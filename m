Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 004A0C53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 13:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1241C6B00F2; Mon, 27 Jul 2026 09:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F9186B00F4; Mon, 27 Jul 2026 09:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0125B6B00F6; Mon, 27 Jul 2026 09:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D52FB6B00F2
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:22:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F10C3A0768
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:22:52 +0000 (UTC)
X-FDA: 85034621784.06.0167B95
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf02.hostedemail.com (Postfix) with ESMTP id 576F280006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:22:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=oHxrOk0d;
	spf=pass (imf02.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785158571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mB3rVl4J/0dZRKiZaqA8l1qOdT57Rk7hhvrQccsk7m4=;
	b=nyK6tPPxkHa0mZEscENVflhoY32DpfuS/TFXO1QlZy5blUCdUJi2UqdJ1yGdzjRPYPfrAP
	bY5rPNAsV3+Alx851ZtWmExGJf+17qUHH9CTjuUgzbeesHnk3c6HlHOjnX5mOKVv8lbgCW
	hTHlViLdZEtDvNVtRwt++A0WT4UYsWI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785158571;
	b=fkN5or5l/MO2xaotXjv1C5ZI4SKbuJ7kqT4tPOJp5MnLKvtsyrybT7045BqbE9Af5YNWFj
	HtRkQvrQ513neXNh86jSFNQ9lIJ8gJPjeqA8Vg/RzscJWRbX9szDCeZKxOAQNCq2q00fph
	tQZ4SFH7BtyIZhCx6NVChR/JXsy/Cuo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=oHxrOk0d;
	spf=pass (imf02.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mB3rVl4J/0dZRKiZaqA8l1qOdT57Rk7hhvrQccsk7m4=; b=oHxrOk0dF/P4m32D0E6tqtoBi4
	IRjcQOCZ/9k1CGQtRAQsNUYaicVPx8mhPiS7+ODexGP5CZfYto4bM7GCcr0LHGHc6o/Pz7Sj15aDw
	hlDvzUv+jTmXKYUmSu7M7LUGovRMwDSbcFwG/s4WtLcBBFzbJ/sJjdOSNegXZvouf/GWRYQZaCSSW
	mwpE3Stkyotby4ASAsARSjzl3m2ovpL0w2/Y4KVg7KVTpUyn1EwH0fMWmSqgpiY0KqpfLajHWfrmv
	oXtbj4EDVmUmWCEdZr+63Q+Khpuarq6kDfZdqotB1WuIZI4si7StacMH6JweoAhZt4ahwuBwEuNVm
	74DW9rCw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1woLHn-006vOX-1M;
	Mon, 27 Jul 2026 13:22:27 +0000
Date: Mon, 27 Jul 2026 06:22:14 -0700
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	rneu@meta.com, riel@surriel.com, caggio@meta.com, anilagrawal@meta.com, 
	rmikey@meta.com, linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH RFC 0/3] efi: mm/memory-failure: keep hardware-poisoned
 pages out of the next kexec
Message-ID: <amdVuOO_6aCxMkA2@gmail.com>
References: <20260717-hwpoison-kho-v1-0-9c5eda551998@debian.org>
 <amDHmNWfQ8eid9jH@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amDHmNWfQ8eid9jH@thinkstation>
X-Debian-User: leitao
X-Stat-Signature: b1uppbnc4opmn33cy89mxnydw1945axu
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 576F280006
X-HE-Tag: 1785158571-576387
X-HE-Meta: U2FsdGVkX18/OjL18gAli2xSEIbpnc6MlbjpsL2lGLcccqKB++sJZy2vki9Vu91jahGecY801OyePJG43B62pRJzsKUL7PHpabgE8lffAwCg9CFv0v6cFB3HKqs8tJtbZVMMgfc/XHBZFJRIV4cw0ZC8Ra+jHtGAByv5EZhEW9/2542EAFHk52PeO4WVoZBUXjWS8ZaQck2slYeiR2dAk6ZzXOBhdUf9uavUVkH9F9WSGezHGCgVHO/I/4OJfPHTHQGRg82XjNINyr0x6Jkoo/4gmxtIaAfacsPQe8L6BbJwRxbQI5aUBNNTr3pPOfoqzDQtzdfTrQsaOsusdyNPr7ZSn0ztOVDIqjmDXjxePZ54qMW1mGsUAyns9mTXO7WT12I+b344VCrAUeGBG1S6bmlJjvLraq08T8xRiqxlhN27NtqqfQZER9fX4zKoUK7CaIKqInafLNHCvxlyHJynd/H9R3cOsncGn3ItT2E93u6J2W5bmcIC+6xHxkeZeaQadyNGmt7HAifpMrWUPkGgoV8NqTrQb8IIYbEYqXnzwtC+XdBT54YqQO9CknNrO0Is7QbhgqtDac8CYVtZN6Q5opyQ1mc/iWE5DGNXSSewi2fogxhhvNyDt2UIbSLZprE87EwUUUH+ub17MuZmGKFfWnQLFHw4AdEdOJW2XQo4CuIWN9IhZS2wPai+/bMTyIiXX30Shch+1SUpegchgx/GeB4xU3eeIeIlPTIq4Nu/Rj8F1j88SgNkshwdzkKYG62LM17KLNqlr8qV6V+g4ytAPxJwQgG2NWfspUVyfCnBU9Db9HtEPdQGuvLD/Kx6UftcUpBgt8zwl1uYe8FkTR3OoKl59BqUockBevyOgYlHZ8saYzAudO835hBiq0qsXin1X2vKTghftwDUM8KYUgNRD44iiqyr/JrV3LHl/8Blr/eXJvyT8yueIWvrLT+7cd2dC7g0VHONs0XO2rU+NQt
 S/M6HAzB
 iBKpj+kbnFH3pj4+Un/kwGZP9QbZAiGz14dCYjfEBrHQ5OFsA4K5rF/G9djERTbSHGago6tWFbLvV8TwjB16Z+W2pNXRdS4sikY7TDcHLe1f27oEOXKv/yZAyfHPurWRE8Lvg49A1aggEIi89ZU0vffH7nXcuiy4y54xR8ES1SaRsLdT3GUHa2+iklZmCuI0n0TdRM+3XtctYBHvsyrRCytHNa+Fm/ChddE3z1NSeW2014K6TRUDoBSb5jQTKcVom7xg4BZmWJ+Si4eTJZzfrCAYNfxmy7MF6wvM4sHi1p5Fch7tuKWkX19STbrzgfBNRkXjqrR5LRdglu98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 02:50:18PM +0100, Kiryl Shutsemau wrote:
> On Fri, Jul 17, 2026 at 07:03:02AM -0700, Breno Leitao wrote:
> > Problem:
> > ========
> > 
> > When a page is hard-offlined due to an uncorrectable memory error (multi
> > bit ECC), memory_failure() sets PG_hwpoison, unmaps it, removes it from
> > the buddy allocator. This information is not carried to the next kernel
> > that is kexeced. The new kernel kexecs and trip over that bad memory
> > bank _again_.
> > 
> > Why now:
> > ========
> > 
> > Several industry trends make this increasingly important:
> > 
> >     1) DRAM is getting more expensive
> >     2) soldered / on-package memory (LPDDR, HBM) is becoming more common, so a
> >        failing part can no longer simply be swapped;
> >     3) memory is kept in service far longer (at Meta, DRAM lifetime is being
> >        drastically extended).
> >     4) It is more and more common to kexec instead of full reboot
> >     5) Increase of memory per system with CXL
> > 
> > Proposed Solution:
> > ==================
> > 
> > Carry the poisoned frames to the next kernel in a new EFI configuration
> > table, LINUX_EFI_POISONED_MEMORY, modeled on the existing
> > LINUX_EFI_MEMRESERVE table.
> > 
> > EFI configuration tables already survive kexec: firmware hands the EFI
> > system table to every kernel in the chain, so a table installed once is
> > seen by all successors without a new handover channel.
> > 
> > The mechanism is architecture independent, so x86 and arm64 use the same
> > code.
> > 
> > The EFI stub installs an empty table while EFI boot service is up. A
> > configuration table can only be created there; the running kernel can only
> > append to it.
> > 
> > Each hard-offlined frame is appended; an unpoison "removes" its entry
> > so a frame that is good again is not carried forward.
> > 
> > The next kernel walks the inherited table early in
> > efi_config_parse_tables(), before memblock and the buddy allocator are
> > up, and memblock_reserve()s every recorded frame. The bad RAM is never
> > handed out.
> 
> The allocator is only half of the problem. kexec segment placement
> doesn't know about any of this: kexec_file picks destinations from
> System RAM resources (memblock on arm64), and poisoned frames are only
> ever removed from buddy. So the next kernel image, initrd or purgatory
> can be placed on top of a poisoned frame -- the relocation memcpy then
> consumes the poison and the machine checks during the very kexec this
> series is supposed to protect. Same for the table's own list pages:
> overwrite one at placement time and the next kernel parses garbage.


