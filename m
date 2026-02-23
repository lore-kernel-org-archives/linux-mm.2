Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 389E9EEC2A8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 22:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97FCE6B008A; Mon, 23 Feb 2026 17:38:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9481A6B008C; Mon, 23 Feb 2026 17:38:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86F6C6B0092; Mon, 23 Feb 2026 17:38:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F4246B008A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:38:42 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0AB4B14030A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:38:42 +0000 (UTC)
X-FDA: 84477187284.07.C0EB7AD
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 34947A0011
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:38:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SBFQz0i+;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771886320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wYuk97hSinOTQ/m7mlOvoqja3g8YulhySTVwuiXXVKY=;
	b=DS/tSWzKEW6DZ4VwmbbviH7RzMcBZrLzlzkp0AYVhZXiGesYccr6qjbDF0qNOYWTa8wDB8
	z/8lGHd/8PgerpsPK7QMmSsR1a+5fu1x47i2Wl3k378hxFxbrOCyCpKQK3za+lz5yrZn3T
	fs4Ya+cac0535YWSyvk9lw1h8AntTUU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SBFQz0i+;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771886320; a=rsa-sha256;
	cv=none;
	b=OFEwlRDyhLRhpAYFZ9XvFV6lRJJRFn/lbOpyW5LLx2r0raIie2y2as7gUyPnsiPgNYwEhi
	1josUmZ1tFk1fO68KlY+9qGVx9y104eauTyCTNybTkjp2r2Yb62/fBnPj5xSQHfnJsziKC
	VITnguiLZLe43RYlh1oMxr3kproC/Uc=
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-4638e6bb8a5so1757566b6e.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771886319; x=1772491119; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wYuk97hSinOTQ/m7mlOvoqja3g8YulhySTVwuiXXVKY=;
        b=SBFQz0i+IPEshd/pShRVJXUhhMZxGs2o4h1Or55Ev2nZelG9VaorwrCzaqcGycojqH
         loJOQ/jOTapRqKlcvdJpg48ERQ1hhWqGPD3j1u2cgwkLUQGqS7E+fvQvWZbervTSX/Ij
         Z01ipzvR/KklEGaoptxC7l+tOvYCnbVLkSyfJGqJyo+r84jAx2KT5KafQpOr0ofL+TAg
         iiwOD+428qfcO+BIS43/T2WKnRCJYIUAet3VcRGYMV2dzIZiSETENvVpGU1a+MnX/Oz1
         P3qOTB1fXSY10XfwlEX5WcZajH4TOm7XPLMD3gm6T9H9wTpqWF5C02bQMhg8+JP1M2s4
         /cmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771886319; x=1772491119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wYuk97hSinOTQ/m7mlOvoqja3g8YulhySTVwuiXXVKY=;
        b=TGa722EF6bjHmSDJBELsrWpAToCD+RmM8S8xoXeKcb+J9pkrwa9GjV8z+7XTfzZRFj
         W2085nJyd3Le/bjGRpHfqEOa31X3C+l+2ZUK4SPliGhPULUvb9Wh2nijkcoteS3lOSAX
         dCZlEPufWo8XqQR8hLLrxmxd8VxNuv13AWvVCMTTDO4QmrpLoAUcFP7l/A+QOkrRoDrS
         19hp8fSR43VCkAyiZzkDX/qB6fxMOt0Zf/QuN8CqCEYoz8bsOeFidjnsqJh/cYJ58+Dp
         WEV+gTZmQ+F+TiqFJhaUABCS2P4twm/LlA8jkKjNRJJpQbjrTJHXUkIMkGiFqgK3cBc5
         BLvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUC3vJwe9ckf/dgY52oOFAHH/JcMFF2p5cl3ZJCQK6fzN2QSC8apkBpcanP5KdqSi7O5S/WOm6NQ==@kvack.org
X-Gm-Message-State: AOJu0YyCsj8R9b0pbHWU+qPtFkgGCtt7uHq14yobo05liZJCved6n043
	aDL0K7WbjDZAUAEePHPO6YMyQTlA3J1NAyKBqK5+ueCqBnBk4OxNwuco
