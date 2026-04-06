Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 497BDEF4ECB
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34DD6B00A0; Mon,  6 Apr 2026 05:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8546B00A1; Mon,  6 Apr 2026 05:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D4AD6B00A2; Mon,  6 Apr 2026 05:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7B06B00A0
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:20:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5778058773
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:59 +0000 (UTC)
X-FDA: 84627586638.17.66B5101
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf01.hostedemail.com (Postfix) with ESMTP id ECF3B40013
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LDFARfW0;
	spf=pass (imf01.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775467257; a=rsa-sha256;
	cv=none;
	b=g0lj6fPR+j3s/xgg0+4hTxAUjFA0C4MYbhGISRgK++q57GwhKNWt9b3+uoGjorjJeqvzRE
	zwDsy7TEDD1Z4vxlObfFZgt9F3fEIrWK9IQ4bF596820odk2taO0/OUyfj4PmQtIKwapdk
	p0x5cf8td42GhEZTkUa160FUchhA9Ic=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775467257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OT+OQFCgRq+Kj1jonLnfSvCEwfsneE3cw0acLy20e6Y=;
	b=VPZ883kTz4ehHk2xinanop7qqglQoBHJoEwur+usencTQaTZ5aJVsPcAQwveAZW7VJELtl
	ZV43ZgWt4ctLmIeYhCWhnhzv+vGJ1rP3QqzrRLheAf3poW5AnLVhXDH3TtAxAxo7yPyans
	AsAw6Z8BPd4bAtqisXVe2azPDv4vPLc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=LDFARfW0;
	spf=pass (imf01.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 635HRL7A3181379;
	Mon, 6 Apr 2026 09:19:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=OT+OQFCgRq+Kj1jonLnfSvCEwfsn
	eE3cw0acLy20e6Y=; b=LDFARfW0396bSv3hZUqUyTZWS04rwq41y52Xi+92KxFF
	zMc8SdwWZv4t3a+Lpi/gpkv9TEk+EcZxgD+/kvsncXz31Fo0bx+BdAvZDwt8bUqB
	s9MLeLNYSaf+VfmTM4iZGk+lvAApWCozJhUho+gMqNlFMeGBgZYiwjXNAMX8PekB
	/eVb5/X6rbjka4IfNHA/IElhwuzYzKgVUCES8jqtF4mscDSXbllZMSq/chqncAEY
	F1x1KEtw7OLmp6iZmcXyCUJylhEHCTnkCSFl8FK1HFmMe/CZvGOZAx99ixSKYEcM
	Xr5BZSLsTFCbMhp2iKfPHR7MyIuSNntVMwQquUrEPA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4datap5vnk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:19:47 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6365ZcD3020501;
	Mon, 6 Apr 2026 09:19:46 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dbdync2v3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:19:46 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6369Jgdb35717392
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Apr 2026 09:19:42 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1790820043;
	Mon,  6 Apr 2026 09:19:42 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A062620040;
	Mon,  6 Apr 2026 09:19:38 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Apr 2026 09:19:38 +0000 (GMT)
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
Subject: [PATCH v4 00/15] selftests/mm: fix failures and robustness improvements
Date: Mon,  6 Apr 2026 14:49:19 +0530
Message-ID: <cover.1775466329.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=Bp+QAIX5 c=1 sm=1 tr=0 ts=69d37ab4 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=2xlL1Z9U7jiVjyWPKcYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=O8hF6Hzn-FEA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDA5MCBTYWx0ZWRfX/jT3q5ilpa6R
 aEEHN/YCS8iqXs8PaeYs2AacTfE8kLrbWHvn2HVKMXYuXDsGNHC1S203Oqrhmv5yoBr8zFu1yjy
 uj0ydsdIXafr9J532erS6OTOhxGVibodUczxZ7bTV7mam/CoQd8QIWl3nRvlPeTbw7ORlQX0Bbd
 2Kypj/SSXoa0NjpW9PnO5UmfPCiIzIkAfR3d2Enil/74TvTl09FGWbn0JHT4aNAQvyPCuPayV4Z
 k9DBOFpdfpvzBC+Wx4KEXPgxnJajqgXRLu+wNisH3k6JHsb656K45pQna8SN7OORFUfcZ24G2T1
 IBZrdtpBtytmrtc/cn7B+f5kswfHutwfks85DlEgndt7UR8+WpJtUPfq4oesYWE+XPrZf7GFyNb
 fdthDApML3C0gFmH9CDo7zCPHNADe8qRQKcGjbH1uFmF2qrMyuDFy+pE1cY+UjwAgHnsTvf+3un
 fYVe/H+/KFzyLbH/7/A==
X-Proofpoint-GUID: nuLxCR4AYTgo-aewaKBiI37kGt8DfwD9
X-Proofpoint-ORIG-GUID: rdqO_gI49MAxaHxdkg0qFKKrMoQcTweM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604060090
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ECF3B40013
X-Stat-Signature: d8grukjunbeq471opn8e7u64fw3pyc68
X-HE-Tag: 1775467256-919738
X-HE-Meta: U2FsdGVkX1+GaY1VCWMwD7DH71g+mEeWRzypPNZL/PwFfXs4uXSlNeafRDyxnRKixfCYphqpHX9UebhGZV8JBKkclNz8CxOvsAfDkSn2xNFI8ud4xGg3WtMB92ENr4nqW1uWI5qnAmqcvho9i57HDdTHgN+nFgW3vxxsFYMXuA7PCQkVR6BIS+osuXkZ0oY5P5iRwmnG4XZmNaDBQBJt+rClFdpcuf2rcLEiCRfahWth3vtkHjqWZF3dIjeWXFWc9JmTz7jKYFjmQ2iIa8hMuV8FyOWCCJQYPx1OGaWuMi4y/jrl53Ftae8ylfjTtJRJOopcEJ8eMIg/BC7fxN4lyTUAfJ2gh4nVrpVSWBNRpS6+qhZbDg40sHsLUR2K5EF6TcLOpMVWIEIv9In1AYBondFVoKnyy0nHCaQZjW2RZnD0E9sgLUARFk+9rc9nyCh7KywFLHe/J3IOhDj4sCvXIWxMjnStAomZbgsT6hA8hbG7pH+3EkN6lMXJ6zt/hl0BYdlYkNcVxSW++qi33pAQ7vDZXkoxznEHCYvnwhqmqWm+9dgKYH8qY15bqg+Pee6nXoTwxbYQp/X6en52kvQWbMrWqsK4GPquOgzChyiYBDwKRe9GPPE4hgRC/tY/janf5srjaqcAajc9/dsyly/xJldnKhDAFDOPOeqh68VCmo6PYVrldqOeW1VqvR9/d5rxWIDPMm34SSeExmqDilG9XNcg3J98EmHxyxshDs00rPV0SD/Z7W7a2uFoOfOJtRfuExTpoQ32Kqu8NeIC0lVFoxSrW7Glwj79O0laYayFk/G7DQhzqyP1jyni+KlCUZY7cICtpnldDKZExII+zJRwHtF3Mo4xeP2ioxcHYzmvanfen0LIzQl9V8/RbvnEUeEV8/EhSUwetgy3+Gxpk2ZQA0F1BBBwnBQGdhkbAm/2HV0o46HLUFkETjtkFzWyHAxlG4yFuv7L9T9FsCBfg9e
 zSZd784X
 Aa1bUamvj1CS3dOozl12P+uPESihjWlojKGp0i2fn6XpKipGHL2Dte2toZBAklngMQAyxvu6fxUfCLAvxSR7ZrnH6k1vTNBXGbsnBnoFkO+ysMCvE9J/PjO6LDszxFzJmVvro/sm/LVxZE9Q4QJy9k7rvK1eO+GiLmqqXrhmvCn3aEdFcNW5JRfvXjnH5NXvm+P4tkognN/OT1Z26283ahaTl5Q+bA+k3fA0szAHuOj5KIqVxM1tqTxnK/eK2nxkW9E6kMOM/8lI5yOg9gLyu9/AX4TA63MeQ4TSd0kz4yxAbExdcYnSAoWr8BYkLnSr6AKyi+e9/y4vyZLTDQp0a3vf7SHImN+0YN5v8
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

Sayali Patil (15):
  selftests/mm: restore default nr_hugepages value via EXIT trap in
    charge_reserved_hugetlb.sh
  selftests/mm: fix hugetlb pathname construction in
    charge_reserved_hugetlb.sh
  selftests/mm: restore default nr_hugepages value via EXIT trap in
    hugetlb_reparenting_test.sh
  selftests/mm: fix hugetlb pathname construction in
    hugetlb_reparenting_test.sh
  selftests/mm: fix cgroup task placement and drop memory.current checks
    in hugetlb_reparenting_test.sh
  selftests/mm: size tmpfs according to PMD page size in
    split_huge_page_test
  selftests/mm: free dynamically allocated PMD-sized buffers in
    split_huge_page_test
  selftest/mm: align memory size to huge page size in hugepage-mremap
    test
  selftest/mm: register existing mapping with userfaultfd in
    hugepage-mremap
  selftests/mm: ensure destination is hugetlb-backed in hugepage-mremap
  selftests/mm: skip uffd-wp-mremap if UFFD write-protect is unsupported
  selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
  selftests/mm: move hwpoison setup into run_test() and silence modprobe
    output for memory-failure category
  selftests/mm: clarify alternate unmapping in compaction_test
  selftests/cgroup: extend test_hugetlb_memcg.c to support all huge page
    sizes

 .../selftests/cgroup/test_hugetlb_memcg.c     | 90 ++++++++++++++-----
 .../selftests/mm/charge_reserved_hugetlb.sh   | 45 ++++++----
 tools/testing/selftests/mm/compaction_test.c  |  3 +
 tools/testing/selftests/mm/hugepage-mremap.c  | 42 ++++-----
 .../selftests/mm/hugetlb_reparenting_test.sh  | 59 ++++++------
 tools/testing/selftests/mm/run_vmtests.sh     | 52 +++++++----
 .../selftests/mm/split_huge_page_test.c       | 27 ++++--
 tools/testing/selftests/mm/uffd-stress.c      |  6 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c   | 13 +++
 9 files changed, 220 insertions(+), 117 deletions(-)

-- 
2.52.0


