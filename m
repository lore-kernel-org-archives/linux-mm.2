Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36324D29FEF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A25C36B009E; Wed, 14 Jan 2026 06:28:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D0AA6B009F; Wed, 14 Jan 2026 06:28:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FD4D6B00A0; Wed, 14 Jan 2026 06:28:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7DB6F6B009E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:28:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51B19B99CC
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:28:27 +0000 (UTC)
X-FDA: 84330346254.25.2F6634C
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf18.hostedemail.com (Postfix) with ESMTP id 77D231C0002
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:28:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ib/mjgNT";
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V1vXHR8JwKEwtIzS8TS860rTPaJr3Gkbm9UJce/sFhs=;
	b=w86MUdS/C87rSItzUswL0Ge2BpX3xug8qxWoxuZSDyY+ByXScLu+FvuUj8cWuhTXc47S/j
	NoikDp/fQKSHs5hAQNfnWgrWW+GEEH8AP2eKsgvts5jn70Bko2qrxbAfNIIUaiJJgRgwN/
	dFTEpEF3T9SBIqfC80Vt8SXNeOW+qSU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ib/mjgNT";
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390105; a=rsa-sha256;
	cv=none;
	b=QnyZSI4MnMaI9ifrkUyU4ojvnpBevcGTkkqjQIjpMN0CAgfNjAgra47hjvycwaP4RNlBv1
	5xea5nxDE367a8fql8q3beVXuPRYhcOk9/XGAW3E6WG260PIXjs6P58NVFm1fRw7JPpYE8
	EPdlAup5xOd0UbhpNcaz/qcZB6ynlAc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V1vXHR8JwKEwtIzS8TS860rTPaJr3Gkbm9UJce/sFhs=;
	b=ib/mjgNTFpVkOV933pkz9U4zVgG7N8FMrYZFgQUpgwStiRSzxk/qE1qGCG8P9WQzWRWJfQ
	ABu+ul2vU0NdfX5eDTltx1pWVnpFdHvqX4Eq6KrJ5TiTQJLFqyE0rgewwfHfJkrKmQktIb
	Kn9pOn10ZPlGeQx3PrV2MMfs63NZe+U=
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
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH v3 06/30] mm: memcontrol: allocate object cgroup for non-kmem case
Date: Wed, 14 Jan 2026 19:26:49 +0800
Message-ID: <3fa85369db90a18608124cf4e16a3b779b3e4674.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 77D231C0002
X-Stat-Signature: u8jjkyx3jes7ej6hrhudtcidwgsy7c4c
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768390105-117955
X-HE-Meta: U2FsdGVkX18LfLgpL8Cm1BnKaluLYcXgjoVB9LWawUzLA5zOT101uxh9xxrjMXCWsGA/0KYUmAAVyKWYsIIZLhG7/tt7uYlE03di3pMH7fbejoZD1+mNMdi2qf0xiciEQFJzvZrpn5D0bIAJPfZZkr8q1dAGAUqbbIv4s34BEzltiw7gnAJVpwqzodn3nTuko5uqn1jGNy6twac3/jiX7SHkyjEBbjtJEa0iRNR1xJ+Z6eDbkT++JSSRQ57woHE8VZtdtNBmVdR16FiHlC+LgUaZXXrIiG7gxcaGqpHWnhqa4l8Su1uuEpvCugkT/FM4g2EjrrwpJzBIAglntbIJrbUkB9Or+4zeSy6uT7YSItBfysmyevpYVSlhGF7KENgwIDaR2oYNdBSB8fw4mGXaXbEjkcu1Zprzkx2olAkN51cvZUjIVt0hxThXdzLp6F8ScgpsPZnn2gICgCgWQdUYQF1A0BlAvXAODLujNAFIVAIeH6NMzC2OZ85mrvIWiR/f6y34ET0/q/nOE5wat9baM4IF2zemNkKhQTAH61MPGD3uHJ+MfLHByGDGPW2FafTNdX595g1w9QlTLbzR0ETojEvUjV+TwIFAGwnFY31FnEPlfewREArt0rKllVDfvEPSkYO2q/i0xA+e4TyHgCKRyvsN8WRiEtaDd61+VmRrTO2POBz9c4CkPsxYAOCRkGNZ6ZuCYz3pEhIvCK2WBSYtZlfMgRyhbv+Rl//ErAdJ71oHDEGJUL/DyUEjfDgoct+qFrua2Q6So/C2nqvOaag2Q73ud+WvLRLzP7VGfEn9QJqNKkE1P2GHimL3IqS1izh6NrKCmmY1Fi1zuCVGaUEg89ZKb4LntYJ83TRekQuUK4wsMzAMeQ93cEAvqXWUZjC+Tf9N/tAU45Jvj9DCGxsPbO7GlQpbkxflF3v+sTJfBE1ClLzePc6n0OwYapxZqGjIpplZTTf2IpAxP/gDdG/
 jSGQCLt+
 LZZL7ZKAboNTWAzZZ/kJ3sH8MyanSEiGFweFFZ/o8H1sUyAY6JBMYhppfYpFbS4drZO0Gm5RYQ5a8+XfmLq5kua+cxjMpXM0zFk4tAwU6597AO5gujHretTUVgS/REkfziiRF3ludOppELTO94P6g1YdXbWGC3WGXhpwFWAkWVQbJQS+GsCZJXKf+Z4wgrr1qQIR9wSPxvHxtSNYAasYxlfIdJrL9V8oXNtBvhBL6SWFpbXcDWX0/q+2KXbUZMoqwgAzc8iSm3UU6+LIHRhaeo1NyZ9IC68/8n/57
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
index c68af9fea0abd..a9057f24cc48f 100644
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
 		queue_delayed_work(system_unbound_wq, &stats_flush_dwork,
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


