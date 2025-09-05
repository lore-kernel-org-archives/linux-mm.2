Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CE8ECA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 20:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD7F96B0023; Fri,  5 Sep 2025 16:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAFA56B0024; Fri,  5 Sep 2025 16:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BED2B6B0026; Fri,  5 Sep 2025 16:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ADE616B0023
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 16:16:24 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4B7ADB7FB7
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 20:16:24 +0000 (UTC)
X-FDA: 83856303888.09.7BF801C
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id A0CCF2000B
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 20:16:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="QV2b/Sbb";
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757103382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3YYDb0qAcN44JOLdZSoQVTNxvRczokE6j4vJhbAzTIg=;
	b=IP/sjBSRDuWkmpRhXquPzpTSc6B+AL21AQM8FKuixYnz3tpwJJ+6K5362349KE/WdE7rlF
	M+1u7sXRtf4pqj9OBXPLpeiTE439fuE7yRzavyJX2hqU364UzqsV44Vfe818EQH+uiB41J
	MjXZ7oxcHD7ntf87E835QdGfxsvTeLA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="QV2b/Sbb";
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757103382; a=rsa-sha256;
	cv=none;
	b=29OA3NsVwTYO36NB7QNChUXaZ6vEbwGAus5obiufrt3jFfz3aUaU8fm8nizPNJ4PwWsw5x
	NjwqEK2jcB76jqIUC2a6WGQux2QtwU3ZjVqqfNGpK8N9c6JBU6CGvvBEzUG0t3VxcPp51z
	hoPNK/LUxaK51//g5ggRogf+5Nijk24=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757103380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3YYDb0qAcN44JOLdZSoQVTNxvRczokE6j4vJhbAzTIg=;
	b=QV2b/Sbb4ipL5cZ9a9yJcNo8hdOASLTVa0TacgojNu7sZz20c2/nXWVL6boHbYt6djjB1S
	/OSgqE5jk4RYujgEEObAjaPqUIlE0+Uct8TGkoUtVptEPursmz+4wJNShlouI3aDznj5Ur
	xykcBXyVbRz92uQuPK1tNJxXM8sExhY=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Peilin Ye <yepeilin@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
Date: Fri,  5 Sep 2025 13:16:06 -0700
Message-ID: <20250905201606.66198-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A0CCF2000B
X-Stat-Signature: hwe6375daky3b7pk8pbhztjz9dsk1bct
X-Rspam-User: 
X-HE-Tag: 1757103382-870008
X-HE-Meta: U2FsdGVkX19dBMdxCHp49GxKnS6VBRjy5LlCObYkjAKuPVnTGjcvCfmsX8o66pXr2zHLQA3gc3LWeT/xHLhjkO088tHwRXsiPfsMlv8ZYzomXEnDkTRhR7macY17XYszhBA21udyUzqVGZEap2bFk9RAocVkvS9ecxV8xfJKnXbh+ky0ITIg3hHvWYXSFx3O9FnFhmv4xTZg/8JID26AkvU3nkiiR98Tfh4p2DLo1FVWVmmih/3tAFk2PpZYrNTi2b+ETBiFjkaWZduMTxGg8x3BoAOjWa/5p0gDZinzI4w5blQk/tojHdKe5A9ED4oZUQYeroQyJaIkGesJF8baZL+Jm0q24zjn5T5J2odgEOUzMsUhpqHIP2oDllYEzzvkj0lwJumX3JyEkfId4LAZSsE50tDYHlTyCChMEYFrRVAlM3nHkpXB2SMR5VnSSbR7Hm/CsrLJb/8xlmAjh7UDu9OQRvXY+VJMdiUBob8pKDxo8gFU5m7PT74YTBE1P5nxpQfo/S3PjfHhNF2KlIP01OnLYiFyzof3vnkG24Hed1fIyU/e3mFMIqG+0aSQGeuvkqJlMk8yPQOP69K2BBv5arldLL0YQ2LvoH4NJlx9bBXQWWOl7hIgCjQZGU8gc1g705XUMBXAL1FtS9iujwDDjM8/XodsI+H++2twS7NfMImv+eZfZeIeTHT4bWca40g4bM7JBlQmve7WfkMGUf3B/SVE0ArOX5lm63LWS/CtAygds5L3EDxbX93eFfYahoq/xXo8ybJemgVTdMWTXThm+Bl+t/DehLWE/jpijfqPFBjLslggf9uH6D9YJ7xMtuDwW62AhUgPndAMigiAWF/BO0OHxFT2IrnqzpYDtTAoO7bTagAM2MvZursIKvuB0YgTN01aRQ+IO0NON4Q3fG+EoZ06npVlEPYJLfrveESpGi/NBfIz4oN76ARDrpPl4Hdl5pFXLnHKGgKfKbaAnwC
 KK4IbJs/
 muK7bX1H5qzF4jMFOuVaSsHHMj3dIVFfKdwYRoN7ZyeU4oNyplSMZye6XT9yBo4gIleSgOWKDBwEuzT9Y2TeK9AFPhvGXtwJPHFt3aOYyoFEgVOO38MtUx6lxulCebpPSiCoz2ANLjv/PrddiWtL0qkIoRFIEsvK3PI13Iq05My0PY4lrmLPCPHvR5XPmQWnUBHNfjvEM9A6ZxsI96g7tdMvilKidB2QGA3emZ4rWhKCrnxZo3s/ZodlFcB1wZwIRFqwo/dk81wR2BWtqOUy+R4lxV8L0VbGv6rIB7S9MZHP4nDeyulm2ebNPO9eH6qTaPsAbHSqfMxT2rQM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Generally memcg charging is allowed from all the contexts including NMI
