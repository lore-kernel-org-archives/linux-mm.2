Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF471EFB7EE
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 09:30:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E58E16B0088; Tue, 24 Feb 2026 04:30:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02DC6B0089; Tue, 24 Feb 2026 04:30:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05AE6B008A; Tue, 24 Feb 2026 04:30:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAFA66B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:30:25 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 878A81604C8
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:30:25 +0000 (UTC)
X-FDA: 84478829610.15.D7BC1A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6BE501A0002
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:30:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="knq0yBl/";
	spf=pass (imf19.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771925423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xmPGtMuDFhm5u0osjnYtcj0S3pHXH651JNJMpWmgfE=;
	b=2VYIajwoVo8t8RCPeWL4sbDDjHlf6oWd3aCi7H3qiVWKqLRw3vD7767e1A0i9iU1wnp0r6
	lBOir9zJdr1O/jswr2rBo4ick/NFYiAxeu1CXMT5ILVwG2oqDguXfFUaxNlr5Pp9XSsUoN
	9KguWw2irETq6gbNqEYWXyfXfB8Iums=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771925423; a=rsa-sha256;
	cv=none;
	b=AM7X0HLyCro8jYwUiDE7phPCgrUzaLHKe5RfhqZDFL48U0N2vOecjp9G96dzTNvgGquSFq
	iBA7ndNICUJCmb8I/KtsyW/LH9KtxkWVKaf6PB8UXhZV7niMyPs/6BjBUtc4Sv/qqOQVzh
	ph6vZJQMLwOJvM8HXec3le6s4tjb3iw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="knq0yBl/";
	spf=pass (imf19.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C7EA41B0A;
	Tue, 24 Feb 2026 09:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8E0C116D0;
	Tue, 24 Feb 2026 09:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771925422;
	bh=jbUHpcYlvb7oVyQJFkV28djZCHiGr4saQLNVfd4W5R4=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=knq0yBl/b9+RxkrojcdaA400AQwDSi0RQp8m5WGlP44MhqbXdgnq5RV3Nd2eIbHQW
	 rEQzqLCM0VPOIvbi6Xhr2tufGlvFZ4G8PEXiOa3TkW+gvG03Rc7nnoqKoasYz7uI7n
	 YrqgxN4M5a691hH87KsXMvtmVQGgYr93i2wQfC/0lVxM+Fb/lvNGo96reCTrlloPIQ
	 7L41Yj/Ji08V9vEcl7uIxBaZiTlJkPWprFudC+MOXErGreyIej5GqcEpKr8UeitJdl
	 qUTtnuX38jOXmeTCTZT9Tsbas/wW50e0FnijMfB1cdwNOp8sCzP0+TBivDjJj4h1WY
	 1abvZ9nYLO3rA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id C6939F4006B;
	Tue, 24 Feb 2026 04:30:20 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 24 Feb 2026 04:30:20 -0500
X-ME-Sender: <xms:rG-dac5Eldop4hd5g1rcFphVyAwAIuwE_Nt6AohZkkYhGCz3pw8ppg>
    <xme:rG-daYsz1hog2P-R8OAx-d1AmpL1wdDZBWAy04ov663SMDYfytyzwb1iHS7pTVWhu
    e_IA1HhlKpt-ol2mp9Vz9Os1D3dnEK_JnzX88cowDVQWXfGXimdLwE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvfeelkedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopedufedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtohepsggvnhhhsehkvghrnhgvlh
    drtghrrghshhhinhhgrdhorhhgpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhr
    ghdprhgtphhtthhopehtghhlgieskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepgiekie
    eskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdho
    rhhgpdhrtghpthhtohepihhlihgrshdrrghprghlohguihhmrghssehlihhnrghrohdroh
    hrghdprhgtphhtthhopegurghvvgdrhhgrnhhsvghnsehlihhnuhigrdhinhhtvghlrdgt
    ohhmpdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgtohhm
X-ME-Proxy: <xmx:rG-dabR0f8a3bHnCzMDUtGobFjlTOLKiX67HAt5j3GLFERUelBzv_A>
    <xmx:rG-dacWnLFN1wrnpaEXZ2hPKAPWX-V7nl8t1-OeUPvse692Cqi4geA>
    <xmx:rG-daVIA1upta-g1_ksje9mFW6cZChSXuJ_E3O3ilJAXiJq_uPfgXA>
    <xmx:rG-dadhO4OkjdezzAe3izOmbzXMjDXfWTqn_MpQrG46sxbwTTeshwg>
    <xmx:rG-daSIzM11vfacGtEVN3K-V5PqLX7fKIi7uQvQAXwoiaYUdW35z26-k>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id A1156700065; Tue, 24 Feb 2026 04:30:20 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AF0NZ4OlJH_7
Date: Tue, 24 Feb 2026 10:29:59 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Mike Rapoport" <rppt@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Ingo Molnar" <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
 "Thomas Gleixner" <tglx@kernel.org>, linux-efi@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
Message-Id: <3a01d817-e08c-45ec-b5a7-4a8d9ecd0fc6@app.fastmail.com>
In-Reply-To: <aZ1vWEgJNwc2nrrA@kernel.org>
References: <20260223075219.2348035-1-rppt@kernel.org>
 <b6f4edf5-7587-45d7-b81a-590d4f3d1ddd@app.fastmail.com>
 <aZwyNAbEqb8ZwLUM@kernel.org>
 <e2ad0845-2f87-418a-9f87-5ce619e004ef@app.fastmail.com>
 <aZw8xSI-TM-Gz84t@kernel.org>
 <bfe487fe-6868-4215-b5be-99a0360e9bd2@app.fastmail.com>
 <aZ1vWEgJNwc2nrrA@kernel.org>
Subject: Re: [PATCH] x86/efi: defer freeing of boot services memory
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: bk3dqfcuj7z5m49egdc3bfp9udhzeu6n
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6BE501A0002
X-HE-Tag: 1771925423-314440
X-HE-Meta: U2FsdGVkX1+W50mIlGBuPnVPge3KQ59OqHtNQNtBjdsKRDmrFATNgXsmISPr3ZYztDuo3T+z8Hxb/HC0RB1nDEvD2TlFS19rLrJzJk1x/fcX2UTvw8vecg+LJT73TkFGxR/GUlR1yj72h+vu3ZDjFTMgTXfLF6Pg5gJuFzskDSjPJ0gMGsu6kSihse6huujkgyGM8Yj6HiJzvNL3mYtS4+YL9VI2+l3HFmgSt2pQ/+GQ7Iwu91iypEq7PbXINCnhkRyMlHDm7C4Z5a2Xp5ETEE9RZcDSAqp3iPRKn4ZPVUnCgKxe5+GoH5gnf1oNKqLyWDZQQVxVC8RMVnCQP2mpPPnjq4xZSilFwuyHubQPpDXbhizTZ32go7C6c04JoSHWZM75kpBD2D6c/7D+hhG0C+lWpTCQDudo/FXAPimJhPOE3O2fA5dRMlQBpQ4DSrZUypHGim7IhziS4smzfeTE0FGz+Rpi8vR45l+2vWRUu4CgowjzuBtORXQ9SScBM3ZSIW3iQ4JHVyomSOeB43dUqZrVQvC0JbgCW9HGKZ0JNJ6SajN32Ma12gDTfFqdxLgRhQ6nIxnjtfB5fyrPtr8+rW3cND3kKUc6UzQjcaMVylDSho7P/bodpP7i5uCxLzjaWLVvw2/FP916XCZZWdaMVMgSgZnBh7BB8Bf3PxZhD6377cnkjZ6qtK12YmSd1i/5d+HtwoUDiy5LU/ReVM6bfhacskUyBqtncaD1RwTr/fNqWjsxM/e8X/LTOwsxFc2OETAiObDIIa4ONj8cTR2d3I9auYcwFJIfDWEJxJenyYukxP9pSnsmluBLA5iJFr8QHwTvTE33vTP9GMJZjqxw8sVTeikNIzbWkvKwpcw6+RCCG2wVD1b1tOHB1DxAhLIHau7xHJ9UL+ftMCUZJYnTILMhwd9RGEJAd4OP2BzoBkD0enRinNVQ1GGrjXvO0CZMjzGOY3pJLhkf88M13n5
 o+A5nAod
 Y8mLkp/kyU4UaHXPlXOTZSXzDcXV00uTh5ngwpKEbjmlUXRaIQlTebbwbfzGBhvSZ/h4LaoXNtGv05TCoizRzgfbHRLxs4ka5hIiV7Tpt7AktgIG2pq3ZAW+d1LwGKX8zXQ7Kak0UDUQTIRchRtelGL73GBxKqLidv6er5blKYbAEgaztNWJVEENareHqbYmDf4Yt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Tue, 24 Feb 2026, at 10:28, Mike Rapoport wrote:
> On Mon, Feb 23, 2026 at 01:18:41PM +0100, Ard Biesheuvel wrote:
>> On Mon, 23 Feb 2026, at 12:40, Mike Rapoport wrote:
>> > On Mon, Feb 23, 2026 at 12:17:22PM +0100, Ard Biesheuvel wrote:
>> >>
>> >> > I wasn't sure it's Ok to only unmap them, but leave in efi.memmap, that's
>> >> > why I didn't use the existing EFI memory map.
>> >> >
>> >> > Now thinking about it, if the unmapping can happen later, maybe we'll just
>> >> > move the entire efi_free_boot_services() to an initcall?
>> >> 
>> >> As long as it is pre-SMP, as that code also contains a quirk to allocate
>> >> the real mode trampoline if all memory below 1 MB is used for boot
>> >> services.
>> >
>> > initcall is long after SMP. It the real mode trampoline allocation is the
>> > only thing that should happen pre-SMP?
>> 
>> early_initcall() should be early enough, those run before SMP init.
>
> I don't think so. All initcalls run quite late in boot, early ones just run
> before the others.
> 

It is documented as running before SMP. If that is no longer true, we should fix the documentation.


