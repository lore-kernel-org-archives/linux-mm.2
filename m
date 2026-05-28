Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C16E3CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 21:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AD986B0005; Thu, 28 May 2026 17:30:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65E3D6B0088; Thu, 28 May 2026 17:30:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 526226B008A; Thu, 28 May 2026 17:30:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 39C696B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:30:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C65FF120619
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:29:59 +0000 (UTC)
X-FDA: 84818121318.26.9E13361
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id E6B34C0009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:29:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JBC6vvsB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780003798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XJk3QCW8gkREhNPtXeh46plc74xVDY9UZfjfo7eIXnI=;
	b=EcWLPPXSPlYn7HAfbqZrfQ4SDjpZ3YCDz3pcOv7/GsFps63e049JwckAF+BW+qxwZJrs4M
	pa6y87kkmz1gMZMZAOWrE3VnI8RPmjwVVpDrEXsg8oN/FC2A0ilhtfUV0IZZMuwBV7ubmH
	k98V0u99tcZQn8tgeqK1Xu7dLrY1tfQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JBC6vvsB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780003798; a=rsa-sha256;
	cv=none;
	b=Q+ZoQte/MRf5OsPaN/J22oDjO5YUVqZL4Y6Ksdsv1uhcIpetkpXwCHXWXINC1rIgdj1cRZ
	/pouF1Hl3VTG/dseil8nUHdbttaEbcbRmMu/CChFfUdJJw+FRw9TL3j9YgGzaKwy3kt/wY
	V0D0EgWn58/hF3dfdXEIqR98eUJMfvs=
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7de4a9cb8eeso11831531a34.0
        for <linux-mm@kvack.org>; Thu, 28 May 2026 14:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780003797; x=1780608597; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XJk3QCW8gkREhNPtXeh46plc74xVDY9UZfjfo7eIXnI=;
        b=JBC6vvsBRl0a2fCm/JcRJ0vFC4hCf9a7A/G34RW7bfxnc6eDFFxMR3JZBZt5/iIsBh
         IcOeQinJpCNVKImxL4peGQ6gfzJYxkZcEyofEGAGeD18Y4N1tKpBpfFVH8uCJ7qnrnsg
         rY09cjOu9vwQCbB/AKbESp5rji2ApiusR9SJ/I1ekafAuR4sT3D5yj7kSIFwerCCcNkZ
         /bbEhUAcIDoPuXEz9hTW5HqGoKpk2KWgVWxiW+DoPXXqcYYPYTFWC6er2ZFayXUB3OAm
         6/s0K9M+vTdD5w0S3wwfuBv1xr5JE8RJC1Qxbfyc6Y2VH18745vtYg3cWDebg4xg+MMH
         tO2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780003797; x=1780608597;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XJk3QCW8gkREhNPtXeh46plc74xVDY9UZfjfo7eIXnI=;
        b=Z81S6tVZHgmbkNThfaEK41JSCE7cELd0iT4kW9Aol5WhRtKsHRbN6VdojwtmGN870F
         tu4y+hL4eAZKcLcoWSL27hBLTKwTNBbqvGeXUoEjJhy5iQJaEB01gJxt6A3ptfxEnmy+
         n7F5/SrksKj2A6u8sOfn67bS8UYpdDYjk/z89Wae1dVMGWv4YN1vAcsEG7XWC4HBTed1
         /W3b5e6O4EZxq83bKrkSZK75mQXUwYxDHfJ0GQYNKwizZql/9uHIBXYJcgAIQ8Rz8DzW
         5Gw1Sr0vtLrdQDVz48nQHlgiuziWJGdkt9KvjTG3BQ8KH+i7lpbLxcxUa71FelapNJ+q
         bFPg==
