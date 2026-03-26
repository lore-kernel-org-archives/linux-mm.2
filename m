Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DECE2FEA800
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 03:27:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 568DF6B008C; Wed, 25 Mar 2026 23:27:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51CE16B0092; Wed, 25 Mar 2026 23:27:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4597B6B0093; Wed, 25 Mar 2026 23:27:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 334896B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:27:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B831A1B9134
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:27:33 +0000 (UTC)
X-FDA: 84586779186.10.1CAFAC2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id C8F5810000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:27:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FPM7oNfq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774495651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=riRX/G54k0buVLVoARmr3GpOP9R848ATdW4K3IUdxAU=;
	b=vE8I5TbhVre5xdJefU8X/RvXcR2B9o8qNtp7z2P+6v5JXLRadQnubE4M8REU2xh5o4o6Vz
	WER9zMI4hKIIRNl4a8xXhO0M4ht5S5C5KtPsEOi1wLFvyzI6TMrhgQc6w3OQJ6CoIDOQg1
	M2IYuEO7VHilUkpQsYTaspxM3PoaYBY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774495651; a=rsa-sha256;
	cv=none;
	b=1UMyOOkXsZ2X0WrMc5x7jhglaWtSjdNpAwUYTU5PwiMQP8Oi9UnUYRiehgFRueKnJ4ppxa
	bPY1yOPei98rJgVVdIgAKlOKF6OgryDnyi2hiZ6oNDPb/CFdb51rmeekoJO/sLfhULY6u8
	nkDABP4llHJrJaAlGer7Znx1JIeYgyA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FPM7oNfq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774495651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=riRX/G54k0buVLVoARmr3GpOP9R848ATdW4K3IUdxAU=;
	b=FPM7oNfqQoH1Z2ASs3iGEapdWmcaupi/KQ4/mUvI9OZgyQ7mf9Cm1T8+is+wCmtK4hUo4e
	IMpCzuaJgJBcV1lOQ5J3dH/gQCCrO19P/+TYCCSqkRhry7OMyCUO/CBamJjAJLBtHV1lad
	xyVl37AfSnQEIYzO8BaOD8bu2BW3Evw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-147-JMFJPb-wMjiHgOZhQyLkWw-1; Wed,
 25 Mar 2026 23:27:27 -0400
X-MC-Unique: JMFJPb-wMjiHgOZhQyLkWw-1
X-Mimecast-MFC-AGG-ID: JMFJPb-wMjiHgOZhQyLkWw_1774495645
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 02A1C1800281;
	Thu, 26 Mar 2026 03:27:25 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.83])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1CDCE1955D84;
	Thu, 26 Mar 2026 03:27:17 +0000 (UTC)
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
	linux-mm@kvack.org
