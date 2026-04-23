Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31F5AFDEE49
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 20:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 959536B0099; Thu, 23 Apr 2026 16:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9330A6B009B; Thu, 23 Apr 2026 16:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81EC76B009D; Thu, 23 Apr 2026 16:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6C23A6B0099
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:35:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08F491B81D1
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:35:05 +0000 (UTC)
X-FDA: 84690974970.15.87F1D2F
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	by imf10.hostedemail.com (Postfix) with ESMTP id 26850C0002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:35:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ctw0A9CJ;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776976503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VIA1ATnBximdIVrwS2AHkBrrXRUA8+TS+BtXj7CLEVI=;
	b=pXLgovQyfZwhQACzanDxAFLR+aKuYvzdvmPp7XiFVwQ2ssN/w7iYrj1Trc+PIuyk2+1T70
	0hEx8dVuk8v8dmXKXx9fXHkyRjmRxzKeelyCrS+vIVgBfQW+Ro1CWK/VxGvWEt9PEtk1+h
	0ebNCDrBRXBMk8DuzMh1C2Nt+pe4S0s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776976503; a=rsa-sha256;
	cv=none;
	b=LOQ2Ndu5tpNvFp28ZMtEDycYs4zarlztWfWfLHygM6hsDp85QWbBUxIIaZC5BTboyoUMqS
	6viWl9zh9/1bCmz3I9ORmbQnjDuQsRASIlEvlWRHUsWT8MrGBcrmoOJypp5WgoUxgsoPBV
	/CEett2PeInPhkEPS4pXHx1MqMpFdng=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ctw0A9CJ;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.169 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-479eb8bcacbso2289813b6e.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776976502; x=1777581302; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VIA1ATnBximdIVrwS2AHkBrrXRUA8+TS+BtXj7CLEVI=;
        b=Ctw0A9CJseUW43RjZrw+8wVgaabk8uvKh9GzuWGLlLjOkZApcWyJXsWiRwsJZmK6yB
         GtScEnSLPUfUZjtNiE58sm69agiSNpGTt/jYfi+h9dkjzTD5O46rSDBxnYFWIbL6ql9N
         YPefPVzo5GmOOvZA6/Clx6nZoYvoh61bZ/X1dWFBL0KRBj3AjAhmSQ7LMR9mBYQvNFfh
         NUxvnh9YKxzIHX5Z2R+EfpP0tP9OcYRH2tu+d7957stoGG31trpeXo1/BMactZq6mtm9
         o2CRbXowKBEUABUXAP7E6ShZrsXjWzEAJicOIc5RW8K+eN9/b6pB+9DcjfmKfI2m0CwK
         fbHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776976502; x=1777581302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VIA1ATnBximdIVrwS2AHkBrrXRUA8+TS+BtXj7CLEVI=;
        b=UBu4fatsmqRJNPrKNhpA2kvrhQ+D2nB1dQmHqYhb1tijdLmcP63Br2bNhxeknKjIkf
         41t1QY9mxb2A/uUUnq6tpXkfmF4a523OvZIOYpqnnpckWJFhszGGrRDDc0XhUzStp6HA
         vWRNcKuYW6TLt0z3AbCXayq4/HCXDmbLwkmtsDEqc3hKngSDdivhl219mLHe/vwyJon3
         O/NcjlzZ2CY+pRQtyA8X/Vzww4FuwfUvarRSz7CddaUE0MHUQX4Fv3JDnUvcA5z0C3Yd
         BtaeAuLakL8EDwLvHR60D9gRORSOJ2amBEJnktstA47syOmVFMdz6/LcAD7sHwH3Ii2R
         7PEA==
X-Gm-Message-State: AOJu0YyqIyGVACFN5B1HV515YIB3jzkEMs29if1MEw49P6Lrlj1dJ7CV
	fOJpUn6zpdTN6CeOU8Idz7rXBuJLZPH0ajVzocBgLe6/X4HGmsVaS/zLB3LZNg==
X-Gm-Gg: AeBDiesghxwiFgo2ibi8r0yEN/RaRiwIWuVY+95IcGeU2UUaPXt+S3OCEOoJ+mVhve4
	leWK2EfV336FDXup4ctAKs4YPPX+D/5FNCS6DEiJIhRU8mufN7s1PPDdBH5/97QuRsvIJSa897D
	XiWXw6xH8INEcIAYcD9eC8YExZhucBVi2oj/dy8VMZ3YUcGLBmqHhOyjMIGPvGvvF/zRYQfgH2u
	BoCIE6OrjKBUv+t4a5asb2KPMgAtoF72+93bcbCWKG2M1Ojw0epgTWk5HJuNqgq4esLwymB1751
	ZNQjoCjtAM8nl/KV32zg74vgZjTuXsNgGrMn3jn8GsUFbAnYLTwqukv1KLAgQCzAObg0qsu5I1R
	fDrgpTBcZuruYQ9NZ0QfwPKfQWhz9Qq8sxMIOK90TxzYHnL/wGM6sFeGg4BPoJ4eW/9ZSY+2iOW
	TjMILiorNxR+/uYMmNy6rMzfZDHPE9n80=
