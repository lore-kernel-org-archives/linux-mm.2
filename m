Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40D45CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 18:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AAE78E000A; Tue, 23 Sep 2025 14:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B488E0001; Tue, 23 Sep 2025 14:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A628E000A; Tue, 23 Sep 2025 14:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63D518E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 14:47:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DAD8AC0281
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 18:47:38 +0000 (UTC)
X-FDA: 83921398596.03.AE67C6D
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf20.hostedemail.com (Postfix) with ESMTP id BA6251C000B
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 18:47:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BVC648B9;
	spf=pass (imf20.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758653256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWyBjhPVJ9kEj0HOT4mbQ4gfG9Y9bTTGVqTNTNBk6tY=;
	b=cZRmftRvbRUXYYtgEqH9beFqY0Ri5eYMTkFh3JOXAn2tCllQlY3og3yb+FfAcdZFeYiiwD
	B9D5dqJiPFXltB6ASRvYl31Pzm3JTSseVDtnW59jbJzlI/BRttale93qv3x8px4+/LZNpJ
	3lQ34V33YI7EaJreahQXVx0n+FPqeFw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758653256; a=rsa-sha256;
	cv=none;
	b=RMYZd0HvqtK3Bfs7CMF6OaaI3gdsc8NGK+q1hsmM1P6tvaSEKMg7CSHagJVqrGnjZwR7+s
	/vQWmczgQm9ADPVQJ6tFMWKMpyz40tycJMQPu2ww0XhhoYw+wfe5R7tx8i4YTzuLsHq8IX
	rM7SgAvzPb11kV8/btsBO6SI0ZGS1Bo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BVC648B9;
	spf=pass (imf20.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58NGWFMC001810;
	Tue, 23 Sep 2025 18:47:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=HWyBjhPVJ9kEj0HOT
	4mbQ4gfG9Y9bTTGVqTNTNBk6tY=; b=BVC648B9HlQljWqjRK/jiReSAc1o886UC
	YyS4reWADYAbpByN/hQpk0FOGhLHWM3h5mps2AngAFiOXIY6Ppveu/SuDeeq1+65
	pTwCS2l+OLnSA+ImWCG2IY5HVeHJ6jziwJu91G9PiT1XWLxeCiVZerRMnQIBdqDb
	tHcZGt8ynYUyd6N/5rML0RXSuAT9z/ppcAk3BIyv8EAydbqy9ufKulJRDXpWgHNe
	ZrQ1YV3jN/V4N4sLSW1yMk/B+6IGvd0HZzcpqYbOAByqndiqOd4uSa0/b8IlGEAN
	PHbkYnqoMXTZ+hxGuD2NsLymWctm3hiPcrKeu5Y2L1N84jjQZp7rQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499hpqavsy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 18:47:35 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58NIXptq026441;
	Tue, 23 Sep 2025 18:47:35 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 499hpqavsw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 18:47:35 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58NHB2KJ030356;
	Tue, 23 Sep 2025 18:47:34 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49a9a14ptr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Sep 2025 18:47:34 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58NIlUPG31850796
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Sep 2025 18:47:30 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9E33A20043;
	Tue, 23 Sep 2025 18:47:30 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D66DB20040;
	Tue, 23 Sep 2025 18:47:27 +0000 (GMT)
Received: from li-218185cc-29b5-11b2-a85c-9a1300ae2e6e.ibm.com.com (unknown [9.39.28.7])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Sep 2025 18:47:27 +0000 (GMT)
From: Donet Tom <donettom@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Wei Yang <richard.weiyang@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>,
        Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH v3 2/2] selftests/mm: Added fork inheritance test for ksm_merging_pages counter
Date: Wed, 24 Sep 2025 00:17:00 +0530
Message-ID: <e7bb17d374133bd31a3e423aa9e46e1122e74971.1758648700.git.donettom@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758648700.git.donettom@linux.ibm.com>
References: <cover.1758648700.git.donettom@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=FrEF/3rq c=1 sm=1 tr=0 ts=68d2eb47 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=yJojWOMRYYMA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=kDUdi5sUuU8vu5WplE8A:9
X-Proofpoint-ORIG-GUID: vlt0YarwwCCxvHbw-JMZk4CEYbXmuZA8
X-Proofpoint-GUID: a1KWKaFoKTLeUCEZkN4FVGuLStWLiyIR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE5MDIyNCBTYWx0ZWRfX6m/w6mNclBpP
 mncaMBnW6ImU+kpNZquOQScJDv76v9VLQr8mDpW0eDqVf5ekUqARuljD6GzslFba1aOngp8Biau
 q7z0UlD24w+YWAHqcKGjL4txIWGFjzJEu3H1dXtG1kGxX1H9P1khPgUBYdkjxoT4tAgSk+OLu+D
 mW+ipyyXalQqM2vVisSNC8hbgB+PEP9OFBX2wM8lmbQK8cfE0342o1X/oH6TJBwBUS3Wig/HKYA
 7wYM7PqByMsMsAKzCro3Esm/1fRvh5IHwHjcXtSw5Ea1PPqLLkhh9OtntPfwa3PGFLud6EuT/QK
 sQtK63L1Hf4v1dhC4uXJ5WaEIoDArns8Kz9n9qF4rGV6lXXzw1RfEjMXWGtD8ugkzjeLkn6KeB3
 S5w+AZrP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-23_04,2025-09-22_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 clxscore=1015 impostorscore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509190224
X-Stat-Signature: tke1s1h9soyqfba44joz9kpt7u88ssb6
X-Rspamd-Queue-Id: BA6251C000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758653256-651609
X-HE-Meta: U2FsdGVkX19yTYS64jqqqPcBq0CENM0nnomNd8AowTJkmYc9FVDGuxJYMS8OFrdld1U4+MzxMqc3whR2IzyX1cEff0jLh6oItPUgHntQrJSCWzXh5neWYa/oieYphuu/2DotPePrPBtbeuAuB7Nc0RDH/hggfmj7fxrIi/a3aKuRcYoiA4nuAWxYqVed7iLNaUmkzm3Oq3ovyCWmYa/onxpKGY6kDovfS5JxOfQimlL7G1yf2hw16ZqUQLsF06+OoTG5mTgfpUchzstWz2m6oP1a+JCUVSU7TTEhWWRSpmqPNfayEF33Uo9GB5QvV6YKI47yMYY5DwGy5N7xakbvEKSjvis6eTgRzMn/AZ0w+P4chyOH5VXowVh1B868fs8qdI0WiyN2nASJZvEZkzT/7bHykK2OUtXuK9HkPtgWe8GdqRRjhdL063bgLuepVqLPqfdLkdCrIi8DXHJbdKn+9L4l9miLQpL0HTPqZM6J/QsSQkwI6pQtwbK8gcDpVoHLCQOgD5lOAdxP/HqWRmVweA1FRSkbKhaLAeixaySTKsPeAtsEMxgYBxeeZ8t4xsPV4LtWhbFA4hKJdnKg1pNUbN28zXZ8xbFKqFWIGiTlHYtj3cNzL4PBBvd0ek9Kv7Zf10TeZAIbEpUzJBEFK+nq/dFZMJ0RgNZXr9Sf8CiAdym/V9CxdiAUxPhEYW5tjw/i+1jj2mfIlKHd4DIiu/pt1v0Hz/CCIlfBdZERmHHG8ZU3RQdGQVZWlgCpchENbgJbIQWrLhaVUMxQk5RV/Ixk+cdolK9BADCyuW6rbhmbvl5RrMRD6hRd46chsrdbzqa+pvkluHh8VYOfk5b8ulp523Nze9sd9J0oC/X2ifCX+fBjLMU4o8cUJutITyRs8bNl0KcTI7PCMHqf3GWKpJMhHImPOCWWe4aWdHcIOo2lABeWI2GwdCkI/OQTWQ8s/b1mIcfFZDDZ72eyqGu8VKC
 9+qLeF4x
 fGYAmtN20ol89xPg3suVqAeqozdsnpBWHkXNNzo1xNaTwc3QmuIuLH5kSR4Ub6Wu2Vf8+guvEoXGbZteXcwqiyVJZfua44OtLiYSWp8m5OMhndI9WTf4PJ61AOlqTjHk9RSjhmkGBGncAwII=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Added a new selftest to verify whether the `ksm_merging_pages` counter
in `mm_struct` is not inherited by a child process after fork. This helps
ensure correctness of KSM accounting across process creation.

Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
---
 .../selftests/mm/ksm_functional_tests.c       | 43 ++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 712f43c87736..ac136f04b8d6 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -602,6 +602,46 @@ static void test_prot_none(void)
 	munmap(map, size);
 }
 
