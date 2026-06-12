Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A222CD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 19:37:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41A5E6B0005; Fri, 12 Jun 2026 15:37:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CADC6B0088; Fri, 12 Jun 2026 15:37:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B736B008C; Fri, 12 Jun 2026 15:37:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D77A6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:37:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C65E11C25CB
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:37:45 +0000 (UTC)
X-FDA: 84872270490.07.16E515B
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id DF71020003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:37:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MQpCiJwO;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781293064;
	b=P8pGYnFCJ+Hn3bkjz/lEFb5jmBQfBhI3fiigoaL5wzTpmUWKyXmeCQ8jSSdagBBfYwUumv
	xAHIZTLIvCIxJGDBcmxwg4vlcN1HlekBLBrY1b/A+ze2tFt2Ylp3pg4simP7NwU7H6U3c7
	Z11XySlSYZndFxvgTP/vdCCiKdBj5BA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MQpCiJwO;
	spf=pass (imf03.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781293064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NYIHDzugB3q4b7dtXwivhmQu85/nZd51+qcui89O6Xo=;
	b=dBmESd2FcgBuPAeqluC2v0WGTyWrGdh5aRIWyFO1fQEnmEYTFL5Rv3agzmQ5OSTaI+8Q9H
	iAnbYlxFcDwmTHjcHkTd2jseSe7v4NycD7jgUAyNQuy8UtidBu7OpGJrbYaiYBBPHgUuB+
	rMBCDrOtc5vqSDIHxi5uIKiQw8Y+SZY=
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7e6dcc22cbcso1267714a34.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781293063; x=1781897863; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NYIHDzugB3q4b7dtXwivhmQu85/nZd51+qcui89O6Xo=;
        b=MQpCiJwOJUEWRNSZopucQD0bmkay8Et+5/PwD2kFGlTRVWNIu1mJXMq1SE8AL3QKEJ
         FYktkaRhnXoNJHwtixrL23u9f+Ge/iBRjMA8ELNT/X9KgI0jgGb+KDmnI3d1IcN1xcl2
         qaM6rDoDWy9WkJRpjJuUDDZzV4cpQBo0yN/M/KEjiIug4+QTdDnMj2qmWLS8VsB2Rwy9
         MKMGbgTbQvrrzyVZZ6Ux2qoEDJOW1T1ehkBaUHH+y++dkMux6j+wgyEsxotH2HhSsQOG
         9zaklAdMpgnGakuZK+kEQF3myz8S1rwIfqHSa4fJAFS/wNpPRbCIp9eVq0RGCUMchHdM
         g+Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781293063; x=1781897863;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NYIHDzugB3q4b7dtXwivhmQu85/nZd51+qcui89O6Xo=;
        b=iAcc05Er0yb7WeesPtQ2FBp5FmHP6jrnwcbB+5Q6uapTH1VL6As2+ASUnvs+EuLBSm
         Anuim6y9tb9jpfTiXxhOEii3jTNj3bGNHh943afWaouXxAOIDJgmRE0jbPyTi2YqztW+
         BAI9XF+5iyBKwihaH6+MfKYlwp7amDsOF7qGDGq9WLFbG6c5fcc19EBJhvnZEjVGs68L
         sBJclu+z3WdBKy9ZFpWOhSQel81JWzAGw32S18nGL/NzZV125ShhvjhgF1PUxBuAmwHd
         h5AC0U8fxi0uu0w5LcSjpM2vfnWe399/5lNAkEEuFXgYli6m6Mphm2UuOB+ajhSfCBP0
         7umQ==
X-Forwarded-Encrypted: i=1; AFNElJ8MLxQKQDNF05Q9mib4KUk7LTpi6GX1Xk1fdeLLDk7D52ZZ1Hc98M2ANj74rLgt5hqhGVd9fVECCw==@kvack.org
X-Gm-Message-State: AOJu0Yy8fdgBhn6fU34YHG7GOyx/i/n/ffcUsqU2AuSvp4j/h9e9f6JZ
	uFvudTTtg9pI/GLzvaPmzEqAKbHYiIMxWs4dQJH8E0dkuq+jSH19qGpt
X-Gm-Gg: Acq92OGqdvMRlHnTBlVwhkzviRpTJLx2yS1CjQIpG99fNCpkLvy98Ca4VQFvZ1HPZ4N
	TeSuhF6ExJ85Um8HQ2Msj4m83uq6MTpvNXYPs3B0Dvx6OEhNT51WOUgfm6M01y+bLWCkY9sRjoG
	vxwE2YaxsrvrfIOp+cKUKIYLI5Ajt5TA5vZZKnsuELVPnqasNq3/AqhTxuCmNIMyWWquWoS7lwy
	PUcijMVSP7cTDuH7PFPvDa8bKQjVpklc3DyB7t1Ut5FKX5DP5jnXLSLUdcmMQlJWeslA8Ti9c+7
	UBnIHy7w1WOwFCMS0tIYvWyFLJcpxhOCpKEmU0GRrvNE4Fp/BwLLTjyXW9ftv76k57fS0zFKbwi
	jcTndKOMlf/5YYigiuKesRAqZgJ4tvsPAWY58/4XnkhIrr8kYcoXF6Y6+bFo/B9Eehfn3lbvKTU
	CvA/OXa+BYaJl94jQmwwRZhv2rZR1lqUICqdqoW1BzNaKaNA==
X-Received: by 2002:a05:6830:380d:b0:7e6:f4a3:1dfc with SMTP id 46e09a7af769-7e784895f7emr3030372a34.23.1781293062617;
        Fri, 12 Jun 2026 12:37:42 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:48::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e78148a918sm2596926a34.7.2026.06.12.12.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 12:37:41 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 0/7] mm, swap: Virtual Swap Space (Swap Table Edition)
