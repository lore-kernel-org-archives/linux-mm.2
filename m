Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17164C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 06:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8045900033; Wed, 13 Aug 2025 02:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A02C28E01B6; Wed, 13 Aug 2025 02:27:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F19B900033; Wed, 13 Aug 2025 02:27:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78D598E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:27:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1FC67823E6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:27:03 +0000 (UTC)
X-FDA: 83770751526.27.97327A3
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id DFBDBC0006
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:27:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="qwQS/bPG";
	spf=pass (imf22.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755066421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nrJVwyChoAP1347E6ULfn6WFMFSfSytfpEMcX/qwjy4=;
	b=e/+BRD4eOFSvIrN1t+8/buMwQhCAC3wlCDFOKAEUArqdSejLbTbS0IvJWON30H6ucTmX8G
	EMU6QvmOZ1pxSTEzDFdTksVNhVranGdnhhkdas+piwQ5goxJRr+EyhezYa9p4uH2PhNPRK
	Szzd1dHrEAHSBywcf3b/EifyrSia8gc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755066421; a=rsa-sha256;
	cv=none;
	b=L02wZvwpVOTbYPFG90PdvVrcZ+FBixFObHciWx650BuvAaSjomIhuDWGI+72FAa63u90VS
	SVzDHpuCB+1o4mDGQyjc5rgdeCa3RvdLpCw26p9i/cTWf3w7IgBozQYCzSvWqTlN6fUOiB
	WbdCes8ar+8ApQz5/7bJf7VFZ3hpQsQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="qwQS/bPG";
	spf=pass (imf22.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CNQT4C009277;
	Wed, 13 Aug 2025 06:26:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=nrJVwyChoAP1347E6
	ULfn6WFMFSfSytfpEMcX/qwjy4=; b=qwQS/bPGxt7TGG39EWVe6T3aCIPfJ5VeI
	FPy2KDnNEUsJ41iLxhD0CIZRTGqrb3dDwvTBRZZnYxyA2PmENa1wS4mrdQd03c11
	5dzGqZ40DDpV2vDV5Q4DVjpPC3agYU8yF8ZS/I2Oso+iP/puU0h5lm7I9rtCI4aL
	L8NrQ5HbTkQGFgGspW14V6ehaF/N/fZSw5oG1Etj5tQqUYboaUNBwf6Wftt1VH49
	5BY/Q1KSeXS6HTuTanX/UWGJEHQbU3a5W2iYjWVsUIp6Mw1Is5XI6cmuDhPQPRln
	lrMomYXGN83Y/fimPM+oMGqGix+f82Ft3+9NbfNUWa/oLxDGTK3jQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48duruav9t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:26:55 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57D1c7UT026279;
	Wed, 13 Aug 2025 06:26:54 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48eh21653b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:26:54 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57D6QrkO9962414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 06:26:53 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6AE5D5805E;
	Wed, 13 Aug 2025 06:26:53 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 66CB958059;
	Wed, 13 Aug 2025 06:26:48 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.10.70])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 06:26:48 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu
Subject: [PATCH v16 01/13] arm64/mm: Add addr parameter to __set_ptes_anysz()
Date: Wed, 13 Aug 2025 16:26:02 +1000
Message-ID: <20250813062614.51759-2-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250813062614.51759-1-ajd@linux.ibm.com>
References: <20250813062614.51759-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1DmuEpzOEC91AhJGOz3CZKD6ylyDxymq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfX9mkUL6x9zxY2
 6Gh1cmtLtFG1OFrKTykCTN9l5yXY9y7nJIXtYKb7NVExjYcnhpFmoZGsazt/l5Qt/uBGDhkFhk+
 yYO6Sihmqw4ta5TLtzOLE7kI8qK2nf+M6hZtDXHBTIcObTV00jRqz2KWwXLynRjhgGoKUE5OZaX
 xQUX2Vt6+l85ynB36Tw59m2P/MMuXBITyhbsAl/T7mEY4YfR8vOAqLlVBQOFzOKM9c/sC8zbHzs
 1Ljcba4ASMebldPjFhu+IffpCtJMv1qW80BOoYC2H6VT3wg954WvoAArFf4rn+uyQB1bmNW+ZxX
 Qo/l/sVagrf+MLN3EXBWYV9JCvkoP9V2iNk+OsdaQwPABsgOuvRFGR6i5lPuMCx2fqEBG4WkGmB
 kIYiud5O
