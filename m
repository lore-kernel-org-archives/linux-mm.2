Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E614D1061B04
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5649C6B00A4; Mon, 30 Mar 2026 10:36:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EDEC6B00A5; Mon, 30 Mar 2026 10:36:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3736B00A6; Mon, 30 Mar 2026 10:36:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E0216B00A4
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:36:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED30CC2AA0
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:36:43 +0000 (UTC)
X-FDA: 84602980686.20.D0081CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 27A85140002
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:36:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oUjt9ek5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774881402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X9xe30BZq01+2FB9ob3pz1h+4NHF1TrtXSqU8UoZZ/I=;
	b=bzn5Kp0yhNvc5EnEwYc5wiO0x2waSb6snM+dqU9IfvnoaEK+MJugUsj+vBFK2qcCcVMiu3
	dMQIqxDPkWx5U8u46ZZBMxqTuCofPJEif7UtO8ebngPhnORxWeIUzNwSk8YjYzV8d68sYH
	c14d4Fwiwn4haz4VuaxINNIMroLGh2k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774881402; a=rsa-sha256;
	cv=none;
	b=mEG1N03bg18G8W2oupMa6193HNsjIwfnbkk0KaMOTKEeV9PM+MEMMjh140GCVK4K5R+xty
	2j6Tu5BlCOEgBUKnLow9iLVBQm+ZpN0QzzAWyfl4hnKZUZjiVO7JXi5yJ2MuhH+I8w23lB
	i8CakZoq0QKqHn1jHd6xsYzPx3HbxDc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oUjt9ek5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 36EB0434BA;
	Mon, 30 Mar 2026 14:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC07C19423;
	Mon, 30 Mar 2026 14:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774881401;
	bh=UUzXjb9asDBbFYQ/P+S6mXqciBQgW6rkek8EtvcnmEA=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=oUjt9ek5UytYIOgdx2VGoInarZWYBW/OInxfrQunSF4g0xgDSRG8tL1vJ1MMYLx09
	 znAh9a8Dg0WHt5KE0ZhCVD9hZ0EVoluGrE9kiHzt+LyqXcxOIE8WHwnwwAI1HDbmfl
	 yHCYmwYJRFTPzbBzS8FelbBewo6uH1RBI5riq+upPasi9sfo6bxDCr87JYIH14yQTh
	 OgAzqm94Ppz79bio8sBysAt1qiAuY1OfwloOGfAUwzQmFnVv/uqQn2l6JZO5ziM/F8
	 L9cJCYqXaPv3H19VygcorNBXydcIE+NCeXaGyMXAAgJF4vxnL5BkEgy4dUTqZhjFgt
	 eUAGSj1iIyiOw==
Message-ID: <d6db5b93-8bcb-4a34-9e44-3ff948e64ce8@kernel.org>
Date: Mon, 30 Mar 2026 16:36:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] mm/page_alloc: Optimize
 __free_contig_frozen_range()
Content-Language: en-US
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>, Vishal Moola <vishal.moola@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 Ryan.Roberts@arm.com, david.hildenbrand@arm.com
References: <20260327125720.2270651-1-usama.anjum@arm.com>
 <20260327125720.2270651-4-usama.anjum@arm.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260327125720.2270651-4-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 27A85140002
