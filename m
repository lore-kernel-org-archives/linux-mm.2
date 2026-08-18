Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20907C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 02:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E2AA6B0129; Mon, 17 Aug 2026 22:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094196B012A; Mon, 17 Aug 2026 22:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC4186B012B; Mon, 17 Aug 2026 22:34:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD96D6B0129
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:34:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B0C1C0A72
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:34:32 +0000 (UTC)
X-FDA: 85112821584.11.DAD0922
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf05.hostedemail.com (Postfix) with ESMTP id E867D100007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:34:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787020469;
	b=gEXFaPiYf/v0Rg73hQ6pPW2o5o0vuYHJ+JKU6fEgit+wW99F1iV30lAw2iV5PEbDGJWK4A
	3gORIOhURBgMKnhl77EEXf412fPrw/n22ovqp9ii7c9N9iWEfNA2Wg8Kxc4V46MxXBj/Dv
	5ZQ+7Gle70aUaIPzjyQSmVm8Jlo38rU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787020469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=8JNaTats77r79W69MPDc10pA6wEGDMVhdlWzBH6wAjs=;
	b=yUHb9kv+Eeo4FiDTUwVV3DKNoiLqlt2eDAPVk0dDP9C9idT5FHvKA//SEJPU2pZVccuBGe
	ABEdv/ruSGZEocsclaintoWUzTDb17n7RHNqcov1tG2bhSCR5H9ujUMEujRQc+7DFOV7wF
	E2gt0OB1SfyC/Dt5Cbv+nfwyFFK+i0k=
X-UUID: 508344ca9aad11f19a56ed5b684f684d-20260818
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_SJ_DIGIT_LEN
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_C_CI, GTI_FG_IT, GTI_RG_INFO, GTI_C_BU, AMN_T1
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:54965268-4203-4b57-b4ff-b1cd1b4b2efd,IP:20,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:20
X-CID-INFO: VERSION:1.3.19,REQID:54965268-4203-4b57-b4ff-b1cd1b4b2efd,IP:20,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:20
X-CID-META: VersionHash:7db8b62,CLOUDID:f6d94200ad9876474a8648ca9f656496,BulkI
	D:260818103421R58TZA7K,BulkQuantity:0,SF:10|66|78|102|123|127|136|850|865|
	898,TC:nil,Content:0|15|50,EDM:-3|-100,IP:-2,URL:99|1,File:nil,RT:nil,Bulk
	:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,
	BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 508344ca9aad11f19a56ed5b684f684d-20260818
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 896177119; Tue, 18 Aug 2026 10:34:19 +0800
From: liuqiqi@kylinos.cn
To: linux-mm@kvack.org
Cc: tj@kernel.org,
	mkoutny@suse.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiqi Liu <liuqiqi@kylinos.cn>
