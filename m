Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A274FDEE49
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 20:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8D606B0092; Thu, 23 Apr 2026 16:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEFC26B0095; Thu, 23 Apr 2026 16:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E17F6B0096; Thu, 23 Apr 2026 16:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CEB86B0092
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:34:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1BF0A1404E8
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:34:56 +0000 (UTC)
X-FDA: 84690974592.02.2BA93CA
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4AAD91C000E
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 20:34:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OQtOYAB9;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776976494;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k8h4sSDHY9wW/Z7IHaPKSopnSuqP+potJrVY6PtuZz8=;
	b=hxa32ubbO0XTMexOtFbwvhSgfiyjgXMCIcqY6ROKbLSC3CO1Lk5/4vr6TbtkTSjxx0+Ud3
	ujui4LRfdW5enBAWTLdONuQdYdHPKuv6Jpnr2E6BHvnfzIKDm9E3NiXsvNScHNIeda3iTR
	SQLts6zZiJukWRubqXmhMEEaTBb/0kI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776976494; a=rsa-sha256;
	cv=none;
	b=qz+yy610o0XPlpbck1GeGE/qtXrDnU4XYwlgKs9lQVzUz+SoOu7tkO4sIVsgHqPgbo20LS
	tWjGKWGfNpIR/oeBSbJgPj8LCVn6a7XFt8pV4DTSjCUHvJOVQ7lLC3srTtVtgCd3JY9X0T
	nBo0o0NMRN7ovFq3LAVDPP2KMgyW/uM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OQtOYAB9;
	spf=pass (imf18.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-409de4132b5so4575363fac.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 13:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776976493; x=1777581293; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k8h4sSDHY9wW/Z7IHaPKSopnSuqP+potJrVY6PtuZz8=;
        b=OQtOYAB91HqsOljoCQlcsM7QRsdZKtsufnq3NR1x62pfJa8qfwy62QXvY9z05QFHKj
         i4mD4HcAYu2J8brMLz4qdxlUy/YohFei3adYq0y0AIR+/yTiYrLvQxDo6JI+F04n4u7n
         ig/ouw8kww538n11x2xO+TOfChWZ6dbA9iT5UUvnuyoCjNggtmjWiIA6S2EApZBL6eH2
         ZMlXqhA3SqpIyJdz4tG0x1W3Ravpw+FNrromtcorQn9/QTXtefg1Dv2BmmJh+E+Wwj5a
         mhtUMSaB5fLkiVlPippoAoRyxUuNkpLm/BmZKmuDzKYc7a0BlX/6d6UvWObMO8Ef3Y8R
         lzNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776976493; x=1777581293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k8h4sSDHY9wW/Z7IHaPKSopnSuqP+potJrVY6PtuZz8=;
        b=fDmDX0QMfuG/AfEOA8IrJhM5sMrDupMld14bi5dModnsaiWalDEQIx51FHQuFEERhk
         ZcRDGqLGt8SQ362tShQsPlhyd90rqrhRIb1qW29nZD6tQRrGHYCU8SwLMRLfuSSgLK4N
         XfkPMsnAEqmdh5Sji8yc+6vYDlf5+cDqV+ewcNy1PmLvFaJH36BzScolhS0TcQQC6HBJ
         w4k7OGf/U5WFsbkZBqzA5XsIXitLES9lqLDZQuoEnRIjXezxWw+CoNf7rfm8hXjFp6XK
         UoaZQLDJn47HrF9VI9TPxWq3RaREcwPDLB/hljddcstmH7YgvFvW42HvO4/U917G+gft
         uJTA==
X-Gm-Message-State: AOJu0Ywmy15pxl2r6wwDb9BcbkW4C7pXFWm38uIbAaUYq0E60Yhem3q4
	CaVvHdB0kT5hvtYq/P8iakfE6mZFzZQkuAH/HxqujEA49fF8bmybkmOuoA+SpQ==
X-Gm-Gg: AeBDieuwybpUDetqejLzVYI/m3TjbNd9bOSoOuIMthH9slOEmvavxlRTe+lLc7erfOu
	cDWiyw11CHA3Fzjk+QOO7dwPbBtkCPPEO08/rKalWrl3VbFgChAdqNHoM112B+ZU7z8jXmLrphl
	O5TAUTZ1/QSTlcv4hDYS/NMuZbMpXx/tcvMw6KsBV9+H8SR+4mmShHr6BlNpQV9n9OwvaTz/w8i
	T9niHm0KAX303VjV0Rl9s29EBhIqUlY8KJHKlx0BVUsYj6aIAk6uaWw66xu6Arx9k5F8khxRbrt
	2uBq4qfsalpt0HEes++OAb/HEuXBuMXMCd9lLJUZgdftv55ZhhXctUDXVW2XbjO4JdotW0RgB6v
	HySDSW6rroTSKx47HtXT3lZpf4Kg2NES9+tN0qPKUZGzHWfAbL+QrHfOJcQIN81WuxRG+J11/E2
	cjA1gV2WSwbuEvh8BQopx0aM7e13AGh0Nc
X-Received: by 2002:a05:6870:89aa:b0:42f:c146:da68 with SMTP id 586e51a60fabf-42fc146e30amr6196515fac.16.1776976492846;
        Thu, 23 Apr 2026 13:34:52 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:71::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42fbe8a0bcbsm6038078fac.2.2026.04.23.13.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 13:34:52 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [RFC PATCH 4/9 v2] mm/memcontrol: charge/uncharge toptier memory to mem_cgroup
Date: Thu, 23 Apr 2026 13:34:38 -0700
Message-ID: <20260423203445.2914963-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
References: <20260423203445.2914963-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: prm1nrwd6d4cuui5hsadj9dft7oit4c8
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AAD91C000E
X-Rspamd-Server: rspam05
X-HE-Tag: 1776976494-311603
X-HE-Meta: U2FsdGVkX19sdW43zENu9zc5/RPIZ+gCYGDx/uk0M/5XuhAlfRBO4hWvaohipU6JMEGeDThDIS/uPcmfL8pORlIAFo5stq6l1Qzcv5Iw92KDc3QH+1tCckNCBEezFuoJY6q4bfahrWuDeINT5ngK16I5FzU7xh/dOfSgqKly7uoeM4xtA5N+ECJEeeRuhvizAcnbB2yyGP/Aqr+nsGhTIhgWCOvRw/Va5atvErzMQCeCpzOTd5WHv0v/BuXcVbOOeBEYeEdPIPyyUT6F328hFlKMrDwIKbqfXD6d2sG04WlfUvQBZ6ftrMBcv2vM31hO+17cBMsY2HQm7P+6uvoWto49rGVpNus6D9csRYz7pr4V+2La2iQeZSlE14j6NIq3lmZemYooUjgFrMMQRbAovp/LnLJH7/lGXEAorzKr/pDrheg+G8E6Rue9uUKqs2n+I9UL9UAOtLuuwtqdnzetvprT01y2wJ+XL9Gblm66dCYOeMzOm8cdxhkE2wQU6t+dMJ30BCNoDiajj/hVm3tPOEI2RrHzJrXvbM34RbmOahNSYLaCOJXRs8KfLUxPv21x1C1NS+CuxAT31zEeC59wGXwIo3Ox3zOn6DF1VgGOC/4KkOHcdzoxGK9bfNXEL7Df/ybCugs5MzYqut+2QiP+oRg9yqWRzJQYwz+23UlFDoD4YQhz0VPMk58bFL4zVM2Qwv/nbZJQVpLFsPmAmgk3S3FyLASF/gZmlCbLLHThULra0epzmEiBYq2QQOyZVpDbqItUzfSuzFHldKcxkYehFQHwQEj5XjsO+3JLhajM8VGkQWWDvSvIAlBcbkrZKe+a54+pLQFxjhkHaEK8b4zDN29+HSkpZPQSQV0Z1Itc4c5eH7qs+Sudy4feP0DqdRPClK6b3c2s0XsJNnQe9A0tfSrApTb0Z6x6VebvXSYsUil5AzBNWQC2y8xFTYO+ZTM6tSw1eezxGDLkhtG9AKQ
 cB44xuR2
 sfP+KG7MtQ51ZKQQ77HGwPC7Fn6c7TDvbuU/mVV8wYq8BGjz1oIqGpEpvdfT8+Qxv1s8DtGq2XgcVjduOfRTKp8oZvYwEQ+tOasPiifdtQp0Nm46CGuqJUlo+WRefE68wMvsPeUXkHcg8D9PXPdORd3CCmex7WVo9iuH1H/oY+adahK2WyhOMyz2fmoMANqsU+VGKy238GPegjSUJd0nryN1jlpo5xkioemj10pX5dCC2VzY0t7ugvAQMBj6fJXPKIFpKQVuR1ZyUu+kFU2IYGFmgSp0kCNEuH3OKey5KE2ic8+915iz9V1QW6Dtg1LNXzplJftVHdU1J/7GyTUh26R7YDga5pAQ775aN9WI2H8RABBjpJfvDBLpyRhnib8kFz+RZsYiNtA63MUT/CSGANjBcdtOWtcKpC3REmRDX2qIOxrDz8w4FRHsvYgBXLn3cCeMuFnXYMsCbFkFtdFYTi54Y3BOR+dLDkLSEWlm0z4uN4Rf1/7Wi18YHW32+YDkbJ5sz9QhOIwY5EmLrWPXqfZdNwK5c5X8iM66yJ1D06MfG0Vg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory cgroup limits currently offer a way to isolate memory as a
resource, but treats the cost/value of all memory to be equal,
regardless of whether it is present in a toptier node or not.

To better capture the asymmetric utility of toptier memory from
"lowtier" memory, account toptier memory usage in parallel to existing
memory accounting mechanisms. To do this, introduce a new page_counter
"toptier" to mem_cgroup.

From a simplified perspective, we can achieve this by checking the
physical location of folios when the memory page_counter is updated, and
decide whether to also account to toptier. Add a new "toptier" parameter
to try_charge_memcg(), which callers must determine.

However, as of this RFC, this simplified model only works on LRU folios
(callers of try_charge_memcg() from charge_memcg()). The other two
sites, obj_cgroup_charge_pages() and mem_cgroup_sk_charge(), will be
addressed in future patches that transition enum memcg_stat_item to
a per-lruvec counter (enum memcg_stat_item).

Enforcement mechanisms are not present at this point. Failing the
toptier limit check leads to nothing, but the charges are accumulated.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 63 ++++++++++++++++++++++++++++++++++----
 2 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index be45641e890e4..0cdb6cd1955dc 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -206,6 +206,7 @@ struct mem_cgroup {
 
 	/* Accounted resources */
 	struct page_counter memory;		/* Both v1 & v2 */
+	struct page_counter toptier;		/* v2 only */
 
 	union {
 		struct page_counter swap;	/* v2 only */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8f7bedb55dbb1..d891cf77cf6d6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -53,6 +53,7 @@
 #include <linux/seq_file.h>
 #include <linux/vmpressure.h>
 #include <linux/memremap.h>
+#include <linux/memory-tiers.h>
 #include <linux/mm_inline.h>
 #include <linux/swap_cgroup.h>
 #include <linux/cpu.h>
@@ -2096,6 +2097,7 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 
 	for_each_mem_cgroup(memcg) {
 		page_counter_drain_cpu(&memcg->memory, cpu);
+		page_counter_drain_cpu(&memcg->toptier, cpu);
 		page_counter_drain_cpu(&memcg->memsw, cpu);
 	}
 
@@ -2370,7 +2372,7 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 }
 
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
-			    unsigned int nr_pages)
+			    unsigned int nr_pages, bool toptier)
 {
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
@@ -2382,9 +2384,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	bool toptier_charged;
 
 retry:
 	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
+	toptier_charged = false;
 
 	if (do_memsw_account() &&
 	    !page_counter_try_charge(&memcg->memsw, nr_pages, &counter)) {
@@ -2393,11 +2397,18 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto reclaim;
 	}
 
+	if (toptier &&
+	    page_counter_try_charge(&memcg->toptier, nr_pages, &counter))
+		toptier_charged = true;
+
 	if (page_counter_try_charge(&memcg->memory, nr_pages, &counter))
 		goto done_restock;
 
+	if (toptier_charged)
+		page_counter_uncharge(&memcg->toptier, nr_pages);
 	if (do_memsw_account())
 		page_counter_uncharge(&memcg->memsw, nr_pages);
+
 	mem_over_limit = mem_cgroup_from_counter(counter, memory);
 
 reclaim:
@@ -2490,6 +2501,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * being freed very soon.  Allow memory usage go over the limit
 	 * temporarily by force charging it.
 	 */
+	if (toptier)
+		page_counter_charge(&memcg->toptier, nr_pages);
 	page_counter_charge(&memcg->memory, nr_pages);
 	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
@@ -2559,7 +2572,7 @@ static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (mem_cgroup_is_root(memcg))
 		return 0;
 
-	return try_charge_memcg(memcg, gfp_mask, nr_pages);
+	return try_charge_memcg(memcg, gfp_mask, nr_pages, false);
 }
 
 static void commit_charge(struct folio *folio, struct obj_cgroup *objcg)
