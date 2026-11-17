Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BABCC606A331
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 06:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lXgRurMK
Received: by kanga.kvack.org (Postfix)
	id DD7546B00EF; Tue, 17 Nov 2026 01:55:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87F66B05B0; Tue, 17 Nov 2026 01:55:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9ED26B05B1; Tue, 17 Nov 2026 01:55:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9E206B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:55:47 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2BD0980390
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:55:47 +0000 (UTC)
X-FDA: 85443700734.11.2657262
Received: from mta0.migadu.com (out-103.mta0.migadu.com [91.218.175.103])
	by imf03.hostedemail.com (Postfix) with ESMTP id BA56720007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:55:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lXgRurMK;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.103 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794898545;
	b=P7OtSJA1IBz+lw8tSlnVnbun/VOkIq110K4FfzSsekAmar7eEAEt8Me0GYhCK0JpJSl86E
	lzKCP95dFjVmjCvFHA1BxRHKtmusC0pnJ0J6G2hLOBwxN3fHTtQM097y05UpERE8KsPJvb
	qfIELIPsNJEgtTY7B4R/Zt0uGr+pgpY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lXgRurMK;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.103 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794898545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2oPYcBnyfKFBVmYGFPt3g8Jq1FN6zDjS6/VkvCawi+A=;
	b=0IBpqxg7yr14VKwezMeHJ6DL447+VWCXuRDZIlL0gfk16JQD4qfj1yvw5Y1Z9DwFF8UdTY
	B3KoL/4Weu8hqfG9tF07v3QGNxe3qBP8fBqorDLTM4fZkrCXT3fDcw71pwn3FS55t0adGB
	nT8RINNdTAIVT3ZizR82v9scbpAczSg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SU0b3f1zTiBLHbxV73c/5LDRiiQt2cN7KkcKdsVywD0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794898543; v=1; x=1795503343;
 b=lXgRurMK73j3nPHPEDrTPBOxyd8BD2/bhOZcU3E6iNtYJ8OIS3qBwRq8/vLYoj/f1d17VABg
 I6O9Um6r8E5j877oq1AFPW558zMJO9Bwyi2jF2lcE1g/H7Oy8y0hmLjPYr1Ew/dHp7SqifEUfes
 pqkfq9BAQZ+vFtjsHFT4EQXs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6d3558f114912485;
	Tue, 17 Nov 2026 06:55:42 +0000
X-Mizu-Trace-ID: 6d3558f114912485
X-Migadu-Flow: FLOW_OUT
Message-ID: <c3906ff3-c5ee-4672-8bab-2318185268c8@linux.dev>
Date: Tue, 17 Nov 2026 14:55:36 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] mm: hugetlb: fix CMA-related issues
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev,
 akpm@linux-foundation.org, osalvador@suse.de, azpijr@gmail.com,
 lance.yang@linux.dev, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1794046188.git.zhengqi.arch@bytedance.com>
 <b1c1c835-180a-49e2-86c0-bc3f65981728@kernel.org>
 <7e733c3b-2aa2-406e-a5ca-cd9a2c872f9f@bytedance.com>
 <bc6ffcff-3aaa-43da-91b4-82f27513c761@linux.dev>
 <1e0aa28d-f81b-411f-92a3-6038c3961443@kernel.org>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <1e0aa28d-f81b-411f-92a3-6038c3961443@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BA56720007
