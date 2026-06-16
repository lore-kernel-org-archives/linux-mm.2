Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 271C0CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:42:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B24D6B009E; Tue, 16 Jun 2026 16:42:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7631B6B009F; Tue, 16 Jun 2026 16:42:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651846B00A0; Tue, 16 Jun 2026 16:42:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B99C6B009E
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:42:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A110120208
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:42:23 +0000 (UTC)
X-FDA: 84886948566.07.94E3F69
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3E651C0004
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:42:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XNhQy8AT;
	spf=pass (imf28.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781642541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RtC6xXZI5/qI+GEgefxFjxY2EgB/VMaaG8KnUuml/B8=;
	b=kvVRshV+ihEj0A0/Y3cIu17PZ1UMySrNwu+/+Sq+eyuipl0WA5cA6KGyHMlQGDnv7tudqr
	VEd+3UJfQopQDXroOrqxFnxLtbCgFoF7dSuY6YNNG3T3r5JUpwEbkhApm1u4zlnyKYWose
	Lqluiogs76PRH5fVxHvRjWDlyyIbvwk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781642541;
	b=NpfDNnC5ZcIMnUrDbe94U9N7CykqYs97J7HEX5gQ3kEIXy7Zidq6NgYfp/ov4ZwleRwwIM
	ZmpqcfIEpLS3D6wSLb2v11077y8V6y9vxMuriISuG1+7rIGDlrEt+eoMXJtAOsUs+k+ayA
	w+eYwB4cqzi6aTDQsIeVMBELcXSX8jI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XNhQy8AT;
	spf=pass (imf28.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65GAIxkh1397303;
	Tue, 16 Jun 2026 12:40:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=RtC6xXZI5/qI+GEge
	fxFjxY2EgB/VMaaG8KnUuml/B8=; b=XNhQy8AT8z36DXzyW+E1NMUFlQ95Z/23X
	4T9EUjL4GdHPerFcxPCv4W/HPjANk1yp8K1DNA4j3YnXfTN1VRG1IYxxAoM4Z9dw
	C+DH1R3vSqIaZVrZWOPGIhESg/FYnGrtAql9eAPl/xsKqt65bz1PtVduR/jgnIpm
	EFLyuKHmISX8JJWGOt6O6vOYQJJiWbH6Gs5gYBGtj3RHlq28tRS+5k7HGhWp3gFd
	LLqMw7GOFNUtJQvW1/dKJaPhPOvFxGVR/yUS6A8Xuzt9Ztx7+yPXopDeOjk/vHrc
	w+sLPNRkJIrDXy9usEn7Tl5ttnS6vv42ZfNx72jKi71Viv0bR5ESA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4es1h85pvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jun 2026 12:40:45 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65GCYbYS030945;
	Tue, 16 Jun 2026 12:40:44 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4eskrgb46n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jun 2026 12:40:44 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65GCedFq61341964
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 12:40:41 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C231720043;
	Tue, 16 Jun 2026 12:40:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A39F12004F;
	Tue, 16 Jun 2026 12:40:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 16 Jun 2026 12:40:39 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 89311E0E11; Tue, 16 Jun 2026 14:40:39 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v3 4/7] mm/gup: Cleanup pgtable entry accessors
Date: Tue, 16 Jun 2026 14:40:36 +0200
Message-ID: <991ea4a061aaf84beef65573d9919f7f5992c6ff.1781611976.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1781611976.git.agordeev@linux.ibm.com>
References: <cover.1781611976.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDEyNSBTYWx0ZWRfX5iW+k+kZ/Ino
 d51K1dyJstUTzqYh+doxSM47ATBfJhyHHSUxi2ufnwIQDIw/DJwUauBwiald/068RD+Vos0wLj+
 6R7xBOr020r2iqlmiOHTcHROIFmVbn8=
X-Proofpoint-ORIG-GUID: akg9qP7F0ogCshEKnnxDK0hQcqAT-4dI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDEyNSBTYWx0ZWRfX6CHOU49hV+cE
 Ph4sg+3axfiGcKxXmSIcaIHGz6cw3erwejPRcve8wdTaSNjGXu5p1MU5mA8A4XYEEmIl3WAQF2v
 /NyS9UXOHpEhSxKDjNaHtNHdkstwrgFiQpkT7kqLnTUNcCSkIPV5Hrct9NsywnuAiEgQa5LwBgA
 l3sZFbGurMHMyvIkj3Agqs+RZZL2birtCKg+YEtPqhOgrnUig2pTLtBYoAGuY6OzEnTT+hKETDK
 ZkwkEbWWaRd3jT8PkSZunTnIROADHoTlMUlthtZgh56Hcu6aontO5q2jHOhmMAGoQ350HpeeStj
 1nQr1vktDPahZreglkWGKQ8WmxSbdLRmvgPJ9Rt7a8WLLxOP0Fj/Ce1Aq/MrmhXBpx/h6/YqJYg
 7rvtktejs8JQFQI9bqPqAGjAqHtKYde49yqqtk1wvApFkLWbMlbS8rFA0cRBkgYD6Fs+0lUm10z
 k8Mulvr4Ro4sezqEqag==
X-Authority-Analysis: v=2.4 cv=U9uiy+ru c=1 sm=1 tr=0 ts=6a31444d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=YUJdHbaOY7yOrIJlIOYA:9
X-Proofpoint-GUID: akg9qP7F0ogCshEKnnxDK0hQcqAT-4dI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_03,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 malwarescore=0 suspectscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606160125
X-Rspamd-Queue-Id: 3E651C0004
X-Rspam-User: 
X-Stat-Signature: 8ajxrmmhsw7kdoks4xkgb8n83pbj367n
X-Rspamd-Server: rspam08
X-HE-Tag: 1781642541-307047
X-HE-Meta: U2FsdGVkX1/E9Lfr9WJk0zAiPSRq7WeCRczDrE2K+8MpcGe+8+OWq5D6xf7rZuvHKam6893Gr3KISsExPcPCi4Qv4FCOMrVFMXWUqMFnLsLdSz7zAkb2U1AZ8ueJTE4x2us0b6djSiDvBlMK852UqDJ9D+1qLyigy3n3658+ivcDf+yHKkvkAojWag3S7UEdMqIHg5Q3zxJLpACXR8+xyEemyNaVyew1cGRpXO1UjH4Uj3TS3mOJR19SAcENuoHtPZZ+ewaTCyk+k+Gg+rCK6axiIlCkS9FcLl7oelkntDSAiQvt457XbBM29J8/VB1LwaI9Gytw5tPSj2Sh6Snhwt2D2HeaTEjAX0tMN1iSUH2xOP70GM5cpad7p7/BHQaGZGOmGylG0zgJuXsJO5qVDbaihjrVkc727Z5UUw078rYtY3j7fqR81fgllEjAUONDZUaRibJxwliOWPwr+Rdd3yVFuCzJ/qM6HUq+06yYI+bKG3L37C6Zwt9Q4M9w5vH4eJ2H3s2lRvFUZ5NF+tyK4up56A0KijDJXw7p7O19vrw/CvxGi0NaSn3QKplvnsaEEuhLxj6KdpFO/ZsPTbIETlN6dHBTjEKiV9eO0oFUwkjTQXYw+rd5LI/VJQsA9uriSmEGg53AYA9BE7/XfHp1BnqHB6RsSYlGyCUQmTanrqmDn2Mn1a/NgYKZ2f7hXMnD7dWMWzooYPufYvrYGbweUz6K6/woCuaUIHHqppSsnkXQ2rA4vAQPwcECFm+Bf0mzs15rVRDT4PQ2RJQS9p5S0sAS8lEPsXYQvWMGjJTND0lz+7dY6ptmDh3ZpXLPaLRxnOMyCe6D2zYdggizzjovFMb9F+ZYnCxCynaOBQrjDc4+I8Oh7Iy4HBX4uTjWWGdLu0x8innU663Je5KSPspGzTzJLIj3lcFtUQolWJ9okUu7893wE876Gskc2Ihm/L9I92t92YKXkvVE4mE9w15
 bKBx8nrp
 QqOgUP7A3U6B4dXskZ4Bn5qoMgyDeJ2naUoOHilbdQRR8TVZl+1Pa8UfztiATMx7qBP74pDbsslWx/WdhYfI7Va8rZ3UhuClHG3Qf0AgMm/D5QFqJV22FTMiG3RZeurxP+JgazXoKiemarrDpEeB3Ek1UzeVuUzQuLO8+ihvZNxOq3j3NBDR5Dan12cdfbxTslGpAKus1nMDUBUKirIWf3GU817CIu/iofLZajc2p6Oww75zhHPSUprcfXWNp7e+bOV6Qh1AD58zLPsC54w2zTcFNc1r6A0cTcyxB
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
index ad9ded39609c..0692119b7904 100644
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
2.53.0


