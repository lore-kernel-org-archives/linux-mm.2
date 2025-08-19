Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53AE9CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 04:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBB038E0012; Tue, 19 Aug 2025 00:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E92748E0006; Tue, 19 Aug 2025 00:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DACBB8E0012; Tue, 19 Aug 2025 00:13:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C97438E0006
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:13:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7840B112D27
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:13:06 +0000 (UTC)
X-FDA: 83792186772.09.44C6F5F
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf15.hostedemail.com (Postfix) with ESMTP id 30488A000D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:13:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CZJuOyNl;
	spf=pass (imf15.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755576784; a=rsa-sha256;
	cv=none;
	b=s0ignw5DwJAEy1ufFcMHottCqxN7QQXrXpCIUbuFraDaQDNy4MLR7ShR3DKVEP41L6e6b2
	gSxN1FaDHrwQnJ+PL4XyhDt+XmPYWUTvZ4IY5NJ9vF+9y1GN5xvKwsfjI2WbTULIfnwFMC
	E8oKIfoU2+Eaz+i8stctnmp4muH5VB0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CZJuOyNl;
	spf=pass (imf15.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755576784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZFlr9XZgtlNb+evn5eEZ1lChPKLSA2WkgbkwzuLvENE=;
	b=bCQ7otVtJRrDz3Yhjzzc0bXKqGKnDKoyImiAsgNnneWZuj7oaXNdqTsFMsVLYo8I8gpUIT
	P51Qk7ZlBnqJCSycsblxMUyRjuMBbMjJXhol8h2K4mtENfFl1Daq3T0TZ7b8huVTsY5MkV
	QytFkZpWL1jiVuoMrvSi87Sm+iWqLk0=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57IJR3nC018787;
	Tue, 19 Aug 2025 04:12:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ZFlr9XZgtlNb+evn5
	eEZ1lChPKLSA2WkgbkwzuLvENE=; b=CZJuOyNlIKOZy0rlXXgcLwa6do0EIfp8b
	4WR8qFQJGjIlXpt2SxTRaBj6ZcjIYSmYLXLzGKZ+ytm2k8KTuwjMsS00v39XZFBf
	etVnja4oBxP5deSrkMGpCxtB1lY/lN6Y8yk8K9hSOtT1VVqPasL9Hl87Emgc+U/9
	mcXBjHrKWyn91HZBNnpOcS90+P1tD04ofe8/vabgO2AWNxcnVfr/I7y2dn8+evZb
	uUWtZm3SgmKKOBm0mcZCRwAcYkGzRglSdObF0rw2cgKZa7u8Sy0ltrk1Sx+u3Vkm
	Uocklo8Zu6ztQiz0TW/bU2bMPJ1aMjUo3tKbbbAEQ4zxD9Y+H7TGQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jhn3vbs4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Aug 2025 04:12:58 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57J4CvRG000433;
	Tue, 19 Aug 2025 04:12:57 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jhn3vbs0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Aug 2025 04:12:57 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57INkjlm028695;
	Tue, 19 Aug 2025 04:12:56 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48k5apgncw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Aug 2025 04:12:56 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57J4CqYb42140152
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 04:12:52 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C470020049;
	Tue, 19 Aug 2025 04:12:52 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BF9C120040;
	Tue, 19 Aug 2025 04:12:42 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.150.8.12])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 Aug 2025 04:12:42 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: akpm@linux-foundation.org
Cc: Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, shuah@kernel.org,
        pfalcato@suse.de, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com,
        dev.jain@arm.com, baohua@kernel.org, richard.weiyang@gmail.com,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, donettom@linux.ibm.com,
        ritesh.list@gmail.com, aboorvad@linux.ibm.com
