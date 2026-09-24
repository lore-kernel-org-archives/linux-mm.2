Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 184D8C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 20:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34D996B0092; Thu, 24 Sep 2026 16:28:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6906B0093; Thu, 24 Sep 2026 16:28:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19F0C6B0095; Thu, 24 Sep 2026 16:28:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4EA86B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:28:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 466D9160253
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:28:23 +0000 (UTC)
X-FDA: 85249793286.19.BF07C24
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8CF6BA0007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:28:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eQzzjoSt;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790281701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qfcIZKwA8q7CQROBoedXLhEH4e3CxPJmdbEI4YWW4Fw=;
	b=RpkfJMj/tn8YwzS9Kwyep4SVQz6KE6dPpRUM73rO7I/002ODPBijYqhRH3alvoKcXtyIzz
	arSWBr4OkR3RyaiSc3haylj+U7iTy1AOEPuPFZXQOjOD15+ZFRAZ8nimsE1qB4sRuvkYcM
	YZvVhpA3PMW0JrUY7Jw/MZ6lYxG18uk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eQzzjoSt;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790281701;
	b=3iDhRtODO933PdaSSwBSYsRThkhYXpV7Zr7K9KWDOUecy+nMJ1avWKZZm/A/4EwKfDJjC1
	jqknfRMCXEScAzuboeObJn25kiV+vKAKydkwwYy+a+l2j9Z/dtHcKp6gpHCpJPYOrpAkbu
	uN6j6icmssw3E08nKhDMnF4867Nx/d8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0A047601F6;
	Thu, 24 Sep 2026 20:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B9591F00893;
	Thu, 24 Sep 2026 20:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790281700;
	bh=qfcIZKwA8q7CQROBoedXLhEH4e3CxPJmdbEI4YWW4Fw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eQzzjoStR1tqW8Ni5DRYwUkCCm+VnI3jwVczkbjBct5Ko9n4GZPp+qlv2az8a89Ir
	 pqAVKmqkwC1WoyLp3sU606u4GJ/0S2qRqNvXlNzxOrKiJ3T1Odi5HKrNa8EBBz8bRa
	 vLpr/BNXnk2Iu4Kd4LLIcS+biICtGEbvMgnVwoMbaF78zNMbssELPcJv6Vi6MMy1zC
	 6Sob7d9/5q6L38ekw9AB/R5uvuK9YbCz9DtsT7gZNTV66B3XAHj3xASPlGLIxTjtaM
	 VpmUjf6u69cNI4wpqhp+rFrkSZdnyHkk62nRWQzgnVkZdiLU3iAvAaXkTTEBso0Qw0
	 f7Aus2KH6oAkA==
