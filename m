Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54904C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:50:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40CFA6B0088; Mon, 31 Aug 2026 11:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BE2B6B008A; Mon, 31 Aug 2026 11:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ADF96B008C; Mon, 31 Aug 2026 11:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F21336B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:50:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E68114019E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:50:43 +0000 (UTC)
X-FDA: 85162002366.14.475178F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id AEE4E14000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:50:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T+R3AL3v;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788191441;
	b=qQ+E6YVcb5buzRyMPlcqEgZm9tsucauPWYSoDObgh7Imlu9DQrawO1IZ2H8CxxF9CkaVbO
	wpEb+1Pkp0pW2iHC+168Q8u66/pIW45DDaHAZH9mVyMAOO9qRTPHhuza8ohJBSl7JxcCaH
	+uo6dtgReIOO+Du+vbi0c8v1M7Keei8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T+R3AL3v;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788191441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HxenJbCV4dFq4UjvqCI9fwACwH3W0FeYkdcjRioC5dI=;
	b=YQ4NSTf1pZQXDrY3Ia4m9RMeWiw2DhS3sHVFwtup1LxIAzsVVLRKYGlcjthBYDXnu1Sbr3
	BC4Jy3H2dfo/niEOmPsVdKVTjaFnbemIaBapEcccl+jJZ4AQ1XOEDxuDf+baY6m9GF1H9k
	FUNgEL8M384zzhdzYJeHZaB2VNnJzVI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89BDF413A0;
	Mon, 31 Aug 2026 15:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD211F000E9;
	Mon, 31 Aug 2026 15:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788191440;
	bh=HxenJbCV4dFq4UjvqCI9fwACwH3W0FeYkdcjRioC5dI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T+R3AL3vFHNrCq+xt2pfAXVR2CDLGmJLvkjAWusze6Kl1a8sOIIOxqfBHE+Q2/I9f
	 ORy+v43LIy611cHw8lvME4WtMKsBOE/wHzchGFUFHbmd/c/2EJNbWORqseDvgNVODy
	 xg7wUgxZXJM2d6XAPclhz6aTXc1F1XtVIS1TSVmWih5JFundL51i1haIZ6GRtSEg1X
	 kTU8qNVrqpu5MsInxqME4s8ERDXbRw/ibc9YHd2PR2FItyc9iVtt9I7ccViIGlchKr
	 Q8Hzv5uwupQxLDJY4zAZtS/xdDbWrC25ULwgLqobE3QcT9Un9eLMGBDe2OLu/oSDtR
	 lZDHtmkN4zWYw==
