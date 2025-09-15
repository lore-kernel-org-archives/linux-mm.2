Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AF54CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4CEB8E0016; Mon, 15 Sep 2025 11:03:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D7788E0001; Mon, 15 Sep 2025 11:03:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875188E0016; Mon, 15 Sep 2025 11:03:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1358E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:03:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 211AA140712
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:03:34 +0000 (UTC)
X-FDA: 83891803548.22.2DDE3C8
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf20.hostedemail.com (Postfix) with ESMTP id 993961C001D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:03:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UW0QNoai;
	spf=pass (imf20.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757948611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjwWWY9wvYaNKY8EAA5KtNvgSNU+KKcZ8lUbtsSE45U=;
	b=mI9XH8dblGBiJiO3Ry8ikUdCnb244kZ/nJLkOGG74Qja/QrJQfxVvQeAVLYmjBHqfWkQgs
	JCjim6vnum1Zl341T6MK7moQR1588wtu1HXLXIEVBk8euXmGmeuiE2ZnDww0agzX92OzxI
	bfEnqfTOSZASJ/i17bowjJ+8jp6QXLE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757948611; a=rsa-sha256;
	cv=none;
	b=Qb23UswleeQG/Bp00ZdyUCErNnelZkYuAbYoDvaglxKiGOLkyH6WkWs2rKdOeGsZ5v6tKh
	ZbZZry4KGiqzN2PFo0gg0MZIuuoMmTOOCRwjOVs9mAad5ijx8FwFpRFNha5+1hoBcau8pG
	Bee6ettzu0vQWp8zOyTsP/74OXjtqhI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UW0QNoai;
	spf=pass (imf20.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F9OwQu018078;
	Mon, 15 Sep 2025 15:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=gjwWWY9wvYaNKY8EA
	A5KtNvgSNU+KKcZ8lUbtsSE45U=; b=UW0QNoaiPu8PZn8HDb8Zq2028URKtOZIq
	IjrLxDxa2AW7gTsIAxuVm+JggSRMg5dANDJcnR69NVkIUSWuZvVCBFCyoLtVSjiz
	azMEZzMai+Ie6nawEpB6CEpM3wDgnqgcXEXAubRpengn5r9qXB+BzRwQMZaTfCZa
	4lelEt2ytcvqwUhIYNplG8A5+Jzp5d8uMtlibjWNVS8FGGD7ZfmxqNkgEN3Jk27h
	8fLkPerTN4ilKu+DmZMlXYqk0bvl5Z8AHoUURZfMW+TP3AB2yo7RavfqTmfoFqmF
	KJT3ZE5O+IjmUb15oUXrHGv6Zz9bR5uZ5PHzOapYuxceIhiW5NDjw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496g531rdd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 15:03:29 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58FEnJdb002136;
	Mon, 15 Sep 2025 15:03:29 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 496g531rdc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 15:03:29 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58FCQYO5008988;
	Mon, 15 Sep 2025 15:03:28 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 495nn36pm0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 15 Sep 2025 15:03:28 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58FF3O1r42533242
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 15:03:25 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D841E20043;
	Mon, 15 Sep 2025 15:03:24 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0371A20040;
	Mon, 15 Sep 2025 15:03:22 +0000 (GMT)
Received: from li-218185cc-29b5-11b2-a85c-9a1300ae2e6e.in.ibm.com (unknown [9.109.215.183])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 15 Sep 2025 15:03:21 +0000 (GMT)
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
Subject: [PATCH v2 3/3] selftests/mm: Added fork test to verify global ksm_zero_pages counter behavior
Date: Mon, 15 Sep 2025 20:33:06 +0530
Message-ID: <5910cb6bfc7c43b169b679a0108667a56d7ebdb8.1757946863.git.donettom@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757946863.git.donettom@linux.ibm.com>
References: <cover.1757946863.git.donettom@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZXyxwX1ucZr2gUZwipFy9t7yA4Xbn7EM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDA4NiBTYWx0ZWRfX4G5L7Xf8orpF
 YrFigQN0bXgzJCxVV7kr3vYqAtOCkAMRmoN1Dyi/zv3wNRrgmP3trUgqVDAf1zqGeNwlwGLpkeu
 sW7I7G29lLsmw4sCAE+SacaAQw5FN41DCLe6/zO5GVY+0EZMl1hc2jgbrwm3PV9ALJd17QMz7a2
 nGZ8RIX37iwnTfBMlbh2jMXIYTkAJT3tgL7jv54g4UB6KHeMDNFzsQhn8L3fPb0p1qyssitq1BE
 GV+Sf000ZYaLxcJjk/DaWmUM+Rch/YFTFkCzcx570hdk+4vHdrYCEJhyiBlPhP0v/MvY/U9+Rhs
 ppXe7x+TxswxlYPGVBCL9gyXgJk1oXg9fqp57LO+1sP6Ca5RF9t+2MN6JtyjJHmcM2Zg0MiJWBg
 l4WfQjmd
X-Proofpoint-ORIG-GUID: KlHLGoZtd7BO7u8AJEiCdnV-7phG6b92
X-Authority-Analysis: v=2.4 cv=UJ7dHDfy c=1 sm=1 tr=0 ts=68c82ac1 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=2YreOkuNpnKIDl0BDdwA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_05,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 impostorscore=0 spamscore=0 priorityscore=1501
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509150086
X-Stat-Signature: ima4tqsthqri7wobcpqfx5eicbnwnx3i
X-Rspamd-Queue-Id: 993961C001D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757948611-570493
X-HE-Meta: U2FsdGVkX19r0TpAhlLi5oQqhOPTsPmrYyeD+/44nEh6Gn3bcrJLIml0Xb1LhaGws6FAU2Se9Ly20q9M4hwRiVGz1r+eRpIPh/GakRXZRQTkGf5FyDfP+XYyZsSESjb0upGu3Zt+jRIbJk2bzQXPJosjJlujWASX+N7RVJby+BD39C9JbtQXjVvzjoIE8r/TY73i8Bo14HjcOjiU2vDGAFgiDPyox2hDPVjeeR5gI+NdNxf9REBuRgIOKGgJE+FSpmRqwVxGGcrra5jbS71SG8cOVIDonVtRjz2bbsPLJvH/MxJa/DbR1xFXRqRM9EwhR3XDnu7i7eFNNBEluevS6PstoBFVqHRkj4JJt0ZP6Ser8wA54h0kUZ489gWBIQ9GS84vzd4UgafM3rwQ6dDJ0xY8sYXkMnaf0M2E38et5+rD2cVksnEUs2jJNw6tgFOGT/v3q7ggWNHw7AnvLAs0UoOfBgrNTgU7EUKT/67oUt/gkjNh1YGB1lH5kBe+QmxXqREDlFboUf+mszWjKPyRGHpJ9aBFnlbQLfMGqkSn4pKf0AFXJmE0hEe4tgg5LwZb3z27NpztjmWQ2XgJUTq8X3KmzTOnG7jIKiU+BuJ7KXucr6l2vLawSEMJEt5mmsk3BpdbryG1o5PEf/3eS3zjKHCZ3Pcaw5E4ge6JCOqaUjbI3OK6+O7OQMKAtQSeUKy6jUMULwe65MdRzob9v2h6Eg7N3QTy2fVI8nxTH5H2Qm/Vm96NpzKqag8NQxeEW+1tdmQcbw8gIXapd4gMdmlPtkDqXuDGeK3rHW/DGoJ7rzPmaiPA7IE7JVBrx7+hH18y2oRhMAbUkrIfedbqfg0pjWVwVofAUwql9ejpq/cEi4eGEVgP0br692QkFoxGy6YZWk6p4LWyw5ZYUu58tbfgD74w0CnsTsot1Kowot5hVY3pPorkgL3q9MgclHb4PMlxyoStf71kh3nZAZrBvsO
 0+b+2qo6
 JMqabPntxYSRbE4d679jlAFa2GTiIpMiCl8fAARsJqwm19Ioe3GKtPTtmEFItr29+IYREVk3NOsW5PldKXxVDfGcR7jgc6jR5BV0YsV4xspT8sd235Y9Axt92Y6WDrRayexjw12CmvRv8LJ9gVeYquX6hMnfrr3oP5bdHhQdE5Su48SPHGvbzdk7CRmV9lEau1o5gxIH7iWbasXVuQVYZLmWtnBBtXz0vq9kA+ZDaTIgtgThr/xAPCNEmTGszdJJ2y6WaBjxH9MrdpGwkNHAaiRxqiIlRi17LgqT8fEa23mnrGEGs/ScmEaatYQ5lan7vmkuhpGNATj1/Ds+f1vGOKr+AVxKaKlmJm027XtqJwlVABqRzfN91+clgvHRumYUgsRzuO9tgx0yIPucY/Iaez9sNsJeqs66DzNsGPeTAucR2KN2D3idThwW++cTCieXKjIVx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Added a selftest to verify the behavior of the global KSM zero-page
counter during fork. When a process forks, the per-process zero-page
counter is inherited by the child, and the global counter should be
updated with this inherited value. This test ensures that the global
counter is correctly updated after fork.

Signed-off-by: Donet Tom <donettom@linux.ibm.com>
---
 .../selftests/mm/ksm_functional_tests.c       | 74 ++++++++++++++++++-
 1 file changed, 73 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 645cefba2126..f23597ac8066 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -602,6 +602,77 @@ static void test_prot_none(void)
 	munmap(map, size);
 }
 
+long ksm_get_global_ksm_zero_pages(void)
+{
+	int global_ksm_zero_pages_fd;
+	char buf[10];
+	ssize_t ret;
+
+	global_ksm_zero_pages_fd = open("/sys/kernel/mm/ksm/ksm_zero_pages",
+								O_RDONLY);
+	if (global_ksm_zero_pages_fd < 0)
+		return -errno;
+
+	ret = pread(global_ksm_zero_pages_fd, buf, sizeof(buf) - 1, 0);
+	close(global_ksm_zero_pages_fd);
+	if (ret <= 0)
+		return -errno;
+	buf[ret] = 0;
+
+	return strtol(buf, NULL, 10);
+}
+
+static void test_fork_global_ksm_zero_pages_count(void)
+{
+	const unsigned int size = 2 * MiB;
+	char *map;
+	pid_t child_pid;
+	int status;
+	long g_zpages_before = 0, g_zpages_after = 0;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	/* Unmerge all pages before test */
+	if (ksm_stop() < 0) {
+		ksft_test_result_fail("KSM unmerging failed\n");
+		return;
+	}
+	/* Get the global zero page count before test */
+	g_zpages_before = ksm_get_global_ksm_zero_pages();
+	/* Let KSM deduplicate zero pages. */
+	map = mmap_and_merge_range(0x00, size, PROT_READ | PROT_WRITE, KSM_MERGE_MADVISE);
+	if (map == MAP_FAILED)
+		return;
+
+	child_pid = fork();
+	if (!child_pid) {
+		exit(ksm_stop());
+	} else if (child_pid < 0) {
+		ksft_test_result_fail("fork() failed\n");
+		return;
+	}
+	if (waitpid(child_pid, &status, 0) < 0) {
+		ksft_test_result_fail("waitpid() failed\n");
+		return;
+	}
+	status = WEXITSTATUS(status);
+	if (status < 0) {
+		ksft_test_result_fail("KSM unmerging failed in child\n");
+		return;
+	}
+
+	/* Verify global zero-page count remains unchanged */
+	g_zpages_after = ksm_get_global_ksm_zero_pages();
+	if (g_zpages_before != g_zpages_after) {
+		ksft_test_result_fail("Incorrect global ksm zero page count after fork\n");
+		return;
+	}
+
+	ksft_test_result_pass("Global ksm zero page count is correct after fork\n");
+	ksm_stop();
+	munmap(map, size);
+}
+
 static void test_fork_ksm_merging_page_count(void)
 {
 	const unsigned int size = 2 * MiB;
@@ -659,7 +730,7 @@ static void init_global_file_handles(void)
 
 int main(int argc, char **argv)
 {
-	unsigned int tests = 9;
+	unsigned int tests = 10;
 	int err;
 
 	if (argc > 1 && !strcmp(argv[1], FORK_EXEC_CHILD_PRG_NAME)) {
@@ -692,6 +763,7 @@ int main(int argc, char **argv)
 	test_prctl_fork_exec();
 	test_prctl_unmerge();
 	test_fork_ksm_merging_page_count();
+	test_fork_global_ksm_zero_pages_count();
 
 	err = ksft_get_fail_cnt();
 	if (err)
-- 
2.51.0


