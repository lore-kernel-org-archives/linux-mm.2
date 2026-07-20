Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 593B5C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:34:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDFA36B007B; Mon, 20 Jul 2026 15:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB8066B008A; Mon, 20 Jul 2026 15:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D80026B008C; Mon, 20 Jul 2026 15:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9725D6B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:34:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 312FFA0864
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:34:41 +0000 (UTC)
X-FDA: 85010157162.17.B7B04F5
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4E18A140004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:34:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kMzhFaYD;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YIRi/tNVurt0/aUbQiHfYuBt9pAAT54Lkn/ZbIwjgmA=;
	b=hJ/2VxHtBFIiQ/A3q0uKtRDTnHPKElSMJ6xOnPO0Iwpe0CTVAItw0/nLTy11ubJnc9dyP4
	Qk51j1VaGJxuZVI9QfJfit5FbszAQv+13uk73Q1luAcgmzxLQq8alAW9eGXA0JvjANQWi7
	5xBq78Ltb4zbfRs/S0dIIwK3mz9P4Gs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576079;
	b=T9nLIzqEJ+fMGwUqoG3CU7KXqfdnZDzTninMSInEMv9Yw6/Gz5DexEToO7aXABnujJqKbP
	ghcQDFAsI9qtLCda4eTyCygrDgpVtnH5Jhbdgw0ajVlbaYe7kNQZRZvd75+VcIRqoAetNS
	/WzPb7qWTMtcYq5D92z5UP5PVryVQ2I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kMzhFaYD;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e5d50b0dbso540083385a.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576078; x=1785180878; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YIRi/tNVurt0/aUbQiHfYuBt9pAAT54Lkn/ZbIwjgmA=;
        b=kMzhFaYD4ojPLuP0o13rNFKEVBZB0e0IRgUzNFYTRD3/SXQvQf6dfzquX6hLIf/ycg
         ITVZ6JYrBjpMJQ38ipLyOsBbXpGmkEJboHnhrdJYCaPcEAK9BLka2cRhhCeJT5r0ZOtm
         qDZuIC07qp6S7hVcKNnRlwiMyE01Go7vSKDmvfmgyBHT51XscSvrWs6S+f6p1fMQKawP
         Y+/75q/ojnSDSo0knKFLvv4zeiBfm9Y1qX4ziAFn0kfhYVrMuRg9Y+pXKCw9ErJkyqTJ
         LhgNRpBVwvYqT6j6ww647LAO5V3pjDhl8CDy5AdhaAVVOWfZ28eQGxj36MZrSCYcKoaI
         djPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576078; x=1785180878;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YIRi/tNVurt0/aUbQiHfYuBt9pAAT54Lkn/ZbIwjgmA=;
        b=bY62mfQX0v+5fI0F8TpMkSctF54qUhG9OJrKyUnYowObD7U2gsAScUa0dZoys1dhvZ
         R06Dml3qq83LTHJ/Gal/IQYGHidLg+I6WlOXpcgjzxWGT5OIRz0MDjx1P26ZzJGFLL4B
         whHajWiJH6F3KOLHzH0Qzw/iK2b6fH5qEIuhC9z2uU/d8s4vvUjT1qF0q0XMVp+ATKEI
         XOasRX2m9GmkBlcEUsJAuqfcqlfBDU2L2hFVNQm5L9tz7nUHynFaDGxJXucQ94dIs+tc
         BIqxcLQFGzAVawgLYdrEm17+B5tgfmqdgxHoQOh77uDOhFkyfPN1OFnWmj0wXOcRiyUZ
         nlxg==
X-Gm-Message-State: AOJu0YwooKET0DViwUufYum4FEwS6u3hFjK0+sodpdZXGPxb9AuNCNUx
	0LZWYWmhBVbbA8TBsvyK/Ujwv43Xbr22Jc6vLcB8JROa+SQdY5NeP4a93sht13hI43+BlbyMkZQ
	JTFUy
