Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3F9AEA71A4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 05:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5D4B6B0088; Tue, 21 Apr 2026 01:18:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABFAC6B0089; Tue, 21 Apr 2026 01:18:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A1B6B008A; Tue, 21 Apr 2026 01:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 841C46B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 01:18:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E456C3A73
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:18:05 +0000 (UTC)
X-FDA: 84681406530.27.84358C3
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf20.hostedemail.com (Postfix) with ESMTP id F3C8E1C000E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:18:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QX0AC4Cv;
	spf=pass (imf20.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776748683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AZU3YeFW7ONrg7r/b5hmN/0MqRUY53fEOjgc4t7xIRY=;
	b=o5oFakDq53KPJxugfRkbzfTQNSHwye98Gg37tPcHCwVuJeDxFeCuxf/U97f9ADDwgB2I2j
	KTsebgCok4cMjJIbYyW8kUEpA3TZkecnEqKPWUtUSjc6XAp9CE5pKH/Wm/DiBTgSiHy21n
	skOf3j2PYvDwQBfgbSysto8aMO3HfNo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=QX0AC4Cv;
	spf=pass (imf20.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776748683; a=rsa-sha256;
	cv=none;
	b=2ybbURigh1rcb2RPSB0LkndOoT7v4C6KyeBFZTJk327NP0tpGisePa2hbjCa7ogKFCmViJ
	GAOgyE5w8nQj+22ocwSn6fCVj23/hSVfBEoiHDJvH5f0h3cibcMGv8dXnvxhS8yXqFJ0lj
	A5D8Yx7yJMtk02yB9hdKXiSj2LTs1bs=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63KJgWSJ1535632;
	Tue, 21 Apr 2026 05:17:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=AZU3YeFW7ONrg7r/b5hmN/0MqRUY53fEOjgc4t7xI
	RY=; b=QX0AC4CvueEVw3h4GuOoEDAFaevxK33+M2Zk0hm3Zh3/sORx6jCw4cBmK
	iaV1PK/JwyR1F/K9kGv9RsH2/oK5RiHzseb28/XkufM/CsPvDlV/9pwRqNnmGcVX
	iTvrtQy2akHuaoNfgtg9FtSaQ7LnaX460xi1PBOYRIm7WWI8ta+vWRiiQBW6mi7h
	SUk8PM3Ljb7NS5tvWkTPcOMl6d0NkoqSU/iY7L2hKFx9XVz2Yrc+x7/pyVHCFLVi
	mKC9x1DTjltWJ0hJT75+WhAd5/zL9YJyCN6LY7kekL2XhO49NzS3CC21DM6SV/3D
	Q0ekfWzJ9Zc43C432GZjO20Fl5tOg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2k6j30w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 05:17:59 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63L55Ihp013445;
	Tue, 21 Apr 2026 05:17:58 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dmmnvqjc8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 05:17:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63L5HsBj13435292
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 05:17:54 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E2BA2004D;
	Tue, 21 Apr 2026 05:17:54 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4C69C2004B;
	Tue, 21 Apr 2026 05:17:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 21 Apr 2026 05:17:54 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 355F1E08BB; Tue, 21 Apr 2026 07:17:54 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v2] mm/gup: cleanup pgtable entry accessors
Date: Tue, 21 Apr 2026 07:17:54 +0200
Message-ID: <20260421051754.1691221-1-agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=L78theT8 c=1 sm=1 tr=0 ts=69e70887 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=YUJdHbaOY7yOrIJlIOYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDA0OSBTYWx0ZWRfX/KjXBcDDvY4D
 eAo0sEZrBN6uqtffa5NRqRXf2z7P0NHjfKH91Ne8M4856VHIUMAYtd7zZwdfcjCIVkJ95WuIcdS
 eotWcuAhWafsNMW11oohQ5tjFOAqsCfrv6sUsZ2HLfF+dyqNqDMZf3tgxSPIWmvviLisosJnbsk
 50UnK/C044yfQZN8t/96rLydx7eDioOUa7rT04zsO4o/QOGiAOsHl2fmvnap6wG2sx5DAeHZzCA
 lIQOm8MKFdg00H5C5JMkZhnHY3yCCVWyWxUDDeBEMyDX9RIm0TAZisNp0S+30PITCuQy6qSEK1E
 xoQp8wn0DJUqPCiQhpLNVYhXjzby6WsYXUo6K3b2Xs0wY/z1dloOx16fXs/zvMnlbTYez03IQf3
 agUDzuGPIB/vrZf8JlKSPPA4G9Ud75wfpTXlQj7yQ55MSebQROQHOsBB8N3yr7JYF5isB9craXS
 sMOuZ3tRr8Sk4BJzmPw==
X-Proofpoint-GUID: Gx4gpKFdt96QBH9dX1k7Xk1_avGBpze1
X-Proofpoint-ORIG-GUID: Gx4gpKFdt96QBH9dX1k7Xk1_avGBpze1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_01,2026-04-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 spamscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604210049
X-Stat-Signature: zenscq344qh5foc5xzgud7cdbpx38i7y
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F3C8E1C000E
X-HE-Tag: 1776748682-26211
X-HE-Meta: U2FsdGVkX18VS0A8Qf+G3MxddEzUjKXeymSQuE1kJn+on2PZv7OIvkw9Rm5y1y2QLOT8coB0yVBWTdCfyX630N7OSfvY/bJbDw3y2nxJAbgOhTxJ7Gl6+3wCLC2LDEpKVOf0OQ4+MYjyD35DSDjf9l86k8kuiLnGk7IJojeF/mXgiet0aAmiC9gT1MWh6jlMiqoOWM+WR3YKO2A2g/ITVr/6nwyx4ShffCfwb2KcAUt19HIsziUJETFbw1n71XIaRzKJkwSbShwQcWEPrno0ewpjAzciK8aS6FEFgFcO0dhxfTLKBJKvkiWcNcchDckwcdxQuetkKrtu/CEGKqdp7QG78EWgmijLS+hgrxqW7OWxF8wqaSAMelxD46hJkbgL51PwIcgydR93YR3pqw84go2p/o+uaC7xF4x/tzbCpcfuNP3DvJcUJzx/9WsuqKKw15Lt7sSkl1HeIzfYEOK9KXOjqNN6dQnmu5F26ZPbVBCmMEgD5FpIthJtj5TH9p34nSh5uKzPilQyuioJqPG/v8vkvcgeve5Noz/rvYEG72HqkIAuxDlOKCiZAV2iVuGQGaHC44XtYf4B5IfquY9MYmI7v3kDFe06bKJcam7XV8rj26ptDJoYOMtUixgllMV7fJ8aYv/XgiVYfJoWRPgSiXEFnLoW6M7mcWUaRjVgAn12IBRSir7klE3JEIFHwjs5Lc1y6jeis2jPsq1IgDhgX57p7m5PY7f4BLZ/QD8hja11iHMwAfy7qBGRMa5BaG4XGuGZILFwIeemckMFaNyU3y6jx1DYi2Wo29dpBDEMb1T3S/FQwddCqB+FPyezpiRkXsrQP4H2Ckaq3GoiVd3qhGfeRZy9ttMUCcHKiQQPGaE88V3CUc/l0C3tg3AqLUp/lB44hBpYQx58763O36NqfpByp7z3vm6srQrW0hkcHgY6STIN0upSIVDdRY0TP5NRObwBolIzU42ja9kHxoW
 QLuh/z4o
 frCi66V+fmhmjYMyl7jzG1pItZYnSjfJutZZ3DLOBib/ZlJ8d80yYm5dJrsh5Bbi4xeAWqu+Kv4FxiYYJX/7TYcnwYoE3JT8BR45c0/fu2iGqqv5S5OzSXaFxM6r9Nh+phzM4fUk/M8mJSl1rRtDF/vm3oDJLRlXd284ZNBsxbmlniBUKbW9w9FFxAolONBEBPadLPN4NDtqkugU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PMD and PUD entries revalidation has the same semantics as PTE entry
revalidation. Convert the remaining direct entry dereferences to the
corresponding accessors.

The PTE validation in gup_fast_pte_range() is inconsistent with the
prior value acquisition in the sense that it drops the lockless
access semantics.

Use the lockless accessor not only for the PTE, but also for the PMD
validation, which is likewise inconsistent with the prior value
acquisition in gup_fast_pmd_range().

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 mm/gup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 8e7dc2c6ee73..236450feea9a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2865,8 +2865,8 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmd=
p, unsigned long addr,
 		if (!folio)
 			goto pte_unmap;
=20
-		if (unlikely(pmd_val(pmd) !=3D pmd_val(*pmdp)) ||
-		    unlikely(pte_val(pte) !=3D pte_val(ptep_get(ptep)))) {
+		if (unlikely(pmd_val(pmd) !=3D pmd_val(pmdp_get_lockless(pmdp))) ||
+		    unlikely(pte_val(pte) !=3D pte_val(ptep_get_lockless(ptep)))) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
 		}
@@ -2942,7 +2942,7 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmd=
p, unsigned long addr,
 	if (!folio)
 		return 0;
=20
-	if (unlikely(pmd_val(orig) !=3D pmd_val(*pmdp))) {
+	if (unlikely(pmd_val(orig) !=3D pmd_val(pmdp_get_lockless(pmdp)))) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
@@ -2985,7 +2985,7 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pud=
p, unsigned long addr,
 	if (!folio)
 		return 0;
=20
-	if (unlikely(pud_val(orig) !=3D pud_val(*pudp))) {
+	if (unlikely(pud_val(orig) !=3D pud_val(pudp_get(pudp)))) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
--=20
2.51.0


