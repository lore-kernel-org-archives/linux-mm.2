Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 453CEEF4EC2
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE5DD6B008A; Mon,  6 Apr 2026 05:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABD726B008C; Mon,  6 Apr 2026 05:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC9C6B0092; Mon,  6 Apr 2026 05:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8779E6B008A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:20:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24211C18F4
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:33 +0000 (UTC)
X-FDA: 84627585546.20.7A7B473
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf10.hostedemail.com (Postfix) with ESMTP id B80D7C0002
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pgl+hWjC;
	spf=pass (imf10.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pgl+hWjC;
	spf=pass (imf10.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775467230; a=rsa-sha256;
	cv=none;
	b=Luj8lZpdux6iuIwfYTB0yjMy5tLrt2NN/AmWsYBRGuUFAcvdGE396UoK7U0BMn9s9Mtan1
	PPfZLcwgjiWKwtii0cywzadaPZnhs0oco8+nKAoDsYmmtOBnbfvX5TZ50xo4ohshfXSA4Q
	eM4fdyJYE12/VV5M5WjcnXzB92eAlrI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775467230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KF0duKJ7kidshxIeQZb5EcnjWw7TF8XQDpz9/tTREjA=;
	b=G/ej4ghoi5/0ZbI/lyDDqZSNLsknP1kYKmR0lceTUcvxQ4wjLqJciPTf0z3Xx3uQpXfxhX
	c4/blL05TMwC4JHDfJjR5o4A671Wp7GKoNXL6HdlGfNwK0LvpmrNhHsDbeYWbmoc1/JLxM
	RxCjw/T5bY3EXQWzjV0YpoIyckHYAE4=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 635GjJNf3103384;
	Mon, 6 Apr 2026 09:20:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=KF0duKJ7kidshxIeQ
	Zb5EcnjWw7TF8XQDpz9/tTREjA=; b=pgl+hWjCPThXudeYR9tfUEanv4t9VABx5
	K7L49v0Ijr3/Y6B0+yXUOweqkNUX7yawJMbiWNyYlbTXrAxcEX6DdwXILOvfch31
	/MO+suSCBFVTAwpdZMEIuz//u7OhUYsOqBxWFBfBRCrvYRzJN/3nVlbuDFb5FpSg
	Thdesf4Jt45KsHvI1CjQbYga76s6wupvEBcUJ7kAr8muqfEFVOvf5XmvN6okydQP
	1FEbvzOoisB7STlX5pfxOilLkeH5arOz8JbaZ70huH+djqHyz11/57zUM1EXbWf+
	44bnWS5EMXfpGHJDprklB0xaAKYfvMbmvJkYwiMeJ3AiSgEb+pmEg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4datap5vpp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:10 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6365wtoS020570;
	Mon, 6 Apr 2026 09:20:09 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dbdync2w2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:09 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6369K5ZW58130846
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Apr 2026 09:20:05 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7B6B72004B;
	Mon,  6 Apr 2026 09:20:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 27CE320040;
	Mon,  6 Apr 2026 09:20:02 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Apr 2026 09:20:01 +0000 (GMT)
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
Subject: [PATCH v4 06/15] selftests/mm: size tmpfs according to PMD page size in split_huge_page_test
Date: Mon,  6 Apr 2026 14:49:25 +0530
Message-ID: <ac04b3ee7d733798b4d79c840f4ce4e94118680c.1775466329.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1775466329.git.sayalip@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=Bp+QAIX5 c=1 sm=1 tr=0 ts=69d37acb cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=2DqBuDyFdJ_AORcY0zkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDA5MCBTYWx0ZWRfX2nir+uOPUP7V
 eZy2CrCAuQTPd0ZX4DHbX9TeMZGTzN19LAkyMfPR65NLBAUX3M4lZxj8QnNFSQnBavANHHy0sR6
 rA2GOJj0UwXfz8KTYpcCAap76u19I6lfy9D0I/p18ffEB1VD6ZRJVoB0jo6EyGB80Gz/4QcwzW+
 hZO+VcU0itWGVa+KCdx/sTjdnPkFHtjeg5/VNhIbVqNHe+SGNno8L+m8Ikr1PmLjkoZuagqR/sO
 whfNL4oSEZV1DmH6pjn9DIhIhqUc+RALTDoAff1kQwx3WfD2jOyJkMR3kvOPPC3HF5SYk+aYTM0
 F2VoA3YJISHLdoaEY06QPw08Enu1t5cTAT7kZBH0jzvKe4+V8dMySsk000zOS9V10BadD4dJOPS
 GiKxdOniY1hnrayo/gQ8lp2dJPVyGw9S4K+QN5qJgsXKhSca9kj4KaXUWqqryhrH7ZNz+Sf+913
 RTEn368WkY5OgjBNHsw==
X-Proofpoint-GUID: CX7u1yjqQVtEQ4iW6KqbqUiUpJyD0NDv
X-Proofpoint-ORIG-GUID: 7FUqPZYTnCHDzchU8xb7T7f_019zCoNA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 malwarescore=0 suspectscore=0 adultscore=0 impostorscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604060090
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B80D7C0002
X-Stat-Signature: pb6edts55ya8k16nauefo5heuadhook4
X-Rspam-User: 
X-HE-Tag: 1775467230-123582
X-HE-Meta: U2FsdGVkX1/bztJkY3b8rCBCwPxZvf46GOYmvraptwwG5+JsjUopt0O8NUWNWvXsVqIWINqa/ougoUT0SMHlOMZi1RUY9IUsR5USiqII0xrYBu8tvEIwp4ZniNtqrAMlUiczY4je4lHNNh9z6M8RTuPSc8DjbWYUg2qZTdcMi+TZvyy2RVhyjHJluhx4rbqUyZtqa+ao6ClryNM598dkJ/6pUpAwY+ntFBsttCkZHp6uP8W/g5I86julylz/lX+YfLCFTpJuTWqPTuI5V9ELH5yp2oHiytfGIySnFqoWjmweIMz24Qc5T1lWgx32nILA/vVvv/c7+SrfBYGXI3AsdDlrPF+2liu7sX95PoQWUAyYpoqt9TG8MVysqdMSQH+MnsCRg3lLuvXzMVSeSuAxGi9/SGN/hBD6dAXG+NmP+twpB8SURmS7LRhCM3V+MEJCbBcmU5mYcudukikmcm5elpq/dtAhj2u8zMpzCbrbYNo/wenRfMWQ7zQkTmCKF+Uk1CwCsH9+0Z37h6NZYfIl2P3WoQgMadzvMV8Sw/vkjHKyOCGCoc9HTevYw47WWhlNgAQD8v8mZPx3vHIluBd+G9FloqKwWRXSG2DEfBUq6pycABgGcasbFoksdAHHMtZJuISDtT8t/tL0T+2YRkrjoRciXogyGyXn7s7xOZVwCh9DwAtH1CymC48kU9RcPtKNNA2JFJOO28PaH0T4ILCGGBFijz3JGxudzHU6yKaRReo0HLasiz0gx+NU8N7IYpivf7ZbM3o4hDP+SxlvNx5c2GQuYlGEz7FyruWf5kxC+QruZVVGGyOaZNOEGnlmbUA6sujUU8TVF0trpHYwJQKBeZz1Uc2XR9UXGNtw5FLJ/rLfWESElBvq2LzCNiAbe62Xk7pHCVQ9TCBNLLNfPsJp23VFATaVEqeP9NPdxk+QlWMa5tQKjFvfiQ9VTgdXuQuxwqFTUkbke6Z3MBsn12v
 Csdfh45N
 StK6NbhWpwDwWPPuzAtekbcQEIs93nqLJbepiKB99YTrrSSDMWZzjid5LuBmU5L9yduIy9D5WcQ6z0p/GQhpOcAh/TMRmuupx5Tv2EgAlddQV8/HhVjeudyBqqLyXKzs1Y8521TAZRE4J5IRabcJsUHDvlOhsKjM++6DGYUT+JK+7l0c0ySKenGeUpVD6S2nEnkKRorD+Xhu8akleySlBx4IAiOkOzW9BSsFGbQSskStrZEi4+c95Adx4mV3itZ4NcmOAxLCGIJsgYLLc6ZKkvbkoxI6UEGqaMhr5JcLEG12cSMYt94qyAFgFwX4iGFH2TfJe6zXDBh24yT5n9tzW4g4MKx0L1FQ+OgVAEm73l1jpLOk=
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
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
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


