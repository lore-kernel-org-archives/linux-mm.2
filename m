Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40A3CE91298
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 08:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7F606B009D; Thu,  5 Feb 2026 03:57:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A29326B009E; Thu,  5 Feb 2026 03:57:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92B936B009F; Thu,  5 Feb 2026 03:57:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 81AAE6B009D
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:57:15 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 375BB16047A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:57:15 +0000 (UTC)
X-FDA: 84409798830.29.327EEAD
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 617208000C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 08:57:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ck+wu8Lw;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770281833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MiDykztldwgZHOg2WclHZW+3LofCYQfh+WScg3xRjLk=;
	b=gYUYLCOvaujWusKIwpfd7bV3wT384kgpuKznmu9kubpAlZQUzHtLWVaDmPj2Cr3/L/RakY
	PlSi/YWbP9fmSceoUkZdK6p48u6J8JTsOQ72EpoClPRDj2hqbC8uT+0R7XIvcRBJnZVhtR
	6+orGZ2AHQyFfdTpCe+/P6IuU14pVpI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ck+wu8Lw;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770281833; a=rsa-sha256;
	cv=none;
	b=v8ONHtD9HGVvRSWVvZtht4k/Kd6dJLlX2Gum3M4M3gTkhwMSaGkhqDP74V8fK9XusJjMl4
	pKtiNhwWJ1Iqx36oaJMcEe8OFDRCIGhXHGLbLE29dJDbVzXpMszcPCmPHPuHgg6yUyGhVn
	KTiTuq4l6zaUcIp/IqshlhXbIfur6Do=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770281831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MiDykztldwgZHOg2WclHZW+3LofCYQfh+WScg3xRjLk=;
	b=Ck+wu8Lw+mENdd8Goe3Ls8M+6rRM2t1/cRGnlpb13P40Wmd5PbhhW4WvuutndfmFv9seRy
	oV7/dPJs1AJm5xx5yd77xawJmLS6cthqOzMcj+9UueEhj6MXPoBeqMKwbr+cAXxMSzzTAQ
	BCNBZ3P4QmS9ZCw2hud4DQzEbD9Gw/w=
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
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH v4 06/31] mm: memcontrol: allocate object cgroup for non-kmem case
Date: Thu,  5 Feb 2026 16:54:35 +0800
Message-ID: <dd1230ba32520bb2c6ea6df5cc821d70d0b966ab.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 617208000C
X-Stat-Signature: 86x3qymoz9a79696gzt3kiaymp311bfy
X-Rspam-User: 
X-HE-Tag: 1770281833-278654
X-HE-Meta: U2FsdGVkX18JMDrLdYfILk/PZDHt2NqjLJyoiknCdcAGm5kGibsusy7XIWUSPbDbQlLb3Q+N7FQNwMesg9IYhBfAnqzWFubcUSxBQLNHAbVIMMcJhD1jCcoZGRDODyrnrBHwYUcBJZ7ZZdteaUMp9eK9mysL0Vw7egzXJT10LmnXcbuPumzasNJIAGcjb3REjTunX0RaDBNn+BF4l4q4s0GapMW5a4gDMufgAIsbM1Q0yh5IA5JOOc2GAf6BPyrGM2pFF38gnjaP6ZnN1A2gat0AFIO3PMlLa5UEROu1dusPZkcCvxe1DHfJkQXgFjsIjlnJIxVl4sm0hUpknQk1AG4SQp+o3x3+JQ4I443fO9XZwL0Y5nkJcWu6UrE6vjITYE/RgZ+8vsdtwYRIPxpMdnwTp2sthNTpoOI7FGkTMxh8tR4LfBHo8scpOf1KRqQ+lH1llSuGlerfoymJtrCi4WLT3x35F+EuI/qETWUle72JA3wPWQfAsXhOjlto7Prkq0+JWgf66WMyW2gPDTg6MiHW56DKJry5axz7OejIiHCpMTakmNw54jcCR+NOBb8V78vQolC0UjAsSIH+PtdKQJb3RtDAEmggwmkRm1PIaXtE4Wuphn8Jg8umF7lTGlwjfEGrnigi54CUVEwMlYSslCo068C7Dq9nkosPk5NbIXm4Fth9l2DeBHFRxjiRW4dewxEkAkXF3XMBvow2B+1S1Ae+Ilv2vFW/23FZA3ai1tEjwp0+X6tAMB2zEI0GnDXHgwIuotdIgVOJv0mih4PZ0NrPcFdG8ITIUEgQIs4jykqD4ImjQVHSIMumny8hgIgPIKszMxjID6MUXjg3fxFP/dvS4YduGr6+L53maBfSdpFp7/xassIYc9RT0it8UdX+zz96MJMnBrnxTuzPee89kyX8dDLjEB+S8ZVl4teS5ZONfxPFLsU+WH5L6D4b4pdlu5A9HQwulwPp0tPf8dg
 h54cdW/y
 IUpiVhQoFD0dHRIzpSq1yDEOj6FjTH0Ok4iV39nxo10hDytQoccAl5YDQaTUZBmMxM71qTuVj1j4aODKCG82fZ8FmIz0h6I9EYz6qWuCUxzQgp0RTCWuJ0CWepLHbDSJTxjZ51aLeAC2uz/7qQOK5U8Pz+WE9M6yTe0UtcpO41809NTEWEKko/Z8YLi93nDfgMJanIdpiFk7xJciTFpitA7vYOt1/sxcLWPEF9Y0r6DgA3yKFbqzygLBCKWuiwm6WqEYCOnWiY/6POtO0f8OIDEIdJFKa6U4gYqbv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