X-Forwarded-Encrypted: i=1; AFNElJ9fqXLG+v/xxCHFPMnbFOcn7mnnsfN8krmApxsD1YA+GLpSMp7jjv1x3kuLdJbRKY4OQ1QIwRKvFA==@kvack.org
X-Gm-Message-State: AOJu0Yzb8LxpNHW7LHGeT2fiuCKIB96y/WL5hwuUeFz+GBt7WanuL/eP
	ktrD/Zd2IdZ75Cc4VoVf1Ck96/NYOQdf9fk2tY740C5ch50dS6iNNYaF
X-Gm-Gg: Acq92OH4EzLbphrvA5n4Lc/LpJ5pch4lPm1ZeCQQVhWd+D6RQQeX5SUW1LMdejD3tiq
	wt9z/irwsmFNBmzMxusaV947KR5jlbMDx4S75kcIpyA9t5LijxWhDR3kIBLoHEHh1jlgMG7xxgq
	NqTGSFQPltBEpK62Qle+4phhvitgJD+JSkwR5CIse7baekzf3sIwK9DAFNpM+82SxGEKlbxA1vY
	zrrzlwO13bZzHmoYbAZGQXlvOffqmrsZFvtLIEZS79JI3820eV+mE2hhEOZvdzN6tNntKGNgbGd
	EqjqTWDcKPoFXoTkL/pRh6g0whsa9O+rq5IpSiw/ICIO7gFvy3fyrtZAoIuPtpOoprUwke8lqi/
	afSkGmIGR1dYhlA8i8YWRftR/bYgeHCIgx31+FAq3onc98NjxQVO9GUqiKQejf8+PwafvjD8ToJ
	CPhKe+UBL7SWORWVYNyA4AvWAyxOfvAS7eKLGMBVROuUzTg7NcrEy9CIYk
X-Received: by 2002:a05:6830:81e9:b0:7d7:570b:6800 with SMTP id 46e09a7af769-7e694e30aa5mr217105a34.23.1780003796651;
        Thu, 28 May 2026 14:29:56 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:54::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e695212fa5sm129153a34.17.2026.05.28.14.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 14:29:56 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com,
	haowenchao22@gmail.com
