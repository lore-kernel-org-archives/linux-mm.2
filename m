Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60600EC1103
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 16:01:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EBCF6B0095; Mon, 23 Feb 2026 11:01:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BCD36B0096; Mon, 23 Feb 2026 11:01:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC15F6B0098; Mon, 23 Feb 2026 11:01:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CFCAE6B0095
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:01:55 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70F3BB6FE2
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:01:54 +0000 (UTC)
X-FDA: 84476187348.11.3CBF4DE
Received: from mail-qk1-f196.google.com (mail-qk1-f196.google.com [209.85.222.196])
	by imf21.hostedemail.com (Postfix) with ESMTP id B64411C0018
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 16:01:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VYvxJk7g;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.196 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771862512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OE3e/mRY2hQ14eIolnufoTqQ/7nanRq+a9D/btXLD44=;
	b=vHPhVjPLt7ErQCoMb+NSsf4nPnlQYBNTEbiJGft/VmvLAZvZjE+0IZxTBRZPYHX/nhmvth
	076YN/lxp+AjF6A8e7WUuVxB19HS+pCPoVjw3n6Rkkjrl0BXNomYDAca+YocEzExrIp8zh
	6jIdjBYCFP7X30lbEhtEkhlwUSGA1jE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VYvxJk7g;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.196 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771862512; a=rsa-sha256;
	cv=none;
	b=kfqeSAW7AMaMVaDY32hLjnTJHHiB8m3k63eJ/DrrLjKw2+LrmpboEkUs0AXQmtjgOD3cIc
	1OkKkWfwhHFK5UfqH2DjIDUGSCe3h2XGQG6qrn1FPNlLXpzYRd1UkNSTsqK+ZvAf7Tm1Uh
	RL/sIuGzJz+WH5JLKObcW5EBXrcKH6Q=
Received: by mail-qk1-f196.google.com with SMTP id af79cd13be357-8cb3fd71badso424548885a.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 08:01:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1771862512; x=1772467312; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OE3e/mRY2hQ14eIolnufoTqQ/7nanRq+a9D/btXLD44=;
        b=VYvxJk7gsjF1/rUIWOJeNuJEH0QYlIS+SWUlGqyi1PXlMQvZRpFssEZrxn0YQ2OraU
         DRUafcPoo5sW+m0nAq15P0g92nAdZJ9mDm2CVDPpM9hVtjYvmRTiEIXGDXIOMOPlS3Kh
         NaUuWMe9cRofQgtPDYsKnwK8b+c7AGqnbMgzlD19+fCyikmNqq4m446nnFwM/ywHASu9
         uJM9+gbUk5rvswSGx2mEeZ2a/oglqmQqjDi7BRgm1hQgg3aBgdJZEkG9jZutf3uGQtcr
         AeSZaXHq9oROJKONwv48k1u2lSY6JRp8MWIuHs6JGpxUGSniuZL5/z/MUbc0xePSK0pP
         c4eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771862512; x=1772467312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OE3e/mRY2hQ14eIolnufoTqQ/7nanRq+a9D/btXLD44=;
        b=mpf06vg3YaFCcq3TQ4q9j91bG8CWhHbRXZiymP3V9YvN6JMs6q2AEU6QHYvstylwLK
         AaWSUsYRGePJYRp6t4E3KFUJ1swhGbwLqPknDOdxg32z2liQ5+9DYmXiXITwfvpNeej2
         WEXPlrS+G2QAjuQJ3C7FU62S1rjr70DlQhV/HYSGR84bq5PoZipBfWd9uFJSPN+1C6H+
         kERJ8f+NxO4WTdsKXQPUFL8wvikefzN3PpSf/K6Pr4IhcamkZDvNX2B8KOMPpdOkytsF
         3vlRF93ZaaQf/f33gYXjDT6g83VkptNasyZktU7vpSWSaRJEkjRRpnC2cVgBJBk9//JX
         2Gqw==
X-Forwarded-Encrypted: i=1; AJvYcCUkSkhrNuQ7FA2NwS5TZxpsPFRIZKdbaHMmWOvy9IZG2NeWhEeeSzTPW0X6p3i5JR4JiauGTVC9vw==@kvack.org
X-Gm-Message-State: AOJu0YzDZVCIPnl4WhhtDXUPxj55748zf7U0bylGbpHhzdQVa4s2y6OE
	IetXQg2LbecElIBfsQT8etn+EIYqWiIGhmKAFwLdZTalL58ZbZNxJCjY1wGG9hOKQkg=
