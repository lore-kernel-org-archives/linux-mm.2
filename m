Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 535D210A88E6
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 17:45:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6065C6B0005; Thu, 26 Mar 2026 13:45:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DE336B0088; Thu, 26 Mar 2026 13:45:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3D16B008A; Thu, 26 Mar 2026 13:45:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BBE66B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:45:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B20CF5D7B4
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:45:09 +0000 (UTC)
X-FDA: 84588940338.10.0820007
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0D35A1C001A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:45:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uTA6AHCr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774547108; a=rsa-sha256;
	cv=none;
	b=VxFdGri+mSSUTmmdhS5qs9ox9l/sfFIIF6utFWZzV2MGEfd2HfPNuuWmV8v7PkXBFee9LF
	uq3sTFR08VssXGaJr+Mv6c/2XUSm/SxgrEhZHLVnPuAHSfslx6xy6Rzks1jS9lMejm7+n4
	KQWRyjJ3w9h8B87R3Px9J8yeAfApYYE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uTA6AHCr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774547108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84R4J996gyaRDGg0K8YqeERlQp70ut8qFSXCmIxFDnY=;
	b=bS7zUeEBCSshhGKbK6wHcZ1B+eOJQAwKPGei4Y6vshgLorl3ylPnLYuz/DyDgPxxu2zDmA
	A0HLnZp7gJipEUMFtlEfqvsHEgRGYQgDBiKajcB8rZENWJnpkW322mTWuZFjUpriay+l3q
	N7QQDiayxvgVAdgV7+g4xT3BPkiQkUg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 46943600AC;
	Thu, 26 Mar 2026 17:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D585C116C6;
	Thu, 26 Mar 2026 17:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774547107;
	bh=w2b5+NfbcqkMBxY/qLqmZHPuyfFesG4+GS6tIl1Zybg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uTA6AHCrIkzwHpTaMtek81hjInOoZjZD/Bjd7dNN7DziyxTKKPUUYUL2kMJleQEQA
	 detkHRGuMTSOXRdXLrcCFq162S3nkqqmsu9O72gy456HS6/ut8OcKc0mYKais7XO04
	 gEmbL3rqh0ao1trGqrijXziKbSZcNof8jXDICqk5eTWQTP+zzD/ej8zUbOs3wRCSZE
	 6w6Vtf+5rYoLRKDRic8RhsMj8Z4kU4Xz6X/wOEWynBY4ehDb5UNKGitLsZvEZKF2je
	 GEUjsci6jsvPG+WlPd3Wr6DaahnnlQ/3Llq363jsCiQxLTJw0zFnfmP+h2B6Lb23kK
	 8htu7gMQV99Dw==
Date: Thu, 26 Mar 2026 17:45:04 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org
Subject: Re: [PATCH v5 4/6] mm/vma: use vma_start_write_killable() in vma
 operations
Message-ID: <3574764c-1cac-401c-9183-6bc3d2627587@lucifer.local>
References: <20260326080836.695207-1-surenb@google.com>
 <20260326080836.695207-5-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326080836.695207-5-surenb@google.com>
