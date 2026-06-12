Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2678CD98D2
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2203A6B00B1; Fri, 12 Jun 2026 00:00:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F77A6B00B3; Fri, 12 Jun 2026 00:00:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E6B86B00B4; Fri, 12 Jun 2026 00:00:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF4F26B00B1
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:00:30 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7938DC2643
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:30 +0000 (UTC)
X-FDA: 84869908620.16.AB82A0A
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8DF9640009
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JkO+HEj+;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7F0jyR+NYrp4SN+/Gr3YYzk571idnjCyjkNavYszN4=;
	b=PQINOh84ElGxNvowTQImL/zEm+UBqn38K/dOWJWQrWHt3Flr3VPd6ZWm3P9GkyVfxy57ZA
	yE+ClcIwN+9xK/rezHysfnjPJs3F+CBB9Auxa9fh8Fe9meZq/2t5lB1ZA/dougwlECI35N
	AP9CJHmxvnV5mtfhHCfYLNYHkqvgUl0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=JkO+HEj+;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf27.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236828;
	b=TJgyio2MdHaNqJoArtKNpBhQvB8EPG8qGWB33gW76WbOrg/ebAcr1EO4Rzuv96Afj2NoHR
	TDJHMu2fN1wTB/s3+4aK/+DfyPribQZ7GyKtab2RaPCxeOLRcnrHU3z5+pwCUv2mlbAh77
	0cP3evv/AtJTwJyfRIOmX4cbthDc4IM=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-84275887a3fso1129695b3a.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1781236827; x=1781841627; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z7F0jyR+NYrp4SN+/Gr3YYzk571idnjCyjkNavYszN4=;
        b=JkO+HEj+jL5zkLVnFts2FURkVszw5IjjFUjtJOqQjKX/EPgNBN8nNrvM8twc4z2qvx
         6pn4ovoL9wHBJb2k/MhDWIcjN5Xn8FLD+NNxbCLi7gQI7BggqR9AjwdiAiJ5uLA9NQ11
         JoAQwef1tS/r92KQivBxymmwtgdOH145hdMdFYP1eyCckoKg0z9J98hRiPRbJVmyOFHo
         HRyTDFBs8NjosFBa0QVjWpD2OWlxxIzeKe1d+vSOwAakeHYTPtGvzXf7sED+2STBdzBQ
         F71B0RhLpBCgRDsznou1faw+FY2JVNzuppOSQ4lBHp5dR6pz+0rMyOxMSRRJ2GUrKqqj
         k1Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236827; x=1781841627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z7F0jyR+NYrp4SN+/Gr3YYzk571idnjCyjkNavYszN4=;
        b=mTvZ2VV37FeIiRnHbvww/AFpcHSfbn/6CgHMFw0l6Ar+wuFkqlDxb6ILGt0lqfEfCA
         VGW871eHPaPFPQ3GzSsQsikTmXwYllSjrjZloY4Gp9lw6CzrionIMxGcONaGbCFEH6+C
         jPRWKQm1HDQXm0SoZz7UhSOsZGdOh5Vd9c47JKB4xHRxl/8M6T+5ZtR+Hj1s4o6v1vtR
         J44uM80GzGRf5l8+0iCLK7Lq83yO8eEZti82rJrAGwSyIEHZYToQrtliOHo0BPabJkn9
         /Ljirznho7rk3rgtqGD8ErEqLjoOdVmRjVXcsJf1o/kLS96su9iG644tKrSuDH4pEXvj
         oACQ==
X-Forwarded-Encrypted: i=1; AFNElJ9AjuRJEAQADAEfYzc1ujoN8soQphdis/zNpEDV0dEcSWq0tqhTwCokD0mq9WCHcsDcjCSefDCllQ==@kvack.org
X-Gm-Message-State: AOJu0Yz0gBA9DZavERblLiv1GFPTHA6BLB85eEM/irSxLhzFD/sByCB9
	Ofkw1iSuD8hKppMYQcgnkFdicbBGtrkgu1Zead3kIryCXuO9aPszmdbntaEDxkDnBL8=
X-Gm-Gg: Acq92OHHvXnZGxP0nAjvtlw+VMBJGSsMDwb3Oj0ikQwsOnYsW7/sKkn7fEUkfYJ3CdV
	cOUJz6BKwahY9nJeMJfbsXklInHNYrt7cxEzdPN0Dx1DQLQ1FPjnUzeBbDPp5BvFyQAx4Wm/vmV
	Rp1YL2do63HP6vf5k0AJq/s/1rlrgzBNmFd/PK3YLSvzxOEpZ908yka+dUpF2M2YPsXvc/YwIvW
	BFHc4IgAvtPDJAwc2v1V42v4DVjrziftF0HQlLfTPvD/44MzNtJQhzMLQdTj6WH+fOVJAfWtaaF
	hdBXiIJy2RrZGluJ4LKwyL8gY9VHNNPRKR+6WwKL+f7GM12vaEVFE1Rf8S3AzdJoCe/P+M7WmBm
	bb5IdX98PCXGcubsnWAwYN113NvMgHdWJeJvqOHZ90GRkf8zwkQ6qrI/GoX6b3XkGgT+RvXU5Zi
	54/XE3bBrF7hYWY+itFzPAqeliDRbXoSl919E1CGXwacGoZrI1iIUyCA==