Date: Mon, 31 Aug 2026 16:50:20 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andi Kleen <ak@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, jannh@google.com, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RCU safety for vma maple tree walks
Message-ID: <apWYZTfxxz6vpkOY@lucifer>
References: <20260831143511.1133029-1-ak@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831143511.1133029-1-ak@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AEE4E14000A
X-Stat-Signature: xwo4d83rhzmgo3c1a564qxysm39jwo5i
X-Rspam-User: 
X-HE-Tag: 1788191441-402536
X-HE-Meta: U2FsdGVkX1+u4bnSv8JjGWfpJTFeVw04YOSiKPd2YMaIrJg8WMmABKc7MlbI7PaHIrQqDsWxYr1+GLIok7juJT03p5KcHRAUGxePeJXoH7jVQKdWIlblEDQYgT8obQkCDOw1xviPW/4VaD80cnQGJ8Fxx6dh0OUotgXWoLG5ayjZj8QYGtgnGAnEsyvVBUWK/tZPMnRAA/3y2mTekzUDZAhFr/BgDjsbDuPNcu2wPoTfiZzcrjhtm/Mb0xWV12dzNqzoWbxP20QiGJgBvpoTw06kC9vYOEL+GFRrvBBZq3ueGFFGyf3sBeJRJar01j4iUTLsGMotI6r8zH1hil/eYptqkNOZk/Fxqj+7mE9Lkfogf0hGBB8MTChFtq9ghVvjmfIV7u0w1KXDr6HY9YFxs41KlU/dDE9+N3Vw7g86/ryQzPANZ7SJkGoZ+92RfZ/ASKRLWEG3vBN+Lmj+gYumgMQOSXDktc4zWzgq+T4jUKnmSbrUp5YUlJH04RJAxnd4UTuplzzXrebR5cgFtFzZfpsKtpTtnQR+Sluooc1duHt6a2jurdQT9MYtD80VdGq/1lAr8EmRh5CxUt1ql4ofzdKIpKajWzOuuh3CwosPVBsGNx95jAdtcdIFD7oFNR9aN3GcyOLBWp7MMZzyeG1ljOIguXrd9Au9f1XVq3ufYjZw8H7a8bZ5m2S89Zmoyr7XwCaZisZ+aOvMy96WFMvcV5QfGNkVyctOSpx6c1qtL6/bDhdunXZeUSgy6ChEoXBIw700aeng3tLFiZ6bodN4gFLV5979ZYiMx5xLXFfN7BXc5slJ7oesB14suVBHeUnvHLqFxMdSIV3yOE+9uqtN3AXdxlIItyB1gAf3Xfnl39mvGjXTu2+vAfW68LSb6uZMBhInklc1Fah9CBg1ofcg8Rcr0bQ+iX15VDxkZSt2JHuaQBwyztLiSG0KfnFvfb2oy32Wlg30EFq05Aq0hZh
 nyCmc4QP
 TldZQElb3VaDsgU87U0C/yFd7kWQuWl1sg7KFuhcLIcRdR1S4KM/TViuTJwD0gMDtKfVxprAhyaXCUyEj5KklRPTDldNu8BDiwXy/z/uPZ4JJjh1Tf/GLicZ+lL22ZUxUQ9Q2Xuv4clEmrJUkeYVQvUa2MoyfMfDffN3L7JJxWUqCd6Mt4x9owD6/1ogRHXtKCpppJawEyE4+s0t/szIDWefY7Rx7ZwZBcapM8poLirddsCx2EtQWZhsKfN+bpELmhi/v8V7zLhTsCX3jjG5BK6/71rUFZVrLCEODJQ7QKwDsEFX8iAEE7wI43RGDCtg9lkNPWe2PsktXsKKznUm3Yew1ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

you really should have sent this as an RFC or a discussion.

On Mon, Aug 31, 2026 at 07:35:11AM -0700, Andi Kleen wrote:
> I ran into the following scenario in a slightly modified kernel:

I mean I could stop here :) you are reporting a bug for a kernel that isn't
the one upstream.

You say your change "can do VMA splits on exec mm teardown" - that sounds
very much like the root of the problem :)

>
>  1. vms_gather_munmap_vmas walks the unmap range and caches a maple node N
>     in the maple iterator.
>  2. It triggers a __split_vma to fix up a range and during that node N
>     is queued for freeing with kfree_rcu

This makes absolutely no sense, we are not allocating maple nodes then
immediately freeing them while also retaining them in the same iterator.

The mmap write lock serialises writes to the maple tree also so only the
current task can do this except... if the kernel is patched :)

If it's a store that invalidates the node, then that same operation also
moves the same iterator forawrd.

>  3. There is another __split_vma that allocates memory and sleeps due to
>     memory pressure.
>  4. During the sleep the grace period expires and node N gets freed for
>     real.

But... what exactly caused the node to be deleted and the iterator to
somehow remain valid?

>  5. The iterator still has node N cached
>  6. When the iteration continues it accesses the freed node and KASAN
>     trips:

What you're describing simply isn't possible.

The mm maple tree is locked under MT_FLAGS_LOCK_EXTERN |
MT_FLAGS_USE_RCU. We use the VMA/mmap locks to serialise.

The mmap write lock serialises the only possible writer to the current
task.

If there was some way of doing this we 100% would have hit this
before. Hell, syzkaller and friends have hit the most outlandish stuff
imaginable.

In the patch you describe the only stores are being done by the called
__split_vma() calls which... use the same iterator?

As you can see from the sig:

static __must_check int
__split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
	    unsigned long addr, int new_below)

So I think what's happening is that your patch that "can do VMA splits on
exec mm teardown" is doing something wrong here.

