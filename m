Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1840CCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCA568E0035; Wed,  8 Oct 2025 21:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84478E0002; Wed,  8 Oct 2025 21:58:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59768E0035; Wed,  8 Oct 2025 21:58:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91DBC8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:58:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 35117460CF
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:50 +0000 (UTC)
X-FDA: 83976917220.25.705D0FB
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf02.hostedemail.com (Postfix) with ESMTP id 583228000A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=dEDM7Iqj;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf02.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lp2v9w2qTrkESoVDLPmv+GpD3nzqMphlK45S5OJoAnI=;
	b=Nr/o7DnzeHECc+B8ASMMAkOBrIQt+bWvBz4qFl4+wKn0FH0xISuAg3p1Iwfew+iuaAKcIO
	XsD3o3AX4xW3Gg2kaMsEEdKGl6kqAZiVAr9zMlwSLaMMugrxOd7QE4fXkzoJjL2KOjxPb9
	YrZgNlmnTIQsGwRZZ9KZT1qptWSaQRg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975128; a=rsa-sha256;
	cv=none;
	b=QnLYqkhapjg4VDAoFcJOhwlh9a+BcQQBN/244auMRdwmTzz0IgkIydLD0JZlz8wIUNgaku
	oGVCyFRrP3qZ9oRp/JGlK3K1nY489v4lN1As6Yh2bo2VWDzzUnfXk9s5Re7CAC8nYha0W+
	hv0HxVr0jzo6x7Ji/JmiCI4CUQLTwss=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=dEDM7Iqj;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf02.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b62fcddfa21so267438a12.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975127; x=1760579927; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lp2v9w2qTrkESoVDLPmv+GpD3nzqMphlK45S5OJoAnI=;
        b=dEDM7IqjggSI1ZGuzUjQwIlNTonevsTQ5FqlhvqINYwUwJQKo3USieHbWIf0m0+QUI
         TOQ2A5p+jmDHtwPsIq/7ldAMemtgpe/FvnZ8WXrsQy3o98mrXi9AJzRLmnCA0wnhbJN7
         IQtJ+auE/cNfezcRP8xM8iUzGVtl24JTqHWKkLEFC3puRepn/adAUhBJHKfg2TPXBbpR
         cuG8RpaywchyFZ1bDJRS6X/szxMsN/OrzNv/WPbAm0sUxPs+ozbjlhgyRxuGysWbcG1a
         qYKVJIsPSo1K1EQoKcIfYuqfpYX6YwHuEVSRI4E0AkPaGDnjwTxk6qTxFP/x0qnKxrwy
         +G9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975127; x=1760579927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lp2v9w2qTrkESoVDLPmv+GpD3nzqMphlK45S5OJoAnI=;
        b=lTxFs+uC8IPswGMPNCI4TOHo0VVPGz/S9SKyXjzh6ib1KKbvWDeA0exqU2BrYU8HLr
         buV7oN4H8Ixrw/FRwi3yRWRh49N99taKPtGjUUdE+bUs4HDE7yXgUd6gndF+pYIDjy9q
         QonhbAVSQ3guraPm8xvsNeE9P56hjlbeOwKcOMa80qw0h7RS5u9StsPAb2C+kN++apC9
         QW/uVOdDiZvyVU07Lp3Ffh8zgeZW9UUNBL6KJQC+EESortnnfWu+1QfQ4zNY0BG5lnI0
         GUrY3tAXJhBTzmg98rmj4MvvIyAWDcKgOKpfXYnekMbYqjW6ELS9ieLYVJn0N57Pv4py
         DNiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcJo/g5FYO1ARdNQjsp+3f38h5N+QtSLBJjmT9omLYCaX21B+zkiT+K2S40HxKOAoTr2BHgOf/pA==@kvack.org
X-Gm-Message-State: AOJu0YyIsPpmdXxR9wMkZ2XLLfmNlyRa8gZbp93kVZrrPhedlkjD+B56
	gzuMXdV03ZB4/SD2xi77sgIDWlHnAIWWpIGpDOzdbVjX15x1fhy5luR9Y2JzCFhXH7I=
