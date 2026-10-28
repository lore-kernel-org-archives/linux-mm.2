Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA38F60A2607
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 21:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=oGUrJlXY
Received: by kanga.kvack.org (Postfix)
	id 003F06B00EF; Wed, 28 Oct 2026 17:19:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF75E6B05B1; Wed, 28 Oct 2026 17:19:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE5606B05B4; Wed, 28 Oct 2026 17:19:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7B836B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:19:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A17B801D7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:19:36 +0000 (UTC)
X-FDA: 85373301552.29.27D3682
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id E9FA940004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 21:19:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oGUrJlXY;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793222374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=H1inaUJqZMR0MYj0p8tMRX6+N//ATaZsUxxZwRk9wOY=;
	b=hIN1WKrbUQ95YIfRCFbU+kAsW5tJFTXzC7wliPwSjBuPNM7O3Foga0QqTyM6YvHjlARnUC
	cMGtLir+/mKV/bKddV+hTDeiRoy0pHaaOTC49DEem1mnWLlo+xTHyDYcLDSMvyWF+Q0dAy
	zW+XurtA/KxBB5Y4uSgH/H8TRVUionw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oGUrJlXY;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793222374;
	b=wtSfEp1WAb+uSgMp9oFqITMCdOxWlipoO5c68Ib8wWCotbj4pOSdgfee0lkOYWGvdAti+c
	9Iu18nd039dytTAZjpdcJ/1X07jrn5Y7dqU/Yfj/hSB9IFuF+pFNTMqj4yjK2jzx0XfaBK
	Agxgqnn857ckb9Z2wFJN/eyLuISc9Dk=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-53bb57f1310so17590171cf.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793222373; x=1793827173; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=H1inaUJqZMR0MYj0p8tMRX6+N//ATaZsUxxZwRk9wOY=;
        b=oGUrJlXYXflssSCQBxDGDh8xpL7+0Tvl9qRMhd9IdXGfx7AOyV/x1+MlNnmwQ7MyrD
         /whqf3JuCr9itSL5+GllvUfX+eg/bmUoM8HmisQ1pXsQOsp1h0xy7qqo0KxH2h0W5ZDC
         BJlXaMVCtwb/ehiji5f69VEEiUSffNz+zBnH78iDHJ3QYK/pMp9Yvx3D3RsCMbl0mJj6
         m7/hin/wueQZZiK/Oc1eIfvKeG7kxDD6doYWwOlXYd3vBXNhXyUwLtiTIcYUAAYKw6aZ
         avVTrxADaKKTJW0/azOQPCgUoETGviRSqb4AOpwz6wN4ZWQ1h+dCixB5+TiL3b4xr0V6
         wHEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793222373; x=1793827173;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H1inaUJqZMR0MYj0p8tMRX6+N//ATaZsUxxZwRk9wOY=;
        b=s06+GU35Jbirzg0WHHljbpRsaeQ1PlvraCmI15bFjyVXHCl1UX4iIlQoyaQzGclY7S
         NfAHYeE61ubSeA6E3HB+RqnYKjRNuK/Pvz9Oohc421UQ9gzteI/WXicNhS4GEmUl3cjC
         emKeL96iy+0t7A6ybJQydtzEWAxRHAlcfT7oP52/0eMPGJ/GswAzWY0wpoq4Ft+iVR7w
         HXMULl2iDs4PqB+BPmBiAAofblgIlqdRX6obvN+M1aXbfDPbV7shWjtUCzdUwgfetZze
         rrwqb6vAs0Zl+GcYTBFWlNCt+CMtds0aVFCUkp+XSL95XLxU+E7NCnYcJdKf5dK35d+V
         OuiA==
X-Gm-Message-State: AFq9FYIwB/TBbdxoY5tJ1M0oGADKA4V/kI54lwrqLcppxmTShxpWRj9I
	Spq32qLVW3dcwi68bLAsdGv95gYchV+DGZXc/ZoJhv9XstzRR5ptSvhOXIi0LE+CTOkzQk+iXgu
	WXMLotG8=
X-Gm-Gg: AYBFou0OJIfhb7xJmWqJoVbZnQh/BuzeJVSGhT/9Im2BdV8vJVvrW0qYUUuxG+tKn2O
	UGDUjpfdd2IfWx5vT+amVapVEF/756cC2oYOpNkk5rbQAr5TEm4hMiF1Nj5ND2yr7cYKVmeHPM4
	sJWJrOjnhnPeWdQYrDovl3Ejt4/FoWBnFjHia3Tc2owVIYLcFJcphMrRRwwmn9k5vewezL5Jmi1
	G1nyZaXOAOJn6mzbMeR+M/lbqzqEFKztNNgjdKfidOsC05PB6CGPtuQzDcgKGyY+L5CHY4BiNXP
	WX1hxhwUtABsOU0a8w/626piryH4DiCWOR8gLzYeJ9/jL2INLpxBcurOFSKJDjKh4qlrylguE7V
	/aLyjecnn7ODaY/ASAyGnJSn/zmY33YW32q4CwlPuYEjnYpmS5cuFaLsV9Fg16Rl9rtzrWkSULf
	fOP6+0etzx7sBhQOCtsXvscLlyMvTPZ0uPLpK872Sgo97zd1ILAGo7j7KrB8OFXlAjhxs4VdT/5
	8tH8y+BkKYpdlDQJHCfFqQGfI0MmdvMRMLOHrsSuN865sdEop9jjQ25vsTvq0wJ4rWu7XlJEjwu
	w9zxXmGqgS/Gpd5h1JEigRT6zrCCkDiEr6MS31CwIGZErOpcoIQKwC6l33V0j7yLNIijkbeA3eE
	Y+u2d3x6BuD4v0Ec=
