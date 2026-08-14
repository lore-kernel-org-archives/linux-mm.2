Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BC31C5DF67
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 11:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E2B96B0305; Fri, 14 Aug 2026 07:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 594D46B0306; Fri, 14 Aug 2026 07:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AAEA6B0307; Fri, 14 Aug 2026 07:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 205286B0305
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:52:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 99131A0438
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:52:25 +0000 (UTC)
X-FDA: 85099712250.29.D241886
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D032240003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:52:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gIRx2ILw;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786708344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EXxOkb/zf8JaeyyejcZxkAssCQ4PIDtuWFoWpGN2+yw=;
	b=Jjb7bz8FQFieDya7l7ttR5MDTxTNg1y+nuTG8/J5tYW9/FM6OxRBm44yEDO80x9l23vMbo
	bWKxacSACe6FQTjkdEgVA9wUjVdP7A4M2xlAXCXuB4Oii7zTifA2vtd4IwwKlLGCAjew/A
	shS1BqKLHQWW1dmGykGMbYjhkhJ2ylc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gIRx2ILw;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786708344;
	b=nhMri/3FQdB45Wl4ponTU3vYlJFPdvaUj+45eWXREEBw45whvac4Asui/L00LFB+2VQlZz
	m37nuXMixYaVO0oTbteVG2Xji4G2T9y927cU0jHs8EVbgO1ETfmmP3bor1tHG5ZgciJLDs
	Fix0fNFDVRKtgY9UvFYwbKkSNV7V4bo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 09B4943F47;
	Fri, 14 Aug 2026 11:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545BF1F00A3A;
	Fri, 14 Aug 2026 11:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786708342;
	bh=EXxOkb/zf8JaeyyejcZxkAssCQ4PIDtuWFoWpGN2+yw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gIRx2ILw6DiX+v6C5y2Hf5hloNaIBaz77zq0G3mBKW1Uc8DZa4JIwFTIBcSdhLI/B
	 s1rgWuZSyfi96Z51g8ispEaptxoxuoxXxtx4+w+y7aEcG2MKtsoDjOR0uumVHVLZKw
	 P7akNXSuED8PWMyVDo7Tc7u3zb5VQZ7m2kzNcNVuvyNSRob84o3dsusPvoFXF84Bx6
	 a/MpM+XmOjOcP6vUyPq7A54ZUqnl8avGeA1gXAYjf+L8b5cqqSxu7Or6brAzoh0ZGj
	 JH7Iuvgky9DaPeu2TcqMcA5SzIpsIOmd2vUg2B13lUhE/gF27d12LopCXVlBWk07Qz
	 tr1OI0gGsTKrQ==
Date: Fri, 14 Aug 2026 12:52:05 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: linux-mm@kvack.org, geert@linux-m68k.org, daniel@thingy.jp, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Subject: Re: [RFC PATCH 1/6] mm: nommu: fix do_mremap() to correctly update
 internal states
