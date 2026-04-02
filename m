Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AC14CC6B03
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 06:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57D016B008C; Thu,  2 Apr 2026 02:37:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506EF6B0092; Thu,  2 Apr 2026 02:37:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6576B0093; Thu,  2 Apr 2026 02:37:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC3B6B008C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:37:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BA1E2C1B8C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:37:54 +0000 (UTC)
X-FDA: 84612660468.24.7510FF8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id D00A020007
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:37:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CB9gp1KI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775111872; a=rsa-sha256;
	cv=none;
	b=w11lkj5/Ig9PkUBstJ8PnPzbUm7QLfM5UT4WT+dX6CuLtVGIRkxRMmrkxkplDPsF6YJdvf
	NHsXovA9HVBrv4B/aPnT0GzrVaQTVBaJOnLcSG53LzNhAtIJG3+AQSNqxiFTgXfZjyp/F5
	l+KF5zRkXYIm49ntyxrqK3bl+J2v5zg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CB9gp1KI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775111872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oIeHjeE45sk83C/EEDWTFz2ktC6iYcZufl2nAkLE5aY=;
	b=uR5OXmbojUy4ARN76EdrMHJODpjrkUpwc7K5Orsaz9VqigvL3ltxQoPx3maDJoc1Hj7jCA
	aXh2NuzJxpHN7v+datp6gDJRnk3Cm3+c/3YG7PTDjnQmvKdJ8jWPhjPrZlgFU+TIiVwWfe
	MjpdKXOtl4YNTfmvr1aPed6UZeRD36Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775111872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oIeHjeE45sk83C/EEDWTFz2ktC6iYcZufl2nAkLE5aY=;
	b=CB9gp1KItbg6/nX9Pqq2uonipylhK5kT85RY9aHHri0LcSSBxx7dkacwDCikKdxWr9fJ74
	5hate7uNlhE3k3hlHYEvBoNVX2sqDsKGWg/nzdrmizhtf06Ce5atDDUISzzXDZ454Rz82d
	NelbNZXJEDjlf9vR4rIGxkdmwl4Yj7M=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-618-QHa-H3cXMe2HHTaWsDM1Qg-1; Thu,
 02 Apr 2026 02:37:49 -0400
X-MC-Unique: QHa-H3cXMe2HHTaWsDM1Qg-1
X-Mimecast-MFC-AGG-ID: QHa-H3cXMe2HHTaWsDM1Qg_1775111866
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFC8A195608E;
	Thu,  2 Apr 2026 06:37:45 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.158])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E65171800361;
	Thu,  2 Apr 2026 06:37:36 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	david@kernel.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	mhocko@suse.com,
	shuah@kernel.org,
	chengming.zhou@linux.dev,
	longman@redhat.com,
	nphamcs@gmail.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH v6 2/8] selftests/cgroup: avoid OOM in test_swapin_nozswap
Date: Thu,  2 Apr 2026 14:37:08 +0800
Message-ID: <20260402063714.55124-3-liwang@redhat.com>
In-Reply-To: <20260402063714.55124-1-liwang@redhat.com>
References: <20260402063714.55124-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 9fRTtR7YMPEclGzeGKInK_fBGal4t3aXdDTeGzut_rE_1775111866
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D00A020007
X-Stat-Signature: 8q497tqdsnm9xp3gdx7bxo95bhfsg8tm
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775111872-188549
X-HE-Meta: U2FsdGVkX19Q6Xsy1HkqKHd/VYjZOVFBp5LaxyS4LVKOXeZsnGD1IvcaeEHAZq1NQMtUjIGyk/3jBuBQyfeS/q9UUlUz7VUEnFB1v3unFC2gT5fOOasrRjFZjyGcd6CieNUpO9eceVhAntUdAoZY5d/N1vEnUKF/cCr4NtUn4RnEz2zD4T0QO6VAb9gT1bE6/CD55GmPO0zP+FKBQoVgk674SxOln5p2jJZEUTchu3r2QQiNlnv197RnXT1ZmGqRWJwr9wPce6Xm71vaZn3oCUfToIVMR0S16uo9b8hn6/cx3NFEiL8Rw9ecu0Pg9uVmuYwUv4qcgu2zFJQEYL693Y1+RBFzf+U/2BOLdKxUr6OH97ITZyaI3AtZ53JqEinLHiqu68jtava1X/uSyCCZh9XI75l8R4gEvkemGPOYAPkB40v9NHToGzF/DuoKFff2qt35XWKaQeCGvppuSOo98RdhEMqStZeqFI/UAds0Q/6HnMU5TCRatAZ9vrYoZnP4BRTCq6IYZ7DybH/vtiCIpndK/q4On8/cv0iXk1A9O5Q9FmOeyg9aGXHrLnaLnU3tjmSQvo/Op99YpGgghLGSWG2K/FGDo25Ax+Lx6+2q88T4li14g9B1w/EC9rnJWaha3VkHC1faE/EdgxZ6GTuEWF+eonbkOeT99YkvUW8PXPdC8HBDf+93LYIOrkdXioSPi0NdCksf9cyflWVicCTi7RbpdN5sUoTiM8Hn5ZSni74erwKhrUvasulOdsDhN/ViOWO4WmqocyJEAP9oUgIVjdGLbI4Q0yAFkZJ778+NNnbVcICgzXll9v/U006XB3RJ90bsptfQQXWx8mjo0gMGmF4XP9qThnKTcAE9jnBIB7NLE2AliOZKuWwW/PA2izb4YRwkhZrUbF9mUnvBl+0VJssldpzMmxvt3Ho+rt+as2PoPyLKGxowarVGIMOek2fhZJQzT6kUzdTLcSrE35+
 EDzvC1Ff
 MNOEUEYYshH6B6oggooDB+wERP55S3OB7hbXeSIXAnEV5qaqE4CHnB43Am3ZCaSbi8Byy9Gs9dJ6/7g2gQ/sw2wCwz+/R3b4yfOAuvv1Y0qGOKj7SDIxcN6kcsSlO3y66CKqk8SxBoqLfNbhLhN0o7QfgIO6KD3RpgcV7vLjtsgoMbf12iYL7BHy9rDbw7ITO/74OFn4TxkLaM9N3VGL1TADeUBv8JX/vbzJ9BJeRibG5vgU5if+l+8+8JUg/WklLO8RVZ3BtHv2/O7TEtx2A561i71yKdBPmG0/idQcWqqNVJKL8yOs8H9fxZAQVnR5vd9U3AHYqAzxNO7dgTSAzGSK5yTPKwoV7wEyyZEUIF6j/SsAjjT5ooy6dv9JFqQTUPquJUovK9OkEQcqs5ZXouU4rOlT4s4hzsACfELNEcIqwgR9/8WhflKFe5l08ZRPzH/YQH/vHavuT6sLdRendMPa5L73SXyZG8oKmWJqkFxqxFellEuxLKtIWaczaYPjRBOYJkr5hmiqbuT1mK+7BTr5gQKw3SDMcv2Qa7a7psXypGeSWhQ25x3lx5MI3tAlAh5avakRpSbFi0ew=
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
Acked-by: Nhat Pham <nphamcs@gmail.com>
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


