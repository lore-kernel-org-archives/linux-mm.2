Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F920CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 06:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0FDB6B008A; Thu, 21 May 2026 02:34:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0CD6B008C; Thu, 21 May 2026 02:34:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0256B0092; Thu, 21 May 2026 02:34:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BA2CC6B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:34:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 753421C1773
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:34:10 +0000 (UTC)
X-FDA: 84790462260.08.EF77FBC
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id 128554000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:34:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="O/BSAGw/";
	spf=pass (imf27.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779345248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=g9WVnCA24T2oL88dvdbZWW8RyQkE/CjsO7VzbhzZYnU=;
	b=RMvk0+/QhLZa910pV5K4udxvgsFfp5QQdhGwTWJreHLbGLxv7P8mi+xODbdJy48h8IB4RH
	GinsNK1iv9SI+o+xyDpSZLHYrxbc8AeaOgwEuqpZ9VZBZqrmK4ZnacNd13T6TE86XZRZG7
	lnNcKAa9e9c/oKSXWDNCtWmsj+aQVIc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="O/BSAGw/";
	spf=pass (imf27.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779345248; a=rsa-sha256;
	cv=none;
	b=ASniqHqFhZ7qbBwkoafaVRPIXt7LZ4EC2rMBUUlIrPYhzY2KsLhH3o0reABySNo7uO5hLq
	I51djs6CtG9cISp35PYXhFJtb+wp0XmRcDr4CnRTNeeBhdy2ntfLdE8YRtE010jaFWeD1E
	Ts4eZOkgcl2VhBDhJoor/diWmcxnAZs=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KNlX7S3300127;
	Thu, 21 May 2026 06:33:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=g9WVnCA24T2oL88dvdbZWW8RyQkE
	/CjsO7VzbhzZYnU=; b=O/BSAGw/6S0sC1qAt/fNchCv+7+gnycgBItLhI/GrG5P
	4iL18vwuR3R3DrNzBG32bOO4huPvgXDDgCpX1P/vCQgerNTrtE8YXjqJmDYQ57Fp
	PLM8nLDNCsGtOLneBXtCNXrfVKaHWHa1XUTUp52UwcHdX0cBQuCWs14LCkjMgHjx
	+Cp0071z4yFUkpH1vx4MeGfI7hEXN6vpyFJaKvZzqGZ0I+050lFzoTGpRAMhqtmR
	SvCJ1fRaK6jDnRrvSKHDkhnLbwwAu45Pmf0fgZ+EVB2Ol2BfMIPp7IxuWBUyI0zd
	G1Z1bL9Hi8NNwIjOK0XZtPKUpd/qOIpTVOfasY++BA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h8mwe7m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:33:54 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64L6O5lR030810;
	Thu, 21 May 2026 06:33:53 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e72wqb0qt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:33:53 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64L6XmJr26149286
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 06:33:49 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 11ED92004D;
	Thu, 21 May 2026 06:33:48 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE07120040;
	Thu, 21 May 2026 06:33:42 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 06:33:42 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Miaohe Lin <linmiaohe@huawei.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
        Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH v7 00/13] selftests/mm: fix failures and robustness improvements
Date: Thu, 21 May 2026 12:03:26 +0530
Message-ID: <cover.1779296493.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: hz_YckkSsHYZrecc5lNdrGv9IQuwwQhn
X-Authority-Analysis: v=2.4 cv=GYMnWwXL c=1 sm=1 tr=0 ts=6a0ea752 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=8uJy_1Y6CBqRYfEKyIkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=O8hF6Hzn-FEA:10
X-Proofpoint-ORIG-GUID: Yk5UnuRzX8TjhS7V9Py9-Hz9jIEhf8mK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA1NyBTYWx0ZWRfX40wz7CRbj800
 Ic8o853IFxhsWyXDz5rrXeWdj6/jw1+vJevkZD7uap/q64XNI2ebKact6M0CrsRKExFbg07Bn21
 nMJewHLLwwORDvOIlJqrMxg1p8K++JmYXiUODQP30CuC0MQ6MLYtKDv07G0VBeaJc1/uogs6BRW
 whN23xeZI9OPD4W1egQy2iPkCr9GkAGFTy9OjMKuyGbmhyb4d0FvT3CIbG2gIWjDU3oq+9yd/hv
 I04CdNnJ3qG9qMaU/qhvkPIojPDHVliceZ65uBCLNBtlJT9YA9rwnX1gWbJO+SeYQXFKBQdhmmo
 14cwti/DbfGchvps2bn1E6tGA7mb4cZYjat86fji07Oht08nlQZF6c1DB7Gtwb8+KhdEM6+/MoT
 qsZKALSAtOgARSogvGHH2d25H19Z9xDnu3ldQSVxPlTzbgro7uA+eLahyPuCUCRjyGRKVUtFh8J
 hsu4iAloysIyGSFRgVg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210057
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 128554000B
X-Stat-Signature: yt65yyp7mdj54dt4h43xpob3c6cmj7ph
X-HE-Tag: 1779345247-516075
X-HE-Meta: U2FsdGVkX19SJnjCDaif06B22lz7kcQIUjIceQiniY8UnILeSkNjec03E3MwDeCIpIsDtgKqzz9qSC3dXMQk2zy0AjBWTngxhMkSTwiI8GVUYGQCToHinEDZ4HPADQjYDdXro+VeOX1Liu+CtYSEUFHAMKcaFJZwyTZxOWK7FUnNfYY8UunSEmBaC85ijvxLgiVsncCu08LoHMt80U5aoeG11a1wc4lk2qyWcRxCvpJKfQ/gFJq6A+Nes3c+9z6egS98lzLe5A0xBDoHBBT6iNWJcmJuFEjeWq/x/LqvEQTBzftBaBw8ExWGongk0Fm7hkDmgGvK+tnWbVg0MwKUtM8QHkxx0wSjd0QaChXQO3hhK8DJiZ7640wQBBNHMOkqno3ezFApx1ZOlTJ/MIwV6RhdlZeARzR2TP1nLJ5Jt1W8QNw9mZQG3hX9wM3ED+7PT6cwNz7UwuYblazJLCMHW2S7s77Yh/pr60lp9/Scg0S+p21+y+3z5rEV2jW4+pM0D2UGqlv7skXdyqr/1SxytseW73FPl+ocrtMYQbxdFrMKXbi/b4bs/eFy/aH9O6DRJe7uPjIX2QnNfLtE5uSZAGixCVw94vWvivtmLQmWr3xvqrr8wole+nX2cBsaIZOvCFaZXw+9Rrgl/NI4POLA6EwuJ7EAwn98+n9X9nJBK/py0VzjAObIe18/pJAucCmM2O0oQVBPvQ5XYwqmXzeTv+mFL8nTYWJTfwXQuRhM/zwZBH+ZcSHWbMeFf8GIzQ1T9QoeZB5q9+zwy0SOFbG7SZhKw9XQJ4xv3+qgIFIeTXLEV9ThFRUO6gZwSxfucCC8pqbFv94KRySMysgatucMnzZGxkld87nS10cvR7q0zHgYVy2dFWSptKPzLYcLUw14hM1DPo69AvZOhiVKVOpwFFdEqNkOOMjfOwClh08BcSd+3l+lVNIQM84y6bbWl+9qER/3/HLMHODztfty34D
 yOARkkn1
 jIN3l/n4OjTuHHSZX+PQlW6AufFFyxcu6tUYEq9J2gqjVMBme0x2qbkGjwKv0U8zqaYGKeW515jVVujUP0MDU9xo+sKCXOt6MsgnsCjJK2RKyDQTdRjmjQ4WyBONqqiBg7AsGxHgVAdziPFAsa5yFoZ1A0tIJ3CewDEc8SGdBn/I/3YXrv59eOuc1qUsoZcNBvCLtiz9d0PvkvyiAQ8m3S7unfBQko8pS0bloBV6r/fPr1arkg68BaxtAMtxK8QplZSqP3d2B7IbzhXIzEBBqdV0n/LadgzGkbeOrH23X1SkcCLgzEA8ChEFEL/Sdf+4DijuVnvJcgB4Sb2azm9Gstj7SDYp0xBsDVYPo0weXYrMn8p4AGjHP5kj/xTKdmGfQvzdreB+zdRee8OKAFMckoAErbr0Er5FvzO18m1zijsiq019HLo/z2tLhRpFT6EMax62f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi all,

Powerpc systems with a 64K base page size exposed several issues while
running mm selftests. Some tests assume specific hugetlb configurations,
use incorrect interfaces, or fail instead of skipping when the required
kernel features are not available.

This series fixes these issues and improves test robustness.

Please review the patches and provide any feedback or suggestions for
improvement.

Thanks,
Sayali

---
v6->v7
  - Rebased onto the latest mm-new branch, top commit of the base is
    commit 0cec77cfd531 ("mm/filemap: fix page_cache_prev_miss() when no hole is found")
  - Dropped "selftest/mm: align memory size to huge page size in
    hugepage-mremap test":
    Similar patch has already been merged.
  - For "selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero":
    Changed format specifier of bytes to %zu as per review
    comment.
  - For "selftests/mm: move hwpoison setup into run_test() and silence
    modprobe output for memory-failure category":
    Added condition to avoid executing the test pipeline for skipped tests and assign
    ret directly.

v6: https://lore.kernel.org/all/cover.1777877814.git.sayalip@linux.ibm.com/
---
v5->v6
  - For "selftests/mm: restore default nr_hugepages value via exit trap
    in charge_reserved_hugetlb.sh":
    Extended trap to include INT and TERM in hugetlb tests to ensure
    nr_hugepages is restored on signal-based exits.
  - For "selftests/mm: restore default nr_hugepages value via exit trap
    in hugetlb_reparenting_test.sh":
    Extended trap to include INT and TERM in hugetlb tests to ensure
    nr_hugepages is restored on signal-based exits.
  - For "selftests/mm: fix cgroup task placement and drop memory.current
    checks in hugetlb_reparenting_test.sh":
    Updated the subshell invocation to pass variables as positional arguments
    instead of interpolating them into the command string as per review comment.
  - For "selftests/mm: move hwpoison setup into run_test() and silence modprobe
    output for memory-failure category":
    Updated the condition to avoid unconditional module removal and ensures it is
    only unloaded if loaded by the test.

v5: https://lore.kernel.org/all/cover.1776150071.git.sayalip@linux.ibm.com/
---
---
v4->v5
  - For "selftests/mm: move hwpoison setup into run_test() and silence modprobe
    output for memory-failure category":
    Renamed LOADED_MOD to LOADED_HWPOISON_INJECT_MOD as per review comment.
  - Dropped "selftests/cgroup: extend test_hugetlb_memcg.c to support all huge
    page sizes":
    Due to intermittent failures observed on some systems.
  - Added Tested-by from Venkat for all patches.
  - Added Reviewed-by from Zi yan for patches 7,8 and 13.
  - Added Acked-by from Zi yan for patches 1 and 3.

v4: https://lore.kernel.org/all/cover.1775466329.git.sayalip@linux.ibm.com/
---
v3->v4

  - selftests/mm: restore default nr_hugepages value via EXIT
    trap in charge_reserved_hugetlb.sh:
    Updated to use an EXIT trap to restore the original nr_hugepages
    once at script termination, ensuring reliable restoration on all
    exit paths.

  - selftest/mm: fix cgroup task placement and drop memory.current checks
    in hugetlb_reparenting_test.sh:
    Updated to use a deterministic synchronization method by migrating the
    workload process within a wrapper subshell before calling exec() to 
    ensure correct cgroup accounting.

  - selftest/mm: align memory size to huge page size in hugepage-mremap
    test:
    Update test code directly to align memory allocations to the hugepage
    size, rather than modifying run_vmtests.sh. This replaces the previous
    commit “adjust hugepage-mremap test size for large huge pages” with
    a cleaner, direct approach in the test itself.

  - selftests/mm: ensure destination is hugetlb-backed in hugepage-mremap:
    Updated to remove MAP_POPULATE flag for the mmap call as per review
    comment.

  - selftests/mm: skip uffd-wp-mremap if UFFD write-protect is unsupported:
    Updated as per review comment to initialize features to zero and exit
    on all uffd_get_features() failures, avoiding spurious test errors.

  - selftests/mm: move hwpoison setup into run_test() and silence
    modprobe output for memory-failure category:
    Declared LOADED_MOD as local variable and avoided a redundant 
    skip message when the module is not found.
    Updated logic to set exitcode to ksft_skip only when no failure has
    been recorded.

  - selftests/cgroup: extend test_hugetlb_memcg.c to support all huge
    page sizes:
    Updated to skip on memory constraints instead of returning
    EXIT_FAILURE.
    Updated the logic to fully account for the scenario when the
    per-CPU stock is empty and a refill charges MEMCG_CHARGE_BATCH. 
    Updated to avoid overflow on 32-bit systems for memory.max value.

  - Included "selftests/mm: restore default nr_hugepages value via
    EXIT trap in hugetlb_reparenting_test.sh"

  - Included "selftests/mm: free dynamically allocated PMD-sized
    buffers in split_huge_page_test"

  - Included "selftests/mm: clarify alternate unmapping in compaction_test"

  - Dropped "selftests/mm: fix double increment in linked list cleanup in
    compaction_test":
    The behaviour is intentional.

v3: https://lore.kernel.org/all/cover.1774591179.git.sayalip@linux.ibm.com/

---
v2->v3
  - selftests/mm: skip uffd-wp-mremap if UFFD write-protect is unsupported:
    Rename function to check_uffd_wp_feature_supported() as suggested in review.
  - selftest/mm: fix cgroup task placement and drop memory.current checks
    in hugetlb_reparenting_test.sh:
    Drop memory.current validation from the hugetlb reparenting test.
    Keep tolerance at 7MB (reverting earlier increase to 8MB in v1).
  - Included "selftests/mm: allow PUD-level entries in compound testcase of hmm
    tests" patch:
    Extend the compound testcase checks to accept PUD-level mappings.
  - Included "selftests/mm: replace hardcoded THP size with runtime PMD page size in
    hmm tests" patch:
    Use read_pmd_pagesize() instead of TWOMEG and cap maximum THPs in
    benchmarks to avoid integer overflow.

v2: https://lore.kernel.org/all/cover.1773305677.git.sayalip@linux.ibm.com/

---
v1->v2
  - For "selftests/mm: ensure destination is hugetlb-backed in hugepage-mremap":
    update FLAGS definition to MAP_HUGETLB | MAP_SHARED | MAP_POPULATE and
    used it for mmap() calls as suggested during review.

v1: https://lore.kernel.org/all/cover.1773134177.git.sayalip@linux.ibm.com/
---

Sayali Patil (13):
  selftests/mm: restore default nr_hugepages value via exit trap in
    charge_reserved_hugetlb.sh
  selftests/mm: fix hugetlb pathname construction in
    charge_reserved_hugetlb.sh
  selftests/mm: restore default nr_hugepages value via exit trap in
    hugetlb_reparenting_test.sh
  selftests/mm: fix hugetlb pathname construction in
    hugetlb_reparenting_test.sh
  selftests/mm: fix cgroup task placement and drop memory.current checks
    in hugetlb_reparenting_test.sh
  selftests/mm: size tmpfs according to PMD page size in
    split_huge_page_test
  selftests/mm: free dynamically allocated PMD-sized buffers in
    split_huge_page_test
  selftest/mm: register existing mapping with userfaultfd in
    hugetlb-mremap
  selftests/mm: ensure destination is hugetlb-backed in hugetlb-mremap
  selftests/mm: skip uffd-wp-mremap if UFFD write-protect is unsupported
  selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
  selftests/mm: move hwpoison setup into run_test() and silence modprobe
    output for memory-failure category
  selftests/mm: clarify alternate unmapping in compaction_test

 .../selftests/mm/charge_reserved_hugetlb.sh   | 45 +++++++++-----
 tools/testing/selftests/mm/compaction_test.c  |  3 +
 tools/testing/selftests/mm/hugetlb-mremap.c   | 32 +++-------
 .../selftests/mm/hugetlb_reparenting_test.sh  | 60 +++++++++---------
 tools/testing/selftests/mm/run_vmtests.sh     | 62 ++++++++++++-------
 .../selftests/mm/split_huge_page_test.c       | 27 +++++---
 tools/testing/selftests/mm/uffd-stress.c      |  6 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c   | 13 ++++
 8 files changed, 151 insertions(+), 97 deletions(-)

-- 
2.52.0


