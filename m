Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3154BFEA830
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 07:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29ADB6B0099; Wed, 25 Mar 2026 03:41:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D70B6B009E; Wed, 25 Mar 2026 03:41:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0057D6B0099; Wed, 25 Mar 2026 03:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBB396B0099
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 03:41:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F2E313B8F2
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:41:32 +0000 (UTC)
X-FDA: 84583790424.04.1ED077B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id 34EB81C0009
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:41:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DunETyhR;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf21.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774424490; a=rsa-sha256;
	cv=none;
	b=LZdw0btR0I02kY5vUsdK21VVVSCeoH/U4iMGg4p5UeEbdr6ZoGnrVK1SDAe/PZnhOTdPmu
	YFQO08fP4jUClbqR38OHcOVzl0r7YJXs5p1XvtpA3yioq2foCuCkn2FtR4/DJos1emiMo9
	uBnMzVz0R4MlkDyuBMR9tWfiWO3tvL4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DunETyhR;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf21.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774424490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PHjQr1TeTUJQnuNftC3BVHoFFmp4yAey/06pHHOJY2k=;
	b=7zBuSFVVfrFssNyFZO+fq4efn6H7IBsBU4z2Cc76RyJgJK8f62CEuIrpc16jV9W7ubykaZ
	+rneDvM+PSIcMLjVhEo6oaVFc5C8dMOUTqP+o8jbt3O0PZKZ9HdKTzaekq5we+RKVN8wb7
	0dL9+ryAHLQ2kQLBCznKLzZytsWHC/4=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62P6s0T43850414;
	Wed, 25 Mar 2026 07:41:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=PHjQr1TeTUJQnuNftC3BVHoFFmp4yAey/06pHHOJY
	2k=; b=DunETyhRgoPgP3rq4MqQ/nP1cCpqB6jYzOoU2OrU6+rtdnMnW81mkwR2V
	p0b46yOLyZQh+1rDX8daSraj+tfX+1F8G65SiLf/n2YPI2SereUl3fvLvE7PHLgB
	0V1g0zXBaCAMRWxk9wHEFnYwKgunzPRG0o9o4+08suUfgLkP+rx1pLtIm7/7AxXt
	yTH+gEsf/tNCa2/eg022dSpNVFVaRIzeK3QemttcuGL3HdLThv82Io4Jr4ueAHjR
	BwqJKKac707EsoLVQSlH7Gi2uuOlpyKG1ky4PZEd+OhSxYqqklGMQhteMjNr01Xn
	3Q3Vzi9NnvpKoNp9fmf7yUgJXIuNw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kxqfcb8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 07:41:26 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62P63YmX008722;
	Wed, 25 Mar 2026 07:41:25 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d26nnnk5f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 07:41:24 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62P7fJD959113968
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Mar 2026 07:41:21 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ACCED2005A;
	Wed, 25 Mar 2026 07:41:19 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 816362004E;
	Wed, 25 Mar 2026 07:41:19 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 25 Mar 2026 07:41:19 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 67C63E0723; Wed, 25 Mar 2026 08:41:19 +0100 (CET)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] s390/mm: Batch PTE updates in lazy MMU mode
Date: Wed, 25 Mar 2026 08:41:17 +0100
Message-ID: <cover.1774420056.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tcrSTXG4jo1D0QMxiBTsSGm3V5p9l42V
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI1MDA1MCBTYWx0ZWRfX0SKZeYKKebmU
 KMy4XYAecKVjRDlzmP2Rn+nzjSRBuW9ooSVfcWGSLUndj6kuD4688f7hbntE27niVa0SwIpKjiI
 Hznp3PyZJOS/q5UcggycOY43nqxJGDbe2f2Zg7H/E4jPsIyb7eMRSDJiyAji5BPBOtZfcNKnaL3
 JbJUJCZjXIMeS9QvvkWUik6pVQWsZD3+bQtKNVg8n7wNTjxImDjMGC6ETaTgIGVdN/yh0Y97PTc
 QtE3DIGyrVuMzOVG+gUOTMm3WePyO/lLTGHfpaDR0RICXH/QcL2ljZXbdpETkuEQxGO7aeM8C6A
 CF7CQTIIuCOlNnkghwkPW+6Zyj9/OTbofv+h+LDEMLn4GCc0joSn7jjt/QazFlTHbXYojuc/lUR
 HBaUC+NEMGsJh6nBXeZaksaum+1zX9C6hXRHdKBD7gXUNwwmSh3BTQ9jhwzrdAV2ENEi2iwFqCJ
 SLAhlAVEpxXx6anZHkw==
X-Authority-Analysis: v=2.4 cv=bLEb4f+Z c=1 sm=1 tr=0 ts=69c391a6 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8 a=20KFwNOVAAAA:8
 a=OejtQ4jW4XaKWV-sQpAA:9 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: tcrSTXG4jo1D0QMxiBTsSGm3V5p9l42V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-25_02,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1011 phishscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603250050