Message-ID: <69c54254-9657-4b95-a1cb-a6c0429c1c8c@kernel.org>
Date: Thu, 24 Sep 2026 22:28:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 12/29] mm: handle PMD swap entries in fork path
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-13-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914122950.3283997-13-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8CF6BA0007
X-Rspam-User: 
X-Stat-Signature: f738qew831fede9yrjiu93ce7zx47j8w
X-HE-Tag: 1790281701-315444
X-HE-Meta: U2FsdGVkX19sAlwWx+qDz3TBlF1/8crEYLJELlesQCdujp1J/PZ/MsA35W7vJWeoP1mx2wIlBgXFqQ7AdAjBoZ6GgPxO5Ts5pn7AovKUZ/Wak7mqKNtWPc6oPYBPZWQTACzYK6etq2+R1F8Zo+LKMwNcaaDKUugRGyPc9119umeRPYT2qKPHzgvsSbelCARBYO8Hej0DExJ46DbRHJv43S/yQ0AGu1SRvJUTWpXMZCsURISj1kXxQGfqXcxl3tGL+Wtqjf2fDhHz3e8yEwU7yw9KKVudHYdWSIagPmkWml/pl5xT4dGz1EfWjWKSGU5Q5wZcnW5gKVvXNVnNZ89aKuynJqYpXVFf2S9yMiKEqZnz5Y3pe1x+MoM37mHk6vPjcJAd7Vj48BkuIh+pKDLS3uKpLx3elaHPPYy+XPpKjJ/s6X8yuIoawvpHLcimt0bIESxW99S56Kn7SsuUApNFB2O5GMuvJCEx/dZxp2LvA6yWBnkuiXv+s7g3VcnD2wL7C5vzNBH95ihu8Q2Z3RlxsVusxIv/fBJ9AUhmreUSPCZN26QHlcYAHcmT+gn4w8tuIA64S54XH38v823xfXEDSMujZNKjZxV0Rh5n0NMRia9XOZPwwruMDqGoi6XIEBu0ASqhqG0eXnvi5XzHkpeJMkqmxDSxAz3tSIOpjJw64iTYnGh/8n8MqkTjhqCjpW855DDH9lLITMiy32DIUvp0/UsGLttYGnTgCb9cWCDkb2H73yKEZww102Jeo76OyPsRMXl6mxTxmIF7FLLa/BtUZCHD+0bTqhxsW7Ywi0UHH7UeBc+NTCBmPDzxLDF4JDuuWygnG2UWsZAPGwfvWdBJy469qOtNYsV92Q8PfeTPWP286wSr22PrTKHzuu4eZg8nZ1X5UY2TF24co/yXIrwyTTUtVKx9MrSwtNjumH9ZTNPLTJRHNrnY+jQWtIylK1Qp6yT+mwv0wnFIWlPCBDD
 Zcr/W0Gc
 PbWZ2SLWbYCLhkXH5Qjiq16nqMgzV0hvT/g8ElsEoxurclzBNl/FJsOyf+Yr1wtmC3xNArZrpHdqmSceDXHEqY5vZhNiiX1MkJkvg2ZYPlqXdOf1/IFMg3KtkJNx6Inl/IGMR7Es9ZgdqAIh4+HZ1nwHE7drpB+y26JJms7OSxXN2mrHSJgkdS0oiV6baLX0zzp3xDD/w19xh09AFfUUCjDeKbop4+oDnxg0Jr+VVqhLqYxFWA/2R5cnTeFPTT7u1/2hL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 14:28, Usama Arif wrote:
> copy_huge_pmd() only knows about migration and device-private PMDs, so a
> PMD swap entry would fall through to the present-PMD path and fork() would
> duplicate it without taking a reference on the slots it points at.
> 
> Copy it the way copy_nonpresent_pte() copies a PTE swap entry: duplicate
> the swap references, clear the exclusive marker on the source, put the
> destination mm on mmlist, and account the child's slots to MM_SWAPENTS.
> 
> Duplicating HPAGE_PMD_NR slots one at a time would be wasteful, so give
> swap_dup_entry_direct() an nr argument and rename it accordingly. Unlike
> the put side it hands nr straight to the per-cluster helper, so the range
> has to sit inside one cluster - which it does, since SWAPFILE_CLUSTER ==
> HPAGE_PMD_NR under CONFIG_THP_SWAP and a PMD-order folio's slots are only
> ever allocated at a cluster head. Reject a crossing range with -EINVAL so a
> future caller cannot walk off the end of the swap table.

You have a lot of patches, put you could (should? :) ) consider moving the
swapfile.c stuff into a separate patch, such that we can more reliably catch
swap maintainers attention (and shrink this patch here).

> 
> The GFP_ATOMIC extend-table allocation inside the dup can fail;
> copy_huge_pmd() then drops both PMD locks and retries once with
> GFP_KERNEL. Bound it to one retry, because swap_retry_table_alloc() also
> returns 0 when it decides the table is not needed. Normalise any remaining
> failure to -ENOMEM: copy_pmd_range() treats every other error as "not a
> huge PMD" and would then reach pmd_none_or_clear_bad(), clearing the source
> PMD and leaking its swap slots.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

