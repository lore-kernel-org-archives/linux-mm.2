Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26FC2C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 17:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 028056B0005; Thu,  9 Jul 2026 13:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1B756B008C; Thu,  9 Jul 2026 13:38:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09226B0092; Thu,  9 Jul 2026 13:38:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 725A36B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 13:38:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E4D24168E0E
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:34 +0000 (UTC)
X-FDA: 84969947748.14.EC00B7D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7072A20006
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 17:38:33 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f1gPSnOF;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783618713;
	b=63IEMBy/pozlKbuTTu54g+ECv/2KP7qCKSKuBpufaCoffmumfwOKKWanCdaOTnwGuyUFVZ
	WOdT7/GrfiiNUezmWNtMJQMfLguS4d/33g4GO7uzyskiPeFfw3SmRMyucF3FhnnMXlwTpG
	FV03CbBbNI52/0zTvGU87Zim/Q+57UY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f1gPSnOF;
	spf=pass (imf31.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783618713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ML+T1jqorHxvPA3U5Bm2XJPJkZmW94GzjT4iRAPtUPo=;
	b=FUiUQ5fLCYLLLB+Ym8xPvsRZzqoql7seVzsx+HUbJnDoPXJMMbTW4iZtOWhXg3Z6jD1o8K
	qiiHJrjYD9Eun142lorUABwAfaqToQm7qriG9jvjaYtIJeY9pOdcz4jg3gerp4xnEdGwWU
	puVKO3s+3GHNwYp0qLD7enZgWN/BKAQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B36106137D;
	Thu,  9 Jul 2026 17:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 454201F000E9;
	Thu,  9 Jul 2026 17:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783618712;
	bh=ML+T1jqorHxvPA3U5Bm2XJPJkZmW94GzjT4iRAPtUPo=;
	h=From:To:Cc:Subject:Date;
	b=f1gPSnOFpVzoXykjOTween5Dbx8dOb9BTJGWIR7Xq333E9/2WgOFIwmnIQeGe9zth
	 fySmSZxYtVMYYgdTHBe4Y8tEq1c3jlWBkB6h09ElBpzvrA9Ck1Ia5lsKr4qCTdGnwR
	 tKm9FLDLPSQx+F4BRy1QES6YcKpplnnlxiVdHghEHWE+Bnpl69/ibTKtfeI3Wx8iki
	 mOkw9XpDbm9YueViPD5e7PgUesoVHQowwqHXOlF/vAoDL0oG6r0U3wp6P4GdDqYrkd
	 j98zUeJ0D9jAjjg/STQi9KEvT5iqO+wRWqZyznYs6RqqG/D5b6SsZu23v2G7q+SNDH
	 AL6ZVP+YgHvqQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>,
	Jork Loeser <jloeser@linux.microsoft.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/21] kho: make boot time huge page allocation work nicely with KHO
