Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04D00CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 14:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CEEF6B0088; Thu,  1 Oct 2026 10:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 959036B008A; Thu,  1 Oct 2026 10:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81F9B6B008C; Thu,  1 Oct 2026 10:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44B076B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 10:13:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E4F080429
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:13:45 +0000 (UTC)
X-FDA: 85274250810.07.E369A37
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2F76A140003
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 14:13:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DUfHsRKw;
	spf=pass (imf23.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790864021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFOsTIkJGCvkWXfmhJPsKgyWFC1Mu0pasSBpSV+Domw=;
	b=cC3GZG+t1j57L9C8I5DeDKFGsCTg5BoQFmV/yJf7m1S83lPSVSF5Jb7elacMYMO3eZ0Jez
	Au8B2ZHCgZMic0b5UwhbiFYpkJV35hmi+LQajUts8iQoJ9MgCvSZD/pp+xVTYT4zJboXxw
	5zYvsGemmCxd4Z2ifu2z137IX+cF+M8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DUfHsRKw;
	spf=pass (imf23.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790864021;
	b=elMU/PYKBagk4uHXtzG4YFDji8WS2l+qaoB0wwYm0NeANBmKSPY5GuA6QrUQDYxm0lTKDE
	OMVGX1QRVsRllAmPQ27CBJxGtT/4a0Ov3k5dv6Rsg+WGsV/7b2VQ1RlDZtv6S5WUsq81PH
	beO0YrBzA0N0zovSgpA8HXzjCgh/t/4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MFOsTIkJGCvkWXfmhJPsKgyWFC1Mu0pasSBpSV+Domw=; b=DUfHsRKws9iHV7XAhdxBh0P7ZF
	Ad8UCecjhoAgYVttZ5lZVpePZBZnu+llZQmgv+eVv3DcbCJy4k5b4oSBl+LjwY28B9yqgLer72yyO
	9v8yUwy3NNlflLw46mqyCk5Id9/5QiN1ofwqK9n4D01GOZ7aJZ5LNlnkUnaT2Jdf0ayeZUc3ekr5h
	7Rn2Rxaw1HHg3dFAU5SAEY7uvHVq+loNxZS59VwbYsJMyMYk8VNfWDuY6w0CaNKkneLYPqlB1ZXf7
	uI60ayI393IGu1t1hoGTV+up5ePrIGwh2LmcWq4UOp0gG+pr1oRHsQdzMjM/WqiAq1rHBeTAISrcS
	MZi6KJTA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xCHXS-00000009LHx-0b7a;
	Thu, 01 Oct 2026 14:13:34 +0000
Date: Thu, 1 Oct 2026 10:13:30 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	Suren Baghdasaryan <surenb@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] maple_tree: fix maple_range_64 crashes in RCU mode
Message-ID: <xenbug3emyr4h4c25zgtrqu44xiayf2kpe7mtvhtoivipeesp5@kdpcd72xwrri>
References: <20260916-fix-maple-tree-range64-rcu-v2-0-0b09de37eb69@cslab.ece.ntua.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916-fix-maple-tree-range64-rcu-v2-0-0b09de37eb69@cslab.ece.ntua.gr>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2F76A140003
X-Rspam-User: 
X-Stat-Signature: uu55hc8sc7fs1buhj8atn3go48fhhw91
X-HE-Tag: 1790864020-708446
X-HE-Meta: U2FsdGVkX1/zmdn2P31tgLyn6ZKCVSeT2IGnqtRcQ6et8wKlyCFFjQI84XMLCOVgauXLcNHOeYkUWtrBDQki0VId8inDnSwmlOVBEwTNMv81AB3CaH5ixDoYHay8Do5RU3hJjRucNaA9gSZhrVn9xQRtq50pD/qdWdkH+bNOcRv8S94AFWKDqzDaZMhcll0NoFbbcIFmq54Ln+a0p7iJ/FnU96WX4aoomqanlMe1bwn33H/w7CGK7r2ymbc2aM6LjZ+VbyvL2SeXhr1JDJHzwINELf4lTh0tCPJQT82LfhyU43SrZfJLlrTzFil1gvRCqhPN0Th0NbpN2BncgkG8h7Jw3HXahaAQg+GI3kKEUS1ylnI/HqoZOEwAe+eVjnx11HYAiqaZ8UqbcpU8UWiIZIqMGh0HIulkX1KkDGY+ERIFChot0GuM82RTAm499yOrkgB0XwFJWC4HcEsf221IzaL/FdVPEKJvRZMQlY6ojjuu6V44EkQkkhnPc21fXjTSQOgGAVLz22AB3d5LxbJLR15eSR4oPSRdJjjny9XFqe4GD8rXxHotPXdb1alGTY1ImDJakKkQP1snuv7Dtoosa/rqHuoUxPCOLPvncuZDXx5wT6LQellXUaaIpslLgPiBQebPHZX2XPYWBpGU9FYLZeco6j8o/U6jfzCBr3MpjK4fzB707xb+zKp7NQC6fOr6Eq+e9A8q+WKNHnwkEJYbeMIwmUVmbibHTylNFUHZx0tFxgSXzLNap1kpWwWsBM0xpK56TjRTinQN+gaCw0jt2Gi1QWNqbSBsQtTyCAKuiJfCV/uorQXeDtSQuJAuJZqqRVrlKVf+MAsbIuFWnxPl+feMwUTrtTugkLwgtT38K3+s0UNuK2yILtYRyJpgwOEaSkNrGrZjgTxF5WZgRBh2vYKE3OY9A0jxYJFyN0jArrX1d664tRHbQjxZCw6pmQTkrooeLey4XVevH/+YUh1
 vvO/5e1R
 NhWsVel+HGdIruVeCp/UHt/Nr5YdMHDy3fSUU4Y4opG6nCH3wO74JJ5d1QsiMpDb3Y44Z3YA6jKUNge6L45oA6txqVCB016O4b6UNtMeAybOfAIaU6PPk/v1wN3/if0JWHN+7eg5Tk5S0WEcNqm6oaKiE7vjpUPsU2jCaxP8ICPfubFcAbFY8EN0CKpAOwxNB2n7LiR9TyQRmsJ0vT/fYqJptgubA+qIMxg0Szgm25taAAL+GwplSKfGQi3ofWFKZwwNsVwWjLrtoOfEkuWkqdZjyqTjaaTBt04ljlrFxITOTVG8yftzLFKcdpoKRfNdlTMc03JyjUAAdK8fZwPSn0QO0Cdk26GjTYkBsIMzUzPGT3tAsAUsdrTdGVWN+k6rjQfjIzdAJS9WvtP03IMEOYiF16zTPuEtFDX1C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/09/16 11:38AM, Dimitris Charisis wrote:
> The patch series fixes two RCU destroy path issues on maple_range_64
> nodes. Both arising from the fact that a maple_range_64 node repurposes
> the last slot to hold metadata when the node is not full. Patches 1 and
> 3 address each issue, and patches 2 and 4 add the tests used to catch
> them.
> 
> Currently there is no in-tree user of maple_range_64 nodes in RCU mode.
> All in-tree users of MT_FLAGS_USE_RCU also set MT_FLAGS_ALLOC_RANGE
> which makes the internal nodes maple_arange_64.

Dimitris,

Sorry for the delayed response.

Thanks for adding the tests to the patches.

Right now the mt_clear_metadata() will avoid descending into an invalid
child (metadata being detected as node on mt_free_walk()).  Your first
fix made the second fix necessary.  Both are needed, but the ordering is
wrong.

If we use them in the order you sent, then a bisect hole is crated where
we may descend into the metadata thinking it is a node.  So testing
between the two may cause a crash otherwise not seen.

Considering how tightly bound these fixes are, I would consider them to
be two parts of the same issue; they should be combined into a single
fix.

Thanks for the testing patches, please keep them for v3.

> 
> Below is the minimal reproducer used during debugging:
> 
> static DEFINE_MTREE(tree);
> static int __init maple_fix_init(void)
> {
>         unsigned long i, j;
> 
>         for (i = 10; i < 4000; i++) {
>                 mt_init_flags(&tree, MT_FLAGS_USE_RCU);
> 
>                 for (j = 0; j < i; j++) {
>                         mtree_insert_range(&tree, j * 10, j * 10 + 9,
>                                         xa_mk_value(j), GFP_KERNEL);
>                 }
> 
>                 mtree_destroy(&tree);
>                 rcu_barrier();
>         }
>         return 0;
> }
> 
> Patch 1 fixes the first issue. The splat is shown below. mt_clear_meta()
> runs after the slots have been rewritten with raw pointers by
> mte_dead_leaves(), so it cannot recognize a valid last pointer because
> the type information is stripped. On my 64-bit LE machine, it clears
> bytes 248 and 249 of the maple_range_64 which are the two least
> significant bytes of the last pointer. The lowest byte is already zero,
> since nodes are 256-byte aligned, but zeroing byte 249 corrupts the
> pointer.
> 
> KASAN catches it as a double-free, because that corrupted pointer
> happens to land on a node that was freed previously. The splat appears
> at 226 insertions in the reproducer. This is when the tree has a full
> root node on a 64-bit build.
> 
>   ==================================================================
>   BUG: KASAN: double-free in mt_free_walk+0x138/0x3a0
>   Free of addr ffff0000f3d40000 by task swapper/2/0
>   [...]
>   Call trace:
>    [...]
>    kmem_cache_free_bulk+0x5b8/0xc18
>    mt_free_walk+0x138/0x3a0
>    rcu_core+0x5d0/0x1638
>    rcu_core_si+0x18/0x30
>    [...]
> 
>   Allocated by task 1218:
>    [...]
>    kmem_cache_alloc_from_sheaf_noprof+0xa8/0x2f0
>    dst_setup+0x210/0x630
>    mas_wr_split+0x568/0x26e0
>    mas_wr_store_entry+0x98c/0x1de0
>    mas_insert.isra.0+0x3d0/0x5d8
>    mtree_insert_range+0xec/0x1c8
>    maple_fix_init+0x94/0xff8 [maple_fix_obj]
>    [...]
> 
>   Freed by task 0:
>    [...]
>    __kasan_slab_free+0x88/0xb8
>    __rcu_free_sheaf_prepare+0x94/0x360
>    rcu_free_sheaf+0x30/0x138
>    rcu_core+0x5d0/0x1638
>    rcu_core_si+0x18/0x30
>    [...]
> 
>   The buggy address belongs to the object at ffff0000f3d40000
>    which belongs to the cache maple_node of size 256
>   The buggy address is located 0 bytes inside of
>    256-byte region [ffff0000f3d40000, ffff0000f3d40100)
> 
>   [...]
>   Memory state around the buggy address:
>    ffff0000f3d3ff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>    ffff0000f3d3ff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   >ffff0000f3d40000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                      ^
>    ffff0000f3d40080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>    ffff0000f3d40100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   ==================================================================
> 
> Patch 3 fixes the second issue. mt_free_walk() descends by checking if
> the corresponding slot[offset] entry is non-zero. In a maple_range_64
> node that has MAPLE_RANGE64_SLOTS-1 valid pointers to child nodes, all
> slots will be non-zero, since the last slot holds the metadata. Thus,
> mte_dead_walk() dereferences the metadata as if it were a node and hits
> the null-ptr-deref as shown in the splat below.
> 
> After applying patch 1, the reproducer reaches this case at 3166
> insertions. The affected node is the root on a tree with height 3 and it
> has 15 valid child nodes on a 64-bit machine.
> 
> Patch 1 does not introduce this bug, but it exposes it for the root node
> because it no longer clears the root metadata. On an unmodified kernel
> before patch 1, the same bug exists and is reachable when such a
> maple_range_64 node appears below the root, where mt_clear_meta() is not
> called.
> 
> Second KASAN splat:
> 
>   Unable to handle kernel paging request at virtual address dfff800000000006
>   KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
>   [...]
>   Call trace:
>    mte_dead_walk+0x78/0x140 (P)
>    mt_free_walk+0x1f8/0x3a0
>    rcu_core+0x5d0/0x1638
>    rcu_core_si+0x18/0x30
>    [..]
> 
> Both splats are from an arm64 QEMU guest. The test_maple_tree and the
> userspace suite pass after each patch in the series.
> 
> ---
> Note for reviewers:
> 
> * Before commit 790e1fa86b34 ("maple_tree: add RCU lock checking to rcu
>   callback functions") mas_clear_meta() was called while descending the
>   tree, so metadata was cleared on every node. That commit removed the
>   call from the descend path leaving only the final call for the root
>   node, and renamed it to mt_clear_meta().
> 
>   An alternative fix would be to restore metadata clearing for every
>   node and fix mt_clear_meta() for full maple_range_64 nodes. I
>   preferred removing the clearing and use slot_len to identify the valid
>   slots directly.


> 
> Signed-off-by: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
> 
> ---
> Changes in v2:
> - Add one test after each fix.
> - Reword the cover letter.
> - Link to v1: https://lore.kernel.org/r/20260913-fix-maple-tree-range64-rcu-v1-0-31a130bb8cbf@cslab.ece.ntua.gr
> 
> ---
> Dimitris Charisis (4):
>       maple_tree: remove mt_clear_meta() to fix a pointer corruption
>       test_maple_tree: test a full maple_range_64 node in RCU mode
>       maple_tree: fix invalid memory access in mt_free_walk()
>       test_maple_tree: test a maple_range_64 metadata slot in RCU mode
> 
>  lib/maple_tree.c      | 43 +------------------------------------------
>  lib/test_maple_tree.c | 32 ++++++++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+), 42 deletions(-)
> ---
> base-commit: e2e54005e20fb42d4a5e140d70a65be4a2363045
> change-id: 20260912-fix-maple-tree-range64-rcu-02fa3d2e59a7
> 
> Best regards,
> -- 
> Dimitris Charisis <dchar@cslab.ece.ntua.gr>
> 
> 
> -- 
> maple-tree mailing list
> maple-tree@lists.infradead.org
> https://lists.infradead.org/mailman/listinfo/maple-tree

