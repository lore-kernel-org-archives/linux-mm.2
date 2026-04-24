Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F5C9FED3CD
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 715266B0005; Fri, 24 Apr 2026 10:01:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D7A6B008A; Fri, 24 Apr 2026 10:01:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5669A6B008C; Fri, 24 Apr 2026 10:01:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0CF6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:01:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 63B461B6F5E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:01:26 +0000 (UTC)
X-FDA: 84693611772.05.82CC5DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B0D9CC0012
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:01:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UF6mG7Dh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777039283; a=rsa-sha256;
	cv=none;
	b=n8Jb/RFBfVt4uOoQVgkOxopTbv5xNxYNnmJlw1vfjF97HVp8yugUhYLFm5YBh3qICtUT5W
	jLqE9vn4Jkfpc6720zT5feV7Eh74M7/7oXwUls2f7I2b97m4+uLCjYCY6LbvOjBsDG4lmS
	/n8cb3xbkfqQRlPGrOdly+K1kWFDbdU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UF6mG7Dh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777039283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hoWIey7imDsa8W79L+EJK/6Oy5tMaZ1Ka5xZdoGC0H8=;
	b=mVdkuN2ZMdo4biq6iYAhnrtJy4zBEYzE2/QSHplOFxtdKfQONlLdAh6ljPob7JF2K/NYNj
	ZbXPJAAEz1ZZgva3GSKut0HtLdJCyDpqdc4s77vg2H4o388VfK3bWxGzKO5SdUVeO3v2zi
	ZPgIHyaf85v8ssS02fZ+yCXkhmjCJaY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9FC21600AE;
	Fri, 24 Apr 2026 14:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DD6C19425;
	Fri, 24 Apr 2026 14:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777039282;
	bh=DFy9AhLANCuPcMWrswbPLcW9ACoxuoxOoAiw0fx5Ep0=;
	h=From:To:Cc:Subject:Date:From;
	b=UF6mG7DhKt9iEDmQyL15UPzJXX6xodvOiof8RN6zvJQjMYULbqq/STXmrcmxxVuEu
	 mRpC22v3aiBpQMAPb4Sq7yFL5Y4R5glujEtTCVG8mUYE2Trd3Pni513IFcAjMQnpNY
	 VJ603ahyjx/ABQoBZLGBTQRxhcc6x7qm7rh58j8a79h7aemfifLmrUs8L0a21jY0X0
	 q5TRr5ZN+740Q/jeBf1ZlPK9gQ8egsvjuxpJlH+oRiuBHB+vaKw1H1TxiHogGDetxR
	 R3FqPVK1eCeRB2LIgWMb0NOyUJXP6l/RGlE5V2ugWgb1rHPeQJzLst1sJPRPsG+M7G
	 wUL5HSVpKOzWg==
From: Sasha Levin <sashal@kernel.org>
To: akpm@linux-foundation.org,
	david@kernel.org,
	corbet@lwn.net
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [RFC 0/7] mm: dual-bitmap page allocator consistency checker
Date: Fri, 24 Apr 2026 10:00:49 -0400
Message-ID: <20260424140056.2094777-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B0D9CC0012
X-Rspamd-Server: rspam12
X-Stat-Signature: dzs7y89jtjrt5apknkhtpefykcwhjq79
X-Rspam-User: 
X-HE-Tag: 1777039283-331124
X-HE-Meta: U2FsdGVkX1/G2tuZskPqDt3F8e6QSaXJ7OUxo3Tlr6k9REQqBbvuqKCx1AfqIeVOpHOIOU9MYd+kITzdU7BQQP01sU+OHhnlMrgUKX2bLwZw7UKQBqbW7f5giNDfTeLpyr4PLYLMCoS7sWMx3umgnqs5wX6Ip9aCKBprqjU4AcOiQsSljCmyh2OQP5oJFKvrpbZzBhEkXuSTP38VtggqPqV7RYeclIpCCjXBiGu/8Qj5jkzrmVIbBmfyzQRIPfIyAl2HtRx57oZzg/yVyF59mAexAoQwTn5FHAkHV8jB3Tk7aNHZw5sSD2TbFt4ElByZBrzlkeYB2QdgaNvzrBvjKLXPKqayoFiDriYWChH1sh0sYilbW4novwaasn0i/Jt/Lzw5+EJ0anT994LLdRU/5FnRXaQdcb/HuiE0+vwSgJ8oylN8WYOQ2y8GrwJctWamSs2DJmlQRT/wjBsJnwGpF1v6aJwGHpQ3z+TEHfTJXgBh0XpeE4hOUatNf0kfHQq8awviFCBrG0RVay7W6U0iXAGai1LGwdCZ2QEjzEUTV9zqYJeD2Qnp8kRuWVpEpzV4V78QeRAk9zbb91qe5uyypytcoiNI9SB3RdcIcIHg915jPlikilgtLzBGzH4MhOaWDg3yZQazgu1TqYfiNV3ZvI1HxucWc6d7+IfxO5kKwzyCUFsCQV9sfnC2XxiTVqvzDq69zIuzy4CJUAQ6wnx+3juKNg+lDjjV+tC85h4M7eN3yLDxfBO0Z9Wryj5EYFKCskDtDqg/DCZN6JoV94wFzDvwIKUd1ZfaBlyDsbbjd7J4PF/rA9HlOMW7vKRtkTl6huZUk0Yi6AtiMGZTV4SOzhJQas4WuXmAdWoXyGQIlVPqhYT+6pC8aobp/F14YlZYlyPJrGp7Vb0o2eWmkTLHfaPAOcWq4+UyD71jpilExy95HIpQBzosXsJHmPW+eevSnfks+TI4sFbo/O5jo9O
 xwW/9j1/
 RBSo6MHa5Wg9zqtL3kHZ3Wpb8fYJae1vgA1LG7GKv0BQQpThLUOG0YCMWuxkSWOt8QUfcNgCpn+gupiN4Q80aEliIozbmF+wVfD/JRPm/V/+qvqbjB2xTabpwE9HI7aIyX4gDZ9kEqcu6KOkS6y7Z52oT9UtW2V7bGjUyUTFnCwPv7QGuBFJsVYrYesxv2tEZKIBuumK0xPvN3Os=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Existing memory debugging tools - KASAN, KFENCE, page_poisoning - detect
