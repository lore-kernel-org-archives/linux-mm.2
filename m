Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A806CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 06:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB59690003B; Wed, 13 Aug 2025 02:27:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5F5E8E01B6; Wed, 13 Aug 2025 02:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B170390003B; Wed, 13 Aug 2025 02:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9412B8E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:27:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 28AB314027F
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:27:36 +0000 (UTC)
X-FDA: 83770752912.14.7F70BC7
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf22.hostedemail.com (Postfix) with ESMTP id B4933C0006
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:27:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BJfVzY7Y;
	spf=pass (imf22.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755066453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XGjWwC8DsjlKdUQ75Q11xxG7CdoSaAxd3XXxKSB85s0=;
	b=lEzc3QYfPN5m6ELFwlNVH3P6lcpCy8tXZQCzai9ImRKvmWNSoG9E8nRCji43BX+EnQ+xqj
	DGo0pWMqlPdEi56nijQWbJUPJjD+WLKr/2eMT32C4VZaiYPr/Uu8NxtInlfCwONz7ZdXHS
	0lp/sr+l2SaIj9KvpXtewmiILp+goog=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BJfVzY7Y;
	spf=pass (imf22.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755066453; a=rsa-sha256;
	cv=none;
	b=Krf0jDb5q1vvB7kh6BCykPNjonVR33Ux+zZBnCCq1A9fETsnnUbD5EJ5PEAIq18oxQGwWm
	6CuNtTH3Qw2TXTutnWc1DTEree8XshxOkjsAoTLTMI/X+eQW4XyJeiWtxaqAwUo813v3K4
	kpC9w1hHBSkMWwIpgHLQKQoLXo5sGX0=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CNQNBc011178;
	Wed, 13 Aug 2025 06:27:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=XGjWwC8DsjlKdUQ75
	Q11xxG7CdoSaAxd3XXxKSB85s0=; b=BJfVzY7YThGQN04gBYF2Q5XI0SB+A5zvn
	mqIgjFvRBx/JnKmC1qRvw4J5PYOwG1oSSqx1k5hltXU+z24+FXa/1hYFfuQV6Fy8
	IRwLGjCsqPp4IiShPlN1gu1xjHUrI7Cd9bRaRFmJveHy2pJOhuYizsCMcB/QogI0
	tuz1KkTL6fZ6m4OR6fkCILtVSmnxHi4Y+X8Ou5+MZTZAilwSXmPebwUvN4KhoaPP
	5A5VRjsGOSPBCTtb4ssHtktzMVjEdFMuZO5n0SsunZ22HqIQII75taopqHc1XMo2
	6Mlxq3jy7mGO3Gleh7fyyTLXx6tE9Dl5gkaw7L5WwbEaQdfiCII3g==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx2d2wrd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:27:27 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57D4KB7D017637;
	Wed, 13 Aug 2025 06:27:27 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48ekc3np4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:27:27 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57D6RPwm28902074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 06:27:25 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5433B58059;
	Wed, 13 Aug 2025 06:27:25 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 97ED05805C;
	Wed, 13 Aug 2025 06:27:19 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.10.70])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 06:27:19 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        Rohan McLure <rmclure@linux.ibm.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v16 06/13] mm/page_table_check: Reinstate address parameter in [__]page_table_check_pud_clear()
Date: Wed, 13 Aug 2025 16:26:07 +1000
Message-ID: <20250813062614.51759-7-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250813062614.51759-1-ajd@linux.ibm.com>
References: <20250813062614.51759-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfX/U11dW4XDkcV
 Ilko5eelj/msHXxYke0wPyfFxl7nOm2GPvxCHsMKWonxI1Bnptg84VJhjJGLivaf7HMz5b0QKwb
 J9HO8rsTEYiUWAZZoDvbrC0B7Te1MkCwEGs3yYMfbbL1gxHqiVUr9uM7D1/X7PypgxUAf2duU2X
 8bZOD8reLVIR7YFZwKRt56rtWI7bOq9kZSSS8SF7Pbi0OfVYHtk2F4dYHM1ZgAp8ZorZ60dpN86
 zZe5QqQYwsAT0RvljasVFbl00CQDTNBEs/cJNgm/T1vkYnis/CoU3bnPIDRgvkh4RjfcVwtTA2o
 6hCbLbqDBImSE9OUp5ar4E1IuhTtfYfSg+8dIhvGomxi0gkbhA9jdPWWpocw2afnSVOigyNu9TX
 u6N3xAe6
