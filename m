Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F99DCD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 892D76B0005; Wed, 10 Jun 2026 11:40:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A216B0088; Wed, 10 Jun 2026 11:40:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A76E6B008C; Wed, 10 Jun 2026 11:40:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B94B6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:40:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1F409162022
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:40:23 +0000 (UTC)
X-FDA: 84864414726.16.0E273EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6A01B140016
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:40:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q5gNJkTh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781106021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rh6k92Y5yfUvQ1Ydl5es3+m24euL6hyzwkyjlD+xQ1I=;
	b=kamXDtRiGiaSi+WRy9XqzuBs1QmJrvlZW0g55vDRv0Mx+X9XQbo62ihMYN0/9UayDyrMfj
	D32SXxY2HMX6IDbkXIdTWy4R5Cj3Wwi6lPBElcA2qrrxw7FgkRUUcwzz0y1RRYGetttr9U
	ugn+wXO8ILJxW7oTwC68tQP8vDoNkCI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q5gNJkTh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781106021;
	b=vwSaGh8pK/d+E00A/n5eAlUWIVxrFcLNalS37+I8xrmKjuI+g7CBsqAgEaw9bgrjTSUQ8l
	LD4ZyaSg31lV+J8uYM1p1uwRZZ/GC87fRij71Zz7ze12V6ObehjeCDFpgfog1AOcER/YNy
	P3/kDsuVs0T95dG4pbB9htOa63wphqc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC025601F9;
	Wed, 10 Jun 2026 15:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417291F00898;
	Wed, 10 Jun 2026 15:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106020;
	bh=rh6k92Y5yfUvQ1Ydl5es3+m24euL6hyzwkyjlD+xQ1I=;
	h=From:Subject:Date:To:Cc;
	b=Q5gNJkThO/m2qp1lkXJFqQaBB8SIHT6CIi8Qj5jPW5jfIX8YyEvV7VIB4Nn4+aG2X
	 hLuXcz3sIQz6ljVMErk3JkZNmqUGJpd2nSXULBASDJbfQF5YyUFx3bu0s+n0YlzFRl
	 Jxu3ly32wNL/+kRr0G5N+6zH/jHTURY85x5I2ayOpOHtaCvhx7fD9wMxkCNN7g/1ms
	 iebecj6TSgrh6xha2dzaTCfpgDOd9SpX4z20D3I7Vg3lybrTtVH1gwCufq0LG8iwhs
	 kPPP6tZsPBPtvswVFKD/1ULSU7THWCJy5ZKvm+o6quJzm6rTOzK94drCj8PZFtqXlD
	 iTW114BWt6elA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH v2 00/16] mm/slab: introduce alloc_flags and
 slab_alloc_context
