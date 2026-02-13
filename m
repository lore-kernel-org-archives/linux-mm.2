Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DB0CEF48DD
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 07:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E29B66B0092; Fri, 13 Feb 2026 02:24:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E01BB6B0093; Fri, 13 Feb 2026 02:24:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFB346B0095; Fri, 13 Feb 2026 02:24:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C30EC6B0092
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:24:18 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4057D1B4083
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:24:18 +0000 (UTC)
X-FDA: 84438594996.02.EA8EC09
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id A078040005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:24:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cc3fpTVf;
	spf=pass (imf04.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770967456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HW+lAdpZxdJcNgAcGUXKCZ/ga5dHaGdja+4OcUdB4U4=;
	b=g2DZQ1SerTbZG8E0C2q+v7E/ZBUI2cfkQBVU2NBLHTKDi++smV/TDtVvRpa3C/tthqZVV7
	DXATnrWyi4o7YlISm+vTw+r4upEjCbPoBHz0DHSrP8njVSvEeR43Crnb5IeE+v+lX8nRAe
	5po1a+hSvsW7uTlzeE+sQ/v+hJOrPF0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770967456; a=rsa-sha256;
	cv=none;
	b=V6uzLJhLMFbTTpDQ3HLqvq9nwHpmc1jETGfKaJ8wHuxv/X+EYdfuQEjRBBPiyqSVD1yH78
	W4KrQxpYQf4owsqVzVRxdQQmr6WBCw7Wk+rQwQ59QYmuetVyWaKBuWsS9D64KQr68v7Y3R
	PhE7tLYcosuEHu8XaMAFvs0EyMLpQgk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cc3fpTVf;
	spf=pass (imf04.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770967455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HW+lAdpZxdJcNgAcGUXKCZ/ga5dHaGdja+4OcUdB4U4=;
	b=cc3fpTVfk4UjRwRea3SPdpj0kMzH1jIgL2ZENeZFz4l/ch+kXyBmx4iuQ6GHsvobdljBxm
	Zjd3mc9KkrGsTIZwIDoqz4fE63dyYV5bc5DJZFI87FljWPb7n7Gza8GpxVzbE3/jZb23Yg
	ia+RRy9hEvB7mBrPZqh015f4DQ+PNzQ=
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
Subject: [PATCH bpf-next v2 2/3] selftests/bpf: Check bpf_mem_cgroup_page_state return value
Date: Fri, 13 Feb 2026 15:23:40 +0800
Message-ID: <ba61b77c71b6285eefa022a84bf80c5913b313de.1770965805.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1770965805.git.zhuhui@kylinos.cn>
References: <cover.1770965805.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A078040005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: c1r4deg5b7onxxsr3zxe4uk3f7woa1tx
X-HE-Tag: 1770967456-356129
X-HE-Meta: U2FsdGVkX1+r6kGjsMHO6UDIB5YGspm2BbVnxCYIYRAoizs/TlMl3g8HY4MCtL2Qv9q/N4PPZjI/ljmAd39nJVNzoG8ykBSGYIFmyN1g7NPZl+1+NfyiKZg3nKFdq13fAUBnwZcacb6yrUNosN4p35K0cJxHUyRl6iuP5f9XvsqvRF0E+T+mhkvybhbWqfpf4CSeIPDfZtCMcpJQNL8cfRUtc6lIrhiEKyq2p7gOfyKlbjBsgnpE4yeFlrZ56Sth6TELGmMAGRNo/h3qAfNXbes+tC0k+Zxm35DsQ+/otgr9P3M0EUMFylsLzE2SSoXfvRyAxFcsUWy/dcD+fwCJl+7Dinxrje+wH2gRpHv1p6FYKMvdZRp1nDnpOzc8688BtNb2m/Pe6snfR51pr9xFxrgZcd/r/3f7d7N0NVopkQkXeFQS93lcwXG1flU0VCoL3c3rz7iFnfbCzXTVrzBkjWAPfFMDHBGm74J6QSUJoNz3NFi47BNb+RNYio9ruFaK8tthLFkANL2+ms2fyChjvu+8QcDqvk7FnyhUwerBW8weRVCRKRuvNcFqBYhcCmiRywcBg5IFtFcjz2jOilyZx4mR1oEDFmB23VHm1pfqcLVjECeYFg1I6bMZV1NZ0H/YciopeP3AQ+2bOzhNTf3lSgDdJTndjzyCv2bCEQ5+qq1v0uxOCCMeL71KRzjeLPg2SBfvld8as10xKcXc9UEJVmlFY2qURSXpKWSRavrsDMpURDPrSlCN+8SdUL8ybyLKQnsg98hAzTRNrzqsVe+eUC4zekfwM+9214mB01nz6meON/0AaFErtt+NgD702tLgUV52sW8ACXlcCkrolPA6qjBKpDR80mKWlXWVUJTNg9CS6Fo6b9pXauCQDo5sxxG2tKR1WvcOSgYkPbDqH81m3CF6mFRtJAB55184wXgQXDweK06KLqS9+sfsHL0KCXcQcJI6y2JIeF8PRYkgEMI
 4oCnaHjh
 E4BmRuZnH/uTL2TXdW22bBik/sThsa2JUL6kFkI7cV2kpu1SjA3gW6c+3OmAxdnH3KkJKzthuGh0rJ2COUX0MapObn/+e7JYtejGPwDMz0IR8qNoEyEXtlWLJJ3Cf8ERFU/4eIL6PPceNWDENDafxDGkU/U6fy51zMs16ryfs1z8svNaydoWEj9S5a/HdkSvFJn+q/8HqTvFk2dPMMW1y+UnVf4vN0vLF7YlKzXNYMqiUod74zEnH/7bQLmGyzGRfUE68uI/+/nrjRX0ANCMUEQfd/A==
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

This patch adds explicit checks to ensure bpf_mem_cgroup_page_state()
doesn't return -1 before validating the actual statistics values.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 .../selftests/bpf/prog_tests/cgroup_iter_memcg.c     | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
index a5afd16705f0..897b17b58df3 100644
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
+		  "bpf_mem_cgroup_vm_events MEMCG_KMEM");
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


