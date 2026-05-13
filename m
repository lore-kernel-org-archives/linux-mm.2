Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67BCFCD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6B26B00E0; Wed, 13 May 2026 09:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87C16B00E2; Wed, 13 May 2026 09:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9CA36B00E3; Wed, 13 May 2026 09:11:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A9CF66B00E0
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:11:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 74DF3160110
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:11:10 +0000 (UTC)
X-FDA: 84762432300.20.7B8A724
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8DCFDA000C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:11:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RSc6+N6i;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lVy27NFdLuqlZKA5DziPKCwbPsRWePBCMeJ/pOD9y2M=;
	b=1GKvCL5H6WuAfA8tGnHXknD3jyQkGu5Zzxi4LfB4BaYLDVxsM299W+gFdYFo5/+jDsYp97
	nuuXeoqliCFpX+Z2JGgabkdJ0ReQITxwrHP6rsH3cR5QvHnTKMAx8EU3DV+06F0WkOQFmY
	3QhaYkyEWJec5+bxCgb3T+NFdANzWTA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677868; a=rsa-sha256;
	cv=none;
	b=EBiB3FguQNsyU5uSGP2TRwPPjbJcof9BEkI4BZnSxUCiPMHVZFjVzXwfY3rFXG7JakWEDm
	pHo749C6tt/2PFDPHlbdPKq0OX9nbDp/fFz6F2oHzJMOyvX7/0c1uCckfq9kp9yHyHwe1N
	thgsirqNl2bo3wNQoMiUF5lMG5WlvLw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RSc6+N6i;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2bc85eda6b6so20799245ad.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677867; x=1779282667; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lVy27NFdLuqlZKA5DziPKCwbPsRWePBCMeJ/pOD9y2M=;
        b=RSc6+N6i/LdxTCp2jgTqQ9BPLvC3kmvjF6qL6XGo3kk8TVAcHhGUnkR3/VQv9fkIoo
         z10piQfA1kHw4k/UzoTdS3GJt8BABUlg3Zy5y+iEqYpyxvi3n0G7lJUUXiAYSauOKE+Q
         9VuVpCtqfAFJ4i62GqhfiyW6C/o1eeus9IdaKzcwrROj26F6LPdrI8tl4gBNdLIUmQcy
         Dos3H9g49+2yliwgeviSzRk+jJbH8xkv9lMWFhzG3g8SSDoSX2rQXmGfezrtVM0jQqmC
         KdTBIaPbO9W6RI5ksbK76ESuoK4gHGymoa8eVXxallctz38CpF9XbftG2lWLXMurbsjx
         vv+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677867; x=1779282667;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lVy27NFdLuqlZKA5DziPKCwbPsRWePBCMeJ/pOD9y2M=;
        b=EIBNgEuJUPXnPwwNeumMpPlbrcKbi2jmgOHwfT6Ns5+AwNhYwx4+1rHiJkYhxycCWL
         Yse8HT2Q3KvMG3IJdk94ymdmmpwQJvNiZa34njpNJqdoucoEAd8agF3jQmBnilTfgx7r
         u6Qjd9kr2K5/k1POYrPTiYyD9u0RBr484k9kV42zaZEIwSYJDLYa098QpKPjGC4Or84A
         EdVHiZetpXG+YH9O3ZWAo/9yStmSdoCohMzq6/nI5JwCyVgkaj13XUhWYtGDPSYe3yQ5
         H6Is6MMPm9pzJz3TG9DfBUYLztbd3z/CLq+zpN8f0M8BIwPAlXZrpKg390qHE9gZRJrI
         gMeQ==
X-Forwarded-Encrypted: i=1; AFNElJ/i+cuCl0HM9XKLkvLXy/13xiC4zbFddPwIZ7QJ4RmoAT7K4a/zdp5lBf7tcKeZHbsvxGirN+abrQ==@kvack.org
X-Gm-Message-State: AOJu0Yy0CQjoWhlV+wVSe6HILB5dvwVO+ZDAItbRy9/3lk1i5rS9sp5t
	9ZIaAGfE9V9SZnS1mtjQFl15XzbijWGlFXbzuP1zv6kH8ov+4fwDBOhWmsEpE8cGyhU=
