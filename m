Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3079BED7B82
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98B826B0098; Tue, 14 Apr 2026 04:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93BB66B0099; Tue, 14 Apr 2026 04:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73FCE6B009B; Tue, 14 Apr 2026 04:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5DDD76B0098
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:23:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2CAC2E3865
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:23:02 +0000 (UTC)
X-FDA: 84656471004.02.E59364F
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id AF41C100002
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:22:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nkWBfs3w;
	spf=pass (imf05.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776154979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KF0duKJ7kidshxIeQZb5EcnjWw7TF8XQDpz9/tTREjA=;
	b=xt7Qxwbv3Nm7UNEMfmusMbrPugg5SsvDf817hTHvjXXqTUEYWk58JvsZH8MboZDESSCj0K
	l1kd9T1PSa8i3V5URUjri/7cImMLqqdl3Ecs6EvVF1ByjaLZmjhvL0xjgtJaxlxXMpLFhZ
	7MURVGZJFwCosO0iYr/GJAmssLRB0xI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nkWBfs3w;
	spf=pass (imf05.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776154979; a=rsa-sha256;
	cv=none;
	b=Knli5UKFpk13IgExPYbyelqeGPESvl82op71lCs9jSTbkEIH/nRFe966ejR1gi6a9jY30o
	6lRM6rk1FpwEGeWq5MtsfbJD5dgCB08sfQQTJBnvUmNqzHfQGixDltoAbG64YXtT0iQ0Jx
	LCRNrhOL7qYTwoj5Q0B83MtioJ13bFs=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLIwMd2131218;
	Tue, 14 Apr 2026 08:22:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=KF0duKJ7kidshxIeQ
	Zb5EcnjWw7TF8XQDpz9/tTREjA=; b=nkWBfs3wMfP9p/r/uKp5TmtLAVh3GKhw6
	8MlTa62g0LQrkqtQB6mNCJhwmMrlShfxN3e51bMyBjOGMsUWlC/z4XFIXnD6zrWs
	D7kvIGq2R04ZTtIl5B1hQ2be0aAI2s8NhbeSqxcl1fr2Dmo2YnnUTuodLz0yLgHg
	cDT/36oQEmZwgvannka2VazIG0kGJFusbFEvmiNSfkhJ/nSiTSIUi1373ExrVygS
	klRh9YH9FmhssviXKajKVsWcOzTGQPuLJl92b57X2QwjQt1ZEE+oevp6T3Pc2xzf
	uJJvlIPhYmdMla3ZYNDdP9BAaID8EdW5qxWjMhzUvULStb4lkUh8Q==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89n9smw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:22:51 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63E5BYA8004188;
	Tue, 14 Apr 2026 08:22:50 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dg24k8hr4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:22:50 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63E8Mk4928836270
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 08:22:46 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7012C20040;
	Tue, 14 Apr 2026 08:22:46 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 79E3520043;
	Tue, 14 Apr 2026 08:22:42 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.39.26.223])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 08:22:42 +0000 (GMT)
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
Subject: [PATCH v5 06/14] selftests/mm: size tmpfs according to PMD page size in split_huge_page_test
Date: Tue, 14 Apr 2026 13:52:00 +0530
Message-ID: <ac04b3ee7d733798b4d79c840f4ce4e94118680c.1776150071.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1776150071.git.sayalip@linux.ibm.com>
References: <cover.1776150071.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: sdLlBxLRWW2dQEnIHW_peSXjD8a3crlA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA3NyBTYWx0ZWRfX2DLbFH1MWf55
 uykUb+YnbD1eCfjAiGm8I8gIgfBbC+8m7lMnIme1JuO07SgmzrqsllBhnfwmc0tq9JYtXO8XP+E
 fYH3PBvHJyoI5sHUdX1p1WBchYc08w0CLucKaXHTrlHgR9Y5zRUSct4+RC1P8ZVn4BBSFg6diN6
 nvC/zCAf5b+guEaTf0iQkCutNqpTh1toAxwYA+8rbdciAJbhXb9++8Ln1Y0E1Ivt8vxwsiErgT1
 ftabRL3Xnqae3tW0gaa4RRkZ5NtpJ5a5hABIBXrZ2g5S7dQc7BUnG1DrgoT17Ebfce10MutaqjP
 6N0oH40Ko+PzxYkWiXzssCGC3hZPuMcTsaH84dVOI60G3eE76rWf9bZQOz8PaoAOSRsiqNPS82V
 iHo/HC8oUxR51Gg0V3sUCS2zxppPV6KiX/plefYG8hsz8Merz1pCXk8FAj7ZKLaSUXdcxX/T8On
 mkotUhMSAZd9FppbhwA==
