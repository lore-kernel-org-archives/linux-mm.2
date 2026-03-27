Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8D9110BA432
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:17:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216CA6B00CB; Fri, 27 Mar 2026 03:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EE9F6B00CD; Fri, 27 Mar 2026 03:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104B76B00CE; Fri, 27 Mar 2026 03:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0305C6B00CB
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:17:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9BB26140F34
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:17:26 +0000 (UTC)
X-FDA: 84590987292.20.FC5A2B0
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5C2371C000F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:17:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HO3jS68e;
	spf=pass (imf18.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774595844; a=rsa-sha256;
	cv=none;
	b=gQhudE3WDXb02Bnp+rtPkxvlaSr0+mkvqqirKgwCogR9OFvDzVz419iSiINCk33MnyMz23
	60EWKbM2Mz3/2BeOlGpkisyt2Ufb6+wPPkhxH0k8n8PrNkBmnFY0gQPLJM4t8GClCxB5oF
	vuQqQ2XBKpzh/ckx6TpN4PC5MjvhH5w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774595844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qX2aWPBs2Uk6pGE5wyoOhNupuU+Rbe2RXQHAKSeaRCY=;
	b=pURHueN30Y5WjEAOLSAx252guXPaTtlNXF5mBhVJRZ9Ymv8N4+r8sq4FtNM0ph/EXAeXWj
	OoAMi/CP/rTQC9QsvR6wwVfB//kgw4XWEOTpHbpDYvLJwnOEN7phkI3Cav4WAaZt0m9R74
	+fc2IEocYHmXlAST/TURh9ytCFpJkdA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HO3jS68e;
	spf=pass (imf18.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62R3mNcS768705;
	Fri, 27 Mar 2026 07:17:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=qX2aWPBs2Uk6pGE5wyoOhNupuU+Rbe2RXQHAKSeaR
	CY=; b=HO3jS68eIUOzX2ESFw4MoKnKhee6iOLtsuixoYu7JrgsOeWb4Ur7gL6F+
	VANEWJ02BF/9P6Z2g10HQyrpf2+E4ddU3QAEs7HBAxotoCV1TOuqfQoQoCJvJ9ta
	y3NNJMzxJ1GdLSaybKBm2+yuzBGUiC29vL70UfDNeMurA2YS/utesENdruTF2HKP
	H2lJIzjEE2jWlImZtFgbXYbOwB9GtVE4vBCyyETvHo3iC6nvGM8S3RHzdeH4y0MF
	SLL2zC4cQCqhQmO5tADHydKH9BuC/1hU/pQ9CzfnrgNmiaKd+RRD7ZjOG3ma8eqS
	vmTR9A8cT27TWu+wtwHQVp/u3ZSUQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1kxqs17h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:17 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62R6NHBG008732;
	Fri, 27 Mar 2026 07:17:16 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4d26nnxgnt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:16 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62R7HEhe46137610
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 07:17:14 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B7112004E;
	Fri, 27 Mar 2026 07:17:14 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 04A5620043;
	Fri, 27 Mar 2026 07:17:11 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.124.208.5])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Mar 2026 07:17:10 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH v3 00/13] selftests/mm: fix failures and robustness improvements
Date: Fri, 27 Mar 2026 12:45:54 +0530
Message-ID: <cover.1774591179.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: bTG2_VkCQGmT433W2bPMIOzx_4gkdGVL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDA0OSBTYWx0ZWRfX22Wd5wAjRkfh
 52EBF1DLYZnsXdmn4tKgwNY57eHTiah8Fukg1+amifZJsMDAEU1zwsINmynIrJvVOKJAOqPhkqW
 qHrZRIQ3n9k4Xrhrnt3hfAKYJhddJ/5lR5ORfnXzzoCmhWQQv4pJ0eq1BbtO7XMEQB0aGKRUiJr
 pS3ik2mK3rUsRV6hGO4BIC+q5IQjA7LKGsh8oaHh1nCnfSqQ6gOLKED82fPDsq9BVUuABlqYgTD
 0S+awKBZmjcnuejWCAI1rLYVpMTXIpJogYvwkAEvjYp93NgqpjBTlydyBJXn4tknUa8sla0l7EI
 yd0ZqLxSB3tYKzRDwi1YQM//LGkR6YcDle0k0w1silMtdbM/626cgIp295+MlntKF8uQ0Fe4Nyd
 XeKNbMHB6yH5sinyHd+fRB79jvQni6Ni84d2JquFMXoS0Nl8ZHHei0gbXDFCTu4cX0hlD2gbxHn
 ikiYQHdv4sGSwitDpsg==
