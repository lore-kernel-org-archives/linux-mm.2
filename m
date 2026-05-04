Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CBDAFF886F
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 13:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E377F6B0093; Mon,  4 May 2026 09:04:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7F06B0095; Mon,  4 May 2026 09:04:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF156B0096; Mon,  4 May 2026 09:04:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF58B6B0093
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:04:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6FE19A01A3
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:04:47 +0000 (UTC)
X-FDA: 84729757014.18.BF5A26F
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2C700100003
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:04:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GmAQ1Pmx;
	spf=pass (imf05.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777899885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pO3syqtmoh2yTQJQGazJgax2lJ/9P8ITd+L4ibUvkII=;
	b=1OOK74J+xgj1twzlhX8bgrBk+aR/jS4ubjUuOA88JGoPu95U+CnlhvWqDb2QcXCnBGvFR4
	kMewWXm4lsodLyuzzL3mbF+DEMOpJdMIH5UscsiEqAROPL6BxnMLjzi8cIS3LFQvNnv9IL
	Indd0ZnlKIVGYNP0ZpfmObIcuy0Z8QY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777899885; a=rsa-sha256;
	cv=none;
	b=T/V634CD4HXvhs64DeoZWHTLWyxfzSxiVqcWCrbbIWGsn8d1yCi/pAjnkz19uWJ2GmpJEh
	C7IOoCq54C1acIz9vcaliMDfFcm8K5iTF1FcD3sJdfm9vu1fZR3SQvb38/mVG0NQzcD6g2
	hQbeSMWTnzYke03B29m5KVj6RESl+XQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GmAQ1Pmx;
	spf=pass (imf05.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 643MTQ7e3010004;
	Mon, 4 May 2026 13:04:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=pO3syqtmoh2yTQJQGazJgax2lJ/9P8ITd+L4ibUvk
	II=; b=GmAQ1PmxHsYC8i2ze1kzDzkIGKgnV6pXDEsTxslAziS6dBxgvj/Js5uxX
	cri2zHYh8DRnRZlM1r26gG6WDxl7Fhg6y5glBtdUPXlCVKf2lpa+5WCF1bw8oiwU
	3l6969zRBaqHre27gS7viJZSIMJRzMeS0o6CWMz8fdlILI0VwkmRBoNeQndZzLwZ
	K7NeiCsFQoE6c11aqr2hcCIsuNT80mZkUM8npQ+asAv/0cZwRHzlnBTNYor4T4Br
	Vt5Tagujd+S0GWxN7Kzj3eDp3iSWgV/WO16aljwkh9ES0cXqvL+fpDXsHlzHIORj
	/7vc8jX18ueUa4AC3MJ50Ilfsc+1w==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9v772gw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 13:04:38 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 644CsNUA030028;
	Mon, 4 May 2026 13:04:38 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwx9y4xcv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 13:04:37 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 644D4YGZ61538808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 13:04:34 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 756792004F;
	Mon,  4 May 2026 13:04:34 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 511592004D;
	Mon,  4 May 2026 13:04:34 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon,  4 May 2026 13:04:34 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 31603E0BD8; Mon, 04 May 2026 15:04:34 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Oscar Salvador <osalvador@suse.de>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v2] mm/page_vma_mapped_walk: Use ptep_get_lockless() for lockless access
Date: Mon,  4 May 2026 15:04:34 +0200
Message-ID: <20260504130434.2285053-1-agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDEzNCBTYWx0ZWRfXxv4MVpWLQ7+4
 opdcsqJrR0GT7NRlU9JzyOPcWPqDpek8+IcJy7P7LDtKJe5m/zVJgjkNfeIRL2p6cgSkXCFd0v0
 OInNujcUlcNhR3J0Jp+6K7NiUXJbI3TjTTFDU5AuYziBDJgQ/buOteS7eG/YXMsqOAZhkifs/E4
 2CYI+VqWfpYE0poyYtke+/kINrKOkheB60+7Mv5hUjHaZuj0ffjy0AlGzKLQOXF/PC0w/NidVO2
 TYvp9itY/1XppDwgFXk9F8y/eZhJ6PCfjuIyhhLKdgfxW7vMrt41zugrK2tB7aQptxCGAL2K5OT
 Yn/i1a+E4Gxn7gnT+zaxuRzrmkZlwXsf+TPuoEggculwXivOOfQsMBNYJ+MvyHhlnTqGL9UouIX
 AybfzTYttrBJzFPzTE+RsXDy3PkPr1fQN+mFdyTYWPtUBnWoZ5GByM28Td+umc6Fvn+iQ8XB3TR
 g4jTy+3TDbYvMGbZI+g==
X-Proofpoint-GUID: WeqN-du5uoGuTeZAEmDisiPRQdC4IUAs
X-Proofpoint-ORIG-GUID: WeqN-du5uoGuTeZAEmDisiPRQdC4IUAs
X-Authority-Analysis: v=2.4 cv=eu/vCIpX c=1 sm=1 tr=0 ts=69f89966 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=8KbNvkZQz-Byi51b31MA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_04,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 clxscore=1011 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605040134
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2C700100003
X-Rspam-User: 
X-Stat-Signature: 5j8dq1nypsrjqg8z1mx7nbtyt1rdszwu
X-HE-Tag: 1777899884-57176
X-HE-Meta: U2FsdGVkX1+v9RNre4eUX9NEak6zgCnQ/zkO6V/UE3YvBCIVQ811P5q4MUTbkH+FAVCXCLSBlpF5qxHW8KP+w1AcsJqoqDmUIXOA/rZ7mq5oaqzxmG5QBwC0EFHwQ8XeEXzE/RSHKjDURFMumyQ8VImQ5s48bx+0jUKo0Nnd6GUcBLORuT4rnrLir+PZRyaUQwhVo95j1mD25n4mHhAQXhfgXlrdTbKdlq0ZZwlI71sOwZFcVf+aucENaXAUbb90TijpjV5Q6Y5XQygyZhoHI6i2XmlbOqxdvFcjH6QhvBUPVg0WWdHZMnqk+orQFRER1/0gEgeDhLuDrEo57ADsq7zyGFaIObGFgAlseBvRk5tYhPSDZPYluOQ7bBA+NCGzZtIPfdfHBerAKQq7fN7LBfuIOQgzKxtj5TQ62w3K2irhskteWD4X2Y2i6fn77v087dX+L1jLhHItrAv0qrJk5S1BgueKQop691tSBAM5ucnyxVhuwyV2wuOhMWPZ+HfSTgW10VJhU7RSToLw5sN3PGiA796x9dmAK/EIU82B+yZ71wX5SyH7Pmv1UacVVkLRe1H3iDoR+prhjebeZBxsiFbVa0e523oG1ui9dPCZFs91Q/WEx8wgjs9Ctr4SBt8DViMFVZp0/LW49QtJ7K7o9tmXZcbMffYfdYw2n+5DfuYbfbVCB/QVT86sMXQLyxv73c+QOnh41cw3exiwNJQQO9gIQ/lUtDaxkWF1xM7r2HStHfg/Bw0RHepWRyFhQPK44zqnLWjQieVsJj8UZDeYG+pD5Dcg7q9eFgiSC8taNh/fu+VLxp9FenADsd2Jha76R0kdktNhEgF6Tnwy/FXSkdwEq4XOMJgsZjZS9au7nZcQ+u9c9ESPdmxk9aGw3tq9sv1KliUDs4/KyWtjsyGXLddRiGj7wmQeblUw+GBUlVdV9knJqDga3O/ZyWiGwdjzf+mwqu3CIcQrzn69/Kv
 mc3bivh6
 5doX0QcNsVD1fefzNkgqWbVQs+xbz+iSnMxBu7HUpSi4mJ0XptImUkN1W2dDKRcqyU4h/XLxiJ1MoJLz9mTb+crGFv0vhNaYpJmYsAP4/Gb5ac19kgJ9UsJgXNqpposHOC/3CLkIVTz2oWkpxPyFoc5dfV1GVLqNtmEU5ZX3XTxJr/elDoqvk3v4trfZlAxVzmlfCXAOxOoShnpWBv3eLppEYts1ReevfSTGre9boSA1N5rqvXK9wQIZiUuRf9xiSB66JgZU7RKDdAuA2hE8evPEUkVmCjwXp98hDn55M+feCnX26wSjQpAGKs3qtaUG4b01HVT+pZhs546zN6Hw/XavEXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Switch from ptep_get() to ptep_get_lockless() accessor for
PTE reads when no lock is taken.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 mm/page_vma_mapped.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index a4d52fdb3056..6559e17f11c2 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -41,7 +41,7 @@ static bool map_pte(struct page_vma_mapped_walk *pvmw, =
pmd_t *pmdvalp,
 	if (!pvmw->pte)
 		return false;
=20
-	ptent =3D ptep_get(pvmw->pte);
+	ptent =3D ptep_get_lockless(pvmw->pte);
=20
 	if (pte_none(ptent)) {
 		return false;
@@ -310,7 +310,7 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk=
 *pvmw)
 				goto restart;
 			}
 			pvmw->pte++;
-		} while (pte_none(ptep_get(pvmw->pte)));
+		} while (pte_none(ptep_get_lockless(pvmw->pte)));
=20
 		if (!pvmw->ptl) {
 			spin_lock(ptl);
--=20
2.51.0


