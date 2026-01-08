Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CC24D1D48A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 20:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28706B0092; Thu,  8 Jan 2026 15:38:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFC4D6B0093; Thu,  8 Jan 2026 15:38:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAA686B0095; Thu,  8 Jan 2026 15:38:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BAC866B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:38:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5897A1602E2
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:38:48 +0000 (UTC)
X-FDA: 84309960336.24.9B7E0B9
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7665FC0002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:38:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=csVCohjk;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767904726; a=rsa-sha256;
	cv=none;
	b=GW9SAGvmW28bLFPzJa0TqTjjzG0x16REtKBPO1iiUKmnuxBSkUmIG3POygsz/9PsGSv0Q0
	5dAVg7dhSae0fbdVrKc7QV0cd+8X1Wu6ng+sQSqDkU4Af2O9QmnRsT6ivfWBySyy7wRL6A
	dWpgeXWjZw9w9BN1SoSIywg4ETNXRqw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=csVCohjk;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767904726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nggVLtJRnFU0QDlUT0CWimedJUol/+KzTaLPJoqAtUY=;
	b=j9XVtyGlgrsxJ7xj2KnFZtqemRICHkfc0BzLdL2AmvEN+V1uUe+3v3cW9HVbfD3XrdfxQ9
	Lr1/aCBcBjk1s8xsYKh5OQR1UVfrnXhVnZ6zjJyq89PQzNe4rBDRDXz9xbZOhHbQoaSatN
	q/Nhdf0BNO7C2mrFbYs0fyccwpxve/4=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88fe44cce7eso28999936d6.3
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 12:38:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767904725; x=1768509525; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nggVLtJRnFU0QDlUT0CWimedJUol/+KzTaLPJoqAtUY=;
        b=csVCohjkR/nG9gS74VOwOEHFfwnxnQICiKzcVDMi2oU7XiiieqjMqI2YEZsa2TEC8c
         nROiCulVUYM76wEvM9pcQXNsb/MreKX9ey8KNTcxHAkgF7pHB/u+oXMviQTMG+jNmg2f
         RQpCS5FJdMKDgFCog/RYe0jqAfMN25T30+yuOBQueeoVPo/P1hkL1X0LOniZX/M1CuRI
         4oSq/vIGv3ZS/9DJHzX7FIl9yGYIqXFJzBzgiOCZD2CjEGFzYepYH2IV+5oWqAbvqxcP
         mR0auy0iEYkjqVkAM+PqMNZga27wHTtEjBddEiVVM6jjmdGCAroxeKs6ueKvhFtZkOjC
         rcfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767904725; x=1768509525;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nggVLtJRnFU0QDlUT0CWimedJUol/+KzTaLPJoqAtUY=;
        b=Y7A+MkgkDkXpr/wC4bT5lz7RWpJsCU+reSkqarX8V7XvHMC1AYBN6+WLSoqhk0yT/Z
         ANNBGxcu/9qNg/VveRixh+93/7lnyAOXldrGAWUIT05g/Abp9tMqNB3gpkbRZhGgYGjS
         rRHyHQK2/4qba4b45+g3Oelvs3L7JXSUI9N9U4wdrfI2oX/XD4ISD15uqknR0oFqJjVa
         lIyr93lMxgI+UWcY3WWOJerbrzoLv2IxTODAUQOYEKeYv1FT+PZWJZgW8+e+rCkbFu5H
         5WPZsU0K/sMHoR0kcMgGmYUSmTF+Mt5KXXIYdIIcqFH3QXvEZCS6PJDJkKTCLZ8rbYF5
         ItYg==
X-Gm-Message-State: AOJu0Ywf3C90WPjd5BJXqeq8Xae9E9k7DtvQNoqXRjKHKuXEQTz0QvYu
	EVJprNf2rbnKIA+GvWEMdiAO1O3POVMqwamje+f04AsH2ULjDEascIbChl2t5iZULYoOY4fFkge
	QmUH9
X-Gm-Gg: AY/fxX4Ey/uCzh48Mf19EZ6ETRj2whe5XXRhw3p8a7c7DO+u4Nhkr5hGJLp0Tixq/Y9
	N/QuML4uOD+cNgNLMh3wnMqlZMd03Wq5KOOVEShV3Z2P2aZmUDiMF8Kuy3TAjCF+cB3SeBgAztP
	22GqgtsM60gk9IoIdyLVkM9MLVV0RiXfuqSH2vJK6v2XlsmYmzj4JeHMVDsRFb+JjROEB+qWybD
	X/hzIudLXs1tmZPN8NCzIdDRPxMJRfFeDEapJ0+7QOVbWGUUHa/Rc6ktY8GDQiaWS5HkPSgDQeq
	unzr4iDPToWidT2dUFmIlHjTM1hC3c1dJOKhbdcFey5zbtFHgpO0196DUGJ18Pd+2yrz6Kqwogu
	hOr7FPMj/rsOP4NX/yo51+timOeJjrOstvjNWnkOKYX/vhwOYsm+IIBd22sbcqrahqOXg38dejJ
	DOeBiCimGpzjoRX/fx92Ws1LB03VwlF07ISz5/Jy7Se5zr8MB/LVDsfU5cinAAUQMrgneCXBITD
	To=
