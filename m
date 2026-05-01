Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F50FCD3427
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 551B26B00B2; Fri,  1 May 2026 17:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51FB56B00B4; Fri,  1 May 2026 17:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 373AF6B00B3; Fri,  1 May 2026 17:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 275246B00AF
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8B698A6B2
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:22 +0000 (UTC)
X-FDA: 84720079164.08.3E08985
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C507A1C0018
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C03jirgi;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669460;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q7WZhgmECBR04MyEd8E6c3towWg49ZYQYSwYzRcDZJE=;
	b=Nm3cJ2d8ot+Tsl8vhdwep3/h236e25I6gWY110A7XR+l+asxjssyVOgY7GY2HLRjC8Xvdo
	WbqRvqlzlP39YKFRUuZTOa7MGfmxemsgGs2rednDCRndSJ4g050wrtRmHvu71CRWc91ot8
	JFzQwcjzrNI2etvlNo7nefICZf3Tm+Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C03jirgi;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669460; a=rsa-sha256;
	cv=none;
	b=uKwRBAstalgYtMftlahJy6GX1otlwiH94alKO7QkPaFQa6gqFrC64jml25OAzaE2omm7aP
	3YLymHUsvMrXSxfdf4TwatzCpSASuuWxVMw6iEy2vfMZO7PMwUkmeDxupXJw9seuOj7BpA
	sx2Bf/3Z4iA13IHw03oJjXqm0BEmNQ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F6A14458E;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40056C2BCC4;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669454;
	bh=iJExWTQRPkiwcYj7KBz1453v6H0elkPygOR5Ae/2kfg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=C03jirginn7K28FqB0HDkVVvV1f+S0NqIZLWLYIXy24kD/B1Y+oxUepgM0HeS0uTf
	 1JA74vEc3bZZeaN2Ajac6Ra9siO9/v+fsxahelnX9SLYyrF2u5eSkD0x2GQqcjcdNV
	 uQN06rDp98RCK0xgD47RnEvkkmMag7ecp8y04ygwAqGLOfEufyHrh+k1fOjEyUwtnp
	 OXxeFb1faKjven7+/FmtcAckVSc0noL953cG7Ev2c8wZ8aq6FvAf3aD4F1zRc4noKU
	 fqa4bGpZ86k75m+llHYDr54XInq1ILZmsEO3jV4vLX7hIfIwp1vO2xkKTI/HO0qMh9
	 05tkudkewn54Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36DF7CCFA13;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:04:14 +0800
