Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F5DFEFCD9F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E1C36B0088; Tue, 10 Mar 2026 05:50:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68FE06B0089; Tue, 10 Mar 2026 05:50:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567966B008A; Tue, 10 Mar 2026 05:50:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 455906B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:50:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D49141B820C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:50:41 +0000 (UTC)
X-FDA: 84529683882.20.BDD6DE9
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9B799180006
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:50:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="pKfXS/l4";
	spf=pass (imf16.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773136239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CpWP3ssTno2Z4GUarF/KfgBuKmxkk/g2ALtQ4Q5/Y5Y=;
	b=qDuNkW+kxQLEz7sfZmMoQpIK3qNWgFdFcPjFE6BL9kJwRdNMaLXtyo/LNse+Y3i3iYuTKr
	qwD/qgoTuWsXdq66eumazDQ16mGVos0prVEz9FPhMRuDhTwVnG8uIVsgqBBirPf9QOWY3O
	sDXXD0yI64MQHBCP4iFj1AkPLuAhyqA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773136239; a=rsa-sha256;
	cv=none;
	b=J1wWlTDVxr18xfjR2uXOH9pkmHeZEu6oYm1agLGfw+vYB2nK3cjI5BcIilec2tZExUak7w
	srbJl8LNM3s8BcesElaHHc63HlrmBKpS8mb3I3KQqC3TOMQblwT47ZxX/32gza/Nl6/MEa
	kFPLd1IP0fyjGudpghcEwOaUpdCHXWo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="pKfXS/l4";
	spf=pass (imf16.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629FwfcR1553765;
	Tue, 10 Mar 2026 09:50:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=CpWP3ssTno2Z4GUarF/KfgBuKmxkk/g2ALtQ4Q5/Y
	5Y=; b=pKfXS/l4hkqMpWlKhvyjNfQYylL9GaFjMJAR8G8ZHfu/tPti932vP51ot
	XKzV0yykWCxd1MpNsXzr1z7lfq3x8R6XP8oOhr3u7rbpId9jvJXRzqkTYBDMY+Wn
	gccXp3G9eI1cXUIbAJKONUem9T33dCCbT5Bs8wPB6qkP2OrEbrrYGQ1z1tgEEDuJ
	+BpezFXqCNjaASRbcG9QczKycDvWiMp/WUZHiomseoHIRGTtew/5Z1xr9m/aE6OI
	doZ8ZVCh4Ujc27Oc0FxChhy1yGkRWk2nk81c1PbGj1wEJXKxmbwHXhWW0l4dCYyV
	YuzWaV1dP51vjwsKzaXwzK/duCbQA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcvra0d1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:50:33 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62A58EST021164;
	Tue, 10 Mar 2026 09:50:32 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4crxbsrpfm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:50:32 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62A9oURC26018160
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 09:50:30 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70E842004E;
	Tue, 10 Mar 2026 09:50:30 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 774772004F;
	Tue, 10 Mar 2026 09:50:27 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Mar 2026 09:50:27 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Liam.Howlett@oracle.com, Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH 00/13] selftests/mm: fix failures and robustness improvements
Date: Tue, 10 Mar 2026 15:19:18 +0530
Message-ID: <cover.1773134177.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA4MSBTYWx0ZWRfX5NegrCCOdEW1
 hvSLo+uWiyGooXu8HrPVrUk762CRKiSCwIrWRfk2lxltPAJ2Ow8AHPb9LVpqIvlCUXPcboAF2tb
 Rm69RI/ChAx3/WWuvvuqTYq4GxwJHpVJmIYQhpspgXKV6k8H7Y9LUxmWzFlTNBs+TdSKFpZEGgw
 qC9j6rOENJJP/7UTya0X5NhLosZeLHJKp6t6yxHa7eHocX6b0dKwO7WW4IdZMRzroGCZbUXKNJV
 x/jZ41g6VuwwCS/frjpKcbbEVNcKPQ/F5OLY93JuZ/vsIeQHDcFK2XbcizKnzv4f3B+WJb6FY7p
 TWLUgnVZpB5QZ8eP3fmSJBAx7jJnVWuMXxKa2JoTY02/cq1y3upVUPd4vN4R9+oXIBztwq//ASI
 Z7JSsVKRNvVdVHQpU8KQVv3ScL0OFBoWKaq4Ow4Q9OzhZEq3FnwQDe1mBHZIGK62Uc1+ErooVfj
 NrDD+uqTIga5+XglvUA==
X-Proofpoint-GUID: qKq1k9BOWPDGfJSSNaNtSslod8i8ZZW8
X-Proofpoint-ORIG-GUID: 5JNoSES92DOI_MLDmnFF1cri-Wq0xJ0A
X-Authority-Analysis: v=2.4 cv=QoFTHFyd c=1 sm=1 tr=0 ts=69afe969 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=Dq3zVHc97-tjocEnGNwA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1011 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603100081
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9B799180006
X-Stat-Signature: 3iqepoa6wdsis4dd15frr44m7nybj8ow
X-Rspam-User: 
X-HE-Tag: 1773136239-476701
X-HE-Meta: U2FsdGVkX1+Wz1UoLF1xp0Uh6u6QxnxuAMzxT34WYDjGtNxCsyFLuBPBYuKEFfQGFUFmRIfb0z4ijXNwb0f8FCn5vBIUrrKh1vvEK5tUBHIGpjGw5vWDrVaXz4x+Q1/+jJhLhvpNY9Ldca6EixyRZtnNe7cPkSM1DiDQHdfMRUu8gFoTV5IC7iZ3QRDnYFoO8wiSF6FH/KKueRcLrRXpgjU99fUHqM1mGUgqSRYUEUDsGR188d7kg+BmyCjz3wkQTf3qJAwJaktO1fm4LoGxzcgPcB2uAZGPx2IQ76h76Lnpv2DneI2UzY3AVgl3pzygGDu4a0x6K6XAIu3rWQyjN55Ub6MvTPjpKs1a+v6LVxFshTsD5RpfiUc/X36uPeAi5Dca4jUspiqB4AhjvcKx0/ccr0ndyexVEWfc9zl9BkFik6ispgdmBAbvMBn1VI4L8VbJN+tMV22BBJSGKdAvazVPFfbUC3QXkQuTAWGAFIuMNm4HlTXXAvj97n8xqiNis4zC03/byGxVpTkHqEv0n79j57vOfVjAkBaBYTBwlsJx8jveVr6QxWt63lOnbjOp8j5CqSQ2P/gmtl+M/95oLT6sibmkJJsVUuXEW6lv8bzlk+MYIYONRK1PIBAtVnpuQf0Uldq1VEqf25FtglazxNFlPgRgnMwwXrJII2Gf+Ajur1U6uCbcYyy8e3xNBi0Y0oIeKxwkjEatDX1WfNHNy8F0BNl1G8SBEibZd8Tactggz2X2Y4qWdQ5D7h3swpBbeQXP4c/TSXtgHHyBB0TC4oo/oJHgc9+MG0fZ1//2s067bnH/MKEVTGzTNKdNeNX1xcm0/DTaIKz/ciGttnvSDXVyMsN4EzSUfRcZaREI05l7wr6pknIwH40+G5IEb2+hgV+QuITEFX4zj2uYoiCOkRB1BjqJa4r/EZNliooSrnZpML9Nobn9bO0Ls9HzJMw8t03VEvvL7ad5usoEoC6
 NBbrw3p/
 feckrYi5dyZ4WHOlnEfr2IrQmc5BY1w2BuCae+o5alu/NJH9kwADdsi9eS2viCCnJJdPsCecuX5oTfrwDOzyIQ5aivoCS5NgVyoEKhgHvShEzhGpbyaIsflQje+NidqS5kz4NDjvB+YvhJiyNK0EYn03HiVbetk11+Mfex8x3wk7DctRVkYT17e4c37t6rdXotXlNLC0CnYOSAyt2DjoDiwqJUdCj9WK0pil5tfmGwn42aIxkn+R1cF7G6DV0qBhV5jgDo7QAy0PUvIR+t3ofN/mUszcxaF+ozkzAw/qQdRlMwZFrl8O/GbaWAXvVQsxPYJbShPZNi1QdruGt4jmnrB8XuQ==
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

Sayali Patil (13):
  selftests/mm: restore default nr_hugepages value during cleanup in
    charge_reserved_hugetlb.sh
  selftests/mm: fix hugetlb pathname construction in
    charge_reserved_hugetlb.sh
  selftests/mm: fix hugetlb pathname construction in
    hugetlb_reparenting_test.sh
  selftest/mm: fix cgroup task placement and tolerance in
    hugetlb_reparenting_test.sh
  selftests/mm: size tmpfs according to PMD page size in
    split_huge_page_test
  selftest/mm: adjust hugepage-mremap test size for large huge pages
  selftest/mm: register existing mapping with userfaultfd in
    hugepage-mremap
  selftests/mm: ensure destination is hugetlb-backed in hugepage-mremap
  selftests/mm: skip uffd-wp-mremap if UFFD write-protect is unsupported
  selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
  selftests/mm: fix double increment in linked list cleanup in
    compaction_test
  selftests/mm: move hwpoison setup into run_test() and silence modprobe
    output for memory-failure category
  selftests/cgroup: extend test_hugetlb_memcg.c to support all huge page
    sizes

 .../selftests/cgroup/test_hugetlb_memcg.c     | 66 ++++++++++++++-----
 .../selftests/mm/charge_reserved_hugetlb.sh   | 44 +++++++++----
 tools/testing/selftests/mm/compaction_test.c  |  3 -
 tools/testing/selftests/mm/hugepage-mremap.c  | 25 ++-----
 .../selftests/mm/hugetlb_reparenting_test.sh  | 31 +++++----
 tools/testing/selftests/mm/run_vmtests.sh     | 59 +++++++++++------
 .../selftests/mm/split_huge_page_test.c       |  5 +-
 tools/testing/selftests/mm/uffd-stress.c      |  6 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c   | 13 ++++
 .../testing/selftests/mm/write_to_hugetlbfs.c |  5 +-
 10 files changed, 169 insertions(+), 88 deletions(-)

-- 
2.52.0