X-Authority-Analysis: v=2.4 cv=QtNe3Uyd c=1 sm=1 tr=0 ts=689c302f cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=iO9NmEFvf90wNdx_zysA:9
 a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19
X-Proofpoint-ORIG-GUID: 1DmuEpzOEC91AhJGOz3CZKD6ylyDxymq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 phishscore=0 clxscore=1015 malwarescore=0
 spamscore=0 suspectscore=0 impostorscore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508120224
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DFBDBC0006
X-Stat-Signature: 93y4qoi6oato34mzycrjg3xewg9h93nw
X-HE-Tag: 1755066420-738976
X-HE-Meta: U2FsdGVkX1/v3mtf2vgdsXfHmIJTTjVgIqXVGmInS6PMPrcnug459jsX1CU/8lXpMvCG+pTIRGaRkjo+XOQDYMLfFbsqaOzzPJiozdkOlP6ehZleZbJ8KEhV74h8hkOl5t3pVK3CVbtq7t3fQBEaQwVjMGpdHhyg2c7DWd/ZciJ3LU9rtAuhSpfdsM09yachpxAvdSwS2OlgEgSbAI6UWZjf8hqn3FsPBHgwUnZskdbZt8iw932KcteulXssuxZraBl2BbSVBzIusBK6PHYRbUHXWip7OaLfPiUUaAiDauCLRWmTdm0u7tqDAsWSaEX04z3ubBMfRvQAYSqDRNDK6AlJOAl2BffQs1gucuI9vc8vcS9K7DLKTN0DHb6tzRnCmIqsxc+A5rTjVWkmHnufTOmyCEAkEq/i/gNneUdmmlEZyIPQizASDn6b9tK4zUL83jSFIBrkx/AQl2EW3xginTM3M/1TTbtJb/Fv9RBQA7nlln7iN/xtbZSOyLPKfTHTbnMVKlDKJMnjxd3Tiw5IAolCP8LxNVkcMH2SqE/UqL0ZX0svGj8u865c4lV8SsFZe0d14fad0DpDuQS/a8WJQMoB3RDXdySMySM6Aj52tMvVGH3RistJXVRlUWuRBVyRFdUi3BG+RUHu+MpUnYC34//7fEh3ixlS7FlRxqn/HKVq9dbjsmQfDICsK6A2+dQ1hQTeg59UIytEte5hok1AeyMF5iChxueM14cmvTfioZtBoRKQ7nbKKFXY8x1RDtFocasFwQjooUJCJyW0dFQjrPcGDpRFmp/CpNE/aTuqKW7fs2opQ47JjADCftZ2KfEKlkJZJ3thO39gHQ0wsKjv/QaUY29Wo9j1VByqOr6BKyZ54BkNUBL5Vj7H2Jug/CP+F6WbPrQVR1ZKr3rBLKo2lEqwwPfpLqcdDxrUYrbKP3/NZOPLhr36rl5VN0hr99/zSTWfBt95UAbaMuGdin8
 lqwKyCbH
 hOpybbSsO9StF33Lq6uxYA3+WmOfaDaF5hfmbUBDSD9ItXqE0Xx12VPA9QUhYs/gCKvNDkwtBCDR0jya5vYA1JmGwp7W1i8/5S7O+WIf2N/yYm1B1b1RNJfV20O26nLMiHQiDeP2Bu3u3YMJ44sgOJKKvUnX9XO0mwYR637znACHqOlh30ZDZNpOsESWbxcn/zZmne7xJMuabMPoZjUAGGxZ7QLjL36N+T263ParDybqrnRQPId6K2GJewALHu7c8jJawTf/dQ3dSHkiwZFFzQf+RH2+Frg1VX2xLjqgaGABKYT37Z9D/2dqFcbgPUdkOQI6psIO3aOByhcA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To provide support for page table check on powerpc, we need to reinstate the
address parameter in several functions, including
page_table_check_{ptes,pmds,puds}_set().

In preparation for this, add the addr parameter to arm64's __set_ptes_anysz()
and change its callsites accordingly.

Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
v15: new patch
v16: rebase
---
 arch/arm64/include/asm/pgtable.h | 19 ++++++++-----------
 arch/arm64/mm/hugetlbpage.c      | 10 +++++-----
 2 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index abd2dee416b3..ed644be48d87 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -698,8 +698,8 @@ static inline pgprot_t pud_pgprot(pud_t pud)
 	return __pgprot(pud_val(pfn_pud(pfn, __pgprot(0))) ^ pud_val(pud));
 }
 
