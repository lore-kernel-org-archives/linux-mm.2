Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF7FCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:10:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F35E6B00CB; Wed, 13 May 2026 09:10:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9D66B00CD; Wed, 13 May 2026 09:10:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0986B00CE; Wed, 13 May 2026 09:10:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C6216B00CB
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:10:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26BCAC2846
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:11 +0000 (UTC)
X-FDA: 84762429822.17.8607B9A
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3C68E1C0014
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:10:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PPm5rbMy;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wj09+T2FktkdLwU79u80MiVhyJiQtKDMnM2x4Hjwdtg=;
	b=6Li0a4xFTs0d0QhKmWmZKbV0yEmdtrreQ6ecBOgvPaUcLkcrYvoR8FPaKqoGfIslJxOQMU
	9XQpP8oi8VG6mv477C4g5qTQrXwhTOjqp0uyKKR3pDVk2cR5xdtER1dMk3xQWgEdr3DsEp
	bHtseNuVrhBOqG+qXcCNgcYKaLhlIr0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=PPm5rbMy;
	spf=pass (imf18.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677809; a=rsa-sha256;
	cv=none;
	b=n2qVABN7kZKUwV3z0DpqU31vfA+BBkhhGFfCWu8y1muCeK8NPB5bNA7zZcOj0bojh9MiM6
	X9NWJtZTkuEc5STyPRwMyEHW7zkTBIO6cPX0REmWtev0nXLNDKPXc/I8tx3mDWG2mMUPEk
	1O3oKWHdXAuSxRh24udrV9xtaCv5hB4=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2bccb978bd9so18879185ad.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677808; x=1779282608; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wj09+T2FktkdLwU79u80MiVhyJiQtKDMnM2x4Hjwdtg=;
        b=PPm5rbMy9OgEkOxJTM+TWDWnZC3QiwNZRVJazI+Utz/A3+hWC79aduWfQBu4hyFJwm
         nocOaBwledNTXJxpJqtz1GOTWtRaVlXnaqroMrLGVgY+NpHFbo8owUHfNQlPrOO890Pr
         fm48c49gSiI/mHwvMgcVAOlNhjKoijBtCKdwA5ctyBvvPmz0HGzC/SmhOFMX9m9t5cby
         t6Nr1QZgFyvq8IZO6hO+iUh7bnziY+5oXHhWQsfNOs3boqeCzGoSvA5Ik10WnwPZl6/Z
         K1KWcBHsMntwFLx2LGxjjD3kXaCXKGtah4TOmco7mI0FDOeyYOsXao/0H970jC3ojXHb
         0o3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677808; x=1779282608;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wj09+T2FktkdLwU79u80MiVhyJiQtKDMnM2x4Hjwdtg=;
        b=YLW180b92XCdie3QQUpGu94FUq4+T4sjTTB4skXgRuhcbHW8NH5HHWOVcUuI4q6/bj
         bwUuTXHr0PAxrPoALJG5hqVd6G6gmDQV8qvyU/VYUGxqB0/erFads60+4tIg6rFuMSIy
         S+UPZOlzQuHNwp4msmox0nNTod+8rZW/0KnKBNl6Be9sz+VYZPgK0Hi4we+/gsJl8Nhf
         3hLzuyCA7sOVwGohlCruKmFKEZG42vRzNfJZ9YtQvkvRu6SH/ny9+tMnNQV1LKvS+qCI
         IZaa4DvCohproq6jUo37WNyqR+IXx7J9M6NLuEQHzBUkFtp29MVjDXHi+S5EwaOSz2Ae
         xsAQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Vbb/HIfVlmdUHe4FMWLYZF7oyy0BwSF+NIpBKPDX9DzSvMedSooAYtNF/UMCqMmb8J2AYxJCQRg==@kvack.org
X-Gm-Message-State: AOJu0YxzY5U6/zjMMn66mQVvTyKOnohRgUwbfjaQNh2k8yQFbJll60HN
	4eXVluLKQx/Bbs71NbOKO4O+yFj3CktdWAtbtRzQ/wF6l8iRUSioov1PptnEp4zprlU=
X-Gm-Gg: Acq92OFY1Tu1/6mKiyesEH6phJ4tTUbeMl+OKuhzawFdkj5sNwX46M9XDN6SxqLTAo3
	vovev1gGOqagTMPIUszwLCsNaJFEtBL68+g4w4XvoxzOFU+5VV8sHz5syM4NiuUk7LOOrR5CzsL
	UXru+dFHn+EQE+RnBWOTN38/vUrF2M+/O1hrSo4/ly4VtC0w/Trj+EF3tc5HtRfKrR0ho1kfgpf
	+Hxl2zbrbrOHsVUMCHhFcUcoaQCJI7FSyPsZ1MrbPUv9eTzmHMHgQcTQniAW+lS9gow0Cy5rh0o
	B4JfqxlpCi8sNg//0anmqNXICbR+nPrKq6ruNNdJKciybav5N8NBdavhhG7R5rY/udAs0+sEPYA
	4k6QDtcVq+4AT98w6FNXqwmRpR79fRhVXe8C7EVx9HZZOltCspB13KxL91XOd7cJ6aXYw8qyRN9
	dBUi9f7rzSocTfeAhziyN+ZWy6VVxe3ektL9zRGtw/xPD/aCrZEwwGGzxSSPQFgtfYZi1KLw==
X-Received: by 2002:a17:902:b713:b0:2b0:6068:4c5f with SMTP id d9443c01a7336-2bcfcc3ce55mr52172605ad.8.1778677807808;
        Wed, 13 May 2026 06:10:07 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.10.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:10:07 -0700 (PDT)
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
Subject: [PATCH v2 28/69] mm/hugetlb: Use generic vmemmap optimization macros
Date: Wed, 13 May 2026 21:04:56 +0800
Message-ID: <20260513130542.35604-29-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: daibukqha6z94h7ywcdwu9ry9rmomtsf
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3C68E1C0014
X-Rspam-User: 
X-HE-Tag: 1778677809-70488
X-HE-Meta: U2FsdGVkX1+RVB0UEdG8M8nCf/8lNZGJFwQXPnzsjEX/awbTSLQhy+rYAWGKHlgzTb3WrvN6Z8VWPx1KOvwrtLeievent5LxQ1xiIJw4QIj+nE+MYRSYISGriQWqN5VsSvbvlKS/ezY3NCJ850a1lgDgi3D7YHMY0vsMx0hzISqM9XsqdAjFiTgH8DSzZ94rCRYc3PL2wrCwG8JCbPyQ/19K3X++tM0JzZq5GUAfSirs7qRykj8NpkH6KkGwnfoQ7FWUg0x0QHLotcM5MyQ6dOWQbK0pU/uCm+gIRN02YI2cvgdaXT63UthCGdRuUQXNnlbTZw5UsbwCpsS3cjbdf9rmvirwnUTMnVLxfbCKmMCldxPlDj//LA9bCggqRBXAdPHQkzIo/27Iy4SlLgMPnsg2U8zc88OkKX0ps5YyrQG+l+3LwqDigGhg/LCLisDuGNHxYqKlgjEf3+T5ErSkT7934hhz7c4ukDnjgpuI6pefA2d/OAtySx+D0oVuVbcObuHVPvjA/zG7SOrwM2CklIzt9ocsdN97feeuoilnBS5NsdUfiUFQw+zJNzzMAZtuLXwNJ15vrOLjHFmPQFg1AY7fmXSvzbeW2xrvep4wvnksiNOEUkFhleIJnDzfHLActa0z/0LtQVgvb+iK0LyjAUzRuaW/2i2SyRHqJrzutyDmwHpaU8DX3PA19RyTPIBN9+Zu0mKFs9P0uQ9lwrKdT3OfYEwqVU2TGXRAU0IDbsFBDN322VAYq3xZd3+/dnh+Vm+HT3iAfhhaEtIbdMPT7c0KK4yYsJ2jgHS8NENMGufer7YjzOtvWfatbLU+0m57ak156WqnCh/befjxSIc5HLrB7/NEWhRZ58p6umYayUavFEHm8B0aIbJbpaHCLhKaICKGfYx9aL8hHoHQSF/bbhZurA/EqoKD6aiPelQr0jg2yOLvM8ZApx48FB0ltHhkM3eoDYiE3/aU/iKBfvg
 XdtBKvAV
 31XL0HFn+LCzzx3rJy6CvSyTpQhGnOkKFVz22oMelyrkF4dRwRMmCpo9wHRvqTMvYTXv4ywhK0Owialm0k9slGLDrmfM0CMkdCFulKXHAYaMnOPbW2SEPXcmBRf+SzJE6heI3JKS7gTpLRr1+mP1zzGo5QUHuSSVYlYtUoxIC/W2seMfb2fBxVFpee9YKOUmJyo6YwPqNcvkJnznQ+zr7+XUmU/WBctEFvpYyDyEI7gjevO7CoOE75/t9dk99EQXnqYc6IM0oHUcaYGk9rnkYZKpG7Kb6DsxWoPgzqgoeGToNRsF+7dwTX15r/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vmemmap optimization is no longer hugetlb-specific, so the remaining
hugetlb-local reserve macros are redundant.

Replace them with the generic definitions to remove duplication and keep
the hugetlb vmemmap code aligned with the common optimization macros.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c         |  4 ++--
 mm/hugetlb_vmemmap.c | 14 +++++++-------
 mm/hugetlb_vmemmap.h |  9 +--------
 3 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 53448b05ca11..8debe5c5abce 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3222,7 +3222,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 			 * be no contention.
 			 */
 			hugetlb_folio_init_tail_vmemmap(folio, h,
-					HUGETLB_VMEMMAP_RESERVE_PAGES,
+					OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES,
 					pages_per_huge_page(h));
 		}
 		hugetlb_bootmem_init_migratetype(folio, h);
