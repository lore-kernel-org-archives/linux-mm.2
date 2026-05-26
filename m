Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 458CCCD5BC9
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 03:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F01F6B0088; Mon, 25 May 2026 23:39:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0C16B008A; Mon, 25 May 2026 23:39:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B7046B008C; Mon, 25 May 2026 23:39:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57B936B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 23:39:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D931812025B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:39:44 +0000 (UTC)
X-FDA: 84808166688.11.2C248C8
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf20.hostedemail.com (Postfix) with ESMTP id 33DB01C0007
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:39:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sreSYi4o;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779766783; a=rsa-sha256;
	cv=none;
	b=aQ+ImG9VlyHwmiQzdnOqHQ/F8YDFyyGcnah/OwARZh955x2kxKvMXPVHbHtlUtUOeev7Ks
	sgqZDoDzmwWWpVCWasQPSPITvP/E09/0PjjN21Sy3FN0ESuaj+L8keyKEWXqGP/s/2Niv6
	fiVlpZ1XG7ogFJ/1njn2FDVLepCEP10=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sreSYi4o;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779766783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nvpqW7ibe5xkt1e+Ex6u6rO4+BgyyQ77/2aNrwatCuc=;
	b=03LNHGqw3IcME6F+8wMa6BTNkEqPoMhLRpT7r5Tfd0xMFcED/6c4CelOTZtr6j/VYYmdHp
	pmIzf1iTSfNzjPffZMDB1VUOgw4pVGEw1XVjnhdVilqMrSur7VNh43U0LD7jWT+Fl05bIl
	56KpEBTiPMei8veUA8f6CJcAhXHqrpQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779766781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nvpqW7ibe5xkt1e+Ex6u6rO4+BgyyQ77/2aNrwatCuc=;
	b=sreSYi4oA1LA9VSAfRsj2bnDuCMWeS7fx0WkQeDjzmeSKORaGFS5uJNnJ9+o5F54XEjqeu
	XHdsIQKAgEp74gbMuuzupg0+YXI2+x4jjhF41jbgBcjaZapr8lSkFa2DFnwfasRLhuXXY+
	VMA4KLKdusErJ+/JfJck9QXzN8D50wU=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Harry Yoo <harry@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v3 0/4] memcg: shrink obj_stock_pcp and cache multiple objcgs
