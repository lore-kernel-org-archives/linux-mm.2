Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDCE4C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 15:32:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 945426B008A; Tue, 25 Aug 2026 11:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F5E86B008C; Tue, 25 Aug 2026 11:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BD436B0092; Tue, 25 Aug 2026 11:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F1F26B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:32:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B31784047F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:32:42 +0000 (UTC)
X-FDA: 85140184164.29.0463CCC
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id EE1271C0003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:32:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PZrBH2Sn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787671960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TWTPFXRnJO3wBcI8WMuuM4Fkhk9C3h07kfsXs96xXog=;
	b=McN02vq5szMyEA3HSs1CUSACSLAlMkRKecOI/1dhni9MQbO/b62CBRn9cq0c0MiRdBYkwU
	W1hoGU3Yd7JPAtU25ZvLjRDeSms1L8rjYZhZBGhKh3sdQ4el1EttkUxWL59IMqRw2dxzPT
	wF3YE52c+N8zRIoqBvhSiqKdzEdW0cA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PZrBH2Sn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787671960;
	b=VXtGfbsooeZ8yH6r5texF7xaRdO0aD8+4oL/D5WCFkan5WlHbgIopFAW0fN0dz6YVUKk4A
	jvWLjw0SoJDJG949qjfgdcOa1ye7yd14u02F99mQ9nE/1yLZhzgD/KzzHViuYk9xxPoDkz
	oT7ISEbdx+dDUovoS+j9XtGifnU+bq8=
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-4583b1703d3so2945818fac.3
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671960; x=1788276760; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TWTPFXRnJO3wBcI8WMuuM4Fkhk9C3h07kfsXs96xXog=;
        b=PZrBH2Snxj6BvqIAQpO4Gae32i13SdTEwSvrxjE4UVhAvDgv7A6KOrSNeBhlKpK4Wr
         fk7W6fLUf45oTr+r/yPjwD/du3xjjtilc8hkG/SZHBSgO07STFprWRf4Qu4E3R3ueCtz
         AgBLglg12/MOI9reUE3i+2f2JxE1SOLvNsHDjfrTazhCV5c5qUeCltZbdMCv2cIatpZu
         WdkP1sSLJAoEZ1M/fUskt/CjVG/CBraIHwmmz4bIM4cWIWiRf9xXJ8dLpAY25qNkl+ms
         wY70jVYURC2fkJv1jFEzWhwpgABhE2tkDyvCVdOQ5L+5G22IkFG0KxrLXBoaPQYSG8MS
         Lumw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671960; x=1788276760;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TWTPFXRnJO3wBcI8WMuuM4Fkhk9C3h07kfsXs96xXog=;
        b=J1YIaG/ryhlpLbHaN5Ib5jjfsFhlGOQ/TCXs7SkDHUl8uxHks+CgByyGxQkxLz0PIU
         NX5M1/ytqr3jF87t3DpnJ45Yy0EtyUqYjRDGzcsnB4Wf3ne2mURBgJzi0EWDMNeDdGwG
         FJK/iWh8FzRc6s4oFsVvov00lOAJ/YCg0Amg+i/yU76LJY/NY8JWvgG8SjvOY9m4mSmg
         BErjABJ5552kD1p9h8oiRpqzHn7LITZpL+Am4r/8qe2/io0j3IJZy/OsRsWvFXrjDtFc
         2HfWzwHuMGQvd8Q1ooQwsWEaUXN/31X0JH9QA6EO8IFO730fDcKdiyC8mdD3VzF94ROl
         rrVQ==
X-Forwarded-Encrypted: i=1; AHgh+RoEJO1ZwSqT+B7B3TuymrlHpwtck0dKuuivh6/lf6Ol3lpDQxFVuYu8Uwwkq3CXd+hpe0iIrpd76Q==@kvack.org
X-Gm-Message-State: AFuF++mlkGY8wtUwg7GQ8HvlGJAnUkryObxSed1lbn808HZwFLas/eHv
	Hzz2q4URIuV1HMiS54LNXdZk4I+FkgmuUc6Kb9oCOeWGN9FvKaSC5gK0
