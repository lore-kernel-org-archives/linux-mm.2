Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DB24C5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 705AA6B00B8; Wed, 19 Aug 2026 05:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B6646B00B9; Wed, 19 Aug 2026 05:54:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CBA76B00BA; Wed, 19 Aug 2026 05:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C1666B00B8
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:54:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C298F1204AF
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:54:07 +0000 (UTC)
X-FDA: 85117558134.21.80AA793
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id DF7351C0009
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:54:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Mqgvt2CX;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787133245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9VHhccCkICJlyi9ZKauHubucoGPnSLODJt3qpXuHQto=;
	b=Ehm8D0OGtjj1dSLB6WnpVw/dvg35yuDhYe96w04baefVKHxyiVelQB600dg3Y+tBBe5Sij
	zoiXdHONaJAKf8JJ6BAlnbMQQdIYsjAiE08oaDeYyhQSggpJV/bAkHBJ3WWuQupucDk6k7
	+QoB6JT6psRztk/eUzBTu4PAXNkD6Jk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Mqgvt2CX;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787133245;
	b=UkwW2Fy47wrB/6RNRfBS0PUNa+Wi9oXX8TLauIJlvlHh+yM55Bpl9BiiJiFEP+q2QLt/l6
	jTWvV5ZizmJjMV68c3+UHGzTMPSarJDY8+OEEvl5MypyHiZUK56nG7FtGmPuel6tmRqkae
	Yzjf+3bUopp+yZnP02vGQm/jCMA0b8Q=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d530328efbso7256995ad.0
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1787133245; x=1787738045; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9VHhccCkICJlyi9ZKauHubucoGPnSLODJt3qpXuHQto=;
        b=Mqgvt2CXmdiCVYHLSeK15L+NFQOuhnRkArP/nXlb8e41N2NFTL2MgQIw+OrVgVdKwg
         UB99kGjlpDaK+DRBWzGQtQXJIuryF6RLwdnrAeX6tYmzkvNfMjw1j4uK+nVwdykdQvpX
         CPQ++ADa6E3EL3OcG8bfEdNtfRvZtNE3tHcXiqkDFL+DGS4D7RJVmZ9AzhiEzAMRtClW
         372fhl3qJMnfRP6P59r2CIo4Vt4E7EvmlKJ26HA3q5jMCfvlK7onVk/oGGBINPxLgZ5D
         Tof1cgXmM3bXPnoPdXxE5R0zKk3vdIiTVRU4co/4F0WVyStoYfFv+vN6jJaPiW4HJqLa
         aq0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787133245; x=1787738045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9VHhccCkICJlyi9ZKauHubucoGPnSLODJt3qpXuHQto=;
        b=qTKJ210eZXvheTjthJDGN8kfHuUaQgsVf4y7Z2SzoUUW9kXhC4Y/7Hlo/v3poT5j+E
         1pALmTTJXXqPM6mHZCVwPJ2PJ677iYY/vZZ58WPOba3lTlbzVAKwsZ4NlJP5lHvJP7e3
         yGnXJINSo/AomPQF6TW0iDB8l695L7UHATfJvJ5+ELyWTtrExYFKyfhb8b8QS2/canIC
         pUx/xoEDnmIdlX/xRrIQPUrGagTGqAmxMGts37ptB/F4y36qs8zXiPHQZLoiFXjVGb2m
         1WlSYoWhwenyIo4dD+0WWGDUCO3FKz/S5b7KgLA18AQbatx2KmUYSrQC4CumuCrgMj0q
         zsQw==
X-Forwarded-Encrypted: i=1; AHgh+RpLQag2j7CMQWkWdJWtR0ma0L7w7glqqjrow1SPUH/OQ9N93snSTg6yKmelKG2dPE8CNZv6eWaD9w==@kvack.org
X-Gm-Message-State: AFuF++nUsK+0mxpbCJv9Nqn5bPedvGsFIFKczsIivFWt96sQRgmgW94n
	0qfk4lNjp/8Hvs9xZvLFPkWFHzNiwassRrHgphv3svPRqx9cbFg0Fsk7z/eDfshbyAA=
