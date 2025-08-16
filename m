Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AE14C87FCF
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 04:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5FBE8E0008; Sat, 16 Aug 2025 00:01:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10D38E0006; Sat, 16 Aug 2025 00:01:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26FC8E0008; Sat, 16 Aug 2025 00:01:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A1D0E8E0006
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:01:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 278CB140367
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:01:44 +0000 (UTC)
X-FDA: 83781271728.15.C7B92C9
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id D69F610000C
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:01:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="UQVUx/s0";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755316902; a=rsa-sha256;
	cv=none;
	b=bSjjTem1cUvhaGhv3FZM91Ctxk/XFdYQ35xtWjuqTyXr86lT6vPNzHtn45FX8/iOtG7pdW
	aru3EClS92pmZ7M7ihTjur/X89YF4eiB9i5kKw7h74rKPqvONoNlTMKl/LFu6NlDiqfSTb
	pNaK9/+1f2Bo1a76+vOfia36Los5yVs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="UQVUx/s0";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755316902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ULVaA8RtCg8Rt4wkESRC4hkPhJHPXvkbBRl57XWyXUE=;
	b=2ANbIzOfNxHU9Spt2pMdxsUeYXFGmp2KUc/Tb15CtUm8RoyriARHY3cChWUxIdX+y0pmCo
	IIhpdeP82h2bgc7HqMIfIaJazUmJe4vG6fRirljmXEq9Le2axxaPlHNnuoiMVBRW663Bsu
	rGddU/JUuTSURCY3Q3KlSEPNJ4Ue4hc=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57G2AAYe029541;
	Sat, 16 Aug 2025 04:01:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=ULVaA8RtCg8Rt4wkESRC4hkPhJHPXvkbBRl57XWyX
	UE=; b=UQVUx/s0XiQArYv2KMH9K9knc1OTAUvR8LUMRMKEPO/VFYps2emw2p7KP
	A84Ulp/8enIDgq7lGxk2PbwTVVhuiSNUt30dmmChsOW4ohVsDTqOcBkV+FQgHy2L
	pc4it5h8hxtk7LJJ0/8S8KdsWktCYLvkNoGi8KcfMJga9kSC/H7KUGzUqS68mDaW
	VHRExzxp0lU6k8wLyTGWGjlKYIklabwjBif1Esw2mEhLn5Quwi8niJBfeo9x0BdE
	Une/VdsQ/NdUjQG66mggZF0tBz+kDJyn63lzBghPxt85WkvPrrUBkyDTvxryfjPZ
	0QSear+zLhIdN8teUN5IvZUOBufFA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jfdrgf6w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:01:33 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57G41WNL030378;
	Sat, 16 Aug 2025 04:01:32 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jfdrgf6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:01:32 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57G0YZFW026377;
	Sat, 16 Aug 2025 04:01:32 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48eh21kxnq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:01:32 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57G41Srn49283338
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 16 Aug 2025 04:01:28 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2AABC2004B;
	Sat, 16 Aug 2025 04:01:28 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E28620043;
	Sat, 16 Aug 2025 04:01:17 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.36.5.210])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 16 Aug 2025 04:01:16 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
        lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, richard.weiyang@gmail.com
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, donettom@linux.ibm.com,
        ritesh.list@gmail.com, aboorvad@linux.ibm.com
Subject: [PATCH v4 0/7] selftests/mm: Fix false positives and skip unsupported tests
Date: Sat, 16 Aug 2025 09:31:06 +0530
Message-ID: <20250816040113.760010-1-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8F7Mu2elyPnZERHNYc6ja-6KH8o6w7mi
X-Proofpoint-GUID: 9CNViZUNZ1h3TVDrxEyzmuhfdYVLujRA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDAwMSBTYWx0ZWRfXyvAhJj9SVkK6
 32AHfiikHsGKlOwl5GOTOwZMMQOTFDEW458aqYUc84U1y0YtAGgk3E4SQZupG0PMNmMCNND8EXt
 IPo0i34sTp5w2kCq++c0Kp0GO9ity9rNh3DHc10OMPPzL+9TSqOQSnGqfUj3ISGQpOGFFa1iSvX
 JrFlXo6bwvAPU5lD6Gu6AEInJmRnvkYnpgM5JgG8NjmDpjSacH8tDZFyo0/8DOUw2he3wjQiXEJ
 +M58UZRBR4VIcX1ZwRZp2MhCXccn5LHpqfMCMxvkwTGntqHx6ZV7i3wF3uDe/aSV/xR3cd2J7B0
 y7+d8tqsJfEuaegLu497MZVXkgLtpQ5O3FbhpB+w1p5GeMPkOtQ5lNsISE8mdMCJgNQzKLeB9QB
 CgPPwxVr
