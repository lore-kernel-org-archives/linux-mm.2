Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FD51C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 06:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E59456B0088; Wed,  8 Jul 2026 02:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3476B008A; Wed,  8 Jul 2026 02:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C83826B008C; Wed,  8 Jul 2026 02:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 924496B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:59:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1252A1206E7
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:59:37 +0000 (UTC)
X-FDA: 84964708794.12.3F0CCC3
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id B7F1E1C000D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 06:59:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Sl8pgYrq;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783493974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SsVDbaxlApNyEIKakZ6DuVBmV/2sKJEYi6us2+0Q1qU=;
	b=h58Ig9UIzzduv6Uk8ULQxqL0OkXFzK7eIqobRNrWtI2h0LZqvj9qSHsBCxByChEtMSEmHT
	0BtQSUYp0+qTW9bz5+c2lVQGCVnMIClosxybVt/pvC31jj96kemzTvoZvzyeogqVrLBos8
	HPjO2Qm28kPXWqBkBJ8hvouMu7UAj44=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Sl8pgYrq;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783493974;
	b=OjHEO9VDGOn4PmL1fXFPD23+BGSsNkSpgp3eGiwWC2hNb3cpdCs5kg3To3Wj6pTf9oJVgE
	vTXnBrriALZHv/SlIcTH37EVLS+Oa893pyAd09uX9uXeZzprd3mcsoZ5iPKjvCCXF8J1bJ
	SLaQ0Q0mPupbdwaFhi2AN6hI3On4zdc=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667MmWLp920747;
	Wed, 8 Jul 2026 06:59:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=SsVDbaxlApNyEIKakZ6DuVBmV/2sKJEYi6us2+0Q1
	qU=; b=Sl8pgYrq3ADYRyRG/uHsdHepp/kPvPycL7mPA/XfWTxwWXnR22PFigT2e
	VIR1SvLENVDRf70fA96yUn4yJMBzEmzOsvMTMegpQLPRxE5pDpz2KiiGFnNf6RXU
	bIivEwWcT6/XUT6jWwlvFoHavrtvPzkOeVs+JZIcnlbif8wPoW+1FQ2TApyYv5+G
	LcXyIE8WOFGWiUjO1d8s70qnqV6xA4jiajiSuFyVi4HQD3WG2WhP5SzrhR1043ZP
	bv2q6UJqCULw4gv+1Tha8qxowsOMtuNc9/m5ohV1QXpCFs6969GPq0QFZ4JHhVVB
	SADW2oSoWMh+NqYuPlPIZDtleStPg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4f6sp3u5er-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jul 2026 06:59:19 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6686nZBZ009362;
	Wed, 8 Jul 2026 06:59:18 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4f7f6y63sd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jul 2026 06:59:18 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6686xE3x51380730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jul 2026 06:59:14 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 494222004D;
	Wed,  8 Jul 2026 06:59:14 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 95CA920043;
	Wed,  8 Jul 2026 06:59:10 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jul 2026 06:59:10 +0000 (GMT)
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
Subject: [PATCH v3 0/3] selftests/mm: avoid false failures in hugetlb and KSM tests
Date: Wed,  8 Jul 2026 12:29:04 +0530
Message-ID: <cover.1783446924.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=KsJ9H2WN c=1 sm=1 tr=0 ts=6a4df547 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=dIJUXHJssPmyVruG4BkA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA4MDA2MyBTYWx0ZWRfX0F5MFB5eM4kc
 tMesEeflz+3BAkmpi5TapmtE5v5ZFOBWiA9i2aA6WoBOoC+ElulcGgZ+INfKnjd35aiGySeinhv
 kXqSkJTdmb5c0xpCqFm2Wyn3pz8RcyI=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA4MDA2MyBTYWx0ZWRfX2rY/0FQRL3NV
 mS3kzUg8IGKV9Pj9FStS27+H5/62OUpzN0QrNuAwWh2OdvBjQcnneAPRuAZY6F26PA+aFhv9hWq
 dR3T7NIJB9DQgNKY2ig4WRjx3j1iIY+XJ91bTJ4iY6+RH7he33qlhI/yb/LSKlijO3MaNlTBohj
 UQsqgOM4w6ZYq0O2vOugaGxXdcmHNA4oiVCy/lpi98hkrw13w/lLPE1jLx6nPoCMtw0RuRBGkEE
 Gg9/FvpAWibOijWwDIwPRRHDW1JVtYNaV+nGOPaUJOipB+5B0rPEVYaB9A3SkQipwO5846RGtC9
 sqYHMaWBxXwF5B2mowl6P1T1KqV6ea71M8iSYhpXnOMZgoJx11sHtXY5k1NYjobn52pYQHziv7j
 sRtkf2n37OhwaxboShjFoyGO2kYCFF+7ZNS6SENM1skpBKvx8tOY1MBPjo17dxaqnqAzWa0M9ND
 Z9xOcDhckWgFQGdSWlg==