X-Proofpoint-GUID: 4bMZSYD5l1TLPBAl5UMJ9hkYzUv7wGJI
X-Authority-Analysis: v=2.4 cv=C9zpyRP+ c=1 sm=1 tr=0 ts=689c3050 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=VwQbUJbxAAAA:8
 a=ocrGMPNeQj1hKc7Dx3AA:9 a=gpc5p9EgBqZVLdJeV_V1:22
X-Proofpoint-ORIG-GUID: 4bMZSYD5l1TLPBAl5UMJ9hkYzUv7wGJI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1011
 impostorscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508120224
X-Stat-Signature: j8m6uz67fgyqzx4i37mkz93kqw5tqau6
X-Rspam-User: 
X-Rspamd-Queue-Id: B4933C0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1755066453-659465
X-HE-Meta: U2FsdGVkX1/L0KkBNq1VEMqrSuMYMCy7cz2Pup3QkEeBuI8LzuIeFiOM9GoIt2mX3Kl2K279+co5Um/fhm/PlSxOye+Ewzb1OUe585en4D/238ZRJqGd8rKgTwKCPyHDNPty1lGmweuJRE/xLfmnWP53gcp1Flsdt+ZUONry+RBxAIuobJZL7NWBFQwBfA8nlLZqPj2CIiU41pk3bTNaIzVx4oa9Wey06DsCIBarjcyfPD/smTl31KZ/B603HSpp0/Brn9yl7SFGUxrpySws0F6/EZOaCIWkfqoouxWfxLm3QdLPNjvlXvHGeEgNNaOVQhXEVSprqqLDmw8FLt4JqFN1lfEGIKV272q4jIC1cbRPDzTFjT92F0XEaRqG9ynyga+7h88+3XK5rf/lpVD//qDaMyeojF+Tb/XhuoFoyDiaura7PGCcvoeayYsCq7NhIPo1ccavv2Qcrt19ONirrj/H5xmy4fDvqU3nrp+2U7E0dr9pXKssxwLdLSr0YuzzJLf0/+xNszRjUMP/7PHVN+iSW7aXDX+9yIqBo27vUozkHm0RN/2VbdjxCqz4YCNLc02HIIS6SAQMSPWN5awmz8UesxA9pGUN46oiVh8a95rutmjdzce+LoLG5tshxigca74SxGxHKCl3yNB4vXIwGyB+tqsbDJaw7hI0XkaRwVe3a8IOmyY29zMDDrfSbTQi+5e9RWVbHU2XDtxDaZ1G/gBah3qtOEYxQZ7gGq51C2pOffpCIlZ4t/zANUlewZ07SfH93lmE7huRko6R40YovtgAfAJ8ldF01VVXLXa5RakjuRyzzHGYJOrRxZxpiFaRw9CcDuVFXEefkvo57KeSjdltIMqX9nlA87t8c947Htk9BpTDzvSlulaFrLsk13ZsG8ANs1u6aDhgb37NXALYdr9Ffe796DzJ5ur2TW1UymoUbzDkmlmroxfwd2rWzISSQkIr6zMJ94DlEhu91N6
 UIOy90ph
 oLMnopqb201nyiUvVB78E6JdQIJpsbXqOJBfJYkZ0VL4E3nx4w9AXYRrs8XE/xUpYQ9waAhxUsKwiGvKVAACT5fwoDmHyeokFPmGkb1BW/zpWLB7LQk6axjmHLL3lbBijk09TsEgzgwcrHPJltmWaRK4hfcF3mY4zDxxGA16lkP/XCHWOfTNzeh1lJAkg1PaiAFg37SOui9gGa/BY2vHoAFQxDzDXsMsRXd37T2VUrbJe1v3kwE/DnpMV6iqpdgNowqgmBaAwN0LhCDLx7QFJ7CMS160aJgKCLfl8/sk1Owd1c31yHcENXf/77I+AW+0pscvMSsgZ0THUqi0MLKESdomxzW6Ru+eCiAG3xRnowvLIl93P2bkQtZmoF+32P1VOOsa1tzA8MqxstlsT7vOTlyiFd6MnemLWpt8QKFGkREXBtqkViuag5OACsCrU6UeXOGRRZSlCiFnE9ZE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rohan McLure <rmclure@linux.ibm.com>

