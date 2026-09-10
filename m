Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83BF3C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:33:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A34626B009E; Thu, 10 Sep 2026 02:33:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0C7D6B00A0; Thu, 10 Sep 2026 02:33:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F80F6B009E; Thu, 10 Sep 2026 02:33:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 663E56B009E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:33:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5E43FA48C8
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:36 +0000 (UTC)
X-FDA: 85196886432.30.1E8AD25
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4207580006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:33:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eXTcnZlY;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022014;
	b=LQ8Wqb0K1HVXx/t/fxnUun2ip1q9egLR1AU1iOULWdwuH4RgPMNyC3XGR06pllVUMfPbC+
	+1ahoxDAVu0vUoKgAJJlzMffijoGW15dTeZcEbcoHGcdZQAGIPs1L2bUxpDTRrcPgJteom
	/MJAwMnmnIMsii31CLEp4/AUzhhW5Wg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eXTcnZlY;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tUBCzuDDmijmZL9894tpqO2PeM3/ckJvguvNiHP8cxU=;
	b=R7gScGjaCoJz8fSnn4FhU3EgeL8LbBniNP5XPXQw5k94msUk2lygrhAWQhe7uqaSkhNVCE
	ADx7L956bvHtB/0YzL+OupdBS6L66U49m1RzpjnG4/b2O2lZhm9ZN+6ehQHIEgIzf5cyKN
	E9PR00jPgEWxhmVSAHZZdps+AwWD3jA=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747ed9865so8436235ad.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789022013; x=1789626813; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tUBCzuDDmijmZL9894tpqO2PeM3/ckJvguvNiHP8cxU=;
        b=eXTcnZlY3sqR22TDCqTUfvqG7BvnHtjcrrVlJGOKXKoHOyQd9wTZVs7Ly2xxtpik7f
         yf6vli9DyAOTrUZH/jV0JwYRTSoPvkOuSlBBHg1uw/baURxcGprCUI76rbQmL6kF5VzM
         incil10ApyH3LNtz0SptrJ2B4cQIfyaDtFJm1ZA/76EcZrxmj7rJMPa5HQ/s/hfgaapc
         pJF0P6DXDnX0PpVGxXywAPflK2+uSoaHgvdo5uA+4tgdPOGtzWsTzCDBUeiWSSra30fX
         s+nQK506EtZq/63H3uw3mF0JdL3G+ZBsFS4nNq8LMolwt1AsRluBk0ANQZ9iKokV18Ey
         BKxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022013; x=1789626813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tUBCzuDDmijmZL9894tpqO2PeM3/ckJvguvNiHP8cxU=;
        b=sgDPJMRsLNMBrekwCijhBJ27rhxtC2IZNRmUwRDMoMmW3gWP3CWI25EsaG9W6M1eMA
         aSprHIgdZ0f3l6rF6ezLG1AQ+ZlLsPXRFI9yKyxB5UT3b1wmklrQRsZ+ldLnkx6lKdW2
         x7sBiQXMMw5SoUH7oDmT0k+bx9CPH0U4HOt40j1IRmqLGEyfPx/jOCVKu1D5MEZsO+yi
         GtqWkAeiXoiKxxNNAxMOs9+KgyKZ013bJC+rsm2SjKQOCwa2albHt/aPaSDU/qHUx2Qt
         vJYb7+D+JsJEhcjN2wcUb3OfiUtHDGbe3kCenzqzRzer/UnqAAL9TrGBmTu7+i9pj0Q9
         p03Q==
X-Forwarded-Encrypted: i=1; AKwUvBz4TFZajyqxvRkOZ9vQsMkKVedSH3An1nbOc39EdFcr//Hau9KaXERLCEsuXUXaRCqXInN+fPblkQ==@kvack.org
X-Gm-Message-State: AFuF++mNZcFrqK7B8/IDslhoG5WCBU2OtmwHRxxyAygodUi22GKltBdz
	T1m6xOyadduACc+N890tppaYie+M6eucuwRdtjXNR3/tUvU/fZbx0qtxwOMb4YOtLa0=
