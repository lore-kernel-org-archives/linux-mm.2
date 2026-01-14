Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ADF8D29FF0
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 974296B008C; Wed, 14 Jan 2026 06:33:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933E86B0098; Wed, 14 Jan 2026 06:33:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849F06B0099; Wed, 14 Jan 2026 06:33:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 756A96B008C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:33:44 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4089058ECE
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:33:44 +0000 (UTC)
X-FDA: 84330359568.07.2B27393
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7EA3D140002
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:33:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FWn2+YoK;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lowH7ZuggXsh4o8HoJ358lFHSoT+96d+VXAyFVrxIQE=;
	b=jtAlc5Mn57X4l3QZdXc071oz9CRLYKkvgXgtHrVt7dRIOXEWNXzbwKOOpgIDHeypHYfS5Q
	84Y1pp5hdcIfRsn8xa71L9XpQlBDJ+p9iBbC3YMrHThDXOk0OQeuKy7jbQQEuFVtqvum/Q
	QjFzZp2JWF5o/Grl51mbkjsFopomTFY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390422; a=rsa-sha256;
	cv=none;
	b=5YVWgy/RaeGH53HuBoxKsRAzoUHKKGgQPufVeBZQVGYds3G7cW/mj3z5F7fypCkePG4LYS
	KAZZqZEAU8c5V+jyk7NNfST9ofumdI2b7/CIPJi+OgaP/Fn6N9HOLX8G9rXdrOHnKCbxbR
	2KgkBj2HJcI8o8TtxbnBYo/ajjbs/qM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FWn2+YoK;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lowH7ZuggXsh4o8HoJ358lFHSoT+96d+VXAyFVrxIQE=;
	b=FWn2+YoKCAO5CwUQgOav6AVHdT/sElug8yrqI+/YSiaWqdp2fBPxaAk4GBIpBBVTmPg2Mg
	exZYh47LypqDMbCynZVuCw+1bgiug4rOflzCKwXZHOMgDInuks9QJRQiffR3ZMg2wAqD7n
	oStTtVk8094nMPN/1CIcwjo6BWEqHMI=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 10/30] writeback: prevent memory cgroup release in writeback module
Date: Wed, 14 Jan 2026 19:32:37 +0800
Message-ID: <cd8d4f4292b9f6b20379f6782f01ec2a1d90b305.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7EA3D140002
X-Rspam-User: 
X-Stat-Signature: rshd54w8ph4zh1e4hoek9umdrgf9iazy
X-HE-Tag: 1768390422-584820
X-HE-Meta: U2FsdGVkX19zpdM5tIRxbOVejj7xx5a98zIeGOfq95boCGK3qPavokrdtIuv8PD4D/P+66HpdKFLIjNwtEIeejXmdpt1tdTZxq2z1gghYcQUbfNltj+/X4Xv9i5gDBqbIEQoEXWwnBLeXIChzUQWNknMgWRoQzTRyrG7AB8m7Tlq0wVup4Fu0nY5rmWS/IVqQd0wkgKUApLX7wLgNXK0MJURKH+R9+Old4kS6kmJ9zAOuWjxcPIe7Hrr2jkjz53LpgbwiNoUQpiaAn75MvOo6xnEUBnkNHnTfg9ymLMZ0gOlHom049EV7TO+XNPsIgU5KXY6uOGz4Xxjgg2C/X/uzQln7ShK5hVq/FlV7CFZvQd+MAvPVPP/ME556RPMuw2XygRMSMMeC8Yn88ed7jth9u1O8wSJu/be5Nkr1YFkXR9k1xdJxYq4qr/O20dgHm8ixaO3Z+43OBLjfjpiY2ycba8uf0ihzLtCch1cemh3H5nhJQmv6Qfp3o4T5D0EIqiFlPy71AAIE0J0E4IhzLlqHQuk8zjwMIwW0gFWuavaMNOyQ8384zcCHTbdMxWPXBR9ATVIBZCqIDXArxilCIKkKD8zB9NUkeneeNwRODjP02eLdkooYTQzF0ZTjCdMMsYFSjsInLk3zEid3WgIW9ac+sa4r9uBszYApr/P9ZnTH9Pl1e7oAcsng9uN9sSBONqeV0AVKEOu1if+A3J2mRpix3eb58qeG9BXddD6RovoESLOi1zNnpXUnzPXaOHHPzO4SJ/I2hZTgUb974GTxRxkDEvbUVc/glpW91aV6zLS9vyGchFwTZzD/M0YIt5NIdhDr+CYhjclvhBvo5DK3wdQJKrhlftRc2XdGv2MXUYGyEDnAq88ob+7ASMZW3KXCEzrTkKHxvK79aYfOH3iCQ+N8E+WmeXXf3nB62dd9cH6zV0Ax1W2v7EsyW4f/dvIP/777zmXW4K0Yqph1t5ixP/
 OVyuwRzX
 0eBS/ZXLfpGny/hnNywrQCg3RtI4A1TCocWLisW6fZQEZAoC1eb1tkTKVWGYiOh9voQkI4qwypQ0GkLybnxpkRfhVxDYCYyzgaozIvLD0qdtlV7srMkjPU0KpfoEdLQWnn1xpkfY0bSBJuMYORewdXdOZ/ZuhPq0rYnhZldoqO0jBU50UiQuqHlnYeGf7gtFMz2zZbVkZNZr7J3GoMIhhit9xRnH1MJbesEvmCz0YkuP4c27w0Mwc6X2dFlnUK8rDK73+lV4atDjoskjxAoCnAZzFOXytQ/8uzBrEyMcXRyDcS8g=
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
index d061666b733c7..d35606e3bc2e9 100644
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
index 0458fc2e810ff..b5d4139ea1aaa 100644
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


