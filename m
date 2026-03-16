Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CEB0F46453
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 11:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5A9D6B0200; Mon, 16 Mar 2026 07:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E386F6B0213; Mon, 16 Mar 2026 07:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D444A6B0248; Mon, 16 Mar 2026 07:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C22446B0200
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:58:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A05716013D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:58:43 +0000 (UTC)
X-FDA: 84551779326.30.F7856BD
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8B5D140009
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:58:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HeD5sh1X;
	spf=pass (imf04.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773662321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WqzStTDme1iRCeMFGoEp8Qdz7FeziR1yr/cuI448uRs=;
	b=517a1oGa8UBwsnCEvI1zofwbVNOfAfWlut0c7nPutiAzsYid+2ybIDW6c28nSAiKZz8gg5
	AWQ+QcEmKgIUz2oBb3tgbDanMlKBg7SMnkFq/ijX+KYhDaQPCMbpWkbHOEAJsTTS/GbzFs
	ArH/4MfGXQe3DM+QwuKCfEzGJYP4ORA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773662321; a=rsa-sha256;
	cv=pass;
	b=btWZjDDXRYq/v+QGzyU/aCxKU+9mdD/Y2geRq/5z1mvCOzKx5vdAOazAl34z/cWg3sDzmw
	C5NKXE3WtMohFeO++RvcDaBo4YVIyCSWP0Eb4XaQPlpIXV32MHe+E4NubYhzP14pRx+OTF
	KI/ycFb2gemcCxz4L/zC40iLAY+2p1w=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HeD5sh1X;
	spf=pass (imf04.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43b48ac2727so182190f8f.3
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:58:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773662320; cv=none;
        d=google.com; s=arc-20240605;
        b=hZUVrfHOghfFLlSBl0l62AKO6KPrRDEazRQZbrpt75I2UHXXJiZ+TggMc/Flkm8ule
         wHodW0i9L6mYmAl+KMILxZ7bmWagRAo5map3c0GXCuvfRU8R9N0YBF3220rkKSpvKxWY
         H4UMj7dMmUn7ZpxNvKzwGBSHBbppY7tk3hyCBoP9stvXgzJt6CnYTUUj+ctsPBLSo9QG
         1h6KnSAyDxKAqM0I3x/v3vE0Y1e4zL9qFwjDnDYyEIdzZcoqxzUaUPK2hXYdymtpHubM
         1jdHJJKJjN2iAM/PJ+8OCwR94tJ9/c+f4FIbLhp/YQ52E1MlsA8LE4txgNT8TqM5HKbx
         WfQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WqzStTDme1iRCeMFGoEp8Qdz7FeziR1yr/cuI448uRs=;
        fh=DV16QHgyG8OzIWfEhmp6b1iVZ/hXeRIVTSANqxTZPsc=;
        b=NC2aU360gPGVNjcnj9IxwgzwFk/55bolsM44aong6k3Fa6QPf3n6J9B29G2ZT2kkGK
         4n7vGG5Iw50O5Qs9o4yKnmzgnVMb+5Al1B4m1nsuqj7UbAoiYD9TstltrcTvv9WVgx4w
         C0cqnTHGDHS1XWPimK3Hfp0qnMiVeEAKbTxrGmsiuzKrWg19YXgoge9PLi3fMCV83JXI
         idnDeFmh+ukrAu9LP1jqsbySKDD0s8TGXqMYpTipJsiNoC05iLk6oL7HIw+I2UqUhEai
         LkcdYbHFuHIUxIV0jIsX2ynRouSz5hoj44td7L3LfsUYUx3zstIHPvukj/QwQZ0Odp3p
         P6Mw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773662320; x=1774267120; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WqzStTDme1iRCeMFGoEp8Qdz7FeziR1yr/cuI448uRs=;
        b=HeD5sh1XQdCfqzjnDsdozOnCBjVfPP4hxJKSJ9ZxAU6CCdKB4QqM/MRpX99o4hHciT
         oXNrqT7fXVXac1hIxgC1QHZ/sZSsijRs2YcKakxbAslw6Kc62nzDKW8TwpDuYTIY38sV
         I08lm4H3/e/J7OTKPRK+FhTvl7aG41FLmQpS27u+goB+gyeA47s+g1IgmdeyXJ/qyD5j
         2zt3EwUZSJTyOhkzCfRuszXvFGrtMZPhBPXBkDVNbL2dVWWp7yuyq92tlt4CZMwrNFrj
         6Y9gUrRyKlQ1iPF5bpPNdfS6AJPvqdh363+PPr4EWZq4ux4DYD9bq32EcvZM+NqyJfui
         4S7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773662320; x=1774267120;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WqzStTDme1iRCeMFGoEp8Qdz7FeziR1yr/cuI448uRs=;
        b=a4p35dBvw/7SoVV7jfh2eDbagYfD7Q6j6F2cgJ1wr9JDKdI/7Ryt9npDwVlxy9pAoO
         wSwSjRyhOCMCAfNvQ0k8xjtmb542llj50ud7WRJVSIJzaEiicb05vqCJMZVnQBqDp64q
         AVnhVg59hymwE0nYMm5FDCBF0rwhPDmygp/SGmBbBLwmOW6osAZFQj4/UCrUJ8gpgAgX
         ZAs6yYkqAcxAvq4JDyz4jDgyEkvogERPKv/1Z5t3Fza98wINeFLo21hVII+AIIoq9vzG
         3ZGjS6REpNjzLvfjSCFu5QYm2gaSGrHHa84WjRkOo1bAcGtsr7z2JCVIsrhH7/rMqFIf
         t4zg==
X-Forwarded-Encrypted: i=1; AJvYcCX+4GcWZskVzTFqQwv8056dgkZdqRoaXLBZAaj1Ozq6aZG1L6xHNPBN0jD7+BiIysmVH/IrueEYgw==@kvack.org
X-Gm-Message-State: AOJu0YwuGvSgJ8sCbnAdDb8V/VFGc69oH21nY8SIh7aOYcixVAo+IId6
	XBlwM5MZ3rNYfCERn0aQ1YZErwAkCpVHNtA8L5pM3+lXiGNAwF/VHP3Wa2HqGqj7IllBgWX70uc
	vzrMr1gXMdXxRFfRMVUL54evt12bnx/xviHXr5mAd
X-Gm-Gg: ATEYQzyGUxW8rul5Yq/UMqQQRLFIMD3JMJ6wHd+GJWN5YcMzUYklKYSjiQF1uiRWT4p
	pckRK3YCEgsu/EJVKN9xKbPDAqDVLIbdKkqcYpCzD91QzHNtXL4aY8Y3dG2NQGqRfqRTmXqfyCJ
	qc8+UevwO6ImP+68Zi/8jkujmFajYA2S2FEYqXFW2QhhHzXJSegq4G14Bqrz4NvRO+a52Kz6MAY
	I1gsY3WszaLsWBYVLKfImiICM/QS2FLlmKY+IC9qDR9Hnin15CfYSGyK+FM4JY8WIYZ9p+tFg9X
	B8DU+4mM47zM7Iukk9TK29jP6QG0qSexCD9+OQgFDwv9YTlgFk0uIGEXuZmTGyyDmQwSAQ==
X-Received: by 2002:a05:6000:288c:b0:439:ac8f:5db1 with SMTP id
 ffacd0b85a97d-43a04d79bdbmr23658023f8f.15.1773662319287; Mon, 16 Mar 2026
 04:58:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
 <20260216-rnull-v6-19-rc5-send-v1-4-de9a7af4b469@kernel.org> <abfNByL15D4s69Al@google.com>
In-Reply-To: <abfNByL15D4s69Al@google.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Mon, 16 Mar 2026 12:58:26 +0100
X-Gm-Features: AaiRm52S0Hs2FH4817i5Rr-RXaUi8EC4_IqQnN2448mAAelNGeUh-DsUEfywyig
Message-ID: <CAH5fLgi+K_5So-kLwyZGhaagEx-rRXPmk=zCOTqG3yh=bSe9Ww@mail.gmail.com>
Subject: Re: [PATCH 04/79] block: rust: fix generation of bindings to `BLK_STS_.*`
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, FUJITA Tomonori <fujita.tomonori@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Anna-Maria Behnsen <anna-maria@linutronix.de>, 
	John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8B5D140009
X-Stat-Signature: 5juxdwiogmi9krs79bumqzfsib1u9hka
X-Rspam-User: 
X-HE-Tag: 1773662321-616954
X-HE-Meta: U2FsdGVkX18e7flioV1PcrQcHPmEwwEyN66VewLeUNcMju9SZceluzEMUa6JDOrq/y3ZAx60dvua3RkpqnVbSDkq9nDignYRyzz4HPO93zWZlJs7Jw4Og2ubwr8i3RSSOW8ZxLmKLku+oJeAn8SekYEyptrJhUS+eaX4RprKTST3ytOv8bffxvaM/jLWWCrr+9wIvNYCuKf8kTp/KLd3xyRfF+nipsOAMfER5q6gH2SEhSKLHD6mCypgeS4ujZpb5sNFFjtSuuf6CFvjRNT5hG7BjfpBafSaXXcymvrJW6c8OqJCaA5/i4aQMlwxioiVV+GNtSd6k/6VxOZZRO44qmEYlN3b5LOPc0snvsrau4l3agPdlIwX+bsNTh58o/FMrElwSIDfj4wwB4R05vU/xY6dkZqd331/UU3H80nuDAlt5ThTpNcaorrp+6kfqrVrVpi/AA6VZCyDmRZpdtLdAnglc09ZDbA57xwpmBH5+mu0qNyw1JRQL33k+KVFIkju6fXOrorRdUI3/ZH9WD5deUAm/Bw2YpxggDnUIznHRmmo6sya2lMXhT8nuxotAgnRYqhx+7zN7x/OVv5u8nrc/mRk0TAmeCWoBmjAcL9/L7s3qhziyvUQOFoGKw3xT2QGVia2+3Jl8EeFCcYrSCEXjUb9XqEYaSdaQZYlbDqs1Ta0u+lYTaP9mFdhAwEc9S1ZPgkwqNKoTJIVOwyweFDUVLt+6sFYxnvIvPGLgy+pqK85K4K5lVKc8e/W1QNgazebgAxaz8JUq6gwacFfGMiV2n3EvSRXq9auT+Q2NsP+lkRR7YAEWb6Ye06A7pShBnkUWpTvgHK+MBrNjp0oOpLsdvWSBaVtCIkc6T9570ELljGvtjDXHQM+6A2KAB4a+QmF9fDnxBRXGiUF0AFpDagBl65SraROXSNLUDGMgMQ9K6Y00A4OPP0uW5R/RYylio1jc4T80i22qcFBGBgHBbF
 c3NXnrsx
 aidEEUfhC2VTGtYHMCI77RujTg4aONS4Wu5FWyEev1CVyKVawa2Z4gzhbP3A3EUPZO44mHXSSVjPCeXabATK3QqJetvApM66JWnPw7xPIjqABG7xhZeOH/wjfNNpNputVfc8UZgu4qgkfC0t5BsD8RTwQd4y3W1XoYrSozcSzcfplpHWi8wIBYiDadXHmJnjsaRFO8NKqocNEPWSlPYgyKUNvTWKJeegEQM5cYBGO1NxdUrL3quVTKP8o8hJfQfDb3dzppoMYKeJOmU5R+qUL5vST8DLRqwzOO+O+vBCoK8/72BrxbjO5TBXJlRA6pXW80zliJbA+62I0Jif3pvXvVhubYUHdIg86pylljUq+w06sSosXMm1nLaoHLiYRq7bN/iz5jeJ2tso+nHlOBv/0VVQRng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 10:27=E2=80=AFAM Alice Ryhl <aliceryhl@google.com> =
wrote:
>
> On Mon, Feb 16, 2026 at 12:34:51AM +0100, Andreas Hindborg wrote:
> > Bindgen generates constants for CPP integer literals as u32. The
> > `blk_status_t` type is defined as `u8` but the variants of the type are
> > defined as integer literals via CPP macros. Thus the defined variants o=
f
> > the type are not of the same type as the type itself.
> >
> > Prevent bindgen from emitting generated bindings for the `BLK_STS_.*`
> > defines and instead define constants manually in `bindings_helper.h`
> >
> > Also remove casts that are no longer necessary.
> >
> > Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>
> It'd be ideal to change the C header to use an enum, but that may not
> work as I'm not sure you can specify the integer width you want for an
> enum.
>
> Reviewed-by: Alice Ryhl <aliceryhl@google.com>

Honestly, it might be better just to declare a Rust module somewhere
with each constant redeclared:

const BLK_STS_FOO: blk_status_t =3D bindings::BLK_STS_FOO as blk_status_t;

Alice

