Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85797ED7B84
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBB046B00A8; Tue, 14 Apr 2026 04:23:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E451E6B00AA; Tue, 14 Apr 2026 04:23:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0F736B00AB; Tue, 14 Apr 2026 04:23:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBE496B00A8
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:23:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A415B945E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:23:25 +0000 (UTC)
X-FDA: 84656471970.08.A57490A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1F4552000A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:23:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=b531dP+B;
	spf=pass (imf03.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776155003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eEOC4G2ZWST9olhihUFWeAxxSaTnVqTcR+V7Cs8ArgY=;
	b=SMlurFQS/vi7bYxgNIfKkuLqIfQKuwrlftSBXupzjmygkQpznHC+5KI2Mzsfo8DbeptEWv
	9Cun7UWCZY/KWpNKrN9HlUwTFfwZFs3S2tIxmnXVRbrluHx7LL70Cz2WtzpNJpDxDbXht/
	c22dZ1DA5vi4NG+TsfV0eieBWuKYclU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776155003; a=rsa-sha256;
	cv=none;
	b=CMIBmX/2fc3dHsp44m5kWNVW1jpMRiSCvey7JPoqvjbs0a9pOXffwheRtua+ZxCbSavUVa
	zqkCA0Dc7mbrm494zRzKCyQTrbITAmdlpLgVnVegC71U/qH3DZsHirQdil6KAJYbZrdO3L
	/Oln0KD87uYEmIIq1C84xCW/PSUOSZE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=b531dP+B;
	spf=pass (imf03.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLIX3E1842955;
	Tue, 14 Apr 2026 08:23:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=eEOC4G2ZWST9olhih
	UFWeAxxSaTnVqTcR+V7Cs8ArgY=; b=b531dP+BbYC7FZT4kGjec7OBgIhyK/v1z
	455p0e/6o8oivRSuAhBWFRh4Lx1ded9ZQAiNqCGtSz80aJSbHFivQe3PKIKcO+oz
	mY9xWBMZTDnNHhxFqJafaE74T+S5+AKr1ulYfGShrjmXUJH77zVM2onT6JjBLyza
	leY7TeV4jdYGL53xwSeQ1m7EyCRKzPM1hBTaGBNY3UcMrVNjKc9lJYl0Y/9Re7hw
	k3Vc+AAvqJURJxjMf412HWgs92p1JiWEyGnp433naXwdv4xDigYdTWsvTXtovTRp
	0OjzKq0rBeCIMsA0m8HPz1BZYLS+vUcCvh4w3xsLyM7LHnZRsd1Fg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89mhs8m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:23:13 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63E3XB4W031854;
	Tue, 14 Apr 2026 08:23:12 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dg10y8qvu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:23:12 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63E8N8CL51904838
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 08:23:08 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 961C22004D;
	Tue, 14 Apr 2026 08:23:08 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 991B62004B;
	Tue, 14 Apr 2026 08:23:04 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.39.26.223])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 08:23:04 +0000 (GMT)
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
Subject: [PATCH v5 11/14] selftests/mm: skip uffd-wp-mremap if UFFD write-protect is unsupported
Date: Tue, 14 Apr 2026 13:52:05 +0530
Message-ID: <80239ca37ad96216eb5d9768cf5373e7246626ff.1776150071.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1776150071.git.sayalip@linux.ibm.com>
References: <cover.1776150071.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA3NyBTYWx0ZWRfXykIEjqTVyWb/
 JuISvs83R4ZYQpEtV9bPJD0itOU0ZbEVBY3nt1/+iTSqSgquvZ0zUlvXQWdeK13IUwtqRPXNVoy
 /K4h9/FCIRxSGnRe7NearYryVik5UgN75t/OzHC8tGDqJ9HmHXSCdUwWHXS7PUni8hztDKzbaSc
 r1fdkkj67r/IEeFIqZpTwjCctHFBvk/5Ef28ltgd6FJk37RRuuVOi4T2WxbNC2RuvSqM3uUXld0
 2Fpi/l4iHmTxFo59QWKGRPIU/eAwOoOSmoMrTEJEApVZF9L1Jz9UwpXE1X9eODoFjoJk1+QuTWK
 G8VwvlCvS/+ek0k7sbGkwW82WxGy88O0eyh6YsMsNiX0bA691rud7QV7H3kS+gpnXdKbpBzv7rt
 Rl0V7oRHZnCmDwZ1c5JBPbk+t8tBebMY7c0i6NTPCCGUhAjt/Ivbi9bK2HTk+BkJwxZFdIG2FIY
 2Ll3cCOc7rifTZTeP5w==
