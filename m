Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F7EC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 09:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B2E6900052; Wed, 13 Aug 2025 05:32:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EEBF900044; Wed, 13 Aug 2025 05:32:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DEED900052; Wed, 13 Aug 2025 05:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 087FC900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 05:32:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D0931402DF
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:32:19 +0000 (UTC)
X-FDA: 83771218398.09.80F2D4E
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7941314000C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:32:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CjlgnPH7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755077537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yz1d7edJo/Q+HsJ1HH001Yh+poWlDoP3asDYz4tNc04=;
	b=yiA6MIndekhU5QJeORCKwzEFXBpm68tpTDcQELAaCqzddnzAWp0y5RNjO4PJF0Dg20EVqs
	0oFjlr4CFalwL9AcWQummYzQO2rK/QjxgieLUQT+Sy0WS2sL2bBv2Ipa9GTiyVjwb+HpF6
	9sLEhviUuIBu6S6ixJVZb35r35uw+lw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CjlgnPH7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=aliceryhl@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755077537; a=rsa-sha256;
	cv=none;
	b=63HUVajNDr+yaLevjD8ALKKmOTqf9M/7CFJuWxu0lJA+qsjjsSdi9Ti+E9U6xH89RGcbDh
	FRTRK9VYz6KnXeYlPUp2ijM1P3kADXq8EW3EQZYn+jkT5Ib7te6YWovcKhpql3rSJx0Gzs
	flud8ceoRLmK4yX2TzOfnDwFhr2ZqIk=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-459ddb41539so20310445e9.2
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 02:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755077536; x=1755682336; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yz1d7edJo/Q+HsJ1HH001Yh+poWlDoP3asDYz4tNc04=;
        b=CjlgnPH7NSCmbIz1oEU6BiB0kB9JKZgMGO1XRCPBnrakvYappfy8iFfP349KCTRQnS
         a0+BZcede66Xm7aEf3aU1UGP3+0AQV7T+EOdnRvYlIB08PMwMDj/pfcsqdRz585ZJUfG
         K1ttwldfjGk/IRtfHNiGjnqrkAAXABRq295h44JDAV1JpLrXYx5EHLx/nKK9yTqCuTU1
         b42Q2evJVPs/BB8ZXGPqsTpRF3DsVu+wKUvguXEJSkMEDyFYL3ALkQsrpwhRZ3YoDtvU
         TXD1l6d6s7bxFRoQeRAccuTS85Gjn6eF6rnvdL0Nwb5IAUNH2NY/0NUv+Wn+950k5uUW
         hCSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755077536; x=1755682336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yz1d7edJo/Q+HsJ1HH001Yh+poWlDoP3asDYz4tNc04=;
        b=mjvGWERxanJlLQ+NZHdaP+RH0FdEIU6UB2m5HxKYd9UjNG1frYvJWYcvfQq2Q5ACa6
         ek0ZWgHq9M9dVKPJBS108C7XROxm1LgiWN7jMe4SoHqYaXaumoh9GI1HSgO3lTyv28L7
         81Lj/7Fa5tnrDRDSLKWoiXurYkIjRdt5gr0Uz+MZ0O82QK+5Wocpeuq9INiUxaG/EpGp
         8B18bJCepyG8MkwKmR301he0eVGiyKwkevId1VhTl3qLh4tlxNqw5T9iHZ9GReM3GI25
         LerHpYrqEYeKhFntG+CHmvuiMxvztZd8KOm+o0RRt7NdiWcT6kvv+gJTEC8s93ycuctT
         CDsg==
X-Forwarded-Encrypted: i=1; AJvYcCVxxPW3zCTKXSdXXz50wkBAnlb3+Lrkq+NCzGotaE7EGPLJy+nWPomIpXxXPRnKfGOfo9/FViffKw==@kvack.org
X-Gm-Message-State: AOJu0YyfiRWlMzA5wLJFEZmnbaOaZQVhJuYdZL9OCMyorx4BYoQBTiil
	IHbRZ7s8gTi6oLD37zlikiCpYpHOwMlmNgbDnKXy0sNFDqAzCrTsIGGxqNkQAC5361z2HESoUmT
	j4JBSWZv5b236g1HxxKdsSgz/uktTmCLiiBcHqwUx
