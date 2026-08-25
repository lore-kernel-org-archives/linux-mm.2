Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C3C0C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A67346B00A1; Tue, 25 Aug 2026 09:16:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F1796B00A5; Tue, 25 Aug 2026 09:16:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E2C46B00A7; Tue, 25 Aug 2026 09:16:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 69BF96B00A1
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:16:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A7AE120427
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:16:14 +0000 (UTC)
X-FDA: 85139840268.13.B757D6B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D449240004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:16:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jOOaAim6;
	spf=pass (imf04.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787663772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SJq7313Y8SDZUpZpBKpgvRr+tGT4kF99sb5KXxTJs5M=;
	b=sg4YgD770LDPNWA8Cvcr+h+f2xT4wagvunJiOT4aBPVqju2EznANoDeLjzs8Yl8jZZI5nt
	RQ1nCA9Xy+7AKcO0EziVVpGw6KgE9swS1RN8vKCK+SScP3PMxq4lKmIy4umFYmps65FBr9
	vy4OhT2ZoQUPGscArlSXpxLVKrMGKS0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jOOaAim6;
	spf=pass (imf04.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787663772;
	b=hUloDwjtbdfW2F/5DtLZNoaxGwWjfV/2wKqLuNoik1LFwjUElDb3HaZQ7yu00Oy24Ipwaf
	vM2lfQYYHvkWAuzmYuDGHtPJJAYv9ochG8RszY/JSkfjBg9fB+LC/yRrgCc2kKM9GHF0eU
	lWJT9xLfhq5PIuZGdvBtkXVGm8yWWOM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 447B36020E;
	Tue, 25 Aug 2026 13:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337BA1F00A3A;
	Tue, 25 Aug 2026 13:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787663772;
	bh=SJq7313Y8SDZUpZpBKpgvRr+tGT4kF99sb5KXxTJs5M=;
	h=Date:To:From:Subject:Cc:References:In-Reply-To;
	b=jOOaAim6vepRVMufMhXqW+jdR92Uj/CQip+PzFYfubv/OMZ3eyUSRGWiKKmKNc3Qs
	 CIm4t5wBReG0/EzVZMMYQaCDwyoS3D65nGSJBRGnjlSdgcrmSdhqvsDrsmHHFvg81d
	 1a8XfJN8Etg9fgBwxvXnF/+QyTa7KXeMaLqVz3T7rfFs5ePpHmWgzlp0ic560K2ES8
	 +sKY3nnCCb3UYoS5DX0VufYTeHjc+/HK7+EsZ/TDSLU4pY9wuI+v6lBKKxY6ZU55MY
	 42LtwLW+ei/NoBBso+QNdCFfVmnM/IhMY8bURoNTKHVq9tVjiB5WIiT8PMFwPcIb5m
	 Ow2FZWe/ZmKAw==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Aug 2026 15:16:00 +0200
Message-Id: <DKY1WYBNR288.36W5V60TR81MG@kernel.org>
To: "Andreas Hindborg" <a.hindborg@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v20 7/8] rust: Add `OwnableRefCounted`
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Uladzislau
 Rezki" <urezki@gmail.com>, "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng"
 <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, "Benno Lossin"
 <lossin@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>, "Trevor Gross"
 <tmgross@umich.edu>, "Daniel Almeida" <daniel.almeida@collabora.com>,
 "Tamir Duberstein" <tamird@kernel.org>, "Alexandre Courbot"
 <acourbot@nvidia.com>, =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
 "Lyude Paul" <lyude@redhat.com>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?=
 <arve@android.com>, "Todd Kjos" <tkjos@android.com>, "Christian Brauner"
 <brauner@kernel.org>, "Carlos Llamas" <cmllamas@google.com>, "Rafael J.
 Wysocki" <rafael@kernel.org>, "Dave Ertman" <david.m.ertman@intel.com>,
 "Leon Romanovsky" <leon@kernel.org>, "Paul Moore" <paul@paul-moore.com>,
 "Serge Hallyn" <sergeh@kernel.org>, "David Airlie" <airlied@gmail.com>,
 "Simona Vetter" <simona@ffwll.ch>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>, "Igor Korotin"
 <igor.korotin@linux.dev>, "Viresh Kumar" <vireshk@kernel.org>, "Nishanth
 Menon" <nm@ti.com>, "Stephen Boyd" <sboyd@kernel.org>, "Bjorn Helgaas"
 <bhelgaas@google.com>, =?utf-8?q?Krzysztof_Wilczy=C5=84ski?=
 <kwilczynski@kernel.org>, "Pavel Tikhomirov" <ptikhomirov@virtuozzo.com>,
 "Michal Wilczynski" <m.wilczynski@samsung.com>, "Ira Weiny"
 <iweiny@kernel.org>, "Philipp Stanner" <phasta@kernel.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <driver-core@lists.linux.dev>,
 <linux-block@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>, <linux-fsdevel@vger.kernel.org>,
 <linux-pm@vger.kernel.org>, <linux-pci@vger.kernel.org>,
 <linux-pwm@vger.kernel.org>, <linux-usb@vger.kernel.org>, "Oliver Mangold"
 <oliver.mangold@pm.me>
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
 <20260824-unique-ref-v20-7-490735672187@kernel.org>
In-Reply-To: <20260824-unique-ref-v20-7-490735672187@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D449240004
X-Stat-Signature: i6cq1b3jj54m8s1wrpbiqf8j15et7izk
X-Rspam-User: 
X-HE-Tag: 1787663772-15908
X-HE-Meta: U2FsdGVkX1+wB81Vx/0oQ0qIE+nuAKuuVT2XTj+mObCqNjidkLkh9AC0cyTxo5Yq9b2SepR3ylmJJ+6bO5Tbw6MW0DtcVnimP5xoKSKxBNEOesZ5Ea6b96GLUv3DFWw92u+DvbySax8xdC/4EqsN0Fqsj05wwGCg3PUpmttinAQQGvIAFVADJyQRF7OyMQxC84nEOIQviIIld+TMQT8IfX9ZLgJbL2ixNK6xwqF+X3eqIB0vHyfyJD7tFC1QjTCUgt/4wo8oftMU8VcQwCPLbAwiW2OaHv7U6WdwghJfvihYST+a7SNm8NaJKEs6dUD6Q4D5TXoszh73aqbNRD0R8yATj1Xxt3u8wnFQmLrz5SIUc5XpvM6ZQ3WfBtVp9T5zZeOdxvToqzj3YNgmuh+DStAYMm1OQx7jOItq1NsS55sbMpPRTuLmqUA6NosEIypFVP0u1oFbomWNnwy+qKpjomVlB9HACkcueCgqkPUlxFNpXpKJoFZ5OzWIetDEEKYiAiwHsUiGdfbs969WvxzhgRxGwaG75x0oV+eYzSV7CeQtBrI3JFoaIr+aal00oMzPMigsh6knJyoF4m0GjOEZr24+vfbW1lUFpBNgpnOAN9mZBKzbFrdr1zi/j0wumDCBy/1qfx1U+qPy9wGHTKelEdhsuDH5XFquMV0/7juH3Pf+Utz7B5zNJx1InPeKFdg9t93GqU5eoaMIiACdj6uoXopZqdAnj0LoqJeb7bG4f29CNNxbkpH13eDD1FLPvrwzQ6lu0SFkaZMsngVnXe7gEudxeJO4srxgL3eeB8leET4GvAay8Gwz3PTdY/od9w8lwtP0Tmh2xvp0m9s+POzhZ+p94GeXCjtXyTlo5CBqtEWP7+dgULt/B9xDqv0YabFG3jnJVrmOwcDJAQgri64lBWovQHXcyThZZaLdFhPJddgK/Yz1X+X6Z969KnJ1DZB7TjoTo9Hj+0KPZTnZ9KB
 HuHTAv5w
 QuSdAGyErGeF1vkj7Wzc6CsKxzRDC+7TbtPWtDlggc+tQM59JUZvVxdRH+G77q4XOOe1FYo32Goc2HDz9YZdg+u8ZqK9YooPNBCqhG81SXPhnNZSol3+HFQ7+y+tO5BDJZ3X8y+mmEvVsWSG5+S3Q1Zk9Tqm4lvgrqvjFxNVvBDwk+D7VfXTK8HlIn7qEF7Lzs0/onE/0nqbZuzefllg2804esp24rLHnnO5IWFlNxQxRo8gKj8y0Bs12i6NmjCTb2jinglBDbT9jnbnt/mavELv6tx1cR3zyAMuQnmjC5Nhsx8uBrp7VA7FjE5JWnhCBtMF8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 24, 2026 at 1:17 PM CEST, Andreas Hindborg wrote:
> +/// struct Foo {
> +///     refcount: Cell<usize>,
> +/// }
> +///
> +/// impl Foo {
> +///     fn new() -> Result<Owned<Self>> {
> +///         // We are just using a `KBox` here to handle the actual allo=
cation, as our `Foo` is
> +///         // not actually a C-allocated object.
> +///         // INVARIANT: We initialize `refcount` to 1, satisfying the =
invariants.
> +///         let result =3D KBox::new(
> +///             Foo {
> +///                 refcount: Cell::new(1),
> +///             },
> +///             flags::GFP_KERNEL,
> +///         )?;
> +///         let result =3D KBox::into_non_null(result);
> +///         // SAFETY:
> +///         //  - We just allocated the `Self`, thus it is valid and we =
own it.
> +///         //  - We can transfer this ownership to the `from_raw` metho=
d.
> +///         Ok(unsafe { Owned::from_raw(result) })
> +///     }
> +/// }
> +///
> +/// // SAFETY: We increment and decrement each time the respective funct=
ion is called and only free
> +/// // the `Foo` when the refcount reaches zero.
> +/// unsafe impl RefCounted for Foo {
> +///     fn inc_ref(&self) {
> +///         self.refcount.replace(self.refcount.get() + 1);
> +///     }
> +///
> +///     unsafe fn dec_ref(this: NonNull<Self>) {
> +///         // SAFETY: By requirement on calling this function, the refc=
ount is non-zero,
> +///         // implying the underlying object is valid.
> +///         let refcount =3D unsafe { &this.as_ref().refcount };
> +///         let new_refcount =3D refcount.get() - 1;
> +///         if new_refcount =3D=3D 0 {
> +///             // The `Foo` will be dropped when `KBox` goes out of sco=
pe.
> +///             // SAFETY: The [`KBox<Foo>`] is still alive as the old r=
efcount is 1. We can pass
> +///             // ownership to the [`KBox`] as by requirement on callin=
g this function,
> +///             // the `Self` will no longer be used by the caller.
> +///             unsafe { KBox::from_raw(this.as_ptr()) };
> +///         } else {
> +///             refcount.replace(new_refcount);
> +///         }
> +///     }
> +/// }

This is valid as Foo is !Sync, but I think it does look racy on casual read=
ing
and possibly even encourages people to do the wrong thing, i.e. to peek a
reference count and subsequently act on the read value.

Besides that, if the value can't be shared across tasks it's not overly use=
ful
in the kernel to reference count it in the first place. Do you have a bette=
r
example for this?  Maybe a broken down version of the one that motivates th=
e
patch?

