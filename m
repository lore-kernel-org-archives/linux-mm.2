Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62F5DCD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 22:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 715006B00A1; Mon, 11 May 2026 18:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5906B00A2; Mon, 11 May 2026 18:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DB516B00A3; Mon, 11 May 2026 18:38:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F4676B00A1
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:38:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1822C1C0A5D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:38:13 +0000 (UTC)
X-FDA: 84756603666.03.9DA4BBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5FB4CC0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 22:38:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sgNjjagG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778539091; a=rsa-sha256;
	cv=none;
	b=mT8uGeQxUPFnE0iZrEGVl0JXlWn9abU3roIj3fj9yGzfr5OI4zYWXGNRLkyKAsxo/gzsCK
	xcnDEvFajKLDXHrbWRVZ3e8NcZ2WXn4e7/nIS2S2KgoAJtDbgyndMf52i1F+Qo9/Rf+UgI
	xyT0SDT5uFK73lRwZ3lE2BTDtyifKq8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sgNjjagG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778539091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E8rWfPQGr5EHWRlsODxf0UN6vI+/UsFqtPOCv7vTrwo=;
	b=hsNCv/3cH86aRiKPPGzkf7xMMdcJ1rpKHsXO/oBVQoAS1Oaf7H6I/7WugZvvnYO8NWpClZ
	goqcz59fjUy92BN47KPOZ3Fk+t0u8sK7OFdystbQXcxB9An1YIo9fdkUKhCU6K9X5E23mn
	ygWQsDtS9KET1d51vf+kI6GNQoqVAh8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E58341B3F;
	Mon, 11 May 2026 22:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AD2CC2BCB0;
	Mon, 11 May 2026 22:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778539090;
	bh=fbyMoeIIAj9uYWA4eCqwbDYRzB9l0R+amEo+V3SyBDU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sgNjjagG7r7F6lVZ4W2fhcv2LvSsGTOVjmvJsKWz/0o6hKQoWe+nh+XkmWLAKUJ1B
	 FiAR7VFybNvjqp9WF+vxe4Bf2t5xKk1QE0y7xhxce6Zf2HZJepoCeD+mDP8GTvhaCo
	 kFos61RCiAVZXuMMoFWjtHF1kOzpWvoIpMdzvxmCJ9uZ/OwHJmBOGebnsvBNjrdm9Q
	 PYxrzdTifYbRZmhGQV6sOA0STkEKh6toWSocSAGvyRfqG3HblVR5kxj29Qo8nd9udx
	 YH4OqdP6pYQJpk3hM9FiCN3LjCMbnFzU2U/+IMk2QiWuFAWQWob+u1hMazimAlO+A/
	 D4m9cT6WcYEkQ==
Date: Mon, 11 May 2026 22:38:07 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: fujunjie <fujunjie1@qq.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Baoquan He <bhe@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [RFC PATCH 3/5] mm: zswap: load fully stored large folios
Message-ID: <agJV-73LaAzMqDBg@google.com>
References: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
 <tencent_69E7E93D1E47766E922D48B9EA9FD1140D09@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_69E7E93D1E47766E922D48B9EA9FD1140D09@qq.com>