X-Gm-Gg: ASbGncvI9pHYG3NCYN12luQlk/KCgrH1WGnm8sQiROWuHzn8XZyjMeustYs7pMHlczS
	A3FBfhibaympUL66qLQK+viGayxnoB7VDCYSR+UfClY2VgbYwL42uYwI2ULpYoV/aKQdsneCYKV
	07uoEnrRN6o8GDKkkd3woP+PWGZqknSlM0Qk5HYISn//no1vUI3GW8PDlSQuzVlRm+mK6+MCB53
	yMvWjh/fVp84Eegfa708fcTW/W6x4V6VuWQAwJG477xDfhW
X-Google-Smtp-Source: AGHT+IFj4eeSkV4YCEm6XMyz0NGDwY1SK1orCsey4/K9VCwcmampRVZs860kHi+1N8EEFxllSFaXv3TdJ9X2E2BozSk=
X-Received: by 2002:a05:600c:3507:b0:458:affe:a5c1 with SMTP id
 5b1f17b1804b1-45a165a2d68mr19346975e9.5.1755077535541; Wed, 13 Aug 2025
 02:32:15 -0700 (PDT)
MIME-Version: 1.0
References: <20250811-align-min-allocator-v2-0-3386cc94f4fc@google.com>
 <20250811-align-min-allocator-v2-1-3386cc94f4fc@google.com>
 <DC0N2SBVHIS7.2P91EJSTIT1FM@kernel.org> <aJxESG0l4-kyUHXg@google.com> <DC16OLU29VX3.16T0QDJF7Q18P@kernel.org>
In-Reply-To: <DC16OLU29VX3.16T0QDJF7Q18P@kernel.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 13 Aug 2025 11:32:03 +0200
X-Gm-Features: Ac12FXzv1OKpnnMnkVcOWodh0QqpLsx6V00O4CPKH5Fp0qCDXM23kP48mbFno2o
Message-ID: <CAH5fLgj0kjGBwZFHjErsa7MCV1fz4xTWwrZAcFzHHnkbvS=OMg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] rust: alloc: specify the minimum alignment of each allocator
To: Danilo Krummrich <dakr@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Tamir Duberstein <tamird@gmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7941314000C
X-Stat-Signature: ucxqdyx7mhosi44i4amzawfnefchbgy4
X-Rspam-User: 
X-HE-Tag: 1755077537-590889
X-HE-Meta: U2FsdGVkX1/d1qVLLMYIezgeJ+q/4Ojkc8izbGSvDgBzaA/SRqQa9uSNxvvcrXJ6bKruiS8zJE/KKxpIAU0MdN1ie5GqssutjIlrTXp5qbHGyqST1t27sLw/+ge5biQqhxuzg3fvZwWe3yCIdZFDCafwAyLpxJ0sQcBE5tW5wFdYR3e+cTC+wOYJNCBUUOaq2tg85ubStGAQ7aQZLznJqg63PgfrFRjeecboc4b/odZ2mE7ufXQS8Z7oAb5ppN76A039CYMhRRkYCClqKHjberZsVGpnW8WvP6PgAbUVFjYxcvtTIm5BGDLUOlfaqU6Aqc2/MhzZ+Wx48RWJoByX/zfKkysRM1EAswENZmUUF0R0gR8DL1knbFBaJ/anujI/dPAMLzATHDUL93xtDKIoh02/RhIA22ytRZrKs9hCSbsO5GXvG9eABfZNa7bJciTRsFvEYBdT0yY/iawyIn7mA+akQ5uuKoGjQ9Xbaf7rhVGiutzvmx+6kgTnm4UwDtWDtJC9r7LSgPFCxwly8WVrGCFnofWxBkfA6qv6dQpHG7b0TudFsJ515AjwsfrmWTwZ7dMiz0r2O/9K0ALHTMauO/C4qr4lubb6M+nAQncLsKn9TfBlezKLjMQFTaIIia8+T4WG2dRtqaCeCg9e8Z5Sy4J3YIyEguZYAJxDvGhCWSIZYWGPnZ+NWFhASPYhTqlmp25qKfnAH/NOM7vSJrmgVNHhTAwcmKo5j/4qRmc4lDp48IApgW4d37MuLMe0kMDa27cy2ExuFMkNrpykUDg+KnHYDojorjjhIDdcAbD17gi7K9rOD+cfyILE9JlZNiK9ZojoPWDUeQ2Nn+SELwIgKbKakxlmz7Ba9PKqvRXRIsAbFB/tBSziwzCHIX0aGAmrGr/tIAbOvdJN7kVTKpToActmxqjBprfW+bvbFHYGFQBDijlOD5VpcLpcl18c+/3DU/Ub53CYdiHI3Q0IJbu
 Zf44vOP+
 daO2yBocBUEHtDive1DrAQd/WPr499l0Pr1GPmAbZIbn8R/UsA7s6Ckj1s9ARtMB9/dNe2S9xGls+n/aqZRjNIPD6doy8z74lEQGEChT9kuRu38AtJ4eYRmM0O99LICNdmMO5chOcExT4TaGx50F252nTqQRl398JyehLsgu52u3GPxu2HvlFSP3Nyq26oS2MlmPmtfyEkaQWYu0ohOUkGGSq8YJnAb8e2QKZpJFVt/c1892s2+MH+KKh1cAJT2CNTl9u1VAcA47zFdOj7WhiW1OlyxmDcowyygIv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 11:14=E2=80=AFAM Danilo Krummrich <dakr@kernel.org>=
 wrote:
