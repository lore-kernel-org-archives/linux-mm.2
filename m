Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2026C531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 08:59:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5806B0088; Fri, 24 Jul 2026 04:59:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986966B008A; Fri, 24 Jul 2026 04:59:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E206B008C; Fri, 24 Jul 2026 04:59:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 32F886B0088
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 04:59:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D104C01AD
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:59:31 +0000 (UTC)
X-FDA: 85023071742.10.38CB7E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E12D7100006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:59:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ok7L3s+j;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784883569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W1/sfx/tV+W+4ENByX+okL4DfRqk5vPpKiIbowGvwkY=;
	b=Acu0CuCvePj2lKaQ1JiXrsG9Us7ihwcCNihkUfFYP4Ff2+Gt/wKxMiP7iwE2MD47BEDyCw
	AjQ85PrIWnWEXyKkyt5f0n4DR1JfbX7sWQ3NTGlh2BSeMYdAijJi74Nu6BIlFjM7Ojic76
	fgvMniHcyE9UqCBbTzE0NjZB9dHdSRA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784883569;
	b=qYIVlFG3VQkXIAfIdKeQiLtTesfQTvSLvV94ZpsE1r02yCeSBlBNRlgjnpt9OnZFO2WILL
	B+u31JpUmbiCk0vj+xEpeOQxmnsFjOz8XjCWwlamdCQjHyUqw73xQ9WZ3iiilaBfxgo1Qc
	RT+ru79aFlLZ0xehWayR5yv2xF/0SmM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ok7L3s+j;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EF8BC60A5A;
	Fri, 24 Jul 2026 08:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236ED1F00A3A;
	Fri, 24 Jul 2026 08:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784883568;
	bh=W1/sfx/tV+W+4ENByX+okL4DfRqk5vPpKiIbowGvwkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ok7L3s+jqmxSaGDociXD5UwjlzRmXvdKZhNMcDz53hVOr/VsVSzr3EKTd2nc4CeQc
	 GDAxzgajUrufLRvzedDeOVsheXYxipiuEjixWlu1RtQs+TYiTgrbVX8LTgyTnagXD8
	 1yJ8SWEOGIUkE44bZ8S6ERzmyGy+I6Tz8kfVNBOpjhyYYA2lqzATPgWtFuU0MaHYnZ
	 hKFb2QfxQiuv9X5YcBmwTEWi3V8gitA9wRBONRgEFW+A9OaTB8nXY1QSvm/FOrjTWf
	 1gWGywRV2PR6CAL1GsW6Fox2cYP88032bYA2MuTt2Lg0gQ5Vq7MBPgIA4Y4n6Xh4X1
	 ytsRDM8+m3bnQ==
Date: Fri, 24 Jul 2026 09:59:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "shaikh.kamal" <shaikhkamal2012@gmail.com>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, linux-rt-devel@lists.linux.dev, seanjc@google.com, 
	syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3] mm/mmu_notifier: Add async OOM cleanup via call_srcu()
