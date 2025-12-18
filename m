Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B398D6E2C7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:10:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A13426B0096; Thu, 18 Dec 2025 12:10:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B0676B0098; Thu, 18 Dec 2025 12:10:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B2A56B0099; Thu, 18 Dec 2025 12:10:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7AB756B0096
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:10:40 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3514412915
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:10:40 +0000 (UTC)
X-FDA: 84233231040.25.F4294C0
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id AC050140006
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:10:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SmVyDKct;
	spf=pass (imf26.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766077837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1PKqaT+cUcVjK0lAQ+5OB41b69bTOfXbbALY1SIepc=;
	b=6aMKcsCTpRgF8X13bvaoCoBu1oBuigQ0NPQT7O/TJIwmB2ni/J5RB9DtiEzCOfMH1Gtpz8
	rlwMRoC/VynCv6C9SamyP3A6NXKPEfSSiY4tuubJlkjjnGjT7T3yN1nlhZmCFZA4sbZc/g
	6/V/NDM3h6wJzO2y/M0GBX2Y4fotG5U=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SmVyDKct;
	spf=pass (imf26.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766077837; a=rsa-sha256;
	cv=none;
	b=cpXc6D4XS9kykctNABW+at+xAIdOG4wqAPA44dM5bywgkOlsWHCYJHLwlfxPVJXk4FDyrB
	Pu/klXQOhMbXJh8zrA9b5gNbqugZ7NkkwWcC2wwJz6t4bpO4ssda+aT8a/1pR+uQRZwEra
	VJRq9RKGOFNrUIJ1F62O3+Njmv8EAXI=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BI9c2Dx004224;
	Thu, 18 Dec 2025 17:10:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=B1PKqa
	T+cUcVjK0lAQ+5OB41b69bTOfXbbALY1SIepc=; b=SmVyDKct2SkjwUxKC3vegx
	7OoSFNkinArjrklGT5EKWKJcgsYWF2VWNCuqFO/MFrg4mcOQuIMuDiZD9m6o7kBu
	TRcB9/bBAeAftfLQwM296xoY/EhYC9sNkyZdXroFNhtOWJBz2cEqttUNAp57s+b6
	g/BEhO1anbnRqKvshvEISBoyWdsc2zPm945NbjF044UOj+XGUDtPFVilr/VyJhwX
	oNAPFE6AQpCcEkij35bwZJY1NxnJ8jXqLNm/saaiSG+KLBXE15V4ivMdQHhvWa/s
	jQq7tUl9sTlu4OG1pPXtm9oh2TS2M5f1IlGz266DZEizA2seYejVKs/t9HlsS6+g
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0ytvkv8k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:31 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BIH3b8c021227;
	Thu, 18 Dec 2025 17:10:31 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0ytvkv8h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:31 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIG9PCg026777;
	Thu, 18 Dec 2025 17:10:30 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b1jfssueq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:30 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BIHAS3u60096796
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 17:10:28 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4BF2458056;
	Thu, 18 Dec 2025 17:10:28 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CCEA5803F;
	Thu, 18 Dec 2025 17:10:21 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.36.16.51])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Dec 2025 17:10:21 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Fri, 19 Dec 2025 04:09:37 +1100
Subject: [PATCH v18 05/12] mm/page_table_check: Provide addr parameter to
 page_table_check_ptes_set()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-pgtable_check_v18rebase-v18-5-755bc151a50b@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAyMyBTYWx0ZWRfXwrqmM5jH5TlY
 twqwUCruTuAPrBBYXUfYXY+TJLNkr1T0Lap0/Z6RTiMu71v1UB9qBzDuQFFTT4vrbGNWmQSxbFM
 xL8T+S2dkrcRNaymfSZUrU4IUj+CQe6WuxPTreqtvgUX64LZ+vxFOeokVUddWvoEi7m9WRh+jy7
 YbZ3tTDztp0IaC/GMdnDZyDgMBPYcKhpMJ8IblSqrBq5PK6FTU86ba4Yq2iMy789C94F2nlxUUU
 3aKYkzPQvhQ5MGk0ZQ2axQHJc+zFic6WTOZVJKka7L8a/E7numETIj3WOAfJ3VlU94rtKWgGqcL
 TGt/Md+bU3UQCfYp2XBu/5jfQS+gqffWaKhY/tv6g1DeDT/orzZdK6+lNg3sf6pt3maQ9wEh6mV
 nYzxlXoRJ4oxKfgGgnCM9Koso1flXw==