Date: Mon, 25 May 2026 20:39:27 -0700
Message-ID: <20260526033931.1760588-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 33DB01C0007
X-Stat-Signature: 577gn8bdt9mrkf8pm1wpqc1ecbm1ymmu
X-HE-Tag: 1779766783-888421
X-HE-Meta: U2FsdGVkX192IoB8ZR6m52zMXArO6ZsPzlUFQEhWnrFUUKF7eyAGDbVpfWtBfA2wPE3Ix7SG9m9jDZCFbo2ehI2dr1klAs3ybg78qqZFVnNMrDW6EtBg94G/KYVARZoWa2ddwfbEgdnyQurdreL1ft7pfon38C6oqc9lCyPcsltSzxKbT18SVJtDIJC1xm/jWyOdULHTd6VNqm41a1HQxON0XEXwQffGE8neyQuEf4igBXTI7pxiun4OdHrZSG+Md89u4QTCHGEf+5DQMf74O5JETd8qmRrny0saw7GVlGs6V0Hqyg7WMb2kYiIII1Q3eGK54cPRz1VavbzjZ8m5iMRN3qzEJPOwm+lNBZFJHwrxo633UklNW3hmUDkoYSDTFyXpgtWEKIPf+wNHLUhmeRLu6grqfPQonYYBUbOuQoL57Lhik5gejKNBO8orwhYYYuosMA9Aaxp/9ZELwpVIuJEd48ZRpH1lpWol5NqHosJJqa4As+4pr6i7sd5LaV+RGM5QcDBDIH7vULYZw3tNZGgYCWKKiuzcW2R+Sn/m6Fo3ey12K/xQkbi1dqjBlW5SJmSeWwrihoVf7Pvq9Hu8I2hV7lvdsgfmm1NxkwvXmQX104O7GNfbv30ECgvcVGiMm+bppAKTzMhJduj1B5CAUbJSCn/8GmtClExYtthcF3LxsMoQjQBTSJUEe35hhGgkg43wD4NDGFzIpU1reRxvhHj4adZeoC2e3GiUxzo7pjFwZnAZcD9GYgqDEf4yNnzwwJk9iCMSaMq6XgTP6Hd4X7XFzUCMLhDuJhu0/lfxMzZD/25G6AjgLCJw/G+oan/a/3R+KK569WPxOh4r7Gzjl2KN2fgO+X0RiaFh30t2Bhku/WbEdl0MwWPwCle5asF/C1kCA0YKv8rs6F0Fz9nqF4o5yB/Q2cf/zm4e0TpN2uAJpr8/tB7w3Tajb2fGdUHrosYPKFx0SqYYqJtB2DG
 7YSZlQ7O
 1VqGv6tkLcTsWtjGxZjWKcQs9PVZDASJgWGNNlP3LfpDVRQYLy9s/E7RdkaseoHwT1w+sKWl0K6dVi57gQ7e0EXpn5c6WItiel2ACPBWkEqosO4Z1mXWrzsI+VPfKFwyjyFgcb/VXkf3OGuIQhiohOHi8398FLLNRZ15IeQC6Am/x8cklmxGCC2RUBkYGenYohUqmEcH9dy1fo7rhh+StJutd7qsVehBd4EPOr8e9UX38vBYAE1+A/whgSFQG7gL1rf8c7ujjTUL9G/7hYncqFVorxRvaoZMKd7pF4bNLimEQcRwFPJfNiPD99YWB1zXNQ4Nl4x+HWCPNH0d9nrtHfdZqN7rz/RrOClfHJw9lnlnQxcQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
per-node type") split a memcg's single obj_cgroup into one per NUMA
node so that reparenting LRU folios can take per-node lru locks. As a
side effect, the per-CPU obj_stock_pcp -- which caches a single
cached_objcg pointer -- thrashes on workloads where threads of the
same memcg run on different NUMA nodes. The kernel test robot reported
a 67.7% regression on stress-ng.switch.ops_per_sec from this pattern.

Commit d0211878ce06 ("memcg: cache obj_stock by memcg, not by objcg
pointer") landed as a temporary fix by treating sibling per-node
objcgs as equivalent for the cache lookup, intended to be reverted
once per-node kmem accounting is introduced. This series takes a more
general approach: cache multiple objcgs per CPU using the multi-slot
pattern memcg_stock_pcp already uses, so the per-node objcg variants
of one memcg can all coexist in the stock without ever forcing a
drain. The temporary fix can then be reverted.

To avoid increasing the per-CPU cache footprint, the first three
patches shrink the existing single-slot obj_stock_pcp fields.
The final patch converts cached_objcg and nr_bytes into
NR_OBJ_STOCK=5 slot arrays and reorders the struct so the entire
consume/refill/account hot path fits within a single 64-byte cache
line on non-debug 64-bit builds (verified with pahole).

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Tested-by: kernel test robot <oliver.sang@intel.com>

Shakeel Butt (4):
  memcg: store node_id instead of pglist_data pointer
  memcg: uint16_t for nr_bytes in obj_stock_pcp
  memcg: int16_t for cached slab stats
  memcg: multi objcg charge support

 mm/memcontrol.c | 214 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 157 insertions(+), 57 deletions(-)

--

Changes since v2:
http://lore.kernel.org/20260522011908.1669332-1-shakeel.butt@linux.dev

- Fix comments (Muchun & Qi)
- Simplify code (David Laight)
- Fix handling of archs with base page size larger than 256 KiB (Sashiko)

Changes since v1:
http://lore.kernel.org/20260520053123.2709959-1-shakeel.butt@linux.dev

- Collected review tags (Harry & Muchun)
- Fix comparison operators (Harry)
- Use round robin for drain

2.53.0-Meta


