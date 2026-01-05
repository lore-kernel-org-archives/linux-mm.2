Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF83CC2A07D
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 09:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9ED6B010C; Mon,  5 Jan 2026 04:27:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA3D96B010D; Mon,  5 Jan 2026 04:27:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85536B010E; Mon,  5 Jan 2026 04:27:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE0A56B010C
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 04:27:31 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50B2A1AB50A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:27:31 +0000 (UTC)
X-FDA: 84297382302.01.3860407
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 922B820002
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:27:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GxOelxmg;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767605249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZLtI/Ua7WhKfG+jYiPvSBUgYmqUrNQHQfpEETLDjgU=;
	b=zD/jp4WkgJTAkDtyNzdHGBM6DVNNgCk9sJgeUYcsTRlT2vX6Kh6gUEc3z31aa2lrI+enMW
	vzrbGttRlz1/7/Zn+wbDFjnVyk72TACtAfMYbQUa8Sj4VEmhKbfceVZjKiNzZunxgs+mFv
	Fp7+vgOTAIDDXZPUqScOrX/eNNSxdn0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GxOelxmg;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767605249; a=rsa-sha256;
	cv=none;
	b=Jhrk/naw4hFOrkD592qTr45MirMbf4LMqI8IhkbpNlGYEwV+0VHZzCOowqeOl9OKayGfbm
	F1MpkXi6K9Bh8fTFnoTU4wRy45H25H2d4PUOIwOGG0tJAcA2dh6oL5w1RISfJAs9n5Vz8U
	7Vaw1akQ8a9bF5JAVX9wXkDbY8z31C4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 57BBC43462;
	Mon,  5 Jan 2026 09:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE59C19423;
	Mon,  5 Jan 2026 09:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767605248;
	bh=MmqtxsIjXAvoU3CBUmxyIo1z0ZVku3Jn6aCyAWnsOfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GxOelxmgyHfcJTZBPbs3eDBMzsYbngUaEf9VBOpPmFPq8xW4V/ms6Df6xdzZHAHjW
	 cjGMgu8412Nk709k65aDYSK6o/zASYjj0Nkb2/hb0yrrAv2FgVdX5djxGyqVRmlG7l
	 3gAb/3vVRwL3h6Nuawkt9mvK+UQ5Aw82kQzp95RtTjDH4nT9AzGKGKHexb0Vc45T7K
	 KwBNsMyx+xFIdywWHlSDcNQxx910JosNkxxvOdTR9Kcuih4zYRRMhI/X0QCFDDsbLW
	 i7gRJM2rCOYSdwBOckHm9NdOtSNH/9/l4kvmPPYPNnbRCGW9/3RDvdfKmKJPbRODWS
	 A8YKivMD3DIOw==
Date: Mon, 5 Jan 2026 11:27:20 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Jason Miu <jasonmiu@google.com>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 3/4] kho: Adopt radix tree for preserved memory
 tracking
Message-ID: <aVuD-PeGIRnr8jZh@kernel.org>
References: <20251209025317.3846938-1-jasonmiu@google.com>
 <20251209025317.3846938-4-jasonmiu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251209025317.3846938-4-jasonmiu@google.com>
X-Stat-Signature: juk8q9ph6bidup9sgaimyojd61no5kxt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 922B820002
X-HE-Tag: 1767605249-989550
X-HE-Meta: U2FsdGVkX19iE/s3WoAMOfGuqJHkvHvx5GNVM8KGWj5c/Jvygo5gc6EIbjvdjf1CxqZ5tT99uxoIu3/P0NpvQSzOL/9+QJbu8vLPG5PF/tAIeexGJHrFwUG4RNATeylIiVTV1fIGJKsOSiwkMG9ZWJK1y6hiqYizI0JwciZ7C/N0zdPTEdtlTSnjyxtLO5jMA0NVHjU5AwQA5k1v7Bv9rRBhki1MIzRdvJW2ajhGX3B2pVhfw9YBOuPKEVADuNg+8aSAhH8dnrro88y01xatk5WUpURPvua55kmjDfDkcLZqbc+u8elbBHf971ScP6HqgQVVKzLiMg1G1pofa3e5FZZuWH+I+2GXl/ZFTm7vtvCWRMl7AC382M2tgTT0Kp3UTPu0z6WfAI8B5j5ChqGhJq3J2azX8ll1pXpLn6NUVsYjJcafKnPWlg5ymedaIMwW0ww0decXo78qqvfqQI0G3IHGhrld50FqdpoJA/ZMft9ozht8vCQzfKNDSZN+z6notgPQyLiVBw2H6KjgVIK41KLccZIJSexWhX5kirCDDi961p1AkmqhVwTNdsF1c1fgPTxU0rYuB7R1lQohyr7H8tCgoE/R4KiCrNx0CDxQDvL89fzOGgpUjafrr0Arghr7dZqPHqw0rW7Tx0sf4vU+rdpHI9FP9OWWQ7xcAw8kpTTZhidaW1hRsgFT6jRNUCv+h9HKacLIlrToI9obsVdOOJ5IwdEuAPutNxel9P2fYdDtQsFaPeapJpwy0UCI4yWszvDQbNT4qXnMCCd9bIpDWif6RiiTLYEbPDgGbil/fdgfVJeH/ipu18nhA+SaNYPr+6hCy/G1Xzy2aIYlC4MpXwYuyt2W6eh2umx2p2AJSUF8XJdEsm/4glpC2372yP2/CF4ffteT1fYoWPT1Rz/GmVP/ewDkCEXL76VuLDi5nqhMqDIfwPg/tO3imRl9iXJLUL5SMNiBFrua5ZGiLUV
 kyYmgxTc
 huKRhY2zJz2dtD/3aNzLqyThkZZsBm+Fn2Bmjk1hhp/yqlNs7IvpssEEZucwgDRjZ8GAsQWGp2RfdkuP2rMJC7ZzEI+BZo1JlnvfSS8sgvzBQxyhelDNNYAPRmhxnLJbky3VKUfYmDD7WbzPO6kWQeQ1/v03ukUTuT0uoVYPMHurn/8iWfBRwL5NrKNHTyGB8PHvsGORIEWb0gmMBFYbBu40ZMqe6BTkHNx/XWNcYCiU5y/V5/EPh3yRsWnZ7Qh9NnhqzxkZu0YJfTTM7jIkvWWKl82azCGbX5HVk6bZd1NIkfVd/+Vac0axaYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025 at 06:53:15PM -0800, Jason Miu wrote:
> Introduce a radix tree implementation for tracking preserved memory pages
> and switch the KHO memory tracking mechanism to use it. This lays the
> groundwork for a stateless KHO implementation that eliminates the need for
> serialization and the associated "finalize" state.
> 
> This patch introduces the core radix tree data structures and constants to
> the KHO ABI. It adds the radix tree node and leaf structures, along with
> documentation for the radix tree key encoding scheme that combines a page's
> physical address and order.
> 
> To support broader use by other kernel subsystems, such as hugetlb
> preservation, the core radix tree manipulation functions are exported as
> a public API.
> 
> The xarray-based memory tracking is replaced with this new radix tree
> implementation. The core KHO preservation and unpreservation functions are
> wired up to use the radix tree helpers. On boot, the second kernel restores
> the preserved memory map by walking the radix tree whose root physical
> address is passed via the FDT.
> 
> The ABI `compatible` version is bumped to "kho-v2" to reflect the
> structural changes in the preserved memory map and sub-FDT property
> names.
> 
> Signed-off-by: Jason Miu <jasonmiu@google.com>
> ---
>  Documentation/core-api/kho/concepts.rst   |   2 +-
>  Documentation/core-api/kho/fdt.rst        |   7 +
>  Documentation/core-api/kho/index.rst      |   1 +
>  Documentation/core-api/kho/radix_tree.rst |  17 +
>  include/linux/kho/abi/kexec_handover.h    | 124 +++-
>  include/linux/kho_radix_tree.h            |  81 +++
>  kernel/liveupdate/kexec_handover.c        | 658 ++++++++++++----------
>  7 files changed, 568 insertions(+), 322 deletions(-)
>  create mode 100644 Documentation/core-api/kho/radix_tree.rst
>  create mode 100644 include/linux/kho_radix_tree.h
> 
> diff --git a/Documentation/core-api/kho/concepts.rst b/Documentation/core-api/kho/concepts.rst
> index e96893937286..d38bcaa951e4 100644
> --- a/Documentation/core-api/kho/concepts.rst
> +++ b/Documentation/core-api/kho/concepts.rst
> @@ -71,7 +71,7 @@ in the FDT. That state is called the KHO finalization phase.
>  Public API
>  ==========
>  .. kernel-doc:: kernel/liveupdate/kexec_handover.c
> -   :export:
> +   :identifiers: kho_is_enabled kho_restore_folio kho_restore_pages kho_add_subtree kho_remove_subtree kho_preserve_folio kho_unpreserve_folio kho_preserve_pages kho_unpreserve_pages kho_preserve_vmalloc kho_unpreserve_vmalloc kho_restore_vmalloc kho_alloc_preserve kho_unpreserve_free kho_restore_free is_kho_boot kho_retrieve_subtree

