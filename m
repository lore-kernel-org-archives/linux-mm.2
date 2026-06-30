Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76099C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 09:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 494446B00A1; Tue, 30 Jun 2026 05:33:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46BE76B00B8; Tue, 30 Jun 2026 05:33:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 383F26B00BC; Tue, 30 Jun 2026 05:33:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6F16B00A1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:33:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C9C91C5FB3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:33:04 +0000 (UTC)
X-FDA: 84936065088.12.A0E8FB3
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2438012000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:33:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=lfXw4+sK;
	spf=pass (imf29.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782811982;
	b=R1piIHBw47UZ+4OQ7xhQVleqU6ecGuT6xe4MXNRN6cg5RQ934VbZOqNye2IZnOtKwM2Cl9
	R11/Bnk6sOcvFbY4iHUF71JhMzRkrcypn5vWWL1PiW5ofZXqmN1iCkoWIVuAcTeNCs4lHd
	+XqGI1zQHwuwvAB0O3Z6L7REEMy9fvo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782811982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=D8Xum+/XKl8zuM90nMa1ZrI3HjGlq/7zbVgI4GO/dys=;
	b=r9vV6J8ZUqhGLnnY4CYtv7qxlYazy1oyB+Hui+rruInvCYutcWT8EQxDuim8NsnDtoM758
	8GnfQ2+2mKocUuWVKW5ajFI1NHdrMRwCwiwGTejwjbbsY0IbvmdgIXL2OCIpYFuQ0s6n1y
	MiLk3eHTC1xnDPJeJhIDMWxeTNTtD9c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=lfXw4+sK;
	spf=pass (imf29.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65U5mD451137062;
	Tue, 30 Jun 2026 09:32:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=D8Xum+/XKl8zuM90nMa1ZrI3HjGlq/7zbVgI4GO/d
	ys=; b=lfXw4+sKDRkVo+yZf75uJXb6Yx6FSRAoMkVzN+fSqX5sSjqD1dqcYpxzb
	FH82lEG6x3wfot5KAhHvVIlaTTCBFlqk4LuLzG5EjK2kJ7kBBm4MZEawlXYpAcnd
	Lc3lQ86eqfViEDL81KlepwRp5LIN9gUS9xf0i1s80Qtd6Z3kE1fT99QdsxFuifvP
	cqWHq0icMrGIhKn0Z7mgqAE9HmcMxot6zTWQW1vX58OrsZljFG0E5EvZb1FFa0p1
	7DP3/JXy1OB48AIIFSbllHmVikeBvYAi2qNXEZr8Eu3BdQE/QL8UNDPgAyoReYMv
	ySeOw/B9yha9KAQDe738DAnhW5Lng==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4f26n5nxmc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jun 2026 09:32:52 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65U9Jg64008817;
	Tue, 30 Jun 2026 09:32:51 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4f2ruq9nsu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jun 2026 09:32:51 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65U9Wm4E59703592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jun 2026 09:32:48 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 29F5D20043;
	Tue, 30 Jun 2026 09:32:48 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EAE4920040;
	Tue, 30 Jun 2026 09:32:43 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.39.22.200])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 Jun 2026 09:32:43 +0000 (GMT)
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
Subject: [PATCH v2 0/3] selftests/mm: avoid false failures in hugetlb and KSM tests
Date: Tue, 30 Jun 2026 15:02:32 +0530
Message-ID: <cover.1782811071.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjMwMDA4MyBTYWx0ZWRfXy+goAH0TvE1k
 dfbVd+MWgW4+3teakz3eH/cFcTfeDvfr339/fZD0qX4NglDCWZKNFd50QHSkjJPbVA4mKIGKiQh
 SL7hnOnqoc8c16NT1araFZMDufPWiQ09sF+1xmXL8wyqfPaJaN4WU8sneXJJmKi2go4y6CbyUpk
 OAxfDAIocMBzGvNT7LbqXT2w1o4jjoKB+9OQn7kCkiA5EAg6FguedYBjv7upZ78lzVp02AJBQYb
 pa8zZByKgf2R5tc4WcaOnPYrmHTGXgn8AoltbnVPSO4m68uDMy3JnLFBp8CIaAyA2xpanQiSkcd
 B8fkiSshTwwl7k3CKCEN7hGT1cEVyGrotdTrPUVCS+thCWliUpPfgzFpd6VN4G5C37DZjdaiocM
 vZkYaIjpWH31IZ0o1MFauXWc1Cy4JyHfgmqwWl6AeacOVZACAtbwnSEh7dCpMz4SIkkUzX3dwwW
 dhaCYaXTTCzAWRMHMAA==
