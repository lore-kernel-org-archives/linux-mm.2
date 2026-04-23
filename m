Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E86CFDEE48
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 20:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38D396B0093; Thu, 23 Apr 2026 16:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3614D6B0092; Thu, 23 Apr 2026 16:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5F86B0093; Thu, 23 Apr 2026 16:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 05CFA6B008C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:34:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BAF9E1404A1
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:34:52 +0000 (UTC)
X-FDA: 84690974424.07.042818A
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id E168FC000D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:34:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CYju+vRK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776976490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Sc+ZsDjiZEjytSKxuIVGQ3PUb0Eu41iRMSui9hW2VQ=;
	b=mAd/C8Vx7gmH5tVU1qUS8DHoyFsLXu1cnPWEQApRS7FZCeCH5pbbt+85JXyxX6GRFKwD6d
	U++NtDGfl4bqgWKM7t11Hccf5vMtW5JnMFBgK7GPFaVGJxsC+TuRix1oyuaMIROd0ETZu0
	gFtaC0BonwcaOARmHEdxoRKgFUIvZ1w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CYju+vRK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776976490; a=rsa-sha256;
	cv=none;
	b=OAgeOY0e5oP5vRFxOHF/lfR8SWsACKBXJJ08nvQsLA3kTutA+UzJmjoMvrP/fK1ijTtLGk
	nOmDAg/a7b+LsVwkQiWsp3sV7l66oyc7RvlS/s0LuoBXavGJr3RyFuLI7GYLtT7reXJqzM
	aWHU4rs35RvrxI00cyKLEK2HaSupxg4=
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7dbcb467f2bso6567030a34.3
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776976489; x=1777581289; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/Sc+ZsDjiZEjytSKxuIVGQ3PUb0Eu41iRMSui9hW2VQ=;
        b=CYju+vRKfcNTJf4R86MqMydXU5PhZTo/U+wJDN6WdNVqO9XyQrR2G+oGclXgtQ5wTG
         7xBrLyO8jFNGSdIi7L6/TC5Z3IzEZzf901mmFHsG2oV+gQ88c2eQjKEWiiFKoI0Gcsg1
         6wZAsAIdlS54ce7cPMeVuISNVZEPyUeFDRpVdmMR2sg1Twuoe3wuzg0sNAR84KrRkIIz
         3zNhVvbJbsNiFFEbvRiW8E3MFh+YbWyE3CE9fvnoNTYUzzvvMCjfrImMCocHjwl7YVW6
         8ITTEMrYUh9S1uruoQV5p/scekaQhS8k8MnOGNdrel8rm6dBFDIZoLm0kBBrtyC6/1lZ
         qfhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776976489; x=1777581289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/Sc+ZsDjiZEjytSKxuIVGQ3PUb0Eu41iRMSui9hW2VQ=;
        b=QsOSrp0pvkZP5ErvnrVeA9V8vd5xuuDoCM0FZr8JqlKsk1izfe2dTLX2eVO1mIzL07
         0irjWDk0TSc1R+WTs26bv5wq7mNcvQj/FqKqlgyLvr+eXGfFb/C2ykggPmj85mB99zwq
         g+hOduPsY7/KFp6VaaEw7IKLqepdyT7x+b263s7D5Neu6WVz2Jk7cA2uT/UstDOT5OFE
         PQj1tV7tUphX59+aT81waAEtK2roIL6oVRSigyW4Rlxw1GMVrAySZDCCj3/7qiO7PPHq
         zNZUe4zlWaKfXhBW1/kJqb6t1xAd4Qj8JrVDwrYhNbp51JCYHxY2CJkkTotgOOzK/pkL
         WTNw==
X-Gm-Message-State: AOJu0Yz6VOLPeFmxi2yppgL7JWitFqxZOTcoJjJitQNASMP/RUNoYVF/
	4nuEPRZDuxQDRSVsGGZpo1UcOPQdvl+vfaxbJY7V9FpQ4g5xVQMyqqjENaSB1w==
X-Gm-Gg: AeBDietH1KFZPt3pB5oXSV+5pko8pY7Mm1dSRZV10NjxRrY6T8Xf6kIoJENzl/n8o7g
	6JoAwQz60ryCBA5x59lAVHihJlIuIYqOZigtajhnqeo4LdAAsGGBzgMaNzsRWlYVTJUgnNtjV6d
	HUiPEe0fKHdnfxYOUBrrvh1tYu1KF2D8sjol95rLMUltNbwyPzJkon4HPfwbEmW7H+QYZOwSBRu
	LBjPdVpe+yA+BjWyiQ2VfLi3wT7UCpinOcYQn7Su/3WeI87chKhbU5F+7649VEX44aBMyruEF3l
	sLoAa/EFRx4eZ/WDf23QvEx8nFSzppcD6Rx4Wc6FyvFmkmXCWKiKNeYIcDGi+1hMBHyxqo9JD8Z
	KDMDWessI+/7dJQ8Nq/Lvq1XYyzc7t6eOIKKjRl75B2aRhlhqR2YTImuHkT7pv89En3ESn3X1i4
	r/BE7+ho3vMqtyrrweXd6gL4kw7PEpGEI=
