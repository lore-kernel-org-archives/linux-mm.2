Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8757FF60FB
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE97B6B00A0; Tue, 31 Mar 2026 06:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9A1C6B00A1; Tue, 31 Mar 2026 06:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB01F6B00A2; Tue, 31 Mar 2026 06:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9743B6B00A0
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:24:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 32359E14C2
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:24:25 +0000 (UTC)
X-FDA: 84605973690.29.392A9F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 993B8C0002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:24:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WwVeagit;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774952663; a=rsa-sha256;
	cv=none;
	b=XgFibzA+SYgkD8bDEc5wa2YpBoH9my/E7x7ZOYuXK/zcCM10VCFLIvrqmw/gmrLr0MIGcG
	2qu0K0Ynlj+BQVCpEL/9uJ/eOY/w48u7hhYmN066GQ9N/DNI/gbtiJqBiwapymc6hiDLMZ
	RqLjjeAfGFcYLIc9YaIF5AxiE5CkLuI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WwVeagit;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774952663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZaOpfnGJTckGpmJMKMB5JFrZ7NgrKlza6jV5tssKKUg=;
	b=UztKIxmYJv+6oomIqxGiXRpDbjZX6lemPD+XrviCBT0DJkWr2w7+8DTJERDDNxDGzi1nhv
	Nq4aHdn80agom6ZOdHVVSNyPxadknCb3VVRWyTMcmFO+yFORk48QCiZrwm23vIEE+tyTLq
	oBCZIuA15scpLkwMNqa1Oeplk62CTWo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ED4F560128;
	Tue, 31 Mar 2026 10:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3A8C2BCB0;
	Tue, 31 Mar 2026 10:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774952662;
	bh=AL3HHHNax4t8yI0kpaJ3XvjHyHJTZAeWSoqv/QN9stM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WwVeagitKrcgeAkw3F41Dh8kVRZ6Pdv5+hPGwb5IWeSdV1Rp5+RnEWSV4oZHEG1Sj
	 EImspGEvG3U5j82mGNEHsNEFO/C9/8bhylIlmocdUjtxoAedEU7HVJ8inGE7URRB3Q
	 PCXiQ7Wnw01R28mgzt/eSvtW/ZD8C7WbYpieSw9GT4Ti56I7YbUqIlwYXZGOUk7by7
	 f3NuIWh/tkwF4r1BVpoMkkoLunbTunk73KdBqdl5tJH4xDtRzWpAxOkc+YW471iwlI
	 To1Ux0s/tjTFr7wndXBK5THUVjB58zpsUWtX6vm0Aj5SXqo21orRAPHemtYqxrOanz
	 x+audNO8j/sUQ==
Date: Tue, 31 Mar 2026 11:24:21 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, 
	rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, 
	maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, hca@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v6 4/6] mm/vma: use vma_start_write_killable() in vma
 operations
Message-ID: <e490c85f-e1e6-4722-9399-e4743549a390@lucifer.local>
References: <20260327205457.604224-1-surenb@google.com>
 <20260327205457.604224-5-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327205457.604224-5-surenb@google.com>
