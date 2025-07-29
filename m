Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6602DC87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 05:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 066966B00A0; Tue, 29 Jul 2025 01:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F32B76B00A1; Tue, 29 Jul 2025 01:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E21476B00A2; Tue, 29 Jul 2025 01:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD7EC6B00A0
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 01:35:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 838A91404A7
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:35:06 +0000 (UTC)
X-FDA: 83716188612.11.3C1CB53
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf16.hostedemail.com (Postfix) with ESMTP id 135E6180006
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 05:35:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=La1wxWKb;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf16.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753767304; a=rsa-sha256;
	cv=none;
	b=vuL2hftMOYNjYUO5osHMxBnIE0OjwZIht7PKpIWaosa7DkpnXanGaEBLZY8oZTj/KImgwB
	kbGFieLpdRzrLE/kFfmH+iC5SI73zaBS5FYAxTy55n6d2beWISzW6E3Z8hnOoKMjgp32SE
	SmLHY7T7d7cuCZIBwIRtGZB7jXvTAU0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=La1wxWKb;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf16.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753767304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I3fCHcP374PKE/USG24onJKIBeFDzBfdCxFluw7C2aw=;
	b=QcwNJs35aRipp0IHdkwJKd6Z6+uExVZ1tXZqcG5zE5q/86Ubwk03YY4gI+YJdb+uiuINix
	dwEXzYWdFzhvgKpZhIOKeIz1jGXkKAfK9R8C13QOrLzJB+LXw6NWkCOe0jGtHhqzhHgyYK
	g+aCIzNx4w2d+/WkbVbz1wyp6w0soCQ=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56T4YwTZ015155;
	Tue, 29 Jul 2025 05:34:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=I3fCHcP374PKE/USG
	24onJKIBeFDzBfdCxFluw7C2aw=; b=La1wxWKbb6DEVxSeuACr0M4PINjLb9pB+
	gqLbg7u5WqM0nf6JfklDjs89pbmMO5G4BLFVKxrfhj0dXK/3xBkfbKvf4aYxIF2b
	IgliZ2Prf/nMOcWEUwzprfPXrm2jDXsNswJDRnRgfWqN+NRl2SQerQYSbPigevgq
	b+af85lcLUFoBEWjTJ/p+TAAjZV5wqEpEPwiKhSn1cr5pH0MCVz+0mY8AmoYKM+b
	eGZCFtkNzAEORJKGqtesnEg5Fz9gtWXosvnTJB1PDfte0MPXHKl9hHgM4aF5rrlJ
	EfXSPzbU87FOfdxIUGu4Er+gOV7a/+a/hOQQtRGMm8CAe7eyh4tZQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qfqmqcg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 05:34:58 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 56T5YwVL002054;
	Tue, 29 Jul 2025 05:34:58 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qfqmqcd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 05:34:58 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56T3A7uR017969;
	Tue, 29 Jul 2025 05:34:57 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4859bth6dc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 29 Jul 2025 05:34:56 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56T5YrWu44826976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Jul 2025 05:34:53 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4AEF12004B;
	Tue, 29 Jul 2025 05:34:53 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A397E20040;
	Tue, 29 Jul 2025 05:34:47 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.150.11.63])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 29 Jul 2025 05:34:47 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
        lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, donettom@linux.ibm.com,
        ritesh.list@gmail.com, aboorvad@linux.ibm.com
Subject: [PATCH v3 7/7] selftests/mm: Skip hugepage-mremap test if userfaultfd unavailable
Date: Tue, 29 Jul 2025 11:04:03 +0530
Message-ID: <20250729053403.1071807-8-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
References: <20250729053403.1071807-1-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDAzOCBTYWx0ZWRfX5HDTFZBViXsj
 sQriN2PAF/TEQNGcwLEZm7IqyrmlXzJcxAdOixgG6zO2r1Zi+L2F9o2WjlqttnWF++K4/O9JASx
 L5jGUOYYPbNjJ9kVgc9mX6FsdiRpoR2VtaddaptwyxzlMGuh3YbnhkEBHCTswdm5s8YdUIGU/Zt
 0lKVdKwQCaxtGxEdhyM/OasYMOPZ+GjakFJoHW9o21+/HQWuLqa1qiGu32dgzq5KiouD9aCYjy1
 6wJBCsfUTTCZBjgjAVeEsxOy8Ha9It4f7DHkwUCj5FmBkeIBOjTXJVp1fSW2GNacbm3RtFl+OBB
 PX50BRebn6jYFbkLK+SA/0Wkh8vTML0VoCeY1m8wUbIHGlqbecKXnsxkPY7jL5ldytqwQVpOfNK
 Q78woXIYbNWizMmBPvJuN2ZOeW0Vc4czGsUwO0WD0YfXd/H929d4WqHkTBh5bkt27zt3a+0y
