Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 730EB60A3814
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=YMi/BKLh
Received: by kanga.kvack.org (Postfix)
	id 899666B05B1; Wed, 11 Nov 2026 06:08:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870126B05B2; Wed, 11 Nov 2026 06:08:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AE016B05B3; Wed, 11 Nov 2026 06:08:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5EA956B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:08:26 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0289F40289
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:08:25 +0000 (UTC)
X-FDA: 85422564612.13.788A6D5
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	by imf10.hostedemail.com (Postfix) with ESMTP id 464B7C0004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:08:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="YMi/BKLh";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3pkz0agoKCG8iQbaaRSbegTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--vdonnefort.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=3pkz0agoKCG8iQbaaRSbegTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--vdonnefort.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794395304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IbCldHU5Mwk7c5H3z6Uc6u4VrcQ6WVCcsNry6NcYtQ0=;
	b=nE9bRIK5+prxU0bFK9a6JrO34h5Qr3V3hix+ULbvnDlk3JtpMzgEFsSq+x5aCLbXU9SlCC
	k8u36CkHwwzeYIHDEwoIzIjf8NnxURLuJPfN+DHG6OkQwEeslpfjJEXkwb80fYFAEgyBfB
	hRVtJMM3FsMOfYdgAzXLO9U26NoUVa4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="YMi/BKLh";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 3pkz0agoKCG8iQbaaRSbegTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--vdonnefort.bounces.google.com designates 209.85.128.72 as permitted sender) smtp.mailfrom=3pkz0agoKCG8iQbaaRSbegTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--vdonnefort.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794395304;
	b=To9JKrHSzAlVSIQkl90VMW16gLW9WInVhk4mlMGDJtjNpbKVjRnhAK4lkm+hkcQldajIrx
	eeguHbdEKCL4ZePOLItK3PmGlaksnzV1sqKumhuqMrcfJMikHpgaWodVeDG5CM7Ew/VTGx
	+SXY4j/K7UQs0s/v7VUEJuK8qUaLLko=
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4a20e41008cso20683855e9.1
        for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794395303; x=1795000103; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IbCldHU5Mwk7c5H3z6Uc6u4VrcQ6WVCcsNry6NcYtQ0=;
        b=YMi/BKLhxmvRO81hl1wXhDmzdBNMh2XZccT24USKLaadoBlOl1iB9Y823x4pw8B56S
         vC+HCtWU033SjpjHX2EmlKAepXOlyo527EFWAXmd90c/CaCJ163OyCzP2atgY3dAA9cD
         dbrwJ/L6d7bgYdsixPFa0zcSp26FXJlolwsjmtSIPMDkoivHnGESIxRJ+a0u+r86V0RI
         kcypMNr/FQFPziJzClei017gqZYdin1F/HliFrseJdPMJWArFaxi9zUZV5NLYB4SSjmI
         ogm1djQ6xOPxKmgQp5oVpWaRk0dlSiMSC5yw7KfFOuN6VscC0uxyOdfTDNH7ugCTSAFq
         l9QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794395303; x=1795000103;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IbCldHU5Mwk7c5H3z6Uc6u4VrcQ6WVCcsNry6NcYtQ0=;
        b=xu8MnT4IqJf7R9E9eoyhs8dD9YTwTUnIVAbVcTjEdlPe8Ryt3OWUQj56PtAiKEZV+q
         3Ekb8bd3K/v2qM6HdaHdtj4tNoHzs7spp3FsMmUGVnUKJf8hEBMYDaPS/GhwhNzSPEel
         2NzWc+/JWLQy4XBCwVEwlkDd5lP0Qfeo73qTn1lu+iB88glPc0OvfLMEG/IXgTlTxLiz
         QN7tPKDw2FsZ4Ca639CPCXDc1xywGnxSfPD9eCEVI+hE7zFRJ/CeWxTpUFxzztubpEIL
         R/jtJb7WH4kdCcLUqe3M0YG6KuNfonzscq0mm5DX4D3WWw1nagyKoKD6qFnjXikDwldf
         euLQ==