>
> BUG: KASAN: slab-use-after-free in mas_next_slot+0x1e95/0x2860
> Read of size 8 at addr ffff8881160bdc00 by task pool-e/5770
> CPU: 1 UID: 0 PID: 5770 Comm: pool-e Not tainted 7.2.0-rc7-1-debug+ #106
> Allocated by task 5770:
>   mas_alloc_nodes <- mas_preallocate <- __split_vma <- vms_gather_munmap_vmas
>     <- do_vmi_align_munmap <- do_vmi_munmap <- __vm_munmap <- elf_load
>     <- load_elf_binary <- bprm_execve          (pool-e's exec)
> Freed by task 25 (ksoftirqd):
>   __rcu_free_sheaf_prepare <- rcu_free_sheaf_nobarn <- rcu_do_batch <- rcu_core
> The buggy address ... cache maple_node of size 256
> freed 256-byte region [ffff8881160bdc00, ffff8881160bdd00)

This makes no sense, except... if something wrongly starts writing into
mm_mt without proper locking, like... a custom patch in the kernel :)

>
> There was also a more complex scenario when the node was immediately
> recycled for the next split VMA insert, modified, but the access by
> the iterator for the previous walk saw corrupted state and triggered
> KASAN too.
>
> Basically the problem is that any sleeping during VMA walks breaks the
> RCU reader guarantees for the RCU Maple tree iterators. But sleeping

What RCU reader guarantees?

> is unavoidable for various reasons.
>
> I hit it with a kernel modification that makes this more likely
> (It can do VMA splits on exec mm teardown)

Smoking gun...

> and also in a very memory constrained environment (4GB guest running a
> stress test), but based on code review I believe it's a generic problem that
> could happen in a unmodified kernel.
>
> That said I wasn't actually able to trigger it in a unmodified kernel
> so far with stress testing.

Yes because the bug almost certainly doesn't exist in mainline :)

>
> The following old unsolved syzkaller report has a similar signature,
> so maybe it was already seen:
> https://syzkaller.appspot.com/bug?id=4c5268fbb1d6d508a4c34dc425e2693d1ff9911a

Hmm that is a very old report? That could have any number of causes?

>
> I guess in many cases where it happens for real you don't notice it
> if you don't have KASAN active.
>
> The patch fixes up all callers to maintain the RCU reader lock
> regions correctly during the VMA walk. If they cannot be maintained the
> iterator is refreshed by a new VMA address lookup in a new region, unless
> it is proven safe not to.
>
> In the cases where there is no sleeping it is strictly not needed
> because this scenario could not happen due the existing VMA locking.
>
> But I fixed them too to not violate the maple tree iterator
> "rcu read lock or write lock" contract.

I'm not sure that's a contract that exists? RCU lock or external lock
yes...

>
> The ones that do not strictly need it are: count_mm_mlocked_page_nr,
> remap_file_pages, range_contains_unmapped.
>
> The ones that may sleep and clearly need it are: apply_vma_lock_flags,
> do_mprotect_pkey, remap_move, mseal_apply, mbind_range, userfaultfd
> register/unregister,
> mwriteprotect_range (doesn't sleep in the walk itself, but uses iterator
> after sleep)
>
> In principle it could be optimized more, e.g. for example only do the
> re-lookups when actual sleeping happened. Some of it could be done
> with a new cond resched variant. But I tried to keep it minimal
> for now.
>
> The patch survived most of LTP, the kernel mm selftests and
> my own stress tests. I didn't do any benchmarks.
>
> For when it was introduced it's a complex area, but I believe the patch
> that originally added the problem was
> commit b2b3b886738f ("mm: don't use __vma_adjust() in __split_vma()")
> Then
> commit 17f1ae9b40c6 ("mm/vma: change munmap to use vma_munmap_struct() for
> accounting and surrounding vmas")
> extended the pattern to more places, and then later it was copied
> elsewhere too. I'm mentioning only the first below.

This seems like absolute handwaving, sorry.

>
> No cc stable so far, needs some discussion first.

I mean RFC is for that right? :)

>
> Fixes: b2b3b886738f ("mm: don't use __vma_adjust() in __split_vma()")
> Assisted-by: omp:gpt-5.6-luna

Yup, it shows. I think this isn't a great showcase for gpt...

