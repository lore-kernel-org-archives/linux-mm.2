Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2940AC87FCF
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 04:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C13576B0407; Sat, 16 Aug 2025 00:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEB156B0408; Sat, 16 Aug 2025 00:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B288A6B0409; Sat, 16 Aug 2025 00:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A45AB6B0407
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:02:53 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 797C082D97
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:02:53 +0000 (UTC)
X-FDA: 83781274626.03.78A491A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id 12B1C180002
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:02:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rXqJDm6B;
	spf=pass (imf24.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755316971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/aBl03vFCknkuawje8hxVJ4OWCSUgh09Oa3cpvTw+uE=;
	b=oQWzQoblh05/0+6RXN3V+B2SZNLE1nL1DcWbOWbmkBaVqq453iC55K6K+akBFuMnDabAph
	a/8+8JgA0xE7+JnmIRaQUV/c2svSKDfOxgerQ0CGdeIfTlT1597U+PPPX93Il+o7IFQ96o
	eb40ZkY5YlsHJAJGsPJU8R/w5fhHpKU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rXqJDm6B;
	spf=pass (imf24.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755316971; a=rsa-sha256;
	cv=none;
	b=SXTFKJbBgL6zQXXIO4O6LknxT7to+ja0BNgiHxX3ZFBsxVSk1RHcEUjlWCKUQtI17iUzrX
	as0owqydKmxPvr5hhAL/RZB5LiKngwoR3Wo3tAOWyzawmQ30NM+PERVltKIZp84RN8LgzG
	G/h9ORGH5LAsWKE1iCZ1lG4IvBZM/0w=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57G2n380021873;
	Sat, 16 Aug 2025 04:02:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/aBl03vFCknkuawje
	8hxVJ4OWCSUgh09Oa3cpvTw+uE=; b=rXqJDm6BI1Pw/Ulov/hRwro6SJSwOzwBW
	3v3wVJnKSxhuFxt4L0hSkxe6rQW4a/5qUXJionz+6wU91GeFoR2XWj7FdUZBQM4A
	4kXtP3cDUHMhrMSRG3VyVZqzvlfVKlojnsgfrqHA/ELgZM7QrAKjXcHcsAiYbLCQ
	WfTAGfqHMeUTthzSZnGD+/c+4OUJUlGOvdcxkqTnkKVwG6ALOBDLrQoNediImGID
	mPNgKLl64ssC8D03a9DUS6apPfYW0UD/fhJlE0GWkjV+iYQkTRkwU/ca1jpe4fe9
	Qxs6/ypWGQ3eUbwlTo7Kj+ebcdltoipvDZ3K491UjmFViNdE00/iw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jhggg4m5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:02:45 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57G42j4G019883;
	Sat, 16 Aug 2025 04:02:45 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jhggg4m2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:02:45 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57G0Yx8K026279;
	Sat, 16 Aug 2025 04:02:44 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48eh21kxtq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:02:43 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57G42eHI51446244
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 16 Aug 2025 04:02:40 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0F0E820043;
	Sat, 16 Aug 2025 04:02:40 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 182B920040;
	Sat, 16 Aug 2025 04:02:29 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.36.5.210])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 16 Aug 2025 04:02:28 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
        lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, richard.weiyang@gmail.com
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, donettom@linux.ibm.com,
        ritesh.list@gmail.com, aboorvad@linux.ibm.com
Subject: [PATCH v4 6/7] selftests/mm: skip thuge-gen test if system is not setup properly
Date: Sat, 16 Aug 2025 09:31:12 +0530
Message-ID: <20250816040113.760010-7-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250816040113.760010-1-aboorvad@linux.ibm.com>
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: a6MP_xSG01_aDuXWt6yFXE7qgCrF2ULW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDAyMiBTYWx0ZWRfX53U75hp/N0hN
 W4VGKczjEXDi1QJ1kq+bJq8dfeFPwJBIQvJkw1cdVub+G4g6S5IyeD5TIRCrx71D3Mv3KKSrMSA
 hANkhXytBT1f75SG2A48QngNFpX3HIWbXUJ4u6eY4XsYA0j7VGzV06dB9bSgG1XN11RtcApEyXb
 wduOaQaIeQ/HrmGGlibV8lv0ZA7i9wES5c6CBhde2GHMIRdZeEIIt4c4Z9tv+WeugSRTvLMDnVr
 +jqLGVELocPkAC67JeVIb8hHwFeY4GNHzSBORQVG5rFeilsWHeBRS70pUEqkyQpQFpLiqtCiaio
 vzsOIHYToDIQ7d3eZ7MsWbV9Q5PUJKudVAlhJqSPeqVKTfnAL2StwjjzU6dzOtgZqo8ztCPpgBM
 LVykbSKX