Subject: [Fixup PATCH] mm/selftests: Fix formattig in split_huge_page_test
Date: Tue, 19 Aug 2025 09:42:39 +0530
Message-ID: <20250819041239.167537-1-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250816040113.760010-5-aboorvad@linux.ibm.com>
References: <20250816040113.760010-5-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qMWmbQ09cn0A6Ai_j_mOSLJ5h7QLc1sg
X-Authority-Analysis: v=2.4 cv=L6wdQ/T8 c=1 sm=1 tr=0 ts=68a3f9ca cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=QMRzLW034-kUWS3sVu0A:9
X-Proofpoint-GUID: LlP27Rf4mfaXWxbFPVAWuPF00on4V6Bf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDAyNyBTYWx0ZWRfX+xUG2hwsfxGw
 ops6hgBiWNDUJyuuhWaWgIV2pryAekhcuDSZGQYnxMlCQL73osbzyasdZHPxdtTdbhxJ7mKmyVe
 O8s+ITkYUL1zI6T/+P2ckIt2Ln6o9beDTMXF8kBoCU2zeS3RSCcnUijFubMeU3YsOMveoP0Hpcs
 sP9XZRHcIva7G30tVSgWh9KDwPQ9QDmSLp1aC+zWNgLRnV67Os3MJFeEpZbjfITk+UkTJyaDQgu
 +6KyRK2jdQfsuur++ikjTZYQfMe06lQ+DyDqRKF/eV8sFc6lY4aFqdOl9qnnW6rNhSWwI4HEqaj
 roKv6FecKkjY2Ld1V2Gfx1L8q5XlSidSKXmd3/E2gDgZWenyXrlKnN8QxEeiSF3JgzODQsE2MpN
 mdAB1nbO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 spamscore=0 clxscore=1015 phishscore=0 suspectscore=0
 malwarescore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508160027
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 30488A000D
X-Stat-Signature: mb9t8qz49nxikjp63411dxwf4y3fa539
X-Rspam-User: 
X-HE-Tag: 1755576783-814552
X-HE-Meta: U2FsdGVkX19N/ggL43xEHMYp3mCKcOh738PAzWLHuhvJ2213hKs7ebbViNnhQJBNRsmhvRAvhn2CqeB5+TDWf1b8qoCPJqUwaR3RPoh0GxKTsxEZbBHbl2gFniz65klP/+wZ3CCKyhCkbEYw8XN/pTS6O2/h4U81CdjH1BMb3rSigQSwU3Ta6KNVYbF4QMiMdFL3Vc+FeUwRJqxtJNaqXNLIS07mv5p2oOaHc+eT63tJWIOBUJ8C0+gtwfVlwSLTbNy9Wpw443UGFR/fJswqL0xbpsnZFdhISAYvzODfMrIbs6olodpVhMwKoHNJOkjA+g/wrJWFbsjkAAPHZnxQ5yJAbM1j/DznmDP5ri+puJFJX9tquyImMNaF6AHhAw35Y4ARlJX88NYQUD2V8Y3qnMWPOIyTdGIOfVT2f/fe4GnUJ9SMtF9m56WzV0BHyyvHe8IORdy26axJR+k00XpCWoIpDnzHNTpjPyPmhhd/wFVT+VhkVR/tQw0TYCHvsWQj64b/4PEc+aJGDv194D3QqQ2KLSP+PQ+nRIivwH8CjEOJzPeSdqP/elTmxrz+xqwjqRb7o3BeZkF2pcT3ISXx2gbJ+7e8L7Nf1Z/I0CHukxJ4fssKEGlPBJX6CpX4M2ufPi+oRfpsOf8QSYcJUG3i2bhfZO4zDP1i8ZE8ZcgJk6JHybRMoQAr+c/nLpL07wPCYiEvh7AqM0V3DaioTWbHmCb9Bk/7TYT+UKxLuQNNztcxmemW0v4EpOehTcD89lyftmyEpdUoBDgbCNV7kwwGwU2+fpk4ayQrN7CTqi7+EDNc4AwX4M/5RP4LrohyZ72HXeFfiK6xCoaYFuNrYHxQ/4lb/mRKfuIqDY0fnB00Qts8d7JyxYphkE7wJ7OkgpWHTNv/IU4Grxm46FMet+Mg7YQqRgUJ9utSHsPxgtN3kJks4Qovg2HYUCy2UnDzeFNWhZ4mAKCww0f7prdV+5X
 nsnvhszm
 6ebv+L4fTzMZ8Lp5K4SYRPx5RQh0tXVSHqE2u7VklZUcCDSRjE3i3e/TaMHuOCIhNWpO5Gxzmnogc6z9qdhQpL1rJmXDW8MdLS89GTQR2mrqyHZAEp5w03iJ0YOAAERhzAfDk58pSwxYR62xywl0KWkNWcEC7q9OEt8tL/0teK4cqiq30g9ixD2vO9lKEvXlYrwHC5Y9tZ02J7nDDnrG3F79AEWZ6gAHPQVbcGH/VKqD1oNVJKA5a22gTVkxlRJN8/+oJNghmoQLjsKN6qMxD0LXELzyrgC7AQvV7M2HKH2hsbnLN8gasNm/lhhnqcWvYna/c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Removed an extra space in split_huge_page_test that was introduced
by commit 4b76e221794b ("mm/selftests: fix split_huge_page_test
failure on systems with 64KB page size").

Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 54e86f00aabc..faf7e1f88743 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -544,7 +544,7 @@ int main(int argc, char **argv)
 		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
 
 	nr_pages = pmd_pagesize / pagesize;
-	max_order =  sz2ord(pmd_pagesize, pagesize);
+	max_order = sz2ord(pmd_pagesize, pagesize);
 	tests = 2 + (max_order - 1) + (2 * max_order) + (max_order - 1) * 4 + 2;
 	ksft_set_plan(tests);
 
-- 
2.47.1


