Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2B3FCD3427
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:05:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91C0F6B00AD; Fri,  1 May 2026 17:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82A666B00AF; Fri,  1 May 2026 17:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CDD36B00AF; Fri,  1 May 2026 17:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 552A06B00B1
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F363C1442
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:22 +0000 (UTC)
X-FDA: 84720079164.22.8ABCCB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0C567180004
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pZZ+MemW;
	spf=pass (imf24.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669460;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fB5vu0MAXl7KvWfbWUIkX0psT1jRLtwB6GuDhSUzTVE=;
	b=M5tAtnVhBRDbjiW8QCujEAIgy5TihbER2WqUUUPWi0ljNJ/3u2YoU5QU/pOKOnATN0HCeF
	qautkhEqYFOcfsLLu/r0Mbb4CLS3HlDofGdxIIeyrpY5DACOqUDbBtZ++d5+EATXBEOqpS
	k4HNDqckfemdJi9V4RoyaeD2w/I9DLk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pZZ+MemW;
	spf=pass (imf24.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669460; a=rsa-sha256;
	cv=none;
	b=mXgatFFC0ltAY2Xk4cCfR218vbaj4jdiX3Pq9dOy3pwGPzRiGD+CLkHzR6sPTAGpMkiI1z
	j8yoJIuwfdXJh4RMUqKkMhJ2Z2z5L3flqbx5nR2ni/kS5SFgE9O7ks7nYN68Eo1143GylS
	OD5PB8j2oYbqwb+1ZFdOIAa9fa9erQs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 22F1544480;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04843C2BCC6;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669454;
	bh=uio2f/d9kySlX7LZuVl0j2Zqx+2SWezHKqCvlhfuxeg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=pZZ+MemWp7rO7SJpDU+K2Imd3EW8rsVfuJEprxVxlr87evIL0C4rbqq/11Z1X1Eem
	 dr4mmiokiixCklaUe4wYF7mwaQxqmgQTfsJe1kRgOq81x78w7plA48Zx01QeOvyHgm
	 1WYqq5U91iAJAVqtuMxaloNHJoNH+hvVqvgOqxFNESM6R8QRoPHMbprSUTo69t9w7Z
	 JDQL/EvPRRF6cHK64crd7zcPJaL6BLlZxv3UeX0uXm3svENW4MF6A06vD/UfQGJtPs
	 HK26S3wVwWjxMJnyOzvU7txHRRHHjrAkBDopJK6YzzjnlvYNZ3uThxBdU97M41btWX
	 24mGajt82/uwg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFB3BCCFA13;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:04:11 +0800
Subject: [PATCH RFC 25/32] mm/workingset, lru_gen: simplify lru_gen recent
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-25-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=4396;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=KbFTzFXmhJEXcTUabj/0KGmAdVaMVZsImEKHZnTCyNA=;
 b=RZb8GTAX1xI9h34O7aHTxF8zmM5P2cs1w7khJykb58iQUXdSl8fVGbsw1OfZz9Bg07EHTDjJK
 Yd9ndllnZ4bBx8uRFgZBRXfjzVFN8DheBQywHs+6Y1ygX8I9k5cFIlo
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: qkhyioz18nrfqwytkhn6easngm7k5dim
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0C567180004
X-Rspam-User: 
X-HE-Tag: 1777669459-666362
X-HE-Meta: U2FsdGVkX190Av8KMoA09u7EcE0xmzasJd5owod/KIcs3AGa/UOE7uZofIIScY0nZlpjpRMhQDhY6Z6ow8C9AM0uyoAVBkrH9Wc8MGonZN6mFAOr98SNAu5+qj4xtZE30+ltLzycXRq29x6HTDOQUs5YL9xR+jtsOqx3CotbPcCFQFbSyK4dZ480wZdUrrMKmx4F9KYfvSLPX2JWAFWlQoUA/muGZ2cOc03wgu6AXHbWKFuf9pt7sjkaCt4UgJ9ywHrhavEhFIKHzCFSdBZy4j0lSeUGBrMvp9dzwNSzREf9+lWGYrEBwYB5EooX7jjnpSKr0NNNWOumdDRDQoI9G44nogkrHfqQFRzxcqqoHg0CFrkuM7jykHEOIpGce6sOJQsxQGT47PxB1F3yP8nxgj4N0PhkW3sSch7SzTWfwejILN9LiOObS6Ge5SmL8ncmsmmcmjBpR1O5d9cN+d7162oVLyUbdw52wAjKw6S2Mpuw1ioTX3LupFRLSOAhLkiDcD0qKeMzpYJc0WAlVTWY6cazc1aKPqxvGHqJsirLsnCJOInN1pCNExaLKOi0PztmuV5FMeXxywLCvB3Soa93wEyFeIiO8fKyAJ29jd+Z4RghPP9VeuyEB76Wsb8XvQZBPtd4PV26/j6qNvfZsIhJFamUck4zsLblB6rgzKKVcPLxp2an1URTJNH7d1wLtXmBr+g3XGExRzdu52GDSUQC05C+bTSHmIZ9o27MQYSJPalf3u3dufjbHsAtuYFvjqOvTsyc6RzUAnBMLDCMlz3b+xBdX6TxlWX95zqN2eO9Wr2z1a3hCl1bB26suzVTAO7MzVc6wO+2GAs5ip8rndCSVUmaAzJc8p9CsCl7HRuKB7htwFiRem9liJCVNMJN9dGuvXt3ChsPomMUBSQnRoN2Z520+lGwO48B6AiCfTKdspZtGYV7tRbiqZvrjE9EL7z6+UPyOa5iiB2JfyP97lr
 vRYBtuHD
 bBSbbBLoaqAPoDlD8I3ysduP1QUxdflYmwds3/GP9EitC8PfCuJnqptWsaa8Ud9VOF3TfdeDadv1ujO9mQfZi5GS3NhbvgH7DUQt0v8VweByX3zt2OYvPcDGr5Xvo5NWm2ARenXyJtrf3pRm4K2FH9ahZnDjvS03zOMs6zTzxoA1H/CryJuEraogmeHNg0pV7iSXTbc1zyHzGL36UE59D2G8rQFJ6FxVfjL4mKEDeXNzSR3EbG0qAeCtpvV8C54c/mXHRqRlh4yFrO3UAoF3zkWMvPW8G1PZPJqkbaZrssHkZaml4njmh5EkuG9EUPjNaJjlzWoJY4dEqbknHNiyl0jspt6im7OkM8LQ669wjYu4z+fAL56gN5r6jjNepnym+9URGMsZ1LsqKiihHUitDjr8Ij3TzZ3sesQNkMIthXkuEsjU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Move the commont part in the common caller. Also let it return early if
the memcg doesn't match.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/workingset.c | 55 ++++++++++++++++++++++++++-----------------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index a77a6c0c3e15..b472ac34943e 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -277,44 +277,41 @@ static void *lru_gen_eviction(struct folio *folio)
 
 /*
  * Tests if the shadow entry is for a folio that was recently evicted.
- * Fills in @lruvec, @token, @workingset with the values unpacked from shadow.
  */
-static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
-				unsigned long *token, bool *workingset, bool file)
+static bool lru_gen_test_recent(struct lruvec *lruvec,
+				unsigned long token, bool file)
 {
-	int memcg_id;
 	unsigned long max_seq;
-	struct mem_cgroup *memcg;
-	struct pglist_data *pgdat;
-
-	unpack_shadow(shadow, &memcg_id, &pgdat, token, workingset);
 
-	memcg = mem_cgroup_from_private_id(memcg_id);
-	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
-
-	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
+	max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
 	max_seq &= (file ? EVICTION_MASK : EVICTION_MASK_ANON) >> LRU_REFS_BITS;
 
-	return abs_diff(max_seq, *token >> LRU_REFS_BITS) < MAX_NR_GENS;
+	return abs_diff(max_seq, token >> LRU_REFS_BITS) < MAX_NR_GENS;
 }
 
 static void lru_gen_refault(struct folio *folio, void *shadow)
 {
 	bool recent;
+	int memcg_id;
 	int hist, tier, refs;
 	bool workingset;
 	unsigned long token;
 	struct lruvec *lruvec;
+	struct mem_cgroup *memcg;
+	struct pglist_data *pgdat;
 	struct lru_gen_folio *lrugen;
 	int type = folio_is_file_lru(folio);
 	int delta = folio_nr_pages(folio);
 
-	rcu_read_lock();
+	unpack_shadow(shadow, &memcg_id, &pgdat, &token, &workingset);
 
-	recent = lru_gen_test_recent(shadow, &lruvec, &token, &workingset, type);
+	rcu_read_lock();
+	memcg = mem_cgroup_from_private_id(memcg_id);
+	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	if (lruvec != folio_lruvec(folio))
 		goto unlock;
 
+	recent = lru_gen_test_recent(lruvec, token, type);
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + type, delta);
 
 	if (!recent)
@@ -347,8 +344,8 @@ static void *lru_gen_eviction(struct folio *folio)
 	return NULL;
 }
 