@@ -3261,7 +3261,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 		WARN_ON(folio_ref_count(folio) != 1);
 
 		hugetlb_folio_init_vmemmap(folio, h,
-					   HUGETLB_VMEMMAP_RESERVE_PAGES);
+					   OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES);
 		init_new_hugetlb_folio(folio);
 
 		if (hugetlb_bootmem_page_prehvo(m))
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index e9906d32a64c..4367118f8f57 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -407,7 +407,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
-	vmemmap_start	+= HUGETLB_VMEMMAP_RESERVE_SIZE;
+	vmemmap_start	+= OPTIMIZED_FOLIO_VMEMMAP_SIZE;
 
 	/*
 	 * The pages which the vmemmap virtual address range [@vmemmap_start,
@@ -637,10 +637,10 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 			spfn = (unsigned long)&folio->page;
 			epfn = spfn + hugetlb_vmemmap_size(h);
 			vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio),
-					HUGETLB_VMEMMAP_RESERVE_SIZE);
+					OPTIMIZED_FOLIO_VMEMMAP_SIZE);
 			register_page_bootmem_memmap(pfn_to_section_nr(folio_pfn(folio)),
 					&folio->page,
-					HUGETLB_VMEMMAP_RESERVE_PAGES);
+					OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES);
 			continue;
 		}
 
@@ -779,9 +779,9 @@ void __init hugetlb_vmemmap_init_early(int nid)
 		zone = pfn_to_zone(nid, pfn);
 
 		if (vmemmap_populate_hvo(start, end, huge_page_order(m->hstate),
-					 zone, HUGETLB_VMEMMAP_RESERVE_SIZE))
+					 zone, OPTIMIZED_FOLIO_VMEMMAP_SIZE))
 			panic("Failed to allocate memmap for HugeTLB page\n");
-		memmap_boot_pages_add(DIV_ROUND_UP(HUGETLB_VMEMMAP_RESERVE_SIZE, PAGE_SIZE));
+		memmap_boot_pages_add(OPTIMIZED_FOLIO_VMEMMAP_PAGES);
 
 		pnum = pfn_to_section_nr(pfn);
 		ns = psize / section_size;
@@ -826,8 +826,8 @@ static int __init hugetlb_vmemmap_init(void)
 {
 	const struct hstate *h;
 
-	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
-	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
+	/* OPTIMIZED_FOLIO_VMEMMAP_SIZE should cover all used struct pages */
+	BUILD_BUG_ON(__NR_USED_SUBPAGE > OPTIMIZED_FOLIO_VMEMMAP_NR_STRUCT_PAGES);
 
 	for_each_hstate(h) {
 		if (hugetlb_vmemmap_optimizable(h)) {
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 7ac49c52457d..66e11893d076 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -12,13 +12,6 @@
 #include <linux/io.h>
 #include <linux/memblock.h>
 
-/*
- * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
- * Documentation/mm/vmemmap_dedup.rst.
- */
-#define HUGETLB_VMEMMAP_RESERVE_SIZE	PAGE_SIZE
-#define HUGETLB_VMEMMAP_RESERVE_PAGES	(HUGETLB_VMEMMAP_RESERVE_SIZE / sizeof(struct page))
-
 #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
 int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
 long hugetlb_vmemmap_restore_folios(const struct hstate *h,
@@ -43,7 +36,7 @@ static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
  */
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
-	int size = hugetlb_vmemmap_size(h) - HUGETLB_VMEMMAP_RESERVE_SIZE;
+	int size = hugetlb_vmemmap_size(h) - OPTIMIZED_FOLIO_VMEMMAP_SIZE;
 
 	if (!is_power_of_2(sizeof(struct page)))
 		return 0;
-- 
2.54.0