Subject: [PATCH RFC 28/32] mm/workingset: split lruvec retrieving and flush
 into a helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-28-913619b014d9@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=8304;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=CannGTZuhdb+chYR/x/lEwpMQkSHEkSpZfE0GVG1Xvg=;
 b=oXBiImfpMiql1tAMBZqHjNGBH+90Hveu3ZZG7nw1NvBuBrivKpGFuLylAq0UHD0SBKaV/+h7T
 khWYi0AglAVD1r4EUq/bDzIigkek7M7F7l5+pz4g9OXg6Qjj0Zb0PwG
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: C507A1C0018
X-Rspamd-Server: rspam06
X-Stat-Signature: cgewa161n5dicba3n8kdcx9mscc7gxdb
X-HE-Tag: 1777669460-82618
X-HE-Meta: U2FsdGVkX188rcSzAwtJIjACbeJU0BCsyyORDOqYVEaJ8jmqTN3V5+ZfS+Bt6tv7/0xNv5+zlExp9ydyr/HNH1h97PWMN3LBIVwQSv4KuVndUJK3I/hxcFQ1UbW+hmaM5X4pVwG3ziXPYRkJySwN3yR/5E9GjBZ8cUzdut6427t8EeMp888AeumbnzGS1FPlr6gvSmc6XUx3sLS2DRgxda5DeL2TawLmrv4ZYqulnda94Ys+BfLRDaXSlT8sroy2Zf79PN4LbYxI7isN+T4oaWSZrLz7pSXeXa7KoFL/FO3Tr+JTPK7AKLzxomVFQbU1XsmEfzLJHOpRYTHFn4QcxBgnHNpP3iauMJ9ZOG4kqCKEt/3cmQPNxstZ/JDdG7xHHHDo/FkRZkYQPs5HbtIKI4vcXtawkrXSfd4OvlD3G3t+S5kAu1drsaXeev92y7FrbTFnXYusoxjdijoXQ6Isr1FmzE3oX2xjy4rVyZXCBBkIF1FPKdQEO115KidvbQIlsQahtWmgw6FHHEB6hVFR7bobjOMjTTaGhfNowJKug6GlbCt7OoBNVN6rtTPFIwiu/h4BCojloxAGBJ/ftLFCOF/7YDDwDPYbgbqfhSR6w9H8YemMo/H1MiAD8sYwqNsHBmRNdKsJkQNdaqj/SwBAklicOeGI1tllKV4HgMwhxmdiTGKonBL15/Lchs0UcbpVjTuk8yRHmFGWc55NagLzmlZA1gbvxrHE/srjiGowN/chiRLRRbCEkA4uxYCCucIjp1h2CsUviCSKO2tZJczblIdTSAab82BW2W14fXM9sFyd8r98aHQf+Op1FfBDCA2zGWJn4i3ebomOR/sG9zcR7TVxfe2Hilw0SKvaCH68++AhshK3q8nlztn8weipn1CT+INB8pZUFAqVa+rVAvXhN5pW0+62esdbZ3lYa1HIufOwILf04rGLbyE4Fu4i3ee8oVqrfVCNpiRKtaRnARj
 euuJ4QHv
 rBOtklrAWwW3f2V8CfkZGA4TLcAEokQ7jxg3iLk+gGrHll1bnf96lXrtBQmV3KxQKszG4i+9ikhkzw4ITIJRzQdowMHoTiUTGPFSJmnp458B5f2YKilrh8vhmyf1klG4JF6VlpbMAX8sPSTtJI5eyiISg7NM/jmL0qCffLonMb2em5bEsSBzD8thcO1PIch7Z1eBmEK0/i19WPKmtZNlBvXN4gilScO/cwxwPVZgVtZLHXTAARkz7wvO5JgveFrFZ4yn4/97u1kOUuPnpFrImay1MD7HpX+kkqRUr9CfJlcKwbsymSnOln2JD11uHZ7t2ZpM3o5p5VSQb4Jy28fpiTVNBqrlyo0i9LmdLuyqyv91vuh1xXxT7m/lygg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Soon MGLRU will share the common routine for refault distance checking,
so make a few helpers for that. No feature change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/workingset.c | 189 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 98 insertions(+), 91 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index e756b0cc14b5..5c52dd835a92 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -261,6 +261,60 @@ static void unpack_shadow(void *shadow, int *memcgidp, pg_data_t **pgdat,
 	*workingsetp = workingset;
 }
 
