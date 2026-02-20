Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D52D8C5AD4E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 19:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FEF46B008A; Fri, 20 Feb 2026 14:10:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 395C36B008C; Fri, 20 Feb 2026 14:10:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299496B0092; Fri, 20 Feb 2026 14:10:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 16F9C6B008A
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 14:10:40 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9DD61602E4
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:10:39 +0000 (UTC)
X-FDA: 84465776598.21.F484FB2
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id BD0334000A
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 19:10:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=W9QWlrJe;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771614638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OWO7RKWgQr+7ICFBB9SCVBLs7NDhlsurdO9niRwwF2Q=;
	b=ho4a34euIFs/q+FWSz9lWLTQk6fQS7ZV9xd45e1sR7vwBjF+w1nVAtN8mD8ap1Q/uZSxrn
	ia6TsIiALLAVwfDK69v7DKXbGLcL+YV8Cq1/vtnAZbSjWY6ZywVBIjc3Yn8Vz14zx9GAI9
	NLAiMAnQhxKbP+uIaBQEBwZSIOcqrnA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=W9QWlrJe;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.173 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771614638; a=rsa-sha256;
	cv=none;
	b=EJ7nYn3I4cJmraInoECJKpEiCKg05i5AguNTfColcyK7gUxSpscqNZwcZos3EQNFjzaZPD
	4Cj3GiifoJzZma46s3Pd+BUm+C7ifWoz5pA2xVNFTYfVgSEGufLT/1t5sLsTAOZT4rHgVx
	CJuBGBwLJQjA+x4neI8G3dbarXm01ug=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8cb5c9ba82bso368032085a.2
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1771614637; x=1772219437; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OWO7RKWgQr+7ICFBB9SCVBLs7NDhlsurdO9niRwwF2Q=;
        b=W9QWlrJetvvnkVJScyAVyBLYJbMYh9lceJTz7YeT5eN0WLsi7ANV6//z2LEghOwW5g
         dEVoSK2jW0vLJm7MCFIZziRU4diCTPhAgl9x6Rm3deLThZ4SpzVY6NC/6RyQkjVOG7II
         iuJm9WWrzaoYozGHbMmXIZvJuxaeRLnExn1WNi1joy5OphB/eE4MQBngIIMU7iznRJCO
         oqLci8PCaqR15zcF6iT1V1T4oidDXUIp6joIqik4BWN5p/EbWYt8YgfOM1eYIvoyamO1
         qgnEvmpGevSEeZJYDnFQL3fj9gipOmSeLVwXubHfLs9NOI36RiK1h91tv2cpIvFn9axe
         mh6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771614637; x=1772219437;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OWO7RKWgQr+7ICFBB9SCVBLs7NDhlsurdO9niRwwF2Q=;
        b=sF7k72f+hGSc6GaI/xE5jl3l7+OrkYS7m+IGedMWb68Wkkuga5WqW4UYUJS6sGRikf
         8cRkEKs2oxJcEoAFYU1p5qQmCQ3WfmOgCDfTsmLId8hNlv4XwvFBdPZ9k0gzEiJDX1WX
         C5kNfEjs5K2jNXEaifwaLqXXayIdfASDivrMWYIgqtYEILpAIp+3DvCjmkQ0ZXaEKn8p
         2nedmBaMG3PLVZ7wDQgVwoTOXSBG50iDmy0Zj9/y4tnE9aEy01Wepky4D2F26q/5LmmR
         fNYypx0GgdioH2hoxosyuyYeMCvzGr7MhxvKTOlpbALHncf5ZJoYjWCty53y51fVD5mG
         4D/w==
X-Forwarded-Encrypted: i=1; AJvYcCUJIyzOHKDJkUiJn7vWeXF9h8gpo2IUPad2JvceAzTBrxqhqRKP0S+B5GPcosdNNJkcEu5OfbTjJA==@kvack.org
X-Gm-Message-State: AOJu0YzztMM9M8hrr5rfoOYDONDVDSmYdcM/lKX1kf3p/RQH5tMFRcIK
	7av749CCYt2c1HEHGJQ5lBz76xfwcunfUMz3RLBLUJxYlmcj935R/11I6nxqRaR/4yo=