X-Stat-Signature: 8pfwch4sdp6m4qkkcrrczygcbcxtyg45
X-Rspam-User: 
X-Rspamd-Queue-Id: 5FB4CC0005
X-Rspamd-Server: rspam07
X-HE-Tag: 1778539091-202921
X-HE-Meta: U2FsdGVkX1/KYEv0rVafLgAdJeAFz7tyT6yG+rP7Rs64Vj/f00bdPUESJ60lEkN3Qyr9iWx4PXe1WtBV5+BYo5m/L8Ma4qLNDhjU3xjzRGqamg2HvNpYhnPY1FJdf99hJLdEZFVpsqJuhoHBHpS6gOle4yXXMPI0SOxX71ut2ToyXqkvbpZ40ux4hbO6e67gm8nbLrKP3cGRav/Ugy8EGXrmvD1JL91ZOxomxH9vD+52MrUoyYegO9ToHN+Rn6jFRcshyQv8LaWcVaiD+4dQIbIt5zjDLA/gAZUwLaq6NBP2e6+u41HfrtFYsRk79ByUdmYTe6wMZ5a7jhrASpB7f3Y9MoAguIBKPRzMw5GAg/5jVLT+aevVmG0V1mkvSyn9dvJ5pzD/kxgKvmGYrjHI+0uIy68WPQkCmQuphhX15UushYJ60gKAwPMpjMcRU0zApLPKbM8hQHq1tagwSty9+9p/B1dVBQlOePP/5KKomOUhwOGuBcQSjXvDBdnb2+/ztBFIOnXxv6KZVlKpoGPwbn9NoRx8n5hpLLPGHedvB1OianKyOnof1CZxo/PrZYwVZG4cXHRuShwRsIMQi0nDHzw5m3lcbUCzjIHMr+0CZCkQ1E630zHFaYdDtdzkusl/LWKULVkwx3sBMzMIGPHQpk1n9VnnsNYet+EyRgksDpf2Xsv9BW3u4VjwMYxMGoIlKslZlkcdbo4VItg9p6g18Sad1RKS8Gp0hXLjvZRrbO9Vf+mzBlWk6H25Bsger/FXWjLweEB86XLC7jhRklJrqpVVNj1QrK5l0g5LAS9mZcaFqykFgXOp6xVYI7O3S8BtD0goHT6T63cwB8Ec03n4CgfxUvvA3kgOmlx6JctGlCn1nTyZG1kThDIzAzjkjcK75niXXEMgGQiUezpr9y+oLfXDnGNjakMgNdNIHz8NyZNxeHm9+WoZsBvwrUdE69IDhMLHWHhoyXh0oN11nq3
 Wh8FyBAX
 qvXQW0DcPz+R7RVapDc7QbhKSowShnyKzhMvGMSFBUTdGCAJtqzCOy3y3DHDjTLfp93r1YL/ksOY8IEoFhnsKgTdjb0aq6uC7ZIJR12zyS+hGZSgK3mu5PjA+9OSZFhCBTHMMWEIFX7uPh99pR6HlhN+BnCEbty8Gawk/epy8fpcM7gWI35rwfGVIAgxvd18N0ctcqSJTQuEN1C8jeGnGh+m5//hDLr95hNwzObLlONLfzTVzgD8fdG1Bygtozt9nmPoTkSOakTWoRenbEeo/mRRNTsZ3jTXuBeGfyaoRPwbkXHRaT4iy3nezifTwRbq//k2ix13wU++qlWbeExcVZXyYAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 08:20:31PM +0000, fujunjie wrote:
> zswap_store() already stores every base page of a large folio as a
> separate zswap entry and tears the whole folio back down on store
> failure. The load side still rejects any large folio, which forces the
> swapin path to avoid mTHP swapin once zswap has ever been enabled.
> 
> Use zswap_entry_batch() to distinguish three cases: the whole range is
> absent from zswap and should fall through to the disk backend, the whole
> range is present and can be decompressed one base page at a time, or the
> range is mixed and must be treated as an invalid large-folio backend
> selection.
> 
> After all entries decompress successfully, mark the folio uptodate and
> dirty, account the mTHP swpin stat once for the folio, account one ZSWPIN
> event per base page, and invalidate each zswap entry because the
> swapcache folio becomes authoritative.
> 
> Signed-off-by: fujunjie <fujunjie1@qq.com>
> ---
>  Documentation/admin-guide/mm/transhuge.rst |  4 +-
>  mm/zswap.c                                 | 65 ++++++++++++++--------
>  2 files changed, 45 insertions(+), 24 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index 5fbc3d89bb07..05456906aff6 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -644,8 +644,8 @@ zswpout
>  	piece without splitting.
>  
>  swpin
> -	is incremented every time a huge page is swapped in from a non-zswap
> -	swap device in one piece.
> +	is incremented every time a huge page is swapped in from swap I/O or
> +	zswap in one piece.
>  
>  swpin_fallback
>  	is incremented if swapin fails to allocate or charge a huge page
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 27c14b8edd15..863ca1e896ed 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -28,6 +28,7 @@
>  #include <crypto/acompress.h>
>  #include <crypto/scatterwalk.h>
>  #include <linux/zswap.h>
> +#include <linux/huge_mm.h>
>  #include <linux/mm_types.h>
>  #include <linux/page-flags.h>
>  #include <linux/swapops.h>
> @@ -1614,20 +1615,23 @@ bool zswap_store(struct folio *folio)
>   *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
>   *  will SIGBUS).
>   *
> - *  -EINVAL: if the swapped out content was in zswap, but the page belongs
> - *  to a large folio, which is not supported by zswap. The folio is unlocked,
> - *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
> - *  do_swap_page() will SIGBUS).
> + *  -EINVAL: if the folio spans a mix of zswap and non-zswap entries. The
> + *  folio is unlocked, but NOT marked up-to-date, so that an IO error is
> + *  emitted (e.g. do_swap_page() will SIGBUS). Large folio swapin should
> + *  reject such ranges before calling zswap_load().
>   *
> - *  -ENOENT: if the swapped out content was not in zswap. The folio remains
> + *  -ENOENT: if the swapped out content was not in zswap. For a large folio,
> + *  this means the whole folio range was not in zswap. The folio remains
>   *  locked on return.
>   */
>  int zswap_load(struct folio *folio)
>  {
>  	swp_entry_t swp = folio->swap;
>  	pgoff_t offset = swp_offset(swp);
> -	struct xarray *tree = swap_zswap_tree(swp);
>  	struct zswap_entry *entry;
> +	int nr_pages = folio_nr_pages(folio);
> +	bool is_zswap;
> +	int index;
>  
>  	VM_WARN_ON_ONCE(!folio_test_locked(folio));
>  	VM_WARN_ON_ONCE(!folio_test_swapcache(folio));
> @@ -1635,30 +1639,36 @@ int zswap_load(struct folio *folio)
>  	if (zswap_never_enabled())
>  		return -ENOENT;
>  
> -	/*
> -	 * Large folios should not be swapped in while zswap is being used, as
> -	 * they are not properly handled. Zswap does not properly load large
> -	 * folios, and a large folio may only be partially in zswap.
> -	 */
> -	if (WARN_ON_ONCE(folio_test_large(folio))) {
> +	if (zswap_entry_batch(swp, nr_pages, &is_zswap) != nr_pages) {
> +		WARN_ON_ONCE(folio_test_large(folio));

IIUC the condition can only be true for large folios, so I think just
WARN_ON_ONCE() in the if statement itself?

Taking a step back, this is doing xa_load() lookups that are repeated
again below. Maybe we should drop this check here and integrate the
check into the loop below (either all entries exist or don't)?

We might end up with a case where we decompress some parts of the folio
then return a failure, but this possibility already exists (e.g.
decompression failures).

>  		folio_unlock(folio);
>  		return -EINVAL;
>  	}
>  
> -	entry = xa_load(tree, offset);
> -	if (!entry)
> +	if (!is_zswap)
>  		return -ENOENT;
>  
> -	if (!zswap_decompress(entry, folio, 0)) {
> -		folio_unlock(folio);
> -		return -EIO;
> +	for (index = 0; index < nr_pages; index++) {
> +		swp_entry_t entry_swp = swp_entry(swp_type(swp),
> +						  offset + index);
> +		struct xarray *tree = swap_zswap_tree(entry_swp);
> +
> +		entry = xa_load(tree, offset + index);
> +		if (WARN_ON_ONCE(!entry)) {
> +			folio_unlock(folio);
> +			return -EINVAL;
> +		}
> +
> +		if (!zswap_decompress(entry, folio, index)) {
> +			folio_unlock(folio);
> +			return -EIO;
> +		}
>  	}
>  
>  	folio_mark_uptodate(folio);
>  
> -	count_vm_event(ZSWPIN);
> -	if (entry->objcg)
> -		count_objcg_events(entry->objcg, ZSWPIN, 1);
> +	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPIN);

Not a problem with this patch, but I wonder why different swapin
implementations are making this call instead of putting it in a
higher-level (e.g. alloc_swap_folio()).

> +	count_vm_events(ZSWPIN, nr_pages);
>  
>  	/*
>  	 * We are reading into the swapcache, invalidate zswap entry.
> @@ -1668,8 +1678,19 @@ int zswap_load(struct folio *folio)
>  	 * compression work.
>  	 */
>  	folio_mark_dirty(folio);
> -	xa_erase(tree, offset);
> -	zswap_entry_free(entry);
> +
> +	for (index = 0; index < nr_pages; index++) {
> +		swp_entry_t entry_swp = swp_entry(swp_type(swp),
> +						  offset + index);
> +		struct xarray *tree = swap_zswap_tree(entry_swp);
> +
> +		entry = xa_erase(tree, offset + index);
> +		if (WARN_ON_ONCE(!entry))
> +			continue;
> +		if (entry->objcg)
> +			count_objcg_events(entry->objcg, ZSWPIN, 1);

Hmm I was wondering how the stat update should be handled here. It is
possible that a folio was swapped out from one memcg and is being
swapped in by a process in a different memcg. For order-0 folios, the
folio gets charged to the swapout memcg.

However, looking at alloc_swap_folio() ->
mem_cgroup_swapin_charge_folio(), it seems like we charge mTHP folios to
the swapout memcg of the first swap entry. This seems a bit arbitrary.

Focusing at the code here, seems like we'll count the swapin against the
swapout memcg, which is good in terms of keeping ZSWPIN and ZSWPOUT
balanced. However, it seems like it's possible that the folio is being
charged to a different memcg here than the swapout memcg, so we may end
up counting ZSWPIN in one memcg but charging the folio in another.

I am not sure if this is practically a problem, but something doesn't
sound right. Johannes (and other memcg folks), were these the intended
charging semantics for mTHP swapin? Is it reasonable to count ZSWPIN in
one memcg and charge the folio in another?

> +		zswap_entry_free(entry);
> +	}
>  
>  	folio_unlock(folio);
>  	return 0;
> -- 
> 2.34.1
> 
> 

