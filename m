Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADE08FAD3F3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 04:02:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22F626B0099; Fri, 24 Apr 2026 00:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 206A46B009B; Fri, 24 Apr 2026 00:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143E16B009D; Fri, 24 Apr 2026 00:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 014916B0099
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:02:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B9D8CA0AB4
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:02:33 +0000 (UTC)
X-FDA: 84692102586.04.503C58C
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id E9EFB180007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:02:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="k6tohs+/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=li.wang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777003352; a=rsa-sha256;
	cv=none;
	b=BXjCqoD2zFScrhCy2QnwJ9Gh1GiwtvKAj+oMRJ7NkThyqyx7v49k585Q+ZHzilc6J5FokL
	67IlGLi8xuloY1iBCdqbyII+hSNRkvs2stiQLGNeIAFVW++cQhSyv3xCN+MvsMN67+2EVI
	RKxvwXk6zmYBHuU6XgzV8tE59RdNkas=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="k6tohs+/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=li.wang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777003352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYJS1j8xw/dE6gWhFGa+SZVgGWdk++DoAWVOoCmadVc=;
	b=Cv/sdxM9Yft3xSjd8zFlIaS/idpFzvurSmiW6C8hzK/gLk8G7iAI9n5PgWEtQCvYakYLZd
	oX1n/ZO/BISbXxiW5JVkhUschGSHzzlo3XuSUyFMWmdrRddn+acrEoAENh/DDE4YH8rW0j
	am3YPwoZjrnQvaV0QFKs3JT2eQQ0pNw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777003350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RYJS1j8xw/dE6gWhFGa+SZVgGWdk++DoAWVOoCmadVc=;
	b=k6tohs+/IUwCKmIckdzo9H7BiDELRkL8d9a1LjRMVUOFSnHlJvCOEh1BAkKvsx7fwDGH1E
	B7nqkXTMMb6SP21snYZwjyb30sgQFLZSn8GMvx5BaiRoCucgeUyjU8oP38gQwqMLQ0Of/B
	9yEHxnyhvPYZepXFZ1FYmMOQfsuyEAE=
