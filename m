Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FDCC87FCF
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 04:02:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B77226B034A; Sat, 16 Aug 2025 00:02:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B006F6B034E; Sat, 16 Aug 2025 00:02:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A0B06B034F; Sat, 16 Aug 2025 00:02:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8682F6B034A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:02:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2A9BC82D97
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:02:27 +0000 (UTC)
X-FDA: 83781273534.06.33DD7F7
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id C43CAC0002
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:02:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="OK/hasTJ";
	spf=pass (imf10.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755316944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=onowwSIkYU3ULnZCBcG9cEogr69XJmaAQTaSo2mpmcc=;
	b=RJJlJHZVHj0VkRFUhNhjfQBtMt+UjxYeTtmBbDzUjNs0A7Xbe1JXZGMviuA7ssIC/c+0sd
	5c8nt6oNhw5ErjCGmTFuRwY5BrJEIDVFhG6UDyc+ZtNGYnctIu19Gi/UyHqD0MGYDw/fV0
	dOi4CBCRvf1dqY/Ad75trPIP/hNkTKM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755316944; a=rsa-sha256;
	cv=none;
	b=CoJ1tmEpi3VkdfxGjmc1KU2rFxUuuLHus8Hj4g5x2t5xcG2R47qlQFaf8eLLCje4GGhSur
	nibdxmpnaBw4c+TDQznkN0DLZ2VwMCy8x4TbMJnwuqm+h2s0dhDiSfuTxdjiaoXBHKkqpx
	a0PCwoT8Kp4WQ8HKRNvBZdenHzizGwE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="OK/hasTJ";
	spf=pass (imf10.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57G3xJPs013014;
	Sat, 16 Aug 2025 04:02:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=onowwSIkYU3ULnZCB
	cG9cEogr69XJmaAQTaSo2mpmcc=; b=OK/hasTJTBhFbTKn7Sfovyvih4J8qaidn
	I7RFZDM08KLJeSd8Zc6xA7Rus7OmIJiglZd0atfRarrFeXgKqoKbJApLyXDtKHno
	vOgPYeX6KvWx0DpJM1uColvSx7QLnZY97sWYEhk9x6afpqZILprGj7Vfuytry9G2
	jEBWaVtuA5el76xAh5SjsMUGol1jO4qUIe+YwfOKMiDARwbhnD1l8cnIxfUFaHSz
	Lu4AuX8I8sI8vBJBzYT5v61vF9H+nZZFssaq49/XloMYJMiURkjcBqaqnrs2BouQ
	oErGkQC5GNgTYdJbQWNQ7gnJJLTKUSd5DZV53jEVVrjxhnaj8QDRw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jhn3g4b7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:02:21 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57G42KBn018593;
	Sat, 16 Aug 2025 04:02:20 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jhn3g4b4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:02:20 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57G2cmWR028571;
	Sat, 16 Aug 2025 04:02:20 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48ej5nkqrp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:02:19 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57G42GRu26542592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 16 Aug 2025 04:02:16 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E111720043;
	Sat, 16 Aug 2025 04:02:15 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 143FD20040;
	Sat, 16 Aug 2025 04:02:05 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.36.5.210])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 16 Aug 2025 04:02:04 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
        lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, richard.weiyang@gmail.com
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, donettom@linux.ibm.com,
        ritesh.list@gmail.com, aboorvad@linux.ibm.com
