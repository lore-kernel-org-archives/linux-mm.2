Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1409EC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BBFE6B0098; Mon, 20 Jul 2026 10:16:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8935F6B009B; Mon, 20 Jul 2026 10:16:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B946B009D; Mon, 20 Jul 2026 10:16:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 41FE36B0098
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:16:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91379A01D2
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:44 +0000 (UTC)
X-FDA: 85009355928.12.346A02F
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf25.hostedemail.com (Postfix) with ESMTP id 55497A000F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Ozn4iDsa;
	spf=pass (imf25.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AfXrqbcXIfe4t2F+b8Q41vcOJmYZO0QIXVrBFejsmcQ=;
	b=izV+V6dsSdpA5/TOm+KP4cjo/CouL5AQUzfZK9tFVuUp9UjSl3QTSk4QdCMak/A8NAYLI/
	lw4I1/2J+ha0ffSaBu96CzRmQCwk78sJik30xctlwiJjPuqAV89jgd7Wl2dt9rEZlsJ32X
	ARsoaUPW8ra6MJFr7QB+Da/h78M3d5o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Ozn4iDsa;
	spf=pass (imf25.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557002;
	b=r7eaNSUvcDrf4UKWtkataif9Qx0anoOB7gAUQfTuofUXu5K1wfsEXI8UQJ7HrWqj2m9Q/D
	RcNV4pfFBDe3hm4fJ0pZ2YCVGERHlM2Y9G7IwyZvTy8dtmBgvxPE8llgGPog0WeQsE3FmI
	cBE7Tq0Pz0TzdTpFRB1VK0D887uxT7M=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66KECZvT2424310;
	Mon, 20 Jul 2026 14:16:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=AfXrqbcXIfe4t2F+b8Q41vcOJmYZO0QIXVrBFejsm
	cQ=; b=Ozn4iDsadE0f6SyghnQsx0hOVMvvKfi4RfkfXt5/EhWjmRyC5yXcN5MvA
	F7Z+8GVQP6AWV/zghZc7gByt9acqxI2Fw9VisIzOSmfaPdG5qntv5M9g9BeuVTUC
	xl1D8OfDIloZXSQus0DhX6BqKbmw2wtoi3OPCMcddIEyVGe02T3727XOr6J/HInA
	lS5jOOrVoaK0anVbR5ePSp3so4kMIMG8oBUSMfjdcGmqrI7/e+UJu4EP06HzS6cl
	WWJ8hXjswaCEsWnxHRyMuo2Y6T6IMa1+YEuIDkbaaPgb8gxqbm5Zp4X48fd+o7pT
	vidQ2pRZDe5TPZZdR+C2jyd/D+t4Q==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7agykwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jul 2026 14:16:36 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66KE4lKc021193;
	Mon, 20 Jul 2026 14:16:35 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgmtjnxph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 20 Jul 2026 14:16:35 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66KEGXt757540998
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Jul 2026 14:16:33 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7EE102004E;
	Mon, 20 Jul 2026 14:16:33 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B5F020049;
	Mon, 20 Jul 2026 14:16:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 20 Jul 2026 14:16:33 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 55EF2162734; Mon, 20 Jul 2026 16:16:33 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Pu Lehui <pulehui@huawei.com>
Subject: [PATCH] mm: use proper PTE accessor in move_ptes()
Date: Mon, 20 Jul 2026 16:16:33 +0200
Message-ID: <20260720141633.501799-1-agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: a_O4kCgjToM29geIxpE50sxQgJBHyfKh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDE1OCBTYWx0ZWRfX2fXKTzpn42nl
 JjHAXDuyW2WH4EzDvfTbR2UDLrQY4+pbI0K2RdwhPWJWUwhbAN099UtZjLSICr5IEvasTS29mfg
 0RyKl/KkDm/7q62GRsj+n0weKDwEdq4HU6si7P/V+TIpxbCI28vF7Csuw+/QavaZzQWsh+zuiM8
 dFIRup48wKTPQmKTKOyV2TaDl6Y9owU1c8xTNUxMuGMXVtPICmSfbZN84CKZOCJyEOBaZs8gl+j
 pqcoCDp/P+CUDCqjQ4sOi2sZUDA2xQoZu2QLTOKxtdjufsB04pkYSEwN0rTsR1Zuk1zI9gkGbJR
 0EzGbXQThVfzbt+pNwYrFB4csG7jJl+ErlV4RRPh2JmpaDjzahkG+JTLnMi2JKI+spsYa2oBTPX
 RkPSLK+fM3b1o+eVucXVcTh8pntmuXujEcS+Nib94sPg9Ecl4IjFevVhL53uMTApeqWeqcg5X4B
 miSqj3CKDvlkbrjtClA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDE1OCBTYWx0ZWRfX76XOjq+kj6dU
 JPmZf+s9GiaO6f+Z/KhDZJYDPft5UgPUpCnj8juuDjGmEPSO/vbaNA+jIVfPsFJtnr+MHHaNRm3
 dR3aq/oKjaOOkZeFKtJJYUMHpqTSX+k=
X-Proofpoint-GUID: a_O4kCgjToM29geIxpE50sxQgJBHyfKh
X-Authority-Analysis: v=2.4 cv=SM5ykuvH c=1 sm=1 tr=0 ts=6a5e2dc4 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=5OkHitKPLxYoD-LOL3kA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_03,2026-07-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 malwarescore=0 priorityscore=1501 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200158
X-Rspamd-Queue-Id: 55497A000F
X-Rspam-User: 
X-Stat-Signature: 6jb7o1awfyu7ud6t473x9b5s7ajbucf8
X-Rspamd-Server: rspam04
X-HE-Tag: 1784557002-285364
X-HE-Meta: U2FsdGVkX198lzD5/+UwVV24qjmj2zKzKKZ1Ge7EsVYEgSSwKTrX3QBIkWf2rm24oDT5Z6Pdw4O3tIEY73dw2vqXn2bEP2aR2Iu2Q1fAu4EBsbi1CrjL9a5kDhMXsFAfYVECXm09J3gXqqkt2x7cx0qk4PoSknJn+AIvM8axUmz3GLpc/etSt1o0anyomhRj/3iltlJ7R2uYrCy3AyPWF9x+7H9GViC+3G0rcGrEbOnv+pu5YRmftOx18TnDEvKIz07/PFxPI8Z1Ex7EnaYOe66wxTioFtnpmlaN8/LG/ewYbeGBKTHS9vegAfi1wOBGaCy2qh9+/P9fQAnpOoDEmr82NjczB3F5K0DkTtVZt6XTrSQY2EU0fR3nU7vLGWtenOoeYa3acOZSGg0AakHona5jQYgM0aZ2VQ1CO3lmfoIVU9COTaRMYgdXOlJuId5eQOK5o9XfHqBt9sOv4WjsqgMMhGiyhiqG/AgoBivfRgOjqrhfBUhAJeWKvg1YkvguuAYc2YrPUImi0TPBpIL7ooOR2IbzkJiBhx6slJsu1wB1Se8Yv+zTlIqQWJR0C+oAdh5BI19BFIr9SkhNjPpjwtpZNmkr6t81BWx6AM5qQUb1FDtFyl45EM0xCFJxniD0K8xSIZhriXxPEJVO9DExaLEpTw9UPnmTLLmkun/wPbjac+tHzRe+5x+dX6TBVoYQViCdUYEd8SB3sPWNHukkUC54soVwMdR7wFffuwelN2ct5DhqBW8PNzLM9Im657eB4ZU1xGzdxTxi/JhllqB5erKHtSKJuVSy25f0onDaDDjx7Xc4Ha3KOUVomIAo3DAoIZapa1xHVwrOf/8S4KJ5+sqjN344ASQkx88FD2hyED7GKVtKJCwlkmiELIVvwC7H1Z2fevYA9fyIq/Ou6PdOXu655xyu2idQH9Zep/X9zE29Fnwpry+XuFew+O+slDRGzO1gvRpxPNQ1Fgs5kQ0
 EkJuNDpD
 ab/dMr2llipttI5bWzrhQf+yCW1wLeSIpuBp8giG+syWhSIYxpbVDybjs2Em7gL5IB28z/NYV2nDBHCC1pDe7uiDs1pDYeqbYiYVbkutAtWlgrcwA9RpsOjmBLBlkCuytWWckThh89PsCwCqEHK32YcmYW3yqjFPtsHaUrAkiLe9U9UtDngPOZ+x663fsFOAev18S3amRl/8NnT9zy0n6DyOiYDvIVFkdiHuFlYCg9VXIDL4oBnrrNR8Ne7sZd9X2SvwMT6wfaGUslCvclgmqMRMyd+ENIyFQ722c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Follow the pattern established by commit c33c794828f2
("mm: ptep_get() conversion") and use the proper PTE
accessor instead of a direct pointer dereference.

Fixes: b36b701bbcd9 ("mm: expose abnormal new_pte during move_ptes")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 mm/mremap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 0dfe3de39ccc..e99b19a9850b 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -264,7 +264,7 @@ static int move_ptes(struct pagetable_move_control *p=
mc,
=20
 	for (; old_addr < old_end; old_ptep +=3D nr_ptes, old_addr +=3D nr_ptes=
 * PAGE_SIZE,
 		new_ptep +=3D nr_ptes, new_addr +=3D nr_ptes * PAGE_SIZE) {
-		VM_WARN_ON_ONCE(!pte_none(*new_ptep));
+		VM_WARN_ON_ONCE(!pte_none(ptep_get(new_ptep)));
=20
 		nr_ptes =3D 1;
 		max_nr_ptes =3D (old_end - old_addr) >> PAGE_SHIFT;
--=20
2.53.0