X-Gm-Gg: AZuq6aKCVdfm3NlLpa8ln6vbGLZu+KUaExj+1omQtqx/HOrY9fXNohPUOGXIcgHJe7Z
	U203u1PD/+Z1R22YXzTOIImNX4S17QHvipH9N1nEbmg3rUKsFv9FoDk3x6Oq2xfO04qNQmZX1cV
	+cN7G0/BnpuSSy2U9bwvNdEl3lbZRH286tTm79oTiov0Dr2OuZptRnAqO6GEtDbxy68TqSf+dHc
	P6+U8QBrcBnamx7YbssZl1exGdDA3wFZA9nRFrq//unVP/SbvZIurB1cWXeEtXnJrWTJ6NH21kB
	uLa0124KP/HYymlpXH4B844y9bduumFgY3ZaiOD+T/GYHDmOJF/yd1Y9NG1GSY7zpqwC6OLfani
	CkPyQ+Bg+ZQas4g3a6G6/koyNBHcKP2f0FPQu+6qT3ysdaRu5MXkRvIJaR7HJpF5Z/6pP7MbycF
	enwFovYTx25ezw+CF78bHvfg==
X-Received: by 2002:a05:6808:1481:b0:45f:727:8fd7 with SMTP id 5614622812f47-4644638ee8bmr5488352b6e.46.1771886318987;
        Mon, 23 Feb 2026 14:38:38 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:45::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4157d2d7826sm8635887fac.10.2026.02.23.14.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 14:38:38 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Waiman Long <longman@redhat.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH 3/6] mm/memory-tiers, memcontrol: Introduce toptier capacity updates
Date: Mon, 23 Feb 2026 14:38:26 -0800
Message-ID: <20260223223830.586018-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
References: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 34947A0011
X-Rspamd-Server: rspam02
X-Stat-Signature: gzg37r8j99uq8zw6s3dukemjn9uait7q
X-HE-Tag: 1771886319-367399
X-HE-Meta: U2FsdGVkX1+amaTUV3cTt+/228X/38FQ1cm7R8japN8IZdrK5Twyzkyw2r3D9vOOk57AE72eYSpVEClER0kNb3Kf4Jng8BZzYZg1A98uS1aVgop66s57s/quuGyO2LrIZ/FVr97iTRpAke6bkvr/bc/WlFwa9ztL7Djmopr8Iq5uBKOXgXCSyjyvlFumFAeddF0b5edKytMhL6p3PZEkaFCmAmV0S9zJlQ1YYMKae81ysGNASThHoqzzYH2guK2KZhNf8CL4ZEvBNFgUclghI0cJ/F0tksjKj+PgRLnmYFKrDPs954OedSYsF4dPmwMFGCAJO382hvFP64ROHa4MZmlrMu5VwkurPRJvRedArU0hlifBTSGFq5uuL/1ojSVxhevBSFVL5k+UvNEVwmA2jjJDRA08T+zUDq/NofXPC9Se8F4W543UlTSWetMAdVeOTICBkUPnYligbJPN2DAv8VDuS4buWnsOa367a56uZZ8yYBgJ/ilv1PXV3+AtJtlfkvXhC5qGfFNtWFzs9jryK4yewycziT6MK6W1ZM8vGzRtbM5b9MDrCdUzihgKZyVtfHmNXn4LZLx+r3kpJTqBayibb5U1zsUUlkJOHAI6yfDOY1kI4ninJq+J8a8ceNzKcVI+avtIJui3d1ofSw+8ogcsoJsGJ/QnJPDpBSIh5GYB7ts+qGLJ1hgy31auxc9IW0Wydme9vHZaVq1s5rLA9R2OdQg9M0NQsLgahXjtoek5kKeDsYHcAweOGBpYFuZL7N6vFScMiUqs2jZUIziWiqSpRAOwgfeHpoyBCA0SZzoCn4XsX5zX/gsOIuFIzdTD8Iy+Pcpv6qu5MHtlBuM9i9xyexsRuBaD+seQARYK9nA6fq5CzrOWR3k3jYPdVXxSL29q6H7w1bi2So8me5yFUom9C8xbd4/LtF1/dSdNPxBYiX5yXmyEOYGk/SBVK/aLpAhe443y4HtOvcMfIzU
 PAi3KiSQ
 YDcViG1YoILvE58L+i0vBiHHUP4eH5I4Ul33pO4qqvly2VtBy5UKkkIjcNLqdggfsmrgpoW3ObVN3YYwSED2/OUYfHpndJpWsSOVz/FuTHO7rW2Y2wdiHBdHvN5P1+5wpKZq+d6PlSnQ8dDUaOxwtBYenH0ktfMq7sn/mZ3mcVMIuAX9F8V3yMBmE+S5PEWG+ar6xrJelF3rJxaSoNyl8L5Qzk/v2Ij56qLA+WUlF1q9LMXwbf5GZgvmZGZJPmfSeDnkjj/1S/cIN98iCADZyjDmdhotPgGGPdycdYKMjVYrU3YwojoO4cDIUTHTG4RSQCA8BR7a1C7ahUo7gpsZXvp+dgFGBtUbhgSM/lLcv7T9y7WdsouVRp4q7Bz5lMDYc5XvtIrhpd+Fet4R3xW59oB/65uhIZJZzfobkqG7HH2JvLz/mIzp13Q7rf1spKsIzzGj3m7br3i3/ZRtSeJrIwwE49+4HMGAxdsr8dt//ApXE5kJr/m58WtmPOuypJO9TQW6kMHRYBAsNGMWJQVyPwLateGld2HQodmiGqa/lMmzr/VI0Is8Ok7Q7G1oXwU5LCL6xtLEPTRVm5juqon09iXSUEUfklk8JJ7WJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

