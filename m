Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C37EEC5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:49:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A14396B0092; Tue, 25 Aug 2026 04:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3B36B009E; Tue, 25 Aug 2026 04:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8559A6B009F; Tue, 25 Aug 2026 04:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B0A76B0092
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:49:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1F9FC0384
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:15 +0000 (UTC)
X-FDA: 85139167470.21.73D7BBD
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id D326A140008
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:49:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SYDguvsp;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787647754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XZrs8X2fjGywiu1ctnjB1m4+W6a3lmWBg96SgWKBRZo=;
	b=i900u+AfBUjtaTqZul78Mb+ZB+lUb1mJUDiy5SH7TBzYrl8ERB/byy1IAUzh7Y+6bqRRGI
	oeLrxovwU0OPty7mkslEm+T+O7zM6nGfyWJg5Xx3lAjuCoFulfslrJjvUzn8nnj8d0ev/4
	QYWEJ9CvRnWsQgqkqJEV/8Fd/3XqZmg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SYDguvsp;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787647754;
	b=0q/YqctH86wL5arwG1DiA7+BiNi7WOQi2E9OvTYeGnvZ5NlnFDCt42llqUK3hX4CUu2P1Q
	Wjyns+9DFTaqC9L2HPvnSUDuLwW6L77t9rLNcEl38V8yeVWwhDYmP0KOQyX2Wv/1q7Z72L
	XIs6QCFi0v1FxYWKuViXXHd9Qx25uu0=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-39647aa9d52so659333a91.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 01:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787647753; x=1788252553; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XZrs8X2fjGywiu1ctnjB1m4+W6a3lmWBg96SgWKBRZo=;
        b=SYDguvspnMESUsXWOW7J7QUEP87m2tnpGKWjSNnzJUyHtQ9FZilCb1fLTe16VkDQ2+
         nxTXkHd+iBUB187bLbaswid01lFEHxnyueg1ZVuD8VwcatkyJfeoUzWImflAE5nlP13N
         RkuIP5wJw5N6fFJnCfajXei6dQsYNGcZ6fiz2sO1tkdoY6SlMh9VEAV1sx8V8DSogWcK
         DyWKLIOko13IoVoQaF0i++eohSw/dqoBFF1o46a65DLm+ba/r8ZWyWr/w7dKc4K1FAfj
         bu2YOI5vgAuEYEVgPM8Yq68OMV/PImLr0b3k4u/lqXU7QKFh+RT/ODCHC+JetTvMDsOO
         VoQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787647753; x=1788252553;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XZrs8X2fjGywiu1ctnjB1m4+W6a3lmWBg96SgWKBRZo=;
        b=RedmJe/0Fg9hEkEfvlbFToShqrl4hKc2MPjFS7G+fX5mPzhBZIMCN9iKfumiBfAVb1
         H58ga8wcgY63p5Jc8U0VOK7FJUDhAKkBgVqlBYskCD7okt3F66DRqUl5WAOP+6wnaTY5
         AEKtslWtN69ovpUuA8/Pgr0QNUZX9YeHB9YiN/bHJdymuJy0D1RSuoIvvb9ug5NddO9p
         gXxUz5qOANL8zs+nCAgaDJfySN8qI4V0ygC4rc374i8xH5MvNhZNdcSrm4m3lHqmsmRz
         ge5aV4iXe2w6xgGsYsdcuwLHzbTGhGhPaYzsV0LcC8i5SL+P4dJfXU0fXADBfXl48C43
         SVQg==
X-Forwarded-Encrypted: i=1; AHgh+RoLNeiybfEdCABogg5PoLmM5y4zIBh6OZaDNdoFIdP6Ut3o6DIvMIUEfZGKHqrKLMtbhnAGkiB32Q==@kvack.org
X-Gm-Message-State: AFuF++meb/5l/L7OOzxLTWXHkg8nilkSMRyIGcG1I+Op+33U9dfNv1zW
	JPzICP5+jFc5rEO7UwH69PpWV0wR1HkttQ9TKFkM0G/tN1ypSaALG3EsSPO1DF44dNk=