X-Proofpoint-ORIG-GUID: dC3DXqNFqgJNAEehbZaZ6BSS4YwKpAhw
X-Authority-Analysis: v=2.4 cv=FY4HAp+6 c=1 sm=1 tr=0 ts=69ddf95c cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=2DqBuDyFdJ_AORcY0zkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604140077
X-Rspamd-Queue-Id: AF41C100002
X-Stat-Signature: h3wm1ow18bre847s41i5fw6erfdqogej
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776154979-150997
X-HE-Meta: U2FsdGVkX19jVzhIsFQpRRS/HMDdGaB8CFamotx6InmBm7Isdq6Cowu7hErzuE2VUZc1Qt5zb6zNoaDcuZyRgGFGOWjFckCxcv18f7n8p96xj25MPD/6Ku5YoPnXGIJfuQ+qve+uH//Z6iW0br2635Yp3EZZvyq5WPuVBtAMlsPWychJXHPH0dk874HKhdH/MM55axZfCOCXkesTR4I6/oeN2JO9cE6LEU0sn1kNy5ZLRpxi5FO6DQnEAsxVRu7YkYUFyyBpTCr3UBcRzm0zRTmdkdDm7qzFDws56dVhxKPKaahAQJZx/mPFJVu1srFND6EeMMcij8UyjFrRjGUP82EYGb1K6xrYzPm+cCMdx89J8Hjub7eMas9oIwIU+yJUEFR09nzn4lSfSaigbmGam9NnhCvSNTXvc3MmNv13CEEkhiOgQP1Mvgw7ma3m7I0UH7HWF+2fyb+9RP1oc130p58grVmfXjCflNF0WXphP+5kqjmaTbsuuPBeMR9/PQoaJ3RFVhNHWZG5UTysW68W4siTMVLF9U5inaNPYFVNbkiqgPImEtJjBqA16iLCXO6By+h8ocSNV6iT9Iyw1zKXkyGuqbNgzbY3w/s+kJ1BghYIJyCKPLIzUrneK3kHRV7TNHQa9hDwJQ5NqcW0a/ECavjXbDp4zCyTC3RUzwggPgxj3hS265mPnCrvVTt/gtUBUgdsWO0nf68pPqPS7wm8rUnscse3FXtlvZk3rd4i4rCuaxjR9p8egqbPY63KFYPnKqeFXUaD9grSRxOFcxcVLj77oFP6T1Wu/Y5T4eLmKUcTEQBIDLtJA1WlEdTtO3hfuAXGWl5DUbd7Qzt7FfavglXEaSZ7m/jHZ17NUVJcMZhn3DbFSIWALncUQPKQBiU6ye2zTtozxSGJdvg7bnKGsayBiycfakCJSYHVzdAbNg138h4nFr7pbZN20AjEqIOndu26BtALxbLKNYdOEnx
 1172aZGA
 +D/Nj6hD/S0bGK7LimR6kqO2CO4cBTmS0HqHogbzhWG6TEEmeHxdhNZ9ZqYgJIIhvxuEOiys5GVT3N4MnuJFfbRe2dsqgRujuaaG0wyu9x4wfHCQtWIZVWfQi/F+lSrmqPVB6+7EmNB8LOJUs6w8aNQ+wEx4AMqNOJAjcXyYWAWTBAVxaNn9Esu+juyYaCAYnx6iWCaxW+i+SOeixu03DKoTAfcKwm7wsLT2QamaKTts2zZF3oXEY/lL5CM1XtysWUUynXYIIiHb66UI4LsnT32yE7ckLDS4Ypj/ydPm451O8UMtzAtad9MGEns6xOVxW5wwiBDp908qRmBhyjSiolj8nKTMCS+EMX4emBk+HqmCg+Kg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The split_file_backed_thp() test mounts a tmpfs with a fixed size of
