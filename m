Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50358F4198B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 11:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B82DD6B009F; Wed, 15 Apr 2026 07:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0BA36B00A0; Wed, 15 Apr 2026 07:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A22B06B00A1; Wed, 15 Apr 2026 07:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 904196B009F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:15:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC36E1A0418
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:15:00 +0000 (UTC)
X-FDA: 84660533160.19.CCF5D7C
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0E112140002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:14:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=b77jdqGH;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776251699; a=rsa-sha256;
	cv=none;
	b=wJsyoUfcdTvXzRCjaFuRUC61Dna6of1dNrrtwxrvAQWURC1jwEnb6RdZ2N7eQqgXm9jwoA
	4ctMYuAxvENR0HzaZKowCdmNbri0QXOOvpp9laRaiRJktKOI72CkcQIg8vD+viCNIwP0Vr
	NJQGVk5j6Q2Ydj1qSGDhviVGD9vspcc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776251699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M2tbh3r8pv+EpSWaqLjjsd7slEO4DRhf7DkjZnRXEmM=;
	b=fXcWxEo6rxX25AT2ga0SFJgNlsJmqXQiHVro7vaU1KTLhr6+2zHLtcnvPFKJMhlHvgHYF5
	SiysXJtFtoWY9pmJgbf+J3nhY3np8+FnV4WPR2LGBESsg1FdArJb5hPOplg8CqKgGU4mKO
	qm0VM7aINNZ5Fzxj9w6lFd+4wjSn5BE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=b77jdqGH;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a7a9b8ed69so50757155ad.2
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776251698; x=1776856498; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M2tbh3r8pv+EpSWaqLjjsd7slEO4DRhf7DkjZnRXEmM=;
        b=b77jdqGHGbBijtqpi3zloGrB6HXubHt9Bw7sL3esj8alddYJRYF8HTi1q67WMAn0tI
         +HvtvQldSe90V3BJGKPgK6FpVF0Go8BJH2F2fMdIezHxnu+Z/qSHgxxXMyXCuGRMZT5w
         SS0A40z3VHyPvI6T487B7kMn34dJ7ihuWdJWCJi4OC1Njj88c+xw/hdI8Z81DcbVC/OC
         yCyQ88FhTsR/Foinls738XhfTDx6gVUku5D/WitqkiAbVQUCG777Vl5w3b4HqazgCFWP
         zdGWg6BVB9QQqbyeP6ya+u6s49SEL/dlHPhT69a5Nk3ifHezS+NDgl9lkvoQPXMgQ97E
         mpug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776251698; x=1776856498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M2tbh3r8pv+EpSWaqLjjsd7slEO4DRhf7DkjZnRXEmM=;
        b=aX/YEnxmv/xdFOzACmSTfilshwkFFwMBW1+gR85EgwrEmyBbpUlIN8Z1nEehmvvs42
         ZaKYI6yCZfiOrJEGgbJm9RuVQmxAtRg8CM7Gkx7vqCUqcY/+Ywwy3301YePqTT99vMC0
         2KRNSar2alN4R1YFakAyZdJ0dhs02uxusw21Ja/FzX1qmn0u0rCnzj6KtEeofikj8FLA
         opuqyVOEJ226O0PxfmsF6F4BCmBEdrP6xRbzbec2EFqvV9U4XsnYO4wHGF6um6SGZ9jz
         l3VEmpHH0cYBXI+NKCi+8MCI1rYbQCaLJcYu1L/nj3X5b98c+5QqYPEYrfM9vWOZrduh
         hkYA==
X-Forwarded-Encrypted: i=1; AFNElJ+sYD4sSbMsf36yQv4KsDFPoe6Y3k+maB1S73IxS8mVPgSfajb95maY/XsRCgtVrheC14mriER5zQ==@kvack.org
X-Gm-Message-State: AOJu0YxIOYe6QXBjKL09GbgpjhMMq3ULBaDq3XCu8ItCKYdZJ35zVEJu
	ndfqrS5YYb+mK3aQBS79CVjJhOySdzSA7yLqsCU15e24sM0h0t/ui4ZHPKjdxqTK7ec=