Subject: [RFC PATCH 0/8] mm/memcontrol: introduce per-tier memory accounting and control
Date: Tue, 18 Aug 2026 10:31:13 +0800
Message-Id: <20260818023121.100613-1-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E867D100007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: czktdmdzptpk7w4oqnqqhjz1rdksdako
X-HE-Tag: 1787020468-951536
X-HE-Meta: U2FsdGVkX18Uxuhp2ar6wGX3v8DMNfqu3la0GUfe/jVdoxdzFuaVBs5CB4pkoONb8CBf4go/WfildrFzvL9nbN7XDnrRaqyDij/OsTnvtzbnX73FojHdvVfBYXYeN3+Hy2YF/arevUhSeof/MUa7k8fRwVpqldF4RSm5GiCI0n8IYzcLq8v7PUt1q0HSd4ffhu5KC2FUIMspiyu2Vwwt2VrMv4GLwvCpomtCsD+swmkHHcKr5kIDh/lGBqE5DgbfEo+bhyjrnbEnX009GNBOyjTMLz6b3E6MmV3PgSQut7kGybKmmBVtKLbFcDgA44NBvJp8n7ku7oPTgYHbEq7Rh8OGMMWtSsa15se5zMJvTtKfiGc9V0W9ZqRPs7Zk6qYi2DBQx3GBiM2rS7vCJ4hd+dArFlOHU8DDZvOAz4B6m65RgyFpM1bvF38PorRI0y1u9EQSARLlkBS0uM9u+zdcfHKFeFRbz4LoKlOhHQBHrqyQZG1LXpvl2TLrIkYoHJqwlvdgjMwp0MnVE5p7IeEig+qwfCTQviOO+nDqAru0afjbTdSGGjxgK4EM68a3nJJZUZgtW8LE22DdPAr45OetiQraqJgXdRF0gIHomxJkje0/+A2deM8RZmpwArv3M9mMXvwvJvew9EQ71pfzYN8ftr/sbnv2T9SygGWOvzoHwX0tocWPJR7mr2YrlUkVbl0wHPHgGga5i7dimNjS6pH9hVj9nSVIJ3HO5lAV+/m06KQaJV4PxLzG0MYeUSAKtyOsPgpEJyyKV9r45m2U9du7JIa2/J55ktsOaUBae8Fc72hfNHU9DvDgfynH6xA0rxom31nCgPv078f9qWahVwow5PB9kwx+KuaKAGp7LYXH+5Ke6A0nP36M1+fL19F5Jz4NHTqoBi+NNPDoLyzLUjqm0f9UrtrLakg2h+EOh04mM8sEnes+G1rUf0sizEo09jlVNMYT/ujzz38T2sNv6AJ
 pWzbrFhQ
 cT6h/RCa6jCA8Z7/rUPJy7Td2AQ9EpD4AsdQXv0EvV7zCTezxzUe5F5wzeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qiqi Liu <liuqiqi@kylinos.cn>

This RFC introduces per-tier memory cgroup accounting. Each cgroup
tracks its memory usage per memory tier (e.g. DRAM, CXL), exposed
through a new memory.tier control file that reports per-tier usage
and accepts independent high (soft) and max (hard) limits per tier.
By default these limits are auto-derived from memory.high / memory.max
based on per-tier capacity ratios, and can be manually overridden.

The implementation integrates with the existing memory tiering and
demotion infrastructure. Per-tier usage (anonymous and file) is tracked
via dedicated page counters, and cross-tier migrations (e.g. demotion
from DRAM to CXL) correctly re-account charges. When a tier hits its
high limit, async reclaim is triggered within that tier's NUMA nodes;
exceeding max enforces reclaim scoped to the tier's own nodes, or OOM.

The feature is fully opt-in. When disabled, no extra counters or
charge/uncharge paths are created, memory.tier reads empty, and there
is no measurable overhead.

Why per-tier limits?
-------------------

On tiered memory systems, memory.max constrains total usage but cannot
express "keep fast-tier usage under X". Without per-tier limits, a
workload can monopolise DRAM, pushing other cgroups onto slower tiers.
This series gives each cgroup independent high (soft) and max (hard)
limits per tier, exposed and set through a new memory.tier file.

By default those limits auto-derive from memory.high / memory.max by
capacity ratio; writing memory.tier pins a tier.

This series takes a different approach from Joshua Hahn's toptier RFC [1],
tracking a separate page_counter per (memcg, tier) for N-tier support and
exposing writable per-tier limits under a cgroup mount option.

Patch structure
---------------

  1/8  mm/memory-tiers: add node_to_tier_id and tier_id_to_nodemask
  2/8  mm/vmscan: add try_to_free_mem_cgroup_pages_nodemask
  3/8  mm/memcontrol: add per-tier page counter infrastructure and lifecycle
  4/8  mm/memcontrol: add per-tier charge and uncharge
  5/8  mm/memcontrol: add per-cpu stock for tier charge/uncharge
  6/8  mm/memcontrol: add memory.tier control file
  7/8  mm/memcontrol: auto-derive tier high/max from memory.high/max
  8/8  cgroup: add memory_tiered_limits cgroup mount option

