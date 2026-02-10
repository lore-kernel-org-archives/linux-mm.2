Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B5E2E94627
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 01:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595426B00A2; Mon,  9 Feb 2026 20:53:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 542F26B00A3; Mon,  9 Feb 2026 20:53:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4249A6B00A4; Mon,  9 Feb 2026 20:53:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31F506B00A2
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 20:53:21 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B6653584B2
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 01:53:20 +0000 (UTC)
X-FDA: 84426874560.27.A81C284
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id F0B2020007
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 01:53:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=POnnUt0y;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770688399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aDsSp8JnEXugJ+ejZmX1Dy3hck/c2mrVpwZocOeM8Gc=;
	b=Gm8zfQFP6y7wRpwhQBgIzEvugOCleED2Y8PRjvM/nF9ncJ9mYt47jKmqqpkFzLDlCnTi8/
	g3AIcz0grj47jxVvumhJiEr32h6dR9ZwEMmiVaTHYFwMSczXVjI0HoYnJe8tNriDKDDYIl
	gPpdWYGhgr0HornK6PW3MiBf+tse0lU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770688399; a=rsa-sha256;
	cv=none;
	b=hNBDhLsDCvrqLsvg/40jWHxybgoRD2LEpxh6/fxfJUEohsPwmhHfWazZQwINsQpsHT0YFf
	m1AuGBVEfyr44YWupsVuzsOQw/depFmpCaRZ5GqslEnK3Wzx5PxQFobHW+s1guphX/rLzK
	bulhpJJoeG4IO9sg0eILvetaHdEhea4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=POnnUt0y;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A80484392C;
	Tue, 10 Feb 2026 01:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5500C116C6;
	Tue, 10 Feb 2026 01:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770688397;
	bh=VsCzRTzENQvdbYEZ9wbxc31//QaNgPdb2GF/3ORsK/c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=POnnUt0yg6asAn/zifiuUgLA8LbsgRMM4IXlot5xx+dMJgXHwFv0dqHys90sGVZAo
	 zgy7nOIeGYEDN6IAQPVE5zL9mUVJdMum5Q9gPUboowt1dE1WjBPNbz7h3xRG49Ae0b
	 ec3eBKlC5bL8h/UvEl4losmqkU1lCtpYsMTc4NFM=
Date: Mon, 9 Feb 2026 17:53:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: david@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/5] support batch checking of references and
 unmapping for large folios
Message-Id: <20260209175316.2ef64ee244599765a74a6975@linux-foundation.org>
In-Reply-To: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F0B2020007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: s5prcprr3xwb731ekt9bydzz7sg77hn8
X-HE-Tag: 1770688398-60843
X-HE-Meta: U2FsdGVkX1/s3HS0SSoWU8UKKgY4szQakzigTMIphcQdTDyb6KNJnC8YDg/TEzxB9CdCCrwVDcqmOZ0RarCLRKbNUcXrBr0dYMvp4VF6ndH+yFgDcmvku/tZCHth8V4LqMheo2p7f4oGYzyyiQl4zkHj4ZXogO6VvPHLyh2Be218xYboY/8MvJZapn6wcFy8ULrqmBJft3kNX6r8WlBLT+oOgX6QLQOfjLxUSvtMMDcwBuWOoNPiYuK0qzIe+WnZ7Yjv318nOYkrk7ym+NvtDE5FOJU2RAMe/Sd84qYSiuTczlrr2YxKMCLA4LlTUrxYVpqbksxG7YQHRi42RZJyU6MndcYLQi4ExNU5eewm+YXvv5a+PqZmi78cT/c8hemC/j2XMn+Z4t2OYSDCMkAfsHW7n4gKAb/HGmeS31IRVdStNPjDop47WLRexuJnPJp5ghx986HzqspoxU1OBg7TSAzzJjDt6PbAuUU7HsVzH8cXPFodZPpmJEJD2lxN0y+VaxfFn7wGIzAAAF5Bi2AgCfVVgms9PPzNVflNdue+Tu7ZvrGQ9eLAfK7aRIpqIJni+oGERIhKH52CqGI2EjwdSXrH1sibtSHERO2KeGdSoGibgfwvdceDyejtmQywMY0DTpt3Ez+IMXrFZWleRotAOVgR3N0okDHzIQRj4eCmrn5gSuU0pjMHqwhSXR/xfaU5FJ5hyYe22UieaQEETQhCHskhUVGH6aGtn9fXKVvGBe6mYVPcIZ4A0sriP2v43S1X22po/WgzO5kL7Kj2e2zX7IVEjbSlpFgV/2NYeWgSe50ktlOqjy08B8pPUK4I8edjecs+C2fqWw8eFaQtRlvsH7dzG89h0irJUDS0KImRFMkoDQRMiC+L9PAlnLjx6raV9tiR3xfI4cn1aPNzmZx8klnqTwbrpdMei5A906XWr96PS/MpkNsOZ6bIT+yjYTZ4X3NQj39F+p5O9Ho7oPG
 u2i4p+Yr
 3rV+F8IzmUlhOwKaECa3ETXPnXkFoHLOxWy7yfZBaDpzIcr6Wp6VKCEf3o11o9g8PX4HnMFWjVHwHq5rIj1qFfhbWeXdupzxDnoBOKnlbAyxlL3kMV+GZ2QwDCmmz5Y2qF2FVJRFzknWztJ5xYvYbWLIyU2SYjDfSOBl0TlypXf+BInnOFh0F8+XepruIgC/q8DceHAp+Jtl3ahFNyJNTMAMrXmjAOYdb8I040Td8wSWLp/YYRbdeCV4GtKBhB/kqRn/+q6GupWoDVx5QZAWnFZ5YVulWjm6ojHTobwXPD1PjHZK4ohyyfTkMZvUV9kkzoVCOhgKOQ4bgvSM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  9 Feb 2026 22:07:23 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:

> Currently, folio_referenced_one() always checks the young flag for each PTE
> sequentially, which is inefficient for large folios. This inefficiency is
> especially noticeable when reclaiming clean file-backed large folios, where
> folio_referenced() is observed as a significant performance hotspot.
> 
> Moreover, on Arm architecture, which supports contiguous PTEs, there is already
> an optimization to clear the young flags for PTEs within a contiguous range.
> However, this is not sufficient. We can extend this to perform batched operations
> for the entire large folio (which might exceed the contiguous range: CONT_PTE_SIZE).
> 
> Similar to folio_referenced_one(), we can also apply batched unmapping for large
> file folios to optimize the performance of file folio reclamation. By supporting
> batched checking of the young flags, flushing TLB entries, and unmapping, I can
> observed a significant performance improvements in my performance tests for file
> folios reclamation. Please check the performance data in the commit message of
> each patch.
> 

Thanks, I updated mm.git to this version.  Below is how v6 altered
mm.git.

I notice that this fix:

https://lore.kernel.org/all/de141225-a0c1-41fd-b3e1-bcab09827ddd@linux.alibaba.com/T/#u

was not carried forward.  Was this deliberate?

Also, regarding the 80-column tricks in folio_referenced_one(): we're
allowed to do this ;)


				unsigned long end_addr;
				unsigned int max_nr;

				end_addr = pmd_addr_end(address, vma->vm_end);
				max_nr = (end_addr - address) >> PAGE_SHIFT;




 arch/arm64/include/asm/pgtable.h |    2 +-
 include/linux/pgtable.h          |   16 ++++++++++------
 mm/rmap.c                        |    9 +++------
 3 files changed, 14 insertions(+), 13 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~b
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1843,7 +1843,7 @@ static inline int clear_flush_young_ptes
 					 unsigned long addr, pte_t *ptep,
 					 unsigned int nr)
 {
-	if (likely(nr == 1 && !pte_valid_cont(__ptep_get(ptep))))
+	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
 		return __ptep_clear_flush_young(vma, addr, ptep);
 
 	return contpte_clear_flush_young_ptes(vma, addr, ptep, nr);
--- a/include/linux/pgtable.h~b
+++ a/include/linux/pgtable.h
@@ -1070,8 +1070,8 @@ static inline void wrprotect_ptes(struct
 
 #ifndef clear_flush_young_ptes
 /**
- * clear_flush_young_ptes - Clear the access bit and perform a TLB flush for PTEs
- *			    that map consecutive pages of the same folio.
+ * clear_flush_young_ptes - Mark PTEs that map consecutive pages of the same
+ *			    folio as old and flush the TLB.
  * @vma: The virtual memory area the pages are mapped into.
  * @addr: Address the first page is mapped at.
  * @ptep: Page table pointer for the first entry.
@@ -1087,13 +1087,17 @@ static inline void wrprotect_ptes(struct
  * pages that belong to the same folio.  The PTEs are all in the same PMD.
  */
 static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
-					 unsigned long addr, pte_t *ptep,
-					 unsigned int nr)
+		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
-	int i, young = 0;
+	int young = 0;
 
-	for (i = 0; i < nr; ++i, ++ptep, addr += PAGE_SIZE)
+	for (;;) {
 		young |= ptep_clear_flush_young(vma, addr, ptep);
+		if (--nr == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
+	}
 
 	return young;
 }
--- a/mm/rmap.c~b
+++ a/mm/rmap.c
@@ -963,10 +963,8 @@ static bool folio_referenced_one(struct
 				referenced++;
 		} else if (pvmw.pte) {
 			if (folio_test_large(folio)) {
-				unsigned long end_addr =
-					pmd_addr_end(address, vma->vm_end);
-				unsigned int max_nr =
-					(end_addr - address) >> PAGE_SHIFT;
+				unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
+				unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
 				pte_t pteval = ptep_get(pvmw.pte);
 
 				nr = folio_pte_batch(folio, pvmw.pte,
@@ -974,8 +972,7 @@ static bool folio_referenced_one(struct
 			}
 
 			ptes += nr;
-			if (clear_flush_young_ptes_notify(vma, address,
-						pvmw.pte, nr))
+			if (clear_flush_young_ptes_notify(vma, address, pvmw.pte, nr))
 				referenced++;
 			/* Skip the batched PTEs */
 			pvmw.pte += nr - 1;
_