@@ -2859,7 +2872,7 @@ static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
 
-	ret = try_charge_memcg(memcg, gfp, nr_pages);
+	ret = try_charge_memcg(memcg, gfp, nr_pages, false);
 	if (ret)
 		goto out;
 
@@ -2888,6 +2901,11 @@ static void page_set_objcg(struct page *page, const struct obj_cgroup *objcg)
 	page->memcg_data = (unsigned long)objcg | MEMCG_DATA_KMEM;
 }
 
+static bool should_charge_toptier(struct folio *folio)
+{
+	return mem_cgroup_tiered_limits() && node_is_toptier(folio_nid(folio));
+}
+
 /**
  * __memcg_kmem_charge_page: charge a kmem page to the current memory cgroup
  * @page: page to charge
@@ -3760,6 +3778,7 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 static void mem_cgroup_free(struct mem_cgroup *memcg)
 {
 	page_counter_free_stock(&memcg->memory);
+	page_counter_free_stock(&memcg->toptier);
 	page_counter_free_stock(&memcg->memsw);
 	lru_gen_exit_memcg(memcg);
 	memcg_wb_domain_exit(memcg);
@@ -3866,6 +3885,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
 
 		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
+		page_counter_init(&memcg->toptier, &parent->toptier, memcg_on_dfl);
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
 		memcg->memory.track_failcnt = !memcg_on_dfl;
@@ -3877,6 +3897,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		init_memcg_stats();
 		init_memcg_events();
 		page_counter_init(&memcg->memory, NULL, true);
+		page_counter_init(&memcg->toptier, NULL, true);
 		page_counter_init(&memcg->swap, NULL, false);
 #ifdef CONFIG_MEMCG_V1
 		page_counter_init(&memcg->kmem, NULL, false);
@@ -3936,6 +3957,7 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 
 	/* failure is nonfatal, charges fall back to direct hierarchy */
 	page_counter_enable_stock(&memcg->memory, MEMCG_CHARGE_BATCH);
