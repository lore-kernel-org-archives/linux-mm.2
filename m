Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6C171091902
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:39:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3618C6B056C; Thu, 19 Mar 2026 13:39:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 339546B056E; Thu, 19 Mar 2026 13:39:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2018A6B056F; Thu, 19 Mar 2026 13:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6886B056C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:39:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CC0325A042
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:39:10 +0000 (UTC)
X-FDA: 84563523660.03.B3ABF12
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2BFC94000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:39:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EF2BegOD;
	spf=pass (imf01.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773941949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dNJ6Lq8/T1XPjKqwxrWp5F2Bbd2jRHO9QNryMAsqUQU=;
	b=hDtTRcqQo34eFG1eHFrHugrGoszH+3aeZjar0629xX7l8RVAx0vDNQtyc/StGWwDJL1/Ii
	0xuTyYpKhH6OnycD12zXhwgMKv7qlczBlEO3YdVw5xsWu/IjnYAGPxyuRLBWWJ/cEymYoB
	6rZv8QKrjOaq5bnknHtcxNO7SXfVIiM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EF2BegOD;
	spf=pass (imf01.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773941949; a=rsa-sha256;
	cv=none;
	b=SziA/X8BhRUxVVjn1jAAR5Msd9QA+5fCTve+HpFZFpers53mxQf4bOwSQH4Y2y6s6eLN/T
	9oB/MHl3AGdIU7NPHSq3RvyHAcukTYjaGteppKn1xkyn2KTD/Bg2aQeIwmvqD2Ls0/q+Oq
	/7OVkEPxeFWbina/WtDj6QzajkD+G50=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773941948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dNJ6Lq8/T1XPjKqwxrWp5F2Bbd2jRHO9QNryMAsqUQU=;
	b=EF2BegODVZb0Jh4pmYXMvdDbOGQhBTzyB6+a8rL3Fz33SCPuVwo6gslNuQUNgwo3yMKipu
	FRnmRmCEyl+tHl3IPjKPHJ8W5ZIzy7wnuAmsC8AHx0GLX2f0jKO5FnINvGyuFfcYXED9VZ
	Lfz+pHfHQ1JwPny5ZU3YbCNwFsgv9Xk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-687-31Ev_X7TNdGagwe5I4LhcA-1; Thu,
 19 Mar 2026 13:39:05 -0400
X-MC-Unique: 31Ev_X7TNdGagwe5I4LhcA-1
X-Mimecast-MFC-AGG-ID: 31Ev_X7TNdGagwe5I4LhcA_1773941942
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A0481944F05;
	Thu, 19 Mar 2026 17:39:02 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.80.194])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7068D30001A1;
	Thu, 19 Mar 2026 17:38:59 +0000 (UTC)
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
Subject: [PATCH 4/7] selftests: memcg: Increase error tolerance in accordance with page size
Date: Thu, 19 Mar 2026 13:37:49 -0400
Message-ID: <20260319173752.1472864-5-longman@redhat.com>
In-Reply-To: <20260319173752.1472864-1-longman@redhat.com>
References: <20260319173752.1472864-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: OnrJ5fMTU2x34mf7-dFTgNJMduLNTngoc5sqaSsGgBg_1773941942
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 2BFC94000E
X-Rspamd-Server: rspam07
X-Stat-Signature: r48o3nk6i4cn9yerraqq9u1c89ibzo94
X-Rspam-User: 
X-HE-Tag: 1773941948-878600
X-HE-Meta: U2FsdGVkX193XZZ9RueKFZIgJWyce9gllwppGh4dmOc7x6htEDSFeBbxRN0uhkoDf1IRaLvtwmx58osW8892O/W9gYfnxuDUhF5FsTgzxXgD1Px9JjpeZdPkKMl4Exp+sGzzUTgvtlBbfKtNWgosGMuBS+FQAjvgYrUMYRfJXlefSx1z2BJY5oEhOq0XW+KE/Wb40/8rXZZZJMYAX5tfOXegbZg0tIwAWpKcPrrDcbqiuusXynRhff2b54XrvXxx6Im4JmVHkhLx0yPNkmdyi2DuBmw3Reqa2P0ncvJaWqVicLY7/fa6no/pMzfYwHZEBGwrN8xT3XcSrDRLBz+NJ3zhE130qNXngWZAMzxNPPmmmEY0K5vduEmlgjVQikIfzlrR4s8onnhjUrwULcs4lPDtJlSlQkAj2oMU2Qf1sX39aL5h45QXvHs4Mlhgbi6BwdIrUDPoFVCZ3EQBB1JZ3CFUKBfjcCNAPrR6oI3/gzmAh4Hkio1pdXZiWjbPp7SZlqvVO2haeLtgw9KNmGh/npvPromtlqWD1H4kiQLi0rok6URO0Sh8BXDveMjS9Dq7x1syvFewk5yt17uJ0h6+kWeM5ob7313/lOAxX9cCtR32syPebGzoTiP8XS79qw1IQ/XqUM4qmP4/HGc0xPBsSpDi9O/8MiGDoiHgMbv8cRnk2KdPhKjNOhaFWGlBH7x0taDSc1OVZetE1glni0i10yaLT8zpqLwKsLhfkQMg9PqpdXjSiO8brgVvi3r+KxTzv4JuaGzvKeP7i5NAIALDuUDgFCLt5CTVWARc6rJvJvmLTu5QUltz4piz6SF5WPNoi49UEA+wlR2FFimpDSQQ/MSHwRBvvkC8vQgn59DSOOFlGkVGWfdb0n0Z5fLayYnghHL8ZLmBFRlu1yBGJgw497BIf6orrIic9rhzNvC2Vz7KZkPsnZCPw61AcPntNlzDqmP75KC8JEXknL/oDbd
 mBD9ZlWC
 TnAcL31AZUV9atjQuG//58+O1aQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It was found that some of the tests in test_memcontrol can fail more
readily if system page size is larger than 4k. It is because the actual
memory.current value deviates more from the expected value with larger
page size.  To avoid this failure, the error tolerance is now increased
in accordance to the current system page size value. The page size
scale factor is set to 2 for 64k page and 1 for 16k page.

Changes are made in alloc_pagecache_max_30M(), test_memcg_protection()
and alloc_anon_50M_check_swap() to increase the error tolerance for
memory.current for larger page size. The current set of values are
chosen to ensure that the relevant test_memcontrol tests no longer
have any test failure in a 100 repeated run of test_memcontrol with a
4k/16k/64k page size kernels on an arm64 system.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 .../cgroup/lib/include/cgroup_util.h          |  1 +
 .../selftests/cgroup/test_memcontrol.c        | 23 ++++++++++++++-----
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
index 77f386dab5e8..c25228a78b8b 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -6,6 +6,7 @@
 #define PAGE_SIZE 4096
 #endif
 
+#define KB(x) (x << 10)
 #define MB(x) (x << 20)
 
 #define USEC_PER_SEC	1000000L
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 3cc8a432be91..2c3a838536ae 100644
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
@@ -1681,6 +1684,14 @@ int main(int argc, char **argv)
 	int i, proc_status;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
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