Ouch. This would be unmaintainable :(

>  
>  Internal API
>  ============

...

> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
> index 74f4fa67e458..bdda2fe67353 100644
> --- a/include/linux/kho/abi/kexec_handover.h
> +++ b/include/linux/kho/abi/kexec_handover.h
> @@ -10,6 +10,8 @@
>  #ifndef _LINUX_KHO_ABI_KEXEC_HANDOVER_H
>  #define _LINUX_KHO_ABI_KEXEC_HANDOVER_H
>  
> +#include <linux/bits.h>
> +#include <linux/log2.h>
>  #include <linux/types.h>
>  
>  /**
> @@ -35,25 +37,25 @@
>   *   parses this FDT to locate and restore the preserved data.::
>   *
>   *     / {
> - *         compatible = "kho-v1";
> + *         compatible = "kho-v2";
>   *
>   *         preserved-memory-map = <0x...>;
>   *
>   *         <subnode-name-1> {
> - *             fdt = <0x...>;
> + *             preserved-data = <0x...>;

Please extend the paragraph describing "compatible" change in the commit
message to mention that "preserved-data" is a better name than "fdt"
because some subsystems will not use fdt format for their preserved state.

>   *         };
>   *
>   *         <subnode-name-2> {
> - *             fdt = <0x...>;
> + *             preserved-data = <0x...>;
>   *         };
>   *               ... ...
>   *         <subnode-name-N> {
> - *             fdt = <0x...>;
> + *             preserved-data = <0x...>;
>   *         };
>   *     };
>   *
>   *   Root KHO Node (/):
> - *     - compatible: "kho-v1"
> + *     - compatible: "kho-v2"
>   *
>   *       Indentifies the overall KHO ABI version.
>   *
> @@ -68,20 +70,20 @@
>   *     is provided by the subsystem that uses KHO for preserving its
>   *     data.
>   *
> - *     - fdt: u64
> + *     - preserved-data: u64
>   *
> - *       Physical address pointing to a subnode FDT blob that is also
> + *       Physical address pointing to a subnode data blob that is also
>   *       being preserved.
>   */
>  
>  /* The compatible string for the KHO FDT root node. */
> -#define KHO_FDT_COMPATIBLE "kho-v1"
> +#define KHO_FDT_COMPATIBLE "kho-v2"
>  
>  /* The FDT property for the preserved memory map. */
>  #define KHO_FDT_MEMORY_MAP_PROP_NAME "preserved-memory-map"
>  
>  /* The FDT property for sub-FDTs. */
> -#define KHO_FDT_SUB_TREE_PROP_NAME "fdt"
> +#define KHO_FDT_SUB_TREE_PROP_NAME "preserved-data"
>  
>  /**
>   * DOC: Kexec Handover ABI for vmalloc Preservation
> @@ -159,4 +161,108 @@ struct kho_vmalloc {
>  	unsigned short order;
>  };
>  
> +/**
> + * DOC: Keep track of memory that is to be preserved across KHO.

Maybe "KHO persistent memory tracker"?

> + *
> + * KHO tracks preserved memory using a radix tree data structure. Each node of
> + * the tree is PAGE_SIZE. The leaf nodes are bitmaps where each set bit

Maybe "Each node of the tree is exactly a single page"?

> + * represents a single preserved page. The intermediate nodes are tables of

And here "a single preserved page" reads to me like a single order-0 page.
I think we should note that each bit can represent pages of different
orders.

> + * physical addresses that point to a lower level node.
> + *
> + * The tree hierarchy is shown below::
> + *
> + *   root
> + *   +-------------------+
> + *   |     Level 5       | (struct kho_radix_node)
> + *   +-------------------+
> + *     |
> + *     v
> + *   +-------------------+
> + *   |     Level 4       | (struct kho_radix_node)
> + *   +-------------------+
> + *     |
> + *     | ... (intermediate levels)
> + *     |
> + *     v
> + *   +-------------------+
> + *   |      Level 0      | (struct kho_radix_leaf)
> + *   +-------------------+
> + *
> + * This is achieved by encoding the page's physical address (pa) and its order

It's not really clear what "this is achieved" refers to.

> + * into a single unsigned long value. This value is a key then used to traverse

                                         This value is then used as a key to ...

> + * the tree. The encoded key value is composed of two parts: the 'order bit' in
> + * the upper part and the 'page offset' in the lower part.::
> + *
> + *   +------------+-----------------------------+--------------------------+
> + *   | Page Order | Order Bit                   | Page Offset              |
> + *   +------------+-----------------------------+--------------------------+
> + *   | 0          | ...000100 ... (at bit 52)   | pa >> (PAGE_SHIFT + 0)   |
> + *   | 1          | ...000010 ... (at bit 51)   | pa >> (PAGE_SHIFT + 1)   |
> + *   | 2          | ...000001 ... (at bit 50)   | pa >> (PAGE_SHIFT + 2)   |
> + *   | ...        | ...                         | ...                      |
> + *   +------------+-----------------------------+--------------------------+
> + *
> + * Page Offset:
> + * The 'page offset' is the physical address normalized for its order. It
> + * effectively represents the page offset for the given order.
> + *
> + * Order Bit:
> + * The 'order bit' encodes the page order by setting a single bit at a
> + * specific position. The position of this bit itself represents the order.
> + *
> + * For instance, on a 64-bit system with 4KB pages (PAGE_SHIFT = 12), the
> + * maximum range for a page offset (for order 0) is 52 bits (64 - 12). This
> + * offset occupies bits [0-51]. For order 0, the order bit is set at
> + * position 52.
> + *
> + * The following diagram illustrates how the encoded key value is split into
> + * indices for the tree levels, with PAGE_SIZE of 4KB::
> + *
> + *        63:60   59:51    50:42    41:33    32:24    23:15         14:0
> + *   +---------+--------+--------+--------+--------+--------+-----------------+
> + *   |    0    |  Lv 5  |  Lv 4  |  Lv 3  |  Lv 2  |  Lv 1  |  Lv 0 (bitmap)  |
> + *   +---------+--------+--------+--------+--------+--------+-----------------+
> + *
> + * This design stores pages of all sizes (orders) in a single 6-level table.

s/This design/The radix tree/ and s/table/hierarchy/

> + * It efficiently shares lower table levels, especially due to common zero top
> + * address bits, allowing a single, efficient algorithm to manage all pages.
> + * This bitmap approach also offers memory efficiency; for example, a 512KB
> + * bitmap can cover a 16GB memory range for 0-order pages with PAGE_SIZE = 4KB.
> + *
> + * The data structures defined here are part of the KHO ABI. Any modification
> + * to these structures that breaks backward compatibility must be accompanied by
> + * an update to the "compatible" string. This ensures that a newer kernel can
> + * correctly interpret the data passed by an older kernel.
> + */
> +
> +/*
> + * Defines constants for the KHO radix tree structure, used to track preserved
> + * memory. These constants govern the indexing, sizing, and depth of the tree.
> + */
> +enum kho_radix_consts {
> +	/* The bit position of a 0-order page */

                 ^ this is either position of the order bits or length of
the "page offset" for an order-0 page

> +	KHO_ORDER_0_LG2 = 64 - PAGE_SHIFT,

I'd spell out LOG2 rather than LG2 here and below.

> +
> +	/* Size of the table in kho_mem_radix_tree, in lg2 */

We don't have kho_mem_radix_tree anymore, do we?

> +	KHO_TABLE_SIZE_LG2 = const_ilog2(PAGE_SIZE / sizeof(phys_addr_t)),
> +
> +	/* Number of bits in the kho_bitmap, in lg2 */
> +	KHO_BITMAP_SIZE_LG2 = PAGE_SHIFT + const_ilog2(BITS_PER_BYTE),
> +
> +	/*
> +	 * The total tree depth is the number of intermediate levels
> +	 * and 1 bitmap level.
> +	 */
> +	KHO_TREE_MAX_DEPTH = DIV_ROUND_UP(KHO_ORDER_0_LG2 - KHO_BITMAP_SIZE_LG2,
> +					  KHO_TABLE_SIZE_LG2) + 1,
> +};
> +
> +struct kho_radix_node {
> +	u64 table[1 << KHO_TABLE_SIZE_LG2];
> +};
> +
> +struct kho_radix_leaf {
> +	DECLARE_BITMAP(bitmap, 1 << KHO_BITMAP_SIZE_LG2);
> +};
> +
>  #endif	/* _LINUX_KHO_ABI_KEXEC_HANDOVER_H */
> diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
> new file mode 100644
> index 000000000000..5101a04f6ae6
> --- /dev/null
> +++ b/include/linux/kho_radix_tree.h
> @@ -0,0 +1,81 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _LIVEUPDATE_KEXEC_HANDOVER_RADIX_TREE_H
> +#define _LIVEUPDATE_KEXEC_HANDOVER_RADIX_TREE_H

Please use _LINUX_KHO_ABI prefix

> +
> +#include <linux/err.h>
> +#include <linux/errno.h>
> +#include <linux/types.h>
> +
> +/**
> + * DOC: Kexec Handover Radix Tree
> + *
> + * This is a radix tree implementation for tracking physical memory pages
> + * across kexec transitions. It was developed for the KHO mechanism but is
> + * designed for broader use by any subsystem that needs to preserve pages.
> + *
> + * The radix tree is a multi-level tree where leaf nodes are bitmaps
> + * representing individual pages. To allow pages of different sizes (orders)
> + * to be stored efficiently in a single tree, it uses a unique key encoding
> + * scheme. Each key is an unsigned long that combines a page's physical
> + * address and its order.
> + *
> + * Client code is responsible for allocating the root node of the tree and
> + * managing its lifecycle, and must use the tree data structures defined in
> + * the KHO ABI, `include/linux/kho/abi/kexec_handover.h`.
> + */
> +
> +struct kho_radix_node;
> +
> +typedef int (*kho_radix_tree_walk_callback_t)(unsigned long radix_key);

I don't think radix tree users outside kexec_handover.c should bother with
the key encoding.
The callback here should have physical address and order as parameters.

> +
> +#ifdef CONFIG_KEXEC_HANDOVER
> +
> +unsigned long kho_radix_encode_key(phys_addr_t pa, unsigned int order);
> +
> +phys_addr_t kho_radix_decode_key(unsigned long radix_key,
> +				 unsigned int *order);

These should not be a part of public interface.

> +int kho_radix_add_page(struct kho_radix_node *root, unsigned long pfn,
> +		       unsigned int order);
> +
> +void kho_radix_del_page(struct kho_radix_node *root, unsigned long pfn,
> +			unsigned int order);
> +
> +int kho_radix_walk_tree(struct kho_radix_node *root, unsigned int level,
> +			unsigned long start, kho_radix_tree_walk_callback_t cb);
> +

...

> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index a180b3367e8f..81bac82c8672 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -66,155 +68,302 @@ static int __init kho_parse_enable(char *p)
>  early_param("kho", kho_parse_enable);

...

>  struct kho_mem_track {
> -	/* Points to kho_mem_phys, each order gets its own bitmap tree */
> -	struct xarray orders;
> +	struct kho_radix_node *root;
> +	struct rw_semaphore sem;

It does not look like we have concurrent readers, why choose rw_semaphore
and not mutex?

>  };
>  
> -struct khoser_mem_chunk;
> -
>  struct kho_out {
> -	void *fdt;
> -	bool finalized;

The next patch removes finalization, probably removing the finalized field
should be done there.

> -	struct mutex lock; /* protects KHO FDT finalization */
> -
>  	struct kho_mem_track track;
> +	void *fdt;
> +	struct mutex lock; /* protects KHO FDT */

Please don't move the fields around.
And while the update of the comment is correct, it seems to me rather a
part of the next patch.

>  	struct kho_debugfs dbg;
>  };
>  
>  static struct kho_out kho_out = {
> -	.lock = __MUTEX_INITIALIZER(kho_out.lock),
>  	.track = {
> -		.orders = XARRAY_INIT(kho_out.track.orders, 0),
> +		.sem = __RWSEM_INITIALIZER(kho_out.track.sem),
>  	},
> -	.finalized = false,
> +	.lock = __MUTEX_INITIALIZER(kho_out.lock),

Please don't to move fields.

>  };
>  
> -static void *xa_load_or_alloc(struct xarray *xa, unsigned long index)
> +/**
> + * kho_radix_encode_key - Encodes a physical address and order into a radix key.
> + * @pa: The physical address of the page.
> + * @order: The order of the page.
> + *
> + * This function combines a page's physical address and its order into a
> + * single unsigned long, which is used as a key for all radix tree
> + * operations.
> + *
> + * Return: The encoded unsigned long key.
> + */
> +unsigned long kho_radix_encode_key(phys_addr_t pa, unsigned int order)
>  {
> -	void *res = xa_load(xa, index);
> +	/* Order bits part */
> +	unsigned long h = 1UL << (KHO_ORDER_0_LG2 - order);
> +	/* Page offset part */
> +	unsigned long l = pa >> (PAGE_SHIFT + order);
>  
> -	if (res)
> -		return res;
> +	return h | l;
> +}
> +EXPORT_SYMBOL_GPL(kho_radix_encode_key);
>  
> -	void *elm __free(free_page) = (void *)get_zeroed_page(GFP_KERNEL);
> +/**
> + * kho_radix_decode_key - Decodes a radix key back into a physical address and order.
> + * @radix_key: The unsigned long key to decode.
> + * @order: An output parameter, a pointer to an unsigned int where the decoded
> + *         page order will be stored.
> + *
> + * This function reverses the encoding performed by kho_radix_encode_key(),
> + * extracting the original physical address and page order from a given key.
> + *
> + * Return: The decoded physical address.
> + */
> +phys_addr_t kho_radix_decode_key(unsigned long radix_key,
> +				 unsigned int *order)
> +{
> +	unsigned int order_bit = fls64(radix_key);
> +	phys_addr_t pa;
>  
> -	if (!elm)
> -		return ERR_PTR(-ENOMEM);
> +	/* order_bit is numbered starting at 1 from fls64 */
> +	*order = KHO_ORDER_0_LG2 - order_bit + 1;
> +	/* The order is discarded by the shift */
> +	pa = radix_key << (PAGE_SHIFT + *order);
>  
> -	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), PAGE_SIZE)))
> -		return ERR_PTR(-EINVAL);
> +	return pa;
> +}
> +EXPORT_SYMBOL_GPL(kho_radix_decode_key);

