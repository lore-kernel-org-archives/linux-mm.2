Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5FB1CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 13:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 313BB80143; Tue, 28 Oct 2025 09:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EBC68013F; Tue, 28 Oct 2025 09:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2023980143; Tue, 28 Oct 2025 09:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DE4C8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:22:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1C51585BA
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:22:47 +0000 (UTC)
X-FDA: 84047587974.02.94B0E3C
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id A8C631C0007
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:22:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lzMf5OFv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761657765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LGSMnG+dfPqB5PeO9+sIbuI2ifAbohOvGlLiOHf29mA=;
	b=4BJ1EeXsCRfLJwGDHDFl7vL8Mk77O+2aQAdQ7DE1HTvlmBtFnWrmsipCGsmv2bPf3FIQWB
	tg7NuotiibZJKOtDcT1pLUO7+c/7ewRQ/4U2sVTMtjBhKcO8UHyqP4Cyj1SU7tJCCff92M
	xpnMQhtKNqSJ9L9VKopIEHrdZ38SU74=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761657765; a=rsa-sha256;
	cv=none;
	b=5bRLkFpi4iGx08oP0Wbpu5LpQ9N0LsOWOy/YYDyYjx/usDKmGQ55e5z0jDmeAoGKifhYDD
	4mh2PlnD1c/cEBM/eziANTeqhQnNu5BmtyH9CfE/O6RBfnPFVAJHYGHw1KhhJzbPDbYR58
	sH3NlghO6oc2QgRhN7crg5qCbNfAkSc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lzMf5OFv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-290d4d421f6so55944925ad.2
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761657764; x=1762262564; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LGSMnG+dfPqB5PeO9+sIbuI2ifAbohOvGlLiOHf29mA=;
        b=lzMf5OFvsZB+HGcg4nnk9MUEgWOpar7qKSivzSC01qhloY1SKNYFDXTUJP9QR8Qj8x
         hKVVPg1zvphII1c+rc8fdV/DBwNzvHkRvKG5H6NImlc4pKYxUUCQ0nnCHISkfXfCSRQv
         a52yWqRqkuHCPLR0DHSin+6eZfZy/bV4fjt9wGt75nyhALUp0tDDM8wIRSc9PrgsRQlz
         mKy8qld6fqFS0exP3Lr4ErC/N2H9tpZW9cX6l0gD0RR76XCbYHpo2T+nYZvwJyqfYFOw
         kRCwjpfx06gU7RxMc6AkZVtz+EguLOkHbW0rbOFfF/cDz2KtwEUN6J4+hdxoQAFbXGIS
         7inw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761657764; x=1762262564;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LGSMnG+dfPqB5PeO9+sIbuI2ifAbohOvGlLiOHf29mA=;
        b=kDOBGXCba3cm5xxHe2f9UsLObYCY4v57Bqyi8EbE2YUJj83miP01eIxWgZU8sC4yDr
         OLq6tB131hC0Qu7sAOVTRuY3S0bckz7jc/5fKhAEz1Keb2xTeRsz8M1ipg8a+APOIWzl
         KgVW8v9jJPXWkXajWtjTIhLla6S0MVY7sM4FdS5OXnQr/UnX2u5tVR2ejWXNbttIMeS9
         HCa8dB5Jd+QSmcVFAcZjthe4PKSoNS9OHatMIL2bzljOpzB4o5537WkInUc6CDeXLtTj
         yElDpUg4rLuF92xb9ExcKnwZopnYILvuQB7sUw+N2uLiYREezqY2r1l5QZRGsTAaaXah
         7+Cg==
X-Forwarded-Encrypted: i=1; AJvYcCVE9ecjAnaFLkFDrN6y0H/2FGQ/cUgKOmBLSNCZVwjBN8vsCqioKTZk+TMmQOAtrJeaoDxYs7tAow==@kvack.org
X-Gm-Message-State: AOJu0YyDfzqbee1kLMlCFCi0OWk/s1uD+Gsr7eR3rbTyIowiuYDYsyct
	0a4o8ieuJ37BMlKQLUKDhJi+lbIAj4X2rcEHkH545ixfI7XzL8mNjZJf
X-Gm-Gg: ASbGncvMxD3zxa4cVT7W7MGot4k8oqPUtML1c5rxZH1lAvExMnfVnC89Xyo7/ipKO+8
	uOjItJOcqUHUz5HsSicRLB6Z0Xhl9HKnx6PakRlxNPDgwkc2VupfohnY4JdvovPn1UeL2wtZc/q
	zt2IJISsI/a0wsAgj2IjvpxgGKenxzRh6Nm+2aPgvFEKlkmKodCp8HekHUylOsoYPa+YesfQPBt
	9OkQdv/l2gaG0YjVqB3IEJ41tLJy3v268CQsSDnmiwQkViyBAX0DShf4SGjB3mQ2O6m0V8dTZhd
	vd3icdsz66cYC2Z6FAWlKUJ+jka9PWS5wR3pvoYV8NuPrdUcxtTB4tpi1IpEfZqROH/SPTLRW/V
	DRYbS4Jl0EaVixr3AkAJlm2ozG1EOtgShjqtwruyKbyMMnwWDvhVxeKGIckOeSx3wHRpgFU67HF
	3Sn5JoMZcLPVarHAokTQ9MECVE
