Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C41F2D6E2C7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30DA66B008C; Thu, 18 Dec 2025 12:10:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D8436B0092; Thu, 18 Dec 2025 12:10:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C4BA6B0093; Thu, 18 Dec 2025 12:10:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 08BD66B008C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:10:26 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B100586125
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:10:25 +0000 (UTC)
X-FDA: 84233230410.25.2FE76D9
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf29.hostedemail.com (Postfix) with ESMTP id 204B6120013
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:10:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QuX+sM1t;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf29.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766077823; a=rsa-sha256;
	cv=none;
	b=3HqjsDJGnz+YD6oW5ksfa0/sUVqKiQ67SwiFJAVQ47GMMSfrzCkn3zw7ZgMhU3uneaSioP
	LEk4renSBswrqOGEL0kaw8wUFWaAHrnAecygL4/L4AKieA5ki33hw6epnTvNLc9U5mhlzy
	95xfxZHUGZdMApqy1dX3nBhmCjdAJyk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QuX+sM1t;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf29.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766077823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SskiqXuzbr2amJlbHojQ/YH/pndNtq7FvgJs906bqOo=;
	b=KRHa2xrPZ1KjFv0mcR4bu/H4bzWQRBdvno8K+uzoRzJMqCUydazQXrDIrF1sgSud9ig9BL
	TlVfIDoLocRwCeeLbzfMfT+CDH3nBZiF1Vqi+xptb0U0/CmAzx4uNu4PIbsCsCSHhOe9A1
	QU+Rtu36oJ0pbwdZmmPnBSBUN73jItI=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BI8lli9012517;
	Thu, 18 Dec 2025 17:10:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=SskiqX
	uzbr2amJlbHojQ/YH/pndNtq7FvgJs906bqOo=; b=QuX+sM1tuFeaV/ZQB+C4MO
	636rwLmiaP2/qrsBwuOmA/Jn9GV+wDtUOTUz9zZvtEr0CdbnfhnJ9neej9KxvokQ
	5mnaaBxvjRpgUkU3WBa+U89gKJXZMbm/qUujS45YCA7VSsyJ71Hbdu157QUrK+zm
	CtyFE8gZyQEF2GD/3/bXhTF6dtGWp2VSAQ2PDbrs2tu0/OoeWh1ssE2R7DPkOjaQ
	FZJbl3+w/4h+vPq0X5og1CGG0Wa7OARxFdhPzLvWvT/Y0qSXPqKm7ADb2DlQZBeM
	4O5SFKmA2GAcF/38YVNa6A5mkc0wbfg3F7epxDoU8SEJq1mVZbZsbdPXw+oNw0TQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0yn8uyt4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:17 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BIHAGkV016082;
	Thu, 18 Dec 2025 17:10:16 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0yn8uysx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:16 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIEUBG0002863;
	Thu, 18 Dec 2025 17:10:15 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b1kfnhhr3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:15 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BIHADsA26542786
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 17:10:13 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F7395805A;
	Thu, 18 Dec 2025 17:10:13 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7692958064;
	Thu, 18 Dec 2025 17:10:06 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.36.16.51])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Dec 2025 17:10:06 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Fri, 19 Dec 2025 04:09:35 +1100
Subject: [PATCH v18 03/12] mm/page_table_check: Reinstate address parameter
 in [__]page_table_check_pud[s]_set()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-pgtable_check_v18rebase-v18-3-755bc151a50b@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAxOCBTYWx0ZWRfX5MxHRb0I5nH6
 3Mb03RBXSENeftYsd20Cd/h6/vASGtB0WEblavnxC96qaOvJrQXyy0YmXAeIif7rQ2LE4VWVfBe
 Nt7ikfqPvJYlDJ5Bd/KMGw8yDzur6OY67w99ZctpkYR4U4iRmp8PaCkg/Pbv87ce4ucM7F/VtIT
 1tegR6DIognFTmKdeUYTdyjWVi2I2HHItHsHJ2NWXWERK69MybTsrDvygvzkCor1R2WPlqNI5QP
 KuiSsPFC5vSivee+qwiVTXSOij6HeXVRFE6zEbwnjP/nhG+51reg3tZC95yIcpkotV+i0i2PRrH
 f6ug4/JcBUkuxhi1dA8Wdd04wln57bf/b5PqYiGUuVjQSXlNqcg9HHA0wzP+Mk1mOs/MuBwmVkI
 9U2Msm/tem/w/LN9Cp6CsPS6dEOxoA==