access violations and content corruption, but none of them can detect
silent corruption in the page allocator's own metadata. If a hardware
bit flip corrupts an allocation bitmap, the allocator hands out a page
that is already in use (or fails to hand out a free one), and nothing
in the kernel notices. This series adds a dual-bitmap consistency checker
that maintains the invariant primary == ~secondary across two independently
allocated bitmaps, so that any single-bit corruption in either bitmap is
immediately detectable. The approach is based on NVIDIA safety research.

Field studies consistently show that DRAM errors at scale are far more
common than textbook assumptions suggest, even with ECC. Schroeder et al.
(SIGMETRICS 2009) found 8% of DIMMs experienced errors per year in
Google's fleet; Sridharan and Liberty (SC 2012) reported similar rates
at LANL; Meta's 2021-2022 work documented silent data corruption at
scale, including memory-related faults. The critical property of
allocator metadata corruption is that it doesn't trigger an invalid
memory access - the corrupted data is structurally valid, just wrong.
KASAN instruments accesses, not metadata integrity, so it cannot see
this class of fault.

Functional safety is a different discipline from security that aims
to reduce the risk of hardware and software misbehaving to an
acceptable level. Security hardens against adversaries; safety hardens
against random hardware failures (cosmic rays, cell wear-out, thermal
noise) and systematic software failures (bugs). ISO 26262 (automotive
functional safety) defines four Automotive Safety Integrity Levels,
ASIL A through D. ASIL-D, the most stringent, is derived from the
severity of the hazard in case of failure. IEC 61508 defines similar
levels (SIL-1 through SIL-4) for industrial systems, and there are
equivalent standards for avionics and medical devices. ISO 26262
requires Freedom From Interference (FFI): a safety element must not
be corrupted by faults in other elements. For an OS kernel, this means
the memory allocator's metadata must either be immune to corruption or
corruption must be detected before it propagates. The dual-bitmap
implements a way to protect from corruption coming from hardware or
software - two complementary representations of page allocation state,
allocated independently via memblock, where any single-bit fault in
either bitmap is immediately detectable. Performance is secondary to
correctness in this context. A safety mechanism must be simple enough
to audit and certify, must fail deterministically (panic, not
log-and-hope), and its correctness matters more than its throughput.
The dual-bitmap adds two atomic bitops per alloc/free, but for
safety-critical deployments this cost is acceptable because the
alternative - undetected corruption propagating silently - violates
the system's safety case. The static key ensures zero cost for kernels
that don't need it.

The natural question is why not use page_ext. The key objection from a
safety perspective is that page_ext stores per-page metadata in memory
that is itself subject to the same hardware faults we're trying to
detect. The dual-bitmap approach works because the two bitmaps are
independent allocations - corruption in one is caught by comparison
with the other. Embedding both in page_ext means a single fault could
corrupt both the tracking data and its redundant copy in the same
allocation region. ISO 26262 recommends this approach for protecting
against hardware faults, but it also helps against software faults -
co-locating both bitmaps in page_ext violates this principle. Beyond
the safety argument, there are practical issues: page_ext adds
8-100+ bytes per page depending on enabled features while the
dual-bitmap uses 2 bits per page total, and page_ext initializes
after the buddy allocator while the checker must be active before
memblock_free_all() hands pages to buddy.

Sasha Levin (7):
  mm: add generic dual-bitmap consistency primitives
  mm: add page consistency checker header
  mm: add Kconfig options for page consistency checker
  mm: add page consistency checker implementation
  mm/page_alloc: integrate page consistency hooks
  Documentation/mm: add page consistency checker documentation
  mm/page_consistency: add KUnit tests for dual-bitmap primitives

 Documentation/mm/index.rst            |   1 +
 Documentation/mm/page_consistency.rst | 211 +++++++++++++++
 MAINTAINERS                           |  10 +
 include/linux/dual_bitmap.h           | 216 ++++++++++++++++
 include/linux/page_consistency.h      |  84 ++++++
 mm/Kconfig.debug                      |  59 +++++
 mm/Makefile                           |   2 +
 mm/mm_init.c                          |   9 +
 mm/page_alloc.c                       |   4 +
 mm/page_consistency.c                 | 360 ++++++++++++++++++++++++++
 mm/page_consistency_test.c            | 274 ++++++++++++++++++++
 11 files changed, 1230 insertions(+)
 create mode 100644 Documentation/mm/page_consistency.rst
 create mode 100644 include/linux/dual_bitmap.h
 create mode 100644 include/linux/page_consistency.h
 create mode 100644 mm/page_consistency.c
 create mode 100644 mm/page_consistency_test.c

-- 
2.53.0