X-Authority-Analysis: v=2.4 cv=V45NF+ni c=1 sm=1 tr=0 ts=6a438d45 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=_V4-DM0ed6H3iwi1ae8A:9
X-Proofpoint-ORIG-GUID: sWru1B2hQQYViISMjebu6H-eIuuJ2fJd
X-Proofpoint-GUID: ggRZ1wWx35-VpUVVZk4dSDPgik26JuYV
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjMwMDA4MyBTYWx0ZWRfXzVAooNWIk4RR
 15AfbStBvgsQaDxH97Z1TZ0BXl7i4mUJTyzDu5OGb7tXHyHNExLTeIO+17rwTTRu40wTNPsYy6L
 Ewiw+hr6ijfQOYzwGuTI26aXttKkv9w=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-30_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 spamscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501
 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606300083
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2438012000A
X-Rspam-User: 
X-Stat-Signature: ndeszcygd46btf84e173fqdiz45wy8fz
X-HE-Tag: 1782811981-688803
X-HE-Meta: U2FsdGVkX1//nNqroWdPME5hKoZjZN5MGSDdubumsHH72pDe8x3TDRhJG7JxMVs3TBWsxm7vxsfikyxv3R+cIq/rFA+EGG+ZAM9ihA068F1KMnucyYE9d1dVbQCIDWKeNabDjFgG9SJemKPNaXvtHRbrXGM+KHd7ISAG8WIwWFjvgO6S5LJe63NLbDbCyAwQPhOjx5jYG55o1UAhGgcXCkllpXUQWAs0qKZaIn21fR4tEuG0k5cHXOCyng2cB2hJFamRUfqm2GrSAi6AmWTU8aFjTXjSgZ2ZeN0iWWbsSr1cUc5f5Uwp3/6uVHZKFrLj+N/TruL3ee5jMFDoDay3iq4ncZYX3pOcWYB1qG3N/3FUgqOR3JRjwExlNC9K2i3YH+OEDt8Ea692QfeHY9RdzVehc4EdFGv7Q3z5ihv74VuadWastY4znjAEybVzMLHYtHkb1K45SN6+du70JQxPL5crzEKVnaOukccc85kHAc8D8tjerATPsILGDM8Vu4Vl1hMMuA6g9ZPNrvxg7kYipowWM4TY50LEqGhCgLrDeRtO1JUZ1e8ceK156bmrJDgKoPWwMZG5bdJ8EXxvldGelHbtD9Cp6wWgd7xxgCs3fhofCZXN7HJwL8+ixMCYxKqoz67LGXLx3EthJ17+rsBUffDC1ERetx5xvYI+DB/oNtEwd2Wcdk4ToOlwX/5K7gas5mDZ5yVrAc9n7I27Xuj2IU8kxvErZ+nzwDy3LUhXamttRpLCgMwhrQST9nZ0DfGEaC6wWf+Td/UrYu5d1/oVHDK/8oYqFrLa0YsLuy1JhaolPUBcNglSl7y/RJ0FzliyB5kODFqbCdV1s02eDfS32rdBcFJMePpyP6I1O9fwg4uRLEcXS8Z9xs8ys9Qa0NAxaeBssTQTx3QFA9k5BLpZ87LMbgUZRr+2LF/Ysx3GTywpolAsCRjKsI8hTUncJMvNMIon5ZBRCXgbGuLZjTh
 /ylthLTO
 fCoyetcYsvmPLdMusNnAitHImPj12T/xi0Qe/DGxSx0Oy3p0LPEOvpIA0JZXM7RM1bkHlmHDhhVxt+n28mg5EJRynL/UsQ/7D5GLMfxWPr8tkjbZBkVyXYMGvDGats6lT4clelPxdQg79QoQiit785OgSiBkeakFHTYvzpaBw4wgrHk/2T0DJ8agq+3uUYnMuLHJ4nlxwU/7/AJY1uxfteTg0vvAq3CRi07fruVKqT9vxDlySpVq4Syo75jH8PjwSb2yCY9A366DY+weDE+C2aV2H4heoq345hLgQkz3wnK0j9BMsFJ97r4oI3BfgONVo2BLXR1n5n9DRRlRDwRW2hOlJ47GH/EfWHZLxOJT7KjHtrR9k7mrimWD4Hic8OaGwBK8byqpaP1Haq1I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This series fixes issues in the hugetlb and KSM MM selftest categories
that can report failures when the prerequisites for the tests are not
satisfied.

Patch 1 updates the hugetlb selftest helpers to handle -EINVAL when
attempting to configure gigantic HugeTLB pages via nr_hugepages. 
PowerPC hash MMU pSeries systems expose gigantic hugepage sizes 
but do not allow runtime allocation of such pages,
causing the sysfs write to fail. Handle this case gracefully and
continue running the test instead of aborting.

Patch 2 fixes the KSM NUMA merge test on systems with memoryless NUMA
nodes. The test currently relies on the number of configured NUMA nodes
and may attempt allocations on nodes that have no memory, resulting in
spurious failures. Use the existing helpers to identify
NUMA nodes that contain memory and skip the test when fewer than two
such nodes are available.

Patch 3 fixes a pre-existing operator precedence issue in ksm_tests,
where a ternary expression combined with logical OR operators could be
evaluated differently than intended. Added parentheses to ensure the
correct evaluation order.

These changes improve handling of unsupported test configurations and
unmet test prerequisites, avoiding spurious failures.

Thanks,
Sayali
---

V1 -> V2:
- For "selftests/mm: handle EINVAL when configuring gigantic hugepages":
  Added a dedicated hugetlb_write_num() helper to handle the expected EINVAL
  returned by gigantic hugepage configuration, in the 
  hugepage setup code rather than modifying the generic write_file() helper.
- For "selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA nodes":
  Updated implementation as per David's review comment to build upon 
  existing helpers get_next_mem_node().
- Added new patch "selftests/mm: fix ternary operator precedence in ksm_tests"
  to address a pre-existing issue identified during Sahiko's review.

V1: https://lore.kernel.org/all/cover.1782365671.git.sayalip@linux.ibm.com/

---

Sayali Patil (3):
  selftests/mm: handle EINVAL when configuring gigantic hugepages
  selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA
    nodes
  selftests/mm: fix ternary operator precedence in ksm_tests

 .../testing/selftests/mm/hugepage_settings.c  | 32 ++++++++++++++++++-
 .../testing/selftests/mm/hugepage_settings.h  |  1 +
 tools/testing/selftests/mm/ksm_tests.c        | 28 ++++++++--------
 3 files changed, 47 insertions(+), 14 deletions(-)

-- 
2.52.0


