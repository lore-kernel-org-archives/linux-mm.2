Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B4F1D6E2BD
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FFE06B009B; Thu, 18 Dec 2025 12:10:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69CD66B009D; Thu, 18 Dec 2025 12:10:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 574EA6B009E; Thu, 18 Dec 2025 12:10:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4508F6B009B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:10:55 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F37F1399B1
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:10:55 +0000 (UTC)
X-FDA: 84233231670.12.168095E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5398640009
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:10:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=i3MeOG1U;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf12.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766077852; a=rsa-sha256;
	cv=none;
	b=d9AdKQz/vNR6p9wGAODdqEnpOyT7woNHX7eCoHG3UQFgePyNUGq7FntYUrLlNAPvBcii2E
	dZfTWnI0rITaVYWR51DQPjYI9eWeJupyr801bkqLOPDm7naeGX35J4OZ9XqTkphcWFLOiy
	uPtFlfHKX9KF7y4lRf0bnqE90rIxgEY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=i3MeOG1U;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf12.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766077852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w7SxODZinRpb+PXVtzo/W4dA98D5r3KELUST5oLOhUs=;
	b=21TMO8WVED4EZUu7qwrsLCNY88QZaoczOTWy/Dyllg/PwCLevNjlaZTZLs3PdiZZj8JNKc
	uR0/rZWFYG46RSOTXgUcC8NZD5+pY+1WCn0uckS9P66nhhScuDkWkyTlvWWB9t2rSA9lvU
	xrXPbI0f+K9LMZgIVS/8Fn0d2sRaroM=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIBsbrj010214;
	Thu, 18 Dec 2025 17:10:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=w7SxOD
	ZinRpb+PXVtzo/W4dA98D5r3KELUST5oLOhUs=; b=i3MeOG1Ue0DhqnfB6GPjMP
	oSv+Wk8dMU5NrbvOoYKbnjSn3uxHYoDkbehXC1gM9gOSwAzZmKCalwoF/y5lLsan
	xwPf74TXhv3BwVoVKy4beWzMJrV+/OZXZ5/a+t/f3IoHV68dBjeQgqkJqjmiMXNX
	I+841iLZlKB83+7tEAEImUSItgMf1OySXsr9J+0dRLLjRPG6267xZmExY+4rAZDM
	3XPzSC1cg+fdkFDLYczuG4HqlgCefPKnkNHOMn/ijL8twnrSsT2WluW0NWW3y1/q
	oDr0FzLHOXdt4vAsNs8nb4HbB24lf6LVKkLpZdhdNndCTA1cuufmrR8WFckAYkrQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0wjqb7qx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:46 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BIGwwWS008341;
	Thu, 18 Dec 2025 17:10:46 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0wjqb7qu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:46 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIG5mjf005806;
	Thu, 18 Dec 2025 17:10:45 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b1tgp87bq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:45 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BIHAhvU14353100
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 17:10:43 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6FD5058056;
	Thu, 18 Dec 2025 17:10:43 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A9D885803F;
	Thu, 18 Dec 2025 17:10:36 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.36.16.51])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Dec 2025 17:10:36 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Fri, 19 Dec 2025 04:09:39 +1100
Subject: [PATCH v18 07/12] mm/page_table_check: Reinstate address parameter
 in [__]page_table_check_pmd_clear()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-pgtable_check_v18rebase-v18-7-755bc151a50b@linux.ibm.com>
References: <20251219-pgtable_check_v18rebase-v18-0-755bc151a50b@linux.ibm.com>
In-Reply-To: <20251219-pgtable_check_v18rebase-v18-0-755bc151a50b@linux.ibm.com>
To: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>, Rohan McLure <rmclure@nvidia.com>,
        Christophe Leroy <chleroy@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, x86@kernel.org,
        Nicholas Miehlbradt <nicholas@linux.ibm.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Andrew Donnellan <andrew+kernel@donnellan.id.au>,
        Srish Srinivasan <ssrish@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
