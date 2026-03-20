Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E21A1099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 20:43:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A249B6B0119; Fri, 20 Mar 2026 16:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4C56B011B; Fri, 20 Mar 2026 16:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EAD36B011D; Fri, 20 Mar 2026 16:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7C0AE6B0119
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:43:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 487BDC0F47
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:43:22 +0000 (UTC)
X-FDA: 84567616644.16.3F6267F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4DB184000B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:43:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZkYSfeiV;
	spf=pass (imf17.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774039400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sWc/eXILLPmBL1iupIXOD8iHNU0S9z1ohodxLQi1ngI=;
	b=7sUs3r8kli2EiMl1LpDandeuV0sW4eJBfaRRcgHPsYySW7OcBYdMDj0lf8hyKXMvYdJ8gN
	ieQ4+o6UzwujTKRO06KnNdGGphes5BhhrErfz/hq/szzN2lfDaDlP1FZo5OmCNsr61YKnt
	Qfpefzom39XCiBgjZwv6JPID+l3bbbQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774039400; a=rsa-sha256;
	cv=none;
	b=34lT5qfrnAThPu8oOtubhMYr7RzLYofbshVu2OeunkM7q1bj0y2XpD6COwD2PjL9JM/rnF
	RTBhYuMcXuwOZs2IdjBpEnwvKML1SJLzw3L1+liJyDWbFws33YpJBTU5UniVobs5wV+3B4
	zXapgTV2MWM7A4yHfq8T3ARCQOrS1oU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZkYSfeiV;
	spf=pass (imf17.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774039399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sWc/eXILLPmBL1iupIXOD8iHNU0S9z1ohodxLQi1ngI=;
	b=ZkYSfeiV4k4psZMHB1+Uh/xMwipN8S7koIz/fTB6pez6Pee+cLIqH5i4RaTyph+3QxEB5o
	qcb65A4/D7XXdxf0h+i+N14yDzJtrvsyY3Llc1b8eTZcwpKJlm0PdhIWPHBJlu0DBpEcc1
	ekAaWIDPD0AwYZbeVuUaiE7uZXuq8pE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-183-hpJT8OQ1PLCcw0oAZgxppw-1; Fri,
 20 Mar 2026 16:43:14 -0400
X-MC-Unique: hpJT8OQ1PLCcw0oAZgxppw-1
X-Mimecast-MFC-AGG-ID: hpJT8OQ1PLCcw0oAZgxppw_1774039391
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 32B621956055;
	Fri, 20 Mar 2026 20:43:11 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.65.139])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F2F95180075B;
	Fri, 20 Mar 2026 20:43:07 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	James Houghton <jthoughton@google.com>,
	Sebastian Chlad <sebastianchlad@gmail.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Li Wang <liwan@redhat.com>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v2 4/7] selftests: memcg: Increase error tolerance in accordance with page size
Date: Fri, 20 Mar 2026 16:42:38 -0400
Message-ID: <20260320204241.1613861-5-longman@redhat.com>
In-Reply-To: <20260320204241.1613861-1-longman@redhat.com>
References: <20260320204241.1613861-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: zXUPAgq7HaE3x16US71OtDi0da7s67i5PErIo5A-xm4_1774039391
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4DB184000B
X-Stat-Signature: xfuimt1886hag9pfpdu1a91kqdof43bf
X-Rspam-User: 
X-HE-Tag: 1774039400-990951
X-HE-Meta: U2FsdGVkX1/d8NomrE0PofgADrXzC3FO6ZVbuvsXzZxdtQL0qH96204PtviGSROwpnBdLYeqjII89o2PJ6oLS9JUrfr4C2yURgXVF4im6lRAcctB7LrDPN6MkqM4YWfFZ6tl7HpZGeEUN4UEwd60t3MBBYo9YbKFJ6jrp+HNoM/L8uY31RjcVOOdrQgd2klhhPAeFYADfjqGBmKiRnzGuz12x4GBqQ5jL+KJrPlIpju/761nRxTdLuJWMi/rO9laLCGt2hqhzAjoBSusCreCDFuDUHJQOPplkPuhKYFdLz1VddiUDyR8TuLBpruHZ6QFgL7v+2zejwPLVWOUO9Q7ktxmbabVEZXCfn/ycp5qe/cV56yQJCMHPXqD3dKV9ieWDhHcNfAxaaUcDZvesaYhNAZ4WC319oUueIvjcczFSnO/ITB/3Cb3uZFaAgzUPBcAZWt6/CEp7Qlc5HJBItst9tOTOmXTtTb49qFYPK2e7yww4YwhZHqfyFszGf5rwtBs+fZmjorNLhNC4j8ikHx/ZNhB6hBpsdJUwZKGNyNI6UagIoN2Dg/ULnaSa7ry3N+byywv0cV6o/X9Cf/dnBZzFoYlTPUyYSabiB2g/dkXtPkQwMCUktWqRXv5CQUpvJXryy4YLED1z0WBVGuQuTeL653k4dA6Gtz9rfejQ9ZbYfCIbKna/r3MexPzuKzZGTYXvpI9aX4sv3RWCDkLtvD540usc5KabGr5BDbxlJc8Gy+ohcCoRiPUKD5i/lhZ/zJMj+PBRN1FJl6hiDVna8alHmRGqN+7LsPXv0Mw1Q2G7FE2BtnLYQIPuZPUaRnBHGm9wZ4UVK9qBw4twVIWXYURDUYvgw0TfHXWgHxlFy+MYfQCrAF2hvPJTjfMtacDkYiEtpBzTIeduTjR+qh13A6Sog5DgFeTHhPRSx8+yYETb9wL0BjyzvOL9uIMJ/5Magx6Sy0GE50KVB5Y3Zoq6+/
 rk7R5tsd
 0VhlxIdUt+GHiNV8ECQq936+hdbv6fXvnz+cXsiq2omndOAv9+gZMMqHJeLYwzyJtdzmT84/U9k++tml3/5rWLr0qLYJa/RTuRJOB92GYjhBNhV47Q7YLG2lKfeamN0B7qnEFH5mx0XRdff+ALmdF9pZLi4Cd4ja41JyWV8yMnjbBWukQIEyh3GFXsut8WBJN/hKSJwU8KujOUnGUX7G91dyY+JLuw1HayZXA7mQk2iBLhcUavkhQq8CiGqEKbwnLJqkBNzv+crqe6DbcPXBnbmnjCOhFpu4s5Ve52bhX8YZJkeRaIYzjYawBzI1DmZyolL6hhJr9c6T2REdaNn2Kiv3IlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It was found that some of the tests in test_memcontrol can fail more
