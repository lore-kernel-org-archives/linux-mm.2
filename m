Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07685CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 15:09:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C2CA6B008C; Mon, 22 Jun 2026 11:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6749F6B0092; Mon, 22 Jun 2026 11:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 564606B0093; Mon, 22 Jun 2026 11:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D30B6B008C
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:09:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 60FB21201E9
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:09:38 +0000 (UTC)
X-FDA: 84907882836.16.A55D6BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6A24040007
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:09:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g22VtQ2X;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782140976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bxSHW1Vtws/j8N34QO2bMrYSzo6we68C9vCirxjCB0A=;
	b=USxcIVoIbwsyxTE4Gtp3YMqyq6PT3Wvr+FMcipToazaHiGmW9/1UwDEtwvghWihhHQzCHa
	vsj1T25x/Oma+u+hf2a75QkbU5USmVlGpcm0JR77R9PjKKd+OraQ/av/mRuoL08b1QjkBs
	MAckad5iQd0zKn9S1g1ra3YVZsbXZds=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g22VtQ2X;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782140976;
	b=KfshObbeVBCL7mOiBFfWW+wa7nHn0bFfT0eAU7/ymrrVff9HboSOQ5rcqQI4a45GQbiC9q
	B5FviMYbFXvzIi/MgrK/pTtP+5YjMkoaHJYl3tpZE1S+p3IWv17HHWSbHLgkVusBUSNp20
	M4ZFzDpMs3AwupIhla0a4jm550W3Kl8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ACB93601F6;
	Mon, 22 Jun 2026 15:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF2D1F000E9;
	Mon, 22 Jun 2026 15:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782140975;
	bh=bxSHW1Vtws/j8N34QO2bMrYSzo6we68C9vCirxjCB0A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=g22VtQ2XyCdUyvrd2wQm4C5MeOpGm7h4/zyi/7eTShhTNg0vkdEqPqEcNu3hpx+A0
	 66BEIzT4vNfrcV7a0cXBPlbZ5oyJNyiQ+XaEShHKgfK9gd6rtidB7fH1cIiC+ublOH
	 fQuEDYICWAxdfwog0yOcpzCOC9xRKopgVCSthAdyV8BTVTpIKIoL1XikpsirO0UMva
	 FAmsdetGjLGVv+LKbL3C8TVsZv+LsmGoreOk0UFLhpjbY/g5w2eAIaX/M/70UH85Q1
	 HC9lHf386SEob7YTCB2sKCjC7/8j8qUVZpZprbYt7cQWIwMFqZkLaQaOy9uqVxbmj4
	 zYgBZr0JBD+5A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 79C82F40079;
	Mon, 22 Jun 2026 11:09:34 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 22 Jun 2026 11:09:34 -0400
X-ME-Sender: <xms:LlA5auY6L8ZEl7TWRkfwC9tIZzs2RRZWtUeHp5SjBvJ4ExFfO6O23g>
    <xme:LlA5ao-HoOcC9KO2dg6f5LX_a2xqlGkQ_Uz1IoT-A07YUtvWc8Bc4wpgn3m4EqP_W
    ts1uU3Am0BQQc33SVGonTlQyZllWUHvb4fzMboCs23tq9OKBQ--QqH5>
