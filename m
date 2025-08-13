Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D05C9CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 06:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AB7190003D; Wed, 13 Aug 2025 02:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635248E01B6; Wed, 13 Aug 2025 02:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AFE290003D; Wed, 13 Aug 2025 02:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 310D98E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:27:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E6113160269
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:27:48 +0000 (UTC)
X-FDA: 83770753416.25.8385B29
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9925A40005
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:27:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QmmK9EIa;
	spf=pass (imf11.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755066466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0jDF8/FcA+VLViblYUPl3hG3I6GtOa7TybSvX9xp+w=;
	b=did4wFwxz9WZFxeTllB8heKrAsBmV6OVJPuPDv2hgxLVdMsxdZu9SZw8vbttnVW/q/Q8Tm
	nlDlNG6ET3s9cC+pHwLssomFMcjiEowMu9K+cU4hMrXtNmOMCvzRQM8W8b7Lh/IINe9FqH
	w7z5Xk186/r618XUWoNGwFF8arjt1s4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QmmK9EIa;
	spf=pass (imf11.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755066466; a=rsa-sha256;
	cv=none;
	b=e969AWXXbwFyBgKmYRD52xUJk7UF69W5wSZ7Fpar7QMErOH9dF7xBWNJ3HkFKIx8tllz6h
	9aVOoU+JVX5MaC2olJb49uKy//lY1uOUckZC8JEDhMpY0lXhLf9pTb4Y0W7yiSMP9vhJd3
	vBPNrxgtq7OE0JKplSkPXWXihbn1uEU=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CNQNMV011121;
	Wed, 13 Aug 2025 06:27:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=R0jDF8/FcA+VLVibl
	YUPl3hG3I6GtOa7TybSvX9xp+w=; b=QmmK9EIaD+UMOCpi+jH4Slswle/4iePHu
	IZUwoUTexk0PTb/X1XIfv0/n1NMV5uFL7Gswb/EPiMLHtKyi4HhnBd3WwizaWOtR
	/TarIKlDbOY+uSEgDay9N1IPwu+bIeJLB+f1EgzBI+hCPrmFoR4G33yGNcKUbo2t
	kjjwRH6crpMdoo3W8KpDygJNEJPVX7r84pkavi9ZGIIJ/HZroux0x488vt9IHB45
	dBPrYFZfQd4zItMftimaENRg4/4+t4tBs30LG8Ktmi3ZL+6BLjheu+TKGliHU34r
	hLSxvTjfThkVh+JRPGnamKRZRR2QWLkk+ZtMHDxROh9FvczpqTz4Q==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx2d2wrx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:27:41 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57D2q7PO020623;
	Wed, 13 Aug 2025 06:27:39 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48ehnpx0hk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:27:39 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57D6Rcbg852700
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 06:27:38 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 674BB58059;
	Wed, 13 Aug 2025 06:27:38 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F6FA58060;
	Wed, 13 Aug 2025 06:27:32 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.10.70])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 06:27:32 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        Rohan McLure <rmclure@linux.ibm.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v16 08/13] mm/page_table_check: Reinstate address parameter in [__]page_table_check_pte_clear()
Date: Wed, 13 Aug 2025 16:26:09 +1000
Message-ID: <20250813062614.51759-9-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250813062614.51759-1-ajd@linux.ibm.com>
References: <20250813062614.51759-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfX4WB+CUyV3SVe
 Wz0LeKZ8xw3ebnnNnR35lPgpSsY2aV0ZgzqQhniopc/Q3KNBvL/4NpinMkHnoUOzRP2LjfSPEDy
 vPJTu3dkn4rDm6JCtnbqtxyFWXK53cJiIkF2kwzcAZWLBS8PPfsP+TB1fUyU4sSGz/JhTpOW2Jq
 zC+9a+MQN0JWqTJWmkaJ3QcCPCkxJDTiXT34ejJn6SrjwbUJyZzhVDKVDmZDTTItigJ3UhOGULf
 ttVkQ77uGbI35tijrusnbqL9A1LCZsUav3jqrKUoFN+TF0QJJvSIkJMO+U823Dnjm+MP3yX/dXo
 NVbMt+vlp802vbilkmU+rVMx5LrKs/O24zMpo2aDhUj14cGwoB92TVqdBnyMvXG5om6y0Kgur+/
 Iiu58xqr
X-Proofpoint-GUID: uDu90Y-FUmHTmv8_5KWQvmXiCkeadxM2
X-Authority-Analysis: v=2.4 cv=C9zpyRP+ c=1 sm=1 tr=0 ts=689c305d cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=VwQbUJbxAAAA:8
 a=brIg1AGlUOEcU9TjG_MA:9 a=gpc5p9EgBqZVLdJeV_V1:22