X-Stat-Signature: gstkiho3cz786dtzd9azkmzjjsps1gio
X-Rspamd-Queue-Id: 993B8C0002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774952663-96047
X-HE-Meta: U2FsdGVkX18TPXgsDl2Sv3yz3uz/WdWQJlTBl+dxdUmd912xEZEU/TiMwntji38/TxScfRjOz2GkDNlOP3RLAoJPiNK9mvaW6KvnymrFcWew9VI/ucYjXPVDQgbIMsYrfkpM/SusKB5s4UgrBp4iEJo5FH3UVTyYe/M+ZbfnvG0pZ/MalPpBlSaP+jGtiAl6dS9pU0JPDh7sfVKksv+Bpv4Fmfmp+C69+hpy/E2uv+KX696CEtZm3go0+Z1YXjeCUlV0+v8d0Iw3/MNtiU22qDP9OOzJfpiUIQjO1oPffQfs6Oxn0YSFzpa9ol67A0In6FgTGORn8iWXdh7bLobrYf8op2WEYC8p6OpMCuBQ2D1i0jaDF5dcssy8buCXtGq4I4aW+Fj0Z+xlA/ce+NgTiTWHGKh7YV3K16Rh7DA7gcYJnYD2GHOVazmtDpQ6CR7bUKX23ydJ/l33jj+68tiDk8Q1TFgOzN8p5/QjX7dgYBbzEFNFSrL08umY/xV4mBzRcDvANDECv4RcaHpcuQcjkm2CCh6qaUoZXlTyZ7aJtlpEzQAb/7doamM4Q03JbkzcjGAml8cXlIwx0sv35fE1zCoQsosX9S/eBGgKYKuNfxMP6QaHJNLkRCP5FZLgkqX2LjxbxgStEdHFWWASH6aD+f8w5atHNtDh4U5cIOpR/D88VjZjNcmKz2PYBCCcp/qvkN4zYAyd3xo77ycWYBR7s1y/OfnYpZBxwj3JobBc2zmgEv0NTjQNlSLuSNRAKvd1dTKq0tg2ezfd77DXmmjq+mI+CoDAiS4ZW4Ti8opb43X4c03OQmaUsr9/pwwKCT73xK3hKQlQImy9zjM+S5zpzWGxmUsyXmwbd0xZlPQeNiyP76y8u9Bsyf0LCbzoj5xx/fVSsM8ltjkzbD1dIVbQqcClmhkTvGTcskuI04dCa4E8hZANAy8Wai0wXpx3x5itRKc4giphcqC9PBWMhmt
 pYAMwoKM
 3r3uVSI+xRM4AzF2y2af5T0+MuauulbHITmb0YK+9FzDdR44CCxOvjpVemJvlhb8HypsyypuGbJyqK3mR9GRSbbXs6uncdMUMFgohV3ltrv7qPzpgGe7nBQ4MTpBbdfhbeot8K/U8CfcCQbQAVlKx3tCbcyAbEvfuzjE5rvNs0kQEthR+9yH/ziyii6osTTeBHZT7dorDuoG4sVJThppAjTxk6YX+lNfdh3tHTFrdIitBTKSgSQP9TzvoqYOp6R5ZnZmQBCzEtd5nvbmajDuYL+EwJB03f4zWkdqQJsswjk0ksV0zErKAEPWmYEEqrL29ANjCYNrF9xjHo50uBnpV6iG0ow3MYX/r8djFUHcr/LGdsfAsRVVyZ0j72WBX16d0p1Pm+wsNAM9w4XTL6EWuL8E59YIzZ3Lp2Y+6XvVW/XOs1HAc4606P3t01Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 01:54:55PM -0700, Suren Baghdasaryan wrote:
