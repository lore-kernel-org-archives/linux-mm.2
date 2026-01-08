Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B9D0D1D48A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 20:38:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831D26B0095; Thu,  8 Jan 2026 15:38:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 805976B0096; Thu,  8 Jan 2026 15:38:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4036B0098; Thu,  8 Jan 2026 15:38:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 59AD26B0095
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:38:58 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 03FF78AC1F
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:38:57 +0000 (UTC)
X-FDA: 84309960756.01.58464A7
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id 26F1D120002
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:38:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dD2CnUOt;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767904736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHxGrBtl/hlNeoeWLQW++mLZlqqQEPHYPIYdLPi7GaY=;
	b=wkTPKiqSZ9VVKFD4+o6qnQQt2Zsg1NeqyYMwffCDqZOpoW6G3nvgV1XxKumdlCs1Vpvefv
	NG843ZtXbfEDYqCoytRI1naTeMlxrclStUf6bTfaQ+rAyjloUh7ivUM/2M7ARK3MoGHzP5
	RcawvVaEB+vtSpS7nNn9vzaJ8G0sD/w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dD2CnUOt;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767904736; a=rsa-sha256;
	cv=none;
	b=0ZeWzN9aBBWWiShM1thPjh9HCpwBiTyKvbrexyYf69DqVcQKlDtIGUBb+a6LjnhqeFG6AR
	pK2Q9INjbhj55jPemdzXk1M7PvLK2//FKTlIIz7Gzh+jE1ca5W1FTMwqTVNEeFC+FRnUdw
	Iqs4ku7AmmqqSeGFIg3Nmc229ilqjdE=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8907ec50855so40193286d6.3
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 12:38:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767904735; x=1768509535; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZHxGrBtl/hlNeoeWLQW++mLZlqqQEPHYPIYdLPi7GaY=;
        b=dD2CnUOtdhP0Ib+D55FqWTIn+Id26xtu806Kffy4NfRkb0CWfX7/Hf+mWI9pPAObOI
         UV3jAdZr3L9I7WwzXV33gzenjHWWFkX1rLezXfn/8FZjoO+gqwpV0pkLetn4HVDY0kkm
         EVbg642P2sW5iRu1jnoiFbYRhhfaP7HlKpWXt3vF9AjRcdh5tMgvyZU+Y46vacFlNp5P
         ZI4ONq53TM16CA0/sgU9HHMQtLrW5b9EaG4Ia69W4SjY3OvsGM9ZcTEVkkyC9QOPYGac
         ANd76fEC8g9F46MSPaofI61DAt/jGt7VBhJ4VYC8myCAtJKXJZ/1hPNMGthkGlIi3Z/D
         YY1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767904735; x=1768509535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZHxGrBtl/hlNeoeWLQW++mLZlqqQEPHYPIYdLPi7GaY=;
        b=CA5J5R+5VkyFSutgqxq3qdZHzc3kLrr/Yizdt3eTSVvSC7JQ+D+Oi5HhDFL27O/HOW
         JSN0xSLglaHloNRp5BL3pwbHTZNnWma04sCvFdD18x7S+0K2EvQNM6x3hwOeEqP8Ywz/
         cOMvo57IzOjcU17b8fmDO+31gnoE40PJ0PnivnhrKqSP5r6WePvuMuMoUbWAH7dsv8UZ
         bKKnuF8y/55FGVWKnOLw7A0N641VRQxaK3ekk5CdT80mPFci8Ixc8mspALYI9Tz3KP9n
         pojAP+lTrVjZVZUvmMPb1EgfH59Kx8KPobxXHjQjWdaKtz7t+B/lMjBKpTmu/03w2UIO
         FjyA==
X-Gm-Message-State: AOJu0YyJk+tq43koFqzdB3MYzDxzVrnjfTf7PF1D5OwGN47kneXT53MC
	oJWCtyWSKa3s/m51SLe5Eb8JlToFgVhQzFzZ6WHXvtt9t5/1HconKX+B5o3TGuirB0q+tPXHr5S
	7JEhw
