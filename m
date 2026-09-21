Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88D26C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 925FC6B00EE; Mon, 21 Sep 2026 07:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FE5F6B0106; Mon, 21 Sep 2026 07:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ECC66B0107; Mon, 21 Sep 2026 07:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5AAC06B00EE
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:01:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F002D1C03B3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:00:59 +0000 (UTC)
X-FDA: 85237477038.21.C15CF7E
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	by imf29.hostedemail.com (Postfix) with ESMTP id 33C2612001A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:00:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PuoVuDrK;
	spf=pass (imf29.hostedemail.com: domain of 3Zw6xagoKCKQZHSRRIJSVXKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--vdonnefort.bounces.google.com designates 209.85.221.69 as permitted sender) smtp.mailfrom=3Zw6xagoKCKQZHSRRIJSVXKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tq21iXQPKKynEPw3Uhq/hZUwml7pvAbpZ0OeTPKe4Go=;
	b=OZDt6g9joqFoF/mvtXDQLWdSLfGEyohW31uWjZU1VoARmlimgAxmV4PjtDdNaJe7GX6vvW
	YjcJggkU0BYCntIa9pFGTmcxIBO8GjSNYIVEb95cMMQpw5C+DairM5Bu54+0nMwSHarswJ
	ffaYf/GlNdtKMCbRNyGDv9RsGM3Tjwc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988458;
	b=33F8V9EjJTZUa2xYsJaHGnZtUYO0pj230wJNhtIzccDyvs2ae2+XLQtAtaWYjFnjgFND/3
	ev0mMtOsqqmyk3isftWqBUwRZ/222b32vBpTumcP8uwYx75t0pxnkt8vIoxyOYgNAkE6Ht
	Pj2W8/t9tzFecYby7Xqu7dOZK94ScxI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PuoVuDrK;
	spf=pass (imf29.hostedemail.com: domain of 3Zw6xagoKCKQZHSRRIJSVXKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--vdonnefort.bounces.google.com designates 209.85.221.69 as permitted sender) smtp.mailfrom=3Zw6xagoKCKQZHSRRIJSVXKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--vdonnefort.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4870a0fe60fso1408305f8f.2
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789988457; x=1790593257; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tq21iXQPKKynEPw3Uhq/hZUwml7pvAbpZ0OeTPKe4Go=;
        b=PuoVuDrK/LlaQDVg7TO5wJtLYQFxXKNomD1E2QsU54owgEVYid8cAEoFwq+O8YrQk3
         vyJvlDG4Y830FhBa4/MygjFWfrqhQ4N0Q9tmq6EsiueN090iMkwzVPwuWdyDS6P50mok
         6l4Gqotvcy6dB15IJSgdholGy6v774qEP6uo+5mUkwDFvK66WJ4aTXBtaHfYR2fpk6tj
         kXYXK/7IEkFryqV77eLsdt3mDMz0f+iQc+VvEP6oGhb6yyR4DxQj2hL+btsAjyCxfcGd
         POCFvjJCRA5hkzU0sFWRnu+UKTAtZlDjaPoF29RVvYmwGGaaVnOAyV+cOTINfJ6PpHFf
         8ptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789988457; x=1790593257;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tq21iXQPKKynEPw3Uhq/hZUwml7pvAbpZ0OeTPKe4Go=;
        b=x25usaSlS8N/keJJ07qTNXhJ0FDMPtGJVo+5JTFpghtDIHQGO5uxeXn/brEr+2SwHl
         2Jnndj5C8UHHgPCAbOZEh7ZMIXO/v5cc+wrUyGxVkAKDJuZgMY7Q6oWVl/xlGq9AGG8T
         ofQa28cRyWVEkzKXzrN/ApBPUKSQr3JGNRbHVtUNxbbPrSW0zK2yhDL0ydzOLI6W3Z8O
         7EpcQsLRg7DibfJLzXBWzhBqhlRtPrc4qHgPhT+1lq8VfmZSHtdC5hGYsaPQclo78yYP
         yti/64RieHnlJ9xbDA/DFwJoYRIczVG81Wa4vMymHiApRGm+9laL7d1vXTX2o8+AXqYf
         59LA==