X-Gm-Gg: AR+sD11/gz99/qeETjOyNugPsorjGmzqIkAwlg/IrTRtqVhi2rFEBp6lrb/aFPgYdzl
	QrY4HuekpQASLDNemfHhcJe59J0nujB/z/gljDsREXoMnFGyDVkKg5FkRcXPs/VMBsihXJ7sQCR
	vB1rZIxE1ITKyWBnzoAL6oLOeXwGD6l9tFdfWCdYWNzigZzgMhGCkDipcmFwQwDrdvoQGlOFL8U
	6ld0ZWuiRhVFtuiUbCJsx2F+bAP/tGY3QP6K89DVMPke8q3zLs1HSAUgAdL5Z6KhXvlNn5vEfco
	oEmzA4IEw1rNiWUAwtATgFYKzcex9eOpDjsd8JLNAGZAd4auaadbPzvhDFZ2sXLngycjGwtoJ0w
	6tITNlXAZBo3SUfn+T2qU+4L34L8KGBcOmQTIL2nqVpBFC6Z+sj48Q9oW68QmTAyunoIT8k5+Jm
	mZ3lDhlaNFVN0Qgq4duAGmSJWuzjkXmyG+02rRq9rRqQdRLyeNDXQnqxUdHXzrLOcynU15YY8Wy
	0gDrzKTroaBc6S7J60uBuHP8A==
X-Received: by 2002:a17:90b:2b48:b0:38e:7297:a92e with SMTP id 98e67ed59e1d1-39645b5b2e7mr5586208a91.9.1787647752583;
        Tue, 25 Aug 2026 01:49:12 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm2873386a91.17.2026.08.25.01.49.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 25 Aug 2026 01:49:12 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v5 03/17] mm/mm_init: skip initializing shared vmemmap tail pages
Date: Tue, 25 Aug 2026 16:45:54 +0800
Message-ID: <20260825084608.47437-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260825084608.47437-1-songmuchun@bytedance.com>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D326A140008
X-Stat-Signature: 43r8ymduqhs8jk7qrfnzqmeksdk3qfp9
X-Rspam-User: 
X-HE-Tag: 1787647753-145246
X-HE-Meta: U2FsdGVkX19V1tslte5ScmFncczaoSXGgNxXhCD+ghNqkAwvuodxnRiS4arGyHDHr3hWa9z7gP2gPMammDVAvI1NG0/XqnBmq+46en75JkAuHm3j4chPw1nIN+thEH7Gs3xLkMiNQOTZZAWYh7WQFiBaaSiFHRKMr9hZfCnlKjEjlgqKQ2xGIoDupRvl6jFz1FJsL6ji9RqL4coNOc4wKW3yQTXuik0TPzgqsB2piaAazw2hlbx5c0ieVOgslVTzvLH+B30d/huV2mtSpAo+fVF9zNuaqahQgTmePnepvXZ4ZlxaFKQfL9qRv2d1NriCjIA4/Cj/NzhUGQS9VN4YwWKt/b/pfDsCNMza2xNYIeDX3fTXRnWN16v6bkxjsSxKMA/T9Jl/9jEOM1r4XLmy8WS3SEXtWKyEBHot2WugNmL6PZb9GGOlWm5Noy+I7HdNH+6ld8Wfu+QVCR8xqbbopfmcANizKMJ22nt7ScwSUVCnP4s2pA0w4Sbkh0loH44hqUMnU+WWDYHk9GRpo0sb3jm82Sz7z559KUkQlDmUHB4Feej0VLLhzdTMfg02OGA+w4LEKW8LXoslizwq1+7w/6isX6HVUf1X6/iXJ6iM4jTODhlhxWFS1spk+JukJbp7DIbdFY8w2x2yZ4uCdFYCycYAYAXvKcJYNHNQYl7ArHFZbKSNuJ0B381/tl+gwRFZdUnToMPcmQxSoWU2UHjM0OW+tX/V8AS2kwrqKsQDDhxte+0BK60CVQL7PiX221rKydRkqEICIKdYaaADlr3MGSQIS0gPYWXjZ3frwZDzoQwoQUtKFUf8QYpxVwoXWsIsQgEpgIHwO9sjUNHuicmSu8xbtvdG4dpL4eeLABc03KMXxBMADznmOqqJeztKoYYLrWtvOb0mTJn6zEUGdqjbQr6IbiM3IM4wNyVEnlidyVADrtFPzke19aHT36xf/3YGlljz2OXPKvSkHD0aZs5
 OiRMCa/o
 +ZFh7F2F0YetfQbh54PsfCiHUtO8U/kaEYf6h1cRVdkdKbsiord4LHHXUYwA5F26l1BZ49CuGwxyc/YuZCejnTOZNbtYCmndNUfclup8Ey3eXyk9MBDxscZXOeT7i3YS9iZKHXQ8fa6a7QN44XLVyNs7FmdubeDqGasXPXxEO0j4KJihhmVDOfUxV74cSgzNfDGJgnpVwhDYOlklRafxxOzESN4XRSQNA8TJcoGjK5nsU2HsCWXFF5SVmvQsrs0CCO7jy5yrWA4Xl0/s8SG43/KfhhYgyOS6p8wf3xVWkO69XfZqWpjYkVxT92GTFeEPkaNVQfxTno0KZD5CZ8BGXBjhDwUjdw4aC0tHC51CE/GX3LtUn9ywv/ntICHc0fRbjP7bLu2twx1m1/4CRns0zTcgMcpd3ErrjRdXm5tOftGoEzeg+bCWCC+KKSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_range() initializes every struct page in the target range.