X-Google-Smtp-Source: AGHT+IGGkUof/CU2/WL6ia65lx/hKwi6wIF+fNWN77FX8bbJUBtv8zQ3F0zWY/9RAxC3ckJGR4/xjQ==
X-Received: by 2002:a05:6214:e4f:b0:88a:52a1:2576 with SMTP id 6a1803df08f44-8908418394fmr114080716d6.1.1767904725150;
        Thu, 08 Jan 2026 12:38:45 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770e472csm60483886d6.23.2026.01.08.12.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 12:38:44 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-cxl@vger.kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	corbet@lwn.net,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	ziy@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	yosry.ahmed@linux.dev,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	osalvador@suse.de,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	zhengqi.arch@bytedance.com
Subject: [RFC PATCH v3 2/8] mm: constify oom_control, scan_control, and alloc_context nodemask
Date: Thu,  8 Jan 2026 15:37:49 -0500
Message-ID: <20260108203755.1163107-3-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108203755.1163107-1-gourry@gourry.net>
References: <20260108203755.1163107-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7665FC0002
X-Stat-Signature: ptkc91g9pb7yim64zx8cxhry6orq5gj8
X-Rspam-User: 
X-HE-Tag: 1767904726-139597
X-HE-Meta: U2FsdGVkX18NO5uZSJBVggCAQfPC7LiYhvS0o1yqvnKTNtrpd0zqtXprFRKHGP/pT7wXrhcDUb0cKXnfWrpJJrWjgl6TtwFBhC2BJA+6OeC9kchJoDRaYM8SyaRIFK9dIYH945WWayhMOW7i8JDgbYnbh8wfKzblnaHNpT3cQvy1VVNyxPTk3BKMjIUjD/ZrS5zJlX+6dQnVGtYQyUjs9+3YBGG6db0ZBnMoeu02uAWpPHXeHKQrPq8LxNV2/74+Eqdqf67MGDn4HV4DUzYz2xuOpPcuzM4JZqox3uPEcNYLBWmJjAZT28sBgfLwGuOMv7VaPN3yQ+z8WifxXS1TSNFpi/+Y0UK7dQCiA5haXrEM648gdJgUbF382+WdC1dHix4ZilpntiFJI/aJV6zmXmTz/g27OGiee+kEU+ekVAsL2AiqBf68qgOJ5phfnhH0LJ6vE3WpZAzSCXnOTbOE0tAccv8Dn2a1ImyFUilWnTj/6ReBxplh4q0XDgAgouHXWy8khzaKr7ZsIFgX7U4OR65k7GF7RsbAhrPafJ0ZAm6VBEI0WshaM0NCGUeWOLRfJs0LdiVCB6WWwNnb6uu2d7Xev1OV2BdRZRYHca6O0HKxb55qmgAUFUnnKUD62W6R0w+rJ+vAa8SI78+ByEYa1ospB4dc8+sCP0tX9p5V8CLT0OBRPlJzbjMwH0mFc3zYMJ7AIfTT0+4E7zjhl45G5PQSiqS0q3r84Io1Ahlv+F2cVIF2yBpO025/eWv8Vd0rIx0p+Ju70JkkdW2tWi5ANasW4h4ZElRXpD05auo4G4CztkmSC7zD+aWFTWzy1QWtc/tLExZip7hrL+jMCn0j24vTJHDxE0dY55JIo2POs6kxHTbyC6G9hQUdSa8CmY2Q0HJTlPx7R3xGdI8Wq19FFetbc0UhOydWXFdXzuMb6/keKB7MCdQeu7sx9Lhlcfy3jPlcr1MCqx1k+MhVAYx
 WFxdpLn3
 pKtQnnWk5j8+M4Cik8S9uuvjkAhiV/6mw2oewwmTTbx34zsZ8imnIte+0IJaph9wJe16vyTAn/7KNNrGX+07SiF61cFz4BZz8QpnZh2jxHtXs/M6Mp6Q/2Lub0bGdKp5B6Jj/gk9lZdAUSoRO33lDv9hqLeawhiIVheNxcHC3NGg8VoCLrRTttIq4nxVoyQJJEJKNVezl52j+4/tvSeHwr39EgeErmKnn8yA+AgeeutwfwokhPIEwDP/rkT+05oXgGXgCc/5h2oQTCQBrem1l1vPHmcayhDWqOgOETPOOj2VIJc+ywGuGMRiyX8Bi5s/aQ5Bc/Hm9zMS30t3jdIxJ7nXsBcenJ5E8nnOQY77vam48uL7ljPlH9fujj8rloilsAzafhY2Bzp+BZZbHLdGXZHzMtZhMDNheceayaA2rLNIE6XPCSdsn5cL6QSywxNwv7pIpaKvV7cEPdGo=
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
index 631577384677..fe4f29624117 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -81,7 +81,7 @@ extern bool cpuset_cpu_is_isolated(int cpu);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
-int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask);
+int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask);
 
 extern bool cpuset_current_node_allowed(int node, gfp_t gfp_mask);
 
