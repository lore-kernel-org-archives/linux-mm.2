Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DEA6CCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 15:26:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39046B0005; Wed, 29 Apr 2026 11:26:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E100B6B0088; Wed, 29 Apr 2026 11:26:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D273C6B008A; Wed, 29 Apr 2026 11:26:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C17C46B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:26:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6EF93C1365
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:26:42 +0000 (UTC)
X-FDA: 84711970644.06.C7A67BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4BC26A000C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:26:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UJerEqCq;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777476400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y9nh48CT/wsyPf1ZfyC+Fj16HLySAyaYmBROs2keEqc=;
	b=U2z1FyuVc0HUElRBBBqPoiBvnsyX9V+/OVnB6TX3STR+YIOadzljBF2JpKhAP+J/55W0kd
	KuhKMkktuZqr0mevb22f8X+qZn3VdQSyoDu8SzVpxe0ZlTonIsVTcLu/iTqY4VzHg9/e9l
	gh5nT2C+r2ihI6+urRMLutWymq+FEd0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UJerEqCq;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777476400; a=rsa-sha256;
	cv=none;
	b=yc3ROFPka/PKfnszUAO52bLO+g51iP0C2uam7Pibf4vV/1Gr8XgOM6S04NXN8L/2el4Q1V
	ldGB32LLjbiYWvtFvnfxsPxZ36hQ7kiycucfaeRPGzNti+ZlMFEuWQ/V4DgBtZDEpwgyec
	CAhivW8MtNn4xGp8GBYJ5T5+MbCWGTI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 56BBA43BAB;
	Wed, 29 Apr 2026 15:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42BAC4AF09;
	Wed, 29 Apr 2026 15:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777476399;
	bh=srBa4KiJ2ooCPxq/W2oVDrPQLvs/fx7BWj2l2xJ/Eik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UJerEqCq+JZHeiGRCScwk/WCzjLgAM8Y5Y5bi0ZUjzTNvscJ0eiuY1uxYmAfJ97/o
	 HqRILlUG+ZX6IeOP0WQ6W5kG+P+1X2HqEwEJ6lxvLMZp3JLaWOOVlh3amItFigS/mu
	 exzYZ1t6W7/h7dH2CcmunEClga4TEkOEc+n2wqU4D5s5f2EtwsNuZlkCfAuYopU6rD
	 N40DxKW8LFo4doCNf5BVBYdgrhj4pOvoXeRPboT1IL3evwdpGIht1qOph5x1sL5vmN
	 DY6QXf0yb6VZqJCrdQpbTQT33QbypCXiCTuioiIOfBHysyYZelwcshYgcCyIgtzxZL
	 odOYwayXS/T2w==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id EC7BEF40074;
	Wed, 29 Apr 2026 11:26:37 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 29 Apr 2026 11:26:37 -0400
X-ME-Sender: <xms:LSPyaRiADJrosqN4Fv0wvBUsOvrIrATmrpEgfYKeNYXWG3snBYR3Yw>
    <xme:LSPyaYW-gVXgzhKKl8AqTgia87g5dfsE9W7hi6Va9vj6Xpzec90_eEdgblBCb5zIm
    bdM2cGimswq3-UiweuMIIiLqT4lqY2mV7lU6E0rfOCJLfBFZnWqWnBg>
X-ME-Received: <xmr:LSPyafz52A7QKJXhX_n4FqfcSoZsZgo1AAZ6r7GEz3_rx2soEsAxDkxP3IYTcg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekgeektdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeeuieejieffkeehfeffffdtkeelfeelhefhfefhudehjeehvdffleeuvddufefgkeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrghdprhgtphhtthhopehlshhfqdhptg
    eslhhishhtshdrlhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohepgiekieeskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonh
    drohhrghdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthho
    pehtghhlgieslhhinhhuthhrohhnihigrdguvgdprhgtphhtthhopehmihhnghhosehrvg
    guhhgrthdrtghomh
X-ME-Proxy: <xmx:LSPyaTPud7gGpOpiOZJSARRdkKzOEecvwrku9Kzki3dxaSoR8zInBw>
    <xmx:LSPyacZap7nFhwYTcRH5KrBcm7XMen71Cjgi_Vjf49RwGCFisfktgw>
    <xmx:LSPyaU46J_pufG8Z0p-r1kdIap_fj8gFW70G-Xgvsr20ADDqdjwizQ>
    <xmx:LSPyaTD9ci-j_NdN8x8EoOpjaE-gGlKI-8DnsG916xOvosOo61pghg>
    <xmx:LSPyaT7VHyoYFVwMx6i8c1byiUk93s0vtQawJuEV-hAOLuczgCCUMW7u>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Apr 2026 11:26:37 -0400 (EDT)
