Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEA42CDE00B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 19:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44DE76B0098; Thu, 25 Jun 2026 15:50:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE766B0099; Thu, 25 Jun 2026 15:50:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3149F6B009B; Thu, 25 Jun 2026 15:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 036C56B0098
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 15:50:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B7281C1858
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:50:47 +0000 (UTC)
X-FDA: 84919477734.30.A16B2F1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf31.hostedemail.com (Postfix) with ESMTP id D4D2B20014
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:50:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mLlfwc6U;
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782417045;
	b=06q41CPZATvKrg9/HTyDUgzs+qLrWZcahMPYfgoKD0LmjkrHRs93Hc30G0W9Q46DYdTYgm
	QMotWswyqOYN52BdYKGRH2toYFw5XLFZgREfoDMqIAVJT8gzbM4XA4780BEFFGN/t0wo6q
	Sfl5+dWA8ES20y9u6zL30087lnTGBl8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782417045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Upb/h5BC6emh2uCvCZmdA3teabeZa04tyl/wtuR/1E=;
	b=5C2wj+4lkplnmecdxT/NgfWSuR48LHzpv+sPdM/zAMDuhNyhZbIIdJch/XEbmyeDGwTJry
	zOEF/Xv6JHdMMDQKCj8fBy3T+/9MRaTaUX4lbmqMdKC8BCTsettaumOH40NkPo27hWH1AT
	fYLbiyRNw/x9q1A1zm5Be+7XHIjHHwk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mLlfwc6U;
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=9Upb/h5BC6emh2uCvCZmdA3teabeZa04tyl/wtuR/1E=; b=mLlfwc6UKmonahFMy9sOQ1P6Qi
	m8tjbweTyLnAb+HPt2LQhaY5a85VktvboOVW4dpwu3ZoNp8+QUFZ+0rq9s/dTjbNAS33j2cISzi68
	2nXSMx9QNRG04sXKeq5nMr3y80ZPRGjYokwT/9qb9N+7RHGT+piwEnRmDtwszp8UIEC5+KZTsQQTI
	hWj/Udeb2d9iCcEAlVl3K5Dv/M4hfRoLfzCBFf8ByAy05o03DqNXjoi3cndz3a3dvLAzCpqDhcgU/
	4azpibFHLpY5gKQESPN4cPHpTFBXIQ7N+BYI5M31IcJhxS8pMlv65Df+uxFsTUckBn8fQfOzroEV6
	CYUdXGPQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcq60-0000000AWYe-0Nk7;
	Thu, 25 Jun 2026 19:50:44 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 06/11] filemap: Do synchronous reads under the fault lock