Message-ID: <an77pELeQdW-sTEi@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <20260813063401.1786548-2-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813063401.1786548-2-thehajime@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D032240003
X-Stat-Signature: hjcwh965i5m5osbpy49uxohmgudua17m
X-Rspam-User: 
X-HE-Tag: 1786708343-491816
X-HE-Meta: U2FsdGVkX18Syrtl2bxpAidVZ7/RKiz4WeRUHA4cbLtAspVq5gvNLTxMIvVoHiHVV8VfaeoQ/mj90DIvR6TTXNgsIhKKUDHW4bncnnajMcoMoysEFM320xYW+hCgazmHz4XTWMWwrSw4u7xeT/NDuKtSvkhBINsIwfGbhEu54n4MRtydnG1zk0zq5M9WWLcDUz6rhl10q1+rsiQ6UwgE2s5sEbv5nYy5OpBMnPBC25NoTesRoclH+rYH2z0GS+MXj06uVUi+JWOfAA21w80CZJEfYY/TxHdCNzoIF3vg5En7e+0xVymgh7YwCr0ChbrYF3+F7ZxADfqt6DpG/LLjjQVwbUGMKmr0eZaxDovKRXOpSC/kTANVLiNOTmyRURkRwfk7ySKe+orXRU0W3x11KVTFN9SPxj6/WnXDXTE4zctXNg1ugM+cqNYdfOTaHcYFMf8U9r1zS955TaxOBaxZYWcWmfWsO9/98VnithYVELrphIwKNzum1VslBilh2BrVLKdZgN+iKEwp8J8DKS1+mMeIJROeP/xeChTYbIgr6crYYbIt5Rjrjn9/RzblyL+VQ5rdCHBir8CTXpN+nA4IzEl85hAOf9W/Kc8TSwSDCtZS0GHiuVq9dA+amtKmj1n77CbWP7NcEMibt0Axgf3D23qhKbATKBytymEqYEbCPSQ9jwY08Nlbo7Oesrg3pKuYThYlZsd0NK4co7puYjSpLfJbYMEREeX+8flMGKcTUmm6a3n2/NGYW3+zh1IEwJz0ucxh89I+yrmyxLUhK9Q5s9lU869Tk4RA5WelEQI9r85DDde/eZzOWrHLZNbrdEEeoEn3MP32KFVUCFjh+xNHo5IB3h8WNAX+Hye/QOTH8TmGaZsH2RZgPDXx9j7DAEhEzdF29BPNzoIz1uVrdrhloocIhcu54a1OLvsdQ/nxf5nTfXAzM25a/gQtsdHc3Sr5cAu9xvLZz39A2gTZfSV
 Hp6I6Kde
 mWVXyJH6VXQ7wY9nCaOiEzF1LkQkiL2USVL3tPj/tB4AQQygPQfNfZq67o+Cp4IK9TpWbopyAUDVtIxvNzQCgOExSBXGnwIzTCZzmE+Dj4hphHI93BRIJRFICKYPnSGNOP64A70OEAR6fsEigQWe0feGnNzvHPVGh61WZN+FGAszmVhyxEa4RFc0+5GhTtOKQJr0h1PM1IvORTZfqft7+cNrjOaQ/vApJaKZLSuyioIybgwl8croS0YLQlRndoEswTx74I9PkOCHgxby3slMURjxcb5O79WsazvfvF2gq8bNM//bru50/923Jx2xkE6RLkq+9H1zJNZW4zg6Z0cgdueKnTDaQ4Orri4oGQyeHWoKZNu5eJZ2pGfyRm/8B7pQCEqWPD/9H4vldZ7tr9xHQSeUbccy0BbIVLJiJCzpvcv3lY2Voqp7jyX46qonhgCxbNPjtv/7ovcpwwrv92zozrhiX9VxommiIVvPlE4OsxdyQTr3j2BStTIN5OGF6KnWcdf82vwOOItiZtAZJ1GPIWb276t7nOGO1lg7L0hc4Cj2B6DwKa2xS7zY2SaoqVcbTlR6Bzp9pXwZXmJUZglTZRoJqC9uGchXUpO+a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 03:33:56PM +0900, Hajime Tazaki wrote:
> When shrinking a VMA via mremap, the bounds are modified directly:
> mm/nommu.c:do_mremap() {
>     ...
>     vma->vm_end = vma->vm_start + new_len;
>     ...
> }
> This shrinks the VMA without updating its bounds in the maple tree.
> If the maple tree (mm->mm_mt) still contains the old bounds, a user
> process could access the freed portion. The stale maple tree would
> incorrectly return the shrunk VMA for an address past its new vm_end.
>
> This commit fixes this issue by calling vmi_shrink_vma() when shrink
> happens.  Additionally, if a file-backed, non-anonymous map is to be
> shrunk, it reports -EINVAL like do_munmap() does.
>
> Moreover, to maintain i_mmap interval tree, two functions,
> add_vma_to_mapping() and remove_vma_from_mapping(), are decoupled from
> setup_vma_to_mm() and cleanup_vma_from_mm() respectively.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Cc: linux-mm@kvack.org
> Closes: https://sashiko.dev/#/patchset/20260702012546.665383-1-thehajime@gmail.com
> Closes: https://sashiko.dev/#/patchset/20260710021028.892645-1-thehajime%40gmail.com
> Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

Fies: 8220543df148 ("nommu: remove uses of VMA linked list")?
Cc: stable?

But if you're going to do that, you really need to make this as small as
possible and maybe separate out everything but what is required to fix the bug.

