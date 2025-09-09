Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C22A3CAC58D
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CF836B002A; Tue,  9 Sep 2025 05:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2321A6B00A4; Tue,  9 Sep 2025 05:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2E76B00A5; Tue,  9 Sep 2025 05:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA01A6B002A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:14:51 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8DA0B1DBB4B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:14:51 +0000 (UTC)
X-FDA: 83869151982.18.AFC3B07
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5C5DC8000A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:14:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=AVp+gJsj;
	spf=pass (imf02.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rf9ph6NMfhsk4MTnaVOsObGJOCqg2OoTHky2ToZ4s8=;
	b=QEJ4xI+grkv9+QWvaHkABdxeqEJzFfiJ4wNjxNYFRKeJ0pG84738SXpnHqylgl65biwUGT
	3X6rUZLGNDzF4kcnvCrGV1RLJpqFl+f/SRqHnvVIpKuBbh86/ad8tcr/Em+jEk4T4SyDXs
	DPKAQteHsje3e1mAmjGUjfSZqtw6zF0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409289; a=rsa-sha256;
	cv=none;
	b=iTdfC5yQPDiYtvuW3nScglQQh6hSj9tCF0dVH8vS53Tcg7W+aULHRUrDz0cZVUrp+9+gkp
	4z2bTKHDDhafKlH847Ls3DeRXeW2Y8W803pWTtnd1uO9+nYDtnyz3jefxGosP9LEpRlRJZ
	1rx5JnFElov41nuy4ahlH18pFo9+WGI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=AVp+gJsj;
	spf=pass (imf02.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588LZSvp020168;
	Tue, 9 Sep 2025 09:14:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+rf9ph6NMfhsk4MTn
	aVOsObGJOCqg2OoTHky2ToZ4s8=; b=AVp+gJsjS08P32cQR2MuQBjbns9puGbP5
	xodN2E5SZPAvTuPkv4/3Q2jinHyo04hg8HJf9kjRxvKYHK1ryDjmN/gCi2Ed/iDf
	tb7PMjY/7Jy2nrMIUpuJE3mVzvBIwSsruCmGnumBiTXtakfnej+ndzXIlFVnwrUh
	ERtNOxBjH5JTUoHB+YHXFIDaWCxVoYNJ9YLPdMXAedioTtNf1sce2bNVwZgBDPcX
	+YOPJxpO6CF5TjWIt4gqsrcfn7EmyajxGMAEK3PqC2iHLclkrBZp+ZF6gB2tiVgX
	ltJgJAczeF6hGAOrbiNoBEanm/j7xQJP9ocArawkOpa1R2aYLrD0Q==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490acqxn62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:14:42 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5897C1GO017188;
	Tue, 9 Sep 2025 09:14:41 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4911gma57n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:14:41 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5899EeE432637648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 09:14:40 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5BBBD58060;
	Tue,  9 Sep 2025 09:14:40 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 103385805E;
	Tue,  9 Sep 2025 09:14:35 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.2.198])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 09:14:34 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        alexghiti@rivosinc.com, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v17 03/12] mm/page_table_check: Reinstate address parameter in [__]page_table_check_pud[s]_set()
Date: Tue,  9 Sep 2025 19:13:26 +1000
Message-ID: <20250909091335.183439-4-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909091335.183439-1-ajd@linux.ibm.com>
References: <20250909091335.183439-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Bnemy2g2muuTSe51EE1f3lfMhycuZHCz
X-Authority-Analysis: v=2.4 cv=Mp1S63ae c=1 sm=1 tr=0 ts=68bff002 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=VwQbUJbxAAAA:8
 a=h0uksLzaAAAA:8 a=3Toew5EgkJ5X0DR0WCAA:9 a=gpc5p9EgBqZVLdJeV_V1:22
 a=MSi_79tMYmZZG2gvAgS0:22
X-Proofpoint-ORIG-GUID: Bnemy2g2muuTSe51EE1f3lfMhycuZHCz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAwMCBTYWx0ZWRfX5vlHQhb6ufIY
 hw6gBTxk1cQL3J5JktW2Ooxf3WGjOJTjVGlcsjw97jBUK3yDPieVWBphRZGTsxGnQAz09yt2ThW
 +3IyPikYKrpqoESLCtKpsqRCfRFnRd1whd02Q/X0vjxC8uc2RoeNQU+61pP7Ous5lOG1Rrndcew
 3S+t+Gt7sVGFcwh2SCv1TbFo9KPcWd8wxcvUPquggJbqDVOOVtdJPyPxyPM540VdWjh5Yix5cjM
 H8VYc9FdTyJcyp/84aMgFWlnkCB/DFBx/GgieI/wvkbL2j2usLHEQeMGC7kmecIwSUlpGS1U+bM
 H1kXePnVUgfwis1mrG/x9Q3i2nwa/VkzKO6DoCEmuKt6zEDYH8BCkpqlroo2wzYN5MX2Fe5MwnN
 VqaqLMGz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 clxscore=1011 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060000
