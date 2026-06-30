Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A360AC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:41:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 859386B00AC; Tue, 30 Jun 2026 12:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8306C6B00AD; Tue, 30 Jun 2026 12:41:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76FA86B00AE; Tue, 30 Jun 2026 12:41:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 335AF6B00AC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:41:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A89AF12059E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:41:53 +0000 (UTC)
X-FDA: 84937145706.22.AC65AEA
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf21.hostedemail.com (Postfix) with ESMTP id B753B1C0012
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:41:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XGNC9xkK;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782837712;
	b=vtDUs45tNNHUAk83jlekwkU+3x6P1VeHlZMoRPaV3H5ULizc5YwXLtIbGBT/R1I0DXDP/H
	KuDhd0dOCPl7RBGViswWfxI7HYcEuxJ/XkjMj3CFBHlpEwep7yyYC5AD5uPQBzr3rVhl5e
	24WediR4tV9FLGro5ZEPIKQ4OU3/xqw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782837712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KTPjRh7UZtQb2sdzHCtoDKVi+rSL6aZD6W2dn40Xe2s=;
	b=7L50aONxtaPS/lcc4QlQcV02znUVevPFTbMQTbt9ovHXDydpPM+RGC/8M6Y1W4+Zlflbi+
	1Ud0ZM1H2iXWdOJWTads+9xFmZGZP45+7onhl96DHDlQrG3UFcR8QPEMvjVjmnIMi1wd3X
	ImylLQKGlV9NcT7oreg6HrWKJ6KHNZQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XGNC9xkK;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782837709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KTPjRh7UZtQb2sdzHCtoDKVi+rSL6aZD6W2dn40Xe2s=;
	b=XGNC9xkKehCDk04ip+vz2mGdyzo6HPlfi+ojTjQKNCNTfA4rQEnNNNd2wKYakUcZ+jNYgM
	pRJzgyuzBDctosrGeYpHbe2Ig4YbBEb5XunlbaXJ3KhQOGTZInmBnKD30rsBkLC/iEo09B
	+kXRA8KWS96f4GJNw92s9iOqQs6LaAo=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 0/6] mm: preparatory patches for PMD level swap entries
Date: Tue, 30 Jun 2026 09:34:37 -0700
Message-ID: <20260630164143.1595669-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: g5uoa38ii9f1ppt7e7ynwi5b3hta5x6s
X-Rspam-User: 
X-Rspamd-Queue-Id: B753B1C0012
X-Rspamd-Server: rspam02
X-HE-Tag: 1782837711-589445
X-HE-Meta: U2FsdGVkX182Gm/xNX7xabp+T3+h9MHkSLUfuVRBCGkd9OY3bLINBqJiF8L3y3BBj1TZZ2vw1WbzHpVLwRW7++umqkk30ZTERHwO4QkH8u/0gilbUyFlMWvu4Cl0eC2gLhh+cmgYWcbliyYY01khK3FwktkLYfaE6kZKNly7UTFUkTCKNsQleKs7aGDO6jmhwVDDnsjlswN2zBXP4CTxpur4a157Ojj6QS9nIu7xASU9V/VGwTqlv/79EizJgq2BiQ00PcF2+cbNRZy0Zgk+gzzxSb9r+Y4+vZ8ptrLNCxP478+6otVQM2HUXrUGgrmGcvHRaVAjikG1JiMxzVIz7qFFrQ8fR+kFuycmU+3NuXD2Ype5t+H2H8jB0rhXPBfmuJBsPOFGeVyKhHHMoZl+qL1TeWioV6DyVrtcR34r6It7et4T8+OLpC9tLStna8hg8pAA+GTFzP3Z4ThmQSoNETNDRDkJvhzPScYInPdd0Db0wCRY9u89FCTrTwCkrhMF/J4SjNDL070MgluaAeJKAnVK0Q8yGvNhuyV5aHt3aH0aYVumAjuprW1U1v3g0de+Jp3LZ5wNvKQSiriqz2g0FOofAiOI4Gow4E4ioGt+2AGai7mmMDqJqUzF2232uBsiOvJa64d9hrqAYmuFme7CP3rLZh8xWDzXp9gyvurV3hvz0PNyS2i1XWBCY93dP27pin9RJhEKD6zrXhglzDN5zSjOaaOwtz2eE3ARfbjpsdvJVGn2kVBB+uw4xCwBay3XSECJTK57LPBEKLAk4mihWO754X5zMxEhtgHkh6AyGJccDnhrjF2fQHyY7HMu5n0Qiq7kixzzISkpjJzaNVbStspHW9QpdwMEbEczlk9vdV2YJIrYJ29yYX/AfKniJ9cE0ruZFEZtuZnX1dGBuuFzJvxUNT9PZ5lu+vCVVjiwJSfTsPNbSNHD+NFlztrsVrvO1fmGzknxo0kuhXpmZQC
 ebm1N8fX
 66hcwQ7EDPgcmXnpaK3q5/8hYE/+XIB8Vdy4wiXz/Cp8sUBh0JGyuzG644dLj/iOqE6zeXayPEUDkUr1A8aXw8RspZ0cdsAn+PRnxSvcZaJYWxr+sVE7Nn2RIUQwouoJUWxxfAwCpIPE5FfFHeR2sWaIbftZFFwE5ufQ/48f0ukWAvprVfzUeHusqdqSVOrimQM5o8xy0U+g9BIKZFze7cXtv0oj26onwn0z+5A4RxJ9aR49pevCrJF10iQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the preparatory part of the PMD page table swapin work.  The
