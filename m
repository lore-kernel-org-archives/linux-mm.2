Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD26BC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 10:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD07E6B008C; Wed, 22 Jul 2026 06:09:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B80886B0092; Wed, 22 Jul 2026 06:09:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48B36B0093; Wed, 22 Jul 2026 06:09:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EB896B008C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:09:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B9501C0823
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:09:29 +0000 (UTC)
X-FDA: 85015990458.05.B3971FB
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf31.hostedemail.com (Postfix) with ESMTP id BCBB920007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:09:26 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="oew5Qce/";
	spf=pass (imf31.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784714967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QOld9v1IQQQffm7VzSiGaWH4GSxtg1czg/IcWZNsV/0=;
	b=vkblSMAgcoCINi8IrjlhU46rLmsq46xCrYDuHDSC3ShTszHarzMtngg8aPJ0Q69bwZb5j1
	aeZMDXznRcuD4w7BfQJEzphdVzvJ6RTupcQbVpbeIE3FZqX/gqHvGU3aGfxVqToa25+QVx
	o8EiLy/FrIuK4Aqik8VigxBOoDLRffs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784714967;
	b=OMEI9X57NKW89zTVebnYuB6FxhT+GSjRI3vtKg88A4zdUgWwiSmvNT5+xtqlnPH8hPBcZv
	5b3+IDYxaqEJ3qCnTO3Pwf7XdHK0ikqo3UD6pBJhX5gd6K1Q3JDs4Y9Ucsb6AMY1CCxThH
	169ec3ZOBxCsHWmCuMjRGi0C1vsWg0U=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="oew5Qce/";
	spf=pass (imf31.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784714965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QOld9v1IQQQffm7VzSiGaWH4GSxtg1czg/IcWZNsV/0=;
	b=oew5Qce/8RPKg4CtQaCt86UiDVVuAa0ASlYHSVVZXXVataMbTTQv51xqf6RFn2d9foYO6W
	yg0bsAEgD+EtSVVk6L/Vl/eTv15os308RhUYq4Jn8UMP6BGflkKGa/LK4AngjdtVV0pqnD
	1QANsEaK3E1G9OIlK51jZlgC6V64qf8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 6/8] mm/khugepaged: hoist isolation into
 collapse_isolate_folio()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260720142913.846902-7-pfalcato@suse.de>
References: <20260720142913.846902-1-pfalcato@suse.de>
 <20260720142913.846902-7-pfalcato@suse.de>
Date: Wed, 22 Jul 2026 04:10:38 -0600
Message-Id: <178471503895.281396.8783902510522649911.b4-review@b4>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BCBB920007
X-Stat-Signature: sdonk588sqqge4wpazp44cdz9hs4au84
X-Rspam-User: 
X-HE-Tag: 1784714966-227262
X-HE-Meta: U2FsdGVkX1+oMBwKQcDrggpKwb5O+vDyn0pFc0lSCnz4iTNqp2gFAmVOWVnFLK8MHjeo0szIGeF9cwN4dpSD1VGhl31jEdvSfIDzeYibZmzNfOpVsnC/rba7WM7x2s5/d9pFZkvIWjaqRDPmz6BtQOZYcwJZH1a1vObNOA7jK7UIVucohU00Zw3+dzcv3/77PI2cnY0UA6YWIXLn9qOXD5LZe5y8UPJNSMX6CS8/i8JVtQyVZAWi+8k2DTtzAFJrtNgQ7C8bsqHyofKaB/IbAfaYopUH9qffnEsEuS8TlBdXBtJigI7N32VAccLBxkIhcKJd2UsEayR8+nIMwPicO5QC1aPCIyPlISdMcvlCbtPkNSol+m2yE1e2V/I9acCzH2vWG7Iuqnl4R9sidU6d0IwRUJv2QdmfOf+Co7C3/H4Zv7b/E0dHdOC8UOlv3gC3CnxoDEP07Jb6VDzh3FsTX51+jAKQW8+KspH5EorZ16RfFVgB0qRXePc/yhQk1kPs1Pksqc4senZxJuprkx/fSn6oEj2kOfAYOqZu52idGX5H4+3T+qBRiUs5sLITyqHxgW3BI4gr7eNjg/ktbFESoFT0hxKKIdNzY/kwedvxESnC9+c4h1A5/60Hf28RVIoUUVRRghWJETrvX0bZmbE4CoRoZpEWl+WbP0hMpViRDLzUD6Tw5DAeH7kbw17cogI2ePbDtq5emffDwYi/t8s/eNVYMDzVLX6Djxx6598c17N8X1u5I3zlmQ/vUif5rdToGowHKqERpksEL+OQhMaKptCWDsImEYkuTCgpQ5JidanLgKd+0jjLnGQWyFp3S1ti6mCUdVsaw9nk1/zT7dG34qXSAo2vozl6gnbzP0e4bBnX8GFblrHI+95mX9CMjz284asJpBG3RoXbtwT+fb8cJCF9ANMslVAoQituRvpwD17GAIiIDc3RBpJHlrS59J8pRy6f6KPQR7Ga24yaG8l
 aNn9GOhK
 obJImc+PzjPOrXRbGkboKrpB8IUI3g2jez0FL9NiDqDgkFdDsGv+MoJSaI4ekM60BWAT9GWyeRn5qS6SnGTpziXVdimxXvviZhb0goAi0WVKlarW53mJkSMn3ly+M30oT4+RaDemhAM/6Eu99jkrUX6GCjCPn0yQbcXpb1AbXNCUvN4pKUm5u6iW2NI0yFEF/ds9oPqTKe9YisuZf+95S71FO30qzXckdv2HflRyA8oL7bWWlJUJE5LUwpQF/Ri6m2Ci2heufJFo0/wUG/O8tANPy0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index db1f765b6ead..429e2c5833d0 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2332,6 +2332,69 @@ static enum scan_result prepare_collapse_file_folio(pgoff_t index, struct collap
>  	return ret;
>  }
>  
> +static enum scan_result collapse_isolate_folio(struct collapse_file_state *state)
> +{
> +	struct folio *folio = state->folio;
> +	enum scan_result result;
> +
> +	/*
> +	 * The folio must be locked, so we can drop the i_pages lock
> +	 * without racing with truncate.
> +	 */
> +	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> +
> +	/* make sure the folio is up to date */
> +	if (unlikely(!folio_test_uptodate(folio))) {
> +		result = SCAN_FAIL;
> +		goto out_unlock;
> +	}
> +
> +	/*
> +	 * If file was truncated then extended, or hole-punched, before
> +	 * we locked the first folio, then a THP might be there already.
> +	 * This will be discovered on the first iteration.
> +	 */
> +	if (is_pmd_order(folio_order(folio))) {
> +		result = SCAN_PTE_MAPPED_HUGEPAGE;
> +		goto out_unlock;
> +	}
> +
> +	if (folio_mapping(folio) != state->mapping) {
> +		result = SCAN_TRUNCATED;
> +		goto out_unlock;
> +	}
> +
> +	if (!state->is_shmem && (folio_test_dirty(folio) ||
> +			         folio_test_writeback(folio))) {
> +		/*
> +		 * khugepaged only works on clean file-backed folios,
> +		 * so this folio is dirty because it hasn't been flushed
> +		 * since first write.
> +		 */
> +		result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
> +		goto out_unlock;
> +	}
> +
> +	if (!folio_isolate_lru(folio)) {
> +		result = SCAN_DEL_PAGE_LRU;
> +		goto out_unlock;
> +	}
> +
> +	if (!filemap_release_folio(folio, GFP_KERNEL)) {
> +		result = SCAN_PAGE_HAS_PRIVATE;
> +		folio_putback_lru(folio);
> +		goto out_unlock;
> +	}
> +
> +	if (folio_mapped(folio))
> +		try_to_unmap(folio, TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
> +	return SCAN_SUCCEED;
> +out_unlock:
> +	folio_unlock(folio);
> +	folio_put(folio);
> +	return result;
> +}

prepare and isolate now share multiple goto error paths. if you move this into
the prepare function (combining the prepare+isolate). the goto labels at the
bottom become very easy to follow and reduce the code bloat.

With the two additional helpers (shmem vs !shmem) the code becomes very clean,
even without the additional cleanups you did in the previous few patches.

I would suggest doing the very simple restructuring first, then including any
additonal cleanups that you did in this series.

That would not only make it easier to review, but also a lot of the mess
already gets handled just by following my recommended flow.

Cheers,
-- Nico

-- 
Nico Pache (Red Hat) <nico.pache@linux.dev>

