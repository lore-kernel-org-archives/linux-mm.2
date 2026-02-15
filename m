Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69E13E63F2D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E430D6B00F6; Sun, 15 Feb 2026 18:51:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0D366B00FA; Sun, 15 Feb 2026 18:51:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18DF6B00FB; Sun, 15 Feb 2026 18:51:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 245996B00F6
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:51:09 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21F4913C05A
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:59 +0000 (UTC)
X-FDA: 84448318878.11.082D856
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8B9A480002
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:42:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ejuvDRaa;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771198977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UkemEaFq2inK5nLl4SnwHV8+C7z6/pf+J7PYTg9oIXA=;
	b=YnLk3/liOgNyTAB/JO97MDaP0DEgY73Sovs8bbhP5HSU/EK5WP9/3CsG0aoo0p4HpgV9SU
	c1ZpeWor8B2/f6t/6i5ptgU6L9HrRMhCYdpAieYjMAzGg9kxOvCfPnCcctwqDttkWHwK64
	h3A5Qt5IHyoYJTrYYEOBPohxe1h7vr8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ejuvDRaa;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771198977; a=rsa-sha256;
	cv=none;
	b=mZACfroaHgYLBctRbRe8yjjRbezjH5OMmdV/aDFeqFVmTP7jwkfIiDUQCpdHa5QVr4qekv
	mT8Q905/6eUZ3+qJdIGOPD6i5NFFM+snnBmSzI4lX1a1+YRBMCoFMN6/OfB7FzEP+N7tyG
	cbPq7ewGmqB+lyN5T4neZexOt5H68p0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 24FE06013E;
	Sun, 15 Feb 2026 23:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012C0C4CEF7;
	Sun, 15 Feb 2026 23:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771198976;
	bh=qqC9HrMhIT+xHKTN/Q9QcHdlf8LN/HZZRbgxc5py8h4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ejuvDRaa8jlRG4OYjh/w0lHsa7NJToZdvYJokX3+FlwRfAo4sNnRcHXEhYWJBTceM
	 anhIJkGGeoXIvityw2DZZHlwspdKVMowAw5nnw7TmibRLSZjL07ItMbwIhENT1zK0h
	 rptOd8bNesUbq4UjshVGWqG2wcNtcMdNSKnOaXxz78zyS07+KjzWxRZcBOdaYTrcwH
	 Y7L+HJcR+V/gQFguUApHVXd0UUBrjvIn+Q5zxtoV5pGF4I7/zZuUdjVKNfzb1chq9w
	 YDfgbsCcLupQ1v2XItMEpwKLmW9454EhnY8ObteRmvdf5qBk8siRvBVS7bt/1W5434
	 6gHeZVOsgVVUw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary
 Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] rust: page: add method to copy data between safe pages
In-Reply-To: <CANiq72kovxkiF1Kj66yVyQYKx1OijjtTGB6UN5M35th57UFFeQ@mail.gmail.com>
References: <20260215-page-additions-v1-0-4827790a9bc4@kernel.org>
 <20260215-page-additions-v1-2-4827790a9bc4@kernel.org>
 <g4ihY-XQwSZ3ysINoU0v3jFzzJG7Uzonq0b6C-EYEYDx4pbJWHHJ1hYmQsmGATIDzexHv6NFea8YNikY6zXq6w==@protonmail.internalid>
 <CANiq72kovxkiF1Kj66yVyQYKx1OijjtTGB6UN5M35th57UFFeQ@mail.gmail.com>
