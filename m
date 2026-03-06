Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E735FCB61D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B42766B00B4; Fri,  6 Mar 2026 11:16:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B032F6B00B6; Fri,  6 Mar 2026 11:16:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A19426B00B7; Fri,  6 Mar 2026 11:16:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6C36B00B4
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:16:51 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 448C21A0656
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:16:50 +0000 (UTC)
X-FDA: 84516141780.12.34C359C
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf30.hostedemail.com (Postfix) with ESMTP id 97A018001F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:16:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=MWKA3yLd;
	spf=pass (imf30.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+G8YAzU9aZ4wHaSHLLYbGlbpJK697IOJOmxNBpIK2i4=;
	b=OKWAgV23d6UGIYvChrxHhnpYjsZAUijqzMjKO/CjtmW3fpT+vW/7B7qVtwQSg6FtcWGZwb
	P5wRXtmOIvSykXW6kQddlFJlKEKO9FqCa3+HDf4Ja4t6SvVH9Gg8ZJ0D+i3R0F5tWVfYz0
	31LuFnavuzh0DMvi9lEt2fFD2uiNiUk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813807; a=rsa-sha256;
	cv=none;
	b=RAG+Ii9QRuzFERKbVXHpnyMIKbvARSCBpArHDWGrWNJHy4ped8ODaRCVixTeffM+w8n5zZ
	2inKqA1EdLkoz9tuoobu7NyhvYT7SeXqEUN9aqK4pSsGobezYOI5V8PykhPTply52/nIV4
	gbQgENOzsiRbW1ikNFFKeeBvX9zOYz0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=MWKA3yLd;
	spf=pass (imf30.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6263HxfH1457437;
	Fri, 6 Mar 2026 16:16:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=+G8YAzU9aZ4wHaSHLLYbGlbpJK697IOJOmxNBpIK2
	i4=; b=MWKA3yLdHbUL0Z+CCDv1QCB4T3rbF9uIaHW3wDIXi9GwyeLJa05dtLG6m
	D/XWX4VadkaCcjr/VFcgC8BYJgVFTHrnCQlGWBKZpsp+bZqdPe8HWCKGu5XZOee/
	XyFoSiCGUncOrzAp3PC0iteD+QCIkssWQNsSdimkARZF1Qk5IWtnyiNGm3+ZVTIT
	94FB+vyrdv/teO72Enezf+CKOBVfh8MWVL+q6Rfcfu3diZC4HhDEv2pUxFRXdDMM
	rkOIkl/wHCwEHtAJAMDveQUgLSIQQfyJDfsVg0b37VpbE4eEwtdoK53mlWdfVzBS
	0zPzdC+XfyW8voVjdHKjDs3cFI/7w==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cksrjhg6r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Mar 2026 16:16:38 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 626ETQ4X010327;
	Fri, 6 Mar 2026 16:16:37 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cmc6kgfvx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Mar 2026 16:16:37 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 626GGXVv22086118
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Mar 2026 16:16:33 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B7692004B;
	Fri,  6 Mar 2026 16:16:33 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2CEB620040;
	Fri,  6 Mar 2026 16:16:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri,  6 Mar 2026 16:16:33 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 13D53E077D; Fri, 06 Mar 2026 17:16:33 +0100 (CET)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        x86@kernel.org
Subject: mm/pgtable: Support for page table check on s390
Date: Fri,  6 Mar 2026 17:16:29 +0100
Message-ID: <cover.1772812343.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Rp/I7SmK c=1 sm=1 tr=0 ts=69aafde6 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=WsTHFn69kSnc_5uNAH0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDE1MyBTYWx0ZWRfXz7XFdJ/VpJJm
 opiQLgcTw3l/dib7koF+ZwarAMZuXE76kXtrZUVa+Pf/c9GCVeg9EO4Lg/eT2AsuLtH/MHzpsGh
 9kSejWQNGueM4b6u4kPv0D21crlPSIPKL5/yszro+QzKd1Phh9jjRo5phDJRgQcebwFNLQfDxPN
 G0gjKxm2EOEiLlM/ZIcyKO2hLIafG7r17rRi10wih2qg3TAseSQ1K2kK6wnmZHsBCjpbBLu9SM1
 d1vpGY257ZVm/u3Hl1Uat779TQCm5c9Yo4KDanQS7qVkunnOtc+iUGEc93EaxQomCr/WB5dVcpd
 x4J8LI2eJpWyMiFuAeJggXqy4xo9so8AcepmuGK6fKgFj2v0X89F+316Ujonxr3Ft4Uf4P90L37
 w+gfcnnveoypMrWN2lj6kx0JLYL67mnB192pj30rqSi3N7I8S+RZUpvEGvZLl7T6PNbl3VZ8YJ9
 MKs7N0dUuyHTDkmBitw==
X-Proofpoint-GUID: WWK__Q3nr7cGNKzcN7KeoYhaVB95iFrP
X-Proofpoint-ORIG-GUID: WWK__Q3nr7cGNKzcN7KeoYhaVB95iFrP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_05,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060153
X-Stat-Signature: oqpscd6bp6md4xiqydd8x7igxn45i7m3
X-Rspam-User: 
X-Rspamd-Queue-Id: 97A018001F
X-Rspamd-Server: rspam12
X-HE-Tag: 1772813807-855962
X-HE-Meta: U2FsdGVkX1/5cjXe1K0EwzBKpJp1PpgchOHMbd2RJYYyxmOJLGadiXzdIPV2WTSpM70RWo7Z4wMx2G5755LnrdZTxV/mIwlb3dPknk7UdN/K3Euok4z4lCLNS3qXdZgvkkQVqsaOkbf9C7RUuwt+n5k2/NW5MXmtzlHIE+8zHA+igAvv2CK/dudl2YVav6Rbd44O776FlzQgwcA6t+w/WN5QsXEcPWjN5TIdcLOga2ymqYAyl0JQiBnAJuMXUvfDeI2NbEf1p/bU6/BypyF2JsH3q7vNJnxlCo8+G5wN94jFeCH52eoepDwwaYZUMpEFEtBssLoWDI3C1HH3xLsGv1Ne3jgyMWR7kZUwZYPjOyJ891IfOzD/3KBZ4VTEtxG/h5Uyaj4ONz/HCskBEUfEi7RKCmQm3lkAAkr3rpWFTLhvv7PLFY1TT0KaAsHVL8NzI567ydmldyKpMM0L1UZUKKIwdT75Px5cXbm1K1+I+3KRLOgmbLra1UmM/S2zqOoqQeljrBaQuboRyY6d9IvlQSCU/vbbdXfZWk65z0BJZ/0PILwlAKTX1X1+s8U9lvH9Ss/AR37bHMMEba2Z8uE/Jn8Mxnk7/XgpQ8Fp9aJNLHcDkLWIsqekbzUrmZi8bhq5WFf8iCLgzOuTzBiKsLgQykb+SlgfYafw87wbNVyr1AcYxhEdFZ0aU7E4qItMVVKkKgMjryOgKAxUg7b6i/Iv38m21Jdgzet70UazkAlR6yg9mUH+b4/hc7C76B6fO5eAAYbkyMU0fcp3eICiH6mCZjHL7lI/AGgalx/Wa4/URVrp1CBqDWqSAvkcQR8KhlCIBViKJ5IQUWhlWrjgTtDXiPkHhzoSatN1FEXYr3YE2h6beDwZrZHa10RHKm8g+kmgxG2XNcMUEN2QPuo4+SRy7+31cHtE066sG0c7AsWjhYdldF+ehWnUm6VCfwE3OiVhLlPGRNkjzKLFmD5El0x
 Ta5e38rL
 aN2czyFpPATeUscMMefUOutq7j9DBUyHg4LjZ4aaedV40PGl64eW8tL6v/+w2q96yIFhfDUXouD94BBlwd+14Hs2iKUCdpcz/mQmbAcsWuPtszBaoQAdE6l6xQz3OERj8iz8V7CQ644ZMNyEWjd2MC5c2kprq7hY2MbTCxxlJOH83l7xtTgkvSPhaCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All,

In v7.0-rc1 page table check support for PPC was added, which
conflicted with this series v1. Thus the only change in v2 is
PPC headers update, which still is NOP for non-s390.

I only did compile test for PPC.

Thanks!

Alexander Gordeev (2):
  s390/pgtable: Use set_pmd_bit() to invalidate PMD entry
  s390: Enable page table check for debug_defconfig

Tobias Huschle (2):
  mm/page_table_check: Pass mm_struct to pxx_user_accessible_page()
  s390/pgtable: Add s390 support for page table check

 arch/arm64/include/asm/pgtable.h             |  6 +-
 arch/powerpc/include/asm/book3s/32/pgtable.h |  2 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h | 10 ++--
 arch/powerpc/include/asm/nohash/pgtable.h    |  2 +-
 arch/powerpc/include/asm/pgtable.h           |  4 +-
 arch/riscv/include/asm/pgtable.h             |  6 +-
 arch/s390/Kconfig                            |  1 +
 arch/s390/configs/debug_defconfig            |  2 +
 arch/s390/include/asm/pgtable.h              | 60 +++++++++++++++++---
 arch/x86/include/asm/pgtable.h               |  6 +-
 mm/page_table_check.c                        | 15 ++---
 11 files changed, 80 insertions(+), 34 deletions(-)

--=20
2.51.0