X-Stat-Signature: 98g1wrbokjhb6e4y69iygcxkgk7t9e68
X-Rspamd-Queue-Id: 0D35A1C001A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774547107-729786
X-HE-Meta: U2FsdGVkX19+iPjJa7UbreiUd9tsO3fYla6WHwRGMdI+DKXEcgy66zhseGKmAUkfQbzqCYvCbGhKpyOVxj9MPZCQqjuXcXgQ7qDPVvU2gidZyqk042h/tfGdZLqX3ByYNwFy/lZpclpzmwnXp0iN2+f+nQu4QefrjC6sdDFg98Jfw6QbdoWqN45tL5Lp/VBZA/dIi29v7GWT1Kryutb4HXZRt4JjInFYFkW2oL5detFOmGBEiMN+lI7yq/tYt185xqj8HvHbXEQvSI3dKxqWK+Rn/1SoM9slByCkgMxkj49b3GMJMqJe2JA3ZpbRogc2HZ5qihOKnBQpKWiCldfUz5RHb0pMzv6GjIbhQtpmKhlXibqetKQuCgGZYhuRio7iVOW3shM6xtUug5JDC0tkiVeGKA55KQLB6au2J0XER3IX3K9cVU61yHENN5XRXNcV3A0ctijrqk3mbMryy+nL9A+rFD4gyGo9yUnMpMIYQnpqyJa0z58VcHyVAAO0SQ8HdK0AL97C4/eQ8GiYUKbWtE5l250Y3iUXPBRsn33xMa9B4rT6GuDoFLn/EruG8qrxUxE3itok817Kpd2vuhZcX0y9Ck9tYlkvzi4w3EPwPn1fqOKCbB2jFtVdHqeYngXW7/Nnq9DfrzrzDc+heSjiJ0U32EHswNkAam79YnPSGqCuslvRAra3erNCgSFEmoCanpdHIdAwJNkx4JrOPF62yLnfe34+DugsY9q55JOPuYVUQ1RZ0kGO6oAfd6TpnKxfeeF4FU36wESArn3RRhNMFxH2h0C1D7JMGxD7/7FrBxBnudho6N6h0oCl8i4Gb9BB4+NjkC5pC0lhiLmDZzn5lIx/xhvtQpENA3nvnCkfTUeTTVzg7mUmun4EcU4KhZnG7CbuJj08ZtunUDla93XHJuxUm7Va/1DsKLxlAR69dmPQpW+GRRgH3+6Uxx1mD6/WpHmA10ro9p1XaisVfaW
 ANfrrwLH
 7JOSz4SonkYPgRv/h1X464O53ikzujAwYrgefbpRBSQU6PkF+X1sSNLignIKX/c56lb/Htz5JinP62yffT5Cc1kj7NsPRM/nLtSTvKvubY95nS0ZXaQtR9v+41JJ940CDx3VhnjH0INgeofFdbEtsozMPYiPb4px6m8yodM6yIoF7zqzJM8PRwcLCrhykJ3Zpg/ytfr3VgyKpQQzFBLASnC3BMPkNpZrJeI9xpux3mF+6BS6YnZE27CN1/qtnkpsKxSdqx2qPPxn22ewcSFzoCLdnB8L8WGPHF7nTzepUI3u8rTeoYa61tqOEDwWKxdSOfZGGgrqOX5lh3bvmCDm5kDuOz7LPiqM1lBrCJRPZCpdi9KB2OEgyI+0E+7M/dWkpb67NU2nzdQK1ON3Uk0WJnT1kJOwNadtjixnmXI5DGIKHrUvnlwcxm+9pvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 01:08:34AM -0700, Suren Baghdasaryan wrote:
> Replace vma_start_write() with vma_start_write_killable(), improving
> reaction time to the kill signal.
> Replace vma_start_write() calls when we operate on VMAs.
>
> In a number of places we now lock VMA earlier than before to avoid
> doing work and undoing it later if a fatal signal is pending. This
> is safe because the moves are happening within sections where we
> already hold the mmap_write_lock, so the moves do not change the
> locking order relative to other kernel locks.
>
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/vma.c      | 130 +++++++++++++++++++++++++++++++++++++-------------
>  mm/vma_exec.c |   6 ++-
>  2 files changed, 101 insertions(+), 35 deletions(-)
>
> diff --git a/mm/vma.c b/mm/vma.c
> index ba78ab1f397a..7ee68fbfea03 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -524,6 +524,17 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
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
> +	err = vma_start_write_killable(new);
> +	if (err)
> +		goto out_free_vma;
> +
>  	err = -ENOMEM;
>  	vma_iter_config(vmi, new->vm_start, new->vm_end);
>  	if (vma_iter_prealloc(vmi, new))
> @@ -543,9 +554,6 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	if (new->vm_ops && new->vm_ops->open)
>  		new->vm_ops->open(new);
>
> -	vma_start_write(vma);
> -	vma_start_write(new);
> -
>  	init_vma_prep(&vp, vma);
>  	vp.insert = new;
>  	vma_prepare(&vp);
> @@ -900,12 +908,22 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
>  	}
>
>  	/* No matter what happens, we will be adjusting middle. */
> -	vma_start_write(middle);
> +	err = vma_start_write_killable(middle);
> +	if (err) {
> +		/* Ensure error propagates. */

Thanks! I will come back to this and clean all this up later.

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
> @@ -914,7 +932,12 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
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
> @@ -1170,10 +1193,12 @@ int vma_expand(struct vma_merge_struct *vmg)
>  	vma_flags_t sticky_flags =
>  		vma_flags_and_mask(&vmg->vma_flags, VMA_STICKY_FLAGS);
>  	vma_flags_t target_sticky;
> -	int err = 0;
> +	int err;
>
>  	mmap_assert_write_locked(vmg->mm);
> -	vma_start_write(target);
> +	err = vma_start_write_killable(target);
> +	if (err)
> +		return err;
>
>  	target_sticky = vma_flags_and_mask(&target->flags, VMA_STICKY_FLAGS);
>
> @@ -1201,6 +1226,13 @@ int vma_expand(struct vma_merge_struct *vmg)
>  	 * we don't need to account for vmg->give_up_on_mm here.
>  	 */
>  	if (remove_next) {
> +		/*
> +		 * Lock the VMA early to avoid extra work if fatal signal
> +		 * is pending.
> +		 */
> +		err = vma_start_write_killable(next);
> +		if (err)
> +			return err;
>  		err = dup_anon_vma(target, next, &anon_dup);
>  		if (err)
>  			return err;
> @@ -1214,7 +1246,6 @@ int vma_expand(struct vma_merge_struct *vmg)
>  	if (remove_next) {
>  		vma_flags_t next_sticky;
>
> -		vma_start_write(next);
>  		vmg->__remove_next = true;
>
>  		next_sticky = vma_flags_and_mask(&next->flags, VMA_STICKY_FLAGS);
> @@ -1252,9 +1283,14 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
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
> @@ -1263,8 +1299,6 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	if (vma_iter_prealloc(vmi, NULL))
>  		return -ENOMEM;
>
> -	vma_start_write(vma);
> -
>  	init_vma_prep(&vp, vma);
>  	vma_prepare(&vp);
>  	vma_adjust_trans_huge(vma, start, end, NULL);
> @@ -1453,7 +1487,9 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
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
> @@ -1848,12 +1884,16 @@ static void vma_link_file(struct vm_area_struct *vma, bool hold_rmap_lock)
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
> @@ -2239,9 +2279,8 @@ int mm_take_all_locks(struct mm_struct *mm)
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
> @@ -2540,8 +2579,8 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
>  	struct mmap_action *action)
>  {
>  	struct vma_iterator *vmi = map->vmi;
> -	int error = 0;
>  	struct vm_area_struct *vma;
> +	int error;
>
>  	/*
>  	 * Determine the object being mapped and call the appropriate
> @@ -2552,6 +2591,14 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
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
> @@ -2582,8 +2629,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
>  	WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
>  #endif
>
> -	/* Lock the VMA since it is modified after insertion into VMA tree */
> -	vma_start_write(vma);
>  	vma_iter_store_new(vmi, vma);
>  	map->mm->map_count++;
>  	vma_link_file(vma, action->hide_from_rmap_until_complete);
> @@ -2878,6 +2923,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  		 unsigned long addr, unsigned long len, vma_flags_t vma_flags)
>  {
>  	struct mm_struct *mm = current->mm;
> +	int err;
>
>  	/*
>  	 * Check against address space limits by the changed size
> @@ -2910,24 +2956,33 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
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
> @@ -2942,10 +2997,11 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
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
> @@ -3112,8 +3168,8 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
>  	struct mm_struct *mm = vma->vm_mm;
>  	struct vm_area_struct *next;
>  	unsigned long gap_addr;
> -	int error = 0;
>  	VMA_ITERATOR(vmi, mm, vma->vm_start);
> +	int error;
>
>  	if (!vma_test(vma, VMA_GROWSUP_BIT))
>  		return -EFAULT;
> @@ -3149,12 +3205,14 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
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
> @@ -3183,8 +3241,10 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
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
> @@ -3197,8 +3257,8 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	struct vm_area_struct *prev;
> -	int error = 0;
>  	VMA_ITERATOR(vmi, mm, vma->vm_start);
> +	int error;
>
>  	if (!vma_test(vma, VMA_GROWSDOWN_BIT))
>  		return -EFAULT;
> @@ -3228,12 +3288,14 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
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
> @@ -3263,8 +3325,10 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
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

