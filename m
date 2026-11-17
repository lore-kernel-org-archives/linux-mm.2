Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F18A2606A886
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 14:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ms4TEX+3
Received: by kanga.kvack.org (Postfix)
	id 22A056B05B0; Tue, 17 Nov 2026 09:23:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202096B05B4; Tue, 17 Nov 2026 09:23:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13FE96B05B5; Tue, 17 Nov 2026 09:23:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E03696B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:23:12 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 385DE120484
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:23:12 +0000 (UTC)
X-FDA: 85444828224.24.DB0D836
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 731D180003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:23:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ms4TEX+3;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794925390;
	b=658dZ0sX0CJFABZuMngCO6eThRnay82J0cUd1qb407l7I64oiGFL0DMuJnPpANvnyJ/+e+
	rB3fMPa4f5/tU0Qm2CpmRKbQ689slBucionlzx6F7MwZ1soXPJ0rQDrV8vNKeocs3kUEdW
	w5GWrGHECQyr1W3qKUc6ZRMYJNdfBpg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794925390;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1v3XDaIPsn+JJltQ44/B7GYW4pMWHo/jyhLjp2tXhpU=;
	b=ohoWz5UH9VagKxRkpeg7yVXbXZTQOtlBEH9OPwPDeFUnfF0zj6lNoawEwzGOmr9hKhhkXc
	w7e66czlLgmdsovGZQrcm/EfMoIXO0iFxKpzM5h1yr7L9sRwaawV7OWdpZD1U5NGhLKLqg
	ZlaxgVWDqfszzGMlN4veIaiq4cDROgc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ms4TEX+3;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B153441999;
	Tue, 17 Nov 2026 14:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E9B1F000C8;
	Tue, 17 Nov 2026 14:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794925388;
	bh=1v3XDaIPsn+JJltQ44/B7GYW4pMWHo/jyhLjp2tXhpU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ms4TEX+35GlVZDWxtFrKHXCEGtiwtf31X5SUg8Rgxfe9VPX1jDQW0/Og//0X0wDmk
	 I9MBNEYvG3eyERN88hZmPsTUdvizD6YaKHRnRh7ce3+vpkmakqbx2/k1M3K8WPtlAM
	 d55iB8zUE+ZCUuKf409Cqx9uTzXVD3rBgWL9o9jOCKYNH1qZ/qpDDYdJj8vzeVUGfN
	 8rjbHYLe1Ak0daACyU18m/Cqw+KrkKBXBwPxXxcFQfKm5jRz6fmZ5nHp5wqFQaVNF5
	 ZNohBWGVtYRBmBA1kLVGKZhNDZPJTdLoDa4ocqQt5LtsXYH1lLrakqxKTEFzfSRGG5
	 vTlyhXL4TjQ+A==