X-Gm-Gg: AR+sD13yg5ZubhTHysAT2vwutRvKsNJt3lee+bLI2fF2Io/ve0KGfN7O4n2LcIaPW6F
	g4yPu1VigyOQ3RaAg19DXLjtjbo9RDiC54UwNrT40iCOod+7LKp21NF8tM6M9OSwA6gbvhQ7YH8
	nx+jnMYjz/odf2r5/uIPd5twmaLnV3N6qMoUGRQMxEEWwCcUqz8Kl19NBMn8ulmcTQSYREdENEa
	Y11I4QTbFNBEbsAqENtRLKDwbzm0gh0I9kW/zBeZ+sF77EoC+tLL7a6tQ0lzv/Nb9BBkn0u5c0N
	QSkCNdQDM7B3XrJV6wQz8AXfCKKLzZvylRe/q+3bicxOzoJcXNIq4TMdj3ETXzuEevCBXzMTijJ
	QUCwk2YhYHaPgtWmpcVur7Wd7+Qagti5WdUl196yslmtMRUrZHNsF2BKjo9leKGf0pSDvVbNkSZ
	5HpqzUB3c54aQz+Uq6fqaE+Q7FsLokAZ8IeejodxMdRi2JZvAWgSvuk/Vqzun8WjZAkmHiLIoVM
	DlRgPAEQbU5b2XRxamcohwwHockVFk=
X-Received: by 2002:a17:902:e5c5:b0:2c9:e9db:8167 with SMTP id d9443c01a7336-2d601860803mr57208225ad.7.1787133243476;
        Wed, 19 Aug 2026 02:54:03 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e5434esm22504235ad.51.2026.08.19.02.53.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 19 Aug 2026 02:54:02 -0700 (PDT)
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
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v4 16/17] mm/hugetlb: localize struct huge_bootmem_page
Date: Wed, 19 Aug 2026 17:51:38 +0800
Message-ID: <20260819095140.17252-17-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260819095140.17252-1-songmuchun@bytedance.com>
References: <20260819095140.17252-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DF7351C0009
X-Stat-Signature: ot3tmt7riicro6i57yf5gj936qho4wrt
X-Rspam-User: 
X-HE-Tag: 1787133245-658039
X-HE-Meta: U2FsdGVkX1+GioMOPBhfC3mb3PZTKe3BnQ2lGjVd7aV4vMvUB/GL2ID1DHYK6qieaMmreKdk7K4LwbI10CYXOU8BKo4Zm/txF35A3OXMU3Zj6yyBKSthQrAXj5Xajpx7gpZcD3my3n1k3MVUam24wDeF1uOUkVdAl1lXBlVjsQEynqGBp2bhpMgmFjXJG4Y3Nce2OeuzZNupvh9r4bskz01WA77pRLVPam6/Us221cFKJ4rFFM3a9zm+hDzB0rBeqhYgUo/pG62ZDWclWLv/eX40jDR3F35J0KiTMfs7lXjvc6S9KMANLk8IHHkI2jYdwPPoEg3GhlxJu/jC/TOtCtYOhkNl9wpUMqdydAbTJokJSELznVl2f4D+EmLtBA3K6aX9ti/6zQV6wOiWNMDJaVbTnSUi/JVavErKabZzkkogp8wdzJFNJnZsKnTkaYCi7qrKtIIrWVEdMV6YTU+/+C2VHoixL+liPDT3ePiaXnWSvfQ0hDRrXoBCxml9ZOugE9sJqEmN22GtmZHqkeGsi+PRiM4QXMqtCqaO7T0wJvG2vZnOgIfkzk552DsZ77IWIaR8l5YeP5OX0bH4QIgzyp+vYZRk+6eIUe3poJd/xkaqO25tlAUqVXs+Rb2O5l2YbP+Rqf5SZo7dj6zPlTgOprOMhtG6xDjTLuQSFmWmRlEI2+WS5b89Y/jqFB6/x5/5f+13swjysECqtbtdNhCX+PVVBYQ7sbPJL760lQY6aDgDLLea6vpxqkIu7IkcaFRukshYcbz1YeSc/KH6AW12hjDQjAioEfwGg6cy/A+dYNdORYRoOpP8B/tDvdODVw8J0+mCcl4hpgB4i21kzSGqZ9k+Cvyk0Pe5qSggEEcZHSDw4YaUU/bWi+tMRcy4RoxMnBZPGEtlSvh23nZkISDbGVHh5o0zpXOsKf6O9vB8h/DoABhSlOkTc0I7DsQ4mxNsDIcbu5t97dI7fiKlUGy
 R3gc4k43
 r+HTEg0lI4xMuetXf2s3nfb0ImgOdB2alXz7NKbYVXBCRd9I6gmZMPE2e2+Dq75y8qMp58zUYJ8wQVKcm53/cLIzxSZDw5/FngwvhjNCtBKDrAI8t/VgS4+RGm8TsyYjVRoxttp+5grbVFmaaxVQuF4eAAQn7/nJre62A9IoOvNZ0/OUdUG5SxdilgnKG3s4l8rjGu0IYLqHW+lzdXLtKmmrBk5wGrtWNiH8Gu09r9sLCXms7Y4O6blNv0afWbae1/n+t0h9Wps18whzigicYROXBw+K1/cKx2eopRq89JpykWC6LkKcv/vCRE0vHHTSb0CxGI8oOua6V63O31GfjMehANLq73H8BS81NaRMfhMsJK2/fTXfHHt9oNfxdCWY3KD6/B4UU2UuS9aPFSW7mASxGawj5r4bqbzcVi6ceaW7c4PhebQNo5aGIyX0zvEcP2rzxNRRc+WLJ+20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

