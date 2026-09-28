Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 203CAC9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4197D6B0088; Mon, 28 Sep 2026 04:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CA3B6B0093; Mon, 28 Sep 2026 04:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E15E6B009B; Mon, 28 Sep 2026 04:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1113F6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:19:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 987B01C04C0
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:19:16 +0000 (UTC)
X-FDA: 85262471112.28.C661EC8
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf23.hostedemail.com (Postfix) with ESMTP id A75F0140003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:19:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790583555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=d+cFRRQuCPtbfR9h4eG+ppCeD2oCzPsJpaeYcstlNeY=;
	b=eLDT3I5Y4TTStGG/daSIoTPCYj+NJ+DaLksHfXHAK7sBq7NHrxRvZKCCtua1LMHZWK+D45
	gx57buzURFPIzbFY6+CfAku5Q6BALMwH+mIdW6UYoysFdTcnOXHRtIvusi0L26BuJmdx0q
	b07mIj7U5MBHVvuV5qzHsDKjpX/X098=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790583555;
	b=GojBuzCyVmQak2yJeQJj69X4lbMiwjeyk6CVlwO+B9NDItt1xUnc/FX1IlIUW6qDj8+1Hq
	zPAwKo6eZ/Kqpzkw67MW9m7fZGxqfGSyvHOu+CaxOjJVvpOw8i9D5mNHB6/vlzAaf140Y/
	43OUt2Oyo0G9CSAu/AiRkEKzFZGsv8o=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 0DE633E972;
	Mon, 28 Sep 2026 08:19:08 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [RFC PATCH 0/4] mm/zswap: make shrinker writeback work with iocost
Date: Mon, 28 Sep 2026 10:18:35 +0200
Message-ID: <20260928081900.4187482-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGDAZTY8FQdfIVgvulh8+Ontt0UHMbNx7VW+SvuP9n/VVpAc15RJUj4OtlP0SQbUn0HcGGGXbzBBp/gASYJS6oVdftruFjiFnihosDaklSoEd+62bXrJAa+/zYSAu4+cl39U0CVLr5WdN46E9L7/Q4tx8ccKm2agYzkHguBa9KkrBths7Yplh0gcXVyS/ngPeLDw2DIh5qJimb0bfwD/0AAsWD/yQvch5ezsNCOkJmyoS5Ic79ZDd4epkxJsioHDkWZtsqSMBR4l6eWELikjxrpKV1btwsNT0QmoHq2jaEkavqSkNYTANQPyP/F43M8V95d8uz5FKIpAMEzb+qV/E9dGOHIu6lbBID3PkMkIQV5fgazvuUzv/CoI1oXR4+kwQITGwxKOht1As2puZhGtjvctCEYLf8n0WF2BN02NFlSuIm7Ob81iipQvFD9c0tP8ElxA7CRRvK581ykoOTp6LX+oErRGuC5JM2LML+EvRXGmcK98f5pELREKePtj8Vgmh+LSRm/ycwcL8UvHQ2po8WykCFDm9GbWnsk8a3kjTw6raq8YKYK1lyUZHmgb6jjStz7q+NbcvKyvNwkbWwi6OzszuZRYfzsQE/tUNwsRLt/dvK7SJ2cUPLiJvDP0Hz8hU3fgPjueoU3fH1OPk894aWjFDSfAOcCZ9Mq8Uo/F8V2ig
X-GND-State: clean
X-GND-Score: -100
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A75F0140003
X-Stat-Signature: z6e8xb5k6mik7pi844rt6y1b89d891xq
X-Rspam-User: 
X-HE-Tag: 1790583554-22493
X-HE-Meta: U2FsdGVkX18VlsLtjhb1ufwHbvFQGrG69MSwXSAZpsETkwtVgm3ecJf+TqGdoZ40w2aMAtIPGOXYMHyNp/qv+HH5w8er9kqrZAgUVASy/Wh0hLmKFJy46sLosA5cQMSOKFC/qae7AxG9Sch6tRuoE8QxEuhD6F13lOdXTgLNaNfCc3QQPHn+bQjRelsW+jjm7UET20pc4d5/8g+soR+3LvembWu4Q3/BOOIelIUlZcZfvHdtXfiVp9Kk1Pisdu/VDk5DvKhhsB2e9lA/Cw5MEeB5T/qH0mfPcONMUT06ovxcacgdcJcV2PQgthwINeGK0KgCPDqnpDm3qyF81sGsnLjNNk4ORsSxdSpf9d81yBIIo8hwSks0wD3aOXEEnCIE6wN+8DvOJLoNIj4K7ZWGyRDld14XV4DhD4XOSNPbHEXHzr7+m5eXiXhqVrTBHHRzvvjMiYMYYU+39zPDKcRcoiVw7PB60euiCu98hWTXP6DrafZ9OTE3di1ZTJ9YKWXirx2FbvLlSj2A7M82Y90RKYvSIJDgAINCuAY+mFZrdC2h0ompp3noOHiH3cgltAnq7MS2IKQHXZbPipbM1DX09bNTGW6sAEcqr37CudJUHhkHKmdS5N0/W5IbsgtNJ0dSLo08k2pVivUxHvEmSVilKyZPKsy56IaO43zeDGHd7bZsr6f8NycPntw+VGLnzXUtTGntmUDnYawehyqw2SQWJ9vKJVce0blIzXLRXTLwU9vcx0AEl9jGS1tsjXUQ5T2vgRhygQyp//4j1RYMXpd39c4xEYR5PygBTB82nmQkBNvOm2hymUqNUhu/9GQI5YwzUr5YvEIWY3wkM8WeabBaIGEHHtvguF4fEE8hTrqU5c3Meq346Qx0AE6zvVmbk5UCHgpeES9YCBK9acTSF/R4DWc2PUxm3pM8+NRDNosLc1FRKLbvD/J6iCUpUc2paFW/KSRO8MN3s2l/uMVf5f6
 Jdp22bNn
 H7mxF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to enable the zswap shrinker on our fleet, which runs iocost,