X-Gm-Gg: AYBFou0lHIw1uNxmB3av6aWQtlwgWlp6wiJRBs/Wl0GSSj6wmKCsbfZk8mfy2qqncrF
	mJCh463x1UrM8hgk3gVJzs3iPUH7DiyLIzgi0jwVdk5eRzzCqI1bjlFQMBDJoFTo9VNM9OgR4et
	d+E3if7c9QWlELzRBPKsfMpPgp1V1pMHkimN0ruLeJzhF0+TAXsgPniXTZiRGecIO8M9FdhPwuM
	VXEFbzgO/XbUgkJluqrIJ5GQv1MhNjwKaTj+gaQIxs3stB3AqS63lPxrIS499kKcdN0pSIucpWY
	Ro3IKRQWVE8I+TNlsgsVKnFkrEBqY7DvasubWwxX6VTsfNkL2PfBMEFmr2lWFzhBCX5FOMfZ+Za
	RLxmmPCAmmHM5M2sj+RMFazAJQQTGiy9qzvRyg05j2oyEkOv7IBIwbVtXzqYHCHCciH1ZdYWe7s
	KAEBPBVTU5R7F4O798o5NvmPcPPEZTyfg9Z8+KX8+UdH5wRqGaBvxgrLRs6JKpu33nuf2AVMoKM
	63AWqu2VmHe44sPZtISmiMlB4p3wuTUYlc=
X-Received: by 2002:a17:90b:1e0d:b0:37f:ed7e:7e42 with SMTP id 98e67ed59e1d1-39d70ae12b0mr7306314a91.14.1789022012813;
        Wed, 09 Sep 2026 23:33:32 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d84fdbae4sm1213094a91.14.2026.09.09.23.33.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 23:33:32 -0700 (PDT)
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
Subject: [PATCH v6 03/17] mm/mm_init: skip initializing shared vmemmap tail pages
Date: Thu, 10 Sep 2026 14:32:42 +0800
Message-ID: <20260910063256.64386-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260910063256.64386-1-songmuchun@bytedance.com>
References: <20260910063256.64386-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4207580006
X-Rspam-User: 
X-Stat-Signature: pae9h3aye9i1kfbu4u7q7fgpzpmjir9p
X-HE-Tag: 1789022014-76836
X-HE-Meta: U2FsdGVkX1/L02qw6AmpbGb+j/pTtLuaTc6NAimKXYtbPJ8O7E7/N0+lbHvlbDtedAGuqgMNIOotPXHKXb2VlXUc0NL3aubS7oHH5eWnG/Zw1GZKfoCqr/F3zOEHZHO4X4oMHs/Z3MO0omnFTCdlrW/fSFqnMofD2vO0AVw005AFPKtahrNxzp4FFMvJg5LY0Il3jJ8O+NjejA4DIhtrH8k5UQBoOv89FouTFsbjSRYoQof79XCwOaMUGX8tDeg/Yol8NdH5ZS2E8hBT4zfTAuLgXMrwLFnKi6EHbwR/VkqSgaLHp6AkZYXoKdz9ncUoxngLoBovZm1/GE8qMHamQvDyACdnaFYItNuEVNoc4oN/rtiazHUsleibvsFr4TghnhdF64DDUKyE/QjtEkVDw0NMa3j/2xRFjQh2fAYdmQouWah8lcb7Z7lKdXgTgbLnL1Uc4hVYB5nBXaPb78TKwT5q+d3Cp9fhPPthvNOBiqXIO+XnATAH/7jFd6BKEnmNkCnznd0/LqZW0S9rVqLX34CmpV0H6NId0ZnsV7DdwgVbcU3QAoObr4sV6yp/vJRm1CKZqFFz0SgywfE3s1ClgjX3+MMN6osTnypTZXSYL0Sd8D4K/g1oe3bv0o4EjAiSN2Z8SJ3SotW/UJxqy0u7FSvxPtlA00EeNGsw7FnkUp+DG6+cJVfXb+FIYpqmUS6VtFvM5EcsCYooqdFRzNzwUBcw2aqt9UCOwyi1Q7zXvMTjV1bwGZC/JI0vr5jy0iFHoFB+cL5ZkeDqi59anQYpKIBZnQ+a6LepqF0DbrgcpWFaeTTeiOLVTA6IzKMDpCL1dWQLQl5bw4VxLEyNgE9gL9yFIPD6emZbj/oSR7wp4JsupWSrYeh31pBo+m4pMgmORFXBXsUa6utQCQInxwLO0F3XlDpEjqwFhgAbqnwYu/JeeOSL3GSU2zfaDzop3i2i3I0tLyKCJf9ep41PxF4
 orB/bCg7
 PZg6CxJpVSs80r4I0X7KB7TNizwAkgXpfNTcxoAg0QAbe9KziNarq3XpcJFFRSHoY4AZOEy4jh73E6dRYVpYtu/wylu9DbMIAixPvtF5slreqFaFss/7WN1ddl9/yg8xwLUblUA0CfP+vTw3D1+WLnmSthuKk9x42S0b44t0+00KpZxQlA6nEaQ/qNRIL7uZOh0R0gVa+zCYkf5SILqzEc2TJHeiV8HeZBR5+hkEqbuYHizPFIm7rTsPpbYre3MtppWLpqXEm6+h4d/9CyxIGZEVcVMaWHB0AJXYsg2E3gvWgye/DtuVMSJ2aKxhQrL+opxOkhiJOPEPG5Le0gIh80gi/QDSsHGGU6193NSHTera4LD27ETI3TKpjqh5Q6X37GfSMFZnw/BMoEcM0lYzM0dx/1k1FdEuhi7HKul62N4zzDxyhbsa3pmQYnHdpJwHgj0zHr9KXNAauUKY=
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

