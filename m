Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18D44CD6E55
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 05:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA29A6B00F8; Sun, 31 May 2026 01:58:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25906B00FA; Sun, 31 May 2026 01:58:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9EAD6B00FB; Sun, 31 May 2026 01:58:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC7F96B00F8
	for <linux-mm@kvack.org>; Sun, 31 May 2026 01:58:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 559788D52E
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:58:36 +0000 (UTC)
X-FDA: 84826660632.02.F6EDBF7
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8EBB740009
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:58:34 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="I6/MBPyR";
	spf=pass (imf04.hostedemail.com: domain of 3Cc4baggKCGwTSKaSiKXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3Cc4baggKCGwTSKaSiKXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780207114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=snShNS8B0A/roLa9I0WH5+4cW+eeLsBmpxsgxamM+Gw=;
	b=XdQ0H9DPUcXXPrhQO1/X8P9AYQVmVnPQTPdxRf2rAGUBgVw0YrrXlc9ZBzb0n212+TSpPC
	Llnxnb71fqPjdDtD40SZjbNuTjamW3mr/bz0j048CykAmWkSZkrQqJQDvaHBm4fe75XNcc
	+/LqB7Gb+q3WJDgSN2u3vhz4V2b6FNU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="I6/MBPyR";
	spf=pass (imf04.hostedemail.com: domain of 3Cc4baggKCGwTSKaSiKXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jiaqiyan.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3Cc4baggKCGwTSKaSiKXQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780207114; a=rsa-sha256;
	cv=none;
	b=vaFW3YY8IsZf4A3SPc2lhwqyufRBELnJNz4sUEdVVwVTKkdH413RsQYQYqPmjx0EZOfSmC
	08doeK2dpiFYaXy84dAlCmK/y7V/zgW8y6Lgs9Un3/cpsk+9HggVjkKW+1fPjBm2kRfoiV
	8En9RBOQUP5BRU0oUlbyrAWUJF1+/gM=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2bf335549b8so20801105ad.1
        for <linux-mm@kvack.org>; Sat, 30 May 2026 22:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780207113; x=1780811913; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=snShNS8B0A/roLa9I0WH5+4cW+eeLsBmpxsgxamM+Gw=;
        b=I6/MBPyRUd11XghXgGsPEZTNIQzK4Nmbkbs8VJLHS6p+n75/8Xeaum8Wyi0N3e1jp1
         ti1rsK98JgwtfMvU0m/pYcU7ab5DbNiLgr34CVgXHLrgbN8pTtZ2HCs8QjZ2JNPQ3USt
         Q2SqkezBQ5H1O92fOH2ovpCQTAdvp82z/abl0QCUsvCv4ctBN5Nf0jLK4zwD6SLvm68C
         EoSuMC2JA+5ty+EyOPf/uLZKy8M6roq2x/v8VuezE2anDa3QHni7al9d94IWTGFufvcB
         PakgUPdtjl2/qFX4bZRSE1KpE4ZOIpSrNqbJeSM1bcZnzVsQdMMFXXQOg5HT1AeiMVt+
         ss/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780207113; x=1780811913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=snShNS8B0A/roLa9I0WH5+4cW+eeLsBmpxsgxamM+Gw=;
        b=ZdzY8Ml80pAFLquvOyLKrIPpw7SxbxQg2REFKkxdecMOK2GVR2z53s+q7kLo5WTu2P
         iEboYqcyGyJUPJSct7YrZr7MQkOFh6RaluSsvBy5cBgJ2JCsarFiTx/G5C//b1nhDDoh
         +NAr8PvnRDMBwv9AoQna3NFbIWYhsRNLe/n1ysZepWyCrTbNo2pvoeoxzfA/zvVGMmU8
         yIc7dI0YmPJdcxSBg2H/1+l5D1BbykKbKI+ReDi+SxZ0yJyPoonQx4YZ/Ssoze5/m1VM
         Co8C8ZX5K/4DWczM9CQDyf/4mi1nikOUMapJjxYl1hzUMwegL26MPZl9qHMI+UxXnXop
         vfbg==
X-Forwarded-Encrypted: i=1; AFNElJ8pskSZXRSVRbTk/vIP8fwjCFlUnWTgN6oP6ZZLxhzfbassZ5tCeFcW9wpAiHBx0CFFHvL3uPStTA==@kvack.org
X-Gm-Message-State: AOJu0YwhifyzZZ9D2bHfU6cuXIbTh5aMlNewr1mYlipEyCjo6FqVsrZK
	l/C2uJGow/MTYLWCHSxX/+HJ9HSOr5dARQZ403r5qcrFQQT9uzrfymwjbwKH3I9ci2VQK8CJZiX
	GFRoy0u/JwRNH7w==
X-Received: from plcp19.prod.google.com ([2002:a17:902:e353:b0:2bd:7a0a:2d41])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e88e:b0:2c0:a3dd:4e6c with SMTP id d9443c01a7336-2c0a3dd4f17mr55603535ad.38.1780207113137;
 Sat, 30 May 2026 22:58:33 -0700 (PDT)
Date: Sun, 31 May 2026 05:58:26 +0000
In-Reply-To: <20260531055829.3636554-1-jiaqiyan@google.com>
Mime-Version: 1.0
References: <20260531055829.3636554-1-jiaqiyan@google.com>
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260531055829.3636554-2-jiaqiyan@google.com>
Subject: [PATCH v5 1/4] mm/page_alloc: only free healthy pages in high-order
 has_hwpoisoned folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: ljs@kernel.org, linmiaohe@huawei.com, osalvador@kernel.org, ziy@nvidia.com, 
	harry.yoo@oracle.com, willy@infradead.org
Cc: osalvador@suse.de, lorenzo.stoakes@oracle.com, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	liam@infradead.org, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: jc6sdsfyryfjdk693z7wxz7skhn5d791
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8EBB740009
X-HE-Tag: 1780207114-81685
X-HE-Meta: U2FsdGVkX1/Jw8C08U2+6H4VMEQegTdYzoxHHqggJqDFhUuejs4P6X49v84q4zQnf0h1Jyke4daJ4O2bKChm22AuG+Xdc773pX8M4OSpjdh/9jilhtT7qRUeOHh5gyWn10GwzfClBdtyr7NHwRHsqBiB+g6hn3qcaVXp8QaP4EvP0opXUMxfcSuZL+zxeAz/TxWQ4D58TtX7sFmU0q7ELkR57yWHxMJGtdvFaoEI0aTDvN7QO37MizGuuRnmiv/WpxqpV0yMRrm6zYfhf4SmDiVwe/ZvjhRAPnBTgBOqQyAtC8JlzpggzRf8olEhBbQpJq34NS6GhJfinXMcQk+E2SaNCbAQgztsX7NKg61blf36M74i4mHTiZiWkC8IpSDH7RCm00mIgHWVN42j8OR8b6qwXWRS7lVHAD6sXOAXS19NkXz2Hm34bwMOy7J6AvQkK9uaBB5K5KfLJQVKFOOu1uswbRCDS/dQE85CRQwgqtdW4QDAApy3HvfNcZTH8xTQOWCy/czsrNYBaxKmIYnKNcpGFGn8vKdd2u4x74VZiUkQ1XUpqDlrqpe57wMtgG5dc13uDUnVE6xfcgJsUa3IcEjVZ/5+lpqI0XIV8JmXm7T5a/jQ0SqHW5XgQqsICG7wGU2///E7QjPHiMqaf3g+UzsB0aVkG8dygvSN/wI58TQUwyCAayWejeT/l+0F5DEdAUQrsI1sQdY4uu39prfd3j1st5BmJ/Y2TtcBo8Tzgir4evYjcfRfuysWJ3nSaiHq5BpLm9ONqpjiEddubyt0jrQs8eglUdsWDvdyj6PSPV8FDHz0XEliFE/me4XcUbCFnum6xjRIf8eC9aO1TaBCP4OCE/+sr5iijqyaGFhD0dJWTqsmaRRdltBpGmw0w2/CxO5ZrJAvMGCX3Wd8Y5gO/QLGQEz8lF670DwWCjS5N2OvH/MSUEXb9E4RsNEGQG5nJDTXJ7/3NakKVoUj+S4
 x21O0EQD
 Ou4WxAemkqM4a5dIBOlBMJiLnhJnSKyEdL8k/tiML7x9tYN4sODBcdo8lvlU1XGImVHpyj7I77Z6ez30WxwDFmnjlgDxNpvnHFf9wCb/er/tGc/RxfNc1Uqz9X7nyuFGpTOfZ7sckG4jPt8NfHeVbEW1O6vI+1XSMkLjuHER1ex8dGfz6GWf3CPRk/dRZ0oKdWwsehM7E+7dSsnp+ybQvRDS+d08WG3/RJqN9cyMgTZPamHdYvz6j1SOutCgdlFtzF/FsyPQA6F+cSfj94s3mcBQo4gRIWTHhvc4z91prDrVUfUWO0+D5diZ0ra+YZ/atoeRY6il5daJNkf/L98Ien9L+wnxdyHFQRcoZ+9/TI/mvRhVkBwDit2DQ73fHyTyskSnmfbGfGJFNeDBmAHgAwixpW6dn19BFlKp2Y5F3kevd66+klWITAlCa48UOsSfaiIKu+EzQMwSCGYdNZ4A4S1IVZaYO2Uj4/qzwTcYLaK4/e/lLDg6ekNUOOSnwSh/RnBcMfjd0oBeZsYECXIjNYkn8ZHxlYid89fm/oAQv7nYzeN/pwgKoFgSkur9/YcfnAL02V2iGVNIovV9Gr8aye/fS8sBSsW9au1iskH1ltXsrVVwnJdqCB4ySTCFe/sXc7KkmpzQYs7QFbtDS3k4g44/xTGQC8iMWylKtMNa1wTJX9AY3GPjzUdgYCVkz/GgUANHrf/8uinVMFfnrim6VnOdP8jRDQts8uN4e5175tnTt91fTMAmIaMdZ6Hp21l+iwcIZUA1fnm17gb/apZD7hOfPMdpoQow+IfPUavOKiSKCyKMpiwXSti7o+l/cAm978rXL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
becomes non-HugeTLB, and it is released to buddy allocator
as a high-order folio, e.g. a folio that contains 262144 pages
if the folio was a 1G HugeTLB hugepage.

This is problematic if the HugeTLB hugepage contained HWPoison
subpages. In that case, since buddy allocator does not check
HWPoison for non-zero-order folio, the raw HWPoison page can
be given out with its buddy page and be re-used by either
kernel or userspace.

Memory failure recovery (MFR) in kernel does attempt to take
raw HWPoison page off buddy allocator after
dissolve_free_hugetlb_folio(). However, there is always a time
window between dissolve_free_hugetlb_folio() frees a HWPoison
high-order folio to buddy allocator and MFR takes HWPoison
raw page off buddy allocator.

Another similar situation is when a transparent huge page (THP)
runs into memory failure but splitting failed. Such THP will
eventually be released to buddy allocator when owning userspace
processes are gone, but with certain subpages having HWPoison.

One obvious way to avoid both problems is to add page sanity
checks in page allocate or free path. However, it is against
the past efforts to reduce sanity check overhead [1,2,3].

Introduce free_has_hwpoisoned() to only free the healthy pages
and to exclude the HWPoison ones in the high-order folio.
The idea is to iterate through the sub-pages of the folio to
identify contiguous ranges of healthy pages.

free_has_hwpoisoned() is added in free_pages_prepare() as
a shortcut and is only invoked if PG_has_hwpoisoned indicates
HWPoison page exists and after checks and preparations in
free_pages_prepare() all succeeded. free_has_hwpoisoned() then
can re-use free_prepared_contig_range() [4] to decompose healthy
ranges into the largest possible chunks of different orders.
Every chunk meets the requirements to be freed via free_one_page().

free_has_hwpoisoned() has linear time complexity wrt the number
of pages in the folio. While the power-of-two decomposition
ensures that the number of calls to the buddy allocator is
logarithmic for each contiguous healthy range, the mandatory
linear scan of pages to identify PageHWPoison() defines the
overall time complexity. For a 1G hugepage having 8 HWPoison
pages, free_has_hwpoisoned() takes around 1ms on average on
a system having 56 Intel Skylake physical cores. This is
15x to the case of freeing no HWPoison page. The cost is far
from triggering soft lockup, and fair for handling exceptional
hardware memory errors.

[1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net
[2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net
[3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
[4] https://lore.kernel.org/all/20260401101634.2868165-2-usama.anjum@arm.com

Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 mm/page_alloc.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e47679e7a9db..03df929abca6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -208,6 +208,7 @@ gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
 unsigned int pageblock_order __read_mostly;
 #endif
 
+static void free_has_hwpoisoned(struct page *page, unsigned int order);
 static void __free_pages_ok(struct page *page, unsigned int order,
 			    fpi_t fpi_flags);
 static void reserve_highatomic_pageblock(struct page *page, int order,
@@ -1309,6 +1310,14 @@ static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned int nr)
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
+/*
+ * Returns
+ * - true: checks and preparations all good, caller can proceed freeing.
+ * - false: do not proceed freeing for one of the following reasons:
+ *   1. Some check failed so it is not safe to proceed freeing.
+ *   2. A compound page has some HWPoison pages. The healthy pages
+ *      are already safely freed, and the HWPoison ones isolated.
+ */
 static __always_inline bool __free_pages_prepare(struct page *page,
 		unsigned int order, fpi_t fpi_flags)
 {
@@ -1317,6 +1326,15 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 	bool init = want_init_on_free();
 	bool compound = PageCompound(page);
 	struct folio *folio = page_folio(page);
+	/*
+	 * When dealing with compound page, PG_has_hwpoisoned is cleared
+	 * with PAGE_FLAGS_SECOND. So the check must be done first.
+	 *
+	 * Note we can't exclude PG_has_hwpoisoned from PAGE_FLAGS_SECOND.
+	 * Because PG_has_hwpoisoned == PG_active, free_page_is_bad() will
+	 * confuse and complaint that the first tail page is still active.
+	 */
+	bool should_fhh = compound && folio_test_has_hwpoisoned(folio);
 
 	if (fpi_flags & FPI_PREPARED)
 		return true;
@@ -1443,6 +1461,16 @@ static __always_inline bool __free_pages_prepare(struct page *page,
 
 	debug_pagealloc_unmap_pages(page, 1 << order);
 
+	/*
+	 * After breaking down compound page and dealing with page metadata
+	 * (e.g. page owner and page alloc tags), take a shortcut if this
+	 * was a compound page containing certain HWPoison subpages.
+	 */
+	if (should_fhh) {
+		free_has_hwpoisoned(page, order);
+		return false;
+	}
+
 	return true;
 }
 
@@ -6936,6 +6964,63 @@ void __free_contig_range(unsigned long pfn, unsigned long nr_pages)
 	__free_contig_range_common(pfn, nr_pages, /* is_frozen= */ false);
 }
 
+/*
+ * Given a high-order compound page containing certain number of HWPoison
+ * pages, free only the healthy ones.
+ *
+ * Pages must have passed free_pages_prepare(). Even if having HWPoison
+ * pages, breaking down compound page and updating metadata (e.g. page
+ * owner, alloc tag) can be done together during free_pages_prepare(),
+ * which simplifies the splitting here: unlike __split_unmapped_folio(),
+ * there is no need to turn split pages into a compound page or to carry
+ * metadata.
+ *
+ * It scans every raw page of the compound page and cause nontrivial overhead.
+ * So only use this when the compound page contains HWPoison page(s).
+ *
+ * This implementation needs rework in memdesc world.
+ */
+static void free_has_hwpoisoned(struct page *page, unsigned int order)
+{
+	unsigned long curr = page_to_pfn(page);
+	unsigned long end_pfn = curr + (1 << order);
+	unsigned long next;
+	unsigned long total_freed = 0;
+	unsigned long total_hwp = 0;
+
+	VM_WARN_ON(order == 0);
+	VM_WARN_ON(page->flags.f & PAGE_FLAGS_CHECK_AT_PREP);
+
+	while (curr < end_pfn) {
+		next = curr;
+
+		while (next < end_pfn && !PageHWPoison(pfn_to_page(next)))
+			++next;
+
+		if (next != end_pfn && PageHWPoison(pfn_to_page(next))) {
+			/*
+			 * Avoid accounting error when the page is freed
+			 * by unpoison_memory().
+			 */
+			clear_page_tag_ref(pfn_to_page(next));
+			++total_hwp;
+		}
+
+		free_prepared_contig_range(pfn_to_page(curr), next - curr);
+		total_freed += next - curr;
+
+		if (next == end_pfn)
+			break;
+
+		VM_WARN_ON(!PageHWPoison(pfn_to_page(next)));
+		curr = next + 1;
+	}
+
+	VM_WARN_ON(total_freed + total_hwp != (1 << order));
+	pr_info("Freed %#lx pages, excluded %lu HWPoison pages\n",
+		total_freed, total_hwp);
+}
+
 #ifdef CONFIG_CONTIG_ALLOC
 /* Usage: See admin-guide/dynamic-debug-howto.rst */
 static void alloc_contig_dump_pages(struct list_head *page_list)
-- 
2.54.0.823.g6e5bcc1fc9-goog


