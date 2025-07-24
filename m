Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF343C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 18:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF438E00B0; Thu, 24 Jul 2025 14:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46E5F8E007C; Thu, 24 Jul 2025 14:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35D848E00B0; Thu, 24 Jul 2025 14:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FD998E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 14:50:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B5CBE16041F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:50:54 +0000 (UTC)
X-FDA: 83700050028.30.161BBF2
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf11.hostedemail.com (Postfix) with ESMTP id B03C340009
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 18:50:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=bxtP0ehn;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf11.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753383053; a=rsa-sha256;
	cv=pass;
	b=yBXuWrq8qzttcx/3fsyEucBxg59vYDOy1EN/OR4JgKmJnl0ez+OcJJirNA0tWVn0Ol/fsv
	LwGZHH1UZbMzWtiMuCkNC7WVXX2y8wpye6+CHIJwStQRGOihmRvPCexzdt5RxBrtGRpGZ+
	sdV3QCTVhYxTt/OFstu7UJTUISFhDIA=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=bxtP0ehn;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf11.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753383052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zUjBE1xSWZ/jaXPPwyRJK69aFYsYjVnhXaqAHUqMFpc=;
	b=nJwaNwpD7WKdiwOqaell8t6AM+eNo/tzlDKygVMwSrXqS16hK02Po7Aa726uK3X+0RGqLL
	plhxofUu8ope+0owK6QjlAEP9Gt2HAEsfQMvGLPqWQidrgLiitz3wCCYBoo8yXFhWAhh4h
	NQvDW0T34RF8S34FIJsaiiB6BU0uJiM=
ARC-Seal: i=1; a=rsa-sha256; t=1753383028; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=MpHMTuxUAqb4oRCWw4ibpqbslIYGOdCazZtwvUhou1OXZ8UcOHL1jDnyjOYq6quPVc6X2e3YRCosgbooy4t1O8uXAZHe5+8lFcyIBUYWWllB95jiBTehOKAmGnmjadzWl4oq/dQ6TJHxUm/XH4zVFGFcygOUX53+Ph/GdOTq/H0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1753383028; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=zUjBE1xSWZ/jaXPPwyRJK69aFYsYjVnhXaqAHUqMFpc=; 
	b=JRnHo/nfYbYUnJAYa/e+kFNWBF6OinORZmnmc3L1XY64dlJyzq4UiObhqZD9fn/BdPZHEsKB5uzTrOh9c3oDF6NniEOXubLqS6sWVt1P21V/TZvbJEu+rDYO9SyRqCVquLkdbqLFv/vx+XPaP9uzjOhfLi/QjrtwdQvfFTWlbSs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1753383028;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=zUjBE1xSWZ/jaXPPwyRJK69aFYsYjVnhXaqAHUqMFpc=;
	b=bxtP0ehnEfzmHeG/v506SxjsNt1XHDdhkZCojKt2FXUy3LqfTQYc2JJp82Gg9G3R
	yjjmxBytXehOSTFqGVYzkpG51l/Rhz6paVZBB6s8Mpyb3MMVg91Vf8jKaX1JBTF3Gce
	aGJcT59TXhv31WDVUj65YkJe9jBWCIj0HEsQrE/k=
Received: by mx.zohomail.com with SMTPS id 1753383025893371.2668099208014;
	Thu, 24 Jul 2025 11:50:25 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH v2 0/3] rust: xarray: add `insert` and `reserve`
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20250713-xarray-insert-reserve-v2-0-b939645808a2@gmail.com>
Date: Thu, 24 Jul 2025 15:50:09 -0300
Cc: Andreas Hindborg <a.hindborg@kernel.org>,
 Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org,
 Janne Grunau <j@jannau.net>
