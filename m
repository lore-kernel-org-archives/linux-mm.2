Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B65CCF65DC
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 11:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83D5B6B008C; Mon, 26 Jan 2026 06:20:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FF7D6B0092; Mon, 26 Jan 2026 06:20:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681C56B0093; Mon, 26 Jan 2026 06:20:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5649D6B008C
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 06:20:17 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE60658B33
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:20:16 +0000 (UTC)
X-FDA: 84373871232.25.1152C7F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id AAF022000D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:20:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AEASJzsE;
	spf=pass (imf03.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769426414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MIWs13uPtbBYR5vhSSUBlncr2KRdF3LUR9HD+nqyOvQ=;
	b=IxEw8H3kwAa1EJ4VxtxgR18q578z93ZxhVBKlbeF3xkeVyxh6OrXttVSnzzXP6khWpiqMm
	fYBxIAQvr9zrhrYJNvas+kGjXon+5KedGdS+lMYfqhvtToCxd55LF1XM3IckJeQGNE52Dk
	iZ7flM7tOIL5iaKtDSofuw0jnBO4Zjk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AEASJzsE;
	spf=pass (imf03.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769426414; a=rsa-sha256;
	cv=none;
	b=CHxuXYgZzdV2Yyb9TyslRqmqR7yK5/WJlVhtaWHTADc1GPs+w5SI0h6nHjrFgCNYQVK1r1
	ltGqWzuQKJHVEXNUe/UOKQOA4JJbZS3Wjv7rBsyaZh+HLaAlDKKkxqq66hQIAlPb4hZEl+
	FaKy3sLrVft/nPwD5lOWYiu52HB7T7k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769426414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MIWs13uPtbBYR5vhSSUBlncr2KRdF3LUR9HD+nqyOvQ=;
	b=AEASJzsErUNNpevbGRIfPoV1qy4BkMqa+/hPmVBd2O1Ujphkir+OnDZ57EUNGWaIx4WyT6
	tvpxdCpll0K6vH1H4QTnTeojp7KK0oCsa7b/QavC5TetjSiSmMZvz/sF7QCsXs1Y05GwbR
	qoCNG7uTcl7JNUKKtYin0dzCGcfeVvQ=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-422-ZNQP15_9PXKmyUWy6k0jFQ-1; Mon, 26 Jan 2026 06:20:12 -0500
X-MC-Unique: ZNQP15_9PXKmyUWy6k0jFQ-1
X-Mimecast-MFC-AGG-ID: ZNQP15_9PXKmyUWy6k0jFQ_1769426411
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-59b7888640dso2636165e87.3
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 03:20:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769426411; x=1770031211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MIWs13uPtbBYR5vhSSUBlncr2KRdF3LUR9HD+nqyOvQ=;
        b=mL/cu2gEwACDpfRpPqUfcwp8nIsORITEh3HvoX9g7LL7anCW53H7U6T2nQc3gah+Hd
         4kZCQPMhaibze6YbK5QraORnipoQQlX6jVV9WMCHykzR9fRi7SHaY1qqI+4pT1ta4Z+I
         ht34T7wo5NDorCOdQoAtuMvTMEcIjxyFenlTBbjqJm04SsbuK3C0dEOSkbtK9WSAv0VW
         CnUWxGluJ7cyfsr8LxoZ2lOOSE9Z9Y2CgxzBimR+1T5lqbE0yI5F+MbYdclVi2MX1zqz
         2lM8yFOE8eYSqKOOvmlpOfB5eeUvAx2g1I5D8DPrqvc+1Xnnimi7aRr9zIoARMa+5BGb
         +qzw==
X-Gm-Message-State: AOJu0YyHw7QbMLRBHPJK9dfaED2MlmUqe0xSylAm8DGgmYKlmGEoM6cn
	rBh5aIUIee0KLQwXxct3DFa6yYpgYyeQsg0tTDvsSy21ftFaBXDTtPCVHSXBvLfbXax1AJS8Kyr
	11LmgKch/2R3MY8Or1SRd8Uzne4auIMBnJ4VpKLIrAaZLj3f6+vTW6Rtn1wrAkRQuH1TWZS16W+
	yKayS8krsgWiL6QbWcAz+gP6aBp/xmuVeBKms=
X-Gm-Gg: AZuq6aJgOTm0ArxWkGGMoKLmXlFiVF1RVQ2PgBgu6JBd5AANcJ+ra7WudrrpvEEM67r
	0fY3y2dsSdxAutoWTAPL8fz6SwNQphz/mkU8I3n6SFV/ksY46q1j4F86spXmU2X7ayBO5VCrgN9
	ON30WyReGBH+qSrHsjrnJI4Qv1nLCvk0KPIRwqzSGP+8TWGMQr/cCdydmSwmPJfNA3vtidhD0bF
	f4AAaJWqI1Sx8NTIVoqppVhx2MzoYTVg0ZCsMREv8vkMkp2BBPZrlBK9G6LDs/29wC7EQXdZMQ/
	ZrPSbIae8+0S3fanOng+LvLlsnhj2oExCXDJ3KKv8jQhY0h2g3O/DgaA3E7MwXtYmUSgEDA8vqu
	9oZiSlltgHAAB++e7FdD3nFpS
X-Received: by 2002:a05:6512:1385:b0:59d:d5d1:371e with SMTP id 2adb3069b0e04-59df361762fmr1354461e87.20.1769426410871;
        Mon, 26 Jan 2026 03:20:10 -0800 (PST)
X-Received: by 2002:a05:6512:1385:b0:59d:d5d1:371e with SMTP id 2adb3069b0e04-59df361762fmr1354442e87.20.1769426410302;
        Mon, 26 Jan 2026 03:20:10 -0800 (PST)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59de48e5f76sm2572221e87.23.2026.01.26.03.20.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 03:20:09 -0800 (PST)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH v3 3/3] mm:/migrate_device.c: remove migrate_vma_collect_*() functions
Date: Mon, 26 Jan 2026 13:19:39 +0200
Message-ID: <20260126111939.1332983-4-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260126111939.1332983-1-mpenttil@redhat.com>
References: <20260126111939.1332983-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XKOjUMDjP9LY9TCrthjlzklB-GehrdWuHnQJayktdOA_1769426411
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AAF022000D
X-Rspamd-Server: rspam07
X-Stat-Signature: o9rkz4odjepeohctcsidra9ggupxt4hs
X-HE-Tag: 1769426414-712745
X-HE-Meta: U2FsdGVkX1+OG4XbOCsxMC5nfOmy7JhiiRodL83AYOzZ6AZaLMhh0q6AmreB23hOXhTN0kghilWrMl54sL4C77llSp9+5qjhh5LlodhHW2xg1btE3bO8pj4s1VwZFzShGRmi6TLmcNg16c40/Jwkd/oq1dfl9L/Fv4NKbwuXW6Ifph219ob7uDH3N8LW/M1bCVzmqesfffAQ+N9Wmq2Km8GzWxaDG84qMTO6NPLCLOP7Zr8LdtzctBFLiB9ZP7TwpBvV9MT0hzQS1aKD786HNSIFWhpMExCbhncHtNcFI8G5/V5joS9GFd5ZuTOw3ZzTqVuIOJuBe+XnfCDc0whqlRJXmWq22oXBiRUSQWWlXDJwB3P+xyhzAnu4umg98V+ovech6vGBtH+nPbZUIZVPggA7DD8k5VPwzGu+hrnZTw6zqphtSQucZDNyhkQ9APecjiAq9s213Eo5xTm1vJY+h9HiVBjY1JTNekCZIxQiWWqJLy4/G9Y/kM36vxhAVnQEpCprvjpiQfnjvma9FhbI+WlagkGKwntfyhlG5phgVsq6foR5OE7fWdavMMi0fwB/GnLoC7Ui+AJSeQ+6KFe6Y4/VmsI1IKgZLVjJvK36+ys/pKETT2FNLijekruTvpcoeoMSBzn6wmVb0C1W9K9G+V9Gtu363DZ9DUzo/fADaUwkOQG9K38Jr25DT4tBKcCCpg8xLACquwmZY229hALLbiBx8A7GqpAHohif1w82ipDSK1Wis/RePU+R2pFlV907mtnvNrfFBqvicifmPEEdIFsr7Fb2w4BpR5ObWokCIi9P335IalynqZK2VGVe2DWNu1jU5pNykVQvUeZCyuOka2DYPRYRtJfIXQuIIk+OZE7doPQ+kp5YIJWf27X6vSoJZkWlHjagARet+EZFTAR3BKa1+Tql/O9vV33D5WMGzM3zF48zu8aQiAcBk/D2k59ICSTFgamQMXvFfKzawiJ
 utApkW65
 WHp0uVCey7XLjQptdREVCG6UNbYvJgtjX/Rh5Sr88PGl7WPZvpLeJcdmp/RBtsdMWdnDRbA6tl3kJmFgx3hC5JNvRITqj961aTnTFKqBsarIOm5d5c4+hhWTU4pg2Qq05o0Pa2DeOYA4R15ZFD+aEAbGVVHyfz/nUgo5IWetpnw1oahSeMj/wzvItHeA6AwNeOoC2nNz87Pwm/97hgYBZpQQ/SZVqdtgXGoTKB9tQK2rRCsG3oLt0ZQz15B48870gA+SbfEgGbN7zFv5fGkayDwDKu7sa4cedHomzJCnhm/40wJEwclcvCLfWPARAf1rceByBeKLnfUv8KK2GFvvMtFHKhAh2uyXdeOKREMHQmDTWFvk5dZvkuhLiLagEz90P5ekK6Qlcfi9YVjnehBlC6Ip4iTc1bTewnQOvQAu8fYbwV7ajtWG95JZKfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

With the unified fault handling and migrate path,
the migrate_vma_collect_*() functions are unused,
let's remove them.

Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 mm/migrate_device.c | 508 --------------------------------------------
 1 file changed, 508 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index bda6320f6242..c896a4d8bca2 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -18,514 +18,6 @@
 #include <asm/tlbflush.h>
 #include "internal.h"
 
-static int migrate_vma_collect_skip(unsigned long start,
-				    unsigned long end,
-				    struct mm_walk *walk)
-{
-	struct migrate_vma *migrate = walk->private;
-	unsigned long addr;
-
-	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		migrate->dst[migrate->npages] = 0;
-		migrate->src[migrate->npages++] = 0;
-	}
-
-	return 0;
-}
-
-static int migrate_vma_collect_hole(unsigned long start,
-				    unsigned long end,
-				    __always_unused int depth,
-				    struct mm_walk *walk)
-{
-	struct migrate_vma *migrate = walk->private;
-	unsigned long addr;
-
-	/* Only allow populating anonymous memory. */
-	if (!vma_is_anonymous(walk->vma))
-		return migrate_vma_collect_skip(start, end, walk);
-
-	if (thp_migration_supported() &&
-		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
-		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
-		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
-		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE |
-						MIGRATE_PFN_COMPOUND;
-		migrate->dst[migrate->npages] = 0;
-		migrate->npages++;
-		migrate->cpages++;
-
-		/*
-		 * Collect the remaining entries as holes, in case we
-		 * need to split later
-		 */
-		return migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
-	}
-
-	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
-		migrate->dst[migrate->npages] = 0;
-		migrate->npages++;
-		migrate->cpages++;
-	}
-
-	return 0;
-}
-
-/**
- * migrate_vma_split_folio() - Helper function to split a THP folio
- * @folio: the folio to split
- * @fault_page: struct page associated with the fault if any
- *
- * Returns 0 on success
- */
-static int migrate_vma_split_folio(struct folio *folio,
-				   struct page *fault_page)
-{
-	int ret;
-	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
-	struct folio *new_fault_folio = NULL;
-
-	if (folio != fault_folio) {
-		folio_get(folio);
-		folio_lock(folio);
-	}
-
-	ret = split_folio(folio);
-	if (ret) {
-		if (folio != fault_folio) {
-			folio_unlock(folio);
-			folio_put(folio);
-		}
-		return ret;
-	}
-
-	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
-
-	/*
-	 * Ensure the lock is held on the correct
-	 * folio after the split
-	 */
-	if (!new_fault_folio) {
-		folio_unlock(folio);
-		folio_put(folio);
-	} else if (folio != new_fault_folio) {
-		if (new_fault_folio != fault_folio) {
-			folio_get(new_fault_folio);
-			folio_lock(new_fault_folio);
-		}
-		folio_unlock(folio);
-		folio_put(folio);
-	}
-
-	return 0;
-}
-
-/** migrate_vma_collect_huge_pmd - collect THP pages without splitting the
- * folio for device private pages.
- * @pmdp: pointer to pmd entry
- * @start: start address of the range for migration
- * @end: end address of the range for migration
- * @walk: mm_walk callback structure
- * @fault_folio: folio associated with the fault if any
- *
- * Collect the huge pmd entry at @pmdp for migration and set the
- * MIGRATE_PFN_COMPOUND flag in the migrate src entry to indicate that
- * migration will occur at HPAGE_PMD granularity
- */
-static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
-					unsigned long end, struct mm_walk *walk,
-					struct folio *fault_folio)
-{
-	struct mm_struct *mm = walk->mm;
-	struct folio *folio;
-	struct migrate_vma *migrate = walk->private;
-	spinlock_t *ptl;
-	int ret;
-	unsigned long write = 0;
-
-	ptl = pmd_lock(mm, pmdp);
-	if (pmd_none(*pmdp)) {
-		spin_unlock(ptl);
-		return migrate_vma_collect_hole(start, end, -1, walk);
-	}
-
-	if (pmd_trans_huge(*pmdp)) {
-		if (!(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
-			spin_unlock(ptl);
-			return migrate_vma_collect_skip(start, end, walk);
-		}
-
-		folio = pmd_folio(*pmdp);
-		if (is_huge_zero_folio(folio)) {
-			spin_unlock(ptl);
-			return migrate_vma_collect_hole(start, end, -1, walk);
-		}
-		if (pmd_write(*pmdp))
-			write = MIGRATE_PFN_WRITE;
-	} else if (!pmd_present(*pmdp)) {
-		const softleaf_t entry = softleaf_from_pmd(*pmdp);
-
-		folio = softleaf_to_folio(entry);
-
-		if (!softleaf_is_device_private(entry) ||
-			!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
-			(folio->pgmap->owner != migrate->pgmap_owner)) {
-			spin_unlock(ptl);
-			return migrate_vma_collect_skip(start, end, walk);
-		}
-
-		if (softleaf_is_migration(entry)) {
-			migration_entry_wait_on_locked(entry, ptl);
-			spin_unlock(ptl);
-			return -EAGAIN;
-		}
-
-		if (softleaf_is_device_private_write(entry))
-			write = MIGRATE_PFN_WRITE;
-	} else {
-		spin_unlock(ptl);
-		return -EAGAIN;
-	}
-
-	folio_get(folio);
-	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
-		spin_unlock(ptl);
-		folio_put(folio);
-		return migrate_vma_collect_skip(start, end, walk);
-	}
-
-	if (thp_migration_supported() &&
-		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
-		(IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
-		 IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
-
-		struct page_vma_mapped_walk pvmw = {
-			.ptl = ptl,
-			.address = start,
-			.pmd = pmdp,
-			.vma = walk->vma,
-		};
-
-		unsigned long pfn = page_to_pfn(folio_page(folio, 0));
-
-		migrate->src[migrate->npages] = migrate_pfn(pfn) | write
-						| MIGRATE_PFN_MIGRATE
-						| MIGRATE_PFN_COMPOUND;
-		migrate->dst[migrate->npages++] = 0;
-		migrate->cpages++;
-		ret = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
-		if (ret) {
-			migrate->npages--;
-			migrate->cpages--;
-			migrate->src[migrate->npages] = 0;
-			migrate->dst[migrate->npages] = 0;
-			goto fallback;
-		}
-		migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
-		spin_unlock(ptl);
-		return 0;
-	}
-
-fallback:
-	spin_unlock(ptl);
-	if (!folio_test_large(folio))
-		goto done;
-	ret = split_folio(folio);
-	if (fault_folio != folio)
-		folio_unlock(folio);
-	folio_put(folio);
-	if (ret)
-		return migrate_vma_collect_skip(start, end, walk);
-	if (pmd_none(pmdp_get_lockless(pmdp)))
-		return migrate_vma_collect_hole(start, end, -1, walk);
-
-done:
-	return -ENOENT;
-}
-
-static int migrate_vma_collect_pmd(pmd_t *pmdp,
-				   unsigned long start,
-				   unsigned long end,
-				   struct mm_walk *walk)
-{
-	struct migrate_vma *migrate = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	struct mm_struct *mm = vma->vm_mm;
-	unsigned long addr = start, unmapped = 0;
-	spinlock_t *ptl;
-	struct folio *fault_folio = migrate->fault_page ?
-		page_folio(migrate->fault_page) : NULL;
-	pte_t *ptep;
-
-again:
-	if (pmd_trans_huge(*pmdp) || !pmd_present(*pmdp)) {
-		int ret = migrate_vma_collect_huge_pmd(pmdp, start, end, walk, fault_folio);
-
-		if (ret == -EAGAIN)
-			goto again;
-		if (ret == 0)
-			return 0;
-	}
-
-	ptep = pte_offset_map_lock(mm, pmdp, start, &ptl);
-	if (!ptep)
-		goto again;
-	arch_enter_lazy_mmu_mode();
-	ptep += (addr - start) / PAGE_SIZE;
-
-	for (; addr < end; addr += PAGE_SIZE, ptep++) {
-		struct dev_pagemap *pgmap;
-		unsigned long mpfn = 0, pfn;
-		struct folio *folio;
-		struct page *page;
-		softleaf_t entry;
-		pte_t pte;
-
-		pte = ptep_get(ptep);
-
-		if (pte_none(pte)) {
-			if (vma_is_anonymous(vma)) {
-				mpfn = MIGRATE_PFN_MIGRATE;
-				migrate->cpages++;
-			}
-			goto next;
-		}
-
-		if (!pte_present(pte)) {
-			/*
-			 * Only care about unaddressable device page special
-			 * page table entry. Other special swap entries are not
-			 * migratable, and we ignore regular swapped page.
-			 */
-			entry = softleaf_from_pte(pte);
-			if (!softleaf_is_device_private(entry))
-				goto next;
-
-			page = softleaf_to_page(entry);
-			pgmap = page_pgmap(page);
-			if (!(migrate->flags &
-				MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
-			    pgmap->owner != migrate->pgmap_owner)
-				goto next;
-
-			folio = page_folio(page);
-			if (folio_test_large(folio)) {
-				int ret;
-
-				arch_leave_lazy_mmu_mode();
-				pte_unmap_unlock(ptep, ptl);
-				ret = migrate_vma_split_folio(folio,
-							  migrate->fault_page);
-
-				if (ret) {
-					if (unmapped)
-						flush_tlb_range(walk->vma, start, end);
-
-					return migrate_vma_collect_skip(addr, end, walk);
-				}
-
-				goto again;
-			}
-
-			mpfn = migrate_pfn(page_to_pfn(page)) |
-					MIGRATE_PFN_MIGRATE;
-			if (softleaf_is_device_private_write(entry))
-				mpfn |= MIGRATE_PFN_WRITE;
-		} else {
-			pfn = pte_pfn(pte);
-			if (is_zero_pfn(pfn) &&
-			    (migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
-				mpfn = MIGRATE_PFN_MIGRATE;
-				migrate->cpages++;
-				goto next;
-			}
-			page = vm_normal_page(migrate->vma, addr, pte);
-			if (page && !is_zone_device_page(page) &&
-			    !(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
-				goto next;
-			} else if (page && is_device_coherent_page(page)) {
-				pgmap = page_pgmap(page);
-
-				if (!(migrate->flags &
-					MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
-					pgmap->owner != migrate->pgmap_owner)
-					goto next;
-			}
-			folio = page ? page_folio(page) : NULL;
-			if (folio && folio_test_large(folio)) {
-				int ret;
-
-				arch_leave_lazy_mmu_mode();
-				pte_unmap_unlock(ptep, ptl);
-				ret = migrate_vma_split_folio(folio,
-							  migrate->fault_page);
-
-				if (ret) {
-					if (unmapped)
-						flush_tlb_range(walk->vma, start, end);
-
-					return migrate_vma_collect_skip(addr, end, walk);
-				}
-
-				goto again;
-			}
-			mpfn = migrate_pfn(pfn) | MIGRATE_PFN_MIGRATE;
-			mpfn |= pte_write(pte) ? MIGRATE_PFN_WRITE : 0;
-		}
-
-		if (!page || !page->mapping) {
-			mpfn = 0;
-			goto next;
-		}
-
-		/*
-		 * By getting a reference on the folio we pin it and that blocks
-		 * any kind of migration. Side effect is that it "freezes" the
-		 * pte.
-		 *
-		 * We drop this reference after isolating the folio from the lru
-		 * for non device folio (device folio are not on the lru and thus
-		 * can't be dropped from it).
-		 */
-		folio = page_folio(page);
-		folio_get(folio);
-
-		/*
-		 * We rely on folio_trylock() to avoid deadlock between
-		 * concurrent migrations where each is waiting on the others
-		 * folio lock. If we can't immediately lock the folio we fail this
-		 * migration as it is only best effort anyway.
-		 *
-		 * If we can lock the folio it's safe to set up a migration entry
-		 * now. In the common case where the folio is mapped once in a
-		 * single process setting up the migration entry now is an
-		 * optimisation to avoid walking the rmap later with
-		 * try_to_migrate().
-		 */
-		if (fault_folio == folio || folio_trylock(folio)) {
-			bool anon_exclusive;
-			pte_t swp_pte;
-
-			flush_cache_page(vma, addr, pte_pfn(pte));
-			anon_exclusive = folio_test_anon(folio) &&
-					  PageAnonExclusive(page);
-			if (anon_exclusive) {
-				pte = ptep_clear_flush(vma, addr, ptep);
-
-				if (folio_try_share_anon_rmap_pte(folio, page)) {
-					set_pte_at(mm, addr, ptep, pte);
-					if (fault_folio != folio)
-						folio_unlock(folio);
-					folio_put(folio);
-					mpfn = 0;
-					goto next;
-				}
-			} else {
-				pte = ptep_get_and_clear(mm, addr, ptep);
-			}
-
-			migrate->cpages++;
-
-			/* Set the dirty flag on the folio now the pte is gone. */
-			if (pte_dirty(pte))
-				folio_mark_dirty(folio);
-
-			/* Setup special migration page table entry */
-			if (mpfn & MIGRATE_PFN_WRITE)
-				entry = make_writable_migration_entry(
-							page_to_pfn(page));
-			else if (anon_exclusive)
-				entry = make_readable_exclusive_migration_entry(
-							page_to_pfn(page));
-			else
-				entry = make_readable_migration_entry(
-							page_to_pfn(page));
-			if (pte_present(pte)) {
-				if (pte_young(pte))
-					entry = make_migration_entry_young(entry);
-				if (pte_dirty(pte))
-					entry = make_migration_entry_dirty(entry);
-			}
-			swp_pte = swp_entry_to_pte(entry);
-			if (pte_present(pte)) {
-				if (pte_soft_dirty(pte))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_uffd_wp(pte))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
-			} else {
-				if (pte_swp_soft_dirty(pte))
-					swp_pte = pte_swp_mksoft_dirty(swp_pte);
-				if (pte_swp_uffd_wp(pte))
-					swp_pte = pte_swp_mkuffd_wp(swp_pte);
-			}
-			set_pte_at(mm, addr, ptep, swp_pte);
-
-			/*
-			 * This is like regular unmap: we remove the rmap and
-			 * drop the folio refcount. The folio won't be freed, as
-			 * we took a reference just above.
-			 */
-			folio_remove_rmap_pte(folio, page, vma);
-			folio_put(folio);
-
-			if (pte_present(pte))
-				unmapped++;
-		} else {
-			folio_put(folio);
-			mpfn = 0;
-		}
-
-next:
-		migrate->dst[migrate->npages] = 0;
-		migrate->src[migrate->npages++] = mpfn;
-	}
-
-	/* Only flush the TLB if we actually modified any entries */
-	if (unmapped)
-		flush_tlb_range(walk->vma, start, end);
-
-	arch_leave_lazy_mmu_mode();
-	pte_unmap_unlock(ptep - 1, ptl);
-
-	return 0;
-}
-
-static const struct mm_walk_ops migrate_vma_walk_ops = {
-	.pmd_entry		= migrate_vma_collect_pmd,
-	.pte_hole		= migrate_vma_collect_hole,
-	.walk_lock		= PGWALK_RDLOCK,
-};
-
-/*
- * migrate_vma_collect() - collect pages over a range of virtual addresses
- * @migrate: migrate struct containing all migration information
- *
- * This will walk the CPU page table. For each virtual address backed by a
- * valid page, it updates the src array and takes a reference on the page, in
- * order to pin the page until we lock it and unmap it.
- */
-static void migrate_vma_collect(struct migrate_vma *migrate)
-{
-	struct mmu_notifier_range range;
-
-	/*
-	 * Note that the pgmap_owner is passed to the mmu notifier callback so
-	 * that the registered device driver can skip invalidating device
-	 * private page mappings that won't be migrated.
-	 */
-	mmu_notifier_range_init_owner(&range, MMU_NOTIFY_MIGRATE, 0,
-		migrate->vma->vm_mm, migrate->start, migrate->end,
-		migrate->pgmap_owner);
-	mmu_notifier_invalidate_range_start(&range);
-
-	walk_page_range(migrate->vma->vm_mm, migrate->start, migrate->end,
-			&migrate_vma_walk_ops, migrate);
-
-	mmu_notifier_invalidate_range_end(&range);
-	migrate->end = migrate->start + (migrate->npages << PAGE_SHIFT);
-}
-
 /*
  * migrate_vma_check_page() - check if page is pinned or not
  * @page: struct page to check
-- 
2.50.0


