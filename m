Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3BE0606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.a=rsa-sha256 header.s=1984.8680eb header.b=hWh+t93A
Received: by kanga.kvack.org (Postfix)
	id B3E8F6B00EF; Fri, 20 Nov 2026 08:41:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF0546B05B0; Fri, 20 Nov 2026 08:41:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B80B6B05B3; Fri, 20 Nov 2026 08:41:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69FAA6B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:41:13 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DED2A1A0EF8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:41:12 +0000 (UTC)
X-FDA: 85455608784.13.99E35EB
Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	by imf06.hostedemail.com (Postfix) with ESMTP id C1FB4180003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:41:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=posteo.de header.s=1984.8680eb header.b=hWh+t93A;
	spf=pass (imf06.hostedemail.com: domain of markus.probst@posteo.de designates 185.67.36.66 as permitted sender) smtp.mailfrom=markus.probst@posteo.de;
	dmarc=pass (policy=none) header.from=posteo.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795182071;
	b=gSk5r7vx4VbmrR26TPO4RWFxV9vQVrakLnTKpr+x6PYEVieW0a/ERyEfKzrxGIXIo5jLSW
	qhPEvB4kOHofKByjn0rIxZIWjhs9vlm9GHUujtPPfDhmjQEkWpx2wFspAYvRhbYG23+JN7
	gjCI9AchQ6hr8CdbwAfY1zjrtcGjavM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795182071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YW4oRhO1MuXRHyeWQ9Lx5ixnye7cuXD9in5rMS24y2A=;
	b=idsUafs4H/KBiXtSghzwSq/wSyKMRsAqdDnNgpyTaoZqNnhcILRcq7mRHUKsXtBXWJ95UC
	TNq+JdVmHrLXp+7NeQ2AIyOyIREsD3PAwP0KbYjsulXg/cijB+nQeWAC3ePsygah7OLGmP
	/va/EcgQd9xK8USA7wZOV7YpxhXIiCI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=posteo.de header.s=1984.8680eb header.b=hWh+t93A;
	spf=pass (imf06.hostedemail.com: domain of markus.probst@posteo.de designates 185.67.36.66 as permitted sender) smtp.mailfrom=markus.probst@posteo.de;
	dmarc=pass (policy=none) header.from=posteo.de
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id 2C453240104
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:41:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=posteo.de;
	s=1984.8680eb; t=1795182067;
	bh=YW4oRhO1MuXRHyeWQ9Lx5ixnye7cuXD9in5rMS24y2A=;
	h=Message-ID:Subject:From:To:Cc:Date:Autocrypt:Content-Type:
	 MIME-Version:OpenPGP:From;
	b=hWh+t93AQ89D3y7Q9jrCyuBHB12xO/fjpp2KbQYXJeT2L3X6wH/D4DMbcDgYcqtgT
	 pePRFyBthjOtirmgOI5czcXW1Xr1VnxH6GfasweXjJm4J9Mm4Hw+mn7yRccYA1M89r
	 ckxYsVMo6pN37AZxMbKEL4i2LBGKnzK6/RJiaHheArZW644ZeQGqGoyhhM2h3T4JFH
	 Dk2Hxfv0uSl3GCmBxQb7acaV1ilGCR5zeH72IlA7Ii3mLlwUcevf0AERKWuKOWgNhS
	 bpETuEoWTvJyWgDofyUyxOmTRbCQ1514fODehAyVg1kPoYini/8kpChbhDu6bw685P
	 5EShivwIQiQoA==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4jWGgr36MZz6tyT;
	Fri, 20 Nov 2026 14:40:56 +0100 (CET)
