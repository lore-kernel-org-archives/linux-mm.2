Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19661C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 06:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB7D96B00D5; Mon, 21 Sep 2026 02:16:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87B36B00E2; Mon, 21 Sep 2026 02:16:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26026B00DB; Mon, 21 Sep 2026 02:16:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8450D6B00D9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:16:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 04C441A05B1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:16:35 +0000 (UTC)
X-FDA: 85236760392.16.1480CA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id E8C3040002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:16:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mZdKqySA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789971394;
	b=Zt/p/gPIvRBfRzIdu69iq0ieuXLly1IUlFPyUdGEO1PVgbNTgIMsfsMyYzXjRxrtR4z3NG
	zQ3hHEBX7D6jv4ri3AfsMUYcrQ0Jw4nQoueDFlKfdaCfOUkclGLW+52WpK+b3Pi4x7x/EB
	OwxB3AOLEDJXcgx9d6fh8fZ8rPXHcbE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mZdKqySA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789971394;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=paUF59EPimRNC8YmI/okpM9XJPjdfAKYzKMwYX/1vQE=;
	b=2MCgKekGpynmvk2nCnam8aDDFViIpltmazrnLs3frOUBDG6VceZZAXcfGhp2Spti/bUl+5
	M2WJtrDT+Hd+sdmYmQZIQiBu2FbGXjPC3zxpmMFh9WppL5XpJvQB//gIhZhy88gsCvNRFh
	8xi1uD2sCOu2MRC0sVaO7ZO5bWXRaqA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DF6941FC2;
	Mon, 21 Sep 2026 06:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 015A4C2BCF6;
	Mon, 21 Sep 2026 06:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789971393;
	bh=ZUzMmbQpUdGk2onbydCh5L+k5zmd1xMeNqBbCinbBRE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mZdKqySApf4RZ48SjtA/U8c78d7SzuJAICSaNwPSpR2V7q+yciJsXGTczr3qeSB/z
	 tz+yv06lGv/Mud/zVSClnAPSJKMUnc4zPlpX2sU3R2cxOMABGrcNw2ljTIFaEBgKMP
	 53O7gdCM+1Rdh0D7kZ/ioerAMOD7jl56vm5BouH041+zTxFesvsvkKFIir816X9IY/
	 uSvzfp3Aj5cVnduVxELXRhx+42Taf5Lqaib3MsBucceJQx+d3KlF5dCdxc957YZnaw
	 TY01X1pFNrfiLOgRALffMe8ls32QTkTU9ucge36Na6YoY7vIVnOefkOTZaYmUJnCVw
	 vdYeQx+DFwW7w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D48F5C982E1;
	Mon, 21 Sep 2026 06:16:32 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Mon, 21 Sep 2026 14:16:24 +0800
