Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B030ACCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EE7280155; Tue, 28 Oct 2025 10:03:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19F298013F; Tue, 28 Oct 2025 10:03:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0670880155; Tue, 28 Oct 2025 10:03:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E37E68013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:03:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9E781604A6
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:03:14 +0000 (UTC)
X-FDA: 84047689908.20.77943BE
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7F67318001F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:03:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bp6a9gAz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660192; a=rsa-sha256;
	cv=none;
	b=tYTw1Ii5dafZmq5Rw6qoXF6UNtL3tjJvOn4DyIkAD+zMu7ZGlZs6H0BrfkmX45hCLUoghg
	ajmsgfjad2hXk9Pk3m/Im6liyuMer6stjJ3XW+cRtrd35o48lvt9/0aDz3mNnN1X79q3xY
	Pc0Jn6UmOlamx/P+XxNzOCfLsDitUa4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bp6a9gAz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdeP1C9lZUf/BHy9VyO6H/2ZkQY+8y2qy7tx97P5h/I=;
	b=U57r4pTLGxD37ZvDvIQ+qabsbCngMefbzaLktIjR14hAJAVFwZiLOH73efN3WahTrEIiPK
	qTI2itz44HVB1HgZ7u999BS3nFvBtxOdPyHMgMvX9xwEQyfKJrqRPh9UeVAAgbkVM5EP67
	42AKCuAMSYRH9CoZk5MKSsypzXT93pY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SdeP1C9lZUf/BHy9VyO6H/2ZkQY+8y2qy7tx97P5h/I=;
	b=bp6a9gAztickZhcVXAzCYe6KGXExJZWpvLQghvCnTrMnB8k9/ms5522DdHvjaBQXwl1RP/
	1YHo2+jDweAPtLcq9U1Cb3e57rrqkh4/RyV+G7msuW0Jz/HOa8JsbwwuEnjip7pOA7mM6l
	35opjXquzD26S/pjcE8ZenFRa/5aYXs=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 09/26] writeback: prevent memory cgroup release in writeback module
Date: Tue, 28 Oct 2025 21:58:22 +0800
Message-ID: <c1d571a61dcd8591da86e5dc036175f076cfbf1d.1761658310.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ss9qn8jy6y8i198iekjwdujzsafqwaq3
X-Rspamd-Queue-Id: 7F67318001F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761660192-210177
X-HE-Meta: U2FsdGVkX1+h0qsb1OjM2P8xsP/KMcpLQgeQcd5YB+AxHKo5EY/egcl/4nWoFvyKCNDvKaFees7/z+HTs7DD8zig1HyVHxQN6qMNlymZqmUAOSgy2FP8QigQ90Jzxo7cqfjvjOVnvkb72N7cLukxMeDODUws49FPkRL7/K0NG+8YeILwnWK5mQRtImmRx8TF1R9j+/71weBsecCBHBPDyMp3gFtAguvXBjr0jX66Pzw9XBtHQaGVrc7qXL3APfUPIeJp1vfJKsnR87vEEd3QzwDQ8BrfX4q+odRgsEVsiTm2KFSLLJisDF2TlICPHk+VLlobft7ay+jp4fPy4xaRdP98C0g9HazacBfqxeOgVK8jLPM5OMV6pemMqEYEqRoYtkbvcIfZlsEduE9yjpgoHsQvI6QqpoS49QSlf+q7l7i+Tp8dM3+epZmbttzxdspNFiC2Zq09jYabFb9tHMVq5FQvgBnr6S7J3DDneinMvPfweHC2VCm6w0S9II5Y0gSo8oUlbS6wsNwvDJntRnp8KOiDlSp9Mgtf3EKtYvaMiuOBQ9ELCNFa282vhq8Uz8uBBLs7qQL73tBe3+ZPZLpfO1sJAiBtZFFq51Ie8PN8bQUOW4e0nsBTgx0b96qhu0VtDLzcm6JYe7zv8fzmavk3ufBBe1w8LZYIUKYs24MsJ4p/q2Ad5Vl8Z2P/KPtZeynqKitqcrFdjpzPoMS5l5xcb1Us42qXI0djY/xsPUdqBBzkVYgMUHu7fhLuGUq61evWwmAvYKCNbhGDNORaiGHQjvAI9Jfw1bIXeY08JV/ei8g4hJtdK5RRWNoYbyOAwUhepah6nlMJ5xaJPVI6QA2cRrh8cf+lzSPVfk/iQYAOCt1CP+qEZcElaOOogfJDE4HIBEhIml7LOHUEB6qyUYSLgSCUOY1dTcr17B96i9RhJxR1c/pU+FwSDt5Lgh5C5NFdyhMLDY+1O8idmdR/t5k
 zwbiu32w
 W2dnJ0Mni2tsfneJ1OETUm604tmDp0tBdvmliaXsixLb/5Pdp5xh9ayvo+GuqisQDycjDDY1UTOqPFeSPcHTf/X2RXA+TTpF0Q03GHtrneAVmLtfepqfUZYgsZDgDoCJ8bR61g30Gv0EiFrMdqceTBxFfMQ8s3l/AEN1brfzsPdwUw8lC1727VqDJAkokiJ1s9F9+MAQE8sGxhcbQy2MIqmTezQ==
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
---
 fs/fs-writeback.c                | 22 +++++++++++-----------
 include/linux/memcontrol.h       |  9 +++++++--
 include/trace/events/writeback.h |  3 +++
 mm/memcontrol.c                  | 14 ++++++++------
 4 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 2b35e80037fee..afd81fb8100cb 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -269,15 +269,13 @@ void __inode_attach_wb(struct inode *inode, struct folio *folio)
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
@@ -968,16 +966,16 @@ void wbc_account_cgroup_owner(struct writeback_control *wbc, struct folio *folio
 	if (!wbc->wb || wbc->no_cgroup_owner)
 		return;
 
-	css = mem_cgroup_css_from_folio(folio);
+	css = get_mem_cgroup_css_from_folio(folio);
 	/* dead cgroups shouldn't contribute to inode ownership arbitration */
 	if (!(css->flags & CSS_ONLINE))
-		return;
+		goto out;
 
 	id = css->id;
 
 	if (id == wbc->wb_id) {
 		wbc->wb_bytes += bytes;
-		return;
+		goto out;
 	}
 
 	if (id == wbc->wb_lcand_id)
@@ -990,6 +988,8 @@ void wbc_account_cgroup_owner(struct writeback_control *wbc, struct folio *folio
 		wbc->wb_tcand_bytes += bytes;
 	else
 		wbc->wb_tcand_bytes -= min(bytes, wbc->wb_tcand_bytes);
+out:
+	css_put(css);
 }
 EXPORT_SYMBOL_GPL(wbc_account_cgroup_owner);
 
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9fdbd4970021d..174e52d8e7039 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -895,7 +895,7 @@ static inline bool mm_match_cgroup(struct mm_struct *mm,
 	return match;
 }
 
-struct cgroup_subsys_state *mem_cgroup_css_from_folio(struct folio *folio);
+struct cgroup_subsys_state *get_mem_cgroup_css_from_folio(struct folio *folio);
 ino_t page_cgroup_ino(struct page *page);
 
 static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
@@ -1577,9 +1577,14 @@ static inline void mem_cgroup_track_foreign_dirty(struct folio *folio,
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
index c08aff044e807..3680828727f23 100644
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
index 1da3ad77054d3..aa8945c4ee383 100644
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


