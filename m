Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 613E8CDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 20:14:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59A376B00A7; Thu, 25 Jun 2026 16:14:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54B116B00A9; Thu, 25 Jun 2026 16:14:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39DC36B00AA; Thu, 25 Jun 2026 16:14:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B7806B00A7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:14:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 99A0C14023F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:14:19 +0000 (UTC)
X-FDA: 84919537038.01.69448B3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1B61DC0002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:14:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LMqdv0eC;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782418458;
	b=lVcDhsEvUH86wUqC4swzw+9F3Zt0wRJxpWX9FYySM0TbTmVF9UgeeFI3s8MVS8pQ0MpBJU
	K/kAWstrWCuVwDHXYXYQN9xaOTBhnLggFU+xYao5ealGgtmWBkQQADSZ22Xx16HgOmBr1e
	6m1+9qJZrkkeUF8Qh9N20EGfoIOyGbY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782418458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5HoOa5lerDbAkpEPblMAK/i5NmugzkaRMmErAHVla6M=;
	b=r5fKKCI5EXEn1f/1Shbv69StsXUqRA1bg46P4h6W2k/pNBY2d/nwME4EsFRFqGW+okfgbK
	rHlznO1oBJ7kKE3KhqpRc9HLpBRgPGv8/n+NK5r8eXaDIxmtIxOwTIhcADWVrRs5Ao0oa0
	vrL67SHzci+GVEXDBP9BcxzAH29Q/qI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=LMqdv0eC;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=5HoOa5lerDbAkpEPblMAK/i5NmugzkaRMmErAHVla6M=; b=LMqdv0eCvj79jMdGFPK0JvY+KV
	QZSqSh8FezY0Mjq8vNFoBaj2sK7YatnvNSyQIgXoczkmMr6Zgtonawj72JZgFqft0/YtDRv8BPw2G
	m1lOoGNqMylHuBqrFL0vaV/XrlkNV55UI2Ivrabc36jc7WWdwHjUgUuqRsLC1UxJlFIHodV52MBiF
	PCGidS/fASrq1F7msiKZCXTmhMhwcOmv2YSvjCZu3VJz0oCTSijuC9H9QPf4ZbQuItlpDLYKjA4M8
	8v0jbOAN13rn4IdQcQiW6gAVLygzL/CZOCD4/ebpV7qfwvoUyUjya87qzB9xW+kZB7nMKltsa8n6s
	yFFgqDdQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcq5z-0000000AWYX-3zBC;
	Thu, 25 Jun 2026 19:50:44 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 05/11] filemap: Do not pin the file when locking the folio
Date: Thu, 25 Jun 2026 20:50:31 +0100
Message-ID: <20260625195040.2508362-6-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625195040.2508362-1-willy@infradead.org>
References: <20260625195040.2508362-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1B61DC0002
X-Rspam-User: 
X-Stat-Signature: mj44u951jbccsrtf89khi3eoejw3xzyy
X-HE-Tag: 1782418457-230130
X-HE-Meta: U2FsdGVkX1/Iq8GT3GSB5lmkuk4pbGsUHf3IbCbsGiejSVWAtXPHAH7zZW7FZNopxvAevk4SJoFFP4EShHNX/Sw5tMjI2LmA7V+R8Uqw7mlgaIc2BM/nxasBPf9JPMqOq+A1lxDpYw0UwS1lIgNfOPCMV8gbjVIJTXG9ncoGn+D7RGP1u4EHp9ZyCJkUy+7A2Q1HY7KJOsfnM4SCCH5gmafHdU7bpA3IG5GmrHaVebkutpaCPxkpKIlN8Ud5z9w6nhSeCVAiNIdF9pFDoPcqtNoUAunC1QQFNbktdT8Y96SjU70lNolLCZKn6VCDkIyiTt8EMHG28CUxnDNjgcjg44S0cExSwoi+9TawuSYe3uHmTmURaVJdZPkLkyrMoz+1g4Ap9N8nAvKsxkfLy5siFsoXlglG0pH97bgS9y4z1XAKnqbQG1eVXbsJuc2Spe5970IpMPFI8jI+AwBn8LwzgR6ldD6LEhb0QuqIkUWVyokwD+hb2RGsehSXdcOHgNB0VoXlCpjIDV7LoXaaTqmbQyXzZ+3YCz/aSH3zUmyFp+DVtFZJu8/ncyA1LIK98rKg0Zhf90X/iZSzQS+LdBG06RCgDxgxx03pw57x+9uOgHLLcotoqehc4vrbnv0/7iDVKnwpd2zNbzbg13UtZVzb1X0sgYdifarR1ueUj9u1lBiRxXfshXjJg7roizAMXon08RNvaSGBDnkIZZSVPOeKYkQIZl9JrV4+A0xFNS2ZblkSEjc15Dt/5qEO6cQK4sbx/+YrpCKqzEUuh35Wwk9uSRc3zLzsAxnHTTduBHblwawVqq9Qeyldeo59cl6feUNjCkQPJcLgzm9kHf5RZODuzRum1nBrkvZZvC+0D98iuLmQxVNjeIG7pRgyRbI9YyOsv04ZTezd6e/97lBTxT+ngAcUlIUKUMwF9NydHLkLZ77nIUUp5rvMBlqpfgdmSjcOqL6lsKrTJcsg0V4P/XN
 Nh8/nh79
 Cly7frx+QKbsfGWSBca3ROW3qklH6NmCO4vXG6hgz+XNPmRbNEXIHb57iWn9amQue99Zr/RgbdSywEfhwaQYdPEt7RYKNBx+pGULw3lCRe+77jeEVLvzMC755JmMYtTmHv4ojFDwYcou/CCeG8TsHq5SHJrBZ1EB7/6bMfYUK08XMl2DEK1r63Z0FEj9aioazLVjQq4rmxGLrfE4K/rxiIB6nPHAcbNpSnxCQtJJUMOQngqCCj18aiDxVTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Call folio_lock_or_retry() instead of lock_folio_maybe_drop_mmap().