+static struct lruvec *try_unpack_get_lruvec(void *shadow,
+					    unsigned long *eviction,
+					    bool *workingset, bool flush)
+{
+	int memcgid;
+	struct mem_cgroup *memcg;
+	struct pglist_data *pgdat;
+
+	unpack_shadow(shadow, &memcgid, &pgdat, eviction, workingset);
+
+	/*
+	 * Look up the memcg associated with the stored ID. It might
+	 * have been deleted since the folio's eviction.
+	 *
+	 * Note that in rare events the ID could have been recycled
+	 * for a new cgroup that refaults a shared folio. This is
+	 * impossible to tell from the available data. However, this
+	 * should be a rare and limited disturbance, and activations
+	 * are always speculative anyway. Ultimately, it's the aging
+	 * algorithm's job to shake out the minimum access frequency
+	 * for the active cache.
+	 *
+	 * XXX: On !CONFIG_MEMCG, this will always return NULL; it
+	 * would be better if the root_mem_cgroup existed in all
+	 * configurations instead.
+	 */
+	rcu_read_lock();
+	memcg = mem_cgroup_from_private_id(memcgid);
+	if (!mem_cgroup_tryget(memcg))
+		memcg = NULL;
+	rcu_read_unlock();
+
+	if (!mem_cgroup_disabled() && !memcg)
+		return NULL;
+
+	/*
+	 * Flush stats (and potentially sleep) outside the RCU read section.
+	 * XXX: With per-memcg flushing and thresholding, is ratelimiting
+	 * still needed here?
+	 */
+	if (memcg && flush)
+		mem_cgroup_flush_stats_ratelimited(memcg);
+
+	return mem_cgroup_lruvec(memcg, pgdat);
+}
+
+static void put_lruvec(struct lruvec *lruvec)
+{
+	if (mem_cgroup_disabled())
+		return;
+
+	mem_cgroup_put(lruvec_memcg(lruvec));
+}
+
 /**
  * lru_eviction - notifies eviction of an folio on an lruvec
  * @lruvec: the lruvec the folio belongs to
@@ -383,30 +437,25 @@ static bool lru_gen_test_recent(struct lruvec *lruvec,
 static void lru_gen_refault(struct folio *folio, void *shadow)
 {
 	bool recent;
-	int memcg_id;
 	int hist, tier, refs;
 	bool workingset;
 	unsigned long token;
 	struct lruvec *lruvec;
-	struct mem_cgroup *memcg;
-	struct pglist_data *pgdat;
 	struct lru_gen_folio *lrugen;
 	int type = folio_is_file_lru(folio);
 	int delta = folio_nr_pages(folio);
 
-	unpack_shadow(shadow, &memcg_id, &pgdat, &token, &workingset);
-
-	rcu_read_lock();
-	memcg = mem_cgroup_from_private_id(memcg_id);
-	lruvec = mem_cgroup_lruvec(memcg, pgdat);
+	lruvec = try_unpack_get_lruvec(shadow, &token, &workingset, false);
+	if (!lruvec)
+		return;
 	if (lruvec != folio_lruvec(folio))
-		goto unlock;
+		goto out_put;
 
 	recent = lru_gen_test_recent(lruvec, token, type);
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + type, delta);
 
 	if (!recent)
-		goto unlock;
+		goto out_put;
 
 	lrugen = &lruvec->lrugen;
 
@@ -424,8 +473,8 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 		folio_set_lru_refs(folio, refs);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, delta);
 	}
-unlock:
-	rcu_read_unlock();
+out_put:
+	put_lruvec(lruvec);
 }
 
 #else /* !CONFIG_LRU_GEN */
