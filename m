Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C52CC5B567
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 07:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3FEB6B007B; Wed, 12 Aug 2026 03:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0596B008A; Wed, 12 Aug 2026 03:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E06016B00A6; Wed, 12 Aug 2026 03:16:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD9F36B007B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:16:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1DABC1C0D67
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:16:49 +0000 (UTC)
X-FDA: 85091760138.06.35211D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 66E511C000A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:16:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jfUvDiAV;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786519007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtcFPckNRhnB0NSBekrVdrI1nx3c9jQI/qZ671uj+E4=;
	b=lKQp+VR7p/qNemjBS9X6mjyNy/3Kzad8caqDZ/pbBoBf8WaRwIAMm8Feosw9OMBi3+coJz
	svczQTkBf6fsrYIyfeBNChH//+QqtzipvhR1vv5UOdSn25K7aZUVea/YYB5rjqpaBhe+iS
	6FTCrEEfCEMiH9tB6u2B6WFED2NrbGM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jfUvDiAV;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786519007;
	b=JLaBiLdovb+zoVO458ubNgeh0ljBoLyGtcU3PE7flV2qmPMTjcCeZVK/95tUmycLmf+E76
	yCGjTOh3OfbNbt8Ezz5IVbv5zsi3DMFpVPahibmpjUGdJ2MQ3zCqhDR+plkNIW7ARkYnXF
	d8p7I1r6ueQg7FN5rvx2LwiVlo43+Fo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B48740771;
	Wed, 12 Aug 2026 07:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16061F000E9;
	Wed, 12 Aug 2026 07:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786519006;
	bh=YtcFPckNRhnB0NSBekrVdrI1nx3c9jQI/qZ671uj+E4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jfUvDiAVnm1uecPldZ04arCCOPdU6I/PZxFMo0pClK4MQsDI4iKIE5C5K9KMFNDlu
	 6xaw2tAerpjM5G6w9HoKl74wKXEdir3hoXDpCZPGxXtLK7UHqUEuPyM8bTiePZZMUu
	 0hks3MSHUKBu4gWTi6AIg6xePZgJTSZ7SG2/p8Dji9VI+wS75+WAikdMOc4BFFNoEf
	 tp+nzk2CCBcqsu5yRqKqJfE6VV8WeRbkj26YTBKK0OxDH4wnIMsRRJlsRkpw4aZ2Oz
	 6Ljd4L2kdI3h70rt1q1eQHSwharzCvN/2qJd6IXblE9VDP+0f84AFvQXKxpBB5MtjI
	 il/H9ZX9iGbIA==
Date: Wed, 12 Aug 2026 08:16:23 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Rakie Kim <rakie.kim@sk.com>
Cc: akpm@linux-foundation.org, gourry@gourry.net, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, dave@stgolabs.net, jic23@kernel.org, 
	dave.jiang@intel.com, alison.schofield@intel.com, vishal.l.verma@intel.com, 
	ira.weiny@intel.com, harry@kernel.org, kernel_team@skhynix.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted
 interleave