X-Proofpoint-ORIG-GUID: PSuWbsLmgZVv-t8ijao20URokJlRqGvk
X-Proofpoint-GUID: VW-XIngojpvDJ0MK-njfKsLTYVG7YB7r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_06,2026-07-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 spamscore=0 adultscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607080063
X-Stat-Signature: yan8jxgehw9fs141st18k8kjszobx9tu
X-Rspamd-Queue-Id: B7F1E1C000D
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783493974-431664
X-HE-Meta: U2FsdGVkX19IFd2qXPeTRIx3W/KnMiDOxC2FdecnosyHX6xhwl0FUr+Pn1ztJ/46IOjxNFVZY07h8MGXxc1cks6O9KGVABFvhrofIYdtw0BJ9Ot4cB1do18Yjpxx2UhYPkr78ZI4/Jno3jjNrFfmcAtKX/ZB5ZRG3Y8l/3moWNSCdbEewRl5MH40DiC+jNovVpFVjDHseO4hb8AnolcvW2Vjg9/54715uJmpUrAQL2grB4TzM+qdWcdunqwTopELXKdjgHTo4d7rNWmnsbXgeTbd1gWBeuZ/17Sm3mwEn7O6aFa4nIYfmt1bLMZPd1AbGLEJETWwqN/nQmD3NjktDnm8Qhx/bREWo7l53xE+TCXDiWoczZeoXxCWBU7pU9TCvy3yQ696fQC337D/dkohk/h5CXfB1ulogiFqUrW+UWOt1RLOHi7pof8Mke8AYM0YVsSpLJK2525b+JJV1JsnkC/PSUOKE8J6bKZfuE/aQ8brQ9Kju2RlBmBUS5ysxxZxSWEBiOlNVzkkbBGH9xI7lWwaLxirxNGgar/zjw77LtxBny5XAEiTglT+a0OcvUVuZCbKBbVNc2adjFQSZdVejmG6kCIeTF6V2d5V17xVhL7Pm+xlvv05Z0HOjpQeYLENDd56s9R4N9Q/c5b2+ALIxhNMbM2a0kV/cdmTA/nvdn7UZcz5vPvnYa5erHcTKpN5vk55VQRXeoY07Ow3RrZFPXpMhQo6oUwzL6ILLhs70xhE2OfODb39xdDkEtz1DfW6aeOoIjDNe8BE6yOk6WQPLK+T+Yx0E5gVTEDjW/i558wq6CRRXs0ehUTynIzR6dS8Jbym/+R8oplOLq/3L9sNqRbMlnGxHMHjhJLQ4XReokhSpBNk3qLg/+5YE0+0gEMZAQyTIw26o15zVF16QiTUObXBvJYO2T2vsMmmqtjsg0nOOAgRvYFS/ext8bu0NqBMho8hWGhh92ACKyc+dPr
 zOMtcMxz
 5ovUP9mstrn9ID2tc6J4wTWRKSaoqW3V+0GMGbaP0HcAzcZdoVSf3iExB+EzMNxF4x4BepaMzifFzW5olJNH62YtFbnyCvfcQtlkFarITlOG3K4IE2UWePaNEbSDe5Vh5g4D2Fvjb9SuENnmb/qT49dV5DjbmfRnYVuR5iNZmqdsGt1lwvTt9dcZDCl5bmTGK7CF+OCor9SJpCqQArfGJlbd2r8GaNwNPQfSX6kDwHfbodBezkoyngTBqKFjZLEuLEtCXsaPnlelHgXH2zDyv0sa7tduoIPBVlIE5oyIQ0ZhSdGNB4SRuxiYTKDe/OLNqXNHibQK4QCEFEnCjyslkO3TlYwJO7aHSHORGuVskM9+4s/z8iP/h8Jzi1KIUQJjt4D/6RUCRf6oKDWc=
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

V2 -> V3:
- For "selftests/mm: handle EINVAL when configuring gigantic hugepages":
  Reworked the implementation to use internal helper functions with an 
  ignore_einval flag, as suggested by David Hildenbrand.
  Added __write_file() and __write_num() helpers to optionally ignore
  -EINVAL from sysfs writes.
  Added write_num_ignore_einval() wrapper for callers that need to tolerate
  unsupported hugepage configurations.

V2: https://lore.kernel.org/all/cover.1782811071.git.sayalip@linux.ibm.com/

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

 .../testing/selftests/mm/hugepage_settings.c  |  2 +-
 tools/testing/selftests/mm/ksm_tests.c        | 28 ++++++++++---------
 tools/testing/selftests/mm/vm_util.c          | 26 ++++++++++++++---
 tools/testing/selftests/mm/vm_util.h          |  1 +
 4 files changed, 39 insertions(+), 18 deletions(-)

-- 
2.52.0


