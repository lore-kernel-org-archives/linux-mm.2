Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AA35CDE009
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 20:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2A756B00AA; Thu, 25 Jun 2026 16:14:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDBB06B00AB; Thu, 25 Jun 2026 16:14:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B8846B00AC; Thu, 25 Jun 2026 16:14:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 704206B00AA
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 16:14:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0130E1C13B3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:14:23 +0000 (UTC)
X-FDA: 84919537248.06.F2D9D88
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6A0D2120002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:14:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="H0/9J/8r";
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782418462;
	b=2Ax0wv+MrfXDCB6nRSKne2oZuqonamQyYWRojAbYwZrUfOIqsn80Lxm9D8D9sAIFQqWdg8
	5Qvmkif7ZNBh/viN0HAAvdM/jIkMOUOF/RQs3aOF3z3jmU8KhOCXje44/wFEWqdkJ5vgn7
	t7Hkx9H2ySmp9g1gODzr1ltEiI7I9to=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782418462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mSdMxtuMp+EW9zU+QIpMH97UVAInFWLbbVKuTTE9mF4=;
	b=HnYRHLykiknA8pVvM42NBNS9lvNS7J3ZJO+hhk0YvnogyqXbzUvPqSHgEIezOVTJ4MOzov
	Ohb8f77D+Dc4AZEihTcECgjxn5Og4eV/gSx0t2VaGo3Kw/QX1qhgjS4/sGuWUZsPmgTCun
	ebKBCY8xJ2MtZ7Qc5eZ/LrR6q3iYD3k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="H0/9J/8r";
	spf=pass (imf29.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=mSdMxtuMp+EW9zU+QIpMH97UVAInFWLbbVKuTTE9mF4=; b=H0/9J/8ruBfzNgtdLA1yItD5dD
	5ui3wOYYxgYTew78IWS91FEQ5oX8bJsfW66unlDoXUFMWyz4FDL4Xp+07TiOP0hsNHpJBIRgxyj82
	6S0ycgp/jSD+A7OOn3UGDiWFSRoSnKcB3mk8R/vPV8D3muSk3el99aNN6FLIHtciaQE/9Px2b0Kb7
	qNGXmQW+1+ttAx0zCUnjPTzlfgYdv9OhnClc4jPC076qSnDODU4Gqr8SybqWRHbrk8bfoXc5Otpak
	vWRk/VMdxqBlciSWaZuSOX2I6YUONxOT3oE+JveviHiGtHb6VU+dxY6wYXa7UlH4rpVeUjRPmusPi
	n2MRi60Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wcq60-0000000AWYr-3DyL;
	Thu, 25 Jun 2026 19:50:44 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 07/11] mm: Remove fpin argument from maybe_unlock_mmap_for_io()
