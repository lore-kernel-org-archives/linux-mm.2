Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3CD6F01808
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 07:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55D4D6B008A; Fri,  6 Mar 2026 02:59:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507A06B008C; Fri,  6 Mar 2026 02:59:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4003C6B0092; Fri,  6 Mar 2026 02:59:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 303D66B008A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 02:59:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C233314046B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:59:37 +0000 (UTC)
X-FDA: 84514888794.19.9877023
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id E4DB3C0009
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:59:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=WZ99aRBO;
	spf=pass (imf10.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772783976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PiiIe69GsFq8HWnkBbJ0yBz0EjYwZDUtJMK8tMs0bEk=;
	b=CIdq1qNEQCxwC9xCoUrnc1tYxB8hF5xV6geqzErScr5S0L7Cu0TNMThT60ygWn1lNsO+co
	gx2oFYRi1RFB40KWGFx3ffmNPRKrHXJKIlB+RPVbiKnHhad183PfzbABq7H+CoD3TcSkqC
	z9XrS1BqjbktUfhm9FMVvuftuxYpkHM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=WZ99aRBO;
	spf=pass (imf10.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772783976; a=rsa-sha256;
	cv=none;
	b=29/HUcrTG45/xU3PyYdo1+4JiETPp+I+84pI6hN1/sW5wM1KqlsdghMTSNswSCM74GAgK0
	AQgokI5JisFikBjPhgEUqWL7BG5jQtt10bQ0iRdDJS3f0u+uqO0LmnGzcGrh1fLs8ocRhW
	4fCyNxcybpZ92i+cMHVtT7aMQsl+XyM=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3567e2b4159so4895637a91.0
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 23:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1772783975; x=1773388775; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PiiIe69GsFq8HWnkBbJ0yBz0EjYwZDUtJMK8tMs0bEk=;
        b=WZ99aRBORx5KQLcbt6RyKXzEuMAI4rWt6WMwNcRY5gy+DEic4eVbwcK3UWZUbG9WhS
         SL+4VfqfAE270nqVGKvCGwhDHrpXXnfhzbrpDLhvdSX/ujZuUaYtVLS/iVtoB5esKWuV
         1ndi8HJT2FpRRLObzz0kB6AGAvpp4mcT/5/NPhK3/xqnLCSdQGu/elBmz+Oc0UOUyofN
         85aNIrJWjG/Re6fch0oSlpVcsvPQMIOUktGfFsW4dyMuLgsd700PPcLzDQFCkZL0TNNG
         VsY7oTtgJZ1i/7sJ58ocOVzZJhFm+APeqQV6iCRm0Q8KpF1R6ukdta3deGOpNsLrHYY6
         YLGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772783975; x=1773388775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PiiIe69GsFq8HWnkBbJ0yBz0EjYwZDUtJMK8tMs0bEk=;
        b=ZZlG+7Aol1s6lN4OJWJkXUkWcSDxc4sq5AD0mduoY2n2BRKslUzviXN/PLvyymhN4q
         OLYsfFDTIgrbtatTUE9GTP0i3OLwjVn7146ljSc13kYJDDISPUbvfolwiuX17ehU3rYb
         oaAoWJULdGbpeo2sfFGiNJAGnhEKu1p9f8cGyWelwXkoVXJIGb1421p2QhBRLkyQEQ2I
         bYj/13SPOAlTxmzssV/fwvH90g2LxohO9o2128qu2UI2wgF546wPwSEBwrTk1c0MKyAz
         7ECeAGsT0OTjsj/aULxpHZaOZfYh7IPTMbk2jTe2Fd1V/pTkMViOqn15fZdbcm1LzGI5
         cwvg==
X-Forwarded-Encrypted: i=1; AJvYcCXb4SlhgYrbqFkBOl3iRt5hw/xB+55Fpx89l9JxxTcyM8TIvSLqhBpn2JRYo3wjJ0Nz30J/CJMKGg==@kvack.org
X-Gm-Message-State: AOJu0YwBKGBnXj0AZq7tMYh8l9vlflMX2sc7K7qKFNpV/Fg29qBeWqU9
	3ozybDRleUBMb/C6eZm2WMfsZCC/dbFrWh4rhyARKt/lC6OHVWoZJnt6Uo9AyT1KHRE=
X-Gm-Gg: ATEYQzygVHWwTyR0N6BkZWehUJ5q8rSIEuVDAozjU1ih1I6Vtlc4dtjJ7fhv/OPd6nK
	rx38jfvuFaivEeoX/5iSeDLnoHIHzvyRPXZ+tIbFeyzYYPcwsh7IzZ0J2XsvKZ7EKIaKn4c5ls9
	giwkBT61cdfFrecwOoVsX7j+tO0gCOjyawstg7g6xJIa6n/Hw0txJKU1LXTSlNwcsolFuUxh7L6
	TSnMcCqueZn9Clk5COs9AXQp401NF1MoM+oSO/9WyHrLJlivJ15PR6uWiHJ2KakTIL3t8dcFQsd
	J0XBgOhG5c6+OyPn4SZ81pZcFU3gpscZMNq0T+vb+SEezk/6dmFkRf3LmLpoUH5lZRQY0T9OHD8
	fODhwmTEUdCX7A1xghY1vq9lhvM/EFE0SIYnM7yejI3+sbDvw7YYmVJBLo/+XIZsBINR8iqkydI
	kGWY9Y1w+WBW0DyLXd6EiucydKp1bDtowEAOkQu7vnV8VRbTdh
X-Received: by 2002:a17:90b:3e45:b0:354:9b3f:710b with SMTP id 98e67ed59e1d1-359be32bc30mr1164370a91.19.1772783974785;
        Thu, 05 Mar 2026 23:59:34 -0800 (PST)
Received: from localhost.localdomain ([147.136.157.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359bbaa0d83sm804787a91.0.2026.03.05.23.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 23:59:34 -0800 (PST)
From: Haifeng Xu <haifeng.xu@shopee.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev
Cc: zhengqi.arch@bytedance.com,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Haifeng Xu <haifeng.xu@shopee.com>
Subject: [PATCH 2/3] mm: shrinker: optimize the allocation of shrinker_info when setting cgroup_memory_nokmem
Date: Fri,  6 Mar 2026 15:57:55 +0800
Message-ID: <20260306075757.198887-3-haifeng.xu@shopee.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260306075757.198887-1-haifeng.xu@shopee.com>
References: <20260306075757.198887-1-haifeng.xu@shopee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E4DB3C0009
X-Stat-Signature: 4ejxto6tac6quasmyenwfu6dpzhhk1bu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772783975-639622
X-HE-Meta: U2FsdGVkX18tdwwloh6MKrobOzGufFblHgkVAEphysfP8mjvleUKBtDUTjv6fpJL9nT+H32sVh97TOqrLpTTwTit3DmwYblctSNQLDQgee8lmnM7dJ8lgc8FQ5J1s0lUYFa+40XhuaUHPiHxoHOCyV6bKQ1DOwDXfdvHTTChjDj2ijuWA7wvP73E7SiJ89+zDSume56wW5urT4JNGNYJpgiZNHR5M1hZPPhYvh9KYEtcdjSaC0H7koqT2S9sBADp4btg8dZAc7WuULQnJWLiv9UnJWjD8Vbl3Syf0fLY9hpkRE6NTAohUYZjzqB0dhghSwP0XtzQKXAYXiu0f4h8OvNoozHnFtzq96rGjPOMhAMPgdOuPQff5+cs584SXIN2Ml8nJZWswm3RpLViGvFpKGX8Cm84SYDna17B8k9dvJw3GA+4kGGZgmzGaHgealOoyCllMNv8bOpwXtxC9UIEmaUXqc5H4QePy7wC/ebGJ8BCNtAUI30QJpOKN+YrSVlGE4rIqrfXlvZWil7n70HAje0SlAgSCpdCnMfSCe1+JY5oBN+0JKU7arxx07R+EDrXzXYf5gQIjtDGsYNjtqrKOUUKqLikDxT6S5fdnvo4oP/ke1lnL34IKfB3P76vpkAAwBq3P2Y4bJIUozTFg9Gq3cLETs/kxLdL2o4bmjec2LJLmz3j2QrFKQOMaKKVlbR56IhM7iUn9z1TKrmm8BYzTFZ4lgdbLHe0ghJgpDiKRR4sj78akJMMm1WsWv0/yMU9Mmr+Xmc7+FJ9VPqptAq0UCaZAIN68v7hDacQ58Vn+5TFwB4Mm7G1Pd33gw57Ga0nnYVS1vQiSiyvDvjITepcY0isv/g0VHwYlmBm40dFJbKk6zMJ5eDN7gFhUp/NMeThUIMkSjYb+l5MZIHoEw5tzGwUC4Jnll/AwJ6dQSjMqlVbtZLtPNlAUGLvMA3M+l5OCmXRjlQhBwj9YAdzsWd
 bkl15FAB
 28O4fO6EQeW+Ts1NVD8L4urEckL5z/pU1AU1F3rpJq9vzw9fw/m/ieuT6y48dCfg8pCJdujiBsJM4AvaIwemJG5iYx8betRrPMnBSVU3g/PWX8JnTXj40ZCI1fCanOGffYlGKK3aJSuurXP6OnVNOPDQ027GDri2F25XUXdum5yvGJmHtwvZ1+aBfvaw0pDG9PZeDxepZVCKuBtBNOjo3MnEVbaQ+OpO2Gp9d0sA+vqX0o/2XEsEVJv/62vF4zm/EOECxS7lM+eE1kJKM7C1qnLKqu7XdmEdCESzgw+4TWHVnqWWJV1a7b3+w3EXeEHCoaEb0VXdSBZDK6Mt3bWJ8SYXVWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kmem is disabled, memcg slab shrink only call non-slab shrinkers,
so just allocates shrinker info for non-slab shrinkers to non-root memcgs.

Therefore, if memcg_kmem_online is true, all things keep same as before.
Otherwise, root memcg allocates id from shrinker_idr to identify each
shrinker and non-root memcgs use nonslab_id to identify non-slab shrinkers.
The size of shrinkers_info in non-root memcgs can be very low because the
number of shrinkers marked as SHRINKER_NONSLAB | SHRINKER_MEMCG_AWARE is
few. Also, the time spending in expand_shrinker_info() can reduce a lot.

When setting shrinker bit or updating nr_deferred, use nonslab_id for
non-root memcgs if the shrinker is marked as SHRINKER_NONSLAB.

Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
---
 include/linux/shrinker.h |   3 +
 mm/huge_memory.c         |  21 ++++--
 mm/shrinker.c            | 135 ++++++++++++++++++++++++++++++++++-----
 3 files changed, 138 insertions(+), 21 deletions(-)

diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 1a00be90d93a..df53008ed8b5 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -107,6 +107,9 @@ struct shrinker {
 #ifdef CONFIG_MEMCG
 	/* ID in shrinker_idr */
 	int id;
+
+	/* ID in shrinker_nonslab_idr */
+	int nonslab_id;
 #endif
 #ifdef CONFIG_SHRINKER_DEBUG
 	int debugfs_id;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e2746ea74ad..319349b5da5d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4351,9 +4351,14 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 		memcg = folio_split_queue_memcg(folio, ds_queue);
 		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
 		ds_queue->split_queue_len++;
-		if (memcg)
-			set_shrinker_bit(memcg, folio_nid(folio),
-					 shrinker_id(deferred_split_shrinker));
+		if (memcg) {
+			int id = deferred_split_shrinker->id;
+
+			if (!memcg_kmem_online() &&  memcg != root_mem_cgroup)
+				id = deferred_split_shrinker->nonslab_id;
+
+			set_shrinker_bit(memcg, folio_nid(folio), id);
+		}
 	}
 	split_queue_unlock_irqrestore(ds_queue, flags);
 }
@@ -4508,8 +4513,14 @@ void reparent_deferred_split_queue(struct mem_cgroup *memcg)
 	parent_ds_queue->split_queue_len += ds_queue->split_queue_len;
 	ds_queue->split_queue_len = 0;
 
-	for_each_node(nid)
-		set_shrinker_bit(parent, nid, shrinker_id(deferred_split_shrinker));
+	for_each_node(nid) {
+		int id = deferred_split_shrinker->id;
+
+		if (!memcg_kmem_online() && parent != root_mem_cgroup)
+			id = deferred_split_shrinker->nonslab_id;
+
+		set_shrinker_bit(parent, nid, id);
+	}
 
 unlock:
 	spin_unlock(&parent_ds_queue->split_queue_lock);
diff --git a/mm/shrinker.c b/mm/shrinker.c
index f0c6dfa026b0..52ea0e6391af 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -12,6 +12,7 @@ DEFINE_MUTEX(shrinker_mutex);
 
 #ifdef CONFIG_MEMCG
 static int shrinker_nr_max;
+static int shrinker_nonslab_nr_max;
 
 static inline int shrinker_unit_size(int nr_items)
 {
@@ -78,15 +79,25 @@ int alloc_shrinker_info(struct mem_cgroup *memcg)
 {
 	int nid, ret = 0;
 	int array_size = 0;
+	int alloc_nr_max;
+
+	if (memcg_kmem_online()) {
+		alloc_nr_max = shrinker_nr_max;
+	} else {
+		if (memcg == root_mem_cgroup)
+			alloc_nr_max = shrinker_nr_max;
+		else
+			alloc_nr_max = shrinker_nonslab_nr_max;
+	}
 
 	mutex_lock(&shrinker_mutex);
-	array_size = shrinker_unit_size(shrinker_nr_max);
+	array_size = shrinker_unit_size(alloc_nr_max);
 	for_each_node(nid) {
 		struct shrinker_info *info = kvzalloc_node(sizeof(*info) + array_size,
 							   GFP_KERNEL, nid);
 		if (!info)
 			goto err;
-		info->map_nr_max = shrinker_nr_max;
+		info->map_nr_max = alloc_nr_max;
 		if (shrinker_unit_alloc(info, NULL, nid)) {
 			kvfree(info);
 			goto err;
@@ -147,33 +158,47 @@ static int expand_one_shrinker_info(struct mem_cgroup *memcg, int new_size,
 	return 0;
 }
 
-static int expand_shrinker_info(int new_id)
+static int expand_shrinker_info(int new_id, bool full, bool root)
 {
 	int ret = 0;
 	int new_nr_max = round_up(new_id + 1, SHRINKER_UNIT_BITS);
 	int new_size, old_size = 0;
 	struct mem_cgroup *memcg;
+	struct mem_cgroup *start = NULL;
+	int old_nr_max = shrinker_nr_max;
 
 	if (!root_mem_cgroup)
 		goto out;
 
 	lockdep_assert_held(&shrinker_mutex);
 
+	if (!full && !root) {
+		start = root_mem_cgroup;
+		old_nr_max = shrinker_nonslab_nr_max;
+	}
+
 	new_size = shrinker_unit_size(new_nr_max);
-	old_size = shrinker_unit_size(shrinker_nr_max);
+	old_size = shrinker_unit_size(old_nr_max);
+
+	memcg = mem_cgroup_iter(NULL, start, NULL);
+	if (!memcg)
+		goto out;
 
-	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
 		ret = expand_one_shrinker_info(memcg, new_size, old_size,
 					       new_nr_max);
-		if (ret) {
+		if (ret || (root && memcg == root_mem_cgroup)) {
 			mem_cgroup_iter_break(NULL, memcg);
 			goto out;
 		}
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 out:
-	if (!ret)
-		shrinker_nr_max = new_nr_max;
+	if (!ret) {
+		if (!full && !root)
+			shrinker_nonslab_nr_max = new_nr_max;
+		else
+			shrinker_nr_max = new_nr_max;
+	}
 
 	return ret;
 }
@@ -195,7 +220,13 @@ static inline int calc_shrinker_id(int index, int offset)
 
 static inline int get_shrinker_id(struct mem_cgroup *memcg, struct shrinker *shrinker)
 {
-	return shrinker->id;
+	int id = shrinker->id;
+
+	if (!memcg_kmem_online() && (shrinker->flags & SHRINKER_NONSLAB) &&
+	    memcg != root_mem_cgroup)
+		id = shrinker->nonslab_id;
+
+	return id;
 }
 
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
@@ -217,6 +248,8 @@ void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
 }
 
 static DEFINE_IDR(shrinker_idr);
+static DEFINE_IDR(shrinker_nonslab_idr);
+
 
 static int shrinker_memcg_alloc(struct shrinker *shrinker)
 {
@@ -230,10 +263,46 @@ static int shrinker_memcg_alloc(struct shrinker *shrinker)
 	if (id < 0)
 		goto unlock;
 
-	if (id >= shrinker_nr_max) {
-		if (expand_shrinker_info(id)) {
-			idr_remove(&shrinker_idr, id);
-			goto unlock;
+	shrinker->nonslab_id = -1;
+
+	if (!mem_cgroup_kmem_disabled()) {
+		if (id >= shrinker_nr_max) {
+			/* expand shrinker info for all memory cgroups */
+			if (expand_shrinker_info(id, true, false)) {
+				idr_remove(&shrinker_idr, id);
+				goto unlock;
+			}
+		}
+	} else {
+		/*
+		 * If cgroup_memory_nokmem is set, every shrinker needs to be recorded in
+		 * root memory cgroup because gloal slab shrink traverse all shrinkers. For
+		 * non-root memcgs, record shrinkers with SHRINKER_NONSLAB because memcg
+		 * slab shrink only call non-slab shrinkers.
+		 */
+		if (id >= shrinker_nr_max) {
+			/* expand shrinker info for root memory cgroup only */
+			if (expand_shrinker_info(id, false, true)) {
+				idr_remove(&shrinker_idr, id);
+				goto unlock;
+			}
+		}
+
+		if (shrinker->flags & SHRINKER_NONSLAB) {
+			int nonslab_id;
+
+			nonslab_id = idr_alloc(&shrinker_nonslab_idr, shrinker, 0, 0, GFP_KERNEL);
+			if (nonslab_id < 0)
+				goto unlock;
+
+			if (nonslab_id >= shrinker_nonslab_nr_max) {
+				/* expand shrinker info for non-root memory cgroups */
+				if (expand_shrinker_info(nonslab_id, false, false)) {
+					idr_remove(&shrinker_nonslab_idr, id);
+					goto unlock;
+				}
+			}
+			shrinker->nonslab_id = nonslab_id;
 		}
 	}
 	shrinker->id = id;
@@ -252,6 +321,12 @@ static void shrinker_memcg_remove(struct shrinker *shrinker)
 	lockdep_assert_held(&shrinker_mutex);
 
 	idr_remove(&shrinker_idr, id);
+
+	if (shrinker->flags & SHRINKER_NONSLAB) {
+		id = shrinker->nonslab_id;
+		if (id >= 0)
+			idr_remove(&shrinker_nonslab_idr, id);
+	}
 }
 
 static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
@@ -310,10 +385,33 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
 		parent_info = shrinker_info_protected(parent, nid);
 		for (index = 0; index < shrinker_id_to_index(child_info->map_nr_max); index++) {
 			child_unit = child_info->unit[index];
-			parent_unit = parent_info->unit[index];
 			for (offset = 0; offset < SHRINKER_UNIT_BITS; offset++) {
 				nr = atomic_long_read(&child_unit->nr_deferred[offset]);
-				atomic_long_add(nr, &parent_unit->nr_deferred[offset]);
+
+				/*
+				 * If memcg_kmem_online() is false, the non-root memcgs use
+				 * nonslab_id but root memory cgroup use id. When reparenting
+				 * shrinker info to it, must convert the nonslab_id to id.
+				 */
+				if (!memcg_kmem_online() &&  parent == root_mem_cgroup) {
+					int id, p_index, p_off;
+					struct shrinker *shrinker;
+
+					id = calc_shrinker_id(index, offset);
+					shrinker = idr_find(&shrinker_nonslab_idr, id);
+					if (shrinker) {
+						id = shrinker->id;
+						p_index = shrinker_id_to_index(id);
+						p_off = shrinker_id_to_offset(id);
+
+						parent_unit = parent_info->unit[p_index];
+						atomic_long_add(nr,
+								&parent_unit->nr_deferred[p_off]);
+					}
+				} else {
+					parent_unit = parent_info->unit[index];
+					atomic_long_add(nr, &parent_unit->nr_deferred[offset]);
+				}
 			}
 		}
 	}
@@ -543,7 +641,12 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 			int shrinker_id = calc_shrinker_id(index, offset);
 
 			rcu_read_lock();
-			shrinker = idr_find(&shrinker_idr, shrinker_id);
+
+			if (memcg_kmem_online())
+				shrinker = idr_find(&shrinker_idr, shrinker_id);
+			else
+				shrinker = idr_find(&shrinker_nonslab_idr, shrinker_id);
+
 			if (unlikely(!shrinker || !shrinker_try_get(shrinker))) {
 				clear_bit(offset, unit->map);
 				rcu_read_unlock();
-- 
2.43.0