Date: Fri, 12 Jun 2026 12:37:31 -0700
Message-ID: <20260612193738.2183968-1-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DF71020003
X-Stat-Signature: i1rcrzbsqay1xr1ohee6pqwnim1aempp
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781293063-303877
X-HE-Meta: U2FsdGVkX18fgTdLwvE45Tir9IRZ20V616stZydeKotARhUdoKmG9fhyenphW8Ze0/77IvwDFqnXLwSz1WacbpEzI/3cykMhn+9OxWMbW3Fu/At8PK3JUaLNdXvvuyc/l0gi9sNiNTrsf0MGgt92jCiLeawB7L6TumiscuZ+FY1E7OmQOis53Q2G8pfmrxnhQsso23Z7ntULbVxycPVCJ0uOrow2mVI8xtY+lwjCpzpY5kDlXbwKHS5KnHFRnX0Jv9/PHC4AvYqrk1oZPpRjQMYjtaXjTRAaM0BOB1alp1cWmNwcVyAsD3jjRwPpBYMkJnAvREoXNyUV5j/j3GiAVzvE+dl4jb6Ngii8pviJjI6YUV8zLOSowD5l+nxGLQQq7GDaST3TODhGiDmvY/bulE3YSxqRk+tmwVazMG366UxMKbhU8hPIOQ0ww62v5iDeGBeoLkhsQhb76yW8zHuk41yK6+WCuyCvKQPXEqDFktJdvkhM3XNtmIRSPLA608SutTLgEucKvF3CDr/iEHHLNJYKOlGnt0zcUc+3ukDmVX5Cg0VA5gdtTfgIs8QILwcSUWgNqxTq8LiEe3a+I9+JnUWaXj7VpPOv51RUCK5jb5oDQrqnw1uBs7ycAYxyEOORrSbwG8MdfVjTxpXMQ9iNVo3uIyqFvB1b05JZ/D03bBsb6Rvy3+2YTb0q0ODyPrS5uXySlwKL454/xZDhOw3AgaNbvdjszBKfPBSEkB1sPfFQFmKNO6sO93xwQkTKPpUQ232F4YoGlYRjcSEY0aLCQceh3I0dXfVMJHcc8Y8FQrCyicrl+TuYmhbdpbNzqbLzTmAhppROprPEOZZRc8evcKp4UL1l9WSSKoIKAT5jEQiyTP2OPcePfRu+/gp4C39B6y+ZmX1KG34gYJFRI8Zva3tmN918RM2Q9RQfLOeqsc43PAFtSCa4PCqthqC9rQ5FV6BAnbYxooS6zetlQV4
 6Wf64V+6
 pvv7ksJMSk30dvpu/FiXZptwdZokp0GHK71LW24Q/jg+C3U+xzWT9IpJIhcNrD82EduOS0m0wYefu6H2au+FANhle1LcoJsxhDhguLukF6u8ssYuA0Z4MCdorAo0o1EvZyma8ObHwWC0qDsyxreFth4oAVQyyWaB4iTidEygQb6iVgCV3B7y8kw3Zfn/4HddDbCOytkX+FHDzdpVD9BZPKYB4WS+PZ0U2cM7cDLuVomBqfHGtOJPoRduDCEdmUuK2IN9tBogl0BNn2bdFpRyQcruO5Nmw8YKZmNdrl0ui3O4xNu+Dlnp/oJBDCn24Yd4M6saPxNsGJf3nHMTkAkHP/XYEu3N/NmHSMyXcKDx/Q1zhoVlrvDfuRSEy7SUUsAd2KzYGUV9MhFIhsyNg3GRmYdJ7oxP6eoEXaue3lyNelHceGS1kwmh55R3BinLDLuEgvyA8+4Ej43DqCl4tBNp2lDG0h+zCt+VIy6yDhopAW4XGW4B+LgHoUoZfSh7L9Ka+AsLQI0i9UcuNlufBalcZwBYOnajkOCfJHJ/elxAvdOMVbQEUe33MIzACgSs0cmmeszHfGExYqf9UeOVFCzu90Bm9Qkrd9XAMIFDNURQCToj2i3zDkWeNxjFKuE/iP98zLAfddzRgBROzfh4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changelog:
* v1 [v1] -> v2:
    * Rebased to a newer mm-unstable tip.
    * Fix a bunch of assorted issues (incorrect zswap store failure
      rollback, vswap_init() failure handling, rmap-encoding collision,
      etc.) and clean up the code (rename a bunch of functions to
      more closely follow existing patterns, etc.).
    * Some more code clean up and simplification: some renamings to more
      closely follow existing patterns, move vswap backing check to
      __swap_cache_add_check, store zero state in the swap_table for
      vswap entries, etc.. Many of these are proposed by Kairui Song
      in [14].
    * Defer memcg_table allocation on physical clusters until the first
      vswap-backing slot installs. Saves ~512 bytes per physical cluster
      that only serves vswap-backing slots (this is the new patch 6).
    * Widen swap_info_struct->max and ->pages (and the swapoff unuse-path
      index) so vswap supports ~8 PB of swap space (this is the new
      patch 7).
    * Add some benchmark numbers for zswap case.


I. Context and Motivation
=========================

Currently, when an anon page is swapped out, a slot in a backing swap
device is allocated and stored in the page table entries that refer to
the original page. This slot is also used as the "key" to find the
swapped out content, as well as the index to swap data structures, such
as the swap cache, or the swap cgroup mapping. Tying a swap entry to its
backing slot in this way is performant and efficient when swap is purely
just disk space, and swapoff is rare.