X-Gm-Gg: AfdE7cn75C9DeDK20l4cLEVcEj7OjbB84JL/Xb6hJy2iPvPnTr67vtP7JKGb4rgAVY+
	5RLYbZG4xbHWWURr0E+eIhSmeZrldn3snfe++MGufSvbmNrCJbsfG2e1yh/kIGoggO5VryTKDDz
	xovxB78K9E9Mje+byP10h5J4NCDHAuxF0VDfEnejgmTGCp3Fm5WupVxxWd+vM7TpyGoVxG/+J3J
	M9tpzoE2i4z4d5CA95n7ehmyjTwADoaGS0F8eX9ukJ/KCLAsLAEfSEF/D+ZGW+mBSIZMQBq3fu5
	llFNu5+fTVXRd+BK8MsCEiA5lgWmWhc8pycBStjKHdgeo1lTevfimifaTMv7mQkurFDRj/2szqx
	34Kg10zRmtxTfZRkR/n1m8/IcBdMJrQ1ttOQMKy/7HeqgUci/KLJ+7NxGkns/Z8dBbaXwaTMt3b
	XTKoAZ2awD3oUVo0s/bp8bDMVfGJIeBcfhaIykwDIvaDJ87TrZ63HNUCoQNocJzFQnKFv7xHCLc
	w==
X-Received: by 2002:a05:620a:4109:b0:92e:fe10:3ef6 with SMTP id af79cd13be357-930b419ed82mr1474129285a.43.1784576078000;
        Mon, 20 Jul 2026 12:34:38 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:34:37 -0700 (PDT)
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
Subject: [PATCH v5 00/36] Private Memory NUMA Nodes
Date: Mon, 20 Jul 2026 15:33:54 -0400
Message-ID: <20260720193431.3841992-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4E18A140004
X-Stat-Signature: xjjb9wbwj3a4x8nmetfq71rqif1ua4sb
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784576079-43137
X-HE-Meta: U2FsdGVkX19vUNw6jQ4LGkz+wyrXJ2+e58fcu5lIkmUiuZYQT59S76B72g25zC1MtjOWxo7d92J8U7Hr2sffidLbPeCc+r4NY0f4Ov6+6WftHxA/IR9IqwxkJi5l2nnoarmzrGuKunvrWDAhJI3dusaaAtoEqkHfOG/IZWVZbeQ0jOjdJEMcRo/+yzlrAkxAw1Bd27LXUYqmnLAXYc6nUEMr77GyofPlmVJFTTaqmzTlLKytlulqTqJ4pmSyLeL/kpwpJOIUY5aaldNiFJW1JADmPrCt+7Lq14C3JpN0Wy0FWbfOtCIX0FHQSiTGOsyhu75OtdWn8nTczgLXL6Nayy1/wSuIK5coJ0SSRxM1yupc/gteBsyQsIVBQTGagXTU/rFcHc6Lg3Rhf9ITTDAGVXe8I+YzQku9Glotihheyxh4D1LFip5BNVFtQ77KHsNraWRqiB+dduk0/BZVjP+Pq2Duxq3bISz0kCdquqrBGhs3H7KqhUh+evYm2Cz+yrf6+1krHN1u/DpEmd14y93shWAA4jip2KJ18ClSMJKPgN1VzEXD0dJ4yW6g/LwARuFi8zGmclK4CDLsyVnN6cnQSbZHiWkSyQKUrxqY5VyhaAFvoi2IfiFsun9OkEJhOb+vyQN2D7kHOx6ES/LiWawxwI9+arYfcTrzxBNsHkICcGm2ZqWnf41NrGmwKWJR/Moq2VcKPt6/hEcBAvT7lZefxeJjfEFPRrCWtzUveXR0Oq4HZ6ZYKP1lVaSmxUCZp4jPfeuyFgi7o6BthZr1Iy2B0BYzUJG6FtaDlWJnXYC1rCHBAKUDLzcdqzNRMRKjWAx9LQ+4HY2jTduTblEwBa+epTTrYnn8wZ3TFMxnabUUrmJezK8hwbzyKGz/eJFCvFNsxJZR76JoimwYg9WD4kUby1jGbVUQ2MA3uoR2noRoiuBl84TYSZJ4aOQ/5CvXqr5YNUJ/UYxAx44WCuxdNJA
 ARieN0p3
 Ty1ZwTPG+w1baO+Xxj/kcy4iWN1gX8np08XeUo+kAxJ9QXPiBehh1naLSurzvBIPG8q1P4qnADXmu/Xw7Tkk1GHRThgt/OyCi8KRBwjZJrHup2PRX6sBDi6aWectmRbAbWNQRNHfG9L0IlHtEa04+EWbkpbc2VmryY7/lV3EAFQmQiRtLYrUAt+M30Nf9t3gnvktrrPBSLOCXZa0MbysGnViU+i6A9TUXWjqlPknF99iJJge73OV0/90yAiEBgji65ZzcphHLmW2DtEKh+Ob5FIOAci3zG7mIalWMHewvgac6dL6t/vx274K2GzSyUdJC5PAtT8aoJEm28BiDyk+dj9eR41kjkfZiSKJDsQyUzB553ptLBCBqJkryJnYI3KvdntSH3fVlUi68ZYbjGq4vx4GTbyYGfnbdLfR/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces the concept of "Private Memory Nodes", which
