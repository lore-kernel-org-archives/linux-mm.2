Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA78FEDF176
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 16:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 575DB6B0005; Fri, 13 Feb 2026 11:19:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523E96B0088; Fri, 13 Feb 2026 11:19:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 419086B008A; Fri, 13 Feb 2026 11:19:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3196E6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 11:19:24 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF553C209D
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:19:23 +0000 (UTC)
X-FDA: 84439943406.02.6495FFB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id BEB5C140003
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:19:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GfjFOyqp;
	spf=pass (imf09.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770999561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=94XdsZU60Ubc9tHz789LHbhYyiQYkhqrpL4QJs1PIX4=;
	b=DkR8vdho88Gt1esxDA0hsrpPkqMKlLWXllBiUOy8VmC7TK0ns5bicy4n1I9tcoOvzVvcK+
	xG7eElZ0hSwEsuCMCAmmm3QRpSkfVWnXkkxHqOkk3wbQe9mfA32op7EqNbfJJZvclAaHJ4
	voqJ2BZugmzEqkkJ1+2IeIhrUuSuoes=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GfjFOyqp;
	spf=pass (imf09.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770999561; a=rsa-sha256;
	cv=none;
	b=RTHYhI2cABg2A3Rl1p5emOzD4fVtR4gz4gAwliEe7867iyZG8mjWJi3JB30jmWEjjTSTYd
	xvk1ldu4NvKQFpNMJWMSYJQOBLyVIod41FBiVS1zF8eC9hgv7Pwv5FhzelWGDk6GTOnI5Y
	foW/FVRLEKYsX+GRifIobhLqddyPvH0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EC1E96132E;
	Fri, 13 Feb 2026 16:19:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209F4C4AF0B;
	Fri, 13 Feb 2026 16:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770999560;
	bh=6wn8Lo1FQZGQiBYxgE6s5N3YCrutqKmZ719Y7h4CCRg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GfjFOyqp/Vwv1QzfzshF2QizgRGwVI1ffbytrt5g0MPfm9/1CCts3iJuvJ4pK/O6Y
	 LWYyCcZIf00lWyM+ko1o7Fd35ItJHuIl/QW6BbtwIufXyGnsz11+P4U8rEjpObKjoO
	 VN4RORDBX0ALSP+9Ci6Inlo2H68SGxz7QJ2uSziFJioGccPjMzOF/rHV6uu94m92i/
	 dAiLaJV1gOW5GPynoSBwAISXgtA+39FUgWEHOaoeIWVrMJkfAYqft1Fz7RcnzVPJtG
	 gBu6QJW0FHx+myJ4rTCb+/X5e3KAbyyCLSkxru2DyTaskeOlRNz8ISQTeYLxR01YBe
	 wPGMnrW7F6Naw==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4309FF40068;
	Fri, 13 Feb 2026 11:19:19 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 13 Feb 2026 11:19:19 -0500
X-ME-Sender: <xms:B0-PafpkflOTSANspNhJFJG4HD84fhmOJq0JNnXzF_s6WIVopL2uKA>
    <xme:B0-PabAxHGDMbgdg9AwZ8KPILfWd1Wgz-BPqxaOmgrg7StcBS5E_h4xGNiz7O85qy
    nCizerwwCIUxd8ZU1GfwdPw4llG7ut7P6GfKwaWqkp4w61Qj7ndTg>
X-ME-Received: <xmr:B0-PaVcHnEoHlzufV6v8uWKUZkK75iZCC2CyQodwzEHq0xK9rdpGeyGEH3HSRr2z3xRuRozPPTtRSYxa3um9it0XsD1J27zv>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdekjeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpe
    ehkeeijeeggeehkeehtddthfdtgfejueefleeutdefjeegvefhhffgueeiteekfeenucff
    ohhmrghinhepohhpvghnqdhsthgurdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhs
    ohhnrghlihhthidqudeijedtleekgeejuddqudejjeekheehhedvqdgsohhquhhnpeepkh
    gvrhhnvghlrdhorhhgsehfihigmhgvrdhnrghmvgdpnhgspghrtghpthhtohepudelpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopehgrhgvghhkhheslhhinhhugihfohhunh
    gurghtihhonhdrohhrghdprhgtphhtthhopehpvghtvghriiesihhnfhhrrgguvggrugdr
    ohhrghdprhgtphhtthhopegrrdhhihhnuggsohhrgheskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheprghlihgtvghrhihhlhesghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhho
    rhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtoheplhhirg
    hmrdhhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopehojhgvuggrsehk
    vghrnhgvlhdrohhrghdprhgtphhtthhopegsohhquhhnrdhfvghnghesghhmrghilhdrtg
    homhdprhgtphhtthhopehgrghrhiesghgrrhihghhuohdrnhgvth
X-ME-Proxy: <xmx:B0-PabIAMi0ukVs3yBqFnaQ1T4Zvumjsj-uzzkJcSLf69Ud4YxM73g>
    <xmx:B0-PaVtBqECs8RQByCBbhP8hi3n5ZmdsXbXzqmyvsjLvEGdC31C6Vg>
    <xmx:B0-PaVbzIvEfQd6Gh0kcIeWB1DK_NtHYaiPbpf6ukEboRmbun-qqSA>
    <xmx:B0-Pad0xuKtbxBb5rjr44ozCuYS3mPB15R2zFp1rSB5LFfwPlGjKsA>
    <xmx:B0-PaTUBrFxvR51MLnVWA3E0RiUXLi1QcM0eQnePIkqROa5i-sv_eqk4>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Feb 2026 11:19:18 -0500 (EST)
Date: Fri, 13 Feb 2026 08:19:17 -0800
From: Boqun Feng <boqun@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
Message-ID: <aY9PBfx3RRV7rXZ5@tardis.local>
References: <40xUh92AU5E9oFxQrdej-AXVg76jmaWGKXZMLoOHXe35Lw9x_eNEoLup9bB60LyGZ_0USPmoxr-9hE3ujA67cQ==@protonmail.internalid>
 <2026021343-germicide-baritone-efe8@gregkh>
 <877bsgu7fb.fsf@kernel.org>
 <TZXRjQ6gkmJNdRcfDVKKEl8Zd-8b7HBCLMrrPXyXYq9HmsVE8BJS4a6FE-YxxNsOBrIQl1fiOvfS19rLkPSmiQ==@protonmail.internalid>
 <2026021313-embody-deprive-9da5@gregkh>
 <873434u3yq.fsf@kernel.org>
 <20260213142608.GV2995752@noisy.programming.kicks-ass.net>
 <2026021311-shorten-veal-532c@gregkh>
 <aY9HD7nH5A-DtgmR@tardis.local>
 <2026021326-stark-coastline-c5bc@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026021326-stark-coastline-c5bc@gregkh>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BEB5C140003
X-Stat-Signature: 3soxh1u3f5nwwgs9gxmchiqiufqmcdmz
X-Rspam-User: 
X-HE-Tag: 1770999561-894705
X-HE-Meta: U2FsdGVkX1+sWFhhPNf27SfdHfjUH6A/dJL4tpdkuc/bA2/3i1U/DwKV6YfGtnwP7zKEIIh09WYIeFERiUB8uL1eal/RGZUM4GuN2gi+gDqbh3zD4MiuMS7dq4Oj58faRaIBbdfXnBZaOi5XXzLFX9lK5nK4l5heoLGEBvGEPk4u3N0Li4qQV1VdZ8JkYoqC6T4huvWxYxVChhrw5pzLrykwl0/LLk/L/+lZfpgsH/LnspXLb95AfRRqq3gKGiigTRqDhF4s9bZOCkAFIb9i8iiUtmGwkyIXRyrjHBPbmMYBxD+Yl1MyWV/9gq6aIhEwdoJRXNeuPvDHR5Pf8romcatKyy3wUG3JIg+tRXYL/aCSDSGXho3GE8dPKUaw+RiVFZc4l/pvWccEvP4MLpmJdhYD+keJS1To26Nhg7m8oPEjQa3QbR1NSXoxz//vuuLuzyTCPrl/yqDGW3mVNAkTEm4KTXGgEdouVGSngK5BDscKQt00if8Rlf+5Pyvs9NYQ08S24uQc9wUOhHw3CbBKNVp2zUzBBuca3IRB3G7eS0zIK1jaQNH74B4cy3XQbQe2WJyMjsYeMACderok1S0h7yFWjGtDJX2E3SEGNgKlEFlwlL4usEEUEZusZSlNMhKXwB1SNiLjE8VzlehydRCDrtH+qrR3zE/QP/onKc8VxoNHodBur/ENEPvsLlMJpoL1VcyC7hGfbzfjuAOrd+ydAudshriMwct5oClv2mStAG09iaGjUt7ygvJuagoNyIaxqOrtpttnmwl67MM5Dy/cT6N7EgkrueRz57zPk9edHu970Gx+8cBzNA6IGDQKNVMpjRYZX8EV/kH2eIlKF6sO/08g8Gq9yBnzeyBIUlFE9kv+VzANw4EkNanfVPT6CJydILqew0QxKkoHjDKLHiVseqS/rGbYII8qmMNoofM25k93pEJV+d9bet7fEGMHpI3foYBt+TCY163hSQXjtSE
 gvd3O5jv
 GB+yg7RlMWU0QSOgLw+YoV/1o0fKGVIoF+bZtyVNTr48rtuBtJFyJshJirP13AqJfSRdsNhrB7LtcnraDaDu9j5uorVyvTdHfQ+B05ZqvSu9AGFMXNjrKuKX7Yt7cN2eQx7WHMfHQfoO1OxIXb2crks0SsvIQ+bw3NrojEf4p0kmuMlgl2jO2IvkyZUufJqNRoZoH06jXIT2dXdZm03srM54Hm8SIZ4i3se6QigX2cAd06lack1nJF2iPBQSf8b9WNF5Fjvz2CmRsVvK+dvE588XAQZh+RSelNMq+MTYWJ5k8lsTLo5Sf6Sg+gRq2W+17hLI181GGn2Nw4FWBQeWgWjquxy/CeEd7m9Q8Hrdl2Bz6hlu0sKDcoFxy6/qHKMqO0M4ME2UIrQji64bd9nvn1bqL7WZ7X1NbaZzC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 04:58:54PM +0100, Greg KH wrote:
> On Fri, Feb 13, 2026 at 07:45:19AM -0800, Boqun Feng wrote:
> > On Fri, Feb 13, 2026 at 04:34:04PM +0100, Greg KH wrote:
> > > On Fri, Feb 13, 2026 at 03:26:08PM +0100, Peter Zijlstra wrote:
> > > > On Fri, Feb 13, 2026 at 03:13:01PM +0100, Andreas Hindborg wrote:
> > > > 
> > > > > C uses memcpy as seen in `bio_copy_data_iter` [1] and in the null_blk
> > > > > driver [2].
> > > > 
> > > > Right. And that is *fine*.
> > > > 
> > 
> > Yes, that's fine because memcpy() in C is volatile and per-byte atomic.
> > 
> > > > > Rust has `core::ptr::copy` and `core::ptr::copy_nonoverlapping`. I was
> > > > > informed these are not safe to use if source or destination may incur
> > > > > data races, and that we need an operation that is volatile or byte-wise
> > > > > atomic [3].
> > > > 
> > > > Safe how? It should just copy N bytes. Whatever it thinks those bytes
> > > > are.
> > > > 
> > > > Nothing can guard against concurrent modification. If there is, you get
> > > > to keep the pieces. Pretending anything else is delusional.
> > > > 
> > > > Suppose the memory was 'AAAA' and while you're reading it, it is written
> > > > to be 'BBBB'. The resulting copy can be any combination of
> > > > '[AB][AB][AB][AB]'. Not one of them is better than the other.
> > > > 
> > 
> > The idea is if using Rust's own `core::ptr::copy()` or
> > `core::ptr::copy_nonoverlapping()`, you may get `CCCC`, because they are
> > not semantically guaranteed atomic per byte (i.e. tearing can happen at
> > bit level, because they are not designed for using in case of data
> > races, and there is no defined asm implementation of them, compilers can
> > do anything).
> 
> Then why not just call the proper, in-kernel, arch specific, patched and
> tested to the end-of-the-earth, memcpy()?
> 

I believe you hadn't read my reply that we indeed call memcpy() here. So
I'm not going to reply this in case you mean something else.

> > > > No byte wise volatile barrier using nonsense is going to make this any
> > > > better.
> > 
> > It's byte-wise atomic [1], which should be guaranteed using asm to
> > implement, hence at least at byte level, they are atomic (and volatile
> > in our case).
> > 
> > [1]: https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2020/p1478r5.html
> 
> Again, just use memcpy() please.
> 
> > > > 
> > > 
> > > I'm with Peter, just call memcpy() like the C code does, and you will be
> > > "fine" (with a note that "fine" better include checking the data really
> > 
> > We are. See v3, we actually use `memcpy()` for the copy (as I already
> > pointed out, Andreas made a mistake in this version), it's just
> > because it's per-byte atomic. What this "byte-wise atomic" does is
> > clearing things out.
> 
> clear what out?  It shouldn't need anything special for a memcpy.
> 

Well, in standard C, technically memcpy() has the same problem as Rust's
`core::ptr::copy()` and `core::ptr::copy_nonoverlapping()`, i.e. they
are vulnerable to data races. Our in-kernel memcpy() on the other hand
doesn't have this problem. Why? Because it's volatile byte-wise atomic
per the implementation.

So here, the clearing out is needed to say: this is not Rust's `copy()`
and this is not C's `memcpy()`, this is the kernel version, and it's
fine not because magic or kernel people believe it, but because its
implementation. The concept of byte-wise atomic at least describes this
correctly.

Regards,
Boqun

> thanks,
> 
> greg k-h

