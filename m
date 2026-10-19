Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21CBB606A33A
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=aTiAZMEt
Received: by kanga.kvack.org (Postfix)
	id 36E0A6B0311; Mon, 19 Oct 2026 13:23:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345A26B0312; Mon, 19 Oct 2026 13:23:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C136B0313; Mon, 19 Oct 2026 13:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 028E86B0311
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:23:52 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 795A11207CA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:23:52 +0000 (UTC)
X-FDA: 85340048304.23.8AE8B08
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id BA1F3140005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:23:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aTiAZMEt;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792430630;
	b=WwCfvASr26SiqeXOTcun+gZe6qd+Hzk2NDlfTdr0z6q83x8sPMwhv/dH2G3h3w3e8327zL
	CODfTb/PDoBIt1cExa24TPLFURgAgOq4opVNyQV0zZpQu2bkeIab3zIiHXsf73e3Rcffc4
	fAPh/mJsXSNxvHNU7OWDWcZj9oDqsr4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=aTiAZMEt;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792430630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FM3inNO3NvMJdWVpEEkpanyELpfwLSr0b1DWGRNHevw=;
	b=slqtqWKL/SIFufFhlbNpkWmCpLsLhimzT19VXRqLGEQ2cYvWPec48G0nWnlpVCEBf3qBpR
	F8tgZjuyuM9kIrTFyoz/XGs86tpLil8ILogH08xFso6Modk0C5ZW844kZcTETYWgHJHrkR
	636DzNKUhKnLTZ9HfoQDla0BQlqLMSc=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91befbcad6dso26234036d6.3
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792430630; x=1793035430; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FM3inNO3NvMJdWVpEEkpanyELpfwLSr0b1DWGRNHevw=;
        b=aTiAZMEt8siKomJdE8Vp5NB9B2HKs42seAq57YV/YY1Rnjd3CF+aE/qBkFV60Dh9Wb
         y9nf3+oWlqeuU2pFHv5Yaq06pC8eijlAMkrBNp5qmrpLyiOIzqIcNYzRQjOvHrQ0uza+
         d1O14frVjhT+ca2To3WKoD+Lv61Jk0bkq+yVNBr9F2SQ97SLC4bdP6vhNUpMqlzcBHW3
         EcLlW0kq5D1vLvs9Z2UGdCzzMUH1VhejBHivFiDlFs7TsmCcnF6dYgQlfQQZGPMkhXLX
         xjncXvGkVD96A4tyZtYWHS7ROlkIXH5L2fQJfONEkKcoB1F7zUWEXrGU9LkKTddTkHZi
         ChHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792430630; x=1793035430;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FM3inNO3NvMJdWVpEEkpanyELpfwLSr0b1DWGRNHevw=;
        b=xaYAkd3oGWQ4kH37BrE8LQWaVvT/qMROh+pdgH0u//Kdx4q9XPD+8RABqz3FtpNl4g
         3qgClbnNXAYriH+LejV692AGp7mhkeNRrQSR/d/Bjl0q+mTx3FbpmN3b3E4Yqq41jynQ
         qGS5qgzqe9KhWNV7LDQb/ggOeRR9v/cInJPhmjSAmaxlUy27NT8Scj+uvarxtMblUabY
         8/+hsTPPVsdu4aoXlgaxgZ9Lrsp6bDUvnfAtgLaw6XCrTUaqeLuPn90ZlYsYDD90YHUV
         VGifyG0PBQSVfiNnBME4qoOtEwXlVWLUTBgFcrcGedvhD8doMnI1X6+sEYa0TVRJojJI
         dlEA==
X-Gm-Message-State: AFq9FYKvtz+rOxwcdaBpnmDrGF7t98zAfe9ccjozTRt/Q60Aq5twT0wD
	UfVGnWwjIj4DthhYFL1r38cMhOPHeanzhC8zA+W9k1PkMkZE1aUxmnpV4ojolASFW4DubAn7RAE
	rtoNRTo0=
