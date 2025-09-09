Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6206BCAC589
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1DB66B00A6; Tue,  9 Sep 2025 05:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B804F6B00A7; Tue,  9 Sep 2025 05:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6F4A6B00A8; Tue,  9 Sep 2025 05:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87F1F6B00A6
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:14:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F77C1DBB11
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:14:56 +0000 (UTC)
X-FDA: 83869152192.17.075461F
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2584C40006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:14:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NXExQpH1;
	spf=pass (imf12.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQ6Ww2rKo2Xh8yFEHpjFEkuRbeIAUa8m0xDumih+LEw=;
	b=nmyAm0jR16iFvekRWQqQtgE+Gm+gkp58oQ0W9c6VNwIqDhX3YmCTZAGvkpa9RsE9PWHgwT
	3KNLOkuw2qwdjvF/k8V/el3NoTM4snmOyJ4/msc/iKsw4kNAN69yx9ookcTbiRAlV/to+A
	jUAxS2091aTz2IQNVMvf9zSoTrCgz/s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=NXExQpH1;
	spf=pass (imf12.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409294; a=rsa-sha256;
	cv=none;
	b=AXBqTVnkU2NZTOWhWrX1GxI907pRaDRsUN07Gn89nDi6LA6B1dV3HQlmaYACrhVt/GDzdN
	/ap1W7TihG6HC6pk6BGctiWOYV0e+QdXt+mjksQWN8G1VSqOeHL4LvgDy1BpvnyIna9BOI
	IxqMgWDWgxDdkL+UgBzimLV1R1rHiuU=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5893mTOS032411;
	Tue, 9 Sep 2025 09:14:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=WQ6Ww2rKo2Xh8yFEH
	pjFEkuRbeIAUa8m0xDumih+LEw=; b=NXExQpH1bXSAuqWdpIYOl6GhlmxcCwSz2
	IXWoq66QS+fsuO4+KhE6HuRhZwOUaI2umGBziJno8eu8VEyX7Rqj0mvvoGYI5voX
	TCZ/wcBT8/kBp3Hz3MbEkI6cvGu8jdAGOQQUrIWFw6/Vi29xi/UY9gB98Nmo/X0C
	lBSSJpEOlc6H1Ux+yR5FYq7u/oZw91CosxTryatO9XLlFy/qmWuYQEsps9d7MToM
	E5A5VDRgzUYciRV4wPzdC5oZ+dpg0NgQOpj25pW0SbV+2HcgXshSbwd+17XQF9Hh
	6yNxm06SZ8Up9TvtNBkSAQQsm11LNe15TmPrQOhUj0LDAaxHJ1A4g==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukebx28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:14:47 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5895iMFJ020492;
	Tue, 9 Sep 2025 09:14:47 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 490yp0tg41-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:14:47 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5899Ek5W35520982
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 09:14:46 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5039E58055;
	Tue,  9 Sep 2025 09:14:46 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 11F4658043;
	Tue,  9 Sep 2025 09:14:41 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.2.198])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 09:14:40 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        alexghiti@rivosinc.com, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v17 04/12] mm/page_table_check: Reinstate address parameter in [__]page_table_check_pmd[s]_set()
Date: Tue,  9 Sep 2025 19:13:27 +1000
Message-ID: <20250909091335.183439-5-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909091335.183439-1-ajd@linux.ibm.com>
References: <20250909091335.183439-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDE5NSBTYWx0ZWRfX4GhJVpm2shjG
 HQV7N+ibunsOvwX/95yjcTjaZ3UIZgk03xt/1P9pbpagE0cwDmQtQ/T7Ba5jzR+YYL6WLQvEww8
 xLI+UedZsL5eLgwBO4kkLUoCnfW4u22YaPjMk3Rp4CxYTbMMfToBuHRuPo17lMB/LHnQJYkfD71
 wo+fVb11PzfsYpOY8AePuiN0awPFvodU4pM0DdYnv+DYxByZ1a2SZ9W8NfUC2GTa3xpJ3DFiUnn
 g/WOqxazwFA5BOUa1VzfInQunWr+PfA/qcEVafCByzQJ1CDLVZEJPuUrYzFI2pXZDdQhWM3Dyyp
 6HmoxYUKgzbhkosY5Oceu1BZfrAV52l1uvwA09eRhBeLBUsg9jDjued2POrAwC6Q7aP0XaYRo2u
 RD01JPBn
X-Proofpoint-ORIG-GUID: ODVpmmO40ri_oG7Hx-KcEX8r7lrbOwML
X-Proofpoint-GUID: ODVpmmO40ri_oG7Hx-KcEX8r7lrbOwML
X-Authority-Analysis: v=2.4 cv=StCQ6OO0 c=1 sm=1 tr=0 ts=68bff007 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=VwQbUJbxAAAA:8
 a=h0uksLzaAAAA:8 a=-IAaNFHw-wEKn7DCNmAA:9 a=gpc5p9EgBqZVLdJeV_V1:22
 a=MSi_79tMYmZZG2gvAgS0:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060195
