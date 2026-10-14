Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22906CC6B30
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 22:25:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C64A56B008C; Wed, 14 Oct 2026 18:25:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C159C6B0092; Wed, 14 Oct 2026 18:25:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2B5F6B0095; Wed, 14 Oct 2026 18:25:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 909346B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 18:25:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 297971C41C1
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:25:04 +0000 (UTC)
X-FDA: 85322663328.10.24EC197
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5FDB22000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 22:25:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GiJtlHTS;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792016702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Q7Ub4KDl09XJRSF6d4W+ZBSqnX35V2vs0yWYMavxzk8=;
	b=TEbRl/Ij1IG2ChIQPFU0H5xo+KSW0xtHTn5GtmjNUIsFLcjDCyS4RNWxe9ad2qqfQGRsZL
	hvN9dlfGdbXD01TyFC+r/FypRQE9JY+weu2lW75aglv2grgNUxyTZvq/Yw8myhLC3t/Md8
	VdNYc6bwl7jFBMMrRAa+kyogocsub98=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GiJtlHTS;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792016702;
	b=2w8y0QED3B8SpClOTrFieANwdbrOB5Q7swYyLQBv6/HdMdpyKYFGXT+Luv6XLMA9DgY5Ay
	ct4E7c3iBupucYIUlwdxnqhoDdpjk5WFszWwseEp0Vvc2vIYSXGRBJJvY8oBfvNfxpU97M
	EwnfxW3/PR4x7yYBMLYI6VPTG3Df/TA=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-53505bc6524so16777561cf.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792016701; x=1792621501; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q7Ub4KDl09XJRSF6d4W+ZBSqnX35V2vs0yWYMavxzk8=;
        b=GiJtlHTSHtpzpBhsEV1Cl8upZhWxy8YeUMDM9gHtqYSBcosoqaQCdvAVnZ+sInnTu7
         oktZkhxOWdBc3WjFCFUVKOFWpr+98aXufFvs8QRik0JNktmHk5GnigAE4IZkF24raB5O
         eMAP27yd5wmWsa7RmB7bLOIfCDx3mWcWOqnbWaAokRNFutIUqyzNsjnqvduTgBQfnuOq
         35vM7SrfRmvWESeuf5KpTXVlI33vA8gml9aVvfQl+emTJ/Bq7g+MmqaDQr0zIAla6hsu
         tlR8+H0wevhZrUMQeBjEht9Ktpb4cqhaqg9mBRTrwhIFlAqowA0eyQtE7IbuXCp5+sNV
         SXBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792016701; x=1792621501;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q7Ub4KDl09XJRSF6d4W+ZBSqnX35V2vs0yWYMavxzk8=;
        b=PsDGJHQQ2H8X1Gp6X28N/bN6QrSTL30zBugOc6g2QU5iiZ/s8Z8defPIbfFDh0v5UO
         OmlQTLQd3febdaezQIDIKj5LTbuMNUrGLp0F17V2+/XbKcI3Y/n4N92xTPqrdM6du0sj
         Ras9EukTGFyy10cwK71WaLYy+PCwT3a2zyQQxdw5048Li+7zOgbpMuviGK/1VOoR+69v
         /FpYVT5qiNZ/eKL2zs3RX4oQXoONC1ZDuEMgMQplr5hE1RuWT+v8VfsRZpevwI95FWvK
         UQNt3lWgev/tzO3TtbK/AseDZuggh+8WJEzAJQI211AeIpeNA8XO+CbZNvRj/xUgDJc8
         cthg==
X-Gm-Message-State: AFq9FYKE/ERFPegi8sw9LWjKGS9v3z606YzWjSatgbMVsCHAn72A+/lX
	oERrKpwBsJbBd/QOPBj/JYazrYYNS+IQUE8k0zcy0sE8djdY0KtzlV7tTrpG1/kpebzIQeXgAFF
	2Uv6QCOw=
