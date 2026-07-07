Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E411C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 07:32:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5157F6B00B1; Tue,  7 Jul 2026 03:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C5EA6B00B2; Tue,  7 Jul 2026 03:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B4B56B00B4; Tue,  7 Jul 2026 03:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F06B6B00B1
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:32:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 93630C1ACA
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:32:34 +0000 (UTC)
X-FDA: 84961163028.16.31317E3
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id DA8B180004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:32:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="U/ua+vsv";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783409553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WJQsLVBduOuIi79XguxT1NsduIFnIZt/nxYyMr+Hge4=;
	b=Fzvbd7DcETtJmpFJVjG6b6DxppW9e1QEpb58GmOuBFOEYupZzvMel7UtKUuad/I6wm6My9
	9JdFn5PK5pbarHR8DromrQjZqGN2gwQ3ci8EaL1X2NApCEOlTPGrtNUZ2x2oYS6c6e2mIK
	EqHM86rSVuKa1/g/YEDx54XF7R46pNs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="U/ua+vsv";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783409553;
	b=vT5HfKt7QQotRuARtnlIRGJdHhOIdg8JBKVhIPkIMzZoOK7FuUBRQiwsYPqg/yvon/tHcB
	DNxe7ZbcV/dJ9WKM9a2A/ZBX1roaGzYq45bxNCpgoPGsVUOV8+LtLQuYRONgoK7N622q2I
	qJjnb+mD0S2qeYkXjcrZV8KfIiM+QUc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783409547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WJQsLVBduOuIi79XguxT1NsduIFnIZt/nxYyMr+Hge4=;
	b=U/ua+vsvKpX1CMOfyJAksgxiQ3qp82R7rn6yXQ52MclaJYxp8UI0k0JG7yG473U725Bq4N
	gUuzr7/v8kF0+BxYiwibZr1v/0Wp0zR987fed5YxpbBxhtcTVF/b1G/rVZcZpyNb9KHP9r
	+dbSbbD15hJCJtWqEu0c30IsOO5Zpy8=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 0/7] mm: store zswap entries in swap table (Pointer entry)
Date: Tue,  7 Jul 2026 15:31:57 +0800
Message-ID: <20260707073215.72183-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: jdghigk6z5sygrbm8qgb1zjbs79iw6eg
X-Rspamd-Queue-Id: DA8B180004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783409549-257331
X-HE-Meta: U2FsdGVkX1/GqGavCgNEJ0LujJOVkWo/h+4VooGfmGktsy2H6KuOj8ZJrCKFN7uzwTwih+LVA5I9VwoP0kQYSfoRlWmwS3jVXCqFJXxYhTc7c1BweCK8tf+64ZbpcZX8bCu2f1KoV/0UWioTFg+Ysry+a3Rv8l6E7BcTKofP4LsT0HRz1C/uRMmN2qkx9XBK2f3tPDv06MPGgaquear1HOxXbL/b9Q3+JykfnzKx5LfvO4RDJRPs14CrDq6vI1q0odxb0jC+P8rlO/mn+JGuN7z5C9IZb7/shJj0pdeNqDTyX1EjM7TwP6jY9nEHQK57stbPTk16ddbep3/51tQMhuYqJq9MItLznEMUYdc7iAyzTUiVgpiQP5UmXJagYpRX/ZfirtKGmKQBZjWfJBioYFf0Pov3L4uLfUM+kAPsAMoXM3iciDEWqtVh9OigiOKhHou7+r3r7BfSumbe0Cn7XomPKwIkIULo1cB2L1O2xQtoVatkSIYvMYPb6LLFItf4s/kF0mLzTN/MH571+pE4aRnxVQYD3HkjtcCa/qt0eQIuVMgUc3fkbGiHuxhLLVuYNyJ/jWIcejkMLJbsFeFq1n5lQA31wEEw6v5QnpAqisqzIEIegI9dqF+/lq/jQ001+2GiNS9E63w8BzgytUnYGUQPuSKl0tHKE269IIKActlVo0m0kQWJFOVhQBJixXtsUI5UqLhWh2J49ma+ofgd5pTEQDeCLr9GEkA3WiUqPjadV0us3VzMDNxNJOaJ2DA7KrGA9YobkubkccGr5Qs1K9J5xdBbhvh9pXhh3XqnDGrMUjRAO3vAIeimTEX3E9P30X+P1xfMOXg6lVvWzZBztqJVLfBttr5nDg/sTYDvbYdJjYBca+ETyHfyIVafYG4GmpysKYO3S9rNVess6okNGR8CyONbz6ylitRE+hirKxUUyftvTevuw2TpDLvBCgnJC/Zk/1y+M9bChszxqyV
 qqMSuzqD
 FcQMnVcAyw6gbagdYjBIMxLkaLsZWsI85eVQ67z54J6Xnf+1Fet/8S/kmH4FHj20xGodVKY2QXJMlbJi0j6ZVMvGg6doIPg7CM87QG6Bq9nkWrUfssfSlfarZLXy/pxV6+3lf6+3aIwetI6hVjohNmsI3fI9iOMikGJl+fmtSmfm+fTECkRWed3ZvgH0Z2OuAm7/9lwz/spP94s8TsdYnKSNpR6G53Lf4HCCh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently zswap uses a per-swap-device xarray to map swap offsets to