Subject: [PATCH v4 4/7] mm/selftests: Fix split_huge_page_test failure on systems with 64KB page size
Date: Sat, 16 Aug 2025 09:31:10 +0530
Message-ID: <20250816040113.760010-5-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250816040113.760010-1-aboorvad@linux.ibm.com>
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CFQgS28LN4Wajl8ZHwrrTcDo19mWi5Ow
X-Authority-Analysis: v=2.4 cv=L6wdQ/T8 c=1 sm=1 tr=0 ts=68a002cd cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=7CQSdrXTAAAA:8 a=Ikd4Dj_1AAAA:8
 a=uVBhFXSbKd2CZzvqDNAA:9 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: eIyWTsAhw2kzj6p73y_AIndWzuhpao_0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDAyNyBTYWx0ZWRfXy5LiTrSgbkSZ
 jNILPQvNqn8DKjgJUqVICHjr+wodCkaE5edQdFqtAmap8cdpO8yON+CzaG6ZHZz6YjXkV9v7wmx
 Eda++xk6SOHDZ8vn6odWuik86jy5i36VyKO/iK1h59z81OmGFBddDMZjpoP+XmLL+tgGtftuVGd
 qB/AIC57RuiBoTtJmFVvKgRGw9M8TKgIWSCWA9oJedUYfLNxy4YbTwXmIfZP2vN5SWAfPZjem1u
 zgDlLD2uBa+xuWM79Wj+UVcnX/ehF1CsGNqDDHttgMLEKjnnrUBAfgaf7H5NTO2b2RE0G+dmAmK
 dIHMl2mPIe/DGsYtUA5zpOqAdNW0bBmmM8q+nFjrU2DMgo0VUbIX3/+eMQewklPg1kI/iJQ+tNd
 kdLguIa7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-16_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 clxscore=1015 phishscore=0 suspectscore=0
 malwarescore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508160027
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C43CAC0002
X-Stat-Signature: 11sx9pp9uwkzppgjc35gaakq5pu4zuri
X-HE-Tag: 1755316944-232613
X-HE-Meta: U2FsdGVkX193OTzGUFR/Vg6Nok7Dk14d0QIFiZloZCe58DD9Cl6jJ85Y405gBgDdPaB7QkEFr/qZ7wmIInqSixcj6OxzAFADe3IXckmZZK7/cK93WOSvxBiNNmusAPRZO7XGbifxx1QsXVjo5M58UTon/+7J3JMiDGZeGXddlntAm/C5iW+mWCld857D2DxUzk0SeqT/J9ihPBItC33Np+GfOoWs4+Yu4MwVwrENcB+98srHTrC1h0yj31lfl685pOieZUSyvUzqR/WYTH/Cf/6o6S6gUO3ZHymp+Ck7fK8f0IUeeAyesyHM1jEVi+tdFrzZ841FuxepnPTNdDlmd5CRu5FpcSBzqeGYULEkKots9XfwM5R43vEHe8XOnvCbmzF+OEtLARYO2SUTDMRqQJvwZ9PkSHamRd47irXDQgNwqsYuPPlcof77K1tuJwDAeRkgkOOF5RIM2lpKDf3kN6U5m+6jmhWBPn2F3lvV/TvEC+kR4oR1BunE92eWaJtVOe+D3OAvLYPdeEbmEC+a3P4QtLIpJLziBINYhvpbVkH92SE7yJqRts6AmleJ4WpfoHL4EMkHYCPSRcd4v12rBTWy5byyf8j6uGYvgJaRw1sEBAe79mpv3PV3ZS8PyULQfue9GsfwLVOjLMGUjmc6NPSXD1iUWlcS0hFY5RFEWkaTUAoyu5IutZ/IkwoE45EDtGjrk5Z/YRjISw/datFRy0ZRUa8zZq0wIeVhkbvaLFExiXLYT4aw6qTZfHuVtgbDm8q8ppZvSEyHbLePsfcOSTyrzKtfUX5VAeAsfxxquTh8PehQCBBV4qneEUwLXTKhiYTXqex80pvJ2C+eF/YRV4iMv9LcSh4DmTtwkObu5E/rqfyCtn5yGdBi0tlCXUsQFIWCV8vCSRGPi9KT3SVjbVqot+UiZMvCu2QefLLtCoo93bHzqVO9PnwJOKM+0jq5kYGghHOijtW/lq/ttIt
 g7P5kXx1
 xXNXOk9inrn3MJyeS2D4cNoNSBT9RH6QG0kz8gkycA6HMKO8zs6RZ0GHxyCd66DUEot3zv6FxXNM9IDeoh6D56gYu4dxl7cmsJlr9bZsTyl+T2bN6fUFgFKggsUnpNdtc/BmvkKc20lqZXnlSd7fSfsh7bM62FBjgnLRI9RB0MsSyj+eYEuOw6MeinWx3E7lCzA+JR0E1cKfApOJ3vXMCJrkZd5ZaXO/zg3UKfI8/+LxdOKEhPaiT4zt2MRe0kQBxXRlj49X3iB6V/oJkUN4FzG30QnYQFAC6notTokX2/JGZm695OSaepLuzu0csv8PTpEaNlZR2mbZB91FAN2siw5djgDmyYOliTXjvmIcV8598ZRZKWRWM7BRpdXmpouBJnoT5p85i3dJ3fp4xWXh8oZS9AA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Donet Tom <donettom@linux.ibm.com>

The split_huge_page_test fails on systems with a 64KB base page size.
This is because the order of a 2MB huge page is different:

On 64KB systems, the order is 5.

On 4KB systems, it's 9.