X-Gm-Gg: AR+sD13K7oVuC1M+XjYNK6urAitkbEPD5kSgjzqGN3tCMkqbpS7hRewAV5pvlp5huCq
	XToFaTTuMG0UhKADDeLlE2qVU5EOogpTjblBAHExspdFIi3W98WlYbQeegcuK3ePLreV6cRB0xR
	6GcV7Y32CZ7/AqUemX3bGtVHnwcJ4h7RBHWZz35qF/WfOUO8ZBByLq2MUOmBJQAXLuysOYsyVJG
	hKLkIdS2OId2Oe42TBiLQVBY7JIzbE+Npx21RR3WelLmjnuEdZ6tr3jJzCR1ZMJQUOGOy6vUBsu
	WhQn+pZUXX2eZQ+cJGvnoxdCw581lX1M9cxX+wSaOv+5i9TQpbJeEYy6CJEqlyh4U7hcN3/XG9s
	uIYQ3RcVCh6RURvplEwS8oIGrTBa+uiLT4a3LdG+/jou7ADi11bN0kQPCWgv+gACEr1+Ac92uTY
	5TRvSgXSHR62XK9liD9EDSDsjhkR8uYQ2ANV6zc56FhMVzb9w3TV84I3E3H8aPpmUp4tO6uGVUL
	eGStILqbn8=
X-Received: by 2002:a05:6870:720a:b0:448:7667:2e96 with SMTP id 586e51a60fabf-4637fa4d63dmr26462204fac.9.1787671959594;
        Tue, 25 Aug 2026 08:32:39 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:51::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-463831397f0sm8191635fac.3.2026.08.25.08.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:38 -0700 (PDT)
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
	corbet@lwn.net,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v4 00/11] Virtual Swap Space (Swap Table Edition)
Date: Tue, 25 Aug 2026 08:32:26 -0700
Message-ID: <20260825153238.2695446-1-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1mscgo8j19fksrxtod41ptbowtsxa438
X-Rspamd-Queue-Id: EE1271C0003
X-HE-Tag: 1787671960-251090
X-HE-Meta: U2FsdGVkX1/F55SjecrhpjNOOE4i4HWBYn9C+zSjp5Ib25RRGiqQmJGtazMbuL8kQHvrdHyvjUGtecRd+cL6vlwsvewCTDF7KugP2v2GwDHZWv1RIxzdyE5szqDAKH4yKxrKTBRdYQbWnjogBZOafU/een/o2iTzomTHTzCCw2xskll3uH+RzHdkyiW7YFjEx01xemqXE51mfRVc1QypbiQoSLVxT292V37ZRkyxRrz6M//2O7zSBlOPY8XPggbrIcusx5Qds4bKysAf/FYTBtyEM/MiunvM45oRyDK5a1HO8aYhJVJtq/VKh316GDpxMd/Lq0eqv4fwJK+bKYdl58Ci1Ifz9nJVMd38DTZcTTGjbUHuBXHml359L4bLlOQDasxNHLcGAfDOaRg+m4DhXAhU5pKnbGCuUzpNdm6M7p/4Otrxfc2yfBO/G7aA6Z9/vCsbAZWhdZKaCqtF4zuL4rzfyd7HdJYXejQEIPHgdqPGt5OPL1/gs7tYNgHACZX+t3ecW4qrN9O+fHiYhuy9x7CvzKRk1kYCPd2Rjo6u6TEquwAZxy9cfKWav3SAFbBmlFaSMF3XahA6NZjaLFa/o13aKgEXF3CyfNJf1lNWgb02SzmCxQ5AdH7PfG1Zna6isV9uJjFwLdhcVGg0DfWEuw+IJKY9/fhWmRKzdbOBD1dLYxrU2vI+dbphdmzNfcZuCWvcwZQnIU9YI/HYGJzih1NbzKKZ3hu58c7xEqPVplKyAyo5MgIyiaXm4FOnN0v2hARIaTJlbX3ZcdAvcSG5ZAC1ZFemi3T1RamwD9nmv8mSYftUxKGGnm1TRk49zQA/C7JJvlex0CJgLflJTM4hkBCdGk0LGgvJz0gRB60ajzjfYe5CGr4By+mEY/GL75nnuKd2L8VGkPwDTKiiHeXmo8IqMdexApg0H59fZwAw55iQWHRnIeYlL7tdZdG2XaZXtF/chunTBVKotiSfrAq
 GgCqSGOp
 fB9/6Dnb3uXMwcoPSK7PezGzHBOCYWkiy31mI8i9CK3/pltGvjHtH89nCS/PziBXmEHgBsQ/bHSniwPWiNR+mBGVBJ6XA73/8zbFXGibBFfXQY5QIf+0xd2c3Vc8FayzRqld9LgNPK9aeCbI7EcI4nquSNVLQ/UeQr2Uvp8wKKsbSs5QO/jnrf6QZXdLwPVA1DYLUQHBZpv9xIzANDakaU1wYvZIzvGRJZsT3Y3glVPEGlGTuAJWqDqdt0JqfOIJOm6RPiOhNHdJsJGVcijhma81tE+gsz+Z8TqCaI/JK69CNs0LuU2X1TRT2Vpk3FWRv2mK/WNXHHoKkOvlFljONWvDGHVg8iF/+BArSy+/W18jO55oUrmnf3pmTr6k7I8554hhhg/zarbu9R+k+eRPQy/aH2UdkY/LjIUo6yXUs3i/CPV9jzy1RVDnLPrUeMYEg7XTPdrjWW8n7VfRfyh8sOl3lZ5ivTNe8WtjlhpgBYCHrAHQIanqlUwsQZ9MD1nunQET/aUi864ISLqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changelog:
* v3 [v3] -> v4
    * Replaced the runtime sysctl with a cmdline param, and remove
      CONFIG_VSWAP (suggested by Johannes Weiner). CONFIG_VSWAP_DEFAULT_ON
      now only gives the default value of the vswap cmdline parameter.
    * Refactor swap-related memcg operations into composable building
      blocks: reference acquisitions, charging, etc. (patch 8,
      suggested by Johannes Weiner).
    * Fixed vtable UAF bug reported by syzbot and Kunwu.
    * Rebased onto mm-unstable (minimal merge conflicts).
    * Re-run benchmarks (no signal change).
* v2 [v2] -> v3:
    * Rebased onto current mm-unstable.
    * Add a runtime vm.vswap_enabled sysctl and CONFIG_VSWAP_DEFAULT_ON
      to gate vswap allocation.
    * More cleanups and small bug fixes.
    * Split THP swapin enablement into its own patch (patch 5).
    * Add production workload benchmark results, and drop RFC tag.
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
      in [1].
    * Defer memcg_table allocation on physical clusters until the first
      vswap-backing slot installs. Saves ~512 bytes per physical cluster
      that only serves vswap-backing slots (this is the new patch 8).
    * Widen swap_info_struct->max and ->pages (and the swapoff unuse-path
      index) so vswap supports ~8 PB of swap space (this is the new
      patch 9).
    * Split the physical-swap-backend patch into three for reviewability:
      the core backend (patch 3), zswap writeback to physical swap
      (patch 4), and reclaim of cache-only physical slots (patch 5). No
      functional change.
    * Add kerneldoc for the vswap API.
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
writeback is disabled. This is arguably the central shortcoming of
zswap:
* Resource-wise, it is hugely wasteful in terms of disk usage. At Meta,
  we size swapfile in the order of 25-50% of host RAM, depending on flash
  availaiblity. This is a lot of flash for a fleet of our size, and
  with universal zswap enablement, most of this is wasted for zswap
  entries.

* In deployments when no disk space can be afforded for swap (such as
  mobile and embedded devices), users cannot adopt zswap, and are forced
  to use zram. This is confusing for users, and creates extra burdens
  for developers, having to develop and maintain similar features for
  two separate swap backends (writeback, cgroup charging, THP support,
  etc.). For instance, see the discussion in [2].

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

For more historical contexts and references, please take a look at
the cover letter of the older vswap submissions ([3] and [v2]).

II. Design
==========

When vswap is enabled (via vswap=on cmdline parameter), a special vswap
device is allocated at boot time. Anon pages that can be zswapped will
obtain a vswap slot at swap allocation time.

