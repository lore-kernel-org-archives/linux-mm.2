Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA2E8E63F1D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 22:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AFA26B0005; Sun, 15 Feb 2026 17:33:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95B646B0088; Sun, 15 Feb 2026 17:33:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A106B0089; Sun, 15 Feb 2026 17:33:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2946B0005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 17:33:34 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5419C21F6
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 22:33:23 +0000 (UTC)
X-FDA: 84448143486.05.257372D
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id E6B5C4000A
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 22:33:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HuRXyEMh;
	spf=pass (imf04.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771194802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZ7+qUdkTyM+y7B0PTABlfJWNoucM7Ep8elG9lwBdIM=;
	b=QbBFkt+trFanaxW4Dz+TyRLJjn+/RncXBAcy52CyAkE6/90QiAKhBPujIWVftn3y0OgGaL
	ECA3fwGIvMYidsYhVDX8OX0nTz4llA9pl3Kxm38K/uFvfTT1faXmmsuPRGb7Ic4Q/fcAtf
	uYajXhpccBTfssUqHuW29S33WDVZunQ=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HuRXyEMh;
	spf=pass (imf04.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 74.125.82.172 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771194802; a=rsa-sha256;
	cv=pass;
	b=f0ob+COO6R0FGYyULGwU3WaGKhjMlJd62VDHqPRB3zwl6hrdrxua76o9xnBPvbRA82qxdq
	eguR4sAh4PI6eXG9J8x87p8sL5ceE87cM85fTcx/ImPKoTZjyswnElPYGktJIeyQAiIGLQ
	EjHnu5T+SFZU3xSoreVjO63PUHZV8Ro=
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-2b866f98574so177044eec.0
        for <linux-mm@kvack.org>; Sun, 15 Feb 2026 14:33:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771194801; cv=none;
        d=google.com; s=arc-20240605;
        b=at3XW4FYh4DczUbi9S5f29wVoscIfSi5eeLqbRFZ2bJxRPnMfHqcOY6wD/JZgy4tV8
         YAOWQZ6rYr7pprr47LNdoBuvWktk0U2LQGy4BujGj5UapMNM0NtW2w4T2W4+7uW0/EQ2
         260Vmopw9L2A6gKEJgV9jEIoKlxpuyglBmXJaPENcQniCL1Igqmw12J8qq4k1kMxZzoe
         ZOJorAZim8By8NkHg7jE6Se4oVlLOy9Bpy0NVcAm1IZS1Jd9p34YTM7EL/3Z9o06LTh4
         NUU9wDETIxVKxTvsnIfEjdCi9DyGUBZHPF7DgTREBKV4xfrbNrkKW6S0zcdz1nR6h6fL
         Ey1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JZ7+qUdkTyM+y7B0PTABlfJWNoucM7Ep8elG9lwBdIM=;
        fh=Wdea8Y0K4Bufhrx2+yLq8hL5B6vNLvMLbWBRusjETdo=;
        b=CH+NyEppTQDQPlRl+goy9AGw4u3x1ptpmORyLoj9yKyOU9l6HFHUyfgBJVANBIIoeN
         alUeCs8rKZViX8aG9RVbBBjRU6wN1WOBsjjkZsXCcUX2L2vfnNjNvJul9Llfd5Br3ybE
         42cx0xqhagyXehEEaqEwBQlLhlZSouLmAj2ihy4pTQ6UpF1fd89QgsKI9Ed9LXX2kysa
         W4g6VLNnqB1DtbrFogBk0K2EMtEY+fkVMTn9yzO4g5iXTkMh9Sl8dKU4Wy7fcGBU1ZUb
         /rDxcC/g2QqCV9YTOGR/HeY8I9Bc8EsX9ByXCUILi8OjhHOfAf5/xZ0W0inmFobocPtf
         LnLA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771194801; x=1771799601; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JZ7+qUdkTyM+y7B0PTABlfJWNoucM7Ep8elG9lwBdIM=;
        b=HuRXyEMhAfb0uBZB1BjIQtAEuPj+g5eHvgti9Yc/vZVLrBssmX2pzQVbQI4YZULvQX
         PSnEet5OjW5EzCdveZaYzcXMRhBEa3uk3kDISFFJSrt+gTQQA8S1u/HyZ4NzhAW2xF5f
         wj7whp98E+QEQnwphmoOK4ZRVgQXlDuapgKNzn9n+7LR69vY9egstnZCNLKz6lxgTCgT
         5b71qw/KZvnVxoLZevQVHCQ1xrW6EK953/TEXmOH+iRQ+/BWrLYCGk9lEgVvD1vVfaPE
         Tqhfs52V0QEtzMw2eZtVKr5+uHeYAylubxWTmUXKuVIAjEp+Xjgl1Ye8OdohdVUI+x4s
         ZsLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771194801; x=1771799601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JZ7+qUdkTyM+y7B0PTABlfJWNoucM7Ep8elG9lwBdIM=;
        b=LDqFJOMNgN9lzLp3XSA6QQDILV+TiJqEI8gkeyAXEtpeaWXaJaOPmB0d2FeEzfDuY+
         BFrx60hQYo6cjccXaAekp+OkQ+q/iFXByXIM3BqLLwuMbpqV0N6acQbtKRxYnBvMeaU/
         jQ/QO+ZxMUSd+vUJtwj9ns26OaJttOKTqzq5enHZ+PxTon3peOScpTeQb31FWIPZhnSi
         prtuux4Tt+7roLz39cD42HLLyvFthoK3ETCwdlORAPufnOojbYt8xT9ntRIZdOoZKGD9
         PCxkR1M64Jyscs4ID8bDUhp9L3cDLDStpQhZHL99Cdlwp+jBMLRVLhaS8Cup71/bZ94f
         6JwQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/l8rY99RYsHc2ixvs+TakoKcV7DGUBW9JcDYZaigxO0PqfYoOXjDIJWaiNBoM+As/wTCj0xgbGA==@kvack.org
X-Gm-Message-State: AOJu0YyIAJI/mH9ilz49Gwq2sD68WXJcQCJ9V3+4lnAQhygAEchitrKu
	xhlFAlZErXHqo77LyH1qxhc5+YN8351OMC6Le/LaF/gXDrK52tW1JY8dZpH6hnZSAjk8vEMKIWP
	gGb/vVhJurQ2LP2DjDTIJilZumEcuVGg=
X-Gm-Gg: AZuq6aLcaE2cGxLDkW2LvgQHu2zO9JRGqYs6WHAxlrAKXBjFHtjJc4sLv7G5/y3+OmK
	1LD68jMlL2xOtft3/f3ewHoQEa+WLRB+bQC1Vac8MTpe/eOEKrNtCBM0x/Ut/Gv+sa9ELmbSxQ2
	SoJm8wizG+y9vM0hhol08oN9qWecpFl9lxW3/x6gE6eBNrq1KcgLSuGVjsmeqlpKX5Z+dFJ1Lqc
	atFtHOwbFCr04YwsisMIKya6vV6qWkvQiWVMq93kekvN5HRYsaKrDDt8xxB8Qy+ncCE5n2p/Zc/
	Tu0jn7WI3WLXOAvZQThNePHX9sMA561EXW68Zwsw4ea0i3GqB8v7J2dBkpbY3dHMw9dCYes7n8E
	wLRezX+z+a7ubdGNmDJXMeMka
X-Received: by 2002:a05:7300:ef82:b0:2ba:7013:2b94 with SMTP id
 5a478bee46e88-2baba0d9f2amr2278586eec.4.1771194800540; Sun, 15 Feb 2026
 14:33:20 -0800 (PST)
MIME-Version: 1.0
References: <20260215-page-additions-v1-0-4827790a9bc4@kernel.org> <20260215-page-additions-v1-2-4827790a9bc4@kernel.org>
In-Reply-To: <20260215-page-additions-v1-2-4827790a9bc4@kernel.org>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Sun, 15 Feb 2026 23:33:08 +0100
X-Gm-Features: AaiRm52C4W01igr5c3XSj8GHXnZngfEE6Hme2FtEbEKQTchO0EV_WW3H4OO5KYo
Message-ID: <CANiq72kovxkiF1Kj66yVyQYKx1OijjtTGB6UN5M35th57UFFeQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] rust: page: add method to copy data between safe pages
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: 1ymn9f8w9dh1x6c6sorx58x4kdkhobth
X-Rspam-User: 
X-Rspamd-Queue-Id: E6B5C4000A
X-HE-Tag: 1771194801-827622
X-HE-Meta: U2FsdGVkX18GzYWfVqgFxNrxBQ5JpXHh3hgnYOACKJZ0MnAE5Rz0nvAP5arzWF+jxTsCVmM1UQjw6IUrSsh8YR8nMl82Gu04utqAjp96TY0FaRu9nHHNGYehAN1BDjYxsfd0oDJLZxp3aliVQM+pvs9ABct9cuSf5sXcygaXjPlTNugUL09Zlc5826ymH97NPS0tbfHTNMjc8AystalG25+iLg0q4pbn4aDkff1qwYf2XCt0YqraCv2SLNSRRU1KcmdkqVBQ/3jZKiYFt1O4WouBx8SKBv7H1o+039OGuCxc7pkWjHLheqX8cVXMW++2pH+KZjvqbQOlM4Fzvnx2PGEKgD5mH3e0h8BdUdYWqe8PtaDJVBmniBPm3IaoKdD25ipxhWh8rbueA6dWDCeknQ7Yqd3lTqWNaa+G/6ODfl8NKh+UKGKi2JZ6SXtFLziLtf0kZ9QLs2gOaAZ88YlwvP4H1Y6TD01Gunty4maM4QPtWML/gge8JgHXwodHuMdKv8M/63HFqCQ1b18wCskVKELQmqdpMwfzsMgzFghpLdv5LHFB0ez3N+NrM9JVpad9bS/n8Mto/VvKWckkV2KhrY1SRMmMpADo8LNQVbNAvZSPwPxOjrc+I4gnkKOkozcDj5Dw0hRTbcbm33PtscA3V1piZy4UtkHW+UL6A9HtKSoXeIyISds+sO86VsiESakz8NDAt9pNyW8NPeQX9apTS/KIWRnRdcAJDWMh3VdSSC5CGnYTwafj/7QxnnF5YUEpIk7o5jbGhNh9DQsMKML+J86TCJIe6Uv/TJN9PvmzG2XeM4pFozIFST7y/y6xIuWCOOaJe9bZPyqH4BYzQYPXW8UOg6ou8+zA1EH4BoItZYY45S0O/8+gi8xrQC9A92yWy4rWAHAb/gijkRFuVraE/LkXP+r2t/KsQlqGIIzISGuUVH6NICBiXEKcuagqIUPKP/mUo8Osj44tEu9oSOH
 Dk2RRMoj
 5+zeFu8mSlHwzDX1XCK/SW/W0yD5tESGK/9ddm6YKGmWixLNAyOz/k3NIl6ZWf9IM9/NjXVZK3/IpfuYfCE6PMA2Sc3EzvSFPOe6akPfAgSX376oaUi559vNhzs+V6FvYpAvLRXOyGIX2PX3MYtKC2bNBteq9HU6S0YJ0cvCiMU5iou56ZFT0/j517GfttBWoIaSBPF4y2uvK4SxtLjb3yY1dkNplMbJvElsiyAT938ktEROfm73ejXAxOl/WryM26FthTRSyVkLyTrDTtW+NU1ChF61Puv9C2jHIn443z/farLZ4+A1HJpQ0n9zuQxpOG0BeJZD76eNANmj6QALXW9cH3hbshTDKZtrkVciAC1fTl1/FQXI4YjNghb7jCAawOu7eNO1w4NrC17asQnJsRVJYLFiL1LmUkp1TtstaEDK+Ig2gVY4e9cJ59VKSGT83B5aNYsm03Xrx7lBpQFaY8L0DYGN6ARYBbmdzIYka9PmejOaBOKYWCL4rH4zTzgsXhv/oySw1rzei3U3xnJ1Zp2tMTxBVLsRwpFA+1nQFOeL26ZVn6VzcyPyszJw24ctqXURDySpy1ewRgl01qCxal4oc0M78wSwa7Zvt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 15, 2026 at 9:04=E2=80=AFPM Andreas Hindborg <a.hindborg@kernel=
.org> wrote:
>
> +    /// Copies data from this page to another page at the specified offs=
et.
> +    ///
> +    /// # Arguments
> +    ///
> +    /// - `dst` - The destination page to copy data to.
> +    /// - `offset` - The byte offset within both pages where copying sta=
rts.
> +    /// - `len` - The number of bytes to copy.

We generally try to avoid this kind of argument-by-argument docs
unless they are really needed.

For instance, would this suffice?

  /// Copies `len` bytes from this page to another one at the
specified byte offset.
  ///
  /// Copying starts within both pages at the same offset.

> +    /// ```
> +    /// # use kernel::page::SafePage;
> +    /// # use kernel::alloc::flags::GFP_KERNEL;
> +    /// let mut src_page =3D SafePage::alloc_page(GFP_KERNEL)?;
> +    /// let mut dst_page =3D SafePage::alloc_page(GFP_KERNEL)?;
> +    /// src_page.copy_to_page(dst_page.get_pin_mut(), 0, 1024)?;
> +    /// # Ok::<(), kernel::error::Error>(())
> +    /// ```

Could we show some error cases?

In addition, why could the test fail here? i.e. if you use `?` in the
"main line", then it means this could fail for reasons outside the
test. If it cannot, please assert it instead.

Also, couldn't you assert that some bytes were copied as expected?
Could you show an error case with e.g. an out of bounds case?

> +            // - By type invariant and existence of shared reference, th=
ere are no other writes to
> +            //   `src` during this call.

If you use the type invariant here that you promise not to break
above, isn't it circular logic? Why someone couldn't have another
`&self` and call this?

Cheers,
Miguel

