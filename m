Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FE6F106FD79
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 04:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73D056B0088; Fri, 13 Mar 2026 00:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FE616B0089; Fri, 13 Mar 2026 00:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6146F6B008A; Fri, 13 Mar 2026 00:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5E46B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:36:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CBA1416071F
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:36:00 +0000 (UTC)
X-FDA: 84539777280.14.7C5785B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id EB301180006
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 04:35:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fwyqxndp;
	spf=pass (imf24.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773376559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6v9/ZvpbDPgDOTKk0vhqPWuR3QN64DOkZY2ykz4H0l4=;
	b=PCS7ROD5D5D/jpJfcVRNf7WGVD7sSVltjzsqUOXnfmmfLk61dXMtkrjSdmd7Srr6BpD/K8
	ygPqN8o5ul86dQT9Ngky9OsSEW54t/E4HWCKVo2UYdUftheC3JJbZ144P4oPRnPY4cw0CB
	IcHxaAmJDe/jjlZ4W1xDA7i2hjKxMjY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773376559; a=rsa-sha256;
	cv=none;
	b=jEEECilwV6Cs4VIM4fjvxUOBkeH62ji3l/pU3z2FoR2RvXkZQMXtUAXjN/gfOICn9/oKc0
	hUwTuk0KDntb2RWvEDXbEiv1IcjORKZe+qIeSjQ4zlA/4NZBEV+2/OgWuAigCdQm1QtPpP
	8wvdYD/TYr4f1OWs3stahRmahA92XXg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fwyqxndp;
	spf=pass (imf24.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773376558;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6v9/ZvpbDPgDOTKk0vhqPWuR3QN64DOkZY2ykz4H0l4=;
	b=fwyqxndpoQTt3TVuolqqh2qMgf+aenipNEEsRSZfuhzXwTiGZoQaGKRyPRsn8nrqK/43w4
	8V1bdQ6q1lHLSwx21F9i8wLGFWrfper4L1U/aE9J7xNfwwiz9bSEgndpQLse4gVY0Qwqo1
	1XBSFlGQCN+Pm/TVnk7hzUsRSCsGZCY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-286-TiamJ6n8Mx6nhY_cwjWmIA-1; Fri,
 13 Mar 2026 00:35:52 -0400
X-MC-Unique: TiamJ6n8Mx6nhY_cwjWmIA-1
X-Mimecast-MFC-AGG-ID: TiamJ6n8Mx6nhY_cwjWmIA_1773376550
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CEEFE1953941;
	Fri, 13 Mar 2026 04:35:49 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB00C19540C2;
	Fri, 13 Mar 2026 04:35:43 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: yosryahmed@google.com,
	nphamcs@gmail.com
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v3 2/7] selftests/cgroup: avoid OOM in test_swapin_nozswap
Date: Fri, 13 Mar 2026 12:35:27 +0800
Message-ID: <20260313043532.103987-2-liwang@redhat.com>
In-Reply-To: <20260313043532.103987-1-liwang@redhat.com>
References: <20260313043532.103987-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: vNnTNFTKnZ3LuHeMLNGsB38gD5ilYckQdDFYfGxMbh8_1773376550
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EB301180006
X-Stat-Signature: itinrkgqkep6npc8n7fkhddo4yx3b51h
X-HE-Tag: 1773376558-429905
X-HE-Meta: U2FsdGVkX1+9NKEFo3n2OxlPOS8Y6u7C+IGAyxCoO3VMaFeMo4+c1XDRCWEBXJP128PX1VvK3bZcOniQzEU2jUDWAAJT+cjDobiIMsEypB3a5ThZKOmwTxEM5xCKXCkqH4j9gc3RtS/zpMjn13Yijt7Okm0G3yWs1Z/of6Ls6PCzjOYOpw86nPa92IEbu9pjiznedXYhXvCVJNmW0oEcRtfa8WSAM9RQb0nNF64Dd1IycNXIgUc6MFEWBmR+Q4k6l5FI6+PVZNt1TB6tez0Xa8bvFk/TTmff1QHwM2iyCCR/FOXETxyVJEj00LJC+pfbDXiibihgmshPPsV0bBc8NRLnq7mtxm+Fv+1B0fNoWrI2o1f1DG9AL0EZjJHv1mdOzovxYu4d14rJ9TYI70WRM6GpsV58TmPGN9zwpEBMrVdn8LCh4/dAzcmViPWjsbjI3P9/fkc/PdHw136wpNipgyxrp/7zHUwIxI/THIQdnAbWAtW+cRu/bDWMiqbLk1P86iaU3XM/8UpREUg/nye4DdsS4GPfTK1S77DdN6OW1sVsmYn07Lwdnw2Jo4LUIviyLARshIT8jkFN5SDfEpbGWRksiq+VtCT8eQYOjjW/qx7VzlQmEMDYC0TOQdZ0ylKJDoo194QHwk8XDdtWc0Wsboc0CTNHHknLV0Y2A7pt3Htw4RQeX7cP98iAZA1AEDiX9L+lJ1e9bVe8RgeJO4IK8rCxDtnxnk3rkMmI3RX4eA367l+3QXzeLHt3y5ZSeNcPsm7ixZNPhIHSd9osZn0KMwXkiFNFOeKCBH2iEdF4WcRcbppu9bMvFhlfAO0+5xmoORK1oYqdjXHmHLsHzgZmYpaJj1uUljCy2GxIyLKWThbwhUKmb7lE01zcz9KknnsvSicgImLdGLi+Z3VDN4QRGXbuyaX70vkOTQZ+AsM7QJUYPkCSI7ZInDnQgsUuJ+lgbQVy8gYoOcH4Zo7iooY
 QAMGtC+6
 72N2ih53iTy6+IrIYdUJ38bExd9NboCTM8OLkxaHtLC3Fnm0MSlTt8d3VzzYgNtYQrw3FV0qfl+aUFzUxwPSGssCd1rZkLugU8xA9daXgX2Zhsp+aHXpO/ognB3yCExhiQvHV6qF8cwNxUiMhPKphTwwJNf6StvHBZ4HFWXnwr7JFtitpZLLpKv/bQ+npCBM5TRCOAXloXEU6AZIaCRCtcyhEzUsZRM7v0YKIlgjz/G6ZKanpYhvKpwjAg5QWYbypn9XngPCBAygZO9dg1riAVTQLXEAhDtTR3kIfEaGX+ht0yEF/D8DmsfHNDqjdQYZm5iHJjgbIQUsakhLymPkECkpfx+AFPwWB9QuR09gE8OTEklWYOrXuyheTOh77bJpuTVAkkt15xxNq/8Vj42DYQDTBnVyiZ07Oq5YOGSF6wB/w+auv6Wky4vlVfwuRgFFfmqvE/k4YRuMkcYra6O828iL3jBG50wMOQZ4D4XZlbHj3XJfOla2gwu/n12u/qw8i7ZXne17MoR7RdNmJp8HkFlXAuTy3GpVhjeLo81tf0BySdpfmWNdyGvLc+x9HV8TTLgP+UflpymnI05o=
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
index e69d845d3592..04796b6641b8 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -160,21 +160,25 @@ static int test_zswap_usage(const char *root)
 static int test_swapin_nozswap(const char *root)
 {
 	int ret = KSFT_FAIL;
-	char *test_group;
-	long swap_peak, zswpout;
+	char *test_group, mem_max_buf[32];
+	long swap_peak, zswpout, min_swap;
+	size_t control_allocation_size = sysconf(_SC_PAGESIZE) * 512;
+
+	min_swap = control_allocation_size / 4;
+	snprintf(mem_max_buf, sizeof(mem_max_buf), "%zu", control_allocation_size * 3/4);
 
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
+	if (cg_run(test_group, allocate_and_read_bytes, (void *)control_allocation_size))
 		goto out;
 
 	/* Verify that pages are swapped out, but no zswap happened */
@@ -184,8 +188,9 @@ static int test_swapin_nozswap(const char *root)
 		goto out;
 	}
 
-	if (swap_peak < MB(24)) {
-		ksft_print_msg("at least 24MB of memory should be swapped out\n");
+	if (swap_peak < min_swap) {
+		ksft_print_msg("at least %ldMB of memory should be swapped out\n",
+				min_swap / MB(1));
 		goto out;
 	}
 
-- 
2.53.0


