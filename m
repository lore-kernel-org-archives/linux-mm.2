Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B15DCAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:15:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E67FF8E001B; Tue,  9 Sep 2025 05:15:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E18E38E0015; Tue,  9 Sep 2025 05:15:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08118E001B; Tue,  9 Sep 2025 05:15:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B87BE8E0015
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:15:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74C09140411
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:15:07 +0000 (UTC)
X-FDA: 83869152654.18.D321D54
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf28.hostedemail.com (Postfix) with ESMTP id 123DFC000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:15:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WnfV38HT;
	spf=pass (imf28.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757409305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=be921ar7cweaRepgQKmzxdr6CgNVTv+ifTaWzFG72G0=;
	b=sGs+XzvrfJ/Zs+fNZH1CVhRQ0fMCjREC/LL3DAZa3pToQtI6r8J+17PPuB87Iw8rQIFyS9
	2Be5LJOXT+35LkPMMgQfBss37wd6BdNZ8Wz59sfJYpK+Zn+KwA1lPNLabi/ciOM4uUb8YV
	qY6AOGw8k5ljJ4Y3vXDXlIFCa+oKzMU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757409305; a=rsa-sha256;
	cv=none;
	b=fGtGC7rt8LlSELh2ANQiXsZHQPTrdGIe5gv4Gwr5kOXvcDLw2uunIL07Ad938bgZQ45k26
	25RrENdiVJ/3G8DGX0d9G4VqwfWHWB4H7z1KVSi6CwiZhlaIfDULe6xAwLsjgBZ+peCBgZ
	XUh2g/3UD0wxl1SIDNL6Hxxkyb3tgP4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WnfV38HT;
	spf=pass (imf28.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588Mni09002811;
	Tue, 9 Sep 2025 09:14:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=be921ar7cweaRepgQ
	Kmzxdr6CgNVTv+ifTaWzFG72G0=; b=WnfV38HTOtr5IHSrUccBTu8IG9FFcOn7Q
	QtDAKzj2GFZ400wVwAma9KJECwXL/xB4vL/J2fzT8gEHJgmDt7xjntWPu8z+Fk/p
	BX5W0VWFTgqljzn6q4YJN3jRdIpQCzf5w4vMSK/t9gTw1TlukjXqbuC3YFk0+jTc
	/nIC0x4mgWJh1DFMSdUmZJmkmhjCNaBxhb2EAlfixvXNhO/tG8ydlO9YlN6IFUO3
	SF1ju41g3BipF25ClVxBI0SEamRJ2Cq55KYJstcpMD+77efD0zcQkzdYuMuv9POU
	8XlLliZ5f0fGDY42KtSV+bkDLo5U1QXCH007Oj+Y3JYQeMi5/j0OQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cff6sgp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:14:59 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5896t4ka010594;
	Tue, 9 Sep 2025 09:14:58 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4910smt9m5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 09 Sep 2025 09:14:58 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5899Ev7t30081696
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 9 Sep 2025 09:14:57 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C50458059;
	Tue,  9 Sep 2025 09:14:57 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 26B8358043;
	Tue,  9 Sep 2025 09:14:52 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.2.198])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  9 Sep 2025 09:14:51 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        alexghiti@rivosinc.com, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v17 06/12] mm/page_table_check: Reinstate address parameter in [__]page_table_check_pud_clear()
