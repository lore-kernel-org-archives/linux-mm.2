Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3E351091901
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:39:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49AAA6B056E; Thu, 19 Mar 2026 13:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4720E6B0570; Thu, 19 Mar 2026 13:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AFA56B0571; Thu, 19 Mar 2026 13:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A45D6B056E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:39:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DA4765397C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:39:15 +0000 (UTC)
X-FDA: 84563523870.14.AB6BCE1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 25E7C18000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:39:13 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Bn19/LJY";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773941954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zkUulf/dklOOtLe7ygalmkfZiPOwnIaF4ZwIQQPoF50=;
	b=fS/P4Sua0xpIEMcLxzKFx3MsavDEhhCBOvu1KhJcolBXHLRYGdM4Tn1a7lHc7IRqNsNGgj
	B05770XQfXFSefyOYAbryXNvO7lGymuD2n8Jc9l722jqfgRYIYkB0FAHhqXxMLHonEB2UM
	YN49P9hAYoPZbOAACI9WOK4kYJdje+w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773941954; a=rsa-sha256;
	cv=none;
	b=XUs5YOoOBJJOvSNXCGJvQ/XsFl15t4kNKF5BxA4giSCGZhsxwyU9zQjXBReYMiEiPFvHke
	VTr1nYikk3rmQvQl0wgaTAnAqLMNTM3nQFkccsmnQBO2G9Ni/hvplCKVAz6u+KWwWok6IZ
	nXH4fq3Y52Iki3yyEL9VpNYtcACAJRQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Bn19/LJY";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773941953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zkUulf/dklOOtLe7ygalmkfZiPOwnIaF4ZwIQQPoF50=;
	b=Bn19/LJYpcPM2p37SaTUQbzF9HnpGJETaH3Gi/3P97E8EXgEkFxpmpiJ8KHQElriDZmx7s
	ujGJB2Wj2WBALAD/baAzWp1RlRCuoq/0LJ/ImEA9TSxht5fhTrPTOuk/ZfwFER7GsmOUtP
	/6gAD61VtscdKY3gZB9B3kS/R95RQqs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-611-HIcTViPWP_quBmhI6xe-QA-1; Thu,
 19 Mar 2026 13:39:08 -0400
X-MC-Unique: HIcTViPWP_quBmhI6xe-QA-1
X-Mimecast-MFC-AGG-ID: HIcTViPWP_quBmhI6xe-QA_1773941946
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB044195607B;
	Thu, 19 Mar 2026 17:39:05 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.80.194])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C4BCD30001A1;
	Thu, 19 Mar 2026 17:39:02 +0000 (UTC)
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
Subject: [PATCH 5/7] selftests: memcg: Reduce the expected swap.peak with larger page size
Date: Thu, 19 Mar 2026 13:37:50 -0400
Message-ID: <20260319173752.1472864-6-longman@redhat.com>
In-Reply-To: <20260319173752.1472864-1-longman@redhat.com>
References: <20260319173752.1472864-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: cHmX5Wy54FJdkbStrSLmZsQ10UdvG5YjSVzCKSuf_uk_1773941946
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 25E7C18000E
X-Stat-Signature: jbbmy6a7wiyuiqgjum8eperw6e7dcapg
X-Rspam-User: 
X-HE-Tag: 1773941953-991897
X-HE-Meta: U2FsdGVkX18AUkaMyp89gtDFO1TTu2ztSqTgG3OcEPWzqXvUYBzy2XBHGOL15Zkfw216Ro1w4vYFjIN1F4CgN9rSRWUpDwi7crrRScG6rw68MoGSvm2eAd6LeevmjaCXIjHrltyoor9nJcHnO3qipT76Rtv7OAHeZzx319hFLOA8EsNcpBcUSyuinYFXT/xFLIise4Xai5Qh/8bi13jGi9mroVEls/vUUl6tGRYV6ZMLyyx58UMvdpLhyLEoQ+ZTTztinRBCBU9XjrOUlHdI20YsJkZeVTaq5aChIOgKSQ0X2KArnbO75uyf+DA9C0Qn4tQr0s19Zb/nC71Ptb9Lxgb3VQLGfGvVS8FMvv5Sz95P8C2RGe/0Jw829f8nV4DseLOTQvGgT2/fZ46zzU8AjWHi7VnMnd7EFQjIGSUlhBInNoV6I0sqdxy4g16hAKweMbqTXoBXLAu10s1NJ9i3uNhTQTpwh3bSW4Sn1hcPLAdE+evVaxEHlEX//beA5Sz6MafcjCSUy+ffAqbPZrD0uVUtdHUxAZArIJewk6il1qogLmzaQUvXkQCoY93rsG/ex1xwcRehf7QER2Osf7PUesuBRJAx1bN/xJqgjUAOIlWeTeFBwN89z7gar6HnSsEZK8XTmT4nfl0bVKrpYevThDtjb6EHfKsSU5ACogjY8PLEtF+Tn6d7mO+D7IbDIMseBiIx3FcgPxP9v0clBYEHfSsTdOJQwkQRzWet9FcTZLgluIAoX8ArWKblimKp+86rx81t318AX4H38b6dWhrA6l1GC/8DoMZUVQFDd65jD1gUaJTN2F7is61+Ryb60bySiyw005eng0J58tBIZUNA0ksEMBW7ZuJWjOav0zpG4f3mxtoT4DsVpDei0IncqBGmYNHRZzFbG3Tx43f4MaHvCubM5uvHO3/+f05rj6QR669qjxnAxOsliIocEUaQfw55bs9CAE6QKtD7hMhEVBL
 VHMLn/yQ
 t458bnJKLH2D8D5WuU1IfIajHug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When running the test_memcg_swap_max_peak test which sets swap.max
