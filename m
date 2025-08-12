Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A794CCA0EDC
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 17:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BFB78E0182; Tue, 12 Aug 2025 13:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497228E0151; Tue, 12 Aug 2025 13:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AE1A8E0182; Tue, 12 Aug 2025 13:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1F02A8E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:52:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95319160136
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:52:42 +0000 (UTC)
X-FDA: 83768850564.28.8790936
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0977B40005
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 17:52:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EDf+4lx4;
	spf=pass (imf12.hostedemail.com: domain of dakr@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755021161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q7SudrwCrvOox5fMeyIms+neVxZMLrX1XSpSWopJ+zk=;
	b=GiLqKneTaJpDweh4B6qnuUgpDwB/SBPNxuIL5fnc0MkxmP5qrcyMPIJdGzAOk7PCZG/fUo
	XVJTqOkIRG3eSx0NMnCoNNWX+9EPdw1te4+mqRo/9yqgxQJYfGU+HiTSxSGe6Y8KGhUCs9
	2vQ5cMTVeOtOYdtcOs9GDrAKzD1hF/E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755021161; a=rsa-sha256;
	cv=none;
	b=s/7P8jswwc4dMc651SaalFlVtWmjqs6lCA2q6faI0bBriiZlHKCsPum0NoSfz6eLcb3qGr
	VrZQB/J39XB+Hyx2B2/ShP0jeptJ4l2gaLi71ZgUTbC5iO7nbftL95NVLCW9a2DB8zaORO
	A/NAnTu5WDzGNrK5bwXsyzK/w/PLv7w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EDf+4lx4;
	spf=pass (imf12.hostedemail.com: domain of dakr@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 48AEEA57822;
	Tue, 12 Aug 2025 17:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48EFC4CEF6;
	Tue, 12 Aug 2025 17:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755021159;
	bh=HrWt7KsFmQFhR+gbni5exLfgmFjQs3b24up4/s6MmUg=;
	h=Date:Cc:To:From:Subject:References:In-Reply-To:From;
	b=EDf+4lx4IuM9rw8qi4wI1aL1fFeQH/N1+zaWTH51ERi8hnA7G07qo26tb3konaG7C
	 sMqCLR2++PPj/UJzbowqN3eJHrxckicnDUjnrPXqS426jZIuJuQqTnQwV7+9TTKNpE
	 ryRfutW6sZyjUFRqYcRpiY5mugzhPWIbv2HC0Ivbe/4zPfeFBzg/BxKlcDHdK9+Slp
	 aXAMyKg+rbnfEmYb8gKgzuIHKc/kha6hu4YVSfA6suInHQO2SDLrrzMRDsnYmIb+u7
	 Rt1ask5T+OWQCX0BGHsZr+mkNLbQV54y60NM2DEWzXbKR4NJl1weaKKPE8+JQy5wAq
	 iMpJ232uW+npg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 12 Aug 2025 19:52:35 +0200
Message-Id: <DC0N2SBVHIS7.2P91EJSTIT1FM@kernel.org>
Cc: "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Matthew Wilcox" <willy@infradead.org>, "Tamir Duberstein"
 <tamird@gmail.com>, "Andreas Hindborg" <a.hindborg@kernel.org>, "Miguel
 Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Trevor
 Gross" <tmgross@umich.edu>, <linux-mm@kvack.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "Alice Ryhl" <aliceryhl@google.com>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v2 1/2] rust: alloc: specify the minimum alignment of
 each allocator
References: <20250811-align-min-allocator-v2-0-3386cc94f4fc@google.com>
 <20250811-align-min-allocator-v2-1-3386cc94f4fc@google.com>
In-Reply-To: <20250811-align-min-allocator-v2-1-3386cc94f4fc@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0977B40005
X-Stat-Signature: 7u9zmokp3g93zda78i94qkuta5wftyd9
X-HE-Tag: 1755021160-577738
X-HE-Meta: U2FsdGVkX18X8GBzl44Xlw+DXRUCroMGEeVnOTNg+LMoBSRnulVxerw9M0geOcBbAMpznpI8oYi9nfIuy4J+vOpiNKpO4lY7e8UwFg89c8r4EWaCnc5/H7N5mrY40xJPUssITCNIjwBHi6XmjYl4XAytzJ29nlh9aT2PmI5f8l3UE4jm31XBlWGwvtxMnfnfdXyAa+1MvbHXFIsKWg379cPKyHzLcnqnQ3uiHXPEhW90oU+j/TIdiK89pxmHTmVn1C5PeYcOY14kp4uo5aJnHJH42x+vGZT0OoCw/AZmUI/cKtISBJN1SSHGZpKojpY0DFB90YO6YuPumlu4obqjvVMUONYJoqrxog/88zeBbO5EN9C/Das99QDOk/LGyoGGsc6+1ZiOEI9pmQ9LSl6qEZ1ZhwsxgcsCdvWbgKEgPOweIm2Nkh64aqFEkuoDIUwGGJIVJFJ6/eX35K4A8u3gxR0BVATP17IzW7N4MRl2GfSYL/LWbfcXrBrueVz5Q/bn2qs2Fv5QcmydHzVYv0pPJDf8Sn9hCg4TyQzmSos8/gl4AIJkFpF9BDWXcYE4MM4xFk4GYl6LRIvfuAfc5AmU9yCtrz18DYxFqYKyNOtpnu3OhwOGn743BFYR3XPd+1Q+fN5ddAKryiFpzXWjfhbg8RqG3djpQFWJRrf5BW4DpsMQLr8mKMSiWchCQLmCP45h5nPmY+kU/Gm7nz40y4UC7W6ICR/sNNgQWMe0GNAZaWPjvDyrZ4UVp2L1YLvUBcPqTvlb7qiYc11IUD62zb8H6zgnvyXJCuTvP8cf3HubTOrN6yYbV/wljsXxGRCWvMLBoNhUUTnV/aYOXezJMewCmNr5hAUZgxj+Zff332EEfiw2Rpu1SWg72UINx/DyQtR1wEx4raR17barehNA1XdSUFjxC2K7Gfm1QTETfwpuh2HtHbVe2WEneUjLHhIT1/lU7njEbAxgCvhtS7EWezn
 zXY9WWqJ
 ycvhV3luyw1WV4OG3yXoslbgGTHIfMXF5jlQQ2iy8OJSKkBGN2EJL61kc9YU3u7qu9GnGKp2GDzqfIKBw4qfoPQTFyAfru2BTFp+9sjwzo91d19BVcVp1jZG+MMR2V5/RopVPPE6x/xI4GNVvvlTa8j6fn/W2PUrCUJbfW4DL8o7J+KFn7h/cAgKWVdK3Swz/lWXmCpuooqL38ikPZevLtQTYhbjI1d64UP1RqpETzjji4JiRBvC+N4DCVr0VFkdp3d4wH8rp+51bRu6vDgPWsM0ErfqBCZsWv7yw7aKrqiT80b5wiko6ZlzlcIMNKMT7WCOwFrEza2jX917eQS/Edizxn+gZNbEA37kN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 11, 2025 at 2:31 PM CEST, Alice Ryhl wrote:
> diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator=
.rs
> index aa2dfa9dca4c309e5a9eafc7da6a8a9bd7b54b11..25fc9f9ae3b4e471a08d77130=
b374bd1397f7384 100644
> --- a/rust/kernel/alloc/allocator.rs
> +++ b/rust/kernel/alloc/allocator.rs
> @@ -17,6 +17,8 @@
>  use crate::bindings;
>  use crate::pr_warn;
> =20
> +const ARCH_KMALLOC_MINALIGN: usize =3D bindings::ARCH_KMALLOC_MINALIGN a=
s usize;

I think this needs the following diff:

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helpe=
r.h
index 84d60635e8a9..4ad9add117ea 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -84,6 +84,7 @@

 /* `bindgen` gets confused at certain things. */
 const size_t RUST_CONST_HELPER_ARCH_SLAB_MINALIGN =3D ARCH_SLAB_MINALIGN;
+const size_t RUST_CONST_HELPER_ARCH_KMALLOC_MINALIGN =3D ARCH_KMALLOC_MINA=
LIGN;
 const size_t RUST_CONST_HELPER_PAGE_SIZE =3D PAGE_SIZE;
 const gfp_t RUST_CONST_HELPER_GFP_ATOMIC =3D GFP_ATOMIC;
 const gfp_t RUST_CONST_HELPER_GFP_KERNEL =3D GFP_KERNEL;
diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.r=
s
index 25fc9f9ae3b4..5003907f0240 100644
--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -17,7 +17,7 @@
 use crate::bindings;
 use crate::pr_warn;

-const ARCH_KMALLOC_MINALIGN: usize =3D bindings::ARCH_KMALLOC_MINALIGN as =
usize;
+const ARCH_KMALLOC_MINALIGN: usize =3D bindings::ARCH_KMALLOC_MINALIGN;

 /// The contiguous kernel allocator.
 ///


No need to resend I can fix it up when applying the patch.

