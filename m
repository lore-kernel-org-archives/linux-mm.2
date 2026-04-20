Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1FB5F36C5C
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 12:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCB856B0093; Mon, 20 Apr 2026 08:14:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA0896B0096; Mon, 20 Apr 2026 08:14:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A5E26B0099; Mon, 20 Apr 2026 08:14:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84C0B6B0096
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:14:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 436A28C8F0
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:14:03 +0000 (UTC)
X-FDA: 84678825966.23.105A57A
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf23.hostedemail.com (Postfix) with ESMTP id EB5DD14000D
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 12:14:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=IVfsdlNl;
	spf=pass (imf23.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776687241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cvEiDRHkSJC9NkgwggfewpK0vAH7q26Omd0hwxaP2mA=;
	b=XpDPMcye9sjeHOzR7IwVrHomlCcRhHQmwv7lLjihBzPzRIQ0F1lkKhQB0Zr+IDPcv0QhDv
	M/NzGFP/HBGtHPKytlZI/O8EyEKwKmFFHkv2YMLCo7szXA6VHoQd/TT/b4ELE5/R4udvnm
	GZ2eMWeSJWHaEifPUtBJP/W+iExDgJo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776687241; a=rsa-sha256;
	cv=none;
	b=WLJc6/9vpes5XnC9Aql0ZyjtZNxCCEj4s0i0uPaTIebM8AyDQos/ciQn3FWg5owpurKw7m
	aTtkCEfb69XD0jWHDGTWT6GLw8M488mhYu6cHoTomkchtLxLd0CLhjFAi6ar9p8Mm8M8Rr
	FJBsF45PIrTRTP8wnahHolLKRQiCrt4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=IVfsdlNl;
	spf=pass (imf23.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63JMTQob3932971;
	Mon, 20 Apr 2026 12:13:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=cvEiDRHkSJC9Nkgwg
	gfewpK0vAH7q26Omd0hwxaP2mA=; b=IVfsdlNlywhOK9bbDw4XdwoBDyUKLJdzf
	PQXaDWDj5EStdde6mqVV3UIIFnbpwN+a3cMTwiGSLPshThq1Y8pB4c4aecgZa8pV
	T6J61/Vn1Eab1Kap/TYXOqpfBbCjVf33mTL3mQkFf4QmtpeOz8Xak4EGIb6QmW65
	xee74aDDLc8nyITdcFQXrSVCsc3xZ3OZBP4O4cr293b2qZ1AemlgNLmEl7ee8tLx
	GeCIsU5HZ98P8Hc+ccmrEYMOJL1R+5dprz42XwJ9B/VCw+KlsrmLI0vkeNwmxEQX
	eLuBXQnOrn8jA6ApylPfIl5jb8OFcJ4gRDazti7ZOb/Je2KApbpeQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2k0pyv5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 12:13:57 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63KBoJ9g000714;
	Mon, 20 Apr 2026 12:13:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dmpgg4h6e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Apr 2026 12:13:56 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63KCDrHV15401436
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 12:13:53 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 166552004D;
	Mon, 20 Apr 2026 12:13:53 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E9A8320040;
	Mon, 20 Apr 2026 12:13:52 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 20 Apr 2026 12:13:52 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id D3F53E0876; Mon, 20 Apr 2026 14:13:52 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Subject: [RFC PATCH 2/2] mm/gup: add lockless access semantics on entries validation
Date: Mon, 20 Apr 2026 14:13:52 +0200
Message-ID: <55c295e17221dc882e09b4caddc7b3bf4f1309ba.1776684344.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1776684344.git.agordeev@linux.ibm.com>
References: <cover.1776684344.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jXvI_MNlPs8AO8j_dEPj7oSPim9ypZZr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDExNSBTYWx0ZWRfXz/QF65KoWDtK
 E1FOB6+IPNHkS+GDRifBZBNX66NiXeoKsA0R/VZmYWQKJMzp9RqUIsPSHtPIzrgN4R5xPo8BV/I
 noPAnWlY5JTx1ULqNCc9tTgw8IBX+xCgvbaII5Nl4EDctWuo9jdIl9ZU8Qf0bxVRkwMgZPDhHQk
 DOVNJ+RI7kbD2NsSRQxGthVdJQny0YR6v6SQ9gJVKOq2P3ZMmo/cSTU8IX7UzpW4VRUhi0p43Va
 HuLhnksJXA67Zeka7aubicn4Jhk9urIrKCVSU7kcHSJAQFEFT9/6yZ+ZqjRaT2X6m49xpFz9rQb
 /kgYd9yGIlNtx8O/A7jPZjfhGq24eOW+r5OqhDBZvsNGh3kGn4L1Cdb0bUOeL8qCO/FoM3cp/fs
 2USk7Luc8IAUyx9dSlJyNnUtptEF25moBAGPKf1+JnpxLw+BFw5WeVLXzd7ohGSpPB2KdpaDHvj
 eiXOmzOwtEKWWpvTBHQ==
X-Authority-Analysis: v=2.4 cv=PtujqQM3 c=1 sm=1 tr=0 ts=69e61885 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=_g_KzqHIDP97zNRR_5kA:9
X-Proofpoint-GUID: jXvI_MNlPs8AO8j_dEPj7oSPim9ypZZr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 spamscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 adultscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604200115
X-Stat-Signature: dpu4gdumuydw3156r1oabbadeopqtgtg
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EB5DD14000D
X-Rspam-User: 
X-HE-Tag: 1776687240-428324
X-HE-Meta: U2FsdGVkX1/6gv+EUv3pEA+d7ZLWpNxN+ovv43GJ9ZgYv1oA7CQVg1x8CGL1ghLb6m6HMjgxO9jNVN0cSnWUfsijAr2FHp4rqMbOuwPV+COCr/h75sc9BhVIZfcO3fFzzEqVNQSTpo04RyOa+rvw5hKkqewgfODJxoQkLFflp5tSh8UeWezJzOrtuWCsDAytjU9KiRVq2obmCFW0Q2sba3nQbut9wNE2kquCQaFPyjg8QumMCD+1pbRIQDLoNt3UlJyL+lFfYTQ81q9uXIeZ/L72Tpwb76EesVFVFq8XWWWifwmrGiJZvZ8thzTuRRNPf1n/Yb819rSK8YrMR02r8Unv7jtMusj7WX1be98RqdxkdmyT8xQIrs2WOgznlOcUKt/8C7Vi+QK0x6oBApvYGgJ2hT+XFXqxXjK4WATLPIhpTbAI+eCIMQESD9g7n8SDHozDg3G3Pa4OYvF4IAGhlZVnmO5MgDVMKpdzUaNN0XydpSpf+7/ntz0Dx9fV3ZMpHUa+zQlS9SdCndlhPfmhzMTmTTHj4vQFRt1ET+37daR+cG2uP4feQM9rdqh2auPS0sdQ0tYfhVwv6krMGGI09tEWqqMGjLlAXDZEl4Rh7jOGeyyN7P4MzDB52ytL/AQd98dW4SqPFy8KYoxFb7EnR+yhtMECg6+D/UXoZVt7Tyc7OcVEkhmvuQAJSAiCoUJ8/GN8992Qx3RGssjC3NCign6vnZnFvGHQmC9E4dNFMoavfxN7izlXewPOOMMVOGKu/HEzTQhTOl1hEoVs8TOvodKMYkx/uf6FVl2y2Z8o39Pvqvvc4pii2OxjvX9DW2kGxMpRNFS4Tx6b1hZSVBHxWrcL0ywkOOMabmJd70gMoVrptGtITZjCu/j0hoLKzfcs+JFl05svZ1AM7sKtWn8rTui96Em9sHj9Z0stbNzFtD+YCdgU43ecQ/1n0dInfqB40kvjSrmyD7PUuO6T371
 Px0Bxzg9
 qht4TfNmfkZkR3JK5Q7fPz9db25ixBLA42xTSvjjT+k6cjl1HOrV/O9GZ4HfUYjYJAY6p5mjLcNnAgdwC7XMudjmQOudKklP4b4K1OzkTHSkboJ7Obci2cH3Udb8NapSnjqo5F1ysOuYHlgsgwASuSpSO6buM/u4/KMf7gYDa2okoBWfL/+KhxS1CZ98hK/SQ7IqqZEFJwzhRFQRds9iIN4NdFDz/Bawm0+NHIMgabelMuChTNIN8OeiQGAolzGz5XmHvgBoQFwN1XhUltzNHZ7DjrGyhKm4qRnSPq7ii8X2PXO8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The PTE validation in gup_fast_pte_range() is inconsistent with the
prior value acquisition in the sense that it drops the lockless
access semantics.

Although this is highly unlikely, prevent a future scenario in which
a semantically mismatching ptep_get() incorrectly yields the same
result as the preceding ptep_get_lockless(), while ptep_get_lockless()
would otherwise return a different value.

Likewise the PMD validation is inconsistent with the prior value
acquisition in gup_fast_pmd_range().

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 mm/gup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index d149a4b0df71..236450feea9a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2865,8 +2865,8 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmd=
p, unsigned long addr,
 		if (!folio)
 			goto pte_unmap;
=20
-		if (unlikely(pmd_val(pmd) !=3D pmd_val(pmdp_get(pmdp))) ||
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
-	if (unlikely(pmd_val(orig) !=3D pmd_val(pmdp_get(pmdp)))) {
+	if (unlikely(pmd_val(orig) !=3D pmd_val(pmdp_get_lockless(pmdp)))) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
--=20
2.51.0


