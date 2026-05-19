Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B468CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 04:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A17F6B0088; Tue, 19 May 2026 00:06:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94AFD6B008C; Tue, 19 May 2026 00:06:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 813236B0092; Tue, 19 May 2026 00:06:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FCA36B0088
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:06:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03127C0841
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:06:41 +0000 (UTC)
X-FDA: 84782833044.14.D848B5A
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7A72120009
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:06:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=YakKxjLs;
	spf=pass (imf13.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779163599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/no75CjCoHZVTQnMBvJ5i8x2moctRIwAVIKf9p7T694=;
	b=dYajL8GL7vuMaZldxPDUH+KxXDk+ckLjgThKiZzgF9Jpf61e9wm/hp5YWh8IR8+Jt7WEIC
	Htrkd7l57xOz1hWWsqlWqVG4q6YarOD4tGQ4zwC1TmBJABi2dtpfFBpUnYJEupOLKRx2L1
	g/IIBItn3BoW/1SbsOFQFQcbVplaFzM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=YakKxjLs;
	spf=pass (imf13.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779163599; a=rsa-sha256;
	cv=none;
	b=eO8Ygk0dlzCARqTI+J8baCMAffVGscccuRlYCdMCaGWIjk3WOZXB4qk6e7JM/ZhEqRFdgP
	Ak2iiKHcIA37nlr76/CjSzjYxkvUzCJEXh0UqdqWus9qhAkK4tEb2XBMR/aSUj2QaUkKdo
	C2Ur//g3szgLBUpvl8Ok8WxIP+jvfzw=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64IGOaBF3991718;
	Tue, 19 May 2026 04:06:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/no75CjCoHZVTQnMB
	vJ5i8x2moctRIwAVIKf9p7T694=; b=YakKxjLsXRk4rMlpiTqWykYUyK8H3L1GD
	PJPmoCHwlWl0mF7F9qqyfrP76xEx4vsIgmPySS2AF/CMSYADV4/SHAt0AI0Sbo/j
	n4o8XJN0033t1HMcsd0jms/m+pA71wLiee91ipGYYFyTbixHh1QGLMf9EhII8uPv
	2+4MhQDu/32qaW6kEjAwHt9dzSDY0ul9B7KG//A/J4a4xMSw167JHUFASlvmXzaV
	GNUYfeovZvwi1QfY3MTiIynCOHnOLw3MBHwaI6yaHHNxrJ87UnNHydbaZ98+sj8K
	8JJlaALXE4lcvJLqwXGAc74cs/P0c3xi6zQRHZGdvxjwQsdQgX7qg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hb8affa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 04:06:36 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64J3s9cp005996;
	Tue, 19 May 2026 04:06:35 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e72wq1387-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 May 2026 04:06:35 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64J46W6o41943530
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 May 2026 04:06:32 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 127992004B;
	Tue, 19 May 2026 04:06:32 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7CCA520040;
	Tue, 19 May 2026 04:06:29 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.39.29.16])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 May 2026 04:06:29 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Cc: Sayali Patil <sayalip@linux.ibm.com>, linux-kernel@vger.kernel.org,
        Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [PATCH v2 1/3] selftests/mm: allow PUD-level entries in compound testcase of hmm tests
Date: Tue, 19 May 2026 09:36:22 +0530
Message-ID: <cda73ed2c48c92da10540b33928e6e8aa04929a8.1779090293.git.aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1779090293.git.aboorvad@linux.ibm.com>
References: <cover.1779090293.git.aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE5MDAzNyBTYWx0ZWRfX2sueJkHpFhwj
 gXALAON5wHNtsxq4Gys2ZRzWfk9Tce71R3sKYbYLHTAmJCyawGr67r0g447qbgaQwSN01tY/t/k
 +ijtW+r/w5mQk1uYNj4vko+a6+nMMKQmDn6CZZ7imKE5AeieBtqHkrsC4NSArSEP5pZHK0kbrBb
 BBECLlcQUiWHqCeddT1jM+6hurnTmSfHm6aP6UEdloNrdEe+AnuN6bBsLTMBRDAJMlTY/fCkoLN
 Ie2Dh5wJl9aZv1ChaKZkDYjNXOPyoFYMuJ7ONGwxUJaTxxhQGK69YZT+IR1oF33cC3RufCmKan7
 UGJiJQg0tLv2wgwMS9gzoH7qXBFebCFYFjs+iY7Waglla4WYgEnKP+hcepXGCfE/RnRec1TVonR
 KB7Gt6CggY4UVrbsjr9zB6OUZG69jkYcMFFhZtPKjcbhadoIAUklyMuoGpb0l4/4a44vhgjcusS
 9qykVQEsVJgFgQNHIag==