To allow LRU page reparenting, the objcg infrastructure is no longer
solely applicable to the kmem case. In this patch, we extend the scope of
the objcg infrastructure beyond the kmem case, enabling LRU folios to
reuse it for folio charging purposes.

It should be noted that LRU folios are not accounted for at the root
level, yet the folio->memcg_data points to the root_mem_cgroup. Hence,
the folio->memcg_data of LRU folios always points to a valid pointer.
However, the root_mem_cgroup does not possess an object cgroup.
Therefore, we also allocate an object cgroup for the root_mem_cgroup.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Chen Ridong <chenridong@huawei.com>
---
 mm/memcontrol.c | 51 +++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 43dbd18150e97..5625955bcd23b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -206,10 +206,10 @@ static struct obj_cgroup *obj_cgroup_alloc(void)
 	return objcg;
 }
 
-static void memcg_reparent_objcgs(struct mem_cgroup *memcg,
-				  struct mem_cgroup *parent)
+static void memcg_reparent_objcgs(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg, *iter;
+	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
 
 	objcg = rcu_replace_pointer(memcg->objcg, NULL, true);
 
@@ -3315,30 +3315,17 @@ void folio_split_memcg_refs(struct folio *folio, unsigned old_order,
 	css_get_many(&__folio_memcg(folio)->css, new_refs);
 }
 
-static int memcg_online_kmem(struct mem_cgroup *memcg)
+static void memcg_online_kmem(struct mem_cgroup *memcg)
 {
-	struct obj_cgroup *objcg;
-
 	if (mem_cgroup_kmem_disabled())
-		return 0;
+		return;
 
 	if (unlikely(mem_cgroup_is_root(memcg)))
-		return 0;
-
-	objcg = obj_cgroup_alloc();
-	if (!objcg)
-		return -ENOMEM;
-
-	objcg->memcg = memcg;
-	rcu_assign_pointer(memcg->objcg, objcg);
-	obj_cgroup_get(objcg);
-	memcg->orig_objcg = objcg;
+		return;
 
 	static_branch_enable(&memcg_kmem_online_key);
 
 	memcg->kmemcg_id = memcg->id.id;
-
-	return 0;
 }
 
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
@@ -3353,12 +3340,6 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
 
 	parent = parent_mem_cgroup(memcg);
 	memcg_reparent_list_lrus(memcg, parent);
-
-	/*
-	 * Objcg's reparenting must be after list_lru's, make sure list_lru
-	 * helpers won't use parent's list_lru until child is drained.
-	 */
-	memcg_reparent_objcgs(memcg, parent);
 }
 
 #ifdef CONFIG_CGROUP_WRITEBACK
@@ -3871,9 +3852,9 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+	struct obj_cgroup *objcg;
 
-	if (memcg_online_kmem(memcg))
-		goto remove_id;
+	memcg_online_kmem(memcg);
 
 	/*
 	 * A memcg must be visible for expand_shrinker_info()
@@ -3883,6 +3864,15 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	if (alloc_shrinker_info(memcg))
 		goto offline_kmem;
 
+	objcg = obj_cgroup_alloc();
+	if (!objcg)
+		goto free_shrinker;
+
+	objcg->memcg = memcg;
+	rcu_assign_pointer(memcg->objcg, objcg);
+	obj_cgroup_get(objcg);
+	memcg->orig_objcg = objcg;
+
 	if (unlikely(mem_cgroup_is_root(memcg)) && !mem_cgroup_disabled())
 		queue_delayed_work(system_dfl_wq, &stats_flush_dwork,
 				   FLUSH_TIME);
@@ -3905,9 +3895,10 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 	xa_store(&mem_cgroup_private_ids, memcg->id.id, memcg, GFP_KERNEL);
 
 	return 0;
+free_shrinker:
+	free_shrinker_info(memcg);
 offline_kmem:
 	memcg_offline_kmem(memcg);
-remove_id:
 	mem_cgroup_private_id_remove(memcg);
 	return -ENOMEM;
 }
@@ -3925,6 +3916,12 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	memcg_offline_kmem(memcg);
 	reparent_deferred_split_queue(memcg);
+	/*
+	 * The reparenting of objcg must be after the reparenting of the
+	 * list_lru and deferred_split_queue above, which ensures that they will
+	 * not mistakenly get the parent list_lru and deferred_split_queue.
+	 */
+	memcg_reparent_objcgs(memcg);
 	reparent_shrinker_deferred(memcg);
 	wb_memcg_offline(memcg);
 	lru_gen_offline_memcg(memcg);
-- 
2.20.1


