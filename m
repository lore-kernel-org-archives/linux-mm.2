Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DB16105A594
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 942BF6B008C; Thu, 12 Mar 2026 08:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F0376B0092; Thu, 12 Mar 2026 08:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F22A6B0095; Thu, 12 Mar 2026 08:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D6436B008C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:26:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10B581399CC
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:13 +0000 (UTC)
X-FDA: 84537333426.16.29037C3
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id B6E0840003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=TwBrSu6Q;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf27.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773318370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IaLbxO8utFixXJID+in4wpuw7n/xPqaFliR9xg+Vo/Q=;
	b=58q0WsqCalNH3im0UYyuJpYgRpYJ058QiJHcDG4F2TxHmRyXdZvwYhbWj4xOQbWvpS3F3Q
	0Cchd3eM5cTFf5LXGmXssh0TwPkPVxL269Uz8n1r1nzBPPBoy+Zg4CRnpnW+1LM/mn/tHg
	WKQIbVAYqbNOpSKURxLpBbbq7bjqXBo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773318370; a=rsa-sha256;
	cv=none;
	b=HxnZSjj8DxxUIDz1299x6aSxqBrE50RndVOqzDZlUqyB852D0TPDd1jBZ/qwm8M3FPS8LK
	/a95ckmD96IDeW/7XGB8Gc10MEt95nR5QKdhkaAOPEFjIq265x1SxCRQ4s7J1w1sS77GIy
	Ok3hiFSnBB9Z5tcR4x/TlwsbutbFJpE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=TwBrSu6Q;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf27.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BMWIEb2581500;
	Thu, 12 Mar 2026 12:26:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=IaLbxO8utFixXJID+in4wpuw7n/xPqaFliR9xg+Vo
	/Q=; b=TwBrSu6QMf2LO9tJ+5qqw5YF90QbKuaJQMRTe+9KBJYWOruUhq7kGyWAl
	FX9g3Mtnx8Ctki8AqWmdAZqarmB7K7yfVoRMw9n+h/apvK78ulIz4G32BdqR+dU3
	l5ybZlbHiSRsWyTkToLXd5yUtBTGM94UuEym+YbQcqV05opzHaYel8xWIT6WgSOA
	F+GT/poM0yQWI89/7qktD5w/mNNTNQxqRAxwgsdedOJBpFvMtFq2JRV/dz8qRd+p
	B/vis1g8d+cZrHg0anSFjolyMnbjRmYn68U70yAjRaJ/8i472Ya0qHNNktbVhsSB
	qfHzv/YZEqw2zVSesy59Tj2RJagJA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh94tmqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:04 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62C9dkw1008838;
	Thu, 12 Mar 2026 12:26:03 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cuha7296q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:03 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CCQ08T49611250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 12:26:01 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D53112004E;
	Thu, 12 Mar 2026 12:26:00 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D5FD02004D;
	Thu, 12 Mar 2026 12:25:54 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Mar 2026 12:25:54 +0000 (GMT)
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
Subject: [PATCH v2 00/13] selftests/mm: fix failures and robustness improvements
Date: Thu, 12 Mar 2026 17:55:27 +0530
Message-ID: <cover.1773305677.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=QKtlhwLL c=1 sm=1 tr=0 ts=69b2b0dc cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=4qS8iJCPjNy_d4tN1AgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDA5NSBTYWx0ZWRfX/NZHFqG8TEXT
 UQU1BfuJk55ozXWIhDLV3GzlZ+BfqItW0P9S0AXPm0lcT3Sbx2Wcq84HbZEE574MHbrIj33akVP
 o2LkZ7Sp00H0CzU3F02iMQOuWn9FtN/yl05q2nUaWbFRDYTykURlv59qQeV5n9IC3TqnZYzTeyG
 9r0CTLLNDugGPxnyr0dsrViciUL41vw/h1lF65Kinnq+jHc7xOAUeFQj4ptPc7jv0XqG+vqM3+p
 NMz4ggV9aw/OC5B8HnIUx6qfl/mGD6Df3IP9j6ulJGPXXtGy0YQVRLx450SpFDFTQDQMH+ZRcNL
 +FdVavhWK0fDzoNhUcq2I4FIE6ebZvbxMZ7n2SdUKvqFQf2MS0ji7IRZoaI868MzN2mlrNmGpBh
 UoQlPbJ/FimdreDTT2lXp1PTZsF7P7Ht3YwenrMvy8zWW969VOjTv554xGahuhly90hGVIKU+CC
 R33xrQ2WzJqW6BbBYcA==