X-Forwarded-Encrypted: i=1; AL+hErEaRpDWWOPmnhF2bTMKmD1LjR6YaC3knBWRWaSt1jr/4d0xUr5I1Vujy2gQheYpflVmc6QV7NGbbA==@kvack.org
X-Gm-Message-State: APuU4Z+SkaJckbPsvbZIlycq6KYX2LfN7nWYmhl3M0KA5SG1wg/RlnOC
	BtnXdCPChl52ZI0x0uWZC0N+HcgniMj79QgRYhbWHhzkyGY4zzWVEZr0NceZcF11XG+zRw79HkQ
	mY1ZnxGE0IYlchGDPOhc7zA==
X-Received: from wmba9.prod.google.com ([2002:a05:600c:6dc9:b0:4a1:b748:caa2])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b78:b0:4a6:4d6b:a840 with SMTP id 5b1f17b1804b1-4ba0938fdf4mr37001375e9.31.1794395302318;
 Wed, 11 Nov 2026 03:08:22 -0800 (PST)
Date: Wed, 11 Nov 2026 11:07:30 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111110738.872947-1-vdonnefort@google.com>
Subject: [PATCH v3 0/8] arm64: Unmap FF-A lent memory from direct map
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, m.szyprowski@samsung.com, jenswi@kernel.org, 
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org
Cc: mark.rutland@arm.com, robin.murphy@arm.com, hch@lst.de, 
	ryan.roberts@arm.com, sumit.garg@kernel.org, sudeep.holla@kernel.org, 
	ardb@kernel.org, thierry.reding@kernel.org, david@kernel.org, 
	danielmentz@google.com, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, iommu@lists.linux.dev, op-tee@lists.trustedfirmware.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 464B7C0004
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: w9a581417ez1omeatbkca9z6oahewxga
X-HE-Tag: 1794395304-480437
X-HE-Meta: U2FsdGVkX19FDPItl4E/QZYr0pm5yJpRi6phz/b2ePG2dDVPXLf6jnhr+RCqguJlo2G4sRFg/ZhpVGwdYbdYPXWYM71+4GE0ESIXngMSrXTI2S0sClaQg4dlM9K0cbmJOo0f59IvVVAL+DxTX3GingOTX1we1JxbN8K5+Y7kQtKV1rAmFrc2U9+vXXcePRa1g2VXRzl0KqDJtocI67alJmHQ2P4GYUkT4WbTYzT02nlBIE9eObMU3yokzC2SNEeaUbXER3NEVRahQ5WegmZyHxBFkyXLUO9UtfcrnBMImZ66+2kCbBi32JEvkiGf58JPKr7kNpUD8jhq6cF/HLr6tRmHdpvei83KFPp0mUt8Oscdk+670bD0vR/8v+3aGwnLsh5dNTqpgQiYUPAsd6NZye/2IpkCHvFtWr4Iv7jo4yPomyj+yBpMi3hIVdoq9BuVtifzkkqk9UxnwCh4nOgg3Mzk8PEMPEXPCpVc6blbrBuRjJ8S0NTwkJpWH5b3k+TYONUssW5P26pR82BDD49aSNvT3+xCG6aBh+y82a3ZEBbX2rVitybfetgCIRdThK06wU3ykP7xfsYpXVkvZsHSPMcrLmWBw46clYSWY27L1ed6n8TqUkRhjRgsshZsReS/w1sQkzA/BsMx5OxftzgURdKIVXFVjdYDjp0jv/eb+UVKjwqBOt8kitcMxqMnhtxN6Rv1sWZuevK375VtRaaSr2mhgu1Bdu+f3fbL/4tAsdTdfJuvIm8d5DeL8idbwB45x0VMdO6R6lCUcviqQyAQtzcIo7lONt8g3ymHmZzfHDyZGO2GqBa96OEQlqqRwkhrHcncrbgOZaYRnBsa/3mrbAXr3aeMaBZ/cegjqD7qskf7S+/DkheSW/d8l2PCeU1n7o2zjaONqOuzMxTgTWKtsYJx5TiDtrWb39lCF2lc1F/VQZYHIpFHCQQeViDE0SVVHcJ/sUedUqQKDCESBwa
 lh7C+d+M
 /GNKUoReOauZvWvWF/JE9p2neRIk/wGxIf++GfoACzITSe4BXB9UcyID1sUh/M41JPfY0XcwcFRYT5snQ+xE2gNuBlqRjfZmS5/Jz4BszgtBStBWOBuPAgAqBAIcqjvkBv/xZX0bmafCcKdt3WNWyxvU8WqpoVR9xvyfs+2b8HVD4AqDpBPLnRWdBWzTbWV6gC+sclnQa/iFbSziftVLItWMu84+7+nYd5ixEgTOA8Lgvyet8JAtnwzRssRmbeW8jbiSvazBt+QJ3cnoD+582v4PdCxSH2xHTePsgfzkEhPVzNlfquIzWZAVg1DuUBufSYKCJwahYUCDJvhaHc4kGjncqTchBpFXG9TlFKghUqIiU8Zlo3bG1McPduleTIAbQZ6SJzqPQRXExnzWZnIlntvt/j26UZl51oBavKCwlSeLCz4HIIEYOSxKLmUi5Y896BcMaCvDyUJaSpUuCjib35xGdDfZJI2ygtoGwDOPEQw6nQ50s1vMmZXSzS0VjNEntxiMGx686bjDxyz8HIeunFPG3wo8jCaoR6YPLhNKRWCNQ9v2STPySs5Yzzu6pAg67jfvdMHkokNuSxbTz90nC72BIC3UTnUN3H+vmGklreJq+/zI44GpISG3rQJi88KNokSNE3R/WUpG+XdLTbosS/RS8PqFBOhHjsibaruLk5q0stpvHfIdaKtwvDTzzVHkc0e7qA4O02vwvovUAamLQvMYCCaMuSOmKBgUzOqG31qNdAZWwuD9TgNdkRGU0FSH3IPiQ1b7BzqTOuVNQ2KBatZehAl4afogtHKu7aoBWj522TxY6Ni26eQkIag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series is a follow-up to the discussion that has started here [1].