I have to say this isn't the way to engage on this stuff Andi - you're
essentially workslopping us when you really you should have _opened_ with a
discussion and copied the actual patch you've made to the kernel.

> Signed-off-by: Andi Kleen <ak@kernel.org>

This patch is wrong even if your theory is right, and the patch is utterly
horrible from a maintenance point of view anyway.

> ---
>  mm/mempolicy.c   | 13 ++++++++
>  mm/mlock.c       | 13 +++++++-
>  mm/mmap.c        |  1 +
>  mm/mprotect.c    | 29 +++++++++++++---
>  mm/mremap.c      | 16 +++++++--
>  mm/mseal.c       | 15 +++++++++
>  mm/userfaultfd.c | 86 ++++++++++++++++++++++++++++++++++++++++++------
>  mm/vma.c         | 13 +++++---
>  8 files changed, 163 insertions(+), 23 deletions(-)

The changes are very horrible, even if we did need to do something like this, it
really couldn't be in this form.

This introduces assumptions about not sleeping all over, it breaks the
abstraction, I mean it's pretty patently obviously not upstreamable.

But you also do weird stuff like... assuming an rcu_read_lock() after a
sleep somehow restores the node back from death...

This could all have been cleared up and saved people time had you just
kicked off a discussion thread or pinged us.

