Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92A44D6E2BD
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 002AA6B0088; Thu, 18 Dec 2025 12:11:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18C16B009F; Thu, 18 Dec 2025 12:11:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24926B00A0; Thu, 18 Dec 2025 12:11:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D26776B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:11:08 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9BDBFB692D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:11:08 +0000 (UTC)
X-FDA: 84233232216.10.C7183AB
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1F01C10000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:11:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RioGV1Of;
	spf=pass (imf14.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766077866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7p2lwupu5j3608FpKmz/mAGFneBtiD2A4y4KpzHGNBI=;
	b=AwfbheneZmq5zgJ8P4xnf7Y94y1m/4IPUjwxrxTb0HS3ePRlns+faFxZCgH/TUn55ySvQ0
	2ZnLPVUeI9HrTzszdeagYJKlZKLaDGAFnL0eTKNOHvSNDWQssML7LcsAr+m8ZcnmdwhxXw
	FijFXF/yQ81crizZXHGrfV6aHM+ec0g=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RioGV1Of;
	spf=pass (imf14.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766077866; a=rsa-sha256;
	cv=none;
	b=5Mb/1nbTblNdrQVJhj+GMGQJ4P9SuIdoGyt7YBu4jYBKQu7E13bM6gkREShnA42ABEv7uN
	WVS+sE+2FkQNq7DpdKdlOfEiDW6B/ZGdqAf6lYh+XoIi/qAgjdqJ+NMxqLteOa91ak82rV
	zjfaOGrlwY3/BAllzzmV58HhRHrD0r0=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIAT1hV020205;
	Thu, 18 Dec 2025 17:11:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=7p2lwu
	pu5j3608FpKmz/mAGFneBtiD2A4y4KpzHGNBI=; b=RioGV1OfR1nh3sHp4n7rDH
	rN1OuMIj9PDATswFfqfGxf/P5mI/viSbYQD/ya/9n872tAbKaHTMDmR5K5/Xxxqz
	L3VkWJYEWv2nUoclWZNjfUE21BkHqm4/WOPG7ui8NCw6tp8eWYu0O5OUb1w5Wesy
	zVRiCMR7KOzgp1qCcFWTrm2CoiW8DJGeVnox5Ixp42FE4NXMifo5KM6vrqMelPIH
	p9RblM1lEDaGbKXw3fbFRMT3P1V8gr0A0V4BmdSaZsAtgelzt9T1WtZCcMyDbA0S
	fmdHpGmJmcWObaX4OowrO0h20F4dn7rXBXlF+HTDZ9AdMOFJACmlMD5TNoE9oitQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0ytvkvau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:11:00 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BIH3fxq021273;
	Thu, 18 Dec 2025 17:11:00 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0ytvkvar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:11:00 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIFhmLk005675;
	Thu, 18 Dec 2025 17:10:59 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b1tgp87cy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:59 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BIHAwN13277366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 17:10:58 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1890D58060;
	Thu, 18 Dec 2025 17:10:58 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 20A5B5805A;
	Thu, 18 Dec 2025 17:10:51 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.36.16.51])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Dec 2025 17:10:50 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Fri, 19 Dec 2025 04:09:41 +1100
Subject: [PATCH v18 09/12] mm: Provide address parameter to
 p{te,md,ud}_user_accessible_page()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-pgtable_check_v18rebase-v18-9-755bc151a50b@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAyMyBTYWx0ZWRfX1cVkpoWOeZYE
 DokomB1+sdlsUuZWa1+3iUxRCfqwrvEa6FP6NbktHC8XGxkHBTbgN0TNUNC4KPPcpcbHfQK1hyU
 K/JVcI5gKeUdbLkYCQIy+xJGlHX8DijpwPxHIGDV98HADHR/E67UWMV3tR/uy1WJoSxq+RSEE6u
 Ibt2l/m4hCAcnIkm19XwKM/mGh9yw1C/9IyW8Fn3F3fy4N5YGgkiAYPV9qxLO9K5UgLnKh6p6BZ
 jxXMtnQCr35dpxLRLZnVJ2VeP8jBFiX/CisFJeoMLPHxWIb/WaAJjJ4xQ1vcv1nFnzCvL+GCZz3
 oZZsIV7pWR1AfU2Wwv4w+8kwuarxSdycr0nl0PKTa3QYeOASrUCakPmP2byTCHeSPkuzjK3I67l
 hZjNUZfMKVW0+cI/rqravmRCwwfI3A==
X-Proofpoint-ORIG-GUID: ZVHISN6Q6_9lkC5i5eJGjtx-INzUHIWa
X-Authority-Analysis: v=2.4 cv=QtRTHFyd c=1 sm=1 tr=0 ts=694435a4 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=VwQbUJbxAAAA:8 a=h0uksLzaAAAA:8
 a=r_0qNQ7kh5zYcWNfr5sA:9 a=QEXdDO2ut3YA:10 a=gpc5p9EgBqZVLdJeV_V1:22
 a=MSi_79tMYmZZG2gvAgS0:22