X-Stat-Signature: x9zehz3trq58omj3c4gbfxuputpsz9dx
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794898544-190528
X-HE-Meta: U2FsdGVkX18fDzibh0maiUK2RcsrFaLc+Y8ArY229MiYQQFvLsDuJwy6vqV3g92B/fdNO2gpe9Ab2MsMitFJjlay40uo8yWwCvB5JYfgBzwTIm8YrfNvB+SCQD4KshSca3lC+GP2kQIbf9U1EJtxlGqP2BN/fhh1Zn7Wa7RhISgw0dizCgqblzKQku5dvdda03gPhNcPJLZ3ZpIPxLvyidCwZxtCcWnmpXlr6w3ulmQk1f4QayIChrOVEiSrnJcX0PSCqO3ON9udFcN8siVkdCrm551+/qGhBxex1XPVGLgi8RrfSunKFi2zV9Vo5d0d9rzVCgVvwv/XNM2/vI+SRt7XOa08tlH3E5Zvk9/VfpyLDwwRBnO51gxVAjYireV5bxSiHp2HLxMmzYDzMcUuCkjDXQeXbgqFgkbOLBvfED2c/uNrvNUDXFXhrmScv/0z8607NDzwgwJWYXGIkjlaWhXQ5i6soA1UbPJyNTX6JSqwHhhy/3ibm2bpiav0mheywxW+VGgroHbqPU2hQOj346YWFkfRS1CH2eo5dDusRXT+5+IcBqv2yi/szmSAZMNGB4aphwVJFU/JYFEWQEBtLqn6S6MUNd1Hcg0D7nD+beWj/bzgWLIThXxo8pAKnIJlXyYolEpAvg9kxjc01UCS+PlRFhLQYlG8i/9DN+vuR2Poo1SOvj8Kg4ww2tMY3tcdeqvZqBCaiviH15ugpDQK9daI3KUqvqE9SD2pzjSinQJax3radZEU5PiZjMV1p/1n13/PWCdHJsu3cRpfMOI/OZG4qKxz4Twlh+QGL/sQi8cxbFeUS6HbOkViyH9pGfFgMUo9mwI/FXQhnkNnyjnKpBe2WUZSpanZ7bHmxJ1kULV7FmWgDAtz/p/rItIK2mTiNBxtTJeZRFmaAUPVkfB78jLq2X1owIHw8nZPvNiUc6tDIefTWtQKzXAyeY7dQYYKC20GMHuE/SBJehev9EZ
 ymb/oOP6
 8FU82bB8GJDt+vCNTSHp3eUgwb7S21UySivFbk/zuDxH9Pu64N/IUOLOio22objI0UXvRb6EJGt4TsYQFe/xO26ykE5ARSmtAG0oFzQjpQcVpGFiL3cb5nnEuCV37hFLLTqihB6tu6r7gq3Wj2v+940LAdGOouqbHK0+cIXpE1vrXjoGPFoCwX43AR/27ztwJjhiQdStzPgZdFytXB5iT5XDccjXkFiRVPxVNSWk2RtvieS9bllnMGOfyfmP3pSYfYIJBwme7cTbtIKvcjLbKbdQL1/SWakyEeuoxBNFu5inY86M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi David,

On 11/16/26 8:07 PM, David Hildenbrand (Arm) wrote:
> 
> Hi,
> 
> sorry somehow I missed your mail.
> 
> 
>>>
>>>>
>>>> Likely cma_reserve_early() must be taught to align (and maybe consume an order
>>>> instead of a size), similar to how the dynamic cma allocations work.
>>>
>>> However, simply adding alignment would leave gaps that the
>>> current activation code cannot distinguish from actual reservations.
>>>
>>> The early allocation path would become:
>>>
>>> hugetlb_cma_alloc_bootmem()
>>>      -> cma_reserve_early()
>>>           pfn = ALIGN(cmr->early_pfn, nr_pages);
>>>           cmr->early_pfn = pfn + nr_pages;
>>>           cma->available_count -= nr_pages;
>>>
>>> For a CMA range starting at 4 GiB, reserving 32 MiB followed by 1 GiB
>>> would produce:
>>>
>>> 4 GiB       4 GiB + 32 MiB             5 GiB             6 GiB
>>> | 32 MiB used |------ 992 MiB gap ------| 1 GiB used       |
>>>                                                            ^
>>>                                                        early_pfn
>>>
>>> Later, cma_activate_area() marks the entire prefix below early_pfn as
>>> allocated, including the gap:
>>>
>>> count = early_pfn[r] - cmr->base_pfn;
>>> bitmap_count = cma_bitmap_pages_to_bits(cma, count);
>>> bitmap_set(cmr->bitmap, 0, bitmap_count);
>>>
>>> It only initializes and frees pageblocks after that cursor:
>>>
>>> for (pfn = early_pfn[r]; pfn < cmr->base_pfn + cmr->count;
>>>         pfn += pageblock_nr_pages)
>>> 	init_cma_reserved_pageblock(pfn_to_page(pfn));
>>>
>>> The gap therefore remains reserved and marked allocated. Releasing the
>>> two HugeTLB folios only clears their own ranges through
>>> cma_release_frozen(); neither release covers the gap. Those 992 MiB
>>> would be permanently lost from usable CMA capacity.
>>>
>>> So we would also need to track the gaps, clear their bitmap bits during
>>> activation, and initialize them as free CMA pageblocks.
> 
> Ugh, what a hacky mess people created.
> 
>>>
>>>>
>>>
>>> Another possibility would be to give 32 MiB pages their own pool,
>>> similar to the separate PMD-sized pool proposed in the other series. On
>>> arm64 with 4 KiB base pages, 2 MiB, 32 MiB and 1 GiB allocations would
>>> then use separate pools.
> 
> That would be cleanest. Would it break existing setups?

