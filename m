Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FCC8C4453D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 16:48:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82C8C6B0092; Wed, 22 Jul 2026 12:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B6226B009B; Wed, 22 Jul 2026 12:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67D956B00A4; Wed, 22 Jul 2026 12:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 17BD86B0092
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:48:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 725FF1C02D4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:48:23 +0000 (UTC)
X-FDA: 85016995686.06.4F7F20B
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id B6A72100004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:48:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pi0bNlmR;
	spf=pass (imf05.hostedemail.com: domain of enjou1224z@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=enjou1224z@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784738901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMDi1tp5OH9zRicJpLyegIigyLh8iQ7jA3uMAaVEcDo=;
	b=xSBmI3Kb/suld5jVFmy9cC87bM30VFv4+AsF7OcdqwOsCwcx4E7emH5By9ay/tSf1Ivo25
	43oNhRBABcYHwDDh2Tv9+RCZTPwnPT5tvN8VnR7yJ47s6yng1cGiXoG1GrPf4VvA6XcSxI
	DYh7tDT6D6QSq6VfBLwmPjFyYR/s67o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784738901;
	b=seHU56OcLzUO+66gAvYcUx9Dqeerb9hYgch35Q+hF5i2AorB3+YOIdRXxEky+Q5mj+bXVC
	SfrPYMQTjG4J47tMkrvIInSDKWxThgbsRJhrUTosSxG2Eh7pGoW0gURb1q9IUPeW+XJGIR
	KQCOzn4KCWucXdZ1sGYHyWWoFAYRnSM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pi0bNlmR;
	spf=pass (imf05.hostedemail.com: domain of enjou1224z@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=enjou1224z@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-381b831d535so11037447a91.0
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784738901; x=1785343701; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YMDi1tp5OH9zRicJpLyegIigyLh8iQ7jA3uMAaVEcDo=;
        b=pi0bNlmRElDaBR8Zx1QxjEsQSWBWC749fb8eo65HkglTGAX97gNeCnJReCyD+egx+l
         pBOTHbqU46AIhUv80wOvDbXP2CCQMZc4nN2qZ0miBsxroAEICS8lHWzHsUxXnIjhPajF
         VfqfqTvFC9yNqVYZKoZoOUxBPRmKsWxKVYfvuZG+Yb0EkE4j2dzhX3Bnqa8ZTQcWO+y0
         6oELdXgpfjdBjoOPem+wgY+39EFxH/HbYbqr4jtEpEokbMdvo+jbmoC9S6rgY/p5IoLL
         cs6P8AXUZNQEBtkPem/6o21AYk78m6Kc30VXjPeySn+pdp8RV1QzCMjnLKXWJ+2i4lEV
         k4EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784738901; x=1785343701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YMDi1tp5OH9zRicJpLyegIigyLh8iQ7jA3uMAaVEcDo=;
        b=KUl4Plk4EmV5BR5KqUvSap2qi7er9IPWueFk/RCMXGap+gldrQDtIY28Ed10/5lTWz
         b9PuUba+MFcXL6nuUCL6OqDmJoK/wA0eOCkWfP2K0gNYf9r1WwtWoLA6ZpBGtOaCG8U9
         v9qqx7olH2Ge4bFrU+ayHnJs3dt9fo5MFmEa58P/dwNicZu+P+uHKtB+xa3T2msa7J6g
         Jgstp4aeXUJL1IgUGjLRzrMMTDtL35d5uV7AoFtQzUI/e0bz2B9e3uS4qFDznkv/KZXI
         qEMkrxUugCfpqT4E/Hn9SFoEknjOdRxKNNWgQnwS6/lEsf33MAPpaMQFqWoBn5Zc7Uih
         FTqg==
X-Gm-Message-State: AOJu0YzY9+k4rJZ7nkU8vhYB9SU+oFroG4oNZH5w6O1RAXr5bEcMrwd7
	7TvLobnX445sguJMQEeGF5OfmjXMVxX2iZ3fVXnIbVkPi7nfHT5bga7nSNWE3kGrtKM=
X-Gm-Gg: AR+sD11rwqw30uE+SFcD//nnm9igxm1mI5q27HCdCK1U6D2v5KPqakxOajj8QAv6KGN
	ZYzGpQNb1CieDrTB3EsfYZxmJMaMTzy5uv1l6+7QUnBdFQ+hjpcdLPyqPUf0HyY5cOoBRM7khnQ
	Pc8sNHODp20ez3/xV1hH9+fL8znd/zBCn9qe/GBcfgxGn9EP/MqjIVKLSSFSAbJw/U3mz9RpLGC
	tf/i5PM4YUm81uK30wfoqyPG/mS1A69lVtBc1bfAs6hih59utg1fty0NgsKv5p4yB0lHnoE0bN6
	r5LNmobSPcMWXxUy/xl+/8dLdL1TSkCkP+VEWv2VeQlJ/+3bUoATtrMaHBdo05U5n4QfXN+cf9y
	fUPKy8YnBIUdHYAt8nBN9Hw5iZCwdllEJJfbHlMvE5E10lvKh7+S0xhAIvNsrsbRaF1RpmkTv9M
	Q/8E3wj/KfHbUhAr5vsBZsWa1ZWSGl1m0=
X-Received: by 2002:a17:90a:ec8d:b0:387:e0db:3faf with SMTP id 98e67ed59e1d1-38e4b5f2031mr24020414a91.40.1784738900611;
        Wed, 22 Jul 2026 09:48:20 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([123.114.53.210])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e9218a25esm3547452a91.15.2026.07.22.09.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 09:48:20 -0700 (PDT)
From: Ren Wei <enjou1224z@gmail.com>
To: linux-mm@kvack.org
Cc: pasha.tatashin@soleen.com,
	akpm@linux-foundation.org,
	vega@nebusec.ai,
	zhilinz@nebusec.ai,
	enjou1224z@gmail.com
Subject: [PATCH v3 1/1] mm/page_table_check: skip special zero mappings
Date: Thu, 23 Jul 2026 00:48:13 +0800
Message-ID: <e94478e4fb7912fb7e8ebebed5ce85d00dc9a69d.1784717203.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1784717203.git.zhilinz@nebusec.ai>
References: <cover.1784717203.git.zhilinz@nebusec.ai>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B6A72100004
X-Stat-Signature: 839453geraou7a9pd4wcpyzgsh9kanrm
X-HE-Tag: 1784738901-640319
X-HE-Meta: U2FsdGVkX1/ZoIOeS5GK4QFvYXUHF3Rh7vi/utlxVxVdcQbK2mAcIcW2x2u7eGhZ/75k5arvntNAmvRWRmWxvI8B2nMJNLWh5NruvPsPtCvfhiUi1upPy0HxT4XuM5iSmb3Q7UKfZDdJOYOQjdPUSjYHHqN0wdYnjFxHJ5oYhpfWFuUIhdy4Yrcg15Y4cHnEdhAARpxiW5rl2Qp3eoNmml6PpQcMnbU/cjBY8bBdNtvyIvdXBVVqDwlmgR6fet+XLRiCszpy7zqXWoQ3Un8cDwFEjoyoDvcPJTfQM9i1FBzXE+vPx0BQcMedBiWSC/u8n6CTAZ5zrYbi6ymXZsEULtLHzkMSIQ7zKwJKhG6aHjG71h7HCaS0vf/xCuKYg5acN1NCcZMmyHE4Ue1Z4rn7yfE+Eq1e+G4NMkyXOzjvNBGwLrS+WbWnnTVuupX3Qr98k+ZrN7Fxl8ZhT14r+MCzKO9WcjvtNZQa2Inl6FUIaxB4P6/cQAgmMKWbTAaBm+C6Uq8a0snqGNZ0FAkgeRoATZF/tpPQ2jUM5ASL+akdPhUqueeSnwT83SL7IoVc+ZA3qgeBMzGa2el6IqyMl93uUWqFLuACibVw+0EaZpe9VBdjR6MQpYlQezmxbu+liSnHea2eDOBe7Q78HWfl0kBcOzTYqIRaI09F28ruAzCmGJYQgVPEjUlCndhASsJwzwFFijwF+u1Ty5BrcCeuPrwRuwy4BcU0sqrN5+AaF2wPe4kEPQagrhscTIA73TYBTvU5FovoPydx2a41SqY4mYwy+ONstmgT+3nYyevkiiV4ZWEybA305eXFxt/o/gB9x8AkwtGHS6GmkPDbpYoEN1nLdzQZd6YS2JxHyQgbot+up4nVulx6PuyXhim6BQnTVgyvTK3O2pKE+Ynyyw9pFnoXZsjBsTvV0QXtGo1gZ4j/0pUko1HeHIAoC2b2qFza/zVHLii6+BaezdwSxjwoRC3
 0A2hXGv/
 BEBJETz4LY1Pt0CKCZcOseEv9gB6se3X0x2NG4xTTxNCYAjOToNWwa0vqfxhnJi7C5TMaM32S5PeE5/o6eQWclueR6mLU4q/lWPoNfSxwhNliS8EMUokE/PkI63a/JrFvIKM8BZ5HbMds7+YqBHqywlNcL98/U1CecfQeSf0pLWsNqVX0viB5lW7C3+xJ5+9BwWCcq7CEQQ//sW6j5EFhW6YbKyvXDo6ZhMKDdafo6DXOZRhfXaTaid5hqjetFhyvPXTasOj5KjMi3pHBJNEF4W6DD7TyXz6DZOCxia1ln9n3j4+PpctIiZ0CdTZDVD4pK2wq7c+OXjMdrQAtzttwMQcYChwhi62BcplUfsFaJnkWf+JHKU/YrO0Vn4Q8F4w/loRX+0Im8D9/zORNCWkNyU4jT2CjSEXyK+42c0cR0b06GQDa6DpFOXxO8EBKDLkcloGy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhiling Zou <zhilinz@nebusec.ai>

page_table_check_set() and page_table_check_clear() account mappings
based on PageAnon(). Shared zero-page PTEs and huge zero PMDs are
special mappings, but page_table_check can still account them as
file-backed pages.

An unprivileged process can populate enough zero mappings to overflow
file_map_count and hit the existing BUG_ON(). The PTE path can do this
with the shared zero page, and the PMD path can do the same with huge
zero mappings.

Skip special zero mappings in the user page-table accounting paths.
Keep the PTE-side pte_special() check, and identify huge zero PMDs from
the mapped folio instead of pmd_special(). That covers architectures
where pmd_special() is a no-op without adding huge_zero_pfn checks to
the generic counter helpers.

Fixes: df4e817b7108 ("mm: page table check")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
---
changes in v3:
- Skip shared zero-page PTEs via pte_special().
- Detect huge zero PMDs from the mapped folio instead of pmd_special().
- Cover architectures where pmd_special() is a no-op.
- v2 Link: https://lore.kernel.org/all/1f8848512d2e3ded944f8d595c29faee8fdaeab0.1784645969.git.roxy520tt@gmail.com/

changes in v2:
- Handle zero and huge zero pages as special cases instead of widening
  page_table_check counters.
- Keep page_ext storage and ordinary page map-count checks unchanged.
- v1 Link: https://lore.kernel.org/all/b4414b588418c52a99d959d35a40e064ae8b6e72.1784337674.git.roxy520tt@gmail.com/
 mm/page_table_check.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 53a8997ec043..2403f5a11410 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -151,18 +151,29 @@ void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
 	if (&init_mm == mm)
 		return;
 
-	if (pte_user_accessible_page(mm, addr, pte))
+	if (pte_user_accessible_page(mm, addr, pte) && !pte_special(pte))
 		page_table_check_clear(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT);
 }
 EXPORT_SYMBOL(__page_table_check_pte_clear);
 
+static inline bool page_table_check_huge_zero_pmd(pmd_t pmd)
+{
+	unsigned long pfn = pmd_pfn(pmd);
+
+	if (!pfn_valid(pfn))
+		return false;
+
+	return is_huge_zero_folio(page_folio(pfn_to_page(pfn)));
+}
+
 void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
 				  pmd_t pmd)
 {
 	if (&init_mm == mm)
 		return;
 
-	if (pmd_user_accessible_page(mm, addr, pmd))
+	if (pmd_user_accessible_page(mm, addr, pmd) &&
+	    !page_table_check_huge_zero_pmd(pmd))
 		page_table_check_clear(pmd_pfn(pmd), PMD_SIZE >> PAGE_SHIFT);
 }
 EXPORT_SYMBOL(__page_table_check_pmd_clear);
@@ -208,7 +219,7 @@ void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
 
 	for (i = 0; i < nr; i++)
 		__page_table_check_pte_clear(mm, addr + PAGE_SIZE * i, ptep_get(ptep + i));
-	if (pte_user_accessible_page(mm, addr, pte))
+	if (pte_user_accessible_page(mm, addr, pte) && !pte_special(pte))
 		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
 }
 EXPORT_SYMBOL(__page_table_check_ptes_set);
@@ -238,7 +249,8 @@ void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
 
 	for (i = 0; i < nr; i++)
 		__page_table_check_pmd_clear(mm, addr + PMD_SIZE * i, *(pmdp + i));
-	if (pmd_user_accessible_page(mm, addr, pmd))
+	if (pmd_user_accessible_page(mm, addr, pmd) &&
+	    !page_table_check_huge_zero_pmd(pmd))
 		page_table_check_set(pmd_pfn(pmd), stride * nr, pmd_write(pmd));
 }
 EXPORT_SYMBOL(__page_table_check_pmds_set);
-- 
2.43.0