X-Proofpoint-GUID: BHPDTKUXdrxY8psOcH4kXyd6KMPwwmrQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130023
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1F01C10000E
X-Stat-Signature: 4ahqnpujnzsrb49r8169o3sc9dr9tt1x
X-HE-Tag: 1766077865-71087
X-HE-Meta: U2FsdGVkX1/ndNYut5/+Jzy3QqRa/Y7lASFmQXBfddl0Cc6J+ET8vhcLJ/ycB4XBX+j8oBIZFF41ih1P6umicOcYfCykmDK/qDW4+WMEaxwSH9GA6zSjWeDmFDbhMypexnAJfUy0m6vydGXrs9lZfJzKZbMgzKJb8rlxIGM2OrriJOQHbNmi7ITXQgS8d69wV94TlX1OMh9IbH+EUWZjQdBFEvUDTouhyK0uIB70SWCUaMzyhlxU5Y7NE/nCX0a0KGhj4GcKldSIIjSlR9RdWt4lPzkGJK6rjh9nQ9YLubgR9kZmmv81TU0ikng89AyS0rcXenIZ2eDFC7i5HOLS9Rr0BeA1XSm05C++tP/6g97cakOHnhd0+GMLiZ/UV+44WR2p1yNHitDduYd34yW823v0cUTIGYe6LT2NMt1pwrXKvOGjLmbnA3t4CtDjXXn8Rdfyo2ZJkwpO6qfa9tRxLwv1sivCSSzvrgzLkSCy11kNF1UDlT/7lmTzTnL2GG4UbOVv2daERl8npn7g35XLZUH40ZeQsb2PDTmQ4Gc6gyhP2Bq9IS/cfn6R9u3P3zFmzkmCc++qIPIfVLCN5CYfRhJN4OsPIa/XMxFWh6HFrudyfcJtNJ4dbgeKCHI19P96X78p41VHyDfkw6UWWRxoPLq2Jl3Jj4j8nt/SIhtXzDWBlxirXL87w/0saij+bfeEBV3LyIciz/XeDov8a4VweWXSCygmmEegAvSSNMhxEkpKgT+WPhYQl9aSu8Q6i7D4O+v/VumZO0uDN9hGFcsfCcAiBBNUKwisQZQeSubWITFQklloFqz6XTHlm0jcu/xzf9WuB2l0DympPRkIre/IAdvD0fm6HY+oOSwn2EsE6mT4PjKZtWrtMjZpfl6Pq2EXIwH2a8Ix5jqyhgkqlh5bk3NPz7i0sV/xPXhz1P6uJMP5EyfDDFHswLZAzwr0RP3m6sjUWkis9uMDDc42A45
 7yaam1+B
 1ZfDuxtd6EokdaCI9pWohTpjIg4oI55FvKGDYgAUJEmyKP+kKUwMJxkvE86zwMJDi5RHXH8zitYyyi5abtNwQRuKOq78x51WHyuZtF9MpmGzMnVUNdfIs3GeiLJ808WPUrjjgN0LGBsJNYO5jERGzrehoVnOW03KOpXBE83spI7pBryNepN4zahVjD/hwOZLmEepVI0Y0YyZRuEGpR/9jiPGJk7mM3LJL/LATVq6Ss+cpiH2W+t0wUjjk5sBpQacEcvweRUTNRbe3Ab/Mp/muRWlvtgP3fdJ5bxWZREATXl3SIN85eteJ19+S7EJvSkfGmYCT2lbjQCSG5wMQAUK51lpdN5xXU7a3r6Ge83GDychsyIit9PiQrjB+quIAFgGiiNQ9OhedfXDIMPN7o4LVq/zxtid/pQByuSq88ZVCkZiu3YhOGcD1WRIcHERiCGHNmMdfqKRIhPW5pjeG9LinZM32VqlIzeWnf8DnRXCsJ7aqnI/67JfjL4lPFFOgg4CN3BKVjk5TdLLbVIMIs0znP1qSQvkHRmkKfkla9sHyUSdJ2z+OooQ0Iio2S0qkjvKjHbYW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rohan McLure <rmclure@linux.ibm.com>

On several powerpc platforms, a page table entry may not imply whether
the relevant mapping is for userspace or kernelspace. Instead, such
platforms infer this by the address which is being accessed.

Add an additional address argument to each of these routines in order to
provide support for page table check on powerpc.

[ajd@linux.ibm.com: rebase on arm64 changes]
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Ingo Molnar <mingo@kernel.org>  # x86
Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
v15: rebase
---
 arch/arm64/include/asm/pgtable.h |  6 +++---
 arch/riscv/include/asm/pgtable.h |  6 +++---
 arch/x86/include/asm/pgtable.h   |  6 +++---
 mm/page_table_check.c            | 12 ++++++------
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index ce64c560e284e1c2ff9d698cf868070ed58ba045..d94445b4f3dfafcda88c7953a84228d39f788f3a 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1265,17 +1265,17 @@ static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
 #endif
 
 #ifdef CONFIG_PAGE_TABLE_CHECK
-static inline bool pte_user_accessible_page(pte_t pte)
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
 {
 	return pte_valid(pte) && (pte_user(pte) || pte_user_exec(pte));
 }
 
