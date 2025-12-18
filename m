Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19A51D6E2C7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 17:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BE4A6B0098; Thu, 18 Dec 2025 12:10:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 630B56B0099; Thu, 18 Dec 2025 12:10:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54AE56B009B; Thu, 18 Dec 2025 12:10:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 446B36B0098
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:10:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E2B9D8887B
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:10:46 +0000 (UTC)
X-FDA: 84233231292.24.B31D131
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf03.hostedemail.com (Postfix) with ESMTP id 672D720003
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 17:10:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GuIiUAaC;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766077844; a=rsa-sha256;
	cv=none;
	b=gVAtQE//pClTcuu7fBcCQbw2lH0HhJ+SKi2wwOnE7QUGiQGDdYJIpph22GTNszkUB9UoCu
	V0k89uouIlwc4i1Ny5se4QAii9h35tn9OEUiKlfNOZkogUATIfSWcuZZQndKhBmI005KEH
	q5No3Z6A/eQmL47h0w94Cva6uvMkdAk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GuIiUAaC;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766077844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZ67xPxaTbTtsO9cvIF/qxKW++iMaXTkBtrOc/gvbuY=;
	b=ix4wFT1GS/FUj0X6w2aenhVLAzkwY+CfALc6ot99mwakx66LaL/78+2AAoRBw46/7LwYrJ
	WLyDFc2ZmYOknfJn7l/NBw6Z176XkijrnIxMdJwqw+OcKrkciKPW0CVzEqpVH7tGdskG1q
	FhinWWao4OMeTyICImn+W5U1dqAPsRc=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BI8GDZw004426;
	Thu, 18 Dec 2025 17:10:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=zZ67xP
	xaTbTtsO9cvIF/qxKW++iMaXTkBtrOc/gvbuY=; b=GuIiUAaCapbAfv+X66e8yR
	oXk20sWt48fjxOw851qbQm0bM0cBJv42ko7vIcm4W6dNGSfDOwtgPJug6UjurOqn
	jQo1gzg8Zs/NpsEbDEoSGLb5C03X2ij0oKYENnaI6qc9925R0nr9EebotrvJoXYn
	e87SF+KGVN12zgX+qB8Jkrbm0pquAFRUd0tYFHxW1ojv3Eu6WEUo5qkTIJ0xq4b9
	SusDVwxCqigv7Fvy+sYaov4s7qJqa7c/kd7791UTd2IR9rMSVghVGTQRSBQyUOhd
	yquWMaKJSwSjnHA9q/Z438oJfgdzrAk8kJ1VA1qBJAC55/OqBGcuNdiJ3wgo2tCQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0ytvkv98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:39 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5BIH72MH027214;
	Thu, 18 Dec 2025 17:10:38 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b0ytvkv93-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:38 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BIEBi43002856;
	Thu, 18 Dec 2025 17:10:37 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b1kfnhhtf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Dec 2025 17:10:37 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BIHAZ5l29819634
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 17:10:36 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB7825803F;
	Thu, 18 Dec 2025 17:10:35 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1CD2E58056;
	Thu, 18 Dec 2025 17:10:29 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.36.16.51])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Dec 2025 17:10:28 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
Date: Fri, 19 Dec 2025 04:09:38 +1100
Subject: [PATCH v18 06/12] mm/page_table_check: Reinstate address parameter
 in [__]page_table_check_pud_clear()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251219-pgtable_check_v18rebase-v18-6-755bc151a50b@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEzMDAyMyBTYWx0ZWRfX2GdI2OfOk0nr
 +YY0AKjbMkEYpENB1vBNlm2TewxLvp9S9NrlIkzUUfqEnD+aIYoseigjCqhWmZFcwTxrl8+VxnS
 Fs7PGC2HvcwtUOK/n2+MJRqbPjBSb/MPazPXnl44xNqdTm/7dYwwpwxoJzJtnB7T+vohxDQQK4s
 8PwB4aMC25jW+a+yQqTwNOChNhqDfo38LSuHOKOwSA0myy9gnx8RQl6Bw5AfOs2TGXV717EQPA5
 JxTcv+MBkHqh//c1/XrhVCxf3FswW3tgmHqC/pH8FyPZl5c8q6W/L8QZbJLkuQdJYXXmuECUA/h
 YMD4DimLWiaPsrdALyuyEDDxyfXVcJ6DmktrgVVB5mr4YWxZ1qftUfdMsYQ8VqipZtc3bzv3arf
 nv/BC33OQxx90d4rkgV8kP6UQEuhIQ==
X-Proofpoint-ORIG-GUID: zb8xkrJS4407DEIx0iB13m777aIHsqjH
X-Authority-Analysis: v=2.4 cv=QtRTHFyd c=1 sm=1 tr=0 ts=6944358f cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=VwQbUJbxAAAA:8 a=wZhGIaPSpsofiGV4ShsA:9
 a=QEXdDO2ut3YA:10 a=gpc5p9EgBqZVLdJeV_V1:22