X-Forwarded-Encrypted: i=1; AKwUvBwqlx3bKTPr8bWxnmgJhqUEnkH1Rj3PcR/r5cb3gdtUyq4okKlF7iZfLwfl7/rhj+mc1ejZnf6dDQ==@kvack.org
X-Gm-Message-State: AFuF++m8oG3+7CwmvTBzWUE1A8LkvnRm1PTHcmgQWleCta1llsYpdfnA
	YD+/PaEGpSCWZmHonTH5Qwoop6GYESqX3XWqkF8WZgY2HHVEbYm9d3wHbeYmTzHQpwe+AYgtUVB
	JN5FDr0WN5JOzI5SkXuHdBg==
X-Received: from wrbep8.prod.google.com ([2002:a05:6000:42c8:b0:488:5ffc:4b74])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:6f05:0:b0:487:10b6:1ce2 with SMTP id ffacd0b85a97d-4871e2158d7mr13645670f8f.1.1789988455971;
 Mon, 21 Sep 2026 04:00:55 -0700 (PDT)
Date: Mon, 21 Sep 2026 12:00:42 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260921110050.3977591-1-vdonnefort@google.com>
Subject: [PATCH v2 0/8] arm64: Unmap FF-A lent memory from direct map
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
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: d8a515utzfjfzq8b47r5roqxg5kj3zh7
X-Rspamd-Queue-Id: 33C2612001A
X-HE-Tag: 1789988458-549696
X-HE-Meta: U2FsdGVkX1/A9jEtNBcEFtMnYiXYN4ktl1MXhY0sZG/cJ4oF04762z6oGJaK+hqylAGPW/GviuhkrBpy0Bt4gAuTVexdccmZ6SoD7jKXzcTh4ayhpmRNptW0QkhO7XSHJv133mI77wjb2Mwc/wuc5Vtl6fTWGzCm3adOpmAM8YbPBH5u3oHbPgvhJkiKVfcGyOrBLXytb5ZmB+K3FTVy7rlag5sTTNjeG8Bwfc6zQdRfwXjpqv89fv13FodNM3mwbYHR77LKIfQWVgj8PulMIo3woySb4fnT5Mif+rQ5fSF4BuujQLbvEE8gPZDG7IRJEShBwFCV68mSRKX5q+3vxkioJ050hiI7POcoloey1/aIdQVydfuxNTk/eG0ncaM210J0mxXdcWegtGBcHi7zHB31mt8jVe7ngVL+iPodDTQxxhY4qBHWyJxT2CG/4zmNLQ9hw8M6hCf5p2Ir569DuqE1H9BaTJMIJhsmpMAWQoZC9f8ksg5hWBS4xzioGQTlC3HWDBaibdjLXBAFhagY/QjCF1GygofTaqZIC2xJ4GAHw+3S52ApyXDhRuXMOthUK9ZVKT/Fk3fckL7pD7bX/2OQeayG62eUUPWnNS4VdySHo979E/UhwkJoQjTh/QEk3p0EPYUKLpwUYT2oG/G+2FeXf49869H2fti/6dmBO1ZodGkVI96OPGyiITjRo0m3KqgiDIIBlOocZj0zwjzvFeSZsug2oq6AEL+XPHh4tPZrzK0ZK0yhYCQfoViD4x7C5Y5vNddgMbXw7Lp+x/zMhliMkTuFko8t7HpfBwfKJOqOYq0MbwdnXtz6Q3k4z4SMUyYgCn83lepgZqoaI5Bzt7QwV3c7olxnM2DxsLQTTj4KHt8JJtPzJYs6nP51TJ4EoK1Tyt1TrFq0Jp+s7IHgYmh+dRSUktMrTkU2bfPu7S/Yrhx3XGORtMDF+SDLoMhYNDOu62nBTBroYA8VbLY
 RhIKARRv
 tpOAp8kWQfTodQ6hE1ZCO1BAdwwz4uDuKI7zbUuczHUp0g0Taa9nTOs5U+Mg52FZ0EtxavRxKSlF3ghe6GcdtzKmWRpprmaa0ugRW6PDr585gw8z7IJDc07FieRDMkDpfcDwyy5s6ryh5Lg/DxoDMLWZMRwb0jvHIOKU2hjruc/tm0kLz+HAzCe8mv/76g8ArUJNnTS4qkJmWWNhG3wUR7ATiXMNgjyCu7JXwehJwbwkqbyKlpmmqWvsXjGVA7KhbhmlMFpMF3h2n6uoOK+hyAZFr2Ia9oPo8kDq51kWuJM1TIXD9bB0288r+2rQF8BrlUXLam4F3kGwvSO3m6VE01a6EefLZ33uOxYmp/zAlcBo+jlHY6WrIXHMXcx+nHc9JgzD+rglf7noaZS3qMHOJi0mok3puIZR6EQpSX9vmaI3Vr4LPFRoqZFlxWAwpT4W6L5DMpww+GsgM6hZOvW6ZMYKd0mtr6Ky953eURNme39ojgYsNNf7YN7Eh+wWDrk1BGCTnFq4kP0FWh1RZxyXETrs43jdh4p8si19xlDGyNBlz+ydjGFgtXULfe5nEbrfoxbT3CmdQfVMuMDt4u+BkMskdijxbtsKRnujLlQKCJJ+LXRG9KdNEuK7rN91/p0Y4C/TUR1Gqq6yWPoxzSQysnJM07ud1TjfymL/RXYqzNYeJt6NvctW6XMqHMiP9u3z8koBz3kwqFksy1zGTuItkPlk2r2iv8+FFxrj5fwWjpdZdooE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
