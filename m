Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEB79606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.a=rsa-sha256 header.s=shopee.com header.b=dX7S+qzM
Received: by kanga.kvack.org (Postfix)
	id C38E36B05B8; Wed, 11 Nov 2026 02:17:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9546B05B9; Wed, 11 Nov 2026 02:17:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFEFB6B05BA; Wed, 11 Nov 2026 02:17:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89E556B05B8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:17:41 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22A2980207
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:17:41 +0000 (UTC)
X-FDA: 85421983122.18.5426F4A
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 35B07180004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:17:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=dX7S+qzM;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf06.hostedemail.com: domain of mingyu.he@shopee.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794381459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7JuUV+9RepX3x2BjxY1OAwwH8ZUYdafN/RIIq5XC+Dg=;
	b=yZKDffA+Pi/PzFIawuIKDYQiF4mZqY3hccxauZRomVeJ5q/xG+GOit1C1oFvpw+q+oW7XB
	mDwPkbLx7v7fgnkzbpL4jyFQwVhzxM2p4zVUnywTOVjHdguWzSi3a7j91p6po0epSSzm6F
	m1I9qagkZeTw2SWwcL/3BpVZECSdfrU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=dX7S+qzM;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf06.hostedemail.com: domain of mingyu.he@shopee.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794381459;
	b=ijBihWujbwHBm5gU1gaIYh+o3gZ/wavWwDxWpnDHX4FZorDVUSdKgK/lthS4X1MzN94h5s
	0KQMMIeYIwNbn23l5ZhNn5z5PG2djpbKCDZY4sXmyrILDMN/A2hjmIJC4OBg5ErDPb8CMC
	nUZ5fgwjPbZvU5vPSlWUJh/2JTM0w9Y=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc4aa18f9afso1199558a12.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1794381458; x=1794986258; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7JuUV+9RepX3x2BjxY1OAwwH8ZUYdafN/RIIq5XC+Dg=;
        b=dX7S+qzMnMo3ZfxXNo1MZocgi+CJ5I82AXzLSW4pOOphgj5QP7N7YtAs1+ezBAQVKP
         +m/MYAziPemp3idzlVrk20F8MQV2AB+uI+cyWwizEfuOUzPS/ePkxaddgei5SLjAG+5U
         o+exrXh+LrsfZMsViLYcVaXvY3/a9cZVLmunEbJrNC3Z6hoqTFVch9BlNmTpxETkw4jH
         1VzUWmkU4aI9as0RUC0Rn0hyy1X8HfG/TP+qbym6dR1wH/TZ4V/6pXdyerDBdPkfLdkK
         pV9d4QeyOPzNcN1c5xgspTyys6u3jRNQRJzxQcGkRHrRFjp1VGG5gXXWfYQlRj7Xqy6Z
         MYnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794381458; x=1794986258;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7JuUV+9RepX3x2BjxY1OAwwH8ZUYdafN/RIIq5XC+Dg=;
        b=o6GiqeRMtkcwLcQg8EZiof4y8mgGLisNCdH0eyXQ93LpNqJ8GIlbXzm463ZS9PcyL8
         NxJmj7dgN4jEkC7gyDlC7ij/gH3hKFsygd3pDo8xpioY+U5z0pzln/O7apy8s+8urPeX
         HAJjzwasmObfa+jCPo+lMULkaLgU7EVoMhvWA66cMCj3qQXcu/zt6q8Py6tAcD/TGabM
         7U7Un1imCmDXzOfX2Z/ZWHw+A4YAxXKIDVMyRB/6ODGfT1driHyyTiLYv6he2mDPYClN
         MLY64voIea7hMb1X53YASVMDTE45A4gVajhMy6LBKH2Saf+LfOdEKNQCYWZRT006JuPn
         4d3g==
X-Forwarded-Encrypted: i=1; AL+hErEEM0RpaZHyETggBFSwbHraj8Ea654cj2SQ2/vPoArA065hTT4iFxxkCaMN1lwiNNBwD1+k8wMxKA==@kvack.org
X-Gm-Message-State: APuU4Z/nYrO+qspBx9kvaUaQdk/ctL7tVK4xtnQb7YGmbbwPgY7FO+vf
	rdTQJ8dqE3oyNLBnSi1WGibBAvCXUZRyiMc1rmv/mwJsFJZZMig2bRFYBcFtJqkYjAA7zNO5Oix
	1zpi082nfdQ==
