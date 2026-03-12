Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 215CCFED2C7
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 04:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D2A86B0089; Thu, 12 Mar 2026 00:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 787A16B008A; Thu, 12 Mar 2026 00:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654FC6B008C; Thu, 12 Mar 2026 00:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5936B0089
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 00:06:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D8D441A0735
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:06:54 +0000 (UTC)
X-FDA: 84536075148.12.C56D130
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id E768114000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 04:06:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ggBunkA+;
	spf=pass (imf26.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773288413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UVbEvS28WBdLRu11pQ22oiG9bD4EcX0LwEYhFnvUKeY=;
	b=4iysWqcnxjl4rhBodOGYphzjMSNBw6iEqCGIgL6rhkwka/GqWjTQigYhX61UySZioSE/iB
	cdYiNeMfUP2otaddf7DrxTQ+w351JwkoAMDD9xwA/tDSkFWeVBr3kWZ5unk3HxZ9DdlF/2
	gsaiyKqT7qB8Ep7LvJgIimdwx36rJEE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ggBunkA+;
	spf=pass (imf26.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773288413; a=rsa-sha256;
	cv=none;
	b=rIcCBN/xLw/nKM0W5tfJHD6YIhEO/GxQ7TT9g72vQ8SG4wDC9PE5+OBn877xxtnM/uoHwz
	ufcu0IqkW7Y9nfWlnNn149lUK5zhijcMROIvEWVL0ZlHJFrZi+Ycjdaf4D0H6KCmDn9E8T
	KGd8Qg5rClm/Z39iiGQ40xlwgYTqMd0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773288412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UVbEvS28WBdLRu11pQ22oiG9bD4EcX0LwEYhFnvUKeY=;
	b=ggBunkA+gNj44yF6Vl3tcBskqOqVYMyBntYpicFLwuCPskEUzUxJtADKE+lc0nfWvUry5G
	STb+9ULBaZOp7xr4n9V6VC6iNSM3Ret4LMHlyABHWQTd+wVa1NDKdRh6ZhkGb23UCmjWB+
	nU5sMbYNNtc2SmIRoPRpdd7FbxxrXjs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-488-SpvZEC8WMB2tQb0YN_hbBQ-1; Thu,
 12 Mar 2026 00:06:48 -0400
X-MC-Unique: SpvZEC8WMB2tQb0YN_hbBQ-1
X-Mimecast-MFC-AGG-ID: SpvZEC8WMB2tQb0YN_hbBQ_1773288404
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 089B41956052;
	Thu, 12 Mar 2026 04:06:44 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.57])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6B89F19560A6;
	Thu, 12 Mar 2026 04:06:38 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: mkoutny@suse.com,
	yosryahmed@google.com
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH v2 2/7] selftests/cgroup: avoid OOM in test_swapin_nozswap
Date: Thu, 12 Mar 2026 12:06:22 +0800
Message-ID: <20260312040627.55257-2-liwang@redhat.com>
In-Reply-To: <20260312040627.55257-1-liwang@redhat.com>
References: <20260312040627.55257-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: XsW3p_cwox8P4qkLeHAIVnaMBUc9yyLDtCPNBzpGVHs_1773288404
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E768114000E
X-Stat-Signature: 8r44mca58eecbj89zx81dbn3j9oxc9y7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773288412-932038
X-HE-Meta: U2FsdGVkX1+GQ5EIsbA/Llv2U/s77zRiJ41QzGUvKnwraPmNM7gYB7cSgstzApOTeVZbWD+9ZWdA0ZCbnsku8O9dOF/EEZTh//c8gqT6Yn/Zll6zz30Eo+DtpIUO3XmeunVMca5QawKvkVY9rBVCJ8qgxMesYnWj6U0j4FfL7kyRXNeBW2mjBjtzV5g2N5LKqv6Rnt7EKqcrubrinNvdIPlMs5/enzpCNIR353rkXGMpszCnB2qIFZhssZHLvk/HXU3uVC0tFGgDlmw6uABrOmRafA24vI/kOaI/cw9TQDDDehVWXRzWBheORW/DiwumiaJcXXPN0gPm7pBYaLLUzBvDM+7oUq5TbCHUxZSnzg8xFjN5H+5FuLBGPWpqJ8zoHcVCnvtp4clLk3iZRhs4ZbhliOcnoUabqRxBcp4Ogbu2koe+PEIk5isViiUVWV2sUJb1t8lRltkBNp3OXc3/IXPfpgskVUBylP05R1/5S9XF1ax6DO2lrSuzNK26Mq9R4g6sNUUMYKGuQ/VwxDDUSrioMQ1Y7dJi3Nsr8RIQiBIbZG5No3oXON1rkmzLvqGZ7xjp+2X32nC+6kk2vU20Oyl0wSEx1Rg82vzmLYRsHVgtqdlXiK+TcuE2JARosFfRWCpRWykJ2H3fZUdu/GpdPx27D4MDQZkhEV7ErMCkes/yFacDuO0Qbm6yZgmA4tBgmqB0mzhosuNV8WjZZ6BzpDjsfJswiHU775U25HnGxCEEZwVW52229veUuJLJ7vkSG9D/0KAmXCnl/b8RIdCqfas7GDmhgeQZV6YNm+Ef+km66K+2KWIybTcC/AzQL8ERak8p6GMVOkVPys2+hWJzYem+xdEvJOYkzJnpt5Mw3isb6mF1XmzYyi/la42vYjJY9ttytGtMEpRmeiSF1cW4MphMDxmwhjqvXuItfCKrhXNEMn8x66DD4Hs9O3I0EDab9NXk6JhinGcoYJy4KB7
 Va1Zcbck
 bqOJez5///SWiR/YN8TATmAlaCdw7iWsEndPSV8z9BHcdwf6hRycYMGbkSAk1/TEp/FyiP+jbmxEUaiepFUHyDMpr5caLAoQMnWANlDykvlQDeflXkSF5FVUVfgoJWeOG1BzVLxmGcoZ/770BV6ZbYwMc8vh2J4AjQ3LMnaRoqcjV2lroGnMgFDBOWM6YrfnV94hDDdZnUjyyyW4c21fWaKgDXM9uNv42gzWiapvk8C9yv9DnBfqmy+X5xJrE1Etp820V/PV5fgFtvYmTiHpWcot2S6ZZm2+jikOk+DI4x8gpyNipTlq/haCMQcIRagnkgixRNareGfXG3nKu39Z9ZvKiBCR3P1x+fsmctFlTo+d39FrhpxgO7elgxBHWT9Nx/WHxDTq+2q2BnZ8bARQLl5ZRqdAowmRkYIjWA4/av3/bFgUD4TKFO+9s6WAZcgo1yy8jgEho4k79oADNtbmH50Hna4idbjlylJ2AQD1+BelFqtWMwlXpy/go0enbZTXkHfhLyjaWTCs2uqSuwrSyof900Sxvl9P/hlNXzbBc8Ueem3ZGD2umTMKb7vhRDHSgEg20a+SgmLGKXkcadLdwZZfR3k2HDcCeqQLs
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

Raise memory.max to 24M so the workload can make forward progress, and
lower the swap_peak expectation from 24M to 8M to keep the check robust
across environments.

The test intent is unchanged: verify that swapping happens while zswap
remains unused when memory.zswap.max=0.

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
Cc: Yosry Ahmed <yosryahmed@google.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index ec64daaa2f5a..8bf5fc34bb23 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -168,7 +168,7 @@ static int test_swapin_nozswap(const char *root)
 		goto out;
 	if (cg_create(test_group))
 		goto out;
-	if (cg_write(test_group, "memory.max", "8M"))
+	if (cg_write(test_group, "memory.max", "24M"))
 		goto out;
 	if (cg_write(test_group, "memory.zswap.max", "0"))
 		goto out;
@@ -184,8 +184,8 @@ static int test_swapin_nozswap(const char *root)
 		goto out;
 	}
 
-	if (swap_peak < MB(24)) {
-		ksft_print_msg("at least 24MB of memory should be swapped out\n");
+	if (swap_peak < MB(8)) {
+		ksft_print_msg("at least 8MB of memory should be swapped out\n");
 		goto out;
 	}
 
-- 
2.53.0