X-Gm-Gg: AYBFou2BF8hh8m+v2kPScMsIKmRc393PuzprMOpRUoFzQSFmjnwmOHQmJZyt5U/p2A+
	F1K7ADjEV727+H+D72JRMigCtqdKxAhv3+h9G5hU+UgKww0iBy+lhYuO0GbsFRhL9iTUtgMqOQF
	mmjbcmUNC5l58HAg0kS/s1Cyvu8FhXvcGZVyLaX3FVbNZBMWROsgKb1EOR28z/fVqhuXPUdpptN
	gaMxbGvkET63QDn6Qebn5UYoooKj46J389brPelp4+01UM3gQuHisTh99BRBdeunlQvqA8vMHe2
	HyRi2pg0tsDufV6FUz0Fyrd79rSQj++SXSERooEbSc2f62ScmLEKn4/5GD4z7DrIooZ+ZqQN1Xz
	uvskYZ9Sv67OKAgUpPJ+8BblfbYZbRRJIVdq3Rv2frq70zB/aLEV2rasHI2OeeK7btNdkRMriV0
	x225YFRDap96RUTobE2uRNKZN+LtkhI4XmnrVG3waFRl4eO7poW2hN4qH6x7jHHokDQHxEwFcLC
	SUID0gYesJ+QRKcEh3XUY1G2ORADQ/iHsffUT6LcUPdXYiJySuFrFSC5qVK
X-Received: by 2002:a05:622a:551b:b0:535:70b3:fa09 with SMTP id d75a77b69052e-535a628f4bfmr260621911cf.37.1792016701507;
        Wed, 14 Oct 2026 15:25:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536128418b2sm8652601cf.30.2026.10.14.15.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 15:25:00 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	david@kernel.org,
	mgorman@techsingularity.net
Subject: [PATCH 0/2] mm: fix two allocator races with zonelist and cpuset updates
Date: Wed, 14 Oct 2026 18:24:54 -0400
Message-ID: <20261014222456.2318284-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5FDB22000C
X-Rspam-User: 
X-Stat-Signature: aycypgwyc554kcuz9bybp8pu3mi8ee8h
X-HE-Tag: 1792016702-570952
X-HE-Meta: U2FsdGVkX1+Pi6zOryg+J8GIksQnLfWrQt3sPN5uJa+W0WXF5/1cjawkt3kLAW0l2KckvFSh/DlO7NiaVbh1A3/yeo5J+4EbWUy49O7dawQpNeaVlgtmB3/YJQ7DK/p5+3jP5plISuBrYI83vdflgGu40+DoUYH0RU5G6ivzz3JrTA+uX+QPGGN+DDmxfk3hBWitWErX5hcR/gSmcBegNA0CBUHO0Lz77hedqqv+aitzd8zNNt+A1bTato0aT2TdZ5NsryLxhjnVcqKv9wZT/u+X8pj5QfJRxH9soF9G1uI3fcQVgxeAWwCXuVtAXqORbLZxww+rmM3k6BDwVBLlPX+mvrnsbKOtuWgpUjKXpUYVtiSMCbapjCuWoCbPi5/RlhLPZKV5+e0bZJrH27z+uXHu1fXK+PENVz623MPwXcmBxwzI8JnxgHS7DiJrNxY2Omvl63c7NTyPukVokhCoyaHwcFr/AJC7wI3amWrUPlFRvTGfCLjjBpvDJGcmyOX85/3dlw/XZsYxU+QszAw+TmvEVBpVeVt87c0j07kGXo6pGVfxbB7IaF6Q/qyz9mPQJt0/TsAq6e7+j+58qHdyxqgrLuv8AGpQreKh2zPzYR6PAQAi19UbxVuEv+hpUEjLWIw7OKz/tJa+jzv6Sesjt2UJk/GVDIYfm+XE/CKlJVGq1wSHn5LtTjsXy6eQiReW4QQQiwtz08SzJKoLNgrP7cpVylCMVpYPqrLNYs/Oif5uTbrXfMG8CbrJwMi7clImesRXNLK14nTQ2yb7DNAzef3FYeDkBycEJE41021DlqimXY2a1kHDVk0vWV0YdvKLkBzeYszJSjlzn06/EdRP4zJ6TJQqgBEeaRYlQ9663re1xuWoVAjSZfvl2aIqoQMVmapugJC0VqbSnCbZ73xSVfCDynSKVGpOBTbCBjGeC0Cii+zBxLCdO/6Ilal97mBBTHw65kfvAMK5QahaqqO
 ITFBnsEP
 McfkNalUtIT/p6FMO0J4h5cJNHV25VyjdFDDtNwWVqpa3KHGTklznV+134h5mQwUrMjtCeWg//XjrB3e1+r6CSpHTpQK9mRZaNeFX8z2MMko/OnvNBSgzubrYSnJPkI7RehtYXS2tpzll/MAaDtUGazTMoT8Tx92mEX4Es1PrSa+rrm4WG+Y9/tii0kJwLxnFEGZ2L+dvui+u0gOszU7Gf1RJ4ZjocxT2uZj0XTRyVptT/Nlc1IVWPPQ1Dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two small fixes for lockless allocator checks that can act on an
