Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD40260A2600
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 02:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=APzNkiGZ
Received: by kanga.kvack.org (Postfix)
	id C6FCE6B00EF; Sat, 31 Oct 2026 22:13:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C20F66B05B1; Sat, 31 Oct 2026 22:13:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0FCF6B05B2; Sat, 31 Oct 2026 22:13:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 880B16B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 22:13:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E674A8371
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:13:49 +0000 (UTC)
X-FDA: 85384929378.25.A90ED32
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id 490741A0002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:13:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=APzNkiGZ;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793499227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=//dwDWwlt0K01pJNLrRVdLtiRgsCM03tXrjKo5UHy9M=;
	b=4il2c1e8aPH/8rlNef5mQpKCh1nho9JQsowtmykvN/fDMBZIiQVnFW6oqt2LXGfaDPMMFE
	DYZDGLeatJAuUYH9SlSR9rWBa35fvhTsL8/sCdwKJD4v1Yz6XjB26bejP5NIuxaJh2TF++
	xiLulMlv7RpXk9jcyZnx6RKMaBtbvpo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=APzNkiGZ;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793499227;
	b=DRMafrq/fCRAn30PBW5z/LE5Gu3qk7g2LTseCdXyjvXNUvnTzG4exT1oDla3aEedIh3Bw2
	V231kwaue1oSeXZJ46lWby1SzhHhDTWSo5kDE3bFyOP4SxRjrl1E4JvxCRJ+NYEBD6l75o
	HcAkM0rFpQV13EIQNK2EBeD9NOVw0p0=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-945ae2daa3eso39830585a.0
        for <linux-mm@kvack.org>; Sat, 31 Oct 2026 19:13:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793499226; x=1794104026; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=//dwDWwlt0K01pJNLrRVdLtiRgsCM03tXrjKo5UHy9M=;
        b=APzNkiGZbppaQBE0ZTeQbmDP86B2q3+61QDKWcm/06m9Hn3DTJn3yjDaYAwPGUVWSx
         Q1gRCMT/t/rIlL3XCTfD8rK0ab8biVbrnLeevqPhUFceKQhvwFqiQuCz7VUCBJTwGAYf
         msNZHHLPbiqtNnRI9begcc5hFbL9vWzcW9KbfDezMNxsMbATDQ6bUVtAGqShSYgmisG7
         QK6tY3/XgPpNmxJ+/9Blm15DxIFkA3jZRbWnh7w0zRHUZ16kj6FExbHntR+LmnYtNsC+
         a8GPhCcAoIGIXnbvwJlTmSohGh5oIvieRiZtk5RXtl4S3tisokkXsz+JX7wphP3PGR2t
         WeVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793499226; x=1794104026;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=//dwDWwlt0K01pJNLrRVdLtiRgsCM03tXrjKo5UHy9M=;
        b=ztG4D9o1V3HmtZMXAuQ+9FA8/LkRipqEDkcN3iXx/WYHajIHu4hLaM0B9JKdj6cqki
         Cxm3ZKaH9lKcmPWtQ2FxNCoHnweew15C8ykujkCBwJCs9NePiqBJJBG7DnDqWaJSFjo/
         5dOG12XSgJfmdPbDWkdTVzagVZrquRC91AFICzvoguZbhykSg9/L1s7XCQR054UMCg4Y
         O1Nagt2xpP6qxcAVRCkNKlrRP5Fg8ZNEI+nXO7nGtVNkDxFVxjvFPcAYhDujP/f3dhHl
         r0gxae9b4ua2PbMKIz5qII0A+aj2IbnP4lAWpFhUOmVxiO8Kw+jiS1JeltqGbS6KD+db
         qUPQ==
X-Gm-Message-State: AFq9FYIxSo2sP13DyKmFRJ7blt7S9shJBP1wFulxFisiIXi6c2TQMXN+
	lkA88a2fGfytnYJC88JwGZMDxZ5WVAyF2VLF4OTQlZ9bNV7g0HwtU5j4yxVaisSWHO7STkOGzJb
	rDIMd
X-Gm-Gg: AYBFou2P4gYpX5U+/9y96fBAROPSOO2axfJSQOKVrYMOXbOkRdRtkUNJHWWd10W55yr
	4VkZ2oXcZM/49sOu+1s39V2+05w80gse8C2hwr89JxqVXhIgG94QJ9woPrBz+FhrVo2ykSU3Z8i
	3tISazbXFE4RiSTUNk+DY7tdvAHh33DFWahG4aqUj2XDeNuKl6NSlx9Y+2Mke5uksbhkL+D6JFn
	FP1ThOj42VlyT1BOo5vDeLYAGUIRo2sSc+QUmYCzUKv4QAQodhVwjBbOmoug3Bc6PPd0iSXmtDA
	/qLI5Ek47zlmPvgBr+Xcik9l7gOs6QAQp0qKXDsuGUs4dKYedLqHSt2AEs7YzdiKzSXhahytCBT
	xuVd7gEQRAtC37UcgC+r6lJB2X004dOU3alY1Zeyu0BqAOR+xLn0Y7LCAdnmyWwegZPYexZpziC
	k7z+hchAdWCucvwM50Y86gWlPIojAXdLSTKgHVZ+ShO8WHsaoZ8BXgTvXlmakJUGxDUSEirqIbc
	pf2NMDXjrFfi+SM2Rg1BHvKDsLTsiT6r90EGVYEH9i2tOgg1KDRZYs9fkDrALLqVmqgik6N9k9W
	tC8pua1sSuFwWE7W+aBszyocqm3t7ZZXgbYUkF40FW51Uf5DI0GYu6r6sBpt35utWb/xodq+Bwm
	5p4vJBI0OxTnXXkrzB84luv3Te3iwVPM=