Subject: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
Date: Thu, 28 May 2026 14:29:24 -0700
Message-ID: <20260528212955.1912856-1-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E6B34C0009
X-Stat-Signature: jn4dow7dyx9x8yxqtw7bbc3n1idx7osf
X-Rspam-User: 
X-HE-Tag: 1780003797-331514
X-HE-Meta: U2FsdGVkX19j4lMfS0zjvIVcYtZwKNcdF8fxLVJanc5xahaPULZPsaOR+TpIt/7Nd+tlyvUD3irfh/Rd4y4FYtTnSQ9CV6tXs0aZ4bBdVA1+ZCf82axLkGXt/NT0NyOxo3Hozs0evZAtRrjaeqphV+n3ieTrd++VkMg1A2UKB4FPyanlL9gfXDK9lxV+HqANlar7tC9nduyrK5UODnojPLuqGSeICU6+3LXB7b/aFKc5YbKn5fHud+FQXAjdlyL0GTGw4WDcASyxHwb4zhMzAWa3Hci0Hs+IIiKrZ++5Pi8HrFT0d2mjjw1uA6ABdSb0o80dA67cS65d9LH0OItE0CYxzwDDeBruMhR7CGRWMtNEwsg2gN6MaVjbpatPXccs+HwmEytTrCzORg66tsILLJoiq/Y4L+SvU5T/8r5hGUbo7hg0w7IT25puzIOOJ1t4MRROG7yMCMBVstdmbSXga7XJ+NEvAIEvlXdlloxv08LHw/ekYqUMnMzro/e+lL8DM6yQyIlkMiPQPGyeo6/4zU93ru2qLSMgROSZAogzf0tExf0hgxnilNKlxN79NR1A+8IbIIRZkaoUCeVgRRUpLWbFSSjqJdWm3gEjgxPylmAF+Hh+rUHMBFbyNWZi4qAgnCVGY1e+znPqMvo+pF0jNVNHo20awf1iSKIkjXFeFPTd/QOEX7IeFrX1vgjBqDZR+dbotx8hXDFJMjN2UUkG3OxY/DRgC78B51wqH2uMJ+TqfkQcPOf9aR4jQ3bXsrMAje3GM/M558+MNjVtyvHHKleqOgnaDFaxURhqKheoZiYfEekG62+5ns+3WlkOBlMz6NVGp62YgLpIRpP7GJaT/UDTyNeWpHvu6Y2dL6mrDZJWVVfUb3ZV4UBmPfSQogdWnA5xtMQ1Q5COYZET+guo5Y6kxgwVv1xmER3nhwBC0pTq082qfZoxxkYj7hYlZqZrDdiixW0Br9zbNtaaEWa
 QFTX2Gs+
 oLvt0cuG56AMzaU5WdKMyuI371K7cUnYef3QMAsu5vYca5ynh7XGdn1Oe85MtB13X8d/TySHpVD0rowfrTEp7le4j57rjmRFUAHLRcQExl0m3qiK77/b7PUMIu9mVGc3ObRErXHJIl5WJsXkPMn8ARawbFTGqOQNnOAualU3aHX00B6zELDa1H8wAYto+WqzxYpajbUYUFOnoFKgUh0vHniMxUPOOh9vgPluvYdDYzuRaXoWnRuFbnDWJ0qr7r2lpOQTK4joqNrjAawT83sjXYO4aDxqOilZr49ebzNIhh/1Z22ILDk3vhQ+RUCh+CvQbRmVGee7L4Xg2wnU2Rt9y9uiiu09ePVR8/DItlxadk1G/SiQAtcKkyeM+UwBu2KJOZTY2wz7+SOJFNbFFpIb3hgNRD5mczbZYoBjAg8abTRCQ9JewJzZFS2zEDwbev6gWquhwsPAm+ClSn5Zonr+7oI7R/oBuazeqZ8dBR/pblwcE0+NsJq9PoqgEEqISfxRPmRuO7IgJw082bf/iYpccAkzhfQ8HMjyX6zmxuVPBywsD+RIhAFZB6KGEEPHz5W/al6z+Kjf3FnkmgUfuEtp7Oemk+m9tvci6Xuq+bkPxCN3UjA3JJ1okoLup4WqWgLQbiC0RTMBDNr2SlGHEQcEqF77vmSvz1NXQUFotgbnDsewmJ8oiNpii/dPvbWybGsGC0nIpCYoOkOu4Al9F5nm9W4Ug7rb00DuhocnW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Based on: mm-unstable @ 444fc9435e57 + swap-table phase IV v5 [2].

I manually adapted Kairui's ghost device implementation (from [4])
for my vswap device. I've credited him as Co-developed-by on Patch I
since a substantial portion of the dynamic-cluster infrastructure is
his (I did propose the idea of using xarray/radix tree for dynamic
swap clusters allocation and management though :P).

From here on out, for simplicity, I will refer to swap table phase IV
as "P4", and the older v6 virtual swap space implementation as "v6".


I. Context and Motivation

Virtual swap decouples PTE swap entries from physical swap backing,
allowing pages to be compressed by zswap without pre-allocating a
physical swap slot. See [1] for a more involved discussion on the
motivation of swap virtualization, but in short, a swap virtualization
scheme needs to satisfy 3 requirements, which are all driven by real
pressing use cases of many parties using swap:

1. No backend coupling. For instance, a zswap entry should not
   require a physical swap slot to be allocated. This prevents
   wastage of coupled backend resources, and allows zswap to be
   used in systems that do not have enough storage capacity for
   physical swap (without having to resort to silly hacks). The same
   should hold for zero-filled swap pages, and swap cached folios too.

2. Dynamic swap space. The virtualization scheme should not require
   static provisioning, to accommodate dynamic and unpredictable swap
   usage. This massively simplifies operational provisioning, and
   allow the in-memory compression backend to be maximally utilized.
   It also makes sure we do not induce unbounded overhead on unused
   swap capacity.