These swap entries can subsequently acquire backend on-demand, such as
a zswap entry, or a slot on a physical swap device (as a fallback option
or at zswap writeback time).

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
                       | | SWAPFILE(swp_entry_t)      |  |
                       | | ZSWAP(struct zswap_entry*) |  |
                       | +----------------------------+  |
                       +---------------------------------+
                              |
                              | SWAPFILE resolves to
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

  NONE:     |----- 0000 ------|000|  free / unbacked
  ZSWAP:    |--- zswap_entry* |001|  compressed in zswap
  SWAPFILE: |- type:5,off:56 -|010|  on a physical swapfile

Other design highlights:

* Note that for the vswap device, we have merged the zswap xarray tree
  with the swapfile-level clusters. This means that for zswap only users,
  we have negligible extra space overhead.

* Both vswap entries (Case 1) and directly-mapped physical entries
  (Case 2) coexist as first-class citizens.

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
  case for this in [4]).


III. Benchmarks
===============

Note that the goal is not to match vswap performance with baseline on
every single case yet - running with vswap off is still supported. We
can optimize further once we have landed this new feature.

A. Production Workload: Instagram
=================================

To test vswap's stability and performance, I ran an A/B experiment on
Instagram (django) workload, with zswap as the swap backend. On these
hosts, the swapfiles' size is 50% of RAM.

Compared to baseline, vswap gives:

* On par request throughput.
* Lower request serving latency (by about 1-3%).
* Lower memory pressure in the system service cgroups running alongside
  the workload. PSI-based proactive reclaimer can therefore recover more
  from them, lowering their overall memory footprint, allowing the main
  workload to expand.
* Elimination of swapfile footprint for all zswap users in the host.

B. Semi-synthetic Workloads (memhog, usemem, kernel build)
==========================================================

All values are mean +/- standard deviation across rounds.

Test system: x86_64, 52 cores, 64 GB swapfile for all 3 benchmarks.
Swap backend: zswap (zstd) with the traditional active/inactive LRU. We
focus on zswap here because it is the motivating use case for vswap.

For each benchmark, we test 3 kernels:
* Baseline: mm-unstable, no vswap patches.
* VSS off: vswap series applied, vswap=off, to verify that there is no
  regression to existing swap paths when we disable vswap.
* VSS on: vswap series applied, vswap=on.

1. Memhog: single-threaded, 48GB allocation on a host with 16GB RAM,
   20 rounds.

                    Baseline           VSS off            VSS on
   real (s)        124.05 +/- 11.64   122.31 +/- 10.29   118.57 +/- 15.68
   sys (s)         106.75 +/- 10.86   105.01 +/- 9.64    101.34 +/- 13.97
   user (s)        10.81 +/- 0.11     10.85 +/- 0.09     10.79 +/- 0.09
   delta real              -              -1.4%              -4.4%
   delta sys               -              -1.6%              -5.1%

Dropping the best and the worst round to reduce variance:

   memhog              Baseline           VSS off            VSS on
   real (s)        123.75 +/- 10.39   122.04 +/- 9.10    116.06 +/- 8.22
   sys (s)         106.80 +/- 10.21   104.99 +/- 8.86    99.29 +/- 8.27
   user (s)        10.82 +/- 0.11     10.85 +/- 0.08     10.79 +/- 0.10
   delta real              -              -1.4%              -6.2%
   delta sys               -              -1.7%              -7.0%


2. Usemem single-threaded: 56GB allocation on a host with 32GB RAM,
   16 rounds.

                    Baseline           VSS off            VSS on
   real (s)        178.75 +/- 6.47    178.95 +/- 6.56    175.97 +/- 7.74
   sys (s)         127.03 +/- 6.56    128.08 +/- 6.59    124.71 +/- 7.90
   tput (KB/s)     386662 +/- 14648   386264 +/- 15150   390443 +/- 17532
   free (ms)       7669 +/- 146       7678 +/- 136       6439 +/- 111
   delta real              -              +0.1%              -1.6%
   delta sys               -              +0.8%              -1.8%
   delta tput              -              -0.1%              +1.0%
   delta free              -              +0.1%             -16.0%