However, the advent of many swap optimizations has exposed major
drawbacks of this design. The first problem is that we occupy a physical
slot in the swap space, even for pages that are NEVER expected to hit
the disk: pages compressed and stored in the zswap pool, zero-filled
pages, or pages rejected by both of these optimizations when zswap
writeback is disabled. This is the arguably central shortcoming of
zswap:
* In deployments when no disk space can be afforded for swap (such as
  mobile and embedded devices), users cannot adopt zswap, and are forced
  to use zram. This is confusing for users, and creates extra burdens
  for developers, having to develop and maintain similar features for
  two separate swap backends (writeback, cgroup charging, THP support,
  etc.). For instance, see the discussion in [4].
* Resource-wise, it is hugely wasteful in terms of disk usage. At Meta,
  we have swapfile in the order of tens to hundreds of GBs, which are
  mostly unused and only exist to enable zswap usage and zero-filled
  pages swap optimizations.
* Tying zswap (and more generally, other in-memory swap backends) to
  the current physical swapfile infrastructure makes zswap implicitly
  statically sized. This does not make sense, as unlike disk swap, in
  which we consume a limited resource (disk space or swapfile space) to
  save another resource (memory), zswap consumes the same resource it is
  saving (memory). The more we zswap, the more memory we have available,
  not less. We are not rationing a limited resource when we limit
  the size of the zswap pool, but rather we are capping the resource
  (memory) saving potential of zswap. Under memory pressure, using
  more zswap is almost always better than the alternative (disk IOs, or
  even worse, OOMs), and dynamically sizing the zswap pool on demand
  allows the system to flexibly respond to these precarious scenarios.
* Operationally, static provisioning the swapfile for zswap poses
  significant challenges, because the sysadmin has to prescribe how
  much swap is needed a priori, for each combination of
  (memory size x disk space x workload usage). It is even more
  complicated when we take into account the variance of memory
  compression, which changes the reclaim dynamics (and as a result,
  swap space size requirement). The problem is further exacerbated for
  users who rely on swap utilization (and exhaustion) as an OOM signal.

  All of these factors make it very difficult to configure the swapfile
  for zswap: too small of a swapfile and we risk preventable OOMs and
  limit the memory saving potentials of zswap; too big of a swapfile
  and we waste disk space and memory due to swap metadata overhead.
  This dilemma becomes more drastic in high memory systems, which can
  have up to TBs worth of memory.

Swap virtualization is the answer to these issues, with three properties:

1. Decoupled backends. For zswap in particular, this means we eliminate
   the unused storage space, and allows zswap to be used in systems that
   do not have enough storage capacity for physical swap (without having
   to resort to silly hacks). Zero-filled swap pages and swap-cache-only
   folios also benefit here.

2. Dynamic swap space. Since virtual swap is not tied to any physical
   resource, we can make it infinite and dynamically grow it on demand.
   This massively simplifies operational provisioning, and increases the
   utilization of compressed swap backends (zswap). Dynamicity also
   reduces overhead on unused swap capacity.

3. Efficient backend transfer. The virtualization scheme should not
   introduce PTE/rmap walking overhead for backend transfer. This
   is crucial for systems that want to support multiple swap backends
   in a tiering fashion (for e.g zswap -> disk swap).

There are a lot of other future use cases as well - see [1] for more
details.

This is the culmination of many years worth of discussions, designs,
and prototypes. A brief history:
* The same idea (with different implementation details) has been floated
  by Rik van Riel since at least 2011 (see [16]).

* Yosry brought up this proposal again at LSFMMBPF 2023 (see [17]), and
  I have been working on this shortly after (see [1]).

* The final missing piece is the swap table infrastructure and efficient
  swap allocator, which is conceptualized and implemented by Kairui Song
  and Chris Li (the latest version is [18]). I added the dynamicization of
  swap allocator via radix trees/xarrays (but the concept of dynamic
  clusters is not mine - Johannes proposed it to me).

There are more contexts (and references) in the [1], for those interested.


II. Design
==========

When we compile kernel with CONFIG_VSWAP, a special vswap device is
allocated at boot time, and all swapped out pages try to allocate from
this device first, falling back to a physical swap device on failure.

