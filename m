Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AA64C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0295E6B0099; Tue, 15 Sep 2026 11:23:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D2D6B009D; Tue, 15 Sep 2026 11:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E336B6B009E; Tue, 15 Sep 2026 11:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB87D6B0099
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:23:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5EB191A034A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:23:51 +0000 (UTC)
X-FDA: 85216366662.03.4CA0E19
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 84AEC1C0007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:23:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=jAfR+gcS;
	spf=pass (imf20.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2G7fwh6XceNihnq+zpe7QcJOabu9l+1CR1KguKLDB0=;
	b=QMA5qT21kDmedX95BFhhHKJDZfVlpBr23p/ruF/mO5aUnyOm3gYB/UdPIZ8LIbW00sCCrI
	WPBhtRV7RwAwn1xfqImhhaOimUwYwt47taOp1T3H1SlXoaeEcteqwdvSHHaJNqsZ8+BbPz
	NeQfsK55kCoZ3aFavsYh1Ha+VllBR30=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485829;
	b=lkgVBFAho1s1fS2jN03tnhDpFd03+JH/qh4SmoJG+MFgod2vzFk6elO4ze9EThY/q21Nzo
	387WOHKheIwVmHPKjfyfFbyhkQNhW4SwCLSM3Z5sAyii3DxbIKp1RfuG0pnwepOBgAOdkg
	z0f6hjEwo97wuZ3enjrkUUujZ84cB/g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=jAfR+gcS;
	spf=pass (imf20.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=d2G7fwh6XceNihnq+zpe7QcJOabu9l+1CR1KguKLDB0=; b=jAfR+gcSZjDJQSgSbSNJBzlcND
	C0OeMYQPwvdtskeMxVDj598uhomdLCqHMzdr/mu5SqxJFNub7z8/3XkLs/vTCT0DMKPCZqX5hTlpp
	TVrXZhg6SFc+9EC1ammzzJCAnWchcu2Ehh0WVgBo6b5rceXLomoQhHtHyzJUVhEFruxK4U91nJkAJ
	nhf82nMDwgrqrCOZ5Ewkf9WfV7DjbHAvrHfzF1anJyRJ6gP+qjYZWHs96Lpcfb/nrwXB08o+qeCXv
	/QxWqK9VQ/qePzLowkz0Da3NomRh3mWXaw55p8Px548cL5etXeghNS+v/sd52hDYWHqWZ8yNKqQmb
	Z5lN/gRw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x6V0Y-000000079fK-4Ael;
	Tue, 15 Sep 2026 15:23:43 +0000
Date: Tue, 15 Sep 2026 11:23:39 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	Suren Baghdasaryan <surenb@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] maple_tree: fix maple_range_64 crashes in RCU mode
Message-ID: <3aqxp6zcomm3wzfc6jt4nhltutnvoatqqsjxlxpxlo3j72eeva@nkqwz43zxsug>
References: <20260913-fix-maple-tree-range64-rcu-v1-0-31a130bb8cbf@cslab.ece.ntua.gr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260913-fix-maple-tree-range64-rcu-v1-0-31a130bb8cbf@cslab.ece.ntua.gr>
X-Stat-Signature: 3q8moqggaymp1rmo4wwryysns8fzfj5o
X-Rspam-User: 
X-Rspamd-Queue-Id: 84AEC1C0007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789485828-434394
X-HE-Meta: U2FsdGVkX1+G/lVG6GWFYWTokUTV4RuIJIYvzxI61A9NglJYsEGffnoawgN4uXOLbyVoVK1GwBtbP5WUdwmrujDpIwmhaVzgyNjc2lyQuB6CslkIM0oMy1GjlNl4wQfrJt7DbjlVjZ+kQHxpdQdD+/XSmc16AACyE3v7PIm51UFQnskF2+d8yX660MQ5irNjUQF3JT6d62l3KOTwrDXShtMgozO2zm3qzY1cegbtPeuaj0BEPB1UKKnktiv9Jttu6fDNN4m5M6ffNIVohm1EXcjqcxtariO+XAyynpTQ38sczSzxwQfcTPo8ZVEhokpuWG06yRCT41ENp6KCrc57BOLWCHtoGv7Ny+tdEXQRY2nMYc3Z1KRmVGSXCvnqTeLBrN9gkVjC7WbGYewjbCvoE7AmqWW1xb+vn3wXM5eKKDKftf06tCQLJnJKW3YgzLg5+c8W0i4Ql7yCYBX+zz6kq97zRhNibuNoplaJgEE0Zynrw2v9BCS6uhvhPCyahTWar/sjolV2CUmyzNJAbCnzgmMXPe/RAZ+MbUGacRE57H+H5egW006BefqJ4h424vRGrMISe2DAcnEuLqQ0HfQLw0cAAIjZmgRq6UHxstCCQUkMgxdd/XsMBztDVW+5te3jaZMGFeLB+BTDI93ardirDWLkCzgMdbG7f9mTUzOw7acVlXoEkUuKEUapNadN9x8ed1VuaRzg4H3m6aCehboA5BWowGID/z251BA5VOxmkF/+SlaLlrJVHHGp+ZYJVwlqSO8VG2taIX5rGGN+bTuN6DKo8y6mmoHfg0vQkonjwtRap8PtZayMSa3P29ovQAnMlYwR7X6qbYwvWGCpfUA2R9QUHPofwuFyQ5PWpd77m4I9KbLlg1W+8uu7jlrPbl7ri/D0fRYedojqXHYBkbdRnFcTNInGeNDbB02ePHhZRi5Hs4q4DeZktJQp7qox9t8Aew0zopXvU3h7ektirEm
 gweCOSFD
 Cwnwvg7woicLlLbhXjDVisTVF2oPF6D6UZeA8YKx+cE7ICB0QKo8Koc57U/DQ/a27CmwfsjfkNaRHgHWTyYUk8QPweenjbv/COobEaJ46O49njw6znJCdGErjiW5lUxtFgdYI2hTgPxnP+Vg90b0ZsDhLm6mlMOrRjD7QKltC+BjZ+/udEQrc78Mw/EcpDw0Wy1hjqxt5MZ4v81we5/G5975GBHE6Uxda1ew9ol0J+MrqIF+np7Q/VI47Y/tN+AqlhQT/BaT+o34OuRiqTwueE6tP6p1SjaHptYgZBr27/ZJ0lG2Ylr7khWNI1S7KlDdDMQP+EFBlYrfYjFl2wL99cx3ftk423S75LAXvkNc30x43jmqevaemb3gDpU3EQEkULAjl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/09/13 03:26PM, Dimitris Charisis wrote:
> I was running a patched kernel using a maple tree in RCU mode without
> specifying the MT_FLAGS_ALLOC_RANGE flag and the kernel crashed. I
> switched to an upstream kernel, and after some investigation and
> debugging (thanks tools/testing/radix-tree/maple.c) I discovered that
> there were two separate issues on the RCU destroy path that were
> responsible. Both arising from the fact that a maple_range_64 node that
> is not full repurposes its last slot to hold metadata. Each issue is
> addressed by one of the two patches.
> 
> AFAIK there is no in-tree user of maple_range_64 nodes in RCU mode at
> the moment. All in-tree users of MT_FLAGS_USE_RCU that I found also set
> MT_FLAGS_ALLOC_RANGE which makes the internal nodes maple_arange_64.

Hello!

Thank you for your investigation and patches.  I will have a closer look
soon, but for now I have a request for this series.

> 
> Below is the minimal reproducer I used during debugging.
> 
> static DEFINE_MTREE(tree);
> static int __init maple_fix_init(void)
> {
>         unsigned long i, j;
> 
> 	for (i = 10; i < 4000; i++) {
>                 mt_init_flags(&tree, MT_FLAGS_USE_RCU);
> 
>                 for (j = 0; j < i; j++) {
>                         mtree_insert_range(&tree, j * 10, j * 10 + 9,
>                                         xa_mk_value(j), GFP_KERNEL);
>                 }
> 
>                 mtree_destroy(&tree);
>                 rcu_barrier();
> 	}
> 	return 0;
> }

Awesome!  What I ask people to do is to create a patch for the
tools/testing/radix-tree/maple.c with the reproducer in its own patch
that gets added after the fix.  This way we never re-introduce new
features and the testing keeps passing for every bisection.

If you have one of these for each bug, then please add them after the
fix.  I understand rcu is tricky to test when a race is involved, but I
do have testing for many threads (which you probably saw).

The testing is less organized than I'd like and since this is RCU
specific, you may need to use the testing file and not the module
testing in lib/test_maple_tree.c.  If possible, I add the testing to the
module, but if internal poking or threads need to be used, we put them
in the userspace testing.

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
> happens to land on a node that was freed previously. The splat usually
> appears at around 226 insertions in the reproducer. The exact tree size
> that triggers it may vary because it depends on where the corrupted
> pointer lands.
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
> Patch 2 fixes the second issue. mt_free_walk() descends by checking if
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

Ah.  I'll have to look closer at this.  The metadata had caused issues
on BE machines in the past which required some tricky figuring to avoid
using the metadata as a node pointer.

> 
> Signed-off-by: Dimitris Charisis <dchar@cslab.ece.ntua.gr>
> 
> ---
> Dimitris Charisis (2):
>       maple_tree: remove mt_clear_meta() to fix a pointer corruption
>       maple_tree: fix invalid memory access in mt_free_walk()
> 
>  lib/maple_tree.c | 43 +------------------------------------------
>  1 file changed, 1 insertion(+), 42 deletions(-)
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