+	page_counter_enable_stock(&memcg->toptier, MEMCG_CHARGE_BATCH);
 	if (do_memsw_account())
 		page_counter_enable_stock(&memcg->memsw, MEMCG_CHARGE_BATCH);
 
@@ -4013,6 +4035,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
 
 	drain_all_stock(memcg);
 	page_counter_disable_stock(&memcg->memory);
+	page_counter_disable_stock(&memcg->toptier);
 	page_counter_disable_stock(&memcg->memsw);
 
 	mem_cgroup_private_id_put(memcg, 1);
@@ -4825,7 +4848,8 @@ static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
 	objcg = get_obj_cgroup_from_memcg(memcg);
 	/* Do not account at the root objcg level. */
 	if (!obj_cgroup_is_root(objcg))
-		ret = try_charge_memcg(memcg, gfp, folio_nr_pages(folio));
+		ret = try_charge_memcg(memcg, gfp, folio_nr_pages(folio),
+				       should_charge_toptier(folio));
 	if (ret) {
 		obj_cgroup_put(objcg);
 		return ret;
@@ -4922,6 +4946,7 @@ struct uncharge_gather {
 	unsigned long nr_memory;
 	unsigned long pgpgout;
 	unsigned long nr_kmem;
+	unsigned long nr_toptier;
 	int nid;
 };
 
@@ -4942,6 +4967,8 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 			mod_memcg_state(memcg, MEMCG_KMEM, -ug->nr_kmem);
 			memcg1_account_kmem(memcg, -ug->nr_kmem);
 		}
