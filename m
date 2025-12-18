Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B6DBD6E2BF
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:10:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B67A6B0095; Thu, 18 Dec 2025 12:10:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874016B0096; Thu, 18 Dec 2025 12:10:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 776546B0098; Thu, 18 Dec 2025 12:10:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65CD76B0095
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:10:31 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0EB3B13A6C6
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:10:31 +0000 (UTC)
X-FDA: 84233230662.04.3747641
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id 95E06C001A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:10:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=B4YoubLk;
	spf=pass (imf10.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766077828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eqiA4lK/eMX5KF8yo+8Tkjj5ayTkYXzOx2oQ6QICjz0=;
	b=k0MW1qPUz2CK71eu/MRXCr/EBjI1+Y1T50DYF+YUM8G3EycnQF6nb8HI2pUjVJeup7hwXJ
	h1M4eFBQyzrxwaev30u3Nm8neNBa0SqPhCM5wta+ov0WJFXofFk9hTtYSgTpLY81Ca2xo0
	zkoZ9n0xNEBk5BQ0et1IXFrTWap/eS4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766077828; a=rsa-sha256;
	cv=none;
	b=rCm+m5jcJ/OAMv27ueSSy+7usThVvPI+kvpbWb1ZeprSZi/sRl6tarnk4Lwb1nwgZzyVZa
	X5TGjkeZJtD21Mk8mLO+BPX/vZty5JhnQerFg8wcvMHyIG66cKDd2/GgnlqirBvzv/KuAy
	g/ngHSVGvLSZk4wMfDmvgQC5Jwy8MpY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=B4YoubLk;
	spf=pass (imf10.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIBsbri010214;
	Thu, 18 Dec 2025 17:10:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=eqiA4l
	K/eMX5KF8yo+8Tkjj5ayTkYXzOx2oQ6QICjz0=; b=B4YoubLkE6md/sCVHzNrnT
	5Sw7/ezimxyKlnlmafmpkJp+ldTkuAILIfax6B3Sh8Rbjd1a3z1+239rvACgtGQf
	dIotvxT6exKFYKF2uloF2OgAAGYNwoHCaUMw3/adPQr4W3D2IwkjFCVzpxQM61BI
	KEw9Xd6flsYQ5eBFnB65yrf3JDp/VDAeAK3wnHmfJlFIK2lgMerc3WuO7fFXKxdD
	CCTbJH35TnlXTIL3LDhwYPwe5HJxljiwtfNHvF47H6kRIlmzSPNPXPTMpyE3AcrA
	0jZoFx1f126TutSqckRf4PMfwKjSMood+TTVUzrG+dBAnl8RQIiGKDO/lhaIvewA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0wjqb7ph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:23 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BIGwwWQ008341;
	Thu, 18 Dec 2025 17:10:22 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0wjqb7pe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:22 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIH2A6X002973;
	Thu, 18 Dec 2025 17:10:22 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b1kym1ejt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:22 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BIHAKZR1376868
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 17:10:20 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C1AC25805A;
	Thu, 18 Dec 2025 17:10:20 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 41FCE5803F;
	Thu, 18 Dec 2025 17:10:14 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.36.16.51])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Dec 2025 17:10:13 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Fri, 19 Dec 2025 04:09:36 +1100
Subject: [PATCH v18 04/12] mm/page_table_check: Reinstate address parameter
 in [__]page_table_check_pmd[s]_set()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-pgtable_check_v18rebase-v18-4-755bc151a50b@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAwMSBTYWx0ZWRfX9IQIIzKXw2xl
 tH0+/rbto+UPHpGRxbED6SFyU3TvQhzBn5Bnm18Rs7M2aU8o3fpGJ4GlFLITKm4ocJpzIM71KI4
 82JiYcC8K0cJaWhsh8Kt4lClC4WvPfTfqtudIu8x5q1we2MEDW+StLh+zTxly5M4hs9tmqSranK
 jbIIl4AwagE/K7yWlry8vTYFNJu5geMYYLi8J4+IpbzhrER7+79YZjCcEwfYF9kq6Exa76R9IUQ
 jWV+WryOEkX902WPU+YriYReNSBQT1zQqZiigNIk/AHMNFd9GV63P/iEY3A8jOFva+/ZkkwZRaF
 WK8kTcvio9IVcqJPQKyWw1OF0YVY55OJrhQ+2rFhtI/Lw9oniFr/In5TpNOtP5/CCYQhO5AEumr
 9xeXkJ23JhORCDEgOB3C7c9DIFK82g==
