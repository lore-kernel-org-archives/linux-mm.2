Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C56DEC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:55:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C04C16B0099; Mon, 31 Aug 2026 03:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6036B009B; Mon, 31 Aug 2026 03:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA4DA6B009D; Mon, 31 Aug 2026 03:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 799DA6B0099
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:54:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0263DC0203
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:54:59 +0000 (UTC)
X-FDA: 85160803518.29.10CEFAD
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4131AC0002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:54:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="k/WnToFQ";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788162897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RFw62PZ7fKSG6PmMZYyDraeWannjZPtyw6lLCfcFAXM=;
	b=6Hrd2kpTi+4mxkuhVXC4xbs5r7SDRNwPcCblEleWGKM7kwkLS/l3WzoH9sVcWLGqgjatJD
	Zm1AZyzzjzGtzn/2e0iScEPIv8NGZtgYAWYwFFb/7ItxdNtS4+S7X1JG3ZX2ohqYaLlvIi
	DsPxoZR40SBSYieodXhXOC28LCskJ+s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="k/WnToFQ";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788162897;
	b=6q4jmjez9K9G4Dlu94FzwaOSLyZeNDv6DSxTXVgMAF/h52xyw1AcvOKOuhaVTeZtY6r9vH
	/zoBGVQl1LMGhqnqtviSVHz+hGnv+nviAImMH4vlwTpCWRiR0Y/Q9edItztqJohT4J39Kh
	DjL9eRrOQep1UEhQ8uCIOS7xJBMT5so=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-848643382fcso3375506b3a.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788162896; x=1788767696; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RFw62PZ7fKSG6PmMZYyDraeWannjZPtyw6lLCfcFAXM=;
        b=k/WnToFQrFUMzDhVGDwbJgs+8qDJ1Jo+iwwXFejN+Cv889Ksh8uq2K9x0cU/tgxCFD
         ggvzHtlQS383IuVO9LcSPkk46Eph/8ar4O/WyGJHk7Yn3t7xd33sg7OvWpd23ahCd+iX
         1qwk+IbqNXuyqLlnjMmkQHU1ROQcQW6WZ0sylatcDJdbr9GwjOtDzHKWYkWVYOVu96Mx
         kzjY3xsMgYJb+yKebeYFcIo55MNjNxvMILlrfoVt/gOE50ihDTBXcVRmzdK40oXfqjIM
         3HlrhCZqTxGPdzQ7aqr3GnoxAKlAsSGGcINIbzw8CZfhxvmvaZVXrCTuhIK8LO5d+Rdp
         SYLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788162896; x=1788767696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RFw62PZ7fKSG6PmMZYyDraeWannjZPtyw6lLCfcFAXM=;
        b=HjipwTYk0ejGJIDd+l2NGPXSLc5LVIRqK8crQcBKse/dZ9cDe+aNeknlCvgb2cMfPP
         fLt5v0JXvJqknMaL4xcJz3hnbUGxOGIpSVeHiqzj1tujtXaZlA7j9S8kS9uGBRD+IoDL
         PgODdpfgqI7OwIJn1xKm/TUhiKdacH2DbHTrEOCaEeH55ntrVrI+dS9PYVOqBQcNFXpp
         OVgjS74Ni6lfqTLGI+Sr9vjycmTGapyJuF24Ejjge1XmZCJ5RKz7sHusLbVBsOD4gf2a
         Fd4JmQlaOzocKmEpoMgyFmqOSO8RgHDRMQNFuYY099kHDCmNGOA1HBG8bcWk2rqXVqUR
         M9DA==
X-Gm-Message-State: AFuF++kU5BJztiuinhGuObf6JPAx14nJnNxgHakClZ7Yx+9HMcpxxFUP
	W65ihDcKCDmnJw+JO8ue7SPGk6jpsNsOqgLWGJUhGHQ4FVcQN1qbQAGgpE9eltWv/v0=
X-Gm-Gg: AR+sD10yOSmw0M/cg0plTeiJPuzMXgQUUCdl9+ivLEoQJDa2eFH5Ciz3z8NOJTaowXI
	mPJIQiWYuCsPb403Ms/ZGvOkgFc5/U+d1vzB2P/ND1AvbKBIm3spJ/X/Ezhchj0d8QhMRu1su76
	fzVpK3zS2XNthfYK51gidNGWY43/3lScfjZBIfqh5RT+oNysR7mHi/cT4vxN5G/IN8MrsOJzee0
	jpvbKyBCzSljy9YmZfdVjZM6RDn6C95mfFRtVISR+sIeSzWJ3B5uauB62/FpIZw+7D+4c+QGbvV
	M9/rnElfxajsmZaD5DIHoJsRqg39ELw+VHtEHiFDJKmdxnrJly13yK08gLl1hMvcZoc38nMTni8
	XhYcxX078InLogJF8YDxfXlcQU3kmUVS22vGFel3zM4bjANYVBAqGr4Tbv903EbrrnjwKVXBkqf
	MfSJ+vyswUHrf05AciZSNHTug9ZTqK/wxr21HfCyqeZt51VuICUdQfK+jMDhEl8OeVVefJJU318
	u9AT6dLAqzfImyE8oofGcnhghpznIP3p+I=