@@ -494,91 +543,49 @@ void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
  * Return: true if the shadow is for a recently evicted folio; false otherwise.
  */
 bool workingset_test_recent(void *shadow, bool file, bool *workingset,
-				bool flush)
+			    bool flush)
 {
-	unsigned long distance, active, inactive;
-	struct mem_cgroup *eviction_memcg;
-	struct lruvec *eviction_lruvec;
-	struct pglist_data *pgdat;
+	struct lruvec *lruvec;
 	unsigned long eviction;
-	int memcgid;
-
-	rcu_read_lock();
-	unpack_shadow(shadow, &memcgid, &pgdat, &eviction, workingset);
-
-	/*
-	 * Look up the memcg associated with the stored ID. It might
-	 * have been deleted since the folio's eviction.
-	 *
-	 * Note that in rare events the ID could have been recycled
-	 * for a new cgroup that refaults a shared folio. This is
-	 * impossible to tell from the available data. However, this
-	 * should be a rare and limited disturbance, and activations
-	 * are always speculative anyway. Ultimately, it's the aging
-	 * algorithm's job to shake out the minimum access frequency
-	 * for the active cache.
-	 *
-	 * XXX: On !CONFIG_MEMCG, this will always return NULL; it
-	 * would be better if the root_mem_cgroup existed in all
-	 * configurations instead.
-	 */
-	eviction_memcg = mem_cgroup_from_private_id(memcgid);
-	if (!mem_cgroup_tryget(eviction_memcg))
-		eviction_memcg = NULL;
-	rcu_read_unlock();
-
-	if (!mem_cgroup_disabled() && !eviction_memcg)
-		return false;
-
-	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
+	unsigned long active, inactive;
+	unsigned long distance;
+	bool recent;
 
 	if (lru_gen_enabled()) {
-		bool recent;
-
-		recent = lru_gen_test_recent(eviction_lruvec, eviction, file);
-		mem_cgroup_put(eviction_memcg);
-		return recent;
-	}
-
-	/*
-	 * Flush stats (and potentially sleep) outside the RCU read section.
-	 *
-	 * Note that workingset_test_recent() itself might be called in RCU read
-	 * section (for e.g, in cachestat) - these callers need to skip flushing
-	 * stats (via the flush argument).
-	 *
-	 * XXX: With per-memcg flushing and thresholding, is ratelimiting
-	 * still needed here?
-	 */
-	if (flush)
-		mem_cgroup_flush_stats_ratelimited(eviction_memcg);
-
-	distance = lru_distance(eviction_lruvec, eviction,
-				file ? LRU_EVICT_BITS : LRU_EVICT_BITS_ANON,
-				bucket_order[file]);
-
-	/*
-	 * Compare the distance to the existing workingset size. We
-	 * don't activate pages that couldn't stay resident even if
-	 * all the memory was available to the workingset. Whether
-	 * workingset competition needs to consider anon or not depends
-	 * on having free swap space.
-	 */
-	active = lruvec_page_state(eviction_lruvec, NR_ACTIVE_FILE);
-	inactive = lruvec_page_state(eviction_lruvec, NR_INACTIVE_FILE);
-
-	if (mem_cgroup_get_nr_swap_pages(eviction_memcg) > 0) {
-		active += lruvec_page_state(eviction_lruvec, NR_ACTIVE_ANON);
-		inactive += lruvec_page_state(eviction_lruvec, NR_INACTIVE_ANON);
+		lruvec = try_unpack_get_lruvec(shadow, &eviction, workingset, false);
+		if (!lruvec)
+			return false;
+		recent = lru_gen_test_recent(lruvec, eviction, file);
+	} else {
+		lruvec = try_unpack_get_lruvec(shadow, &eviction, workingset, flush);
+		if (!lruvec)
+			return false;
+		distance = lru_distance(lruvec, eviction,
+					file ? LRU_EVICT_BITS : LRU_EVICT_BITS_ANON,
+					bucket_order[file]);
+		/*
+		 * Compare the distance to the existing workingset size. We
+		 * don't activate pages that couldn't stay resident even if
+		 * all the memory was available to the workingset. Whether
+		 * workingset competition needs to consider anon or not depends
+		 * on having free swap space.
+		 */
+		active = lruvec_page_state(lruvec, NR_ACTIVE_FILE);
+		inactive = lruvec_page_state(lruvec, NR_INACTIVE_FILE);
+		if (mem_cgroup_get_nr_swap_pages(lruvec_memcg(lruvec)) > 0) {
+			active += lruvec_page_state(lruvec, NR_ACTIVE_ANON);
+			inactive += lruvec_page_state(lruvec, NR_INACTIVE_ANON);
+		}
+		/*
+		 * Be cautious about challenging the existing active working
+		 * set; sacrificing the inactive part of the opposite type
+		 * should be safe.
+		 */
+		recent = distance <= (active + inactive) / 2;
 	}
 
-	mem_cgroup_put(eviction_memcg);
-
-	/*
-	 * Be cautious about challenging the existing active working set;
-	 * sacrificing the inactive part of the opposite type should be safe.
-	 */
-	return distance <= (active + inactive) / 2;
+	put_lruvec(lruvec);
+	return recent;
 }
 
 /**

-- 
2.54.0



