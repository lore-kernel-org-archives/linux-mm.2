Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD24EFCD9F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922856B009D; Tue, 10 Mar 2026 05:51:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B3806B00A0; Tue, 10 Mar 2026 05:51:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CEF56B009E; Tue, 10 Mar 2026 05:51:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5992D6B009D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:51:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3DFD596DE
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:51:16 +0000 (UTC)
X-FDA: 84529685352.26.2C4C5F5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9E65E140008
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:51:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sMzY4G5i;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf23.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773136274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QGi1qF8PiOKDYjAiPGpA3ncjmf9jwUTDw9NnQ+rBsyQ=;
	b=ySsirD9jc49Huzjw6E9wZZahoWpXzc900sSXDkxOf81IdqgdVlT3IT6B0Ca61ZQJVo6R+f
	7mVgEbAK9m1uyFWIDKau9hkrV9w1R1LCLPRDlYOS7oiPzPErDbbuwnLdzEiBEDtWYcqo+Z
	TnKybjaNDpFoe1Fr7DDG0tYMM3jxN4w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sMzY4G5i;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf23.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773136274; a=rsa-sha256;
	cv=none;
	b=vxY5g1ukoX5RdteGVDC/Tc/vqCdUJAqOY1JGejKAtG276Ax9rtGWxl8K/Swnm/34VQ5eoj
	NGjZY3ld/e/go7eraaJ5pm4VpwXwQVvBjZB3rvBfTq/PXThxp/o36GvgfKHcnhKCxyW7Xm
	vGM6kzH4lScxPbXYIMSAQAOGXvJ6u2c=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A87eRb1651541;
	Tue, 10 Mar 2026 09:51:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QGi1qF8PiOKDYjAiP
	GpA3ncjmf9jwUTDw9NnQ+rBsyQ=; b=sMzY4G5iyi+sGubv9NKWyKBvm8brljeKp
	Ha9S2d3pXst/fNP4ahAd4IqrMJ+bgzSqg3ynV2SQDUyBaHMUcp7A2XOGWhtvEaN3
	X4v0/NwRkmVQyeevTIybm8gNkEFmIQzLPi4wzwTzPeqAONqVxj1khOmvlMe+8v+q
	udpHZ2xT6jWFNSg4ZUMD09NmYnQ3qzNpH/vQnFp9gtzAu/HFlQZGrFDQcN6z+VKK
	LUSAygctFY5ITAfllyfYkC8ZE7CpUIoIh1LsWTQcaDjur4ZZJFN/p9Fr76ZSm8dz
	l5bC7EKpQxbmPewGnwycroVsHoG9TG4Mqqf9U4da8UP1x8y2wNpmw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcun9yg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:51:04 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62A6FAnD023022;
	Tue, 10 Mar 2026 09:51:03 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ct8ng1gja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:51:03 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62A9p1Ot52035974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 09:51:01 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7833D2004E;
	Tue, 10 Mar 2026 09:51:01 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 590EA20043;
	Tue, 10 Mar 2026 09:50:58 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Mar 2026 09:50:58 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Liam.Howlett@oracle.com, Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH 09/13] selftests/mm: skip uffd-wp-mremap if UFFD write-protect is unsupported
Date: Tue, 10 Mar 2026 15:19:27 +0530
Message-ID: <afbe6bf8ca508d810bc1c9d749483711edae9751.1773134177.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: SWxD8bpKaqy-0dfV_GENQ8P_aUbhnGDw
X-Authority-Analysis: v=2.4 cv=Hp172kTS c=1 sm=1 tr=0 ts=69afe988 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=smpEqqgnm6pLQfsEXf8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA4MSBTYWx0ZWRfXx8Ggp5UJeC3z
 bgAh9pD69SkCLo8vgYvemGu1LTiQSgaa/rSo8xXVb2EstW+bSjSzyfYlB/1qzU61owb+pqRP2NW
 9Nf5R4POWnv52IeANqEcmIl/6NexdPheiiqJEjSIqYTiTPNXfZSMf+WZD1ZzzcjdWdG0GjxDBXi
 QUmu8AukMRncSuB5NzBCkI3rmVN5qhtuSsO88kDdxemyKPA5HDEYLARN3Wj3TKC7xpUaIMxIC8e
 7t4MZoleXLLeRgnvnpFaLX/cMJ6dOsSOWKWzfm6NEUYKoxNMmZ6zKOXG5QQ6wEI1PHFrDCIozl0
 eR0cDgWsz3Iqs4/wZcUUwFIcJ/KkuQ0WlYCl8MxKMB/t4SALkJq9KbUoiDLiV0mBj6nZIier+hr
 suwscYiNuQ4bJG/y+xCq9nnmZweNXtCy4IXbkzYz0mVOYXMpkRbqKemPXx0Zfgy8sdIjJGPVptV
 /U/tvLIfXTjJZiV4G/g==