Content-Transfer-Encoding: quoted-printable
Message-Id: <39015200-6AB5-4331-A679-C0CF6DB4B930@collabora.com>
References: <20250713-xarray-insert-reserve-v2-0-b939645808a2@gmail.com>
To: Tamir Duberstein <tamird@gmail.com>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-ZohoMailClient: External
X-Rspamd-Queue-Id: B03C340009
X-Stat-Signature: zhpr4ysxe7oyoqjuiodpatofjgp6az9a
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753383052-302085
X-HE-Meta: U2FsdGVkX18MEvn8M2BYGisX8GsWkOZ3GZ1q+bLKHc4igSlzyn1LWf3xrLuuXG7rp45nmNnbmKfsSk7gARmMDROEF1Lvrk0dS401t45cZQt2R72ZuK4QpqRolH9SsEw+VxLWZKZbdN/Db0iDXACUE6sCx3/mDCwC1a0qKUD7oXVw9otWP2rvz58HE6DPMMwFkwrUjztSqvxih1ApJRUnf3NfuEX2PwiR8yVq+lnkkSGX/dGR0BcmodbJa5ae+t4hgrpWso02bXpjIF/BC9k611n6rh6AG3UIGgFBiAURs0pf9PS8V44SGs4LtkQkIwSyLvSzwPPHfqwZ+QRBUpjiukrl5VG/2WsyiElCAydp7sfPTeMrqcsw+ELMh0aawj0JhEuRqC/a+uP5YitJp3280o/sVUfakp8JnKdZ+JoxR/JSNy3/XHF5h1Jtce96zqCxDcj2dfgKPSGLlmGOIIw8OgK55uw/67Cmds1yXEwLN20N3OY3+NtnxlAMlcyICZ1y21KPsfijfcz7dNqO188Gz3OZ67b1VtoFrWGpwu9/T9JVEr9UQsEJU5+IzXLLhW1GgJA3qTKsXeGgSpNNTg7GiocojH1PmRm/kZVqCcJWNXR7PMzrBmo6e8sYOT52GeW5Y00nnXO8gXKh+iKXckrDYZ8MfHCFxvP3qMKMgEhrRFly9Snf5h78bsyMRm8SHpZ8KBo7aLAduDps1rfQM3SPnLbGy9jviFz3d+C/6AhJHXPlQxP/m2v7UzQNswFJDNXg0Wb1SERoqrIeODLVY6nryPaN6bnaeuieinqlMRTHvjPwtZJVlJC+uCXACI6LFKGAGr6Ln/0XVxYblPj2XBNmlhXJ80BpPq8LL3LXTqKyaIjAMAQFoCYVCFYhlPvNXDRvF8GPjyDGQvr9V31cjbSzVLVrw0xwM84dhgY5i2lCmv1p2omgp6vkcKIxE+eNGSt/COZFuB4Ccg7a5zXwbdk
 Hf3FnY61
 wWZWVRE6sJ2sTTmNJoUxw35ItlBnsLK9V28z0s7UjkLhkglocfltDinWvQr3X5EsSWV8LyJjI2psaaFjzIde/uT/H5i4JT2dtAfGQBOBR/TjDeDrkApdnjMuaXhSQxH64/a7SO2jUiSeFyxJt6a7Esn+1wauL9T/zvGRlZ9qlmoRKrb3vx+UARjq1lECckIYUf2Z0SwgbsKyHAsgUHWcKEELkBQhStH2uD6UqBz/fSRQk5XlrQZGaP2ocRb/7tqcQNq6RN94IVuD6tzyXPAS2ZML748DjIdVm+bYGqjGOoSvroqghuOlZmDryTXIbiiyq5T38iJopMTsJpr5Sf2OL9HkIOi76Da6/j6TUrbIQsDF/eCdCyhgqcYVbU1oz4V5mHySQfMWN73FqBMBBuV/ciDIaQ4LqS58w776uV8RPHzLaK56PDMkk8BhPR8TR/i/F8l794UNAzTQAOvY7b1RugI+V3SE/C0hxvtfmiHbPBaWNhjednnYu80vTX43RS6LKW/522F4u/n44oHKsR4l/1ZXy72+pwfxX569O8OGXv98JS3fRMu942682EoHp1GEbGQlFVPtTBqemjzFCdwCo2gqNnH8lGRL1bqEg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Tamir,

> On 13 Jul 2025, at 09:05, Tamir Duberstein <tamird@gmail.com> wrote:
>=20
> The reservation API is used by asahi; currently they use their own
> abstractions but intend to use these when available.
>=20
> Rust Binder intends to use the reservation API as well.
>=20
> Daniel Almeida mentions a use case for `insert_limit`, but didn't name
> it specifically.

Here is a patch that tests your code on Tyr [0]. I sadly didn't realize =
in time
that you were using impl RangeBounds as an argument to insert_limit(), =
which is
even nicer :)

Our internal tests still pass.

I also double-checked that the kunit/doctests pass, just in case.

>=20
> Signed-off-by: Tamir Duberstein <tamird@gmail.com>
> ---
> Changes in v2:
> - Explain the need to disambiguate `Iterator::chain`. (Boqun Feng)
> - Mention what `Guard::alloc` does in the doc comment. (Miguel Ojeda)
> - Include new APIs in the module-level example. (Miguel Ojeda)
> - Mention users of these APIs in the cover letter.
> - Link to v1: =
https://lore.kernel.org/r/20250701-xarray-insert-reserve-v1-0-25df2b0d706a=
@gmail.com
>=20
> ---
> Tamir Duberstein (3):
>      rust: xarray: use the prelude
>      rust: xarray: implement Default for AllocKind
>      rust: xarray: add `insert` and `reserve`
>=20
> include/linux/xarray.h |   2 +
> lib/xarray.c           |  28 ++-
> rust/helpers/xarray.c  |   5 +
> rust/kernel/xarray.rs  | 533 =
++++++++++++++++++++++++++++++++++++++++++++++---
> 4 files changed, 536 insertions(+), 32 deletions(-)
> ---
> base-commit: 2009a2d5696944d85c34d75e691a6f3884e787c0
> change-id: 20250701-xarray-insert-reserve-bd811ad46a1d
>=20
> Best regards,
> -- =20
> Tamir Duberstein <tamird@gmail.com>
>=20
>=20

Thanks a lot for working on this. It will definitely be used by us.


Tested-By: Daniel Almeida <daniel.almeida@collabora.com>
Reviewed-By: Daniel Almeida <daniel.almeida@collabora.com>

[0] =
https://gitlab.freedesktop.org/panfrost/linux/-/commit/791de453eb103af37e3=
cc6825e042f26d4c76426



