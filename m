Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C23606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0sRMpam3
Received: by kanga.kvack.org (Postfix)
	id 0AAEA6B05B1; Mon,  9 Nov 2026 20:53:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05CE36B05B2; Mon,  9 Nov 2026 20:53:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6BB96B05B3; Mon,  9 Nov 2026 20:53:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A24996B05B1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:53:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E1F671A06ED
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:53:52 +0000 (UTC)
X-FDA: 85417538304.20.943C4D8
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2921540003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:53:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0sRMpam3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794275631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1b9Gm52IiM/h9OrZZh1jFEopd/R8VOMTojmLWfiROik=;
	b=J0NgYzBshEAk5OK13gQPqb6VhpcKEbkcMNU5HmtSyECW2jNMOEQ19BojDcrjB3FTIPCyAR
	pSRKVkpK+1dKx9ZSHeW9hLOSWu6nyS376DD3+twVhdDHMtInfYsUJESxNuBbgqnzRTdrrh
	HK2WdkZlMyVPX08SGJ+Tdd3Dzmmn+ZA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794275631;
	b=0Lq9RrzP5Kk0nujn8jYuioSedSKolc4UH7r9iSvuaOZYHOgasBiu89+dOHY0WNBmZ+HzBm
	72fezIEGMy0Eg8AqKz86Rpi8hWuqz/kTQiOJ3u3MHv3A5gnt6ZhXMAYbusxPuHw3Ng33tD
	VRzt2j7xQnR5XxcVuXo8P2aK0MZf2iU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=0sRMpam3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ed0890476fso8055005ad.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 17:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794275630; x=1794880430; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1b9Gm52IiM/h9OrZZh1jFEopd/R8VOMTojmLWfiROik=;
        b=0sRMpam334LSQBY/2hdx+tnUXJqCvewL7+Ic0FLMLjogeOjm4HQuSTjBf9/pQ0+poS
         thWfZhZcxM0tQw/PIMqs/LVZVKYdHx8ZOOovroYHiGClOASsKeYK9o5JGhggB8zlYRKC
         vqAeJoULMxLQpW07Bb7TNmSoUO21qpgK5FBHrntxsFqO3vLXNXJNz2U4OUHRcNl8AcdF
         taktucx7McW85/XEde9uotbahRECEEBnZiaNfOMEFsvUK2sXu9S08dG+DHtMX74EYErC
         n13MH4NH9n0NwiVOF68GZyDOmhyV0ItchL141RaYCXmEYrHrtJ1vDWexbVlmOhQJWG0t
         TXmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794275630; x=1794880430;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1b9Gm52IiM/h9OrZZh1jFEopd/R8VOMTojmLWfiROik=;
        b=NDVyXKr7I0lwTi6Mq4sGrFPh4Ule1z8i+gQf9iZDNc9JNYs9p0Z2aKHeEt1mPlha7B
         SE3HrmHBLGs6c+sOFxKaGYRRDdKRicDOnlfHdiTocsusmxfpmRtCoZYk0CfaOJcY7ciu
         GV8RqEvCXVqrbLOok7HyQQUnG1lBwpZ//bT7FCiOVdzbVumNQauytHQWO43BL4n79Ldt
         RTgyaYe81GNXXG9wTm0jn1Hgd2Ydu73HvPgMuIfFKmNT6qvFdsGe1ste4IOBIwvC7HFQ
         9jEa1Lh9yNQfa/wvoo0kc+Hke8SXKuYyOsS6DGnHCg0IxiS8xMj4tNEDMV47jmcslzuF
         SXyw==
X-Forwarded-Encrypted: i=1; AL+hErEfrmn+fxHsHbwOT1MRPqBzoLPCuCpOYas+TWxrUcpr3v9C/xcBM2XysJVx1Z14jKLnIXyrKPdd0A==@kvack.org
X-Gm-Message-State: APuU4Z9guI1XCEi5M1zY8Ahbg10qvmgDxqm0x6truIpCafXg8HG5Tkef
	gH7Di6GCOJvdn4anIu+oCo80APH5oA86TebTKW4QvXS6NxB88Ufn1wmY