X-ME-Received: <xmr:LlA5aok8o-1nR_V_BIuBL-Z7nXoAJ-n5f4V53RdGBWu6Fk26Mm21ph3H3D0z9w>
X-ME-Proxy-Cause: dmFkZTExngy+hclOlIBXvUpHQziHjFrUpzPu0HcLMBn6PVU60vRl9Bx3SXhYedeiikVCTB
    mwI4XWMI1CuyCvFFIq3sPOvHUPB+grLHj8l+cuAfUVL+YEykiR8td4Hsk0COK8IyDJI5Fy
    V1KIpuTF//psCfMQp6cr2zL9uMAXMcm4xYxSKxsqbRrEfoPxfBXOW/PeAgbr68EwifkAfE
    GNSnwvx1ppu2Ol+mhAtBg98tvw5/Xk37Z8xyq2FbWQzFifyv6HZ3Zeb+PQOF7OJB9sf08f
    aTUUOyhJV5rYjurKuzst7J7ITItKAforxSusKXMI3daQCuew+0QXIqOtvRDv8FFjInviYr
    gXFesPLJDhBNBXjjq2p5LeTUUbF87uwFNZ0aQM8T+nUWr6cmRkADc1tY3fBBf0dresx7cg
    BdsP7PZKH0CTiE0M+ZrFSXTNL8V8XHXSXt5QD+9hHOByNGGFihrBPiVbdy9G9VrlCO8FTh
    JHtGFWY9NES9UCyuLvUGCv+klhdV+F7hjJFgCY02z9WdByKNIiRTIAr9hAfg4XQ9Y9M+sO
    37ILD+kYW7hwv11dAfE0WdneHURitxRGjR3iHt8wN3+Ef20I6g5vV+WLMRhYEuqzTVhIu8
    RJIYzxbmpX1A/hFyYQ5La7nQFGng9YzehksYnwNBIYz3gUenKfzRhom5XWEw
X-ME-Proxy: <xmx:LlA5atY74yYcNHPleibtYrq8Jw1V0PmkC_Bnls0x2uXmea2tH8xlVw>
    <xmx:LlA5agNGHIgtDZkxIa__isEAzIoe9Gk7sSV_CMnjCXdJEGgZFPvYHw>
    <xmx:LlA5ale_Ol-LLMuK-1ifP8X9MEfayt7iHZHArv15yTjkjjE7TOATKg>
    <xmx:LlA5auG9G6BJByo1q5G50LeMEZiAuxH3gWH3qZNqijJ2y2B8hK7C7w>
    <xmx:LlA5aotKOhMgO_10v63X2OGPpj0HYq_sRfZNr1sDTbgaYCXl7plQmRqP>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 22 Jun 2026 11:09:33 -0400 (EDT)
