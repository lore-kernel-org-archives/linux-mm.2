Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88ACCCD4F5E
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 11:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBB6F6B008A; Thu, 21 May 2026 07:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C92036B008C; Thu, 21 May 2026 07:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCF366B0092; Thu, 21 May 2026 07:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AEC466B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:50:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D1801A05CD
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:50:57 +0000 (UTC)
X-FDA: 84791260554.14.941B837
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A004F4000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:50:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MRKZFDWb;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779364255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mxmzw2keS/IWw65LW2VBQA2Mr861k+BrmQPUw3Orkk0=;
	b=bkwJ5r2iPxqNsWCEbtRw8+escvuCIgDuTnju04/5t5GCizkKv/UNhyOzrF9d7DfSjXWtsD
	v2JPAsmBDpo9r77N7nM0FsDG4DUC3LNshILhz1CxN9XOgeTGtu42MnpfM0ZFpkYnRukqmx
	8q+s/4VTwoVKpfVLtqLDz45Y3pmpbvs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MRKZFDWb;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779364255; a=rsa-sha256;
	cv=none;
	b=ekj4p2dJdGTOLJDKEBHLhE9OWS8di69orRH9rwKpyC7k8TmJGfouhaWwLtOyV3DXJbhU8X
	+E1oKPP4WCBbEkNfWs3gXwEEPaAJIwtlobPEiR0UJnJc/B2pdYi9BdJY9B9UoQoI8UO2/k
	P6YdTZ4a93XeYE+hF5onHKEJUqGZprU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 233CD600C3;
	Thu, 21 May 2026 11:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34651F000E9;
	Thu, 21 May 2026 11:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779364254;
	bh=Mxmzw2keS/IWw65LW2VBQA2Mr861k+BrmQPUw3Orkk0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MRKZFDWbtFwY+D1XK7YXUgEDz2oAzVEz4C1qGJ7I4CJHVnOASNC97pUQKCz7EnN8P
	 lo+7bpbwOr3QBU8+gp3z+dwyxxtdLEMuUCGxg0oNNAph68BdeJy9sfTWe7+ZNbMv7m
	 jy4Rd1hD/hMT7MuVkCILpB5vwTWFtZcqc+GyMBR4WC/yfaNv87a9ndEVOa2PchI2Ku
	 As+bU54MEWUSoQ1nrOwdcgxcw3asfAPGfLh48hJKeotibVBCW0Ku5m6KMEbKkrGMGk
	 p2XQi5T4z94JVrdjesACegxGnTtAvHiBBf/pTLPP0j2AC1azH8U0QLK7qxjWlxvSCZ
	 LyL6/73ncJL6w==
Date: Thu, 21 May 2026 13:50:44 +0200
From: Christian Brauner <brauner@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Oleg Nesterov <oleg@redhat.com>, Jann Horn <jannh@google.com>, akpm@linux-foundation.org, 
	hca@linux.ibm.com, linux-s390@vger.kernel.org, david@kernel.org, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com, 
	timmurray@google.com
