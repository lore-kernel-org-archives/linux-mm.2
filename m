Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72E43103E160
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 10:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4966B0170; Wed, 18 Mar 2026 06:58:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7BE06B0172; Wed, 18 Mar 2026 06:58:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91FC6B0173; Wed, 18 Mar 2026 06:58:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B90346B0170
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:58:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5933C1A0652
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:58:46 +0000 (UTC)
X-FDA: 84558885852.11.68CA833
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 50B894000A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:58:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eKiMcZ85;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773831524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YpWbdmy2u35pquIoQDOkSYbA2SDw10dr75CUG2SUk9Y=;
	b=K9oq1GAYnx+5tCao1v0smuRNBKFPlyvIwTfa1U9jBKld1ZvSvA1sqaZLU5aCwH0z4TAehD
	U+wF82VQ0PRq0MfXuBZuiLX5l8LEi2U/l5Y6FEn9d8v7znNjjA0AvsOtWKnHYd5Da68hFn
	EPhYXb0Qx84r5FEy5IYj9GgIkRr86r0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eKiMcZ85;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773831524; a=rsa-sha256;
	cv=none;
	b=Oa3W9hMzeZUt5QPv87RQFwk3+VpXBi7zxRsPZ4I/qafJMVWrkYNqRy3DaJg3Cevh1WYZyG
	yX1rrK0BhiNeSLe/TmBkuzdkwZ5DnBxYYEnq2T9hl6UBH+UaKo4DLtJAjEHxw/pviF9/Gk
	fiM36VQHPgLf9V5m4mNuL14Cqahu/7o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AC42B4474A;
	Wed, 18 Mar 2026 10:58:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65881C19421;
	Wed, 18 Mar 2026 10:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831521;
	bh=kLYySycm4Q+kO2x2jmLEs+z7oAnQtdjmqDIbHrWcbjw=;
	h=From:To:Cc:Subject:Date:From;
	b=eKiMcZ85WLFC8bXWA/cKx5AD46CSeZMTj7t+7hTK626aenEZLjVU/M1bTaE/8BRRS
	 X6S1Y6bTAssMWXPL91D/crg1FtPFmAE77lAntj2Q7m/PYz0wUHGJzu4AZOtr5VKYhD
	 O9x+2NB3x0e+Qee3RPqpqmkTck/x41t2dPoDUPGIkmdpXAuih590JlibeZmTDiQlQj
	 +q9tqVFXNLT50Bo4J93EDhzKNN36MtH2iOtNw1iebPTvJL5rSLJyP/H3K7GSINY4cU
	 Jl739DvgI4xC+TxFvGCyIhqDj4Pg7a/bTjrprZ63VJjVDKtRWfpfjBV+NYDfdH+Dsr
	 4yKWpa/0srIqQ==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Larsson <andreas@gaisler.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <jackmanb@google.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rob Herring <robh@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	devicetree@vger.kernel.org,
	iommu@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 0/8] memblock: improve late freeing of reserved memory
