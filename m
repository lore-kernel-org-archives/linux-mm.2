Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E783CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 17:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 768508E00F4; Tue, 26 Aug 2025 13:02:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719508E00EC; Tue, 26 Aug 2025 13:02:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62F1C8E00F4; Tue, 26 Aug 2025 13:02:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 50C118E00EC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:02:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE59FB746A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:02:18 +0000 (UTC)
X-FDA: 83819526756.24.CBB0ADE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3EBC04000A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:02:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bXN0ec99;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of lossin@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=lossin@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756227737; a=rsa-sha256;
	cv=none;
	b=oPpl76NEmmQPM0aZyA4cELREA5qYycyLK9j7hm0Jio7EdmGLmIi+L3YYMGQtYWnRi6ei10
	Bc4i3V+xvzBgTxogSb0wRkBE2kq7Vf7igEQr4fdwPf0AGLlFvXDOCZVWDtc6Ufm8jrTaKq
	SvjtfP09Cu70Zx+FhrZWoln8TIARYJg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bXN0ec99;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of lossin@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=lossin@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756227737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBXZWzv+CbnQGx6jmIhtHysjzTj4FKnbJ1Vr7YZqgRA=;
	b=Mpz1KTDyitp8ggib9yp5AcqcRpknWuY+8dEyUVcKxu2ulnXuKvgMlX/AAqLgLdSrBhj6zB
	C5ru71WFjisAs+7LBLFuU9gDbJeWZcGd9ZKXE5En8anajJj4lT65poHvTMRtxOwTDUno/e
	mTu925l+F1MihgZ9x0cWBTI9BRL3i0s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 61227601F5;
	Tue, 26 Aug 2025 17:02:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAC6C4CEF1;
	Tue, 26 Aug 2025 17:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756227736;
	bh=uWeuDAsfN/tp/nC929ZRBzcYdfCHEc7ZuZPZ1yV5eY0=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=bXN0ec99osLJTD0La+KFz2H/LAu9VqjB86wvXoLkYi0oO78srlCdGJ6THvwBpcJiS
	 uS2N3Pg4ZD3rCoXJ2Uom4gS3jKW4OTBJEqDbUBZ6EQ2gLqTfR6Lk4lc5Czj5SkRY6H
	 TBsdFEmRkgBzRCLJIeTfftdemdx0kTf7PRKYE+rcPBVthqLxEJ9lCUtJvR5xz50l27
	 Vq+C6NqeLh9H0odHmOsELFteGd2s0ITr+U5E3MRXF/ZP5bPBj9qBrUW2L9EqMvSIg7
	 XloGwx945bV5uJMzXcBpJ1lHueC31w9felQ42/P3evBksWBxx7lbsXm4NKdVIh0K1j
	 zmoMRkLm0UjEA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 26 Aug 2025 19:02:10 +0200
Message-Id: <DCCIRTHGQFNX.1M8GXO4TYA7DF@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, "Uladzislau Rezki" <urezki@gmail.com>,
 "Danilo Krummrich" <dakr@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Alex Gaynor" <alex.gaynor@gmail.com>,
 "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo" <gary@garyguo.net>, "Bjorn
 Roy Baron" <bjorn3_gh@protonmail.com>, "Andreas Hindborg"
 <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Yosry Ahmed" <yosry.ahmed@linux.dev>, "Nhat
 Pham" <nphamcs@gmail.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH v4 2/2] rust: zpool: add abstraction for zpool drivers
From: "Benno Lossin" <lossin@kernel.org>
To: "Vitaly Wool" <vitaly.wool@konsulko.se>,
 <rust-for-linux@vger.kernel.org>
X-Mailer: aerc 0.20.1
References: <20250823130420.867133-1-vitaly.wool@konsulko.se>
 <20250823130522.867263-1-vitaly.wool@konsulko.se>
