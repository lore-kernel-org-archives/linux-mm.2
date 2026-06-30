Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CE30C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 09:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1389A6B010F; Tue, 30 Jun 2026 05:33:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E9E26B0111; Tue, 30 Jun 2026 05:33:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1A076B0114; Tue, 30 Jun 2026 05:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA0726B010F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:33:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 64E4114040A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:33:14 +0000 (UTC)
X-FDA: 84936065508.26.FC29E59
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id E7C3514000C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:33:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nb1ipQZt;
	spf=pass (imf09.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782811992;
	b=GRU7eFlVNX5Qcg5xq9/7q/yMBgb5hb5e57DSRqWnuYAE+LHHbgUkgQdbll6YC48Z3Hq7Ru
	zh9ItnDLa493kLSUQ1jfT3s5UiHGvz/IIuF4cDDcQ0kptQNg2YAZivgCqGqC+3slTMz+j9
	7FShS9tplnHrg4YHu9+61vKTu974ClM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782811992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CuWuZbFd5cy9VxUgXbfMs27Q7qYTzAcGtHe14pOZImA=;
	b=L09ticzA8oWUy+C3s6RwDz+w9ywyHT/Dsk5zJonECSkP+L44dXJhbNQJTtfOZCJgqeZOkC
	QoxmQCN5kx0mZ/p3UyrA2E9X7CvCr6TEAjCIJW7Sq/FSrFd0oErbke07gik4Pp54LgD7+U
	stJ2ykQMaRMCu9KmdgePJDzmoPPgQyw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nb1ipQZt;
	spf=pass (imf09.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65U5mJhT1075861;
	Tue, 30 Jun 2026 09:33:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=CuWuZbFd5cy9VxUgX
	bfMs27Q7qYTzAcGtHe14pOZImA=; b=nb1ipQZtXSHw18KSgOfDkmviyHITBs+cR
	XzVc+0nEuNJr94iOOybBAdz+TIDsmuAcWxbAmPJ+yI+yoh3N5qvwUV/9cd5da8PF
	eRiU8pto03iA62g0Z91OraxA1J013tXbxSS6vSwVTTDxoLpMPRU1J1VsNKP+ylB0
	3NdyqNL+j4bfx2eyvtKG7VonAH6vB9XEOpFMu5jmoZWCBw8sgq9Qzjk6RFzyyLBT
	GLFuB6twPTjkfFEJ93FBBnyiCqxbU42vQvOoXcPgrk20ZVwcKIKMzd4UPzKQPxjI
	371M3/qfYx+TeXEdwLgiCgwTPd5w0+MdHVwRZ9OoPxLzKtepeDbzQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4f26q9wnr7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jun 2026 09:33:02 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65U9Jhsg016913;
	Tue, 30 Jun 2026 09:33:01 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4f2suk1fvp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Jun 2026 09:33:01 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65U9WvqE42205562
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jun 2026 09:32:57 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5BF4F20043;
	Tue, 30 Jun 2026 09:32:57 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D0B720040;
	Tue, 30 Jun 2026 09:32:53 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.39.22.200])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 Jun 2026 09:32:52 +0000 (GMT)
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
Subject: [PATCH v2 2/3] selftests/mm: fix ksm NUMA merge test for systems with memoryless NUMA nodes
Date: Tue, 30 Jun 2026 15:02:34 +0530
Message-ID: <878cbc1dd24921d55049932dcd5fd6ee517557ca.1782811071.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1782811071.git.sayalip@linux.ibm.com>
References: <cover.1782811071.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjMwMDA4MyBTYWx0ZWRfX90Ob3bFoYf0P
 7USWsl1bMta6TUVxs8jFEyuD30j4xtcCMup0gramPJ0ngEtm0j4ritKUPR3MaKmFhYxaAQhpGE8
 XyIP6YXa184A4MHleWEup0GPd1AIaNn2P4tpBjrViaXzNhZ0Nkm9+IvU3EtMrMDHxvXX7C2azTH
 nM7Kf3Nbbn41vDimagIv02m640HSyhwWuAxRpp+k40XHwfFloAtUc/SSuL7uxizaizKgqvoCELE
 cRmI1LZ5j9oIhPeZ4htKJsizXBBlFJ2ZjmbE8F8psdxqS43NORDBX+3NuUl+e30rSsplLBqmqxm
 ULci+63X3jcn5lKWvihddBh0t0Ipi6ZoKcdadA/HgYYiUosaCr4Sjm3btwdLkkIuQKGsFZiTUte
 dVm55pzzQ18vb5IV8Sx1h1xqRlaWJroKi2QpkCwJbR/H7IASs41oKe528GrCoYhiIxbYK1xrxk+
 TNUBb5++rdORhfhWxqw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjMwMDA4MyBTYWx0ZWRfX+ZK/ypLqVw+T
 GUaH8TwKuPAZA5+tHa57L7qPzHKKXT839DzOZ6laZHs0tD5KUONYwhfyzGvrtaXiLHprhjwt51k
 kv4euxHooxPX75dgNWmNICTW1MO3gV8=