X-Proofpoint-GUID: GgX4_szkJA6yTTm0B-gwoI7WWvTHXwg8
X-Proofpoint-ORIG-GUID: riEKCtJc0a_Nv3It3u3dYPsN-a7NeUG_
X-Authority-Analysis: v=2.4 cv=LbYxKzfi c=1 sm=1 tr=0 ts=69443579 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=VwQbUJbxAAAA:8 a=h0uksLzaAAAA:8
 a=3Toew5EgkJ5X0DR0WCAA:9 a=QEXdDO2ut3YA:10 a=gpc5p9EgBqZVLdJeV_V1:22
 a=MSi_79tMYmZZG2gvAgS0:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2512130018
X-Rspam-User: 
X-Rspamd-Queue-Id: 204B6120013
X-Rspamd-Server: rspam10
X-Stat-Signature: 6csq5g95z18wos9swrzoeoinatyeetdg
X-HE-Tag: 1766077822-604592
X-HE-Meta: U2FsdGVkX1+SHbhyrGw3ruwxuieQgtezu5yjKptF0G4RvVs3DlpmVckirDbKNhU17o4g26WeZsv3b23dsTLxaUk3rmyjPVEr084Gj1q3lU/7QxCJ+SsIGDSVTKTV84nq1Dg4vZlF+/6vCw/vHVYHNxk/+SrKxxqPsMEBov1ZMfZUzshEkUhLUYIGMzquyOIw+iZG28oMmVF3+M8/W8o9K8eE8AcinG+1dkD65DdaGoqBHHWV7oMmvOtCw+mZfojRoD8an2RjxYs/qatIY1VKZ6NOM9hoYDMy1iiH2U4UpOqpmZIV6higJ+fbbAv2gD8kz5C7aoE9EMVlrEAJrJE55MkC/gLDY3Bhhq6bdTFAjeoTjO9QJZPOAtkzs/Xhi9GrUznWhyGU/W8uTukIuv+ZrzriuyyIiqxPEU626lE89lXNXElwk/0V+nhxGKlbWltgdF/nfxgjjcHLfTLEpCUUdPQVwjeMdWOeoV3bodi0YR68a043mgG62fwrfngJUjGdDEdYn2Em8KwmX+laz3TKl8UcDjpPVSLuntZz6qCs0qhUqcg6W8TovlPljG3BnTnmOxa1ElLDniWmq6SAxzRIb+q1TR2BAynncYdoL4PRkrDa3ye/s5dsJKANaTS07su8Nzyyv2GDDrnBEZ6vJCoIqaU9UdNj7HhtGxd96HZvaElliYuo90A9+VhsjkNyLyit+P1Lg7NBqTgLuAzMFtXKbQtjuVljusjRzO4DwcKtA+bpytlYRtHQ2HWBcxHExm3CmlmXBy7O9lEGRQOw8neyXG1T7jwpKZWogTTREfYICPAuYdMcyRhMXiwqAsAtPjbVaDb+R9lfY7gpfazNbrQOrGMk8VuHxIKO7nsMRsiRn+G/Za13Wg0mgLSXhQ+I/8nlQa7LZSvN9jK2ocn5gFwheD83wo7uC36qs9rfwDuUHkU0as1XGtCTAB+3l0JudkbKBxOUbM+RRaU29KN1jtr
 HsIIk+sZ
 2o4LqVzTlenk3U4RgJTAEhDW+CTM0zyAD7MYnAywaAmOAOHo6FIYwZhYONAIbtZ2EVXB2ZGUZ++7EQygumxj0cGtRVy8XAqgMcPZYy1iPspsUxzSVpXALv3+yOPa0zK89HsqjYX6bjCPVuoJ/80GahyT4eMj0bgZvC+4OTgiEL/fH3vUqdzu0JmOZkuuyEXAgSFLjJdagyGRfmUwomc81HO0nJopBBLIY2qBhy+9fn5eUVuB1C1qP7meYBeJA4gXsLlyb5MKpe8UR0keyslCbkUpXFwD/WiqA8tUh4ai3peDJWHcAi6URBIYOaXcAdWZm9pU67DC8bEVPifgyx7ejfvYcj11rrvE5dsQdQbK745+XEHxoJT7X3t/H7is/X2M1zT3DfjoJXqmya0o4U+m6u+P44jeZzaasOvccS8/VZ+PJ3+MfuMtl+RZySORt+sOCfcfnmWJjy9ymCDxmi02Xk0jPE23z2CcW6knD4Aca3gcdkDtp1iI7xfFbDEElZU2JWWAaSnnVDj95EWA=
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
Acked-by: Alexandre Ghiti <alexghiti@rivosinc.com> # riscv
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
index 29f7ae7011a820687f5b1e2fdc782eb37f85fc1b..87ed9b1c011e167125a7f29a3388eca4c7bd9f29 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -688,7 +688,8 @@ static inline void __set_ptes_anysz(struct mm_struct *mm, unsigned long addr,
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
index 8bd36ac842eba94ec6af140ab81bd75d32ad1ff8..c4ea70903fedac7c055fb4cf530000a533c27ade 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -951,7 +951,7 @@ static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 				pud_t *pudp, pud_t pud)
 {
-	page_table_check_pud_set(mm, pudp, pud);
+	page_table_check_pud_set(mm, addr, pudp, pud);
 	return __set_pte_at(mm, (pte_t *)pudp, pud_pte(pud));
 }
 