Subject: [PATCH v5 2/8] selftests/cgroup: avoid OOM in test_swapin_nozswap
Date: Thu, 26 Mar 2026 11:26:52 +0800
Message-ID: <20260326032658.96819-3-liwang@redhat.com>
In-Reply-To: <20260326032658.96819-1-liwang@redhat.com>
References: <20260326032658.96819-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: WPAAd_0SyHyiSLr6lahnzkoeRuEbQ4-ktXeJp-uQ9X4_1774495645
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C8F5810000C
X-Stat-Signature: myjcw8dx66ti1zghjstzccnuf4mnqnr3
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774495651-945318
X-HE-Meta: U2FsdGVkX1+4ZjEB+LuezK4NQR7Cd5E0rObDHNaglq+9sVXSENWuwGNOjTwmxoXVKPo6SUDiqPCuHBb2Af9dXNUpG7roXy5jb9SN82DahWQbJme5UKzW5OiDs4OMDRSVErBQaWqpJ32QeYkbUjK9BSkpaWuYY9i226hH1PrI25VINA59q6UdDD4Prgr95RPSF735iGvyYAtOMcGRuyWRIH7QyB/o+Onj4OfUxmb4if7148uePJGp4MtkEpNfkQOm0Wm0HngzAYMWUk0sowXNMQRYzQiVG289ybQzIDDSH6J+wAFb2SvLOu1P7de9TDexS5WpSMBC123FZLbIWckmuygj5ZI0Kw6o3RNhuEsfDUrc33Am1VWZKQP/nbfogR0oHW6szeHKq7t3WskiBrsh+GmM5jpzrP7Hp6J4n8R3hHphDIjFWYIRG+PCD95THWUKANHJ/AtkvsMSBQK2106IFgX+ISPze3qCywyV/xdZdYUX3xjch6GZdM36QiXFTGJty7IjxErvJ9KgaRWilw4NQVKH0ka+LEogIKSB4uO/K7iGKPwD1lOrcpvkSWjlrcngiN6o8TYn4JTpY5Peb90TgB8LPxM7kshdT+hhh6vNuqie9xeasxSGv10XZ7ACTYh7ieVaVHgasiEzQif6Xe6jpxsNUGOFqPA7ZwGLmg059bEhCCU7tAKE/xVzuIdRgsDNRgfTX3OtBrwRTYCC+P061nWMkb5VPn47aNmz/PDoRsiZl+1SuB6qD1AuHZ6L9kLA/iy58D1UGoVOoTWCZxn+gnCbnamP0TQAl4mDOWxJO9tzDSAC/Oi48QBtQTb7N7CrOqOYOM2Snw8vnc0/gEhKtk0OLXnih/CVSCA+AazrGJQVEAJW24Xk4b8VNShxmkA3/JUcrWmAMQShLVYVNC04XKCNnXObkAj4FPXjHrlnROzD1eiYcKjiwLmkm8PmXGyikO5UrAQ+xNTaRkblMZW
 96Ul5DxO
 GYy/mLd3kldo53cXKZsdJ26bqvs+53GW886RRaW2B/57z4fpm9KN3VIh7/NOy8nyRwYNzp7wB/LC5hQiTUybFuwbi0VXMfkfjRMQROAWKmhSSRwyCeT5CC+Kkgizfthxgc8VbATUQbnjL6t5VNgvnd7L8QebtQmq2+qMjSQ6AJXTTLHQy0LCI5BKsYt4L0UOZblsP7VDO67Ym5KJunDL4mpCaQ5p/ewnG7FnaP9LeGGMGVkrlDmpYUo8pHuMWSXPyTf00RbUNVcAhzEbG8jvGLqmiH7DSyqUP+Qwqs38Qi2p8rCkusbpMgb/Z53xLVHCY1WbTUIyspcHhmpIx/1gCjJ1UTPvz/8/Gi7f6UfTo4PWi20oKm8YTHJ0zbGI3jxwAx+0LqY2jg8lm3J1/hOLmgQPUGwZJ/FJG8nFkpjEecC57q5Kb5x/FHmMRt7mIaBhsyG0XV9far6iWp6phFwmhUqgRR2Xiyrd7JTbVErf6IIMZgO7RoRJd52g4E7yc1yZPUz9+ZIQMJczzQvunIJbGspmXQPgRb1dsvaC322lP16UmhrydxQmgAbUgUWDxLC4prX1ZIQHd8o55/DQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_swapin_nozswap can hit OOM before reaching its assertions on some
setups. The test currently sets memory.max=8M and then allocates/reads
32M with memory.zswap.max=0, which may over-constrain reclaim and kill
the workload process.

Replace hardcoded sizes with PAGE_SIZE-based values:
  - control_allocation_size = PAGE_SIZE * 512
  - memory.max = control_allocation_size * 3 / 4
  - minimum expected swap = control_allocation_size / 4

This keeps the test pressure model intact (allocate/read beyond memory.max to
force swap-in/out) while making it more robust across different environments.

The test intent is unchanged: confirm that swapping occurs while zswap remains
unused when memory.zswap.max=0.

