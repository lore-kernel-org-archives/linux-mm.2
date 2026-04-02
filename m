Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB11DCC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 06:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1874D6B0098; Thu,  2 Apr 2026 02:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 137BA6B0099; Thu,  2 Apr 2026 02:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026796B009B; Thu,  2 Apr 2026 02:38:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E53566B0098
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:38:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 89FB6B983D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:38:35 +0000 (UTC)
X-FDA: 84612662190.30.E510EF2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 73AF41C0004
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:38:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I0RjGYnY;
	spf=pass (imf21.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775111913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ugd9P0cI6Fe499qy5Kl/bBLKO3rB+If5FXFztZIJJ9w=;
	b=PF4XTNmNWV7kfBst3QheV877GO2Lha6e/881F980SshmGQzHtf5deNeiuiavT57xRaOMSX
	TyJpLtPv2PqcQRCwsSojB19vgfhBerG7qQpgjEK+Z/mtoBe/wT5BryNSO29oJWY9LFZgsB
	V6iNNBD65tUMR2v4kM6OiWP1eQP3YDA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I0RjGYnY;
	spf=pass (imf21.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775111913; a=rsa-sha256;
	cv=none;
	b=poJaDtmz+3DYZQWWJjNJF9USRBiV2PApKgdf+r3eu7rBk8K7ej6w9tb1u7I7DEGaYwzL3U
	B+GKrs4DVjZLQGttSIMPyTuDvuwXCuAhWt0vVp7YoQLhMwLiyRUZExKLx7ajdhDoKKlEgy
	tICPX7rMeK3jKaLxurhStRPRpORMMSE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775111912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ugd9P0cI6Fe499qy5Kl/bBLKO3rB+If5FXFztZIJJ9w=;
	b=I0RjGYnYy2aGky7Pb9fsFXM2zwtnUMtNRQtDk4/0UGYw631QyqkBAJfLss26FTkuPqiisA
	WXWLcOW+L5//1/+yqTiUKzxAz6QIFuX0OPe33xt+7D+mSSMIdtxUVIYiEkRU9Hfze0HkDg
	B7gaczgwqC3NoMLQXRUTiV0H9vgv3UU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-283-tJ1hc58aOiWuTcCCJ9kzNQ-1; Thu,
 02 Apr 2026 02:38:28 -0400
X-MC-Unique: tJ1hc58aOiWuTcCCJ9kzNQ-1
X-Mimecast-MFC-AGG-ID: tJ1hc58aOiWuTcCCJ9kzNQ_1775111905
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 013F5195607B;
	Thu,  2 Apr 2026 06:38:25 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.158])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1CC781800351;
	Thu,  2 Apr 2026 06:38:15 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	david@kernel.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	mhocko@suse.com,
	shuah@kernel.org,
	chengming.zhou@linux.dev,
	longman@redhat.com,
	nphamcs@gmail.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v6 6/8] selftest/cgroup: fix zswap test_no_invasive_cgroup_shrink on large pagesize system
