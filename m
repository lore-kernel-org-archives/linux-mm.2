Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02D26CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 03:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55E298E0014; Tue,  7 Oct 2025 23:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 535F88E0002; Tue,  7 Oct 2025 23:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C3D8E0014; Tue,  7 Oct 2025 23:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 315BD8E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:29:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CBBED13AA97
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 03:29:15 +0000 (UTC)
X-FDA: 83973516270.18.50A777F
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id 06EE8140002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 03:29:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759894154; a=rsa-sha256;
	cv=none;
	b=yxMbbhZJFyrT/9ig1mX/QnCDKzchepdCGZnG0DmL1XNpOigzurzOx0hGcMYywQn5ZJL3ov
	rjcGb52CXTnBOUx/U/yOV+SS8uVK+sXLtn26TlQUy8cDQZZQ2HSqETELgMDlK1PO1IBAml
	aAhyQtHcAOnSbb2lHr1WhH7+qsi7aGw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759894154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=j4qILVJfm7DfhssJ0ueEnYCl55Tf6EovTh892sb6XGE=;
	b=0MoxZzUpTEWvd+ZlYZYLqieG/VeqEsoKFTMS1+B8qhkZXiIdP1geqBZ8nKNyhVScyrKXBC
	srO90MJzVkoAG7GsNQ8aAElMS1Y8INX6w9xR28hEnquFC6xuN1wp+BtsY3CyZKaBf+fxJ8
	CGY5Vp6IFRCs5JC5WLx/Cm+6VJWSvS8=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3ed20bdfdffso6101980f8f.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 20:29:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759894153; x=1760498953;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j4qILVJfm7DfhssJ0ueEnYCl55Tf6EovTh892sb6XGE=;
        b=jBk8kB3Kd4ZvvM3p5AIjAN/2NpbeZQw9s0NxTP7HZAE25JFbaMT2nq5dY/ObnjZcJg
         rp2vXV7IAyhSXUv5Svo2TRhNzzPrpQW5KOt9tCHqn6LAuCmcEw7D3IoFp5QeENGLXEGl
         GXq7PNivVgBgUtnkYITx4ERPEWdIP0lc8HvkAlGL6YrCyAp/DEdavrLjzShVrq9r6Qba
         yUn0Dv9K/jw50a/BCV5h2/xuQcCUnuVxyMdfqMprRDQmp74F9C6FlJwmnSp/Wh2s9mvs
         gx8LjEpZna+eLzN8Z//JVCVHrCmVa3VV71cQuYAscgiAhrh414mqlDSia6OWmZARR+Vv
         uuvA==
X-Forwarded-Encrypted: i=1; AJvYcCUQpIeD7V9Ws3chvfVzpTboS+E3vIhIDprd7jaOThWB4P7JaHZVtRXoR+nS1jrzB3VUt8MVdtZMmg==@kvack.org
X-Gm-Message-State: AOJu0YxGJiHUf67CfWnixxf7qthG1RBsRXBq3epvkn0oPFgy7dnE4EMp
	2BAOyVLx1o/GmtkLgLCyp1Hf6Z1+JQiO8jxf8/lycifNo7vkh5aL0tdq
X-Gm-Gg: ASbGncu2YLv9/TTJ9seyQDcEe6zOTevN6D6oaQE0ONx2wBAmgvfOpfV/nzK0XuH9Uj9
	dnoCSAxp6m67F/vizTbFtN1Tk8amlnUd7vn6xtBEgSL66M3h0lEoBNy502rH7fYHQKSWscgCnbO
	2X039kAPuavtzHxybjJzn+UEGxFw9QInfUPwKp+mmo/T3UphL5AIgM4t0RZuFl1MpvkBxiF8pbf
	+ARqpXget9b6yRmkU9X/LAWzRm9cwbDeVgB+QK5R5eo2HsGajbPLDQ42ArdKrSSL0/eMSBUHC6h
	M0HRuqjhRUSpFfD4zZvBZZ7vp9kL/EF2kV7Lp1Ip72IWUXRGvsmhiY4GAMjlIYXnEUoFV5r50Aw
	QdrFGxySst7E9/ee4njD1byDzt4LUxk+f5ItbAN8=
X-Google-Smtp-Source: AGHT+IEqyPpRTF2bZhw/gcKv2q3t9mfW/SB+36ieW0hvddjq7ne03GNKUlJjLVfRv6Vn4FOWpuwBsQ==
X-Received: by 2002:a05:6000:2305:b0:3ec:dd26:6405 with SMTP id ffacd0b85a97d-42666ac73a0mr986043f8f.26.1759894152435;
        Tue, 07 Oct 2025 20:29:12 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::30b2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8abe90sm27644519f8f.23.2025.10.07.20.29.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Oct 2025 20:29:12 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	dev.jain@arm.com,
	hughd@google.com,
	ioworker0@gmail.com,
	kirill@shutemov.name,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mpenttil@redhat.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	ziy@nvidia.com,
	richard.weiyang@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on non-swap entries
