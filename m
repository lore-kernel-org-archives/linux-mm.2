Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECF62CD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 20:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD0F6B0088; Tue, 19 May 2026 16:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485266B008A; Tue, 19 May 2026 16:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39A496B008C; Tue, 19 May 2026 16:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2AFA76B0088
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:53:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC620A09E5
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:53:33 +0000 (UTC)
X-FDA: 84785370306.24.1FDD3B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0C5491C0010
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:53:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OI4P2Mzp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779224012; a=rsa-sha256;
	cv=none;
	b=wwHCKth17Z+dVJMAY1NZZRoV+qqd6rAIm3RIrFjUtNsgh/CYhlCcX03gDxwkQ0JM6Js3zz
	Vk89A+Dn3v2wZ1WLXpCME8k1p0ALMYcjcJQ5KrD6t5uuBKTUaynNCwREL6Aj71yiwg8p6h
	nKDH9r/Fouk3fnNpHQE+knBCwHyrO2o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OI4P2Mzp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779224012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jCqIEXfw/wdvd3SK3XOskv8/nJywCW8w0ATavedCeCQ=;
	b=D6LRhLipJO9CAWHm+jmAa/U7M/4Cx7JcHccAVEJbV5ClEi+h/uWjs11oFnLQ5Sz90/R7Rn
	Xe4nEaGiDSyu1Ik5Qw+43uT4nZ2nBN7lfkKzA0m3nCpglIVn32B35UqjFit4J+bLA9w5cI
	gmMneki/ATCpG8mXz4AsDs7Vv+gYVEA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 097924169F;
	Tue, 19 May 2026 20:53:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4C21F000E9;
	Tue, 19 May 2026 20:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779224010;
	bh=jCqIEXfw/wdvd3SK3XOskv8/nJywCW8w0ATavedCeCQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OI4P2Mzpbf6YCwD9QkPGZO2VyqVZebFUp+qZ/ndrxtEvKZgvBFvazZ/5FhVarFVM4
	 sghlGq6PREViBvKMH0FDJtBVy2YhFLlz2Y5qAgUkP4pe+0PaeraCNDxS4ij0nDGGh2
	 fvK/XmKh8DDwtda1VYK7bEeSij8VUL7P+gApAinmbufjrtEXu8Ps9MBtTuYWMBZXFS
	 93N9tU86GTC/MhCxZpXalKA8GsOaefgybM/wFVHKb0JPgCIWcQnIZY/52ER8RG1QJI
	 /2EjE3jc1tWTGlkmTDfj+rY4sG0dDSMJ/YGD36JCvCwlWV93N5UEToe8EMc9Fo9ZRi
	 IErQOvsdch9vg==
