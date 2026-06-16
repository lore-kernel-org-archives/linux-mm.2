Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57A76CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432386B00A7; Tue, 16 Jun 2026 16:43:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E3126B00A9; Tue, 16 Jun 2026 16:43:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8A26B00AB; Tue, 16 Jun 2026 16:43:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D66276B00A7
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:43:26 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 62B601A0257
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:43:26 +0000 (UTC)
X-FDA: 84886951212.10.2FD207A
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf04.hostedemail.com (Postfix) with ESMTP id 30E5640003
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:43:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=A2BEN5RP;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781642604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RMfqveTS00B2bVfK8ta2tvPTyb6FBrxiY4BewlyDnv4=;
	b=IsUd70qQbzsT9wZ1IZDg6NZ/Her/RvyEZW86VyC4AmVPaVPY187z1Kg7ltU7P7zjX6VRd/
	7uEAka6FNXHcX7OM/QaRf6H/q3aXgMWN26fXd208+6hXJLE1NLCcB/Rpzfr0KrVFo+Z9ni
	crszeOljcGojupAwY4Oy0AamBze6y98=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=A2BEN5RP;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf04.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781642604;
	b=aM7YfTOhcGEu8Wqpr5OLAtx0JVghTOAhseTvmEQpgfaYgGJwt6gwqTHuRG5HdyP+ceTE4S
	BmKRkayKlSt5iq9620PVmd+zHJmPbD28Zm+0UaQvIUwrJ4XPdu1o2F6i0PRg5eVWCHSz12
	InBYzgUvsQbQO955MbaD+zTUOWwyN5A=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65GAIUfX1156242;
	Tue, 16 Jun 2026 12:40:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=RMfqveTS00B2bVfK8ta2tvPTyb6FBrxiY4BewlyDn
	v4=; b=A2BEN5RPK9lJM/HXFcOY/6j2NIwpsWsrtRVbhUDkR6orF7fBzZFG+fj2u
	lBh2o5S+Aj/rb+bT4nvXiyPHAb2w2bv5wqGt3uBplBEinuoWUwUUVCZ2MEaBZKb3
	nOFCUSML+Sj946JwGXb4BK1ZURhqAdB4b0AV2RF4Fuh9XjMjSx/cwwIQ+mZBk6FV
	2vbh8UDycQ4xSxg6D3IS7NgUlfrdG6yrsyofKBgNGXM76sFq4e9SB5DWs+ri2rg0
	ua79XvBfFW3ptQIOIVv14Vkdg70AQZ0svGWOHzdA+06D11tKBNYckVnxpET6piSq
	BpOh5LpPLjbSmPIqxnfRl10CJizlw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4es1eg53mm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jun 2026 12:40:44 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65GCYbpI021705;
	Tue, 16 Jun 2026 12:40:43 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4eshww3dw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jun 2026 12:40:43 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65GCedEK57868582
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jun 2026 12:40:39 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BEE6E2004D;
	Tue, 16 Jun 2026 12:40:39 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A00E120040;
	Tue, 16 Jun 2026 12:40:39 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 16 Jun 2026 12:40:39 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id 7E1B9E0612; Tue, 16 Jun 2026 14:40:39 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v3 0/7] s390/mm: Batch PTE updates in lazy MMU mode
