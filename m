Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF335CCD19A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 09:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 052108E0052; Fri, 17 Oct 2025 05:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 001F18E0016; Fri, 17 Oct 2025 05:39:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E32C68E0052; Fri, 17 Oct 2025 05:39:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB1578E0016
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 05:39:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65EB2BA3D7
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:39:10 +0000 (UTC)
X-FDA: 84007107660.20.1C40BA8
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id CB4BC40009
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 09:39:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760693948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=82txt8z3ePeVTeUSUG8VLqTzgVsdlRqOmFYFwTwtnb0=;
	b=E/btsVc6gkqDWjt0jSyITEgTj5CZT9yHUEm1re3jsYns1U17hGFEoSWIXE5Jn3jjPauFm3
	4srRi4doe430UOKXQyEwt+KMGd1oAKMYSgJ+RVhGRWM34Z1QSTfVh/f0N0SIAvXvAj9fvA
	8W5U3Upnj5j1yqhGcs401uMMErn5e8Y=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760693948; a=rsa-sha256;
	cv=none;
	b=L5Rs4/IyVcm6uXt1K7LoxLvV/MOeWi5H/CG1m4yuftRhTdAEfnZy6h7Kt9b6iIdgNrz0qo
	iq2HfEP+tAZDM6J5Vg9SMVCamKJ61E1DxZWq80LrjSlrmFkCNjFUpMCNvKDv32SRLPG5E8
	LqoY2DPpz6FaKKAdlmhrjPb2ciozCvY=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-42706c3b7cfso177274f8f.2
        for <linux-mm@kvack.org>; Fri, 17 Oct 2025 02:39:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760693947; x=1761298747;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=82txt8z3ePeVTeUSUG8VLqTzgVsdlRqOmFYFwTwtnb0=;
        b=qQwLYFU09bI2vvx2d41V9KP27yMgmHtqLFigdvfm/WR0/KCuUpbFXsq2Ci1P/d0sJB
         zV8w+Q9x/tE4+siPBzbdX9pNFXe7mji8hsfGWezfs9UlivJ3Au3+eIUTXC36k6HuL5nG
         /M4eXVNqN19YTN4Z/HQ1Tv8oH1eyzbDagTHBv2CrucCMmQAR+7VJdVfTudo61UQlwH+S
         pCOEGt8c8uzpWVxvLaayS95VoHLEx56q1I/e/3ZsZIW8mqukKIk5fiC3320iN+Z12soy
         2She2kzt1dVmoR8S/ptzzDREHwiWsEWbm412w3uJP7XSuz0CPIoP1nLJs62ae7IH/zC7
         /Udg==
X-Forwarded-Encrypted: i=1; AJvYcCUEGOJM4ehcwMn0k7dvR8NJMv+EsNWTnfJYaEDWDmlkkao5TSk5ARfIiOqf4denxHnq4OAHGCO61A==@kvack.org
X-Gm-Message-State: AOJu0YxrJdL0qvvjMKEcD8AiPksUHwGtajr0gMQDdOLbdX1puLEewujd
	1jLr9ePF/ciOoosPtuLJdIV9VlB0CQ4wcuOVYJFE/lS9zZ2GNXTfO2Xp
X-Gm-Gg: ASbGnct/flNS132/tfkNegd3MtykPIgXbQBbt/BtisrU8PvNmIpk/2GrezDqzt0CwCf
	wV4n9LYow1NoYBXoCq2bRiet3+b54nk8Ja4D3dUeeHr2b6HUo/58qff9Zd4YKmFPRbJ+dpRp8FE
	qc+gyxrOTZWVzbwscMZKB4c7w1n2kH677icle5m+ZN1byHh5r507C8D0BzdsuhPu7+w6dRL+8Cd
	8RhKgqXw2ulDetSiAqpwBGSfoc4U4pbjUwDJebNq9iN7KhQcNJkwa94E9OpzklqaJRdEwtA1Iwh
	8h034L+4gr8EeSh455EgVgfc03td8BpQ3B/6ToCTXhJwihomUjR4hQX9tfawkKEL0ULNowBNQVn
	Dh3fcAz68GJwKCDZfeNkc8LxqFlFFp8t6tYSxRFxJDT9bSE/TdpsKWsftlOtQol9SzQ==
X-Google-Smtp-Source: AGHT+IG1GbOglWAOwpAnLl2f/RlHayD8BRBUt5O0twnrZaHrEC3ynTgsF+9lhYx/GNx+QUpdNq8J/Q==
X-Received: by 2002:a5d:5888:0:b0:3e3:24c3:6d71 with SMTP id ffacd0b85a97d-42704d51240mr2007293f8f.1.1760693947235;
        Fri, 17 Oct 2025 02:39:07 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a09:0:1:2::3086])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce583664sm39883572f8f.22.2025.10.17.02.39.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 17 Oct 2025 02:39:06 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	ioworker0@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-new v2 1/1] mm/khugepaged: guard is_zero_pfn() calls with pte_present()
