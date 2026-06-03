Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CFFACD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 08:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C24246B008A; Wed,  3 Jun 2026 04:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFB716B008C; Wed,  3 Jun 2026 04:03:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B381D6B0092; Wed,  3 Jun 2026 04:03:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3C856B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:03:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 420861C1174
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:03:20 +0000 (UTC)
X-FDA: 84837861360.08.3A9E387
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	by imf07.hostedemail.com (Postfix) with ESMTP id A28CA4000B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:03:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=XhyhxQVt;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780473798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mlIIN622rLr22plKnXfWrvgdqL032Wr8kiqR08LjPLw=;
	b=0CKfpfsTP+pY/5rFKcaNBUmVJ7RFS215YEljA1hQXVXCVgO5/9rBIiZKSSN1WAKY/kq/WE
	rf3wbg+NKzgPdlGpQH0buQ064/ztZ47s5SGSksW0NFzeAbBriUeoeF1RiM3mq39wvFw5Hz
	kYpv6/vzpujd5Zt+F4UrhKFGPihCgEI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780473798;
	b=6l/OvnGmwWllGOTIRo5UFMAxX+8KNTmlolqT48ygAGS5lmX+wdO7CB775m7zfoic/aAMSQ
	HSKakZDbtA3PJr5dESwvNWCBizsRF0eJpggHXYxxIGbZ5TjXTstq7AhjcSrForjn1qvFDO
	TH5zeXUg+z1gp7kyVdLosKh5Tt4HT8g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=XhyhxQVt;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1780473785; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=mlIIN622rLr22plKnXfWrvgdqL032Wr8kiqR08LjPLw=;
 b=XhyhxQVtwdu7YbtdnzYMUC3AbW7fd3Fk7Kr6/21Dx9zAadCBWoz2E9PbnH4ma1yhudSGD2
 IrrqyI9TK8j83Bsk4eqOYyYWzgddEpiFsAPz+Jl4YsydWx2zDs9j8Expvc69QMmG2qesvI
 zfof/RMcR8Qr9NKceU8ApJ7JA4Z5fq2cjM5BHdc+EhksGOSoaoETqQCz+QNEj4EA3JJq2t
 NkDJGByIHw7LE9TEVjSkHDjeCy/kKujZvBQLUQH6ocrKCJB6PnuJZeunvbeGc9IreKdnzm
 mX90p4eYnF5SS7Mf/AGvpm5J3cVuw2I33X0TBqYuI3rUznY/U3Pp912tlONBBw==
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a1fdfb7+727e02+kvack.org+lizhe.67@bytedance.com>
Subject: [PATCH v4 0/8] mm: speed up ZONE_DEVICE memmap initialization
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed,  3 Jun 2026 16:01:44 +0800
Message-Id: <20260603080152.64728-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: A28CA4000B
X-Rspam-User: 
X-Stat-Signature: h6m3wmop76qestqikcrzuermcx6o8u77
X-Rspamd-Server: rspam08
X-HE-Tag: 1780473797-452586
X-HE-Meta: U2FsdGVkX1+EfcwmAcYqRLXHTRASo0/Q2cvaSlcg5CxaJcnRIIh5wqSCZkHNJyNjzv7nt7bBWt2erjx0LZetNwqbWFkFhfUs/3QpPu1BtPWfxPZ/5zt8z1oiuV7/1cpNFaHKfRRa5AnBI51ZYWHaZhzOT6X2JRUz5GngZHmf3aAbNWBSFeGzrcK420rEaznhHGPfM5JxKV5fHSx+Mp7qrs5yn4iMzpueR+MpnKEYAXa8MJB4cypw80vzajngqHGWjvlAGcGeI0Kk8WRFtldSVhTk8Edt1ScjKvUXGM+d2Uz6rwfLIlBHjnd/6F9U7ohW5LkyV/5n95DMqLzi2fVyLl5aXdC/vZq8LCHWdvMjhcF6b4yV77qFrdiz1NSMg2DtPQ/Vqt5yy2e0AigECSTz+5W9Q4F6GwwBMueMwyllptdhzPME2TimcrCmFoHBB4wD+w/H2PgZ0fBiZBypYFgcHf70neXb36FCKKk3zJIvecjDFkgFX9B2GA0j8hfZAy4rqxmsMjIjNw+2DDDp2SRk4ntVICd8d6QyMrvkqNqu918qzyp/2XuBzBsU/A5y2ILNASIWk41phtuo7wKRDKhCnJw2F92Liu/ZgL9so2XetsZu3dy7wvauMImI0QZ8sFOYe/lpRq7g97L3VnNam2Grsqa7OnX0+Ou0Tv3VbI0+CWNysYaOJsjH0r3EzcZgdu0acHs8V3sjuM8IZmL27PJIdZsX/pnV1wKKIT63575lKmBObN13LFpW2J2DToSgAotZxA12ljxsxoJ+ub3rLCL6Cv+7gny9FwoQP2lEEqwZIcQRms8IrTVTtiz9144qEbBfpDf1zEXmYH0uf+mTSp4DDw0wAVSBInISdjhz+9ZFzZXg6jcJLJabRyia/1NM8Iu7fJTssqXuL/PqGrd94+ebZsRQ+V/hVUsZodDi1xjcm7lIysguFLpDlMTBHfFT/OV0wNnN8xF1ubxhZHk4RBb
 DWfaBiFe
 90jD8+UO8/l2Ytz+HopVE2pS1zvcSlORtoDqV3tlBO/qZDG5TOJsiTyJAcA0aS93UPwHHS0GDgKSHioDVrCsdy6TEsUqEd0wn366gtlFZN22JZCpMISofRGquJ79MuBhXG5cs/Qi7+bQYLnnWsh+ZxhDTONxCdqRCAcP5L7VHNwxJxqYNMTyC2t/J9mWyQ0BizkF1MyVetRW+gc37A4cahSi6QK6eK/5fdA9/1rNRsucvcDU6/cXzm+RrMOTCfb88sYpix/ftuIXU9Lq1BDUugAUsN32pIXy4sVrpITb4R708D2su0W7bcSrIpwSKWUy5hmEBRJ8cd6CWSt8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memmap_init_zone_device() can spend a substantial amount of time
