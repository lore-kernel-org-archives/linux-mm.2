Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0170CA6002
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 15:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A612B6B0099; Wed,  7 Oct 2026 11:37:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A119D6B009B; Wed,  7 Oct 2026 11:37:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 953226B009D; Wed,  7 Oct 2026 11:37:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7099F6B0099
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 11:37:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0BCF61C2700
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 15:37:38 +0000 (UTC)
X-FDA: 85296234996.06.D2189C4
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1C848180003
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 15:37:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791387456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rz0pcjCp1DDTsCLIjgkxlDnCP787q8xCdUQ4S5IgNbs=;
	b=LH75Ua3kIjVah4fgI1KQJ87I0m20n8FhXn7tIwhSol+he3uFRCoM4dXwB27esZg6+HW9YK
	VhJsuV74wYvgjn099lnuLe2uMb4jui8uD5+r22JLjyNuZuSmsE+CvV51GEWU+ri/J0M70E
	cqyNN1tEaWnQhqOncxbsCdgoX1DH42M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791387456;
	b=dQjBjp3szO2ygxS6HmfJDmkQfU5Sk2Qu4Fk7OE9qhasg4ob3wT987o0Qn1Lf8mee4SPCah
	z/jN2hz2U6L2PiAdK54NdNAIaRgcFgKAzbnvFmm54AdUbUfaFZBI2pXHtQ0ifMCSK1jyxD
	JsI9H0EBSbpQ4t+invzDLq6BaaSS0Ig=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 1A4DB20CF1;
	Wed,  7 Oct 2026 15:37:29 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH 2/2] mm/zswap: plug the writeback IO of an LRU walk
Date: Wed,  7 Oct 2026 17:34:44 +0200
Message-ID: <20261007153507.50715-3-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261007153507.50715-1-alex@ghiti.fr>
References: <20261007153507.50715-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTFMmDhzRI1VF4VJEv1Glxi0/xCf5/UsaPxWiZO6CFitpeL7iII4ozF9mAko/Y4N96ToP1F+wO9d8Cyt3n3dCOkrHN5hKkSWqaXARpt/7JbAg3TpjzCUl4KqGKKBz3AR7HIKyFjdQExErAoROeYZPqoxG1hEcCJfeu4H30zWPy7XFcsGnqc1OviNnc7t7euAQXNG1ugsMfrmgxN7Mj3vrEto5zHPM7+7sYmBN/JegeTAvN4WAi4RcHGVN7oWMt7WFFDKBlNE6uQOLfQURLf3Il6Khr5Lc5CbsnRODEDRmt1CxIN5yefsqczuun4pWuL/6FgGBOZT1eF/1ulnRaqq9f5tteWn8tLrK6aFppDTnm/3OM7T7Q51K4fqCO9z0lbowPAv3yeQaTo8V5iR4q99W3TkkXk1uJM9XE+YWD9IUg2GKfDehpPVIxQ4/cMb8JBOESskrvnLGHnIxpZGZ2EaLbhcaY0aIV0gOATHZPaDZ578vjZoOBI/E23sKBxfLuES6IAsH5/QVf5+aBdXHhIWoUh7glDv1F87yhqJ3bPQjNM5zgBUf9hhh0vDUbFW5b13dRVc36L5TqokxVwMj72wz1L9PzDGYRGh0QM2XbvCrkQDhOEzvIgMulalJwM44zmZBfsbqGwDiE4ncteoVzNakB6UK0vlYN89gGsz1cIZsd7mFA
X-GND-State: clean
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1C848180003
X-Stat-Signature: cigckeui36m4ebt3acybhki5azi5f691
X-HE-Tag: 1791387455-236132
X-HE-Meta: U2FsdGVkX19DLPzqH2qP5mAgvLfPmSobPQWfmo/l13fO87DsE1lqWjmcn3bGkHb3mO1OuEhyjG1D0nKEk5VyGaoAAP9DAXgi1A+w1BJAP0svY79vA2fDgn+1ob6f46DUfSDXHnkl9JCkkLgpNSv6j6CJOAU6oQIf9R1SWW0f4cR+BjOIEo/iCTRZARExhCEOuagRvCEYGAXIGSiqHG4CqyYTl+K7rXwInzYoE6Ff5Qj75yCOjTflo9FtPqJ/1F+a10eBgaHIAz5dUkPGzAa3uXp4bqEXwJdE5rEG30pbgzeHJ47eQ/V96TKcXHDi8H05HzqCTKZZbr51lolxEfvTZe2PLQ2852HHgbHHXW7l10PuVqSLgy6PMkeLNZjoGN3R4wz/dgySARbc+9nTvUSm5q4x+ewSyfB0/nQ88hYPNiqQwmwEgOL2VWws3WvlK3PXDH0soYzHk7UGwDcVGZrAqQAYZNK7k4PsjiEm7lg6rBR2ZiRxXG0Bzzw/KXBy7IKEKwPoqpEYSSXhhy8ZKmf1mlEfqsNuPbXPs2Qbds3XDzzggR/WTFn9mHhPxpLSWsF0n+Eec/HeYJNUK782nL1j7mStkskhfCNSt/F8epur6S9TMe45oE/ZxH8QBiX1iKJ2ClaLKgjfer9IeK416VBlJxaUhOb4X4sNfM5Po/PPZX534lUWm6PLcYQFxu7CqVehpibDTFEPft84sQaswREQnOOJRIHeV61KdKXWew8d0PDGl/P5869pGkpy6LMQjX7V9aMk1N93gXdjsQcSIZr1ZnbJczT8YdwM3jMIUfPSRmUZZUz0W+9Xo5vcnb7rI/aHdnn/No2eguGhfyD/OjDiSnVytnZNWnHDCa1uHNmLTV3biBkeDypWdYk+4XcZh8IEpxmaeUG66tROM/zEEhMPA8Mh92L4j4ZGmsprAHX1kDSK2cuF7MpCs2THiVQpRHkGgnabtO7OYkVg9jrJBip
 pbg7HeMm
 ng35S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap writeback only appends an entry to the pending bio when its slot
