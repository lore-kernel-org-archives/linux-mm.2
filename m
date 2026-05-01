Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3324CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BC8C6B0093; Fri,  1 May 2026 17:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56ED16B009B; Fri,  1 May 2026 17:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BF196B0099; Fri,  1 May 2026 17:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 211526B0095
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E1B1F1A02B9
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:16 +0000 (UTC)
X-FDA: 84720078912.23.2EDBD36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 050184000E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mA6Rfsig;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669455; a=rsa-sha256;
	cv=none;
	b=de+dYiw3G5/SCEXKuqAcldxjS7cxhfkOWEGCWaIgGK/kPnYoFfW4xa8S2L8mTAb1g3bh3+
	L5uoxdqvenpAVOZHwCXm5yFWI1hdhznhO34b0GBWXZx2T6tS7XAKTmdUmz4yQAoaGW3ZVp
	Hsxdj6WU148SEQ8OgXgSHbpg7+8yKrc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mA6Rfsig;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669455;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUmSm0pfDv8drj8IEK4f1znVXSSdQypQLW/Hp/hmUbc=;
	b=m1CVq8aHTjpMJTPmoWfroNW1IcKqqZ99IJRsOQupV81H1DGx68+v2Ljp3fKah0nUEYbazG
	PYe8XH4+/Pf4A/qmc4XuqJglsv32DdcjsOW2kiHzpNX0HsKZnDmE9KOdjqn1pbMLDI4g/c
	J1yRITzpL1lnsV1ZUlSwY2Zy5zkT8m0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7891460142;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B62DC2BCB4;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669454;
	bh=EZl06XMXdG5hHyjUR1NFTv/KzrDGXtu69mN8a47gXHc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=mA6Rfsig+XZYNj7U/Zy2ZXvj1j3kRtHYm3zR+THVmyImSOxOlZb3zsOFC5OEh8zM+
	 Nch/I4+D6ug9K0m5kVNEoG96iNJDyUZG9PjJGWM72F6gLG8848hPP0byDeRYOwpRVb
	 6azUYxUx1/MqnUg9bIYgOQwLZell8kR0YlR3U1eYDxobAaBnb+PinMofGCObwz2APp
	 Rt8ppNlxzlh9opLmOtrAaKXfKx3MaT3hP7iSb9LC6hxlXcHS4Bdq9+kaDQmuyaedt+
	 cMc8WCriDX0N8DVeE98tCUQ2x7xBO4dr0E1G05Tt3pv7ZrAQWI09auVzbFTzXziljx
	 jsRa3PkYCOC0A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2347FCD342C;
	Fri,  1 May 2026 21:04:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:04:13 +0800
Subject: [PATCH RFC 27/32] mm/workingset: move refault distance checking
 into a helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-27-913619b014d9@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=7913;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=bwYzIJmY3Hqa83k+2m4zOivhjtGZdKIukV17N5RFO4g=;
 b=406q4TDrkyFVDQ5IMpGCHCP44WNYxwuZQGPzaniAOeZA2dwckbGSgUqvgkWv/KqqeqF9PROsP
 Cb4l7vx1BkkC9r/wmxg3Sx2QxppoNWXmWgFDYcIRETQ5+fcG45eU5gT
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: yi1kuf8okq6unbb5di5mtai97tngecfq
X-Rspam-User: 
X-Rspamd-Queue-Id: 050184000E
X-Rspamd-Server: rspam07
X-HE-Tag: 1777669454-758482
X-HE-Meta: U2FsdGVkX1+RiXU0vW6Uuuoe6NtZwqCFJ+C61lJLHIZ3JWXZUW18fIvsgEF51rWRjdn3+rr1xdw269Sh244CA3IUxn9LfYGHpjHm6O3tyLr90n2IU12Jz/bkCubvp3jj37Ob5xaQ97j3tOjkwcj7+VNWPFhR7VRvZQshkRJcBHovxDT/sjvScr6kA6KnzgeCWnnTNULTS8Nvka2Ec4JyABJISQR90h6+khzzn7LejCWZYxms8aZS5LRMJMTXLgEYOmYdm1Bb36R2Khj/AzFHa7UEPEeIXJYegKNNai1xnqH/NWP6GxNOSq4hkOS6l9jS6JYEwK1MPAIElqqLjzgAjaOSdPqr6WgkWsrCZHHX6PffaetIRJgqm2NskDwMJ1nWPjgI5DpJqsBwgwxRgzSnXCo6bk8lks9vMiR0S2yqGQetGwqFUQkOcSkEgXS77udhcHW8g3lugk7eO/TCxXpn4fna6Ol+nd3PV2wdJNK8qVqrZLxZm4EskKeo0q65jVFMpl7X8oRLB7Eci1G0HeYiX81biDt3OXoh9u3wAUWnHvC0hz53H46vFD6O2QXvvxAoxUp+KriAw2LQEak5Ck6ykH/nHxsBMvfRPkzhwE6leBtP7yUsHjjAnvhbAdYAs+CuaHDj981Lge009Hg+8Zs97/SNDB2zgc7F804Klpu9XtO22Iwaff5Y0gwDoQHjWpwWVLo2RB6cgkvHI8XLixR0QZomf0xJSmbaoY9TdEN7bvQ65B4Z09IY17Vcj7AE0Mm4XOfvvuL40mI0UWYGjoNudgeGP0zgM8zRszyniOpzxU4ODwFMQDF49zsRUUH4O7F6Ob3r7A1g0Q1ACqkH8fBdMprSEors6lFplM/eN3Tdgh0Wq5+kcW86AtQwVbIYJmJ4tzwwsThSrhMg2fqZTH6rmAef2DBIJEW3lJ4BMM6GOui6dhwrY23pAhXj0BaAtTUz6TkdHmWtHrgoHXs2R8P
 SJHBoTb+
 hayIvYtHgSJH07fI9GLXOAlvcqOmokKD7tKEQaumbtPZuwIVywaBCItEKcOn9yn7zbEg1ZW8ktcBsxd8Psf6Al0DahnqDNIjidT8ySGpgRS+jUlB7sgnYVVpyurKX6SJ012uXsSEFf5Iu5khn0Ba/g4csa9cRJP08TjhL9j5IbdTY0cHzZHNIixc4nKmFC9jBmf3U1KPnsw0I2sm0tnWpBivti0A0yGs2CdXwI8XMYhez4sPyuswqe2kl5zl/z7ivoue8w0JALRyFhDCkc/6fphn4LieVyFcfRSfo2tNBdR9YgOI2wPAeh6kzwYkluchRRho/ZZvVWq2+m8644S+ltJ5dGVZDmMjMi/vrcXT1NJ665tRXDs0Z4eHINw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