X-Received: by 2002:ac8:5f8c:0:b0:536:9684:36b4 with SMTP id d75a77b69052e-53fcc3d0fd9mr62417701cf.57.1793222373004;
        Wed, 28 Oct 2026 14:19:33 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47a6d598sm139778966d6.3.2026.10.28.14.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 14:19:32 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com
Subject: [PATCH v4 0/8] mm: fix allocator races with memory hotplug
Date: Wed, 28 Oct 2026 17:19:22 -0400
Message-ID: <20261028211930.3504634-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E9FA940004
X-Stat-Signature: kyqkpubxipusbt96q75ehwaozpwszwz5
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793222373-852544
X-HE-Meta: U2FsdGVkX196sltcvK8vU/eZlsTSDmZRx67pkFHODOmilcYQdzA1MDdb2tB8jyqWGbH/LKLMQS4AXPQQbx9wKTGr54qR9qK0puQCDyrZjrbA8ngz2K8LqL2iytL0x4EYoPGZ6TqtLdriWh3o6p3oUw5ZN3I1YXr09pLF8rl4Q/hPK05bPXwuJ08JuYc8vIJlANo142tuEJnX4Ay8Pr4lZWpcdp+C5YUcutqGD0DW5NOWzbgdZAKAuq8XChNoT6cxz/uQVtbXAkjtGDJQydkwwA74T9jO2SP67deaAmW39HmMK/hMebFSqZRsQ4/P4iBGUb+sFlzgNcmunW8YAa6+Wj0Gb/lT+GXJjzWo/C50j1bZMWH/dADEcH2tP77R9MoRkB01uO0zdBAD9byjXd2vKgD3n6ccMxNed3NEGnXDMWch72q8IlxEnbbobZcyj5EOuS5zCr0ELRKNgMM6AoCz+6D350xcosD1A8Jgny91rELn+lGK+t26WI2XheCP9NaZ7YGjlBLdlT6MztkevGPRWBeTWTkkJboQJmN9iO988jNhISfaTyKeQF5cHZeB8i6bDXCtzu2vVYby94xZDk8C34WzUveY8B+CQaott7w/LJbB6skaROtm4S6dt5oHmiIVYsDLWikXvwstrwxNRP9arSr2Sz0EW++zpSoxYrmeY+W7iqaUI78CAD9LpZoj2bTFmKhv0F2NiOJRmltA6xmNVVIr2uhLSM8TDKLYO+BLB9lLfbnruvW2UVx0QaSmzexsHoY+msh83cJaf5qVbYKWEtCf43GYKSOwDy0T3GZ/LOJDg2HUIozIH06WCCVyxczPtecyqUz+4KkOk9B4gQ6moDIKCYTZ9dr0zNmbaevT4ZJKbwwZTHtduwh+Cs9JafkRbXZpeYFlHTF7MZjjOPe/YJ+dFZifN/a4LR8gOMIpveRnsfUvSHbUZZUcrRUgIhG8xEMZ9GUFZVGVLSmdrRV
 R0chT7I/
 Qtb5e6+6lUgxtwcqK7Oklo9hV54Fz63nHf1vF4vwVBqoI3M5na+2ggi0t1oQuZHGyeGPjQsAwk0Ml5NIW8PQj0Vt8gclO2ODsnoRHvnSvZJvVKayyQu5d6HjlpOglJ0Y53F0fZSpSJYqyGQNWZ6PSN3/6EfyfhufhR+c3mpgR3NHrVtP8EypVbsZkjUH6ssjaI41C2H6A3kg4V4uhH5aMZp4yGi7XMZal0NAk4wP2+CIdzWWNnwpDc7od/mija1YXvy38TaQTGr9EFarvbQSTSCFchbcfCArPG1VhuMy+1adkWkaqsRJQnYbiKv4yASNPDR2h1kfOZWdg0mO8t3ORz4hcP4sUuzDK+7Bif5AbilcXkNrtOeRwjFCesltLD/ZTeIBgaXOf4j3yzjIEFUEEuFkAnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Memory hotplug rebuilds zonelists in place while allocations walk them,
and offlining an emptied zone frees pagesets the vmstat worker can still
hold.  These eight fixes cover the walkers that crash, fail, or pick the
wrong zone or node as a result.

   1. a restarted slowpath loses its retry with reserves
   2. the zonelist retry is compiled out without MEMORY_HOTREMOVE
   3. NULL preferred zone after a shrink rebuild
   4. __next_zones_zonelist() rereads a slot
   5. allocations land outside their zone or nodemask
   6. the hugetlb pool walk takes another node's page
   7. alloc_contig_pages() takes a range outside its filters
   8. mempolicy_slab_node() rereads a slot

