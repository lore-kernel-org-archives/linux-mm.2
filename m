Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3380EC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 20:41:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B149F6B008A; Thu, 31 Jul 2025 16:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5676B008C; Thu, 31 Jul 2025 16:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A02A26B0092; Thu, 31 Jul 2025 16:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 87B026B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:41:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75939C0AA5
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:26:42 +0000 (UTC)
X-FDA: 83725693044.27.2302097
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7AB1080009
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 20:26:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eDZEfT6t;
	spf=pass (imf02.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753993600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2QWyqOhHxg7JbenWRXhBIzIH7+1hBrT59x3bYZFd4Do=;
	b=JjLmwZ5bO61wrT5xnJlI3bbdJcMVXAHhxkLTn9wDMCDVX8aUYBhA+4uRVDAp540bzKQBZv
	N+2uH8N5loagM3nMoP8Jt6+HudYSSvCV71yo4UTRwCMvuoWblX9Ct7vEKOxOeQlMzIHSkc
	N58BZ8BbVHNbyQ6yG11TrHbQ/q10Bto=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753993600; a=rsa-sha256;
	cv=none;
	b=EilXdQRMO/azjextFB5WnkbRo/ZAT91PgnZ8xHkDvH4/01EUdyxNFIJm6fc0ZfQqnJ6fEA
	kOZAUihTTvbJXnm/fgXG73GSVyER+tJZx9SVFx/lev0gFxOhyIQkwbkzgWGGh7/wYI8Qsg
	hrNbjqL4yKZTJpnThQfKyKe08QbNMN8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eDZEfT6t;
	spf=pass (imf02.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56VIXtDP014858;
	Thu, 31 Jul 2025 20:26:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=2QWyqOhHxg7JbenWRXhBIzIH7+1hB
	rT59x3bYZFd4Do=; b=eDZEfT6tx541Eqw+re/pmVqKbWTr5SjDb0gU+1r9Z+uBl
	XVdYOYw0CXZl28YXccMOfK53L8U9LMivaTYy+uesnq4ieTV9qt0t+JUmw9kfQCiO
	i1voNJlDTh+SVE6emc6iMOHoMAolxXABIb2WVQxcAisUMmlrKHsOdvR2UGpZe2Dy
	vbat3arTKuBS4A1GcR96X7uJEhmzbLE2KTNyZDviboIgAc+n+i9/M09WBEKgrMpI
	av3TUeBLdqGkvD58RYGr+qnQur1CCEbxzyMs+rsgxuG32sM2Y2LKQc9w+jvarmwG
	CbM8aGq/UIf3XeplsFsifAhOxyIyFFLij9OwAYQLw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q734yjw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 20:26:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56VIWeMu016723;
	Thu, 31 Jul 2025 20:26:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfka1ue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 20:26:33 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56VKQXAF031838;
	Thu, 31 Jul 2025 20:26:33 GMT
Received: from sidhakum-ubuntu.osdevelopmeniad.oraclevcn.com (sidhakum-ubuntu.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.108])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 484nfka1tv-1;
	Thu, 31 Jul 2025 20:26:33 +0000
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, willy@infradead.org,
        vbabka@suse.cz, jannh@google.com, pfalcato@suse.de,
        lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: [PATCH] mm/nommu: convert kobjsize() to folios
Date: Thu, 31 Jul 2025 20:26:29 +0000
Message-ID: <20250731202629.3729139-1-sidhartha.kumar@oracle.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_04,2025-07-31_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507310147
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDE0OCBTYWx0ZWRfX0E4moPh1P6rU
 1DL+7fLGMhM9r7inHWS65ub9Evp9dAnNcYAN2CGKWbpKzK5JsUYaMXbc2ryUw4Q7m4W3g3sg5WM
 Dv1biJIjZQvWKnFqDCyqNjU9bKr06Ia+zHXmtsnnfKLAjIkF//s9FHjfKOH1d8Qnsn8s/UPsrgO
 cxbXNsEm9BPSp+nCGswKTbai79qsNjmkzZof5G3BRoQsJWhUK8maCfO761VwWPO9WHpCkQaFAjP
 hm4gb0U5EB+Maw4+8Xm9nA1MyGD12+8X0gPSD37jU5RCv/vdZRfpcfPGvy4oIjkkWhkm4E/Wq3/
 Iay4qFkIQulazsemIg67CW80LwtOSY6t420SWtIyFLEgMOZFNV180hDFUMlqm4LbjCMYKmiapuD
 gnJRt3qGxTPAKhezhzMDv4u4xvEnhyPlW1jLN1Gm2zWmHpStqRy4w0/+9ghUyxJco+TTkxwB
X-Authority-Analysis: v=2.4 cv=ZO3XmW7b c=1 sm=1 tr=0 ts=688bd17a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=Wb1JkmetP80A:10 a=yPCof4ZbAAAA:8 a=utxCX54T8dCYmmMssvoA:9 cc=ntf
 awl=host:12070
X-Proofpoint-GUID: 3hmwJVy3hG4Kb9OM0nCFB0V7TNz6bREp
X-Proofpoint-ORIG-GUID: 3hmwJVy3hG4Kb9OM0nCFB0V7TNz6bREp
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7AB1080009
X-Stat-Signature: wi9bu4rthewo3fuqjkt1sqzm33g4oda4
X-Rspam-User: 
X-HE-Tag: 1753993600-96004
X-HE-Meta: U2FsdGVkX18/+3AMSL354KjT9K+EFlDIImCQkSdxPLgDzYAzlU0TI1Wz0uo+qtmiVKRAebTPxQkACZujZFVKZrWJr3454kLc2cVsoTXaR004AP8cSTuuTHXL5eIdFmXrsU0V4d2S7XC/A8M2hm+4IG4d2Hg0WXBc+630UAl3h5Gqp2pwzXa+OWf4zIluVdpuxKdM6eADiYgO8eblwrNj9KmgFUH/20NrHV9xQOCQXgGViTA4flj7FuIvIwIJty1TgD8tyq9Z5zZIKTBetTUPDLZskHbtryhkkN6xg2FbGRmu/hUMou/CvNzDb2I5r2X3IncrJclT7fWsegwfxZYohgpvjw5Y2ANw2zVekstRUPaV/4fls713Nis/bjBxvNXBa1DY+QfxJ1YMAK3oAtddx40tL+KCoyRdgRHbX9nghXGLaBiUJm7Hfpw9vT/7yMmKNheCPBQCQXJkfi80o4oY9O5omRNBA4JDRuIuoYrbjmBe/woH36ohcOGzwXSAbJ3OLMPk8BG/WQ1us/KFoBUvIeRJWjpFylwZ1gNcxlOxo1OELHrpsMXb4dkwtEzwsN1aLvRIIdkOvqXjZ90zq70XK/cwCUpsnFoN2zU60QbFrPVzjfxYpi9iRvfAlFxAT85FwF+I1ka4wrATqTXVBrDXp+HwcFygLJnt7b+vtceIql0+8cEUmx6DuNSU5ihQl/sTxHoOW6jAW6qgIcl2RClp4wUVIfvaI/LX55487loYtQrTkLoge7pvX65O12MH4Ey2uRPoabaUCFqsUGLjgUOLP4s6C3fC958nqvuIxRrSuNka/AgXFf7+Z0921IVMTNEUN1/ZOBSYM691UkSAQSZyIDolwBV3luISqeSeGOAcdjd3pac4NVFmuVKHM9IWGHXa07aCWs9yQjZ3/9dzouSSsvubzEvi1JzC85kFj7PmI0Z6NOrFVKUAh5bqjrMk4XoYaxdKAvG5H7m+S6ImQTN
 gpHC2pN3
 SIpppc6hMb0oyoNtEJEH0AeKU/LAzf61Eu50NlK2ouxGHee0iHP0Cz6Z5/P9rzs77Outduca3jC8asJkFjeHwROW7pJR00c265uva15fY7bmP1UvhgzuydmfgIhZD8g5Aa822VeYc6Y62EO1BB+6O7cC9ecMgYsL6P/plRlPwKoV+6JGSoSEW3jVlcJwWITezzQotBv2fH5M3q9oBSwjB0B7qGoLGOfIYKCtQ8PkHUDPtBVdWBizHp7cotGCoEyllz4iA5gB1TgFYLaxuhUgpTJGZoc8CtD5XJOPFilTagb7ZuT0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Simple folio conversion to remove a user of PageSlab() and
PageCompound().

Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
---
 mm/nommu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 07504d666d6a..a00f8fc316c1 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -64,7 +64,7 @@ const struct vm_operations_struct generic_file_vm_ops = {
  */
 unsigned int kobjsize(const void *objp)
 {
-	struct page *page;
+	struct folio *folio;
 
 	/*
 	 * If the object we have should not have ksize performed on it,
@@ -73,22 +73,22 @@ unsigned int kobjsize(const void *objp)
 	if (!objp || !virt_addr_valid(objp))
 		return 0;
 
-	page = virt_to_head_page(objp);
+	folio = virt_to_folio(objp);
 
 	/*
 	 * If the allocator sets PageSlab, we know the pointer came from
 	 * kmalloc().
 	 */
-	if (PageSlab(page))
+	if (folio_test_slab(folio))
 		return ksize(objp);
 
 	/*
-	 * If it's not a compound page, see if we have a matching VMA
+	 * If it's not a compound folio, see if we have a matching VMA
 	 * region. This test is intentionally done in reverse order,
 	 * so if there's no VMA, we still fall through and hand back
-	 * PAGE_SIZE for 0-order pages.
+	 * PAGE_SIZE for 0-order folios.
 	 */
-	if (!PageCompound(page)) {
+	if (!folio_test_large(folio)) {
 		struct vm_area_struct *vma;
 
 		vma = find_vma(current->mm, (unsigned long)objp);
@@ -100,7 +100,7 @@ unsigned int kobjsize(const void *objp)
 	 * The ksize() function is only guaranteed to work for pointers
 	 * returned by kmalloc(). So handle arbitrary pointers here.
 	 */
-	return page_size(page);
+	return folio_size(folio);
 }
 
 void vfree(const void *addr)
-- 
2.43.0


