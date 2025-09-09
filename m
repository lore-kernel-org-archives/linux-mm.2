Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E4D1CAC589
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33AD6B0026; Tue,  9 Sep 2025 05:14:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABD196B0027; Tue,  9 Sep 2025 05:14:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95EB96B0028; Tue,  9 Sep 2025 05:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7DB156B0026
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:14:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43AF51603D4
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:14:45 +0000 (UTC)
X-FDA: 83869151730.21.FD3A0DE
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0F54C80013
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:14:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=IjUMIvmi;
	spf=pass (imf30.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c0HW+blhE7M3nTPyFA27l5i/iEflduWAFHPGBKiI5lE=;
	b=YCKO2I8M+bwwisvG+zHsgJ3h+OLf/OSPxm8zFZrOjl7cQeivM521MbnDosR18PvrMh1KmX
	JK5KwAWnycCmrsil0qLMUyGe/bwAlaVLTK1WS1XLdO3OUyKWJMQ75G7pyoFDSVBcPLkKeP
	sQg3nA51hgWMfIgQ+Q2mNDBHLFC0H68=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=IjUMIvmi;
	spf=pass (imf30.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409283; a=rsa-sha256;
	cv=none;
	b=ob1x6R60Tj9WGDoUFTP8B58gGSyEs3SmkM++4niptt0ywqfYIMJPZQGxDv8TNjwXpdLm91
	UyvkhtPornGm/oNv76xDvghKWG1ib12FvpILqLrb6ZF6rfPKzeoAGU7VppfwypjHDkCG+x
	o1yMLOwOnUSjVeQV/Wus7f6CERbEDeg=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588JqsJ3027668;
	Tue, 9 Sep 2025 09:14:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=c0HW+blhE7M3nTPyF
	A27l5i/iEflduWAFHPGBKiI5lE=; b=IjUMIvmi0L8BRu7otvJmyUfaAOG1ADq20
	7i1e5kbZNv1UarwszA0kPJ8nqONwLuxygYrRYWDS5u1426Lh/dGnPEj5LMufW/78
	p8dXRqGGLDl8wmJwEfplSm8VUufMhZnuDwtGbJM9OMEILDJ/5XYMlYh5GZ5+1Ps+
	M0/aMk7XLBZ0gEqaWZabHJMZUtjWsTw7Z0iTDWCfXXyQkEzutVRwBDTJ7jjlISC2
	UiQkQRFUSXFRiG4CvqpmSwL3X2odqlqlKj9QnfpPxkVhd25alo16lqNk/q9PDKSY
	Ra2OK8TCN7Yy1wtLh307ot2saiWQ/O1umlBjsPFlt2jc4bN7zXUvQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490acqxn5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:14:36 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5897Dfcg017163;
	Tue, 9 Sep 2025 09:14:35 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gma577-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:14:35 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5899EY5X30868222
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 09:14:34 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6144D58061;
	Tue,  9 Sep 2025 09:14:34 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6617758043;
	Tue,  9 Sep 2025 09:14:29 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.2.198])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 09:14:28 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        alexghiti@rivosinc.com
Subject: [PATCH v17 02/12] arm64/mm: Add addr parameter to __ptep_get_and_clear_anysz()
Date: Tue,  9 Sep 2025 19:13:25 +1000
Message-ID: <20250909091335.183439-3-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909091335.183439-1-ajd@linux.ibm.com>
References: <20250909091335.183439-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zma7-2BIGce-GjmjSuDkB0mTsFn9uVMG
X-Authority-Analysis: v=2.4 cv=Mp1S63ae c=1 sm=1 tr=0 ts=68bfeffc cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=_22z2SZoHydJqXFBeZgA:9
X-Proofpoint-ORIG-GUID: zma7-2BIGce-GjmjSuDkB0mTsFn9uVMG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAwMCBTYWx0ZWRfX1ZST0tGidk09
 0tYS4d3b9I50Xe9Xj9L0RFbb//nVHmcrY8Kmmi0KcbGjvSYhAJnleq/oaC9/hiqsN42X8f7wI3z
 NbPTNnaRmzQcq+jUWyL5N5delqzVe6pmQP7pMEH2r9GHThMmXfnGONPytsC0UIbAAjb8+hBqRve
 aNnvPhGBgOKjU962DWfo6101QuylYVAuKBPcQi7jOi9N/PsUme2uFMHalr7FrJTaQGhbAEnV5lj
 y0CZaENOf0CkOi/7y2Va75gIixlFoFqMPH6XkB6x7G9UX13q51yxh7e2RVCTvO/3r7/qo8VJliQ
 oyo4C01nk8inYVWpCpnzb3yphiqfMhuWgkuSgxBYgHXz7eTo3cYMf6cjk884K3kcopbupsItyOL
 woutaxKE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 clxscore=1011 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060000
