Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3498910A62D1
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EE256B00B7; Thu, 26 Mar 2026 22:15:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5426B00B9; Thu, 26 Mar 2026 22:15:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 902736B00BA; Thu, 26 Mar 2026 22:15:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F97B6B00B7
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:15:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 488AF13BFE5
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:42 +0000 (UTC)
X-FDA: 84590226924.24.D19D397
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8E71840002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:15:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w7b0PFKI;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DA9DXWIy9I9hYoDDZ6d9idv8WvO7k2GsFa78UasupfU=;
	b=Osodq10rTgf6STdy1tSgZU7fghFWt+uauWvancsloxpu+1308xDt2rlooRfORkItsA+Xzz
	Odf2BEppP+Yd1HfygFBw7VyhKa6bWzJI2jtV0pbU0BRPeUqMTpMKf1aeNCjP++MrYIRpOn
	N4qgJ35aN9g0J1V4tNvUEL5cBWD+I6Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577740; a=rsa-sha256;
	cv=none;
	b=S42BSi3opuZAxsq0pzZdlTdgUHI1UaQtGchK7VRKrUuQLthGELdGupH/azS51TWAtsP0k7
	RE1zcYIYWU1zsDw6fKXZ0BwV362c40iwVYFxp21m19XF7FIUv6Hzq1gt/2/uFCRNu3Vvlc
	l/XXJz3luRe7UVQ4KOcsGA672FY2v70=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w7b0PFKI;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577738;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DA9DXWIy9I9hYoDDZ6d9idv8WvO7k2GsFa78UasupfU=;
	b=w7b0PFKIYHL5VzgfVOmJaU8mndUe+9d3TAczYvwOPmlWZPC+YdbN4753/gZVXBv6rf/e2p
	hhxdxl4rOelbJ74Wb6vwZdxneuTlP5Mo2CuIkJfQOwBMurDfXHMHtfo4IP9DtIrgPBP2Dl
	uZc/JaknYWmWWlMxr4qMjjDLSrv/rhw=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [v3 14/24] powerpc/mm: handle split_huge_pmd failure in subpage_prot
Date: Thu, 26 Mar 2026 19:08:56 -0700
Message-ID: <20260327021403.214713-15-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8E71840002
X-Stat-Signature: 4ck47hep9s9r4fg4w1aswqdg7xnqmgkj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774577740-213324
X-HE-Meta: U2FsdGVkX18pkWbCGMJxnaytkuGz6MImYIPsE9ApWSMPQM8Bol0lU0Wrva5EhQX/izNrqpKIG+w5CQDR1gqqJNS9C0nuXds2I8bPIrZqbqELWbR2WmP6sIxZlZVPDsP4Dc6KNUidy3xP5p5ty594g0UrMYLWZVkBQaMb/cgI+dmwPoUJr4tmSsbBFYpL5dg49BeQcwg2Pkg4/LpKc9f9obv+am8TJCbIqKlfo43xJx2x40JRYMnnJzg5vQVDcMloo/y17SbTF45KgnZLaaoarGADpkPMbtNnPO8RAZmSamEjqNxRvxbV1dWfX2XR6dlQKEuWukKyD7dWWBgkrpun4VwQ+Hg4pzLO8trgQOn+u9Xt8LLvEDOtxKHoBO/yXIhfoD0B+UkuTn8/L4RIltV9WvTlfU2fvnr3Pa0Xq7XtpRmWCWXupZP6axnDApo/ycfGwHVTGD+HWwdJ+PllUHuA/Hb1o9LuIhdH7d4B+dbGiHqabkiRi6Em4vsgNM6zC3GEPCp3xMzan3GazLYdege6ZQFLCpFP0lGNCTJ6M4WG8d8UNSDg4Lx7YM7fpByTfOdyZRpfK9e6/stwlaetltjC3cnAFmGzgTfjyFapRWsLpdf5i8da2EKYD8+alkBzpFvnFLUckGOIFgTg9ZqdcGuG6aD3Uhp5ILYTIviyYfcnTuTs9yNipHG1/BYg7uNZm76F2GuLQ+GUlqODHbsPhib07vOT8qI1cCnYw52gKk6dhJcnyltGO0yz+Q7+WisL+PKTlWaaNV6N5smi4JSgAEfeO4rDgpEySDRfkf7ukuDvfN7a+6hAiSRH5C5PJB92qQdB/ii4uB8oqTETy1CZTU6BNhaCV2MpocaMiTsi3CCyftae0KvO56O7zTqPLvby7rZRE8Ql0CzDhUjhycba2+S1Am2YpjOyjMtZGnGB6CYQE8rXFc9vumdornsKF2PjnwrbYBQIBw80uufpVGTdz83
 vlD9PIN/
 59xOl5qOFaHQ/qV2wl/VxbypoUyf/xKP8A8Fr4nRWCw0nFcA0zDnOl6cvr16jFRGmjlFdF/aGBUJPlhJHuoNbpBGoBKsWySrlDrkSG/QOxbpO1lciJ/gO8ST4ZKa9+7IHx0rVlzcfCiEq9bi5nuC+KAfK6i+OlGsGYv+yVToXrRcLkXy34gvFl+wKm+O8lG7QSDoS7Pi4M+OaeRSsPqUluoNpelffX2Z4jPhgXDkA81hRzgs6++31f2ayNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

