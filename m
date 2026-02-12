Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31C3CEDF055
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 08:23:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BB0E6B0089; Thu, 12 Feb 2026 03:23:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83AE46B008A; Thu, 12 Feb 2026 03:23:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 760CF6B008C; Thu, 12 Feb 2026 03:23:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 671436B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:23:54 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07B3DC165B
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:23:54 +0000 (UTC)
X-FDA: 84435116388.21.EEF6AF9
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf02.hostedemail.com (Postfix) with ESMTP id 47BC680003
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:23:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TDKuVggx;
	spf=pass (imf02.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770884632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=crYbU+ThqI1KboSIh+EReNJtidB4zxhxhtyNUFlO0rY=;
	b=f9ZMDPaD2Yr/VnIxnHdQb1S06J8bGklEtQ4dRsy9m1ThnqS2t2+l4//EKoXKM9ZAKYyl6u
	j0NJyXMx+a77JOklh4TmVDCXX/cch09LpiKF2OA1aCfcvEGxeZGPKneyDsXsGAVWi1QjXy
	6RkqIJkuq9st/qf5MNwcDGHiqU+entQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TDKuVggx;
	spf=pass (imf02.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770884632; a=rsa-sha256;
	cv=none;
	b=kjfknFVKnwzZdWewfH/9DdtilwGXXxgmEkoDdRM44LLi4SjdIay7mXPsDWHpK0UV6pdpn7
	qMkPVTU607hgqMa27GaPy6DfP/dlCt5sTryOuvx2QNIdpYu1+6gqsWNvWtRn3yybWOq/Ez
	btdeAu8eK2LBwPOIFl2D60HiqYax0j4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770884630;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=crYbU+ThqI1KboSIh+EReNJtidB4zxhxhtyNUFlO0rY=;
	b=TDKuVggxscYGSctBSiDWdBR38fcvT+Z3PytbqBFCVFWT9qlg6PqmrB3xUNFaLH/XhUnQ0V
	/cNlB+mkcXUIsmjYfm600iLmjAGnPJAZe3pq7FPg8OY0WRq6FSaPe0IjxmUObaf1pjtqLO
	L5j2gXzjnb1A/e/bJWzIh5DBJ9GmIzg=
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Hui Zhu <zhuhui@kylinos.cn>,
	JP Kobryn <inwardvessel@gmail.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 1/3] selftests/bpf: Check bpf_mem_cgroup_page_state return value
Date: Thu, 12 Feb 2026 16:23:14 +0800
Message-ID: <042df9438d9e78bcd66f1fa0e7043b9ea8cda96c.1770883926.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1770883926.git.zhuhui@kylinos.cn>
References: <cover.1770883926.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 47BC680003
X-Rspamd-Server: rspam07
X-Stat-Signature: jp9qi975999751jb4qcqqahq5bq8ryde
X-HE-Tag: 1770884632-946767
X-HE-Meta: U2FsdGVkX1/0jOeklf1Pr0e8IHXwvTOjnvV3CGncOXk0cSpYYWaiXAmv+L5uNNxrJ+uiLmUopWbFgBRuZcj/7eH4YKxwWHd2QI6vM+T9g9pWPd6pW7mxNIoa6GyPESxKF99ofEBRWiQ3TQiUSjAtKNBlEKk94hB0z6c9MaAmdG+XHuithr1pYpEsgDQfrNW4vB8TFCg06yDA4QIyn3HCGE0u2J49teK93xW1MsfMEyOHpfBYrR9+tNpaPLWquTjOjS75ZIa9RqNSQTiFVdDiYogYom2uNnW7a8jB+jjU4b+BEGiNgbCC/P7MZIgbeDgaREPE1+dPrx2KqsqrVqhow0h52XR2I5nWz3n+HuAc9+9WdBFGqgv8M0hb8IVinBt/xIY2Jeq4d8y/Hc7DgJBATtB4STL85zjOEoQ4KSHc92pJ8c/UQHNVzicgh5uPfifDeNwzVLpEGg01gB8AtJYdRCY7JmoaLvKckfsuCHGfFxCSEVTZ+1qGEzRIckMGYPGxqRCzcssfU5t6989iN3G4Iu/r0bpLkobR/g5RiaPmPKQQBUMTxynySfcpagRNGofByqwuaNMNzIAMf03/ORI0X3/cP/2Msruqnv+A9cW+OkG4qNUdQpRQKAzQeuraLuNj4YMODge+/SBX844V0265yRXq9Bwafv4Sl9Np3hIIIqBqViQ9ECWMEWRN2pdpSmF2oho4la67qocVi9cPgvARCovmKJf7tTM+vHmxNQ8bOXjp0IwRvw3QrKPnLzQSzyMXHffZSpLwLwBm1lDTb/NWodmXw722CuQEGja+0UP6WkCFwMDsmFhwSqvyVjfa/xHOIHfRME761mUGA9fFHjZRAuVoA7dKMJJZQ2tKq8m0m77BQSYBdPZyBlh/EbodaoX+2YF3iQnD4aCFVjCw53db4A7c6BlQ8s6aztDnCX1cBoQVILEvsVkkQIzOBtqb+MLVwAcFyOPBWdH13wCYYFB
 SUsZ702Y
 JYaaoiBbMf06dWOIw731SBB5YPxHyjbd0O0WjHQTyYH5mtX40vutE5NlJR0yoFhdbhcmtNAGgQWvXDozKaV6gywFZDfs9Y9cbskiuO5r99tihXyuFnqy4B5PilXp9jPPYpWVtklnrTG6oKWJAG30gws/Fr1G7AgyboW2EX3dKydCYNpi66KelpgaIkVMqgr1GT2FV1KJBrncgOPlknbcnbRtCl7ZYGjoU6ZUvA3gGTb7mkTf5nFUG2t3Mu9Rw19MxsG6Z5wc4YTFU71b2yjCXMctmiw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

When back-porting test_progs to different kernel versions, I encountered
an issue where the test_cgroup_iter_memcg test would falsely pass even
when bpf_mem_cgroup_page_state() failed.

The problem occurs when test_progs compiled on one kernel version is
executed on another kernel with different enum values for memory
statistics (e.g., NR_ANON_MAPPED, NR_FILE_PAGES). In such cases,
bpf_mem_cgroup_page_state() returns -1 to indicate failure, but the test
didn't check for this error condition and incorrectly reported success.

This patch adds explicit checks to ensure bpf_mem_cgroup_page_state()
doesn't return -1 before validating the actual statistics values. This
prevents false positives when running test_progs in cross-kernel
environments.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 .../selftests/bpf/prog_tests/cgroup_iter_memcg.c     | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
index a5afd16705f0..13b299512429 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
@@ -53,6 +53,8 @@ static void test_anon(struct bpf_link *link, struct memcg_query *memcg_query)
 	if (!ASSERT_OK(read_stats(link), "read stats"))
 		goto cleanup;
 
+	ASSERT_NEQ(memcg_query->nr_anon_mapped, (unsigned long)-1,
+		  "bpf_mem_cgroup_page_state NR_ANON_MAPPED");
 	ASSERT_GT(memcg_query->nr_anon_mapped, 0, "final anon mapped val");
 
 cleanup:
@@ -88,6 +90,10 @@ static void test_file(struct bpf_link *link, struct memcg_query *memcg_query)
 	if (!ASSERT_OK(read_stats(link), "read stats"))
 		goto cleanup_map;
 
+	ASSERT_NEQ(memcg_query->nr_file_pages, (unsigned long)-1,
+		  "bpf_mem_cgroup_page_state NR_FILE_PAGES");
+	ASSERT_NEQ(memcg_query->nr_file_mapped, (unsigned long)-1,
+		  "bpf_mem_cgroup_page_state NR_FILE_MAPPED");
 	ASSERT_GT(memcg_query->nr_file_pages, 0, "final file value");
 	ASSERT_GT(memcg_query->nr_file_mapped, 0, "final file mapped value");
 
@@ -119,6 +125,8 @@ static void test_shmem(struct bpf_link *link, struct memcg_query *memcg_query)
 	if (!ASSERT_OK(read_stats(link), "read stats"))
 		goto cleanup;
 
+	ASSERT_NEQ(memcg_query->nr_shmem, (unsigned long)-1,
+		  "bpf_mem_cgroup_page_state NR_SHMEM");
 	ASSERT_GT(memcg_query->nr_shmem, 0, "final shmem value");
 
 cleanup:
@@ -143,6 +151,8 @@ static void test_kmem(struct bpf_link *link, struct memcg_query *memcg_query)
 	if (!ASSERT_OK(read_stats(link), "read stats"))
 		goto cleanup;
 
+	ASSERT_NEQ(memcg_query->memcg_kmem, (unsigned long)-1,
+		  "bpf_mem_cgroup_page_state MEMCG_KMEM");
 	ASSERT_GT(memcg_query->memcg_kmem, 0, "kmem value");
 
 cleanup:
@@ -170,6 +180,8 @@ static void test_pgfault(struct bpf_link *link, struct memcg_query *memcg_query)
 	if (!ASSERT_OK(read_stats(link), "read stats"))
 		goto cleanup;
 
+	ASSERT_NEQ(memcg_query->pgfault, (unsigned long)-1,
+		  "bpf_mem_cgroup_page_state PGFAULT");
 	ASSERT_GT(memcg_query->pgfault, 0, "final pgfault val");
 
 cleanup:
-- 
2.43.0