Track the compound page order for HVO-backed sections and use that metadata
to detect struct pages that fall into the shared tail vmemmap range.
Skip those shared tail pages in memmap_init_range(), then initialize
pageblock migratetypes for the processed range with a helper after the
per-page initialization loop.

Keep direct mem_section access inside sparse helpers. Expose
pfn_to_section_compound_order() for callers that only need the order
associated with a PFN. This lets memmap_init_range() skip shared tail
vmemmap pages without exposing __pfn_to_section() to !SPARSEMEM builds.

This is a preparatory change for consolidating handling across users of
vmemmap optimization, and it also avoids redundant initialization of
shared tail vmemmap pages during early boot. That early-boot benefit
appears only once HugeTLB is switched to this common handling, since
HugeTLB is the early-boot user that creates those shared tail vmemmap
pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v6:
- Rename the section order field and helpers for compound page order
  (suggested by David Hildenbrand)
- Collect Reviewed-by from Mike Rapoport
- Collect Acked-by from Qi Zheng

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
index 5fb9b37819d5..738bf3d27256 100644
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
+	unsigned int compound_page_order;
+#endif
 #ifdef CONFIG_PAGE_EXTENSION
 	/*
 	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1533aebafb68..6655fe696e0f 100644
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
+			const unsigned int order = pfn_to_section_compound_order(pfn);
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
index 3b744667a7e6..da79c83adeae 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -10,6 +10,39 @@
 
 #include <linux/mmzone.h>
 
+#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
+static inline unsigned int section_compound_order(const struct mem_section *section)
+{
+	return section->compound_page_order;
+}
+
+static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
+{
+	return section_compound_order(__pfn_to_section(pfn));
+}
+#else
+static inline unsigned int section_compound_order(const struct mem_section *section)
+{
+	return 0;
+}
+
+static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
+{
+	return 0;
+}
+#endif
+
+static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
+{
+	const unsigned int order = pfn_to_section_compound_order(pfn);
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


