Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80C36606BE08
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iDRCjiIw
Received: by kanga.kvack.org (Postfix)
	id 8E5A66B05BA; Wed, 18 Nov 2026 16:03:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BC8C6B05BB; Wed, 18 Nov 2026 16:03:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736A26B05BC; Wed, 18 Nov 2026 16:03:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 459446B05BA
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:03:53 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C86C41208C2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:03:52 +0000 (UTC)
X-FDA: 85449466704.08.13099F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9EEEC40006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:03:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iDRCjiIw;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795035830;
	b=zo5PmLIAec9fx2ASzbBttt7ATaQgx/Vg/Gmep5snX1iH6ab8k2wZakwzMzn4FApoH7v3dI
	MOWQTD5vxrXAYiP+D2BZnoSzYtYahJRT5ukYh3XAHX2q2sA7B6VfIu5ohh1bL2JmhVqd6E
	zFBypfYwZuvJyT2rOPmefT4N42JIOYM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795035830;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZiehOo0Bf1P5SRqogf/poqTftsKsN8SeO2iYKxqJA4=;
	b=QAM78m/Z/KEi6qnIdQg7DDunoKPdw78lmXnjV5nuiCq8oUHA8xt3hggXFa9iMWSzcbGAar
	lmv7TThWjXUsba11HtBWtb5+t3PWx4p5sFvAVcgaQ07TKDJO6M1KKR2ShGcmLsvpQ48HiR
	II18nGp3yDPP0JTcWpPsEsyWcRuIfyk=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iDRCjiIw;
	spf=pass (imf17.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B9B2746C74;
	Wed, 18 Nov 2026 21:03:49 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035829;
	b=RnS9BFUDjQFlXEmN40/k0gR3Hr51s4tUvqxOTJtn2B20UdCh/ChkT3xx5wIa2iBbvWc6
	 NmVhCv9zlE1rc+4fe0ESV8zPpX5jBGn5+nZHsPZNYGeCbg7Xtl/oA4IcsHXJ54BDHR6Lx
	 7sHSYhs1CP5Jqh7PWRHOHcD4evBCGJsG3XUh45TOIc1olpTyvDCM1fgukAUdRmOMWKf80
	 WHmvmqDckYlTPp510CHKakg+2s/3nOYYmxXa1QZ5ftZpxJO4ZQIYuwr5EhaduVtaRb8dW
	 O4MIvagB98pOcX6Iy4b+KsfeS869WKW5ej7GGsjYnErV23WGoiS/wph+iZuGWayK39g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035829;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=FZiehOo0Bf1P5SRqogf/poqTftsKsN8SeO2iYKxqJA4=;
	b=GTQx1cs9YRCXNV1esLP1SjuqH+cfbcsna8gF8fF6ECqLcfmPipEXt+lgmbuJmzQevgq+
	 h1DQ2tDJ2XiozynHSvm2lFy8BrHbuI60MDSqrGamvfr5+AdOTREDs7W3J/17Dhh98rWp7
	 9uuAzGyz8Y/kz+02DnKOZo2x+bRWOwxP5WG2js1b5MlhAha1q5T+XjjQjDK1lONOGTyM8
	 WEDwr2/awqPNbd6ZkcvdH+cYjdc0uy82KPsOuEjmadkmZnoFBZYCX4TTLq7i52wCWPH99
	 LIekN95b1wE9+M9takBZBMhasdNBhscr1/QU46edznlpmRFu3+7ZH/KL3Gk0OQsYCaw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1F5561F000CA;
	Wed, 18 Nov 2026 21:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035829;
	bh=FZiehOo0Bf1P5SRqogf/poqTftsKsN8SeO2iYKxqJA4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=iDRCjiIwfelGsQy/xV/bJmPj89/nn6vNUCPq+BTxs6S0W+QBnNHX/v/q1nNqqHfwe
	 jeLFqc/kwuDimjqceSEPhwzpfXt5WwHtNCWC/EIYmHOkDZAMt29L7vaL3QuGIM3kFO
	 oKKuDETzH9mDMsiAaJJIZnd9seLqeJ2nigPN1yrD8frnjBrUwSX6QhMihMhaXF1gGr
	 hq3j807Cuf/H4vcquJ9jsN7rnuJG4eHALf4gfSZ0QGF71F23+LTZsQd1WAbe5biARo
	 CRlA3XtBSvQFOPK3bGYQ7wwR/gRDdd55eAXGewmOXoGjwcZsI+ijzkCiX506jGUKsw
	 zHG8yWEcIGhnQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7E9D94AF94;
	Wed, 18 Nov 2026 21:03:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:36 +0800
Subject: [PATCH v5 04/17] mm/memcg: add folio-based lruvec live helper
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261119-mglru-fg-v5-4-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035819; l=5345;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=UPy3pGE6319hHgjCcjHs3BYbIQXEmhnHCnBETYV6U1U=;
 b=AqfXtl+0yCpQiqyIhsARAmmg2Fsm9mLz1qO5V+JmtA+2ZDtZgTGXqyJCmNSR+dvfy8goUaZ48
 3vrkNo74McRCI5QhGsRrjoUyRufQBCMaywpKJnzlOrA+BydE3iJC3FC
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Stat-Signature: p1cd1z56t4irazcr7zoykuycnena693w
X-Rspamd-Queue-Id: 9EEEC40006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795035830-420785
X-HE-Meta: U2FsdGVkX18dFcilXpk3NdHPOEaim4+7/JXQtvqSSjO4KXP74LdBJrAqJM+nblFZJVmfu126VmZs0qcjeqz6H2s/cJxSzAz+jOnkni/+FfDlClu8+hu8KiOgvxBXcl9GzkMYmJ+7agi3gMUZRhUV0C2XjQheulxSJoVc9p11Brz91tBcy+74nkH2AT/SAO8KlYlYivyknr/WEFnE+/mrqblWXly3X8HLDlSYsB/472FrhhIFXXP9oIAFhqU5GWO5YuPRsC/p/udA6GvON8Wpb8NfyyBRnvsnEDM1rp3ru/mEP77YXIBT1JSxfSNF1YShCgpUzjjSXgUQS5UHoHLoPArMsHr4SHESBFIfJChQuvP+oI5qHsjW2rwSaiLXttheAiACQNp0qoWIs3FNgoLgYFavhh+VP3DR7c9QSXx212G22edQfjRlQ+D8M7obhlTW9H9gvmlrSOoLevlej441LxC4+8LfAtu2UodiIUe+LnCHSPPxVGC3D8DXDipN+pFlefSqcqQDZckeGQcxgs0Y9MncS1EgB+qvrq/RcpDVV0PMXDl2b1mnbnIiNvAz/0xJ7nAdLX67eBkgTkSZyTrIJ8aIeEs7nSLOZDMwshAkiVigJeU7imD8zPqBCOxBgEOMLmyb7EPuHzQCLlqcD4/xcQj+hqIgVqO0xZ4MMEq+osT4ZiG/i/tPqA/N4x1/nuWC+GQus3r/lpc5eEGHZUeKuebrldw1kCRRyRYfyqGGMVJ+yjq8kr6ZZE+8qZ8cWZenHA6gA2CVxO8Tl13cYlfx+K5cYPH0qflgfgTOhiNh0pZ6RIdFFpWyYhgJKz+oqe6YoVZux5nI+KVLUirLuoij2exrEJEHukozFjkL66QAcItuVHHmM682rpd5a+r3uWACnOUkSad2YY2C/d3MBANuc++wmHDnXZ7ZhWpLJVmR5PDLJNsMAf36QghatfUucgf/aNPs4sZbz7rnA0ywhC5
 BI9aQwmV
 iG1ynAivC0EEDI0V6CgIkTT3hrpptm2BdPKzpzJ4W+zxN/EPSR8vQHRL2Tfb2+E2YO38YUaJhW54GwFzHGNusQ6/NETcY9O8NMhfGE3RICO4PyKaNqgAqWsrJTQQnVc6XRtfe0eJJmE/DZSiVZIM95/+e0FyOyEZmFsdHhfPR+wqwFOdsAu5qLkeoSyH4yIavvmQHZoaLtuapFEcKaPzymPHk0vItX+Yr32QehtZrUti0tCSAUdqYs/qRzWmsT0ofoVx/0Kc6cuwWgbLrWEtto9/KK+V0b201lN0RXuk/4PD4fURqRgukc8Ojutl6gXw+fJXbZPgv/8QDA4j2MScgQlT+yrTjYjfLqLyCy14qPCJTfG7mgnkLBOkLJqcElHIxdsuskzE3b/cZHJqTO1br6yD7CbydpFU5tkb2cVJ1xEwhnfFdFUxzg7jqlhNgbcnWCT7bj0BN8Dsk6l04o2jDE51p2+rfWYLaWOPsqfC3cyqe7+vjtiH49eu6fnVxeDtLpXipAEEb+uXblWGbhNbUaL+/TbrqD40IXe26/rk2+7hYzCUFviplUE20kn/LlqaqvS3/sK3tc22cl5F+XDEV3OGzazzaw/OjfnQPmHXgBBl4kxxexDiIshpuNnpI/e1/vO0e1Ws7h85LD36iHRrguG2Zmnmx0g0xljX+r5ji5A3db5oKRG/zwgtfsHVvUA+YxNSalvnbYi+tUdi0V+TvvjmVrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Add a helper that resolves a live lruvec for a folio under RCU
without taking the lruvec lock.  It takes a folio directly so the
lruvec lookup happens inside the RCU read-side critical section,
which a lruvec-based interface cannot guarantee.  The first user is
the lockless folio_inc_lru_refs() path later in the series.

Factor the ancestor walk out of lruvec_live_lock_irq() into
__lruvec_get_live(), so that both entry points share it, and spell
out why the walk is enough while only the RCU read lock is held:
reparenting of a memcg that starts dying waits for a grace period,
so it cannot race with the caller until the lock is released.

Move memcg_is_dying() up in memcontrol.h, next to the other memcg state
predicates, and use it for the walk rather than repeating the open coded
css_is_dying() test a few definitions away from where it is explained.

No functional change for existing callers.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h | 71 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 56 insertions(+), 15 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 980358bc6f49..441a5d57e723 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -571,6 +571,11 @@ static inline bool mem_cgroup_disabled(void)
 	return !cgroup_subsys_enabled(memory_cgrp_subsys);
 }
 
