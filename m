Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29ECFCD4F54
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 10:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E70E6B008C; Mon, 18 May 2026 06:13:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 570A86B0092; Mon, 18 May 2026 06:13:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487036B0093; Mon, 18 May 2026 06:13:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3875E6B008C
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:13:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26F759280B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 10:13:27 +0000 (UTC)
X-FDA: 84780128454.18.4C62567
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8A67540009
	for <linux-mm@kvack.org>; Mon, 18 May 2026 10:13:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qwKW3rQh;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779099205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dCPqSlgQFv6BdIqxfRR326isBfxWkik3ea/rsVnvQBM=;
	b=W80I6VXS+402UE/+DhwsWi3GXfruZKMQpCbqidpFxwI1WEfjc2qbjSmsI66y+8Y5rgsmwQ
	eR/2ZO3vEQWMCCL1pTpNWloRx1rN+9GVHhKpVYk+m//Wmxn5jyU/R4vDrx+YENpgftDKEb
	Df7NV2pT5NXMnE8JQgdLk6BJxrYuVRM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qwKW3rQh;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779099205; a=rsa-sha256;
	cv=none;
	b=1NsKQ6RAjt49OJvyT5mOxWPmPXMV4Ra2Ly3koDJ1aTmTTp0qN9PEng6fk1FzI6hZb+DmWD
	GC/q9sdlKLLFGnS+ALCSuVu4EsQFHO5iWpTQUnydbtJ+gv6o2nuwntXf6U3Jg8ylk9WgUv
	y9O0r2HJEKdTCaX0gSxUbPZrcaBeab8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DDFFA6001A;
	Mon, 18 May 2026 10:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0DFC2BCB7;
	Mon, 18 May 2026 10:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779099204;
	bh=AQneTqU2WjWy5WuAxxdRDOEovifMPzhrmkykBj8ZD5I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qwKW3rQhKBH8cdlFDdj3odVBujABo+7iuXPrB3HlcTJyS9yZd1aF8qQQxCYkJbcvH
	 2LP1+9jI7/NU9hSqOO/uLXqxvsP0+wD5pOF2QKscstWgx3IZ2lMKuMk4mCQ1W4h2nE
	 Ext8/sLcftJbD2vgZ49PlJNWUhnYcx7P6oIFg93xeyDwUqDqFR/CIajElxxYkmfM67
	 CoqB/Bs6k+Vjad8QDB1f7H432fTcUyQQlB/NA2VkA6Lm/dG6CbE19xLo2iqYxoL4ie
	 bK3hY6jJtEelOj+ZVQGCfF9jBqcutbpbQ3bcvp5N6GtRaYCDE02aKfx+SpOQNZ181s
	 FCIAi3I+131rw==
Date: Mon, 18 May 2026 12:13:18 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Qualys Security Advisory <qsa@qualys.com>, Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>, 
	Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] ptrace: keep task's mm around in separate exit_mm field
 post-exit
Message-ID: <20260518-obgleich-petersilie-2d77ccccf9b9@brauner>
References: <20260516-work-exit_mm-v1-1-76bcc7c2439d@kernel.org>
 <CAHk-=wgvUW=1qtJxYcvbA_WaTom6n73nT7S_=7tZd0bo49BNOA@mail.gmail.com>
 <CAHk-=wi-5WSdzg_UxAFSRtjTUfscATJ8+1R3Pqvw8=-KKLmQCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wu6enxnrzjkfmb2m"