Date: Wed,  8 Oct 2025 11:26:57 +0800
Message-ID: <20251008032657.72406-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jf7j8deawus1bibmqe9fo1wiguc1snmg
X-Rspamd-Queue-Id: 06EE8140002
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759894153-259558
X-HE-Meta: U2FsdGVkX18hbDC/RUEDxIuYDrwBuHWpyAlL+Js+3qdctzaCdqGI0mLnZIlA2Sr/Wm+ZS5sxiZms8GasnvNTzv9P8niPxXeO0Fl8qWRtN1vnZnk362jFJFGkhK8kWsSTZspthRtK6RN65HC2lnzlelsdTCWroUKCkswdowX5qQ1HHg+fILJDuZx19f6yXu8R4jnDwapxH9xiI3XCufFBUv+eDvCGQ9R7lgBbbu4tAGf6bG4GDa4d2rf4aKV7ZIyltuGx1+k85wzIsFzxJInQOD/CG/uOeDTjIRyyeZsmuMFbW9u/HA2n/Gj9Lo9mpW7qJayUITFWBnxxCB8+yJCJgXwOwDECuMLS9zAgIJFyloZOIIsMgOPHerxaydIYkLXYFdJhVn6EHZh0hprAF+fBR8ZyBMpNPTrdh0p2T8/RrKforyyvvFciWt216XkpSKaw5mw18m5E8PR+lVkP/oXpjLMWEJmuN3frnzCZmgapokn9EW3GE4MSUxkK//DZ0us0Lc4wJA1HzIC/BHvkTGUhVxHSUTdwoIw5cGeZU5UGD0/o9JI0/Aw89T1j7zIb7XDE8bFHNwB5KiFNIxsCf/XRALZQ4suWN60nemmH/5xoANAjm3Kp7QEjjaTFruknj/gkyDBXoeicPkLO43CKYbxL8feS5QKI/nQxfINJ/pFGv7pkROH/DN9Le+EKrh0HCp6nak8/LDyj9p9ozw2jvmko/+JLFtMG1A0v8byab5bGMh+V3u+a3ZDyxhqizQz+2AgmT7x5yCttkFoKNLtVQth6347zqIV4Wx+omKnn9GGagpFxFndoE2VoF76ud9i/YMEw+WLhHaPJDajz6wR0u+oCadaQdVnEgx9lo+lLe8gskXt79LiFlIBiBxGUiVCvgF4IinHcUXVqWlrYE3ZIHOH4960GftDXNQAcZdkQzWyr/oCrleYHcFXXYobdFxl9skf2p8fH1DqZkpiM+DknXBt
 6EII+2cn
 D3sxOEzh2biopv8MXti5wEm63ubKg12c4eQfl2W2/L/OeD8qW/Wa6Hhlt3ikBYRx/d8b3xZ0Y1RojP8mHq/+YvS4dT4Cbit7VEM/YtMGsUlB8/pPtpbXatfsaa4fkTvH1FjIkj+WMRsX4dFKBZtyu3SIEshthh3h0M6XIDJU4nFamcRkF+h43Po60rcnhCpl70ygITuWmNaR7lk9QQBQbNBjZRLlDHi/yxc8gMGpx2MOQbLY64Xs+XZtl17mWUz4f15AAsTJbvblSswqTER097qtzQd7cYdBtJTn58BcfvfH7s13RNL37FPJJDe8Zlpj2Pl+EMqzXlbIBdFb8T67/cpon5hoaNo7zeED/l9soZ+1usYzhOnp4wE14EfgnhHVLwzMnLBgSvOysmlLC71Wlpw8GHlMZ/0iBHk/H3vMUoIvG6yrfsGX8Me1YDGJYfRjfAjb+kls9vOeQRwYcC2FHmQeeBJbsLplWW5CK8QU5jOmDdT9q/+cgGYbSRR8Nk1BXUIW2ozaMC2JNbviFSWixfgYqCOGGWVUYP6Di2priAKKytJE2HYQdrY9WSoftqH5kaUFeGZmU3wV1iwSsbvkDb3DxeNUuFtyb3q5NAqP+BJszcOD0HS3txZr1i8/AQ1EVG1onuDLzCLW8zYuoWlIHDUwyvxPK6PuvjygGAD1ZnVj5Mi4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Currently, special non-swap entries (like PTE markers) are not caught
early in hpage_collapse_scan_pmd(), leading to failures deep in the
swap-in logic.

A function that is called __collapse_huge_page_swapin() and documented
to "Bring missing pages in from swap" will handle other types as well.

