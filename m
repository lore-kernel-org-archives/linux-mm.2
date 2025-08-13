Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D0B5CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 10:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83EE4900054; Wed, 13 Aug 2025 06:19:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81696900044; Wed, 13 Aug 2025 06:19:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75355900054; Wed, 13 Aug 2025 06:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 66172900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:19:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0FE4D1A0302
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:19:33 +0000 (UTC)
X-FDA: 83771337426.13.0CDBFD4
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6D2DA4000B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:19:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fXa7pfH+;
	spf=pass (imf07.hostedemail.com: domain of dakr@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755080371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X4T16RQEgB3Z7qpvj++iaMCFNNmxOqStvzKrETm5LQI=;
	b=Epwt/Xj83uKUXKUdkxIVzHdm9jqRAOdmpypccYWCEV8fxh0MbMpUY55BXJtZYMCsryPlJr
	uL9ZDvtr5FRLUq5wwFWXHzf2t/DKADivcLS+g9Jk4HLS/YcATmPyxqsGTTxMLi3PBsEg8T
	eJX6pdY3x+cd3ffv8BDq9mkJvH3x0yA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fXa7pfH+;
	spf=pass (imf07.hostedemail.com: domain of dakr@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755080371; a=rsa-sha256;
	cv=none;
	b=17AK5Pqpv+kUywpf08B4izyI6vx8Q4f3729K0PE148SHH9Xm4nI2eBrvusIIQR7oyAWYw3
	lTg/WssW28mqPD8SVZpjWLKn1g2IP9Walw3LMZAqW9omZmoD41xNtIosFeCxcan4s7kXVZ
	+QDfyP1FReXs6/RyugdYCH5IY3lDB9g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id BF48BA57C42;
	Wed, 13 Aug 2025 10:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F519C4CEEB;
	Wed, 13 Aug 2025 10:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755080370;
	bh=qW9SWoWX6A53AFhzzT38jehPPUJjNU69Tw+gWAuHO48=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=fXa7pfH+WHcRrIEQTszchLdqLCY1ttHuNL0sPo1YvUXnQLfMGmX6a1e0j9Hiu73Kh
	 A4Se8wYGmsx+9XO2QWPrr6zDMoVWsCH5CmLB+f3l/8WvNQyWBiTjpCWnPY1H/N78c5
	 L5r7+wBDRF/AC/zvx/JOxLAECcN88fYijNDmt7Q75zyc0qnN1HehKPsYEv4clPZwRS
	 dUutqdh/ZIq2f2ykr3GdtwgNMU2QzOA8VpHKwo7t8TO57GuYemALsKywPDxxlpUlEm
	 iOQ5MKjnh/X4q2+nhwzHUxa0jN7c0wihdky9ohKIe5s0/D+C76KuJFPogUV9fLkldD
	 jTdrx+qbeILYw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 13 Aug 2025 12:19:25 +0200
Message-Id: <DC182DB9HNS9.21ZVBYT6DXHDE@kernel.org>
Subject: Re: [PATCH v2 1/2] rust: alloc: specify the minimum alignment of
 each allocator
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
References: <20250811-align-min-allocator-v2-0-3386cc94f4fc@google.com>
 <20250811-align-min-allocator-v2-1-3386cc94f4fc@google.com>
 <DC0N2SBVHIS7.2P91EJSTIT1FM@kernel.org> <aJxESG0l4-kyUHXg@google.com>
 <DC16OLU29VX3.16T0QDJF7Q18P@kernel.org>
 <CAH5fLgj0kjGBwZFHjErsa7MCV1fz4xTWwrZAcFzHHnkbvS=OMg@mail.gmail.com>
In-Reply-To: <CAH5fLgj0kjGBwZFHjErsa7MCV1fz4xTWwrZAcFzHHnkbvS=OMg@mail.gmail.com>
X-Stat-Signature: 3rrpraor5fuw5hf89mowyhikrnqjq5jy
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D2DA4000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1755080371-423724
X-HE-Meta: U2FsdGVkX19Jt6sytHIwM/ndvlrsCPU8ISeLo6FWjQedA5sVc9MA7pPtzINvON09pIis5tl5Cb7pVM1ziA0n6NPuUppMH0zceXoH/0ywk8w9zEhGRLpCxMUQrI/dipJ+EfOsgh/zOqF7xNbUuR4x05XUL4/WATTS8/J6ZDbbLSoTtC4t0/daRBz+h1AuG86Ce/E725mmOZe15CzCItl1/ZUWZARaqb4wqr/KCMMRt6WkRDEUXbpn3A5n9wwLtITasQrBvn3DuAyNOyjRAGQogyKGCTcCPDlpghT+jeLqTEVL6SPNA3pR6zI8FJLTV+CQ22v2PkOjLYo851ufkXAI7ZZx6E1gp4ZJweO3jN1ZFIGg97Myn+zGIO6FumshGdjGSlYfbXx94O5oQn1kHulEYtqYcPsBCafqAeovVYFJ1+joxFy7vXb6jbcW7gyR+Qi1qKNxVnH/+VbSBJp0KGn+XV0toJfYE+uU0z2aYQrChgrfXZBH5XXaetX6d7nOIntqGVu5HVA04TziVc7pX869e0jJa2Tn2TUjst/MO8F9++Y9cY794RFE7eyQpjvXTJxEpmRGNIt1SlwcKNWSQVUaDbN8jFSrsAzu5PneBvYl7bfZYQ4zjEdkpeLrU1XyV63COF7xZjB0EyL5ppdNsJ8yUIYTn9h2eFAUCmGGOpCkNEQ21hgDtgGRcEaLsiIfYcetRLxtWb9ecfEvo3wf6GsyzPrVMBHSV5f8oev1U2g0iClYcODPS2L+FIkVXh3Qub/rpojeyoXIC9TS2df7+Dx65TOtWoMq466Kq642RMIxd7W7g7KQ7A6HvJG/b3CvJxmUbEGccdWP4YYyxXzdGNuOq+kTV0CJVSzKnQ+q6Suryv7d/ymDn1OoLWnA/aP8Sp+cFZefxlTcshJzc1prI3iemrFkzR1yqpSxAaemq6mCKwqtwzOQAHGL2I9yvOFFO3eLT72eJl0fzPAx/V7FQL8
 Jp7SOWjF
 JGuffI19zjSylGHXpZbrx/EBDb8OI8Fi5zTd19gyFJZy01aU7oJ8GzRAC1DiRK39FYNcP7CmPz2HbNN8cisAEgAIw4gYDxDS/f5/qIVAfH9GVQ/Ms2LW2XOpxWWTdsOnr3VZTz3J05XidS+OeusYs0rJwLw0ricCIbcsWUY1L1MnXAyyrWQKnZ77/Fgj3SyoJNqkdqxNLE9ReLBhlxB0JBC5ZFyI5vK059zdUK5oaXY3SBufWcriwxn7d4craPoxL6/JvN3VdmD5fYeX4jdiD+Mmx2omd74LY4s8aPWILSqfLKUyfKxdY9scP+2EuqDo6Xrkv7ZEroG5bKm0WNNPDwjI0MsFUs45s61dLaT93asF50sAVPxWalIsu7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 13, 2025 at 11:32 AM CEST, Alice Ryhl wrote:
> On Wed, Aug 13, 2025 at 11:14=E2=80=AFAM Danilo Krummrich <dakr@kernel.or=
g> wrote:
>>
>> On Wed Aug 13, 2025 at 9:52 AM CEST, Alice Ryhl wrote:
>> > On Tue, Aug 12, 2025 at 07:52:35PM +0200, Danilo Krummrich wrote:
>> >> On Mon Aug 11, 2025 at 2:31 PM CEST, Alice Ryhl wrote:
>> >> > diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/all=
ocator.rs
>> >> > index aa2dfa9dca4c309e5a9eafc7da6a8a9bd7b54b11..25fc9f9ae3b4e471a08=
d77130b374bd1397f7384 100644
>> >> > --- a/rust/kernel/alloc/allocator.rs
>> >> > +++ b/rust/kernel/alloc/allocator.rs
>> >> > @@ -17,6 +17,8 @@
>> >> >  use crate::bindings;
>> >> >  use crate::pr_warn;
>> >> >
>> >> > +const ARCH_KMALLOC_MINALIGN: usize =3D bindings::ARCH_KMALLOC_MINA=
LIGN as usize;
>> >>
>> >> I think this needs the following diff:
>> >>
>> >> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings=
_helper.h
>> >> index 84d60635e8a9..4ad9add117ea 100644
>> >> --- a/rust/bindings/bindings_helper.h
>> >> +++ b/rust/bindings/bindings_helper.h
>> >> @@ -84,6 +84,7 @@
>> >>
>> >>  /* `bindgen` gets confused at certain things. */
>> >>  const size_t RUST_CONST_HELPER_ARCH_SLAB_MINALIGN =3D ARCH_SLAB_MINA=
LIGN;
>> >> +const size_t RUST_CONST_HELPER_ARCH_KMALLOC_MINALIGN =3D ARCH_KMALLO=
C_MINALIGN;
>> >>  const size_t RUST_CONST_HELPER_PAGE_SIZE =3D PAGE_SIZE;
>> >>  const gfp_t RUST_CONST_HELPER_GFP_ATOMIC =3D GFP_ATOMIC;
>> >>  const gfp_t RUST_CONST_HELPER_GFP_KERNEL =3D GFP_KERNEL;
>> >> diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/alloc=
ator.rs
>> >> index 25fc9f9ae3b4..5003907f0240 100644
>> >> --- a/rust/kernel/alloc/allocator.rs
>> >> +++ b/rust/kernel/alloc/allocator.rs
>> >> @@ -17,7 +17,7 @@
>> >>  use crate::bindings;
>> >>  use crate::pr_warn;
>> >>
>> >> -const ARCH_KMALLOC_MINALIGN: usize =3D bindings::ARCH_KMALLOC_MINALI=
GN as usize;
>> >> +const ARCH_KMALLOC_MINALIGN: usize =3D bindings::ARCH_KMALLOC_MINALI=
GN;
>> >>
>> >>  /// The contiguous kernel allocator.
>> >>  ///
>> >>
>> >>
>> >> No need to resend I can fix it up when applying the patch.
>> >
>> > Hmm. Maybe that depends on the configuration? The constant was generat=
ed
>> > for me. Either way, happy with the suggested change.
>>
>> That is a bit odd, I'd like to understand this before merging.
>>
>> All of the definitions in the kernel are defines that shouldn't be picke=
d up by
>> bindgen.
>
> It is possible for bindgen to pick up a #define in some cases. The
> main case where bindgen fails is when the macro is defined in terms of
> a function-like macro. This is why we see so many failures with _IO*
> macros.

I think I see it now, ARCH_KMALLOC_MINALIGN seems to be either a literal or
__alignof__(unsigned long long), either directly or indirecty through
ARCH_DMA_MINALIGN. bindgen doesn't like the __alignof__() extension.

So, I assume you were on arm64? :)