For compound pages with vmemmap optimization, the tail struct pages are
backed by a shared vmemmap page.

Initializing those tail struct pages would overwrite the shared
vmemmap page contents, requiring users such as HugeTLB to restore the
metadata afterwards.

Track the compound order for HVO-backed sections and use that metadata
to detect struct pages that fall into the shared tail vmemmap range.
Skip those shared tail pages in memmap_init_range(), then initialize
pageblock migratetypes for the processed range with a helper after the
per-page initialization loop.

Keep direct mem_section access inside sparse helpers by exposing
pfn_to_section_order() to users that only need the order associated with
a PFN. This lets memmap_init_range() skip shared tail vmemmap pages
without exposing __pfn_to_section() to !SPARSEMEM builds.

This is a preparatory change for consolidating handling across users of
vmemmap optimization, and it also avoids redundant initialization of
shared tail vmemmap pages during early boot. That early-boot benefit
appears only once HugeTLB is switched to this common handling, since
HugeTLB is the early-boot user that creates those shared tail vmemmap
pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v5:
- Add comments for pageblock migratetype helper callers and shared
  tail vmemmap skipping (suggested by Mike Rapoport)

v4:
- Rename pfn_vmemmap_optimizable() to vmemmap_optimizable_pfn()
  for consistency with vmemmap_optimizable_order()

v3:
- Replace the !SPARSEMEM __pfn_to_section() stub with
  pfn_to_section_order() (suggested by Mike Rapoport)

v2:
- Fold section order tracking into the first user instead of keeping a
  standalone API-only patch (suggested by Mike Rapoport)
- Rename page_vmemmap_optimizable() to pfn_vmemmap_optimizable() and
  pass a PFN directly (suggested by Mike Rapoport)
- Initialize pageblock migratetypes from a helper after the per-page
  loop (suggested by Mike Rapoport)
- Use a 1G PFN chunk for cond_resched() in the pageblock helper
  (suggested by Mike Rapoport)
- Guard section_order() with CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP so
  it returns 0 when HVO is disabled and lets the compiler optimize the
  code as much as possible (suggested by Mike Rapoport)
- Explain why the !SPARSEMEM __pfn_to_section() stub belongs here
  (suggested by Mike Rapoport)
