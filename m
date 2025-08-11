Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E63C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 13:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C26178E0056; Mon, 11 Aug 2025 09:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6B78E0045; Mon, 11 Aug 2025 09:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B136B8E0056; Mon, 11 Aug 2025 09:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A0C508E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:38:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 407DB1A01A2
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:38:31 +0000 (UTC)
X-FDA: 83764581222.08.A53C20E
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf27.hostedemail.com (Postfix) with ESMTP id B282340006
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 13:38:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZuYO1pyf;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754919509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOfZRdM/qqYj6GeyhKBjq7vdH2qd/Dbp7Ah9gAR00ZI=;
	b=ZUdX/DsyNQ1PAeMz+xgzlVEXnU/eqbtfOv+iuSABQJtojfDZPSJsQA4KYMOvuDEnrLvAT1
	gsvlShUgApQouIPZeBVZa5vvJXlO7RLT/zihLzlXSHF7qFfyPLmCvHnmaomEnYyBsVrj/4
	gGQD2r/cFUai9V2NvEwYskQEurLfE7g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZuYO1pyf;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754919509; a=rsa-sha256;
	cv=none;
	b=crEIPok0sdXjGh3P9VvHDYn2f4XGCYVrLyyJ43BSPIhN+W57sLC7Il+6amMBLN8PsQky3O
	d0w54SU/ldyPtMi/VI8l/ByGT4daMra17FDsMxFTMG8DTV/I1QgZJ1gsCcDhsSWw26rqD4
	59z1PMZ3nUY5cW0auwF9jaWkqqlDr6U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 18456A56E96;
	Mon, 11 Aug 2025 13:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8109EC4CEED;
	Mon, 11 Aug 2025 13:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754919508;
	bh=bOfZRdM/qqYj6GeyhKBjq7vdH2qd/Dbp7Ah9gAR00ZI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ZuYO1pyfJ9AQu5ponOsLQyI4lrsHCY5zViVB2CocdX9e7rbPaqw60Orwg/6+0Yq/C
	 +vNz4IbebOt4JZHXP1AwcVN/ZljhPiLEM2gqB4bJgVNYvgqKPhTfNsoWlsONpjWwdS
	 T0+gWW8CDoSo+qD5OSE7NbuOc3SXdnBQrOoZd92mCxrCaYmjBSffvVydtJaIgt/fYD
	 pwD24D76iZ+XXUX4sE6g2IDBZxVGoT8ml9SptKfceQpzZ8YX4rk+qSdPgmuYzzawAt
	 Eji1kTsjokpo641VRi8RT7J0tnTj4QFdXNWiCLgUPcNzC5ATkj1wt2Is/7a2ABdckj
	 cyzuHr+mkEOaw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Danilo Krummrich
 <dakr@kernel.org>, Matthew Wilcox <willy@infradead.org>, Tamir Duberstein
 <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Trevor Gross <tmgross@umich.edu>, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, Alice Ryhl
 <aliceryhl@google.com>
Subject: Re: [PATCH v2 0/2] Take ARCH_KMALLOC_MINALIGN into account for
 build-time XArray check
In-Reply-To: <20250811-align-min-allocator-v2-0-3386cc94f4fc@google.com>
References: <pR7yUSHMm_04sw7FqBeN5OaFASLq1MTrX5ojLG2yZx9IXByhp6Lyf1dSzUB3tArhQZoxOYITWVixYBaM_mZLyQ==@protonmail.internalid>
 <20250811-align-min-allocator-v2-0-3386cc94f4fc@google.com>