+		if (ug->nr_toptier)
+			page_counter_uncharge(&memcg->toptier, ug->nr_toptier);
 		memcg1_oom_recover(memcg);
 	}
 
@@ -4987,8 +5014,11 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
 		ug->nr_kmem += nr_pages;
 	} else {
 		/* LRU pages aren't accounted at the root level */
-		if (!obj_cgroup_is_root(objcg))
+		if (!obj_cgroup_is_root(objcg)) {
 			ug->nr_memory += nr_pages;
+			if (should_charge_toptier(folio))
+				ug->nr_toptier += nr_pages;
+		}
 		ug->pgpgout++;
 
 		WARN_ON_ONCE(folio_unqueue_deferred_split(folio));
@@ -5063,6 +5093,10 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 		page_counter_charge(&memcg->memory, nr_pages);
 		if (do_memsw_account())
 			page_counter_charge(&memcg->memsw, nr_pages);
+
+		/* old folio's toptier usage will be uncharged on free */
+		if (should_charge_toptier(new))
+			page_counter_charge(&memcg->toptier, nr_pages);
 	}
 
 	obj_cgroup_get(objcg);
@@ -5105,6 +5139,23 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 	if (!objcg)
 		return;
 
+	if (!obj_cgroup_is_root(objcg)) {
+		struct mem_cgroup *memcg;
+		unsigned long nr_pages = folio_nr_pages(old);
+		bool old_toptier, new_toptier;
+
+		rcu_read_lock();
+		memcg = obj_cgroup_memcg(objcg);
+		old_toptier = should_charge_toptier(old);
+		new_toptier = should_charge_toptier(new);
+
+		if (old_toptier && !new_toptier)
+			page_counter_uncharge(&memcg->toptier, nr_pages);
+		else if (!old_toptier && new_toptier)
+			page_counter_charge(&memcg->toptier, nr_pages);
+		rcu_read_unlock();
+	}
+
 	/* Transfer the charge and the objcg ref */
 	commit_charge(new, objcg);
 
@@ -5180,7 +5231,7 @@ bool mem_cgroup_sk_charge(const struct sock *sk, unsigned int nr_pages,
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return memcg1_charge_skmem(memcg, nr_pages, gfp_mask);
 
-	if (try_charge_memcg(memcg, gfp_mask, nr_pages) == 0) {
+	if (try_charge_memcg(memcg, gfp_mask, nr_pages, false) == 0) {
 		mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
 		return true;
 	}
-- 
2.52.0