Date: Tue,  9 Sep 2025 19:13:29 +1000
Message-ID: <20250909091335.183439-7-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250909091335.183439-1-ajd@linux.ibm.com>
References: <20250909091335.183439-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JAsfxUR7OteBs7zZwHfgxz1WoC2vVI4f
X-Proofpoint-GUID: JAsfxUR7OteBs7zZwHfgxz1WoC2vVI4f
X-Authority-Analysis: v=2.4 cv=EYDIQOmC c=1 sm=1 tr=0 ts=68bff013 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=VwQbUJbxAAAA:8
 a=wZhGIaPSpsofiGV4ShsA:9 a=gpc5p9EgBqZVLdJeV_V1:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyMCBTYWx0ZWRfX2TO+cKFAPDTr
 cHn7VNjNlI0YRTxKU1WsldnMOEVv9/r7wTUWOvPlwvDXqLtkz7ttmtRrVVCsssXo9ObUen0XOY3
 S4Gtu51XwVfKfcYqpZpbGQGsg5To/Z6d6BHhkBduHe8uvDeHzEIhigSquh/Qc4uHWaLowAe8Ev0
 8aT+Lg53qPRy39tm0OJOFBywQT3CB7SQMQ161Xly7umQptdHDzBnKuH8Ezpxe64f2huyFGjK3oy
 3ucKYKY+PC4Vz3ndz0/tbZl4FAbxu3YCU7VoE+RHF7QdxSyV7zQQsrZgwlGsR+Hyq0I/KycCB0z
 2ctj8Fs1mNTlw9P5vveDdYQomzrchLOLPIRxdgn143PghXKHvwl7BX+ZGgznO7QBXzQ26ArGHNy
 yJyt/ug/
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1011 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060020
X-Stat-Signature: es3o5hpwxfufxhyd8xip4eg51ioe6oit
X-Rspamd-Queue-Id: 123DFC000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757409304-190068
X-HE-Meta: U2FsdGVkX18eTIU7Z/zDymUobdpfwfucJqsZ6vpxCX/DblFj/EKESdi2K1Gq1ZsiQsBcFjpRzdQ4h67TWLIb11O7t/CCfjxV/ZW02EiEDohe5ZlSLCKAhUFNV6Asnm2oG0yPkmCO3MQ6D03ufiqY+1Ue0QUzVDGtUNE7SxNbrHK/vuFPQcnCTkM6iUUVChhK50ggC8qHraqDtbNN1eGAqg1f+mcMa3ZccBPDv4umge1XUhwqTiaytDNMYHPz2E9Ht2VWFPw2NkQ30068yzlukrfP5CoNUq09ZoickeFqlUc3D+AAe/xTH069FQX3rRYRLE/iwgHaqM3KGS22Ps+h0mzfng6EbdlZT4fqOMdqJJoVDbzVUScrtGpPt/ptrE2mG90xMVqIdmIDAJLPePySbDbxqBh3uBiQDKEK3UR4OsD3fVxrbHxlLoF4GVp1P25Cf9dFMI9K/mhQQoE/sAv+8nbAOl7nzfhuTd9mkJUeHcRKMqJKh28vlm47mWkLUm1WmT+u6yB2l6cYj3OyROI2xUVu4Pa6E4O7zvQssgJqgVWeJhW2eb8XRup0IV2guHoI+UbBXn1hrjY6BAhLzzcFYoTQEUc7Ha6BkXK/LdJcikjSqs8YAHluOVt29z+nCrz6Kbj84M0QVC5QdMGg2lhkbF5yakttXqeT8HmGfkEnagPURcRhfBEvQv7bnPqARXT8Jz3UKYNc4tMLUmBaR+dooTGcebPFesou3UlfVEyGsZZOcUqkUTP3TdYVqGcMmND1audK7VfiaaSIbmFjtDVJGVIFmz9Pm4OJKFTcxn6JmtpDphhsbEsVigptVE3jPIodAwedLFDjbDFneAC30VYoTVnRyj0vAlVfCpzz6R7UIPDcr1VzY7KLCoaL+q6WBn06pixD/prGDbQ+c55G1GaX+8IYCFMZbxpxSIMUGq7anM7r8C7rBtGEOC8HeqHswDoOrZfHwWLW51sdiJyTY3E
 1Q+CYEDL
 TuJBgMXe6ST0+bEBUQCFg2GL77gukVd/o2sjiyD/tq/kAHLxyqJ/bp1SrzxWfvyR/RCj58K8lU1TGONVneZ0kXgL68nluXjpN2i61KfZ8FxUHzyreo0TjazYL487XUF+DUJzz+wTVQc/kMKBXPQv6JmzkXkQbqd+NZVWHqXFoS8pAX26xVocaOC6Z95lL2+gd3kGUA1oLqoItFjq8pHkbe3SDNPyYBQpWZ5I91KgG0t5t/XPPf8HD1jQnlCjwmtCqe8AmAsds5GSIQegrOSoXfODVlLzqYFxHc9hVWgh6DK9aC2kKR/SP3TVxu1ptg4chebgQyJ1JXOiYqG1lO8BpYTeyBCmSOeDnX5ZTgOzp3kQwlbMx8t7pVLcnNQ==
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
v17: rebase, fix conflict with riscv patch
---
 arch/arm64/include/asm/pgtable.h |  2 +-
 arch/riscv/include/asm/pgtable.h |  2 +-
 arch/x86/include/asm/pgtable.h   |  2 +-
 include/linux/page_table_check.h | 11 +++++++----
 include/linux/pgtable.h          |  2 +-
 mm/page_table_check.c            |  5 +++--
 6 files changed, 14 insertions(+), 10 deletions(-)

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
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index bef95776504d..3d152933eb99 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -948,7 +948,7 @@ static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
 {
 	pud_t pud = __pud(atomic_long_xchg((atomic_long_t *)pudp, 0));
 
-	page_table_check_pud_clear(mm, pud);
+	page_table_check_pud_clear(mm, address, pud);
 
 	return pud;
 }
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
index a422fdf31ffb..6d00d0948bf4 100644
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
2.51.0


