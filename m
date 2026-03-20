Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 378D71099B40
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 20:43:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7FE06B00ED; Fri, 20 Mar 2026 16:43:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C944F6B00EF; Fri, 20 Mar 2026 16:43:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34146B00F3; Fri, 20 Mar 2026 16:43:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 936DF6B00ED
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:43:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3BD801C9D4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:43:08 +0000 (UTC)
X-FDA: 84567616056.02.9812111
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5FD831C000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:43:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LpTd45nU;
	spf=pass (imf21.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774039386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+VsJFp2tNWi9W0z5ic43UYrbznU9xub21G0oKpjTUlA=;
	b=xLDbLqJfyZ7YN4qfXhomMtRYKSAeFIKArDfYEJSt6iF9xW9vy6+IS73MNkAgJpu/ej7l0G
	XCLxw3X4xZyfaMatshRjL+2J7ch8m+kRNjsSgCBWIc8crfUzNpuKLFlDS31MZuDNsEod+X
	9mClLg41pqstOxxCALAfwaD3CqcY++4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774039386; a=rsa-sha256;
	cv=none;
	b=nHdKsXhVZc68q0hu7d7SevIolawfOv5WduEG5rdkUH8W78Ml9TNaosBeI28xJMMX8dzKMv
	k38Igl+XLqudFcP7G17eBagEuhPrU9qaN1ExGw9WDBP2Kh7qmnT/hE24J807DQzgdOTcHe
	8DcjIMonu4+UyOQG2nXPIK1RyHVuSAE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LpTd45nU;
	spf=pass (imf21.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774039385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+VsJFp2tNWi9W0z5ic43UYrbznU9xub21G0oKpjTUlA=;
	b=LpTd45nUOODfqesVKxr1t0znL+nQxg0vB/E/znuJMEetkS+vFwmTwyWhQhR0GekIT9pSU/
	5lzFNAupw980D+xsxKRida9uS0HZEpN2MSjd+Nwm08UVaywNGfSaK3+OGXtrAggwX1wB3c
	xSe3SVTgiSbpg387ueSkP/nmpLEUszY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-l_GXzCzJMD-UhlKZH8gwFw-1; Fri,
 20 Mar 2026 16:43:03 -0400
X-MC-Unique: l_GXzCzJMD-UhlKZH8gwFw-1
X-Mimecast-MFC-AGG-ID: l_GXzCzJMD-UhlKZH8gwFw_1774039381
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 78E78195609D;
	Fri, 20 Mar 2026 20:43:00 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.65.139])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9FAEC180075C;
	Fri, 20 Mar 2026 20:42:56 +0000 (UTC)
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
	Waiman Long <longman@redhat.com>,
	Li Wang <liwang@redhat.com>
