Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46CC9CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AF336B00F1; Fri, 26 Jun 2026 06:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35F7B6B00F2; Fri, 26 Jun 2026 06:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 227F76B00F3; Fri, 26 Jun 2026 06:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E597E6B00F1
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:14:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 661D0C1DCB
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:14:08 +0000 (UTC)
X-FDA: 84921653376.10.27F206A
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by imf28.hostedemail.com (Postfix) with ESMTP id 57A2DC000C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:14:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782468846;
	b=FzVArirVrbqOiJGBGvkoJRznpkuupL0mY0QxN+c8dPRBzac5DVAnp1NX9oIzdbc1V+eWuk
	X2ZfUIJUawnZ4/m2QXfeDZ2dkiVch8eSt16SMw5fTUvMgLESuko01f6KzQsHp+TKhiJXJh
	1w3wq3/jq1muItqHLmZY2grF0UceZas=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782468846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=51qIM4p1NvfZURtbRRB+90FDO1iGM4P1BpNeTkPJIsU=;
	b=BCYaATJKiEvaS8549K1z/n1SdsRuac353ltetgiPSHvcni3mF15aHdWkKbfnL6NGuhwrey
	D6M9eN0caUlLRz4AKEREOI2nPD9EZHG0CemGUqdrpG8k3ns1XwsddiMXArXsf15dJ6qUAs
	g3g3W7PwSX+2he8LryRf61Y+DzZCprA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 6D91820CCB;
	Fri, 26 Jun 2026 10:13:58 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	cgroups@vger.kernel.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kairui Song <kasong@tencent.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2 0/9] per-memcg-per-node kmem accounting
Date: Fri, 26 Jun 2026 12:09:27 +0200
Message-ID: <20260626101356.1599643-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTGmWD2fPyKDYNlhP4gTn9Rxo3haDH1OvFRHYwg3drCV4CZLvBEv9OczPZLwKS6J1xcDH0flBnn6daeBkaySaYZY+gpFW+i7m/KXEZ6Ws5xxe7LMmjQQa3yDT3WkW05+4p6RkYb/hJCZRk8b5v7/dmFEsZvET0Yc8fWC1Cv3sVxs1kVYYH3+u9xFCDABt+tFKkSE1lH9umelwQZS8QLxMNjRIy+/D65/rXWJjzLo+lV3PJnR+L5/MRZq0DjZ9KN7P/vxZCT5yv4V3tYsbVUbg027xGHm8Agd400V3SYgE/wKtjrtxm9XDjR8lcftVfj3cDfgX61TYOv4S5tgOvyO2vnsQhJtjIJqc6z0vBvpp+4eBBcK5y+n2PqLKXvOVFxg7dXRMrvtLZCrQOVMnUXvzGrGExdkQWGLFhgX/4d90CMXdj38yfHzB+tApYX/GIN9/bvCoE7CtYCU44SyeJvQy+SHG2nh+vHy0BbEkChajexlf4B5nPVOemNEmX3S5Kc837Y0x86Cz0cvw0FOlgQxuhfb+/RtrxKbyIEk1h/rhgY8iI8L/UgL9NLkS43rJqbVn87T6lY+xbAsBI2VMFIu7d3pRT4R3S88vYjIEBsh9Yf40ZqlMsZuvvrDFYBRlMNTjQwqvPDOspANmyf0OcnhuNmRWo4QXtUTIUj4GIa68/KRoA
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 57A2DC000C
X-Stat-Signature: kapg6b6753re18fdeou1pgfuwaq5wj34
X-HE-Tag: 1782468846-102760
X-HE-Meta: U2FsdGVkX1+FQmwa4EGik2aUkhOnSfmnFQ0FnQSm7fQwbs8lD6I5Zke168l38HynQKnAfV2C7emDJWljHM6smVCUv+kB/xixRfkkNDSBv/fe9uANSVgtcokV+yb2sn5P5rsohodX2rbtr35PhBuvBP88lEZcPQ6brehKU3o/rx0VbcyS3iqqUL516skPUE26qsKCW0R46tMjwv5qyIvw8Yl/zfC8f/B4N9SyjIgbCJGSOxO7aUQ4UifiHqq4cssiGrgigRFnACKurqKZU1ZwaiUW+uk2U+CHH2k4mIQ1mAlV6FkBTWGAncmDRaL+WrATO/+uBsDQRJCYfoO0wi9i6aV95X5Ykq/6UGQ2K76n7IGfSYzL/sLCdje3h73mjSyf5a3uF9eF0kjftfaVBZqatFWgI5Il7BCwH32QiwupqWtQVCNjXzE4iDSAIxPNdtcMN5RQC/pNpnIbbWX/Wzhi73WrlnF96Mw12L1sMSNrWv1MbvM30mGKdQ+ephHaNVavCD4V1wxmuXQ1Qy8bDFBH1uRKon0/BLKqO7/p+cECzymAIhAT964nXgcuXbHuc70pqe6RVne7otMvFC6mmPZsEGQnkTGVngduH0d2X2zVbdHMwa7bMghtf4I5qALf7DxuqpNAM4HPS4dJ9XxogBXjnRciF7mpHKxeS8dFTRdfObibYvWhWfOP563H9sN715v6XnDYyHhIH59EfetlHeSLEdXFlUe3XkYEMSA++8COxuFSmgYVf04csOOsp//Xd+Ce/skIx9SMi0vNcta+Fqb/hxS0HYQh2t/xsEskCZA8GwRgkKzgPZz9SHJUv7R2PJPRCdA21tWOU8bIoxmgoYk+Q0lOYMoRu8JmJWCF0M0FaAu14FhczXrZy00YTyCmJehllfKVZlw8RxXb0gu4Hr9R6V3O+T8Q7mDa/nN6xRh7XIxc7R+WEN9EKp+dQA1qvCwSOuZbng5OuRAV78WOrkk
 YHQdIy0B
 qSgtUne4hWPcGi/7KlwIbt90G8HJrTREJkCS8nDtmwvdH2EqgjQiNO4Ps9PBLM4u9K2DVk/SpNUwcXdU9AHoFS8EWMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is version 2 of per-memcg-per-node kmem accounting.

