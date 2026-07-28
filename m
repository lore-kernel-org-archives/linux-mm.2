Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CE8AC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 08:33:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF4C06B007B; Tue, 28 Jul 2026 04:33:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7E876B0088; Tue, 28 Jul 2026 04:33:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946BE6B008A; Tue, 28 Jul 2026 04:33:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E73D6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:33:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 838BEA13CF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:33:52 +0000 (UTC)
X-FDA: 85037522304.29.441C154
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf10.hostedemail.com (Postfix) with ESMTP id D373BC0009
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:33:49 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HsT3ezX3;
	spf=pass (imf10.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785227630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X1OAr0wARt/pkmfsKUtroNqFk1WpnC6NGf/q2G4G+OE=;
	b=n+/MFzn4VE9y5Mo6uAZYlzj+87ECFaTbbrzyAOZ4kpQ2VTMJdxmTz47ag0uGWYxFQvZRul
	ZnlPHzucyC+GfKI3fmkU5CawUuSAnUqYytQOCI4DbfoZbF5+skq5k2qV3LeVfQ8etA5Z+H
	2p9+Bjc49cO3BOIdfNlca2SVeTDeqlM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785227630;
	b=MZpU/mi5max0JCCrQ89BFdhVNMHp4pXs6yWNHo0z7TSrCFYKLUTID1qxL+BLvPHRl6xcr8
	Lm+aSDbAWbVjJ44qs2XxuG9QyUb3npYiDrLGHpr4ig3ijyQ9l0xCYnzqndfCNyqqHfrlNs
	T0w8PnV6dbksLONC4WFPSXQ/ccfvz+8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HsT3ezX3;
	spf=pass (imf10.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <24b9f213-96e8-4eda-a20f-8746d7c399b7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785227627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X1OAr0wARt/pkmfsKUtroNqFk1WpnC6NGf/q2G4G+OE=;
	b=HsT3ezX3XlyvCAN/4AtbXu4YWl0QPD5oKLSCL22Zygw504c16hhj4wnT4pDRT0ekqOEwhw
	qtXjJccfgaKB+ZP7qWAm5SjWBM2ha/BpR2rzULKwxJ4wJ4EOu/PjuDI4aueK6I2QeyWSzQ
	ySBOtRPBuap+gsK7uc9gZFWBIu9Abpg=
Date: Tue, 28 Jul 2026 16:33:31 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/4] mm/vmscan: fix swappiness=max and clean up
 per-node proactive reclaim
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Zhongkun He <hezhongkun.hzk@bytedance.com>,
 Muchun Song <muchun.song@linux.dev>, Davidlohr Bueso <dave@stgolabs.net>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260723045718.2052070-1-ridong.chen@linux.dev>
 <20260723171842.137e45eb36b21b3b45245da0@linux-foundation.org>
 <8336e48a-ab3a-4db9-a7f9-5bb6af2b22c3@linux.dev>
 <CAGsJ_4xPw24afGLZH6Qh5rxOts37SCpmBVeB3gGntk1QQuSCow@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4xPw24afGLZH6Qh5rxOts37SCpmBVeB3gGntk1QQuSCow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D373BC0009
X-Stat-Signature: keya8gr4d3wk834uogxetjbk58nw78ee
X-Rspam-User: 
X-HE-Tag: 1785227629-369226
X-HE-Meta: U2FsdGVkX1+WCl/Y0KVTJlyZQ3xKQu+ZTTufeo41OU7VscU0MijhUCNgLiJizeYgM+PruxRNYl7Ayusd8PWJh4A5xijqu/sfOuokIR4oRYi0SPTSzC4Au3Fp04Eq450vHNB1IkAf4qHNWTyRCd1Xf/oP+45oPN6zB7fjXP65LpfhC05LSZ4sKNP+3GKrCOisUUy4WJFA3KszYNwdyvD2I86BTP/O+l9ZOau2EQZ2OpYEwXMUvz54IxG0Wts102meQZDLe404eEPmPQJVJGEUnxlBtViJ/pThh/zl5yhZMXDdh2y7ljfEXN3aBq5saLB1QA7elCatL7ODkNqMF1+qzIie0VhsUsW8+BnSUdn23CATr0499xkoQofD8D68dxcNM3/WZZ2Al43PTVFtkk9fIEuuZ0Dm5Typ1TsE/tSVij5mQAoZUi962PPLxBcy/ZyskhJ6+VTIvZhmr9gqzz//s6USg3Gr0MSvxIVPB+ryG0Dbsv8f0ylhEYgZBBU3xEDlceNHkT/lBfhMOVzwwvSe8V49ARdCmtUiTT3wxh64X9uRhKve03XiFl+KOZw296VMGbiKh6zTbMTLg5J0KRavr4xfD13r9onAv8e25W5OF8ZP6u9SGn4ZCt65gE/+nY+ZZKKvrkTtNFOzQbF+PS/M7CMsAXszmfNOUVqy0iZQuT8dXXFZGfDlAy/TeWwAIKmCa5/udemOqAeKIIECGXD3sn9HSdQS4SLOx3jwmrPXghP43OPteY8571iP75+7nc2YEFUk1V9rut+7mIGjdtgQh4AciEUGDNNvxAaBR9A4cw1ONAoAhAvDAcME4Xw30jlNh04DOEu/IP6zvdDeBSBWtxS4VBEy9Aj27Y04xJwhWqRwMq99fQ8w01+hmpp5jm6L0MbAmNh4PpZhhYakTnRVaGX0T2v6I7uotvjc+4lff+r5oeJ1RbjADr5AroG/50hWxzCD4uJicZ/21P8A7Ro
 h1ZHX0k5
 LiqTDuxxjFV1aGWdMEcna4vxPlgpktgp53ZR/LejcMVJMjRCDaIDPflZTWbG0Ep6wMSvbQ1ssoDpPcROyGQxBwJzoaIoxVBitW1cnGkxV8DfQVwuOYco6TJPjDtkraUsh1q4Sy9XpambXJqeoYEIl+jc3IlRL1INTw/sipNOYn1+i/8AUMAnt9tO9pb90H7BqaPY5yZ7v/5B6wJ8kGTnetRdclCz9K670rTW8KXOWqBhA73qoL89fqPR6xn6lAyLKDOd7keMgQPry4tRrD0GsadGWkF3xNI36eXakdGCjbHoeRFQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/24/2026 7:12 PM, Barry Song wrote:
> On Fri, Jul 24, 2026 at 10:43 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>>
>>
>> On 7/24/2026 8:18 AM, Andrew Morton wrote:
>>> On Thu, 23 Jul 2026 12:57:14 +0800 Ridong <ridong.chen@linux.dev> wrote:
>>>
>>>> Fixes and one cleanup.
>>>>
>>>> Patch 1 fixes "swappiness=max": the anon-only test in get_scan_count()
>>>> sat after the "cannot reclaim anon" check, so when no anon was
>>>> reclaimable the request fell back to SCAN_FILE and evicted page cache
>>>> instead.
>>>>
>>>> Patch 2 fixes reclaim_store() collapsing every error into -EAGAIN, so
>>>> callers can no longer tell an invalid argument from a busy interface;
>>>> propagate the real error code, matching the memcg path.
>>>>
>>>> Patch 3 drops the now-unused gfp_mask parameter from __node_reclaim().
>>>>
>>>> Patch 4 fixes the same "swappiness=max" issue for MGLRU.
>>>
>>> Thanks.  AI review might have found several pre-existing issues which
>>> might interest the maintainers.  Also a suggestion against your [4/4]:
>>>
>>>        https://sashiko.dev/#/patchset/20260723045718.2052070-1-ridong.chen@linux.dev
>>
>> Hi all, sashiko review:
>>
>>     This is a pre-existing issue, but I noticed that per-node proactive reclaim
>>     fails to reclaim memory if the node's unmapped file or slab pages are below
>>     minimum thresholds, completely ignoring anonymous memory.
>>     In mm/vmscan.c:__node_reclaim():
>>          if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
>>              node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) >
>> pgdat->min_slab_pages) {
>>     Does this condition incorrectly block proactive reclaim of anonymous memory
>>     by applying legacy zone-reclaim thresholds?
>>     It seems to bypass shrink_node() entirely if file/slab pages are low, even
>>     when sc->proactive is set, which could falsely return -EAGAIN to userspace
>>     for anon-heavy workloads.
>>
>> Should we add:
>>
>> if (sc->proactive ||
>>       node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
>>       node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {
> 

Hi Barry, sorry for the late reply.

> Nop.
> I assume reclaiming file cache and slab becomes problematic when their
> amounts are already very limited, so we should still honor these two
> checks.
> 
> Maybe we could relax them only when swappiness == 201
> (SWAPPINESS_ANON_ONLY)?
> 
> BTW, for global proactive reclaim, when setting swappiness to 201, does
> it prevent slab shrinking? If not, it seems problematic when
> node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <
> pgdat->min_slab_pages.
> 

in __node_reclaim, we will shrink the node when 
node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages, even if 
node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <= pgdat->min_slab_pages. 
This means slab shrinking can still occur even when below the limit (since 
shrink_slab is called unconditionally after shrink_lruvec). This is not an issue 
only for global proactive reclaim.


> Your recent patchset prevents all file reclamation when swappiness is
> set to 201, so we only need to check whether there could be a slab issue
> before allowing shrink_node() to continue in this case.
> 

So can we add just like?

if ((sc->proactive && node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > 
pgdat->min_slab_pages) ||
	node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
	node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {

-- 
Best regards
Ridong


