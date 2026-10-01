Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 378EDCA5FC5
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 00:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 024F16B0088; Wed, 30 Sep 2026 20:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17E16B008A; Wed, 30 Sep 2026 20:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07766B008C; Wed, 30 Sep 2026 20:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B3F6E6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 20:14:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A69C8C028E
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:14:27 +0000 (UTC)
X-FDA: 85272135774.04.5447319
Received: from mail-pz2-f38.google.com (mail-pz2-f38.google.com [74.125.228.38])
	by imf14.hostedemail.com (Postfix) with ESMTP id DE410100008
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:14:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ny+oFgr5;
	spf=pass (imf14.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.228.38 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790813665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NMBKydyDXomE0cjnYGxv2IYVxFWQ1Eth8vx/ghbPX5M=;
	b=aoqOUhXmHDIDmCh9LabjboelffcDB0gthCP/70YFwYF5Yg0svz0DqL/10jDdhL3WS92Any
	GCX5mqvsR6+xDVhz8kaTwub34c0tcHEPIukxjGNEA038InbM52LVmJZqipcxFcgT0N9AaE
	8Q0R6neJfxG8Vjnk/RYksv8y7R4pitE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ny+oFgr5;
	spf=pass (imf14.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.228.38 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790813665;
	b=yumeYZ4oZEz4qyzBe4UTdg/aAU/1EyjENQ4rySSZhe/65hLr8ow2d53v2gJcHXMWIkdAM4
	yR40EUTquAuD34q9jnV1+PcNb9qgWyR7STbn+woRaq42Jgcq/gHXqjih1EIv624MgxrHqJ
	2JcPnkA8CSLTsICIrlPukqDvknBlQpQ=
Received: by mail-pz2-f38.google.com with SMTP id d2e1a72fcca58-88582e2153eso1891835b3a.2
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 17:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790813664; x=1791418464; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NMBKydyDXomE0cjnYGxv2IYVxFWQ1Eth8vx/ghbPX5M=;
        b=ny+oFgr5hNTc6p9DtiD83njusH6rG4iywfswRorB3W2Eaa6EoGJfDqoKIpF1ibXzVR
         6K35167JVFgYjffkrUNcIfstfRI767qTh2QFPELYuZuj31SYBDv5b4idXdI0O0MO8y++
         gKVNxbYQ1k5wPW+W5KKXJ4yd2Ere1VW7IMyqj5oWjHtEf1M3l9Y+mmqJwSIKJypqIy8/
         Ekzhv08brWiPmu7qXrg5hqhIF0EVXhar5BYi14rMToAxxMsioU9OJluILdnYJNRH7jRf
         TrXCfGahX07VAQRYQDS7JWkSJeDBXu6BTH1leReo+0v2aiHXDnXqBhMk8OLXlJg23X7H
         SctQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790813664; x=1791418464;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NMBKydyDXomE0cjnYGxv2IYVxFWQ1Eth8vx/ghbPX5M=;
        b=TaPfaEhJbiqv5PrZrZqrNGe+neIOjbWuHunWFwz9HNdH4j9tAzTLYYeIUqdl3Y6M4p
         tufJbcHPxQhuwgfjg3MeE681voQAnCQ6WO+qDC7cg4SaF38AGmfeRRaBfcYS4B+bIIVt
         JOk5xkdEcG8mRD8Pun4r87ts9HyQkVe68VoSji3JpdZAQ7VpJMtsMdLyCM6CuxNXjpHh
         u7Kf86Uck6saHgKzBykQC2i4ReqMSPXy13RDCg7u6CWuHpFm3rd3/Fpf3uSz7YN85jl1
         0dNkWU9Fx4KG8HFyy1EVKsVQG5J3cj0qffsdzHWZkdV8YsPmFqAv+Jp5k921T/Ju0uGc
         ab1A==
X-Forwarded-Encrypted: i=1; AKwUvBwoC2NEoSnXsQeX+G3f3df5vdx50lQ/b0w5jtYKoqeh+WLo7OT48jHEw+3Y+XAICyPFRZaCXCDDrA==@kvack.org
X-Gm-Message-State: AFuF++mDBVnC/t5ugcg1taYre7F8lSdSmmIMMobxMg9RkcFqDDRklJVQ
	gwfXA9iIB4+PGsL4wZqbPAlzDiqgBDtyCSoxi4qGZgLaxf3zXfMCesUw
X-Gm-Gg: AYBFou3ovuUNTGr1xiKscTny8eP4XUrMj3PRqMI6DnuxOnoVuYK7PeVsUycp8jTZ8U6
	p0vzfRf/XFoh4dCvxqCTUj9aAUO9vH4w/kKiqEOCnCBdULMeizUYa5OddZsFjUBmC4LZ2WZBnLv
	klcaB4vdMGBEOc1UaJTOVzN1aLBVjaGEcDX92briCyVeX/z/lzbaAVym5As98JO7PtmO5R5nYHC
	JmJErUVUhJIsekT64G0qBXSRhulaK5L+4En3Lr3SzqrG1tzLj9e1txB9KKDmu1yCS8OkQtqfzbh
	2aUSLz8MhM/ezZh5FU2S72Jmbg2rSbsAIc8cFflP31ke3E6hd71e4Md6OytxCQtmRv+i5bhnY7p
	csNKD1HgqogwhYQ8018ogQ8/RqpaCVDi32xKIQg8/Bae5lF267qL7i88+PyinhRoGavO2arqkCg
	QqpDBB5r7VqI6L6dZiZHyVEgcQp8kjxA2TEqfyCz3VZo4jirXIe74bUVMM784LrF/5SQRl2ao4Z
	kXqTLMBPTR5zyKk
X-Received: by 2002:a05:6a00:10d5:b0:881:750f:b142 with SMTP id d2e1a72fcca58-8874c8d3331mr2523937b3a.55.1790813664458;
        Wed, 30 Sep 2026 17:14:24 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-88818814b2bsm253287b3a.19.2026.09.30.17.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 17:14:24 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: [RFC PATCH v2 0/4] mm: compaction: mTHP-friendly memory compaction
Date: Thu,  1 Oct 2026 08:14:08 +0800
Message-Id: <20261001001412.3837085-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DE410100008
X-Rspam-User: 
X-Stat-Signature: cyje3qqyft4agr1715o9m9yoi1ybcbad
X-HE-Tag: 1790813665-635777
X-HE-Meta: U2FsdGVkX182G3BjzageEq1o/1KmdZPEROFuArNcRa2hJ4AyUTOrrNwfduyTo9UXZ0KnsOEVxYzNqmTqRP62DztdKznFeKOCDhxSuL38nBCi39xy1eZOxu8/6SlKJJc+3ga7FYID43/f8uttf/RFmEQGPynoIf7c4N6FEs2b2mp8RSpKTKDqPyUXKHPtvFj6exqwMFMT26R7ARzSmIHs0xJZMXPekbwpJ+ebzMk9ijjJubn2BSYMdMneGxQxpL+kJXXhWRCpJEZdcgK+bIXebIMeZqtQcrK+n+hVN4mb9AYNHQeY/6Z6ydg/qJRpikw1iz5qxyD3lh9zbKNiNW7Zmvg9EmvUT8zFcb3ysETFGaDKCU4LZ+8KSTiRluWDzWVyQxftTDwxyFjGzJHwt8dSEQ8b2P7QAiiACZooX5sCmWETYfyQC1XgaA+FeTgABM2pyhOcRji/o6RnDAGPOYJ2qurIryW0Q1pCWnZktEJHVclNkj2WHO4cONqYrOeIbLTC7lFc2CIOF2poqU217K7EcQ/ddofX6DNyOnv/zfS+7omXmSqtm7fwLV4yzIMcYIsY5HGnBpYreEJjRoZV7uWf+hYEDuYpQmGG3ynXEdF5dIY8TOH/wU1SvTvT4OXJpb2lVPS3oGkFaiCbHsYcR7olcpOvmWCb7CJpnQlvl1LJfghPQ6ZATYDUDzGm98WksZJaVm1Q+uwDlaOZP5/O1eVVox/y0T5+bzLaED3VcVtG3lWMmxYFbwdjja9CEEzPt5adZ4tOlgclcQPm/r/P0klhKZBvCfP57QKNT3FiPldX0FBaiTRlALRaakxunCegHu2HlaeBmvTDu5x3yVnoK4izr0ELiMC8ItMiBE/jLBE48hAbxHIVyyEQPmOHUV7zCxIm08wCJcyUNcnZ0vOxKPhneMSuIXni4b+WW2Y9ICukW7XMzEv1zO4xjMzJ2ywRSeMlEyF94dTvb79XTN/oyfa
 Xn3/xktc
 0qaEJERPHBIablz+wIywD9iZr9m+8TVxJ1evzbXY27nixaPoxsVR8MNFoAU9KrMdmKvHMZKNrlxBAerjVBFsKPL7yBwc6SVj4OIFp9DMRsjP1dVC0T1iohhRKXawJTmeZw2BIIL29VbB/JhkyiKSROBCHA5P3lupiVL2+sVvX/BZjsA5ZO37oQxMZEC65K0ts/sXbJM8PvTNpypLzwgJ7bHCJCZs5oMCOWxPVHy5BJbOggCBE3K1UbCNgMkclVo9VG46UHtmLUnkP+J8cg5/73cIXTG4TGqmsUpVZpZI08MNqUbJ24qBrk0uPOdlLJuNaNYIc3HYsCQybvvkIezuAzQTAn6qoQOT/1yLr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This series improves memory compaction to better serve mTHP (multi-size
THP) allocations, particularly for small orders like order-2 (16KB).
The changes focus on the proactive (kcompactd) compaction path.

Problem:

The current proactive compaction targets COMPACTION_HPAGE_ORDER (order-9,
2MB), which is unfriendly to mTHP in two ways:

1. It migrates folios that already satisfy mTHP allocation needs. For
   example, an order-2 folio is a valid mTHP page, yet compaction still
   moves it around trying to form order-9 blocks. This is unnecessary
   work and wastes energy.

2. Compaction designed for 2MB huge pages is too heavyweight for mTHP.
   mTHP allocations are frequent and only require small contiguous blocks
   (e.g., 4 pages for order-2). A lighter-weight, mTHP-aware compaction
   strategy is needed to reduce overhead and power consumption.

Approach:

This series makes four changes:

1. Generalize the fragmentation score functions to accept an order
   parameter. This is a pure refactor with no functional change; all
   callers still pass COMPACTION_HPAGE_ORDER.

2. Use the highest always-enabled mTHP order as the proactive compaction
   target. Because a fragmentation score for a small order is naturally
   much lower than for order-9 under the same fragmentation state, the
   proactive watermark is scaled down in proportion to the target order;
   otherwise a small order would almost never reach the trigger threshold.

3. During proactive compaction (compact_memory), skip isolating folios
   that already satisfy mTHP requirements, avoiding unnecessary migration
   overhead.

4. For non-costly mTHP orders, restrict proactive compaction to movable
   (and CMA) pageblocks. Unmovable/reclaimable blocks are dominated by
   non-migratable kernel allocations. scanning them wastes cycles because
   a small order can be satisfied from movable blocks alone. Costly orders
   keep scanning all blocks, since they are harder to form and benefit
   from any migratable page available.

Test setup:

x86 host, arm64 cross-build (defconfig + CONFIG_DEBUG_INFO=y,
CONFIG_DEBUG_INFO_DWARF5=y), booted with mem=4G. order-3 (32KB) mTHP is
set to "always"; ext4 root mounted data=journal. The kernel build
naturally fragments order-3 free memory during the run.

Runtime (two defrag modes were tested, see Results):
  echo always > .../hugepages-32kB/enabled
  echo madvise > .../transparent_hugepage/defrag   # or: always
  echo 20 > /proc/sys/vm/compaction_proactiveness

A background loop keeps proactiveness poked every 100ms so kcompactd
re-evaluates promptly (its default 500ms interval is too coarse to catch
the transient order-3 fragmentation peaks under this workload):

  while true; do
      echo 20 > /proc/sys/vm/compaction_proactiveness
      sleep 0.1
  done

Workload: make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- vmlinux -j28
5 rounds per configuration; each round: make clean + drop_caches, then
counter deltas around the build. The baseline is the unmodified kernel.

Results (5-round means). anon_fault_alloc is within 1% between kernels,
so the fallback numbers are directly comparable.

defrag=madvise:
                              w/o patch     w/ patch    change
  --------------------------  -----------  -----------  --------
  anon_fault_alloc             14,307,597   14,401,699    +1%
  anon_fault_fallback              97,701       40,975   -58%
  fallback ratio                    0.68%        0.28%
  compact_isolated              8,479,773    1,458,949   -83%
  compact_migrate_scanned      78,198,828   22,900,359   -71%
  kcompactd cpu (s)                    43            7   -84%
  sys (kernel build)                6m34s        6m34s    ~0%

defrag=always:
                              w/o patch     w/ patch    change
  --------------------------  -----------  -----------  --------
  anon_fault_alloc             14,370,984   14,404,234    ~0%
  anon_fault_fallback                 619          823
  compact_stall                       979          585   -40%
  compact_isolated              6,390,940    2,431,800   -62%
  compact_migrate_scanned      86,171,095   46,339,911   -46%
  kcompactd cpu (s)                    36           13   -62%
  sys (kernel build)                6m34s        6m27s   -1.8%

1. With defrag=madvise, the patch cuts mTHP fallback by 58% (ratio
   0.68% -> 0.28%).

2. With defrag=always, direct compaction already keeps fallback near
   zero, and the patch instead cuts direct compaction stalls by 40%.

In both cases the compaction is done far more cheaply (kcompactd CPU
-62..84%, compact_isolated/scanned -46..83%).

Open questions:

1. In skip_isolation_on_order() and elsewhere, the target order is read
   from huge_anon_orders_always directly, since during proactive
   compaction cc->order is -1 (via compact_memory) and there is no clean
   way to plumb the mTHP order down. This variable can change under
   userspace at any time, making the semantics fragile. Ideas on how to
   pass the target order through the proactive path cleanly are welcome.

2. The proactive watermark is scaled linearly by the target order
   (wmark * order / COMPACTION_HPAGE_ORDER). This is empirical; a more
   principled cross-order normalization of the fragmentation score would
   be welcome.

Changes since v1
================

The series is now scoped to the proactive compaction path only. Two
patches from v1 were dropped, and two new mechanisms were added:

- Dropped v1 patch 3 ("don't skip proactive compaction for non-costly
  mTHP", i.e. running proactive compaction concurrently with kswapd).
  Follow-up testing showed it lowered fallback mainly by driving extra
  anonymous reclaim/swap rather than by better compaction; keeping the
  original kswapd back-off avoids trading workingset for mTHP fallback.

- Dropped v1 patch 4 (mTHP-aware zone_effective_free_pages() watermark):
  it added reclaim pressure without a clear net benefit in this scope.

- Split the former patch 1 into a pure refactor (parameterize the
  fragmentation score by order) plus the mTHP-targeting change, so the
  mechanical and behavioural parts can be reviewed independently.

- Added the proactive watermark scaling by target order, so a small mTHP
  order can actually reach the trigger threshold.

- Added patch 4 (skip unmovable blocks for non-costly proactive mTHP
  compaction). Without it, proactive compaction wastes most of its
  scanning on unmovable blocks full of kernel allocations; with it,
  kcompactd's CPU and the scanned/isolated counters drop by an order of
  magnitude while fallback still improves.

- compact_hpage_order() uses __fls() (highest always-enabled mTHP order)
  guarded by #ifdef CONFIG_TRANSPARENT_HUGEPAGE (m68k allmodconfig build
  fix from the kernel test robot).

- Refreshed test data on an mem=4G, order-3, data=journal kernel-build
  workload; see Results above.

Bo Zhang (4):
  mm: compaction: parameterize fragmentation score by order
  mm: compaction: target mTHP order for proactive compaction
  mm: compaction: skip isolating large folios that already satisfy mTHP
  mm: compaction: skip unmovable blocks for non-costly proactive mTHP
    compaction

 mm/compaction.c | 85 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 68 insertions(+), 17 deletions(-)

-- 
2.34.1


