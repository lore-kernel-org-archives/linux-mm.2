Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81AD5C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:47:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7530E6B0140; Mon, 13 Jul 2026 12:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72B096B0155; Mon, 13 Jul 2026 12:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 640C56B0156; Mon, 13 Jul 2026 12:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34F5A6B0140
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:47:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D5958168BD7
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:18:40 +0000 (UTC)
X-FDA: 84983959200.27.BAAB6AE
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6BF9140002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:18:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=TXdK6rfi;
	spf=pass (imf04.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783952318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JRtrvW+eaMSaqeAtu8UUN9SOFyw4mEWwVL83pW7uIeE=;
	b=EF0KjAix936HNl5TXw6ZxOMlwkjUSDVwtW4tjgAv4HYZeN3mS4srCQCuwX3dGl61qAUglT
	ZgAc+VcdfX4mhJoZYx/haNAz7bAO4kxqSAXEDoi0KqbBWPl0djZJpy/OAbvZRUzqgJZ3RG
	o2ETJEcS0cbNvIAeu4qjzeqtyaaN5kw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=TXdK6rfi;
	spf=pass (imf04.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783952318;
	b=amla0OkDRur94h51gJTRuaBX5QYxlNwHG8eo2OpDE5ouv2cXuwBG30VVCkxRi3ZLkZ88UO
	uhOJ+pu0ZGkc9rVssiNZjYN6rnrmlAdzb3IWmoo4VzMywMOSa+IghyQ63dy35p7f/6K6eL
	Qpv6hMvWiH8YwNkHAOyHQAI07QT3JYg=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DCCw4p2433464;
	Mon, 13 Jul 2026 14:18:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=JRtrvW+eaMSaqeAtu8UUN9SOFyw4mEWwVL83pW7uI
	eE=; b=TXdK6rfinVVOvkuxcEWw2yup/kjaZdZTj5eP9o5CuVCga3KjEwC34RwmB
	CQaz5sb1GKwtz83KJoDY7maI2axeLDbk1bme2hA62g3euNpKidNiCsaYJZy6HJRL
	8m3lMxljLi9d54fLK8om9oQIeKF/PDJf5OlJy/wZcfbu1JbPBBEkwZJQYfU1Xwv5
	3GLTj5nilOYuNLLdyxeGTuEDWHy3MyHbNaNvYAkPK76Vu5IsYmkBL/v+WDVekkXu
	99kiSg+iFpCzO+cYn0fWlln4rOr57Y6qz2OhJ9CeiCsJL+7lZIMvEfYQhXUQW/uy
	hqeIK9S8H6/IBR0fN1jIaHc2+geGw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fbegbgrkp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 14:18:32 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66DE4a2L011181;
	Mon, 13 Jul 2026 14:18:32 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fc15jp1ca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Jul 2026 14:18:32 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66DEISVa43254100
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Jul 2026 14:18:28 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 35C7F2004B;
	Mon, 13 Jul 2026 14:18:28 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0F5E520040;
	Mon, 13 Jul 2026 14:18:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 13 Jul 2026 14:18:28 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id EBDFB1618E3; Mon, 13 Jul 2026 16:18:27 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v5 0/4] s390/mm: Batch PTE updates in lazy MMU mode
Date: Mon, 13 Jul 2026 16:18:23 +0200
Message-ID: <cover.1783945507.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=fOcJG5ae c=1 sm=1 tr=0 ts=6a54f3b9 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=c92rfblmAAAA:8
 a=TRBNZcfPePrm8P-CY9YA:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDE0OCBTYWx0ZWRfX2k8M+LlsJWC5
 pZLjCF/3CqDZdQLRwr19ZI8P/VUqe7Uop2zn+6bkJz5nEN4RElXdIh8aEU7P4y6QFYIu/etkwQb
 C8TwbvmOzI6F4U1D7Z5HoIFGs3gRDAvc51K2iaunRQqFto72hOwtcAw4gY+NTIZx8yvnV1oyhNI
 SkgBqIeBsg1fzg4Ov6ovFTw0UCImlr6em+QgmGVrBWQsfHvlzQ34gKqB4NjpuPggYbMvw2URLjp
 GGKRxgoy0uKXEmRyPXiP+MWuDOrwEnpeFmhV9Sj8yiVRSsDG5DvVFUNt90+r5JYCsmbCh6pjoAa
 B9q8OpSLFkZk82eXZ/qMOscd5nndyDDx4oGWU3WJRhKHb7MwKNfyxw+8OZwMTOT+cQ5bdYxuM5U
 BrIpATYzcDYbY5PYNpENODmmra74Ezr4yKPW7tk+AFO+K/e8e3bUy4FJwIsHwplR+FIekQU6IR4
 YQfJyav+64DuE7K5yhw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDE0OCBTYWx0ZWRfXzqHWo6HtNkdK
 XlOShYi8oB/NVlOWkBjfcxs57PZ5Ar4R3b3EfF4WHU0zhgISaavK9+8O1KW+TunkVg+R9bHCw8x
 HmcCVfaVsjy0GhUUHhkTgF4K1tWtorM=
X-Proofpoint-GUID: jGBqlIivDEUP-DcdiBrwMRuSrMcKJ2df
X-Proofpoint-ORIG-GUID: kb2KoN-84XjZ0ROpzliaNA6mOYIN9mgw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_03,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 impostorscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607130148
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6BF9140002
X-Stat-Signature: f8awe8xoz8eomd8earyyoha9ip4iboeh
X-HE-Tag: 1783952318-898912
X-HE-Meta: U2FsdGVkX18BAI9siGAFxoagG8wBntpzMg1JmRToqLHyQG/wXTDi8YmVXe8TXYFeqMGxZplzGh9F+BZIrBppEmeKdHzYQkGLooUiVCKQlX8ROtBya0njPNzhF5Vy+or7Zs0EO3dz5I3RPWPio9tJOXBuul3+VzIHQEuKuvWL5Linjq7fA/ayDCApMHInTq48kyJZI+jvGCn4oJjMmFI78CJOPPhmFfOdiSYbDcxQvF3Gj96OXg6tobfSg32dWOYliQCWgNMQintTiez93hda012FAXauHMOaT+RHlnn5ezNd/nUBeKkq2Poa2v2DeyKQLYLIjcH7eDD+sd5/ot7QGn3bSSdO+HYBYmCNffcUHPI5VNV0IucQJ90fp8npUcYCNv1blFONp8XFIRIqWUeyIsmeRYKew2EgvtVvNFRg4uF68u0FFAYeR3Kg29MjtDrnArr28jN/g1syhptaxWwqElNx+3A9Zq83MXXqgWd9P2LGCH1Q8rHqbzoAGNAdjUwuj/xQyoF/CtVRNcVG8B+dpu99TtXVGt9TsnjXhB4GDh63/ITBUwqc4RzchVDIQIVECsFW0n4q9PgsGnXgg2BHE1hT71imQk75a/hdC0Y5B5wYbQqX4Y5gg2fvMNhrFx+ICL1AMaoZ8iQ9bXVgRVpK0IA25boGL7i8u08OQVRxJ/+6IcoS/7B43nuCsP2aJBYi2N5o+A50q7dlf0a5Jh/HRo/3+qpMSrSJSoboUrTY5Q+yVuh8M7x0ZLoCDHkPnlOQts19Lon4WMIz/ANz/xPXOQ9z/+GMbuK0pn1r/lpjE3nX+s5GSw7DYivk+sHLpiBolUkxmVqV2n1jrH7PW2Bcd1iE32Nmr+52jTzJTEXALaHrmVkIeft1zpcs2/qn1jhUdL/dmas7odkFc3Jg8vTjxFir1hTDNGNwFPiHadH/26Oz2cJhHMHFsWukBZPnD9IcIP0ZNqBh0Yvq8l6+9LU
 0dQLtUfw
 HUOH+P7nQiA8k6s1GPlZaqpS121gv8MxucaVOJDzndk3YxtvLgbeYveVJnLBvWLAAWd5QU7SARrmiZdZ0jCOKt7kapszCuSD/fAC9MiCWMIHq4gWyApSyxLg6xsibFpA+mE5kzq8y6DSOUe+CCo0YKj9HgYDyBAn+V2C4lXhvhpaMuiGiiRg1LW7TVoKybIoUZ9wLR85SCRQbc0Lgj9zsR6IQaJ4Cn0umUPqNddDaeQ9Zny4snYAd4vJx4F+LIzCzJHmDLpwZYnoUzLBpqIHA+0Apl5P5KZlIxgbtQiT+FykFruxSDc6OuL1Dg+kB2COTG+A2qcM0TUIJswNx89Ihw4n3QGcjtV3ZtkJ64gc1T09ptYM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All!

This is v5 of the batched PTE updates in lazy MMU mode rework.

The presented implementation sets up per-cpu caches in the s390-specific
hotplug callbacks as opposed to CPUHP_BP_PREPARE_DYN hooks. I like this
approach better, since the boot CPU setup is architecture-specific anyway
and the whole SMP-related lowcore initialization is handled in one place.

Changes since v4:
- verified that a presumable sashiko performance regression finding [2]
  although appears valid does not really degrade performance
- applied sashiko suggestion [3] and added "direct-pte-access" kasan bug =
type
2. https://lore.kernel.org/linux-s390/20260623062703.269982B28-agordeev@l=
inux.ibm.com/#r
3. https://lore.kernel.org/linux-s390/20260623061321.269982A64-agordeev@l=
inux.ibm.com/

Changes since v3:
- all prerequisite patches are landed in -next and removed from the serie=
s

Changes since v2:
- lazy_mmu_mode_enable_for_pte_range() renamed to lazy_mmu_mode_enable_wi=
th_ptes()
  (David Hildenbrand)
- patch "mm/pgtable: Fix bogus comment to clear_not_present_full_ptes()"
  is dropped (David Hildenbrand)
- direct PTE dereferencing KASAN sanitizer added (Heiko Carstens)
- CONFIG_IPTE_BATCH option is dropped (Heiko Carstens)
- PTE_POISON changed from zero to 0x800 (Heiko Carstens)
- allocate per-cpu caches on CPU hot-plug (Heiko Carstens)
- introduced a lowcore field for fast lazy mode checking (Heiko Carstens)
- few minor code changes (Heiko Carstens)

Changes since v1:
- lazy_mmu_mode_enable_pte() renamed to lazy_mmu_mode_enable_for_pte_rang=
e()
- lazy_mmu_mode_enable_for_pte_range() semantics clarified
- some sashiko comments addressed [1] including one bug fix [1]
- patches 2-4 added
1. https://sashiko.dev/#/patchset/cover.1774420056.git.agordeev%40linux.i=
bm.com

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

Alexander Gordeev (4):
  mm: Make lazy MMU mode context-aware
  s390/mm: Batch PTE updates in lazy MMU mode
  mm/kasan: Introduce helpers for lazy MMU mode sanitizer
  s390/mm: Lazy MMU mode sanitizer

 arch/s390/Kconfig                |   1 +
 arch/s390/include/asm/lazy_mmu.h |   9 +
 arch/s390/include/asm/lowcore.h  |   2 +-
 arch/s390/include/asm/pgtable.h  | 163 +++++++++++--
 arch/s390/kernel/setup.c         |   2 +
 arch/s390/kernel/smp.c           |   7 +
 arch/s390/mm/Makefile            |   2 +-
 arch/s390/mm/lazy_mmu.c          | 401 +++++++++++++++++++++++++++++++
 arch/s390/mm/pgtable.c           |   8 +-
 fs/proc/task_mmu.c               |   2 +-
 include/linux/kasan.h            |  16 ++
 include/linux/pgtable.h          |  46 ++++
 mm/kasan/common.c                |  10 +
 mm/kasan/kasan.h                 |   2 +
 mm/kasan/report_generic.c        |   3 +
 mm/madvise.c                     |   8 +-
 mm/memory.c                      |   8 +-
 mm/mprotect.c                    |   2 +-
 mm/mremap.c                      |   2 +-
 mm/vmalloc.c                     |   6 +-
 20 files changed, 662 insertions(+), 38 deletions(-)
 create mode 100644 arch/s390/include/asm/lazy_mmu.h
 create mode 100644 arch/s390/mm/lazy_mmu.c

--=20
2.53.0


