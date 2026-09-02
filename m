Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45760C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 10:51:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31CFC6B0088; Wed,  2 Sep 2026 06:51:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CD836B008A; Wed,  2 Sep 2026 06:51:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BD586B008C; Wed,  2 Sep 2026 06:51:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E65886B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:51:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 645EB120187
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:10 +0000 (UTC)
X-FDA: 85168505100.15.E07EF59
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	by imf26.hostedemail.com (Postfix) with ESMTP id C42CE14000F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:51:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BZj0tZGU;
	spf=pass (imf26.hostedemail.com: domain of 3mv-XagoKCFUI0BAA12BEG3BB381.zB985AHK-997Ixz7.BE3@flex--vdonnefort.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3mv-XagoKCFUI0BAA12BEG3BB381.zB985AHK-997Ixz7.BE3@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788346268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Fj637K00n75DiMuZkcJnY4d1CwmzO8C83BzSZ9fxg50=;
	b=sAnJAWs5Ew6f8lS3czyIRT5f7iXVjZNpVDKPl8t93yk4UvuFDkq/QrlKlaUwpC8E9l43XW
	a0RoUulSYiqSJsIoU6quCTQF6QiU883T+O9UDEO/cndLFK1H4/pdgCax8VBcFvU3I7nfaW
	0Ri7s4bPwGIZRWJJaTyBv+SVWQYzmrY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788346268;
	b=ERQl/Yjg6E/5G+22PJnZxxDo66xKOV4wf6hEqksE2z0mxijKOVpAu0KF8Juk2FAKM0+X1m
	cFoWsI5CYElhiLTz/lL5NdZntGWvgiuxpjb0kqtjoV2fjg83f+5ceJLB+iDmItxKKMJ+8O
	yHPdIgWIY11idvcA9kqdvdw3qmZ7kpQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BZj0tZGU;
	spf=pass (imf26.hostedemail.com: domain of 3mv-XagoKCFUI0BAA12BEG3BB381.zB985AHK-997Ixz7.BE3@flex--vdonnefort.bounces.google.com designates 209.85.128.71 as permitted sender) smtp.mailfrom=3mv-XagoKCFUI0BAA12BEG3BB381.zB985AHK-997Ixz7.BE3@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-490a767c7dcso6863025e9.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 03:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788346267; x=1788951067; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Fj637K00n75DiMuZkcJnY4d1CwmzO8C83BzSZ9fxg50=;
        b=BZj0tZGUoorbXbNd88JeCZHYkhrzFB3CqwBPeYsLQMDuc5CdytLjLi+QpzeJUELiHH
         gcwCtWWzMO3/kGtXEOClucepiKkRDIm2JznjqJtzTeInRnGneCCtL0+B1sQAczvFPjG3
         /uzfIQpCQXemRVqU7i1vadN2aVdWbyk4OwYqxQZNgAjEyrYLNqRNAUN0OFNIFWrWs9G6
         M4u9T1Vm54NHTSGd/rCAfXjOBtvhxJwOcDqhr8jBaG0E+qS3SkVIyfuJgoVwXzPqB9fQ
         KKfnxASoYNIT6revnMvEjf8bA08q/GeFOxJBBiiFfm5TjUoCjTx4jo6u0Xgilg3MbM97
         SheQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788346267; x=1788951067;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Fj637K00n75DiMuZkcJnY4d1CwmzO8C83BzSZ9fxg50=;
        b=lrTsmhNqdv7U8TctH+nb4LZQLBSrqLY49p4OPPb0NrF+qL+/nOZ3LM6c8SG5Y4/RJT
         dKQYpNNtKfL647ubj3gVk0RE21ltqZP+qaxP/nHlYIGBbiQnW3A92x49ez4ONRrcexzQ
         pOHymUntGgxG2eGsgz4Vdd6Rteg6Y6rKokYwbs+tCsL4iiUVAJshe5ej3Y8Q0tgXqgI9
         xttCd2TWy9y58zU8ujJaFzETD7FryQ0k1d9D6eRinLp4szjQ/iFwSsrHljlCpeigfLtO
         M7ivT6eKfI0sjfi/yxUxXYy+jU52avcfPNf8TvQdjtNBU278hNmWXlOsIofw+LsY7ptx
         VVDQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro01zCWwDQXTFzzG/1aqJjtZwEKZ59MZ4eAk+gzcUfpt5vo0LbtDjQO1RXJdo2R5isc0fmcwxpmgQ==@kvack.org
X-Gm-Message-State: AFuF++mRShdy6lPY+YlPPKty+z/gm+Ru21p9svKb/Gi5TSHD5BNgZuap
	BoWKmHc2EI0k2ttohWqhCwLG4vLDyOPqJ9zrQclNgatNGXDZfqmRda6Rtpe25Uu8w0XSO+AFgfY
	ycDH0lGloUBkz5pL59k7g4A==
X-Received: from wmee9.prod.google.com ([2002:a05:600c:2189:b0:49c:e2b5:5573])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3587:b0:49c:cee2:1697 with SMTP id 5b1f17b1804b1-49ce583bc25mr63950535e9.16.1788346266751;
 Wed, 02 Sep 2026 03:51:06 -0700 (PDT)
Date: Wed,  2 Sep 2026 11:47:02 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.970.g62bdec98f9-goog
Message-ID: <20260902104712.2399797-1-vdonnefort@google.com>
Subject: [PATCH v9 00/10] arm64: Unmap FF-A lent memory from direct map
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org, 
	akpm@linux-foundation.org, sudeep.holla@kernel.org, jenswi@kernel.org, 
	robh@kernel.org
Cc: mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org, 
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: pczk6aooscjkommrcgp47dkcg1mt4gks
X-Rspamd-Queue-Id: C42CE14000F
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788346268-590018
X-HE-Meta: U2FsdGVkX1+UdhtWVZiqbMj1dcU980OYp5TMsYH7PNbuXuJjG7ogGecmMaj2mqzi6MsXrITh3gIyyCYZlJrmHzM6iX4jLQOQnC1UL82K/YMgkn61wsYxnyus3OMVxJwpI2xt9MOWKwk74+3chRHzVXu9O227BSsxUINF+6Pj4Ts1YA/ebrwDtbyl2MlKAi6d3Fdwn9Z0qL9DaJze8rofon896h8EEGTXkbtwEf8dIRFxeXe/2Oa7CjhUpeENuItp4rkBeoEciQs/VpeeoNjg4LYSPI488J8YkTtHgkhnAeVlCejkC40VifyzZSHzdk6tYjHPRZgGGfY2G7Q603K+TUnBRRIRqqG6YLBe/8JsW5SBSAG1pBxuMptk0VBkCvLdKp9LL77yBFwuzlUoppKN076M6p5pbBw8gC9eUbKGa+tMPWIYkWGhNVPjUMT3+Gcjkoq4PSp2LL62yY1fxtM2vOYnEc0r6xZVK5eIhPblFqn3njGmxtFVTisgHIJxVsfdY9HeUU2nh9rbVSg8qmWUsJZ3/L+I2AseIA4CO8dg+WjuYKi7YJHXIVE2pC5TSYKhPASGplwD+16DqCtlJ5kVcrIYO6YtnJQRhKb/cPvRJ8wvFpcWGbo5ADEK5XSebEB3+RwvkGLXHktZlIpIZkrbCyrfLPRv6x/Ql7TLhM6zzm3vjP/dM6s6VO/009Px6sv/vDzAvrloFxzM6fcZB+R5f0wkf3s12Cmnp+615GJa76XQ94P8NsIEcvT1JKH816uX6VRp1kAu9T6ynr1wKW0B1OAopRI9lrjrRn5mgGDaEm3+HzYf2q3Q2mhKzpnf37GghT/UbS4lZ3ywGC41YB+qXXdfF0CdHRa19eFhbhuOC6i//bAn/km+nYcLNcV2U+vvzq95Jm1KXfrkoCI2VwlzFl1Gezv3ntWDOdUWNeyzeukSmqG55UEsDMQauQ8la8KjVusy4jhskusWM8/1fLm
 KkaI/fzB
 9FwrBKGCJkAblBsmrhCmtiXFHMQExTN6Th7/4WLRWRNwgVmxX3JhCSJIIuOL87YUVb1xmdExpfGg+as1svsapZ6haJu0a9de7PI9Fm2mQmi1XjmJRDL5QuqZAVu45rcvi+HljAACTX27xlHVRr4vo0jCleuLMxMycMM5oifadMJVmII5+nRh59UBSXk2/N3XVaMK5cwMHg8auBxm9C8tuF2QVIbS9/PoGst0iuNbU9xhaVYqvg+51NYaTgpAHEFoaXLQb6g6KssZY3BXwokxCiimDxId1lT8P6AuUArk7YfdEhXiI+MiM46hvlBsN1R6loWmVaW5GWiapOX9A1iMmO7GX4hTY37jJf+Xuj14bmp8EHQJhNzFgaoU2hnuU0MdIkVjgasoOeq2gLJWBQTdFPnezm45/yg7KrNrPNQIcBNP1mwL5ZZ02k8j9rYrQHPEAQUul1T12V3MFTm8aaamQypZAiqZHqxKa0kX5mz4X0tJhHNiO8zL5Nc0lRvEkc38eG+bMcX7xWclIcJOPqy/q36VZsbXnG/CYimiUnvFDV382HL9sIbyjmLB/PIZX/6qllYnFHT62eRd3fwWLFbINH/9rHkmKYEOKMn8KkKUTP9oNKi4Didq0k6TqlbBMH1/FV/qmJAaZJ59v3oA2Ti+k3OPCXArIXStSpFQBeE/U9LndWjhPNMssDluaYoD6tPWGp8dvJCh2cCqpVn0xyTixgmhPCDBEJTWGZjYmsPjUn3valLCWHrhPZqqS3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is a follow-up to the discussion that has started here [1].
While standalone, it also provides primitives reusable for the VPR DMA
heap.

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
for designated memory regions, along with the "arm,ffa-lend-pool" CMA
driver to manage unmapping and remapping on lend/reclaim transitions:

1. memblock & OF reserved memory ("ll-map"):
   - Introduce MEMBLOCK_LLMAP and the DT "ll-map" property for reserved-memory
     nodes to force last-level (PTE) mappings only for a specific region.

2. set_memory infrastructure:
   - Introduce can_set_direct_map_range() to check if a specific address
     range is mapped with last-level entries and can be modified safely.
   - Introduce __set_direct_map_*() variants that bypass redundant checks
     when the caller has already validated the range.

3. "arm,ffa-lend-pool" driver
   - Introduce the "arm,ffa-lend-pool" CMA reserved-memory driver, which
     unmaps pages prior to lending (ffa_prepare_lend()) and restores them
     when reclaimed (ffa_lend_reclaimed()).

4. Optee support
   - Hook OP-TEE dynamic protected memory pools to "arm,ffa-lend-pool" for
     both SMC (via DT memory-region phandle) and FF-A (via
     ffa_lend_pool_attach()) transports.

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

Vincent Donnefort (10):
  memblock: Introduce MEMBLOCK_LLMAP
  of: reserved_mem: Introduce "ll-map" property
  set_memory.h: Introduce can_set_direct_map_range()
  set_memory.h: Introduce __set_direct_map*()
  arm64: can_set_direct_map() if BBML3
  arm64: Implement can_set_direct_map_range()
  arm64: Implement __set_direct_map*()
  arm64: Add support for MEMBLOCK_LLMAP
  firmware: arm_ffa: Introduce ffa-lend-pool
  optee: Add support for arm,ffa-lend-pool

 arch/arm64/include/asm/set_memory.h  |   7 +
 arch/arm64/mm/mmu.c                  |  23 ++-
 arch/arm64/mm/pageattr.c             |  67 +++++++-
 drivers/firmware/arm_ffa/Kconfig     |   5 +
 drivers/firmware/arm_ffa/Makefile    |   1 +
 drivers/firmware/arm_ffa/lend_pool.c | 223 +++++++++++++++++++++++++++
 drivers/of/of_reserved_mem.c         | 104 ++++++++++---
 drivers/tee/optee/ffa_abi.c          |  13 +-
 drivers/tee/optee/protmem.c          |   8 -
 drivers/tee/optee/smc_abi.c          |  17 +-
 drivers/tee/tee_shm.c                |  11 +-
 include/linux/arm_ffa.h              |  21 +++
 include/linux/memblock.h             |   9 ++
 include/linux/set_memory.h           |  39 +++++
 mm/memblock.c                        |  50 ++++++
 15 files changed, 545 insertions(+), 53 deletions(-)
 create mode 100644 drivers/firmware/arm_ffa/lend_pool.c


base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.55.0.970.g62bdec98f9-goog