In-Reply-To: <20250823130522.867263-1-vitaly.wool@konsulko.se>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 3EBC04000A
X-Stat-Signature: 8ced6m8zneu9fw8x9gm1ji57hzshez3m
X-HE-Tag: 1756227737-856003
X-HE-Meta: U2FsdGVkX1/PbUQwmWGiKTOZkkVgIb7iZvN1MDgJgYHtK9jqSUV03zkbXT3mHamK8zztOxwkUg54OKnuWe6leqo8aZAHUzkZ/6+hipwNyHQtivWnn16NOMFvrIVOMN8VgroIx77DbncrwhqCl4tKAPC4OJGGtLQkGIfeoVztHHkw2MelE+USU6Z0ZqoEw/FBfOH64iIOiPNd/3uYP3wix141GyHdlwuQckzbpW5FQPbux6i/3T94vuZtjhARppL42sti9tBwmv6hIZAzOgV4R3OoUQD7jzWerZADs2MJVHZyt+sLhilqY4QUAI1v7G5O4dZoCxGY+Y4DPOCk6tabMtyFQ42HXZUjdacdA72EurJM6T6j8LnMP1Tp3ZBQ4prNIC+ASMOmn4n9PaqB3z5is0aCOlxAl66ypD6OD2tQ93x5Mj+ZncIpHDAz2y26qjMbh1WIO+3XvjMPL50cTM0rz5rdnawENZw/0lAYEeiFn8/pcU+ac8Sz5OpjSo2IYXJ+HXs/gUpyw4GsBJA8sKj9S47Kc7NmutdC8+YD7KCfMkCnofWRc5LNb9HNV8lYCevVolNLpKf2AmjHh6ilgWcsaJa5b8CiUH0tMERV5vk/p/Y3zJ2sgYXEw8+S+12pOQew0JSYujadanl//mOcaGJTwJgdQhNczqYszGkBnKFw3/jsvvazvta6n+iTh/f4+Ati5DkCclXT+7W/1k6W1Jb77oA4smqthYWQ0NFY1r2WU49lsxJjhvnl/oKFopnfPUiCZ3i2nCUDdUIfTRIkgZ1zBaG42siPM7OUYyBstNJfUAgkt4HJUQtjJNdBjxvKD7GFdiGI8NeK03oeM7JL0Yp5Kde/RuuS0jD5SX6N6ZRSKfbgJpS1O6WTRDOrwtwhb7SgLO/WbtfPiPJpln+6w1MoDhOYeHuO6+PtUO+mpwBCA0ZYoua1EbRitFHvqDg3I/I5L3aW1QuuGXBzPMvuQve
 2+cIt8ej
 JipvX6pbGnASxT9Y9vskj3hSkEDSCuc4DRssDMC4mgWeB6MNc2ephhp/Iy5pM5BLm+VNfmNDIKu1unXgfVCxDoQFoBDieYbCEsYiUcIWiMZHVH7XpSCvMDmVt3LKMUvAwrU6w5/Sy01PikvWJl8lU5f3Sj/R17R46aXD0WwH7HYBXZRNoJrzLh+ea2477UUgO/ffqBQDJCFlXRQNQ/yFWHsGzhFXTm420G5YSfjE5QiCxula7/1bVwMJKGakS5xjoahBSyudCfOlZNlxr8TANcClirdEUz8oLVwg6DAbrncBE6Xdk2nNLb9zq1kleSpUy9tqe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Aug 23, 2025 at 3:05 PM CEST, Vitaly Wool wrote:
> +pub trait ZpoolDriver {
> +    /// Opaque Rust representation of `struct zpool`.
> +    type Pool: ForeignOwnable;

I think this is the same question that Danilo asked a few versions ago,
but why do we need this? Why can't we just use `Self` instead?

> +
> +    /// Create a pool.
> +    fn create(name: &'static CStr, gfp: Flags) -> Result<Self::Pool>;
> +
> +    /// Destroy the pool.
> +    fn destroy(pool: Self::Pool);

This should just be done via the normal `Drop` trait?

---
Cheers,
Benno

> +
> +    /// Allocate an object of size `size` bytes from `pool`, with the al=
location flags `gfp` and
> +    /// preferred NUMA node `nid`. If the allocation is successful, an o=
paque handle is returned.
> +    fn malloc(
> +        pool: <Self::Pool as ForeignOwnable>::BorrowedMut<'_>,
> +        size: usize,
> +        gfp: Flags,
> +        nid: NumaNode,
> +    ) -> Result<usize>;

