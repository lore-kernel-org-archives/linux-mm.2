Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90E91606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 13:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W0vPQuJM
Received: by kanga.kvack.org (Postfix)
	id A182B6B05B0; Thu, 26 Nov 2026 08:12:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8826B05B2; Thu, 26 Nov 2026 08:12:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B77D6B05B5; Thu, 26 Nov 2026 08:12:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5BBAF6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:12:41 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D7BE11A0449
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:12:40 +0000 (UTC)
X-FDA: 85477309680.19.BDB17B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1220BC000B
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:12:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W0vPQuJM;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795698759;
	b=Nq5QOmBTs6iTaw17B41aBzKD0DcogC181yjEwgPzNWsjbY0lUq8vl+KvaUJnKckFbCWivw
	Y1jaQR/fWDn3gRSDvCX1016Fb/QlLh6NOFMfQCc7OPi/fGvTrUd8ix9KujWu+mcKb2qSVd
	pWLVZUpzmLkQCQ8AswowSr8N9qwZmjM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795698759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=04Pw5/OY8msg1N4ni7fthpRWs4dsPaaWOmyW/Ryrtok=;
	b=BsXoSad/1SgqsQ4GPztHi82ZmtQGUuZUXHGiQNM9tT5Dv6os1GesJ7gp7cZ/mWTW7osZSS
	s/LBkB1jrQHM2EDg3r4JAfpzUyHuTjzpmTOOiAVj9efMBcP0PdzvKQXg2M+jqe7qMbXYjl
	9b6IRRkFOEadCaVBPx9tYUR9WYp2k6s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W0vPQuJM;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4122E41841;
	Thu, 26 Nov 2026 13:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731561F000C6;
	Thu, 26 Nov 2026 13:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795698758;
	bh=04Pw5/OY8msg1N4ni7fthpRWs4dsPaaWOmyW/Ryrtok=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=W0vPQuJMT+/oHXZHnqDlw703OaMHbf9w2Yg2CfsBeQqcQFeJ3KRryyUQrVG6gjCBZ
	 SfxCBZBXSDJPKATvOgElt98JC++9M1kiyuHDEN+ykHhCkgGbLPMqp4g7rpyQH3fY+i
	 oP3lPp37BZRKQvNOQ/0K7i1FWpK+2jNcCQ6WhKwnQf/5gkNLgBt217e2SvbMQrActz
	 PQ+fW5PxActHc15mqtmbnNRjFvRlWvvMtqNYdwRhYGa7Zuu2KKTgcm0i1uFb5gh/LY
	 wbuVOJOHhT3AkJUvtGIkwpgGjPJlccc3sCHETam5mnkOkTlBSx/MPcPYeEnn/3cTnY
	 reDX0Jl6KU4ug==
Message-ID: <5cc60faa-002c-4c96-97e3-46d3002718c9@kernel.org>
Date: Thu, 26 Nov 2026 14:12:29 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iov_iter: Fix direct I/O across compatible device pgmaps
To: Naman Jain <namjain@linux.microsoft.com>, Christoph Hellwig <hch@lst.de>,
 Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Oscar Salvador <osalvador@suse.de>, Logan Gunthorpe
 <logang@deltatee.com>, Leon Romanovsky <leon@kernel.org>,
 Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
References: <20261126053433.88531-1-namjain@linux.microsoft.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261126053433.88531-1-namjain@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Queue-Id: 1220BC000B
X-Stat-Signature: nwifa7wuy4nqrx81xejfbfhtdidhduo7
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795698758-593621
X-HE-Meta: U2FsdGVkX19r2xUp4UOU2BXmtBsZfi2Iyu2WM8solcwO7jlvXhanOuiPL9PFnaQYOL7m2FPgal9MHBLwIcHPAK3W8Edb8u9HrTyHV5SQ5pj3ItMnDgCgRZfFscAWnghwkewuvon3AWeOtBy45VTFdSmtpNRxcc0O2LrHGKbTTFtWsOtxzr39X+XfvZqbKhQn9unPPmeTQBH+IJrelklQG90+lrQRDSIrg5hInxo2V6f/++429/p7bhK81TlGqOEmsuJUj7cOkpzbxi9HUewQZGvRVI53hFjG1eezqYLgYZla9dxtubeXMfFxH+myboDNN0nrRS4JyvNXhDKv+W4jI8Jw9tPW39CiLkbfWPqYVjK3RMX5WKQF+Ljmh06cSKTEo2/EYdt0h47b0sU2esYSpP3u1AZQZ4wAFraGzlYEGQ5ACRg+HrKE3CFRFL0hFRCqGxENEgiHEjpcMkJ5Ho9Lda1iLT0eplw8gfNbgyokz3SlhrOx4xLNtJRnhmiUpk9ZH4saat9gjh3Zpg4o+1Dq9uqWtNPwoNVeKXuxdJLdd4XfjTfNYVXn/zfGtaML7TY88wQO1p0JiDlFwf22u+E4ScW1mHl9nwm5JOMIBO+eIb9U73/ZjJbYCJ6s/s2KglCJ/i9BExyaOAaOJvr4XYQVvvU0O3PkFPZlYiG4spnIy5Wj3gYtBE+Hy0sM/gULDp/u4zO4V7Hd5SkQamoUTViywUehgzw1fWmA4aqev+06IvYbdK9+57JAk85KWvWuNJxTMHSsg+CCfYszE89T6Mtxkr8nuOvgiETQNiRVJm8VjeJSrtBHohU4yBBTSZsivP306/cPRlgVyy3GPXiCch7KYAcElHBh0MqO/oXsQHOv9JMRAvzFuNOtVjSL1ot49kaZXrTX9YECO5Iar0Sz6otqpqa4iovZsQjQlUPsh2xo4Bi82ZjuuiT00V164mqIhcmSIozHyssen+zeo8c7a8E
 7y1UarBV
 VKv/ESFcNZAO0wGn8SWeKIDak5pyfqVGesSHCJVW6VbMGXdsJkXl3d+oICyWscV3dcoH58+Icd8D3k2mwJSGYq8htzaCSt4XieaX2PGcpjxFs4R8VyuLtUganoCsnicPIIQZesp+QxGKBiEM+bCj7HM7M8NO9pdCqipwlDs6J8KyYY7DHNF+UHEMStFg2u6XfIt5JnDB0xl7T1aCTXrljPJ2lXcEhMw5nlBXMs69BsuBdsj5SA1UYW46PItCx5y4OqUTrCk5N0Fi+1sTxn4R1dMoRWhFVmw9hIVPoTLlBbgbzH6cG8ZXFRrggrpvlcIPfsSgC78aK05YTVnma/MpV1fklxW7AI4uGAIx7HL5wsG5wgGZlfSNxgVn4stRUJLRaOeITd4bd9Roa32m7R7HWisoEpR1LgiIiFPFvJi2IsKQGveen+64bB7mJ58db6dAhnfSBiEaujgnEgK+8PODHMKlwBGK+uIVEv7FHewpjSlIHfuzGwYzRHPZPnybuDySbl1WxUG5E2i08QuZH/nXi/gDzfLp8nzY6RVi0YUXr6z3vpnDGv4Y0BlA76psPHKMgqlcLgZf76+f7uPc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/26/26 06:34, Naman Jain wrote:
> Commit 38446014648c ("block: don't merge different kinds of P2P transfers
> in a single bio") made bio_add_page() reject pages from different
> dev_pagemaps. This was needed for PCI P2PDMA, but also rejected pages
> with compatible DMA mapping requirements.
> 
> Commit 41c665aae2b5 ("block: relax pgmap check in bio_add_page for
> compatible zone device pages") allows these pages in separate bvecs.
> Commit 13920e4b7b784 ("block: add pgmap check to biovec_phys_mergeable")
> prevents physically contiguous bvecs from different pgmaps from being
> merged into one segment.
> 
> But direct I/O now fills a bio using iov_iter_extract_bvecs(), which
> retained the original restriction and bypasses bio_add_page().
> For a non-atomic request handled by a single bio, only the data before
> the pgmap boundary is submitted. The rest is not transferred, and the
> request completes with fewer bytes than requested.
> 
> Fix this by moving zone_device_pages_compatible() from blk.h to
> memremap.h and using it in iov_iter_extract_bvecs(). This allows
> compatible pages to be added as separate bvecs without relaxing the
> same-pgmap requirement for PCI P2PDMA.
> 
> Fixes: 38446014648c ("block: don't merge different kinds of P2P transfers in a single bio")
> Cc: stable@vger.kernel.org
> Signed-off-by: Naman Jain <namjain@linux.microsoft.com>
> ---
>  block/blk.h              | 19 -------------------
>  include/linux/memremap.h | 19 +++++++++++++++++++
>  lib/iov_iter.c           |  3 ++-
>  3 files changed, 21 insertions(+), 20 deletions(-)
> 
> diff --git a/block/blk.h b/block/blk.h
> index 50abfd9328861..460c064f1d1b0 100644
> --- a/block/blk.h
> +++ b/block/blk.h
> @@ -142,25 +142,6 @@ static inline bool biovec_phys_mergeable(struct request_queue *q,
>  	return true;
>  }
>  
> -/*
> - * Check if two pages from potentially different zone device pgmaps can
> - * coexist as separate bvec entries in the same bio.
> - *
> - * The block DMA iterator (blk_dma_map_iter_start) caches the P2PDMA mapping
> - * state from the first segment and applies it to all subsequent segments, so
> - * P2PDMA pages from different pgmaps must not be mixed in the same bio.
> - *
> - * Other zone device types (FS_DAX, GENERIC) use the same dma_map_phys() path
> - * as normal RAM.  PRIVATE and COHERENT pages never appear in bios.
> - */
> -static inline bool zone_device_pages_compatible(const struct page *a,
> -						const struct page *b)
> -{
> -	if (is_pci_p2pdma_page(a) || is_pci_p2pdma_page(b))
> -		return zone_device_pages_have_same_pgmap(a, b);
> -	return true;
> -}
> -
>  static inline bool __bvec_gap_to_prev(const struct queue_limits *lim,
>  		struct bio_vec *bprv, unsigned int offset)
>  {
> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
> index c8a4979d4c780..a1d447a847990 100644
> --- a/include/linux/memremap.h
> +++ b/include/linux/memremap.h
> @@ -202,6 +202,25 @@ static inline bool is_pci_p2pdma_page(const struct page *page)
>  		folio_is_pci_p2pdma(page_folio(page));
>  }
>  
> +/*
> + * Check if two pages from potentially different zone device pgmaps can
> + * coexist as separate bvec entries in the same bio.
> + *
> + * The block DMA iterator (blk_dma_map_iter_start) caches the P2PDMA mapping
> + * state from the first segment and applies it to all subsequent segments, so
> + * P2PDMA pages from different pgmaps must not be mixed in the same bio.
> + *
> + * Other zone device types (FS_DAX, GENERIC) use the same dma_map_phys() path
> + * as normal RAM.  PRIVATE and COHERENT pages never appear in bios.
> + */
>

Can you convert this to proper kernel doc while at it?

Also this should all be working on folios instead of pages. But that will need a
zone_device_folios_have_same_pgmap() so we can defer it, not suitable for this fix.

-- 
Cheers,

David

