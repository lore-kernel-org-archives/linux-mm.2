Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90581D58CBB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 03:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC7846B0005; Sun, 22 Mar 2026 23:04:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51D76B0088; Sun, 22 Mar 2026 23:04:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B19336B0089; Sun, 22 Mar 2026 23:04:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9CE956B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 23:04:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 385F8C2F76
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:04:52 +0000 (UTC)
X-FDA: 84575835624.14.6136474
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by imf20.hostedemail.com (Postfix) with ESMTP id 22CAD1C000F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:04:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=lunn.ch header.s=20171124 header.b=Cgzrqx8G;
	spf=pass (imf20.hostedemail.com: domain of andrew@lunn.ch designates 156.67.10.101 as permitted sender) smtp.mailfrom=andrew@lunn.ch;
	dmarc=pass (policy=none) header.from=lunn.ch
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774235090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0o3IMkXU9M+ra6jtZIePmaIM7c78nzlX/rqtiYyUMUs=;
	b=cz8A+qtaIJefaq/632KWEOdnvW+j0dt2amvBtJZ1XlEdUtKxwRjTD6ix0ol32LZXtYQJ9h
	KZdkhAxWqHtx4Y+sCNggtFvK42+HRvon2KhWPz3MJt/XyV5DsLmS1zpTxi9ivWfOxCxTsA
	PlvBiZd3/pt1pZOj+DereeN6QkEv+lA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=lunn.ch header.s=20171124 header.b=Cgzrqx8G;
	spf=pass (imf20.hostedemail.com: domain of andrew@lunn.ch designates 156.67.10.101 as permitted sender) smtp.mailfrom=andrew@lunn.ch;
	dmarc=pass (policy=none) header.from=lunn.ch
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774235090; a=rsa-sha256;
	cv=none;
	b=NvOAtKKxNDYq8yYuzs6JxxtcGEERzeAwolzqZqQomqkF0Vuqd2KHJCeNzzz+mVKTr8hM19
	vaxL+BarA8MI/++pm1rBDcgGZqBIu7dyVEdHQAgFjupR3xwjM1Fj56pKG+4PcfWIu6gGF+
	O8QMUwJWtH0nQSbcFygnyMVaVTyyNTU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=0o3IMkXU9M+ra6jtZIePmaIM7c78nzlX/rqtiYyUMUs=; b=Cgzrqx8GftS1h7cFSUrWUQgVHX
	Oh5P3qaAHvzzIytGyVzyTqcRYfVSrxZKFIjJlQR/n2YNmzpRaq+HqDI5Yc9o0F7SqIqnOwI+6P0AC
	pkYpFBz2YLxvMYi4mly+bn6M59Uog8kGy1QttCO/yD64ayMbRm+bt7PXlzvZ2SezX0M0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1w4Vah-00Cs79-Lr; Mon, 23 Mar 2026 04:04:31 +0100
Date: Mon, 23 Mar 2026 04:04:31 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: a.hindborg@kernel.org, acourbot@nvidia.com, akpm@linux-foundation.org,
	aliceryhl@google.com, anton.ivanov@cambridgegreys.com,
	bjorn3_gh@protonmail.com, boqun.feng@gmail.com, dakr@kernel.org,
	david@davidgow.net, gary@garyguo.net, johannes@sipsolutions.net,
	justinstitt@google.com, linux-arm-kernel@lists.infradead.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-um@lists.infradead.org,
	linux@armlinux.org.uk, llvm@lists.linux.dev, lossin@kernel.org,
	mark.rutland@arm.com, mmaurer@google.com, morbo@google.com,
	nathan@kernel.org, nick.desaulniers+lkml@gmail.com,
	nicolas.schier@linux.dev, nsc@kernel.org, peterz@infradead.org,
	richard@nod.at, rust-for-linux@vger.kernel.org, tmgross@umich.edu,
	urezki@gmail.com, will@kernel.org
Subject: Re: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
Message-ID: <96287f3a-d245-47cf-b7cb-f821451493d3@lunn.ch>
References: <20260322192159.88138-1-ojeda@kernel.org>
 <20260323000327.111235-1-ojeda@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323000327.111235-1-ojeda@kernel.org>