When memory is lent to the Secure world via FF-A, CPU speculative
accesses from NS to the lent pages can still occur as long as it retains
a cacheable mapping to it.

Ideally, lent memory would be "no-map" but that would mean giving up
MiBs of useful memory, so let's try to do better with the help of a CMA
pool.

On arm64, modifying the direct map at runtime is generally restricted
because the linear map defaults to block mapping and splitting blocks at
runtime may trigger fatal page fault, unless the CPU implements BBML3
or the entire direct map was mapped at page granularity from boot.
Forcing last-level mappings system-wide incurs a severe penalty we want
to avoid. Instead, this series introduces targeted last-level mappings
for designated memory regions, along with a generic "lendable-dma-pool"
CMA driver to manage unmapping and remapping on lend/reclaim transitions:

1. memblock:
   - Introduce MEMBLOCK_PTEMAP to force PTE mappings only for a specific region.

2. dma-mapping:
   - Introduce the "lendable-dma-pool" CMA reserved-memory driver, along with
     generic dma_zap_direct_map() and dma_restore_direct_map() APIs to unmap
     pages from the direct map and restore them.

3. arm64 direct map support:
   - Implement the "lendable-dma-pool" hooks.

4. OP-TEE support:
   - Hook OP-TEE dynamic protected memory allocation (tee_shm_alloc_dma_mem()) to
     dma_zap_direct_map() and dma_restore_direct_map().

Testing:
========

Tested with QEMU v8 using OP-TEE OS (built with CFG_CORE_DYN_PROTMEM=y)
under both SMC and FF-A transports [2]

static void dump_direct_map(const char *label)
{
	printf("\n=== %s ===\n", label);
	fflush(stdout);
	system("sed -n '/Linear Mapping start/,/Linear Mapping end/p' /sys/kernel/debug/kernel_page_tables");
	fflush(stdout);
}

