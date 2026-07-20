Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A60A2C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67E696B00D3; Mon, 20 Jul 2026 15:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608936B00D6; Mon, 20 Jul 2026 15:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CF4A6B00D7; Mon, 20 Jul 2026 15:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 14BED6B00D3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:36:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80F55A0212
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:36:08 +0000 (UTC)
X-FDA: 85010160816.12.18E0744
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id A911FA000D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:36:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IF4DSCmP;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576166;
	b=EJBiwV3BcQpXFx3MJGIoukBVkE8JwMD51j03TPsIfRMMQBxpCcCvq8KpfTzrSRItYSTAnU
	57XG78TtuAgv1FTLZ4eJzNA8r/nDXVRkWGqmYZUQlC7p+r/9y+CRbvL/dEi9bED0icI4kR
	LY7p0cztFw2anZMkwLNw9pZPUjOFzPs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IF4DSCmP;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DV5Z1tJXaWxvckL3peka95N+5/TymDiplHxo+CY2ByI=;
	b=5+FAOuNEkHIRo4tORrA97EJbRARcQ/slg17InQ19mPRr+iPCT1ydhGncT9qPpz1ZyN1/NZ
	L5TF5x34jA0uQ/XkanfKhLDRe1238lU3vBd7fBXezROyD0t1mwkqXFmqx19sE7KTwYnAuY
	hQtnBDkFQHo9SA8umoLV/+mwpUuncRs=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92ed19f4d60so369355385a.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576166; x=1785180966; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DV5Z1tJXaWxvckL3peka95N+5/TymDiplHxo+CY2ByI=;
        b=IF4DSCmPhlH405AUnP4u7FjbFGpwy6GMUX7ljEQ4gz6e3hrCYyjtTL2SyREtO/eTx6
         Q2+pJDPMZXg7R76GfddpSeOMU2o/UcP6q51A39bI4JpDqT6DG2eBh5G+aJO1xRvu/V6Y
         qkTez7O5Dy2IbLTYil33XTiscEm1SVLK79R4e/R0tr9rsjhIdVcBWp7h0hliznlyVJoK
         4n6bHP9mloJ0axv2Nah8CmE3D7KeKm12peVG/jt6kioKhV4yXnHSs8b+QDL+ubRYS97p
         iZ+Ks5a+11cZwfM3Im1scc6zOzo4vJ2RQXnpe7I8nxlW3DWoEwJMCX1vvHh4dmasg8xj
         9r/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576166; x=1785180966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DV5Z1tJXaWxvckL3peka95N+5/TymDiplHxo+CY2ByI=;
        b=adj0vDhNA3hXz4kNEFIKaRe42mq/7q3PskVHvLKcYyobVwAT9mdTwJsgBli6p8kveB
         hMPBTaAGeFGbx3KNJ7UXgn9dTN92oZxB9LQFvxQGszlDaJiwoovfjoPGJ0JvSQe+ISEh
         SsvyWnrPxwB6TMaa1bd3jkjxO2EuGlV0sYhh8SWrm6UGJWW48pUfEH9mJU7wzOUMnfIJ
         UA+Uwp6Tqw9OBB3kySKCEdjUCxcuilDAZCrCSB+W/VT+ua8nU4T9lg3WjvhzYnocbrPF
         s/MCbmZsCjNrrJeS6LkzjXOwhrnjPGuoJgJDp1LFy7Y3mEPeNTXh3wa08OFWBtx5e7wJ
         /3Ig==
X-Gm-Message-State: AOJu0Yy2LmwRF/lJUTKck6iCrVHn48ps+gMjmBwYbnlPur94jLD7HDHE
	PsAi8Vy2XRHPozRY1FcF2HsRtOLed5IxBL3KDbuIYNFvRqVtCWXejRiJm0pX5r38vpFaWVvZwWG
	uwbc/