>
> On Wed Aug 13, 2025 at 9:52 AM CEST, Alice Ryhl wrote:
> > On Tue, Aug 12, 2025 at 07:52:35PM +0200, Danilo Krummrich wrote:
> >> On Mon Aug 11, 2025 at 2:31 PM CEST, Alice Ryhl wrote:
> >> > diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allo=
cator.rs
> >> > index aa2dfa9dca4c309e5a9eafc7da6a8a9bd7b54b11..25fc9f9ae3b4e471a08d=
77130b374bd1397f7384 100644
> >> > --- a/rust/kernel/alloc/allocator.rs
> >> > +++ b/rust/kernel/alloc/allocator.rs
> >> > @@ -17,6 +17,8 @@
> >> >  use crate::bindings;
> >> >  use crate::pr_warn;
> >> >
> >> > +const ARCH_KMALLOC_MINALIGN: usize =3D bindings::ARCH_KMALLOC_MINAL=
IGN as usize;
> >>
> >> I think this needs the following diff:
> >>
> >> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_=
helper.h
> >> index 84d60635e8a9..4ad9add117ea 100644
> >> --- a/rust/bindings/bindings_helper.h
> >> +++ b/rust/bindings/bindings_helper.h
> >> @@ -84,6 +84,7 @@
> >>
> >>  /* `bindgen` gets confused at certain things. */
> >>  const size_t RUST_CONST_HELPER_ARCH_SLAB_MINALIGN =3D ARCH_SLAB_MINAL=
IGN;
> >> +const size_t RUST_CONST_HELPER_ARCH_KMALLOC_MINALIGN =3D ARCH_KMALLOC=
_MINALIGN;
> >>  const size_t RUST_CONST_HELPER_PAGE_SIZE =3D PAGE_SIZE;
> >>  const gfp_t RUST_CONST_HELPER_GFP_ATOMIC =3D GFP_ATOMIC;
> >>  const gfp_t RUST_CONST_HELPER_GFP_KERNEL =3D GFP_KERNEL;
> >> diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/alloca=
tor.rs
> >> index 25fc9f9ae3b4..5003907f0240 100644
> >> --- a/rust/kernel/alloc/allocator.rs
> >> +++ b/rust/kernel/alloc/allocator.rs
> >> @@ -17,7 +17,7 @@
> >>  use crate::bindings;
> >>  use crate::pr_warn;
> >>
> >> -const ARCH_KMALLOC_MINALIGN: usize =3D bindings::ARCH_KMALLOC_MINALIG=
N as usize;
> >> +const ARCH_KMALLOC_MINALIGN: usize =3D bindings::ARCH_KMALLOC_MINALIG=
N;
> >>
> >>  /// The contiguous kernel allocator.
> >>  ///
> >>
> >>
> >> No need to resend I can fix it up when applying the patch.
> >
> > Hmm. Maybe that depends on the configuration? The constant was generate=
d
> > for me. Either way, happy with the suggested change.
>
> That is a bit odd, I'd like to understand this before merging.
>
> All of the definitions in the kernel are defines that shouldn't be picked=
 up by
> bindgen.

It is possible for bindgen to pick up a #define in some cases. The
main case where bindgen fails is when the macro is defined in terms of
a function-like macro. This is why we see so many failures with _IO*
macros.

>  Are you sure you do not have additional local changes?

Yes.

Alice

