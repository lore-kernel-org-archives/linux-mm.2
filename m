Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F26B606A324
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n3PnWGSE
Received: by kanga.kvack.org (Postfix)
	id F2EC76B07C3; Tue, 27 Oct 2026 11:38:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDF5E6B07C5; Tue, 27 Oct 2026 11:38:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1CD76B07C6; Tue, 27 Oct 2026 11:38:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8DFB6B07C3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:38:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 54E761409C7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:38:32 +0000 (UTC)
X-FDA: 85368813264.18.F1A50C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 94FE1120004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:38:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n3PnWGSE;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793115510;
	b=sJZsaKv5SLshWYNCV5RNfxeKjnGP70JTMhuADyyIw34QwqqF/ThHA3ghRKvKTiRjkKy4Lw
	ZVDLOaQsrflT7FWZkBfUsbOBhUysZtAMB4k4reSM1zLU2RuZIn9Tbx5PjBpBSeKT2UFWZa
	CmDB2cKZbHT4UgeB8kbUE8L1sEbwV8A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n3PnWGSE;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793115510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4QDwDejSsPjI6QsC7K2e4l+YE6idf6liU1KvYAti6A=;
	b=zzeTAfmNHXJHFggdlRjypTIjSpgxqFazh74o0wfuuRFmu/vPr0fqoohjY1cH0sIqu2vkUy
	WTsmYF0Gpk9D7AQEHgkIIbGHC5x3KONyaTZBYYC753Ut3UMPRAbnVANqbOULFnKaCJeD3w
	2zKeK5qLfkNGtMwys3CMiCasbiHWTUA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C3B5F408D6;
	Tue, 27 Oct 2026 15:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E4A1F01825;
	Tue, 27 Oct 2026 15:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793115509;
	bh=P4QDwDejSsPjI6QsC7K2e4l+YE6idf6liU1KvYAti6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n3PnWGSEy63TkshTbN+NH8Lz7qKC2SA8BzUpk+tmV1MeonlnzUWDIuBkzYaozxT3Z
	 TJuesb05R2Pm5JRavby+Id3CDOR+kOvkFdCodgze+hSIFOYNb0H3jPFqCe8pAWDr+h
	 QV0ABQe5oaV3oQvreewvONhUys5vgEHtAqlstJ/rjTPZYP0XClTFKPjezt4pZtzYPy
	 F1cnDPPZQYxciQ7wC+9ibZoYSUUWqMclFS2Ymoq0Ma232n5JNGXX3/RYFcSWnSS7Ai
	 ppF8o8avIYgpka5fUBCD16Z1rhQ9NYdLIYFPlOzOV36IyZnqZg4rOn9rcyDk8FbuTn
	 WeSaUXLtumYBA==
Date: Tue, 27 Oct 2026 15:38:20 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf@vger.kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	eddyz87@gmail.com, memxor@gmail.com, oleg@redhat.com, peterz@infradead.org, 
	mhiramat@kernel.org, jolsa@kernel.org, akpm@linux-foundation.org, liam@infradead.org, 
	surenb@google.com, david@kernel.org, vbabka@kernel.org, jannh@google.com, 
	hughd@google.com, kees@kernel.org, mingo@redhat.com, tglx@kernel.org, 
	x86@kernel.org, linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 6/9] uprobes: Don't sleep on mmap_lock with
 dup_mmap_sem held in dup_mmap()
Message-ID: <auDApO7ECoVLs-Jp@gremlin>
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
 <20261022015712.1297331-7-alexei.starovoitov@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261022015712.1297331-7-alexei.starovoitov@gmail.com>