3. Kernel build: 52 workers (one per processor), memory.max=3GB, 10 rounds.

                    Baseline           VSS off            VSS on
   real (s)        165.58 +/- 0.45    165.83 +/- 0.49    166.01 +/- 0.58
   sys (s)         694.24 +/- 26.13   710.76 +/- 19.83   705.06 +/- 21.40
   user (s)       5132.62 +/- 1.12   5133.69 +/- 1.57   5134.68 +/- 1.68
   delta real              -              +0.2%              +0.3%
   delta sys               -              +2.4%              +1.6%
   delta user              -              +0.0%              +0.0%


For zswap backend, vswap outperforms baseline on usemem freeing, and is
on par with baseline on the rest.

IV. References
==============

[v1]: https://lore.kernel.org/all/20260528212955.1912856-1-nphamcs@gmail.com/
[v2]: https://lore.kernel.org/all/20260612193738.2183968-1-nphamcs@gmail.com/
[v3]: https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.com/
[1]: https://lore.kernel.org/all/CAMgjq7BhOn48xEyC=2j837R7qddfjeBVHMiRqdx8no4ZEBpBLg@mail.gmail.com/
[2]: https://lore.kernel.org/all/Zqe_Nab-Df1CN7iW@infradead.org/
[3]: https://lore.kernel.org/all/20260505153854.1612033-1-nphamcs@gmail.com/
[4]: https://lore.kernel.org/linux-mm/CAKEwX=P4syV38jAVCWq198r2OHXXc=xA-fx1dk6+qYef6yzxWQ@mail.gmail.com/


Nhat Pham (11):
  mm, swap: add virtual swap device infrastructure
  mm, swap: support zswap and zero-filled swap pages as vswap backends
  mm, swap: prepare the swap IO path for vswap
  mm, swap: support physical swap as a vswap backend
  mm, swap: enable THP swapin for vswap entries
  mm, swap: write back vswap zswap entries to physical swap
  mm, swap: reclaim physical slots backing cache-only vswap entries
  mm, swap: only charge physical swap entries
  mm, swap: add debugfs counters for vswap
  mm, swap: defer memcg_table allocation for physical swap clusters
  mm, swap: widen swap_info_struct max/pages to unsigned long

Nhat Pham (11):
  mm, swap: add virtual swap device infrastructure
  mm, swap: support zswap and zero-filled swap pages as vswap backends
  mm, swap: prepare the swap IO path for vswap
  mm, swap: support physical swap as a vswap backend
  mm, swap: enable THP swapin for vswap entries
  mm, swap: write back vswap zswap entries to physical swap
  mm, swap: reclaim physical slots backing cache-only vswap entries
  mm, swap: only charge physical swap entries
  mm, swap: add debugfs counters for vswap
  mm, swap: defer memcg_table allocation for physical swap clusters
  mm, swap: widen swap_info_struct max/pages to unsigned long

 .../admin-guide/cgroup-v1/memcg_test.rst      |    2 +-
 .../admin-guide/kernel-parameters.txt         |    7 +
 MAINTAINERS                                   |    1 +
 include/linux/memcontrol.h                    |    6 +
 include/linux/swap.h                          |   76 +-
 include/linux/swap_ops.h                      |    9 +-
 include/linux/zswap.h                         |    3 +
 mm/Kconfig                                    |   20 +
 mm/memcontrol-v1.c                            |   10 +-
 mm/memcontrol.c                               |  148 ++-
 mm/memory.c                                   |   21 +-
 mm/page_io.c                                  |  106 +-
 mm/shmem.c                                    |    4 +-
 mm/swap.h                                     |   71 +-
 mm/swap_state.c                               |   60 +-
 mm/swap_table.h                               |   50 +-
 mm/swapfile.c                                 | 1182 +++++++++++++++--
 mm/vmscan.c                                   |    9 +-
 mm/vswap.h                                    |  440 ++++++
 mm/zswap.c                                    |  129 +-
 20 files changed, 2100 insertions(+), 254 deletions(-)
 create mode 100644 mm/vswap.h


base-commit: efecab401cb15fd3bb9bc05990609acb6b267ff2
-- 
2.53.0-Meta


