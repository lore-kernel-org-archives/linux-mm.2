Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 827DDC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DCE36B00AA; Fri, 18 Sep 2026 05:19:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28DD26B00AC; Fri, 18 Sep 2026 05:19:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 154FF6B00AB; Fri, 18 Sep 2026 05:19:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D462F6B00A7
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:19:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC75EA5EB7
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:19:02 +0000 (UTC)
X-FDA: 85226333724.01.6995CB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E73CF1C0009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:19:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mxOSpZGv;
	spf=pass (imf18.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789723141;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCG36X89WdpeW7yUiFmpzxNWK5utBoPDYcDQvrr9Kng=;
	b=aLXKlNlnsqxD7BrTtQ9L6CNS9e+nMC/XqCXo84AE5yXHK1+qQ+p1l2yz18hwbKJGjnPV9y
	lgZdVeil6wnUYXj1PDDYH/P+nGZrvsV70bGgPpGcVqurUroU7nFRBwn90hSjwjyFnSsJZ5
	I0DFZeEGONwW0dt1GNnT42yoScoEwiA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789723141;
	b=4ILGhDXbeaSMeAvUSfPSRNVt/Kfmk4VVO5TCDAHsY9ISsliMEE5bA76R7xkzBGEIEz4vVA
	IpbFy79fr4Tl/wICsVjRTmrAM8ZMc6j7ldDxBO+lIck5YyBox6WKLpyxVCpWckjSlrJuIK
	cz/GL+Wmaqlg3djSCpMksnRGHUuIWY0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mxOSpZGv;
	spf=pass (imf18.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4AE8243F1B;
	Fri, 18 Sep 2026 09:19:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F363BC4AF09;
	Fri, 18 Sep 2026 09:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789723140;
	bh=C+aZ/PHCHVwPqKCsmHIkGeCsoWqK7M+a2bgJxBzAS6s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mxOSpZGvxT5tYcAJ4npmZNQ/Puq3w5SG3WfTQCbiiOIAmw3u8QDC2Yuyhf4ZAhUOD
	 onO3v5MGj/LLjoG/rFOYp2Gr104VKE1T7hDU4QGQGYjlKpjz+vuCefZw8Z5MW7Ws5H
	 ivKgAlz26wZEeaWtFsy0SBOiOfS/d9cLGCAacop1KR/6BIPr3H0lZKQVcunF4nQzUf
	 dk5dbruLON7jjz/HUgEDJhmHd/LJ9rFGVkAIUNwrQKjmPjCDpzFgd7q1+8cNVDTY6x
	 OoxZLMfgaDLaU2YUYrIyqMGCr+1uTEzFqlqsuaGydBO0ZbwOUHERi3M1OBII51xOhH
	 WD/EvHOp9FQAQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF0AC982DC;
	Fri, 18 Sep 2026 09:18:59 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Fri, 18 Sep 2026 17:18:42 +0800
Subject: [PATCH 3/4] memcg: manipulate memcg private ID references by ID
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260918-bingfangguo-memcgid-rework-v1-3-5bbf3220d88f@tencent.com>
References: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
In-Reply-To: <20260918-bingfangguo-memcgid-rework-v1-0-5bbf3220d88f@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789723137; l=5810;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=6P3XefKks8CnjRxUmQqiyNUvDBHLa0aO+gsTJIsTI0E=;
 b=Pvgko5tDjB9FVjV0Ty8Jov0miIgcIg+4+4UcwUj5o0qs+t4mPU7JmBhHLFt3MlZtZXEjOur5N
 fqGR0rot3OvDoSYo0FqJpwOZsycCmkYXA0blmpFz2v9EdJBp2kcKO/G
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 1dswu1y7cahng6dyb638hhu6q4z58eoq
X-Rspamd-Queue-Id: E73CF1C0009
X-HE-Tag: 1789723140-966493
X-HE-Meta: U2FsdGVkX1/SQ+SzLg7GkWErKjYxHEkgOWSPlqLUXvLlZrSdfRHHeZdGZNA2ECcF2gaeA0RrJAAjwzkEeHtS18sAPiOKXlW8tiQKPEnAIjfhWyiGk3IiY6PCRq/MFv2hYlTY0h/UA54t4xPnCUVixDerN0BirggbKogvLllNxPhU09Pqgi9NWowBTgzP+QHZgqGz7WwoNSC2hJ+0wvHw2xBW1uNEdvTX0iU2JKsrnzJD75CpwgzpYTz+tDb3sOsPZEoTdC32kiOVTJ5fB41iyXYBVq8eJNI7i89BiejpAz7IS/F3ChBqeM63IZKPwrYZfNux6wQIP3zwiLvc9n7gr+wzPtyaQQjQdBTTgAFpr9pK8763d67/GjFxz5xjad1iaaFVEzxss690FVB8P7yxDlzoQr7qnX33q6x9vPjBColnAkdEn9SR22sSEEAZ3nQWWDiSJ8N7Ra40ORGp3+WLAOxD+BuQWGXujhvE+Q1YgjaGCRiKyP691V9H5NzadunTr/SduNDTR1fe63dCF8X4cGgKlx44LDtFKbF2OmRcDn0endlCl3IjW7q2V/nGgAeUa7F8/vgaJ+XrLLPefFIQRj8NHQszEmin4QZlXcX8kP9AbeFFaPSlAd7IBg2Cy1yi9kt/ZBBjkpgpcxu0jubTlEcKwHr2qIf1bZFsVBn8HRGR1SbwRdsr+4+3N4njP9GBLCpMI6mbkLwKV0DvH/B/H2/X0CouOsMFYpNAWKvPlly1+/nTUPWHEMbl9HhpdmXNQz25NthaZURCi/orw+cO6gssbb+V7UVHiHWI0Yzwiaganxy6f3/i5+uHEAHfPZwuDWjy6hwWbDaxoMoM8fw8KI/+I9g98RT/9Kz2pjBJEnh4Bc09FJiwp4ckCJy7uzkaqh3qYScxShVVDa5u9DOODWtSZ92/v+PADqsNi5OdaRI6MX5KaRfWJOj0e/ELLtTwtblyQrXb2xR7FdBJn/E
 p7EPpubG
 4els1H0cBjOUUzyMRFzDmG6mq6B8lQqb6ttJtw2k3LArgVHTI15ygRH9ahuE4FyyGAn3rG/kKY1F0C2Kx9MI86moq+VJGld67Y9F+RxnkYbdN2hBd9WXLkcOmh0xNDLefgQ7+Fb5s6W7xnP53qeTnKRjV3NNwqoBEeV5TD8zy6GTzTiGToM2JFmxXV53PPdh2Lbtc4zZ6xukY+q+e7/HIzW4GkLzkbrfLmdPoulM8WJDkTtu83ULCF2IbGXXIPfiE2wZjghYQK6yitrnzighkbu+oTbIQ+aFuz+ckrk6QYlN3qHX+LGkLCV5VNAYLnbxeZA9opIzjXH01dpOoM/uNQapm1p2ulj85PVIxmfksuZ3ZSkBklP8SUEYVYKDo+sBaYLSugRLUw16nLuBlKwKbw3V0wxTlP9iInwj62X34/WoV4zo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bingfang Guo <bingfangguo@tencent.com>

This is a preparatory work for moving memcgid from memcg to objcg.

Swap entries retain a private ID rather than a memcg pointer. Once
private ID references are moved to objcgs, the ID can also outlive the
memcg to which it was originally assigned.  So it's better to make the
get and put functions accept the ID itself instead of the memcg.

Rename mem_cgroup_private_id_get_online() to
mem_cgroup_private_id_get(), and make it return the ID only.  If the
memcg is already dying, the dying memcg will still be used for charging
and stats accounting in v2 swap charging path. But they are hierarchical
and will be reparented after offlining so it doesn't matter.

Make mem_cgroup_private_id_put() take the ID and resolve the reference
holder internally. Convert swap uncharge and charge rollback to release
the reference using that ID.  This introduces an extra xarray lookup for
now, which will be removed in the final patch.

Separate the online-state reference release into
mem_cgroup_private_id_kill(). The offline path already has the memcg
pointer and can call the underlying put helper directly.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/memcontrol-v1.c |  7 +++----
 mm/memcontrol-v1.h |  3 +--
 mm/memcontrol.c    | 32 +++++++++++++++++++++++---------
 3 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index ed015fdd95123..b7f2868885071 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -268,7 +268,7 @@ void memcg1_commit_charge(struct folio *folio, struct mem_cgroup *memcg)
  */
 void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 {
-	struct mem_cgroup *memcg, *swap_memcg;
+	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
 	unsigned int nr_entries;
 	unsigned short private_id;
@@ -298,9 +298,8 @@ void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci)
 	 * if the ID refers to the root memcg.
 	 */
 	nr_entries = folio_nr_pages(folio);
-	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
-	private_id = mem_cgroup_private_id(swap_memcg);
-	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
+	private_id = mem_cgroup_private_id_get(memcg, nr_entries);
+	mod_memcg_state(memcg, MEMCG_SWAP, nr_entries);
 
 	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries, private_id);
 
diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
index 23be2512702dc..281425273ea97 100644
--- a/mm/memcontrol-v1.h
+++ b/mm/memcontrol-v1.h
@@ -27,8 +27,7 @@ static inline bool mem_cgroup_private_id_is_root(unsigned short id)
 	return id == mem_cgroup_private_id(root_mem_cgroup);
 }
 
-struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
-						    unsigned int n);
+unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n);
 
 void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 				       struct mem_cgroup *parent, int idx);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index bfe53e4392f09..ed44b3e7ac938 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4082,7 +4082,7 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
 	}
 }
 
-static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
+static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
 {
 	if (refcount_sub_and_test(n, &memcg->private_id_ref)) {
 		mem_cgroup_private_id_remove(memcg);
@@ -4092,7 +4092,22 @@ static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned
 	}
 }
 
-struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
+static inline void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_private_id(id);
+	__mem_cgroup_private_id_put(memcg, n);
+	rcu_read_unlock();
+}
+
+static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
+{
+	__mem_cgroup_private_id_put(memcg, 1);
+}
+
+unsigned short mem_cgroup_private_id_get(struct mem_cgroup *memcg, unsigned int n)
 {
 	while (!refcount_add_not_zero(n, &memcg->private_id_ref)) {
 		/*
@@ -4105,7 +4120,8 @@ struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, un
 		}
 		memcg = parent_mem_cgroup(memcg);
 	}
-	return memcg;
+
+	return mem_cgroup_private_id(memcg);
 }
 
 /**
@@ -4430,7 +4446,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	drain_all_stock(memcg);
 
-	mem_cgroup_private_id_put(memcg, 1);
+	mem_cgroup_private_id_kill(memcg);
 }
 
 static void mem_cgroup_css_released(struct cgroup_subsys_state *css)
@@ -5972,15 +5988,13 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 		return 0;
 	}
 
-	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
-	/* memcg is pined by memcg ID. */
-	private_id = mem_cgroup_private_id(memcg);
+	private_id = mem_cgroup_private_id_get(memcg, nr_pages);
 
 	if (!mem_cgroup_private_id_is_root(private_id) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_private_id_put(memcg, nr_pages);
+		mem_cgroup_private_id_put(private_id, nr_pages);
 		rcu_read_unlock();
 		return -ENOMEM;
 	}
@@ -6013,7 +6027,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
 				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_private_id_put(memcg, nr_pages);
+		mem_cgroup_private_id_put(id, nr_pages);
 	}
 	rcu_read_unlock();
 }

-- 
2.43.7