+static inline bool memcg_is_dying(struct mem_cgroup *memcg)
+{
+	return memcg ? css_is_dying(&memcg->css) : false;
+}
+
 static inline void mem_cgroup_protection(const struct mem_cgroup *root,
 					 const struct mem_cgroup *memcg,
 					 unsigned long *min,
@@ -1349,6 +1354,11 @@ static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
 	return true;
 }
 
+static inline bool memcg_is_dying(struct mem_cgroup *memcg)
+{
+	return false;
+}
+
 static inline
 unsigned long mem_cgroup_get_zone_lru_size(const struct lruvec *lruvec,
 		enum lru_list lru, int zone_idx)
@@ -1510,28 +1520,41 @@ static inline void lruvec_lock_irq(struct lruvec *lruvec)
 	spin_lock_irq(&lruvec->lru_lock);
 }
 
-static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
+/*
+ * Reparenting moves a dying memcg's LRU state to its parent at any time,
+ * so anything added to that LRU afterwards would be lost.  This helper
+ * walks up to the nearest live ancestor while the caller must hold the
+ * RCU read lock: reparenting of a memcg that starts dying waits for a
+ * grace period, so it cannot race with the caller until the lock is
+ * released.
+ */
+static inline struct lruvec *__lruvec_get_live(struct lruvec *lruvec)
 {
 #ifdef CONFIG_MEMCG
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
-	rcu_read_lock();
-
 	/*
 	 * The memcg can be NULL when the memory controller is disabled.
 	 * Otherwise, the caller keeps the memcg owning @lruvec alive.
 	 */
-	while (unlikely(memcg && css_is_dying(&memcg->css))) {
+	while (unlikely(memcg_is_dying(memcg))) {
 		memcg = parent_mem_cgroup(memcg);
 		lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	}
+#endif
+	return lruvec;
+}
 
+static inline struct lruvec *lruvec_live_lock_irq(struct lruvec *lruvec)
+{
+#ifdef CONFIG_MEMCG
+	rcu_read_lock();
+	lruvec = __lruvec_get_live(lruvec);
 	spin_lock_irq(&lruvec->lru_lock);
 #else
 	lruvec_lock_irq(lruvec);
 #endif
-
 	return lruvec;
 }
 
@@ -1561,6 +1584,34 @@ static inline bool folio_matches_lruvec(const struct folio *folio,
 	       lruvec_memcg(lruvec) == folio_memcg(folio);
 }
 
+/**
+ * folio_lruvec_live_get - get a live lruvec for a folio under RCU
+ * @folio: the folio
+ *
+ * Same as folio_lruvec(), except that a folio whose memcg is dying is
+ * accounted to the nearest live ancestor, which is where reparenting
+ * would put it anyway.
+ *
+ * Return: the live lruvec, with rcu_read_lock() held.  Pair it with
+ * folio_lruvec_live_put().
+ */
+static inline struct lruvec *folio_lruvec_live_get(struct folio *folio)
+{
+#ifdef CONFIG_MEMCG
+	rcu_read_lock();
+	return __lruvec_get_live(folio_lruvec(folio));
+#else
+	return folio_lruvec(folio);
+#endif
+}
+
+static inline void folio_lruvec_live_put(struct lruvec *lruvec)
+{
+#ifdef CONFIG_MEMCG
+	rcu_read_unlock();
+#endif
+}
+
 /* Don't lock again iff page's lruvec locked */
 static inline struct lruvec *folio_lruvec_relock_irq(const struct folio *folio,
 		struct lruvec *locked_lruvec)
@@ -1826,11 +1877,6 @@ void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg, nodemask_t *mask);
 
 void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg);
 
-static inline bool memcg_is_dying(struct mem_cgroup *memcg)
-{
-	return memcg ? css_is_dying(&memcg->css) : false;
-}
-
 #else
 static inline bool mem_cgroup_kmem_disabled(void)
 {
@@ -1901,11 +1947,6 @@ static inline void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg,
 static inline void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
 {
 }
-
-static inline bool memcg_is_dying(struct mem_cgroup *memcg)
-{
-	return false;
-}
 #endif /* CONFIG_MEMCG */
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_LRU_GEN)

-- 
2.56.1