Message-ID: <e4c77581b1c09f8e0c8be570283f653a2a7e2147.camel@posteo.de>
Subject: Re: [PATCH v22 4/5] rust: rename `AlwaysRefCounted` to `RefCounted`
From: Markus Probst <markus.probst@posteo.de>
To: Andreas Hindborg <a.hindborg@kernel.org>, Danilo Krummrich
 <dakr@kernel.org>,  Lorenzo Stoakes	 <ljs@kernel.org>, Vlastimil Babka
 <vbabka@kernel.org>, "Liam R. Howlett"	 <liam@infradead.org>, Uladzislau
 Rezki <urezki@gmail.com>, Miguel Ojeda	 <ojeda@kernel.org>, Boqun Feng
 <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,  =?ISO-8859-1?Q?Bj=F6rn?=
 Roy Baron	 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Alice Ryhl	 <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
 Daniel Almeida	 <daniel.almeida@collabora.com>, Tamir Duberstein
 <tamird@kernel.org>,  Alexandre Courbot <acourbot@nvidia.com>, Onur
 =?ISO-8859-1?Q?=D6zkan?= <work@onurozkan.dev>, Lyude Paul	
 <lyude@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Christian Brauner	 <brauner@kernel.org>, "Rafael J. Wysocki"
 <rafael@kernel.org>, Dave Ertman	 <david.m.ertman@intel.com>, Leon
 Romanovsky <leon@kernel.org>, Paul Moore	 <paul@paul-moore.com>, Serge
 Hallyn <sergeh@kernel.org>, David Airlie	 <airlied@gmail.com>, Simona
 Vetter <simona@ffwll.ch>, Alexander Viro	 <viro@zeniv.linux.org.uk>, Jan
 Kara <jack@suse.cz>, Igor Korotin	 <igor.korotin@linux.dev>, Viresh Kumar
 <vireshk@kernel.org>, Nishanth Menon	 <nm@ti.com>, Stephen Boyd
 <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,  Krzysztof
 =?UTF-8?Q?Wilczy=C5=84ski?=	 <kwilczynski@kernel.org>, Pavel Tikhomirov
 <ptikhomirov@virtuozzo.com>,  Michal Wilczynski <m.wilczynski@samsung.com>,
 Ira Weiny <iweiny@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
 Thomas =?ISO-8859-1?Q?Hellstr=F6m?=	 <thomas.hellstrom@linux.intel.com>,
 Johan Hovold <johan@kernel.org>, Sumit Semwal <sumit.semwal@linaro.org>,
 Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,  Dave Jiang
 <dave.jiang@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Saeed Mahameed
 <saeedm@nvidia.com>,  Zhi Wang <zhiw@nvidia.com>, Jonathan Cameron
 <jic23@kernel.org>
Cc: Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 driver-core@lists.linux.dev, 	linux-block@vger.kernel.org,
 linux-security-module@vger.kernel.org, 	dri-devel@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org, 	linux-pm@vger.kernel.org,
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
	linux-usb@vger.kernel.org, linux-media@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, linux-serial@vger.kernel.org, Oliver
 Mangold	 <oliver.mangold@pm.me>, Viresh Kumar <viresh.kumar@linaro.org>,
 Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?=	 <ukleinek@kernel.org>
Date: Fri, 20 Nov 2026 13:41:05 +0000
In-Reply-To: <20261116-unique-ref-v22-4-12029383206d@kernel.org>
References: <20261116-unique-ref-v22-0-12029383206d@kernel.org>
	 <20261116-unique-ref-v22-4-12029383206d@kernel.org>
