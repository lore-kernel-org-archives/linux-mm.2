Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47054FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 09:11:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CA876B009D; Mon,  4 May 2026 05:11:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97AE46B009E; Mon,  4 May 2026 05:11:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81D2F6B009F; Mon,  4 May 2026 05:11:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6326D6B009D
	for <linux-mm@kvack.org>; Mon,  4 May 2026 05:11:28 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 31BA68BBBB
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:11:28 +0000 (UTC)
X-FDA: 84729169056.17.2061DB5
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id CBCF21C0004
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:11:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="M7Guab/h";
	spf=pass (imf21.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777885886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jm2w8eq1FHMdDz3aG4TKoSi7OYPVag1/QptiIakzkcQ=;
	b=5yDflZV1EaYdltZuUggqKXmkgQ9rJtv6eVAuoH66g/IqM3fPpFM5zhme1vgLDOGHhVFQrk
	Vf+abBibbr0VagsmXhRWOjrnOeZkNJNCPtVGAmnERAm+uBL8U28tEjJ+zgMVkm/MlGLMMw
	gc18t3kNQwMQ1R21rryELxXF1Oj0IMc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777885886; a=rsa-sha256;
	cv=none;
	b=NhCjau0Dc+ycS60CkKssxBYVz/b+kwJ3aPwWQSRxYA3X02LeyRdqaCJ0/s0tvWwZ8OCVD2
	CbV1kJpoOLClMIkmBnybAPUP1+PoVNFIiRWpI/4j1+KZt6BiWQYp18LkC1xbxxrNd2+66j
	VMDwu9IsKSMttMAUS3IOO7AWC3a0zxs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="M7Guab/h";
	spf=pass (imf21.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6442tF7G068020;
	Mon, 4 May 2026 09:11:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=jm2w8eq1FHMdDz3aG
	4TKoSi7OYPVag1/QptiIakzkcQ=; b=M7Guab/hF7A18bW90wQmaYLM2oR1SFL80
	arCpJhW27YtIXqUzxgWAD1g040yZWIpkg5x9HoeluqxcQWPlH1ISxmid6cHc16cb
	lnHgeGQA80Hih+uslLry7N9XR4TWTDtbekEbAhfcNm+cr3MTWEveDPzWID8Z/G5F
	rYWxEKKgyc3Gd5OqN4i7K4NnEoVDw1VjNfptrtKU5FrtvNpqcDp4QjEkmd9VYQ7C
	h6QKLjrvr/E0gtMuoZcMRFl/FL3p1brmdZ9WMDfUo10VcVoU/on/qJAnbNct/GRL
	jEMZFl6lBAiHyYSAYqCqQKg5x5m6pUseBjHZ8UH5T08CP8Hm0JwOA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y168ru-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 09:11:21 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64499V0E025969;
	Mon, 4 May 2026 09:11:20 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwx9y472j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 09:11:20 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6449BHLM30605840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 09:11:17 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 326012004B;
	Mon,  4 May 2026 09:11:17 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A058720040;
	Mon,  4 May 2026 09:11:15 +0000 (GMT)
Received: from aboo.bl1-in.ibm.com (unknown [9.123.14.187])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 09:11:15 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Cc: Sayali Patil <sayalip@linux.ibm.com>, linux-kernel@vger.kernel.org,
        Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [PATCH 3/3] selftests/mm: fix exclusive_cow test fork() handling
Date: Mon,  4 May 2026 14:41:08 +0530
Message-ID: <f3884dcd77212d9a9f3498f0863f73ce861897cd.1777870179.git.aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1777870179.git.aboorvad@linux.ibm.com>
References: <cover.1777870179.git.aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: CLrEPZepVvPWW--8jC581KAg740SAxfb
X-Proofpoint-GUID: CLrEPZepVvPWW--8jC581KAg740SAxfb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDA5NyBTYWx0ZWRfX7828XjCc7lDp
 W8qiv4I7CvqzBOmj/pcjx0dkovueJ/A9+xgYOCoCwlsC+YoB4oKjwjrKNNrHTiYcJEm0BUUsjlh
 pkIaOOhPEy+t/n8kABgOC3+DftyLjCiwpNUC11c1fJ5CucRN7wUj4X+m4c4CEHlgFbl0hPMEIWg
 dTWx1GZ30G1ZUS+IqWR/96+6imawGwcF32NujWVlWOMht7C/eq5jdJydaOGRsMsef9qreffaGya
 /2fKwqcZZiwQzoE4jJCIKRTPWfHRRCHJQF9Puwx/AbL4GtjP0HvwFHMUKZwgkkFPDxjntAHvn87
 WewUU7C1VN+0NGzl2bZOx4Xia3xIqpho7ptYiZGT5KAOB4yM0w80K+qIQOKhlFsawAxE335+JiW
 XCbTn0h8TOFffsQyM1ACwTuD3qwKLJwakCwuyqS1m+X3zh10v77+aRmHkn4UVIOADN7yIi+OGB9
 Q+sHi9QHCXs5amEwBXQ==
X-Authority-Analysis: v=2.4 cv=UbFhjqSN c=1 sm=1 tr=0 ts=69f862b9 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=YKbGnN07TdQTFoDUIKcA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605040097
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CBCF21C0004
X-Rspam-User: 
X-Stat-Signature: b8n4arx48n8j7t7hk4rjfdwemk6n14sk
X-HE-Tag: 1777885885-803782
X-HE-Meta: U2FsdGVkX187ZwwzXFNS5PVq/ubaaYH2AxzrB1g4YI94k4bOfDrPhTwY+WDHc61UsD4J6up0nt02ZYcvHI2d+9l8ZHlU7vXqp+w0ois69cPI0x+HmFmoCSo5U3W9PJdGRB5tm/0NEhijGM4Frjxhvarz/s0wDU5xPFJRrJWi5ylo0uX/QpFYwcL1i26p192Efm7CxSJ/zXHWc08lQXlkjnRQTaeipnW8//tAcAdlNmvopdQmDAKRSztaBrvvKZfAxMJZCA2ODJZf8GSAr17Qw62FPkwVk2/qaWu7NIOagp6ZTkgbjuDN+Zn28FipUu1ghVE1aC3T3C7id88lkx2L3OIuyqidyBT/l127X21p4wzkg7SY2zSW2OKOyqmQuvpwIVWvupUp9hGXQRdpZN6U6lUF1A5+e6byEtEZscVMV4D7v8ZDmA04bhIFSiIOKF2xp/os582UFz7wip9GEd/cG6kQ6qdtIz7kXuXSpNgDYB9Fkja1yF5AUPS/UbUaDBJNKH7i386i6rTmaetY9cx8fthegVRM8mhuQ2syFjziMhaapQogVgUWlqw/ETNE5ipER6eGqix4fwYp+WgbhY3O/8iQWNnSF9WJHfAhNqOzieYcG6P1vbL6gyAxj+8IkCbS+//nSySJfifYwTGOzTxNNJR1nUB6pXGm9zQIJ5ChBXmlg2BfNHC6fF9do6alvEVkG/t5mLavClEJcf1uaCoDJhUZTwqs91+6Ba0DBvg2B98DgD5Nb2bmsOapCu0N92SMah3Gd0A4aHwtUHMEKlkZbLDpLwvtFYZ+v/vRZ6DaHJH5WSRaIdFCNXXnAfe/uG9gmnuOCO7V0VbHUVycJvP+s1LMplDp/t+ocWoxoPf7i2Nze908AJcJBmqpFh7gcrUk3QJ7B5YWaksaZ8h3hrfWLXDcMQz35CcZqu2aPLSmtmGjrflyjNwFVjCyl6YwBGCZv9YiZ4+9xNSBqtIQYfZ
 TqnOkOrN
 9hlLcA/P3Hw+7UnSKC7huhWFgoj31NszWuBs6XPay5t4SDzvPUHnmx4k8Tkv3qAHYQTE2BAwM/VQ7fC75sam7MWH9IgldAyEUWgvI3O+dLi2Or5qey9bfDztTiPbBchD919VgPxUifTQtMEKd07B2k5X7U9EVZg93AtP3iJW2wWkOcGaPUCZdXTl+Wtk9YjZclhfsTDa3lTJMuPyDg4r8JdPF5gcf30ZSe7/OCYCcN/b5JDedmqmkh2xk7/BUunDP2TAliwv5Cql7+96YWqSFS8giX6Vn1kGhQNsSVUjVaHB/AZcxWerF+HAY7TIHIymL4JpBRcir0ypTYyNH5UB4P1bnww==
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
index 1e5c1432ef6b..c5000d53b604 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -1866,6 +1866,8 @@ TEST_F(hmm, exclusive_cow)
 	unsigned long i;
 	int *ptr;
 	int ret;
+	pid_t pid;
+	int status;
 
 	npages = ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
 	ASSERT_NE(npages, 0);
@@ -1894,14 +1896,36 @@ TEST_F(hmm, exclusive_cow)
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