X-Stat-Signature: zg9wrbupw7hehbykihox6bkee1bj9361
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 94FE1120004
X-Rspam-User: 
X-HE-Tag: 1793115510-388003
X-HE-Meta: U2FsdGVkX1/jVjRwce7NmHokJvFlKeNRx3PI5K1Psb/0fPTpGNvC8IokT7IairBVJ5Ffzhe3sL14XUfriWakDCpiY0k17wadmn82HtI+bTEfzy9IGcFQ/W/DeF8InLIuJqEcsL1ubPlQdJ21e6XoD3x8RUJjFKEp/loYFCzDZbbdfVCusPuJdtyRL+AaEeYeDPD5PTIc3yITMJR1t1heYXwBbxi6s4UgUkr0NJROibwlnlLSaLDYIiSG4ZW6Px7c9jjcxhq/rmk9K30mo4IObCPQCnTaLb5b0+rHdBWuWpoWWxuDeqJ+70SuLIqjA1sfoWL+lcEvkgvBv50xvCJ5sOyyuGK5yTNRREVipWn/1qqRWoow9bw3Lf/xBrIIlNg3d/1lB0C9wmH91w+6w9qJzqA+cm+pO4t7twyxo2PoP6gI6FAFhDZ65JNRNg50OUFdE/sIdHhwoyLCQf5iNrXvrv0gzKHbo0WtLfjPHpwXx+/UUCNlE3EbHeREO36RqgQzrf/6Uf024j9WL9+HSa8Y3z69CY+Ba+BVBbes+43J2CqhZQZTCL+azPaPjQGlwK6sL4f+RiIVOsEqbVJCZdoLfyKyslbkdtQ2D9jYf1D9JX5z017AFoLd2omIb4Mp5Ra9iS3GQAHjmOWkVMUE3msYnqN+igeiRyzaYxZzmYj8G7ozsZ5JyCO+vBC9UbUAb+29gaPHl5nFKaJmvf6lmzuvJP2koKigVHySlCAzBTO+8FsFxKxiuiXSCt2hY3aibFxldC+Hfif9PBoar5pQsGzvDc/4HGkJ8bn4iufuxtBC4oByrdE1mimdC5xpFAVliZHY0N2gzGBubsZGaFy6SQnkPQmNsupoZI+rSGU/I7WmdXcuv04tJmcT/3BcbsljfukzXA03I3BEQ/N+6GPkRnWBGXSZO2lVD2tSgOw73aFMEOofzapz3KJ5of4ekv9lhVqBUkOpjnT9crfjyNUF0YH
 1KxiJ82T
 1sMMz/3KIfwDnJ4GD6ht/LAxZ2tKaTXr11tTGH53nWaN2ECPJhMEKvYe8unrRgbYtKrW55qf3i9nEmDaSOYTnJo7Iql4DqflF37JLvzw/P1G8amqIeV0PKY4yODlxqrqJQWT5woSyxvpKtKuTF55nyhsddWCX+iknhA85UalRyqEqZ0E5FxLkT3Zny+W1wqsLN4R4FwMT7BW3wZEvzQp4ljDmU9w9VSw8x+dBI8yFS2h5VHC4XzG9eOVH6BdBrQcgKPQvqfWfgfsjHJ/sxzAtuY6FGFBFPi53uX7cuDpGvY5QgvwmkVTjN7HHr6UfBf/xofQOYg6VDSH3XTyukeonRUsdpdL9kyF/Ba/lAhFsogydUEn2vhdMnEU+FgRIwip0a3KHoPtTvUE/4FLD1yBDfmZFlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 01:57:09AM +0000, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