X-Stat-Signature: awgectfq3setwzdgu55bc8pcxnqqqg4b
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774881401-763113
X-HE-Meta: U2FsdGVkX19kd4JC4T6y+DGfWuWyl+xjYN2gdqFzFL5+5UU3L5YreDz8A/gTsXg2hoZP4sd1PQkzQS/c8IDSYoYXL6fFwL8rHSbdSfY/qdJVhKEkUUuslxODDMlCH3JAsMEwhvfthvb911HhqR+aPuPo0JmWT8pGm5SNEqkkQbQR2Wd6/d+ZgOeMd3ku1fHHpHMP/6aLQMocCQrASYJRK+cnttyrpSHGnCoJqJavcVCPo1OR/pcaRQwFBqyw5cmVGndoVpmeM872wk6F5lbx6Aiw7IU3UEMBp8b5CJoMVXSAYEuEDXyHL2qX6N7QvcLNzhX7bbax7jZnSsWY/mwoLt2VStxcXoRM8l7XRT4ga/dUaQtfr4DfsFm3U+BgkTv6rEOhld2O6EMp6k/uUTCUzKLdXHHU47z5weyZ/T2ONK9nMHmgEYUBRBGy9SPUsPAEjJCy6cXSwTVCjpkamSh4NcvpXtLtRFMdJc5Iwd4T1X52x8k0dFicf8wirpod9X6TBlP4PJl+XjW/+69RtOr9O+t46tlvgcv6Xx07wCVa/rxnAA2pFHeLMTW0UCPYAzwEnm6MqWhaANWMzQeH2jwpxWOtcuCLJhFcKLpe/IssehsFfvkvKB5CyhMyq7RfiqNcBO2AMb+xwuCeTOdTVghQtM8c9M4hde9FUBHgOB/Ni/LPs+yPmvV6BqRs3LuHHQAMscXnKoJVBQPkTXRGuVdxRGw0pPSfi9DdcLbqdZ8sNRmWFKpTixHTW+TLHKqWIEtiWXnl+7lkJIvs+Csf8gEpgkWB6WIvQXGM6FJI8FX3xHHewCr3qzgSvCU0X27+Sq2BeIvVaYf+QxKf7Pu0TI1uE+wmVUCsHKPb4Yq3unAg7VPKSuV8i9nK462x9x65VgctoIRXkXL8odfx+3PzFK67bbIxNCNfb2H1FJA/NdCriE0cXqe9/YjoonsGDi4KvIiqai+PXzySkVqwVS5nA3j
 bM03/Kbd
 rS6EmlUVYpin8MG/Ge2WkMxYIJ6DczL70WRYc3Zf3NmFORBqawZGC2bYiMiW9HPOXiPUMWJsaRVX8R5+S1FJj/Ya21nfbQYBUev1WkO4umJQvjwqQiLgTbuxBmZzGe/n/4ojYTX7ZEIBBQqC6m3M1rBcxSx3mcyMqmd6Z6aouHR2TLhb7oqjH7ztdoAPdM6CKZiaw67A9v81awScZpb+HxvrmvmzGg/WDmCYyiUZc4740V75n43pYP6Pf7+293fPhOCK2peQZOOxLh8PzN90c2AFI/p+FZleOre3avP44iEvl6yQDbwqhbDuuwEmXaUtWCkRvPW0HFMjcQ2DyVwQrPmlPBTUtcF8a+Pv7W+/kWy6VIpLe0FcSUK74+durebDaGH+NM0Ew1Z12OcvcduFOSpI1hQKU8Ya/i17aZe0C3ErdOpCm7/85/HfV9kbtFAegYpypUjgc/mN7wzYv/B6iw1Blo8Q1blPH+Pv4VPmkUa+o1SM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 13:57, Muhammad Usama Anjum wrote:
> Apply the same batch-freeing optimization from free_contig_range() to the
> frozen page path. The previous __free_contig_frozen_range() freed each
> order-0 page individually via free_frozen_pages(), which is slow for the
> same reason the old free_contig_range() was: each page goes to the
> order-0 pcp list rather than being coalesced into higher-order blocks.
> 
> Rewrite __free_contig_frozen_range() to call free_pages_prepare() for
> each order-0 page, then batch the prepared pages into the largest
> possible power-of-2 aligned chunks via free_prepared_contig_range().
> If free_pages_prepare() fails (e.g. HWPoison, bad page) the page is
> deliberately not freed; it should not be returned to the allocator.
> 
> I've tested CMA through debugfs. The test allocates 16384 pages per
> allocation for several iterations. There is 3.5x improvement.
> 
> Before: 1406 usec per iteration
> After:   402 usec per iteration
> 
> Before:
> 
>     70.89%     0.69%  cma              [kernel.kallsyms]      [.] free_contig_frozen_range
>             |
>             |--70.20%--free_contig_frozen_range
>             |          |
>             |          |--46.41%--__free_frozen_pages
>             |          |          |
>             |          |           --36.18%--free_frozen_page_commit
>             |          |                     |
>             |          |                      --29.63%--_raw_spin_unlock_irqrestore
>             |          |
>             |          |--8.76%--_raw_spin_trylock
>             |          |
>             |          |--7.03%--__preempt_count_dec_and_test
>             |          |
>             |          |--4.57%--_raw_spin_unlock
>             |          |
>             |          |--1.96%--__get_pfnblock_flags_mask.isra.0
>             |          |
>             |           --1.15%--free_frozen_page_commit
>             |
>              --0.69%--el0t_64_sync
> 
> After:
> 
>     23.57%     0.00%  cma              [kernel.kallsyms]      [.] free_contig_frozen_range
>             |
>             ---free_contig_frozen_range
>                |
>                |--20.45%--__free_contig_frozen_range
>                |          |
>                |          |--17.77%--free_pages_prepare
>                |          |
>                |           --0.72%--free_prepared_contig_range
>                |                     |
>                |                      --0.55%--__free_frozen_pages
>                |
>                 --3.12%--free_pages_prepare
> 
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
> Changes since v3:
> - Use newly introduced __free_contig_range_common() as the pattern was
>   very similar to __free_contig_range()
> 
> Changes since v2:
> - Rework the loop to check for memory sections just like __free_contig_range()
> - Didn't add reviewed-by tags because of rework
> ---
>  mm/page_alloc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 64be8a9019dca..110e912fa785e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7059,8 +7059,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
>  
>  static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
>  {
> -	for (; nr_pages--; pfn++)
> -		free_frozen_pages(pfn_to_page(pfn), 0);
> +	__free_contig_range_common(pfn, nr_pages, true);
>  }
>  
>  /**


