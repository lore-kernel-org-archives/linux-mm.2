Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39049C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 07:41:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 193636B092D; Mon, 17 Aug 2026 03:41:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 145846B092F; Mon, 17 Aug 2026 03:41:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F28E56B0930; Mon, 17 Aug 2026 03:41:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3FCB6B092D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:41:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F1831606AC
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:41:15 +0000 (UTC)
X-FDA: 85109965710.19.D875606
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id A2B3820003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 07:41:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z+tlLekJ;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786952473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EmziZaZv/cLbV513MDuzagnh1jExWrpF47K9zKIYMcU=;
	b=jPmPU02AFMu1gpRJWpgsebPfpSc/Tg6rYXnwRMljux/U7pA+K+9fkAJZqoCy6aanxhNmXU
	qFFdJFJlbDgqelXxjgrdAVZ5wEFX5nsrPsRkL/4mkBi3evUFDzqq+HImQDtTEzYAK6eI66
	qBVuyDJ7aoCxYKRU879C6hMeHeXipS0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z+tlLekJ;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786952473;
	b=GNu864Pr4xxsETBE1dH9S+IGdMO9ZjcC+Lb3/JACnpydEu8QLVBxEZA52iG7WDyYkKUJJs
	T7fpM06WTtB7Q1lgw0KjPnafTPckJpBqI956ejseRGqN1nJGjbRtw7p/ZMDN2USa5HjGcw
	0fyJe3inFi/jfErONPGTC2fZ4LSH1hs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A925600AE;
	Mon, 17 Aug 2026 07:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB8B1F000E9;
	Mon, 17 Aug 2026 07:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786952472;
	bh=EmziZaZv/cLbV513MDuzagnh1jExWrpF47K9zKIYMcU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z+tlLekJzmSV2i7sOPawC9tGNESkdNn0F8lCQCJ/GJlbciVsvA21KbfypuVpB1N72
	 ayhXh9QG6klPR8NW4Y5OL2Xz9XEWfOFJiOijYK9M+7i6lpfxESIq8WlKnCTq2M+jXb
	 uyZ5oKebW8nHMDeqnxsTt9MMz+BVIhpqsAFOhefkjlfGIAkpsxBBJZcfhkge/kva3i
	 RuQF1l3io7no+1g6g7EvWMOpskVUkbr8SJl4ExQp8MjHDKoXAUrDqlkbZQpMl9ETBR
	 N2HRD2hRBZiwjVjCcMp1MFo85Jo7ndRY7zFYrlGPqM9FGgFVEvOnbW4GHcQ6AglcQ8
	 q+Z6Fit2QeCsg==
Date: Mon, 17 Aug 2026 08:40:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, hughd@google.com, 
	ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com, 
	ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: shmem: fix incorrect vm_flags usage when checking
 allowable orders