There isn't any feature change, just move the refault distance checking
logic into a standalone helper so it can be reused later.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/workingset.c | 136 ++++++++++++++++++++++++++++++++------------------------
 1 file changed, 78 insertions(+), 58 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 622e00ac28b6..e756b0cc14b5 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -234,9 +234,6 @@ static unsigned int bucket_order[ANON_AND_FILE] __read_mostly;
 static void *pack_shadow(int memcgid, pg_data_t *pgdat, unsigned long eviction,
 			 bool workingset, bool file)
 {
-	BUILD_BUG_ON(LRU_EVICT_BITS_ANON <= SWAP_COUNT_SHIFT);
-
-	eviction &= BIT(file ? LRU_EVICT_BITS : LRU_EVICT_BITS_ANON) - 1;
 	eviction = (eviction << MEM_CGROUP_ID_SHIFT) | memcgid;
 	eviction = (eviction << NODES_SHIFT) | pgdat->node_id;
 	eviction = (eviction << WORKINGSET_SHIFT) | workingset;
@@ -264,6 +261,77 @@ static void unpack_shadow(void *shadow, int *memcgidp, pg_data_t **pgdat,
 	*workingsetp = workingset;
 }
 
+/**
+ * lru_eviction - notifies eviction of an folio on an lruvec
+ * @lruvec: the lruvec the folio belongs to
+ * @nr_pages: size of the folio
+ *
+ * As in-memory folio is evicted, increase the eviction counter on
+ * the LRU and return its current reading.
+ */
+static inline unsigned long lru_eviction(struct lruvec *lruvec, int nr_pages,
+					 int bits, int bucket_order)
+{
+	unsigned long eviction;
+
+	/*
+	 * Reclaiming a cgroup means reclaiming all its children in a
+	 * round-robin fashion. That means that each cgroup has an LRU
+	 * order that is composed of the LRU orders of its child
+	 * cgroups; and every page has an LRU position not just in the
+	 * cgroup that owns it, but in all of that group's ancestors.
+	 *
+	 * So when the physical inactive list of a leaf cgroup ages,
+	 * the virtual inactive lists of all its parents, including
+	 * the root cgroup's, age as well.
+	 */
+	BUILD_BUG_ON(LRU_EVICT_BITS_ANON <= SWAP_COUNT_SHIFT);
+	eviction = atomic_long_fetch_add_relaxed(nr_pages, &lruvec->evictions);
+	while ((lruvec = parent_lruvec(lruvec)))
+		atomic_long_add(nr_pages, &lruvec->evictions);
+
+	/* Truncate the timestamp to fit in limited bits */
+	eviction >>= bucket_order;
+	eviction &= (BIT(bits) - 1);
+	return eviction;
+}
+
+/**
+ * lru_distance - calculate the refault distance of a refaulted folio
+ * @lruvec: the lruvec the folio belongs to before eviction
+ * @eviction: eviction timestamp recorded in the shadow
+ * @bits: number of bits used to encode the timestamp
+ * @bucket_order: bucket order used to truncate the timestamp
+ *
+ * Read the lruvec's current eviction counter and return the refault
+ * distance.
+ */
+static inline unsigned long lru_distance(struct lruvec *lruvec,
+					 unsigned long eviction,
+					 int bits, int bucket_order)
+{
+	unsigned long refault;
+
+	eviction <<= bucket_order;
+	refault = atomic_long_read(&lruvec->evictions);
+
+	/*
+	 * The unsigned subtraction here gives an accurate distance
+	 * across evictions overflows in most cases. There is a
+	 * special case: usually, shadow entries have a short lifetime
+	 * and are either refaulted or reclaimed along with the inode
+	 * before they get too old.  But it is not impossible for the
+	 * evictions to lap a shadow entry in the field, which
+	 * can then result in a false small refault distance, leading
+	 * to a false activation should this old entry actually
+	 * refault again.  However, earlier kernels used to deactivate
+	 * unconditionally with *every* reclaim invocation for the
+	 * longest time, so the occasional inappropriate activation
+	 * leading to pressure on the active list is not a problem.
+	 */
+	return (refault - eviction) & (BIT(bits) - 1);
+}
+
 #ifdef CONFIG_LRU_GEN
 
 static void *lru_gen_eviction(struct folio *folio)
@@ -379,37 +447,6 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 
 #endif /* CONFIG_LRU_GEN */
 
-/**
- * workingset_age_nonresident - age non-resident entries as LRU ages
- * @lruvec: the lruvec that was aged
- * @nr_pages: the number of pages to count
- *
- * As in-memory pages are aged, non-resident pages need to be aged as
- * well, in order for the refault distances later on to be comparable
- * to the in-memory dimensions. This function allows reclaim and LRU
- * operations to drive the non-resident aging along in parallel.
- */
-static long workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages)
-{
-	unsigned long eviction;
-
-	/*
-	 * Reclaiming a cgroup means reclaiming all its children in a
-	 * round-robin fashion. That means that each cgroup has an LRU
-	 * order that is composed of the LRU orders of its child
-	 * cgroups; and every page has an LRU position not just in the
-	 * cgroup that owns it, but in all of that group's ancestors.
-	 *
-	 * So when the physical inactive list of a leaf cgroup ages,
-	 * the virtual inactive lists of all its parents, including
-	 * the root cgroup's, age as well.
-	 */
-	eviction = atomic_long_fetch_add_relaxed(nr_pages, &lruvec->evictions);
-	while ((lruvec = parent_lruvec(lruvec)))
-		atomic_long_add(nr_pages, &lruvec->evictions);
-	return eviction;
-}
-
 /**
  * workingset_eviction - note the eviction of a folio from memory
  * @target_memcg: the cgroup that is causing the reclaim
@@ -437,8 +474,9 @@ void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 	lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
 	/* XXX: target_memcg can be NULL, go through lruvec */
 	memcgid = mem_cgroup_private_id(lruvec_memcg(lruvec));
