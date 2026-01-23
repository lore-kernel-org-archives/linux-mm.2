Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2823D6CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 670226B03AF; Thu, 22 Jan 2026 23:57:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61A6F6B03B1; Thu, 22 Jan 2026 23:57:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2166B03B2; Thu, 22 Jan 2026 23:57:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3661E6B03AF
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:57:44 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 949B9D2515
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:57:43 +0000 (UTC)
X-FDA: 84362020806.30.705CEE9
Received: from mail-yw1-f193.google.com (mail-yw1-f193.google.com [209.85.128.193])
	by imf20.hostedemail.com (Postfix) with ESMTP id CBF751C0004
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:57:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LxfHnfwS;
	spf=pass (imf20.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769144261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EJkgvPZFHCE7A0AwblR4LoBvEnU1RF29gonEpvLNZc8=;
	b=SybY1Q1Y+4rwnACzBC/gj6dOhS8M8mPx/8OBZ9uXlczG0WGiwrCuthkgOZFugGmD2CmQXK
	DRH52G3vAJnMQgBwl206J4/aWkAw7oNNd8jySFb/SXkHCdzQ4S+1eeK4U8eUfYqi4lD5cf
	f6MBhinMCoTjIhNY8g/uubwcPEY6/GA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LxfHnfwS;
	spf=pass (imf20.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769144261; a=rsa-sha256;
	cv=none;
	b=qOgrd3stvEfFuD4A0ph1BAFJS73dIF5o8Z8OLjgA8BFYc1vK/BpGbr6iAl40/zU33RWw6+
	hPfVHbDJde7530YK8S63N3JmYDlbPX9Omb0OvEoqq5QPPIWStGKQFngS43As/TYoNVj42Y
	u6RwdiW4+xMDf0W13Xk+KcFktQjMnR4=
Received: by mail-yw1-f193.google.com with SMTP id 00721157ae682-79430ef54c3so13881867b3.2
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 20:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769144261; x=1769749061; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EJkgvPZFHCE7A0AwblR4LoBvEnU1RF29gonEpvLNZc8=;
        b=LxfHnfwSFZw4enHkYJIKfDN+Z+HOYbwZkS+8mzFnvoTJPPYUtQn9HhXXYBvmflfqlF
         iVeu0JiZ79O7MW9dfhwCe3esXDl2xw56onaA/EWGqwnBcxaPvGw/2uwvBlEF1cxXGvlt
         LKN5JoSuhq0VMGG+n3F5PiMb32NF+BZblKulboRAUqudc9lIuYMq9SX4OBkkIuADHvPn
         aRghUxilo3MG34Fk98ukOOknhfn0b6sZ4L1H1ya3X0HzFLqypx72fLiXeiw1z5jvAsif
         uZwpDArLTZHZgHNxJJ4o6UhL/SBWgEP+kSixfnJcMWgiulawRuB6MBWb1bR1RIiTyN7L
         n44w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769144261; x=1769749061;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJkgvPZFHCE7A0AwblR4LoBvEnU1RF29gonEpvLNZc8=;
        b=JnHsnRq7kY2cJg+JtcmMiK3FXn3XeDY/ynpk9VuaVD7PQh1mto6Nw0+MvURLqxsF3Z
         Gf2tvS0YPB+P30jgd2YAfN9lETvLNZKpfO1fJArMINpC6JUYaJg2G/14hUaj2Y5V+//4
         sXtT+sCCN5CkbnvzWFQe6uKqvN3oXMS856Z4NVBGn3YgipmH40Nrus659iVPZ6IRARsG
         LOXj5t7eRbUkEHX/KWD3egX7kuQmsZNIeg8bfaCo0+AUFU8Nre6GMM/Bogw9DKz7L7/R
         Cnu6Suyw0jaD1RFTwcbwoINP+Tjs4FLIgRHcfLJ3fHG261toF4NCpxPqgrC5O+BO7FmR
         68qA==
X-Forwarded-Encrypted: i=1; AJvYcCUpb9o7JM7znW0QbcSiB8h29sHTjiX7i5q6iRoRji5CGf+J1OK1r0/ikTImzIw5v+WPcZwQ7/Dhdg==@kvack.org
X-Gm-Message-State: AOJu0Yz2ebm39cDSx62jEcvOkG7jfpDAQ0fXIK8HU94GZQJE41zqFDUv
	mncyFRAyKYq9FSHswQ7DPXYXgwez2NIX6Bq4RFKvu+GEmMDz4yW4T2w=
X-Gm-Gg: AZuq6aJNGl69SR0yiwVYdH7zqgfl0zNSthihozAQ9AzJCIQBB5Nl03U8rrH4huXztxS
	wbTtea5GX9xbLD+/Ya7Dn4VlM43s7OsvVTiykATxb48LXQAVC5Q5EHFrwjU36Coa5LXvjQTPsQk
	lAnNMclMSnxxJJUjvMJDLnuRUx6FcJHt5s3A8DB6rCBTkrQ+iBY65Mgwf4Cx1Q9EXUHtVIbyDSy
	qXLL8ODCpcfHxaSUTvDHtSVH0HBAnl2IGXV8UHGgJy9lOZh9kw+SJpLknOLfWTSvqhP3IXJ8qOc
	QD8YcQS/FByBiCktiaaSWdeACZAxmkEZolRbJZkeuEwR7bRnmAZCRTmr/5s4b+CqgV9w3NhRZSr
	BGE8jGeBt7g3G+Jeg7/G7MgWsDjh8t12dtuY6Xy4J01x1Jj/VlDGRTTOjdL02/bJbcRGQDawZOB
	1073JaeChpSp+/YPSkRYfu7ndlrq01LOwTgLRwd+6hpFhW4bwcPKC/OauGb1zKDw==
X-Received: by 2002:a05:690c:4444:b0:794:93e:d0f8 with SMTP id 00721157ae682-794398be450mr16665047b3.7.1769144260705;
        Thu, 22 Jan 2026 20:57:40 -0800 (PST)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7943af13d6dsm6408937b3.9.2026.01.22.20.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 20:57:40 -0800 (PST)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: [RFC PATCH 0/5] mm/damon: Add node_sys_bp quota goal metric for PA-based migration control
Date: Thu, 22 Jan 2026 20:57:23 -0800
Message-ID: <20260123045733.6954-1-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CBF751C0004
X-Stat-Signature: cjx4s6sbpuszuqhbjdtguq1owmh98qmd
X-Rspam-User: 
X-HE-Tag: 1769144261-927514
X-HE-Meta: U2FsdGVkX19g4wskc1wXjU6pey1mq/9EK83UkvvdbLHf44iTTEfPI9XDS4GcU081+0WfJ3+5yySZQYazolWBjYHbs7QWC/mM82oq5lE5TglnJbJqEXJ/ZeIrxV4T8qwj3ywqTRjCJ6k8m5jqy05EBO1aOMcDVp4aPSvEDid0Rp3CNl0qmkUJdPMA9eu2LSkJMqOzRXta/6QHC9EuJbB+g1ioxrXCXha+QM5a07kFZ7IjobaShsQ3veC2HsiR9asoPSccZkUP2H3EvJahJdJiv3B8o5ybmJitLIu9OayH9yp48GpDi1O6iQlqmawUhu7wtdDLb4JlvK7Je5e8V7nDu2SxdptXrA4oZ9EqFT2enn5rHoNDwcAM33JjGWf9vWcE+o+IlDF5iXjibgNxFbrjnd2jOEyo6I5QoRHYHysJ16rGrnIT7OGhMDO89ob9bTxtV87u9QA0atPZFtxcK0+HfCN5piY+dDiZQiAmTaVeNIfGPxJQs2aFfc4+VLSYx/je+D6qdkSLrLzoJWC15s56X+Q+EGQv/iouPT3M81aAn/FUNQii2xpQaPgX362HWtXl1muDZdD9m2g1Xsx+jjHvtwBjdpR/sQ0hD5G2kUrY9cHTM5FUramH+70d3VucEXYgUM5Rc9/kT3OnqGrfc6nR1a0jyMTSlg/ZFoNyj3818TwRS2r9psycsiVg2xvZOadU2fdaVd1et1MuUvuazJ26n5cqBGM5EfDlAayMth2LUUI3/eK3kEnLeQ4AYuqDa7hWClrf+VQrQSNjPgyqOvnVbRH2UDKy3CubhWCZTlxf/fDlxJMW3pPHodnKK8hCI9xo4B5lyCQI3GVbpdRJRxHD2j6sqczvC97bS3Ka9rvPtNOZuVSI3SVaVQA+iIQSASBQSpeIOFTNe/9Zj8h/Gwh7eMX4ySkxY4Kx1Gn3WZfkquW8fLZ+bkTB1pe1HCmAMeekGkGjkMp0a3nB9FNoBmz
 5twiSHx8
 DBJ/M74HGeOIT2YshJwvUd5UKglVqrc0XUkKDnl1urdddlslzOGHcgmounrRrWnhYmOsp9iGqqFdvTao2BSmNVJU41qJK2674PsEKU6uOY9D6JD6Kg+dyHJkI7MzQr3DmljZG9qPfK1HT3DeRbDMkweC15oZb2tQOTQHLC04b9roPpWf3cpiZe/wR8pVxkgaAgbS+5ljDdsfa8p3ImfWF98ta43+I+TX942vuFSet/XtwqY6cncb/kL60gckCCfk1EJDsvTsrjVr87iyMt8Gc9H0GuGHcMgDAv4RyHKLwsU1zrfm9VpoZXOE0M/DedRb2XnAMAfT1He6rHx2OMI4bb1pSKpzMU2ipldaSkFILChOipmZcfhE+cfn4HjOhNCRtoWQaJVYZpW+hadFgywrNKMO3YGNww4NLWZ9ooZHbkCGry0LqjLVIx3EnbwnfPZGzNAnAaKv+dE6QWl3mjWHK/+uKLx0LM21+UqZokCD3E1ExArL+711lIIEeBP17TFbDBABO7ZYTWskFa4kL1wpEMQcZP/mGfHUksCr0v0GnqP6XwkA78bxTroFlzYgnI9v7f/Ug/Qy0d1zqom8ycVNF3JMVQBEXnFDmq7cLG19RUfW+fIy1Qk5VP4YxV3GwH2y/SmAT9N1ZM6FViYBHqVKG2jcQLrj7naIuikQjwZnrDJHvWJlNMn4opUI5pqWOFEo1D93ExF4RNK4+MQfiF7aDx+78OKCCdvsH9bjUQjX9gaWjHel6QWCQhDTj7DaXXkm13c+M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces a new DAMON quota goal metric, `node_sys_bp`, designed
for controlling memory migration in heterogeneous memory systems (e.g.,
DRAM↔CXL tiering). These patches are provided as an initial RFC and have
not been tested on actual hardware.

Background and Motivation
=========================

A previous patch series [1] by Bijan Tabatabai and myself added weighted
interleave support for DAMON migrate_{hot,cold} actions. That series
implemented the feature for vaddr (virtual address) schemes because the
weight-based approach requires VMA offset information to determine target
nodes:

    target_node = (vma_offset % total_weight) → node_from_weights

For paddr (physical address) schemes, obtaining VMA offset requires costly
rmap (reverse mapping) walks. As noted in that series:

    "However, finding out how a folio is mapped inside of a VMA requires
     a costly rmap walk when using a paddr scheme. As such, we have
     decided that this functionality makes more sense as a vaddr scheme."

This new series takes a different approach that enables PA-based migration
WITHOUT requiring rmap walks, by using basis points (bp) target-state goals
instead of weight-based action rates.

The rmap Cost vs Oscillation Trade-off
======================================

For PA-based migration with weights, there are two possibilities:

  1. Weight-based with rmap:
     - Use rmap to find VMA offset for each physical page
     - Apply weights based on VMA offset (same algorithm as VA)
     - Works correctly: VMA offset provides stable identity
     - Problem: rmap walks are expensive for every migration candidate

  2. Weight-based without rmap:
     - Attempt to apply weights using only physical address information
     - No stable identity across migrations
     - Results in page oscillation (see below)
     - Not viable

The Oscillation Problem (Weights Without rmap)
==============================================

Weight-based migration relies on a stable identifier to determine which node
a page "belongs to". For VA, this is the VMA offset - it remains constant
regardless of which physical node backs the page. For PA without rmap, no
such stable identifier exists.

Consider a two-node system with weights {Node 0: 40, Node 1: 60}:

  Initial state:
    Hot pages on Node 0: PFN 0x1000, 0x1001, 0x1002, 0x1003, 0x1004
    Node 1: empty

  Iteration 1 - Weight-based selection (no rmap):
    System tries to achieve 40/60 distribution
    Selects pages at PFN 0x1002, 0x1003, 0x1004 (60%) for Node 1
    After migration, these pages get NEW PFNs on Node 1:
      PFN 0x1002 → PFN 0x5000 (Node 1)
      PFN 0x1003 → PFN 0x5001 (Node 1)
      PFN 0x1004 → PFN 0x5002 (Node 1)

  State after Iteration 1:
    Node 0: PFN 0x1000, 0x1001 (40%)
    Node 1: PFN 0x5000, 0x5001, 0x5002 (60%)

  Iteration 2 - Weight-based selection runs again:
    System sees pages at PFN 0x5000, 0x5001, 0x5002 on Node 1
    These are "new" pages from the system's perspective
    NO MEMORY that these were just migrated FROM Node 0
    Weight-based logic may select some for migration back to Node 0

  Iteration 3, 4, 5...:
    Same pages continue bouncing between nodes
    Each migration changes the PFN, erasing any "history"
    System never converges to stable state

The fundamental issue: weights define an ACTION RATE ("migrate X% of
candidate pages to each node") rather than a TARGET STATE. Without stable
page identity (which rmap provides via VMA offset), the system cannot
determine which pages have already been "handled" and continues to
reprocess the same logical pages indefinitely.

With rmap, the VMA offset provides stable identity - a page at file offset
0x1000 always hashes to the same target node regardless of its current PFN.
Without rmap, we have no such anchor, and weights become meaningless.

Solution: bp-Based Target State Goals
=====================================

Instead of specifying action rates, `node_sys_bp` specifies a TARGET STATE:

    "Node N should contain X basis points (X/10000) of system memory"

The migration control loop:

  1. Calculate current_bp: sum bytes per node across monitored regions
  2. Compare: if current_bp >= target_bp, STOP (goal satisfied)
  3. Otherwise: continue migrating toward target

  Example with target: "Node 0 should have 4000 bp (40%)"

    Iteration 1:
      current_bp = 10000 (100% on Node 0)
      target_bp  = 4000 (40%)
      current > target → migrate cold pages away from Node 0

    After Iteration 1:
      current_bp = 4000 (40% on Node 0)

    Iteration 2:
      current_bp = 4000
      target_bp  = 4000
      current >= target → STOP, goal satisfied

    No oscillation - migration stops when target state is reached.

No page identity tracking needed because we measure the END STATE, not
which specific pages were moved. The early-exit prevents oscillation by
stopping when the goal is met.

Why get_goal_metric() Ops Callback
==================================

The bp calculation requires iterating over monitored PA regions:

    for (pfn = start_pfn; pfn < end_pfn; pfn++) {
        if (page_to_nid(pfn_to_page(pfn)) == nid)
            node_bytes += PAGE_SIZE;
    }
    bp = node_bytes * 10000 / system_total;

This requires address-space knowledge that only the ops provider has.
Existing goal metrics (PSI, node_mem_*, node_memcg_*) are computed in
core using system-wide data that doesn't require iterating monitored
regions.

The new `get_goal_metric()` callback in `damon_operations` allows:

  1. Core to remain generic - handles all common metrics
  2. Ops providers to implement metrics requiring region iteration
  3. Clean separation - PA implements node_sys_bp, VA could add
     different metrics in future
  4. Optional implementation - ops return 0 if metric unsupported

This design ensures node_sys_bp is only computed when using PA contexts
where it makes sense, while keeping the core quota goal infrastructure
unchanged for other metrics and ops providers.

The callback pattern allows each ops provider to implement metrics
specific to its address space model without burdening the core with
ops-specific knowledge.

Advantages of PA-Based Migration
================================

PA-based migration with DAMON enables integration of multiple hotness
sources for migration decisions:

  1. DAMON's native access pattern monitoring
  2. Fault-based information (similar to NUMA Balancing)
  3. Future: Hardware monitoring units (e.g., CXL CHMU)
  4. Future: Instruction-Based Sampling (AMD IBS, Intel PEBS)

Unlike VA-based approaches tied to individual process address spaces, PA
monitoring can aggregate hotness information from multiple sources to make
system-wide migration decisions across the entire physical memory space.

Complementary to Existing vaddr Migration
=========================================

This series complements rather than replaces the vaddr weighted interleave
migration merged in 6.18:

  vaddr migration (weight-based):
    - Per-process control
    - Fine-grained interleave patterns via VMA offset
    - Deterministic placement based on weights

  paddr migration (bp-based, this series):
    - System-wide control
    - Target-state goals for node capacity management
    - No rmap overhead
    - Aggregates multiple hotness sources

Capacity Clamping
=================

The series also implements capacity clamping for `node_sys_bp` goals. In a
system where Node 0 has 40% of total RAM, setting a target of 50% is
impossible. The implementation clamps:

    effective_target = min(user_target, node_capacity_bp)

This prevents the quota auto-tuning from chasing impossible targets and
avoids thrashing in two-context DRAM↔CXL setups.

Patches
=======

  1/5: mm/damon/core: add DAMOS_QUOTA_NODE_SYS_BP metric
       Adds the enum value and documentation.

  2/5: mm/damon: add get_goal_metric() op and PA provider
       Introduces the ops callback and PA implementation that iterates
       monitored regions to calculate node_sys_bp without rmap.

  3/5: mm/damon/core: add new ops-specific goal metric
       Wires the new metric into core's quota goal evaluation, delegating
       to ops.get_goal_metric() for DAMOS_QUOTA_NODE_SYS_BP.

  4/5: mm/damon/paddr: capacity clamp and directional early-exit
       Adds capacity clamping and early-exit logic to prevent migration
       when goal is already satisfied.

  5/5: mm/damon/sysfs-schemes: accept "node_sys_bp" in goal's target_metric
       Exposes the new metric to userspace via sysfs.

Status
======

This is an early RFC for design review. The patches:
  - Compile successfully with no errors or warnings
  - Have NOT been tested on actual hardware

Feedback on the overall approach and design is appreciated.

References
==========

[1] mm/damon/vaddr: Allow interleaving in migrate_{hot,cold} actions (v4)
    https://lore.kernel.org/linux-mm/20250709005952.17776-1-bijan311@gmail.com/
    Merged in Linux 6.18


Ravi Jonnalagadda (5):
  mm/damon/core: add DAMOS_QUOTA_NODE_SYS_BP metric
  mm/damon: add get_goal_metric() op and PA provider
  mm/damon/core: add new ops-specific goal metric
  mm/damon/paddr: capacity clamp and directional early-exit for
    node_sys_bp
  mm/damon/sysfs-schemes: accept "node_sys_bp" in goal's target_metric

 include/linux/damon.h    |   5 ++
 mm/damon/core.c          |  34 ++++++++++---
 mm/damon/paddr.c         | 102 +++++++++++++++++++++++++++++++++++++++
 mm/damon/sysfs-schemes.c |   7 +++
 4 files changed, 141 insertions(+), 7 deletions(-)

-- 
2.43.0


