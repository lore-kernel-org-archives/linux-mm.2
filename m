Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 935F6CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 12:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1D466B020A; Tue, 26 Aug 2025 08:49:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCDB86B020C; Tue, 26 Aug 2025 08:49:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6DBE6B020D; Tue, 26 Aug 2025 08:49:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8856B020A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:49:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B5B8119006
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:49:49 +0000 (UTC)
X-FDA: 83818890498.07.11B88C7
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 095FC40008
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 12:49:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="bUFhIR/D";
	spf=pass (imf12.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756212587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+belWiZUDk9fLOgXUHzO6ceN18vMAuWZJInY/ST2zkE=;
	b=o8VUm0+9WbDBapWMN4J1MryNkj747INWkvqYogVrqvRM/2Vkf+aIEiLg2IhKIy6s8nhrpr
	I1VKBAVDsiHZNr5Zh6YDWOcqVE3tj01hVTPEDVVwGTtQxjFHI6UMTT/jJ4yu0BttBtD0uk
	e9JcE/yFD6O+exvhGoedCoBvk6QWMiA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="bUFhIR/D";
	spf=pass (imf12.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756212587; a=rsa-sha256;
	cv=none;
	b=bRuTBQXC9qQVbhO4Oxz+AN09hW6AdlEQGr7GLYY/rqwown9Enc5cV4cKV0KJIMKtaLDjak
	WRG4B2UpDqJzVGUbc7SD6ScKe9iVwS7a9k1PWDm6cXismEHK3Sync+fbk7cJeb7pkcuhP6
	JsoHF4pfntg8WCUPDy6XgFGbdhcIDNQ=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57QCAhZC024902;
	Tue, 26 Aug 2025 12:49:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+belWiZUDk9fLOgXU
	HzO6ceN18vMAuWZJInY/ST2zkE=; b=bUFhIR/DQv/8PzoNRFyj5Xc4ZknlOgBfR
	4U9jjSlERU42kpXBspa+ZiBefz8SUzNa3ysB7mMzv6KNpzkmeZy26Ft0nJKXlAdI
	LGIMkuTlTuhWpwGq+iUPPFJZGwmsaIcacAuPHKtbydGb8fMg9Qn2VFgFCHWzcJIr
	hOtiXopV2xoyALw4g+HdLly4Q6aNf5WVUFlv7OLQ4dOcnefjLxkAE3nkOtWoYzrA
	IWCKBbAer7qUi/Z+mfjf/XYTN9+BXh3R9BMl6bYB87SZXzITBpRTGRKmRXLqECkh
	uJMb/BZ1TBuOgjtGIVrUr32Ldzrc1DeQORD3yJ4jSW72kbrXUVCkQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q557xk8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Aug 2025 12:49:37 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57QClRbG014723;
	Tue, 26 Aug 2025 12:49:37 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q557xk8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Aug 2025 12:49:37 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57QAVQGI007514;
	Tue, 26 Aug 2025 12:49:36 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 48qqyuax0s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 26 Aug 2025 12:49:36 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57QCnWOW48627974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 12:49:32 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7375020043;
	Tue, 26 Aug 2025 12:49:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3056920040;
	Tue, 26 Aug 2025 12:49:30 +0000 (GMT)
Received: from li-218185cc-29b5-11b2-a85c-9a1300ae2e6e.in.ibm.com (unknown [9.109.215.183])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 26 Aug 2025 12:49:29 +0000 (GMT)
From: Donet Tom <donettom@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Wei Yang <richard.weiyang@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH 2/2] selftests/mm: add fork inheritance test for ksm_merging_pages counter
Date: Tue, 26 Aug 2025 18:19:22 +0530
Message-ID: <88d6d5f08ff119625fa9accaa7b849dd77f9df25.1756211338.git.donettom@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <2e662107e01417bf9af23bc7f52863cd538419be.1756211338.git.donettom@linux.ibm.com>
References: <2e662107e01417bf9af23bc7f52863cd538419be.1756211338.git.donettom@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VkolPkvh0DsD7H5lXlA_g6Umvua8Zct4
X-Proofpoint-ORIG-GUID: vWrApFb4qKyKmWTUoxuW81NgIsitET3J
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAyMSBTYWx0ZWRfX+VxFFVNdJwl4
 2AVY4r8Aycp0hT8Fv3v5EEMog5yTYcFmj08ERY1G+7kHPoG1EOInsASwjaUgsU+RqGxjW469Qh5
 BVll4w45+mDSf9l0Wk53ekNYqXfmrOOLwXEZBt/VoYKwppG0C+8Bo/W/I6uGkrRdl2n43f3P2Gw
 z01EpUMVkMeccByikiQHFkpNEC0kUXeXo3Z/hJebPWQSnl2i7sIMn/xphIwd9wfGu7ipWm5BO76
 kKPD0KA2jEO+gXr/1EFSqjy47W8rGS7i1le/xtp9Bm7EyoQJzj3oRlVXJ5Cyt5zEd1jnT1rXdPT
 6aTd/mOZP9py9TNQtjXyp26tnC6OQ+dJxbIDkQ9Wsuk/jmf4OS1skcqgg/s5Hvwn0STrI/jXiv0
 nVpOhPWB
X-Authority-Analysis: v=2.4 cv=A8ZsP7WG c=1 sm=1 tr=0 ts=68adad61 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=mq3xLqhzurGmh3fbWqMA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 priorityscore=1501 suspectscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508230021
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 095FC40008
X-Stat-Signature: 61h4pm9uscuz8rybhg3ry3inif6emewy
X-Rspam-User: 
X-HE-Tag: 1756212586-449240
X-HE-Meta: U2FsdGVkX19Z6ETC8tuHLL/7QnTb8OUsg+n9ZV2c5wGOIelPqMJOFIgHtnsBRbtRVxWR+NEInKi2NfZYiW7sV/ocnHRrFAAJChD/CX9ARZ5MX+IC4SQsook9ry6b3uVvu2TKZE5HfygNZHVx/t/GDnauNRXX7UrkqChfUdcOKCHAVBivepFUEQQi9u3pHdmq6PGFuCbaTFY+ZWnoNv7awV2n/jLj/sV7zNxuyBYoMfS/x3bEJLfL/n01gYxCI2fhCGWFbVMoHazWDZujRu+fKfkirfohtWTXdSj05BPd+aTeLYa4Po8jJDoToZI5AqVMY7nqHIFxOGeGSqtkL6zX4Z03WxC/m2WL8j38LPTF5azD2Fu2rNsx/1DQNyQbOvLA0sSVyEz0Lw95EoUlbgXEto1sgxNAeMsFBNzhBycz2a9QCk7ibrVq4nsu9Dx1J9+b4ek7Vc6NV3YyRk4sFS8mJ+fQ8NaF1ZX4LZV+cKMrys3zgBM2StHHJ+rxqYbjyU2yYK/8T7Ip34iBf/2DfL5hU4o8tOSmxyCRD9wLzB16p9KJGx64MGDmWwHXz5vWAfXO+6kVePDa1n5/s5lmgm3lhFwAr+C2qqbSnIoYkpGCb088u6GHZWgRoF8HoRVKT+B7mVsO5A3wj2GYEYcd+tv9RLeftHLzZtKzszJ2L4bkruPG2z+9In6PFRfky5Yf8x+I0YtsxPolkmicr9UlgygS6+7+xutOI/JBxskLwJjmmIgKETbl9lr/7UKbLk29qqiC5DBNz9LHpzZTWGr1nRL59sxV/XjGhuJ9xt0anjy0I4qsaS08/mRKYipodn5TP5D0DLdCQ9mToAJxnu+73FgWB+RDoK273JW0LYzIQm0r5+EUUbhEMxqIPJyw+iyksIyOUfxs0kps1CT+B33ZRR0dTcet1BpXglKuLK8ySjRlMmrS8Y/dJhldG6Kb4R6dVXUEJWCWTWHA52P1qOa0u+q
 a+X+E9SC
 69W87It6i5MJpKE8aXQtcfAt3kbE7VicP5hITLPuUPViBHeM7Jm5lvvqfOKQzy+UdCORfUB6l3okjL/xiKecXf+aLdwy07kqksq6heqYN/89S+5gOf/vj6Z/INcQnHqRE5vc1Asn8hRcdkDtLxQeIz6R08N28bi7b3JTZLzB0CrnNq1LJkXzNWpza6DTvVc450P86meUrOJ6zTJeDKNzX+b7k2JXSeeXU74kk8v5+7Jr/u8M3e/lc56FeDlIfqsvylXs5L4SAqB9iryJkCeF8iDiGPEJA1Bm9bwKVeJqZMghuGGTahHegZ21IuMV3d0DGqUhGFLFFknQpzNRq/vKwCEd7pqe8DgdQwomhZmihTjescVv5Q4TMWyZ3mzm0b1lHWrMV+vEfQsKVXJeV6DrB4rJx1REeRCEUGwOyxbfWKBCClpihP67k3t0BeiMXH01uj6X0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new selftest to verify whether the `ksm_merging_pages` counter
in `mm_struct` is inherited by a child process after fork. This helps
ensure correctness of KSM accounting across process creation.

Signed-off-by: Donet Tom <donettom@linux.ibm.com>
---
 .../selftests/mm/ksm_functional_tests.c       | 42 ++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 712f43c87736..d971394c9567 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -602,6 +602,45 @@ static void test_prot_none(void)
 	munmap(map, size);
 }
 
+static void test_fork_ksm_merging_page(void)
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
+		int mpages;
+
+		init_global_file_handles();
+		mpages = ksm_get_self_merging_pages();
+		if (mpages > 0)
+			ksft_test_result_fail("ksm_merging_page in child: %d\n", mpages);
+
+		exit(0);
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
+	test_fork_ksm_merging_page();
 
 	err = ksft_get_fail_cnt();
 	if (err)
-- 
2.51.0


