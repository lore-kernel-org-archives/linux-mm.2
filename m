Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EC91CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 22:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7086B0096; Fri, 22 May 2026 18:09:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86FA96B0099; Fri, 22 May 2026 18:09:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7604B6B00A0; Fri, 22 May 2026 18:09:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6167B6B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:09:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04855161A91
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:09:17 +0000 (UTC)
X-FDA: 84796447596.07.98E1C67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5B55240006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:09:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WBld1bOX;
	spf=pass (imf27.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779487756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yf2vEzlZ5+p+ATp9gN007KI2Z3fmEmZMNNzYlyeFYlA=;
	b=o3z9TKnGzopiYdathlpnsfFm0L0jlSZZET0J/Gd4zdZcfjKMzTvcK+b4udvQke0o5+qAnZ
	auNmFdyCHO4XF6znUym9i3nHbkhF4C0ccAkG/NSEI9PMeyVYF1dnHXwFy/uXda7fY2Nn0h
	2qY9k2Qu2aUF5V/QqYMUAJP8GLRFIqw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WBld1bOX;
	spf=pass (imf27.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779487756; a=rsa-sha256;
	cv=none;
	b=JpMgPZxgJb5be+1YjPOf7GTr6S5646T10ZVEqPge2gTYOImCgHDBNndRKIcRFgRR9SwSEV
	2RZz8dUBEH5oc4c5bLIfkH6hcW2hlLNmTafyT9FRoHM07dnx5Qmddn6HSvFlUl7CGef1ww
	61JGqpCQsFvydMBBC5V/FHXEKBQ/D3I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 845B144523;
	Fri, 22 May 2026 22:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2081F000E9;
	Fri, 22 May 2026 22:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779487755;
	bh=yf2vEzlZ5+p+ATp9gN007KI2Z3fmEmZMNNzYlyeFYlA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WBld1bOXzLJCq3Bw17JrbLFuzGPxIszFTxGQZb7z2lmiU9Yypj3FKG+qWRywZju1E
	 1KFiWIMGtBflx9SOmTDgX3R8s4+pRHAbVCL23cYXsXSH2sKGZHgvJ+c23rK4KUtEnQ
	 X0jyv7P1SJbMSGE0AkbgLLGmXbchgiiCXhbMB9HgGtnMgypiKJ7wrnZPfi/gdS85Ub
	 IvnMYD7XSMNJgsuaQOr7jmFJCX9Gx70hwE5KwfdcQZQAMmHs75Xl54nZsjFiNBkkih
	 YaCxoRJdA4T8QLKEF2LX96hQDjsC6L3vUfRZ3T3ZHMmG98DWhTYjK/GYx3y3Ug9Dyy
	 e1GjUdLcRwIaw==
Date: Fri, 22 May 2026 15:09:13 -0700
From: Minchan Kim <minchan@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>, Jann Horn <jannh@google.com>,
	akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, mhocko@suse.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <ahDUCbo4fIKA7rMZ@google.com>
References: <20260511214226.937793-1-minchan@kernel.org>
 <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
 <agd--WZpeTq2iKFW@redhat.com>
 <agefLhQeWpvil14M@google.com>
 <CAHk-=wiHfzbufXD2nuc9BhOVp-pYEmnVUYeThKmfZRXLU0kJ7w@mail.gmail.com>
 <aggE2haQ7yGeHPeF@google.com>
 <CAHk-=wg08=sZb=hVa22KjN2pD3aNk-diGmKQnizCgmoMMfrvwQ@mail.gmail.com>
 <agzNyXKIirm1zOob@google.com>
 <20260521-voreilig-investieren-34f6e0c56258@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521-voreilig-investieren-34f6e0c56258@brauner>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5B55240006
X-Stat-Signature: y93x78qsyx9zoceoobtafbdnf6bjhzk4
X-HE-Tag: 1779487756-130451
X-HE-Meta: U2FsdGVkX18k8JHRFL57Bn6WnHCZhMoXRYp4AD3ByeIVsxbJbsxES+NafNwduDKxW+QXS9gOB84COiEEGUtyDPm3sNHOZvifhepQ/aybMWY5C8pPDptOHRwHZAy6NMW7xN+FU81r6ei2Sldfgzo9z8PcsuV1B78T+466GJ9ZDzqEGZ3q7P5RkAIVaKy3YYCOIA7DbFIZ0u/+fM4z1sN6k0M+9zSpmw69sIPmwtLvUDtBZoLLOTNkDtOhcsNmDATh2RutW0t+Gtvrn/qQvt5MiQYGwDKBPZtukpLQV4m6AiB7OR4PY20xW44sC8BbWVmOwKnG8u7N+KOzXe6VardMhiQdf8ksqFBwfADr8MJTqXg0FA8U3vJRx03oBtkC0MqUz02P5S4j09bH20opid7LaXlFL+c4sBmu/CxXHxLXJxD+z/fLEtDF6sxkZiMec+sKG+V16ObTY1Jgco0Ur5v7S6af+ADOM0+SLRhRHxAoe48SK6hsAN/XMeLfnhq74dO2N4Ga1vni4vgjidII/GOsTnjPDdRaWEo/dDR9ivHdU3r2lcopDFCB4lPLw1DcCuMXeBHNsQpsvOCdM0cZQjqT4ravjXhJF/AKNtIwA36X7ZZkJ8DvQiAKg6KfwkHSpQ7OJodvG+/PVV3sFpbUFbHU81hJdE9nnLNO6RdAjyb2Yng6LVAYd+oSEMm2Wb8O6KAIQNgsfj5l9RP2IXEjHGj3XkLE5vleSkD/3fW4ubUPnzJzZcG3ypbp9zUoFmT6TRAoghnMMZz4ERBw3h2VHdFHLssss6zV1oCAA6AEZ2CRL/uJik5nN2RW3vhBKYLk9t7Hwnj7OFVg2u+WBK4t40dPhe2eAWRgapwcKgWRfF0Nnr1Da5vyUqGPKkVahVO48FgsC57xVMocFEUJVckOn4r9dGTTyr+Q3aANLGE+Y7B1V/LM7rPZWWBcR742z6xIISHvmGZjdhI59q93E3ZsJbp
 lOFPRaBZ
 WLCGunVYJzzsWBl94cL6AMZwdlmaQOYR13YDoz5LeluJ53dRBj7KwcXbwoCIPtkveZDOl5NL4qQQgiDK3cl/EjflHMiGK6TBmMZ3h/qETfj1D4J1ETefFv+de7z+n9T/Acc+JYlZjfx6HrbFgVb3fof+ZQx3V9DhdJ1dcNKz/QqeMuZS6Y+UtP0EWNEqXV1ao0KMmSiLzsjwFIi/Xx0iiErUHgyL3rbzldzUCKKQjDYU7kA5b7BCT4koIcWZmLBP2nHELcxrc66+PFUcja45R2AX7ps4F2lx4WRFCilYnGKroIXZ1sw2c40dRbIgVatrLOZ3N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 01:50:44PM +0200, Christian Brauner wrote:
> On Tue, May 19, 2026 at 01:53:29PM -0700, Minchan Kim wrote:
> > On Sat, May 16, 2026 at 09:31:04AM -0700, Linus Torvalds wrote:
> > > On Fri, 15 May 2026 at 22:47, Minchan Kim <minchan@kernel.org> wrote:
> > > >
> > > > Regarding proc_mem_open(), it actually operates very close to what you suggested.
> > > > It acquires a reference to the mm_struct itself via mmgrab() but immediately
> > > > unpins the address space memory via mmput(). Thus, no long-term mm_users
> > > > reference is held across the open file descriptor.
> > > 
> > > Ahh, and we've actually done that since 2012. How time flies..
> > > 
> > > > The latency issue occurs during seqfile iteration (m_start/m_stop) in
> > > > smaps/maps, or during get_cmdline() and ptrace_access_vm(), where the reader
> > > > temporarily acquires mm_users via mmget_not_zero() or get_task_mm().
> > > 
> > > Ok, so it's that much smaller region.
> > > 
> > > How about a completely different approach then - make exit_mmap() just
> > > take the mmap_write_lock() properly, and allow walking the vma's
> > > without ever grabbing mm_users at all?
> > > 
> > > IOW, just a mm_count ref would be sufficient to hold the mm_struct
> > > around, and then the read-lock protects against exit_mm() actually
> > > tearing the list down when the last "real" user goes away.
> > > 
> > > [ exit_mm() is currently a bit odd - it does take the mmap_write lock,
> > > but it *starts* with the read-lock.
> > > 
> > >    I'm not sure why it does that - it used to do the write lock over
> > > the whole sequence, but that was changed in commit bf3980c85212 ("mm:
> > > drop oom code from exit_mmap").
> > > 
> > >   Sure, read-lock allows more concurrency, but that would seem to be a
> > > complete non-issue for exit_mmap(), and switching locking seems to
> > > just complicate things.
> > > 
> > >   But that's a separate issue that I just happened to notice while
> > > looking at this ]
> > > 
> > > I may be missing something else again.
> > 
> > Hi Linus,
> > 
> > Sorry for the slow response.
> > Thank you for the incredibly detailed feedback and the suggestions.
> > 
> > Your proposal to avoid mm_users and synchronize via mmap_lock is an elegant
> > conceptual cleanup. However, from the perspective of userspace OOM recovery,
> > we hit two critical roadblocks that this alone cannot resolve:
> > 
> > First, the -ESRCH race remains unsolved.
> > Even if we don't grab mm_users, the victim process still clears its task->mm
> > to NULL early in exit_mm(). Here is the timing mismatch:
> > 
> > CPU A (Userspace OOM Killer)      CPU B (Victim Task)
> > ----------------------------      -------------------
> > 1. Sends SIGKILL
> > 2. Victim receives SIGKILL
> >                                   do_exit()
> >                                     exit_mm()
> >                                       task->mm = NULL  <==== (Stops pinning mm)
> >                                       mmput()
> > 3. Calls process_mrelease()
> >    (Looks up task->mm)
> >    (Sees NULL)
> >    Returns -ESRCH! <======================================== (Reaping fails!)
> > 
> > Without Jann's patch to preserve the mm pointer via task->exit_mm, the
> > userspace killer won't even have a chance to attempt reaping.
> > 
> > Second, the latency bottleneck transfers from mmput() to mmap_lock.
> > If a low-priority procfs reader is preempted or stalled while holding the
> > mmap_read_lock, the exiting process calling exit_mmap() will block indefinitely
> > when trying to acquire the mmap_write_lock.
> > 
> > Crucially, if this lock contention occurs, process_mrelease() itself would
> > also block on the same mmap_lock while trying to reap the memory, defeating the
> > synchronous and expedited nature of the API.
> > 
> > [An Alternative Proposal: Combining Kill and Reap via pidfd_send_signal()]
> > 
> > Taking a step back, I believe the fundamental issue stems from separating
> > the asynchronous "Kill" and synchronous "Reap" operations into two distinct
> > system calls. Because userspace cannot predict when the victim will execute
> > exit_mm(), the timing mismatch is practically unavoidable so the reaping
> > doesn't work in the end.
> > 
> > Since Christian understandably dislikes combining signaling semantics into
> > process_mrelease(), perhaps we could solve this from the signal side.
> > 
> > What if we introduce a new flag for pidfd_send_signal(), such as
> > PIDFD_SIGNAL_PROCESS_GROUP_EXPEDITE?
> > 
> > When invoked with this flag and SIGKILL, pidfd_send_signal() would deliver the
> > fatal signal and immediately trigger the oom_reaper's VM zapping on the target
> > mm within the same synchronous syscall context (where task->mm is guaranteed to
> > be valid and easily locked).
> 
> Maybe. We would need to see what that actually looks like.

Hi Christian,

Sure, Let me cook the initial draft.

Thanks.