X-Stat-Signature: wj6aaeomg3y8gywqb44mqfcfs194bin8
X-Rspamd-Queue-Id: 34EB81C0009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774424490-194813
X-HE-Meta: U2FsdGVkX18e51fqKjzjWs/J8a4RZjgfq/celb7iHEjglyU4oCYYBUqVsyI5PL9tmSS6dC70eK4bZABEniUvaP/LaUyPw8uklcm8cepv1p7q8ruVRFFwPVNog2IeqwcWhxLKfrP9MXGLZ3wpijAMKE0/YhETl+ch+lQ5UU6d3cFu/nKRmt+nelhhL4ZTvgXfWUnx9NuQD6rG0lcphL97GFLTvS1mN/RhjN0yKOQwObs/hTL0tfjLooqsh4jDfw1LAZCxhVh2gWty29Yy7zrrpve7sTHVgzLepEui7Be8g2h4hoOYcUFb/o2gY5v4QSUcUpQqo17uLvntaA6lUR4HfpZsZyMgnm1daxZQVr8sat6TQJInIdsoXmWbNzhpTH60lKmNqwG4SFxZLzX7VaTGfx6CqEGaB+OtcNJiCpac96FBvdo5/8J0JYdZeM3n8xvYQ6MvWZtvLPg+ivLVf1M9C5qHLybztdyu13uuDB8r2EJMwvUNPG6nCG0mHxbGx0WhnZ1syGYhkOQra8tNjLhE4w9uqarRJ1kfIaiJRF66KHjF1mnlXby4HaQo8ycsw2Eebcr2Ovfdm/Pot3ygWZ2IiEAboiZ3I/gzHnIC0j3x+wLQoG6QTmNl+40LzYhwWMs9+QajxHQ5ng3TjOoeSdoVKbHJiimC9KxbSok+0cPyYnMLbCvMc3SKdkEMII6Qt7pIPfZsacu2qytqCkJw2qr3PWuQLpZFrlFYL9GS7j5WZMVzJhXrbnXdpCYnPrmn7HxJ2iTTNpaKoYvsh632WQ55/PTOylYsrkJWVgZXH+QQ13B3mK6p+mrxhgiJl7CizzJFboSKjG87HWFmzant7twymHf5/QepZ9E2hv4Vd538PnyWGGyGLk3qH9iOZcz66BrnILqwnA32D9fuFhDuR4WfvP+0o1TJ3BhCpxm9NXa4sUn2W49g2dargtjl+3yb/KrqHNDvpnD+GWgghx76x1A
 9g9MB7jX
 v2yd9Jrs5cvso7O+2poyKkcZ1wGOw0lfdeJIcYgTcjqvoEwNZmBM7igZUBLR4fmw3kQqb3PrtsG54b5G+9+pqFOT4mVN4nRnhzwPUCXkpTyD4XYgRrPL7Ew+lbjiZn4vYOFemT0u6avNTeuY1k/jT4otTKv22JOeRB4hMrvlc5KrwJOK9no5ARdiJ+NN/D5zWhnvmZq5zQhGtVXD4TTiTbPSdQ/KrTQ/Q+7MEu6uCA3d3ZhgkFN167KkwgOantNTKBXiUNOi8dC8JTdCI/lBio9RNTIZDx8vfNQFL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All!

This series addresses an s390-specific aspect of how page table entries
are modified. In many cases, changing a valid PTE (for example, setting
or clearing a hardware bit) requires issuing an Invalidate Page Table
Entry (IPTE) instruction beforehand.

A disadvantage of the IPTE instruction is that it may initiate a
machine-wide quiesce state. This state acts as an expensive global
hardware lock and should be avoided whenever possible.

Currently, IPTE is invoked for each individual PTE update in most code
paths. However, the instruction itself supports invalidating multiple
PTEs at once, covering up to 256 entries. Using this capability can
significantly reduce the number of quiesce events, with a positive
impact on overall system performance. At present, this feature is not
utilized.

An effort was therefore made to identify kernel code paths that update
large numbers of consecutive PTEs. Such updates can be batched and
handled by a single IPTE invocation, leveraging the hardware support
described above.

A natural candidate for this optimization is page-table walkers that
change attributes of memory ranges and thus modify contiguous ranges
of PTEs. Many memory-management system calls enter lazy MMU mode while
updating such ranges.

This lazy MMU mode can be leveraged to build on the already existing
infrastructure and implement a software-level lazy MMU mechanism,
allowing expensive PTE invalidations on s390 to be batched.

Patch #2 is the actual s390 rework, while patch #1 is a prerequisite
that affects the generic code. It was briefly communicated upstream
and got some approvals:

https://lore.kernel.org/linux-mm/d407a381-099b-4ec6-a20e-aeff4f3d750f@arm=
.com/#t
https://lore.kernel.org/linux-mm/852d6f8c-e167-4527-9dc9-98549124f6b1@red=
hat.com/

I am sending this as an RFC in the hope that I may have missed less
obvious existing code paths or potential code changes that could
further enable batching. Any ideas would be greatly appreciated!

Thanks!

Alexander Gordeev (2):
  mm: make lazy MMU mode context-aware
  s390/mm: Batch PTE updates in lazy MMU mode

 arch/s390/Kconfig               |   8 +
 arch/s390/include/asm/pgtable.h | 209 +++++++++++++++--
 arch/s390/mm/Makefile           |   1 +
 arch/s390/mm/ipte_batch.c       | 396 ++++++++++++++++++++++++++++++++
 arch/s390/mm/pgtable.c          |   8 +-
 fs/proc/task_mmu.c              |   2 +-
 include/linux/pgtable.h         |  42 ++++
 mm/madvise.c                    |   8 +-
 mm/memory.c                     |   8 +-
 mm/mprotect.c                   |   2 +-
 mm/mremap.c                     |   2 +-
 mm/vmalloc.c                    |   6 +-
 12 files changed, 659 insertions(+), 33 deletions(-)
 create mode 100644 arch/s390/mm/ipte_batch.c

--=20
2.51.0