> Replace vma_start_write() with vma_start_write_killable(), improving
> reaction time to the kill signal.
> Replace vma_start_write() calls when we operate on VMAs.
>
> To propagate errors from vma_merge_existing_range() and vma_expand()
> we fake an ENOMEM error when we fail due to a pending fatal signal.
> This is a temporary workaround. Fixing this requires some refactoring
> and will be done separately in the future.
>
> In a number of places we now lock VMA earlier than before to avoid
> doing work and undoing it later if a fatal signal is pending. This
> is safe because the moves are happening within sections where we
> already hold the mmap_write_lock, so the moves do not change the
> locking order relative to other kernel locks.
>
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  mm/vma.c      | 146 ++++++++++++++++++++++++++++++++++++++------------
>  mm/vma_exec.c |   6 ++-
>  2 files changed, 117 insertions(+), 35 deletions(-)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index ba78ab1f397a..cc382217f730 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -524,6 +524,21 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  		new->vm_pgoff += ((addr - vma->vm_start) >> PAGE_SHIFT);
>  	}
>
> +	/*
> +	 * Lock VMAs before cloning to avoid extra work if fatal signal
> +	 * is pending.
> +	 */
> +	err = vma_start_write_killable(vma);
> +	if (err)
> +		goto out_free_vma;
> +	/*
> +	 * Locking a new detached VMA will always succeed but it's just a
> +	 * detail of the current implementation, so handle it all the same.
> +	 */
> +	err = vma_start_write_killable(new);
> +	if (err)
> +		goto out_free_vma;
> +
>  	err = -ENOMEM;
>  	vma_iter_config(vmi, new->vm_start, new->vm_end);
>  	if (vma_iter_prealloc(vmi, new))
> @@ -543,9 +558,6 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	if (new->vm_ops && new->vm_ops->open)
>  		new->vm_ops->open(new);
>
> -	vma_start_write(vma);
> -	vma_start_write(new);
> -
>  	init_vma_prep(&vp, vma);
>  	vp.insert = new;
>  	vma_prepare(&vp);
> @@ -900,12 +912,22 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
>  	}
>
>  	/* No matter what happens, we will be adjusting middle. */
> -	vma_start_write(middle);
> +	err = vma_start_write_killable(middle);
> +	if (err) {
> +		/* Ensure error propagates. */
> +		vmg->give_up_on_oom = false;
> +		goto abort;
> +	}
>
>  	if (merge_right) {
>  		vma_flags_t next_sticky;
>
> -		vma_start_write(next);
> +		err = vma_start_write_killable(next);
> +		if (err) {
> +			/* Ensure error propagates. */
> +			vmg->give_up_on_oom = false;
> +			goto abort;
> +		}
>  		vmg->target = next;
>  		next_sticky = vma_flags_and_mask(&next->flags, VMA_STICKY_FLAGS);
>  		vma_flags_set_mask(&sticky_flags, next_sticky);
> @@ -914,7 +936,12 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
>  	if (merge_left) {
>  		vma_flags_t prev_sticky;
>
> -		vma_start_write(prev);
> +		err = vma_start_write_killable(prev);
> +		if (err) {
> +			/* Ensure error propagates. */
> +			vmg->give_up_on_oom = false;
> +			goto abort;
> +		}
>  		vmg->target = prev;
>
>  		prev_sticky = vma_flags_and_mask(&prev->flags, VMA_STICKY_FLAGS);
> @@ -1170,10 +1197,18 @@ int vma_expand(struct vma_merge_struct *vmg)
>  	vma_flags_t sticky_flags =
>  		vma_flags_and_mask(&vmg->vma_flags, VMA_STICKY_FLAGS);
>  	vma_flags_t target_sticky;
> -	int err = 0;
> +	int err;
>
>  	mmap_assert_write_locked(vmg->mm);
> -	vma_start_write(target);
> +	err = vma_start_write_killable(target);
> +	if (err) {
> +		/*
> +		 * Override VMA_MERGE_NOMERGE to prevent callers from
> +		 * falling back to a new VMA allocation.
> +		 */
> +		vmg->state = VMA_MERGE_ERROR_NOMEM;
> +		return err;
> +	}
>
>  	target_sticky = vma_flags_and_mask(&target->flags, VMA_STICKY_FLAGS);
>
> @@ -1201,6 +1236,19 @@ int vma_expand(struct vma_merge_struct *vmg)
>  	 * we don't need to account for vmg->give_up_on_mm here.
>  	 */
>  	if (remove_next) {
> +		/*
> +		 * Lock the VMA early to avoid extra work if fatal signal
> +		 * is pending.
> +		 */
> +		err = vma_start_write_killable(next);
> +		if (err) {
> +			/*
> +			 * Override VMA_MERGE_NOMERGE to prevent callers from
> +			 * falling back to a new VMA allocation.
> +			 */

I don't think we need huge, duplicated comments everywhere.

I don't like us effectively lying about an OOM.

Here's what I said on v4:

https://lore.kernel.org/all/9845b243-1984-4d74-9feb-d9d28757fba6@lucifer.local/

	I think we need to update vma_modify():

		/* First, try to merge. */
		merged = vma_merge_existing_range(vmg);
	        if (merged)
	                return merged;
	        if (vmg_nomem(vmg))
	                return ERR_PTR(-ENOMEM);
	+       if (fatal_signal_pending(current))
	+               return -EINTR;

OK I see you replied:

	We need to be careful here. I think there are cases when vma is
	modified from a context of a different process, for example in
	process_madvise(). fatal_signal_pending(current) would yield incorrect
	result because vma->vm_mm is not the same as current->mm.

Sorry missed that.

That's utterly horrible, yes.

I'm sorry but I think this series then is going to have to wait for me to rework
this code, unfortunately.

I can't really stand you returning a fake error code it's too confusing.

I guess I'll have to go do that as a priority then and maybe queue it up so it's
kinda ready for 7.2.

In any case I said in reply to the cover, I think this series is going to have
to wait for next cycle (i.e. 7.2), sorry. Just too many functional changes in
this revision.

> +			vmg->state = VMA_MERGE_ERROR_NOMEM;
> +			return err;
> +		}
>  		err = dup_anon_vma(target, next, &anon_dup);
>  		if (err)
>  			return err;
> @@ -1214,7 +1262,6 @@ int vma_expand(struct vma_merge_struct *vmg)
>  	if (remove_next) {
>  		vma_flags_t next_sticky;
>
> -		vma_start_write(next);
>  		vmg->__remove_next = true;
>
>  		next_sticky = vma_flags_and_mask(&next->flags, VMA_STICKY_FLAGS);
> @@ -1252,9 +1299,14 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	       unsigned long start, unsigned long end, pgoff_t pgoff)
>  {
>  	struct vma_prepare vp;
> +	int err;
>
>  	WARN_ON((vma->vm_start != start) && (vma->vm_end != end));
>
> +	err = vma_start_write_killable(vma);
> +	if (err)
> +		return err;
> +
>  	if (vma->vm_start < start)
>  		vma_iter_config(vmi, vma->vm_start, start);
>  	else
> @@ -1263,8 +1315,6 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	if (vma_iter_prealloc(vmi, NULL))
>  		return -ENOMEM;
>
> -	vma_start_write(vma);
> -
>  	init_vma_prep(&vp, vma);
>  	vma_prepare(&vp);
>  	vma_adjust_trans_huge(vma, start, end, NULL);
> @@ -1453,7 +1503,9 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
>  			if (error)
>  				goto end_split_failed;
>  		}
> -		vma_start_write(next);
> +		error = vma_start_write_killable(next);
> +		if (error)
> +			goto munmap_gather_failed;
>  		mas_set(mas_detach, vms->vma_count++);
>  		error = mas_store_gfp(mas_detach, next, GFP_KERNEL);
>  		if (error)
> @@ -1848,12 +1900,16 @@ static void vma_link_file(struct vm_area_struct *vma, bool hold_rmap_lock)
>  static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
>  {
>  	VMA_ITERATOR(vmi, mm, 0);
> +	int err;
> +
> +	err = vma_start_write_killable(vma);
> +	if (err)
> +		return err;
>
>  	vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
>  	if (vma_iter_prealloc(&vmi, vma))
>  		return -ENOMEM;
>
> -	vma_start_write(vma);
>  	vma_iter_store_new(&vmi, vma);
>  	vma_link_file(vma, /* hold_rmap_lock= */false);
>  	mm->map_count++;
> @@ -2239,9 +2295,8 @@ int mm_take_all_locks(struct mm_struct *mm)
>  	 * is reached.
>  	 */
>  	for_each_vma(vmi, vma) {
> -		if (signal_pending(current))
> +		if (signal_pending(current) || vma_start_write_killable(vma))
>  			goto out_unlock;
> -		vma_start_write(vma);
>  	}
>
>  	vma_iter_init(&vmi, mm, 0);
> @@ -2540,8 +2595,8 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
>  	struct mmap_action *action)
>  {
>  	struct vma_iterator *vmi = map->vmi;
> -	int error = 0;
>  	struct vm_area_struct *vma;
> +	int error;
>
>  	/*
>  	 * Determine the object being mapped and call the appropriate
> @@ -2552,6 +2607,14 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
>  	if (!vma)
>  		return -ENOMEM;
>
> +	/*
> +	 * Lock the VMA early to avoid extra work if fatal signal
> +	 * is pending.
> +	 */
> +	error = vma_start_write_killable(vma);
> +	if (error)
> +		goto free_vma;
> +
>  	vma_iter_config(vmi, map->addr, map->end);
>  	vma_set_range(vma, map->addr, map->end, map->pgoff);
>  	vma->flags = map->vma_flags;
> @@ -2582,8 +2645,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
>  	WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
>  #endif
>
> -	/* Lock the VMA since it is modified after insertion into VMA tree */
> -	vma_start_write(vma);
>  	vma_iter_store_new(vmi, vma);
>  	map->mm->map_count++;
>  	vma_link_file(vma, action->hide_from_rmap_until_complete);
> @@ -2878,6 +2939,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  		 unsigned long addr, unsigned long len, vma_flags_t vma_flags)
>  {
>  	struct mm_struct *mm = current->mm;
> +	int err;
>
>  	/*
>  	 * Check against address space limits by the changed size
> @@ -2910,24 +2972,33 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
>
>  		if (vma_merge_new_range(&vmg))
>  			goto out;
> -		else if (vmg_nomem(&vmg))
> +		if (vmg_nomem(&vmg)) {
> +			err = -ENOMEM;
>  			goto unacct_fail;
> +		}
>  	}
>
>  	if (vma)
>  		vma_iter_next_range(vmi);
>  	/* create a vma struct for an anonymous mapping */
>  	vma = vm_area_alloc(mm);
> -	if (!vma)
> +	if (!vma) {
> +		err = -ENOMEM;
>  		goto unacct_fail;
> +	}
>
>  	vma_set_anonymous(vma);
>  	vma_set_range(vma, addr, addr + len, addr >> PAGE_SHIFT);
>  	vma->flags = vma_flags;
>  	vma->vm_page_prot = vm_get_page_prot(vma_flags_to_legacy(vma_flags));
> -	vma_start_write(vma);
> -	if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL))
> +	if (vma_start_write_killable(vma)) {
> +		err = -EINTR;
> +		goto vma_lock_fail;
> +	}
> +	if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL)) {
> +		err = -ENOMEM;
>  		goto mas_store_fail;
> +	}
>
>  	mm->map_count++;
>  	validate_mm(mm);
> @@ -2942,10 +3013,11 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	return 0;
>
>  mas_store_fail:
> +vma_lock_fail:
>  	vm_area_free(vma);
>  unacct_fail:
>  	vm_unacct_memory(len >> PAGE_SHIFT);
> -	return -ENOMEM;
> +	return err;
>  }
>
>  /**
> @@ -3112,8 +3184,8 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
>  	struct mm_struct *mm = vma->vm_mm;
>  	struct vm_area_struct *next;
>  	unsigned long gap_addr;
> -	int error = 0;
>  	VMA_ITERATOR(vmi, mm, vma->vm_start);
> +	int error;
>
>  	if (!vma_test(vma, VMA_GROWSUP_BIT))
>  		return -EFAULT;
> @@ -3149,12 +3221,14 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
>
>  	/* We must make sure the anon_vma is allocated. */
>  	if (unlikely(anon_vma_prepare(vma))) {
> -		vma_iter_free(&vmi);
> -		return -ENOMEM;
> +		error = -ENOMEM;
> +		goto vma_prep_fail;
>  	}
>
>  	/* Lock the VMA before expanding to prevent concurrent page faults */
> -	vma_start_write(vma);
> +	error = vma_start_write_killable(vma);
> +	if (error)
> +		goto vma_lock_fail;
>  	/* We update the anon VMA tree. */
>  	anon_vma_lock_write(vma->anon_vma);
>
> @@ -3183,8 +3257,10 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
>  		}
>  	}
>  	anon_vma_unlock_write(vma->anon_vma);
> -	vma_iter_free(&vmi);
>  	validate_mm(mm);
> +vma_lock_fail:
> +vma_prep_fail:
> +	vma_iter_free(&vmi);
>  	return error;
>  }
>  #endif /* CONFIG_STACK_GROWSUP */
> @@ -3197,8 +3273,8 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	struct vm_area_struct *prev;
> -	int error = 0;
>  	VMA_ITERATOR(vmi, mm, vma->vm_start);
> +	int error;
>
>  	if (!vma_test(vma, VMA_GROWSDOWN_BIT))
>  		return -EFAULT;
> @@ -3228,12 +3304,14 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
>
>  	/* We must make sure the anon_vma is allocated. */
>  	if (unlikely(anon_vma_prepare(vma))) {
> -		vma_iter_free(&vmi);
> -		return -ENOMEM;
> +		error = -ENOMEM;
> +		goto vma_prep_fail;
>  	}
>
>  	/* Lock the VMA before expanding to prevent concurrent page faults */
> -	vma_start_write(vma);
> +	error = vma_start_write_killable(vma);
> +	if (error)
> +		goto vma_lock_fail;
>  	/* We update the anon VMA tree. */
>  	anon_vma_lock_write(vma->anon_vma);
>
> @@ -3263,8 +3341,10 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
>  		}
>  	}
>  	anon_vma_unlock_write(vma->anon_vma);
> -	vma_iter_free(&vmi);
>  	validate_mm(mm);
> +vma_lock_fail:
> +vma_prep_fail:
> +	vma_iter_free(&vmi);
>  	return error;
>  }
>
> diff --git a/mm/vma_exec.c b/mm/vma_exec.c
> index 5cee8b7efa0f..8ddcc791d828 100644
> --- a/mm/vma_exec.c
> +++ b/mm/vma_exec.c
> @@ -41,6 +41,7 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
>  	struct vm_area_struct *next;
>  	struct mmu_gather tlb;
>  	PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
> +	int err;
>
>  	BUG_ON(new_start > new_end);
>
> @@ -56,8 +57,9 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
>  	 * cover the whole range: [new_start, old_end)
>  	 */
>  	vmg.target = vma;
> -	if (vma_expand(&vmg))
> -		return -ENOMEM;
> +	err = vma_expand(&vmg);
> +	if (err)
> +		return err;
>
>  	/*
>  	 * move the page tables downwards, on failure we rely on
> --
> 2.53.0.1018.g2bb0e51243-goog
>