All eight are for stable.

Patches 5-7 need patch 2, without which their retry is compiled
out on HOTREMOVE=n kernels,

Patch 5 needs patch 1.

Testing
=======

Each race was reproduced on unmodified source in a QEMU guest with three
NUMA nodes and a 512M pc-dimm on node 1, left offline at boot.

A test module widens each window with a kprobe that stalls one CPU inside
it, as an interrupt or a vCPU preemption would.

       base                            this series
patch  outcome                  runs   outcome                  runs
=====  =======================  =====  =======================  =====
 1     NULL returned            3/3    page from reserves       3/3
 2     allocation fails         3/3    waits for the rebuild    3/3
 3     NULL dereference         3/3    ZONE_NORMAL page         3/3
 4     NULL dereference         3/3    ZONE_NORMAL page         3/3
 5     wrong zone or node       18/18  right zone and node      18/18
 6     page from node 1         3/3    page from node 2         3/3
 7     1G page in ZONE_MOVABLE  3/3    1G page in ZONE_NORMAL   3/3
 8     NULL dereference         4/4    keeps allocating         3/3

Cost
====
Kernel instructions per order-0 allocation and free in the QEMU guest,
counted with a task-bound hardware instruction counter around 1M
iterations on a pinned kthread, non-debug kernel, mean of 15 rounds:

                           instructions per alloc+free
                             base   this series
  alloc_pages()             890.5         900.5
  bulk, nr=1, nodemask      865.5         875.5
  bulk, nr=16, per page     477.2         478.1

Bare metal, two-socket Xeon Gold 6138 (Skylake-SP, 80 CPUs),
12 kexec boots per kernel across two hosts.

will-it-scale page_fault1-3: each iteration touches one page, so the
unit is page faults per second, summed over all tasks.

each boot takes the mean of 8 one-second samples.

Base, millions of faults per second:

  tasks                         1     10     40     80
  page_fault1, processes     0.46   4.16  10.51   9.23
  page_fault1, threads       0.46   3.51   4.35   4.19
  page_fault2, processes     0.43   3.66   9.02   8.33
  page_fault2, threads       0.43   3.48   4.37   4.19
  page_fault3, processes     3.89  14.78   8.10   8.00
  page_fault3, threads       3.87  14.29   6.88   7.96

Change in faults per second with this series, + is faster:

  tasks                         1     10     40     80
  page_fault1, processes    -0.3%  +0.1%  -3.0%  -1.7%
  page_fault1, threads      -0.5%  -1.6%  -0.9%  -0.9%
  page_fault2, processes    +0.0%  +0.9%  -1.4%  -0.5%
  page_fault2, threads      +0.3%  +1.5%  -1.4%  -1.0%
  page_fault3, processes    -1.0%  -3.8%  -0.7%  +1.2%
  page_fault3, threads      -0.9%  -0.7%  +0.8%  -0.2%

The boot-to-boot stddev is 1.0-1.8% at 1 task and up to 15% above
1 task, so no column shows a change larger than its noise.

Changes in v4
=============
- dropped 2 patches already covered by other posted series
- Added patch 1. We found that a restart, also reachable through
  cpuset updates, lost the caller's retry with reserves.
- Patch 4's changelog now says that an eligible page is dropped too,
  and that an ALLOC_NOLOCK caller gets NULL.
- Patch 6 checks for a rebuild before escalating to the pass that may
  migrate hugetlb pages.
- Added patch 8 for mempolicy_slab_node()'s double read, the one
  remaining instance found by auditing every zonelist walker.

Link: https://lore.kernel.org/linux-mm/20261014222456.2318284-1-gourry@gourry.net/
Link: https://lore.kernel.org/linux-mm/20261015210539.3243563-1-gourry@gourry.net/
Link: https://lore.kernel.org/linux-mm/20261019172346.3344005-1-gourry@gourry.net/

-- 
2.53.0-Meta


Gregory Price (Meta) (8):
  mm/page_alloc: reset can_retry_reserves when the slowpath restarts
  mm/page_alloc: detect zonelist rebuilds from memory hot-add
  mm/page_alloc: snapshot the preferred zone against shrink rebuilds
  mm/mmzone: read each zoneref slot once when filtering by nodemask
  mm/page_alloc: retry allocations that raced with a zonelist rebuild
  mm/hugetlb: retry the pool walk when the zonelist is rebuilt
  mm/page_alloc: retry alloc_contig_pages() when the zonelist is rebuilt
  mm/mempolicy: read the zoneref slot once in mempolicy_slab_node()

 mm/hugetlb.c    | 13 ++++++--
 mm/mempolicy.c  |  4 ++-
 mm/mmzone.c     | 11 ++++---
 mm/page_alloc.c | 85 +++++++++++++++++++++++++++++++++++++++++--------
 mm/page_alloc.h |  3 ++
 5 files changed, 93 insertions(+), 23 deletions(-)