Yes, this requires an existing user to explicitly configure a 32M memory
pool.

But in practice there shouldn't be such a user today, otherwise the
misalignment issue would have surfaced long ago, wouldn't it?

> 
> 
> Another quick-fix idea could be to always allocate larger folios first.
> 
> That way we should avoid any holes, right>

Ah, this looks feasible. How about the following?

(If that looks good, this could go as a stable-first fix.)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6fba92b0f6749..32e65ce347c90 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4556,6 +4556,22 @@ void __init hugetlb_bootmem_set_nodes(void)
  		node_set(nid, hugetlb_bootmem_nodes);
  }

+/* Return the largest early-CMA hstate below the given order. */
+static struct hstate * __init
+hugetlb_next_early_cma_hstate(unsigned int order)
+{
+	struct hstate *h, *next = NULL;
+
+	for_each_hstate(h) {
+		if (!hugetlb_early_cma(h) || huge_page_order(h) >= order)
+			continue;
+		if (!next || huge_page_order(h) > huge_page_order(next))
+			next = h;
+	}
+
+	return next;
+}
+
  void __init hugetlb_bootmem_alloc(void)
  {
  	struct hstate *h;
@@ -4571,9 +4587,19 @@ void __init hugetlb_bootmem_alloc(void)
  	for_each_hstate(h) {
  		h->next_nid_to_alloc = first_online_node;

-		if (hstate_is_gigantic(h))
+		if (hstate_is_gigantic(h) && !hugetlb_early_cma(h))
  			hugetlb_hstate_alloc_pages(h);
  	}
+
+	/*
+	 * CMA ranges are aligned to the largest supported size. Allocate larger
+	 * sizes first to keep the early reservation cursor aligned without gaps.
+	 */
+	h = hugetlb_next_early_cma_hstate(UINT_MAX);
+	while (h) {
+		hugetlb_hstate_alloc_pages(h);
+		h = hugetlb_next_early_cma_hstate(huge_page_order(h));
+	}
  }

  /*

> 
>>>
>>> This could work during early boot too: hugetlb_cma_reserve() establishes
>>> the CMA areas and their ranges before hugetlb_bootmem_alloc() runs.
>>> Although the bitmaps are allocated later, each range already has its
>>> own early_pfn. With naturally aligned ranges and one allocation size
>>> per pool, the cursors would stay aligned without creating gaps.
>>>
>>> What do you think?
>>
>> Hi David, gentle ping
>>
>> I’d like to update to v5 so that I can continue advancing the support
> 
> Feel free to fix this issue here independently from the current series.

OK. I'll go ahead and post the v5.

> 
>> for 2M hugetlb CMA. Regarding this issue, would you like me to include a
>> fix in v5? If you agree with the "split pool" approach, we can handle it
>> as part of the patch set for 2M hugetlb CMA support.
> 
> 
> I think we want a stable-first fix for that.

Got it.

Thanks,
Qi

> 
> 