X-Rspamd-Queue-Id: 5C5DC8000A
X-Stat-Signature: tpe4c746nkwoewe8qm5wqw5u1aziafpd
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757409289-424424
X-HE-Meta: U2FsdGVkX19QIezVhZPwPsgBG3OJavEeWwqy1BVhgA1JqCG75BkqKJSRqgbuc4NaaDW8OZp1g6ESv35EhiQmvSDK5yVSq4KAUG9gkUkgS5YYuh63xuLQd4GUDeQGva7FgWQKmzIeJ0dPpE1MUlb0EjJse4Tzmzknl6QeRwwdbtAGOi3ZIXvCqGJQZIA8ryHOSXW9e85kShU3y4zmK2oEsX28JFrZE9RUtAuzTmmcT0ZPzKo0oR/UO7WN0uZV78qP8BRQcW5e5l8KvPRA1msf3DXdFfYnGMylMztLMJ7zbrFzLBBUeCjOboBssriUZBuraOB4O7in8B5GVfjdOSaugo3z8rKZ4SeWHFdkPUbY1fq8zETKl9RClpZtYsk2rNZ0Wr+mHM3RZKFf2yj1uGuPHXbClTlS5u3vvljzgODidr5QFe045TvY1LtN6MLlGiYP8VraOvjeVDLV/y7LWwNVRH70dRbS8tLWOvSZVyspeu62/icSMGmWxfgPyu9shraI8cwHUwKmEJVtvXH+rQDvTNFnqRRf7HfysgjCcZjx1/bBdspTD/BS+/QeydCUuHtUYfn8VyMk34+pQ/YKTLovBR72/IqgldIx68S3c7/qVMrfR/m8oPXlM3OUtjtBuTvgagGQPM03wyXaS6pakHEUpL35hmBkBmceFIyj2CsXEjizcvrfdhJEkIj85Niw0O9kng77h5s4Hhs+SWVJTimemYEGeF3Rl+k4uxrhxieTnvZEZulkHNsTRqPWkXucBjU29+Ewkvczx2BOj2xSY1mb5o9EOU9qTFuPeBzladiEgpwwGhBcyL9mGv6jeGSUadFdEvTxsdeeVJN4MQMhE74mzoSVji8gSxtzpe9PUPGO4+h2g1KcaLpubUCUd1MCX+v7TRoYsJLA8uue+DxHPHhsC6DFG/QGFMzjoEg/H+f8FQmmZeyia2IwsanYxHF2CsshuR0QAkpLAc97WI9eu5l
 EnE0pvsm
 LIXpoFm0fscFpK1lqP0BAxGsotISknpntkadBrFWWCvz1eWbxNqu/ycok5724k1dTGLR3OLC06ywVjghSURiCIhJmsB9Pjl9/DHM4kZ/3oLFnpdG6J6/aaVddc59KY7+iTNk9E3hHUs7E0OfCXGm3LlmSp3OUeET1XuwW5FjgR6V6UZgP1JcRxD6yEvB8hD5ABPB3CYsDn2xOddH0MJdbXUCQ94pT0ImEgd+a08XJs7rXEO9JtOeg40Scxn+IuHnco8uEfsOXXbSZTIKpY0Cuo1eugUy0ejaWTIgnk5VuoFHQKpxiCp8G6GcyV1p2wcTCUI/fbQ3NctXkhgevQMXLwIG09z1wa2Rd78TMtkTMusUGgeEGXmjY7cjRIeN0Ae2JD0gljSl4HM3uI/Ljb30DQR2kfwxkU+06GF/YrNeDVFXktxX3Ga/Qxn9mQhsQoWPy/544/GaPxpGne9dV56tgbt/Ayc/KQ8MgX8Lh6b0DXJnuCSpeT1HpGvQ6LsTFd1SZOxIrZooZgK6UfJE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rohan McLure <rmclure@linux.ibm.com>

