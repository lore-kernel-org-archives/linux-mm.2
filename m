Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D48F6CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:10:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498CE6B00D6; Wed, 13 May 2026 09:10:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46FDF6B00D7; Wed, 13 May 2026 09:10:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3861A6B00D8; Wed, 13 May 2026 09:10:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2762E6B00D6
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:10:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D70AF8EAC2
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:48 +0000 (UTC)
X-FDA: 84762431376.02.22AD668
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id E6FE516000D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eUNnSqBp;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K6tm8+Tn6qMHHNbiluBNgNTiouQaD7hYoUCXgTq5wuU=;
	b=A/uqp7ftqseBrpSfGebvw64zLKR4zN/yr5322CWFZeryq/TORctb9shq2nyjU/W+0QAxDE
	qPGSge3IzI5uO3Wpw3BXX4/KOvaJkR8YkuZtX0igxN1+kUuQjAoijSf+DtzeD2o+f8M0Z9
	bD4cvAF6vcJrFIImKgEMZDsjH7kYnNY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=eUNnSqBp;
	spf=pass (imf08.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677847; a=rsa-sha256;
	cv=none;
	b=y3eMrp6OWLVc5MPlTSS4fQO7ljA+fDEFb2cR9/oYPlNNcy69FjmhqCpVWYexQwaBdXVt4A
	CXbJBja34hdxuWZfZeJHmlIEoRpVfIkk8mO5sGNKRhV/Vy128CdhC3tQjC++i1n5nFCjq+
	0/JUTmdXpt00FdjfVzeexJL/sZKeLx0=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2bcd730e090so24820625ad.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677846; x=1779282646; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K6tm8+Tn6qMHHNbiluBNgNTiouQaD7hYoUCXgTq5wuU=;
        b=eUNnSqBpf/DpcIifCYRl+DRe6yzrSSOzpsN/NRfSagePfII9Nqajazlr1l42CZXebw
         i8+GT8hPG6Y10hNmSELNYIae35Wm84txDZRsS7q022/KKMo/F9k5jCgA51hVeBKDo4AX
         SW81vgsJXcgOD0nr3MW9j8AbJwevg8Mnn5cuTsQoXvce69n0A0dejpJwBhSwPB+ILuq/
         ZrX/iBmlieu3mtjNN1uRn+qwWaemCLWGPZNBSZvgCti7Xk2TroocsP1NeM/ny+ZwxPWG
         hD7Ee9KCdrh6YHq63KOncF6By9sEIrFSPnnLosCaCQhrW9TSyImDiiqFzDvyPBzQKM+i
         y4qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677846; x=1779282646;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K6tm8+Tn6qMHHNbiluBNgNTiouQaD7hYoUCXgTq5wuU=;
        b=sPGJo+7wGxAgUkiQ7qxM/mfQrYJtZDq/2NZTAAbuUMOrDsWakzUWJ2SXg4Ecd8BbbZ
         NDIOseBT2Ey3KMezoRleBhDxm3NxhPTc/wlw5ZUbGrefbAzEmJtcDvObPd3bbX2Ii+R8
         xhvjRF4ZbOhF+E/tH/xwkJV/ZuJRbGt/mwGGpf6T3Ll79KQCsDDI9P20Bq8EgtnsbFCq
         xKxUlJLuG+DveSbDB4SXX2SUwAaOm+9+/iH1KCJNxRFntPtbYOhZsmsUFIKv6ycNF8+D
         y2okXS+fBEoJQOAkcoCnvWXy65XnUZ77m2PsPF0jgf03FrakcDwQno+291EOh7CIbLw/
         /bJw==
X-Forwarded-Encrypted: i=1; AFNElJ8uPP2g+0f5MRKorjR42rTt3wFaLo9GRijROhME7MQkG4SP9kBNHXh7XrKVZ+SK0nUpNKkhXzslrg==@kvack.org
X-Gm-Message-State: AOJu0YxCoOlAcPuOWk6NaM5Rwv/hbMh5/O2+IwDsZQEzy1R4H5skUABm
	588eB96SpORxBHN/4C3T0HWPsKkatcLx3w2zLNxC9UJo6YZSXBlsUba55wDRZmgSbB8=
X-Gm-Gg: Acq92OEB9FnMNdtSOZXOKVEyDM0JbGqroWDk/celTYC42m5D1x5rNkYVUYDYQwnEg7x
	GNDgoCPjM69aJATya3L/QYF5tuewq34+ZMcX0mTq6LLki7auBCs9Nk1vzbFMKrArLKYZ6R4MEC6
	V/ajZ2T44ZMS8nRBpcC4b6UumQBNIiEP9DwT2R6mUZoP+M94Kg9LP8OJaUReKhxOM+wmsIe4wxW
	uiBPO2AagmCj+qcYw/2buuDlMnizT8T4WpxL2Agr1j7U1SaK7Rp1Vfv60NOCYW1MBF5zDdQizbz
	bn/SKAXglOksoZ1l6IutvR/bW8MtjITAG+fSGC+heEZut4l9857L/pnvizvLrUvGZqC0eT6HkpW
	cFrtiTtAhrhz6rDXIv2wZFQytaUKUVLEnpWDQoYqfYiqIGxiiMuqTr71eyx/mFHACcMh+Npved3
	WvFGQZZUpxQ37muhMyI06j1fSHWMZXkn6EripzrYOgvei6dwi8FoDlwmfp3So=
X-Received: by 2002:a17:902:d584:b0:2b0:ac1e:9720 with SMTP id d9443c01a7336-2bd30210d95mr31196025ad.23.1778677845712;
        Wed, 13 May 2026 06:10:45 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.10.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:10:45 -0700 (PDT)
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
Subject: [PATCH v2 35/69] mm/hugetlb: Remove HUGE_BOOTMEM_HVO
Date: Wed, 13 May 2026 21:05:03 +0800
Message-ID: <20260513130542.35604-36-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E6FE516000D
X-Stat-Signature: 8zygn5bajfuu9ogsjiwrynrbmpd66uh6
X-HE-Tag: 1778677846-829018
X-HE-Meta: U2FsdGVkX19vjxJKWviv7MU7N9TDD3213XFInrs7A1YRiOjYWxRM14m/3I83EL0syoELT4EKVOeZ0WFkWiKNvueVgrSim9mdNfdyHUCMpUr2VptcNEOym2TeC/yEYl4pn9EO8/ulmT6MdIF3VuTo/gskq4H7DPSopAghd9WGqJmdvSJZPwyntYjT5Kc2AdA0wb4Q7KegQwMFHKttzBsmhHgELaA6nh2MnHSiUZphcn1izozp2gJz9iBbRQ2X7vQ9CjAm13C4jhACTdhSWxXYfBO7vY9pnwJtDCLYF6cU2fgW7M+QR1Tk+B6OVNT+GnfPstQNQ6tkVJsEZsXX2XyNWL7zJe2+UiEF2oHsi6JQ3Yy+N7sxhuvYm80/sNhkA4vIrh7NAdlUVHQtPKrxnWkSuoep/bUWNvbEVtx2lj+/wVoU6rIKvy/jFHY2X4IVvuv0Fnqeq93Rh0U66T3ZbGfmJnWaMgWZQwJM2tsjPakXomjCOlCsUMxwYvJlK35Xm85yH9CC+H5S4j/gfmREmGvwcLF0VjTWtKeKDUWTZXoDwCqFpSeY1+E6+v0ye/yLCDQZulhrPDY94EI1c2vWIElsLYe1CTRZFEtzMno62aWMkiSgdbpuh+KF/10Z349SYDn+YDuc26+O7idkqEmpJkguX742PmzawBxDW/tpLk3VKU83ei3YezFjp7MzD1lwvtljdc3rm/oAjtNZO3lhtTqpvBKGKwt2irFX05fTdX0okmfpZ2wKFAM+t9u3knwm9omFV41DrdaCP+jjtzTee85b43YJQinkfaMlpc+yYBZd/mn9shU8nS5WczBwMHT2+KLmC01G8JtnbBaA8ky0zwZcNIDI50NnbL0+fDAExeI9/QIPKsPFVGJK100OKw1OZExj/Lls6MWdqQ58iWZZKZZc045ZgBoYNClcCr9hC1kWXMV9Sn2Ia1pR+kZO2n5IEIPuB1SlEeaMdc9kH5E+VH4
 YarjnzIn
 ESSFrDcY9rxPhJNsWJ+Z1hjpC/bhSWtFhy5IRtT/HoYSGG6LYyUr05l8HzjnY+PqsnKU80eArkhTuWxhERVNZt2BaUUMaT3brP92Pef6QthTelGFDKRu15fOXtp9XenbfZbKpHBc3ToIC6MOc8j4eTakvfJJDrRI5JZzwtxJr4UIwAqzAgbxEtTVfCmGrJybFS49T/0flyamdbSfnuPaJpVXnPib+x6CUFTewfjQvdMgshZUS3duq5hOVwWpxpX/HyBX+UXYkpOIs3HzmJpXpCIPaJgj3B7JBoW9ibuEH5R7Q/Q+Ksl4oTFTCM0qlUPh/i2oki1r98hAAHvl5ZViEpb20Hblzj5RmBbHNb/2Y2x9f161MXIwcVOctWaV3V8MZTmjA5XJIkH/o8wQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HUGE_BOOTMEM_HVO flag tracked whether a bootmem huge page had
already gone through the old early vmemmap optimization path.

Now that HugeTLB uses section-based vmemmap optimization, that state is
already reflected in the section order.

Remove HUGE_BOOTMEM_HVO and its helper, and use the section state
directly when deciding whether to mark a folio as vmemmap-optimized.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/hugetlb.h |  5 ++---
 include/linux/mmzone.h  |  7 ++++++-
 mm/hugetlb.c            | 12 +-----------
 mm/hugetlb_vmemmap.c    |  2 --
 4 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index dce8969961ea..18af8f304b95 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -695,9 +695,8 @@ struct huge_bootmem_page {
 	unsigned long flags;
 };
 
-#define HUGE_BOOTMEM_HVO		0x0001
-#define HUGE_BOOTMEM_ZONES_VALID	0x0002
-#define HUGE_BOOTMEM_CMA		0x0004
+#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
+#define HUGE_BOOTMEM_CMA		BIT(1)
 
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index a60fd5785fa5..9b87d798a365 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -117,6 +117,11 @@
 #define NR_OPTIMIZABLE_FOLIO_ORDERS		\
 	(__NR_OPTIMIZABLE_FOLIO_ORDERS > 0 ? __NR_OPTIMIZABLE_FOLIO_ORDERS : 0)
 
+static inline bool order_vmemmap_optimizable(unsigned int order)
+{
+	return order >= OPTIMIZABLE_FOLIO_MIN_ORDER;
+}
+
 enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
@@ -2262,7 +2267,7 @@ static inline bool section_vmemmap_optimizable(const struct mem_section *section
 	if (!is_power_of_2(sizeof(struct page)))
 		return false;
 
-	return section_order(section) >= OPTIMIZABLE_FOLIO_MIN_ORDER;
+	return order_vmemmap_optimizable(section_order(section));
 }
 
 #ifndef CONFIG_HAVE_ARCH_PFN_VALID
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 080f130017e3..abd79bb85b1c 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3169,11 +3169,6 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
-static bool __init hugetlb_bootmem_page_prehvo(struct huge_bootmem_page *m)
-{
-	return m->flags & HUGE_BOOTMEM_HVO;
-}
-
 static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
 {
 	return m->flags & HUGE_BOOTMEM_CMA;
@@ -3265,12 +3260,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 					   OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES);
 		init_new_hugetlb_folio(folio);
 
-		if (hugetlb_bootmem_page_prehvo(m)) {
-			/*
-			 * If pre-HVO was done, just set the
-			 * flag, the HVO code will then skip
-			 * this folio.
-			 */
+		if (order_vmemmap_optimizable(pfn_to_section_order(folio_pfn(folio)))) {
 			folio_set_hugetlb_vmemmap_optimized(folio);
 			section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 		}
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 730190390ba9..66362e553870 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -718,8 +718,6 @@ void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
 		return;
 
 	section_set_order_range(pfn, pages_per_huge_page(h), huge_page_order(h));
-	if (section_vmemmap_optimizable(__pfn_to_section(pfn)))
-		m->flags |= HUGE_BOOTMEM_HVO;
 }
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
-- 
2.54.0


