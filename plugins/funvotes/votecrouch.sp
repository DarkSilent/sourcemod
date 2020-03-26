/**
 * =============================================================================
 * SourceMod Votecrouch Plugin
 * Provides votecrouch functionality
 *
 * Author: Norm
 * =============================================================================
 */

void DisplayVoteCrouchMenu(int client)
{
	if (IsVoteInProgress())
	{
		ReplyToCommand(client, "[SM] %t", "Vote in Progress");
		return;
	}	
	
	if (!TestVoteDelay(client))
	{
		return;
	}
	
	LogAction(client, -1, "\"%L\" initiated a crouch vote.", client);
	ShowActivity2(client, "[SM] ", "%t", "Initiated Crouch Vote");
	
	g_voteType = crouch;
	g_voteInfo[VOTE_NAME][0] = '\0';
	
	g_hVoteMenu = new Menu(Handler_VoteCallback, MENU_ACTIONS_ALL);
	
	if (g_Cvar_Crouch.BoolValue)
	{
		g_hVoteMenu.SetTitle("Disable Crouch");
	}
	else
	{
		g_hVoteMenu.SetTitle("Enable Crouch");
	}
	
	g_hVoteMenu.AddItem(VOTE_YES, "Yes");
	g_hVoteMenu.AddItem(VOTE_NO, "No");
	g_hVoteMenu.ExitButton = false;
	g_hVoteMenu.DisplayVoteToAll(20);
}

public void AdminMenu_VoteCrouch(TopMenu topmenu, 
							  TopMenuAction action,
							  TopMenuObject object_id,
							  int param,
							  char[] buffer,
							  int maxlength)
{
	if (action == TopMenuAction_DisplayOption)
	{
		Format(buffer, maxlength, "%T", "Vote Crouch", param);
	}
	else if (action == TopMenuAction_SelectOption)
	{
		DisplayVoteCrouchMenu(param);
	}
	else if (action == TopMenuAction_DrawOption)
	{	
		/* disable this option if a vote is already running */
		buffer[0] = !IsNewVoteAllowed() ? ITEMDRAW_IGNORE : ITEMDRAW_DEFAULT;
	}
}

public Action Command_VoteCrouch(int client, int args)
{
	if (args > 0)
	{
		ReplyToCommand(client, "[SM] Usage: anti_duck_enable");
		return Plugin_Handled;	
	}
	
	DisplayVoteCrouchMenu(client);
	
	return Plugin_Handled;
}