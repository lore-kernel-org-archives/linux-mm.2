Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4428CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD1BD6B0005; Mon, 15 Jun 2026 07:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA9406B008C; Mon, 15 Jun 2026 07:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E69C6B0093; Mon, 15 Jun 2026 07:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91C666B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:54:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 212011C4607
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:54:47 +0000 (UTC)
X-FDA: 84881990214.26.FBAB340
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 67993180008
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:54:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HGmCN35m;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781524485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dA6pXgYKZb0WIDS2w3jJIvRv7wIBxlN6dP+Wu8BjXu0=;
	b=zuJbtrQXVKDIPzMo3WvCYf0Un30vzHpxfGULlf0YZ2N6TtXD5hVwOFiQvDM4fnb6D9dutG
	S4e+S5G8pwvfv6inQDGr4yS+j/Tf3lWUfZ6yFfKfnhbcHKa3ErZb6kM5PR60tdeusll2SX
	eZwj3YldHs9+JTwK8DQwTcRQYtFMOyI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HGmCN35m;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781524485;
	b=VY4FiqzRwtrPDaAAnE6pGbmAv5ANrw83OEsav2ZrYShcQJo642AWUMtN33KzAQDB5SB02E
	xxsjRUBjBKQD6KHblsva5cz3FU5EDa+6y3XwxY/6/U3DHOPNPFol+mnY0VgjMVT6Jg+qFA
	V4FoZN32nrpK+9ujsYgDryfXtq2HsFQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E8C3F601E1;
	Mon, 15 Jun 2026 11:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0571F000E9;
	Mon, 15 Jun 2026 11:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524484;
	bh=dA6pXgYKZb0WIDS2w3jJIvRv7wIBxlN6dP+Wu8BjXu0=;
	h=From:Subject:Date:To:Cc;
	b=HGmCN35mELvu47Clj9Yd/zpHmlPIi8WgOMfhm4P+zBXvy5oadvPdfjG3Z0Ewtygm/
	 5gjE3A0SuWkXu95LiUj4NLYERoL2xlNDinf6jKmlCi+xwXOVdR+EejK8VaCMtnM54S
	 LLDxe8OImksC1W/yslLnIWJSGajL5TPNKb62B3+IiTXpJvGh4z3Q9TM8+4GSypjhZ9
	 oJtWJn8hHK58r/4+UUthS12avoYO+bfxDzesRWwcgd5VSlkP7QzP4T4Bd9ij1CIOLW
	 G/5jZ4o6RAeJU2d31H/GyvZGLo2KlFWdQ27hudgxEbIfZVCOn+mHmiRt+WRsfaNrUq
	 kZFPZqdIfrMhw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH v3 00/15] mm/slab: introduce alloc_flags and
 slab_alloc_context
Date: Mon, 15 Jun 2026 13:54:33 +0200
Message-Id: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAPnnL2oC/23NTQrCMBAF4KuUrI0kY39deQ+RkqTTNhoaSWpQS
 u9uWhEUZVYP3vtmIh6dRk/2yUQcBu21HWLYbRKiejF0SHUTMwEGOcsZp94IWQtjrKpbIzpPIVN
 FCZKprFAkzq4OW31fyePplf1NnlGNi7M0eu1H6x7rz8CX3puvfvnAKaMg21SkspIZ5IcLugHN1
 rqOLH6AD4GzPwJEoeAVi9dIzssvYZ7nJwCbJ3IFAQAA
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 67993180008
X-Stat-Signature: bx9dfqtzfidp18ne4rjbprq7ajjddyb7
X-Rspam-User: 
X-HE-Tag: 1781524485-538070
X-HE-Meta: U2FsdGVkX1+uwbcnTTuQMrmQ71M/SbBeOD2IjZNyMivw92i89vlIa6xpTN1ndqEFzJxqodcX/NX1BY77Vq8Icl4XTRdbu0E4v2MHwJA+SpwX8o79YQZ4qRlM0AMcPhdLVijP713zYsXyb8kKyykoANbWeS4VPX4XjOPLpcs5UwvkLMDihhm48fVMy9hgJK7LDpsj4M3JMQpgMIfomQLw21511RYKCAGpCavX02ra2jDvawmHjvOjImxq9D2GftXIuX/zqwg6zcEZeOOLyVhwAiTzt8QvWJQ54pAHtLGAtolo6N9cdzPTu63dPxEP9oMibEC1p91m5lhax4L7k5Nq1M4IVtNoRAYf1FZ1UJIZHeDiEqYIsb6p6NIp9MLD7HNLnGQ2YRr3trM19u9ElEy1quKu+Ws1rFHhVTsVsZum+6czMoFJDeuB/X+pTdK66YZLgkJafQLdsEU824Cx4VOTX05RjDMIQHsXJqyoNNZU8VGFxVvbCbn4NbiEhCMWLy/+9mJvXc0hw70AMIkdE7H5hy8+om+acno7+CF6LJX1gunEa5XsPwPc8vN2pC5iNvl5ouWgRkyr0h4eMq5wS8IixTddsuj+HItPgL3HzJ9sfXHP8q3+W8PtpyAYsQj09Tdh2e7/0i8wnQ+wGv6BqJX+R8rVFjX1L8rl0cqsLkHeegaqS/L7/+V5N5hKqN57RTe5KnGWg26BrT43HySXLVqdCSp5LB5P3IJAonOuO+GWwnKo+Zd0wzrT4LeJa3NAn4SvlpKfowM9YOnDS72M3FkL/0fqe4H4SW60gIpCYF498G5e9hkGVK0ITMVMOkNZaEOuzmLKJ2uoAB31h3g0tjadOspFhDlkEJoDxWyJFhsaK4AQuvNYO5isVeFcScXsEhfZifuXWx8tzmkWHfJRljH7tWv5rv4X89+o/UZi91l2Jb6k5TpOHFCyXa0v8Rfqk75VWo+AOzPazHrmW1BSmNW
 N2HVL5tL
 lVQQMYCDW8JUe4T3EnnSDekkpKgc02nWabEFS24huATZCpwpfmHAnRVA2lV77jvDga/DZmfTJEu4Th92zmhMnAYODEpmHmjAhoyDHyp3mB5ZA2ckRBBHV350pmExEj8dfoBWQILyx+Qp36AoMDsscmO0Z9ausUmSVTEcR5x+ervloWcyxwngqmlRQ5axIHeP4f+oEnUGW9xyp+S0ATapOG6IPi628rWqJM+eKGf+bEJDHTTRWQs+Of0VeEZKN6Rftj57GrnN/OQaWutS56D2boEldueRFCev4u8zwMBhnMisxeBjOgNVTj65XWcw7IBfrgiywpLF+DPzbfAcVBG9Hm/0wg9rh7R32kcJAOGbHpF8UqXNvOi0L1eTdFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is now in slab/for-next, based on the slab-for-7.2 tag that