This reverts commit 6d144436d954 ("mm/page_table_check: remove unused
parameter in [__]page_table_check_pud_set").

Reinstate previously unused parameters for the purpose of supporting
powerpc platforms, as many do not encode user/kernel ownership of the
page in the pte, but instead in the address of the access.

Apply this to __page_table_check_puds_set(), page_table_check_puds_set() and
the page_table_check_pud_set() wrapper macro.

[ajd@linux.ibm.com: rebase on riscv + arm64 changes, update commit message]
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Ingo Molnar <mingo@kernel.org>  # x86
Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
v13: remove inaccurate comment on riscv in the commit message
v14: fix an x86 usage I missed (found by akpm)
v15: rebase, amend commit message
---
 arch/arm64/include/asm/pgtable.h |  3 ++-
 arch/riscv/include/asm/pgtable.h |  4 ++--
 arch/x86/include/asm/pgtable.h   |  4 ++--
 include/linux/page_table_check.h | 12 ++++++------
 mm/page_table_check.c            |  4 ++--
 5 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 66b5309fcad8..8070b653c409 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -713,7 +713,8 @@ static inline void __set_ptes_anysz(struct mm_struct *mm, unsigned long addr,
 		break;
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SIZE:
-		page_table_check_puds_set(mm, (pud_t *)ptep, pte_pud(pte), nr);
+		page_table_check_puds_set(mm, addr, (pud_t *)ptep,
+					  pte_pud(pte), nr);
 		break;
 #endif
 	default:
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index e69346307e78..3a113c837605 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -812,7 +812,7 @@ static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 				pud_t *pudp, pud_t pud)
 {
-	page_table_check_pud_set(mm, pudp, pud);
+	page_table_check_pud_set(mm, addr, pudp, pud);
 	return __set_pte_at(mm, (pte_t *)pudp, pud_pte(pud));
 }
 
@@ -969,7 +969,7 @@ static inline void update_mmu_cache_pud(struct vm_area_struct *vma,
 static inline pud_t pudp_establish(struct vm_area_struct *vma,
 				   unsigned long address, pud_t *pudp, pud_t pud)
 {
-	page_table_check_pud_set(vma->vm_mm, pudp, pud);
+	page_table_check_pud_set(vma->vm_mm, address, pudp, pud);
 	return __pud(atomic_long_xchg((atomic_long_t *)pudp, pud_val(pud)));
 }
 
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index e33df3da6980..0603793acb3a 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1220,7 +1220,7 @@ static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 			      pud_t *pudp, pud_t pud)
 {
-	page_table_check_pud_set(mm, pudp, pud);
+	page_table_check_pud_set(mm, addr, pudp, pud);
 	native_set_pud(pudp, pud);
 }
 
@@ -1371,7 +1371,7 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 static inline pud_t pudp_establish(struct vm_area_struct *vma,
 		unsigned long address, pud_t *pudp, pud_t pud)
 {
-	page_table_check_pud_set(vma->vm_mm, pudp, pud);
+	page_table_check_pud_set(vma->vm_mm, address, pudp, pud);
 	if (IS_ENABLED(CONFIG_SMP)) {
 		return xchg(pudp, pud);
 	} else {
diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
index 289620d4aad3..0bf18b884a12 100644
--- a/include/linux/page_table_check.h
+++ b/include/linux/page_table_check.h
@@ -21,8 +21,8 @@ void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
 		unsigned int nr);
 void __page_table_check_pmds_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd,
 		unsigned int nr);
-void __page_table_check_puds_set(struct mm_struct *mm, pud_t *pudp, pud_t pud,
-		unsigned int nr);
+void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
+		pud_t *pudp, pud_t pud, unsigned int nr);
 void __page_table_check_pte_clear_range(struct mm_struct *mm,
 					unsigned long addr,
 					pmd_t pmd);
@@ -86,12 +86,12 @@ static inline void page_table_check_pmds_set(struct mm_struct *mm,
 }
 
 static inline void page_table_check_puds_set(struct mm_struct *mm,
-		pud_t *pudp, pud_t pud, unsigned int nr)
+		unsigned long addr, pud_t *pudp, pud_t pud, unsigned int nr)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_puds_set(mm, pudp, pud, nr);
+	__page_table_check_puds_set(mm, addr, pudp, pud, nr);
 }
 
 static inline void page_table_check_pte_clear_range(struct mm_struct *mm,
@@ -137,7 +137,7 @@ static inline void page_table_check_pmds_set(struct mm_struct *mm,
 }
 
 static inline void page_table_check_puds_set(struct mm_struct *mm,
-		pud_t *pudp, pud_t pud, unsigned int nr)
+		unsigned long addr, pud_t *pudp, pud_t pud, unsigned int nr)
 {
 }
 
@@ -150,6 +150,6 @@ static inline void page_table_check_pte_clear_range(struct mm_struct *mm,
 #endif /* CONFIG_PAGE_TABLE_CHECK */
 
 #define page_table_check_pmd_set(mm, pmdp, pmd)	page_table_check_pmds_set(mm, pmdp, pmd, 1)
-#define page_table_check_pud_set(mm, pudp, pud)	page_table_check_puds_set(mm, pudp, pud, 1)
+#define page_table_check_pud_set(mm, addr, pudp, pud)	page_table_check_puds_set(mm, addr, pudp, pud, 1)
 
 #endif /* __LINUX_PAGE_TABLE_CHECK_H */
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 4eeca782b888..3c39e4375886 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -236,8 +236,8 @@ void __page_table_check_pmds_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd,
 }
 EXPORT_SYMBOL(__page_table_check_pmds_set);
 
-void __page_table_check_puds_set(struct mm_struct *mm, pud_t *pudp, pud_t pud,
-		unsigned int nr)
+void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
+		pud_t *pudp, pud_t pud,	unsigned int nr)
 {
 	unsigned long stride = PUD_SIZE >> PAGE_SHIFT;
 	unsigned int i;
-- 
2.51.0


