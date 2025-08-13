Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F07CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 09:14:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F74A900050; Wed, 13 Aug 2025 05:14:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A87E900044; Wed, 13 Aug 2025 05:14:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E57E900050; Wed, 13 Aug 2025 05:14:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E2E3900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 05:14:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1C3FC0310
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:14:33 +0000 (UTC)
X-FDA: 83771173626.26.47204A2
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf15.hostedemail.com (Postfix) with ESMTP id 458BDA0007
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:14:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kRKHttQw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755076472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zjB4SnQhQR7vU+gaDvvbdJ8eJi56sM12Q/RiCREYC3w=;
	b=z95lzikcqkvfdnDI8ChlaI/TkPdAABsBLseWIYttf5NcObcYlVXZE0KtWfPL1YrYZtsSk6
	wTEXi2cTV5Mu1yqJ5MvXUhwLm0RSzOMFCBLppDfYpSMHMnN65OZYh5AAohcwebAke3XL6/
	rTuFuGlZUXwQkfEcaeU2Dgeqtkzo/SA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kRKHttQw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755076472; a=rsa-sha256;
	cv=none;
	b=Uw2d1TTD1+8ng7Xqmcj3bOmrWUPSYNvMYhx6rxzbS8p7EtmbslPtDVoqPLIqIaJGPrP0Dw
	dPL2nEFfmOdyraNowuILGo86nSgxJT229IbSh31ur3sbH2wx4ob7SS86obLd/aAXlwS8Hu
	OEIDGWJByHxSoIr049KqUaUDMZj9nFA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 5A8425C6605;
	Wed, 13 Aug 2025 09:14:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA76C4CEEB;
	Wed, 13 Aug 2025 09:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755076471;
	bh=yfqXjIkaXYenRYERwnQVa9mqrbvMdVxPjhgytxo1X6o=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=kRKHttQw38ZbAGPNs2QpX7S53I8G96CiLQMTrugzJbW8O2wdDfqrhhsiFc478xzCb
	 HOBOacVlXZadDj4lmlinm7nDoq9nHD3GQOjBm1NxLKiLO7pynjsWVRPSfBLeQ/LNiZ
	 G0CApe/Gy7yxx8ikzIJGp0gFEvuY3LrTeUeC5iHlskqLA24izYiL/X5S9A7Ix5h6jG
	 jtLBXrMZbnXponpfsvKwFtZUnGAjBdn6N3dv+5oUnZaFC6V6GERWhclJxl3XqSGL1d
	 /SMA+6+T9RA45JISScXd93cJ59A4FAjh18TEWE3VsSsVREFpxFrQkUjwL8XXsPPsvA
	 IaOWcuP65zG8A==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 13 Aug 2025 11:14:26 +0200
Message-Id: <DC16OLU29VX3.16T0QDJF7Q18P@kernel.org>
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
In-Reply-To: <aJxESG0l4-kyUHXg@google.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 458BDA0007
X-Stat-Signature: 1jp6a4frmkr7gc8fbjng1z5hkk7gcnwn
X-Rspam-User: 
X-HE-Tag: 1755076472-302799
X-HE-Meta: U2FsdGVkX1/Nw2ShbSkNfQbPGTz1qFpd4P6nPMEMtPpm1fL1jpF9e+im/cCI2PzPul8zO4BVhJYT8dKfA+j+M6ofEaSAQdA173OHzewAeGxG9he/nZeLkJj4AYFHoNtNj6nf+rKeTrHBdmP17EfSB6n/u2hF1OSkOGdcMKJAnM2ZFv6aDKv2LSCxCFYnGnlBg3n0U7AnHjUJPtL0J0x9y5P5/D6RtzKAAzlCXqs7R1R7ZYyMqREhizj/zqOABdPo/9xmAZktKeIj2RTugbUN1gDESKA7J7mMg1pz2jLzzv+Hms2W8OEsvj1I2Cy6NN+vxXczNsDuPve3KWhbZMCu+8S/BLNeOVRjN6aLdVvPDkGq2b+JUewcdig1NMDWkS4VGQjM79DsNFCsMMhjzEDiZ6due/FJLa5mxw6v9OYgnod4072zylff5i9SJwD+NfimNtHrdRNzPBcuDvBryJNrtzVG1GSq6Z3D3vuDBykYsu7EIFhCFCHGPdaKF/XvQmPddoQlM16PE/EBkhrVN0X+okonP2h1ElJDfZt+/BvkKGq5a+KJC8rOGb5OraZHmr00QOc8AkTUz3Zz1Q5gOyJtseNhk74lJoYKkX78hDWAnFwmfRpXbeGqrOVlkbrN0EhWAFrKjXbnONXRkY/Z/vxt9fZXVGW0JsD8CaRbPw4C/QXB2nWC3N7TDie9UmX7kEi480cahpVlZCY6FkVHDXh4BGXLTUQAtJR/QAJPlLlJhejHLQ/9MHDZaaPHRiywCBODtZQjlUjKFaTpZZCGZGbJaPAy1BTVf/GFfdXXLEpnvoCar3L+LwXoqZ+ckm1VP024+ckPi/F4OGHGkyIMk7L/f9TUiZgEPLPe76/NA20FrtZbRe+0221XJinbxi70EVxx1Y7d7UMA0zY0zxk01ozUeufWGg4F8TiJXbFRNy2lBNcRjDoIeI1Uvg1Vql62ARUAAp0b94UhRK5PdNcWYPL
 lydY8rLg
 Z9t24L+FJVOH994e2+mtm8IqfxhredVGdp5DrrfkirpASXh41FmYSrFvmr8FnKSYvQ4DNE3AimDvatUTcZhYtfDv4bgyo7B3ZMYZ4nL8Q0JxUeJt7rtzicIbHoM+UyuyJo4oZd88VyDOx+Ko3jOdyMqtscq0SGRua121JHj9lqrYlRzBZn2YqlJmh69rnCKLppK4jyhg4r3AqhOu8ghmNNw2n2jVP6r8grVakDt9jWRQBYK2eumsRVly0R2uUBnQ3a/q84hN1HscSXyemf89OggxqIT8uBlIYr44ndYfFU5q6ZoNdlT3SKVd2yLwwi0XtIHXrNRCGmrhpUSTUty7eb6K+Voi+l9vcpq/3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Aug 13, 2025 at 9:52 AM CEST, Alice Ryhl wrote:
> On Tue, Aug 12, 2025 at 07:52:35PM +0200, Danilo Krummrich wrote:
>> On Mon Aug 11, 2025 at 2:31 PM CEST, Alice Ryhl wrote:
>> > diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/alloca=
tor.rs
>> > index aa2dfa9dca4c309e5a9eafc7da6a8a9bd7b54b11..25fc9f9ae3b4e471a08d77=
130b374bd1397f7384 100644
>> > --- a/rust/kernel/alloc/allocator.rs
>> > +++ b/rust/kernel/alloc/allocator.rs
>> > @@ -17,6 +17,8 @@
>> >  use crate::bindings;
>> >  use crate::pr_warn;
>> > =20
>> > +const ARCH_KMALLOC_MINALIGN: usize =3D bindings::ARCH_KMALLOC_MINALIG=
N as usize;
>>=20
>> I think this needs the following diff:
>>=20
>> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_he=
lper.h
>> index 84d60635e8a9..4ad9add117ea 100644
>> --- a/rust/bindings/bindings_helper.h
>> +++ b/rust/bindings/bindings_helper.h
>> @@ -84,6 +84,7 @@
>>=20
>>  /* `bindgen` gets confused at certain things. */
>>  const size_t RUST_CONST_HELPER_ARCH_SLAB_MINALIGN =3D ARCH_SLAB_MINALIG=
N;
>> +const size_t RUST_CONST_HELPER_ARCH_KMALLOC_MINALIGN =3D ARCH_KMALLOC_M=
INALIGN;
>>  const size_t RUST_CONST_HELPER_PAGE_SIZE =3D PAGE_SIZE;
>>  const gfp_t RUST_CONST_HELPER_GFP_ATOMIC =3D GFP_ATOMIC;
>>  const gfp_t RUST_CONST_HELPER_GFP_KERNEL =3D GFP_KERNEL;
>> diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocato=
r.rs
>> index 25fc9f9ae3b4..5003907f0240 100644
>> --- a/rust/kernel/alloc/allocator.rs
>> +++ b/rust/kernel/alloc/allocator.rs
>> @@ -17,7 +17,7 @@
>>  use crate::bindings;
>>  use crate::pr_warn;
>>=20
>> -const ARCH_KMALLOC_MINALIGN: usize =3D bindings::ARCH_KMALLOC_MINALIGN =
as usize;
>> +const ARCH_KMALLOC_MINALIGN: usize =3D bindings::ARCH_KMALLOC_MINALIGN;
>>=20
>>  /// The contiguous kernel allocator.
>>  ///
>>=20
>>=20
>> No need to resend I can fix it up when applying the patch.
>
> Hmm. Maybe that depends on the configuration? The constant was generated
> for me. Either way, happy with the suggested change.

That is a bit odd, I'd like to understand this before merging.

All of the definitions in the kernel are defines that shouldn't be picked u=
p by
bindgen. Are you sure you do not have additional local changes?

