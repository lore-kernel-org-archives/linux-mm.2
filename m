Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC115CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AFA18E0012; Mon, 15 Sep 2025 11:03:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 087A28E0001; Mon, 15 Sep 2025 11:03:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDFC58E0012; Mon, 15 Sep 2025 11:03:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE1978E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:03:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8CDDC5A2FE
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:03:33 +0000 (UTC)
X-FDA: 83891803506.02.EB6CC60
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf07.hostedemail.com (Postfix) with ESMTP id 54F5E40009
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:03:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VjQcyFpo;
	spf=pass (imf07.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757948611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mw9l3ATox05SMSrOaVD6dql5/r3vydDIVDHsMiAYBH0=;
	b=NfdEH1DI48XUiG+xW3kPxdiLOjNBSvlV0l7D8mofWUTfOfCENhpNdAgTh9X+kY2SiKEAIE
	UAoIoIFmcSj4xXmAii1UkrFg0DxdkVVdLMaOeKZ5+lVOqF8ujvpG1EZIe7hPNaNuDjMTn0
	fsxHZvU7gl8TJYaCkUZwKtuV7tjhG9U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VjQcyFpo;
	spf=pass (imf07.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757948611; a=rsa-sha256;
	cv=none;
	b=Vq7lHRcBO8HpOUgd8H1JNpSXIiM6PPbSTE4SupnoYmI3XJkvFGhu3U8ERy/IdW045kE3ju
	cxLNwSxRJLAeUctSiVj+zJEWzfUxoKbugJ1k2witUUSPAiAXsS+rIU1PUHkxvbpEnLsLnK
	MZ82bfQz3ti8Z1qJMArhn3nixjTNgmg=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F9b9TH018951;
	Mon, 15 Sep 2025 15:03:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Mw9l3ATox05SMSrOa
	VD6dql5/r3vydDIVDHsMiAYBH0=; b=VjQcyFpoA1Ov14qYqNziq/EnNCZ6O3cbR
	TdIKtbvqH0w180I0vqhxd7QgbpHnN6Lo58oNPCK2mRnce7VStmEMt7Ehh1m4oYr2
	/GZtcrWVI6LzcYr+nVehpSpEYTdAJEetQA5gEii705h/uv3YUq1deX7H0oCMvMGl
	JKzH0LX50OWJxwEqleXlr+m6lX0YLpJTSIi1RJyHSWn0Zlb0BByXlx6HjKcC65Fq
	Ok5A+0v2NUvVpL4zOnJOW2fNwLy8UPOooZR1LG5bxVkPjYU9N7ie0XdHjjtzpoV9
	yVg6dOCxfZ5Gv9oBtFbfhlxc+rWUpvfgXNNoVTqjBhouDdjnRUy/w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496gat1pyy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 15:03:28 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58FF0UUB032168;
	Mon, 15 Sep 2025 15:03:27 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496gat1pyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 15:03:27 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58FBWauU027276;
	Mon, 15 Sep 2025 15:03:25 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495memxxr7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 15:03:24 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58FF3Kim51052992
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 15:03:20 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C08CD20043;
	Mon, 15 Sep 2025 15:03:20 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 01F6720040;
	Mon, 15 Sep 2025 15:03:18 +0000 (GMT)
Received: from li-218185cc-29b5-11b2-a85c-9a1300ae2e6e.in.ibm.com (unknown [9.109.215.183])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 Sep 2025 15:03:17 +0000 (GMT)
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
Subject: [PATCH v2 2/3] selftests/mm: Added fork inheritance test for ksm_merging_pages counter
Date: Mon, 15 Sep 2025 20:33:05 +0530
Message-ID: <f07c901d4b6b1d1c15a8c1bbd324367d6135d0a3.1757946863.git.donettom@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757946863.git.donettom@linux.ibm.com>
References: <cover.1757946863.git.donettom@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=BKWzrEQG c=1 sm=1 tr=0 ts=68c82ac0 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=kDUdi5sUuU8vu5WplE8A:9
X-Proofpoint-GUID: j3U2VRkqQn4XzAtJobpMyJIcM65S50IL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDA4NiBTYWx0ZWRfX+owsqfDsyOJT
 wra/dfkNFMg0Aty67SOAVFn9WPu+ZedniDZ1oBpVSg2IO4QeaJMdd1d8CABWjTR8imZ7wyY3FNY
 kcDXuTvCPt7L3gvm8I079Djz4yVUEKvkTbb+Egj2wXAX6UzpJi7CuWy64jl9eLjD7RcQl8KgF0l
 G9gLpuM1x4xYLKWKxbfSYOdKBOw5QXqoy6Ot/oy1RURKb9a/XoI3WwlivENzn8kd1Va+wVH/+qH
 x5oTE/kfbFC/KThIl7iGI1heWEj7V4tBBCTRzWJFxvrYexNIW3Gu1NkowN97kE3HNURwuYdpupl
 7tO2/IHhEy1CafLDNgUIlB0oPznV6OBo2rlvuO1lREtdh+4fKWDUqn2Cmiq4wxjuBqW8CXHH2VH
 XBCQKQj4
X-Proofpoint-ORIG-GUID: UVh9NO6MTXzI6hFy_IMba7QcotMBbCPF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_05,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 malwarescore=0 priorityscore=1501 adultscore=0
 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509150086
X-Stat-Signature: yz3sbwbo9knangeah3gsrdgkypzgicj9
X-Rspam-User: 
X-Rspamd-Queue-Id: 54F5E40009
X-Rspamd-Server: rspam04
X-HE-Tag: 1757948610-401368
X-HE-Meta: U2FsdGVkX1/xBd9H7f+RFaKmprhfLzIxQYQUH+ROTgFCk5q6d4vS2n6ni8W2tx/HMsaWSCe7LDquRRpYhglMwK023dkiJROXcOi5xSxWlt/2JLuOeXLv3QLhMA5xgIaBncMg+afl79S34gdH27ko3QO9eev+zmIS8OGh66P+0nGT4PTLV7YWEFjRmFOrwY2ef6HzMqlkWPf5enl+fSz09V6DWmu/Hlztymogxwz8mXaR2e2rtXwHifSNlmp9kMg5n4La4t0/bNTdigp2t8aI3HsDTrzGbN0ShL4QXr0vvLOBwPNBnAb4+fL5t++m1pOHCEBfPFHltjzw9VxFyJv7f3q93yUcHhPEVOcorNJ77ctTNzWIL4N0NTv2zmwt1NvqRM2sKni3Igjrkdk3Z8/lxc5FeQgS5TUA1aOFnk7ZSGMgx6c1jNVH9Zo7wEIsQCyLpz7eWu385SBvjjkRvFsfReCwYwxaahQnvhJzXQYDTXrgkAGt2Xwjw9Z0J1mZmQMc26idz7MjQGAN72FFuGYVg0pXe6Fa1nseRiQLSUhJk5LxdhSRlrqD6X8YhLysWWmed+AYq1WHxzc0z6cQhQADWryY+RrEhOvSMccw9GaKHWVrOY/xCQmojw5cMXPLbmdQ6gLhTvizXUY1P68nUx17ohSNQRuSoSALic/rKQUkssvjZMVT3rABKMY0r5aMfhvLKaIT0No1/Jhmb8oAnizPPM11ve95JJMbw/gyPo4G4QMCHYeCHCgCmN1cyD1vAZNe6etMwF2DNdgx9diETTq9wVfozTtEPpZAUZZR3yU2Bmx1lMYL56u9Q4lHLzEX2vt6HXRYqrZJftIkv7wl+WJflNMNQj0iIZLRPFX8hrJFf4cTLRa4TFNfSfffFdRiFJe78J6dMaFfSVhRaj7DVugsgi5sxsHcpTNB9ksVLwCM2D6GIISEbFF0+KNvSVs5rJyTr4Rl/eRgssSdHYEkAuE
 3R0KQfqn
 Weme8lBySI+Kk96Xk80rBVkbAHHVUGQKX9IkbbvRnG/qNGgmrIbVCsSSrTGn737VwXL3XY/KJb8rW2jsQz9YROBfoD7+oygndIM5ZoM6OoBahIYeark8UIFRVas+oTWxSY/q8akNIvq08ZWnlhamSoJ43KksQBIbpyaeI51GbS9FECfsm2JRItnniZO1e7kjEl5SteBfe8aXmwXk0/bFHa9Gkpuv5nQmOEICKam5YcazkmBG4O755njjluVKciIb3+2sp/d7WKnFOl0iMNmhC4bR4qyHoOlrcBz0UF/MODI8LSHljk1H2ylQHjGcyfxBQLdYC
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

Signed-off-by: Donet Tom <donettom@linux.ibm.com>
---
 .../selftests/mm/ksm_functional_tests.c       | 42 ++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 712f43c87736..645cefba2126 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -602,6 +602,45 @@ static void test_prot_none(void)
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
+		return;
+	}
+
+	if (waitpid(child_pid, &status, 0) < 0) {
+		ksft_test_result_fail("waitpid() failed\n");
+		return;
+	}
+
+	status = WEXITSTATUS(status);
+	if (status) {
+		ksft_test_result_fail("ksm_merging_page in child: %d\n", status);
+		return;
+	}
+
+	ksft_test_result_pass("ksm_merging_pages is not inherited after fork\n");
+
+	ksm_stop();
+	munmap(map, size);
+}
+
 static void init_global_file_handles(void)
 {
 	mem_fd = open("/proc/self/mem", O_RDWR);
@@ -620,7 +659,7 @@ static void init_global_file_handles(void)
 
 int main(int argc, char **argv)
 {
-	unsigned int tests = 8;
+	unsigned int tests = 9;
 	int err;
 
 	if (argc > 1 && !strcmp(argv[1], FORK_EXEC_CHILD_PRG_NAME)) {
@@ -652,6 +691,7 @@ int main(int argc, char **argv)
 	test_prctl_fork();
 	test_prctl_fork_exec();
 	test_prctl_unmerge();
+	test_fork_ksm_merging_page_count();
 
 	err = ksft_get_fail_cnt();
 	if (err)
-- 
2.51.0


