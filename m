Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2216C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:32:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAD286B00A0; Mon, 20 Jul 2026 05:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D849A6B00A1; Mon, 20 Jul 2026 05:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A776B00A2; Mon, 20 Jul 2026 05:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9764C6B00A0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:32:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C72A160522
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:15 +0000 (UTC)
X-FDA: 85008639030.25.7F175CE
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf31.hostedemail.com (Postfix) with ESMTP id 321BF20002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:32:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YePxWT82;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s6zsu4ImsI5QIEzL19H+gxsmGfblKWRGuAokU/tHqk0=;
	b=Ln0vyZjaZy4XBBOhoM6gnCMeUzk5oVW9e7WatCjJPD4+/J7JfrVOlwq8/Ru+2V2SCnXZik
	elcgvLmXO7l3ZFtXpNp0b6mtcvkAwSAKAg8ngt5nFs6iFkJs/TleoYie510ZwRoxhaMSVz
	rijWoU2tXOxY3sO4zzSLqxIuknzQQKc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YePxWT82;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539933;
	b=WgM9v2Uql9FJKukJr5QrakdDuPPW0x/vGaVOVvEIicxuQu9hwyMEEdf+kgfEWI/q/OmhiA
	Hou/cwxRSypXyi7xfAEUoJZShW/kiu/ndhSzwQuhyfEkDTqnly/S3lIVtctoYFwaK/uYKB
	wJYgtGvAqjLEwaeBhyhAEMhBWBQaqek=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cacf197759so107869565ad.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784539932; x=1785144732; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s6zsu4ImsI5QIEzL19H+gxsmGfblKWRGuAokU/tHqk0=;
        b=YePxWT820DZL7dG8xfMFqpWwpPV8GVgYxKpg4QeZZp0yxq31b/sSBEaxzOlTJltHSK
         tw0DamPy2ANFj/+tb2jk8BMDJ+bsPqW0NuruZ3sBfYKO7ilrLavpTbVJn6J4iDy8qFXx
         0W/+w6FcbM5TxuLPWyuv5RqJb7v5QRGwBn+fjjCzNxn3VkvLvMG5aUsnB03U5kW2mfRN
         634uwbQJ5VJUfvXbf439FcTTCTUdFOtBFcSYjtJiHerCFIpdbfkcJG/31fUwxY1dosF9
         y8B9IZ5s181jxKo0Bt20sh6jpIcLLuRqwlkSIqKNnnStkk7yulxxTMVIU8aK0Wri5nUJ
         zpRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539932; x=1785144732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s6zsu4ImsI5QIEzL19H+gxsmGfblKWRGuAokU/tHqk0=;
        b=O43eBxlgqE5pnabZz9QhX7FdWYPW2Amtxlww2VtRWcFfMvFSItxo9vZVXk0AIpogBG
         TU3P7QsblyJxbPF8QW1vxMxZYcbJ3M6SXEz7xI4P7L7JRgqc95pQLK+WSdN0A+kD3Nkj
         5OUpWOImF3dbCpYFwWScsptTt7hWFaSIwkEjED0KnS7yZMewMGSlQh3k96y8dPM/efwH
         U/bjhEjuoYAQc7t47dCJ7kf+Bu8HAM0HIwKA6I+CvVQrpiqRpiq51Z7fJZGB5jutGy7P
         aIaeklN2vQsG5JKsUsOyxgHCchRrECUPg4bpLTl0/fQC9dUBltfg+kTRcFc1DNmpnQgB
         a+gw==
X-Forwarded-Encrypted: i=1; AHgh+RpyJ0+FjapbrhZ6o1b1C2urx+WdoN/eYrKTY6m9wzy4KvasZupiBLYZWyTNU8vWHdJIE2usgv9SQA==@kvack.org
X-Gm-Message-State: AOJu0YwLWB5CagAtNyWiWZZNKW52ahVrtIgpE5ZmgYu7DIllY9zPAhVc
	14RgEZUv1iQdDKladf4sh3CKxch+BH6JdMLn1hxYgHMG6TnPur23kCfWpKYNeIdXMP8=
