Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D01C3EB105A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 14:54:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DC5A6B00B6; Tue, 10 Mar 2026 10:54:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A68B6B00B8; Tue, 10 Mar 2026 10:54:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09EFB6B00BA; Tue, 10 Mar 2026 10:54:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E92786B00B6
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:54:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 826AB140210
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:54:49 +0000 (UTC)
X-FDA: 84530450298.21.AB56123
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id B7221C000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:54:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LmrODPSV;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773154488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGK3lb1Gl4HCpee4Gph+9eiHmaXQeXqY6khXIDpX7y0=;
	b=JJAnwM3PwjfSr0C+1EDDTZJ88PU8Zjeq50gNNjEx97al1uh7UNRHp4RCTwlpRD5s4MLsmG
	BBJ22Tew7zBFJy1TuTuplyD77RgGvGuA+nBXJ9CDgiPT3fEJNS4QQ/k+mXvZM+F5p5Tkqm
	ErHGcC7fDEqnpKC69cI2W2ISfSL9igU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LmrODPSV;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773154488; a=rsa-sha256;
	cv=none;
	b=uLZ1ub+PbAXGYTOZ+YS5mrVMCAxxzKxEVISwFWeOAxd9z0OjC0PbZNbNKFN2CkwclDjTdZ
	9Y79BQFYK9NpBBuAKfWKP1LsY8k/EAZ92iZ2h/FZucO7vbQ3xeFu/+HsoZWyjMJRHTzQ/4
	H1MofwUG1yYZT0IWtmYioP2yfgaZNK0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773154485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cGK3lb1Gl4HCpee4Gph+9eiHmaXQeXqY6khXIDpX7y0=;
	b=LmrODPSVrXpm2EmXagV1g0RUXMxioQTzpSwL5eNBUJ9rkDCjz6bNRfo8KV+CqZRbnHjE68
	I8WEXf5qsZGH5CDbqxlCSz2yMBlvWrR6/6lzTS3KHT+IOo4Pw70p5ooXE//x8R2klmN4qF
	c7PhpqQjMaabhHUGcyJnaSnjqP8H69o=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	ryan.roberts@arm.com,
	david@kernel.org
Cc: ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	dev.jain@arm.com,
	jack@suse.cz,
	kees@kernel.org,
	kevin.brodsky@arm.com,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	rmclure@linux.ibm.com,
	Al Viro <viro@zeniv.linux.org.uk>,
	will@kernel.org,
	willy@infradead.org,
	ziy@nvidia.com,
	hannes@cmpxchg.org,
	kas@kernel.org,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 2/4] mm: bypass mmap_miss heuristic for VM_EXEC readahead
Date: Tue, 10 Mar 2026 07:51:15 -0700
Message-ID: <20260310145406.3073394-3-usama.arif@linux.dev>
In-Reply-To: <20260310145406.3073394-1-usama.arif@linux.dev>
References: <20260310145406.3073394-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B7221C000A
X-Stat-Signature: 389w9nox9g9rau89y9mxonjtej5u64t7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773154487-76468
X-HE-Meta: U2FsdGVkX19Pb7ISyxUqUv0CHM575vGAZEqGOtvn4lkwAtdJo70qzzTM0gl9UzNDN55tf8A+rUJRyQdchMAj9c0B0+Ar/ydIADRt6cA3zyBdMw9wsMWSE5+C+PVS4S116AczlEBh4gpx4E9oz+pnDIzkfN2HLOQ/niVgsdem3bM4Ex6grvIhMMYMu2hBhZGQqXK38Htq5kwIFgeIc80BJSWddEZfH7iJxQ793UR6ube1tBIOdQqA6DTt9to+thkEV3Ur7ckHYGc5JZaBWZisH9601Qc1F1V05GuPBI8PYMldqVkOhK0c/hUj3qoBOi7CRsx+O7l01TwHv1iRoJgte3iqq0YYqVNiyiaRe0qHBvC4ZaWEZNagZVAO+R95eEATs4UbKjUnk4QIO0/wXT6sZ1QEZ1GCt68AvMb/+6t3j1AT+1zte+DMaNp1NImgfgxKLhxR+QApcahmly3o9ILPr0PpWxmUrRydAtHpD+uCrGx5lCup+QnI3Yl++QhyTGvCuI1GjelBQcDYqQGoYvTR1pP3S0hHQ83nDD2nBjHJ9bJK+/BUhmbkwi6FUU8b3Ynmb8vqACNxM++YzFN6VVEmYaPghEPMUm4DK/jA/jZ1eiM0nQQ3FFmx5ZkvMXTNetuqaQtdkp99Z3c83IKvUuT5tyPZ0IhBFOita5HzUel8GicvIR2uEoDEbFSwMAhm8uj9IgTVXDWPrChNmNJG4JH3g9UDdwvJRv8QU8DVYGcmI3Lv0LxpFCFjqe25hcmaTdYW4KnTkvPzuKFb2NZGjgjdJvMqJBehJjymxqdu7fDAoPUaNOB89okD7IletqnlKAYNIQF6s/khFirqVwCg2X5u4uJTH+BLH6BRCRtMr9ezqQRvnVA/3578f+NUpwxjqWqYVrnPGRwDBSlo73N6tPQsV1e5gac231w3d9tSwwu/J08cmim52iIVA9sYENTf/bzg6KY4XchyYCM21VJYiiw
 0anegS+n
 L64aD8TLli9IjaMRXskwEcdVGrDTtRiUXUOk0NONn9l2QweeolbIbBicF9iGXkAJEmSOeWYnGM+OrRfWOgiZMug+CCfFjHTBialRXxrVQ72gXMsEcEgRI+g+y1FK6TNkVgWtM7CSJomEQBtyvwW9scgGr9yk3mrYmF0o7QxdRghMbcfM8MdHf0cZ1aPM0uFkex07rrltX6Sr2chbeVK+Z6rQXXRqMsCoUqZtHpAkeuoBVXgztVHUbz20s7xts//UB6vw9oKosQIrM8cjF/dETiBl7+T3F+bDYQdLsi++xeNRHBo09JFz/AU+O3PpfGrvCndklyzSE9stFXsE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mmap_miss counter in do_sync_mmap_readahead() tracks whether
