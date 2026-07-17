Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47D0FC44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 15:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B22346B0095; Fri, 17 Jul 2026 11:57:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFA3E6B0099; Fri, 17 Jul 2026 11:57:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A103D6B009D; Fri, 17 Jul 2026 11:57:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 670A66B0095
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 11:57:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5CCA1C0046
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:32:34 +0000 (UTC)
X-FDA: 84998358228.24.857C697
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf01.hostedemail.com (Postfix) with ESMTP id 38F8140010
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:32:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DahiS0tq;
	spf=pass (imf01.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784295152;
	b=gt7yrYXN+ddaWkB9ghl4GxyrGeLlG6/lkXo33c34KU5JJirATrCLswecwBEJmIWcAi0AJ6
	pMQRnBC5Moahc6S+4aw3uY+/LZvwXE9vRz3DNRkAfIupuafkzmOK/pIo5K7ovpRYVC8Ieq
	0FHCxYfwm2T68gmNM0wM6OV6UkXfnSU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DahiS0tq;
	spf=pass (imf01.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784295152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i6MAPSOtfow276eUF3Xe6qEnwK6XLk455QrSg12o/Uo=;
	b=USPwmx7uTd46LR9uvJymWo8oiJOTVyd7DNBI9FVkCl4e3nl8kirFGKD3i7iFs/UEWORab1
	Q8rGng6qlc0330G09HGDsXFRfIStIUSZ50lB+pbzmxdOO7UF3kZXrVwrkENTRo8nLZPCVD
	0Rv/H8nmHdXQ1Ab8XJXOdTX6/EpM0D0=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HCfYmE2047880;
	Fri, 17 Jul 2026 13:32:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=i6MAPSOtfow276eUF
	3Xe6qEnwK6XLk455QrSg12o/Uo=; b=DahiS0tqzO9lnBZt1OMv47D7A1v5+LAPj
	CH/aqiWtGW2afMScSS7jImNTbPkh5RAH6Tnr4pB80eq1TQjd3bccjHTHE1/LBQo2
	L0CDYVqYQ2VxW9k+3ydbl+TSdGTLYtZD8PbjjD8tWyQhGSLTwi9m7ABLjQDr2Ese
	sETsMvyhQEnopaN+hidySqnqgNrmzEJPFnfwwo2LEQ2t5/nLPAr/+q6QX9KnvP3+
	khQG25yOjXPkG4wd5nTqMnhUnCj3/ESUFkDgkuyfC10PIuYumi06Y07AyKzF9Jd2
	+c5KH8pNbe4ZndXT/hmsrhvmyCPUFgtcqen1rGj5/e3p+qVjQtulg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fbepxxnp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 13:32:27 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66HDJf8I018515;
	Fri, 17 Jul 2026 13:32:26 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fc2uyhjng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 13:32:26 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66HDWNik43385300
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jul 2026 13:32:23 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E2A092004F;
	Fri, 17 Jul 2026 13:32:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B7D462004D;
	Fri, 17 Jul 2026 13:32:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 17 Jul 2026 13:32:22 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 9F8CC162755; Fri, 17 Jul 2026 15:32:22 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>, Chris Li <sparse@chrisli.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: [RFC PATCH 4/4] s390/mm: implement __ptent-aware pte_t type
Date: Fri, 17 Jul 2026 15:32:22 +0200
Message-ID: <2580c0c643125fb89247f255ff42803bea44e4c3.1784292223.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1784292223.git.agordeev@linux.ibm.com>
References: <cover.1784292223.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: K1SWd8x3gKV5j6296YUSXLjfWYwZ0oEb
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDEzNCBTYWx0ZWRfX7TV/eW1/02Ov
 JzQPvI2jpf+5VWdWMs9PhWmVgV08H6ZsSKAg0H8CKmpvqOTtt/7d5lvVO8eOcj9g7VVOscHu1YV
 bnA+FF9164abOQHuAMg3/TR0FOmz71Q=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDEzNCBTYWx0ZWRfX4HNVZADoQJg/
 uMaLhfDvH65JzqfMxrRVIYFXA9e1KcfaEiSOeHgBeR+XI2KKeBpeX2Y0xq3WF1WW1zfZZZtOenD
 tCqRLPGgtL/ojBmRQL6CD7Hmvv0+53SBL0o95bAaP74aoKXGS2WD0iVBYQe+DgwoeJ3vllGrZoS
 e2wUCGhyU0+qxH6qBHm7mVDkGsMsXJbsSzThm058DUFXPdIk85WdwsL5ws9rWj2tESFeA9iKLLQ
 E9VcsHCo1QFuZPF3IvRZoD96l2f/oUHzWiwz8oaLtxkLSSgCKqsIhr0lQlTHE9D5g8yMw8Qy44O
 96q1AZ0gd4N6D4uh62byEprqyBaTWYnKkAtaRqlIPEz2NsW9MtUFSO/GJr4VkOHnK2USGOHHB3W
 VzHBQlzMl7CsHKqR/V4PhmOI5YRA2vl5e8a7YYOY7FsDO1eS7cQOLpP2JqDj+yz9OfGZeb6qeKe
 vm/wb93jdovnJ/3/P3g==
X-Authority-Analysis: v=2.4 cv=XbS5Co55 c=1 sm=1 tr=0 ts=6a5a2eeb cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=xjXagFC_2LMuDb4xjsMA:9
X-Proofpoint-ORIG-GUID: K1SWd8x3gKV5j6296YUSXLjfWYwZ0oEb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_03,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170134
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 38F8140010
X-Stat-Signature: 431tgyaggur5nfypbekuwiuysay4r6yh
X-HE-Tag: 1784295152-545404
X-HE-Meta: U2FsdGVkX18eCM3CLMSCiyWkwJ6eimAG4weImqgwGICLw3LtVGr+Euep08+hNzWYI+tqSbD4rt/mffnX2k1RnOpRi+N3sMM+mrJ5RM7HDDVsvi/JYuxlEMlaElslHqGGO/3SX9rN2nzXCfBu2Bi3KzwzUP2yxbA1rPZjjZ7xtPHCnVgSMeZlkj85oojEKxMPyFkK4Q5R7giNkX16G6wCHzElehU4TM/8/6ZG7iilrbc3ddS2T0WgL+Od382nOtF94moY3RF0We7kZROmXQXVkPjnwKOap81x5IIDMfBbEN2pDmNB1gaV1DnQvxiIvvkYoEDml8WVoGpVnCATKcvF4eCglPNy9443CN28ez1R2y5aUm3YT/iT15kGGakfv0v3Kfwb59L1cMoiIQWePkcnpHbZmGBgVN/PYBuIiVeyTcMKzzT4oSwbh6Mwg58wVr2MrJRoB8SuPm+W6LOqpqqNk0jrmD/KPPSnlUBbQQPYtk1TzBbw3LWiEu+K0GRwfiU0O6+UwmOXSnOqdRmpaRNJOdPJclbGkf4kztA9ChDWWoCGOQbG5kR/8ogR2yRZqMNTH3t6HhMZv4JgxIUhhp/pbRUNWeOzAtbizeK7JgFSLK8ikqe32i9TvCOSKm+ZC9Mhz3jFg5LuDn7JzMRHdnYVCBI7WXHK6c+XL3V7XuyM7IJHP/hifl+MwRwMO3DsjVoxUOPd7FINRuA9nyqiHbfYGijogwppyQSz8fgk/5uVbS54dOD+8crUseLNEqhgBg/ZzOyh5851LRviKFx4hkLTSI7rQIl1HdORTcZ2TUAHd//BA4nn61jX2HPZUGA6lFOcZybtkUo5gJv6xcJ7e74ajzPOYbKyiIriaNDlv0zjGLIxyPpcISXAPsXRb6/hCOjjt9XGf4NNz4E2XYYApyoLm8EnShMdipNB5Zmt/ytAJuUpiHCcP8MF4oyrJkqKQUa753U795xq5Wzl4whvTUR
 HAau1WDK
 gvNisEdFvuE59w6A37p2O9SNq8lyuPB5a/ufg7emwvMLHeC/iGlUbakYbTR8gHsLpf8kK/VP3iZZwrUBKyvoLUoWyq9B5gvA6iaoEIpDDoBzF7P4+3RcBIiZwmrzBvNj2WX4X6ZAV/5qN+jIvWjmB6VH3bH7ZUzxxqBiiEED6yLOXMeP36iy+sgQqhPEBwyuzHlWMEyJlJHXIiurX8/tZLz/O6GMmHtXgRpldC3Mw1EmA5aawfqsuU3qlhE+ALfKoSDIp/W3r46SZFblz0vUpUISSQH1Fpg5bJIs9qM7X9Qg2C5RzgzLM1/sPhxP2b5v2pSkYHG3HhOajScbL49lzdorvVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 arch/s390/include/asm/page.h    | 16 ++++++++++--
 arch/s390/include/asm/pgtable.h | 44 +++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index 56da819a79e6..ce68994a0292 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -76,8 +76,10 @@ static inline void copy_page(void *to, void *from)
=20
 #ifdef STRICT_MM_TYPECHECKS
=20
+typedef struct { unsigned long pte; } pteraw_t;
+typedef pteraw_t __ptent pte_t;
+
 typedef struct { unsigned long pgprot; } pgprot_t;
-typedef struct { unsigned long pte; } pte_t;
 typedef struct { unsigned long pmd; } pmd_t;
 typedef struct { unsigned long pud; } pud_t;
 typedef struct { unsigned long p4d; } p4d_t;
@@ -89,6 +91,11 @@ static __always_inline unsigned long name ## _val(name=
 ## _t name)	\
 	return name.name;						\
 }
=20
+static inline unsigned long pte_val(pte_t pte)
+{
+	return ((__force pteraw_t *)&pte)->pte;
+}
+
 #else /* STRICT_MM_TYPECHECKS */
=20
 typedef unsigned long pgprot_t;
@@ -98,6 +105,11 @@ typedef unsigned long pud_t;
 typedef unsigned long p4d_t;
 typedef unsigned long pgd_t;
=20
+static inline unsigned long pte_val(pte_t pte)
+{
+	return pte;
+}
+
 #define DEFINE_PGVAL_FUNC(name)						\
 static __always_inline unsigned long name ## _val(name ## _t name)	\
 {									\
@@ -107,7 +119,6 @@ static __always_inline unsigned long name ## _val(nam=
e ## _t name)	\
 #endif /* STRICT_MM_TYPECHECKS */
=20
 DEFINE_PGVAL_FUNC(pgprot)
-DEFINE_PGVAL_FUNC(pte)
 DEFINE_PGVAL_FUNC(pmd)
 DEFINE_PGVAL_FUNC(pud)
 DEFINE_PGVAL_FUNC(p4d)
@@ -116,6 +127,7 @@ DEFINE_PGVAL_FUNC(pgd)
 typedef pte_t *pgtable_t;
=20
 #define __pgprot(x)	((pgprot_t) { (x) } )
+#define __pteraw(x)	((pteraw_t) { (x) } )
 #define __pte(x)        ((pte_t) { (x) } )
 #define __pmd(x)        ((pmd_t) { (x) } )
 #define __pud(x)	((pud_t) { (x) } )
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgta=
ble.h
index 859ce7c7d454..6398f58c09ce 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -978,6 +978,49 @@ static inline void set_pmd(pmd_t *pmdp, pmd_t pmd)
 	WRITE_ONCE(*pmdp, pmd);
 }
=20
+#ifdef STRICT_MM_TYPECHECKS
+static inline void set_pte(pte_t *ptep, pte_t pte)
+{
+	pteraw_t *pteraw_ptep =3D (__force pteraw_t *)ptep;
+	pteraw_t pteraw =3D __pteraw(pte_val(pte));
+
+	if (pte_present(pte))
+		pte =3D clear_pte_bit(pte, __pgprot(_PAGE_UNUSED));
+	WRITE_ONCE(*pteraw_ptep, pteraw);
+}
+
+#define ptep_get ptep_get
+static inline pte_t ptep_get(pte_t *ptep)
+{
+	pteraw_t *pteraw_ptep =3D (__force pteraw_t *)ptep;
+	pteraw_t pteraw =3D READ_ONCE(*pteraw_ptep);
+
+	return __pte(pteraw.pte);
+}
+
+#define ptep_get_nopgtable ptep_get_nopgtable
+static inline pte_t ptep_get_nopgtable(pte_t *ptep)
+{
+	/*
+	 * Ensure this is a pointer to a copy not a pointer into a page table.
+	 * If this is a stack value, it won't be a valid virtual address, but
+	 * that's fine because it also cannot be pointing into the page table.
+	 */
+	VM_WARN_ON(virt_addr_valid(ptep) && PageTable(virt_to_page(ptep)));
+
+	return (__force pte_t)(*(pteraw_t *)ptep);
+}
+
+#define set_pte_nopgtable set_pte_nopgtable
+static inline void set_pte_nopgtable(pte_t *ptep, pte_t pte)
+{
+	/*
+	 * See comment in ptep_get_nopgtable().
+	 */
+	VM_WARN_ON(virt_addr_valid(ptep) && PageTable(virt_to_page(ptep)));
+	*(pteraw_t *)ptep =3D (__force pteraw_t)pte;
+}
+#else
 static inline void set_pte(pte_t *ptep, pte_t pte)
 {
 	if (pte_present(pte))
@@ -990,6 +1033,7 @@ static inline pte_t ptep_get(pte_t *ptep)
 {
 	return READ_ONCE(*ptep);
 }
+#endif
=20
 #define pmdp_get pmdp_get
 static inline pmd_t pmdp_get(pmd_t *pmdp)
--=20
2.53.0