X-Gm-Gg: AZuq6aJ53Efw2nZgI3v4gXaLlZ31t24+JLx12WzwVnH1mY/saBAH9jTwfiYdXpfTTWs
	BnwOQHxxvdFcLcOtJwEn9B7NLzdbSiB0XM4+0wg8WuO9wf4vE1fqMzVNBMSAbrMjO06p70RBpCg
	4htdHNcitz0myrq5wgs+B73up/lGWymFaJH9nZUU+SHKXAhcJ3nHUz8vAmUtNfrmqv647S7v8Q7
	uGpx87ZaNJuPKI5T4imXs5P9cTMdZ5o9nsWM7d5gxayQx5hj+621hATsIouK0zr4b2zc/yjXXWU
	WIZn9SRyxDJNMg0u5e2PInHqICF9Qv7TndD+kmhJjFK6PN4JT+alDzOITT/f6WyvEcOxYH88TGt
	95aWyKzu/LBrWAcZvEVU737onWPlc9UsX6Kz+r9yC73JobD7XXdl702m6kNETx1ob0Xtl3oXaWY
	zlRgRFwErubsOMs2j55ubqnA==
X-Received: by 2002:a05:622a:14:b0:502:9a98:34b6 with SMTP id d75a77b69052e-5070bbde388mr116096171cf.19.1771862508740;
        Mon, 23 Feb 2026 08:01:48 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d6c9de8sm70140001cf.26.2026.02.23.08.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 08:01:47 -0800 (PST)
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
Subject: [PATCH v2 1/2] mm: vmalloc: streamline vmalloc memory accounting
Date: Mon, 23 Feb 2026 11:01:06 -0500
Message-ID: <20260223160147.3792777-1-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uc6y6b1ao6s36hjgd59c3xzsa6faq8eo
X-Rspam-User: 
X-Rspamd-Queue-Id: B64411C0018
X-Rspamd-Server: rspam01
X-HE-Tag: 1771862512-98097
X-HE-Meta: U2FsdGVkX19l3Iv+er7wrAUPYSr1i0mwGKoq2/fIucyS8P9RmNNxnXbPl5lsLs1uGRBUy2LH6JAogqqfWvbuL/BltXwBO/FXmzj1OzPdp5vC6+iOqC+QkdBRbQShY/w3LJPyPy7naTtdQI1QU/TamMiQ3yz9KnEE2QztLEaanSsTJDKuFsy3a8nvJWBUEB6mCMbAE7HidCeAkDPugvDEPTG03T0ExqlWzrrwv4A9iLouwZBMRUH33V9fMOIqi89f6iyRgAWJ8zxzpjzx+6iGuoOQZ6jX2ErsJs2nHLzh5ees7F9H8m2cKSJkfc7YyN6Pj8CaEZH6naCOlLkGadjCG361Fj3bBUtrTn6LLmqxvuYrTw0lFZWQ/HSpZTI3J/pu7AqMmiVu8MgmajBFuynateNwPpAc59nCY8JFMTjIzj/6w9FMn/rAwyBqPUUDGJNv5w2lCLJQcHY8zEbgh1/Tyt0cFrMjXJkTYPePVt2ZD20r2Udas6E5Dr30dB2TDAU+pT5ehcoIhrfaqrYl6pQ1gr25LO+EdgK1MQA46J9F+sHi7ib9bqjikBB5jnfFCQ+GWMINwL3Ib+cCdkQxaBDe4XWsvxIPpySK5Kny+7cNVSknZBHqgYlB7jOqo0G4aA1Us+dJ2QoY9Dm5ZFVQJoTF8GSwVuwEv/2vcWHvV9VDLp/cBRjFjAsekWTUuq0Dfvci7LlY5uHGjJ0neFS1CnlqAF6VjBat3abAyAu6KYQn8NVn6Q3OtzjmCm4Iai0cjHIQkCHanqqnWWb38eYgXDVE5lvtohDr/XuBFi5zqH6fxbTtFtFHD9Kyls2BICXRHCV2kii/hCjVqAODpRoNxoV10scWdUIgSODWgwxaKyRd8aCUrSe4WadrqMVQKQ0ZmbPy1AFPnLbgSsqhX/D+IYbFnJVCe7PjVj5JyvjXzg5VZuZOzPCBM7jLDBJnHqizLCIHDBBAXZkIWC/7olkH94/
 20pzP28X
 AJp4xDbnSfIkIrZjhco7aA3UC3ebZBFre6s9e6PDPBeHFA2+MbQbTRnDlKQLpkkeeYaNcmEEFgtWv3ziWJhZW4EbG5ra6elI/gxM0htGuQbh9zFt+455Ku6zLVC3uebKLV2UxEkqDJX9f8p+mtef8Zrkd44Fa35eQMbYnPJ6N0tlDUMs=
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

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 fs/proc/meminfo.c       |  3 ++-
 include/linux/mmzone.h  |  1 +
 include/linux/vmalloc.h |  3 ---
 mm/vmalloc.c            | 19 ++++++++++---------
 mm/vmstat.c             |  1 +
 5 files changed, 14 insertions(+), 13 deletions(-)

V2:
- Fix mod_node_page_state() pgdat argument (Shakeel)

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
index e286c2d2068c..a5fc7795aafd 100644
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
 
+		mod_node_page_state(page_pgdat(page), NR_VMALLOC, 1 << large_order);
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
 
+		mod_node_page_state(page_pgdat(page), NR_VMALLOC, 1 << order);
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