Date: Thu, 25 Jun 2026 20:50:32 +0100
Message-ID: <20260625195040.2508362-7-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625195040.2508362-1-willy@infradead.org>
References: <20260625195040.2508362-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D4D2B20014
X-Stat-Signature: kr93y3p8os3eh3cp4m3s1yrpgq87hhxt
X-HE-Tag: 1782417045-818517
X-HE-Meta: U2FsdGVkX18LMqR/KI13O6Rvi1mjSw4LFus8L8d5O+wxi3H/6GK6QN1zL0H8EVLjEghdiw9xzRXylsn1DsS1Lpxmb5XJTF3jALcr8jFSL7A6oKwZqt6nWsBeU/H6ZzOnuBMcsa6m9as+sJMg3nlr3tI0Re3UKO6kjLtrMMLgl08jPgK83MtPVPT2R3HLNSLxeVAdffcoSupQIJ7EJ3JG2+Ad5GZVqH53nS5ypH6iocuHKE8OPe6J8DVWog/9yhO6E9ZUkJY3lqew91Aed4wm9XBOvTTsw7iqaXaRF32bqh3WKtLZ5PE22iQOq7PIfDTRPw9Hq9E/ONRxQ66KdGAhYevzrl0jOCPovj4qH8Sm+O0iHdOAG457OyxjVutgs88zMw0rTjf43QfUx1KUxHuw9AOXp5cgp0m7DXpHC2IR4d4cd6X/M9JBQXSm2yfiUCaaEFcXqnQ9MkpKt4BBfhuSJj6hRPpmS/0vFiK3xsH61iKEPs2hIttOFlAvwnB4gE5XpS215HgWM2Uvd6EyPDBncb4t6hrjI+AvKZgU6cTKKHSPAJKiXpzTwWeDGTWvNTteb2sl5ADD8dr3FPpdyoyOidm2rLtXoIxelb/uFmf/Ov0Jq1u4l/7txxdzM3Bw09KiAvRGHavc5SRw3EjOdP8sHZ3QtU6/MmVMKsa/cYCXwQnKCEnw5JapcfjvaS105lQtWa2QCFC0DYHcgXNQ6LjjdOakvYgMkXXyoNQi5/m+23FPryxm/9k6LWl1YIBcGKHy4X+MBELbHVIalhucWWZQd0jH9AswN1gt9BAfhqdlMtNmzrsBrE5GASmBz8mLIbV9AGIcmodEApfVLr1fUfosnC9Tvtltb9GGVwzWoW3IHJDkt0A5c5C8q9ZyqH9ddlRqdh3ahta8pGyQJPFiYvskSjtJMLvBqdrlC9T+rbhGBsgn7egBEDyW0jkairXbDW5C7PxXXA0ZVr/UFJpQK2V
 q+vbThV/
 xqIY6AbiNNeVdJ1FtsgWvUOSwCYugIRcoB9UAlopJPFcJeRHpqDLuaZeieSnjEdRLUosODLeq/v2/0LNMhkViu+ldswqizF2BWzSoKU2EgPTon4/CoL0dwTyK5NRYI1liKnSuBns0JMNZoKsQR1kpSArDXBU0LdFRHbPCSFqCSGxthvnYZvNoEpAxMW2jXGxC2deht89NBW97G1wTD05TpCrRRltxvvhfcbEy6qmPYQMV3jKVvXBSsg+QIg==
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

This was the last use of fpin, so we can delete it from the function.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/filemap.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 4bbdafe990da..b504e3e37836 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3479,7 +3479,6 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 {
 	int error;
 	struct file *file = vmf->vma->vm_file;
-	struct file *fpin = NULL;
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
 	pgoff_t max_idx, index = vmf->pgoff;
@@ -3531,8 +3530,6 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 					  FGP_CREAT|FGP_FOR_MMAP,
 					  vmf->gfp_mask);
 		if (IS_ERR(folio)) {
-			if (fpin)
-				goto out_retry;
 			filemap_invalidate_unlock_shared(mapping);
 			return VM_FAULT_OOM;
 		}
@@ -3576,21 +3573,12 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		goto page_not_uptodate;
 	}
 
-	/*
-	 * We've made it this far and we had to drop our mmap_lock, now is the
-	 * time to return to the upper layer and have it re-find the vma and
-	 * redo the fault.
-	 */
-	if (fpin) {
-		folio_unlock(folio);
-		goto out_retry;
-	}
 	if (mapping_locked)
 		filemap_invalidate_unlock_shared(mapping);
 
 	/*
-	 * Found the page and have a reference on it.
-	 * We must recheck i_size under page lock.
+	 * Found the folio and have a reference on it.
+	 * We must recheck i_size under the folio lock.
 	 */
 	max_idx = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
 	if (unlikely(index >= max_idx)) {
@@ -3609,10 +3597,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 	 * because there really aren't any performance issues here
 	 * and we need to check for errors.
 	 */
-	fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 	error = filemap_read_folio(file, mapping->a_ops->read_folio, folio);
-	if (fpin)
-		goto out_retry;
 	folio_put(folio);
 
 	if (!error || error == AOP_TRUNCATED_PAGE)
@@ -3631,8 +3616,6 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		folio_put(folio);
 	if (mapping_locked)
 		filemap_invalidate_unlock_shared(mapping);
-	if (fpin)
-		fput(fpin);
 	return ret | VM_FAULT_RETRY;
 }
 EXPORT_SYMBOL(filemap_fault);
-- 
2.47.3