Date: Tue, 19 May 2026 13:53:29 -0700
From: Minchan Kim <minchan@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Christian Brauner <brauner@kernel.org>,
	Jann Horn <jannh@google.com>, akpm@linux-foundation.org,
	hca@linux.ibm.com, linux-s390@vger.kernel.org, david@kernel.org,
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	surenb@google.com, timmurray@google.com
Subject: Re: [PATCH v3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <agzNyXKIirm1zOob@google.com>
References: <20260511214226.937793-1-minchan@kernel.org>
 <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
 <agd--WZpeTq2iKFW@redhat.com>
 <agefLhQeWpvil14M@google.com>
 <CAHk-=wiHfzbufXD2nuc9BhOVp-pYEmnVUYeThKmfZRXLU0kJ7w@mail.gmail.com>
 <aggE2haQ7yGeHPeF@google.com>
 <CAHk-=wg08=sZb=hVa22KjN2pD3aNk-diGmKQnizCgmoMMfrvwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wg08=sZb=hVa22KjN2pD3aNk-diGmKQnizCgmoMMfrvwQ@mail.gmail.com>
X-Stat-Signature: x64augygzpt3ss646w8aghyoewbcznen
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C5491C0010
X-Rspamd-Server: rspam07
X-HE-Tag: 1779224011-330665
X-HE-Meta: U2FsdGVkX1//mH0EG/EVEaKNCKDLpAhhO+bChU35Y/7C4I1GVPv4c89ifC0ZensCFDxpIHstjl069U4H7Jr7lrBbScWpS3ggnsOXPM7LP18Ukdv86LeswJNjJF1Zu6gRknHVYBJmMYu81u1VrT2gW4njE/JAQWeghF64AnEoJ6pByTNuq+6aJUF5fJGLFGLg5nBQ1pra1Ntx0r8hZloq8gNLq8BsfP+FRBTlW+615AfMZ+/w8ZjpOn+GK15AGwo47/dZK0KlEyXBpFZ4LvASBxNx3fomWdLw7MMhQk+HuEfObm2eznrMRcHtF/BhO8BEZFnWLuBSEJY6d0S1+hjOdY2VP4uxaqMr6WTotTVmhbr/5cmrOVpCfRlfQfPnt82IydpzxJDHMRBg/QknN5GSJWE+lf27BwOrT5DGcajIdj0khFUzezU2ZeuLqzJNaCMyT48J3tBbzLNUexX3Qp4xBG3KhwUecFwZdFUw31I805W2G7NL6iG6BhsVlcMbAA7Yvo65lvpsX0++bW1SK8ihJVaMfc1C8awkSgsdKxWI0OQ61rNbgZMYAltiwTUoRxH2cWkvbgJpHxHeoGaJBtn5eJXdxPbpi008Fe1hySgZzTMcwv+h6oSwd84YpCXr04fONrsV120LlAqfsCCXeFSj8bE0iNeywivHteR9OedV6O3QCUICGsg4zFks58G9XnMEfZYnHhmhPi1McUn5KlyqafniNrXhAaZEoTLvZFneGK2bdT15XWUdIbr2tVjXJgmyvvB53x5bk9F6TvWvCiehhefPKkjT1UzStpj0AsWemJeenD8PyTkhR46e7G3+HyP6/ZO3TPsxLOPVQfpNwdEiXitZmpgy3lJc2jvROQ4sa9FzcGNlcWrlL3Wvc4dmGiOoy6DQjcpMygrIeJd0BZhQe/wag/omIed4qye5vMgl2OSGj0NNjBIM93Yuk3zVY1bE6PWiqmZNs1N1VgpEETy
 xnJORInC
 Q11Y28I1Vts1E9b4821PZ6QKTjghsskA2/d0gSE74NaaV5snzWo7DSTU9PJVcUQO3Qg8x29tjaG2sGk2g6bTBlzMs7WhzHOdpUb3j/rBCV4IP6ZSN7lGhjTjPTECfoMMXdQcBip25SiLCQNzhxtl36/hglcPNkPDHr5UeffWBxNpggJwM0ukwQD4BbwEYI4KEoDSpAoXkM2iRYjV+8YpGEsnvsrASAPDvQjd3nMwchsnkunQuE78v0mDgVSHjiCTNFFUJxqXsJTyyjXg9F3bqXGEhTnTWEMKBu/KorLw4NQl5OWawjp9jYpVWB8ygj1ILbF9e8psbWDwSjreG0rUM2sGK7ximBsXR4HlA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 16, 2026 at 09:31:04AM -0700, Linus Torvalds wrote:
> On Fri, 15 May 2026 at 22:47, Minchan Kim <minchan@kernel.org> wrote:
> >
> > Regarding proc_mem_open(), it actually operates very close to what you suggested.
> > It acquires a reference to the mm_struct itself via mmgrab() but immediately
> > unpins the address space memory via mmput(). Thus, no long-term mm_users
> > reference is held across the open file descriptor.
> 
> Ahh, and we've actually done that since 2012. How time flies..
> 
> > The latency issue occurs during seqfile iteration (m_start/m_stop) in
> > smaps/maps, or during get_cmdline() and ptrace_access_vm(), where the reader
> > temporarily acquires mm_users via mmget_not_zero() or get_task_mm().
> 
> Ok, so it's that much smaller region.
> 
> How about a completely different approach then - make exit_mmap() just
> take the mmap_write_lock() properly, and allow walking the vma's
> without ever grabbing mm_users at all?
> 
> IOW, just a mm_count ref would be sufficient to hold the mm_struct
> around, and then the read-lock protects against exit_mm() actually
> tearing the list down when the last "real" user goes away.
> 
> [ exit_mm() is currently a bit odd - it does take the mmap_write lock,
> but it *starts* with the read-lock.
> 
>    I'm not sure why it does that - it used to do the write lock over
> the whole sequence, but that was changed in commit bf3980c85212 ("mm:
> drop oom code from exit_mmap").
> 
>   Sure, read-lock allows more concurrency, but that would seem to be a
> complete non-issue for exit_mmap(), and switching locking seems to
> just complicate things.
> 
>   But that's a separate issue that I just happened to notice while
> looking at this ]
> 
> I may be missing something else again.

Hi Linus,

Sorry for the slow response.
Thank you for the incredibly detailed feedback and the suggestions.

Your proposal to avoid mm_users and synchronize via mmap_lock is an elegant
conceptual cleanup. However, from the perspective of userspace OOM recovery,
we hit two critical roadblocks that this alone cannot resolve:

First, the -ESRCH race remains unsolved.
Even if we don't grab mm_users, the victim process still clears its task->mm
to NULL early in exit_mm(). Here is the timing mismatch:

CPU A (Userspace OOM Killer)      CPU B (Victim Task)
----------------------------      -------------------
1. Sends SIGKILL
2. Victim receives SIGKILL
                                  do_exit()
                                    exit_mm()
                                      task->mm = NULL  <==== (Stops pinning mm)
                                      mmput()
3. Calls process_mrelease()
   (Looks up task->mm)
   (Sees NULL)
   Returns -ESRCH! <======================================== (Reaping fails!)

Without Jann's patch to preserve the mm pointer via task->exit_mm, the
userspace killer won't even have a chance to attempt reaping.

Second, the latency bottleneck transfers from mmput() to mmap_lock.
If a low-priority procfs reader is preempted or stalled while holding the
mmap_read_lock, the exiting process calling exit_mmap() will block indefinitely
when trying to acquire the mmap_write_lock.

Crucially, if this lock contention occurs, process_mrelease() itself would
also block on the same mmap_lock while trying to reap the memory, defeating the
synchronous and expedited nature of the API.

[An Alternative Proposal: Combining Kill and Reap via pidfd_send_signal()]

Taking a step back, I believe the fundamental issue stems from separating
the asynchronous "Kill" and synchronous "Reap" operations into two distinct
system calls. Because userspace cannot predict when the victim will execute
exit_mm(), the timing mismatch is practically unavoidable so the reaping
doesn't work in the end.

Since Christian understandably dislikes combining signaling semantics into
process_mrelease(), perhaps we could solve this from the signal side.

What if we introduce a new flag for pidfd_send_signal(), such as
PIDFD_SIGNAL_PROCESS_GROUP_EXPEDITE?

When invoked with this flag and SIGKILL, pidfd_send_signal() would deliver the
fatal signal and immediately trigger the oom_reaper's VM zapping on the target
mm within the same synchronous syscall context (where task->mm is guaranteed to
be valid and easily locked).

This would completely eliminate the -ESRCH race by making the kill-and-reap
operation atomic from userspace's perspective, while keeping each syscall
focused strictly on its primary responsibility (signaling vs. reclaiming)

Honestly, if we adopt this atomic interface, it might actually make the
separate process_mrelease() syscall obsolete. I am not entirely sure about
the historical reasons why they were split into two distinct APIs
in the first place, but merging them into a single pidfd-based atomic
operation seems much cleaner.

I would highly appreciate everyone's thoughts on this perspective and
alternative direction.

> 
> Also, I do really hate the smap code. People have optimized it because
> it's so piggy, but that code is still just silly. The "rollup" case in
> particular knows how bad it is, and does that whole "unlock and relock
> under contention" because it knows it's a horrible latency pig.

And yes, I completely agree with your frustration on the smaps code—it is
indeed a massive latency pig. In fact, userspace tools have increasingly moved
away from smaps and even PSS (Proportional Set Size) altogether because they
are simply too slow to be usable in production.

> 
> Oh well. But it really feels like we *could* do this all without mm_users. No?
> 
>                   Linus
> 

