Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E245CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 06:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8338D6B0095; Thu, 21 May 2026 02:48:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BCC86B0096; Thu, 21 May 2026 02:48:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638856B0098; Thu, 21 May 2026 02:48:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53E296B0095
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:48:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DC00160E5C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:30 +0000 (UTC)
X-FDA: 84790498380.19.E2A0B56
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id C23A61C0006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=D3S5yZb6;
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779346107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mtvzoiAxbgnkfrp6PscCj4WP0YSbVNRNiGRRDhh6oYQ=;
	b=b7nhV+SKCtdd9aV5K537luKd+F49Rzjs7rl5c0IrLE6E1qdPQ5JSRyRdW2HfHSD5hHUnI6
	Y/4z+AXNQCvttMp0WkbHGeIwl15/VqbZyORwmbBdtuK6nTP1EwjWDu+40V8YOY3x9Bc6FN
	pU24J0XlrljCKs+a0hFWQqbZQMIz8GA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779346107; a=rsa-sha256;
	cv=none;
	b=Ood8t4cxkR3m6cW0QmCFpP4VEU/KoVJfVzQb9+H3/ypVoSRc+8i8d59+nyNUmQZ9UBKlTP
	TD0IN25PRhR+on6JnKxSX5vPKoaw8x0qRjRTJ+1FDobWr93+zNvs0hDXIa9ICG6212FKpp
	CIzaHzgJG0WuxuLmyrJ6eCHlUNlSFi4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=D3S5yZb6;
	spf=pass (imf21.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KJBE2b2735197;
	Thu, 21 May 2026 06:48:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=mtvzoiAxbgnkfrp6P
	scCj4WP0YSbVNRNiGRRDhh6oYQ=; b=D3S5yZb6D9RVZAJbTgVLjaoeF4LmeNTY2
	jFy3mg3DNVsQpTX3FPSETGGUzBX51j74CAwd63gsLvcn/hNlbVE7b8pi3sKWz4jo
	B5/xj+xgH1D1omtIg03N1apo5l+IWZwuaC2tYgS4DoFskzTobQ65x4N6356dDFD4
	nATYohC2tya4N+QN/DqhTdgniffLWl2RS8Y/5UytL91dZ0OXDY5qGnWf41cL13eN
	4JBXnUDGn4CM+CYMivOhY33W4qUDJi1B4EPE1IGK6iY0yMUTr55axX5QsMauUnYu
	JUEuoMPT2QYlOPbKIvy6AgQ2TaxvTYm5/RpBnJLTsHKrq2fLvH5Kg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h88mcd8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:48:15 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64L6d6hQ018345;
	Thu, 21 May 2026 06:48:15 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e75kyajdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:48:15 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64L6mBQj49414406
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 06:48:11 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8002E2004D;
	Thu, 21 May 2026 06:48:11 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5FCBE20040;
	Thu, 21 May 2026 06:48:08 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 06:48:08 +0000 (GMT)
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
Subject: [PATCH v7 06/13] selftests/mm: size tmpfs according to PMD page size in split_huge_page_test
Date: Thu, 21 May 2026 12:17:46 +0530
Message-ID: <33e1bc10753fe82d1217613d8cd496020778cf2b.1779296493.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1779296493.git.sayalip@linux.ibm.com>
References: <cover.1779296493.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: mDMVzFjnYJc1JdZPKPQtNX6Etc6MavDN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA2MiBTYWx0ZWRfX6cMxuM7nd47K
 MsrK6X7vjHNPqH/gfxfH1Br1ClZCnimb+XXLJI+6DaCmTzDuhUpQPuUbtmh7yBcFm7AC/Hm4ZV6
 iqVKgBOiYynV0IIjE1mJS1KeGf9pIAqB1Nimd4Z8fX+AHkkohtQJRht0OVp35avDt2I9gBVcaei
 z1tiYB7Jt9CrmO16I2AXvjdf6CvCUxSVV0fKOKWB3qGp2TN/P69tn6OjUPsUs/H+RxyP5O7itU6
 BGszVYp53aOgnRhRhvM3fVY70qP89+vKKvuAOMHxmPzDXiELNhqlUyWay0Mnoulag4x8nc1JtAf
 ovpEsgiha158K1wVMM35sTycyapJXw4cmptFMxQQ1+c/vKEjS8eMPZ11jP7inVgML8PWmHwSnAE
 vMdY4Hfwt4e8xm5NNTYVw9JSPScbCQ0JG5qNn9OkVOkZ9quuBneKaZdcBCOJam3yA6WacKukz8d
 EL5WN4ns/byyFIcmBFw==
X-Proofpoint-GUID: 7OsTwujtcS76igdtvXCRZzwfhYTlJYbk
X-Authority-Analysis: v=2.4 cv=apyCzyZV c=1 sm=1 tr=0 ts=6a0eaab0 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=2DqBuDyFdJ_AORcY0zkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605210062
X-Rspam-User: 
X-Rspamd-Queue-Id: C23A61C0006
X-Stat-Signature: zs545szwiok7ajx93t8eydgft5j1tcd4
X-Rspamd-Server: rspam06
X-HE-Tag: 1779346107-249439
X-HE-Meta: U2FsdGVkX19vX+kKjdypQ30iNNH9QCHVhUTJdJ7CgFPgMi0q9Of3R6ETUfm44SU037v73uS10hnUFInx0/RZ9d5a4JvhdKMwHOw3MmIjVAn6Yv+Le3UoLVCt+lRjiofAlrAvXsF1s2NQBUt5Wn+YT43GLha5IuOLEY6GbWHiSX2ZpvQ/M37cHlRzuXRefHntXZ/bC0X3scK77JN4rFYAXCNlw2bvIvZHVfMhdMMEKbXiUpkKZb9BqrlXlfaJXDLC03fvS6UCWjkwptwqw9HwdseDSKJ7IdV5rGdGPUydKcBDZ7eo97oTGZdcZq/FvV4yL5rNMOFt3++HDT0w3vDYD7wgodcj51nKZmp5Bb67sX0EsTx2xMJkF7fjV/ItVRnQIlqTw2tO1ZSbE2F9dvNOBPdKXTCaiDXtlT2HiWV7fsOMUsQleh8w9yKUOzriCzVBNCkPKlwzaAWHCzU3NFpLBZ9pBRY0S47rJ8+4bTPFcv+bVrxPMOwHKbVDZ0zPcD7Pl+SHPiXQWwW34sVEBUqc53k2Kf697ECIKOUfqYshpBpSha5iOrfmcuRb8INdGBCPmuxNboqsa5NQOhjzEBsorNrbza/5LSFuTgSYEgj+D4LHzTCYh2tO/qAUsQh1I4lGeRhIwXcAHTij8z4/wZYc9oNesKV5E+6VJIIMH7QkkZiuBGxurEy2YFHM4NIcaXgKUsMLNHNTC2YCnOn5k+M+vdJ+XIhmXeNK+CihLMPVql2pLGXMBscipZL1duqKjZ7dODEiatBX9UndyOd9rS+4KqHJWJ4cyCTnoJnrHXRM/bfFtKalcIxHBqBE2ffi/40crG57herzPe++l4buK+SR3M6X5Xc3nbJ6CO3GCSSR3YJrhC9YesDGSodhw4RAuUMsqtF2iCRueC53evomTrnGuCicijd+gFVKDmmxZZFBPesgAR/mhBxz+qa76K7cVV70268xYiPn695VCpW48zV
 x76mwgDf
 mSOJMVAlOjBY2HkSTSh/wWeGwkyrZlOW+5wl9UUwIkHic4NOHQMulTOyz5v3ercthuF6/lcMZXoCBVzHTaQzKsUIifUYo6kW9nMf0xzchNkdLE+khzmujCDfPipQaEfq32mczBtPz0hVIm6EiU7RP2eaWQ49l/ehhp0SexH2VeSg5hddNrAQpOzmpd9yxEW+5AXINO8J1WNwvpV8TsQD7f4r3yHnGq0boG43LhhZewqjfxR32D1Fx6bT3LHiZqBjr7Ugyo+Tceq8qrJZ+DiXr1QQJgWFGtXrep6lmDxQOPEApVLxMnYxUJ6lNerEyPdV1mbdz/L/0oam5WOm1cTyjqB7rihG9WLz/MOldeuaIjsOaF31Gs3s2K+Nz6AiUhad04dSkGEP9/3laTpV1wz2flfQPwPYRMFKyY8+s1X1nNRtVo5iYP8MzgpvdiBHbO3uN/K7/nw2zsA5CFkI=
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
index 50c80ceb4988..4066de6e8ae0 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -470,6 +470,8 @@ static void split_file_backed_thp(int order)
 	char tmpfs_template[] = "/tmp/thp_split_XXXXXX";
 	const char *tmpfs_loc = mkdtemp(tmpfs_template);
 	char testfile[INPUT_MAX];
+	unsigned long size = 2 * pmd_pagesize;
+	char opts[64];
 	ssize_t num_written, num_read;
 	char *file_buf1, *file_buf2;
 	uint64_t pgoff_start = 0, pgoff_end = 1024;
@@ -489,7 +491,8 @@ static void split_file_backed_thp(int order)
 		file_buf1[i] = (char)i;
 	memset(file_buf2, 0, pmd_pagesize);
 
-	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, "huge=always,size=4m");
+	snprintf(opts, sizeof(opts), "huge=always,size=%lu", size);
+	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, opts);
 
 	if (status)
 		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");
-- 
2.52.0


