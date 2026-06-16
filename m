Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 224B7CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0E246B00A1; Tue, 16 Jun 2026 16:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABF866B00A3; Tue, 16 Jun 2026 16:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 986C06B00A4; Tue, 16 Jun 2026 16:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 632176B00A1
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:42:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E6B1A1401BB
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:42:46 +0000 (UTC)
X-FDA: 84886949532.01.81D82DA
Received: from mail-lf1-f74.google.com (mail-lf1-f74.google.com [209.85.167.74])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1A1E320002
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:42:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=etxsyHqY;
	spf=pass (imf31.hostedemail.com: domain of 3dDkxagkKCAUfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com designates 209.85.167.74 as permitted sender) smtp.mailfrom=3dDkxagkKCAUfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781642565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fkz/8WHSlc5z8mgSFYgivmaJvolb4fXApnGq7F/IsFs=;
	b=gmAJkQFD1e6bE7WGwLOVMjcQK26IH4EuVr0z9mjIo7eJAxbq96IGPneFpliEg88NSfCH3x
	G7q47ccOk+LzhDuXi90HyIGhwWOvVWEE+WVflRlZJFaePwvDvNpUJe6zfT4Ye2FNxOXQxX
	rrdvaOmpHFLK02fZs1JLeHx4T7dgUUI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781642565;
	b=6AaFW6EtkF2Zg3tRWX8KgxvUhxJwYWml33x+eIwcdRofov5q1Iz11Ge5Ar+v9CyZvZYlNc
	+qyx3Hm9nr19gxBvxYMdRz5lzLW6eiKyZGce6aNgtBjz6EtDtH5ZV3qT5vJ3FiH79TbxtL
	ybZYBa0PAuCJ9LX7zxEyh8Xj7ny9D6M=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=etxsyHqY;
	spf=pass (imf31.hostedemail.com: domain of 3dDkxagkKCAUfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com designates 209.85.167.74 as permitted sender) smtp.mailfrom=3dDkxagkKCAUfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lf1-f74.google.com with SMTP id 2adb3069b0e04-5aa607bbfe2so2640154e87.3
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781642563; x=1782247363; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fkz/8WHSlc5z8mgSFYgivmaJvolb4fXApnGq7F/IsFs=;
        b=etxsyHqYqAnQjg3pKc7OzM/QJtE5CRkgo5Oe3Y+0o2QX4/XiromjwbAejqNHQDIcS9
         XrkRqIf2XJ3TbzLEmI793heO+LLo6yHZsymkqiKh27H/DL9V42k81YhzONUsEHfUmL1u
         WEPXelDHiMBYWLvhRJx7FgSXxl2paZlgIhTmLgINxjTJab/WaUeuXpRP+WZt0fpKFXVJ
         5AdLWWUEBl0ADYi4jGJi2qneC0hwRA7Zc0d1gt9ACazGnCR2hFcNL4SxYxC8DS2i42wZ
         9J5Ul2NAhSySCMtwkvDvwY2dW7mL512XFdlRQcp7tTXzTUtTZXPwulIuYMZruxvYEtQN
         yc1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781642563; x=1782247363;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fkz/8WHSlc5z8mgSFYgivmaJvolb4fXApnGq7F/IsFs=;
        b=erlKei9ER8jaz3XU9pk8lHsL/vNx9y0b1oOzxR6bND3IHrAvZ4HC8KLWA08lyjRhp4
         gnf6noABzHR+hj01mAU7pdGP/U+V0+PvpvzS07Ocz5eU22IDMhuIkn/CupFuKB+Jw0iz
         VVtlDE6KQPYibD3cLVMLzfPThWPWlYuTfEiLqOvqfsCIX/9RoMx+zNNYi197Nmn05zZ3
         MTZ9RIrQTbL9IYqb4HJ7Wu4U0Lpzf+w9WGz08xgGEKI0aDeH3UkyXPfu6Sd0ziZ27AVx
         ib6nPNTLCEafUUzIY/KxHl3Bt5A2IsN9Nm5bDizoklTzW5KuQebs42I0LKibe20uc8q2
         lHTQ==
X-Forwarded-Encrypted: i=1; AFNElJ8e2g+XsShcJ06wDJ717yokX3o8JL+uRnSlk69DApaKNV3Z/WCoLS0ZW32GcU6+kU5EGTGqgniiJA==@kvack.org
X-Gm-Message-State: AOJu0Yx0bYo/iPz1/Je37XhRmP7DNOoVOxzzN0CDZIHIovOaLBtQ+0PB
	ZfzkT/g9bvsJSZWWJRcos0jbqP/C8FqFBg0ylDUhrTJ5vK+wGTXVa7KutRxt/B0Hne48mjLMdZ9
	22mLgbBo1sYK1wY75Xg==
