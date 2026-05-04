Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19E1CFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 16:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D52896B0088; Mon,  4 May 2026 12:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDD246B008A; Mon,  4 May 2026 12:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA54B6B008C; Mon,  4 May 2026 12:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A9A736B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 12:08:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48AE71C003E
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:08:21 +0000 (UTC)
X-FDA: 84730219602.04.948F9FE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf03.hostedemail.com (Postfix) with ESMTP id 54FAA20011
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:08:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LEcWDUBU;
	spf=pass (imf03.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777910899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQPMjTUHkP2UwGPYhszIF+AnxbBwLtPXM0Jz4vPxZjw=;
	b=xkzH368lmCUu8nvMsi7XsybhLVFgdEtTB3lIs/ONuiqyjvP7FQXZB9UuA5lDaXM4i66d27
	cBBvkmskx0WPk8wjBSPivyKA0DMKj//URSWhDMZ0Dq7hKBDvU9KclaR/Tp0aSA80l3suui
	v6zRgDizfK72edUA6wzUQiy0LT7QvKk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777910899; a=rsa-sha256;
	cv=none;
	b=i1k4/ItVz/L2Eu2zRP9sttl5l76ODtWl76bWiC8KhvTngF6zjvrafo+mtZ2P8UPdnFJzwV
	bpwzYXYKwEaY/+E5j4SGEaZaAP7BXjqZIfrYimcXAJF08VxWbwxERsrxVPb4ePMJMUiTqo
	d6TGErfQ534u1ulkRjmvKSmkbAR0ny0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LEcWDUBU;
	spf=pass (imf03.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=dave.jiang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777910898; x=1809446898;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4lCsaFuu2B5R467I+7rpTNdF6BZtih2LJJ2lk/PHSPw=;
  b=LEcWDUBUlTb6NptpEql7vedUMPjyxZxLpy82Cy6m3QjClCESz2krUHDb
   rr0u+0duV+EyCjdqrEAelTrrxuP9HacP+DekGVRiYNjDhnbccPBj8J04H
   UHKkkZ8wCiL3niBKPAiF8HUB002MPggYo3Xnr8nyr8LRwCk9CYDYwFawR
   4dfmFPQDVRzF6QiYNSpA7yCatmtyFtJqgTXyQshNHqZFPfhNzVibIq+21
   nSCK8ulgGIq2DguKGxJSRmmlU1vJptT0TTGMiDSZN8lOxCDbcgkwd8d56
   mScfQwJZ2/3KdNmiAL55wYHg8l0tSXmK3VZ1rpoIDsVWciPP0ZCAj4U7D
   w==;
X-CSE-ConnectionGUID: k4yKcpvdRISAck1isr7HtA==
X-CSE-MsgGUID: gt+4YqyLTSaYRE7Xd0bx3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="77789300"
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="77789300"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 09:08:15 -0700
X-CSE-ConnectionGUID: keFM9U6aQ4urZpzFRDdezg==
X-CSE-MsgGUID: pg+QsgYJTZGFA3RcNf/zHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="259211309"
Received: from ssimmeri-mobl2.amr.corp.intel.com (HELO [10.125.110.19]) ([10.125.110.19])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 09:08:14 -0700
Message-ID: <1eb01a65-d21a-40a8-948e-0b1a3f088a20@intel.com>
Date: Mon, 4 May 2026 09:08:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/dax: check for empty/zero entries before calling
 pfn_to_page()
To: Souvik Banerjee <souvik@amlalabs.com>, dan.j.williams@intel.com
Cc: willy@infradead.org, jack@suse.cz, apopple@nvidia.com,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260501233933.2614302-1-souvik@amlalabs.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260501233933.2614302-1-souvik@amlalabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 54FAA20011
X-Stat-Signature: zhb87569iz3q1idoq8eudstc6t8cm85n
X-Rspam-User: 
X-HE-Tag: 1777910898-73125
X-HE-Meta: U2FsdGVkX1/etKS3fPtHNbVRN3YZb1YV6SwAKuwqmJANi6CeaZBzPvKPnZo3LtZw1vTJVpRhQaJNHDpRuGfqlTvuJdiwnncfcz6yyhqdMwuVsx5hB0L15ZPvigX4225+T8EQcSu55LiF0IucxR54ok8p1SLjlOEDA/7iXFDgZnE319SO7cs9IupFeGFLHl6uvVDHJOL3OkMJoleAESweBGcoeGURfs7llrvKOqSLCWEEh2oEiPQFZdyxjGb2NMUIm9UNvkgINREjFMARkd3dpm0OKbN9Vu5eL20ixjCBVdSTMfjeGfi/PEsOhyIZVxn9K84mJiQzn4KOi5xi96nX9QCHgYOJZ2UGKzRRbvjL5rPQvJDsS5K0kER54WWGsguP6g46WXV5xS0xRlwJkqES+2tUB0SIQKaWDZ37CphGup2N6fAUKAt+fqMOhfu8CcreWl/4ztT43XCaRfeq09SK9wiGdv+aS3ErCmc6mg39lCm6RhOOikV0RMYdd8l3p8KDFRou31Jkl5Q+tO3BkwQDVl8PvcjrsOkR4ZYyTg6bh80zQpKsvBAur6YRStOxxhfiA7YAwpFo2sJA5OgejtNNOU7ChjbbAGBesgzf2tC5fnNExG6X/jt34ca1YfDQ72EQc9S0Pht1a07h+npCDrBZ4WkPqARMczO1H3cNn312iLvy25jEIwW1YaF4l/qOeBa9KJLOsx8+NTc1M6etqWC2k3d1DpZe9TTZeiwFHCedt0D6BzUikI6LmBy7LE7ZIl7PK7aDsE7gLbG3FUkMs+fRg59jhnKQeqMDWizgDk15slOm3WNVXxEcokIlHPuYn4n1K6rMkbm+VxEwWj4/kD36OFlQTDbN8yLzkzCsFzt1CrSfuBxXcsGXtVeoKd7UEKWnV7d5+VfiXGo71J7ERc6gWyC72jPx693x43HRxiitTTa7whW7jHBTpx5Db7QRo2WSNX3zWcYcCR21CM9/UlW
 cmlKnxgc
 EZH0WbR226mLcCvrmF/9jvqk9g7PU5ENHWaTP5wWKQvB6DsRW4pjLpzuDtLZg6A8mkHBqSYykKc+cK+VVZANOCeZLp7vc30KQJX9QdePUf4kkRqBNGQ/T3fcvApug+8khMWBfRFtbPLBYni5pKNm4oKrB82strO6JXgT6ai79PALcAHa46I+sTeS85+pDT6DXWK78d7RFnA2T9wHTQO8D+G3DPCjjkPpO0j1L6MEkWEvKrEfisxFnZZlbinZXK3e0JULRm3+B+KolY7N0e8NyCvZWJY5eeS3HxMksVRFX9z8khIWz7aqcSQhJV+7xBmBzGVVe/w8zwL8ZGxV995X8wusH52KbYJqsq4tAykuh14jRLO2b3pWNMpsqpaLc84Jz6Ry8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/1/26 4:39 PM, Souvik Banerjee wrote:
> Commit 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> added zero/empty-entry early returns to dax_associate_entry() and
> dax_disassociate_entry(), but placed them *after* the
> `struct folio *folio = dax_to_folio(entry);` line.  dax_to_folio()
> expands to page_folio(pfn_to_page(dax_to_pfn(entry))), and page_folio()
> performs READ_ONCE(page->compound_head) -- a real dereference of the
> struct page pointer derived from a bogus PFN extracted from the
> empty/zero XA value.
> 
> On systems where vmemmap covers all of RAM that dereference reads
> garbage and is harmless: the early return then discards the result.
> On virtio-pmem with altmap (vmemmap stored inside the device), only
> the real device PFN range is mapped, so the dereference triggers a
> kernel paging fault from the truncate / invalidate path and from the
> PMD-downgrade branch of dax_iomap_pte_fault when an entry is being
> freed:
> 
>   Unable to handle kernel paging request at
>   virtual address ffff_fdff_bf00_0008 (vmemmap region)
>   Call trace:
>    dax_disassociate_entry.isra.0+0x20/0x50
>    dax_iomap_pte_fault
>    dax_iomap_fault
>    erofs_dax_fault
> 
> Close the residual gap by moving the dax_to_folio() call after the
> zero/empty guard in dax_disassociate_entry().  Apply the same
> treatment to dax_busy_page(), which has the identical pattern but
> was not touched by the prior fix.
> 
> Fixes: 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
> Cc: stable@vger.kernel.org # v6.15+
> Cc: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  fs/dax.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 6d175cd47a99..6878473265bb 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -505,21 +505,23 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
>  static void dax_disassociate_entry(void *entry, struct address_space *mapping,
>  				bool trunc)
>  {
> -	struct folio *folio = dax_to_folio(entry);
> +	struct folio *folio;
>  
>  	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
>  		return;
>  
> +	folio = dax_to_folio(entry);
>  	dax_folio_put(folio);
>  }
>  
>  static struct page *dax_busy_page(void *entry)
>  {
> -	struct folio *folio = dax_to_folio(entry);
> +	struct folio *folio;
>  
>  	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
>  		return NULL;
>  
> +	folio = dax_to_folio(entry);
>  	if (folio_ref_count(folio) - folio_mapcount(folio))
>  		return &folio->page;
>  	else


