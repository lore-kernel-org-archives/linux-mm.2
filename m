Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51369C83F26
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 05:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D38236B009E; Tue, 29 Jul 2025 01:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC1CE6B009F; Tue, 29 Jul 2025 01:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B895B6B00A0; Tue, 29 Jul 2025 01:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A1FB36B009E
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 01:35:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 779F580490
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:35:00 +0000 (UTC)
X-FDA: 83716188360.13.EC3459F
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3777F1A0004
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:34:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=YG5jNBD+;
	spf=pass (imf19.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753767298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=puctAwqoH4VWxfpXZN+AbLrRyBve2Bkehva2Jfypeiw=;
	b=ZwlOlGNpwFUzsrFZsK+3ipXF/O6LVXM+pJ0QrsA4EBDKLJHg//feGR0hbdbwSnXjt7m5Sj
	pCV8/31nTeN4eSynunx6P+QCJS9cXIO56szCNfG+ymyWEwl+KZV1isoeXYXvXmDBcT5JQO
	s3l9EaYJejXAJqyOnM25RA2o/wFzuqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753767298; a=rsa-sha256;
	cv=none;
	b=abRifFSGilFwp9uWw8gjPGAl2cZXshzMnpfGxyBNLPBnXNXmql+14Xq7sIybEVRMSmslhz
	J8i2+v4SQPk/ABP1DwB+NIINDbSe7fERvWte53UmhOGPCsTkQ8HNV3SyUCDp8v+DG97c0B
	UsWudUzF0G4oty3RZj92WJvGLGYSTs4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=YG5jNBD+;
	spf=pass (imf19.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56T4Z2fg023071;
	Tue, 29 Jul 2025 05:34:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=puctAwqoH4VWxfpXZ
	N+AbLrRyBve2Bkehva2Jfypeiw=; b=YG5jNBD+qAllCCb9ayUlxc9LP/SZamInU
	7sa9U72Mpf1s+8LCFACuBULPh0fWRa6uZ5ByPJwPivg5sTyJfLpwLdOnyiG/H7U1
	csLcaWZ3kNjHIOBIahfSF8vy+HVNgCu27qs/7zInSVBAwVpermge71YJ4CqFWZn5
	duTrrBhJJWv+pT3o1ZSbdKMIEZVKQLQgR80YVsgICTc38IY98PV0+5wLcBm7prQ0
	Wm5kcc7fkLSKiW+DiGZQxVox8r72Wj6hrv0HQ4jdIAXRuw5tvvMXwYISgXxpT5ZA
	yi3oKM7kPZTlfbDOuWAbd/mM+GnNGq2PVYp6Y5+0WBjRwLvfoIpOw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qd5csvy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 05:34:52 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 56T5NwGV019251;
	Tue, 29 Jul 2025 05:34:51 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qd5csvt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 05:34:51 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56T0kdY0006242;
	Tue, 29 Jul 2025 05:34:50 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 485bjm0twr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 05:34:50 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56T5YlgL20382006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 05:34:47 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2782D20043;
	Tue, 29 Jul 2025 05:34:47 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 674F120040;
	Tue, 29 Jul 2025 05:34:41 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.150.11.63])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 29 Jul 2025 05:34:41 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
        lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, donettom@linux.ibm.com,
        ritesh.list@gmail.com, aboorvad@linux.ibm.com
Subject: [PATCH v3 6/7] selftests/mm: Skip thuge-gen test if system is not setup properly
Date: Tue, 29 Jul 2025 11:04:02 +0530
Message-ID: <20250729053403.1071807-7-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
References: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDAzOCBTYWx0ZWRfX9353wI5WPT9p
 0HxgOgUzYLCsRfxNTQ0W04rrUBX8J+IdV+w+scY0HnAUIHbF6CjeI/cTgJaOdXCVuZ43jePd3/U
 nUrriP3j6BKuPwQWS263LxoOSVQRS1+sllaHUmL5GdOKjOLkbDqlr3bBtf1ggcjuDAX898VX+8J
 t3QXKRm8zxp0jsrSgGGUR/njFOBr+DRaSTnW277Jej1oBYpERmcmxaK9vgbwuvKVUymgbZedkI1
 zKRQoLQ/jxfkJZfm6A8RDnLPO/O2PMyYj1VP1iS/zruYAjQgKbwg3aY0kFvMPBAGlMiPwvZKHIk
 2Eg75XtXbsKSU/vHjk4JYr8KoxXggySu24aQUVgrmeMyomakHzlSXHvGUa0mLj/U2BEp3ZDJAbX
 NrDGsBjRStuXP3E2h6hKBNaqoEJtWEDoxZw05RwFm5LifbMUITDfAiDi9cJqD/rwWFXcXBLK