The test currently assumes a maximum huge page order of 9, which is only
valid for 4KB base page systems. On systems with 64KB pages, attempting
to split huge pages beyond their actual order (5) causes the test to fail.

In this patch, we calculate the huge page order based on the system's base
page size. With this change, the tests now run successfully on both 64KB
and 4KB page size systems.

Fixes: fa6c02315f745 ("mm: huge_memory: a new debugfs interface for splitting THP tests")
Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
---
 tools/testing/selftests/mm/cow.c              |  5 -----
 .../selftests/mm/split_huge_page_test.c       | 22 ++++++++++++-------
 tools/testing/selftests/mm/uffd-wp-mremap.c   |  5 -----
 tools/testing/selftests/mm/vm_util.h          |  5 +++++
 4 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index 90ee5779662f..e742d9313798 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -41,11 +41,6 @@ static size_t hugetlbsizes[10];
 static int gup_fd;
 static bool has_huge_zeropage;
 
-static int sz2ord(size_t size)
-{
-	return __builtin_ctzll(size / pagesize);
-}
-
 static int detect_thp_sizes(size_t sizes[], int max)
 {
 	int count = 0;
diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index eadbeb820d71..7cbeaebc9d71 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -523,6 +523,9 @@ int main(int argc, char **argv)
 	const char *fs_loc;
 	bool created_tmp;
 	int offset;
+	unsigned int max_order;
+	unsigned int nr_pages;
+	unsigned int tests;
 
 	ksft_print_header();
 
@@ -534,35 +537,38 @@ int main(int argc, char **argv)
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
-	ksft_set_plan(1+8+1+9+9+8*4+2);
-
 	pagesize = getpagesize();
 	pageshift = ffs(pagesize) - 1;
 	pmd_pagesize = read_pmd_pagesize();
 	if (!pmd_pagesize)
 		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
 
+	nr_pages = pmd_pagesize / pagesize;
+	max_order =  sz2ord(pmd_pagesize);
+	tests = 2 + (max_order - 1) + (2 * max_order) + (max_order - 1) * 4 + 2;
+	ksft_set_plan(tests);
+
 	fd_size = 2 * pmd_pagesize;
 
 	split_pmd_zero_pages();
 
-	for (i = 0; i < 9; i++)
+	for (i = 0; i < max_order; i++)
 		if (i != 1)
 			split_pmd_thp_to_order(i);
 
 	split_pte_mapped_thp();
-	for (i = 0; i < 9; i++)
+	for (i = 0; i < max_order; i++)
 		split_file_backed_thp(i);
 
 	created_tmp = prepare_thp_fs(optional_xfs_path, fs_loc_template,
 			&fs_loc);
-	for (i = 8; i >= 0; i--)
+	for (i = max_order - 1; i >= 0; i--)
 		split_thp_in_pagecache_to_order_at(fd_size, fs_loc, i, -1);
 
-	for (i = 0; i < 9; i++)
+	for (i = 0; i < max_order; i++)
 		for (offset = 0;
-		     offset < pmd_pagesize / pagesize;
-		     offset += MAX(pmd_pagesize / pagesize / 4, 1 << i))
+		     offset < nr_pages;
+		     offset += MAX(nr_pages / 4, 1 << i))
 			split_thp_in_pagecache_to_order_at(fd_size, fs_loc, i, offset);
 	cleanup_thp_fs(fs_loc, created_tmp);
 
diff --git a/tools/testing/selftests/mm/uffd-wp-mremap.c b/tools/testing/selftests/mm/uffd-wp-mremap.c
index 13ceb5628970..7140b2f9c452 100644
--- a/tools/testing/selftests/mm/uffd-wp-mremap.c
+++ b/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -19,11 +19,6 @@ static size_t thpsizes[20];
 static int nr_hugetlbsizes;
 static size_t hugetlbsizes[10];
 
-static int sz2ord(size_t size)
-{
-	return __builtin_ctzll(size / pagesize);
-}
-
 static int detect_thp_sizes(size_t sizes[], int max)
 {
 	int count = 0;
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 1843ad48d32b..85f7dae9a0c1 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -127,6 +127,11 @@ static inline void log_test_result(int result)
 	ksft_test_result_report(result, "%s\n", test_name);
 }
 
+static inline int sz2ord(size_t size)
+{
+	return __builtin_ctzll(size / getpagesize());
+}
+
 void *sys_mremap(void *old_address, unsigned long old_size,
 		 unsigned long new_size, int flags, void *new_address);
 
-- 
2.47.1