X-Gm-Gg: AeBDievo1Sw/i8NBVrqr7SPwPkSGpfe9VElGNYdxINvR9F+Uy/xQ0DWdloj6K2ckKy1
	8W1/CCHmSoCvuIApW+9mlmojpsoSnLKKXAgyNp7jPSbYnaBPSf2E5GFA3Bjt4orVbxXDvSy33Yk
	cSsFE71po2UC8N60RJlhf6J4Ui0f7YIOa1qKQIdoec/clmqBetDoZ+yE472oC+zhxgtbrj2f9sf
	3yJW3d2k6S3IUlbjTnLXcVnX6xxHPmPFuSVBK+bUiDsnbZ322IxCU28YTxm82pCAXcw/WVXunxC
	yvxbFiP9IWwC2PBvpLPZrufCeQWN9ppPVqrfohC7EbxmPGxIQ1cXpv3x8UyyRsrZYkQp/oafiJh
	m2Lmyv8O0f0trWqQKp/TRu9cHxvsgiAfNG5wshMbJjLJDoLYAXkWovQwaAVwZt9li5Bf2wq1DYA
	iNnAK6civFe2jzpIm29aC+mVkGMGT5azcVpnG6+IwNjkE=
X-Received: by 2002:a17:903:1a24:b0:2b4:63c8:ce18 with SMTP id d9443c01a7336-2b463c8db7emr113441015ad.12.1776251697718;
        Wed, 15 Apr 2026 04:14:57 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b477fd3724sm19509485ad.0.2026.04.15.04.14.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 04:14:57 -0700 (PDT)
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
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 6/6] mm/mm_init: Fix pageblock migratetype for ZONE_DEVICE compound pages
Date: Wed, 15 Apr 2026 19:14:12 +0800
Message-Id: <20260415111412.1003526-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260415111412.1003526-1-songmuchun@bytedance.com>
References: <20260415111412.1003526-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0E112140002
X-Stat-Signature: 38961xu6jyf1bcdcyczmauugceyfndyh
X-HE-Tag: 1776251698-451662
X-HE-Meta: U2FsdGVkX1/nJv5mhvY+SWhKL0U1APLBMXhY3T1GUv40Y5IUG4mjKn1j/PeTGMYpNNMismNHHciQISDfsiizUaHzmfFy5AuS9frmByv2ApeLHQfvD3C6q+r1jjd48XIB106FjIiFULzqVfOA0+zHGx6eRstZ4IFmjFddNmrXaCRia+oFS6WV1r6Nnl3UA+BSMpovbApRvAKZjzx5YpBjr6S+rcO6k+BPuuklnADrns23CU9CwH+P9JewffnIFEXSjxVfdnPvaf/jFhuSfmD6OLGgIpCWyuAZMaCBSTQ22ROYwRTlfgLXSaATl3+ZLesBGovu0hwnfS/vJ4NnCG31IfWSCki9DYsFTHaXIfzP3RNhkA573pQEbvkJQ1carOL9+yn0PQu2EOADWxf5hDd90GyHK3KmXlrQx8zm6pX+qmboRtbnfwFPATcKLQGTKAa5Ldyoz5RjAQqSkPZJUws1QrET+2bulYYkMNAYwjnQ7YsnHtS9BkLrxO6iliRHnZbkcdnhfvlfw4Kt/l+vX2AjcH2q8AkHADPyDWnynohrLkv3QvyiTdwxTDZ0fxiz6eq6M3x/uG/p1Do0SsDCXmzptfnLaKQfRGSgPs776uyycYeC+6U1dGpBLb3JO6Fk/I7EXWhRFhbkahoHzdvAbLoZ4vMEJ25SoMNB7Hwes+kA4L6auFpLTqxlfyghpO3BdSPasaWjhUDDEgHWAdjPy7ESUxbGj6Qhv6WN2h1UVzNT2td2ZnJYpvnwY53w7KHlorIRlZYI0c/9sNxpvfptZQ5AJbZ8nq8PDAaWQl4Y9HK+TtRTeoMbVkxNgJLhkLqy2Br4Qc16HiQmJkC5pJQu8CMgdx6qwZZWhklOtWJiL7lxwVV266W0AZJ6eOFkM4TWz5g0rhAhebxBjAlJQg6w5V3oDDSglPAbafB+5Km1rGmT++Asmxsjgz0DUdwPv2BdnCff/BVIJg0RzasS3F4t8sv
 /sbXdJwM
 MISTIygyu2Xsee/GnaRjBHTB71yDWMkT/CvqkZLVtOHn88vJkqhl4088V509DGDSV4bjt3X7WiEo+WscITo0ZjWunE9W3xXoB0deYqJiuuEMPj3x6MnF4RK7HasdCAIfTwQv2FZE6+gn2Lky8jm2mtXYkgulsaUoxY/mtjydzpF9rVR7/UzmAD1lyjZ4GS7LTRh6wrO/L+nZRFkH+TTqZEPnvo7ue0Dl5Xx+H5ffXmPu/KYmcngUp45Vljy4B06IvylikI6PKCy1z3MH5F0Hdk2EAe2v0g0w+Affdimp/GqDjyOexTijecjzCTTfvcpjX/8RjLJmJesZ+8M8nbLF0viiVDlLP4B2jPXTEeIckazQKI4A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memmap_init_zone_device() function only initializes the migratetype
