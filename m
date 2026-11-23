Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 485D8606A327
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=od/eY//M
Received: by kanga.kvack.org (Postfix)
	id 19A8B6B05BA; Mon, 23 Nov 2026 13:53:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1737D6B05BB; Mon, 23 Nov 2026 13:53:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 036076B05BC; Mon, 23 Nov 2026 13:53:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C34116B05BA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:53:27 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CAB87C09FA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:26 +0000 (UTC)
X-FDA: 85467282012.17.62CD6DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A1D6B140009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="od/eY//M";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795460004;
	b=0pbe9UN9tpYn92NzuUwIxJ7eG8FLnglqULg5hWztsJY9Mqt2SKVbarsi07ZZ8GRpD6AwGH
	gbg1nwrOoHNXJdxxHPzD6V10WNAOfK573jPj8ws7xDdlN+HyObWu2QnvUCkyps5xwVgxeq
	Vor24k8HFfGVUTlvGqGG4VbVIx0sVbg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460004;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y9oObqSSiDMafmKBBZklAmQlgVzGVcaYHm/4oLczkO0=;
	b=rsJpiVPgYsjhQBiE0r94H9jkdw5aLTTQITIMZwcPY+jCeRvcaUhgaLny4JS4IS3IX9VO7l
	XDhWqzcS+MYpLIxxFVpkeElmgYcQY0NdG9GwA9t5HJs5aX489ia+0IqNA9TxGvD6N4tVdn
	U6XolLMLUaKb7NRQ/yadOMJO7fw0be4=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="od/eY//M";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E9CE445790;
	Mon, 23 Nov 2026 18:53:23 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460003;
	b=2pyduxfOQ2IoqdGE84HLr+NXzy5qJdY/Ynl7UBzHKAI09Oid5hu76aAR3OK/azCh2bFs
	 GY2D0VxNymm0RbqRlxD/HEyOzKM4cVds44+H6CtUj97GhfYfCK5IRjFWZ5QO7AV1zpK61
	 iCizY4kVTmuYiaC9+gBbTeBcnlz2wIEBF3l1omIgWQwKGIjmlMWgMvshwM9aLz/t/P/wj
	 5zEuqyBk/p1zmCzhPhuPzoytf3zDeowKYNCsPW+F4XdhWJHYNJkTxF/8Bm15zg+W8TYCB
	 vUZZpYigrIamOm/MTXL+iwD15fGpmeWr+AUbbLluDx1D3GhgnXCsnpl5U6p+Si5iz9g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460003;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Y9oObqSSiDMafmKBBZklAmQlgVzGVcaYHm/4oLczkO0=;
	b=YwaDQWYFqlmX1b3GvNQ1AHnSPERAOERSS+ijhaCp25k8DCkvx7blfOfO9lFKTG/1coTc
	 T1fKq0a/WERHlm0VX2EiwjaxkusLM6Gc2L7mM52jrAFhlKA6vE7+ERaNvdfO6iPUi/IjE
	 fM4iKp2z+3y6OO6hV+4olBQuX5kuoK8rMsK6SobP9A4diZ0+NgbEnX9+TTe+D1fGcOVYu
	 d9TEu0eLYEJzURgXWui7YDkZ573KldCI8tbxUtbz+L0xLOa2r7jBpzl3UhJf4OyR4rHHr
	 1Swnm17YPJ9cVU6f8Pir2Voz1na2GBZPoSXMw9SNlLi7NGoi97zQ5VM4OQD5f7FtoMA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 50A1D1F00A19;
	Mon, 23 Nov 2026 18:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460003;
	bh=Y9oObqSSiDMafmKBBZklAmQlgVzGVcaYHm/4oLczkO0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=od/eY//M6OwwtZ/2VjVHg+5kOKBjtK+62RAes9/MfgS+0PdBtf88KMKllfQVYwAc5
	 Ly20jYnZ3XBgmpalk06Zya7GY5JtAmEcXfC17lY7qo/sGi+0P6mG1d635WBYjB9T4r
	 Iecz4bFGssxs+7mrcOTRM0B1jaIn368J1C/K/QpT4bl7fuLHI8vN6DT13sXENqWFR0
	 kcx9/McaOLJCmPU/KVJdFCZCP+TBjPa2BUAzLY0AMpEK2miSwbAf7p/sUNQjEhqSjx
	 oGHow8XYge/WcZjYi+mTVhUy+3jedqov9B7mj1lRgv3kAcw0smCvn4NZeM2/QkB2+W
	 BNrdfR+KXtQ4w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9C3284C63D;
	Mon, 23 Nov 2026 18:53:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:52:57 +0800