=== Error Logs ===

  # ./test_zswap
  TAP version 13
  1..7
  ok 1 test_zswap_usage
  not ok 2 test_swapin_nozswap
  ...

  # dmesg
  [271641.879153] test_zswap invoked oom-killer: gfp_mask=0xcc0(GFP_KERNEL), order=0, oom_score_adj=0
  [271641.879168] CPU: 1 UID: 0 PID: 177372 Comm: test_zswap Kdump: loaded Not tainted 6.12.0-211.el10.ppc64le #1 VOLUNTARY
  [271641.879171] Hardware name: IBM,9009-41A POWER9 (architected) 0x4e0202 0xf000005 of:IBM,FW940.02 (UL940_041) hv:phyp pSeries
  [271641.879173] Call Trace:
  [271641.879174] [c00000037540f730] [c00000000127ec44] dump_stack_lvl+0x88/0xc4 (unreliable)
  [271641.879184] [c00000037540f760] [c0000000005cc594] dump_header+0x5c/0x1e4
  [271641.879188] [c00000037540f7e0] [c0000000005cb464] oom_kill_process+0x324/0x3b0
  [271641.879192] [c00000037540f860] [c0000000005cbe48] out_of_memory+0x118/0x420
  [271641.879196] [c00000037540f8f0] [c00000000070d8ec] mem_cgroup_out_of_memory+0x18c/0x1b0
  [271641.879200] [c00000037540f990] [c000000000713888] try_charge_memcg+0x598/0x890
  [271641.879204] [c00000037540fa70] [c000000000713dbc] charge_memcg+0x5c/0x110
  [271641.879207] [c00000037540faa0] [c0000000007159f8] __mem_cgroup_charge+0x48/0x120
  [271641.879211] [c00000037540fae0] [c000000000641914] alloc_anon_folio+0x2b4/0x5a0
  [271641.879215] [c00000037540fb60] [c000000000641d58] do_anonymous_page+0x158/0x6b0
  [271641.879218] [c00000037540fbd0] [c000000000642f8c] __handle_mm_fault+0x4bc/0x910
  [271641.879221] [c00000037540fcf0] [c000000000643500] handle_mm_fault+0x120/0x3c0
  [271641.879224] [c00000037540fd40] [c00000000014bba0] ___do_page_fault+0x1c0/0x980
  [271641.879228] [c00000037540fdf0] [c00000000014c44c] hash__do_page_fault+0x2c/0xc0
  [271641.879232] [c00000037540fe20] [c0000000001565d8] do_hash_fault+0x128/0x1d0
  [271641.879236] [c00000037540fe50] [c000000000008be0] data_access_common_virt+0x210/0x220
  [271641.879548] Tasks state (memory values in pages):
  ...
  [271641.879550] [  pid  ]   uid  tgid total_vm      rss rss_anon rss_file rss_shmem pgtables_bytes swapents oom_score_adj name
  [271641.879555] [ 177372]     0 177372      571        0        0        0         0    51200       96             0 test_zswap
  [271641.879562] oom-kill:constraint=CONSTRAINT_MEMCG,nodemask=(null),cpuset=/,mems_allowed=0,oom_memcg=/no_zswap_test,task_memcg=/no_zswap_test,task=test_zswap,pid=177372,uid=0
  [271641.879578] Memory cgroup out of memory: Killed process 177372 (test_zswap) total-vm:36544kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB, UID:0 pgtables:50kB oom_score_adj:0

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Yosry Ahmed <yosry@kernel.org>
---

Notes:
    v4:
    	-  print the expected swap amount in KB but not MB.
    v3:
    	- Replace fixed 8M/32M sizing with PAGE_SIZE-based sizing in
    	  test_swapin_nozswap.
    	- Set memory.max to 3/4 of workload size to reduce OOM risk while still
    	  forcing reclaim/swap activity.
    	- Derive minimum swap expectation from workload size (1/4) instead of a
    	  fixed 8M threshold.
    v2:
    	- No change.

 tools/testing/selftests/cgroup/test_zswap.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 44fa81ef6157..ed257d464bd6 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -163,21 +163,25 @@ static int test_zswap_usage(const char *root)
 static int test_swapin_nozswap(const char *root)
 {
 	int ret = KSFT_FAIL;
-	char *test_group;
-	long swap_peak, zswpout;
+	char *test_group, mem_max_buf[32];
+	long swap_peak, zswpout, min_swap;
+	size_t allocation_size = sysconf(_SC_PAGESIZE) * 512;
+
+	min_swap = allocation_size / 4;
+	snprintf(mem_max_buf, sizeof(mem_max_buf), "%zu", allocation_size * 3/4);
 
 	test_group = cg_name(root, "no_zswap_test");
 	if (!test_group)
 		goto out;
 	if (cg_create(test_group))
 		goto out;
-	if (cg_write(test_group, "memory.max", "8M"))
+	if (cg_write(test_group, "memory.max", mem_max_buf))
 		goto out;
 	if (cg_write(test_group, "memory.zswap.max", "0"))
 		goto out;
 
 	/* Allocate and read more than memory.max to trigger swapin */
-	if (cg_run(test_group, allocate_and_read_bytes, (void *)MB(32)))
+	if (cg_run(test_group, allocate_and_read_bytes, (void *)allocation_size))
 		goto out;
 
 	/* Verify that pages are swapped out, but no zswap happened */
@@ -187,8 +191,9 @@ static int test_swapin_nozswap(const char *root)
 		goto out;
 	}
 
-	if (swap_peak < MB(24)) {
-		ksft_print_msg("at least 24MB of memory should be swapped out\n");
+	if (swap_peak < min_swap) {
+		ksft_print_msg("at least %ldKB of memory should be swapped out\n",
+				min_swap / 1024);
 		goto out;
 	}
 
-- 
2.53.0


