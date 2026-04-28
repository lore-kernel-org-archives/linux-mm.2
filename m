Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79E0DFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78226B0088; Tue, 28 Apr 2026 03:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A28136B008A; Tue, 28 Apr 2026 03:30:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9177A6B008C; Tue, 28 Apr 2026 03:30:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 795A26B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:30:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 22573404D6
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:30:29 +0000 (UTC)
X-FDA: 84707141778.06.748C506
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7EE8420014
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:30:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DzAuyE4m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777361427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vB0MwZldZDv8Ot9Iyk/GJtj0eYSJ/ozod/d4F7lt7E8=;
	b=M7J0gwPPB16rzKlyqr6EMQej5Kgfc8UmZ6FIK/TMb+3bcKglXa5W8JOxs+TWKrNS7nhx7J
	cmIxdwFPM6pa/FJK7a/ejp/KbFOROnwufXHCIGpdt8iAD+4PSHfagkbPHgwAuIx16/CSHq
	PRPCU79TTpnsEpW54KXIZTiE8nWjduc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777361427; a=rsa-sha256;
	cv=none;
	b=zSs/Pe5LflONNb4XOh3QKzKP+7vt71p5c91mNUhPbedBemIDaUzyYzKMKRr6hGSOwFHuId
	KLiYKQ7lDNQF211ZYw+nPhiDT64KulMNsZLld2PijU6undKxtJY4oJputmHyMdbeQ//lMP
	pICWUPkXRGSyz4s3Z+qFb3qaMlSHiv0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DzAuyE4m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B196660133;
	Tue, 28 Apr 2026 07:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE594C2BCAF;
	Tue, 28 Apr 2026 07:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777361426;
	bh=NUkahn2fQKcVscwh1ZNhP9Ux4hzuiTG9l+Ex0RnXqrI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DzAuyE4mHR73GXt0aEhL4Y1y83XCRo5dzQEP/Naos4y98wjCQ3+9aVHy87wYPKQm+
	 UyvY1H4A3aspMp0YlGRzaaUe5/YbbHn/YHN1tLdka8XMlHq9q0NvVois7IJSPXFSqK
	 vMZv9CHHYxEQ9z8gIpmeOg0a2KgeizAFD5YSP1VeSjqtkkFjuFQ39sTC34VNvNDMiR
	 BqN+HDCOHVr5miGYAw2BWbnMH+Ifcq3QUG9DctkZ8+uruJzCf6i6RnZ5o6wRH5DKtL
	 sOpCO4BrNFXx4plg4ylgJhsiUBNjYKTXiPrwg9lfXVo+rqnvVWmE5jUYURupXpH4I9
	 KBsRCgfEo5Ebg==
Date: Tue, 28 Apr 2026 09:30:13 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/49] mm/cma: validate hugetlb CMA range by zone at
 reserve time