are opted into two basic functionalities by default:
  - page allocation (mm/page_alloc.c)
  - OOM killing

All other features of mm/ are opted out of managing these NUMA
nodes and its memory.  Then we add capability bits to allow node
owners to opt back into those services (if supported).

NUMA-hosted memory is presently a most-privilege system (any memory on
any node, except ZONE_DEVICE, is 100% fungible and accessible). We
then slap restrictions on top of it (cpuset, mempolicy, ZONE type,
page/folio flags, etc).

The goal here is to flip that dynamic, isolate by default and then
opt-in to specific services that the device says is safe.

Isolation at the NUMA/Zonelist layer provides a powerful mechanism for
memory hosted on accelerators - re-use of the kernel mm/ code.

 - Accelerators (GPUs) can use demotion, numactl, and reclaim.
 - Special memory devices (Compressed RAM) with special access controls
   (promote-on-write) can have generic services written for them.
 - Network devices with large memory regions intended for ring buffers
   can use the buddy and standard networking stack.
 - Slow, disaggregated memory pools which aren't suitable as general
   purpose memory get cleaner interfaces (no need to re-write the buddy
   in userland, can use migration interface, etc).
 - Per-workload dedicated memory nodes (disaggregated VM memory)

And more use cases I have collected over the past few years.

Not included here is a dax-extension [1] that exposes all the internal
bits as userland controls for testing - along with a pile of selftests
that prove correctness.

Changes Since V4
================
 - Massive reduction in complexity.
     - no ops struct
     - no callback functions
     - no __GFP_PRIVATE
     - no __GFP_THISNODE requirement
     - no task flags (no PF_MEMALLOC_* in the alloc path)
 - isolation via a dedicated zonelist:
     - private nodes are omitted from FALLBACK/NOFALLBACK
     - added ZONELIST_PRIVATE(_NOFALLBACK)
 - ALLOC_ZONELIST_PRIVATE alloc_flag
     - on top of Brendan Jackman's recent mm/page_alloc.h work [3]
     - Zonelist selection rides the allocator's alloc_flags
 - rename OPS -> CAPS (capabilities)
 - split base functionality (isolation) from opt-ins (CAPS)
     - first half of series can be merged without CAPS
 - dropped compressed ram example from series
     - will submit separately if this moves forward
 - Added KVM as first primary in-tree user (mempolicy / CAP_USER_NUMA)
 - fully functional dax-kmem extension and huge suite of selftests
   located at my github, to be discussed separately [1]

Patch Layout
============
The series is broken into two sections:

1) N_MEMORY_PRIVATE Introduction.
   Introduce the node state.
   Opt those nodes out of mm/ services.

2) NODE_PRIVATE_CAP_* features
   A set of mm/ service opt-in flags that augment private
   nodes to make them more useful (i.e. reclaim = overcommit).

   NODE_PRIVATE_CAP_LTPIN for private node folio pinning
   NODE_PRIVATE_CAP_NUMA_BALANCING for private-node NUMA balancing
   NODE_PRIVATE_CAP_DEMOTION for private-node tiering demotion
   NODE_PRIVATE_CAP_HOTUNPLUG for opted-in private nodes
   NODE_PRIVATE_CAP_USER_NUMA for userland numa controls
   NODE_PRIVATE_CAP_RECLAIM for opted-in private node reclaim

My hope is to merge at least #1 pulled ahead while #2 is debated.

Allocation Isolation
====================
page_alloc presently controls whether a node's memory can be allocated
on a given call by 4 things (in order of authority)

  1) ZONELIST membership
     If a node is not in the walked zonelist, it's unreachable.

  2) __GFP_THISNODE
     If this flag is set and the only node in the ZONELIST is the
     singular preferred node (or the local node, for -1)

  3) cpuset.mems membership
     cpuset trims any node in its allowed list

  4) mempolicy nodemask
     the allocator will skip any node not in the nodemask.

