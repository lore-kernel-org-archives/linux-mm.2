Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21A23CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 03:42:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E9EB6B0095; Wed, 10 Jun 2026 23:42:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79A826B0096; Wed, 10 Jun 2026 23:42:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B05B6B0098; Wed, 10 Jun 2026 23:42:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59F8D6B0095
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:42:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E7370402BA
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:42:00 +0000 (UTC)
X-FDA: 84866233200.26.4622D2A
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9051120002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:41:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Jlzkl5Xy;
	spf=pass (imf31.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781149318;
	b=jjXFzZX8vBdbR11C7LVcPqm0N4jg7y5zwLoANVbLO1gTaVmKdzakqA6KznFA//3qX9u4c+
	wqlTnaxjtrloUpmiCgbQzSjqoPMgGduQLCSwlyD6IZsAnxmUVEoN0P1d8LoxaiF4pzAH5R
	GiKw3I0pc2TgViJLflTZu5Jpc60uI0w=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Jlzkl5Xy;
	spf=pass (imf31.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781149318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NhRSo6Z/W4jD3irkbV2apRuLXcxRfq9kkdO+okO3Cxw=;
	b=8Ua+/Y+FlKBgWW0WrIWeqTQr7e/YYQBsI6whwvYARFtyKUzkFS0GD75Ek4gl+pX/jeeFuG
	gu4t5dRDsi5aPNzH6JGKqdlRAhefiACz7GXFwEfaqHl0KOHJYZgwOdIvmhoOMi8w33zQwc
	e7UkSirD0kz1BS/bEQhCz9ieE+OLpik=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65AJu3op1741881;
	Thu, 11 Jun 2026 03:41:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=NhRSo6Z/W4jD3irkb
	V2apRuLXcxRfq9kkdO+okO3Cxw=; b=Jlzkl5XyMkwM9GervKpM1nrFhbWDSq/FM
	rauRTRXeLZmmAK9w/NnVvDb+ru6TTkBd8TNTB3WuerAB3RaHwjep9YDEcofxUamO
	qIBJ1mDtd5YbyZHtk1wUxylVv1KI/PIhz9sRX7UEsctfRz3pNKwLXzVzm/Y6wr5/
	VPqh/fGHygiycvMqsiynVttkRk0fMF9vb1zhHqY1/RE+476Dx4pOOZYuAK0JmSSA
	zqhizDcNV6XoPLAcaO/MieLCF3N1U0M6iVTXmAmRSBpwqI9J1bDRB0Ebxo0pv809
	5Ya7OIGvEugGiyKYBzJW146439t7UC87zY0UtyTJAVHxVDvKYVo/A==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eqe8bh80w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 03:41:36 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65B3dAjQ001974;
	Thu, 11 Jun 2026 03:41:35 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4eqe09hf7b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 03:41:35 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65B3fVk114942694
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jun 2026 03:41:32 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D4E2A20043;
	Thu, 11 Jun 2026 03:41:31 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D47820040;
	Thu, 11 Jun 2026 03:41:25 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.39.27.36])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Jun 2026 03:41:25 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R . Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shuah Khan <shuah@kernel.org>, Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Balbir Singh <balbirs@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Alex Sierra <alex.sierra@amd.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sayali Patil <sayalip@linux.ibm.com>, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [PATCH v3 3/3] selftests/mm: fix exclusive_cow test fork() handling
Date: Thu, 11 Jun 2026 09:11:02 +0530
Message-ID: <20260611034102.1030738-4-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260611034102.1030738-1-aboorvad@linux.ibm.com>
References: <20260611034102.1030738-1-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=Xfa5Co55 c=1 sm=1 tr=0 ts=6a2a2e70 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=qerImOSnxKlIG2EQ76sA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDAzMiBTYWx0ZWRfXwuBRMA9ofurN
 DRF9/IxvT7YfjGofRDu3rufKRwBD/EFBtft/ebk+6w3tHTYcUueien8y4OX4twbkGaaluN5AmAn
 zDomrsbKg/RVhlAht7kYRLV5zeZTc+//H5quTBJsJMmPuAkS/JSMEjUZ3oQn3/RKbxrBmFoD4V7
 HpL0iPmy1RbIp+Xh1o+XUZs/bIgz4RCGl+NWwdvX1PbyJgZNtLoklGEFabBJ+THs4lXtkSdGFdV
 hMvoUE/GKK4PrLxjg1urjzD1dkD/o1DgmZl244bohffeQLRB079kPGzUtfoIMKmG7OtXdijfJmz
 XOrNqMX3iVvL2CdPidhljgQymQs2rg7hDkPTF+fjysrgAw0SD8g+8poZVNoP399e06sULab+Yi8
 n0re2BbHaIQ6lGk5WPlVTcpBxgVgn11v0YuiP8BBimmqNGeaoHERIhyJmX3grQOTA6Ilh5FgxGR
 mAJ4YEaZv2QJVroaxeg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDAzMiBTYWx0ZWRfX23Z/1Tm6Hdq+
 n67wZ+D4GD4hpN/3qZ5ji4oLyp7WxipbR0m8fmtJGrX1HBbs5dK+u5+NRucy4Syfxv0wOlELfLA
 rFLyjtJ1mPpe7sxAMabF0hQWXYPesfo=
