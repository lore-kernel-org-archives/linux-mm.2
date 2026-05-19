Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3512CD4F57
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 07:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E9C6B0088; Tue, 19 May 2026 03:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF38A6B008C; Tue, 19 May 2026 03:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE27F6B0092; Tue, 19 May 2026 03:37:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CB8C46B0088
	for <linux-mm@kvack.org>; Tue, 19 May 2026 03:37:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B95B401B0
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:37:34 +0000 (UTC)
X-FDA: 84783364428.19.D597EEE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id C37DF180009
	for <linux-mm@kvack.org>; Tue, 19 May 2026 07:37:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nRi5sAV8;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779176252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7n1uwx3LIjBjo9SOdYsSZ6dYusUYrk+7uIBrjO2d4Q=;
	b=rc9w3ra3H42arQ8kS/t7qNozhynm8TXw5UCYtmsR10FYV4tgITqzVg6Eg4tVA+iZuhQAEY
	H1JcV5T+DNhYXXlOSEnm2zKVd3k2hkLYN8LvrBNjvooPeSvJaad+ybYJvhMfsNsz9tINwI
	IyC4UMs2jU6IcEHo14FvMNLHTAZ+9ps=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nRi5sAV8;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779176252; a=rsa-sha256;
	cv=none;
	b=8NkyK8/OAJCljs/JTZNuNADytBfcL6WoD/VWPFknYY49+WinxXA5y1dyEojit+6CalyMU7
	6TWpZYAJhp3+rH6uIYs71a6SduCUTJgVkzLgS+OgkYN+COuLyY+lKtS12BgcHmNqXDBjxT
	bGb1UGwfbpJhaPPkR80fPo0yH+aZAk0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 35E756020B;
	Tue, 19 May 2026 07:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC8AC2BCC9;
	Tue, 19 May 2026 07:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779176251;
	bh=fkFPHH8Hwthih9xO706d0W1LBmGMYkEa5LnsmoqZSYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nRi5sAV8zWXUXd6aF16BSAQn/V7t1LwiM4AmJ2/tFlH/4CmchiQZNU1j9lsw0ESqx
	 iCLhEaTnteltFsp3mZiKMut1GcYMzsXROYduPhBOQtYbDXRExzA/zvOYe+aHFs67BH
	 J6ulQWOB+OT4WrNDV0UvJPNVyycndUiMkCCvjt2vb7Q+sID07BKDVRNZHQ9m+HTpoQ
	 obGDiPZbrlP2fWiCpW7H/lwB9VaYqkliNasczcFWhg4vkXf+UST+QcbDOxySYh5fXb
	 s0EOwLmVsReyq8/A7YphoIyCajr004WqQVgnFfq7hms5u6WyfFvC5I6bSfkACHBMa1
	 1RyEuq5YJWe5Q==
Date: Tue, 19 May 2026 09:37:25 +0200
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
Message-ID: <20260519-gehversuche-lokomotive-cd720c53bab1@brauner>
References: <20260516-work-exit_mm-v1-1-76bcc7c2439d@kernel.org>
 <CAHk-=wgvUW=1qtJxYcvbA_WaTom6n73nT7S_=7tZd0bo49BNOA@mail.gmail.com>
 <CAG48ez3jeAAvy5mymVkLq84Lf27VyQqM9JkjFYzXps+-jLKMkg@mail.gmail.com>
 <CAHk-=wjxBg4Mb98zjJP95gYsC1kYzzBdtp-Yz+J3ZYD+3HrHyw@mail.gmail.com>
 <CAG48ez0Gz_GghVeVzaixAQRNYBdWHYEj3K6FXBSzc+8WNsFxtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez0Gz_GghVeVzaixAQRNYBdWHYEj3K6FXBSzc+8WNsFxtA@mail.gmail.com>