X-Gm-Gg: AfdE7cnkx0TI75Orx9BrEekEwYFBtz1A3EdfdMvWt2p1Ey38aF/IF4fGgVVUO6WjI0a
	HyHzuSw9p4PzvhrVX3msO2MnByt2R55HmuNnw86l9qwol9LPq485FPptO5Z89CJST62QT53KUAd
	K01zlRH3Z6DCO3T6sTca6IICo94qed8RNJaU2BvFhyu0pZyopisSPtoBNE3kqiu/p/M5MyjjrYG
	rpMut5R5KsTryPDQvWZ0BimWI6tGZIE6dj/eV3Kqd4ZfB0GH2N8PchaUUePVyeRxKnpm+Ng9Kzk
	ZoARLX16dm8CbgPKAv9KjfFWlhwEgKz0YenJTWjawjd1PPjaxzaF49syBBYRGncNkCj5mzJJN3L
	Ukg5xM+1M/fYFVBKUQJdEYaWq438MDwtUwxTODSxVN4CknOxR7VObtGuMm4TcPi5FbyNbkk/UD9
	N9fVj6bIuKPRA91AergewPIR8=
X-Received: by 2002:a17:902:e80a:b0:2c9:fc14:588f with SMTP id d9443c01a7336-2cf3494afc3mr147908865ad.29.1784539931402;
        Mon, 20 Jul 2026 02:32:11 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf347a7c9fsm53136455ad.84.2026.07.20.02.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:32:10 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v2 05/17] mm/sparse-vmemmap: support section-based vmemmap accounting
Date: Mon, 20 Jul 2026 17:31:15 +0800
Message-ID: <20260720093127.540540-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720093127.540540-1-songmuchun@bytedance.com>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 321BF20002
X-Stat-Signature: jwxxt6ooj8quwygg5d7qpiodd6pu4gft
X-HE-Tag: 1784539933-214866
X-HE-Meta: U2FsdGVkX1+iQriRmjyU8g7QHiqgvdynzQitjUQNkEYHyw+6+Okp40/oUnxJay9pycml1iZ4OUhR+CdKoj9q+s/TE4ZV71PJDUG7yqFUQE65Ygalws2/jcZ6fqIPczuGBRNRbsTLVLT8f+Xjha9Moj/pe1XlxcRtG4WFIgrakpXGoxSSvd6ZDwB98xNluzFagBvCAOWM9zNadlrKmJkHTnQxcIzJ6hF+dauAombccgZLOJJQXWnll1xXn5dElw4zXlhPIF8doui4nybGbCOr2lryqg1LHIzRujihHS18Lg1M3GQcgksOT8haxjL5FaRisPa/8VDp4oiO4JQWRIqNOMRejSJTOJPrWTKifYM/oI5t0fdMRqZqSt+bvqHbKKcngcPnYP33I6TVF+tiR3bfnf11j2/Oc0PgnORokg1P/yDbg0c7/f56QLLnk38xSG/HUfFGY226x6+Q4oGwNVO3KyFQXXTRHMWYctjhzR+fuxZYcP3snB9OCP5nx50yK3vgq+BMl9eqR92BC6ougxylJWBGWW0JqODtNF5hv2PaOU4s9W6DbUqui3JWJ7feES2GWCInQcxE96mdS7a+moSnq8PC9ODdmY41NilU8Wb+kAAQpUPHC0y945AINAHcCqFmkPpbsf/KIWGAX8EQhwXm9cT1VWxZ3J3iCyWy8/VyhZAvSjh5dj210HhxDwfxqVoiGQRd4qMb0E9jCfXv27MPR9NUXdUf0SuHEP2H0dxGyn2Z4NlDKFCV3t9VQVoRTNeuTZE/8qrkWwzKGRjzFtHAoni6RJQxKTNZoS129ScRDLQsQOSJ7c/rEPKb+3TzNW1UrlvMC18Ul4cWAwZRvmHpKJ/JTQ89i7mkmdv/dbVk9QY1AO2ryXVslFCZzRMVbyAdcWzCWViKc3VqAgfCqZ9Khx2uQQfwnlNSeALh3Gx1fD5LFk+MeA3BhZxYBx4Z3tElggqMQgR5pjWobn6xfgn
 kNDNSGRM
 wJig8zTcDK54zbSp1DOq3A6mXfCUN8Mo3hAc2DV+blRj+bWy4q3kCZBJvF+bcQjHcan+Tw8IfCGAjPcL+lsiSdwedbq8K9LulAHEDNGvTa43x2tpLhtnBb7ixqcyUM0aghO/X1dicQXoguvQUikB++qBkRiPpFNDlN9/0KGu4NgqNgknt8Mmp/kAGZEKA0Uhqf4rFkMikOGQXuo6CxWcbB19WeaIsxt+jf8ABe3WLEE07E0fZFt78IAedqWWKWAXTIcoCJDSpol1osZ2B0Q43Q93WM3c+Aix80JGycWlNi3SGD6c0pHONQIKECsawjmIyVvF2FaHYfUctN3R8m/jQ/mWsMv5+TGdJpotvbU7DMQFUgLQIBqaA4hkrquRlaZXXpOQ42Z/WJONEK4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