X-Proofpoint-GUID: I2zX4DK71CblZCa3u2dIDhZ7h8ZwJsLZ
X-Proofpoint-ORIG-GUID: cZpzCHq2r53ZhDcAFYYYH7eEx1WpyjvD
X-Authority-Analysis: v=2.4 cv=Kq5AGGWN c=1 sm=1 tr=0 ts=6944357f cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=VwQbUJbxAAAA:8 a=h0uksLzaAAAA:8
 a=-IAaNFHw-wEKn7DCNmAA:9 a=QEXdDO2ut3YA:10 a=gpc5p9EgBqZVLdJeV_V1:22
 a=MSi_79tMYmZZG2gvAgS0:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 impostorscore=0 clxscore=1011 spamscore=0
 priorityscore=1501 lowpriorityscore=0 bulkscore=0 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130001
X-Stat-Signature: qgtugmr4n5k3wt7df9y1kkfmcgy9gfwh
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 95E06C001A
X-Rspam-User: 
X-HE-Tag: 1766077828-379062
X-HE-Meta: U2FsdGVkX18rU7gxGvOqdDWROlXCYfWNorYEYg7ohOKxyHYGV6KoPeXiNC8D1lP25uyZB6Ph9Kgpt8QWUrPQbhEPjsN64IxxdxQr4Q1ql8YZB2J6DyTPA0VsLBBK6BLsiYQWUCJgHhmoeZ1HpeOSoo3v85JqPP0KhhtnH2bDPGAgFVPfS2NxpXqCDY/PxjcCE08AWL1QijAB5SakDoroYCAYVY0qFXMkl2PP9uPLZdyx4kjIRHmW1qoqTfl2kezNv1TY9EXiJ5HtG4U8LxGAuuafSz7V28cID9Kf17/ANMbBuVfHjC0qRgbxgJky7/Uk0cWod+5QPtipx9a2hEMYA6w4tuK88gRdwhfamJrW5nb7U7uhMqVWs0gx4PycTYzdHlEJxzlnsskd+WoQbyHUGQ0yVOqQ6/5ZbUCx4fd34uWKSXjGkvwt3ro6uwgrijn4GFreXLFCxKihs+kIvUTSItS9SVvGs0nBV/gjgqJhctqEqMDYzrtpSznrx4DOwPjITEJSijw3jhCWcy1hO6/9k1DaKGW0DV1xqayREIQGqy6lR/T0oIl1o2lNkE7dv5aCzRetnJc+miwXNUbMKNqKGBrkqf04NBkYeFbEmMj8sqGtjnwknFKFD/033CPSGJlQ4dbd2VG5bALWWYXMvalje53g68Dknks9rUQIGTKjb4U+TuBUYUZCYVSiufpC53haPeiuqlT7AQD5y5pLQfPDpomdP2IKijHg2Vj8fF6G+8dJZjp/F7G68nSBEgjlzc6CNb5ynhN4yFMo/7uW17bKPzdSVEa24dQ1A+CvR9gtjmj7WQscFUU819Y6QLChTLweECXaklSdANTwxcwf+jyfhemAqqk0Ux7kjt7lDQ+jUu3ZkMpu1AQ+cK9WW15PJI2kovYiDzUxS4tYA9bTya5FWww5PjI5ynJRnVKyFZnS5C9m1LlNnpPB3eirIlW5po8zjaQd0jLcBzW09wFdNfH
 3OL3w8vG
 Ttn2e044QaTuzftUfv6p3zggs4IkthynL4lv3c10jWB91+scT38ZRaYJx7zIYfTn6+wPX8ryG35Xaw5SB9CNu2s/bJE2hAarmnldS67D5N2IxRI5qLEb0M7799P1ejLi25iuAIPfjEGnBmUDNQ9GtuS+Wo9zKJVjYnpX35zcXjDpL1TSILHLEUjnh1hpuTphNkxaj6gob1whvhyeFBAzKK8GXQ305TRtit2MB69BQ1v1eR8Ue3Zb954u1pOIr1dSlIwLBI+axD6t6xDmBQm3wr4RvJW7qvC9V5S2HjQ+4paBM0zNVUCpPJlGHZZqvPzSGAQO0szVYSt/rKM8Abc4n7XBvYN8eCfM+A4YzK8Sa9kZ+DRV7O+fDaKabIEEI4i7ffaLjIdRPnZlOIAgWhLARHov1wTaVGtPxXHwe8m1U/14wiWHgZGgWwNon9po1H+RJZ9BmVrwhEk4yH99pfuJ83ND8BC0qHeRLsg+AJpkAFwAbKaU8N6FhRYVonGu2LN1MAztFCpS8025sfjI=
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
index 87ed9b1c011e167125a7f29a3388eca4c7bd9f29..4b580d6246f5a1c8f859bf79665419bbcd8c7cd3 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -684,7 +684,8 @@ static inline void __set_ptes_anysz(struct mm_struct *mm, unsigned long addr,
 		page_table_check_ptes_set(mm, ptep, pte, nr);
 		break;
 	case PMD_SIZE:
-		page_table_check_pmds_set(mm, (pmd_t *)ptep, pte_pmd(pte), nr);
+		page_table_check_pmds_set(mm, addr, (pmd_t *)ptep,
+					  pte_pmd(pte), nr);
 		break;
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SIZE:
@@ -1489,7 +1490,7 @@ static inline void pmdp_set_wrprotect(struct mm_struct *mm,
 static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
+	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
 	return __pmd(xchg_relaxed(&pmd_val(*pmdp), pmd_val(pmd)));
 }
 #endif
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index c4ea70903fedac7c055fb4cf530000a533c27ade..3fea1d07f7470a04fdc9a6f581d21667e35e0e2a 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -944,7 +944,7 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 				pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(mm, pmdp, pmd);
+	page_table_check_pmd_set(mm, addr, pmdp, pmd);
 	return __set_pte_at(mm, (pte_t *)pmdp, pmd_pte(pmd));
 }
 
