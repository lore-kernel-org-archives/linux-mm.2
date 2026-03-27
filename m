Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C30C310BA432
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0215A6B00AE; Fri, 27 Mar 2026 03:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13E66B00B1; Fri, 27 Mar 2026 03:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E03406B00B2; Fri, 27 Mar 2026 03:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEB6C6B00AE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:47:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9751E140FC9
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:47:57 +0000 (UTC)
X-FDA: 84591064194.28.1F027EF
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4B5E41C0003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:47:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=V1K4qbXS;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774597675; a=rsa-sha256;
	cv=none;
	b=q4MHirbkWQynkZ67LWwOYKhUworFDeFApbj+haRKwBgTJpZUG8Np1R/cxBznzZhC+0AT2p
	gLuzykwPWYu29yDC8gsb7Idv4ndCAYhdQT+Dd+laQUVTGxIV76sjQzGgPJ6aHn8fJUkR93
	vqu2CoZ+Gmzg7xQSwQQ1qorV2aHwbNM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=V1K4qbXS;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774597675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QW9PlId4/hTy4XCvWaXgJ549gjJqmRI2LMC+p2oKhag=;
	b=Zy1aWtUm6IKt4tSPgju7g/aYrMbhVw+4/N+d8E9K3FtyN4o9l2bBY0MoEmSKAgxuh8RUG+
	CVaqRpYQFj52uaPk0sbXUFyfSF7lhTw2J/rc/W4M1c2aZukVoWw25zbc/h6MTrCmX73I20
	7NaxhQObZceCAAy2JRn5MfAGzK3ZY9s=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62QFRomM1566113;
	Fri, 27 Mar 2026 07:17:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QW9PlId4/hTy4XCvW
	aXgJ549gjJqmRI2LMC+p2oKhag=; b=V1K4qbXStCzafT3nrCz8e9yGqCH6CjayA
	9FEe640fmCahqsP9zn6TEs/iSkVdRPo0l3EocEdgOyd9lUz3WdS8D5uv0tRhCZ3G
	dODQDQvVKfeepaJkSB6TM15KF7YmkoWAD+KDtrej713mm2arPjFI5zXbCQwSsadY
	6ONr64kvdZ6pMfonQwiiDPjkMAwi+YGypzZURbZ2pAwEZjlVc3Rr/lRxNFH09J14
	lGj7drWFLNK+86kiX+8Bxv1udKCZONKiZDnKqil50xpqoHqXRtjLU7plvXvlB+OP
	RVcUUE5GDn0LMHalAOrU9GPtVVfGm2do5UlTrGjeKgR8QD/if9skQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1ktv7usp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:39 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62R6Y9e5011788;
	Fri, 27 Mar 2026 07:17:38 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d27vkeaat-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:38 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62R7HYDc25101004
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 07:17:34 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 581E420043;
	Fri, 27 Mar 2026 07:17:34 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D158C2004D;
	Fri, 27 Mar 2026 07:17:30 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.124.208.5])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Mar 2026 07:17:30 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Sayali Patil <sayalip@linux.ibm.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH v3 05/13] selftests/mm: size tmpfs according to PMD page size in split_huge_page_test
Date: Fri, 27 Mar 2026 12:45:59 +0530
Message-ID: <2fd965ce641d32a759984943a427fde47d7c3b13.1774591179.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1774591179.git.sayalip@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: CAjcffWirCDW10sWSpn9b-OgwYt6-wME
X-Authority-Analysis: v=2.4 cv=aMr9aL9m c=1 sm=1 tr=0 ts=69c62f13 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=Q3urm4FTTvKoMhOPgnYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDA1MyBTYWx0ZWRfXz3npW2ykWglj
 GV4D9XvB/SylIfBfFw8aeSo41t8a00wnDlYm+DRM+Q+O0tWD8S3f7iMfB9mb5Gf2ZHI7O0QcY2N
 8QlEYKKWAHobCGZNIO6dhinl/g+niYgMwoB2H3y0aLWET2P1xRKW1sNe25TfST43Bq5RR9Gjii0
 IElD5cHwaIXRMKXyRx5VFfY1FFxapYsv9sYXF3DJY1rMA4eHFyD9JO+305OVRRI5GSyqSrXpKkc
 g0JXENZj3rqIjWtXIkzCddgzD1a5ajt9vX/xlNGNTwT191FNpsqAQ/w6x+Q7joM80rvfBKx/dSn
 dCT4Oqx5dtzh6lYRzVhOOmF+93AUicrktuDxH0jbNxFWcQ0IedDQnM6bVYppTawSkGqmK1N3KqW
 X5/DqoSoAk2UlnZhZ2FaLslvLqhWH/mXFRJ0jb1TANjD3ZK960fHsXPtoH+I51B4WYiEoelInAl
 XBtlQ/OVN8nCWbaujgA==
