Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AEE3CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 03:25:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D79CB8E0005; Tue, 30 Sep 2025 23:25:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D512A8E0002; Tue, 30 Sep 2025 23:25:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C67158E0005; Tue, 30 Sep 2025 23:25:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3D208E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 23:25:06 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 304D116091D
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 03:25:06 +0000 (UTC)
X-FDA: 83948104212.10.A208168
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf03.hostedemail.com (Postfix) with ESMTP id 80A1120002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 03:25:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf03.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759289104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=FA57N8DSQvEdDyyKBkxAad4tUYCW8q9ybdMKiaOoC/o=;
	b=kIfWvLPNYsH8Zvk0Pp0bNMBnPDzxQHFB+urza/MdhQiLT1lEWoLeN2jS41gZ275rR3fpxY
	3rVv1VxrCu9WG5mwuC9GRqiYcr+4q+6PURwriSZw6uDdwKTgrbfJGuHiHBWPSH4tzIpcQv
	zOyKqWgCapZGSSCtXCdJfrNoiEliHvE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759289104; a=rsa-sha256;
	cv=none;
	b=tx2YToJlPeO+rRQtjgaztlGp4cmGPhAfd6AdKHWklFn7pXUaXCdQlb82LUDh7TyXA/WK6D
	cC30BGkIFi1S2Oy2KTRlG8bgqBimwKuiE79qk+g9Dmds7eZhGsZBEbepTqVj6fpLw2qCbz
	VH/GVXDlz8A/tvYt7qSEnMXQQHj+PcE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf03.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42557c5cedcso251648f8f.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 20:25:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759289103; x=1759893903;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FA57N8DSQvEdDyyKBkxAad4tUYCW8q9ybdMKiaOoC/o=;
        b=ldxwDo5+qTWLmF3diqWcpFZjUzwJV8d8nbUD0W6xQr9mq05TAclpuwoSxjG2ayGXmt
         ndkd3YorxUv49WG68yeE7y8mP94RiagNo+laOq06eQKa6yAhv1bUULdN1scL4hlVAN6r
         HbNHkh6M/Gung2Khuodh9mrQHPrMYJaxJ/FjqJtfU6X7VbH1FW9Yu37XLhCrk+VlCLi5
         zQu08ZVsG7/U4CteOXEUkzBmSMeehjvo1f/XEvwrZ8SU0PGsY/VB5fTCQZGZ4NAuJ1vb
         CUwVgo25o2r1uPPC8gVLN/gmBs2N+pVI3DqIm6LagfWcYZK38wGnX9OSXKBWkqJ3D7SB
         CmNg==
X-Forwarded-Encrypted: i=1; AJvYcCVZB7FWjXSywzXJwllDC3X56EKXtK4d3UQTfmvj9et5hSqOVFRBVvmVZHH/kzFhZ/48QNYeebOIXA==@kvack.org
X-Gm-Message-State: AOJu0YxZq3npCzzzi9or+0BTBo41AVAqsgVzxhqydhswWdrXwpCmKYvy
	qlEf614YbnHmXcMyHwJBHaEhtka8ndY8Bo9ZlzJ5Nz5HOTnoxLZgwHdc
X-Gm-Gg: ASbGncsxW2JDzWK0li4Oa7rESdr6X4QCK2W9OIJCQ5teXVY4LDG8SWDA1ZB9g5hB56X
	cCiy5u/F0+sj06Cniz64dAWieEZbkZ40hoX9/bsh0mt5mRm+zz1fRvtzC87wMib9XE4gkbsq5iD
	/zLDK+GRQxKzCHBBwT3eTZqhJlhEPMkTYa0By30ZkA16MuggWIHQ/qCzvNHjgvx4Qpvw+GB2ClY
	8FVgMk1W+53kt9mr94rSQsI2ZnXsaQqV47VnwCPx/WRzYNJx5eo07yjIszHxflYudAURwlwIcOa
	b1g22Hxyx+7At19yAMTqyZHgnl7KcKvtDZmZKr59269jDcCoxSsgcl/SFnmdD8O+j+Bu6tKOjcU
	3suGJoXfpxJzDySZfB5BkdHUtlsa8fcSKnD6j2W8=
X-Google-Smtp-Source: AGHT+IFBchqrZzaojHRR/WFRnhqsxmy4IwBajiOP3XpKUmxGFc7GSlwImuIjkfg4UuEYFnWVH5+X+w==
X-Received: by 2002:a05:6000:2388:b0:3e7:4697:297a with SMTP id ffacd0b85a97d-425577f5552mr1219739f8f.24.1759289102832;
        Tue, 30 Sep 2025 20:25:02 -0700 (PDT)
