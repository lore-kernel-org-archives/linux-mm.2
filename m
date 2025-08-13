Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AEE9C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 06:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A047D900036; Wed, 13 Aug 2025 02:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98EAF8E01B6; Wed, 13 Aug 2025 02:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85552900036; Wed, 13 Aug 2025 02:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 711AA8E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:27:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1BC4A57F20
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:27:09 +0000 (UTC)
X-FDA: 83770751778.02.ED4ADDE
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf09.hostedemail.com (Postfix) with ESMTP id B790B140004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:27:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=H+4Fl0r5;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf09.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755066427; a=rsa-sha256;
	cv=none;
	b=bQwJmzE+uQBhLYE1kqfmzOxU9HqNv984p2wsvhOi/GEWuCPfZ//ACOzN5w/XJZmHDOHcHz
	xPdZrl9q410QdzyLvDjL81hyy6KFT1FL7MsPOLwCa2+LagzUcdPgjgGph3/aGnpgh0R40p
	+MOJmTAysmk6ld9PRaoVCeuOoK4oaco=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=H+4Fl0r5;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf09.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755066426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1GHaxAI7e7Jm7zWrZVTIcSrlfyTmfiyqNti8b4TFpOc=;
	b=UNQeeRdblkm6AetLgpA5Y2GvM6Ktxqzil7EVUqZt4k2P2osiCTHbGSuuc49zvtYIb/mQ9s
	3gGWUVLe4ZLtbdVdOcE/U3gmdhxW5MCOCneUsdyIaRViJL8lFJUJUaVIyFQTOKnQnc9CbV
	trctLYEOGSVi5PFt5BakP2HGe77oBDg=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CNQNMr030080;
	Wed, 13 Aug 2025 06:27:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=1GHaxAI7e7Jm7zWrZ
	VTIcSrlfyTmfiyqNti8b4TFpOc=; b=H+4Fl0r5RNAABMjE43pwrHunsUzTtQiNm
	4wu3QQ5Qpv88TgfBTEGocIFBkqPYGX+CPOxvAk8Bk/nUO7kVJWXFql8LMEMJOQni
	v++FT8b+FS0QoSJFb0ZiuDwG6tNsq0sGj9S8NkcP7wwNI/QtksYvD3/Gl2daulHt
	f4bwZLAy12EYS+2Cxlr6KSlo3To0q44YseR1DzhS+hZ4yZQqJqX+rC3SLKe1E3xq
	v3Es7w2GKPQtKq8oDGCgSqMBnOHm3VdRBM+DAw5pZFOTFRBEvyIKuSE/yc+5rsi2
	aUmdnGbvbg3SHawWVqTTWUSy8D9EJbCzDl50I1ZdSQdjypawtgGQg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dwudax2a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:27:00 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57D4NHRH017588;
	Wed, 13 Aug 2025 06:26:59 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48ekc3np1s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:26:59 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57D6QxC632637630
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 06:26:59 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 07DA95805D;
	Wed, 13 Aug 2025 06:26:59 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B5E45805C;
	Wed, 13 Aug 2025 06:26:54 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.10.70])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 06:26:53 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu
Subject: [PATCH v16 02/13] arm64/mm: Add addr parameter to __ptep_get_and_clear_anysz()
Date: Wed, 13 Aug 2025 16:26:03 +1000
Message-ID: <20250813062614.51759-3-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250813062614.51759-1-ajd@linux.ibm.com>
References: <20250813062614.51759-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfX92rkpoWMsRic
 I8pbfee7csCpHoGV5IQyOP1Bu3bGHdnndHqWCrjTMw7WiwGZ55lEK5b7w+LXdqMPfdB4Xzdzh8M
 7sz3MYUhdh1ruANSfG0kdVNDGehMHgEKc5Z/oINS2zn5TybVjBRnr+3yfpMaDMNTeDQsthOXKJ/
 iG4HEtNq+aOyDwYaK7dyHRUDZtSL4/oW2sOjVGjbwGN4ScZBN+KtbMqGRSMB5vI3kMDQ18pRfda
 qvsLt/OaxALcmYykh3f1GE/wBSmOpdlBqRHoSAUADQuDG87Xagm9Pw/8ZVijqFxEVAL5nOKOmmQ
 ErjKnKJN2TAlx6x4Yn3sjLEyyWOxBw5DNphs1VezYsl7Ai4WHPgr1W0MSXC9E2ySBEwhzf3Li2Z
 3TB9zyXM