Date: Tue, 16 Jun 2026 14:40:32 +0200
Message-ID: <cover.1781611976.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE2MDEyNSBTYWx0ZWRfX7c+xetp8jSG+
 uSnWJ9hWUvWOoyUNDqfT/BGCLBjOSGUMOq5Lk2+Sw0IAKkY8+1VfA/ruBcUQaU3yesasFwXtdnC
 OpfNXRdosZm8oqgIdQythO2xkvJOBsQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE2MDEyNSBTYWx0ZWRfX5TyCm4jyASzL
 Amt8KyZtZopY2jzT1HverTYjpcjbM3wCyBl5h+nmbKgUWzfOHfOR+1B6XQt8kT6Uu6nwGO4t+G4
 JQhTl80MJ9Pu8sEq/dzGwQM+gwHShoKmqS7H7TVdUEUGaIRga3JuT7o7dZ/D6swh55Z99sq3uo+
 4QT0Xg6U4osROZxRTaMDeXpDkU1DghsaEH1HnbmMs0E3xfD0eOhEA2HIDP/0fguuyfWLwM2JMlV
 1ODAb7pJVGk7ZUlmCgCKJr/zP0q5suHuybrWPgHsTNSkdincWktQTzn+AmUw5prCRH3LQ8MPLCQ
 I4IqJmpiXbF7qHz0vcu017xCzjmVMlB8FNqFfhXVtmccXsIjm6pvRtZa/YPZq0ONoz+WwgjfFGD
 8KqCeYA8ThOFXMNxBgeHVEs5oxWeAiyWl9rvTPT9LN+80EP9CotQhF2paH0Wx0jm4H3382mGNdk
 rxHIVsH2pT/vEeFtn3Q==
X-Proofpoint-GUID: vC5Q112xbJDkLGfdT8fd-nsfA7-zz7vr
X-Authority-Analysis: v=2.4 cv=NuDhtcdJ c=1 sm=1 tr=0 ts=6a31444c cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=c92rfblmAAAA:8 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=TRBNZcfPePrm8P-CY9YA:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-ORIG-GUID: vC5Q112xbJDkLGfdT8fd-nsfA7-zz7vr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-16_03,2026-06-15_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 suspectscore=0 impostorscore=0 clxscore=1011
 phishscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606160125
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 7jp8ge4jyojpm4quwajysx6trzbedrzy
X-Rspamd-Queue-Id: 30E5640003
X-HE-Tag: 1781642604-462234
X-HE-Meta: U2FsdGVkX19Uirj3csE6qvZS2uE1ekeW6f2MO9pwqgkTHnlhM0swLAkqJhqY/Ivo+iR9cWrKX68p4RJoN9HoG4No0yONPm8CigQ6jd//v0zHA5dbDZRsDtGhq32ezamEb1eqel9TbM4xuy+K/pPWB27wiwYF8PNF8AgdBkCJpM4981ffKRXe8EYLo6/09j6CDbn5sNSCs8NT8KFsxLzUgDtEzUexmndGvWpu+ksNPUHaxR5ccNgsgFFRlv2QJtUNDCkgItkAyrcLpwDB3c2Ss3rCpDs7dTG1eoC37zY+EnLK+PleLzQ8cLTZKKH1J2s6xkF1SnSw5q+JBIwNV2My1fcpn1xSMJiMakIXTu10qjRydnI6rreDQI8UXg552EIEhLf83SLUk1vJer9qmKJXqKr9+ae70Vo7v4SxlO9DYKPotlWGW11+AdO8MxMSOiCJPdDXKzdIm64Cjd6qba0KB9F2d0C9KgN8yv62NyrrRPlU4sSKbzU+wajm4dieyvjd0UAnOJE0eUQnHU9eGk5j2mDjbCY9vIojSMt8Df/Uwhq5veyWbvq1DL9trESEV0m4mM9sIUf0JNhR8CM92TUTNM5DFar9IV2+OymqYJD8JH6qhRyucv7A0fuStbQpNBmQs0yGf3kikrCK9G5DvWjps9fql3m3RDW5uo70P2ulhYyaHEp96I6Wkz1KSqDbEyoLAshSz7ixKfomIkKP1jMMPVbMNG288VoSwFjEZsUS+NivlL5hRUdFxHc4dCLspWXATi48RlHpiYWrC76zq/so0iFmKKtkge/lWqVSiFLPC8KfQHx69ozLW9KmJvZ96oeLuDRB4sAPqOhGyRqxMEJg5Yi6De7FMEA5IwMSq/ZU62Jqldhc2eKmFzaKkhs0U+0N2KfYsqvqCU60cmLHxx2ns3zmbYEWRleIpQV3gWnymmk25pcfSyYVIx5YLhmAKjJXy5iFlXhoOZGnitOdTYm
 39OlGJHG
 c0oOy3eQOLXhGqPVYHqhVHXKXrug9pK4NLXlzlCao7uIfvQWohzKsI7MFhQkVzMM8hEj2lgAeeaFLD5nzIkgU6ogiASPrOCmlSrCd9evVvujZB/JM23fVT+5AeJGqefrqU6vSrM3FSrmx2uL34IT8n6geN4Obzf2QiNMxILGA1Mv0ROh6zmU5LgiDug7k3IrLpv8nWobHJ1PsFgyFLnlOGn7TxG03XxMqxdQkTPuRBFvwyQonyGGAb7bwuxlFZ9YqTRzisWwvpvpdD8TvmT7WCpd9Lnd5zpcEcGHu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All!