What a memcg considers to be a valid toptier node is defined by three
criteria: (1) The node has CPUs, (2) The node has online memory,
and (3) The node is within the cgroup's cpuset.mems.

Of the three, the second and third criteria are the only ones that can
change dynamically during runtime, via memory hotplug events and
cpuset.mems changes, respectively.

Introduce functions to calculate and update toptier capacity, and call
them during cpuset.mems changes and memory hotplug events.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h   |  6 ++++++
 include/linux/memory-tiers.h | 29 +++++++++++++++++++++++++
 include/linux/page_counter.h |  2 ++
 kernel/cgroup/cpuset.c       |  2 +-
 mm/memcontrol.c              | 17 +++++++++++++++
 mm/memory-tiers.c            | 41 ++++++++++++++++++++++++++++++++++++
 mm/page_counter.c            |  8 +++++++
 7 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 5173a9f16721..900a36112b62 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -608,6 +608,8 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 				     struct mem_cgroup *memcg);
 
+void update_memcg_toptier_capacity(void);
+
 static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 					  struct mem_cgroup *memcg)
 {
@@ -1116,6 +1118,10 @@ static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 {
 }
 
+static inline void update_memcg_toptier_capacity(void)
+{
+}
+
 static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 					  struct mem_cgroup *memcg)
 {
diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 85440473effb..cf616885e0db 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -53,6 +53,9 @@ int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
 struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 						  struct list_head *memory_types);
 void mt_put_memory_types(struct list_head *memory_types);
+void mt_get_toptier_nodemask(nodemask_t *mask, const nodemask_t *allowed);
+unsigned long mt_get_toptier_capacity(const nodemask_t *allowed);
+unsigned long mt_get_total_capacity(const nodemask_t *allowed);
 #ifdef CONFIG_MIGRATION
 int next_demotion_node(int node, const nodemask_t *allowed_mask);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
@@ -152,5 +155,31 @@ static inline struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 static inline void mt_put_memory_types(struct list_head *memory_types)
 {
 }
