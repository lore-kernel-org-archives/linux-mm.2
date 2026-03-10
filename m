Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDEB3F4180D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 710576B0093; Tue, 10 Mar 2026 05:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AE066B0095; Tue, 10 Mar 2026 05:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 573B76B0096; Tue, 10 Mar 2026 05:50:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3EAB06B0093
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:50:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 124C3C2037
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:50:59 +0000 (UTC)
X-FDA: 84529684638.09.1D1D67F
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf20.hostedemail.com (Postfix) with ESMTP id B0C221C000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:50:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Nx6b4FfU;
	spf=pass (imf20.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773136256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ern5cjBl30ejnsMs3icyo6GwdQeAYiguMsgcL4UcbbE=;
	b=Zww2f1Bbu+RHuA/p0KkHXPaWclNbKk22Yknmwr2JMHC34B7hJFLj6PZOD4igO5MnC3pBjv
	qGyp6OVg949wbAxT9KwPaQWs098PHnkBw7AKPrcvOXosmZrca6YW1huXUkB5mJOZYlgLz6
	g173QMkovi3bmbtIhtxhuIoSRceT90U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Nx6b4FfU;
	spf=pass (imf20.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773136256; a=rsa-sha256;
	cv=none;
	b=twwbydhbMLA3R/PmCHXXubHd2dIsmqBWOjWgPTEPMPLM7nBuc46wUaQBivTTK/o3x43IQr
	BBqyg8JhhSkxlh+Okay+yqnQ4YGxMuj9jo2vHObRr9KhS4mS/RkSRE5WcgJZwowtJ6cnkc
	RSRTj5BqQgpX07/2FoJUfgl//GX9JNc=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A94Q0e1368044;
	Tue, 10 Mar 2026 09:50:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Ern5cjBl30ejnsMs3
	icyo6GwdQeAYiguMsgcL4UcbbE=; b=Nx6b4FfU0CACxYHXSqt/Fnz9FkCMYGB2+
	rTrkpjdrMGNoUiFQSY0hWtIfgYtaZJ/YbmytV7Juw5UV1zF1xYdbgzOnav8oMgiK
	/nHHsp91ttlK02LZj5q+Bu7Cs4T6SO2n5ZoDm5cABqsYN8USlM8UJPPrDU4RpcsU
	6eem2HlKX/ZA5celU/A+vyQjlC8Y3axUyW38aKvKEA7pZcG/k6xjKn2JKJpHKWVo
	wLvwReH1gfVRsDCMU5i73ypWVFzazfqPEe0S9HT56903l/n3uSfduYkCux6Tu6Hs
	5s9Mhj3q8a59fbiR5bVYcOAFProI4XtY4hIFZtp9f6xLb3qUQxACA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcvmab4e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:50:50 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62A7tvcZ015720;
	Tue, 10 Mar 2026 09:50:49 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cs1220977-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:50:49 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62A9olVI52035936
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 09:50:47 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 94CA320040;
	Tue, 10 Mar 2026 09:50:47 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6ADA02004B;
	Tue, 10 Mar 2026 09:50:44 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Mar 2026 09:50:44 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Liam.Howlett@oracle.com, Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH 05/13] selftests/mm: size tmpfs according to PMD page size in split_huge_page_test
Date: Tue, 10 Mar 2026 15:19:23 +0530
Message-ID: <4284688bbec0901d25f88ee1b55c7495fa26b125.1773134177.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: 4x4lI7U0-8crrqN0jVaQkRZRbeRIe-VK
X-Proofpoint-ORIG-GUID: 4Uij6jZphGsCFDVs4aVrarue8oAwPvQy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA4MSBTYWx0ZWRfX7lfsUXSodEG+
 6Ol4r2Q3P4SHZTU2MKXeoHMXzuIdtJVYOFQtPzfL/gBFiz1AZmEdZxk0053e4jS/4/Qmb92BSlY
 AeOOWqv6cTBuSlHKPsVuGmi9uk2mH9NSbkl2gZ5s3fL3YpmSntBvXwk9aewvhS0o93eDwZDg1ld
 22Ehl1ChRoTHSU8ghtUlx/RltsKKtlBknk0c/xkzQUpiPT/t/babt9bFv1f68TT77BwXBhM2bFY
 zvF20q2nY0rjLY9cIV7W1TubrqN2eWWDzqVoMuwjV+VOMqmpOdDpKb3tyjtEdSp2BOhcWniNOF7
 MPE+8paOIMcUoPQeHO52AXw+X6DVan5zYgpOUacRLfjqS45zBwM1WLj+knU2sn9Jjqdw9x87nfn
 64xH4VBy9If/rAt6LverqtG7fjX8mGGW7ocLC8qPT1RyfzGryU6xcb1MpyOvmYHO846xPumd/m1
 XyPgq5rLQePEnyOwQJA==
X-Authority-Analysis: v=2.4 cv=B5q0EetM c=1 sm=1 tr=0 ts=69afe97a cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=2DqBuDyFdJ_AORcY0zkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 clxscore=1015 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100081
X-Rspam-User: 
X-Rspamd-Queue-Id: B0C221C000A
X-Rspamd-Server: rspam08
X-Stat-Signature: bkwnde565bgiscbnou75wqqezxomp83p
X-HE-Tag: 1773136256-327317
X-HE-Meta: U2FsdGVkX1+JleE9Vw3UYZ6y8BZipwzbh9EZlprKeedYiGQ49fqAXTH1oW4bojlfSe45FHJ0mjBmsaosqhdsXCGhjawdJeYEvL8jAl+CRCTJ8gQYYKjOAizISb2gUJHJ9uTHpiTrJGBweS7rz1Kur+JtdVrmNcncl7DLxI3q4J22LaSXHWGF7rI+cS0eeimdWN+bYUdC365a1U1jtgDx9mKMvEfU7jk5o5GoeRgGSJzVVmMGNG1mkbZEhqA75/kej4WiZw4PyL2VRFX9NWwDQEcoDof5Jyrui0CtDvdPECHEHNoFRlloTi5x7v6bgcWD+PQX2G5jFxc2kM5TIgAojAhPPyXfHDFuyOlYwIt3olrMsdtKL4XkDkvZBk/QsMSKYHvlFqymXcrzDa4JRnnrLSFm7u2u1TiP7eQOJiIqJVadDnsVvC8UljRSH9JZ7UQ4XQEPHnmADmumKl0+uG/bcDNrHfzmVBh+RCwDBpjKLxECz6CDkMvTur9bENSq3W6yrj5AUkiqAe28VAuZMjdykvzbKzN9B9PLCXwYns/b7vi6CIK53a2hqfg+HBZ+CJ22kOtVG5Dxrl32rCYm/KRKP4QC3k/IzYDeo+KwYbTvuXbTAY8huepfF24MEeaa4jcB/CCaH29m0R0ZLJtICBNHt/awJ1GO1SQbm1tUnQWR1trna7v24DFSHApW0K453DRfr/JaYQmfuyFfkNGwJPUSfHtUG1B0YKOl6yiZZjn/r84fexmwQxzHdRSF4b+HDK+bRouSUb80vN090I8LJwrwqtHRfPIbP7cp6ht0LE3TTvWH2ibrLCUfwymeq7KKfTzuC0oaOe50qrZpbhmU1qS1iY6jEjGVlVbI0hJIegoBKSrKBppPMOup/pQ+6eYmQIqZaxv/o6MaVp8veJc6q30lXwqwsH0TwuqW7no3SWe1klbEga/Nvuvkm92UHrB5PB0TdB5Ma2byZ56Kx4QXSqi
 ms1HoLjf
 5A/mv9SA3VkUtlDXZypHCs84CXMPTS2xfVup/c7GQciAtMRLfezGWusbCZG60orHLSegr/53t0ijomszbzXlRS353nVsdb9qza6gRpAiMRL102JQN3EfbvKoPrRR2PZ2rRW46Wv1iNVuYCMhcEonmjnQFlok9ONyLC3QrfZwSsONGYmpwvCnn14nd7f2YRSBvbID58qiBhcyIVlZ9ak6HZVZfc0bzgz0N4jGvapes2CCRHlKfh2T66bhr11NnpwpgQbD5Zbd1yFzPLyOwuFbWjDyDUQoziFwAWw3zA7b9x9BgKqi45p/63MENSPru6VxbeSQASIOTNfPIBFeW1yPsruV+A7e+0ogfjqg7QksTguDmFUlwALLL7DleUFkz5A89d/tZ9Rrq8mvzLw2kWWNN1thE4ri7l+YgpoTx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The split_file_backed_thp() test mounts a tmpfs with a fixed size of
"4m". This works on systems with smaller PMD page sizes,
but fails on configurations where the PMD huge page size is
larger (e.g. 16MB).

On such systems, the fixed 4MB tmpfs is insufficient to allocate even
a single PMD-sized THP, causing the test to fail.

Fix this by sizing the tmpfs dynamically based on the runtime
pmd_pagesize, allocating space for two PMD-sized pages.

Before patch:
  running ./split_huge_page_test /tmp/xfs_dir_YTrI5E
  --------------------------------------------------
  TAP version 13
  1..55
  ok 1 Split zero filled huge pages successful
  ok 2 Split huge pages to order 0 successful
  ok 3 Split huge pages to order 2 successful
  ok 4 Split huge pages to order 3 successful
  ok 5 Split huge pages to order 4 successful
  ok 6 Split huge pages to order 5 successful
  ok 7 Split huge pages to order 6 successful
  ok 8 Split huge pages to order 7 successful
  ok 9 Split PTE-mapped huge pages successful
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Failed to write data to testing file: Success (0)
  Bail out! Error occurred
   Planned tests != run tests (55 != 9)
   Totals: pass:9 fail:0 xfail:0 xpass:0 skip:0 error:0
 [FAIL]

After patch:
  --------------------------------------------------
  running ./split_huge_page_test /tmp/xfs_dir_bMvj6o
  --------------------------------------------------
  TAP version 13
  1..55
  ok 1 Split zero filled huge pages successful
  ok 2 Split huge pages to order 0 successful
  ok 3 Split huge pages to order 2 successful
  ok 4 Split huge pages to order 3 successful
  ok 5 Split huge pages to order 4 successful
  ok 6 Split huge pages to order 5 successful
  ok 7 Split huge pages to order 6 successful
  ok 8 Split huge pages to order 7 successful
  ok 9 Split PTE-mapped huge pages successful
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Please check dmesg for more information
  ok 10 File-backed THP split to order 0 test done
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Please check dmesg for more information
  ok 11 File-backed THP split to order 1 test done
   Please enable pr_debug in split_huge_pages_in_file() for more info.
   Please check dmesg for more information
  ok 12 File-backed THP split to order 2 test done
...
  ok 55 Split PMD-mapped pagecache folio to order 7 at
    in-folio offset 128 passed
   Totals: pass:55 fail:0 xfail:0 xpass:0 skip:0 error:0
   [PASS]
ok 1 split_huge_page_test /tmp/xfs_dir_bMvj6o

Fixes: fbe37501b252 ("mm: huge_memory: debugfs for file-backed THP split")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/split_huge_page_test.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index e0167111bdd1..57e8a1c9647a 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -484,6 +484,8 @@ static void split_file_backed_thp(int order)
 	char tmpfs_template[] = "/tmp/thp_split_XXXXXX";
 	const char *tmpfs_loc = mkdtemp(tmpfs_template);
 	char testfile[INPUT_MAX];
+	unsigned long size = 2 * pmd_pagesize;
+	char opts[64];
 	ssize_t num_written, num_read;
 	char *file_buf1, *file_buf2;
 	uint64_t pgoff_start = 0, pgoff_end = 1024;
@@ -503,7 +505,8 @@ static void split_file_backed_thp(int order)
 		file_buf1[i] = (char)i;
 	memset(file_buf2, 0, pmd_pagesize);
 
-	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, "huge=always,size=4m");
+	snprintf(opts, sizeof(opts), "huge=always,size=%lu", size);
+	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, opts);
 
 	if (status)
 		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");
-- 
2.52.0