X-Gm-Gg: AZuq6aLE58GABsdRNtnVBvF4qJ1HvrBwq879eTIimCJB2Gc+yDhZDPI7lD6+paQbJsx
	/s2cQ5jSNNgrp2axIsy7WX7tu9OnV2YGACiugHWPgm+CeAwcq4pIYosV4sS3V+rQEHMBsqG4eEp
	3inCiu8JnSwdmWozCam6rSXkNUUwyWtGsIM/aXPK4LVFOZkG5r1He99glOrQLhhGk2a4RYoBwOU
	stnGvNFK06x7sZWl9YgKtJNG2pHMwSQlWZEYRlm+ifiIcntMPB2eV1+jgt9xpIaH/ddI8ZIktsx
	t8vNV8OtGfL5AG9MkeC24G5Zw2mojcIMsGp3FEUiteX2Y+nRlxVo/YPesnDTEP3S0QcQ9tIDhgZ
	9mAQP57QC7vzBlXHjsXnuppf5jImjiEOfHvdluWYDk37p9CQzy66Itau8Mi8vBPqnnya0MAB07C
	9C03HvC3C/m/8nxmQeMokFEcj6OJNlAump
X-Received: by 2002:a05:620a:d8d:b0:8c6:a5bc:8a90 with SMTP id af79cd13be357-8cb8c9e0086mr82079585a.14.1771614636634;
        Fri, 20 Feb 2026 11:10:36 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb8d0ebcd0sm22196885a.28.2026.02.20.11.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Feb 2026 11:10:36 -0800 (PST)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm: vmalloc: streamline vmalloc memory accounting
Date: Fri, 20 Feb 2026 14:10:34 -0500
Message-ID: <20260220191035.3703800-1-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BD0334000A
X-Stat-Signature: bcn9yf3nqjfehq5zmstuet47ho8anx9w
X-HE-Tag: 1771614637-863372
X-HE-Meta: U2FsdGVkX181ES0hKX5DcLyuZisUxXxr0+CWWE2vpUmzYh+LI191RGLe1kH4UKfSqpNgLuG65YPqhFvPkyqDRM54/9Iht91quNb94qEFygIgMEsvTRmAEq3TaQtrD7UuhDKCO4aPTEOQRZcUrtsTqpZO4qacAR3xCF/UQRxQiXMXLVqZlWS7L9tZ+ZlnuHJbrnUBmrTu8C8MAfIT9weKDcPzMrBLcbVL15Diwcnl/btQhCQdvxOd1x9yi6bs3yEUlaBmXHv0/xkSEoWSJUl666VlnyNJGZUshCqGNPKmVzGA9R/1txAycyIm8rpjLbFyBp22efqykKpA46SmC/5DEuQQrw7M8XKCKajX5pnrIJK0cTSY3xkQlOVQtST1zga6fzKuenNDWjLhG0kC3lDnCBm7oBM39X0OhYBgshpz/UQHHxQlUq14YreCKkkaoq0rGFizQryb8Sw3znZKhxTnSCnPf+0sVb2/nLAAYI+60+RB630rSkztNkjljKKEF/NmbfRvFyZVxLAfCHziI0uF8rnjM+SkW1wl8d3OwDwDLhTGGhWam/56OPVqLEzUBcf82xfqju+kB3T83PZn08OAMXEtuGVH2UJ/1xbXhrA329XTl/W+PdNxQLNe6G9n0elPsWxqeLzt/NmA7x4FkJ+2v+Cac3OuXNLZCzSQ2UCR0LLAdW25j0EOdIi7wYW1iG4Nb3s1R5ZOYuhY8+IK1Ym1XqMI3cIC7aVQ+lYC/12QfIHePQYB+p/PIY+l8pIRBHS3uFn5GaOhf+HVbrCefyI0J5lhdTXbzPbJrgvs7LYYXD4aAQ8UGvswBP6lL8nHEIM198Xie5vwMISUwenn14lDZ1d4dgIND5p/wlx6rAEF8TBRpP7maMQN6wV45tNt3egliERPTk9+vCUqGuSl06wypCqCbROCjEjvqYnKnbgE3h6PN5MAg74DO8BiiWArMGSdzPyAyKsLlPDxn65h5oo
 hwe/D2sj
 jE8YUcdyhqeHQOKOq6LalA67s8o87AEHbe8kWHyTGgkK3aPVu9tdjgFkQPud+mfdUGdoClj4ye2unEwa5dtiihHdPmxxvCZWAozaPGi0qHsMRMyZPaAkTIKVZUbWNZxtmImiKtIG5sdMHzEtTaxihNiHd8GO8exHl2fgmlZ/UZhjD0gBnvBntnUrN62MDOPAosDmtMGOTFeVgdoqtu8vedeG2p27aTjILdoOfPvK+/KT9BONqjoKievL2gGX2MvCXgrSIDyhMVe4eMXc7USdN7JXCdBVh/uNI9BmAwtuffL0dB59L9jaDo3hTh7pCgKdJsSCc4flq92XJf1s2QaKnsBDwhrEu3zASv4McSz34CDeHGl6fMQSiwiWdE74ENov920MIjHgm1yHPK+0JAykfS88FSjMZmYNvTr8TaDsQE6qlhswu3s1xMS+O6f3Kzwcz7o+9jSoPwKozE6ZVVilskaFGOGirprCnc+fhYTYWQ92q6H0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use a vmstat counter instead of a custom, open-coded atomic. This has
