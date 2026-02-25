Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2E56EFD204
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 07:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EEA76B00A4; Wed, 25 Feb 2026 02:51:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CF9D6B00A6; Wed, 25 Feb 2026 02:51:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DC696B00A7; Wed, 25 Feb 2026 02:51:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EC2926B00A4
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:51:08 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1427B9895
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:51:08 +0000 (UTC)
X-FDA: 84482208216.09.F40B481
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf28.hostedemail.com (Postfix) with ESMTP id E4B06C0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:51:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QyTpyBem;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772005867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7g4zlvI4KL5BM3hQhoVvcLwONpSLS6QDIXKeCKwliro=;
	b=q4Qh9WgD/qaOGd+9EfKa5c/c9l6jM5oLpj4pPOVT42oK/PT44RN2AxPPoN+XEHvlH4q2b3
	Ei7fcyfadXEF82clWYjSGSQYngqvl1LXa+E+Tm0+Yr5+0rZM74Asgwe/HNqID/jayqcfZe
	G7zaB0wTeT5doA8wZKeqqE9qaGCTN9M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772005867; a=rsa-sha256;
	cv=none;
	b=PQRe3WDoJYhuD95tpz6KvAI2gLL1R0vgTTAJPOTH9pxBXnfqXndcdTaQvAc7hzYbpNp4WQ
	4CxUGEvrGJNVlqoeJQXPZPOaWKdkiwaWecn4kKLU8I3NcZSic85ktIG8zRWi+kLy8TUxPb
	ARLGu2KbJ6eeWPlBgdRCadaTbtq/Sdg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QyTpyBem;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772005865;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7g4zlvI4KL5BM3hQhoVvcLwONpSLS6QDIXKeCKwliro=;
	b=QyTpyBemrEemSPovJqik1g1xMtszEVeXZTEVpK9vIyrraK29LWm8EfiWvYJ0/9qB6QH13H
	ZPRe4QfxI1ucZU9acWwkLDTq2RsSNpk1CJnAp1qL/0Cz3XfjtpZ/1PbDrE2NdfVG1f1E4S
	P1qIeUOIX2wzqlwneyqBSF3fYHT4dOc=
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
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 10/32] writeback: prevent memory cgroup release in writeback module
Date: Wed, 25 Feb 2026 15:48:43 +0800
Message-ID: <645f99bc344575417f67def3744f975596df2793.1772005110.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772005110.git.zhengqi.arch@bytedance.com>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: fnhuq9wpf8aitzyazby4cmjutwsbx95w
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E4B06C0005
X-HE-Tag: 1772005866-224547
X-HE-Meta: U2FsdGVkX190u/WWPLD/JQMOLxaxBOhUpDJbcxjUnACF+kI7JtUATf/hljuo3D9KqY8uD9r+aFf3zri5HGMT/6VjpzrXyLzghMPHTJ0d+SVILQaLnfdA8n4LOZeyF2wuxoXQDlQok2sYy94bEXZbq+x09JwgHueKwdDoXbZEIo270tNzPcZQU55s+nBmV3zlUfPWzmCLUSK0wGpogc3152tGtum304XYaNxDg8CGYMjzVSP3Zf4T/Cz2CB9ospZ7F0LhNuvLp29c3tKM10Y3yuuKaDugERmc7xdnSG0v4nitl7hbwNKxYTAmKbiDW0hIHsEGH/zthrNoBg8lQE6bTr45eacAcDN/x+ogTUCJBQGonlePMYqHDW7CSCiA5i/cK8HTuHOkxIk2p74/OhrmREstPTbriXhyfMiow58aWGIXApe3d9fdICCOD2tExX9GYmU0BbAR2bM40Fr7bIdVJGjZ0kA59ag3KRkawQcjx9VTq9B0GuY1Rw7fRB6gTLWXI7c7ETVuPRHYyqnyfp1lcsCSc10xFIvPgBjtVHZftlvVafMqn6aJeQUN2RhKRsm221NxzL7Y9q84T6+bEy6PHSoFw7ftGKItmltqcxeTNkgl0kETSD5DauxhD48EsUVIxn3p3BEhpHKAT6zGurO75GdptYZJYvD7WhpHNC7Gv2o4etnC9r+WoYKc4ag8Z7TMh24ZhKqqrYJfAPu4vgRUv+nzIADvMkpcnME0jwPIfAI+8M1S5bScthoYsVkEflwRHCty5k1wQglgl6BOo4ARB/+zgUMnXOFLwhLEBFrHj6cJCAEZkouxBfinMoulAiMuUzTQpUbLrisTFufr4XqOteTE5x3nl8ViYUjIeluxvQw4BR/8fTP5MXpDfJNERHKNpCg3g0ZpCaDHO/MRTPwEIW9CPsPl1MjHagcORqy1h+xRDSgYCdSK5Xr4fs0+/hMaWR87iLEWFr317Oxj6g7
 id0s83Ps
 Kkn9cpOByDnim97/5kMa4n10igdqnplxzkXilQBKQMkbXC6b0cq942CbFdO10FhzUDGwu74IDuThfjZukU0rgHxtnaVaeGk3FeTzckHpMsjC7TbQdGO6nHva+2yT1UB44NPQSqFfp/vBpKCibxbsuwvM2itXRxkPq/R5ll1DUCFX9/BN0RKJ2URwrL1A6TgF1BUQD2cOZNl1tfzNfnE7kmraTkgcSeboA2jsHoksDbMSwR+03ZneIkZlhagR633a10gHcrRuVxFhJaJI74WGypKZPMMv0GmjSXcLjUMofY+5qs1I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the function get_mem_cgroup_css_from_folio()
