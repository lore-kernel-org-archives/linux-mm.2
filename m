Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43115C4450A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E0F96B009F; Wed, 15 Jul 2026 09:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091B16B00B0; Wed, 15 Jul 2026 09:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9BA86B00B3; Wed, 15 Jul 2026 09:29:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7A846B009F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:29:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3CA531401B3
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:22:52 +0000 (UTC)
X-FDA: 84991076184.12.A578576
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf01.hostedemail.com (Postfix) with ESMTP id EB19840009
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:22:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XhHx2mhE;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf01.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784121770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zrvRKONkIctnT7GLUq69H6eSyaiBYmcbU4wk/GaV1k8=;
	b=csHdlTgrOq6Lh79CFxm6BiNxxIOOlfTU7I14NU07ZPpOsbH8Uu6Nj49xHEY4Us+eVDtrtr
	xfWN54c6p7y+xfSGTnW9sgw4WjA7e97TXJHk+tiJYLonBuh8H6UKmQFkSBs2iiaA0odrJv
	CP13Yf/Lmr7mywUWHdyn1aam3YEsVUI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=XhHx2mhE;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf01.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784121770;
	b=6O/gH/yLCCoRlcy97OsEyTK4rdn4HGaxyjm98v79oUKTNX47aUtrK7BZ8UPo0jGtcbrTas
	PlFpXKmrdm493zw97JAit6Ijn80kVdfQXg6CGOV7Xrv1KRX8go4Rr6XDYWUMCBSnOn6ZpY
	gIdXzPzCGzNfVOBPVSOFLoWwT6Gm8+0=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66FBg6jL4188086;
	Wed, 15 Jul 2026 13:22:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=zrvRKONkIctnT7GLUq69H6eSyaiBYmcbU4wk/GaV1
	k8=; b=XhHx2mhEJqhTF28yZ/ZsLoSKHQ2sufiEFa5uMTnLgP7r63dvzdff8i6a0
	LKoNLcwlhVeThEAfJu+Qil9lwmiJVLOazJtspgNLlX9BRHq7HTDbioydZK6L0DgQ
	YFGsNovQfCewbii8L9x86hNqvOsTJ401+TWA12D9E8F2FMjSlubDBl9dp3bTzrpH
	zfB8KO3cCfBp/4lP7px5avGX98vmS8T6GRaT0+5QAiLIFyqoV+xPRA7i8uL1gJgH
	dl3pgNU1yOqTSNWyaDCjdEsMpSsn3+5W5/ri/4loQe2UYTNJfuHmP4EP/kQzsRJO
	B3n1E4zsYwHX8GbRby3G8pBS9ddzQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fbf2ab4p9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jul 2026 13:22:43 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66FDJdlW006417;
	Wed, 15 Jul 2026 13:22:43 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fc15k05vt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jul 2026 13:22:43 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66FDMdET50004458
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jul 2026 13:22:39 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1B09620043;
	Wed, 15 Jul 2026 13:22:39 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DB53220040;
	Wed, 15 Jul 2026 13:22:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 15 Jul 2026 13:22:38 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id BE88216264B; Wed, 15 Jul 2026 15:22:38 +0200 (CEST)
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
Subject: [PATCH v6 0/4] s390/mm: Batch PTE updates in lazy MMU mode
Date: Wed, 15 Jul 2026 15:22:34 +0200
Message-ID: <cover.1784121418.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE1MDEzMSBTYWx0ZWRfX8Vg5dXTcIZEF
 jaF0WsAL0e2SOYZVjFH2re5kNqprVC4JDYZezWfzriYv8czHlNR0a7gux9KtBXLlx4mAYtM0s7S
 9iuLO7Uu6620h7e7zikowurgE6KX7sk=
