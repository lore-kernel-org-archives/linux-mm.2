Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B094CA6009
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 22:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 005066B008A; Wed,  7 Oct 2026 18:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF6926B008C; Wed,  7 Oct 2026 18:35:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0D6B6B0092; Wed,  7 Oct 2026 18:35:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0E116B008A
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 18:35:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3514F1A03D8
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:35:30 +0000 (UTC)
X-FDA: 85297288020.28.7B6A874
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 63C7EC0006
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:35:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OHbq7WvW;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791412528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B+VMO+YMjXevl0hOsc4oTcVQo83xucHvyssxvgfaocc=;
	b=6cvJYtDaNGDT2cxf/SkYFvR6jdMGdIK1rdwIOcuabTrDQKDVCdlgo1ndDAch2rWfmFsL0h
	OLZAdtT3teItRrYj7fzRITLJvQfoxdyOCJGYvFdRpsq7pnSGDLaWHfmDNylfqMu8M7ZS+4
	bgZEkbmzq0NQB4PHTwzJuldSbkOkyZc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OHbq7WvW;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791412528;
	b=TKhUmXM2N6PEDqUr6jLMwAcwUfG4+MvQubc5CbtVM5rwzEJoj2vjBBt2Ke9R+ZysXqFRdk
	h8oIp/86KzrBMyOcnZn1d858VngTFu/fI5TFodYaF+iaUGnoQpPlKjLH+SkgnXIIJF0fAO
	6N0/FEaZBus7gdjghQGMR0qyiAwnNpY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D0C8416E0;
	Wed,  7 Oct 2026 22:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83261F000FF;
	Wed,  7 Oct 2026 22:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791412527;
	bh=B+VMO+YMjXevl0hOsc4oTcVQo83xucHvyssxvgfaocc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OHbq7WvW7VgYYAX/mYOnO5AJwUDhQ5vPApvLzHa8f0U6z24RKHye8eJK+TQGwMIxQ
	 BpIU2ThZjznvdTr9jkgJhNfuc2Cvv0rZ+AV7i6eE3DJSCtrCajiABjniiNAjbIX6s4
	 KpKpY9bfm5813BUGteKy34MbO5nbuSeeUJeeG0mw=
Date: Wed, 7 Oct 2026 15:35:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com,
 vivek.kasireddy@intel.com, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hongfu
 Li <lihongfu@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/memfd: fix hugetlb reservation accounting in
 error paths
Message-Id: <20261007153526.cb4473601fc9038a9ca4f517@linux-foundation.org>
In-Reply-To: <20260927094757.31665-1-hongfu.li@linux.dev>
References: <20260927094757.31665-1-hongfu.li@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 63C7EC0006
X-Stat-Signature: k7rz7zh49rtptyzx9qf83pdxpte1q36q
X-HE-Tag: 1791412528-939256
X-HE-Meta: U2FsdGVkX1+QyDEgH1jS0oTxhyXkgOVLjNwIYdHK9uCOxEe7Al3vfqc4kFZbLBkUGyn3nW/n3LwUphOIJjrTuM+hbzlvQLumxFSr1gpqGhlunlLSHId/qi1+yWLjt8fLRWuAulvVUTXQZY/HQkOYsPFJcnqqBEqS6ppPrEs4ocX7yDzEXeLcarVGaYHG1cJu1HiYkwaVaXuEUAOmP8+KsyWkkahM3NIm3fYgihBB1wjeQv0dzNPqDpxNTQTRsBBn7br4uU+8GgpH9DrrGwuweVMHh3AGeUqrdlppMM+mH2+d2n18SW6adlJmed2rS4SA6kUD/xA52E979NkbSL1GsxZ240V2cPZuXTyM9YSpS+cyl/E1AqbLDRPd6R6MIN9Qs8V+JYF2Ismy625+Akl0EKs390DZquP7OUfwRMA/afgvX+TCsygCpLq17NZa98egWevwJXZ/BsR3dL0BtLQZSY6O8bFsssM6zO4/u07z/DhZHkCXlvFFmHbbU++gwy1JI7o1UoHhZU6UEtvEDteCPsDJKnSWE/mr805baN4Ua+FegqfSRImqRG4fTk8TawiRWZoq/2zs95TxD/qYNcEo9ckavtqvIueMcXOwSFZgLIq/ikNfFZoWT54oCTQHSjCJOueihp0550Kcixmv02zhsPVvSRYjHnf4FMm1h/zIyPzVgh6GsuFV0/hWwDTlka9ktkLC7wgjqKPAt8cO5We9hmQJj2qvl3WYanKWHg/UNdzscBGA3r6wWg9hiMNg2FvycuYlJLPe0271vQRswtc45r+LEBL9fuyRgRMP8Ppk9P5wLsc+EamnfMqiTkW/XpdRTpZ4PYIX3S+fQQdRRV8+Q28IffPHTnCT0G3RWk6KY7ZINr1sTfWGqmFArANlaKz64QQbkp1oyT91XJO/5N3HbnQoqwpVDoEAkTbMMh/kqOCut92TZ+7YW5Mi5bcS3vkoEAiI/mwUB/XsYUIhbDU
 m5KnkCQT
 mzujnkNou66VJT1vnaRoTzff4v06hcIb0POvvigF5xF6w8UGWzF+C2VOXYSONdaGfxvsIAFn5p4UIeAdQajQWSM8mHz+b6sRxv7ZpaH9DWFCXT7ZfARVO+W+Kz60ST+DEV7+sh7hWfV0zL36eBDOxC4Sa7aaYWYMtvZArPa4kBF2a+Cg3nWQZUWTFiqmMbNyvzIXBnCwUbA7OXIA7Mh3xAs07qKBDpajbQm461Na+VQ5v47OduWS6I9h/72m7IuFz5d4bWWzB5eraAqdCmvD4U61OVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 27 Sep 2026 17:47:57 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> If hugetlb_add_to_page_cache() in memfd_alloc_folio() fails with -EEXIST,