X-Received: by 2002:a05:6808:e642:b0:47a:ae7:b5f6 with SMTP id 5614622812f47-47a0ae7c548mr3040802b6e.43.1776976501368;
        Thu, 23 Apr 2026 13:35:01 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:7::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-479f6705d7asm5629481b6e.10.2026.04.23.13.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 13:34:58 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH 8/9 v2] mm/memcontrol: Make memory.high tier-aware
Date: Thu, 23 Apr 2026 13:34:42 -0700
Message-ID: <20260423203445.2914963-9-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
References: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eoqt9srpiaj39cjzecat3ansbdng5meb
X-Rspam-User: 
X-Rspamd-Queue-Id: 26850C0002
X-Rspamd-Server: rspam05
X-HE-Tag: 1776976502-435471
X-HE-Meta: U2FsdGVkX1/SrS9V6WPDiLBI7dgv4HWkBTinezIv0nhWO4Xm2nlulUHgWmqZkNK3/HYfjmo7z0mXGyKvmMqY74YMCDZ5Rb1rpdSth28uRGOWbvuUzpv8+QB0nojI8hLpVkw+87w8nEQJyslHqeqwh/jaAmEq5ckgYXQchJeX6A7juzpwsLNWmtykBlyD5FPqCFLYATufzqEpKHipYuw0yxChournxW0cTTX1Kyo4X7Zn1A9YJ6Tb9/ZoKHuiFptc4Zhx2CiUhFI+kKzdOlTWZyd23BViBHe/6QYT3IJQeFocGd/ULH0qW/QoMT6ec/D9LSr1CM5L/M1RzZrXeaqhQWMCL8DpgKgQ3mY++b0JGl4bcWN+tjGk3xFSMSqorOH7w5BGFUnGBO/Rmpq8P0eoM8Tqq3vI/SmhoV9fg0PL93l05J4efaJiRRXTzDlyw4clqdHwnRWlCa2H34XzA2RgPdh9NhdmGlQU+XVOmMwI+IUgmWfRTzycypy6AoPXLFZFFv1Y6pV/YoJ4u75XcGwLOQpze8fr2hVcc8uvkYcBq67zrc2Hb15kt+n5d1C7PLCifwmsykFH4tGchT/BwzLflLu/xJmsWscMyEKhho22nl4NgJzX4Fsib2ame8EWfCEX2wb7f+wjJanSSfk0bxBWgh5STqEAhiZwkwbcOrEXCHWAW/vhLpdrFtRm3FSM0sq4x/lrkKeqSTPPdDs5jlNj9pHgNDTXlUH9v/XBIc6wD4s/Ij5/+Dy2h1/pjIq64R6IvDd81LqUj7J2iaBz2kOMU/Q4hpV9tRQa8zd1mAqSRa9KoC9IXLxO9GahUPs2jFNhaj2wA+vAzEd4Pj11UnBhFoiBORGr78AtXdmL9b9hPgCWPcmbjrKI1pi2dtRwr5s7JdDwoLy2B+BZr1YWfLNzLXikojt4RU1TPhwQgXqJUYDdRMclD9zpcUA9vJ0UwsNvZm/6N5TENQxk56Pixq9
 5dDJt9ON
 u7GY3v13ru3SG0h7cbFKqWb8X//A6heEyHxue3/Yrnqi/pHtD/ph8cYiwAK6JCftmqDuw48eZ06xkzNXC+IM7ySW8Rz33cxT+s13VxKnKqu7crLEc2VtY/PBx46lZss3lmwRBqOxU+QuMicW3DXJfPMOwBkW8rTANkTHXdSOhy5WonXPAh28FsXeuhmOrS4/qcKoXfl5zTsRvDim+ziRteTNdjvh4xg7JQMMowv79IVaE5v9oQKfWLGNDYVVP3RthIbrXF5fF5fCyc3fIXuAd577vK10zgXm04qhxUwZOs3Aj65WEP4OMW0rX9WBjdXKz9Silvs9h0FSgvOXW14KZPJIKvPyCNdQ7aCfmEjwZsv7YGLIEXikKDdgEX5Kc3VLr2hMzM1vnCnPpDUzCM2x3pJ3HHx/eTW0GPBhPo3mh3HfIwGipxhlClwd/oQITimL+HhVeLL9cH1XB3X8X1FxPT5R6msjlaU4bXsmYaj2CnFMO0hbrioj21RXISg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On machines serving multiple workloads whose memory is isolated via the
memory cgroup controller, it is currently impossible to enforce a fair
distribution of toptier memory among the workloads, as the limits only
enforce total memory footprint, but not where that memory resides.

This makes ensuring consistent baseline performance difficult, as each
workload's performance is heavily impacted by workload-external factors
such as which other workloads are co-located in the same host, and the
order in which the workloads are started.

Extend the existing memory.high protection to be tier-aware.

Depending on the combination of limit breaches, selectively reclaim on
toptier nodes: when memory.high is breached, perform reclaim on all
nodes. When memory.high is safe but toptier.high is breached, perform
targeted reclaim on toptier nodes only.