X-Gm-Gg: ASbGncv4KtGBMSSd3N0whMngEzY1nQ6QJ42crQehzeLBbPlB58JUkn9tk6mTA8IHm26
	BIM0bfWnbCi/VhwVEBp09vODVhJt78zIzvoJZ4lXMDztIiBHrhJipQESydj5az1jk0tD2RUNMkA
	GcTTTGRYKDkFSOERUB3FTa9sjiagYqRI9VEliImTc/5TuhFuhFitRP1Xq/UPMSZKMYiIdnd13lx
	fMc5GOHR87RpoZ7X9lhRl2c81b0OZn64yoxOuFps+LaTNJ8XVvFJpPl2NXWX8LefCLOc2FVC2o8
	xt5HDtWVlxwG6xSblz+yUwSskYQXIIe7Tp/9yhW3E1tnDsvcSA3B/gV66msV1bQ5yNw3zbWGFHE
	MoWkzvTlRJD+wtf2vD6uD/dLsclLK/zwQy0w0mPoydiKJ8vcuo3+/AApixnzw/JAZajRyFwASi9
	XGIxI=
X-Google-Smtp-Source: AGHT+IE+agqXEhLEONLyA5d2qyFrvAw1S+1pygAwMmWTwUwpcKU01+ZnN2Cp743AX1wJ7euQQmxe/A==
X-Received: by 2002:a17:903:2292:b0:24c:bc02:788b with SMTP id d9443c01a7336-290272e3debmr85255285ad.44.1759975127215;
        Wed, 08 Oct 2025 18:58:47 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:58:46 -0700 (PDT)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Conor Dooley <conor@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v2 05/18] mm: Allow page table accessors to be non-idempotent
Date: Wed,  8 Oct 2025 18:57:41 -0700
Message-ID: <20251009015839.3460231-6-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 583228000A
X-Rspamd-Server: rspam02
X-Stat-Signature: xfequq1m8ck3qfne8k8wgup6j3drjafu
X-HE-Tag: 1759975128-733794
X-HE-Meta: U2FsdGVkX19es/IcFxB6e6HYIfgmGBmzdoUPabR2utNd/eGsOjAsVN0MYnRJGu1qJumtEgmYWXfPGUO0QFuxanitOA3ulCfTh/cH6LI5AhvYxDxwEFHiTbi7ogt15GyfYtwf5k/b9EFTGBvrzIaT68PKS9de99Ju0P/rEW8omM4PP9QMEPGZnXSJkBXZ+FA6ILlSNLsXycIf988z3y5KtDNeIFMF2axtyJdI2Ky9MWKw/PXmbQqabPiwRUn284uLys3NDihPI6UYpeA3nH3yO4Nq2gvqrjgxSBukKgfHSb1K1FVCtuBfuhBTJ1/EaAPcftwMPNAAp6bVUc/Xq5Jtj7b+xiOp7mu7PuVczOdxqvAxrbmr9rPbBrzkegZOs1Xc5hzAp3FVuw1mBgCiARbmzIQiL1FpEiK0iPEmAFiK57MT3YEPzld8DOPMqCHomPa4bLEpB/sGP1sb+26R93juXWmogJoH5iXGb+5wOx3TwMSP8TWR88GcJdeFHt4F0w/K7fV2PzGOECv6MNo7uMpennF7PmPw07mHesho+YrPyNKogtfWIhUzxssD2KghpCLpZXZVw3wNghJM/mO0+xmaCYhJkjo9xpIyYRec+VhjmE+OlGmooUcqV3Hvcz/tqITKcntHFFbrKin/KosKZpqm0xLpwVh4+NQnJZTTJTiMECEiPlb5NyHWr/vKFPq55hf6T6lf+ZejZPwgSUnbUtHhNOsEb+zbGTdzL6e42AWbBpCeTVQ8n1jeUHw1FQ4ChInuwoKEL+a1oZI5cHbKFgDHj2UbcM7dx9ag2wpkuRWIpWwl/oReXw9z/UK0+qVP0uwu+JhmDN7XotCKDaiJqyZw1iMFiIzM89/LBlHCKZT4CZnPf9NvX8b7cD42lfyS/Jqw5zZj8o3E0mfttCNwOtpQhaW3vhnaUz+33V41TSZ/G0Cohz+29l//QjQwbLdCG7VB1M8NHxuyHbJd7Yg0Lt2
 hXXW/wVt
 Coex9BX+hGg+x4CER4jfHyT/4j5644cIhMJEhYWjTOhEBT/Z/5Qo0Mt5phaSq05d/9KbsdevQ0iiC3oukuMGsIxnLeQLJ6CjdpjxMAJO/lV4RJSwHpotN0mqDr809Z/kgAYB1q4CbEGjmeF+NS61O7rU9VTORdoRZxfoNRV8iRC4etY0HStuzDLiiHFys9Ui418UgV+XuAcv1am0moJP30V2FjLCH+FVoH80nJ/HPAwQ+OBAcWYHK1Xi0+Zebg77rNWx+U8Sc4RkQI6Hvtr+x98+mJzeXDiR3fq+/50TiQz1fNlvi7B7DRlYJi/OVKvBzGW84WDJXNDuo4loYYgm0HZFUSlNyVxAb5m0adNA3GS4j69rZ8wU3x4yVKGmomR+HAMfKQfEwRkMk9D3kW3PtD7R1/w7mbyl8W4ManHowBiqjTScoqYERmx6UmA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, some functions such as pte_offset_map() are passed both
