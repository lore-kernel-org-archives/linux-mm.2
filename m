Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18AE2EC01A1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 07:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 488686B0005; Mon, 23 Mar 2026 03:48:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439426B0088; Mon, 23 Mar 2026 03:48:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327D56B0089; Mon, 23 Mar 2026 03:48:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 212246B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:48:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C19968CA53
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:48:52 +0000 (UTC)
X-FDA: 84576551304.13.5AFC481
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4F38314000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:48:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rlv1S8+0;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774252131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IytCGZb8QoqUKOg+ctT1e1Ezzg+jN0P1FskdLA5DESs=;
	b=zub+s7hSQ6QjiicH5PbgIBSG76hPvYNwzgcV+cFVzBXRDrL7rxENIDxgtSWC+KmT6tEx+2
	CzFPYXXyQWk8v2Te5MBkWKHeCfKursXriMogIL22Hy6tv05aQkvaAhGxi+/rUR+L/O4+Mc
	uSoGAjx4MR1bGTKAli4pFUR6EAYli9M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rlv1S8+0;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774252131; a=rsa-sha256;
	cv=none;
	b=3n46PRcMyzMbk+cOwc2tR0+i8guqHhA6iLlrryZXFBX4Gp/Q2F42EOmByROetKjNefvDAF
	qAYcHgyYhk9sIXQN6EEior267vgAi3i0SZNh47t1vX6q0X05jCgSO5lIKoHIwBVeTqZfv/
	A0pfv+4AFeGHO+f8/OfL2AQxRrYUOkc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B58BB600C4;
	Mon, 23 Mar 2026 07:48:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC71BC4CEF7;
	Mon, 23 Mar 2026 07:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774252130;
	bh=pCbilTTHI/VwIdYALA976lc/t17gtYFZ5ukjoWq9Zt0=;
	h=From:To:Cc:Subject:Date:From;
	b=Rlv1S8+0zQURdG9YTxr4y3pNRy8/ylu6kZZ6eCiQf+sFd02KfS8+YNnbcyhsi4jov
	 S5w11oK7YTX3gkuWTcyu3hCCiTiR3veT8ei69ieEMGgMa2ZYMUeINhQjyhnr9FSaE8
	 Uj98YvIFa19EU/fOo55YccuDjUkb9MArMrSqYZ/sLc3WXjjEkYT/en9m3MbKASypiu
	 mxy2taD/9hMXzY7nvOCde6k5j3T9Mi98SQf3en8jrYNH2nRMr3fIiwj2mujYUhGjba
	 bnwQO6qLYjo9aQPPjQMfazIbKXhjL7hgiC8xGbSCEvOmYFBujPtB+XyBem0ZCuxVV4
	 bFbyai2HlbXwg==
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
Subject: [PATCH v2 0/9] memblock: improve late freeing of reserved memory
Date: Mon, 23 Mar 2026 09:48:27 +0200
Message-ID: <20260323074836.3653702-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4F38314000E
X-Rspamd-Server: rspam07
X-Stat-Signature: dpqgun8ye1r3kncnx15fgoeesczdnj3q
X-Rspam-User: 
X-HE-Tag: 1774252131-652098
X-HE-Meta: U2FsdGVkX18psIWEtD3CFsPuJXyU2CriFoCGY2xpwosZv6rAyJ6yhaIM62WxfSugMezkjQmcmlwVEcVuGFb3R76OIJaaI8nfEx5dL2t6VDpNgs3YABHfExdv8EyncHsBbMjROiT5ii6zyL93KDkRSR9HmH1E8cWGuGluowdgmmv7UAi5zJ0j5ZV8lK8Q14+mYX279o4/PHgIMFSh51CpyYuQO7P0pbG6h8jdO11YytOB69YGp9pqTxEUrEfAkD3Sf5dcKIBG58lmImZKlSpb3jGAJTZGsrQ2CNvPx9Zjt4+XjChITDvVyUSFIpjk3exiN8iT83p/bddWCUWC51Uxey8k2uus7wzaQBY3D3MRxT0i19YmritT8zBOFHr54R58fV0v7axdW+CxHo9S/gNcaH4ZkmUDcurZLmXpMbLFCk5VuLOGw35Srxqsoh3ZQWx7TRaLk4RH/GNznuMnSyyfVmCMTzydVeR1M2tWZt27JF954wFth3qB8vlq7kX7EdrTABIQ/hpwtcQ6BWu1WkSn4XIYL4UUqHcCuUAtTdtDnlX4u33agS1xE7w3Sm2YJv3rnVTewnNNfoSr0zOyYJui/1rABQjP8Vn5RfVSG3R2rvMsKsGRHJRkJginIG1kXtlIji8KH3/IQhgug+/38V+/SN5Hy5OP4t6Ngvh0HP9joLhTPQpGbDM1+1+5wPm21AsWJca5uS5o5wsIZp9iVuFsp9jRxkfXU48K0Ggl6LpxK4Y+gRx9VyI6hwTzISRDBoMT2Yfu6ktPUjAfIrnD5qaLpdrYlK/VbPOxrSCatKtArq5YZ7f+A0doMeIlWQEAc2L/A6YjhsQ8W2xRdW1HsPoubGLbElCC5U646lRKrGOtJs7gBg4zk00nlU8WCN+z7qy0Sxtr1xpVPyZ/y8Zt+J8UZmMYOM/M6z7LiK2cyKHkof5mCw2LEuodBLafw9SSEsVgXFg9zupIBibo/whqpXY
 4gk3J/+U
 iAWUgeMS2nmOxqsB1APQ//VPyBdAzsR7Mxwv6icvi+6+qi2yofpzv+wX5Ytn0aIAHVD4a2pExTGkVH5FSeY7VZyl2p0cA5Nt726mtGAr0WH6uGdz/01sS3KeD0Ni0t3YwlCUK3Ns4vmq+Z3x/zjcg2+kmRXEuLBBLsYSh9beuLd1bTXC3fA8SvSVfzGnblad46ht9vaEDcf93eLuyWQJ3rtBQTJTqXPU6l18nSQ3w5/SIH29/KwkX/wC+d97rMUoooyaD/UVWjaNuxNf+NQkvJAIfgox0I9fjiQm7
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

