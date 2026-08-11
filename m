Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 544ACC5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 20:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C7536B00A7; Tue, 11 Aug 2026 16:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49EFA6B00A9; Tue, 11 Aug 2026 16:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5266B00AA; Tue, 11 Aug 2026 16:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1326D6B00A7
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:32:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8DA961C07B3
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:32:58 +0000 (UTC)
X-FDA: 85090137636.18.764FE29
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0A34E40005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 20:32:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=af9Yzsml;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786480377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CN2l9vWwoY/I0+/xUhc13X8fJjrgmTbCFVIi09J5CeY=;
	b=7en+BtZsuw+PYWSEYpRSYBSu9HvlTXooGMh4FinGKKv4XcPEJrIeM73jpnxOQoUpUcydVl
	dhV6Oy5C1Is++jGT2tC3gRejpYc6kH0PVxCioVc23+9ZvWPq0N/LkqWaQik6iRPN6Oc87o
	T7djepVv/lJR3WbFN33k6aVyl5fGQpk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=af9Yzsml;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786480377;
	b=2BP5Rh9p9D5ymvYbAcHFSFmlPUMT3KMzjEIC3cIm1+LdPuOuRL5zvqFMKrvXhJMraKvg7e
	nsyi/bo/zzmIKgW9CvP/AbFqNRMI5Rpt4JRud6da9uKbEc/wJ5T6lzl4h8JtSBaG91XuCf
	iXCoHoUYOU1OpWBtRX/b6zt9xpEIOQY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786480375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CN2l9vWwoY/I0+/xUhc13X8fJjrgmTbCFVIi09J5CeY=;
	b=af9YzsmlUM8QyJokSTb4jl52AGvGhzDmHQV45zQAnc+V3AZGcRml/gBTj66J2r2qxPKzv8
	eN/7vvJORDm58oraWpUHvex7ga5Jyw3DfjmD9HzwJMXBlnKuHfY767ETMMCySch/fkEOPa
	AMO+TEodrg0AxugIsaFVYFIbmwzFnZA=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] memcg: remove mem_cgroup->soft_limit
Date: Tue, 11 Aug 2026 13:32:02 -0700
Message-ID: <20260811203203.3456029-9-shakeel.butt@linux.dev>
In-Reply-To: <20260811203203.3456029-1-shakeel.butt@linux.dev>
References: <20260811203203.3456029-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A34E40005
X-Rspamd-Server: rspam07
X-Stat-Signature: mp7oze8wfhi8q7onyxmqso768m7owogk
X-HE-Tag: 1786480376-506925
X-HE-Meta: U2FsdGVkX1/9yk2FtqlcMACzzAGfjOsCM8v/1e6odR3jndF1QdigDxE3d3ni6ifzG2IRLcdBZPzVSIc01YrdZZD8jXdOiqyLmEXkD8wJTaW2PNUhNZN0nsw15Toa0tuS98R9bkov6auioDoZK4FFYentpC910xNDs1Mdq1fX4SDGN7/din3ctQVLjaFz5XK08cJC3gbzOzcJ5ZlDIoK0GXdrFgW9YfJDKk+4NJ1OZ6V8ZaXMRO648/YbBRu6Ejr5EiP6MTUTOc3+DC7LzGoIODh/54a204w2oVq1ihYsb35PSVKcyNQkqbt/2OcWuXiJ7DVo9rRSDPHlAkzYcMhwzaBrNdPzDY/O7QN1R9Yh1g+xoLG1p8O4FcNs8IS5fJ7LRaUmhb0WF5mYjSveRlPPIlIBWXDkYuLuI/XyYC5I/pWErwUrGQpMlGTym8VLOLbOzPMLTNFWGTIvsMsvfSVfLDvVXrXLylXcj9h9gSje8oUL2SRAhVBojsJH79pR5t6dFk+7L0f9JpcVznrXdPe/o+LRHjg5uIbWdlhbF0KWN0EPKTxrLPydw9w3a9MsObxXLDyB/4NWdeYf92JsR9UbBAHksT8oXTEd4HVwYq7EROe2DyNacbZLNXppqdfDg8n0SSLevS9qKvrzRnY81rVovN+X/GVpiJIpQQcQIlBsz0BmXYl4MkeD8ncFSjKtABKC3cZaREoBDqErgMr4S4oTWMTutk8CilnjSs02pq7fFvbG55qjzYXJWIovhq1v9tylN8Cj3J/3kCVl5uENCI6k4bEFGwHZs0sbdh8Zju3DjP3Ff5sntKumS8Pl4K58JotYde6JSMqfWe0Gti6uDCETMvKB1+oGylhElakwG/bDD+kP70YI7noelCTZszv6sd2EQhaKOBUbuRf8NKPs/Bf+aDMhBBv9moBiKNdHgtdmV3aZtN/OPj9Uxfilic/2ICL3YqHIgif9SigVtil+bDO
 8swSDMzs
 nZeWZnU7S1c5FFV/pkn3b55Rlss92n8GGuIm4rXsrwsYv/t9fVXrFe88onmgSjOqSD0woTZ7EyvCqvB8Jq67zJaOAt0jQH6yVyL52QLBWgG9TTIgWVv4dIGH2RYwfpDbfTfK72syrRYFNrEWw6YrD/T6HyHCeJcvnLA3AkpY1tuegiEYnSj4chgUn/bw4wbGdbVULpo5qWBe1FRp50zoTaz0EiOxntmt2XC3OqU+IVEYO+loV3r1j5+sbmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nothing reads it anymore, so the field and the helper that reset it on
