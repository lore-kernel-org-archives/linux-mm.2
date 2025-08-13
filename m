Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70A83CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 06:27:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4CF90003C; Wed, 13 Aug 2025 02:27:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08EC48E01B6; Wed, 13 Aug 2025 02:27:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF9590003C; Wed, 13 Aug 2025 02:27:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D6E048E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:27:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6BA713768D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:27:43 +0000 (UTC)
X-FDA: 83770753206.22.C6B205B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4CF601C0006
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:27:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nOx1qaJp;
	spf=pass (imf21.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755066461; a=rsa-sha256;
	cv=none;
	b=ueulnukmLh93Ysm4cKZP38IS+B7OTZ3pXhP8gNI/zM+OVlIllTZSZMCNaupNuJtPANw9F2
	VqptK3ghjJTtJpX0Nj9xcfgmqiUlQj34GTm7J4hkqdW6DwaYRBDIft//jQZU+p0r2KP8RS
	HtBisUvvpTraQCWK9hb0wT+KSGbqpSg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nOx1qaJp;
	spf=pass (imf21.hostedemail.com: domain of ajd@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ajd@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755066461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ZOEttN2rinOqPM3cuyvY6SprpUS3kDw9u6bIHVAu1A=;
	b=KEu9waICAZUVBsZOqSJYKww6U09WabcrKUAFRQ46XpKl/xpRXFe4UsML5CCIXtIJMifZKt
	+Vqb3DLvxY9A5rEsY+XdyaiOWNFIcuLZr+SCkaSuDB6XuYDykuc2ib+8cuw6LgieH2V2Z6
	E+qW1FY8xFIYe1dCBz84s9ojwYfU5CY=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57CNjG1f017423;
	Wed, 13 Aug 2025 06:27:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=2ZOEttN2rinOqPM3c
	uyvY6SprpUS3kDw9u6bIHVAu1A=; b=nOx1qaJpqPQg2UnNMpRydf523LcLIcK2g
	pROqgLtKw60+K1rpy/FrMNkJsylA+74cE7neoKrOENWN1X72WPlPyF7bGdL2VnVX
	ELIVS2DeKhM5XXG8dx6FMuYeyX7ShhFnsmAPNYGmm+VOrx9Za8B9nKfNqbf8fiit
	iLqIL3DpPaqMoEvzShX8ddxyE4tF6OcZ7IbhnNmxOGgGoO2hNXJZ63j2XRePgnCN
	syCITXWYpaA6wPEfg+GF4mv/04UVOOzcfI6CEzqKOYcL3fu7BT/tvyUYU+4J81+I
	vP7NjPhKHPd5fEO0pzZWDVgXzYcSWyIjuwUf2xzuh5Dc8cOuiyqkQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx14jvmm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:27:34 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57D1gaao026377;
	Wed, 13 Aug 2025 06:27:33 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48eh21657k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 13 Aug 2025 06:27:33 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57D6RVeG52822466
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 06:27:32 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C19555805D;
	Wed, 13 Aug 2025 06:27:31 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 18E8E5805B;
	Wed, 13 Aug 2025 06:27:26 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com.com (unknown [9.36.10.70])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 13 Aug 2025 06:27:25 +0000 (GMT)
From: Andrew Donnellan <ajd@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, x86@kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        pasha.tatashin@soleen.com, sweettea-kernel@dorminy.me,
        nicholas@linux.ibm.com, christophe.leroy@csgroup.eu,
        Rohan McLure <rmclure@linux.ibm.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH v16 07/13] mm/page_table_check: Reinstate address parameter in [__]page_table_check_pmd_clear()
Date: Wed, 13 Aug 2025 16:26:08 +1000
Message-ID: <20250813062614.51759-8-ajd@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250813062614.51759-1-ajd@linux.ibm.com>
References: <20250813062614.51759-1-ajd@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: s1VsPG9a4-EfnJ3hk-oJCaydBbmyxgNA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEyMDIyNCBTYWx0ZWRfXx6TAaH0BbdED
 HmLduwEf92ZBFwALX5DF/r4LxVOpNSr64WQNNy8ORx055HQEyEI6QBUyi5c73ilc3rMUeWPxSMm
 B1i5mmDah5Ol81rfdXKNaLhlp1ytqoakAROVaOPABTo+U1csb2pWMlA8IRNaU+RJyFRJoXo8uK7
 kFRLjeYNcvtvR8dmpPK8GLwH4yAqbclZQ5U786CMQ5NktCEQPKLm2nqe3PqlW/c6068ncmyqlqb
 gjiUmUbzNwe1B957/VBkGHJQ9K2y2Cswm4T5Q1QJOGhwaWDowM3VkAVw7Hfjo4Ml+3QZdL8mYxh
 bzhbs60n3FtP71oLsvFva6w4b/u3KrXKIcrQrLMP3+2RfEJSnm3jy74PG1h0j5qADcUaloZoLgi
 32BkEJqp
X-Proofpoint-GUID: s1VsPG9a4-EfnJ3hk-oJCaydBbmyxgNA
X-Authority-Analysis: v=2.4 cv=fLg53Yae c=1 sm=1 tr=0 ts=689c3056 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=7ipKWUHlAAAA:8 a=VwQbUJbxAAAA:8
 a=wZhGIaPSpsofiGV4ShsA:9 a=gpc5p9EgBqZVLdJeV_V1:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1011 spamscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508120224
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4CF601C0006
X-Stat-Signature: pj66njueds4q8fbedrtbyn9xraaw3ftd
X-Rspam-User: 
X-HE-Tag: 1755066461-412984
X-HE-Meta: U2FsdGVkX18/qrw8Q/qmazdifS6uMu5R8byD29SEU53XjmYcHMKnH2UtM9edng+XaBTNOo68AWpV4hArNLVH3axXOjDE5Yd6Ojx62T2SBbhl/7xXBW/NxLMV7goiRDFTxDJmIIp256KXPOfuAEWFLrw0kNk+vCd+j+0VpB6S2oEvqT0pFDQWhSWUihk+AWRSrP2L9DIQsBCBx9VZAQT+c56HDaw+P7D95hLd/MQf+dxg2AzYQ0LDTIFnBy6vVmojdsa6z9uUjA37/ZrEe/XgYNQllVQk1B1rxYvHOXpr0cEnUVpNUVlsR8kpkJ2jiAMbURXZuvlCymPYycXU5j9Pa3x7fRhdOJt1qBmZATow/TcCNDE7DEzClZe4DyTDdquJjxXF87Eyjt686CxXNOmXMe0e6MFinLGrimMBILGhv/AAUONbZQWvW1pMq3kYbDyadp41kFreI92thw4WCzUXdkQmdisjfu2wTcsEIRdL18Wd+qCrU+odjMXt6IMD+31PqX+y/4qXSE8zABzugIU9zas4q6hBnHYVSwsyB7q5a8Wc+SEYXNXwKa6++iTs6ucIn7hn1DE41E4g3ykb6ZrBOQbY/2jtuBR2ThBwckjanEIijB1OMB3yv4KPQWYOWZYSKjWg7aHfFn1mObfltHrNDxmXktsEYTfk0+OwV4HmyWe54yXEYe98pWGFHzcnCs8mtLgRz2mUqDNVshOgmfEDgMlsqlaCNFpAZQeb9B/bDq6BRJbieh+5MtGede21SW+Pqf5a/OzUI5pBhctv24EgMHvECBJx+8/zWmY41lcbqE3/COQyF9TM4jHJse9yOZekq7TQPxX/0FnRpdJ9DByYpCfOqL5W38rhbr/TBQSKMf+J0zJT/rUb9Zhe0JaW0ECGms0Fffqaata5OENi/fkd1EWfL9ueYkQqMQq8qwc/b+52bViJLYGo0XX98l9Fc0fhFnxfI+Xx5QUTJ39wbmE
 iFIi+tMM
 DLPoGGVR/guxfsFOftj+4ApvRh3R1hP4pCqSBQrwJCJOrHTxeU/r35A+KfiFspP4Sbw3u1fzIX2zf0Lbf6/vG5OvG2Jci/SQyzymRPY3DXqPwlfLSK+Rrgyk439ZmULQunRQVc+ybHsSQJh00kr1s+4Shcn8tO3D8PFcDkvxM1B7fcvF84W+7ikWqeVrEMDB79qKSZChkpYedWxEE/+ScjxY1mVl8zQ38LV5y5tS0oOSP8I5dCIOp99FOTtKsQNpdf23FtvloUpwe3Xrc3AqI+qJS+8I0PmU/DFsgnftINBd0F+YLM22mLIlLV3LVT8BoJXGZwqYaNxIg+qdJH2kJMHi3UQqcXlkt5uQGxTW2kNS+MAQTRcoGwn5E6Q==
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
index 81f06e5e32b2..dfcdf051b114 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1370,7 +1370,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 		page_table_check_pte_clear(mm, pte);
 		break;
 	case PMD_SIZE:
-		page_table_check_pmd_clear(mm, pte_pmd(pte));
+		page_table_check_pmd_clear(mm, address, pte_pmd(pte));
 		break;
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SIZE:
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 2484c0788012..d11fc6333606 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -860,7 +860,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 {
 	pmd_t pmd = __pmd(atomic_long_xchg((atomic_long_t *)pmdp, 0));
 
-	page_table_check_pmd_clear(mm, pmd);
+	page_table_check_pmd_clear(mm, address, pmd);
 
 	return pmd;
 }
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 8b45e0c41923..b68bea15f32d 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1318,7 +1318,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm, unsigned long
 {
 	pmd_t pmd = native_pmdp_get_and_clear(pmdp);
 
-	page_table_check_pmd_clear(mm, pmd);
+	page_table_check_pmd_clear(mm, addr, pmd);
 
 	return pmd;
 }
diff --git a/include/linux/page_table_check.h b/include/linux/page_table_check.h
index 808cc3a48c28..3973b69ae294 100644
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
index 28fcff844b63..d97f40f1365d 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -648,7 +648,7 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 	pmd_t pmd = *pmdp;
 
 	pmd_clear(pmdp);
-	page_table_check_pmd_clear(mm, pmd);
+	page_table_check_pmd_clear(mm, address, pmd);
 
 	return pmd;
 }
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index bd1242087a35..e8c26b616aed 100644
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
@@ -231,7 +232,7 @@ void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
 	page_table_check_pmd_flags(pmd);
 
 	for (i = 0; i < nr; i++)
-		__page_table_check_pmd_clear(mm, *(pmdp + i));
+		__page_table_check_pmd_clear(mm, addr + PMD_SIZE * i, *(pmdp + i));
 	if (pmd_user_accessible_page(pmd))
 		page_table_check_set(pmd_pfn(pmd), stride * nr, pmd_write(pmd));
 }
-- 
2.50.1