X-Gm-Gg: AY/fxX7E/2mBm/xMrBaHTL3ReXRrOmqtPZVhycPkDQ485CXg5VbcorockM/dlf0yANH
	a2cSKCVzFEMFIzYpOUXpzajKqovrs8pHnMj3A55OHCsH6r6YfpHlUFZvcgvX4yXfxfjydVqZf2t
	tGZoAs+vHBbFrV683NeSXs6nil0sI+V++rX8Dl1o7wy7exX1WVvNxG71KeMTjWmXQSl9qBX17ih
	O/XLkee/uAmYkoJ1W4MQbPNnIAFwPgiPpt5vZ3BwltFCCegyp1w1Flqcthq4jQ0m+qWeEYrEO/i
	nZ89X18rYbMMSnpRDiOKsTtrHoEKSXqrwx8lavqpCDIqIhhr26tsgzoqiOQj4We1yihFT0Ifx5B
	CBtEsRGPzEBvAJU1FSmSc+rT9sYyO05k6iCVCQ7n1Qhcrh8LBcX0V4G9Lm13O6BgxFKhDYaXtVc
	smOzEDsaiGHP7wEt+kiJt54Zb8GWkIcsiAfCXUDyOwut12WUKi5yfkiHSkmIVYeklWBDpW9GoeE
	FSsskqFhBG+ag==
X-Google-Smtp-Source: AGHT+IHoPDtEyu/qazAej9qUcvHlLXP2al9oKF0ZIuQR82MK0kzJKO/DN4uJk0hBSgOfyzdaEtp2Zw==
X-Received: by 2002:a05:6214:1147:b0:890:9169:d2f5 with SMTP id 6a1803df08f44-8909169d5c2mr55584316d6.64.1767904734853;
        Thu, 08 Jan 2026 12:38:54 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770e472csm60483886d6.23.2026.01.08.12.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 12:38:54 -0800 (PST)
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
Subject: [RFC PATCH v3 4/8] cpuset: introduce cpuset.mems.sysram
Date: Thu,  8 Jan 2026 15:37:51 -0500
Message-ID: <20260108203755.1163107-5-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108203755.1163107-1-gourry@gourry.net>
References: <20260108203755.1163107-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6mmu4s3pps3fjj6aof87zqgeh6riwzdo
X-Rspamd-Queue-Id: 26F1D120002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767904735-287005
X-HE-Meta: U2FsdGVkX18ua+Hlz9gAibcpxsg/hFxqncAKv6LraHOEA9HTNqqHgc7IOOl7ZlNFcLc0zPFS8mHD+E5NzpKjPjvUCjHGnSjOzIlcFdK0+qOYB89qYoTiN28P9J7/0uVhp27cGjweikori8+2b7VIlwZiLVTpZDDhWFKwXPzXpSwOCrLC8pY87Uo3ODAixi1C1xHL4bwG8fvp/deGp9nL92OLorHUkEmUdAx0MXMbf6u45BFBjdjMa1Ieec2v5sPBzxteuJK8GJVdnlPeZdFNXeOVkRrL874FTeuo8ILN+jn6pDywqrfyZpusDLNoNRG/mk5Hr4EhWa+/nwZnDmB/1fvBN8909toiulGkjZSN4Da/Q0hbCdOitxXpbX89ABslxEz7YCXf7kpX+7NdN0VgUPyb+FNy6DPg7XiT8lydBkzTRoJh4uvUHnC0dRA6Q5Qq5jDPGWoXdZvu/r3EUVRDpIcRyen+CkkFEp0W95BEmZkxzgJIawSEa6NB+1G6EVuULaDA4UPnH5MSM6KfoZ2o/vspPCEn6wisH5mG582hV18c0027JrdDBe+fzgHHngGCtbhI9qfK/gHzp2PvofgMi/KrVG8wbI22Asfbm47jsjG2V9sGqmDWxPsF/MQTMfhAiA6eMOWshBm3kaCbRPmXZKBvFbp+Q7MOsPwXaPVhvS83gWdI9SkTLRRzGUiO4YXy00aZzuSjTcp+1GqiYQRPXm+fO2knJPawhw09mY3qV+sEdkRgOzk6SK8JfmYgUbL9FUMnLZ4+9Cvym/Ni453pL7Z3INJ3DDm0RAouVwUWboNRk5e54H3aa8cCNCLb/w3HS1+nDBqawCOiVyOcnEMjZu54ec4pWyAHzZr81aMWl+tU9luI+lakeqxixurWXxJJ3NGKS9Ji7qdduyTzeIyERDvRndUhejFy+ZAcwDdBJXEE8LzDBKX416FGah3DU3lPtd6NW4o64hzvZ8SqEos
 sNPQQAwt
 w4cxiqm1EULhzv2FLnAGbufwshBlsVTsdKInTExpyfkO6IYbJUKpgzkOW6RA9UPVv3XDxcsqo6OpY/fJzX/JSMvN7mKdGAKmdT9JofGzW33gucx1Ku4cnSUYkmGdCh1TbQmw8WWoKP8RyeD8aMswXqDQIgfaHFnfLGenTeY74uuWHJxQRef+kC4NNABvHdvd4fHbgSWBOfC5Qu8rhuZD7pRMpiihckRNN/TMM3XW4Y0XiiP5cPftMSKCZPH5ZGzUBRLE0JfVl6QWRQtu2u7w+r4Peq5woEOfZJINxctZzNl0cGYfuehxM8SGNbOz2wUF9RZ46qlEjw+JqnZXo2Bl8AHPybi1MOI+1I6jzAeb2Qu2Zhj/+YAhyezzuwdjjXt2FiDiIrsMXnhE+ZbvBq85ukXSeXa9pwzeZnVh+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mems_sysram contains only SystemRAM nodes (omitting Private Nodes).