initializing large ZONE_DEVICE ranges because it repeats nearly
identical struct page setup for every PFN.

This series reduces that overhead in eight steps.

The first patch fixes a stale comment in __init_zone_device_page() so
the documented refcount policy matches the current ZONE_DEVICE code.

The second patch factors the reusable pieces out of
__init_zone_device_page() so later patches can share the same logic
without changing the existing slow path.

The third patch adds set_page_section_from_pfn(), so callers that want
to refresh section bits from a PFN no longer need to open-code
SECTION_IN_PAGE_FLAGS handling.

The fourth patch adds a template-based fast path for ZONE_DEVICE head
pages. Instead of rebuilding the same struct page state for every PFN,
it prepares one reusable template through the existing slow path,
refreshes the PFN-dependent fields in that template, and copies it to
each destination page.

The fifth patch extends the same template-based approach to compound
tails, so pfns_per_compound > 1 can also benefit from the fast path.

The sixth patch introduces memcpy_streaming() and
memcpy_streaming_drain() as a generic interface for write-once copies.
Architectures that do not provide a specialized backend, or cases that
cannot safely use one, fall back to memcpy().

The seventh patch extends x86 memcpy_flushcache() small fixed-size
fastpaths so struct-page-sized streaming copies can stay on the inline
path when alignment permits.

The last patch switches the ZONE_DEVICE template-copy path over to
memcpy_streaming(). It keeps pageblock-aligned PFNs on regular memcpy(),
uses memcpy_streaming() for the remaining write-once copies, and drains
streaming stores before later metadata updates that may depend on them.

This is not intended as a steady-state data-path optimization. Its
benefit is in pmem bring-up paths where memmap_init_zone_device()
dominates device online / rebind latency, such as:
  - fsdax or devdax namespace creation and reconfiguration
  - nd_pmem / dax_pmem driver bind or rebind

