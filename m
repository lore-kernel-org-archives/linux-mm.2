Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E8EDCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBAE38E001C; Tue,  9 Sep 2025 05:15:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6B358E0015; Tue,  9 Sep 2025 05:15:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B336F8E001C; Tue,  9 Sep 2025 05:15:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 986EE8E0015
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:15:14 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 655E2C0434
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:15:14 +0000 (UTC)
X-FDA: 83869152948.16.555530F
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1ED46100002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:15:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="PQi/yYMJ";
	spf=pass (imf14.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QUAUe1gZkDXqDdXJByUDedQ9Y4Xn7V6W7BbuO0bUF/E=;
	b=54l29VH2QpD1/lztVeZfVrpWW9hPPWdgWbYQ1SxRF8izyQOkXGcDeBj/QjcT5wa0T5iVvQ
	56FOXhL74eaULqXjqQ+XDMVAusRJRXL9jzjCY1Xj2qMB5/3lvJn6jhi9UkC0vzaiTB/NrD
	tPfOeLHCubXoFxAkuI0u/UVHmGaGZCo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="PQi/yYMJ";
	spf=pass (imf14.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409312; a=rsa-sha256;
	cv=none;
	b=dEzdptlGw1VO1YbNih860Fk+cuGMVGKeQEAecFCSWguQz11XJjJr9D3ZElOgCGtYwDzWyp
	aueXUeBi85GOy9NLf42zfdSmGDg49BUDniG6o53qCiw1y2SqNw7XUXIC0+KR5c1/NhDENx
	kJHxW0KXdUTZMi+DeqLrbFSi0aQ4OLo=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5896VvRG008043;
	Tue, 9 Sep 2025 09:15:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QUAUe1gZkDXqDdXJB
	yUDedQ9Y4Xn7V6W7BbuO0bUF/E=; b=PQi/yYMJdvAS9k02PqVF/m21iI0q5nGnA
	/E9H3cTMKOilcM6tMRccrD1iPSSuwKypjXDZqq8X4NK0nSmd+iSnKsnCTrIWUQBN
	njt6lfM5WzbdFibf57cQQ3WOF5gZnjpnndQ/JS2PIKDnpT6y+Th5wM4PNF3RI2+J
	4m/jnGkr5YGi7A97OeRe+t7T+ZOyqGy6OrLqEXuWDBxh36Y1xxTtv0TkwG2X5znF
	UFguKpFTVjoz7j2jn6tvKZ9ozv1K/jd3AfKTXkTZmTQRzeAbf+tbJpyspbYWfdw+
	jmjQbDkJrCpNJ0LpH9Iztp3N4ART9SWyIOO+jeiJVmJu0+Gs5UiDQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukebx3h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:15:04 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5896t4kj010594;
	Tue, 9 Sep 2025 09:15:04 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4910smt9ng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:15:04 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5899F3TP33424092
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 09:15:03 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 813D558063;
	Tue,  9 Sep 2025 09:15:03 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 15EB258055;
	Tue,  9 Sep 2025 09:14:58 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.2.198])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 09:14:57 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        alexghiti@rivosinc.com, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v17 07/12] mm/page_table_check: Reinstate address parameter in [__]page_table_check_pmd_clear()
Date: Tue,  9 Sep 2025 19:13:30 +1000
Message-ID: <20250909091335.183439-8-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909091335.183439-1-ajd@linux.ibm.com>
References: <20250909091335.183439-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDE5NSBTYWx0ZWRfXzjVXfs4IKY8c
 0OX9ZzWXRqQI19pEPWhJ3ibdWLYA9qB765+TUyXKd+ItvUTV9x0HpJUC2vCRussfHpFPcH4hZJF
 JXK3JmBmW471DgjGjL+5jhja12tNY5uCPnHKTYsWpjxHkxG5cYR9l21ERV04euewY5HD2+KdqbT
 EbTuTHUU305kkpoy0p20ifWEhbk4Jp2gaMp3L7fCH/xqEcv/RotTWbCuiuJCfH1wxPQvLIqkzFF
 Ya2hwtKVgORrVtmJs77meztrwwOsjQCV1sFluN7HwHMNNi/AQgfsgnh8Iq/mTQEX+WqTQR83Ap2
 M6z3Nz4kwW02xxlvM0W21Yg/+2NEH9kKQxM9Mf+IYeby6qlp3iu0+my1lLo8Vc4np4s9KZrysns
 EWjrthwt
