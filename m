Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FB7DC44515
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 15:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72AA16B0096; Fri, 17 Jul 2026 11:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7041B6B0099; Fri, 17 Jul 2026 11:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F1FF6B009B; Fri, 17 Jul 2026 11:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 212C26B0099
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 11:57:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C34B1A0115
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:32:34 +0000 (UTC)
X-FDA: 84998358228.13.DC9EAA9
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6C3DB100006
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:32:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=MwS765PJ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf05.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784295152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=or7YSIsxjyCve/ej8k0RxC0Gu9rUVwFjOTsLFx+KLRU=;
	b=b4VLqMx5Oa/RYQABjm6JPCdSMEGAsEhYmVTTp7/BrlLnUVkytHtPdE2tglaPkTiqLRnEFh
	hCe2mquU+wsRodjmyv77iVktb630bhsIh1qA7XSfYiwGQNN06eM77NSZ3XkylC3VArvqvK
	6dqnjz7byq7uzlebb9RV8qBc/ssSmSg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=MwS765PJ;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf05.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784295152;
	b=C1dy4R/UItOZAps1EXi3W0wfF++K8Xelv/z1/sD14PK5d6Ylio+uVm+tbF0rHt8jEbBExE
	LTbqzTrhiHy7rekjCc/kHNdzjYo1ESYgj4s8rniuavBACOb95XYRedqX6nqMM8v5e56PSs
	KZ57mvSOdFqs9ZqXP7P3qD+JtXhBzLs=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HCfi2b163738;
	Fri, 17 Jul 2026 13:32:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=or7YSIsxjyCve/ej8
	k0RxC0Gu9rUVwFjOTsLFx+KLRU=; b=MwS765PJeaXFxgAXNqMZOKh6zPDkErKlq
	Nu0mURW6LivfW4RH7Bz5kq9NRum1WSyyqKZhF66dlkK6Iy3vP0z/uhqNSpd7OXEO
	FZ5GaPSNblIofp3mkiY+5LsaBIreWFig+05Uf+1ULVwp6+IXBMIyRY1A/I5ImcCB
	UmWPl4oaT1BIDsn+XR75amnMcxK1Szp7ipPN9ejVrcJJschN1PUh2rhy3GgSwLNJ
	kOOJhYAx3ME+hRiGRVgJUQS0awz33KvfJE0hb/tVhKAzr+92MJBX3gpXfCRI7gIP
	jQAphL1ISCe+ypZqar7i8gIbN92UqiUFsM6jqI2HzAqSOYrbqHLCA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fcv33q7br-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 13:32:28 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66HDJbh9003175;
	Fri, 17 Jul 2026 13:32:27 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fc1nhssrs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 13:32:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66HDWMMR13959492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jul 2026 13:32:23 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DCCF120063;
	Fri, 17 Jul 2026 13:32:22 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B23B020043;
	Fri, 17 Jul 2026 13:32:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri, 17 Jul 2026 13:32:22 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 993F916274C; Fri, 17 Jul 2026 15:32:22 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>, Chris Li <sparse@chrisli.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: [RFC PATCH 1/4] mm: use proper PTE accessors in madvise() and mremap()
Date: Fri, 17 Jul 2026 15:32:19 +0200
Message-ID: <3c4d3c768ebf9cc7bbc7667e0e08bf5ad2fe8729.1784292223.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1784292223.git.agordeev@linux.ibm.com>
References: <cover.1784292223.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDEzNCBTYWx0ZWRfX9kTvVNcz5Jmo
 Pl3Z3eyavgj3VadKxtd+RD+oh/mU1JqXDFG0N53D3VIBNBKOcvxeaVQLtkyE6V0rApGcYpSzYuJ
 G1xHo80wT776IJw0+74E42/G4EHswSg=
X-Authority-Analysis: v=2.4 cv=Mp1iLWae c=1 sm=1 tr=0 ts=6a5a2eec cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=qew0nP0EAHuLvkb_oQEA:9
X-Proofpoint-GUID: iDaEB2JQJhBC3xsyEdq_VH2SQVaRtzO_
X-Proofpoint-ORIG-GUID: iDaEB2JQJhBC3xsyEdq_VH2SQVaRtzO_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDEzNCBTYWx0ZWRfXy0sIwPc2aB4/
 dq4yFvqPqzzSQA1rjXzofJrLQbIAgPtHG4loanaLFSFUtqJ9VyF1nap1yGs8FzJ/l40QRhFHA8v
 46EySlpFNmLJy0Wuzbd8As+LczdjMQMWmyMp46MIuO3awjuuQd0OGSI2uIptoLWnhWstDgHPece
 kniOX0XSUMx5gz6KAZ3XCqVmVBzt1LMCItkCDnnAnuHbWmMelJxsbuFS/fQ5sj72sxJa0x4jQvC
 WNqvlVaQVvaf+Pxjxe4I6nOpJdKmifrDoo8Um/AULY9PvMZe66HFViAx83WMmKXX7MDksAsHzU/
 6okHfXih2CaBXzDWHDRTAwo6L0QK1PyLsuT/Au1xE31YKHG7FQxBsEjuBPN/OzXAPuK68LhF8Ai
 Cc3xnVPm3brph2gAS6/LHUglbpcGQTqDb+0aEOwxdqrEp/YpESZKj+11hLSpts2VgSmKnLcmBEW
 cenaUk28fAsX+21YlmQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_03,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 suspectscore=0 clxscore=1011 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607170134
