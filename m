Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16423EEC2A7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 22:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF6CA6B0093; Mon, 23 Feb 2026 17:38:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62856B0095; Mon, 23 Feb 2026 17:38:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B38CE6B0096; Mon, 23 Feb 2026 17:38:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 971936B0093
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:38:46 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68085160307
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:38:46 +0000 (UTC)
X-FDA: 84477187452.19.6CB8E6E
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8F2BD20004
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:38:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l2aezRd6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771886324; a=rsa-sha256;
	cv=none;
	b=Gv6xyNqESRfbMT+9PMaBHzQOM12UFYJXhm6HzfAtGv8SCrO5Tm81TZBlG2PA9Mpf6T3j0P
	ndlBwUAngexI3LapbyyMG/vbG6lsIO3862cztzZues0qrC/QXg8Oq0pkHO0DBd/XCpsaA1
	P0lL5XGWiddKYtljFpv7Nf1RMuXzdws=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l2aezRd6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771886324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/pi4GMyqfUzxedG8y+xzMj5Pky+ci5h56Uzs52BODo=;
	b=gQDVkb7oeC71HZ8ct3Wfa5NdLTi3QvsQ37uH5MIksBdzzq58Z/TKHObfCcDuOI589uHelN
	uaYx0D62VKNzaUYV7sL6ze1NyP0dT0m1/8VaZDJFEG/oFc6qMmo3K/rwpsT09CPSFB7tO4
	XyK7tLbapG6UWih6+NaPNE5oFzhR2yo=
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d4c68f0e47so2859268a34.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771886323; x=1772491123; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1/pi4GMyqfUzxedG8y+xzMj5Pky+ci5h56Uzs52BODo=;
        b=l2aezRd6/Qy/3bNAlNLYTlld6H3O+YNFM/z1wcYm0/m/d+BjgKr0IO+k2c1Wg5KS1q
         qP4ludVjRH0ixRpVCVrqR3pi/WuS38Gsp7UI01QQWEvyK6sX4aYfghBoXhw50ZWQQtkJ
         MpARYnYsJfO8IHSj41nwWVLabxfusC+bbNVfPXlnSXz5WalPgUfTn5XH8Nirko6B33H8
         uZzl4q6yydu3+Ch6BOJ6lZZWDsxWxVW4MF2sciG7jCL0K5DLXEcN1U+M5CRnvnBA+cmT
         dTAfbTvCbd//RGr+WaUMBf9O2bL4PS61iCTK/Y1Cp2y48+KVJXOU+S8eCbIk5D2scuAZ
         bd1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771886323; x=1772491123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1/pi4GMyqfUzxedG8y+xzMj5Pky+ci5h56Uzs52BODo=;
        b=vx8pkj6fd5VPx39dytbNN5DxBNgojtWWbncfPXb4+U7VnFrlwKS6gEHWw36EMcrLBd
         0dpnvvvh0OQ4x3G/uk4rqPuVgD7/R8bOIrzed6gjO8L3PpTplOqjfKQe3G0kpqmPwHtO
         4vvuN707n0K0g3ye9Ozpz7CP+8AozbGwMWgHLZTIKceEoquhykKUg2qv7BJ18jyP02Cm
         aEKOr3Kkht7Q9/Sm6JEibvRUxrdrCw7LUEudxdBNhCJ/xdUMe/snaIy674r1TyOy99fP
         OIanDEuwgok4hNyGqzOaUWEzBAMjmMWAy+s21mM0V7uxYmS+JjhKi7NXDgDW1wK+ZF96
         kc1A==
X-Forwarded-Encrypted: i=1; AJvYcCUy88r8slhgj7dIy0eeQabJ+wAr56nkN3feQ8V3B+EGs/1N3PSK3d0QeKdoQpu8TldYjkPwif4Dpw==@kvack.org
X-Gm-Message-State: AOJu0YyZYGCP+QCjx7sW2p1vFYUfhx0/tnmpfbI53CJ7a22SQPDl5YMk
	OeCgQFLCgdkQ0ytVaCgnZFMV0HdCzKzeOjWZ/Cf7w9b7rC35beNIyP0t
