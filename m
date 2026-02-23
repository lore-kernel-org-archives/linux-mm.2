Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9210EEC2A8
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 22:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67C6C6B0092; Mon, 23 Feb 2026 17:38:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A226B0093; Mon, 23 Feb 2026 17:38:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CA2F6B0095; Mon, 23 Feb 2026 17:38:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1486B0092
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:38:45 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E68A9C17FF
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:38:44 +0000 (UTC)
X-FDA: 84477187368.11.EF39698
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf18.hostedemail.com (Postfix) with ESMTP id 06ABA1C0010
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:38:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S7YkKJYa;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771886323; a=rsa-sha256;
	cv=none;
	b=vUPYeNIqCsHp4owlrZLLwdFPAlUqiu0/KrCB2Yv7YvMsCUYzVGWmegn10XAs6lE1rN69Xc
	epJxZVOkmLcuA8yxrYOkDtngfwLX06bXm8opRoiKcwZmle2GY7WL2VnIVRTzp/rYrLICKr
	zyfpbbxLVcU4N1KrS9wjOrPtYu0LatI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S7YkKJYa;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771886323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FkAGKD7Y1lByzW5ZH+EADePeSZfMfZz07pF+iYnM/14=;
	b=j9x/B6hZ5GWUbXkZkWbgVLUoD5kyaO98+khqtUD8fu3ofjYVjOmPATm97bWIqm21J6R46+
	PyzErsP6id0/h0XqPCZanw/o4AwQVHjrRRBivon4ve54BpBVVYwYGhErn9fYkCKWUOpFzU
	MCWwm/mTv9zXFs8ScjbH81jePS7JKxk=
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7d4c4b494fcso2784951a34.3
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771886322; x=1772491122; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FkAGKD7Y1lByzW5ZH+EADePeSZfMfZz07pF+iYnM/14=;
        b=S7YkKJYalxRDsy5sBjaGyEn1DiNJhUtfAc3x4N4B9FiZTjTl+Qj1pC/b9k8JzEkOV9
         EbnafLpfjOiv7+el27H5uh7XsaufAr3nGhUjj9hF8x1AM40MSKOkoCtcONb8IFDXPKGR
         Pe8bnvaUGmaOtBSM3r5UzMHrdHe77/kW1vixoH0QrZ+ygF7bMd+1oEEspYqbekSTT5O1
         43hbfKXvhkY0570HIE/r2p17e3iMhLkZe5pe3HuPO7y7U6M8Sgy4HRujNqazByuDG4+3
         H7TBa3qthDsY8lF7coHTinTbHE4anTg0E4VseTI61Y8YkWiHOL/kClr3Q6FDtDAxWXoz
         UJmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771886322; x=1772491122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FkAGKD7Y1lByzW5ZH+EADePeSZfMfZz07pF+iYnM/14=;
        b=ThvY+u9xk8ZIELNufaDCHxk4Z79yHt7AIUYiiRsXvSErmzjBlVmfEAGwmQXOCas3kB
         dvqiQ3ws/vXYsS9m8NoAkXunjUIpuFlD2za0Sd3cr1yt8NRX5TmD5jv8V776d85RddI2
         If9bFC26H0DIZFtPBDa11EOzkb9EO8WaEJiFCpnPVZ3bmzdVQi73EKe7Y4K2xqOKAfbx
         quIzJmOqt4jyd8G4B3vf+oNpWhtBL9Ms1hzM/qRBsuTPPONXgTKv36bc8GcOk40qFtyc
         qWvt/PCJmT8t+2xkuGaUpgy8YL9OBzKmdtwX12H+3pn+T995NlQ8v2eeaQ0O+YRcAmiU
         ztUA==
X-Forwarded-Encrypted: i=1; AJvYcCVMGCoBbPJAsS0/6UMHxTrRGfzpu/GqRnhCT2D9IL+B44QPv12rUUiKEzJG6iQLpzKksBF6V+/I4Q==@kvack.org
X-Gm-Message-State: AOJu0YzqrrPNyF4CFaY1t69rbBJQ+i2hKuLoHDe3wf8uw/bPfHZGf1eS
	Zt13BPjDwhXEHBYjTJzqddf0dSXS1Qix8Zxs79LA0QWToaHiXE6J4c1S