Please make kho_radix_encode_key() and kho_radix_decode_key() static.

> +
> +static unsigned long kho_radix_get_index(unsigned long radix_key,
> +					 unsigned int level)
> +{
> +	int s;
>  
> -	res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
> -	if (xa_is_err(res))
> -		return ERR_PTR(xa_err(res));
> -	else if (res)
> -		return res;
> +	if (level == 0)
> +		return radix_key % (1 << KHO_BITMAP_SIZE_LG2);

I'd split this to 

static unsigned long kho_get_radix_bitmap_index(unsigned long key);

>  
> -	return no_free_ptr(elm);
> +	s = ((level - 1) * KHO_TABLE_SIZE_LG2) + KHO_BITMAP_SIZE_LG2;
> +	return (radix_key >> s) % (1 << KHO_TABLE_SIZE_LG2);
>  }
>  
> -static void __kho_unpreserve_order(struct kho_mem_track *track, unsigned long pfn,
> -				   unsigned int order)
> +/**
> + * kho_radix_add_page - Marks a page as preserved in the radix tree.
> + * @root: The root of the radix tree.
> + * @pfn: The page frame number of the page to preserve.
> + * @order: The order of the page.
> + *
> + * This function traverses the radix tree based on the key derived from @pfn
> + * and @order. It sets the corresponding bit in the leaf bitmap to mark the
> + * page for preservation. If intermediate nodes do not exist along the path,
> + * they are allocated and added to the tree.
> + *
> + * Return: 0 on success, or a negative error code on failure.
> + */
> +int kho_radix_add_page(struct kho_radix_node *root,
> +		       unsigned long pfn, unsigned int order)
>  {
> -	struct kho_mem_phys_bits *bits;
> -	struct kho_mem_phys *physxa;
> -	const unsigned long pfn_high = pfn >> order;
> +	phys_addr_t pa = PFN_PHYS(pfn);
> +	unsigned long radix_key = kho_radix_encode_key(pa, order);

pa seems unused elsewhere, you can just put PFN_PHYS() into
kho_radix_encode_key().
And radix_ prefix for the key seems redundant to me.

> +	struct kho_radix_node *node;
> +	struct kho_radix_leaf *leaf;
> +	unsigned int i, idx;
> +	int err = 0;
>  
> -	physxa = xa_load(&track->orders, order);
> -	if (WARN_ON_ONCE(!physxa))
> -		return;
> +	/*
> +	 * This array stores pointers to newly allocated intermediate radix tree
> +	 * nodes along the insertion path. In case of an error during node
> +	 * allocation or insertion, these stored pointers are used to free
> +	 * the partially allocated path, preventing memory leaks.
> +	 */
> +	struct kho_radix_node *intermediate_nodes[KHO_TREE_MAX_DEPTH] = { 0 };

Let's try keeping declarations in reverse xmas tree order. This long line
can be the first declaration.
And I don't think this array deserves such a long comment, it's quite
obvious why it's needed.

>  
> -	bits = xa_load(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
> -	if (WARN_ON_ONCE(!bits))
> -		return;
> +	might_sleep();
>  
> -	clear_bit(pfn_high % PRESERVE_BITS, bits->preserve);
> +	node = root;
> +
> +	/* Go from high levels to low levels */
> +	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
> +		idx = kho_radix_get_index(radix_key, i);
> +
> +		if (node->table[idx]) {
> +			node = phys_to_virt((phys_addr_t)node->table[idx]);

Is casting to phys_addr_t required?
We should have an assert that verifies that phys_addr_t and u64 have the
same size somewhere, otherwise everything falls apart anyway.

> +			continue;
> +		}
> +
> +		/* Next node is empty, create a new node for it */
> +		struct kho_radix_node *new_tree;

Please don't mix declarations and code unless strictly necessary.
And new_node seems a more appropriate name here.

> +
> +		new_tree = (struct kho_radix_node *)get_zeroed_page(GFP_KERNEL);
> +		if (!new_tree) {
> +			err = -ENOMEM;
> +			goto err_free_alloc_nodes;

This reads to me like "on error free and allocate nodes". err_free_nodes
sounds a better name.

> +		}
> +
> +		node->table[idx] = virt_to_phys(new_tree);
> +		node = new_tree;
> +
> +		intermediate_nodes[i] = new_tree;
> +	}
> +
> +	/* Handle the leaf level bitmap (level 0) */
> +	idx = kho_radix_get_index(radix_key, 0);
> +	leaf = (struct kho_radix_leaf *)node;
> +	__set_bit(idx, leaf->bitmap);
> +
> +	return 0;
> +
> +err_free_alloc_nodes:
> +	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
> +		if (intermediate_nodes[i])
> +			free_page((unsigned long)intermediate_nodes[i]);
> +	}
> +
> +	return err;
>  }
> +EXPORT_SYMBOL_GPL(kho_radix_add_page);
>  
> -static void __kho_unpreserve(struct kho_mem_track *track, unsigned long pfn,
> -			     unsigned long end_pfn)
> +/**
> + * kho_radix_del_page - Removes a page's preservation status from the radix tree.
> + * @root: The root of the radix tree.
> + * @pfn: The page frame number of the page to unpreserve.
> + * @order: The order of the page.
> + *
> + * This function traverses the radix tree and clears the bit corresponding to
> + * the page, effectively removing its "preserved" status. It does not free
> + * the tree's intermediate nodes, even if they become empty.
> + */
> +void kho_radix_del_page(struct kho_radix_node *root, unsigned long pfn,
> +			unsigned int order)
>  {
> -	unsigned int order;
> +	unsigned long radix_key = kho_radix_encode_key(PFN_PHYS(pfn), order);
> +	unsigned int tree_level = KHO_TREE_MAX_DEPTH - 1;
> +	struct kho_radix_node *node;
> +	struct kho_radix_leaf *leaf;
> +	unsigned int i, idx;
>  
> -	while (pfn < end_pfn) {
> -		order = min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
> +	might_sleep();
>  
> -		__kho_unpreserve_order(track, pfn, order);
> +	node = root;

This can be done at declaration spot.

>  
> -		pfn += 1 << order;
> +	/* Go from high levels to low levels */
> +	for (i = tree_level; i > 0; i--) {

tree_level seems unnecessary, just use KHO_TREE_MAX_DEPTH - 1.

> +		idx = kho_radix_get_index(radix_key, i);
> +
> +		/*
> +		 * Attempting to delete a page that has not been preserved,
> +		 * return with a warning.
> +		 */
> +		if (WARN_ON(!node->table[idx]))
> +			return;
> +
> +		if (node->table[idx])
> +			node = phys_to_virt((phys_addr_t)node->table[idx]);
>  	}
> +
> +	/* Handle the leaf level bitmap (level 0) */
> +	leaf = (struct kho_radix_leaf *)node;

idx should be updated here for level 0.

> +	__clear_bit(idx, leaf->bitmap);
>  }
> +EXPORT_SYMBOL_GPL(kho_radix_del_page);
  
...

> +
> +/**
> + * kho_radix_walk_tree - Traverses the radix tree and calls a callback for each preserved page.
> + * @root: A pointer to the root node of the radix tree to walk.
> + * @level: The starting level for the walk (typically KHO_TREE_MAX_DEPTH - 1).
> + * @start: The initial key prefix for the walk (typically 0).
> + * @cb: A callback function of type kho_radix_tree_walk_callback_t that will be
> + *      invoked for each preserved page found in the tree. The callback receives
> + *      the full radix key of the preserved page.
> + *
> + * This function walks the radix tree, searching from the specified top level
> + * (@level) down to the lowest level (level 0). For each preserved page found,
> + * it invokes the provided callback, passing the page's fully reconstructed
> + * radix key.
> + *
> + * Return: 0 if the walk completed the specified subtree, or the non-zero return
> + *         value from the callback that stopped the walk.
> + */
> +int kho_radix_walk_tree(struct kho_radix_node *root, unsigned int level,
> +			unsigned long start, kho_radix_tree_walk_callback_t cb)
> +{
> +	struct kho_radix_node *node;
> +	struct kho_radix_leaf *leaf;
> +	unsigned long radix_key, i;
> +	int err;
>  
> -		new_physxa = kzalloc(sizeof(*physxa), GFP_KERNEL);
> -		if (!new_physxa)
> -			return -ENOMEM;
> +	for (i = 0; i < PAGE_SIZE / sizeof(phys_addr_t); i++) {
> +		if (!root->table[i])
> +			continue;
> +
> +		unsigned int shift;

Please don't mix declarations and code unless strictly necessary.

>  
> -		xa_init(&new_physxa->phys_bits);
> -		physxa = xa_cmpxchg(&track->orders, order, NULL, new_physxa,
> -				    GFP_KERNEL);
> +		shift = ((level - 1) * KHO_TABLE_SIZE_LG2) +
> +			KHO_BITMAP_SIZE_LG2;
> +		radix_key = start | (i << shift);
>  
> -		err = xa_err(physxa);
> -		if (err || physxa) {
> -			xa_destroy(&new_physxa->phys_bits);
> -			kfree(new_physxa);
> +		node = phys_to_virt((phys_addr_t)root->table[i]);
>  
> +		if (level > 1) {
> +			err = kho_radix_walk_tree(node, level - 1,
> +						  radix_key, cb);
>  			if (err)
>  				return err;
>  		} else {
> -			physxa = new_physxa;
> +			/*
> +			 * we are at level 1,
> +			 * node is pointing to the level 0 bitmap.
> +			 */
> +			leaf = (struct kho_radix_leaf *)node;
> +			return kho_radix_walk_leaf(leaf, radix_key, cb);

I'd inverse the if:

		if (!level)
			return kho_radix_walk_leaf();

		err  = kho_radix_walk_tree()


>  		}
>  	}
>  
> -	bits = xa_load_or_alloc(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
> -	if (IS_ERR(bits))
> -		return PTR_ERR(bits);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
> +

Feels like an extra empty line is added here. Please drop it.

>  
> -	set_bit(pfn_high % PRESERVE_BITS, bits->preserve);
>  
> -	return 0;
> +static void __kho_unpreserve(unsigned long pfn, unsigned long end_pfn)

The change of __kho_unpreserve() signature does not belong to this patch.
If you feel strongly this change is justified make it a preparation patch
before the radix tree changes.

> +{
> +	struct kho_mem_track *track = &kho_out.track;
> +	unsigned int order;
> +
> +	if (WARN_ON_ONCE(!track->root))
> +		return;
> +
> +	down_write(&track->sem);
> +	while (pfn < end_pfn) {
> +		order = min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
> +
> +		kho_radix_del_page(track->root, pfn, order);

If we are going to expose radix tree APIs, it would make sense for them to
take care of the locking internally.

For that we might need something like

struct kho_radix_tree {
	struct kho_radix_node *root;
	struct mutex lock;
}; 

and use the root struct as the parameter to kho_radix APIs.

> +
> +		pfn += 1 << order;
> +	}
> +	up_write(&track->sem);
>  }

...

> -static void kho_update_memory_map(struct khoser_mem_chunk *first_chunk)
> +static int __init kho_radix_walk_tree_memblock_callback(unsigned long radix_key)

This name is much about being a callback for walking the tree and very
little about what the function does. It should be the other way around.

>  {
> +	union kho_page_info info;
> +	unsigned int order;
> +	unsigned long pa;

In the most places we use 'phys_addr_t phys' for physical addresses.

> +	struct page *page;
> +	int sz;
>  
> +	pa = kho_radix_decode_key(radix_key, &order);
>  
> +	sz = 1 << (order + PAGE_SHIFT);
> +	page = phys_to_page(pa);
>  
> +	/* Reserve the memory preserved in KHO radix tree in memblock */
> +	memblock_reserve(pa, sz);
> +	memblock_reserved_mark_noinit(pa, sz);
> +	info.magic = KHO_PAGE_MAGIC;
> +	info.order = order;
> +	page->private = info.page_private;
>  
>  	return 0;
>  }
>  
>  
>  

Too many empty lines here.

>  /*
>   * With KHO enabled, memory can become fragmented because KHO regions may
> @@ -789,14 +774,22 @@ EXPORT_SYMBOL_GPL(kho_remove_subtree);
>   */
>  int kho_preserve_folio(struct folio *folio)
>  {
> +	struct kho_mem_track *track = &kho_out.track;
>  	const unsigned long pfn = folio_pfn(folio);
>  	const unsigned int order = folio_order(folio);
> -	struct kho_mem_track *track = &kho_out.track;
> +	int err;
>  
>  	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
>  		return -EINVAL;
>  
> -	return __kho_preserve_order(track, pfn, order);
> +	if (WARN_ON_ONCE(!track->root))
> +		return -EINVAL;

Can we move this to kho_radix_add_page() and kho_radix_del_page()?
I see that some preserve/unpreserve methods WARN and some don't.

> +
> +	down_write(&track->sem);
> +	err = kho_radix_add_page(track->root, pfn, order);
> +	up_write(&track->sem);
> +
> +	return err;
>  }
>  EXPORT_SYMBOL_GPL(kho_preserve_folio);

...

> @@ -1213,25 +1214,12 @@ EXPORT_SYMBOL_GPL(kho_restore_free);
>  
>  int kho_finalize(void)
>  {
> -	int ret;
> -
> -	if (!kho_enable)
> -		return -EOPNOTSUPP;
> -
> -	guard(mutex)(&kho_out.lock);
> -	ret = kho_mem_serialize(&kho_out);
> -	if (ret)
> -		return ret;
> -
> -	kho_out.finalized = true;
> -
>  	return 0;
>  }
>  
>  bool kho_finalized(void)
>  {
> -	guard(mutex)(&kho_out.lock);
> -	return kho_out.finalized;
> +	return false;

Most of the finalization changes belong to the next patch IMO.

>  }
>  
>  struct kho_in {
> @@ -1304,18 +1292,49 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
>  }
>  EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
>  
> +/* Return non-zero if error */

That's what 99% of the kernel does, no need to comment about it.

>  static __init int kho_out_fdt_setup(void)
>  {
> +	struct kho_mem_track *track = &kho_out.track;
>  	void *root = kho_out.fdt;
> -	u64 empty_mem_map = 0;
> +	u64 preserved_mem_tree_pa;
>  	int err;
>  
>  	err = fdt_create(root, PAGE_SIZE);
>  	err |= fdt_finish_reservemap(root);
>  	err |= fdt_begin_node(root, "");
>  	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
> -	err |= fdt_property(root, KHO_FDT_MEMORY_MAP_PROP_NAME, &empty_mem_map,
> -			    sizeof(empty_mem_map));
> +
> +	down_read(&track->sem);
> +	preserved_mem_tree_pa = (u64)virt_to_phys(track->root);
> +	up_read(&track->sem);

It seems to be the only place that uses down_read(). So we actually don't
have concurrent readers. Let's just use a mutex.

> +
> +	err |= fdt_property(root, KHO_FDT_MEMORY_MAP_PROP_NAME,
> +			    &preserved_mem_tree_pa,
> +			    sizeof(preserved_mem_tree_pa));
> +
>  	err |= fdt_end_node(root);
>  	err |= fdt_finish(root);
>  
> @@ -1324,16 +1343,26 @@ static __init int kho_out_fdt_setup(void)
>  
>  static __init int kho_init(void)
>  {
> +	struct kho_mem_track *track = &kho_out.track;
>  	const void *fdt = kho_get_fdt();
>  	int err = 0;
>  
>  	if (!kho_enable)
>  		return 0;
>  
> +	down_write(&track->sem);
> +	track->root = (struct kho_radix_node *)
> +		kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	up_write(&track->sem);
> +	if (!track->root) {
> +		err = -ENOMEM;
> +		goto err_free_scratch;
> +	}
> +
>  	kho_out.fdt = kho_alloc_preserve(PAGE_SIZE);
>  	if (IS_ERR(kho_out.fdt)) {
>  		err = PTR_ERR(kho_out.fdt);
> -		goto err_free_scratch;
> +		goto err_free_kho_radix_tree_root;
>  	}
>  
>  	err = kho_debugfs_init();
> @@ -1379,6 +1408,11 @@ static __init int kho_init(void)
>  
>  err_free_fdt:
>  	kho_unpreserve_free(kho_out.fdt);
> +
> +err_free_kho_radix_tree_root:
> +	kfree(track->root);
> +	track->root = NULL;
> +

No need for empty lines around the error handling

>  err_free_scratch:
>  	kho_out.fdt = NULL;
>  	for (int i = 0; i < kho_scratch_cnt; i++) {
> @@ -1422,7 +1456,7 @@ void __init kho_memory_init(void)
>  		kho_scratch = phys_to_virt(kho_in.scratch_phys);
>  		kho_release_scratch();
>  
> -		if (!kho_mem_deserialize(kho_get_fdt()))
> +		if (kho_mem_retrieve(kho_get_fdt()))
>  			kho_in.fdt_phys = 0;
>  	} else {
>  		kho_reserve_scratch();

-- 
Sincerely yours,
Mike.

