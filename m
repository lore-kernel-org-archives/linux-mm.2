Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06A65D64087
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69BB26B00BD; Wed, 17 Dec 2025 02:34:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6656D6B00BF; Wed, 17 Dec 2025 02:34:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 552426B00C0; Wed, 17 Dec 2025 02:34:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 43FC86B00BD
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:34:07 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB8D91A08DA
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:34:06 +0000 (UTC)
X-FDA: 84228149292.22.3752400
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 261DE18000C
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:34:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P8PB9ZU9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956845; a=rsa-sha256;
	cv=none;
	b=RouLm10bOQEH6YilFZYMTEPM78+hn9Ax2nKz9hUMt+yar+On7rh5eR5QmKeOHZ/6i2un9C
	MJXRF/zgq44CfxYZs5LiAH1q695uZzPIAORiGT2VD2xu6YOLh1DplQRgY9SZnPiPVgA0PY
	AkWhI1CbzKY+C9eYoTIRpvl9t6xrqZ8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P8PB9ZU9;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w8JtVsEwuAYX9hiBQJNmTbS3AoZrY1ADR5PkaJDwFdU=;
	b=pwFJQ1WZrlneqwTm7zOZiy6U02xMW6xCgfyZt9xtXqDkVgBKxs5MZ9Q87sd1oj5FF7P540
	WPEKcVqRDVtcZm0FrkGmb60KpdJOCxpq6AKzkcQRYyetfRviDGWd7E44GikRj75sbL+1OV
	Xe/nrOjAWplp2M1ZYtFX3c+Prv/ykN4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w8JtVsEwuAYX9hiBQJNmTbS3AoZrY1ADR5PkaJDwFdU=;
	b=P8PB9ZU9Q6MDmfdfPtWGse616l/crVah1JQtTwg41R/rrJo/+jWao2sbIDhN1hY5RoJtHp
	jlE7lGcLKeM5XVvntPmnQE+xWOdXeJEYeMqK5Oa+LRWnNdkcHO3OcicIiJkDDt4VMRH0x6
	2chPgmBGuZSYyx8QQqXE1HsH5/pQ28w=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 25/28] mm: vmscan: prepare for reparenting MGLRU folios
Date: Wed, 17 Dec 2025 15:27:49 +0800
Message-ID: <93cf8a847992563a096fdf9b24b18529606c29ee.1765956026.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 261DE18000C
X-Rspamd-Server: rspam03
X-Stat-Signature: sd5gwqzo35yur1jxa8f9c9g4wu83f84b
X-Rspam-User: 
X-HE-Tag: 1765956844-181201
X-HE-Meta: U2FsdGVkX1+Ut+bbK5yzDgtFdyw1K2Hm/zx2784TnYyv3OQbvSY5OU8zAv8qjEkwWKHNFjaa241Yg7VFi2eP991fnAkkgp+uRKJ/cmt7RVO4nhYgK+zWK+arPjqyGUyiLIiZPPYzNPj5+yPEbb2mDUTGYZ1Rdlqj14asOAzHCgPkAPm3y4vBBZ3cVARD2EdSE6sICRWuXrj5IsJvL3wjtpa//N+nHpJ2nbXiDxK95J+QXzJKMwZPvjthdB8UxvRonOpjCoHFpBLp2JSiYrzWGho3b6Ob3DaDStgf7uU6ciUxQu3Y6DDJsqNlu8GUiXuORl7uCm7T0JIat0LMV02ky38sqnTFKjYmZyez406WErCvdnpCVixvJWdxSfwLkCaW74f6Jx5D/VSDE2vYKe0C6RxibrpAI0tIp5Dudo8ma3TTMxFy0/cexLgCfe/vuefHS7ehspl4k6r71RuwPmGymZULlrwKKELp5/OpfU2nfMFW8Ly338XfNqhkARFI/jn6WGX3Mpfv8+18sg6uUZN6Z0ZksSeVG7r7jIprfdTKMbuvfRMM1WFXwy6vbvHET08e5QpZ5Y2MHbKobBIG2qmCEUVEYxnVua/k4So3b+eNebOomWQln+FuzrU2tYcTW3gsM1vD9i09BOgFa+lM+JpNGe/8yz+8ikwYMOdo01cfun+2RjvO9+G6HpYMN5gLM+xZhSF9jZmz7exsXozSRUf/Sh7vk4BhN9SKnNC6SyPmLHKDQdkGtcrOofqi/vwZx/KPTp6bggfkRusdbj89DFqjNpqDb7G/H5ubxL79YMKZMO6BOnbBFHw0sFuWsx2sSJ7gaDetTht9cqyB8qyuE+CUNFQQPXQvZowMx4mCofPcrG81cts56h31JCrCoSdPh5yQGtMlt618HMlAZHgjc1MWcEwX9Dh+g5kNu+XX5cUuVJRnH9cBquLbed2OnvMMSnph0GlDWdhr21WJG4HpvAJ
 //N+JWOC
 V5u1Z9q1/NDR5RTmcwbvXToaOTsIENV5WYD1qQqOtTnyALW4iZ1Iy1mJHKEzA7iCtJt5ncdXMMzlJ4MvuweqCRQPtkqrKzJxip4M5KfgT/KrN6DAjwWwxiUtNx+leekAgXrEtezwk65aKJWbr4EQV35L1GUdCzPw779h2a9TFv2X44IY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Similar to traditional LRU folios, in order to solve the dying memcg
