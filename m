Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6401C5ACD3
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 16:52:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 198D46B0089; Fri, 20 Feb 2026 11:52:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 146A16B008A; Fri, 20 Feb 2026 11:52:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 086F06B008C; Fri, 20 Feb 2026 11:52:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4C2B6B0089
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:52:15 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6E40EC111D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:52:15 +0000 (UTC)
X-FDA: 84465427830.07.EEB6045
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 93A22100009
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:52:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="a97V7/sJ";
	spf=pass (imf05.hostedemail.com: domain of 3PJGYaQoKCBU7x6vA38D5319916z.x97638FI-775Gvx5.9C1@flex--mclapinski.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3PJGYaQoKCBU7x6vA38D5319916z.x97638FI-775Gvx5.9C1@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771606333; a=rsa-sha256;
	cv=none;
	b=y0K7s35L73ObNuJ4TskGKnt/yVd2DniNEIStnFWcWjufrJCrJ9OvoXLYS2jGZgV+Jzw7ps
	THpKXMBNo0nnTlQYy8I220r7UdXJPxjJJYucix08+cgCJOleEqwzCjK083yimpFQ03pWgU
	czZeU153YKlzvrVKaoTKse7j4TxkcWE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="a97V7/sJ";
	spf=pass (imf05.hostedemail.com: domain of 3PJGYaQoKCBU7x6vA38D5319916z.x97638FI-775Gvx5.9C1@flex--mclapinski.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3PJGYaQoKCBU7x6vA38D5319916z.x97638FI-775Gvx5.9C1@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771606333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/cSTzAkt5CK3RH1LCsoiWKzafA/Onxi/2uJ8AKZyka0=;
	b=lN56jpomZLh/D1sdrwQpQFa8mr0JDIwm/S6/HdJCJVoGq1JeOD7X6tIFaF0+qAq9lUSq8I
	AD1yp8DF+QyUMdGhkA5/Aek0lCmisyRyOYb4a/64j8NzVA/V3EMunK7twf5psHfs2RajZ+
	7otx74mF9iZUPaJ/ZZ/LxaxFipdFcfs=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4832c4621c2so25230065e9.3
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 08:52:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771606332; x=1772211132; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/cSTzAkt5CK3RH1LCsoiWKzafA/Onxi/2uJ8AKZyka0=;
        b=a97V7/sJe4Q1N5YE7lUzAbpZ0tX+MaFXDQPnOpSY6H8+ohxYbc7V4mgHCTDG8rmGLI
         kezHOnwlqvTnivcrH0/zQg4PgW4Pnh3TfVcBlpkO96VO0iipU7lSIaHhqdxAmLV5bFkn
         rluj+SFLUzIWiQ29PGws9OylFA9MsD/aqWSOU6d+YEuxQS2UTh5TI17uu6pWQWNlx0dU
         GBxJIDNr9FRMhupiGBav8i3qEFMhcDQqTi2r54h4nbAmWrdAq9byMOzap2W1VMost6Hj
         kX+Ss5mBsqbawBoPDvFz1pHRUZUxveQA92QtnY0e8CNa3SPMpsVFIiVzEp0i+evtKX1v
         6f7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771606332; x=1772211132;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/cSTzAkt5CK3RH1LCsoiWKzafA/Onxi/2uJ8AKZyka0=;
        b=qQRq+mHF38BEDjfoZYkU6E0Typ0mrjkgZdRdFI9AX2DYtdnAU6Vw/4XMr2+ljmpNRP
         jvWwZMI06tLdlA/1x67EpTFm/C6f0QXixwv1G8hQVIscdfqsfDUyho6YXccv+XZfuV+h
         J0Lr3S0tohIxMbxhz3sMRUKJyzy0Nn6Zs/kdpxn6e3fzXcL2gLBeOuhp+ljsmcY9w1bp
         fRwL0C7mdaA8YpiJtk4/ym2RRwbPKO1IwKlTfEYApUdZFuLl6M/ByGyXtmGmi3pGhqlX
         DVEUWQO1SYgjE3fzbG2zY8Rv7Sx2DJRb5suHNMpJsf8YjLZGBrck8KcBc2GSeULES4yw
         wHQA==
X-Forwarded-Encrypted: i=1; AJvYcCXSS5ObM62tBgNd8eJGY9u8Y4r2TlLlHMwiO7B87iKb1AkNWqAXeeEJyUcCGH5TQfjLjYq0JG08vA==@kvack.org
X-Gm-Message-State: AOJu0YyWVJIP0SwUjx5aXaqyQ/77uf9UbuYKBYxMDZ2klY1wDg+I8KU7
	2gdgavxnNNWSVX1GBV9rXVecg4d/1p8HSpHyNiW/7r7EJhUcLCrOAKjQy50zmFE1ZIxUY1FagNk
	0RZg6and/Ufz3lKxa6vgP+g==
X-Received: from wmhn17.prod.google.com ([2002:a05:600c:3051:b0:480:4a03:7b79])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3153:b0:480:3b4e:41b8 with SMTP id 5b1f17b1804b1-483a9603c07mr2950695e9.33.1771606332067;
 Fri, 20 Feb 2026 08:52:12 -0800 (PST)
Date: Fri, 20 Feb 2026 17:52:02 +0100
In-Reply-To: <20260220165203.3213375-1-mclapinski@google.com>
Mime-Version: 1.0
References: <20260220165203.3213375-1-mclapinski@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <20260220165203.3213375-2-mclapinski@google.com>
Subject: [PATCH v4 1/2] kho: fix deferred init of kho scratch
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 93A22100009
X-Stat-Signature: humd8a5u6tupsydb4ggafuu83t5ah1qu
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771606333-589376
X-HE-Meta: U2FsdGVkX19XpShN9WAb0kBT9MNz5+y3+OYhBx+xsUxwF7xRX04JGOtPWm1va1DRwzxWJQ3TFmIfuLtXtw0L+Ci+OJMMwc60bkwFi8d/gelNcCjYYa9O6qXYsUEPN0MHNgBTMFBa79RCNQPc8rLaOTDKRjPR/kidOPVwEd9PeROjG1NgCmlxXMz5Vep/UxMQBgbBQM0vRn2eMcIQS308oYlWCRnnOUSLv/GM5A/MzOBnYD6/F7lexWerv3W3WzsUJ8YsSpVhJOEtCkujHERyxUagdZI0PjEkweF1whc5K0LTUJwMk+Z7QbyCLjVPU1RS13Z119LoqP5qG10tF8U/8VHSWm8SgZRGdt7nD6ihjF93vm2gzzOU3DC5n9mA+fooeCbhqM8lhnVnXRON6w1ULw6De6PdtXBsfdx/u9Ov4zhq+sjWEjCXQyPWb4NIxKs5vtk0yvOn145jWdonkEgoCYOxlfulQHY/9GOKzLiqDTV/jLpOKjwWv8ixaBVgNWjqofwVBFFCfns2IOHwCxkP1lKiteuh57qSbjzbz44nzslm1sVQil7QGOp81oBe8SLU3cghxcA79olgempOLiYaqSCsmsbJUOSxy87A2dJPLqbQSej+fXMXhe1mY8y3gi0n7LtJ8KG9jG/lL/VJbZ5tUAOWNDZvuMVh3y5eAYvURBP60fcJKaeDvJOtnTSF4FzOnIKUR/VgrSS7AfNe6FdT4ZcvWrT94wR+audcZ0h4T7/XVVVKL68HwyF84yauabDQtA4RpqpVSKoRb5OGU3ZcLuOA2Hm/IuhPw8UxIS4xghjIV6OZSiq63tYjCe+hpxyJfKZqCrsgeQZz7g2Xgp3A892COvQfUXRoy6LyDlGYKxkJdVH1rjPt/BN1W32C16zD3EEI2Hadve6wXGS68uKRV38lEfE2/rVPXDFCCrVw6XRDWzpIo956Rzfzlbd8pTmxUn0aVy4Vtp8QjnCp5sm
 dt8ZC4FS
 JOLmq2Pw+OdSHyOWr4CMZFpph7sTpHQzurp4UUQWohP4P3JEIFYmyoimGboiU2drVrpAstHLWWsEvbyCwvShn7+4E4YX7feW8xzYsHDFMkWdiYbQje7mKmXoG56do2g9mJSgU1PosAre4qPGG35lXCWcI89Ey2RK1t1S9oMbT3wzNALtdtC6Y1johUgl2JM5NUHEaOJ7LseQun3Bq+wELZ8ZVglUiPpSurfP7wG4/3i0ZLJZAQTP6a1WfGgJyVRywvJH8oHw+Sj6kASZeOLh7LnYO3GJEsVuvXX8+P6G9xupjaarRFh12alQYH6EJDwA6GToWTPGgp7iyG3Bk149TTjL/KvpI0/FTau1WuAiPp3Yt1GVsk219M4lMFgLBoRz3S8B4Vf+6IxZ8Xt8gbnpDw0DobuChFtsspGsiPqvsdDJ+/CQLayhoZ4ECojEnCqi/NQ7QxV1TeEb5vVwcjzJKK1Q88MbvWrbTaotGHnct6K1noOWDUPJn8M48AWK7PKYUhM22VPcpIRyccp043/Jrh9Ssiyrg3emFTqCHTb06YWzviIAheVkjAj0qMf0KaZQ2O8LmdchqoutKDhlru4DfnujNs/E5lUHLDMkwT+EVCpPJRaY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, mm_core_init calls kho_memory_init, which calls
kho_release_scratch.

If DEFERRED is enabled, kho_release_scratch will first initialize the
struct pages of kho scratch. This is not needed. We can just let
page_alloc_init_late init it.

Next, kho_release_scratch will mark scratch as MIGRATE_CMA. If DEFERRED
is enabled, this will be overwritten later in deferred_free_pages.

To fix this, I removed the whole kho_release_scratch.
Marking the pageblocks as MIGRATE_CMA now happens in kho_init, which
runs after deferred_free_pages.

Signed-off-by: Michal Clapinski <mclapinski@google.com>
---
 include/linux/memblock.h           |  2 --
 kernel/liveupdate/kexec_handover.c | 43 ++++++++----------------------
 mm/memblock.c                      | 22 ---------------
 3 files changed, 11 insertions(+), 56 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 221118b5a16e..35d9cf6bbf7a 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -614,11 +614,9 @@ static inline void memtest_report_meminfo(struct seq_file *m) { }
 #ifdef CONFIG_MEMBLOCK_KHO_SCRATCH
 void memblock_set_kho_scratch_only(void);
 void memblock_clear_kho_scratch_only(void);
-void memmap_init_kho_scratch_pages(void);
 #else
 static inline void memblock_set_kho_scratch_only(void) { }
 static inline void memblock_clear_kho_scratch_only(void) { }
-static inline void memmap_init_kho_scratch_pages(void) {}
 #endif
 
 #endif /* _LINUX_MEMBLOCK_H */
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index b851b09a8e99..de167bfa2c8d 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1377,11 +1377,6 @@ static __init int kho_init(void)
 	if (err)
 		goto err_free_fdt;
 
-	if (fdt) {
-		kho_in_debugfs_init(&kho_in.dbg, fdt);
-		return 0;
-	}
-
 	for (int i = 0; i < kho_scratch_cnt; i++) {
 		unsigned long base_pfn = PHYS_PFN(kho_scratch[i].addr);
 		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;
@@ -1397,8 +1392,17 @@ static __init int kho_init(void)
 		 */
 		kmemleak_ignore_phys(kho_scratch[i].addr);
 		for (pfn = base_pfn; pfn < base_pfn + count;
-		     pfn += pageblock_nr_pages)
-			init_cma_reserved_pageblock(pfn_to_page(pfn));
+		     pfn += pageblock_nr_pages) {
+			if (fdt)
+				init_cma_pageblock(pfn_to_page(pfn));
+			else
+				init_cma_reserved_pageblock(pfn_to_page(pfn));
+		}
+	}
+
+	if (fdt) {
+		kho_in_debugfs_init(&kho_in.dbg, fdt);
+		return 0;
 	}
 
 	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
@@ -1421,35 +1425,10 @@ static __init int kho_init(void)
 }
 fs_initcall(kho_init);
 
