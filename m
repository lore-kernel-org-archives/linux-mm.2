Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57FA3C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 06:27:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8756900039; Wed, 13 Aug 2025 02:27:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18258E01B6; Wed, 13 Aug 2025 02:27:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB1BA900039; Wed, 13 Aug 2025 02:27:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A6CEF8E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:27:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 384D0116D7B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:27:24 +0000 (UTC)
X-FDA: 83770752408.23.FAB2096
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id CD3BD100004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:27:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=EHCPAT1f;
	spf=pass (imf05.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755066442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4/Ctvw1o/hFQJBWWTXNgAbNPCkcs2kP/YXaYRhFGjCA=;
	b=vjDLR3w2f1kiGo74T2t3idEcJ8doDN0MMqAG1OgFXrigXXlnTxpVgW3Q7k/n28pXun/wcZ
	NyiDU9PruBDLPXZa3uRu9rpBJCrXXJdxqEjtAa9wYeHX7DGxtATu3nda4E+kGFQerZj5yY
	bsULMwkYobfXSbV24PZZcpQnXR1o/XE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755066442; a=rsa-sha256;
	cv=none;
	b=IfqjbV/cBcus/fkhtY1a9ECf2p6HNWNpeG9ZxMGRCBiJ0moUji64co1uXQDmbj5tMb7mdZ
	mWdwQ+lyeEvCFSa6ktoF2JNX/QOhvL3RZW5HhERRmk1WSOgmpzM1PusmdrweVKRPlbXKAo
	O3N6VJXcVTuf9/5l9E2kEd7e/bb47x0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=EHCPAT1f;
	spf=pass (imf05.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CNQEdw029457;
	Wed, 13 Aug 2025 06:27:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=4/Ctvw1o/hFQJBWWT
	XNgAbNPCkcs2kP/YXaYRhFGjCA=; b=EHCPAT1f2fauwPtx/6zrJJMyUp0eIk2Y7
	hDQfBazzR0GwVvKBWmScRNueXvD9ynudxoLhPhCsWYaviLXRR4BmAXWwtWCQya4j
	7GUqQEVZ9NuWoKU7KZ2tvaVOuhAUWcO8p6eqn+B5E4fn5tufgQWPULlMsI6rQZAg
	y0nou+fOvRmjzpR4Ox+EZA4L4ptsYPdwFWv8kz9c0CaN3q63Cz3x5+PbbRz2MX/z
	ku/7CRXwcex6OlmIxkzs9h/OShkYCujhuTgidYprSEBMupUaHj8dX+SG30FhUn6/
	4SBx9+tp0s/ucZ/DjuLGEm46PIf0hCQCHxp2hONdWEOmG0cnm+eAA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dwudax2s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:27:15 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57D2Cmmm026282;
	Wed, 13 Aug 2025 06:27:14 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48eh21655h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:27:13 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57D6RCjh60490068
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 06:27:12 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A4475805C;
	Wed, 13 Aug 2025 06:27:12 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7AA4558059;
	Wed, 13 Aug 2025 06:27:06 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.10.70])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 06:27:06 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        Rohan McLure <rmclure@linux.ibm.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v16 04/13] mm/page_table_check: Reinstate address parameter in [__]page_table_check_pmd[s]_set()
Date: Wed, 13 Aug 2025 16:26:05 +1000
Message-ID: <20250813062614.51759-5-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250813062614.51759-1-ajd@linux.ibm.com>
References: <20250813062614.51759-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfX33uH2V/03q65
 WN1QqKQKPu+t/sNLO9adq6bh7J0+vOcFEjkPlxjNF7M7tg+moTlBMpS/c6j9AgpvgXUZ2MYtBIa
 GtFekt00DU+cohrUnti/7P5wmWPKnf75PmWN6ycJXo11JjLgJfvyvuKs/F0K+PXMgzFcTjebPdA
 5OqZpbwdlm8QhqyfRUahZcLCR7p4v6EmHoa3xnCixBaMM+Ji/JPDY34KQoxO1S6gNftzLTXfStr
 intARyZ3giZtscaglPA26hARl0XSFBdjwhiBZfXaF32KPpXgJLy7fBvhsJxHWdQN+Pqb/gSSAB4
 HYrf7sYrN8xaITkfpUvuz51i2leyAGqJnNpkyxwMHzhP4HHMaOjAN13K+mI0n5lZ3gDzwZIFD92
 QHXPggVK