This reverts commit 931c38e16499 ("mm/page_table_check: remove unused
parameter in [__]page_table_check_pud_clear").

Reinstate previously unused parameters for the purpose of supporting
powerpc platforms, as many do not encode user/kernel ownership of the
page in the pte, but instead in the address of the access.

[ajd@linux.ibm.com: rebase on arm64 changes]
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Ingo Molnar <mingo@kernel.org>  # x86
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
v15: rebase
---
 arch/arm64/include/asm/pgtable.h |  2 +-
 arch/x86/include/asm/pgtable.h   |  2 +-
 include/linux/page_table_check.h | 11 +++++++----
 include/linux/pgtable.h          |  2 +-
 mm/page_table_check.c            |  5 +++--
 5 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 06ea6a4f300b..81f06e5e32b2 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1374,7 +1374,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 		break;
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SIZE:
-		page_table_check_pud_clear(mm, pte_pud(pte));
+		page_table_check_pud_clear(mm, address, pte_pud(pte));
 		break;
 #endif
 	default:
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 8ee301b16b50..8b45e0c41923 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1329,7 +1329,7 @@ static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
 {
 	pud_t pud = native_pudp_get_and_clear(pudp);
 
-	page_table_check_pud_clear(mm, pud);
+	page_table_check_pud_clear(mm, addr, pud);
 
 	return pud;
 }
diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
index 66e109238416..808cc3a48c28 100644
--- a/include/linux/page_table_check.h
+++ b/include/linux/page_table_check.h
@@ -16,7 +16,8 @@ extern struct page_ext_operations page_table_check_ops;
 void __page_table_check_zero(struct page *page, unsigned int order);
 void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
 void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
-void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud);
+void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
+				  pud_t pud);
 void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
 		pte_t *ptep, pte_t pte, unsigned int nr);
 void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
@@ -59,12 +60,13 @@ static inline void page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
 	__page_table_check_pmd_clear(mm, pmd);
 }
 
-static inline void page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
+static inline void page_table_check_pud_clear(struct mm_struct *mm,
+					      unsigned long addr, pud_t pud)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_pud_clear(mm, pud);
+	__page_table_check_pud_clear(mm, addr, pud);
 }
 
 static inline void page_table_check_ptes_set(struct mm_struct *mm,
@@ -123,7 +125,8 @@ static inline void page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
 {
 }
 
-static inline void page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
+static inline void page_table_check_pud_clear(struct mm_struct *mm,
+					      unsigned long addr, pud_t pud)
 {
 }
 
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8aab3fa19c85..28fcff844b63 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -661,7 +661,7 @@ static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
 	pud_t pud = *pudp;
 
 	pud_clear(pudp);
-	page_table_check_pud_clear(mm, pud);
+	page_table_check_pud_clear(mm, address, pud);
 
 	return pud;
 }
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 0957767a2940..bd1242087a35 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -167,7 +167,8 @@ void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd)
 }
 EXPORT_SYMBOL(__page_table_check_pmd_clear);
 
-void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
+void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
+				  pud_t pud)
 {
 	if (&init_mm == mm)
 		return;
@@ -246,7 +247,7 @@ void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
 		return;
 
 	for (i = 0; i < nr; i++)
-		__page_table_check_pud_clear(mm, *(pudp + i));
+		__page_table_check_pud_clear(mm, addr + PUD_SIZE * i, *(pudp + i));
 	if (pud_user_accessible_page(pud))
 		page_table_check_set(pud_pfn(pud), stride * nr, pud_write(pud));
 }
-- 
2.50.1