X-Gm-Gg: AZuq6aJ8HJX1/HGH/n9YqJF1W+RaiCKf3Mx+FwiWjsgyp7U3q06o3LNn+INRMthNYt7
	KLVaYON8x/Fb0O6U+DnmvNXOiuvgSlfR3yaLsROAPcF61pQl0PiSw/ijlfV0P/GnLvzd2NHNgkd
	kBv11Ygsp8FTJAktSLjIVlDvnYY17Bythq96e3CCaOlK1qGU+HFvlm5L78tQmbIo8fhEAC/hoSO
	VZUXTZLX9yNomGrWsn0kp/W7u01asmxovTcE767YWY2hF0s+k9zsGoRLwU6pF8XZPtwSTWSNry7
	1OgZGRylql8YcfVz4TcyKqcsctCezf9oFSunUcu+jG7HUpLkhyi3OrzOPyMHXqXwqFiDG+YLFm6
	Rv+vZf22IRLUs7zkqOEqraVlo2O+cWa5ldWgK/61jAo1cNEqcBSxk9AQvMYCMJh9qC4FWQpynWO
	REa9ymLiaeabZjGVjfnrXhAJe5M8dHPxz2
X-Received: by 2002:a05:6830:6610:b0:7d1:9da9:c6e with SMTP id 46e09a7af769-7d52bf6bb20mr5168975a34.25.1771886323539;
        Mon, 23 Feb 2026 14:38:43 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:71::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d52ce63069sm8952812a34.0.2026.02.23.14.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 14:38:42 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH 6/6] mm/memcontrol: Make memory.high tier-aware
Date: Mon, 23 Feb 2026 14:38:29 -0800
Message-ID: <20260223223830.586018-7-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
References: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8F2BD20004
X-Stat-Signature: ixdxxbsxz49rwdayb45enza6xr7aoica
X-HE-Tag: 1771886324-571271
X-HE-Meta: U2FsdGVkX1+QH4IU1S0mRx31376iK1sWKqcZ6FnLuMmRyEtEtppe7Q066cDOcrFQB3z6UFBiVzJvzCqV60ja0OshY8kROgeRdl7wVM75Uz91zGvit/bX7HZb6FOs88Q0H1ob808o5VxOmM5u0E4FBf2uwTx3kHPr3R8lNs6MdtGZHYXb3xogkd9ZkuExJbfey5rzi3UAZcxcQH0NfKXK0/g5P2lZ+rW2gMEJ2PTcJFq0XdMwXuKRq2YIKbGhYqSjWMU4YImoBvDtcyBDb+oBhani1HlCkNH7MM3SSvzooE0OFK3M4y3uo2SrvbaZFLgIW5hgY2jGhdBXXSEuCHgJCzgVr9/McAZwuEEeTBUybbtL5qaVc7EF6ZC8o/YaOt578ZAb0xmFdee69QOy19QK2oZRWOMPEMlQyUchh0InAjQt0TWRJT7ejRBKrojVhV67775r2b3m6OemO31O4AlU5q9sHLoa2A/302KHL14lTH7RQxWIBPeS16qGu2lDbfdjZ5kHXXgAJpCq5HeIoYLuH7bZC1UClbsJsPTzkW8XrT4tHbblREKlNihaU6xxXKhMxqsvykifAQZom2aQNzRBRPMBPl0pIPjh66ZGPa4XW0tJqSQpFY9xWc/OwaToD0uTrljQYX/eBKXLwlGKlZZ1wlGv51m+UvJNRKGir8Tyj+0vAw4RV97s4hhqTHFkV5cYl2FsZR+09+I+bFG27hnDWkO0TyFA0SsytjbabySLAG7BlpvZNqHXNLI7SQXbYNIkO+uhMZR61xnS6MhKixETZ+66TK+n1JgqG06D96dDdajtEGTxbfZyxdk8z1pOeI9yE0ENFf+ioXoBR9AtD7BtWvP5vj3K6VdS55X23IgTxHysofNVTNWAr5C6No7td7IJPBgqI7OkOpsIHbVHqZVu1W2W9y8eFuNE5efHU4m834DBkFDuv9/rzPLWjyLFUc7p3jQFEeA5oz19l2ivI81
 VJvFgGo1
 EYnYzE83fh5rYfjOi4Dre2k2Nmq87L6fjDRaXTcAxtX/Bd7rk9l7hvx8NdvbZktKIgp+ArIkch4Amq0liOQXgYnjovicfIHTvIUTIPmN51Mw0gtwVeoAA52pCKDKoyNdkgLoWHTkTFiHxF5IfLqvqaUdDeZvNZjfdjrKkICrQj5N6jhKmGM/Tw0l7XPOa2zsXo2SKVLRlZVz63RmzIi5yC0F1d5kwB/ho8Gw/CWVM+TUSuOzGDS8+JxJrFELlWfwf34emzS4C3PqHVIBMGqJCEaCFVoQzDwbiWi1CrOX8u0sjsS0aRNYoP2D4nG/xRah2K/GTWE3LxsjJ+WkfMkYhl/CKFiQN4POTiANBhBPr3owhyStSI74VyylwZiY2AqFPJV7nmxxljBUyCrFqxzMcxVUbsg6OdXawcZYkW8RqlSTyEWdARi6AaTjnl7DJVYG8a8V0O6EqgCHjDBmUdLU4F/Q8DImoTYzIF+xSIixdz6A2/rKANFGr97e6E8K5s+oZSXwL+0UJAZKVM/46B5c1uJ07ezQAFXrXLIaUm+StRdr6VbWoHHcLnBR4HLO6U8teYXvC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On machines serving multiple workloads whose memory is isolated via the
