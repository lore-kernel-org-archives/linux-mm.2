Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8EDCD79742
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 07:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DFD66B0005; Sat, 31 Jan 2026 02:22:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D446B0088; Sat, 31 Jan 2026 02:22:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C4C6B008A; Sat, 31 Jan 2026 02:22:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 671A96B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 02:22:57 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C3AF1140787
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 07:22:56 +0000 (UTC)
X-FDA: 84391417152.08.AE677B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C62CB1A0002
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 07:22:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CQLiAlJx;
	spf=pass (imf19.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769844174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YL17sh5k9e0S5K+biS+VXLqex4AApnHTirNti4XdFVM=;
	b=8Izeac4PNxALwNIkKNAO5Slq7Cez2jrm4ETEiy5z0aERNW7l88LzIhpX7j/7rZsbEz5+sU
	Ctac5fjBAMXuAMBBr2nT/W6ist2blh9RfLmM3NT0mnsk5T0+ktOLW7FWIzUjXEy1bXrhos
	kXdiBCi+LFgqfBo2fGJD6x95NkEOWDI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CQLiAlJx;
	spf=pass (imf19.hostedemail.com: domain of boqun@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769844174; a=rsa-sha256;
	cv=none;
	b=B3KJpIigkUD8csyvxwQyJygFtqYq0oleuXgWqC6UtJ5dqaUDhiB0k1PdZ/xWxgKZejh/9Y
	+UFik8eU8S6n3ZcGF4Xq04wi0XbHN+KHuX27TUMr19VwpgvzbT8sshe+Er+p/uNADSvnb4
	oqUVHZyBHHnKXo+N6CstxGENAY0sc2c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E27CC60008;
	Sat, 31 Jan 2026 07:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F012C16AAE;
	Sat, 31 Jan 2026 07:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769844173;
	bh=AIqB+Yz0BpkTQP5c/1PNpp0zKhJOID5ar/6PViA+Sl4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CQLiAlJx2/9lBd7BnG4auSBDs3LorTyoRsnoFRDvxsPLPgUYEi+DrKBFG8km/98UL
	 dXJp8oP/tDa/4cFQFXeu0LRAmkhPyX2v4/t3RG/HnfTt7sLfY4zghv+mwZgoBk9ifH
	 WOT5O5HaWsKNwnmw2LA8i0wyPXr0DuwgjZp0zOuFW9LLAZmltOPx/pzMksE7EBJfpU
	 tamQr7RBOQ4jaYmhDzbfKsHwmmZ0lRoQJ5TMu7cTRii4Dvr33ecBDqfpPFkN+jAF5d
	 3kMfPuF//6OplmwYffoZ3DyIpSwRvOi4Gtz/i+NKunQzHcq/OjzFv5yxux56eVCcL2
	 qlAIB4NYS4d9w==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 2D759F4006E;
	Sat, 31 Jan 2026 02:22:52 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Sat, 31 Jan 2026 02:22:52 -0500
X-ME-Sender: <xms:zK19aYxHaWzOEhFYtMWKDAHE8m10XJs1XyteYJ5eGBqnVseKg0Fg9Q>
    <xme:zK19aWpTYKMN3vrWYvlzXHFWsKGmd5IlqGsFbZyLGXSEixgoXQ3zwBCxST4-PAc4z
    XcdVOKCQnMNeb5kFNXzJpFYhQoJ7hd8zKqY86XfDlzT2x65paBq_2o>
X-ME-Received: <xmr:zK19aQdgc5kwN6_WvOEi7RVdCQDRy2Aommo1A7y2ZAESl20OU3w72DFhO7d-EcKqQeIE3WFc-_OPZqbiR0VsHp64pGqHRYUe>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujedufeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpe
    ehgfekuefgvdeffefggefgteeuieegieduffeghffhuefhleegiefhffduleetffenucff
    ohhmrghinheprhhushhtqdhlrghnghdrohhrghenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdduieejtdelkeegjeduqddujeejkeehheehvddqsghoqhhunheppe
    hkvghrnhgvlhdrohhrghesfhhigihmvgdrnhgrmhgvpdhnsggprhgtphhtthhopeduhedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprgdrhhhinhgusghorhhgsehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehgrghrhiesghgrrhihghhuohdrnhgvthdprhgtphht
    thhopegrlhhitggvrhihhhhlsehgohhoghhlvgdrtghomhdprhgtphhtthhopehlohhrvg
    hniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopehlihgrmhdr
    hhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepohhjvggurgeskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepsghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhm
    pdhrtghpthhtohepsghjohhrnhefpghghhesphhrohhtohhnmhgrihhlrdgtohhmpdhrtg
    hpthhtoheplhhoshhsihhnsehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:zK19aRpRQbLWHDyQgntOj6bDEUTSSfESA_7h9_wyHdoRU5i5dQWkmg>
    <xmx:zK19aSnpz3iyfIAkC3WelIP7etHLXc4bllXNYJ0UJsR76qEBzoUZlA>
    <xmx:zK19aaSPd-81iMyCN2nldTmbWfz1FrqeGPURtMxriVdGuzgIV-7BDw>
    <xmx:zK19aQbxCGXHfPP-BcA-xlC9ltqSliupI5CGGXRgv8X6tFpB1zQMiQ>
    <xmx:zK19aS_Tc8lYWGz8H38xV7ZfI0tABuAuapAIF4XYCBQYRUqJdflq8UJV>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 31 Jan 2026 02:22:51 -0500 (EST)
Date: Fri, 30 Jan 2026 23:22:50 -0800
From: Boqun Feng <boqun@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rust: page: add volatile memory copy methods
Message-ID: <aX2tyn9nBUEKM-SN@tardis.local>
References: <a8nHDdzac5l20akcxjjf9w7huObjn4eIHjUI-A17aKEwWl1N-4vvLBiVdqTQbBHwypMIA6gNkzm8YFXmMl44ew==@protonmail.internalid>
 <DG1ZJ1350EMS.1S1360PA496QG@garyguo.net>
 <874io3rwl3.fsf@t14s.mail-host-address-is-not-set>
 <iFJVkpTMbd-NR24OHYTJj8lr4dw7MwCQ9rJWiuRZFgK3JRDhIIAcpf5Z24viL5qHhkrPzpnKfvX7JS6X_VO2vg==@protonmail.internalid>
 <DG20LKAHMXMZ.262Y7NAC1A1Z9@garyguo.net>
 <871pj7ruok.fsf@t14s.mail-host-address-is-not-set>
 <-9VZ2SJWMomnT82Xqo2u9cSlvCYkjqUqNxfwWMTxKmah9afzYQsZfNeCs24bgYBJVw2kTN2K3YSLYGr6naR_YA==@protonmail.internalid>
 <DG21IW5HZV2F.PXTH9P2IO8O7@garyguo.net>
 <87sebnqdhg.fsf@t14s.mail-host-address-is-not-set>
 <aX0lcVngRcRwqgd5@tardis.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aX0lcVngRcRwqgd5@tardis.local>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C62CB1A0002
X-Stat-Signature: gagi7jef79j9r6r9uo3ojte6i9azk8ms
X-Rspam-User: 
X-HE-Tag: 1769844174-46442
X-HE-Meta: U2FsdGVkX19666Z01XD8iiSfFRmdyokT5VGxXP8H4u6W7xMOAArtnxcRT/pgMQgZGXkmGBIhx/V7n6vx6KL1CGW5zyci+QphDLvxozS6EbunOhuLE1iYNI/QZvO+cwhxrad2kaBv5uHUeoLMJ12bznpCjZsy6lZ2Z7pYK6REp0MHjktYLOSD5p90G3VeZ3HBtG2kxFcJk6AJbaogkJUTRyrFHLVUAR7Q0/ZO960q8fj0mm1BvpECJ+JPoOz+pHc7/2PB3RhAx56oAN4WE6/uPC0r3u574sy+4DZVOsG3/p+QOVVw7KeZkdFQcKQmeKoUl7r1QeR+Rerq6CipJDNIdTkgIzNvv+uXv6xeuGkRbnjnU+wf6sFg6E6aR59SgMBxspyw8kcZabcSzJxRD2iUZJI0D+jx1deJ3IPyjsa6SRFfO17ojPy3gzqXH5uLWKmEnz1Lnn6nG3ezxMQz1X33hxLXmS5WZpHEf9aco2Pjn4J7iAuKKkj91GkP2tsGYW0ftll+CylXVsuoDbhNbkK2wYGmEz+Pxa1DXZlG8wlLN41dRNn6eEeHPFeKQEZzxv2QxP9TwPNbjZZg6Z5JfZscrQ40Z/qHN7PNWYRdFn4gDPPyWTFw2ZFIRzf+/Us+tEyNSee34anosCAzuqWJRAkww8gnbIp6G5fMNJ/w1aymYvLp2PJruJ7Dd9Yv1QbaeBjTtvuKt4l9y+T8j5JTChP5bTIDFWUPKT6q+wM/CN2lyAt7hEWmBthFJ+LjsVTHxn8HddQhKS0YfGRuBXXk1oDoz/5Qyph6xQFK2ZAy5F2qAaLz1BiQrPiky1ata99fVH4FC7lqFGHewwPjfn7b6NxpjAWO7R6A+njfrraCQGGugb9xzhC4WSMbFNz3/1g1086RMNFWNMOHnrEUzxqOa8rKrtPhIozY/t3eDC081ybG++7aBB84qGewm0lCMeb0BXQkN/q4sdZWUA5dPdQENAQ
 DlXWqxIx
 EbbGGrfgverjz79+agLpwYCLxcq4yfXze2d+Iy81S2r8kMmNAS3K8wyyipAdV7sZuJOnDlXLPi68g6ZLTRj8gJ9PTiCMHRoGvSYKNsvXNwFYfxLpvAdqu9MwLT2CMOG49ywM0KCrIFBDQWhl2uAKTxPHmMu9BS/Q8rINp0nmsDS/zBse+yoRR+D2zrgXzlOv2Vrr/de+8GmTkzak0qtzT6sr3kJE8yiHHdpL1QttAJ8yCm2n0qvB1ASvChmeXRW9E9qrRosvQR1e2Vtvxc1At3KNUq/tKS73haU7JslSLrilbFvILBqICGIbZrsEVHoWFEcOKuhzWoOwBne12Tl4tFHA5KEC80IPXNs7GkbkwA74Wf0Vv3mEAqfZlEoLPwyeHIOoMNaPnJJxETVo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 01:41:05PM -0800, Boqun Feng wrote:
> On Fri, Jan 30, 2026 at 05:20:11PM +0100, Andreas Hindborg wrote:
> [...]
> > >> In the last discussions we had on this, the conclusion was to use
> > >> `volatile_copy_memory` whenever that is available, or write a volatile
> > >> copy function in assembly.
> > >>
> > >> Using memcpy_{from,to}io is the latter solution. These functions are
> > >> simply volatile memcpy implemented in assembly.
> > >>
> > >> There is nothing special about MMIO. These functions are name as they
> > >> are because they are useful for MMIO.
> > >
> > > No. MMIO are really special. A few architectures require them to be accessed
> > > completely differently compared to normal memory. We also have things like
> > > INDIRECT_IOMEM. memory_{from,to}io are special as they use MMIO accessor such as
> > > readb to perform access on the __iomem pointer. They should not be mixed with
> > > normal memory. They must be treated as if they're from a completely separate
> > > address space.
> > >
> > > Normal memory vs DMA vs MMIO are all distinct, and this is demonstrated by the
> > > different types of barriers needed to order things correctly for each type of
> > > memory region.
> > >
> > > Userspace-mapped memory (that is also mapped in the kernel space, not __user) is
> > > the least special one out of these. They could practically share all atomic infra
> > > available for the kernel, hence the suggestion of using byte-wise atomic memcpy.
> > 
> > I see. I did not consider this.
> > 
> > At any rate, I still don't understand why I need an atomic copy function, or why I
> > need a byte-wise copy function. A volatile copy function should be fine, no?
> > 
> 
> but memcpy_{from,to}io() are not just volatile copy functions, they have
> additional side effects for MMIO ;-)
> 

For example, powerpc's memcpy_fromio() has eioio() in it, which we don't
need for normal (user -> kernel) memory copy.

> > And what is the exact problem in using memcpy_{from,to}io. Looking at

I think the main problem of using memcpy_{from,to}io here is not that
they are not volatile memcpy (they might be), but it's because we
wouldn't use them for the same thing in C, because they are designed for
memory copying between MMIO and kernel memory (RAM).

For MMIO, as Gary mentioned, because they are different than the normal
memory, special instructions or extra barriers are needed.

For DMA memory, it can be almost treated as external normal memory,
however, different archictures/systems/platforms may have different
requirement regarding cache coherent between CPU and devices, specially
mapping or special instructions may be needed.

For __user memory, because kernel is only given a userspace address, and
userspace can lie or unmap the address while kernel accessing it,
copy_{from,to}_user() is needed to handle page faults.

Your use case (copying between userspace-mapped memory and kernel
memory) is, as Gary said, the least special here. So using
memcpy_{from,to}io() would be overkill and probably misleading. I
suggest we use `{read,write}_volatile()` (unless I'm missing something
subtle of course), however `{read,write}_volatile()` only works on Sized
types, so we may have to use `bindings::memcpy()` or
core::intrinsics::volatile_copy_memory() [1] (or suggest Rust to
stablize something) if we want to avoid implementing something by
ourselves.

[1]: https://doc.rust-lang.org/std/intrinsics/fn.volatile_copy_memory.html

Regards,
Boqun

> > it, I would end up writing something similar if I wrote a copy function
> > myself.
> > 
> > If it is the wrong function to use, can you point at a fitting funciton?
> > 
> 
> I *think* for your use cases, a `user_page.read_volatile()` should
> suffice if the only potential concurrent writer is in the userspace
> (outside the Rust AM). The reason/rule I'm using is: a volatile
> operation may race with an access that compiler can know about (i.e.
> from Rust and C code), but it will not race with an external access.
> 
> However, byte-wise atomic memcpy will be more defined without paying any
> extra penalty.
> 
> Regards,
> Boqun
> 
> > 
> > Best regards,
> > Andreas Hindborg
> > 
> > 