X-Proofpoint-ORIG-GUID: QN0PTe2awLgTQlX95me5sAZrLyqoU1y4
X-Proofpoint-GUID: QN0PTe2awLgTQlX95me5sAZrLyqoU1y4
X-Authority-Analysis: v=2.4 cv=StCQ6OO0 c=1 sm=1 tr=0 ts=68bff019 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=VwQbUJbxAAAA:8
 a=h0uksLzaAAAA:8 a=wZhGIaPSpsofiGV4ShsA:9 a=gpc5p9EgBqZVLdJeV_V1:22
 a=MSi_79tMYmZZG2gvAgS0:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060195
X-Stat-Signature: t4j16wcjiys4kutnype6apm6u3y56mf7
X-Rspam-User: 
X-Rspamd-Queue-Id: 1ED46100002
X-Rspamd-Server: rspam04
X-HE-Tag: 1757409311-549821
X-HE-Meta: U2FsdGVkX18YRT6azVlH7OUc1fYnSWz4lzMW+thdlUeeoPEKudGc98LH1jSsTcnq+BqHxvVpcVFDubOJhY+X/d6Rb5XxjD7kcuECqV4InmWEWsL24eRr24jJ/i4AmW04Y3ds/PoZ8Ne3QQOhggbrZCEYja4ZZrtI1KNTDdMWQp3R4g1djfmjSxcthZtAf1NSZcxERmpzTeARjCQJKI2KAvtdfxD4aBvYDoRm4GAEaCXQdgfS7ShiOzKNsnIC4oXmGUm+g0lLqZbkRsS7aFf31rvwzxkT3XLJg1nhSoxeVKexFjPrnvxO7uus/uzrR5gshQiOFjuN+rxjvIr/sCKZ6C7lX2iB0SyZBEtetSpakOW9tkPA9sIwQPWb+D793fSAjHKOaJc87MWtPg3DAm0SL8c750KMgvdIFyVpVTiaJhyCulRcNW5IqO96PNnkIJwhZjkPLPCLfNN4+kxHFq4sWzD4nxNVq4sNncLBmBpyKV+cXxt9Z8EQg1BwGCTbe6Q0bBzZRILNPTDMTQRJii4Y/CMYUiXzukSIpK68QiTOBXIYAvy/qzx43fJ7TZ+ftYioG3Sr6DaJDBsfT2bgBPo2BVaAT8WVOl06sOw7K005kbHKwoGgOrEjpgBLnADANzeHnlgODrxedde07rkjslX836P0OHX65cywvidoLGzEO4e4LBAis/6+DcrGsSsvxrdRHLu8iV9xAutXYVrVuLD3BFnKM1sHov56tr65u4wY7tI3tLi3Z0J2Tzt5Mgm8eQ6BQUl/qf8S6DiuZfT+cdKjH6U/+ISklV+yyyuyOg/6d8rxK+COMchP+O/CmREp8VsLrPWCST8ulVMmlW8uRnJaiD/YXcZ0q3hj/N0A9dzeJX1fuqLBq3eE3HEwAwt4ffScUx7MOsoQXujLF2Z8Fq8qCVEmWDANh9HytLTjIvY24i91d6F7W/6Y+6fPvxMSO7Y8Lb8duPEcJIPTUv7bs7t
 JnSaQiUW
 nHvQ2pxp33wAYbXcjNuLztfB63dqgFjgQkl8GsbdAvBBnmjV5e6DJCyhQE5SOYzwuXzNtiOqRLHflOo8bSKmjbtIdke2U14psQ47vPJgMVyPi1d6ZnJW1KZbvcaHLCuBvjo9NnxJFRN5d4RHfzYlU+0cvPNSEq9wqc5vBHX2j7IlbD8mLYbcRjlwkOMyX2jL+kxQqj88paDKrOzM0W3jBxFc0VPyI1d6POI5Ox1peei85C5sDYcFofa+h0AMIVnLf19l5a3tib88Dhs60GoSSTw1/+VyIMEzazkGpfdKsxbnVqezSyjOqjXEBnDw4Gj8b+HWLLNXwDLNibSzHPmbFndQimM2fadMdqwum5qfzOqEYz0Cr8cwiVimvEST3iTB/G7h4N7JW3cKE6K/klAcyiG/uTFRTbMaDOup/U6JkJzi1qrc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rohan McLure <rmclure@linux.ibm.com>