Date: Wed, 18 Mar 2026 12:58:19 +0200
Message-ID: <20260318105827.1358927-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 50B894000A
X-Stat-Signature: 44otscdscef7uok9jyo3b5san6yqc7ms
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773831524-434412
X-HE-Meta: U2FsdGVkX1+HM3LZ7PDsdROtdc/KgEXNYhz4DuzR2A7GaDe0SYejm2QTivP8b8NYpTiKpmjEhw11OqKpM1cWVkNyRkXLwjTSV/0koNHAeDAyD9V0jJf5eiZsCrRuzTSkX/B2FOBQ4ee3mQMx4C3x97dTiWMOPwNIYLYKlyYTiQ9EHYNydJK6R5IsRgOkSwh9QRsmQsKWN6bHVIxKFOSMg8bNikscLEtfKsIZVHKkXxAMNHi2K5I4NRIdWVNlGyocr+ICokLMB73RMj4Msl3lMzVA0NcHEI1bRDQy1ZMrg09vh0CS8IXWTFHYBBfnzZH88cD6D4UeT1u1sLfLY4KGHzBhm/OVyKr5o9tAhxLiiff6NMS4lIZJbJzrEs2gwBaWoHk9FwFFtlWbMPyXBz7Gug53z5VSNVshwhmZ4wyYdnyMQqf8zVoYettM1IlRHdB8SUGDdSoUPgiW2jpP9ekH9Tsq7/tdPTVp0pcJCIlq46GAbgD/2ZefiuT65s9gzQV0TsweXndpeeVpeWZ/Bs9hcNGHBqiVOCH8kZy7kkTY0i3G0t0XdEjt3oZa8Y6KVw8jViBn882Pi6DkhczVi+W9OZ+keQwrmx+UtHcu9D39w6/dgJn6Czh2LzphxuoSt5Rr2iypO0+L2EzgGrjNdm7sMDwaluJy/RaxRAkoaGiJZ7kJfawwNJZ5O9ziozg6rWxhLm9DeZQwd34VgIHLp68Toz64IfMMz68wxf/sgBLOWnhZDLjy0fv1IuNoh5rLz+57I/QICWPKskyCw8IxRw1IciMGwBwWhiUB+wX2Latu/IR74lBy8JQ1u0hu1cOTS3Xrnw9BfMLX0gdgjCqWQdaJXEGxcLNTAqaKX/szr614X/tUsVLuhmsFPUg+hPZw8TaMSSUdRnjnySqXEc96vcnLjzNB7ZS398WP9MtsjJbAe1sEiaaSaNk5yP7dw4oVx/h+Ci6sbUWTdfzgnna8gu+
 t8ssZjRU
 FvPOja4BB+RWsPlcyfC8wgd4bcvV5yFZ2YQyag/f6QhWvTIBP36rlOTmk+amp1uC42Z/MNY0mubMa7/wAOSjYADwqSQ6fGyUYtqZJGQztSv/BJcEvxt9eh1ixSRDTQN0mRzexVWGXJ5kQXyoj8tXI4tyFj+hBodxuWO/cFwv+TdPTrHValAkmUMNaLBAAag6Xkdu4XWQyDkl6EyRBut3D9mFySXB7JQo7/qP4+h3IIPqzM1oihMyZ1SVmr0oISouDr35sDE5FOnAPqcyZOGPXrX6Q0fW8EvMnuK4d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

Following a recent discussion about leaks in x86 EFI [1], I audited usage of
memblock_free_late() and free_reserved_area() and made some imporovements how
we handle late freeing of the memory allocated with memblock.

[1] https://lore.kernel.org/all/ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org/

Mike Rapoport (Microsoft) (8):
  powerpc: fadump: pair alloc_pages_exact() with free_pages_exact()
  powerpc: opal-core: pair alloc_pages_exact() with free_pages_exact()
  mm: move free_reserved_area() to mm/memblock.c
  memblock: make free_reserved_area() more robust
  memblock: extract page freeing from free_reserved_area() into a helper
  memblock: make free_reserved_area() update memblock if ARCH_KEEP_MEMBLOCK=y
  memblock, treewide: make memblock_free() handle late freeing
  memblock: warn when freeing reserved memory before memory map is
    initialized

 arch/arm64/mm/init.c                       |   3 -
 arch/powerpc/kernel/fadump.c               |  16 +--
 arch/powerpc/platforms/powernv/opal-core.c |   9 +-
 arch/sparc/kernel/mdesc.c                  |   4 +-
 arch/x86/kernel/setup.c                    |   2 +-
 arch/x86/platform/efi/memmap.c             |   5 +-
 arch/x86/platform/efi/quirks.c             |   2 +-
 drivers/firmware/efi/apple-properties.c    |   2 +-
 drivers/of/kexec.c                         |   2 +-
 include/linux/memblock.h                   |   2 -
 init/initramfs.c                           |   7 --
 kernel/dma/swiotlb.c                       |   6 +-
 lib/bootconfig.c                           |   2 +-
 mm/internal.h                              |  10 ++
 mm/kfence/core.c                           |   4 +-
 mm/memblock.c                              | 110 ++++++++++++++-------
 mm/page_alloc.c                            |  46 ---------
 17 files changed, 102 insertions(+), 130 deletions(-)


base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
--
2.51.0

