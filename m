Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C4EACCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 07:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A31F48E0006; Thu,  6 Nov 2025 02:54:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A09938E0002; Thu,  6 Nov 2025 02:54:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946428E0006; Thu,  6 Nov 2025 02:54:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 839528E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 02:54:06 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F27C9BA592
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 07:54:05 +0000 (UTC)
X-FDA: 84079418850.01.5EEE790
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id 17C3420005
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 07:54:03 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=V1alrSiT;
	spf=pass (imf13.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762415644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+2ar18tr6b962L15dLxJpfxEfWpKtIrcxwp6VAnJlI=;
	b=qmPM8QR3MnnGqVJ+tFzmTUit6tRvMWVYqt358seVqzLlQsrbJ0OT19590sp/tVkjGEGVmB
	EgjN5luzHmbSFooAOeIv1nXv3H0zlkVLOt9V9Gz6mUE+9nLZUvGuzu1kRderV8t6dRIK1W
	p99Y+mZrE4pi/ZaRapW0vqpeR7RUPyw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762415644; a=rsa-sha256;
	cv=none;
	b=55YY4G6LzIvFrZfD0Uon0Qi8/sjlwNHzp3mj2xrkHGPFUzbDKLfBSX9MuLfCgW0iZWou9K
	DBTR/0PyOYJnZIWafKmSj8cBRrT0I9haKulW7inKuJjZyj/lXKeNBzitv+V92x0qzh363W
	CFEfR/MUkIPbpblwBCqVLMVsWJZmJ0k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=V1alrSiT;
	spf=pass (imf13.hostedemail.com: domain of aliceryhl@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-477619f8ae5so5152445e9.3
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 23:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762415642; x=1763020442; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T+2ar18tr6b962L15dLxJpfxEfWpKtIrcxwp6VAnJlI=;
        b=V1alrSiTBWV5Z2czz3QjFSHFiyNNvkXf+ifNd7Mku3vBmkeXE24IatVZX/JE3QVFX2
         RQhmxvkGy1xHUu/1fyIl1+8FxH1Y/AH1QctVw1KvtLi78QYQVjnRi5oVuJbW4EMCLsF6
         Dqd3gVMx/0hsrIs+LJXb4t7m1JkU71tDo8z/0DqsFVArOSsuaCALpDyadi5GJy7OXXv5
         KexpMHvYlc8Guts2h3kQ5Tg1TnLx9ia1bcgCUDqNeTiv/pHH5BN0pALcLxhlYn+QVjBT
         BSlY6ht92RInnynQnJrlVhjqJUy8EhMbqG5/tWnEKhdP3/1qBy/E8yfPrCCBiBvF9RB7
         9NQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762415642; x=1763020442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T+2ar18tr6b962L15dLxJpfxEfWpKtIrcxwp6VAnJlI=;
        b=bI3tiFalqrbCLI2htJKB+vrhNCf1JOUyh5CYsLOTwUcn4mOG1q7YVVhc9vXdrmoBUS
         5iM8pVaaIkUaSNYD1BslSa/XRUi7iqZu2k1RZOgSacmgqAw/uNLySwIVMC0w5FqKefIi
         WFru7Kh6UmVHt+2oKfu1Zd+RhI78yuZuTvVDECAKH2ecyzvH4TfyYnV76nEdmyze56xX
         pXZMwoyyE1zpCx/BOyuvJSzAhkDmgMyxAbs2/5WwY1YqOqPYM5J4ApcI1r/49j+yK+Ba
         4+p2cVN7zw4e+CFRw5Cwl4o58nfDN7oAh49bx4LMGiPhYta1JPEpPiTngE2WIa4IItBr
         wqkw==
X-Forwarded-Encrypted: i=1; AJvYcCV/VxSxZ2XFtBgPpFJ5n/DCiCf+M/2LoRAU2PpFeK8YqtnFExC0+QxuD5Zkpsmk2jc768hYovLCAA==@kvack.org
X-Gm-Message-State: AOJu0YweeFyWagjATAE8yAddqhVC8qtwsAWSU899cWm8t0gj4xpVvrqi
	oJLQr7mh4m+NPxNcbzPrmKFFiJTereuXt3eOblGm9k4Tg288kKR2NYc1wgK91np5o69lqMdY6kG
	p5mXFvFE6KAz8j+0p52KLnhMqWg/Vg06RxFiiDwOU
X-Gm-Gg: ASbGncu8FgIn9DPGiilWRGS+RkJiJ/VNbocIkKhWxloYCi0P+Qruthb0u9QwnNYDAyM
	vBuUUapj8EU4og0rtAtZmFu5aCc9H2JzKKjwnakLDNbF+GaHVblAJjWF7h/zE3Zi3dl+BBKnhXE
	GvXGmlXJY+5T4+HDSaCCNJca4iFAGVwnk6iR6/EtmlRdJQa44kEP508mUgHKepa9i0wot5oFn+V
	6FDWH6vhqRWSspvfc2TPM0aBZd964di1VC4QpEKsgMtBXNT7BIgDyhcvj6LBN/ZqHD6cfWM
X-Google-Smtp-Source: AGHT+IEjUyFU89nMa+q5df2qUBnqXwId1/eHxAYmD1edApkV0pnuDrta64OSQlPJebpI7md4qTtQXkuypkJRNoQCvJs=
X-Received: by 2002:a05:600c:8414:b0:471:1d8e:3c4f with SMTP id
 5b1f17b1804b1-47766986793mr5309775e9.24.1762415642292; Wed, 05 Nov 2025
 23:54:02 -0800 (PST)
MIME-Version: 1.0
References: <20250924193643.4001-1-git@elijahs.space> <20251001044508.23126-1-git@elijahs.space>
In-Reply-To: <20251001044508.23126-1-git@elijahs.space>
From: Alice Ryhl <aliceryhl@google.com>
Date: Thu, 6 Nov 2025 08:53:49 +0100
X-Gm-Features: AWmQ_blEJvV78Y_pK8S2wijCI3QywPGzT7z7xdYg28jPz0DOAgq4L25bYhQJkTE
Message-ID: <CAH5fLgiDwghSy_P3ER8WAYyAtRPgVji_wsmkiNfvc5HHpUpGnA@mail.gmail.com>
Subject: Re: [PATCH v2] rust: slab: add basic slab module
To: Elijah Wright <git@elijahs.space>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ksbm3cdyugtm36xgz771r6srftho1uc4
X-Rspam-User: 
X-Rspamd-Queue-Id: 17C3420005
X-Rspamd-Server: rspam01
X-HE-Tag: 1762415643-251482
X-HE-Meta: U2FsdGVkX1+zcFMgaH3GJYBypeJDUbcaQdrwdWQWtsgHJcrhQiy2sNKVf0DiH3/H0QXDGnagprxtr7BdfioGC2QwASmQkMttUG8NcUVWGoF9Z/eQBDpb2jIP/HUf0WZeu+ylF9jVdKqZo0RfvelZQWqCGpJFuEJr8SMqhRG73btnT+AuhspNZo33mFPfJG+e8bqClOARUCyQ/s5ql4GAKz6QSNeuORRK+mXBtg6VwlJBvBqDcz7hYauNQkbzV3mp2lLAoOvMhlDlZ9NmFFXNsOt8ql0YicYow6C7SK7YmhzLo8PnW92V0xV1/BSpPDGSy+IN10UfgH7N0ALaXmss80f1r3lpeqJxYHlJmENyW9JXTjIkcbr06I/2cuWzADmFTMA6Yl3cmt+89OPXez+EmoaJLkeONIxC7ihTbBdPtGogSoRswZYYL1y9JzcA5G3y0hkIiRNwcNhUiOfHIbd51ft6DGndBrFZQKq/foJSsBKiia6Db96xmADeoEnLIXF2OFPkdkZTl6IlMtUq21xDJI9DXX9YY1Ro8tRBfK1WsKdZLY3zjwBQR5p5L1DPbHYGPTSEAEJct5aZpZc1WHuBemlmPMUFxk8DKAVqmZJbcd4q+zqsOuIvAijQuMi5H4xhHKya0AlOGIsoOjuuj5dOIb6eA61e0vc81IBBXpIbnoR9tt+nnsQ2XTXkfIl6icwQ//PpIiYoFueiE8l8lXEsUiTZpC+dBLqDwbDIlkispYT+3kImVddAyqQvXBYoAlW8IXqbC7nhyL43CaqFZ4ofMBRtEHq7s3klecOrJYEBAi7cQIi3DIm4Cw8/Y4WgcMHfv6H3cSTQ9PDnIf7yzzoNWf0HPJuLcfINuQhqKEz0b6Vr2FQG35TwryQqj1EXnY7jJrM4YVIcqJkQtQFrYebMueNNGz7VZ0pgIC1KPRew4q/IVjPEplnllLFbAgIjvMMigbUfwXU/F7ODQW37vyG
 wkYzP1pc
 ctKqgjA+twvO9YddPxsjNscLSfcaS1itymB2GNZIFl2pafI7UmHpk8tBfRNGsys6W2FCXyrYUJLrv9qL/kaG+GtbAm6SPgePQH+5bfSPrEKIsrxoWeug6DpHrqKpM62YtgTW4DZ47b+lNFJgTmTvMgGJ5digpvkGwpYAK7X4JLwr3spTGG2TpvaosXYlkDh21qQtBAhMYwe+esGwj0T/EV3v1E3vIQfnnJGIVUZZivUq2xXuNHBah8fnlyZ9X0sOT0egASDWm58IMJxc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 1, 2025 at 6:45=E2=80=AFAM Elijah Wright <git@elijahs.space> wr=
ote:
>
> this revision adds gen_kmem_cache_allocator, a macro that implements
> Allocator::realloc for kmem_cache. the one concern that I did have was re=
alloc()
> for resizing, since that obviously isn't possible for slab
>
> Signed-off-by: Elijah Wright <git@elijahs.space>

When you send a new version, please don't reply to the previous
version. It's too easy to miss the ne version if you do.

> ---
>  rust/kernel/slab.rs | 52 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 52 insertions(+)
>
> diff --git a/rust/kernel/slab.rs b/rust/kernel/slab.rs
> index 8b418f9db7cb..3f1310f309c5 100644
> --- a/rust/kernel/slab.rs
> +++ b/rust/kernel/slab.rs
> @@ -83,3 +83,55 @@ fn drop(&mut self) {
>          unsafe { bindings::kmem_cache_destroy(self.cache.as_ptr()) };
>      }
>  }
> +
> +// SAFETY: The pointer does not change after creation, so `Slab<T>` may
> +// be used from multiple threads.
> +unsafe impl<T> Send for Slab<T> {}
> +unsafe impl<T> Sync for Slab<T> {}
> +
> +/// Generates a zero-sized allocator type that allocates from a given
> +/// `Slab<T>`.
> +#[macro_export]
> +macro_rules! gen_kmem_cache_allocator {
> +    (struct $name:ident for $cache:expr $(,)?) =3D> {
> +        #[derive(Clone, Copy, Default)]
> +        pub struct $name;
> +
> +        // SAFETY: Allocation and free happen through kernel APIs which
> +        // provide guarantees. The ZST carries no state, so it can be
> +        // duplicated freely.
> +        unsafe impl $crate::alloc::Allocator for $name {
> +            #[inline]
> +            unsafe fn realloc(
> +                ptr: Option::<::core::ptr::NonNull<u8>>,
> +                layout: ::core::alloc::Layout,
> +                old_layout: ::core::alloc::Layout,
> +                flags: $crate::alloc::Flags,
> +            ) -> ::core::result::Result<::core::ptr::NonNull<[u8]>, $cra=
te::alloc::AllocError> {
> +                if layout.size() =3D=3D 0 {
> +                    if let Some(p) =3D ptr {
> +                        // SAFETY: Caller promises `p` came from this al=
locator.
> +                        unsafe {
> +                            $crate::bindings::kmem_cache_free($cache.as_=
ptr(), p.as_ptr().cast());
> +                        }
> +                    }
> +                    let dang =3D $crate::alloc::dangling_from_layout(lay=
out);
> +                    let slice =3D ::core::ptr::NonNull::slice_from_raw_p=
arts(dang, 0);
> +                    return Ok(slice);
> +                }
> +
> +                if ptr.is_some() {
> +                    return Err($crate::alloc::AllocError);
> +                }
> +
> +                let raw_ptr =3D unsafe {
> +                    $crate::bindings::kmem_cache_alloc($cache.as_ptr(), =
flags.as_raw())
> +                };
> +                let nn =3D ::core::ptr::NonNull::new(raw_ptr.cast())
> +                    .ok_or($crate::alloc::AllocError)?;
> +                let slice =3D ::core::ptr::NonNull::slice_from_raw_parts=
(nn.cast::<u8>(), layout.size());
> +                Ok(slice)

Hm, this is kind of tricky. We specify a size when calling this, but
kmem caches only support one single size. I don't know what to do
about that.

Alice