X-Proofpoint-GUID: vfxFyI9pYF041gxLRAg-P1g5dxDPRABz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_04,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603270053
X-Stat-Signature: pntze93e81eikxgnbjpwir8ftwyk7x7k
X-Rspamd-Queue-Id: 4B5E41C0003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774597675-205105
X-HE-Meta: U2FsdGVkX185YPEJ7SnbEVzcR4fQOZswoX5j9xpuKIO7DuEjdM4FwO4COLqj8qv+EIDfeyDPpsL2riUGfIQ2UgfN0Kb+8ZsCTXqkCzMdrW3znTfIAyLzhVlXnL4rBRW31WsSayYsHEoM8DbYxIk8Gs2Cc7A8rKTC4iyF5Jb5Zj9105dzJzA6ZxH6htfWyflthGGX4DAYfyWWyJV/X1Qh6Ql6o/eSCYVRVYchIbp4wiv2O4zvvuxO2xPoY4Yq/sGUMK83wHvhtAbVhlk1/bKYECdZ8IVhCW7Rtn5cE9dkDS/JOdA344QVhxNj5Nq1dYnZhCK86VrR9Tl3pSOVQkocu622shvOz57felym3WcKEQMUr7hrkYLum5PNuxjTsg3l8xiNSlySRWlCWNJQsjCCv/gvSJCc2RjZYNNA+l0SRaMT1YlCZZNnQJd88A3KM3Og93M46STNYD6Ug6yEDvbAL5vcmLoGIdRKJ1+Npe1ABmcxW8WgbR9fzqzl1+5dOsrU6afYLZidmRPJiFLNFXcaBR+/3Pbu9B89x3EVp/RFBZHPOhWm/diQHg0T5hIv8n5DtkfLXd6ARAHXsYVSg4afe7n7yhEPdKXrdwEYsKq94lnU0LtjaJjGTUnPC0VEAN6JSOjGtItsriRDjfL4uDQRlA8szc0yBKIncMK4qcAgJ8Dia4V1VDoa9oD4/KdbSORnTkmtbl1jdntYYTpVOKLzMHTraOs6UwAIVyNsdVWKMjMNEgml7eojmA0K/ZfyZz4bnJmj5fsPAVnORKc7o/BXbNQjNCK6asnWdMaaoEi7IO+xpVJd/pZbtrFkbGC8VEPFVOI9ev/R6hA73GeRjs8r9FjJCJmT+is2A9Pot/BpTWErXR8Bp43EX1xkoc0wtQe4rCJAi+8NzEVLAJbIBJdI/yl/4HpGMCLpbuNnMlzddGPZS3GHd3swmT6ab70/qSqnkMI+VBJGtJIOnomLX0R
 6t4PjAuc
 Q5Sb75cRdMD2gBcDGEPsUB4EX6eY9O+V05E+LIsP0n1SMf1HRzR5gyD+9DdsHLMA9/TkgcgTCEEnlB1VNtSgYy+d7mjmvIT7fxGSZxp3lpkjYkcNxx2Z+ODc2nDgKbwloPUcR3sgT5bDKNrGtnEH528bupDgzG3VyepGQzgwXzHIMEw+E6b0IAtI2/Vi/SsQ7c5+obm/FVxsEofIdR5Zut8i7J9cRDWt1DLc/kvF5sPn3ZIt8B2hL4shKEdf9/U2R0etkm+g5FzUAXi+l6XIcmnpHJuq9f/RhE1UKNPi90NmVfE+W4xleGm9m5NV7u3qfmonTEcr3nGcEgyARtfACXG4Zj8bY64pkqnRWbnPLgup4Acklwxv1blYZ+1Fk4q4szB7kHQxrQJwqD6b0pz60iSNZ4Y+9XLhXYFejyZt8HoHmDxKWLlcnoi5iJpASbZOMzsUIOFfdi0Af2HE=
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


