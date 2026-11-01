Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8886B606A326
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 16:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tqAXrMaG
Received: by kanga.kvack.org (Postfix)
	id 483386B05B2; Sun,  1 Nov 2026 11:04:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40BCF6B05B3; Sun,  1 Nov 2026 11:04:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FAE66B05B4; Sun,  1 Nov 2026 11:04:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02D346B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 11:04:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50571C09AF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 16:04:38 +0000 (UTC)
X-FDA: 85387023036.06.F8A7AE1
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6241E180005
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 16:04:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=tqAXrMaG;
	spf=pass (imf16.hostedemail.com: domain of maxmuzaf@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=maxmuzaf@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793549076;
	b=whtL44pBjPycjrvHaSFax/lxKhnsw6b4EmjRr+y59Qf/lcynQxZZ1gOghULqTlKQj0TA4G
	+RDRfFx0ku/W85+hT9Cz4nyMnjAp+XbZKOtM9w0z46spONwj/iU1k2EKg6qHxMXUGZomLF
	aE25e/WTVqZ37RjnpaIX86jCbI1yy0M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=tqAXrMaG;
	spf=pass (imf16.hostedemail.com: domain of maxmuzaf@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=maxmuzaf@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793549076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=59AkfJZqg17nYrV8HOTYJbLmwWBLcbXj8cjORtW0eeM=;
	b=7d0G9Nnae5dUtq/UnU/b2wdU5H5SOAdPgY973LYphJnUdviVnmjZEAf2JNR3ewhqHUtB1U
	3m0hpTS/s6CXi4J2n5iZTcTKfjmw+DJa742/lS4nXcfNaevzJI+KgweBcPZ5AoSn4z21Zz
	9eAj3H3e2U1pw20kOWjqgPhlURO5PUI=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c4cac7a7d3cso237739766b.3
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 08:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793549075; x=1794153875; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=59AkfJZqg17nYrV8HOTYJbLmwWBLcbXj8cjORtW0eeM=;
        b=tqAXrMaGLxjhBSHEiketaKYGMe/pUj6FUownoT3g+5mzd3ZMSHAxqxuV9UXkebB0ET
         3r+fGykOHrn38OxeRlwL8p9Ar4CmE8VY3fY6NH7N7Kmf3OxbTNEJsxDP9cVtgDxYKgoo
         l3HiFxZLn09fjfjCZ2+k39SUUEKhcyBQ+8HXsAp8yVWxsJKGNL6afMtDspo6+7xDchL9
         0jh6+Fr6q2Yk+Xj4lICzdKKBGrEKak462h+zSF1eW4x3joomEcB+43Ncpx+PYxuzB7UB
         FyNIQR+c/Hshwva0/ODk5oCNIEc1Yjl+fEVcTmTIljCVl/NChd80QLU8pFqayEVEFl+8
         fQVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793549075; x=1794153875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=59AkfJZqg17nYrV8HOTYJbLmwWBLcbXj8cjORtW0eeM=;
        b=v5AXRnl+oXGbAKCF2VvJ3nJvOdeHF07ii7LFnVIqyqSwl5LSluU0zNUfeS3Rh5ID/o
         R8IIC5z0TBLWprQnFyrln/Tp7qxmIWlntPxVZnxPdwM4ZuFU/9H9gMZGkeHkDHkT+8KQ
         UbHVER/1NIh9wc/VrM7kx6H0rXeul6iy5SpREEa76evJSr7v2zlvxW3gxgfiWAtHFiSR
         uisd2emM+NuBQq7tEKqDbuPEJjb3z8zf1uPcrRi17TorGerMKpXU6An33pe+oEymM/9u
         zG/wp6iEWYbNEl84rov6LFzJnsw8CtWe9k1Slg3nNUGlSOs8G6itcH+RqMz8LBi2TqBK
         /2HQ==
X-Gm-Message-State: AFq9FYIIhprKnsfraWDmJSImupI8sTTsy7ZNnnNb09irvbPeTcHOR2I6
	eqRLjdzJhzJ0PUPFlWb8LoRCOqyTEHUn5qZJ+ClqhFjlKFadvBBr2dPntUtNVOxYznk=
X-Gm-Gg: AYBFou3fuMuet0CgTny3R/iCvo3IPWNUOaVUpA01YBRI2jnu/hAiXPD9aI/gZxUHRej
	URdMFlOBvmc1CPEXQCOqUlzolBhTB1IhlleQzK20FG6l3HopsLt92tteouO58XZRNK1CbLB9ZuQ
	yw7TyGSLWJCAXw9QQVHIO1WVfdSpH8KD2hcabRe6rQBwEAz8lxCkH+sYT+qCT+UTKF6/ohLOJLP
	rVaeqYy5wOqo3Nvh0T5po6x8gDjd8b2wYF5NiKO//MpzEo3k3yXuzAOynkrCWDzyEMU+lKjUeup
	CJ1/SxLrWedgbCG9y/ZuApreXALfzB5fXIHH8wbQARLzOQIVRjuUSu+sXLX3uR1PMdv128f2ARa
	JZrhUVHA4BJ2u98avMD2N92Oo9Axgw4MpkOmzrn3wb0o5NkwvaS8hu08QZgEI/VKvfDvrAU56fx
	99goXYHMEtLQYWmQYbSWK4KaZaVSvvz813sCX7Sw3eoWZRIJOa26F4uQ+FBmho9V4QzdaKYv/+Q
	yDZHzJ80jzeBDvBEiDjxe/UQ5BJNkNc5vUIFUfOloSL5floM4afQapi2kzHzMGKzbAYW8RRkGrz
	IRW3g3ZOwD8DzWeBkyEv/EWNI20fCOFpDurNVaQFs1Eque9rMYhY8drck73XlotkhCIZTK1uinf
	1dGpCkwNVCrO1c16GnFEIO+kiQpZTI5FiwiTJgbc=
X-Received: by 2002:a17:907:7f92:b0:c49:8fa6:f585 with SMTP id a640c23a62f3a-c4ca7ac0085mr639888566b.38.1793549074709;
        Sun, 01 Nov 2026 08:04:34 -0800 (PST)
Received: from localhost.localdomain (dynamic-077-188-130-121.77.188.pool.telefonica.de. [77.188.130.121])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4cabc174c0sm287957166b.8.2026.11.01.08.04.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 01 Nov 2026 08:04:33 -0800 (PST)
From: Maxim Muzafarov <maxmuzaf@gmail.com>
To: linux-mm@kvack.org
Cc: Maxim Muzafarov <maxmuzaf@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Yu Zhao <yuzhao@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/1] mm/mglru: age when the oldest generation is thrashing
Date: Sun,  1 Nov 2026 17:04:27 +0100
Message-ID: <20261101160427.85701-2-maxmuzaf@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261101160427.85701-1-maxmuzaf@gmail.com>
References: <20261101160427.85701-1-maxmuzaf@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pypebrxdt64bcnaeipruwzt9ge4143qh
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6241E180005
X-Rspam-User: 
X-HE-Tag: 1793549076-467919
X-HE-Meta: U2FsdGVkX1+Nq88chRs30Z/l7kDtLaicM09MQksPyLipAyyPx6WfvhtsxCHzK3+H7Mu/e3pq86XF4ZvA9LVdQ+UrYLSw4WYP5MX28yY55E3M2YWfNfRm87BlLUYfHwyBadrzhNVnP5ql7aoGM2wUJC8gK+xg+CK4iF+l/u9d6XAvZzYazlpUdOvb+9Yo0m+PID5D4AKKlfyzphbnFykZ/QY8irrDIZISxtMe7HhNTxpv1NveKCsYD1JZ5BBJHGRjhcYEImgHVa8KdfWT8KIyNFlqjxY6ESsWxfXKR8LmG45G76c6DB5bCxB8NDiwHoskNn78d+fGYJEMXXLioYeM2VDAIaJayOFLwdXMjsqC1cRyu/BYHqIT0lqxx1suIrIHQty2uNPmwzrPxB5ahHxyGBoJxp8cLyr9+kSgllSLzfLwrXJXvUpVO0dtMMN5R1F7D7qTQhcWEYvIlMDQNQ+Qtxaejawqsd4fgxxZ0Tdr39Swoosc4pGPUh/nTXKEP+R1hKYVJep4dutNBH/QACtgHi13RNsOd+9UQPEP81g9cw+KV+824BE60mNPwbleQNqPbzHNVSZP7HowZnhhnOrvOVvRPKR9rDiZxLqYK53TieqC7PrqtUPhhED01oj0x0vPoBFEuxgk8wXbPXrRf2HXBcvm62rfwdeGFc1WNa0ur7MVuPkhMgz4S8UI1x+f8PoaBJvZyoEqJWJ8MQSzMIRg49SgAwXzLJCXoxD4Wh6WqhwckMHcKAl9Ww2el0Ch1CKm8vGCiwaucWkFngKkZv2MiZ8O68rQAlxSmYlKI4IqctjZtIiQpveonLVDH5WktV99GhQjtuZKtDhJPx2nf0e15kNOxdBqDnjIbygERnjBo8GXgRUYMLrku5EAqoRs6r+WpERZfNKi7uq1z7GL+nKIyvZisbkmolKt8Fv2IDwIrsdH/bz8YSWY1eplY0IB8kdQH1uoxdViIyJIuxLLdYo
 fESg7jYW
 DAOfLUDzftQrqPi3GolBiUDZmoBQgsvtYRd91D8Je6Yi/7Drf3B6se1yQgCP5up6lrdTtaGuwidVLr8fpAhP4J/DxJKt2UL4X0xNJp/sPn0wwpGtVKnXN8rF6qHvDFpqPxxhbNglKeKOjkoePP8wFTsoV0ipKMs5cTEWDvAtPBUfjCgNenN3pnQSrSNh3rZfXq7rIrwlxoYUbFa9LaWc4fktTdGWkNz4nvYlOlc43D1pCZ5PmlwItLsikAuHrYZEjHaZhC6tcbJBUIQ03utKmDK+i9c8ecRwM9IMp5q8VXPjpXIf5T3g7oFYu7TIeGvQXZuHjzyTh+WMcYKz2HvfvWXkh1Ii1i67H2/oqooJcOpILo/e2/kF0QcqqotFs2XhkE4H80mpMtL8dIwpljKBFEo5bIs7jDHOkf/m3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With four generations, should_run_aging() only runs when the window
shrinks. With every fault on MADV_RANDOM mapping landing in min_seq,
and the oldest generation refilling as fast as it is evicted,
min_seq never advances and pages in the generations above it are
never evicted.

Run aging when the oldest file generation has refaulted more pages than
the lruvec holds since it became the oldest.

Signed-off-by: Maxim Muzafarov <maxmuzaf@gmail.com>
---
 mm/vmscan.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5..f59b29723ec9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4966,8 +4966,26 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	return scanned;
 }
 