X-Proofpoint-GUID: 3uvqvxQf5dxC4D_8zMYO_7eOfViLUuD1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE1MDEzMSBTYWx0ZWRfXzZB2ZaWRqb7x
 dwMmIJnWKwiZNVI/xXXlwfXmNR3KW6vnEHGTW4ZVyYroFgKpho1T9nV5qsnA24HSnCuuOjzDcZH
 74fqhk7SJSkPtqikbjA839/44KD75Jtj8735jKqvPKIhMQz38lGJRaF1/98iMurq20u9gcsuGKO
 ySwdFpf3/IgkXUlUlmgAuP9vtGNxwCQplQ+qKnNSoCByh7eVVkRzIPDvQNkDCuA5LRBEfXdTMJG
 kAtPUeVW21uJszNxDmO/7etlaIhXT/cACYdV3JAND0euW5hEefuvPTR3f0PpnZnX4oNmYeK9aO5
 ee8OwUVn93xVq2a13loMEIgS/cTsUW5ct6HMBJExxUXIYSGGVPPIXBamipjEYe5SMfBVpjtJ8lp
 iGDf/dWPS6ID/ZVkwzuOa3scPBiWJ+Si9I+vc+L9KrxWf3T/4v4d1oLcnGr9DpmWN2psbEmDv7F
 Pr4lTQfNHuZq6XyvRqw==
X-Proofpoint-ORIG-GUID: A6Vu3jN4j8NekXGnsfVcLGBzYJXFSpgW
X-Authority-Analysis: v=2.4 cv=PvajqQM3 c=1 sm=1 tr=0 ts=6a5789a4 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=c92rfblmAAAA:8
 a=1fX-024GrAZ7cXdUNU8A:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-15_02,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 spamscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607150131
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EB19840009
X-Stat-Signature: 6ku3hhyswunr4oqfkehte8qpz38ssmfo
X-Rspam-User: 
X-HE-Tag: 1784121769-709609
X-HE-Meta: U2FsdGVkX19g5xcGvTD2QOhh/kEZOoD0QzVY9JUYXvmeX9Wo3G7MSu9aG9OJH3qkrMpFqFvtxcklZPZYddIyE3Qktc3r4KeU8EASraY2nLKdwrctBYdPPxuJiqPvcPLbenS9EUg6uphVK8lTqXbEsrch9UqQGNcpvDqulb+VYBESWODRU0yVL3Jes3HRQbGKq3qjKzljWjFyv36IKLXZ6HLQySmpiY69g9YezliU3dClNeX/WIiLTLkES6ONSICKrJsw2T5WXV0RtpsWfcZfpqOeS73JWXM6idkYROhII8xXdFE4i58LU8wg7zbGdvs1Mi0WR3EyjUgeEdhpMbzua/j1DoPP7QKi/wY2H++o/1nCP1IzTIXyL65/b1j7XSSYbVOpWoHO86VpW166w8lQxOzQwfi6FLhWSgk3j/8VY4ZXKmwpwn9SJ5D3pt+2d8HrVj+7pdyqDsBOLiDVFJ8xXU2gWqp4V5BNM+6qoQK3db+BxpfdeBTYvmxYlZUmUwgctFTT+rhIg5gGIdw7I/T72o2DrlBD2vQHLEW/g0QTyD50xMQO7XB7UM+hWjqHQZBMCu41pKG8BdwdOqTsBBcMjQfn5TqXA7dDlIbpxB6aLOKkUxrIcIdYb5VeUwF/pGh6H0JuaAPZfEjsU6LCqYjs10YAJXu1YGkEtDlNiXFXY8fSGzejFR7Y+QFCrETf5ZxLIfEgHrwRsblIIlbMSJKp+UrkFj29v1wOSzg02LW9m1xhroNcSMMIjVbVXd+ywyKgGftDHeiagsj9KwmdtGY9mn2wRUeJFh+SZ+jNsSFzsh3ktS+QUSaxHmL/ry0elxgEWq7OSeOfeBlWnXL1sDNNCJCqyhtrwhyGnavcRcmqO94VJO+jReQNHcOBxkhN25PakPMdLN9/4rtHAjKgBo6Q/jm1oPX1SMtZ7+qjSPZexrGre2HxivavRMoq5N0eT+RanR5NasPZJWy5dsodi+5
 KhadkaR6
 9zPnZ1wmZb2eIGnQ48hERTjm/VJrmgMc81n8pTVGgjOIvsMOp2h6d5Tm0L7P9R2dVU6mudHIEIoXRsugu4/u5n3Z5i6+9zJA+ZMM6nDA2iCpKR2munpCKgCWJs+rr5nGYDKikKI3BXVvzrGl56j7szmn1mxGn9XXyzWwifBfHP0E2K08cGimi1z/GE4YJEC1boIDNJHv1FNV9lcD3K3X1Fz4v0fnHBisPrv0M+kYCbCtRhek+IApGW2FO6NpfPO7zy2uSZvGb/CaPdXzfg6Ztn5G7BoxGcL0TLUDed5HabmeBJiMMRMzQlzAnUqfUKfWSAHVVX9uE71cr4tKSFQTO6++97wD7HgunhdSJui/r68V/qRg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All!

