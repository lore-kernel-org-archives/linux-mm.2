Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D31C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:45:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D05B6B00E2; Mon, 21 Sep 2026 09:45:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881136B00E3; Mon, 21 Sep 2026 09:45:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797CD6B00E4; Mon, 21 Sep 2026 09:45:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49A3A6B00E2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:45:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25E4B1601A2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:38 +0000 (UTC)
X-FDA: 85237891956.02.09A0471
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 69D47140007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TpW5IZj4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uDFVbgvJ7xnyyLVrNwCFS2r46etfsHvtzm5ZhTttIBA=;
	b=bBNM6V3nND5SUHgliqRCrTCQc6X3Zj/OWTIGt2tJrWS1fIC/VnsUBHcVd065Lmun60CyQF
	YUsi+eCJunA3t8EEhpllYPl8oxBUm5lWBMe+9jV5R3GFPq5o7q1HtR6Au5p8lDQoi4vLKW
	cD62YXdKQUyrvA9EFFyOzCrkzxWIKqc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998336;
	b=Z+A2iqyu8VO6iou5+VkGlqJSxpDwc/H/Wp9ajliKl7ZXRPjrAJRVsKKeHmVLlmWTWWKA4U
	lIhRJER+7i/vy5wV43+6mMC7lbheqn4/wp3w9Bw177kqCPl3jPwgq0lK/5afyRr+kHLOva
	WU/DtOCQrj7lVVYg5l/MW2pOzBUx4pQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TpW5IZj4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0975E600C8;
	Mon, 21 Sep 2026 13:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00E71F000FF;
	Mon, 21 Sep 2026 13:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789998335;
	bh=uDFVbgvJ7xnyyLVrNwCFS2r46etfsHvtzm5ZhTttIBA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TpW5IZj4rtYbO7lCDv8Q6KmiwLq6HAR/i7W+BErM3FKlJkW9OaOgQ707omWL5/9c4
	 +a+zAPvP/tEereXm4zwjqCcpCdDjeR2RAKNJwtSGPDSHOgpBeDJk3dZ35ATe5TYLgw
	 JtCoRGNNo7surhqgOFk6ZKHHjPqUqG6iM03saVORaEWzSuRGzm+f6rntLQpohhO5lk
	 DZeFDLIQJVmGJ8zboy58GmFMnxLG12Y05OGTDYdkyrf/mVY0ADLwtjhy9geyg0lXJY
	 lucpjqfBpxI+SB8HAwHkFtaKBFFMIY/zE4PBvgeOyDC19ROAoH/Q5DnDZ9cJLR4GwH
	 6SDoGwz2MDDSw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 21 Sep 2026 15:44:57 +0200
Subject: [PATCH v3 08/17] exit: hang up the tty before closing the files
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-work-coredump-fixes-v3-8-8e4adb1619e6@kernel.org>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
In-Reply-To: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Chris Mason <mason@kernel.org>, 
 linux-fsdevel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 linux-mm@kvack.org, io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=2967; i=brauner@kernel.org;
 h=from:subject:message-id; bh=7KUzGKGrk7V1HZ7iUNzf5pjBye0tThbmUGx9Q6GKXVc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRtNLnz5PgfRi+mGLtds24IJjJ2zdO/ldP6upLXrjXK9
 4IO30/3jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlU7mNk2Hn/cfH6PMsnjzZu
 Z43iicyXNSx6ocTyvXH6D1mHgF+RCxkZTh66purH4RJ4qev/Df7YfaHL+aJURbjExeQkdJOD1r5
 kBQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 69D47140007
