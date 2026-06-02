Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01FE7CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 17:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 660F66B0088; Tue,  2 Jun 2026 13:22:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611A06B008A; Tue,  2 Jun 2026 13:22:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500ED6B008C; Tue,  2 Jun 2026 13:22:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6CD6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:22:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E7D541A08AA
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:22:41 +0000 (UTC)
X-FDA: 84835642122.09.DC632FE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7827814000D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:22:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gTtnjxuy;
	spf=pass (imf26.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780420959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fxVSpoXcqWMDSv7EE6VMZFwvrzt1MkGFJIAnUJakhK8=;
	b=zeolTWGggvqvURJKJdAMTwrJzQarcmsOkd7TCnV8pTlZhqTc0d5zJxDtBunvAzGVbABrRm
	56ttnQFuyr+3VIeP2iiX7aqT/1LxYLhgQ5ysqxSPymbKIgydsVGMDzwH9WfS7UwNlIzEXW
	lsx+Jdv0TASSnp1c4COI1N+8vtX3Wlk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gTtnjxuy;
	spf=pass (imf26.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780420959;
	b=vf/9twQE/wNTruhx7R/687G8m0RgUIQAxpQ9xu+HBQOKJH2K2hI4QWF5uShqezB/teRK61
	vutQBgR/HD2AXlCyl7b5e2nSfQAmv/ISnVRy/vHz0q3aCX42WBO4WqWZZTfCE7+Id4CKPG
	APAw6ysb4iiozz/YlYUlELygcn4oj10=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780420958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fxVSpoXcqWMDSv7EE6VMZFwvrzt1MkGFJIAnUJakhK8=;
	b=gTtnjxuy1CI8mMuo1r/f6kbaXVgPgQZyOfekLa18Ky1k37CE+z2ZWEwDL7h25gRUkPMmo1
	XIO2O0ouNbMCori8fFqFz+fLZ8I/MAQn+CV56+2S1iFMuIspurDh9u50ABzSIA6ROuUtUO
	fehFjjRRTWpdWxeMnDsRoXk36Ud/KOk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-368-KMk7tOgGMFODYqyR_B4rOw-1; Tue, 02 Jun 2026 13:22:36 -0400
X-MC-Unique: KMk7tOgGMFODYqyR_B4rOw-1
X-Mimecast-MFC-AGG-ID: KMk7tOgGMFODYqyR_B4rOw_1780420955
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4909ea0ffbeso37656425e9.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 10:22:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780420955; x=1781025755;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fxVSpoXcqWMDSv7EE6VMZFwvrzt1MkGFJIAnUJakhK8=;
        b=cFceO8XHicp8N5R6K0AUhoXdwnky7aY9rvtN6T3XDwWYTjApg11AnGaVTS/UTPVjAz
         NlhVoQ+mSTOlR5HfHkxp5yZY5VmSLq0o36PK12ptSp856l7o1Dhjv+HDWs6tx9ohU2yo
         7rkyoPhyMlln+vyF8fOnp0bmICxei0lEWWAQvy7XwM2PvJzHVNtgguyp07Xlmh/WDmgR
         Yl8At/x2wlNrXZrQt0uBndLSif8dssGgX+yXT4ul5UE4xmS/QIpeXmkUtXR8mvNUJqOk
         D5smD0EyX1FLUmmPzVW7DSVXYpE4gAm5KEGIFK2pTtjwLqXyU3JDdbsSRkaxWXTGGDfs
         0Hjw==
X-Forwarded-Encrypted: i=1; AFNElJ94zOLby41IXqTl5yqT+Cr8xRzpoWnMWbqq68LROtaewySFs4M+RIrXY1YvMzFzGjT913eViYxWfg==@kvack.org
X-Gm-Message-State: AOJu0YyTX6EK2CXWM6Dd9WqLuMwZ/WrL3dXt9G28UJYo5HarNCYbvnif
	AZU2Uv2fFJGhuWOSh8AfA1l7n66bhwzkiMsVJ8rlHzo9AqW0KS09aPtoTQjmiuI16Ts3Tkga5zo
	OVqDb9QQo2onDk4bmf2aasWw3cWIwum4sxKu6wv4wPGpfkwSxkhyr
X-Gm-Gg: Acq92OE2ANkwL3bnv4iRIKZgQkeD9Rlt40Tv1/4f+VeSlnSxhb9WujQTEyKwmHam6DQ
	82maqt/taOCtlszixcX7Tz9hTo+MF7C2mBH6k17cV1xt5xFwBvzrm4THM1BLhLgXTRDdrHcpgXa
	X0Hn6a5+RuO0JLAelgLevov4E948sS8ZsqZ5Mdx3NEr5Sra/7zi608lAiiz+joYmGNop6rBDBRQ
	Zafhvcvhwb01bLw/UalrOCeaduluPVwheVpMLH7Qoz/zEXX+TIw8cdEmdxQVdVU7cUF9BeZhO81
	su77V8kUUithJiIwLgENP/blQPQzpP1Qctqk+5I0CwAHY2Swzm17oKryAauz2daM33NV3MUYYd+
	cTh+qE+eYhJA+fC1re2dSpyQ2pkvEzd0ijCzhHx1IeYkgL6bExFf0P/ZpR7XncA==
X-Received: by 2002:a05:600c:8518:b0:490:b1bb:cdc6 with SMTP id 5b1f17b1804b1-490b503f584mr11183865e9.5.1780420955133;
        Tue, 02 Jun 2026 10:22:35 -0700 (PDT)
X-Received: by 2002:a05:600c:8518:b0:490:b1bb:cdc6 with SMTP id 5b1f17b1804b1-490b503f584mr11183195e9.5.1780420954698;
        Tue, 02 Jun 2026 10:22:34 -0700 (PDT)
Received: from [192.168.1.144] (88-149-243-171.dyn.eolo.it. [88.149.243.171])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490b0da5ae2sm75001205e9.0.2026.06.02.10.22.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2026 10:22:33 -0700 (PDT)
Message-ID: <19639b08-5bf1-4974-9635-c458d512fa38@redhat.com>
Date: Tue, 2 Jun 2026 11:23:35 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, vbabka@suse.cz, vishal.moola@gmail.com,
 wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org,
 yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com,
 zokeefe@google.com, Usama Arif <usama.arif@linux.dev>, usamaarif642@gmail.com
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-12-npache@redhat.com>
 <b8380eb3-096a-49f1-9ace-99c1e75888b4@kernel.org>
 <CAA1CXcBg1su-bk3i_H+TW4-nTgvGSGqRNeC9MpQo7sGeH8ejnA@mail.gmail.com>
 <d3c2b00c-6810-434a-b837-0707b0a11611@kernel.org>
From: Nico Pache <npache@redhat.com>
In-Reply-To: <d3c2b00c-6810-434a-b837-0707b0a11611@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 32HeFvEXjwtHwzQ_vXxeX7W2JOwKZFRjoUjopkBstms_1780420955
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7827814000D
X-Stat-Signature: saukfxmwu3s9fagdwx78xzwy6xbgjn6k
X-Rspam-User: 
X-HE-Tag: 1780420959-393447
X-HE-Meta: U2FsdGVkX1+F6U4KIzLohrcdSO0rLBIj0EblK1If8KsmU0EXiCZ3pT68rgPRU22R/Yk251cGp8PE5Ea4g9bf2A4SG9Wg7A47GBu41lifY53lX23ANj/zSE1mIxe4dQ6SKfnsduj9wIrSjfuDwDe0elnJH1svmFPzSl+8BcVUbtDszkD00yYHaNFw2IJOYv5/MNl03V84G16mnT/DT1G9EnCmi+eR+0cpGZqKBSKD5IX+9PUnyaq2maXOkJAC0fbbbFBCpEFPEhpLpyhaiys9vJBiVIlIpq3fYgwpPaR6IzmBeZKv/aE3kBNdjmpZHA07i3XCJjmSbciop1q4oJfZG6CTeL8VpSnIPsTwPFKNUDyyNIxbzKrIahfmzBfvTABqjJoDlAqBROAg/GEG9gNsebsYll5hb7oaC1wqRe4Sl86G/BbsfFi48t49n+hmAbWNpVn8ObhtugX+Yjl0QJw2XJc7xZ5xW/386jTqkKNBtf++n/9iYfFcdn0/eMIuzOVfWJwdcNyriz63T70V5ZvPgb/nF2kMIogTsH4rIjJLCQHHN5W5OM2MhwKIvw4U/S6JdlXwlaBltjMWeXrpYXzU7AiHW2liUWhuFVWleLq+7PMRgzOuzGbTyQh8FDBny6Aegiey3dfvJoanekRO4pjaZCscvm3h0J5IRzWyd1Y7OTiIQleHBO6d25hy//vDb6Hlq2jZJxibnhwMIO+KhSmrnEsUtGa2yRJr3wOobJKOrUd7KR4p9rccDjpd3vHQLgglx0aNs/vVj6N+AmYyS20FNW0fdEhdYdpNY5usFi5sdGxXvfPFgvInOc1vJbbwfPWszm/DEG00Hk9m87VG90nMv44kagvrSl1mXnkN1qqpwNzhrSPUKsQail1ya4NQKUDlyX0FAY+PEg6gSm3IhVNAjmm6yXwQsLyq04cvEZKU28bUIdxy9UjERYgeoNw9uHgX70xSFK32JLLIU//gd8i
 apaW3lAt
 IAQJ0JLSwWU1FRtzrM2+I6hJQgxLDDViv2RidbhBlFDYQvAMJ6Jf3zGDiOgAXlnR2lRzDZawoYNE2ZC9iFxmxIud/8KgyyLBlZSoOHDAZYnRfwLDX+KttHBH0oWF93XT8DTB91QFmndIlk9lVwJnLOegGZd955Wk9mYqU1coV5Zs8xw3enqawBuIiKgrb54tbDKKB7LVkbKdaSLApZiZgFOmD8NHiLN/NcNAllaVnz3C0a2QhWwTb1kpUMQfn2zYrxJElthRkC/QdP4rd/wdMqNHPQFHXBYWxw+zevgWZPcN1EaqjQyQgG9moAy0JV5RFtPHJutMVxAIxBKjUbgyvm5AJAbe70+ozWPfBrRPIsJhjeAcvGSqXRhUD2Go+uer1dy3eRjSvftAtiq01vMbSCOEgmE2th3hqMRKVeJwKcl69C0HF0covi9GsA+096u7zeQijTCsALxFc4qEJDlkEE0FK55GNy7+C9rsYqhnG7SMhQWS6/HDsN3ME3hB9oK+X5tt6D19c6++ZgLP3cf/dtcZLWMtUfetEnj3ktAtZT3kwas7qKubUhdabcFN5NGqxs66kRKjf0H5Ygu0zNBzdo1C8lV6yOMQtBIbI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/1/26 7:15 AM, David Hildenbrand (Arm) wrote:
>>>
>>> Reading this, it is unclear why exactly do we need the stack.
>>
>> So I looked into your items below. It seems logical, and I think it
>> works the same way; however, your method seems slightly harder to
>> understand due to all the edge cases and more error-prone to future
>> changes (the stack holds implicit knowledge of the offset/order that
>> must now be tracked in the edge cases).
>>
>> Given the stack is 24 bytes, I'm not sure if the extra complexity is
>> worth saving that small amount of memory. Although we would also be
>> getting rid of (3?) functions, so both approaches have pros and cons.
> 
> I consider a simple forward loop over the offset ... less complexity compared to
> a stack structure :)
> 
>>
>> I will implement a patch comparing your solution against mine and send
>> it here, then we can decide which approach is better.
> 
> Right, throw it over the fence and I'll see how to improve it further.

Ok heres what the diff looks like on top of my V19. 

you can access the tree here https://gitlab.com/npache/linux/-/commits/mthp-v19?ref_type=heads for easier review.

So far I have no problem with this approach it appeared cleaner than i thought. Did some light testing. Gonna throw it more through the ringer tomorrow. 


From 9496c5d17eba7f6d04820d78c7c6f1592a58888a Mon Sep 17 00:00:00 2001
From: Nico Pache <npache@redhat.com>
Date: Tue, 2 Jun 2026 10:26:18 -0600
Subject: [PATCH] convert from stack to forward loop

Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 96 ++++++++-----------------------------------------
 1 file changed, 15 insertions(+), 81 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 498eba009751..6de935e76ceb 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -100,28 +100,6 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
 #define KHUGEPAGED_MIN_MTHP_ORDER	2
-/*
- * mthp_collapse() does an iterative DFS over a binary tree, from
- * HPAGE_PMD_ORDER down to KHUGEPAGED_MIN_MTHP_ORDER. The max stack
- * size needed for a DFS on a binary tree is height + 1, where
- * height = HPAGE_PMD_ORDER - KHUGEPAGED_MIN_MTHP_ORDER.
- *
- * ilog2 is used in place of HPAGE_PMD_ORDER because some architectures
- * (e.g. ppc64le) do not define HPAGE_PMD_ORDER until after build time.
- */
-#define MTHP_STACK_SIZE	(ilog2(MAX_PTRS_PER_PTE) - KHUGEPAGED_MIN_MTHP_ORDER + 1)
-
-/*
- * Defines a range of PTE entries in a PTE page table which are being
- * considered for mTHP collapse.
- *
- * @offset: the offset of the first PTE entry in a PMD range.
- * @order: the order of the PTE entries being considered for collapse.
- */
-struct mthp_range {
-	u16 offset;
-	u8 order;
-};
 
 struct collapse_control {
 	bool is_khugepaged;
@@ -137,7 +115,6 @@ struct collapse_control {
 
 	/* Each bit represents a single occupied (!none/zero) page. */
 	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
-	struct mthp_range mthp_bitmap_stack[MTHP_STACK_SIZE];
 };
 
 /**
@@ -1458,50 +1435,14 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
 	return result;
 }
 
-static void collapse_mthp_stack_push(struct collapse_control *cc, int *stack_size,
-				     u16 offset, u8 order)
-{
-	const int size = *stack_size;
-	struct mthp_range *stack = &cc->mthp_bitmap_stack[size];
-
-	VM_WARN_ON_ONCE(size >= MTHP_STACK_SIZE);
-	stack->order = order;
-	stack->offset = offset;
-	(*stack_size)++;
-}
-
-static struct mthp_range collapse_mthp_stack_pop(struct collapse_control *cc,
-						 int *stack_size)
-{
-	const int size = *stack_size;
-
-	VM_WARN_ON_ONCE(size <= 0);
-	(*stack_size)--;
-	return cc->mthp_bitmap_stack[size - 1];
-}
-
 /*
  * mthp_collapse() consumes the bitmap that is generated during
  * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
  *
  * Each bit in cc->mthp_present_ptes represents a single occupied (!none/zero)
- * page. A stack structure cc->mthp_bitmap_stack is used to check different
- * regions of the bitmap for collapse eligibility. The stack maintains a pair
- * of variables (offset, order), indicating the number of PTEs from the start
- * of the PMD, and the order of the potential collapse candidate respectively.
- * We start at the PMD order and check if it is eligible for collapse; if not,
- * we add two entries to the stack at a lower order to represent the left and
- * right halves of the PTE page table we are examining.
- *
- *                         offset       mid_offset
- *                         |         |
- *                         |         |
- *                         v         v
- *      --------------------------------------
- *      |       cc->mthp_present_ptes         |
- *      --------------------------------------
- *                         <-------><------->
- *                          order-1  order-1
+ * page. We start at the PMD order and check if it is eligible for collapse;
+ * if not, we check the left and right halves of the PTE page table we are
+ * examining at a lower order.
  *
  * For each of these, we determine how many PTE entries are occupied in the
  * range of PTE entries we propose to collapse, then we compare this to a
@@ -1517,26 +1458,20 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 {
 	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
 	enum scan_result last_result = SCAN_FAIL;
-	int collapsed = 0, stack_size = 0;
+	int collapsed = 0;
 	bool alloc_failed = false;
 	unsigned long collapse_address;
-	struct mthp_range range;
-	u16 offset;
-	u8 order;
+	unsigned int offset = 0;
+	unsigned int order = HPAGE_PMD_ORDER;
 
-	collapse_mthp_stack_push(cc, &stack_size, 0, HPAGE_PMD_ORDER);
 
-	while (stack_size) {
-		range = collapse_mthp_stack_pop(cc, &stack_size);
-		order = range.order;
-		offset = range.offset;
+	while (offset < HPAGE_PMD_NR) {
 		nr_ptes = 1UL << order;
 
 		if (!test_bit(order, &enabled_orders))
 			goto next_order;
 
 		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
-
 		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
 						      offset + nr_ptes);
 
@@ -1553,7 +1488,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 				collapsed += nr_ptes;
 				fallthrough;
 			case SCAN_PTE_MAPPED_HUGEPAGE:
-				continue;
+				goto next_offset;
 			/* Cases where lower orders might still succeed */
 			case SCAN_ALLOC_HUGE_PAGE_FAIL:
 				alloc_failed = true;
@@ -1581,15 +1516,14 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
 		}
 
 next_order:
-		if ((BIT(order) - 1) & enabled_orders) {
-			const u8 next_order = order - 1;
-			const u16 mid_offset = offset + (nr_ptes / 2);
-
-			collapse_mthp_stack_push(cc, &stack_size, mid_offset,
-						 next_order);
-			collapse_mthp_stack_push(cc, &stack_size, offset,
-						 next_order);
+		if (order > KHUGEPAGED_MIN_MTHP_ORDER &&
+			(BIT(order) - 1) & enabled_orders) {
+			order = order - 1;
+			continue;
 		}
+next_offset:
+		offset += nr_ptes;
+		order = min_t(int, __ffs(offset), HPAGE_PMD_ORDER);
 	}
 done:
 	if (collapsed)
-- 
2.54.0



> 
> [...]
> 
>>>> +     bitmap_zero(cc->mthp_bitmap, MAX_PTRS_PER_PTE);
>>>>       memset(cc->node_load, 0, sizeof(cc->node_load));
>>>>       nodes_clear(cc->alloc_nmask);
>>>> +
>>>> +     enabled_orders = collapse_allowable_orders(vma, vma->vm_flags, tva_flags);
>>>> +
>>>> +     /*
>>>> +      * If PMD is the only enabled order, enforce max_ptes_none, otherwise
>>>> +      * scan all pages to populate the bitmap for mTHP collapse.
>>>> +      */
>>>
>>> You should note here, that we re-verify in mthp_collapse().
>>>
>>> But the question is, whether we should relocate the check completely into
>>> mthp_collapse(), instead of conditionally duplicating it.
>>>
>>> What speaks against always populating the bitmap and making the decision in
>>> mthp_collapse()?
>>>
>>> Sure, we might scan a page table a bit longer, but the code gets clearer ... and
>>> I am not sure if scanning some more page table entries is really that critical here.
>>
>> Someone asked me to preserve the legacy behavior (PMD only). Although
>> rather trivial, if you set max_ptes_none=0 for example, we'd still
>> have to do 511 iterations for no reason if PMD collapse is the only
>> enabled order rather than bailing immediately.
>>
>> I'm ok with dropping it, but I think its the correct approach (despite
>> the extra complexity). @Usama Arif brought up this point here
>> https://lore.kernel.org/all/f8f7bb71-ca31-46ee-a62d-7ddfd83e0ead@gmail.com/
> 
> We talk about regressions, but I am not sure if we care about scanning speed
> within a page table that much?
> 
> After all, we locked it and already read some entries.
> 
> Having the same check at two places to optimize for PMD order might right now
> feel like a good optimization, but likely an irrelevant one in a near future?
> 
> Anyhow, won't push back, as long as we document why we are special casing things
> here.
> 


