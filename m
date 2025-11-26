Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8EA7D1039B
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 17:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61AE6B000C; Wed, 26 Nov 2025 12:45:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38E16B0031; Wed, 26 Nov 2025 12:45:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C75AE6B0062; Wed, 26 Nov 2025 12:45:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B82BD6B000C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 12:45:08 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 61F07160703
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:45:08 +0000 (UTC)
X-FDA: 84153484296.08.9FA12C4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 27D6E18000B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 17:45:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=oHrk9An4;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764179106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=v+f0U6dnVkw85AC8BGgvKilEaE3btbEnKSaHNVU2XlI=;
	b=TVOPDchZXbwYZGYTU0AimqrSIGxSdUFe7TkR1q3XpAMwG4HBNbFZgUEL21JTjVz6OdSVPH
	oky4QlhRMJdn4lPFZm3+Jgpd3Uw6oNzRwjS4Ih23sU7TcCMrcezaYmxomTee5GXSx7H8kY
	/B3nEpp4d0rQwKWDOQgJw0OwQhnLtww=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=oHrk9An4;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764179106; a=rsa-sha256;
	cv=none;
	b=fv+P/TF2EIOJC/Gc0EHKWgVMZQFCZludU/fpD8hNCO/jG1b5vwSEdxUoC8+UmxDbDXWyO5
	8Mm+ASaK6pYV+59hpeoZfyDaWxutYA3lVZfZ6WZTBfvdkoBO8sNUh2fQCoFtKzJH0WSZuk
	h3xVC0oNBt5lArDWp2Psb8cSHZT1/XU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=v+f0U6dnVkw85AC8BGgvKilEaE3btbEnKSaHNVU2XlI=; b=oHrk9An4XolIg+rFqd/p6qgDpY
	1ZcO6RWVC03VXRMeUW1+rYmLBCFjz0NcU983ntLVcwYB5Raoh9Xhf1ZCJ+5qiCK11YZVeE6Bkehwg
	N7bTG1ybhsOWrovMWDh8bw93lhURL0+c9ubvXiIdLFKmVngPJylgDqbXc0U/98fr6RXRnX9RTdtqF
	lJgSJ5K17jUx8VEXtqEPYWQP2jahzss2lZ95hqBE133geMDm56vjLhvo8OOKJUTluE0XMA13D5nU/
	9RYBLz/bJk/XW3gX2+KnwAiaJhuPmta85lyexEEc07QORHbo7ks7wRxCrnXDJqqHiFXv4j+1HsKcF
	rMerdySg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOJZe-0000000AUBr-35yL;
	Wed, 26 Nov 2025 17:45:02 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-mm@kvack.org,
	syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH v2] mm: fix vma_start_write_killable() signal handling
Date: Wed, 26 Nov 2025 17:44:58 +0000
Message-ID: <20251126174500.2498895-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cirhzx3nhc9gzbyzfxj4exk6temxoe7x
X-Rspam-User: 
X-Rspamd-Queue-Id: 27D6E18000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1764179105-930790
X-HE-Meta: U2FsdGVkX19XorPB/TTLgI7iuGG41jKGcSAoYe5eqI/yGvuoN5HpcvaJ69JwgKZWbsJg/2RXyLzamEUzYtR8aX0RJ1l6i1EdwQ3wZ7SFtmkclqaS/3NiYzFEeoaFXHIEk1rJMQ7yvkqW5Qa8+bPb9zxVL2j1cVtoxCVYoJzQOhtFBwFxs/49e72Q5RziT0TIqT6T+pAI5lADtEcJq4mguWeLvFiEMOB8RrhCh/RuKRI9Woywo8qdplq1gnayBUd2dj1Mn63DzCQhqB4F+6NPZhHUruLE5ZgOCYHVl7rfnaSLLYG5ZTEcALKK0YW0pGE3QhINPveGR4u4Ofh8uOFlrm1DwUdsqddsbAILSUmPDkLmvP9ab44l77UHZ78CybLXCs/o/wsKfRDUcYLPdfUDoimYvIf06co9kWrE5TQKcG9PthwlwTYa4/nLADDGwsK9By9mYfY8b7jsUmPKnzdvoI+7TDOYPzLi+s3JzYnaNuw8JB275/nwTjOue0o2enz5kC7+7vnXFb0fDfO0zHFXhebwQLQUbzHxvnv5tJn8zlirjNvUhogESUxZfFCEnjqXgTCxTtDFXmtRCYvOXezSAn24ejhIbB3h+OFK0TTjFUtjEbwhuKOjPea5YqfWRpbERYHtgH1ZANYQmdguYu7o/YkCvCTK6k4o46yRC3yk8wbCY4XJ+b6HYfnI5mhJpTH/lq4V/XGxYgpLfQag8r2IFR+py3R7J1eNzMGBHmLcyr3bVFUYzpSKV5FGwqsTSavyykDxDsJIfXxLkzBH+3ev4srwijAUEUn1TCLAC3qKXH5hBJz3p3pWeYcnQzeyf7g/NmP8YPe+JPjVGGckSpeMo42tmRtXcBjQxWT+OLD/JCx8ujiJs79n7i0IHjKJWprvayG5aoSuScFqWCnMXDVFOGBlp9weSJp8E5pnROwn19IMFpE4aK2W3PweLZwrv2U4gyUwO1T4ndb6Wp7jpGS
 C/HLPOcf
 G9VEKcfHYoAsPcO+l5nQ4BOaFcTGqhTLAPmZp7BUaSMJrPq2RJdx0oocHfr8MiItOMhh6c2IK2/TdAjPYoxR8ZkAPfmTx6Rv28OtLTpYCzMcuorM1A/LNdszi7HtvBzE+jRDcnpng4iWxP/ViL129Ye8dko9zNBrGVxTVyNesMW7C2bHAG7AR3RRgFbArNQ1JS9YglWC7Pi4zneviiULB/Ede/6iJ7b1w6wdg8tMc6anRWyD5D0RRfXR28YT/9LCAtxLmAcR7GcBeX417gTwBhEbsuNiQYhfG2uyjnsR0QKyc1Xxw4MPxiAVZDYLIIOV6hrmYKoQyMeMp4Tvc5o82vtaaYAC5haCdxUaY96ZyIvyrOhMxjrKypTwDXhwACHuSekj8MnnITjkH8midOJV9mgs9+KA0+wdKYvSys5QNMjkAJrGW9f9HIZ9DCQubIn4LGMoIS5anF/+Kgw38QbQ8U9Nyn5Tu1kdElqFtcT6SuzQApXO00K9E18HKLZu7cPbgIkjy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If we get a signal, we need to restore the vm_refcnt.  We don't think
that the refcount can actually be decremented to zero here as it
requires the VMA to be detached, and the vma_mark_detached() uses
TASK_UNINTERRUPTIBLE.  However, that's a bit subtle, so handle it
as if the refcount was zero at the start of this function.

Reported-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com
Fixes: 2197bb60f890 ("mm: add vma_start_write_killable()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/mmap_lock.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index e6e5570d1ec7..3c9bf2f96280 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -74,6 +74,14 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
 		   state);
 	if (err) {
+		if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
+			/*
+			 * We got a fatal signal, but the last reader went
+			 * away as well.  Resolve the race in favour of
+			 * the vma being detached.
+			 */
+			err = 0;
+		}
 		rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
 		return err;
 	}
-- 
2.47.2