Message-ID: <amMZFqs1smKmMuj5@lucifer>
References: <20260722140803.11421-1-shaikhkamal2012@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722140803.11421-1-shaikhkamal2012@gmail.com>
X-Stat-Signature: 1ogb1t4jkrgrhb64fergue9tfpjeq6md
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E12D7100006
X-HE-Tag: 1784883569-839164
X-HE-Meta: U2FsdGVkX19wilZMndX9LR/6DYMTqpqHVvamIzA+60LN3YmZq6ikgwijVNTQVITmHNWyWjLtL9BoY2t2JSw6qrNZcsGKrfSD3548+Eb6nyGDjxkV2q7OFKjdzQvPATIULrEPS0GmSfjjwqpy06c8f2SZFQR6M/kdLJUsj64KMi5cwBhGgoR9JyJG0mf6/hDGtWK91MEy6tgqPvTdms/SRT6dqZ/OBZ29dMRMLaGVolePU4chKRw0B7V+P0jO4TPNo5bN/feJnaR19rX5TnNwJAK3LnMlx7L4Quzrtqhltt9qX8xtxbkAdl3zHxozcM/GgO4abdWW3ocF2mCnY92teXKAzAhujLESm6srx6DOqa71skQoeFhrzqyxMsD9TA3X01DEyvFamOaQaaRmx38w8VsieDRo5siYhdURig/YeSlPYpAsKkkXd4bfm2tbt68mTdM9U7cXOz+wTC1JKzImqbyuAmhpTcuUeOV+xLZjO+WsiBKSkSJ8Q5lPYxzDZXMQTmf2VX/dH2TmFaxGb04BX407co0CGqFu1EqeYA1wGUz7Br7sU4fnDCsCKXHpmu+4MSUN1HEuk/YOsyAZSL84WnNERONl7z3VH/oDhb3+pujShFn1+mPKoz4ry0h1s8So7OJYisqdrm8tmGJbjEOmbj+OuFnVAFS+/eZ/TYxUH08vW067lpYfdPcLSbfy/7muz44j2xXmdi1rz5+1X6wL4T9DSUzzQthwmGXzdHCaGj3PsWAMU31FNiVg0H5DNjvABPjXU5+Ypc5E3u6qynTjvoBp46+eHrUuf8qJkEhTbdX57nL5VgyR8C4lUJ+zpAXv+3CKxl7y7iMk5CZzjyPI4+fnGNYP8C9qjvRCh8MZoTkG8obXmF+2eqZ5AKAQv5+L/ko9hGQx/+GsD/wAVZ2eN6ZhYpHpe6+AOLDl4ksQUPWyloa7b0zL9Qr0xe45LPTNk+SgrBxEEulaGuVGzgd
 2DygF6XC
 rvdbU6krz4yRq5TNoE4jEY+M2UUFbfvQZ1bcHPzD70ogFERX1+sBYJ96kyJhYuQLLFOjFkUfRlRnpXVScxadp8mA/xoO4DIKDhYm+Prl4BrZEPkUXawmo+2a9JxmO5Q5qAh90p19aH2p1VTG2VO5oDqFOlyYp244uDb+B1bSw8+y1TBZszW6mT+ahOAHdbXo/PRG2tmst3RN2FcaLVcajZk1LNdjWTBO4k1sWGUwMLLegUUXmOBY3PVYSza+7BgFW5mWcWoFnJtAZ7ecCjWLPqgh3h6jOHwRjyDKD6tOntbg44nvZrGGNd5fYueNH82qK7EHODKueqvmMBNIozSaC9sxiiAik+3+MFm/tQKOmUQ6a2kg5lXRI3uSRcjXkdPG6pHVK3UWUt1LTLMUOTp0eVYRU26bZCnrGMVPJPdu2rsAS8oGwF6v2nyTOqFnvIrgO7H0SZjtHbbgudILo1+E5AscdE49u47rmMV+5NkJ62quffDTlDRbbcknuw7NKCc4ufF2g9CvGCNuqt5F0dR+MPMSHekqvy6QWpY0EcxPdi+FhY8qbkiTKp1UGHcrLAyY8gWZV6DRUEEXzbtl8wBO2fKxXDttKdl8ndMfqAtPuCz9dwNpIi0QjD8kEj2KOY3a7QurJuG/W466t0jvfuehj8YHMK+3HEpE0oMZX+PwJse1goe+j7Lp30pfWhDaA1k6kF/Q5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This approach was previously NAK'd so I'm not sure why it's at v3? :) see
below about this, but maybe that was address, doesn't seem so however.

(I'd also suggest you don't use gmail, it bounces kernel mail as spam a lot
now and may result in you not receiving responses - see
https://korg.docs.kernel.org/linuxdev.html for a free linux.dev account as
an alternative).

