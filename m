Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 017D3CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 19:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B6116B0005; Tue, 19 May 2026 15:27:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 366D16B0088; Tue, 19 May 2026 15:27:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27CBE6B008A; Tue, 19 May 2026 15:27:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 160386B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 15:27:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC4451C0380
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:27:14 +0000 (UTC)
X-FDA: 84785152788.27.84AA7A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id EE383180006
	for <linux-mm@kvack.org>; Tue, 19 May 2026 19:27:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=a0DQELKM;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779218833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxFwHBeP3nF1/C+zpz+/ZGN4ZMGPhZ04dCMyDEAnTzo=;
	b=sLD8XzWR84YfMLl0jquM8PWCxgNDXPjzvMePYRGLPSC1OORRUSN2z7YMipirQ2GEeMchHy
	bomqinoEL2XTNNPIL3E4x03UPMGZbHYO7qrOTAXI9S2UdolmzOEe08Q20PX+4HlE0wVivG
	YcpGpS2y0Pub+8gVuX6x4HyrQHHgb18=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779218833; a=rsa-sha256;
	cv=none;
	b=3ib5yBI2BCIVWscdV1IKt+m+u0ZaitpuVrbmSi4WACsvnvQpDVVExndjPjSDzvFq60i9o6
	s8hDzHgayzLW1hht7FyiBTOaHwBQL7C6/H3pjV9F8j8Wyx/kjEuy8QbPfsQCD4vN3I1ss6
	xaUNmf1H4Ih655HMRxA8w1cYilVupwU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=a0DQELKM;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 083F243957;
	Tue, 19 May 2026 19:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870AF1F000E9;
	Tue, 19 May 2026 19:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779218831;
	bh=fxFwHBeP3nF1/C+zpz+/ZGN4ZMGPhZ04dCMyDEAnTzo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=a0DQELKM2H7Bkj9ft8qMfCCtqm2YvQzoUsSSxjz1z7NGlPknAavUGATNUL8Onbzri
	 M8v2FyaXkH4tqtXeQLySeHNhEnw+PbVad4+F8Cu0CwOLlol4S0cTOF/9ioSYEgrq+1
	 7kY0kpT1/VGWCQ3sBwOTAi9TD2GVFhBnF+L6t0ss=
Date: Tue, 19 May 2026 12:27:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, usama.arif@linux.dev, kirill@shutemov.name,
 willy@infradead.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/page_alloc: skip high atomic reservation at or below
 costly order
Message-Id: <20260519122711.1afe69455bcaf22a0962dce8@linux-foundation.org>
In-Reply-To: <20260519012532.272770-1-jp.kobryn@linux.dev>
References: <20260519012532.272770-1-jp.kobryn@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EE383180006
X-Stat-Signature: tph4k94ha7j8ajfyr6e5chjrh36d9qka
X-Rspam-User: 
X-HE-Tag: 1779218832-23344
X-HE-Meta: U2FsdGVkX18jP4FEmIl0ggHDbML7Lve2aB0WRxM2y+XIUfiXY120f/GAdGLDllC19/oMyeOP5DPMPfNorVpoPmfYjB6sofYAo8wduAf5JVjL6oEcnFrhtdNzF5K0HgbWOC6/nYzpIDWuCHCYaFSBbInbSOhnYd/FIyYCUwCoacsWSAZ3WldqsDzM6FhxmIQc63GiG43Y66Yjz9Xw+LrQ0B8v3uwmqudONnM7IlRqfivp+KdWumVDwRJwyX+PZQZ3NqmBEKMZ+z0cALp1NaalcieV2aEomdUJrLir1aYl+P5QD5DMUFVgfr7BC4Am4acUPfr1fUb8KqCVsOhNKY8XqpGiM1ypK97p0rKYJnBl2PzZVyFPjcP6LQRbQVq7g2pGdL/+ljrEkMETDFZIF8lycKxFpA+QYFzgy58mciuCANo/MdYKzG9Aoh1BA+yKQ+nYvjxgcGoeR4TGK4X9LStcAg+XyqnLcqUpJKIis6PinjSnpjYBux4wsBXDBamEdNWB9NgoRTeVJiTZmRQknhnnS0NCFIz/g/iDGAgLhYOEfikD6qke66vBlFb1/JwRa/Zy/QoqxydPnZFPaz+DDl+3Wnv6Opaw4sWvxiTJNvgkeNSBMDnh7c4XpwasV0SFUnsCKaMCvWDBSK2sv+W28KC+tVQC5URafVbqlt/CwuBL49ChahGOfYUfmrOmSOzV5hdL2vkZ6S3yD+JimEmdSCQ6pAfNn4t65dQbSwYF98USZ8JxBIppCPKEjgk2zTDQkenoW/jPWLmHQjbDgH5ucWK10/cqm3gRbt2e2Saq0V6cEOCJ7nYXG7rJnMb3C66GK0RCLYjmkApoHEuB6tWWD2mKY1tX18jOs0mA2iBl5SaWpiZCJLuXu/+ro/dTGYBa0xRD9eQu9Uzkgsp8thKl/pVgR3NFUUmKayJS1iz6UKT6hEoWs3dB6LqUvM5DTDvqE93ll29OGDlq2nFwByQpUBj
 wgC1pEJy
 vQxrtXhQaj2byoYd0AyTf/hD46Pl0mpqUpVW+A4MqYn+cu+Hx5SWJ8NyHeHkNSaOoL86cxe7ZwvmOf/ZSjKP9DOqUyybAMbu6RdxRoA2J2d3MxWZnzZDX9GtZl6eEh3O9AwkQGkUi5FtWaRftzphkhf0bHiKBIeqTs/0JdzeDlEW9qFpYm7I6ZkQEL+VcSwTfwOcaYa8nPzIxdurzWJ/YZ82wjx+tkHSK7NNVEzyBdsVTsrt5LTkxS7Cd+Du0RSR7bZX4jDhNjLGzkJakDSac4T3ZQ8SqXmQqggXzABPyHITAXeI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 18:25:32 -0700 "JP Kobryn (Meta)" <jp.kobryn@linux.dev> wrote:

> We're seeing a pattern in production where 2MB THP order-9 allocations are
> failing due to fragmentation and triggering reclaim on systems with plenty
> of free memory. Over time, the success rate of these THP allocations do not
> increase at all.
> 
> Inspecting zone->vm_stat[NR_FREE_PAGES] via kprobe on compaction_suitable()
> indicated the given zone had sufficient free pages for order-9 allocations,
> yet they were going unused. Drilling down into the zone and inspecting
> /proc/pagetypeinfo revealed why. Order-9 blocks were accumulating in the
> zone's HighAtomic bucket (while zero were present in Movable). THP is
> unable to draw blocks from HighAtomic since that bucket is not in the
> fallback list.
> 
> The heuristic for reserving pageblocks in HighAtomic is that any atomic
> allocation greater than order-0 will result in the full pageblock being
> captured. This means that an order-1 atomic allocation will over-reserve by
> 256x, a full 512 pageblock.
> 
> Gate the reservation on order. Skip for allocations at or below
> PAGE_ALLOC_COSTLY_ORDER. This prevents smaller atomic allocations from
> reserving entire pageblocks, and significantly helps when THP is in use on
> a fragmented but otherwise healthy system.
> 
> Testing was performed using an A/B instagram workload receiving prod
> traffic. Each side had ~60 hosts with 64G memory. The patch resulted in
> several gains:
> 
> Unpatched
> HighAtomic pageblocks per host: 309-312 (1% of zone or 620MB),
>   ...all order-9 blocks in HighAtomic
> THP success rate: 1-6%
> Compaction success rate: 0-2%
> pgscan_kswapd (total across ~60 hosts, per minute): ~70.2M
> Atomic order-4+ allocations: 0
> 
> Patched
> HighAtomic pageblocks per host: 1
> THP success rate: 44-78%
> Compaction success rate: 24-47%
> pgscan_kswapd (total across ~60 hosts, per minute): ~29.9M
> Atomic order-4+ allocations: 0
> 
> Note that for this workload all atomic allocations were order 0-3
> originating from the network stack, btrfs, and scheduler.
> 
> ...
>
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3446,6 +3446,13 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
>  	int mt;
>  	unsigned long max_managed;
>  
> +	/*
> +	 * Don't reserve a pageblock for lower orders.
> +	 * Order 1-3 allocs should not capture a huge page size block.
> +	 */
> +	if (order <= PAGE_ALLOC_COSTLY_ORDER)
> +		return;
> +
>  	/*
>  	 * The number reserved as: minimum is 1 pageblock, maximum is
>  	 * roughly 1% of a zone. But if 1% of a zone falls below a

Sashiko asked

: Does skipping the HighAtomic reservation for orders 1-3 break the
: anti-fragmentation guarantees for these atomic allocations?
: 
: The MIGRATE_HIGHATOMIC reserve protects high-order atomic allocations
: from failing under fragmentation by taking ownership of the entire
: pageblock.
: 
: If order-1 through order-3 atomic allocations fall back to stealing
: pages, but the pageblock remains in its original migratetype, won't
: order-0 non-atomic allocations consume the remaining contiguous space?
: 
: Under memory pressure, this could leave no contiguous blocks for atomic
: allocations to steal.  Because these atomic allocations cannot trigger
: direct reclaim or compaction, they might fail, potentially leading to
: dropped packets or I/O errors in subsystems like the network stack or
: BTRFS.
: 
: Could background compaction or khugepaged be used to unreserve
: HighAtomic blocks dynamically instead of disabling the reserve for
: these orders?