X-Received: by 2002:a05:620a:6406:b0:939:b057:daf2 with SMTP id af79cd13be357-9442176d62emr1044006585a.45.1793499226345;
        Sat, 31 Oct 2026 19:13:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425858552sm498131985a.18.2026.10.31.19.13.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Oct 2026 19:13:45 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	nathan@kernel.org,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com,
	Bessel.Wang@huawei.com,
	jiang.liu@huawei.com,
	mgorman@techsingularity.net,
	anshuman.khandual@arm.com
Subject: [PATCH v5 0/12] mm: fix allocator races with memory hotplug
Date: Sat, 31 Oct 2026 22:13:28 -0400
Message-ID: <20261101021340.2251928-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 490741A0002
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: wownynq99wmib9cypgs1nbw5rzx8t445
X-HE-Tag: 1793499227-99658
X-HE-Meta: U2FsdGVkX18EuXMbTQcpIYKKHfcusnOghebm/tIQQkExjeSg9BF8VOUoUnmiZKMdfgtaXUEwrkYs3Ku/grRIpQetKOBGsw8YxhozoR8j5Spw5tGnooH5o1HCV5dSvS4jFMSm7rMQHWUoX2hBkrpLJOsfgl3FKc9XQthIx7qGN+TEEy3qwWRKo6EfNEesMqQKjvgTCkbbw/62GFMJxn5hb0sr6wNU50HpQ7P/oZzeDs3jeE23B/Izc7338lkqEULYme5MDxU2VtjOZ5vdPWU8yyp3KRH5RmjC9N5jGiH4ikXecqRBpXcofcAZHxtQSYIuUHzLIKKrC2otlCMftsa3ijg9tizo1gPl3CTfzeLTOV7jRJBrfPql3m5wU8tin1S5MzUHuvZ/yVh1nLYSXWBmQFWeyidJb5j0qKJKyDSKADzuQ5iMxJTXGIw/R3XZKOY63SdvDDH5BwmwiF0NL66xzbP+OB+UyxJpWqwvxS7wCHmHjdVwxy/TEA2sEAuj5Y1/Kr8T8ClRFXKuXqr2DYleKbiwFpcmy3H1fBrsMHwfob1pxJYN93v+eH7605UV34fJGX5qpv8tQ+hk3JWz0TvpWytYZwRLepjqVqT86PWSyaNLqj3Oz4/xWPcHNHxIGJodB9ptVCb9UwWqeh3ZLqf43mcr1H8Ec+hIcS9TVi+CZYPzC7b15MSF3wz0sMOyvMVdeOn4CH7zG7yvRrUaLYAKuIj5ML+NEhcP8PMoxhwyW4dPDaIolpK2XME3/vu3UQQD1WgP14A1FVy9NdeRWcrCoYztZWJBVtBVQOoirSV6PvA9wETAa1FKwwEXWnJ+uqHYU7SA9yqEzvHxTfxIcVHdi+MyemBDPC4wmm8m94T4qbE6621M+ZuGOQVh+2WHj2yb/f1s/Rerou/gMcittiJPm6UGrGFlbKCZ8J11CaiPcio5Mp5JG1h5rrKh59o3YQNNmqsbeiuaUpXdrVyQKRE
 hHYL0D72
 zr1hTCHGELseXivGVu4wwf2Yo3DfqylTWTvftgTv16+4928KuZH9wRE1UFBjMo7vP+/CKeiij4pqiNPm5U1STnZ6y9hN/dFu2Ehr3HtnwFWCIqAucpWc7qCQ/RDQIl7KzFy15LcfhDVoaMqSy3uVDW8hOj3ZFyPOlgtEHY2SpgzUpSY6t5Z7562EQIHbOXOepKPdAFwijz8r64NK/2IiRuEwll7H5ohA/UKC6ZB+uk9p3fruHZ3E4ypCzKM7dVCXZ2X5PgLTwTrqeQWaIkbyEwFLkoWruhnqOh2mhccX+EkWIvvj3M4ra1jS/aX4ImzgwW0ylS8a/1Yy+itNlrLdmdR4poVObn8P8GKL5FJrodWCuvZmESbb0U2w3HzfxJ/ESwOtycF0DaWy072bUn2FO4MB+Cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Memory hotplug rebuilds zonelists in place while allocations walk them,
and offlining an emptied zone frees pagesets the vmstat worker can still
hold.

