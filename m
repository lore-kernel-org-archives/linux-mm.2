Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFE9CC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 21:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082116B008C; Fri, 18 Sep 2026 17:22:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00B356B0093; Fri, 18 Sep 2026 17:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15BD6B0095; Fri, 18 Sep 2026 17:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B67306B008C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:22:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CED2B120819
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:22:39 +0000 (UTC)
X-FDA: 85228157238.21.AF68BD1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0F4BF180009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:22:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B8KzO6ly;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789766558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C73E6Le+67WYIluMdsgmrs2q/oVPB+LK1n/ed4dGSno=;
	b=OoDqC9K52L2BLQw+Pa9xsT0lPoSOM/mx6jYdWvZGKqPwMIYuWBYYaSw1DXPzNxIvt7GNql
	zIidnjk3e7xfMnQaLZHoo2r3vkmqBurik3zLixUIdCU436KWBJ3c8nU3FsCfuIlIJosWaO
	EHB5JtbhbVIXW7DbXdxw2Tb39+Bi4f4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789766558;
	b=SHcIW4A5VYKflg3bv8+J7X8QWRjkWrEK/G5nUdjLaD4tZLQ5ZhpYuQx4P/G1sN0VYOpR1F
	C++QBNJoeaH1hY+cDRpLi9x2un2gabfXr30ef3ooNbbgNSi5oP6lt5H6roZhXCApHDnUsn
	1gDiYt8JL0uQ8T+Pz7ZZNiyS5Av/YTA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B8KzO6ly;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CCA842B86;
	Fri, 18 Sep 2026 21:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DBB1F000FF;
	Fri, 18 Sep 2026 21:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789766557;
	bh=C73E6Le+67WYIluMdsgmrs2q/oVPB+LK1n/ed4dGSno=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=B8KzO6lysIoyffMg2GGY6hxUGrTPlq5HDRDp45GMbDnFnHPrfc/rKa07eAN1espP9
	 w25mOHnGeumnnk+YMtk9hfHgMOtM4wRF4ZtE8r1gnaBcoYGQGH134kZ+LAGp/kAnoj
	 Qrqqb8cz3YoZo/dvTElPbvISAGhsIXgRMaabG2EQLwoL6WbqWK7lwVrhtztRnqn0wK
	 o6qMA9yhjR46HAZuBjpW5d48VZu2t/tJqryIHHrX1wBWRU9otRFxDjPop/ysX1Tr2k
	 bqdXTZVJ3i7jXIPUN5hw48c6VbLjErL15WGD1dCYdiF5u+1m7UKPaadvMHALHWs+ez
	 GaJceCdAzuK8g==
