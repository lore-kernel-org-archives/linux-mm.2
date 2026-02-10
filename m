Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A38D0EB26EA
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 16:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03F766B0005; Tue, 10 Feb 2026 11:58:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023976B0089; Tue, 10 Feb 2026 11:57:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E45E26B008A; Tue, 10 Feb 2026 11:57:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5D5A6B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:57:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 99FF4BA2EF
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:57:59 +0000 (UTC)
X-FDA: 84429154278.27.364F709
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id B1376A0008
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:57:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aKrzPkr5;
	spf=pass (imf15.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770742677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JuTr1v7vZJwrCLefGdygjnFVcvKYo7h+RejLuFTqn2c=;
	b=u7wtMObsCBxt5868NpOUNYoHbPQSlq/fn4eyU4lihqumLfDgUWDh3l72NdCLcIwGgeE38c
	RSpVrwOEHOQ6/1ScLzLmg9kxOPFjALQ84Ot9KgBhupRusNn1UHpm1Ncob4nZsSFQBlz4Fi
	ilqeQaQ3oJxeyjBtLtnmtl+VnXsZAWo=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aKrzPkr5;
	spf=pass (imf15.hostedemail.com: domain of tamird@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=tamird@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770742677; a=rsa-sha256;
	cv=pass;
	b=C01snJa7amQlmOnNxFUV5Z/m5kzLrZytzZmhY+nSjgmOTOlbUAVOHyvGZdZWfvNXvZDMEm
	tYsV1i0ZUJnjYlDvKITUQhyZAl9x/MeavDzD2fm8CnRwwTQyBr34Nrm+pcg/zdubBbTDUw
	ampXhZ9m7blprAnxBt0EfkPw4Om18q8=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-385b9be0759so7618131fa.3
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:57:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770742676; cv=none;
        d=google.com; s=arc-20240605;
        b=lbfc2ba/GDkRgm6cuPVq3s+1wIF6mPJbPwtickyB6PxbvZICT5H9UsyuZuQJqGi+cF
         QsqvCQpHU1+wHfe/JMHBOZAfjT9Bd2zfM1LjNA6oRWdRdY/o2DhO27754wU0ZEKgisaL
         P5QGUnotyK63x+vR0y38S73rl0dOGYRya3RXew1COjAnjKgLMMc899WsonhmXRA0ssV5
         SkSK63KsUx2XTbeFE11uS1c5FiUCPoQvBoVv2FbXqz+VFP9IFTRrf5dNL+yXR7OcCbgg
         o08L+ZSz+FfMA56JmLdILFAPvkIyv6KL8txPVIIIqmr4HrYO0qMNiJjSjxoUWMzYFUjR
         ZPRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JuTr1v7vZJwrCLefGdygjnFVcvKYo7h+RejLuFTqn2c=;
        fh=L/zBlkZELLzlCKNCZoYkBkns6uvha11MkSNmO5sAuUg=;
        b=JU6Qxj+8IgQZBbC1Gxx6DO7QR0kA282QgotqDJ3miv1s7JX/HSQC9ACF7esxdP/+u0
         WJ6eRZnEgcg0ph+HyF0frl81OkdZo8L+BAtklYxP6J4SqfDFnoRF/qxOTZ3CnCLbiZM6
         PBz6CXNuQUQgvj037OtAizNalC606XCNmHmuCEtxJzNb9fnO/rQExoQTlLsyme2aRZz7
         Jlv5wgdo3jHHqYtaMAkasyTOiwoNuSJcbK/V5BnkAf7AvtDOuId8cbELrxfP9ShdPBVD
         2nUG/2zWQwqFeXqjX/IvldxUbV97uV2i8WcDorsQDjYXLShybaQdYLhfKlakmsRVKRNU
         srew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770742676; x=1771347476; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JuTr1v7vZJwrCLefGdygjnFVcvKYo7h+RejLuFTqn2c=;
        b=aKrzPkr5kMfv3EkuBJ7qcafHgZw9Zt+7fy+I8efxAQT/u3rWUBdOxEueeoXsz/yzoC
         4cKWpK1RXg74H9FwRKeULtLf5XqpLvdS2N93nXfmt0yKZJIP11WARaBCbFQ5+fg35uAO
         YMq/edFCkxTUCGulLhRlxfz8PD/U3zELyY+jGTbzSr6vxkG/GHlOIkqdWv/GhsFtIgvK
         J6nZb8xFMaYa02W4r8JuFRU0ZmQ3AM1lyhWHjBmF8QMngGw1PlvUnT235U+EelmKYusv
         WyOJCkm24joRNHHA3pIhx3sN5fc8xyIQN54X/H+ut7cur0a1q500q5ZHkxqyF9nztw3t
         Ml9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770742676; x=1771347476;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JuTr1v7vZJwrCLefGdygjnFVcvKYo7h+RejLuFTqn2c=;
        b=bFVdHdnndRaOw2RZsUVDdKEnXwLasge5cAiwKGv4QL/hBsrcVPsNZY/YwzcjXIL3tI
         /ttY2YBcfa+wIv3SsDvVw9g3w/3/HTA+GP1BTPnYltLFEnCkqQNEBICclenXfFkGNbDb
         2Ng/DgAX/DhltppIJ6vl6+p7mvfRR3dn1y8JKvJIZsIxe6Q9ayOx3sU6j8HoNKYjx8wk
         aQt8yJvXGyVSLzkgJ+79w/tKwjRZuHq2T60VyvFKwQ6QmoMM3fL49K5iDmHUbe7s+/i2
         pBhp5vFNZioOO9id7HrNqspdk1sWd6BQDr/C2LIuX4qplDSmZKT2FZhWDTmpbDu6TG9A
         ajNw==
X-Forwarded-Encrypted: i=1; AJvYcCWP5Y4xTistxJ+kjLhzvQs6p/kVl7RZvUjulbLhnG/RXZW9AENrjXv80/4jNdJwirbjh7Ruw9iyGA==@kvack.org
X-Gm-Message-State: AOJu0Yzl20lNGQOyEuZYd9bdwBCO1ZdbLmaaI/Bb7JZgvvAYHUk4elKP
	aYSmb/n8PJ23P8YBOMseRnYt2TByzfPj8ZDlH+OoYT6zQVzDtvY4St15xeolQEFbylZp9bq3k/f
	UeQAoFipfYEUEAI+VKjCzqn0a3KkWs9s=
X-Gm-Gg: AZuq6aLL1+6KoJHtqgRmzb4aNDxu2fK4vUubaa/08o6T/gYREfNkrZd5u18u04/7nz4
	XuOze01lhXUmBA2AZs5yLfZQAKWfWOP6eo1Cif2Qy57t//HDIerK+kPcMtdreuFraofDK7RI27b
	miCitu+pd1OJWCYud+hP3SGx65PtvrdVEyp0CaAibqJjoHpIk791ZcvOhZVsFa9NrDBHW+KTzVy
	K3Hojp+s80AVpIOg55RKeyThwKAaAdbCxM71g95dAo2tVW10vTgrb6AqajDCnJIRptKNjL94+oz
	UAibHxHlzUatJPCzVAhI7PYBerWNQzeoOfCxIlYZCVjqtNEkB6IFb2VyIG9elQ7XAhJ8KWa9O8z
	AQhRRgIy7nMDd4VmJKvT5
X-Received: by 2002:a2e:a5cb:0:b0:386:8f97:d0b8 with SMTP id
 38308e7fff4ca-386b5106ef5mr52202351fa.20.1770742675630; Tue, 10 Feb 2026
 08:57:55 -0800 (PST)
MIME-Version: 1.0
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org> <20260209-xarray-entry-send-v3-4-f777c65b8ae2@kernel.org>
In-Reply-To: <20260209-xarray-entry-send-v3-4-f777c65b8ae2@kernel.org>
From: Tamir Duberstein <tamird@gmail.com>
Date: Tue, 10 Feb 2026 11:57:18 -0500
X-Gm-Features: AZwV_QjO2-EsPct575RPXi7JROMwJ92pVr3PLA-_MmegBYrDreR1XZieS5jWe_Q
Message-ID: <CAJ-ks9=hWB2eFcEj1obfsoLvK15=YR9y=hifxVyeB=mJOz+gXQ@mail.gmail.com>
Subject: Re: [PATCH v3 04/12] rust: xarray: add `XArrayState`
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Daniel Gomez <da.gomez@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: d8p5xwzfowgcshx6x55m91giob5t4bhq
X-Rspamd-Queue-Id: B1376A0008
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770742677-810356
X-HE-Meta: U2FsdGVkX18072xag4HPwnYCQ5djL6UdN875+aLRXirYHQh95exnT/SEz3AiXIrijteqEo1tDCXOQ9jsQz6EORYoefDpzXfxdehb+TekEiuUwuA1RP6FA7D3NPLUQwiO2xP9JdNUyH+vzsNv5xH2N3G4tX8Xg/ag62e259bUjTICtyaS1+wD8WJGOaVpPeviGY7bGOVtbmyeNpEeGEDTIx7rzsLU2OIz653SgwTcO3O8ADZocDt3mjhHQS/i3SCBaRyaVzHsR+34cXudVyUIw+rfDzi/lZ6M9DS2qx6ypcwSYsRZGH/OyMZJrEy0tKvIlYHfupwW0xVjw8LL9fHft88Vh+qTeAhNOKbUDpdxMk3yaeUgRzrY2QOp9Be00iv9TXJWBRCG6/+iGuOkBlil2fCJ7FbCBFzHhX5orTwoORxv0swTTimyzokcnBWPHTr/r9qYbsQoWtJvq8+5TMF2PTJUUWJ+tSHXCjXXOXDngHhUmPJuVJPj9oA0XileCK3IphM7Mjrm+TEfp0tghbQylFC2vOwKkxb+p5sQTVicYWC59QZwi8+YEYPOC9NGIikIuXRSIOnsVlCwUCy1ucRKUutcIqTOldcM8pcxodLaGIqSYJT7rW8cAdTPFxd8OCyi99UaWq0Pqyfbh7xmKdgVikG0gDB/s8wgf6T/3+escFkVOkW0xcON21jsSKWikrxC8URgRG7sIcy1hXYjdn4+5RjPu1md3+xHK8SqLe0SiVhQ2YnmOfmrTKIY0bKYVNmw9I+xzrSYPXa8//Te46qybmJx30pGTk+V5Phz+Kn690w/XnWo6fA2fzrH2ng+LETFv18U15dgdtBI4x/hl5wanUE8aMOLfvRygRLv9MvgCyhEnf6ciAz/HPFhw2CQ2beR/qmsUyBIY9CVOzSofSl28gr1NkYUKnOfhWQaPRtqrhLTnc2+eYNZwNhr1nzHmew4JBC40TtPzSecNTyM/sL
 OSdaZxEX
 rxpW+NcOz2PxIS9YjjhBVUzBuGHt+IewnSpqYEJboAMPPOAdDWgNFIVFKlAJ6ZiqKkUxLlo2zZiZsWCmtXpGUfXJu4r9jhrRhqysKwcQ9HtW+ic0SeFyEsSZye2GeqIa5DiSb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 9, 2026 at 6:39=E2=80=AFAM Andreas Hindborg <a.hindborg@kernel.=
org> wrote:
>
> Add `XArrayState` as internal state for XArray iteration and entry
> operations. This struct wraps the C `xa_state` structure and holds a
> reference to a `Guard` to ensure exclusive access to the XArray for the
> lifetime of the state object.
>
> The `XAS_RESTART` constant is also exposed through the bindings helper
> to properly initialize the `xa_node` field.
>
> The struct and its constructor are marked with `#[expect(dead_code)]` as
> there are no users yet. We will remove this annotation in a later patch.
>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  rust/bindings/bindings_helper.h |  1 +
>  rust/kernel/xarray.rs           | 41 +++++++++++++++++++++++++++++++++++=
+++++-
>  2 files changed, 41 insertions(+), 1 deletion(-)
>
> diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_hel=
per.h
> index a067038b4b422..58605c32e8102 100644
> --- a/rust/bindings/bindings_helper.h
> +++ b/rust/bindings/bindings_helper.h
> @@ -117,6 +117,7 @@ const xa_mark_t RUST_CONST_HELPER_XA_PRESENT =3D XA_P=
RESENT;
>
>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC =3D XA_FLAGS_ALLOC;
>  const gfp_t RUST_CONST_HELPER_XA_FLAGS_ALLOC1 =3D XA_FLAGS_ALLOC1;
> +const size_t RUST_CONST_HELPER_XAS_RESTART =3D (size_t)XAS_RESTART;

Please add a comment to explain the cast.

>
>  const vm_flags_t RUST_CONST_HELPER_VM_MERGEABLE =3D VM_MERGEABLE;
>  const vm_flags_t RUST_CONST_HELPER_VM_READ =3D VM_READ;
> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> index ede48b5e1dba3..d1246ec114898 100644
> --- a/rust/kernel/xarray.rs
> +++ b/rust/kernel/xarray.rs
> @@ -8,7 +8,10 @@
>      iter,
>      marker::PhantomData,
>      pin::Pin,
> -    ptr::NonNull, //
> +    ptr::{
> +        null_mut,
> +        NonNull, //
> +    },
>  };
>  use kernel::{
>      alloc,
> @@ -319,6 +322,42 @@ pub fn store(
>      }
>  }
>
> +/// Internal state for XArray iteration and entry operations.
> +///
> +/// # Invariants
> +///
> +/// - `state` is always a valid `bindings::xa_state`.
> +#[expect(dead_code)]
> +pub(crate) struct XArrayState<'a, 'b, T: ForeignOwnable> {
> +    /// Holds a reference to the lock guard to ensure the lock is not dr=
opped
> +    /// while `Self` is live.
> +    _access: PhantomData<&'b Guard<'a, T>>,
> +    state: bindings::xa_state,
> +}
> +
> +impl<'a, 'b, T: ForeignOwnable> XArrayState<'a, 'b, T> {
> +    #[expect(dead_code)]
> +    fn new(access: &'b Guard<'a, T>, index: usize) -> Self {
> +        let ptr =3D access.xa.xa.get();
> +        // INVARIANT: We initialize `self.state` to a valid value below.
> +        Self {
> +            _access: PhantomData,
> +            state: bindings::xa_state {
> +                xa: ptr,
> +                xa_index: index,
> +                xa_shift: 0,
> +                xa_sibs: 0,
> +                xa_offset: 0,
> +                xa_pad: 0,
> +                xa_node: bindings::XAS_RESTART as *mut bindings::xa_node=
,
> +                xa_alloc: null_mut(),
> +                xa_update: None,
> +                xa_lru: null_mut(),
> +            },
> +        }
> +    }
> +}
> +
>  // SAFETY: `XArray<T>` has no shared mutable state so it is `Send` iff `=
T` is `Send`.
>  unsafe impl<T: ForeignOwnable + Send> Send for XArray<T> {}
>
>
> --
> 2.51.2
>
>

