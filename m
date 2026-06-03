Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F098CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 04:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7737D6B0088; Wed,  3 Jun 2026 00:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7242B6B008A; Wed,  3 Jun 2026 00:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 612BA6B008C; Wed,  3 Jun 2026 00:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 50ECD6B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 00:44:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5F93A021D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:44:51 +0000 (UTC)
X-FDA: 84837361182.14.A5AC47D
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id 131C714000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:44:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H7XQaTxB;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780461890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xj0nD0QD/WNmMfrUXCn9Q5TSzWLvSSnzm5MnjEnC8kQ=;
	b=LqE7d2f7yT13cYGZWpHeUtwxXrL9Mf7DwMeARpbjMO64ZY9odEw2nafcMD+jkV0c/1v1Vl
	jEX8OZ5cwwNlDEVmlGXBBwbhGm56SNC/T66PeEXTIMOFceTq//gJp62vAsfV6RvYOrI7Jr
	Gkgpjv9Z0LLySNIn6k/xOg0vUR+j/zc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H7XQaTxB;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780461890;
	b=4xiiB/LwPaN8r3IoUhkalA3Z7/0MckRXOmE+sHdyoXcQ1nVtTdd+ujkDKpsx+I1vb+G3HP
	M3QJSqFoS6+/sWNqNgrgEekdW96B1U8KAbAkhNJFKcanggZgPfdtwpOHP4iqqKUd3GD2UU
	kdJ24Nwk7nHlrMvvr5NpOl6hVnb4g/E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780461886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xj0nD0QD/WNmMfrUXCn9Q5TSzWLvSSnzm5MnjEnC8kQ=;
	b=H7XQaTxB33HBNwRGqtmsRiVQBxgVHF/d9blO8P3L26M95U+NwvCotTQfsN7Tz+YglGBoLI
	kyBaTd4fgoO0wu/LWpkH0Bm5GswE6Yt8fHPDFaSxexO0DfwmxH8WaXqtR1mpPWw9xExSGx
	yJ7IEzomxULbP0YlFDQ5qfIaAnLAtco=
From: Lance Yang <lance.yang@linux.dev>
To: hannes@cmpxchg.org
Cc: lance.yang@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	qi.zheng@linux.dev,
	yosry.ahmed@linux.dev,
	ziy@nvidia.com,
	liam@infradead.org,
	usama.arif@linux.dev,
	kas@kernel.org,
	vbabka@kernel.org,
	ryncsn@gmail.com,
	zaslonko@linux.ibm.com,
	gor@linux.ibm.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/9] mm: switch THP shrinker to list_lru
