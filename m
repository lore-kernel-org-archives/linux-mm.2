Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72BADCAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 05:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774A88E000B; Tue, 30 Sep 2025 01:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 723888E0002; Tue, 30 Sep 2025 01:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 639CA8E000B; Tue, 30 Sep 2025 01:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B83F8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 01:48:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9B17C05A6
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:48:42 +0000 (UTC)
X-FDA: 83944837284.09.61050A0
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id 43A3614000B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 05:48:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pmySo2y1;
	spf=pass (imf09.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759211321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nwaNOsPaMPcKzgmglNmEscXlbXRyMv0Han6sLSHWCaw=;
	b=TqQRgV81hGZKd5NXhDDkBMtteIresWg5YUN0IguCuD6Kg0WTXQb/yLZJiFzncHS4nWmRTM
	e2QLw3fyRdLVEsvIKP/KFDOaWBQOD1mu01iHnPaDBS2bLTaWwg0We1VZYqU6cpSCgLx43O
	qPIyo+QPNtcOvw1LUUgN46+WH66PGhw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759211321; a=rsa-sha256;
	cv=none;
	b=Jq2fRKB7ozOQRTWjhh0fgOKDKdIyX0g6Q/dOHX2ZymagXEbZUWZnoCvfc2iWyROGFSS33H
	S6+aaB/RltjV5I9y1+N92ESJcNBdD6vfEEAjQ/kQJ7tUSA3f5P5kVH2ig1tdwZoDtoVVHH
	BQZ2NZInCvkiwuUAdMC64mAzqg+nQcQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pmySo2y1;
	spf=pass (imf09.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759211319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nwaNOsPaMPcKzgmglNmEscXlbXRyMv0Han6sLSHWCaw=;
	b=pmySo2y1mTUj+Hr/IcBN2zZF4HXhBVlZfNevClLH2GLrdQbgELHVg/tH2snIP35hUgWF5D
	GtGv3022ovPF1dxHmfPX6ELwctMadEKOPOGRuci7evFLZ3qI8xyt0eE/BinJpQoVaUnE9o
	BsNLPkkhumB/Lx+JR8Lex2DfmeVAJfM=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org
Subject: [PATCH] mm: readahead: make thp readahead conditional to mmap_miss logic
Date: Tue, 30 Sep 2025 07:48:15 +0200
Message-ID: <20250930054815.132075-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 43A3614000B
X-Stat-Signature: z4i6dsqxd7cn39dwx9inf8zdxkgjtfb1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759211321-675389
X-HE-Meta: U2FsdGVkX18fKJe6pXEE5OJRQBqtB5x/NSixFD/fc5Sl4DI4YfIuxn4VA5xIZzcwS08Sk/TzYowweV9nSF4AiqOcmtydrltncGyHsAex+uGpDdEZfjoNjZx3P+300YHWQaYVJ6wGRzwKbiqoV7UxTI8n++oYTA8wGroNOq+1xz/1y8/SGbrsUIkoKvc/y2CN6N91nyPNAWKIGEZ5ITJxLxppR2cU82kKltBo6EmIjtQbfTEYquagqZ24LRQuPWyRGfNbqjb46VckAAhq0KTaqftiMTIYt7FPpgVEkl4ISJH5jgo1J/ac7fOtk3W9s/DVxxdhowTqYfKScALUVV4AoHBnJ59J//U7SP1Webym98OPanzhobKd9RurYOk6DGEFTDeWiune/dbtISWgr5q49xhWfFK23yzdVR4VYudWgci2j6pV21vLS/D0RJTqubYoE/AFOlwIjXSI1NCNYteT6TlM+KdWTd05OvRj3T7I7DWdRT0Cc6UszngK9lBKN0gkU0OctVmQ9mhUIvKefCxnW9qoAoTTZN1saA+gLQUvrEQYIwTVTnyeaVORs0eRuMbZ9ZGs9QAHB+2OcN1JsaIeBMlHTFM5qMVQzlU/4RkRf98uSa1FpyMAS7m5oJRNsWpMIyR744xXg/W9ijH4F7XX4xENiilCuaXL8fRdwIeJSKLiAeARCREXJHIENbJtBPU/ta2ffO+9mfh0Kj6DnWqTCIedPkZC4Pqd2p1uz7XDKSx/TJ6Vt7Ar5Xnn/cTRqia/FxH5Th2wVjbEB8PG+GrYiDCG+b58hrAo9kXFhLWwEvrC+dhPCqDGz7eW84htNO3mpl5lPtamUM8xkOdP7+L+AqpQqh9B5JST6U1mi71S+n2VGd5d8TZ8oxg7t0n8onwvJfsVYHh7sO8CbyZvi5ingCS6TY/TjZ4NOxMEBcmVZ4oeq4Um5n4sU4fUy3FNFeADYfnAuYdmTIOu5gp1zJc
 lOJ8sRFj
 3d0ul/hnPZfpMcHOg2dVneQ/qCHBF39pzsoOf0pDiJVb84o2zY1DmMAH3yiOIustzd5POdmFLMzYs+avnb++4mxXU1kidNyJbnO/3h14Zmam7aIaeIjqiBlz7+p3hrjzlFeAPxTJKsniyclZSFb+4v8ivpswrQsahf2uVNdTFdsJgWPjfZZnVJtCE3AIPUTcclr/IMH1vSxd7jM+RsgAnPEgiMpus+6s29h7EKoGKuFfKRXkmHml013hhAhv8YnLsTpsxJVkoE3FDpBFoDWvOngH3YEBaMQkfa5FpU3SaY2x9oVwAgQ3AMB+DE6/ozbw0Uz+8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
introduced a special handling for VM_HUGEPAGE mappings: even if the
readahead is disabled, 1 or 2 HPAGE_PMD_ORDER pages are
allocated.

This change causes a significant regression for containers with a
tight memory.max limit, if VM_HUGEPAGE is widely used. Prior to this
commit, mmap_miss logic would eventually lead to the readahead
disablement, effectively reducing the memory pressure in the
cgroup. With this change the kernel is trying to allocate 1-2 huge
pages for each fault, no matter if these pages are used or not
before being evicted, increasing the memory pressure multi-fold.

To fix the regression, let's make the new VM_HUGEPAGE conditional
to the mmap_miss check, but keep independent from the ra->ra_pages.
This way the main intention of commit 4687fdbb805a ("mm/filemap:
Support VM_HUGEPAGE for file mappings") stays intact, but the
regression is resolved.

The logic behind this changes is simple: even if a user explicitly
requests using huge pages to back the file mapping (using VM_HUGEPAGE
flag), under a very strong memory pressure it's better to fall back
to ordinary pages.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org
---
 mm/filemap.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index a52dd38d2b4a..b67d7981fafb 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3235,34 +3235,20 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
 	struct file *fpin = NULL;
 	vm_flags_t vm_flags = vmf->vma->vm_flags;
+	bool force_thp_readahead = false;
 	unsigned short mmap_miss;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	/* Use the readahead code, even if readahead is disabled */
-	if ((vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER) {
-		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
-		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
-		ra->size = HPAGE_PMD_NR;
-		/*
-		 * Fetch two PMD folios, so we get the chance to actually
-		 * readahead, unless we've been told not to.
-		 */
-		if (!(vm_flags & VM_RAND_READ))
-			ra->size *= 2;
-		ra->async_size = HPAGE_PMD_NR;
-		ra->order = HPAGE_PMD_ORDER;
-		page_cache_ra_order(&ractl, ra);
-		return fpin;
-	}
-#endif
-
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
+		force_thp_readahead = true;
 	/*
 	 * If we don't want any read-ahead, don't bother. VM_EXEC case below is
 	 * already intended for random access.
 	 */
 	if ((vm_flags & (VM_RAND_READ | VM_EXEC)) == VM_RAND_READ)
 		return fpin;
-	if (!ra->ra_pages)
+	if (!ra->ra_pages && !force_thp_readahead)
 		return fpin;
 
 	if (vm_flags & VM_SEQ_READ) {
@@ -3283,6 +3269,22 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	if (mmap_miss > MMAP_LOTSAMISS)
 		return fpin;
 
+	if (force_thp_readahead) {
+		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
+		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
+		ra->size = HPAGE_PMD_NR;
+		/*
+		 * Fetch two PMD folios, so we get the chance to actually
+		 * readahead, unless we've been told not to.
+		 */
+		if (!(vm_flags & VM_RAND_READ))
+			ra->size *= 2;
+		ra->async_size = HPAGE_PMD_NR;
+		ra->order = HPAGE_PMD_ORDER;
+		page_cache_ra_order(&ractl, ra);
+		return fpin;
+	}
+
 	if (vm_flags & VM_EXEC) {
 		/*
 		 * Allow arch to request a preferred minimum folio order for
-- 
2.51.0


