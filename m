Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADC4EEA4FB3
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 11:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF4346B0089; Mon, 23 Feb 2026 06:53:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95AC6B008C; Mon, 23 Feb 2026 06:53:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4CF26B008A; Mon, 23 Feb 2026 06:53:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 999D66B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 06:53:25 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40069BB964
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:53:25 +0000 (UTC)
X-FDA: 84475561170.26.53D28EB
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0E2C4C0008
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:53:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fLux+JNP;
	spf=pass (imf22.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771847602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VGeQemTVLA6CfGFEfwMKWDbtyAhZnxofgecnLX4C05E=;
	b=2m4d9WgWO4yaZM0hOdaGSurZABxsPp6vJy9OyA1hIQXrJB4WlItOHU2Ey6jPUxnUUWHWUZ
	2Rhj0+IsAaT9Qps4l86Da7KfGf8P1XZVPkic5ebY7KMNUnTZ/+/VCgslNDK2XHbl1Yyypd
	rOewLL5SjIQ3oegq8VUsRmACROH+n8g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fLux+JNP;
	spf=pass (imf22.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771847602; a=rsa-sha256;
	cv=none;
	b=X1+2TiVWCFr9LYQbasQ8zOKB7rnN4DkOdi6yHnAjfaoXUNJY+G6SrvCn5XDjheJOW3mJSY
	+joElAYFg4KsVgbBQiRSl2bLTBnLUSg3c0YZCYto4dCJqgMIeRGYxSKOsDpdcRkEb+ZQjw
	K10FGbihBx09PCaetrMITTNwUrctYwY=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61MNFM642713432;
	Mon, 23 Feb 2026 11:53:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=VGeQemTVLA6CfGFEfwMKWDbtyAhZnxofgecnLX4C0
	5E=; b=fLux+JNPrdMkDG7Z3qL5+oKlx39ZvYxtJ3avfWRwJsuVC5EGNOhSGXv3u
	jbLR03UIckEncl1pd02dMS9RLqrzHTJyhvzX/1PpHVRVzGyuH6tslAQtlUf7kAG2
	czFw/aV6lEWGUvfEBXlKXVSfUFsZQcSO8qKeYX0SXpBtETSa1F+MN36HPFw5IQwS
	MKB0rsLwG/JW91bg0MFil+ZwEzmqWi5Ujm5HFbCoEyXUzR6RBSHQXGBLU5sSND+D
	Nm1DsHimG71MnezeMUQ63l1H0cBiQBVID4hsRxjMRvJQ4kyRoPynhRw5tqTmkqkS
	ENCQi1nP8lHW0F3u+kKzEknL6JRwg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf34bxhy1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Feb 2026 11:53:19 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61NBVjIN003382;
	Mon, 23 Feb 2026 11:53:18 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cfs8jmd7u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Feb 2026 11:53:18 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61NBrGos44826882
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Feb 2026 11:53:16 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 890CD2004B;
	Mon, 23 Feb 2026 11:53:16 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6151120043;
	Mon, 23 Feb 2026 11:53:16 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 23 Feb 2026 11:53:16 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 3E42FE0B5A; Mon, 23 Feb 2026 12:53:16 +0100 (CET)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, x86@kernel.org
Subject: [PATCH 0/4] mm/pgtable: Support for page table check on s390
Date: Mon, 23 Feb 2026 12:53:12 +0100
Message-ID: <cover.1771845678.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIzMDA5OSBTYWx0ZWRfX3bwiMJwv1jXe
 c4r0aVkh//XvZK3EBXuqKG9B0JraQiFOc8dQcg3L6hlHbNCSPBy354nHZYbOf3Z9UZlNVi+mRux
 EeyDGkJUJBDyoK2GU1u5SyohvpgacRwgMGGKQXrxihP5qZl5F/DQuJZITynR4i1aGOv8LKibeSC
 RGxHizdZO14zQnTCKgUY1FBF3JutdD5rOSEHxXURU6zKflVN9dkdE/EozKdxlSGa0kRFjzX/24Y
 gMjuCTOZLLradKDnaisg7DvD5UIEq28QAz9KXPmGnX7Xd8oy7GBzzGTdP+VhA82rCLE6wjou7xH
 Pn921Qn8QacYVzhh+1/7F+ZvAp/qVub2x3Fl96dY16DPIf9Z59BA44ZAQWLeFBS46z37smUj8Ta
 XkNJr03kfjcFpQpwp0bZpqgJa3LePoO1YYZp/7JVKWBY2uDu6ffV8SZp7G3zh5eOU1l19MHnaqP
 oT1eC76P9C+aiIo/j6w==
X-Proofpoint-ORIG-GUID: CmD9jFH5k147Zt0zS8yAjMb88bgQYtmP
X-Authority-Analysis: v=2.4 cv=F9lat6hN c=1 sm=1 tr=0 ts=699c3faf cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=WJZKNU4qom20v2zI9iIA:9
X-Proofpoint-GUID: CmD9jFH5k147Zt0zS8yAjMb88bgQYtmP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-23_02,2026-02-20_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 bulkscore=0 adultscore=0 spamscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602230099
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E2C4C0008
X-Rspamd-Server: rspam02
X-Stat-Signature: janf7zzxabm73d4t5zqzxuc7agdxfk79
X-HE-Tag: 1771847601-284646
X-HE-Meta: U2FsdGVkX1/EEQQnacCzpYh+HQgZnz72qEPP9CLZ2r8Nf5ZHZFotRSFLilpYLHZCfeujgdas++NmRY2yRc3pZPJcL4M3eUEVPvB4BkfTc6I0eHF8aA2BlgjBacnwvWDEMs8ZlT89/xcugbf2TVf9B3LmItx9gYjRXQ4U6J24pF7S0UH+JLyEOvYQZF1oa4K383s2vCd+lCO7WjX8e8YwWjibQl6pNpWykCWko0YQgZBXNMZ1M71RuEW1G6GqSFiydJwshBIwmBMECwTHXrPRaSbB8iyz6asXS6iD2rbXC4DbYaKqzPFw1lrqDHeTx9BtJqS0NirrHjK5Cs24gTsq8KJCo/HcaWqDzRaPCyqn8KiEadADvAXw30Z+XZ0VKpTHYHE7h/mt4dFLvvGROtNEpLU9p9CT9Tv/JikQlDLX70lmIv4UJxEmoGqvGN2HiTcAdxg2uJA6obpI6YbGMzd6Uel7M+JSb3C5ZNC6+lzfalRwSmr6p3SSmap61R6/LGG32TjIcn0KOfdlpIbDrHqrdxtQHkwHBGVElxYs14DR6LJIWPHbGwUSX0VMl7r1JWdmrx4h2ILZqtSyVttCfG3/o2Ness5toPooS0JoAyX2ZlKlq3dFNs6k6Mncyzzx+oFN/A3my3m5Kztsysma2YMrtylEEBDcP6620cknIE3Np7Psr/Ul+oC2vWteGEFA2vyreB48M5Mv0ZG01bi5QUGW85bXem9h9VuyHkuZt2pALUcG4omlQBaH9tZIH3mnpSgs924oreXsLwcvO2DUcW3YgLiBoWWyPND6m0vUOhf7tFZQKQGD6nskKns3FWLgBLEDsxI+HkqSyxBrKLFIlRxuNvioxCSI3YkFCNn8vNL+F8+174FtK1JeHtq+sfEDKbXIb0gQ15mDgZh1W8bKqD7VgGHJV5Gwi2VfbG+QUCZmMYAVF8gg8HF82s19Fl/dt0OSiDn6uBNL3wHVDMc665s
 ANbLHZom
 NAON/Y5SKDbo5ywu83scWQ2GirSs2FmdBoc0we1xMcEES0lFMQG+BdDZP8KdZdsFvvH6Wy+Mdn/dG+fSeQRp4BbZgCM5lKVR65bhBA3JXwb+j/JQslYpZBX8JK2ysSpQP/pYn6tEeL/NInEE4HxKPKLnI0/7e+mU+jV2OnNUEtpbgWh0ymPoy/tcyS6/UTgU8jY7AkSuhQC9lSGK4gkIDbxVXmni37yJOFoGqiOx3dhowCGbQdxlOMpboGFKinSsYf0quGBV40PmJ/Cg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All,

This series adds mm_struct parameter to pxx_user_accessible_page() hooks,
which is only used on s390 and does not affect other archs.

I reordered pxx_user_accessible_page() parameters to be consistent with
the traditional order and removed unnecessary brackets in patch #1 - the
only patch that touches the generic code and other archs.

Thanks!

Alexander Gordeev (2):
  s390/pgtable: Use set_pmd_bit() to invalidate PMD entry
  s390: Enable page table check for debug_defconfig

Tobias Huschle (2):
  mm/page_table_check: Pass mm_struct to pxx_user_accessible_page()
  s390/pgtable: Add s390 support for page table check

 arch/arm64/include/asm/pgtable.h  |  6 ++--
 arch/riscv/include/asm/pgtable.h  |  6 ++--
 arch/s390/Kconfig                 |  1 +
 arch/s390/configs/debug_defconfig |  2 ++
 arch/s390/include/asm/pgtable.h   | 60 +++++++++++++++++++++++++++----
 arch/x86/include/asm/pgtable.h    |  6 ++--
 mm/page_table_check.c             | 15 ++++----
 7 files changed, 71 insertions(+), 25 deletions(-)

--=20
2.51.0


