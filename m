Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5075CFAD41C
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 04:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6B106B008C; Fri, 24 Apr 2026 00:01:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1BE26B0092; Fri, 24 Apr 2026 00:01:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 932A06B0093; Fri, 24 Apr 2026 00:01:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 82A316B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:01:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 16BA48A6E8
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:01:39 +0000 (UTC)
X-FDA: 84692100318.06.55FE1D1
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 451761C000E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:01:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q0CEzSKD;
	spf=pass (imf21.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777003297; a=rsa-sha256;
	cv=none;
	b=c6YEbR7L4JY4T8zmKs31ebx05VYB9rTsiToi48t08EYuK3se3+TPqIbo82FO0gm6IhIv3P
	NhLcuwi65oUvhsjoe2E3vWq8xVJr4dTOO9LY9xk5mDJYOo2SyRMWzBFRYTxrc/xyDI3NlX
	0SALDveqdnEUuJrE2MDp7GtdxXacf00=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q0CEzSKD;
	spf=pass (imf21.hostedemail.com: domain of li.wang@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=li.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777003297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zo6kGfk/xM7DSaD4ymtNFmjwZMlQQ2mCHqeTEgtluNI=;
	b=bynld/Eyjds+MAUJ2bKQn00Zn7absa3YeSXgb4b0Ed1Zau23MtsRbQExKVukEqUKKWRCy+
	+CxWjdFsY+FYaw1SWSvosCJmfGRut7ULZki5Is+w3WnWfU58LmyxzA9bu0j4zmalozu+gd
	Hivpwwv4iL3qLiLK7SedTpDDEl+dU2c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777003295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zo6kGfk/xM7DSaD4ymtNFmjwZMlQQ2mCHqeTEgtluNI=;
	b=q0CEzSKDXtzJ+NN/eB54JePXjXFiUxjo5CUbGCNwo7x2vx+fZA6OQor6AGPHWgmbp3WDpM
	bwZRvN7QGv/URDbOFDQAoJC3+Wcrx7bIkFp/Tcv3rNHqvwBK73BvhauXX8RMxCXnieELXz
	XsykdlZ2L6gcyo80CmMnESDt2xfM4E0=
From: Li Wang <li.wang@linux.dev>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	longman@redhat.com,
	roman.gushchin@linux.dev,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	jiayuan.chen@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	mkoutny@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH v7 2/8] selftests/cgroup: avoid OOM in test_swapin_nozswap
Date: Fri, 24 Apr 2026 12:00:53 +0800
Message-ID: <20260424040059.12940-3-li.wang@linux.dev>
In-Reply-To: <20260424040059.12940-1-li.wang@linux.dev>
References: <20260424040059.12940-1-li.wang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 451761C000E
X-Stat-Signature: yuo5jdzs37nn7afqgt8s4cfwe1zbhfou
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1777003297-899385
X-HE-Meta: U2FsdGVkX1/CLF6M1PRqiQjqCq8GrQfLLBV4QqJfp/qYwRm1cNOjY1HoEMrFgYJX3HqVSAd30kOQewKrRTFnW2uX3yGvMMZY+r4ydy9w6hFPgrs+6dDv3ij1fqIUTj4WBgGJW9Xw8mvCV8djRC2Xbe9rwfia/A6MCb0VkwC3fcc+xmA9xoE6VzZFN1BvGtvxdd7scfQxHwMHBIeOQC3jr2UHyX6STa5+I0FujFw5ZlSbLEBtAzZ63WYnVNB2C+81t+4j8SNAH6Ti95UpbANwugmQSqbvIFWDr0/BXF3j+W662HATBcmFNLW6hwwb6uifofZrLS82xnzMTQITUNUZOFFy+NSHvwNND7lFVWu3MnABNYIl8M2xuiUDq7VM6pCLK/U2jTOtbMKXBFU2vAg+r2swU3Y8IMoIOR0aPFjFHA0csMiLfPpYQgSnBF1lym+vds1Gb0ejt3hChFcdG5jTfVlMWUd+K8tn2povdS+fyCTK6p0SqH1Ae8B0ojIdCaCdXf5IdAGM55DabhITjCJtJny9hHS2FhVA+2Pp2jhofbz4YoxLzHyuXEceYDVw25q3ubuXPrtmv7UY4XIUT+fG0KsRlFUsHkpcLGoX3r9TLjDrHomqatv+YpZWH6ezkLXSYCUrgKt0/EupZUUqSe298NazX58uh6eU1Fzzfp+JlMwJWa0vc/0PUQCgUjEOHZLuWgdJ2zh2TwPR8rsyk5u64mGVQtO/uJaXSkv5ZitvTloo8ywa/sDhjtP4SahH7HOMTdLoPlqSotIvP3tp+fkFusAWpI5TLApOHdK6ZUo2N9t/1ENVTLay0xuoBomJu8RpzqYhZXIlKeTSYEP+LvwNHYuTg1P5Ro0SBzd5xtZyhrjxFT6cD+aYOVKySZP/vphj/yz2jDBTBvTTik/aSaZPUFIoIbn+P8Bi/rEQ+1CcIqRN9yjSMdX58zJ79vBWSa2NIMQEgQ9drYP6XZ8ppcI
 /XZz5SPB
 2zncVxBZOaWRSxn3qDk2SaF29LZL/ATpAVzje6VNs6RjmoC61pUqGvUmO93ccd3cxr64MY2m7kLHtCptHV3oXSVbGM0mSTVPD8Sdm8xfFKDnxK8/cXXG52OmagtNWP4w9mIfzdD8bbOE8dHCOi8wzCoSSqfH2SS7dehniX8gnkC7QSmV34MguE+F/K9luzOZBGZh/7IOpfw/WEVAGJIXp+5cHAGu5v6liMa+WnYmI5X4SmklPTmsQ3Apztnp4/tx+6pL6iVAYfqwuF39WFGeGIsJsSG3vJQ/a2lt6WIvOvdjxEsfFpdietW5EuB7hChOO9oCStsJ3NYMym51szDWI6umYHfUWcf7aWPFDJya3ACKe3boifzlemJSThpDOmxGH26ocv8Q0wp4NWSLQhdHn+37k9Ut24oJYjrPgxX7PvvaSH1xQlieIMFitCm7Nj5gEBGg9
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

Signed-off-by: Li Wang <li.wang@linux.dev>
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
 tools/testing/selftests/cgroup/test_zswap.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index a94238a2e04..47709cbdcdf 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -165,21 +165,25 @@ static int test_zswap_usage(const char *root)
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
@@ -189,8 +193,9 @@ static int test_swapin_nozswap(const char *root)
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