struct huge_bootmem_page is only used by hugetlb boot-time allocation
code, but its definition currently lives in mm/internal.h because
hugetlb_vmemmap_optimize_bootmem_page() takes it as an argument. This
exposes a hugetlb-specific internal type more broadly than needed.

Change hugetlb_vmemmap_optimize_bootmem_page() to take the information it
actually needs. With that interface, mm/hugetlb_vmemmap.h no longer needs
to include mm/internal.h, and struct huge_bootmem_page can move into
mm/hugetlb.c.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2:
- Pass PFN and order to hugetlb_vmemmap_optimize_bootmem_page() instead
  of struct hstate and bootmem metadata to simplify the code further
- Collect Acked-by from Mike Rapoport
---
 mm/hugetlb.c         | 8 +++++++-
 mm/hugetlb_vmemmap.c | 8 +++-----
 mm/hugetlb_vmemmap.h | 5 ++---
 mm/internal.h        | 7 -------
 4 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 03665ff92696..b2b80284c4ce 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -55,6 +55,12 @@
 #include "sparse.h"
 #include <linux/page-isolation.h>
 
+struct huge_bootmem_page {
+	struct list_head list;
+	struct hstate *hstate;
+	unsigned long flags;
+};
+
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
@@ -3138,7 +3144,7 @@ static bool __init alloc_bootmem_huge_page(struct hstate *h, int nid)
 	} else {
 		list_add_tail(&m->list, &huge_boot_pages[nid]);
 		m->flags |= HUGE_BOOTMEM_ZONES_VALID;
-		hugetlb_vmemmap_optimize_bootmem_page(m);
+		hugetlb_vmemmap_optimize_bootmem_page(pfn, huge_page_order(h));
 		/*
 		 * Only initialize the head struct page in memmap_init_reserved_pages,
 		 * rest of the struct pages will be initialized by the HugeTLB
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index a25adc474351..eb339c4a71f4 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -19,6 +19,7 @@
 #include <asm/tlbflush.h>
 #include "hugetlb_vmemmap.h"
 #include "sparse.h"
+#include "internal.h"
 
 /**
  * struct vmemmap_remap_walk - walk vmemmap page table
@@ -705,15 +706,12 @@ void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head
 	__hugetlb_vmemmap_optimize_folios(h, folio_list, true);
 }
 
-void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
+void __init hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order)
 {
-	struct hstate *h = m->hstate;
-	unsigned long pfn = PHYS_PFN(__pa(m));
-
 	if (!READ_ONCE(vmemmap_optimize_enabled))
 		return;
 
-	section_set_order_range(pfn, pages_per_huge_page(h), huge_page_order(h));
+	section_set_order_range(pfn, 1UL << order, order);
 }
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 20eb03df542a..464192e32dec 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -9,7 +9,6 @@
 #ifndef _LINUX_HUGETLB_VMEMMAP_H
 #define _LINUX_HUGETLB_VMEMMAP_H
 #include <linux/hugetlb.h>
-#include "internal.h"
 
 /*
  * Reserve one vmemmap page, all vmemmap addresses are mapped to it. See
@@ -26,7 +25,7 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
-void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m);
+void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order);
 
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
 {
@@ -77,7 +76,7 @@ static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate
 	return 0;
 }
 
-static inline void hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
+static inline void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order)
 {
 }
 #endif /* CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP */
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..c37a468d53c1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -23,13 +23,6 @@
 #include "vma.h"
 
 struct folio_batch;
-struct hstate;
-
-struct huge_bootmem_page {
-	struct list_head list;
-	struct hstate *hstate;
-	unsigned long flags;
-};
 
 /* mm/workingset.c */
 bool workingset_test_recent(void *shadow, bool file, bool *workingset,
-- 
2.54.0