X-Stat-Signature: qghjwp1qnuss3t1tfbx9ownoz1ojjcud
X-Rspam-User: 
X-Rspamd-Queue-Id: 2584C40006
X-Rspamd-Server: rspam04
X-HE-Tag: 1757409293-511643
X-HE-Meta: U2FsdGVkX18UVPCPO7kZ28d42U0AfMdZeEi2sZW4FzcO5ENJeQpUi7nvpjEclV1yeNIJ+69pRY1hKHZQIM13HE5eQ23t9oC2URGtPRDxN2Ulx9Ol/K7OKQW5qNHRml32m6Q1QLCBDAaMbzEEq24smwz/HT++gdWCreR43G3cnvtm4lh3jJX6F4/6N8Yn6hAgBoFW2FwAxhDomxQ9KeE0J0ximo/BRVm+y3JLgEmRV659KdHWuKabgHNaChTXsvYXM3qqdtxI3do9SwLgHGom9ux5XJffMdGGhC17QqVp3vFLEhGT6a+qpIgGaBxQ7jGW0E4+x21acXHc37x3lIPSGbf/Ug9N/7i5pVwzYxa2oNhJ1epzs5z+K+GQaoWM1DDEjpc/RE+sua2k1LLAa5fe4cwqSQcK7To4WDrsxBwVB4PJicGrUbErD4s4fCU6RyzOoCBbZYB+0DW68z5WizkiE8mqAK6KuAh6CzS0yANGt5H8YMPJCtzq1RlXwdeHMPzCQdC2ZYscmlg9WatOkh8o+ICcFLAivKVd9O4OtIlwbokRZHx6Ph42dFzdQDGBCnBTOnrlJwwS96oi8JZL83Lsb+Wo2ImtWC/fO5CEh47lhwNrgVcMPSDoTKoTy4ImJzEZ3jZLpU2wkOAA+IV8PEdodyR2G9zs96mp+A9KJaS7cbL1Vrtsl7pVfgqb3KORCNzPloED7nrnIufSJg1qLpiDwpllPG7dDRqauXoc6p/cO/hIV6KvEX8QW4pA+i+QUBYuNzUC6Zf7+Hm9IynqvRCxQNXnuwCbVgFw7LbmOTsLTVZ6zFyUSyG2nSClqppqRNlkt64XQ96+oq+vkQPrW0bzgUnSB3L7Aj1SvImb1e50CUsplDJWlqXqzuf2QvDElXtS40cmWQlr1R64HFdtGl6bluwsIK0XQ9vcJbvVPqMhJ9A681iii2OZCt+2y23YLhgW4+axDKmu7U0SNnWTEmI
 2B1W3j+9
 SGI3911H10BO3HPMqYPjc6A2YVabtdbQ/aDcrD9OPgrvMZHqT11+dH0L424/GkvrFKJBKeeJTmQdkCwXv1tq/OW7scJtxZEv4AVaByjh3lBlAqKhhMaMJvhR9uuqL3R8Zp9vzs/E6Yhh4i1GO0IwDWxGnIVtYXe1mAuODt5y0QPc3/w6fiqcWQw3xSSATLApPPOGJm1rKcyIqsARiejiIFMy/sZCQ34C1LQMDPbemhf+6XM257PcvbjXf2NdUZ1jif2l0FYsitjrl5Q3RSg3eI75hCBnxWjz21GKrzwyc/sEpP4N6216PW+uN36Z2g4FHoL5xGAe2e8nGH/OmCPNRRSOrFtNxQi0Ek65eprtf40SypIGUsUaD65mkn8g+HVeU3AaIk5L2ROESAF3rnCxYPiFRlZSzWqUJhTUHjxthi5aOqP0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rohan McLure <rmclure@linux.ibm.com>