Date: Wed,  3 Jun 2026 12:44:26 +0800
Message-Id: <20260603044426.54863-1-lance.yang@linux.dev>
In-Reply-To: <ah9PGv12mqai84ES@cmpxchg.org>
References: <ah9PGv12mqai84ES@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 131C714000A
X-Stat-Signature: hpom8fy5poka8zswmam5feny4jgx9anj
X-Rspam-User: 
X-HE-Tag: 1780461889-339611
X-HE-Meta: U2FsdGVkX1/g/JpdV3kTiBUP32ePIcdE0Qxo/GZdLss6H7XDwoPesciYqSuLGgRk4lIfq8OwVS1MOomHFBozqCIuVy8euD3Tn3eO0tEwyztzWS2kkVcGjM4s5YyrBxO0r25cpJIx8toXyS6O+6HXLvJp8nHR5db1Uw5o3XP8Ggd2wJ3yR4EAJzLQm0mzMYn5Za3KPupYeqAUSQl2sVNeuKRfJBz7ilp7G8Gz+DkONClJgtsucv3+30JdjCXt4KEIssK6wrAFtqUPdiATHpZOq/8XHw6P5RCAHUesXnLKNZriDyr0FbmW+FZ5NXKdxOsterDvSmeCDHfOuJCNUuDgl+msP0wPLlz6j5Nr/C4OUXjSLENVfefyanZexvGsLgm0x1QCYfN9/aXJcabE4cVUumMgUXhmqZ2Lc1zKVH+aIRN6Fcw0ym8u9OtigmLQSldAOrZH1uwaovmqmVy0RXN6D8ykZOyESvv2W/2sD3i9ZR1hkXZ1CGqmVfvgBEwN4jCR2Xh5Effldw0GxdKt5qI2Vwx9J8hvgkDPSleMyiI2kujKSEE+xMbCkmWrPRHiF8BqtLHN000FQNkX/1NsIeBxBJsbOhOp7ve4cNCtxKH9/sAmPw4LqVt8UZo0sDQVkUTv1cOp9r83/Vv4qro+Oic6DBYI6QWZ/YAkZUd7GmSeLMQ5q0EppHdTx1noYbxYXrtE8Nbm9zDtgeixSAU1myysIA3jsKHqCflqaize+xPM/MwFdvTpk+aCc8aU6+Se+WFJqZvvR+wls6Sln42Pt/ycIyyxU8xAqRQay6egzTlEk4DNLaosxqZpNv2J8T1cxOGzkma789pje0FxrsmE8+iGeXvLZNjkndyWiICzXnAT7fDfWPr0zvk6L5gE2kRbHo3NoNiNJNWDpxfK00AlJjJ9SZka5M5yIfC2GDF9L+WCQr1d6S49nnSMqUQrPdsasrmNN4nLeFpRNrcA4K7e9qy
 eOOESLgG
 LPSV5VWcIPKC/uWt2vfkbrMQSAkC7zZH8vDBqGtuyEWIypZJTtR0emw5JxzTRT3N65l9RY2xesGXySUvfoJLp2rczQpWDsgIuRZM6XXrr7jdYV+hDL5FzKzHgwWM9dhSMKo7rkkRIkVmBIvy5RnK6TwFX5n7rbHrnG66Wpos2/K9h+c/Ktx8a2LloW9phJplheq81gYE4IWJqDJe/UHQdRiKRkJ/wA3MDxSKrt+WyIsXqA/MUysPI3XakHfyzPTKsR+HmV/b5GnHK/C5o1Uqtnndv9k6jwmnFW9zEP5MlX054UeWqqPvGXhHLMx/dQzvSVATj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jun 02, 2026 at 05:46:02PM -0400, Johannes Weiner wrote:
>On Mon, Jun 01, 2026 at 04:36:52PM +0800, Lance Yang wrote:
>> As the changelog above says, the old queue is per-memcg only, rather
>> than per-memcg-per-node. So reclaim on one node can still walk the whole
>> memcg queue and split underused THPs from other nodes in the same memcg.
>> 
>> But I think the new one can lose reclaim in the cgroup.memory=nokmem
>> case ...
>> 
>> With nokmem, the deferred shrinker can still run from memcg reclaim,
>> because it is SHRINKER_NONSLAB. But the list_lru is no longer per-memcg:
>> 
>> __list_lru_init() clears memcg_aware,
>> 
>> 	if (mem_cgroup_kmem_disabled())
>> 		memcg_aware = false;
>> 
>> so list_lru_from_memcg_idx() falls back to the shared node list:
>> 
>> static inline struct list_lru_one *
>> list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
>> {
>> 	if (list_lru_memcg_aware(lru) && idx >= 0) {
>> [...]
>> 	}
>> 	return &lru->node[nid].lru;
>> }
>> 
>> That makes the shrinker bit unreliable. __list_lru_add() still sets the
>> bit on the memcg passed in, but only when the list goes from empty to
>> non-empty:
>> 
>> bool __list_lru_add(struct list_lru *lru, struct list_lru_one *l,
>> 		    struct list_head *item, int nid,
>> 		    struct mem_cgroup *memcg)
>> {
>> 	if (list_empty(item)) {
>> [...]
>> 		if (!l->nr_items++)
>> 			set_shrinker_bit(memcg, nid, lru_shrinker_id(lru));
>> [...]
>> 		return true;
>> 	}
>> 	return false;
>> }
>> 
>> If memcg A adds the first folio, A gets the bit. If memcg B later adds a
>> folio to the same shared list, B does not get a bit, because the list
>> was already non-empty.
>> 
>> So in the A-first/B-later case, reclaim from B may not call the deferred
>> shrinker at all. The shared list is scanned from memcg reclaim only if
>> reclaim runs from the memcg that has the bit, such as A here, or from
>> global reclaim :)
>> 
>> Anyway, only after the shared list is emptied does the next memcg to add
>> a folio get to be the one with the bit, IIUC :)
>
>Sorry for the delay, this took me a bit to think about. The shrinker
>code is a mess.
>
>I read it the same way you do. And this is true for all list_lru users
>when nokmem is set: we just set random nonsense shrinker bits.
>
>HOWEVER, the generic shrinker code fixes that up by IGNORING random
>shrinker bits like this when !memcg_kmem_online(). And shrinking
>correctly happens only against the shared root queue when the reclaim
>iterator walks root_mem_cgroup.
>
>HOWEVER, the THP shrinker explicitly sets SHRINKER_NONSLAB, which in
>turn overrides the previous override. So yes there is a weirdness: we
>get the root cgroup invocation against the shared queue, and then one
>more time triggered by that random memcg bit.
>
>The most direct fix is to just drop SHRINKER_NONSLAB. It declares
>independence from kmem, which is no longer true.
>
>Cleaning up the shrinker code is left for another day.