X-Proofpoint-ORIG-GUID: owjdkx3vLbfUBCKN3LeoYoInS9y9NNdw
X-Authority-Analysis: v=2.4 cv=B9q50PtM c=1 sm=1 tr=0 ts=68885d7c cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Wb1JkmetP80A:10 a=7CQSdrXTAAAA:8 a=20KFwNOVAAAA:8 a=Ikd4Dj_1AAAA:8
 a=VnNF1IyMAAAA:8 a=6zTM3Imc7A7I5ri1M5IA:9 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-GUID: uoTHmPnNFgwRGLOFVMlrBynDbJ7dL9bO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_01,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 mlxscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 clxscore=1015 impostorscore=0 bulkscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507290038
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3777F1A0004
X-Stat-Signature: 4u73xzzrzyjcxkuse8j1jx873wncttzj
X-Rspam-User: 
X-HE-Tag: 1753767298-723023
X-HE-Meta: U2FsdGVkX19ECcgcNFXYxl+Dqy8cY0AztDUT0e06roolOmEuqL9tIiSIAa7PqurkbVH5MVlpwnAL6kgTpcKQ2dAhMVEYcoqruKLhm9CpCoDcL1bI3Borz21epgnrcF1Qa1QbHSxtKOeNGWHRKNDgEWO0zczR9KR8G+/vUJ1WOpTngm4bUaZGta7c9YW1tjJ46BLhEOSbvfUBt38WBMcHy/HkgeYHcuIY1qoOM0ojKcU5kQnPFJv2DGKH+ifUdcNORlnGm1ZhOh07AJ4ND552wUS/RxJ/8ki3AOWi45fTQkDRM0J3n4CRnjpHuuyORuX2nBVCpyQlqxkImNnJ/EhWuVZ6QREduZDPvZ78S3H5PtAKpBfj4lNJ7br0Z+moj3i2z+3YKk+1KLJYB06sn+sfo4oWwGfoEPnHHc9cP2zjQQ4gQnBXcEs8JcPXpUPQkaH7lbMqqhzM/lppx98WMJ8A7P9LMJOnx9ziMZRpZDNgMDelQA5q33nBJsl4wWmnd0rhsgGizJD3ImuIFja+l6SodPp3ry2+WaMUbgG2GCUhFteW89XYPGIlKF0YY+gWKrR/aJEpP/MPtqgLFmBIc7gxWRtA7CnJ95uECB9oZsWrR0z6ikgTLoe2bh/pueYuc9DmeQQepHKXosQwewMfvYk6YKq8HFAhz+uYuSEbQPkiQBzQP+PK1T7OoOox9Tna7jvF0an4qf/r1cTpY7Gzib1sSKB+2YNDf2yzlJieZM11POf3iRpM01Q09ST/A6XJkndGoenfMQPZ+OJh/ilrOluRgLgYbXdkQaWRGxIxk4GiDY4M5bmOiDpn1crrTqxoRrMug875P92qOR0UUMyAy6y7x30DnmN6wDON3HsYqaqM2Dsd1+x+ANKiqdDaBkfkOTnXY0ZQRXMWWQeEfZUA0PvdoSKwt/shq9o8ANmskTRLmLvFOpfc5WB89MlC6nD9Id0qJ9UhpBShZjG+GCX7ctX
 lQ1yk/zN
 KBfrxfOWL9PYP7NpnwzX39ZKgR2xxmc4DkFsJ7SZ7DIiSUJfAM9QThoM6fCrlX9Sz6W/TV79m41kRP3uEe+6vP0lFwf8gNGQP9aoerSDYnHA4dIsHuHkWDNZVrv/thrNejfr1OLMTmV2Nq/HnRPC/GrwNoCgiK4ljeZLwiFe59nZXxKfD/yTLNyFKSJtRCYcq59uEab4oxrOX2Bd3/fOEYTp0Xc6njHy4ddqTeY+Alj8utqouXFDE+ZrsHNU0YcpxmrvVZBTRD/CzQH2W6oN7TwcKSbz/+3EKyzNHvn7CjaC+kjEYDnd6RQoblCuibuf7awkdye0olhQVpDujhmdH63BSmMIpBVdR+gKqU9TXNsgxIkkwJdoYjcmhpDHbSzT+cnk0jzuNQwP42I1F00e2r86bq+r3bEjG0UMqX8jIV9PXoMy2VWnacbMaf6ZvgoRzBeFJHLk/0bgc7bSEAxARkuvpVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make thuge-gen skip instead of fail when it can't run due to system
settings. If shmmax is too small or no 1G huge pages are available,
the test now prints a warning and is marked as skipped.

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

Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Co-developed-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
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


