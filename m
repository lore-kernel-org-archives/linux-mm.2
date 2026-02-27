Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0BE2FEFB58
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 14:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C64D86B0005; Fri, 27 Feb 2026 09:35:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C12EE6B0088; Fri, 27 Feb 2026 09:35:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32406B0089; Fri, 27 Feb 2026 09:35:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FF146B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 09:35:25 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4B4A41606A6
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:35:25 +0000 (UTC)
X-FDA: 84490484610.23.A84ADB2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id A4D52180006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:35:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772202923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=H16MC33XKhRgnT6CoFw8RHXtgCJA06kFRRpA7cTakUs=;
	b=VaYi04RWH+kRV3/42NiSZ9hCJchcHDMubxMILJxYXhj7qSmikBVAkN15nmhwAK9oXwWvdu
	mGijruyK+HYhTMSENZaRrDTiCwTt5QS4Zs+B0bfljnWB3ZWeTwtUip0eJWda7X+tObUbGB
	P1YxUYrFYpZPae2yf93xh+ECvKlCCtw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772202923; a=rsa-sha256;
	cv=none;
	b=UEY/eZx4+mgpmsPg+oxAKFBmC0OTCkmb8oudIF2GQZSd+s1fxLwUvZYsPIfD9Ed1X6FDNp
	c2iGDEsbAYoTp5jLXCiAzEkUuTtLJ1MEG75xaUn5EKXN16Y4izP8ow6t6H03N1cXoWoFSp
	VwyKecjTv90yWihkg8R1de0tQRjxMqM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 429AE339;
	Fri, 27 Feb 2026 06:35:16 -0800 (PST)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 982293F62B;
	Fri, 27 Feb 2026 06:35:18 -0800 (PST)
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] khugepaged: remove redundant index check for pmd-folios
Date: Fri, 27 Feb 2026 20:05:01 +0530
Message-Id: <20260227143501.1488110-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fcz135q18y1usthreczb5uzwoqighdqa
X-Rspamd-Queue-Id: A4D52180006
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1772202923-942582
X-HE-Meta: U2FsdGVkX1/8ekHi7ZvY1JwPLaek9Dw5lJmomu2ZM6qkQAcSWBsFVIbzpC1AXOogup+JZTIdArhvm1trvVAU19H8h20OX1cUSQHkeJpY+F1ahyAuh3PiCSCr0vogSFF9cor5T25qGRbw5yRYxFY+h9fsmjI+bjC4YyydqWbi02jQT3XSoSnOTdiMKYIuEgt3K2E6im9K9bjoepAqdl+F7KpgOS44e5c9DiNgdSznxX4Y2e1ZMVUNoNeJRnCwBv5vKhSJFt1KKnSD/7hME8gxwIvSWq7YiVtxhv2PHTy0DiDbm2KGsTqFhR1Ms86AtYv/Bjf2WT29+Rw6vw/nX/ajqski/QTSr/lW+9HMtB/iapj3dZQQEXH84WuBeHalypoCKy5OaxmRCRWxIUUdSBFzYxKU2xKXIuYXIhOLtZzbspS4TOi1MLAg9WLtqmWL193IK6ALfp7zLbI4jNGN3Xz/76byYZIU6V3bplYoDPxv5FnOh1zhqvsF3o1tzFNQK+cMWK2UVAzsG+W2e6JgwDvZIKAPJZ6TuXE7qf1xUct4JV5Ad0tPi4IO61h0phpo+RFAyHHuTrh/os87AwT/f4zRgNowtRmoCT61XDH6IG+pe54boPU+rBnzqeFASoX2IYTsVamczSOFG+BOogv2xNwrlcitj3ypFLpekHzcGjTk7VqRjNVuhKSfWVB42TyXRyhqESrs72LTFpWby85lXsiJPHvIx1DMYGMLA8gj8Diq73vWvxCFMob7yWKfG2y7IgVHRTja7Qegj46Bf7tIe9q5xW7DLUp6UheX9bJkOWrI9P+PJePM0oOeNMjD2bu1iCaVFm43Kq6To8c9CDjZfHlIklub+zdjk1VWbiRNyV1zPs6d9SCxLXGHb0++YtyICZ49LVPvkaEg2EtPTsYSVN8UbwtLBs/NxWTnN5Mf0MHgleOIuo4UQ9V3YyWaqjga1DEhslYo+86x1K7OANYbUOb
 P7u68dOF
 VQR8KEfyAtm0yOdKguF52YRBevwkgV8ltIFcOzG9riw4ZHebXZvnDol5JIXezIAF8cLAQNgehKGqmjLipfeO3qeiHrejDwezeVxNzNvEwravKryGAMOD4Pk+yKGZk8vX8kqnxpPfy+fcfPkAh1q7VT6dL2ZSbUZj6x5bxOFvrC9iKUcqZBOhkyIuSc5Vp6C5OPmOwwVLiQ7L5IOT8R7YioCeFyUUzEMjnYPTmK3Z/dbIDWZo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Claim: folio_order(folio) == HPAGE_PMD_ORDER => folio->index == start.

Proof: Both loops in hpage_collapse_scan_file and collapse_file, which
iterate on the xarray, have the invariant that
start <= folio->index < start + HPAGE_PMD_NR ... (i)

A folio is always naturally aligned in the pagecache, therefore
folio_order == HPAGE_PMD_ORDER => IS_ALIGNED(folio->index, HPAGE_PMD_NR) == true ... (ii)

thp_vma_allowable_order -> thp_vma_suitable_order requires that the virtual
offsets in the VMA are aligned to the order,
=> IS_ALIGNED(start, HPAGE_PMD_NR) == true ... (iii)

Combining (i), (ii) and (iii), the claim is proven.

Therefore, remove this check.
While at it, simplify the comments.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
v1->v2:
 - Remove the check instead of converting to VM_WARN_ON
 - While at it, simplify the comments

Based on mm-new (8982358e1c87).

 mm/khugepaged.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5f668c1dd0fe4..b7b4680d27ab1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2015,9 +2015,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		 * we locked the first folio, then a THP might be there already.
 		 * This will be discovered on the first iteration.
 		 */
-		if (folio_order(folio) == HPAGE_PMD_ORDER &&
-		    folio->index == start) {
-			/* Maybe PMD-mapped */
+		if (folio_order(folio) == HPAGE_PMD_ORDER) {
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
 			goto out_unlock;
 		}
@@ -2345,15 +2343,11 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 			continue;
 		}
 
-		if (folio_order(folio) == HPAGE_PMD_ORDER &&
-		    folio->index == start) {
-			/* Maybe PMD-mapped */
+		if (folio_order(folio) == HPAGE_PMD_ORDER) {
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
 			/*
-			 * For SCAN_PTE_MAPPED_HUGEPAGE, further processing
-			 * by the caller won't touch the page cache, and so
-			 * it's safe to skip LRU and refcount checks before
-			 * returning.
+			 * PMD-sized THP implies that we can only try
+			 * retracting the PTE table.
 			 */
 			folio_put(folio);
 			break;
-- 
2.34.1