the added benefit of making the data available per-node, and prepares
for cleaning up the memcg accounting as well.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 fs/proc/meminfo.c       |  3 ++-
 include/linux/mmzone.h  |  1 +
 include/linux/vmalloc.h |  3 ---
 mm/vmalloc.c            | 19 ++++++++++---------
 mm/vmstat.c             |  1 +
 5 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index a458f1e112fd..549793f44726 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -126,7 +126,8 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	show_val_kb(m, "Committed_AS:   ", committed);
 	seq_printf(m, "VmallocTotal:   %8lu kB\n",
 		   (unsigned long)VMALLOC_TOTAL >> 10);
-	show_val_kb(m, "VmallocUsed:    ", vmalloc_nr_pages());
+	show_val_kb(m, "VmallocUsed:    ",
+		    global_node_page_state(NR_VMALLOC));
 	show_val_kb(m, "VmallocChunk:   ", 0ul);
 	show_val_kb(m, "Percpu:         ", pcpu_nr_pages());
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index fc5d6c88d2f0..64df797d45c6 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -220,6 +220,7 @@ enum node_stat_item {
 	NR_KERNEL_MISC_RECLAIMABLE,	/* reclaimable non-slab kernel pages */
 	NR_FOLL_PIN_ACQUIRED,	/* via: pin_user_page(), gup flag: FOLL_PIN */
 	NR_FOLL_PIN_RELEASED,	/* pages returned via unpin_user_page() */
+	NR_VMALLOC,
 	NR_KERNEL_STACK_KB,	/* measured in KiB */
 #if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
 	NR_KERNEL_SCS_KB,	/* measured in KiB */
diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index e8e94f90d686..3b02c0c6b371 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -286,8 +286,6 @@ int unregister_vmap_purge_notifier(struct notifier_block *nb);
 #ifdef CONFIG_MMU
 #define VMALLOC_TOTAL (VMALLOC_END - VMALLOC_START)
 
-unsigned long vmalloc_nr_pages(void);
-
 int vm_area_map_pages(struct vm_struct *area, unsigned long start,
 		      unsigned long end, struct page **pages);
 void vm_area_unmap_pages(struct vm_struct *area, unsigned long start,
@@ -304,7 +302,6 @@ static inline void set_vm_flush_reset_perms(void *addr)
 #else  /* !CONFIG_MMU */
 #define VMALLOC_TOTAL 0UL
 
-static inline unsigned long vmalloc_nr_pages(void) { return 0; }
 static inline void set_vm_flush_reset_perms(void *addr) {}
 #endif /* CONFIG_MMU */
 
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index e286c2d2068c..a49a46de9c4f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1063,14 +1063,8 @@ static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
 static void drain_vmap_area_work(struct work_struct *work);
 static DECLARE_WORK(drain_vmap_work, drain_vmap_area_work);
 
-static __cacheline_aligned_in_smp atomic_long_t nr_vmalloc_pages;
 static __cacheline_aligned_in_smp atomic_long_t vmap_lazy_nr;
 
-unsigned long vmalloc_nr_pages(void)
-{
-	return atomic_long_read(&nr_vmalloc_pages);
-}
-
 static struct vmap_area *__find_vmap_area(unsigned long addr, struct rb_root *root)
 {
 	struct rb_node *n = root->rb_node;
@@ -3463,11 +3457,11 @@ void vfree(const void *addr)
 		 * High-order allocs for huge vmallocs are split, so
 		 * can be freed as an array of order-0 allocations
 		 */
+		if (!(vm->flags & VM_MAP_PUT_PAGES))
+			dec_node_page_state(page, NR_VMALLOC);
 		__free_page(page);
 		cond_resched();
 	}
-	if (!(vm->flags & VM_MAP_PUT_PAGES))
-		atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
 	kvfree(vm->pages);
 	kfree(vm);
 }
@@ -3655,6 +3649,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			continue;
 		}
 