X-Gm-Gg: AYBFou2mh0bzY071OYub5xuI2d9mtZe8ej6aD4xmNFUigP7SFHWtkljlO4QB513QNmN
	V320N4aKP6mkTdmfXSjha6pWdfZKKoyvgR0DzFXSGKtGE3Ko0JXc9lFW46T6IumWQZqbjgZiSCD
	kQJz9BvEaBCVLZ6l0AcMUyK07dqGu53xv4YlESeT5pU3uAnrKxCp7yAA8FyE6tlbHa2McrlEI0f
	qS7CMZRGI9OGPiFqA46PZBQD4ZP5/7tqoN/JjJLImIriGbZLfa7mZbUieNGCWBM+aT3o0/7QFeZ
	u3e+I5OWx01MiWlKuVEQKVyYB2pzMwEqRaBebYG6a5sceEKuIsWuRyvJiNsxAR+jYVWPTh+PF6S
	egUj3YeiMPGPvITpnOH3gbWKDBZ52oCEmO8Db1OL/qzV9zZBNYzhPrcCRDPMV/a8odTwqQ0lC2c
	CTKGpyc4sm2/Pr5mzE7NOULPHgxctjCfG0DCqamLmgsWWZOu+gkd/HWDky8uXCcYS37LUS0KrFs
	Lq3ec/n9Q+nhp2/BcNo+maN+LGITZTtpenK/qMb+drNziVC7UG91D8sgaPgHw2dlkCGMfV2ifTU
	RJKgRiXVtuJCSojvbr07KCOSIVyIUlOIL8I/or+M3acq2+dfr3tSAF1DML4c0CwVLw3M5Stw9Kx
	/j3ImHa4bym29qxrPAHFddpA1dg==
X-Received: by 2002:a17:903:120b:b0:2e9:660a:7944 with SMTP id d9443c01a7336-2edb92c846bmr9971635ad.58.1794275629806;
        Mon, 09 Nov 2026 17:53:49 -0800 (PST)
