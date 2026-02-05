Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8B22E91297
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DC6D6B009B; Thu,  5 Feb 2026 04:02:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29C996B00A4; Thu,  5 Feb 2026 04:02:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15DDB6B00A6; Thu,  5 Feb 2026 04:02:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 051536B009B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:02:32 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A805258F72
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:02:31 +0000 (UTC)
X-FDA: 84409812102.25.FCF5732
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id D9B3040002
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:02:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gJvM0GXf;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVG4FBtA5C8lZDYA783TBUFJRw1YsphndfITKeVR5Jk=;
	b=B3F2ryB4POhnnZIoht0aq2VL157ki5SdSJRuuPPXaS26RxcEgJ+LFHvuAOOwdr8RI9mIch
	W4W0mzTuf7FwbNKb0xwN7xun4Ibs2cpNxkMVHmlsOeHznpo7cguQCKpBwiNafg7EioVEJi
	1ReG1jvwBlzziMRi4Ou0dOsVRsoGreQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gJvM0GXf;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282150; a=rsa-sha256;
	cv=none;
	b=lYECcXEihy6QlXl2MIWsydxA7TcSXyPfTKRM/9h9jnJpguQ4ACdfW5HGEcTp24C8lmVwlc
	Um7GRPmXPAyM0OlEcGJ62A4JmtB8g94Kgf6d9wE3zcO11dBzwHRC4kInJTg4W4jcPRWs1F
	JN9k+0a280jSYdmeNLzUzv4R8udxJm0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rVG4FBtA5C8lZDYA783TBUFJRw1YsphndfITKeVR5Jk=;
	b=gJvM0GXfYQygWkW4Ct+rwyYQkDXLMBc3fP697JvVIMEZedGgIR8TI28dyqAoOkaQ9blK/h
	D3CJvfPRZbVKCShjyWCz8Zde7Vf+fXSIeTOP19Qt4JAlKVhS0+PtMtGXKzjBbLVZkGJ8BM
	SDe5BdzPXCcuGS6rcjBS2ydOuV0l34Q=
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
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 10/31] writeback: prevent memory cgroup release in writeback module
Date: Thu,  5 Feb 2026 17:01:29 +0800
Message-ID: <46e2df6f69837b0f12e1ad1307c0f32334939dc5.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: qpdexeij8xkeugqi9qy3433unn9fj1xh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D9B3040002
X-HE-Tag: 1770282149-949514
X-HE-Meta: U2FsdGVkX18OQEZ2d0O1dvvwLKlR7yCDG/3e1RxZ5xeO70iZzJcWcGV7WKsGUkdIJuM4u7CCELgscQmBB3wA6Aq6fuxtkdZ724cVf0ikpqEwgn/B5baAGQRj7dwNlaUGEDdUDlvlruIuzEpV0ktz42HXTeuITk5eB9LrIiCXmg3UEHMx9zINSdiXUC2fEj430sQ6LGD/1TfHd0iTyRaIvXV+IPPvCgLjxAXCdp1ac0Oz48fYFGVyVnXj6qe/jknUJNBbMMfi6zUANOCh3EEvNAwgftQdJNBw723Es+eMsqYsCw72mOKz3FIYE4ZZdvP3HUsocghn7HeeNekRLuw2aQqULTnq14tcUYI3iNSH+QXhBpC7aSp24BzXSj3JCsevISA0obYMrgpe1LHBcnFxuMHbJx+oWKqDQNrZAo7LPAfZDejEbRSg9CT9zZrEVFlTKAOvUdkHEs3oxncbovi2Wzx1/YyxLsPE1n06MTdwms/jL7bGMC0NzizhSmtzKKZDwMvh5PU+0Uc/q8brYpnbBKm54+JpxeRreYoDxXg9qVLaL2vPPHSbrsX8rKu6i6oHCGvPW1DUhaspEugNd0Ff58nKwacqo7ydPz4ISPGxdSMKpGsWOdSPlJQNtSSQYvwBZ9On05cRS/8y7RDuxKe5ihsyvi08280O6BuJ/lFjj6AuhKkAjM/f2MIPIqsGwz5eiUs8f/hqQxZbQEIfFnU2n+s8Pmxi0iyi1NtRzG/Wx/Zj5dHO1BJRdXehsWrcMPZiu6RTtsr8xS/3rm+lb+3cvC/A+idSQuPCJTlEl/7B4BDLXdZGpAOVpZ2CP0tGSi7+L+h6buImR01Nt1RGyv2+cK0WqQdORn017pSq7K6r2vDBt3bTD3kes6M2pcUWIhUxCao1A7rjEkRFjm+xmguo5FgpMDQJJCXe2QaqwXhLyEClXKmW4EElksgyR/B5QcdhsMroOWKWLt272HRXA4q
 fJM3wLoU
 NbzFh6KHC0j+4IB7XEriCqrvGTuKipk0atSFiOVIslvdKcuNiQWu89kSJPTT385zzJZLVzKJAFnTKPprghaPgH8+ZMW5GCuTYD7YsujP+OaVANvuoGhRv6LJj4CS5Rfl820zZiBpiDkfcowm6b320zLOUvE06s59ZA6/kVj1VOrdTpZsktshdab5umSOlNVxmSACUJnnfjwqTGp1+IIgnCjbmsF7lm8Ogq1u4m5i1rH/JKtmzunwMlIY47mtete0IRk/Mi+X2tXpiOokzBhiA1Ocf7aI5ibguIAmdUn0LN0eWm0k=
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
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 fs/fs-writeback.c                | 22 +++++++++++-----------
 include/linux/memcontrol.h       |  9 +++++++--
 include/trace/events/writeback.h |  3 +++
 mm/memcontrol.c                  | 14 ++++++++------
 4 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 68228bf89b82e..1a527ce28514d 100644
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
index 7b3d8f341ff10..6b987f7089ca4 100644
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
index 9e7b00f1450e7..5508a4aced0cc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -243,7 +243,7 @@ DEFINE_STATIC_KEY_FALSE(memcg_bpf_enabled_key);
 EXPORT_SYMBOL(memcg_bpf_enabled_key);
 
 /**
- * mem_cgroup_css_from_folio - css of the memcg associated with a folio
+ * get_mem_cgroup_css_from_folio - acquire a css of the memcg associated with a folio
  * @folio: folio of interest
  *
  * If memcg is bound to the default hierarchy, css of the memcg associated
@@ -253,14 +253,16 @@ EXPORT_SYMBOL(memcg_bpf_enabled_key);
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


