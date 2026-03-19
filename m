Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D9A31091901
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9068E6B0566; Thu, 19 Mar 2026 13:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DE996B0568; Thu, 19 Mar 2026 13:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B746B0569; Thu, 19 Mar 2026 13:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 724B56B0566
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:39:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4387A1A0674
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:39:01 +0000 (UTC)
X-FDA: 84563523282.02.9BF0807
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 63F94140009
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:38:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bci7S3Uo;
	spf=pass (imf26.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773941939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqbIelhKh/+RMtXT/TasUG8zStElNREsucgnnLo8/DM=;
	b=1oIKZmqYgCp+Y2eBnFqQlv+ul9AGn4bXyvScgsl9c9CLDM8cjvEr2vB4kBd931O1SAIAMp
	f9RWfUsHCE20xHJsdij6xTKrOoQULY+g0V69qvnpXxuuXkoZKZMWl6pkZbwdZMPQz/+I4S
	qh1G4OCz/lvoVyz7qurXEB+gjykAK7U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773941939; a=rsa-sha256;
	cv=none;
	b=esEObVfwh5pZg57gSVM9oaaCHLOrO/451TRVB4pWrsuKb2zUFEboLmcGdt5D30qQWjP1fb
	KXEuFc1zzU4dodUo4QxGcPa1bwYCBh96yrt5AXBoimygFoQIpsIylyX8166lV/DYHgvrLY
	4kIjtMZoIN/K6bYyDBVwZ34t8Im1BwQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bci7S3Uo;
	spf=pass (imf26.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773941938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nqbIelhKh/+RMtXT/TasUG8zStElNREsucgnnLo8/DM=;
	b=bci7S3Uoq69yIfIA4wSXMxRdieDNvPqPzqgcJv5OUIscpGAlIqXMVS9SnY82u6x17yvlqu
	wMOTnS54Slt+qsGLmg1VTO/Ko55sHf9bi0/KfXRAmrj/N6VeEd2pFHLzBNxNE9T5Twz/7Y
	+en+TeR/FUxsGMH/fXCKA2KzKUfNE0Y=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-523-lNQCi7DFNEiVKg0aQMKFfw-1; Thu,
 19 Mar 2026 13:38:55 -0400
X-MC-Unique: lNQCi7DFNEiVKg0aQMKFfw-1
X-Mimecast-MFC-AGG-ID: lNQCi7DFNEiVKg0aQMKFfw_1773941933
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 627591956062;
	Thu, 19 Mar 2026 17:38:52 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.80.194])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D86ED30002DF;
	Thu, 19 Mar 2026 17:38:48 +0000 (UTC)
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
Subject: [PATCH 1/7] memcg: Scale up vmstats flush threshold with log2(nums_possible_cpus)
Date: Thu, 19 Mar 2026 13:37:46 -0400
Message-ID: <20260319173752.1472864-2-longman@redhat.com>
In-Reply-To: <20260319173752.1472864-1-longman@redhat.com>
References: <20260319173752.1472864-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: -gdq2FiMV60DAs2RgcJEYh95rvKJ517gKj-CeiLXbjk_1773941933
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 63F94140009
X-Stat-Signature: f1scmw79nhwzfpboegx9fk9fq9km9ogg
X-Rspam-User: 
X-HE-Tag: 1773941939-943847
X-HE-Meta: U2FsdGVkX1/3WeYQv0VVCxTmK4o5W9Jb2PykqKi9tV067N8wNA/5gpxNsUaot0nvunvwxz2ZFWNW3oLqxWiD5D9JB5WRbNJetenIqb4agoNrP+WH3A+Z3zKLq7hfqoDpdSgxwbgMbY9lmRXLDY59TVQec1pW0KFoQ+xEXivLobLl16qXt8hIlIh5//xDwu8AM+uZ9lXpN/+PY4IMsAijtRTsRWYufpci9eVDHfBlDVl473ULPp3R6g5s83NLnVhTBA7rnH2xJM3bBKd92FHrnIgP8pEnnnLwGZD23s5naZXPr3I0wYF7zhc1EmgP9V6lc/5SS9mVmGngnqoY/UjUYhnDKYiEj96AiPfVz7kUHmQe9gxx2JxxzdaN+N61neK/oPyyM12nQcOfVN3x9MTPfVohNC7iaQ8EFA1ZixEpCuiSiQwkAIPc3XXaGfNpxZsibX3GxG4R1A73KwONC4Rj+AWTPKvOESvzGpVkAq5p+xlf0GZ5qxcpn0iJxLlHahINuTcmLuzBh3r+XsNewF+KWk72MNMrueZe3u4TUiKNJIAZtWGy4aA++57eYceVT7GjE7igjTkPqNdxBjGUwIj/VDFelu47JaXuTD8n48gu8m5wFpVz5tM3Gn70SYAYjZlBM+hixcxYpgexIfTINIye+Ydg0N9dRSXvGoMdi5WJKIQeO2YfVPjXGghiZJIyHly6UqFwcyRZxCr90ZUlPfTt9PLArOcEZpYMozIQvrhKCN12qnbwn8kLwRQPnGX/zcUe6DX8lYvBelQtxbHmzkRadhpWi3uz8l6ivlRmHXrMYlc+PR5bDQKAcpY2xfh6SHM/P93040FPkWPhMThZr46xtbpzp7fP+glQ1cUkE80HgJSq3prwk54SF8RPu6w5C+JGWek8UcQjXsvcmMKq2XOnfHWngSpV+FtFKh3rGBVrsqIsTbvRlaZwjvz+j4VryQ2feC94eFybqLBLF+NQ1N3
 nhPkDiTJ
 eOyYU8IzoS+J7sDbAHfkoLYGsvLbJ58lGunpw9cRDFdrIXNYU7FdEzij3j0NONQphUBx7Y9ePzq5lZn2w4FxmB080v6zoD32wwFB4V61UOfAKSNCr97QXi836qttPG4dTzpmGOFDpjh9dxuaGeqoWmEWaOLAwFTqDpaBUdThVreFHFpxbzZOFMrA5Hy552omtXnQcpvqcAl+8Y1X3gWAfJVzPURIj2S1s/0RB1utgOcNMxtfd7Ri3ENgj3QDS7b4ohHe3YRSh5XZm190sVmpo9BvmVgj5Kaz2VSJuPu9Ad18xm92wq7u4eZG9JpTeiQiLWr0oBETUW4S33HKqCTSugbxKyKQdLYHRxopzinU8rHjrNAVnEjFBRbzUp+RrT3urb6tBD3xKfV76f0k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vmstats flush threshold currently increases linearly with the
