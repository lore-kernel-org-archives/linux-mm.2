Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1874BCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 18:51:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74F458E000A; Wed,  5 Nov 2025 13:51:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 726B88E0002; Wed,  5 Nov 2025 13:51:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615D38E000A; Wed,  5 Nov 2025 13:51:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CB308E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 13:51:55 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 196C81A045B
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:51:55 +0000 (UTC)
X-FDA: 84077447790.04.158AA86
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4123A12000F
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 18:51:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CMC9MW7J;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762368713; a=rsa-sha256;
	cv=none;
	b=SjaorJ84duejnkPQXo6IfqFEMRJHAyhwOgkZJe4YMQb8k4yXDwNN8KA0YpMD+X+xUgAG83
	qdnUH9y3tQyw5byhTr1sqdZdeSfkydxWEFOEF/QhfWKlYpxXXoZgEEpOYXId+n28LP+Y4T
	OO5tfMR0onCW9Dk6reS7WJgokCnkkAA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CMC9MW7J;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762368713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IUaQOSDeSY3xlmWNT6LRyPB2LIv5pFA+AQBxwZjm9KA=;
	b=LIkMqwvu7TZrqWEcmOCrNm4d87/hciiHgSGTFBHXxDDjF6Uy3zBdymC+duOrfVX5U/4XV+
	x9XxtZIc2n8qeli3v/KR/QNPAdQZnU22ocWHxBRNls3wVkeKUTjaa8AF3ggfav/L30Cnqz
	fZdF9i4F/Yku+B3Hg/ShomD77ODEvPY=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7af5d99f500so279149b3a.0
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 10:51:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762368712; x=1762973512; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IUaQOSDeSY3xlmWNT6LRyPB2LIv5pFA+AQBxwZjm9KA=;
        b=CMC9MW7JbFfYcS3rKxEOxpv/NkjuKAiUtAHAnlV1F7N4m7W6rj92LstMtEc7CRqZQJ
         wZqikv6r340GuxNSXVp0zcVwHAOjOxbxaoGlJyLiZgx9iRnCeKaBZhHkgR1ot0Rl+Z/Y
         rPB7KcoqeVrfJL4C1mKrbar5v7woIvWSpC21SV47e8uA72MEK2UXeujcD4pSxcgGJVYJ
         BfjfqO3/PI2WNoYLFARzNtyLcMU2cAGH6tr2YG+Cci0FmfxpT7hoxxZ3EGdgAp5JEbby
         NVqj1/HwLAZ/7QvQnoHWAMYPLLLWCeGNBTfSD5U4CGSCvwkKgL7i1B5JZ6tLM6MnPOTY
         ARNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762368712; x=1762973512;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IUaQOSDeSY3xlmWNT6LRyPB2LIv5pFA+AQBxwZjm9KA=;
        b=JeOHWCE7aYsXZcDdmFu/sEqCr/3ia77OF5Y/h15TVkzt940AQAHRe4BgakFsTPwRjx
         eTdw4ypNE7goeg10Lq9kF1pvAy/GA3cuu9rwv4Yog949MGLBA+IdKTkFlV3FwBn0tRam
         5/De7gdRLKfdsUbkJT6pnq3BGGY/4ek9eHEMFp+YE3VYLpS+2xSqcazVcB8vNjmc0aHG
         GXmTXTMoKQFt4UJE2EdhPrSFHFkPHvikHjimobdYqtfN1CYRgvPNmH7PpOOcWGLw99lP
         S0kEaqk7lRxI0dEeOFEJggqRySlfs5ALxwnoHcwC13+Stvv5eZ6BdX/7MAIckvucO0Mh
         iOrA==
X-Forwarded-Encrypted: i=1; AJvYcCVQrXHOSfK72uIE5V2ayusMEf8XdG4GhkPzt5xG5BHE6+sEtH+mlPHwpBw2GDC25wwpf/KykSiasw==@kvack.org
X-Gm-Message-State: AOJu0YylTVaDZPJnxJ8Uqd8vrmK990mzYhUYcdJy0oLTBBtfbGcVMKOW
	mrStBlFXNS9FLFEBKAu5R3GcDA+YDEfJHXWawkAs6FVszjQo+Ccy0xG6kfIWJQ0L/pc=