"4m". This works on systems with smaller PMD page sizes,
but fails on configurations where the PMD huge page size is
larger (e.g. 16MB).

On such systems, the fixed 4MB tmpfs is insufficient to allocate even
a single PMD-sized THP, causing the test to fail.

Fix this by sizing the tmpfs dynamically based on the runtime
pmd_pagesize, allocating space for two PMD-sized pages.

Before patch:
  running ./split_huge_page_test /tmp/xfs_dir_YTrI5E
  --------------------------------------------------
  TAP version 13
  1..55
  ok 1 Split zero filled huge pages successful
  ok 2 Split huge pages to order 0 successful
  ok 3 Split huge pages to order 2 successful
  ok 4 Split huge pages to order 3 successful
  ok 5 Split huge pages to order 4 successful
  ok 6 Split huge pages to order 5 successful
  ok 7 Split huge pages to order 6 successful
  ok 8 Split huge pages to order 7 successful
  ok 9 Split PTE-mapped huge pages successful
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Failed to write data to testing file: Success (0)
  Bail out! Error occurred
   Planned tests != run tests (55 != 9)
   Totals: pass:9 fail:0 xfail:0 xpass:0 skip:0 error:0
 [FAIL]

After patch:
  running ./split_huge_page_test /tmp/xfs_dir_bMvj6o
  --------------------------------------------------
  TAP version 13
  1..55
  ok 1 Split zero filled huge pages successful
  ok 2 Split huge pages to order 0 successful
  ok 3 Split huge pages to order 2 successful
  ok 4 Split huge pages to order 3 successful
  ok 5 Split huge pages to order 4 successful
  ok 6 Split huge pages to order 5 successful
  ok 7 Split huge pages to order 6 successful
  ok 8 Split huge pages to order 7 successful
  ok 9 Split PTE-mapped huge pages successful
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Please check dmesg for more information
  ok 10 File-backed THP split to order 0 test done
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Please check dmesg for more information
  ok 11 File-backed THP split to order 1 test done
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Please check dmesg for more information
  ok 12 File-backed THP split to order 2 test done
...
  ok 55 Split PMD-mapped pagecache folio to order 7 at
    in-folio offset 128 passed
   Totals: pass:55 fail:0 xfail:0 xpass:0 skip:0 error:0
   [PASS]
ok 1 split_huge_page_test /tmp/xfs_dir_bMvj6o

Fixes: fbe37501b252 ("mm: huge_memory: debugfs for file-backed THP split")
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index e0167111bdd1..57e8a1c9647a 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -484,6 +484,8 @@ static void split_file_backed_thp(int order)
 	char tmpfs_template[] = "/tmp/thp_split_XXXXXX";
 	const char *tmpfs_loc = mkdtemp(tmpfs_template);
 	char testfile[INPUT_MAX];
+	unsigned long size = 2 * pmd_pagesize;
+	char opts[64];
 	ssize_t num_written, num_read;
 	char *file_buf1, *file_buf2;
 	uint64_t pgoff_start = 0, pgoff_end = 1024;
@@ -503,7 +505,8 @@ static void split_file_backed_thp(int order)
 		file_buf1[i] = (char)i;
 	memset(file_buf2, 0, pmd_pagesize);
 
-	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, "huge=always,size=4m");
+	snprintf(opts, sizeof(opts), "huge=always,size=%lu", size);
+	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, opts);
 
 	if (status)
 		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");
-- 
2.52.0