Message-ID: <anwcRyfzs5lklpzk@lucifer>
References: <20260806080936.421-1-rakie.kim@sk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806080936.421-1-rakie.kim@sk.com>
X-Stat-Signature: imknteeefb717imnusr7g7zarnn3mggk
X-Rspamd-Queue-Id: 66E511C000A
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786519007-897914
X-HE-Meta: U2FsdGVkX1/6mEpk2PT6cey+EpmQ1WeOzWilSWpCk4WDXMzy/rF4L+GXIc997hpA4hyfzGC3caTBd3j2zhQTFC+Tc7MK3iMaou3lXydl3k9dFF33JFfx9TvRL3wwufQIHvAaCVzvVgcxadVucc1mdGKpBlmIpk5+nh5AVV7jcGQ4EGjaCXR2/QXrd5NWlNA70THa0iI5YGoir+htVLDKAlFRJaoNIf+TbyeQ19PI6UVk5nM/kMd0wjPFwmDHqgjFgc350jqbw1CLPjsMkYCQ37YwHXMXIQ5tKCgUZ83QXBT0Ldg7aWgVdlM3jWmYBjRqABpIjA+DtCbyNvGC10LgqUKY0hqOo4g3WUgnAeUpjZSg1vXDHrHCRJnjQ8lMeRkYv5SkcslKV0OkAX4UYDpgKpcG3Z4vBk30eFuxKxXxkVN1dA4QnzfFGIhAc9cLsmGvoiTyVS0AQevBBy5XTm+Zq+adPgcbCAZfrUt6SlYHE6WcDFzvpiAG3qpUKsW4hluZNiv02HKYQm5brXoQhHsS18QTexBv7q9BnwN3wlSuWRNhjijpcNVYoUrwg5dcEz+qh2/Wk8ALoRyOOH7C5KELRehY9HH58bplK6wan9lYUqU5W2vqVvD/QkTkZt3Vl4AVaxoIE6NK9Dq1yd+6T5HuFTHHWTVBsmmZVUDLomO/MvodWmrlvcYez9tqA7El+xMQgbeWhi+M7aNC+b/gBZ5qodE0CFDlqQWG3Vh6zoyoqws23ivGbZHlAlWwy2NLRNsU/MdfrFaj3MEQ4WoUAys6E7Rxyvz4q+lxeus3EklxQDgMT+ywwd3Nn1LsamL6Di2tmSXVi1RjA8TJsHK1XU3bQLclmG4qL0qlo4cpbAXH+Gt0z8A2Rt/YXAKwFoqtmG4YZ04HOwAuy6eEI20NIAHwQhJMz5ESF+KsYneIlfPQjYKaEetgdARnMCvFEgCd2vaBooOPAwCVv4IuFyOiS0t
 VSnFuhND
 7aS7BXNSkcKeKVvOtOhVKmFJD6rb2mGCZCtCmBUiJumPDMkzdHgGe2W8PzEvfSYQzoGIzBu5eR7Wkg/cm9YQCIPemkz14A7O49+SI1wIDw9RqjsRBQ2I8dUZLaGq321uRfNjs781Vmg49B+WzkK9OE55F3nEf/rn3oETnGuiuqFEwceP1x9iT7Sscz8timgeZ7LiXcWoXK6zKqf6mRkBSTkf6h+ShQB3sVFVtPpPW6Ifj2LBVKTAwvyLvBmcH0Du/oN3oVkrK5SETGM6bKcmyja2D8exSpPus021kYUsCQqy3BSAaRCF/LTY+KN6d1y7MD65gupG+et++Dj+1BVzQ/G8v9OqHiml6YLsVhWZK9j9O8Xga6ZOJ9+AcfYbWdjQIX1WKJ2prj+iCz1gRk5LS9xFGrb28rXCOIUy7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 05:09:31PM +0900, Rakie Kim wrote:
> Package-aware weighted interleave places a task's weighted-interleave
> pages on the NUMA nodes of its local package, so that interleave traffic
> does not have to cross the interconnect to another package. This keeps
> each node's weight aligned with the bandwidth the task actually gets
> from it, so effective bandwidth holds up on a system that has more than
> one package. (A package is a CPU socket together with the memory
> attached to it.)
>
> Changes from RFC:
> https://lore.kernel.org/all/20260316051258.246-1-rakie.kim@sk.com/
> - Added an opt-in sysfs toggle (off by default) and a read-only sysfs
>   view of the package topology
> - Added topology validation with a clean fallback to plain weighted
>   interleave on unsupported topologies
> - Hardened the allocation, device-teardown, and node-hotplug paths

Please put change logs under the cover letter :) in mm we put the cover
letter in the actual upstream commit so it's better to keep separate for
reviewers.

I see the RFC was from march and tied to an LSF session I think?

While I don't want to be too pedantic, I think you should only really
un-RFC in a situation where you have a good sense that the relevant
maintainers are happy with the _concept_.