X-Gm-Gg: AZuq6aLq/VNRLTkxSteBvnGV/sTyMJDTTFgKSI5sBmALTsXpNlYAaJQMFe+tb/r84cF
	q4arsyZSAqDpSRUmjtBmKUQXez3wLk/HG+u82S97ZjSdks5ih4J5vwEzcKm8BHEkihYRE3oPHXP
	iYcCxhktGLwzc6YIPuqVrnpnqeB3ikBJ6IAOlOd91Q5ndDghGmtlCi3YkKM5krTvdXPZhILY53o
	H6iUrocSfLkJWmGfWU2k4AyVGdJqYNDOJy7fLJTNcaRT4dTt7cpoHAes3zFhrY3UJYjyWfjCHkw
	AlAnHItCzmacfOPoC7eSBnqaeobCgQ5o59WZlQT23vMMM/59j3IK59+Vtby++b8oz/4uITNAC/k
	UsnLAz78xZndEp/Eqe59oodh019tH7R0BSGG86ON+DIZJ6ai44EwmfxtrGpkGzPmNRVuUUlgNPs
	1GnlxejFhj+0I+HBV3TQWk4w==
X-Received: by 2002:a05:6830:4709:b0:78a:5183:8f6a with SMTP id 46e09a7af769-7d52bf6f7ccmr8378736a34.28.1771886321962;
        Mon, 23 Feb 2026 14:38:41 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:41::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d52d0386c6sm8952995a34.13.2026.02.23.14.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 14:38:41 -0800 (PST)
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
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH 5/6] mm/memcontrol, page_counter: Make memory.low tier-aware
Date: Mon, 23 Feb 2026 14:38:28 -0800
Message-ID: <20260223223830.586018-6-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
References: <20260223223830.586018-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 06ABA1C0010
X-Stat-Signature: zr41rkhftx3oni3p9n3c44a4e3nfu61o
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771886322-259094
X-HE-Meta: U2FsdGVkX18kfuYpBIF2KA/FX5NwB9wInjelKoACQluqbrH4FHvTlsvyGxkG7/jQPO8QIwSld1do+O8f0gj8aE+AkyfpZexISlVAxz/QU+eApt7sBLRC+YTORBLsg6Do6/HD6cZf+pBnMPMn1y0HNKaRBB63KviOe9SvIATcmHCaxc1ZmpMIhtzZAour4c67nPYs6z7Jeh/BNvsQlUUda+RzJylTfhIqc2qqy7jDDobA60jEMDbPy7pBjjJsRIAb2m9CvIvG3wmqh3mCt5syTXd75YeRize94Y8F32UBV0roAdCgkPfepvZ0lb6QucrnMBV0Mi0vpb38RKIni2qBAg6IajypLn6LZXIFz30lvIbPd4Fy3WPmrTARLld0B8j0aNBoRVYFZORiy+xGt6aqMuDBQFZXDRYtBNQSlLUSp4RjHFduOTw5JXNP4AuSri6YyKRDAUgALco07whcDVrOVs/B9O7RK1QA+NYllFVIZZ0LQPq3Yh1PCsdjzZZBawjsBxgncbQ6ScY6pKBxfC2cK9+um+TiENQhPuJs1YQvQKfpe4AdH+0UEZq7Asu4sCU9Mh7fTeJCvBjP7QxoL7jhyXOOa8mNnVm5I/lLEWF31tSxo4PKmeqmELGdTkBIR9e2ZLPq1O6eE0+cQBxNASqaG6mlOgVGiBzmbBYfdkkmUTJCFX1pqFUtOYATmR+8bCF6CdllF1loV3IGLwJ56Ry6u4/s8bZtFatw/5BebUcKKUc95eos6j5CVMkR89BRi8vQcjh2Ww6rs64XaYLO3B831W8lyafRhtqShyAlQzY7Rd21HUeTHBjdjLy9SrkTrgkGxKdAaN01j+LXtRJXr/oik74eyn8e3eqBGLb2Xp5oL6UEfFk7A1+MMpY7p3gVuKdBv62yFCsmyIIawQJM9r4UD8ACHu7lU3iyqOnGx+KLv14j+TVnERhYwH/LtukXKMOBIyht+MDmQ7rDvcpW8D9
 9JS+CTUY
 v8br3KlpXIAVMis/unIynphv2EEv1HN0O1qwednmYDiMWOQJTvph0qUcPVRNHNAm2d7tfHnVquEFyW2BdXH9/4sLMpPitS6enS3L2CK0RO4eXrg+jG8efHywLDDV4yVPqKefGpGVU8YLMnSYfDHk9I7GvYpFXyfQszwL1pD2SMYTXc01UYxukX8MgRntYo+9Fi8qAG9g+GGuA09lIhZtwVFhqUHgrHLJF11jX2A8rbFHyBEUan0mATy/N0BFcI4Xew7erXaeIYy/1CghezpOzz19WiYJXbqheeZjQRKURUv+vTA70N4l56sbCX+BPHCGOFA9T6NxpF6tdtoVgCe0IL+KzBlvCmxUlHENevrplhH4MkIG7LikHqYySOCn6LDH5FRRSUf/0bpVBEBWacP/mgAtB+6YfPlK63tlVOBEie5xc4Yxbz2k56VJQvWmFzUDTovnr2z3PdMrlo3POmblHXpOjyD9VrG5b1lcuZa/OQzUV4/lF0Vvv3cop49AObzW97Jb8Ba9tVUH9OBXJpQLf9i4z8KM9hFmirSiOPdNf/a/riAzB8m40LdW+DUSVslGFpN7WFieDwpWVNSucBJmtMXVNGIdkfuSs7adH98j4CVPyoxhS5anzRriwa8iGijVk0XUloCQGTVf1uu2CG6V5rVTYNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On machines serving multiple workloads whose memory is isolated via