but with it on, a large production workload is slower than with it
off. Two reasons:

1. zswap writeback is REQ_SWAP, so the IO controllers issue it as root
   and charge it to the cgroup afterwards, as debt. The workload pays it
   back: its swapin and page cache reads wait, and iocost eventually
   stalls its allocations, which in turn stalls the application.
   Patches 1-3 let zswap writeback be throttled instead, by marking it
   REQ_BACKGROUND.

2. A throttled write sleeps in its submitter, which for the shrinker is
   whoever entered reclaim, often an application thread in a page fault.
   Patch 4 moves that writeback to a per-lruvec kworker.

Large production workload, 10 hosts per arm, CPU matched, one 24h run
per comparison. Change with this series:

                     vs shrinker off    vs stock shrinker
  p50                    -0.7%               -5.8%
  p99                    -0.2%               -6.5%
  memory PSI full        -52%                -94%
  zswap pool             -97%                +12%

The benchmarks below run with iocost enabled, in a cgroup whose
memory.max (the "cap") is smaller than their working set, so they are
under constant memcg reclaim.

UCacheBench, 12G cap, 5 runs:

                     shrinker off    stock shrinker    this series
  ops/s                  469k             280k             634k
  errors                  0%               44%              0%
  p99.9                 5.8 ms           16.6 ms          4.3 ms

MySQL, sysbench OLTP, 256M cap, 5 runs per host:

                     shrinker off    stock shrinker    this series
  TPS, host 1            OOM               413              609
  TPS, host 2            OOM               399              666
  p99, host 1            OOM             334 ms            90 ms
  p99, host 2            OOM             273 ms            44 ms

FeedSim, 16G cap:

                     shrinker off    stock shrinker    this series
  QPS                    4.7              30.2             32.4
  p95                  1306 ms           495 ms           494 ms

kbuild, defconfig -j4, 600M cap, 3 runs per host:

                     shrinker off    stock shrinker    this series
  build time, host 1    784 s             788 s            778 s
  build time, host 2    691 s             696 s            680 s

Alexandre Ghiti (4):
  block: do not issue background swap bios as root
  mm/zswap: turn shrink_memcg_cb()'s argument into a flags word
  mm/zswap: allow writeback to be throttled by the cgroup IO controllers
  mm/zswap: move reclaim-driven writeback to a kworker

 block/blk-cgroup.h       |   8 ++-
 include/linux/swap_ops.h |   1 +
 include/linux/zswap.h    |   4 ++
 mm/page_io.c             |   7 +-
 mm/zswap.c               | 148 ++++++++++++++++++++++++++++++++++-----
 5 files changed, 146 insertions(+), 22 deletions(-)


base-commit: fe2ec83746e501645709761605c2464a44fd2929
-- 
2.53.0-Meta