These eleven fixes cover the walkers that crash, fail, or pick the wrong
zone or node as a result, and a twelfth patch removes a helper that
invites the same bug.

   1. a restarted slowpath loses its retry with reserves
   2. offlining an emptied zone frees pagesets still in use
   3. the reclaim_retry_zone tracepoint rereads a zoneref slot
   4. the zonelist retry is compiled out without MEMORY_HOTREMOVE
   5. zonelist_zone() may load its slot more than once
   6. NULL preferred zone after a shrink rebuild
   7. __next_zones_zonelist() rereads a slot
   8. allocations land outside their zone or nodemask
   9. the hugetlb pool walk takes another node's page
  10. alloc_contig_pages() takes a range outside its filters
  11. mempolicy_slab_node() rereads a slot
  12. zonelist_node_idx() invites the same double read

Patches 1-11 are for stable.  Patch 12 is a cleanup and is not.

Patches 8-10 need patch 4, without which their retry is compiled
out on HOTREMOVE=n kernels.

Patch 8 needs patch 1.

Patches 6, 7 and 11 need patch 5, which makes zonelist_zone() read
the slot once.  Patch 12 needs patches 7 and 11, which remove the
other callers of zonelist_node_idx().

Patches 2 and 3 are patches from anthropic, pulled in from Vlastimil's
series to keep the backport issues self-contained on the series.

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
 2     UAF                      6/6    no UAF                   3/3
 3     NULL dereference         3/3    allocation succeeds      3/3
 4     allocation fails         3/3    waits for the rebuild    3/3
 6     NULL dereference         3/3    ZONE_NORMAL page         3/3
 7     NULL dereference         3/3    ZONE_NORMAL page         3/3
 8     wrong zone or node       18/18  right zone and node      18/18
 9     page from node 1         3/3    page from node 2         3/3
10     1G page in ZONE_MOVABLE  3/3    1G page in ZONE_NORMAL   3/3
11     NULL dereference         4/4    keeps allocating         3/3


Cost (these tests were run on v4, v5 hasn't substantially changed)
====
Kernel instructions per order-0 allocation and free in the QEMU guest,
counted with a task-bound hardware instruction counter around 1M
iterations on a pinned kthread, non-debug kernel, mean of 15 rounds.

                           instructions per alloc+free
                             base   this series
  alloc_pages()             890.5         900.5
  bulk, nr=1, nodemask      865.5         875.5
  bulk, nr=16, per page     477.2         478.1


Bare metal, two-socket Xeon Gold 6138 (Skylake-SP, 80 CPUs).

will-it-scale page_fault1-3: each iteration touches one page, so
the unit is millions of faults per second, summed over all tasks.

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

The boot-to-boot stddev is 1.0-1.8% at 1 task and up to
15% in 10-80 tasks, so basically this is all within noise.

Changes in v5
=============
- Pulled in patches from Vlastimil's series (patches 2 and 3 here)
- inline functions (Vlastimil)
- Added patch 5: zonelist_zone() reads the slot with READ_ONCE(), as
  recommended by sashiko on v4's mempolicy patch.
  Patches 6, 7 and 11 call it instead of open-coding the load.
- Added patch 12, removing zonelist_node_idx().  Not for stable.
- Patch 1: reworded the changelog (Vlastimil).
- Collected Reviewed-by tags.

Link: https://lore.kernel.org/linux-mm/20261028211930.3504634-1-gourry@gourry.net/
Link: https://lore.kernel.org/linux-mm/20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org/
Link: https://lore.kernel.org/linux-mm/20261014222456.2318284-1-gourry@gourry.net/
Link: https://lore.kernel.org/linux-mm/20261015210539.3243563-1-gourry@gourry.net/
Link: https://lore.kernel.org/linux-mm/20261019172346.3344005-1-gourry@gourry.net/

Gregory Price (Meta) (10):
  mm/page_alloc: reset can_retry_reserves when the slowpath restarts
  mm/page_alloc: detect zonelist rebuilds from memory hot-add
  mm/mmzone: read the zoneref slot once in zonelist_zone()
  mm/page_alloc: snapshot the preferred zone against shrink rebuilds
  mm/mmzone: read each zoneref slot once when filtering by nodemask
  mm/page_alloc: retry allocations that raced with a zonelist rebuild
  mm/hugetlb: retry the pool walk when the zonelist is rebuilt
  mm/page_alloc: retry alloc_contig_pages() when the zonelist is rebuilt
  mm/mempolicy: read the zoneref slot once in mempolicy_slab_node()
  mm/mmzone: remove zonelist_node_idx()

Josef Bacik (2):
  mm/page_alloc: keep the pagesets of an empty zone
  mm, page_alloc: pass zone pointer to trace_reclaim_retry_zone

 include/linux/mmzone.h     |   9 +---
 include/trace/events/oom.h |   8 +--
 mm/hugetlb.c               |  13 +++--
 mm/mempolicy.c             |   6 ++-
 mm/mmzone.c                |  11 ++--
 mm/page_alloc.c            | 107 +++++++++++++++++++++++++++----------
 mm/page_alloc.h            |  19 +++++++
 7 files changed, 123 insertions(+), 50 deletions(-)

-- 
2.56.0