Looking at the RFC thread it's not clear that David was OK with this on the
mm side, though I see you got some feedback from Jonathan on the CXL driver
side.

So I wonder whether next respin this should be re-RFC'd unless you get
clear feedback that we want to go in this direction?

>
> Weighted interleave places pages on nodes in proportion to per-node
> weights that are set from each node's bandwidth. Within one package the
> weight given to a node matches the bandwidth a task sees from it. Across
> packages it no longer does: a memory node's physical bandwidth is fixed,
> but the bandwidth a task effectively sees depends on which package its
> CPU is in, because memory reached from another package, over the
> interconnect between them, is slower than the same memory reached within
> the package. The weights are set once from device bandwidth and applied
> the same way wherever the task runs, so a node in another package is
> given a weight higher than the bandwidth it can deliver to that task.
> The kernel has no package abstraction and does not record which package
> a node belongs to, so it cannot tell which node pairs are separated by
> the interconnect.

Please please - break up huge paragraphs like this :)

It's 2026 so I have to mention that if you've used AI to assist with
writing it (which is fine) please do a pass over it manually to curb AI's
tendency to be overly verbose + definitely try to break up paragraphs into
smaller charts at least :)

>
>           node0             node1
>         +-------+         +-------+
>         | CPU 0 |---------| CPU 1 |
>         +-------+         +-------+
>         | DRAM0 |         | DRAM1 |
>         +---+---+         +---+---+
>             |                 |
>         +---+---+         +---+---+
>         | CXL 0 |         | CXL 1 |
>         +-------+         +-------+
>           node2             node3

...though I _love_ ASCII diagrams so this is great ;)

>
> The numbers below are illustrative single-stream bandwidths (GB/s).
> Local DRAM sustains 300 and local CXL 150; any path that crosses to
> another package, over the interconnect, is capped at 100, so a node in
> another package delivers 100 whether it is DRAM or CXL. Note that local
> CXL (150) is still faster than any node in another package (100). The
> effective bandwidth each CPU sees is therefore:
>
>               node0  node1  node2  node3
> from CPU 0:    300    100    150    100
> from CPU 1:    100    300    100    150
>
> Since a single per-node weight cannot encode the interconnect penalty,
> a reasonable set of global weights is taken from local device bandwidth
> (local DRAM : local CXL = 300 : 150 = 2 : 1): node0=2 node1=2 node2=1
> node3=1.

Also great that you provide the receipts on actual observed real-world
numbers that's great.

NUMA isn't my area so I can't comment here on the technical details but
thanks for providing this :)