int main(int argc, char *argv[])
{
	int heap_fd;
	int dmabuf_fd;
	struct dma_heap_allocation_data data = { 0 };
	size_t size = 1024 * 1024; /* 1MB */

	if (argc > 1)
		size = strtoul(argv[1], NULL, 0);

	dump_direct_map("BEFORE ALLOCATION");

	heap_fd = open("/dev/dma_heap/protected,secure-video", O_RDWR);
	if (heap_fd < 0) {
		perror("open /dev/dma_heap/protected,secure-video");
		return 1;
	}

	printf("\nOpened /dev/dma_heap/protected,secure-video\n");
	printf("Allocating %zu bytes of protected memory via DMA heap...\n", size);

	data.len = size;
	data.fd_flags = O_RDWR | O_CLOEXEC;
	if (ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &data) < 0) {
		perror("ioctl DMA_HEAP_IOCTL_ALLOC");
		close(heap_fd);
		return 1;
	}

	dmabuf_fd = data.fd;
	printf("Successfully allocated %zu bytes! dmabuf_fd = %d\n", size, dmabuf_fd);

	dump_direct_map("DURING LEND (EXPECT HOLE IN DIRECT MAP)");

	printf("\nReleasing dmabuf_fd...\n");
	close(dmabuf_fd);
	close(heap_fd);

	dump_direct_map("AFTER RECLAIM (RESTORED DIRECT MAP)");

	return 0;
}

[1] https://lore.kernel.org/all/20260807-tegra-vpr-v4-7-5510d16af89e@nvidia.com/
[2] https://optee.readthedocs.io/en/latest/building/gits/build.html#qemu-v8

Changelog:

v3:
  - Replace "arm,ffa-lend-pool" and OP-TEE "memory-region" DT binding with generic
    "lendable-dma-pool" compatible with "linux,cma-default" (Sumit).
  - move conflict check to flag-setting time in memblock_setclr_flag()
    (Mike)
  - Rebase onto v7.4-rc1.

v2 (https://lore.kernel.org/all/20260921110050.3977591-1-vdonnefort@google.com/):
  - Rename MEMBLOCK_LLMAP to MEMBLOCK_PTEMAP (Mike)
  - Warn on conflicting MEMBLOCK_NOMAP and MEMBLOCK_PTEMAP flags (Mike)
  - Drop DT "ll-map" property and mark MEMBLOCK_PTEMAP from ffa_lend_pool_setup() (Rob, Thierry)
  - Drop "reusable" and "no-map" property checks from ffa_lend_pool_setup() (Rob)
  - dt-bindings: Document arm,ffa-lend-pool (Rob)
  - Rework the Optee support with a separate ffa_lend_pool.c file.
  - use walk_kernel_page_table_range_lockless() for
    can_set_direct_map_range() to fix folded page table (Sashiko)
  - Add missing TLB flush in ffa_prepare_lend()
  - Disable hibernation
  - Rebase on linux-next (next-20260918) to use the new set_direct_map*() ranges (Mike)

v1 (https://lore.kernel.org/all/20260902104712.2399797-1-vdonnefort@google.com/)

Vincent Donnefort (8):
  memblock: Introduce MEMBLOCK_PTEMAP
  arm64: Add support for MEMBLOCK_PTEMAP
  dma-contiguous: Expose rmem_cma_ops
  dt-bindings: reserved-memory: Add lendable-dma-pool
  dma-mapping: Introduce lendable-dma-pool
  arm64: Introduce direct_map_is_ptemap()
  arm64: Add support for lendable-dma-pool
  optee: Add support for lendable-dma-pool

 .../reserved-memory/lendable-dma-pool.yaml    |  58 +++++
 arch/arm64/Kconfig                            |   1 +
 arch/arm64/include/asm/set_memory.h           |   6 +
 arch/arm64/mm/dma-mapping.c                   |  71 +++++
 arch/arm64/mm/mmu.c                           |  22 +-
 arch/arm64/mm/pageattr.c                      | 121 ++++++++-
 drivers/tee/optee/protmem.c                   |  48 +++-
 include/linux/dma-map-ops.h                   |   9 +
 include/linux/dma-mapping.h                   |  16 ++
 include/linux/memblock.h                      |   9 +
 kernel/dma/Kconfig                            |   3 +
 kernel/dma/Makefile                           |   1 +
 kernel/dma/contiguous.c                       |   4 +-
 kernel/dma/contiguous.h                       |  10 +
 kernel/dma/lendable.c                         | 243 ++++++++++++++++++
 mm/memblock.c                                 |  39 ++-
 16 files changed, 630 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/lendable-dma-pool.yaml
 create mode 100644 kernel/dma/contiguous.h
 create mode 100644 kernel/dma/lendable.c


base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.0.542.g3ef89b7020-goog