memory cgroup controller, it is currently impossible to enforce a fair
distribution of toptier memory among the workloads, as the only
enforcable limits have to do with total memory footprint, but not where
that memory resides.

This makes ensuring a consistent and baseline performance difficult, as
each workload's performance is heavily impacted by workload-external
factors wuch as which other workloads are co-located in the same host,
and the order at which different workloads are started.

Extend the existing memory.high protection to be tier-aware in the
charging and enforcement to limit toptier-hogging for workloads.

Also, add a new nodemask parameter to try_to_free_mem_cgroup_pages,
which can be used to selectively reclaim from memory at the
memcg-tier interection of a cgroup.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/swap.h |  3 +-
 mm/memcontrol-v1.c   |  6 ++--
 mm/memcontrol.c      | 85 +++++++++++++++++++++++++++++++++++++-------
 mm/vmscan.c          | 11 +++---
 4 files changed, 84 insertions(+), 21 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0effe3cc50f5..c6037ac7bf6e 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -368,7 +368,8 @@ extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 						  unsigned long nr_pages,
 						  gfp_t gfp_mask,
 						  unsigned int reclaim_options,
-						  int *swappiness);
+						  int *swappiness,
+						  nodemask_t *allowed);
 extern unsigned long mem_cgroup_shrink_node(struct mem_cgroup *mem,
 						gfp_t gfp_mask, bool noswap,
 						pg_data_t *pgdat,
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 0b39ba608109..29630c7f3567 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1497,7 +1497,8 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 		}
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP, NULL)) {
+				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP,
+				NULL, NULL)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -1529,7 +1530,8 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 			return -EINTR;
 
 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-						  MEMCG_RECLAIM_MAY_SWAP, NULL))
+						  MEMCG_RECLAIM_MAY_SWAP,
+						  NULL, NULL))
 			nr_retries--;
 	}
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8aa7ae361a73..ebd4a1b73c51 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2184,18 +2184,30 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 
 	do {
 		unsigned long pflags;
-
-		if (page_counter_read(&memcg->memory) <=
-		    READ_ONCE(memcg->memory.high))
+		nodemask_t toptier_nodes, *reclaim_nodes;
+		bool mem_high_ok, toptier_high_ok;
+
+		mt_get_toptier_nodemask(&toptier_nodes, NULL);
+		mem_high_ok = page_counter_read(&memcg->memory) <=
+			      READ_ONCE(memcg->memory.high);
+		toptier_high_ok = !(tier_aware_memcg_limits &&
+				    mem_cgroup_toptier_usage(memcg) >
+				    page_counter_toptier_high(&memcg->memory));
+		if (mem_high_ok && toptier_high_ok)
 			continue;
 
+		if (mem_high_ok && !toptier_high_ok)
+			reclaim_nodes = &toptier_nodes;
+		else
+			reclaim_nodes = NULL;
+
 		memcg_memory_event(memcg, MEMCG_HIGH);
 
 		psi_memstall_enter(&pflags);
 		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
 							gfp_mask,
 							MEMCG_RECLAIM_MAY_SWAP,
-							NULL);
+							NULL, reclaim_nodes);
 		psi_memstall_leave(&pflags);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
 		 !mem_cgroup_is_root(memcg));
@@ -2296,6 +2308,24 @@ static u64 mem_find_max_overage(struct mem_cgroup *memcg)
 	return max_overage;
 }
 