In those paths, the kernel initializes a large vmemmap range once and
does not immediately benefit from keeping the copied struct page state
hot in cache. Reducing write-allocate traffic in that one-time setup
path can therefore reduce end-to-end device bring-up latency.

The optimized path is disabled when the page_ref_set tracepoint is
enabled, and sanitized builds remain on the slow path so their
instrumented stores are preserved.

Testing
=======

Tests were run in a VM on an Intel Ice Lake server.

Two PMEM configurations were used:
  - a 100 GB fsdax namespace configured with map=dev, which exercises
    the nd_pmem rebind path (pfns_per_compound == 1)
  - a 100 GB devdax namespace configured with align=2097152, which
    exercises the dax_pmem rebind path (pfns_per_compound > 1)

For each configuration, the corresponding driver was unbound and
rebound 30 times. Memmap initialization latency was collected from the
pr_debug() output of memmap_init_zone_device().

The first bind is reported separately, and the average of subsequent
rebinds is used as the steady-state result.

Performance
===========

nd_pmem rebind, 100 GB fsdax namespace, map=dev
  Base(v7.1-rc6):
    First binding: 1466 ms
    Average of subsequent rebinds: 262.12 ms
  Full series:
    First binding: 1359 ms
    Average of subsequent rebinds: 108.36 ms

dax_pmem rebind, 100 GB devdax namespace, align=2097152
  Base(v7.1-rc6):
    First binding: 1430 ms
    Average of subsequent rebinds: 229.12 ms
  Full series:
    First binding: 1273 ms
    Average of subsequent rebinds: 100.17 ms

Li Zhe (8):
  mm: fix stale ZONE_DEVICE refcount comment
  mm: factor zone-device page init helpers out of
    __init_zone_device_page
  mm: add a set_page_section_from_pfn() helper
  mm: add a template-based fast path for zone-device page init
  mm: extend the template fast path to zone-device compound tails
  string: introduce memcpy_streaming() helpers
  x86/string: extend memcpy_flushcache() fixed-size fastpaths
  mm: use memcpy_streaming() in zone-device template copies

 arch/x86/include/asm/string_64.h | 140 ++++++++++++++++++--
 include/linux/mm.h               |  19 ++-
 include/linux/string.h           |  20 +++
 mm/mm_init.c                     | 221 +++++++++++++++++++++++++++----
 4 files changed, 360 insertions(+), 40 deletions(-)

---
v3: https://lore.kernel.org/all/20260527033636.28231-1-lizhe.67@bytedance.com/
v2: https://lore.kernel.org/all/20260521040124.10608-1-lizhe.67@bytedance.com/
v1: https://lore.kernel.org/all/20260515082045.63029-1-lizhe.67@bytedance.com/

Changelogs:

v3->v4:
- Rebase the series from v7.1-rc3 to v7.1-rc6.
- Rework patch 4 so the reusable head-page template is seeded from the
  first real struct page, rather than being initialized directly on a
  stack-resident template object. Also add an explicit !nr_pages early
  return. Suggested by Andrew Morton.
- Rework patch 5 similarly for compound tails: seed the reusable
  tail-page template from the first real tail page, thread
  use_template through compound-page initialization, and reuse that
  prepared tail-page image for the remaining tails. Suggested by Andrew
  Morton.
- Tighten patch 6 so memcpy_streaming() maps to memcpy_flushcache() only
  when the destination alignment and size allow the transfer to stay
  entirely on the non-temporal path; other cases fall back to memcpy().
  Suggested by Andrew Morton.
- Rework patch 7 so the existing 4/8/16-byte cases remain handled
  directly in memcpy_flushcache(), while the new aligned fixed-size
  fastpaths cover only the larger 32/48/64/80/96-byte cases. Suggested
  by Andrew Morton.

For changelogs of earlier revisions, please refer to the v3 cover letter:
https://lore.kernel.org/all/20260527033636.28231-1-lizhe.67@bytedance.com/

-- 
2.20.1

