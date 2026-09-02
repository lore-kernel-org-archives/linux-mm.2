Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3269FC624D9
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:27:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB1746B00BD; Wed,  2 Sep 2026 09:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D61BB6B00C0; Wed,  2 Sep 2026 09:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2AAD6B00C2; Wed,  2 Sep 2026 09:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CC816B00BD
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:27:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D058A3BF5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:27:37 +0000 (UTC)
X-FDA: 85168899354.21.E450F1E
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2BB7CA0007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:27:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=owNwZIVw;
	spf=pass (imf25.hostedemail.com: domain of vdonnefort@google.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355655;
	b=hC346duOt3DLGnO6Eq114s+xAGPdE1MwSC91Y5gDFhhO/OobzaF0/PSov4w0IKF6uho4k9
	wdZLjTyP4TIkyGCHY3E5KcQbZsqDXHuiQG+RZA8eU7tNvpgkOCI+Bg5yNmscSW1rDYCM38
	TkzRih6x343RZxT67S4PClqFzgP7d1A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=owNwZIVw;
	spf=pass (imf25.hostedemail.com: domain of vdonnefort@google.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=vdonnefort@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zt5M13bJdXW7K7qyVlwwml2r+oge4XhKrpcO5BXQh9I=;
	b=sKJb+FJtVgzKu6xJhsMdZRuztXzaKwwS6FGOtK5m24SpmsN1wgtN56V1IuG706gdIzqKBm
	GDFUCm90owmBjvpo+E8LUfTh6KBteRbkF2dS+Z0gskHwWnUQvk+oE6VFMHxo/33hmXe5t0
	24uz05vtKkRtJJCNs5IguMz0+yUcoH4=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c197e7e4e94so152147266b.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 06:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788355653; x=1788960453; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zt5M13bJdXW7K7qyVlwwml2r+oge4XhKrpcO5BXQh9I=;
        b=owNwZIVwzH36pyYgTzPknHt3rgexdA1W4bwRPdu9D/YS1uau8IZW+affOO5vvFNWW1
         Evb+W74hMc3eCPTjethLslPyIbB2cfE6dJ+Juej3PWFxvZ5oRfb8rRjnPxxqZBBINZc/
         LTn70TFbtkJRvdzyeLE2bPbUMCu9YnKZCG24azcNlvByGTeE5C884yUzoOuAjzhgh+8m
         RcoBj9tANBSEhhialmEB3OHshVeL/w3tzHokBno/MUBvWBaJKy+h3P4+HgAUNRNwQwNx
         Yi6NH2lD31x6TKRWXmPWiG1bjQoPT+OLUyLFTnrzeGkTpj7+G1NJC8Oihb8vYKeWPVYd
         G8/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788355653; x=1788960453;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zt5M13bJdXW7K7qyVlwwml2r+oge4XhKrpcO5BXQh9I=;
        b=dvjrM+uxu3zIsuVVxGXDKW4ZW66tPUqhsTafOdUZx3KiDqgK3A24MCwDjPedqHtRhM
         NdgLW5QlIBkDlEsFTMOEPLUbdGXdJG/mVMf3jUmYzo1iGFvI9pWJVczyNWhTaZ8MzKa7
         f7/6orH5YmZNd3V9T7cWpRsMeG+acInqdsmqwHbxFEWLEDcSLFngUnniLsYkwyav3Woc
         SRCoNXoj23+PM7QYkKvEDclY1VF6Lf3GoBGOgyR7y7EGN9/zklJxOOe14yQ+I13gRmIL
         6rZydiSCwcFQhjM868EYuIUwclXsf9xRhG7318ZwrttKwgi1IdGLuNBSYVxrkApnjMa7
         LSTQ==
X-Forwarded-Encrypted: i=1; AKwUvBzbFL2wsH6vAJBNDZM57gJbmmOJT+lA17oB+7KEITDC004PBjA8n25/bcdOvvI59Nyg4wTPPJKYVw==@kvack.org
X-Gm-Message-State: AFuF++l0COZ3sFgZxJxinYj1exk4QJCrCe4hi8HBAQXJ1uidU0reRGKq
	lXPgUPi5qF6XjkzK4pK4sQtQ8paMUagtlJ9aifhotwsOjk9EeXJAK1laTu33yyJScg==
X-Gm-Gg: AYBFou1UZPqXBy2Mk6TOfd0lNzsPRpBOi3xo72HXDjHulqQDMnYUFjpkjg6uVCYMlti
	RrEQ0/P6sGNIjkO4tSj0ahkVbMDp8EWW6VpeH/sajZOdF0BPUc4zrXPHnYjaDeSXGacUIFZFUsG
	k+CZJH9Quobp3PuK2TNeLI1TmXH3kNEle2nuw5oQvZNpsSWol0MiaWDHdrMucLp6ethzz0JB840
	6zJG69ZNYxiM9i7TlbyDaSCWLxXYRwhpO6uQm00jewGsSeHGip3zNhmHaaAwQAcCF0dkNSmETK+
	T84uKaaqskxXRR2N2HtmAtj57L4hWx5ZaRAPSRQGUqIdtq20Vle6X+wdDUo456zZydDIO274cY3
	lZxEugdLrySnMdtzXE8qW0mhiQYAC98xT1iLi319xdGXkFEiv0Ws3hSDB6Czzs/3HrMBM1JNp3C
	E2coxQiYjeVxFbtJDG10YPnj/muJxLXZudx8HOc7Yoxf6m9sKC1lx3e+L0+K6tZeirpej7Q16aT
	RzS0RYcKuH6O930Z4FCBkV8T+BasMZM
X-Received: by 2002:a17:906:f58e:b0:c25:c954:faf2 with SMTP id a640c23a62f3a-c25d563a41cmr291059666b.21.1788355652676;
        Wed, 02 Sep 2026 06:27:32 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c25d039d796sm138037066b.40.2026.09.02.06.27.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 06:27:32 -0700 (PDT)
Date: Wed, 2 Sep 2026 14:27:28 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: catalin.marinas@arm.com, will@kernel.org, rppt@kernel.org,
	akpm@linux-foundation.org, sudeep.holla@kernel.org,
	jenswi@kernel.org, robh@kernel.org
Cc: mark.rutland@arm.com, sumit.garg@kernel.org, ardb@kernel.org,
	thierry.reding@kernel.org, david@kernel.org, danielmentz@google.com,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	op-tee@lists.trustedfirmware.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 00/10] arm64: Unmap FF-A lent memory from direct map
Message-ID: <apgkQJai-2pjI75-@google.com>
References: <20260902104712.2399797-1-vdonnefort@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902104712.2399797-1-vdonnefort@google.com>
X-Rspam-User: 
X-Stat-Signature: jn465scouwwwbiqdb6zd6ixwcpuj8gsn
X-Rspamd-Queue-Id: 2BB7CA0007
X-Rspamd-Server: rspam06
X-HE-Tag: 1788355655-534811
X-HE-Meta: U2FsdGVkX199s1QdNWfVH9rbSNooDKc2f8CXz0PmzmUtnVZYl663J1SuoIr7M5nBBNCnsrn2ySRT7a9It7w9aad1n+AThdN0q9RG72QGpuVcJUQ218ItpuGZqimG7taNpY6bmYdF7a5PexcZoadc0iB+jqlQbRtfTYuw5BvUwUpEUidBnypl0TDfeRm11tHoo+ENihC2zjuSw0gs7IjN/8GvfhhvCTwCxmvh53GLfKwo+EnDH1kr5uMRTTq6/l9xk0mzr9+/r+wYWID+cWLqIaR9uh2Ofk5Vrge9GUntt5TMvn9smOLIyPHOVuzYNmMyXoarpDdmrSQTwpw9ZAeoML87Q4EDzsKhWmBl/0fA6Bjw5oQB8dvCrZFJ26CbZEOrsOJn2thCjbS9ISwqyIn4GQNkmMztKe+1tYvfvEMGHVuomSJMddq/TYDwB4eianPFYXkyHO7MzvpHcQDypfPkAvcRu7Y80SghvNq2RfurH7q3+OKaGrT8UxZCY/gN5lnvRmDEQPfY4j+R3oqIY6OXJfWZOFdKbBYUbTNC26feM+fpudoF1ZdbqB1XFO6fs2mePURZd15fPLZFytepD87RE+3hfEx8UrJG334PcOdW8raSCP2mXzOvYHvaMQVaEnPxUdukM747hF54oMRCjgSMtrZXCJ4koMq8edQKcKIWHYQ8iLNDIxZrkOgyYCcHYJ2C/5KhDEWXH0AqZoH5LYzMTlojEhOV1YlYMbbtZEHkqxTskBGzzvItiX5tN3CshjE4Ys2haSScj1hgLvXM0MzKCUEA5ikn4l29cAEjLpMI3MbWkyygEVrP0i3lyEJTBpTbClSUBZRL/IeeSUspKjNyoBUX6NCp+gtsaNChHD7ixf3TwSbyV0kVNFRsh3dDp7VswVfqIO5h9is29F/zmwobdpdbaLPBBlEgTZYmZZzE3RDzofh0kww9tPsplJue9YsayvpzIR//EwGGw8OyBpy
 r+NnICJx
 DUK7yUENp5h3GaUaLHS73X081fg61xqE7YqFODHWu5YYolok04eFS4tnj+wByM04WqziRfCWYLJMDSQUVllP91+6p5bC3VMxVarxcbRXCTX1BSOE1dCx7IIBfItxEmwY0tqml7zV339Z/vV5ccRIIq+41561z1B1yw8wYvUb8b1gZghIvku8rzKYDdbup827l1XoNaXBrmqIiESqTVnSIJKE+1fccZTvQFnzwq1LThqote3fS0O3oWJ2sGaVMW4PoKgZ+8YeWWdLzP2eIFsOo+Db0jFyvLTB1s5aHl7zrxM2dC/wjo5AB2ICuK92ySQWqAxCaXqc5iuUWDT4/4aXJ4RG840q/11HZ3JPegJU2qHaCJKVC/PMZpnogxxLPrnCnRLppFLb/nyz2L4WXs9H3wqQqsM+VFs3tvFeZwhFKSSKaPEK79fBtqVXxQ7uivTSIEe2XV59UnymA9mvyDvYdJ+CqGOeOpyMeoMhQxhv+z6MzHyEVJjRUnTGHqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is of course v1, not v9...

On Wed, Sep 02, 2026 at 11:47:02AM +0100, Vincent Donnefort wrote:
> This series is a follow-up to the discussion that has started here [1].
> While standalone, it also provides primitives reusable for the VPR DMA
> heap.
> 
> When memory is lent to the Secure world via FF-A, CPU speculative
> accesses from NS to the lent pages can still occur as long as it retains
> a cacheable mapping to it.
> 
> Ideally, lent memory would be "no-map" but that would mean giving up
> MiBs of useful memory, so let's try to do better with the help of a CMA
> pool.
> 
> On arm64, modifying the direct map at runtime is generally restricted
> because the linear map defaults to block mapping and splitting blocks at
> runtime may trigger fatal page fault, unless the CPU implements BBML3
> or the entire direct map was mapped at page granularity from boot.
> Forcing last-level mappings system-wide incurs a severe penalty we want
> to avoid. Instead, this series introduces targeted last-level mappings
> for designated memory regions, along with the "arm,ffa-lend-pool" CMA
> driver to manage unmapping and remapping on lend/reclaim transitions:
> 
> 1. memblock & OF reserved memory ("ll-map"):
>    - Introduce MEMBLOCK_LLMAP and the DT "ll-map" property for reserved-memory
>      nodes to force last-level (PTE) mappings only for a specific region.
> 
> 2. set_memory infrastructure:
>    - Introduce can_set_direct_map_range() to check if a specific address
>      range is mapped with last-level entries and can be modified safely.
>    - Introduce __set_direct_map_*() variants that bypass redundant checks
>      when the caller has already validated the range.
> 
> 3. "arm,ffa-lend-pool" driver
>    - Introduce the "arm,ffa-lend-pool" CMA reserved-memory driver, which
>      unmaps pages prior to lending (ffa_prepare_lend()) and restores them
>      when reclaimed (ffa_lend_reclaimed()).
> 
> 4. Optee support
>    - Hook OP-TEE dynamic protected memory pools to "arm,ffa-lend-pool" for
>      both SMC (via DT memory-region phandle) and FF-A (via
>      ffa_lend_pool_attach()) transports.
> 
> Testing:
> ========
> 
> Tested with QEMU v8 using OP-TEE OS (built with CFG_CORE_DYN_PROTMEM=y)
> under both SMC and FF-A transports [2]
> 
> static void dump_direct_map(const char *label)
> {
> 	printf("\n=== %s ===\n", label);
> 	fflush(stdout);
> 	system("sed -n '/Linear Mapping start/,/Linear Mapping end/p' /sys/kernel/debug/kernel_page_tables");
> 	fflush(stdout);
> }
> 
> int main(int argc, char *argv[])
> {
> 	int heap_fd;
> 	int dmabuf_fd;
> 	struct dma_heap_allocation_data data = { 0 };
> 	size_t size = 1024 * 1024; /* 1MB */
> 
> 	if (argc > 1)
> 		size = strtoul(argv[1], NULL, 0);
> 
> 	dump_direct_map("BEFORE ALLOCATION");
> 
> 	heap_fd = open("/dev/dma_heap/protected,secure-video", O_RDWR);
> 	if (heap_fd < 0) {
> 		perror("open /dev/dma_heap/protected,secure-video");
> 		return 1;
> 	}
> 
> 	printf("\nOpened /dev/dma_heap/protected,secure-video\n");
> 	printf("Allocating %zu bytes of protected memory via DMA heap...\n", size);
> 
> 	data.len = size;
> 	data.fd_flags = O_RDWR | O_CLOEXEC;
> 	if (ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &data) < 0) {
> 		perror("ioctl DMA_HEAP_IOCTL_ALLOC");
> 		close(heap_fd);
> 		return 1;
> 	}
> 
> 	dmabuf_fd = data.fd;
> 	printf("Successfully allocated %zu bytes! dmabuf_fd = %d\n", size, dmabuf_fd);
> 
> 	dump_direct_map("DURING LEND (EXPECT HOLE IN DIRECT MAP)");
> 
> 	printf("\nReleasing dmabuf_fd...\n");
> 	close(dmabuf_fd);
> 	close(heap_fd);
> 
> 	dump_direct_map("AFTER RECLAIM (RESTORED DIRECT MAP)");
> 
> 	return 0;
> }
> 
> [1] https://lore.kernel.org/all/20260807-tegra-vpr-v4-7-5510d16af89e@nvidia.com/
> [2] https://optee.readthedocs.io/en/latest/building/gits/build.html#qemu-v8
> 
> Vincent Donnefort (10):
>   memblock: Introduce MEMBLOCK_LLMAP
>   of: reserved_mem: Introduce "ll-map" property
>   set_memory.h: Introduce can_set_direct_map_range()
>   set_memory.h: Introduce __set_direct_map*()
>   arm64: can_set_direct_map() if BBML3
>   arm64: Implement can_set_direct_map_range()
>   arm64: Implement __set_direct_map*()
>   arm64: Add support for MEMBLOCK_LLMAP
>   firmware: arm_ffa: Introduce ffa-lend-pool
>   optee: Add support for arm,ffa-lend-pool
> 
>  arch/arm64/include/asm/set_memory.h  |   7 +
>  arch/arm64/mm/mmu.c                  |  23 ++-
>  arch/arm64/mm/pageattr.c             |  67 +++++++-
>  drivers/firmware/arm_ffa/Kconfig     |   5 +
>  drivers/firmware/arm_ffa/Makefile    |   1 +
>  drivers/firmware/arm_ffa/lend_pool.c | 223 +++++++++++++++++++++++++++
>  drivers/of/of_reserved_mem.c         | 104 ++++++++++---
>  drivers/tee/optee/ffa_abi.c          |  13 +-
>  drivers/tee/optee/protmem.c          |   8 -
>  drivers/tee/optee/smc_abi.c          |  17 +-
>  drivers/tee/tee_shm.c                |  11 +-
>  include/linux/arm_ffa.h              |  21 +++
>  include/linux/memblock.h             |   9 ++
>  include/linux/set_memory.h           |  39 +++++
>  mm/memblock.c                        |  50 ++++++
>  15 files changed, 545 insertions(+), 53 deletions(-)
>  create mode 100644 drivers/firmware/arm_ffa/lend_pool.c
> 
> 
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> -- 
> 2.55.0.970.g62bdec98f9-goog
> 

-- 
Vincent

