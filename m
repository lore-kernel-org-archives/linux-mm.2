Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C478CD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 06:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A57416B009D; Thu, 21 May 2026 02:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2ED66B009E; Thu, 21 May 2026 02:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A8306B009F; Thu, 21 May 2026 02:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7BFCF6B009D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:48:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 411B1120548
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:41 +0000 (UTC)
X-FDA: 84790498842.09.506250B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf25.hostedemail.com (Postfix) with ESMTP id DC5C5A0009
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gBO+Kf5I;
	spf=pass (imf25.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779346119; a=rsa-sha256;
	cv=none;
	b=AlfQ9kdiMh4j/dZT02uhXYjpi25LKftYfblvitkO6pNlb13jtr3CEs6OjC6VKycuG32Th3
	MLqanv9OnCwjbhx1YqDGKMhwPcPM0aH+NbmuXEZcM8ROG0wCvE2W3B2DI2zZ0uizoWdfJt
	FyiR+JHs5m9pFnTVtNLYHiXYhI4hjzg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gBO+Kf5I;
	spf=pass (imf25.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779346119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c75aam0Ymf20+UpHFk7pH2xwhCNVScu6l+3UVxdrvZE=;
	b=afhigrnkPHILWyhQ6EwYHZ8HRccEOgdiLjx5cJOeizj0LHplqgKZgwIBIe56K37Uxw9roq
	VuuHcxpqZie9cdLucI7b3q8NakL+RvOEoJ6jqH24yH2yMX8mCcI+4yL9JBuAlFAZP1/j9U
	5WvVub99DMJSZAR7ROd2VRegTVA0tuo=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L2lBOm069628;
	Thu, 21 May 2026 06:48:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=c75aam0Ymf20+UpHF
	k7pH2xwhCNVScu6l+3UVxdrvZE=; b=gBO+Kf5I274AG57O6OQdAaXfl1n4iN762
	zICNnGqq4pu0bn+cw5BS+iB5PExV1yrY/NkvVHOJRguwuYuauVMY9ZCD87JuVeDU
	BrwPEvI4y5Iqj1jmYLA1g4OHG644sfUBLMbc45KQlHHJ2ji4kl0ApjyDLZ7OjKJK
	8FfmKLb8o2U3U7NmPcN19DYtjCFFCLWVOg/2GUCLSt3h4de0Tlyn6f4oTR7IVZYp
	JUFxW1Lc1fOc5WEx1U1R3fn7j4FsYg4mHr3eNm1gKpfUZ+uIvJv2l+gw9h57cYFL
	FPCDanC5GvwHAbKPCvlAutbz6K7KIju3EzNbmK+14yr70pDdwRmtA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h8mwfwg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:48:29 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64L6d6in003597;
	Thu, 21 May 2026 06:48:28 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e754gjkug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:48:28 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64L6mPxp48824634
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 06:48:25 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 330D320043;
	Thu, 21 May 2026 06:48:25 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 43BBE20040;
	Thu, 21 May 2026 06:48:22 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 06:48:22 +0000 (GMT)
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
Subject: [PATCH v7 10/13] selftests/mm: skip uffd-wp-mremap if UFFD write-protect is unsupported
Date: Thu, 21 May 2026 12:17:50 +0530
Message-ID: <c3c5af76d71d5f4446f773f4de94882efc33ebe4.1779296493.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1779296493.git.sayalip@linux.ibm.com>
References: <cover.1779296493.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: w3CxwwPr800L2Lw7kCvtEmxLurTbiHzo
X-Authority-Analysis: v=2.4 cv=GYMnWwXL c=1 sm=1 tr=0 ts=6a0eaabe cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=njH7lnjfnPuJvX8OOgMA:9
X-Proofpoint-ORIG-GUID: im54uowdCAl_43vhwGui22KJhSluskMK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA2MiBTYWx0ZWRfX3jD4vaifPvzr
 5Mp2iMho1gyyXWLaDQz3bREV2Ilk+rlomm6P3jjo7qVO37XuU15J3OhVsHuqshqDgiKGwhkAcIz
 /aE+n7iP2kGCboZ5umA3w0sXANwezvTxM7cA2IhL75bwQIrrKfi1T6lTjdzTO14FB3fnvgRp64X
 zkiVcIGnqF6F66jLg443RfuXm61C0/BxScyE+H84s6uvYzdT9pLoLjEERqgULOCVesidOj0BVIp
 VXE51Q3ARI1M7FenoMOTHRZJovtCpOf0A84eSQ2pV1NDQChmL12b3nPykdxk+YIk8hJR5h2jCVy
 9/M0nc8neARN834hE60ls9FVYOc74Bk2deDeulgRwpvN1S8a6y86zOKuoz75neW4vKbjXavEF/D
 Ckg2awmcbj14aSlU0ZVkO3cb7lJ6VffClToo+adirO3a6RPSFwLF016s3NUpC/vk6JZH7kiZXug
 1e9vB2vQ78MkRUVR68g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210062
X-Rspam-User: 
X-Rspamd-Queue-Id: DC5C5A0009
X-Rspamd-Server: rspam03
X-Stat-Signature: wfrxhp7oar7i46hr4mrjdkz5jjkqdt6y
X-HE-Tag: 1779346118-53862
X-HE-Meta: U2FsdGVkX18GARQU5dyHToiFJKZLpDokReR/d7YMmEHjDb7GiXqxISQlryeehkoV988d6nA9sihzJRCI0zhLFQPr0DpAuufwWpLGw6lDBNrB1BDWBvZOUYY948140+q7GFQz0mmlyW7HiA55eD7c8S27mypMLutpq3sPGcHQKhUOAt/euwJg7/OZiGMvplK9kC2H5hZzRG/ljQhNK3DLlIL6Jdm9SVPUr3pkeBdoQMto8qO49No6Bc4pafbbiHSfWeTXFWYoplO50Hxq2z+LtJw8g5ocK9n0litVfZy1HUgiC51mn4hwqbc+Zovio6nJGWwovtGoqj/AyRWMbqLZd1Z77zZCQRkdeYKhoMgEFhiM/KheKvU6YyLpK8nGX7lEy50hCxdNnvu4pCNw01zlq+DTILY1mah+5bMWADkT1LibFtCVfYC7itojLXyCZaJOFOrgYzS2TAk+7SyqpkayimgzLzZMRfOR0gnScV7B82EO+xLQWU8STuZ8vd+/ECuHwpERFVmvIipPmbxTrS+VB8i7omOR+mdQP9N3RuxHi//qYOw8lMv7oQNcL3c7NsJQmL1UEdfs3KtqmfajuqJa+JIwEHCe/uu8D6EcIDJHGY5iqVCQMc8lZ9RH8myI+6jLGNkxqj9YG8njD3JJpCBVuBFyn+jtvxYbQx29dzyQHCXFBhvL1UkBg9yoxtOx4oKex20hWbLYAM2IubybcOe1WBCBEuq3/3rZ6aEtXW/rmTqaPblACmveSeVyECtAkpicdLQHQwDYjRCQi/b94SX2k48nUPO/l1X0NQ+Tb2poTE59GuZJDtulsR3rbTbfGDZEqBTffi1jtYnSqZfzUI5yBwMB/NFIlxvIAuVDngrLA1i8fVBV1z4u7nZjGTs1tY7cHVaFbPTNSeSLrNXBJTBe1RzfvZ25ZrEYoJjlYCt2+B1YWBINRg3jd8WbfDToSjTYHUKlrNVTEBYJpEu1LLe
 ogIK6+kw
 8u9Zmu249C73Z0FI6vl5FuuGde5ZWCvsdRIfxGs2bOtxsq2IsILJRCd8k3cR7M+lM8Msv1z7ybqNmB6+KFNOErzVr2WyfQDGQqdXUtQ2NXF6tPRtKGWLT4ERVP+/7JwFgrLkwIkHjOS1Bxe7dJGiiKpc5sokRDp7cze/4V6DWtqImXuIOxzBG80NJTlb7TDXQm3meRNsxNhSSr03viaQtD7TBZ8TfWLkONhGMOsf0n1woXzt/fTcocGuqvP0iAuVuuZ+cEccksqXGCPQXgQGxCijiZC/NBKDRoNG3ASDlZ9d4d5tyRcZX6d8uME9Q0m15BFxodWG+dJ3kYokfdfRolq6K7lizN2MapwO8I7DyOhXEWckLF4yWC6M8RA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The uffd-wp-mremap test requires the UFFD_FEATURE_PAGEFAULT_FLAG_WP
capability. On systems where userfaultfd write-protect is
not supported, uffd_register() fails and the test reports failures.

Check for the required feature at startup and skip the test when the
UFFD_FEATURE_PAGEFAULT_FLAG_WP capability is not present,
preventing false failures on unsupported configurations.

Before patch:
 running ./uffd-wp-mremap
 ------------------------
  [INFO] detected THP size: 256 KiB
  [INFO] detected THP size: 512 KiB
  [INFO] detected THP size: 1024 KiB
  [INFO] detected THP size: 2048 KiB
  [INFO] detected hugetlb page size: 2048 KiB
  [INFO] detected hugetlb page size: 1048576 KiB
 1..24
  [RUN] test_one_folio(size=65536, private=false, swapout=false,
  hugetlb=false)
 not ok 1 uffd_register() failed
  [RUN] test_one_folio(size=65536, private=true, swapout=false,
  hugetlb=false)
 not ok 2 uffd_register() failed
  [RUN] test_one_folio(size=65536, private=false, swapout=true,
  hugetlb=false)
 not ok 3 uffd_register() failed
  [RUN] test_one_folio(size=65536, private=true, swapout=true,
  hugetlb=false)
 not ok 4 uffd_register() failed
  [RUN] test_one_folio(size=262144, private=false, swapout=false,
  hugetlb=false)
 not ok 5 uffd_register() failed
  [RUN] test_one_folio(size=524288, private=false, swapout=false,
  hugetlb=false)
 not ok 6 uffd_register() failed
 .
 .
 .
 Bail out! 24 out of 24 tests failed
  Totals: pass:0 fail:24 xfail:0 xpass:0 skip:0 error:0
 [FAIL]
not ok 1 uffd-wp-mremap # exit=1

After patch:
 running ./uffd-wp-mremap
 ------------------------
 1..0 # SKIP uffd-wp feature not supported
 [SKIP]
ok 1 uffd-wp-mremap # SKIP

Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/uffd-wp-mremap.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index 90ac410c6c6f..c973d6722720 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -19,6 +19,17 @@ static size_t thpsizes[20];
 static int nr_hugetlbsizes;
 static unsigned long hugetlbsizes[10];
 
+static void check_uffd_wp_feature_supported(void)
+{
+	uint64_t features = 0;
+
+	if (uffd_get_features(&features))
+		ksft_exit_skip("failed to get available features (%d)\n", errno);
+
+	if (!(features & UFFD_FEATURE_PAGEFAULT_FLAG_WP))
+		ksft_exit_skip("uffd-wp feature not supported\n");
+}
+
 static int detect_thp_sizes(size_t sizes[], int max)
 {
 	int count = 0;
@@ -338,6 +349,8 @@ int main(int argc, char **argv)
 
 	hugepage_save_settings(true, true);
 
+	check_uffd_wp_feature_supported();
+
 	pagesize = getpagesize();
 	nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
 	nr_hugetlbsizes = hugetlb_setup(1, hugetlbsizes, ARRAY_SIZE(hugetlbsizes));
-- 
2.52.0