Date: Wed, 29 Apr 2026 16:26:36 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <afIdgkYJGCi_cC5P@thinkstation>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <afIYFtL6KrBs38rT@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afIYFtL6KrBs38rT@casper.infradead.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4BC26A000C
X-Rspam-User: 
X-Stat-Signature: jad337wgc39neyzi6wnotzuk1ik8shq7
X-HE-Tag: 1777476400-948769
X-HE-Meta: U2FsdGVkX1+uLmRfoRu64xIZWiV39t+qX5Edxc+SQ+C5AdyxMiam2/jeTg6OBVt5Q85fgOvTiHpqZUqtBryTvVGkD0a+4KHC6f2QgFPNnGcjhq42CQzWqcGf20qVdPCB2YnKHNGLb1OnIYbgbHASU64PdxO+PePa6kl32OOrxaGcEMefwhL2cP73bjxIekz77xRvIvedlJ3XB0c3iGOYenHERWlwtxow8OlL09EChruohRtcnzCjJiJyI7RPNyGpTespCyfIEww3etZbpAau27RdkHWwdekffTF3e5qy3yR4spn/D/aGHd78tvxS2sV+bNRENHjxGaRgd4GLO1Kqy7GdZ48bWT4yrM3VpUgSbl8Q6Oe+om2FG53SjJc079b5uOZClkb1Q/yZFuuQSkS/SIxqKtFvNvNWRj1keMYBJzkf7JvE0IGABarznVULfIZZIjdjqqjHdd1gPN10/J6QJXxjBlMZDWCVDyiiiq85i9ls1JXAlmgoW6Zh1hHOskTyFNA+PksVBWCPRLGLrvp9xKxJTfkU0EP/VLBbIdbr+rMiv/jc9bVX2hYzcm5p27gbuzLikr0dvTA6iuBlKVE4KES0+1DQIB2ICfE3dQtLfaLZjI+98B5U7edL9tm+vAAoo/hD5chzNCDe12r7+LraJxsmnu8QQDz6Te4oJpFQsCcsyoxklnBOE2TwoJF8E9sa2BMxvPfJk9Ku5E3Seguruw5Hfgcpe0d8l3xq5SR5ZcaYt6LmwQXMjRhc65ocnuMFEw9EfCpRGyDw52L4TJsalvClS6ZNbiaERfNm0frU2ZuFsB2hwJpVQWlYOOdvnTjvr0+0SXLBLNER3zQYQxfqX6MsYdoLacc8wYP94flC/sdf0yc3sY1q0Q+4rylxGxkju5uIDQ3N1Mna67Oe1132vgz4rxXzcwWV0gpkOzA5NnPtUecnEeRKZArBVhkr3Zj/jIDfVXgWdtRZMr6CGzW
 PRk8/OY9
 sb7j1hl4a7yxD5pawbpxM5txOvItWKrePUT0dWV3EVxFWD8kiStDwPckdQ9+IyRPSMb0MJ6nXIqNGm2lKUblC3drlCkbfYPe0LWaaeWioznc+UUBL56rZbZQRozajfSM5B2l6bLBffrc/GIi0hlc8PeDaeAEshyNBPBtTluyLxphlveeeYjXM0HWM2tp5Cj/mT6FbOnVKqbPJQP5gaBZ/wx2ym5HjVFx+/GPHjyOeOkC2soD7s8FEA9FPUlDsm014LRW2tU3Ych0A64hsVGeoPrQ1TA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 03:39:18PM +0100, Matthew Wilcox wrote:
> On Thu, Feb 19, 2026 at 03:08:51PM +0000, Kiryl Shutsemau wrote:
> > No, there's no new hardware (that I know of). I want to explore what page size
> > means.
> > 
> > The kernel uses the same value - PAGE_SIZE - for two things:
> > 
> >   - the order-0 buddy allocation size;
> > 
> >   - the granularity of virtual address space mapping;
> > 
> > I think we can benefit from separating these two meanings and allowing
> > order-0 allocations to be larger than the virtual address space covered by a
> > PTE entry.
> 
> I actually want to go in the other direction.  I once came up with a
> name -- POTAM -- which stands for Power Of Two Allocator with Metadata.

... of the House Targaryen, the First of Her Name!

> The use case was something like XFS's buffer cache where we want a
> filesystem block size of data (so 0.5KiB to 64KiB) with some metadata
> attached (xfs_buf is 664 bytes with debugging enabled!)
> 
> I set this aside to work on folios, but folios offer a back door to
> unifying this with the buddy allocator.  It's a long road, but here's
> a sketch:
> 
> First, we separate memdescs from pages.  I believe this lets us shrink
> struct page down to 8 bytes (previously presented as various LSFMMs).
> 
> Second, we get rid of 'page' in things like sglist and bvec.  This is
> already in progress for various other good reasons.
> 
> Third (this bit is new), we replace memmap with something like a maple
> tree.  That lets us lookup memdescs by physical address (typically
> a memdesc will contain either the physical or virtual address of the
> memory it controls).
> 
> Fourth, we change the unit of the lookup in the maple tree from being
> a PFN to being address / 512 (or whatever size we want to use as our
> minimum).
> 
> Now we can have memdescs for an arbitrary power of two which means we
> can ditch all the awful code from ppc/s390 page table handling where
> they try to share one memdesc between several different page tables.

I had similar, but less ambitious idea. Can we get this functionality
from slab?

Maybe having a kind of kmem_cache that would allow to have metadata for
each allocated object. It will be backed by two slabs: one for actual
object and one for metadata. Plus some glue that allows to translate
object->metadata (not sure if reverse is required). If both object and
metadata are power-of-2 it should be doable: pointer to metadata in slab
page plus some math.

But I have not thought much about the idea yet.

Your idea is much bigger and I don't understand implications yet. It
seems redefining basis of memory allocation in kernel. Do we still have
page allocator? Where page allocator ends and slab begins?

But sounds fun to discuss it next week!

> It's going to be "fun" avoiding allocation deadlocks where we want to
> rebalance the maple tree containing the memdescs ... that's a five year
> away problem.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