These swap entries can subsequently acquire backend on-demand, such as
a zswap entry, or a slot on a physical swap device.

We repurpose much of the existing swap_table infrastructure and
swapfile allocator for this new vswap device, with two notable
differences:
* Clusters are dynamically allocated on demand and managed through
  an xarray. This in turn allows us to avoid static provisioning and
  let swap space grow dynamically.

* Each cluster of this new vswap device has a virtual_table that stores
  the backend information of the entries in the cluster (see below).

Diagrams:

  Case 1: vswap entry (virtualized)

  PTE                  swap_cluster_info_dynamic
  vswap_entry          +---------------------------------+
  (swp_entry_t) ------>| swap_cluster_info (ci)          |
                       | +----------------------------+  |
                       | | swap_table                 |  |
                       | |   PFN / Shadow             |  |
                       | | memcg_table                |  |
                       | | count,flags,order          |  |
                       | | lock, list                 |  |
                       | +----------------------------+  |
                       |                                 |
                       | virtual_table                   |
                       | +----------------------------+  |
                       | | NONE                       |  |
                       | | PHYS(swp_entry_t)          |  |
                       | | ZSWAP(struct zswap_entry*) |  |
                       | +----------------------------+  |
                       +---------------------------------+
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
entry is tag-encoded in the low 3 bits to indicate the backend type:

  NONE:   |----- 0000 ------|000|  free / unbacked
  PHYS:   |-- (type:5,off:N)|001|  on a physical swapfile (shifted)
  ZSWAP:  |--- zswap_entry* |010|  compressed in zswap

Zero-filled pages and swap-cached folios do not get their own vtable
tag. A zero page is recorded in the swap_table per-slot zero flag, and
a cached folio is just the swap_table PFN entry. We still have
VSWAP_ZERO and VSWAP_FOLIO in the backing type enum, but this is purely
for convenience in the code that needs to determine the backing of
vswap entries.

Note that for the vswap device, we have merged the zswap xarray tree
with the swapfile-level clusters. This means that for zswap only users,
we practically have very minimal (if not 0) extra space overhead!

Other design points:

* Both vswap entries (Case 1) and directly-mapped physical entries
  (Case 2) coexist as first-class citizens. When CONFIG_VSWAP=n, the
  vswap branches compile out and behavior should be unchanged.

* Backend transitions in the virtual_table are synchronized through the
  swap cache and the folio lock - the same mechanism that already
  serializes ordinary swap operations (swapin, swapout, zswap
  writeback, swap cache reclaim). IOW, we can only assume that the
  backend of a vswap entry is stable through swap cache/folio lock.
  Looking at the backend without this should be done at best for
  optimization purposes, as there is no guarantee that the backend
  will not change under the observer.

* Pointer-tagged swap_table entries on physical clusters provide the
  rmap (physical -> virtual) lookup.

* Virtual swap slots not backed by physical swap are not charged to
  memcg swap counters - only physical backing is charged (I made the
  case for this in [7]).

See the patch series for more of the gory implementation details :)


III. Benchmarks
===============

All values are mean +/- standard deviation across rounds.

Test system: x86_64, 52 cores, 64 GB swapfile for all 3 benchmarks.
Swap backend: zswap (zstd) with the traditional active/inactive LRU. We
focus on zswap here because it is the motivating use case for vswap.

For each benchmark, we test 3 kernels:
* Baseline: mm-unstable, no vswap patches.
* VSS off: vswap series applied, CONFIG_VSWAP not set. This is to double
  check that I did not regress the existing swap paths when we disable
  vswap :)
* VSS on: vswap series applied, CONFIG_VSWAP=y.