From: Li Wang <li.wang@linux.dev>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	longman@redhat.com,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	jiayuan.chen@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	mkoutny@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v7 6/8] selftest/cgroup: fix zswap test_no_invasive_cgroup_shrink on large pagesize system
Date: Fri, 24 Apr 2026 12:00:57 +0800
Message-ID: <20260424040059.12940-7-li.wang@linux.dev>
In-Reply-To: <20260424040059.12940-1-li.wang@linux.dev>
References: <20260424040059.12940-1-li.wang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E9EFB180007
X-Rspamd-Server: rspam12
X-Stat-Signature: 1mucijfuenpfc5n4he5qqrh7wnxk68n6
X-Rspam-User: 
X-HE-Tag: 1777003351-628385
X-HE-Meta: U2FsdGVkX1/TrYm428dF84WbCKOzeRsvFqLW896Ial6cM5+7sVTz/A8gnU39li6J/MuA0XG1KTGQQGrR7cox/0HkMC4Vd2cBP5jB/TWf4PxYxdNBzhnI5uTQs/ldQH/Yu+kgxVqX+Q12rdNSbuieNoERHXnVxeME6RQsTaDSQvkWoPx3AjNk8majKpxW0BzeBpVX5KE4Xw+CDTVEVdHB3XQ6JN5psywybmWWzuTMv7gZLgD4rZ1C0TzAhlG9GaExoxuuTxCoTH1SgM3O0q4OM1LrtKPTaFcMyXNN0FiNteSINCqU5CfG37gtqUqatB90ULHAMywKAvQBWqWxFhpqpuwaOzFuRQCmJ1hQ92HkWw9RPjIZZijl7rE9O/VRyANT9uIhmnMVR0C1owZ/mVAyf1nICo+BQdgVwNx9Tph0+C+NkmnyWY4EGVuwV0pTF/jerUQrpMWo0x/HFP70xfeZGlVe8f6c7dOVoLidllcTjN8h+Up2cLdW/nCVSwfJYkHf29Ae2YonRuCVeY8/D7Nk1UYLPYKSTivC/qHTZRSiLQqH3zC8eyUe3lEd+24N4TfFNQGINDYZNMe09Y2vs8inIdUPPkqHhzzsoPNkL+IAC19fZee8ic7jUQCvATFCNGL1CXlA+ilI4ypGJ7sS3OwWDLLKrguOOnxOKiY0Rel5k2EVhyVJl+shJaI6VHtQEeHzunc82YZnMgiXsw5zqCQhxl15aVSIEUwV9arvzXypK8ISWWq0/NrEyvGI1djIMdNRyGADzThyGFOUmE2j9sprBbUnQwtat1b+Kotx3JOqRedBeg95A5Eo7hn3mDowkQzYsOehcBu0tAt5Q0PGha9AQvM/Q8AxdJaIj7s0tgFCYED+Is3YeVDjLY6ByiaGp5VF6RaCf0Ay6BGaM3r1jX+3f4W3vvBBCUtaBncxBLPRWhUmsfvU3phtyP93t7pJLQA+VVtDZH7Kni+ZvfU9hx2
 ws/AU7AP
 H9s5DOxxxv5W02xce87Fcz6xHagHba+gl1Fk/JmCmmQgluYi9xGi1BxbCO8jbCOuB/qVWL1539jtVSsPJbu+l5uyGgWvlVxykhnqP81blrpHJIQ+5XcyJbyLhMf8+iM6XTgirZ0WLm3pInFuBhb0PpQ/RzxxJ/SYLpmpHD5+njB7CJJjf6AQlEMt7LA2giqpUHj3DDJ28Blo2+kjk5A5HBxVyCieQUtjJde7ABJ0eoHybUonjfUBDw2SSJVBKH6KPGhbIYSAB8IlH/eK5Azk+FbqOqHSEotYMb20CXQoMdBbz2qkHC9sZ4eznyKzrj/gAEiv/HBCAlilLPX/ffgAYwrUXFNtCzap+Q2ZTVOTobA4chnJ7rrjVKPShIcwS9vlgAkZ0LzX+WPDUM7bY+WYc9YApbfYp3bfH9l20pnXdVQDK/y17Bwu1Zb0DTS3aXnfmNgEuUmUwgSvUSh2uBFeg/xLPRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_no_invasive_cgroup_shrink sets up two cgroups: wb_group, which is
expected to trigger zswap writeback, and a control group (renamed to
zw_group), which should only have pages sitting in zswap without any
writeback.

There are two problems with the current test:

1) The data patterns are reversed. wb_group uses allocate_bytes(), which
   writes only a single byte per page — trivially compressible,
   especially by zstd — so compressed pages fit within zswap.max and
   writeback is never triggered. Meanwhile, the control group uses
   getrandom() to produce hard-to-compress data, but it is the group
   that does *not* need writeback.

2) The test uses fixed sizes (10K zswap.max, 10MB allocation) that are
   too small on systems with large PAGE_SIZE (e.g. 64K), failing to
   build enough memory pressure to trigger writeback reliably.

Fix both issues by:
  - Swapping the data patterns: fill wb_group pages with partially
    random data (getrandom for page_size/4 bytes) to resist compression
    and trigger writeback, and fill zw_group pages with simple repeated
    data to stay compressed in zswap.
  - Making all size parameters PAGE_SIZE-aware: set allocation size to
    PAGE_SIZE * 1024, memory.zswap.max to PAGE_SIZE, and memory.max to
    allocation_size / 2 for both cgroups.
  - Allocating memory inline instead of via cg_run() so the pages
    remain resident throughout the test.

=== Error Log ===
 # getconf PAGESIZE
 65536

 # ./test_zswap
 TAP version 13
 ...
 ok 5 test_zswap_writeback_disabled
 ok 6 # SKIP test_no_kmem_bypass
 not ok 7 test_no_invasive_cgroup_shrink

Signed-off-by: Li Wang <li.wang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 70 ++++++++++++++-------
 1 file changed, 49 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 23ff11390a3..8f0478923bd 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -11,6 +11,7 @@
 #include <string.h>
 #include <sys/wait.h>
 #include <sys/mman.h>
+#include <sys/random.h>
 
 #include "kselftest.h"
 #include "cgroup_util.h"