Date: Thu,  9 Jul 2026 19:37:49 +0200
Message-ID: <20260709173821.429921-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7072A20006
X-Stat-Signature: 31ejoh1yzyhgewaofk56rmtmio7gypzx
X-HE-Tag: 1783618713-945543
X-HE-Meta: U2FsdGVkX19jHgtqU/Bq91M/JkdIQVWL77Lnr80y0mIEBOUzCLoOkOFma4Mi0q2Jn3OiENvBUTunX0OlX0bTzibsx+kVXE/2ypw6cq2BDxca92tC+WNTo6xFHV1Ht+m2fY24xIq7at0PInZPG6XKdi8FB2A0Cfv1ZcesZNi2GX8iPjxsb4PJgrhK1a+JzTD3pYxj4/b5Ot0Vsg8K0fFz0rKAT1zM86/g3yTYw/XOFMkzTPx0gAi6dSTU8pLQ20JlHoQ3r2jnXb/J+R5DbaCBzU56+vqEm4GEsglKv8nFbPIxQs4dZdDK4T6fOBsX2T8jUKva/vh4DLxrxO3X9poV4+q+yxoUtS2oY5l0lWKBNcCt7L6HL4oM5Vcc5w+BHAOOoqMqeuSZ5JFs5zk/WKb/vjFqtkXEmrG4J9bSBZSLS/gJt4zIDYTWeMc6JiSCv7KlKQmJ6I1D0KmRfxP2SXTZOP045ow0kwVARnEq+qkflRCEX9EZqskgyHYvXP8qjPS/joruxAYi9oBFBSxeZapOmnTe79iCle+E/GELgJGaiu7a7MNf5pcmVDlbMs1iT7rcwuncybeUK2rHLf6/ljSbtamoxtNR0AW2j6jJJPSnCw57W5DQ8M05jz1PLQ3ENzz3LgehnRtTloIMVdzD5oN/waH47NLl2v+XStEuPRJhVf7aEtcene2nE4k6VLyOCs7SZRHpMv1t2w2/qphvOfbIfH9NHsRRGmSuFCXi4q/hq9CRVk/xOaN0hhniuZLEPygknfE1YNC+0Bl4FLHGkwbns8SlEZ0EfYXBN/66+cZ7eKRGplL3Wk6pB/WANPhUW2cfrfobrfS8/+YG9EX6MIk9yCQjxaTSp7mzGFvsUkDHB2mCGnySAzIei5twpv6Flv46/FPLVxKA0FAwscg2ciVDkVvvQ7UdlLfMhdPJtFMKbSeJYsJOMcIHOdUavZquMKGea3UkDh3czBjE+g6I47q
 McDuE8gG
 6pEO1rkHfO0xGoFo3ir2FljXWTVsyT8SCEjTHyrZDy7tmK7EYnd13EwGxOHCu0Ow5/NvCMYNHcdyIEhXTrhHmb+eMNs4OXwZda+WcN+VcJDOVZy0U4Q9PtJHrKoWrX/CzFXcG9VgkwF1ayMddC8U4PNJEY9lYj/KznZKKVau3uT6geNkhJsNPItyej8rzldK8ouwamV6UAASkgH7ApCPV9TrkhrQojTVzmU84dG3XmvrE/qw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Hi,

Gigantic huge page allocation is somewhat broken currently with KHO.

First, they break scratch size accounting. Since they are allocated
using the memblock alloc APIs, they count towards RSRV_KERN, and this
scratch size when using scratch_scale. This means if huge pages take a
large enough chunk of system memory scratch size will blow up and fail
to allocate.

Second, scratch can not contain preserved memory, and if hugepages are
allocated from scratch, they will fail to be preserved with the upcoming
hugetlb preservation series [0].

Fix this by introducing the concept of extended scratch areas. They are
areas that the kernel discovers on boot by walking the radix tree and
finding free memory ranges. See patch 10 for more details.

Discovering the scratch areas needs some preparatory changes to KHO, the
radix tree APIs, and to memblock. Patches 1-17 do that.

Patch 18 adds the scratch discovery logic.

Patch 19 adds the dedicated memblock hugetlb allocator.

Patch 20-21 fix the scratch size calculation with using scratch_scale.

This series is based on top of the liveupdate/kho-scratch branch.

[0] https://lore.kernel.org/linux-mm/20251206230222.853493-1-pratyush@kernel.org/T/#u

Changes in v3:

More notable changes:

- Refactor how key width and table depth is calculated.
- I noticed that extended scratch breaks migrate type init during
  testing. Below two changes fix it:
- Remove memblock_is_kho_scratch_memory() and kho_scratch_migratetype().
  Instead, add kho_init_scratch_migratetype() and rework how migrate
  type for scratch pages is initialized.
- Move migrate type initialization from deferred_free_pages() to
  deferred_init_pages().

Other changes:

- Use kho_get_mem_map() directly in kho_populate() and add a comment on
  why it is okay to use.
- Don't say "export kho_scratch_overlap()".
- Add a comment in kho_extend_scratch() that it should always be called
  after efi_init()::reserve_regions().
- Get rid of memblock_reserved_size_flags(). Use
  memblock_reserved_hugetlb_size() instead.