Patches 1-2 are infrastructure (helpers in memory-tiers and vmscan).
Patches 3-5 add the core accounting: counter lifecycle (3),
per-page charge/uncharge (4), and stock batching (5).
Patch 6 adds the userspace file. Patch 7 adds auto-derivation. Patch 8
gates everything behind a mount option + kernel cmdline, so the feature
adds no measurable overhead when not opted in.

Usage
-----

Boot with:

  cgroup_memory_tiered_limits=1

Or remount at runtime (affects newly created cgroups only):

  mount -o remount,memory_tiered_limits /sys/fs/cgroup

Per-tier limits and usage can then be read from and written to
memory.tier.

Scope and limitations
---------------------

- Only LRU folios (anonymous and file pages) are tier-accounted. Kernel
  memory and socket buffers are not yet accounted per tier; support for
  these is planned as follow-up work.
- Per-tier memory.min and memory.low protections are not implemented.
  These can be added later by extending the per-tier interface to
  expose and enforce min/low protection.
- The command-line parameter mirrors cgroup_favordynmods; automatic
  enablement via the cgroup mount path is left to userspace.

Testing
-------

Tested on QEMU with fake NUMA (DRAM tier 4 + CXL tier 22), with
cgroup_memory_tiered_limits=1 on the kernel command line and demotion
enabled.

Set up a cgroup, apply per-tier limits, and run a memory-intensive
workload:

  $ mkdir /sys/fs/cgroup/mycgroup
  $ cd /sys/fs/cgroup/mycgroup
  $ echo "tier4.high=200000000" > memory.tier
  $ echo "tier4.max=300000000" > memory.tier
  $ echo 1 > /sys/kernel/mm/numa/demotion_enabled
  $ cgexec -g memory:/mycgroup ~/stream --ntimes 5 --malloc &
  $ cat memory.tier
  tier4.current=296488960
  tier4.high=199999488
  tier4.max=299999232
  tier22.current=1625464832
  tier22.high=max
  tier22.max=max

DRAM (tier4) usage stays under tier4.max (hard limit, no OOM) but exceeds
tier4.high (soft limit, suggesting that async reclaim is in progress);
CXL (tier22) absorbs the overflow via demotion.

Also verified:
  - tierN.current tracks per-tier usage (anon + file).
  - Cross-tier migration (demotion) correctly re-accounts.
  - memory.high / memory.max auto-derives tierN.high / tierN.max.
  - Manual override (writing a number to memory.tier) pins the limit.
  - Tier max enforcement triggers reclaim scoped to the tier's nodes.
  - Feature fully off (no mount option): no counters, no charge/uncharge,
    memory.tier exists but reads empty.

Open questions
--------------

- Should kmem/slab tier accounting be included in this series or deferred
  to a follow-up?
- Should per-tier memory.min and memory.low protection be part of this
  series or left for later?

[1] https://lore.kernel.org/all/20260423203445.2914963-1-joshua.hahnjy@gmail.com/

Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>

Qiqi Liu (8):
  mm/memory-tiers: add node_to_tier_id and tier_id_to_nodemask
  mm/vmscan: add try_to_free_mem_cgroup_pages_nodemask
  mm/memcontrol: add per-tier page counter infrastructure and lifecycle
  mm/memcontrol: add per-tier charge and uncharge
  mm/memcontrol: add per-cpu stock for tier charge/uncharge
  mm/memcontrol: add memory.tier control file
  mm/memcontrol: auto-derive tier high/max from memory.high/max
  cgroup: add memory_tiered_limits cgroup mount option

 include/linux/cgroup-defs.h  |   5 +
 include/linux/memcontrol.h   |  26 ++
 include/linux/memory-tiers.h |  12 +
 include/linux/swap.h         |   6 +
 kernel/cgroup/cgroup.c       |  21 +
 mm/memcontrol.c              | 786 ++++++++++++++++++++++++++++++++++-
 mm/memory-tiers.c            |  58 +++
 mm/vmscan.c                  |  26 +-
 8 files changed, 936 insertions(+), 4 deletions(-)

-- 
2.43.0