Date: Wed, 10 Jun 2026 17:40:02 +0200
Message-Id: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFKFKWoC/2WNyw6CMBBFf4XM2poy4SGu+A9DSFsHqDat6SDRE
 P5dwLhyeZJzz52BKVpiOCczRJos2+BXwEMCZlC+J2GvKwNKLGQhU8FO6VY5F0zbOdWzwNyUJ9T
 S5KWBdfaI1NnXnrw0X+anvpEZt85mDJbHEN/755Ru3i9f/eenVEiBustUpiudY1HfKXpyxxB7a
 JZl+QAQBFkpwwAAAA==
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
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 5wf6aabrhzxkpenbcdtoh9jfdjquspf1
X-Rspamd-Queue-Id: 6A01B140016
X-HE-Tag: 1781106021-659021
X-HE-Meta: U2FsdGVkX19SwsqbMP9gsaREFpze1ydvKzj0AaNtjrOR/pRn2tg9QdiZhSZifmciwE+DaFjQNKAJGdg0J8LES44YZUAFJ+kG9ta0MCA5xlwNqOUEzrSHCqUZmjnuLsTRToAOQ0CRpZVzK7vlYu+AN10YbWQBJQQt2qH3953YIhgnG0EDvYCURj5KoupUrl0/Hg7f+tIyJxZ1MzmyabK3HGq/ypxXCcQBMSYwRqQxBxo8fVVqvF/CDqwldAiH8NRz0avOS84I0+KNxxEh8IHXM9DN7tn/G8YS/vcWTzsWsC0kqY93levjzq4+YJktWBkI3QYi+k46kRsy+SAuaKlbehMSZrqT2WAV0xUTPZZ8CT18pxfnAxnbK7OTfBuDP7J1MynRz4rZRkN6rZEqlRxFaRvvMuVfujECNt40QLTjBLXTpYhRQshmHr/SCUvEwaXCfLTzwn4FViAyV9wLtvCRIngK6B6Gs49PpHv3tBc4jnRgkONcHSi1ipza3leQILpAs6ZZrdJydh39KY1kmTINrzjcJm0uuRvpx9zc8FQyo5XsI4YzOb6cq+eEOy8Tka++kTcZLr1zO43hd5rV7K+bvX8kuHY32mNY2iN/y/8+Lv+et65EAllvx2SDQfxpCjA1kW6/5MItgeVg9xeSDQIFZm0jnBEA4GUbdNHuhSec27HU9kfdkx04jyvOTXop/bvF1Bm0UhMf7tFWt512OTeFANl1Uuz0TNIiwLnd2+WE695rG5U2zayQHD+f+fEfMZ4RxJ8NGIrjk1/isbuY/GTVbQ9CsnsulGOhkgl4YzCjeG4mghCKIv/IYgTR9CyBFDtloCCMixx/wmlfjzne1cW/A2hgDM16YARotMevIrA4I2Ca8F8K7LUF7ww4+Oz6MmIXhxZEG9rtOQBSo1wd7Ry9pVmjYt1oDVWpwTrHSMI49MAUSaBrdWCxDZmbpw2fOlbMr8aLBvjdcI/ZRbrIAOW
 7qL+7Tkk
 ll0ZuolbciPEvjZ/Ov6gwvBqaqiCWbr0K8W9fuwbeHlamUHSUzecihaUTlYVgmi8+vyWuS7pfB3IqPUIOFw5yl4j5ybBj1qkOLBjVP7PNEokVd3H35nyTt74etUXG2V/aJ458a4p66RL+KKXnCuvLO1VSN559zziz9o8rFnSzjV1p3XAEH5X6Y4N8Ezu5uoUiufnnKMmqsZNh7dT6/WmendajzfXL3gRvjhqKwm+UGu7GPFVYb2ct0YrR37ndoR5g6qfxMrdQeK1L8L04kwUgy/akMAA7Us04+Xewkk2ahnatM0HaQZwmnlH5X5UPSxvjU+YceI9HYQL0hoJfTu116TgJUb0TsXCkPVe9pnyLIxZroJWkQB4/nFV3TA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is based on slab/for-next. As suggested by Alexei I will
try to put it there ASAP (hence the early respin) and see if it looks
stable enough to be send in the second 7.2 merge window week.

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
Changes in v2:
- Due to Sashiko review, drop the idea of zeroing orig_size
  unconditionally, as it can break krealloc(). Thanks to that found a
  pre-existing bug fixed by the new Patch 1. The kfence zeroing related
  cleanup is implemented differently in Patch 2.
- Prevent nested kmalloc_nolock warnings due to added gfp flags
  (Sashiko)
- Fix a pre-existing issue with opportunistic slab allocation from the
  target node only effectively dropping __GFP_NOMEMALLOC and __GFP_RECLAIM.
  (Sashiko)
- Move kmalloc_flags() definitions to mm/slab.h (per Harry).
- Link to v1: https://patch.msgid.link/20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org

---
Vlastimil Babka (SUSE) (16):
      mm/slab: do not limit zeroing to orig_size when only red zoning is enabled
      mm/slab: do not init any kfence objects on allocation
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
      mm/slab: allow __GFP_NOMEMALLOC and __GFP_NOWARN for kmalloc_nolock()
      mm/slab: introduce kmalloc_flags()
      mm/slab: remove __GFP_NO_OBJ_EXT usage from alloc_slab_obj_exts()
      mm/slab: replace __GFP_NO_OBJ_EXT with SLAB_ALLOC_NO_RECURSE for sheaves

 include/linux/slab.h |   5 +-
 mm/kfence/core.c     |   2 +-
 mm/memcontrol.c      |   5 +-
 mm/slab.h            |  29 +++-
 mm/slub.c            | 439 +++++++++++++++++++++++++++++++--------------------
 5 files changed, 304 insertions(+), 176 deletions(-)
---
base-commit: 500b2c9755301742bdbb61249511ac11a4665dae
change-id: 20260601-slab_alloc_flags-25c782b0c57c

Best regards,
--  
Vlastimil Babka (SUSE) <vbabka@kernel.org>


