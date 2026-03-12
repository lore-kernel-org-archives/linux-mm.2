Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0541E105A591
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:26:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 636686B00AB; Thu, 12 Mar 2026 08:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FDFB6B00AD; Thu, 12 Mar 2026 08:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 517446B00AE; Thu, 12 Mar 2026 08:26:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3FFF46B00AB
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:26:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C37F91401D5
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:43 +0000 (UTC)
X-FDA: 84537334686.30.33B0383
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf10.hostedemail.com (Postfix) with ESMTP id 45773C000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="i55fAb/9";
	spf=pass (imf10.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773318401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4KLo7Cu1tBPEIe4Wi8q28A9cCAdIIYLBWP0GVwzLjQ=;
	b=cNFnJ7UHcpeasvtkVMe6UySQ2VC1qLWaBSblZTIdzTMPfQwnahj32nkD7PAeR4tRrOFrV4
	AMZixAbsHrMg3G+mPdCZlPrpPMOMnkef9A/NRuvHq/KByptrfeQ++m/CmHjSW90jTxCIrY
	bAGeeEmCKyDBFsQfHrcxPdMFeQNQDjQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773318401; a=rsa-sha256;
	cv=none;
	b=xNQKlvU8GYGNtI7bgzrrzEVRqlb5BhtfujPZK1DqueRqTdRClsJyzvI2MQzUr0o9RTEr6M
	8/SuWKqlTk9gWpgyD4fVQt0TeEg+vVXLDzJTIbZ3Z4j9dS6T3C8ETgE//EsKiSYTdGsyNP
	stQ7hEfr83OcvtgSiYPi+ziKXUhN8qE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="i55fAb/9";
	spf=pass (imf10.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62C1T8XY2923674;
	Thu, 12 Mar 2026 12:26:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=l4KLo7Cu1tBPEIe4W
	i8q28A9cCAdIIYLBWP0GVwzLjQ=; b=i55fAb/9pu1muQfvU66CXti4BaHPJN3Qn
	TSjW4XDD4OoWj+rHNhapXqM4WX7UtkYkCT7WZSqxbmYE4+VnOqxEeKQRJXANQXPe
	ruRWB0N5kMnnGp1Pb/cHLzQHNSSPARfaHERc1doZYnwq0L3fZJskIb0OXwF7Q+xv
	SdjTNB3k4GhpC4n552zyYhwSdYPuQNTbnEYYvZRjJRE5cXVFs78xM1cj22fjNDcZ
	PQAgwIDnNGMbKm9BtkkE+bfjrxIVl5DxQRKsfnZArMDZEPvpxXYH8jYFQnXWDsAm
	4grDoldSMC5mj9W6JgBLMzDj9UacPiw9QyMis4tjC59oRhdFGy78w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh94tms7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:35 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62C9ZAmM014631;
	Thu, 12 Mar 2026 12:26:34 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cuha8a8t5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:33 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CCQWVm50266592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 12:26:32 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E22932005A;
	Thu, 12 Mar 2026 12:26:31 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 025AE20043;
	Thu, 12 Mar 2026 12:26:29 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Mar 2026 12:26:28 +0000 (GMT)
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
Subject: [PATCH v2 09/13] selftests/mm: skip uffd-wp-mremap if UFFD write-protect is unsupported
Date: Thu, 12 Mar 2026 17:55:36 +0530
Message-ID: <ed23ff57a80881c9d087d22709862af40addf49b.1773305678.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773305677.git.sayalip@linux.ibm.com>
References: <cover.1773305677.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=QKtlhwLL c=1 sm=1 tr=0 ts=69b2b0fb cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=S6b9uB01mPhIUM3ue0cA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDA5NSBTYWx0ZWRfX19zbQokCgEFR
 RKW9LPXmZaRml/MLaIQT7nqxB301SfQAZZM744QotxcfDMo58locbrBG2s/ulY5o8i7iLvKaQ3K
 t3XjFXTK1WJrapbN5dNedZTEqw1WiO/qgXSXFnNZr6zZvFcbeLGB4Rgvdp5AaEfb4upwfHLWI58
 lt6KmVvylv2sK+O8jQ4S9+t4QhI9v7LaY04i6rGLLU4y1I8DTGLjV2WatqlaDXeGu8WbecQQbiV
 Koii51rSVA7CcK9sYorD+aPFfI6NLYeacz5ac4GLVgrbRjB8yaQKW0kLbrUwaq8UfmzTYPhCJo3
 DIhS19FzKcvDSdHQgdkjsiuVtvQwXtwUGDILZWNh2GyhJo4bRTUNmNLK6YFJs7w1y/o8IoN4ksv
 4O9rOghR5rn/iWC6QcsOqhbtzjps9dpL8DhnlW6d7R3/w1GhrqveZ8BZ5RIAprPKGKEvJoPp5e8
 5HHcW+YM7O70AgZSf2g==
X-Proofpoint-ORIG-GUID: XFP0rrqUgwdyVFmlypteqc28GqnPY5Ct
X-Proofpoint-GUID: phzoDGqvYzVKFEMdmskEQ_xwXsMQw1zA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 bulkscore=0 adultscore=0 phishscore=0 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2603120095
X-Rspam-User: 
X-Stat-Signature: 7cwf9i57xd3ntcctyk9qimib8difg7kf
X-Rspamd-Queue-Id: 45773C000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1773318401-456650
X-HE-Meta: U2FsdGVkX18bOsQR0KNIM0yhpP90StmeEihwhDHPW5KSuACgioYHKFFXE7SVLs6+2Xo6alEk9SmuyJ/6AzgpEWizegiiZ3x5CSd8d5nRPG4+Uug4gEPmOmh3c/XX58tGmeCOHzFnkAhYnHDrHqwhK3iJdX/NZJx58Q/B93PHPeUDmJY0/cDwFARdFDH5X3u0PyEG5Qg32yrbI4etAhf9/ZptRaJ2JqN36O47mxoaBbfHu8Yd8SGsKvRgSmCZA3ZCyEpyKd3MuTo/x5aEX1NgcvZn6Ad2Iwr3TOnu9IPPy8ITIFW2toYRJIoO2e0t8g08sM1NfMn9ge/ZlgkD07634gU1hfkbOMwmvhSIs4aZ0tK3LxO5wZehPqlbHEjBgHmAGohCyuJR2e1HKRpuHEVAoODSXRw9G7KPKhaSVintIDBLEPq7XcbIdbcnG1OftyJHnBN4Yy9uB1s0OStkNXFBwcZaPTOsh0khGZaTGtb2nTmWX8W4p/K6FY1NCuvXJyWLFdhdEmlm3wMK3CzqszPhVMn1NGRP1SmyMVy4lUMB5v1ttTdYMh9k/vuVXDh9HfkP5Xyue0WiIAVhUO/id3odkIV/1zOmOJDzVjA3v8XmSvxXjqm04ted4+C83NmOAVdBuS5nIOdIT/198tTTq6URZ2opjaUvy6b8dGWm4xVpZ95E3nIipSAFshfVSR+YMh1WQJJq6H8FZ+pr8MGzeZxEh4dAJUAIbKP873OTEwdYCd2E56xZO5VAJwG8BgZ9OuQJ1MyylAVlGR8EZDWvHUBYsBDGTjX5FUcLTeTGO1DUHmSpLAywv8ebRW3ytuXNsxRKkx7UVnSaNJ/kZ9J8NYqWzZF+bc5Po9W5mbHYotGgE+APNd2FEVw+mqpjwD9yyMx6+fuA5Hrt0jIhY38HMZ75G74yPW7iUPdzf6wDkxo89q8f+Q2oTZ4suC9L7ifOs159/uHUknY7C6coLJ/wuSq
 dGWrd5cd
 p13drvWMZVtTKtDQt/Mu5eQKk3joXA37LHgpdLiNBgr1D4wAA/gnXEPHFmaVWgkOPYcfkQmZyeyOdYwqzU+B6Bxlch2sIhYMHUh81AM5PDsF3L+rzcSDa/NySPvC5KkFxWdyx5x5HOZIvtNeHofDc7xK66X3+pJinmVZaC+AWpklbqBWzS9MVeiRkSJaNErUJEQB9wol4t0xLvDZ82q3DYFiEA8a3jQNk+EWNnTUjBMBymktonJaww7HDWGqyGogAhHiP5Cesq+zgWxA6wIP1LJTklh1NFjxzJYgS4hrOylcsfbE=
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

Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/uffd-wp-mremap.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index 17186d4a4147..73d53a4da389 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -19,6 +19,17 @@ static size_t thpsizes[20];
 static int nr_hugetlbsizes;
 static size_t hugetlbsizes[10];
 
+static void uffd_wp_feature_supported(void)
+{
+	uint64_t features;
+
+	if (uffd_get_features(&features) && errno == ENOENT)
+		ksft_exit_skip("failed to get available features (%d)\n", errno);
+
+	if (!(features & UFFD_FEATURE_PAGEFAULT_FLAG_WP))
+		ksft_exit_skip("uffd-wp feature not supported\n");
+}
+
 static int detect_thp_sizes(size_t sizes[], int max)
 {
 	int count = 0;
@@ -336,6 +347,8 @@ int main(int argc, char **argv)
 	struct thp_settings settings;
 	int i, j, plan = 0;
 
+	uffd_wp_feature_supported();
+
 	pagesize = getpagesize();
 	nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
 	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
-- 
2.52.0