was sent as first PR to Linus. Posting new version due to many
accumulated changes, for final rounds of review. The plan is to send a
second slab PR with this early next week, if nothing explodes.

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
- SLAB_ALLOC_NOLOCK - do not spin on locks (used by kmalloc_nolock())
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
	size_t orig_size;
	unsigned int alloc_flags;
	struct list_lru *lru;
};

This also replaces the existing struct partial_context.

The last necessary piece is kmalloc_flags() which can take the
alloc_flags in addition to gfp flags and is intended for the recursive
allocations of sheaves and obj_ext arrays, so that both
SLAB_ALLOC_NOLOCK and SLAB_ALLOC_NO_RECURSE can be communicated.
Internally it decides between kmalloc_nolock() and normal kmalloc()
depending on SLAB_ALLOC_NOLOCK.

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
Changes in v3:
- Applied R-b tags from Harry, Hao, Suren (thanks!)
- Former Patch 1 "mm/slab: do not limit zeroing to orig_size when only
  red zoning is enabled" fast tracked as a fix to slab-for-7.2 PR.
- Patch 1: refactor kasan_init handling (Harry).
- Constify struct slab_alloc_context usage eveywhere (Suren)
- Rename SLAB_ALLOC_TRYLOCK to SLAB_ALLOC_NOLOCK (Suren, Alexei)
- Reorder patches 5 and 6 (formerly 6 7) (Suren)
- Move trynode_flags refactoring from 7 to 6 to avoid bisection
  hazard.
- In Patch 14, support temporarily both __GFP_NO_OBJ_EXT and
  SLAB_ALLOC_NO_RECURSE to prevent obj_ext -> sheaves -> obj_ext
  recursion (Sashiko)
- Expand OBJCGS_CLEAR_MASK to allow kmalloc_nolock() warnings
  (Hao Li, Shengming Hu).
- Link to v2: https://patch.msgid.link/20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org

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
Vlastimil Babka (SUSE) (15):
      mm/slab: do not init any kfence objects on allocation
      mm/slab: stop inlining __slab_alloc_node()
      mm/slab: introduce slab_alloc_context
      mm/slab: introduce alloc_flags and SLAB_ALLOC_NOLOCK
      mm/slab: replace struct partial_context with slab_alloc_context
      mm/slab: add alloc_flags to slab_alloc_context
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
 mm/slab.h            |  29 ++-
 mm/slub.c            | 488 +++++++++++++++++++++++++++++++--------------------
 5 files changed, 329 insertions(+), 200 deletions(-)
---
base-commit: dfdfd58cce1c3f5df8733b64595448996c08e424
change-id: 20260601-slab_alloc_flags-25c782b0c57c

Best regards,
--  
Vlastimil Babka (SUSE) <vbabka@kernel.org>