-	eviction = workingset_age_nonresident(lruvec, folio_nr_pages(folio));
-	eviction >>= bucket_order[file];
+	eviction = lru_eviction(lruvec, folio_nr_pages(folio),
+				file ? LRU_EVICT_BITS : LRU_EVICT_BITS_ANON,
+				bucket_order[file]);
 	return pack_shadow(memcgid, pgdat, eviction,
 			   folio_is_workingset(folio), file);
 }
@@ -458,7 +496,7 @@ void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 				bool flush)
 {
-	unsigned long refault, distance, active, inactive;
+	unsigned long distance, active, inactive;
 	struct mem_cgroup *eviction_memcg;
 	struct lruvec *eviction_lruvec;
 	struct pglist_data *pgdat;
@@ -515,27 +553,9 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	if (flush)
 		mem_cgroup_flush_stats_ratelimited(eviction_memcg);
 
-	refault = atomic_long_read(&eviction_lruvec->evictions);
-
-	/*
-	 * Calculate the refault distance
-	 *
-	 * The unsigned subtraction here gives an accurate distance
-	 * across evictions overflows in most cases. There is a
-	 * special case: usually, shadow entries have a short lifetime
-	 * and are either refaulted or reclaimed along with the inode
-	 * before they get too old.  But it is not impossible for the
-	 * evictions to lap a shadow entry in the field, which
-	 * can then result in a false small refault distance, leading
-	 * to a false activation should this old entry actually
-	 * refault again.  However, earlier kernels used to deactivate
-	 * unconditionally with *every* reclaim invocation for the
-	 * longest time, so the occasional inappropriate activation
-	 * leading to pressure on the active list is not a problem.
-	 */
-	eviction <<= bucket_order[file];
-	distance = ((refault - eviction) &
-		    (BIT(file ? LRU_EVICT_BITS : LRU_EVICT_BITS_ANON) - 1));
+	distance = lru_distance(eviction_lruvec, eviction,
+				file ? LRU_EVICT_BITS : LRU_EVICT_BITS_ANON,
+				bucket_order[file]);
 
 	/*
 	 * Compare the distance to the existing workingset size. We

-- 
2.54.0



