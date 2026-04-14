Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B6CAED7B84
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F2906B00AA; Tue, 14 Apr 2026 04:23:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67C576B00AC; Tue, 14 Apr 2026 04:23:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5441E6B00AD; Tue, 14 Apr 2026 04:23:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 406A16B00AA
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:23:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DAD0140496
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:23:29 +0000 (UTC)
X-FDA: 84656472138.29.E2C6BB1
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id CEBD610000C
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:23:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SPOq9MBR;
	spf=pass (imf14.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776155006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91SGkots8hY8yhefJjvScb8bSKAk7Ka9vIM3IAFA2DQ=;
	b=B8VL7TLcw7ox2umUTwq4Cbe3SRN153A13vks+UGqyTfGH7EVozgITSTILwPvO4/rofMzXQ
	KmI10lr1cMBg8EhOQtiPnxCW4sjq7bOUFSYPpyjUL7wE4BN4upur1oMCsdTcC+cLYvyZGJ
	J5zPHQK72Uoz+rkvZqXfZgI0cKSrYZQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SPOq9MBR;
	spf=pass (imf14.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776155006; a=rsa-sha256;
	cv=none;
	b=WJo7jio/ca/jgIQxsMv5F7bOctM7unU2V0TgC5P0RZE9Qh1Ko9C18PyP44Lof6ytI9iMcA
	teagnh1jmrhIaRpA9pqagpCdCIYt4PrJhggwTFvcMsZxDWYR7cFxmf/UWYUuCdrsY/ycyX
	aoiXcC8MHBRUaF2LJcGKlStYfueI1/s=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLIEOT1733620;
	Tue, 14 Apr 2026 08:23:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=91SGkots8hY8yhefJ
	jvScb8bSKAk7Ka9vIM3IAFA2DQ=; b=SPOq9MBRrtseY+PPq/lZQIZTZ6w7NlbUH
	+wscxIsYOfaxHdUbzW+V56nL24HofMt/3X8668FVSTD+v/dCIgeptJ40Iboqc3A5
	fw8HzQxcRUUxXeSNtaQe+hrq2GN7UwscEOjVe8Z5qROXFFb+T0Jjcl+O6FmdaXtb
	n5DRFNRMAcoPwDQ8Jw1WEEb3ZbPRpDKaskYTI0gCuBUqZp0+t8bzNT1JFC4l+smX
	li1XV2ZtKCAv9XN/tJhsfkRBAHFAbxnxBmJ4atHpSU1ZwMncIQdPmbKfShx8pY+g
	TDMFHa/TtxKh1wPJdaa2uhPGAU+qNhxWH4W1zCT158NXdsazJEZzg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89m1pq2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:23:17 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63E4brAi003568;
	Tue, 14 Apr 2026 08:23:17 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dg1mn8m9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:23:16 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63E8ND2q43975104
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 08:23:13 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1E0822004D;
	Tue, 14 Apr 2026 08:23:13 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 044AD20043;
	Tue, 14 Apr 2026 08:23:09 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.39.26.223])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 08:23:08 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Miaohe Lin <linmiaohe@huawei.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
        Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH v5 12/14] selftests/mm: skip uffd-stress test when nr_pages_per_cpu is zero
Date: Tue, 14 Apr 2026 13:52:06 +0530
Message-ID: <395d3477a67919780887afcfd15e49bfe3816060.1776150071.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1776150071.git.sayalip@linux.ibm.com>
References: <cover.1776150071.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=I/dVgtgg c=1 sm=1 tr=0 ts=69ddf976 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=QLFraA1qSxkZgXf6QZAA:9
X-Proofpoint-GUID: K10mC2YQ1iqrMdW55jWm6W66Yak07L-O
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA3NyBTYWx0ZWRfX2fNpRd1TUIPe
 7wta+e6LTGyKs5lgjomH7GQY5o6CU8GnGofm64xce8MfEXjW9QVFyKC3jWlYYuiAX5iHeY1oDfH
 6up+vSZwrFTqhWu3EztD1iqbvjv8w9udP8cw1NkW0SgWIh5SeVJ9OXo4cDx6Ke3qji5mMF7hDPi
 CymIBl8osbPlB/GUnAvX+n9g8jhL9mCArv+p2fxH/MyFgVymh3uuUFSJInretMQ1QFOvpF04UNX
 NDeOBQd+uwrreGh69AIIk40RW0UXnQx52mzwD6qq5ibdU502bwjKIdw209HDh1B+E5AqHSBU1GX
 UbgpwRkcwPsCUqiYDF+zneXe1nkfbcNVbeI0Jt3CA721E/styibVlZjg/UHiSexUAa1/iUulIGv
 /w1ig7CmBMn1CDXmer5WwzKHEIPZ1invI/o2V/bRkKUEs3YuQe2cGtks+eRkKxQX+ZvtufzVIBX
 iTK6bV3XbG6hVp+5kCg==