X-Stat-Signature: kzbj9seykhpqk3ps5yqpu5nbxyibnwui
X-HE-Tag: 1789998336-907879
X-HE-Meta: U2FsdGVkX18nxUHxcKMlVjtGsoq56Lob7RJgVahAo/F1v1QKWMEB41d+kItENOwBeMrlf/81hIBLpAEmNcB4cANPKj6B7UmpBpOE1qZtdT65xW1goUbfdOBe0XCBPXz4PfU4OBdNE1gArdDzw3zg/YjvWXuNAunwx78vfv+5MkEgurLOuHI4j8HVOZA6ifEkhSvxbkWBdasOKdmhYj1F804X4hizjTVvB4pC9tMi1S4TE2TSuun0fQZTMjQhzTTgOt1j4c6sY8D8E3tVFG8i57klbXlBnr5nDtlgDcDDszHP5hOyXyRXlhoiWYxBZ1tqQflkFt/0TZZfRs31VP3PmBsR8AZIcefBbANo5syyiruI89mXjygfZe7qrSI9Yccogn1T7NaiLtD4wy2P6+fizCXp9wYt0uAntfUhtrg+yj7gAC/fs79Kb57bbrkKi+XiNN1tOy1OMrK2adJB7XJLRmDpjpGFpqNU4g1mmVsQLuoEmRMuq4bYueewq9zxYJ4ytlHqBVnzLmI6w8tBWttQrdl8DFKl89MGAcKbUQ2fYB0pgQLd/2WLHuPYKXaUAzoPlR5VtHsoDIbL4zW//jOJmY7Ciz5umSG50yeZFrt5sI6IHhgArIJ156BTm8oCtkW+CyDw06VzDvDb60EXCHaCNT7zlkNyTuCdgemJRH5jCYPDz0ZadhGM2wov4rUfl0EJEoQKc2RPm831HGTrVEFia2kbwSx8t1FcWtO1Lyx+KAKy+RzbhMmHyNhKA4zwFZXXiRhB/YeVXKJkeRCPXq3Ka0uugPosVsXH1rK5Ueo5xzesWYAnoRyyRGc4APRBOSjz65ymehnrSZC7Y7mqZtZg/cWPaFalmwZP9Vk/4p8FETNbsWnxwd6yX9XLID7Vm2Tvfvg1GZvtIMDaRTtXolXf1OxEZ4fMV9pvYMI9r4cRTd4GSxXWWoxJ+AoNygUaFXTjQahWBUIazkVlQr54n/7
 u1Ydh59a
 M6kpLJ6TpaBx+zkogJIHyfynWVtMYK4LldMYINpXhalfKqPEngXjVhOyNUbEElj6CkYBoFoCArcrsZAslYEGkmir2HddB8ecLzxc3jY2817l6RZ5Sqg3d/LbIIvqo8CUy3Rh+r4TnHLMIKWME3v3/mxATP3h7STIyv2hNhwZ6BmIlTaQspB+h8Bl3mnIK6/K4N29syJi6MYgVkcOwya9gMZCVYlDR6DHTi0RB5sGK2WgEf6dK7jJn1hvHeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

do_exit() closes the task's files in exit_files() and hangs up the
controlling tty of a session leader in disassociate_ctty(1) after
that. Since commit d99d38540bf0 ("fs: make close_files() synchronous")
the final __fput() of every file runs inside exit_files(). So when the
session leader holds the last open of its tty the tty is released
before disassociate_ctty() runs. tty_release() clears signal->tty for
the whole session in session_clear_tty() once the count drops to zero
and sends no signal doing so. disassociate_ctty(1) then finds neither a
tty nor a tty_old_pgrp and does nothing. The foreground process group
loses its SIGHUP:

    do_exit()
      exit_files()
        close_files()
          tty_release()             tty->count == 0
            session_clear_tty()     signal->tty = NULL, no signal
      disassociate_ctty(1)
        get_current_tty()           NULL
        signal->tty_old_pgrp        NULL, nothing sent

That only affects real ttys. For a pty the master's open keeps the
slave's count above zero. And it only affects a foreground job that
holds no descriptor to the tty anymore while its session leader exits.
Everything else is unchanged. The DTR drop on the last close happens in
tty_port_shutdown() regardless, stopped jobs get their SIGHUP from
kill_orphaned_pgrp() and signal->tty is cleared either way.

Before that commit the final __fput() ran from exit_task_work() which
comes after disassociate_ctty(). That order isn't old. Until v3.14
exit_task_work() came right after exit_files() and before v3.6 fput()
was synchronous, so the tty was always released first. Commit
c39df5fa37b0 ("exit: call disassociate_ctty() before
exit_task_namespaces()") moved disassociate_ctty() up to fix a pppd
crash and in front of exit_task_work() as a side effect. The hangup in
this case has worked since then and that's eleven years of userspace
being able to rely on it.

Hang the tty up before closing the files. This is the ordinary hangup
with the file still open: __tty_hangup() swaps in hung_up_tty_fops and
tty_release() runs from the close afterwards as it does when a modem
drops the line. disassociate_ctty() stays in front of
exit_task_namespaces() which the pppd fix needs.

Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/exit.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 55dbea3b242e..9ed5eb03d0e1 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1003,10 +1003,11 @@ void __noreturn do_exit(long code)
 
 	exit_sem(tsk);
 	exit_shm(tsk);
-	exit_files(tsk);
-	exit_fs(tsk);
+	/* Hang the tty up before the last close of it can clear the session. */
 	if (group_dead)
 		disassociate_ctty(1);
+	exit_files(tsk);
+	exit_fs(tsk);
 	exit_nsproxy_namespaces(tsk);
 	exit_task_work(tsk);
 	exit_thread(tsk);

-- 
2.53.0