Thanks for working on this!

Wondering if this fix trades one problem for another, though ...

Before this series, the deferred split shrinker had a real per-memcg
queue. Even with cgroup.memory=nokmem, memcg reclaim could still scan
that memcg's own deferred_split_queue:

memcg reclaim -> deferred split shrinker -> sc->memcg->deferred_split_queue

With the fix, nokmem + w/o SHRINKER_NONSLAB falls back to a
non-memcg-aware shrinker:

memcg reclaim -> skip deferred split shrinker

root/global reclaim -> deferred split shrinker -> shared list_lru

Is that expected? There woud be no memcg-driven deferred split reclaim
under nokmem, IIUC ...

Not sure what the right fix is, as I am not a memcg expert ...

Cheers, Lance

>Andrew, if there are no objections, can you please fold this?
>
>---
>
>>From 6787efabb9584824c196bf01c517d93aae3764c3 Mon Sep 17 00:00:00 2001
>From: Johannes Weiner <hannes@cmpxchg.org>
>Date: Tue, 2 Jun 2026 17:11:46 -0400
>Subject: [PATCH] mm: switch deferred split shrinker to list_lru fix
>
>Lance Yang points out a weirdness in the list_lru code with
>cgroup.memory=nokmem: in this mode, list_lru collapses to a shared
>per-node list that holds the folios, but __list_lru_add() still sets
>the shrinker bit on the owning memcg.
>
>Usually this is fine, because the generic shrinker code ignores these
>random bits when !memcg_kmem_online(). But the THP shrinker still has
>the SHRINKER_NONSLAB flag set, which specifically declares an
>independence from kmem. As a result, the shrinker fires twice per
>reclaim cycle: one during the regular root cgroup scan, and then one
>more time triggered from whichever memcg got the shrinker bit.
>
>Drop the flag, since it's no longer true. The deferred_split shrinker
>then behaves like every other list_lru-backed shrinker under nokmem,
>including the non-kmem ones (zswap, workingset shadow_nodes): skipped
>from memcg-internal reclaim, driven by global reclaim only.
>
>This needs proper cleaning up on the shrinker and list_lru side, but
>that's scope for a follow-up series. Just make it consistent now.
>
>Reported-by: Lance Yang <lance.yang@linux.dev>
>Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>---
> mm/huge_memory.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>
>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index 72f6caf0fec6..aef495891f8c 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -956,8 +956,7 @@ int folio_memcg_alloc_deferred(struct folio *folio)
> static int __init thp_shrinker_init(void)
> {
> 	deferred_split_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
>-						 SHRINKER_MEMCG_AWARE |
>-						 SHRINKER_NONSLAB,
>+						 SHRINKER_MEMCG_AWARE,
> 						 "thp-deferred_split");
> 	if (!deferred_split_shrinker)
> 		return -ENOMEM;
>-- 
>2.54.0
>
>