Subject: [PATCH v2 1/4] memcg: keep swap charging under RCU protection
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-bingfangguo-memcgid-rework-v2-1-6c0637dc0edb@tencent.com>
References: <20260921-bingfangguo-memcgid-rework-v2-0-6c0637dc0edb@tencent.com>
In-Reply-To: <20260921-bingfangguo-memcgid-rework-v2-0-6c0637dc0edb@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789971391; l=2959;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=sE3zMklqkcFz3uR1w6qomhpryX2R8nExKsjfG+k30bI=;
 b=jYqZPOQzuqXt3gG9v8XXM4BalCcLyDqai9BvgC5xpefOPP5WMa23il4SGzRfiEbjc9+PIIj0H
 GvQ5nU6AAg/DDtdj1U5G90CxDuQBHe6GOo2QGChpb/L3eR4heGMLTma
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E8C3040002
X-Stat-Signature: mm7qdd4upnzuzzmch36qfw3a477637rd
X-HE-Tag: 1789971393-615711
X-HE-Meta: U2FsdGVkX18x8+qS3fqOkT1ykPofI4a3PEGPnmuP8ya9mYTWVYf3+rgDDYXCW/Gp7E0n3o9MpiLVtCn6GTrhT82T6k13shwY/KGrhS0gLX/0uDcmSvQwJyeGCM6GZYAVAc7N08PqDUdDwKcTySlrCmIrL1A92mmPw+l6rJldX0UXnfNQKMcMqPQIfi5iw6VPmd8bsT+jpglO1gQkHzC64Whkk4lBJ4kxBEjcVKZQDZ2nh2B0c6BD9QRe11+r0TabEa7RnAgZavfSBt7y4lRI73sDBiq7aGTharODpBYbPrrM6THloibAGCg3NL0+AwIbmO3Kpav28zxnzxXIH771B60/nxHtR7zm+78HdFs/hcFdpHzJva9FrZkEMKksTxAF3upDVY7sFizz4q1/kr8i1KXV7ar100yQBmM29S1K2OktjCZwoK3Wjk12XzEuJuTWeERqIlT0Zwz3pZ9k/YJhq86StBAKG7Kj3Yb+xU2Dw80+Yt/DxK6Rp5rR7gT9u1VyxcBc+w6Gq+HK/GINWvPDUbnzyT15ATkWulwKmZHYnY61IMWliUMf+WUGA2tRF77mGnerp4o8LmsobmYnCEYguvIw4174cMbtfBMm8rCMxq+EwXWlTEm6TUvMe6VIwkErxAMeDAr67XL1BQfcpLdNg0XWlMg4rMIs01oNHd6NYEoIkt+50S2OEGaN1gw4oLl3KQjDp2J/aCnU+FGF6HbkLeYZRIq/vPA4qAI074ckcLM1BA5mLq5HBS9uvg1RzJBhn0IhJdc8e+Lta0wyKlZSUi38LBdD/0/KvLOQInwFxylEmhPXXlQlIsA/52Mpi/piYarkmB6lisPEZFUqxXWemd8So0rPcOgzlzAuh2yPoaoia7tRAPuo37/zwvaPQIRkbhJfn5bqTIMkhAQEglC42dCkEt7/tyGS36o1qxAmM7b24IP5yx63PdiL0sAOr0n32tVleN+Fa54Y5tt7jES
 F4JgmSMg
 MAO6RUMQtYLb4s5IAHboXmtilW+6vCJQOP7Lc3DBdBoRbYGyHVAfI2iiGhywxBy5KxzTjlAwV16L+P62c0Qnmo3WdYh3XgJ+zHC/fzYfAXrG++B0hLqVWeQwcXaziwQ845dUwI/1SZU0bfc+5Id/6OVQZrfzUxFbKekCnrzRUUwQ5TR0X/AZQHa9SUCQt6QJSWN+E+tzoEO4pIulbxpjV8ZxMmhqTn+/nn3SXr6OHMj/00UhDDJ/HyXKIOsfZo7K5ebN60oXBZHEirBxtQ4OEEfUaqq8yDSHiEjoj9iUe7/3sxgB0zS4CcNu7+6++KM5znOnYWy927XgDu/BdBaMzdL+spKwj7vZWMZKDdx8j3E7JyIAF/Tv7r+x5sP02L1563vsmKOBiAKWLtTV9lv1xNSm7DItzzrWwsJbd9yqixtTlAbzs/LiJWd35chAajIxhnxlF6H52DnGaoSI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Bingfang Guo <bingfangguo@tencent.com>

This is a preparatory work for unbinding memcgid from memcg. No
functional change.

The swap charging path currently drops its RCU read lock after acquiring
a private ID reference. This is safe because the ID reference pins the
memcg's CSS.  After ID references are moved to pin objcgs, that lifetime
guarantee will no longer hold.

Keep the RCU read lock held while accessing the memcg for counter
charging, statistics and failure handling. (This matches what
__memcg1_swapout() already does).  Save the private ID for swap memcg
recording before dropping the RCU read lock. So the swap cluster locking
remains outside the RCU read-side critical section.

Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
---
 mm/memcontrol.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 791e536efaebe..981a231a76129 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5954,6 +5954,7 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	struct page_counter *counter;
 	struct mem_cgroup *memcg;
 	struct obj_cgroup *objcg;
+	unsigned short private_id;
 
 	if (do_memsw_account())
 		return 0;
@@ -5963,30 +5964,29 @@ int __mem_cgroup_try_charge_swap(struct folio *folio)
 	if (!objcg)
 		return 0;
 
-	rcu_read_lock();
-	memcg = obj_cgroup_memcg(objcg);
-	if (!folio_test_swapcache(folio)) {
-		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		rcu_read_unlock();
-		return 0;
-	}
+	scoped_guard(rcu) {
+		memcg = obj_cgroup_memcg(objcg);
+		if (!folio_test_swapcache(folio)) {
+			memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
+			return 0;
+		}
 
-	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
-	/* memcg is pined by memcg ID. */
-	rcu_read_unlock();
+		memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
+		/* memcg is pined by memcg ID. */
+		private_id = mem_cgroup_private_id(memcg);
 
-	if (!mem_cgroup_is_root(memcg) &&
-	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
-		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
-		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_private_id_put(memcg, nr_pages);
-		return -ENOMEM;
+		if (!mem_cgroup_is_root(memcg) &&
+		    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
+			memcg_memory_event(memcg, MEMCG_SWAP_MAX);
+			memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
+			mem_cgroup_private_id_put(memcg, nr_pages);
+			return -ENOMEM;
+		}
+		mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 	}
-	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
 	ci = swap_cluster_get_and_lock(folio);
-	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages,
-			  mem_cgroup_private_id(memcg));
+	__swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages, private_id);
 	swap_cluster_unlock(ci);
 
 	return 0;

-- 
2.43.7



