Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3922F30951
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 11:55:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16CDF6B00A5; Thu,  5 Mar 2026 06:55:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1347B6B00A7; Thu,  5 Mar 2026 06:55:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035BE6B00A8; Thu,  5 Mar 2026 06:55:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E54B86B00A5
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:55:57 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ABAB0C2D1E
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:55:57 +0000 (UTC)
X-FDA: 84511855554.06.07515F4
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5C21AC000B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 11:55:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pb6WKb5m;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772711754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7g4zlvI4KL5BM3hQhoVvcLwONpSLS6QDIXKeCKwliro=;
	b=YAimTwtXLLYlef00WmsevSMg1UptJV3cb+VEv9aloM+K06W9F9kMT+X9Om1z2b/X8iEqoh
	Toy784FRNyhlEQe5g3A2k3HtXCIlK7Doo6CTNL+C0dF6JVSOAjZUIqARPasYfqNrNMzRwF
	rgzVtq4957uP1K/RdCnV+Yh9txVyfRM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Pb6WKb5m;
	spf=pass (imf28.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772711754; a=rsa-sha256;
	cv=none;
	b=vCwisocANx4rcUnda/0GmSyj+mhniYCr3SGRaQu/q7DYBSLcbBzdv5rkou6ZF04fQc+jDN
	cHjha/xpMEzTZa4IqSXBIx7jrYL7ENWfxmuy2sUV7BxGYKKZu8eK6EVljPQDtdppt1i1p8
	O5MGuLfGF9RzqL15IWU+JBFsmwBgtRY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772711752;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7g4zlvI4KL5BM3hQhoVvcLwONpSLS6QDIXKeCKwliro=;
	b=Pb6WKb5mz/1V1WY0eot4/pZLnwSOkyFz2Lzw8N3G+lPEzpxbDxUTlbXrGgDlF2tztpheTp
	93mVBUBBnl/qzFMK1rAbrS6RsSXQ4dyPaLwlGTNCXmU152hwx4J4C1yCAIohg+SU0p/nz5
	Pw2uIUZUgDgYZnRJlE3XqFM4pliL338=
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
Subject: [PATCH v6 10/33] writeback: prevent memory cgroup release in writeback module
Date: Thu,  5 Mar 2026 19:52:28 +0800
Message-ID: <645f99bc344575417f67def3744f975596df2793.1772711148.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1772711148.git.zhengqi.arch@bytedance.com>
References: <cover.1772711148.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5C21AC000B
X-Rspamd-Server: rspam07
X-Stat-Signature: y35m1s5b1rdzujnzooaktcmedwij3ziy
X-Rspam-User: 
X-HE-Tag: 1772711754-703237
X-HE-Meta: U2FsdGVkX19gUZozmE5lkqjzBp5mm3OZZfVuvdoOV+C2aUC8IJeW9d/UtSVauD8zHm/Vvw2SAtdn+5wns8RT1miJ8RkMXWnY0QrdSZB6EgN9AM2ZORt//gWmLy6T4Ff7yIpQ3RqhJT0dlLFfdzjseTS4Hv8oLOBJ0W4rMSbCDAsYWAMpBbsvG28vDb1FmbUX4VySHCS6pGnmIo6LNpNiP37NV2aJ/HAVdNYyz7uETXYnLST4gnwyqUFrLW/WPUgtrMi46tg/WF68yEc904BGwBZPPHcXJ8lv2UAaGoxCxmW3JZdmQEO920NC7+wmkZBf6NGVXc6mSWyyM8EatEXDJ4M6NcqDJoo+kX9efAM+lS1IdEpV9NFXS/YHMw4lYTbhMzCW9DaAJHfO+qNBpsru76DGLUNT0/gBBfRoitaL+ri1RzvwNA//nEeVHXMflFExcPPUSRbkmZLxRoo/waiEYr6qIXIOMs7OdsV+8QpU9yuU33k8TROpCiaYt4/OKRycBTeY67DG3S+VwUV0/OXxdN442i1eEFWlrQdi8TvBoJKHfNzQ1ToeNWznbSr/BwVwf3hTF7q+vbFuuxOKcZAmORZscM6aB0knoQvChuRfAcCqRnc76cmIGB89Ni4Bxr9gWMhribeSbjGvA9U5j8N+FwG8xFQId9uHE2dIjKQ7PQ/NA4jL1jQFDR7kPgaz6ejGtE+UHwYz6wL8kFDXlgdB4I2+//BN0LSVUXvQizsoUhfaRikgrOzAFwvZARMc/rMqhqsuul4vBlRmP5TMNwLm0670mIM2mXJwxMWyMgZweJ0WX4LEyVXux2bsAswIS9J46GRkRmDOpjL3c/LDRgeYhbSOB9/hWTJwrlktIyRHKSCV2UktRmEHT0clF00kXsyn42Z5/M8jKjvER/g4twkCu3TYtdjOJYM5pzpgac93JBvW1A1qj5/UGOgUhY0AGdE7L+Z8jTCRRHO83Hx5Kkb
 zRqmmtjs
 7rDhpcN/CObp385GniP9mA7Z63QbzGVwPsEspmqdqQn0JnThhRaWCmmN4E5zk9Niw0GIddBS9Sdk+N7nnlrag4shHuaCSnzI9RkC+yvz//1cc/i7NZ47srDxhgNG+9U+eGPeMQBoudsuJhFGd7WC14W9PoQOZjQuM5EJpL0oJQX5M1u86ICENxkwQnd7JsZ5zDFZoCHYQDchVvTRMsfQHrLQa2YE+s7+E+gYv9c5oXvjzbzWkio+EhQRyKH+P6u1rclZMawEwppHuDDS5P0leQkQa3Chky22RoDDNlZXp8CPpHdA=
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


