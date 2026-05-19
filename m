Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA4FCCD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 04:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52D6B6B0092; Tue, 19 May 2026 00:06:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B7AB6B0093; Tue, 19 May 2026 00:06:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37EF96B0095; Tue, 19 May 2026 00:06:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2604F6B0092
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:06:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BCCB2A0198
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:06:47 +0000 (UTC)
X-FDA: 84782833254.14.2496BC1
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf23.hostedemail.com (Postfix) with ESMTP id 77DBF140005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:06:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="X7RWxTb/";
	spf=pass (imf23.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779163605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NymUJvLzenYDD5zRePoXoHJ8ghSJOU8eRyvhNSKbHoQ=;
	b=jI8Tw2MNw7mOCDO822SJrlx1uDtpTjv5+mNmLbQTgSIXBMx1LqujoQtxXFA182kpZqS/rx
	9jfeASxXTDb/NtTg5ddT2HWoQwwdnZBoah6Ih/VuhSTkaCi5wM11fiZsVRmhRUs148mTux
	9/kjagr58a7wmCix1TU/u25G5gGtgLk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="X7RWxTb/";
	spf=pass (imf23.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779163605; a=rsa-sha256;
	cv=none;
	b=ZYes1mkqe3fsWJ/P86tPm5Rx1srqta9seHb1808tbg0PeVK9SSXZzJZF71DRkk5G9xQfPp
	tYYGC4rgholV2p0Zmmj9XlhtTOEZI7NigNl4WpaI5aUjIrBkZlILA2pvDNAFQZdgWYQAyY
	gv+QYlTwmVu/4bJOqlbSCGl3PinL1Y0=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64IG2ZeR3252234;
	Tue, 19 May 2026 04:06:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=NymUJvLzenYDD5zRe
	PoXoHJ8ghSJOU8eRyvhNSKbHoQ=; b=X7RWxTb/IIRgzOKExFLMOL49vQlMw2arb
	3K7YBC/tyAyQvzMNeYkLtCl+KjWoHepMCxKlT9WEh4lF3O1M3lapOJae2SbG4Fda
	SsUcgs8817bABXAn7WO9B32OfZdG6+d3PLz0LLkjSpCKVpMLbViyp3aNUk2ikLMP
	h5Swj7nJpQUo7mteISEUuPCkgXY2VnIObicd1RUjbmURJ7iYuBuxrHWDA0VaxTeJ
	N8pVldzFK7Y4xdIGEnNZHG3L6R8sl05tKMYVQql7zXum06sUPEDJpOxMPvDyn8/b
	snl71fU+gr1SZH0xfZD/LA1aEP/afPPLKtrmaxq9/KM4NoWnOYYJw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6haw2fsg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 04:06:42 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64J3s8h5003315;
	Tue, 19 May 2026 04:06:41 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e754g8nv3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 04:06:41 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64J46cBF25690604
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 May 2026 04:06:38 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 18DCD20040;
	Tue, 19 May 2026 04:06:38 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A02E82004B;
	Tue, 19 May 2026 04:06:35 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.39.29.16])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 May 2026 04:06:35 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Cc: Sayali Patil <sayalip@linux.ibm.com>, linux-kernel@vger.kernel.org,
        Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [PATCH v2 3/3] selftests/mm: fix exclusive_cow test fork() handling
Date: Tue, 19 May 2026 09:36:24 +0530
Message-ID: <ff06c54ec2cd037a6d9a0d65cd06e4c37cc0b3a8.1779090293.git.aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779090293.git.aboorvad@linux.ibm.com>
References: <cover.1779090293.git.aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDAzNyBTYWx0ZWRfXxEs+blJ1WZGx
 jURbBeii+KyFGA2EtQjYPq3ZWwJcquIrIwLGhseHfERxTuclaUa/0+CCh45MTfY0hkEjhnGG6Eu
 yM6r6/PbBaKHXHNv8/VxVWVgn90DZ+afbPw65djXjiz4LKTPMJvnmjoBBLUYbMJ9Vr0324B/G71
 /1CpWvMps1AJqi+llWJ0+lVpAkwNKJNcrH6p+rwg789GIxt8+N+UdZ2ENp3nP1k/d29oa9pB9bK
 r1d+hwYNGa23EJcIJ9onwsiQ358dk9vtVxHAObjR6hszdSr6jFYooqMXFWyC58P6F6OixIcSJcB
 IOuijACqTzkCNFrxzsRjtWGj1gE4wSMBh6HKzEI2aOzSTnfPliXBpjMbGKLsTLDXSEJeyA4f0DW
 nlTmnRAmSb+4h8TAhJLjKdOlRAMGWdiJrkmTmG8Wf0p8Es1tLqTKoc1+4iFbrTjgiRyzaphwybs
 cYK6IoqLLwxoSK28QtA==