the memory cgroup controller, it is currently impossible to enforce a
fair distribution of toptier memory among the worloads, as the only
enforcable limits have to do with total memory footprint, but not where
that memory resides.

This makes ensuring a consistent and baseline performance difficult, as
each workload's performance is heavily impacted by workload-external
factors such as which other workloads are co-located in the same host,
and the order at which different workloads are started.

Extend the existing memory.low protection to be tier-aware in the
charging, enforcement, and protection calculation to provide
best-effort attempts at protecting a fair proportion of toptier memory.

Updates to protection and charging are performed in the same path as
the standard memcontrol equivalents. Enforcing tier-aware memcg limits
however, are gated behind the sysctl tier_aware_memcg. This is so that
runtime-enabling of tier aware limits can account for memory already
present in the system.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h   | 15 +++++++++++----
 include/linux/page_counter.h |  7 ++++---
 kernel/cgroup/dmem.c         |  2 +-
 mm/memcontrol.c              | 14 ++++++++++++--
 mm/page_counter.c            | 35 ++++++++++++++++++++++++++++++++++-
 mm/vmscan.c                  | 13 +++++++++----
 6 files changed, 71 insertions(+), 15 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 900a36112b62..a998a1e3b8b0 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -606,7 +606,9 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
 }
 
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
-				     struct mem_cgroup *memcg);
+				     struct mem_cgroup *memcg, bool toptier);
+
+unsigned long mem_cgroup_toptier_usage(struct mem_cgroup *memcg);
 
 void update_memcg_toptier_capacity(void);
 
@@ -623,11 +625,15 @@ static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 }
 
 static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+					struct mem_cgroup *memcg, bool toptier)
 {
 	if (mem_cgroup_unprotected(target, memcg))
 		return false;
 
+	if (toptier)
+		return READ_ONCE(memcg->memory.etoptier_low) >=
+				 mem_cgroup_toptier_usage(memcg);
+
 	return READ_ONCE(memcg->memory.elow) >=
 		page_counter_read(&memcg->memory);
 }
@@ -1114,7 +1120,8 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
 }
 
 static inline void mem_cgroup_calculate_protection(struct mem_cgroup *root,
-						   struct mem_cgroup *memcg)
+						   struct mem_cgroup *memcg,
+						   bool toptier)
 {
 }
 