Message-ID: <sashiko-outbox-218957@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v22 5/5] rust: Add `OwnableIntoShared` and
 `OwnableTryFromShared`
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Danilo Krummrich" <dakr@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Uladzislau Rezki" <urezki@gmail.com>, "Miguel
 Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?b?QmrDtnJuIFJveSBCYXJvbg==?= <bjorn3_gh@protonmail.com>, "Benno
 Lossin" <lossin@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>, "Trevor
 Gross" <tmgross@umich.edu>, "Daniel Almeida" <daniel.almeida@collabora.com>, "Tamir
 Duberstein" <tamird@kernel.org>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?b?T251ciDDlnprYW4=?= <work@onurozkan.dev>, "Lyude Paul" <lyude@redhat.com>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, "Christian Brauner" <brauner@kernel.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Dave Ertman" <david.m.ertman@intel.com>, "Leon
 Romanovsky" <leon@kernel.org>, "Paul Moore" <paul@paul-moore.com>, "Serge
 Hallyn" <sergeh@kernel.org>, "David Airlie" <airlied@gmail.com>, "Simona
 Vetter" <simona@ffwll.ch>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Jan
 Kara" <jack@suse.cz>, "Igor Korotin" <igor.korotin@linux.dev>, "Viresh
 Kumar" <vireshk@kernel.org>, "Nishanth Menon" <nm@ti.com>, "Stephen Boyd" <sboyd@kernel.org>, "Bjorn
 Helgaas" <bhelgaas@google.com>, =?utf-8?b?S3J6eXN6dG9mIFdpbGN6ecWEc2tp?= <kwilczynski@kernel.org>, "Pavel
 Tikhomirov" <ptikhomirov@virtuozzo.com>, "Michal Wilczynski" <m.wilczynski@samsung.com>, "Ira
 Weiny" <iweiny@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>,
 =?utf-8?b?VGhvbWFzIEhlbGxzdHLDtm0=?= <thomas.hellstrom@linux.intel.com>, "Johan
 Hovold" <johan@kernel.org>, "Sumit Semwal" <sumit.semwal@linaro.org>,
 =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Dave
 Jiang" <dave.jiang@intel.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Saeed
 Mahameed" <saeedm@nvidia.com>, "Zhi Wang" <zhiw@nvidia.com>, "Jonathan
 Cameron" <jic23@kernel.org>, "Markus Probst" <markus.probst@posteo.de>
Cc: "Philipp Stanner" <phasta@kernel.org>, linux-mm@kvack.org, linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-pci@vger.kernel.org, linux-usb@vger.kernel.org, linux-serial@vger.kernel.org, "Oliver
 Mangold" <oliver.mangold@pm.me>, media-ci@linuxtv.org
In-Reply-To: <20261116-unique-ref-v22-5-12029383206d@kernel.org>
References: <20261116-unique-ref-v22-0-12029383206d@kernel.org>
 <20261116-unique-ref-v22-5-12029383206d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 14:23:02 +0000