X-Proofpoint-GUID: ZcbySWh4w5lgKpugxWSci09tNfPsio4T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_02,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 impostorscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2512130023
X-Rspam-User: 
X-Rspamd-Queue-Id: 672D720003
X-Rspamd-Server: rspam10
X-Stat-Signature: uhgnatw76ou7pq1rckdnbysc8x7bkg5c
X-HE-Tag: 1766077844-250939
X-HE-Meta: U2FsdGVkX19VGFq3oBNvmy/JyImPGe2kzj7vhIJkDGmur66jP0aj3hEynuktIFcYQh2dvjUEUIY1jPM0zvSVlYrovesbHSjfxtGpbLeRy0Bvo+uMCR5y7H9LQOCtY/n5ObhvC/phDddfGQlZbbpoLYjhTuQXxpF76tuB+29yubJC7AawBDvHGEEDtNrDJftGB1HsP8GGIBrZZfzRzKlJ0FrJryXQESp17hWNO6ks7cw8HZaSdgRMmeO3N5OHTLNbxKvlI7tUXgLSLN1X0Bh4ZNUxSb/Xwmk/Tiz/W6eT+tcoNoyh3Y0IOZVp4bhvQ2ctLFP5yfa0SnPrmjT7PbEmKqd+pptIh/tSfTWPpUR4xptrynd5gFpu3KI2vo7t7aTq0Z27s/9UrFXAJLzqJ5j6I3DB2zqfX07ldDOtnOtfhkajSSUKN2KRzCZq+g+UoE8tqmSprn44ezqy3rbAJHhiQJlrJwvki/TDFDXam6Dle1CJgsibRnkmrwERuG+F6YIlDX5XYieh4+FTAoLglJKAF+FlDiXpMdsV5U0/tciTuUzCsw8pHkYN4S3Mo1XWMoPgqpwkhhhapa6WkPz/LZqgQMQsYfBl+uu2JOScZYtnZW566bDNBwDlMwg6fLa9RGO7QKzMAxjQWUJejEoCe+4gjiTYgRoUl9VicFUd1kVWHfTUavndCo1cYrtVh13wqwRi3UFB10pHqo020EzzWYIUwzU8WtWWjnK1T5sfu8ZYGLotX46JY57+1X069B8Gy2PUQ5FicfvLqPCZbDVftkGhrrRhoc5Vc0G+JyYw2dw6kGmKPGQNYpyJVkQIByBBO8idIPrM5nkPvpChE9ApbR2QCv9thTuRENz4+sg5ZuhwXYVnW1L4SFbiYSsb3jL8q7iyD4a4h6A89DmIGhvwIrTliscG3/OtM73qyj8O5kLqHGcx7IOGymVMrIRrS56dtMXLXoRSzVwBgx2mw08Qy8/
 7XG+n2FY
 ZDtZm8ZpNre716IgaYwfcPCI3V1hjS2I5/svFi6R58Ophp1EhfCnOY0wAXzmdNeA8W3UQtO2sLR8nUIy1AA+cVw2HzMFYZi5LgrLqb6nG57o8wM0+Hv6eXqpG8FljAPsPkGwJoj/IAQr+oe6oHIZ3stfJNPqin+2/phe0RciO2YbVjQNpaNKNK3eu+CJhUXFyo0wz4cM8rgqBBoDISe8rtm/X0C9yMQhI/v70r2r4plelVw3uHyHXbGW2QqXZWIeQecnbNxHtt13hohKaHe0m3fE+T8qm2gkL/OpncCxTnUzjNAt+xzBk9dgEYOS/sLsZOmWyUqYiPNuxEWwRtgV5Lz0wxupuFpzQ6SjW1F1b5MyY86q+ZTrFlErMH1au4oxj7jmRHial2Hct0b/ZrRVs4JcBbE4rH501OV5g/tm65HrTxTaOTAva9t2kGc+sHLwGftGsFZSInNVQBhU=
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
index d1dd0266bb0c946442df88594cc39e958185af0a..595405e6bfc736f2824a9c2e8784351f15ad0571 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1349,7 +1349,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 		break;
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SIZE:
-		page_table_check_pud_clear(mm, pte_pud(pte));
+		page_table_check_pud_clear(mm, address, pte_pud(pte));
 		break;
 #endif
 	default:
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 89abba40e3e426c00e6964bdf135042777319588..841494ef46ee6ae1410f420dc7d0a99c4e1958cf 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1093,7 +1093,7 @@ static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
 	pud_clear(pudp);
 #endif
 
-	page_table_check_pud_clear(mm, pud);
+	page_table_check_pud_clear(mm, address, pud);
 
 	return pud;
 }
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 7fd876f8d828ea70def7adc51cc17e70d3046e35..3eb36a36058face6aba92efe3eed7214752e751f 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1330,7 +1330,7 @@ static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
 {
 	pud_t pud = native_pudp_get_and_clear(pudp);
 
-	page_table_check_pud_clear(mm, pud);
+	page_table_check_pud_clear(mm, addr, pud);
 
 	return pud;
 }
diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
index 66e10923841691a59620da8d17f7bb7b09e6a6d3..808cc3a48c28fcf988ba2c50031fa4f317496582 100644
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
index 496873f44f67b73fc32940c956fd5265b748faad..ed3c28ebeb35b766418abdefa5cc6604c0533479 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -801,7 +801,7 @@ static inline pud_t pudp_huge_get_and_clear(struct mm_struct *mm,
 	pud_t pud = *pudp;
 
 	pud_clear(pudp);
-	page_table_check_pud_clear(mm, pud);
+	page_table_check_pud_clear(mm, address, pud);
 
 	return pud;
 }
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 2871d9c453682ba922b2fcf532cb6a7d867ad952..2295bc9368ab9cc827ee671ff9abf18a6b738172 100644
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
@@ -253,7 +254,7 @@ void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
 		return;
 
 	for (i = 0; i < nr; i++)
-		__page_table_check_pud_clear(mm, *(pudp + i));
+		__page_table_check_pud_clear(mm, addr + PUD_SIZE * i, *(pudp + i));
 	if (pud_user_accessible_page(pud))
 		page_table_check_set(pud_pfn(pud), stride * nr, pud_write(pud));
 }

-- 
2.52.0