+
+static inline void mt_get_toptier_nodemask(nodemask_t *mask,
+					   const nodemask_t *allowed)
+{
+	*mask = node_states[N_MEMORY];
+	if (allowed)
+		nodes_and(*mask, *mask, *allowed);
+}
+
+static inline unsigned long mt_get_toptier_capacity(const nodemask_t *allowed)
+{
+	int nid;
+	unsigned long capacity = 0;
+
+	for_each_node_state(nid, N_MEMORY) {
+		if (allowed && !node_isset(nid, *allowed))
+			continue;
+		capacity += NODE_DATA(nid)->node_present_pages;
+	}
+	return capacity;
+}
+
+static inline unsigned long mt_get_total_capacity(const nodemask_t *allowed)
+{
+	return mt_get_toptier_capacity(allowed);
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index 128c1272c88c..ada5f1dd75d4 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -121,6 +121,8 @@ static inline void page_counter_reset_watermark(struct page_counter *counter)
 void page_counter_calculate_protection(struct page_counter *root,
 				       struct page_counter *counter,
 				       bool recursive_protection);
+void page_counter_update_toptier_capacity(struct page_counter *counter,
+					  const nodemask_t *allowed);
 unsigned long page_counter_toptier_high(struct page_counter *counter);
 unsigned long page_counter_toptier_low(struct page_counter *counter);
 #else
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7607dfe516e6..e5641dc1af88 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2620,7 +2620,6 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 	rcu_read_lock();
 	cpuset_for_each_descendant_pre(cp, pos_css, cs) {
 		struct cpuset *parent = parent_cs(cp);
-
 		bool has_mems = nodes_and(*new_mems, cp->mems_allowed, parent->effective_mems);
 
 		/*
@@ -2701,6 +2700,7 @@ static int update_nodemask(struct cpuset *cs, struct cpuset *trialcs,
 
 	/* use trialcs->mems_allowed as a temp variable */
 	update_nodemasks_hier(cs, &trialcs->mems_allowed);
+	update_memcg_toptier_capacity();
 	return 0;
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0be1e823d813..f3e4a6ce7181 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -54,6 +54,7 @@
 #include <linux/seq_file.h>
 #include <linux/vmpressure.h>
 #include <linux/memremap.h>
+#include <linux/memory-tiers.h>
 #include <linux/mm_inline.h>
 #include <linux/swap_cgroup.h>
 #include <linux/cpu.h>
@@ -3906,6 +3907,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 
 		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
 		page_counter_init(&memcg->swap, &parent->swap, false);
+		page_counter_update_toptier_capacity(&memcg->memory, NULL);
 #ifdef CONFIG_MEMCG_V1
 		memcg->memory.track_failcnt = !memcg_on_dfl;
 		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
@@ -3917,6 +3919,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		init_memcg_events();
 		page_counter_init(&memcg->memory, NULL, true);
 		page_counter_init(&memcg->swap, NULL, false);
+		page_counter_update_toptier_capacity(&memcg->memory, NULL);
 #ifdef CONFIG_MEMCG_V1
 		page_counter_init(&memcg->kmem, NULL, false);
 		page_counter_init(&memcg->tcpmem, NULL, false);
@@ -4804,6 +4807,20 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
 }
 
+void update_memcg_toptier_capacity(void)
+{
+	struct mem_cgroup *memcg;
+	nodemask_t allowed;
+
+	for_each_mem_cgroup(memcg) {
+		if (memcg == root_mem_cgroup)
+			continue;
+
+		cpuset_nodes_allowed(memcg->css.cgroup, &allowed);
+		page_counter_update_toptier_capacity(&memcg->memory, &allowed);
+	}
+}
+
 static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
 			gfp_t gfp)
 {
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index a88256381519..259caaf4be8f 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -889,6 +889,7 @@ static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 		mutex_lock(&memory_tier_lock);
 		if (clear_node_memory_tier(nn->nid))
 			establish_demotion_targets();
+		update_memcg_toptier_capacity();
 		mutex_unlock(&memory_tier_lock);
 		break;
 	case NODE_ADDED_FIRST_MEMORY:
@@ -896,6 +897,7 @@ static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 		memtier = set_node_memory_tier(nn->nid);
 		if (!IS_ERR(memtier))
 			establish_demotion_targets();
+		update_memcg_toptier_capacity();
 		mutex_unlock(&memory_tier_lock);
 		break;
 	}
@@ -941,6 +943,45 @@ bool numa_demotion_enabled = false;
 
 bool tier_aware_memcg_limits;
 
+void mt_get_toptier_nodemask(nodemask_t *mask, const nodemask_t *allowed)
+{
+	int nid;
+
+	*mask = NODE_MASK_NONE;
+	for_each_node_state(nid, N_MEMORY) {
+		if (node_is_toptier(nid))
+			node_set(nid, *mask);
+	}
+	if (allowed)
+		nodes_and(*mask, *mask, *allowed);
+}
+
+unsigned long mt_get_toptier_capacity(const nodemask_t *allowed)
+{
+	int nid;
+	unsigned long capacity = 0;
+	nodemask_t mask;
+
+	mt_get_toptier_nodemask(&mask, allowed);
+	for_each_node_mask(nid, mask)
+		capacity += NODE_DATA(nid)->node_present_pages;
+
+	return capacity;
+}
+
+unsigned long mt_get_total_capacity(const nodemask_t *allowed)
+{
+	int nid;
+	unsigned long capacity = 0;
+
+	for_each_node_state(nid, N_MEMORY) {
+		if (allowed && !node_isset(nid, *allowed))
+			continue;
+		capacity += NODE_DATA(nid)->node_present_pages;
+	}
+	return capacity;
+}
+
 #ifdef CONFIG_MIGRATION
 #ifdef CONFIG_SYSFS
 static ssize_t demotion_enabled_show(struct kobject *kobj,
diff --git a/mm/page_counter.c b/mm/page_counter.c
index 5ec97811c418..cf21c72bfd4e 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -11,6 +11,7 @@
 #include <linux/string.h>
 #include <linux/sched.h>
 #include <linux/bug.h>
+#include <linux/memory-tiers.h>
 #include <asm/page.h>
 
 static bool track_protection(struct page_counter *c)
@@ -463,6 +464,13 @@ void page_counter_calculate_protection(struct page_counter *root,
 			recursive_protection));
 }
 
+void page_counter_update_toptier_capacity(struct page_counter *counter,
+					  const nodemask_t *allowed)
+{
+	counter->toptier_capacity = mt_get_toptier_capacity(allowed);
+	counter->total_capacity = mt_get_total_capacity(allowed);
+}
+
 unsigned long page_counter_toptier_high(struct page_counter *counter)
 {
 	unsigned long high = READ_ONCE(counter->high);
-- 
2.47.3