X-Received: by 2002:aa7:888f:0:b0:842:47f7:5f1 with SMTP id d2e1a72fcca58-8434978f969mr1354803b3a.28.1781236827034;
        Thu, 11 Jun 2026 21:00:27 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434ad03fdcsm643352b3a.24.2026.06.11.21.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 21:00:26 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v4 15/19] mm/hugetlb_vmemmap: Move bootmem HVO setup to early init
Date: Fri, 12 Jun 2026 11:58:59 +0800
Message-ID: <20260612035903.2468601-16-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8DF9640009
X-Stat-Signature: 4si45r9yrkmgsu99x96x4tdruwwz4ibf
X-Rspam-User: 
X-HE-Tag: 1781236828-497782
X-HE-Meta: U2FsdGVkX1/gdOdA08WsRDv6AfEeuLNU3mpF9eu1qaGPIxklVhKURi4EEhmQYEYQ+UDNvporNetoqP5O+DWkqRp4t1ttIN32gY3Y05J8+HBzJhrgOzmQkidN2vmsCoXOsrmlgQglHG6P01h65ftYC3Hpk2a/O+qTMMneGVKCc0JEzuV0/+nbJ7DfThjStZJEgI9jKSSfZSYk5iBc1DZpe/Z+2BtZakms7y59n8CEyMw8Q4TojzvNVb6Ms4b+XZai2hxCcCWrruQdylfoCHs/fgAX6i9/aB5Io7Q4mCjctFZYONMmnlAPRcfB/PGmB+6HOnjtY5pyzkbDUnRLQhaKsJBejFt/r1kBdOqkjPCZ+Rm6jsu7DcfjcoP2ZQ7waYaEwNgeezr4FQSYTqgDB9Sz3DF9Tb0PHlaVqaYiGQEcf2/T782c83u3VlQjipfX+1OdoBTxBWrdiRzFVx3mrhWKoD2MY9/K0vU04jClBz286I9MaO9RhUsKw2YhmCaNmJ6o1t1TWE723AwM9pVoZVRBATmGNU5ayfAfUoIVC5eoW8mrgjsLEdQTYFi4RGFCVL/fbkLOJuPxYGVxOZmYEe2Ko5xwvwzEFkfh68VJdIqJ0rKPYehCwKV0SdVh82jSnalzOCdqSTja8UwEL3p1JgTlLERV5zuwtYDI2GOIK2lva7TO11SFgnqowoIh9c14GCRvIsCkuHPqExJ2aDUciTlJBvx88mllrbRa5jIHfuRCrMW9ByDxBWrpxVoNMn9PohRuGLw10Gt2qT44tGMQMjvTTtCohATKKk5lpkaIe3M665YAFIMfkKI//EO00dYLCPrEP0OOWa2WYfXtFT4dcMUT09ZnpsBK7lWkQk/9+4J/9SS85CtRyaRHoitad3cMOCavzvPNU2TxouOLRIEEwK9iIhkBQ80XFu3xAJRS7fFx3Q/2deBqRv7GoRCnMVGH+feioJOmkIYhvXQfFUGxx9K
 tSgk/I8h
 ni4FdAG/F6AUk7PjRqE/qUelgUcM4rMccf9N5Bdft5J1uDLnqsmz/L7+We5wxiPyphG4VMMG5sWSYW/VXMDUHfY8bjcr/fIugZMk4hgj1Kc1Qo2rRRCbCiDcVuTcbVG5q4RhZxFteDhSsdXnT+5obAAKGiOXTqKz6V1XKZpbtylhbqjuADH5WbpMfaNBPL99RnxDrdLRaI+WBWsJzI7o3X2rltQS5BqHbuz5sOpefVXlgCB4UEyeQYeotxGpbe/8Zju4PNqH26A89P1uP5/kZgum3urUwYbtBPBGxfPK8u6EXrW8e6DubRfru8hIY7CY36Pj+vnprU2S/AVjSlPxVdzCHxuaN572jCDV7bMoj5mF4vSAzW8YR9axq8gc5zvTRtnveHYXMDlmR6BBEMeDS2ZYobBgZnQpiZNu6t3Cmr2mo0j/GlYOCt70ppADgqhqfgiZx9yLfihWhRW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bootmem HugeTLB pages currently defer HVO setup to
hugetlb_vmemmap_init_late(), because the optimization needs zone
information.

Now that zone initialization is available earlier, the bootmem HVO setup
can be done directly from hugetlb_vmemmap_init_early(). This lets
gigantic HugeTLB pages apply HVO as soon as they are allocated.

Bootmem gigantic pages that span multiple zones are now filtered out
when they are allocated, so the remaining bootmem gigantic pages seen by
later hugetlb initialization are already zone-valid. As a result,
hugetlb_vmemmap_init_late() no longer needs to handle bootmem HVO setup.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>