@@ -1128,7 +1135,7 @@ static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
 	return true;
 }
 static inline bool mem_cgroup_below_low(struct mem_cgroup *target,
-					struct mem_cgroup *memcg)
+					struct mem_cgroup *memcg, bool toptier)
 {
 	return false;
 }
diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index ada5f1dd75d4..6635ee7b9575 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -120,15 +120,16 @@ static inline void page_counter_reset_watermark(struct page_counter *counter)
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 void page_counter_calculate_protection(struct page_counter *root,
 				       struct page_counter *counter,
-				       bool recursive_protection);
+				       bool recursive_protection, bool toptier);
 void page_counter_update_toptier_capacity(struct page_counter *counter,
 					  const nodemask_t *allowed);
 unsigned long page_counter_toptier_high(struct page_counter *counter);
 unsigned long page_counter_toptier_low(struct page_counter *counter);
 #else
 static inline void page_counter_calculate_protection(struct page_counter *root,
-						     struct page_counter *counter,
-						     bool recursive_protection) {}
+						struct page_counter *counter,
+						bool recursive_protection,
+						bool toptier) {}
 #endif
 
 #endif /* _LINUX_PAGE_COUNTER_H */
diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 1ea6afffa985..536d43c42de8 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -277,7 +277,7 @@ dmem_cgroup_calculate_protection(struct dmem_cgroup_pool_state *limit_pool,
 			continue;
 
 		page_counter_calculate_protection(
-			climit, &found_pool->cnt, true);
+			climit, &found_pool->cnt, true, false);
 
 		if (found_pool == test_pool)
 			break;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 07464f02c529..8aa7ae361a73 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4806,12 +4806,13 @@ struct cgroup_subsys memory_cgrp_subsys = {
  * mem_cgroup_calculate_protection - check if memory consumption is in the normal range
  * @root: the top ancestor of the sub-tree being checked
  * @memcg: the memory cgroup to check
+ * @toptier: whether the caller is in a toptier node
  *
  * WARNING: This function is not stateless! It can only be used as part
  *          of a top-down tree iteration, not for isolated queries.
  */
 void mem_cgroup_calculate_protection(struct mem_cgroup *root,
-				     struct mem_cgroup *memcg)
+				     struct mem_cgroup *memcg, bool toptier)
 {
 	bool recursive_protection =
 		cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT;
@@ -4822,7 +4823,16 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
 	if (!root)
 		root = root_mem_cgroup;
 
-	page_counter_calculate_protection(&root->memory, &memcg->memory, recursive_protection);
+	page_counter_calculate_protection(&root->memory, &memcg->memory,
+					  recursive_protection, toptier);
+}
+
+unsigned long mem_cgroup_toptier_usage(struct mem_cgroup *memcg)
+{
+	if (mem_cgroup_disabled() || !memcg)
+		return 0;
+
+	return atomic_long_read(&memcg->memory.toptier_usage);
 }
 
 void update_memcg_toptier_capacity(void)
diff --git a/mm/page_counter.c b/mm/page_counter.c
index cf21c72bfd4e..79d46a1c4c0c 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -410,12 +410,39 @@ static unsigned long effective_protection(unsigned long usage,
 	return ep;
 }
 