As asked by Joshua, I ran some microbenchmarks to check the impact of
this fine grain accounting.

TL;DR: There is a substantial impact (up to +337% on small percpu allocations)
on a benchmark that loops over small percpu allocations. On the other hand,
on a userspace program that creates a bpf percpu map, this cost is not visible.

I followed Joshua's advice and now this version batches the memcg accounting:
it improves the performance +337% vs +417% (v1) on 176 cores single node
machine and +153% vs 206% (v1) on 80 cores 2 nodes machine.

We can see that the overhead of this version scales linearly with the number of
cpus (the number of nodes being small). This overhead comes mainly from
vmalloc_to_page() so I have another variant (b) that decreases the impact even
more (+131% vs +337% on 176 cores and +86% vs +153% on 80 cores) but I'm not
sure the added complexity is needed so I did not send this version, let me know
what you think.

Performance
===========

All benchmarks run in a memcg with __GFP_ACCOUNT.

1) BPF percpu map create/destroy, full series vs baseline kernel (two
   boots, 176-CPU AMD EPYC, 1 NUMA node): the per-node accounting is lost
   in the BPF syscall overhead, the delta is within noise (us/op):

     size (B):    64     256    1024   4096   8192
     delta:     -5.5%  -5.1%  -1.8%  -5.1%  -4.1%

2) In-kernel microbench that isolates the accounting cost: a tight
   __alloc_percpu_gfp()/free_percpu() loop, __GFP_ACCOUNT on vs off on the
   same boot (ACCT COST = on - off). The dominant cost on a many-CPU box
   is discovering each backing page's real node (vmalloc_to_page() per
   possible CPU). ACCT COST by value size:

   176-CPU EPYC, 1 node
     size (B):              64       256      1024     4096     8192
      baseline (upstream)  +5.3%    +5.4%    +0.1%    -1.8%    -0.5%
      v1 credit (per-page) +417.3%  +182.5%  +68.5%   +21.4%   +16.1%
   a) per-node accounting  +337.8%  +141.8%  +36.1%   +11.9%   +6.8%
   b) per-page nid cache   +131.3%  +53.7%   +10.5%   +0.9%    +2.0%
   c) single-node fast     +12.6%   +12.1%   +3.5%    +6.6%    +0.7%

   80-CPU Xeon Gold 6138, 2 nodes (fast path inactive)
     size (B):              64       256      1024     4096     8192
      baseline (upstream)  +1.2%    -3.8%    +12.4%   +1.2%    +0.5%   (noise)
      v1 credit (per-page) +206.1%  +134.0%  +44.5%   +11.6%   +11.5%
   a) per-node accounting  +153.2%  +64.7%   +19.4%   +4.2%    +5.9%
   b) per-page nid cache   +86.5%   +45.5%   +14.7%   +1.8%    +1.6%

   (a) this patchset without fast path for single node
   (b) is an alternative version, not in this series, that caches each backing
       page's node in the chunk so the walk is paid once per page instead of
       once per allocation
   (c) this patchset with fast path for single node

