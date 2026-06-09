Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C04A9CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:17:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE8506B0005; Tue,  9 Jun 2026 05:17:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D992F6B0088; Tue,  9 Jun 2026 05:17:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAEF86B008A; Tue,  9 Jun 2026 05:17:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B93176B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:17:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C40D1204FC
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:17:57 +0000 (UTC)
X-FDA: 84859822194.14.3ADC60C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A08C6A0006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:17:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=InpuJTdi;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780996675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JklGHxBs/e7WoHWY8zy6xxkN2IXkLn5LKgi5O76JqdY=;
	b=LGt1SdO0az4koeFu20BmgjYMqQNwhZ1fWzPHXLNR04CdinZkfxEbbrtGIpq45RHiKP9xrU
	5LoCbLJGhknLnkAe/ttaNOJsyJIcgQK6M35EZuD0AGLLv9na12prxwfYo7IVi2R8Ounl70
	PCAvo2Roj9nfJ4yiu6QdEUuZxyeiPSU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780996675;
	b=PvIdOYDeHourAtA9+jcCznNl26fbmYi6LQicRqytpF5sQzxTgbgycnY13GdqlsXYzpLKUv
	6q7ugQJY+TGqe7KnQjTGdYdHGR9hgcyep6jguKWKL40mOHI5Rpy13xRMe4VY3jVid+sb9U
	/dKPiwyCTUYOqRk2LxrqUIDZZ1nnJ9E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=InpuJTdi;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D490B43B00;
	Tue,  9 Jun 2026 09:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428AB1F00893;
	Tue,  9 Jun 2026 09:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996674;
	bh=JklGHxBs/e7WoHWY8zy6xxkN2IXkLn5LKgi5O76JqdY=;
	h=From:Subject:Date:To:Cc;
	b=InpuJTdixIWUvPPcFY6VIL8TLmanaDGHTbitvz3Ypi3itXf5Wqncv9tnKBpDPSicn
	 wokRauUzVrN38x7gCY9XFJFFNcFtk3EGI+QotA50dpBp2jrGsZSLaqPe9hkaj4lHgc
	 QVQpfUUWcFqM6IVplaSZMt6Y4tNd9lw9RktAlsS2UzgLTZMHBVYF0Vi5PLYiytcfy3
	 rNXaaeWM4zj3ct4b4kxLDzM52lMrq4N3oSIIZDPH2lnEDWhWspSrtHndryL1y64PKG
	 dqyA/Mto7LbJZuiHUeWCVSR/AAxYjocA7zmzTsDBcaUg2o6+3L7ZeKfdPw8rHqDGZm
	 0HFWmqQQXoFtw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH RFC 00/15] mm/slab: introduce alloc_flags and
 slab_alloc_context
Date: Tue, 09 Jun 2026 11:17:45 +0200
Message-Id: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADnaJ2oC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDMwND3eKcxKT4xJyc/OT4tJzE9GJdI9NkcwujJINkU/NkJaC2gqLUtMw
 KsJHRSkFuzkqxEMHi0qSs1OQSkGFKtbUAms3VdHkAAAA=
X-Change-ID: 20260601-slab_alloc_flags-25c782b0c57c
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: A08C6A0006
X-Rspam-User: 
X-Stat-Signature: wipyn51qkgc4i7ysao99bphg7wdbghdw
X-Rspamd-Server: rspam08
X-HE-Tag: 1780996675-207391
X-HE-Meta: U2FsdGVkX1+v8ddrEisyzfzsKGZJtQLpnfZEQf7jLc+Bqzqzbrczctxquzir3oc/WRbfrl73xHE/RsDI9/jJ99kq0exkV1ueQbqjvZe0PEGdo6VGBU5RrWGwImFHeUcn4sfJHeGn7csHQzw/fqybgsG72qN/L/vcqfSUVGnBdBA84sXD/RzQXU+oTVWTZvsloHd6Mx+CXpe3m+y18/xqSsjsf/R0NIHxueNhRnM/vg9CYWnXGkIAjHkkn6qd4pep0N/VmMb7NpTTb7iTO/RS2tF8YGIiqRAr8lUICJoCT2YDeNHfW4Ol4Hw2WLBw5Ltezqwu9BuYNGcuK30nskM8rM6a90FLK9aO8DPkAdmKTZl9zDb9GKWUHCC4EpfwtaS2uackfeKgEtDluB6GowLPc/qwaUukX1cFwzK9fAP5UWgW2O5IOFJr8RPQjOCb4d26l4ScH/F6z911W0RMCxHpWybeFIDH2QvWN3rLcicZgo2uV3eHS+KSH1BaZOXWmOwkhk2mJVUsi5WvIeIxkuZ9zVzoXVhz7qWrdcGLlQwag/1W9R73jpbYMNx2IeD2p1QbfudQqjwo7dZWYeS36XuLW5WfOn1hN3D9ReCQWDw2D3KVGop5fbmppO59DpO6p7/zpeMMqlReM3ccDtjWryWmYomqmZ9vucCqum+Q74OGnKy9Yd/lzu25YT94UguXQbSCAL3BsXqIxitQ5OuHYsAJ5q8UGcX24mvvGZCLkNRidsDtOU3h1bdhZ5wE+OP+KVH4zWtjfF3mPCW3MUoRzffoFNVxbRj+WDw9r6w1TeCp/aQvGVB1DF9BKqgnUySQBzAGPfO0JyX+pkbw+tkag10ee4vpZK0NmGwdF0y7+FWIDZE5VdU5OTBxQXDojmJDTSKTtZeZ2OAnDWmqEFKHwPDo1rhkbKZA/67vAqmmD8kLLLw7Gsh3l05XrelaVvjQiHaosokv1vNX6E9q4H9BC6k
 No4eNXqm
 CSuRuqGCUZo4cCpnGNxwcMnE99twjvbqNFUrL0a/Xm3lp8XR8FwiY1IsAv7TxPcKmBzG1p1zW6cj8+rZUCK+Idb9+1DO2dtu+r0vZq8CFspfThWRlc5YR3O/bhQixFKHY6bT3puZFZqcV5qEUkOG4GtBBITx/ITmAfaFNbbRNr5Rn1B9kCJDPry2AvHFA7FIf+Tbjz7z02OxpmEooPAmCWAcNxaY56k/n1zGa1U5NsD8vjHf/D5Jv7WjRI1p5eAL2hXcNDgwfkcCPdBJGEmgJoSudM/s3JcC0AJ0g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is based on slab/for-next. If all goes well, it would
