Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87EDDCDE009
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 19:51:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 909586B0099; Thu, 25 Jun 2026 15:50:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B93C6B009B; Thu, 25 Jun 2026 15:50:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8616B009D; Thu, 25 Jun 2026 15:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D5786B009B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:50:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B621E8C343
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:50:47 +0000 (UTC)
X-FDA: 84919477734.09.64C10DE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 98D60140007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:50:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=t1FxJckI;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782417046;
	b=0Tqag0ErBxKfJ7/vLMCf6pQBiZHivLe/VbNoVYZ8srA2OC1A1uGtRl9rfotQ0FAViJw0Tx
	+aXMfhaFwHfO85NMsi2ojafdVg/A3c/P8OTJAlJRKz23PANnZoQFtFRAX5rNC9KGahEAUE
	eySkCf1GO7SqgyWQEWDW2/xve4GI6CE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782417046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F9TtFd0+rVocRstw5ItXF/WJXqzIlF5YPET4R5b3nSM=;
	b=eIPx1sefVhctDS948bQbv5XAVeVgntWDAFEVzhibuPuLItHcXhC+fSLLLqLX6tNPEfqf7h
	u+ZWx7LlLaaijTHSYZbviBiMLHZdMUzDumAdX96Wo94ADYRtFi0/8UuBL7Pg6AUf5PyK77
	V3gHQeY02h8hDqeuyiaCHI/wPnj4z90=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=t1FxJckI;
	spf=pass (imf09.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=F9TtFd0+rVocRstw5ItXF/WJXqzIlF5YPET4R5b3nSM=; b=t1FxJckID8xOapL9kb9PRjlQtu
	Oi7ZQgU57V0s+69ZcN/6Zf+g6Mmr5etiziGukVZ3nP0sr+Ty3VRsrdFeSQQMgr4ZWvimyWMHHC3jL
	faQxcfuPvqr6/Tn/5w3Zat/TwLdTPw62OkelL5YVvjM7HlI1714wUqHt0AXyp0kcJsmntxJWPOPgf
	a7sbK/G4+Bp2DlM/04/FmHzjdOK8s8IjO6jdMRFL6OxNr3C8ESrWRpULRbyCR3B/g/W9a4Pj6CJ0v
	v0LXzp/b928ZCOxHcL/u1A5/zqU1rpb0jvW9Fj/GHyIDwjbf/VPcYDnouTgXFXMlNLWjAYVGDCeof
	gFxE69jw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcq5z-0000000AWY9-2dOB;
	Thu, 25 Jun 2026 19:50:43 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 04/11] filemap: Do async readahead under the fault lock
