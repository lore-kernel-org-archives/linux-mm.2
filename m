Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AB68C88E72
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 08:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3722A6B008A; Fri, 18 Sep 2026 04:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 323B86B0092; Fri, 18 Sep 2026 04:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 215246B0095; Fri, 18 Sep 2026 04:54:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EEDDA6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 04:54:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 724FDA05FB
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:54:16 +0000 (UTC)
X-FDA: 85226271312.02.EAFC85E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7ACE9100003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:54:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FnU51j/x";
	spf=pass (imf14.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789721654;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DmnsO9HTJIfp3DKlcWtfgZlRsYLo4mXtVi9/q7yi9SY=;
	b=zpZ+h+Tf41FvHJ564tB5yOvpKO1Govca1HwObvCdUExh2iYqmnXbbEy27CtrG9noLPwwC4
	kmS1JAENy2fwSlzkDJtgcQPRWzX912o2OKtAPiXtyhFQZkqaFCDkZwwNgFJTi0S0nC4jVU
	ctF7jcoio9WrpWNDG/gGW5BNx5YEjnM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FnU51j/x";
	spf=pass (imf14.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789721654;
	b=kHSorLtSE3Ew3RdS0OckWhycL0vaU+OVkDvwrSq7NWepZawu+a0jeb7Ky2YqTB/rWg/dJS
	lgAozegyXx6SCsWFBWflyHI88ftrqK+dTFl/2dNCx6bDuuWoY3AP7i79fbIS5r/fAWBgkB
	FRKsljFLkPaPIp5c54I5yetFKsF3jWc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AA6D340AD2;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76177C2BCB9;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789721653;
	bh=mc0laF+Rrv6F0Aaeni+B8Gm6Oo9raw0zuKM9XV7mPww=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=FnU51j/xdKl2Bd9jS81pJLDSJbsv0+AO/tOHCVG8h93o+xsAtENmzPnSJnOMOEhFr
	 5jSELTw1mXmk9LKvMqfWpgCJz39YqSyU2PGQEmzv3+O+/spaiqWh8uTuaaXWRcVhlr
	 qW0kG1x8Nrvwcvyq+RjNX2cBx2j6quuEJ9E/h/pduXHM3TAPX977EEkhinZINhjo+Y
	 97Y5HNloaiOXq83psrACudqL9YOBzHFZaghIcjEWNlOyo3cVPiOnuO3YD2Ypz82B/0
	 Woj2DI/EX2p544UL06hXuQMFhizPfBy3xz+DYPuUTtIx4eqgc92KoGsxz/C1XBfips
	 er9aeVMtwo+TA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C583C88E72;
	Fri, 18 Sep 2026 08:54:13 +0000 (UTC)
From: Jingxiang Zeng via B4 Relay <devnull+linuszeng.tencent.com@kernel.org>
Subject: [PATCH 0/6] mm: memcontrol: implement the memsw limit on cgroup v2
Date: Fri, 18 Sep 2026 16:53:40 +0800
Message-Id: <20260918-descriptive-name-v1-0-dfcfdd91b456@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABT8rGoC/x3MTQqAIBBA4avErBPGfoS6SrSwcaxZZKERgXT3p
 OW3eC9D4iicYKwyRL4lyREKdF0BbTasrMQVQ4ONwUEb5ThRlPOSm1WwOyskj65vO7PQAiU7I3t
 5/uU0v+8H6UmwSWIAAAA=
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Oscar Salvador <osalvador@suse.de>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: Jingxiang Zeng <jingxiangzeng.cas@gmail.com>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-doc@vger.kernel.org, 
 Jingxiang Zeng <linuszeng@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789721651; l=6623;
 i=linuszeng@tencent.com; s=20260909; h=from:subject:message-id;
 bh=mc0laF+Rrv6F0Aaeni+B8Gm6Oo9raw0zuKM9XV7mPww=;
 b=RM1zhgBseQSHr0NWSr6StBGrfeyxAy9ZtlO0U66cJh5jbRc835a/Ii+noHNJQfwMnFm0YmIQz
 3kxCptrTsXiDrNpFxH2oJREf2Wqq+ba18OFWloiXpNW+iH/KuuH/5V/
X-Developer-Key: i=linuszeng@tencent.com; a=ed25519;
 pk=6K54xRzYIRWqatrAPy86M4E0MsI92BVJBhXwz5NdC74=
X-Endpoint-Received: by B4 Relay for linuszeng@tencent.com/20260909 with
 auth_id=1017
X-Original-From: Jingxiang Zeng <linuszeng@tencent.com>
Reply-To: linuszeng@tencent.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7ACE9100003
X-Stat-Signature: g9xkrw5p8i79yxzmfem8emccto6ui17o
X-Rspam-User: 
X-HE-Tag: 1789721654-489083
X-HE-Meta: U2FsdGVkX1+krx1JWmcDZa3qFr5PmnqQccA8OzmsFPVvuRLzPfGMI1Mo/Tvd7c1fgKiIUq+D2fGe+z2meEyvvlScpmNMrmgqE+Dw4WUQFOJuJTjvCE8iF34mydV5WvXSa9o7RpacmlJsIFJxx21UdUczbvDOBCevkEp5RYLoZ1iPUIqeEU6ny7pBXKve67P2UTpvUAKa03UEahi6YcPN+vx/Vqw1bkh+h0md3ZWBbmBViGEjdXzI4CYrDZCacEZbRCc3emRhHzo64Ez58ZXIFh8S9JAYlrlj9cxfmzxhi1ZRrLYHCWWuEBg/P5mAQUnk4Rpcg3sHuMvAKAE9fcdpcciCr+l33bvIfMQkWDZz8Bp70Nhnm17IV8W0LEt0fTxS0Geh09m08h499O/v78qOoDALYcuRfgKUUZsbQFvUnU5zYVChQWLk0R+64Rx7w7bEaxc6PsOqlLUXWCxyaxLhXomPUAD6NwTvGcFrHNrheAga0/6XzjukXlv8Slcx0n4Ib15G2Sa106/Z3ZkC1KyGQWKpRamnBjcncxuXZAipDzB26/LGTrcQev4ttVhvlby6UDQKPJ9zZn2hbRRh8sBYrzkNY9a/9bQMUKRvzky5uIv6xAJpu+Gc2bOF5mthczPEYbgybU+BX9xg61T3AaiphNGLb6W+jmX7x3CSl6bGFhKA6tw78+PzSfOzlUZsXB3rKZ5QTfm9rFRZ93JGHSOzqz8TZ7korxDBaVwaeSeIC+5jDfmONGRgZGjEtwGGz+28AQUzoddHOsJb/twOPD0bFuUPBdbK6E3nDOW8MoxCVDlJQszSJxvRfB1/R1R/VMJo/FBvnY4AgQfj8UZtu8HNdmecITTKMrHW3tUjWq5llhqpqbdvn32p/toAHBYG+1hhCXk1yaKn0YriD7AShiFEN5O7DjS0o2yeBC8kgBCiKggB6/8tWFLFa2ji/hd6ep33ttZhip1mzdF0YmRTKBo
 McPRSgfF
 wz7oYhp5D2Hlgmfrp8CX5LctYqCr4LbF+UesuI9k5Gx4pFyxiVbNFrei0mP9nnPFSKMWmC030fTNhz4iOal8Bp9FWcDWC4dQwBiz75IstrAJfInPmtHqz2m8/hm6RgRExkxiSzyO8LGSBnmdPe61uwe6VGGP2B3T9suEh/5NKLoz3nBIUiB09KVL7O0ViRmCAb5uXxd8eVrrrU2Ri6ONpoISaP0nxIhl0XZnfBj7bhJ/EvN+tkwrN6D1iSMmGoQ1OOjNbGgcp37l4fNTr8gOb4IPbonVAR21f0OkpWPErW8NTPkAXXLZ/cq+/qUyGcJQXwfM+f0iVWHVnaygM8u6kFtR5MMo8ZGUhnZxq2jY/vj9a/2gDINiA4GZTVA/EVx2hM8ZJpL7GRFvQQX3a5nhN+QCLkYB6kZ7z2FBZb8V+sukM0AmFXDDTqkYoIfUM4NK7Z5x+C8ec52HbFe3bYvfRQz2uB6m/nDpj0lfN71xMxOT9kq+EqQlyd70mKXxNU+NNsiaAUxwvqfi9OEeFahxNY8ZmkgMf87oFeljT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cgroup v1 caps the sum of memory and swap through memsw.limit_in_bytes.
v2 only offers separate memory.max and memory.swap.max, so a workload
that has to be capped on the total of the two has no equivalent knob:
memory.max alone can be met by swapping, and capping both separately
reserves swap the workload may never use.

A container capped at N pages should stay capped at N once swapping is
possible, but with memory.max alone the pages move to swap and it
allocates N more; reserving swap per cgroup instead means guessing how
much of the footprint will be cold at any moment.  The combined limit
states the intent directly - N pages however they are divided between RAM
and swap - and leaves the host free to offload cold pages.

This has been discussed before [1], and the direction agreed on was to
track and control the combined counter as a proper v2 feature rather than
fold it into the existing swap knobs:

  My suggestion is to factor out from struct page_counter all the stuff
  that is not necessary for all users, and then have separate counters
  for swap and memsw.

  The protection stuff is long overdue for this.  It makes up nearly half
  of the struct's members, but is only used by the memory counter.  Even
  before your patches this is unnecessary bloat in the swap/memsw, kmem
  and tcpmem counters.

  Fix that and having separate counters is a non-issue.

and, on the interface:

  This should be new knobs, e.g. memory.memsw.current, memory.memsw.max.

Patches 1-3 are that refactoring.  Hierarchical protection is only used
by the memory counter and by dmem pools, yet every page_counter carried
it; moving it into a separate struct page_counter_protection, embedded
only where it is used, takes struct page_counter from 192 to 128 bytes on
x86_64.  Both embedders put the context on a cache line boundary (384 in
struct mem_cgroup, 192 in the dmem pool state), so the fields the charge
path touches - min, low and the four usage counters - share a cache line
with emin, which only reclaim recomputes; only elow crosses into the
next one.

Patch 4 splits the counters.  swap and memsw share a union today because
v1 only ever charges memsw and v2 only ever charges swap, so charging
both on both hierarchies is what the combined limit needs.  v2 hands the
combined charge over to the swap slot in __mem_cgroup_try_charge_swap()
and drops it again in __mem_cgroup_uncharge_swap().  memsw.max still
defaults to "max" and v2 cannot set it, so behaviour does not change.

Patch 5 exposes memory.memsw.current and memory.memsw.max on non-root
cgroups.  A charge counted there is held for as long as the memory
occupies either RAM or a swap slot, so reclaim cannot get back under the
limit by swapping; try_to_free_mem_cgroup_pages() is called without
MEMCG_RECLAIM_MAY_SWAP when the limit is written, and the cgroup OOM
killer is the last resort, mirroring memory.max.  Both writers keep
memory.max <= memory.memsw.max under a mutex, so the two limits cannot be
configured into a state reclaim could never satisfy - the invariant v1
keeps in mem_cgroup_resize_max(), including its serialization.

Patch 6 clamps mem_cgroup_get_max() to the new limit.  That value becomes
oc->totalpages for memcg OOM and oom_badness() scales oom_score_adj by
it, so while the v2 branch derived the ceiling from memory.max plus
memory.swap.max it overstated the reachable total once a combined limit
was set, and oom_score_adj weighed correspondingly more than intended.

Size effect, measured with pahole (x86_64, 64-byte cache lines).  The
split costs a cgroup one more page counter, and without patches 1-3 that
counter would be 192 bytes:

  struct mem_cgroup (CONFIG_MEMCG_V1=y)  2240 -> 2432 -> 2240
  struct mem_cgroup (CONFIG_MEMCG_V1=n)  1664 -> 1856 -> 1792

The middle figure is the same tree with the union split but the counters
left at 192 bytes, so it is what the series would have cost without the
refactoring.  On a v1 kernel that is the whole 192 bytes paid back; on a
v2-only one the three counters involved shed 192 bytes between them, but
the protection context takes 72 back and alignment a further 56, so 64
are paid back.  Counters that gain nothing keep their share:

  struct page_counter             192 -> 128 bytes
  struct hugetlb_cgroup          1344 -> 1088 bytes
  dmem pool state                 320 ->  320 bytes

Tested on x86_64 with CONFIG_MEMCG_V1=y and =n, each patch building on
its own:

- memory.memsw.current equals memory.current plus memory.swap.current
  across swapout, swapin and swapoff.
- Squeezing memory.max drops memory.current while memory.memsw.current
  holds, and a combined limit stops a 128M working set that otherwise
  escapes a 32M memory.max by swapping.
- Writing memory.memsw.max reclaims without MEMCG_RECLAIM_MAY_SWAP: swap
  usage stays flat and the cgroup goes to OOM, where writing memory.max
  swaps instead.
- Concurrent writers to the two limits could not leave the invariant
  violated in 600 rounds.
- A kretprobe on mem_cgroup_get_max() returns 48M for memory.max=32M and
  memory.memsw.max=48M with 2G of swap, and is unchanged with
  memory.memsw.max left at "max".
- v1 memsw.limit_in_bytes, and the v1 paths reaching the new NULL ->prot
  guards (css_offline, css_reset, lru_gen_age_node), behave as before.

[1] https://lore.kernel.org/all/20250320144722.GH1876369@cmpxchg.org/

Signed-off-by: Jingxiang Zeng <linuszeng@tencent.com>
---
Jingxiang Zeng (6):
      mm: page_counter: add page_counter_protection struct and init API
      mm: page_counter: track protection state in page_counter_protection
      mm: page_counter: drop protection fields from struct page_counter
      mm: memcontrol: give swap and memsw their own page counters
      mm: memcontrol: add memory.memsw.max to the default hierarchy
      mm: memcontrol: clamp mem_cgroup_get_max() to the combined limit

 Documentation/admin-guide/cgroup-v2.rst |  32 +++++
 include/linux/memcontrol.h              |  27 ++--
 include/linux/page_counter.h            |  88 +++++++++---
 kernel/cgroup/dmem.c                    |  21 +--
 mm/hugetlb_cgroup.c                     |   4 +-
 mm/memcontrol.c                         | 241 ++++++++++++++++++++++++++------
 mm/page_counter.c                       |  61 +++++---
 7 files changed, 371 insertions(+), 103 deletions(-)
---
base-commit: 1ed9cdd724d46119dd9adf0ffba2f2daaa3335ef
change-id: 20260916-descriptive-name-0cf0d5346bcb

Best regards,
-- 
Jingxiang Zeng <linuszeng@tencent.com>