X-Received: from edrc26.prod.google.com ([2002:aa7:d61a:0:b0:68d:205:9a90])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:35c5:b0:695:865:47cd with SMTP id 4fb4d7f45d1cf-695086ebec3mr1540972a12.7.1781610868582;
 Tue, 16 Jun 2026 04:54:28 -0700 (PDT)
Date: Tue, 16 Jun 2026 11:54:27 +0000
In-Reply-To: <20260604-unique-ref-v17-2-7b4c3d2930b9@kernel.org>
Mime-Version: 1.0
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org> <20260604-unique-ref-v17-2-7b4c3d2930b9@kernel.org>
Message-ID: <ajE5c-5gZtJRoadx@google.com>
Subject: Re: [PATCH v17 02/10] rust: types: Add Ownable/Owned types
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Viresh Kumar <vireshk@kernel.org>, 
	Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	"Krzysztof =?utf-8?Q?Wilczy=C5=84ski?=" <kwilczynski@kernel.org>, Boqun Feng <boqun@kernel.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Igor Korotin <igor.korotin@linux.dev>, 
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-pci@vger.kernel.org, driver-core@lists.linux.dev, 
	Asahi Lina <lina+kernel@asahilina.net>, Oliver Mangold <oliver.mangold@pm.me>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 1A1E320002
X-Rspam-User: 
X-Stat-Signature: 5w3cksinxogdoy3t8wpx1jw8zf4a9xex
X-Rspamd-Server: rspam08
X-HE-Tag: 1781642564-450548
X-HE-Meta: U2FsdGVkX19L+KTbJF5hqMLMC6WfFlIfV281KYPsGago9Hhb3wUW4gIRxv1fc+mIEShsEOYXotZK3Q1TmarULrH8kEunL1eosvbeuHhpYC7l3ilV2Mh3bfHNDjDjPyjYN5LvHqmpJ5DdrCrSnhe39V4Y1WIdsZJYY0yf4XhDOAKziY/Kjo+4nm63Y/OU2PidA3SLE2HPLD35mWBqieScDg1ffbTaSe4WRhXhSqBdh7Uv4CFB+kxyg2c00mcf6UUnmWZgspMHzr+lDeBKhZPTc12qFBMrt6BBORdMQ1fUWLSUz5j4AneWXvWw+8X5s8i6Pz4p1ubKfq0Dxi/94el/FnSB2Z3kwMhhMlb5Bs+MQEAVKMIPKRdt0PAoDO92YS2Fh0K6KzTRMQ+a5cFK/ezQ/Urk6yoNL58S89Ed2Y/qpocBH9rv4D0wQ5beqfcBjDdPIQqhGSAWcQ0EOqQuj49brZtWtEzZUuFIKPCC3QriFhVU7ps4cFGKPxN1PJPqmBVCGu2btMLhipwYQGmumOJKQx6ItyJv9yUZ4nsgj1mUeXFl8IpiaGUFvO+RgenRNdwbxFbBiadAGY2TV4Q2bMLqCzeH8xfYZzW8LHB5OuBZsD7tQ1HGOC94iGgDAO2JJJMK02IE2/ciTJVZk402qA0cBHQxHWm6aa10R15IoVEu5mpmSzUYH8S9luG2ZvPpgmpzCFgOzaPWG4CmX+zjESZr8Vw/mejXbYT7HQ+wRfFPo2jLCFUKvapW/daCnDHce8Aqe7IOCiYbaEU5bPdBZwy6T/8mTWDbV6e+Ohimk9YVqzV7i7QLWAehtqJagvVnOhv9mwPiCouBBsee9RD/PQK+GJlAya0AZNT2AGlMKeF6K5NZ23szF0Xfb44CukUNfhT6BJ9EiFBm1KMVcrGH7UHlnt6BiheDloTQrq4ZpOHaiIERlrHQRdFenL6DDPhQ3a5lvjBO8+GDRCc2531hJjV
 oGZVL4E7
 qOeIveEClZ/Wu8cmZ+R/wByMfJVaNs6+7pydtMyjv8yuoR5pPtQ2mHXySGc4y/fB3wfVn3JyBNvJwANZiFiwy5PMAFcJ+NCiHTHjjLzLm89M0CCkX1FdwxbpwTZeObylAbaPAFZn/so5R/BRBKE916uA+RA83lXuewvb89G66QpTGOGJ3OCjOK8Ses9JOt73ZU2eCLlFXpJHCbBZOaDWtdKp/B8Y5vVjixtczHv4Jal0rY7toKNJF0aZlxq77dLvWY8OGroOhKN84qsX29xBollC25W1ZE7llw5s4fWKszmpPKfg61hTpd9tQzZKjlED1uLoFZBVUVyMHwnQFNgOz6eFYOqEQ9ZhzwkrpWpkg4u8y2v2VSTjc1f361hdx6XCeU2gcONIw+ubI6hYpJ8GdQAvJOqxFs1WFyCAHPEoTTp7tj1cSMIZvpBk3h/ZAsb9K9z6rvlZo5zfL0qqO1JSShpFjQYGQIn8hrqpO6zDDFjD9VDeDFad4uBYhl7Z2xqZVfP+z9DVxuou4nnONa14kSKeQZiCFBI0wqGVyECMgx1KLODyZXSSGAvLc3FA47vezLeyQuMxmqXb5Xui9rGGPFKV2MtMhySTctuHsgxV25FYHsediWCou2EppwDwa9CZm/ZYOlOC+u7jNJSRK0KMS2sm3HbfebYiOE/dn1mhKKCF9koOgKoAbqO6YYwcmzFroGJk7lSV0JZcFhZ8rNWpqnH4v4oHy3CFKEHWhO67/k0S7+DfFrGWA9clc8T6tFji32z6SkbjpDdezNgIFFyUJtgjLnhCCdl7UncDk1JVty4E74ereqejUsJ3HUB/dNxju8aNpeaJ0HWaDTJiYd8lPrRGwGGrJrhfqHs502BxQVRsaRfkVPbi5q/szTU/of6rwnJCpuDpO2qDDTVwl3szlaatm4rGiSFXxP+WIeQiS4LKVPbXNZT5x08Yx66k//FvEL4X05OzBPHI6+zgnNsjT4rhX4JO/
 NbG8gXVq
 YtzQJVxc7K4JKHQ1f2I9k6ks6Vb531/PYuBHI9GLrfVCBplYFY8mHrRki4X/dPSdoernPb14F0SSiPqeG2Whrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 10:11:14PM +0200, Andreas Hindborg wrote:
> From: Asahi Lina <lina+kernel@asahilina.net>
> 
> By analogy to `AlwaysRefCounted` and `ARef`, an `Ownable` type is a
> (typically C FFI) type that *may* be owned by Rust, but need not be. Unlike
> `AlwaysRefCounted`, this mechanism expects the reference to be unique
> within Rust, and does not allow cloning.
> 
> Conceptually, this is similar to a `KBox<T>`, except that it delegates
> resource management to the `T` instead of using a generic allocator.
> 
> [ om:
>   - Split code into separate file and `pub use` it from types.rs.
>   - Make from_raw() and into_raw() public.
>   - Remove OwnableMut, and make DerefMut dependent on Unpin instead.
>   - Usage example/doctest for Ownable/Owned.
>   - Fixes to documentation and commit message.
> ]
> 
> Link: https://lore.kernel.org/all/20250202-rust-page-v1-1-e3170d7fe55e@asahilina.net/
> Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
> Co-developed-by: Oliver Mangold <oliver.mangold@pm.me>
> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
> Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
> [ Andreas: Updated documentation, examples, and formatting. Change safety
>   requirements, safety comments. Use a reference for `release`. ]
> Reviewed-by: Gary Guo <gary@garyguo.net>
> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Overall looks good to me, but two nits below. With them fixed:

Reviewed-by: Alice Ryhl <aliceryhl@google.com>

> +pub trait Ownable {
> +    /// Tear down this `Ownable`.
> +    ///
> +    /// Implementers of `Ownable` can use this function to clean up the use of `Self`. This can
> +    /// include freeing the underlying object.
> +    ///
> +    /// # Safety
> +    ///
> +    /// Callers must ensure that the caller has exclusive ownership of `T`, and this ownership can
> +    /// be transferred to the `release` method.
> +    unsafe fn release(&mut self);

I'd make this take a raw pointer because the pointer can be freed during
the execution of release(), which references don't allow.

> diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
> index 4329d3c2c2e5..4aec7b699269 100644
> --- a/rust/kernel/types.rs
> +++ b/rust/kernel/types.rs
> @@ -11,6 +11,17 @@
>  };
>  use pin_init::{PinInit, Wrapper, Zeroable};
>  
> +pub use crate::{
> +    owned::{
> +        Ownable,
> +        Owned, //
> +    },
> +    sync::aref::{
> +        ARef,
> +        AlwaysRefCounted, //
> +    }, //
> +};

We removed the types::ARef re-export, so you shouldn't add it back.

Alice