-static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
-				unsigned long *token, bool *workingset, bool file)
+static bool lru_gen_test_recent(struct lruvec *lruvec,
+				unsigned long token, bool file)
 {
 	return false;
 }
@@ -445,19 +442,8 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	unsigned long eviction;
 	int memcgid;
 
-	if (lru_gen_enabled()) {
-		bool recent;
-
-		rcu_read_lock();
-		recent = lru_gen_test_recent(shadow, &eviction_lruvec, &eviction,
-					     workingset, file);
-		rcu_read_unlock();
-		return recent;
-	}
-
 	rcu_read_lock();
 	unpack_shadow(shadow, &memcgid, &pgdat, &eviction, workingset);
-	eviction <<= bucket_order[file];
 
 	/*
 	 * Look up the memcg associated with the stored ID. It might
@@ -482,6 +468,17 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 
 	if (!mem_cgroup_disabled() && !eviction_memcg)
 		return false;
+
+	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
+
+	if (lru_gen_enabled()) {
+		bool recent;
+
+		recent = lru_gen_test_recent(eviction_lruvec, eviction, file);
+		mem_cgroup_put(eviction_memcg);
+		return recent;
+	}
+
 	/*
 	 * Flush stats (and potentially sleep) outside the RCU read section.
 	 *
@@ -495,7 +492,6 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	if (flush)
 		mem_cgroup_flush_stats_ratelimited(eviction_memcg);
 
-	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
 	refault = atomic_long_read(&eviction_lruvec->evictions);
 
 	/*
@@ -514,6 +510,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 * longest time, so the occasional inappropriate activation
 	 * leading to pressure on the active list is not a problem.
 	 */
+	eviction <<= bucket_order[file];
 	distance = ((refault - eviction) &
 		    (file ? EVICTION_MASK : EVICTION_MASK_ANON));
 

-- 
2.54.0