X-Authority-Analysis: v=2.4 cv=d/31yQjE c=1 sm=1 tr=0 ts=689c3034 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=_22z2SZoHydJqXFBeZgA:9
X-Proofpoint-GUID: 4ZBlhpz1er1xIozkgnQsN3_4eZX4o7m0
X-Proofpoint-ORIG-GUID: 4ZBlhpz1er1xIozkgnQsN3_4eZX4o7m0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508120224
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B790B140004
X-Stat-Signature: zefu46ob71kg3tkou64qaiax76wzzj1s
X-HE-Tag: 1755066426-514865
X-HE-Meta: U2FsdGVkX18DkWfDbZiAKWERiZsITmE0R4W/juVei1vawH9e/18JQMRmOhsoKL8GDkwJ+RgaOuu82otX/jCpZJN7xq+QcHFxMrMj1dwMKbZOODc7jP9mnvQk8YYzPWCFicWtvJJLSETHlas7NeHV40sGqLghMiLzQVSwvHCfsX05MNY41uVJTLm1gZ18R/EW4x491GgIg50lSUc7KgNkrZz8vWItITzyZ0btzal+K+b61RpDbayHQxf9Dcef6VaCAU2WjSRNNR3Syo36D6Vdtp2vB1uLHLrk40kaUGaghlqIOCuFetbphQnOSPtoOU8XJ/6YLep7vn07xgzgIU5v+B8445MH28mzbyoSc7xjaxIdIsm5eHwRWLU3EqwdV/yNofHUKXc33wXjqxttc5tVJfLQWze33/7XK9zoJdbTTWZzm1kJbVK5080CRyxi6vWoKWBxQ/wfFN8N1+45hcglKkQ1ZosNvc7GNt9FBA5nJ4QYjr6Gu8rboO0UOnYDeb+AhOkiS/3CYOI/krRG+dNN8ph0WLSfb2GOgwpJWCKCEGUQaQKQEhPaoJaIChRWqcQKPXl2OTMmhr7cGZRMZHrZ8nVgzFUXzuxDSLdPqPtHE5Aj9dTNhhisyCnRTgOrd2niH79pACUZ5qy1Yke5cstEWV9Az434oO4dT/sLrs/WdqsQLAF9hwZAjjkpnDVOd88nhmQ9FZcBPpT8ttBpLCzXFq6zIszhJOVJ0VBQ7zXgl0FYMnfGsNCidY0VNk9tgLb6m3FFnOoW1vbtfiVegPLJAnVifVF4BnkA4Jf50MBQxU+s6VNFhsshx3PB21Mnvomy6x8aAqC8v4PdEu6h/KCaq8zyuI9Ydy9lj9hGJ9csaGJOt2Bg8FQZaXCx+JKuEPK7JZjQ63TgfMiodcLN0uDTmxDFIJs/xHr8clJ8+n0SIM5f69uFZKqpf3B6gTt+KXhhZVabTHHRMLQMTYzGsoz
 tLhCzgng
 Y4xfhtNDfBhdOPPMEF8QrN7twWQlsqpEHrjCq4LPzMRqmWMRDLd1YD9j/VD1/u/3scbPsuecN5ok9yMg/Izo0VpU+/xo55rcBx9hJokLXlySnoJp/eeMcFL51bv8wN2M4S5b9xS21A1venqbie4rAGflCSqfKGVZXTUHuOoeqCVlMMNDMrvDXsjJJkBKBWdebqIUl3t4WFYTFuO98nxe+0zWg37ONhh1R5J8+YIxoYlEorILHoNdL25pAQSeZ65B0u88mbR82MJzC4rUjvaVcS6+MyHLfhnEKkOmaIjDtjRvwYEDE1mKUT1OaUPhUV9jkQ7N3upKvocl7QeDcQFQV7iFRwYvU2GRla2uNlmF01yzUOxsdDeyqRZkTJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To provide support for page table check on powerpc, we need to reinstate the
address parameter in several functions, including
page_table_check_{pte,pmd,pud}_clear().

In preparation for this, add the addr parameter to arm64's
__ptep_get_and_clear_anysz() and change its callsites accordingly.

Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
v15: new patch
---
 arch/arm64/include/asm/pgtable.h | 5 +++--
 arch/arm64/mm/hugetlbpage.c      | 7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index ed644be48d87..66b5309fcad8 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1357,6 +1357,7 @@ static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
 
 static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
+					       unsigned long address,
 					       pte_t *ptep,
 					       unsigned long pgsize)
 {
@@ -1384,7 +1385,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 static inline pte_t __ptep_get_and_clear(struct mm_struct *mm,
 				       unsigned long address, pte_t *ptep)
 {
-	return __ptep_get_and_clear_anysz(mm, ptep, PAGE_SIZE);
+	return __ptep_get_and_clear_anysz(mm, address, ptep, PAGE_SIZE);
 }
 
 static inline void __clear_full_ptes(struct mm_struct *mm, unsigned long addr,
@@ -1423,7 +1424,7 @@ static inline pte_t __get_and_clear_full_ptes(struct mm_struct *mm,
 static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 					    unsigned long address, pmd_t *pmdp)
 {
-	return pte_pmd(__ptep_get_and_clear_anysz(mm, (pte_t *)pmdp, PMD_SIZE));
+	return pte_pmd(__ptep_get_and_clear_anysz(mm, address, (pte_t *)pmdp, PMD_SIZE));
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 1003b5020752..bcc28031eb7a 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -159,11 +159,12 @@ static pte_t get_clear_contig(struct mm_struct *mm,
 	pte_t pte, tmp_pte;
 	bool present;
 
-	pte = __ptep_get_and_clear_anysz(mm, ptep, pgsize);
+	pte = __ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
 	present = pte_present(pte);
 	while (--ncontig) {
 		ptep++;
-		tmp_pte = __ptep_get_and_clear_anysz(mm, ptep, pgsize);
+		addr += pgsize;
+		tmp_pte = __ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
 		if (present) {
 			if (pte_dirty(tmp_pte))
 				pte = pte_mkdirty(pte);
@@ -207,7 +208,7 @@ static void clear_flush(struct mm_struct *mm,
 	unsigned long i, saddr = addr;
 
 	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
-		__ptep_get_and_clear_anysz(mm, ptep, pgsize);
+		__ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
 
 	if (mm == &init_mm)
 		flush_tlb_kernel_range(saddr, addr);
-- 
2.50.1