This is v6 of the batched PTE updates in lazy MMU mode rework.

The presented implementation sets up per-cpu caches in the s390-specific
hotplug callbacks as opposed to CPUHP_BP_PREPARE_DYN hooks. I like this
approach better, since the boot CPU setup is architecture-specific anyway
and the whole SMP-related lowcore initialization is handled in one place.

Changes since v5:
- IPTE optimization is not applied to secure guests [4]
- __kasan_(un)poison_pte() are marked as EXPORT_SYMBOL_GPL() [5]
- PTE table poisoning is not applied to architectures with PTE entry size=
s
  unaligned on KASAN_GRANULE_SIZE [5]
4. https://lore.kernel.org/linux-s390/cover.1783945507.git.agordeev@linux=
.ibm.com/T/#md98724bd3b66d0a0711deb6089fa541f420566d8
5. https://lore.kernel.org/linux-s390/cover.1783945507.git.agordeev@linux=
.ibm.com/T/#m9c8b31b4863416732d0cbbc5f5f63290db4522c1

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


Alexander Gordeev (4):
  mm: Make lazy MMU mode context-aware
  s390/mm: Batch PTE updates in lazy MMU mode
  mm/kasan: Introduce helpers for lazy MMU mode sanitizer
  s390/mm: Lazy MMU mode sanitizer

 arch/s390/Kconfig                |   1 +
 arch/s390/include/asm/lazy_mmu.h |   9 +
 arch/s390/include/asm/lowcore.h  |   2 +-
 arch/s390/include/asm/pgtable.h  | 157 ++++++++++--
 arch/s390/kernel/setup.c         |   2 +
 arch/s390/kernel/smp.c           |   7 +
 arch/s390/mm/Makefile            |   2 +-
 arch/s390/mm/lazy_mmu.c          | 404 +++++++++++++++++++++++++++++++
 arch/s390/mm/pgtable.c           |   8 +-
 fs/proc/task_mmu.c               |   2 +-
 include/linux/kasan.h            |  16 ++
 include/linux/pgtable.h          |  46 ++++
 mm/kasan/common.c                |  14 ++
 mm/kasan/kasan.h                 |   2 +
 mm/kasan/report_generic.c        |   3 +
 mm/madvise.c                     |   8 +-
 mm/memory.c                      |   8 +-
 mm/mprotect.c                    |   2 +-
 mm/mremap.c                      |   2 +-
 mm/vmalloc.c                     |   6 +-
 20 files changed, 663 insertions(+), 38 deletions(-)
 create mode 100644 arch/s390/include/asm/lazy_mmu.h
 create mode 100644 arch/s390/mm/lazy_mmu.c

--=20
2.53.0


