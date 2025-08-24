Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5838CA0EEB
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 11:38:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBDD76B00B7; Sun, 24 Aug 2025 07:38:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D959E6B00B8; Sun, 24 Aug 2025 07:38:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD2716B00B9; Sun, 24 Aug 2025 07:38:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B3BAA6B00B7
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 07:38:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6DAF016091F
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 11:38:50 +0000 (UTC)
X-FDA: 83811454020.21.970713E
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8D0FA180008
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 11:38:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GZakf7SR;
	spf=pass (imf16.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756035528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9cDqNbqcDUrKN9I6FwLpcYOrNjGw94QGbdTT6OM3Mgs=;
	b=V/KV3guHQmNeHg4G45VbsP/rifgO+fSkOt2z7BqGUdpBduF5e2Nn2gm3QjJU7a8A3+8P3E
	VxxeoVQ/bQmRTQHTDtt7l2WyBv/dPinyqUKTxvnWefLu+aJMp7nHSlypFXdQWF9QNISl2d
	6E67B+ZzvK0R8kIHQ6rTvK7JRDZpfv8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GZakf7SR;
	spf=pass (imf16.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756035528; a=rsa-sha256;
	cv=none;
	b=W5r6sDlRLr/8mFLDlf5iqklyrwH8Vkz/ChOuyvBKPOHzhpBtdfzhUXTC7fWy3kFFIhE1i2
	PcAgHuV6NARxyqL6lOjqB90dmEpkV2aBfed7P2CyZZQD9D26hyjjruXFYgp+m1cJCEpIOA
	axiW/TzP/ilYMXp46KKynNKQrXBUjVg=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b47173edabaso593023a12.1
        for <linux-mm@kvack.org>; Sun, 24 Aug 2025 04:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756035527; x=1756640327; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9cDqNbqcDUrKN9I6FwLpcYOrNjGw94QGbdTT6OM3Mgs=;
        b=GZakf7SRLYy9m4ZZjMU2TboVUNfSnY9c4Hd7QC/dEIGvS41aNU3vff4umulTJIkZgf
         kWF35yCPsju/CkCfmupBhCOKpQ654m48kxLi5OiBa9RhbytRem0bchqgRfx9VS7YgSYD
         KgzG6L7ylhve9JuYfrOmlPdxlqY1jgEEfATEQMgIZ0B8oehfeGhppH57BLxCEzFMmICZ
         550fXCaNFQRXVnnuAwgHOvGrbkrg6Fi099xvNpXiKr7T4BFAS4vzD3f+LL9XhjBummql
         StE4xaKZWbuCGlD5bSnR9IbrG9LpPKgYvLLg9LpLB5y1UgoDk9DOdHXGdIrfDjwwjpHE
         RnKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756035527; x=1756640327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9cDqNbqcDUrKN9I6FwLpcYOrNjGw94QGbdTT6OM3Mgs=;
        b=AuZ8x8SDnisN3VDEI/VVjHhdocfo/8ATr+2h2veOKAYSb4DzkE3zpaPDJUy6ihOBIj
         1YtpfR5vVMm1DDhD4hyUg+bh4OgSnrSmr1euke08tjjCTMIcWPINAmVa53N39tfQLAJd
         RmAf2IpIsZHSBFK9Vx2D5nQswq1m5n10r2r9klhB/IRETNAkPWZrluZgdMeRfNKJTG1m
         tR2HdQHgWNnHwQAUROp9xP09eosu9wHCrD0HhxYvc6u+1m1hpM5cPtEOTdBXCslrBhwW
         4w+VktdufEOWrlGTMotIPuiSQ0+YITyYsizBf/JbgAC+H+YOoAEg9cN3elQ2HGL0CwLd
         JAEA==
X-Forwarded-Encrypted: i=1; AJvYcCUkp/SkD3w5bmTMM4ljUiwIQapiIGVZ9bltGkbmPDuhjbHxjo8RLbRBuAQs9dbam5/JKRxeAISv9w==@kvack.org
X-Gm-Message-State: AOJu0Ywjz2zWvjtNY6kf8nP+o1khgJSyHyr0X+HItx93y1xhVZ9IBh+/
	gK2Xl9s2qbNaa6hiN8XMi7L7YEIFk4rXpz6yPz/tnbbm5pej0viAztog2wvjCV1nmf2U5eXR9dx
	9pVHhp0LUZespBRCn1/t2wLdYiUWyNxZeU4MD
X-Gm-Gg: ASbGncsTgvAE4Yd12qHTjn2/44EmB7c3tLm61ShIIFM1M5iHGvZjQnsAiLaWxeQQ5RH
	vsI4EwVDANZOmhcEBFPXsRh3FoeuuHGLKyHPcWxTwz0mn8xoZdTE1QTKJ1rFKjkdmpMvXR2vQoa
	nRDiPErTEjWWjan4i7CpDFAUv4E7h5HmSYX6BdsV9x57CO9a20D/8yuF1+sXphUFv8U7Y3BX9s/
	Vz53FohTMtlBY9ty0Z2+yPLPdkqJywV+FYJkygsTqImicY35Vk2752TSdBHw0Za+dziJqzeLA7L
	JYF3L2cNGs9Hawx24xNpl2taqw==
X-Google-Smtp-Source: AGHT+IEDeQcH9/cmzvxp/cnplp8sqsKYB9Imynqz0W/6Icoa1vEMhVJTFtyjOb1zgaJdMSz9KZMeBG8x7XunTdy8Nx0=
X-Received: by 2002:a17:902:e888:b0:240:280a:5443 with SMTP id
 d9443c01a7336-2462ee5d589mr55989045ad.3.1756035527288; Sun, 24 Aug 2025
 04:38:47 -0700 (PDT)
MIME-Version: 1.0
References: <20250811-align-min-allocator-v2-0-3386cc94f4fc@google.com> <DC38NDRET9NB.31UDI8FHB7WAY@kernel.org>
In-Reply-To: <DC38NDRET9NB.31UDI8FHB7WAY@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 24 Aug 2025 13:38:34 +0200
X-Gm-Features: Ac12FXwORJcKw5BWVPRfeLB42EncV6m0mvAs8xiRT-uFV3AfSlGlkdcdd5BVvsQ
Message-ID: <CANiq72k0FSBTB2yOjiAy9PnAuyM=-PHxL3uQQ_Cv+zwswnr_bA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] Take ARCH_KMALLOC_MINALIGN into account for
 build-time XArray check
To: Danilo Krummrich <dakr@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Tamir Duberstein <tamird@gmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8D0FA180008
X-Rspam-User: 
X-Stat-Signature: 6xo3n1bd3r5yiy6xra7tkryybtnnpw8r
X-Rspamd-Server: rspam09
X-HE-Tag: 1756035528-465350
X-HE-Meta: U2FsdGVkX18gookL3iQUbpQm1Z9EJ9RG2CCdDRhNsGelz4XptvVXgBz4JxuajypBlOc9CNZtXuyjZEKkXViLncAKiqXHBqy/nlfkK0CTG5//BpIhtRne8/hg4P0TPN4o2dCsEn7GgG1WVJE2zS/iyBxuoYzzN0Q71Xublb1Y891ovyr0qdQUcARImtf2jOT74Vkd0nAbZSFY3vrx73hgwKdqLlXI+4UtLJJ0igT4+cUIPW8xXvVGQQz0pPn00hi74hSWFrYfEn3MY72sRVRFrtHfNfa0hOXwJw/MX3YyhjAHbgx8LTQdRArUBk/bqDkupOwdawuhLgzCym5WwOfQDxHNyfnKYqrp1HEjnwv6AV7T+/4GH1V4/nJvD/Sw6AnzjXhIZaqDZ0sLS7Dr24p8MrBtmvl6sdo8S6XpVkiQPPapwbunNDv5xuUfYwhkF5IGbZpCRdM2Z2NU2Yd52ynx66Ab8ngKxpZC/UL43LxmaTDRVAosxSbfzGORK5JWTclAsss461hxKGzRZJHot7ncn0gFBsO7h4MWbrNtPIX3iEBBrfZCicTOdDfulBcW3eAy97vY/leOPMYU/f3Cc8nZZ5pasFp8q5qUkze0Rg6sFvLcsqaEdd6N/Pym/aTFEjXztVivS7iJhrNyrjhLpetMlf9F39f6g3gp+dLP0fcslHYFPvWpcuh+OzMrMWxXSdM1UDqwwyv4Y9JerkMmr3oWaNuqxW4zrsCqtmIvkzh5gxfGIcigWqdNb8k3IhpNfrf44/U25uT1OfpcdicpKMwcbBGnvAq8t6SuLrbmMvPuJAJMaO7eDiz0y43FKWBK6z5vBhx9bTSYfcpmvsuMFsdtX4SIjiXhYBPGPbjH/kwF+qbmmsWzId1oOcwfu9vP9jDK6zPT7YAAyevBYMTpI/R8ZhtpdCR5BiC3YeUf6ki5pWguPFrCf6oDm9yV/QGBA/LaID95oGvjZi/4qaoGMV1
 l/FITvt1
 pe39yTkrtOPQ2FHec7nX+uT37BSph9bn2mjiQj0vRuz8MVG98Ia0y74oCkc0tq3ncrXrYsMlPi4mS8UCfXzVIUVhg8Ce3KXd37ekfknx0+Kt+VQzUwo/Z5NkRnhxoNNg+uNUCMvi3FwydEmaVBpyviXGQwjB6e9i15cGV3uMmmUQSh9SzalSiTUr0jjO69DERuQb1AeT5CAkPcchsCWf7Zd3t/3QLUxi/WbYXKgpLZfvJGYUlMlZqgCNHLYgxJD5KBBjb1POiApsPAt4LEoLJl+CunIHOOIPOhvQ2ph08BY9w5tsP7Bm8X9cxJWw4gMmU2XyIjfh/obikHtE5UTjK+mPlo1UtvWYi9y5y16zMUCruCnjotqH1TfJdfbzmkFcUN+wMXGeswqjVKBvC/gRx3XpiIbsWB5IbAm1mvnnvuKJGlelP4INx1i9XLCbrS9uxkhGca2YXFrzA+IhHdijasRTuEMA6nc56qTPOWRkQCXVZU2ZegOskRdQMt0mSphN25/+4yMh4woDuL9LCG55DfXT9xg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 9:12=E2=80=AFPM Danilo Krummrich <dakr@kernel.org> =
wrote:
>
> diff --cc rust/kernel/alloc.rs
> index b39c279236f5,907301334d8c..000000000000
> --- a/rust/kernel/alloc.rs
> +++ b/rust/kernel/alloc.rs
> @@@ -164,7 -137,15 +164,15 @@@ impl NumaNode
>   /// - Implementers must ensure that all trait functions abide by the gu=
arantees documented in the
>   ///   `# Guarantees` sections.
>   pub unsafe trait Allocator {
> +     /// The minimum alignment satisfied by all allocations from this al=
locator.
> +     ///
> +     /// # Guarantees
> +     ///
> +     /// Any pointer allocated by this allocator is guaranteed to be ali=
gned to `MIN_ALIGN` even if
> +     /// the requested layout has a smaller alignment.
> +     const MIN_ALIGN: usize;
> +
>  -    /// Allocate memory based on `layout` and `flags`.
>  +    /// Allocate memory based on `layout`, `flags` and `nid`.
>       ///
>       /// On success, returns a buffer represented as `NonNull<[u8]>` tha=
t satisfies the layout
>       /// constraints (i.e. minimum size and alignment as specified by `l=
ayout`).

`MIN_ALIGN` is missing in `Cmalloc` -- from `rusttest`:

     error[E0046]: not all trait items implemented, missing: `MIN_ALIGN`
       --> rust/kernel/alloc/allocator_test.rs:48:1
        |
    48  | unsafe impl Allocator for Cmalloc {
        | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ missing `MIN_ALIGN` in
implementation
        |
       ::: rust/kernel/alloc.rs:173:5
        |
    173 |     const MIN_ALIGN: usize;
        |     ---------------------- `MIN_ALIGN` from trait

i.e. similar to the other one.

Cheers,
Miguel