v2 changes:
* fix UAF issue in memblock_discard() reported by 0day and sashiko
* address relevant sashiko comments
* squash memblock test stubs changes into the commit with core updates

v1: https://lore.kernel.org/all/20260318105827.1358927-1-rppt@kernel.org

Mike Rapoport (Microsoft) (9):
  memblock: reserve_mem: fix end caclulation in reserve_mem_release_by_name()
  powerpc: fadump: pair alloc_pages_exact() with free_pages_exact()
  powerpc: opal-core: pair alloc_pages_exact() with free_pages_exact()
  mm: move free_reserved_area() to mm/memblock.c
  memblock: make free_reserved_area() more robust
  memblock: extract page freeing from free_reserved_area() into a helper
  memblock: make free_reserved_area() update memblock if ARCH_KEEP_MEMBLOCK=y
  memblock, treewide: make memblock_free() handle late freeing
  memblock: warn when freeing reserved memory before memory map is initialized

 arch/arm64/mm/init.c                       |   3 -
 arch/powerpc/kernel/fadump.c               |  16 +--
 arch/powerpc/platforms/powernv/opal-core.c |  11 +-
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
 mm/memblock.c                              | 124 +++++++++++++++------
 mm/page_alloc.c                            |  46 --------
 tools/include/linux/mm.h                   |   1 +
 tools/testing/memblock/internal.h          |  34 +++++-
 19 files changed, 144 insertions(+), 139 deletions(-)


base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
-- 
2.53.0


