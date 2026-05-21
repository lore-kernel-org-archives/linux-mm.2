Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3A50CD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 06:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F038C6B0088; Thu, 21 May 2026 02:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3EC6B0092; Thu, 21 May 2026 02:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA2A26B0093; Thu, 21 May 2026 02:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C72996B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:39:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6BB50120547
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:39:16 +0000 (UTC)
X-FDA: 84790475112.13.CB6906E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf06.hostedemail.com (Postfix) with ESMTP id 194A6180004
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:39:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gKtXGcef;
	spf=pass (imf06.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779345554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w2yZGEA3lho6ftsaxVq+LrAKP95Gff3FxI3cY3B/TaU=;
	b=r3FjQiZuTVjkKrFR7J7/G4rz7OcK3xE/hvrL6R2a28Ju2cYuj6yDegSNZ5a12ks2gwMks1
	oD2po0F3Uo7UVCew7rlR3U+AVLcuJ7tACU79beAz9mfcS7lA86KamFMiUL4oQIM1qxajxU
	/LEdu7CF691BlIk/k7O8hLmTGKyRyy0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gKtXGcef;
	spf=pass (imf06.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779345554; a=rsa-sha256;
	cv=none;
	b=d9zbAT4+xllT9KMz+xUl4WCel3c8JR9D8ASR53C1SSdxgcNynHP4hg4rDIhy9xR6C4jSZz
	4iqOy8ip+iWFZQdkwlx2TU9eb7hFuc42ph8WOZA4SKDhN1QSu1NQ4ReuQXm5+t0XU0coT3
	Z2FiydMFj2HdnI+cUQ/D2BUsfy9EFJU=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KE1IB83442044;
	Thu, 21 May 2026 06:34:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=w2yZGEA3lho6ftsax
	Vq+LrAKP95Gff3FxI3cY3B/TaU=; b=gKtXGcef/sC4+x8bGU14KBnEmqDoi9P7O
	CsnM9Qkq0D3J27qIswyWNk2wfmNu5qKhB6rBGr6ij84VkBO6i1Hz1r8vgRVKyjl9
	3IFqzzMu0iDedPgv8ut8NhUZj/1VhpE5MzgcmSvf6iuiOjN7nCV6xoHbFxjLF9Gl
	/q2lueaE8XxJo1PSzi9R2A2aQsRMJ4QxTgHFSofDwnejD+IT+r14qIaBQ6ta88ql
	XMa5WqmbMaaaIIRLBYovvmSKDWDIq6kSYtWAdGazLyndlNZ0+mPLGYiq3UChwX5w
	n5OeRO2CcA/GUa6C/9rVhQANziKzELSWhQXcZ4sHMROVsZZQrGFyQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hawcbr3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:33:59 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64L6O8VP020623;
	Thu, 21 May 2026 06:33:58 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e754gjjam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:33:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64L6Xtrq24117612
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 06:33:55 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 16CD02004B;
	Thu, 21 May 2026 06:33:55 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B02A20040;
	Thu, 21 May 2026 06:33:48 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 06:33:48 +0000 (GMT)
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
Subject: [PATCH v7 01/13] selftests/mm: restore default nr_hugepages value via exit trap in charge_reserved_hugetlb.sh
Date: Thu, 21 May 2026 12:03:27 +0530
Message-ID: <5b8fbb29cd6ceffe6752e0af104f60cec072aa10.1779296493.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1779296493.git.sayalip@linux.ibm.com>
References: <cover.1779296493.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA1NyBTYWx0ZWRfX7BiSBC/BH+q3
 WNHXD3L9QBm4oBcc1dXRLOme/yBryy4Phu4Dk2NsjQvBHFPkfv0sNsRKStSd7gmvGGDyKK0fTOk
 JTdM/sSlmPpDGTBCiIT2v/y5D3Hn/0xv/fBFK1ShO669pnME6mCL3u8JKaocq5UQojKUf1CRHJ2
 alyPxsBf5qGcgIJl83tz2UukoonXdqG7WV4KABVtiY3gHvxKOPVmDB9OOnMfl4j9/Vxv4RMaphK
 VjX4/dVwJxWp4L4OoQPgLqaxFdEw6xPrwD1a1d65+Hwqub5ELbafR4ooiUQUf5Dei/ENWN9gTGs
 TudQou9qEBE8iMbhb8BENJUpytRoG/DcTFLJRDg8wwr4aWxmUeb4REALljJ26bKURBUISsNmN32
 8iil/F1vvIU1UJOh28RdZ6q1C2qfd6zUGCeUlh5DGPnXnTlXUfK791pOzxMEtC85aNOmmgNl9Q4
 i19gGqlJta/Mc5zNZrg==
X-Authority-Analysis: v=2.4 cv=Np/htcdJ c=1 sm=1 tr=0 ts=6a0ea758 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=vtM6K80SjIFNW2yxelUA:9
X-Proofpoint-ORIG-GUID: V0oBOkychhHPDJnWgUrLS-jFsIr72PlK
X-Proofpoint-GUID: scVNd80hmPse-gtev7kSfVtikji2rMeK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210057
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 194A6180004
X-Rspam-User: 
X-Stat-Signature: uhfwzjnm3ungzj57o7135qfgf7ozydmp
X-HE-Tag: 1779345553-541140
X-HE-Meta: U2FsdGVkX18S4P8njtx0d901X7XmeZsXmcQttOpAU4YvZEeiOqYiCBdIWIr8NzPdyggpO3OZe+iZHidtRtKegAPwu/Vy4FdZI+dBb3oURPsOSpaha92ohp2x4lcmutcmtRmifjWDAbrI3M9RXeVQ2AjT66/8/bX/qS3rsQ0ByduRIeDDDljcevG3ClQwPpmS4/DyMcWJE2CFocg+JZOFSSJff3h/E/iNPdkuKCR28IS9UzCCHBcouHRfUGIGXnSchUxQX5G0r5hazW+4z2MMVBQvCrJA8VsBT8NKGRixl7I1Mxa5wN0vFqTLiYras4ZGGPGWHrJFIQbyAsAOrzCAGMhLgcOqaPmuyF21B7zsoX4q0T5noFOK7mZ2AqCWDVpGhS2lqthR2FmiY/Ra2CGUDiJha3wtXpbTCZMIi8pPd8qMmlAsI/KkHjifOxhN7tReVBsm4QOJuOSQlsuPREFKNv5H6YGdeXZhxJymCY/nn/CoIRyM286y+MnM2GqCZt5uLqNgvMIvA/oTbJGcw6jnNZQvwZA0YXwsQdBlPVpZ+6NH8Vss+/+tmZdGNMH4a/0rjyP8/D+rehZIHmU7gGF+7aTIIau1dG2/o3qzY+Xmko6WfzYAYmnIKm9wTZAJ/XNhnnaJAjfby+txyYDFE43DCS/0mRd2hj7iekKdQTvGbvcWblaZnZvPZmRMerulqOJnRobu1ehQgDug5IdG8rAuKHaqO7jLR7/3fV9PF01Oxs4adroRO9Ldcip6bfEgpVblu5TlowNBMnhRURik0dj70AQb6yIsmMkM5rkW07kNO/HQ4sgwBQ+DLSwZ8xpzD5KpphigNskkH8GY7WISRNW+MEm9KPSEaTAa4cjG98FrbbMEnjbwiiG5/doCOQY+FX6PizqsXJ3xDDt6lfZ5U+wXmvutjgeF+/hhoqraqVZIB3o22R4CAjkAUIliTErnWtdId95AXyiqw4PATP/BOzG
 iTjm4qfH
 LcVGLVcUzNrOE5tf5knGHPD4bfPVDf+N7yXL9mkPPg/9jNDbJwN4nhUKJ4MWyphx+Cqx4+q91ehM1VqFBVX+rVOEZgx5XtBUTsxnP15o93MreeQpk+h7uafTxnx8NncZAlgPu2P/V3Sn1qUOzFG5gNDfwgltQLlC0Bx9PBxy43ENpNAE/A+jhxk+hSN53c9b31za8FcLSZOyz9wmK8QIcKE+j4NPM++A888mOzDq3oBK6u32ITq7or6Mx5YPePvevKS0cWSfixp/MeZWK7/YDiT53YfBr1ATmUi2lJDB3EXz3Qsb2Fxz1woEWO8jfxSLD/U9i8/BcxnYxWxTFF/tzY3ll+G9Nf0Ao037bmN0UzNEIE61r964rLnjDRGda5IvHRhyQ6EU8cKdt5kfH4mHuzUNf7C//CzRhe6pWHHXtAIR0Pf1NtnC+mjF2Ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cleanup() resets nr_hugepages to 0 on every invocation, while the test
reconfigures it again in the next iteration. This leads to repeated
allocation and freeing of large numbers of hugepages, especially when
the original value is high.

Additionally, with set -e, failures in earlier cleanup steps (e.g.,
rmdir or umount returning EBUSY while background activity is still
ongoing) can cause the script to exit before restoring the original
value, leaving the system in a modified state.

Introduce a trap on EXIT, INT, and TERM to restore the original
nr_hugepages value once at script termination. This avoids
unnecessary allocation churn and ensures the original value
is reliably restored on all exit paths.

Fixes: 7d695b1c3695b ("selftests/mm: save and restore nr_hugepages value")
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/charge_reserved_hugetlb.sh | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index 44f4e703deb9..e1945901fd20 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -17,6 +17,7 @@ if ! command -v killall >/dev/null 2>&1; then
 fi
 
 nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
+trap 'echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages' EXIT INT TERM
 
 fault_limit_file=limit_in_bytes
 reservation_limit_file=rsvd.limit_in_bytes
@@ -70,7 +71,6 @@ function cleanup() {
   if [[ -e $cgroup_path/hugetlb_cgroup_test2 ]]; then
     rmdir $cgroup_path/hugetlb_cgroup_test2
   fi
-  echo 0 >/proc/sys/vm/nr_hugepages
   echo CLEANUP DONE
 }
 
@@ -599,4 +599,3 @@ if [[ $do_umount ]]; then
   rmdir $cgroup_path
 fi
 
-echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
-- 
2.52.0