X-Proofpoint-ORIG-GUID: uDu90Y-FUmHTmv8_5KWQvmXiCkeadxM2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508120224
X-Stat-Signature: y816r64pdhy4c4xm14ugyqd3b5t76wuf
X-Rspam-User: 
X-Rspamd-Queue-Id: 9925A40005
X-Rspamd-Server: rspam05
X-HE-Tag: 1755066466-305917
X-HE-Meta: U2FsdGVkX1/nzFZiaofc/TNMy7dZ3hOSi3NQmrax2LKGQ5W+CG3/7gcl9TYhGrgCuxxua86qQBBK2ps06ODyWq5CmAM2ETkjoLtm+g8yyHcP8rxvk75Bm/zjqdks4FXPOU4Y8p8dn7gRkgmI0hTB9tDMb1doxniZ/Ks+bIj81gqScLhR4aph7Rlxt21VoZ2QuR8CqeC1ORaPP7ZU7QO99sVJabKJ1y2tNO3iLBLFRAt+QbY+tdyRFUcVcXhxH046oS/7ySqP3MWGQHjeBS8il4WenW3Z4pAI7m23ilGI0PAbJmqR/3md43ovSteEG0jlORzkAVOD2CCw6KiVIoN4q2/dqK4lyk8IP5TXM29yZMnaL7FchYAcqIL7uxzm2/XIZQ4uwvR9Fg+q8cFvhrMyjJuuJwODAntPDLxafDq3SkY3AjSXOLjMKxhGmT0XU3nsFhRbEf6G8g6DBCAvSw5jU0QjgkpSD+cCUaU/yZOq0dgP3ldN0NFOlqpC1F+hiV5HvjVCzG4Mo6GxPk9ei5SGaGhCbrqigxBzjJaZTlmJEikTCqC68UKJ9Bcniyj8cS23CKCUR2wCLKgbUkyzldrUfR3D0r4Dh+3rNhrLzN+QmLOvmSxjX9IvArA89jy/puolmyV4gF/kh88kP1n9K6CCUPfMpD41AKkMhHrpDN5WmCyit73GEB6lcEculK8ezCu2XA+EQgIXs3xHbTngWSJlfPdBGqVa9rzPzC+JBz6S62CrJ+ttuLS5muQnywl7YeIlHLNTuZu38JSc6SshrW/sARIfUCEOBXdrwWMcMaVlmaKhdVH6EgTz9dr6/1POKr87XVMZwdmRngINbe2kDeErK3mHkg4iUkHWs+BnIMVVmlE/YMH18wMxZOeJMhY4s3vMQJTG3l2nOb4GsAPIWVkyhKjwT4I8P2OU05edMtqb1ZI44YCGgwe5GQN1ufv/XwubgjZX+vkJCfOP3AmlvI8
 zUdX1LZh
 QH3mLQO8D96PcsXzdFoROTiCavRs8/DnWYU19oYr6Gat8oVXkByBtnSxFtTlhcLW/S+Hu0vLmCiSvj8R8nKmYZvu1RXLeaWB0+D99RKTjw0MG4PeK8MKwUp81i85L0jS2kp4ebMwiYQybAr71DFcoW3T8at6oTZC7hcL1gmniDcDHHXZVeBuq2Mt0XVk1zAPmk5jArg5qZMkbaNADeKT5/HzaxJi3xBtJVHTHPv/Xm2Tn3Zwg8WpGjNe7N6EEWL+c/Ya/1yoSOjquk7hkgaRe9jst3L9LE8wR++ysxi8Dumzjg4lhpWtEYaaW67nkrfm3pSj2C+oXevwxhJVVOdPHgQr0eCVPBJ867PXAPmO4beYWWUpJN2TuHXv2mw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rohan McLure <rmclure@linux.ibm.com>