X-Gm-Gg: ASbGncv7BEPRGwdgM053zT0/r3OKJG2xSZIkMkrOAYyZlEh2FMaM341DIAmdMIWj2CU
	DBqWn0g/1aQ9ScK/OaUfa9jSG6y2zoVdEZbXjDydKo+UEnvpb5dnH1audAJk78VtWD9iLQcz5+6
	N/YNQq9YuaoIZ+r80VPALpPw1e3rKOolF6OgfiRwwMyz5fKzuoSy0FrMKMrHg/Y55hCsYA83iaW
	xNpVdu/ZLppdSBiEON8Z0iuDoga7PMU52NbbB0FSyoIJQ03J6+y4vblIi3AHH+TLCu0FccfnRc5
	24Q8wNzIQLqqYSS0i6HnizhIntacip09sdmNgPPuZc+V6cKv/gE6gq7tyJHQUw3ciP9+ZjkeGtZ
	8hO4MtklEQeShRLgpVAGHLmevQMDbomIDu3UGVFv70/tk8ZJZj8m37eCc9jMBrj1IvpUb8arTrf
	sfs9zC3AvK2m5NdVKIFzS/d9JsjL4tsMBLPc4xqafhSd6Rx61ulL4i+MBlp9W5iS6W2bk=
X-Google-Smtp-Source: AGHT+IHxASxsK8vTXLXO/0PsN4EEUlCT4YiPJmJu56rmIQqT4YnWndf+GkwmJcPBmnTEv82AgRzXbw==
X-Received: by 2002:aa7:8891:0:b0:781:be:277e with SMTP id d2e1a72fcca58-7ae1cb61439mr4730826b3a.4.1762368711955;
        Wed, 05 Nov 2025 10:51:51 -0800 (PST)
Received: from weg-ThinkPad-P16v-Gen-2.. ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7af827effebsm118409b3a.57.2025.11.05.10.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 10:51:51 -0800 (PST)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>,
	David Hildenbrand <david@kernel.org>
Subject: [PATCH v4 2/3] ksm: perform a range-walk in break_ksm
Date: Wed,  5 Nov 2025 15:49:11 -0300
Message-ID: <20251105184912.186329-3-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251105184912.186329-1-pedrodemargomes@gmail.com>
References: <20251105184912.186329-1-pedrodemargomes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4123A12000F
X-Stat-Signature: gmbs46wem6iwqxjhxghbifagr4nmdopb
X-Rspam-User: 
X-HE-Tag: 1762368713-110145
X-HE-Meta: U2FsdGVkX18qK6OMga7ehfQWXHXHILob/W8Ds0z6C+sU9iZOXbF7YElr8r8tRpo08YrUAavR0ceXWFw7U4J14PkFVSSVcnbxtF8z/NEmGkoOCGYqqd96G/9N0Oec0+rPIqOxM76LPvv6T0+yWYroeedxn/YC7REMzLQS/24hfrohHU83ELEi5wqk8StJHePJ3y/lgXx/MbGucEIkZqfNYPepelAVk391adc9KiOZR/aO0ZbpSFjgKWaRJI+oP1hwEjIlgzlWQcsQjh/hfEEOu3OzwuL37qT/iVW6n3xDA6av6mHVCvL4QHdCgQNbO1Sww4Ncw9HCGMZeGk63uW9dK7GzKMAZZ5JA2V64Ar7f7zPuBdflk6/k8kEgnry15zk+YgFJl+I9i/VDwPOb4h3+XFvZkPUg7TGiw1Lmg08PNe52jZYdtFZPh3BknNEle8y4DEUDeKFgvdkqH0EBOPIvqM7kb4VoLv58hxF40NLG8HW3v4bqUi1SXZyLponbsj800cZjbTfIMGAvOvbmryBrpQalM2zpV/gDu9BlO/LQNMtZ+7lpvEpG/tYDqmdYflxF0fYBfzTInGXrnHvXM065vhDEo9d8yqalF06XLjr8ir18UPe4aWYzf6m7+zczEL0CNjFJ3O8WLHWaYeCTmih07yWwjqPlLKr+g+i3QKWb3Z6x4xtkNUGiFC0I4w6+sJc1gIKP07nQY5ocRiUOb5gpGXK/ImhgCZXjWUHpzalkznWMIQ91L/3jY4yF0gLnEcK1mv8f6UwefNkNaL6ScO7ztd/v44fEe7QKYRiHo0hhjft+PJ5HzeIxj3KyNh5SPYe1/ecqC9/yGcpQKBSKiiWCoL0gS8uFrJit/ZofA/iVBLY6Dt0xerDQdMj/jeG/jhOizuOcAtzM0u1/1p5DB4EJWODAzgv23JLtB8NS8oEgJ/r/6T5+Y1O0WivlexWM1i4vb6TQ5tWQp8exlE6at3E
 JKFoVkMU
 1xh3XjRfeht7aeYgn88RHyp17SsPITHDc3t6W1BM4uFyZNBo12Xz0bGmXYM1BZeTiAVb2vXVRorYZRe94ZqiCiq/xYDusGgVzNUi5
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
significantly reduces runtime.