As analyzed by David[1], we could have ended up with the following
entry types right before do_swap_page():

  (1) Migration entries. We would have waited.
      -> Maybe worth it to wait, maybe not. We suspect we don't stumble
         into that frequently such that we don't care. We could always
         unlock this separately later.

  (2) Device-exclusive entries. We would have converted to non-exclusive.
      -> See make_device_exclusive(), we cannot tolerate PMD entries and
         have to split them through FOLL_SPLIT_PMD. As popped up during
         a recent discussion, collapsing here is actually
         counter-productive, because the next conversion will PTE-map
         it again.
      -> Ok to not collapse.

  (3) Device-private entries. We would have migrated to RAM.
      -> Device-private still does not support THPs, so collapsing right
         now just means that the next device access would split the
         folio again.
      -> Ok to not collapse.

  (4) HWPoison entries
      -> Cannot collapse

  (5) Markers
      -> Cannot collapse

First, this patch adds an early check for these non-swap entries. If
any one is found, the scan is aborted immediately with the
SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
work. While at it, convert pte_swp_uffd_wp_any() to pte_swp_uffd_wp()
since we are in the swap pte branch.

Second, as Wei pointed out[3], we may have a chance to get a non-swap
entry, since we will drop and re-acquire the mmap lock before
__collapse_huge_page_swapin(). To handle this, we also add a
non_swap_entry() check there.

Note that we can unlock later what we really need, and not account it
towards max_swap_ptes.

[1] https://lore.kernel.org/linux-mm/09eaca7b-9988-41c7-8d6e-4802055b3f1e@redhat.com
[2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local
[3] https://lore.kernel.org/linux-mm/20251005010511.ysek2nqojebqngf3@master

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
v2 -> v3:
 - Collect Acked-by from David - thanks!
 - Collect Reviewed-by from Wei and Dev - thanks!
 - Add a non_swap_entry() check in __collapse_huge_page_swapin() (per Wei
   and David) - thanks!
 - Rework the changelog to incorporate David's detailed analysis of
   non-swap entry types - thanks!!!
 - https://lore.kernel.org/linux-mm/20251001032251.85888-1-lance.yang@linux.dev/

v1 -> v2:
 - Skip all non-present entries except swap entries (per David) thanks!
 - https://lore.kernel.org/linux-mm/20250924100207.28332-1-lance.yang@linux.dev/

 mm/khugepaged.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index abe54f0043c7..bec3e268dc76 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1020,6 +1020,11 @@ static int __collapse_huge_page_swapin(struct mm_struct *mm,
 		if (!is_swap_pte(vmf.orig_pte))
 			continue;
 
+		if (non_swap_entry(pte_to_swp_entry(vmf.orig_pte))) {
+			result = SCAN_PTE_NON_PRESENT;
+			goto out;
+		}
+
 		vmf.pte = pte;
 		vmf.ptl = ptl;
 		ret = do_swap_page(&vmf);
@@ -1281,7 +1286,23 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
 	     _pte++, addr += PAGE_SIZE) {
 		pte_t pteval = ptep_get(_pte);
-		if (is_swap_pte(pteval)) {
+		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+			++none_or_zero;
+			if (!userfaultfd_armed(vma) &&
+			    (!cc->is_khugepaged ||
+			     none_or_zero <= khugepaged_max_ptes_none)) {
+				continue;
+			} else {
+				result = SCAN_EXCEED_NONE_PTE;
+				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
+				goto out_unmap;
+			}
+		} else if (!pte_present(pteval)) {
+			if (non_swap_entry(pte_to_swp_entry(pteval))) {
+				result = SCAN_PTE_NON_PRESENT;
+				goto out_unmap;
+			}
+
 			++unmapped;
 			if (!cc->is_khugepaged ||
 			    unmapped <= khugepaged_max_ptes_swap) {
@@ -1290,7 +1311,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 				 * enabled swap entries.  Please see
 				 * comment below for pte_uffd_wp().
 				 */
-				if (pte_swp_uffd_wp_any(pteval)) {
+				if (pte_swp_uffd_wp(pteval)) {
 					result = SCAN_PTE_UFFD_WP;
 					goto out_unmap;
 				}
@@ -1301,18 +1322,6 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 				goto out_unmap;
 			}
 		}
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
-			++none_or_zero;
-			if (!userfaultfd_armed(vma) &&
-			    (!cc->is_khugepaged ||
-			     none_or_zero <= khugepaged_max_ptes_none)) {
-				continue;
-			} else {
-				result = SCAN_EXCEED_NONE_PTE;
-				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
-				goto out_unmap;
-			}
-		}
 		if (pte_uffd_wp(pteval)) {
 			/*
 			 * Don't collapse the page if any of the small
-- 
2.49.0