On Wed, Jul 22, 2026 at 07:38:03PM +0530, shaikh.kamal wrote:
> When an mm undergoes OOM kill, the OOM reaper unmaps memory while
> holding the mmap_lock in a non-blocking context set up by
> mmu_notifier_invalidate_range_start_nonblock(). MMU notifier
> subscribers (notably KVM) acquire sleeping locks in their
> invalidate callbacks, which deadlocks on PREEMPT_RT where
> spinlock_t is a sleeping rt_mutex:
>
>   BUG: sleeping function called from invalid context at
>   kernel/locking/spinlock_rt.c:48
>   in_atomic(): 0, irqs_disabled(): 0, non_block: 1, pid: 40,
>   name: oom_reaper
>   Call Trace:
>    rt_spin_lock
>    kvm_mmu_notifier_invalidate_range_start
>    __mmu_notifier_invalidate_range_start
>    zap_vma_for_reaping
>    __oom_reap_task_mm
>
> Implement the asynchronous cleanup design proposed by Paolo
> Bonzini in v1 review: a new optional after_oom_unregister
> callback in struct mmu_notifier_ops, invoked after the SRCU grace
> period via call_srcu() so that no readers can still reference the
> subscription when cleanup runs.
>
> The flow is:
>
>   1. The OOM reaper calls mmu_notifier_oom_enter() from
>      __oom_reap_task_mm(), before the non-blocking VMA zap loop.
>   2. mmu_notifier_oom_enter() walks the subscription list and, for
>      each subscriber that provides after_oom_unregister, detaches
>      the subscription from the active list and schedules a
>      call_srcu() callback. The reaper's subsequent invalidations
>      therefore never invoke the subscriber's callbacks.
>   3. The deferred callback invokes after_oom_unregister once the
>      grace period has elapsed and all in-flight readers have
>      finished.
>   4. Subsystems waiting to free structures referenced by the
>      callback can call the new mmu_notifier_barrier() helper, which
>      wraps srcu_barrier() to wait for all outstanding callbacks
>      scheduled this way.
>
> Paolo's original sketch called synchronize_srcu() from
> mmu_notifier_oom_enter() before invoking the callbacks. That
> blocks the OOM reaper waiting for a grace period and can deadlock:
> the reaper holds mmap_lock while waiting for SRCU readers to
> drain, while an in-flight reader can itself be blocked on
> mmap_lock. Use call_srcu() instead so the reaper never waits; the
> callback runs asynchronously once the grace period elapses, and
> mmu_notifier_barrier() provides the synchronization point for
> teardown paths that need to wait.

Hmm I don't think mmu notifier callbacks can make assumptions about mmap
lock, do you mean there's an implicit dependency on the lock somehow?
Please be a lot more specific about the deadlock scenario.

>
> after_oom_unregister is mutually exclusive with alloc_notifier
> because allocated notifiers can have additional outstanding
> references that the OOM path cannot safely drop.
>
> Update KVM to provide after_oom_unregister, which clears
> mn_active_invalidate_count, and to detect via hlist_unhashed() in
> kvm_destroy_vm() when its subscription was already detached by the
> OOM path; in that case call mmu_notifier_barrier() and drop the mm
> reference rather than calling mmu_notifier_unregister().
>
> Tested under virtme-ng with PREEMPT_RT, KASAN, and lockdep
> enabled, using a minimal KVM test program (opens /dev/kvm, creates
> a VM, registers memory, creates a vCPU, and sleeps) driven through
> a CONFIG_DEBUG_VM-only debugfs trigger (not part of this patch)
> that invokes __oom_reap_task_mm() on the target task. With the
> patch applied, mmu_notifier_oom_enter() detaches the KVM
> subscription, the call_srcu() callback runs after the SRCU grace
> period, KVM's after_oom_unregister clears
> mn_active_invalidate_count, and mmu_notifier_barrier() returns
> cleanly in kvm_destroy_vm(), with no KASAN reports, kernel BUGs,
> or lockdep splats across 20 stress iterations. The same setup
> reproduces the syzbot-reported warning on an unpatched PREEMPT_RT
> kernel; it is no longer observed with this patch applied.

It'd be good if you could provide a minimal reproducer, especially since
syzbot wasn't able to come up with one.

>
> If the GFP_ATOMIC allocation in mmu_notifier_oom_enter() fails,
> the after_oom_unregister callback for that subscription is
> skipped rather than retried, since retrying could sleep and
> reintroduce the deadlock this patch fixes. The subscription is
> still cleaned up later via the normal unregister path.
>
> Fixes: 52ac8b358b0c ("KVM: Block memslot updates across range_start() and range_end()")

You need a Cc: stable in mm for backports.

But hmm backporting an entirely new mmu notifier mechanism like this is
really really questionable.