Date: Fri, 17 Oct 2025 17:38:47 +0800
Message-ID: <20251017093847.36436-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CB4BC40009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: dyn3f1ezfuuod4q3bsm85do4fqhk89wf
X-HE-Tag: 1760693948-786071
X-HE-Meta: U2FsdGVkX19bR/fael4Rt5k0KC4aEigvwtFVFRvQkQQMS7iUJXKM/4dxajGpf2TLVZ1mn/dRoorFFjW9HuAbTX4lU1fr2DokJ05Loq7I+JejXkBfprMc1bl+Vgv1D0W5gNMre3DO8+hc03sPTfWLeWX721PoQLf5Zfb0hqTG1gg9sgzuHUg+UCsNWuirU0ocGg4gDY5pxvc8TToHmsFg1u3BwWWOGUVvu3ND4hi+3DodJh6+gesGoCFr2v1vx3b6msMUVpYNSUunAW5K7ZIHU5vdDnhCXWnhaKKC/NdmxfeOa6tBvhWc8XEKKT/DwQlJaN889zTW5xYkILgG4h/FwME4QhxDENWgALawNdBiyFOytnAW1tJXzZgf7Tg5kjYiiQ6Sf7VecrQm9SNtZDSX2n4vzYAWOGwZT0241q9yeTLISDNZ6yTQhFBeKpY26rB4YxM/HCpZNObDHxVdbPRs8BHRxmPs4pSgPrGiUG/L7bTZNZhgNTiN6oOBovrVgqi2+AyZPMy7MUzXsknM7acRsZnotvkeTEY4LXYJIs2gY1PnolQrdQfcWUbf+vYdb8ZlJiYBovgURFpJD5E9DaI4SWHcFL9zLonJ5YhptZQH5NRhczXkErbo1jfCJHfK9Lrf6XhVNwLPwQdu2qKOYdNyE8KES6UysFCAbkRHjng9nP8T7NL/zUw9Qu4HpHT+nT4AQxXznMcaQS6beMGGuvjcElUqabMShTIYMfNYiZgUad80WVE3aK5QSfXdhApLTWyQci93V4VJqDuwUTZor9s3vjITEEWLSFSwkh5UFEe0Zxcts05ft+BqqmLPsxXxqtcra9wqXguFK8QP5CXkQYg7fFcBaWA1//u84PLyfsCRWWlsPZKNYywyg66xV2IuhIcSK2PCTMOKvE8M4wfSnFxf7chVm5OENLg0LREVK1HMCRafO0WvT2QxZX5WJrvcMNpDpQqw8acaEnBot06WxKy
 4/dAaH05
 3cj9l/UgXTp0MNZDM7fYWHRDyEamTSInSJrzZDtgs9wEQ6MNJRkhQMkM7G07yy15bV92fj3bw3VeNLM9f7CGiNu4wF2vnxcr8NYXWVfiDdoejUmHmqJaicto7yr0Pu76Qud0HADkp+GG39XMxWtF4H/zt/iKCTxlxefMh04LH9h71fbmUlAL0jnxyf2lBDeIjeammOuxPjGe97+gbbyLPTmY5o4OJIG8JNWxYIHjlpu+4CobK7CCCK7JbHScy3BdowlgTAMXlYRBMsIwUisITgckRDjnRONZYO37MS2TNgHqO98s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

A non-present entry, like a swap PTE, contains completely different data
(swap type and offset). pte_pfn() doesn't know this, so if we feed it a
non-present entry, it will spit out a junk PFN.

What if that junk PFN happens to match the zeropage's PFN by sheer
chance? While really unlikely, this would be really bad if it did.

So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
in khugepaged.c are properly guarded by a pte_present() check.

Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
Applies against commit 0f22abd9096e in mm-new.

v1 -> v2:
 - Collect Reviewed-by from Dev, Wei and Baolin - thanks!
 - Reduce a level of indentation (per Dev)
 - https://lore.kernel.org/linux-mm/20251016033643.10848-1-lance.yang@linux.dev/ 

 mm/khugepaged.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d635d821f611..648d9335de00 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -516,7 +516,7 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
 		pte_t pteval = ptep_get(_pte);
 		unsigned long pfn;
 
-		if (pte_none(pteval))
+		if (!pte_present(pteval))
 			continue;
 		pfn = pte_pfn(pteval);
 		if (is_zero_pfn(pfn))
@@ -690,17 +690,18 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
 	     address += nr_ptes * PAGE_SIZE) {
 		nr_ptes = 1;
 		pteval = ptep_get(_pte);
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+		if (pte_none(pteval) ||
+		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
 			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
-			if (is_zero_pfn(pte_pfn(pteval))) {
-				/*
-				 * ptl mostly unnecessary.
-				 */
-				spin_lock(ptl);
-				ptep_clear(vma->vm_mm, address, _pte);
-				spin_unlock(ptl);
-				ksm_might_unmap_zero_page(vma->vm_mm, pteval);
-			}
+			if (pte_none(pteval))
+				continue;
+			/*
+			 * ptl mostly unnecessary.
+			 */
+			spin_lock(ptl);
+			ptep_clear(vma->vm_mm, address, _pte);
+			spin_unlock(ptl);
+			ksm_might_unmap_zero_page(vma->vm_mm, pteval);
 		} else {
 			struct page *src_page = pte_page(pteval);
 
@@ -794,7 +795,8 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
 		unsigned long src_addr = address + i * PAGE_SIZE;
 		struct page *src_page;
 
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+		if (pte_none(pteval) ||
+		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
 			clear_user_highpage(page, src_addr);
 			continue;
 		}
@@ -1294,7 +1296,8 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 				goto out_unmap;
 			}
 		}
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+		if (pte_none(pteval) ||
+		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
 			++none_or_zero;
 			if (!userfaultfd_armed(vma) &&
 			    (!cc->is_khugepaged ||
-- 
2.49.0