+static bool oldest_gen_thrashing(struct lruvec *lruvec, unsigned long *min_seq,
+				 int swappiness, unsigned long evictable)
+{
+	int tier;
+	unsigned long refaulted = 0;
+	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	int hist = lru_hist_from_seq(min_seq[LRU_GEN_FILE]);
+
+	if (swappiness == SWAPPINESS_ANON_ONLY)
+		return false;
+
+	for (tier = 0; tier < MAX_NR_TIERS; tier++)
+		refaulted += atomic_long_read(&lrugen->refaulted[hist][LRU_GEN_FILE][tier]);
+
+	return refaulted > evictable;
+}
+
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
-			     struct scan_control *sc, int swappiness)
+			     struct scan_control *sc, int swappiness,
+			     unsigned long evictable)
 {
 	DEFINE_MIN_SEQ(lruvec);
 
@@ -4975,6 +4993,9 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
 		return true;
 
+	if (oldest_gen_thrashing(lruvec, min_seq, swappiness, evictable))
+		return true;
+
 	/* try to avoid aging, do gentle reclaim at the default priority */
 	if (sc->priority == DEF_PRIORITY)
 		return false;
@@ -4984,7 +5005,8 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 }
 
 static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
-			   struct mem_cgroup *memcg, int swappiness)
+			   struct mem_cgroup *memcg, int swappiness,
+			   unsigned long *nr_evictable)
 {
 	unsigned long nr_to_scan, evictable;
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -5003,6 +5025,7 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 	}
 
 	evictable = lruvec_evictable_size(lruvec, swappiness);
+	*nr_evictable = evictable;
 
 	/* try to scrape all its memory if this memcg was deleted */
 	if (!mem_cgroup_online(memcg))
@@ -5053,10 +5076,11 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	bool need_rotate = false, should_age = false;
 	long nr_batch, nr_to_scan;
+	unsigned long evictable = 0;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
-	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
+	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness, &evictable);
 	while (nr_to_scan > 0) {
 		int delta;
 		DEFINE_MAX_SEQ(lruvec);
@@ -5066,7 +5090,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			break;
 		}
 
-		if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
+		if (should_run_aging(lruvec, max_seq, sc, swappiness, evictable)) {
 			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
 				need_rotate = true;
 			should_age = true;

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.56.0