> a concurrent fault has already instantiated the folio in the page cache,
> and the reservation now belongs to that folio. Calling
> hugetlb_unreserve_pages() in that case incorrectly removes the region
> backing the cached folio and releases one reservation more than it
> should, leaving that folio in the page cache with no region recording it.
> 
> That leaves resv_huge_pages one page short until that folio is removed
> from the page cache, so available_huge_pages() reports a page that is
> not actually free and the pool can grant one reservation more than it
> can back. Applications using hugetlb memfds can then fail to allocate
> or fault in a page they already reserved. They see -ENOMEM or -ENOSPC
> from the allocation or fault path even though the reservation and
> HugePages_Free still look healthy.
> 
> So hold the hugetlb fault mutex from hugetlb_reserve_pages() until the
> error-path unreserve completes to make the reserve, allocate and
> instantiate steps atomic against concurrent faults. With the mutex held
> from the start, a concurrent fault can no longer consume the reservation
> between reserve and allocate/instantiate. If a fault completed before the
> mutex was taken, it has already added the region for that index, so
> hugetlb_reserve_pages() returns 0 and the error path leaves the region in
> place.
> 
> Fixes: 717cf9357325 ("mm/memfd: reserve hugetlb folios before allocation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Can we please have review of this cc:stable regression fix?

> v3:
> - Update commit message to describe the accounting damage and its
>   user-visible effect; no code changes.
> - Add Cc: stable@vger.kernel.org.
> v2:
> - Take the hugetlb fault mutex before hugetlb_reserve_pages() and hold
>   it until the error-path unreserve completes.
> - Update commit message
> - Link to v1: https://lore.kernel.org/all/20260831090631.29227-1-hongfu.li@linux.dev/
> ---
>  mm/memfd.c | 31 ++++++++++++++++---------------
>  1 file changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/memfd.c b/mm/memfd.c
> index c708d92533f4..0f6fff004f5e 100644
> --- a/mm/memfd.c
> +++ b/mm/memfd.c
> @@ -82,22 +82,31 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
>  		struct hstate *h = hstate_file(memfd);
>  		int err = -ENOMEM;
>  		long nr_resv;
> +		u32 hash;
>  
>  		gfp_mask = htlb_alloc_mask(h);
>  		gfp_mask &= ~(__GFP_HIGHMEM | __GFP_MOVABLE);
>  		idx >>= huge_page_order(h);
>  
> +		/*
> +		 * Serialize hugepage allocation and instantiation to prevent
> +		 * races with concurrent allocations, as required by all other
> +		 * callers of hugetlb_add_to_page_cache().
> +		 */
> +		hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
> +		mutex_lock(&hugetlb_fault_mutex_table[hash]);
> +
>  		nr_resv = hugetlb_reserve_pages(inode, idx, idx + 1, NULL, EMPTY_VMA_FLAGS);
> -		if (nr_resv < 0)
> -			return ERR_PTR(nr_resv);
> +		if (nr_resv < 0) {
> +			err = nr_resv;
> +			goto out_unlock;
> +		}
>  
>  		folio = alloc_hugetlb_folio_reserve(h,
>  						    numa_node_id(),
>  						    NULL,
>  						    gfp_mask);
>  		if (folio) {
> -			u32 hash;
> -
>  			/*
>  			 * Zero the folio to prevent information leaks to userspace.
>  			 * Use folio_zero_user() which is optimized for huge/gigantic
> @@ -112,20 +121,9 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
>  			 */
>  			__folio_mark_uptodate(folio);
>  
> -			/*
> -			 * Serialize hugepage allocation and instantiation to prevent
> -			 * races with concurrent allocations, as required by all other
> -			 * callers of hugetlb_add_to_page_cache().
> -			 */
> -			hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
> -			mutex_lock(&hugetlb_fault_mutex_table[hash]);
> -
>  			err = hugetlb_add_to_page_cache(folio,
>  							memfd->f_mapping,
>  							idx);
> -
> -			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
> -
>  			if (err) {
>  				folio_put(folio);
>  				goto err_unresv;
> @@ -133,11 +131,14 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
>  
>  			hugetlb_set_folio_subpool(folio, subpool_inode(inode));
>  			folio_unlock(folio);
> +			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
>  			return folio;
>  		}
>  err_unresv:
>  		if (nr_resv > 0)
>  			hugetlb_unreserve_pages(inode, idx, idx + 1, 0);
> +out_unlock:
> +		mutex_unlock(&hugetlb_fault_mutex_table[hash]);
>  		return ERR_PTR(err);
>  	}
>  #endif
> -- 
> 2.54.0
> 