X-Gm-Gg: AYBFou00DCP7Tx9icSe5IfXomp8HL9dl822+YO7sYBPbPVZiZvCuytRL44JHUs8Ki+r
	ZZgaJVaDZf8P5d2eFaacL1i1O93IWzXi7kP+AP8UadLZyBCyWPEySnjPEYNiH3/ukbN61DecAo/
	5SC279I+LFYfiSLEYEzPl7S5Vnp1tiaJ73eWJf9IkgAxRE4SWYEnDKEUws5HxCFNmMosButuJ6c
	R3mzKDCuHJVdC4bdua9C2qnaV02igqXKOK+L5QVjNOWUgWT76WnNNhcAoiqnVP4rzwooBv6/ZVK
	XMKjwHD5O9mjSIrLGnGSywhz716QwKRFo6AQWlOPL94zL5Wp0yuR/pMRu3A9IaVeRczNHSllizM
	0PwUsjuYTjE2gp8LJuaa8KNaYNrjmVGyqmd1cg2tzV/upe+XADde53eNfiTysYzlJQs1/JHD8TY
	my+I9ik9NDIpL2dCIpgBiKzbo3DG1UYc2HuxR+p1Xa6ZgpFzQMxGkTO7xsRW7/eRpuh/4s0g/hs
	/kpVH3wgvvUSvXg3DADJuBTmOA3oOzgrMyEPHANPta6vPMovMM7+Wt3Ve+m
X-Received: by 2002:a05:620a:43a8:b0:93f:1dbf:6ceb with SMTP id af79cd13be357-93f29b74543mr1329416185a.3.1792430629865;
        Mon, 19 Oct 2026 10:23:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f4adb28c2sm14615385a.0.2026.10.19.10.23.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 10:23:49 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	mgorman@techsingularity.net,
	jiang.liu@huawei.com,
	Bessel.Wang@huawei.com
Subject: [PATCH v2 0/5] mm: fix allocator races with memory hotplug
Date: Mon, 19 Oct 2026 13:23:40 -0400
Message-ID: <20261019172346.3344005-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y515aciuy971bfe84agizps5hpq3dgun
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BA1F3140005
X-Rspam-User: 
X-HE-Tag: 1792430630-30834
X-HE-Meta: U2FsdGVkX1+umNHFRiBoqAKJRUvhckqFEcXTB7t9uIRXV4byJmEBKC11D+xl2rM2bCX47b92fWKRZm+Yo976OFFzVhyMnOWQSwSphwPJ7jruZUL+kS4MTeQypg6gRUito6j5uVZ2TAWhT/IZg8N/HADfM5bGbHX8tCpplhVkdp5DvJoS2YjzBeWzQaf2XrGjmlqlyqo7xpT3hnsyCdmZZRcqxTnMSQ85RxJi3Y7FGFbzpCoF45Hxkh6jrHKiXnnK/hPEDhi42FmzArbn8GjuizBlWin9jGqBNeHHhIrBGkbK5UHmHR8Nsb5AOpnYAtQwaCFqlE4dfxS9RwTwyj48qwC6zHo4AHJLN2og8wcvMmEEEbKpDMu1z4p6tv4aRqDRtAmLOSxrEYaocP6dvI8c+/mDzQY0+sul/2AJRASda6j/XtBuWczv8gGH0Yu2Z41Gg6ghe+8eXdZH7JA05Gu9DTtI4W+qG17yX1EzRIpUW9YHhfv5FRdtlgyh3I2E2h8TRxL2Be2UwkckwFiSY+932TjhhqqdJGVGYq1PA/ABLxcOkO2L1oqM4aGOquAWHDUVPxYX1XfdB2xTvTiTCoipvUtBXnysqGJnbM5vv+8BmK9AEJLiVu2ylXXBED09BNTiblm9WZbg+I2hAJNHyAdHm8x6gkU1hgjywBrHajrfMOkf69X4LHa/J+vNFfj6GqaZic/v4fPkecNQLlv6RgcikZ2FwkMgPC8Ovc0VCFzC1yyu2Vgj0oL0i+MHt+/8Y+Dr6h9UxbWGX+P9Bfz2ZqtR7my+jYXHe2aUZwfasaupA2kodb3LRyKVX+/Abj6qwKlXDqhkGLCaUsve/RBULSb+XLgrbSke4RPxaxIOeGs8TtE6iV34KnycHaq9Dk/xPGiknDHVTWOtdpCOYf7Kf/tN2GTfspGQVESKHkM8CllafV6VBUdoRnx0Db4YOj80DZR9VdEzsWqEb+semqCvJui
 gp4MCA8k
 5b+L5t7DhgUhUeB4KRUdtfb4cb4rMWAPOkQqsP6Ok3Yj3K25ALcD6ewNFHma2tdJTqRFG6f5o4tX3ntgtFvSn/X9+XICx7Z9RDS5J7bSoBiLqR22tbZgSFGG22jOX7QF06YbU8KcQYdn+eZ+XFTJwnDhxSGZXTLw2uAx8GpSJR1cCNvAFLa3RBNA9Ljs6XexxrF86Yiud3D2I6GY/FPwNR3gxbiZaeaXfOl2DUN0jxVU8iqZ3T5JsEba9b6JTwopsBwn8+sMds6LucSx7stX3lcdpUvMIU3/lV44rJ3YUuWtaWG8DrsevEQdaN8Y4EArrVC0LGTIsstUKYUq4aWtIwg1d7ntRg/hTDBL8D6CjS1nLnBR+YaMfEHK6yVWisK+KEo4KxX7x4v4Pv6jO8LR8c1A3vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Five fixes for allocator paths that can act on state another CPU is