-static inline void __set_ptes_anysz(struct mm_struct *mm, pte_t *ptep,
-				    pte_t pte, unsigned int nr,
+static inline void __set_ptes_anysz(struct mm_struct *mm, unsigned long addr,
+				    pte_t *ptep, pte_t pte, unsigned int nr,
 				    unsigned long pgsize)
 {
 	unsigned long stride = pgsize >> PAGE_SHIFT;
@@ -734,26 +734,23 @@ static inline void __set_ptes_anysz(struct mm_struct *mm, pte_t *ptep,
 	__set_pte_complete(pte);
 }
 
-static inline void __set_ptes(struct mm_struct *mm,
-			      unsigned long __always_unused addr,
+static inline void __set_ptes(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep, pte_t pte, unsigned int nr)
 {
-	__set_ptes_anysz(mm, ptep, pte, nr, PAGE_SIZE);
+	__set_ptes_anysz(mm, addr, ptep, pte, nr, PAGE_SIZE);
 }
 
-static inline void __set_pmds(struct mm_struct *mm,
-			      unsigned long __always_unused addr,
+static inline void __set_pmds(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd, unsigned int nr)
 {
-	__set_ptes_anysz(mm, (pte_t *)pmdp, pmd_pte(pmd), nr, PMD_SIZE);
+	__set_ptes_anysz(mm, addr, (pte_t *)pmdp, pmd_pte(pmd), nr, PMD_SIZE);
 }
 #define set_pmd_at(mm, addr, pmdp, pmd) __set_pmds(mm, addr, pmdp, pmd, 1)
 
-static inline void __set_puds(struct mm_struct *mm,
-			      unsigned long __always_unused addr,
+static inline void __set_puds(struct mm_struct *mm, unsigned long addr,
 			      pud_t *pudp, pud_t pud, unsigned int nr)
 {
-	__set_ptes_anysz(mm, (pte_t *)pudp, pud_pte(pud), nr, PUD_SIZE);
+	__set_ptes_anysz(mm, addr, (pte_t *)pudp, pud_pte(pud), nr, PUD_SIZE);
 }
 #define set_pud_at(mm, addr, pudp, pud) __set_puds(mm, addr, pudp, pud, 1)
 
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 1d90a7e75333..1003b5020752 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -225,8 +225,8 @@ void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 	ncontig = num_contig_ptes(sz, &pgsize);
 
 	if (!pte_present(pte)) {
-		for (i = 0; i < ncontig; i++, ptep++)
-			__set_ptes_anysz(mm, ptep, pte, 1, pgsize);
+		for (i = 0; i < ncontig; i++, ptep++, addr += pgsize)
+			__set_ptes_anysz(mm, addr, ptep, pte, 1, pgsize);
 		return;
 	}
 
@@ -234,7 +234,7 @@ void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 	if (pte_cont(pte) && pte_valid(__ptep_get(ptep)))
 		clear_flush(mm, addr, ptep, pgsize, ncontig);
 
-	__set_ptes_anysz(mm, ptep, pte, ncontig, pgsize);
+	__set_ptes_anysz(mm, addr, ptep, pte, ncontig, pgsize);
 }
 
 pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
@@ -449,7 +449,7 @@ int huge_ptep_set_access_flags(struct vm_area_struct *vma,
 	if (pte_young(orig_pte))
 		pte = pte_mkyoung(pte);
 
-	__set_ptes_anysz(mm, ptep, pte, ncontig, pgsize);
+	__set_ptes_anysz(mm, addr, ptep, pte, ncontig, pgsize);
 	return 1;
 }
 
@@ -473,7 +473,7 @@ void huge_ptep_set_wrprotect(struct mm_struct *mm,
 	pte = get_clear_contig_flush(mm, addr, ptep, pgsize, ncontig);
 	pte = pte_wrprotect(pte);
 
-	__set_ptes_anysz(mm, ptep, pte, ncontig, pgsize);
+	__set_ptes_anysz(mm, addr, ptep, pte, ncontig, pgsize);
 }
 
 pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
-- 
2.50.1


