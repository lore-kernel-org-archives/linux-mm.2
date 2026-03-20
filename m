Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 980D11099B3F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 20:43:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 088776B011B; Fri, 20 Mar 2026 16:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 011B36B011E; Fri, 20 Mar 2026 16:43:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E42E36B0121; Fri, 20 Mar 2026 16:43:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D05146B011B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:43:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E25554A53
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:43:24 +0000 (UTC)
X-FDA: 84567616728.03.FE625C1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7465480009
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:43:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hef3RfkC;
	spf=pass (imf02.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774039402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JO4fo5puVhwmWSTN9p22d3bjrul0eBuHqiTy66++5S4=;
	b=W+YoOCuF+B5SXs3wYfjdqvQMtFSQbkdko1Swd+5OXBDD53pgGArZWbGOQ9T+w9cG054ALC
	0wxOf2w4vQkmGXFEYHkpU79/a1yGIugzCUmN9ObjB1bVQRpQo7f+XEDUPKKwH+vKwW34zQ
	JAf6VN1rcGRP6FaRDVRtWIwbEE1Sq64=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774039402; a=rsa-sha256;
	cv=none;
	b=PVnuDG2JpJese7S6XIaFcmtZy3HU0cFdLZSB8JeMmtKeB3/l8JmiZYAJ8PDM93OopowuNO
	hBv1Wen0SiSK5p16u2FMSfZIGuB1/YBN4Fx1V308XMFrW07WEYD7IC+jTTJ3IP8nI1haRQ
	JWniORJNgwUYx/CoSjDjvC9nYv8ZCKw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hef3RfkC;
	spf=pass (imf02.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774039401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JO4fo5puVhwmWSTN9p22d3bjrul0eBuHqiTy66++5S4=;
	b=hef3RfkClyL6HMY/7U+xarbf+efqVa3fouyAQWgVRWlzGD1wJs7jZPG3XMFv/DBm52sqqV
	5IaQjF7LL11hVNSHNYcJX1JYlHssFLeJRfC/VD/5AOd68kzyD/kUdPvTq0EUcCZVZ2kRnG
	ZCesKXjsaSDKp62AkYa5nHL4bPj+exE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-120-i9oc_bP8ODSUAob25PNTlw-1; Fri,
 20 Mar 2026 16:43:17 -0400
X-MC-Unique: i9oc_bP8ODSUAob25PNTlw-1
X-Mimecast-MFC-AGG-ID: i9oc_bP8ODSUAob25PNTlw_1774039395
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DAB3918005BB;
	Fri, 20 Mar 2026 20:43:14 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.65.139])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6E3CB180075C;
	Fri, 20 Mar 2026 20:43:11 +0000 (UTC)
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
Subject: [PATCH v2 5/7] selftests: memcg: Reduce the expected swap.peak with larger page size
Date: Fri, 20 Mar 2026 16:42:39 -0400
Message-ID: <20260320204241.1613861-6-longman@redhat.com>
In-Reply-To: <20260320204241.1613861-1-longman@redhat.com>
References: <20260320204241.1613861-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 0-8SlhWynRi_ABja5eDvj9KuDzObYgE606oxyMSh_94_1774039395
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Stat-Signature: fkad6uicgpnr44i14wo3a9uo5p1nw6m5
X-Rspamd-Queue-Id: 7465480009
X-Rspamd-Server: rspam03
X-HE-Tag: 1774039402-96215
X-HE-Meta: U2FsdGVkX19cEJ8tPgRC9oIvkI9ck5fEjRbOwz6pZ4BDFVTpTw5rennoFmwfNxqOLjHwKMZSLqGck+YgfBSx3YI+PDB/RAzkleZLD4dnPGr4b07vB2GJi+wQSFM82MXMMtb3exxOUGeAlMoWbAZ7+3IUm1WBT7E2XqgnNw5c+EeevRmlt2jjxs9wNvASfL88MCDAdDxxOBVWOu90Wja4IPC96NwXjmAWEL4/KfH/bFdQaKO30JiE5fEtLpL+yRkSf7xZYtgOpcS91rVhUKEMO0Qf2K5itLQI6DQiwYH4fOiQDkdOJPTdQyXvR4+TbOrZZ3q0Fy3gnv00YNXTZi6VZ8d3bLwvFF4lTtT2BRwzTSR/Dmt0DOaijT/vaeKk6Kk3LLT29Tn0OicR4rNul8qqkASRAkmtTx1ItuK4Io04MDZRM//Tlkztwy7UPWRevyp11Zy9/Xr3cRFSZ5rnYjkEAalyHPthvC8dRJc6MVoKRdCAJerEYLeTAsGcizJz/7NTfGafMsXgAHisTLws76rsIQhAR95WFKoq1UMTvO5b9UyvFo5JWSQc1Z+5ZzJLTSBmzSFX2s4DeGsewwBtgpCjQqjqTerlYrxtDyAOJdzouS85x1UHhW9tubBfS83ZOmHD1OMPp74kM6697cdCJpAX2pRO7/s2BhfSWanYQEQytr4CQofBFXpT8TAfc724dbCkwncLIa7vuc+bpzg7RmKWctRWSe+LHsjYJFGa04vBDdfWKXB6kn6RpOhdQ4aDZR0Lpwv0XqD605CcL/gNmxo/qjEmuAq8ZXQpJBts6NsPaaP5MZtjI3pfPf9tF9DT+Ztuuhn5+WHsZXLq3yxrjkYxLLHfzV8ZRJ/9NI5xe2rBzweM64UKrzgRdldmxNZH8tiC5VHstmc9EapWfaoOAmHJoCFwertKn77Pgs9A9/VkpQBGZgqy8hx3XVTlV4sOrGjuUonYmWE/cdfjqr1dTiQ
 hL92050+
 GkHyjKFSDSSfc0Gr7CevShwmtKEQA+vZYMr3bjoDana2bGgYueY9JTl95fMbQThZQsD5acoHN6P+xHe6pJzEIy2XmoKCK4BpI/6xUUuoOsrrZfsipGFguaWX+xntNthyIkyDrySUOM1pVCOLIQo772FYPy/jQBZ68yW94SUDwcJitqp8sptuuj8iLGd6A68Xw4f4EGzOujpTzWz2fzxr1cLebfKW8qO807wtMy+NOD8GSwiTYBUfia7C/8MxMUiYuuF4RAMNbonXFmleNKPtFw8so+uVdv2U/xZi6CfvvhXc+s5ezAenc5YOTcPQKFLNYtJoZMDrumgawRCe5P5UNqVPKnA==
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
index c078fc458def..3832ded1e47b 100644
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