>
> Applied the same way to every source, these weights give the map:
>
>               node0  node1  node2  node3
> global:         2      2      1      1
>
> A task on CPU 0 gives node1 - remote DRAM, effective 100 - the same
> weight 2 as its own local node0 at 300. Worse, node1 is weighted above
> node2, the task's local CXL at effective 150, even though node2 is the
> faster of the two. The flat weights rank a slower interconnect-bound
> node above a faster local one, which is exactly backwards.
>
> This series makes weighted interleave package-aware. When it is on,
> weighted interleave prefers the task's current package: while the
> package's nodes have room, the task's pages are spread across them by
> weight, so allocations stay off the interconnect. The rest of the
> policy nodemask is used when the local package cannot serve the request
> - when a node in it is under pressure and the page allocator falls back
> along the zonelist, or when the policy nodemask happens to exclude every
> node of the current package, in which case the package spanned by the
> policy's own nodes is used instead. The nodes considered are always
> within the policy nodemask, which mempolicy already narrows to the
> task's cpuset, so cpusets and the task nodemask stay in control.
>
>               node0  node1  node2  node3
> from CPU 0:     2      0      1      0
> from CPU 1:     0      2      0      1
>
> A task on CPU 0 now places pages on node0 (weight 2) and node2
> (weight 1) at 2:1, which matches their effective bandwidth of 300:150;
> a task on CPU 1 places on node1 and node3 the same way. Placement
> follows the bandwidth each task actually sees, NUMA locality is
> preserved, and interleave traffic stays off the interconnect.
>
> To make this possible the kernel needs a notion of which nodes share a
> package. The NUMA distance model offers only relative latencies and no
> structural grouping, which is especially limiting for CXL memory nodes
> that come online without an explicit package association.
>
> The series adds a package-aware topology layer that groups CPU and
> memory-only nodes into a "memory package", built from the physical
> package ids firmware reports and, for a memory-only node, an initiator
> CPU node or SLIT distances. A package can contain more than one CPU node
> or more than one memory-only node, so the layer maps a package to a set
> of nodes rather than to a single node or a single CXL device.
>
> The feature is off by default and opt-in through a sysfs toggle. The
> package topology itself is exposed read-only under
> /sys/devices/system/package/; there is deliberately no writable
> override, since a machine whose firmware describes its topology
> incorrectly should be fixed in firmware. On a topology that does not
> have the symmetric shape the placement relies on, enabling is refused
> and any active mode degrades cleanly to the original flat behavior.
>
> Measured results:
>
> System Configuration:
> - Processor: Dual-Socket Intel Xeon 6980P (Granite Rapids)
>
> 1) Throughput (System Bandwidth)
>    - DRAM Only: 966 GB/s
>    - Weighted Interleave: 903 GB/s (7% decrease compared to DRAM Only)
>    - Package-Aware Weighted Interleave: 1329 GB/s (1.33 TB/s)
>      (38% increase compared to DRAM Only,
>       47% increase compared to Weighted Interleave)
>
> 2) Loaded Latency (Under High Bandwidth)
>    - DRAM Only: 544 ns
>    - Weighted Interleave: 545 ns
>    - Package-Aware Weighted Interleave: 436 ns
>      (20% reduction compared to both)
>
> A small CXL driver change registers a CXL memory node into its package
> as the node comes online, using the initiator the driver resolves for
> the region; this is where the package layer gets the CPU-side
> association that plain NUMA distance does not carry.
>
> The memory_package layer offers a broader interface for grouping and
> querying package topology - usable by memory tiering as well - and
> package-aware weighted interleave uses the subset it needs.
>
> [PATCH 1/4] mm/numa: introduce nearest_nodes_nodemask()
>   Add a NUMA helper that returns every node sharing the minimum distance
>   from a source node.
>
> [PATCH 2/4] mm/memory-tiers: package-aware topology management
>   Group NUMA nodes into memory packages from firmware topology data,
>   expose the grouping read-only under /sys/devices/system/package/, and
>   validate the symmetric shape that package-aware placement relies on.
>
> [PATCH 3/4] mm/memory-tiers: register CXL nodes to packages
>   Bind a CXL memory node to a package using an initiator CPU node.
>
> [PATCH 4/4] mm/mempolicy: package-aware weighted interleave
>   Prefer the current package for weighted interleave node selection,
>   behind an opt-in package_mode sysfs toggle that is off by default.
>
> Rakie Kim (4):
>   mm/numa: introduce nearest_nodes_nodemask()
>   mm/memory-tiers: introduce package-aware topology management for NUMA
>     nodes
>   mm/memory-tiers: register CXL nodes to memory packages via initiator
>   mm/mempolicy: enhance weighted interleave with package-aware locality
>
>  .../ABI/testing/sysfs-devices-system-package  |   35 +
>  ...fs-kernel-mm-mempolicy-weighted-interleave |   17 +
>  drivers/cxl/core/region.c                     |   54 +
>  drivers/cxl/cxl.h                             |    1 +
>  drivers/dax/kmem.c                            |    3 +
>  include/linux/memory-tiers.h                  |  113 ++
>  include/linux/numa.h                          |   11 +
>  mm/memory-tiers.c                             | 1009 +++++++++++++++++
>  mm/mempolicy.c                                |  200 +++-
>  9 files changed, 1439 insertions(+), 4 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-devices-system-package
>
>
> base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
> --
> 2.25.1
>

--
Cheers, Lorenzo