Message-ID: <aoK3JcBYe_JuydGm@lucifer>
References: <ed34ca03ae7d65e89467fb87bc961f5497049c00.1786948410.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed34ca03ae7d65e89467fb87bc961f5497049c00.1786948410.git.baolin.wang@linux.alibaba.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A2B3820003
X-Stat-Signature: tarzxj3gpnfs9t3h5gm49s5rzp41dfuh
X-Rspam-User: 
X-HE-Tag: 1786952473-533343
X-HE-Meta: U2FsdGVkX1/hBPVr/dnTYvoRshNCy6UhiXvcaFm4rZ3ghVEoSm4wUkFkTec77ngu+ChomLf5Hw4ouqmLRNz5UrythN7I+80hSztoiYOZoDvX1YQw3s44yDUMl7DFwaljkzvQL0X9EzQK6kFlfauMum6DqIFOw3vGv27o7y+v8Xfi85Ykd8pRUl5be3m09pKJw8L1uirPctW74cMk0WgEsJEB3lSToEBzge0jGy4lFmWNMr1ELp7PhVbyJ5uJCmE8nv/qSeIU0fcdM8btEE02QwEOXonH8MJXkvgGe/9L6gQnvrYwsOB/OHjpiBZhGcfxR8AuzIFs6V4Qnz0QYh5GLCQQdlS0r9c4FBScPzGMErf0lAeGfCWPqin2plOST9OV6UDleSlH8PDIpEWhsuN7iDvadmacQ/oBYj+qcWQzNJ7g/JwtBg2qfIEHX4yC484r0qtPxjH1VtYD/9gitZKuYfhnrK7oiFSTolAPupgtviyffmGSXRYuynjNZc0vT1q0rNJcVk+XRW6HXaoVOtxxY+D2rBeON0em5A3RVhedbOAALYiqiSVhxWdEXM0GP8Te4JiYdEApOfFbGojO6FAHPIp2Po3MCOYDZZe5mB9eNYDVfnYYhrBXgauS4j6ObZX8LFLniLBzEEV2+ln4OAM6z8AOdVIU3/3Pke8C37t3WU6tcLOlKL3apJjm187QBBhBneyCzhlUkr0j4C9fgZi9+aVVxYiVC6yWpRakWcqPU2Lfrtq0w9OaMpV3HyrGa1eWqlvylk/u6Wd0RvQ7hApwNdyv5h4rEMNBS8fhEh8ZO0BtFvvCukEoFIny0bSY0JkTIZ6Mojo+2a/ocN4Kgz/+54oaY3dDPozbmRiz2Re2CKuYwh2tM991+nRAaMRPAHx7cn/P1kb4VSy4XlBjTC1V0GkgkYmGvhMsTrS4X2o3LfwTGAyB2CA3SZ+Q4fUhqxFw5n3s1jk6c5QbPDtRRxo
 N3J1MUmF
 r5226dQg+KCzoJ2sjQ6/m5xUIoJq8SmLk/6/Ua3xxgqZK+5s3sCbfuKhQAwTI+JbB/Co8erHse6auU/m4bRVGceKgo93uVVOsxBplhKiokrrnP9uCC7flRG88M3swMIrcbpCS4LZMfuS6yJwZMZ1Aw8vb2q1wyvYiOJN+yHrfwCjoQF30Svt1UIIggoJykUjZnLrqr3NiqjlozamCsyJD9paBsu03yU9rX9NRi26fE2EQ3D9fcA1q9O/KhOUydtEWGseP9hEBgjhn3WWDMNbCZc+beVh99OOLGgdLaxWM2wg6C0oXaYWUUXglAPFPABTwLycJMyMoy5foxW3OojkHOl5RL4AqtCAKXD73
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 03:16:43PM +0800, Baolin Wang wrote:
> Lance reported that when MADV_HUGEPAGE is set on a tmpfs file mounted with
> huge=advise option, khugepaged fails the allowable order check and does not
> scan the tmpfs file for collapse.

Ugh.

But really I think this isn't quite accurate - what you mean to say I think is
that when _nothing else_ causes the mm to be considered for khugepaged collapse,
an MADV_HUGEPAGE-advised tmpfs VMA alone does not cause scanning to commence.

>
> After commit 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into
> shmem_allowable_huge_orders()"), the shmem/tmpfs allowable order check reads
> vma->vm_flags directly.  However, when MADV_HUGEPAGE is handled,
> khugepaged_enter_vma() is called before the VMA's vm_flags have been updated,
> so the check uses stale flags and incorrectly rejects the VMA for collapse.
> As a result, khugepaged does not collapse the tmpfs file into PMD order in time.

Could we at least refer to the non-deprecated field in the commit message?
i.e. vma->flags.

Probably worth mentioning VMA_HUGEPAGE_BIT also.

>
> Fix this by passing vm_flags as a parameter to shmem_allowable_huge_orders()
> instead of reading it from the vm_area_struct.

Ugh this is so disgusting.