Date: Mon, 16 Feb 2026 00:40:21 +0100
Message-ID: <87ldgteftm.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8B9A480002
X-Stat-Signature: zdd366wnh83k7rpo8nru61mkkuatbkfn
X-Rspam-User: 
X-HE-Tag: 1771198977-570168
X-HE-Meta: U2FsdGVkX19Zz4MNf+5y9tWBc16xX1nfn37YbVLB9zvMNGaBRRQvk4yo4yJbpZZ2G1bzWCWMkOAU4+be0cCVCr4+O4Mmxpd9hVRo9E9f2qsm+cTb83/WIzYK2NfAK2A+CQmKj/64RxyYqWTOflxbrlx8Yg1aFgPxnXwsEo04Vb6fG2c4EZOAom3eunyLqEdcH9DrtT5Akmvt7XBjzgh2WEHEzizwjRXUIdsPaVn0I8AgvWDBrB7sTdbgCGSP/s/5MKbasBvCrVniG/HXweVg3VBt++bLHotH6hyi0qu69aSGp5uB4mR4rdyve82B0i+dFQAWCtt4/vUmkssu9RdRilipQJwll+FqCWKqbiHLbe7caeaIAr6zQcFKkj5SxzsSLffhyWEXOGbFiU4dlGjRMn1nXePR8BsRCy+CELUKE7Tv1enbfIZmK0BjqU4/WC9296YolAriB3TR//YM6S2wThPY9TM+l0hoCkMv2iMBAnxXqKDgJbnX0+GXEIxJW7MRiHV3i+WIXRRiFwk537UhZ3wdm3dTYIsJ2/C0M1oH+hWTFuUnuXL5ySqCPaaqdxDZ4zT5aPIjjWEyG65Wae5r+X6mB43z+guDJ3r5ZuIqXxmZPCADjKcmvVhiMirNZYhbJnCaPA0w1Ijs0L+z99t8BTfJErY7ZBRXYSFpBaTpGU6imYJIbIjphy/M4D/v1ti2sKrlyNfhixCwdST7FJNvmtVCE+PUDdvVoH85Z+Q554995M5GL0DIOiwdAye4o/yF7tOvfv+COMkSLqPQ2hXqKbRk9iJXNBtrCD9izPk21zIblo2zIeahSKx+uR53FsepUnQRogwb+qACX+DpSE7XPym/KpZ+LC5ekvO9w66Bkn3w5iPmLBwK3+JgGNQPahraDLOvw4kT1yAd6aTHgTlloDl/JNYoGsyY2MV8sOOZ1bV2l8UlPIHBSjIL4KZSLWc5zaBX397/0ehvtG1PNNV
 H5tyTenW
 oazMXW5qV3lOW5qwIe8gqgr62Gh3RU2MBVgkNf3onVfROvg//DTiPuVSXevzrtuChb+kb3+3VgWDQ2SMkYZPdkCW/UQc5qj7lIxEiqr+awE4vE250XLF+gIdH0USwp4fxf1zfeitDBPw38tfTetqWx7CVYO355m5jieWlYHG+vmdL0KwMQ2+wHyTaitF9lIUSgtnvZ8Yv76rKbf2ap/4gfqPqlYudzUICds3hrSS5Chn8/8fQZGOy00vXE8TcEAp3PfLoue8WnLkolNUdbMOGUOHupyrV2QbKU8gwfTAtnYFVNra32KeB/xqIRgScCTJYHL8idgVnwVXo03k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com> writes:

> On Sun, Feb 15, 2026 at 9:04=E2=80=AFPM Andreas Hindborg <a.hindborg@kern=
el.org> wrote:
>>
>> +    /// Copies data from this page to another page at the specified off=
set.
>> +    ///
>> +    /// # Arguments
>> +    ///
>> +    /// - `dst` - The destination page to copy data to.
>> +    /// - `offset` - The byte offset within both pages where copying st=
arts.
>> +    /// - `len` - The number of bytes to copy.
>
> We generally try to avoid this kind of argument-by-argument docs
> unless they are really needed.

Why?

>
> For instance, would this suffice?
>
>   /// Copies `len` bytes from this page to another one at the
> specified byte offset.
>   ///
>   /// Copying starts within both pages at the same offset.
>
>> +    /// ```
>> +    /// # use kernel::page::SafePage;
>> +    /// # use kernel::alloc::flags::GFP_KERNEL;
>> +    /// let mut src_page =3D SafePage::alloc_page(GFP_KERNEL)?;
>> +    /// let mut dst_page =3D SafePage::alloc_page(GFP_KERNEL)?;
>> +    /// src_page.copy_to_page(dst_page.get_pin_mut(), 0, 1024)?;
>> +    /// # Ok::<(), kernel::error::Error>(())
>> +    /// ```
>
> Could we show some error cases?
>
> In addition, why could the test fail here? i.e. if you use `?` in the
> "main line", then it means this could fail for reasons outside the
> test. If it cannot, please assert it instead.
>
> Also, couldn't you assert that some bytes were copied as expected?
> Could you show an error case with e.g. an out of bounds case?

I can demo an out of bounds error, sure.

>
>> +            // - By type invariant and existence of shared reference, t=
here are no other writes to
>> +            //   `src` during this call.
>
> If you use the type invariant here that you promise not to break
> above, isn't it circular logic? Why someone couldn't have another
> `&self` and call this?

Writes require a mutable reference. There cannot be a mutable reference
while we have a shared reference.


Best regards,
Andreas Hindborg