-static inline bool pmd_user_accessible_page(pmd_t pmd)
+static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long addr)
 {
 	return pmd_valid(pmd) && !pmd_table(pmd) && (pmd_user(pmd) || pmd_user_exec(pmd));
 }
 
-static inline bool pud_user_accessible_page(pud_t pud)
+static inline bool pud_user_accessible_page(pud_t pud, unsigned long addr)
 {
 	return pud_valid(pud) && !pud_table(pud) && (pud_user(pud) || pud_user_exec(pud));
 }
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 9af5bfc780800fe2f974daa5329277c46877f848..e38da3f9908fbd32ccb27a4f95c049dc2ae705dc 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -956,17 +956,17 @@ static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 }
 
 #ifdef CONFIG_PAGE_TABLE_CHECK
-static inline bool pte_user_accessible_page(pte_t pte)
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
 {
 	return pte_present(pte) && pte_user(pte);
 }
 
-static inline bool pmd_user_accessible_page(pmd_t pmd)
+static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long addr)
 {
 	return pmd_leaf(pmd) && pmd_user(pmd);
 }
 
-static inline bool pud_user_accessible_page(pud_t pud)
+static inline bool pud_user_accessible_page(pud_t pud, unsigned long addr)
 {
 	return pud_leaf(pud) && pud_user(pud);
 }
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 6ec6cf7ad2d4d92da7d3396bc96a5b5902e81576..1662c5a8f445f58c62e7364040d13b5958347818 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1680,17 +1680,17 @@ static inline bool arch_has_hw_nonleaf_pmd_young(void)
 #endif
 
 #ifdef CONFIG_PAGE_TABLE_CHECK
-static inline bool pte_user_accessible_page(pte_t pte)
+static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
 {
 	return (pte_val(pte) & _PAGE_PRESENT) && (pte_val(pte) & _PAGE_USER);
 }
 
-static inline bool pmd_user_accessible_page(pmd_t pmd)
+static inline bool pmd_user_accessible_page(pmd_t pmd, unsigned long addr)
 {
 	return pmd_leaf(pmd) && (pmd_val(pmd) & _PAGE_PRESENT) && (pmd_val(pmd) & _PAGE_USER);
 }
 
-static inline bool pud_user_accessible_page(pud_t pud)
+static inline bool pud_user_accessible_page(pud_t pud, unsigned long addr)
 {
 	return pud_leaf(pud) && (pud_val(pud) & _PAGE_PRESENT) && (pud_val(pud) & _PAGE_USER);
 }
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index de9e54bd27e6f2bce68304a0b3e99b139f33c313..2708c2b3ac1fbd19a0a4528f5a2b27ddbef03adf 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -151,7 +151,7 @@ void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
 	if (&init_mm == mm)
 		return;
 
-	if (pte_user_accessible_page(pte)) {
+	if (pte_user_accessible_page(pte, addr)) {
 		page_table_check_clear(pte_pfn(pte), PAGE_SIZE >> PAGE_SHIFT);
 	}
 }
@@ -163,7 +163,7 @@ void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
 	if (&init_mm == mm)
 		return;
 
-	if (pmd_user_accessible_page(pmd)) {
+	if (pmd_user_accessible_page(pmd, addr)) {
 		page_table_check_clear(pmd_pfn(pmd), PMD_SIZE >> PAGE_SHIFT);
 	}
 }
@@ -175,7 +175,7 @@ void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
 	if (&init_mm == mm)
 		return;
 
-	if (pud_user_accessible_page(pud)) {
+	if (pud_user_accessible_page(pud, addr)) {
 		page_table_check_clear(pud_pfn(pud), PUD_SIZE >> PAGE_SHIFT);
 	}
 }
@@ -211,7 +211,7 @@ void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
 
 	for (i = 0; i < nr; i++)
 		__page_table_check_pte_clear(mm, addr + PAGE_SIZE * i, ptep_get(ptep + i));
-	if (pte_user_accessible_page(pte))
+	if (pte_user_accessible_page(pte, addr))
 		page_table_check_set(pte_pfn(pte), nr, pte_write(pte));
 }
 EXPORT_SYMBOL(__page_table_check_ptes_set);
@@ -241,7 +241,7 @@ void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
 
 	for (i = 0; i < nr; i++)
 		__page_table_check_pmd_clear(mm, addr + PMD_SIZE * i, *(pmdp + i));
-	if (pmd_user_accessible_page(pmd))
+	if (pmd_user_accessible_page(pmd, addr))
 		page_table_check_set(pmd_pfn(pmd), stride * nr, pmd_write(pmd));
 }
 EXPORT_SYMBOL(__page_table_check_pmds_set);
@@ -257,7 +257,7 @@ void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
 
 	for (i = 0; i < nr; i++)
 		__page_table_check_pud_clear(mm, addr + PUD_SIZE * i, *(pudp + i));
-	if (pud_user_accessible_page(pud))
+	if (pud_user_accessible_page(pud, addr))
 		page_table_check_set(pud_pfn(pud), stride * nr, pud_write(pud));
 }
 EXPORT_SYMBOL(__page_table_check_puds_set);

-- 
2.52.0