This reverts commit aa232204c468 ("mm/page_table_check: remove unused
parameter in [__]page_table_check_pte_clear").

Reinstate previously unused parameters for the purpose of supporting
powerpc platforms, as many do not encode user/kernel ownership of the
page in the pte, but instead in the address of the access.

[ajd@linux.ibm.com: rebase, fix additional occurrence and loop handling]
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Ingo Molnar <mingo@kernel.org>  # x86
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
v13: fix an additional occurrence
v15: rebase, fix loop handling
---
 arch/arm64/include/asm/pgtable.h |  2 +-
 arch/riscv/include/asm/pgtable.h |  2 +-
 arch/x86/include/asm/pgtable.h   |  4 ++--
 include/linux/page_table_check.h | 11 +++++++----
 include/linux/pgtable.h          |  4 ++--
 mm/page_table_check.c            |  7 ++++---
 6 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index dfcdf051b114..2203ebac81d9 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1367,7 +1367,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 
 	switch (pgsize) {
 	case PAGE_SIZE:
-		page_table_check_pte_clear(mm, pte);
+		page_table_check_pte_clear(mm, address, pte);
 		break;
 	case PMD_SIZE:
 		page_table_check_pmd_clear(mm, address, pte_pmd(pte));
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index d11fc6333606..d60e1604852d 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -591,7 +591,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 {
 	pte_t pte = __pte(atomic_long_xchg((atomic_long_t *)ptep, 0));
 
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, address, pte);
 
 	return pte;
 }
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index b68bea15f32d..63350b76c0c6 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1251,7 +1251,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
 				       pte_t *ptep)
 {
 	pte_t pte = native_ptep_get_and_clear(ptep);
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, addr, pte);
 	return pte;
 }
 
@@ -1267,7 +1267,7 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 		 * care about updates and native needs no locking
 		 */
 		pte = native_local_ptep_get_and_clear(ptep);
-		page_table_check_pte_clear(mm, pte);
+		page_table_check_pte_clear(mm, addr, pte);
 	} else {
 		pte = ptep_get_and_clear(mm, addr, ptep);
 	}
diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
index 3973b69ae294..12268a32e8be 100644
--- a/include/linux/page_table_check.h
+++ b/include/linux/page_table_check.h
@@ -14,7 +14,8 @@ extern struct static_key_true page_table_check_disabled;
 extern struct page_ext_operations page_table_check_ops;
 
 void __page_table_check_zero(struct page *page, unsigned int order);
-void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
+void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
+				  pte_t pte);
 void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
 				  pmd_t pmd);
 void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
@@ -45,12 +46,13 @@ static inline void page_table_check_free(struct page *page, unsigned int order)
 	__page_table_check_zero(page, order);
 }
 
-static inline void page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
+static inline void page_table_check_pte_clear(struct mm_struct *mm,
+					      unsigned long addr, pte_t pte)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pte_clear(mm, pte);
+	__page_table_check_pte_clear(mm, addr, pte);
 }
 
 static inline void page_table_check_pmd_clear(struct mm_struct *mm,
@@ -119,7 +121,8 @@ static inline void page_table_check_free(struct page *page, unsigned int order)
 {
 }
 
-static inline void page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
+static inline void page_table_check_pte_clear(struct mm_struct *mm,
+					      unsigned long addr, pte_t pte)
 {
 }
 
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index d97f40f1365d..c85e0e1c1f97 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -494,7 +494,7 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 {
 	pte_t pte = ptep_get(ptep);
 	pte_clear(mm, address, ptep);
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, address, pte);
 	return pte;
 }
 #endif
@@ -553,7 +553,7 @@ static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
 	 * No need for ptep_get_and_clear(): page table check doesn't care about
 	 * any bits that could have been set by HW concurrently.
 	 */
-	page_table_check_pte_clear(mm, pte);
+	page_table_check_pte_clear(mm, addr, pte);
 }
 
 #ifdef CONFIG_GUP_GET_PXX_LOW_HIGH
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index e8c26b616aed..1c33439b9c0b 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -145,7 +145,8 @@ void __page_table_check_zero(struct page *page, unsigned int order)
 	rcu_read_unlock();
 }
 
-void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte)
+void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
+				  pte_t pte)
 {
 	if (&init_mm == mm)
 		return;
@@ -206,7 +207,7 @@ void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
 	page_table_check_pte_flags(pte);
 
 	for (i = 0; i < nr; i++)
-		__page_table_check_pte_clear(mm, ptep_get(ptep + i));
+		__page_table_check_pte_clear(mm, addr + PAGE_SIZE * i, ptep_get(ptep + i));
 	if (pte_user_accessible_page(pte))
 		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
 }
@@ -268,7 +269,7 @@ void __page_table_check_pte_clear_range(struct mm_struct *mm,
 		if (WARN_ON(!ptep))
 			return;
 		for (i = 0; i < PTRS_PER_PTE; i++) {
-			__page_table_check_pte_clear(mm, ptep_get(ptep));
+			__page_table_check_pte_clear(mm, addr, ptep_get(ptep));
 			addr += PAGE_SIZE;
 			ptep++;
 		}
-- 
2.50.1