1. Memhog: single-threaded, 48GB allocation on a host with 16GB RAM,
   20 rounds.

                    Baseline           VSS off            VSS on
   real (s)        107.56 +/- 10.69   110.44 +/- 20.80   108.36 +/- 17.10
   sys (s)          90.72 +/- 10.57    93.33 +/- 20.23    91.39 +/- 16.18
   delta real              -              +2.7%              +0.7%
   delta sys               -              +2.9%              +0.7%

Note: for some reason, the first 1-2 rounds are significantly slower, for
all 3 kernels. No idea why, but probably because we need to allocate swap
clusters etc.? So I have decided to run 20 rounds to cancel out the
noise :)

If I drop the worst and the best rounds, the variance is even lower,
and all 3 kernels are very close to each other:

   memhog              Baseline           VSS off            VSS on
   real (s)        106.69 +/- 8.87    107.40 +/- 13.11   105.95 +/- 11.98
   sys (s)          89.91 +/- 8.83     90.40 +/- 12.83    89.28 +/- 11.90


2. Usemem single-threaded: 56GB allocation on a host with 32GB RAM,
   16 rounds.

                    Baseline           VSS off            VSS on
   real (s)        178.89 +/- 4.25    176.28 +/- 8.04    177.39 +/- 5.43
   sys (s)         124.39 +/- 4.62    124.32 +/- 8.01    125.47 +/- 5.62
   tput (KB/s)     386398 +/- 9469    392976 +/- 17972   387264 +/- 12167
   free (ms)       7821 +/- 108       7825 +/- 116       6646 +/- 103
   delta real              -              -1.5%              -0.8%
   delta sys               -              -0.1%              +0.9%
   delta tput              -              +1.7%              +0.2%
   delta free              -              +0.1%             -15.0%

3. Kernel build: 52 workers (one per processor), memory.max=3GB, 5 rounds.

                    Baseline           VSS off            VSS on
   real (s)        169.08 +/- 0.31    169.23 +/- 0.73    168.90 +/- 0.53
   sys (s)         814.25 +/- 17.12   817.75 +/- 20.27   809.35 +/- 16.76
   user (s)       5131.69 +/- 1.29   5130.93 +/- 0.76   5129.26 +/- 1.63
   delta real              -              +0.1%              -0.1%
   delta sys               -              +0.4%              -0.6%


Commentary: as I have suspected (in [20]), for zswap backend, vswap
matches the performance of the baseline kernel. This is because a lot of
vswap space and CPU indirection overhead already exists in zswap due to
its xarray tree. Nice to see things work out of the box though.

In fact, vswap seems to be better than baseline for usemem freeing.
I have not perfed things yet, but I suspect it is a combination of:

1. vswap does not do swap charging and uncharging for zswap backend.

2. The allocator is more efficient for vswap, because we spend less
   time on trying to free up swap-cache-only slots (since vswap is
   infinitely large).

3. Zswap metadata is merged into the vswap cluster. This allows us to
   merge lock sections and eliminate xarray tree walking.

Note that the goal is not to match vswap performance with baseline on
every single case yet - that's why we still maintain !CONFIG_VSWAP
cases. It is fine to trade a bit of performance to gain the flexibility of
this new design. It is nice to know that it might not be as much where it
is most useful (zswap) though :)

Please let me know if there is any other result you'd like to see. If no
one objects, I will drop the RFC tag for the next version.


IV. Follow-ups
===============

Some of these depend on patches not yet in mm-unstable. I'm not 100%
sure what's their status, but if they land in mm-unstable before this
patch series, I am happy to rebase. But otherwise, they can all be done as
follow-up patch series :)

* Simplify the memcg charging in "only charge physical swap entries"
  (patch 4) via the mechanism proposed by Kairui in [14].

* Once we have per-swap-device per-CPU allocation caching, we can get
  rid of the dedicated allocation cache of vswap (see discussion of
  Kairui and I in [14]).

* Swap read/write handlers can be simplified with swap_ops, whenever
  that lands (suggested by Kairui Song in [14], and the line of work
  pursued in [15]).