- Define KHO_EXT_BLKSIZE to SZ_1G and add a comment explaining why the
  size was picked.
- Fix memblock tests build.
- Rename kho_ext_walk_key() to kho_ext_walk_leaf().
- Add some comments around the kho_ext tree callbacks to clarify which
  tree the function is called for and which one it uses.
- Move initialization of kho_in.radix_tree to kho_memory_init_early().
- Do not check if the tree is already initialized in kho_radix_init_tree().

Changes in v2:

Detailed changelog below.

At a high level, the major change in this version is to remove
MEMBLOCK_KHO_SCRATCH_EXT. Keep MEMBLOCK_KHO_SCRATCH as the only memory
type and mark the discovered areas with it. For HugeTLB, add a dedicated
allocation routine and if allocated memory lands in scratch, do a retry.
Also introduce MEMBLOCK_RSRV_HUGETLB to help with accounting of scratch
area sizes.

- Fixup commit message in patch 1 to make namespacing change clearer.
- Use @key in kernel-doc for radix functions.
- Add a runtime check on key width.
- Move all mem retrieval logic to kho_mem_retrieve().
- Add a comment in kho_mem_retrieve() explaining why mem_map won't be NULL.
- Rename callbacks to ->leaf() and ->node().
- Fixup commit messages.
- Clear tree->root in kho_radix_destroy_tree(). This lets the tree be
  re-initialized by calling kho_radix_init_tree()
- Add kho_get_mem_map() earlier in the series.
- Export kho_scratch_overlap() and use it in memblock_is_kho_scratch_memory().
- Get rid of MEMBLOCK_KHO_SCRATCH_EXT.
- Introduce MEMBLOCK_RSRV_HUGETLB.
- Introduce memblock_alloc_hugetlb() for hugetlb bootmem allocations.
- Refactor memblock_reserved_kern_size() to allow calculating size by flags.
- Exclude hugetlb memory from scratch size calculation.
- Collect R-bys.

Regards,
Pratyush Yadav

Pratyush Yadav (Google) (21):
  kho: generalize radix tree APIs
  kho: make radix max key width more obvious
  kho: disallow wide keys in radix tree
  kho: return virtual address of mem_map
  kho: store incoming radix tree in kho_in
  kho: move all memory retrieval logic to kho_mem_retrieve()
  kho: add a struct for radix callbacks
  kho: add callback for table pages
  kho: add data argument to radix walk callback
  kho: allow early-boot usage of the KHO radix tree
  kho: allow destroying KHO radix tree
  kho: add kho_radix_init_tree()
  kho: expose kho_scratch_overlap() to kexec_handover.h
  kho: initialize kho_scratch pointer earlier in boot
  kho: initialize preserved memory map radix tree earlier
  mm/mm_init: init deferred page migratetype in deferred_init_pages()
  mm/mm_init: don't rely on memblock to get KHO scratch migratetype
  kho: extend scratch
  memblock: make HugeTLB bootmem allocation work with KHO
  memblock: add memblock_reserved_hugetlb_size()
  kho: exclude hugetlb memory from scratch size calculation

 include/linux/kexec_handover.h              |  16 +
 include/linux/kho/abi/kexec_handover.h      |   9 +-
 include/linux/kho_radix_tree.h              |  44 +-
 include/linux/memblock.h                    |  23 +-
 kernel/liveupdate/Makefile                  |   1 -
 kernel/liveupdate/kexec_handover.c          | 549 +++++++++++++++-----
 kernel/liveupdate/kexec_handover_debug.c    |  25 -
 kernel/liveupdate/kexec_handover_internal.h |   9 -
 mm/hugetlb.c                                |  22 +-
 mm/memblock.c                               | 144 +++--
 mm/mm_init.c                                |  59 ++-
 tools/testing/memblock/internal.h           |   5 +
 12 files changed, 645 insertions(+), 261 deletions(-)
 delete mode 100644 kernel/liveupdate/kexec_handover_debug.c


base-commit: 08412b8c707fdbccb7bf2116f0554fe09113cd53
-- 
2.55.0.141.g00534a21ce-goog


