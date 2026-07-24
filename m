Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D45B4C531FC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:40:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4196B008C; Fri, 24 Jul 2026 18:40:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6E156B0098; Fri, 24 Jul 2026 18:40:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9A96B009E; Fri, 24 Jul 2026 18:40:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 614A76B008C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:40:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1235801D6
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:40:24 +0000 (UTC)
X-FDA: 85025140368.28.121836A
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5DD0640004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:40:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=RVCkNQ0h;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784932823;
	b=htzLRaYy0Kv2/TvTIQezBCtedFeZg+RGtnnMEj+dsMjbgsx/JIlO/W1V1KghYwDl0Zv+Je
	f25EE059TUo0PZsIIR9J7jkZCfhLyoqGgHhNFRaZOUiSI1YH7ii5s8R2w4DODY5boWZFDc
	J4h8v3k29kzmwSyAxAwblGoSi7rFX4o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=RVCkNQ0h;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784932823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qDlbQ/k/gKhextbIPqwqCwZ5BabZN9oEFBEjCjmG3eE=;
	b=n7JDWsga63yiuGHNztl+g2O5JzoP1CXK2WRJV9lSHTWb5tD0s27+dSc8RumX2f6DhNbKnp
	3V+Co3vzHOL13JxG8NlmpT5CbtboWeE4ol9Z2CXW4fIwE0eeVSk9wUEiXJHS82+cBDv4ol
	f1w4h+4dlOYFhPN34Gp8a2255mG33RA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qDlbQ/k/gKhextbIPqwqCwZ5BabZN9oEFBEjCjmG3eE=; b=RVCkNQ0hfcZsXJGNqnk2s4AJat
	5GNYVKosxlBdUigBnazluK5OVF0UCUomWI4E0gm1sKSyQ2DpZ+Ve3tIRlSFSnuh2kflmXApNDjUUy
	gxxxgxZDK+Zu5kiplzcnWTHxBVCkgfs3azyY4shlHCrtJXqFOOpJwEQwoT59m8dBOlzuDGVHaelLx
	9vu7z4jFwPmPhdj9bAGq53MEVutyT93H6mHz4OREXM9GZBMKTOl1XR7MZjlGNdhiKzL/CVQTn0RWx
	GCawa8mEsly9K9s3yOHmXaRVfdOenUeerOK0giEoty7aWhdLSK/ThtyzZ3pM42YvYQPfRKES+Rp9i
	Oa/5MXxQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wnOOs-0000000027h-1CWq;
	Fri, 24 Jul 2026 18:29:50 -0400
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Rik van Riel <riel@surriel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	linux-trace-kernel@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH RFC v4 03/12] mm: rename get_user_page_vma_remote() to get_user_page_lookup_vma()
Date: Fri, 24 Jul 2026 18:29:25 -0400
Message-ID: <20260724222934.1463812-4-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260724222934.1463812-1-riel@surriel.com>
References: <20260724222934.1463812-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5DD0640004
X-Stat-Signature: 47jt51uesz4x6cxrbhzttpc67n7ak141
X-Rspam-User: 
X-HE-Tag: 1784932823-763477
X-HE-Meta: U2FsdGVkX19zvucN4DoxYPDM1UA0CO6FBOsvDB2S6/SZTLC2SpJ21fAbPPVISo03npnNy2pLqHU5dONH7mWYp9VINYhnDCR+Y8uDu47sak9+kQ+YSoBJrDxm2tFPwJmicCZfZccSmP/etziGlyPrBTfXgtpFDMIPxAm+n/GpEH0D2AzoBCfv0vOiHdU66dr5vSS08uODajuPGXHaLnO2diKAbFPHhfbilpptLRgXEbFo+Kc+wWPpx44VTt5dmvo9qMm3Ci9/sZacxzn8M2o5rYqmGMj3peQYt4tin96XFKhFvb7DBIGeZDi9pSvF63sisMmSd/hzrurpX+PYeRHMBzquGNNMnruJKliU55R9LCNH9YumZwKtmDFJ7rqiOkefiH/SOWxijiiW2AYpZ+UY9kvZoxrEgNZHUH3dWtup/Qq89KCqlIHLoRnYasvYbg4wS1IwKw/y+plY7oonFxGMlUtcDTj5atc66CjHViC/QfsU62w14lnY8jCc8qS2hXQ1mlXd+Dkr/oR/+ezCrBxlmi30s744Xxt5lwSkRE2zbe20U+PRNIsKmJWz+hHx3gYG3oXPHIU5nNtPmSmtfElV+RTb1JlwsrPOqRZlbJKDISeMAG2eImynPcBafP74zwJg/Ofg2rUvsLx5Xo7V7GGbdAykRIRc1pke5XSMOZkmjoDSLUiwhdUk149ySEL4JXBIyR0YUyI+KfDi29BJtPuHK0R9luQG7lqlhc/3fNr1l6a+7lskjoSn8ZBMzKzRaarbQwCCVmokMrwAlULQ8i7p8/6EYjaG6yqBGQN0aWh30zpraO8xJWx5jMRkQXSbNPv3hGJzvHRPJytpyZ1givDFsKhYiNdHunXRddYBX6cvmiMDLT0bsJPpESvcGQJRZJQ4yn3c09vQt17QaGafVuQiiSqQhcKQ1YKSpMfKQbwXGTpsR7U3JNEjd18/qF8BwVu5BzVAdJD7ofzFVdRYxQs
 3NVgM70c
 BKYLDfmD1l4fS6tkXek6drQWqcBlts86N5VBCUyiAAKvkvVs5jFJoZIeaidg+Ya4EZbTJJAnZgAGFqVhwdtbPu4OA5fs+XWsmsMyL/Iwrzxa5DAYuc0IwzqdziC2EUJA5VnMS0r0xKnJSwrI7/3NNBjqzrMwpfcLBZUNwIXF8D/M3llbRn+rYfCwn2qziqFVW+QoWWE0Yt+V68bjV3SGxPrGHvEvhL+sGAnd+Q1D3B2kuJzz8IlsmtlS9nme7ShOewj1BtYBTJj7G66YomcIeBEGtf2o2hoWnIaR+rXTnJK5xyn6XR0oWtUDlaB+LmHAQ7Rr6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_user_page_vma_remote() faults in the page at @addr in a remote mm and
