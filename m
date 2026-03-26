Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34823FEA800
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 03:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DAC06B0098; Wed, 25 Mar 2026 23:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1A86B0099; Wed, 25 Mar 2026 23:28:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EE8D6B009B; Wed, 25 Mar 2026 23:28:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7DD296B0098
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:28:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 341EDBCB07
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:28:02 +0000 (UTC)
X-FDA: 84586780404.30.E21AF92
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8317940003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:28:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NRz2L4yx;
	spf=pass (imf01.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774495680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NkrZmV+ciJiAg2eJxu0EA95Ha45gXSvLLHXumh7zBiQ=;
	b=q8RRxZSbcJSuxIbyOW+0+RpjXrjKLiGV+Psyo1BxdPq3Hu/iyi6AkyB62RzvAPYp8Hi7BD
	RQe5jt9FaZFLpVDa3RQ5IWY4JReaVDtg/tijVLC+UV9ZpIYU24Ijv55V0WUQ9zCxBsyfPc
	MY70F+9Tmk03gp+gwGlRyo9MevQF5ZA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NRz2L4yx;
	spf=pass (imf01.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774495680; a=rsa-sha256;
	cv=none;
	b=hVp3wPgBaKcwiEkqkWmF7pCRNpcopxlxzwxIwZxJTm4RZj8Frf+Q1X3c9UM93UNXH4m7se
	6HArA0WJuArvF6LfEj37NTOjaziPaZJYfHjSHVxYChyiw6Ywj2qGD6fw7OUECu+ajIwwXh
	7m2RiIepeF8bSMPvj+v4Adv/GygVoA8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774495679;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NkrZmV+ciJiAg2eJxu0EA95Ha45gXSvLLHXumh7zBiQ=;
	b=NRz2L4yxJxgMx5AML6TWJ0cJpdPOLwnNHZFta1MmxqQ7Qf0V2wgCIiWLny1wqwgIcbj+1w
	zXKmeRtmoenXVGwfCUUMZ2iHWsh+SgiQvmQ+dO+XsIpNuTOo8+t7Gy+FiXQhSaVNJHn6xB
	HltSpNJzCabWuysNcChHRsuvhcjB8RM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-629-BtFk9MNAPCK8rq26DfrzFA-1; Wed,
 25 Mar 2026 23:27:54 -0400
X-MC-Unique: BtFk9MNAPCK8rq26DfrzFA-1
X-Mimecast-MFC-AGG-ID: BtFk9MNAPCK8rq26DfrzFA_1774495672
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A98C19560A6;
	Thu, 26 Mar 2026 03:27:52 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.83])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 15A8E1955D84;
	Thu, 26 Mar 2026 03:27:45 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	mkoutny@suse.com,
	muchun.song@linux.dev,
	tj@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Cc: longman@redhat.com,
	liwang@redhat.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v5 6/8] selftest/cgroup: fix zswap test_no_invasive_cgroup_shrink on large pagesize system
Date: Thu, 26 Mar 2026 11:26:56 +0800
Message-ID: <20260326032658.96819-7-liwang@redhat.com>
In-Reply-To: <20260326032658.96819-1-liwang@redhat.com>
References: <20260326032658.96819-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: pksIWR-S4cehfdxsByl4OoEbNq-vzuZfy8MoipIy1IU_1774495672
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: txb7rqfbtuwqzj3ommsmpebii6sdmueb
X-Rspamd-Queue-Id: 8317940003
X-Rspamd-Server: rspam09
X-HE-Tag: 1774495680-767904
X-HE-Meta: U2FsdGVkX19TUrFX7nrTLZa5q1gVQZ2V6s6DGkyFUwsRafdvCCV2ivmugJNxwqbXh0xs7iT/KtZ1Ib/572E5rf4dqAz2ssTXugK+W7matMfr76N5bfoLODvQJFyxA2OJCT2oLCnf3sWrIiGsjjQ0578PaJ4hUGaDRFPV0M43zmdNAimaYot4XRrOWGai6OwtbRhx/ZYs3tiF3nz+F5V2okq3J/PuUuFiX1zL+GKIM1Hmups6a11MtAefgHIBrQ2NdHeRqPUXjyMWTYGTnluTe6/PitjjSiuoyUZKiwoRUN9Ur8IVDkMj1XIZ7azhckoD3LPT4JN4w1lzxFv78JDvXu0KsvQoyUnZq6M24aRjLxRxSGG98GPUpxdlzPOwVSIMDwXCZ64eYhEWWYBSgHt4+m+TNniWUH4es0Gud1NGV1cQzGyQBLx62O193bY868miFsr0L8Vhyi6JI89C1Nf3vLYbbqa3BRpEWpRMIwBD5ZXGLjJwr/duWKZprXiYeba1mWr5sNEFLx+1wRGoTriYcQCut6mvnBxgoLWlLoKFIIK2yUsIYm/fRpJAW6uM2hyZrIt28P4Cfv9ALN6qOA73MLVPFykVSizqKiiIbBfY0i8Fb8pcWLEQEyebp5d20/hPmyExvQHC2/YZyC72oXl/ZRbwgIVxK1+DqOaKlkNiITcrSI056e8n6y7LSJMDAb3aRLZ4IF7FNDbgQIYBxJ2kw0hbksyJ9Vdriyyp7Tn5MhMTykkJFzaxQpF3tYU4WtNKk5Fx3ViRlVTSdH9jlZmcguERE32weP+2tyI707TcX+G4kTbRUPRHnamgIOxk/axPw9rBX7psQhDxotVak1gp2cSj33MhplMc/kVP1Ckq9lyk8LM2liJuW1a/dXUXQ0bORTRRyhqpq6taGPYFfLcNPBYX+B8SDBMQSEB1PGwfFefL6xbB7gYpdFOgB2ldyDuqEnZm0Qtgi+84czgjOMV
 SSDgP8vA
 YVWtvsnIXLUP1QgkOGr4fhgTOq/Jus34KysEk29roCjxS/DjFP9B7qLy/Y9tw+O4X8ig2
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

 tools/testing/selftests/cgroup/test_zswap.c | 69 ++++++++++++++-------
 1 file changed, 48 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index fc7a9aa27e27..72082e5d4725 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -9,6 +9,7 @@
 #include <string.h>
 #include <sys/wait.h>
 #include <sys/mman.h>
+#include <sys/random.h>
 
 #include "kselftest.h"
 #include "cgroup_util.h"
@@ -424,44 +425,70 @@ static int test_zswap_writeback_disabled(const char *root)
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
+	snprintf(zswap_max_buf, sizeof(zswap_max_buf), "%zu", page_size);
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