X-Google-Smtp-Source: AGHT+IERdQtSDdu2ALxwESRZtQdoqizCIyrUk8LFMRRdLzwdff1L8If+YNv1ncII0+3vpd4kLKVlkw==
X-Received: by 2002:a17:902:da91:b0:267:a1f1:9b23 with SMTP id d9443c01a7336-294cb3816e6mr48946635ad.18.1761657764129;
        Tue, 28 Oct 2025 06:22:44 -0700 (PDT)
Received: from weg-ThinkPad-P16v-Gen-2.. ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29498d0c6eesm117446235ad.42.2025.10.28.06.22.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 06:22:42 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH 2/3] ksm: perform a range-walk in break_ksm
Date: Tue, 28 Oct 2025 10:19:44 -0300
Message-ID: <20251028131945.26445-3-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251028131945.26445-1-pedrodemargomes@gmail.com>
References: <20251028131945.26445-1-pedrodemargomes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: xpfy4s5wx11du3i1t13spgc5wrm1j3kx
X-Rspam-User: 
X-Rspamd-Queue-Id: A8C631C0007
X-HE-Tag: 1761657765-271353
X-HE-Meta: U2FsdGVkX1/SL6cwOj0emk4YYZlI9C3lqKynRL69a5Uuyj27CtbTP6JPuDfEMLlcTJ1K+m5T7AA9SPcqIBrtsgBTk8ZBpPEsSUIdGNL7Q9OWVcH36W17PxYWh1RHeIZyiEzsskR6rdfmiV1T60okqIRUFTP6NZQSw2E1JUMdnUukz7igLFDa+Y9YBcex3ZV2zP6oZbmOAzxde9YNtOVZMjE/cWtiELzNMfYLkoFT30X+cTVrDSdmd+QaoB87FELEobLfJhEcEECmCX0szaPNTTnJfDh8OlnTtBr7YcPRoSCrcbriCb0UHLcESCNYgzxP10m2KMRW6HMXwckwoV6HsOdWIKoV9dsbbBROt9rtxiZLfTHCo6r2RtHiDv4HKAqDTOQemOQKdfVZqfrOWs4tprcza+eJzQdsPn4vdkqmI8EoPXFHdSDThflTblQ/zwb5z/J3UuDfhhY8V3l2c9vOsimU/7rwYkcOD7Zi3PHSzLjtlgZN4dhmok2Y9hvtC9H6y/vXFK72TJX67B7s32fxQx+RUXbS8LtP+/y90V4DU5CZ6TsRRsKQLHyH54BKLhPRXbt2VyM0GZvyFVXMl+/4/mIOmQredrqX3Qq+dKzBGGSFJGKb0u0eOkMLU/mOwdRsl2ETA2ly7Yg2GrzRhcFp3re+8iFUS87qVjor5txgR5dL0pAgPx5gJLt752COzkuhyE4O3MjHn2l9iVl157Ocmf7xHlbRjkaDbdaJQF8ERZexHfF4qnJoHnT4+zwrB6C074LneAbFRB6atb61xzv9OeUT9JUEACRgQRZOG4rqTtaZGirfDMkjhJMDHd/1783j7jMD42C0888tUA8ntRt88DsmMk+0NvuRlMKVtXU+u6Nv0whU8N2/iLz8idQnyNRGb5TXdlAmpooC7msrHHeHJWRoTXjBWfv2yOuppaf0t/+VkaCYDygFrw2J5K/WXgYU/T1cABCqIl3/Q16ABX/
 bpuRacLG
 ezkYGwXWGg6ceFHYpdhTePNRD6O38s6mC6ZBO7ilM3jYBkTSXa4DdwboT13C1/5vlY7yeblE3/Hn+HBX35O3NADaPrzitaWSsBmIosvLQFqvsn5vxlSVAcUpJXkUBTMLWxhQlaIK9wxxI1c7Yqd1gPTqonzX6pr+tfWxHJ0nxtMkEXOr+VTaD/tMwZxzpHCo66zx1T8G0/RFc6E0Exz9rK4ISw1TRz/v+hdetd1eD5wPUdGs9ZhwA5zeXktByIATV/X66cUqWyH6QztkDv+NAWSBVwjANpTJHeffIkt3QSBsA4/0Dwkz3dXkuYDh2lZjUPOYo4qFUalMKhrSpFtGxWpVCrPBhIaUcy4mxFbji1sWuYskBANsMYoEAhQrzoXUdIGwk70IS23WtET8fpvfzCIOGFEGUXi4+09AFsffaos6vbjuTjiCBseaQMhbVCTDcu0H4fQIDACJL8BWX7/cjRk0eEwtNEf369byf3zOzB+umizk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make break_ksm() receive an address range and change
break_ksm_pmd_entry() to perform a range-walk and return the address of
the first ksm page found.