X-Rspamd-Queue-Id: 6C3DB100006
X-Stat-Signature: ye3j1k9yikcxkhkthgiq43trt5m3969s
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784295152-580700
X-HE-Meta: U2FsdGVkX19gSIPVQaXhizvFETlyF2bn79rLRe79ZOlxpuV1v797WN08MwYV4wH/6nDiGbz9C+ARaJ6apyZghWv0lsMQI6UXFRs9hLeZ2N3KT50z4a3p9mFaSTE8PycRhM59CD1H1Y2fxh2Wdw/Q7PHYVcP2U6zRv+h+cwrlb2ENaMf0V8dDJCbkR0xW6OnhJ+ctZx/N5jJEBgtJAw1LR2y6h39jsQtRH7cSHuPrqc5p22y9qUw99h9XptWHMRtzoiPjUaNV4YJ0E2VxqFWAMVaX3IkcXdQNdIzdjVSmAc/xK1cSaq4dFMK3pnlachSFKqnfhoPyr1MFXTBhdW69xdVLqd40UMgL3v2a4wMUiEjyGhr70q1m9GVK8i6vCeLWeRCpjBbX0xgWnwZj94bA6tZGeNmdzchpdDUtFWRmG4+1bzfkpRu6fMBcGiHJkQwAisFwrRdj2aninBFuAWM63DhTiPGGcR8hV7+zQzji5LGB2rV5vhHazNkZUndqtuBEhkI47Tp2wumg54JY3t5IVOWXdttIYCPMeOrsgNRPy7G/gQDJmQuCsfXeg2H1nE4Fo7LHgTSGie5Zf66wPWIJ5kCk/P++yTGPv2kiTnAVBQJmhg7o4DTKAWZYI3zVkry/UEeZB/izNYOcMvFFbiIfWPW7udSRp/OZ7unAfGugz3lGC9z9AcW6ATkvG6vK91MDRl/gKASu0lqgW67qPO5Z3AvNmYPZxU3ZQMKsP9LfD4jcqw5VGeZpwOyFu061/jFBsTbaGKH3rFmmEXf2DZXzZjnVAPJjOfl6IEPUhyvM0QWLLCrmzGwXIqaa9Pab4uYpNW1//D8c51PClFdU3dhCIpjYeHDwvK1//d01BZaShnQu/SXT9wzYy9MSNE4XHJ4RVmzXRLW4y52tgGJZ6kT6f4r+SVo+Xak9l0FT7k6yiHplEgKrvXxGnNnWbObYGpipKgX+9KZZUaz4hXSlg9O
 oEzKuZe+
 OC8Oq3mgEdEWqghajhtx4uBorhhREYCuWiGsg+kes/r6zXcI/ECl6TnmWudHN/aoSRr50BODbDxC1f/ZLhnrrPPrdsc7n4UHRbZPXXSxsCwWSB7jAXSPMDogRmZACjbsNfvEWJZmaec96E7LD4H7TtMeyoUhKyFUr6H6r3XM1qFWbb5s9ePFEs6sKyWFwuKiuLjsVFu9w3uBZLpoRgR0k9bB0WaEO7iCybHAqyYZzJmtyeWE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Follow the pattern established by commit c33c794828f2 ("mm:
ptep_get() conversion") and use proper accessors instead of
direct pointer dereferences.

Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 mm/madvise.c | 2 +-
 mm/mremap.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 77552b03d318..7d369b1ff8e5 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1106,7 +1106,7 @@ static int guard_install_set_pte(unsigned long addr=
, unsigned long next,
 	unsigned long *nr_pages =3D (unsigned long *)walk->private;
=20
 	/* Simply install a PTE marker, this causes segfault on access. */
-	*ptep =3D make_pte_marker(PTE_MARKER_GUARD);
+	set_pte(ptep, make_pte_marker(PTE_MARKER_GUARD));
 	(*nr_pages)++;
=20
 	return 0;
diff --git a/mm/mremap.c b/mm/mremap.c
index e9c8b1d05832..fc3b90274a57 100644
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