to 30M on an arm64 system with 64k page size, the test failed as the
swap.peak could only reach up only to 27,328,512 bytes (about 25.45
MB which is lower than the expected 29M) before the allocating task
got oom-killed.

It is likely due to the fact that it takes longer to write out a larger
page to swap and hence a lower swap.peak is being reached. Setting
memory.high to 29M to throttle memory allocation when nearing memory.max
helps, but it still could only reach up to 29,032,448 bytes (about
27.04M). As a result, we have to reduce the expected swap.peak with
larger page size. Now swap.peak is expected to reach only 27M with 64k
page, 29M with 4k page and 28M with 16k page.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 .../selftests/cgroup/test_memcontrol.c        | 26 ++++++++++++++++---
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 2c3a838536ae..4f12d4b4f9f8 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1032,6 +1032,7 @@ static int test_memcg_swap_max_peak(const char *root)
 	char *memcg;
 	long max, peak;
 	struct stat ss;
+	long swap_peak;
 	int swap_peak_fd = -1, mem_peak_fd = -1;
 
 	/* any non-empty string resets */
@@ -1119,6 +1120,23 @@ static int test_memcg_swap_max_peak(const char *root)
 	if (cg_write(memcg, "memory.max", "30M"))
 		goto cleanup;
 
+	/*
+	 * The swap.peak that can be reached will depend on the system page
+	 * size. With larger page size (e.g. 64k), it takes more time to write
+	 * the anonymous memory page to swap and so the peak reached will be
+	 * lower before the memory allocation process get oom-killed. One way
+	 * to allow the swap.peak to go higher is to throttle memory allocation
+	 * by setting memory.high to, say, 29M to give more time to swap out the
+	 * memory before oom-kill. This is still not enough for it to reach
+	 * 29M reachable with 4k page. So we still need to reduce the expected
+	 * swap.peak accordingly.
+	 */
+	swap_peak = (page_size == KB(4)) ? MB(29) :
+		   ((page_size <= KB(16)) ? MB(28) : MB(27));
+
+	if (cg_write(memcg, "memory.high", "29M"))
+		goto cleanup;
+
 	/* Should be killed by OOM killer */
 	if (!cg_run(memcg, alloc_anon, (void *)MB(100)))
 		goto cleanup;
@@ -1134,7 +1152,7 @@ static int test_memcg_swap_max_peak(const char *root)
 		goto cleanup;
 
 	peak = cg_read_long(memcg, "memory.swap.peak");
-	if (peak < MB(29))
+	if (peak < swap_peak)
 		goto cleanup;
 
 	peak = cg_read_long_fd(mem_peak_fd);
@@ -1142,7 +1160,7 @@ static int test_memcg_swap_max_peak(const char *root)
 		goto cleanup;
 
 	peak = cg_read_long_fd(swap_peak_fd);
-	if (peak < MB(29))
+	if (peak < swap_peak)
 		goto cleanup;
 
 	/*
@@ -1181,7 +1199,7 @@ static int test_memcg_swap_max_peak(const char *root)
 	if (cg_read_long(memcg, "memory.peak") < MB(29))
 		goto cleanup;
 
-	if (cg_read_long(memcg, "memory.swap.peak") < MB(29))
+	if (cg_read_long(memcg, "memory.swap.peak") < swap_peak)
 		goto cleanup;
 
 	if (cg_run(memcg, alloc_anon_50M_check_swap, (void *)MB(30)))
@@ -1196,7 +1214,7 @@ static int test_memcg_swap_max_peak(const char *root)
 		goto cleanup;
 
 	peak = cg_read_long(memcg, "memory.swap.peak");
-	if (peak < MB(29))
+	if (peak < swap_peak)
 		goto cleanup;
 
 	peak = cg_read_long_fd(mem_peak_fd);
-- 
2.53.0