+static u64 toptier_find_max_overage(struct mem_cgroup *memcg)
+{
+	u64 overage, max_overage = 0;
+
+	if (!tier_aware_memcg_limits)
+		return 0;
+
+	do {
+		unsigned long usage = mem_cgroup_toptier_usage(memcg);
+		unsigned long high = page_counter_toptier_high(&memcg->memory);
+
+		overage = calculate_overage(usage, high);
+		max_overage = max(overage, max_overage);
+	} while ((memcg = parent_mem_cgroup(memcg)) &&
+		  !mem_cgroup_is_root(memcg));
+
+	return max_overage;
+}
 static u64 swap_find_max_overage(struct mem_cgroup *memcg)
 {
 	u64 overage, max_overage = 0;
@@ -2401,6 +2431,14 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 	penalty_jiffies += calculate_high_delay(memcg, nr_pages,
 						swap_find_max_overage(memcg));
 
+	/*
+	 * Don't double-penalize for toptier high overage if system-wide
+	 * memory.high has already been breached.
+	 */
+	if (!penalty_jiffies)
+		penalty_jiffies += calculate_high_delay(memcg, nr_pages,
+					toptier_find_max_overage(memcg));
+
 	/*
 	 * Clamp the max delay per usermode return so as to still keep the
 	 * application moving forwards and also permit diagnostics, albeit
@@ -2503,7 +2541,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 
 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, reclaim_options, NULL);
+						    gfp_mask, reclaim_options,
+						    NULL, NULL);
 	psi_memstall_leave(&pflags);
 
 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
@@ -2592,23 +2631,26 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * reclaim, the cost of mismatch is negligible.
 	 */
 	do {
-		bool mem_high, swap_high;
+		bool mem_high, swap_high, toptier_high = false;
 
 		mem_high = page_counter_read(&memcg->memory) >
 			READ_ONCE(memcg->memory.high);
 		swap_high = page_counter_read(&memcg->swap) >
 			READ_ONCE(memcg->swap.high);
+		toptier_high = tier_aware_memcg_limits &&
+			       (mem_cgroup_toptier_usage(memcg) >
+				page_counter_toptier_high(&memcg->memory));
 
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
@@ -4476,7 +4518,7 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
 	bool drained = false;
-	unsigned long high;
+	unsigned long high, toptier_high;
 	int err;
 
 	buf = strstrip(buf);
@@ -4485,15 +4527,22 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		return err;
 
 	page_counter_set_high(&memcg->memory, high);
+	toptier_high = page_counter_toptier_high(&memcg->memory);
 
 	if (of->file->f_flags & O_NONBLOCK)
 		goto out;
 
 	for (;;) {
 		unsigned long nr_pages = page_counter_read(&memcg->memory);
+		unsigned long toptier_pages = mem_cgroup_toptier_usage(memcg);
 		unsigned long reclaimed;
+		unsigned long to_free;
+		nodemask_t toptier_nodes, *reclaim_nodes;
+		bool mem_high_ok = nr_pages <= high;
+		bool toptier_high_ok = !(tier_aware_memcg_limits &&
+					 toptier_pages > toptier_high);
 
-		if (nr_pages <= high)
+		if (mem_high_ok && toptier_high_ok)
 			break;
 
 		if (signal_pending(current))
@@ -4505,8 +4554,17 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 			continue;
 		}
 
-		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL);
+		mt_get_toptier_nodemask(&toptier_nodes, NULL);
+		if (mem_high_ok && !toptier_high_ok) {
+			reclaim_nodes = &toptier_nodes;
+			to_free = toptier_pages - toptier_high;
+		} else {
+			reclaim_nodes = NULL;
+			to_free = nr_pages - high;
+		}
+		reclaimed = try_to_free_mem_cgroup_pages(memcg, to_free,
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL, reclaim_nodes);
 
 		if (!reclaimed && !nr_retries--)
 			break;
@@ -4558,7 +4616,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 
 		if (nr_reclaims) {
 			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL))
+					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
+					NULL, NULL))
 				nr_reclaims--;
 			continue;
 		}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5b4cb030a477..94498734b4f5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6652,7 +6652,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness)
+					   int *swappiness, nodemask_t *allowed)
 {
 	unsigned long nr_reclaimed;
 	unsigned int noreclaim_flag;
@@ -6668,6 +6668,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
+		.nodemask = allowed,
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
@@ -6693,7 +6694,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 					   unsigned long nr_pages,
 					   gfp_t gfp_mask,
 					   unsigned int reclaim_options,
-					   int *swappiness)
+					   int *swappiness, nodemask_t *allowed)
 {
 	return 0;
 }
@@ -7806,9 +7807,9 @@ int user_proactive_reclaim(char *buf,
 			reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
 					  MEMCG_RECLAIM_PROACTIVE;
 			reclaimed = try_to_free_mem_cgroup_pages(memcg,
-						 batch_size, gfp_mask,
-						 reclaim_options,
-						 swappiness == -1 ? NULL : &swappiness);
+					batch_size, gfp_mask, reclaim_options,
+					swappiness == -1 ? NULL : &swappiness,
+					NULL);
 		} else {
 			struct scan_control sc = {
 				.gfp_mask = current_gfp_context(gfp_mask),
-- 
2.47.3


