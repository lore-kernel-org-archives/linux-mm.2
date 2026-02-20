Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08174C5AD44
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 17:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E36B86B008A; Fri, 20 Feb 2026 12:51:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEA606B0089; Fri, 20 Feb 2026 12:51:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6E26B008A; Fri, 20 Feb 2026 12:51:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B946C6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 12:51:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 698C61C1B6
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 17:51:28 +0000 (UTC)
X-FDA: 84465577056.19.2FD0349
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6FE001C0008
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 17:51:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ogMLxT4f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of tamird@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tamird@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771609886; a=rsa-sha256;
	cv=none;
	b=llviruJwnHeiBckFDlLiD86+YbWSIh4rfI3LLKPT7cc2hBvbEpL1Pmm9HyLafz/0z0AWk8
	cyQfpZKkzLPQC4mwBcdaDZvHV6aG5Ai85Sc7OfAKd+Y5FE0fvO0vX9iBrXK3o06nGL9Vku
	LS80zrY+7kc4gwcinWvV3AGXVPun9lY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ogMLxT4f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of tamird@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tamird@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771609886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A/5T+3TY7ArS6gzq1BN6d/Eog7UejCtV48nvr1/gOY4=;
	b=aDIAwesewzdxk3o9pvrX4MsN6MuDS4gFkjilfBUL44BKHivQ8wPBAQo4P76sVgRKhEEPYs
	LplKA5R++ENiV/efQtOI9ID2oLv1gIPFV82MzE5A5lBxppiVX+uPCF7JB4dvbR9WNaoM0j
	/kvBAi7Lbx8Dr5gMC8wS37zCgbIs3ok=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CFA3445D3
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 17:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F62EC2BCB2
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 17:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771609885;
	bh=LCZsbY0WlkLDQaB+g3+Nolk280ujbFsPA+yQ4pCMsbQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ogMLxT4fZDIGFz9T/q1fVk1xsqCLg7tuOxY0rcVuLkCjEG7zOjZaWVrBOSWJ1QcY+
	 ctyFHL1ed8ZGNkOShwM6jUeq/i5Mr2NSGw/d3iHKbRvDjYN8olL3xDUnjQA/2nIDDa
	 WLlq2vxK1I50F4iJaPRoXU2UzPQmLQJgKY63W/nHdsJ7gKsjs4ZDhTgsiuydRl+mae
	 pXtK0Ng25A6oXSizGr2uz90pVVIQey7vfDZ9AnI9kXcIblN/xyljgOxgBvdOfpYJwL
	 Uv9Q37Hh9G4yDpza8wDS9GWvbl1Ulz9veM8yBxM6CE8V43IQaV6WIwyVyl+uJgpVSA
	 tcIk/S0il7niA==
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-38708180241so19035881fa.1
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:51:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUHMKx6dNckNF3WqKjw6TN5d3Dnis+/oDqyQqyFaByMPQkZaowY+7jeX1bHPhfgd6oKl9mtXs2i8A==@kvack.org
X-Gm-Message-State: AOJu0Yz3QrGWdwIKXncNkYNFJMMMFVn33levzq0CXTpj/lN5nMYyF8CP
	5qf4wC6TSGaxXl3+IqBw0GczsaegSyMvBXGtasoXNpAU4ulAfq/OMIRY7ppM67APokpviCOr2Dd
	gl6gW+QPanBIsDA25IUlnIH4jghFW5LU=
X-Received: by 2002:a2e:be1a:0:b0:383:24fe:4eaf with SMTP id
 38308e7fff4ca-389a5de4d48mr1328121fa.30.1771609883065; Fri, 20 Feb 2026
 09:51:23 -0800 (PST)
MIME-Version: 1.0
References: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
 <20260220-unique-ref-v15-9-893ed86b06cc@kernel.org> <CANiq72myc+tCEHm0WtZspZHWwsSzvesxsmUvk31=GCdUN_zVNA@mail.gmail.com>
In-Reply-To: <CANiq72myc+tCEHm0WtZspZHWwsSzvesxsmUvk31=GCdUN_zVNA@mail.gmail.com>
From: Tamir Duberstein <tamird@kernel.org>
Date: Fri, 20 Feb 2026 12:50:46 -0500
X-Gmail-Original-Message-ID: <CAJ-ks9n2N5fCVdEF-jLsjLhAiyY7HLHA1dbanmxqEj1vuqfuKw@mail.gmail.com>
X-Gm-Features: AaiRm50BHJk8sWqZZGVukWMOtaBDUYkSm_Z-CQij1pvKGbmHOip5UB_YSDsNkM0
Message-ID: <CAJ-ks9n2N5fCVdEF-jLsjLhAiyY7HLHA1dbanmxqEj1vuqfuKw@mail.gmail.com>
Subject: Re: [PATCH v15 9/9] rust: page: add `from_raw()`
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, Benno Lossin <lossin@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Igor Korotin <igor.korotin.linux@gmail.com>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
	Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	=?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: butpgyrp9mcew7s6zzzucgdysn8d5wkr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6FE001C0008