Except for #1 (Zonelist membership) there are all kinds of weird corner
conditions in which 2-4 can be completely ignored (interrupt context,
empty set because cpuset doesn't intersect mempolicy, shared vma, ...)

But ZONELIST membership is *absolute*.  If a zone is not in the
zonelist being walked, IT CANNOT BE ALLOCATED FROM. PERIOD.

The existing zonelists are constructed like so:
  ZONELIST_FALLBACK    : All N_MEMORY nodes
  ZONELIST_NOFALLBACK  : A singleton N_MEMORY node

Private node isolation is implemented via ZONELIST isolation:
  ZONELIST_PRIVATE            : The private node + N_MEMORY
  ZONELIST_PRIVATE_NOFALLBACK : The private node alone.

(mirrors exactly the fallback/nofallback for __GFP_THISNODE)

Private nodes:
  1) Never appear in any ZONELIST_FALLBACK
  2) Have an empty ZONELIST_NOFALLBACK
  3) Only appear in their own ZONELIST_PRIVATE(_NOFALLBACK)

1 & 2 mean all existing in-tree callers to page_alloc can NEVER
accidentally allocate from a private node.

An allocation must explicitly ask via a zonelist and a nodemask.

  alloc_flags |= ALLOC_ZONELIST_PRIVATE; /* use ZONELIST_PRIVATE */
  __alloc_pages(..., nodemask);     /* with the private node set */

The page allocator keeps all its original interfaces which only
ever touch the default zonelists - avoiding churn.

Making it accessible via Mempolicy: MPOL_F_PRIVATE and page_alloc
=================================================================
The vast majority of the kernel will never need to know about
ZONELIST_PRIVATE, because we add MPOL_F_PRIVATE to mempolicy.

When a mempolicy has MPOL_F_PRIVATE, the alloc_mpol() interfaces
do the zonelist selection for the source of the allocation.

That really is the whole explanation of the mechanism:

  alloc_flags = mpol_alloc_flags(pol);
  page = __alloc_frozen_pages_noprof(..., alloc_flags);

On mm-new this rides the allocator's existing alloc_flags plumbing:
ALLOC_ZONELIST_PRIVATE is just another alloc_flag, so no new
parameter, enum, or alloc_context change is required.

For modules that want to implement their own special handling, they
get the _private variants for the page allocator.  This lets modules
re-use the buddy instead of rewriting it.

   - alloc_pages_node_private_noprof()
   - folio_alloc_node_private_noprof()

This keeps ALLOC_ flags mm/ internal (these functions add the flags).

Isolating private node folios from kernel services
==================================================
We implement filter points in mm/ to prevent operations on
private node memory.  Where possible, we even re-use existing
filter points from ZONE_DEVICE.

Most filter points are one or two lines of code:

Combining ZONE_DEVICE and N_MEMORY_PRIVATE opt-out spots:
  -     if (folio_is_zone_device(folio))
  +     if (unlikely(folio_is_private_managed(folio)))

Disabling a service:
  +  if (!node_is_private(nid)) {
  +      kswapd_run(nid);
  +      kcompactd_run(nid);
  +  }

Disallowing a uapi interaction:
  +  if (node_state(nid, N_MEMORY_PRIVATE))
  +      return -EINVAL;

In the second half of the series, we replace blanket N_MEMORY_PRIVATE
filters with NODE_PRIVATE_CAP_* filters to opt those nodes into that
interaction if CAP is set.

We abstract this with a nice clean interface to make it really clear
what is happening (nodes have features!)

  -  if (node_state(pgdat->node_id, N_MEMORY_PRIVATE))
  +  if (!node_allows_reclaim(pgdat->node_id))

NODE_PRIVATE_CAP_* features
===========================
This series of commits opts private nodes into various mm/ services.

Capabilities:
  NODE_PRIVATE_CAP_RECLAIM       - direct and kswapd reclaim
  NODE_PRIVATE_CAP_USER_NUMA     - userland numa controls
  NODE_PRIVATE_CAP_DEMOTION      - node is a demotion target
  NODE_PRIVATE_CAP_HOTUNPLUG     - hotunplug may migrate
  NODE_PRIVATE_CAP_NUMA_BALANCING - NUMAB may target node folios
  NODE_PRIVATE_CAP_LTPIN         - Longterm pin operates normally