Also, throttle allocations when toptier is breached as well, making sure
not to double-penalize when both toptier and memory limits are met.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 82 +++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 72 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b115ff40e268d..e5f39830d250d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2112,10 +2112,25 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 
 	do {
 		unsigned long pflags;
+		nodemask_t toptier_nodes;
+		nodemask_t *reclaim_targets = NULL;
 
 		if (page_counter_read(&memcg->memory) <=
-		    READ_ONCE(memcg->memory.high))
-			continue;
+		    READ_ONCE(memcg->memory.high)) {
+			if (!mem_cgroup_tiered_limits())
+				continue;
+
+			/*
+			 * Even if the memcg is under the memory limit, toptier
+			 * may have breached the toptier limit. Engage
+			 * targeted reclaim on toptier nodes if so.
+			 */
+			if (page_counter_read(&memcg->toptier) <=
+			    READ_ONCE(memcg->toptier.high))
+				continue;
+			get_toptier_nodemask(&toptier_nodes);
+			reclaim_targets = &toptier_nodes;
+		}
 
 		memcg_memory_event(memcg, MEMCG_HIGH);
 
@@ -2123,7 +2138,7 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
 							gfp_mask,
 							MEMCG_RECLAIM_MAY_SWAP,
-							NULL, NULL);
+							NULL, reclaim_targets);
 		psi_memstall_leave(&pflags);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
@@ -2224,6 +2239,23 @@ static u64 mem_find_max_overage(struct mem_cgroup *memcg)
 	return max_overage;
 }
 
+static u64 toptier_find_max_overage(struct mem_cgroup *memcg)
+{
+	u64 overage, max_overage = 0;
+
+	if (!mem_cgroup_tiered_limits())
+		return 0;
+
+	do {
+		overage = calculate_overage(page_counter_read(&memcg->toptier),
+					    READ_ONCE(memcg->toptier.high));
+		max_overage = max(overage, max_overage);
+	} while ((memcg = parent_mem_cgroup(memcg)) &&
+		  !mem_cgroup_is_root(memcg));
+
+	return max_overage;
+}
+
 static u64 swap_find_max_overage(struct mem_cgroup *memcg)
 {
 	u64 overage, max_overage = 0;
@@ -2326,6 +2358,14 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 	penalty_jiffies = calculate_high_delay(memcg, nr_pages,
 					       mem_find_max_overage(memcg));
 
+	/*
+	 * Don't double-penalize for toptier high overage if memory.high
+	 * overage penalization has already been accounted for.
+	 */
+	if (!penalty_jiffies)
+		penalty_jiffies += calculate_high_delay(memcg, nr_pages,
+					toptier_find_max_overage(memcg));
+
 	penalty_jiffies += calculate_high_delay(memcg, nr_pages,
 						swap_find_max_overage(memcg));
 
@@ -2522,22 +2562,26 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 */
 	do {
 		bool mem_high, swap_high;
+		bool toptier_high = false;
 
 		mem_high = page_counter_read(&memcg->memory) >
 			READ_ONCE(memcg->memory.high);
 		swap_high = page_counter_read(&memcg->swap) >
 			READ_ONCE(memcg->swap.high);
+		toptier_high = mem_cgroup_tiered_limits() &&
+			       page_counter_read(&memcg->toptier) >
+			       READ_ONCE(memcg->toptier.high);
 
 		/* Don't bother a random interrupted task */
 		if (!in_task()) {
-			if (mem_high) {
+			if (mem_high || toptier_high) {
 				schedule_work(&memcg->high_work);
 				break;
 			}
 			continue;
 		}
 
-		if (mem_high || swap_high) {
+		if (mem_high || swap_high || toptier_high) {
 			/*
 			 * The allocating tasks in this cgroup will need to do
 			 * reclaim or be throttled to prevent further growth
@@ -4577,10 +4621,28 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
-		unsigned long reclaimed;
+		unsigned long reclaimed, charge;
+		nodemask_t toptier_nodes;
+		nodemask_t *reclaim_targets = NULL;
 
-		if (nr_pages <= high)
-			break;
+		if (nr_pages <= high) {
+			unsigned long toptier_nr_pages, toptier_high;
+
+			if (!mem_cgroup_tiered_limits())
+				break;
+
+			toptier_nr_pages = page_counter_read(&memcg->toptier);
+			toptier_high = READ_ONCE(memcg->toptier.high);
+
+			if (toptier_nr_pages <= toptier_high)
+				break;
+
+			get_toptier_nodemask(&toptier_nodes);
+			reclaim_targets = &toptier_nodes;
+			charge = toptier_nr_pages - toptier_high;
+		} else {
+			charge = nr_pages - high;
+		}
 
 		if (signal_pending(current))
 			break;
@@ -4591,9 +4653,9 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 			continue;
 		}
 
-		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
+		reclaimed = try_to_free_mem_cgroup_pages(memcg, charge,
 					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
-					NULL, NULL);
+					NULL, reclaim_targets);
 
 		if (!reclaimed && !nr_retries--)
 			break;
-- 
2.52.0