number of online CPUs. As the number of CPUs increases over time, it
will become increasingly difficult to meet the threshold and update the
vmstats data in a timely manner. These days, systems with hundreds of
CPUs or even thousands of them are becoming more common.

For example, the test_memcg_sock test of test_memcontrol always fails
when running on an arm64 system with 128 CPUs. It is because the
threshold is now 64*128 = 8192. With 4k page size, it needs changes in
32 MB of memory. It will be even worse with larger page size like 64k.

To make the output of memory.stat more correct, it is better to
scale up the threshold logarithmically instead of linearly with the
number of CPUs. With the log2 scale, we can use the possibly larger
num_possible_cpus() instead of num_online_cpus() which may change at
run time.

Although there is supposed to be a periodic and asynchronous flush of
vmstats every 2 seconds, the actual time lag between succesive runs
can actually vary quite a bit. In fact, I have seen time lags of up
to 10s of seconds in some cases. So we couldn't too rely on the hope
that there will be an asynchronous vmstats flush every 2 seconds. This
may be something we need to look into.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 mm/memcontrol.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 772bac21d155..8d4ede72f05c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -548,20 +548,20 @@ struct memcg_vmstats {
  *    rstat update tree grow unbounded.
  *
  * 2) Flush the stats synchronously on reader side only when there are more than
- *    (MEMCG_CHARGE_BATCH * nr_cpus) update events. Though this optimization
- *    will let stats be out of sync by atmost (MEMCG_CHARGE_BATCH * nr_cpus) but
- *    only for 2 seconds due to (1).
+ *    (MEMCG_CHARGE_BATCH * (ilog2(nr_cpus) + 1)) update events. Though this
+ *    optimization will let stats be out of sync by up to that amount but only
+ *    for 2 seconds due to (1).
  */
 static void flush_memcg_stats_dwork(struct work_struct *w);
 static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
 static u64 flush_last_time;
+static int vmstats_flush_threshold __ro_after_init;
 
 #define FLUSH_TIME (2UL*HZ)
 
 static bool memcg_vmstats_needs_flush(struct memcg_vmstats *vmstats)
 {
-	return atomic_read(&vmstats->stats_updates) >
-		MEMCG_CHARGE_BATCH * num_online_cpus();
+	return atomic_read(&vmstats->stats_updates) > vmstats_flush_threshold;
 }
 
 static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val,
@@ -5191,6 +5191,13 @@ int __init mem_cgroup_init(void)
 
 	memcg_pn_cachep = KMEM_CACHE(mem_cgroup_per_node,
 				     SLAB_PANIC | SLAB_HWCACHE_ALIGN);
+	/*
+	 * Logarithmically scale up vmstats flush threshold with the number
+	 * of CPUs.
+	 * N.B. ilog2(1) = 0.
+	 */
+	vmstats_flush_threshold = MEMCG_CHARGE_BATCH *
+				  (ilog2(num_possible_cpus()) + 1);
 
 	return 0;
 }
-- 
2.53.0


