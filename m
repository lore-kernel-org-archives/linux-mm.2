Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE87606A33B
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mxBiRJX5
Received: by kanga.kvack.org (Postfix)
	id 10FF56B05CC; Mon,  9 Nov 2026 13:26:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 099416B05CD; Mon,  9 Nov 2026 13:26:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07426B05CF; Mon,  9 Nov 2026 13:26:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95DDD6B05CC
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:26:05 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0F952140761
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:26:05 +0000 (UTC)
X-FDA: 85416409890.08.58EE350
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf13.hostedemail.com (Postfix) with ESMTP id 425C620005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:26:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mxBiRJX5;
	spf=pass (imf13.hostedemail.com: domain of 3ORDyagYKCIApvm33sksskpi.gsqpmry1-qqozego.svk@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3ORDyagYKCIApvm33sksskpi.gsqpmry1-qqozego.svk@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794248763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+sT6XTK+eeEEa5458THsapg1E+bsHZZOT99yd+LRURs=;
	b=TrpcYdTlU2vn3e2E3HFyhEpiGaDyvfvFGTcj6RWR2gh0KUhM5UYrLAkERFimMEaExSRH5+
	lgNGnZ5ZHftRofsQbYZTAulZxKcNYgNjNaKNSdb8p7sql4TZE0a8yyGU+CstTkP1Ub/HAH
	YW3o0/I3tvfKYYHWjhMVp6onoBr8hlM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794248763;
	b=uCrr9rxZvPk+BzYAjmOlWoGsLeFeD1Mf8MoB3NBFXqxazUKd8ubSiWtYvU3zdWJ0IAJcbf
	N1BIXk2f7YT8NsWutMr1UL8QCRGvfnAa1gF2/T2hYS1Ykkp3uL277idzhyWLuXelFzx7p8
	1Gcyu+e/mUc1WDiVJtbFqh7ES76yAh4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mxBiRJX5;
	spf=pass (imf13.hostedemail.com: domain of 3ORDyagYKCIApvm33sksskpi.gsqpmry1-qqozego.svk@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3ORDyagYKCIApvm33sksskpi.gsqpmry1-qqozego.svk@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c42394d1e41so108847166b.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794248762; x=1794853562; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+sT6XTK+eeEEa5458THsapg1E+bsHZZOT99yd+LRURs=;
        b=mxBiRJX5T+7HrxgWcoAJyWw4Ea9EFHtDfiCWBox9Y7CImxPksEXY85IW7edCo+0JbU
         G3LiNupjvYWMQUdmV8MCV76pKecdIPC3H3qTofPCi5zf2OzwTEMROykimTxHCzZkUrWc
         LfasYol069/zBMEWPdPBbsCF8CEXoytf69ZbiUUvdHuSzEt/NRjvv8yfQvHB4Wuw6+aw
         kPydKFFwwQEqqvfCNpHT/CPLzGvxhgVymuyitaNnSBjWS6596cqvP/K8eQtqGlMMZ6BM
         vw24gPnNRHU1jcTOQaYWYEGtiqOHdD+Z/YnIBJAb+ZSfK4/P9UII1v0SBBndf+d6DGjI
         yX9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248762; x=1794853562;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+sT6XTK+eeEEa5458THsapg1E+bsHZZOT99yd+LRURs=;
        b=i1juPkfSLi8gQbW79ExaCwH6iPTx2+J4NaKdCZxCCzuTUbInsJy7fDjh7egFtUBsmD
         aLsrVVDModWxp5AOPMowYhhK6rO9kSfBLdndfgEqOIIFmeettBrRHlbhVLXlYjRnW1DJ
         E85f9HseLFXwoTkMQVIC5aokvGL4WHJF9SJFH6iKwXN34hGAITPv6a7SweyDwBjtubIE
         /x+32HkBcpSWPHw/GlxzWBQlnvyh/ynmFYG8B81dE5E9UrfP5vLMeDRmXrXl43XqquDN
         0ous0w+3yGl3pdlRYP9mLcfC8jCK4BwEU+umfc1LjvW4AEbdDElSAmFJsCv3Z7khCas9
         Qp8g==
X-Forwarded-Encrypted: i=1; AL+hErFbgyI6qJoEAjafdD5RWRodKi7jH7UQj2Rww/7v//r49otSYCd/8MYixtzkm1zr67KKqA189hBgJg==@kvack.org
X-Gm-Message-State: APuU4Z/v6s/viAYVMhF4VkwZx60z5YDB4VOg4r0IyPTQ0k0a7CusqUyt
	UzGiUfjE0Wzy859eGwJQJXDrdxXa4eF7F0cVZEVp/Hvk2+bnXaa8OLW0TTK7+nP87fmh9DIh67r
	haCvq+A==
X-Received: from edcnu18.prod.google.com ([2002:a05:6402:c512:b0:6b5:7654:ef5d])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:6ea9:b0:c35:d50a:1352
 with SMTP id a640c23a62f3a-c504952c54fmr16607166b.11.1794248761661; Mon, 09
 Nov 2026 10:26:01 -0800 (PST)
Date: Mon,  9 Nov 2026 18:25:32 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109182533.3594984-25-lrizzo@google.com>
Subject: [RFC PATCH v2 24/25] Documentation: Add PISA architecture documentation
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 425C620005
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 53u81hd87ick1utimdnn3s5ux5r1uepw
X-Rspam-User: 
X-HE-Tag: 1794248763-763631
X-HE-Meta: U2FsdGVkX1+F8K4xX0xzFwjXbIJNvxBCJ1bREG4uBkiALfj4I7jMbHlNEnXA5bXCsuh/1siifMxgEQZ/g8Ebop6aLH/HLl0cv7TkaQ2wDvBR+iq9Tydgx7qS0jXhGJ8gA2sla8HZ9uIAUCYMIHRcRXmmH7PET5a0X15Bhio/QGzMeEVSLWnKagv+wodVHpeZcigP8RDnpvUb8ZjRLrL7l05pNDt7g6SjNGiYxaylwpcF3xDikNGFNYqciWAEwif8Oldwd9YP3coqpiXBGsJL3xgwWiX5acBW9H8Nhwt/3gD7QqdH7xsrF7jOTsfW1tRJ2FCU197pLivY6mFAXIFzgSBypY3AVD26E/DILg5fNMhBfnU7r64RMcOlzCRR/yyHJL0DmAOboe3r4S76tbQ5Rw5bzC1F8WKviSc8zOio5Wubikdb+BLLiEw75BCJdbgFmvJxv7j/ynf1rS2+cQJJCrtpBCnawGgiPKmF3NsBi99175kuJrj47qHwLkr3iEYe0Wf54gd7sAAWMCSGtO1ySvkOIR6FaNerJv3jDr880dVtIgCtMdeAJT+x7XIIBH2OEUtSyNrjbyOwUQMZYxdB6nUI80Pci9bVHcdVn0w9taCTzGwkz5jlCGaiwRV1+5ZulH1ijPsaSpiuVbUxx/4ABRouUDo0+CZ7Pa6FcsRkUgs9rO63dC6xiX6qha7WsAukRdyiV+PF1y5aAwSI+djAEgpq6MXy5DGucNm8OTXnCl6YroP7OqjytkmRE7f2KC9hDA57vj/VLjg5JvSNHDiP/Vc/lkyI5ZZJcf2aeYMv/GSCQPg9k3EIlTmE0uPBulYqzLb+tHCKwTEmcKSuEtjA6roppSmKuzoq3aKnILyYJM/Y42dttBl63HfEo6TFuEXwDSePbUlAUdZb+N+XXZnvPwT8bbxIGrlBjyD9lDnMg8qxTezmbXwqw4I7ecxWgSCK23ayqd5XzKILhqr11RX
 qy9QVXnN
 jjU0zPsGT0xNQxEhmr4WAWO0t69dPJTecKTCpSaODPvqLVy27K5RgDE7UJ2CT06kYEoQ5PvYXAc/ATlBMvipGTCUtJzoC+AESL+RzoFG8N8r2CuOBpYbwEnNiMMKzVztbmPV6dsj68xX4vcFC9xjqj7/ZSeIrUrw/wIP4+iwUwV0fj54/XN20chTYyvkQlOAU2snaSZZP8rgqqiHibzMB3o3gEvIuIS7R1v5/ldql+LOUL3pw7LoMFYazgwG0S2fSyqA5OjUG62EfW9c9H5pfNqStNFvRnMiOvQ10g3Qb/xc1OaqcyPJkle4thfwJArCibFesjCOwzf7Hae+oWWuBFBHTN41eTqfwRC+fy8AdfOo4Vkx5iH9rbMjs0ibIoZ9kgmJk2FklxvQV9MSf2tGl22GQTbFi4f0LLBKG1+coZGWj/ldFc04tWLpt5JuNiruoLK1gGI1X9T+v3zWcT8m1epv5dOt3PZmH6irI0saIk5jty0zb5h7IGyGmX0/5roSugx9w+djTqQKhgWpXTPwwXv58/JYf64Z2vu8FytEzSSmSkbioC4EmqZFjvlstRHZmfwJoA3oFT71EjxSQZbY7Al8CG00kVQ5WLR0jwahrmdKUKL9qGAfVNFxG0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Document the PISA IOMMU 2MB-hugepage-backed DMA memory
subsystem in Documentation/core-api/pisa.rst.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 .../admin-guide/kernel-parameters.txt         |   6 +
 Documentation/core-api/index.rst              |   1 +
 Documentation/core-api/pisa.rst               | 426 ++++++++++++++++++
 3 files changed, 433 insertions(+)
 create mode 100644 Documentation/core-api/pisa.rst

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd94..cb978469a7df3 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5345,6 +5345,12 @@ Kernel parameters
 	pirq=		[SMP,APIC] Manual mp-table setup
 			See Documentation/arch/x86/i386/IO-APIC.rst.
 
+	pisa.*=		[IOMMU] Pre-mapped IOVA Superpage Allocator (PISA)
+			tuning parameters (max_bits, max_pages, slots, max_idle,
+			idle_ms, reservoir_max, scrub_max, compact, wasted_pct,
+			old_ms, pcp_batch, user_max_4K_pages, scrub_migrate).
+			See Documentation/core-api/pisa.rst.
+
 	plip=		[PPT,NET] Parallel port network link
 			Format: { parport<nr> | timid | 0 }
 			See also Documentation/admin-guide/parport.rst.
diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
index 92f91c6a0d79d..4955f477ed797 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -113,6 +113,7 @@ more memory-management documentation in Documentation/mm/index.rst.
    dma-attributes
    dma-isa-lpc
    swiotlb
+   pisa
    mm-api
    cgroup
    genalloc
diff --git a/Documentation/core-api/pisa.rst b/Documentation/core-api/pisa.rst
new file mode 100644
index 0000000000000..6ed4bd9951f8a
--- /dev/null
+++ b/Documentation/core-api/pisa.rst
@@ -0,0 +1,426 @@
+.. SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+
+=============================================
+PISA: Pre-mapped IOVA Superpage Allocator
+=============================================
+
+Overview
+========
+
+PISA is a memory allocator that provides DMA-able memory backed
+by large physically contiguous pages (typically 2MB), and mapped by
+IOMMU leaves of the same size.
+Devices can opt-in to use PISA memory for descriptor rings,
+header buffers, tx and rx data buffers, and zerocopy I/O.
+
+PISA has the following features:
+
+- greatly reduced IOTLB pressure by using fewer and much larger
+  IOMMU entries
+- greatly reduced DMA map/unmap costs. Mapping only happens when the first
+  block from a 2MB page is used. Unmapping is a no-op for the caller,
+  and happens in a separate worker the 2MB page is fully unused
+- much better security than DMA-FQ, because buffers are not returned
+  to the buddy allocator (where they could be used for code or sensitive
+  data) until all IOMMU and IOTLB mappings have been flushed.
+  Note that the mappings are kept active during the lifetime of buffers,
+  but this is the same thing that happens e.g. with pagepool, even in strict
+  IOMMU mode (DMA).
+- can remove the cost of copying into bounce buffers e.g. for overcommitted
+  or Confidential Computing VMs.
+
+For devices that do not opt-in to PISA, the IOMMU keeps using the
+native IOMMU mode (DMA or DMA-FQ).
+
+Note that PISA is fully integrated with relevant kernel APIs so
+devices can use it without device-specific code changes.
+
+What PISA is not
+================
+For avoidance of doubt: PISA is essentially a specialized memory allocator,
+modeled after alloc_pages() and related APIs. The main difference is that
+it enforces some properties on the memory it provides so that other operations
+(IOMMU mapping and unmapping, high rate allocations, identification...)
+can be implemented efficiently and with the desired security properties.
+
+It is not a specialized cache or pagepool or slab allocator:
+we have already plenty of them, built on top of the buddy allocator.
+PISA sits below these existing subsystems and acts as a memory provider.
+
+It is not a custom netdev feature. While network devices are the primary
+user, disks and other compute accelerators can use it, again, as a replacement
+for the alloc_pages() allocator.
+
+Background and motivations
+==========================
+
+I/O devices typically access at least 3-4 different memory regions on
+each transaction (network packet or disk request):
+
+- command, completion and buffer queues
+- optionally, header or metadata buffers (e.g., NIC packet headers, NVMe SGL...)
+- data buffers (TX socket buffers, NIC RX buffers, disk I/O buffers)
+
+Enabling the IOMMU impacts performance for the following reasons:
+
+- CPU cost to install/remove IOMMU Page Table Entries (PTEs)
+  (``dma_map_*()``, ``dma_unmap_*()``)
+- CPU/system overhead to flush the IOTLB, ie remove stale PTEs that could give
+  access to sensitive data or code when memory is recycled for other purposes.
+- Higher DMA read/write latency from IOMMU page walks when the working set
+  exceeds the IOTLB size, backpressuring the bus via flow control.
+  This is one of the biggest bottlenecks for high speed devices:
+  typical network devices have very little IOVA locality, and that makes
+  the IOTLB almost completely ineffective.
+
+There are known methods to mitigate these problems:
+
+1. Recycling I/O buffers and their IOMMU mappings removes most of the DMA
+   map/unmap costs. This is common practice for command, completion and
+   buffer queues, as well as disk I/O and network receive buffers.  Network
+   TX buffers are a noticeable exception. They normally come from
+   ``alloc_pages()`` calls unaware of the leaf device, and require
+   mapping/unmapping on each use.
+
+2. Lazily flushing the IOTLB (as implemented by DMA-FQ) amortizes a
+   very expensive operation (up to several microseconds to wait for
+   completion, necessary for security), but the way it is implemented
+   in DMA-FQ compromises on security: IOTLB flush requests are run
+   periodically in batches, but the underlying memory is recycled without
+   waiting. During that window, the physical memory is still accessible,
+   opening the door to exfiltration or corruption of sensitive data/code.
+
+3. The set of PTEs in active use can be significantly reduced by mapping larger
+   blocks, e.g. 2MB large pages instead of the usual 4KB (PTE). This is not
+   currently pursued by the kernel.
+
+PISA addresses all the above with a combination of simple, known concepts,
+implemented in a way that integrates smoothly with the kernel and drivers:
+
+- intercept calls to the small set of functions used to allocate, map,
+  unmap, and free device-accessible memory (rings and buffers)
+- return memory backed by physically contiguous 2MB PISA pages and 2MB IOMMU
+  mappings
+- heavily recycle memory and mappings
+- wait until the IOTLB has been flushed before returning unused PISA pages
+  to the system
+
+Execution is what makes PISA practical: the implementation intercepts
+a small set of kernel APIs so that device will inherit the benefits with
+little if any changes, and the design is such that these intercepts have
+minimal impact on the original functions.
+
+Furthermore, since PISA intercepts allocations of device-accessible
+memory, it can transparently configure unencrypted mode, required for
+confidential computing. Under a paravirtualized IOMMU, the long-lived 2MB
+mappings also make host-side pinning of DMA memory a rare event.
+
+Limitations
+===========
+
+PISA is currently limited to systems with 2MB large pages, which
+is the vast majority of existing platforms. This is enforced at compile time.
+
+Decoupling the allocation size from 2MB can be made without much effort,
+so the mechanisms can be extended to systems with 16K/64K page size.
+
+The implementation assumes non-preemptible spinlocks, so PISA is not
+compatible with ``PREEMPT_RT``. This is enforced at compile time.
+
+PISA can only be used by DMA-coherent devices. This is enforced at runtime.
+
+IOMMU mappings for data buffers follow the direction the allocator was created
+with. Receive pools (``page_pool``) are ``DMA_BIDIRECTIONAL``, so received
+buffers can be retransmitted (XDP_TX, forwarding) without a new mapping.
+Allocators that only hold transmit data, such as socket TX fragments, are
+``DMA_TO_DEVICE``. Allocators created
+``DMA_TO_DEVICE`` or ``DMA_FROM_DEVICE`` have their PISA pages mapped device
+read-only or write-only, and a mapping that requests other access falls back
+to a per-buffer mapping.
+
+IOMMU mappings for queues are also ``DMA_BIDIRECTIONAL``, though stricter modes
+can be implemented trivially.
+
+Implementation details
+======================
+
+Most of the code size and design complexity relates to the handling
+of exceptional events (device teardown, memory hotplug) and to
+the safe release of pages through deferred tasks, RCU and grace
+periods.
+
+The implementation lives in ``drivers/iommu/pisa-*.c`` and
+``include/linux/pisa.h``, and relies on the components described below.
+We use the name "PISA" to refer to the second-level physically contiguous
+pages (typically 2MB) used for I/O memory, but the design is not tightly
+bound to the use of a PISA page.
+
+The set of functions that need to be intercepted is relatively small:
+
+- ``page_pool_dev_alloc*()``, socket TX page frags, ``__free_pages()``
+- ``dma_alloc_attrs()``, ``dma_map_*()``, ``dma_unmap_*()``
+
+and most devices will automatically inherit the benefits.
+
+Requirements (for performance and functionality)
+================================================
+
+- efficient identification of PISA pages, based on either their Physical
+  Address (PA) or their I/O Virtual Address (IOVA)
+- fast access to PISA page metadata
+- fast allocation under highly concurrent usage
+- efficient DMA map/unmap
+- comprehensive lifetime management
+- support for confidential computing (decrypted DMA buffers)
+
+Internal mechanisms
+===================
+
+We use the following components:
+
+- **PISA metadata** (``struct pisa_meta``):
+
+  Identification of PISA pages could be done in principle with a flag in
+  ``struct page``, but that would not solve the management of per-page
+  metadata.
+
+  PISA addresses both requirements without depending on ``struct page``
+  using an idea similar to ``pageblock_flags``. Each PISA page used as a
+  buffer requires only 256B of metadata, or 0.01% overhead. For metadata,
+  we reserve a sparse virtual memory region of approximate size
+  ``max_possible_pfn * 256 / PISA_SIZE`` (``pisa.max_bits=N`` on the
+  command line covers ``2^N`` bytes of physical address space instead; RAM
+  above the covered range is not used by PISA), so the metadata can be accessed
+  directly using the PISA page index.  A metadata page is backed when a
+  allocator first takes a PISA page in its 32MB chunk, from any context: the
+  page tables are allocated beforehand for present RAM, and by a memory
+  hotplug notifier for memory added later. A compact bitmap (1 bit per
+  32MB chunk, or 4KB per 1TB of address space) tracks which metadata
+  pages are backed, allowing fast lockless validation and direct array
+  indexing.
+
+  ``struct pisa_meta`` has flags to mark the page status (used as
+  PISA buffer, or decrypted for confidential computing), and tracks
+  which subpages are free, which domains have an active IOMMU mapping for
+  the page, and holds list/RCU linkage to manage its lifetime.
+
+- **Per-domain reserved PISA IOVA ranges**:
+
+  Another key requirement is to quickly resolve the PA-IOVA mapping for a
+  given domain. Since a PISA page can be mapped in multiple domains (e.g.
+  a network buffer used to route packets between different NICs), it would
+  be too expensive to manage random PA-IOVA mappings created on the fly.
+  Each PISA page gets a dense slot number when it enters PISA, and is
+  mapped at the same offset, ``slot * PISA_SIZE``, in
+  every domain's window. PISA reserves on each domain an IOVA range of
+  ``pisa.slots * 2MB`` (by default 2 * ``max_pages`` slots, i.e. a
+  quarter of RAM): its size does not depend on the physical memory layout,
+  and IOVAs do not expose physical addresses. The IOVA allocation happens
+  the first time a domain is used, hence a IOVA within the reserved range
+  will uniquely identify a PISA page. Slots are handed out lowest first
+  and reused only after the page has been unmapped from every domain.
+
+- **alloc_pages() compatible pisa_alloc allocator for I/O buffers**:
+
+  PISA implements a pisa_alloc object for fixed-order page allocations
+  that is a natural fit for the allocation of NIC receive buffers and tx
+  socket buffers. The API is similar to ``alloc_pages()`` (in fact, it is an
+  almost direct replacement) and pisa_allocs are instantiated as follows:
+
+  - per node, order-0 ``DMA_BIDIRECTIONAL`` (``__GFP_PISA_RW``), with per-CPU
+    block caches, to provide RX buffer pages
+  - per node, ``DMA_TO_DEVICE`` (``__GFP_PISA_RO``), with per-CPU block caches
+    to provide order-3 (``SKB_FRAG_PAGE_ORDER``) pages to refill tx socket buffers; on a miss,
+    an ordinary order-0 page is used. Order-2 ``DMA_TO_DEVICE`` (without per-CPU
+    caches) is also provided for small skb heads on systems with few CPUs.
+
+  - per node, order-0 ``DMA_BIDIRECTIONAL`` (``pisa_alloc_coherent()``),
+    carving naturally aligned contiguous 4KB page ranges (up to ``PISA_SIZE``)
+    to back coherent ``dma_alloc_attrs()`` queues and header bounce buffers
+    when ``dev->pisa_coherent`` is enabled.
+
+
+- **Fine grained control**
+
+  Both for experimentation and production use, it is useful to have
+  some form of control on which devices want to use PISA and for
+  what. PISA exposes the following controls. Keep in mind that full
+  performance can only be achieved if all regions are mapped using PISA.
+
+  - ``/sys/devices/*/*/pisa_{coherent,rx_bufs,tx_bufs,tx_skb_heads}``
+    per-device entries that control whether a device uses PISA for coherent
+    allocations, RX buffers, TX socket page fragments, and small TX skb heads
+
+- **Safe release of memory to the system**
+
+  A key feature of PISA is that memory is not released to the system
+  while there are active IOMMU mappings. Release of buffers is managed
+  as follows
+
+  1. on ``__free_pages()`` or ``dma_free_attrs()``, blocks are returned to
+     PISA, IOMMU mappings are still active, and they can be recycled
+
+  2. when all blocks in a PISA page are unused, the page is moved to the
+     allocator's "idle" list, still with active mappings and available for reuse,
+     unless the allocator already holds max_idle_pages idle pages
+
+  3. pages above that per-allocator watermark are released by a reclaim work
+     item, and under memory pressure the shrinker also releases idle pages
+     from all allocators: the iommu mappings are removed and a synchronous IOTLB
+     flush is issued. The pages are no longer usable for allocations but not
+     returned to the buddy allocator yet
+
+  4. once the previous step is complete, the system schedules ``call_rcu()``
+     and waits for an RCU grace period (and re-encrypts the page if it was
+     decrypted) before returning the PISA page to the buddy allocator.
+
+- **Handling domain destruction**
+
+  When a device/domain is destroyed, all I/O issued by the device must have
+  been quiesced and memory released via ``__free_pages()`` or ``dma_free*()``.
+  PISA hooks into the domain destructor (``iommu_put_dma_cookie()``) and
+  forgets the disappearing domain: its bit is cleared in every active
+  PISA page, without touching the domain's page tables, which the owner
+  frees wholesale. The domain index is reused only after an SRCU grace
+  period.
+
+- **Handling loss of the last DMA API user**
+
+  ``dma_unmap_*()`` never removes window PTEs, so when the last driver using
+  a group's default domain through the DMA API unbinds, or the group's DMA
+  ownership is taken (VFIO, iommufd), ``pisa_domain_quiesce()`` unmaps every
+  active PISA page from that domain and flushes the IOTLB. The window
+  and domain index are kept; PTEs are re-installed on demand if a driver binds
+  again. In-flight page_pool pages, which ``page_pool_scrub()`` cannot unmap,
+  are covered the same way.
+
+- **Allocation and compound splitting**:
+
+  An allocator that needs memory calls ``pisa_alloc_split_page()`` to allocate a
+  physically contiguous PISA page on the calling CPU's NUMA node, and
+  ``split_page_compound()`` to split it into independent blocks of
+  ``pa->order``. These blocks can be independently passed through the
+  networking stack.
+
+Modified kernel APIs and runtime controls
+=========================================
+
+PISA integrates transparently into existing kernel memory, DMA, and
+networking APIs. Allocation of PISA memory is opt-in via per-device sysfs
+attributes or module parameters. Mapping, unmapping, and freeing automatically detects
+whether a buffer or IOVA belongs to PISA:
+
+- **Streaming DMA map and unmap** (``dma_map_page_attrs()``,
+  ``dma_map_single_attrs()``, ``dma_map_sg_attrs()`` and
+  ``dma_unmap_page_attrs()``, ``dma_unmap_single_attrs()``,
+  ``dma_unmap_sg_attrs()`` via ``drivers/iommu/dma-iommu.c`` and
+  ``kernel/dma/direct.c``):
+
+  - On map, any buffer belonging to a PISA page
+    (``is_pisa_phys(phys)``) is mapped via the domain's reserved
+    PISA IOVA window with a simple addition, typically reusing
+    existing mappings. Under ``dma-direct``, decrypted PISA pages
+    (``is_pisa_direct(phys, size)``) can be mapped directly without
+    ``swiotlb`` bounce.
+
+    On unmap, IOVAs can be identified as PISA buffers with a simple
+    range check and that results in a no-operation.
+
+- **Coherent DMA allocation and free** (``dma_alloc_attrs()`` /
+  ``dma_alloc_coherent()`` and ``dma_free_attrs()`` / ``dma_free_coherent()``
+  via ``drivers/iommu/dma-iommu.c`` and ``kernel/dma/direct.c``):
+
+  - PISA is enabled per device via ``/sys/devices/.../pisa_coherent``
+    (``dev->pisa_coherent``). When set, sleepable ``GFP_KERNEL`` coherent
+    allocations up to ``PISA_SIZE`` are rounded up to 4KB, carved out of
+    the per-node order-0 ``pisa_alloc`` via ``pisa_alloc_coherent()``, and
+    mapped through the domain's PISA IOVA window (or directly at their
+    physical/decrypted DMA address for ``dma-direct``). ``dma_free_attrs()``
+    releases the order-0 pages via ``pisa_free_coherent()``, which recycles
+    them back to the allocator.
+
+- **Page allocator release** (``__free_pages()`` / ``put_page()`` via
+  ``__free_pages_prepare()`` in ``mm/page_alloc.c``):
+
+  - ``pisa_free_page()`` checks ``is_pisa_page(page)``
+    and recycles PISA subpages back to their owning ``pisa_alloc``
+    instead of releasing them to the buddy allocator while their 2MB IOMMU
+    mappings remain active.
+
+- **IOMMU domain teardown** (``iommu_put_dma_cookie()`` in
+  ``drivers/iommu/dma-iommu.c``):
+
+  - A call to ``pisa_domain_release()`` before freeing a
+    domain's IOVA cookie and page tables clears cached domain state across
+    all allocators. Existing IOMMU mappings and IOTLB flush has already happened.
+
+- **Networking ``page_pool``** (``net/core/page_pool.c``):
+
+  - PISA is enabled per device via ``/sys/devices/.../pisa_rx_bufs``
+    (``dev->pisa_rx_bufs``). ``__page_pool_alloc_netmems_slow()`` adds
+    ``__GFP_PISA_RW`` via ``pisa_rx_gfp()`` when ``PP_FLAG_DMA_MAP`` is set,
+    allocating RX pages from the per-node ``DMA_BIDIRECTIONAL`` PISA
+    allocator and falling back to the buddy allocator on exhaustion.
+
+- **Socket TX page fragments** (``sk_page_frag_dst()`` and
+  ``skb_page_frag_refill()`` in ``net/core/sock.c``):
+
+  - When enabled per device via ``/sys/devices/.../pisa_tx_bufs``,
+    socket TX fragments are allocated from per-node ``pisa_alloc`` instances,
+    with per-CPU block caches in front of them.
+    These allocators are ``DMA_TO_DEVICE``: devices can only read them, and
+    callers that map fragments for device writes get per-buffer mappings.
+  - Only data routed to a device with a DMA parent, outside IPsec, is copied
+    into them (TCP, UDP/raw), through a dedicated
+    per-task frag. Loopback, virtual devices, kTLS, sockmap, KCM and MPTCP
+    use ordinary pages. ESP output uses the allocators through
+    ``skb_page_frag_refill_dev()``, when their egress device can use them.
+
+- **Small skb heads** (``kmalloc_reserve()`` in ``net/core/skbuff.c``):
+
+  - When enabled per device via ``/sys/devices/.../pisa_tx_skb_heads``,
+    small skb heads come from the ``skbuff_small_head_pisa`` slab cache,
+    whose slab pages are blocks of per-node TX-only ``pisa_alloc``
+    instances (created ``DMA_TO_DEVICE``), zeroed when taken from the allocator.
+    Mappings of these heads that request device write access fall back to
+    per-buffer IOMMU mappings.
+
+- **NIC driver RX buffers**
+
+  - Controlled per device by ``/sys/devices/.../pisa_rx_bufs``
+    (``dev->pisa_rx_bufs``) for queue modes managing their own page rings
+    (e.g. ``gve`` GQI-RDA).
+
+- **User pages for MSG_ZEROCOPY** (``drivers/iommu/pisa-user.c``):
+
+  - ``madvise(MADV_PISA)`` migrates the present private anonymous pages
+    of a range into blocks of per-node ``DMA_TO_DEVICE`` allocators, so that
+    zerocopy sends from them use the PISA window instead of per-send IOMMU
+    mappings or hypervisor pinning. ``MADV_NOPISA`` migrates them back to
+    ordinary pages. Both are allowed through ``process_madvise()``.
+    Freeing the pages (``munmap()``, ``MADV_DONTNEED``, exit, reclaim)
+    returns the blocks to their allocators.
+  - ``/sys/module/pisa/parameters/user_max_4K_pages``: Soft cap on user
+    pages held in PISA blocks, in 4 KB pages (``max_pages`` counts PISA
+    pages). When non-zero, eligible pages are also migrated on
+    ``MSG_ZEROCOPY`` sends (best effort, non-blocking, skipping pages still
+    referenced by in-flight skbs); 0 (default) disables both. With
+    ``pisa_tx_bufs`` also enabled, pages that are not in PISA
+    after that (cap reached, busy, large, shared or file-backed) are copied
+    by TCP into PISA socket frags instead of being sent zerocopy (other
+    senders still send them zerocopy); the copy is not reported to the
+    application.
+  - Not available on CoCo guests: decrypted blocks cannot be mapped to user
+    space, and whole pages would be shared with the host.
+
+- **Global memory limit and observability:**
+
+  - ``/sys/module/pisa/parameters/max_pages``: Global cap on PISA
+    pages held by all allocators and the per-node reservoirs
+    (defaults to 1/8th of physical RAM, at least 16 pages).
+  - ``/sys/module/pisa/parameters/reservoir_max``: Per-NUMA-node reservoir
+    target of pre-allocated PISA pages (defaults to 16 per memory node).
+  - ``/sys/module/pisa/parameters/scrub_max``: Max idle PISA pages
+    scrubbed per background pass (0 disables background scrubbing).
+  - ``/sys/kernel/debug/pisa/allocs``: Debugfs summary of global, per-node,
+    user-page, and per-allocator allocation, mapping, and fallback counters.
-- 
2.56.0.542.g3ef89b7020-goog