X-Proofpoint-ORIG-GUID: tNcJ3CkRq9YNU_5vXjojIhgjdsSmJri_
X-Authority-Analysis: v=2.4 cv=QtRTHFyd c=1 sm=1 tr=0 ts=69443587 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=h0uksLzaAAAA:8 a=HLGKFg-hzGnhYpGVURIA:9
 a=QEXdDO2ut3YA:10 a=gpc5p9EgBqZVLdJeV_V1:22 a=MSi_79tMYmZZG2gvAgS0:22
X-Proofpoint-GUID: 1NC-0ugCpLo-736stlHdKZQlU2SwS_3X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130023
X-Stat-Signature: i673mrbtu7hhuqh556us1do4kyepkioi
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AC050140006
X-HE-Tag: 1766077837-671186
X-HE-Meta: U2FsdGVkX19qbRRQOijvXbFlhK5C1Ev3XBrsqOlLQGkE8YVv7H9WwBWwUT//n/7v79fWeNOQi2FhLkpjYxn9mBzLxvVlP6yG/KnpTmeL3xuPE+bClGP+cPuTkzJJHy/s+/1af2N7ecx8NnlEWvCkTia4uac4zbmmI1a3Tyg3YMpwaJJmJhbZHO8ockcENhVMD7M48STW2A05UdyQr7ftXAde0Tc3K4HNUh6FqgKKlYvvLzNM7Aijcr9wWTjm48dCdRp06QPgOB4KvbTqK+OacKSq4BBryHTWswXEdv4fZgm/CJnpl2A/JnPSkm5ulnoapNsznLuVsNSNmkdbAuGkznb85epK8sgt/3+JwzYAtguIerBiRVSPHE7Em3y0KV2hnghPNoLcsBwrjn4TbGl/3nBw379jaRtXy6dWvOI5SADjOxMLRYQBvTnfq/+ny/IIVB8t9weGjqWgHMpuhM8sJcGi7uR6ews41RUBoCz8K4DudeXRMyWQ7kEQiqTANIX0GX41/hjBw5Vk2dyry3fHuXzMwC6YwNGBYqSqVdjRTIFGDwbriCQNAsOOiS8yVJZWQd4zMtu1sa287XqL1sC3zKpVXPuSLP6g7ILgtXB6NCERgY/Htb/cBHcl3eJeUbhRiH8bnKl43YK68rLaFtl0LYtdSJh59MLCBYccK8h9jSNZPdNO/PLW8iPfG1CR01QqY5K1xuucslMYdUnOrbKOiw1dEg0ChDqDmcsmRJdLP0LLvw7rK6f0L37KNOl90ZK43HhL0uNlqjv7g84w9CHirnoX0+g5QaGG54HIg5zOrvAfM9Df/A8iCQKbBPVPpFQBG1KezMw5zGBePg78avUjcyobTZYk4cBDsuiOBYEXdmo4Auj+2QSFoFx5z+kzDHmED9DpEd2JUyZFH1upHszhv+1HphmSrZV/26WqQl/M2ig6xEjt/7jsl60TA273qLg8iHCL9ftWjUSj8ZG5Of7
 gjHwFlJf
 IIdDzOiAjIElasditO8ulUsjbmMjR1Hj/EvJi/f6JWF38ZlV+yaud3oSY5szapobcKjxrIEtToh3CFH0NMYOrK8NimxgQ87AW0znDlpCTCIhuIRjbnEWpZz2v8MfXCF31/ViRarLiojCt15fMD5HZUTYqjuu+C9XK7bR0BEZJoi15UNF8HLbh528gBXO5qMpri4BGR5FQpXth2zV+Brm+uUXhteF+C2MYblPPDeL9AZKEig7FgBVCj4bJ+tmU7wT/JUvs44jCIbI41U8ntzmtYkg70loH11bXDMzaxzbvxiZkgDZanYK7XZv2llnwCB6d5ryhP9CuzouW9ohETtbt2qSd6FoEZF9Q96Qv7cgzLqLiN2TJTR2AwJgyfArnEGtk6OSvXdHurbea0145eknQpuvCUcljuz8cBQMrfyWcXK3o83q8BRNzTSE0NuJw4CsRBlfG2Dj0V8xP9fFAOm964f9UTQTsgTwhremltDlhapHriY3+zgbJCm3hh09r15puviC+zI9uIwZm9+ZR1x2vyDK2u1DhodsNbwzee0NUOsI7f80=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rohan McLure <rmclure@linux.ibm.com>

To provide support for powerpc platforms, provide an addr parameter to
the __page_table_check_ptes_set() and page_table_check_ptes_set() routines.
This parameter is needed on some powerpc platforms which do not encode whether
a mapping is for user or kernel in the pte. On such platforms, this can be
inferred from the addr parameter.

