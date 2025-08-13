Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D679CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 06:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80A0C900038; Wed, 13 Aug 2025 02:27:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 793748E01B6; Wed, 13 Aug 2025 02:27:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60D1A900038; Wed, 13 Aug 2025 02:27:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FEBA8E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:27:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01ADB137753
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:27:15 +0000 (UTC)
X-FDA: 83770752072.14.4FB93C8
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9DE971C000C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:27:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QgJGo+Rp;
	spf=pass (imf21.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755066433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oIsmqcd3sDRkkq4qG56OsvaByBlsBufNFhaaP9lIfV4=;
	b=1fwfk3TMGkKEA2HKMddoriMecq4di8Cw8+b1qBdVBLn70P5nMwM3bPHY10UrYiRANl1B6b
	/58UgUesFnnhHzxXCEtUqw78+evwHNn2ODB2sMfS9Ml7oeU9M+cD9o63v8tBumrU4quA7I
	bFh03aPmkP0eEjGDDjCNAnScXxNpZ/Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QgJGo+Rp;
	spf=pass (imf21.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755066433; a=rsa-sha256;
	cv=none;
	b=umn/BgDEcqzXeiz0NLnVJqFuv/Nc5lsT+Yk7Xkc+ruvyTKycD/tfwRBIJb8kjornhSV9jx
	t7dUDk+gNDb31heIgHX9XlT/YLarVvwRTpynSGBfaEvrc/rwY2L9946otGH+lADMupgSoo
	E2Cf0OyRsLzRQ/zC+H/GziWGkfG6nAQ=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CNQGr2029508;
	Wed, 13 Aug 2025 06:27:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=oIsmqcd3sDRkkq4qG
	56OsvaByBlsBufNFhaaP9lIfV4=; b=QgJGo+RpLD90tW8TTxsKcXR8Jg3husvxS
	RSuEIKr0RPCha8jDgj0G+JXOlQHpPZaYoqLCV/zFtIxyFPsqPlJb2NsqPtgDLANK
	ZtFtxQKyjqG/HSSDg77L6Fshd4HIoh3ipeQTfSjQrAnepNmdE0WT4d8GzU/rZFPM
	Yqd64CXfoQXuvsblfrVzq2b7SG+M/KhWQdJjLIe2AwmkKqWPmE5EN78gAY1J2Zaf
	i3157SVgSGa79onPTI7ea/v8ZGlq4pAcup7wsrCkVAl3Ma2phM2vT39DGC2I6taj
	LVUs0YNdZOR2rJ0lMw89Je4NXamDb3TrlTFJHEz4VfC4fSA4/1pHw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dwudax2j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:27:07 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57D4F4W6025623;
	Wed, 13 Aug 2025 06:27:07 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 48ejvmdsej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:27:07 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57D6R5xv33358476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 06:27:06 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A7E625805E;
	Wed, 13 Aug 2025 06:27:05 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CEF525805D;
	Wed, 13 Aug 2025 06:26:59 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.10.70])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 06:26:59 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        Rohan McLure <rmclure@linux.ibm.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v16 03/13] mm/page_table_check: Reinstate address parameter in [__]page_table_check_pud[s]_set()
Date: Wed, 13 Aug 2025 16:26:04 +1000
Message-ID: <20250813062614.51759-4-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250813062614.51759-1-ajd@linux.ibm.com>
References: <20250813062614.51759-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfX1Bggf8ydEAS0
 KVC14FBLkEXZVP3b/ZrT3pNjZAYt0IFbyOyw+dTnPqODTH6Q9I3+naEB/yNncAbhFhIaXAtJitd
 C8F5sD9kMRnTlptbFdPRdD4eaUd2BEtWUsiAFWXveefnbarOxE5RrlNQu6XHmf6De7xLKRe6zYr
 ZJ80nYf8frsUdayJ9NO2kE1H09mbh0jyV0E4sau7c+FEFgmQ5To82c49WUzq3FdxNkR12VFnlPa
 05T2CrctgxsjXgxG4GR2OKQvm6M5V20cve8ut/LI4KWZefkDxNzMgGSMmlSGVTktzlIz8+rt3w/
 kdr6AyprJFbJYpj7d3b5yJ8IbLcgJbOL6E18N7l7wNVQUCMG0ii+g9I899ln+3gbkU3M6LSKUUJ
 vDX3SqS3