@@ -1015,7 +1015,7 @@ static inline void pmdp_set_wrprotect(struct mm_struct *mm,
 static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 				unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
+	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
 	return __pmd(atomic_long_xchg((atomic_long_t *)pmdp, pmd_val(pmd)));
 }
 
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 2b540c563d8ddc5ed28e583de6a409c0e1bd97aa..7fd876f8d828ea70def7adc51cc17e70d3046e35 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1214,7 +1214,7 @@ static inline pud_t native_local_pudp_get_and_clear(pud_t *pudp)
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(mm, pmdp, pmd);
+	page_table_check_pmd_set(mm, addr, pmdp, pmd);
 	set_pmd(pmdp, pmd);
 }
 
@@ -1357,7 +1357,7 @@ static inline void pmdp_set_wrprotect(struct mm_struct *mm,
 static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 		unsigned long address, pmd_t *pmdp, pmd_t pmd)
 {
-	page_table_check_pmd_set(vma->vm_mm, pmdp, pmd);
+	page_table_check_pmd_set(vma->vm_mm, address, pmdp, pmd);
 	if (IS_ENABLED(CONFIG_SMP)) {
 		return xchg(pmdp, pmd);
 	} else {
diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
index 0bf18b884a1265fa98eb04d2e3dbd63d02e706f3..cf7c28d8d468c026cb5278435a64fbcf0fe9260e 100644
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
index a48f835216a1f50ffd088477ae7e80896be43bc6..86dc4e4d1dad12fe5d9d86905234b009257586d5 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -225,8 +225,8 @@ static inline void page_table_check_pmd_flags(pmd_t pmd)
 	}
 }
 
-void __page_table_check_pmds_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd,
-		unsigned int nr)
+void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
+		pmd_t *pmdp, pmd_t pmd, unsigned int nr)
 {
 	unsigned long stride = PMD_SIZE >> PAGE_SHIFT;
 	unsigned int i;

-- 
2.52.0