>
> --
>
> v1 -> v2:
> - handle error when vmi_shrink_vma() failed (reported by Sashiko)
> - prevents mremap() with being shrunk for file-backed one like munmap()
> - consider i_mmap updates on shrink/expand by calling newly decoupled
>   functions, add_vma_to_mapping()/remove_vma_from_mapping()
>
> v1: https://lore.kernel.org/linux-mm/20260710021028.892645-1-thehajime@gmail.com/
> ---
>  mm/nommu.c | 147 ++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 124 insertions(+), 23 deletions(-)
>
> diff --git a/mm/nommu.c b/mm/nommu.c
> index ed3934bc2de4..89444ee2aca6 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -559,36 +559,51 @@ static void put_nommu_region(struct vm_region *region)
>  	__put_nommu_region(region);
>  }
>
> +static void add_vma_to_mapping(struct vm_area_struct *vma)
> +{
> +	struct address_space *mapping;
> +
> +	if (!vma->vm_file)
> +		return;
> +
> +	mapping = vma->vm_file->f_mapping;
> +	i_mmap_lock_write(mapping);
> +	flush_dcache_mmap_lock(mapping);
> +	vma_interval_tree_insert(vma, &mapping->i_mmap);
> +	flush_dcache_mmap_unlock(mapping);
> +	i_mmap_unlock_write(mapping);
> +}
> +
> +static void remove_vma_from_mapping(struct vm_area_struct *vma)
> +{
> +	struct address_space *mapping;
> +
> +	if (!vma->vm_file)
> +		return;
> +
> +	mapping = vma->vm_file->f_mapping;
> +	i_mmap_lock_write(mapping);
> +	flush_dcache_mmap_lock(mapping);
> +	vma_interval_tree_remove(vma, &mapping->i_mmap);

This function doesn't exist in mm-unstable, it's now mapping_rmap_tree_remove().

Please always base mm changes on
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/?h=mm-unstable

> +	flush_dcache_mmap_unlock(mapping);
> +	i_mmap_unlock_write(mapping);
> +}
> +
>  static void setup_vma_to_mm(struct vm_area_struct *vma, struct mm_struct *mm)
>  {
>  	vma->vm_mm = mm;
>
>  	/* add the VMA to the mapping */
> -	if (vma->vm_file) {
> -		struct address_space *mapping = vma->vm_file->f_mapping;
> -
> -		i_mmap_lock_write(mapping);
> -		flush_dcache_mmap_lock(mapping);
> -		vma_interval_tree_insert(vma, &mapping->i_mmap);
> -		flush_dcache_mmap_unlock(mapping);
> -		i_mmap_unlock_write(mapping);
> -	}
> +	if (vma->vm_file)
> +		add_vma_to_mapping(vma);

add_vma_to_mapping() also has a guard against vma->vm_file, either remove this
one or that one (this one seems better to remove).

>  }
>
>  static void cleanup_vma_from_mm(struct vm_area_struct *vma)
>  {
>  	vma->vm_mm->map_count--;
>  	/* remove the VMA from the mapping */
> -	if (vma->vm_file) {
> -		struct address_space *mapping;
> -		mapping = vma->vm_file->f_mapping;
> -
> -		i_mmap_lock_write(mapping);
> -		flush_dcache_mmap_lock(mapping);
> -		vma_interval_tree_remove(vma, &mapping->i_mmap);
> -		flush_dcache_mmap_unlock(mapping);
> -		i_mmap_unlock_write(mapping);
> -	}
> +	if (vma->vm_file)
> +		remove_vma_from_mapping(vma);
>  }
>
>  /*
> @@ -1351,6 +1366,8 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	if (new->vm_ops && new->vm_ops->open)
>  		new->vm_ops->open(new);
>
> +	remove_vma_from_mapping(vma);
> +
>  	down_write(&nommu_region_sem);
>  	delete_nommu_region(vma->vm_region);
>  	if (new_below) {
> @@ -1364,6 +1381,11 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	add_nommu_region(new->vm_region);
>  	up_write(&nommu_region_sem);
>
> +	if (new->vm_file) {
> +		vma->vm_file = get_file(vma->vm_file);
> +		new->vm_file = get_file(new->vm_file);
> +	}
> +
>  	setup_vma_to_mm(vma, mm);
>  	setup_vma_to_mm(new, mm);
>  	vma_iter_store_new(vmi, new);
> @@ -1386,16 +1408,20 @@ static int vmi_shrink_vma(struct vma_iterator *vmi,
>  		      unsigned long from, unsigned long to)
>  {
>  	struct vm_region *region;
> +	bool has_mapping = !!vma->vm_file;

Better to use const for this kind of thing.

> +
> +	if (has_mapping)
> +		remove_vma_from_mapping(vma);
>
>  	/* adjust the VMA's pointers, which may reposition it in the MM's tree
>  	 * and list */
>  	if (from > vma->vm_start) {
>  		if (vma_iter_clear_gfp(vmi, from, vma->vm_end, GFP_KERNEL))
> -			return -ENOMEM;
> +			goto restore_mapping;
>  		vma->vm_end = from;
>  	} else {
>  		if (vma_iter_clear_gfp(vmi, vma->vm_start, to, GFP_KERNEL))
> -			return -ENOMEM;
> +			goto restore_mapping;
>  		vma->vm_start = to;

you're not updating vma/region->vm_pgoff here, that's incorrect.

>  	}
>
> @@ -1415,7 +1441,15 @@ static int vmi_shrink_vma(struct vma_iterator *vmi,
>  	up_write(&nommu_region_sem);
>
>  	free_page_series(from, to);
> +	if (has_mapping)
> +		add_vma_to_mapping(vma);
> +
>  	return 0;
> +
> +restore_mapping:
> +	if (has_mapping)
> +		add_vma_to_mapping(vma);
> +	return -ENOMEM;
>  }
>
>  /*
> @@ -1544,6 +1578,9 @@ static unsigned long do_mremap(unsigned long addr,
>  			unsigned long flags, unsigned long new_addr)
>  {
>  	struct vm_area_struct *vma;
> +	int ret;
> +
> +	VMA_ITERATOR(vmi, current->mm, addr);
>
>  	/* insanity checks first */
>  	old_len = PAGE_ALIGN(old_len);
> @@ -1567,11 +1604,75 @@ static unsigned long do_mremap(unsigned long addr,
>  	if (is_nommu_shared_mapping(vma->vm_flags))
>  		return (unsigned long) -EPERM;
>
> -	if (new_len > vma->vm_region->vm_end - vma->vm_region->vm_start)
> +	/* vm_region->vm_top != vm_region->vm_end when sysctl_nr_trim_pages is 0 (default: 1) */
> +	if (new_len > vma->vm_region->vm_top - vma->vm_region->vm_start)
>  		return (unsigned long) -ENOMEM;
>
>  	/* all checks complete - do it */
> -	vma->vm_end = vma->vm_start + new_len;
> +	if (new_len == old_len)
> +		return vma->vm_start;
> +
> +	/* shrink only happens addr + new_len and old_len are in different pages */

Unclear really I don't think you really need an explanation like that I'd drop
the comment altogether.

> +	if (new_len < old_len) {
> +		/* like do_munmap(), we're allowed to shrink an anonymous VMA but not
> +		 * a file-backed one
> +		 */
> +		if (vma->vm_file)
> +			return (unsigned long) -EINVAL;

You break MAP_PRIVATE-/dev/zero here but then unbreak it in the next commit,
this is a bisection hazard.

I'd just leave this check out until you bring in the /dev/zero stuff.

> +
> +		/* vmi_shrink_vma() needs from/to pointers to be removed,
> +		 * (mainly used in munmap) so, specify them.
> +		 */
> +		ret = vmi_shrink_vma(&vmi, vma, addr + new_len, addr + old_len);
> +		if (ret < 0)
> +			return (unsigned long) ret;
> +	} else {
> +		/* growth path: grow up to vm_top should be handled here. */
> +		unsigned long old_end = vma->vm_end;
> +		unsigned long end = vma->vm_start + new_len;
> +		unsigned long grow_len = end - old_end;
> +
> +		/*
> +		 * Initialize the newly exposed portion before making it visible
> +		 * through the VMA or i_mmap.
> +		 */
> +
> +		/* read contents of extended map from file, or zero-filled if !vm_file */
> +		if (vma->vm_file) {
> +			loff_t fpos;
> +
> +			fpos = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
> +			fpos += old_end - vma->vm_start;
> +
> +			ret = nommu_read_iter(vma->vm_file, (void *)old_end,
> +					      grow_len, &fpos);

Umm, this function doesn't exist at the point of this patch so this breaks the
compile :)

> +			if (ret < 0)
> +				return (unsigned long)ret;
> +
> +			if (ret < grow_len)
> +				memset((char *)old_end + ret, 0, grow_len - ret);
> +		} else {
> +			memset((void *)old_end, 0, grow_len);
> +		}
> +
> +		/* The backing contents are ready. Now update the VMA bookkeeping. */
> +		remove_vma_from_mapping(vma);
> +
> +		vma->vm_end = end;
> +		ret = vma_iter_store_gfp(&vmi, vma, GFP_KERNEL);
> +		if (ret) {
> +			vma->vm_end = old_end;
> +			add_vma_to_mapping(vma);
> +			return (unsigned long)ret;
> +		}
> +
> +		/* vm_top remains unchanged; only the logical end grows. */
> +		down_write(&nommu_region_sem);
> +		vma->vm_region->vm_end = end;
> +		up_write(&nommu_region_sem);
> +
> +		add_vma_to_mapping(vma);
> +	}
>  	return vma->vm_start;

In general you're making this function very long. Can you split it out please?

>  }
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