Subject: [PATCH v6 05/18] mm/memcg: add folio-based lruvec live helper
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-mglru-fg-v6-5-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
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
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Tianyi Chen <hi@tychen.cc>, Kairui Song <kasong@tencent.com>, 
 Ridong Chen <ridong.chen@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=5565;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=4nACRHHUT6uoBi4A3zLGJqQt1hkIcj1Dp7YpYy06ekc=;
 b=L8XeY1unOlmxAlxK2jWtG4TrI2zaQHkKujBrGJORzsRuLiFUKDDM2Z0QuMTOIy1sME7rZM35M
 Hfu4zMRX7/ODZuwwOA3Ffwe7jxyK1pS7sobMCnoUSEO0En1TeQnScMU
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A1D6B140009
X-Stat-Signature: e1xrsg6m13apf88p45bfwgsxwxopz1rf
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795460004-25884
X-HE-Meta: U2FsdGVkX1+oUzSXcdx2B+5Ow2xTUXuE3fDzdXnX71pVV5UkpH+nBjERGSVCjuLag8J6eTa/Y+PBxQebnVeJ2Bj6AHghDN1WKxTIR5QeuXEbYW5VRoYq2VqKxuisU8cIn/vxAijYBvq7tcKx5ejxmX0NOvUSaFJ0pdfBl4cmmCPl/0ZuId7vAjMW3oRO+1s2yge+hji70dT2yNn0enuK3vLaMmSB0Y7Q30WAW/uHNkL2ap6a4jeJ5K88hHD15NH4PDBS7efgjp0/QBOcycl0Xim90utby7jXgg4qszWW1sa+u7dJaSDCZqZdLVPap38jiYDy5U5kuRtJDeK2KwpHuuMa8PAv1TbSetHA20Ws/tFB52z9vSyA87AzKmhpgtEn5BOTXxRXhlWCyl4RfMIVB+FDJBScryuaBRKLFJVSAJuL76wr2+2GQYbNm55JUGrZnw1WY/eXfb7K1SIdreRKSXS2LLaxxLqw58cEnaqiXluqMo1IILrWahVHFiWw14/Jtol4Hg4hvDJ7X2uKEH8ZYTvXpL/AxtV3Qa95MR/25UzvWmQYG4vK/pMpU/d4gp2P0N0HJVJRjUX+8AfdYgwKKzXg5EiGUNnnvg75WlivjGhJDhiAV/GtlK611VEq0UObs7KFPAGP14OOYfjtEFgEaV8iFXBg2I2pRBctdrFANaGhE8P6wI4w8V9YbTqOHxI7av2mVMPt/DL2Sa4VYiHxbm3JbTj+zZkOYAEKZRdKgj0L+URNdinumXrK7yK5IXM21E3ZFQhL7Y73oM3qdZK6wEBtV4QdGxEVQxTJwQ/QVD+Kw8sy4B48LGIeDnicPBfr+Ek8jHHPfcb2AjDK0ovCm7HT/rqnlRpWcHyhl39EYZc+zbBTW8pqSMK/aucoDOxcCUrr9ZzMgRud4jZq/LvUO5uvlLkW4d9vsRyeJmie9ChkgGzlt6GWXrIj9wqJMn0Sd8yuaWGYFM1x6qwV+oY
 npYW+yvN
 DDGjVTd1HwN5+5HMIt9YKDRgZNdOgWZqXD4ZijS46f9YWfjoVbrAI7iwCEtsj84T/URucVTE9tPzfb2JmhxBQufbqLkvHALtK5RiUNVRttLMZ3r+9arQZhePkNEUt0tQANSaAEH1Je3xkFUUVIiUfvkfktO1GbqAq8gAdqI/9rzXhRAn/8kDacMWsBgbBVNlF/2uBMlDUnVQUTii+bjUqhVNsCu8RTaQ/qA0qee0B907ep3VJJe26f1BxOM75aQ0IyzcSCuXzObr9yudF3NgTRNmaRB805HdAYQ5dAgdMUCaVv2D9Lv5YN2gDPU0zpLnOGJ7al1Bg8Ka911beGBDQA0/IYsAlJEt+gq+bvh48k3m9L/+Tou+fluozH6cWA6pnjUR376GXXz7LqwZ6zOWniUnBffOa4+Ri5B/EJhxIqL1qHN7mdSr47Nq38ih2owPWizinuMAKyyDkHI64V9DC68DV7QNCTpLlJP/X+XymHmOo35BxbUZ3ya0h33cP2baYELH5mPQraR+Ncd9K9NP5TiBZoDtbFqsepoOHhbTEzkKQl8PFYtSezeD1Wye/tHNpY8N38oaTg+OWK2PtVSG//4u7WEsSEvRmzEfw2W2Wr6jI+YKxrfSx6VPI8BrKg/nmr9hHaqWf8OqW6wFqP9ToRrKGx/jTBQOenjzqWI5TATwGrraidSvdFGWjYtAMBcCct4qfaVWxARoiiKvx4+YCxfJFQYOWQR22PIvplzMao9cpQHp+ujHTkyqXe073c67VY79/ZCFUwdYNFveSaL6ETJtDRyhU+zylI1F6QdKx5U5J5r8U3s6fjE9pbNoOJDB0BPMB4PJPMmwYAyOqKF74m9iYHFfSqf7tYRz3EujcZWxQWRNAtF4l1mZWW0Ml8ut+xD5Q
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
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/memcontrol.h | 71 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 56 insertions(+), 15 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 980358bc6f49..a03f9711522e 100644
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
+static inline struct lruvec *folio_lruvec_live_get(const struct folio *folio)
+{
+#ifdef CONFIG_MEMCG
+	rcu_read_lock();
+	return __lruvec_get_live(folio_lruvec(folio));
+#else
+	return folio_lruvec(folio);
+#endif
+}
+
+static inline void folio_lruvec_live_put(const struct lruvec *lruvec)
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