Received: from localhost ([2a03:2880:ff:1::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2edb6a3e61bsm3307325ad.11.2026.11.09.17.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 17:53:49 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org
Cc: yosry@kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	sj@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v2 0/4] mm: read root memcg stats from global counters instead of flushing
Date: Mon,  9 Nov 2026 17:53:17 -0800
Message-ID: <20261110015321.611093-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yuy8ob1etpcmbq1f6dusgn4ogas4csmx
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2921540003
X-HE-Tag: 1794275630-233631
X-HE-Meta: U2FsdGVkX19IqhD/4cZkeQZwYxdY3xUBukbcASHduU2+wFwYuGC/bT9SBGtcnyWsQScl2TnRGKxT1ncbHqJF5hACueaQ290UAq5RPgwXDf6SWv4jsxE41XIsoYgzdTjTgDmx5hoot97kgrtIBa0E3vJ3m9Yw5qQEipBQwEthPTwQB7PcGlDeTGPnKyRspblYx3R6yDqEuC4dFFzypUT3V3+/tO6Qs4590mZXs13frveEn3194bHy9OJJJYbbOjtwhukmmagUFbvw3Il1K8d8HjW5B4u8yZpMI0DwZlghhqDdzXJAFBjgPpsa+vPFuvGEKNfAvbiH9188ct4nC1nFsdt2X7b8G8BzR1/ubg86PUcIZp1b0wZklEq1GLcGDs83Wr8UyTS6Osrp0OhshhOCPcbZrSFTLwOFPI3cxiRQVcCi7J26ETeUcpbAOzxEveVG09KtcOJOlr8BMujUJTrQCAwD4NKZ2cmx/1ff2wQneN1y2NE8j7cD0gcrxvbyvN7qJqVN04nBa/deGX0+MFPgvZCR0RG3kTNgTrakLZe0xveCMcv1ndjMRm68C8jEWFr23BMLPFohDXWmJbks0A1g93tk6E2n46LF2i75+ID2E2Gf/esQQHOyKVKD+KEkN6q3FlKWgBuWtGdY14XdIbUGcAUwPl4CdpxIzZSr4ROKRnFVmhj3ZIJpRBexmS+8RKs+g3l3IuWDM8j70To39RXxFCMkQu5YnzA2IBBn7KusYJht4In9hhXkN1ee4n37Urd8qJpkGB3irGAWYf3e/TgLx7Pq+FFdaCPqXSQ7JisSqWJyCsF6cEosRvZT0NV3/nGxCMD6zRQ8RpR72IfsUW3mcx7QVtyFVAM0lvxn9+n2HB3e0wu76+ubqxtF0TCofJEHSuRvN+K5XltaUMrUjcg5N65PuhVbNyRRgEq55loYZ9t1czmXqWTiz+v6Bsow3azjvcVLMmfsDwEgS9oo0CA
 MFTxzbA8
 mE9m0klfpVshmjYWF1WQIZ82db/Hp9PvSoKAYNr66O55GatPC/puqyIPNwI5d8m+qjicTlVF/XtPoNTeNNbKC7K/ga8P/tIbMI1r0gsOQWL4odbXNNOJOeTQ6yHvVJ2+un+QuoCwpXzeR0wu/gtzKDB+JqdXMBPpuqU3eZPcjGr0QErTz6Q5z+pczegrGMHRHlj7vzueQeugR00xlpU3U5z5y7GobHCLDU81cf/3K+NJa6xQVV17G+I8WBpzQsUq7E9oTYLLgc6TTEBtJavIbcfqmDqVFDcv7lghQeVf41UVTZF6Zsj3x+9X6Os9/+Y3plT5G433R/7Gf6Jbc3P8021FPE2tKcu6eI9D5E1Gb28UnfUmy+JK7CS89AJKTzbsdrnWMu+I6pYjpPKPoACb0JAbSFytVeN0l58MdVR/o7MRCknLoAV2LkJbzkwk5tayFd1n+mPmyF92mnHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reclaim, refault detection, the zswap shrinker, and DAMON quota goals all
flush the memcg rstat stats before reading them. When the target is the
root memcg (eg global reclaim), that flushes every cgroup in the system,
which is expensive. Most of these flushes are ratelimited today, but the
stats they read can be stale for seconds.

For the root memcg, the call sites can read global counters directly
instead of going through rstat. Global counters are always up to date
and don't need flushing. For stats that only track memory charged to a
memcg (eg LRU sizes, workingset, rotation, and reclaim writeback
counts), the root memcg's hierarchical value equals the node counter.

Patch 1 is a zswap fix for the shrinker's count for the root memcg and
can be applied independently of the rest. It doesn't have the stable
tag, since the zswap shrinker is opt-in and the fix can change writeback
behavior. With a workload running in the root cgroup, the shrinker wrote
back 0 pages before the fix and drained the whole pool after it.

Patch 2 makes lruvec_page_state() and lruvec_page_state_monotonic() read
the node counters for the root memcg by default, except for the stats
whose node counters also count memory that isn't charged to a memcg.

Patch 3 skips the flush in workingset_test_recent() when the eviction
memcg is the root memcg. Reclaim keeps its flush for now, since global
and root reclaim also read the stats of the child memcgs they scan.

Patch 4 skips the root flush for DAMON's node_memcg_used_bp and
node_memcg_free_bp quota goals, whose flush is not ratelimited.

Of the excluded stats, kernel stack, secondary page tables and
WORKINGSET_NODERECLAIM only differ from the node counters because
accounted kernel memory allocated by tasks in the root cgroup isn't
charged to the root memcg. If the root memcg's stats should include that
memory, then those could read the node counters as well. This is left
for a separate subsequent patchset though since that changes what the
root memcg reports and needs more upstream consensus.

Three root flushes remain. Reclaim also reads the stats of the child
memcgs it scans, and count_shadow_nodes() and filemap_cachestat() need
the root memcg's own (local) stats or the stats of arbitrary memcgs,
which means global counters can't be used as a substitute there. This
will be addressed in a subsequent patchset, as well as getting rid of
ratelimiting for most call sites.

On an 80-CPU machine running proactive reclaim on the root cgroup, a
root flush took 69us on average with little cgroup activity and ~0.9ms
with 128 memcgs repeatedly allocating and freeing memory (wall time,
including waiting for the rstat lock). Reading a node counter doesn't
add any cost: it took the same amount of time as reading the rstat
counter (~150ns, which includes bpftrace probe overhead).

For more context on the background of this series, please see the
discussion about memcg stats flushing in [1].

Changes since v1 [2]:
- Read the node counters for the root memcg by default in
  lruvec_page_state()/lruvec_page_state_monotonic(), with explicit
  exclusions, instead of adding lruvec_lru_page_state() helpers that
  callers opt in to (Yosry). As a result, the root memcg's memory.numa_stat
  now also reports the node counters for the non-excluded stats
- Split the workingset_test_recent() flush skip out into its own patch
  (patch 3)
- The DAMON patch (now patch 4) only skips the flush, as
  lruvec_page_state() reads the node counters for the root memcg
- Rebased onto current mm-new

[1] https://lore.kernel.org/linux-fsdevel/CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com/
[2] https://lore.kernel.org/linux-mm/20261102225030.2743129-1-joannelkoong@gmail.com/

Joanne Koong (4):
  mm: zswap: fix shrinker count for the root memcg
  mm: memcg: read root lruvec stats from the node counters
  mm: workingset: skip the root memcg flush in workingset_test_recent()
  mm/damon/core: use node counters instead of flushing the root memcg

 mm/damon/core.c |  7 ++++++-
 mm/memcontrol.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++---
 mm/workingset.c |  5 ++++-
 mm/zswap.c      |  7 +++++--
 4 files changed, 64 insertions(+), 7 deletions(-)


base-commit: b95f8bb86713c860ce8536d22a988b949b884d5f
-- 
2.52.0