X-Proofpoint-ORIG-GUID: 0LkASIrnKhk4Zh6sHYbQn9nK8TJmjTT1
X-Proofpoint-GUID: Q8hGwmMOMMTc_3yFvNLksDWfLZ7DXacl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 suspectscore=0 clxscore=1015 phishscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606110032
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9051120002
X-Rspam-User: 
X-Stat-Signature: wkjjyyjip377be4ft7wz1ftkajqahtcn
X-HE-Tag: 1781149318-468776
X-HE-Meta: U2FsdGVkX189umu49dlpVXnP4Df+LtkZtayPikbKSvq8fFeqNl06qfzVzgc7Fo/3lB0Ihikt3R49k36HeSEDn13amvVDLl1GPi4J+BTpsi69CLVKRCOXwHI5K2lZWU0RuRoEfOZGLlFHh0w4SDaVKBFNCVX5IA7V0oD/SyvD20qKUx+alzpZzC8AhqopXQChkq2kElGIevRavpwTl26NsPqcfQkGKX/sdodetJC/8FhFVKlsyy87u/jtF6J2yvNW8Mkf3Hj7/JfH7RoimwDi+IqBX/V1CpizREh48CyPB6BzY6iRF3QxXi7GbAIceHnZjvZllJiThUwQi7HVacvzJtlfPsBIs5RGY2mzil+041WEpq2Rlh3sWfQYPgMUSC3SoSrqHqE9SBnFs8pu5DheOwKVwN00Ry9O8KzD42fsmU/m4yMydO/f9rfjoAJzF7n1KWHHxhXxJCcxO6dy5qaZvv3ciaBn8XhBb0np0L7jgtM/BJS8JPY6Quba9eAqaPYBwfdSwEQ+hfKSIAUDTcnF+yWvuyn6uxsxBXyYzpB2p7p+t8rZ6rEVXlEr+cmPrmPbchcY2UQ5ts6LfRkX/KQEKEfm54PnRNliAFVZ+WYj2EspTXoeJMXydelo0KOSbehYARny7HIsDLYjMW3T5wgcYpMPKDgW45ZphteHbyUT3hsPCJ7r8QqrpraDL7EMeEoaPG330UZJng7xJvOGryyniVJbxYyjpmSyaea7PFzO9lpN6erQXKZ1M2r8eqRmopS7aB5vbUEkeaEIg/2r64Pqr6NHMcsOCxq7NMFkVau1QeYB4DzxuLrr6Goo3W/GApsUSL9LLtUiK+RAxE51T+6oy/M6E2kSkT35Jpldenoau91RW3r929LxE3Imc8SmPYtp0C8+uE4J1WCZ2GZsqFL5jKPXZIO41/78XQ5hfGmye2hKh84GVUTsYrabrmcoDryriXyqgHkK1HP2Mg33wf5
 hg5nrcd1
 DDgAvkwFEmLwd9Bn40xTZjeyg+L/SwZ0PpTrszgVA5sU0II5NfMiPh3RizBTbVvTI3J51FxI4H61fNWlrTJi7L6iXlwjVartloFAoo6qVKgP/KzZi2cSdFH7vgRPV6B/4Wh2a790o6nv2HyVRCEokIDNQYJpeIKOOfiZpte7jpuwffv/ECsqLYbCQsKZYnUUNNCb8Dws67x7RG1mUSev2tQmxszW8O4IhtKiK16/vr+0DYSIIEa+/+Mc5jC6UyK2wdXtpT8lg5MYuFNtLKatei2Lf8/670FZLDNnAJCw779bY/mgybdjUxqCBjirpKHaqT7HCjQV0e7Of/bSmyN0pV0ua8w==
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
 tools/testing/selftests/mm/hmm-tests.c | 31 +++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 8f4f82467043..e4c49699f3f7 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -1884,6 +1884,8 @@ TEST_F(hmm, exclusive_cow)
 	unsigned long i;
 	int *ptr;
 	int ret;
+	pid_t pid;
+	int status;
 
 	npages = ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
 	ASSERT_NE(npages, 0);
@@ -1912,14 +1914,37 @@ TEST_F(hmm, exclusive_cow)
 	ASSERT_EQ(ret, 0);
 	ASSERT_EQ(buffer->cpages, npages);
 
-	fork();
+	pid = fork();
+	if (pid == -1)
+		ASSERT_EQ(pid, 0);
 
-	/* Fault pages back to system memory and check them. */
+	if (pid == 0) {
+		/*
+		 * Child verifies COW independently, then _exit(0)s so it does
+		 * not run the test teardown.  A failed ASSERT_* here makes the
+		 * harness abort() the child, so the parent sees
+		 * !WIFEXITED(status) below and fails in turn.
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