Subject: [PATCH v2 1/7] memcg: Scale up vmstats flush threshold with int_sqrt(nr_cpus+2)
Date: Fri, 20 Mar 2026 16:42:35 -0400
Message-ID: <20260320204241.1613861-2-longman@redhat.com>
In-Reply-To: <20260320204241.1613861-1-longman@redhat.com>
References: <20260320204241.1613861-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: yboUjnTVVnmKquVE2wjEFclU7PL0x4gma4tafsN8us4_1774039381
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5FD831C000C
X-Stat-Signature: i9rpk5gp8k5sdntq9d3bjs9qprtkx78t
X-HE-Tag: 1774039386-404588
X-HE-Meta: U2FsdGVkX1+4HxITTxcFcJVov3GQf2SK7lBjIV2VdzKPO/3RUtL02x+WHUeOmt6njOKs8gzmecaIMGDLC2RtXfRRjAXLSEb1BkTdab3+ltwSoGdFpr/N8J20bLil07FimKURkJsItMpQ6dmnBunHqDz1SgDq+whI1hGv3qKqIQF8Rf4Tp8DvtBPspKWNAOu7YwWeJ74cerjMFSdf/gWT6eN4OWxX4CQTOBXPXO7EpdzvFJsya2NkNFGRCESpPn/POvvRA7dHQrmjhhweRe2t6MvT1VzPDaOPVh0LJxO4WXgbOy6cNl7x82+CYxZPrq6dzTfEwSjVXpbl7IJYzJgxzY7gEOPCMmYcJBv7BxlrTTcebjD/zGlNaQX+LWi49MMrQUVN2QRvHRvY29UH8IP9pG6F5YHlkuNzlcLOZGb5LcE54wwCsQSrpb/7bOTC7PPHy5VvtOH+BmkVivMG0rg5BjJ8N4NjFFAJ7t02VAQGCKGHWsLCREPjaY04VOTjTmiCGzCeUYI7+3plppNNm/GqxzjnQFcY5DcuRct81FvdAhD7CtM2anASCAg23Ig+iZtC2zVOaf9HQbVyIjifwtqF/owAXn+bVaYVRNFRXHyN26RcRhEXPR7WhPTKPc1jmWkxWnjkuAUOwhZSXVYVQD7Sk0rxsQWjC6Pi3AQzOwjreVOV1RyoUQmcLMBXvr7EdWq2usZzH+PJdE9OF/2lvaPayx9HK+M4noOmeezKSPeJESkZ9LPO4De8sIc4PshvvOsjUEY9zDH2/CLpS7aFd4CkSCFYzNe0T+kvOUw85+RFWmBlatVCST0/g3Wf/ROO9F/qkg2ndkNKRch/fT2DmHnV3dQGjuZYBCxWPP49dd6jP6n0f9AGMs2Cj2/KE/7ncBTXXUegOQbQtraXLir25W/SqkUdl7ZxW2y7TWFzWQuqPT1gjhOdn4FxJR9tDwx9ky03oLfNpf6SiKkvmJnRKRn
 bbTn05aT
 K7Vd6PTVaGqli3l0ElmH8pNq6luqGHmLgw9J81U3pKiu6EoKQyx4G1VbY09oqo+eSbX9ML9svoIQc88G3elrELulWG0I2Z+CI+Ryvf1hh1QwFDyKR3ha/kgUfzQSFl1UEsq89uTOZnCW4rMgH7bSGdKs+4KVMvmMHKFeQ1WdVQg4WEqZi4hoKcEOO53FHD57NO3B/4pEOCeMlzU4fJw/xsFcwqEzlNlwov/qhAvOD2A+x0VGt0uBG8VPq4bFoqJKSeTVC2GsQUQGsrklf5dKmqKuNn2fc87go6zhBhf1KOFzhSootIRZdFo/g8KbEtAxQLj1T+zqEsHCQBmisXyzJcMeNQxxz77zWLk+3dtGCBVkCiieGieCqXUe5AE9CpMV6zc8gzFlcNtO7PaUSmmt7Bmgg/aQePB63TbFc
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

To make the output of memory.stat more correct, it is better to scale
up the threshold slower than linearly with the number of CPUs. The
int_sqrt() function is a good compromise as suggested by Li Wang [1].
An extra 2 is added to make sure that we will double the threshold for
a 2-core system. The increase will be slower after that.

With the int_sqrt() scale, we can use the possibly larger
num_possible_cpus() instead of num_online_cpus() which may change at
run time.

Although there is supposed to be a periodic and asynchronous flush of
vmstats every 2 seconds, the actual time lag between succesive runs
can actually vary quite a bit. In fact, I have seen time lags of up
to 10s of seconds in some cases. So we couldn't too rely on the hope
that there will be an asynchronous vmstats flush every 2 seconds. This
may be something we need to look into.

[1] https://lore.kernel.org/lkml/ab0kAE7mJkEL9kWb@redhat.com/

Suggested-by: Li Wang <liwang@redhat.com>
Signed-off-by: Waiman Long <longman@redhat.com>
---
 mm/memcontrol.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 772bac21d155..cc1fc0f5aeea 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -548,20 +548,20 @@ struct memcg_vmstats {
  *    rstat update tree grow unbounded.
  *
  * 2) Flush the stats synchronously on reader side only when there are more than
- *    (MEMCG_CHARGE_BATCH * nr_cpus) update events. Though this optimization
- *    will let stats be out of sync by atmost (MEMCG_CHARGE_BATCH * nr_cpus) but
- *    only for 2 seconds due to (1).
+ *    (MEMCG_CHARGE_BATCH * int_sqrt(nr_cpus+2)) update events. Though this
+ *    optimization will let stats be out of sync by up to that amount. This is
+ *    supposed to last for up to 2 seconds due to (1).
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
@@ -5191,6 +5191,14 @@ int __init mem_cgroup_init(void)
 
 	memcg_pn_cachep = KMEM_CACHE(mem_cgroup_per_node,
 				     SLAB_PANIC | SLAB_HWCACHE_ALIGN);
+	/*
+	 * Scale up vmstats flush threshold with int_sqrt(nr_cpus+2). The extra
+	 * 2 constant is to make sure that the threshold is double for a 2-core
+	 * system. After that, it will increase by MEMCG_CHARGE_BATCH when the
+	 * number of the CPUs reaches the next (2^n - 2) value.
+	 */
+	vmstats_flush_threshold = MEMCG_CHARGE_BATCH *
+				  (int_sqrt(num_possible_cpus() + 2));
 
 	return 0;
 }
-- 
2.53.0


