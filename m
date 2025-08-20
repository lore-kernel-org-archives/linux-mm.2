Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14A6CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 23:25:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0858E0031; Wed, 20 Aug 2025 19:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 688218E002F; Wed, 20 Aug 2025 19:25:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C5028E0031; Wed, 20 Aug 2025 19:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7A68E002F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:25:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D30B51A01B3
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:25:22 +0000 (UTC)
X-FDA: 83798719284.13.9A472FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0B99140010
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:25:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="xp/Kg4l+";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755732321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uqgixCMWfTdAL5HPvS0J0wS3VY/Xi1IqTGlHkWpZt14=;
	b=OVnLGPWt6m0V9IztRHjnr35LeaiRHST6XGL3GxxdhDZjKJRCbCpm+Wa58kPQNnlP0+yX4Y
	q+Eeiumoqf098oJ08VwW74/KGyMXRpTAi1pgmwir96syI4eEaCybYQAMQY4bjHI6HFxhEn
	SgBPJVS5u/FCRGqeOaLWgqnFBOVm44M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="xp/Kg4l+";
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755732321; a=rsa-sha256;
	cv=none;
	b=DcRMYjVg5+v1leEu/VQfNLk5SnhHH2Tiuu548EE6YQsIIxCH1X6cWHKkwxXZGbS4uziup9
	irhzdyvQMixU4CCyVhsiej9zMBQthMcZ5VrvGeoTVH2zPrt5GoPJBKTOcjRFEsNs8Js2YX
	/eG7L/umx1q0cfo5sca+Ero5JS3Ynfk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 957894185A;
	Wed, 20 Aug 2025 23:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61FCC4CEE7;
	Wed, 20 Aug 2025 23:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755732319;
	bh=i6WrTgez3RWzxsAhDu16ux8CIUtq8CDIDqrNRvCflSk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xp/Kg4l+YkggT2CnSvl09KsaqWZOIBHk3besNL8+S4+rqVNqDnJPuynHQHWipsJ/s
	 fqyM1+Md598/f0gDLKHsJaL1SrgTXUTSRFTusvTW/90L39iLxaV5jBi7REbrsDVBr9
	 3kgPxigkF2E7j/0JFCZ0qtLyvcLBKZQlw5dZ5UYw=
Date: Wed, 20 Aug 2025 16:25:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Shankari Anand <shankari.ak0208@gmail.com>, Miguel Ojeda
 <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?UTF-8?B?QmrDtnJu?=
 Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>
Subject: Re: [PATCH 3/7] rust: mm: update ARef and AlwaysRefCounted imports
 from sync::aref
Message-Id: <20250820162518.7dd218ef331618bea11e9c2b@linux-foundation.org>
In-Reply-To: <CAH5fLgiUfZG4e0k6ajkkKo+iaidWHu4dTRfBbgm4Y_CQPGLHpg@mail.gmail.com>
References: <20250716091158.812860-1-shankari.ak0208@gmail.com>
	<CAH5fLgiUfZG4e0k6ajkkKo+iaidWHu4dTRfBbgm4Y_CQPGLHpg@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0B99140010