Date: Thu, 25 Jun 2026 20:50:33 +0100
Message-ID: <20260625195040.2508362-8-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625195040.2508362-1-willy@infradead.org>
References: <20260625195040.2508362-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kpfp1f5suogfw8kuobyjwxw4xmegwz3s
X-Rspamd-Queue-Id: 6A0D2120002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782418462-889385
X-HE-Meta: U2FsdGVkX19c5QXrwdQ2T9svx86xJIdxyXbN++zM2ldow3iKERFKvBkiN3GMSWCu5GFh5INcwy2g1eRkiNhj85E3cfu+Oq4+bP14MEapreeiaoxR70pNiM3nXo7mk7PSXTfEfpWWYkpXI9/PyD4SWxqCbY8CoQYUUm6zEdM6Ebl8kF1WYnaDPqnEvY305Bb+Iy+IeE/n7eLWVbBO8TaxruWjzqDJyBBXB5aoFl02XZxwimRW50NI0Xcaunrm8H6H/jd4ka9ubxBF4vuBpv3WkMDNT/m7mPI2vdbh5Nhz3+g+klIBhTEzVM48LJtXFoz6SwxbqdKpU63N9F7W9w4oXM36YDwfCosVkZvnBOdSfhHMg4+sS3HdumMxjPSqipM9lC1cgaDsaX2YYiJ0SMf8Vnt70nDQc+p8TSaVQ5Ekb7zE9/FCKyfypQ9fBRzltFqcT6pfQHquaPwulGZ8jtI5PvbzLIHLyRQ0tBeaDOLL8AbLMzHK9atV2fa5KVnyGfMwEXSaZsniTgxMnvN5Zgrw8tvdShpSsaP+z1+G7LvRBmZ56nkTiGS0wEdtiYtBb2YwQyIBGKxCNF1BRbSuY7bSFIMDc0EWNAtafI5/OTPB9XurxikOLEZF+ba64qfRc117VAJisryr9l0Gfj24C0uBRA0mx/0b/QNkXmAQboI9wrAu2McBWlCCwnE5UkvCJz4i62nP9db3cI69UHutI6kJ8MxUS807CDjZzauKEeRHY7Cc0eXrD/Q9qD4jvucy77b42AeB5BHqtCgoTrT9U27uPZ3SjbaPiLxkyPKEePMBNwlFLblQEMo2LGsltFjesWU8SNDVRoewSKBmrbljLk9pGXxUUB3Myzcm5m9weD/lAQj+1HV56RkSNLp2WMRak0hhQVlHfbz3OTkc0RJnelAnAL7K33/onU/kJfixm1KS0532plaKivVrr6GDNy+znVHqpg/fybSwIjzGatEU16s
 /ZJV16Qo
 cicGJsAGRuhXAQJBRzXCIU1OxOQD+/LEprG10z8dzpSZ93yFb7J3HYHJfSsd/k7da8ooMzlKq2dms0ak3rsK9sUkoFGrjPYBL4qi5YY00qeEAw8JQwRq+MIgte3+QNypWy93TXIP1vBZ4T1U9IboxKRFChJ2iIDZ4wf0uDEWPy8rSrxYBwiE2n6tgvNeABSfCp4ttrXLT7RVqo25vaP53BieGtEqSHjWYBdGB32CcH9cnS0ezRdJLM4k5fKyTwAhqzmJNR5V7JXDwjzmZ+Nfv0rO1H0DG0qoqJtasxVysPKaBN3A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both remaining callers pass NULL, so we can remove it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/internal.h | 7 ++-----
 mm/memory.c   | 2 +-
 mm/shmem.c    | 2 +-
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..d88a00cbea4c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1273,14 +1273,11 @@ static inline unsigned long vma_address_end(struct page_vma_mapped_walk *pvmw)
 	return address;
 }
 
-static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf,
-						    struct file *fpin)
+static inline struct file *maybe_unlock_mmap_for_io(struct vm_fault *vmf)
 {
+	struct file *fpin = NULL;
 	int flags = vmf->flags;
 
-	if (fpin)
-		return fpin;
-
 	/*
 	 * FAULT_FLAG_RETRY_NOWAIT means we don't want to wait on page locks or
 	 * anything, so we only pin the file and drop the mmap_lock if only
diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..0124a87c3e81 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3737,7 +3737,7 @@ static vm_fault_t fault_dirty_shared_page(struct vm_fault *vmf)
 	if ((dirtied || page_mkwrite) && mapping) {
 		struct file *fpin;
 
-		fpin = maybe_unlock_mmap_for_io(vmf, NULL);
+		fpin = maybe_unlock_mmap_for_io(vmf);
 		balance_dirty_pages_ratelimited(mapping);
 		if (fpin) {
 			fput(fpin);
diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb..878eaacc009f 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2656,7 +2656,7 @@ static vm_fault_t shmem_falloc_wait(struct vm_fault *vmf, struct inode *inode)
 		DEFINE_WAIT_FUNC(shmem_fault_wait, synchronous_wake_function);
 
 		ret = VM_FAULT_NOPAGE;
-		fpin = maybe_unlock_mmap_for_io(vmf, NULL);
+		fpin = maybe_unlock_mmap_for_io(vmf);
 		shmem_falloc_waitq = shmem_falloc->waitq;
 		prepare_to_wait(shmem_falloc_waitq, &shmem_fault_wait,
 				TASK_UNINTERRUPTIBLE);
-- 
2.47.3