X-Authority-Analysis: v=2.4 cv=XOUwSRhE c=1 sm=1 tr=0 ts=68a002e5 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=7CQSdrXTAAAA:8 a=20KFwNOVAAAA:8
 a=Ikd4Dj_1AAAA:8 a=9-ECl0np4EkliaZUNCgA:9 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-ORIG-GUID: if8lV-oYGlA0Z2T0D5dhKpwFf_cTXoTq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-16_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 spamscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 adultscore=0 bulkscore=0 phishscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508160022
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 12B1C180002
X-Stat-Signature: us6z8rk71e46cxoqe7hqjxtn9zqesbwq
X-Rspam-User: 
X-HE-Tag: 1755316970-402262
X-HE-Meta: U2FsdGVkX18FD/nrtck6f8aLkEDTqXenb/11Q1US+rfdXfllYaJjPfPkdLwrw54KIaUwjtmBbz4KgX+icyupCGjRJDNvm/eG+Zqje3R40E21twME8JvAtgPopFNtUVFh0zG73QexbBiS7Fkp1Jwi1kKgQrO+K5wIA7MKRYBymAoHXRNH+QIq37HGENY38/DDimBL96rSuxYzN9sk7kfy+TxHJ/dilRdjmtJD2N5DihT7JB49qtbfD4VRGxWfpC5oGQbzT1YOdFFn9agxT9pZD4mO537y1w1jMEYcZnkD/5LZUGj3O3iKB/fPUSjDYHb6iccSPgcOCrQoIUQrTMrACYR6RIBS2VMSPcr2rsA5T2ZNNNrJ8lvEbLLD8V9aEpu4bER484fVVUO8ix+8zqskQwgHItBXhhsI+GqsTO7aCOjcTleTPck8ddNbPegSyLbnRFeZQ3A+xymMnZXr4q7mCW6+LqmXBjgw0MgyHCoKmumnONMLp4BuFGebmErSOo7KbURpn/aOdH02GdQ5c3/9GvP/kBlIC7/gA/q03nElPrTfcibkPa4wWfrKzhP008ZVk6vlC4fHz3p9TFF2IQakCpTf/+LliiRuIcw1THIsymMtFvMoN3JeWEdcuQMeeIzCzyNn+GfGijtlU+m7pvjcmEn0UyQVpr4Ml0eodk8TFRV+E1HUWHRbDc4xLYQZRmqerGbrBAka4U5eCKF8oF2rQBqYDFcz2E6InsxDzze9CKYEtCK4TFRGBgl0VbfLP22raxRI55KtdIk56dyKiAaqStLqTsoseiuTrUNDezZQ858hMBKJTeQSeWpUgEs2fbHfjfJT7Dhtapl2KqON8nS8kce+BBpLFscKmGl1s6oVsN/GMuA/YrI8PHiM4yDdmdA9RjfPBhf+67iGnchyRhUwAl6kCoroeFYZ9O6d9H0IPi0laajqKMPwaFLudQ9vRzwkvqeI2ZcDebnEbwDOQng
 y3aALrca
 Ww9pg/kkIfpYLRfpq3KeHFnWw1V7EhBLR9bbWxXpXL+47SUL5CTEL6jisT83Pcuy4xkq0UGkVXOuvdIdjeliNzCjBoEPdpBTScylOpSDWn+0mPT5jGQp0Prg5IvGgFvJBT44zvRStg2l72dEh8EA3eEn4zub6IGn0cJlnv96NFh9vw/HrcEotFP5jeI6zhWkCHmiaEH5GIW1Vn4ra1Eb9aCGSCXkCIOELPKxPW9su2aqw4m2j375wDe/9/JmJeI/xnE271qSPdB6nzGcCi99feTyEwbciGJS37VDns6F62JN6vVvAnF/AL7PdQXz61OSNfjhTAhSo507SYApfAJCqcVBPaqq2oBUXXXYocwIAySgl2ZqBTpWh4lUOe1nwq3F3EKfV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make thuge-gen skip instead of fail when it can't run due to system
settings.  If shmmax is too small or no 1G huge pages are available, the
test now prints a warning and is marked as skipped.

-------------------
Before Patch:
-------------------
~ running ./thuge-gen
~ Bail out! Please do echo 262144 > /proc/sys/kernel/shmmax
~ Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
~ [FAIL]
not ok 28 thuge-gen ~ exit=1

-------------------
After Patch:
-------------------
~ running ./thuge-gen
~ ~ WARNING: shmmax is too small to run this test.
~ ~ Please run the following command to increase shmmax:
~ ~ echo 262144 > /proc/sys/kernel/shmmax
~ 1..0 ~ SKIP Test skipped due to insufficient shmmax value.
~ [SKIP]
ok 29 thuge-gen ~ SKIP

Co-developed-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
---
 tools/testing/selftests/mm/thuge-gen.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/thuge-gen.c b/tools/testing/selftests/mm/thuge-gen.c
index 8e2b08dc5762..4f5e290ff1a6 100644
--- a/tools/testing/selftests/mm/thuge-gen.c
+++ b/tools/testing/selftests/mm/thuge-gen.c
@@ -177,13 +177,16 @@ void find_pagesizes(void)
 	globfree(&g);
 
 	read_sysfs("/proc/sys/kernel/shmmax", &shmmax_val);
-	if (shmmax_val < NUM_PAGES * largest)
-		ksft_exit_fail_msg("Please do echo %lu > /proc/sys/kernel/shmmax",
-				   largest * NUM_PAGES);
+	if (shmmax_val < NUM_PAGES * largest) {
+		ksft_print_msg("WARNING: shmmax is too small to run this test.\n");
+		ksft_print_msg("Please run the following command to increase shmmax:\n");
+		ksft_print_msg("echo %lu > /proc/sys/kernel/shmmax\n", largest * NUM_PAGES);
+		ksft_exit_skip("Test skipped due to insufficient shmmax value.\n");
+	}
 
 #if defined(__x86_64__)
 	if (largest != 1U<<30) {
-		ksft_exit_fail_msg("No GB pages available on x86-64\n"
+		ksft_exit_skip("No GB pages available on x86-64\n"
 				   "Please boot with hugepagesz=1G hugepages=%d\n", NUM_PAGES);
 	}
 #endif
-- 
2.47.1