The nodemask is intersect(effective_mems, node_states[N_MEMORY]).

When checking mems_allowed, check for __GFP_THISNODE to determine if
the check should be made against sysram_nodes or mems_allowed.

This omits Private Nodes (N_PRIVATE) from default mems_allowed checks,
making those nodes unreachable via normal allocation paths (page
faults, mempolicies, etc).

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/cpuset.h          | 20 +++++--
 kernel/cgroup/cpuset-internal.h |  8 +++
 kernel/cgroup/cpuset-v1.c       |  8 +++
 kernel/cgroup/cpuset.c          | 96 +++++++++++++++++++++++++--------
 mm/memcontrol.c                 |  2 +-
 mm/mempolicy.c                  |  6 +--
 mm/migrate.c                    |  4 +-
 7 files changed, 112 insertions(+), 32 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index fe4f29624117..1ae09ec0fcb7 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -174,7 +174,9 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 	task_unlock(current);
 }
 
-extern void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask);
+extern void cpuset_sysram_nodes_allowed(struct cgroup *cgroup,
+					nodemask_t *mask);
+extern nodemask_t cpuset_sysram_nodemask(struct task_struct *p);
 #else /* !CONFIG_CPUSETS */
 
 static inline bool cpusets_enabled(void) { return false; }
@@ -218,7 +220,13 @@ static inline bool cpuset_cpu_is_isolated(int cpu)
 	return false;
 }
 
-static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
+static inline void cpuset_sysram_nodes_allowed(struct cgroup *cgroup,
+					       nodemask_t *mask)
+{
+	nodes_copy(*mask, node_possible_map);
+}
+
+static inline nodemask_t cpuset_sysram_nodemask(struct task_struct *p)
 {
 	return node_possible_map;
 }
@@ -301,10 +309,16 @@ static inline bool read_mems_allowed_retry(unsigned int seq)
 	return false;
 }
 
-static inline void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
+static inline void cpuset_sysram_nodes_allowed(struct cgroup *cgroup,
+					       nodemask_t *mask)
 {
 	nodes_copy(*mask, node_states[N_MEMORY]);
 }
