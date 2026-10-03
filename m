Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEB51CA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B757B6B008C; Sat,  3 Oct 2026 17:22:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4B2A6B0092; Sat,  3 Oct 2026 17:22:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 979266B0093; Sat,  3 Oct 2026 17:22:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0A96B008C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:22:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF880120AA8
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:22:50 +0000 (UTC)
X-FDA: 85282589700.04.03704DE
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0B726120004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:22:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OvcWTX2R;
	spf=pass (imf29.hostedemail.com: domain of 3J3LBagYKCG4XdUllaSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--lrizzo.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3J3LBagYKCG4XdUllaSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCPdU27sg6z5vmqKOpFlsCnhDDPZy7EzA7omKnPk3ys=;
	b=L0GelhIh5VXNU8L6XGazLiapN7Sy2NTpyHJVeCm4XhMQ60b5QjmbR7Ggcj+f+ckMF9NIHc
	Kdmbdl2v2JAymQXEasnPl8h9IhdcSfjQadEpdGxiwWf7Kwmvz959pD2WqEpwyUjUhximJt
	dOZID+MbQc/0YoKIQMmq6baEkcfpUAg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062569;
	b=3INJKyu8BfHHb4fwGItzl3XenDni6H54zWjtufVv2BxtoWeZrvoIwma5LsppemQAgY9t6w
	NC28UCoJAoWrXjqYT6AmSYSTHTx2leHS6SK2xA9zK4FOsPSl4UmXmkIzPGR2XL+QzG7GYh
	hD6V2g83L3e/gvGgxYlLNgHqUw62No8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OvcWTX2R;
	spf=pass (imf29.hostedemail.com: domain of 3J3LBagYKCG4XdUllaSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--lrizzo.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3J3LBagYKCG4XdUllaSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a125f5b317so897673a12.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062568; x=1791667368; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wCPdU27sg6z5vmqKOpFlsCnhDDPZy7EzA7omKnPk3ys=;
        b=OvcWTX2RmHEeAmyyIzf2b+bg1cL8ZpQ/EPEPgceWdqFgeM4Ylyr6uFpn+f8WKNvecJ
         QH7xCxEslsARejHXA8JunPjGonBrImS2YVPsaD3xoHTPUDuc3rNml/OIfH7e7C1M79h7
         //+0BeXcVyUI6yiq6nf4ymlLuWgFmZtN15KOVUTt1A/HX0w0cOArsJBnuYC/igfki3Fe
         NpLlcX/h1PBodiSWRcvhCtEqlgp1BglhD24GxPIyA3cGwHGQV6Lqrju8NPUOifardEIn
         hYv4r64N1FXlpkzw50dv3kTVQ18Z432Z+rpgHL0lfneK6JMe9knTYcp7AeZ2XspvCqyG
         ZwIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062568; x=1791667368;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wCPdU27sg6z5vmqKOpFlsCnhDDPZy7EzA7omKnPk3ys=;
        b=VOGur7W7NujAvqqLagbFwTZxi8ScA2vNAIgnDaRvfWC0xbe04WKmNKjnejPVHhVbxJ
         BLz8/mcO7XvJspYFhZU6UjjlugaoZdnK1354LvZhK6D60bdO1L7O5d1CJYmgADw2zg3c
         HNZHjz+NQkXhVoKvb27/Tn9qtmysIweevAKQ4y9VoKLjzbmtBxgmqDgW7BAuSgVQ60dY
         d4B4ApwAOYr6lsLCx/le+37kEvqMfnAnOUx0IxL8DfrJfn7o0pSaDM6KSXCD0z/iOj34
         BzEN1kW5vYB6zeP6/KwQtiQniB1CpkRBIx0m/kSCifi//uoOifTL1nyerDa/Gxv3KhSN
         LQWw==
X-Forwarded-Encrypted: i=1; AKwUvBzfM/U9iUw5R6EZC0W/M/j7dgIAWSMXr+wT2D5LqNJ6nUxbZ3YfKZXhc0uFRdFP/ZpdrK4icm3RHw==@kvack.org
X-Gm-Message-State: AFq9FYJRmVbUMnSV10Ay8Tis4wVBrAYzj8DNO11Nb61ZI+wfudWmzT9S
	NQARlwHLL92z1XuMHuFWkgTrRbNKIRi/i2o0JOdDp2YaSF0Q32sZ5m9kEgJ4+EzM91y3X8Ijwig
	5Mhtgkw==
X-Received: from edbfj19.prod.google.com ([2002:a05:6402:2b93:b0:6ae:1946:248a])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:3810:b0:6ac:813a:a1ef
 with SMTP id 4fb4d7f45d1cf-6af9e2f1a5fmr5355535a12.26.1791062567237; Sat, 03
 Oct 2026 14:22:47 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:20 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-2-lrizzo@google.com>
Subject: [RFC: DMA_PMD 01/22] iommu/dma: introduce CONFIG_DMA_PMD and metadata table
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: igq4r4n63xjg7pijyzbexp7k3769758q
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0B726120004
X-HE-Tag: 1791062568-210549
X-HE-Meta: U2FsdGVkX1+01v7MAp0QdUo8UAl/nGhs4+2/UJP0kU0x6f4qC1FhgGDQvfdzNHhyy91C5u2oC20GmQ1O/bsh6KjH+9MeuklWQI1c28+KtLiO7juMQ9iIfeKx5d83DXab6ZbVBUjRLSruAffIVZRWgfaIl752DSYvDmXZiB98EcQlQopRe+hniBqAI9U1cA8vbeuzXFR++ZFJ9WQ7T3roVDjYYThy6ii4bRJpxvCfBJFNh2WPYdzAmIyBevBnLKFsk53wZt+kZajhF9imLQQvEVTUJTBvQBvqwWQ2JgFSNJ4Vz3sP+rP6xQmH7SvYiLuzogWXQW1oWYY8mBSx4bthDx6BAaeDVLMLCRIEjwSB1cBqyOqGvVJl3NPLJ5WMgHdJT9fqHrCWDAjPLct0x/2/7CrOzaSfWeFlbVZYg92pUv5jeKrEo7IuYCHFgRAZ4UER14+BYEyQuR0v6ztQayq4a8BCQSwXVaBbBsRJJerkBvkqWifnAjdqj7HDNoEFukgQffKVs33px6X1w9jsrD4hWG4qYCfbPUeHPAy1wMxenRnWepFGG8tQTvoA9CHICZGRiYgVBWGdBMeAahejOsTQUXT7vqlFTacrF/qVAg/xuijEpDBsIWZq0DnpWTlQTYUeKLhJPjzfZobhrRVytJei2eBGS0c1lq07hzfVjfLkuKl75ss7D8T/dpoieUp0SJ+5RPklTE+UONEcfmFFyBtfeY2tItopVgr62+At5s4n2xFMDde+Uks8068Q9VF8nDmz91kATdOo5SAcaB8xSOXIbMel9GcHeNfgkaSklZdUnHasD1ieysOxGllcbiA6Rambz0/D1HbkF8RZ8Uy3uiR1Cyva/1J0NhkTe3Veghs7WTMmdxUIPhtRk7nIIZlr5R0CCY0wY91y0Usuuj0v38s7eFeWMPIBXEFi7DqMv9tdNAmu1D8eFYdMsY61uEdsjM/GmPrifotUn/R3nM3yo2v
 UZ51XVpm
 Tk6N53Pqce6eV4p0wGi3z5QuPYdvUEARn/u7jpOwc+OQVCNFg0Xa9cydpyKiHAXU43D9AJD/WGJKTywuxekihOzcHDSWSiH/JioN9HGs1IviAReAoXzEAHt+tCKaK7hPuPKV7idOdE+IKEEsW7YLxUV32zhsTimWyk6zqTl7+2ev9fJzJIiJa1RDcNV3jelVdlarGVehXybCDYYrwPsIWAX/SsRoDqR/PYXGXTskR0L25EEyQB1nWrk6eUrL5KvrvCVBMv/GuTww6K6JlvDJvngztirC8SKLXpwUsLmHKAvcWS/gSoLnU0nxHFm/XVHVLg9d3klsMZ2Cc+HQ0oQT7y+2bR9vCiRMinFxe2BBNK2gKnfu03vJRlHaSJwnDolblNlYm1jhpkAHOCJfqncTu4pjtzufZkygcPnP6ZAAjc7ZD6s/S2SzTOhSFlzPTl5k/vZBavd7vJJ6fQbLaGRuSEvlo/jUawvMJybw2SLXyaN/e63IykAYdhPQ6PFycDB1Z+V7CQRBveAWNyBP32m0TLcyjDSSwftcePPbo+g7aW4E2FHFWE+93gz5UYbHSuA6HP8ygy3jK1zfQeQnGXNpxiVg+U+Wk2VJ36GQQBP0xO+haBZFi+eH2QxPaOXlb4xxnaU97MtJyFlesfvLZg84a4MXQ6Ox8HChzBxUVFBHlQd2YseScZ7g1mA/rhxtpE4/kjT8k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DMA_PMD is a new subsystem to back IO buffers with physically contiguous
PMD_SIZE pages, allowing the use of larger leaves in the IOMMU.  This
significantly reduces IOTLB pressure, with great performance benefits. It
support very common cases (2MB PMD, !PREEMPT_RT).  The 2MB backing pages
are dynamically allocated and released.  DMA_PMD overhead is 128B of
metadata per physical page (64KB per 1GB, or 0.01% of physical RAM).

Add a CONFIG_DMA_PMD option to enable it only when applicable, and
introduce a sparse per-PMD metadata table to store the necessary side
information efficiently (similar in principle to pageblock_flags).
The table is initialized on first use, reserving KVA across the physical
address space up to iomem_resource.end (capped at MAX_PHYSMEM_BITS,
64KB of KVA per 1GB of address space) along with a chunk-populated
bitmap (1 bit per 64MB chunk) for fast lockless lookups. Only chunks
covering online RAM are backed by physical pages at init; memory
hotplugged later within the reserved range is populated on demand when
allocated by a DMA_PMD pool, and safely declined otherwise.

Also add a built-in KUnit test suite (CONFIG_DMA_PMD_META_KUNIT_TEST)
exercising initialization idempotency, PFN/physical round-trip lookups,
out-of-bounds physical address handling, and DMA_PMD membership toggling.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 Documentation/core-api/dma-pmd.rst | 320 +++++++++++++++++++++++++
 Documentation/core-api/index.rst   |   1 +
 drivers/iommu/Kconfig              |  32 +++
 drivers/iommu/Makefile             |   2 +
 drivers/iommu/dma-pmd-kunit.c      | 102 ++++++++
 drivers/iommu/dma-pmd-meta.c       | 365 +++++++++++++++++++++++++++++
 drivers/iommu/dma-pmd-priv.h       |  56 +++++
 include/linux/dma-pmd.h            |  36 +++
 8 files changed, 914 insertions(+)
 create mode 100644 Documentation/core-api/dma-pmd.rst
 create mode 100644 drivers/iommu/dma-pmd-kunit.c
 create mode 100644 drivers/iommu/dma-pmd-meta.c
 create mode 100644 drivers/iommu/dma-pmd-priv.h
 create mode 100644 include/linux/dma-pmd.h

diff --git a/Documentation/core-api/dma-pmd.rst b/Documentation/core-api/dma-pmd.rst
new file mode 100644
index 0000000000000..1d113b8c15876
--- /dev/null
+++ b/Documentation/core-api/dma-pmd.rst
@@ -0,0 +1,320 @@
+.. SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+
+=========================================================
+DMA_PMD: PMD_SIZE IOMMU mappings for DMA-coherent devices
+=========================================================
+
+Overview
+========
+
+DMA_PMD is a transparent enhancement of the current IOMMU modes, that
+gives the performance of identity mode, and like strict IOMMU mode
+(DMA), guarantees that memory will go back to the buddy allocator only
+when all IOMMU mappings have been removed and IOTLB flushed.
+
+The original design aimed at removing IOTLB thrashing, but its mechanism
+also give security guarantees comparable to strict IOMMU, and remove the
+bounce buffer overhead from Confidential Computing and preemptible VMs.
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
+  This is one of the biggest bottleneck for high speed devices:
+  typical network devices have very little IOVA locality, and that makes the IOTLB
+  almost completely ineffective.
+
+There are known methods to mitigate these problems:
+
+1. Recycling I/O buffers and their IOMMU mappings removes most of the DMA map/unmap
+   costs. This is common practice for command, completion and buffer
+   queues, as well as disk I/O and network receive buffers.  Network
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
+   blocks, e.g. 2MB (called PMD) instead of the usual 4KB (PTE). This is not
+   currently pursued by the kernel.
+
+DMA_PMD addresses all the above with a combination of simple, known concepts,
+implemented in a way that integrates smoothly with the kernel and drivers:
+
+- intercept calls to the small set of functions used to allocate, map, unmap, and free
+  device-accessible memory (rings and buffers)
+- return memory backed by physically contiguous 2MB pages (PMD) and 2MB IOMMU
+  mappings
+- heavily recycle memory and mappings
+- wait until the IOTLB has been flushed before returning unused DMA_PMD memory
+  to the system pool
+
+Execution is what makes DMA_PMD practical: the implementation intercepts
+a small set of kernel APIs so that device will inherit the benefits with
+little if any changes, and the design is such that these intercepts have
+minimal impact on the original functions.
+
+Furthermore, since DMA_PMD intercepts allocations of device-accessible
+memory, it gives two important benefits:
+- transparent pinning/unpining, required for preemptible VMs
+- transparent configuration of unencrypted mode, required for confidential computing
+
+Limitations
+===========
+
+DMA_PMD is currently limited to systems with ``PMD_SIZE`` equal to 2MB, which
+is the vast majority of existing platforms. It could be extended to larger
+pages without much effort. This is enforced at compile time.
+
+The implementation assumes non-preemptible spinlocks, so DMA_PMD is not
+compatible with ``PREEMPT_RT``. This is enforced at compile time.
+
+DMA_PMD can only be used by DMA-coherent devices. This is enforced at runtime.
+
+IOMMU mappings for data buffers are always ``DMA_BIDIRECTIONAL``. This
+simplifies the handling of e.g. forwarding between different network
+interfaces.
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
+The implementation lives in ``drivers/iommu/dma-pmd-*.c`` and
+``include/linux/dma-pmd.h``, and relies on the components described below.
+We use the name "DMA_PMD" to refer to the second-level physically contiguous
+pages (typically 2MB) used for I/O memory.
+
+The set of functions that need to be intercepted is relatively small:
+
+- ``page_pool_dev_alloc*()``, ``skb_page_frag_refill()``, ``__free_pages()``
+- ``dma_alloc_attrs()``, ``dma_map_*()``, ``dma_unmap_*()``
+
+and most devices will automatically inherit the benefits.
+
+Requirements (for performance and functionality)
+================================================
+
+- efficient identification of DMA_PMD pages, based on either their Physical
+  Address (PA) or their I/O Virtual Address (IOVA)
+- fast access to DMA_PMD page metadata
+- fast allocation under highly concurrent usage
+- efficient DMA map/unmap
+- comprehensive lifetime management
+- support for confidential computing (decrypted DMA buffers)
+- support for preemptible VMs (pinned DMA buffers)
+
+Internal mechanisms
+===================
+
+We use the following components:
+
+- **DMA_PMD metadata** (``struct dma_pmd_meta``):
+
+  Identification of DMA_PMD pages could be done in principle with a flag in
+  ``struct page``, but that would not solve the management of per-page
+  metadata.
+
+  DMA_PMD addresses both requirements without depending on ``struct page``
+  using an idea similar to ``pageblock_flags``. Each 2MB page used as a
+  buffer requires only 256B of metadata, or 0.01% overhead. For metadata,
+  we reserve a sparse virtual memory region covering of approximate
+  size ``max_pfn * 256 / PMD_SIZE``, so the metadata can be accessed
+  directly using the 2MB page index.  Metadata pages are populated on
+  demand, with a compact bitmap (1 bit per 32MB chunk, or 4KB per 1TB
+  of address space) tracking which metadata pages are backed, allowing
+  fast lockless validation and direct array indexing. Memory hotplugged
+  later is also supported.
+
+  ``struct dma_pmd_meta`` has flags to mark the page status (used as
+  DMA_PMD buffer, decrypted for confidential computing, or pinned against
+  memory compaction), and tracks which subpages are free, which domains
+  have an active IOMMU mapping for the page, and holds list/RCU linkage
+  to manage its lifetime.
+
+- **Per-domain reserved DMA_PMD IOVA ranges**:
+
+  Another key requirement is to quickly resolve the PA-IOVA mapping for a given domain. Since
+  a DMA_PMD page can be mapped in multiple domains (e.g. a network buffer used
+  to route packets between different NICs), it would be too expensive to manage random
+  PA-IOVA mappings created on the fly.
+  DMA_PMD reserves on each domain an IOVA range
+  covering the physical memory range plus an extra region, allowing a
+  fixed PA-IOVA offset, possibly different for each domain.
+  The IOVA allocation happens the first time a domain is used, hence a
+  IOVA within the reserved range will uniquely identify a DMA_PMD page.
+
+- **alloc_pages() compatible dma_pmd_pool allocator for I/O buffers**:
+
+  DMA_PMD implements a dma_pmd_pool object for fixed-order page allocations
+  that is a natural fit for the allocation of NIC receive buffers and tx
+  socket buffers. The API is similar to ``alloc_pages()`` (in fact, it is an
+  almost direct replacement) and dma_pmd_pools are instantiated as follow:
+  - per NIC-receive-queue (or page_pool) to provide order-0 pages to each queue
+  - per-CPU to provide order-0 and order-3 pages to refill tx socket buffers.
+
+- **dma_pmd_arena allocator to back dma_alloc_attrs()**
+
+  Devices use ``dma_alloc_attrs()`` or variants for long-lived, variable size
+  allocations to back device queues and header buffers. dma_pmd_arena
+  has the same functions: it both allocates and maps memory in the
+  reserved IOVA, and is used exclusively within dma_alloc_attrs() to
+  handle suitable requests (4K or larger, GFP_KERNEL, for devices that
+  specifically enable DMA_PMD)
+
+
+- **Fine grained control**
+
+  Both for experimentation and production use, it is useful to have
+  some form of control on which devices want to use DMA_PMD and for
+  what. DMA_PMD exposes the following controls. Keep in mind that full
+  performance can only be achieved if all regions are mapped using DMA_PMD.
+
+  - /sys/devices/*/*/dma_pmd_{rings,rxbuf,tx_hdrs} per-device entries
+    that can be used within device drivers to decide whether to use DMA_PMD for each of its regions
+
+  - /proc/sys/net/core/tx_enable_dma_pmd controls whether tx socket buffers should use DMA_PMD
+
+- **Safe release of memory to the system**
+
+  A key feature of DMA_PMD is that memory is not released to the system
+  while there are active IOMMU mappings. Release of buffers is managed
+  as follows
+
+  1. on ``__free_pages()`` or ``dma_free_attrs()``, blocks are returned to DMA_PMD,
+     IOMMU mappings are still active, and they can be recycled
+
+  2. when all blocks in a DMA_PMD page are unused, the page is moved to an
+     "idle" list, still with active mappings and available for reuse
+
+  3. upon memory pressure or when above some global threshold, a shrinker
+     thread collects idle pages from all pools and starts removing the iommu
+     mappings and issues a synchronous IOTLB flush. The pages are not usable for allocations
+     but not returned to the pool yet
+
+  4. once the previous step is complete, the system schedules ``call_rcu()``
+     and waits for an RCU grace period (and re-encrypts the page if it was
+     decrypted) before returning the 2MB page to the buddy allocator.
+
+- **Handling domain destruction**
+
+  When a device/domain is destroyed, all I/O issued by the device must have
+  been quiesced and memory released via ``__free_pages()`` or ``dma_free*()``.
+  DMA_PMD hooks into the domain destructor and removes all existing mappings
+  for the disappearing domain and synchronously flushes the IOTLB, similarly
+  to steps #3 and #4 shown before.
+
+- **Allocation and compound splitting**:
+
+  A pool that needs memory calls ``dma_pmd_add_page()`` to allocate a
+  physically contiguous 2MB page on the calling CPU's NUMA node, and
+  ``split_page_compound()`` to split it into independent blocks of
+  ``pool->order``. These blocks can be independently passed through the
+  networking stack.
+
+Modified kernel APIs and runtime controls
+=========================================
+
+DMA_PMD integrates transparently into existing kernel memory, DMA, and
+networking APIs. Allocation of DMA_PMD memory is opt-in via per-device sysfs
+attributes or sysctls, while mapping, unmapping, and freeing automatically
+detect whether a buffer or IOVA belongs to DMA_PMD:
+
+1. **Streaming DMA map and unmap** (``dma_map_page_attrs()``,
+   ``dma_map_single_attrs()``, ``dma_map_sg_attrs()`` and
+   ``dma_unmap_page_attrs()``, ``dma_unmap_single_attrs()``,
+   ``dma_unmap_sg_attrs()`` via ``drivers/iommu/dma-iommu.c`` and
+   ``kernel/dma/direct.c``):
+
+   - On map, any buffer belonging to a DMA_PMD page (``dma_is_pmd_phys(phys)``)
+     is mapped via the domain's reserved ``DMA_PMD`` IOVA window with a simple
+     addition, typically reusing existing mappings.
+     Under ``dma-direct``, decrypted or pinned ``DMA_PMD`` pages
+     (``dma_is_pmd_direct(phys)``) can be mapped directly without ``swiotlb`` bounce.
+
+     On unmap, IOVAs can be identified as DMA_PMD buffers with a simple range check
+     and that results in a no-operation.
+
+2. **Coherent DMA allocation and free** (``dma_alloc_attrs()`` /
+   ``dma_alloc_coherent()`` and ``dma_free_attrs()`` / ``dma_free_coherent()``
+   in ``kernel/dma/mapping.c``):
+
+   - DMA_PMD is enabled per device via ``/sys/devices/.../dma_pmd_rings``
+     (``dev->dma_pmd_rings``). When set, sleepable ``GFP_KERNEL`` coherent
+     allocations are rounded up to 4KB and carved out of DMA_PMD buffers
+     ``dma_pmd_arena`` and mapped accordingly.
+     ``dma_free_attrs()`` automatically detects arena IOVAs via
+     ``dma_pmd_free()`` and returns the sub-blocks to the arena.
+
+3. **Page allocator release** (``__free_pages()`` / ``put_page()`` via
+   ``__free_pages_prepare()`` in ``mm/page_alloc.c``):
+
+   - ``dma_pmd_free_page()`` checks
+     ``dma_is_pmd_page(page_to_pfn(page))`` and recycles DMA_PMD subpages back to
+     their owning ``dma_pmd_pool`` instead of releasing them to the buddy
+     allocator while their 2MB IOMMU mappings remain active.
+
+4. **IOMMU domain teardown** (``iommu_put_dma_cookie()`` in
+   ``drivers/iommu/dma-iommu.c``):
+
+   - A call to ``dma_pmd_domain_release()`` before freeing a
+     domain's IOVA cookie and page tables clears cached domain state across
+     all pools. Existing IOMMU mappings and IOTLB flush has already happened.
+
+5. **Networking ``page_pool``**
+
+   - DMA_PMD is enabled per device via ``/sys/devices/.../dma_pmd_rxbuf``
+     (``dev->dma_pmd_rxbuf``). Any NIC driver using ``page_pool`` with this
+     flag set will back its RX buffers with a per-``page_pool``
+     ``dma_pmd_pool``, and opportunistically replaces plain 4KB pages when pooled 2MB
+     blocks are available.
+
+6. **Socket TX page fragments** (``skb_page_frag_refill()`` in
+   ``net/core/sock.c``):
+
+   - When enabled globally via the ``net.core.tx_enable_dma_pmd`` sysctl
+     socket TX fragments are allocated from per-CPU ``dma_pmd_pool`` instances.
+
+7. **NIC driver RX pools and TX header bounce buffers**
+
+   - **RX buffers:** Controlled per device by ``/sys/devices/.../dma_pmd_rxbuf``
+     (``dev->dma_pmd_rxbuf``) for queue modes managing their own page rings
+     (``idpf``, ``gve`` GQI-RDA, ``gq``).
+   - **TX headers:** Controlled per device by
+     ``/sys/devices/.../dma_pmd_tx_hdrs`` (``dev->dma_pmd_tx_hdrs``),
+     copying linear packet headers into pre-allocated coherent bounce buffers
+     (backed by ``dma_pmd_arena`` when ``dma_pmd_rings`` is also enabled).
+
+8. **Global pool limit and observability:**
+
+   - ``/sys/module/kernel/parameters/dma_pmd_max_pages``: Global cap on 2MB
+     pages held across all pools (defaults to 1/8th of physical RAM).
+   - ``/sys/kernel/debug/dma_pmd/pools``: Debugfs summary of global and per-pool
+     allocation, mapping, and fallback counters.
diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
index 92f91c6a0d79d..49608d2b7509b 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -113,6 +113,7 @@ more memory-management documentation in Documentation/mm/index.rst.
    dma-attributes
    dma-isa-lpc
    swiotlb
+   dma-pmd
    mm-api
    cgroup
    genalloc
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 6e07bd69467a3..1bb347fd9da4a 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -158,6 +158,38 @@ config IOMMU_DMA
 	select NEED_SG_DMA_LENGTH
 	select NEED_SG_DMA_FLAGS if SWIOTLB
 
+# PMD_SIZE IOMMU backing for DMA-coherent devices
+config DMA_PMD
+	bool "PMD_SIZE IOMMU backing for DMA-coherent devices"
+	depends on IOMMU_DMA
+	depends on X86_64 || (ARM64 && ARM64_4K_PAGES)
+	depends on !PREEMPT_RT
+	default y
+	help
+	  Hand out DMA buffers carved out of PMD_SIZE physically contiguous
+	  blocks that the IOMMU maps with a single leaf PTE. Mapping,
+	  unmapping and IOTLB flushing are done lazily to reduce CPU overhead.
+	  The large mappings greatly reduce IOTLB usage. As in strict iommu
+	  mode, pages are returned to the buddy allocator only when any existing
+	  mappings have been removed and IOTLB flushed.
+	  Costs 128KB of metadata per GB of DMA_PMD buffers, allocated on demand.
+
+	  The config option enforces requirements (2MB PMD and !PREEMPT_RT) at compile
+	  time. Other constraints (e.g. dma-coherent devices) are verified at runtime.
+
+	  If unsure, say Y.
+
+config DMA_PMD_META_KUNIT_TEST
+	bool "KUnit test for DMA_PMD metadata table (built-in)" if !KUNIT_ALL_TESTS
+	depends on DMA_PMD && KUNIT=y
+	default KUNIT_ALL_TESTS
+	help
+	  Builds KUnit unit tests for the sparse, per-PMD-frame metadata table,
+	  PMD page pools, and coherent DMA arenas in drivers/iommu/dma-pmd*.c,
+	  verifying metadata lookup, pool recycling, and arena block allocation.
+
+	  If unsure, say N.
+
 # Shared Virtual Addressing
 config IOMMU_SVA
 	select IOMMU_MM_DATA
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 2f05725eaab18..2ad9b2eefd741 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -11,6 +11,8 @@ obj-$(CONFIG_IOMMU_API) += iommu-traces.o
 obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
 obj-$(CONFIG_IOMMU_DEBUGFS) += iommu-debugfs.o
 obj-$(CONFIG_IOMMU_DMA) += dma-iommu.o
+obj-$(CONFIG_DMA_PMD) += dma-pmd-meta.o
+obj-$(CONFIG_DMA_PMD_META_KUNIT_TEST) += dma-pmd-kunit.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE) += io-pgtable.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_ARMV7S) += io-pgtable-arm-v7s.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_LPAE) += io-pgtable-arm.o
diff --git a/drivers/iommu/dma-pmd-kunit.c b/drivers/iommu/dma-pmd-kunit.c
new file mode 100644
index 0000000000000..f80527eaf2e84
--- /dev/null
+++ b/drivers/iommu/dma-pmd-kunit.c
@@ -0,0 +1,102 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * KUnit tests for the opaque struct dma_pmd_meta table API.
+ */
+#include <kunit/test.h>
+#include <linux/gfp.h>
+#include <linux/dma-pmd.h>
+#include <linux/mm.h>
+
+#include "dma-pmd-priv.h"
+
+static void test_meta_init_and_roundtrip(struct kunit *test)
+{
+	struct dma_pmd_meta *m_pfn, *m_phys;
+	unsigned long pfn, base_pfn;
+	phys_addr_t pa, base_pa;
+	struct page *page;
+
+	KUNIT_ASSERT_EQ(test, dma_pmd_meta_init(), 0);
+	/* Second call must be idempotent. */
+	KUNIT_ASSERT_EQ(test, dma_pmd_meta_init(), 0);
+
+	page = alloc_page(GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+
+	pfn = page_to_pfn(page);
+	base_pfn = ALIGN_DOWN(pfn, 1UL << PMD_ORDER);
+	pa = page_to_phys(page);
+	base_pa = ALIGN_DOWN(pa, PMD_SIZE);
+
+	m_pfn = dma_pmd_meta_of_pfn(pfn);
+	m_phys = dma_pmd_meta_from_phys(pa);
+
+	KUNIT_EXPECT_PTR_EQ(test, m_pfn, m_phys);
+	KUNIT_EXPECT_EQ(test, dma_pmd_meta_to_pfn(m_pfn), base_pfn);
+	KUNIT_EXPECT_EQ(test, dma_pmd_meta_to_phys(m_phys), base_pa);
+
+	__free_page(page);
+}
+
+static void test_meta_invalid_phys(struct kunit *test)
+{
+	struct dma_pmd_meta *m;
+
+	KUNIT_ASSERT_EQ(test, dma_pmd_meta_init(), 0);
+
+	m = dma_pmd_meta_from_phys(PHYS_ADDR_MAX);
+	KUNIT_ASSERT_NOT_NULL(test, m);
+	KUNIT_EXPECT_EQ(test, dma_pmd_meta_to_phys(m), PHYS_ADDR_MAX);
+	KUNIT_EXPECT_FALSE(test, dma_is_pmd_page(ULONG_MAX >> PAGE_SHIFT));
+}
+
+static void dma_pmd_meta_set_pooled(struct dma_pmd_meta *m, bool pooled)
+{
+	WRITE_ONCE(m->pooled, pooled);
+}
+
+static void test_meta_pooled_toggle(struct kunit *test)
+{
+	unsigned long pfn, base_pfn;
+	struct dma_pmd_meta *m;
+	struct page *page;
+
+	KUNIT_ASSERT_EQ(test, dma_pmd_meta_init(), 0);
+
+	page = alloc_pages(GFP_KERNEL, PMD_ORDER);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+
+	pfn = page_to_pfn(page);
+	base_pfn = ALIGN_DOWN(pfn, 1UL << PMD_ORDER);
+	/* The buddy allocator returns naturally aligned blocks. */
+	KUNIT_EXPECT_EQ(test, pfn, base_pfn);
+	m = dma_pmd_meta_of_pfn(pfn);
+
+	KUNIT_EXPECT_FALSE(test, dma_is_pmd_page(pfn));
+
+	dma_pmd_meta_set_pooled(m, true);
+	KUNIT_EXPECT_TRUE(test, dma_is_pmd_page(base_pfn));
+	KUNIT_EXPECT_TRUE(test, dma_is_pmd_page(pfn));
+	KUNIT_EXPECT_TRUE(test, dma_is_pmd_page(base_pfn + (1UL << PMD_ORDER) - 1));
+
+	dma_pmd_meta_set_pooled(m, false);
+	KUNIT_EXPECT_FALSE(test, dma_is_pmd_page(pfn));
+
+	__free_pages(page, PMD_ORDER);
+}
+
+static struct kunit_case dma_pmd_meta_test_cases[] = {
+	KUNIT_CASE(test_meta_init_and_roundtrip),
+	KUNIT_CASE(test_meta_invalid_phys),
+	KUNIT_CASE(test_meta_pooled_toggle),
+	{}
+};
+
+static struct kunit_suite dma_pmd_meta_test_suite = {
+	.name = "dma_pmd_meta",
+	.test_cases = dma_pmd_meta_test_cases,
+};
+
+kunit_test_suite(dma_pmd_meta_test_suite);
+MODULE_DESCRIPTION("KUnit tests for struct dma_pmd_meta table");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/iommu/dma-pmd-meta.c b/drivers/iommu/dma-pmd-meta.c
new file mode 100644
index 0000000000000..fcaf5b121e66a
--- /dev/null
+++ b/drivers/iommu/dma-pmd-meta.c
@@ -0,0 +1,365 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * DMA_PMD sparse per-PMD-frame metadata table.
+ *
+ * See Documentation/core-api/dma-pmd.rst for the architecture overview.
+ */
+
+#include <linux/bitmap.h>
+#include <linux/cache.h>
+#include <linux/cacheflush.h>
+#include <linux/dma-pmd.h>
+#include <linux/export.h>
+#include <linux/gfp.h>
+#include <linux/ioport.h>
+#include <linux/list.h>
+#include <linux/memblock.h>
+#include <linux/mm.h>
+#include <linux/mutex.h>
+#include <linux/pgtable.h>
+#include <linux/spinlock.h>
+#include <linux/vmalloc.h>
+
+#include "dma-pmd-priv.h"
+
+/*
+ * Each PAGE_SIZE (4KB) metadata page holds (PAGE_SIZE >> DMA_PMD_META_SHIFT)
+ * struct dma_pmd_meta entries (32 entries of 128B, or 16 entries of 256B with
+ * spinlock debugging), each covering one PMD_SIZE (2MB) physical frame.
+ * One metadata page therefore covers a chunk of DMA_PMD_CHUNK_PAGES 4KB pages
+ * (64MB normally, or 32MB with spinlock debugging), i.e. order
+ * DMA_PMD_CHUNK_ORDER.
+ */
+#define DMA_PMD_CHUNK_ORDER		(PMD_ORDER + PAGE_SHIFT - DMA_PMD_META_SHIFT)
+#define DMA_PMD_CHUNK_PAGES		BIT(DMA_PMD_CHUNK_ORDER)
+
+static_assert(PAGE_SIZE >= DMA_PMD_META_SIZE);
+static_assert(PMD_SIZE == SZ_2M);
+static_assert(PMD_ORDER <= MAX_PAGE_ORDER);
+static_assert(PMD_SHIFT <= SUBSECTION_SHIFT);
+
+void *dma_pmd_meta_array __read_mostly;
+EXPORT_SYMBOL(dma_pmd_meta_array);
+unsigned long dma_pmd_meta_nframes __read_mostly;
+static unsigned long *dma_pmd_chunk_bitmap __read_mostly;
+
+static struct dma_pmd_meta dma_pmd_meta_nil;
+
+static unsigned long dma_pmd_meta_pages;
+static DEFINE_MUTEX(dma_pmd_meta_mutex);
+
+static __always_inline struct dma_pmd_meta *__dma_pmd_meta_of_pfn(unsigned long pfn)
+{
+	struct dma_pmd_meta *array = dma_pmd_meta_base();
+	unsigned long frame = pfn >> PMD_ORDER;
+
+	if (unlikely(!array || frame >= dma_pmd_meta_nframes ||
+		     !test_bit_acquire(pfn >> DMA_PMD_CHUNK_ORDER, dma_pmd_chunk_bitmap)))
+		return &dma_pmd_meta_nil;
+
+	return &array[frame];
+}
+
+bool __dma_is_pmd_page(unsigned long pfn)
+{
+	return READ_ONCE(__dma_pmd_meta_of_pfn(pfn)->pooled);
+}
+EXPORT_SYMBOL(__dma_is_pmd_page);
+
+/**
+ * dma_pmd_meta_of_pfn - Metadata for a PFN known to be used by DMA_PMD.
+ * @pfn: PFN the caller already holds a struct page for
+ */
+struct dma_pmd_meta *dma_pmd_meta_of_pfn(unsigned long pfn)
+{
+	return __dma_pmd_meta_of_pfn(pfn);
+}
+EXPORT_SYMBOL(dma_pmd_meta_of_pfn);
+
+/**
+ * dma_pmd_meta_from_phys - Metadata for the PMD frame containing @pa
+ * @pa: Any physical address
+ *
+ * Safe against MMIO above max_pfn and PFNs inside physical holes: those
+ * resolve to the shared sink entry.
+ *
+ * Return: Pointer to metadata entry (never NULL).
+ */
+struct dma_pmd_meta *dma_pmd_meta_from_phys(phys_addr_t pa)
+{
+	return __dma_pmd_meta_of_pfn(PHYS_PFN(pa));
+}
+EXPORT_SYMBOL(dma_pmd_meta_from_phys);
+
+/**
+ * dma_pmd_meta_to_pfn - Base PFN of @m's PMD frame
+ * @m: Entry in @dma_pmd_meta_array
+ *
+ * Return: PMD-aligned base PFN, or ULONG_MAX for the sink.
+ */
+unsigned long dma_pmd_meta_to_pfn(const struct dma_pmd_meta *m)
+{
+	if (unlikely(m == &dma_pmd_meta_nil))
+		return ULONG_MAX;
+
+	return (unsigned long)(m - dma_pmd_meta_base()) << PMD_ORDER;
+}
+EXPORT_SYMBOL(dma_pmd_meta_to_pfn);
+
+/**
+ * dma_pmd_meta_to_phys - Base physical address of @m's PMD frame
+ * @m: Entry returned by dma_pmd_meta_of_pfn() or dma_pmd_meta_from_phys()
+ *
+ * Return: PMD-aligned physical address, or PHYS_ADDR_MAX for the sink.
+ */
+phys_addr_t dma_pmd_meta_to_phys(const struct dma_pmd_meta *m)
+{
+	if (unlikely(m == &dma_pmd_meta_nil))
+		return PHYS_ADDR_MAX;
+
+	return (phys_addr_t)(m - dma_pmd_meta_base()) << PMD_SHIFT;
+}
+EXPORT_SYMBOL(dma_pmd_meta_to_phys);
+
+/*
+ * Install one preallocated page. The page is allocated by the caller rather
+ * than here because apply_to_page_range() runs this callback under lazy-MMU
+ * mode with the pte level pinned, which is not a context to allocate from.
+ *
+ * @data points at the caller's page pointer and is cleared once the page has
+ * been consumed, so the caller can free it if it was not needed.
+ */
+static int dma_pmd_meta_set_pte(pte_t *ptep, unsigned long addr, void *data)
+{
+	struct page **pagep = data;
+	pte_t pte;
+
+	if (!pte_none(ptep_get(ptep)))
+		return 0;
+
+	pte = pfn_pte(page_to_pfn(*pagep), PAGE_KERNEL);
+
+	spin_lock(&init_mm.page_table_lock);
+	if (likely(pte_none(ptep_get(ptep)))) {
+		set_pte_at(&init_mm, addr, ptep, pte);
+		*pagep = NULL;
+	}
+	spin_unlock(&init_mm.page_table_lock);
+
+	return 0;
+}
+
+/* True iff @pfn is backed by online system RAM (excludes holes and ZONE_DEVICE). */
+static inline bool dma_pmd_pfn_online(unsigned long pfn)
+{
+	struct mem_section *ms;
+
+	if (unlikely(!pfn_valid(pfn)))
+		return false;
+
+	ms = __pfn_to_section(pfn);
+	if (unlikely(!online_section(ms)))
+		return false;
+
+	if (unlikely(online_device_section(ms) && is_zone_device_page(pfn_to_page(pfn))))
+		return false;
+
+	return true;
+}
+
+/**
+ * dma_pmd_meta_populate - back the array for [@start_pfn, @end_pfn)
+ * @array: base virtual address of the reservation
+ * @nframes: number of valid PMD frames in the reservation
+ * @start_pfn: first PFN of the range
+ * @end_pfn: one past the last PFN of the range
+ * @force: if true, populate every chunk unconditionally (hotplug / arena)
+ *
+ * Maps and zeroes one page of the array per chunk of the range that contains
+ * at least one online RAM PFN (or unconditionally when @force is set), and
+ * skips chunks that are already mapped. A chunk
+ * is DMA_PMD_CHUNK_PAGES of physical address space: 64MB normally, 32MB when
+ * spinlock debugging doubles the entry size.
+ * Locking: caller must hold @dma_pmd_meta_mutex.
+ *
+ * Return: 0, or -ENOMEM with the range partially backed.
+ */
+static int dma_pmd_meta_populate(struct dma_pmd_meta *array, unsigned long nframes,
+				 unsigned long start_pfn, unsigned long end_pfn, bool force)
+{
+	unsigned long chunk, last, pfn;
+
+	lockdep_assert_held(&dma_pmd_meta_mutex);
+
+	end_pfn = min(end_pfn, nframes << PMD_ORDER);
+	if (start_pfn >= end_pfn)
+		return 0;
+
+	chunk = start_pfn >> DMA_PMD_CHUNK_ORDER;
+	last = (end_pfn - 1) >> DMA_PMD_CHUNK_ORDER;
+
+	for (; chunk <= last; chunk++) {
+		unsigned long addr, base = chunk << DMA_PMD_CHUNK_ORDER;
+		int ret, nid = NUMA_NO_NODE;
+		bool has_valid = false;
+		struct page *page;
+
+		addr = (unsigned long)array + (chunk << PAGE_SHIFT);
+		if (vmalloc_to_page((void *)addr)) {
+			set_bit(chunk, dma_pmd_chunk_bitmap);
+			continue;		/* already backed */
+		}
+
+		if (force) {
+			has_valid = true;
+		} else {
+			for (pfn = base; pfn < base + DMA_PMD_CHUNK_PAGES;
+			     pfn += 1UL << PMD_ORDER) {
+				if (dma_pmd_pfn_online(pfn)) {
+					has_valid = true;
+					nid = page_to_nid(pfn_to_page(pfn));
+					if (nid != NUMA_NO_NODE && node_online(nid))
+						break;
+					nid = NUMA_NO_NODE;
+				}
+			}
+		}
+		if (!has_valid)
+			continue;	/* pure hole, leave it unmapped */
+
+		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_ZERO, 0);
+		if (!page)
+			return -ENOMEM;
+
+		ret = apply_to_page_range(&init_mm, addr, PAGE_SIZE,
+					  dma_pmd_meta_set_pte, &page);
+		if (ret) {
+			__free_page(page);
+			return ret;
+		}
+		if (page) {
+			/*
+			 * Unreachable while dma_pmd_meta_mutex serialises
+			 * every install, but kept so that the defensive
+			 * pte_none() re-test in dma_pmd_meta_set_pte() can
+			 * never leak the page it declined to consume.
+			 */
+			__free_page(page);
+			set_bit(chunk, dma_pmd_chunk_bitmap);
+			continue;
+		}
+
+		flush_cache_vmap(addr, addr + PAGE_SIZE);
+		/* Pair with test_bit_acquire() in readers. */
+		smp_mb__before_atomic();
+		set_bit(chunk, dma_pmd_chunk_bitmap);
+		dma_pmd_meta_pages++;
+	}
+
+	return 0;
+}
+
+bool dma_pmd_meta_ensure_pfn(unsigned long pfn, bool can_block)
+{
+	int ret;
+
+	if (likely(__dma_pmd_meta_of_pfn(pfn) != &dma_pmd_meta_nil))
+		return true;
+
+	if (!can_block || !dma_pmd_meta_base() ||
+	    (pfn >> PMD_ORDER) >= dma_pmd_meta_nframes)
+		return false;
+
+	mutex_lock(&dma_pmd_meta_mutex);
+	ret = dma_pmd_meta_populate(dma_pmd_meta_base(), dma_pmd_meta_nframes,
+				    pfn, pfn + (1UL << PMD_ORDER), true);
+	mutex_unlock(&dma_pmd_meta_mutex);
+
+	return !ret;
+}
+EXPORT_SYMBOL(dma_pmd_meta_ensure_pfn);
+
+/**
+ * dma_pmd_meta_init - Reserve and populate the sparse per-PMD metadata array
+ *
+ * Populates all present RAM pages before publishing @dma_pmd_meta_array so
+ * no concurrent reader ever sees an unmapped entry.
+ *
+ * Return: 0 on success, or negative errno on failure.
+ */
+int dma_pmd_meta_init(void)
+{
+	unsigned long nframes, nchunks, size;
+	struct dma_pmd_meta *array;
+	struct vm_struct *vm;
+	int ret = 0;
+
+	if (likely(dma_pmd_meta_base()))
+		return 0;
+
+	mutex_lock(&dma_pmd_meta_mutex);
+	if (dma_pmd_meta_array)
+		goto out_unlock;
+
+	nframes = DIV_ROUND_UP(max3((unsigned long)max_pfn,
+				    (unsigned long)max_possible_pfn,
+				    (unsigned long)min_t(u64, iomem_resource.end >> PAGE_SHIFT,
+							 1ULL << (MAX_PHYSMEM_BITS - PAGE_SHIFT))),
+			       1UL << PMD_ORDER);
+	size = PAGE_ALIGN(nframes << DMA_PMD_META_SHIFT);
+	nchunks = size >> PAGE_SHIFT;
+
+	dma_pmd_chunk_bitmap = bitmap_zalloc(nchunks, GFP_KERNEL);
+	if (!dma_pmd_chunk_bitmap) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	vm = get_vm_area(size, VM_MAP);
+	if (!vm) {
+		bitmap_free(dma_pmd_chunk_bitmap);
+		dma_pmd_chunk_bitmap = NULL;
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+	array = vm->addr;
+
+	ret = dma_pmd_meta_populate(array, nframes, 0, max_pfn, false);
+	if (ret) {
+		struct page *p, *next;
+		unsigned long chunk;
+		LIST_HEAD(pages);
+
+		for_each_set_bit(chunk, dma_pmd_chunk_bitmap, nchunks) {
+			p = vmalloc_to_page((void *)array + (chunk << PAGE_SHIFT));
+			if (p)
+				list_add(&p->lru, &pages);
+		}
+		dma_pmd_meta_pages = 0;
+		free_vm_area(vm);
+		bitmap_free(dma_pmd_chunk_bitmap);
+		dma_pmd_chunk_bitmap = NULL;
+		list_for_each_entry_safe(p, next, &pages, lru) {
+			list_del_init(&p->lru);
+			__free_page(p);
+		}
+		goto out_unlock;
+	}
+
+	/*
+	 * Publish @nframes and the populated pages before the array pointer:
+	 * readers pair with smp_load_acquire(&dma_pmd_meta_array).
+	 */
+	dma_pmd_meta_nframes = nframes;
+	/* Pairs with smp_load_acquire() in dma_is_pmd_page(). */
+	smp_store_release(&dma_pmd_meta_array, array);
+
+	pr_info("dma_pmd: %lu frames, %lu KB of KVA, %lu pages backed (%lu KB)\n",
+		nframes, size / 1024, dma_pmd_meta_pages,
+		dma_pmd_meta_pages * (PAGE_SIZE / 1024));
+
+out_unlock:
+	mutex_unlock(&dma_pmd_meta_mutex);
+	return ret;
+}
+EXPORT_SYMBOL(dma_pmd_meta_init);
diff --git a/drivers/iommu/dma-pmd-priv.h b/drivers/iommu/dma-pmd-priv.h
new file mode 100644
index 0000000000000..a5ebede11dac2
--- /dev/null
+++ b/drivers/iommu/dma-pmd-priv.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+#ifndef _DRIVERS_IOMMU_DMA_PMD_PRIV_H
+#define _DRIVERS_IOMMU_DMA_PMD_PRIV_H
+
+#include <linux/dma-pmd.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_DMA_PMD
+
+/*
+ * Normally 128 B per entry (64 KB per GB of RAM), or 256 B when spinlock
+ * debugging enlarges struct dma_pmd_meta. Verified by static_assert().
+ */
+#if defined(CONFIG_DEBUG_SPINLOCK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
+#define DMA_PMD_META_SHIFT		8
+#else
+#define DMA_PMD_META_SHIFT		7
+#endif
+#define DMA_PMD_META_SIZE		BIT(DMA_PMD_META_SHIFT)
+
+/**
+ * struct dma_pmd_meta - Metadata for a single DMA_PMD page
+ * @pooled: True while this page is owned by an dma_pmd_pool (at offset 0)
+ *
+ * Lives in the sparse per-PMD-frame array @dma_pmd_meta_array indexed by
+ * (pfn >> PMD_ORDER). Only chunks covering valid RAM are backed by physical
+ * pages (64 KB per GB of RAM).
+ */
+struct dma_pmd_meta {
+	bool pooled;
+} __aligned(DMA_PMD_META_SIZE);
+
+static_assert(offsetof(struct dma_pmd_meta, pooled) == 0);
+static_assert(sizeof(struct dma_pmd_meta) == DMA_PMD_META_SIZE);
+
+extern unsigned long dma_pmd_meta_nframes;
+
+static inline struct dma_pmd_meta *dma_pmd_meta_base(void)
+{
+	/*
+	 * Acquire pairs with smp_store_release() in dma_pmd_meta_init():
+	 * orders both @dma_pmd_meta_nframes and the populated backing pages.
+	 */
+	return smp_load_acquire(&dma_pmd_meta_array);
+}
+
+int dma_pmd_meta_init(void);
+bool dma_pmd_meta_ensure_pfn(unsigned long pfn, bool can_block);
+struct dma_pmd_meta *dma_pmd_meta_of_pfn(unsigned long pfn);
+struct dma_pmd_meta *dma_pmd_meta_from_phys(phys_addr_t pa);
+unsigned long dma_pmd_meta_to_pfn(const struct dma_pmd_meta *m);
+phys_addr_t dma_pmd_meta_to_phys(const struct dma_pmd_meta *m);
+
+#endif /* CONFIG_DMA_PMD */
+#endif /* _DRIVERS_IOMMU_DMA_PMD_PRIV_H */
diff --git a/include/linux/dma-pmd.h b/include/linux/dma-pmd.h
new file mode 100644
index 0000000000000..07df815945257
--- /dev/null
+++ b/include/linux/dma-pmd.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* See Documentation/core-api/dma-pmd.rst for the architecture overview. */
+#ifndef _LINUX_DMA_PMD_H
+#define _LINUX_DMA_PMD_H
+
+#include <linux/compiler.h>
+#include <linux/mm_types.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_DMA_PMD
+
+extern void *dma_pmd_meta_array;
+
+bool __dma_is_pmd_page(unsigned long pfn);
+
+static inline bool dma_is_pmd_page(unsigned long pfn)
+{
+	/*
+	 * Acquire pairs with smp_store_release() in dma_pmd_meta_init():
+	 * orders both @dma_pmd_meta_nframes and the populated backing pages.
+	 */
+	if (likely(!smp_load_acquire(&dma_pmd_meta_array)))
+		return false;
+
+	return __dma_is_pmd_page(pfn);
+}
+
+#else /* !CONFIG_DMA_PMD */
+
+static inline bool dma_is_pmd_page(unsigned long pfn)
+{
+	return false;
+}
+
+#endif /* CONFIG_DMA_PMD */
+#endif /* _LINUX_DMA_PMD_H */
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


