Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2248DCD3444
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 19:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DFFD8E000E; Wed, 12 Nov 2025 14:29:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791048E0002; Wed, 12 Nov 2025 14:29:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67DC78E000E; Wed, 12 Nov 2025 14:29:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4DA458E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:29:54 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1AA2C160666
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:29:54 +0000 (UTC)
X-FDA: 84102945108.09.7FDEBF3
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id 49C12A0012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:29:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gPbrAhQr;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762975792; a=rsa-sha256;
	cv=none;
	b=0ZGASvdSvkamJqPfCo69KuwxLIgkamO6QdQAoCIJGxRlyGx/DDHNjKC+h2vlkBby+F6+mX
	4pXclw+OOJTHtG+guvNvDgqH3H9m6P5XW1gjccVyM/xuBGaWO6u6ejZtzzYBdRrMKpl3Ub
	+eMxo+sH9297THUsVPM7rVRj7rWfBfE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gPbrAhQr;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762975792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T7tukR8goduFTZ00FpwpL7JWktUWF3Mq7A3Wmoox3b0=;
	b=nHK0s7ZMGqVmieXGUr7QMfdBaF2yOuzUq4ij1u//1Z4fdP7DZhRg1p8hmdWkOCw6J8vy3m
	oYEy93heMxrSwY7Gc3+KCeie4ehfOdhAsQTNIl3ncdy/sQ2C4dQRYRZTtuQ6xM7xV67dxk
	sRprSughmUqvF4z3f52Ctew1zIsSzDY=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8b25ed53fcbso7046685a.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762975791; x=1763580591; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T7tukR8goduFTZ00FpwpL7JWktUWF3Mq7A3Wmoox3b0=;
        b=gPbrAhQrIDczy4pGXOtrOe5AJNju+W6o8YzjR40OVB0/zcL6eFB8hmmWtjzwWSQwMJ
         Fi9E6spLlaPix8N58m64CeER6pM0BJ0Z6Mfq2o7wx971/f8ZqEAGMQ1YhXqZDQdayruW
         vk5uf88E32TnVxoz/6+xtvMqKSOAP0OBhgE/f6J0d3SLyLj53d0dbCsksnb3Nz5wYY+7
         BtCQHJJpDdgLIB8960dnPR3qL83reWZm/pOaq1YqWUD1FyCuH7yiQjvo2C+A75Y3YorJ
         8sEzFU/dMDrYa5w1ZUXSm+mYJcyHsZROK55ESRWeoQruTUdOZYSKvRENgnsODXw6yKNn
         XQOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975791; x=1763580591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T7tukR8goduFTZ00FpwpL7JWktUWF3Mq7A3Wmoox3b0=;
        b=BHnDgUzWggOLqFJgp2s8bKapZy+kW3pZV7wW25ctxWU0suEeFrIfmYyZYQumMOOe+p
         OV/i6nl4CKti2+KGZi09c9yNngZ2LZQZZBSfh+QlYARq8d4xo6ZCwMUMN/wcHBLMFRxw
         sUAk6Uv5Pg0TQhByLo7hByqf+s3VdkRYX0SvdQiM79Jd4WQY0e/HTW/Y2Rte3gK6x2Hs
         R6lzyGpo5p939gqinKtufrq/F4mW53jR04/nIg09nUoxIUTqEAJXFiNo6cZFYBa3j0No
         KsYv1kvJv7EIFbjLBhHALA5MRYKU9z3mN0kbEjKPmvEhutob4lv66h2hCQMr9++O6uPU
         ay2Q==
X-Gm-Message-State: AOJu0Yy3N++LYhwnd4oyhhs5Fh3TibY5g/hLEKVVBs77Gfsu7Hftk8rP
	vUPSvY43L3u1bdbFgptz0LsrYl5sqsWJhOwTrwLxuobMUHqa81l1Ai/RoWSpYoCFDafhQhPc9ZO
	/VcLg
X-Gm-Gg: ASbGncvUvRUJs5DWN36/StcNkS4QMqJh/ZuTQ1vQ9g2YlyxaI1F6cfYcyY9vrhfu2AE
	wtVxnDoBl9oDEply5E/lQkHXVk2GGoe/zMSae5cWIg+7amiowlIJ+3JHn7Y3uA9iUm3lp1lMgqy
	ordmzxwJTfQapLDgmswgnaZ9Vn/v1vnuttg5HuQ6CWQBGVgdNNohwJpUDtPSogf3oLY7/AR2iXk
	nZT9XTwixtpdbT/tOM0J1N5gER1MllFJvV99msWnaC4eghpLlfgWeFI4zBPqheFaFoxuBg2MmgU
	nAYIsJQf7fY50ivcwmRjEEgTZB851bdppqgcfU/WY9oDjEGrD3ZJMWX1Eykt4zXF9HibnyB+GG+
	td+1jNa7cjZ75rNx7ipFEhiqd4mS7tQwjcl19zg0ZuyD3+f10ZS08X2RnY9KnOpMInkzHe79i7C
	nC7LbX5rp1uS/C5VdAQzRhUcLMVyQH26D5bnpCrwrCd6V6zqvhtTjwm+3OtjtHLWai
