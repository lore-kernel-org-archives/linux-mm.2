Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6888FC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 07:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62EEE6B00AF; Fri, 31 Jul 2026 03:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DF176B00B1; Fri, 31 Jul 2026 03:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE486B00B2; Fri, 31 Jul 2026 03:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2457A6B00AF
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 03:19:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3DE114034C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:19:16 +0000 (UTC)
X-FDA: 85048220712.24.BA518AE
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id DE829C000A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:19:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gSEoAE5K;
	spf=pass (imf10.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785482354;
	b=HkIlypL6SN3ErFtk6b5D0DN5tspS9tSh5ycsUuVZ6Wc9t/7Qzsg8bhbhnvy2Fmw72St9Wd
	tcDSRyZMnAsdwsGRGrWrS2X4wZ3PaIIsuFib3jsI+yEJ52uP3sfYVqE/oFHjw7r04sTFQC
	m950uqFlspsMKwwHv6W/P00pNjs+HI0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gSEoAE5K;
	spf=pass (imf10.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785482354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XTbbTCD4egv0utHJvm00B5iv3aXVh0vE7Y+3UdThKEs=;
	b=Xpgmg/Xw4fKVCvGlA2AI5xWIQDNTUOcogKawNlL8SxI+fo2C/XC7L9hdPmoX9Pf9/pVUEj
	d4TVjZ52vRf0OQ8Zjp1LMf7f0pNk8/A97awZXNB5ALMoc/nW1NobNP41tH6+GTeN1mCJlW
	rLUyDhqzYalcFq9ZrFunR+MmlKkrG1g=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38e347638adso897109a91.0
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 00:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785482354; x=1786087154; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XTbbTCD4egv0utHJvm00B5iv3aXVh0vE7Y+3UdThKEs=;
        b=gSEoAE5KFwMjHDS0WD1G3EsPZAcLVXEFsX0+ERMUL96VijUE0LCjBsKOZ7w5W9lUM1
         GC6AM6qwi0r+j0P75caeWUasroqmhxAyKZ7z6y5ABQvhsB6D3aF88PjjLFSK/KVZ9mF1
         5MVwQ6ERZHVpEg0mkHaXagiOda4iFCw++qIdwcL2COssQhdW39OSsmxkZM2/n/6UQJVK
         nAi3128atOz/qwNG/SaMVuV/vZfJNxY2UE+nU5BhNVY9OTsKUgdi1T+VDYd05S3KSa2k
         PEXjp1NN8NLzBcLo4HFf3tOq3ujO0rGrpeHQAt1I07E9FqtHxD/xZ9qwcpPEAFj0lUew
         g9lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785482354; x=1786087154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XTbbTCD4egv0utHJvm00B5iv3aXVh0vE7Y+3UdThKEs=;
        b=pLEGaTMcPlvfH6Ixdz3eSkRNftYSwZhWBJSDqGWIcCgh02w6bttLisXK80/x2vMnIi
         02oEWQUpQ6y/VE52YdCHhi0z0fMJ4fnPQjmavKgPbc58WzJ8VhfpNJjSgdQ7l81gGRHW
         HTHSrSwgHk1YU3jKfALm7LsBvlLzj1r+dzUgFVqHuvXRu4lKb9TBxaBLYCFa1IY0Y04J
         YYdwRclTBotCClkeo9n6aNWqXGhINDKxd6sOJnRZX/Y5ZrU7yFmNmgJFL2FSA/46u/1i
         PfOPbu8F4X5vHlXw6ak//D/vKsoTowNFZFdoClXVYQkYMWISEszvcbq26Rh8QgoZGTVa
         MCdg==
X-Forwarded-Encrypted: i=1; AHgh+Rpmyglbj2qH9rX6lrwgXPnMFWcSkUhW3aPFCtY4+RUW4FBDdeQG47IWWVouNtVMjwg5cxSK4rl19Q==@kvack.org
X-Gm-Message-State: AOJu0Yz5oNve2LDU7rEx7/fPibXxIa4ZNVee8dWTOovHCj0qqyIkzT/P
	DxmXew8t/6kxlggdBYCkxz/6DSP6kby6daLnIUdJemTZrORqLOWLaG/E
X-Gm-Gg: AR+sD13QkZyyL4DBqQT1l6kXrOtBENJdLVYN6tEb5qH5n9pC9i2G6jkjsZUgpE04bZh
	Cl0cpuMoWVJVogz6qA6tmrlapL4ml/YG6THj0cVqjeZeFFYXoDwAjdeF9Ss3Qxu8DXGmmv41VrI
	bT8WGJkeXJSLD45vez9fzLyg7eSQ1LoUIkY/dOzwOTXE8PE8IZ+OXRwQHacV2e78XRZ802Lgp0Z
	aGEhKGVJkRlMj7kP/O0/c9ZUJDbZDxc7yfx1B1GMXgNeQKz6wj3KZOieHLDnuDAoeKsjcx9bAg9
	yNKmdiVyFgs6YrzFE7n5u5np7/AJkXx37DZklBUFs4rr1lI//nkXC/7/u8lFmrl1iNzNL+p/Zhu
	WG5H0rHzOLGSz7QWK+Kem032KiqrnZCRaHrMC/qBoiC75rtitvfxv2m3Mk9qV2pXdCn0lOHeCvQ
	0SzyiJD7brT+EnERTIAoGbQVynJsnZV+/8IcSua75HLaj4egoEqycq8mIft1TbA6DvY6PBithxN
	tvDjvn3y5o6NvvQ
X-Received: by 2002:a17:90b:1c81:b0:38e:2517:5d1f with SMTP id 98e67ed59e1d1-38fb114f74bmr924299a91.9.1785482353580;
        Fri, 31 Jul 2026 00:19:13 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38fb311994esm298909a91.17.2026.07.31.00.19.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 31 Jul 2026 00:19:13 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: hannes@cmpxchg.org
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	jiahao.kernel@gmail.com,
	jiahao1@lixiang.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@kernel.org,
	mkoutny@suse.com,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	stable@vger.kernel.org,
	tj@kernel.org,
	yosry@kernel.org
Subject: [PATCH v3 2/2] mm/zswap: Support batch writeback in shrink_memcg()
Date: Fri, 31 Jul 2026 15:19:00 +0800
Message-Id: <20260731071900.38942-1-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <amufiuAaZbuDdKkQ@cmpxchg.org>
References: <amufiuAaZbuDdKkQ@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DE829C000A
X-Stat-Signature: 5s8xp8fqcr6pobhojm3njqwbq3fuprgj
X-Rspam-User: 
X-HE-Tag: 1785482354-420353
X-HE-Meta: U2FsdGVkX18MMsRDqMkGhc+ChkyBHKEzq7/t1FeUlcrCuBdhSV/pgz+GCb5K2/dbR/ookW5b7G1rPcEVEPv2GamIh5MjM4oOUv8/LiqialFDU4ZhxLp3cqqvpHqM73OtrBtWZKEts2Zd7k7/Cyn3jOg4OZh+42k4HXM5LYDTuBpw4MsCJsED4gBZd2qiofZtDYPfnVmvUy+fTuNvKNV7BjzGa4aGohbsXzE6Qzn9AJ3Pf04U0exdXPjpehwxG4y6Og+Wm8LtwkjArDwna/6rM/3pwfTDIdOPKFt73zKdk7kKKibVhy9yx3sNjB6TLFjsT98/lm8YiPydyC8j+x45ond4P7UQ57lCocO8qMgARac9hIHAjOWZCMEXc2bnUgEAQ4zby6JNa+vSR6WSipaR72+CqTgo1/RXFDL6ihfPmQLARFJIGs4m4Qu0NcoHrWCfm34p3pvJ3H7AhpY2eDuXEKCc+4S5N7eq+/c+QdDO7H6OhTB0GDV/JjyMGNLv1mSIcun9o5jjl6FETp7S9EtG01BDRtM5+aeFDHQMUiaTYgXXY2Pu1pcDI9hZeR5b0Y4lhxou4ffrHj5Msecv+cr3dTgNFPL2s6SXBsjoESvUrfb7cGOnG2a8xd3yI4CEleVAUY9Zgp8u9weVvp7PiQp26BR2qqklyvwGQHj0EBfb+G3GUVE/HwG2Y3OMA8YWuF5J7Y7txY8Q07F21dVu6gtbJHLB54uLmNAxNTHOaq5V9spfo67G6A6GASQPvFkOmLwbFUC/YbFcC2J8NPmno6ixEQ7f/+yQ8BLtiQgFCnwMuZbWhn8s5w7VJTkT+Ux6DSmIcl9qMfOMDK5RhUj367ffI7lF7S7ds2Jx4l9PwDziKDkrTW8vsE41KBSoKv+xd7JaZHnfBS3e1RkBmlpn7x+8imr+4+qhnQqFXGpHA5aE+Pu4H++IrskumPAkqv0OALBHlc+vMZ0rdKtB+BdOeDP
 jLASHv4l
 DLmcJZD2+QsLCyf+5tkBtpNjMJK1VFeOl5PcJr826PWfzAvEzmTVIiO5R4dvsHHZxJ1Fx62lstbeGg3eKjF0IR1YdVwt9ZSsTOKki2J4XpThhim6jV48sZzvav69IUMqZR7ZjbDSIyonkogtJ6Aw2tO9QHBWmMYivd0xKIpJR3DvQLaLO8ydzJcGlkjy3hcVKNx5GOzUfnhAl8yBQP6sxkM31nzstXtKeSB/LQVOHmH6B00J6bEvaNlzV0oUh/R4sDjAkULoLX2p/bqTImiqOYhLBuGyHJ02H9AguKkZCe+H1marsmYu1AwPLQLlvEwIxDQGu0eRg0eMvfNUOomeYjH9te1D9HoTTAsvj3DjpmR/UIRm373JL2w1iWpDNNiheXwiCQ/ftydKYN1SkWNSueQ65uw0395RyJxoBW+Zm/wVM7v+8XCAIv76cdP1NaBlBd7jnIznWnsaS7jSXBhCTDoaaBoCEPZhEjcl6NyZ8vSYSMYLzWayJAo3uKdvJIGU0uB+L+Fj+SQyLxijbOSljt7RxvJOBY2CaJhHe4EggaeAZ2941ntOoG9lagsanTzhXdBBpZU/A5XC7Qk0WGMpLbGZ/gAmc9IciBwFsQwGLSwbNB98BrND8wMULuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

Currently, shrink_memcg() writes back at most one entry per-node during
its traversal. This makes shrink_worker() inefficient, as it must
repeatedly re-enter shrink_memcg() to make any substantial progress.
Under high memory pressure, this can cause the writeback speed to be
too slow to keep up with refaults, leading to zswap store failures and
forcing pages to skip zswap and go directly to disk, which results in
an LRU inversion.

To address this, extend shrink_memcg() and rewrite its LRU iteration logic,
enabling batch writeback for both the shrink_worker() and zswap_store() paths.
To prevent shrink unfairness across NUMA nodes caused by a shared global scan
quota, limit scanning to up to SWAP_CLUSTER_MAX pages per node and write back
any reclaimable entries found.

Test Setup:
- Total memory: 32 GB, 1 NUMA node.
- zswap settings: accept_threshold_percent=50, shrinker_enabled=N.

Test Case 1:
Set max_pool_percent=1, allocate 512MB of anonymous pages, and fill them
with random data (to avoid compression). Then, use cgroup memory.reclaim
to force a large amount of anonymous pages into zswap. At an interval of
2ms, allocate a 4K anonymous page where the first 4 bytes are random numbers
and the rest are zeros, and then trigger reclamation of this 4K page through
cgroup memory.reclaim. When the pool threshold is reached, shrink_memcg()
will be triggered.
The test data after running for 120s is as follows:
                                Baseline      Patched
shrink_worker wakeups              5,363          169
shrink_memcg calls            11,373,201      350,703
written_back pages                40,212       40,241
zswap_store calls                161,190      163,753
   store succeeded (ret=1)       102,743      117,183
   store rejected (ret=0)         58,447       46,570
   store reject rate                ~36%        ~28%
pool_limit_hit delta              55,826       33,760
pswpout                           98,659       86,811
pswpin                                 2            0

Test Case 2:
We evaluated the following two sub-configurations using stress-ng inside
a cgroup capped at memory.max=1G for 120 seconds:
  Test Case 2a (max_pool_percent=1): Continuously triggers the global
  zswap pool limit, thereby waking up shrink_worker() to perform asynchronous
  shrinking.
  Test Case 2b (zswap.max=320M, max_pool_percent=50): Continuously triggers
  the cgroup's zswap.max limit, thereby invoking synchronous shrinking.
Command executed for both setups:
   bash -c 'echo $$ > /sys/fs/cgroup/zswaptest/cgroup.procs ; \
   exec stress-ng --vm 4 --vm-bytes 4G --vm-keep --vm-method rand-set -t \
120s -q'

Test Case 2a (max_pool_percent=1):
                                Baseline       Patched
shrink_worker wakeups              5,640         1,308
shrink_memcg calls             8,481,500     3,140,972
written_back pages                   260       468,216
zswap_store calls              2,742,756     2,011,269
   store succeeded (ret=1)       934,640       947,988
   store rejected (ret=0)      1,808,116     1,063,281
   store reject rate                ~66%          ~52%
pool_limit_hit delta           1,181,310       196,882
pswpout                        1,808,376     1,531,497
pswpin                         4,288,497     3,635,365
Test Case 2b (zswap.max=320M, max_pool_percent=50):
                                Baseline       Patched
shrink_worker wakeups                 0              0
shrink_memcg calls              687,608         54,002
written_back pages              639,176        846,663
zswap_store calls             1,224,222      1,228,548
   store succeeded (ret=1)      992,816      1,208,123
   store rejected (ret=0)       231,431         20,425
   store reject rate               ~19%            ~2%
pool_limit_hit delta                  0              0
pswpout                         870,745        867,360
pswpin                        1,707,823      1,216,814

Under identical workloads and runtimes, batched zswap shrinking
exhibits a significant reduction in both shrink_worker() wakeups
and shrink_memcg() calls. Furthermore, the sharp drop in both pswpin
and zswap_store() rejections demonstrates that batching zswap shrink
operations effectively mitigates zswap_store() failures caused by
hitting the pool limit. This significantly prevents pages from bypassing
zswap and falling back directly to disk, thereby reducing LRU inversion.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 mm/zswap.c | 30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 48fc7b575e24..d406c14925d8 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1275,6 +1275,21 @@ static struct shrinker *zswap_alloc_shrinker(void)
 	return shrinker;
 }
 
+/*
+ * Scan up to SWAP_CLUSTER_MAX pages on each per-node zswap LRU of @memcg
+ * and write back the reclaimable ones.
+ *
+ * Since the second-chance algorithm rotates referenced entries to the
+ * LRU tail, the per-node scan is capped at the current LRU length so
+ * each entry is scanned at most once per call. It is up to the caller
+ * to handle retries, deciding whether to scan another memcg to complete
+ * the full iteration, or to rescan the current memcg to drain its zswap
+ * entries.
+ *
+ * Return: 0 if at least one entry was written back, -EAGAIN if entries
+ * were scanned but none could be written back, or -ENOENT if @memcg has
+ * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
+ */
 static int shrink_memcg(struct mem_cgroup *memcg)
 {
 	int nid, shrunk = 0, scanned = 0;
@@ -1290,13 +1305,24 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 		return -ENOENT;
 
 	for_each_node_state(nid, N_NORMAL_MEMORY) {
-		unsigned long nr_to_walk = 1;
+		unsigned long nr_to_walk, node_budget;
+
+		/*
+		 * Cap the scan at the per-node LRU length so each entry is
+		 * scanned at most once per call.
+		 */
+		node_budget = min(SWAP_CLUSTER_MAX,
+			     list_lru_count_one(&zswap_list_lru, nid, memcg));
+		if (!node_budget)
+			continue;
 
+		nr_to_walk = node_budget;
 		shrunk += list_lru_walk_one(&zswap_list_lru, nid, memcg,
 					    &shrink_memcg_cb, NULL, &nr_to_walk);
-		scanned += 1 - nr_to_walk;
+		scanned += node_budget - nr_to_walk;
 	}
 
+	/* Nothing was scanned: every LRU under @memcg was empty. */
 	if (!scanned)
 		return -ENOENT;
 
-- 
2.34.1


