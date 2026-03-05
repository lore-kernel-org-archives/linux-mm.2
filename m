Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F4A5F30951
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121C16B00C4; Thu,  5 Mar 2026 06:58:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F6AC6B00C5; Thu,  5 Mar 2026 06:58:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 001C76B00C6; Thu,  5 Mar 2026 06:58:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E20176B00C4
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:58:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC1D85B7CC
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:58:49 +0000 (UTC)
X-FDA: 84511862778.20.5C44B88
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf14.hostedemail.com (Postfix) with ESMTP id EE870100002
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:58:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nK5cOxuP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FNVJ4KS5apbdFZdhuZeNuYa2gU+wA/pVS6ou2uf08Uw=;
	b=S53nD4yJ3llOpvJ3mXj+xSm/YYfVyA7hC33mCgXQeKhT6v6YzdwE4oNMFbcFC24egw31Rn
	auSj0rCqAbdsnmbadEBmezUY6n5nMKgJhyOU69HgSmCX2tE888hpibSlGwEjqk7kGq7Cn+
	VY1u5Rpr+OGh84cDy2tIv0SZyFSauqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711928; a=rsa-sha256;
	cv=none;
	b=EaQNl7vyix5FPsOD9wcSBV4XhtyF3orzRe7YHmvJHJvjlM45GHSUS9hsF6byqPsYe6r8Dx
	z6bdzfrZ771ZkhHR0S7OWjFgynkn/BoVOuoTAjAvE2GvuM0lDM3blSRQScDpQW2tYYkpwU
	9uojFd6hWJKljQb0rPu2/8V8T0NncZ8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nK5cOxuP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FNVJ4KS5apbdFZdhuZeNuYa2gU+wA/pVS6ou2uf08Uw=;
	b=nK5cOxuPDHk2gapaPO9PtGKvoNl0fuenWnofmUxxaf38ar1Zu9UNZ8LqU48OXeMt0hNxKD
	PsrOAwAAgLYcbOoJ+XI4Tner1RfwB0CzmAJBb+sqixT/aqSmhxUgGhL2JWP/RgagZbvWuu
	Duqvm7d7Sml9BxhyHLdDM2X3/tEZGOU=
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
	yosry.ahmed@linux.dev,
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
	lance.yang@linux.dev,
	bhe@redhat.com,
	usamaarif642@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v6 26/33] mm: vmscan: prepare for reparenting MGLRU folios
Date: Thu,  5 Mar 2026 19:52:44 +0800
Message-ID: <e75050354cdbc42221a04f7cf133292b61105548.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EE870100002
X-Stat-Signature: zm79ycmbsfnhyxqo7ja9xpfgrrsezzzg
X-Rspam-User: 
X-HE-Tag: 1772711927-965153
X-HE-Meta: U2FsdGVkX18ls5Mw8O16w82Qll+zTJMWm8G+2dSEeTUDmOgvXwUsD0+s6QNEv5e5oiNVoqbYHPAZqBH++Y7qmU0PWPzU/HrM4xrzMpc6qpn/xurzdWcaQR/Zqq/YrS7ZwOxEZdclen0kVUxL0SN02kHeQdE+w08Zec5YympkT1tUhPyhgSwf0f8PK1wH/veugW0XuEGBax9GMGt1Kk+vnvhLkIkdi7m4+fqEdmSxnydZBAiDQx4XwZoB0XmLrVMx3dYgOAnSGM+0mt2UlqfSc5I9cuBJWt6ZdX7rxUTjOE2BB/QquAK3/KEsVbhKQHPzTJATowXrqtWqbbD9AkLLk+b+4GECVzfozqaBXY5i6fbgCtNyY7vKsSyjkHVFNwmBp62tbNHhL/UW0SkIFYk2zybppY9RyY34qirNHzSwJHe2eEVI5UD/zY8o7ojH17tfBRapIrwvSxg6l2oXMozxG3doSk/DdnP57I9infjfU6lZbb74lws5TZ85rVuNYJC4PWxuuwwZ3y4wrmc8FcAhOWgCZJDmI11rS0hsWjqqOnbk/H0/Lz7xSQdY1Eb8Iqs/86MUGQVUYueHar/UI+nxjncYvkfsva5ku4UbXZsb8NgkpCYN6aowUG9qXQNafoqmpClU2+UgzJA2yA4RYjAcD4ZWngkx2hPeJROtjnS/y1eFrM7nqfEUmHPQEBcJGYRgWFjCYoc+56gYNp4Rye2m54pJTpojzXeypC6Rvjp8pTjflnlsebCo7zL6TTd8NvZJyzct8GMEMB+5cNmNxgD79/W4JuYcBhdrI4GbrE5d/XNVPfh69Tz7OrhU7RFmSJmpBFcs3ghViHC5tfapSi4kB5BoFiGGlOe60S//gpHmVWFAED4Etcu5nrfpOZyx0v93AJCX8vy3en7MzFMxYrYMJumxdukvezwYFrf57LcUtFxmunFlyEXvQspYB34w8cLKUFsS0zOFZFZ0qx0WlhX
 2PiDRqhW
 oA81zguSHsh4XwUrN7gKzrMbXdaRTMLUwWFO8EMLD0Tmr7qva9KHrgdHMWiOuvn1QrsMmtj3MKbNw/gReG1eGOSviB8LbjyHmsGlI2/xizfIJ8veyS/boCBo4ULTOzX4A57WJJOxSbP7X8iTHZ77rciVCMGH1ziCGs3/rP6TQbVivlFo=
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
Acked-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/mmzone.h |  17 +++++
 mm/vmscan.c            | 142 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 159 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 546bca95ca40c..e7a8cd41619b2 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -637,6 +637,9 @@ void lru_gen_online_memcg(struct mem_cgroup *memcg);
 void lru_gen_offline_memcg(struct mem_cgroup *memcg);
 void lru_gen_release_memcg(struct mem_cgroup *memcg);
 void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid);
