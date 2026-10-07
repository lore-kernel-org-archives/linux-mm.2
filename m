Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F9B0CA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 11:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BFB26B0099; Wed,  7 Oct 2026 07:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449856B009E; Wed,  7 Oct 2026 07:42:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 161496B009B; Wed,  7 Oct 2026 07:42:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D205E6B0096
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 07:42:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A8F45C0198
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:42:10 +0000 (UTC)
X-FDA: 85295641620.08.738124B
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4783E1C0003
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:42:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=b6hXKOA4;
	spf=pass (imf20.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791373328;
	b=BCQYmnnugNbUVH9Ts7smy1w3ifuVfDItBb/ooOGZ7jxa+eeWGED3toIa/I9ZYl4pbgKPtA
	iGboBrCZIJ1cPjYvDnASswLWzOg4czpMG8XZm1LHzF6U6EMZ/0z/2zfj1xJioBRHkQp7vw
	5YK8aJKOAaRQCwKbhtyC/JsMGgaHWnY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=b6hXKOA4;
	spf=pass (imf20.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791373328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=c9EMoYB6T0wMfGVYaUxSquLvrDtSzCog3Wbp6Jo8Vq4=;
	b=6jHkHuy8HECEYk478uHCgqjFOmmeQ6ns8JfYgHUZMaRdN7sE0toPUfYwwuqUVSyPeP66mZ
	kLFvlV3WcJnaqDdn3fKbUbuCQFaPfT/KDt2A6+gkavllVRKcoqvxeB+OfN97+NteBFsG2E
	bgDdKXPhWw3KI2DJsHPMgh7sCXykEzU=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 697BZuvB2400453;
	Wed, 7 Oct 2026 11:42:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=c9EMoYB6T0wMfGVYaUxSquLvrDtSzCog3Wbp6Jo8V
	q4=; b=b6hXKOA4h6UFtLUdxWzOdNf1JoStxVX7cXwx9RI+RDamXGK8zDETxaEky
	M681GM1Ha3qhZda/ihbha5Hw/LAYLPOSVy/j2JX29KzLWBgwYEp9X5D5O3MxLGcb
	djw6aZJukIa3uV71+6eSNPaubNT6RWE2V9TRimk/wWhRmYemQonq4fAc9E+xKcC9
	kPu7V11QZ0OcrXdH5Qs05Sj3/CQE21d++ImFiYraKrlc5W6p0c1toaCF5RUjuqkT
	JbJtNdv9ZSG9K0RA5EkbpHSiI41z/3O2froomvJ4P3cBq24SySCq8WPiF4Fq2N3t
	CijJRhqNmn6QfzPrZ7bTTADAnqJpQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h2sbvc5fn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:03 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 697BWcwe1810425;
	Wed, 7 Oct 2026 11:42:02 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h58ek2ka0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 Oct 2026 11:42:02 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 697Bfxeb45154630
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 7 Oct 2026 11:41:59 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 070112005A;
	Wed,  7 Oct 2026 11:41:59 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D33B2004B;
	Wed,  7 Oct 2026 11:41:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed,  7 Oct 2026 11:41:58 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 77CBD160862; Wed, 07 Oct 2026 13:41:58 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com
Subject: [PATCH v8 00/15] s390/mm: Batch PTE updates in lazy MMU mode
Date: Wed,  7 Oct 2026 13:41:43 +0200
Message-ID: <cover.1791365932.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: YZpebUi1ohTJ19ZHo1gM0dcRm2Snm0y5
X-Authority-Analysis: v=2.4 cv=KJHPn1Fo c=1 sm=1 tr=0 ts=6ac6300c cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8 a=c92rfblmAAAA:8
 a=VnNF1IyMAAAA:8 a=vWxzslZmAAAA:8 a=3TpcdIXXsA1J5E0z9WEA:9
 a=a-qgeE7W1pNrGK8U0ZQC:22 a=GvGzcOZaWPEFPQC_NcjD:22 a=W-V1AfKMsUyx0yxTjrDY:22
X-Proofpoint-GUID: l8CyGvrUlQeVgM66WRRZl9KQkfB58jPp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfX5aFVUCPwOnoR
 Z5G3ixAeqWGa76/FO81pddWq9kjdzko0GOjTeHwMAcdeY9Q1IUdadOV9/jh+RW01fu63nVlBPx0
 8Sr2UwIs9tWzlCDGDHa16h79gQ0hlyJUddhD7qn/dtrP+2I9JDtXOmwwlitR7K3mUbjTXuSDOJJ
 pYNZ9ftEKv+kXOyRgKzwpBhVE5s2jR5BG9cXM+Us5luqBD8JQsNvKA0Amnh0Zt+1wvmCcTKWty+
 alMmoxsmQ6B5C+47OO6zuCsC00Vzqep6GNwYNYEx5WSpPhpTYtjQP13IhN8PMPIzaPievFUQgvS
 32d0G3uhmmxgjvq3KysSsZ4c/BflGaZOFI2Jdad0xov+WuSU/3kL/86iYKRXpJMPub/RIljmDY8
 sPnJaYqfnotKOSAZe2b57PkO0pTIcumqbxkxvjA71A5sBpZBnPPUPluUWOqrzDLQbhBBi5OKTSd
 qEogA2C8ghrvutqR/gw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA3MDA0NiBTYWx0ZWRfXz7HN2Uz2dOUK
 gYGHQe2c/nbyeruWTjERuESQsnjwMnGPCS/4H3lMP6cjyXLAwKb/2nZ3ZO5idhYdx+TRLOdkld2
 hxHaQ46lunkplXwu4r6NteWMFTL4b+I=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-07_04,2026-10-06_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 spamscore=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 adultscore=0 clxscore=1015
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610070046
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4783E1C0003
X-Stat-Signature: 6t4bt3oos5kbkffafira9jnkgb64kbyi
X-HE-Tag: 1791373328-308420
X-HE-Meta: U2FsdGVkX18ptu/lm/n5LDKee//XLTesNMs1+DEfUCfQbOTEtJl5rcH28+RKC/EgZpKg/KY2HFImfi6NOSc9Cve8WLktW+flpg3ehnX5zXFaiTzLGjKyAuKtPM2ZXlNSL7WFj9ZCVVS6FbXp331hFm7DvTe9nH0uBRyiTO0VrJeWvxizkoePIX4gWpzfWSepdXk3YRGFJStt0LeWLgZLY3tmX7calhhwlh8qo7EvKxvWuCgY+1aQJnVVKDxq2jjtkk/kPFD6owbL+n7EIcGA0zIwbvY8PRhHNuSIqZGhQyxrXQfgS7qFeZn+kwk7ntiHepxEgsAOLR2hafwOHADkYcfrY0zIRRxpHXTi1nfMk9BO8IS0pepxzzZ5K2Xb36JgGCL2Q/3r4gZjpeOzrFB7flCGxfaNRgrQv+pA2O7MSO2qfT3yLSKbb6TL74XZa/+X6yo64apj7Z9FF1uNIF5rd315vNI3u2GNWBtEUTMKk5Z6EZ5aunPOoKLhYgzIw9pVd8ipmnjSeza/GnWma2wzf59XIfMT7UwDYysIAHzuRtIasohQZNclpJfAinn4ePV9EW1Es23JgwajvEMNf+qv9dM/xwd8uPgMGZlfWgXWSFHshJPtt04CWj0jrTlEJamX815VO1I0IsO24EL+wr45rNf5oIJuONyQbKBY/wrkdlBSMmnNm/l5NK3e6NRzP570iMcH7FxmkBJQJ6ps1RHWBtgBv+TxNUyFeA49VpY78BQNJDNm5E9t16bVMklhxNBDIdekDwL/F1DJiXEaQZg0kIVWvovMPiNvL3myXp/EACdPejRvOiKtJ9RirocCVHnwJclxBw6hHUDkKr+ITcXcc/UdldYybBKVT04GtXxcCPkEl00a0JWnK08VIuObjTcMIQ5XiNC1QH2izmSxi0s5HfBLQSdBk3zqu0BG+b1s2yr+3IFO1EamQ02QOQr09gVwfBDIAWW2dYoraaiGe3L
 UXqAUAcT
 a9fYQQJA6Ncs/76Qd5pwZjQIezucAg4jjTtGxZ3MfPaqEV0Ekc0Va2HZn1OwS8hjxJ6zvMpfscr09HBCdpcihMzpVqZ/Bk0uMAvKG8l8GZ/VFafu9+xy18BIqc81srVqiPgEUCceO/6UEtcj5Xrqe14JtSmztMP5HKUuRSpwxCJ5jHVlWuxkcRupExye/uPFlaggqCIFcyOO7q58t3VbYCMymzLNImr/XaVqkJtJ5QUavlWYsZMUlb7pmG6lefU9kWaan865ekKORc28G0c/+rJZdCMrgSD6XeJZZ4OdVgVTe7N0onuKtU3H56ESvdr3mTP3sWfSMjYEppRDHCOvBnxPb5qxhIRtDIn02EGAqKBeUic7An9I+OwQ+JSqSL6Xy2ItbDaxoq+giH7zggi5zIH6JwEqozOwighlJ92O6CmJWORYT8u3xNKWI8AlMhZIb+Sf2S/FY1hzejvJq/rmHWte7AoCZnaj/JoMws6uj8DhMVTOo3aY8f5nYomsr+mgU+Hiq+ADnRA/eeVXp1UJwtx+9AbsHe2SeI3uTVpPe8Z4UwMy+4qI9GX+ltCk+wUSH94AA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All,

This is v8 of the batched PTE updates in lazy MMU mode rework.

Patches 1-9 are a prerequisite series [1] backported from mm-new to maste=
r.
It is only posted to facilitate the follow-up s390 lazy MMU rework review=
.

Patch 10 is a cleanup that could be picked independently and is
a prerequisite to patch 11

Patch 11 is the s390 variant of the ARM64 series [2] and provides
hw_pte_t type enablement

Patches 12,13 are the lazy MMU mode implementation and the main
objective of this rework.

Patches 14,15 are an additional KASAN-based lazy-PTE guard mechanism.

1. https://lore.kernel.org/linux-mm/20260922-pte0-v3-0-5670b8cb9059@arm.c=
om/
2. https://lore.kernel.org/all/20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.co=
m/

Changes since v7:
- CPUHP_BP_PREPARE_DYN hotplug event is used to (de-)allocate per-cpu dat=
a
- lazy_mmu_enabled static key is used to indicate the lazy mmu mode avail=
ability
- is_lazy_mmu_active() is implemented using CLIY alternative
- lazy_mmu_count lowcore variable is turned 1 byte to allow CLIY alternat=
ive

Changes since v6:
- bottom-halves are disabled on entering and leaving the lazy mmu mode

Changes since v5:
- IPTE optimization is not applied to secure guests [4]
- __kasan_(un)poison_pte() are marked as EXPORT_SYMBOL_GPL() [5]
- PTE table poisoning is not applied to architectures with PTE entry size=
=3D
s
  unaligned on KASAN_GRANULE_SIZE [5]
4. https://lore.kernel.org/linux-s390/cover.1783945507.git.agordeev@linux=
=3D
.ibm.com/T/#md98724bd3b66d0a0711deb6089fa541f420566d8
5. https://lore.kernel.org/linux-s390/cover.1783945507.git.agordeev@linux=
=3D
.ibm.com/T/#m9c8b31b4863416732d0cbbc5f5f63290db4522c1

Changes since v4:
- verified that a presumable sashiko performance regression finding [2]
  although appears valid does not really degrade performance
- applied sashiko suggestion [3] and added "direct-pte-access" kasan bug =
=3D
type
2. https://lore.kernel.org/linux-s390/20260623062703.269982B28-agordeev@l=
=3D
inux.ibm.com/#r
3. https://lore.kernel.org/linux-s390/20260623061321.269982A64-agordeev@l=
=3D
inux.ibm.com/

Changes since v3:
- all prerequisite patches are landed in -next and removed from the serie=
=3D
s

Changes since v2:
- lazy_mmu_mode_enable_for_pte_range() renamed to lazy_mmu_mode_enable_wi=
=3D
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
=3D
e()
- lazy_mmu_mode_enable_for_pte_range() semantics clarified
- some sashiko comments addressed [1] including one bug fix [1]
- patches 2-4 added
1. https://sashiko.dev/#/patchset/cover.1774420056.git.agordeev%40linux.i=
=3D
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

Thanks!

Alexander Gordeev (6):
  s390/mm: Cleanup pXXp_flush_lazy() routines
  s390: Distinguish hardware and software PTEs
  mm: Make lazy MMU mode context-aware
  s390/mm: Batch PTE updates in lazy MMU mode
  mm/kasan: Introduce helpers for lazy MMU mode sanitizer
  s390/mm: Lazy MMU mode sanitizer

Muhammad Usama Anjum (9):
  mm: introduce hw_pte_t for PTE table storage
  mm: rename pointers to software PTE values as ptentp
  mm: use hw_pte_t for generic PTE table storage
  mm: convert PTE table entries in ptep_get()
  mm: convert PTE table entry to pte
  mm: add hw_pte_val for HW PTE storage
  mm/kasan: use hw_pte_t for the early shadow PTE table
  drm/i915: use hw_pte_t for PTE range callbacks
  xen: use hw_pte_t for PTE range callbacks

 MAINTAINERS                                   |   1 +
 arch/s390/Kconfig                             |   2 +
 arch/s390/boot/startup.c                      |   2 +-
 arch/s390/boot/vmem.c                         |  17 +-
 arch/s390/include/asm/gmap_helpers.h          |   2 +-
 arch/s390/include/asm/hugetlb.h               |  18 +-
 arch/s390/include/asm/lowcore.h               |   3 +-
 arch/s390/include/asm/maccess.h               |   2 +-
 arch/s390/include/asm/page.h                  |   3 +-
 arch/s390/include/asm/pgalloc.h               |   6 +-
 arch/s390/include/asm/pgtable.h               | 215 +++++++--
 arch/s390/kernel/uv.c                         |   4 +-
 arch/s390/kvm/s390/pv.c                       |   2 +-
 arch/s390/mm/Makefile                         |   2 +-
 arch/s390/mm/gmap_helpers.c                   |  18 +-
 arch/s390/mm/hugetlbpage.c                    |  20 +-
 arch/s390/mm/lazy_mmu.c                       | 449 ++++++++++++++++++
 arch/s390/mm/maccess.c                        |   2 +-
 arch/s390/mm/pageattr.c                       |  10 +-
 arch/s390/mm/pgtable.c                        |  34 +-
 arch/s390/mm/vmem.c                           |  26 +-
 .../drm/i915/gem/selftests/i915_gem_mman.c    |   4 +-
 drivers/gpu/drm/i915/i915_mm.c                |   4 +-
 drivers/xen/gntdev.c                          |   2 +-
 drivers/xen/privcmd.c                         |   2 +-
 drivers/xen/xenbus/xenbus_client.c            |   2 +-
 drivers/xen/xlate_mmu.c                       |   4 +-
 fs/hugetlbfs/inode.c                          |   3 +-
 fs/proc/task_mmu.c                            |  35 +-
 include/asm-generic/hugetlb.h                 |  15 +-
 include/asm-generic/pgalloc.h                 |   6 +-
 include/asm-generic/tlb.h                     |   5 +-
 include/linux/hugetlb.h                       |  53 ++-
 include/linux/kasan.h                         |  21 +-
 include/linux/mm.h                            |  26 +-
 include/linux/page_table_check.h              |  10 +-
 include/linux/pagewalk.h                      |  10 +-
 include/linux/pgtable.h                       | 127 +++--
 include/linux/pgtable_types.h                 |  23 +
 include/linux/rmap.h                          |   2 +-
 include/linux/swapops.h                       |   6 +-
 include/linux/vmalloc.h                       |   4 +-
 include/trace/events/xen.h                    |  10 +-
 kernel/bpf/arena.c                            |   9 +-
 kernel/events/core.c                          |   3 +-
 mm/Kconfig                                    |   3 +
 mm/damon/ops-common.c                         |   2 +-
 mm/damon/ops-common.h                         |   2 +-
 mm/damon/vaddr.c                              |  20 +-
 mm/debug_vm_pgtable.c                         |   2 +-
 mm/filemap.c                                  |   4 +-
 mm/gup.c                                      |   9 +-
 mm/highmem.c                                  |  15 +-
 mm/hmm.c                                      |   6 +-
 mm/huge_memory.c                              |   4 +-
 mm/hugetlb.c                                  |  60 +--
 mm/hugetlb_vmemmap.c                          |  13 +-
 mm/internal.h                                 |  16 +-
 mm/kasan/common.c                             |  14 +
 mm/kasan/init.c                               |  14 +-
 mm/kasan/kasan.h                              |   2 +
 mm/kasan/report_generic.c                     |   3 +
 mm/kasan/shadow.c                             |   6 +-
 mm/khugepaged.c                               |  50 +-
 mm/ksm.c                                      |  11 +-
 mm/madvise.c                                  |  26 +-
 mm/mapping_dirty_helpers.c                    |   4 +-
 mm/memory-failure.c                           |   6 +-
 mm/memory.c                                   |  86 ++--
 mm/mempolicy.c                                |   4 +-
 mm/migrate.c                                  |   4 +-
 mm/migrate_device.c                           |   4 +-
 mm/mincore.c                                  |   4 +-
 mm/mlock.c                                    |   4 +-
 mm/mprotect.c                                 |  21 +-
 mm/mremap.c                                   |   6 +-
 mm/page_table_check.c                         |   4 +-
 mm/pagewalk.c                                 |   9 +-
 mm/percpu.c                                   |   2 +-
 mm/pgtable-generic.c                          |  20 +-
 mm/ptdump.c                                   |   4 +-
 mm/rmap.c                                     |   6 +-
 mm/sparse-vmemmap.c                           |  22 +-
 mm/swap_state.c                               |   3 +-
 mm/swapfile.c                                 |   5 +-
 mm/userfaultfd.c                              |  32 +-
 mm/util.c                                     |   2 +-
 mm/vmalloc.c                                  |  17 +-
 mm/vmscan.c                                   |   6 +-
 89 files changed, 1269 insertions(+), 512 deletions(-)
 create mode 100644 arch/s390/mm/lazy_mmu.c
 create mode 100644 include/linux/pgtable_types.h

--=20
2.53.0