Autocrypt: addr=markus.probst@posteo.de; prefer-encrypt=mutual;
 keydata=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
 jfGillcaQOqFZ3WwVqyzG1BUfTow==
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-1bC6az0UrhT7nf2a398O"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
OpenPGP: url=https://posteo.de/keys/markus.probst@posteo.de.asc; preference=encrypt
X-Rspam-User:
X-Stat-Signature: tzk7t13xa9sezx7g65hmsqkhx5un59zi
X-Rspamd-Queue-Id: C1FB4180003
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795182070-177448
X-HE-Meta: U2FsdGVkX189Dd1uqjHgTT4LhFmHS+FdOIp4vhtaNxXCGos0TCXdqZKhLVsz+a+BnsYc/wKeQxwrm2fCLqYmPCWM1Nz9/fgA5ieOQ5RuJVINqZevyYFrgsrGJQDRUIYOe4Aur+jBe+lc8YACJx0AMVx03M8cnC8V+gP8BwxbrwFTdF2gDcgK+WGDnvpXWZ4vnvFoqofgzWenZlSa2KhRUp7ll5SPZou/P/sDtNvoKVb+m2OVbBbnJd4HQOX4wJYUtMt/PnmrtmxYIxonj2hn/Dag6nBgcmnwBuH2gN+WOjTjQ9rnJqfTs95abGwShnGh1SXhdJSphtwffjmUQIMrwxyJmGCr3Isg8vtsipksrtF+SG32FNWehtXqx39u8YD7HUcIjiwYFNgP1rmQu0tyjx9tL1AKdxfGQrdh0qnv1UJ2AK4+4Ai9zdRSWjRfQKN09nPorBvLwItz3BnXFxpdESx50CLWqxxwzVKDAw1AVlA6DRnJ5kjMLP/X9sV4mcy+ES8x1sxv6Gfc8gnmtRYASPQAG1A04cyDO5+N5niZi0ujc3Kv4oq1+inV7oMxHeig8URMzIrT45LHoaHgTyjQDczJG1kK2GKe+RlnIGowcNkBBsD5Mvzb6VP991zXQANDOhMNOHecZCTkj0uE9wlSoIKnTH6z/+J1/N0dXX9hc5FN0Mit6tOMJtOZhOqeX8MgaDGTjeyxHeeWxhDBbs6DC5cNM7VdRbR5C7g1cc8kvBTMO/pEJ6NOyqpv84zd3Rrtv3Mst0iqj/e7I0eKF6ucnO8Ywk+jYi3Di6P56/M6E0EWcSrhrOisHZPYaRxSX+jtPvOYsWwBbPkCs00gyE0130TffggYvipyoDjNGqZTMz2lejMJA8OacIcakAUkYRj3jZxlrpx+oa8hyCuLmXWAvLsSqfDlqV1REZRiIPKT6F782opzSR4WFOx6Rs1LDTvsPHxrBT+5fWUB+WHcAIY
 wA9nIkvx
 w/uVdonQMxqk69DxdfKhgFKlNjfKKZXy/9UDFE3Pn/CL4xZKtpZjQcUhl8z26rcjlPG4hdOViC+3wW/jyKKAwuuZw4ZKm+OKhEgcmwPt1tt8I4fBYQcJIivkSq3YE9gWoRPV1XQbzCzaclEHvjeY7mlHRXmZfmSuQDHmZJEu7o9qfpHOwDJ1yl4w/Og68ZhVSZe354ZDAdLPwPFVuOwbBb4IYF9/spP2+W0/uBI4+/yXIBTiWAG5j4i4qbZOXvQ1H/pwxImV24UqZTKcUd9YssqKKMKZzN8KFFE9PyYQIlzocx0k6hUIA8TkM2DQ+KDpL8VaMlyyGrPat+rJmw3rONT4hlzN6VPMrztSTpfHDrhgqu//qMifoESvXt9h6zOwCPQWD2r+njFJBrTVKUyCXveLA01E7hIyiPVGRb6kt5DVcstGbP1tErbdcOs/H/cESS78iGQvpyLnV48aNr6muPcNCZD8rp4fnNmJGM/G9tz8qp6IkR+afWk27/MUtf0A6OzaD0ZkO6kQ3pW7ZYhzdzi6C57PZ6M8z6rhnr+MmTUyJnDNs4NfUmQaO6PvVF9FdGU6EjiBFuY5RIGqTFNQGFZhhEXnt4j/viLsk6bx+eS2mHe8F1go5QljzPfWYJWxciW1YaoQqS0J6KBLs9lBvjq4Fl43SmIk1YO8OMWyyu6c+8Z2deLax8H9TzXDrF+si7igZQkx0R4RnV/NSp4JpJUy3smPAiSHEQmRB9Yy7EFMXuKyvYIPQWfpWCgmXyfT0b5INa13Lm/9pBk309urmS/6tM+RfefdbzqUWfxORumXVvYnXj7U/UVfKnXfuayplmNXStw0Z4Xd7Vzpde2XmwmsmRxftTQtPNS2c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--=-1bC6az0UrhT7nf2a398O
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2026-11-16 at 15:21 +0100, Andreas Hindborg wrote:
> From: Oliver Mangold <oliver.mangold@pm.me>
>=20
> There are types where it may both be reference counted in some cases and
> owned in others. For such types, obtaining an `ARef<T>` from a `&T` may b=
e
> unsound, as it allows creation of an `ARef<T>` from a `&Owned<T>`.
>=20
> Therefore, we split `AlwaysRefCounted` into `RefCounted` (which `ARef<T>`
> would require) and a marker trait to indicate that the `&T` -> `ARef<T>`
> conversion is sound for the type. A type that implements `Ownable` may
> only implement the marker trait if it allows an `ARef<T>` to exist
> together with an `Owned<T>`.
>=20
> - Rename `AlwaysRefCounted` to `RefCounted`.
> - Add a new unsafe trait `AlwaysRefCounted`.
> - Implement the new trait `AlwaysRefCounted` for the newly renamed
>   `RefCounted` implementations. This leaves functionality of existing
>   implementers of `AlwaysRefCounted` intact.
>=20
> Suggested-by: Alice Ryhl <aliceryhl@google.com>
> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
> [ Andreas: Updated commit message, rebased on v7.4-rc2, converted new
>   implementers, relaxed the `ForeignOwnable` bound for `ARef<T>`, updated
>   safety comments. ]
> Acked-by: Igor Korotin <igor.korotin.linux@gmail.com>
> Acked-by: Danilo Krummrich <dakr@kernel.org>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> Acked-by: Uwe Kleine-K=C3=B6nig <ukleinek@kernel.org> # for pwm.rs