X-Rspamd-Queue-Id: 0F54C80013
X-Stat-Signature: ud6c3eokbgr4su5xrdkxq3qurwjthk14
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757409282-450880
X-HE-Meta: U2FsdGVkX19ZdSTsGhuF486HAuZkyDDeH1yKvJiPwWAiiPaCaNBcLBizKdRZEL7CJoVtmS/2c7bfgqd5zO6ZkqItKPorh9SLOYfmalenZAzISj5qDX3Vu1KcXu3aojyC/tA6zMeFldGTwALuEX3Uhs1opr59OsYwISCGlyo8UqLc/0OzEzUPmu/8splamxTdzznObkmt09RfHv94D1iUjtSSJR+gyJo3FPWi1XFmgvdsZ195M8RpotisRmvqWmB2VY6WbLiqCuVSb+EO6NCtHs+2JetddCXiEUzxaycs1MFwfEA3e6gY7UbCfefc8VwSjl+lpV3RL49+gyH1vVzGvjYmFc1wvtm21i7quT061O9K2WNO/e85kPNY3m5sJ3ivZkpDYqvdbQav9t5b7O+L45NunFIN0P/ylJ+ccRwlKSeZ0p7pauurysCIPgudeEEUcZlY+Oez6v//zrme1r7A1NiedBn4qMHEEPRRb1TL57yqBqr3Tfp4EYONW0hpq+7Xz8TAQYUc3Pq5xeXvl1pv97UFd5Sh1lpfO3y3j4ez+TLaVNWEPb/LrW5kXr+JdWuttYQ7hik9+FxEUvhnuEyaVVduw91y7XZyB+MtByJq9KumCbhYKAvF+htkxxwVkYEea4QzZ5K5M4Z9DBVoUmJE7q7owaR8Rop+6/t29BkFI8ynKUU0omRP+WcPIw0i76kqdr1Bmg+UAvRUjYCZCSW1bNVC+k8ZnnNdlhpYGx1BGVV4i/V5Z/ISD7C+sAlv6wsW2ek/G/26SjA9FbCp+MP7pgGWTlhtHXEe4EDJbVyZofzLiGKUGkZ4Y9RIfc58beE4Nb7PN56wysOVZq7/kg4VqC02B6RbuPAlIxXPy3QPE02ltvzVVudbSO3ylbsCsgBqvF5xxqBiQXMQeZ48VlL+p+UhPpqjnjpn6+Vmn9GJyNB0LFx6EnN0tTA6EkqJmK9K9eyMQ5i7VZ9RDaSyhUv
 DgZl88jF
 ATwGVncjbgQSu2z4SX7UgNwucGj0tudU2vjnhiISdFkriGXm2sR73GDBwOEn76EkpNRigBAWSKUCFxS/cc7criW2zavorKCTqLQDJbmNg9TN+Frnn33b91s6wvvxKT1AWPWglc1HHNA/aqPruaMUcfHoP4PXkhEzmbuigC0Pjl3g/ImLyAxo6JKhmWaMXiWXtIszC0qLvYb4BpCgdeS8UyWbHN9UNCW58pKv/kWWdyDTE0rlAIeiCb/Gwe3R7u8RLbbHlLgd5eOhEz3d/5rX2z0nln0UOUoBDvxgVbOsaH54xi5t7lw8WMi1Sj7sV+WPOwQAob7BU5r1o965oW5778KdzO+C8mItkFp8cUj3uOb7af3IlRCx9md00ZQ==
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
2.51.0