X-Proofpoint-GUID: y9ORYq1P4RUGhhI7K6F91kCRYPAVfGOW
X-Proofpoint-ORIG-GUID: cy_-x39nKHutTCGFkJIdxbyaYTdhSaH7
X-Authority-Analysis: v=2.4 cv=WZ88rUhX c=1 sm=1 tr=0 ts=6a438d4e cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=SdE_JmCAbqlUaBO606EA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-30_02,2026-06-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 phishscore=0 clxscore=1015 bulkscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606300083
X-Stat-Signature: xfhgp3rf7sgdo5oqt5tbu49i4rbpprng
X-Rspamd-Queue-Id: E7C3514000C
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782811991-778910
X-HE-Meta: U2FsdGVkX1+U3WwdTgDxHNNo7x4s2AMqWu0yiV4CiNwBo9anIpg9/X+PAx9xhP0js0ar1QOvaWYVJpIBt7zmmeW14NzvPkuK52/LIYRolKU4tcIrQffjGMBeZP4lL+3PtD317er15sDtyHnf/humGMRwvkgK9WwF1ea5QtpGicl85exsIc9wJny729x6xEvyNy7mUf6+VHP9clvmLVxK/jFFU2NXmsuQCED0FGASjWuvXH21CtvR2jKQdazZZaflFvJrblHYfZImReyG+Y5k8fzA4KBywHLF0jyK0De65kAUEroexU4EWI6UAlnD5i9gnvbY09OlRM/js08W4Rdq1L4PlG1KI1f4CSt6vWTcBUNS/YLhONbN2JCLjldp7cuo/pquAzcSo5nG/erjAQkwwWRrXtq5MWC6LZtriqUA1WT2OsrA0l6yvbv/cldiz32C50LsZxMuU4wXCFApXCiOtxDs+CGETjUwbOWHgv4WneKySgIaVtvKxGmWCosHC8PR5ggG3bt+P1r4R3hJzUIYNUcUTlgrW+4DBuyDaEEhIkwzDxmE0dSTBWoNL49IMLHmyLe4wbKTuXNq6L4VQKfmi4fE0QteLMO3YVBTEWSTdhvZFJ+ifiQg8ANqMlUgS+ZMbdgiTY2sfvE4YUdKUN/JRjNKXgN195UPtFVEVi+z8YTk/+2Z5s2kq1yGz4XvtqzylwUtCvKCjU/rqYUxBRb/oGphJHPA8/hvZLX3TNkB3kXclTRZ+FSjqYo3FrNQd5JsLtf6dazeKp+F363Or4a2iL4rzfYu9nvdmJOgO/o3QUfdhb55m6mdDw4+SfzzY1O4ReoNbv4Cb9wDrLmJOvH3xF1mgrhTJHVzBsMQSNDZltqUtK18HfHI3KmidD6q98atbk/jwqry6fWWiSQYWAezw22tWY5RbpJHFm6NhlLc+9foEUJloxBLl3wAdm3hDBA2i7QJEazC69sTKTdVUF8
 6BOr7Hs6
 PQiZNsqjieXZI1nR2TmgL15j+u4vrk424UV/PHl/y3B2mUTgJ4y4xD07smpp2VqqhWrk0uT2teMS1T5J9A1SZyEFo1OOhg4eet78J7Zthx/DTKvwQlYlulQLoa2Gh1SpIEViiFvrate2UrFU7EGa1arm0+mxlQIZ9sPM3e6sSdxtG1THXPjs0eeQNzdMLz3tBMxUQDlVXVEDWIuVTC4NUBqIe0QG2W0n8787AWSe8OKQDBizd40XldukkrLozgMB1VFxfOFC07AegA0FgcqJ5BfkRUmz5JOmO+IcGDl8taquEhZU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The KSM NUMA merge test allocates identical pages on different NUMA