In a benchmark unmerging a 32 TiB sparse virtual address space where
only one page was populated, the runtime dropped from 9 minutes to less
then 5 seconds.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 mm/ksm.c | 83 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 43 insertions(+), 40 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 9f74baf01e46..43be57a6a3fd 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -607,35 +607,50 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
 	return atomic_read(&mm->mm_users) == 0;
 }
 
-static int break_ksm_pmd_entry(pmd_t *pmd, unsigned long addr, unsigned long next,
+static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long end,
 			struct mm_walk *walk)
 {
-	struct folio *folio = NULL;
+	unsigned long *found_addr = (unsigned long *) walk->private;
+	struct mm_struct *mm = walk->mm;
+	pte_t *start_ptep, *ptep;
 	spinlock_t *ptl;
-	pte_t *pte;
-	pte_t ptent;
-	int found;
+	int found = 0;
 
-	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
-	if (!pte)
+	if (ksm_test_exit(walk->mm))
 		return 0;
-	ptent = ptep_get(pte);
-	if (pte_present(ptent)) {
-		folio = vm_normal_folio(walk->vma, addr, ptent);
-	} else if (!pte_none(ptent)) {
-		swp_entry_t entry = pte_to_swp_entry(ptent);
+	if (signal_pending(current))
+		return -ERESTARTSYS;
 
-		/*
-		 * As KSM pages remain KSM pages until freed, no need to wait
-		 * here for migration to end.
-		 */
-		if (is_migration_entry(entry))
-			folio = pfn_swap_entry_folio(entry);
+	start_ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	if (!start_ptep)
+		return 0;
+
+	for (ptep = start_ptep; addr < end; ptep++, addr += PAGE_SIZE) {
+		pte_t pte = ptep_get(ptep);
+		struct folio *folio = NULL;
+
+		if (pte_present(pte)) {
+			folio = vm_normal_folio(walk->vma, addr, pte);
+		} else if (!pte_none(pte)) {
+			swp_entry_t entry = pte_to_swp_entry(pte);
+
+			/*
+			 * As KSM pages remain KSM pages until freed, no need to wait
+			 * here for migration to end.
+			 */
+			if (is_migration_entry(entry))
+				folio = pfn_swap_entry_folio(entry);
+		}
+		/* return 1 if the page is an normal ksm page or KSM-placed zero page */
+		found = (folio && folio_test_ksm(folio)) ||
+			(pte_present(pte) && is_ksm_zero_pte(pte));
+		if (found) {
+			*found_addr = addr;
+			goto out_unlock;
+		}
 	}
-	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
-	found = (folio && folio_test_ksm(folio)) ||
-		(pte_present(ptent) && is_ksm_zero_pte(ptent));
-	pte_unmap_unlock(pte, ptl);
+out_unlock:
+	pte_unmap_unlock(ptep, ptl);
 	return found;
 }
 
@@ -662,7 +677,8 @@ static const struct mm_walk_ops break_ksm_lock_vma_ops = {
  * of the process that owns 'vma'.  We also do not want to enforce
  * protection keys here anyway.
  */
-static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_vma)
+static int break_ksm(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long end, bool lock_vma)
 {
 	vm_fault_t ret = 0;
 	const struct mm_walk_ops *ops = lock_vma ?
@@ -672,11 +688,9 @@ static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_v
 		int ksm_page;
 
 		cond_resched();
-		ksm_page = walk_page_range_vma(vma, addr, addr + 1, ops, NULL);
-		if (WARN_ON_ONCE(ksm_page < 0))
+		ksm_page = walk_page_range_vma(vma, addr, end, ops, &addr);
+		if (ksm_page <= 0)
 			return ksm_page;
-		if (!ksm_page)
-			return 0;
 		ret = handle_mm_fault(vma, addr,
 				      FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
 				      NULL);
@@ -762,7 +776,7 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
 	if (vma)
-		break_ksm(vma, addr, false);
+		break_ksm(vma, addr, addr + PAGE_SIZE, false);
 	mmap_read_unlock(mm);
 }
 
@@ -1073,18 +1087,7 @@ static void remove_trailing_rmap_items(struct ksm_rmap_item **rmap_list)
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