X-HE-Tag: 1771609886-802606
X-HE-Meta: U2FsdGVkX19VL4xAJS8bDjfo34mlyMAPlv6BD5dSg8PJRHN4y4Ic/AnxtaL7EfgEpgJHC+f8l+YPijdXbDd8k885hZah7vY0c23pIBU2BQCIv+bb8L5eh8sKnTqAzg7Znurc3muHbrNiJR4n0Cx6zgNzhzwqVrASe4/CwW6GDQFcnjELMyx/CjklCZrqlKtEjfUEWLICgVIKUxUaXx5haVOS/ZT7M7kUdaquZnwTHlN+hncY2LDQ8zaaGIa9hK2O/XhC3NLsbyE71Zqeo8MHLXwD3Aqbpu8qZDt1a9wWzil/E3hJOtNJwwq3i0BDF3WHnUNoQ3gue0DJIDbHUv1gCO1WKKmtJFj9MjOLC21245ODy/xwccKADe0rbJD9m4WFbiy538/6Al8IGw3FMkrSHt/OxneTax8pmoXgt5krXFBlrWvY+JQ5ei1hrntWIGPa+rEGwlVpDgYMo3rW7QJfUDUsb1QbXp1gaqhue9hQykIpMsePNaf78HTO3e4cmKDrGDvzMJZKtTblwLjmcQdsCCkBPYqlsLWdR2CjNKV0W07E0jIbml/jax1OCJgXB37BiJWEa0x0ybhn/ZyhYvmu+AOxDAdUYd1VM4Cpp2OzOpyWPUzJSw80hsq6WNXAxfXdLjIBWN4aUNUb6wQjwRrbH/oHkPbvcRnfTTyV6fTKJfG6wyUvy82WpTSEkuC3npe2hO5uHZRUuDDNa/o0vY51GurbWilGMwB46kzYFL98407hTWbdZrxLqGwvodebuK2ykDmqjVt39phdy80o8GHiLFA/Fgxb8JMEeZrRToarOggBoxHWB1nXWVl7MKgYu0oFK8+VQIQiFznv6ur1vwUWgHKrnbCDIsHxBMyjLhjVAeVQnpWkfNHxoAKLqa4YQ6E1f5zj3ZH2JvWT4rHr9z9X0dijaIp7S/Ivkrql3WeggB/aZhCR8yKRU9kr5d3jNvEYJDnhztYhQDLMBQ3wLLw
 KclB/T+3
 JJ6yrbZT0tdkjSHZz/Rnw5Kx4nF5LhR/kkZraZl5/YCFsr1n7Rx1GsLZdbqRs63/2XqR6Mu8TomUldnIWAW2OuCtchqNRuMd/ZQLaTKi+kIJZ/KhjWN/7ykLZFFjidUSkHsnbQ8xGGvfkVa8a3jt7SSXtl+nFuazogusmcLluv9plQPUdeZhTSpX5Ev+syUq0XwwAQo5qE4FlWPKp9XhkEFXpCyoOQIsFFt8T30lqkfqC5vEyOFtVChFg5bYmEDAEnAJe758C7rQ2valLeGkQnfyH8FnowRRP5U/GAwLh0EEcaVRTE1QCDh7T4GLkqKl4apcnBfTcnXacZXsk9vBtpehBqjFfFlKZx+/vuIuqTRkNSmXj+aBoWqAUxn/P/jc9Q1Ma1A2Ii0W599xjlVXtCFnNJziMe+SYzg+0QQfTWC+771ypFYoj38G0M5Ixc78yAv3MEa+MQ0NgoaPE/PuZzeXS+QDBmkJmsviki0lZO2iXLrUEgnoVHKDZBm64lPT9T9IerjwPNHS/mvzcvAaO+b7QDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 12:34=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Fri, Feb 20, 2026 at 10:52=E2=80=AFAM Andreas Hindborg <a.hindborg@ker=
nel.org> wrote:
> >
> > +    /// Create a `&Page` from a raw `struct page` pointer
>
> Please end sentences with a period.
>
> > +        // SAFETY: By function safety requirements, ptr is not null an=
d is
>
> Please use Markdown in comments: `ptr`.
>
> > +    /// `ptr` must be valid for use as a reference for the duration of=
 `'a`.
>
> Since we will likely try to starting introducing at least a subset of
> the Safety Standard soon, we should try to use standard terms.
>
> So I think this "valid for use as a reference" is not an established
> one, no? Isn't "convertible to a shared reference" the official term?
>
>   https://doc.rust-lang.org/std/ptr/index.html#pointer-to-reference-conve=
rsion
>
> In fact, I see `as_ref_unchecked()` and `as_mut_unchecked()` just got
> stabilized for 1.95.0, so we should probably starting using those were
> applicable as we bump the minimum, but we should probably use already
> a similar wording as the standard library for the safety section and
> the comment:
>
>   "`ptr` must be [convertible to a reference](...)."
>
> where the term is a link to that section. Cc'ing Benno.
>
> I have created a (future) issue for that:
>
>   https://github.com/Rust-for-Linux/linux/issues/1225
>
> Cc'ing Tamir since this is close to the cast work, so it may interest
> him as well.

Thanks Miguel -- FWIW there's no current cast work on my plate, I
believe everything was merged except for provenance which was a bit
too hard to work with given MSRV.