X-Stat-Signature: 4jzss51hkiua69ym6aorongnnsj3b53s
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 22CAD1C000F
X-HE-Tag: 1774235089-917496
X-HE-Meta: U2FsdGVkX18UmKg1uPaUqnXuUQI+4v0qGZrVdgMkyuDxoDn7LvlvA9sbkiIpKEnAbfac2lCOe7U/war87hqCYhsJF8QxEbAsIQWAMWFhLMdeGrf6qt1p4TP54r2uMPYBYkeGGKlZeLsqaxP6Vdg7X2fP9zBepRFeFdkm/dMfm9GMDp7EBoeADdZDAFbESimGq7qD1IJ2/VB1hapsRGcSQ8IrMIGEooIe/GVVgnvcIW7ce4+SGtpi6LrN6V09h5j9R+Nj2qjTZprW9tEwUT7cLLpe5pWz8dpra754pnABTy7g8eYjOHAvIXcmz8PTotZNXCrahZ0kfg+rHKiss0qMZ5AuDzdqRlvjoh+EkDv4uwmaxl9WwfNWWzS9XbBXM1KvREbawkbQsESF/3fmpKVYeNrM6VV4LnLnBFGua4jKjxpKt+XrmUkok4eFyK8GAbB9oZjvDRFY05sLO+9Kra5Uir94e/fqBYBKLlwRPjr3TuHb2NIgNIx6jv7YHUrN21nFgfgLMWUrTMk5u8gN9LR6pLe0Pxq6vsFXLoJiOmZSyRbNKo8+7g4CGE0WLaNtpteQAznzyw51fev/ychPP0lQ5UKIReIUICe2dattYqyZldo5v3seAgp6oFcvsaLuMUyCSD5eKr8J5cEXSLMAKKmHsohTqDBS+OWWOyAJoGtrzKMpKcXxmh1/0aHl32ZV/D/H98JbNzMS+i2j1+crXviODJ3Q+DryxoBm9jLGnBt852FGJStZUtANjOfNy/rrdVgZfsgmhf0ZUxb5ZGXK5PswcCPxFPJ77uYSy3Jwzgx/zx1NUdVBzVJyjAxWfrTXbNG459rnYeWjvultld00kmMsprhNLC34XjUEeweyUHuTKSJUwXN0gpDPJ4Gd+3pebdXnP7LXOu2TsZ3VW+s+qXdLvQSKrEIWdi1MN64nabRfAmdhTUjZlHbzTfZKmezc9YRF7SWS2L5Gt/jAjHbyASH
 XRQYveWo
 Ni2uZxQlSxGahoRh6XX0D8nTTniHnBfgQ9GzKQks3AY7cNWydJA6I+F+0ThWQN3uTmhLy4/7ImKbaFRVpZGX68muMOKBk3jANJLGAX6eN4v4MIw62RHRNd2e0W53qMOlHUEBnZCByj7VF78tGWLhpDzzkhJJ828HivbRZfZqEeFxyMPw9WquoGwJlZKfSmhPGhQrkey9emNzBkMecLUKAyKW9bqiFjHvm0Ppu8FMCjHfnanqb9tfaZMlREWATae1G5NOMymxiOqeud0nPuX6Jncb9xu1gMqqbykbzg/ziS6zWs9dVYAVeuGFl0AnL6MCQ9O7umE/dG73LGgqSLyQdKdWMwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 01:03:27AM +0100, Miguel Ojeda wrote:
> On Sun, 22 Mar 2026 20:21:59 +0100 Miguel Ojeda <ojeda@kernel.org> wrote:
> >
> >     On the other hand, regardless of whether we fix this (and another
> >     issue in a separate email found thanks to the UML build), we could
> >     instead add `depends on` listing explicitly the architectures where
> >     this is going to be actually tested. That way maintainers can decide
> >     whether they want to support it when they are ready. Thoughts?
> 
> Another one for arm 32-bit:
> 
>       LD      .tmp_vmlinux1
>     ld.lld: error: undefined symbol: __aeabi_read_tp
>     >>> referenced by uaccess.rs:349 (rust/kernel/uaccess.rs:349)
>     >>>               samples/rust/rust_misc_device.o:(<rust_misc_device::RustMiscDevice as kernel::miscdevice::MiscDevice>::ioctl) in archive vmlinux.a
>     >>> referenced by uaccess.rs:543 (rust/kernel/uaccess.rs:543)
>     >>>               samples/rust/rust_misc_device.o:(<rust_misc_device::RustMiscDevice as kernel::miscdevice::MiscDevice>::ioctl) in archive vmlinux.a
>     >>> referenced by uaccess.rs:543 (rust/kernel/uaccess.rs:543)
>     >>>               drivers/android/binder/rust_binder_main.o:(rust_binder_main::rust_binder_ioctl) in archive vmlinux.a
>     >>> referenced 36 more times
> 
> I think this reinforces the case that this is something that arch folks
> should think about case by case, and decide if they want to try -- we
> may want to start simple with x86_64 and arm64 or similar first.

But is this an architecture thing?

The netlink binding required this, because many of the netlink API
calls are implemented in inline function. However, netlink is
architecture independent.

Rust is already fragmented, because it does not support all
architectures. Do we really want to make it even more fragmented by
having some bindings only work on a subset of the subset of
architectures?

	Andrew