subpage_walk_pmd_entry() splits huge PMDs when the subpage_prot
syscall controls the access permissions on individual 4 kB.

In practice this cannot fail today: sys_subpage_prot() returns -ENOENT
early when radix is enabled, and on hash powerpc
arch_needs_pgtable_deposit() is true so split uses the pre-deposited
page table and always succeeds. The change is for __must_check
compliance introduced in a later patch and correctness if the call
chain ever becomes reachable on architectures with lazy PTE allocation.

Propagate the error through the full call chain up to the syscall.
The syscall already returns -ENOMEM in other places when it runs out
of memory.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/powerpc/mm/book3s64/subpage_prot.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/subpage_prot.c b/arch/powerpc/mm/book3s64/subpage_prot.c
index 37d47282c3686..b3635a11ff433 100644
--- a/arch/powerpc/mm/book3s64/subpage_prot.c
+++ b/arch/powerpc/mm/book3s64/subpage_prot.c
@@ -139,8 +139,8 @@ static int subpage_walk_pmd_entry(pmd_t *pmd, unsigned long addr,
 				  unsigned long end, struct mm_walk *walk)
 {
 	struct vm_area_struct *vma = walk->vma;
-	split_huge_pmd(vma, pmd, addr);
-	return 0;
+
+	return split_huge_pmd(vma, pmd, addr);
 }
 
 static const struct mm_walk_ops subpage_walk_ops = {
@@ -148,11 +148,12 @@ static const struct mm_walk_ops subpage_walk_ops = {
 	.walk_lock	= PGWALK_WRLOCK_VERIFY,
 };
 
-static void subpage_mark_vma_nohuge(struct mm_struct *mm, unsigned long addr,
-				    unsigned long len)
+static int subpage_mark_vma_nohuge(struct mm_struct *mm, unsigned long addr,
+				   unsigned long len)
 {
 	struct vm_area_struct *vma;
 	VMA_ITERATOR(vmi, mm, addr);
+	int err;
 
 	/*
 	 * We don't try too hard, we just mark all the vma in that range
@@ -160,14 +161,17 @@ static void subpage_mark_vma_nohuge(struct mm_struct *mm, unsigned long addr,
 	 */
 	for_each_vma_range(vmi, vma, addr + len) {
 		vm_flags_set(vma, VM_NOHUGEPAGE);
-		walk_page_vma(vma, &subpage_walk_ops, NULL);
+		err = walk_page_vma(vma, &subpage_walk_ops, NULL);
+		if (err)
+			return err;
 	}
+	return 0;
 }
 #else
-static void subpage_mark_vma_nohuge(struct mm_struct *mm, unsigned long addr,
-				    unsigned long len)
+static int subpage_mark_vma_nohuge(struct mm_struct *mm, unsigned long addr,
+				   unsigned long len)
 {
-	return;
+	return 0;
 }
 #endif
 
@@ -229,7 +233,9 @@ SYSCALL_DEFINE3(subpage_prot, unsigned long, addr,
 		mm->context.hash_context->spt = spt;
 	}
 
-	subpage_mark_vma_nohuge(mm, addr, len);
+	err = subpage_mark_vma_nohuge(mm, addr, len);
+	if (err)
+		goto out;
 	for (limit = addr + len; addr < limit; addr = next) {
 		next = pmd_addr_end(addr, limit);
 		err = -ENOMEM;
-- 
2.52.0