full PMD swap entry series has been split into two parts:

  1. this preparatory series, which contains the first 6 patches. Zi [1]
     and Lance [2] suggested to separate this out from the core series.
  2. the PMD swap entry core series, which depends on this one. I will
     send this once the preparatory series is merged in mm-new as v3
     as the combined is currently at v2 [1].
     I have not marked this prep series as v3, as its not really adding
     support for PMD swap entries.

This series does not introduce PMD swap entries and does not install any
new page-table entry type.  It only cleans up existing PMD softleaf
helpers and call sites so the follow-up PMD swap entry series can be
smaller and easier to review.

It should be safe to merge independently.  The patches are either helper
additions, refactors of existing open-coded logic, defensive checks that
preserve current migration/device-private behavior, or a mechanical
rename of the PMD softleaf Kconfig gate.  The follow-up series depends
on these helpers, but this series does not depend on the follow-up
series.

Patch breakdown:

  1. mm: add softleaf_to_pmd() and convert existing callers
     Add the PMD counterpart to softleaf_to_pte() and convert existing
     swp_entry_to_pmd() users that are constructing PMD softleaf
     entries.

  2. mm: extract mm_prepare_for_swap_entries() helper
     Hoist the "register mm with swapoff" double-checked-locking
     pattern out of try_to_unmap_one() and copy_nonpresent_pte() so
     future PMD-level users do not need another open-coded copy.

  3. fs/proc: use softleaf_has_pfn() in pagemap PMD walker
     Avoid assuming every non-present PMD softleaf entry encodes a PFN.
     Existing migration/device-private behavior is preserved.

  4. mm/huge_memory: move softleaf_to_folio() inside migration branch
     Keep the folio lookup in change_non_present_huge_pmd() scoped to
     the migration-entry branch that actually needs it.

  5. mm/migrate_device: move softleaf_to_folio() inside device-private
     branch
     Apply the same ordering cleanup to migrate_vma_collect_pmd(): only
     derive a folio after confirming the PMD entry is device-private.

  6. mm: rename ARCH_ENABLE_THP_MIGRATION to ARCH_SUPPORTS_PMD_SOFTLEAF
     Rename the architecture gate to describe what it actually enables:
     PMD softleaf entries.  Migration remains the only current user in
     this series; the follow-up series adds PMD swap entries.

The patches are based on akpm/mm-new as of 29 June
(git hash: 15654b0268cd65b4e673510c0377774e61b86397)

[1] https://lore.kernel.org/all/6E99CC4E-A026-4DE3-8A5A-34216771F521@nvidia.com/
[2] https://lore.kernel.org/all/b08cafbb-a4b7-4609-84ae-dbb2cfcfc8be@linux.dev/#t 
[3] https://lore.kernel.org/all/20260602142537.198755-1-usama.arif@linux.dev/

Usama Arif (6):
  mm: add softleaf_to_pmd() and convert existing callers
  mm: extract mm_prepare_for_swap_entries() helper
  fs/proc: use softleaf_has_pfn() in pagemap PMD walker
  mm/huge_memory: move softleaf_to_folio() inside migration branch
  mm/migrate_device: move softleaf_to_folio() inside device-private
    branch
  mm: rename ARCH_ENABLE_THP_MIGRATION to ARCH_SUPPORTS_PMD_SOFTLEAF

 arch/arm64/Kconfig                           |  2 +-
 arch/arm64/include/asm/pgtable.h             |  4 +--
 arch/loongarch/Kconfig                       |  2 +-
 arch/powerpc/include/asm/book3s/64/pgtable.h |  2 +-
 arch/powerpc/platforms/Kconfig.cputype       |  2 +-
 arch/riscv/Kconfig                           |  2 +-
 arch/riscv/include/asm/pgtable.h             |  8 +++---
 arch/s390/Kconfig                            |  2 +-
 arch/s390/include/asm/pgtable.h              |  2 +-
 arch/x86/Kconfig                             |  2 +-
 arch/x86/include/asm/pgtable.h               |  2 +-
 fs/proc/task_mmu.c                           |  3 ++-
 include/linux/huge_mm.h                      |  2 +-
 include/linux/leafops.h                      | 28 +++++++++++++++++---
 include/linux/pgtable.h                      |  2 +-
 include/linux/swapops.h                      |  6 ++---
 mm/Kconfig                                   |  2 +-
 mm/debug_vm_pgtable.c                        | 12 ++++-----
 mm/hmm.c                                     |  4 +--
 mm/huge_memory.c                             | 17 ++++++------
 mm/internal.h                                | 13 +++++++++
 mm/memory.c                                  |  9 +------
 mm/migrate.c                                 |  4 +--
 mm/migrate_device.c                          | 19 +++++++------
 mm/rmap.c                                    |  9 ++-----
 25 files changed, 93 insertions(+), 67 deletions(-)

-- 
2.53.0-Meta