X-Authority-Analysis: v=2.4 cv=d/31yQjE c=1 sm=1 tr=0 ts=689c3043 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=VwQbUJbxAAAA:8
 a=-IAaNFHw-wEKn7DCNmAA:9 a=gpc5p9EgBqZVLdJeV_V1:22
X-Proofpoint-GUID: ArK2hxIBNAN1bo7D-2Vwi9D3z4rGNP9E
X-Proofpoint-ORIG-GUID: ArK2hxIBNAN1bo7D-2Vwi9D3z4rGNP9E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508120224
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD3BD100004
X-Stat-Signature: k9pp99sy3rmmnkosr8gd13mnboapgpjx
X-HE-Tag: 1755066441-136299
X-HE-Meta: U2FsdGVkX1/V/E0B2PxWafH+UCDQ+zCD7BvWRV3zgFQH0tRKhTsRoHMukcpKTfG3ythXzVTUp3PWCnqL1sBvzj9pZPELrdKZRw8tPPxNpoq6IldeWbPtOdlReSDd+IDunwIptfU/pzD5VlRQ/Rk4wCbSLucnOc+WXD8x6+Ebz3Nn5seqkz4pSR4jzvyhWaISbY2SltfVmuI+ufv8nrhnVW9/YS+jchqaC/nhTiiXQ9a7L8S1VmatfbGIpj5tzMnn15zpqIa3Bmq7gZ3RqwShJIHEeDGzfv1jmp8ClfQE6Im4xtyiXAuKmFdHcXbuf5OETC0K5CefdrjNc5KYOsMsFUx/Cm5UfaGmyaZQ7ZyepNOCBJKAbXPam3qKekJOLpCEdxw9E4Q3MEuT/dgY137LvL3HEdLlyy/2ugGcrimwn8La1ER3GNO3dMEYrB6hDOvzsfZ7RQMB5Zjp7zQvjJKfIP3PXm3KjC5exlvOKKBDUJHUqOVkoTraZna1IVFiAXirXBeHfbI0clqpMM81waX3jotXIR9GS/rXdc9AChnCRGsHvAzLberPACUHdoQ/qGalE7tWLhCwvCTAE2Fexeaj1EQtp1qvvEHPUTa6ZwLW1CX1bE2OLjh1S1Bzx/vHLKiQLi/7XvWviGAtj+Fx0/c3mI3LdQyPS0IYKeekapXDfG7fxwGjSfKbSpiNl1HxlJ5sXEb/Jyt6VAFWqo2amzExhoBsHNR7W86jozlihi2exsOVjma7cbaMhwcAT7ltNl6tm5ZxbXqAFwmEyVKnI8JPMj+iLJcKLaJo960LzFxNnlBXndd9D54lkYGy2Hehd7WWte1WoHEa9xfLxjrYjI4+NsCRkFA9H2k1oCCXMpPXNgbReWc/W/wXRy0ZXnZjIGXqdmKCIt91DDEczHk+3UVO1BZcGeDFsQcXOkAMBHTGsyKsCQAetZhA/Zf4r+B+eiv84Q4lkb5o2ZmYdg9xzgt
 PO3Hn2G0
 6C31GTuMFar4bWMP4PTVTnGLFKd+Js11xQZK6DIqsmRAu9H2YRzcWTSRlSKATZoVE3niJk1uP5OA9QG0j/K+U7iy+V8Yf+REgSjDqs8PJFqIGKXhB5nuMz0F8o8MqpB2HEsJDkDBcuRd4FB5vA7ReIZVvpsQQDjjTzrBeYhPM1jPm/aH45QxOsBZwkG6l8ZEXOEtqn2KThLGo8RwNYlOHU72CO5QmTtc3DVenx3b8ENIrFqp8y5lyF3oeIOEoQlGwkeh87Z11MCXFWiTINyF49lKotZEzrmwQnsPHi2Q1Ey9mfiPfE37eMiMMxP52/3IJYRkxK7AJZR66YvXCm4mZCqmzcbEzEAXNyA01YX24HpMO/kPrdw/w/JSEJg==
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
index 3ed0f5e4879d..6e8c3d19f96a 100644
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
2.50.1