readily if system page size is larger than 4k. It is because the
actual memory.current value deviates more from the expected value with
larger page size. This is likely due to the fact there may be up to
MEMCG_CHARGE_BATCH pages of charge hidden in each one of the percpu
memcg_stock.

To avoid this failure, the error tolerance is now increased in accordance
to the current system page size value. The page size scale factor is
set to 2 for 64k page and 1 for 16k page.

Changes are made in alloc_pagecache_max_30M(), test_memcg_protection()
and alloc_anon_50M_check_swap() to increase the error tolerance for
memory.current for larger page size. The current set of values are
chosen to ensure that the relevant test_memcontrol tests no longer
have any test failure in a 100 repeated run of test_memcontrol with a
4k/16k/64k page size kernels on an arm64 system.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 .../cgroup/lib/include/cgroup_util.h          |  3 ++-
 .../selftests/cgroup/test_memcontrol.c        | 23 ++++++++++++++-----
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
index 77f386dab5e8..2293e770e9b4 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -6,7 +6,8 @@
 #define PAGE_SIZE 4096
 #endif
 
-#define MB(x) (x << 20)
+#define KB(x) ((x) << 10)
+#define MB(x) ((x) << 20)
 
 #define USEC_PER_SEC	1000000L
 #define NSEC_PER_SEC	1000000000L
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index babbfad10aaf..c078fc458def 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -26,6 +26,7 @@
 static bool has_localevents;
 static bool has_recursiveprot;
 static int page_size;
+static int pscale_factor;	/* Page size scale factor */
 
 int get_temp_fd(void)
 {
@@ -571,16 +572,17 @@ static int test_memcg_protection(const char *root, bool min)
 	if (cg_run(parent[2], alloc_anon, (void *)MB(148)))
 		goto cleanup;
 
-	if (!values_close(cg_read_long(parent[1], "memory.current"), MB(50), 3))
+	if (!values_close(cg_read_long(parent[1], "memory.current"), MB(50),
+				       3 + (min ? 0 : 4) * pscale_factor))
 		goto cleanup;
 
 	for (i = 0; i < ARRAY_SIZE(children); i++)
 		c[i] = cg_read_long(children[i], "memory.current");
 
-	if (!values_close(c[0], MB(29), 15))
+	if (!values_close(c[0], MB(29), 15 + 3 * pscale_factor))
 		goto cleanup;
 
-	if (!values_close(c[1], MB(21), 20))
+	if (!values_close(c[1], MB(21), 20 + pscale_factor))
 		goto cleanup;
 
 	if (c[3] != 0)
@@ -596,7 +598,8 @@ static int test_memcg_protection(const char *root, bool min)
 	}
 
 	current = min ? MB(50) : MB(30);
-	if (!values_close(cg_read_long(parent[1], "memory.current"), current, 3))
+	if (!values_close(cg_read_long(parent[1], "memory.current"), current,
+				       9 + (min ? 0 : 6) * pscale_factor))
 		goto cleanup;
 
 	if (!reclaim_until(children[0], MB(10)))
@@ -684,7 +687,7 @@ static int alloc_pagecache_max_30M(const char *cgroup, void *arg)
 		goto cleanup;
 
 	current = cg_read_long(cgroup, "memory.current");
-	if (!values_close(current, MB(30), 5))
+	if (!values_close(current, MB(30), 5 + (pscale_factor ? 2 : 0)))
 		goto cleanup;
 
 	ret = 0;
@@ -1004,7 +1007,7 @@ static int alloc_anon_50M_check_swap(const char *cgroup, void *arg)
 		*ptr = 0;
 
 	mem_current = cg_read_long(cgroup, "memory.current");
-	if (!mem_current || !values_close(mem_current, mem_max, 3))
+	if (!mem_current || !values_close(mem_current, mem_max, 6 + pscale_factor))
 		goto cleanup;
 
 	swap_current = cg_read_long(cgroup, "memory.swap.current");
@@ -1684,6 +1687,14 @@ int main(int argc, char **argv)
 	if (page_size <= 0)
 		page_size = PAGE_SIZE;
 
+	/*
+	 * It is found that the actual memory.current value can deviate more
+	 * from the expected value with larger page size. So error tolerance
+	 * will have to be increased a bit more for larger page size.
+	 */
+	if (page_size > KB(4))
+		pscale_factor = (page_size >= KB(64)) ? 2 : 1;
+
 	ksft_print_header();
 	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
-- 
2.53.0