Date: Thu,  2 Apr 2026 14:37:12 +0800
Message-ID: <20260402063714.55124-7-liwang@redhat.com>
In-Reply-To: <20260402063714.55124-1-liwang@redhat.com>
References: <20260402063714.55124-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: G5FMiRALGHORP72azElAWndq2XFAhpM9EyZPJbTo7GU_1775111905
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 73AF41C0004
X-Stat-Signature: 4dcwd4eegb6ctjzgijj6p941ayot5wah
X-Rspam-User: 
X-HE-Tag: 1775111913-731829
X-HE-Meta: U2FsdGVkX19RltcaG+IetbpeD1/wam1M7y/MDDaFobwFktbkZyp2NPUNgHoL+OrxEkCsOuNA2GODv4+jUs6bO7Ati04zp1Xo625pzITsFUuCk0SElO09OULitfKihi5EFsP95HUVwpz1xbcBl3HYDJfI9+AdFnAx372agfvY27lo+1JtYdASTYt9tSWoyfHNt7TPAwLpCaGAGOuMWF+WV250WCXKEpg1AxjX+XykoPAowmuuiclHv9rCBLeoOoQGIioxn7wS3rtp/RglzcdB7kLGbSQOjy6GvJWkusm4bG83hCqDCsDopSJJUZKF0yVUz5JafTKwiO8SzFOHqPbeV2hrnYOsURRCFyUBBYgYwEltnRlC07Vqyu/KILpHtHLfxGYeDIqfSNdTwdHJTib20ZEXZoNSQYM4zKxOiDGvCLNiwiosriaya8a1VyDsi51rIOGI4RQPxIIMN6k1MfWT2ECBBpxfSqaMtM2jw9yPL50WwFIH3xFFERjGAT840BcdlnKAdpuNUGxNY+DNQaL87mYo7m9fPX8qaoqspQSSQOQzf3EdKZ5VDJ4rqMO3BMytXU560uszLlE5rBiELPbV5C40Ov39Dwm46HFUlubb5f0F8R6Og8XQEDVUiCYF0SXwnZ8+dsKnxc1gt3aOyqUBuhqNDKlKUwzH8rs/VpwqmAn5+hg4SQoEXJYLoXKGavpnCZ09br6SzBJ74jBu5r1n2ZicIOwDITFml2t12sh12RH4wERywubG0CXwfQfJ5/6L0Co9c9nQmDXGUmJCqedvZRgEwKJ/P4x9/8uyPlOOUC13i0jGakf0gOqcWTQF2d/rME5+Id9STMu0lCknGXSIXQj37AbDZbvJYXUyUJzR51hrU7COfgxgQ9TG8vXtEmt4BgKP63qoUnLCQ3oMi+8UaJfFeNsDyUsPkg4AhXeEAVrFpAK95nZ3CKc1rBukalphOPfOOMxM0g7Rk+qnkIa
 PMT9Dlwy
 v6Lj8fPGfatxt7ttHlLFm3Pvk/2C2F9iks3pNoTIEtIz11OoB1UJFDlN4XhUcjgst3xW1t1o715vArVz3e6csbFe1erOz97wNF3aRaWnX3E8/HqHGjxM3kOdaFXmustNJGPURYSMZKfp7yCm3BbjZ+oz5GQCosDTSy7hYj8oYkLlv+qzMMF1qhunRCtklecTAq5hfJCRLqyPY8fYFrV4mRCoJAuNPP/f87ShkkwYe8pKv06yut8IpSaFtsjlaTNyPuNSDp6Q1d/UZO3Q9EKwPkPhil65+Yu1JZdzE72/jY9RmyGSOhdBtvWzdppfC75uOYoSlOCE5qcDW+nuk33BVPkEniMbUv2kb57gg/UNxpPFdXUTdCcgtlQKhxk7vceNzK7vF4F5JkTos+FcVVsgyn6CzvlE0p/8T59sH5cF+MW6gBJDSIrq4U9CrLyRLLhbZ513ULFVI/k4pA3NHlHRXFm3l5gXsmod6fmsWVTBt8LQpbgl8UCbE12Jq7QJtXIl0qNogb0NRLEYUJjr8N1hYRebVSjJVAG+3wqFOASRVJ1gfjT1d595zGIfMLIqfqPJmd2TbrfBD1h8DdflBLK5JhytqbwpHF5FzYN13
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

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>
---

Notes:
    v5:
        - Swap data patterns: use getrandom() for wb_group and simple
          memset for zw_group to fix the reversed allocation logic.
        - Rename control_group to zw_group for clarity.
        - Allocate memory inline instead of via cg_run() so pages remain
          resident throughout the test.

 tools/testing/selftests/cgroup/test_zswap.c | 70 ++++++++++++++-------
 1 file changed, 49 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index db4889bef6d4..2b14683f9a77 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -9,6 +9,7 @@
 #include <string.h>
 #include <sys/wait.h>
 #include <sys/mman.h>
+#include <sys/random.h>
 
 #include "kselftest.h"
 #include "cgroup_util.h"
@@ -424,44 +425,71 @@ static int test_zswap_writeback_disabled(const char *root)
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