Changes in v2
=============

- objcg lifetime: Shakeel's patch 1 now guarantees the lifetime of every
  per-node objcg
- dropped patch 5 and 6 since Shakeel's patch 2 replaces them
- fixed the number of precharged pages (the v1 formula under-precharged)
- per-node batching (Joshua's suggestion): accumulate the per-node bytes
  first, then issue one account_kmem()/uncharge() per touched node =>
  O(nodes) memcg ops instead of O(num_possible_cpus)
- single-node fast path: skip the per-cpu node walk on single node machines
- obj_exts metadata is now accounted per-node (walk its vmalloc pages)
  rather than charged whole to one memcg (Shakeel's main v1 objection).
- renamed obj_cgroup_get_nid() -> obj_cgroup_nid() (returns a borrowed RCU
  pointer, no ref taken).
- zswap: fixed the missing locking around the per-node objcg lookup (now
  done under RCU + obj_cgroup_tryget()).

This series pursues the work initiated by Joshua [1]. We need kernel
memory to be accounted on a per-node basis in order to be able to know
the memcg <-> physical memory association.

This series takes advantage of the recently introduced per-node
obj_cgroup and makes those obj_cgroup tied to their NUMA node.

The bulk of the series is percpu per-node accounting: percpu
"precharges" the memcg before we know the actual location of the pages
it uses, so charging and accounting had to be split. All other kmem
users (slab, __memcg_kmem_charge_page) are now handled directly by
Shakeel's per-node obj_cgroup infrastructure this series sits on, so
only percpu and zswap need explicit per-node work here (zswap support
is limited because Joshua is working on it in parallel [3]).

Thanks Joshua and Shakeel for the early feedback!

[1] https://lore.kernel.org/linux-mm/20260404033844.1892595-1-joshua.hahnjy@gmail.com/
[2] https://lore.kernel.org/linux-mm/56c04b1c5d54f75ccdc12896df6c1ca35403ecc3.1772711148.git.zhengqi.arch@bytedance.com/
[3] https://lore.kernel.org/linux-mm/20260311195153.4013476-1-joshua.hahnjy@gmail.com/

Functional Testing
==================

- Tested with a percpu kmem self-test in an 8-node VM (2 nodes with CPUs,
  6 memory-only). For each allocation it checks that every node is charged
  and later uncharged the same number of bytes -- including a CPU-less node
  that ends up holding the obj_exts metadata -- and that nothing is left
  charged after teardown. All checks pass. (The self-test module is not
  part of this series.)

Alexandre Ghiti (7):
  mm: percpu: fix obj_exts metadata charge size
  mm: percpu: Split memcg charging and kmem accounting
  mm: memcontrol: track MEMCG_KMEM per NUMA node
  mm: percpu: per-node kmem accounting
  mm: percpu: per-node kmem accounting for obj_exts metadata
  mm: percpu: skip the per-cpu node walk on single-node systems
  mm: zswap: per-node kmem accounting for zswap/zsmalloc

Shakeel Butt (2):
  memcg: convert task->objcg to a per-node objcgs array
  memcg: charge kmem pages and slab objects against per-node objcg

 include/linux/memcontrol.h |  23 ++-
 include/linux/mmzone.h     |   1 +
 include/linux/sched.h      |   7 +-
 include/linux/zsmalloc.h   |   2 +
 mm/memcontrol.c            | 286 ++++++++++++++++++++++++++-----------
 mm/percpu-internal.h       |   2 +-
 mm/percpu.c                | 108 +++++++++++++-
 mm/vmstat.c                |   1 +
 mm/zsmalloc.c              |  11 ++
 mm/zswap.c                 |  19 ++-
 10 files changed, 361 insertions(+), 99 deletions(-)

-- 
2.54.0