directly follows the previous one, and submits the pending bio
otherwise.

Plug the LRU walk so that the block layer can merge what the batch
cannot.

Kernel build (defconfig, -j4) in a 600M memory.max cgroup with the zswap
shrinker enabled, swapping to an NVMe partition with iocost enabled. It
runs alone, and next to a sibling fio random writer with 10 times its
io.weight so that iocost throttles it. Mean +- stddev, counters from the
build's cgroup:

Alone:

                                unplugged       plugged
  build time (s)                1061 +- 2     1057 +- 2   -0.4%
  write requests (k)            622 +- 34     579 +- 21   -6.8%
  pages per write request    1.30 +- 0.02  1.36 +- 0.05   +4.9%
  iocost debt (s)             14.0 +- 2.5   11.0 +- 1.7   -21.6%
  iocost wait (s)              7.7 +- 1.8    7.1 +- 1.1   -7.9%
  IO full pressure (s)        18.3 +- 1.4   17.5 +- 1.3   -4.5%

Next to the writer:

                                unplugged       plugged
  build time (s)               2188 +- 45    2104 +- 75   -3.8%
  write requests (k)            594 +- 21     567 +- 24   -4.6%
  pages per write request    1.30 +- 0.01  1.35 +- 0.02   +3.6%
  iocost debt (s)               648 +- 22     645 +- 29   -0.5%
  iocost wait (s)               624 +- 23     633 +- 29   +1.5%
  IO full pressure (s)          615 +- 31     550 +- 44   -10.6%

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/zswap.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index 698fb74c5d47..39c4d891cc86 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -20,6 +20,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/atomic.h>
+#include <linux/blkdev.h>
 #include <linux/swap_ops.h>
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
@@ -1225,6 +1226,7 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 		.encountered_page_in_swapcache = &encountered_page_in_swapcache,
 	};
 	unsigned long shrink_ret;
+	struct blk_plug plug;
 
 	if (!zswap_shrinker_enabled ||
 			!mem_cgroup_zswap_writeback_enabled(sc->memcg)) {
@@ -1232,10 +1234,12 @@ static unsigned long zswap_shrinker_scan(struct shrinker *shrinker,
 		return SHRINK_STOP;
 	}
 
+	blk_start_plug(&plug);
 	shrink_ret = list_lru_shrink_walk(&zswap_list_lru, sc, &shrink_memcg_cb,
 		&ctl);
 
 	swap_write_submit(&ctl.io_ctx);
+	blk_finish_plug(&plug);
 
 	if (encountered_page_in_swapcache)
 		return SHRINK_STOP;
@@ -1343,6 +1347,7 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 {
 	struct zswap_shrink_ctl ctl = {};
 	int nid, shrunk = 0, scanned = 0;
+	struct blk_plug plug;
 
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
 		return -ENOENT;
@@ -1354,6 +1359,7 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 	if (memcg && !mem_cgroup_online(memcg))
 		return -ENOENT;
 
+	blk_start_plug(&plug);
 	for_each_node_state(nid, N_NORMAL_MEMORY) {
 		unsigned long nr_to_walk = SWAP_CLUSTER_MAX;
 
@@ -1363,6 +1369,7 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 	}
 
 	swap_write_submit(&ctl.io_ctx);
+	blk_finish_plug(&plug);
 
 	/* Nothing was scanned: every LRU under @memcg was empty. */
 	if (!scanned)
-- 
2.53.0-Meta


