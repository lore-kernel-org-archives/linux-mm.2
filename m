Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89011108B8E9
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:13:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDD886B0088; Fri, 20 Mar 2026 06:13:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8FC56B0089; Fri, 20 Mar 2026 06:13:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4DD6B008C; Fri, 20 Mar 2026 06:13:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7AF76B0088
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:13:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5636314011C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:13:40 +0000 (UTC)
X-FDA: 84566029800.27.05C2EC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 99BCAC000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:13:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="m/WpkM7y";
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774001618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXWb8jyhOqqvyBgM6/E/8rxGou98J+rWk6sZlOnWDL8=;
	b=A/ihwK8WK9J3x2IP7DxJJGUH/gxbr4fXiAV5HaJ6xblhlBXTykxAoSKmVDZlFw0HIXfNeh
	g99jOnc+O3pGdvoInfwnGA5IYIwZ2xrJDkN+rV/BWEM7/aMAnyDljCXj0vT6gT+v9XXTRS
	vSxZy5DZ+Ye3icztHuqyIoFKPNAiZ40=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="m/WpkM7y";
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774001618; a=rsa-sha256;
	cv=none;
	b=wcw4G+Eq0ovPBPVdETTVIDSVhmEx61DqEWMBzE60IYXdiopmUMaPyROBtj1dPivVPQ+B/C
	oDFomUZOnnNiMuz88U8WzofbRSh0G91/6+Cn2ja7YIOWD984HT1UsQdruXlWxE2XbYBlr/
	DRUi9yDLLMs2I2YvJ7PfvZaxq40OGfI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F70844174;
	Fri, 20 Mar 2026 10:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2F5C4CEF7;
	Fri, 20 Mar 2026 10:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774001617;
	bh=8Cux4Or9KBz8E1bbQ/G37aCVREYFbbZo9kf7MyLOF4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m/WpkM7yXsPrj+XS090ErPj5z6XrZ+vYpuCUuf2GOk8/xN0ZoqH5x4JhyK+YyiE6M
	 Cm+gtAkO/Gzkin1ue/MBR3ZUEjNNxhGY/UH/WaGXOLxS+xEgiaqgCAyGYpAQeJK3TC
	 3jhL80M+MneKdkEOon73DI/gu044cgE78S7rJjXTeVLyR7dSUDveM59p5o4hAHtQv6
	 ESfmxNyj9EuJeRXNJYAmJJaWbt19x6FoNCU7RMO6l/2qB0nd2rtIV7I1v1r4aTAkas
	 x7txEN1h2zIDdMPOaKEyKjrlAr0zuilZFR9pold24lMS9BuP+NDxNIzxROwqgZPS79
	 W2KrZ2MOKk8GQ==
Date: Fri, 20 Mar 2026 10:13:34 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, baohua@kernel.org, ryan.roberts@arm.com, 
	linux-mm@kvack.org, wangkefeng.wang@huawei.com, sunnanyong@huawei.com
Subject: Re: [PATCH v3] mm/huge_memory: fix folio isn't locked in
 softleaf_to_folio()
Message-ID: <63266e52-2644-4f4e-aca5-6db64052455f@lucifer.local>
References: <20260319012541.4158561-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260319012541.4158561-1-tujinjiang@huawei.com>
X-Stat-Signature: ncrubrrf8j4y9wqorafw6cceepu7grmc
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 99BCAC000E
X-HE-Tag: 1774001618-898112
X-HE-Meta: U2FsdGVkX19SAj9J2vnvBChbUrR0Nrn9rKoYB29d5d8iASqr0VxYOTt1xYvU2zRfeYO2H81+WJRNJwnTrgdQJmVQ4E230A9pLrxtMMwBgDcoeSftVI6efHUO8qj4EmVhreJ09vSo0igoWuvLeZbJN7Dr2NdlnS9p23x2sFihol2qAPfNjEGFKu0KCrhUFTQqBE12oLg7xZ9U2jnjD7+5aV4VJjxwpGdsLaQlNlDT7iM2KqDfFQqK1YFL2Jz4NmzZKKs3md3FhonrB2u8BLk273jEHrJEHBvk+2DTJPChGQUM9QzTGQUIl2O8zU+INaL1CvDzTzCwovclLFiVXsy1VSEWrSbivQIgHTSWMv3CzOEsQhAllLgCZcN2xBTM1Le3DM08NGcFJqHmFFAyDi5uFQ8J7wQeK123A8z7+OkotKps3pXRhauPRpea+EH5zzOKleEmPHrTNuxWRjBDXZzNvJwG4G6a+bsyIeQxnrvihIrNDdCr2xfEYBBIM+M4UvHK9jAUjpCjiSwk/UmFuTsACzJ5HrxgRouYv0WtvUQVTtEIh8RWXhOk/nPpArBWYojWyC3yXhuXl2Jzt405K0AylkL8OOCzhWIvtThZNwTjbUN7z/BZTXP0bV8+0fjPM/CVh/bSF2MBOmpDXmSWUhWOUdP7fJ/mF1oVUSne6log3Gq/bj/v1At+JX59Zdc+2eNAJEimjc5YgKnBzAqzmMCsCp1AnMEhffqExZB27avSWJkxQ6qDQkbvkzhy7b7E9cG8ST6tdlFy6NI8xza5T5z+pDXu9jCLc2cJO1Zu3hmKjIs1J0pMAp8betzBbPNyKm0Y/CJyHyVfT7abX7EWsRnD+715/dBKgYlwcADdUu11dOXE4jXPidM8sM4zRia8AcWa/LdOF3xj42eg/KWFjeug4+aGuREj9bajFbIGzx762a7DJSeFoDl0Vx7vDUULVjxpYOWUJrWaucMdwBQy6Rm
 +mZLwe4y
 7NNKWWrRGWneYHtUSbtIZWBsw8bNZ3s5QJ95xuF90B2HQR4z6gJhl3CKUJpIY1gbgV+DAgixG13lcsueGclEJ/H2tC/vkrnhsnle5J4r9iEQEuia9M8Syhqg511X9aUmAas4yXDXDGROYkME1Vwi25DKqsBeGJ4unDVs9LbA3AVLXJI/2fHIVMXcj1kl4xq8iMLZWNfyxffXGYyOX9ieYf4F9kNLQoX/cXMjyfQMvXHsTodq2+gFvq4waPVLtpG+TqmzM71JxX0Autf7t7anvg2Rq8q25f+ig3EPBNHDMqTYYXSbg3cXYXCWC0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 09:25:41AM +0800, Jinjiang Tu wrote:
> On arm64 server, we found folio that get from migration entry isn't locked
> in softleaf_to_folio(). This issue triggers when mTHP splitting and
> zap_nonpresent_ptes() races, and the root cause is lack of memory barrier
> in softleaf_to_folio(). The race is as follows:
>
> 	CPU0                                             CPU1
>
> deferred_split_scan()                              zap_nonpresent_ptes()
>   lock folio
>   split_folio()
>     unmap_folio()
>       change ptes to migration entries
>     __split_folio_to_order()                         softleaf_to_folio()
>       set flags(including PG_locked) for tail pages    folio = pfn_folio(softleaf_to_pfn(entry))
>       smp_wmb()                                        VM_WARN_ON_ONCE(!folio_test_locked(folio))
>       prep_compound_page() for tail pages
>
> In __split_folio_to_order(), smp_wmb() guarantees page flags of tail pages
> are visible before the tail page becomes non-compound. smp_wmb() should
> be paired with smp_rmb() in softleaf_to_folio(), which is missed. As a
> result, if zap_nonpresent_ptes() accesses migration entry that stores
> tail pfn, softleaf_to_folio() may see the updated compound_head of tail
> page before page->flags.
>
> To fix it, add missing smp_rmb() if the softleaf entry is migration entry
> in softleaf_to_folio() and softleaf_to_page().
>
> Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>

I absolutely could have sworn I replied to this before, but I looked and it
seems like I didn't :) am I getting old or something? :P

Anyway the logic looks good, thanks for this, but some nits on the
naming/comments below.

With those addressed:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>
> Change in v3:
>  * move softleaf_is_migration() check out of softleaf_migration_entry_check()
>
>  include/linux/leafops.h | 28 +++++++++++++++++-----------
>  1 file changed, 17 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> index a9ff94b744f2..dd4130b7cb7f 100644
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -363,6 +363,19 @@ static inline unsigned long softleaf_to_pfn(softleaf_t entry)
>  	return swp_offset(entry) & SWP_PFN_MASK;
>  }
>
> +static inline void softleaf_migration_entry_check(softleaf_t entry,
> +			struct folio *folio)

I'm not sure this is correctly named, you're doing a debug-only check here
but the barrier is a LOT more important.

Maybe softleaf_migration_sync()?

The fact there's a check there is implied by the VM_WARN_ON_ONCE().

> +{
> +	/* See __split_folio_to_order() comment */

NIT: reads better as '/* See comment in __split_folio_to_order() */'.

But you're referencing a 1 line comment from __split_folio_to_order();

		/* Page flags must be visible before we make the page non-compound. */
		smp_wmb();

Which also doesn't give sufficient context in my view.

So I think overall better as:

/*
 * Ensure we do not race with split, which might alter tail pages into new
 * folios and thus result in observing an unlocked folio.
 * This matches the write barrier in __split_folio_to_order().
 */

> +	smp_rmb();
> +
> +	/*
> +	 * Any use of migration entries may only occur while the
> +	 * corresponding page is locked
> +	 */
> +	VM_WARN_ON_ONCE(!folio_test_locked(folio));
> +}
> +
>  /**
>   * softleaf_to_page() - Obtains struct page for PFN encoded within leaf entry.
>   * @entry: Leaf entry, softleaf_has_pfn(@entry) must return true.
> @@ -374,11 +387,8 @@ static inline struct page *softleaf_to_page(softleaf_t entry)
>  	struct page *page = pfn_to_page(softleaf_to_pfn(entry));
>
>  	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
> -	/*
> -	 * Any use of migration entries may only occur while the
> -	 * corresponding page is locked
> -	 */
> -	VM_WARN_ON_ONCE(softleaf_is_migration(entry) && !PageLocked(page));
> +	if (softleaf_is_migration(entry))
> +		softleaf_migration_entry_check(entry, page_folio(page));
>
>  	return page;
>  }
> @@ -394,12 +404,8 @@ static inline struct folio *softleaf_to_folio(softleaf_t entry)
>  	struct folio *folio = pfn_folio(softleaf_to_pfn(entry));
>
>  	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
> -	/*
> -	 * Any use of migration entries may only occur while the
> -	 * corresponding folio is locked.
> -	 */
> -	VM_WARN_ON_ONCE(softleaf_is_migration(entry) &&
> -			!folio_test_locked(folio));
> +	if (softleaf_is_migration(entry))
> +		softleaf_migration_entry_check(entry, folio);
>
>  	return folio;
>  }
> --
> 2.43.0
>
>

Cheers, Lorenzo

