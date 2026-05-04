Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E98BCD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 09:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8443B6B008A; Mon,  4 May 2026 05:11:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F49F6B008C; Mon,  4 May 2026 05:11:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70B0A6B0092; Mon,  4 May 2026 05:11:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5FC156B008A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 05:11:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 057141C116F
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:11:23 +0000 (UTC)
X-FDA: 84729168846.09.FC72982
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf16.hostedemail.com (Postfix) with ESMTP id C9715180007
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:11:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hKX1mZwB;
	spf=pass (imf16.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777885880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cIQ8K2HJtwQlSMozFshA6AnsK+LYu4W5byOwdQkFz7o=;
	b=1rQu5O6XJWGaEXapRyU3viuUL2kQ4f4eJG4SBAcplwR5OqIJr3jtRknvjwo4Xbn9i145bl
	96G5aOTP6nY+bpIeqK+qm3UB6fa94cq/ifXqKuRD2WZ15/KNI49T0uK7b5TPmvQr37r8UW
	UrXNwxp1oU7byLD5FsZFiKNYdZzXbVQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=hKX1mZwB;
	spf=pass (imf16.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777885880; a=rsa-sha256;
	cv=none;
	b=oWv8OayjFwKoGJPxOuE4hZfVYE8Z9onhXu3aSVaLpOZ05f9SPuedv/SQgb3tspYbXY+NbL
	u6lzPDnld0Y6pLnlmNt6YtdVExSZ2E8H05bNvRzkTz3jld/B4k99QZ14LH4LFWCw7MYTsB
	D3r4s++EWVqLNbsAA2MLJOjd90C2yME=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6441cdh23828299;
	Mon, 4 May 2026 09:11:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=cIQ8K2HJtwQlSMozF
	shA6AnsK+LYu4W5byOwdQkFz7o=; b=hKX1mZwBKEg5A0ExFkDzhwzoSVYdN2UFU
	664ZtZlz773uh2jNpNdNgXtvVZBQAuj2Ge7o26FLuSTqM302v7fVhRADNyoq3UyR
	tA2StNtcEo+XM8uEtbZA+smrZ2yAf6U8Bnt13mUdSRG9IM+wve9/WnwD3pM4gndi
	N/0/FvUMUlJVmeeNlM909U2xh3pRrFbVws72Sn8h5qjRVLMAWe/8XvKnEZxYcyDk
	1d5pgPvGbvAtEWXcXGT0lHyRWtz2Dhl4ykhbesjUYzQ2Do3lrdXivSASYq2h5kNs
	/oJfzN3c7+kRC6DJnEFL7jNlKf9Vd2RV9PGrhW8BYhuQGd2Pg/dhA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9xxe20b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 09:11:17 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64499Sxc005944;
	Mon, 4 May 2026 09:11:17 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dww3gvcqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 09:11:17 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6449BDPE47841598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 09:11:13 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B9EA2004D;
	Mon,  4 May 2026 09:11:13 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AE09420040;
	Mon,  4 May 2026 09:11:11 +0000 (GMT)
Received: from aboo.bl1-in.ibm.com (unknown [9.123.14.187])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 09:11:11 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Cc: Sayali Patil <sayalip@linux.ibm.com>, linux-kernel@vger.kernel.org,
        Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [PATCH 1/3] selftests/mm: allow PUD-level entries in compound testcase of hmm tests
Date: Mon,  4 May 2026 14:41:06 +0530
Message-ID: <b754427130272dfe0e468cef73a9b92d22ec0ab0.1777870179.git.aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1777870179.git.aboorvad@linux.ibm.com>
References: <cover.1777870179.git.aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDA5NyBTYWx0ZWRfX2OTKEwUdMLi/
 ntGJYwlcp8C1ZyrhHAxE5H89GTwk7NKGtr0nohDG9mGLpvMJgjB2xJaerwrO5DwPT4MHmR2pf5K
 Sg9MkFfuoVvEXQdnc9rklJ7mE0GBO+bMcvKIOB54VIaEbcUOKo3FujSQpdBrGuEIaBdPJufFqwV
 Z/CiWs8s5X7/brmNoeT++Ytc2yn1xvBhKLjK+g4vFutzDlutNL9rMi5txFegCKxUpHkFkWGrxmk
 ZvM5L4Hf5K3WCs/pojwhhYCJohaDIpJq9+DA97XZTl0wmdwNxBfRplaHXJdYWEYAcl1SyoMa9Us
 CzsAbyRl5E2IS6iyY4FkKIVn9dJoI4TKiJ3//GSA+oM92wnyCrxjrdx8fA+Ebvem5rzH2kordjg
 jcN7Mn96Z8qBIFNPthXeIphXMfy61DVfwEX4+5ZI2I8dYLa2NCFQ3mdWt9vArWMbOmCxrDnLq9A
 th+c+SBH98yol+CAKkQ==
X-Proofpoint-ORIG-GUID: wcx_EMfXyr1ZDFrb0a5UjKobkgA1YPmS
X-Proofpoint-GUID: wcx_EMfXyr1ZDFrb0a5UjKobkgA1YPmS
X-Authority-Analysis: v=2.4 cv=ctWrVV4i c=1 sm=1 tr=0 ts=69f862b5 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=QxgUL920Qp7ezWAymYEA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1011
 suspectscore=0 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605040097
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C9715180007
X-Stat-Signature: k7ihaj1skrrerw33jfp1mty6zqw9uqnz
X-HE-Tag: 1777885880-750764
X-HE-Meta: U2FsdGVkX19P0rq/qEebC6VZFVAtDnGoH28Q/c28k1UaPviBX2SYhIRhz//LjmJf7O1gVL8qywnKouxK08fDsQPj3mP6FqA67jdpCkvVYPf5N50HoYXHZwXgOPldRAR0ibb3nB6N2LI4aG9qnRKT26qPlo6hfh1DfxBBiHoaoZKqn0drhOgTRnjafBJkhAgFanQCaFgWmE+inSyGdS8twujA+JQUUOEpzM05smAR5wTMfaOEjJjri6mfY6UMiKW4FuZrrySUTnQP982kmhjyT924KkpGZMmRd0SS83ePS9IYpZsxlB6PVDwGWqBMadkJGIG8H+173QNVID4CjA/Fmljc/vhprPXUZnr9y4Yz08KDgFVmQPpsrIUOLgiAkx0/t/V+ENLLQ3UttRTOtPq1s1bgLppfvD+uyfklEEbHGEIA6JLG9H+O9sQ8g+h1zhR1/8MiheKmzqdBoJ1/hu5CXM+mqKI9mgx6AmEWOkrxdfKb5nTiKQtkixJYpazn7X1f94lEXYatGEd7spyLyFbZnrJOIYY3smTRrGMI/eWLssSEpDpD74LA/+kA16BLppYLY3zZeqFO40BtrSkT/eGyR8X8qcI3ELQz6cqvBkb7u5at6JpwqlTZboV4j9f1Q3Xj/9ONal26UVLEu/2obbgNoUqgrjyq8WJcnsE/J+kqd7/VqwUKi5goEdzfaNqsGR/38Xs3cQChrpMeqMmDyBXNj4DBlsZfhJgv35re5CYOIbAHH6sBkejbrciCK4wwMjXCvMpTLnp/uenhmaSjdJub8apIWdqyDdnclDc1RsymYI2oOJUVNHty4Q+7YcpNXIti0MwTfYMSqzfar6FDdr/ByT3j6EryC2cafUl7FqSt4uyaxA3DxyqIuDS9bvsITLrehINAm2Eul+PzK2IEwdMUjcrMdrz6nrTWOhbpvxDQHicd26X19pj+BwqulMNzXlQOc2IGMh0s0kwegw3gIHI
 zvck0td4
 TTbj9hQGDGeSsG7adyMJPcg8iC58WEnYsk391VqSH2Koo4VKiBAg291pf6DrH9rMIYXIwUIz38o0RU67mgoVJrbtiQNJdc5+VCrnxrXhWYLW7TWidmLZqsB70/dtNpEPdPzlxr5HgZquMIqy6x6Or1+ipH3Rehrxhwl/+/dLt+DKMYeAx+21QY9HpijxKaUW9clbqBjVOKfGs674=
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
index 77fb4c5d871b..6dc839866dfe 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -1599,8 +1599,8 @@ TEST_F(hmm2, snapshot)
 }
 
 /*
- * Test the hmm_range_fault() HMM_PFN_PMD flag for large pages that
- * should be mapped by a large page table entry.
+ * Test the hmm_range_fault() handling of large pages (PMD or PUD)
+ * that should be mapped by a large page table entry.
  */
 TEST_F(hmm, compound)
 {
@@ -1649,8 +1649,8 @@ TEST_F(hmm, compound)
 	/* Check what the device saw. */
 	m = buffer->mirror;
 	for (i = 0; i < npages; ++i)
-		ASSERT_EQ(m[i], HMM_DMIRROR_PROT_WRITE |
-				HMM_DMIRROR_PROT_PMD);
+		ASSERT_TRUE((m[i] == (HMM_DMIRROR_PROT_WRITE | HMM_DMIRROR_PROT_PMD)) ||
+			    (m[i] == (HMM_DMIRROR_PROT_WRITE | HMM_DMIRROR_PROT_PUD)));
 
 	/* Make the region read-only. */
 	ret = mprotect(buffer->ptr, size, PROT_READ);
@@ -1664,8 +1664,8 @@ TEST_F(hmm, compound)
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