nodes and verifies KSM behavior with merge_across_nodes enabled and
disabled.

On systems with memoryless NUMA nodes, for example:
 #numactl  -H
      available: 2 nodes (0,4)
      .....
      node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
      node 0 size: 14825 MB
      node 0 free: 1382 MB
      node 4 cpus:
      node 4 size: 0 MB
      node 4 free: 0 MB

the test may attempt to allocate memory on a node without memory,
causing numa_alloc_onnode() to fail and resulting in a spurious test
failure.

The test currently checks numa_num_configured_nodes() to determine
whether sufficient NUMA nodes are available. However, configured nodes
do not necessarily have memory.

Reuse the existing get_first_mem_node() and get_next_mem_node()
helpers to locate NUMA nodes that actually contain memory, and skip
the test when fewer than two such nodes are available.

Before patch:
       ---------------------------
	running ./ksm_tests -N -m 1
       ---------------------------
        mbind: Invalid argument
        ok 1 KSM NUMA merging
	Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
        [PASS]
       ok 1 ksm_tests -N -m 1
       ---------------------------
        running ./ksm_tests -N -m 0
       ---------------------------
        mbind: Invalid argument
        not ok 1 KSM NUMA merging
	Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0
        [FAIL]
       not ok 2 ksm_tests -N -m 0 # exit=1

After patch:
       ---------------------------
        running ./ksm_tests -N -m 1
       ---------------------------
        At least 2 NUMA nodes with memory must be available
	ok 1
	SKIP KSM NUMA merging
	Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
        [PASS]
        ok 1 ksm_tests -N -m 1
       ---------------------------
        running ./ksm_tests -N -m 0
       ---------------------------
        At least 2 NUMA nodes with memory must be available
	ok 1
	SKIP KSM NUMA merging
	Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
        [PASS]
        ok 2 ksm_tests -N -m 0

Fixes: e3820ab252dd ("selftest/vm: fix ksm selftest to run with different NUMA topologies")
Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/ksm_tests.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_tests.c b/tools/testing/selftests/mm/ksm_tests.c
index a050f4840cfa..2ebbb544c671 100644
--- a/tools/testing/selftests/mm/ksm_tests.c
+++ b/tools/testing/selftests/mm/ksm_tests.c
@@ -440,9 +440,9 @@ static int get_next_mem_node(int node)
 		mem_node = i % (max_node + 1);
 		node_size = numa_node_size(mem_node, NULL);
 		if (node_size > 0)
-			break;
+			return mem_node;
 	}
-	return mem_node;
+	return -ENODEV;
 }
 
 static int get_first_mem_node(void)
@@ -455,8 +455,8 @@ static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeo
 {
 	void *numa1_map_ptr, *numa2_map_ptr;
 	struct timespec start_time;
+	int first_node, second_node;
 	int page_count = 2;
-	int first_node;
 
 	if (clock_gettime(CLOCK_MONOTONIC_RAW, &start_time)) {
 		ksft_perror("clock_gettime");
@@ -467,17 +467,19 @@ static int check_ksm_numa_merge(int merge_type, int mapping, int prot, int timeo
 		ksft_print_msg("NUMA support not enabled\n");
 		return KSFT_SKIP;
 	}
-	if (numa_num_configured_nodes() <= 1) {
-		ksft_print_msg("At least 2 NUMA nodes must be available\n");
+	first_node = get_first_mem_node();
+	second_node = get_next_mem_node(first_node);
+
+	if (second_node < 0) {
+		ksft_print_msg("At least 2 NUMA nodes with memory must be available\n");
 		return KSFT_SKIP;
 	}
 	if (ksm_write_sysfs(KSM_FP("merge_across_nodes"), merge_across_nodes))
 		return KSFT_FAIL;
 
 	/* allocate 2 pages in 2 different NUMA nodes and fill them with the same data */
-	first_node = get_first_mem_node();
 	numa1_map_ptr = numa_alloc_onnode(page_size, first_node);
-	numa2_map_ptr = numa_alloc_onnode(page_size, get_next_mem_node(first_node));
+	numa2_map_ptr = numa_alloc_onnode(page_size, second_node);
 	if (!numa1_map_ptr || !numa2_map_ptr) {
 		ksft_perror("numa_alloc_onnode");
 		return KSFT_FAIL;
-- 
2.52.0