Agreed, and thanks. This is real and, I think, largely separable from
the cross-kexec table -- the running kernel already knows its own
poisoned frames via PG_hwpoison, so excluding them at load time protects
the immediate kexec without depending on anything carried across the
boot. I'd like to tackle it as an independent change, let me do a PoC
and see how much change it is. I suspect it is less than this one (and
probably nice to have even if this series doesn't end up anywhere)

> Hooking num_poisoned_pages_inc() also means soft-offlined pages are
> recorded. Those are functional pages, offlined predictively. Turning
> them into permanent losses for every kernel down the kexec chain does
> not seem right. I would record hard failures only.

Yea, it seems that action_result() is what we want instead of
num_poisoned_pages_inc()

> On the data structure: I am not an expert on DRAM failure modes, so I
> went reading. The field studies [1] say roughly a quarter of DRAM
> faults are multi-bit structures (row/column/bank), and the address
> interleaving means one such fault shows up to the OS as many separate
> 4K pages. A row fault lands in a window of tens of KB to about a MB; a
> column fault is one bad line per row, strided across the bank's entire
> footprint -- potentially thousands of pages scattered over gigabytes,
> reported one MCE at a time as they get touched. DDR5 on-die ECC hides
> most single-bit faults from the host, so the visible mix shifts toward
> these multi-bit modes over time.
> 
> If that is accurate, per-4K entries have no natural bound, and every
> entry becomes a separate scattered memblock_reserve() in every future
> boot.
> 
> I would consider a bitmap with one bit per 2M instead, modeled on
> struct efi_unaccepted_memory: the stub sizes it from the EFI memory map
> at cold boot, the running kernel sets a bit on hard offline, clears it
> on unpoison, and the next kernel reserves set units. It is one
> fixed-size allocation, so the whole grow-and-link machinery and the
> chain-parsing trust problem go away, and a row fault collapses into one
> or two bits.

Thanks for digging into the failure modes -- that matches my
understanding, and the bounded, chain-free bitmap is appealing for
exactly the reasons you give: a row fault collapsing to a bit or two,
one fixed allocation, and no cross-kernel chain to trust.

Let me hack a PoC with a bitmap and check how it looks like, let's see
if that looks like smoother.

--breno