[...]

> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 0e347a545588c..6dfe8ef6dd371 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1894,7 +1894,7 @@ bool touch_pmd(struct vm_area_struct *vma, unsigned long addr,
>  	return false;
>  }
>  
> -static void copy_huge_non_present_pmd(
> +static int copy_huge_non_present_pmd(
>  		struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  		pmd_t *dst_pmd, pmd_t *src_pmd, unsigned long addr,
>  		struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
> @@ -1940,14 +1940,40 @@ static void copy_huge_non_present_pmd(
>  		 */
>  		folio_try_dup_anon_rmap_pmd(src_folio, &src_folio->page,
>  					    dst_vma, src_vma);
> +	} else if (softleaf_is_swap(entry)) {
> +		int err;
> +
> +		/*
> +		 * PMD swap entry: duplicate swap references and clear
> +		 * exclusive on source, matching copy_nonpresent_pte().
> +		 *

I'd drop that, rather obvious.

> +		 * A PMD swap entry only exists under CONFIG_THP_SWAP, where
> +		 * SWAPFILE_CLUSTER == HPAGE_PMD_NR, and it is cluster aligned,
> +		 * so these HPAGE_PMD_NR slots are exactly one cluster - which
> +		 * is what swap_dup_entries_direct() requires.

This is the more relevant information.

> +		 */
> +		err = swap_dup_entries_direct(entry, HPAGE_PMD_NR);
> +		if (err < 0)
> +			return err;
> +
> +		mm_prepare_for_swap_entries(dst_mm);
> +
> +		if (pmd_swp_exclusive(pmd)) {
> +			pmd = pmd_swp_clear_exclusive(pmd);
> +			set_pmd_at(src_mm, addr, src_pmd, pmd);
> +		}
>  	}
>  
> -	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
> +	if (softleaf_is_swap(entry))
> +		add_mm_counter(dst_mm, MM_SWAPENTS, HPAGE_PMD_NR);
> +	else
> +		add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);

Can we instead just do it like the PTE variant and move these into the
respective cases?

BTW, I'm surprised that we don't have to handle file THP migration and always
assume MM_ANONPAGES. Maybe we always zap them instead of using migration entries
... maybe :)

>  int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
> @@ -1957,6 +1983,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  	spinlock_t *dst_ptl, *src_ptl;
>  	struct page *src_page;
>  	struct folio *src_folio;
> +	bool retried = false;

Do we really need this retried logic? I cannot easily spot something similar in
copy_pte_range(). I'd assume once swap_retry_table_alloc() succeeds we should be
mostly good.