Weren't you also told that this predates that commit anyway and should be
commit e930bffe95e1 ("KVM: Synchronize guest physical memory map to host
virtual memory map")?...

https://lore.kernel.org/all/aYyhfvC_2s000P7H@google.com/

I'm a little concerned that review is not being addressed here.

> Reported-by: syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=c3178b6b512446632bac

This isn't a report it's a syzbot control panel?

You mean https://lore.kernel.org/all/6936812a.a70a0220.38f243.0090.GAE@google.com/ right?

> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Link: https://lore.kernel.org/all/CABgObfZQM0Eq1=vzm812D+CAcjOaE1f1QAUqGo5rTzXgLnR9cQ@mail.gmail.com/
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202605031109.uxckW5L3-lkp@intel.com/

We don't do Reported-by/Closes on stuff that's not upstream especially not
on previous revisions of a not yet accepted patch.

>
> Signed-off-by: shaikh.kamal <shaikhkamal2012@gmail.com>

Hmm, this approach was NAK'd before but you're pressing ahead with it
unless I'm missing something:

https://lore.kernel.org/all/aasD2OHkQN3kdRba@google.com/

You never responded to that - could you address that please?

I'd also like to hear from Michal and David on this also ideally. But my
2p:

You're allocating GFP_ATOMIC when the OOM killer reaper runs (!!) using reserves
that are intended for absolutely critical atomic context stuff (IRQ etc.) for an
MMU notifier event.

This seems nuts to me, and you're letting it be unbounded on MMU notifier
registrations AFAICT.

I also don't think something like this is backportable esp. to a 2021 (!) Fixes
tag.

I would suggest trying a completely different approach.

In general gating things on whether the oom_reap (renamed...!) op is
defined then having mmu_notifier pre-allocate the callback stuff (or reuse
a place that's already allocated) seems a better way.

But since it's intended for a fix (+ therefore backport) is there not some
simpler resolution that doesn't require actively extending the mmu_notifier
logic to do completely new stuff?

I'm not really comfortable with something like that being backported.

You can always do a 'dumb' fix for backport and a more forward thinking one
for upstream.

> ---
> Changes in v3:
> - Rebase onto v7.2-rc3; v2 was based on stale v7.0 which the
>   kernel test robot could not apply to current trees
> - Add missing static inline stub for mmu_notifier_oom_enter() in
>   the !CONFIG_MMU_NOTIFIER section of include/linux/mmu_notifier.h,
>   fixing allnoconfig build failures reported by the kernel test
>   robot
> - Use kmalloc_obj() per current allocation idiom
> - Add Fixes: tag identifying the commit that introduced
>   mn_invalidate_lock
>
> Changes in v2:
> - Complete redesign per Paolo's v1 review: moved from a
>   KVM-internal locking change to a new mm/mmu_notifier
>   after_oom_unregister callback with call_srcu() async cleanup
>   (hence the subject prefix change from KVM: to mm/)
> - Add mmu_notifier_barrier() (srcu_barrier wrapper) for teardown
>   synchronization in kvm_destroy_vm()
> - Move call site to __oom_reap_task_mm(); use hlist_del_init() to
>   keep hlist_unhashed() correct and avoid use-after-free on the
>   stack-allocated oom_list head
>
> v2: https://lore.kernel.org/all/20260429222548.25475-1-shaikhkamal2012@gmail.com/
> v1: https://lore.kernel.org/all/20260209161527.31978-1-shaikhkamal2012@gmail.com/
>
>  include/linux/mmu_notifier.h |  14 ++++
>  mm/mmu_notifier.c            | 122 +++++++++++++++++++++++++++++++++++
>  mm/oom_kill.c                |   3 +
>  virt/kvm/kvm_main.c          |  27 +++++++-
>  4 files changed, 165 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index a11a44eef521..a1820a487854 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -88,6 +88,14 @@ struct mmu_notifier_ops {
>  	void (*release)(struct mmu_notifier *subscription,
>  			struct mm_struct *mm);
>
> +	/*
> +	 * Any mmu notifier that defines this is automatically unregistered
> +	 * when its mm is the subject of an OOM kill.  after_oom_unregister()
> +	 * is invoked after all other outstanding callbacks have terminated.
> +	 */
> +	void (*after_oom_unregister)(struct mmu_notifier *subscription,
> +				     struct mm_struct *mm);

This is really confusing. You subscribe to an event that then causes that event
to actually happen? And you are defining a new event specifically for it?

It definitely needs renaming, I read the comment and the name and think
'what?' :)

How about simply 'oom_reaped' or something like that?

> +
>  	/*
>  	 * clear_flush_young is called after the VM is
>  	 * test-and-clearing the young/accessed bitflag in the
> @@ -424,6 +432,8 @@ bool __mmu_notifier_clear_young(struct mm_struct *mm,
>  		unsigned long start, unsigned long end);
>  bool __mmu_notifier_test_young(struct mm_struct *mm,
>  		unsigned long address);
> +void mmu_notifier_oom_enter(struct mm_struct *mm);

This seems like a bad name. Enter implies exit, and this is at the point of the
reaper being invoked also, seems better to put that in the name.

Good also to have it resemble the event name it triggers?

> +void mmu_notifier_barrier(void);
>  extern int __mmu_notifier_invalidate_range_start(struct mmu_notifier_range *r);
>  extern void __mmu_notifier_invalidate_range_end(struct mmu_notifier_range *r);
>  extern void __mmu_notifier_arch_invalidate_secondary_tlbs(struct mm_struct *mm,
> @@ -643,6 +653,10 @@ static inline void mmu_notifier_synchronize(void)
>  {
>  }
>
> +static inline void mmu_notifier_oom_enter(struct mm_struct *mm)
> +{
> +}
> +
>  #endif /* CONFIG_MMU_NOTIFIER */
>
>  #endif /* _LINUX_MMU_NOTIFIER_H */
> diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
> index 245b74f39f91..f30bf95f17c7 100644
> --- a/mm/mmu_notifier.c
> +++ b/mm/mmu_notifier.c
> @@ -49,6 +49,37 @@ struct mmu_notifier_subscriptions {
>  	struct hlist_head deferred_list;
>  };
>
> +/*
> + * Callback structure for asynchronous OOM cleanup.
> + * Used with call_srcu() to defer after_oom_unregister callbacks
> + * until after SRCU grace period completes.
> + */
> +struct mmu_notifier_oom_callback {
> +	struct rcu_head rcu;
> +	struct mmu_notifier *subscription;
> +	struct mm_struct *mm;
> +};
> +
> +/*
> + * Callback function invoked after SRCU grace period.
> + * Safely calls after_oom_unregister once all readers have finished.
> + */
> +static void mmu_notifier_oom_callback_fn(struct rcu_head *rcu)
> +{
> +	struct mmu_notifier_oom_callback *cb =
> +		container_of(rcu, struct mmu_notifier_oom_callback, rcu);
> +
> +	/* Safe - all SRCU readers have finished */
> +	cb->subscription->ops->after_oom_unregister(cb->subscription, cb->mm);
> +
> +	/* Release mm reference taken when callback was scheduled */
> +	WARN_ON_ONCE(atomic_read(&cb->mm->mm_count) <= 0);

I'm quite concerned that you think this is likely enough for a
WARN_ON_ONCE()... You really shouldn't be accessing this field directly. And if
you're seeing a 0 refcount you're already effectively doing a UAF so what's the
point?

> +	mmdrop(cb->mm);

Hmm but you're also mmdrop()'ing in the KVM callback?

> +
> +	/* Free callback structure */
> +	kfree(cb);
> +}
> +
>  /*
>   * This is a collision-retry read-side/write-side 'lock', a lot like a
>   * seqcount, however this allows multiple write-sides to hold it at
> @@ -385,6 +416,84 @@ void __mmu_notifier_release(struct mm_struct *mm)
>  		mn_hlist_release(subscriptions, mm);
>  }
>
> +void mmu_notifier_oom_enter(struct mm_struct *mm)

This function badly needs a comment, kdoc please.

> +{
> +	struct mmu_notifier_subscriptions *subscriptions =
> +						mm->notifier_subscriptions;

This indentation is absolutely wild :) please find a better way.

If you call the var 'subs' it can fit on one line ;)

> +	struct mmu_notifier *subscription;
> +	struct hlist_node *tmp;
> +	HLIST_HEAD(oom_list);
> +	int id;
> +
> +	if (!subscriptions)
> +		return;
> +
> +	id = srcu_read_lock(&srcu);
> +
> +	/*
> +	 * Prevent further calls to the MMU notifier, except for
> +	 * release and after_oom_unregister.
> +	 */
> +	spin_lock(&subscriptions->lock);
> +	hlist_for_each_entry_safe(subscription, tmp,
> +				  &subscriptions->list, hlist) {
> +		if (!subscription->ops->after_oom_unregister)
> +			continue;
> +
> +		/*
> +		 * after_oom_unregister and alloc_notifier are incompatible,
> +		 * because there could be other references to allocated
> +		 * notifiers.
> +		 */
> +		if (WARN_ON(subscription->ops->alloc_notifier))
> +			continue;

Probably better to check this at registration time no?

> +
> +		hlist_del_init_rcu(&subscription->hlist);
> +		hlist_add_head(&subscription->hlist, &oom_list);
> +	}
> +	spin_unlock(&subscriptions->lock);
> +	hlist_for_each_entry(subscription, &oom_list, hlist)
> +		if (subscription->ops->release)
> +			subscription->ops->release(subscription, mm);
> +
> +	srcu_read_unlock(&srcu, id);
> +
> +	if (hlist_empty(&oom_list))
> +		return;
> +
> +	hlist_for_each_entry_safe(subscription, tmp,
> +				  &oom_list, hlist) {
> +		struct mmu_notifier_oom_callback *cb;
> +		/*
> +		 * Remove from stack-based oom_list and reset hlist to unhashed state.
> +		 * This sets subscription->hlist.pprev = NULL, so future callers of
> +		 * mmu_notifier_unregister() (e.g. kvm_destroy_vm) will see
> +		 * hlist_unhashed() == true and take the safe path, avoiding
> +		 * use-after-free on the stack-allocated oom_list head.
> +		 */

This seems really fragile and 'just so' to suit a use case.

> +		hlist_del_init(&subscription->hlist);
> +
> +		/*
> +		 * GFP_ATOMIC failure is exceedingly rare. We cannot sleep

Really? Under memory pressure enough that the OOM killer has been invoked
and when only emergency memory reserves (which you're now depleting) are
available?

Allocating on an OOM path is deeply questionable in general.

Allocating _for each subscription_ seems nuts?

Also aren't you definitely using additional reserves this way because the OOM
killer is underway, reserves intended for _absolutely critical_ tasks to do with
OOM, not MMU notifier events?

Wouldn't it just be better to have pre-allocated this at registration
time or embed this somewhere that's already allocated?

> +		 * here (would reintroduce the deadlock this patch fixes)
> +		 * and cannot call after_oom_unregister synchronously
> +		 * without first waiting for SRCU readers. The subscriber
> +		 * will not receive after_oom_unregister but cleanup will
> +		 * eventually happen via the unregister path.
> +		 */
> +		cb = kmalloc_obj(*cb, GFP_ATOMIC);

See above re: the craziness of this.

Couldn't you use mmu_notifier->rcu_head?

It's only used if alloc_notifier is specified which you explicitly disallow.

That way you don't need an allocation at all.

> +		if (!cb)
> +			continue;

If you can't allocate, loop around and try another allocation afterwards?
That also seems crazy? You should bail out. But really you shouldn't be
allocating like this here at all as per above.

But in general - you're resolving a bug by doing this but it's ok to just
give up and allow the deadlock if you can't allocate?

Then it's not a fix at all?

> +
> +		cb->subscription = subscription;
> +		cb->mm = mm;
> +		mmgrab(mm);
> +
> +		/* Schedule callback - returns immediately */

We don't need to have comments explaining how core RCU functions work :)

> +		call_srcu(&srcu, &cb->rcu, mmu_notifier_oom_callback_fn);
> +	}
> +}
> +
>  /*
>   * If no young bitflag is supported by the hardware, ->clear_flush_young can
>   * unmap the address and return 1 or 0 depending if the mapping previously
> @@ -1144,3 +1253,16 @@ void mmu_notifier_synchronize(void)
>  	synchronize_srcu(&srcu);
>  }
>  EXPORT_SYMBOL_GPL(mmu_notifier_synchronize);
> +
> +/**
> + * mmu_notifier_barrier - Wait for all pending MMU notifier callbacks
> + *
> + * Waits for all call_srcu() callbacks scheduled by mmu_notifier_oom_enter()
> + * to complete. Used by subsystems during cleanup to prevent use-after-free
> + * when destroying structures accessed by the callbacks.
> + */
> +void mmu_notifier_barrier(void)
> +{
> +	srcu_barrier(&srcu);
> +}
> +EXPORT_SYMBOL_GPL(mmu_notifier_barrier);
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5f372f6e26fa..66adcd03f36a 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -516,6 +516,9 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>  	bool ret = true;
>  	MA_STATE(mas, &mm->mm_mt, ULONG_MAX, ULONG_MAX);
>
> +	/* Notify MMU notifiers about the OOM event */

This comment is superfluous.

> +	mmu_notifier_oom_enter(mm);
> +
>  	/*
>  	 * Tell all users of get_user/copy_from_user etc... that the content
>  	 * is no longer stable. No barriers really needed because unmapping
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e44c20c04961..79a4df8a337a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -875,6 +875,24 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
>  	srcu_read_unlock(&kvm->srcu, idx);
>  }
>
> +static void kvm_mmu_notifier_after_oom_unregister(struct mmu_notifier *mn,
> +						  struct mm_struct *mm)
> +{
> +	struct kvm *kvm;
> +
> +	kvm = mmu_notifier_to_kvm(mn);
> +
> +	/*
> +	 * At this point the unregister has completed and all other callbacks
> +	 * have terminated. Clean up any unbalanced invalidation counts.
> +	 */

The comment seems unrelated to the WARN_ON()?

> +	WARN_ON(rcuwait_active(&kvm->mn_memslots_update_rcuwait));

Is this actually possible?

It's not great to leave WARN_ON()'s in a patch that's intended to be
backported that seem to be 'oh maybe I didn't get this patch right'.

We don't want that kind of thing as part of a _fix_ you should be
absolutely certain the fix works.

Also WARN_ON_ONCE() maybe?

> +	if (kvm->mn_active_invalidate_count)
> +		kvm->mn_active_invalidate_count = 0;
> +	else
> +		WARN_ON(kvm->mmu_invalidate_in_progress);

Why is this separate and predicated on !mn_active_invalidate_count?

Seems simpler to just group the warnings together with comments explaining
_why_.

But as per above the fact you're putting 'maybe my patch is wrong' warnings
here worries me.

> +}
> +
>  static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
>  	.invalidate_range_start	= kvm_mmu_notifier_invalidate_range_start,
>  	.invalidate_range_end	= kvm_mmu_notifier_invalidate_range_end,
> @@ -882,6 +900,7 @@ static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
>  	.clear_young		= kvm_mmu_notifier_clear_young,
>  	.test_young		= kvm_mmu_notifier_test_young,
>  	.release		= kvm_mmu_notifier_release,
> +	.after_oom_unregister	= kvm_mmu_notifier_after_oom_unregister,
>  };
>
>  static int kvm_init_mmu_notifier(struct kvm *kvm)
> @@ -1273,7 +1292,13 @@ static void kvm_destroy_vm(struct kvm *kvm)
>  		kvm->buses[i] = NULL;
>  	}
>  	kvm_coalesced_mmio_free(kvm);
> -	mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
> +	if (hlist_unhashed(&kvm->mmu_notifier.hlist)) {

I really hate that you're accessing internals like this to figure out
state. Is it also safe to access it like this without a barrier of any
kind?

You'd at least want a helper wrapped around this...

And is KVM the only place that needs updating here? You've created a whole
new paradigm here surely needs to be reflected elsewhere?

> +		/* Subscription removed by OOM. Wait for async callback. */
> +		mmu_notifier_barrier();

It seems like you've decided 'why not both' on synchronisation vs. callback :)

> +		mmdrop(kvm->mm);

I really don't like that you expose mm internals here.

It seems to me that this logic should be part of the standard unregister
procedure, gated on the 'after_oom_unregister' (preferably renamed) op
being defined.

> +	} else {
> +		mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);

This code should _just be_ mmu_notifier_unregister() as before.

> +	}
>  	/*
>  	 * At this point, pending calls to invalidate_range_start()
>  	 * have completed but no more MMU notifiers will run, so
>
> base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
> --
> 2.43.0
>

I also asked AI to have a look at this and it points out process_mrelease()
has no capability check, so you can trigger this from an unprivileged
process (on its own killed child process for instance).

Is that intended? That seems possibly problematic?

Cheers, Lorenzo