>
> dup_mm() takes dup_mmap_sem for reading and then dup_mmap() sleeps on
> mmap_lock of the parent. When another thread keeps that mmap_lock busy
> register_for_each_vma() waits for the reader, and every other fork() in
> the system waits for the writer. The parent doesn't have to map the file:
>
>   A thread 1:  mmap(MAP_POPULATE) -> mmap_read_lock(A)
>   A thread 2:  fork() -> percpu_down_read(&dup_mmap_sem),
>                mmap_write_lock_killable(A) sleeps
>   tracer:      percpu_down_write(&dup_mmap_sem) sleeps
>   others:      fork() -> percpu_down_read(&dup_mmap_sem) sleeps
>
> dup_mmap() needs both locks. Don't sleep on one of them while holding
> the other. Sleep on mmap_lock and trylock dup_mmap_sem. If that fails sleep
> on dup_mmap_sem and trylock mmap_lock, and so on. Taking mmap_lock and then
> sleeping on dup_mmap_sem is simpler, but then all threads of the parent
> wait for mmap_lock as long as the writer holds dup_mmap_sem.
>
> Both are taken in dup_mmap() now, so release dup_mmap_sem there too.
> Commit 8ac662f5da19 ("fork: avoid inappropriate uprobe access to invalid
> mm") moved that to dup_mm() to hide the child from uprobes until mmput()
> when dup_mmap() fails. Since commit 43873af772f8 ("mm: change dup_mmap()
> recovery") dup_mmap() removes all vmas of such child before it drops
> mmap_lock.
>
> dup_mmap_sem is released before dup_userfaultfd_complete(), so the monitor
> that doesn't read UFFD_EVENT_FORK no longer blocks every fork(). During
> that wait register_for_each_vma() can find the child, while no task points
> to its mm. The next patch deals with that.
>
> Thread 1 of process A loops over mmap(4G, MAP_POPULATE) and munmap().
> Thread 2 calls fork() in a loop. Nobody maps the file. Process B calls
> fork() in a loop. 32 cpu VM. Median (max) of 15-25 runs, msec:
>
>                          the longest fork() in B    attach
>                          before      after          before  after
>  uprobe_multi, 1 uprobe  206 (219)   0.10 (0.30)       220   11.7
>  uprobe_multi, 4 uprobes 208 (428)   0.08 (0.32)       219   13.5
>  perf_event, 4 uprobes   419 (424)   0.10 (0.44)       632   11.4
>
> During detach: 265-293 -> 0.19-0.37.
>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---
>  include/linux/uprobes.h |  5 +++++
>  kernel/events/uprobes.c |  5 +++++
>  kernel/fork.c           |  4 ----
>  mm/mmap.c               | 19 +++++++++++++++++--
>  4 files changed, 27 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
> index d34dbc0fbbfe..6d74efa80d04 100644
> --- a/include/linux/uprobes.h
> +++ b/include/linux/uprobes.h
> @@ -211,6 +211,7 @@ extern void uprobe_unregister_sync(void);
>  extern int uprobe_mmap(struct vm_area_struct *vma);
>  extern void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned long end);
>  extern void uprobe_start_dup_mmap(void);
> +extern bool uprobe_try_start_dup_mmap(void);
>  extern void uprobe_end_dup_mmap(void);
>  extern void uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm);
>  extern void uprobe_free_utask(struct task_struct *t);
> @@ -277,6 +278,10 @@ uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned long end
>  static inline void uprobe_start_dup_mmap(void)
>  {
>  }
> +static inline bool uprobe_try_start_dup_mmap(void)
> +{
> +	return true;
> +}
>  static inline void uprobe_end_dup_mmap(void)
>  {
>  }
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index a9274016c55d..92ccb730278f 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1927,6 +1927,11 @@ void uprobe_start_dup_mmap(void)
>  	percpu_down_read(&dup_mmap_sem);
>  }
>
> +bool uprobe_try_start_dup_mmap(void)
> +{
> +	return percpu_down_read_trylock(&dup_mmap_sem);
> +}
> +
>  void uprobe_end_dup_mmap(void)
>  {
>  	percpu_up_read(&dup_mmap_sem);
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 10f2d05d816a..8fd6be932afe 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1539,11 +1539,9 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
>  	if (!mm_init(mm, tsk))
>  		goto fail_nomem;
>
> -	uprobe_start_dup_mmap();
>  	err = dup_mmap(mm, oldmm);
>  	if (err)
>  		goto free_pt;
> -	uprobe_end_dup_mmap();
>
>  	mm->hiwater_rss = get_mm_rss(mm);
>  	mm->hiwater_vm = mm->total_vm;
> @@ -1558,8 +1556,6 @@ static struct mm_struct *dup_mm(struct task_struct *tsk,
>  	mm->binfmt = NULL;
>  	mm_init_owner(mm, NULL);
>  	mmput(mm);
> -	if (err)
> -		uprobe_end_dup_mmap();
>
>  fail_nomem:
>  	return NULL;
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 4bf26b0f1e6e..6ce654e33e3b 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1713,8 +1713,22 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  	LIST_HEAD(uf);
>  	VMA_ITERATOR(vmi, mm, 0);
>
> -	if (mmap_write_lock_killable(oldmm))
> -		return -EINTR;
> +	/*
> +	 * Take mmap_lock of oldmm and dup_mmap_sem of uprobes.
> +	 * Don't sleep on one of them while holding the other.
> +	 */
> +	for (;;) {
> +		if (mmap_write_lock_killable(oldmm))
> +			return -EINTR;
> +		if (uprobe_try_start_dup_mmap())
> +			break;
> +		mmap_write_unlock(oldmm);
> +
> +		uprobe_start_dup_mmap();
> +		if (mmap_write_trylock(oldmm))
> +			break;
> +		uprobe_end_dup_mmap();
> +	}

This isn't beautiful :)

As David says, we have an incoming fix that moves things around, i.e. this will
no longer actually live in dup_mmap() but rather dup_mm() [which, by the by, I
do want to move into mm], but that'd just move this there i guess?

I'm concerned by what Jann says re: a livelock here though. I'm not sure this
should be unbounded, and fork is a super-sensitive time for mm.

I would feel more comfortable with it if it were bounded, and really it'd be
nice if this was abstracted into its own function too rather than something
open-coded.

Do you have numbers on how many loops you are usually observing? Could you get
most of the way there by just doing a trylock on uprobe before trying to take
the mmap write lock?

I mean if 99% of the time you only need 1 iteration, for example, then the fix
looks a lot more sensible.

All in all it feels a bit egregious for core mm to be held hostage to uprobe
like this, isn't a better fix possible? Does uprobe actually need to exclude
fork, or could it just eat the cost of checking to see if something forked
since?

>  	flush_cache_dup_mm(oldmm);
>  	uprobe_dup_mmap(oldmm, mm);
>  	/*
> @@ -1883,6 +1897,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  	mmap_write_unlock(mm);
>  	flush_tlb_mm(oldmm);
>  	mmap_write_unlock(oldmm);
> +	uprobe_end_dup_mmap();
>  	if (!retval)
>  		dup_userfaultfd_complete(&uf);
>  	else
> --
> 2.55.0
>

--
Cheers, Lorenzo