X-Gm-Gg: AYBFou3zA6WKtcfu6hAEVkrr+BNbSiiKI0isw9hQe95Merwoa3r/rX/Idw8ZL8tc4gw
	4ktLPrv2MGte/4ZAs1d0FKCuzYjFJUIop85bNF7oV7Exru5Vykz0xWLgIpu95RMK2B4dMoCkQuj
	5w7QAsYY1KkU/8EJ/AsSADdj9TYc3MkE2RTpqEe8Putg6++ilJyS9WECJCqvSLh9t2YFKxXguhY
	dUiPXf1Gjuz+2JVz6AsIMJfJZE+lqbwxOfYRasYdSYmuemE46JOjNd+ryOiOZKGi4fe7nGF9xzn
	Vqj6D41Lak68iLNvEnrq9NBzoG+CXoNAjw5VmiBnAOfMBbTGR2jUdN/8+vWBIk50fSm6IS4PvSC
	/Vo89WnMa8fWRtpvwTWzQLqqnU5aDQe0rNcuLgdAsb9FIq/IL6vP5X6OhM/hw6RSAXoueSZHB1L
	FHWFOGjod7hVLjjbAOIFdUGd69zcOikVTYC9GY5syM10+mY9kfPBJ3d9XgYdwtKLrT93fd7OasA
	ijrq4C4wzANUgZ0NOWRzsb6d9KglfhWH7mgzPeArJApv4255ZtwX8apCaRrPVNNEHwaSl4pJ0Zn
	Ujmiq4MhSrtpG0Cm6Q+eqbfGWffQ3uicqJK+k2LLFdMMhf0u8A5grJdiKi0Hn1XnBPMy7HUJsdO
	0gnjHFJZnEEv/8d8=
X-Received: by 2002:a17:90b:2552:b0:3b0:9deb:d994 with SMTP id 98e67ed59e1d1-3b182f85315mr1524391a91.64.1794381457818;
        Tue, 10 Nov 2026 23:17:37 -0800 (PST)
