Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68CE5FCB61C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51976B00B6; Fri,  6 Mar 2026 11:16:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDE916B00B7; Fri,  6 Mar 2026 11:16:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BADE06B00B8; Fri,  6 Mar 2026 11:16:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A30CD6B00B6
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:16:56 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5BF9059C33
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:16:56 +0000 (UTC)
X-FDA: 84516142032.10.CEA1260
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id 17A994000F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:16:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WBTmsmxv;
	spf=pass (imf12.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLTBtbUx77gzumExkwQ+UsZaY5sqhpu/Y8wOE2jbbEc=;
	b=5OBUmmgTIg/FnYtwa+f1ur8shtPMXTsa9Z+hxNWNn0LBeZ4jJffql7TFmCSD5jnXtdv2R9
	xTXRdwm/KAFKIsvr/LdIN2WThDNyPGiXcj3notwg6mkP0LIkN008W9oncoh3AKXxcmceEB
	qcwSCX/Gz4Qom5CC50FsZT40fGY1ZHc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WBTmsmxv;
	spf=pass (imf12.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813814; a=rsa-sha256;
	cv=none;
	b=MRM07L7NfjbQzcBjjRkAk9mIq3fZnMUfW4dsUxfdL0vQkg4lUokkFnAZwSPl4t2CTwrosP
	j5C4teVHJfKC7G91OQyGvJTqYpzntNi9WSRO0inz67+xIEEuQy6OvCC1GG64h8cWkb6Jf/
	X3kIytkmzWg24znI665uLUBi4ybn8uE=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6267lN2m2100389;
	Fri, 6 Mar 2026 16:16:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=VLTBtbUx77gzumExk
	wQ+UsZaY5sqhpu/Y8wOE2jbbEc=; b=WBTmsmxvk8iyjPHSdlTpr2YTLvS6K+CA0
	PrOilBrKGR9EZ3Yw5wwcGokyjRG4tLnjQm74rXetTcvfcUU4Nbe4VKIKwDxqWLr2
	gI00c0nDm5OGDM528Xw4QPFRYuEUIV4jqBK9N6Ogf5lgO82ft7eUxQWfKHduln1o
	aLPCMRzzqs86GoMc+Ad6nDE2eefM0+Porj3yL1NSPX1PRkLFIBsTRAt8rZktcSjU
	Ch0Iz0PlCHpmW82MKLKQZmLSEJS2pfdkxbnsjhX+nOwYlvdlO9/5YXydeAjac2Lv
	Z8Z+JB7UtbhsEFvvPRYmckfaNYhlu5gyaSYB6a13pxND7D7MD870g==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cksk48udd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Mar 2026 16:16:37 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 626EMNp8027692;
	Fri, 6 Mar 2026 16:16:37 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cmcwjraae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Mar 2026 16:16:36 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 626GGXVH10354974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Mar 2026 16:16:33 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 653FA2004D;
	Fri,  6 Mar 2026 16:16:33 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 36A9C20043;
	Fri,  6 Mar 2026 16:16:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri,  6 Mar 2026 16:16:33 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 1EF1CE078F; Fri, 06 Mar 2026 17:16:33 +0100 (CET)
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
Subject: [PATCH v2 4/4] s390: Enable page table check for debug_defconfig
Date: Fri,  6 Mar 2026 17:16:33 +0100
Message-ID: <975007c27f8563e46d66a1fbb4b14ae6a4147edd.1772812343.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1772812343.git.agordeev@linux.ibm.com>
References: <cover.1772812343.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eToHDjTYiyMz7a2sBJeb72YZHB1UF-lQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDE1MyBTYWx0ZWRfX25ilnaqkZ1mG
 395rxazo4o/xlOSP7O01w3hOCD2fwuHn/hc8XRx+Hh6uLMLfIsh1YZODI6BGMqB4yqnh7PNfATx
 sYO9Epo62gqmbtyYvpE12E2pUTnTzKY0REnmDUodQ/lkC+QdUjoEsTz85lJtj0bSa/7JWbHwUKw
 S4OzB3YkLOzoK5vG4y1AU3bx6TkPZISueCuc3B4/Y/PZwoAecmg8ZTwZRgn94PCGqfaaiP2+tSE
 gYsNd2oE1FXqB1stqpYj+ol8oVQ4VUYvjOAduAEbIWT5wbxteDBUiuoCMtK7Ry6mu4lNeWzjQBr
 F4pediMuqFgritMq+U4u6HQTpEGvzfw/NCtbei3QFKsPK0U1j8OSqRD6YfzdY6nUDV9RcBco5b3
 ufL3p6bKaEkmzi1BhrbNw6cErKGR1CsSps7IhNSzL7vEA0USc818VxE93Z3mKst7K5ghD14yFLh
 e709UMA8iEzOm0G+9sA==
X-Authority-Analysis: v=2.4 cv=csCWUl4i c=1 sm=1 tr=0 ts=69aafde6 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=ll0qgXPPjJRHf6HrCsAA:9
X-Proofpoint-GUID: eToHDjTYiyMz7a2sBJeb72YZHB1UF-lQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_05,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 suspectscore=0 malwarescore=0 adultscore=0
 clxscore=1015 bulkscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060153
X-Rspamd-Queue-Id: 17A994000F
X-Stat-Signature: ctywtn54sfyebdaipz8s9z7qgky6y5fe
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772813813-398706
X-HE-Meta: U2FsdGVkX18WuQyTD1uYlhTy2finI/SQfn7r0JbA6ApJalQvFg25y4FH3ZBqoqDo6DZak7bXO2sx8cx9xGgZ/aZG78QWOUlihSQZTIWcYLVykh+pcgzHj0Vl10velOB6e2UpEr/MdE8Cx3JaAog+Z5XtL8ZZ63gjpioz5ldlqGPOd6Vil9ZTs2Ha17v5De1ZW4QwtjA3Tf+ImsbeAtrFcyFh8sgxejc2TORrEVNoF2NiSdo7c6PlpaSLAdzn/BpgBHD2+ZH0+sw4bdF6nG6UtmACQuxdpQ3G7LRz8E7neS930h+GX1ixGBmS9MHNq5BTFMc44q7jCsyS6y+g7lVCQYOLRsbpK+j8wZzigeY07ZmLq06SzlypwA7gNuaYOWT+OmDQwh/pxMXXiyHlkikXHAMFZeVzwJ9R0tPXlw6jctXtjRtD5CEzFBOLFo+LPj6PV0MsXMdvxqW67uOtcbYt/QgyZMzsPSNb/urkX/8Lag7VllEbTO+isTp4qixgDnagGX0atQZehIt3AYYgOrT9ZuIR+Qra/RluPLOw7jqyyHlvRaq7hzPjwr+oM26LfLXZ717ATzjc4S0jo/Th+10sah+m/UJoCF8QaXPFlh89X5YIzPGncdKi6EdWSsPUL3yGKsDWHEdeHB8aGpMKxZkU49DDNwk3KZQROso0ErAsigvKGWYV24TYV3wogOh4A3sywzS925TdH5PLvV+0YQaxfd5sqv5ZfKLsudt3+7lbfujhGY2P8kF3T58nQtiCj/qrb9DCcmAAyyHKS/fu2AMqnp5ENTBRTmwbxOFz0IDhOCzt75KyckAXX/lhW5QVbFENFGdOXszFH+IPGATaTdNrgujGlHgxh7EZUwVAiamM3Q1O/2hzQyKOavoc8ajzqc/7q793Gl9w/1iT2mgug1GtXZQkHN30sYkDu9nLKLBRR+ecW8pQMmc02Mur64nzGF+qzFonVoW4mvIlM/WbytO
 o5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
---
 arch/s390/configs/debug_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/configs/debug_defconfig b/arch/s390/configs/debug_=
defconfig
index 98fd0a2f51c6..12cdaaefb6db 100644
--- a/arch/s390/configs/debug_defconfig
+++ b/arch/s390/configs/debug_defconfig
@@ -929,3 +929,5 @@ CONFIG_PERCPU_TEST=3Dm
 CONFIG_ATOMIC64_SELFTEST=3Dy
 CONFIG_TEST_BITOPS=3Dm
 CONFIG_TEST_BPF=3Dm
+CONFIG_PAGE_TABLE_CHECK=3Dy
+CONFIG_PAGE_TABLE_CHECK_ENFORCED=3Dy
--=20
2.51.0


