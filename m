Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AFACFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C1B16B0005; Mon,  4 May 2026 04:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8720C6B008A; Mon,  4 May 2026 04:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761006B008C; Mon,  4 May 2026 04:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 646C76B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:25:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F04C21A03E5
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:25:25 +0000 (UTC)
X-FDA: 84729053010.19.58E839E
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8A583180003
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:25:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jnBSbP1k;
	spf=pass (imf24.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777883123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IHNX7MRFT5w9RM/ynp0582/aI4gaqLiwyHf7ehX1XfI=;
	b=0fdowhd6SaWPtUPCOkJuQdgwSTye2i6evJocjq1Xjyod1g9zEUkYtHPo8FHduJc53VpQaL
	QzCwUZH96BM/SPSbBZCL6BkFX6jRgxOuOyCjdJ8YBT9DaqpCsTCmROc2ly6xj/mRr8/j5r
	esUkrU0JlD3CLDzA37DOfsJlhVd1maM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jnBSbP1k;
	spf=pass (imf24.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777883123; a=rsa-sha256;
	cv=none;
	b=JXclDPsCA8/vSaohCTfwylsZPX4echT+3gEvx1Rn56ceyU3dzAaYxMhPNs6UCpw8ZMmYEn
	N3R/rqALD5CrZJB8FhK8eEv5TY7EnsEvThZockuCUF72/65Hhl6p9J+qlfKVpvmhSS5dMw
	FR3W4/35LCRCyEgJUAVwbB32oDpJFNE=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6446S7YF599575;
	Mon, 4 May 2026 08:25:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=IHNX7MRFT5w9RM/ynp0582/aI4ga
	qLiwyHf7ehX1XfI=; b=jnBSbP1k3eLVfzsBiKLlDQzhPKUE+fQvwinC8TYKHi0n
	DwD0NW38zIeYP938BmClheRkHVIfP8e4VEqSv7zGCRt3i4k1wnaxWZ9m3cqJ2R9a
	mEJcraZaqxMMQTnzvuJihDRfOUcpwtS4V08OaWAVowoY4k7MKplYHSDVjafirGom
	i9Z+fhhPwiMkkVXeCfLWgKemr5hmixLLdtcNBe59TvEFv+6bCKYEbxmL7S3sxShI
	u3TA5F1+kw1bgeVHT+gXTrDT26iGwKgRS7BktOUhqlpZ+/L0IzVc1O//ekMmeYQy
	6+fbQJ4FahzrHHzPt9EZmFc16S1Dy6156cdn4c7kQQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y164d5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:10 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6448OOd2023531;
	Mon, 4 May 2026 08:25:08 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuyvve7w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:08 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6448P4SS52166976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 08:25:05 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D5FC62004E;
	Mon,  4 May 2026 08:25:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 883F62004F;
	Mon,  4 May 2026 08:25:01 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 08:25:01 +0000 (GMT)
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
Subject: [PATCH v6 00/14] selftests/mm: fix failures and robustness improvements
Date: Mon,  4 May 2026 13:54:37 +0530
Message-ID: <cover.1777877814.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: R29VylnpmzWk06t4o6p-1eSokrDQIb0M
X-Proofpoint-GUID: xCl2WFaP9RF3ZmxfC1TucYAXJWU_9KeK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDA4NyBTYWx0ZWRfX0w77sA23xMZf
 X9hb7uo086NCD910+27YnqeavrxSNIRnBg+yAatwzaDL6U/FF8nbQW/3EPzZDrz28/IRrRTEI3p
 P14+zAj+co3GfYysyduwdaof7AesLnLiSAuAdsEgPMsG5EklaDKYj2fprNXaS+qgtpwgVtQ96hs
 DZhVHiK6J70Nt8Pypn5TEatSiShxs2e/8GTGHPgX0w6oAKx2YdsSty4qsSlH3C6MVpuk+GlH84S
 q5bjJsowz6caq8CjmOXlQgu9vdqwhCSt3Dov2zapETYjQ3Z5Ea4VfHpzEVYxXebjgeS8aoMGz5v
 Q3dAmHJnbBiTd9qiCw3wtYdDswcTxEyfb2iU/9nI2dDnzdXn3Tkv76xkD4RgUZrC9zhUnQ565tn
 0sFaKjN46U2n/lWHhIgF7pFOrYATNMuJ1iLvxQnGFpedOsAgTVF4B3u9QftV/ve0gVcwNGNkIXO
 fhCktGKl3kVtBysUEAw==
X-Authority-Analysis: v=2.4 cv=UbFhjqSN c=1 sm=1 tr=0 ts=69f857e6 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=-DqwulyscF0aooa66S8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=O8hF6Hzn-FEA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605040087
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8A583180003
X-Stat-Signature: gjf3wnoo4j97a3etbhg4y6yfazqijgu6
X-HE-Tag: 1777883123-84138
X-HE-Meta: U2FsdGVkX19x/hSVc5Z5Qa8fBI2RMtl1syu16pESC7BYBzTTvUx8nBegN2/KCeBbpUBVwUjO+GRVJEGk2H9Ic6p5yyGyrI2H0xeVkSWwCn7IqD/TaMlOXLlE0Mh3LIlry7RISHDBLRrm1sJ60ilov4RkMSCCmboTXeSrhCSXLUbe/YRi4ngOT6/uFw9Rei0MQEIBTnjozJ7eJoy34Gp391NZMQb6R25sHJ/bFdHGcRAn/aBYdbk2s9b6P0E786V6qs7XJRIPeKzYBETX3qVHUy/+XTDE3loHc+bS/jrB4d9RPkFYjV80t5nQDdxsA2fxYHGwwj5+jmzl57UmftPQaoBcRebfR5a2WjVMvFoVXH3w7xzOhPLWm5griv/MxOv9g4RPXd1oV4S64rwVRhBSXDbxMxX1pxatuzGc8h0h9WaE8BBD4iA1UFuTYdEymdajPy/t69PUwB0GcswVzOp4Iv31QO9EcN9ZygglZv8Cb50YN7GQlI7FfsuodXzkp6TZe+IN05QqMM8vLTy+M44V6BD5iAt3CMwGq9Xjxo5fqcsqBDUy/z/6NTxG2M9drExDTXPUlcn8aNET4n49gUkV5onASTfE/3kQQpzkNFBJcWs0rfnEMbV92wtj0lduP3MzA4tzK7me8U6V4r1RmBx6cu0AM6F6Sf9ahEqwS33Xtuau3eHVvjEmbCSyv30RWkMGJnzDDZEU3RnPsBEocb9bYtc4tYQXZEvTkpJCFvKOoKNymzIQEHk7SarKx1Qt4fGoVq1z+yutiNvvl5ubUyEQE9F4/qC5R7M1wZ04bJumfEiGbPEiwBtr9sF5EmJmtLuHcu6M5BJuEmNvtirj8DrS5aPfe/BpxZCHbAqH5azEGDMUrLkhyIx+as/aehDzWm7RoASHF0oNxbttjAz1i+MfPHdqYFJaK6yBrodzyTE/vYy9+wHk8vLH0+21WLlmaY/E/w3wCDEPCpAIHs1ubHE
 7vv/auoB
 efo0r9zd3eqt8oMZMeXvHmyj3fZBaMifSKtVNW2wUJPkzJWUcOPK0T9+4JM0Eq5coRHebxYjHgeCQ5aWadOCbrmQAHwImsegv+Wv3kAGRCEwEoR4I/52hzKzOzwOXC22JXMu27V6rFgDcXqeo7DwOor6T/5lCxCnTzssZSEaItuVipKrVJQgDFR6ogOUi3RBsHlJiqqU10ZbJlbBTHtt/VXEK+1yi4YCRDy+kYtZiNdTLGqQpky+5IE5TYKVXG+I1rahRW5Q7OgmcaFEJiFU3aqHNpNh2eAPahy9jEhrp/XMyOtGANtdOQNtbvUJHNqPWaPL60g2F9HWw0FwOBCfNCr/rGzJTYEJL/tKq
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

Sayali Patil (14):
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

 .../selftests/mm/charge_reserved_hugetlb.sh   | 45 +++++++++-----
 tools/testing/selftests/mm/compaction_test.c  |  3 +
 tools/testing/selftests/mm/hugepage-mremap.c  | 42 ++++++-------
 .../selftests/mm/hugetlb_reparenting_test.sh  | 60 ++++++++++---------
 tools/testing/selftests/mm/run_vmtests.sh     | 52 ++++++++++------
 .../selftests/mm/split_huge_page_test.c       | 27 ++++++---
 tools/testing/selftests/mm/uffd-stress.c      |  6 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c   | 13 ++++
 8 files changed, 153 insertions(+), 95 deletions(-)

-- 
2.52.0


