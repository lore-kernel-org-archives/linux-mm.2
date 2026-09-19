Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2E7BC982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 13:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F1026B0093; Sat, 19 Sep 2026 09:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4743F6B008C; Sat, 19 Sep 2026 09:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33B5B6B0092; Sat, 19 Sep 2026 09:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01B1A6B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 09:53:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60619A4F9A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 13:53:56 +0000 (UTC)
X-FDA: 85230655272.22.B3C48F1
Received: from mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf22.hostedemail.com (Postfix) with ESMTP id 69611C0005
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 13:53:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="UBBaig/R";
	spf=pass (imf22.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789826034;
	b=w1J2r1iJGkx2uKDx9/CT6qsIPVBb3XDJeDnBYwn/sk/5IwK5RjcfSklO8YvXQ/Pi1YlM4n
	NYeJ1TjWtdbRlI3CR6bPj6I6k16l3lZiLr7OifRGNIShiTafFXdtghjJT8kJZYWGvD6ohl
	CDzhGMVgn+JBg+OwbP996zkzFvDtz/8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="UBBaig/R";
	spf=pass (imf22.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789826034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9IZTMVT0u3yL9a+1YQQo/O5hZnIG91a7LbdX96ryVF8=;
	b=5WC5d2uc86dBLhFQB0dq3FV4JwkEyAB10c0b+XWX85ZkLcxGpZ8KpTAoNU3CEuCoLG8hs4
	uWkftytGtBfZt3/tidi4CSPHPg8ZZsm8eyGkmqGlZb9NXAtiK9PC8+OXcA5JVWrn/7FkZg
	Ss3UcKVYA2wAyRgkEURWrXeJKMD6L/8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eQ4xyA9EmXhqdnCJrxxqL/S8/wudyVgXuV6D/sxwFlE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789826032; v=1; x=1790430832;
 b=UBBaig/RewgVOXLE40DXVc4lBwCHFY4j9CArY81BjLIZ5OF46HSZycswZwz/JVh0SkNCtCTo
 8onwf8A0N6OZDrwo7g6QDJ7hS4SXCigv8Z0n+rjF1gUZtrsKXV6FiGk9ErpfwwiyFakDSiEOGPZ
 afDb/olqTfl3rjSdFutmq5ok=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 568801b7d887b774;
	Sat, 19 Sep 2026 13:53:42 +0000
X-Mizu-Trace-ID: 568801b7d887b774
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>
Cc: Priyanshu Kumar <priyanshukumarpu@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <kaitao.cheng@linux.dev>
Subject: [PATCH v2 0/3] memblock: Remove unused exact nid allocation API
Date: Sat, 19 Sep 2026 21:53:24 +0800
Message-ID: <20260919135327.74089-1-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 69611C0005
X-Stat-Signature: sin5rcb8j8duf3jw77z93yqcz6jq9th7
X-Rspam-User: 
X-HE-Tag: 1789826034-998464
X-HE-Meta: U2FsdGVkX192Qbwzxkx+QRacpFP1VA9czJ0/ebx//tM5tG+1fhwxvTmX7ehoOPprtJ5RcZrgYkaVccKZmV/pYSSs84++9HGBFEfjuNLWEwRYMtzOJRZDUe2Cx67OQw4NuCXdkdJD9sFPUinjvG6eDHyoP962aBZAk+XmYyMTAGyHo8DDTqfRHQbDnX8Eyp7H5Ilb7MT2RLwVbuppCrBC7PUXiiaB12aTKPy0xY3kOpqAwfqNtrv4MXKDQN7CSS8uu99H0dFkCgwsgHGidtO4eI/gl8gdd9UxqNVUoKGcj0UzXP6ue4VUasuM3kMZ9rHpn450/AGQUPg1MQsSFAg1KaygXE+1jXOl86nibMbIrdHDPNKX9oCrj1S77guoAEyJDco1UGtH8durg44tQXgseNU1BoimCnH/WBfCQcQKCylWS5dSSaTgqzv58SFJXm946KGWQDmepJfkgOE1CrYvdqXrK3KbA6fTYaqonsgcvYPpLU3W0c4WTYWBb3y3ZVNdX4mOPyWPLSYRNmQ/+VUrKaOXLNW5sYTzcJyYwixhKCSb9WW4CDD/leXziw8dYB5AZOySzoXbePLvOgtTqJbc+fc6JDqs/J598ebk9kVQcQaCRVO8Zzg+e+QX24mq9Mj7lvvXHQUDixG76D/3MsMkfozV6f25GFyRlM3TR9Idv7JIq9L4On48FZunwN1+kUUI8vcJcruc2FuJngz+IafVuqx621sxKECVJR8yMhPyUiDEbs1+LYOPk7M8HNNkuT2cPRB/rFEQ2oi56Y15xD/usipNQ2D3tIGP/nKRHeu8iVGauxxboIDALuCxCy1bMX5PNrjt9GX3sy4ly8tvy5xLpLU1ozKZH5ldYPJ1w9oFkA41i3SfCTLrSMMoYJxnd5kEaN65BU4FmKIM54tQKdplWtweb1YhntirPybsS5m9iOdSGtiytdSkHkkKOHz2sM5TfgFJ+OnHafmHulAafTb
 pqvlYXJu
 byuY3C6fSFv8jnUMJrM3MDjatcCxss0lK6vo3YfM7OoZPyCtXsxbm9PSd0Cqwj039skZFY3/bWd39V/l1oMqF1d+As/ic0UmKuf7S7WXBiVBgjlPvuLrhFv7mdeRvQGibS/3g4NcX2E4pSZTs//EMbgIDm7b3NALkq2S0f6fFPPt5b0V6ZYWgNFU2A+/VR9EgRWvr+P0R/bx2htdE4jh/fJmHknaGFoUpzJKw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit ffe55393137c ("mm/sparse: remove sparse buffer pre-allocation
mechanism") removed the only memmap_alloc() caller that requested an
allocation from an exact NUMA node. All remaining callers allow fallback
to other nodes, leaving the exact_nid argument unused.

Remove the argument from memmap_alloc(). This leaves
memblock_alloc_exact_nid_raw() without any in-kernel callers, so move the
applicable exact-node allocation tests to memblock_alloc_range_nid() and
remove the unused API. Also remove the exact_nid argument from the internal
allocation helper, since all of its remaining callers allow fallback.

Exact-node allocation remains a required behavior of
memblock_alloc_range_nid(). CMA uses it when reserving per-node CMA areas;
allowing fallback could leave the area's recorded nid inconsistent with
the physical location of its memory. KHO also uses it for per-node scratch
areas that must remain on the requested node. Therefore, retain coverage
of this behavior by making the applicable NUMA tests call
memblock_alloc_range_nid() directly with exact_nid set.

The tests that exercise memblock_alloc_internal() retrying below min_addr
cannot be retained unchanged. Unlike memblock_alloc_internal(),
memblock_alloc_range_nid() treats its start address as a hard boundary and
does not retry from address zero. Remove those tests along with the now
unused TEST_F_EXACT dispatch from the shared allocation tests.

Kaitao Cheng (3):
  mm: Remove unused exact_nid parameter from memmap_alloc()
  memblock tests: Move exact nid tests to memblock_alloc_range_nid()
  memblock: Remove unused memblock_alloc_exact_nid_raw()

 include/linux/memblock.h                      |   3 -
 mm/memblock.c                                 |  44 +-
 mm/mm_init.c                                  |  14 +-
 mm/mm_init.h                                  |   4 +-
 mm/sparse-vmemmap.c                           |   2 +-
 mm/sparse.c                                   |   2 +-
 .../memblock/tests/alloc_exact_nid_api.c      | 454 ++----------------
 tools/testing/memblock/tests/alloc_nid_api.c  |  20 -
 tools/testing/memblock/tests/alloc_nid_api.h  |   1 -
 tools/testing/memblock/tests/common.h         |   2 -
 10 files changed, 50 insertions(+), 496 deletions(-)

-- 
2.54.0 (Apple Git-157)