X-Authority-Analysis: v=2.4 cv=Je28rVKV c=1 sm=1 tr=0 ts=68885d82 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Wb1JkmetP80A:10 a=20KFwNOVAAAA:8 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=6zTM3Imc7A7I5ri1M5IA:9
X-Proofpoint-GUID: PKKiQI5cwGNe6XvMWxlnWgNZrfba5Dml
X-Proofpoint-ORIG-GUID: -qUcTG5LhWDqQW1_-b_YoFOsW4noWCr9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_01,2025-07-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxlogscore=999 clxscore=1015 lowpriorityscore=0 spamscore=0 adultscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 mlxscore=0 impostorscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507290038
X-Stat-Signature: 9i15ug37c179pxhqurrtn8ppn5r6wpd7
X-Rspam-User: 
X-Rspamd-Queue-Id: 135E6180006
X-Rspamd-Server: rspam02
X-HE-Tag: 1753767303-743007
X-HE-Meta: U2FsdGVkX19lwGkx5WVVjhxuHQgMWUMwD+Yk5a/pCDb6Xg724GlvNYrpT2zgoe0SjFKMou+8zkwHIFTv+FRK2v+0xF6Zobzkee1IlH2lHSFyQcqnLicQ5DeNVrWZK/5aM6oqHHxBhqpBZzoRRMcntqRAThDCR/KT9yOXY0+CzXgaEBJC3BT6Tw9WJAyAFwxKpdrmR7ScMtQTlXp6oHIBKqQK1EIW/efqTNS31NUM7BB65sSTm1RXdJcrUZshGSTBB4Jxsz4TKRFKzE0iM5qaNs7+jmG3YubqcvrIx2cO74X5nwswHhlVo3s0ZAdgTtqfyYpeQW6TTZGtGhKBOiDvXkvQj5amtn6IWjKrvQcds5NrqJTOVjpwoSP/xk5uo/ZcJgnGJeQoHZaSNlp+8RNQDHJXlBdtY8GXL5xkyOXB6YoYJXP6FKOhiVRRvefct5lZWxCygyfTjTg1rrXrkpfGsmd+H/r7d96C2qfAy97/lay6IiDzlE6KzXiAEWKhEeUyNMfGa6kluwzvCnOZs7nd8nU1CA318gRBJljbZ0h4KTgyxEAvqZ89TptckufRLqJ/fCQe1Gv2aJCOlC8uVn5NFSEdkBfbVlUJlAHYz7gBc55dT1G1aDi2wDcpWVlt8RbIU2J8RzBMt8hZlL8EJ8YYwjNChWa6jSzIGyHTuKJ3VuAjZHfGKU6Ow3KKJKNs+Ew3Q4TTNIVIUc5eehcFliM8b6FpNy2TGGugsxlSGITSoXKzjAGeyiIL1TWygj4KrODcokhlzmbhBefDjoLoS6Tw5HrzlNFZahUOJ0nW2AtL0AoSsszgVlMXnohETs4jHngy6HM1q0eveivypn6RbYIBvW6TiLso84IDwchJJbf7v/ilG+3/m9CjxrWqI4ISdLsAXylZjjKwMPbhby3xcW6+2o32Ti5XL5TUTM2xIFmuCA19kwnmMSgjbDGQhvL4INNLmb8wd0syuwdprAWD6OZ
 CUHfS8Ud
 JXOT5vyzIIQWwavRiP3R++cmm3/2whKvwG1t4oGXzLZJ1LrJhOe2mWf8HCgUZ+XDuDt1yfdeho06fQT2XwdssVxvvzvaMa2SuV1ogqoYEcuE8ap9qw6sM57Kx6Qbgw+tJi1IWB3uSxFFMQf+lIqQ9IHRouOaQAa1yI5YJ6fRp99e+4o9MT4OAeHjauRcJi8YhcO19j3bGzxRF4ClTxUpt+tzBGZDoT2ugtJZH5pw/7U8QDWikkCbcP4H4a9BZQpyBb+aqAijqNw3BGQ3FbwSfZYrj78aVMF+V40Qxm/wUHamWDEqJuPTU6FnvABfGHLV3VG3qxhpIjksaypX3IClQFO5R92teL/sS1QUiA28do34OCXq2EuLsoDwdKdI93XDD6ywiAerxZM5syfeeCiX5Jk5ltPieJzTcO3F2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gracefully skip test if userfaultfd is not supported (ENOSYS) or not
permitted (EPERM), instead of failing. This avoids misleading failures
with clear skip messages.
--------------
Before Patch
--------------
~ running ./hugepage-mremap
...
~ Bail out! userfaultfd: Function not implemented
~ Planned tests != run tests (1 != 0)
~ Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
~ [FAIL]
not ok 4 hugepage-mremap # exit=1

--------------
After Patch
--------------
~ running ./hugepage-mremap
...
~ ok 2 # SKIP userfaultfd is not supported/not enabled.
~ 1 skipped test(s) detected.
~ Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
~ [SKIP]
ok 4 hugepage-mremap # SKIP

Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Co-developed-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
---
 tools/testing/selftests/mm/hugepage-mremap.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
index c463d1c09c9b..2bd1dac75c3f 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugepage-mremap.c
@@ -65,10 +65,20 @@ static void register_region_with_uffd(char *addr, size_t len)
 	struct uffdio_api uffdio_api;
 
 	/* Create and enable userfaultfd object. */
-
 	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
-	if (uffd == -1)
-		ksft_exit_fail_msg("userfaultfd: %s\n", strerror(errno));
+	if (uffd == -1) {
+		switch (errno) {
+		case EPERM:
+			ksft_exit_skip("Insufficient permissions, try running as root.\n");
+			break;
+		case ENOSYS:
+			ksft_exit_skip("userfaultfd is not supported/not enabled.\n");
+			break;
+		default:
+			ksft_exit_fail_msg("userfaultfd failed with %s\n", strerror(errno));
+			break;
+		}
+	}
 
 	uffdio_api.api = UFFD_API;
 	uffdio_api.features = 0;
-- 
2.47.1


