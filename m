Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D89D68BE8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 07:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 502F16B0088; Thu, 18 Dec 2025 02:49:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B0656B0089; Thu, 18 Dec 2025 02:49:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC176B008A; Thu, 18 Dec 2025 02:49:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 292AB6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:49:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC46613C2AD
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:49:51 +0000 (UTC)
X-FDA: 84231817782.20.0AB5408
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 431F0C0009
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:49:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="K/c2SWuZ";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766044190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ChZHrXjzBgR0dqg62h16b6r1YxZPBY6iz2jpH4K+lgY=;
	b=RG7MaIgeNv6SoMKPYi1VUWC8WFcKrYZTON9OBKBvFvqEpw2vdnw5NwMepP4WO3SWX5qPUG
	Cewv5j/DC3UMt9Huy86GPPuhcmvmgZ50/Mix0WbZu9wNKOhu0+jaIK1dHq8DplLN6COAsu
	9twvh7bHR8Z1d8F1aTpVtbdyNDraAFQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="K/c2SWuZ";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766044190; a=rsa-sha256;
	cv=none;
	b=TvbphxehcFD5geBp0faOSWva1sT0qlH+DRxaUYMxzJ2k9tSwE4juCq1203b0sRiWpxGDEG
	UOkImZi0SscLl5rNSrZunN5W3qlpgU4yimfTn+4jVzgcB38/vM3PAA5lnGej+CwC0Zs+JJ
	BDdfbjsvNheOaZFMTtzy6zuN2FUy8oc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 79C92600AC;
	Thu, 18 Dec 2025 07:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39C1C4CEFB;
	Thu, 18 Dec 2025 07:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766044189;
	bh=6hWr9VPgXU8Tq3WyWcIWZ53BCbVptvGvP90d3Gdgcuk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=K/c2SWuZ5zJkEu+Y1yk5X0LsveGqtcKkrhA9l+sgGx+tiv42m6esO0dkJ8qFqmFTD
	 X4MQfQVy/hdSAmOaqW63/bfRNEgegrDpg0zkJiVVN8yZOp2PhQZDd8Luj+I9Zc0ogR
	 qxz+Q+E6gmwFtzcJ1J/oVmXxXYWiMckPSZJ6M1uB+UvcMoaOL+FYR2jZJPahKDHrBO
	 Z8/aE2ke7Fl9Gm/J4bMqaVhZ32CeFP0HcSpTKHpCpB4b+s/Qk71VRwepcP/rjbGoll
	 IjWVevtZnjioMr4o5uIY7cA6ud4lb7BqRAmMq4iY7w8En+YkgHcwZOF1IXy4GF3ALx
	 95sNL0Zu1y0qQ==
Message-ID: <b34ce151-45d5-4074-a869-de93b2bcdef0@kernel.org>
Date: Thu, 18 Dec 2025 08:49:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 8/8] mm: folio_zero_user: cache neighbouring pages
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
 boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
 <20251215204922.475324-9-ankur.a.arora@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251215204922.475324-9-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bugpkqeki3uox5fn3xjfmh85bst6ytyf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 431F0C0009