Date: Thu, 25 Jun 2026 20:50:30 +0100
Message-ID: <20260625195040.2508362-5-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625195040.2508362-1-willy@infradead.org>
References: <20260625195040.2508362-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 98D60140007
X-Stat-Signature: frkpwihdjb9cckd54h745wb4o9m1xagb
X-HE-Tag: 1782417045-119553
X-HE-Meta: U2FsdGVkX19t2yjM1KLpUEM93wbbeFb0ZbgHpIoa+VFqXHl9T2r6Xe0YYfshLNPtYYtQsOPKKqGkiiJdSv5OV+E0eMYpatf+x81rY6de26kclNujIEjr5kjX//qQXwAletbLxUyv+mdAEwlgaeHJSl+grUdLywQkXH5UjY7EdkKnG9CdZHibwz8hakysyQ+49gttrj1ubMfs4Nbo1c4E+IsQhWvfchJYFgMrqR+1ZxDfPOu+PAGIWdWWketjoL/vwQIpQuWcNSN7DNUx1SP4Ii6XoFay6RL8qZArmqUz36RtPTdUx4bm2uTn90mbTxXVQKn3P6YPY+DXnIxcX8CDjxQtW1etH8XIpg3qgD+38fs08mYWfqOtVBNxA/d4YqIGDIn4dRxRixCU4LTWTCDhepo3p2bQdm85+jhQBcnAXODv45QFNjus97GBAEoottfYjx/WyX1DZXbjVUZSSz2RQc9jmxb8uNElvo4WPl/pQ4FhWyBoSLvRYBmRBpGHCLjOgY2QCqGS025sy6neObo3vaLe0r6zwfI+zapUdwwS9rQerFeyit3arKHQM2CpYG98hUvmiuknabdzqKvp1TODMHnOVKlbCL00Z8jIdJYG4hOSRP0cEjmiEi/D8kuMUanh4R9vsSvLz2aUOeqpNK5PNP49FZNCSbCHamgK5FbU0rh+OHgIOKPZb9dKfvSPBRYmR/2xT9zjUL/Xv2IYqh467Gth8FrEp7vHpyUEZQRh1OBQSbyYS60pWkXuBeMmpvPHvWjc4Wedj1xwOs2ko7joh7ZxAUTEGtG6UKBR3NeQTC2xvfKpI58ZEgeFV+4fSXhgvOJzrZxC/5zGeRK44bozY4a5xhHYian+R2yKpbqRrZoBFcDWwmsjbYaDW0wDxzRKtWzOmy/cr5TSk5qDhkBcimqUS/is9yDUZdBlgiLhyLfpzXcdw+pq5F1twfuox1pNLaeyuAIMHz8jP2Yo00d
 HVBGY4Ta
 vz+M6jHVsioXE7kUqgYHdYZxlmBjO4EpSthEjsK483kTfQxmmFo8fgMFuxGpUhy7c9An9k8GSqrCjKsRDVn4Z3qRu2bR1/z/60EN2ZhjNydH4Jiiiurxj98rS7bJnpSeWIPEWegZYrrCC7UD8H7hOSxEYKawU3gcNbLldonA9IfppJ1oeAh//e94xZkyfyiuZmFBMzeAKcGjQnQ865x5Cpaqe49tO9d0qttICXHJp9Ijq5xiSEvKVpnwwblJV1dp6Fpmf0r2eFNpit+3wyDeGv73XqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of pinning the file, dropping the fault lock and retrying
the page fault, just submit the read while holding the fault lock.
The priority inversion originally addressed by commit 6b4c9f446981
is addressed by per-VMA locks, so we no longer need this complexity
in the filemap path.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/filemap.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index ce115411404f..3be815da09ed 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3416,22 +3416,20 @@ static void do_sync_mmap_readahead(struct vm_fault *vmf)
 }
 
 /*
- * Asynchronous readahead happens when we find the page and PG_readahead,
- * so we want to possibly extend the readahead further.  We return the file that
- * was pinned if we have to drop the mmap_lock in order to do IO.
+ * Asynchronous readahead happens when the folio has the readahead flag set
+ * so we want to possibly extend the readahead further.
  */
-static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
+static void do_async_mmap_readahead(struct vm_fault *vmf,
 					    struct folio *folio)
 {
 	struct file *file = vmf->vma->vm_file;
 	struct file_ra_state *ra = &file->f_ra;
 	DEFINE_READAHEAD(ractl, file, ra, file->f_mapping, vmf->pgoff);
-	struct file *fpin = NULL;
 	unsigned short mmap_miss;
 
 	/* If we don't want any read-ahead, don't bother */
 	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
-		return fpin;
+		return;
 
 	/*
 	 * If the folio is locked, we're likely racing against another fault.
@@ -3450,11 +3448,8 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
 			WRITE_ONCE(ra->mmap_miss, --mmap_miss);
 	}
 
-	if (folio_test_readahead(folio)) {
-		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
+	if (folio_test_readahead(folio))
 		page_cache_async_ra(&ractl, folio, ra->ra_pages);
-	}
-	return fpin;
 }
 
 static vm_fault_t filemap_fault_recheck_pte_none(struct vm_fault *vmf)
@@ -3551,7 +3546,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		 * the lock.
 		 */
 		if (!(vmf->flags & FAULT_FLAG_TRIED))
-			fpin = do_async_mmap_readahead(vmf, folio);
+			do_async_mmap_readahead(vmf, folio);
 		if (unlikely(!folio_test_uptodate(folio))) {
 			filemap_invalidate_lock_shared(mapping);
 			mapping_locked = true;
-- 
2.47.3


