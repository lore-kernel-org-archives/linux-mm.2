Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A84ACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 05:29:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4D496B008C; Wed, 20 May 2026 01:29:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25806B0092; Wed, 20 May 2026 01:29:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 913A36B0095; Wed, 20 May 2026 01:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80DD16B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:29:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A3C08AC1F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:29:47 +0000 (UTC)
X-FDA: 84786671214.11.CBD1161
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2224A1A0004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:29:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oOdT9Qjk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779254985; a=rsa-sha256;
	cv=none;
	b=u2rHximdde5Dn9fTRWtfXcwrX0eTK36aWth0FUqbiQF65qYKKXIXlDF4JADUszM5V6DdiK
	WpRN/qVeML5CcFjhUlSelbwq7dkHDvvAd/gQOzDL3ayI4WcVHP+eeTszAKJBNfmHXreLEi
	HbStSsTJN6CSV+Pmxpe98B/yKP8gGIs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oOdT9Qjk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779254985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=w9644gpBoOdPB14uQ67yzVOzo6y2pa74KkqSttfHrQ0=;
	b=a0+bH5sNmrbDJzjRvCmc3AnweO/9Z66MX+uec2ffOMnJUHpQ3RCsTo1AlXFMPy5FRNH2N3
	dSO0/l9Rm87P1n4b1o6orSjH5b1gkVLzRczb9BgJREd2uISLJ+WIlvsIPe8Sbu0UCX5lLu
	naqBeGeYT2zn6KdQh5BLGRbdiRzdo3c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779254980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=w9644gpBoOdPB14uQ67yzVOzo6y2pa74KkqSttfHrQ0=;
	b=oOdT9QjkNL+aTBjlLReLdJ3EnXS+dfmLSkf1hJvCfaJRXr5TbQqGqYmnDT4sm8Vlg+lrJa
	ZBbuCyt9/riSrBjJHV7ewel8MUcet5SG9UxkNLjIfMGFZI3EIZVKm3q0Ge9ITu96Q6lVLE
	y+hO0sIKpsKasqvqEjtX6/uwcii3Mcs=
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
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH 0/4] memcg: shrink obj_stock_pcp and cache multiple objcgs
Date: Tue, 19 May 2026 22:29:00 -0700
Message-ID: <20260520052904.2673675-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: nn99nc3wtu8isqsgsde5icrbka5bkebd
X-Rspam-User: 
X-Rspamd-Queue-Id: 2224A1A0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1779254983-893274
X-HE-Meta: U2FsdGVkX18BPv8Jt3tocs3aevFknDRj/c/CTnGfZbbzx5GQvlz340PS3fQMMZKpQ8MKZdFSgIlOQeyUZvaS2x4qELImILLe+l015qWtPB468Gdpt+OWThL5b/oO36LwLDb8o05haE5i0Ql49D89uyLGVRazTQ6edeoRl3jlZwf6i2bXK40+Vpw2vMtlBwqW8BwmxgC8b+UQh6ENbBSdUyDpK+JeD7iHROLFqJ89UBstCdW2UceEbr/yNQmFz4mwGFK42qfbv0UacpvDik1HPG/Km9bwzHf1f4+uY97u8NHnnu09fRDQi/b2E7RScCkIeDpwzwhKs2VKWQ7QZCWMdswtxWiM8CFnpGuPeDQ5Mqu/hXiBKGdfLdrv2aV+U/tRn4Z1WyJTj7obFQqlAbZ2gYiPAlyhkWmEQLHhm8Tzz1RcvqRYE1/HC6d7ozu1Y2Kb8r/N8UweTh+SIAIb3IibLKJMX7POY7ic0yZYiY6NsaCjpbVt3olO3N+9nv8V6UGJ18Ye5vYPpVFfoK1TRCFJeQUP0Lb+qiudBCvbOY4u9xRWsPTE8dC7TAjD/Hc17nnhyXYpC4zBF+CvrXS+l5CZWh/wfqV+eRlEem0oUczsAE+7QuLDfuL7ei0D938qodsvNlgfm9tNl+9C2k7XOsl6q72Nq7l3SHgw4sGeRA1nDJfs7UtiRFDAAasipQaDs/5ershc2nlRK/2mr24hcS60kV1FIRbO8KxU023e5ccN4ptYOGFe8djeygtv8z0IahQLhtQiq6MTuGMtT6LL5iZ181yXLk1zQZlj6cEzkNnMov0pp91lqfbEsLE+u8AQP+XpDTA0MZwQEZJKD8D4LADbIbjEbpi1AB10LlymFhvPdh2IWz4XUzOxLRk/pJ3XntL0BM5ip4Hg62NM383MMiFH3K6YgmPN8KpKE6vxVHtNKYIFkxmDxFIv1dOtMQ/0U4i0o86dIfVOOtE2vsbjfme
 RDJaHwkj
 cnWJDVBUohLtWaCJ/t2Q8YlOWBwiTvtKZ7n/mrBr3ovMRJHzxqvGafKtuNADvbnDb6085FSQfgIZEf228Vaap19PqTcCIL6T+IiI9lP2osF20LeULbLe8T35E/GfMMcb44hgUHrsWgnLSlvuihoDziiSg+iOGT2Qe3UDCMsmdSNPBqAyVMBb+gMcF2OPlq/pXbczUJbhTEsJUccnio62dbk/rpefUyabREwQcncge9NMT6ZqtmFQCe00ON4KJyex1cGkvPTfa0TxU7iRTQikgHUW2OvL96WfmTuacWulrAT8s+N2KZ+w/8LNKP2HOiYC6XticH0xcVQ8lxhM=
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
2.53.0-Meta