X-HE-Tag: 1766044190-582925
X-HE-Meta: U2FsdGVkX19L4VGoK1xqRwNglf8z+eZnZse396hN9Nwe/R7+FsdA3LpBKjNov4IpT8aiDCx36HTfGHfmFmLq7zOZs+sB55xvbxlo7K2VoVc5n5SR+3CiX8KHwzEi78rlE7JzOeB8KnuklRreSGMB1wu7srZsVcxpwK7QtRckPjMQgp6P3hR5pc8eL0w6fxwQgOQiGn14rZuwAe8rCDdwLIqfiwXEZQmBSKekQM3vllK/pyXh9xY68MGJRtDxJs1RFYeAt1aam5V0qZw2t4JBZ1nD7tn0yzvgxwweDx7kTnqxmEy7zh9onzy1NF7cKRzQQ7tbKBYA9QutEdYiDXQjCK2REJnRnUEbT0AlKwOym4itFwjO+ua4SAIPUhq22WNNTyW7oE+H8Nqlv4iLFbOIYFIu3hNiVwenaRF1CPJ/TXMYwYI4c+Aa0zR+F9zqH5BDOYjWwWrAjjyNEjxRNllBrA/B3YRYwoven1lnYRYM35fJkUUsuQ0WAWzsvA7TNx4tvOjOyXholx8xC2Z5RADKM8F1ygMYY1fsd7I7r3E/ib4qacIZD531WLcK3qGUCd9WSBnwUt709+S7WjcmDkJS+9CbvvrwNfYpIXltGz/fwBdtB/EQrXAZrzpAGmv8mQ+UMc3yAYP8O1pBR3ased0y1nGZJ95iRTQmDdkNnQczbhH2A0TwW9j8qST8YAnAR4HUGomDtmV68hskYSu98cFqHZ4MjE60whAxsAH8+wiphDpFrA3bsHj1C8mK4dnM3LXkxZqnxN8JiI5oOFdVbhTjYcbAu8zBbRhCRmNLG4tMlOdhaOgaLPd/VTpev5/jszlmO39H5u358MdfZxlA6P2snEbzvnvdIwE2TI6183YZiUI9WpNCYXoBUaBl0t1Pr1Zd7hIvancB/FP51v+lSLhd6sIOvMe0nx33jMB9JQDNc/YLweCjozCwRZnL+qdJkz0XJ3lsJ0OCKwXjbh/qWEN
 iUndIjJh
 fdrRgV2Z9Q9WYj7iOw6GAFjtUfOVoMx/tf+r18aoaVYiZGEzVqmpqGuQVrfWY/oHVHCrQEvTDfo+k/MpSFli8aps/BiMs+ckUCz0IP2wpKoxhfinG5qOr/rq9WCvsxHT5UdCm92c2RqPtjuXy/7TiuRtZORX69/eI3iTz8Z97/ude3XpfR0f4L6YgJryZO20J9H3tJTTpBb7SnW99qdaTJEASXxFn2ZXuldyGyIFZ/BUkNuS/DJzqREgje0xJBeQhDexDJwtOu9j1JFE9rx4GmCLBs481YI5YfnvUamjBSUUvoSDQEW/jaBFBYSyxgoKLJ3Ly1zacz81HkC2hGhZZdz6jybkp4r9NJU8C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 21:49, Ankur Arora wrote:
> folio_zero_user() does straight zeroing without caring about
> temporal locality for caches.
> 
> This replaced commit c6ddfb6c5890 ("mm, clear_huge_page: move order
> algorithm into a separate function") where we cleared a page at a
> time converging to the faulting page from the left and the right.
> 
> To retain limited temporal locality, split the clearing in three
> parts: the faulting page and its immediate neighbourhood, and, the
> remaining regions on the left and the right. The local neighbourhood
> will be cleared last.
> Do this only when zeroing small folios (< MAX_ORDER_NR_PAGES) since
> there isn't much expectation of cache locality for large folios.
> 
> Performance
> ===
> 
> AMD Genoa (EPYC 9J14, cpus=2 sockets * 96 cores * 2 threads,
>    memory=2.2 TB, L1d= 16K/thread, L2=512K/thread, L3=2MB/thread)
> 
> anon-w-seq (vm-scalability):
>                              stime                  utime
> 
>    page-at-a-time      1654.63 ( +- 3.84% )     811.00 ( +- 3.84% )
>    contiguous clearing 1602.86 ( +- 3.00% )     970.75 ( +- 4.68% )
>    neighbourhood-last  1630.32 ( +- 2.73% )     886.37 ( +- 5.19% )
> 
> Both stime and utime respond in expected ways. stime drops for both
> contiguous clearing (-3.14%) and neighbourhood-last (-1.46%)
> approaches. However, utime increases for both contiguous clearing
> (+19.7%) and neighbourhood-last (+9.28%).
> 
> In part this is because anon-w-seq runs with 384 processes zeroing
> anonymously mapped memory which they then access sequentially. As
> such this is likely an uncommon pattern where the memory bandwidth
> is saturated while also being cache limited because we access the
> entire region.
> 
> Kernel make workload (make -j 12 bzImage):
> 
>                              stime                  utime
> 
>    page-at-a-time       138.16 ( +- 0.31% )    1015.11 ( +- 0.05% )
>    contiguous clearing  133.42 ( +- 0.90% )    1013.49 ( +- 0.05% )
>    neighbourhood-last   131.20 ( +- 0.76% )    1011.36 ( +- 0.07% )
> 
> For make the utime stays relatively flat with an up to 4.9% improvement
> in the stime.

Nice evaluation!

> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
> Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
> ---
>   mm/memory.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 42 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 974c48db6089..d22348b95227 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7268,13 +7268,53 @@ static void clear_contig_highpages(struct page *page, unsigned long addr,
>    * @addr_hint: The address accessed by the user or the base address.
>    *
>    * Uses architectural support to clear page ranges.
> + *
> + * Clearing of small folios (< MAX_ORDER_NR_PAGES) is split in three parts:
> + * pages in the immediate locality of the faulting page, and its left, right
> + * regions; the local neighbourhood is cleared last in order to keep cache
> + * lines of the faulting region hot.
> + *
> + * For larger folios we assume that there is no expectation of cache locality
> + * and just do a straight zero.

Just wondering: why not do the same thing here as well? Probably 
shouldn't hurt and would get rid of some code?

>    */
>   void folio_zero_user(struct folio *folio, unsigned long addr_hint)
>   {
>   	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));

While at it you could turn that const as well.

> +	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
> +	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
> +	const int width = 2; /* number of pages cleared last on either side */

Is "width" really the right terminology? (the way you describe it, it's 
more like diameter?)

Wondering whether we should turn that into a define to make it clearer 
that we are dealing with a magic value.

Speaking of magic values, why 2 and not 3? :)

> +	struct range r[3];
> +	int i;
>   
> -	clear_contig_highpages(folio_page(folio, 0),
> -				base_addr, folio_nr_pages(folio));
> +	if (folio_nr_pages(folio) > MAX_ORDER_NR_PAGES) {
> +		clear_contig_highpages(folio_page(folio, 0),
> +				       base_addr, folio_nr_pages(folio));
> +		return;
> +	}
> +
> +	/*
> +	 * Faulting page and its immediate neighbourhood. Cleared at the end to
> +	 * ensure it sticks around in the cache.
> +	 */
> +	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - width, pg.start, pg.end),
> +			    clamp_t(s64, fault_idx + width, pg.start, pg.end));
> +
> +	/* Region to the left of the fault */
> +	r[1] = DEFINE_RANGE(pg.start,
> +			    clamp_t(s64, r[2].start-1, pg.start-1, r[2].start));

"start-1" -> "start - 1" etc.

> +
> +	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
> +	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end+1, r[2].end, pg.end+1),
> +			    pg.end);

Same here.

> +
> +	for (i = 0; i <= 2; i++) {

Can we use ARRAY_SIZE instead of "2" ?

> +		unsigned int npages = range_len(&r[i]);
> +		struct page *page = folio_page(folio, r[i].start);
> +		unsigned long addr = base_addr + folio_page_idx(folio, page) * PAGE_SIZE;

Can't you compute that from r[i].start) instead? The folio_page_idx() 
seems avoidable unless I am missing something.

Could make npages and addr const.

const unsigned long addr = base_addr + r[i].start * PAGE_SIZE;
const unsigned int npages = range_len(&r[i]);
struct page *page = folio_page(folio, r[i].start);

> +
> +		if (npages > 0)
> +			clear_contig_highpages(page, addr, npages);
> +	}
>   }
>   
>   static int copy_user_gigantic_page(struct folio *dst, struct folio *src,


-- 
Cheers

David