+static void calculate_protection_toptier(struct page_counter *counter,
+					 bool recursive_protection)
+{
+	struct page_counter *parent = counter->parent;
+	unsigned long toptier_low;
+	unsigned long toptier_usage, parent_toptier_usage;
+	unsigned long toptier_protected, old_toptier_protected;
+	long delta;
+
+	toptier_low = page_counter_toptier_low(counter);
+	toptier_usage = atomic_long_read(&counter->toptier_usage);
+	parent_toptier_usage = atomic_long_read(&parent->toptier_usage);
+
+	/* Propagate toptier low usage to parent for sibling distribution */
+	toptier_protected = min(toptier_usage, toptier_low);
+	old_toptier_protected = atomic_long_xchg(&counter->toptier_low_usage,
+						 toptier_protected);
+	delta = toptier_protected - old_toptier_protected;
+	atomic_long_add(delta, &parent->children_toptier_low_usage);
+
+	WRITE_ONCE(counter->etoptier_low,
+		   effective_protection(toptier_usage, parent_toptier_usage,
+		   toptier_low, READ_ONCE(parent->etoptier_low),
+		   atomic_long_read(&parent->children_toptier_low_usage),
+		   recursive_protection));
+}
 
 /**
  * page_counter_calculate_protection - check if memory consumption is in the normal range
  * @root: the top ancestor of the sub-tree being checked
  * @counter: the page_counter the counter to update
  * @recursive_protection: Whether to use memory_recursiveprot behavior.
+ * @toptier: Whether to calculate toptier-proportional protection
  *
  * Calculates elow/emin thresholds for given page_counter.
  *
@@ -424,7 +451,7 @@ static unsigned long effective_protection(unsigned long usage,
  */
 void page_counter_calculate_protection(struct page_counter *root,
 				       struct page_counter *counter,
-				       bool recursive_protection)
+				       bool recursive_protection, bool toptier)
 {
 	unsigned long usage, parent_usage;
 	struct page_counter *parent = counter->parent;
@@ -446,6 +473,9 @@ void page_counter_calculate_protection(struct page_counter *root,
 	if (parent == root) {
 		counter->emin = READ_ONCE(counter->min);
 		counter->elow = READ_ONCE(counter->low);
+		if (toptier)
+			WRITE_ONCE(counter->etoptier_low,
+				   page_counter_toptier_low(counter));
 		return;
 	}
 
@@ -462,6 +492,9 @@ void page_counter_calculate_protection(struct page_counter *root,
 			READ_ONCE(parent->elow),
 			atomic_long_read(&parent->children_low_usage),
 			recursive_protection));
+
+	if (toptier)
+		calculate_protection_toptier(counter, recursive_protection);
 }
 
 void page_counter_update_toptier_capacity(struct page_counter *counter,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 6a87ac7be43c..5b4cb030a477 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4144,6 +4144,7 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
 	struct mem_cgroup *memcg;
 	unsigned long min_ttl = READ_ONCE(lru_gen_min_ttl);
 	bool reclaimable = !min_ttl;
+	bool toptier = node_is_toptier(pgdat->node_id);
 
 	VM_WARN_ON_ONCE(!current_is_kswapd());
 
@@ -4153,7 +4154,7 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
 	do {
 		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
-		mem_cgroup_calculate_protection(NULL, memcg);
+		mem_cgroup_calculate_protection(NULL, memcg, toptier);
 
 		if (!reclaimable)
 			reclaimable = lruvec_is_reclaimable(lruvec, sc, min_ttl);
@@ -4905,12 +4906,14 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 	unsigned long reclaimed = sc->nr_reclaimed;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	bool toptier = tier_aware_memcg_limits &&
+		       node_is_toptier(pgdat->node_id);
 
 	/* lru_gen_age_node() called mem_cgroup_calculate_protection() */
 	if (mem_cgroup_below_min(NULL, memcg))
 		return MEMCG_LRU_YOUNG;
 
-	if (mem_cgroup_below_low(NULL, memcg)) {
+	if (mem_cgroup_below_low(NULL, memcg, toptier)) {
 		/* see the comment on MEMCG_NR_GENS */
 		if (READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_TAIL)
 			return MEMCG_LRU_TAIL;
@@ -5960,6 +5963,7 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 	};
 	struct mem_cgroup_reclaim_cookie *partial = &reclaim;
 	struct mem_cgroup *memcg;
+	bool toptier = node_is_toptier(pgdat->node_id);
 
 	/*
 	 * In most cases, direct reclaimers can do partial walks
@@ -5987,7 +5991,7 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 		 */
 		cond_resched();
 
-		mem_cgroup_calculate_protection(target_memcg, memcg);
+		mem_cgroup_calculate_protection(target_memcg, memcg, toptier);
 
 		if (mem_cgroup_below_min(target_memcg, memcg)) {
 			/*
@@ -5995,7 +5999,8 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 			 * If there is no reclaimable memory, OOM.
 			 */
 			continue;
-		} else if (mem_cgroup_below_low(target_memcg, memcg)) {
+		} else if (mem_cgroup_below_low(target_memcg, memcg,
+					tier_aware_memcg_limits && toptier)) {
 			/*
 			 * Soft protection.
 			 * Respect the protection only as long as
-- 
2.47.3