I haven't unterstood yet what use case this has, so I am trusting the
other ACKs here. Maybe a precise example would help?

For serdev:

Acked-by: Markus Probst <markus.probst@posteo.de>

Thanks
- Markus Probst

--=-1bC6az0UrhT7nf2a398O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQJPBAABCAA5FiEEgnQYxPSsWOdyMMRzNHYf+OetQ9IFAmsATecbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyAAoJEDR2H/jnrUPSANQP/R1hB8C5F3mypETYwCgo
/31OX6ODiCHu568feU0OwqqnH1gKua6thOPxdUzO4oz9uHEvJOy9k0pAUuqhIoUR
cwWGFajvqbq0iEcbMMls3ezTo63QhALeYKpaK+p4wCU6HqazGDnsTiqXqIBnSMFF
/zhMCLHxApAYueLhRzmTe9z4DIEhOaUdcOowPIV35HlxhghSQZ/uaZclBwv6h+xn
PDpQAKnR2JxW4CcyT1Fm62hItTX+Djvef/Q6aac3xdMq1JSPlsbNUlThWsY+EjbX
eBTAO766WENw3Hw3SxnX/pcUQwUVsRa3bxxgBxSfwZtm6nSfhxmBzAHsiR7aA4wq
hrI46P32JW6WcL+jToQJC/QjQienV9rV/QTWrfp83Z59ce3lL43XtMlofu0EoK6W
IWoX/O4IoSM3YDlzHsSYGQR7KG+VGDXyJAb6HhVyNdMTiegz8UxWwYqGviS9mTON
a3YA8htdMngXmkwT5CQKhsNbS0sLqGb3nDrqmLV2hSDpjGkdUe86bahObcVCXonf
7Gdl1/15c46K0QRbEf7q5kgreejRoLqFdi2eyw406ruUxE7Bd71t9faF5zWzaJRK
ewr2s+IremZr522ABFhIX0SFkqu1sPzXqNLKXQa5fz5XxTh6jQziddGf3Q2z71dB
79I2PETkcl5NqkNBz+UkmsCH
=iSw7
-----END PGP SIGNATURE-----

--=-1bC6az0UrhT7nf2a398O--