@@ -1114,7 +1114,7 @@ static inline void update_mmu_cache_pud(struct vm_area_struct *vma,
 static inline pud_t pudp_establish(struct vm_area_struct *vma,
 				   unsigned long address, pud_t *pudp, pud_t pud)
 {
-	page_table_check_pud_set(vma->vm_mm, pudp, pud);
+	page_table_check_pud_set(vma->vm_mm, address, pudp, pud);
 	return __pud(atomic_long_xchg((atomic_long_t *)pudp, pud_val(pud)));
 }
 
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 2842fa1f7a2ce2346c51f76470a0902155d7d00d..2b540c563d8ddc5ed28e583de6a409c0e1bd97aa 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1221,7 +1221,7 @@ static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 static inline void set_pud_at(struct mm_struct *mm, unsigned long addr,
 			      pud_t *pudp, pud_t pud)
 {
-	page_table_check_pud_set(mm, pudp, pud);
+	page_table_check_pud_set(mm, addr, pudp, pud);
 	native_set_pud(pudp, pud);
 }
 
@@ -1372,7 +1372,7 @@ static inline pmd_t pmdp_establish(struct vm_area_struct *vma,
 static inline pud_t pudp_establish(struct vm_area_struct *vma,
 		unsigned long address, pud_t *pudp, pud_t pud)
 {
-	page_table_check_pud_set(vma->vm_mm, pudp, pud);
+	page_table_check_pud_set(vma->vm_mm, address, pudp, pud);
 	if (IS_ENABLED(CONFIG_SMP)) {
 		return xchg(pudp, pud);
 	} else {
diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
index 289620d4aad3a03a0c3b27b08066fb27250cd10a..0bf18b884a1265fa98eb04d2e3dbd63d02e706f3 100644
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
index 741884645ab0fdd49425098681d62070c343152b..a48f835216a1f50ffd088477ae7e80896be43bc6 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -243,8 +243,8 @@ void __page_table_check_pmds_set(struct mm_struct *mm, pmd_t *pmdp, pmd_t pmd,
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
2.52.0