+static void test_fork_ksm_merging_page_count(void)
+{
+	const unsigned int size = 2 * MiB;
+	char *map;
+	pid_t child_pid;
+	int status;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	map = mmap_and_merge_range(0xcf, size, PROT_READ | PROT_WRITE, KSM_MERGE_MADVISE);
+	if (map == MAP_FAILED)
+		return;
+
+	child_pid = fork();
+	if (!child_pid) {
+		init_global_file_handles();
+		exit(ksm_get_self_merging_pages());
+	} else if (child_pid < 0) {
+		ksft_test_result_fail("fork() failed\n");
+		goto unmap;
+	}
+
+	if (waitpid(child_pid, &status, 0) < 0) {
+		ksft_test_result_fail("waitpid() failed\n");
+		goto unmap;
+	}
+
+	status = WEXITSTATUS(status);
+	if (status) {
+		ksft_test_result_fail("ksm_merging_page in child: %d\n", status);
+		goto unmap;
+	}
+
+	ksft_test_result_pass("ksm_merging_pages is not inherited after fork\n");
+
+unmap:
+	ksm_stop();
+	munmap(map, size);
+}
+
 static void init_global_file_handles(void)
 {
 	mem_fd = open("/proc/self/mem", O_RDWR);
@@ -620,7 +660,7 @@ static void init_global_file_handles(void)
 
 int main(int argc, char **argv)
 {
-	unsigned int tests = 8;
+	unsigned int tests = 9;
 	int err;
 
 	if (argc > 1 && !strcmp(argv[1], FORK_EXEC_CHILD_PRG_NAME)) {
@@ -652,6 +692,7 @@ int main(int argc, char **argv)
 	test_prctl_fork();
 	test_prctl_fork_exec();
 	test_prctl_unmerge();
+	test_fork_ksm_merging_page_count();
 
 	err = ksft_get_fail_cnt();
 	if (err)
-- 
2.51.0


