Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C7BCCD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 15:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B21DB6B008C; Tue, 19 May 2026 11:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF8B86B0092; Tue, 19 May 2026 11:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E7446B0095; Tue, 19 May 2026 11:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C9216B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 11:49:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30B0BC21CA
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:49:03 +0000 (UTC)
X-FDA: 84784602966.06.C6B50F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3372C14000D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:49:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YMdOb61l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779205741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SIjUr3YqhsY6GcJyYAQQPk+eTDh06lrhqnT+K9RbkdY=;
	b=dG0rZp3K/uMYVeYJjGVv+OdVQY457MCRdeCIwgVBNcayWI6Z+fhct3nWsDwqt+IXzbzD7e
	kkYiEn891+Yb8dm0lxfh8vhJv1w5Wa+K7RS4uuIn3KG2RmoJ3kGIDPwMMZUHBywBr21Sd2
	DiUl+OZzywK3wk3oxs6xfUnCgYB2Dfw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779205741; a=rsa-sha256;
	cv=none;
	b=zWcDa7H9fUJU4SjofqUSBtLHkliQ4zwweoAdNQFO/dPvHfpnvXYUhKV8bmMxrOuV1Zw1mx
	DorMIN54wZTu0KhBuvKibiV6p7Z4n10ecWD4TMesQA3wQL9Q5RffVke0yar5sVl+Kd91+J
	k+L8B1Slj7bEigv1oi/2z1cyZLQcEjk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YMdOb61l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9785A6014B;
	Tue, 19 May 2026 15:49:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7404BC2BCB3;
	Tue, 19 May 2026 15:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779205740;
	bh=BmArmLUFabXkv1FN5bMis9iz2OEPjQisfyx08p2TqZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YMdOb61loSo+TYmzJxw3rQ+H2q7bhA0m4nvzpCWSkkkBRASzRBUH0RDW6JviAUgh3
	 0gfylxFkCJeL5GiKrVcIUE5MNw+GvsftDHC0Kam+HT0ZMntGQT1u/9G1XIfGeM5qYm
	 W0zXLwX456416FGSFdqtblXKR8RLnShbjlLa4b3FuKQTeomTkTcRKdWbFzxteW5ZsR
	 hbaolGCxFd1Rgt2OxaW9l5et7+UggRJaKET0W85BHOtjYMmVsN85Hxv4RBQ9bQaW7o
	 6U+EN8HFYaxe2voKkafM1l53xlt7fmF2D8fawJR5UiXK2SGPPlHGNg8W+GKnFGu43I
	 tj4VxDndWi9Vw==
Date: Tue, 19 May 2026 17:48:52 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Qualys Security Advisory <qsa@qualys.com>, Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>, 
	Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] ptrace: keep task's mm around in separate exit_mm field
 post-exit
Message-ID: <20260519-lehrling-backt-261d022de809@brauner>
References: <20260516-work-exit_mm-v1-1-76bcc7c2439d@kernel.org>
 <CAHk-=wgvUW=1qtJxYcvbA_WaTom6n73nT7S_=7tZd0bo49BNOA@mail.gmail.com>
 <CAG48ez3jeAAvy5mymVkLq84Lf27VyQqM9JkjFYzXps+-jLKMkg@mail.gmail.com>
 <CAHk-=wjxBg4Mb98zjJP95gYsC1kYzzBdtp-Yz+J3ZYD+3HrHyw@mail.gmail.com>
 <CAG48ez0Gz_GghVeVzaixAQRNYBdWHYEj3K6FXBSzc+8WNsFxtA@mail.gmail.com>
 <20260519-gehversuche-lokomotive-cd720c53bab1@brauner>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ej5tgo2oo7zqhnzi"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260519-gehversuche-lokomotive-cd720c53bab1@brauner>