problem, we also need to reparenting MGLRU folios to the parent memcg when
memcg offline.

However, there are the following challenges:

1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
   number of generations of the parent and child memcg may be different,
   so we cannot simply transfer MGLRU folios in the child memcg to the
   parent memcg as we did for traditional LRU folios.
2. The generation information is stored in folio->flags, but we cannot
   traverse these folios while holding the lru lock, otherwise it may
   cause softlockup.
3. In walk_update_folio(), the gen of folio and corresponding lru size
   may be updated, but the folio is not immediately moved to the
   corresponding lru list. Therefore, there may be folios of different
   generations on an LRU list.
4. In lru_gen_del_folio(), the generation to which the folio belongs is
   found based on the generation information in folio->flags, and the
   corresponding LRU size will be updated. Therefore, we need to update
   the lru size correctly during reparenting, otherwise the lru size may
   be updated incorrectly in lru_gen_del_folio().

Finally, this patch chose a compromise method, which is to splice the lru
list in the child memcg to the lru list of the same generation in the
parent memcg during reparenting. And in order to ensure that the parent
memcg has the same generation, we need to increase the generations in the
parent memcg to the MAX_NR_GENS before reparenting.

Of course, the same generation has different meanings in the parent and
child memcg, this will cause confusion in the hot and cold information of
folios. But other than that, this method is simple enough, the lru size
is correct, and there is no need to consider some concurrency issues (such
as lru_gen_del_folio()).

To prepare for the above work, this commit implements the specific
functions, which will be used during reparenting.

Suggested-by: Harry Yoo <harry.yoo@oracle.com>
Suggested-by: Imran Khan <imran.f.khan@oracle.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/mmzone.h |  16 +++++
 mm/vmscan.c            | 141 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 157 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 08132012aa8b8..67c0e55da1220 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -628,6 +628,9 @@ void lru_gen_online_memcg(struct mem_cgroup *memcg);
 void lru_gen_offline_memcg(struct mem_cgroup *memcg);
 void lru_gen_release_memcg(struct mem_cgroup *memcg);
 void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid);
+void max_lru_gen_memcg(struct mem_cgroup *memcg);
+bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg);
+void lru_gen_reparent_memcg(struct mem_cgroup *src, struct mem_cgroup *dst);
 
 #else /* !CONFIG_LRU_GEN */
 
@@ -668,6 +671,19 @@ static inline void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
 {
 }
 
+static inline void max_lru_gen_memcg(struct mem_cgroup *memcg)
+{
+}
+
+static inline bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg)
+{
+	return true;
+}
+
+static inline void lru_gen_reparent_memcg(struct mem_cgroup *src, struct mem_cgroup *dst)
+{
+}
+
 #endif /* CONFIG_LRU_GEN */
 
 struct lruvec {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5fd0f97c3719c..64a85eea26dc6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4466,6 +4466,147 @@ void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
 		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
 }
 
+bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg)
+{
+	int nid;
+
+	for_each_node(nid) {
+		struct lruvec *lruvec = get_lruvec(memcg, nid);
+		int type;
+
+		for (type = 0; type < ANON_AND_FILE; type++) {
+			if (get_nr_gens(lruvec, type) != MAX_NR_GENS)
+				return false;
+		}
+	}
+
+	return true;
+}
+
+static void try_to_inc_max_seq_nowalk(struct mem_cgroup *memcg,
+				      struct lruvec *lruvec)
+{
+	struct lru_gen_mm_list *mm_list = get_mm_list(memcg);
+	struct lru_gen_mm_state *mm_state = get_mm_state(lruvec);
+	int swappiness = mem_cgroup_swappiness(memcg);
+	DEFINE_MAX_SEQ(lruvec);
+	bool success = false;
+
+	/*
+	 * We are not iterating the mm_list here, updating mm_state->seq is just
+	 * to make mm walkers work properly.
+	 */
+	if (mm_state) {
+		spin_lock(&mm_list->lock);
+		VM_WARN_ON_ONCE(mm_state->seq + 1 < max_seq);
+		if (max_seq > mm_state->seq) {
+			WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
+			success = true;
+		}
+		spin_unlock(&mm_list->lock);
+	} else {
+		success = true;
+	}
+
+	if (success)
+		inc_max_seq(lruvec, max_seq, swappiness);
+}
+
+/*
+ * We need to ensure that the folios of child memcg can be reparented to the
+ * same gen of the parent memcg, so the gens of the parent memcg needed be
+ * incremented to the MAX_NR_GENS before reparenting.
+ */
+void max_lru_gen_memcg(struct mem_cgroup *memcg)
+{
+	int nid;
+
+	for_each_node(nid) {
+		struct lruvec *lruvec = get_lruvec(memcg, nid);
+		int type;
+
+		for (type = 0; type < ANON_AND_FILE; type++) {
+			while (get_nr_gens(lruvec, type) < MAX_NR_GENS) {
+				try_to_inc_max_seq_nowalk(memcg, lruvec);
+				cond_resched();
+			}
+		}
+	}
+}
+
+/*
+ * Compared to traditional LRU, MGLRU faces the following challenges:
+ *
+ * 1. Each lruvec has between MIN_NR_GENS and MAX_NR_GENS generations, the
+ *    number of generations of the parent and child memcg may be different,
+ *    so we cannot simply transfer MGLRU folios in the child memcg to the
+ *    parent memcg as we did for traditional LRU folios.
+ * 2. The generation information is stored in folio->flags, but we cannot
+ *    traverse these folios while holding the lru lock, otherwise it may
+ *    cause softlockup.
+ * 3. In walk_update_folio(), the gen of folio and corresponding lru size
+ *    may be updated, but the folio is not immediately moved to the
+ *    corresponding lru list. Therefore, there may be folios of different
+ *    generations on an LRU list.
+ * 4. In lru_gen_del_folio(), the generation to which the folio belongs is
+ *    found based on the generation information in folio->flags, and the
+ *    corresponding LRU size will be updated. Therefore, we need to update
+ *    the lru size correctly during reparenting, otherwise the lru size may
+ *    be updated incorrectly in lru_gen_del_folio().
+ *
+ * Finally, we choose a compromise method, which is to splice the lru list in
+ * the child memcg to the lru list of the same generation in the parent memcg
+ * during reparenting.
+ *
+ * The same generation has different meanings in the parent and child memcg,
+ * so this compromise method will cause the LRU inversion problem. But as the
+ * system runs, this problem will be fixed automatically.
+ */
+static void __lru_gen_reparent_memcg(struct lruvec *src_lruvec, struct lruvec *dst_lruvec,
+				     int zone, int type)
+{
+	struct lru_gen_folio *src_lrugen, *dst_lrugen;
+	enum lru_list lru = type * LRU_INACTIVE_FILE;
+	int i;
+
+	src_lrugen = &src_lruvec->lrugen;
+	dst_lrugen = &dst_lruvec->lrugen;
+
+	for (i = 0; i < get_nr_gens(src_lruvec, type); i++) {
+		int gen = lru_gen_from_seq(src_lrugen->max_seq - i);
+		long nr_pages = src_lrugen->nr_pages[gen][type][zone];
+		int src_lru_active = lru_gen_is_active(src_lruvec, gen) ? LRU_ACTIVE : 0;
+		int dst_lru_active = lru_gen_is_active(dst_lruvec, gen) ? LRU_ACTIVE : 0;
+
+		list_splice_tail_init(&src_lrugen->folios[gen][type][zone],
+				      &dst_lrugen->folios[gen][type][zone]);
+
+		WRITE_ONCE(src_lrugen->nr_pages[gen][type][zone], 0);
+		WRITE_ONCE(dst_lrugen->nr_pages[gen][type][zone],
+			   dst_lrugen->nr_pages[gen][type][zone] + nr_pages);
+
+		__update_lru_size(src_lruvec, lru + src_lru_active, zone, -nr_pages);
+		__update_lru_size(dst_lruvec, lru + dst_lru_active, zone, nr_pages);
+	}
+}
+
+void lru_gen_reparent_memcg(struct mem_cgroup *src, struct mem_cgroup *dst)
+{
+	int nid;
+
+	for_each_node(nid) {
+		struct lruvec *src_lruvec, *dst_lruvec;
+		int type, zone;
+
+		src_lruvec = get_lruvec(src, nid);
+		dst_lruvec = get_lruvec(dst, nid);
+
+		for (zone = 0; zone < MAX_NR_ZONES; zone++)
+			for (type = 0; type < ANON_AND_FILE; type++)
+				__lru_gen_reparent_memcg(src_lruvec, dst_lruvec, zone, type);
+	}
+}
+
 #endif /* CONFIG_MEMCG */
 
 /******************************************************************************
-- 
2.20.1