X-Authority-Analysis: v=2.4 cv=GotC+l1C c=1 sm=1 tr=0 ts=68a0029d cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=lqfGnVuM_wKh1zUdGBEA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-16_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 adultscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508160001
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: D69F610000C
X-Stat-Signature: bnepbg7d5esmfgj7owbezghfmra7im35
X-HE-Tag: 1755316901-598225
X-HE-Meta: U2FsdGVkX18BAvlVmuyLPI2DeMhbXXm/3W8Y7+wif46hmJyA0iGPmLD5H8rnehxfzCcsc8wRMuB5hWLoeOGNbaK0EjraJ1xn16VFpnX8A75RFCwZifK8cCcOTbVoS/YrVpFpnkftLEVF+7skxU8SdrZCdFrPRU7mhI0qp6nDjQzIS3zdqtHW5Cwnu4/X+3hrDkhKji0FP9Bcu0hHc4rb/xkyzvSYyVhyJzv2IviOeaXb29OW+fogwBim883ZvNkNmSK+GX88JXjH5a6BO8c4+0f6fsmi37cPp+5XYzmUbYhweGgObxlMJF7UBM/b08NOR7qWtRjcp92EeRXSoNurJFd75nKOPYlhvX/K1yeEkcXCBlTQAI6qmKc8u476ThVqxQyBLj5m3UM3mmTnendXqgfEBgSKn+szspBAsjEh6bQk6TI7cEJhxjSu2Ypypo3Y+p1U7N219bdBaZVuz0UV83e2V18sB63h7G7Zpoj+26GTIFjv8kLfvj23XMeJ13exm1rk4SWX2PTgsvf89X9T8CyhgDClrY317x3eZXNTx71Dq5RYO+2yFZXE9kAn1rImbAz4NOcwZeyhZefYT38HOed8ffFcUw2UjplZLt4Bc01jCVkwH7ubDiy1+Lsa3Cx/BSfzKAmFqgPmu4g+n7W0NCqrWAgSqd0K5FXdjszcOtS04X0NUBWtbrDK/C2TNoN4PH0PNGx9rF+FRXXbiLvS+WawcSvZSZzNwboKUYaZ/j3PGidXLQlYZk1Ry5CLkBsW/lF6qI353TAUsts3dwQg/vCb/izezo/GZ0Zbxfk7/VH3lVKbofykCkgoIRNUSRFJWVKcjmdpXzEa5jNaNmKSh7knkK07v+Qtt9UYTmBxwyClFWOztN2V7ttC7/m81C7DXewhd60dwWq48jehIf9Oc2dhURD6NF6A8+pXkbRuNrI5svG/6D9Z/BTWqnbX3WgJPc1UbXRtn/yGqwtCvIZ
 TFq9bd9/
 JWrB+5K+ypzzvntLWEgt1S9/db1y/fIWESlfTB/lHt8bU2IlCNRAWSVWejnMfrVBGqD4wW3hOohnIt4QLSIR6T2HEJMYYRwWxeAfTn/oxNXBvw2zYwe4HrRysbXEeZLKQIhB8mhYGdiZhKmcSjjLaggz8feqPYUdOLDf4sc5wjydZilT3RRLtfLAc7wzMTgY+Qf3LhVDMWRAQXZOw5XrLX2Lz2tRsWj0PY865bSPCyMFQxmanKxpldhSBoWC0eeDoLS5qwpmipPM/RmCauq6of0WzufVj4bjCPt7oZupr+ONhamo=
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


v3: https://lore.kernel.org/all/20250729053403.1071807-1-aboorvad@linux.ibm.com/

Changes in v4:

  - Rebased onto the latest mm-new branch, top commit of the base is commit 916e1f041670 ("drivers/base: move memory_block_add_nid() into the caller"). Dropped the v3 patches that had already been merged and re-applied them to the mm-new branch.
  - Only Patch 4 is updated to address review comments, all other patches remain unchanged from v3.

--- 

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
  selftests/mm: fix child process exit codes in ksm_functional_tests
  selftests/mm: skip thuge-gen test if system is not setup properly
  selftests/mm: skip hugepage-mremap test if userfaultfd unavailable

Donet Tom (4):
  mm/selftests: Fix incorrect pointer being passed to mark_range()
  selftests/mm: Add support to test 4PB VA on PPC64
  selftest/mm: Fix ksm_funtional_test failures
  mm/selftests: Fix split_huge_page_test failure on systems with 64KB
    page size

 tools/testing/selftests/mm/cow.c              |  5 ----
 tools/testing/selftests/mm/hugepage-mremap.c  | 16 +++++++++--
 .../selftests/mm/ksm_functional_tests.c       | 28 +++++++++++++------
 .../selftests/mm/split_huge_page_test.c       | 22 +++++++++------
 tools/testing/selftests/mm/thuge-gen.c        | 11 +++++---
 tools/testing/selftests/mm/uffd-wp-mremap.c   |  5 ----
 .../selftests/mm/virtual_address_range.c      | 13 ++++++++-
 tools/testing/selftests/mm/vm_util.h          |  5 ++++
 8 files changed, 71 insertions(+), 34 deletions(-)

-- 
2.47.1


