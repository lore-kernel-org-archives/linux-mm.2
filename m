Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA14CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 10:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11FE16B00E7; Tue, 19 Aug 2025 06:49:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D0F96B00E8; Tue, 19 Aug 2025 06:49:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00D386B00E9; Tue, 19 Aug 2025 06:49:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E1CAB6B00E7
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:49:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 942E0C0779
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:49:25 +0000 (UTC)
X-FDA: 83793185490.27.FC5F164
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E4ED414000A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:49:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hiwspCeh;
	spf=pass (imf26.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755600564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4C461uqkBRTf/VoyeMHeL/ZxhPm9u8aTbcJgO4Mzv+8=;
	b=6FOizr6X8bqKq1PHBeL2zE4As6FuSoChcQstZLFSDTjkZNjs3IVFEeuSIRAK11tyRT7r6b
	QZEfcdn2ZFVQim1xkd1qz1rpeQyNMCxQzD6lhtlUZPnEy19X1LdtU5+HnQRC3pgXxIWLGh
	GKBgdVLEisd+HG7MmvwsBrhs1Ea/UIo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755600564; a=rsa-sha256;
	cv=none;
	b=QE7+6jqbjpULJtBiVSWGaXlnbbYjU4JyI9dDEoqPOWwk+jSVG6TeTUX+UksCK4F6Is7fvG
	08SU65HORm/cn7qfqm0DeIlATeTt2KXPJW/FFJ1CIJ9+zqwcVsSYH1ZacmglfrVoYjKsI+
	DNJvtVyhsvVYNtsO0wARz3UdRqVZoBs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hiwspCeh;
	spf=pass (imf26.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DD33343241;
	Tue, 19 Aug 2025 10:49:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEADEC4CEF1;
	Tue, 19 Aug 2025 10:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755600562;
	bh=4C461uqkBRTf/VoyeMHeL/ZxhPm9u8aTbcJgO4Mzv+8=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=hiwspCeh3vVliHN8vq/VHlFU49sh+i7/SjlHask+7oRb2UHt6bWFYGsnesOlpELXh
	 evXzZ4ZNG/1FXotVis6Swa4MkTFtcqLFe2hjp5MBeZ4MN4mDRVCxVm8NPWl7R3Ru3f
	 V/DwH+Ckea9ZBgkXXaw9+Uv0EgIaEjBP6mb0pKE1ZQDWe83wXUwQzW4svCWdrZWhaF
	 b65yJj9Ao4zLmj1kMyO7OoRh4dZCoWxwnPFvEBuU1KU9z2EgcRyGvRZ5uKBJpVzwY8
	 4kQ8Y6pQqVqK9iQfxwkgtSQSrhnmyTFzDIgypz6vBqyRIXpaGOU/vl74AzW8w9aYzI
	 Fd84CIuDMq2uA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 19 Aug 2025 12:49:18 +0200
Message-Id: <DC6CGIFANVZ3.2J04CI984KNM0@kernel.org>
Subject: Re: [PATCH v2 1/5] maple_tree: remove lockdep_map_p typedef
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Andrew Ballance"
 <andrewjballance@gmail.com>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary
 Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Andreas
 Hindborg" <a.hindborg@kernel.org>, "Trevor Gross" <tmgross@umich.edu>,
 <linux-kernel@vger.kernel.org>, <maple-tree@lists.infradead.org>,
 <rust-for-linux@vger.kernel.org>, <linux-mm@kvack.org>
To: "Alice Ryhl" <aliceryhl@google.com>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
 <20250819-maple-tree-v2-1-229b48657bab@google.com>
In-Reply-To: <20250819-maple-tree-v2-1-229b48657bab@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E4ED414000A
X-Stat-Signature: h5udzh5kwitwc5yxe11o9xz7duikfm9t
X-Rspam-User: 
X-HE-Tag: 1755600563-15280
X-HE-Meta: U2FsdGVkX18p1U7mtX9UrONGI3r8wHEGkSUHmjqlzvyMvlMf3M4yXgZSSP1zqennODZ6djuHmDRFmEAocceBLUttbjoOJ6Yg1TLHGL0CNw/ZTNc4gt/jycqY1v/rMl45hT2ENcLGG8wqgrB9e2HkOzAU9jbO+MLxqpFcPv9gROYCDMSIYuQSBwYD/hAW4VzMKs+cGtaK7ds0BLf91i5ax7k6U1JMPC/4R0dHhcqJIVx59rYa1dcxoT5aJzyNts7qU68L6MaeHpH4IWWI0bZ6q2LjF+DIt2SOKLNtEVXKOuBkovB9czYxZSqCVZHudETiF7QQc25OqzMWABg6sxBTSL/cQMWHSU6b1lkL3UGLU396TVeWRNKG+s8yRkGGFV50vh5bOLt1a7eOEvhX1bteV1b7L+ZehQTfBxNIbceqdPLXQaAXQQGAzcscnpg0HqBDdg+ne2de1fYq7Zt0oYimlL6WtqNF54JJ8W3ejlCwDOLbmmXzok1p1zRr0ta+f9pcAWCJN3oe29n+bEbJLYwaidNh/Xf5f47lqqrPokxfX9+B6UATKVmLgStVpaBzNonAMe2Es0wkGNQ8GOxY5Fz5qaMNhvOr+dkb1J1iVnX0HQzHpVyEFsrKFby5WE7CMafBHEGYgwrFKYCZM3C0031qgbmqGYyTncMqV/7r5KdMFQJHEk+m2GLK+aZpEZzqcsF0ybZ3JmRdhKv8j4Ao39l1yE2wzy+KcNnnmf3ME/wa8hcWRj4hl/98NoyjVXEwPzREAVLXhhjYyD2TCRruzTqcHjk7rKv3dtXY5EgW4R++HMIXLDJI/XYh+Q/65IGf4oKIUhVUVZXknoCk3jmNgSNXx6FXNr1sTLjJpTkslMuPBMGAUWvS2u01EoEwut7CHxebKUdCId1zdIRd6P6hHH1Jn3CNfxPS1EJj37VvxemFnqBFB8LYhSJi4xm/mxTY8XmmTSVn/Kpf0APcud13i0O
 lcz5fkk7
 SnwTRHTUkNwAzaM5lbiBnv6n+eqjemSY1sWqhpb3MivAqOMBqy/XSy3xJ86BzJKtLY5aul1tyvVVK+RzzBPYxCHRj+yf8vEVRPctnpcODpokhxB7VEnIBY8R8hPT3tTmnXep31w1X6d8T88FgUNnHpSqwsAeAAVbXqY3uZwagg1ybXuoOxGzv4e86EAUheSmMDKgoSkmU/TOirg9MJuaVkOxGC4hKvkdJA0Kz6eaIS5KvlJiTXSz7gIow/x+AZJaItkZVkpxB7ifW7LlJ/2iPRDpfex8+LDe/5WRCZBSSneKNiS3ZZuanDmqvBLrr/sxjTvZ/Vs8uWY71XvAumvY2GczNnNw2Ic+GVRcC/bxTERYOaEhj5dAAl59fi9acPaH7YJ9e34DdO6sFb9axH1qy4o+1SXmtUXzxAvDBMGv//RXuUTJGG/SxTiNDZtMQ5gVZ1PTJqGpik33YkpEjSQ9iWAOfF5HB0O4HnR7K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 19, 2025 at 12:34 PM CEST, Alice Ryhl wrote:
> Having the ma_external_lock field exist when CONFIG_LOCKDEP=3Dn isn't use=
d
> anywhere, so just get rid of it. This also avoids generating a typedef
> called lockdep_map_p that could overlap with typedefs in other header
> files.
>
> With this change, bindgen will generate better definitions for this
> union, which makes it nicer to use from Rust. This avoids a cast in the
> Rust abstractions for the maple tree, ensuring that Rust's type checker
> will notice at build-time if ma_lock is changed from spinlock_t to
> something else.
>
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>

Reviewed-by: Danilo Krummrich <dakr@kernel.org>