@@ -226,7 +226,7 @@ static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
 #define cpuset_current_mems_allowed (node_states[N_MEMORY])
 static inline void cpuset_init_current_mems_allowed(void) {}
 
-static inline int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
+static inline int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
 {
 	return 1;
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 45dfb2f2883c..dd4f5d49f638 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3572,7 +3572,7 @@ extern int __meminit early_pfn_to_nid(unsigned long pfn);
 extern void mem_init(void);
 extern void __init mmap_init(void);
 
-extern void __show_mem(unsigned int flags, nodemask_t *nodemask, int max_zone_idx);
+extern void __show_mem(unsigned int flags, const nodemask_t *nodemask, int max_zone_idx);
 static inline void show_mem(void)
 {
 	__show_mem(0, NULL, MAX_NR_ZONES - 1);
@@ -3582,7 +3582,7 @@ extern void si_meminfo(struct sysinfo * val);
 extern void si_meminfo_node(struct sysinfo *val, int nid);
 
 extern __printf(3, 4)
-void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...);
+void warn_alloc(gfp_t gfp_mask, const nodemask_t *nodemask, const char *fmt, ...);
 
 extern void setup_per_cpu_pageset(void);
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 6a7db0fee54a..7f94d67ffac4 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1721,7 +1721,7 @@ static inline int zonelist_node_idx(const struct zoneref *zoneref)
 
 struct zoneref *__next_zones_zonelist(struct zoneref *z,
 					enum zone_type highest_zoneidx,
-					nodemask_t *nodes);
+					const nodemask_t *nodes);
 
 /**
  * next_zones_zonelist - Returns the next zone at or below highest_zoneidx within the allowed nodemask using a cursor within a zonelist as a starting point
@@ -1740,7 +1740,7 @@ struct zoneref *__next_zones_zonelist(struct zoneref *z,
  */
 static __always_inline struct zoneref *next_zones_zonelist(struct zoneref *z,
 					enum zone_type highest_zoneidx,
-					nodemask_t *nodes)
+					const nodemask_t *nodes)
 {
 	if (likely(!nodes && zonelist_zone_idx(z) <= highest_zoneidx))
 		return z;
@@ -1766,7 +1766,7 @@ static __always_inline struct zoneref *next_zones_zonelist(struct zoneref *z,
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
index 62fc7499b408..1569f3f4773b 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -370,7 +370,7 @@ extern void swap_setup(void);
 /* linux/mm/vmscan.c */
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
-					gfp_t gfp_mask, nodemask_t *mask);
+					gfp_t gfp_mask, const nodemask_t *mask);
 
 #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
 #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 289fb1a72550..a3ade9d5968b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4326,7 +4326,7 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
  *
  * Are any of the nodes in the nodemask allowed in current->mems_allowed?
  */
-int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
+int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
 {
 	return nodes_intersects(*nodemask, current->mems_allowed);
 }
diff --git a/mm/internal.h b/mm/internal.h
index 6dc83c243120..50d32055b544 100644
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
index ecb2646b57ba..bb89d81aa68c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3988,7 +3988,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	return NULL;
 }
 
-static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
+static void warn_alloc_show_mem(gfp_t gfp_mask, const nodemask_t *nodemask)
 {
 	unsigned int filter = SHOW_MEM_FILTER_NODES;
 
@@ -4008,7 +4008,7 @@ static void warn_alloc_show_mem(gfp_t gfp_mask, nodemask_t *nodemask)
 	mem_cgroup_show_protected_memory(NULL);
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
index 7c962ee7819f..23f68e754738 100644
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
@@ -6502,7 +6502,7 @@ static bool allow_direct_reclaim(pg_data_t *pgdat)
  * happens, the page allocator should not consider triggering the OOM killer.
  */
 static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
-					nodemask_t *nodemask)
+				    const nodemask_t *nodemask)
 {
 	struct zoneref *z;
 	struct zone *zone;
@@ -6582,7 +6582,7 @@ static bool throttle_direct_reclaim(gfp_t gfp_mask, struct zonelist *zonelist,
 }
 
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
-				gfp_t gfp_mask, nodemask_t *nodemask)
+				gfp_t gfp_mask, const nodemask_t *nodemask)
 {
 	unsigned long nr_reclaimed;
 	struct scan_control sc = {
-- 
2.52.0