---
v3->v4:
- Move pfn_to_zone() before hugetlb_vmemmap_init_early() instead of
  adding a forward declaration (suggested by Mike Rapoport)
- Collect Acked-by from Mike Rapoport and Usama Arif
---
 mm/hugetlb_vmemmap.c | 93 ++++++++++++--------------------------------
 1 file changed, 25 insertions(+), 68 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index ea6af85bfec1..ee4fbd5fed0d 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -745,6 +745,20 @@ static bool vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
 	return true;
 }
 
+static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
+{
+	struct zone *zone;
+	enum zone_type zone_type;
+
+	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
+		zone = &NODE_DATA(nid)->node_zones[zone_type];
+		if (zone_spans_pfn(zone, pfn))
+			return zone;
+	}
+
+	return NULL;
+}
+
 /*
  * Initialize memmap section for a gigantic page, HVO-style.
  */
@@ -752,6 +766,7 @@ void __init hugetlb_vmemmap_init_early(int nid)
 {
 	unsigned long psize, paddr, section_size;
 	unsigned long ns, i, pnum, pfn, nr_pages;
+	unsigned long start, end;
 	struct huge_bootmem_page *m = NULL;
 	void *map;
 
@@ -761,6 +776,8 @@ void __init hugetlb_vmemmap_init_early(int nid)
 	section_size = (1UL << PA_SECTION_SHIFT);
 
 	list_for_each_entry(m, &huge_boot_pages[nid], list) {
+		struct zone *zone;
+
 		if (!vmemmap_should_optimize_bootmem_page(m))
 			continue;
 
@@ -769,6 +786,14 @@ void __init hugetlb_vmemmap_init_early(int nid)
 		paddr = virt_to_phys(m);
 		pfn = PHYS_PFN(paddr);
 		map = pfn_to_page(pfn);
+		start = (unsigned long)map;
+		end = start + hugetlb_vmemmap_size(m->hstate);
+		zone = pfn_to_zone(nid, pfn);
+
+		if (vmemmap_populate_hvo(start, end, huge_page_order(m->hstate),
+					 zone, HUGETLB_VMEMMAP_RESERVE_SIZE))
+			panic("Failed to allocate memmap for HugeTLB page\n");
+		memmap_boot_pages_add(DIV_ROUND_UP(HUGETLB_VMEMMAP_RESERVE_SIZE, PAGE_SIZE));
 
 		pnum = pfn_to_section_nr(pfn);
 		ns = psize / section_size;
@@ -784,76 +809,8 @@ void __init hugetlb_vmemmap_init_early(int nid)
 	}
 }
 
-static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
-{
-	struct zone *zone;
-	enum zone_type zone_type;
-
-	for (zone_type = 0; zone_type < MAX_NR_ZONES; zone_type++) {
-		zone = &NODE_DATA(nid)->node_zones[zone_type];
-		if (zone_spans_pfn(zone, pfn))
-			return zone;
-	}
-
-	return NULL;
-}
-
 void __init hugetlb_vmemmap_init_late(int nid)
 {
-	struct huge_bootmem_page *m, *tm;
-	unsigned long phys, nr_pages, start, end;
-	unsigned long pfn, nr_mmap;
-	struct zone *zone = NULL;
-	struct hstate *h;
-	void *map;
-
-	if (!READ_ONCE(vmemmap_optimize_enabled))
-		return;
-
-	list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
-		if (!(m->flags & HUGE_BOOTMEM_HVO))
-			continue;
-
-		phys = virt_to_phys(m);
-		h = m->hstate;
-		pfn = PHYS_PFN(phys);
-		nr_pages = pages_per_huge_page(h);
-		map = pfn_to_page(pfn);
-		start = (unsigned long)map;
-		end = start + nr_pages * sizeof(struct page);
-
-		if (!hugetlb_bootmem_page_zones_valid(nid, m)) {
-			/*
-			 * Oops, the hugetlb page spans multiple zones.
-			 * Remove it from the list, and populate it normally.
-			 */
-			list_del(&m->list);
-
-			vmemmap_populate(start, end, nid, NULL);
-			nr_mmap = end - start;
-			memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
-
-			memblock_phys_free(phys, huge_page_size(h));
-			continue;
-		}
-
-		if (!zone || !zone_spans_pfn(zone, pfn))
-			zone = pfn_to_zone(nid, pfn);
-		if (WARN_ON_ONCE(!zone))
-			continue;
-
-		if (vmemmap_populate_hvo(start, end, huge_page_order(h), zone,
-					 HUGETLB_VMEMMAP_RESERVE_SIZE) < 0) {
-			/* Fallback if HVO population fails */
-			vmemmap_populate(start, end, nid, NULL);
-			nr_mmap = end - start;
-		} else {
-			m->flags |= HUGE_BOOTMEM_ZONES_VALID;
-			nr_mmap = HUGETLB_VMEMMAP_RESERVE_SIZE;
-		}
-
-		memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
-	}
 }
 #endif
 
-- 
2.54.0