3. Efficient backend transfer. The virtualization scheme should not
   introduces PTE/rmap walking overhead for backend transfer. This
   is crucial for systems that want to support multiple swap backends
   in a tiering fashion (for e.g zswap -> disk swap).

There are a lot of other future use cases as well - see [1] for more
details.

This series reimplements the virtual swap space concept (see [1])
on top of Kairui Song's swap table infrastructure, on top of [2]
and in accordance with his proposal in [3]. The proposal's idea
is interesting, so I decided to give it a shot myself. I'm still not
100% sure that this is bug-proof, but hey, it compiles, and has
not crashed in my simple stress testing :)

The prototype here is feature-complete relative to the swap-table P4
baseline — swapout, swapin, freeing, swapoff, zswap writeback, zswap
shrinker, memcg charging, and THP swapin all work for
both vswap and direct-physical entries — and satisfies all three
requirements above: no backend coupling (zswap/zero entries hold no
physical slot), dynamic swap space (clusters allocated on demand via
xarray, no static provisioning), and efficient backend transfer
(in-place vtable updates, no PTE/rmap walking).

II. Design

With vswap, pages are assigned virtual swap entries on a ghost device
with no backing storage. These entries are backed by zswap, zero pages,
or (lazily) physical swap slots. Physical backing is allocated only
when needed — on zswap writeback or reclaim writeout, after the rmap
step.

Compared to the standalone v6 implementation [1], which introduces a
24-byte per-entry swap descriptor and its own cluster allocator, this
edition uses swap_table infrastructure, and share a lot of the allocator
logic. Per-slot metadata is stored in a tag-encoded virtual_table
(atomic_long_t, 8 bytes per slot), and physical clusters store
Pointer-tagged rmap entries in the swap_table for reverse lookup back to
the virtual cluster.

Here are some data layout diagrams:

  Case 1: vswap entry (virtualized)

  PTE                  swap_cluster_info_dynamic
  vswap_entry          +-------------------------+
  (swp_entry_t) ------>| swap_cluster_info (ci)  |
                       | +--------------------+  |
                       | | swap_table         |  |
                       | |   PFN / Shadow     |  |
                       | | memcg_table        |  |
                       | | count,flags,order  |  |
                       | | lock, list         |  |
                       | +--------------------+  |
                       |                         |
                       | virtual_table           |
                       | +--------------------+  |
                       | | NONE               |  |
                       | | PHYS               |  |
                       | | ZERO               |  |
                       | | ZSWAP(entry*)      |  |
                       | | FOLIO(folio*)      |  |
                       | +--------------------+  |
                       +-------------------------+
                              |
                              | PHYS resolves to
                              v
                       PHYSICAL CLUSTER (swap_cluster_info)
                       +--------------------------+
                       | swap_table per-slot:     |
                       |   NULL   - free          |
                       |   PFN    - cached folio  |
                       |   Shadow - swapped out   |
                       |   Pointer- vswap rmap    |
                       |   Bad    - unusable      |
                       |                          |
                       | Vswap-backing slot:      |
                       |   Pointer(C|swp_entry_t) |
                       |     rmap back to vswap   |
                       +--------------------------+

  Case 2: direct-mapped physical entry (no vswap)

  PTE                  PHYSICAL CLUSTER (swap_cluster_info)
  phys_entry           +--------------------------+
  (swp_entry_t) ------>| swap_table per-slot:     |
                       |   NULL   - free          |
                       |   PFN    - cached folio  |
                       |   Shadow - swapped out   |
                       |   Bad    - unusable      |
                       +--------------------------+

struct swap_cluster_info_dynamic {
    struct swap_cluster_info ci;       /* swap_table, lock, etc. */
    unsigned int index;                /* position in xarray */
    struct rcu_head rcu;               /* kfree_rcu deferred free */
    atomic_long_t *virtual_table;      /* backend info, 8 B/slot */
};