Message-ID: <afBiBUq98Msv7ZFc@kernel.org>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-15-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405125240.2558577-15-songmuchun@bytedance.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7EE8420014
X-Stat-Signature: qji45jfxs5npssd333cbu81zmzxmnypy
X-Rspam-User: 
X-HE-Tag: 1777361427-86987
X-HE-Meta: U2FsdGVkX1+g2gjzmvKKN2JrXkfZ6yAJpaxahbISdnoe7dW91FJUhKHgu+oDlvV1ltyJml0hPN4bijacFheF/aeBLHsHL/YtxW5xlf57lBfuGgQ6UncGYHmq2EyGqPVfuZer79nlgVDQp8JBHyiAqUqKM7jfJh9i2F+ye/n62W6Nz7cSvEEUVMydMzwbIekEXDTdTL53GpK0TnoCMFWhDXVWx0SYpAQTJOI8WlDhzk+qpC6jnWGfTARv5EBv9DZoROntrOAfeH/WoaqgJlObX1phr5lD5xvW+gnqjdhgOcHUHxJTudaMqJeA5oIc/Y5HpuRdRF8ujvwu7y5YA9DpjA9OnPNWoE7KJPAiPwKvEXZezzxDYDGWG1B0ipt75K3S5asVd9d87YCcRolsBJIJadi+AvuazJrT+rKnUI9RxSWd74xWxAOynRCV8x1wPggMmxIcLPLSGeM9DpSwQRm9rEVuEm05RlBZvfGF5bIgVDZdy8DM0L8pTwZg1OGn7fjq4zJ4ziEEgKIGNW6sfYiwx06rhe46I3o45OxM6ZYUY94Hp9O6BShF1AtcZYEq+k4X+D5qpUZhCa1/gCRAcUDnZCVTcd6PEpYR2PGbRI1Xnx0H0nWBoTcwmmJexxKsRWjcruX3sZpCmGSeuEMtekoPAebSF62J8fEk6xPGEtnAA9FaQwFIqYzyUjptqRuXTKtjDzeT38KpSFxI6kRvoFL+cX+dbvJn4Ii2UE3B4ezJiTzyBJnZv6/B6vC0iOHycSnvtY3/zeMsDYWdd8qxGf6keqJptgETkZcNTXXz6tggpOLACtZBCtTPMFz6YfZb45n4U2UIwnJElWvDhCLj0sS9w4pQq1BOZGl/PnDTF7xnCR5a2pnaSXkZMf9aKYf3nPfEuEkle7Z1xfkHsh+bBmXfxgZneGjfnR3ajyzOHhQc7s4mHyk8ylqEhDhwm3tx5NYlXtAgVwv+BWUATiQB9lG
 h14LEPze
 d0jf+OdpmqVUoSkPzQCY+msq2CSjyQ0WYVvkzmptGqqPKlFrQd3KksvdfBwAOqoWFHSf6Q8QH+KjDSAst3N1pS5PuhQSB4fVOhJsmOd1HQuqKyzcx9Kg4VY+KBEErFXtPgm1n3N1GomsCO+w0twW8Txe/jGm+7qxTjMeQyhQCtzT6y66FQAHCBq2Ggiwqr7lkA+s27veaixWVMNk10Dc6LVltJRRthVqLlYcMmXK69HMooanrzvtmtd9mNkD0ZI4loNobE4kSqtHYkH6W5oLcWVoQoJtQYMr8M7q3J4JUfxLsAEA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 05, 2026 at 08:52:05PM +0800, Muchun Song wrote:
> During hugetlb_cma_reserve() we already have access to zone information, so we
> can validate that the reserved CMA range does not span multiple zones.
> 
> Doing this check up front allows future hugetlb allocations from CMA to assume
> zone-valid CMA areas, avoiding additional validity checks and potential
> fallback/rollback paths, greatly simplifying the code.
> 
> The pfn_valid() check is removed from cma_validate_zones() because mem_section is
> not initialized at that stage and it can trigger false warnings; keep the
> sanity check in cma_activate_area() instead. This is preparatory work for the
> follow-up simplification.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/cma.c         | 3 ++-
>  mm/hugetlb_cma.c | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 15cc0ae76c8e..dd046a23f467 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -125,7 +125,6 @@ bool cma_validate_zones(struct cma *cma)
>  		 * to be in the same zone. Simplify by forcing the entire
>  		 * CMA resv range to be in the same zone.
>  		 */
> -		WARN_ON_ONCE(!pfn_valid(base_pfn));
>  		if (pfn_range_intersects_zones(cma->nid, base_pfn, cmr->count)) {
>  			set_bit(CMA_ZONES_INVALID, &cma->flags);
>  			return false;
> @@ -164,6 +163,8 @@ static void __init cma_activate_area(struct cma *cma)
>  			bitmap_set(cmr->bitmap, 0, bitmap_count);
>  		}
>  
> +		WARN_ON_ONCE(!pfn_valid(cmr->base_pfn));
> +
>  		for (pfn = early_pfn[r]; pfn < cmr->base_pfn + cmr->count;
>  		     pfn += pageblock_nr_pages)
>  			init_cma_reserved_pageblock(pfn_to_page(pfn));
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index f83ae4998990..b068e9bf6537 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -233,9 +233,10 @@ void __init hugetlb_cma_reserve(void)
>  		res = cma_declare_contiguous_multi(size, PAGE_SIZE << order,
>  					HUGETLB_PAGE_ORDER, name,
>  					&hugetlb_cma[nid], nid);
> -		if (res) {
> +		if (res || !cma_validate_zones(hugetlb_cma[nid])) {
>  			pr_warn("hugetlb_cma: reservation failed: err %d, node %d",
>  				res, nid);

The warning here should be updated as well. Other than that

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> +			hugetlb_cma[nid] = NULL;
>  			continue;
>  		}
>  
> -- 
> 2.20.1
> 

-- 
Sincerely yours,
Mike.