X-Google-Smtp-Source: AGHT+IHo8OwgwUC032YSv60eOJd12q77M7KD3oUAYRPoiD1R5IwVdmpQvxPyI0R/rCY63GPtuNDIug==
X-Received: by 2002:a05:620a:4406:b0:8a4:40da:b907 with SMTP id af79cd13be357-8b29b768ba9mr557487185a.32.1762975790793;
        Wed, 12 Nov 2025 11:29:50 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29aa0082esm243922885a.50.2025.11.12.11.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 11:29:50 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	kees@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	rientjes@google.com,
	jackmanb@google.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com,
	rrichter@amd.com,
	ming.li@zohomail.com,
	usamaarif642@gmail.com,
	brauner@kernel.org,
	oleg@redhat.com,
	namcao@linutronix.de,
	escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: [RFC PATCH v2 01/11] mm: constify oom_control, scan_control, and alloc_context nodemask
Date: Wed, 12 Nov 2025 14:29:17 -0500
Message-ID: <20251112192936.2574429-2-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112192936.2574429-1-gourry@gourry.net>
References: <20251112192936.2574429-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 49C12A0012
X-Stat-Signature: 3w1fod133y8h9co3ihi3dpxeqz1945rr
X-Rspam-User: 
X-HE-Tag: 1762975792-612839
X-HE-Meta: U2FsdGVkX18CQAp6eWHEHDGVuzCnfUadXUB6xOczr35ot8ng9s55fhVX9NOwP/36hfhiBs7qfeWQZOXr5nKh3ptsaS8Zrdj1J1yvSA5O/2MEpegAFVafisxP4S+MvtMQyNozI4DMjrdSCywt+IcTKOFlyGlzof7sOBj0nYjmqUvNav96mTE0+nxhCVYInbcC9DW9afHzdracM3i6Zd8iBlYttnrLZ1sMPve/FyQVaVc1SX1dMDanbAyZJSyC3onRfSI03WZENrQjEFS8TXUwA61Q3aKiM0fSz8l5uFKx9E7pLhXOY+9Sclow2bZtJzj1a0dA0i2jpgUEepZhLaOYy6tKdBU7eJ5rE7SE1s1oajpfjn1nVfXqMtFszh8YGAODIVvT1u/7nTWP5TTK2x81rul+CnLrW4U+2x8WLzSYXuPpWEmBt0gJMh5MO5k/BnGkOWroZ9U0bkvSefsPdaZAxF2EkLFBnpNH0K4MTJytE79XfWuhGF7PdzSkSMsuxfzwIPsAuX6Qz+8SSy2AtfmjezzngkZeCx5+vX0NtNfpZnZVNdC07Ig/g+pMkM0poQrIQGSH0ZVQx+GUXk3JOCnNSmT9iRDk9a/SspYiJ2CZJAAAnM/7VY0iXYWEX92ijR2MCkxLEXN9ugY5IbVxvvuNHuJKeuXvSojIp6CXZvK3tpZihAhn5+8HWUAQxnEN79p3fI9SjiXtnvu4dqf1fnnSXg+x2+lPFz3lgcfSxdOeF+CoWnDHQXsimR0AHCNdyF/KfCY4nK/wbJ2CMygwbdmxhMioxXtH4CUdxqJLyeQOffhadtBKrQXZLEBF5g3tg4iW4i7iXTQ6RBcLqt+FVbp6LLudd1H4y8zLOMBd7aREXtBsEAWLSpiqSiIsuO68jEvn8A5eP20DNiRuUC4vTZc7lDcJE+KHLl6H8D9jU9rper7hMKj+mP2l18uAYBebBOsEGs2bQdLKK42VpoFkIVn
 fX/Qk2Qn
 QYHJYxliRNbvn63xfOo+G5ruPyrbRKEAy11VfG0PC8KdmLhqWX9pWEUXFp2YDg/lIr0lOAoT2F9M0RJ3u7ZXJ4aUBotVjJkyyT0N9uTgemBkPcLCYke1gvnHFcn31tXSuFWnwCC3ph+e0RpmmFfyOZsGt/ZBec2ILn0H0bNfjsDsddJvoJCJLuJYFlTY0gkm11DO3q3uOVHzytqgambmcn0dora8ee9X4CJgSHFirpnpaB9d0dL3JG+3ADBDEiPuugsRWnt69lp0tyueIKg27vz4TT+SZxbbZ0Wafdjff4ioa96hSns3tKtx4xrKIkkMBXs4HHy+gtkAc+EyWzAlTx6jsvCwjvunuEoGoVLT9qxtenuJXW7xKBPOPgsjBDqrf4PFdSwvGZWQ01IYvB4vs2u/APufW+Gi3ea+kRL/3b+6Jb3YRdt9jjB3boewqt3fm58ujou8G2zVUlmM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The nodemasks in these structures may come from a variety of sources,
