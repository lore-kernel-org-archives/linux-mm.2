Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 723C8CD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 18:16:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09A176B0005; Sat, 20 Jun 2026 14:16:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04BBF6B008A; Sat, 20 Jun 2026 14:16:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E54FE6B008C; Sat, 20 Jun 2026 14:16:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B43CC6B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 14:16:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F0271C483D
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 18:16:50 +0000 (UTC)
X-FDA: 84901096980.15.143D35F
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 671ACC000B
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 18:16:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ksOqoH9e;
	spf=pass (imf22.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781979408;
	b=XSmWlFBd4mQG/nDhGQi2y3qA469I+y10ph43iVivoORiVsR/awpibkxoXzBusIR6iFE8ij
	2FWVG1ZHwH+ruDzXc6ss94XHlSFPO3cVZH1WlYlFzsaBwB4O1ttoFS/jsay/ipJrkYy6CK
	/0MW0hs3AMqTHuHsJ8IQd7le898b+Hw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ksOqoH9e;
	spf=pass (imf22.hostedemail.com: domain of her0gyugyu@gmail.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=her0gyugyu@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781979408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MKXHChCZvPPhlY8n4Ua2hoJq9ToW4QcOYuQ0CXpouRI=;
	b=u7Eco8zWTFvsamUX2ndFRe6SGmzJ84ME7eLBsDBLsentWUv+7yOadsYGuLLx1WwRv7QriO
	HWCq5+Q+EQ736pscEDNaQAgtPrrgo4jJGJsWg6hL1Ko45Ih+GLeugTROLxV4UxvIBOnvMQ
	rYZ8bXHAv5zSjQvXOIfTPJLp7DFPxJ4=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c89370405aaso1390698a12.0
        for <linux-mm@kvack.org>; Sat, 20 Jun 2026 11:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781979407; x=1782584207; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MKXHChCZvPPhlY8n4Ua2hoJq9ToW4QcOYuQ0CXpouRI=;
        b=ksOqoH9enuu2AHozCx2q65SlfzBPXSYtFrcnWrRUwA/Z1vJvbOV0fTq9mlDWw1ycpZ
         0XMIVo4IVVnKaj+II18NxoZ9WxSXad21rXmiQQoK5XEI/WUNqdGQuvUMKAJ4fh6fBtmA
         y5T40faFK40F3MZbBXMOupGm1hKYVN7XoiS66Wp9MyAjankexMOmvkL8hk7ULx62ZN6N
         SqZ1ivVk+YBQVSR+pnWNMjrXBFBxDaFpENNkZ/R/PoVLRYy/PQD8ob13dHkacc/WUZNh
         Z++tao7LDJSn0UyXtPEYp6dUjCiZvVtaRf3jNviKRNCr1qZXn871j+XCD9TaxSFTwG/S
         q4MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781979407; x=1782584207;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MKXHChCZvPPhlY8n4Ua2hoJq9ToW4QcOYuQ0CXpouRI=;
        b=NkpCT0ROItsiIk1Zi/+ly9PMYOxReD90KUYIAMx2fWE9Zl1zo/kTvNq/agBy7SBcNc
         V0sk03hE1bHzWFaHuzzjy5UQh/aavDInVM4/eL/zX08qbc/8GTYxzN7BEdGe+R4Vx+A/
         72r387/OckX6SybUgxaMiQMbnnwffXrMoCKWYJVlmG7PGiWOGxD5gdPQ8amtVddOQMnU
         +7+Zh1R/ryryeWyxlq8zcORWn2pAswZogvnyE98yEsboIX+5z1ZgM5MnJCkdNBC9FqwD
         ju75yGS0+raVYTTtlgIOolQkezYMuQLzsngOuCuXw348T5tWrw3uT8EnJ7xuPA9pf81b
         rxEg==
X-Forwarded-Encrypted: i=1; AHgh+RptFxeX91vU5DoQPjWGwjzBb9xhoTtoBHd6LXWSJFFeV+cPlK4Sk9qEHs55HMewKA9oGG+YmudZiQ==@kvack.org
X-Gm-Message-State: AOJu0YxaYTSbELZPGRwYBSwGrp6IfsLIkpzCT9kwLIDiHXgDpjzaMOo4
	Nda3T4Um9oegVjiiMMn6yUlwcNuujb6J9IMG98Qu8zZwLHRj1mLv5EWK
X-Gm-Gg: AfdE7ckOxgymq6rvlCM+5x9KO9rmHYJ9yg6Ct6YrjrnrFyYbcEGX3PKGxe+JXfYny+p
	2nNnZqOlhevRYiv43rsjPO7v4rqSzoSdJzST3z5NPUgCfdY8JxPMbXYjOdbs1u5FEyA6IhshAMu
	LnP5+be2OTEQwQS80xSjpgXNbx5C2JbQKl5G311rwZRHvEQZr1cbhsaRpHa9F0m3pEK6185jJqZ
	9CoPxM6KJpXpgf1WVBJ5N/nw5H2DQMRgi4r9OPSPJDBUyb3roPcxuFfu4a1a64zMmiLfo9d1/cK
	hyYIr3xinukunNi+3ZeeDa0iwdcbeKJPWHpnF22UoX4rLzp4bn/nvZNWgyqaaB4KxKFJT84Byet
	Avti2rrctkEnosTcjqg2FulRAIhidLForBxy1dnt7f+3RZpgFt4z4UXqLpCCDLX4ySPrMJZHo/Q
	kP4EvzYURZzzIbZBD8RKt5zN7hQyf+ZWNC6+tv64URymZMOhHgpy+RE7RUrXJgmaE3l8huTJ6c2
	r/2G5dYE2ct
X-Received: by 2002:a17:902:d549:b0:2c4:608:167c with SMTP id d9443c01a7336-2c725a650f9mr77896095ad.6.1781979406967;
        Sat, 20 Jun 2026 11:16:46 -0700 (PDT)
Received: from localhost.localdomain ([220.85.166.190])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7436af6d9sm30339465ad.4.2026.06.20.11.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2026 11:16:45 -0700 (PDT)
From: Youngjun Park <her0gyugyu@gmail.com>
X-Google-Original-From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	yosry@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com,
	baver.bae@lge.com,
	matia.kim@lge.com
Subject: [PATCH v9 0/6] mm/swap, memcg: Introduce swap tiers for cgroup based swap control 
Date: Sun, 21 Jun 2026 03:16:25 +0900
Message-ID: <20260620181635.299364-1-youngjun.park@lge.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oqonfwwu7qj9hyeac59fbc7a8xx655kq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 671ACC000B
X-HE-Tag: 1781979408-304089
X-HE-Meta: U2FsdGVkX1/F0Fcl3IKgfKs4xOv02AmIhcqRxBa3mu1W1SSVpBwhd8KxDyLslhd69v8KOx9AznnIvyjz4UWgEOXAmHtM300MxPLKg6z2mXOXz/lATojv/gnX72Zo9GQl4CvMQp6FaxFiQkETOCHRIdJACd79Jxk5OOyIIKOTtpi2Z65o3R6TZXBkqwBUDYYf7LjcpwBVKVzAch40kG71d9F7PXf0Rm5fhAHu5/RI3yUyYYsfIV+KXT3wQqRVxHHjoimKLZrxFYNVGyVO2YjmHDNMTaok/AgYMy6a9dgssYmptediH4nGbKPBMHwrAnBod1wlAxtqc7WSRhsmagXK6Sf6eKreL/RCtQo2gv1f7//mbG8A/cx2NbiJAXlDQd+2goNMC3Mf+GT9QZ+csuTQ+GCv273IRAi8f4W1M+MJGLiIg7krhwMtWZJit1zf/7zE8h8laJzMVnGio8vLd8TUcI9rqvHEyYRGYqUPSy8SD7vlY5N5Uoasn8PTyetSozpiDM3lWhOcO3A8tGaP6UZq0fH+u9q+wywI9F8UoJ+RweQhMUKmhV5TpzZANP3IjAJYLhRxicvC8rscRBK3HpSvP3uY9qgwPObTx1FOfXgaq3Tk0ofWiwzwbaaUzLGCopUX6LBPM/xYNk4A32wVFv/w8+BY/mDhBVIDkNQglM37gm/x60t27dA6Xj44Wm2IqD8R5u+jwGfBi2p9G0HYLM1U7oVOGovLJa5XtnlbBSgWDMaKRXniIQy+URWO3iMRs0R2eTojQnNrgDa71cOj3+9B/qP8uGTqTxbNZV8X4y6yoYI4ROzL5yqvD7ViR23qBB/SWDMMXEq4oashVHiQWWLlnKdbGmp2Hh0Wk0Hf2k/zki6WMAGenQ1qhbuvN2wqrid2qLSIEoC74qA+iNzdIZ4ie0fVbbpwpRtBHALWAI6/TMVcR4YW+eh/pwt27YJ2LK5H4nEreSXqZ9f9jTiP73t
 ZV5+O7/9
 ZUR/imn0L0wdh8g+3fgG/DfnPp9qgVUNjA6/pOVhFUzPxKUsmFgCpCZQIL+6dDOY5tl4PYH6r7XQGydXijITuXSnnbpzJz6vwt5xrp0rqXGkvgDyFc86AwpT0siKAXWRIK0kJhQJ15jPMXqdgatZ+j+3YoqHxL5/HQ93k5KZv8cXUAXsNy4VLhJlaxUCjETc8emwYKwWpb9dejHwk0Sz1NQncrORfptUw9Hxtm5nlYjNl0J6SzT0frPpNL9HPQSdFCHKNWRVYGakYRNqf4IEFOaxHnmsE4ofvEmZLQgpGFflpcrkgjt6mAUG4bX1MVxvxpyWBnoU/9dvcqVvYmvGU97pPvg8AL/8S5xMEiRzQanc/lF5kKt2bfiOmy3tZV2UTFbBW90w7C8FSNWVQGpVX+xjLroTxgYqyVFZ+/TCzbcpV4ozpV21H+jewRnCF9TECkHKxopI/FvWuL3WdAX8Ogix5Qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the v9 series of the swap tier patchset.

The main change in this version is the addition of selftests for the tier
interfaces, requested by Nhat; see the changelog below for the other changes.
I designed the test cases and wrote the selftests with some AI assistance.

For context, the bulk of the series is unchanged since v8, with great thanks
to Shakeel Butt and Yosry for the reviews and discussions [1] that shaped it.
The main change in v8 was the interface change to use memory.swap.tiers.max
with '0' (disable) and 'max' (enable) values. This mechanism was suggested
by Shakeel and Yosry.

This change allows for future extensions to control swap between tiers and
aligns better with existing memcg interfaces. It is confined to patch #3's
user-facing interface; internally, patch #3 still uses the existing mask
processing method, which is implementation-efficient.

We also discussed tier extensions. Thanks to Yosry, Nhat and Shakeel for their
valuable feedback.

Here is a brief summary of our tentative conclusions. Please correct me
if anything is misrepresented (details in references):

* Zswap tiering [2]:
  Tiering applies only to the vswap + zswap combo. Zswap itself will
  not be tiered, as the current architecture requires a physical device
  for zswap allocation.
* Vswap tiering [3]:
  Vswap should be handled transparently to the user. Vswap itself will
  not be tiered. But, someday supported if there is strong and real usecase.
* Relationship with zswap.writeback [4]:
  If zswap tiering is introduced, it could replace the zswap-only tier.
  However, since zswap cannot be tiered independently, it is still
  needed for non-vswap cases. Separately, the internal logic could
  potentially be integrated into the tiering logic.
* Tier demotion [5]:
  A separate interface like memory.swap.tiers.demotion might be needed.
  For now, we only support 0/max to enable/disable tiers. In the future,
  we could introduce an "auto" mode to automatically scale the limit
  based on swapfile size and memory.swap.max, similar to the direction
  memory tiering is heading in.

I plan to apply the swap tier infrastructure and the first use case
(cgroup-based swap control) first, and continue following up on the
discussions above.

Overview
========

Swap Tiers group swap devices into performance classes (e.g. NVMe,
HDD, Network) and allow per-memcg selection of which tiers to use.
This mechanism was suggested by Chris Li.

Design Rationale
================

Swap tier selection is attached to memcg. A child cgroup may select a
subset of the parent's allowed tiers.

This
- Preserves cgroup inheritance semantics (boundary at parent,
  refinement at child).
- Reuses memcg, which already groups processes and enforces
  hierarchical memory limits.
- Aligns with existing memcg swap controls (e.g. swap.max, zswap.writeback)
- Avoids introducing a parallel swap control hierarchy.

Placing tier control outside memcg (e.g., via BPF, syscalls, or
madvise) would allow swap preference to diverge from the memcg
hierarchy. Integrating it into memcg keeps the swap policy
consistent with existing memory ownership semantics. There are
also real use cases built around memcg.

In the future, this can be extended to other interfaces to cover
additional use cases.

I believe a memcg-based swap control is a good starting point
before such extensions.

Use Cases
=========

#1: Latency separation (our primary deployment scenario)
  [ / ]
     |
     +-- latency-sensitive workload  (fast tier)
     +-- background workload         (slow tier)

The parent defines the memory boundary.
Each workload selects a swap tier via memory.swap.tiers.max according to
latency requirements.

This prevents latency-sensitive workloads from being swapped to
slow devices used by background workloads.

#2: Per-VM swap selection (Chris Li's deployment scenario)
  [ / ]
     |
     +-- [ Job on VM ]              (tiers: zswap, SSD)
            |
            +-- [ VMM guest memory ]  (tiers: SSD)

The parent (job) has access to both zswap and SSD tiers.
The child (VMM guest memory) selects SSD as its swap tier via
memory.swap.tiers.max. In this deployment, swap device selection
happens at the child level from the parent's available set.

#3: Tier isolation for reduced contention (hypothetical)
  [ / ]                    (tiers: A, B)
     |
     +-- workload X        (tiers: A)
     +-- workload Y        (tiers: B)

Each child uses a different tier. Since swap paths are separated
per tier, synchronization overhead between the two workloads is
reduced.

Future extension (Follow up)
============================

#1: Intra-tier distribution policy:
  Currently, swap devices with the same priority are allocated in a
  round-robin fashion. Per-tier policy files under
  /sys/kernel/mm/swap/tiers/ can control how devices within a tier
  are selected (e.g. round-robin, weighted).

#2: Inter-tier promotion and demotion:
  Promotion and demotion apply between tiers, not within a single
  tier. The current interface defines only tier assignment; it does
  not yet define when or how pages move between tiers. Two triggering
  models are possible:

  (a) User-triggered: userspace explicitly initiates migration between
      tiers (e.g. via a new interface or existing move_pages semantics).
  (b) Kernel-triggered: the kernel moves pages between tiers at
      appropriate points such as reclaim or refault.

#3: Per-VMA, per-process swap and BPF:
  Not just for memcg based swap, possible to extend Per-VMA or per-process
  swap. Or we can use it as BPF program.

#4: Zswap and vswap tiering:
  Tiering applies to the vswap + zswap combination.

#5: Vswap on/off control:
  Currently not supported. If a strong use case arises where vswap needs
  to be controlled by memcg, the tier interface could be used for it.

#6: Per-CPU swap allocation caching:
  Per-si/per-tier per-CPU caching of allocations to reduce contention in
  the tier-filtered allocation path. 

Experimentation
===============

Tested on our internal platform using NBD as a separate swap tier.
Our first production's simple usecase.

Without tiers:
- No selective control over flash wear
- Cannot selectively assign NBD to specific applications

Cold launch improvement (preloaded vs. baseline):
- App A: 13.17s -> 4.18s (68%)
- App B: 5.60s -> 1.12s (80%)
- App C: 10.25s -> 2.00s (80%)

Performance impact with no tiers configured:
<1% regression in kernel build and vm-scalability benchmarks

Change log
===========

v9
- Added selftests (per Nhat's request):
 - selftests/mm: swap tier configuration test for /sys/kernel/mm/swap/tiers.(#5 patch)
 - selftests/cgroup: swap tier routing test for memory.swap.tiers.max. (#6 patch)
- Removed the redundant rcu_read_lock() around the memcg tier-mask tree walk;
  for_each_mem_cgroup_tree() already takes RCU internally and returns each 
  memcg with a reference held. (#3 patch)
- Sashiko review: swap_sync_discard() now honors the memcg tier mask, so the
  discard fallback no longer drains clusters on disallowed tiers. Left as-is:
  the cgroup tree walk under spinlock (bounded by cgroup.max.descendants, an
  admin-controlled limit, and triggered only by infrequent tier writes) and
  the pre-existing swap_avail_lock drop in swap_alloc_slow(). (#4 patch)
- Dropped patch #4's Reviewed-by tags (Nhat, Kairui, Baoquan): the
  swap_sync_discard() change above modifies that patch (the tier mask is now
  passed as a parameter into the alloc and discard paths), so the earlier tags
  no longer apply. Re-review would be welcome.
- v8 link: https://lore.kernel.org/linux-mm/20260617053447.2831896-1-youngjun.park@lge.com/

v8
- Changed the memcg interface to memory.swap.tiers.max.
  Values are '0' (disable) and 'max' (enable). Default is 'max'.
- Addressed Sashiko's review: Update the mask value atomically at once and
  read the mask value while grabbing lock.
- Collected review tags from Kairui and Nhat.
- Rebase on recent mm-new
- v7 link: https://lore.kernel.org/linux-mm/20260527062247.3440692-1-youngjun.park@lge.com/

v7
- Collect Baoquan's review tag
- Baoquan's feedback on fixing improper comment
- Minor code adjustments per Baoquan's feedback.
- Rebase on recent mm-new
- v6 link: https://lore.kernel.org/linux-mm/20260421055323.940344-1-youngjun.park@lge.com/

v6
- Sashiko AI review fixes
 - Fix batch parsing error path to restore snapshot before exit
 - Reject overlong tier names to prevent truncated duplicates
 - Avoid restoring raw list_head via memcpy (stale pointer risk)
 - Ensure early parse errors do not skip DEF_SWAP_PRIO validation
 - Use (1U << TIER_DEFAULT_IDX) to avoid signed shift UB
 - Defer tier mask inheritance to css_online() to close race window
 - Add READ_ONCE()/WRITE_ONCE() for tier mask accesses
- Other fixes
 - Fix build error reintroduced due to missing v5 change
 - Fix WARNING in folio_tier_effective_mask by adding rcu_read_lock()
 - default number of swap tier max (change to 32->31, for reserving last bit)
 - commit message refinement.
 - rebased on recently mm-new
- v5 link: https://lore.kernel.org/linux-mm/20260325175453.2523280-1-youngjun.park@lge.com/

v5
- Fixed build errors reported in v4
- rebased on up to date mm-new
- Minor cleanups
- Design docs with validation (by Shakeel Butt discussion)
- v4 link : https://lore.kernel.org/linux-mm/20260217000950.4015880-1-youngjun.park@lge.com/

v4
- Simplified control flow and indentation
- Added CONFIG option for MAX_SWAPTIER (default: 4)
- Added memory.swap.tiers.effective interface
- Reworked save/restore logic into snapshot/rollback model
- Removed tier priority modification support (deferred)
- Improved validation and fixed edge cases
- Rebased onto latest mm-new
- RFC v3 link: https://lore.kernel.org/linux-mm/20260131125454.3187546-1-youngjun.park@lge.com/

RFC v1 ~ v3
- Change the direction after discussion with Chris-Li
- apply some LPC feedback.
- RFC v2 - https://lore.kernel.org/linux-mm/20260126065242.1221862-1-youngjun.park@lge.com/
- RFC v1 - https://lore.kernel.org/linux-mm/20251109124947.1101520-1-youngjun.park@lge.com/

Earlier Approach (per cgroup swap priority)
- v1: https://lore.kernel.org/linux-mm/20250716202006.3640584-1-youngjun.park@lge.com/
- RFC: https://lore.kernel.org/linux-mm/aEvLjEInMQC7hEyh@yjaykim-PowerEdge-T330/T/#mbbb6a5e9e30843097e1f5f65fb98f31d582b973d

Reference
=========

[1] https://lore.kernel.org/linux-doc/aiw2p5ANjsQUCIHA@linux.dev/
[2] https://lore.kernel.org/linux-mm/CAKEwX=Nz9SWcEVQGQjHN8P8OANJY4BG0w+iQOzoNOWuteoVjAg@mail.gmail.com/
[3] https://lore.kernel.org/cgroups/CAKEwX=O23a4iWBZoewKVb8QqODte6r3Xijckw3_oCJNoiO9M5A@mail.gmail.com/
[4] https://lore.kernel.org/linux-mm/CAO9r8zOg0OP1Ak1v7CRzSfQq0D8b4Dw+_T0Jui6YTM_KwQQNOA@mail.gmail.com/
[5] https://lore.kernel.org/linux-mm/CAO9r8zNi4-QC4sUi=xXWHt9WMeG39mbyoSf8kON9vLOZ=cbCmw@mail.gmail.com/

Youngjun Park (6):
  mm: swap: introduce swap tier infrastructure
  mm: swap: associate swap devices with tiers
  mm: memcontrol: add interface for swap tier selection
  mm: swap: filter swap allocation by memcg tier mask
  selftests/mm: add a swap tier configuration test
  selftests/cgroup: add a swap tier routing test

 Documentation/admin-guide/cgroup-v2.rst       |  20 +
 Documentation/mm/index.rst                    |   1 +
 Documentation/mm/swap-tier.rst                | 159 ++++++
 MAINTAINERS                                   |   3 +
 include/linux/memcontrol.h                    |   5 +
 include/linux/swap.h                          |   1 +
 mm/Kconfig                                    |  12 +
 mm/Makefile                                   |   2 +-
 mm/memcontrol.c                               |  67 +++
 mm/swap.h                                     |   4 +
 mm/swap_state.c                               |  75 +++
 mm/swap_tier.c                                | 477 +++++++++++++++++
 mm/swap_tier.h                                |  76 +++
 mm/swapfile.c                                 |  34 +-
 tools/testing/selftests/cgroup/.gitignore     |   1 +
 tools/testing/selftests/cgroup/Makefile       |   2 +
 tools/testing/selftests/cgroup/config         |   2 +
 .../selftests/cgroup/test_swap_tiers.c        | 500 ++++++++++++++++++
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 tools/testing/selftests/mm/config             |   2 +
 tools/testing/selftests/mm/run_vmtests.sh     |   5 +
 tools/testing/selftests/mm/swap_tier.c        | 323 +++++++++++
 23 files changed, 1762 insertions(+), 11 deletions(-)
 create mode 100644 Documentation/mm/swap-tier.rst
 create mode 100644 mm/swap_tier.c
 create mode 100644 mm/swap_tier.h
 create mode 100644 tools/testing/selftests/cgroup/test_swap_tiers.c
 create mode 100644 tools/testing/selftests/mm/swap_tier.c


base-commit: cdad4d4e4fc2e5acb9a8b2cac9af6ce87c92656f
-- 
2.48.1


