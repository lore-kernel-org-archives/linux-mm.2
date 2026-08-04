Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB883C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:56:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58FD56B00B6; Mon,  3 Aug 2026 23:56:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568256B00B8; Mon,  3 Aug 2026 23:56:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 456B56B00B9; Mon,  3 Aug 2026 23:56:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 153736B00B6
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:56:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97EBDA2352
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:57 +0000 (UTC)
X-FDA: 85062226074.25.4D04B6C
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id D072F180007
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=f9N0Yp0Z;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815815;
	b=sW8Skc0yy2NbepSMvxKbDeYZiSu0cJsvOFWBTzfBvT7uJXFXYq46mzSGuplumc8v+gZfKZ
	ZYneNJSIXfjs+V/WazKg7uq2T7lzecdSYc7VnnEBdste93ZdOvfgGL2Kq4hk9OVcmY+SO0
	unAHBgFmUg4CYvyRNXG+m3YfuIAwZ+I=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=f9N0Yp0Z;
	spf=pass (imf24.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HVMuForKZApPU3H4utqVM44IJGHsuiuqxhUD4Ue7wX4=;
	b=amsMWMRCYidXgQrVurZO+PhAp5wbqCq1CfngxV2ERamQqwoHGRnu/iPlzvqw6UcfAAAMBA
	/Ly/G/mDieR5xoC8CMFe5Dm1XYyyXA/RNU6ar+B5jkH7+jQ84Eyer/fbshL8smbW3gDBCB
	FQutkOuxtiRFJIwJs6zq3pamy8t7GZ0=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cacf197759so60702715ad.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785815815; x=1786420615; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HVMuForKZApPU3H4utqVM44IJGHsuiuqxhUD4Ue7wX4=;
        b=f9N0Yp0Zd7p1c1PnQPCDVAgLevhTIRnTpRQ7KU16kbczJAlmb0VrTR2NA8k2plwcfL
         NaYK3Ni0+qH0pqREQZC485H/XMhdUvg3aPawv+ckOrwHyqiz+LvHzVv7a4Y2nqLd3QT5
         AsZsCbK4KBTtMdOmFsoQk2XdJtqHa2P3Woxa7t8ZXq7IOLn8dbttGeR8BggNDweyAIm9
         2voYTtj/sMEZQofwP17Y2wCjAa4/HD2K1+jyfwHp1ITYV1uJ+Eh9Pu4Nt8qIZYpFmib0
         WtrnzDB/GqTSMX41kbpyJq24oOkLBnxVfJxxRfKLsQRuQyVD2K5KxaZFZbuCxs4zNxc9
         Ma0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785815815; x=1786420615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HVMuForKZApPU3H4utqVM44IJGHsuiuqxhUD4Ue7wX4=;
        b=fDe4sv/iAkxlE6+0/+zor2UJ37DPPhCPCXp5+3ghnroTqWiNVUfYW6aKQcWIDpF+it
         FOEtkvl236Vopf48XefFxkjAiiKJDbVk+JMJSOD0UbSm6r2qVvEMQAllzWmQ2UGQ6JuF
         ifYvCDefxAh/1khNAtGkqxSkjuwbcGk5UfZiknrstL0pLjaUKyjgyHyQytZurIpJm5ds
         0lzl2XAsFnRoOztV+xQ88CMSDsC82vh80cGBN7t/WuJQDVxOlYU+I7zrLrmWHWURFIhG
         rxyN4hwVqwalya6AnpDEChfxIGpzS0546BY34J+64Xfrdf2IDyq/ed2zrA/NbmLS8qIs
         ip4w==
X-Forwarded-Encrypted: i=1; AHgh+RqZ2yqSjhd3bfmSrFZLD0ab6fm95p7F3a2nlQp2uoCSeBWXUd5T/H49LGN6WamKU48iWwyT8U3COw==@kvack.org
X-Gm-Message-State: AOJu0YxHTMxMY4RA8F1bro+MDs+I3fjXaVur6UEdniK2o40DJc4RGCsu
	ORtmbc/9eMVdsO+i6K5E7AgX1ruEgE4es0mr1p/YMJ6Nb/XMFc2Wdcf0wUb651d/5zk=
X-Gm-Gg: AR+sD11uyO9LX5FO8xEHhtnP9XUYBIivRCd5+d+yrTi3bhVPNd7+PGYQkatQWGp6PPO
	4zbyCmfwuP2qyPqOO6rT2M0VXz2cwlBbddT+7QjILhaCOxbya4XZO+c9gszLiYOREceDKQ7DHfW
	KtE477buRf9sckYlCZIYj1IO+dYdDwOeVyvW2ajmDshYc5gaolIkIBR5RLgAc2daGzTVnTXsoPo
	wdmsrrX6F4YNGZUxqf+R2tNyS7+3rvt9cI+vRTJ893gUrlxhsujh2joVb7/xdhs6ni1g41Ejzxo
	FkswkMeW5WipN3zZMN8kUGQ3e93zzZVIgie1H17MQQTTZgrkcw/wsLXw/e/QH4OR17A5Mhd2Bd+
	Vvhj0vg2xeIUeoxWgCYHNu2dWlZUSt8x0m5MvOl9lGLa5Jr+5jxYs5ARrVqdDjqEo38ZGSgH3ZG
	LxIkPDwgTsOUV8Rb3vpdGDFXXV8E9qTSWxMuMyA5pkAXEQVDrPzN+na+didoGlchHmZHqPK3Trx
	IllWNtW
X-Received: by 2002:a17:902:ce8b:b0:2cc:ee78:3236 with SMTP id d9443c01a7336-2d0523e8aadmr122285575ad.33.1785815814649;
        Mon, 03 Aug 2026 20:56:54 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae99af1sm46313695ad.33.2026.08.03.20.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:56:54 -0700 (PDT)
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
Subject: [PATCH v3 16/17] mm/hugetlb: localize struct huge_bootmem_page
Date: Tue,  4 Aug 2026 11:55:34 +0800
Message-ID: <20260804035535.2846016-17-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260804035535.2846016-1-songmuchun@bytedance.com>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hswmh7tn39d18k86y1qum1eo587jaiu6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D072F180007
X-HE-Tag: 1785815815-87372
X-HE-Meta: U2FsdGVkX1/B9alq0dpBJrEUkGH4WXfXmrK4oTKxKFdv8/IjQS5eZszDzGnwrMbWTPmV0AlwM+czlLk/Df9a1Xsbq6EL6L4evxTCuQJ7I9DNza72S9wH9lOqcJWSVEtMvcdkoI01Yi6/bh+IEl5cb0zVqm7LFLfBIykJFxMcd3dv05Q+gPn3ZWivCN5c/rtBc52xkDTQ55tj+RctCGx+m54sSYwQoI8ErNlQ/YoccMAyztuwd7QB1gHgqHEedDtios13c5qcm7WLRsvP+/kh4CTiKE6tUHTU0D5OuHBSR83QcdtMkLnrauTP9wmjvnBBxATmFM4lW6pa3ImBxREBIsFYzxVF6BuMqpb3RX/hTWfZoLsxkIMJN/FX5Pav+M44U7JA5l2LbzUiX3mLh4kk2kxZv+Kn3BJ1j6b6FeIxgCvhLP3Qe97lacGwLNdCv79qg8h+W+3YOiqL34MIObfjWFgFdB2ZZWUXoXuOfGUmAvLT+T8VovsBqhAGeeZ/1d4JS4UnuBMogA0RJ2VeLFPvJoosfOcH0GwxWy1RWwcXlmwp2LwfJndfYXRuWyUI96X0lHNjjI2R1tY2WwKVRDTJ8sHXRtPpsBmFUljrNKNKChhhAOhI0YBDKzIlCiktbgikwgwT/Zskf3OhuZ5/mrwyRwk1p2ZAplrJYrAvUTPj63Xp8zlxCvvNuuK2eZpcbskbymHlbrQCp3112vAYgDJJ1iw1/AV6ByGiWYBYTwa51EWpwf2TEA9vREW+YNon21U83kExTOtYPlcfP1JHeosQk5JMeGHdVL8+thZtP/utKYbjKCJHush7+egt46VO1Pv05kVM1c8U6e/8VTJrA1KDw1G+QQAcqeEJUpnj60BJDdxKKb8gnzUec/Agc4lthEVjmGlXPXomGQ7YhGDuMBYSIqbcymawYhWmdc5A9ZriGSTGxiHJGy9Rw5uBHSeGq0xZOhxCZoGvLFdiJR2Bheb
 BJ8I50DR
 erIUW0Yt1rb+ARlKFeZJFjib831fSh9KLz8gyC5DfQV2TD4mCg/CUGRxIJ9b1G23cQbXETMOl4Jq1W7pd0+8iPROe+MnVbRvIN+IMVenLK/yGhXrscnsn4AKgeIxAjZ5AO6hBYTJHB4NYicNGCvcwL2ISz3h2XM3swb8kNiUHS8q8OYufVeotVn1q4qz80tUmJo2C1lp6Uzb0T1uaM6obnhzolGzU3m7yAthx2U3tq8l2t2CFW+fBymqU8+vIZ0MPCuicx/Iydrmcd2SAkB0q9tmwUQkYMvTPybIOFxwIeecZqq07W3v1Z+jNc31m1KjzPdHvgzQmqk0kxV1KruB1YOidaDbogHvMyA5jdfk7/FQN1+dYZzKlPcj5uCNXuUEdCXI+3QnXQvZDGQCN4qBIp4tkArtWBTbZpvh6RIUycWyTx0tpJd54SfU+yzQ+OUY4wROb/7vGno21gRk=
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
index df5944651b9a..d978992e2770 100644
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
index f47f06c55548..8862d447ba8b 100644
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