Message-ID: <47ccd5ce-2301-4ddd-881c-d57cb82b562c@kernel.org>
Date: Fri, 18 Sep 2026 23:22:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 04/29] powerpc: mm: add PMD swap-exclusive helpers
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com,
 Madhavan Srinivasan <maddy@linux.ibm.com>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-5-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914122950.3283997-5-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ci46xpihx8co8w6obchheigpb6unwghh
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F4BF180009
X-Rspamd-Server: rspam03
X-HE-Tag: 1789766557-249515
X-HE-Meta: U2FsdGVkX18LKlufRRKqyrCdJ1K9jR8MsvOo2SBsH4xz1dgni8hOjRYUq38WkiAurmVGglfAn2W2AoYNIVfWeeTgMLcxK1aTptphdnNW8XG+ao24yQdsXa+qITWc0J5BULDkn+ur/FcC8by/yrz/kxVN2L0L/wX/ugWwa6HuDfehx69z/Su+W71KU7S8psbTasBWJ0SnYCiRSQFpReN3nbXczC5qdUs1cpQ/FP9Kd95ngRUNd+qhSLfFtLq0YdzfHhQNunJDIIFRtQ4I21vz9R45MbY/bh+C6JPMZZfCPSPAYvj6EysR0XbUYxJsr/6b8i9/Rx4Zkmd5mU3PM2bulBTrbfnWSN4ugU9R2TcyQtq4fxZeX2lNIUbjaiG3AWR9OUX+WXIp/7IaR/1e60F7emJI+VDSDzx1KdcrZ9Chp2pNcnAqSdtBs/NhGHxA7rA5TcIr2itarjfKp1oua8bkfRufMl13CkXVzhRcvQVAdoBT6LBCZx6wrgWYFt0iQ6C/r5y7JmMmb9Xy8CRkL8/IxvanvqMvGGcQURrhJHjUwc977KaoOWINGJK4YVO7TXmDBFHu+TEy1F8gBYyp7295fu+qgtGvtzIr7FE3zTz6uAombaeeN91stZbSkG/xb8ENV/45HKUxiBynB+Qk8D/zgZeCDT4JOQIxdIbuZUEdrizM6ViFKZEmEQNMqpYfFNCQMzZ1+CNshheieboxdYnVhYYsgjYIJGVDojqCgmBKwk1XLqDdooSKEDwSgvLxV4Gn4oST5HPINXrpzFbfpiPe70cRc/qTpQWuOxcVoYJ8MrRN6YY8zLPse5z+2idOtPs0ho53trGl67if3zYB/4KtqKROam2goWXGRgpR1daCrvwjKJotastO+7vTEHuoDYpo60WxjGcQjXlhZV5tbqXFp9bYHma27/1zjvSmqgN6NWn4hBZnaFibMj6zuVlUJddNwbs8jQGkMHIdV7GwYuk
 z3CYOLnR
 ooqmmReblTMpFyKdy/hHztBujVchhyxQibd/ncnyjXNV35F2ZF9ICHi3krTH+OI+LW49Xu9kCPey2+wJunODizLo1jDhuqwUOACVkBJqNa0f4VaCaWiXh6UpnmGifU7OuvFD4J3xIocUDvsmPN4AcizdL19bmf4I+lVzNXHaVwjEyg+CytGV8n38GoWf6PXUDQb+DulBezj7thSUep8eJUfflsbJOWY7GwXXVZ30QrpqehFbHC/y6wJ+YXf9WQi2JmdCSD1HdpTQwntc2QfZ8oL4G+7SZbir+Gxu2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 14:27, Usama Arif wrote:
> A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
> swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
> not just in a swap PTE.
> 
> book3s64 builds a swap PMD by running the PTE encoding over pmd_pte(), so
> the PMD helpers use the same _PAGE_SWP_EXCLUSIVE bit. It is also the only
> powerpc variant that selects ARCH_HAS_PMD_SOFTLEAVES, via PPC_THP.
> 
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  arch/powerpc/include/asm/book3s/64/pgtable.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
> index dff8790a047db..28943ef3c1c80 100644
> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
> @@ -699,6 +699,23 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
>  	return __pte_raw(pte_raw(pte) & cpu_to_be64(~_PAGE_SWP_EXCLUSIVE));
>  }
>  
> +#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
> +static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
> +{
> +	return __pmd_raw(pmd_raw(pmd) | cpu_to_be64(_PAGE_SWP_EXCLUSIVE));
> +}
> +
> +static inline bool pmd_swp_exclusive(pmd_t pmd)
> +{
> +	return !!(pmd_raw(pmd) & cpu_to_be64(_PAGE_SWP_EXCLUSIVE));
> +}
> +
> +static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
> +{
> +	return __pmd_raw(pmd_raw(pmd) & cpu_to_be64(~_PAGE_SWP_EXCLUSIVE));
> +}
> +#endif

This should likely go below the pmd_swp_mksoft_dirty() handling block?

For softdirty it's e.g.,

#define pmd_swp_mksoft_dirty(pmd)	pte_pmd(pte_swp_mksoft_dirty(pmd_pte(pmd)))


Why can't we follow a similar model here?

-- 
Cheers,

David

