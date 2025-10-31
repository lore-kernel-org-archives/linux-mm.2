Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85AABCCFA02
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 17:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9FC98E012F; Fri, 31 Oct 2025 13:48:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76F78E0121; Fri, 31 Oct 2025 13:48:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3FC8E012F; Fri, 31 Oct 2025 13:48:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BAAEF8E0121
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 13:48:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7CC0412B0A1
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:48:51 +0000 (UTC)
X-FDA: 84059144862.08.018FED0
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id 86F2B4000C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:48:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RYMboP5J;
	spf=pass (imf01.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761932929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=suj6Dur0K6qgOtTWDhgGJ8k45c2o5OzoxZ5K0IrFENE=;
	b=nZQ+SjGmdOCIGfu0LT9UIldJ6Q0JjZpauon5aGVHxfQCD4kqLDnW04lPTgYXfq5OhAoC/n
	rPRA0iiaPoEYW1Z3NqyYM20slX4+xgfrIYWqLqgyJAk8Bwh+k7wcTyCTGnDQL3wGs1bj/0
	RO9dnIjyWb17qYzYzOUtNsLJEbc/kkc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RYMboP5J;
	spf=pass (imf01.hostedemail.com: domain of pedrodemargomes@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=pedrodemargomes@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761932929; a=rsa-sha256;
	cv=none;
	b=XbE9Gw3jXbp+SeJYLA11DayvfI2+xVRTIdmB0hzK+kfSAnXgukP9Ck+FNtJxi1onzXk/pI
	/ar3q4Ow+Yw6pPQ5yXsJUnX1QjiKZPvIvAzE4OcU0H8Wk8EpauRRNsSpcSMMTnlVZ3BLb6
	gNx3WsTFkopIHZuanJuIPZBTU6FLwvQ=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-295247a814bso14412705ad.0
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761932928; x=1762537728; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=suj6Dur0K6qgOtTWDhgGJ8k45c2o5OzoxZ5K0IrFENE=;
        b=RYMboP5JYA5b9et9yi86i+UO8w2PlyWx29rPG8AixRnoCcl18Jvwf2fWrj3POgrq9E
         aGDxN+5XOxbMITLfqFXom2KzkSyMGA/LP7QkYvuywNCVndvL4EYz47sp4lipMjPAQ2J1
         0XdJaIJgexOJpbCsbih5dO1YDJzsTNWVCABukh+Z0QBUlcl6OppivqQhMoz18/UFZomS
         TJCH+tC1Q7OYd+LpHGfMfk3TO7AqodoQTYooRJGbs5xu739URrVK+PztjuqDBj14KmwG
         D5zxicqIANZ/BZZ3krQQMpMGhvftOUhEWBp3MCa10CGg/3Wnxp6QmsZwf2STkl9DntJR
         oavQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761932928; x=1762537728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=suj6Dur0K6qgOtTWDhgGJ8k45c2o5OzoxZ5K0IrFENE=;
        b=GMHFH8j0l6U6hpYbn+V5vaWgTpzArK+p88TzBE99iFrJqtc61O0PExf8lZllqkZ6bM
         KpXU+Tn5oD5m5CSXSng1ypx4/u6KYd34fTRQSOiKi5Mk+SkXXdVhvcgpNTVfL65oHuJB
         tGCjAwW49APdJbD8xDb52gCs9tL+1H/kAoUB0fVY92CNz7xv3UlRwmD+7d8GOIpDab1Z
         +VYrflRZkrgKp583SPsiPJO1J4P+0uD0LPXJ1poWNsicLlHQ57puoUq1BWTz2zyJTAF2
         V9OqFvuW3o7EgtaEqFmz+4atDUeMBU3dQi+njdzFL10VrRYFAgnoI6Ip7f+ZtregBfEE
         RLLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVy7jLwT1cjopCIqzvofb/V8/KZma8dfz2mb1ioexfIr9XOst4dHTifetLjft3zruEhrQf9UiYhtA==@kvack.org
X-Gm-Message-State: AOJu0Yw4tlEHPyyXsKn+fyJkvA2bEoe+cEbibqzvHF1Ic7FA06jeIqcN
	OaH1bAVTY4hwYiOylvzubie+KkaPA7YdrrVak62bbsU1Msq0Eq14snQwFk/+mFS0ADA=
X-Gm-Gg: ASbGncvnUoqp1m2/tmbIRpCtIn/B4npvFEbgAZbIvGNlVCk7JRKGCS9YWLdkfSIT043
	OJVDn/10i3mc4Usex1hyIunbfzXqPYGg1iiuAGStKc8Sz/ImwQxrwbuFmcqYYhLDWRYYMkiiriS
	JClauQi8m57srT+KO/6fggrOx/SkRywhq+jlZ20BsRfx0k84WR9OzgUZUi4EXZgdZ50AaDNBA8c
	P322Ok76x7PQ1vH22tIqX1zNZ/o3iCA5gaT60Yoyc7nsODdWfmeQIjnWUkClCZxx6GZEJYY1rkP
	/8+Fx3YKM5eTRDMS4OLvCgDiQIFNmd+y5EXTJn+pKSleGSzf6G9qeZYAj53TXKbmBOiSqE5s88a
	P6QiCSQVbIHJ9Nm0v04Z6NARVixYd+HbxuMuLGhdrx6zHDHKb9WkJIcvdk0xBd3Sijktl5Bk8MD
	XSYx4gZwhoBHN/eWK58OsUJcEX
X-Google-Smtp-Source: AGHT+IEJ5Souq5YXwjodyLW6kaFFMxjoA2rgMiNGNGLghFOxvhist2DSCElTCEeTgxQTMrfnKIBxkg==
X-Received: by 2002:a17:903:32cd:b0:295:30d4:23c2 with SMTP id d9443c01a7336-29530d4476amr27224805ad.50.1761932928285;
        Fri, 31 Oct 2025 10:48:48 -0700 (PDT)
Received: from weg-ThinkPad-P16v-Gen-2.. ([177.73.136.69])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29526871693sm30113185ad.20.2025.10.31.10.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 10:48:48 -0700 (PDT)
From: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
To: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
Subject: [PATCH v2 2/3] ksm: perform a range-walk in break_ksm
Date: Fri, 31 Oct 2025 14:46:24 -0300
Message-ID: <20251031174625.127417-3-pedrodemargomes@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251031174625.127417-1-pedrodemargomes@gmail.com>
References: <20251031174625.127417-1-pedrodemargomes@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 86F2B4000C
X-Stat-Signature: ae4bipfz41pni1kj8uof7mb8s1m9sr5e
X-Rspam-User: 
X-HE-Tag: 1761932929-60211
X-HE-Meta: U2FsdGVkX1/bLag0z+7j0mcTmfsrYEQZrs3lBAAls/UVouAcEBINHbmroJ0lG4pJmSnVDHx4w+xHSLMLUvXJXE+AzUzwORWRK2LbJ7e7cQDMzuB2Wagcr6aK3aBCvAdEmlwBTiW+zOdInKMQSumNsFnRI4/AZyspjhvgpfucHAg2T/iq1u7u24wLgYu7H7juiU7tiqahajz7pIIxE36LlU0o7s26Th8xSxANDFp+FjGMqFTQSbwjAj4Um8X5hXr2QHv5HoYw8uh+VYeVnPSQ1Gdm1e6aOtZ+ADHmRDKGEHq2NNVV3Lyv8BodE7o5BEDg61IUFUBYNs+hKhZOFYSRuls9ltZ+r76rPATWL9Ek6Rmzit+1Vv6p9oj2TbvAIDk4MoWVjhfMZIi+BZ9ri++ZTwTmEqEHsJgM9AhXXsY0uJhYRmCcI5oqR0Uo1AkTbQC3pXxd6TSuxSl3/ICTArvqaWFN5pDpLDl4bBil71mMBxtOKihkPFEzNOwfocRouY5vuIxdK+tDejwRJgZIxqnB2RQFB5QUw/RcJNcCuuEI6VHCpOSaHqZYW7lvoYyvkhFvMj/7Cjz2XfdbWIFwC1cxOKpppjCA1C+1QzyHVzq26iAz/SXcEyjhJpkIBwjICaxz1kX3F7VO4kF66kqe7GF1HueisBF4ncamTYLC9JEMG/xC67IG0GdbJlwqrZeCRPNibDQ8nzTAO65h6yH4+mQ2WQdVSmGxuVB+cMQAWZVG5m327y2SRlx7P2yfCDuYLl49M9vz44mT1N3GazhU+LSFcTCSoRf4nF++A2uZlXVjYtHXYZxbfmdz7Tne9nwMAYCBJW0/Bl6cqrc2g4QMyk6apP+4rcKzvzdzHEG0dFOlu71y/mkTAx4DG1ZS/twuTWUOZtVieJGGS6kGH0SSebLM4UklkkMLiXtN7yb1csolUYQTXrb9QTRKQhP1c+SYs85UkZauOHKN3lDL9DQfCym
 YfeFQoLE
 kqWAh/wwuNSMi99fTqQtcnSpD4JF5di8S3GMNIyuEHCNbn8b0jIyxjVgXyCKezukm6rR/BTNM44ur0Fh6hifZgi7IE0Bu6ts+hek/K1p/q2iCAspADQ58IRSsQjnv3M0e+wzuk3FkIa2S4Dt8fA91Wp4WfGSnD4yhaXmWayV1OI0gPXTfrZ0s7tqtCuGMrQgTpxhtXUBmvVeQmgT4McjhjEXSSbmNieLEuS1xeHAvwMV0G/40ClbSvVA2k5GArg9bM8pkvOxdz4kAfLjc+eb/O6MxJ4ZAnfLGknEKtDkn8GTf02pxEGa3sROlMp4lnZr4xg/TU9nTFd+JyNxBANl/zun93BGr4ucBK5qEUYeBVqF5O8xFZoftza3xZfrUpm6zCLNL7Yr0KKkMjqCMcNbKS7UdzLAo/SdQ33NQ21svy4vovbwD2jbqdVFA61XwtuE4QTbpk2UnuaP9e5Mf/VjKFzyrHphTuc60QOTGx0S+moXGW3Y=
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

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pedro Demarchi Gomes <pedrodemargomes@gmail.com>
---
 mm/ksm.c | 88 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 48 insertions(+), 40 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 922d2936e206..64d66699133d 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -607,35 +607,55 @@ static inline bool ksm_test_exit(struct mm_struct *mm)
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
-	struct folio *folio = NULL;
+	unsigned long *found_addr = (unsigned long *) walk->private;
+	struct mm_struct *mm = walk->mm;
+	pte_t *start_ptep, *ptep;
 	spinlock_t *ptl;
-	pte_t *pte;
-	pte_t ptent;
-	int ret;
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
 
-		/*
-		 * As KSM pages remain KSM pages until freed, no need to wait
-		 * here for migration to end.
-		 */
-		if (is_migration_entry(entry))
-			folio = pfn_swap_entry_folio(entry);
+	if (signal_pending(current))
+		return -ERESTARTSYS;
+
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
+		found = (folio && folio_test_ksm(folio)) || is_ksm_zero_pte(pte);
+		if (found) {
+			*found_addr = addr;
+			goto out_unlock;
+		}
 	}
-	/* return 1 if the page is an normal ksm page or KSM-placed zero page */
-	ret = (folio && folio_test_ksm(folio)) || is_ksm_zero_pte(ptent);
-	pte_unmap_unlock(pte, ptl);
-	return ret;
+out_unlock:
+	pte_unmap_unlock(ptep, ptl);
+	return found;
 }
 
 static const struct mm_walk_ops break_ksm_ops = {
@@ -661,7 +681,8 @@ static const struct mm_walk_ops break_ksm_lock_vma_ops = {
  * of the process that owns 'vma'.  We also do not want to enforce
  * protection keys here anyway.
  */
-static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_vma)
+static int break_ksm(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long end, bool lock_vma)
 {
 	vm_fault_t ret = 0;
 	const struct mm_walk_ops *ops = lock_vma ?
@@ -671,11 +692,9 @@ static int break_ksm(struct vm_area_struct *vma, unsigned long addr, bool lock_v
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
@@ -761,7 +780,7 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
 	if (vma)
-		break_ksm(vma, addr, false);
+		break_ksm(vma, addr, addr + PAGE_SIZE, false);
 	mmap_read_unlock(mm);
 }
 
@@ -1072,18 +1091,7 @@ static void remove_trailing_rmap_items(struct ksm_rmap_item **rmap_list)
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


