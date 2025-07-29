Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4CFC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 05:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45DA56B008A; Tue, 29 Jul 2025 01:34:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40E036B008C; Tue, 29 Jul 2025 01:34:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FC816B0092; Tue, 29 Jul 2025 01:34:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1A1BC6B008A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 01:34:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A09FE1DAE6F
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:34:24 +0000 (UTC)
X-FDA: 83716186848.17.9AC858F
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf23.hostedemail.com (Postfix) with ESMTP id 37C18140005
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:34:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="OI/gnrMH";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf23.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753767262; a=rsa-sha256;
	cv=none;
	b=hPhGJEB/G/Z7+HYsp1+gSQ89egYaLjkqOsv+QCiZxDwSW3M8WyXyiapK8dD86hCmBdaH/s
	ZUTbp2s/k5n59U6af0NlZGMf7q0Nssu0Du8Ro9iI3Mg3JGq1INQRGyaiRa5vSL7/sAiE93
	cq9d8XR8e++K0pJY9E7V4sH4saqj0nM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="OI/gnrMH";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf23.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753767262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BzKXBqbp/faCAopeARB3w/J9fSxnLWo9rSJqyHdAM3o=;
	b=nE6BqSPK5id8k0UuY4EwaDfAg9rU+0HgKHYpYRgOIMsLPHkCJFWKLrGEKoT/54t8xjQbZo
	ofnQwLZf0JW6Z0i1dmpjHtQBN4MrNHVJGLMSs75IrcS6/jolR87V8q4lNYJfHIuHlvyUHu
	lV3sANtvqiXiMD77CcdUla6oVZUFqYg=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56T4ZPIk015929;
	Tue, 29 Jul 2025 05:34:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=BzKXBqbp/faCAopeARB3w/J9fSxnLWo9rSJqyHdAM
	3o=; b=OI/gnrMHKGpSl8VLpprhPuUyTh6AUHfZENXhFs8AwYabXqP90KbxrrI3E
	l7v/RuzDAaiOrHvONgIA6xqBQOBN3aZSjme44it9kYzaMPhlAGo3NoPWHw+pj9vO
	r3M/6k4nHXPn66k7tdDJOzzC/5jrYh6ghmWqrUeRKHgrQjpmxSo7dkV2/BiPWG6b
	TJ/5L1VhjEfKnWK0SlWr1tsb8d3W8k1Sy6inVjCCLCl0DgaR0NdHts87gyiFS8Kw
	XLDUync5KlOfjRhRtzV+EAMGEOJgdlVodiJKFN6JR0LiTm6ljJ9RD0C4p8cXubfh
	L6WHFDw/yPnEz1kR9fhn3Hl/+TWZQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qfqmq5w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 05:34:16 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 56T5YFFs000501;
	Tue, 29 Jul 2025 05:34:15 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qfqmq5g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 05:34:15 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56T4JAqa015952;
	Tue, 29 Jul 2025 05:34:14 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 485aumgws4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 05:34:14 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56T5YABO48693738
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 05:34:10 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1668720043;
	Tue, 29 Jul 2025 05:34:10 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED14F20040;
	Tue, 29 Jul 2025 05:34:04 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.150.11.63])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 29 Jul 2025 05:34:04 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
        lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, donettom@linux.ibm.com,
        ritesh.list@gmail.com, aboorvad@linux.ibm.com
Subject: [PATCH v3 0/7] selftests/mm: Fix false positives and skip unsupported tests
Date: Tue, 29 Jul 2025 11:03:56 +0530
Message-ID: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDAzOCBTYWx0ZWRfX8hAUANN1wq0Z
 xjxSK5pUzlUOHIJMn+FZmhiDfOiCRFV0Ms/uKu8pUVh2GQaUmxXR32fVKo3xutEG7BupHvFB9OM
 4SRVAOi9Yz2ZGZ3fSkY1Ofag02wV+E4PB9QLO15bUG2f6i69SHZEVN1cp8E/G/dQZWyj8MiQGKs
 aoNrEBRoj5wZCU1hbelEXyzXbX6FJyL7gvHYyHXoSrBNsALALPewKbIftu+2KZQobJVKYYaIPhX
 QnjbZRtjpc+Jzkk3DA7p4/uFKG23qzY9ZOe4wBq9QT8T3Cw9K+Tctct9mrBEer6O8CN5lU/nNdG
 wRTnFt1VlIcM2WtFUqFYb5s05I56EYQSo9dlDPuQu/n3AHGbfEyzTze/n2PnX9W7m1ze3AQgzBg
 aKvvnzt06OqMAaVljKi2yieAaV6HNoezxJ9X05nAuZ8WEfHtV2qJu1PhXHFq6PVtKhNIUfW8
