Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D21FCD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 120FF6B0095; Mon,  4 May 2026 04:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D21B6B0096; Mon,  4 May 2026 04:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29C36B0098; Mon,  4 May 2026 04:25:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF80C6B0095
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:25:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 87553120403
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:25:42 +0000 (UTC)
X-FDA: 84729053724.15.F6D11FC
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf08.hostedemail.com (Postfix) with ESMTP id 09B7E160009
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:25:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HTG2SQwt;
	spf=pass (imf08.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777883140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qLoytzKAJrXb86n4y25lLTNIOtZZSNJIuVfwc68Am2M=;
	b=PKJRLSAA4VTie1he2GVk2FzzTktiLJeEot5Ioyth6saxousrGfuWNbdQ3TahLYtstQd9WN
	aP4gQXe6oHdJDCRBoYrOZzsPOxnFPX0+HKHDKJL4iZSh/9LLz2eGDyWXfzI5OO2+fjQSaj
	W0/93dOkVtK2mJOGw8UFooogYJZKhHE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HTG2SQwt;
	spf=pass (imf08.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777883140; a=rsa-sha256;
	cv=none;
	b=LcxgfK+HVf75eDKRpIF2yeyCbj2RnsgZ9oABvA/Qx0GP7KpmNLh7viiC1Iz6YfUODAM7SO
	Uyw6OG468iudP4gC0v8qsoZYcU3Gzh7RL/fyRyk5Kz9XzjoGyeCU/EfWyHgmnI7cvh1eNO
	eTsarZ4Vw2O/g8F0WHzEIBv4Y36QleQ=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 643AG0hO2080466;
	Mon, 4 May 2026 08:25:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=qLoytzKAJrXb86n4y
	25lLTNIOtZZSNJIuVfwc68Am2M=; b=HTG2SQwtiwSPiN5W6yzBbAKYDx6scYfKV
	gmLwDIhBLfYcLDL7h+zkLU5a7AaJqkkDecaH4tGxQ5YKVSjlBxEXUSzhoLEkHzZS
	McgiyEq63g1NubRuMbOQDnGFNz1aHBpOBsBR4HQJ77ew1KoRLvw4rsOQiJfR3oPh
	A9LUQt4BiVCWEhYhv2E0KMHnQ4bv/N0PGccIgJlwmX5oCYmc0edZyVl1TrR9bnq6
	sSRVAQalFTjZbauPRCq7ClGMTfEKvoVtxoi55AWbBlepm+asjBugl0DN3JaRMNWP
	qN747XgDsSj5bUEmD4Z3MXBDeGFyrDHMQ5v4a3qvQDvwGHKVXos2Q==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9xxdwm9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:30 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6448OROa000545;
	Mon, 4 May 2026 08:25:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwukq4fra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:29 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6448PQOS50856368
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 08:25:26 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 22CD120043;
	Mon,  4 May 2026 08:25:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0EDD520040;
	Mon,  4 May 2026 08:25:23 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 08:25:22 +0000 (GMT)
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
Subject: [PATCH v6 06/14] selftests/mm: size tmpfs according to PMD page size in split_huge_page_test
Date: Mon,  4 May 2026 13:54:43 +0530
Message-ID: <4f690c32f5b0948ac50a45a067a2186fbf084ee6.1777877814.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1777877814.git.sayalip@linux.ibm.com>
References: <cover.1777877814.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDA4NyBTYWx0ZWRfX8upt1mGXYHKE
 MshnLX1JyyFdq7QysKpZ0ZeAqJMu26Sq4W0sAqyDfSDtYhLYtTMs6bQTuQLNFJnFcKbcu+YaWmM
 qlRRwPQ0jan6CDJqI31B+WBGr37ElUiBBpe8GnbpjxprW2LMpjjT9N8cr6wQN9svbVx2xJRYoHT
 bddLCY4gd1kmYzfEvEJe2u9gdxEv3On1MhNE8+0acpjdbvQmS8bZU8XTUOw8dGlwypKWox/rt7N
 9hbieWuZKKDTHv9F+TSiJCy4qYVtQPSw30HV8X76qpRyz3Ag1CCz8jP201Hb/nq7PQ84NemMqA2
 D2kLT/m6o1txTgBelIYqdTqu3emPcXjFOmdxVBHspVon5YdJWBL9DFNvFaInqkMWyJk0QuG8Opk
 v5bnQjVqUCl8sYI/D7W3b/g4Mz+BeNcz3VBWOKC8V2LgrVTS28NTyXt7PyYByRKD4XfaoQ+64nr
 ysvYv/P4SuTvjUYTUGg==
X-Proofpoint-ORIG-GUID: HxJxplt_wNg9Yf6gWbjzQPxjYGFJPXxt
X-Proofpoint-GUID: Y8-BYe3-MdiAjFE2BGYFKeO53fCTVIgB
X-Authority-Analysis: v=2.4 cv=ctWrVV4i c=1 sm=1 tr=0 ts=69f857fb cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=2DqBuDyFdJ_AORcY0zkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 clxscore=1015
 suspectscore=0 impostorscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605040087
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 09B7E160009
X-Stat-Signature: 7wi7k9i5kmwkw3bb5uqwb4jcsrkxn6t8
X-HE-Tag: 1777883139-221312
X-HE-Meta: U2FsdGVkX1/nzRaNKtQRVfCXeVTVAWHlf+X5A7xsZ9A6R5oTlJdjNdDlf37hwLbXzlrUzKH+TXRtiGM4f1CSIjiMUV7cSAOl0qfYXxSUfzwLHm6r6F22TRe7cbDGo/EPANInuGq15rZxuo5tvHuPkIIU4raQSKvqwtKWMNfrjBcKsjuwMni9fPidnxtYBlfWBb0eF7QEFg3dXyduu+7N4FI4Mp4UFvVgewOB7TLHucehhRgOLag47o6LYUV+UtyDm6haPDZJxLxdD9hOL4+h/yaqadH5WaJ/7QUvnqnXZ2TxsRMS+1BPJUg0w70vVnFJ6GhWdRJ7FLnefiQIQ41wGtSUNkDmYCZ72DQe4CJIH2q/cbsoz8qgvtBf/Uipjhyvw0+uL0AzSvxqWXEcx6Zd4nOHwQr5gOVOx7yce0lCxhYFrCX/uB/MFCCmwOG2LHKQuMnVr4aBpWqGk7Mn4R6mk0s29HJ5sVEjQLkfdjuoVD8bQxG2vCRC8KpoMUJi4OnTGqkb2hi46V6rbcBtlBkCNjwLkCVek71CrxVaGL4L0tTp9e7IXmssGxHfAvgmbTHKZoGbTPtV97TzeAFrxDx5/KN+UnGk7xH8Q8lt9bZpImnmx7leIhsdizJOa74oUjSMtAg6fCxnN2qpmfX2lrYty3aCg6TM1QufVJqxBDLEmMmYBAJ4pwakUWRGT59L62ossNPK/hp3vHAC+wnE9cz6izy1/f/udxwRpGYNag60aEFa9M1jQBG7amMWz70AUZyNYrDh2mjb62eYpLcyM6Q00Bn5bXJfxyKaEYXG0iu503gixv4cYGkB4yuHJJV7SHxVdVLEFFoIuNyoGgFFRlROHS2awMXlo8rOAo3qi2w1JLUgewJa5F6bnUKq9NspL4/K30K4dEc2amH9K7PQVTc/d0qJq9nzq7doHdyfAv0ccVWsbZ3EgmRRhNXM/66vNf5B2QfntUTAJ0H9Af9Hk3p
 +EVcAOwv
 2a2yv7VaL68iSH8x1dKXQB3Y/fFhrU9TjYTlcU8Y/sXh1tC/t4O2MasI5+12rA61cvOTWLer++22HSFJ4mQsK8+AKA9Z3KAoCatoF1xCzgZdvSjbV6bj4XD3an0+iVmuBuK4p8ATkZITmm9eEvc4wv0bQOOlQEbeomqLWpcpiUse7bDUPNW3WG+zjIq683ecBCd6QqONH/1cIP0z57cEaEMmeOxSD6WAz3MV4nlKYOK9Y5gvVyKjNzFCRBF83gZvsPjxg3Pz3Z7KeqY8kzQ9G+bMBBHDLTSHGm4Ro55Q+p1UkmuRE6RRBok4JYexbs7OY2AXAR16vU1UsyLvIlP7XeUtP1diZiXNTkqROLV/7sMCHyM8juAkP+emWF3ZE6orxCHWqNFLKleA5/1au3wlMUcNavwyak7rAEA90EKeduc8Hm7eJHTVEsrrQzVF7Eaxm7mAriGYcr/Q1OTc=
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
index 500d07c4938b..02938f38b880 100644
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