updating: zonelists rebuilt by memory hotplug, and the pagesets of a
zone that offlining empties.

I've packaged these together because they're all related to hotplug
in some way, but they may end up backporting differently.

Patch 1: the zonelist_update_seq retry is compiled out without
CONFIG_MEMORY_HOTREMOVE, but memory hot-add rewrites zonelists in place
too. A __GFP_THISNODE allocation that sees the list mid-rewrite fails
even though the node has free memory.

Patch 2: onlining a zone shifts zonelist slots under an in-flight walk,
so the allocator can use a zone its filters rejected: a GFP_KERNEL page
from ZONE_MOVABLE, which later makes offlining that block fail, or a
page from outside the nodemask. Without CONFIG_MEMORY_HOTREMOVE, it
relies on patch 1 to retry a walk that skips a zone and runs off the end
of the list.

Patch 3: offlining a zone's last block can move the zonelist's NULL
terminator onto an allocation's preferred slot, which the allocator then
dereferences in zone_statistics().

Patch 4: zone_pcp_reset() frees an emptied zone's pagesets while the
vmstat worker can still use them. The pagesets are now kept for the life
of the zone, which costs 320 bytes per possible CPU for each zone that
was onlined and then emptied.

Patch 5: __next_zones_zonelist() tests a slot's zone for NULL, then
reads the slot again to look up its node. If offlining turns the slot
into the terminator in between, zone_to_nid() dereferences NULL.
Current GCC and clang merge the two reads, but nothing requires it.

Reproducers
===========

All five races were reproduced on unmodified source in a QEMU guest
with three NUMA nodes:
   node 0: 3G, CPUs 0-1
   node 1: 1G ZONE_NORMAL, CPU 2
   node 2: 1G ZONE_NORMAL, CPU 3

And a 512M pc-dimm cold-plugged on node 1, left offline at boot
(CONFIG_ACPI_HOTPLUG_MEMORY=y).

Patch 1 needs CONFIG_MEMORY_HOTREMOVE=n to show the failure
Patch 5 needs mm/mmzone.o built with -fno-inline -fno-ipa-sra,
        without which the two reads are merged.

The windows are a few instructions wide, so I used a test module to
widen them with kprobes that stall one CPU inside the window. This
emulates an interrupt or vCPU preemption.  The vCPU preemption is the
more likely event to cause this at large scale with memory hotplug.