X-Received: by 2002:a05:6830:6a91:b0:7d9:d2b6:1568 with SMTP id 46e09a7af769-7dc9518bb34mr18578777a34.17.1776976489633;
        Thu, 23 Apr 2026 13:34:49 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc975034e7sm17408211a34.6.2026.04.23.13.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 13:34:49 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH 2/9 v2] mm/memory-tiers: Introduce toptier utility functions
Date: Thu, 23 Apr 2026 13:34:36 -0700
Message-ID: <20260423203445.2914963-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
References: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E168FC000D
X-Stat-Signature: zwuwt4je76449j1ojd57uwnzfrccqeir
X-HE-Tag: 1776976490-487481
X-HE-Meta: U2FsdGVkX18egGySRENK5oEgmcbLuIV9DyrYpjafaqdO1Vbom5OHKLK9ukHY+PrBv/SwjdybTJLkkoKl0nyFjiMxM9rGfKU7W+C/+UnTS8vUZ9DMeomLOybUdo84/sRhP9SpwtxIaO27OQUhGjwESt06ihc6h1O0MFlnEwlmi7f5lXTmgiU6I/jcq8iXhyaj57Csi08Md1kcYVwYvdjeaLXXb5qfsl3eJCDxoS2gGsxPx47wHsrbFAtpUVBQFYIQPwRbvmcuET3ggK8zMGGq/EpLLKuTXAAskcl19vzvZV2LbhlcGPmfCcGQIJ3BDv4F09TbzC5WOdV7tEGpVFhJBbMQhoY/70cwBhincaQR/JDgmmV/kf6FNVFMy4Q1OsNw3+DM9YDYwaO8oY+igRmhSSrjrAeZ9IYbWa9AHMLyIJxr1SyvAzhSulNcbo/NRP15s1zOZlABgv7EDZsx5+l3mPMkQIoV246PwyrDPX/nvfKIaeByLu909oyToQZRwmYNNsEB4SYMFFDOiASRNCuuOD7sNiDzcsoAK5Vq4LFqOq01LDZpVZMCRjjOb/HCIscJRek7i1gDspwuYQd5vADm16bU3asxY+4gFBuXUfBeQfmR56OyLIcWAH8RgpyzC6MtvJKetUsSq6Qch3CgVGJfsU6gVN3JAdMJkx1pgR3MRYHKAJvPEBC4LFHflWs+uYYAhF0uf+2p2UzBAXpEvVL/DlZcV/9Ew9/2713VbDffbNlcgz7G7OAAbeT/RNZ093ykc21dhDw+B7vjyvUHDQTo3sMuCtPqWU0zqG/5UcdNfSj3FGCCJmELXziYAxRwIn3q2G7qTUM2uKK75I+z3s3pLp74NdQ7mYOKiL7b7eKZ8Nt/aCQinV/9odkFYEgiUzR+fw+FsS2B4ei3bw2mMNrpCvSYFOlYMJahe6mgzQJ2zSOdbeWTAJ9j9jl0LywiKm5IeyxaST1cYtXn2Gp8BpW
 lVObmbTN
 YKtSsqIzwm8KvlR6qvF4+mBwp+xf8ZckNof2mD/gjMzcbmEo/WSBOKg3xInpMGpgriAVcYnTaFV30a+gW7JjYkKjp1Fi8iIFjb+r3LpKphbOXsqnQ15b73vHWDDKefI+IYuij9WU3G7+ZLhPa2aH6g2fj8j1fEdUYEvz6fkIrE1odQix4uA1vJKvTi79vzqFs6ClHsa7hlvlwHclgsFsOEabQeh2hBl9I95pkmqeL91radQzXKCYgj7t+JIh6zbR4++N8fw23QYSbxyBhgBgH7sZUxQT/7uvuYIpHCtHV6Zu2+hEX5Lt49yQVN8JVnaQUQ365v4dJeYjQFXiaguEWSjUTT/F1DweNPTanmpOos9raQ9TYB9qRTrrmfhT0opG8U7wDOZYySKVd/b8Cx3mhyU/QTnkRPQ0hdAEz6+QL+18s86EF1W9rYtkqZsdqqmNLqiBjgF/K13xrUV0nvt531QyCkq4E9CuSsruJDZNWrX7FmEWs5VoW5tcx2E+heWP4m0T/RWc71LTL1+iaHSyu60dpBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch introduces two toptier-related utility functions,
get_toptier_nodemask() and mt_scale_by_toptier().

Tier aware limits will introduce new memcg thresholds on toptier nodes
for systems with multiple memory tiers. To simplify the calculation
for these new thresholds, introduce a function mt_scale_by_toptier
to scale memory limits by the ratio of toptier capacity and total
capacity available on the system.

For single-node / single-tier systems, the scaling operation will be a
no-op since capacity updates are hooked into establish_demotion_targets.

Note that the ratio is static for the entire system. Explicitly, it does
not take cgroups' cpuset.mems into consideration, meaning even cgroups
limited to toptier nodes only will still get a scaled down toptier
limit.