X-Rspam-User: 
X-Rspamd-Queue-Id: 3372C14000D
X-Rspamd-Server: rspam04
X-Stat-Signature: nusod1kdius683pucp7kqz9yi4j4ookm
X-HE-Tag: 1779205741-310693
X-HE-Meta: U2FsdGVkX19BPmFIfap99kf4PjUa6pTZzbccxJffaHs6jqlSFH2SFDvnLh03FmZiKAcaWPs6cd6CWIN4VGF7lCCRtEeNjmaHMpztD0kkyMqvKXuYVtum9Hjc94MMN7P+2s9SswcrXWoXBlx1oadh7kNXsD9QrGqAfJ5gqsCl4gGT/jBPjETZtFMIZRsOVwWsdDYCwrW/AQvXoDADlzozs9egFL0IPVkbsSHjhxpnndGg9sd+ZpOpxtec6UWf4sHXtB1YMJnvrdAYsFuUZ6VfweI0yLRVmuf3/dWDQZ+xrHyuLIxaOV3ipbbnFYqQnjsLrmR1nfiQ7UXOKGJluyhprFobiDuSmH1otQZ9mlriGnON13muafLWiEZM4R198HDhclhJVa6+GrcQafQQ/e/bm3/x0LBuRKVwXj8gAMPvK9r2vO9Bb1qHhf/QMaFqnwupPoUpnfTXWRBUO18a0uPcEhbCZAx4Xk28+x5BcLn9cbWOqxIayMHVHrSIuS+VLC5ag1jVIEodbcInxg75laO4dlfurei9Uz2A9hOSQ0GOBknvo3UaS3VunQCU9VF4DDQeq/J4L1kr+PWY9n+KXn6Ve+sCL0Q6qF+K+oz5LUFobBiVbb06Cj6nYu7suhn16D6l1rM490fIVwzHwtUM1NOv9xsXs1a8JtNGfhUzkfbT0hR6AA6Eouz4V8xbU8y+ZZjzIgrq35b0cAGKFmtiooV+X/KoO1e5O4CuWc6nmIfrZnEkvMaZ11ntmRPWEuRfmy9Af4/Tx8BGQ3h3sx8NsiX4S/f3TQ1/oSLMNIsnP0ygbkHFbLIAlBrjIWKapwP2f5JiOs8HwUtbJ4F0HGIVgP0vTMj9rvLy8yv+umPjMW1fzXgU4ZoFARqoB3jESmNGRxCpsR3FTal1dh5kQvV9uOXy1V1mFeiURIZn4FQvKWg4C7ovja0wuisK8YmkSkcyhJ4L1p1v1iznV0D9BB9IfzI
 w+sFWxru
 AqB7kSS1rYS9y7Q37SAtO2YIhuAGz1UYQV0pHzsN4zWst/6l0E2wI3hDxzeCYScl65lRArUeGuQxu+s90wXuHaF3k1c3A0ukSd1ovI5Dg50xW2XoML3P/Bm8b7PRZNc97qi9ffcUHmHnKQe/Ncr9nLlMLckCUml1MiwKiIOZPhmWybRAMbvkmVvPGkaJAsglcSke8EmYU8J1uX4iQT06V+YYfc6yuHOiYWRIyAsMDDJJEgMbGKYEuohm42BtKxdixxJw+QtAs7Hc183GMOdUc+D5ynkyVzegZIqbWeAfPk85g/41PIaM17D/AITPZaXBLmqGQhjQ0KHO/rAeqoLEXh45Q1xEjCW1TcyC+eQQPUjOpMCAeUjyWWeYvVR4bkYhOVRLOVuWqmFE29xtEs5LyYSySp7TBB141tt/tMfkDUwJDD9UkAgHRzaTYRP9Vr25YFHuox9bT/TQqFc+rK2pIIO5vnGXlCPaVKOy+5aUTDXTbUAodpkXRneRIpXA+6DfQS5eh5w7riC5INe+e9RGbY1hdkVLg3pbiNA2BQ4WumbeduhmRDZhvqiGcSGiAkHSumxS+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--ej5tgo2oo7zqhnzi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, May 19, 2026 at 09:37:25AM +0200, Christian Brauner wrote:
> On Mon, May 18, 2026 at 08:41:43PM +0200, Jann Horn wrote:
> > On Mon, May 18, 2026 at 8:11 PM Linus Torvalds
> > <torvalds@linuxfoundation.org> wrote:
> > > On Mon, 18 May 2026 at 10:20, Jann Horn <jannh@google.com> wrote:
> > > >
> > > > I mean... /proc/$pid/task/fd/$n probably has the same problem, no?
> > >
> > > Possibly. That said, the permissions on that directory changes when
> > > the process becomes a zombie, so it might almost accidentally be ok.
> > >
> > > > pidfd_getfd() is just more severe because it directly creates an FD
> > > > for the file, instead of going through normal VFS open() permission
> > > > checks. But /proc/$pid/task/fd/$n is theoretically also dangerous for
> > > > stuff like anonymous pipes or memfds, where security mainly relies on
> > > > not being able to reach the inode.
> > >
> > > If your security depends on "not reading the inode", your security is
> > > not security, it's a joke.
> > 
> > I mean... __shmem_file_setup() explicitly creates files with
> > S_IRWXUGO, and that is what memfd_create() uses. So the security of
> > memfds in particular always relies on the inode not being reachable,
> > unless LSM restrictions are involved.
> > 
> > user@vm:/tmp$ cat memfd_test.c
> > #define _GNU_SOURCE
> > #include <stdio.h>
> > #include <stdlib.h>
> > #include <sys/mman.h>
> > 
> > int main(void) {
> >   system("grep ^Umask /proc/$PPID/status");
> > 
> >   int memfd = memfd_create("foo", MFD_CLOEXEC);
> >   char cmd[1000];
> >   sprintf(cmd, "stat --dereference /proc/$PPID/fd/%d", memfd);
> >   system(cmd);
> > }
> > user@vm:/tmp$ gcc -o memfd_test memfd_test.c
> > user@vm:/tmp$ ./memfd_test
> > Umask:0002
> >   File: /proc/699/fd/3
> >   Size: 0         Blocks: 0          IO Block: 4096   regular empty file
> > Device: 0,1 Inode: 2064        Links: 0
> > Access: (0777/-rwxrwxrwx)  Uid: ( 1000/    user)   Gid: ( 1000/    user)
> > Access: 2026-05-18 18:24:31.669411864 +0000
> > Modify: 2026-05-18 18:24:31.669411864 +0000
> > Change: 2026-05-18 18:24:31.669411864 +0000
> >  Birth: 2026-05-18 18:24:31.669411864 +0000
> > user@vm:/tmp$
> > 
> > 
> > (Anonymous pipes are less problematic in this aspect, get_pipe_inode()
> > uses the current_fsuid() and sets mode 0600.)
> > 
> > > The /proc/pid/ interface has been around forever, and that's ignoring
> > > regular ptrace too. Files have absolutely *never* been private, and
> > > anybody who thinks they are some private thing is just wrong.
> > >
> > > And being a zombie doesn't even change that - files can stay around
> > > afterwards, and it's not a problem.
> > >
> > > I really think the *only* bug was literally the whole "people didn't
> > > think about mm->dumpable as a security thing wrt zombies"
> > >
> > > (And the entirely unrelated bug of IO-time vs open-time, which we've
> > > had many many times because it's such an easy mistake to make).
> > >
> > > > I think that would be kind of ugly because here, the MM is not
> > > > actually used for memory management thing; instead, the MM is just
> > > > used as the one place we have that stores state that is shared between
> > > > threads
> > >
> > > I agree. Except it is *not* "the one place". We have multiple shared places.
> > >
> > > In fact, I wonder if we should simply just move "dumpable" into
> > > "struct sighand_struct" instead (or "signal_struct"). Those stay
> > > around until the task is released, and they kind of are more natural
> > > for core dumping, since it's about signals.
> > 
> > I think signal_struct is not unshared on exec; so in this sequence of events:
> > 
> >  - task T1 is a non-dumpable task
> >  - task T1 creates another thread T2
> >  - T2 exits
> >  - T1 goes through execve and becomes dumpable
> > 
> > I believe T1 and T2 are still associated with the same signal_struct,
> > which means that even though T2 is part of the pre-execve process, it
> > shares state with the post-execve process and it would wrongly be
> > considered dumpable.
> > 
> > I hadn't realized that the sighand_struct is unshared on execve, I
> > guess putting it in sighand_struct might be an option. (An
> > implementation detail regarding that is that a task can currently lose
> > its sighand_struct while there are still references held to the task,
> > but I guess changing that would be easy.)
> 
> struct sighand_struct is not unshared on CLONE_VM (without CLONE_THREAD)
> during fork(). IOW, it's possible to do CLONE_VM without CLONE_SIGHAND.
> Right now commit_creds() broadcasts dumpability changes to all tasks
> using the given mm. If we move it to struct sighand_struct we break
> that. Forcing CLONE_VM to imply CLONE_SIGHAND would break vfork().

One thing I played with is to move dumpability and exec namespace into
struct task_exec_state which hangs around until the task is freed. This
kind of works and effectively splits the permission related stuff out of
struct mm_struct. The problem is that callers now need to take care that
exec_state and mm_struct are in-sync. And we have various interactions
there. There's at least task_lock() and exec_update_lock(). For example,
mm_access() relies on exec_update_lock() so task->exec_state needs to be
updated alongside task->mm during exec_mmap(). It's all doable but it's
certainly subtle on its own. One advantage one could argue for, is that
this move makes it clear that dumpability is not just a concept tied to
mm but is used for permission checks beyond it.

Anyway, I have a draft of this. Please, it's not pretty and it's a PoC
I've done it so that we can look at something rather than just wave
hands. I don't even know if it compiles.

--ej5tgo2oo7zqhnzi
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


--ej5tgo2oo7zqhnzi--

