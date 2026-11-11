Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F255F606A339
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 20:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=rLAFqeBU
Received: by kanga.kvack.org (Postfix)
	id 8F0616B00EF; Wed, 11 Nov 2026 15:17:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A1F96B05B0; Wed, 11 Nov 2026 15:17:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7266B05B1; Wed, 11 Nov 2026 15:17:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 629026B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:17:12 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB292403F5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:17:11 +0000 (UTC)
X-FDA: 85423947462.17.3519660
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf08.hostedemail.com (Postfix) with ESMTP id 956D7160007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:17:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rLAFqeBU;
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794428230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oD3CNLbIRk9zgIo0q6lJWHOlAEvsBK/j/BkurlWIEZE=;
	b=szLALbhNydVLhZ9VpItB/FLX9uKtvTC2T8AyZXlTiRMYJ3MkH1NQIooWDX6ELtn0acP1wd
	K3LGF7U7izx1gL36Kg5K1nhjCdOsbwdj3NADwi/iZ47D1bRYzqqNPmT2Gkjw1DvqnIheAd
	mbNv7o4NnWUa6wOTKcf6Gtm+HuZbBNo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794428230;
	b=vSLL5hGlPZzvtpI2+GV5FM53XZrUhs4mi6TpZyb3ztsDYgtZGWpr/eFAPY98ZLQCSE+yvj
	WuqePl2CV8BG3OHtiEP9gzL8rtRtVlHu2yUgwO4AP2TP6LJLloG3Ny3vV6WLcWqy8Zu68t
	zlsSJ4TP2ASd8xuLdP7+Svt1qtyi+TM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rLAFqeBU;
	spf=pass (imf08.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oD3CNLbIRk9zgIo0q6lJWHOlAEvsBK/j/BkurlWIEZE=; b=rLAFqeBUcRnY4NFkuIHyq7axiM
	OXoJlAbDb0EldqG2BE/m1cR/pt7hEIOLwW/UrBT8SD/09THyBOdupL7HrT/Pin5s5AS+ljJpiuV91
	uFBF1p3C0+GrY12Z51g4zudUG9d0I/4SNRMta9KcCqF2XA5QiF1uxLR7BumUoYnoQqeQctvrqmmr1
	23k9UcSdMZspzmPMbgIClHfC2bTLvo4KCW56OA11vkfrts/urzO6HaA6MWEApc+rNK5pQzZzljSXE
	zYWK6hijsIIwAHOD19U9V7c6nttMAWznydYLvAbPxtcTIatXZoHTZbtpncxPE2Vk64Ln4f3IW+54X
	ifyMh7PQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xREkj-00000007bhW-1sZ9;
	Wed, 11 Nov 2026 20:17:05 +0000
Date: Wed, 11 Nov 2026 15:17:03 -0500
From: "Liam R. Howlett" <liam@infradead.org>
To: Florian Schmaus <florian.schmaus@codasip.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Ballance <andrewjballance@gmail.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Suren Baghdasaryan <surenb@google.com>, 
	Dimitris Charisis <dchar@cslab.ece.ntua.gr>, linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v2] test_maple_tree: test maple_range_64 node below the
 root in RCU mode
Message-ID: <b444rjvq32jvaljx2jp25ky7jp3zwkgvojemuq4hvwua4fdyqo@unnxuu64mnqo>
References: <20261102-maple-tree-fix-slab-corruption-v2-1-d0037f04ecd6@codasip.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102-maple-tree-fix-slab-corruption-v2-1-d0037f04ecd6@codasip.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: hnx7cmewh1kuzbqx47mag9sx17g574im
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 956D7160007
X-Rspam-User: 
X-HE-Tag: 1794428229-590916
X-HE-Meta: U2FsdGVkX1+WeONwOqSf48Eafbwc0h+C5L9VZd0RBx6Bx86HA8eTN1woqDBEy2v0wXVJXP2IHdqfDkyIkFMoDDSnJgBiGvq4/fhNWHZxPFQmU4m1MucvhUt1XZU5LTo1bCxlHRJAsvfBylHRh5WXGIVfO7mdjULa/5ThYQOTQCAdetJz9Bjxsbt0DzL9eLZsvktRSvXLR1oyg7WkV6xflSC9IV1gS0F9o1SppTuZuzeoMsEuFlCYG0Nuf6hKIeOY2yT62tHedxqVL2oXQtj6RyItnXUvCcWWkK4CInwmrQWfMtvMrJB2ugDH3h7RB0eG7xjDL1Y+1Gs3KOCiTJKRKD7djXPLpYyUyPb3OPlDGcqHKimq0wb0d+l4HMV3U3fL1jdDkC74Fhk8P2EvFz/24utPthQQvnIEvDsjamuGusAZ/L6wP2/bZhOrBmnjAiTm4xRJWmw7UNDY1LqdLXOTNYggqHyf6Bcffp+1NXD6hVaJcFfZJp4F9NvImN7bXcRk40Ehf5m1DHxOGiVWNWnjx4L5MdUzaQEfvic/DfOUqA0gamrLuLxQCQT++wl4HKGPIGyR+0v9qmOIjonrHWK7XNli6NocnN3tMffm8QQyXQ65Rd/X1+unAoH/GAz/evE2ttssYFuE8rqgQ8FIn6Aclf943oOaK82xUk9FBbyBiaI+BhukJN/akcOm1wB2gSiZaxqcYGQZ2lBXt6oGmTGL6c7gfxfYN10ZBg8qo7cya7YyjUDIEwz08ZaOUweEZpfdsufyUCxNo7C5lpez3uIH5KpQzu3jeUJOH1qHck/hRhNxw4FyKSKng4nf9YM72744J8F5inRxntcY2rxF71NeDp8dGngnhAfslt+yBLz/mOvxwivrxk/aAbFo2sYDV1LKiCusN6lU2blSjNB9zI6MABoZRE+wBNU8cj+xdglAhT4kfumMtimMjgBFrVEju8GATi5aNu0d+r/50lSJG4V
 RFdMrzVY
 yz0qIvXr8F6CLUkpOz4jjTv7lgMTFuzCmYiEgUVaOklAAQbC8YkreqLVRL4prsuQHyvyozyJO0ZDKXftplCv3Z5UgWox6BNmibPaftbQQoX5Pbn7joYIwFbpapKCASEN3h5y24AZ6ga+SespfcSSA4VV0Z7wzVK27RCPQOLlLJ/r1s9yi4U3vU2cDZEonsI2a9SkV/LAkvqYMnsdxKINVGxHH42rH/RwRhhXQacJll7GvHJbf35LgD/ZdEs8qKCXgo9qFVk/LmU3RYtvcqlCw7mrJZWB6vmcvK8NS45AlOLmetl/+/6LAB07rOVu+uAo1bH1bWmdlJkne93uufZD84c4fP6dJ9Xw5kLHf5we72i80+JoZ9Kjx3oRBok/tfZqvjGvCgmZACjlGviEed3c0ThHtIHxrS9Raa0T2pYkgIWv2c7PygXXJYvncmMONt61Pe6tyWhQB+jXQQPh2dcfj+bQkkBHkZofZB7v513DCx20DvhayqvVle2/3TFfaam2eRqXzFdN5UolOpAgSL+u97sFIHHxbwyPNU3Zj3rVVBw1Mrh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/11/02 10:14AM, Florian Schmaus wrote:
> Commit baed735a956f ("maple_tree: fix maple_range_64 crashes in RCU
> mode") fixed mt_free_walk() taking the metadata in the last slot of a
> maple_range_64 node with 15 children for a child node.  The bug only
> affects nodes at least two levels above the leaves.  The test added
> along with the fix, check_range64_in_rcu(), uses a height 3 tree, in
> which the root is the only such node.
> 
> The height 3 tree only exposes the bug because the same commit also
> removed mt_clear_meta(), which used to clear the metadata of the root.
> On the code before that commit, the bug is only reachable below the
> root, and the height 3 tree is destroyed without a crash.  If the
> metadata of the root were cleared again, the existing test would no
> longer detect the bug.
> 
> Add a height 4 tree in which a child of the root has 15 children and
> keeps its metadata in the last slot.  5191 insertions produce such a
> tree on a 64-bit build.  Destroying it crashes without the
> mt_free_walk() fix, with or without mt_clear_meta().  For example, on
> the code before the fix, the userspace test harness reports:
> 
>   lib/maple_tree.c:4755:27: runtime error: member access within
>   misaligned address 0x00000000000e for type 'struct maple_node'
> 
> Signed-off-by: Florian Schmaus <florian.schmaus@codasip.com>

Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>

> ---
> v1 of this series fixed two bugs when freeing RCU-mode maple trees. Both
> are now fixed in mainline by Dimitris' commit baed735a956f ("maple_tree:
> fix maple_range_64 crashes in RCU mode"), so only the height 4 test case
> remains, which I offered to send as a follow-up in [1]. It now extends
> check_range64_in_rcu().
> 
> Testing: the userspace test harness (tools/testing/radix-tree) passes
> on x86_64 with ASan and UBSan, and on s390x (big-endian) under
> qemu-user with UBSan. On both, the new case fails without the
> mt_free_walk() fix, with or without mt_clear_meta(), while the
> existing height 3 case only fails once mt_clear_meta() is gone.
> 
> 1: https://lore.kernel.org/all/46073a08-20fd-465e-86e8-9c358787f9b3@codasip.com/
> ---
> Changes in v2:
> - Drop the two fixes, superseded by commit baed735a956f ("maple_tree:
>   fix maple_range_64 crashes in RCU mode").
> - Rebase onto current mainline.
> - Add the height 4 case to check_range64_in_rcu() instead of a separate
>   check_rcu_destroy(), using its insertion pattern (5191 entries).
> - Drop the full root case, which check_range64_in_rcu() already covers.
> - Link to v1: https://patch.msgid.link/20261015-maple-tree-fix-slab-corruption-v1-0-160d97f7304c@codasip.com
> ---
>  lib/test_maple_tree.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/lib/test_maple_tree.c b/lib/test_maple_tree.c
> index fb40e193a3cb..121f521e263f 100644
> --- a/lib/test_maple_tree.c
> +++ b/lib/test_maple_tree.c
> @@ -3738,6 +3738,19 @@ static noinline void __init check_range64_in_rcu(struct maple_tree *mt)
>  
>  	mtree_destroy(mt);
>  	rcu_barrier();
> +
> +	nr_entries = 5191; /* Height 4. Root child has 15 children + metadata */
> +
> +	MT_BUG_ON(mt, !mtree_empty(mt));
> +	mt_init_flags(mt, MT_FLAGS_USE_RCU);
> +
> +	for (i = 0; i < nr_entries; i++) {
> +		MT_BUG_ON(mt, mtree_test_insert_range(mt, i*10, i*10 + 9,
> +						      xa_mk_value(i)));
> +	}
> +
> +	mtree_destroy(mt);
> +	rcu_barrier();
>  }
>  
>  static DEFINE_MTREE(tree);
> 
> ---
> base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
> change-id: 20261015-maple-tree-fix-slab-corruption-d1f098521d15
> 
> Best regards,
> --  
> Florian Schmaus <florian.schmaus@codasip.com>
> 
> 
> -- 
> maple-tree mailing list
> maple-tree@lists.infradead.org
> https://lists.infradead.org/mailman/listinfo/maple-tree