This is to ensure that all cgroups are limited to their fair share of
toptier memory, regardless of what nodes they are restricted to. This
also has the added benefit of preventing accidental /unintentional
overcommitting of toptier memory, since every cgroup shares the same
toptier ratio.

get_toptier_nodemask() extends the existing node_is_toptier check to
return a nodemask of all N_MEMORY nodes living on toptier.
For !CONFIG_NUMA_MIGRATION or !CONFIG_NUMA systems, it will just return
all N_MEMORY nodes.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memory-tiers.h | 17 ++++++++++++++++
 mm/memory-tiers.c            | 38 ++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 7999c58629eeb..f21525c50a5ff 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -52,10 +52,12 @@ int mt_perf_to_adistance(struct access_coordinate *perf, int *adist);
 struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 						  struct list_head *memory_types);
 void mt_put_memory_types(struct list_head *memory_types);
+unsigned long mt_scale_by_toptier(unsigned long val);
 #ifdef CONFIG_NUMA_MIGRATION
 int next_demotion_node(int node, const nodemask_t *allowed_mask);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
 bool node_is_toptier(int node);
+void get_toptier_nodemask(nodemask_t *mask);
 #else
 static inline int next_demotion_node(int node, const nodemask_t *allowed_mask)
 {
@@ -71,6 +73,11 @@ static inline bool node_is_toptier(int node)
 {
 	return true;
 }
+
+static inline void get_toptier_nodemask(nodemask_t *mask)
+{
+	*mask = node_states[N_MEMORY];
+}
 #endif
 
 #else
@@ -116,6 +123,11 @@ static inline bool node_is_toptier(int node)
 	return true;
 }
 
+static inline void get_toptier_nodemask(nodemask_t *mask)
+{
+	*mask = node_states[N_MEMORY];
+}
+
 static inline int register_mt_adistance_algorithm(struct notifier_block *nb)
 {
 	return 0;
@@ -151,5 +163,10 @@ static inline struct memory_dev_type *mt_find_alloc_memory_type(int adist,
 static inline void mt_put_memory_types(struct list_head *memory_types)
 {
 }
+
+static inline unsigned long mt_scale_by_toptier(unsigned long val)
+{
+	return val;
+}
 #endif	/* CONFIG_NUMA */
 #endif  /* _LINUX_MEMORY_TIERS_H */
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 54851d8a195b0..acc02679e312d 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -46,6 +46,8 @@ static struct node_memory_type_map node_memory_types[MAX_NUMNODES];
 struct memory_dev_type *default_dram_type;
 nodemask_t default_dram_nodes __initdata = NODE_MASK_NONE;
 
+static unsigned long toptier_capacity;
+
 static const struct bus_type memory_tier_subsys = {
 	.name = "memory_tiering",
 	.dev_name = "memory_tier",
@@ -299,6 +301,17 @@ bool node_is_toptier(int node)
 	return toptier;
 }
 
+void get_toptier_nodemask(nodemask_t *mask)
+{
+	int node;
+
+	nodes_clear(*mask);
+	for_each_node_state(node, N_MEMORY) {
+		if (node_is_toptier(node))
+			node_set(node, *mask);
+	}
+}
+
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets)
 {
 	struct memory_tier *memtier;
@@ -428,6 +441,7 @@ static void establish_demotion_targets(void)
 	struct demotion_nodes *nd;
 	int target = NUMA_NO_NODE, node;
 	int distance, best_distance;
+	int i;
 	nodemask_t tier_nodes, lower_tier;
 
 	lockdep_assert_held_once(&memory_tier_lock);
@@ -496,6 +510,19 @@ static void establish_demotion_targets(void)
 			break;
 		}
 	}
+
+	toptier_capacity = 0;
+	for_each_node_state(node, N_MEMORY) {
+		if (!node_is_toptier(node))
+			continue;
+
+		for (i = 0; i < MAX_NR_ZONES; i++) {
+			struct zone *z = &NODE_DATA(node)->node_zones[i];
+
+			toptier_capacity += zone_managed_pages(z);
+		}
+	}
+
 	/*
 	 * Now build the lower_tier mask for each node collecting node mask from
 	 * all memory tier below it. This allows us to fallback demotion page
@@ -878,6 +905,16 @@ int mt_calc_adistance(int node, int *adist)
 }
 EXPORT_SYMBOL_GPL(mt_calc_adistance);
 
+unsigned long mt_scale_by_toptier(unsigned long val)
+{
+	unsigned long total_capacity = totalram_pages();
+
+	if (!total_capacity)
+		return 0;
+
+	return mult_frac(val, toptier_capacity, total_capacity);
+}
+
 static int __meminit memtier_hotplug_callback(struct notifier_block *self,
 					      unsigned long action, void *_arg)
 {
@@ -932,6 +969,7 @@ static int __init memory_tier_init(void)
 		  node_states[N_CPU]);
 
 	hotplug_node_notifier(memtier_hotplug_callback, MEMTIER_HOTPLUG_PRI);
+	toptier_capacity = totalram_pages();
 	return 0;
 }
 subsys_initcall(memory_tier_init);
-- 
2.52.0


