Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F3B2106FD7A
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 04:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 104176B0092; Fri, 13 Mar 2026 00:36:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C5426B0095; Fri, 13 Mar 2026 00:36:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F00476B0096; Fri, 13 Mar 2026 00:36:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E04CC6B0092
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:36:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 855B21607A3
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:36:25 +0000 (UTC)
X-FDA: 84539778330.05.DF25CB6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9860240004
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:36:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hxaBXIkD;
	spf=pass (imf17.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773376583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PlktpjWAW8aZ8EDgU9QdqmDTBt5hSYxwzKW8BTBPTM=;
	b=aEAx+kJWm6bvd0IV+//Ht5OtyLiT9ciEX0BC0fq/T+Y0dXRwBphVRkahiSZivMF0chVHmO
	KHHXA6MztM97Tf5DcEtSCQJ0rAl5Y94IuH8PbGM85bCmXXhMa6fwhabysW3Oue5RkO2iBw
	zkKk7/mSeUdsUa38jra6AyJ9TqHP1CM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773376583; a=rsa-sha256;
	cv=none;
	b=hlyajolLtp0h2sdv0f/J0Ka5RlBFuRie7s/kZB6tSfQ+0N+BrDFjhA60cznLKXECSz55SP
	lVcemHvZkihmoFgMJRAJz+yirroRy9/IKzJxoKqaSlbVAr8K/hDZz/o3XSaJTFvjGslWZn
	PTA6PxOyHS/WMr3982iz6iKmb5DuwbA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hxaBXIkD;
	spf=pass (imf17.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773376583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9PlktpjWAW8aZ8EDgU9QdqmDTBt5hSYxwzKW8BTBPTM=;
	b=hxaBXIkDoiQGBYz8GSh3870DV3MKjptUt45HpMzRdcG2vfQDIUOtFeUqUGEcdk0jdv5Pg8
	4PdhaS8Hi2VbJG5s9/8X9woovPxbpAOqCBESQtaV5O062yn+lPZM3yGCaCU0FtNK61do5J
	zjvbWgXNnbllbbK/KDCAhWOjvys07Kk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-120-pUENbAFeM-qn5q9KII87Og-1; Fri,
 13 Mar 2026 00:36:17 -0400
X-MC-Unique: pUENbAFeM-qn5q9KII87Og-1
X-Mimecast-MFC-AGG-ID: pUENbAFeM-qn5q9KII87Og_1773376575
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 342F719560B4;
	Fri, 13 Mar 2026 04:36:15 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD1E219540C7;
	Fri, 13 Mar 2026 04:36:09 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: yosryahmed@google.com,
	nphamcs@gmail.com
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH v3 6/7] selftest/cgroup: fix zswap test_no_invasive_cgroup_shrink on large pagesize system
Date: Fri, 13 Mar 2026 12:35:31 +0800
Message-ID: <20260313043532.103987-6-liwang@redhat.com>
In-Reply-To: <20260313043532.103987-1-liwang@redhat.com>
References: <20260313043532.103987-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: Khuz5KuaH5EU91Jiskn-E2AOVUjQHsL9UtCZ-aEQFj4_1773376575
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3ciwkqcrfaj3ewu7cnpmp861ptiiieju
X-Rspam-User: 
X-Rspamd-Queue-Id: 9860240004
X-Rspamd-Server: rspam12
X-HE-Tag: 1773376583-132252
X-HE-Meta: U2FsdGVkX1/4mm8MVm+s0WscsjUtXbwJiQEzL2BBQzfS+42YsfvylNVGQWPXqB+Y8fR3uXBMZjktcs0sXF9v4ovVAYn+Y8/iVnkpyuIV9kSFxLBd9eNCm+9pmZzA3ZIgAkZSoOOF46/N3XGxrxJugTEYetmCbxent0rn5ZH2IbZp3YM1cqjtwwDT6pJY6tn1Qa3OHPf+iIPwhtZFvX8btewtVjqvNGd5ELC0LapVTZHOIezv7K7nHAE9nUa3JmBdP7xNOQaX6+W39ptFefHeh6fZfkWK/yaiWUb50GJLEcFmkknqRwMVwYLcDV4ugZ2dOTKjy12PLwsPe8TzcAmy7X0wjNJhQNKCsI7XtQz3KZ3UDSqEkFfM6tmn1dm79BlkHY9I+PeSb36DxqOBFIjbJOlJN3AvRcIxBeNU6Oq52Uqn9xccE9hAXlVWpNeofJM+pKWWMhwIUrEysas32gLfJ9jTUSIDRxZSDGPDVkQHf46EtB6bO9aNGNL5cXu4cD9t8wGIjjmS585D3I3cwTupCvSzrOxFhJ5cH5GRW7lEtBzajW9puwNxi1cgx/6Gk+F588+IpGPg27aZnZZgWPazvzY28/PPHPJIGSh8xWZYpLhGG3LYQxArErlF1Wc2yBZQuH9ZxudLKbpqrjO0zBsQzo/2jkojgsLWXyeeldmviiPPmxN3m9EjyKtUjJy9yMmElmAl1wfhYE1VtX33uKo+50RBaW3S2wRu6tvy2k01DsBqSZW6WDe8/M8vmdUama5OG/kJYufZiVcYrBrE+jDvt5Rq1jd3ktslgmhA2jCG+RdxktMwKq8fNevj96R/JFz8XXwEZpobsowfTfNDPc53KtsELmaqITrajWMcCu0c6k75SdBrlMqEC3D+3quQppH8O/WoLacgBNWwH6IiQG/QN1MHSn8q1RghQvFkeT4NT5Fnn3Mj+0N4UcbmEICo+J9S6RU5WGvqvW5ExdTeQBf
 P16h8gjP
 sPcnbmuXKsZ6r1pumhgJiyerKEZf/kAl+NHz4UIwoSxjICzU13C5l1cqUQc3BNhM+KX/nwXdaIv2a669R/HSudnyGwoo2TGUVy8SDWDJNJP6POrcgJ3uTS9+YxIQyONKZZGLwtxFs9lXuVZ4zWJRmFVNQjJreeE9xOISGIm8BwNIxAepQthnfZQpOEj4WjQ/+mXNzfF6qlmksA+s9FQTKZL3oTWR8sbbL0SBdpcc6n/iO6r/3nFlLzlqrHtXYfIjdtoorT11IMRUVsO2y9dOO/XvPaBDcIRKPXF8XNpXgEcoQhyqgICYqaBjdad//HRV8w0SmJ3/zq1Etf1znZZkdxzPzJyMIfqTF1ILfzM05GZZe8Kj5Ie0OUU0oKt3vcev+fOmzpPW2m2qgS1Y14Z7dN+kmd7b9p45TFBHtWfjx8JSeiVwKqAEw4qEvxx7xOp4x/FEof+mm3HjSh1lasdo7pk1v3SqsEEDih9t22KlSJC2LUqmvWzkCvtIwq1T96OQ1FuBJLUTl4/NQiPpRYJT0nwSZhWIxHGt3KZ3rSSqNMA7Y6rJV1edrW2rMJwM8negpj2ECOSWT6/kPseeksYnQV1fw/n2C/O8wEJ5N
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
index cf5b1531c827..f84e84c3e7c8 100644
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
 
+	snprintf(zswap_max_buf, sizeof(zswap_max_buf), "%ld", pagesize);
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