[ajd@linux.ibm.com: rebase on arm64 + riscv changes, update commit message]
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv
Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>
---
v15: rebase, amend commit message
---
 arch/arm64/include/asm/pgtable.h |  2 +-
 arch/riscv/include/asm/pgtable.h |  2 +-
 include/linux/page_table_check.h | 12 +++++++-----
 include/linux/pgtable.h          |  2 +-
 mm/page_table_check.c            |  4 ++--
 5 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 4b580d6246f5a1c8f859bf79665419bbcd8c7cd3..d1dd0266bb0c946442df88594cc39e958185af0a 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -681,7 +681,7 @@ static inline void __set_ptes_anysz(struct mm_struct *mm, unsigned long addr,
 
 	switch (pgsize) {
 	case PAGE_SIZE:
-		page_table_check_ptes_set(mm, ptep, pte, nr);
+		page_table_check_ptes_set(mm, addr, ptep, pte, nr);
 		break;
 	case PMD_SIZE:
 		page_table_check_pmds_set(mm, addr, (pmd_t *)ptep,
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 3fea1d07f7470a04fdc9a6f581d21667e35e0e2a..89abba40e3e426c00e6964bdf135042777319588 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -631,7 +631,7 @@ static inline void __set_pte_at(struct mm_struct *mm, pte_t *ptep, pte_t pteval)
 static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 		pte_t *ptep, pte_t pteval, unsigned int nr)
 {
-	page_table_check_ptes_set(mm, ptep, pteval, nr);
+	page_table_check_ptes_set(mm, addr, ptep, pteval, nr);
 
 	for (;;) {
 		__set_pte_at(mm, ptep, pteval);
diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
index cf7c28d8d468c026cb5278435a64fbcf0fe9260e..66e10923841691a59620da8d17f7bb7b09e6a6d3 100644
--- a/include/linux/page_table_check.h
+++ b/include/linux/page_table_check.h
@@ -17,8 +17,8 @@ void __page_table_check_zero(struct page *page, unsigned int order);
 void __page_table_check_pte_clear(struct mm_struct *mm, pte_t pte);
 void __page_table_check_pmd_clear(struct mm_struct *mm, pmd_t pmd);
 void __page_table_check_pud_clear(struct mm_struct *mm, pud_t pud);
-void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
-		unsigned int nr);
+void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
+		pte_t *ptep, pte_t pte, unsigned int nr);
 void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
 		pmd_t *pmdp, pmd_t pmd, unsigned int nr);
 void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
@@ -68,12 +68,13 @@ static inline void page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
 }
 
 static inline void page_table_check_ptes_set(struct mm_struct *mm,
-		pte_t *ptep, pte_t pte, unsigned int nr)
+					     unsigned long addr, pte_t *ptep,
+					     pte_t pte, unsigned int nr)
 {
 	if (static_branch_likely(&page_table_check_disabled))
 		return;
 
-	__page_table_check_ptes_set(mm, ptep, pte, nr);
+	__page_table_check_ptes_set(mm, addr, ptep, pte, nr);
 }
 
 static inline void page_table_check_pmds_set(struct mm_struct *mm,
@@ -127,7 +128,8 @@ static inline void page_table_check_pud_clear(struct mm_struct *mm, pud_t pud)
 }
 
 static inline void page_table_check_ptes_set(struct mm_struct *mm,
-		pte_t *ptep, pte_t pte, unsigned int nr)
+					     unsigned long addr, pte_t *ptep,
+					     pte_t pte, unsigned int nr)
 {
 }
 
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 2f0dd3a4ace1acd665f229d4ea2a67187fd4d2b9..496873f44f67b73fc32940c956fd5265b748faad 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -429,7 +429,7 @@ static inline pte_t pte_advance_pfn(pte_t pte, unsigned long nr)
 static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 		pte_t *ptep, pte_t pte, unsigned int nr)
 {
-	page_table_check_ptes_set(mm, ptep, pte, nr);
+	page_table_check_ptes_set(mm, addr, ptep, pte, nr);
 
 	for (;;) {
 		set_pte(ptep, pte);
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 86dc4e4d1dad12fe5d9d86905234b009257586d5..2871d9c453682ba922b2fcf532cb6a7d867ad952 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -196,8 +196,8 @@ static void page_table_check_pte_flags(pte_t pte)
 	}
 }
 
-void __page_table_check_ptes_set(struct mm_struct *mm, pte_t *ptep, pte_t pte,
-		unsigned int nr)
+void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
+				 pte_t *ptep, pte_t pte, unsigned int nr)
 {
 	unsigned int i;
 

-- 
2.52.0


