Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE30B1088E58
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 23:41:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E974E6B0388; Wed, 18 Mar 2026 19:41:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E476B6B038A; Wed, 18 Mar 2026 19:41:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73556B038B; Wed, 18 Mar 2026 19:41:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A74E16B0388
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:41:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5CDEE1B6FAB
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:41:33 +0000 (UTC)
X-FDA: 84560808066.15.EF2891D
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8DF60C000A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:41:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JBwC9DXS;
	spf=pass (imf10.hostedemail.com: domain of 3Kji7aQsKCNsPLRO7SM7KA7DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--souravpanda.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3Kji7aQsKCNsPLRO7SM7KA7DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773877291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAE7XM+sTZKgqzB4BrZL2AJoWNFQZI9gaPUtJ4ReKmE=;
	b=V+FwK8FLf9xN9lhzIr94vkpRFo31OC1VI0UippM5AwukfKxwkafLhOQd0JtNi2fDya6Wae
	PnFJIw/A7o2PiPsbuqSjsZQ5acDt2NDqt8kVXyvqokNzZ/d3XZZcAcHaHXcos9Tm7zniVS
	xx32rM+bBVW/MvHJY7JBd000rgi1HKM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JBwC9DXS;
	spf=pass (imf10.hostedemail.com: domain of 3Kji7aQsKCNsPLRO7SM7KA7DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--souravpanda.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3Kji7aQsKCNsPLRO7SM7KA7DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773877291; a=rsa-sha256;
	cv=none;
	b=qAZOnTt1W3ceR68pZo3HVTxb3HUJ9VpN4mmQppjnZj18fUHrsYvulGaKy01+Esn9VYHLRx
	W5DbusZ2M6YWrR3Mg3+upEJ4KUEOfTAtYlV6v+mHTf8z++8qXDyaL4BCyRU44yowX66Du7
	Ca6FR4I4nbBtajMyeiuqMTAlGOzyvv8=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b06b68783dso3675395ad.3
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773877290; x=1774482090; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZAE7XM+sTZKgqzB4BrZL2AJoWNFQZI9gaPUtJ4ReKmE=;
        b=JBwC9DXSGvic7F1m/Fc3rZe6cXdE6bVPkPOKHPLFVj2jdQMZqdPJnJ4zpdZWHZkc7Y
         +lS+ZMy3HmwT4ie0zSDr6Dno3crCCVtVnQUo7r87PLywKA679VU5E4OjKDrTlXvwobty
         52UdX7VynrNeQaAiINL04up196Fu8B79UCNHRhPTQO8HJCumkrxFXKUFMy3YyfTzWph/
         syVl4htB7p5dUYDqaauhKQ02IW88Z+EgFDn2i7MkTQT/RAxkxWNRawgVqY4LevpT/iKo
         cGZDFiVBcNleE2bCKL2L/zJuyd+G5N387pqFhpMMwFKSq+7OU+2JjjDoB+GfyySmiel1
         oQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773877290; x=1774482090;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZAE7XM+sTZKgqzB4BrZL2AJoWNFQZI9gaPUtJ4ReKmE=;
        b=qejF8aJgrBW/WkuwQiXdIHFwRhK3/UttsZFpVFgO2t1T/a2jq8g5Hd217lxFkD+nxU
         JWJDRt0PcqvHc3ojklhuWpEH8tnma46ono4zHoJBDq9wb1hk/Hymdqz5v7tXDK9aSu1F
         iSn02gAOZr2pI+T6K+g8NhZOoBi66i5fGKXj68jvI0faKpEi8ktusIjCZAlZrVWck8+4
         Q+0h3JkNaeC+ziveFuZZGDINgYI/lrdB1tNZ7yEUetVjoSHSDr4S7mFmRnBf1p8LZDaX
         zzwd7Q9GGB6om0br6MUK22B7PkNm0iJP6Ce6Rf2Qp7oto9t617Xm9gwMm15/ldasHnOs
         oyLA==
X-Forwarded-Encrypted: i=1; AJvYcCXgmRrd1gpeLJ5zlLrgvUmTIfXPHrqKRM6PpBtvzN+TD8YdzNQtl/6AZE26bYaQbgUe/l8mmPHLFg==@kvack.org
X-Gm-Message-State: AOJu0Ywg3LBeeC0ipOh248YB4sujR/wKTFRPeNUg8NVTnzuJeAll8E1i
	zuIHudTcNZerqhZSszpV+eKLM5pHFrr1W5mOUdlxJhKacadaJUKDJkqYUsnRu7jj8jRTYYM9QGp
	CxaBUoWyiHPugX+fq4BwyTZc2JQ==
X-Received: from pfay33.prod.google.com ([2002:a05:6a00:1821:b0:829:72ec:561c])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:4781:b0:39b:9644:6e98 with SMTP id adf61e73a8af0-39b99c9eb04mr4939494637.8.1773877290134;
 Wed, 18 Mar 2026 16:41:30 -0700 (PDT)
Date: Wed, 18 Mar 2026 23:41:25 +0000
In-Reply-To: <20260318234126.3216529-1-souravpanda@google.com>
Mime-Version: 1.0
References: <20260318234126.3216529-1-souravpanda@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260318234126.3216529-2-souravpanda@google.com>
Subject: [LSF/MM/BPF TOPIC][RFC PATCH 1/2] mm: add hugepage shrinker for
 frozen memory
From: Sourav Panda <souravpanda@google.com>
To: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: lsf-pc@lists.linux-foundation.org, songmuchun@bytedance.com, 
	osalvador@suse.de, mike.kravetz@oracle.com, mathieu.desnoyers@efficios.com, 
	willy@infradead.org, david@redhat.com, pasha.tatashin@soleen.com, 
	rientjes@google.com, weixugc@google.com, gthelen@google.com, 
	souravpanda@google.com, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8DF60C000A
X-Stat-Signature: hkozmtuowmfqtmw1haik53ggpsxrxfns
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773877291-160184
X-HE-Meta: U2FsdGVkX1+pHKQoA00c2QChBfTaJPPo9WEMjeWjQbwGiUjfXhv97F4CHNabSh1PM/xw9zAumXUbqcxk9VyxwkFbq6yxDkz2d11uVWIZZ9f8nUeooavpOVJo4YQekZLkPzAOeegbjkGQ4TvmSnTzw2N/KzInqNwgIa/x2ltjpRBx53LlaqpFhBemzce7S18CB4koOs6wUDBcAjTETGQ91PIf13APbcLyhqVUSLGTcPAgbn6JBLwft/LCB8Cj26Szm6o9eSaXkG0nBVfU7QM83PB3UQL9dH4c8D+9QpjANSM9Hrq7pjorIH4GQwrdtTtwJBMWjpPtFOd2BR5coCbOlxSm0lpUwhKBNuV+hn0qgxlI86m5OBQ9M4TBqCo3MwebSuJF5epi6Ibda/f9iP9/B1pG8B9z+/RQH1ujAmqgdxKDHMZMeq4ZN450/WIW34QzSUGLAjxaxQLphh8XhU7maaxowIW+u39C9oGDKBTRA33cElYNqbWdw7SIi0Qj+K4BfK/3S17+SRcEXEJjhIX3d7N0kSTN0nhiL/kFbN6W4UbNGsDBRrUfTcVEQ1syFr7CojLSGZFIxBQVtzXqTO0PdaBgmMEU/+Wx+Vvw8sAGkAraCzo/ro6thsL+oJ6n64KANXPUYqRgb02j/NN4acekPjer1czw1cJgB2Pj9LzYjJHJHQgQCCk96DBdloc7c03CyPMy6WeMKXFizJz2X55w0KiSqxvdQAHnkGJ3BFdvX2g+Ru1QQN42jFO5umwqneuF8KU0Gwlh/mlfacDTVuq8ZGcO6yk4okBEHGGhUIMrXQqvUb+vIQEAYQYmE9t3gnZC21hHHeDvYvcH2zZsTY+M0PkyKrDfGeNZ4ldutv07kMuT9SW3+Jk+WlMOPkIjJKYTYkEoKka2GfaM5jZOwLK3q1ztXf/qwUIocc2n5ogzV5BFZr4kU/bRXgw68xqTWJke6fV/4+gXo8pLPmOEFew
 y/8HnC+c
 yEYvHkFE478U3qXHI/OyD6YyqYv5WSkQbNMdB+wTvtAi7PDT3aLJR6pyoZmGMu7MToClLMF2A/Lk+01lRaRvW4UTOXEPe3bfT21xbt75JN21Vrd37UXmt2LQ3gdgQ1cwW/1BYtErkyyZ8ihrq03Lb7EDlUlo0mksDchChKSDUvFuKOnqG8hNxW7jAoggAwTy4xgf+QhI0RAB2yXoWzDET/tClfnF329YF6rKGyrN5pXAL58Yc2FNVVH8KkTI13+plB52djDJBc5nyxTv2MmdUG6dGXJwrcQtF59b0FBgqz8WstEt8l4n5QnAe2IdhmGu7/FiY5lALoM7q4j0cbfIR+iPf47mjSueVuklyahTl52t0+NGG2jgGg6TwcdSAgoSAmJaNLBP7E7YAS2w/r6WOpENZAHGlSFCF6WSizKV1Q0NzhDu1gTcvSiWYOlY73O8rm25IxW15TvCOmDLUqI5N5d2fLUwB1CaysV8OEZKZWe4M9BaQYSqm+Ma+w5/biiIxrdy6pccEw5oHWSmwLpEEoVlI8DA5gnMOZhZTTEESkaf0OJaGBdoK6CsG0++Zr24fqheUhwWTGD7H7ZMq38KMcS2KUjphWNCB2JeX3hUDUcgEfl8v47OjB37ztFqafsK8qGJA/UGgASN6WTVtarNuKULcwthSQkZA9K772tJ3s1PC3EbkrYAidKESakieCNgeHuEkzD4R0ijXzgY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a shrinker for the hugetlbfs subsystem to provide one-way
fungibility, converting unused persistent huge pages back to the
buddy system. One Huge page at a time.

This is designed for virtualization user cases, where
a large pool of huge pages is reserved but kept free, acting as a
"frozen" memory reservoir. When the host experiences memory pressure,
this shrinker thaws the memory by reclaiming huge pages on-demand.

Pass the hugetlb_shrinker_enabled=1 kernel command line param to enable.
Please note the nr_huge_pages will change without user intervention.

Both kswapd and direct reclaim can shrink gigantic hugepages when
the system is under memory pressure.  To safely support concurrent
reclaimers (e.g., kswapd and multiple direct reclaim tasks), a new
mutex `hugepage_shrink_mutex` is introduced.

Signed-off-by: Sourav Panda <souravpanda@google.com>
---
 include/linux/shrinker.h |   2 +
 mm/Kconfig               |   9 +++
 mm/hugetlb.c             | 125 +++++++++++++++++++++++++++++++++++++++
 mm/shrinker.c            |   2 +
 4 files changed, 138 insertions(+)

diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 1a00be90d93a..5374c251ee9e 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -51,6 +51,8 @@ struct shrink_control {
 	 */
 	unsigned long nr_scanned;
 
+	s8 priority;
+
 	/* current memcg being shrunk (for memcg aware shrinkers) */
 	struct mem_cgroup *memcg;
 };
diff --git a/mm/Kconfig b/mm/Kconfig
index ebd8ea353687..a88f370c7485 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -769,6 +769,15 @@ config NOMMU_INITIAL_TRIM_EXCESS
 config ARCH_WANT_GENERAL_HUGETLB
 	bool
 
+config HUGETLB_FROZEN_MEMORY_SHRINKER
+	bool "HugeTLB Frozen Memory Shrinker"
+	depends on HUGETLBFS
+	help
+	  Enables a shrinker for the hugetlb subsystem that allows
+	  unused huge pages to be released back to the buddy
+	  system under memory pressure. One huge page at a time.
+	  Further gated by kernel cmdline hugetlb_shrinker_enabled.
+
 config ARCH_WANTS_THP_SWAP
 	def_bool n
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 327eaa4074d3..d4953ff1dda1 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -27,6 +27,7 @@
 #include <linux/string_helpers.h>
 #include <linux/swap.h>
 #include <linux/leafops.h>
+#include <linux/shrinker.h>
 #include <linux/jhash.h>
 #include <linux/numa.h>
 #include <linux/llist.h>
@@ -4127,6 +4128,129 @@ ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
 	return err ? err : len;
 }
 
+#ifdef CONFIG_HUGETLB_FROZEN_MEMORY_SHRINKER
+
+static bool hugetlb_shrinker_enabled;
+static int __init cmdline_parse_hugetlb_shrinker_enabled(char *p)
+{
+	return kstrtobool(p, &hugetlb_shrinker_enabled);
+}
+early_param("hugetlb_shrinker_enabled", cmdline_parse_hugetlb_shrinker_enabled);
+
+static unsigned long hugepage_shrinker_count(struct shrinker *s,
+					     struct shrink_control *sc)
+{
+	struct hstate *h;
+
+	if (sc->priority >= DEF_PRIORITY - 6)
+		return 0;
+
+	if (!gigantic_page_runtime_supported())
+		return 0;
+
+	for_each_hstate(h) {
+		if (hstate_is_gigantic(h) && h->nr_huge_pages_node[sc->nid] > 0)
+			return SWAP_CLUSTER_MAX;
+	}
+	return 0;
+}
+
+static bool hugepage_shrinker_is_watermark_ok(int nid)
+{
+	int i;
+	pg_data_t *pgdat = NODE_DATA(nid);
+
+	for (i = 0; i < MAX_NR_ZONES; i++) {
+		unsigned long mark;
+		unsigned long free_pages;
+		struct zone *zone = pgdat->node_zones + i;
+
+		if (!managed_zone(zone))
+			continue;
+
+		mark = high_wmark_pages(zone);
+		free_pages = zone_page_state(zone, NR_FREE_PAGES);
+		if (__zone_watermark_ok(zone, MAX_PAGE_ORDER, mark,
+					MAX_NR_ZONES, 0, free_pages))
+			return true;
+	}
+	return false;
+}
+
+static DEFINE_MUTEX(hugepage_shrink_mutex);
+
+static unsigned long hugepage_shrinker_scan(struct shrinker *s,
+					    struct shrink_control *sc)
+{
+	int err;
+	struct hstate *h;
+	unsigned long old_nr;
+	nodemask_t nodes_allowed;
+
+	if (sc->priority >= DEF_PRIORITY - 6)
+		return SHRINK_STOP;
+
+	if (sc->nr_to_scan == 0)
+		return SHRINK_STOP;
+
+	if (!gigantic_page_runtime_supported())
+		return SHRINK_STOP;
+
+	if (hugepage_shrinker_is_watermark_ok(sc->nid))
+		return SHRINK_STOP;
+
+	mutex_lock(&hugepage_shrink_mutex);
+
+	if (hugepage_shrinker_is_watermark_ok(sc->nid))
+		goto unlock;
+
+	init_nodemask_of_node(&nodes_allowed, sc->nid);
+
+	for_each_hstate(h) {
+		if (!hstate_is_gigantic(h))
+			continue;
+
+		old_nr = h->nr_huge_pages_node[sc->nid];
+		if (!old_nr)
+			continue;
+
+		err = set_max_huge_pages(h, old_nr - 1, sc->nid, &nodes_allowed);
+		if (!err)
+			goto unlock;
+	}
+unlock:
+	mutex_unlock(&hugepage_shrink_mutex);
+	return SHRINK_STOP;
+}
+
+static struct shrinker *hugepage_shrinker;
+
+static int __init hugetlb_shrinker_init(void)
+{
+	if (!hugetlb_shrinker_enabled)
+		return 0;
+
+	hugepage_shrinker = shrinker_alloc(0, "hugetlbfs");
+	if (!hugepage_shrinker)
+		return -ENOMEM;
+
+	hugepage_shrinker->count_objects = hugepage_shrinker_count;
+	hugepage_shrinker->scan_objects = hugepage_shrinker_scan;
+	hugepage_shrinker->seeks = 0;
+	hugepage_shrinker->batch = 1;
+
+	pr_info("Registering hugetlbfs shrinker\n");
+	shrinker_register(hugepage_shrinker);
+
+	return 0;
+}
+#else
+static int __init hugetlb_shrinker_init(void)
+{
+	return 0;
+}
+#endif
+
 static int __init hugetlb_init(void)
 {
 	int i;
@@ -4183,6 +4307,7 @@ static int __init hugetlb_init(void)
 	hugetlb_sysfs_init();
 	hugetlb_cgroup_file_init();
 	hugetlb_sysctl_init();
+	hugetlb_shrinker_init();
 
 #ifdef CONFIG_SMP
 	num_fault_mutexes = roundup_pow_of_two(8 * num_possible_cpus());
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 7b61fc0ee78f..8a7a05182465 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -529,6 +529,7 @@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
 				.gfp_mask = gfp_mask,
 				.nid = nid,
 				.memcg = memcg,
+				.priority = priority,
 			};
 			struct shrinker *shrinker;
 			int shrinker_id = calc_shrinker_id(index, offset);
@@ -654,6 +655,7 @@ unsigned long shrink_slab(gfp_t gfp_mask, int nid, struct mem_cgroup *memcg,
 			.gfp_mask = gfp_mask,
 			.nid = nid,
 			.memcg = memcg,
+			.priority = priority,
 		};
 
 		if (!shrinker_try_get(shrinker))
-- 
2.53.0.983.g0bb29b3bc5-goog


