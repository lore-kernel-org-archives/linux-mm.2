Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96B73D64087
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 088F26B009F; Wed, 17 Dec 2025 02:30:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03FF16B00A1; Wed, 17 Dec 2025 02:30:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB2C6B00A2; Wed, 17 Dec 2025 02:30:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D51386B009F
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:30:52 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A17CB140923
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:30:52 +0000 (UTC)
X-FDA: 84228141144.26.5EA5C07
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0CC5DA0007
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:30:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZrvJVvvW;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cb8NWIyZ/ts5sKA8lazTxoYJ+MrmJmaOEPm0Hg1IF8Q=;
	b=1fWFA1Q9TKA7L7M1rLyx+W4mpOp4obX4n/BBDtqNd+hmaTfFoFexiep000K7rhCLil3RW4
	wqrM+5f8l7MGxZDIh/QxGL0705as5r6Q5sqmKQxCZ5Gg4ZXRt6BV6uz0Rkg61FraCnRKFg
	AUr9HPSJRZHGz+536dvUqWLLFvYk3rE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956651; a=rsa-sha256;
	cv=none;
	b=Zx3vLjRS+QXkJDfuT97p8drOGsIEEo73VgWhtKuysP9DBkNBIoGVlsBA+u3mJi4739RfX1
	9Y+Jabw45F5/Wnf+dbGIZ4QA7AJuptbghGl64quUMuTCjppuG7C5mbwKUr3LKl8CItfKsk
	11byjYFPccCPMhKO72IADumPdFY5cjQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZrvJVvvW;
	spf=pass (imf15.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cb8NWIyZ/ts5sKA8lazTxoYJ+MrmJmaOEPm0Hg1IF8Q=;
	b=ZrvJVvvWuNeMXQL9pMRHM4uWZyvvIGS4eeGanGz2oB/X+b3VfcEuyVIps/0tthZkAdqdER
	WYYXtlOzeXulJisgMUeJS2MAmu/yMhGhzaCnO4JeGiEvFWXmp/3gOQMVYWVe8xAjW17tZ+
	omsRM5kP270T8TDwabvlJGBS3joq4mA=
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
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 10/28] writeback: prevent memory cgroup release in writeback module
Date: Wed, 17 Dec 2025 15:27:34 +0800
Message-ID: <d2863fabba49a16572a84163e42cbce64aee27c9.1765956025.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: hxmgs93m6bsc1axxqc9grw3wt6jg3sug
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0CC5DA0007
X-Rspam-User: 
X-HE-Tag: 1765956650-693037
X-HE-Meta: U2FsdGVkX19Vz2PR1JJRUUFgFLJQgSUQk5qrLlvW2o2MzhmfetFbPhn2tclD/MV+XXjBdcoqer9cYXFqngAqYoIYOtI+ChDwaD/IcKE2/Lilt8e1KHihzQF/UZhvF9kgXvqKKACC+fcSuIEXEEQ9tiR5Xb/Fco28KW10jNUwW8qjdR20tXBhwiulAcV3Ee5NgfbF/KUoQeIMjmgt85/o611vdyTrZRFDIF9DV2lgY/hkWyClG0T/ggL6MvibvT7tr22/8I9EOm5vNXB4F9fswzNLERjJt7nR483m4SAvRjcOER3x04OsgPK8V5cKogQ2Up1CiUdPkwHWAjmwBVVvR0db0GeZvBgUTG4iWc3/+gS41sDeRdYCHzXpMaIRcbbGHpuiH/WFWRvxShzyaeIttC0NRx0iOjDTUTn4OOOYTAFdGle9HIDOPJxbqwOafMkd/SJWkD3doqGDSUD1umpotZS/A2LEinhsRxw2v8XCjy+A3XW8H2N8cRyUaLCaMltXF5715rcks4RlWI2tyB6BRh9trFvWcOJfrwNe206i+QVlWK1H7fwUyzslQ3OlrSueZVvP2dBrH75gQNmesCyslo2reE55zlukJv98mufUn0I26aqEzLjSmCaAbMzv5dZmciYY9YnOtbgc1BRRkSCpFKdR/sAXPuxXZBSJNcHXq27/sm0v1dMLW10BPsxz3x1+vcAzwEzFdkzQaGWx5CdSZblm5OutSkiKzaIqeExdIqjUnws9M11iNT0f6pXimu1K585nXJ2SUZnkSBxARGxEsKyUPkNPSJoA7ROynR7/1W/h5kkMjF8RM7nmR5nXVn7ZUkga53CZsfW3ae8WBaUwOQvqr+oj/PtTz4LP600Rz2grZeHcQNUvi/MQvA1eUIg1KgwpWhK9Lh3rNyLTmXqFBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
---
 fs/fs-writeback.c                | 22 +++++++++++-----------
 include/linux/memcontrol.h       |  9 +++++++--
 include/trace/events/writeback.h |  3 +++
 mm/memcontrol.c                  | 14 ++++++++------
 4 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5dd6e89a6d29e..2e57b7e2b4453 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -279,15 +279,13 @@ void __inode_attach_wb(struct inode *inode, struct folio *folio)
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
index 776d9be1f446a..bc526e0d37e0b 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -895,7 +895,7 @@ static inline bool mm_match_cgroup(struct mm_struct *mm,
 	return match;
 }
 
-struct cgroup_subsys_state *mem_cgroup_css_from_folio(struct folio *folio);
+struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio);
 ino_t page_cgroup_ino(struct page *page);
 
 static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
@@ -1549,9 +1549,14 @@ static inline void mem_cgroup_track_foreign_dirty(struct folio *folio,
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
index 311a341e6fe42..f5bfe8c1a160a 100644
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -295,7 +295,10 @@ TRACE_EVENT(track_foreign_dirty,
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
index 431b3154c70c5..131f940c03fa0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -241,7 +241,7 @@ DEFINE_STATIC_KEY_FALSE(memcg_bpf_enabled_key);
 EXPORT_SYMBOL(memcg_bpf_enabled_key);
 
 /**
- * mem_cgroup_css_from_folio - css of the memcg associated with a folio
+ * get_mem_cgroup_css_from_folio - acquire a css of the memcg associated with a folio
  * @folio: folio of interest
  *
  * If memcg is bound to the default hierarchy, css of the memcg associated
@@ -251,14 +251,16 @@ EXPORT_SYMBOL(memcg_bpf_enabled_key);
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