+
+static nodemask_t cpuset_sysram_nodemask(struct task_struct *p)
+{
+	return node_states[N_MEMORY];
+}
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
diff --git a/kernel/cgroup/cpuset-internal.h b/kernel/cgroup/cpuset-internal.h
index 01976c8e7d49..4764aaef585f 100644
--- a/kernel/cgroup/cpuset-internal.h
+++ b/kernel/cgroup/cpuset-internal.h
@@ -53,6 +53,7 @@ typedef enum {
 	FILE_MEMORY_MIGRATE,
 	FILE_CPULIST,
 	FILE_MEMLIST,
+	FILE_MEMS_SYSRAM,
 	FILE_EFFECTIVE_CPULIST,
 	FILE_EFFECTIVE_MEMLIST,
 	FILE_SUBPARTS_CPULIST,
@@ -104,6 +105,13 @@ struct cpuset {
 	cpumask_var_t effective_cpus;
 	nodemask_t effective_mems;
 
+	/*
+	 * SystemRAM Memory Nodes for tasks.
+	 * This is the intersection of effective_mems and node_states[N_MEMORY].
+	 * Tasks will have their sysram_nodes set to this value.
+	 */
+	nodemask_t mems_sysram;
+
 	/*
 	 * Exclusive CPUs dedicated to current cgroup (default hierarchy only)
 	 *
diff --git a/kernel/cgroup/cpuset-v1.c b/kernel/cgroup/cpuset-v1.c
index 12e76774c75b..45b74181effd 100644
--- a/kernel/cgroup/cpuset-v1.c
+++ b/kernel/cgroup/cpuset-v1.c
@@ -293,6 +293,8 @@ void cpuset1_hotplug_update_tasks(struct cpuset *cs,
 	cpumask_copy(cs->effective_cpus, new_cpus);
 	cs->mems_allowed = *new_mems;
 	cs->effective_mems = *new_mems;
+	nodes_and(cs->mems_sysram, cs->effective_mems, node_states[N_MEMORY]);
+	cpuset_update_tasks_nodemask(cs);
 	cpuset_callback_unlock_irq();
 
 	/*
@@ -532,6 +534,12 @@ struct cftype cpuset1_files[] = {
 		.private = FILE_EFFECTIVE_MEMLIST,
 	},
 
+	{
+		.name = "mems_sysram",
+		.seq_show = cpuset_common_seq_show,
+		.private = FILE_MEMS_SYSRAM,
+	},
+
 	{
 		.name = "cpu_exclusive",
 		.read_u64 = cpuset_read_u64,
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index a3ade9d5968b..4c213a2ea7ac 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -29,6 +29,7 @@
 #include <linux/mempolicy.h>
 #include <linux/mm.h>
 #include <linux/memory.h>
+#include <linux/memory-tiers.h>
 #include <linux/export.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
@@ -454,11 +455,11 @@ static void guarantee_active_cpus(struct task_struct *tsk,
  *
  * Call with callback_lock or cpuset_mutex held.
  */
-static void guarantee_online_mems(struct cpuset *cs, nodemask_t *pmask)
+static void guarantee_online_sysram_nodes(struct cpuset *cs, nodemask_t *pmask)
 {
-	while (!nodes_intersects(cs->effective_mems, node_states[N_MEMORY]))
+	while (!nodes_intersects(cs->mems_sysram, node_states[N_MEMORY]))
 		cs = parent_cs(cs);
-	nodes_and(*pmask, cs->effective_mems, node_states[N_MEMORY]);
+	nodes_and(*pmask, cs->mems_sysram, node_states[N_MEMORY]);
 }
 
 /**
@@ -2791,7 +2792,7 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)
 
 	cpuset_being_rebound = cs;		/* causes mpol_dup() rebind */
 
-	guarantee_online_mems(cs, &newmems);
+	guarantee_online_sysram_nodes(cs, &newmems);
 
 	/*
 	 * The mpol_rebind_mm() call takes mmap_lock, which we couldn't
@@ -2816,7 +2817,7 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)
 
 		migrate = is_memory_migrate(cs);
 
-		mpol_rebind_mm(mm, &cs->mems_allowed);
+		mpol_rebind_mm(mm, &cs->mems_sysram);
 		if (migrate)
 			cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
 		else
@@ -2876,6 +2877,8 @@ static void update_nodemasks_hier(struct cpuset *cs, nodemask_t *new_mems)
 
 		spin_lock_irq(&callback_lock);
 		cp->effective_mems = *new_mems;
+		nodes_and(cp->mems_sysram, cp->effective_mems,
+			  node_states[N_MEMORY]);
 		spin_unlock_irq(&callback_lock);
 
 		WARN_ON(!is_in_v2_mode() &&
@@ -3304,11 +3307,11 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	 * by skipping the task iteration and update.
 	 */
 	if (cpuset_v2() && !cpus_updated && !mems_updated) {
-		cpuset_attach_nodemask_to = cs->effective_mems;
+		cpuset_attach_nodemask_to = cs->mems_sysram;
 		goto out;
 	}
 
-	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
+	guarantee_online_sysram_nodes(cs, &cpuset_attach_nodemask_to);
 
 	cgroup_taskset_for_each(task, css, tset)
 		cpuset_attach_task(cs, task);
@@ -3319,7 +3322,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	 * if there is no change in effective_mems and CS_MEMORY_MIGRATE is
 	 * not set.
 	 */
-	cpuset_attach_nodemask_to = cs->effective_mems;
+	cpuset_attach_nodemask_to = cs->mems_sysram;
 	if (!is_memory_migrate(cs) && !mems_updated)
 		goto out;
 
@@ -3441,6 +3444,9 @@ int cpuset_common_seq_show(struct seq_file *sf, void *v)
 	case FILE_EFFECTIVE_MEMLIST:
 		seq_printf(sf, "%*pbl\n", nodemask_pr_args(&cs->effective_mems));
 		break;
+	case FILE_MEMS_SYSRAM:
+		seq_printf(sf, "%*pbl\n", nodemask_pr_args(&cs->mems_sysram));
+		break;
 	case FILE_EXCLUSIVE_CPULIST:
 		seq_printf(sf, "%*pbl\n", cpumask_pr_args(cs->exclusive_cpus));
 		break;
@@ -3552,6 +3558,12 @@ static struct cftype dfl_files[] = {
 		.private = FILE_EFFECTIVE_MEMLIST,
 	},
 
+	{
+		.name = "mems.sysram",
+		.seq_show = cpuset_common_seq_show,
+		.private = FILE_MEMS_SYSRAM,
+	},
+
 	{
 		.name = "cpus.partition",
 		.seq_show = cpuset_partition_show,
@@ -3654,6 +3666,8 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 	if (is_in_v2_mode()) {
 		cpumask_copy(cs->effective_cpus, parent->effective_cpus);
 		cs->effective_mems = parent->effective_mems;
+		nodes_and(cs->mems_sysram, cs->effective_mems,
+			  node_states[N_MEMORY]);
 	}
 	spin_unlock_irq(&callback_lock);
 
@@ -3685,6 +3699,8 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 	spin_lock_irq(&callback_lock);
 	cs->mems_allowed = parent->mems_allowed;
 	cs->effective_mems = parent->mems_allowed;
+	nodes_and(cs->mems_sysram, cs->effective_mems,
+		  node_states[N_MEMORY]);
 	cpumask_copy(cs->cpus_allowed, parent->cpus_allowed);
 	cpumask_copy(cs->effective_cpus, parent->cpus_allowed);
 	spin_unlock_irq(&callback_lock);
@@ -3838,7 +3854,7 @@ static void cpuset_fork(struct task_struct *task)
 
 	/* CLONE_INTO_CGROUP */
 	mutex_lock(&cpuset_mutex);
-	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
+	guarantee_online_sysram_nodes(cs, &cpuset_attach_nodemask_to);
 	cpuset_attach_task(cs, task);
 
 	dec_attach_in_progress_locked(cs);
@@ -3887,7 +3903,8 @@ int __init cpuset_init(void)
 	cpumask_setall(top_cpuset.effective_xcpus);
 	cpumask_setall(top_cpuset.exclusive_cpus);
 	nodes_setall(top_cpuset.effective_mems);
-
+	nodes_and(top_cpuset.mems_sysram, top_cpuset.effective_mems,
+		  node_states[N_MEMORY]);
 	fmeter_init(&top_cpuset.fmeter);
 
 	BUG_ON(!alloc_cpumask_var(&cpus_attach, GFP_KERNEL));
@@ -3916,6 +3933,7 @@ hotplug_update_tasks(struct cpuset *cs,
 	spin_lock_irq(&callback_lock);
 	cpumask_copy(cs->effective_cpus, new_cpus);
 	cs->effective_mems = *new_mems;
+	nodes_and(cs->mems_sysram, cs->effective_mems, node_states[N_MEMORY]);
 	spin_unlock_irq(&callback_lock);
 
 	if (cpus_updated)
@@ -4064,7 +4082,15 @@ static void cpuset_handle_hotplug(void)
 
 	/* fetch the available cpus/mems and find out which changed how */
 	cpumask_copy(&new_cpus, cpu_active_mask);
-	new_mems = node_states[N_MEMORY];
+
+	/*
+	 * Effective mems is union(N_MEMORY, N_PRIVATE), this allows
+	 * control over N_PRIVATE node usage from cgroups while
+	 * mems.sysram prevents N_PRIVATE nodes from being used
+	 * without __GFP_THISNODE.
+	 */
+	nodes_clear(new_mems);
+	nodes_or(new_mems, node_states[N_MEMORY], node_states[N_PRIVATE]);
 
 	/*
 	 * If subpartitions_cpus is populated, it is likely that the check
@@ -4106,6 +4132,8 @@ static void cpuset_handle_hotplug(void)
 		if (!on_dfl)
 			top_cpuset.mems_allowed = new_mems;
 		top_cpuset.effective_mems = new_mems;
+		nodes_and(top_cpuset.mems_sysram, top_cpuset.effective_mems,
+			  node_states[N_MEMORY]);
 		spin_unlock_irq(&callback_lock);
 		cpuset_update_tasks_nodemask(&top_cpuset);
 	}
@@ -4176,6 +4204,7 @@ void __init cpuset_init_smp(void)
 
 	cpumask_copy(top_cpuset.effective_cpus, cpu_active_mask);
 	top_cpuset.effective_mems = node_states[N_MEMORY];
+	top_cpuset.mems_sysram = node_states[N_MEMORY];
 
 	hotplug_node_notifier(cpuset_track_online_nodes, CPUSET_CALLBACK_PRI);
 
@@ -4293,14 +4322,18 @@ bool cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 	return changed;
 }
 
+/*
+ * At this point in time, no hotplug nodes can have been added, so just set
+ * the sysram_nodes of the init task to the set of N_MEMORY nodes.
+ */
 void __init cpuset_init_current_mems_allowed(void)
 {
-	nodes_setall(current->mems_allowed);
+	current->mems_allowed = node_states[N_MEMORY];
 }
 
 /**
- * cpuset_mems_allowed - return mems_allowed mask from a tasks cpuset.
- * @tsk: pointer to task_struct from which to obtain cpuset->mems_allowed.
+ * cpuset_sysram_nodemask - return mems_sysram mask from a tasks cpuset.
+ * @tsk: pointer to task_struct from which to obtain cpuset->mems_sysram.
  *
  * Description: Returns the nodemask_t mems_allowed of the cpuset
  * attached to the specified @tsk.  Guaranteed to return some non-empty
@@ -4308,13 +4341,13 @@ void __init cpuset_init_current_mems_allowed(void)
  * tasks cpuset.
  **/
 
-nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
+nodemask_t cpuset_sysram_nodemask(struct task_struct *tsk)
 {
 	nodemask_t mask;
 	unsigned long flags;
 
 	spin_lock_irqsave(&callback_lock, flags);
-	guarantee_online_mems(task_cs(tsk), &mask);
+	guarantee_online_sysram_nodes(task_cs(tsk), &mask);
 	spin_unlock_irqrestore(&callback_lock, flags);
 
 	return mask;
@@ -4383,17 +4416,30 @@ static struct cpuset *nearest_hardwall_ancestor(struct cpuset *cs)
  *	tsk_is_oom_victim   - any node ok
  *	GFP_KERNEL   - any node in enclosing hardwalled cpuset ok
  *	GFP_USER     - only nodes in current tasks mems allowed ok.
+ *	GFP_THISNODE - allows private memory nodes in mems_allowed
  */
 bool cpuset_current_node_allowed(int node, gfp_t gfp_mask)
 {
 	struct cpuset *cs;		/* current cpuset ancestors */
 	bool allowed;			/* is allocation in zone z allowed? */
 	unsigned long flags;
+	bool private_nodes = gfp_mask & __GFP_THISNODE;
 
+	/* Only SysRAM nodes are valid in interrupt context */
 	if (in_interrupt())
-		return true;
-	if (node_isset(node, current->mems_allowed))
-		return true;
+		return node_isset(node, node_states[N_MEMORY]);
+
+	if (private_nodes) {
+		rcu_read_lock();
+		cs = task_cs(current);
+		allowed = node_isset(node, cs->effective_mems);
+		rcu_read_unlock();
+	} else
+		allowed = node_isset(node, current->mems_allowed);
+
+	if (allowed)
+		return allowed;
+
 	/*
 	 * Allow tasks that have access to memory reserves because they have
 	 * been OOM killed to get memory anywhere.
@@ -4412,6 +4458,10 @@ bool cpuset_current_node_allowed(int node, gfp_t gfp_mask)
 	cs = nearest_hardwall_ancestor(task_cs(current));
 	allowed = node_isset(node, cs->mems_allowed);
 
+	/* If not allowing private node allocation, restrict to sysram nodes */
+	if (!private_nodes)
+		allowed &= node_isset(node, node_states[N_MEMORY]);
+
 	spin_unlock_irqrestore(&callback_lock, flags);
 	return allowed;
 }
@@ -4434,7 +4484,7 @@ bool cpuset_current_node_allowed(int node, gfp_t gfp_mask)
  * online due to hot plugins. Callers should check the mask for validity on
  * return based on its subsequent use.
  **/
-void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
+void cpuset_sysram_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
 {
 	struct cgroup_subsys_state *css;
 	struct cpuset *cs;
@@ -4457,16 +4507,16 @@ void cpuset_nodes_allowed(struct cgroup *cgroup, nodemask_t *mask)
 
 	/*
 	 * The reference taken via cgroup_get_e_css is sufficient to
-	 * protect css, but it does not imply safe accesses to effective_mems.
+	 * protect css, but it does not imply safe accesses to mems_sysram.
 	 *
-	 * Normally, accessing effective_mems would require the cpuset_mutex
+	 * Normally, accessing mems_sysram would require the cpuset_mutex
 	 * or callback_lock - but the correctness of this information is stale
 	 * immediately after the query anyway. We do not acquire the lock
 	 * during this process to save lock contention in exchange for racing
 	 * against mems_allowed rebinds.
 	 */
 	cs = container_of(css, struct cpuset, css);
-	nodes_copy(*mask, cs->effective_mems);
+	nodes_copy(*mask, cs->mems_sysram);
 	css_put(css);
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7fbe9565cd06..2df7168edca0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5610,7 +5610,7 @@ void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg, nodemask_t *mask)
 	 * in effective_mems and hot-unpluging of nodes, inaccurate allowed
 	 * mask is acceptable.
 	 */
-	cpuset_nodes_allowed(memcg->css.cgroup, &allowed);
+	cpuset_sysram_nodes_allowed(memcg->css.cgroup, &allowed);
 	nodes_and(*mask, *mask, allowed);
 }
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 76da50425712..760b5b6b4ae6 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1901,14 +1901,14 @@ static int kernel_migrate_pages(pid_t pid, unsigned long maxnode,
 	}
 	rcu_read_unlock();
 
-	task_nodes = cpuset_mems_allowed(task);
+	task_nodes = cpuset_sysram_nodemask(task);
 	/* Is the user allowed to access the target nodes? */
 	if (!nodes_subset(*new, task_nodes) && !capable(CAP_SYS_NICE)) {
 		err = -EPERM;
 		goto out_put;
 	}
 
-	task_nodes = cpuset_mems_allowed(current);
+	task_nodes = cpuset_sysram_nodemask(current);
 	nodes_and(*new, *new, task_nodes);
 	if (nodes_empty(*new))
 		goto out_put;
@@ -2833,7 +2833,7 @@ struct mempolicy *__mpol_dup(struct mempolicy *old)
 		*new = *old;
 
 	if (current_cpuset_is_being_rebound()) {
-		nodemask_t mems = cpuset_mems_allowed(current);
+		nodemask_t mems = cpuset_sysram_nodemask(current);
 		mpol_rebind_policy(new, &mems);
 	}
 	atomic_set(&new->refcnt, 1);
diff --git a/mm/migrate.c b/mm/migrate.c
index 5169f9717f60..0ad893bf862b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2534,7 +2534,7 @@ static struct mm_struct *find_mm_struct(pid_t pid, nodemask_t *mem_nodes)
 	 */
 	if (!pid) {
 		mmget(current->mm);
-		*mem_nodes = cpuset_mems_allowed(current);
+		*mem_nodes = cpuset_sysram_nodemask(current);
 		return current->mm;
 	}
 
@@ -2555,7 +2555,7 @@ static struct mm_struct *find_mm_struct(pid_t pid, nodemask_t *mem_nodes)
 	mm = ERR_PTR(security_task_movememory(task));
 	if (IS_ERR(mm))
 		goto out;
-	*mem_nodes = cpuset_mems_allowed(task);
+	*mem_nodes = cpuset_sysram_nodemask(task);
 	mm = get_task_mm(task);
 out:
 	put_task_struct(task);
-- 
2.52.0