zswap_entry pointers. This introduces an additional tree walk on every
zswap entry access.

This series replaces the xarray with a "Pointer" entry type stored
directly in the swap cluster table. The new swp_tb_t variant embeds
a zswap_entry pointer plus a entry count, eliminating the xarray and
its lookup overhead entirely.

Design overview
---------------
A swap table slot can now be one of five types:

  NULL:    |---------------- 0 ---------------|
  Shadow:  |SWAP_COUNT|Z|---- SHADOW_VAL ---|1|
  PFN:     |SWAP_COUNT|Z|------ PFN -------|10|
  Pointer: |----------- Pointer ----------|100|
  Bad:     |------------- 1 -------------|1000|

When zswap compresses a page, it saves the original swap table entry
(PFN or Shadow) in zswap_entry->swp_tb_val, then writes the Pointer
entry into the swap table.  The swap count and flags remain accessible
via helper functions that read them from swp_tb_val.

The zswap_entry is threaded through the swapin call chain via a new
void **zentry parameter, so zswap_load() receives it directly instead
of doing an xarray lookup.

Performance
-----------
[~]# free -h
               total        used        free      shared  buff/cache   available
Mem:           3.8Gi       155Mi       3.4Gi       656Ki       315Mi       3.7Gi
Swap:          4.0Gi        54Mi       3.9Gi

Scalability benchmark: 'usemem -O -y -x -n 1 5G', 10 runs under cgroup
MemoryMax=2G MemorySwapMax=3G.  zswap enabled with zstd compressor.

  Kernel A: cfb8731f5396 (xarray-based lookup, baseline)
  Kernel B: (Pointer entry)

5G test — the gap widens significantly as swap pressure grows:

     Metric           xarray(A)       Pointer(B)
    --------------------------------------------------
    Avg throughput      709,556 KB/s    792,681 KB/s  (+11.7%)
    Avg free time       167,994 µs     132,896 µs   (-20.9%)

  Free time trend across 10 rounds at 5G:

    Pointer: 126→124→126→126→124→129→138→145→142→148  (gradual, +17%)
    xarray:  136→139→136→160→162→161→159→230→219→178  (collapse, +31%)

  xarray degrades sharply in the later rounds (last 3 avg free time
  209 ms vs Pointer's 145 ms, 1.44× worse) as the radix tree
  insertion/deletion cost grows non-linearly under sustained swap
  churn.  Pointer entry avoids this entirely by looking up entries
  directly in the swap cluster table, which is already hot in cache.

Baoquan He (7):
  mm/swap_table: add Pointer type support for zswap entry storage
  mm/zswap: add swp_tb_val to zswap_entry and Pointer accessor helpers
  mm/swap_state: do zswap conversion in __swap_cache_do_del_folio
  mm/zswap, mm/swap_state: handle Pointer entries in add_folio path
  mm/swapfile: handle Pointer entries in count/dup/put paths
  mm/zswap, mm/swap_state: migrate zswap to use swap_table for entry
    indexing
  mm/zswap, mm/swap_state: replace xarray indexing with swap table
    lookups

 include/linux/zswap.h |   4 +-
 mm/page_io.c          |   4 +-
 mm/swap.h             |  52 +++++-
 mm/swap_state.c       | 117 +++++++++++---
 mm/swap_table.h       |  35 ++++-
 mm/swapfile.c         | 107 ++++++++++---
 mm/zswap.c            | 358 +++++++++++++++++++++++++++++-------------
 7 files changed, 508 insertions(+), 169 deletions(-)

-- 
2.54.0