X-Authority-Analysis: v=2.4 cv=d/31yQjE c=1 sm=1 tr=0 ts=689c303c cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=VwQbUJbxAAAA:8
 a=3Toew5EgkJ5X0DR0WCAA:9 a=gpc5p9EgBqZVLdJeV_V1:22
X-Proofpoint-GUID: PdA4B6wbDskCy3jQX6Huf3piNDjKdvlV
X-Proofpoint-ORIG-GUID: PdA4B6wbDskCy3jQX6Huf3piNDjKdvlV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508120224
X-Rspamd-Queue-Id: 9DE971C000C
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ucsdnpp8makkp9z7phe3rmijk7rafnjk
X-HE-Tag: 1755066433-786446
X-HE-Meta: U2FsdGVkX1/Rj/CfNFspu+0xG55N+6X+QkL3j+iAI2soD7Gza3B9PqRzwqb8o4nsyMgT0v94NfHbCl3KLdy5xMMMNsN9bXm4hthp0mKcES44PV1i/8RqNG5UXLjSPzrMmBax9XW41q8xPsxy36BwZGzNh0xVWki16h32yQPM3QfWmPHsq5RtnijqL//U9URte7zXs5JwkU2MZSgLmKHcmfgxPZwkn/0DrHQbeZFu6k263CZSzbDYvKwT0js+0k5IU+6/Mhf0eNSi1hpykCdsrpYwgDZ7mOJW1ZTzoYHP1eMc355F4tVEvipj2J6N7Zipuwa+wzFXiwGiXAQC+YmzkwdUqVgzwP8qsb6oAIOQ3qdCi3nxvncegSNib4EduxbzuJggqy3GhkJOZkuw7XzONe+VU/l1xZbTO37yeO0c/gJ4G150YwVNpDdG258VkZFcMNobeodL2KtqnxJNH0lqA0g8rOWU/z+1UKO2aZt3P7VAEGmn/8jGSS+FrXoHzCA5GN3Ol6bJU3mLeutlGrK58e8u14tJOeIAuuq6ZaaZsobJEdqvVFTbm2vA/SVlQDoE6c8woBA7ZO5mN9quCAWU1d8qou28zoJhb30G1Zs2MJRF3ZWydom2bvetp8QvRgiN6ygCi4E+y+FODBpVCq0hrMp59W8DPZVCPwpv7EyDbyyasFEPBsv4zR2XrtPJ9Id34kZFOB9wggFzXDo+SstRl5D+dI8j1qDuCE3sIURLoQIr1rJj+5HXFMg70Ou5Od+55k0WWiNIRvSCKr3mpyvxVtmBcwlQUWNsPIfUYz3x1RFjeAkxQCmM+jiYuWnCAHdjoQmzxqw/60PFu9Bl4bkO/1sst8aeiHvGrKNYnBzWGONszQn3Syf0bZf09lpzZX/5LRLtnUh+qHECPrk8IjpoVTslxa+rqFdOtG05p8r9U/AWiizaOHYVtddFwT4YgDUrsVp2jpZUmlUKAt88ev+
 Y0hEEehT
 MIePz3dXE6jMQmGrbJ+DGo3QRKkEc8LPLBFraEknKEA9jnmzs+FmqAgGuQENF3pARuhydJ82xyuxbt9OpSEMDuZs6nrrI1gDf3ej4DU94G/7pi01wan3BRMj1NtfnxKZnzN208YglTAQO/PwEjDxkbs7xZEN9+W3Bn923nyzoPiZ9DvbWS+VPW74JqjpOSAZmPyfx8WPE8h7nf5hv4ONCL/CzhmTaBFSPf3RCSwColWdir2y9CF88zc9e5MtTFblOndXl4MtnaXIrCGGAzhuJ2D52yGQ7Bc9BDVOaKI6T8H3115H66JCWnGXpGEfsQDjCGqt2Qy5ewtduinZvZqzQ5o/eoLD87jVUq87YuSAxVnIp8/f4NtSbQjZQkzktcFm2wt+7HT7pkxAAnZKW4P/MOjLPNHubmxdK53wtgXS0+4MBENY8vMnSMmdWsn30RF4JX/LEnLFsTSKJ11Y=
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
index 91697fbf1f90..3ed0f5e4879d 100644
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
 
@@ -958,7 +958,7 @@ static inline void update_mmu_cache_pud(struct vm_area_struct *vma,
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
2.50.1