Both functions release the fault lock to wait for the folio to
be unlocked.  The difference is that lock_folio_maybe_drop_mmap()
returns with the folio locked so that filemap_fault() will do
more work before retrying the fault.  folio_lock_or_retry()
simply waits for the folio to be unlocked and then we can retry
the fault.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/filemap.c | 50 ++++----------------------------------------------
 1 file changed, 4 insertions(+), 46 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 3be815da09ed..4bbdafe990da 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3252,49 +3252,6 @@ loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
 
 #ifdef CONFIG_MMU
 #define MMAP_LOTSAMISS  (100)
-/*
- * lock_folio_maybe_drop_mmap - lock the page, possibly dropping the mmap_lock
- * @vmf - the vm_fault for this fault.
- * @folio - the folio to lock.
- * @fpin - the pointer to the file we may pin (or is already pinned).
- *
- * This works similar to lock_folio_or_retry in that it can drop the
- * mmap_lock.  It differs in that it actually returns the folio locked
- * if it returns 1 and 0 if it couldn't lock the folio.  If we did have
- * to drop the mmap_lock then fpin will point to the pinned file and
- * needs to be fput()'ed at a later point.
- */
-static int lock_folio_maybe_drop_mmap(struct vm_fault *vmf, struct folio *folio,
-				     struct file **fpin)
-{
-	if (folio_trylock(folio))
-		return 1;
-
-	/*
-	 * NOTE! This will make us return with VM_FAULT_RETRY, but with
-	 * the fault lock still held. That's how FAULT_FLAG_RETRY_NOWAIT
-	 * is supposed to work. We have way too many special cases..
-	 */
-	if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
-		return 0;
-
-	*fpin = maybe_unlock_mmap_for_io(vmf, *fpin);
-	if (__folio_lock_killable(folio)) {
-		/*
-		 * We didn't have the right flags to drop the
-		 * fault lock, but all fault_handlers only check
-		 * for fatal signals if we return VM_FAULT_RETRY,
-		 * so we need to drop the fault lock here and
-		 * return 0 if we don't have a fpin.
-		 */
-		if (*fpin == NULL)
-			release_fault_lock(vmf);
-		return 0;
-	}
-
-	return 1;
-}
-
 /*
  * Synchronous readahead happens when we don't even find a page in the page
  * cache at all.  We don't want to perform IO under the mmap sem, so if we have
@@ -3508,8 +3465,8 @@ static vm_fault_t filemap_fault_recheck_pte_none(struct vm_fault *vmf)
  *
  * vma->vm_mm->mmap_lock must be held on entry.
  *
- * If our return value has VM_FAULT_RETRY set, it's because the mmap_lock
- * may be dropped before doing I/O or by lock_folio_maybe_drop_mmap().
+ * If our return value has VM_FAULT_RETRY set, it's because the fault lock
+ * may be dropped before doing I/O or by folio_lock_or_retry().
  *
  * If our return value does not have VM_FAULT_RETRY set, the mmap_lock
  * has not been released.
@@ -3581,7 +3538,8 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		}
 	}
 
-	if (!lock_folio_maybe_drop_mmap(vmf, folio, &fpin))
+	ret |= folio_lock_or_retry(folio, vmf);
+	if (ret & VM_FAULT_RETRY)
 		goto out_retry;
 
 	/* Did it get truncated? */
-- 
2.47.3