-static void __init kho_release_scratch(void)
-{
-	phys_addr_t start, end;
-	u64 i;
-
-	memmap_init_kho_scratch_pages();
-
-	/*
-	 * Mark scratch mem as CMA before we return it. That way we
-	 * ensure that no kernel allocations happen on it. That means
-	 * we can reuse it as scratch memory again later.
-	 */
-	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
-			     MEMBLOCK_KHO_SCRATCH, &start, &end, NULL) {
-		ulong start_pfn = pageblock_start_pfn(PFN_DOWN(start));
-		ulong end_pfn = pageblock_align(PFN_UP(end));
-		ulong pfn;
-
-		for (pfn = start_pfn; pfn < end_pfn; pfn += pageblock_nr_pages)
-			init_pageblock_migratetype(pfn_to_page(pfn),
-						   MIGRATE_CMA, false);
-	}
-}
-
 void __init kho_memory_init(void)
 {
 	if (kho_in.mem_map_phys) {
 		kho_scratch = phys_to_virt(kho_in.scratch_phys);
-		kho_release_scratch();
 		kho_mem_deserialize(phys_to_virt(kho_in.mem_map_phys));
 	} else {
 		kho_reserve_scratch();
diff --git a/mm/memblock.c b/mm/memblock.c
index 6cff515d82f4..3eff19124fc0 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -959,28 +959,6 @@ __init void memblock_clear_kho_scratch_only(void)
 {
 	kho_scratch_only = false;
 }
-
-__init void memmap_init_kho_scratch_pages(void)
-{
-	phys_addr_t start, end;
-	unsigned long pfn;
-	int nid;
-	u64 i;
-
-	if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
-		return;
-
-	/*
-	 * Initialize struct pages for free scratch memory.
-	 * The struct pages for reserved scratch memory will be set up in
-	 * reserve_bootmem_region()
-	 */
-	__for_each_mem_range(i, &memblock.memory, NULL, NUMA_NO_NODE,
-			     MEMBLOCK_KHO_SCRATCH, &start, &end, &nid) {
-		for (pfn = PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
-			init_deferred_page(pfn, nid);
-	}
-}
 #endif
 
 /**
-- 
2.53.0.345.g96ddfc5eaa-goog