hopefully go to slab/for-next soon after the 7.2 merge window, so any
other work can be based on it to avoid conflicts, as it touches a lot
parts of slab.

Git: https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/slab_alloc_flags

The slab implementation currently relies on gfp flags to convey
some context information internally:

- The absence of both __GFP_RECLAIM flags is interpreted as "cannot spin
  on locks", and intended to be used by kmalloc_nolock(). But false
  positives are possible e.g. during early boot where gfp_allowed_mask
  clears __GFP_RECLAIM from all allocations. This leads to unnecessary
  allocation failures and workarounds such as fd3634312a04 ("debugobject:
  Make it work with deferred page initialization - again").

- __GFP_NO_OBJ_EXT exists and takes up valuable bit in the gfp flags
  space, only to prevent recursive kmalloc() allocations for obj_ext
  arrays and sheaves.

The page allocator uses its internal alloc_flags to convey various
context information, including ALLOC_TRYLOCK (meaning "cannot spin").
This series copies that concept for the slab allocator, with its own
slab-specific internal flags:

- SLAB_ALLOC_DEFAULT - no extra flags (the value is 0), but explicit
- SLAB_ALLOC_TRYLOCK - do not spin on locks (used by kmalloc_nolock())
- SLAB_ALLOC_NEW_SLAB - replacing existing 'bool new_slab' parameter
			for allocating obj_ext arrays
- SLAB_ALLOC_NO_RECURSE - replacing usage of __GFP_NO_OBJ_EXT

To reduce the amount of parameters in various internal functions, we
additionally introduce slab_alloc_context (also inspired by page
allocator's alloc_context) for passing a number of existing arguments
and the new alloc_flags:

/* Structure holding extra parameters for slab allocations */
struct slab_alloc_context {
	unsigned long caller_addr;
	unsigned long orig_size;
	unsigned int alloc_flags;
	struct list_lru *lru;
};

This also replaces the existing struct partial_context.

The last necessary piece is kmalloc_flags() which can take the
alloc_flags in addition to gfp flags and is intended for the recursive
allocations of sheaves and obj_ext arrays, so that both
SLAB_ALLOC_TRYLOCK and SLAB_ALLOC_NO_RECURSE can be communicated.
Internally it decides between kmalloc_nolock() and normal kmalloc()
depending SLAB_ALLOC_TRYLOCK.

The rest of the series is gradually expanding the usage of both
alloc_flags and slab_alloc_context as necessary, with bits of
refactoring. Then, __GFP_NO_OBJ_EXT is removed completely.

Note that some usage of gfpflags_allow_spinning() relying on absence of
__GFP_RECLAIM remains outside of slab (and page allocator) in memcg,
page_owner and stackdepot code. These can thus yield false-positive
decisions that spinning is not allowed, but should not result in
important allocations failing anymore.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Vlastimil Babka (SUSE) (15):
      mm/slab: always zero only requested size on alloc
      mm/slab: stop inlining __slab_alloc_node()
      mm/slab: introduce slab_alloc_context
      mm/slab: introduce alloc_flags and SLAB_ALLOC_TRYLOCK
      mm/slab: add alloc_flags to slab_alloc_context
      mm/slab: replace struct partial_context with slab_alloc_context
      mm/slab: pass alloc_flags to new slab allocation
      mm/slab: pass alloc_flags through slab_post_alloc_hook() chain
      mm/slab: replace slab_alloc_node() parameters with slab_alloc_context
      mm/slab: allow kmem_cache_alloc_bulk() with any gfp flags
      mm/slab: pass slab_alloc_context to __do_kmalloc_node()
      mm/slab: introduce kmalloc_flags()
      mm/slab: remove __GFP_NO_OBJ_EXT usage from alloc_slab_obj_exts()
      mm/slab: replace __GFP_NO_OBJ_EXT with SLAB_ALLOC_NO_RECURSE for sheaves
      mm: remove the __GFP_NO_OBJ_EXT flag

 include/linux/gfp_types.h       |   7 -
 include/linux/slab.h            |  14 +-
 include/trace/events/mmflags.h  |  10 +-
 lib/alloc_tag.c                 |   2 +-
 mm/kfence/core.c                |   6 +-
 mm/memcontrol.c                 |   5 +-
 mm/slab.h                       |  16 +-
 mm/slub.c                       | 423 ++++++++++++++++++++++++----------------
 tools/include/linux/gfp_types.h |   7 -
 9 files changed, 288 insertions(+), 202 deletions(-)
---
base-commit: 500b2c9755301742bdbb61249511ac11a4665dae
change-id: 20260601-slab_alloc_flags-25c782b0c57c

Best regards,
--  
Vlastimil Babka (SUSE) <vbabka@kernel.org>


