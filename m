Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB8C3CD98F8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 14:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B42E06B0088; Thu, 18 Jun 2026 10:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF36C6B008C; Thu, 18 Jun 2026 10:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A146B0092; Thu, 18 Jun 2026 10:47:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70B666B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:47:40 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECB3BC01BB
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:47:39 +0000 (UTC)
X-FDA: 84893312238.09.0537D56
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id 94D82180002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:47:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iSKJjA+X;
	spf=pass (imf24.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781794057;
	b=FT7IxkPdK3Af01emt5eDzhqQgJGF3UA1WY9KGyL7Z2JV26EKiy5O6G+chHrt9dtb2PAydi
	/ss+Fw6y9MQNNaD494TINLLIYpVS5i724P4OAjfk5gilO01RkhN8yNE27xQN1UkbXye6DE
	yL/71Vuk/B/lysZPX+EoUSrpUxEN3W8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iSKJjA+X;
	spf=pass (imf24.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781794057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nBocLtnNWkEW0LgQ0lTGeERkqajb5IUlQLup1K96h70=;
	b=vaHe/RjN3Fzfrmdm0d9iXCcWVeGtuzu5LEHQsx41LpSfldST7cKmJ3sDDjOzDk3bqjzUv3
	x3zfMZxaGWySDyS157bz6Ugwqr3yp3kYEoyvXtLX1OyYhAGeynIxwxKqfDGJF/G/O4FAkl
	B2tT4KOYH0l2Ts3x5tg0ykZ+Ee06Jic=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65IEIFBi3688625;
	Thu, 18 Jun 2026 14:47:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=nBocLtnNWkEW0LgQ0lTGeERkqajb5IUlQLup1K96h
	70=; b=iSKJjA+Xsu2yHRBTgLyzIrOopuE+ohd4DxhKOUAAyjYQarckRAlHk6kwM
	mQVf8tkBde1llOYtfi88NMY0lHWTSPWJPJBn8cjKgdd46zNRXnp3fg3pxHnPuKZq
	jj+YKVq5e0gRZS0hXp2odWCNj5d6YWRViwyYoSo3rrPB7PuQz3GrLV3cQC4bb4O0
	+R271R3PKyIYxJpDyudjbYw70FHFhIHML+qtc01zXgVaucUPdHQxIbNFUhwGvBTL
	Gr/4xYKmN5ilL5fJY4W5bPE4X+F+XmL4df9ORsOj/hLIfiMkp+JoHOeoqyPhviOU
	c6L/AyS+bPlHch6KYfu8qwynkBnug==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eueqtrq7y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 14:47:33 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65IEYaum012600;
	Thu, 18 Jun 2026 14:47:32 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ev17247tf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Jun 2026 14:47:32 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65IElTkO49873332
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Jun 2026 14:47:29 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C0722004B;
	Thu, 18 Jun 2026 14:47:29 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E2B4E20040;
	Thu, 18 Jun 2026 14:47:28 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 18 Jun 2026 14:47:28 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 55669)
	id C4B59E074A; Thu, 18 Jun 2026 16:47:28 +0200 (CEST)
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH -next v4 0/4] s390/mm: Batch PTE updates in lazy MMU mode
Date: Thu, 18 Jun 2026 16:47:24 +0200
Message-ID: <cover.1781789772.git.agordeev@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jVQySmv3zW6sPQjwDmrcsCyhbJDMY7ZC
X-Proofpoint-GUID: jVQySmv3zW6sPQjwDmrcsCyhbJDMY7ZC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE4MDEzMyBTYWx0ZWRfX9SMUhdzZbTnn
 I0Fzmgv4UY3basnvEQ2JRHDhnK4j/KXsCSxjGZgSvdJEoXnnNhc+PcbMlA/N79RSyxerFJfAt3n
 88HQvA/LJ1GrnolnG+fMS+ynuvfDe0jJNch0l453OjGTUTTsZKRiNr2xlwrFo1aKNuecY6zJQWV
 OCpcmEnGaaF6RSMV5594lHVQbb8IyqYu84TWyrKsHm66JgwzuLApjzZxPIMetphlcs06+MeiQ9I
 C3y7nA7U/LQaYpBo0XxUAZJhOf4m73wQacEPAowIiS4DpfOA8poInYMc2sjOr6XpiAFUIToKVLA
 laKxCKaV8+fa30nctttnehVXJPm1TDTvXp0jhVXNzy2wb82KtM4QG2X6RNj77FW6ION+yrekwJj
 Y9h8vLkzJuGC9dH27t+5JlTZjter+tfb9+xB6RLQmEFD+wP/N+4lF0zqtL+OPggXacK0xBJ1VDN
 86kIvkk46LoeDqDVK0Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE4MDEzMyBTYWx0ZWRfX4K5E1EbtiOnl
 TlGGf0gjXYq6bnEIN2wnAQVVokTZ9rSzU+2Q3GJWYLlna+JwSs20eV/OdixaKUz+0mThHo79dN2
 Fa6QszUPoEp3BBXF8o2bTZGEQ6tf+6k=