X-Gm-Gg: AfdE7cl9QxHIaWD/272mTkTPog1S2v/EEnTNRQCIKypkoJzrTx35wr6v53tSiRU5ojh
	Map25Pkg4I7Evn1i+gM/SDu8iFbgRBEWNrTerzZeVEv1niwK8T9Wr6ieWHEIvMvSKjbop18XeV2
	OW8nDMDemqt62e4RZA7CYOlowpugGI2u1RITu3FBacHwBAH8nMc8mufzO18CyWp0MjwpjeZF0TJ
	gbwe0bViaphuoHgnkNWSQZs+uuTG/s/8IkOXbLAy+C9OxRNyuYChGKzgMJXzii/NdJTtza5Q49Q
	zS/WM+s2D8TQJql4L2a917XU74XsKiQet2rpVXrLtjWSfW0k0Pu/aEcJI1s11WuMZ//b/Qu3QrB
	1uq7EnYlROaXHnN2vK4+rMJHqeDAlSOlKLklPJKi+jzKLMHNyKZhWFTG/612NE+Wvl8EzSgAKB7
	WCIT2ItW2Hb2pfY/B0lvIoVgXfUrRdx6Qk3lyo1Uj4hWliazH6iCiZBG22U0I3HNM=
X-Received: by 2002:a05:620a:171f:b0:930:5a34:3882 with SMTP id af79cd13be357-930b482d3d6mr1498824485a.2.1784576165506;
        Mon, 20 Jul 2026 12:36:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:36:05 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 33/36] Documentation/mm: describe private (N_MEMORY_PRIVATE) memory nodes
Date: Mon, 20 Jul 2026 15:34:27 -0400
Message-ID: <20260720193431.3841992-34-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A911FA000D
X-Stat-Signature: ssfh61qc7pepr5wmzkwcja8ss16btpnx
X-Rspam-User: 
X-HE-Tag: 1784576166-658930
X-HE-Meta: U2FsdGVkX1+3LhhbP/UkVBMDbuKKSi7E7C/Qm8TakiC9ZGwR+E/Hwa3kPQMxHvZY2vZbVY5Pa1KRx+a0FabbhOH6Fnw6idHS5mNuDi2JwEzNIKNhHh7EaDQPUYoYTZ5oKOmCtp858mw2SZmoC/UR/c6xVnhzRzE+fC3xfiUbmdYHtO08aUzVIqibMDlWHj0BGRiHJih+HNmqf3QqJoA37FaUlv6tGwo3LPlKsQP5bgjlCexun3C1juIXUSvAgFnxgU38sWaLAgGbiGueH7MwmVUcdJcKFRxJ+qvDAwESKAzXtLJulRdoTG8K5JaLGfUrtxNSmePzrULTEB9f8KBcVrHcb/2fhGrPxOfbJ6lVz6goUF7LV1l+Ccy+XaPwPsMw8ouMW6/xgc5WiVmyP2BXdB6ax9oQGPRcqBUq8p/7kdJXREwgxwEPtXzedVDmWZWBShy5t9fhZcoE/KE6iaaHt+9K4Bjhe75JLg4duKOhspmpay2qsh72xoAM/37sJ/F2Ok90ECjX0QtwF1GWWMWG2UCy3QlqoH2P4O+RytTyqmUpsQ6li8VudVtumc2SCgvtqeE+mYrhNJ7TTQPO7+RW1YCawBK1WAI71/sanBoQEGZB/QYYSY3j+5nvfthJ8HetcTFaKbXHQsGILgyH/CBYog8q5dhXK258K0JQTkPdirXU+ezT8iismKE9A3dzqlGseVhM0HpBLiTB4APUj0eXDMtGbkMpHqSogFnbAaCd2cLjPlSsziLBKLetgSba6QunHW5cuqPzJF1OXICGRKWAcfdvhUOd2YvU2VX1Kt2V8orRF04xydIz9759mCJljk2vEKHzIvLoe0GcQLyDCZb1UrnacbT/vwuCg1f/oQDirmP0DNVhdW4Wtu+YYBDtYU4i3xXU22KBvg58MZxKBFnkoW1kbhJ8g8IxOEjNl5R0jKzvj1lf6VjIVUKmYFDoocH2nqpGVpPMzZtelUo8AEz
 XlA5SpIV
 UtGDctinPDyNLws79+16GaFctzmUxyQQM+V5VvgBOm7FjJOdAZaCcWtiVssfYCLYAfm0T60DDsnBW2ReTi5vNC70uqcl4LiKwA30KdcUZlgSLAAkAKldQCr00MZsXAYdMGN2GhPZkrl7Ns/LJGJdJTEFjt3sD7S2UL5QY/8Zq2wYkpMhrNIavkuG7ko5wXEBFvp2TnCLnUkKV0FFopjq/lps1VlFmQeiIKoLs1OZId9pggUSGRPg6xxOYsdDbOHeGPODALpPPhZwxBEwnXdyAC3ky0rgtoL/MSbTfSygoUjrHJo3OYDAKP02jBmQ8kTewwyLQ3o7eYBttc3dAy2NBOcd7npTDBz/+9clzN3RvzmXCt7yymM3il9uVatvYTxGCvodLRPvBDmYPNDd4SbuGu1hh9ty/B4qKaPf3NxqjBWZyRgg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a design overview of private memory nodes:
  - the isolation model (structural zonelist exclusion)
  - ZONELIST_PRIVATE
  - driver provisioning API
  - capability opt-in model and its dependency rules
  - observability surfaces

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 Documentation/mm/index.rst              |   1 +
 Documentation/mm/numa_private_nodes.rst | 160 ++++++++++++++++++++++++
 2 files changed, 161 insertions(+)
 create mode 100644 Documentation/mm/numa_private_nodes.rst

diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index 13a79f5d092c0..f60704df6104c 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -65,6 +65,7 @@ documentation, or deleted if it has served its purpose.
    mmu_notifier
    multigen_lru
    numa
+   numa_private_nodes
    overcommit-accounting
    page_migration
    page_frags
diff --git a/Documentation/mm/numa_private_nodes.rst b/Documentation/mm/numa_private_nodes.rst
new file mode 100644
index 0000000000000..3b27a2e24b086
--- /dev/null
+++ b/Documentation/mm/numa_private_nodes.rst
@@ -0,0 +1,160 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====================
+Private memory nodes
+====================
+
+A *private memory node* is a NUMA node whose memory is hotplugged by a driver
+and deliberately hidden from the kernel's normal memory management.  Such a
+node is marked ``N_MEMORY_PRIVATE`` instead of ``N_MEMORY``; the two states
+are mutually exclusive, so a private node is never considered by the page
+allocator's normal or fallback paths.
+
+The intent is to give a driver a block of NUMA-addressable memory that the rest
+of the kernel will not allocate from on its own, while still letting that memory
+be mapped into processes as ordinary, struct-page, LRU-managed folios -- and to
+let the driver re-enable individual mm services it is capable of allowing.
+
+Preconditions
+=============
+
+``N_MEMORY_PRIVATE`` and ``N_MEMORY`` are mutually exclusive, so the backing
+memory must come up on a node that has no DRAM of its own (otherwise the node
+would already be ``N_MEMORY``).
+
+In practice the memory is provided by a device driver or a DAX device whose
+target node has no other memory, and usually no CPUs.
+
+Isolation model
+===============
+
+Isolation is *opt-in by exclusion* and is **structural**: by default nothing in
+the kernel can place memory on a private node because the node is absent from the
+zonelists an ordinary allocation walks.
+
+Zonelist exclusion
+    The kernel page allocator depends on the ``FALLBACK`` and ``NOFALLBACK``
+    zonelists to allocate memory.  A normal ``N_MEMORY`` node's zones (except
+    ``ZONE_DEVICE``) appear in these lists and allow allocations to fall-back
+    to less preferable locations if the preferred location is pressured.
+
+    ``__GFP_THISNODE`` is used during normal operation to switch between
+    ``FALLBACK`` and ``NOFALLBACK``, where ``NOFALLBACK`` only contains the
+    zonelists of the preferred node.
+
+    ``N_MEMORY_PRIVATE`` nodes are **excluded** from both ``FALLBACK`` and
+    ``NOFALLBACK`` zonelists.  Instead they are added to ``ZONELIST_PRIVATE``,
+    which includes both ``N_MEMORY`` and ``N_MEMORY_PRIVATE`` nodes.  This is
+    the only zonelist that contains private-node zones, and so the only way
+    to acquire private node allocations is to explicitly request that zonelist.
+
+    Even an allocation carrying ``__GFP_THISNODE`` cannot access the node's
+    memory without also explicitly passing the private zonelist.  This prevents
+    incidental allocation of private memory by users of possible/online
+    nodelists.
+
+    When ``CONFIG_NUMA`` is disabled ``ZONELIST_PRIVATE`` aliases
+    ``ZONELIST_FALLBACK`` and is never selected.
+
+The user_numa path
+
+    ``MPOL_F_PRIVATE`` is an internal user_numa flag (never accepted from
+    userspace) marking that a mempolicy has a private node in its nodemask.
+
+    When ``CAP_USER_NUMA`` for a private node is set, user-sourced mempolicy
+    (``set_mempolicy(2)``) and migration (``move_pages(2)``) operations are
+    allowed to include that node in nodemasks and targets respectively.
+
+    ``mbind(MPOL_MF_MOVE)`` is both a mempolicy and a migration operation,
+    so placement and migration share the same capability.
+
+    The mempolicy component uses ``MPOL_F_PRIVATE`` at fault-time to select
+    ``ZONELIST_PRIVATE`` and makes the node's memory available for allocation.
+    It is otherwise an ordinary, relaxable mempolicy: an unsatisfiable request
+    (an unmovable allocation on a movable-only private node) simply falls back.
+
+
+cpuset interaction
+==================
+
+cpuset.mems does **not** partition private nodes.  cpuset neither grants nor
+denies access, and rebinding cpuset.mems nodemasks do not affect a private node's
+residency in any nodemask.
+
+Likewise, a private node's inclusion in a nodemask does not affect cpuset.mems'
+filtering of any ``N_MEMORY`` - they remain partitioned according to cpuset.
+
+
+Provisioning
+============
+
+A driver brings memory up as private with::
+
+  add_private_memory_driver_managed(nid, start, size, resource_name,
+                                    mhp_flags, online_type, np)
+
+which onlines the range and registers the driver-owned ``struct node_private``
+(``np``) describing the node, including its capability bitmap (see below).
+
+Only one driver/service may register a ``struct node_private``, which
+heavily implies a "one-node-per-device" design of the system.
+
+The node leaves ``N_MEMORY_PRIVATE`` only when the last range is offlined.
+
+.. kernel-doc:: mm/memory_hotplug.c
+   :identifiers: __add_memory_driver_managed
+
+.. kernel-doc:: drivers/base/node.c
+   :identifiers: node_private_register node_private_unregister
+
+Capabilities (per-service opt-ins)
+==================================
+
+Because the default is "no mm service touches the node", each service a driver
+wants back is requested explicitly through a capability bit in
+``np->caps``.  The mm side checks the matching ``node_allows_*()`` /
+``folio_allows_*()`` predicate before acting:
+
+.. list-table::
+   :header-rows: 1
+   :widths: 35 65
+
+   * - Capability
+     - Re-enables
+   * - ``NODE_PRIVATE_CAP_RECLAIM``
+     - reclaim of the node's folios, by the mm and by userspace
+       ``MADV_COLD`` / ``PAGEOUT`` / ``FREE`` (userland-driven reclaim)
+   * - ``NODE_PRIVATE_CAP_USER_NUMA``
+     - all userspace-directed placement and migration: ``mbind()`` /
+       ``set_mempolicy()`` / home node, and ``move_pages()`` /
+       ``migrate_pages()`` to/from the node
+   * - ``NODE_PRIVATE_CAP_HOTUNPLUG``
+     - hot-unplug via migration
+   * - ``NODE_PRIVATE_CAP_DEMOTION``
+     - reclaim-driven tiering demotion onto the node (the node joins the
+       demotion hierarchy)
+   * - ``NODE_PRIVATE_CAP_NUMA_BALANCING``
+     - access-based NUMA balancing scan/migration of the node's folios
+   * - ``NODE_PRIVATE_CAP_LTPIN``
+     - ``FOLL_LONGTERM`` GUP pins
+
+khugepaged never operates on private-node folios (like ZONE_DEVICE), and DAMON
+does not act on them; ``MADV_COLLAPSE`` is covered by ``CAP_USER_NUMA``.
+
+Dependencies between capabilities are enforced **once**, by
+``node_private_register()`` at hotplug, rather than by whatever sets the bits:
+
+* ``DEMOTION`` requires ``RECLAIM`` (a demotion target accumulates demoted
+  pages, so without reclaim as a safety valve it would just fill up).
+
+Capability flags are expected to be stable at runtime.
+
+Observability
+=============
+
+A private node is reported through:
+
+* ``/sys/devices/system/node/has_private_memory``
+* ``/proc/<pid>/numa_maps`` -- per-node residency includes private nodes
+* ``/proc/kcore`` -- private-node RAM appears in the kcore RAM map
+* memcg per-node statistics account private-node memory.
-- 
2.53.0-Meta