@@ -426,44 +427,71 @@ static int test_zswap_writeback_disabled(const char *root)
 static int test_no_invasive_cgroup_shrink(const char *root)
 {
 	int ret = KSFT_FAIL;
-	size_t control_allocation_size = MB(10);
-	char *control_allocation = NULL, *wb_group = NULL, *control_group = NULL;
+	unsigned int off;
+	size_t allocation_size = page_size * 1024;
+	unsigned int nr_pages = allocation_size / page_size;
+	char zswap_max_buf[32], mem_max_buf[32];
+	char *zw_allocation = NULL, *wb_allocation = NULL;
+	char *zw_group = NULL, *wb_group = NULL;
+
+	snprintf(zswap_max_buf, sizeof(zswap_max_buf), "%d", page_size);
+	snprintf(mem_max_buf, sizeof(mem_max_buf), "%zu", allocation_size / 2);
 
 	wb_group = setup_test_group_1M(root, "per_memcg_wb_test1");
 	if (!wb_group)
 		return KSFT_FAIL;
-	if (cg_write(wb_group, "memory.zswap.max", "10K"))
+	if (cg_write(wb_group, "memory.zswap.max", zswap_max_buf))
+		goto out;
+	if (cg_write(wb_group, "memory.max", mem_max_buf))
+		goto out;
+
+	zw_group = setup_test_group_1M(root, "per_memcg_wb_test2");
+	if (!zw_group)
 		goto out;
-	control_group = setup_test_group_1M(root, "per_memcg_wb_test2");
-	if (!control_group)
+	if (cg_write(zw_group, "memory.max", mem_max_buf))
 		goto out;
 
-	/* Push some test_group2 memory into zswap */
-	if (cg_enter_current(control_group))
+	/* Push some zw_group memory into zswap (simple data, easy to compress) */
+	if (cg_enter_current(zw_group))
 		goto out;
-	control_allocation = malloc(control_allocation_size);
-	for (int i = 0; i < control_allocation_size; i += page_size)
-		control_allocation[i] = 'a';
-	if (cg_read_key_long(control_group, "memory.stat", "zswapped") < 1)
+	zw_allocation = malloc(allocation_size);
+	for (int i = 0; i < nr_pages; i++) {
+		off = (unsigned long)i * page_size;
+		memset(&zw_allocation[off], 0, page_size);
+		memset(&zw_allocation[off], 'a', page_size/4);
+	}
+	if (cg_read_key_long(zw_group, "memory.stat", "zswapped") < 1)
 		goto out;
 
-	/* Allocate 10x memory.max to push wb_group memory into zswap and trigger wb */
-	if (cg_run(wb_group, allocate_bytes, (void *)MB(10)))
+	/* Push wb_group memory into zswap with hard-to-compress data to trigger wb */
+	if (cg_enter_current(wb_group))
+		goto out;
+	wb_allocation = malloc(allocation_size);
+	if (!wb_allocation)
 		goto out;
+	for (int i = 0; i < nr_pages; i++) {
+		off = (unsigned long)i * page_size;
+		memset(&wb_allocation[off], 0, page_size);
+		getrandom(&wb_allocation[off], page_size/4, 0);
+	}
 
 	/* Verify that only zswapped memory from gwb_group has been written back */
-	if (get_cg_wb_count(wb_group) > 0 && get_cg_wb_count(control_group) == 0)
+	if (get_cg_wb_count(wb_group) > 0 && get_cg_wb_count(zw_group) == 0)
 		ret = KSFT_PASS;
 out:
 	cg_enter_current(root);
-	if (control_group) {
-		cg_destroy(control_group);
-		free(control_group);
+	if (zw_group) {
+		cg_destroy(zw_group);
+		free(zw_group);
+	}
+	if (wb_group) {
+		cg_destroy(wb_group);
+		free(wb_group);
 	}
-	cg_destroy(wb_group);
-	free(wb_group);
-	if (control_allocation)
-		free(control_allocation);
+	if (zw_allocation)
+		free(zw_allocation);
+	if (wb_allocation)
+		free(wb_allocation);
 	return ret;
 }
 
-- 
2.53.0