X-Proofpoint-ORIG-GUID: LSo4tFsccqouHiMR0_Jb0aKF-uiVCRfy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 phishscore=0 spamscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604140077
X-Rspam-User: 
X-Rspamd-Queue-Id: CEBD610000C
X-Stat-Signature: 1kdfgq6gqzyx1cfga3geg7rdfa7pa9sd
X-Rspamd-Server: rspam06
X-HE-Tag: 1776155006-609501
X-HE-Meta: U2FsdGVkX1+JBNXRC6fZjWR3l9Phb/ANsXBH6NbVMIug+5R4xGgR1TCcIgHkyeCgVyFfalNVZo1ORqX22Bfa45E5B4b4IuEFbjsYSt3P2jmnAE7rqrtKPN4rw3BDi8Ei3mCXM3KEmY0mlj0elY2vRu2zigFnSGo62M8Kebjl0SrMj/eESUEfFdKF61WEz1GgBrxg45FznCxBYRA7jXrkru6XidftrPYG0nONR2biUjBy5wwmo67WGi/8EAyu+CS6x08LbbrN1uKSmhm1aBZyCqj/6UvE03mFWi020lSdIKLfkUxr2MISB7cz1vl/luGeY6ZyKgL2cXUQNHpdQF7phRh8JLWzKzcZqB1gWAmC1A+c6alkFhsheWkdbeaVVlHF0BuHuhQuW1Q2o1ipCVWfxyfJA+L1vxysuZf3cT29+/ZzK4zjwbW40aOdWv3LFeaY33nGGvikaS0eI591ipVcHGkHq5Stz6qKAQMvgvduwLPnApH+lZdg9/e029WprFUjoWCEIY1ujl9JOBBLCeS7jKFWBDyik6HRz7dEzCW5UpHoM9FFuNVXKW1/vRKBiJwFtGTKCdgDzK8POs1X7cBBIlvqyvFJ8vE1JZQBAY2HJHK/mxotVhMdcFx2wD5Rtb6gctwfeCSuYbkByDhSuccTDIZeqZnADPNr+wHSROSmbh0e0fEAa04y0sh96rPlD5egqm3scxFRXZ9e43J8Sq9p6bwdDVX8BWvjgJMcVGx9GO8yOl1VEqnfI7JPPZgWzBoJiIXrbPU66y0loshmZyiZvWVvpfZ6L/4XilAYefTQlTAXfUjqODqjOVVGNEycKJErk8c4Q6+5iCxDv/gdfR8DFz6+AmOggLfrNjvHc4TfWLlrArkZ5yx/35u5qjPV/v3ijcwX6TsRcWH+s6AWw2MtxUy2F55iGC1W9dTVSxofDFkXsHy2xKX2BRrM2cZ/uEAlodBzkqNXXcjBkRf3+i9
 9HiS/RhF
 485wGcC0AQz4ZfI63hbrkbW5Uy09qUrQ5lW/SqdlCT/4jAa/uKkLP8qNIxPGx0mhgxVJZBKRko8bLgdxkPyhwhKTyyRm9NDz0QZwVW8NPQO/wgrmOROJPHeAAInOrM7NVHlh9YZveltJnfmtMXQ+rsoKhPqQkx0+S5JaonE9AeP4caPAkSKq7cpwGWSLNi394WZipk1ts+dbuXTy94KHEJC16sT+102jVGbAusI/UQROqIgkjhjUvNInOpzUNlrqIeuOWJHaKsnWJvylzzqaTn/IrifEnVCbOGtKdUFOZHkAOOqAaVSDvk6q9gSKagasFVWE0THZZa+AzxJarj4NqNGTVXpkFHdDCqXh4xxeim89s23Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

uffd-stress currently fails when the computed nr_pages_per_cpu
evaluates to zero:

nr_pages_per_cpu = bytes / page_size / nr_parallel

This can occur on systems with large hugepage sizes (e.g. 1GB) and a
high number of CPUs, where the total allocated memory is sufficient
overall but not enough to provide at least one page per cpu.

In such cases, the failure is due to insufficient test resources
rather than incorrect kernel behaviour. Update the test
to treat this condition as a test skip instead of reporting an error.

Fixes: db0f1c138f18 ("selftests/mm: print some details when uffd-stress gets bad params")
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/uffd-stress.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
index 700fbaa18d44..b8f22ea859a6 100644
--- a/tools/testing/selftests/mm/uffd-stress.c
+++ b/tools/testing/selftests/mm/uffd-stress.c
@@ -491,9 +491,9 @@ int main(int argc, char **argv)
 
 	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
 	if (!gopts->nr_pages_per_cpu) {
-		_err("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)",
-			bytes, gopts->page_size, gopts->nr_parallel);
-		usage();
+		ksft_print_msg("pages_per_cpu = 0, cannot test (%lu / %lu / %lu)\n",
+			       bytes, gopts->page_size, gopts->nr_parallel);
+		return KSFT_SKIP;
 	}
 
 	bounces = atoi(argv[3]);
-- 
2.52.0