Subject: Re: [PATCH v3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <20260521-voreilig-investieren-34f6e0c56258@brauner>
References: <20260511214226.937793-1-minchan@kernel.org>
 <20260515-nachdenken-umbenannt-a90006a46e14@brauner>
 <agd--WZpeTq2iKFW@redhat.com>
 <agefLhQeWpvil14M@google.com>
 <CAHk-=wiHfzbufXD2nuc9BhOVp-pYEmnVUYeThKmfZRXLU0kJ7w@mail.gmail.com>
 <aggE2haQ7yGeHPeF@google.com>
 <CAHk-=wg08=sZb=hVa22KjN2pD3aNk-diGmKQnizCgmoMMfrvwQ@mail.gmail.com>
 <agzNyXKIirm1zOob@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <agzNyXKIirm1zOob@google.com>
X-Stat-Signature: z71ra9emfqpjfjy5usc3muwn6zkogygm
X-Rspamd-Queue-Id: A004F4000B
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779364255-176125
X-HE-Meta: U2FsdGVkX1/reWGEf3U1tcyglaxa38LXHtoGpm1hNSphIRC7haJwyUSSRmEmKEgUYu78iikWlNU8JQpABxMdxH4xk/NzxgKFGJ218xwrtXF16VbjgXTbg/1IYhX/5oCb4hw4a5gYns636K7s3yJZmf+fUKiLT5w05mnZItkck2G+NK259AURe+FvzuD99cyti/1jhi9J4Z7FVQfr8O1nfJARB+YgbGPUZDppUwCZzE6qOd2NYYZuHEs9neL1QwiIMCAwFTl4MoJfFNfvCcT8mMcI/PHdy1BaUOJGZoIqrWvv6sKJT9yAyxHdL8y9MRJHtVZU/HONV1fgZ8is6HKlHaKiQE6K4GvczL7czXNq1VW4/3RlbhF7MBjKWNeGPGTGYynqgxgtEguFZjmx/MMDgclK0Cp0qHZW75XtKRAf6q5t3/4k16d0aVoPUDkv1dSSAilnlznma3qhqBeethBjEXux7XYvx0IfiLTkHaDyoyIJh4FP9eHbCg1oZ2bbxEzMvG+dBlo/oDd597fy/AG4RszPJUFWEBz1UnC5bw839x0k14TuvyhV33+HuSn8g0FIPDcMBLFEA7Q6MLdbulW+YgD8qOzO2Hf4JiCp9qRakSuu5P9co/zUCHJVkBOODlLfnklDjiS5NpmOtLl5X12fcBc04r3Nk77El9/gdO2zpBAECbRrX3N12iejoUbm3riD2vdFpnRgf5HBNsGR+q9D/LVMSHsSP27dQ6QggqgSnT7M0+V2SfuztZqr41208sZv0OaK3C4W56UaLu73MAA01a6bGW6ZcYl6/yH0aXAl7NxurrUU+bz57cUF7ad+VOtoJk6tJ2drmHeWArybr31Tw7SqSzptyed6QiIKkvfiFScc/UzSStbtMmRZzoU5SZpQGiPYH8THRaKACwIP4//wBeUwbYXcGnw3TIaI444JJdpBnj/KYn4vyXHFbGiNyhmZ+IyR1N0KSAzRnezayf7
 t73tm/b/
 SbXfqvJZH0ubZtkAGvrUwXrgZ/rhlq2gAEUPTbcteyJCQQ+qp6zn7lRVNGnt+QOA3E5W16ZRUx4JdfxRw1N6UnX9F5VjJVqtV6nUCSMjs5Z1VNotRli6SCPKa0AK1l158equgeEtQvRvNpJLz8kgQ586107rX+Bg9chZv9vmQGia7daQCm7nVTK1+kHcFdx8KklGKF1JPgmPM/wZjHuyVCE4Pu4ufDWyG1FcNqGMmA4tINBH5abijkMeFJs+tiTRCHqkp+z7aevPOdnQOZ6UQR8HyIIG+cYh39jRlTTITEi0t0/HhLBmBwixXdCeNzvP9Y1dUyggYLwsan3/P9rAJt0pNIIF1sIwMytILdFgDWzL5J9cT8VFkLMkq+mWatL1uOwF8+x1YucM1Krw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 01:53:29PM -0700, Minchan Kim wrote:
> On Sat, May 16, 2026 at 09:31:04AM -0700, Linus Torvalds wrote:
> > On Fri, 15 May 2026 at 22:47, Minchan Kim <minchan@kernel.org> wrote:
> > >
> > > Regarding proc_mem_open(), it actually operates very close to what you suggested.
> > > It acquires a reference to the mm_struct itself via mmgrab() but immediately
> > > unpins the address space memory via mmput(). Thus, no long-term mm_users
> > > reference is held across the open file descriptor.
> > 
> > Ahh, and we've actually done that since 2012. How time flies..
> > 
> > > The latency issue occurs during seqfile iteration (m_start/m_stop) in
> > > smaps/maps, or during get_cmdline() and ptrace_access_vm(), where the reader
> > > temporarily acquires mm_users via mmget_not_zero() or get_task_mm().
> > 
> > Ok, so it's that much smaller region.
> > 
> > How about a completely different approach then - make exit_mmap() just
> > take the mmap_write_lock() properly, and allow walking the vma's
> > without ever grabbing mm_users at all?
> > 
> > IOW, just a mm_count ref would be sufficient to hold the mm_struct
> > around, and then the read-lock protects against exit_mm() actually
> > tearing the list down when the last "real" user goes away.
> > 
> > [ exit_mm() is currently a bit odd - it does take the mmap_write lock,
> > but it *starts* with the read-lock.
> > 
> >    I'm not sure why it does that - it used to do the write lock over
> > the whole sequence, but that was changed in commit bf3980c85212 ("mm:
> > drop oom code from exit_mmap").
> > 
> >   Sure, read-lock allows more concurrency, but that would seem to be a
> > complete non-issue for exit_mmap(), and switching locking seems to
> > just complicate things.
> > 
> >   But that's a separate issue that I just happened to notice while
> > looking at this ]
> > 
> > I may be missing something else again.
> 
> Hi Linus,
> 
> Sorry for the slow response.
> Thank you for the incredibly detailed feedback and the suggestions.
> 
> Your proposal to avoid mm_users and synchronize via mmap_lock is an elegant
> conceptual cleanup. However, from the perspective of userspace OOM recovery,
> we hit two critical roadblocks that this alone cannot resolve:
> 
> First, the -ESRCH race remains unsolved.
> Even if we don't grab mm_users, the victim process still clears its task->mm
> to NULL early in exit_mm(). Here is the timing mismatch:
> 
> CPU A (Userspace OOM Killer)      CPU B (Victim Task)
> ----------------------------      -------------------
> 1. Sends SIGKILL
> 2. Victim receives SIGKILL
>                                   do_exit()
>                                     exit_mm()
>                                       task->mm = NULL  <==== (Stops pinning mm)
>                                       mmput()
> 3. Calls process_mrelease()
>    (Looks up task->mm)
>    (Sees NULL)
>    Returns -ESRCH! <======================================== (Reaping fails!)
> 
> Without Jann's patch to preserve the mm pointer via task->exit_mm, the
> userspace killer won't even have a chance to attempt reaping.
> 
> Second, the latency bottleneck transfers from mmput() to mmap_lock.
> If a low-priority procfs reader is preempted or stalled while holding the
> mmap_read_lock, the exiting process calling exit_mmap() will block indefinitely
> when trying to acquire the mmap_write_lock.
> 
> Crucially, if this lock contention occurs, process_mrelease() itself would
> also block on the same mmap_lock while trying to reap the memory, defeating the
> synchronous and expedited nature of the API.
> 
> [An Alternative Proposal: Combining Kill and Reap via pidfd_send_signal()]
> 
> Taking a step back, I believe the fundamental issue stems from separating
> the asynchronous "Kill" and synchronous "Reap" operations into two distinct
> system calls. Because userspace cannot predict when the victim will execute
> exit_mm(), the timing mismatch is practically unavoidable so the reaping
> doesn't work in the end.
> 
> Since Christian understandably dislikes combining signaling semantics into
> process_mrelease(), perhaps we could solve this from the signal side.
> 
> What if we introduce a new flag for pidfd_send_signal(), such as
> PIDFD_SIGNAL_PROCESS_GROUP_EXPEDITE?
> 
> When invoked with this flag and SIGKILL, pidfd_send_signal() would deliver the
> fatal signal and immediately trigger the oom_reaper's VM zapping on the target
> mm within the same synchronous syscall context (where task->mm is guaranteed to
> be valid and easily locked).

Maybe. We would need to see what that actually looks like.

> 
> This would completely eliminate the -ESRCH race by making the kill-and-reap
> operation atomic from userspace's perspective, while keeping each syscall
> focused strictly on its primary responsibility (signaling vs. reclaiming)
> 
> Honestly, if we adopt this atomic interface, it might actually make the
> separate process_mrelease() syscall obsolete. I am not entirely sure about
> the historical reasons why they were split into two distinct APIs
> in the first place, but merging them into a single pidfd-based atomic
> operation seems much cleaner.
> 
> I would highly appreciate everyone's thoughts on this perspective and
> alternative direction.
> 
> > 
> > Also, I do really hate the smap code. People have optimized it because
> > it's so piggy, but that code is still just silly. The "rollup" case in
> > particular knows how bad it is, and does that whole "unlock and relock
> > under contention" because it knows it's a horrible latency pig.
> 
> And yes, I completely agree with your frustration on the smaps code—it is
> indeed a massive latency pig. In fact, userspace tools have increasingly moved
> away from smaps and even PSS (Proportional Set Size) altogether because they
> are simply too slow to be usable in production.
> 
> > 
> > Oh well. But it really feels like we *could* do this all without mm_users. No?
> > 
> >                   Linus
> > 