This reverts commit 1831414cd729 ("mm/page_table_check: remove unused
parameter in [__]page_table_check_pmd_clear").

Reinstate previously unused parameters for the purpose of supporting
powerpc platforms, as many do not encode user/kernel ownership of the
page in the pte, but instead in the address of the access.

[ajd@linux.ibm.com: rebase on arm64 changes]
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Ingo Molnar <mingo@kernel.org>  # x86
Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
v15: rebase
---
 arch/arm64/include/asm/pgtable.h |  2 +-
 arch/riscv/include/asm/pgtable.h |  2 +-
 arch/x86/include/asm/pgtable.h   |  2 +-
 include/linux/page_table_check.h | 11 +++++++----
 include/linux/pgtable.h          |  2 +-
 mm/page_table_check.c            |  5 +++--
 6 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 81f06e5e32b2..dfcdf051b114 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1370,7 +1370,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 		page_table_check_pte_clear(mm, pte);
 		break;
 	case PMD_SIZE:
-		page_table_check_pmd_clear(mm, pte_pmd(pte));
+		page_table_check_pmd_clear(mm, address, pte_pmd(pte));
 		break;
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SIZE:
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 3d152933eb99..d8bf210b57aa 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -860,7 +860,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 {
 	pmd_t pmd = __pmd(atomic_long_xchg((atomic_long_t *)pmdp, 0));
 
-	page_table_check_pmd_clear(mm, pmd);
+	page_table_check_pmd_clear(mm, address, pmd);
 
 	return pmd;
 }
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 8b45e0c41923..b68bea15f32d 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1318,7 +1318,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm, unsigned long
 {
 	pmd_t pmd = native_pmdp_get_and_clear(pmdp);
 
-	page_table_check_pmd_clear(mm, pmd);
+	page_table_check_pmd_clear(mm, addr, pmd);
 
 	return pmd;
 }
diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
index 808cc3a48c28..3973b69ae294 100644
--- a/include/linux/page_table_check.h
+++ b/include/linux/page_table_check.h
@@ -15,7 +15,8 @@ extern struct page_ext_operations page_table_check_ops;
 
 void __page_table_check_zero(struct page *page, unsigned int order);
 void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
-void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
+void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
+				  pmd_t pmd);
 void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
 				  pud_t pud);
 void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
@@ -52,12 +53,13 @@ static inline void page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
 	__page_table_check_pte_clear(mm, pte);
 }
 
-static inline void page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
+static inline void page_table_check_pmd_clear(struct mm_struct *mm,
+					      unsigned long addr, pmd_t pmd)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pmd_clear(mm, pmd);
+	__page_table_check_pmd_clear(mm, addr, pmd);
 }
 
 static inline void page_table_check_pud_clear(struct mm_struct *mm,
@@ -121,7 +123,8 @@ static inline void page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
 {
 }
 
-static inline void page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
+static inline void page_table_check_pmd_clear(struct mm_struct *mm,
+					      unsigned long addr, pmd_t pmd)
 {
 }
 
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 6d00d0948bf4..46fe3daa4b18 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -648,7 +648,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 	pmd_t pmd = *pmdp;
 
 	pmd_clear(pmdp);
-	page_table_check_pmd_clear(mm, pmd);
+	page_table_check_pmd_clear(mm, address, pmd);
 
 	return pmd;
 }
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index bd1242087a35..e8c26b616aed 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -156,7 +156,8 @@ void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
 }
 EXPORT_SYMBOL(__page_table_check_pte_clear);
 
-void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
+void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
+				  pmd_t pmd)
 {
 	if (&init_mm == mm)
 		return;
@@ -231,7 +232,7 @@ void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
 	page_table_check_pmd_flags(pmd);
 
 	for (i = 0; i < nr; i++)
-		__page_table_check_pmd_clear(mm, *(pmdp + i));
+		__page_table_check_pmd_clear(mm, addr + PMD_SIZE * i, *(pmdp + i));
 	if (pmd_user_accessible_page(pmd))
 		page_table_check_set(pmd_pfn(pmd), stride * nr, pmd_write(pmd));
 }
-- 
2.51.0