for designated memory regions, along with the "arm,ffa-lend-pool" CMA
driver to manage unmapping and remapping on lend/reclaim transitions:

1. memblock:
   - Introduce MEMBLOCK_PTEMAP to force PTE mappings only for a specific region.

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

Changelog:

v2:
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
  arm64: Introduce can_set_direct_map_range()
  arm64: Introduce __set_direct_map*()
  arm64: Add support for MEMBLOCK_PTEMAP
  firmware: arm_ffa: Introduce ffa-lend-pool
  optee: Add support for arm,ffa-lend-pool
  dt-bindings: reserved-memory: Add Arm FF-A lend pool
  dt-bindings: firmware: optee: Add memory-region property

 .../arm/firmware/linaro,optee-tz.yaml         |   5 +
 .../reserved-memory/arm,ffa-lend-pool.yaml    |  55 ++++
 arch/arm64/include/asm/set_memory.h           |   7 +
 arch/arm64/mm/mmu.c                           |  23 +-
 arch/arm64/mm/pageattr.c                      |  72 ++++-
 drivers/firmware/arm_ffa/Kconfig              |   5 +
 drivers/firmware/arm_ffa/Makefile             |   1 +
 drivers/firmware/arm_ffa/lend_pool.c          | 261 ++++++++++++++++++
 drivers/tee/optee/Makefile                    |   1 +
 drivers/tee/optee/core.c                      |   6 +
 drivers/tee/optee/ffa_abi.c                   |  13 +-
 drivers/tee/optee/ffa_lend_pool.c             |  72 +++++
 drivers/tee/optee/optee_private.h             |   4 +
 drivers/tee/optee/protmem.c                   |  20 +-
 drivers/tee/optee/smc_abi.c                   |  21 +-
 include/linux/arm_ffa.h                       |  23 ++
 include/linux/memblock.h                      |  18 ++
 mm/memblock.c                                 |  30 ++
 18 files changed, 608 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/arm,ffa-lend-pool.yaml
 create mode 100644 drivers/firmware/arm_ffa/lend_pool.c
 create mode 100644 drivers/tee/optee/ffa_lend_pool.c


base-commit: 3f2425f5b5bbbdd991ca9cdfd5502e68d8895998
-- 
2.55.0.1082.g2b9226bbc0-goog