X-Proofpoint-GUID: 0WbvWPkYJFCnop1e07qIbsbY_Ch19x3U
X-Proofpoint-ORIG-GUID: 0WbvWPkYJFCnop1e07qIbsbY_Ch19x3U
X-Authority-Analysis: v=2.4 cv=aYBRWxot c=1 sm=1 tr=0 ts=6a0be1cc cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=QxgUL920Qp7ezWAymYEA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-19_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605190037
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A72120009
X-Rspamd-Server: rspam06
X-Stat-Signature: 4fzwukc61js3wc74nrswisyeed5us6p5
X-HE-Tag: 1779163599-46484
X-HE-Meta: U2FsdGVkX1+ZVohTJA07i1pHQzwSQykZaFPmcuKxditc9u7N0MV+gVnJYqxyhKd72/eEtoWG+FOLMCvC6lUBanW50qvZEoBIBMkdX4Q0vtESnc140PLwtDGKc2bUCcx5H58S/we1s/C1x1ZW6mkbZEcA56+I07EyzLnwHo2kqQhozVCV1kT8edNtmykggWT1XaAuicfcYNjp0A/+JkiRy2XKFR8LyMip4x+q+uijEjGtNfoB4bvbZzTSP1FemHpDaF0jCexEwfe4466Vv4n3pwrD5xcw40yDSuVDN5CDhBspZwVUcicCyNQWERXPDcCZcQhabtsXVEcVaYwva6D0BruhrOCYzkD77ghlUVoFLeBGQKBInpv1EDgBrbonYfAKY4lUgNxOy8AUMA/unoz8piTKWpbQJ33gU8hdriyWTFNyOrzNoHNlHIu2CCk+/YFPV6DFSP8vtl72yj87HZKvgCESJCj5SsLyUGRrlDzR11dgCJdqbd6pN/55XTgJ1U0T5DyX10yfmh8OniHf+K3DO9wkX5SpDAUAxEKpKP28GnoeNsddR0/W/Oh1EhE7kTJZhp0z6rZQXfH6nc18dqBgVHC2Wq/GBE53sMR5IQHSiFSZbfL8qr8zA+daJRXnXbTB10cvCefb0IICZgSSD/0KXMy+VVm+f5DdKX/SEob1/YwleNdYelcm3DS7AHtGhQO7rWkZG4PqQbk7maiW2urFHIh53X52yyK9HcLn8JMM/+hQ2Uxqg/hM6/iY8ITQbJNsuH3ynzcorDngRoQJ/HC1nfOs4XbSu5krmWTNr5f4+jNe3YLX/NfbokKsLoBCP4lZPMiOKlkVHKqwdc8P1ibJbSl+CtuIO2txxWt0IPjh7K5nXKmLd4nEZdModgSKdhgYfwyKoWpUpQtQdjVvhArGmzAQjkJnC9Mu7+hvH+0Rx2xcTOrLeRzLclTTTDs1jwjfgQl/RtpOKKzXBvMm2S8
 xXBN9ACT
 c7r3UHqtz3qWngpfWNQIrqipiArO2ys/EHgT64/KV1tlICeYOX5hBuls7Vwd4KZAnPZpG1yTLNGIgbqayJxOoipi7Ubi5p464T0G6+vSkzL7qH6fH8W8oUKKvMFczLg1lt9bIyINCiKnNOiBzhl52G1n1ladjS6L9c2myxlTCRb9QWq57VTpAvexajlIkRheFBGQT9XZTvxQHwEmbsPPfJL7HYCT//mY1mGpiYg+XaoqBAXF2X29wK720eChg9Z3WhGnRBX/5Ts6rMBDtZ4DbqVjIx3MPHXVpFuz4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sayali Patil <sayalip@linux.ibm.com>

The HMM compound testcase currently assume only PMD-level
mappings and fail on systems when default_hugepagesz=1G is set.
Extend the checks to accept PUD-level protections as well,
avoiding false failures.

Fixes: e478425bec93 ("mm/hmm: add tests for hmm_pfn_to_map_order()")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
---
 tools/testing/selftests/mm/hmm-tests.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e1c8a679a4cf3..3d0da4dff85bc 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -1602,8 +1602,8 @@ TEST_F(hmm2, snapshot)
 }
 
 /*
- * Test the hmm_range_fault() HMM_PFN_PMD flag for large pages that
- * should be mapped by a large page table entry.
+ * Test the hmm_range_fault() handling of large pages (PMD or PUD)
+ * that should be mapped by a large page table entry.
  */
 TEST_F(hmm, compound)
 {
@@ -1651,8 +1651,8 @@ TEST_F(hmm, compound)
 	/* Check what the device saw. */
 	m = buffer->mirror;
 	for (i = 0; i < npages; ++i)
-		ASSERT_EQ(m[i], HMM_DMIRROR_PROT_WRITE |
-				HMM_DMIRROR_PROT_PMD);
+		ASSERT_TRUE((m[i] == (HMM_DMIRROR_PROT_WRITE | HMM_DMIRROR_PROT_PMD)) ||
+			    (m[i] == (HMM_DMIRROR_PROT_WRITE | HMM_DMIRROR_PROT_PUD)));
 
 	/* Make the region read-only. */
 	ret = mprotect(buffer->ptr, size, PROT_READ);
@@ -1666,8 +1666,8 @@ TEST_F(hmm, compound)
 	/* Check what the device saw. */
 	m = buffer->mirror;
 	for (i = 0; i < npages; ++i)
-		ASSERT_EQ(m[i], HMM_DMIRROR_PROT_READ |
-				HMM_DMIRROR_PROT_PMD);
+		ASSERT_TRUE((m[i] == (HMM_DMIRROR_PROT_READ | HMM_DMIRROR_PROT_PMD)) ||
+			    (m[i] == (HMM_DMIRROR_PROT_READ | HMM_DMIRROR_PROT_PUD)));
 
 	munmap(buffer->ptr, buffer->size);
 	buffer->ptr = NULL;
-- 
2.54.0