including tasks and cpusets - and should never be modified by any code
when being passed around inside another context.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/cpuset.h | 4 ++--
 include/linux/mm.h     | 4 ++--
 include/linux/mmzone.h | 6 +++---
 include/linux/oom.h    | 2 +-
 include/linux/swap.h   | 2 +-
 kernel/cgroup/cpuset.c | 2 +-
 mm/internal.h          | 2 +-
 mm/mmzone.c            | 5 +++--
 mm/page_alloc.c        | 4 ++--
 mm/show_mem.c          | 9 ++++++---
 mm/vmscan.c            | 6 +++---
 11 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 2ddb256187b5..548eaf7ef8d0 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -80,7 +80,7 @@ extern bool cpuset_cpu_is_isolated(int cpu);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
-int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
+int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask);
 
 extern bool cpuset_current_node_allowed(int node, gfp_t gfp_mask);
 
@@ -219,7 +219,7 @@ static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
 #define cpuset_current_mems_allowed (node_states[N_MEMORY])
 static inline void cpuset_init_current_mems_allowed(void) {}
 
-static inline int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
+static inline int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
 {
 	return 1;
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index d16b33bacc32..1a874917eae6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3343,7 +3343,7 @@ extern int __meminit early_pfn_to_nid(unsigned long pfn);
 extern void mem_init(void);
 extern void __init mmap_init(void);
 
-extern void __show_mem(unsigned int flags, nodemask_t *nodemask, int max_zone_idx);
+extern void __show_mem(unsigned int flags, const nodemask_t *nodemask, int max_zone_idx);
 static inline void show_mem(void)
 {
 	__show_mem(0, NULL, MAX_NR_ZONES - 1);
@@ -3353,7 +3353,7 @@ extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 
 extern __printf(3, 4)
-void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...);
+void warn_alloc(gfp_t gfp_mask, const nodemask_t *nodemask, const char *fmt, ...);
 
 extern void setup_per_cpu_pageset(void);
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7fb7331c5725..5c96b2c52817 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1725,7 +1725,7 @@ static inline int zonelist_node_idx(const struct zoneref *zoneref)
 
 struct zoneref *__next_zones_zonelist(struct zoneref *z,
 					enum zone_type highest_zoneidx,
-					nodemask_t *nodes);
+					const nodemask_t *nodes);
 
 /**
  * next_zones_zonelist - Returns the next zone at or below highest_zoneidx within the allowed nodemask using a cursor within a zonelist as a starting point
@@ -1744,7 +1744,7 @@ struct zoneref *__next_zones_zonelist(struct zoneref *z,
  */
 static __always_inline struct zoneref *next_zones_zonelist(struct zoneref *z,
 					enum zone_type highest_zoneidx,
-					nodemask_t *nodes)
+					const nodemask_t *nodes)
 {
 	if (likely(!nodes && zonelist_zone_idx(z) <= highest_zoneidx))
 		return z;
@@ -1770,7 +1770,7 @@ static __always_inline struct zoneref *next_zones_zonelist(struct zoneref *z,
  */
 static inline struct zoneref *first_zones_zonelist(struct zonelist *zonelist,
 					enum zone_type highest_zoneidx,
-					nodemask_t *nodes)
+					const nodemask_t *nodes)
 {
 	return next_zones_zonelist(zonelist->_zonerefs,
 							highest_zoneidx, nodes);
diff --git a/include/linux/oom.h b/include/linux/oom.h
index 7b02bc1d0a7e..00da05d227e6 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -30,7 +30,7 @@ struct oom_control {
 	struct zonelist *zonelist;
 
 	/* Used to determine mempolicy */
-	nodemask_t *nodemask;
+	const nodemask_t *nodemask;
 
 	/* Memory cgroup in which oom is invoked, or NULL for global oom */
 	struct mem_cgroup *memcg;
diff --git a/include/linux/swap.h b/include/linux/swap.h
index e818fbade1e2..f5154499bafd 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -381,7 +381,7 @@ extern void swap_setup(void);
 /* linux/mm/vmscan.c */
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
-					gfp_t gfp_mask, nodemask_t *mask);
+					gfp_t gfp_mask, const nodemask_t *mask);
 
 #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
 #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 52468d2c178a..cd3e2ae83d70 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4238,7 +4238,7 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
  *
  * Are any of the nodes in the nodemask allowed in current->mems_allowed?
  */
-int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
+int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
 {
 	return nodes_intersects(*nodemask, current->mems_allowed);
 }
diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..464e60dd7ba1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -587,7 +587,7 @@ void page_alloc_sysctl_init(void);
  */
 struct alloc_context {
 	struct zonelist *zonelist;
-	nodemask_t *nodemask;
+	const nodemask_t *nodemask;
 	struct zoneref *preferred_zoneref;
 	int migratetype;
 
diff --git a/mm/mmzone.c b/mm/mmzone.c
index 0c8f181d9d50..59dc3f2076a6 100644
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -43,7 +43,8 @@ struct zone *next_zone(struct zone *zone)
 	return zone;
 }
 
-static inline int zref_in_nodemask(struct zoneref *zref, nodemask_t *nodes)
+static inline int zref_in_nodemask(struct zoneref *zref,
+				   const nodemask_t *nodes)
 {
 #ifdef CONFIG_NUMA
 	return node_isset(zonelist_node_idx(zref), *nodes);
@@ -55,7 +56,7 @@ static inline int zref_in_nodemask(struct zoneref *zref, nodemask_t *nodes)
 /* Returns the next zone at or below highest_zoneidx in a zonelist */
 struct zoneref *__next_zones_zonelist(struct zoneref *z,
 					enum zone_type highest_zoneidx,
-					nodemask_t *nodes)
+					const nodemask_t *nodes)
 {
 	/*
 	 * Find the next suitable zone to use for the allocation.
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 600d9e981c23..fd5401fb5e00 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3924,7 +3924,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	return NULL;
 }
 
-static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
+static void warn_alloc_show_mem(gfp_t gfp_mask, const nodemask_t *nodemask)
 {
 	unsigned int filter = SHOW_MEM_FILTER_NODES;
 
@@ -3943,7 +3943,7 @@ static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
 	__show_mem(filter, nodemask, gfp_zone(gfp_mask));
 }
 
-void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
+void warn_alloc(gfp_t gfp_mask, const nodemask_t *nodemask, const char *fmt, ...)
 {
 	struct va_format vaf;
 	va_list args;
diff --git a/mm/show_mem.c b/mm/show_mem.c
index 3a4b5207635d..24685b5c6dcf 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -116,7 +116,8 @@ void si_meminfo_node(struct sysinfo *val, int nid)
  * Determine whether the node should be displayed or not, depending on whether
  * SHOW_MEM_FILTER_NODES was passed to show_free_areas().
  */
-static bool show_mem_node_skip(unsigned int flags, int nid, nodemask_t *nodemask)
+static bool show_mem_node_skip(unsigned int flags, int nid,
+			       const nodemask_t *nodemask)
 {
 	if (!(flags & SHOW_MEM_FILTER_NODES))
 		return false;
@@ -177,7 +178,8 @@ static bool node_has_managed_zones(pg_data_t *pgdat, int max_zone_idx)
  * SHOW_MEM_FILTER_NODES: suppress nodes that are not allowed by current's
  *   cpuset.
  */
-static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
+static void show_free_areas(unsigned int filter, const nodemask_t *nodemask,
+			    int max_zone_idx)
 {
 	unsigned long free_pcp = 0;
 	int cpu, nid;
@@ -399,7 +401,8 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 	show_swap_cache_info();
 }
 
-void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
+void __show_mem(unsigned int filter, const nodemask_t *nodemask,
+		int max_zone_idx)
 {
 	unsigned long total = 0, reserved = 0, highmem = 0;
 	struct zone *zone;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b2fc8b626d3d..03e7f5206ad9 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -80,7 +80,7 @@ struct scan_control {
 	 * Nodemask of nodes allowed by the caller. If NULL, all nodes
 	 * are scanned.
 	 */
-	nodemask_t	*nodemask;
+	const nodemask_t *nodemask;
 
 	/*
 	 * The memory cgroup that hit its limit and as a result is the
@@ -6530,7 +6530,7 @@ static bool allow_direct_reclaim(pg_data_t *pgdat)
  * happens, the page allocator should not consider triggering the OOM killer.
  */
 static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
-					nodemask_t *nodemask)
+				    const nodemask_t *nodemask)
 {
 	struct zoneref *z;
 	struct zone *zone;
@@ -6610,7 +6610,7 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
 }
 
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
-				gfp_t gfp_mask, nodemask_t *nodemask)
+				gfp_t gfp_mask, const nodemask_t *nodemask)
 {
 	unsigned long nr_reclaimed;
 	struct scan_control sc = {
-- 
2.51.1