X-Stat-Signature: h41xgucsetbe88mfje3eic7tspobfq8c
X-Rspam-User: 
X-HE-Tag: 1755732320-922295
X-HE-Meta: U2FsdGVkX18SyOifR+wSSM9b8qHVEYARQbKl4qF9W42WJdZJhZH0LdM53k3v+rwFBbVlZIlm8h8YZ1sU+iPoiX+ZaYoT4NzqPHy5gzikxSsiGxCLNWusKtSOMpurUKWZErl5Ki/V/cfQFvh3ZqAUpk34DBn3v3jRTL5RbPl3Pp3P/JFrK8+MHM7LwnVvKuCgDqNQVXfKHHp94Q1CDBM2SFOBRDbu19V4g9nhB/FQiJBurpavZ8dtN1TbeYGrJN0JgNev05jd09DBQg5NY8L0yUVab2UpBRV5Vjb6MnlSByya8VL8vac9LeU/qrgCYtJlG3nD7lXjq4Wp0LULLYgt9+mBNViFKVQeCh556HTFThShNxC9S8o/OaC9aPJ4uU0P3MXiDLQefFHRKEor2o1rKzzti7bap1B6F8FZCcAZ82Y/ONBPxfmxu09dG7LmvcMe/TOsE1+6G3n2P0TY+OE+xsxZIGkDi9D6jm+BvlZFyUgEBZHAe6qCD2y7kmoowPhw0YQR7AqrcL9bie88DtlJ+jmk2medPL8YNrtRjl+U98e5jxkJG3W0hcYlQrAaEuYGIefS0Va9CW8fC1gveckVcdwtP2mbayAut5oHDyMEXdf0UUhh0xuGnDiXHlDqBhcbJH6HG2fQsyUWTwHe/o0lQYk3grrlsaLmDFCKTENj4xdOoYuNfzkSAmHLF24h4L7jOwZvpg9i0UoG2hNxhlo3j8lBLifs2W/OzyPRXzOvpca/nCnQYf0cbzvMVO6zMEE5YsDuqnQvpn275Lx8Z6x5Psy8Fb8PpastUodfZ+HBtQ0YbZJKq6u4lI/z1jJTxxmQNwDuo2op5a+4Ax44d8098QOCjOTmt8SNqQYPMnaokCGNdoCauCcZsE7UMYRAgFO0lUPN8Li0zUTcDtN17+OZsHsGyhiXMb/U8e9D8Ks59V5lNeVkWCcO8nfE0v2r0PzNkBQHndQxjulpv87cVt2
 2CVan5Ep
 PMB65VrLkYj9BUkbWXcVR9h2+OTYfFD3Pn8kUbQqFpi2SrLJDP8awJKe7aPHh0fdy6OEuSoPFVTvkzbTxyOL6AeQwlnMURRWZXwpOyt3tx37S9pYfrdaNntal/ah65LfkLpOHGydZjB1nbl1az8zcyehfvdg3nyMXYsWHx0lHAgRLr6n5yemAH0nihfbMoKSQzJmRdmffRFCI1iIWbbv66BO7TSyIE1KAjGsN25qx0UB9l8qNVXRc0+MaEaZs9eReYgVnBqzvalJQhBz9W9uh09p98FmMJsAumViGu833ion+mSycIEn+gZ1kEDsefdiL1bsUraFRcuzXmH9Xz8uFA2ittlkf7UV9x4N0SvxWm340a1BmQf1I8m1J1UcmzJIM2W4kKcWskDlhRvtyhdmgPKTsMrRsclWXctFdGlMwxvI8SkHmZshh4Cf82Bu9E7ncD4djs19DxovlSjRfGZ4hNmzsV4SvbpqvfPng/td31hM8GDoVkwk+lXtw7g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 Aug 2025 15:51:31 +0200 Alice Ryhl <aliceryhl@google.com> wrote:

> On Wed, Jul 16, 2025 at 11:16 AM Shankari Anand
> <shankari.ak0208@gmail.com> wrote:
> >
> > Update call sites in the mm subsystem to import `ARef` and
> > `AlwaysRefCounted` from `sync::aref` instead of `types`.
> >
> > This aligns with the ongoing effort to move `ARef` and
> > `AlwaysRefCounted` to sync.
> >
> > Suggested-by: Benno Lossin <lossin@kernel.org>
> > Link: https://github.com/Rust-for-Linux/linux/issues/1173
> > Signed-off-by: Shankari Anand <shankari.ak0208@gmail.com>
> 
> Andrew, would you be able to pick up this patch? Thanks!

I prefer not to grab a single patch from the middle of a series, so
please add

	Acked-by: Andrew Morton <akpm@linux-foundation.org>

and merge this alongside the remainder of that series, thanks.

