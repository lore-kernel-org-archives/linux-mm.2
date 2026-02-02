Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC800D172B0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 07:44:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87E786B0088; Mon,  2 Feb 2026 02:43:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82C766B0089; Mon,  2 Feb 2026 02:43:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7380C6B008A; Mon,  2 Feb 2026 02:43:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64D6E6B0088
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 02:43:59 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EDB1413A2A0
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 07:43:58 +0000 (UTC)
X-FDA: 84398727756.11.6B57EE5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D62AF1C0006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 07:43:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HVcBQxLT;
	spf=pass (imf20.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770018237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8kpHK17s1Z6xz3JjVRVavy0ExWhOFP+85VyJ3RdlE4w=;
	b=2XgcXUIqiIhCgFxsDpeqO8usN01RmLAzwMr6f90d83VD5NwNRa0DvXPTGomUjoe50bTtkA
	aB0tj5HnP+WwAGRwYgzdE9yukxhPvWagsXVACTpQqUAw4xmyRmghHb7nW8rHESlugJVUkg
	NMxFwAZQGqIsdFofq3Ty7eMQ38qDdP8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HVcBQxLT;
	spf=pass (imf20.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770018237; a=rsa-sha256;
	cv=none;
	b=1LN/R1qgPt14fMTb+HBFfFaynUcGJ2oLrw8xKoMxRZM4+Yj49ptu9m9K84L3JDgByzFmom
	1hoTZnl3+O++NzKB24hzIGWd+eoFJa3A5+qL+jboLRZ+pPRQMR3mmGPbB1xsqOhwifrr4R
	ejz6ToMLrc1550+pirpcpIsvPscXHaE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A178241A49;
	Mon,  2 Feb 2026 07:43:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46641C19421;
	Mon,  2 Feb 2026 07:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770018235;
	bh=Wx6zDnajmZZdgiHVlWIKBs8yudA1QP5iyWHbsFAQdLQ=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=HVcBQxLTn4UjZnq7J+5Fs086qlBUOTmwv7OeLyww2/ZP9HTfRqVIzU4MbogF/6VJK
	 FgrMjRkWSai0c7nyHtgK168o+hUiMKPXL0E+z165pmp0qg1fuvFZQ38ewrq1IJJNmm
	 6lG6p131ma9B+4EfA/Y5DERj+RODI2MNXbxm6Ya8hIpQKxKYB1qWzpSbvzzFHDAJbm
	 uNmcN5RJCYGUw4W7oFb5uKjfs1K3BxV6GtetPuP98VeubJZb4lt76xz9KHcvflZ1Zr
	 cKUjxYwQa8atrrj9ss3YAFhPrt+mAso0zAYmP3A+fsq9fiZXEbLV8HMn46vvVCZ6Dz
	 pk4HUFy1KZ3Zw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 54B85F4007C;
	Mon,  2 Feb 2026 02:43:54 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Mon, 02 Feb 2026 02:43:54 -0500
X-ME-Sender: <xms:ulWAaStlknjTrDUWdERH9gRRoaSapAK41Km3o1tsqdI_p5u8sj4TPQ>
    <xme:ulWAaSSJbEbY2KvtploRNTV2Y62CJO9JctCpTAzZg71odj0SkBYa2i1c1uv4Qps4H
    T2Ln-zTC3qC8ia_kjsEctQEv4Di-UwQoBHIoDRRvqPuyEuhnS7_Yn1k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeejtdejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeetkeehudehiedufefhjeeiffeugeeltdfghfdtffeftdeivdehhfefieeu
    tedttdenucffohhmrghinhepphhrohgtrdhssgenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegrrhguodhmvghsmhhtphgruhhthhhpvghrshho
    nhgrlhhithihqdduieejtdehtddtjeelqdeffedvudeigeduhedqrghruggspeepkhgvrh
    hnvghlrdhorhhgseifohhrkhhofhgrrhgurdgtohhmpdhnsggprhgtphhtthhopedugedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheptggrthgrlhhinhdrmhgrrhhinhgrsh
    esrghrmhdrtghomhdprhgtphhtthhopeguvghvrdhjrghinhesrghrmhdrtghomhdprhgt
    phhtthhopehrhigrnhdrrhhosggvrhhtshesrghrmhdrtghomhdprhgtphhtthhopegrrh
    hnugesrghrnhgusgdruggvpdhrtghpthhtoheptghlsehgvghnthifohdrohhrghdprhgt
    phhtthhopeifihhllheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmh
    hmsehkvhgrtghkrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgu
    rghtihhonhdrohhrghdprhgtphhtthhopehlihhnuhigqdgrrhhmqdhkvghrnhgvlheslh
    hishhtshdrihhnfhhrrgguvggrugdrohhrgh
X-ME-Proxy: <xmx:ulWAaXd-c82xllHkjEfnMapa4yE-fDVMzEQNGOXkNVE_WY6yEmkAhg>
    <xmx:ulWAaXnXtIzo5E2r4L2IbfA2fKc1x4AXhdXQUznZ3koN8Fh6qn7cdQ>
    <xmx:ulWAaWoU6aCVYlM8hYFj2rZAQiQXmVJV0_WLy5mvAKNNASWViRJdvA>
    <xmx:ulWAaUERtMTwuQR4-pmODvqa5YD-RYmzqvjCIEQ5PQLRvVBCt1uN7Q>
    <xmx:ulWAacTDQmKAc3SsySmM-bxpbQhloUzG_f89gqScbXpnqzC-tu8C4Lja>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 28379700065; Mon,  2 Feb 2026 02:43:54 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AF_iGlW-huzg
Date: Mon, 02 Feb 2026 08:43:32 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Arnd Bergmann" <arnd@arndb.de>, "Yang Shi" <yang@os.amperecomputing.com>,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>,
 "Ryan Roberts" <ryan.roberts@arm.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "David Hildenbrand" <david@redhat.com>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Dev Jain" <dev.jain@arm.com>, scott@os.amperecomputing.com,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Message-Id: <bf94fb74-d391-440c-a90e-1346312328c4@app.fastmail.com>
In-Reply-To: <fd18c462-60ce-4dc1-9877-2a1d162d5879@app.fastmail.com>
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <20250917190323.3828347-5-yang@os.amperecomputing.com>
 <fd18c462-60ce-4dc1-9877-2a1d162d5879@app.fastmail.com>
Subject: Re: [PATCH v8 4/5] arm64: mm: split linear mapping if BBML2 unsupported on
 secondary CPUs
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D62AF1C0006
X-Stat-Signature: ia65hu4g1mupw198fdaec9ygwjpzqef9
X-Rspam-User: 
X-HE-Tag: 1770018236-702952
X-HE-Meta: U2FsdGVkX1/QMKbJwHzubuPfPzc1C/l4s48PVkOdUMlBYB1I7UvK9WJl+8dB/Fr4q1ANeeDNP9UMWBEWQ80VzayaQ2asMFzr6Gr0tnQOp8wIK5CPbxSLoir/oh4wQAEpPsm2bXJ/U9OzrzEWn0s/D535dAEFbFWTuLYuoYx5VF9iSRfJvTQpOd/ti2BJDVH4h21JeU+DeLqVx5f4yahxr9wcPq4SA+8zzn1i3Vc7U0aZvpM+iWG2ffIGO4XfHadzMiA66bC+jXC9KgTTwmQ2kuBuaVrsOqzExOwIbv+WED+3GpZmkVH3aKEcQTW8l6sHBOpvF5Ym17+PZEn8E+MNafLOpQPcrCtxhMVVxqh+0kpKvifzBoHrewx2r93an03i0UtLvvNka1Wx25+JpHv8igY6UzU8DAGdYxu6ouu64Sr7udIstIwj5ih4AoJss1mUrYxL3QC4nlI8AaKy5yeRPzhLF+f7RZZpMPC9WsSe4+elrn7YkvqcnwFPdJJ4Mly4Zm7NxpvFlRhTcqjhip+jPMEmaW64uBZmmPdktCOXd5lcWruXIb2lFFgI0+t3ZJPPnJIqMXEu0HfeqCyXf5/UBZ0/w3fQglZWbr1WSPD+cVJ471Sm/j+fbrs3lGPJDDdrjBuN4BlfNA54Tk5sTleHirt4bBZ4dlvtFPCxlyXkQGN7vacvpk6VpK4r6hrYET/dOg0nvUoNg/3mUlRkljfDFtFdRz9fWejpJ0AcwXu+XRz2WFkX2WTjFCrEzdQ+vxsBEg1dIfnnIG+LDDNpQ3P9vCKJ7/wSUiqh/Van1sZrLKHkj2fv8ySPJ2UHACmFW+LrWlyVG893xn2B0Rrm1WJ1CdlFnLZZcEH9XCBkb5d5LE9UZIKAtrOhbj91+Yvb0tXKxTzGnuY5RBwMDjcu0CIP7L/elWl5A2rChmICtu1ece2cL35kgGRbuTxT18KK7X+S0Bo8sdrWaSbx7F8fXXF
 Vw1oIhYA
 zpftKdPH/Hk7yJWph8Rl4NF3yE80lI2SbjhvK+8gz/Q/R3CTf7C28IqT5eGemMEU+BYShEjStD+Bxns3z/YxA48C2xSWTR8TOEr9bJSx96LrpNyIoiJzYBq0TXwTXkYdJsFc/GgXj/bm6sBPm7ladEBUHurjCLzBaNClbgsi/zBWVTjuoXGWh1kam6S7aKKgzRYDU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Mon, 2 Feb 2026, at 08:18, Arnd Bergmann wrote:
> On Wed, Sep 17, 2025, at 21:02, Yang Shi wrote:
>
>> +	.pushsection ".idmap.text", "a"
>> +SYM_TYPED_FUNC_START(wait_linear_map_split_to_ptes)
>> +	/* Must be same registers as in idmap_kpti_install_ng_mappings */
>> +	swapper_ttb	.req	x3
>> +	flag_ptr	.req	x4
>> +
>> +	mrs     swapper_ttb, ttbr1_el1
>> +	adr_l   flag_ptr, idmap_kpti_bbml2_flag
>> +	__idmap_cpu_set_reserved_ttbr1 x16, x17
>
> I'm getting build failures here, using CONFIG_CFI using clang-21:
>
> ld.lld-21: error: undefined symbol: __kcfi_typeid_wait_linear_map_split_to_ptes
>>>> referenced by arch/arm64/mm/proc.o:(.idmap.text+0x298) in archive vmlinux.a
>
> I can get it to build by using plain SYM_FUNC_START() instead of
> SYM_TYPED_FUNC_START(), but I have no idea if that makes any sense:
>
> --- a/arch/arm64/mm/proc.S
> +++ b/arch/arm64/mm/proc.S
> @@ -439,7 +439,7 @@ SYM_FUNC_END(idmap_kpti_install_ng_mappings)
>  #endif
> 
>         .pushsection ".idmap.text", "a"
> -SYM_TYPED_FUNC_START(wait_linear_map_split_to_ptes)
> +SYM_FUNC_START(wait_linear_map_split_to_ptes)
>         /* Must be same registers as in idmap_kpti_install_ng_mappings */
>         swapper_ttb     .req    x3
>         flag_ptr        .req    x4
>

This is not the right fix: the indirect call from linear_map_split_to_ptes() will be instrumented, and so it requires the CFI annotation to precede the function entry point, which is what SYM_TYPED_FUNC_START() is supposed to emit.

The typeid symbol is injected by the compiler into every object file that takes the address of the function in question, and so the fact that it is missing seems to suggest that linear_map_split_to_ptes() has been optimized away entirely. Could you double check arch/arm64/mm/mmu.o if that is the case?