This is v3 of the batched PTE updates in lazy MMU mode rework.

The prereq patches 4,5 are in the mm tree and scheduled for -next already=
:
git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything

The presented implementation sets up per-cpu caches in the s390-specific
hotplug callbacks as opposed to CPUHP_BP_PREPARE_DYN hooks. I like this
approach better, since it locates the SMP-related lowcore initialization
in one place. But that is up for discussion.

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
- some sashiko comments addressed [1] including one bug fix
  1. https://sashiko.dev/#/patchset/cover.1774420056.git.agordeev%40linux=
.ibm.com
- patches 2-4 added

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

Alexander Gordeev (7):
  mm: Make lazy MMU mode context-aware
  s390/mm: Complete ptep_get() conversion
  s390/mm: Batch PTE updates in lazy MMU mode
  mm/gup: Cleanup pgtable entry accessors
  mm/page_vma_mapped_walk: Use ptep_get_lockless() for lockless access
  mm/kasan: Introduce helpers for lazy MMU mode sanitizer
  s390/mm: Lazy MMU mode sanitizer

 arch/s390/Kconfig                |   1 +
 arch/s390/boot/vmem.c            |  32 +--
 arch/s390/include/asm/hugetlb.h  |   2 +-
 arch/s390/include/asm/lazy_mmu.h |   9 +
 arch/s390/include/asm/lowcore.h  |   2 +-
 arch/s390/include/asm/pgtable.h  | 213 +++++++++++++---
 arch/s390/kernel/setup.c         |   2 +
 arch/s390/kernel/smp.c           |   7 +
 arch/s390/mm/Makefile            |   2 +-
 arch/s390/mm/hugetlbpage.c       |  12 +-
 arch/s390/mm/lazy_mmu.c          | 401 +++++++++++++++++++++++++++++++
 arch/s390/mm/pageattr.c          |  45 ++--
 arch/s390/mm/pgtable.c           |   8 +-
 arch/s390/mm/vmem.c              |  82 ++++---
 fs/proc/task_mmu.c               |   2 +-
 include/linux/kasan.h            |  16 ++
 include/linux/pgtable.h          |  46 ++++
 mm/gup.c                         |   8 +-
 mm/kasan/common.c                |  10 +
 mm/kasan/kasan.h                 |   2 +
 mm/madvise.c                     |   8 +-
 mm/memory.c                      |   8 +-
 mm/mprotect.c                    |   2 +-
 mm/mremap.c                      |   2 +-
 mm/page_vma_mapped.c             |   9 +-
 mm/vmalloc.c                     |   6 +-
 26 files changed, 805 insertions(+), 132 deletions(-)
 create mode 100644 arch/s390/include/asm/lazy_mmu.h
 create mode 100644 arch/s390/mm/lazy_mmu.c

--=20
2.53.0