Patch 1 (zonelist):

  Online node 1's first memory block as ZONE_MOVABLE, which rebuilds
  node 1's zonelists.

  Stall the rebuild after it writes ZONE_MOVABLE into the first entry
  but before it writes ZONE_NORMAL into the second.

  On another CPU, allocate GFP_KERNEL | __GFP_THISNODE from node 1.

  Before: the allocation fails, 3/3 runs.
  After:  the allocation waits for the rebuild and succeeds, 3/3 runs.

Patch 2 (zonelist slots):

  On one CPU, allocate GFP_KERNEL with a nodemask, and stall it after
  the iterator approves its first zonelist slot but before the
  allocator loads the zone from that slot.

  Online node 1's first memory block as ZONE_MOVABLE, which inserts
  ZONE_MOVABLE at the front of node 1's zonelists.

  Before: nodemask {1} gets a node 1 ZONE_MOVABLE page and nodemask
          {2} a node 1 ZONE_NORMAL page, for single-page and bulk
          allocations, 3/3 runs each.
  After:  nodemask {1} gets node 1 ZONE_NORMAL and nodemask {2} gets
          node 2 ZONE_NORMAL, 3/3 runs each.

Patch 3 (preferred zone):

  Online node 1's block as ZONE_MOVABLE, so node 1's local zonelist is
  [MOVABLE, NORMAL].

  On another CPU, allocate GFP_KERNEL | __GFP_THISNODE from node 1,
  whose preferred slot is NORMAL, and stall it after it loads the zone.

  Offline the block, which rebuilds the list as [NORMAL] and moves the
  terminator into the preferred slot.

  Before: NULL dereference in get_page_from_freelist(), 3/3 runs.
  After:  the allocation succeeds from ZONE_NORMAL, 3/3 runs.

Patch 4 (pagesets):

  Online node 1's block as ZONE_MOVABLE, then offline it.

  Stall the offline before the zone empties, and stall the vmstat
  worker on another CPU (kicked through /proc/sys/vm/stat_refresh) in
  decay_pcp_high() for that zone. Let the offline free the pagesets,
  reallocate the freed percpu area with a known value, then release
  the worker.

  Before: decay_pcp_high() runs on the freed pageset, 3/3 runs. In
          1/3 the area was reallocated before the worker resumed, and
          decay_pcp_high() rewrote the new object.
  After:  the pageset is not freed, 3/3 runs.

  Repeated offline/online of the block, and ejecting and re-adding the
  only DIMM of a CPU-less node over QMP, reuse the same pagesets.

Patch 5 (slot reread):

  Online node 1's block as ZONE_MOVABLE, so node 1's local zonelist is
  [MOVABLE, NORMAL].

  On another CPU, allocate GFP_KERNEL | __GFP_THISNODE from node 1
  with nodemask {1}, and stall it after __next_zones_zonelist() tests
  the NORMAL slot for NULL but before it reads the slot again.

  Offline the block, which rebuilds the list as [NORMAL] and moves the
  terminator into that slot.

  Before: NULL dereference in zone_to_nid(), 4/4 runs.
  After:  no oops, 3/3 runs.

All five reproducers also pass on the series tip, 3/3 runs each.

Changes in v2
=============
- Added patches 2-5.
- Pulled cpuset patch out by itself

Link: https://lore.kernel.org/linux-mm/20261014222456.2318284-1-gourry@gourry.net/
Link: https://lore.kernel.org/linux-mm/20261015210539.3243563-1-gourry@gourry.net/

Gregory Price (Meta) (5):
  mm/page_alloc: detect zonelist rebuilds from memory hot-add
  mm/page_alloc: validate zonelist slots against concurrent rebuilds
  mm/page_alloc: snapshot the preferred zone against shrink rebuilds
  mm/page_alloc: keep a zone's pagesets when it goes empty
  mm/mmzone: read each zoneref slot once when filtering by nodemask

 mm/mmzone.c     | 11 +++----
 mm/page_alloc.c | 77 +++++++++++++++++++++++++++++++++++++------------
 2 files changed, 65 insertions(+), 23 deletions(-)

-- 
2.53.0-Meta