>  	pmd_t pmd;
>  	pgtable_t pgtable = NULL;
>  	int ret = -ENOMEM;
> @@ -1988,6 +2015,7 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  	if (unlikely(!pgtable))
>  		goto out;
>  
> +retry:
>  	dst_ptl = pmd_lock(dst_mm, dst_pmd);
>  	src_ptl = pmd_lockptr(src_mm, src_pmd);
>  	spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
> @@ -1995,11 +2023,34 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  	ret = -EAGAIN;
>  	pmd = *src_pmd;
>  
> -	if (unlikely(thp_migration_supported() &&
> -		     pmd_is_valid_softleaf(pmd))) {

That thp_migration_supported() thingy is one ugly function.

> -		copy_huge_non_present_pmd(dst_mm, src_mm, dst_pmd, src_pmd, addr,
> -					  dst_vma, src_vma, pmd, pgtable);
> -		ret = 0;
> +	if (unlikely(pmd_is_valid_softleaf(pmd))) {
> +		ret = copy_huge_non_present_pmd(dst_mm, src_mm, dst_pmd, src_pmd,
> +						addr, dst_vma, src_vma, pmd,
> +						pgtable);
> +		if (ret) {
> +			spin_unlock(src_ptl);
> +			spin_unlock(dst_ptl);
> +			/*
> +			 * For PMD swap entries -ENOMEM means the per-cluster
> +			 * swap-extend table couldn't be GFP_ATOMIC-allocated.
> +			 * Try the GFP_KERNEL fallback once before giving up.
> +			 * swap_retry_table_alloc() also returns 0 when it
> +			 * decides the table is not needed after all, so bound
> +			 * this to a single retry rather than looping on it.
> +			 */
> +			if (ret == -ENOMEM && !retried) {
> +				softleaf_t entry = softleaf_from_pmd(pmd);
> +
> +				retried = true;
> +				if (softleaf_is_swap(entry) &&

How can we suddenly not have a PMD

> +				    !swap_retry_table_alloc(entry, HPAGE_PMD_NR,
> +							    GFP_KERNEL))
> +					goto retry;
> +			}
> +			pte_free(dst_mm, pgtable);
> +			ret = -ENOMEM;
> +			goto out;
> +		}


That's .... messy :)


I was wondering whether we could handle it slightly like the PTE case: return
-EIO and let the caller do that for us. We only have to return the "softleaf_t
entry"

Would avoid the retry label, the manual unlocking etc.

Nit sure, just a thought. The code as is is definitely too messy :)

>  		goto out_unlock;
>  	}
>  
> diff --git a/mm/memory.c b/mm/memory.c
> index 477d7e359b447..84e1e1c22bffa 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -979,7 +979,7 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
>  	struct page *page;
>  
>  	if (likely(softleaf_is_swap(entry))) {
> -		if (swap_dup_entry_direct(entry) < 0)
> +		if (swap_dup_entries_direct(entry, 1) < 0)
>  			return -EIO;
>  
>  		mm_prepare_for_swap_entries(dst_mm);
> @@ -1394,7 +1394,7 @@ copy_pte_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma,
>  
>  	if (ret == -EIO) {
>  		VM_WARN_ON_ONCE(!entry.val);
> -		if (swap_retry_table_alloc(entry, GFP_KERNEL) < 0) {
> +		if (swap_retry_table_alloc(entry, 1, GFP_KERNEL) < 0) {
>  			ret = -ENOMEM;
>  			goto out;


For both, I'd provide a simple inline helper that maintains the existing
interface. Less chrun in unrelated code.

[...]

>  
>  /*
> - * swap_dup_entry_direct() - Increase reference count of a swap entry by one.
> + * swap_dup_entries_direct() - Increase reference count of swap entries by one.
>   * @entry: first swap entry from which we want to increase the refcount.
> + * @nr: number of contiguous swap entries to duplicate.
>   *
>   * Returns 0 for success, or -ENOMEM if the extend table is required
>   * but could not be atomically allocated.  Returns -EINVAL if the swap
> @@ -3978,8 +3997,16 @@ void si_swapinfo(struct sysinfo *val)
>   * owner. e.g., locking the PTL of a PTE containing the entry being increased.
>   * Also the swap entry must have a count >= 1. Otherwise folio_dup_swap should
>   * be used.
> + *
> + * Unlike swap_put_entries_direct(), the whole range [entry, entry + nr) must
> + * lie within one swap cluster; a range that crosses a cluster boundary is
> + * rejected with -EINVAL. The only caller passing nr > 1 is the PMD swap entry
> + * fork path: a PMD swap entry can only exist with CONFIG_THP_SWAP, where
> + * SWAPFILE_CLUSTER == HPAGE_PMD_NR, and a PMD-order folio's slots are only ever
> + * allocated at a cluster head (see alloc_swap_scan_cluster()), so such a range
> + * is exactly one cluster.

I would reduce this drastically. This will bitrot easily and the details are
only relevant if this actually ever starts failing.

Just keep the first sentence and add the details to the patch description (which
you effectively already have)

-- 
Cheers,

David

