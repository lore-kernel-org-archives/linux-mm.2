Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7529FC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 07:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC1548E01C8; Wed, 13 Aug 2025 03:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9BE28E01B6; Wed, 13 Aug 2025 03:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAEE28E01C8; Wed, 13 Aug 2025 03:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ABB628E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42FCDB7DEC
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:52:44 +0000 (UTC)
X-FDA: 83770967448.25.70A7820
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf02.hostedemail.com (Postfix) with ESMTP id A40FB80008
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:52:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nVXuxxnt;
	spf=pass (imf02.hostedemail.com: domain of 3SEScaAkKCI0r2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3SEScaAkKCI0r2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755071562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=02qDuB/EcGaJVS8+Q8TL27euIcDkVRhwVcM5c3itE0g=;
	b=klb1D+Wm40rTPb2TVWYMtQ2gdcYHzgpaYkVC+EkVYL9H43Rpc4nUNzT8SpLYEgSrdWU1dG
	Rx80yhvilMDI6DdygeIb1CNZZdFkTLeQOUHtqPGmBNTsRxtCgWptUwJnsSiIE//oHKDJHk
	DslRri2uIQWq94lVGdjADeYJm+C6U3k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755071562; a=rsa-sha256;
	cv=none;
	b=RukMmyl6640v9Ztv2t5Hl5Bm2uLnUcbOoUhIHbrDrw84tm+mApcLcF01/ceT/toiktPO8L
	ZlcOSvRMh+T1DWKQbfKV7ta4m67RgNH+9J4eX1LP7j0m+293wZTcuYiiahM3R/Cb+HMBPE
	nGzA79PkRIqdwvquvrS0Rg1hXTjUj70=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nVXuxxnt;
	spf=pass (imf02.hostedemail.com: domain of 3SEScaAkKCI0r2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3SEScaAkKCI0r2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3b79c28f8ceso3782091f8f.3
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 00:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755071561; x=1755676361; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=02qDuB/EcGaJVS8+Q8TL27euIcDkVRhwVcM5c3itE0g=;
        b=nVXuxxntxomOCEnMYUuKa8AbqeZwt7mJnlDWn+ac7y5xTWGtJ0GOZ/ODik25aYRlWM
         Tgu6Wh39OWJiCTauLUkusxEnhtQOfMuWHO740+XrjUcZjfSn3irbtc85WvYPtaVAHZ7C
         6aQNgpYGso/2UqMoUmFeIdXq/OsLnh1y5VXCmwN6WosOJoSeInY3k99FtSiY4Gl64Y35
         RcOSUJhWLJP9eV1SAXwQJZyqiTKLlUS3dTTWg9U91B41cKZEtLEHW9p32Yxi7YB7bIIF
         x0Ge7FXqgtWavddPh3haaElQy9EbyYGHwHOUYriSJ7qfhV7ZN/3lOEYm8iOHfcetEOe4
         gt5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755071561; x=1755676361;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=02qDuB/EcGaJVS8+Q8TL27euIcDkVRhwVcM5c3itE0g=;
        b=LRJJYJ9Er0M7JLB0j0hVu2/E/a4Z5FSwYWGZ52S6XMv3XnLzfMFqloyZ7Ykobv/nWM
         E7bIe+6ep2T4oYwhpPCSXU1fTtyeZFQfMYRyZgTW9FsdW1BAFo7OZCtYg92g+iJSbyIh
         fZ1dNlsxMFwLIrtFvnwJd4PAqHjaRwmzqcn2Qr250UcAnuX5sz+mzI8KJUxNb7MnKMIx
         f6syK5zND1DMXNONMMFWoBOPC2FssJmX0Zk0DwAT+tF0IG+buTG6Sze5sHWWCEswAEh8
         vYi5A7WBILKkQ/+12bObnD38ygjyMJhzMghVTc6GjGfucBr00sLmDzO2D/6F/MD8wSt9
         WJwA==
X-Forwarded-Encrypted: i=1; AJvYcCUn6Pxry6ugTRfSRntRbxE750sh841/196EWRow40B+FZuSOM9HD4uMqFRirE+v07p4zQGVfrrF2w==@kvack.org
X-Gm-Message-State: AOJu0Yz+/yxh5WLZfwUT5FSTlP1RFzNH4RJH/TWVeMXDkMTVmkCciCgj
	PSES4E0IZP1qR98BcT3KiLMbBgZJgVVeGtPo1ZnJnmZ4d+W3Y6rqAtF24gZp50zLHZlXzVF2B1H
	c61oeMP1WA8UIqIuZtA==
X-Google-Smtp-Source: AGHT+IFQOnB3WTKhyHtvWJmH83iA6/rYttG73Tf1N82jwPFXufEqb0tOp/a1EyEQXFyeHLXn1qK53ixfr0QTKsU=
X-Received: from wmbjg12.prod.google.com ([2002:a05:600c:a00c:b0:458:a7ae:4acf])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5d85:0:b0:3b7:61e5:a8a5 with SMTP id ffacd0b85a97d-3b917eb5b43mr1445076f8f.47.1755071560984;
 Wed, 13 Aug 2025 00:52:40 -0700 (PDT)
Date: Wed, 13 Aug 2025 07:52:40 +0000
In-Reply-To: <DC0N2SBVHIS7.2P91EJSTIT1FM@kernel.org>
Mime-Version: 1.0
References: <20250811-align-min-allocator-v2-0-3386cc94f4fc@google.com>
 <20250811-align-min-allocator-v2-1-3386cc94f4fc@google.com> <DC0N2SBVHIS7.2P91EJSTIT1FM@kernel.org>
Message-ID: <aJxESG0l4-kyUHXg@google.com>
Subject: Re: [PATCH v2 1/2] rust: alloc: specify the minimum alignment of each allocator
From: Alice Ryhl <aliceryhl@google.com>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Tamir Duberstein <tamird@gmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A40FB80008
X-Stat-Signature: ikhqcr13uomx71fkatyfrzzbgap5a3jm
X-Rspam-User: 
X-HE-Tag: 1755071562-343405
X-HE-Meta: U2FsdGVkX18kIp5ieykieNWATZOzewH9b5NBzJ4TwALwf1waqVCEqgFK/asN4v1jPYoDgK0sJjEbENOVDh9THxgY1PzRP+HZv/FK8OG16yuHi58k5EWS7Vrn8hZpEbIq+FySsNNvA0OU2Yf8hd4Hia3NNwPlTM1aZobm/IV2xY4QCp3j7wP2lOXHc8W6F2nbENCodZNU09Xbhqtly8QMervr+xyQE6EHE5AVXPFVyhN7uLz6v3mqo27f9D0ZmQ0LgLwiXu0RZgQj+okLxmhGIOHfmV0LkjQEiTSX6vOyVPWaCcClqq2ClMOmnsFsUE4pmHsKqm5Q1iYMYS12BeNCRwXJVPgTWAfLgqxgVk0SrueF3v05DmAxNPZTwwrqgsRHbZFar8sl2qMYbWovEDW5muM9T8O+AVJZP+zPx6DTkkMik+q6dcKnIqotEinJMu4Lt8LlQOnYZZCBs07bhtL2ie90vy9eLdWXPVKTLNg/dGNgh5fPKYH+bAUz7+coNQGx12nYHaj+csEWfT0A0DVQMEnwSDl9DKpQXX1oo6anMc1RpxdZmz6hhHmED18HZj/7dim6dEz/yVZ5/Sl0S7Tq2Xvgf/xzgnqm+HS1tRy4bhv+l8XS5A6CaShWjqeAtDuDhqZuDz0/2ZhJ6WgU3QjBi0EFfHMfyXEFf0w8niZ7ciPnP8KYKOgM+v6pIrgfRFnLyg1W9dIG0Z8WrBod/OvW7JxYjKXAOOE/QuL4eAR1ugxJHzGFhmlR+3LSiK1FlDEHr0K+NmozI13ap4Y+LOivlzrkwUlcfGj5/qdu+Mf1KqyI4c6YvGBlJr3HlV58G/LTwvVwcBea7d33V6LtoJoZ4IoD7PpKz3xqav93/t6NtlVvDSMa1xDFOvrJUcByaSft1P5wJrLKPh4YpMJ8Jrdh0OQXIsu7rjPkxjgvPxAsiyBQy8skOhxEDIRyQhkGZFKsJpnTzax0FomdEIysaHN
 wo0VTGz6
 Aqn2CRLbTkm5Glc0kTuXFQF9s1wInZuy0A2PyVYBTvGAQ+6aBuKQF0SV+ursgbzMIch13/oo2Syq3t1I381CtPvcvt+bH3uyNRZMHt9NT08RkF3+RViGJVp2JqT3KlOuET25CByJ9rFwoetDSJzJVmFQCJHmkbmRrlg03KSsBFsdZBJ7MGXvpTEg25CcBQgM78lOMmixE+9KQyzn7/i5IOI0s7/Owk8sEUqXaPgeF4PZwm2DcMW7QLKRu1u3u/5WHDX/l9NvII1FaMveqZ6vYyjHIe56xOud7c4iqLCEryA8Z5stwG5gwVEvkDIKd4IIdvmxVwXzt92z6DBoGCH8P6AeczRiiJVii7wX8pBueRTMflk0Ne/fnFvVzjSsohlh54gCj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 07:52:35PM +0200, Danilo Krummrich wrote:
> On Mon Aug 11, 2025 at 2:31 PM CEST, Alice Ryhl wrote:
> > diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
> > index aa2dfa9dca4c309e5a9eafc7da6a8a9bd7b54b11..25fc9f9ae3b4e471a08d77130b374bd1397f7384 100644
> > --- a/rust/kernel/alloc/allocator.rs
> > +++ b/rust/kernel/alloc/allocator.rs
> > @@ -17,6 +17,8 @@
> >  use crate::bindings;
> >  use crate::pr_warn;
> >  
> > +const ARCH_KMALLOC_MINALIGN: usize = bindings::ARCH_KMALLOC_MINALIGN as usize;
> 
> I think this needs the following diff:
> 
> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
> index 84d60635e8a9..4ad9add117ea 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -84,6 +84,7 @@
> 
>  /* `bindgen` gets confused at certain things. */
>  const size_t RUST_CONST_HELPER_ARCH_SLAB_MINALIGN = ARCH_SLAB_MINALIGN;
> +const size_t RUST_CONST_HELPER_ARCH_KMALLOC_MINALIGN = ARCH_KMALLOC_MINALIGN;
>  const size_t RUST_CONST_HELPER_PAGE_SIZE = PAGE_SIZE;
>  const gfp_t RUST_CONST_HELPER_GFP_ATOMIC = GFP_ATOMIC;
>  const gfp_t RUST_CONST_HELPER_GFP_KERNEL = GFP_KERNEL;
> diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
> index 25fc9f9ae3b4..5003907f0240 100644
> --- a/rust/kernel/alloc/allocator.rs
> +++ b/rust/kernel/alloc/allocator.rs
> @@ -17,7 +17,7 @@
>  use crate::bindings;
>  use crate::pr_warn;
> 
> -const ARCH_KMALLOC_MINALIGN: usize = bindings::ARCH_KMALLOC_MINALIGN as usize;
> +const ARCH_KMALLOC_MINALIGN: usize = bindings::ARCH_KMALLOC_MINALIGN;
> 
>  /// The contiguous kernel allocator.
>  ///
> 
> 
> No need to resend I can fix it up when applying the patch.

Hmm. Maybe that depends on the configuration? The constant was generated
for me. Either way, happy with the suggested change.

Alice