I understand this is a fix for a bug to be backported but couldn't we just
achieve the same without having to add a deprecated field to be passed around?

As you say the khugepaged_enter_vma() isn't really so helpful in
hugepage_madvise().

But you could add this to the bottom of madvise_update_vma():

	if (vma_flags_test(&new_vma_flags, VMA_HUGEPAGE_BIT))
		khugepaged_enter_vma(vma, new_flags);

I don't think this is really egregious on this code path and could go some way
towards us eliminating the silly thing of passing around flags-to-be-set.

And yeah you'd endure a little backport pain on switching that new_vma_flags
vma_flags_t test to a new_flags vm_flags_t test but it's not so bad :)

I will be doing a series soon that improves the allowable orders vomit-a-thon
somewhat in tip :)

>
> Reported-by: Lance Yang <lance.yang@linux.dev>
> Closes: https://lore.kernel.org/all/20260815181632.21453-1-lance.yang@linux.dev/
> Fixes: 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge_orders()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  include/linux/shmem_fs.h | 8 ++++----
>  mm/huge_memory.c         | 2 +-
>  mm/shmem.c               | 9 +++++----
>  3 files changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index 5663dff53186..321017e0fd63 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -127,13 +127,13 @@ int shmem_unuse(unsigned int type);
>
>  #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
>  unsigned long shmem_allowable_huge_orders(struct inode *inode,
> -				struct vm_area_struct *vma, pgoff_t index,
> -				loff_t write_end, bool shmem_huge_force);
> +		struct vm_area_struct *vma, vm_flags_t vm_flags,
> +		pgoff_t index, loff_t write_end, bool shmem_huge_force);
>  bool shmem_hpage_pmd_enabled(void);
>  #else
>  static inline unsigned long shmem_allowable_huge_orders(struct inode *inode,
> -				struct vm_area_struct *vma, pgoff_t index,
> -				loff_t write_end, bool shmem_huge_force)
> +		struct vm_area_struct *vma, vm_flags_t vm_flags, pgoff_t index,
> +		loff_t write_end, bool shmem_huge_force)
>  {
>  	return 0;
>  }
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ced400f72d43..70f57d700739 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -187,7 +187,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>  	 */
>  	if (!in_pf && shmem_file(vma->vm_file))
>  		return orders & shmem_allowable_huge_orders(file_inode(vma->vm_file),
> -						   vma, vma_start_pgoff(vma), 0,
> +						   vma, vm_flags, vma_start_pgoff(vma), 0,
>  						   forced_collapse);
>
>  	if (!vma_is_anonymous(vma)) {
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 599665a3d6e7..6f1ad5456aca 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1834,12 +1834,11 @@ bool shmem_hpage_pmd_enabled(void)
>  }
>
>  unsigned long shmem_allowable_huge_orders(struct inode *inode,
> -				struct vm_area_struct *vma, pgoff_t index,
> -				loff_t write_end, bool shmem_huge_force)
> +		struct vm_area_struct *vma, vm_flags_t vm_flags,
> +		pgoff_t index, loff_t write_end, bool shmem_huge_force)
>  {
>  	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
>  	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
> -	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
>  	unsigned int global_orders;
>
>  	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
> @@ -2430,6 +2429,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>  		gfp_t gfp, struct vm_fault *vmf, vm_fault_t *fault_type)
>  {
>  	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
> +	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
>  	struct mm_struct *fault_mm;
>  	struct folio *folio;
>  	int error;
> @@ -2507,7 +2507,8 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>  	}
>
>  	/* Find hugepage orders that are allowed for anonymous shmem and tmpfs. */
> -	orders = shmem_allowable_huge_orders(inode, vma, index, write_end, false);
> +	orders = shmem_allowable_huge_orders(inode, vma, vm_flags, index,
> +					     write_end, false);
>  	if (orders > 0) {
>  		gfp_t huge_gfp;
>
> --
> 2.47.3
>

--
Cheers, Lorenzo