* Allocate the per-cluster virtual_table from the page allocator (like
  the swap table), and make those pages movable. This might reduce
  memory fragmentation issues of long-lived vswap clusters tremendously.

  Perhaps we can even free the virtual_table when the cluster is not
  backed by any zswap or swapfile slots?

* Free the per-cluster virtual_table when a cluster holds no zswap or
  physical backing (all slots cache-only or free), and re-allocate it
  lazily, mirroring the deferred memcg_table allocation. Reclaims a
  page per 2 MB of cache-only vswap.

* Integration with swap.tier by Youngjun (see [12]). For now, I'm
  leaning towards opting out the vswap device from swap.tier entirely, and
  treat it as a special device. Integrating it with swap.tiers will
  benefit the cases where you want some cgroups to skip vswap for fast
  swap devices (pmem), whereas other should go through zswap first. But
  most other use cases, either the overhead of vswap will be acceptable
  (or not the bottleneck), or we can just disable CONFIG_VSWAP entirely :)

  Youngjun, may I ask for your thoughts on this?

* Supporting 32-bit architectures. We can make zswap depends on vswap
  after this, getting rid of a lot of the complexity (see my discussion
  with Yosry in [19]).

* Further optimization of swapfile backend case, especially for fast
  swapfile (zram, pmem, etc.).

[v1]: https://lore.kernel.org/all/20260528212955.1912856-1-nphamcs@gmail.com/
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
[13]: https://lore.kernel.org/all/20260220-swap-table-p4-v1-7-104795d19815@tencent.com/
[14]: https://lore.kernel.org/all/CAMgjq7BhOn48xEyC=2j837R7qddfjeBVHMiRqdx8no4ZEBpBLg@mail.gmail.com/
[15]: https://lore.kernel.org/all/20260601113449.3464734-1-hch@lst.de/
[16]: https://lore.kernel.org/linux-mm/4DA25039.3020700@redhat.com/
[17]: https://lore.kernel.org/all/CAJD7tkbCnXJ95Qow_aOjNX6NOMU5ovMSHRC+95U4wtW6cM+puw@mail.gmail.com/
[18]: https://lore.kernel.org/all/20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com/
[19]: https://lore.kernel.org/all/CAKEwX=P95D7wNpWhEAXQpeNPM6eQa2mEZE8Srzfpct=-=Q40tg@mail.gmail.com/
[20]: https://lore.kernel.org/all/CAKEwX=M3WAkSY=Zd35dEuQ6V3ZiNR02bKAN_DnCgVr69w9=0sQ@mail.gmail.com/


Nhat Pham (7):
  mm, swap: add virtual swap device infrastructure
  mm, swap: support zswap and zeroswap as vswap backends
  mm, swap: support physical swap as a vswap backend
  mm, swap: only charge physical swap entries
  mm, swap: add debugfs counters for vswap
  mm, swap: defer memcg_table allocation on physical clusters
  mm, swap: widen swap_info_struct max/pages to unsigned long

 MAINTAINERS                |    1 +
 include/linux/memcontrol.h |    5 +
 include/linux/swap.h       |   75 ++-
 include/linux/zswap.h      |    3 +
 mm/Kconfig                 |   10 +
 mm/memcontrol.c            |  166 ++++-
 mm/memory.c                |   28 +-
 mm/page_io.c               |  172 +++--
 mm/swap.h                  |   58 +-
 mm/swap_state.c            |   60 +-
 mm/swap_table.h            |   62 ++
 mm/swapfile.c              | 1219 ++++++++++++++++++++++++++++++++----
 mm/vmscan.c                |   14 +-
 mm/vswap.h                 |  455 ++++++++++++++
 mm/zswap.c                 |  166 +++--
 15 files changed, 2244 insertions(+), 250 deletions(-)
 create mode 100644 mm/vswap.h


base-commit: 01a87376d94249407343653a63e8ecfbe4c79cda
-- 
2.53.0-Meta