+		mod_node_page_state(page, NR_VMALLOC, 1 << large_order);
+
 		split_page(page, large_order);
 		for (i = 0; i < (1U << large_order); i++)
 			pages[nr_allocated + i] = page + i;
@@ -3675,6 +3671,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	if (!order) {
 		while (nr_allocated < nr_pages) {
 			unsigned int nr, nr_pages_request;
+			int i;
 
 			/*
 			 * A maximum allowed request is hard-coded and is 100
@@ -3698,6 +3695,9 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 							nr_pages_request,
 							pages + nr_allocated);
 
+			for (i = nr_allocated; i < nr_allocated + nr; i++)
+				inc_node_page_state(pages[i], NR_VMALLOC);
+
 			nr_allocated += nr;
 
 			/*
@@ -3722,6 +3722,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		if (unlikely(!page))
 			break;
 
+		mod_node_page_state(page, NR_VMALLOC, 1 << order);
+
 		/*
 		 * High-order allocations must be able to be treated as
 		 * independent small pages by callers (as they can with
@@ -3864,7 +3866,6 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 			vmalloc_gfp_adjust(gfp_mask, page_order), node,
 			page_order, nr_small_pages, area->pages);
 
-	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
 	/* All pages of vm should be charged to same memcg, so use first one. */
 	if (gfp_mask & __GFP_ACCOUNT && area->nr_pages)
 		mod_memcg_page_state(area->pages[0], MEMCG_VMALLOC,
diff --git a/mm/vmstat.c b/mm/vmstat.c
index d6e814c82952..bc199c7cd07b 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1270,6 +1270,7 @@ const char * const vmstat_text[] = {
 	[I(NR_KERNEL_MISC_RECLAIMABLE)]		= "nr_kernel_misc_reclaimable",
 	[I(NR_FOLL_PIN_ACQUIRED)]		= "nr_foll_pin_acquired",
 	[I(NR_FOLL_PIN_RELEASED)]		= "nr_foll_pin_released",
+	[I(NR_VMALLOC)]				= "nr_vmalloc",
 	[I(NR_KERNEL_STACK_KB)]			= "nr_kernel_stack",
 #if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
 	[I(NR_KERNEL_SCS_KB)]			= "nr_shadow_call_stack",
-- 
2.53.0