X-Received: by 2002:aa7:888a:0:b0:84f:dd30:1890 with SMTP id d2e1a72fcca58-85adb7bdb1dmr2240316b3a.15.1788162896019;
        Mon, 31 Aug 2026 00:54:56 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc1f330f88csm3590256a12.10.2026.08.31.00.54.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 31 Aug 2026 00:54:55 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 06/11] mm/sparse-vmemmap: switch device DAX to shared tail vmemmap pages
Date: Mon, 31 Aug 2026 15:53:37 +0800
Message-ID: <20260831075342.57563-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831075342.57563-1-songmuchun@bytedance.com>
References: <20260831075342.57563-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4131AC0002
X-Stat-Signature: 3tug3wkp8k181kwe5ri8z4591epzgfso
X-Rspam-User: 
X-HE-Tag: 1788162897-330278
X-HE-Meta: U2FsdGVkX1/JkV6HOAvu8sQUPjSpIO99/H9xdqgUSgCFHirI25FKi008HI+AAKVj/8pdW9gtq9WOJ/ssIEwOwQL7VWbHJ+sdOiSEqlXMjtdsJaf3nbNkN/ZMyUm/S/kd1bVDY/vB8H7zFOrkcKzHegN3YBxYGUmWbpnkzFbsEZw3WxHWHag+6hcvayAWzimJ7Sqn+uSSKmQbpuqw8XKTuoOQPLkhEpLTM43yEObXgUYHk19tPbUyeoiknEoIAtjmV9NGmj3mL4BLnggHw6GKPhJyo1l/hjClx+UbjH4xDyfbUfUqTFfYTUp/969xOHnIXOwUfDVjtaMw+kusrYv1fP2xjM9VdTpk5VS+osyx6V6kieeG3UipRU9El4TfB8B+zxdtkliIBeMFG7VnL53IUKTcXw537OeXJCk1OA11USLT8/1FpC0jBe3hfAlMsZ5xE+Tj+4UVcqROL107g/4PRbxUv5VaIA/1kQlPjTa9e5H3zC1gX8Vp2+aezYsKrAn8jy6bgR3NeuNWCXjeg75jO+DbikwJ0DNdbFoSUgvoGPKKRlBH8PAASnTW3/cPUSuiGMrV2oQ9PLmfoR3Bs6uvq0LSd/13ppn34171hErMeHAg3mzOW/CLKoeOJ9pYBBipn4jr2f8diJNfpZYaMrEf8InInY9sTfKB8L2Dxsu58y/TZYrE+5vtzrQgi+bsLfmYyIW/myOnvHnk7Lnxe6livaOw0tTTqC6pDt8O1Fb/E5sQioxEz9yjMVb4g4nbJ4uC5tpRm/Dvc7+QtbTmCCrnuPaVQ0K7sEVUOmBV9RlCKY9YUtpt5FHFJpwXrhYWQykvj1xB+SexmwBS9FMaCahnIxNAIHOzH5TKivoJxXY/yXPVZe9KdV/aI/PlJzMKSlFSpczYSVtVw+wXMnt4q7AABxsT9DHKpTtGqQwg3MFjywCFla5NGUvqRdUmQaVjOxtGcO9v+7nc7PhFdLj4JVD
 53JUvGsH
 DFc9c32PkN4Tq5eYcsA1NHKxo9hXQRaZr4Noatkz4E2jcOwLkpntqDUMyxRUKbAwBx3m0FcnH81ONQ8tKJjXnemjW78VzyXUWs6o8ruMjAybR8jrJBwiNPxGynlArVikDh2Vtbp9gZULZ7f5kDYALZ1b42GnOF/zILFh97J41u4+qUSdepX1C/Fze8tLTNAGGl8WD8Yl1IUDYCQDcHi0VxG7fU3TAWtf73+h+hC7wwngG3IKUDDE5X11PRqrt8mW5laHFXU/tWPUEVJeUicAAwcfoWH39Wr/tldTZ/TBrzVd31VUaEjLe5en563kFxeY+GNfP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HugeTLB vmemmap optimization now uses per-zone shared tail vmemmap pages.
Device DAX has not been switched to that mechanism yet.

Switch device DAX to vmemmap_shared_tail_page() as well. This aligns DAX
with HugeTLB by using the common per-zone shared tail vmemmap page.