X-Authority-Analysis: v=2.4 cv=Np/htcdJ c=1 sm=1 tr=0 ts=6a0be1d2 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=V7PHP-YOonYUhVqbgP4A:9
X-Proofpoint-ORIG-GUID: tSqefxWkmupUPinfPcO6y6YwvePycbTS
X-Proofpoint-GUID: tSqefxWkmupUPinfPcO6y6YwvePycbTS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190037
X-Stat-Signature: 4gn8f1x7wcxgj645u5emnz4izeipboqu
X-Rspamd-Queue-Id: 77DBF140005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779163605-206266
X-HE-Meta: U2FsdGVkX19use9m70dHe3tBiqE0JNyiJ33X0wnTp4PiuqJKNTPLPLXITTOySW5yC2UVeIxgO7KGcqTCyuRC2oKW8zUdS6a7d2I3XcgmMaoy+nYDWbvPbGohO6d3YrMQ3TYYE3jauC7AsX1ZRIq73O5Hx3AmvEta1gJ/Wi1RRFrvjbixADhfWvMqFPecIlMpvswuGFeD7KJoJfx87lry4bflLHs+wXrAIkgmq1dywYLzcWnwuVA6sbvwSR2ik+wFaiZGMCfcy8kXOiG/0rhob02qR2eltrjJCGVseAiJYTtZSlNgOLBg6uFp0zocihOYqHLvd6Q5cz1RLOnc0dycIySQk2JfghfyIHSSsKRDyQc8IYwVkTVXvW17FmegMpeZBKoejzNj2xi/58ptTHoKY1Ug+7zgEf6dkROW2CqiSGRsahvhLbK+nDpjGCVYpgA/hCsry1ntFjXkbHrAc1pOc/HyrBud7gqmOGcVQ1Ke3CsDiMFLl5SL2H47bagzpwYtdnzB3btvjCjHx/mIJk8y5vHDR6jywFUZCcpGIAGIlKLCcFkkIFPbXqWOgBQMab7rZQHN/LzB8KRbEjvYBCGcgiG/nGUdyoU+byiTq9Ik83sywLkQ6ILUKTL76cYIJZaLY20CEzJQFO2SRRGIzb92qouoN9gh7Vquf5aYQAsFj7o9jkQ/3qGYZ0Mug533f1netLUSBGWBYjcoN149LlftZW62vkYKc3mlXHwgpFrdy/4b+u9pv8XzkZblc9R6bFvfFg7ht8rcgCn0oYC6vHao0BSd6bkcHqWPHCyDiwG1TA7OJvvoujrw/Tnkf5E2QWztKlXEFoUfLL1j2QerHw5+bsGMvHVU2jGhbJo3+qH5UiZTTuzYfUm115U7AFOdlEcdAyqlgl1K5Jx3kAT95xIdenzS1qna93Wf0biSD88bO3BoUgGjuXTnCdnsqAlFqBWBbO1KrJNDQIey+1NcVmk
 lYen8eiM
 ynBoe/YRkVARJuQkqmBEhIxJKYWRwGpQJVnEZqhgiShID/FfVTHI4uaLsg8DbKMub06yp0s/elQ3d2xbezYfPRJGMVvm29dTs+wFL11QOYwdpZG53D0FaLGj9sXgxUzLYgiJGkVIGRo2IImD5wG1eQ8UBFSllyAoG4eWcLKxrPXZMMisykRxlEunHFcevyQ5Ep2VwiBQFa+LXpWEuboE+qGyZeiTa+UCz7FfhFitHbGg7sRIfIVqhyGDBbanVDQCwtGkQ2aBXMjT0grRwv74sEwCcr95dZ+tAgo2Nc14oW6fOrNN35AyxNTjhFiXCKvLQkTaUPOvBMulI5/T+cg7ZLG1AVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test ignores the return value of fork(), so both the parent and
the (newly created) child run the COW verification loops and then
call hmm_buffer_free() before returning into the kselftest harness,
which _exit()s each side.  This duplicated teardown sequence has
been observed to manifest as a SIGSEGV in the test child, e.g.:

  hmm-tests[360141]: segfault (11) at 0 nip 10006964 lr 1000ac3c code 1
  in hmm-tests[6964,10000000+30000]

Fix this by adopting the same fork()-then-wait pattern already used
by the nearby anon_write_child / anon_write_child_shared tests in
this file: the child performs the COW verification and then _exit(0)s
so it does not run the test teardown, while the parent independently
verifies COW, waits for the child, and only then frees the buffer.

Fixes: b659baea75469 ("mm: selftests for exclusive device memory")
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
---
 tools/testing/selftests/mm/hmm-tests.c | 30 +++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 1d49d9e919c1f..48834e7d1d984 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -1868,6 +1868,8 @@ TEST_F(hmm, exclusive_cow)
 	unsigned long i;
 	int *ptr;
 	int ret;
+	pid_t pid;
+	int status;
 
 	npages = ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
 	ASSERT_NE(npages, 0);
@@ -1896,14 +1898,36 @@ TEST_F(hmm, exclusive_cow)
 	ASSERT_EQ(ret, 0);
 	ASSERT_EQ(buffer->cpages, npages);
 
-	fork();
+	pid = fork();
+	if (pid == -1)
+		ASSERT_EQ(pid, 0);
 
-	/* Fault pages back to system memory and check them. */
+	if (pid == 0) {
+		/*
+		 * Child: fault pages back and verify COW, then _exit().
+		 * On ASSERT failure the harness calls abort(); the parent
+		 * reports it via the WIFEXITED/WEXITSTATUS checks below.
+		 */
+		for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+			ASSERT_EQ(ptr[i]++, i);
+
+		for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+			ASSERT_EQ(ptr[i], i + 1);
+
+		_exit(0);
+	}
+
+	/* Parent: also increment to verify COW works for both processes. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ASSERT_EQ(ptr[i]++, i);
 
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
-		ASSERT_EQ(ptr[i], i+1);
+		ASSERT_EQ(ptr[i], i + 1);
+
+	/* Parent: wait for child and then free the buffer. */
+	ASSERT_EQ(waitpid(pid, &status, 0), pid);
+	ASSERT_TRUE(WIFEXITED(status));
+	ASSERT_EQ(WEXITSTATUS(status), 0);
 
 	hmm_buffer_free(buffer);
 }
-- 
2.54.0