X-Authority-Analysis: v=2.4 cv=bLEb4f+Z c=1 sm=1 tr=0 ts=69c62efe cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=ibztMZabhZb7YLjfUOMA:9
X-Proofpoint-GUID: AhEwzDl57hOrQJRz74vzJkQQkwuK9cJn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_04,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 phishscore=0 impostorscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603270049
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5C2371C000F
X-Stat-Signature: jyynpoa39k3icxmyeporb5m9hroysgam
X-HE-Tag: 1774595844-177501
X-HE-Meta: U2FsdGVkX1/J2ovbDxEUPAEZhKJCDcH4ieqUqBviukhjaFmgHNeSZkRL1XZcksmYjxMUfNyyDN62FarOpD1+8flMh/IuN9imfTVotkyMquErvojxW6QnrTnBzokaqeBOH1bN0vWpwDLkfQJszu+9fYo0H/kBf+/JJ2bWyoJrxEsAQTHq32Fho3yxnse5UIJRkHDuTr0sLi4fPmfFczY0XHhH9pgcc/6JuQLeYSarCQ74hpX7HnB9GhWgW4i3GHY59qAO9eSET9RXG69J7aYXQGc6tHGsBlfVr1KgDqdGqy6AiN7swelOUCR/KQB7UD3deeuI6mcyqdA9L5zYpSfe2flKWuYaCoCBqpjkvEP0iIBQQfs8AfyE6zOVT/L5huPG+yJuXlT5b82M+oNpFWxSe+00xL9aZNthp7EGyuYpQNmzmKKBXDm8ifV+PBUrTRYj71VTBgJxhvOLjrWYxaNY5h40NQxJFs5njfKOjpDQiQHq0axunNWtBJ5sRFJhYr3/RWjt7x/GulxBu9aBZ6u4SEXySiK6NGYQyVQST4wfu6ZsDTQvKJJ8De2Vyc1WSsdwsUCzaN3F0dGzgALe7rZC3dAzCfWkptduvon9DGDET590qYs+gceJc/CXfVU03haskRAmKArv1RiwKmVqqQJcFVrjr72dYN3pPHAd/fPcZFeggp9rpOR+x3Xp2kmJNnk5yaU6Neno0Xn38RNHugs7fF59rekEIZhZ+/5a+jBeYIqpjp88TJ3gxUMCsIeq6mwk4W1n6NOQghcUmagZuSswM/tFU4Fkww7XNg/GvYB7/DEurOaXgZLaGtznGc/vuRILErkSmMQLtizQWQUx0TkRBIvd/YmAt3l6xlHrKyP7jzh9ZiU+jfhyEbLRRUQVLGMXUiaeDx3X0VVvGFmbljTyn10UYiU/PTNP+xOVIfO4LVjmvMeBmlaP0omi6mLPYDz1ogw9iho4o0Hd+kW1/ph
 3vbb+FL4
 xg+eR/15MQ61/+sdR5jpPbnVoRWzAloT4sREZWgVIarXMSiZVeRVpLteD4bAcjDeLUiQNEAeEG/9RYlKKRFm9u7tqmTMTNEfXwnmQqMt+sz5X4KGcpR9c+JUk4NUhw00JNZYKl5VolKMQbb5zjrtkQTbe5hUhbQLweKU0j8h40tYU9YRjhh5AqIHKrMkXIwH/2vjM8h93txrYcZwjAPTYtqLVHis+al4bq1aJ4mGrLD7hviIIHR5f+daTus0+rZTmDK6juZKvRopLrBYmLKTYPZh7ZYhzYpXJOCROWPY17iiZFsw=
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
v2->v3
  - selftests/mm: skip uffd-wp-mremap if UFFD write-protect is unsupported:
    Rename function to check_uffd_wp_feature_supported() as suggested
    in review.
  - selftest/mm: fix cgroup task placement and drop memory.current checks
    in hugetlb_reparenting_test.sh:
    Drop memory.current validation from the hugetlb reparenting test.
    Keep tolerance at 7MB (reverting earlier increase to 8MB in v1).

v2: https://lore.kernel.org/all/cover.1773305677.git.sayalip@linux.ibm.com/

---
v1->v2
  - For "selftests/mm: ensure destination is hugetlb-backed in hugepage-mremap":
    update FLAGS definition to MAP_HUGETLB | MAP_SHARED | MAP_POPULATE and
    used it for mmap() calls as suggested during review.

v1: https://lore.kernel.org/all/cover.1773134177.git.sayalip@linux.ibm.com/
---

Sayali Patil (13):
  selftests/mm: restore default nr_hugepages value during cleanup in
    charge_reserved_hugetlb.sh
  selftests/mm: fix hugetlb pathname construction in
    charge_reserved_hugetlb.sh
  selftests/mm: fix hugetlb pathname construction in
    hugetlb_reparenting_test.sh
  selftest/mm: fix cgroup task placement and drop memory.current checks
    in hugetlb_reparenting_test.sh
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
 tools/testing/selftests/mm/hugepage-mremap.c  | 32 +++------
 .../selftests/mm/hugetlb_reparenting_test.sh  | 56 ++++++++--------
 tools/testing/selftests/mm/run_vmtests.sh     | 59 +++++++++++------
 .../selftests/mm/split_huge_page_test.c       |  5 +-
 tools/testing/selftests/mm/uffd-stress.c      |  6 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c   | 13 ++++
 .../testing/selftests/mm/write_to_hugetlbfs.c |  5 +-
 10 files changed, 181 insertions(+), 108 deletions(-)

-- 
2.52.0


