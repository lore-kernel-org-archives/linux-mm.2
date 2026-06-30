Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A9A1C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDA846B010B; Tue, 30 Jun 2026 08:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB1706B010D; Tue, 30 Jun 2026 08:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9E26B010E; Tue, 30 Jun 2026 08:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A08876B010B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:44:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01283C23F3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:44:08 +0000 (UTC)
X-FDA: 84936546618.16.12AD457
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 295F2C0002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:44:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lD3BZvWa;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782823447;
	b=B5lTgY/3k5NipwqhDRCL/83JgrFSDmLnOKzWOpVr0qD/v/fJOM/pphq1BcPjzgtALFpM0h
	7wBtjavgtb7VvOtkQivM1poaVTopf0dylQbfTjNrcTFv1eMlRvEcPFwKKRg7Y9Tv6Wj+I6
	SQRJundC9w/FCHS6wlC2rusEvKFVdig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782823447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P0adnldm8TK6ipv/lOGCfmnuD8juohd0zUTPMiBbPi8=;
	b=QPdhF30gW2hm352zFP+ovFmtr/a2OE/2fB6mbwzMcQcw3nK92D1gmaYmJvSn+1l2SfuCgB
	WKQnl2+qXJcJ/gi4bHoHvpbA5mKOA12wdruun8IAYwTSAz0/O+eLxqeF5GHyf6pUtlP4Mg
	4PmlaXFb2UdX+TfeRZGu7nBRZBROln4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lD3BZvWa;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A770437FB;
	Tue, 30 Jun 2026 12:44:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC101F000E9;
	Tue, 30 Jun 2026 12:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782823445;
	bh=P0adnldm8TK6ipv/lOGCfmnuD8juohd0zUTPMiBbPi8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lD3BZvWaX1EwmVrvf1qwnpfvnmdk6yRnka8Da93gojUcYJhWk3EmYzo2xwntJW5yJ
	 j8PDe1WukQ8KwnyMWky4BE5yG4hIRY3m40deLp3IwW/ExkZpEgOBQekTmEtKiTNT+X
	 50rY8xr28kw/N0jtGaG1vDSLf8NswY5kL1TX+KcnS5Ud7RXzEwn1bAsCnH6isghV5k
	 bVNDXbEsSz0grLee/GUMQ2m8ddY+A1MXIIf1y5s5OwMkV8tHIXuGcBqzxXCY0Bx6ly
	 XVp/qJ7kNO6ovYpSOiMabmhpMQzV3LYnEK7denzXQteOo03uq8R5relIO3OnTGM4Ti
	 GeBiigFn5OlkA==
Message-ID: <c8c538e2-11d2-4484-bea3-49955d1a9b10@kernel.org>
Date: Tue, 30 Jun 2026 14:43:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/16] mm: name some args in a function declaration
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-3-57bef0eadbc2@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260629-alloc-trylock-v3-3-57bef0eadbc2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 295F2C0002
X-Rspam-User: 
X-Stat-Signature: dw91a3hygytsymgfq4ugi1pb4pk3ahsn
X-HE-Tag: 1782823447-692013
X-HE-Meta: U2FsdGVkX1/FIbs9YejsP/Qz45WtdxucQ/InCcrvNrbRCQALN+TGCMDoHegxQHfg7IBsWxy2///1zmgwOwf47pF5ue2Tp9ZZmuhpp/A359oj0dR5Ar8xT1jMipLQHUomydhbKBbKy2dR/E9nzw3xvK6HhvX7wGMrdVyOvF+8SIbh8OvMBhQG10j/JWr5cj8tnflFWdX/wKP0lTNDLG2gddpsg9spUiWsXDVUrFaToupluBlL3zCuICAhwVhxyoHdhAbtuiWwke6tgS1l5scNeScycuKV0q8VBH/DTbZMLvcazdhIc5VcSfgnghad+IE6WZ4euPXUcfqD+H1nIux2H1Nddmti4zDQHfMLsmIi/f7Evqr7HBUV4Tbu1V2Z3TB0LSydsS6wOycFypVig7fhy6gKmt0Rq6ZMZwnl1hG4CmB8yGLd8hBcx970HPJTeztKS4fIOgA7fj3GkPzDCRx5uvFV4rdITi0vPCn5wB0VYfMlJz48PG2FxnmOaNNPgG9xMec6CiqgBllWaADo7WY4NANglCavRTYGc3FdG4OTCbsfq3arHa6rYIcYr+KhxirpUe1ISAxbFYEX89754zZWsYJBFE0omMCEbTVh6M+skYR0uvZYwtMTgTuyJWT4dH6MHygbpc2BIWo0ilSnlDxpLXMPTMDlR2jPNYcLaxX1bf5oQ0WNlpFSMJSN0DvYpTwYzXD2zzJov35R/+Tre75wuZqZS/XeQrVdsU1yCncLpLVZRWfZQ4IfT/xZnKIz6o9eq11D7fkcDwakb9QH7wERtIoeJ/Auqi919m7KLR1csOCU+DFCEEb5MN2Sbabkebp+QwFpXBiPgqR9ydMD1UgwRUJxgj3/0lcojYPJO3P09QvhxVSwnMg5l7m5p66VL9JimeYbvXW2p2btsmBU6BYQhF8vQgaod0oLAssLU5kltgcMPpRyEMxZfdXfAuU6UfJCQAFM3oqskIuOMUgDd53
 t7VVv7u5
 SzN4+PU4aXCGuJWxEOHeJJ6JGZYG+wjV4WH2YfTNDokfOHA6fPFcl4LPq0JtYr0cC7LQmB2wZhiUo3A6IQL0PAmDHGjxLi9UHF74uRVjFlU7bpRgn3D7FKjSS+UTAwihfE6tAx1EHyAcyTzqB8+z4LIrWwjXmLV13ToXLNDNGurZd6+3vFO1EshSypxV/4Sk8501YDdGC52FJN/KOYZ1j62Ww5U7wz3X6tnn13s8ODJ5XWfQ2MBP5nux5uUcqjmjYruQ2yw9POLyS3DMA9hKiQd2FB1enms5llzVrgqk8fX+evhVFv/tTKgZyVdxrEd0d2ow96eJx0aL64mh/xb+yW0VmOuqu0+mm9kb3i20qUv3xFCqy3W4nwI3TsZBsDg6rpuGt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 15:11, Brendan Jackman wrote:
> Checkpatch complains about this, a later patch will move the code, fix
> it so that checkpatch doesn't complain about that patch. Do it in a
> separate patch so the "move the code" patch is trivial to review using
> Git's diff colouring.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/internal.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 2237eee030cba..8ce59c5664497 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -919,8 +919,8 @@ extern bool free_pages_prepare(struct page *page, unsigned int order);
>  
>  extern int user_min_free_kbytes;
>  
> -struct page *__alloc_frozen_pages_noprof(gfp_t, unsigned int order, int nid,
> -		nodemask_t *);
> +struct page *__alloc_frozen_pages_noprof(gfp_t gfp, unsigned int order, int nid,
> +		nodemask_t *nodemask);
>  #define __alloc_frozen_pages(...) \
>  	alloc_hooks(__alloc_frozen_pages_noprof(__VA_ARGS__))
>  void free_frozen_pages(struct page *page, unsigned int order);
> 