X-Authority-Analysis: v=2.4 cv=Je28rVKV c=1 sm=1 tr=0 ts=68885d58 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=irm_vNLxJShBRlos8zwA:9
X-Proofpoint-GUID: pw61ZIEWy7RakHmY0YtrLFjMg38otVvq
X-Proofpoint-ORIG-GUID: fqFVTppS9lOwJEJZYn1nMtUcYHS1_3iu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_01,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 spamscore=0 adultscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 mlxscore=0 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507290038
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 37C18140005
X-Stat-Signature: ghp8o3s3h88ezwm4qi1j4s8re4ituud7
X-HE-Tag: 1753767262-355383
X-HE-Meta: U2FsdGVkX18guEyMM0x7kWoSweoksiXDD+OM+iiqTOJRtca8l1vuZSqsvVzLoZLjof2yqPztvKCE/8aqjcS6wTX7yRVzmBvnTbJjPcN5mfhpxzFHhNyM6ak32a2We+Leucj4Tdi4bvk6xsbKgkmm/MNYFLwMZhzGwY1obRWwla0QRg5U9fp/vqiAZVOPxFkkTpYLSQR+OC/Byn/LFeYJGsPwq5jOv/llDJ9d3jkeY2D+04tXRU0s8u6+SpQoitjC/BxtFUGxhpkRAdGSajydLd7DfOXx7nAUNuBgxujka3e4rfnc0XC1mk0EA+7thmdhz/wHrh9Lr/cOizK/qrF8AYMROtlcg4/HQHlhaY6ESNvrPkBP11FKITCkDdxKMF6alj/1Gl1lL1y3l9YTDHJVMMjTLylta9lIBACOFLMM337ubngvD7NrRAoFCWjyqGjpAaOm9vFDc7aTuH1uRjAar8DLkMvoKNuSpU7+KZRzBQVgozY7SHWGgNP5tjK10fY7M9c0GUSOwuIPCiHsTiwYSUgals1LuHi6JS+2ojjS11aizlOgRdq+iXweJx+dw9hE+7tlT+3m98auUd5nwV+8GFJNpPbKmHcYiHN7oCISJtHGE4Mz45l6PTAc0uYp8f4T8UOZiToOYIP4frio8bD7GbiT8w9qtZWefrOteAL/lnbGcVJmWuz9CKcvFgliAIf/GtBEs0e0UI1Ss1JTxMXy46hYp8cAm5+Hzcws2hIE4GjTCJ31UWJvR6z6872soGsesMcwjc9fEImV6hcAmuqRlpN+bdcUSWVz/RczrGD9ARa1RBAWNsyfUgqXlZevl9pYmouT34uj0Ll9uRdeTrtgUmxsAm0WamdD2+9oowIsw8dihSm8Un7DX/CT4k6WQuOn/tUeFTOQfRqjkAkMRs/cxDQlewsL5RWvR0iWo3Q1V0X77bQXsPeuOOyYDQy0wzAdyGVbOgr/OStyzLuM7J5
 YR2vHvxi
 9N4ZheDtp3onQtpgX/Y7Xn4LpwWN138mCVf6YzpwpHZYOIjjqu1z0P/9ftq5lEQpBOTXZeJM1AW+ke66tmE28C+WTXCCkuiyQkgy00bC31BHzwVTvwXu5t0H9/0z872tXDG00Ii7pQ/Z4BwdNPiPioffTKIQGZ8kEW3KHvIiIrHZnfh8e4LUdy1LtGAnF11XQ6QJ1o8uVEbxkCY8ljzRumozn0X6NoLWjLAvg7b2Muyq+NZgXcbU0Ciy7UUTG5X5g3gdmiLaN2AMITbnljCEjv7QLz0oI+Ax0FJZf33pIjiVij34=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This patch series addresses false positives in the generic mm selftests
and skips tests that cannot run correctly due to missing features or system
limitations.


v2: https://lore.kernel.org/all/20250703060656.54345-1-aboorvad@linux.ibm.com/

Changes in v3:

  - Rebased onto the latest mm-new branch, top commit of the base is commit 0709ddf8951f ("mm: add zblock allocator").
  - Minor refactor based on the review comments.
  - Included the tags from the previous version.

---

v1: https://lore.kernel.org/all/20250616160632.35250-1-aboorvad@linux.ibm.com/

Changes in v2:

   - Rebased onto the mm-new branch, top commit of the base is commit 3b4a8ad89f7e ("mm: add zblock allocator").
   - Split some patches for clarity.
   - Updated virtual_address_range test to support testing 4PB VA on PPC64.
   - Added proper Fixes: tags.
   - Included a patch to skip a failing userfaultfd test when unsupported,
     instead of reporting a failure.

---

Please let us know if you have any further comments.

Thanks,
Aboorva

Aboorva Devarajan (3):
  selftests/mm: Fix child process exit codes in ksm_functional_tests
  selftests/mm: Skip thuge-gen test if system is not setup properly
  selftests/mm: Skip hugepage-mremap test if userfaultfd unavailable

Donet Tom (4):
  mm/selftests: Fix incorrect pointer being passed to mark_range()
  selftests/mm: Add support to test 4PB VA on PPC64
  selftest/mm: Fix ksm_funtional_test failures
  mm/selftests: Fix split_huge_page_test failure on systems with 64KB
    page size

 tools/testing/selftests/mm/hugepage-mremap.c  | 16 +++++++++--
 .../selftests/mm/ksm_functional_tests.c       | 28 +++++++++++++------
 .../selftests/mm/split_huge_page_test.c       | 23 +++++++++------
 tools/testing/selftests/mm/thuge-gen.c        | 11 +++++---
 .../selftests/mm/virtual_address_range.c      | 13 ++++++++-
 5 files changed, 67 insertions(+), 24 deletions(-)

-- 
2.47.1