Some opt-in support is more intensive than others, so these features
are broken out in a way that we can defer them as future work streams.

NODE_PRIVATE_CAP_RECLAIM:
  Enabling reclaim for these nodes is actually surprisingly trivial.

  Without CAP_RECLAIM, when an allocation failure occurs, the system
  will not attempt to swap the memory - and instead will OOM (typically
  whatever task is using the most memory on *that* private node).

  This capability consists of:
    1) enabling kswapd and kcompactd for that node at hotplug time.
    2) formalizing opt-out hooks to node_allows_reclaim() opt-in hooks.
    3) Sets normal watermarks for these nodes.
    4) Allow madvise operations on that node (PAGEOUT).
    5) A small tweak to how LRU decides which zones to visit.

NODE_PRIVATE_CAP_USER_NUMA
  Enables the following userland interfaces to accept the node:
    mbind()
    set_mempolicy()
    set_mempolicy_home_node()
    move_pages()
    migrate_pages()

  example:
     buf = mmap(..., MAP_ANON);
     mbind(buf, ..., {private_node});
     buf[0] = 0xDEADBEEF; /* Page faults onto the private node */

  Later - the KVM example shows how in-kernel mempolicies can
  also be bound by CAP_USER_NUMA.

  Otherwise, that's it - it's just a mempolicy with MPOL_F_PRIVATE.

NODE_PRIVATE_CAP_HOTUNPLUG
  This is simple: allow hotunplug to migrate this nodes folios.

  Some devices may not be able to tolerate unexpected migrations,
  so we prevent hotunplug from engaging in migration by default.

  Some devices may have an mmu_notifier in their driver that can
  manage the migration and subsequent refault.

  CAP_HOTUNPLUG allows memory_hotplug.c to migrate normally.

NODE_PRIVATE_CAP_DEMOTION
  This adds the private node as a valid demotion target, and allows
  reclaim to demote memory from a private node to a demotion target.

  Requires:  NODE_PRIVATE_CAP_RECLAIM

NODE_PRIVATE_CAP_NUMA_BALANCING
  This enables numa balancing to inject prot_none on private node
  folio mappings and promote them when faults are taken.

NODE_PRIVATE_CAP_LTPIN
  This allows GUP Longterm Pinning to operate normally.

  Normally, longterm pinning determines folio eligibility based
  on its ZONE_* membership (among other things).

  ZONE_NORMAL is eligible, while ZONE_MOVABLE folios require
  migration to ZONE_NORMAL before pinning.

  Neither operation is preferable by default on a private node,
  so the base behavior of FOLL_LONGTERM is to FAIL.

  This capability allows longterm pinning to operate normally
  based on the ZONE membership.  Private node memory may be
  hotplugged as either ZONE_NORMAL or ZONE_MOVABLE.

In-tree User: KVM
=================
Dave Jiang proposed [2] dax-backed guest_memfd() memory as a way of
enabling disaggregated memory pools to host dedicated KVM memory.

With private nodes, this is trivial (with a bit of basic plumbing):

static int kvm_gmem_bind_node(struct inode *inode, int node)
{
...
  /* Bind to a private node - gated on CAP_USER_NUMA */
  pol = mpol_bind_node(node);
  if (IS_ERR(pol))
    return PTR_ERR(pol);

  /* Set the shared policy */
  err = mpol_set_shared_policy_range(&GMEM_I(inode)->policy, ..., pol);
...
}

KVM doesn't even need to know about private nodes at all, all it
does is ask mempolicy whether the requested node is a valid bind.

mm/ component testing with dax driver
=====================================
The dax driver extensions[1] implements a simple interface to create
a private node from a dax device created by any source.

I left the dax driver extensions out of this feature set because
it locks in the CAP_ bits before anyone has input.  It's there
primarily for testing at this point.

The simplest way to get a dax device is with the memmap= boot arg.
   e.g.: "memmap=0x40000000!0x140000000"

The dax driver extension has the following sysfs entries:
  dax0.0/private         - set the node to private
  dax0.0/dax_file        - make /dev/dax0.0 mmap'able in kmem mode
  dax0.0/adistance       - dictate memory_tierN membership
  dax0.0/reclaim         - CAP_RECLAIM
  dax0.0/demotion        - CAP_DEMOTION
  dax0.0/user_numa       - CAP_USER_NUMA
  dax0.0/hotunplug       - CAP_HOTUNPLUG
  dax0.0/numa_balancing  - CAP_NUMA_BALANCING
  dax0.0/ltpin           - CAP_LTPIN