section_nr_vmemmap_pages() can account ordinary sections and DAX sections,
but section-based vmemmap optimization keeps its compound order in struct
mem_section and retains a different number of vmemmap pages.

Teach section_nr_vmemmap_pages() to recognize section-based optimized
sections and calculate their vmemmap page count from the section order
and the HVO retained page count.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
Hi Mike,

I reintroduced VMEMMAP_OPTIMIZATION_PAGES (the intermediate macro), which we
discussed removing in v1, so the section-based HVO path doesn't have to
hard-code its retained vmemmap page count (i.e. 1) in section_nr_vmemmap_pages().
To better unify the codebase in the future, the new macro introduced in this patch
will also be applied to the HugeTLB code (e.g., to calculate
HUGETLB_VMEMMAP_RESERVE_SIZE from this new macro as well).

v2:
- Remove an unnecessary vmemmap_can_optimize() call to simplify the code
  (suggested by Mike Rapoport).
- Rewrite the commit message for better understanding.
---
 include/linux/mmzone.h |  6 ++++--
 mm/sparse-vmemmap.c    | 10 ++++++----
 mm/sparse.h            |  8 ++++++++
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 2a32101d55e6..025ea69f57d8 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -107,8 +107,10 @@
 	 is_power_of_2(sizeof(struct page)) ? \
 	 MAX_FOLIO_NR_PAGES * sizeof(struct page) : 0)
 
-/* The number of struct pages covered by the retained vmemmap pages with HVO enabled. */
-#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	(PAGE_SIZE / sizeof(struct page))
+/* The number of retained vmemmap pages with HVO enabled. */
+#define VMEMMAP_OPTIMIZATION_PAGES		1
+#define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	\
+	(VMEMMAP_OPTIMIZATION_PAGES * PAGE_SIZE / sizeof(struct page))
 #define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
 
 #define __VMEMMAP_OPTIMIZATION_NR_ORDERS	\
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 107215cf8488..b7abc5494bb9 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -649,24 +649,26 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
 {
-	const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
+	const struct mem_section *ms = __pfn_to_section(pfn);
+	const int order = pgmap ? pgmap->vmemmap_shift : section_order(ms);
+	const int vmemmap_pages = pgmap ? VMEMMAP_RESERVE_NR : VMEMMAP_OPTIMIZATION_PAGES;
 	const unsigned long pages_per_compound = 1UL << order;
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION));
 	VM_WARN_ON_ONCE(nr_pages > PAGES_PER_SECTION);
 
-	if (!vmemmap_can_optimize(altmap, pgmap))
+	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 
 	if (order < PFN_SECTION_SHIFT) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound));
-		return VMEMMAP_RESERVE_NR * nr_pages / pages_per_compound;
+		return vmemmap_pages * nr_pages / pages_per_compound;
 	}
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SECTION));
 
 	if (IS_ALIGNED(pfn, pages_per_compound))
-		return VMEMMAP_RESERVE_NR;
+		return vmemmap_pages;
 
 	return 0;
 }
diff --git a/mm/sparse.h b/mm/sparse.h
index 030248030dc7..1e9fcea10181 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -74,6 +74,14 @@ static inline bool pfn_vmemmap_optimizable(unsigned long pfn)
 	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
 }
 
+static inline bool section_vmemmap_optimizable(const struct mem_section *section)
+{
+	if (!is_power_of_2(sizeof(struct page)))
+		return false;
+
+	return section_order(section) >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
+}
+
 /*
  * mm/sparse-vmemmap.c
  */
-- 
2.54.0