This reverts commit a3b837130b58 ("mm/page_table_check: remove unused
parameter in [__]page_table_check_pmd_set").

Reinstate previously unused parameters for the purpose of supporting
powerpc platforms, as many do not encode user/kernel ownership of the
page in the pte, but instead in the address of the access.

Apply this to __page_table_check_pmds_set(), page_table_check_pmd_set(), and
the page_table_check_pmd_set() wrapper macro.

[ajd@linux.ibm.com: rebase on arm64 + riscv changes, update commit message]
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Ingo Molnar <mingo@kernel.org>  # x86
Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
v13: remove inaccurate comment on riscv in the commit message
v14: rebase
v15: rebase, amend commit message
---
 arch/arm64/include/asm/pgtable.h |  5 +++--
 arch/riscv/include/asm/pgtable.h |  4 ++--
 arch/x86/include/asm/pgtable.h   |  4 ++--
 include/linux/page_table_check.h | 12 ++++++------
 mm/page_table_check.c            |  4 ++--
 5 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 8070b653c409..9fe3af8b4cad 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -709,7 +709,8 @@ static inline void __set_ptes_anysz(struct mm_struct *mm, unsigned long addr,
 		page_table_check_ptes_set(mm, ptep, pte, nr);
 		break;
 	case PMD_SIZE:
-		page_table_check_pmds_set(mm, (pmd_t *)ptep, pte_pmd(pte), nr);
+		page_table_check_pmds_set(mm, addr, (pmd_t *)ptep,
+					  pte_pmd(pte), nr);
 		break;
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SIZE:
@@ -1514,7 +1515,7 @@ static inline void pmdp_set_wrprotect(struct mm_struct *mm,
 static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
+	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
 	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
 }
 #endif
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 3a113c837605..98e56d4ff840 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -805,7 +805,7 @@ static inline pud_t pud_mkspecial(pud_t pud)
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 				pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(mm, pmdp, pmd);
+	page_table_check_pmd_set(mm, addr, pmdp, pmd);
 	return __set_pte_at(mm, (pte_t *)pmdp, pmd_pte(pmd));
 }
 
@@ -876,7 +876,7 @@ static inline void pmdp_set_wrprotect(struct mm_struct *mm,
 static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 				unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
+	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
 	return __pmd(atomic_long_xchg((atomic_long_t *)pmdp, pmd_val(pmd)));
 }
 
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 0603793acb3a..8ee301b16b50 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1213,7 +1213,7 @@ static inline pud_t native_local_pudp_get_and_clear(pud_t *pudp)
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(mm, pmdp, pmd);
+	page_table_check_pmd_set(mm, addr, pmdp, pmd);
 	set_pmd(pmdp, pmd);
 }
 
@@ -1356,7 +1356,7 @@ static inline void pmdp_set_wrprotect(struct mm_struct *mm,
 static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
+	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
 	if (IS_ENABLED(CONFIG_SMP)) {
 		return xchg(pmdp, pmd);
 	} else {
diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
index 0bf18b884a12..cf7c28d8d468 100644
--- a/include/linux/page_table_check.h
+++ b/include/linux/page_table_check.h
@@ -19,8 +19,8 @@ void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
 void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud);
 void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
 		unsigned int nr);
-void __page_table_check_pmds_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd,
-		unsigned int nr);
+void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
+		pmd_t *pmdp, pmd_t pmd, unsigned int nr);
 void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
 		pud_t *pudp, pud_t pud, unsigned int nr);
 void __page_table_check_pte_clear_range(struct mm_struct *mm,
@@ -77,12 +77,12 @@ static inline void page_table_check_ptes_set(struct mm_struct *mm,
 }
 
 static inline void page_table_check_pmds_set(struct mm_struct *mm,
-		pmd_t *pmdp, pmd_t pmd, unsigned int nr)
+		unsigned long addr, pmd_t *pmdp, pmd_t pmd, unsigned int nr)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pmds_set(mm, pmdp, pmd, nr);
+	__page_table_check_pmds_set(mm, addr, pmdp, pmd, nr);
 }
 
 static inline void page_table_check_puds_set(struct mm_struct *mm,
@@ -132,7 +132,7 @@ static inline void page_table_check_ptes_set(struct mm_struct *mm,
 }
 
 static inline void page_table_check_pmds_set(struct mm_struct *mm,
-		pmd_t *pmdp, pmd_t pmd, unsigned int nr)
+		unsigned long addr, pmd_t *pmdp, pmd_t pmd, unsigned int nr)
 {
 }
 
@@ -149,7 +149,7 @@ static inline void page_table_check_pte_clear_range(struct mm_struct *mm,
 
 #endif /* CONFIG_PAGE_TABLE_CHECK */
 
-#define page_table_check_pmd_set(mm, pmdp, pmd)	page_table_check_pmds_set(mm, pmdp, pmd, 1)
+#define page_table_check_pmd_set(mm, addr, pmdp, pmd)	page_table_check_pmds_set(mm, addr, pmdp, pmd, 1)
 #define page_table_check_pud_set(mm, addr, pudp, pud)	page_table_check_puds_set(mm, addr, pudp, pud, 1)
 
 #endif /* __LINUX_PAGE_TABLE_CHECK_H */
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 3c39e4375886..09258f2ad93f 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -218,8 +218,8 @@ static inline void page_table_check_pmd_flags(pmd_t pmd)
 		WARN_ON_ONCE(swap_cached_writable(pmd_to_swp_entry(pmd)));
 }
 
-void __page_table_check_pmds_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd,
-		unsigned int nr)
+void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
+		pmd_t *pmdp, pmd_t pmd, unsigned int nr)
 {
 	unsigned long stride = PMD_SIZE >> PAGE_SHIFT;
 	unsigned int i;
-- 
2.51.0