X-Authority-Analysis: v=2.4 cv=eJ4jSnp1 c=1 sm=1 tr=0 ts=69ddf972 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=njH7lnjfnPuJvX8OOgMA:9
X-Proofpoint-GUID: tPRFCHZz-H-acC40CY2MRNnhvmCE7ieD
X-Proofpoint-ORIG-GUID: UPHYde5pk5iv0EE12nNRx23tffbIF7hg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 adultscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 suspectscore=0 spamscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604140077
X-Rspamd-Server: rspam12
X-Stat-Signature: 3yc3iiyb1wh4com7ka5mjrxpp738fjkd
X-Rspamd-Queue-Id: 1F4552000A
X-Rspam-User: 
X-HE-Tag: 1776155002-720992
X-HE-Meta: U2FsdGVkX1/lRZ7fpkgCikl0ohzJXfWEL9Q/CDXP10ha2sPw1v5s7dcBvTe5/vVliM5bItlLAS9P4pNo57F+hoGy4H/ghOu9BqpKQ8yGBku7YxSr0B+MTCT0wZO2LAKS1enmpvreg4IZVIpMv6g7z19jPw9W/AMlrB/rYFFidpQYGk24segrt6iblD3B2M4UaofTyJ7tNBjy/MMlUmxvgEfK89+MZi+t8Ot8q/3cwO8T68M/IOfEdShZJVKHSqO/5qRi1O/XwVT8TwIVTMrxBygPOJxd/ratUbw8R13lugWwp2cFSH1mZ8w9hhJKmiMY3z4GeZETe7Bx7RyKcBqZdFDmD1yjVrPHnQbawd9E6NS+v9tprgzDloUNbOnHktcKhjgkII67D/ID47wDdX/0GoMPRTdh6OfWP5GmYST+aYvvNzIHo5Gqvux+ZxvZgHv+YYRaM1m/pAOVuVhk1sC5XZKze+MvDxnvgkDr8XVRXU+gSPJOrCmSsmFJKIRScCv6+ZqwIF7f6BNNvPNw8Kv8FUPwGBgPSk0N9kylIjhPzLtJfIGcWkYTCYMJVAbYl8N10HB/pWaoc9mHQCUp/kg4XVHvkCuE5PPlvXj4hDQbZHiVmVloyPgDmcJGyrEkhzHvU0AlLHOlGTHtgjJ/gjUg+jhO/Bv0SrgQwkcFPJBQCnkcUOCqfYpAKi7nLArzrxVprvunL1DuHQSiEnXb6LIc3uaKEI4VhLL0Vq8xz4ODismk2XzCmMZwBivhc5DrIoQwC3adiLT2p4ZQ1jKU+S5ngCSUPqyXHzsG+3ZRtDVksdM3k/eQ4wOi3cMRORU3PYAgbVVun2b8c+W14HSSxfOLGDeznPV/KDcteP3bV3V/gnjI0p1gjT6uLpBFDkR/c4yncOEYft/Vg88kfCoqDdgZ/MY4zi9ysKxGB9H5zaKxSeJiGHOWuPc7NVVQnYz675Zl24U2p34ELVOOeRJwC6A
 I6NUxT/X
 3BBcf2gYlPpCNDHMtic8J10akZL84cvaLUVwZKzHtRphOn9G5FJQu9VGaap/XujqC6paNIuuBLSDD3r0j2aEJJMrosPKmTk0ma5DMEaaIYFneZydyvkh9aWwzbrS0sYpUYFyo5iqWGWDImamcys9bnS9f56CTn6kGNI1zRpn3h6RBgVuqxBoAmFnclWKv+Hea7jLIdYsW5dXAqKZKpHc4TBHl8gP/mH1sRW5xCmqDVyjAj68irwYVRz/4hm1CPLBeEXOdRGwSm9a+YjUkHw4YNjiktg==
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
index 17186d4a4147..8f288484d5f5 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -19,6 +19,17 @@ static size_t thpsizes[20];
 static int nr_hugetlbsizes;
 static size_t hugetlbsizes[10];
 
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
@@ -336,6 +347,8 @@ int main(int argc, char **argv)
 	struct thp_settings settings;
 	int i, j, plan = 0;
 
+	check_uffd_wp_feature_supported();
+
 	pagesize = getpagesize();
 	nr_thpsizes = detect_thp_sizes(thpsizes, ARRAY_SIZE(thpsizes));
 	nr_hugetlbsizes = detect_hugetlb_page_sizes(hugetlbsizes,
-- 
2.52.0