Since the shared tail page can now back ZONE_DEVICE vmemmap mappings,
initialize its entries with PG_reserved for device zones. Also skip
poisoning vmemmap-optimizable sections while their struct pages may be
shared.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mmzone.h | 10 +++++++++
 mm/memory_hotplug.c    |  5 +++--
 mm/sparse-vmemmap.c    | 47 ++++++++++++++----------------------------
 3 files changed, 28 insertions(+), 34 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index d3778ba976a5..03ed9232f186 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1686,11 +1686,21 @@ static inline bool zone_is_zone_device(const struct zone *zone)
 {
 	return zone_idx(zone) == ZONE_DEVICE;
 }
+
+static inline struct zone *device_zone(int nid)
+{
+	return &NODE_DATA(nid)->node_zones[ZONE_DEVICE];
+}
 #else
 static inline bool zone_is_zone_device(const struct zone *zone)
 {
 	return false;
 }
+
+static inline struct zone *device_zone(int nid)
+{
+	return NULL;
+}
 #endif
 
 /*
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 226ab9cb078a..d28bafb6fd53 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -554,8 +554,9 @@ void remove_pfn_range_from_zone(struct zone *zone,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages =
 			min(end_pfn - pfn, SECTION_ALIGN_UP(pfn + 1) - pfn);
-		page_init_poison(pfn_to_page(pfn),
-				 sizeof(struct page) * cur_nr_pages);
+		if (!section_vmemmap_optimizable(__pfn_to_section(pfn)))
+			page_init_poison(pfn_to_page(pfn),
+					 sizeof(struct page) * cur_nr_pages);
 	}
 
 	/*
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index aed1e7429daa..0201877a7f80 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -193,6 +193,8 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 		set_page_node(page, zone_to_nid(zone));
 		set_page_zone(page, zone_idx(zone));
 		prep_compound_tail(page, NULL, order);
+		if (zone_is_zone_device(zone))
+			__SetPageReserved(page);
 	}
 
 	page = virt_to_page(addr);
@@ -490,23 +492,6 @@ static bool __meminit reuse_compound_section(unsigned long start_pfn,
 	return !IS_ALIGNED(offset, nr_pages) && nr_pages > PAGES_PER_SUBSECTION;
 }
 
-static pte_t * __meminit compound_section_tail_page(unsigned long addr)
-{
-	pte_t *pte;
-
-	addr -= PAGE_SIZE;
-
-	/*
-	 * Assuming sections are populated sequentially, the previous section's
-	 * page data can be reused.
-	 */
-	pte = pte_offset_kernel(pmd_off_k(addr), addr);
-	if (!pte)
-		return NULL;
-
-	return pte;
-}
-
 static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 						     unsigned long start,
 						     unsigned long end, int node,
@@ -516,21 +501,18 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	pte_t *pte;
 	int rc;
 	unsigned long flags = VMEMMAP_POPULATE_DAX;
+	struct page *page;
+	unsigned int order = pfn_to_section_order(start_pfn);
 
-	if (reuse_compound_section(start_pfn, pgmap)) {
-		pte = compound_section_tail_page(start);
-		if (!pte)
-			return -ENOMEM;
+	page = vmemmap_shared_tail_page(order, device_zone(node));
+	if (!page)
+		return -ENOMEM;
 
-		/*
-		 * Reuse the page that was populated in the prior iteration
-		 * with just tail struct pages.
-		 */
+	if (reuse_compound_section(start_pfn, pgmap))
 		return vmemmap_populate_range(start, end, node, NULL,
-					      pte_pfn(ptep_get(pte)), flags);
-	}
+					      page_to_pfn(page), flags);
 
-	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
+	size = min(end - start, (1UL << order) * sizeof(struct page));
 	for (addr = start; addr < end; addr += size) {
 		unsigned long next, last = addr + size;
 
@@ -546,12 +528,12 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 			return -ENOMEM;
 
 		/*
-		 * Reuse the previous page for the rest of tail pages
+		 * Reuse the shared page for the rest of tail pages
 		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
 		 */
 		next += PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
-					    pte_pfn(ptep_get(pte)), flags);
+					    page_to_pfn(page), flags);
 		if (rc)
 			return -ENOMEM;
 	}
@@ -883,13 +865,14 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	if (IS_ERR(memmap))
 		return PTR_ERR(memmap);
 
+	ms = __nr_to_section(section_nr);
 	/*
 	 * Poison uninitialized struct pages in order to catch invalid flags
 	 * combinations.
 	 */
-	page_init_poison(memmap, sizeof(struct page) * nr_pages);
+	if (!section_vmemmap_optimizable(ms))
+		page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
-	ms = __nr_to_section(section_nr);
 	__section_mark_present(ms, section_nr);
 
 	/* Align memmap to section boundary in the subsection case */
-- 
2.54.0