X-Proofpoint-ORIG-GUID: ICKPdNTKlEdscOpeOVNgxjJbHMgrb33i
X-Proofpoint-GUID: Si-Z5Z9mkqEgNksK3q47qN2wjUZehhGu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603120095
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B6E0840003
X-Stat-Signature: koukuxfja5qerjriezahqkbbqje5h4ef
X-Rspam-User: 
X-HE-Tag: 1773318370-883221
X-HE-Meta: U2FsdGVkX1/hcxp5Qhuyc/QR71O1f+pg4KX3CJizF6OSjihUItUNgupPz1lPke8K9FuBZ88M+1/FKZgbgbWpQM3jgFpTtkgq/VGFaipih2Bn+1vR4slHjXl+fQ+pfG0r4F7PtN9pxrq3JCLyZAMp/67zOj8iq/J3758BMqppVFufzSRCJmmzyxWcd+HgGOk0yTet8j+koM+R9ZaKy6eAuxmmuIr5XtS6vngShJXVhfUpp9Zx3fuwY0/LAS1dmkR2T/YhmtqFaMHIXUHcKPzk7YJa/Ulijm7UCJUt5BYAYGTMjge88DsRxD/h8ud742ynaKVExsmsAPRBdacmRluztKOHCjgsnfcfKR9CkMDf1tZvEqDk1wK+Z2u/CfMbkgnqni4HFWu8CR5JxvGgBpksNU9B7J2gP4BKEwQLiFOcynL3woFXsU1Xswfd/B3E1OMPfHZGUbI7MM7OLPZ3LnfmUCCCGb1fYyoBSyeTI1otzw8cxEs84T76H2bqOCL3uZ811pkxNwjyuEDlVmDqj/LjmXTtFxxnhPc2rTRcqPCCHJ2DPxY9bNWk541sIOtBAH2NJ+XeWvNaed2VBiaE7GSHjSGTZZdjlA1WGI7OJV3jz4YW31bRKCn/9SSaU4wEOEKm9ai4CeO28cNpVum/Q1YUQcUBotNl3kvOb+I1ipG8KVrM3tfqO0vQKhIZmZYNFnz08Zs7YJDL//NGrSNoNvLN615egqLPp+ax5l5BMhLMSLJ9rkU+NdKrB69SaofqJppr7qQIvhN77PT79/vshIf6E8Cr5Kq1Otro/4B/LqDLyOVtCFpzu4NlqKQzeVPyrfvWpx586a/PQrQvsaHTQiUSCXD+h3IxniM4zn5rhAMsOnL3YgnJw6pQ4afJ1GaFl9W+CnXPAmlQjtpsWc9iQM9iB4SNZZXKX42tAIR2C0chBG3adRmMaw3pFlTR5zosG+Hc3484IAI2L45q8nwsfUs
 8Ie1KESf
 RuHK3q3+r28uBsj/DnLxzeiT7IQ2A0OnNTwZbxaJQPENkKP8oqTC6d+c076QG9Z2p59jvw57CZYu76hrlGOLTsUjSo+Nh4YyRcsBMbkIDj4S+aoGaVr5QgSQOP0ZmYEnote8z1BwCEFsvyT5w21gsMTkbVO/PvH/jOBO2uTDNyZ4YR8PTIFbhwveg0ZycdFsNFLGVWPPkniz6YHVcoaBajoCGnK5xRQFBtI6YdPBXRikEsSEM5KCx8I0F+juks9aMKnZSK5hk/CAJ4n9g8eDoGKA/emFl16hxypFzcDYzr9Sl8BY=
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
 tools/testing/selftests/mm/hugepage-mremap.c  | 32 +++------
 .../selftests/mm/hugetlb_reparenting_test.sh  | 31 +++++----
 tools/testing/selftests/mm/run_vmtests.sh     | 59 +++++++++++------
 .../selftests/mm/split_huge_page_test.c       |  5 +-
 tools/testing/selftests/mm/uffd-stress.c      |  6 +-
 tools/testing/selftests/mm/uffd-wp-mremap.c   | 13 ++++
 .../testing/selftests/mm/write_to_hugetlbfs.c |  5 +-
 10 files changed, 171 insertions(+), 93 deletions(-)

-- 
2.52.0