This change allows break_ksm() to skip unmapped regions instead of
iterating every page address. When unmerging large sparse VMAs, this
significantly reduces runtime, as confirmed by benchmark test (see
cover letter).

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 mm/ksm.c | 88 +++++++++++++++++++++++++++++++-------------------------
 1 file changed, 49 insertions(+), 39 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 2a9a7fd4c777..1d1ef0554c7c 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -607,34 +607,54 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
 	return atomic_read(&mm->mm_users) == 0;
 }
 
-static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
+struct break_ksm_arg {
+	unsigned long addr;
+};
+
+static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long end,
 			struct mm_walk *walk)
 {
-	struct page *page = NULL;
+	struct page *page;
 	spinlock_t *ptl;
-	pte_t *pte;
-	pte_t ptent;
-	int ret;
+	pte_t *start_ptep = NULL, *ptep, pte;
+	int ret = 0;
+	struct mm_struct *mm = walk->mm;
+	struct break_ksm_arg *private = (struct break_ksm_arg *) walk->private;
 
-	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	if (!pte)
+	if (ksm_test_exit(walk->mm))
 		return 0;
-	ptent = ptep_get(pte);
-	if (pte_present(ptent)) {
-		page = vm_normal_page(walk->vma, addr, ptent);
-	} else if (!pte_none(ptent)) {
-		swp_entry_t entry = pte_to_swp_entry(ptent);
 
-		/*
-		 * As KSM pages remain KSM pages until freed, no need to wait
-		 * here for migration to end.
-		 */
-		if (is_migration_entry(entry))
-			page = pfn_swap_entry_to_page(entry);
+	if (signal_pending(current))
+		return -ERESTARTSYS;
+
+	start_ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	if (!start_ptep)
+		return 0;
+
+	for (ptep = start_ptep; addr < end; ptep++, addr += PAGE_SIZE) {
+		pte = ptep_get(ptep);
+		page = NULL;
+		if (pte_present(pte)) {
+			page = vm_normal_page(walk->vma, addr, pte);
+		} else if (!pte_none(pte)) {
+			swp_entry_t entry = pte_to_swp_entry(pte);
+
+			/*
+			 * As KSM pages remain KSM pages until freed, no need to wait
+			 * here for migration to end.
+			 */
+			if (is_migration_entry(entry))
+				page = pfn_swap_entry_to_page(entry);
+		}
+		/* return 1 if the page is an normal ksm page or KSM-placed zero page */
+		ret = (page && folio_test_ksm(page_folio(page))) || is_ksm_zero_pte(pte);
+		if (ret) {
+			private->addr = addr;
+			goto out_unlock;
+		}
 	}
-	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
-	ret = (page && folio_test_ksm(page_folio(page))) || is_ksm_zero_pte(ptent);
-	pte_unmap_unlock(pte, ptl);
+out_unlock:
+	pte_unmap_unlock(ptep, ptl);
 	return ret;
 }
 
@@ -661,9 +681,11 @@ static const struct mm_walk_ops break_ksm_lock_vma_ops = {
  * of the process that owns 'vma'.  We also do not want to enforce
  * protection keys here anyway.
  */
-static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_vma)
+static int break_ksm(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long end, bool lock_vma)
 {
 	vm_fault_t ret = 0;
+	struct break_ksm_arg break_ksm_arg;
 	const struct mm_walk_ops *ops = lock_vma ?
 				&break_ksm_lock_vma_ops : &break_ksm_ops;
 
@@ -671,11 +693,10 @@ static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_v
 		int ksm_page;
 
 		cond_resched();
-		ksm_page = walk_page_range_vma(vma, addr, addr + 1, ops, NULL);
-		if (WARN_ON_ONCE(ksm_page < 0))
+		ksm_page = walk_page_range_vma(vma, addr, end, ops, &break_ksm_arg);
+		if (ksm_page <= 0)
 			return ksm_page;
-		if (!ksm_page)
-			return 0;
+		addr = break_ksm_arg.addr;
 		ret = handle_mm_fault(vma, addr,
 				      FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
 				      NULL);
@@ -761,7 +782,7 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
 	if (vma)
-		break_ksm(vma, addr, false);
+		break_ksm(vma, addr, addr + 1, false);
 	mmap_read_unlock(mm);
 }
 
@@ -1072,18 +1093,7 @@ static void remove_trailing_rmap_items(struct ksm_rmap_item **rmap_list)
 static int unmerge_ksm_pages(struct vm_area_struct *vma,
 			     unsigned long start, unsigned long end, bool lock_vma)
 {
-	unsigned long addr;
-	int err = 0;
-
-	for (addr = start; addr < end && !err; addr += PAGE_SIZE) {
-		if (ksm_test_exit(vma->vm_mm))
-			break;
-		if (signal_pending(current))
-			err = -ERESTARTSYS;
-		else
-			err = break_ksm(vma, addr, lock_vma);
-	}
-	return err;
+	return break_ksm(vma, start, end, lock_vma);
 }
 
 static inline
-- 
2.43.0