Each vswap cluster (swap_cluster_info_dynamic) extends the classic
swap_cluster_info struct with a virtual_table array that stores the
backend information for each virtual swap entry in the cluster. Each
entry is tag-encoded in the low 3 bits to indicate backend types:

  NONE:   |----- 0000 ------|000|  free / unbacked
  PHYS:   |-- (type:5,off:N)|001|  on a physical swapfile (shifted)
  ZERO:   |----- 0000 ------|010|  zero-filled page
  ZSWAP:  |--- zswap_entry* |011|  compressed in zswap
  FOLIO:  |--- folio* ------|100|  in-memory folio

We still have room for 3 more future backend types, for e.g. CRAM, i.e
compressed-CXL-as-swap, which is laid out in [10] and [11]. Worst
case scenario, we can add more fields to this extended struct.

Other design points:
- Both vswap entries (Case 1) and directly-mapped physical entries
  (Case 2) coexist as first-class citizens. All the common swap
  code paths — swapout, swapin, swap freeing, swapoff, zswap
  writeback, THP swapin, etc. work for both. When CONFIG_VSWAP=n,
  the vswap branches compile out and behavior should be identical to
  today's swap-table P4 (at least that is my intention).
- Pointer-tagged swap_table on physical clusters for rmap (physical
  -> virtual) lookup.
- Virtual swap slots not backed by physical swap are not charged to
  memcg swap counters — only physical backing is charged (I made the
  case for this in [7]).
- Careful separation of vswap and physical swap allocation paths and
  structures adds a lot of complexity, but is crucial to make sure
  both paths are efficient and do not conflict with each other (for
  correctness and performance). I do re-use a lot of the allocation
  logic wherever possible though.

  An example of this is the per-cpu cluster caching. I have found that
  caching virtual and physical clusters in the same structure is a
  recipe for bugs and performance regressions :) For instance, zswap
  shrinker will invalidate the cached virtual cluster, and cache its
  physical cluster instead, which will be reverted by the next vswap
  allocation.


And a lot more of these random tidbits off the top of my head. See the
patches for a proof-of-concept implementation.


III. Follow-ups:

In no particular order (and most of which can be done as follow-up
patch series rather than shoving everything in the initial landing):

- More thorough stress testing is very much needed.

- Performance benchmarks to make sure I don't accidentally regress
  the vswap-less case, and that the vswap's case performance is
  good. I suspect I will have to port a lot of the
  optimizations I implemented in v6 over here - some of the
  inefficiencies are inherent in any swap virtualization, and
  would require the same fix (for e.g the MRU cluster caching
  for faster cluster lookup - see [8] and [9]).

- Runtime enable/disable of the vswap device. To be honest, I don't
  know if there is a value in this. My preference is vswap can be
  optimized to the point that any overhead is negligible. Failing that,
  maybe we can come up with some simple heuristics that automatically
  decides for users?

  In this RFC, CONFIG_VSWAP=y means the vswap device is always created at
  boot, and CONFIG_VSWAP=n means the vswap device is never created. This
  *might* be enough just on its own.

  Is a runtime knob (sysfs or sysctl) worth the complexity beyond
  these heuristics? I'm not sure yet. Maintaining both cases
  at runtime also has overhead for checking as well, and some of the
  checks are not cheap :)

  Besides, what does swapon/swapoff buy us here? We do not want
  multiple vswap devices - they're identical performance-wise, so we
  will just fragment clusters unnecessarily. We do not care about
  sizing, since the metadata layer is completely dynamic. If we want
  to opt-out of vswap at runtime per-cgroup, maybe swap.tier by
  Youngjun (see [12]) is a better interface than swapon/swapoff?

- Defer per-cluster memcg_table and zeromap allocation on physical
  clusters. A physical swap cluster backing vswap entries only do
  not really need their memcg_table, but the current design forces
  us to allocate it anyway. This is a waste of memory, and is an
  overhead regression compared to my older design on the zswap-only
  case, which Johannes has pointed out multiple times (see [6]),
  and is one of the biggest reasons why I have not been satisfied
  with this approach thus far. It honestly is a bit of a
  deal-breaker...

  That said, I think I might be able to allocate them on demand, i.e
  only when the first direct-mapped slot is allocated on that cluster.
  That will give us the best of BOTH worlds, for both the vswap and
  directly-mapped physical swap cases. No promises, but I will try
  (if this approach is good enough for all parties).

