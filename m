Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15011FC72AC
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 06:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A4B6B00A3; Sun, 22 Mar 2026 02:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 541C56B00A4; Sun, 22 Mar 2026 02:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47F506B00A5; Sun, 22 Mar 2026 02:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 379A66B00A3
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 02:11:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E69645A276
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:11:41 +0000 (UTC)
X-FDA: 84572677602.30.260C689
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1BF04140008
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:11:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RBs6TLuK;
	spf=pass (imf23.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774159900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SrL2AX+ceqx9sNAAroe9dHxRWyg67vSJ191ORAP+K8A=;
	b=4VED/7PVHNU3rIfmdzpcO4bVHSwzA5bhszdRaBECEbAqMsv6SutxqZYoupwYMbsHdegS7J
	oNWd3bpryaueFCtaWU8JN28DGQ8lHAEV4ZHFY7RWA4HAaAlCako1ObdipSD1IlNCAi6eK1
	oqr7UDfZHzP1pQ8gELqd1XytVE1g8Vw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RBs6TLuK;
	spf=pass (imf23.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774159900; a=rsa-sha256;
	cv=none;
	b=ZOqTsj/J6aN1Bd1UuaN86mWXDDB+yvxgfV78k7NAZIJSx2kK1CBJ2bcUGDOMZySoN+/nNg
	SfkNjDLG0Rm3xLCXdGi5XHx6WBXyJb2KdbHzrwd8k90gMAhm5narwtQ2X2aloy+Xh44Prt
	ePihL+mFgvW9o44ZQ2jYZCnuJmXO+fI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774159899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SrL2AX+ceqx9sNAAroe9dHxRWyg67vSJ191ORAP+K8A=;
	b=RBs6TLuKZdn9kzrPKKU2CC2xfijo5GY0gLUSLB6TwrdzF3wJQBd24/MTqKzk4djsE4vV3Z
	f4fIqikkGOh1SIkXLxY6+x+Da/yCFqFCHIjJ0HwBll/Wm7yW4EjaoRuva5ZvZAAk42oPFa
	57YQ7a2ea0Y/PAvFhk7IvJSORtFVrWM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-572-9gLZOP22NOy9Wgnz9yPBWw-1; Sun,
 22 Mar 2026 02:11:35 -0400
X-MC-Unique: 9gLZOP22NOy9Wgnz9yPBWw-1
X-Mimecast-MFC-AGG-ID: 9gLZOP22NOy9Wgnz9yPBWw_1774159893
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6401E195608A;
	Sun, 22 Mar 2026 06:11:33 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.34])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1EB9F1955F21;
	Sun, 22 Mar 2026 06:11:26 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	yosry@kernel.org,
	yosryahmed@google.com,
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
	linux-mm@kvack.org
Subject: [PATCH v4 6/7] selftest/cgroup: fix zswap test_no_invasive_cgroup_shrink on large pagesize system
Date: Sun, 22 Mar 2026 14:10:37 +0800
Message-ID: <20260322061038.156146-7-liwang@redhat.com>
In-Reply-To: <20260322061038.156146-1-liwang@redhat.com>
References: <20260322061038.156146-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: dA0VZq1In3nEAkKHJ1A5UxJcMGjn8LPuLX0j88wevIQ_1774159893
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1BF04140008
X-Rspamd-Server: rspam07
X-Stat-Signature: wdc4oo1dxa4a4o47cs9ds1zb6w6tuocc
X-Rspam-User: 
X-HE-Tag: 1774159899-48233
X-HE-Meta: U2FsdGVkX1+GqRsyisTzhUelWm8uERqFAwUqrZQye/zIaWbLDeXcVHAqH/XJ9n2kN21KUHd9h7SDa0lS/bU/JO9tFNxhT3mKgt9DGqX1bLoFII+yQR2uYq5JLe2A1g+HskAxHRut/BtXcBcIrrZcuuc5W/796+3JongkTmfOtkqd+hNfvfin2oDKO93ZDUnSqiWAdI+PGzuvt+Iuy1QdyJUL0g4NEvJlc9RCb8DtAH72c14MLmKP22JGDRR6dh5QBTJ2pYXvZ2p56KVgywlJg//BID5HDF6oxUMUy2gXeEiEAc6Swa6xhz3SyHhDTIA00OyxRGQRyYUNRs3lf2USY0ZV+6rwuTfDUs0YKXmkY2yguY5NtQ1n7ZUou9LpgV+n1LV8I2NHw6GXyc0rFyE/m+c4w78x7jWFIAToyZ40witXioQQW1N5r9872tsZjROynd6N4NX6QJUxtPftIK5PV2I52T2fEDn2ZFHTSa+axqnzj4sz6V3lXyAeE5NYIbissQSbCu7OAHP2g2rCJHcyk7Ro48TmGSFNOdHTzzPI6s4AnyobtXzLubOMiwTT6GjAZVaLxU9K0j5moFc5wlvUZ9lpOnwf8QAAX5yx4Nr30dXdNodqDRRvTGC+1A8NrHmuUCg9aGWuEB53Qz9dhzhgPwmfKnrL+EaO4gbDRpr2dWd3M3oIYljn6P574tI778AcznCKk41vhO48/Fq7bvJADm6rn+/ZhmzPG3z8L893f2FVGTL6dc2sUJmB5WVDAm9WEy+jbt2pi7xUuc6t5G1o6ejb3utWfsMokX4yLPNJAXwmtktFJB2bW3QeRXIPLEMfuP7410pJuFB1f4t1biJXDPTAYrwA1jjGKBIxFaWTCdtrBaRp1467KTEqSYQtD7iWZdjZiA69JFrFlc099f7u7uqba0ElGYd168KwRKr8yFHk2LxtB4NsYAH0jEFFSkcGtUZpeB2k0AXwIvGvLOF
 wqkXYKMF
 s3jPgg3z7cGeRTXpSmd70SYRQjoni3ralZucOuP+AuvxQnFDnRElZ0vJPoJ6YVXTKt0EeRreueksM2Hwf4PKT1zE0ByE4guUGomMjME10fMmw3ahwcPV2OxtI6GuK5P5H5uqgeuu3xApLclqb6qNO92F7zTn7RjKiAKyeFVRl7Npbi44fKFuo4ylyyjtror35LfvFlKJqml3b6zKPLSTugbF6BBBWq0y+sF33TuNo9v+U0V0fa6Gbev9u8ifWTQbZbDPlL6gfiMMt7y3NR+NTxM3k3IaUPAmz3p7YllfHdF3KT4QFNSLvRj4WLPMCDlorR6A2J/hC4rooWAwfbObdY4S5mcpCB2fROKYVx5+qkzKy1RZIsS7x2C0pMDwZ5MIPqh9J+T+8z5AlilTwcFxJ7lZ662gXXg+jVw3eeeelSSYt2KaAd9mYFDRdTOCgEEPtotPd4Wm4+O9c7RLxPOP4OhpYmJSNXFM/XZNn2IDfPk0pjE49FpfWZt5R6zk6gOEs/dWGQaqIDbpeif037Fv6FGlL1VWeJ7Ho5/jvQJWtmEnTE4jqx5UdRV9XLS/83aRlVTooPdAuR+TafNblbLA1ccNV9bK7cfaG6jKW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_no_invasive_cgroup_shrink uses fixed zswap/memory limits and