where even spinning on spinlock can cause locking issues. However one
call chain was missed during the addition of memcg charging from any
context support. That is try_charge_memcg() -> memcg_memory_event() ->
cgroup_file_notify().

The possible function call tree under cgroup_file_notify() can acquire
many different spin locks in spinning mode. Some of them are
cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
just skip cgroup_file_notify() from memcg charging if the context does
not allow spinning.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 23 ++++++++++++++++-------
 mm/memcontrol.c            |  7 ++++---
 2 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9dc5b52672a6..054fa34c936a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -993,22 +993,25 @@ static inline void count_memcg_event_mm(struct mm_struct *mm,
 	count_memcg_events_mm(mm, idx, 1);
 }
 
-static inline void memcg_memory_event(struct mem_cgroup *memcg,
-				      enum memcg_memory_event event)
+static inline void __memcg_memory_event(struct mem_cgroup *memcg,
+					enum memcg_memory_event event,
+					bool allow_spinning)
 {
 	bool swap_event = event == MEMCG_SWAP_HIGH || event == MEMCG_SWAP_MAX ||
 			  event == MEMCG_SWAP_FAIL;
 
 	atomic_long_inc(&memcg->memory_events_local[event]);
-	if (!swap_event)
+	if (!swap_event && allow_spinning)
 		cgroup_file_notify(&memcg->events_local_file);
 
 	do {
 		atomic_long_inc(&memcg->memory_events[event]);
-		if (swap_event)
-			cgroup_file_notify(&memcg->swap_events_file);
-		else
-			cgroup_file_notify(&memcg->events_file);
+		if (allow_spinning) {
+			if (swap_event)
+				cgroup_file_notify(&memcg->swap_events_file);
+			else
+				cgroup_file_notify(&memcg->events_file);
+		}
 
 		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 			break;
@@ -1018,6 +1021,12 @@ static inline void memcg_memory_event(struct mem_cgroup *memcg,
 		 !mem_cgroup_is_root(memcg));
 }
 
+static inline void memcg_memory_event(struct mem_cgroup *memcg,
+				      enum memcg_memory_event event)
+{
+	__memcg_memory_event(memcg, event, true);
+}
+
 static inline void memcg_memory_event_mm(struct mm_struct *mm,
 					 enum memcg_memory_event event)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 257d2c76b730..dd5cd9d352f3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2306,12 +2306,13 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool drained = false;
 	bool raised_max_event = false;
 	unsigned long pflags;
+	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
 
 retry:
 	if (consume_stock(memcg, nr_pages))
 		return 0;
 
-	if (!gfpflags_allow_spinning(gfp_mask))
+	if (!allow_spinning)
 		/* Avoid the refill and flush of the older stock */
 		batch = nr_pages;
 
@@ -2347,7 +2348,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (!gfpflags_allow_blocking(gfp_mask))
 		goto nomem;
 
-	memcg_memory_event(mem_over_limit, MEMCG_MAX);
+	__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 	raised_max_event = true;
 
 	psi_memstall_enter(&pflags);
@@ -2414,7 +2415,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * a MEMCG_MAX event.
 	 */
 	if (!raised_max_event)
-		memcg_memory_event(mem_over_limit, MEMCG_MAX);
+		__memcg_memory_event(mem_over_limit, MEMCG_MAX, allow_spinning);
 
 	/*
 	 * The allocation either can't fail or will lead to more memory
-- 
2.47.3