and the rcu read lock are employed to safeguard against the release
of the memory cgroup.

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 fs/fs-writeback.c                | 22 +++++++++++-----------
 include/linux/memcontrol.h       |  9 +++++++--
 include/trace/events/writeback.h |  3 +++
 mm/memcontrol.c                  | 14 ++++++++------
 4 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 7c75ed7e89799..c3442a38450ca 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -280,15 +280,13 @@ void __inode_attach_wb(struct inode *inode, struct folio *folio)
 	if (inode_cgwb_enabled(inode)) {
 		struct cgroup_subsys_state *memcg_css;
 
-		if (folio) {
-			memcg_css = mem_cgroup_css_from_folio(folio);
-			wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
-		} else {
-			/* must pin memcg_css, see wb_get_create() */
+		/* must pin memcg_css, see wb_get_create() */
+		if (folio)
+			memcg_css = get_mem_cgroup_css_from_folio(folio);
+		else
 			memcg_css = task_get_css(current, memory_cgrp_id);
-			wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
-			css_put(memcg_css);
-		}
+		wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
+		css_put(memcg_css);
 	}
 
 	if (!wb)
@@ -979,16 +977,16 @@ void wbc_account_cgroup_owner(struct writeback_control *wbc, struct folio *folio
 	if (!wbc->wb || wbc->no_cgroup_owner)
 		return;
 
-	css = mem_cgroup_css_from_folio(folio);
+	css = get_mem_cgroup_css_from_folio(folio);
 	/* dead cgroups shouldn't contribute to inode ownership arbitration */
 	if (!css_is_online(css))
-		return;
+		goto out;
 
 	id = css->id;
 
 	if (id == wbc->wb_id) {
 		wbc->wb_bytes += bytes;
-		return;
+		goto out;
 	}
 
 	if (id == wbc->wb_lcand_id)
@@ -1001,6 +999,8 @@ void wbc_account_cgroup_owner(struct writeback_control *wbc, struct folio *folio
 		wbc->wb_tcand_bytes += bytes;
 	else
 		wbc->wb_tcand_bytes -= min(bytes, wbc->wb_tcand_bytes);
+out:
+	css_put(css);
 }
 EXPORT_SYMBOL_GPL(wbc_account_cgroup_owner);
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f4b6158b77d8e..20d38262b984b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -895,7 +895,7 @@ static inline bool mm_match_cgroup(struct mm_struct *mm,
 	return match;
 }
 
-struct cgroup_subsys_state *mem_cgroup_css_from_folio(struct folio *folio);
+struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio);
 ino_t page_cgroup_ino(struct page *page);
 
 static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
@@ -1564,9 +1564,14 @@ static inline void mem_cgroup_track_foreign_dirty(struct folio *folio,
 	if (mem_cgroup_disabled())
 		return;
 
+	if (!folio_memcg_charged(folio))
+		return;
+
+	rcu_read_lock();
 	memcg = folio_memcg(folio);
-	if (unlikely(memcg && &memcg->css != wb->memcg_css))
+	if (unlikely(&memcg->css != wb->memcg_css))
 		mem_cgroup_track_foreign_dirty_slowpath(folio, wb);
+	rcu_read_unlock();
 }
 
 void mem_cgroup_flush_foreign(struct bdi_writeback *wb);
diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
index 4d3d8c8f3a1bc..b849b8cc96b1e 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -294,7 +294,10 @@ TRACE_EVENT(track_foreign_dirty,
 		__entry->ino		= inode ? inode->i_ino : 0;
 		__entry->memcg_id	= wb->memcg_css->id;
 		__entry->cgroup_ino	= __trace_wb_assign_cgroup(wb);
+
+		rcu_read_lock();
 		__entry->page_cgroup_ino = cgroup_ino(folio_memcg(folio)->css.cgroup);
+		rcu_read_unlock();
 	),
 
 	TP_printk("bdi %s[%llu]: ino=%lu memcg_id=%u cgroup_ino=%lu page_cgroup_ino=%lu",
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4820919c0d219..a4bb8b8b2c457 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -244,7 +244,7 @@ DEFINE_STATIC_KEY_FALSE(memcg_bpf_enabled_key);
 EXPORT_SYMBOL(memcg_bpf_enabled_key);
 
 /**
- * mem_cgroup_css_from_folio - css of the memcg associated with a folio
+ * get_mem_cgroup_css_from_folio - acquire a css of the memcg associated with a folio
  * @folio: folio of interest
  *
  * If memcg is bound to the default hierarchy, css of the memcg associated
@@ -254,14 +254,16 @@ EXPORT_SYMBOL(memcg_bpf_enabled_key);
  * If memcg is bound to a traditional hierarchy, the css of root_mem_cgroup
  * is returned.
  */
-struct cgroup_subsys_state *mem_cgroup_css_from_folio(struct folio *folio)
+struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 
-	if (!memcg || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		memcg = root_mem_cgroup;
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return &root_mem_cgroup->css;
 
-	return &memcg->css;
+	memcg = get_mem_cgroup_from_folio(folio);
+
+	return memcg ? &memcg->css : &root_mem_cgroup->css;
 }
 
 /**
-- 
2.20.1