+void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid);
+bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid);
+void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid);
 
 #else /* !CONFIG_LRU_GEN */
 
@@ -677,6 +680,20 @@ static inline void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
 {
 }
 
+static inline void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid)
+{
+}
+
+static inline bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid)
+{
+	return true;
+}
+
+static inline
+void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid)
+{
+}
+
 #endif /* CONFIG_LRU_GEN */
 
 struct lruvec {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 606b4ecf77ef3..0fb81fb7985e2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4408,6 +4408,148 @@ void lru_gen_soft_reclaim(struct mem_cgroup *memcg, int nid)
 		lru_gen_rotate_memcg(lruvec, MEMCG_LRU_HEAD);
 }
 
+bool recheck_lru_gen_max_memcg(struct mem_cgroup *memcg, int nid)
+{
+	struct lruvec *lruvec = get_lruvec(memcg, nid);
+	int type;
+
+	for (type = 0; type < ANON_AND_FILE; type++) {
+		if (get_nr_gens(lruvec, type) != MAX_NR_GENS)
+			return false;
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
+void max_lru_gen_memcg(struct mem_cgroup *memcg, int nid)
+{
+	struct lruvec *lruvec = get_lruvec(memcg, nid);
+	int type;
+
+	for (type = 0; type < ANON_AND_FILE; type++) {
+		while (get_nr_gens(lruvec, type) < MAX_NR_GENS) {
+			try_to_inc_max_seq_nowalk(memcg, lruvec);
+			cond_resched();
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
+static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec *parent_lruvec,
+				     int zone, int type)
+{
+	struct lru_gen_folio *child_lrugen, *parent_lrugen;
+	enum lru_list lru = type * LRU_INACTIVE_FILE;
+	int i;
+
+	child_lrugen = &child_lruvec->lrugen;
+	parent_lrugen = &parent_lruvec->lrugen;
+
+	for (i = 0; i < get_nr_gens(child_lruvec, type); i++) {
+		int gen = lru_gen_from_seq(child_lrugen->max_seq - i);
+		long nr_pages = child_lrugen->nr_pages[gen][type][zone];
+		int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
+		int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
+
+		/* Assuming that child pages are colder than parent pages */
+		list_splice_init(&child_lrugen->folios[gen][type][zone],
+				 &parent_lrugen->folios[gen][type][zone]);
+
+		WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
+		WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
+			   parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
+
+		if (lru_gen_is_active(child_lruvec, gen) != lru_gen_is_active(parent_lruvec, gen)) {
+			__update_lru_size(child_lruvec, lru + child_lru_active, zone, -nr_pages);
+			__update_lru_size(parent_lruvec, lru + parent_lru_active, zone, nr_pages);
+		}
+	}
+}
+
+void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent, int nid)
+{
+	struct lruvec *child_lruvec, *parent_lruvec;
+	int type, zid;
+	struct zone *zone;
+	enum lru_list lru;
+
+	child_lruvec = get_lruvec(memcg, nid);
+	parent_lruvec = get_lruvec(parent, nid);
+
+	for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1)
+		for (type = 0; type < ANON_AND_FILE; type++)
+			__lru_gen_reparent_memcg(child_lruvec, parent_lruvec, zid, type);
+
+	for_each_lru(lru) {
+		for_each_managed_zone_pgdat(zone, NODE_DATA(nid), zid, MAX_NR_ZONES - 1) {
+			unsigned long size = mem_cgroup_get_zone_lru_size(child_lruvec, lru, zid);
+
+			mem_cgroup_update_lru_size(parent_lruvec, lru, zid, size);
+		}
+	}
+}
+
 #endif /* CONFIG_MEMCG */
 
 /******************************************************************************
-- 
2.20.1