X-Gm-Gg: Acq92OHL/v9XNOgKeGV8koTq8EbL1qpcI/AUWa2BUVZcUAQpOg/Kr2s9eQgJwxRnTOj
	iy8syRtOhxAB18cgz8oxyKMo2gh02jaoFKgmyp+sBeJOR3V0eEX2pPFYq+MgqcBR79mc/LvpRlJ
	iiR09VSCIUZ7ERFw7UNp5cjcKVYfLbkVRU5FuG4DAb5v/38n8tTx8bD+asfJ6qMXxj3TH/fdrZF
	lVoXNR/b2c+k8G/h0v0MEmXir7S+Of66OU+x8SW/VnktLl6mrwuR5gfL1UD1dgTEHVXEtCuOgWu
	NKlrGkUJ/uGMJDni+nQoW8V5pSY7yU+S2/xBBkfsKlvDZvgQwG0qe/jKwT/T7rjW9ecoGsr5+Kk
	hvG1B73ec8ZT4XfcIGHuj81mA4Yfo8jbwL0ZWWoaoyQEwi6I8pH9SfZ1axL8fACa649BgYp8eqB
	gMx2KaWWDcyYOUcaEd08R/m1oDE3KM/ry0Kd/PP4yKEHEaPvR507WVR/oBFHI=
X-Received: by 2002:a17:903:8c8:b0:2b4:65ab:57cd with SMTP id d9443c01a7336-2bd275c0c48mr35313305ad.36.1778677867293;
        Wed, 13 May 2026 06:11:07 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.11.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:11:06 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 39/69] mm/sparse-vmemmap: Switch DAX to vmemmap_shared_tail_page()
Date: Wed, 13 May 2026 21:05:07 +0800
Message-ID: <20260513130542.35604-40-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8DCFDA000C
X-Rspam-User: 
X-Stat-Signature: xbryw9377z4jhepnc4k3dm7rdhe7dkkk
X-HE-Tag: 1778677868-815987
X-HE-Meta: U2FsdGVkX19bJV3fm8KEOVePKRpIyIXwyXRllPgIhMXRrpHRE29ZPPOm1Bl6agID0HqRO+WTsaGP99RP0+l/eBV8zAgG+eGoDlgqDO7VGXNQG8cpQ1zhhjrWhvGXtoy120O7RRMQTMJ45OxyurUEkvwF5PKCLptQ8qY+GIFZ7A+ZLyaqs7jmlcXQhoJSkCKNfgylYYOb8DAVIM9p1UNPXa7iBhNeGo4yuT8ZiYjANR+iR2A/9VpgKKsQ58AvImgoU+Z+6ExmetaDBAA8SXOawU4WR8Jxw7+l9yBe8YGjLZ4lOAW97mpIABx7Di0eF5Dd+WsRHSHOq5jR2A89S5u/e2Gc+j0rnsnR5o5ORuXHjkEJXEQrH/7Egz7qsUsyBOfykaisHN09r8iCj3DId7uqoAiceyczXNtY/9QcWVSGVuBbHLStWf78n6MKEyn/SDK3D0Pu+heoZXcCcg4eOG2MzN0wrwsDd9171DJ9GvV34Lz9t+IeTt8dbOq6l7OpudAtre7FuBnFJCE0ceM2rnhdVBEY1jyAs0Ql9CR9BlcDhTe8HEC+a3CFGyyEl8TPnGZhMMToygfIqUxq/fnx4Z54sxKdqShLjKALX/SUT+cCPWaoXQUNTEBDfYB8jS2sBHDgjgMnJlDwU+TdH4hHGihbz5XtzcGLCQGf/Udbh1XU4YAOnA6Gnbsnxz09v0IiLzTxrjjVvaEZSXXTWElD2sfHV57U5eQ450IPCpIjCMp/uHVqBwfwWYN6C9rBf3TuJiSptXycnmqJ70WrKfO6s37f2Bt/W6LRPMuiDcDPC5TAc4YVlLvZsYIWY99Vj8QrtF4k7rDN7LkeN1VAdEK8VCVC4sLzxFlfNBCoKyOFBTbOLHyRVbdOsBpvdSLYADr+MQmUrr+WPrDIYENW6lY1zNvfQrw6h1Yt6fxe5xVgONYIq0RAr6yiSA/it3LeBKObTa7k+2zTIU604TmuczDiDVu
 LhcNZvuM
 /gdo4fgtOWJuu14Otl0P8VY1JrJYgV+tbXMzwZd43uU66v5dPdzTXcUtbCEu+1Ho4crUJ8/caIzuHB/pYSCL21I5cHFJe24QGWPJerrUi/Ht+jJtY7o29jjjjTCyQC1EZI6B3302fmcUCDUz/nnrUDp4j+vf9bhHW3RB2QvRMjPAzh3ohBWicArgC+19Ypa0aNabYm58GmIoLJhFMeMVzlaUq8shkFjaXVmsu/p4ReCvy6/FcMh3uUZyLs6uIeGCvStuezfBm3jekBb7RumcWiXCzGn6dpz7IOJGzukquZmPyoCfdzW39L/y6XjG0t60kZzWI/xIsH4N/hcriQHPwzXJN+i9oZJ/+/DGLwVj+ugkbW/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAX compound vmemmap population still has its own way to find a reusable