inconsistent view of state another CPU is updating.

Neither of these are stable-worthy.

Patch 1: the zonelist_update_seq retry is compiled out without
CONFIG_MEMORY_HOTREMOVE, but memory hot-add can also cause the race.
A __GFP_THISNODE allocation can observe this and fail to allocate.

Patch 2: cpuset_nodemask_valid_mems_allowed() compares a mempolicy
nodemask with mems_allowed without mems_allowed_seq. A concurrent
cpuset update can cause a spurious empty intersection and end up
relaxing an MPOL_BIND needlessly. This only covers task policies.

Reproducers
===========

Both races were reproduced on an unmodified kernel in a QEMU guest with
three NUMA nodes:
   node 0: 3G, CPUs 0-1
   node 1: 1G ZONE_NORMAL, CPU 2
   node 2: 1G ZONE_NORMAL, CPU 3

And a 512M pc-dimm cold-plugged on node 1, left offline at boot
(CONFIG_ACPI_HOTPLUG_MEMORY=y, CONFIG_MEMORY_HOTREMOVE=n).

The windows are a few instructions wide, so I used a test module to
widens them with a kprobe placed on a single instruction inside the
window.  This basically emulates an interrupt or vCPU preemption.

Patch 1 (zonelist):

  Online node 1's first memory block as ZONE_MOVABLE, which rebuilds
  node 1's zonelists.

  Stall the rebuild after it writes ZONE_MOVABLE into the first entry
  but before it writes ZONE_NORMAL into the second.

  On another CPU, allocate GFP_KERNEL | __GFP_THISNODE from node 1.

  Before: the allocation fails, 3/3 runs.
  After:  the allocation waits for the rebuild and succeeds, 3/3 runs.

Patch 2 (cpuset):

  Put a task in a cpuset with mems={0}
  set_mempolicy(2) the task to MPOL_BIND={0}
  Run the task on node2 (yes this is a little flagrant).
  
  Fill node 0 with HugeTLB pages to make allocations fail.
  Stall between the two loads in cpuset_nodemask_valid_mems_allowed().

  While stalled, change cpuset.mems={1,2}, this rebinds the task
  mempolicy to MPOL_BIND={1}.

  The check compares the old mems_allowed (0) with the new policy (1),
  finds no overlap, and drops the nodemask.

  Before: the allocation lands on node 2, 3/3 runs.
  After:  the allocation lands on node 1, 3/3 runs.

Gregory Price (Meta) (2):
  mm/page_alloc: detect zonelist rebuilds from memory hot-add
  cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask

 kernel/cgroup/cpuset.c | 13 ++++++++++++-
 mm/page_alloc.c        |  4 ++--
 2 files changed, 14 insertions(+), 3 deletions(-)

-- 
2.53.0-Meta