readahead is useful for mmap'd file access. It is incremented by 1 on
every page cache miss in do_sync_mmap_readahead(), and decremented in
two places:

  - filemap_map_pages(): decremented by N for each of N pages
    successfully mapped via fault-around (pages found already in cache,
    evidence readahead was useful). Only pages not in the workingset
    count as hits.

  - do_async_mmap_readahead(): decremented by 1 when a page with
    PG_readahead is found in cache.

When the counter exceeds MMAP_LOTSAMISS (100), all readahead is
disabled, including the targeted VM_EXEC readahead [1] that requests
arch-preferred folio orders for contpte mapping.

On arm64 with 64K base pages, both decrement paths are inactive:

  1. filemap_map_pages() is never called because fault_around_pages
     (65536 >> PAGE_SHIFT = 1) disables should_fault_around(), which
     requires fault_around_pages > 1. With only 1 page in the
     fault-around window, there is nothing "around" to map.

  2. do_async_mmap_readahead() never fires for exec mappings because
     exec readahead sets async_size = 0, so no PG_readahead markers
     are placed.

With no decrements, mmap_miss monotonically increases past
MMAP_LOTSAMISS after 100 page faults, disabling all subsequent
exec readahead.

Fix this by moving the VM_EXEC readahead block above the mmap_miss
check. The exec readahead path is targeted. It reads a single folio at
the fault location with async_size=0, not speculative prefetch, so the
mmap_miss heuristic designed to throttle wasteful speculative readahead
should not gate it. The page would need to be faulted in regardless,
the only question is at what order.

[1] https://lore.kernel.org/all/20250430145920.3748738-6-ryan.roberts@arm.com/

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/filemap.c | 72 ++++++++++++++++++++++++++++------------------------
 1 file changed, 39 insertions(+), 33 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 6cd7974d4adab..c064f31ecec5a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3331,6 +3331,37 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		}
 	}
 
+	if (vm_flags & VM_EXEC) {
+		/*
+		 * Allow arch to request a preferred minimum folio order for
+		 * executable memory. This can often be beneficial to
+		 * performance if (e.g.) arm64 can contpte-map the folio.
+		 * Executable memory rarely benefits from readahead, due to its
+		 * random access nature, so set async_size to 0.
+		 *
+		 * Limit to the boundaries of the VMA to avoid reading in any
+		 * pad that might exist between sections, which would be a waste
+		 * of memory.
+		 *
+		 * This is targeted readahead (one folio at the fault location),
+		 * not speculative prefetch, so bypass the mmap_miss heuristic
+		 * which would otherwise disable it after MMAP_LOTSAMISS faults.
+		 */
+		struct vm_area_struct *vma = vmf->vma;
+		unsigned long start = vma->vm_pgoff;
+		unsigned long end = start + vma_pages(vma);
+		unsigned long ra_end;
+
+		ra->order = exec_folio_order();
+		ra->start = round_down(vmf->pgoff, 1UL << ra->order);
+		ra->start = max(ra->start, start);
+		ra_end = round_up(ra->start + ra->ra_pages, 1UL << ra->order);
+		ra_end = min(ra_end, end);
+		ra->size = ra_end - ra->start;
+		ra->async_size = 0;
+		goto do_readahead;
+	}
+
 	if (!(vm_flags & VM_SEQ_READ)) {
 		/* Avoid banging the cache line if not needed */
 		mmap_miss = READ_ONCE(ra->mmap_miss);
@@ -3361,40 +3392,15 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		return fpin;
 	}
 
-	if (vm_flags & VM_EXEC) {
-		/*
-		 * Allow arch to request a preferred minimum folio order for
-		 * executable memory. This can often be beneficial to
-		 * performance if (e.g.) arm64 can contpte-map the folio.
-		 * Executable memory rarely benefits from readahead, due to its
-		 * random access nature, so set async_size to 0.
-		 *
-		 * Limit to the boundaries of the VMA to avoid reading in any
-		 * pad that might exist between sections, which would be a waste
-		 * of memory.
-		 */
-		struct vm_area_struct *vma = vmf->vma;
-		unsigned long start = vma->vm_pgoff;
-		unsigned long end = start + vma_pages(vma);
-		unsigned long ra_end;
-
-		ra->order = exec_folio_order();
-		ra->start = round_down(vmf->pgoff, 1UL << ra->order);
-		ra->start = max(ra->start, start);
-		ra_end = round_up(ra->start + ra->ra_pages, 1UL << ra->order);
-		ra_end = min(ra_end, end);
-		ra->size = ra_end - ra->start;
-		ra->async_size = 0;
-	} else {
-		/*
-		 * mmap read-around
-		 */
-		ra->start = max_t(long, 0, vmf->pgoff - ra->ra_pages / 2);
-		ra->size = ra->ra_pages;
-		ra->async_size = ra->ra_pages / 4;
-		ra->order = 0;
-	}
+	/*
+	 * mmap read-around
+	 */
+	ra->start = max_t(long, 0, vmf->pgoff - ra->ra_pages / 2);
+	ra->size = ra->ra_pages;
+	ra->async_size = ra->ra_pages / 4;
+	ra->order = 0;
 
+do_readahead:
 	fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 	ractl._index = ra->start;
 	page_cache_ra_order(&ractl, ra);
-- 
2.47.3


