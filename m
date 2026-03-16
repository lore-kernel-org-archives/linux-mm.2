Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 482D9F4644A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9506B00C1; Mon, 16 Mar 2026 06:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 687216B00C2; Mon, 16 Mar 2026 06:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57F556B00C3; Mon, 16 Mar 2026 06:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4318D6B00C1
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:34:12 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E0AA5160168
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:34:11 +0000 (UTC)
X-FDA: 84551566302.04.63A1295
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1C51C4000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:34:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h2tw+jrY;
	spf=pass (imf04.hostedemail.com: domain of 3oNy3aQkKCI0r2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3oNy3aQkKCI0r2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773657250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k1Pp6B+kbyJ7AS+BSznHhsZJFqEGhJ13TKhxuOIaMsk=;
	b=Pf6hLVGq+oW+CNg7CNPq0UQknQpXW9KZV1PwSxF3nxsP8hHFbwVKy/TXPT+v0fDU0pinUX
	e5V7f7+C9udeDZwQJJw93x91BjZ0jL6cMg5X4H0N62aDCv3/sde8oSxWvLx6SFrii+Uk9F
	7ZcGwnWcClQ9Ltw4EzxvOnGekb9RPWM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773657250; a=rsa-sha256;
	cv=none;
	b=GmZVZ4THuPNWqG4aTv7SK8G5oBt5aiWD4hqJbDTtmdJiwiZ8QC+s5ijAqfZAeoUScj1SeV
	jTSUjKHngS8uGzt35yp/pIVqdlWxsj/u4fkTs8CWu886FpXi+erAkgO2oYjxna6WPh5SAJ
	MIRY1dePvPsiBjHvwiZyOQLkohitLqU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=h2tw+jrY;
	spf=pass (imf04.hostedemail.com: domain of 3oNy3aQkKCI0r2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3oNy3aQkKCI0r2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48553fdd03dso25733735e9.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773657248; x=1774262048; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k1Pp6B+kbyJ7AS+BSznHhsZJFqEGhJ13TKhxuOIaMsk=;
        b=h2tw+jrYIT/PwdqdPWTwioD7Xqrxq58yRCRLyOtAW1GwHIrORZWE0G81gH8NHKaysq
         nBDRupRgZcdvdnGFh75ZJWVnu36Z0p+yzW0hjXGTyjtOdm/bOvH76EkZScD+8J0xmDOd
         RimL+f6NzEVuhoGCbCvPc09qplC8mZvLOAku/q6eiz13Re/i00zcISP0pssp2WKMlQ1T
         FlQIf/bUdzZ1GQyZqtnSqUSx9B3Q4q0jmm1FxsJCu09eo2ANFgGXgfbSFdQr7C+LTpBe
         Ukp+BTAiElbJ4Mb3jtSBfYk5LuswnCgmgbSDdFTA3UJTyGsMEXTWGE+PlkeZIXnIYSyk
         VTXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773657248; x=1774262048;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k1Pp6B+kbyJ7AS+BSznHhsZJFqEGhJ13TKhxuOIaMsk=;
        b=X5IzjoOSYuCliOGE2LTe0bUcWKtDTIQIYU6606zWqPugzgigFytW+/MQlJZfA49DnT
         nGVcpVsnpLerRBB4V1Wxo5vqQxkPWqU23N2pCYGSajqmKBEhch+cq9F3RgumsW1sxG5+
         jcUDk2UnMzFpgg/LGuUlgZrOa2x7SMDttPGK55Gy7+9J59/yQlM4vvSmCa7L1niVLg0E
         SgKzXQ28EedNzUolZZ9g3lvMYUz8NnUjuNGsmi/QQog3hTIWleShlmSnkhvZisQZOf9V
         PcicP/r2hTeHdLlvaiq2VS3Kvg07lHaWy50s1r2BeIM0cTHlmPJScKmWfpDFKQ58/BQf
         Mvzg==
X-Forwarded-Encrypted: i=1; AJvYcCXTYrZ4G382WpXYL+40M1Ly8FzmVV2BsBkCJPe+aPcBeyuwrXqs3m+HBq2tnfe99GMyCa6mCREVYQ==@kvack.org
X-Gm-Message-State: AOJu0YxjwYAiG/hhRNj8wtZhC3i+5JrYblmqYz8WVkLv5WOuSpc4FatQ
	5vt/dQv6enx4ydrjoQLFLZCUjLRSDOrSERp6e65qvL3beHBcOsN2LH0UfY2/YR/76p2UK+kKe1H
	IWsWBBJuckBxPPGdBJg==
X-Received: from wmoo9.prod.google.com ([2002:a05:600d:109:b0:485:4f4a:bd87])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3553:b0:485:3a27:a961 with SMTP id 5b1f17b1804b1-4855649fdafmr220588635e9.0.1773657248391;
 Mon, 16 Mar 2026 03:34:08 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:34:07 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-12-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-12-de9a7af4b469@kernel.org>
Message-ID: <abfcn5dVzjoQmomd@google.com>
Subject: Re: [PATCH 12/79] block: rust: add `TagSet` flags
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Lyude Paul <lyude@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz <jstultz@google.com>, 
	Stephen Boyd <sboyd@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-block@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: 3hbcbmzy8395k3xeex675meoc8kick6f
X-Rspamd-Queue-Id: 1C51C4000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1773657249-802570
X-HE-Meta: U2FsdGVkX1/ZOg1Se9wP2vvOPu0xyKZ2+tj9w2dBYrtgN27SDDKj+zK0Iyix5I/vkzu6o/hBXzLreUPLgFipSbe+0X5IaL4oJhTrJXDaZ0Zf+fFGWOBhxWNetltOvzVIlFhYVyN4qYSISjOvjgwEJ0EcwA8YLJqdxXsdiUO4BuZQVq9hh77I+rbZ4GjuHerTFcMkG3vBO2uN4+vET+vKbobFaKD/igqKEqj1GCz81Z2tGMhtKlqXeLaXKpure7BT4JB8hrdgsL8w+oQ1+uDTMIJd/Jol5WIFL6aLVg8UGXqazA99tFYkGdF61OllNk0Q3HhKqYgeZw0RLM4h02DmEF93DckyuxNq/TbEuCeAXRSpjNF7ZK7IfvDo6fO7AW7kBQifvVnti8wDusowt7pG8OZveYPjlo0PJyugAorEi2f0TA8lpDaGOUOna5DJsaZ4HFlwA9KPUCaE3OqcoeHJEbOdNZ6MrLZV+74uG1SYJPhraBnnCkHDFrtpWeWl4BaL+SsyvhxiuWlOso5C2tXI/abrEb53dMQ/15Tx7QX1wr78yoMHAEPv6qpOmXUQAMjQKypbSRzkywG+tnd94tB4GhR7T2mSqcBq1dJdalT0LxMx3C/9+FmR2qFn9c33NYuls+/N6tZ/x6qEoqC++ZEa/eR/jMcQYq7wBL4Lw7P5g4CGRc3Pd68S6ilCF+aSyvGhCyqbC5hMPVfJxW9hrEu/aiatZOdYiDPrJr6ruI0OBLi9IsIFw65eid7NDhYsRp/IUSrUNUifxVDyrUCT+09heU5LrPhjTIkD+3Z3z1+4BIz1D1Fkot5nRWtg1UIbhZ9sWvH0PktEwMTPPApt+ZK5eE56d9kES7vj5Er0jv6UmM2ZWVtWzzYcF0Mfg9O7otvfq+cmC/yeiMzogaecuk8X5IbVELS0gzjXTyXJ0l+4pkJmD+6W0kYBowTWQe84Otzq0hk299FGU5ncCVWgzE/
 cyaD7Dn+
 G+9wLFhfmIPLXLYutbzeQt6Lkn/TBq+1TBmu/CIUdjV7x6iPhU1nwoiYV3EU0ihORUnv2QUqzVxM4gLRbjsO/wjQjaxdJkzls5ydjziSlHu8eDnXJHOHBa8h5MfXdyYU3lZWnOt5RnZXiH8c0ZAyeJ1MApChWjoGzwiRDbwlTf1QdV+ptv1EPdYhXdm2D94C4JUblh5WC1aDDlMAnXrTtWzinx9CioxPIQuI2yr2xbYFxqdo5yxJUDx6PTlXzBDnpW81kvUh9uVEFZKsy9sVOCqk3IWihVoBmSaa0CI3SM3Hp4ocllsqEI3WK6MIF/X9A9Tj064qVQZ+kNP9F4IiBy1xIq6H6ap0yJG35Bnnj5c61kMyQal+BhV3/uqMfEDX89MByW1cEEpr/TV8JIiJVlWSMjezONogR4Z8uhGBXT5iqHNvOqFBSlpgb1MXY4QrtXwMsDvC1Rq+dxQPN90vTKVvZOyr8NAhfHoK1l7W1EsjS4d6sMlzwIBMjTtH28cKL5AwsPlR/RbWyG47joiJXmrohmICv9c29ngzhrCaX0K6ZzMLY61Cg4CuVSm1xq9el3Fp1BRW3777OTHOooLCpU6u1BZziy/hAT5trLSdGPILP2fN/zSxi4QWG975xDuDm0uZWgOGc2m5nUChSmek8oZL8TTL9Nmv/yNzcGYzT820EzQRaMu+cm3xdgTB4qJf2H0bNaNPHyggP+eZr2D6EMhj/Sge4BKC3gGCdqBxvBpcq5xI2bKc9DvkKp3A4P1DXNlpVWLL4YcQIQp9br4Fk2uhvmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:34:59AM +0100, Andreas Hindborg wrote:
> Add support for `TagSet` flags by introducing a `Flags` type and adding
> a flags parameter to `TagSet::new`. This allows configuring tagset
> behavior such as blocking vs non-blocking operation.
> 
> The Flags type supports bitwise operations and provides values like
> `Blocking` for common use cases. The module documentation example is
> updated to demonstrate the new API.
> 
> For now, only a single flag is added.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

with nits fixed:
Reviewed-by: Alice Ryhl <aliceryhl@google.com>

>  /// A wrapper for the C `struct blk_mq_tag_set`.
>  ///
>  /// `struct blk_mq_tag_set` contains a `struct list_head` and so must be pinned.
> @@ -37,6 +41,7 @@ pub fn new(
>          nr_hw_queues: u32,
>          num_tags: u32,
>          num_maps: u32,
> +        flags: Flags,
>      ) -> impl PinInit<Self, error::Error> {
>          // SAFETY: `blk_mq_tag_set` only contains integers and pointers, which
>          // all are allowed to be 0.
> @@ -51,7 +56,7 @@ pub fn new(
>                      numa_node: bindings::NUMA_NO_NODE,
>                      queue_depth: num_tags,
>                      cmd_size,
> -                    flags: 0,
> +                    flags: flags.into_inner(),
>                      driver_data: core::ptr::null_mut::<crate::ffi::c_void>(),

c_void in prelude.

>                      nr_maps: num_maps,
>                      ..tag_set
> diff --git a/rust/kernel/block/mq/tag_set/flags.rs b/rust/kernel/block/mq/tag_set/flags.rs
> new file mode 100644
> index 0000000000000..768db938b9a95
> --- /dev/null
> +++ b/rust/kernel/block/mq/tag_set/flags.rs
> @@ -0,0 +1,19 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +use kernel::prelude::*;
> +
> +impl_flags! {
> +
> +    /// Flags to be used when creating [`super::TagSet`] objects.
> +    #[derive(Debug, Clone, Default, Copy, PartialEq, Eq)]
> +    pub struct Flags(u32);

Nit: Spurious newline in beginning of macro.

Alice

