Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CA68C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 11:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 672D26B00C2; Mon,  6 Jul 2026 07:43:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 623B26B00C5; Mon,  6 Jul 2026 07:43:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5393E6B00C6; Mon,  6 Jul 2026 07:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7766B00C2
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:43:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C352167A02
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:43:32 +0000 (UTC)
X-FDA: 84958166664.12.0952093
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4DC0D1C0004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:43:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xAQlJV+n;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783338211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VTOGSBABu9xUimde1qEWT6hO01zgOc9yO0AubTBXGFc=;
	b=Kt01vsKukWpX2VFwDj09f+OkSaYAhd2MRKH17lJ7EHw+48z1aNvB9uqJR3yRN2mCmrGE4K
	5p3OBaVjts5vr85csj6Sfhz2iPslhkAjWh2MEkrW3qgj+y7g8UtoAWX8PLly3G/raCjFxx
	HbnawJ/gV+18fWezn1xcw459qWb2uvI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xAQlJV+n;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783338211;
	b=tAIrpvZa4TrXPF8c93PhcVloEilxzUlc+vKwmwtTy73C/I4sz07d93RShJa8tA/ANDwa1K
	GZs1zImynpVuRLF1hQeX4y+8OrN/+zzGKVCyRGfSF1RTlBzX8D1DFsdu4JREbRK7AZRscW
	pxXAkrMruAi2DZin2K3Wd9trmv5xuAM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783338208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=VTOGSBABu9xUimde1qEWT6hO01zgOc9yO0AubTBXGFc=;
	b=xAQlJV+nzbR3YaLlkTGv21EwhPTmfIAYp/a5m7GqLigUiIVa1X/4pW8aIcPYJc3lH/wLFb
	3x28NrXCiFJbDLyKAyR8oQSJWmiKd+Yh36QHcbCnGokQcKvNkBEZh/zKJTrm0Skp97IPDA
	Q6Tv1jxdzr+fWIUUGrJt3ptSZIDA+7s=
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
Subject: [PATCH v2 0/6] mm: preparatory patches for PMD level swap entries
Date: Mon,  6 Jul 2026 04:42:02 -0700
Message-ID: <20260706114320.1643046-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4DC0D1C0004
X-Stat-Signature: e44tcq78qqrihms17xr9oud5efjx9cc7
X-HE-Tag: 1783338210-834312
X-HE-Meta: U2FsdGVkX1/CcYwVqmDbu7b5CpJ1zPguE9YL2ECzDEz5kUIYXCy5xGF+rE4il8rs5hg3KlGgWBhRFY+zkZzJBlPl3EW4MuUVijq0ggJ1bFpgtmMuu5duo9hgxFUT00lkdy3MnPBBgjDz86E9eCD8ZhG5LVfcUHclCjtWWe8INP3kaJJRS5TUlNr1ZVghZDwCNCBOBIQBGj8bTD3kn+i6h4zf8WoXFpoRXQDTcGVz0Lw9XGUcQRk7k74FScUvOeWUEkOUgFnawzd7d1QhTjrvPjX4je5Qqta4eCD3/+tfrjKZwC4KN6qSDe7IsLiK9ACR4cvyW3MHtDpLX1NCPdo+Q9PpMR4k7IMeljaheVWLhA8IjPbCSlYTehczpHPXza5XBAegFXFMU2WujQ5aHx+7A/9ZBsEPo/IPzAU7mDZ4npAk6Rw6E6Lo7WWDf424/alQCuNRPAK14TAdrKQuuZBbroAGdrbuFQqkcV1U5fHyMj1Yp3LUPttPg1BBDEwHn/cHlhUJ5xMcRDg+mW2mPtxiJ9xXELEgEAPlWbUxOkEdjfYY7vU2MRQnQEEJ4twJTiL6yVSZDXsWQbCYqppp/JqUzELvjMeEb5d9HJnMMxd8eLcYPEz1/6pkrs7imPwHvYzay72dMJrjxcOs9ew/48QG40jQMN/Tinq1iFJZsuBOgY0MJidl4IOMovOjo0Gy6fNaIhN4TQn/98FgT/Tb41dks1i17JlJUi2jJYAdvuncJz3TcFmsdCkjkJeIus5Ak3RU1r0PcBfKYV/mgd0IKzrv97Wsii7QnvxiPsf3ONJP7yWbuNYZS5C2UXSU3NENcum5Oqzbvw+04qKEoGA0g44WbBT/RtsWzkY/MB270ojmSpJwj/hxc9Xyk38sZIx+guDhrZ4R3xN2LorALkmeb7dYFHa9UUabpXb3NhZUkIt/IJ7RnRE7eefSnjmTvV/JrYEE7YhNkHVsWOMFd5d/T57
 hcR3NzNL
 DcIKzvfSlsW4tPCwgC41fnnHopCh3fTvNRn9TC7l1eYJE/tFaJe2leaVIY/kQeOH3we5mkaAt70+L6xcem5hADNrKec8yTaKYPqQr85Db6Ict8YWs1drQ4XT31caxv6fBZBkY29/wf8Y8mwBTVCDBHb2lS7bzuLfXh1vQlqQGOO9QG3yuPSAbGxB8t3eM/wzTkhsPyZcFSmHBcJ7S0GBOg2I5w/ak3tcO32ADBaIdN+ZEVIJkmVeRCEQnog==
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

  6. mm: rename ARCH_ENABLE_THP_MIGRATION to ARCH_HAS_PMD_SOFTLEAVES
     Rename the architecture gate to describe what it actually enables:
     PMD softleaf entries.  Migration remains the only current user in
     this series; the follow-up series adds PMD swap entries.

The patches are based on akpm/mm-new from before this series
(git hash: a8754c9b38cf2fa1d764fedd29ae8b9f3ace8058)

[1] https://lore.kernel.org/all/6E99CC4E-A026-4DE3-8A5A-34216771F521@nvidia.com/
[2] https://lore.kernel.org/all/b08cafbb-a4b7-4609-84ae-dbb2cfcfc8be@linux.dev/#t 
[3] https://lore.kernel.org/all/20260602142537.198755-1-usama.arif@linux.dev/
---
v1 -> v2: https://lore.kernel.org/all/20260630164143.1595669-1-usama.arif@linux.dev/
- Remove unnecessary comment in patch 2 (David)
- s/ARCH_SUPPORTS_PMD_SOFTLEAF/ARCH_HAS_PMD_SOFTLEAVES/ and rewrite
  the commit message (David)
 
Usama Arif (6):
  mm: add softleaf_to_pmd() and convert existing callers
  mm: extract mm_prepare_for_swap_entries() helper
  fs/proc: use softleaf_has_pfn() in pagemap PMD walker
  mm/huge_memory: move softleaf_to_folio() inside migration branch
  mm/migrate_device: move softleaf_to_folio() inside device-private
    branch
  mm: rename ARCH_ENABLE_THP_MIGRATION to ARCH_HAS_PMD_SOFTLEAVES

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
 mm/internal.h                                | 10 +++++++
 mm/memory.c                                  |  9 +------
 mm/migrate.c                                 |  4 +--
 mm/migrate_device.c                          | 19 +++++++------
 mm/rmap.c                                    |  9 ++-----
 25 files changed, 90 insertions(+), 67 deletions(-)

-- 
2.53.0-Meta