>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 3498a5651d50..7ffdb930b60d 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1062,7 +1062,20 @@ static int mbind_range(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	if (IS_ERR(vma))
>  		return PTR_ERR(vma);
>
> +	rcu_read_lock();
> +	/*
> +	 * The modify might have invalidated the iterators when
> +	 * sleeping happened. Do another lookup
> +	 */
> +	vma_iter_set(vmi, vmstart);
> +	vma = vma_find(vmi, vmend);
> +	if (!vma) {
> +		rcu_read_unlock();
> +		return -ENOMEM;
> +	}
>  	*prev = vma;
> +	rcu_read_unlock();

If your RCU theory were true, then the iterator now has invalid nodes in it
then when next you RCU lock -> walk you are going to UAF?

You're also forcing a complete rewalk every single time and making the vmi
pointless here.

> +	/* Iterator still protected by write lock */
>  	return vma_replace_policy(vma, new_pol);
>  }
>
> diff --git a/mm/mlock.c b/mm/mlock.c
> index efa6716e4dfb..ee5c0347129d 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -540,12 +540,15 @@ static int apply_vma_lock_flags(unsigned long start, size_t len,
>
>  	nstart = start;
>  	tmp = vma->vm_start;
> +	rcu_read_lock();
>  	for_each_vma_range(vmi, vma, end) {
>  		int error;
>  		vma_flags_t newflags;
>
> -		if (vma->vm_start != tmp)
> +		if (vma->vm_start != tmp) {
> +			rcu_read_unlock();
>  			return -ENOMEM;
> +		}
>
>  		newflags = vma->flags;
>  		vma_flags_clear_mask(&newflags, VMA_LOCKED_MASK);
> @@ -555,12 +558,19 @@ static int apply_vma_lock_flags(unsigned long start, size_t len,
>  		tmp = vma->vm_end;
>  		if (tmp > end)
>  			tmp = end;
> +		rcu_read_unlock();
>  		error = mlock_fixup(&vmi, vma, &prev, nstart, tmp, &newflags);
>  		if (error)
>  			return error;
> +		/*
> +		 * The iterator is always left on a life node, so no

live?

> +		 * re-lookup needed after sleep.

This makes no sense, your theory is that an RCU grace period can invalidate
any node right, somehow?

> +		 */
>  		tmp = vma_iter_end(&vmi);
>  		nstart = tmp;
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();

Now nested rcu locks, to add to complexity...

I mean I could go on but I think the LLM has got itself very confused here
and a human should have intervened sooner.

>
>  	if (tmp < end)
>  		return -ENOMEM;
> @@ -589,6 +599,7 @@ static unsigned long count_mm_mlocked_page_nr(struct mm_struct *mm,
>  	else
>  		end = start + len;
>
> +	guard(rcu)();
>  	for_each_vma_range(vmi, vma, end) {
>  		if (vma_test(vma, VMA_LOCKED_BIT)) {
>  			if (start > vma->vm_start)
> diff --git a/mm/mmap.c b/mm/mmap.c
> index e10412160b32..dfe5c51dee98 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1184,6 +1184,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
>  		VMA_ITERATOR(vmi, mm, vma->vm_end);
>  		struct vm_area_struct *next, *prev = vma;
>
> +		guard(rcu)();
>  		for_each_vma_range(vmi, next, start + size) {
>  			/* hole between vmas ? */
>  			if (next->vm_start != prev->vm_end)
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 2888ee638d87..53e4fd45d39b 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -941,6 +941,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
>  	tlb_gather_mmu(&tlb, current->mm);
>  	nstart = start;
>  	tmp = vma->vm_start;
> +	rcu_read_lock();
>  	for_each_vma_range(vmi, vma, end) {
>  		vm_flags_t mask_off_old_flags;
>  		vma_flags_t new_vma_flags;
> @@ -984,29 +985,49 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
>  			error = -EINVAL;
>  			break;
>  		}
> +		rcu_read_unlock();
>
>  		error = security_file_mprotect(vma, reqprot, prot);
> -		if (error)
> +		if (error) {
> +			rcu_read_lock();
>  			break;
> -
> +		}
> +		rcu_read_lock();
> +		/*
> +		 * The security hook may sleep; re-lookup instead of
> +		 * trusting the pre-sleep pointer.
> +		 */
> +		vma_iter_set(&vmi, vma->vm_start);
> +		vma = vma_find(&vmi, end);
> +		if (!vma) {
> +			error = -ENOMEM;
> +			break;
> +		}
>  		tmp = vma->vm_end;
>  		if (tmp > end)
>  			tmp = end;
> +		rcu_read_unlock();
>
>  		if (vma->vm_ops && vma->vm_ops->mprotect) {
>  			error = vma->vm_ops->mprotect(vma, nstart, tmp, newflags);
> -			if (error)
> +			if (error) {
> +				rcu_read_lock();
>  				break;
> +			}
>  		}
>
>  		error = mprotect_fixup(&vmi, &tlb, vma, &prev, nstart, tmp, newflags);
> -		if (error)
> +		if (error) {
> +			rcu_read_lock();
>  			break;
> +		}
>
>  		tmp = vma_iter_end(&vmi);
>  		nstart = tmp;
>  		prot = reqprot;
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>  	tlb_finish_mmu(&tlb);
>
>  	if (!error && tmp < end)
> diff --git a/mm/mremap.c b/mm/mremap.c
> index e8df5cdb0ac9..c8589c699515 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1903,6 +1903,7 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
>  	 * with all VMAs in the input range [addr, addr + old_len) being moved
>  	 * (and split as necessary).
>  	 */
> +	rcu_read_lock();
>  	for_each_vma_range(vmi, vma, end) {
>  		/* Account for start, end not aligned with VMA start, end. */
>  		unsigned long addr = max(vma->vm_start, start);
> @@ -1911,8 +1912,10 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
>  		bool multi_allowed;
>
>  		/* No gap permitted at the start of the range. */
> -		if (!seen_vma && start < vma->vm_start)
> +		if (!seen_vma && start < vma->vm_start) {
> +			rcu_read_unlock();
>  			return -EFAULT;
> +		}
>
>  		/*
>  		 * To sensibly move multiple VMAs, accounting for the fact that
> @@ -1940,12 +1943,17 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
>  		multi_allowed = vma_multi_allowed(vma);
>  		if (!multi_allowed) {
>  			/* This is not the first VMA, abort immediately. */
> -			if (seen_vma)
> +			if (seen_vma) {
> +				rcu_read_unlock();
>  				return -EFAULT;
> +			}
>  			/* This is the first, but there are more, abort. */
> -			if (vma->vm_end < end)
> +			if (vma->vm_end < end) {
> +				rcu_read_unlock();
>  				return -EFAULT;
> +			}
>  		}
> +		rcu_read_unlock();
>
>  		res_vma = check_prep_vma(vrm);
>  		if (!res_vma)
> @@ -1969,7 +1977,9 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
>  		}
>  		seen_vma = true;
>  		target_addr = res_vma + vrm->new_len;
> +		rcu_read_lock();
>  	}
> +	rcu_read_unlock();
>
>  	return res;
>  }
> diff --git a/mm/mseal.c b/mm/mseal.c
> index 7a8ac66dc215..551b5ad52f4d 100644
> --- a/mm/mseal.c
> +++ b/mm/mseal.c
> @@ -22,6 +22,7 @@ static bool range_contains_unmapped(unsigned long start, unsigned long end)
>  	unsigned long prev_end = start;
>  	struct vm_area_struct *vma;
>
> +	guard(rcu)();
>  	for_each_vma_range(vmi, vma, end) {
>  		if (vma->vm_start > prev_end)
>  			return true;
> @@ -43,6 +44,7 @@ static int __mseal_range(unsigned long start, unsigned long end)
>  	if (start > vma->vm_start)
>  		prev = vma;
>
> +	rcu_read_lock();
>  	for_each_vma_range(vmi, vma, end) {
>  		const unsigned long curr_start = max(vma->vm_start, start);
>  		const unsigned long curr_end = min(vma->vm_end, end);
> @@ -51,17 +53,30 @@ static int __mseal_range(unsigned long start, unsigned long end)
>  			vma_flags_t vma_flags = vma->flags;
>
>  			vma_flags_set(&vma_flags, VMA_SEALED_BIT);
> +			rcu_read_unlock();
>
>  			vma = vma_modify_flags(&vmi, prev, vma, curr_start,
>  					       curr_end, &vma_flags);
>  			if (IS_ERR(vma))
>  				return PTR_ERR(vma);
> +
> +			rcu_read_lock();
> +			/* The modify may have slept and merged, so re-lookup. */
> +			vma_iter_set(&vmi, curr_start);
> +			vma = vma_find(&vmi, curr_end);
> +			if (!vma) {
> +				rcu_read_unlock();
> +				return -ENOMEM;
> +			}
> +			rcu_read_unlock();
>  			vma_start_write(vma);
>  			vma_set_flags(vma, VMA_SEALED_BIT);
> +			rcu_read_lock();
>  		}
>
>  		prev = vma;
>  	}
> +	rcu_read_unlock();
>
>  	return 0;
>  }
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 23fb68fce000..464570b15d4a 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1134,6 +1134,7 @@ static int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
>  		goto out_unlock;
>
>  	err = -ENOENT;
> +	rcu_read_lock();
>  	for_each_vma_range(vmi, dst_vma, end) {
>
>  		if (!userfaultfd_wp(dst_vma)) {
> @@ -1150,14 +1151,18 @@ static int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
>
>  		_start = max(dst_vma->vm_start, start);
>  		_end = min(dst_vma->vm_end, end);
> +		rcu_read_unlock();
>
>  		err = uffd_wp_range(dst_vma, _start, _end - _start, enable_wp);
> +		rcu_read_lock();
> +		/* The iterator is still on a life node */
>
>  		/* Return 0 on success, <0 on failures */
>  		if (err < 0)
>  			break;
>  		err = 0;
>  	}
> +	rcu_read_unlock();
>  out_unlock:
>  	up_read(&ctx->map_changing_lock);
>  	mmap_read_unlock(dst_mm);
> @@ -2324,9 +2329,17 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
>  	if (vma->vm_start < start)
>  		prev = vma;
>
> +	rcu_read_lock();
>  	for_each_vma_range(vmi, vma, end) {
> +		rcu_read_unlock();
>  		cond_resched();
>
> +		rcu_read_lock();
> +		/* The cond_resched above may have slept, so re-lookup. */
> +		vma_iter_set(&vmi, vma->vm_start);
> +		vma = vma_find(&vmi, end);
> +		if (!vma)
> +			break;
>  		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vm_flags, wp_async));
>  		VM_WARN_ON_ONCE(vma->vm_userfaultfd_ctx.ctx &&
>  				vma->vm_userfaultfd_ctx.ctx != ctx);
> @@ -2355,6 +2368,7 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
>  		new_vma_flags = vma->flags;
>  		vma_flags_clear_mask(&new_vma_flags, __VMA_UFFD_FLAGS);
>  		vma_flags_set_mask(&new_vma_flags, vma_flags);
> +		rcu_read_unlock();
>
>  		vma = vma_modify_flags_uffd(&vmi, prev, vma, start, vma_end,
>  					    &new_vma_flags,
> @@ -2368,15 +2382,31 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
>  		 * the next vma was merged into the current one and
>  		 * the current one has not been updated yet.
>  		 */
> +		rcu_read_lock();
> +		/* The modify may have slept and merged, so re-lookup. */
> +		vma_iter_set(&vmi, start);
> +		vma = vma_find(&vmi, end);
> +		if (!vma)
> +			break;
> +		rcu_read_unlock();
>  		userfaultfd_set_ctx(vma, ctx, vm_flags);
> +		rcu_read_lock();
>
> -		if (is_vm_hugetlb_page(vma) && uffd_disable_huge_pmd_share(vma))
> +		if (is_vm_hugetlb_page(vma) && uffd_disable_huge_pmd_share(vma)) {
> +			rcu_read_unlock();
>  			hugetlb_unshare_all_pmds(vma);
> +			rcu_read_lock();
> +			vma_iter_set(&vmi, start);
> +			vma = vma_find(&vmi, end);
> +			if (!vma)
> +				break;
> +		}
>
>  skip:
>  		prev = vma;
>  		start = vma->vm_end;
>  	}
> +	rcu_read_unlock();
>
>  	return 0;
>  }
> @@ -3808,16 +3838,26 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>  	found = false;
>  	basic_ioctls = false;
>  	cur = vma;
> +	rcu_read_lock();
>  	do {
> +		rcu_read_unlock();
>  		cond_resched();
>
> +		rcu_read_lock();
> +		/* The cond_resched above may have slept, so re-lookup. */
> +		vma_iter_set(&vmi, cur->vm_start);
> +		cur = vma_find(&vmi, end);
> +		if (!cur)
> +			break;
>  		VM_WARN_ON_ONCE(!!cur->vm_userfaultfd_ctx.ctx ^
>  				!!(cur->vm_flags & __VM_UFFD_FLAGS));
>
>  		/* check not compatible vmas */
>  		ret = -EINVAL;
> -		if (!vma_can_userfault(cur, vm_flags, wp_async))
> +		if (!vma_can_userfault(cur, vm_flags, wp_async)) {
> +			rcu_read_unlock();
>  			goto out_unlock;
> +		}
>
>  		/*
>  		 * RWP uses protnone as an access-tracking marker. PROT_NONE
> @@ -3827,8 +3867,10 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>  		 * mprotect() must still be unregisterable, so this is not
>  		 * part of vma_can_userfault().
>  		 */
> -		if ((vm_flags & VM_UFFD_RWP) && !vma_is_accessible(cur))
> +		if ((vm_flags & VM_UFFD_RWP) && !vma_is_accessible(cur)) {
> +			rcu_read_unlock();
>  			goto out_unlock;
> +		}
>
>  		/*
>  		 * UFFDIO_COPY will fill file holes even without
> @@ -3839,8 +3881,10 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>  		 * F_WRITE_SEAL can be taken until the vma is destroyed.
>  		 */
>  		ret = -EPERM;
> -		if (unlikely(!(cur->vm_flags & VM_MAYWRITE)))
> +		if (unlikely(!(cur->vm_flags & VM_MAYWRITE))) {
> +			rcu_read_unlock();
>  			goto out_unlock;
> +		}
>
>  		/*
>  		 * If this vma contains ending address, and huge pages
> @@ -3852,11 +3896,15 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>
>  			ret = -EINVAL;
>
> -			if (end & (vma_hpagesize - 1))
> +			if (end & (vma_hpagesize - 1)) {
> +				rcu_read_unlock();
>  				goto out_unlock;
> +			}
>  		}
> -		if ((vm_flags & VM_UFFD_WP) && !(cur->vm_flags & VM_MAYWRITE))
> +		if ((vm_flags & VM_UFFD_WP) && !(cur->vm_flags & VM_MAYWRITE)) {
> +			rcu_read_unlock();
>  			goto out_unlock;
> +		}
>
>  		/*
>  		 * Check that this vma isn't already owned by a
> @@ -3866,8 +3914,10 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>  		 */
>  		ret = -EBUSY;
>  		if (cur->vm_userfaultfd_ctx.ctx &&
> -		    cur->vm_userfaultfd_ctx.ctx != ctx)
> +		    cur->vm_userfaultfd_ctx.ctx != ctx) {
> +			rcu_read_unlock();
>  			goto out_unlock;
> +		}
>
>  		/*
>  		 * Mode switches that drop VM_UFFD_WP or VM_UFFD_RWP would
> @@ -3876,8 +3926,10 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>  		 * into the other mode. Require an unregister first.
>  		 */
>  		if (cur->vm_userfaultfd_ctx.ctx == ctx &&
> -		    cur->vm_flags & (VM_UFFD_WP | VM_UFFD_RWP) & ~vm_flags)
> +		    cur->vm_flags & (VM_UFFD_WP | VM_UFFD_RWP) & ~vm_flags) {
> +			rcu_read_unlock();
>  			goto out_unlock;
> +		}
>
>  		/*
>  		 * Note vmas containing huge pages
> @@ -3887,6 +3939,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
>
>  		found = true;
>  	} for_each_vma_range(vmi, cur, end);
> +	rcu_read_unlock();
>  	VM_WARN_ON_ONCE(!found);
>
>  	ret = userfaultfd_register_range(ctx, vma, vm_flags, start, end,
> @@ -3980,9 +4033,17 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>  	 */
>  	found = false;
>  	cur = vma;
> +	rcu_read_lock();
>  	do {
> +		rcu_read_unlock();
>  		cond_resched();
>
> +		rcu_read_lock();
> +		/* The cond_resched above may have slept, so re-lookup. */
> +		vma_iter_set(&vmi, cur->vm_start);
> +		cur = vma_find(&vmi, end);
> +		if (!cur)
> +			break;
>  		VM_WARN_ON_ONCE(!!cur->vm_userfaultfd_ctx.ctx ^
>  				!!(cur->vm_flags & __VM_UFFD_FLAGS));
>
> @@ -3991,8 +4052,10 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>  		 * the one used for registration.
>  		 */
>  		if (cur->vm_userfaultfd_ctx.ctx &&
> -		    cur->vm_userfaultfd_ctx.ctx != ctx)
> +		    cur->vm_userfaultfd_ctx.ctx != ctx) {
> +			rcu_read_unlock();
>  			goto out_unlock;
> +		}
>
>  		/*
>  		 * Check not compatible vmas, not strictly required
> @@ -4001,11 +4064,14 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>  		 * provides for more strict behavior to notice
>  		 * unregistration errors.
>  		 */
> -		if (!vma_can_userfault(cur, cur->vm_flags, wp_async))
> +		if (!vma_can_userfault(cur, cur->vm_flags, wp_async)) {
> +			rcu_read_unlock();
>  			goto out_unlock;
> +		}
>
>  		found = true;
>  	} for_each_vma_range(vmi, cur, end);
> +	rcu_read_unlock();
>  	VM_WARN_ON_ONCE(!found);
>
>  	vma_iter_set(&vmi, start);
> diff --git a/mm/vma.c b/mm/vma.c
> index 35e7a64855fa..e00b0cdc3d83 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -614,10 +614,8 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	validate_mm(vma->vm_mm);
>
>  	/* Success. */
> -	if (new_below)
> -		vma_next(vmi);
> -	else
> -		vma_prev(vmi);
> +	vma_iter_set(vmi, vma->vm_start);
> +	vma_find(vmi, ULONG_MAX);
>
>  	return 0;
>
> @@ -1573,7 +1571,12 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
>  #endif
>  	}
>
> -	vms->next = vma_next(vms->vmi);
> +	/*
> +	 * The loop's cached node may be the one a split's store deferred.
> +	 * Continue from the range end.
> +	 */
> +	vma_iter_set(vms->vmi, vms->end);
> +	vms->next = vma_find(vms->vmi, ULONG_MAX);
>  	if (vms->next)
>  		vms->unmap_end = vms->next->vm_start;
>
> --
> 2.54.0
>

--
Cheers, Lorenzo