X-Rspamd-Queue-Id: 731D180003
X-Rspam-User:
X-Stat-Signature: 7xt484xyxonf7cadwnh15dsp88qygsu5
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794925390-477713
X-HE-Meta: U2FsdGVkX19IPwQPaozyaz7gyDrxKpjgcBz8UKG/AL/uvUI/h9XVePKBtbgAX43uXiwKKG/GVT5bECB+o+9mTrI6EATs/EGBLe+mifiygl3BHBLuK2UmrUZBVIB63cu57r6rCTBOfAFp2vuxOtqEeiR9iRQhUZRbXuTsjdXLqVwtnt+4lj7vE873bfq0DcPGo6vIYPjh+Sc9KDAQ2+kD9sgq0yRlFl7bXu7Du5WwH7eQ1wz4Tlw1RYo642P1EYS8lthpiozkqxDSmOU7AEuhzZla8k6gFQINQYXPjXg4whzagwMq72wfxX8d/2EJBqVjs2R8JyCtZSZ/BfA9PhY31zEgu8ZQ2FBURhUs0LCIHu4uyH94F8aLufkHefihDMhX59/vsroDhbDtrDyXnGVwbdT5S2nzwDT36wxZKH6nxrN/AATZomUFxvzRsN28swgTNtzUEgbAmnRqkvtMvkynqpzZJPXhEicJw/x1n7+pqp2kat9tpERKzFk5i8QVKhfW3i88BtqMhxwVAZVuGmInrygS6zUfVvlfvqzMB3UOdFybfL8eMa2t8KUIQji7+/AomccCqSbuhDgZs6u7QYnADJoBJDeRocXdNbWXOQIf8gOYypY13RTna6PyM+oUgHI1mO7f0vXe9EnqEDFd7EL0fL9nnFha+uHc8x7gyJgFxSINOvhQJTNRITARZCunRCL4Iurjt8Q0GfTyO6WGtRL9K7gTJqJZHAD8/3dSYrCXWuYmaRphYThdcfiJqr2sKE2dqRDkA4gJ5Czc5b4zmtQlIoCJcoBgwOt2uLbmfFjgBSvtYQMmgRhufriSQDfjl2WDOBQeevuyGbL2a9oiF7q0SWj6ckC0CJLiCcE1OxCFjdGAbsm7BSZwvDYtoGuBDc4MtXQ1iyEXY4KboXIPwwVfpaWGFR9H6lfhWR/putU+1Lwe7VW09qC/F8eFCcFczlUYi2GNUKwk5mv8BLwPu+G
 Kd4ylt5T
 bjcktjR0n1t74EYYugEimQXUMwOkxsEIgdPTVrVxPaH1OjGTxp2h7H8PDVcysmqgjFuHOdrqCpmsPyURem+eXblQU132/y4K5RujtVdV+5tG2RI1GtcLnoNa2hhrZ1eRPDl2qs8Wh4nxLRWgvHdgpry3qEK5e06VmiuNJe9l49vxa52oHdEQYCj4tLf4FXUbv9OrUsRVnUX5oGr+8yCt6hBWgfmB+uvp0FALTpTwhbhP3TN8cqBKMyUp6iALCBRqr+GaKLzjFKrBTwwIO9qKtSKH/mO4xD22nqpWcKmIVlQwYhAtsUNM2vNkXeKeuFRuhCIYL+ihLlDLobvkVFQk0fvoq7N8THCND4qyu/gPtJBvblnAVUa/4GwbEJ1q+VtIhKy8ZdX1pW7ubUd26Y0H8qvrXBCsU1P5Dn7qctyEaB6HndjCHCc0nPvAs11es8igYgPX5kEV1rRHTF5GZV0nTLA/wJYJovRqieEFM0mVJL9jRZUYglxILsoVCcdRHC2H13XPGTkcDjd5X3noTbVVWT9N4KWO1+rAzep+/2HUZ5Ef0mS23wJZ4OlfwfU5fVI365dULvJ8eZTrfvoRGQJh7nAUX1wwl2+tNdp/OxjudHdLlKasqTQhpmxHdeAitHyL3VSlahtzq0CUxgLOr434PIYV11s0330W9eyaksMBjsAC0V7Cvu6HhRFUoqymhYtEid7kl+mkLoqApwF4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] rust: separate use blocks instead of single vertical import
  block
--

commit eb9ded53e4184ea08932194e99ba6dc1bce8d3eb
Author: Oliver Mangold <oliver.mangold@pm.me>

rust: Add `OwnableIntoShared` and `OwnableTryFromShared`

This commit introduces the OwnableIntoShared and OwnableTryFromShared
traits to support converting between Owned<T> and ARef<T>.

> diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
> index bfc52bc7f6451..5b71d264477ef 100644
> --- a/rust/kernel/owned.rs
> +++ b/rust/kernel/owned.rs
> @@ -14,6 +14,10 @@
>      pin::Pin,
>      ptr::NonNull, //
>  };
> +use kernel::{
> +    sync::aref::ARef,
> +    types::RefCounted, //
> +};
> =20
>  use kernel::types::ForeignOwnable;

[ ... ]

> diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
> index 6bc58aae38ed9..8a029d124fa31 100644
> --- a/rust/kernel/sync/aref.rs
> +++ b/rust/kernel/sync/aref.rs
> @@ -23,6 +23,10 @@
>      ops::Deref,
>      ptr::NonNull, //
>  };
> +use kernel::types::{
> +    OwnableIntoShared,
> +    Owned, //
> +};
> =20
>  use crate::{
>      prelude::*,

[Severity: Low]
This isn't a bug, but both files add a separate use block instead of
merging the new imports into the existing kernel/crate vertical import
blocks (grouping ForeignOwnable with RefCounted in owned.rs, and
OwnableIntoShared and Owned under crate::types in aref.rs).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116-unique-ref=
-v22-0-12029383206d@kernel.org?part=3D5