Date: Mon, 11 Aug 2025 15:38:20 +0200
Message-ID: <87ldnqf06r.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: bre151sh7j7dq4oxdeew3a6mnq5hejj7
X-Rspam-User: 
X-Rspamd-Queue-Id: B282340006
X-Rspamd-Server: rspam01
X-HE-Tag: 1754919509-827563
X-HE-Meta: U2FsdGVkX19oJUWySpOXenvAiaJ3lWgHfmoPDmhCfqF12QFdPUHXNGD9x2SjrmSIDQIYM7+I7xx0+9K+DON8aYWwf6TB9pwsR9r9jacPUvd9hQAOQhdIKnTfFqw9m0u8TZFKpj0y3TB8QdjniCwntq0/A9qOhZdaEJ+4XJ20gQ06kmQcZAKpsirWlH//m8XtnObUbObtcBcPG3+HXKAhVLDnpi/baL7XeYzL2MmOd3MZTaSrlC4xRXD9oxfL96nwWu0jdWGc2qWWVMFIlY8SOki7Tvd1J5JKi//t2n9XR190iDOeX1oBieFuuoCCxIK5haawRAPTFIiCr7yDHJasXBQhDYtj1slttyb2IHHn7/ZLIfbO/urm47AQMUOvas4fFNspDlOVApSKFA+VKTg9Edj7NCS8YGNMreh2aKF/SwNQjR7+NC8G8EffFNxAVMaUx6H1nEvNfwsiA6CK5jMqWKLkEm+TtAa5ZroJThatZJu8lbh3BPF//aYcjMD31FEh/u9VTcqGO9ip3xuwhRNZ/7agBNGmzb5ztkjTwyOcNPrO5kqWaGVEGhnr+NlRZd9M6qIMPpEUbr02i7Vj631iY+JGTjcS1htLI51Hzy9NMZWzYEARKi8TTXrlPzs9MWkuNQdVGAg5iAQwBRNj5hTrv+Eppo27dwWXvc24T5F4T2WDB1TJCofFekfQdOJoDdkPQ/ZPMIDO1XUslauOtduLQAjyaT6ZSpYBmhhDiv0xtJ/oHpxgeDv4KHgJ4qDD6W0Bp8GuQeRkn7A9s1kkuMg94+Tx03VnV9AYcufJOd6+Mk6bX4bCpBzRZ5NxUBxynMJU+BNa1ZB3AGtWTnz/zjZ40E0wRz4TYscjnTCuIbI/uE4lYke9YAOb5qN3IBcYxLr6lWFtqSJyWKIJjPQSCJ7FO7u4/5HCLRQh2G9KWRtmURhwgscqy+wBErqTahFpIwuaB/LQd8Wgzqqlhyr0EFy
 t5eBdjYi
 cFdRwQeNOCw9Qyvi2hPGj46mthjP66lcPuwKdX0g0cKy/Sfkd+94Y+vJfczpkmcHYfrosE3Jsg3G8EN88PSwfMB/9VK9WjDtrGPXt1PQlPicn2QxCS5ntyZfddXiExZqYaGWfQKYGqXcj0+F0v8PDqtrvz6Pae5DXuz9a6fEHmtt6/vAmCsGp96JdCLhlcn82YsViKavHpTuPlH1rKpYgF73Uj4aicrMxWiuTJG9uxUoh9SNDp22JSQPGlMt4rJWI7B1tr3jHL9I0waJ5HI/zouOlExj+Nk8rwDMmpbzpJ5JQP90Npc0AhXrG4UwzXQbhRR/NllGTwf/CETAbOkcF0TOtTGu42OUv+ORvY6+akR46JikaCJik5/rY6ZgDUPfTChrr66+bZkJgrvyss4K4BzCykQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Alice Ryhl" <aliceryhl@google.com> writes:

> The Rust bindings for XArray include a build-time check to ensure that
> you can only use the XArray with pointers that are 4-byte aligned.
> Because of that, there is currently a build failure if you attempt to
> create an XArray<KBox<T>> where T is a 1-byte or 2-byte aligned type.
> However, this error is incorrect as KBox<_> is guaranteed to be a
> pointer that comes from kmalloc, and kmalloc always produces pointers
> that are at least 4-byte aligned.
>
> To fix this, we augment the compile-time logic that computes the
> alignment of KBox<_> to take the minimum alignment of its allocator into
> account.
>
> Intended to land through alloc-next under the RUST [ALLOC] entry.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>


Best regards,
Andreas Hindborg