of the first pageblock of a compound page. If the compound page size
exceeds pageblock_nr_pages (e.g., 1GB hugepages with 2MB pageblocks),
subsequent pageblocks in the compound page remain uninitialized.

Move the migratetype initialization out of __init_zone_device_page()
and into a separate pageblock_migratetype_init_range() function. This
iterates over the entire PFN range of the memory, ensuring that all
pageblocks are correctly initialized.

Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for compound pages")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c | 42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..30528c4206c1 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -674,6 +674,19 @@ static inline void fixup_hashdist(void)
 static inline void fixup_hashdist(void) {}
 #endif /* CONFIG_NUMA */
 
+static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
+						       unsigned long nr_pages,
+						       int migratetype)
+{
+	unsigned long end = pfn + nr_pages;
+
+	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
+		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
+		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
+			cond_resched();
+	}
+}
+
 /*
  * Initialize a reserved page unconditionally, finding its zone first.
  */
@@ -1011,21 +1024,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	page_folio(page)->pgmap = pgmap;
 	page->zone_device_data = NULL;
 
-	/*
-	 * Mark the block movable so that blocks are reserved for
-	 * movable at startup. This will force kernel allocations
-	 * to reserve their blocks rather than leaking throughout
-	 * the address space during boot when many long-lived
-	 * kernel allocations are made.
-	 *
-	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
-	 * because this is done early in section_activate()
-	 */
-	if (pageblock_aligned(pfn)) {
-		init_pageblock_migratetype(page, MIGRATE_MOVABLE, false);
-		cond_resched();
-	}
-
 	/*
 	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
 	 * directly to the driver page allocator which will set the page count
@@ -1122,6 +1120,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 
 		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
 
+		cond_resched();
+
 		if (pfns_per_compound == 1)
 			continue;
 
@@ -1129,6 +1129,18 @@ void __ref memmap_init_zone_device(struct zone *zone,
 				     compound_nr_pages(altmap, pgmap));
 	}
 
+	/*
+	 * Mark the block movable so that blocks are reserved for
+	 * movable at startup. This will force kernel allocations
+	 * to reserve their blocks rather than leaking throughout
+	 * the address space during boot when many long-lived
+	 * kernel allocations are made.
+	 *
+	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
+	 * because this is done early in section_activate()
+	 */
+	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
+
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
 }
-- 
2.20.1