X-Proofpoint-ORIG-GUID: K3yND6Lm82jlVHKWL0E0jpjFajuQexdH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 spamscore=0 phishscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100081
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9E65E140008
X-Stat-Signature: whuzca5s33zaciow9j3aiimo1htx7gwq
X-Rspam-User: 
X-HE-Tag: 1773136274-105940
X-HE-Meta: U2FsdGVkX19LbUxY+dCyR0HsAlb3GOXj7bVit1WE7I0yU5kF46sS+83istIfQdB6hAzkv3ww/tHeC1JtG6jeng6L04oH7TUd8cEFO3OcUPHBh+K9mnSsjS5L6wS9HwtRsa+jWFTdPnWRDH9QM2829Pj1SWafjdJ3aso7gq+cJostIGWCf9eyH/NnvUmItyU6SpqexPLkZuWULv7Z/bRzK+jg7y6N8lcrZknmBnmosasaD/piIH/f8rr0yBKrL3sVkjfs/yWe0f74PuCeJMwS33uk2wpRgfd5rdRqfvVt/ALzlSJ/UkDpvlnCa/Dmt3w67dydrSRgxZszPsy8wqn8tkukcYQi1dzdWA2r8QHovWX/QFPT5pKNT4JsnL+Q+ns03dInHlnCA2vSnKW47luERn46LBTwwbk+f6zplFLw0u60WWddxM+MWCF3ei8DKNgA+GCD/F+ElKeOmFiLtEeEefXJQpucNmaFBUwX2i+FlAvIjwoj9zin7+PK975XozPjXBxrpk6q8BgAP7kza/WLs10jNNSproRFW1skwlioEJ0MzZ1Dk8zp045CxbZvQNTU0GE0Nw5ArHT6XRQH3pDmUbeoHtTFKn/kDt9knOXNyssNgqGo3UShZ+j8eD+hpRwnLYFdZwAlFYKxIlP7OYRJXimgoL21oIZZCUqp17AhMGiI5r6NA+piiF4vsYjMOn41QrHQOUCpDiaq8SJRw994Xb7z+zj3gImLv1RPvI3sbqJi9R4TEg+BbrHGgBMs+Z5WxaHCrGX9XJJ91CmlfnqHKAn2Td9IkbuE3W+oBCPDZxYB4qIUSHQczryYM+NaLkDzKBoaXyNLykAaAoVyBEAXI0JDzK6+q9aC8symnyA4/FWqksUPnfne+JarXkk8pOtY3TQb+3A2Bi+2jy8++Y6Z90t6S1Vw/iVakJzK/vmv1+Eo0ItvSkoFt3G/rxI7XQUCuZ6ALV8ZawqWUSqVBYG
 64uKkibv
 sqm0d3/9bBwbt+zeB04h08hlV/9oT8BQ4h6J/RlnAshDWq5nJPIZM8/aK7/cEQJVkOmQie0YsH43BXpIuy/AC3+yQmOLuruWAtnK4ZbR+M4OEtIk+PEZudvGCakf6fffS+vQeniQ01ctBaOAyjvPQEUM3hn+z+3WZRrBjbUVFFyfhozqxWBkGC7WVt64e6Et53ID7VIAS2XQl3clP0aaNScOlw3uplFfJBmryl3c1LuXKs2q+mZkE1zhSd+yt3l/z/7f7zEFwoa+DFigK3vaIkaETvA==
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