pointers to hardware page tables, and pointers to previously-read PMD
entries on the stack. To ensure correctness in the first case, these
functions must use the page table accessor function (pmdp_get()) to
dereference the supplied pointer. However, this means pmdp_get() is
called twice in the second case. This double call must be avoided if
pmdp_get() applies some non-idempotent transformation to the value.

Avoid the double transformation by calling set_pmd() on the stack
variables where necessary to keep set_pmd()/pmdp_get() calls balanced.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v2:
 - New patch for v2

 kernel/events/core.c  | 2 ++
 mm/gup.c              | 3 +++
 mm/khugepaged.c       | 6 ++++--
 mm/page_table_check.c | 3 +++
 mm/pgtable-generic.c  | 2 ++
 5 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 952ba4e3d8815..d75be3d9e0405 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8142,6 +8142,8 @@ static u64 perf_get_pgtable_size(struct mm_struct *mm, unsigned long addr)
 	if (pmd_leaf(pmd))
 		return pmd_leaf_size(pmd);
 
+	/* transform pmd as if &pmd pointed to a hardware page table */
+	set_pmd(&pmd, pmd);
 	ptep = pte_offset_map(&pmd, addr);
 	if (!ptep)
 		goto again;
diff --git a/mm/gup.c b/mm/gup.c
index f5676a3aa525d..34d1b59bd59c1 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2865,7 +2865,10 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
 	int ret = 0;
 	pte_t *ptep, *ptem;
 
+	/* transform pmd as if &pmd pointed to a hardware page table */
+	set_pmd(&pmd, pmd);
 	ptem = ptep = pte_offset_map(&pmd, addr);
+	pmd = pmdp_get(&pmd);
 	if (!ptep)
 		return 0;
 	do {
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index acc620158696e..d8c22ef8406bd 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1731,7 +1731,7 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		struct mmu_notifier_range range;
 		struct mm_struct *mm;
 		unsigned long addr;
-		pmd_t *pmd, pgt_pmd;
+		pmd_t *pmd, pgt_pmd, pmdval;
 		spinlock_t *pml;
 		spinlock_t *ptl;
 		bool success = false;
@@ -1784,7 +1784,9 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		 */
 		if (check_pmd_state(pmd) != SCAN_SUCCEED)
 			goto drop_pml;
-		ptl = pte_lockptr(mm, pmd);
+		/* pte_lockptr() needs a value, not a pointer to a page table */
+		pmdval = pmdp_get(pmd);
+		ptl = pte_lockptr(mm, &pmdval);
 		if (ptl != pml)
 			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
 
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 31f4c39d20ef9..77d6688db0de9 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -260,7 +260,10 @@ void __page_table_check_pte_clear_range(struct mm_struct *mm,
 		return;
 
 	if (!pmd_bad(pmd) && !pmd_leaf(pmd)) {
+		/* transform pmd as if &pmd pointed to a hardware page table */
+		set_pmd(&pmd, pmd);
 		pte_t *ptep = pte_offset_map(&pmd, addr);
+		pmd = pmdp_get(&pmd);
 		unsigned long i;
 
 		if (WARN_ON(!ptep))
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index 63a573306bfa2..6602deb002f10 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -299,6 +299,8 @@ pte_t *___pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
 		pmd_clear_bad(pmd);
 		goto nomap;
 	}
+	/* transform pmdval as if &pmdval pointed to a hardware page table */
+	set_pmd(&pmdval, pmdval);
 	return __pte_map(&pmdval, addr);
 nomap:
 	rcu_read_unlock();
-- 
2.47.2