Content-Disposition: inline
In-Reply-To: <CAHk-=wi-5WSdzg_UxAFSRtjTUfscATJ8+1R3Pqvw8=-KKLmQCg@mail.gmail.com>
X-Stat-Signature: ig6d3aeieczut5den4tsqeea5er74xjz
X-Rspamd-Queue-Id: 8A67540009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779099205-756497
X-HE-Meta: U2FsdGVkX1/kbGePEOl6QgtfSuaa46fBddJiW3AE2SD5chCuPuqbR3Qzcpxkn97vqPkXFVwz2uKDNjHUPgA2rzKjm93roiPIjF5gSvfZtOo3U6Ph9jPsbNr7LxsnWCmamAKXJxPJ22bSxkccpwuLILUvBiYuXrGHhSZQl9tEE+Xgh7HfXdjDk61jBmTO2weZFe84cT4lvRRM2r6YGeNe95LzZ71SVtL4+ecbt7OXTYMAA49LHytydj3J3q2ASQLvuQFCOFTT+aD8jVGO6Qbxb/rEUNW3Cxp8Q8LN1XvmKlApxS+PYoCXZPh6Y1T78geULn0f9lbIbMDwvHMKdZUK+tPSpj+keI7e5CNU5N1C5xBdM891lb/xRiaBRIeSwxwlrNmGIsba0XJBnPQ1lhoqXJuoh5w3Q+10PJllnPWV5NMg2cZfBZMLj6gilU68Z9yGso2toNAAfjZAzZ4kTF2hjeA9rX8RyZeM6Ao5m/tDBfJNqh6cm/4wjasSDcq1rbDvGh9xrj9JAeIci/7OUOD3KTpj0q89EhMWaSLsyNH/jVaoQZxBLNO6y3W/Ma1DoVcDKntGJAyRUoHO3ZZutO2Nif138U4ylzH5sGRTrdp8O/5sK1Vap3Lfe0CPkagLa3x83FHKX40IO1Tuf950jM2ExxI93nuyAjRPYoO9Mko91FjPtXi33ArMe0Rk8LCWtqQVIwARap08YWYUgEsTkLoehbsnr/F/1XAjzSKl0599nbCKhJOxsAnLnPhDWGiBcjdJn5m+6VhOmRNxCjOFVQPhFw6CWzQ5UQ1/CXlaCGGjQrwDjh+3bCpXZb0yiL+BV3QG4ca6J3laGlRo3Tz2MldzyAPlZxxGqdkWXR17PC1WMGJqUWYZiw9f3Hvxrr5wUXcjExQj+KrUBZa+xrTR3/NpyXuSEe7OWdpWTtK4waDb05PT1r3y+MhKUCBMxKdoDqLng5uMsx6/7rXstg5sS+f
 NUOrpNCr
 7lQkERuw8c2fqzL0b+H0tc54iAtV0SUxkCZ7pgtNr4xyFR/GMN75kDgyU54C0zswslVboN59GL6v/Jo2z9TMswmOw881zyFyZq3RG9zZTp8Ge9U3v+Rtt5tuoUuLvvLVRQW3EwhHhPUV62JBRYTOPAMIMQFBcprLuk6qIW78bZ/yF1YZq90OTpau6wnvunCGoxQyms5RfqYA1rv4fmzcOcQiehCrEasG0FLdsWsh06BXklSbgRSZCFo2GgBEGWICSmaMMSwPtW0aWB0jNFAA/CXL3/XZ4kvnzc0eneqLmQqQkMX+S4Avy0LdUHsopkcDuRqc0MualqhQuy/iyA20T4B3nLCM8YzvATouKrMco20FmD1S9x/G+/Ps5GDO8e/3sTbSRBJliAlkRlh7I+sc7pANqqkm/e9V+KrccL+9eHSTgQGpyohW0wIHa/U3THd7xP5LHFPKsVLxnzOlJpBY0KFxtHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--wu6enxnrzjkfmb2m
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

> So the problem really is ptrace_may_access(), and that thing needs
> fundamental fixes. We should not add exit_mm to try to paper over the
> real issues.

If we can improve ptrace_may_access() in additional ways I'm very happy.

One thing that I would like to mention is that forcing callers of this
api to reason about post-exit, zombie, or mm behavior has potential for
a lot of subtle bugs. Dealing with mm sharing and dumpability
implications is rather subtle so I think doing it within the api itself
would be preferable.

I've also appended a patch that makes pidfd_getfd() check for exiting
tasks after a successful ptrace check. Please do feel free to apply it
directly if you agree.

--wu6enxnrzjkfmb2m
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-pidfd-refuse-access-to-tasks-that-have-started-exiti.patch"

From c64938bbcf9f473db0e95b714746e57b03efc334 Mon Sep 17 00:00:00 2001
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 18 May 2026 10:32:11 +0200
Subject: [PATCH] pidfd: refuse access to tasks that have started exiting
 harder

The recent ptrace fix closed a hole where someone could rely on task->mm
becoming NULL during do_exit() to bypass dumpability checks. This api
here leans on on the very same check and so inherits the fix.

But there is no good reason to let it succeed at all once the target has
entered do_exit(). PF_EXITING is set by exit_signals() at the very top
of do_exit(), before exit_mm() and exit_files() run. Once we observe it,
the task is committed to dying and exit_files() will release the fdtable
shortly.

Fixes: 8649c322f75c ("pid: Implement pidfd_getfd syscall")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/pid.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index fd5c2d4aa349..f55189a3d07d 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -885,10 +885,12 @@ static struct file *__pidfd_fget(struct task_struct *task, int fd)
 	if (ret)
 		return ERR_PTR(ret);
 
-	if (ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS))
-		file = fget_task(task, fd);
-	else
+	if (!ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS))
 		file = ERR_PTR(-EPERM);
+	else if (task->flags & PF_EXITING)
+		file = ERR_PTR(-ESRCH);
+	else
+		file = fget_task(task, fd);
 
 	up_read(&task->signal->exec_update_lock);
 
-- 
2.47.3


--wu6enxnrzjkfmb2m--