Now consider the following...

Single node reclaim + mbind support:
  echo 1 > dax0.0/private
  echo 1 > dax0.0/reclaim
  echo 1 > dax0.0/user_numa
  echo online_movable > dax0.0/state

Test program:
   /* node1: 1GB Private Memory Node, 4GB swap */
   buf = mmap(NULL, TWO_GB, PROT_READ | PROT_WRITE,
              MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
   sys_mbind(p, len, MPOL_BIND, mask, MAXNODE, MPOL_MF_STRICT);
   memset(buf, 0xff, TWO_GB);

We can *guarantee* the ONLY reclaiming tasks are exactly:
  - kswapdN (in theory we can even make this optional!)
  - the memset task faulting pages in

This also means these are the only tasks capable of becoming
locked up and OOMing (as long as it is not under pressure).

The rest of the system remains entirely functional for debugging.

It now becomes possible to micro-benchmark and A/B test reclaim
changes with different scenarios (number of tasks, amount of
memory, watermark targets, etc), because we have hard controls
over exactly which tasks can access that node memory and how.

If we broke CAP_RECLAIM into subflags:
  - CAP_RECLAIM_KSWAPD
  - CAP_RECLAIM_DIRECT
  - CAP_COMPACTION_KCOMPACTD
  - CAP_COMPACTION_DIRECT

We can actually test the efficacy of each of these mechanisms in
isolation to each other - something that is strictly impossible today.

Bonus Configuration: HBM device memory tiering
==============================================
echo 1 > dax0.0/private       # make the node private
echo 0 > dax0.0/adistance     # highest tier
echo 1 > dax0.0/reclaim       # reclaim active
echo 1 > dax0.0/demotion      # may demote from the node
echo 1 > dax0.0/user_numa     # mbind()
echo online_movable > dax0.0/state
echo 1 > numa/demotion_enabled

This is an HBM device which is treated as the top-tier in the
system but for which memory can only enter via explicit mbind().

It can be overcommitted because it can be reclaimed (demotions
go to CPU DRAM, and reclaim can swap from it).

If the HBM is managed by an accelerator (GPU), the mmu_notifier
allows it to know when reclaim is moving memory out to do
device-mmu invalidation prior to migration.

Prereqs, base commit, references
================================
akpm/mm-new - for Brendan Jackman's mm/page_alloc.h work[3]

Prereqs (all already in akpm/mm-new; listed for out-of-tree application):

page_alloc.h split + alloc_flags plumbing this series rides on:
commit e81fae43cd69 ("mm: split out internal page_alloc.h")
commit b4ff3b6d0a1d ("mm: replace __GFP_NO_CODETAG with ALLOC_NO_CODETAG")

dax atomic whole-device hotplug (used by the dax extension [1]):
commit d7aa81b9a919 ("mm/memory: add memory_block_aligned_range() helper")
commit 3b2f402a1754 ("dax/kmem: add sysfs interface for atomic whole-device hotplug")

[1] https://github.com/gourryinverse/linux/tree/scratch/gourry/managed_nodes/dax_private-mm-new
[2] https://lore.kernel.org/all/20260423170219.281618-1-dave.jiang@intel.com/
[3] https://lore.kernel.org/all/20260702-alloc-trylock-v4-0-0af8ff387e80@google.com/

base-commit: c872b70f5d6c742ad34b8e838c92af81c8920b3e

Gregory Price (36):
  mm: refactor find_next_best_node to find_next_best_node_in
  mm/page_alloc: refactor build_node_zonelist() out of build_zonelists()
  mm/page_alloc: let the bulk and folio allocators carry alloc_flags
  numa: introduce N_MEMORY_PRIVATE
  mm: add ZONELIST_PRIVATE(_NOFALLBACK) for N_MEMORY_PRIVATE nodes.
  cpuset: exclude private nodes from cpuset.mems (default-open)
  mm/memory_hotplug: disallow migration-driven private node hotunplug
  mm/mempolicy: skip private node folios when queueing for migration
  mm/migrate: disallow userland driven migration for private nodes
  mm/madvise: disallow madvise operations on private node folios
  mm/compaction: disallow compaction on private nodes
  mm/page_alloc: clear private node watermarks and system reserves
  mm/mempolicy: disallow NUMA Balancing prot_none on private nodes
  mm/damon: skip private node memory in DAMON migration and pageout
  mm/ksm: skip KSM for managed-memory folios
  mm/khugepaged: skip private node folios when trying to collapse.
  mm/vmscan: disallow reclaim of private node memory
  mm/gup: disallow longterm pin of private node folios
  proc: include N_MEMORY_PRIVATE nodes in numa_maps output
  mm/memcontrol: account private-node memory in per-node stats
  proc/kcore: include private-node RAM in the kcore RAM map
  mm/mempolicy: add MPOL_F_PRIVATE and zonelist selection
  mm/mempolicy: apply policy at the kernel zone for private-node binds
  mm/mempolicy: add in-kernel MPOL_BIND interfaces for drivers/services
  mm/memory_hotplug: support N_MEMORY_PRIVATE node hotplug
  mm: add NODE_PRIVATE_CAP_RECLAIM for opted-in private node reclaim
  mm: add NODE_PRIVATE_CAP_USER_NUMA for userland numa controls
  mm: add NODE_PRIVATE_CAP_HOTUNPLUG for opted-in private nodes
  mm: add NODE_PRIVATE_CAP_DEMOTION for private-node tiering demotion
  mm: add NODE_PRIVATE_CAP_NUMA_BALANCING for private-node NUMA
    balancing
  mm: add NODE_PRIVATE_CAP_LTPIN for private node folio pinning
  mm/khugepaged: base private node collapse eligiblity on actor/cap bits
  Documentation/mm: describe private (N_MEMORY_PRIVATE) memory nodes
  mm/mempolicy: add mpol_set_shared_policy_range()
  KVM: guest_memfd: bind backing memory to a NUMA node at creation
  KVM: selftests: add a guest_memfd FLAG_BIND_NODE test

 Documentation/ABI/stable/sysfs-devices-node   |  10 +
 Documentation/mm/index.rst                    |   1 +
 Documentation/mm/numa_private_nodes.rst       | 160 ++++++++++
 drivers/base/node.c                           | 118 +++++++
 drivers/dax/kmem.c                            |   2 +-
 fs/proc/kcore.c                               |   5 +-
 fs/proc/task_mmu.c                            |  10 +-
 include/linux/gfp.h                           |  22 +-
 include/linux/kvm_host.h                      |   3 +
 include/linux/memory_hotplug.h                |   5 +-
 include/linux/mempolicy.h                     |  16 +
 include/linux/mmzone.h                        |  26 +-
 include/linux/node_private.h                  | 262 ++++++++++++++++
 include/linux/nodemask.h                      |   7 +-
 include/uapi/linux/kvm.h                      |   5 +-
 include/uapi/linux/mempolicy.h                |   1 +
 kernel/cgroup/cpuset.c                        |  26 +-
 mm/compaction.c                               |  13 +
 mm/damon/paddr.c                              |   9 +
 mm/gup.c                                      |  28 +-
 mm/huge_memory.c                              |   5 +
 mm/internal.h                                 |  97 +++++-
 mm/khugepaged.c                               |  18 +-
 mm/ksm.c                                      |   8 +-
 mm/madvise.c                                  |   8 +-
 mm/memcontrol-v1.c                            |   8 +-
 mm/memcontrol.c                               |  13 +-
 mm/memory-tiers.c                             |  40 ++-
 mm/memory_hotplug.c                           | 119 +++++++-
 mm/mempolicy.c                                | 288 +++++++++++++++---
 mm/migrate.c                                  |  19 +-
 mm/mm_init.c                                  |   2 +-
 mm/page_alloc.c                               | 189 +++++++++---
 mm/page_alloc.h                               |  34 +++
 mm/vmscan.c                                   |  57 +++-
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../kvm/guest_memfd_bind_node_test.c          | 213 +++++++++++++
 virt/kvm/guest_memfd.c                        |  39 ++-
 38 files changed, 1728 insertions(+), 160 deletions(-)
 create mode 100644 Documentation/mm/numa_private_nodes.rst
 create mode 100644 include/linux/node_private.h
 create mode 100644 tools/testing/selftests/kvm/guest_memfd_bind_node_test.c

-- 
2.53.0-Meta