Received: from localhost.localdomain ([2a09:0:1:2::301b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb72fb017sm24993352f8f.3.2025.09.30.20.24.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Sep 2025 20:25:02 -0700 (PDT)
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
Subject: [PATCH mm-new v2 1/1] mm/khugepaged: abort collapse scan on non-swap entries
Date: Wed,  1 Oct 2025 11:22:51 +0800
Message-ID: <20251001032251.85888-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9maci6cjp8n3rhxskgr6biygwf41zcai
X-Rspam-User: 
X-Rspamd-Queue-Id: 80A1120002
X-Rspamd-Server: rspam10
X-HE-Tag: 1759289104-30583
X-HE-Meta: U2FsdGVkX1/VpJYSB9sPvxqxYjBCRh3b7qiOLfBLUluGurBhVt+ll67/2JCxz0XK+zcD25AlnDs/JHkbafsHwkae/CfWGDS0zFqF1Zk/rDChbTqIkSbt+qOVlicer6QD4YPxrhPYK8A2I769AmPg/02QGWuhLsnpukBt63nuUFmwMXSF/jnWANE5GfEiqbrp8rhOFktEtNmD7b113r3nB3oNx2lTaKpsIAZ/yB/xwsVZSuYOwiByb5Iguvnfi32xoPMdvKtDklAtLgTo+Beao/T8M6BxRo3KdmlbSuYoNTi6wqZRTkFfp8xhA2pK6y0RmrqaVMGte6ls68g0nV0cCvi6gYSVF0KDZD6TzN+1lhEONbl3qaKE+amBsjr2Lr3AhQw9KXQRMY+/D9ruYHNrH5WFZ+NmND1JCujX8+Q7Ytx0/FV0agCPlB0OaTLHfNnHysGBYOXRfTJasZ+wLJiD82lH9pafCmrMXHn5HJ99ttAEDSXoSR2XOxueAxGplTuM6Jot1wnTDKhWJ5ttrRXTyDOgVcYoWISICOKBsTkLLuyzW1cP7XoRIcIIvoQ9tXn5EyHx83KwLLR/UoIARmnlVjlyfW3DmacI7PuUXGBWvSXXY9YYvty+whyxxUGweTylrscAXjgETG2nSC/KJqeV7poaDJZeuiGgsZEU/JbZsWih73AFiyjBCSlOWnq9uRUtfNhRfnJVAOfcF8H/DU9t6IBcE3CDOi+DvABeA6eK+E4KdC/GezK0srGl/oaAMK4uT9pPCIvpZoFfn1zDmhWIdGFmQXjhFXbtLQnNDWrbWHqsmOxm1HHE+OKK92NIoWgeE0VlcM3belU+X7ydBXXDQZ9VxCoLnGml3ZWHTmqgborf3wAs/j14ob9sKsSZwZdCXqgH9plIDcOsc1x+SVQJTqZT+s51ah1byzcF6M6RkXNi/xY6an4Dys/tWD6M0lMo1Mjp6wwMtukjg0Yx9HO
 DbShZi7+
 vO+xOVYMEbIIlPsZDp92aJac714F4VhidqvrDU85D5ucn2cUdA907nW34qSw+mcgO4jrmu6gEWmyDU434B7cgZGOWs5QWrRwucmZvpAo8wB6zl02UwYqy0DCrQsEQpieFTUzmSFYqhj84fbmBNe0l/8rFDrzpihcD4ERWgoL2zV5YmoHxaq1ufpJKhwxNsNdkbP3fddOLSKmGeLTl5FIFvxg3SRezCZHnKhSfwE6Q4u5DcR2xLUFzNhQFyUJVJlsl+KRsDwPRlYtMVcWuWL1HnXEs9CYW9cErzwdH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Currently, special non-swap entries (like migration, hwpoison, or PTE
markers) are not caught early in hpage_collapse_scan_pmd(), leading to
failures deep in the swap-in logic.

hpage_collapse_scan_pmd()
 `- collapse_huge_page()
     `- __collapse_huge_page_swapin() -> fails!

As David suggested[1], this patch skips any such non-swap entries
early. If any one is found, the scan is aborted immediately with the
SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
work.

[1] https://lore.kernel.org/linux-mm/7840f68e-7580-42cb-a7c8-1ba64fd6df69@redhat.com
[2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local

Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
v1 -> v2:
 - Skip all non-present entries except swap entries (per David) thanks!
 - https://lore.kernel.org/linux-mm/20250924100207.28332-1-lance.yang@linux.dev/

 mm/khugepaged.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7ab2d1a42df3..d0957648db19 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1284,7 +1284,23 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
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
@@ -1293,7 +1309,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 				 * enabled swap entries.  Please see
 				 * comment below for pte_uffd_wp().
 				 */
-				if (pte_swp_uffd_wp_any(pteval)) {
+				if (pte_swp_uffd_wp(pteval)) {
 					result = SCAN_PTE_UFFD_WP;
 					goto out_unmap;
 				}
@@ -1304,18 +1320,6 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
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