allocation sizes that are too small on systems with large PAGE_SIZE
(e.g. 64K). In that case, the test may fail to build enough pressure
to trigger zswap writeback reliably, leading to false failures.

Make the test size parameters PAGE_SIZE-aware and consistent:
  - set control_allocation_size to PAGE_SIZE * 1024,
  - set memory.zswap.max to PAGE_SIZE,
  - set memory.max of both cgroups to control_allocation_size / 2,
  - allocate control_allocation_size in wb_group (2x memory.max).

This keeps the test behavior stable across 4K and 64K PAGE_SIZE
configurations and avoids spurious failures in
test_no_invasive_cgroup_shrink.

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
    v4:
    	- Use use %zu in print pagesize format.
    v3:
    	- Make PAGE_SIZE aware instead of using fixed sizing.
    	- Set memory.max for  wb_group/control_group to control_allocation_size/2.
    	- Update wb_group pressure allocation to control_allocation_size.
    	- Clarify commit message to focus on this test's sizing issue.
    v2:
    	- No change.

 tools/testing/selftests/cgroup/test_zswap.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 407cfb6ae34d..ec7f0bd515e1 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -421,17 +421,26 @@ static int test_zswap_writeback_disabled(const char *root)
 static int test_no_invasive_cgroup_shrink(const char *root)
 {
 	int ret = KSFT_FAIL;
-	size_t control_allocation_size = MB(10);
+	size_t control_allocation_size = pagesize * 1024;
+	char zswap_max_buf[32], mem_max_buf[32];
 	char *control_allocation = NULL, *wb_group = NULL, *control_group = NULL;
 
+	snprintf(zswap_max_buf, sizeof(zswap_max_buf), "%zu", pagesize);
+	snprintf(mem_max_buf, sizeof(mem_max_buf), "%zu", control_allocation_size / 2);
+
 	wb_group = setup_test_group_1M(root, "per_memcg_wb_test1");
 	if (!wb_group)
 		return KSFT_FAIL;
-	if (cg_write(wb_group, "memory.zswap.max", "10K"))
+	if (cg_write(wb_group, "memory.zswap.max", zswap_max_buf))
+		goto out;
+	if (cg_write(wb_group, "memory.max", mem_max_buf))
 		goto out;
+
 	control_group = setup_test_group_1M(root, "per_memcg_wb_test2");
 	if (!control_group)
 		goto out;
+	if (cg_write(control_group, "memory.max", mem_max_buf))
+		goto out;
 
 	/* Push some test_group2 memory into zswap */
 	if (cg_enter_current(control_group))
@@ -442,8 +451,8 @@ static int test_no_invasive_cgroup_shrink(const char *root)
 	if (cg_read_key_long(control_group, "memory.stat", "zswapped") < 1)
 		goto out;
 
-	/* Allocate 10x memory.max to push wb_group memory into zswap and trigger wb */
-	if (cg_run(wb_group, allocate_bytes, (void *)MB(10)))
+	/* Allocate 2x memory.max to push wb_group memory into zswap and trigger wb */
+	if (cg_run(wb_group, allocate_bytes, (void *)control_allocation_size))
 		goto out;
 
 	/* Verify that only zswapped memory from gwb_group has been written back */
-- 
2.53.0