also looks up the VMA that covers it, handing both back to the caller.

This cleans up the namespace for adding a get_user_page_vma() variant where
the caller already has the vma.

No functional change intended.

Assisted-by: Claude:claude-opus-4.8
Acked-by: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 arch/arm64/kernel/mte.c   | 2 +-
 arch/x86/kernel/uprobes.c | 2 +-
 include/linux/mm.h        | 2 +-
 mm/memory.c               | 4 ++--
 mm/rmap.c                 | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 1a9aad6ef22a..7a6ecc3d9294 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -459,7 +459,7 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
 		struct vm_area_struct *vma;
 		unsigned long tags, offset;
 		void *maddr;
-		struct page *page = get_user_page_vma_remote(mm, addr,
+		struct page *page = get_user_page_lookup_vma(mm, addr,
 							     gup_flags, &vma);
 		struct folio *folio;
 
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 3af979fb41d3..329efac0cfb3 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -1036,7 +1036,7 @@ static int copy_from_vaddr(struct mm_struct *mm, unsigned long vaddr, void *dst,
 	struct vm_area_struct *vma;
 	struct page *page;
 
-	page = get_user_page_vma_remote(mm, vaddr, gup_flags, &vma);
+	page = get_user_page_lookup_vma(mm, vaddr, gup_flags, &vma);
 	if (IS_ERR(page))
 		return PTR_ERR(page);
 	uprobe_copy_from_page(page, vaddr, dst, len);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..24ead14b4790 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3238,7 +3238,7 @@ long pin_user_pages_remote(struct mm_struct *mm,
 /*
  * Retrieves a single page alongside its VMA. Does not support FOLL_NOWAIT.
  */
-static inline struct page *get_user_page_vma_remote(struct mm_struct *mm,
+static inline struct page *get_user_page_lookup_vma(struct mm_struct *mm,
 						    unsigned long addr,
 						    int gup_flags,
 						    struct vm_area_struct **vmap)
diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..3b86eeaf084f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7039,7 +7039,7 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
 		void *maddr;
 		struct folio *folio;
 		struct vm_area_struct *vma = NULL;
-		struct page *page = get_user_page_vma_remote(mm, addr,
+		struct page *page = get_user_page_lookup_vma(mm, addr,
 							     gup_flags, &vma);
 
 		if (IS_ERR(page)) {
@@ -7167,7 +7167,7 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
 		struct page *page;
 		struct vm_area_struct *vma = NULL;
 
-		page = get_user_page_vma_remote(mm, addr, gup_flags, &vma);
+		page = get_user_page_lookup_vma(mm, addr, gup_flags, &vma);
 		if (IS_ERR(page)) {
 			/*
 			 * Treat as a total failure for now until we decide how
diff --git a/mm/rmap.c b/mm/rmap.c
index 1c77d5dc06e9..b36f2e219b8f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2838,7 +2838,7 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 	 * (non-device-exclusive) PTE and issue a MMU_NOTIFY_EXCLUSIVE.
 	 */
 retry:
-	page = get_user_page_vma_remote(mm, addr,
+	page = get_user_page_lookup_vma(mm, addr,
 					FOLL_GET | FOLL_WRITE | FOLL_SPLIT_PMD,
 					&vma);
 	if (IS_ERR(page))
-- 
2.53.0-Meta