Received: from LPMV6FJ9FM.cn.corp.seagroup.com ([143.92.118.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17db5cc73sm3189218a91.10.2026.11.10.23.17.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 10 Nov 2026 23:17:36 -0800 (PST)
From: Runli <mingyu.he@shopee.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	littleswimmingwhale@gmail.com,
	Runli <mingyu.he@shopee.com>
Subject: [PATCH v2] mm/bpf: Always flush memcg stats when explicitly requested
Date: Wed, 11 Nov 2026 15:14:34 +0800
Message-Id: <20261111071434.34547-1-mingyu.he@shopee.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 35B07180004
X-Stat-Signature: 8deidqbuyxj93d6x4irc78nrjjcnxggg
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794381459-298736
X-HE-Meta: U2FsdGVkX1+f24i6F3jHDTjGFbVqyfOqbOoeyDYSQJ1SFvAh6jqmd9Lo2buezNzMerQ4Bwf32WF9Pw6TlAYkFKJZJ7qkR8ie6yRm4aVWAikyXvpM/S7PE0n3YrdRXxvwKxe6cwMcxtpkEapacxpZ1ejSvS7lTRGzSyJjO614/779tmcXc+/HW/53FT0nhg44E6h2VBZa3HACpNR1rNgGIe8qoLxxc73WMNNH0MoB3VRP1mbHyLH7zMO57aOXpsBrCzwVmN3hdXSBUrKcr3lJlk7Eq8nD7cn+315rOfiM4nLqQQ9Lyrn9K5kdx/WPAx5NlH4QjpgYMrObvJDc82Am275SSrJHFiz5rDXtuxWmXl6C2fJ13OCgRmNFfr2Zlo3m5qLAnNaXHw+y6EpTLdW6qmovpmspDjMBrOQIyJjQgQ6auGUXpHWpOp5bKnvgPqlUQUYSGChl/wyACgADCd8EifrfXjU06x/HN/mNVblpqEJHYhR2Lc8ltssE2Cqy2eXwoRTfxH0bRMqnF5hzgcf3cR8+rrZfSU2HkbDf4wfMP6mEFCChuNYHNfNUFAessJSjO6EhUR3R5tdhRGHkBgf3zFHEk3G6LcfGjCoYuLtVyuxPy8IO4kySPDn/A65bjIh5elveCvMVoJmrkbCEvcEo/YoljWDp0Iifw35U0kDArsACvlKU7n49Zt6iQNzBk8gzEsTMevT603BXFaQQedJLqhYFzeCAHY6o8gTD+DU5O4/LUIHRpvGNFMvpMU40fxbtWsH408r7uSYFKk0ZoE10gLCI4C6Klpl0F04AvbZQnJ/Oq+apg+naqt+3C4HxW+7Rck3+WyF3cbUJSiNnrRd5KLbizzRHh+516ysQsukBcLq5Wc9b+3jfV7zqV8bbfz9wkl9BgsT3EcX0MbUKejdAfGJ8VcpfS5sM/w6GbPkj47izxY2AqjeBAHO/sqwMhwcbPxtY3Q1lJ2keXA4qf1f
 GaxFD4yO
 jwQ/jphZf3XxKKgMQXE7msuHpMiUFW/44fVUQYT7y5ZQeJbZ/Wbn5yVohG3uCg6aYc7aPn5Js/lgWe+6x0oDTuSVd10qoxV5NlHx2f7T0ti9f8XPxofppTjpVUVa/eoMOzqsJi5ru017x94l8thd4EanFpiM7xacMdD11p0dz79DfsigN6wlPnvwVFyaiuC70dRd0Iv5LtyOXl/hIp+7ou7/sJapawOdr5dG2MpoJqpSJXRovTcZX3OR4dTa9dP4RZj2bA4Ol+Y+oH688KVb2VabCw6qeI4/zt+hqmApMpdtEhqUphR/BcafayJofLcwsOWyIvwXHDGBs+brRo+WPuJQXyXnwRqqVP6uexFStOcE5/og=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

memcg_rstat_updated() stops walking the ancestors when a memcg exceeds
the flush threshold. A concurrent flush can leave an ancestor below the
threshold, so the early exit prevents it from receiving further updates.

Consider root and leaf on a 4-CPU system, with a threshold of 256.
CPU 0 is flushing another CPU's stats after CPU 1's stats have already
been flushed. The counts below are shared stats_updates counters:

  CPU 0 (root flush)                CPU 1 (leaf updates)
  ------------------               --------------------
  clear leaf->stats_updates
                                   add 64 to leaf and root
  clear root->stats_updates
  finish flush
                                   leaf = 64, root = 0
                                   4 more batches of 64:
                                     leaf = 320, root = 256
                                   next update:
                                     leaf > threshold
                                     break; root is not updated

Root remains at the threshold, which is insufficient to trigger a flush,
while further leaf updates keep taking the early exit. The periodic
forced flush restores progress, but until then the root's aggregated
statistics can fall far behind. For example, page cache grows at rate of
1 GiB/s, a two-second wait can leave the reported usage about 2 GiB below
the actual usage.

Make bpf_mem_cgroup_flush_stats() bypass the update threshold so BPF
callers can explicitly flush stale statistics without waiting for the
periodic flush.

Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://lore.kernel.org/all/avKy9oMwDRjKjfzm@linux.dev/
Signed-off-by: Runli <mingyu.he@shopee.com>
---
Changes since v1:
- Make the BPF kfunc flush unconditionally, as suggested by Shakeel.
- Leave memcg_rstat_updated() unchanged.

v1: https://lore.kernel.org/all/20260911032905.63683-1-mingyu.he@shopee.com/

 mm/bpf_memcontrol.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
index d8f579c28560..f8552651b6d6 100644
--- a/mm/bpf_memcontrol.c
+++ b/mm/bpf_memcontrol.c
@@ -7,6 +7,7 @@
 
 #include <linux/memcontrol.h>
 #include <linux/bpf.h>
+#include <linux/cgroup.h>
 
 #include "internal.h"
 
@@ -154,11 +155,12 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, in
  * bpf_mem_cgroup_flush_stats - Flush memory cgroup's statistics
  * @memcg: memory cgroup
  *
- * Propagate memory cgroup's statistics up the cgroup tree.
+ * Flush the memory cgroup subtree and propagate its statistics up the cgroup
+ * tree, regardless of the number of pending updates.
  */
 __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
 {
-	mem_cgroup_flush_stats(memcg);
+	css_rstat_flush(&memcg->css);
 }
 
 /**
-- 
2.39.2 (Apple Git-143)


