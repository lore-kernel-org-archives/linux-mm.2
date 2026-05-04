Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5A4CCD3436
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C465D6B009E; Mon,  4 May 2026 04:26:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD0016B009F; Mon,  4 May 2026 04:26:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A215C6B00A0; Mon,  4 May 2026 04:26:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 942236B009F
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:26:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4DF5E16041E
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:26:02 +0000 (UTC)
X-FDA: 84729054564.13.260089B
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf28.hostedemail.com (Postfix) with ESMTP id D6115C0002
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:25:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="ACS/8LjP";
	spf=pass (imf28.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777883159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eEOC4G2ZWST9olhihUFWeAxxSaTnVqTcR+V7Cs8ArgY=;
	b=pEgKfJSYwIjzBeGZPnNrUOexahRYHi7RZKPYqibX/ypWxHhRXxfjn3Ff/JS0LHVm+yV9t2
	1q9g0drIdmUNy9Qx1NAPBAtI7hjQgX6n8iHx6fH5pLfCy5d43PU/Zu/RuZ4NpzP1c+IANe
	dbz6fntChFdCSzDZbFi+P/V7YZqxuBU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="ACS/8LjP";
	spf=pass (imf28.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777883159; a=rsa-sha256;
	cv=none;
	b=v3vZPBCMnz5qN3ruBE5Jzb67nEiYyl3S3Ld/3JTkG9RRAl0JulS0z+6tA0GiZe3FoA8X6b
	d50PDLPcaDkQhjr7bcdtQHrnpVD2oMd8IghEjevtEUYuNZHeByiENXcpqv8dXA9gDdpAtA
	HwTqUvUMIxP8XDinZme2i1lUh/Zu5lE=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6447sMbN852737;
	Mon, 4 May 2026 08:25:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=eEOC4G2ZWST9olhih
	UFWeAxxSaTnVqTcR+V7Cs8ArgY=; b=ACS/8LjPnmKRpBgCC9clEf0/n9SAnNQlh
	vaZvmG3b405kEFBFbEdI8XZTePwKeK+q3sxB79UqdpXw09jIx+EV3hpLcc33+oif
	Cjn45BgbY0dwW9vLko02n51xLV6HDWEwexHLNPtZWAh3S0VtbR6wWYtbOh5eQXu0
	kaFv+EpfH6m1Llkfgsn6FLExLQ/2Qz7aS5UX4PlPt6jMkfAE2eJPlaANk65IZCCA
	WwR0UD3OJUq2fumgTANklNhZ4zM5qyJLEFdpnn+aA9vY+LqjopYdTyCqtvlQDAlp
	xPx1FrysyKnp/cuq5qiMecf8mnO/fbcB/yI/MCqj2yDyaN1Odq5AQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y4dxm7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:47 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6448OO24032710;
	Mon, 4 May 2026 08:25:47 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwukq4fsf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:46 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6448PhGV16777684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 08:25:43 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 86ACD20043;
	Mon,  4 May 2026 08:25:43 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5286720040;
	Mon,  4 May 2026 08:25:40 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 08:25:40 +0000 (GMT)
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
Subject: [PATCH v6 11/14] selftests/mm: skip uffd-wp-mremap if UFFD write-protect is unsupported
Date: Mon,  4 May 2026 13:54:48 +0530
Message-ID: <902b5c8139a681df83d78551d5bd4bcfa54ed3d4.1777877814.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1777877814.git.sayalip@linux.ibm.com>
References: <cover.1777877814.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDA4NyBTYWx0ZWRfX3Yh6pK2He7kU
 Di7hUwVi+46Wh6Yw7qJtS9XhcwJMF45xROzk8LwWbFXMiqxbTjyUYi2nvRj4Th8mrbGiyuSTIoK
 QJfFCUlzOPZoT2l9leH23zIf+pGFaF64Ev3X46oprqOs1Wx5dfZZma8GikZa7kksIct8IBpngoN
 CIFo3d3WwAHRW/EyaTAbkzFPI2v88fQ8uYFMHVgv9TOdMe+nETF7wXGHSqbYykK1wrVX5tGdzNa
 c/5/+b9qOhUvKW8pcZtUyOHmW9fqwb7ZjxC3vc+p1iRnAeVpLztfPczq5UFAcKlHSO975eo2W+X
 1MAznx2TlYlsBF3067s5S6aHY/nR4mbVaG8h5BGgghuFcBBc5+KSaPfpEMINlNgJCBrwZbNWWdK
 Auj0SR4twfVDHCz4Ls2AGx5E1s3V6edM3f2zJhdcUk3ycFaZSUaVDt2e70lcc4CdZvhdlgJuePb
 TSV+EgYllre12BHNYug==
X-Authority-Analysis: v=2.4 cv=J4GaKgnS c=1 sm=1 tr=0 ts=69f8580c cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=njH7lnjfnPuJvX8OOgMA:9
X-Proofpoint-GUID: iO3DPjSToF56TX06C1VMlVCNxALVfiX3
X-Proofpoint-ORIG-GUID: -dBqZdtVfJELVuVJqNqzGacCYupTfoQu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 spamscore=0 phishscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605040087
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D6115C0002
X-Stat-Signature: einmea6yfc6goyqsbasqyqtbnf73rj8s
X-HE-Tag: 1777883159-29505
X-HE-Meta: U2FsdGVkX18L8Q3ucUbFX5Ww1G+GNwu+HE1augi1qbDBeGw3fPTWnSw9KoFMPEELnVHEjrKTguk1g1LaDZ98cwr6IISEhji/DIgdazcKfYj8IO1PLPtA7xnLPB1WTH4ZMdQNfEY9FurHu12aTrgCa3Jl9m0SQwuBLovG6ZZgt9iFYaCWVkfqxj1xgrIQyFLIBLcImp3dgF4SV6HerNlizpneMf2REA81xdcgROKNlkg+odESnLj8UatPufV7HeqvfBRrmgfBCgP4tJGA3fTQ7/4haNK08kTk/8+AdvVQzY0p7/+SIqebL/O+f5/nhiELgLSZGkxuBbB5rk++UQwnIoTwYxdz8OF/VwbQ2mMvgrFZr9ElDLiFGES+L58NEMiGIDns61ZQj/mdf1y3B/OLsDW7wxELYv7vPl5Fc1ns2zBflF7QV0ik+3t0W3R27/4Xy1pQ1IeJ3Xn2TdEG8tTV/hL539UW7m/J7NuvjeNXw6P/yz6DaiZIIN+zO+3LUCX8OEjKhQWNE1EsdLDVFmIXBlP5gSRiRLf5TjKNlEAhwlN8eJQQVCrVKFzB1PQ3iX+6gcLLJBJRD0ueBwdZodpVn7eTFh4PmC+c3J9EoRpYEx9H9rcyGPvv8kGv5+YmWvJH5kwTsgVJoIcujy3UVnRonZiTxbWrP/o8r5UI3TVVH6w0QtCeX3TYQJNqpcSijhNHazEzVzquVSqQMhKgOAkOZCGyramf0OQgkEgem0K1bcgkH02hKp22JSNvrvNZ+d2c8FxHps1H67xRmVSlI5J+5mgcmNx+xFC4UXRgpyC6Zr7NiAxPRxRXxde7l6YjWfD4DUOO+NP8NrnXm9345N5xcuGuy80757fOt+X2Rc9PSDtWZDmMmuUbhax9XSNoOdArBVNT2KkrLEHaVm7YFmHukopEM0giu6UKb/POZQYPPaxi4hBVxIWFwqOTr+mpJs4wFUtaiOCAT76ga+kopaQ
 0zdlJ2G+
 Kfxz8ROKsEZ9ciLxP05lF3TTCV0K3WV6nrbzFj/MsBTFCBKrW93DmLAQGDINWNrDCE+nuejMB0ohziUCErScDge0EVr5qe4z5BHGKxwEaFTtgvD5fjAPTXYyLrUaYth6D9GZiOcZIfpaDMZBtP34ertrkrKUkp4Nv6WCUIi6wFTg55vmav4FhZdUJ54OycK4nTdDjAojkWPmMW6KLY31kU8Avu+u1TqPzBpUyCsmofjFwDGL8hPQuoewFVpUBThE5MG8JrXPoIJoQW7KIvLLUG5pUjnHB0L1DbkwMAWOZ/o6rxbeidotwCHvSnvMuHWBXnjjUPEpcmblK2noI0sSfQ6lcaIE8T3krzwTar8dlbSnyO3fVuDJynI+L3g==
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


