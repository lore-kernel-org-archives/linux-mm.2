Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9116CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 09:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFCC36B0127; Fri,  8 May 2026 05:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD45F6B0128; Fri,  8 May 2026 05:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEA636B0129; Fri,  8 May 2026 05:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C05366B0127
	for <linux-mm@kvack.org>; Fri,  8 May 2026 05:15:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5ABD31C15B5
	for <linux-mm@kvack.org>; Fri,  8 May 2026 09:15:13 +0000 (UTC)
X-FDA: 84743693706.19.89CBF9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7A4DC40002
	for <linux-mm@kvack.org>; Fri,  8 May 2026 09:15:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oKmgI4wq;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778231711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EyWtjNJ3xXvPmtRUDZYkT1+UCrVy6opEKT6OdJBM46k=;
	b=GRjMXtf2Li+cqD/PIm4G8qHIz5+JBqz/nRm0ft6pN/eTBsALzbaS3PGB6WlgYrtlwc3AHe
	ORIohSk5e2mGtj8gjUCn9p0AFr+u6xGW3hc10as/eK9ocUZyOMA8CIyKyUFbnqQHxDQpai
	yMf2/++ubx1ycS5Jw1Il7kJrgzrvd5Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oKmgI4wq;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778231711; a=rsa-sha256;
	cv=none;
	b=svpk+AKHtzwaLvvHMjbwg1P6Azdea4Kw499O0CTtjYSKNBflWf/yKCvft2MA/liqezPD4W
	bR1hOHWfEYz7u0qCyP9tHFBcSQ1b94pCBfBN38gPOCx60BckaHoHXYu7yzZWb62ddVCggn
	ZnJ0DK0X1aQTPUITCQdpcAdSanMPJeM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 93371429C2;
	Fri,  8 May 2026 09:15:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE1DC2BCC7;
	Fri,  8 May 2026 09:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778231710;
	bh=NXZCU9O+VnXKW0Sj9R4wxcr+LevLi2lp2ovXFLv6vJk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oKmgI4wq7bbeVrOg4MRR6sfYHcNJ4J+g8kT2q+cfspcG0ggGGazKNsKJW9yHW8Yht
	 UfKdlAf8CONiwguOIIXA8zzDMabe3eZZ9Wop21tmbFQk0s0+wricTFF+eBLpFZZii1
	 wsUO+jsMDHDypwLO8KVorS5qpt+ddDuwgG76To6GvFrYwOWYfEUxrQEHYC70YIyJA/
	 PiySftNL/Go2Daomk44GyADSVg1SXDY79SLFwr74xdcb0Otza2Sf1fpbp1T+pFWGyx
	 KPXDafM+0hQ1IeWB5YV7nJirMYMI47Ly4IxIsc9ZgN7rOg3UzIMWwgdX+QsvNbiWYB
	 Gv5SbUKY/Oplw==
Message-ID: <a708a295-9d80-4538-9d12-53c12820f9ed@kernel.org>
Date: Fri, 8 May 2026 11:15:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/dax: check for empty/zero entries before calling
 pfn_to_page()
To: Souvik Banerjee <souvik@amlalabs.com>, dan.j.williams@intel.com
Cc: willy@infradead.org, jack@suse.cz, apopple@nvidia.com,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260501233933.2614302-1-souvik@amlalabs.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260501233933.2614302-1-souvik@amlalabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A4DC40002
X-Rspamd-Server: rspam06
X-Stat-Signature: 455etfau6t8m6ibxngmcd4frbr8dmpb5
X-HE-Tag: 1778231711-752966
X-HE-Meta: U2FsdGVkX18n5C6cfzf0KrWDU9ERtTVBXwcU4bULGBUS+/yx+bwBhMDn3nXS+OaR4BEngWT4dicSij/OhCfUw5nkxYiKfvr3xOh/wOFBtESJbtgj1PD7qFo4RqXQrSq+isbtipKRFIS1KwFDqqcA5JK18BVgSM6vibPyuhSMdkc50h9UXkqpsuu21teEnBqPvpOr7LI6RJhd6+fdDTeEkqJDvczzpEBx+IEiuMANINf+xRI58XGKiQYe6n7X2sNJ6eRxnHk0IdBWtkIRBryLPiwnguGKVqXpVOkQf5uQGpWcMr81vhRpj1u4ZHQO4xIRes9iF+fQgH31lO+2UpwH8fcftUlrZdJ1aAN7wGLIvX1snlPVu8p4u3T4b0uFT5piprVzOokhYCNyhkx4Ftp1ZB/O4K2zkvrHRrHMdu3AVc6dKFpbNyiwLLVDrowSkl3ItXH9enfUG5xcgWgv2VHOcgPGM859zpE3tnqtDqJMjDDB6uJJWA4KMxScbTSr8UCFDcMrSRfURRiZxkd9l8cOf0n6xpdOFQwQeHXLJ1nUkvGwBvVJTI5teZyVPjEYf93MD+wKEg+rPBo6C9ehp3LJPJ7ypocynqw3kWAGr9NHfkHtxRUwK2q07q665u1o6vI6lleNYEiT7x3cbPoAL+RaobiL1AJYpJbJ5mNATHOtz9TEodzIwiP+5bOYMM7vzfRkT7poNxN3mh76L1VvgScTa2RK0qIV5FSkwiD+rMG8pHK0I2EjchXKdjqA+GQwr/Pj0hH7T+D/7vmXXJKVHCbbaIEytS9K2TdN/w1ki2MAValzVCLRd4GS/ASSJaRdsj+fHh0Quqa8SiwAGnnzL+fAVZ1qRGo7NC3Raw1BAOAYyUm3N0zcRW0LmrfWdrGQZduo9XpbYcHcWhOgVPX+tnh+yGP475JAx7xRqZuTFfzKms6aqNpop5KOslDCKYHxACE26crDWmp6Cp4dv2+ZfPG
 yxywrvdX
 zPZHWdqnDslQ2e5RR64gVU9arFrTWVAsLxI1c/gPBhrP04TlXejMBzYazZGsAknC+wQUJyMkRXWBHnwfIzL3m6ybzV1MiSqkm8eKYpwmgJdDxOlUUj37MAgbbX+bLyDhHdvix1d5AaOOdZvCc3FcN1YoxotudrCE9pWAEjEDatOZJQb5bP25BfpnOPZrKnL5Kh0rv+8vCp7SSEFpwb+JtEgI5E1MikhFrSvfxwEZwpY8dCWiTQt0/I7cVbA0Djv2f0KcbZM3OjCbgs5/hfFgmvwiVUE7MLvQYcs+a2Ty8TmelHoP3mPlLbCDlxXI+BSM04HU2lkGubUicEjTi0T5kmDd5MwIv2lTzvIT3NvmxGgnO80XK685i/kji94RIFgPC7ML11sPwT43Ikx3gzBdG6hey1Ib8Glefxq6G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/2/26 01:39, Souvik Banerjee wrote:
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

Makes perfect sense to me.


What about the usage in dax_associate_entry()?

-- 
Cheers,

David