---
 include/linux/mmzone.h |  8 ++++++++
 mm/mm_init.c           | 40 +++++++++++++++++++++++-----------------
 mm/sparse.h            | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 17 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 5fb9b37819d5..df31cac12311 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2022,6 +2022,14 @@ struct mem_section {
 	unsigned long section_mem_map;
 
 	struct mem_section_usage *usage;
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+	/*
+	 * Normally, sections hold regular (order-0) pages. However, for
+	 * sections with HVO enabled, this tracks the compound page order
+	 * to enable deduplication of redundant vmemmap pages.
+	 */
+	unsigned int order;
+#endif
 #ifdef CONFIG_PAGE_EXTENSION
 	/*
 	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1533aebafb68..f801fd486085 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -29,6 +29,7 @@
 #include <linux/cma.h>
 #include <linux/crash_dump.h>
 #include <linux/execmem.h>
+#include <linux/sizes.h>
 #include <linux/vmstat.h>
 #include <linux/kexec_handover.h>
 #include <linux/hugetlb.h>
@@ -677,21 +678,19 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
-#if defined(CONFIG_ZONE_DEVICE) || defined(CONFIG_DEFERRED_STRUCT_PAGE_INIT)
 static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
-		unsigned long nr_pages, int migratetype, bool atomic)
+		unsigned long nr_pages, int migratetype, bool isolate, bool atomic)
 {
 	const unsigned long end = pfn + nr_pages;
 
 	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
 		enum migratetype mt = kho_scratch_migratetype(pfn, migratetype);
 
-		init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
-		if (!atomic && IS_ALIGNED(pfn, PAGES_PER_SECTION))
+		init_pageblock_migratetype(pfn_to_page(pfn), mt, isolate);
+		if (!atomic && IS_ALIGNED(pfn, PFN_DOWN(SZ_1G)))
 			cond_resched();
 	}
 }
-#endif
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static inline void pgdat_set_deferred_range(pg_data_t *pgdat)
@@ -886,6 +885,17 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 			}
 		}
 
+		/*
+		 * Vmemmap-optimizable PFNs are backed by shared tail struct pages,
+		 * which have already been initialized during vmemmap population.
+		 */
+		if (vmemmap_optimizable_pfn(pfn)) {
+			unsigned int order = pfn_to_section_order(pfn);
+
+			pfn = min(ALIGN(pfn, 1UL << order), end_pfn);
+			continue;
+		}
+
 		page = pfn_to_page(pfn);
 		__init_single_page(page, pfn, zone, nid);
 		if (context == MEMINIT_HOTPLUG) {
@@ -897,19 +907,13 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
 				__SetPageOffline(page);
 		}
 
-		/*
-		 * Usually, we want to mark the pageblock MIGRATE_MOVABLE,
-		 * such that unmovable allocations won't be scattered all
-		 * over the place during system boot.
-		 */
-		if (pageblock_aligned(pfn)) {
-			enum migratetype mt = kho_scratch_migratetype(pfn, migratetype);
-
-			init_pageblock_migratetype(page, mt, isolate_pageblock);
+		if (pageblock_aligned(pfn))
 			cond_resched();
-		}
 		pfn++;
 	}
+
+	pageblock_migratetype_init_range(start_pfn, pfn - start_pfn, migratetype,
+					 isolate_pageblock, /* atomic */ false);
 }
 
 static void __init memmap_init_zone_range(struct zone *zone,
@@ -1112,7 +1116,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				     compound_nr_pages(pfn, altmap, pgmap));
 	}
 
-	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE, false);
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE,
+					 /* isolate */ false, /* atomic */ false);
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
@@ -1921,7 +1926,8 @@ static void __init deferred_free_pages(unsigned long pfn,
 	if (!nr_pages)
 		return;
 
-	pageblock_migratetype_init_range(pfn, nr_pages, MIGRATE_MOVABLE, true);
+	pageblock_migratetype_init_range(pfn, nr_pages, MIGRATE_MOVABLE,
+					 /* isolate */ false, /* atomic */ true);
 
 	page = pfn_to_page(pfn);
 
diff --git a/mm/sparse.h b/mm/sparse.h
index 3b744667a7e6..1fcda8a1c270 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -10,6 +10,39 @@
 
 #include <linux/mmzone.h>
 
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+static inline unsigned int section_order(const struct mem_section *section)
+{
+	return section->order;
+}
+
+static inline unsigned int pfn_to_section_order(unsigned long pfn)
+{
+	return section_order(__pfn_to_section(pfn));
+}
+#else
+static inline unsigned int section_order(const struct mem_section *section)
+{
+	return 0;
+}
+
+static inline unsigned int pfn_to_section_order(unsigned long pfn)
+{
+	return 0;
+}
+#endif
+
+static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
+{
+	const unsigned int order = pfn_to_section_order(pfn);
+	const unsigned long nr_pages = 1UL << order;
+
+	if (!is_power_of_2(sizeof(struct page)))
+		return false;
+
+	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
+}
+
 /*
  * mm/sparse.c
  */
-- 
2.54.0