X-Mailer: b4 0.14.2
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAwMSBTYWx0ZWRfX6nzb5F/ecAh3
 OYnrq9MXuDzCuEGNNoMDOUHhF5ohGm1/Hc39kCYvO7mHvjHbgJPxKOxiR2rtJMWVdKCT8ICWTK+
 +SR40QSSXOya81NkHabCeHF4iE/RKMcFVzu1EbB2WHGn1koSKCiBtBP/4l/ByGgiy6xRxEq2rep
 uJ2TebIef/jriATzkwum+eIki8L1QK8KvcxUd/RWbKQMXofY1pXLeeXdSpckEMBLvpcvdlB0Leu
 UzDAi8GIs1EGJyr9hgffuto3eh+cEgklKiNpl046zCEyWDDXJ099kXiYTOgzERwlXbUpy9wC6W6
 80nBqQ3XljUuy5Bvg/b7vh4id5tzKFxKgLXtD6Om98KWndsemSBx1CbzDoQIWvthEuEcTcC5sbi
 olFsB/Ownxoq4MY9hPdiCUuv66+BZA==
X-Proofpoint-GUID: Ml2_IOzzqc_MRwukIXizwUJtmUrzG69k
X-Proofpoint-ORIG-GUID: 9FUVujqksekBXWEyUzlZ5obvyeQkd3mK
X-Authority-Analysis: v=2.4 cv=Kq5AGGWN c=1 sm=1 tr=0 ts=69443597 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=VwQbUJbxAAAA:8 a=h0uksLzaAAAA:8
 a=wZhGIaPSpsofiGV4ShsA:9 a=QEXdDO2ut3YA:10 a=gpc5p9EgBqZVLdJeV_V1:22
 a=MSi_79tMYmZZG2gvAgS0:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 impostorscore=0 clxscore=1015 spamscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130001
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5398640009
X-Stat-Signature: zzhwbdfmnxdcdzzxu9k8q385wh68pwn3
X-Rspam-User: 
X-HE-Tag: 1766077852-398111
X-HE-Meta: U2FsdGVkX1/tC6cSZjfvQjBBBypGFyjv1eyK93JuvUUBJIjtAU5MrTjblZj62g3f4BdAgKgmRUMAobIIcb9PKkAmZ5cHjq74PSmeGetK9L+AdVitzA1zlAHO5jRGBPxgWC9axKIqAnAiR+ABb0AsqBSO3xPA8Fjfl+v+gm4/9CJ927m16b39qrC3Bn5Qx+lZ7tgqu1jiIumHwsUTch7fasOeMa5VatzFFScYb3d3UlaKgu00mWJpvdOK63z3qsz7/MpvXQ5TIHZKcipSBFIjxqR454yTvBx1q2zJxWnqf4AhjsNkmQdT5wo+ZTx7O3fyZVrE2E4eRs3JFkRePDYSLbIWEhcMm34+8eHDbxuIQiyZ9KMuSP5v190czLF9QxrvIx8HjVYcYY9gxpfV1sqs/lyKC/wPT235Wh//7cCSR8OsDUbzHKGJwQoW29cIqs8agQCCnYB/+WOZ7CKKXpXGbMre2D900mOS/rgQbSdhFVLJ+bQDaUkgFr1QkEBMVe1W0JQlVIMfMxkLzwConLuRyoo2HTj9eNr48Yk4vE5t+OIza596LrjCzOcHn0oVwl8HUiIzaFJHtPjoFCWDVoZIbWKhtdHNz3zvHAeOrt/i3mIvNtAzK49oh23pylouDo1fa74U/npzSX+kBoTtVjEW7m9ngmE0NdnkMcXE64+LU3ofg/wMgTPSqS1PHMSBZytP0eqT/8MArxjV5mpvqwG/W8Bj0ceVXc8RrnFoGqzoPKpxBtHGCo3aFMDGjZFEh4pSKT/yYstmi2gNxRhbLjY9eJGgc/0C3265U6gJvJnV6sQUg7ImwpIvR2W8Z7kKI4bhiiJPD3j46teYZk5rp6igRdfl6hzDmCuFrEbnAIvwkWQ/LiAnmH5b5wQW1iMc9KMRhUARSHJW7qGY1VkEIaLsZI/N6MAsp8JmjAcaw+ZMUvn+Mvkl1TX+IS7E7KEHifVEQ4eHIfWfyA+sPr2vhUh
 M4u8KfMg
 EftYtIoV33INbYhyFTK4XKQ6A7xaD6FH2ZubDsqiCh090POLbUZTJTPU9DWe6BR6Jd2aHnXtE14hWw0vX8HJwTWYAlC1Z3HoGTmqTU5SQI8wS5y2sR91IAdkpZk1Ha6RO4I9nh7mAVqqf8rINsYZC0GeJTiXyM0HxLibbQNh00Sq0AFvNLhMP7DtlswKum86srMdMFHXCpyi1L/3cCsZ6iYSvg8q6W8n6KNVx6eKuFaNKmj5pw3/+vtcl6EJnvsq6rfA9VOVv2iStTTJ7A9K1bnZZ0+zFQkD2isZ7giCpT1/jvgiXrio/nj60lSMlaPGDpC9tg1pOk3m0rREr7Fotji4+eX4f7NOnFMY+rQiMGQkEIoAeomkDk1d2QK91UYbPEq34ZbYD9QGxcMjYFPLdVgHxargHyuEXiG2oAzxsiUDmWWu0wr4/9RyldTVJ1cuExybPcbthHz92fJm3qWCJI5FRmqRyqGvmPFNKksut6Dwp7i7TGgbbXJi6qsOgsZDcYiE65RA/xMMUHAx0f08bDEq0BF7vfZRi9hT7soo310kwcfPoQprPn6nNB7VKRRcWx3jr
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
index 595405e6bfc736f2824a9c2e8784351f15ad0571..5abad90913eb8b0a3aa867cd5a66107bbf96e177 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1345,7 +1345,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 		page_table_check_pte_clear(mm, pte);
 		break;
 	case PMD_SIZE:
-		page_table_check_pmd_clear(mm, pte_pmd(pte));
+		page_table_check_pmd_clear(mm, address, pte_pmd(pte));
 		break;
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SIZE:
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 841494ef46ee6ae1410f420dc7d0a99c4e1958cf..f179970fe47d333565a9199e0991e806aed44346 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -999,7 +999,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 {
 	pmd_t pmd = __pmd(atomic_long_xchg((atomic_long_t *)pmdp, 0));
 
-	page_table_check_pmd_clear(mm, pmd);
+	page_table_check_pmd_clear(mm, address, pmd);
 
 	return pmd;
 }
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 3eb36a36058face6aba92efe3eed7214752e751f..5a2b2d3a80d83d8eff2c1a6f69df3e80590c684a 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1319,7 +1319,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm, unsigned long
 {
 	pmd_t pmd = native_pmdp_get_and_clear(pmdp);
 
-	page_table_check_pmd_clear(mm, pmd);
+	page_table_check_pmd_clear(mm, addr, pmd);
 
 	return pmd;
 }
diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
index 808cc3a48c28fcf988ba2c50031fa4f317496582..3973b69ae294e501a9c6c3140bc462d6d9b7d203 100644
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
index ed3c28ebeb35b766418abdefa5cc6604c0533479..2d1f7369624c504b531beb8965e7352770a5f4bc 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -788,7 +788,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 	pmd_t pmd = *pmdp;
 
 	pmd_clear(pmdp);
-	page_table_check_pmd_clear(mm, pmd);
+	page_table_check_pmd_clear(mm, address, pmd);
 
 	return pmd;
 }
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 2295bc9368ab9cc827ee671ff9abf18a6b738172..e8280b0b6dda97ee68bb52593df454665bac9acf 100644
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
@@ -238,7 +239,7 @@ void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
 	page_table_check_pmd_flags(pmd);
 
 	for (i = 0; i < nr; i++)
-		__page_table_check_pmd_clear(mm, *(pmdp + i));
+		__page_table_check_pmd_clear(mm, addr + PMD_SIZE * i, *(pmdp + i));
 	if (pmd_user_accessible_page(pmd))
 		page_table_check_set(pmd_pfn(pmd), stride * nr, pmd_write(pmd));
 }

-- 
2.52.0