X-Stat-Signature: 84635xtwyccefputahwzud1qd6cndxxj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C37DF180009
X-Rspam-User: 
X-HE-Tag: 1779176252-973780
X-HE-Meta: U2FsdGVkX1+BHyJwf8tm20J3kSbSaLfhk3zxQsVG3arRMIEffqgkgNHxaNCWcaBkcczTLuoeNFKzrw6MHy5LG0ZY6YXtHmxOFLnToem2QTSnL1U2yUbGOgdzpOsTKnrsDtTteNq/eFpyK9amJzoLaiRHz5tw6fHvqjnlrJLYWQ1ZJ7YlAfmtqTTWuk4/FflSXBkm9LgLndbEvh3dOltVqz0QwiuR9+F0Eq+A+S9/uAmmMKaL/U1PzwZtO3/l00vPRuGCwV1KrHsYuCNomS4/uxYDGv5q5KK+K6iis2GM930b3cNcia/CbE3WTUNWTEJTICWDl8KGmPsir9HLH3XaZAmZbEmpYth0+wLBoLMmVnpj/1uh+h2mxFGbCzJJTDXedPDeO0mPIy/7PwWI5TXFgnIpxO9mBJMTMQ4Lnd1DsME2gjDU0Tn34Et1uugQKFaNstbYi0Qoos27EopI8sZbKbf+9NLpwra0rSjFEsbla9+4O6Q/qkxr1V+9XAUmWfCbxXR+llaAu80s+nGxIYmlsDEYT7djqX2ZC4CaQDMvRFGq9ReCjWDSXnQodf4+ahcixyf2negCHW3vRVO5LKj1/AYqMo1FYhUYMCrhA2ikeFZLtLt744EsoTc+BWhagvZqyRheMGKB9+CkVzG0KzUJB4z4dq9fw5+A5ftmjUlweSSDA3v5Jbmk6jwm3+jB5xuTX7E5wfPuPotI30OOq3KmYbERHm5Vey9phzPhgnNrNW8SPXBTs+OfsfoBUBgwDK6K+xg8OWtcGJMQxFYkxm3bUoZhpoLk+hMTDw4LkKnM+0FNRoUpWPq6/HjV3DNRei4AzpXCSWctRi9b1QWj6u4C3rdzeTXZHravKw8JAUH1P94Zl14VENEmzoFAJFihOQlTkTBYh4V1wNcQB5mxs/8hTz2O6pMO8lRckQCigM+KV22AoR6XfBRVI6w4e5Jhkf4RpHORRZiI6XYZqnMDCPy
 cLcQ+VAZ
 /7UZjoTyvx7Dq+Cg1tkl0M4xUUPF6qKvPG2fn0lRdxQ/0NoptG0gj7XXGGgj2sMnpiOyzkdxeX/3SzeRWACTzZEM5z37IKk/YCVH+ozN3PRGOcDcKENLk1Q7Tuolp/jinjC+PpQHjy9yYkI/DAyrDQWGuJsHuWuNkyUaKS0ERIzAp3cPiYh1l8C4Gdhmx2UXAIAiuwYmfdSUXdL0pF2oa0fUphKSsr7DH2KwEeWt2+p84ASPZT0sLO2z6M/z/DlWZz8fVs3tyFUMiJdBmsk1vGQNpPMiIcVwboY6OuTT+wJasRD4Xgr5pwKh5dlGtQNspWPIfKscUycTfXquP0Oda/eaK3IdE1y79IY5zIuNv0209M/rrvYj5knoT+jDyE8J7WSqW3IGUll3eR3CfcfEUEwgEdxYVMlR8+h4w2VKU0JpyXuIXN4Sqay/t4F+aPQpyEft+KK4hw9GatGA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 08:41:43PM +0200, Jann Horn wrote:
> On Mon, May 18, 2026 at 8:11 PM Linus Torvalds
> <torvalds@linuxfoundation.org> wrote:
> > On Mon, 18 May 2026 at 10:20, Jann Horn <jannh@google.com> wrote:
> > >
> > > I mean... /proc/$pid/task/fd/$n probably has the same problem, no?
> >
> > Possibly. That said, the permissions on that directory changes when
> > the process becomes a zombie, so it might almost accidentally be ok.
> >
> > > pidfd_getfd() is just more severe because it directly creates an FD
> > > for the file, instead of going through normal VFS open() permission
> > > checks. But /proc/$pid/task/fd/$n is theoretically also dangerous for
> > > stuff like anonymous pipes or memfds, where security mainly relies on
> > > not being able to reach the inode.
> >
> > If your security depends on "not reading the inode", your security is
> > not security, it's a joke.
> 
> I mean... __shmem_file_setup() explicitly creates files with
> S_IRWXUGO, and that is what memfd_create() uses. So the security of
> memfds in particular always relies on the inode not being reachable,
> unless LSM restrictions are involved.
> 
> user@vm:/tmp$ cat memfd_test.c
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/mman.h>
> 
> int main(void) {
>   system("grep ^Umask /proc/$PPID/status");
> 
>   int memfd = memfd_create("foo", MFD_CLOEXEC);
>   char cmd[1000];
>   sprintf(cmd, "stat --dereference /proc/$PPID/fd/%d", memfd);
>   system(cmd);
> }
> user@vm:/tmp$ gcc -o memfd_test memfd_test.c
> user@vm:/tmp$ ./memfd_test
> Umask:0002
>   File: /proc/699/fd/3
>   Size: 0         Blocks: 0          IO Block: 4096   regular empty file
> Device: 0,1 Inode: 2064        Links: 0
> Access: (0777/-rwxrwxrwx)  Uid: ( 1000/    user)   Gid: ( 1000/    user)
> Access: 2026-05-18 18:24:31.669411864 +0000
> Modify: 2026-05-18 18:24:31.669411864 +0000
> Change: 2026-05-18 18:24:31.669411864 +0000
>  Birth: 2026-05-18 18:24:31.669411864 +0000
> user@vm:/tmp$
> 
> 
> (Anonymous pipes are less problematic in this aspect, get_pipe_inode()
> uses the current_fsuid() and sets mode 0600.)
> 
> > The /proc/pid/ interface has been around forever, and that's ignoring
> > regular ptrace too. Files have absolutely *never* been private, and
> > anybody who thinks they are some private thing is just wrong.
> >
> > And being a zombie doesn't even change that - files can stay around
> > afterwards, and it's not a problem.
> >
> > I really think the *only* bug was literally the whole "people didn't
> > think about mm->dumpable as a security thing wrt zombies"
> >
> > (And the entirely unrelated bug of IO-time vs open-time, which we've
> > had many many times because it's such an easy mistake to make).
> >
> > > I think that would be kind of ugly because here, the MM is not
> > > actually used for memory management thing; instead, the MM is just
> > > used as the one place we have that stores state that is shared between
> > > threads
> >
> > I agree. Except it is *not* "the one place". We have multiple shared places.
> >
> > In fact, I wonder if we should simply just move "dumpable" into
> > "struct sighand_struct" instead (or "signal_struct"). Those stay
> > around until the task is released, and they kind of are more natural
> > for core dumping, since it's about signals.
> 
> I think signal_struct is not unshared on exec; so in this sequence of events:
> 
>  - task T1 is a non-dumpable task
>  - task T1 creates another thread T2
>  - T2 exits
>  - T1 goes through execve and becomes dumpable
> 
> I believe T1 and T2 are still associated with the same signal_struct,
> which means that even though T2 is part of the pre-execve process, it
> shares state with the post-execve process and it would wrongly be
> considered dumpable.
> 
> I hadn't realized that the sighand_struct is unshared on execve, I
> guess putting it in sighand_struct might be an option. (An
> implementation detail regarding that is that a task can currently lose
> its sighand_struct while there are still references held to the task,
> but I guess changing that would be easy.)

struct sighand_struct is not unshared on CLONE_VM (without CLONE_THREAD)
during fork(). IOW, it's possible to do CLONE_VM without CLONE_SIGHAND.
Right now commit_creds() broadcasts dumpability changes to all tasks
using the given mm. If we move it to struct sighand_struct we break
that. Forcing CLONE_VM to imply CLONE_SIGHAND would break vfork().