X-Authority-Analysis: v=2.4 cv=B4KJFutM c=1 sm=1 tr=0 ts=6a340505 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=c92rfblmAAAA:8 a=VnNF1IyMAAAA:8
 a=TRBNZcfPePrm8P-CY9YA:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-18_02,2026-06-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 spamscore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606180133
X-Stat-Signature: kciwksmtx6et7w4jcg7urnkrftgyhsef
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 94D82180002
X-Rspam-User: 
X-HE-Tag: 1781794057-440803
X-HE-Meta: U2FsdGVkX1+P5aBV18j3+rqUHNyk/Oj9g0xyUf3TSWSZCtz35fJkWLZboN9718o1JL/ZxjYMiYxO3Tb4/UpGc7+ch25hUJg0SqbtsVCk3aH3DOwoRLQP9yztC8n0XdVbIO7fUzUiYN+BW/m6LT7v/qEGs0IoXpWlMIMyzEQyh7X3o3gxdV7RJVR9cwVlqhUGwbqaESI4NTtqj26db65MmUhKQlChyw34troaz1jvV5JcHjYB8yu4itYaQbdAqXdMmi/2tr0usF/pzYvTV/tTTaSS8U2XMWqMjLIYhwvNBZfwdRTmFjMoPcTZFuL1ARmi+k0ZO+4IyH+4cS2WIbBJHAEAwxPOdIdQYAvQdFVtHS5toSxive98gjs7djwAzHMNXZLx4XEUfboYK/MVZnR9cKx68V5Oaf6LKCraU5rzHG/t8y0lIQc0EvRb3masMadU46c/wvRf+BwXx+uBLyS2QbNxyBypjAyyd17ELA636M0NNTm1szXKdkVFtzN400I3b55UTuVXfjrYlib+css42aA3ieI7YF0RdIhS3jHBYYyznPzCZTAsh8sptsWgWQPVfmkFWveLVU9ATRC2Ro///utzpc7i+/HWc1a6rFohypM18sxWu1aScStfD9/C2RzVqJz/8+3xcylB9u0mmCW5kd1P/TFvq2Fj1c74fhf9P8iLmmweH2QbWOP3k1GPp+gNBBMsQQAWV3rZETuFdACF6uL/Ksi26e0XZ2ofzonizsMcH7j6jZnvt31CxmDzkcBZgH/LDP353RIlJ4s0DBLl8AFT5bN1Bg0JhhDwptiUUmhFYOm15MsbcHkstOVJ2fxcDQuBO9eyfmVsjxginpuXR5saDYv7msNjSmWkzw6HqeDfHkEvhgx+NIJ2Wb6Rl5G7RVy6Jq0WoJJlvSJ7NzDTBNrLZM8HHA/b5Hm9SxBgqWt9UJ0iKEB4HgCPHXYlyO3la2B3pTftqt1Fws98hRS
 Hv8/iXqx
 fwdBAJF93irjUYWWBSWPZLVuu+1qo3R71fWXDAg0hA0j11IUBdkSU2OSnoNAjbsrHjiAnopjwsZzo+L/t4ZTnstzIxVxmQvhaRfmhSPLbE00J5VuoD2o3I/LzDuW7rXrFjsJx7Ufwx75XDcbgoz8at+HIYu8/9DdA/JxN4tRP0xR4cWrQtG/jR/XGCaS4PRADhVxCKE3uezrziGG8sqT/Zi9vY522znxpu3Dg0anh5DLS5edBcLCN2j4TYfbsrsveVE2uFzxjPqFU91h8tMhvWRxQvpiW6bctNjRQPPnaHziaGU4rPXryjLjoV/UfPRlnROSeoZmBaOWXTY5SDt4a1XHgWIVQ3/0Gaact
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All!

This is v4 of the batched PTE updates in lazy MMU mode rework.

The presented implementation sets up per-cpu caches in the s390-specific
hotplug callbacks as opposed to CPUHP_BP_PREPARE_DYN hooks. I like this
approach better, since it locates the SMP-related lowcore initialization
in one place. But that is up for discussion.

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
 mm/madvise.c                     |   8 +-
 mm/memory.c                      |   8 +-
 mm/mprotect.c                    |   2 +-
 mm/mremap.c                      |   2 +-
 mm/vmalloc.c                     |   6 +-
 19 files changed, 659 insertions(+), 38 deletions(-)
 create mode 100644 arch/s390/include/asm/lazy_mmu.h
 create mode 100644 arch/s390/mm/lazy_mmu.c

--=20
2.53.0


