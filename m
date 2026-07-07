Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E65ABC43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 06:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AFB46B00CF; Tue,  7 Jul 2026 02:42:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EAA36B00D1; Tue,  7 Jul 2026 02:42:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECC976B00D2; Tue,  7 Jul 2026 02:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0F006B00CF
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:42:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2D5341402EE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:42:47 +0000 (UTC)
X-FDA: 84961037574.07.121BD27
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf12.hostedemail.com (Postfix) with ESMTP id 719EB40005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:42:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NqygPsY6;
	spf=pass (imf12.hostedemail.com: domain of 35J9MagsKCK8hdjgPkePcSPVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--souravpanda.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=35J9MagsKCK8hdjgPkePcSPVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783406565;
	b=3z2V92L8eywoQ9M8gZwJpDE/MALVpEtPg5Z0sdrApH3CSi41IFdS7pLNEbsixxYf76+26p
	eOhsgYcID33a/idGmNJPilMJdCBBuJMuFQeClQLkUrvqSCjb2nHUUuiIK81WO6IbWXyD4V
	3TLgHivP9/FY8YqkIR06SEOe/tVP//8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NqygPsY6;
	spf=pass (imf12.hostedemail.com: domain of 35J9MagsKCK8hdjgPkePcSPVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--souravpanda.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=35J9MagsKCK8hdjgPkePcSPVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783406565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pw6BVJ/QVNzRTvmuXXHDf40tgOrCadUtgbpK+Kq2rCY=;
	b=bQYSwoGTkD0IY8XhA3+Qh+0G7ztaKj63Ie3tvfJxs20/8CH1g+R8lnxWLsNXnlTPMCHI1S
	kgV0N67X31Lnm+knBt2IctG10OKBUC4PasncTjX9qi6avx363uw5q5Z1YvWl835VQb0F+Y
	oe30bZCBoviO8kmwhZ5eU/xa2RbPKfY=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8482df30da4so719237b3a.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 23:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783406564; x=1784011364; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pw6BVJ/QVNzRTvmuXXHDf40tgOrCadUtgbpK+Kq2rCY=;
        b=NqygPsY6Q+xUasK3+b7hxKjBzegISoy+lDNPWqjr/Atc1on1SB4MWedkeVioe3JL7C
         TFg11zmwPa1L/o0x3YVtFbLlo8AFbqEFJHdJ/gM1xWBdP1fOuQVj057mSVh3it/VHvv2
         2yQVUn4OpfecY54lrvrDtoHgj3acuXVUROXZgd/fc8TJKh7nLU3qLVT2W6QAvPElqxum
         x6bNqySVcT85jBwBeydgaCQ0YqPPBDsaN5hsm+IgOLcFarq/SYBJyUh6FiL3jHU+dRSA
         gXP7egAEG2dslVO9pG3J4LCzlqgt25q1AqlIExaua4z1jjrrkxQqQxvZY+V8nhfw3FCr
         KggA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783406564; x=1784011364;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pw6BVJ/QVNzRTvmuXXHDf40tgOrCadUtgbpK+Kq2rCY=;
        b=VmKI87enXA/Lf+1T6iGgR44SXFXWeZXTwOvPNKT7Ng7bP+DgjQ839zh4Jf6cXgoUcA
         2s9ilwSyknyb8VO5QhAasfoikJ6etyOPlzuFnn/gL/HUqpHAabHoflIyc3DY1z9fiP5G
         6yu+hL0rIpgqUHo3T/x4MG39SV8zvWbQGrtgbCLNmdtLNFnb5xrc8zItuFd2Xz0oZdd/
         0BdJPdiz2c/R6btMsi11MGKypAqEoF6GbSNV+L42+udsmD1d8rvlkxaUABEB2+8KEyCT
         lhh+2FBiTt8Ai7jHfjZ8IdpmX7Il1d9CLXZBZG8K9UJxa7mJCjNPiO8uSwxHWz2sClHg
         eipQ==
X-Forwarded-Encrypted: i=1; AHgh+RopT554aydk0AlwFHe0gSwUTRlQ2tCkBW3tSlRLr+ZU/Zh4jGBNje0J+vRnoj8kU/PDOy5UtrixQg==@kvack.org
X-Gm-Message-State: AOJu0Yy5KOZ/MZadJJsVEB216lav7lNDJhf29domazUU+zFFLt0xMNY7
	W5TjeHctPkSe/1GbBqru6a2DW7dv74bi5av11tgzdz5BlxOQwcIkhUQbYW9bdfQBQdrsRHgU8Eh
	nU20FXVikh77i1vwqHeinsJQGvg==
X-Received: from pfbbj20.prod.google.com ([2002:a05:6a00:3194:b0:847:74c2:35f5])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:8085:b0:846:8b21:6304 with SMTP id d2e1a72fcca58-84826bb949bmr3922339b3a.14.1783406564179;
 Mon, 06 Jul 2026 23:42:44 -0700 (PDT)
Date: Tue,  7 Jul 2026 06:42:35 +0000
In-Reply-To: <20260707064235.1386552-1-souravpanda@google.com>
Mime-Version: 1.0
References: <20260707064235.1386552-1-souravpanda@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <20260707064235.1386552-7-souravpanda@google.com>
Subject: [PATCH 6/6] mm/hugetlb: support free page reporting for cached hugepages
From: Sourav Panda <souravpanda@google.com>
To: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, mst@redhat.com, 
	mhklinux@outlook.com, souravpanda@google.com, fvdl@google.com, 
	gthelen@google.com, mike.kravetz@oracle.com, pasha.tatashin@soleen.com, 
	rientjes@google.com, riel@surriel.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 719EB40005
X-Stat-Signature: ba16dd7k5yn39ws4trdqccrewicpnwqu
X-HE-Tag: 1783406565-614116
X-HE-Meta: U2FsdGVkX1+eMJkfmHIsUvOptuuLKP+V45zU+X4hhjrugvzTIOd7MHCZNg0L7kil++1k8z8RoNfBVyKBkRPVz/q8hqMJL5LY1/2s1ClCYxXZgtQTho+M8K4h2MFApBwiyeyPKg5kCm0V1hxtK7U3evndejphAOo0sFymoCBoTzqbSbjmqRc8UzyCkC6NswKuIvudo/IxzL4Py7pUFQR6plMNEVNMB49MvhwhbricqZacrRTdMJceP++Z1jHw7c3+JNTl5Bmuj8lJw0sgI2aHP1BUhDokE5BeDoHkaBAx1QP1m72kSn4PYUyaScyKPrQ78IrM9t3mA93NfvVAojXLVF/SoWEhzK0y4F3nC8uPeUZXwc9z2fkOaqdXohlozCAJiGGMnRNYGDWSzuNdvsd6tyxBE3aTozwX40lCvJ6VmKw/FMdXRt8TIkxPq7NJd3xAB3bPQ0UvfB//pjGl+wnV+u7gdFr4ZPmtSKdW9YwfT0hEqBIXVpflzLsjYWQsjxp2O0EwjcD/7UmMTQMdFCvW2+KnrCiwm16C1Dn3M3c7gRKc5CPeGIbDZCUAOBl+UaaCuckdZVgSdJ90uVxWdQDiSUiuzj7zbvoTJIlUIDebx3QbElcAQW733v36XQ/rWyRukS/WS1evOe43LL9vyRIdkvWyYnLLsNqvKePcxHWIcXS+LfohvuG1jCruas57n5kA96Gm7CK6rlpcQXtex/dvzISYzH9h4nr1cFlsWkxwYNP3tXcM7AdSJbFNgkIEXemAL0W32QeNurqU7O8CB8JFc8zuMjv59QkOJiqsjBrXE3ykSlcbhJ2uaOHME1Q7xQqb9YHz7YrMofCN98D5p0twwYNv2RnWb+9w2c0/mgPox1O11GhVCxuACFDQbdVo7tpoQJOFBhJ9eZCd7a4Puv7EgHXoqxZ9SvzcQiABr2CIH14uWFwvg1yHKnL9SrLTuqRBwdPPfo6Mi9ZkH58yX83
 3Osbo9E9
 mFzbafA19MDi+c9EIBljUXPhBuXRcYRMfVeMnbEFXUiR1MmS7DTwsswvCUHN7EVgJTuTcVA5ho31adX5sLCkzY1TWLnQ1+rq35hvjon11+N1+D7AwVJKnYXyrVl55QQEYWfe8Jceqlk9EhzgcbpMnQEVKccrUBJbGfWdpU1C65Ygd652wNK8QjJ9xHzWPIzQy8/f7GEjgJJ5W8NOAWWTi0EZeSavJiPNlp1XExYDzW7nYOrNOOX/6lUHJaCT1bm/Dw5DrqhLiveChICQgaLIDmq0VZfGmTRGK51aot7xGSlw8AxVLsOqMKu14xlnbj6uG0pyDzXGteP7JUj7XJI3sPRhfy0jcFFEGfmfGRztThqp2yvw3s5nb4VdSJnXhbFRMQ9snMwbQgbtav7XYotuVFo6iIVCFujuyj76ckybn0UpwTyeEYUSCZbKqHP0deCwQw/RK/dCz2tHQYpn3h5eSqbgK4I/dDXCzDFrMx9emo7mkMnNeIoJbfklVOPoih11QYvvyr/0jnjzYhD4SDwlOBfYA6lSGAoE+zgrx7ZXz3reGF5O0VrTO+TJNCV7del379HwyX3fuSTV45INaSld/knFHLgIGxFu63mQlWFRi2MrHs5cK4t5tBcAphw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement free page reporting for the HugeTLB dynamic cache.

Register HugeTLB hstates with the page reporting framework if they
support caching.

When pages are added to the cache (either via recycling in
free_huge_folio or direct population via sysfs nr_cached_hugepages),
trigger a page reporting cycle.

Page reporting isolates pages from the cache list, reports them to the
hypervisor via virtio-balloon, and then drains them back to the cache
list, marking them as reported (HPG_reported).

If a page is allocated from the cache, or reclaimed, clear the reported
flag.

Signed-off-by: Sourav Panda <souravpanda@google.com>
---
 include/linux/hugetlb.h        |  27 +++++++
 include/linux/page_reporting.h |   1 +
 mm/hugetlb.c                   | 125 +++++++++++++++++++++++++++++++++
 mm/page_reporting.c            |  10 ++-
 mm/page_reporting.h            |   6 ++
 5 files changed, 163 insertions(+), 6 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index e882c99780b6..bde23edcb803 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -587,6 +587,7 @@ enum hugetlb_page_flags {
 	HPG_cma,
 #ifdef CONFIG_HUGETLB_CACHE
 	HPG_cached,
+	HPG_reported,
 #endif
 	__NR_HPAGEFLAGS,
 };
@@ -650,10 +651,14 @@ HPAGEFLAG(RawHwpUnreliable, raw_hwp_unreliable)
 HPAGEFLAG(Cma, cma)
 #ifdef CONFIG_HUGETLB_CACHE
 HPAGEFLAG(Cached, cached)
+HPAGEFLAG(Reported, reported)
 #else
 static inline bool folio_test_hugetlb_cached(const struct folio *folio) { return false; }
 static inline void folio_clear_hugetlb_cached(struct folio *folio) { }
 static inline void folio_set_hugetlb_cached(struct folio *folio) { }
+static inline bool folio_test_hugetlb_reported(const struct folio *folio) { return false; }
+static inline void folio_clear_hugetlb_reported(struct folio *folio) { }
+static inline void folio_set_hugetlb_reported(struct folio *folio) { }
 #endif
 
 #ifdef CONFIG_HUGETLB_PAGE
@@ -1093,6 +1098,20 @@ void hugetlb_unregister_node(struct node *node);
  */
 bool is_raw_hwpoison_page_in_hugepage(struct page *page);
 
+#ifdef CONFIG_HUGETLB_CACHE
+struct page_reporting_dev_info;
+int hugetlb_page_reporting(struct page_reporting_dev_info *prdev,
+			   struct scatterlist *sgl);
+#else /* !CONFIG_HUGETLB_CACHE */
+struct page_reporting_dev_info;
+struct scatterlist;
+static inline int hugetlb_page_reporting(struct page_reporting_dev_info *prdev,
+					 struct scatterlist *sgl)
+{
+	return 0;
+}
+#endif /* CONFIG_HUGETLB_CACHE */
+
 static inline unsigned long huge_page_mask_align(struct file *file)
 {
 	return PAGE_MASK & ~huge_page_mask(hstate_file(file));
@@ -1311,6 +1330,14 @@ static inline bool hugetlbfs_pagecache_present(
 static inline void hugetlb_bootmem_alloc(void)
 {
 }
+
+struct page_reporting_dev_info;
+struct scatterlist;
+static inline int hugetlb_page_reporting(struct page_reporting_dev_info *prdev,
+					 struct scatterlist *sgl)
+{
+	return 0;
+}
 #endif	/* CONFIG_HUGETLB_PAGE */
 
 static inline spinlock_t *huge_pte_lock(struct hstate *h,
diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index 9d4ca5c218a0..bd5a5a293dc3 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -27,4 +27,5 @@ struct page_reporting_dev_info {
 /* Tear-down and bring-up for page reporting devices */
 void page_reporting_unregister(struct page_reporting_dev_info *prdev);
 int page_reporting_register(struct page_reporting_dev_info *prdev);
+extern unsigned int page_reporting_order;
 #endif /*_LINUX_PAGE_REPORTING_H */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1bc0198a695c..110c566efc3b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -46,7 +46,9 @@
 #include <linux/io.h>
 #include <linux/node.h>
 #include <linux/page_owner.h>
+#include <linux/page_reporting.h>
 #include "internal.h"
+#include "page_reporting.h"
 #include "hugetlb_vmemmap.h"
 #include "hugetlb_cma.h"
 #include "hugetlb_internal.h"
@@ -1414,6 +1416,7 @@ static void hugetlb_cache_remove(struct hstate *h, struct folio *folio, bool to_
 	list_del_init(&folio->lru);
 	folio_clear_hugetlb_freed(folio);
 	folio_clear_hugetlb_cached(folio);
+	folio_clear_hugetlb_reported(folio);
 	h->nr_cached_hugepages--;
 	h->nr_cached_hugepages_node[nid]--;
 	if (to_surplus) {
@@ -1806,6 +1809,7 @@ void free_huge_folio(struct folio *folio)
 		    !folio_test_hwpoison(folio)) {
 			arch_clear_hugetlb_flags(folio);
 			hugetlb_cache_add(h, folio, true);
+			page_reporting_notify_free(h->order);
 			spin_unlock_irqrestore(&hugetlb_lock, flags);
 			return;
 		}
@@ -4231,6 +4235,7 @@ static int adjust_cached_huge_pages(struct hstate *h, long count, bool is_delta,
 			account_new_hugetlb_folio(h, folio);
 
 			hugetlb_cache_add(h, folio, false);
+			page_reporting_notify_free(h->order);
 			spin_unlock_irq(&hugetlb_lock);
 			cond_resched();
 		}
@@ -4310,6 +4315,7 @@ static int adjust_cached_huge_pages(struct hstate *h, long count, bool is_delta,
 			account_new_hugetlb_folio(h, folio);
 
 			hugetlb_cache_add(h, folio, false);
+			page_reporting_notify_free(h->order);
 			spin_unlock_irq(&hugetlb_lock);
 			cond_resched();
 		}
@@ -7763,3 +7769,122 @@ void fixup_hugetlb_reservations(struct vm_area_struct *vma)
 	if (is_vm_hugetlb_page(vma))
 		clear_vma_resv_huge_pages(vma);
 }
+
+#ifdef CONFIG_HUGETLB_CACHE
+static void page_reporting_drain_hugetlb(struct hstate *h,
+					 struct scatterlist *sgl, unsigned int nents, bool reported)
+{
+	struct scatterlist *sg = sgl;
+	unsigned int left = nents;
+
+	spin_lock_irq(&hugetlb_lock);
+	do {
+		struct page *page = sg_page(sg);
+		struct folio *folio = page_folio(page);
+
+		hugetlb_cache_add(h, folio, false);
+
+		if (reported)
+			folio_set_hugetlb_reported(folio);
+	} while (--left && (sg = sg_next(sg)));
+	spin_unlock_irq(&hugetlb_lock);
+
+	sg_init_table(sgl, nents);
+}
+
+static int hugetlb_page_reporting_cycle(struct page_reporting_dev_info *prdev,
+					struct hstate *h, int nid,
+					struct scatterlist *sgl, unsigned int *offset)
+{
+	struct list_head *list = &h->hugepage_cache_lists[nid];
+	unsigned int page_len = huge_page_size(h);
+	struct folio *folio, *next;
+	long budget = 100; /* Limit */
+	int err = 0;
+
+	if (list_empty(list))
+		return err;
+
+	spin_lock_irq(&hugetlb_lock);
+
+	list_for_each_entry_safe(folio, next, list, lru) {
+		if (folio_test_hugetlb_reported(folio))
+			continue;
+
+		if (budget < 0) {
+			atomic_set(&prdev->state, PAGE_REPORTING_REQUESTED);
+			break;
+		}
+
+		if (*offset) {
+			/* Isolate */
+			hugetlb_cache_remove(h, folio, false);
+
+			--(*offset);
+			sg_set_page(&sgl[*offset], &folio->page, page_len, 0);
+			continue;
+		}
+
+		spin_unlock_irq(&hugetlb_lock);
+
+		err = prdev->report(prdev, sgl, PAGE_REPORTING_CAPACITY);
+		if (!err) {
+			pr_info("HugeTLB page reporting: reported %u pages of size %luKB\n",
+				PAGE_REPORTING_CAPACITY, huge_page_size(h) / 1024);
+		}
+
+		*offset = PAGE_REPORTING_CAPACITY;
+		budget--;
+
+		page_reporting_drain_hugetlb(h, sgl, PAGE_REPORTING_CAPACITY, !err);
+
+		spin_lock_irq(&hugetlb_lock);
+
+		if (list_empty(list))
+			break;
+		next = list_first_entry(list, struct folio, lru);
+
+		if (err)
+			break;
+	}
+
+	spin_unlock_irq(&hugetlb_lock);
+	return err;
+}
+
+int hugetlb_page_reporting(struct page_reporting_dev_info *prdev,
+			   struct scatterlist *sgl)
+{
+	struct hstate *h;
+	int err = 0;
+	int nid;
+
+	for_each_hstate(h) {
+		if (h->order < page_reporting_order)
+			continue;
+
+		for_each_online_node(nid) {
+			unsigned int offset = PAGE_REPORTING_CAPACITY;
+
+			err = hugetlb_page_reporting_cycle(prdev, h, nid, sgl, &offset);
+			if (err)
+				return err;
+
+			/* Report leftovers */
+			unsigned int leftover = PAGE_REPORTING_CAPACITY - offset;
+
+			if (leftover) {
+				struct scatterlist *sg = &sgl[offset];
+
+				err = prdev->report(prdev, sg, leftover);
+				page_reporting_drain_hugetlb(h, sg, leftover, !err);
+				if (err)
+					return err;
+				pr_info("HugeTLB page reporting: reported %u pages of size %luKB\n",
+					leftover, huge_page_size(h) / 1024);
+			}
+		}
+	}
+	return 0;
+}
+#endif
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 7418f2e500bb..882496b8b2c9 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -2,6 +2,7 @@
 #include <linux/mm.h>
 #include <linux/mmzone.h>
 #include <linux/page_reporting.h>
+#include <linux/hugetlb.h>
 #include <linux/gfp.h>
 #include <linux/export.h>
 #include <linux/module.h>
@@ -50,12 +51,6 @@ EXPORT_SYMBOL_GPL(page_reporting_order);
 #define PAGE_REPORTING_DELAY	(2 * HZ)
 static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
 
-enum {
-	PAGE_REPORTING_IDLE = 0,
-	PAGE_REPORTING_REQUESTED,
-	PAGE_REPORTING_ACTIVE
-};
-
 /* request page reporting */
 static void
 __page_reporting_request(struct page_reporting_dev_info *prdev)
@@ -334,6 +329,9 @@ static void page_reporting_process(struct work_struct *work)
 			break;
 	}
 
+	if (!err)
+		err = hugetlb_page_reporting(prdev, sgl);
+
 	kfree(sgl);
 err_out:
 	/*
diff --git a/mm/page_reporting.h b/mm/page_reporting.h
index c51dbc228b94..74e05af4bac1 100644
--- a/mm/page_reporting.h
+++ b/mm/page_reporting.h
@@ -11,6 +11,12 @@
 #include <linux/scatterlist.h>
 
 #ifdef CONFIG_PAGE_REPORTING
+enum {
+	PAGE_REPORTING_IDLE = 0,
+	PAGE_REPORTING_REQUESTED,
+	PAGE_REPORTING_ACTIVE
+};
+
 DECLARE_STATIC_KEY_FALSE(page_reporting_enabled);
 extern unsigned int page_reporting_order;
 void __page_reporting_notify(void);
-- 
2.55.0.rc0.799.gd6f94ed593-goog