Date: Mon, 22 Jun 2026 16:09:28 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Michal Clapinski <mclapinski@google.com>
Cc: Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: init tails before init_migratetype
Message-ID: <ajlO8cYdhDnbuvV3@thinkstation>
References: <20260622101901.223961-1-mclapinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622101901.223961-1-mclapinski@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6A24040007
X-Rspam-User: 
X-Stat-Signature: 5mr5fgsuhq1hkrfizhx5u55w9rr1sqjz
X-HE-Tag: 1782140976-535004
X-HE-Meta: U2FsdGVkX19Drx/cZ39kuBrklIIB6W3BA2ZMwiOiwYZA2O6FZvoox4TXsB31Yu159qSoBMc0fAHsUxmNu7SF/cmS2hA9vk/gi9L0BMibgHpU3bc7qovUmvWBNIAsha17ozU944Ys2C128dhoa3vOaMJPqYhqHM1D5v5bhQqBazQUzHPcGB7/jlu6Hs0vTF2DZnRQFZxljm+2muTnBKvhpqBaAeozaM4G4ay+HgM07IxTE+2tWKOSr1xjt45197Ulez/ozNJPuLdrBpv3zj01nEc+O9A06JcvqHgT5Z/rjG8kC9zRoFuoTIM06kv+k8prfEB2t83FZ+lPtbGRmrOt4bLDWY4VBC7rkRbOl3frZohICUTWx7hLB2dLeK3yxeH5xyD2TDLPODX+FpR/ItLJpGJ2SHmCEJmYMEO6/H1Aw9EII7O8+MOcv4POvEjXw5tw3xN20/osyokKtABSJyycIBnvb1AcK80fQcF08RV7DnsLBKHLJAp2Wcxo4dAePHECguCAFHZL5iKZlJkkF5iOqWgJ/ljyq+eu3pQxNTmd6q4HXaGBqCKLRZZjpNDIAraABDFc7voLNO7Q6RuROzSC9st3a5l7BuoE8eqZBfNd4KDL/WIut7Sd/aTU/vkp0JB0EmYam2E4puOAoDV83sb1zOC/aNsf0PXv2h/RB3x1WGip0FVqY/PkX9vQbqKYwMTSOLkecU12kDEmtzeN9Ur2ZlW/zg0pzUON5KMkUkoPicdGSS1lAQD0QgVK8tq8L9GeFkqTQC1/nNOGTpUg51VPo+ZSS5R84kHj1dOrdtlOOTZHNaDtBQjAIt4sc8FxA80kQDrav1IFhk9ZaVX23i+N7tcOtKTFbKsj2pdleFY2NdU+lRtubhcjOp3cFfqa/0t7YvrUiXPgHDahd7DM1pI6Fr/uj+/rREn+7/wqTy4gY94gdvqXWxk2Ug3uCXiCrkCrbex6hetCvzP94lz9znq
 PFSVoKfy
 wzB/udh6sqEgvd4cejvel4FcZlG99epIVyeeitBhoyqggYHfC0QL3utQhTP1N6Danya1xbbDpfw7d0R/KeXbP90rI0nWWsple+M+CvDVP2Kud1oa+nWRVDUrr89DMH1Gx+5/P7MQu6DNXiIzImQmW99i5KUC9SpOW4303fY7TfAA4yyua30OyNkCNV62Q/RDnFDxjJAZCCMwxiHwLem1v2BeOYuqcnJsUoXyyVL6OFaXVAUNiinWgqo377Ys3LkCT4tYMx5qkFTEujrHekhvuaWCrDd3AvxZScKzb4fIrq/y9GJNqvnbMMDpFzmRUZQXF3Ej0bZ6m8csMoBLuiCj4bTzF4Uwf93UvAXpq7uQa/Dl1fHh7UuTIhBiH5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 12:19:01PM +0200, Michal Clapinski wrote:
> Currently, if you enable HVO, DEFERRED_STRUCT_PAGE_INIT and VM_DEBUG
> the kernel will crash with the following stack trace
> 
> get_pfnblock_bitmap_bitidx
> __set_pfnblock_flags_mask
> hugetlb_bootmem_init_migratetype
> prep_and_add_bootmem_folios
> gather_bootmem_prealloc_node
> gather_bootmem_prealloc_parallel
> padata_do_multithreaded
> gather_bootmem_prealloc
> hugetlb_init
> 
> on this code
> 
> VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
> 
> This code looks inside the struct page which will be uninitialized
> for hugetlb tail pages, which will cause a false positive.
> 
> So let's initialize the tail pages before this happens.
> 
> Fixes: 622026e87c40 ("mm/hugetlb: remove fake head pages")
> Signed-off-by: Michal Clapinski <mclapinski@google.com>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Tested-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

One nit below.

> ---
> I think this one check is the only thing that fails, so I can probably
> just remove it instead.

Please don't. It caught a legitimate issue.

> ---
>  mm/hugetlb.c         |  1 +
>  mm/hugetlb_vmemmap.c | 14 +++++++++-----
>  mm/hugetlb_vmemmap.h |  5 +++++
>  3 files changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 571212b80835..de5e7c104c10 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4127,6 +4127,7 @@ static int __init hugetlb_init(void)
>  	}
>  
>  	hugetlb_init_hstates();
> +	hugetlb_vmemmap_init_tails();
>  	gather_bootmem_prealloc();
>  	report_hugepages();
>  
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 133b46dfb09f..cf485c101926 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -867,14 +867,10 @@ static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
>  	},
>  };
>  
> -static int __init hugetlb_vmemmap_init(void)
> +void __init hugetlb_vmemmap_init_tails(void)

While you're touching this, please also fix up the now-stale comment in
vmemmap_get_tail() in mm/sparse-vmemmap.c, which still points at the
old function.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