css alloc and css reset can go.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 2 --
 mm/memcontrol-v1.h         | 6 ------
 mm/memcontrol.c            | 2 --
 3 files changed, 10 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ce24e04967d8..526da1d869ed 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -275,8 +275,6 @@ struct mem_cgroup {
 
 	struct memcg1_events_percpu __percpu *events_percpu;
 
-	unsigned long soft_limit;
-
 	/* protected by memcg_oom_lock */
 	bool oom_lock;
 	int under_oom;
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index fd611e66859a..f48d0e22e615 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -42,11 +42,6 @@ void memcg1_free_events(struct mem_cgroup *memcg);
 
 void memcg1_memcg_init(struct mem_cgroup *memcg);
 
-static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg)
-{
-	WRITE_ONCE(memcg->soft_limit, PAGE_COUNTER_MAX);
-}
-
 struct cgroup_taskset;
 void memcg1_css_offline(struct mem_cgroup *memcg);
 
@@ -97,7 +92,6 @@ static inline bool memcg1_alloc_events(struct mem_cgroup *memcg) { return true;
 static inline void memcg1_free_events(struct mem_cgroup *memcg) {}
 
 static inline void memcg1_memcg_init(struct mem_cgroup *memcg) {}
-static inline void memcg1_soft_limit_reset(struct mem_cgroup *memcg) {}
 static inline void memcg1_css_offline(struct mem_cgroup *memcg) {}
 
 static inline bool memcg1_oom_prepare(struct mem_cgroup *memcg, bool *locked)
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b68f1f16ae54..ba3ef821553d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4222,7 +4222,6 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		return ERR_CAST(memcg);
 
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
-	memcg1_soft_limit_reset(memcg);
 #ifdef CONFIG_ZSWAP
 	memcg->zswap_max = PAGE_COUNTER_MAX;
 	WRITE_ONCE(memcg->zswap_writeback, true);
@@ -4429,7 +4428,6 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 	page_counter_set_min(&memcg->memory, 0);
 	page_counter_set_low(&memcg->memory, 0);
 	page_counter_set_high(&memcg->memory, PAGE_COUNTER_MAX);
-	memcg1_soft_limit_reset(memcg);
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	memcg_wb_domain_size_changed(memcg);
 }
-- 
2.53.0-Meta