tail page by walking the previous section's PTEs.

Switch it to the common vmemmap_shared_tail_page() helper instead, so
DAX uses the same per-zone shared tail page as the other vmemmap
optimization users.  This removes the PTE walk and lets both the section
reuse path and the populate path use the same shared page directly.

When the target zone is ZONE_DEVICE, mark the shared tail page entries
PG_reserved as well, so they match the initialization requirements for
device pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mmzone.h | 10 +++++++++
 mm/memory_hotplug.c    |  9 ++++++--
 mm/sparse-vmemmap.c    | 48 ++++++++++++++----------------------------
 3 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 5285d53b0c53..7484e7be7b6d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1693,11 +1693,21 @@ static inline bool zone_is_zone_device(const struct zone *zone)
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
index 462d8dcd636d..9ff830703785 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -551,8 +551,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages =
 			min(end_pfn - pfn, SECTION_ALIGN_UP(pfn + 1) - pfn);
-		page_init_poison(pfn_to_page(pfn),
-				 sizeof(struct page) * cur_nr_pages);
+		/*
+		 * This is a temporary workaround to prevent the shared vmemmap
+		 * page from being overwritten; it will be removed later.
+		 */
+		if (!zone_is_zone_device(zone))
+			page_init_poison(pfn_to_page(pfn),
+					 sizeof(struct page) * cur_nr_pages);
 	}
 
 	/*
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 53a341fcde74..0c0b54e94c07 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -329,8 +329,12 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 	if (!addr)
 		return NULL;
 
-	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
-		init_compound_tail((struct page *)addr + i, NULL, order, zone);
+	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++) {
+		page = (struct page *)addr + i;
+		if (zone_is_zone_device(zone))
+			__SetPageReserved(page);
+		init_compound_tail(page, NULL, order, zone);
+	}
 
 	page = virt_to_page(addr);
 	if (cmpxchg(&zone->vmemmap_tails[idx], NULL, page) != NULL) {
@@ -442,23 +446,6 @@ static bool __meminit reuse_compound_section(unsigned long start_pfn,
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
@@ -467,19 +454,15 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	unsigned long size, addr;
 	pte_t *pte;
 	int rc;
+	struct page *page;
 
-	if (reuse_compound_section(start_pfn, pgmap)) {
-		pte = compound_section_tail_page(start);
-		if (!pte)
-			return -ENOMEM;
+	page = vmemmap_shared_tail_page(pgmap->vmemmap_shift, device_zone(node));
+	if (!page)
+		return -ENOMEM;
 
-		/*
-		 * Reuse the page that was populated in the prior iteration
-		 * with just tail struct pages.
-		 */
+	if (reuse_compound_section(start_pfn, pgmap))
 		return vmemmap_populate_range(start, end, node, NULL,
-					      pte_pfn(ptep_get(pte)));
-	}
+					      page_to_pfn(page));
 
 	size = min(end - start, pgmap_vmemmap_nr(pgmap) * sizeof(struct page));
 	for (addr = start; addr < end; addr += size) {
@@ -497,12 +480,12 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 			return -ENOMEM;
 
 		/*
-		 * Reuse the previous page for the rest of tail pages
+		 * Reuse the shared page for the rest of tail pages
 		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
 		 */
 		next += PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
-					    pte_pfn(ptep_get(pte)));
+					    page_to_pfn(page));
 		if (rc)
 			return -ENOMEM;
 	}
@@ -828,7 +811,8 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	 * Poison uninitialized struct pages in order to catch invalid flags
 	 * combinations.
 	 */
-	page_init_poison(memmap, sizeof(struct page) * nr_pages);
+	if (!vmemmap_can_optimize(altmap, pgmap))
+		page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
 	ms = __nr_to_section(section_nr);
 	__section_mark_present(ms, section_nr);
-- 
2.54.0