- Widen swap_info_struct->max to unsigned long. The vswap device's
  max is currently clamped to ALIGN_DOWN(UINT_MAX, SWAPFILE_CLUSTER)
  (~16 TiB) to fit in unsigned int. 16 TiB is small for vswap,
  especially when we're getting increasingly big machines memory-wise.

- Supporting 32-bit architectures. I need to do the math carefully.
  But do we want to optimize for these architectures anyway? I think
  the only argument is if somehow virtual swap is so good that we
  can just get rid of the direct-mapped physical swap case entirely,
  so we need to support 32-bit architectures. I'm willing to have my
  mind changed though.

- Add some fat design doc (assuming this approach is acceptable to
  folks).

- Samefilled page handling is still doable BTW, if folks think this
  has value :)


This is an early RFC — I have only done basic functional testing so
far, and still need to run more thorough stress tests and benchmarks.
That said, I figure I should send this out early to get folks's
feedback, before I get myself too deep in this rabbit hole - the
complexity is already mounting...


[1]: https://lore.kernel.org/all/20260505153854.1612033-1-nphamcs@gmail.com/
[2]: https://lore.kernel.org/all/20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com/
[3]: https://lwn.net/Articles/1072657/
[4]: https://lore.kernel.org/all/20260220-swap-table-p4-v1-15-104795d19815@tencent.com/
[5]: https://lore.kernel.org/all/aerrps94j70MkgdW@gourry-fedora-PF4VCD3F/
[6]: https://lore.kernel.org/all/aZyFxKGXc8J6PIij@cmpxchg.org/
[7]: https://lore.kernel.org/linux-mm/CAKEwX=P4syV38jAVCWq198r2OHXXc=xA-fx1dk6+qYef6yzxWQ@mail.gmail.com/
[8]: https://lore.kernel.org/all/CAKEwX=NrUhUrAFx+8BYJEfaVKpCm-H9JhBzYSrqOQb-NW7QRug@mail.gmail.com/
[9]: https://lore.kernel.org/all/20260505153854.1612033-23-nphamcs@gmail.com/
[10]: https://lore.kernel.org/all/aerrps94j70MkgdW@gourry-fedora-PF4VCD3F/
[11]: https://lore.kernel.org/all/afIKxG5mJZE6QgpR@gourry-fedora-PF4VCD3F/
[12]: https://lore.kernel.org/all/20260527062247.3440692-1-youngjun.park@lge.com/

Nhat Pham (5):
  mm, swap: add virtual swap device infrastructure
  mm, swap: support zswap and zeroswap as vswap backends
  mm, swap: support physical swap as a vswap backend
  mm, swap: only charge physical swap entries
  mm, swap: add debugfs counters for vswap

 MAINTAINERS           |    1 +
 include/linux/swap.h  |   71 +++
 include/linux/zswap.h |    3 +
 mm/Kconfig            |   10 +
 mm/internal.h         |   20 +-
 mm/madvise.c          |    2 +-
 mm/memcontrol.c       |  132 ++++-
 mm/memory.c           |   34 +-
 mm/page_io.c          |  195 ++++++--
 mm/swap.h             |   59 ++-
 mm/swap_state.c       |   51 +-
 mm/swap_table.h       |   56 +++
 mm/swapfile.c         | 1096 +++++++++++++++++++++++++++++++++++++----
 mm/vmscan.c           |    5 +-
 mm/vswap.h            |  445 +++++++++++++++++
 mm/zswap.c            |  167 +++++--
 16 files changed, 2108 insertions(+), 239 deletions(-)
 create mode 100644 mm/vswap.h


base-commit: 401c55d4eacd97ffd24a89829655baa43b2b308e
-- 
2.53.0-Meta


