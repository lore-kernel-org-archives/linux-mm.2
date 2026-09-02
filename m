Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC24DC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 02:57:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31ECD6B0092; Tue,  1 Sep 2026 22:57:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6006B0095; Tue,  1 Sep 2026 22:57:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1979B6B0096; Tue,  1 Sep 2026 22:57:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DBB4D6B0092
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:57:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 557461206CA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:57:09 +0000 (UTC)
X-FDA: 85167310578.11.9014137
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id 871FE80003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:57:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=CRPvpefM;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai;
	spf=pass (imf30.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.214.174 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788317827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gdt9O9DrbfD0+uxbYBw0LbC/ktAZ2LjIUSYy5m+59wc=;
	b=gzGOwPfJapPiDM/rGVmYRgWCBBUqzRkLPOP81NXL5otHbZubeDBFgScRfYLHrG78VbTqER
	UoswNSPlGhdx7UOs4Yyfz2dNHh3cKqE+svGoHKUCCKDALa3lN1dj/V/dD9yafVplZMYEel
	XjCLaoglmREKk7szlKeXMS1SfIbWSW8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788317827;
	b=R2vWc8r28cA7nuhTedOKrNPquJdopHnEOBUd5L1x7Nlm8+ZKw2cXSV/cDK5V8ib98UpV0f
	M4YyPwCIiG6CE/ChqrzrdqkF7al6Ei2aOLHaJz5NoiYo+06h3M3R6QOegUKkTAWYnWPot7
	1xuAvGWJHjlYrLLhd0h2NIW1QB1txvo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=CRPvpefM;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai;
	spf=pass (imf30.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.214.174 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2d942c7cc2fso4217965ad.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 19:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=crusoe.ai; s=google; t=1788317826; x=1788922626; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gdt9O9DrbfD0+uxbYBw0LbC/ktAZ2LjIUSYy5m+59wc=;
        b=CRPvpefMWnGR7yCPplc4HM0R0K1sdfzxO506XNoqTYXXWq1Dtoh1IGbzpcMFdVe3C/
         JICiUA88mWOrEsNuPs9V0CgskhY0EeZK7FnWOUU9MIv9BiP43+BNLLr+Ml7dCm3caAv8
         FEzLPJMTD/V+SaW0v4lY1YO9vrI/weWJULVNxCMZqCVMPrnCiCWqw5iZX6cJj/9k3p60
         mRjFKK7pj3QemPgoABLyj7cpa+9twXcBR2QdRLqmS9Kkkbc5FRKkwd28yVpw91ziqyEw
         JdonWX72jXSLzrCpJq1we72VmuYb2RnWkUVSYkNWldFTL0Qut5CW68sYgXw2hVEQZ9vI
         gRhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788317826; x=1788922626;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gdt9O9DrbfD0+uxbYBw0LbC/ktAZ2LjIUSYy5m+59wc=;
        b=j/Uq1P2IfGEc4WPTKnjvoPXY3GmLVLADTlRsdMIu/N2UCKxqYgIBuPu1Ind8QgbkhZ
         OS31gSYojatdLU+JE1M59Q4btxPdKt4edcjNXZdBae57H7s/Sv2viHAwaOihu3Rp6P/s
         0S1/3tOjw8sZKJKJvb5HaOJp0hYaBnH7pJXHLVPZ37slSTMEZqgY+uzq8p1hKuOcpwum
         Sr7RZy7/lot9mgiXSvdpHemjj832txqSg+/MHqox2HJplC4IZM1akHvz7Hsb9W3oXkSW
         B4UmcfLSX+kShflSUCOV1cPl00dHI4kyO4JPVH5tEpMxFa0ZNU7Ofh2U3cF6l36Y/SL5
         imIQ==
X-Forwarded-Encrypted: i=1; AKwUvBymQRRRVxCjAQS62SUAKzewN0RQXmD1R2/2s0PITkmQm+1leVaXc7rJIm0f3FiFWpa1ZwK7CUnrOA==@kvack.org
X-Gm-Message-State: AFuF++nlBVk4ZDdDONKw6ddTHB4JLNRUrCmoI7PnWqJlwdZzG+DnfvdT
	Wy2/KSN0x5UzlIoK+AhDYAHQxi67sdJPVTzmLcJrM/NuPG0mXSW7linvbU/n8Bw+yVM=
X-Gm-Gg: AYBFou0b3zyhCGAJzYptTbFLa9xnOqlIglCimHizp5vu8ZHI/WCXpo+tS8dAGGH+R/O
	stnswGbhWqtwvxkFy6H7DiwHS4Hmg6ejWxnPdsWoKkcF2j5pKloEE4HDVN8Yk+/526NAqMcJtpg
	EKqB1zJQ/soIqukp4JXiUIhh3+kdGMLhpS7TyRGTym/iAGTNSJAyVHZpXSFWbCOCbOA7nUOFmqP
	fZYu4yuCPLuFICEx+hWbuKa2GsOMmXD7A48mpqrQ/C1n+Rnpo5fPkBhSIYA2m3IGZS1i7KBLTZM
	mqzaavee3oFv7DbCcw/Sh4WlqTFONkLzbKk3Y2qeRHfcWGja3GXcz4a+KH5pd7qFAIuCNZ7xi4F
	yUOor3gJniGsYmB9w1WCwX1qGh85USpmOrs7YbAvRq9a6KUHb5zsjmG/UWJyCEbEj03yd2ENogo
	LhpjUPzuzm8ngK7W7n7OZPBHSxwxDr3/7kE5ixv2uI9qSEGGGegZQonp2C5u9Hnf/fpYRjuFtzE
	bfjflXbKjcBevOsrLtkdsp5AhyUwvxCGWpg
X-Received: by 2002:a17:90b:52c8:b0:398:9be9:ab8f with SMTP id 98e67ed59e1d1-39aee125891mr2168853a91.20.1788317826404;
        Tue, 01 Sep 2026 19:57:06 -0700 (PDT)
Received: from MBP-Krishna-Iyer.civet-hops.ts.net ([2601:645:c68a:b830:a1c2:77c:7ab7:f9a0])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32f07bde5bfsm2066469eec.27.2026.09.01.19.57.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 01 Sep 2026 19:57:06 -0700 (PDT)
From: Krishna Iyer <kiyer@crusoe.ai>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] mm/damon/paddr: support hugetlb folios in access monitoring
Date: Tue,  1 Sep 2026 19:57:00 -0700
Message-ID: <20260902025700.17975-4-kiyer@crusoe.ai>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260902025700.17975-1-kiyer@crusoe.ai>
References: <20260902025700.17975-1-kiyer@crusoe.ai>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 871FE80003
X-Stat-Signature: 9w73qnnut4x953skm16d7zdbywaa1ngi
X-Rspam-User: 
X-HE-Tag: 1788317827-20739
X-HE-Meta: U2FsdGVkX19iUHNtWJXIyxqvIGFw11o+PCgP7Yhx9k+If+n2lSVKP4enJWfaqTr33cYcT6WVVpPB2cpgapA8nODo61xd0T7KM3bq+pCOoO/tLx/a2JlkAUTOAetWGh2LM4CrHHABhgXy6hpcWFJoTP/LoncqVrBLnANq44dh4KEyDm+Wfp4uDlA3iQZU4Or1zXG5F/tRxHVt4qwQae5xtPnyuc2lkA4VwGzN1KcZXNzai3DwbgBzWlsHhQO0TXbG+M8MDe/xZAf1YpSry76WCaCuSbtIqdkTOpyTBjiw2po6QCE5DbpqC3IJo4rRDlbBTWtAdTzJQMkR96OmRdPcl4Psy2jfMfAPNJ0wRQ0d6YYUh4Nm9aat4bRr6Y7Ay1O8fUiHqVJWF27Wjpy7O7y+57ZXgOKse8CHa32qvReKr9n8SceZV4cjM1RaMYuwWKiyDhC9mnYjvyFlzHpQDDPwX933qdaBrvpX9Gc4Lg2o46ohMQ+TBqAzY7trfegWq52YP/V0hAsihpKYmy1GKCKyk/UMgsAiw84f2suiBRF+OFEoXDsj+IPgNNxi44Hq0iwJVh7b6VNGdrexdKsP17Vytnyvx04zvoEth6s1NIQ6YCuyczsZp7FP4xpEb/aU1Z51bDK6pDnqOHzS5h5yYdcjsiZ1hLPX6252TRyBl+ftF1s5WwtOZDBEU6xVFP8v1VjHTfYUd4MLqkjqGm8WoGAE/jKSxTz5nhMGGfY400B5xzpd3Uk+F51boc6CMY6lLQDU1z0KqtY3BMlQvmVUnYolRHS6PmSjABYC/EggotA1bkokXwZePrupi455HS7LkyINefwWHPZZxS2mObeoHFL5MGMsARba5L5QPBDzjY1P1GenLzuJ2C77CQFWBc/iaydWcsV9278aWjAMUeJyEDoJNtai5WcdsU9NV88Xogm+EPywuC25mvQDidxnj7zQxDjcgXNvB7Su4WYOzfRa48X
 RaSbhY4j
 UbEp8fRSOs2siXyJ4XLaaIKlcVd+WxRMdbMdtVqp7yCPIMnmjzOCihL4WPmhiRocEBKTdnqtBENLhg3S0jZf+2JKVH0h8Q5il0Dy+4VzKjGhQMhUgXwzXniopDVhAOie+vEL2pn+SFVOytE9lS7yAvTwf5mZ92GE+idM6vS83HII698AIHtQyZgM5F+XzWa1YqagEjgvnLRvXHtgojJTGOxuIHD+KmBfZ8RX5W8Jh5YzXx5fIliJZZ3f4rV2ZATkPt14s/feGxeyIwQx+NNKT7fc+xdxbGyGAxsqmJOZ1JQSb4SwDP+U/2vakkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON's physical address space monitoring is blind to hugetlb-backed
memory.  Every access check starts at damon_get_folio(), which rejects
folios that are not on the LRU lists.  Hugetlb folios are managed
outside of the LRU by design, so every sampling attempt on
hugetlb-backed memory silently fails and the pages are reported as
never accessed.

This is a significant blind spot on virtualization hosts.  Cloud
hypervisor hosts commonly back guest memory with 1 GiB hugetlbfs pages,
covering the vast majority of the machine's memory.  On such hosts,
modules like DAMON_STAT observe only the host-side remainder (page
cache, daemons) and report all guest working sets as permanently
idle, defeating the purpose of host-level access monitoring.  In
testing on a 1 TiB host, an hour of 4-thread random access over 842 GiB
inside a guest was statistically indistinguishable from an idle host,
while a 40x smaller host-side workload produced a quantitatively
correct response.

Add damon_get_monitor_folio(), which additionally accepts hugetlb
folios, and use it in the two paddr access monitoring primitives,
damon_pa_mkold() and damon_pa_young().  With the previous commit
teaching the folio-granular rmap walkers to age huge PTEs and to call
the mmu notifiers spanning the whole huge page, this makes guest
accesses visible through secondary MMU (e.g. KVM/EPT) young bits.

Free hugetlb pool folios have a zero refcount, so folio_try_get()
naturally keeps rejecting them.

The DAMOS action appliers (damon_pa_pageout(),
damon_pa_mark_accessed_or_deactivate(), damon_pa_migrate(),
damon_pa_stat()) keep using damon_get_folio(): reclaim, LRU
manipulation and migration cannot act on hugetlb folios, so their
behavior is unchanged.

Note that the access check granularity for hugetlb-backed memory is the
huge page size: one touched byte reports the whole (up to 1 GiB) page
as accessed.  Also, DAMON now consumes secondary MMU young bits that
KVM's own aging uses; at DAMON's sampling rate (one page per region per
sampling interval) the interference is negligible.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
---
 mm/damon/ops-common.c | 31 +++++++++++++++++++++++++++----
 mm/damon/ops-common.h |  1 +
 mm/damon/paddr.c      |  4 ++--
 3 files changed, 30 insertions(+), 6 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 373b25db5950..80207b56c6fd 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -15,14 +15,20 @@
 #include "../internal.h"
 #include "ops-common.h"
 
+static bool damon_folio_acceptable(struct folio *folio, bool monitor)
+{
+	return folio_test_lru(folio) ||
+		(monitor && folio_test_hugetlb(folio));
+}
+
 /*
- * Get an online page for a pfn if it's in the LRU list.  Otherwise, returns
- * NULL.
+ * Get an online page for a pfn if it's in the LRU list, or a hugetlb folio if
+ * @monitor is set.  Otherwise, returns NULL.
  *
  * The body of this function is stolen from the 'page_idle_get_folio()'.  We
  * steal rather than reuse it because the code is quite simple.
  */
-struct folio *damon_get_folio(unsigned long pfn)
+static struct folio *__damon_get_folio(unsigned long pfn, bool monitor)
 {
 	struct page *page = pfn_to_online_page(pfn);
 	struct folio *folio;
@@ -33,13 +39,30 @@ struct folio *damon_get_folio(unsigned long pfn)
 	folio = page_folio(page);
 	if (!folio_try_get(folio))
 		return NULL;
-	if (unlikely(page_folio(page) != folio) || !folio_test_lru(folio)) {
+	if (unlikely(page_folio(page) != folio) ||
+			!damon_folio_acceptable(folio, monitor)) {
 		folio_put(folio);
 		folio = NULL;
 	}
 	return folio;
 }
 
+struct folio *damon_get_folio(unsigned long pfn)
+{
+	return __damon_get_folio(pfn, false);
+}
+
+/*
+ * Same to damon_get_folio(), but also accepts hugetlb folios, which are
+ * managed outside of the LRU lists.  Aimed to be used by access monitoring
+ * primitives.  DAMOS actions that assume LRU-managed folios should keep using
+ * damon_get_folio().
+ */
+struct folio *damon_get_monitor_folio(unsigned long pfn)
+{
+	return __damon_get_folio(pfn, true);
+}
+
 void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr)
 {
 	pte_t pteval = ptep_get(pte);
diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
index f7811c9c7a02..172f0f17c4a8 100644
--- a/mm/damon/ops-common.h
+++ b/mm/damon/ops-common.h
@@ -6,6 +6,7 @@
 #include <linux/damon.h>
 
 struct folio *damon_get_folio(unsigned long pfn);
+struct folio *damon_get_monitor_folio(unsigned long pfn);
 
 void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr);
 void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr);
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5c6c3a597fd0..ed7b7f31291a 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -37,7 +37,7 @@ static unsigned long damon_pa_core_addr(
 
 static void damon_pa_mkold(phys_addr_t paddr)
 {
-	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
+	struct folio *folio = damon_get_monitor_folio(PHYS_PFN(paddr));
 
 	if (!folio)
 		return;
@@ -67,7 +67,7 @@ static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
 
 static bool damon_pa_young(phys_addr_t paddr)
 {
-	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
+	struct folio *folio = damon_get_monitor_folio(PHYS_PFN(paddr));
 	bool accessed;
 
 	if (!folio)
-- 
2.54.0


