Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56BFCC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 10:08:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 540A26B009F; Tue, 21 Jul 2026 06:08:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519436B00A4; Tue, 21 Jul 2026 06:08:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4070F6B00A6; Tue, 21 Jul 2026 06:08:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2E86B009F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:08:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 89DEB1C06ED
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:08:03 +0000 (UTC)
X-FDA: 85012358046.06.8D68A00
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 919BE180004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:08:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n+JRHP4g;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784628481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJqHqkBJhkNLZbiN8td7JzVLgTCDKdS3I7/+ILBr1ww=;
	b=PDqmaiF1f/eEuS+3oQKjcj9ufjcv0MxbXz2nH5NojwDTaq/3z0W0k+6ZyYkSd+hHN4rbZ0
	Z8Y8z/tPvQzt089jjrSN20R1jvwRuxNWC1ohH8QjpnBDhdEt1LdT+nuUKcD2d+f6//ebbD
	wkt/nd9vEO8eiFknkMZJIgbo3RRRlN0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n+JRHP4g;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of miguel.ojeda.sandonis@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=miguel.ojeda.sandonis@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784628481;
	b=rltWsxuORgVhUkg/TPjopom/B2GVO29a2AzNDarpLKhadLrCd+ZnAqs5etau+T/A9nDDQe
	o5NouKUvrEAnyZVfmPhnygSQPhNFS85njMjrJjfMy6rhWG1/xEGcOZilPOK9wgHUxVOfjI
	qMFJAOPh2ffuyRZ8/Cpj4UuTKEMqtbo=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cf30af983aso7679815ad.3
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:08:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784628480; cv=none;
        d=google.com; s=arc-20260327;
        b=i2POb7UPmMQN/1vNefsKMnwzilfv61goRmJs4GFLmbyikDFIdeGXAi00UbP44S8zgd
         HXYVkElrosoWGLr002kH4kOhmVUn9aQNpuagY4yoDB5S4AnfG+IiaPWeRQ9FbkPK86O8
         ECX0gejZiFExRaXs5DBEhMBygSkaCTtC8S4JoHe9KMrCyCiATzZfd4iF0G8O/MPNBaeN
         8nyZGf/x9vAUpDZqzub22T/KJ2DJB4EX9Ua2HH+I3VnsWoptbwmyb7WdI6rRGgLPnUAH
         sVE0AK5Qe9ZarfrF2J+vNZp8q5aIdiGGf3onGfK+ZxXwSMav/RLhJ8NRwBE5yVEjuHmN
         hTdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uJqHqkBJhkNLZbiN8td7JzVLgTCDKdS3I7/+ILBr1ww=;
        fh=LTvCQrNPIVedENNky3FlPK6xduKOA12P8GUq6tduTv8=;
        b=NWoxqTv6/9bvSX2OH8fT6nRfubYY7C1aIHsdggH1KDLkR3ho5KtrCIcYRerX9WMhnI
         vV1PFMriU7R3nbAFz2dvvlKWnZfq7gwUYbGxqVxpdz3M51ga7yPsQ62XCE5pUcPOQ9iY
         /OqcDDsEK/XQsTDkO4KozLrf7GkivhDFW7kVPOvC00gd4xZwtBy5Kq5L+cBLSokV968K
         R0CI7+3dylQ0m5/YLjjy/86kTQsxLcqGOMqcjINj/MAvbmsqAYhH0uLbgn9rdHC4iU4v
         uhzm1EzHMb90Z4uppEAO0K8oJN5x9thZtcxAQaGXISWYlUS80qAOeD+LncnTN8GrXUtv
         fQXg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784628480; x=1785233280; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uJqHqkBJhkNLZbiN8td7JzVLgTCDKdS3I7/+ILBr1ww=;
        b=n+JRHP4gumu736A0LQWLeUEqq91ojTwbDOZ4OabMfqPyt3AubmhC3zoDbrM9b/6Su+
         gNk8NyTYeWE12ZqS9i3mRo0JIXQIGg0cPMM2lMAd32hHTIsVg1MbjgMfUSMSOAerKOIX
         XIYj5yAbFp2BtOuUYyDkLqIPKD39XuQfpTWhWvHxIqfD1MUkPtJu6o0gv6eF+aPbalBc
         H1aeUqqd+YMamgTn5vEv453DUFkbvMZq6zO20zych+GPrId2KdQ9gT0B6SlW/GG1KaYw
         qCcEU52i4RJa7VoOmrPRqJqMiI4oCfx17DTSaY2R70mHG9+UxhVLg5ethyYwcWY4nlGV
         Hy6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784628480; x=1785233280;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uJqHqkBJhkNLZbiN8td7JzVLgTCDKdS3I7/+ILBr1ww=;
        b=l/0mv/y4mu5Q51Htttd9Pyc+Qv4FoNClWX1ZY6IxSPf4bLFovwY2T0UvEGoGbcILnx
         T0No42hFfsMTGoAhva9zG+/DMgeAVQNtkw7D0PEfBUAcvVSftjtwQvvbu0TAGMSNCyq9
         B2C7r0G8IVL+0S+RUguAe6JG6PW/a6gHaAcvfC0Tq5lvFvjr5F3m91pHOGZEOQ/99TMw
         MEjM1lucnocgd9cIzExdspMKXdfnxp9PKZIWRAvbtpgPCvBRpX9Lmu28rcriU/hkkXmV
         n7jOJnvvBHHnhwSnETb7YWmyRVvdgOL9lPB4XIg7gH/M/HfIjXy43Dh9KSjff2iiJYLM
         8UnA==
X-Forwarded-Encrypted: i=1; AHgh+Ro74kwzIajmAqYCthJYOVZy8BoeqwzJmtCEQOovvPrrrSVAc+3PArrJStetjlmcfU70hSaZhS+kmA==@kvack.org
X-Gm-Message-State: AOJu0YzodHnkxBgAewYFiI+XamHki7pLLDUJWRL+U0s+aCw6WqMEZTIb
	C0j6G/KWhgWiDvZlrKa/F0uOoqIBysIgBbWZRT9yzViZNJnSR4l5HNfSi9lFBD64z6jd4Ojq8Xl
	r+QOWpHHq4b9uGZok3TrLCMLwkyT0GPw=
X-Gm-Gg: AR+sD12chqZJu7RkFONlPu5acgPhAKaHgVl6du6Nq8lriw5c+HBO+A6wMGeDwMBMJ62
	uU4Os+3GgFb/yiVj8wyYqRVRmltGXKgJHRuHZyq+8WX4y0Yyw9DfZXt0cf+RHPwCYjLT9iKkMHn
	Wu8/BA56NfGGVQc0meO6zCjugLbLPFKbWPH3SCYQ3TlzRLg4VTqONyoC5I5Xh7rFP8UiPiGbyI/
	GYVJtT27t8PhCMXoh+60oajfS2MK0RzuZan2LLFHCyCI+uMzitSfTJQx3NmQo6p5prSVtGigtdA
	xEZtQykUW4EfI5wMVJx0fp9ofaJzZAMSkdk8cYmj/iH2LIpz+6AQ8DMMxuHad6+x5BS2v8/oyRw
	M4Q==
X-Received: by 2002:a17:903:2c0c:b0:2c0:db23:4a6 with SMTP id
 d9443c01a7336-2cf34877127mr161188405ad.1.1784628480430; Tue, 21 Jul 2026
 03:08:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260711-id-pool-move-bitmap-v1-1-cd5b7efc2c12@google.com> <alzeHwmGJsmK4z96@yury>
In-Reply-To: <alzeHwmGJsmK4z96@yury>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 21 Jul 2026 12:07:46 +0200
X-Gm-Features: AUfX_myc3dWi3KO1PwgkhDIvWoWmIji8BJjxPimHdjYL3OdXBlWKkkU1pj14LEw
Message-ID: <CANiq72mz9bvrOn14yVtEOLf9BW7R6mS+whRszmcA-WNMuftcNQ@mail.gmail.com>
Subject: Re: [PATCH] rust: bitmap: encourage using xarray/maple_tree instead
 of id_pool
To: Yury Norov <ynorov@nvidia.com>
Cc: Alice Ryhl <aliceryhl@google.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Andrew Ballance <andrewjballance@gmail.com>, 
	Burak Emir <burak.emir@gmail.com>, Eliot Courtney <ecourtney@nvidia.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, John Hubbard <jhubbard@nvidia.com>, 
	Matthew Wilcox <willy@infradead.org>, Tamir Duberstein <tamird@kernel.org>, 
	Yury Norov <yury.norov@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Benno Lossin <lossin@kernel.org>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Boqun Feng <boqun@kernel.org>, Carlos Llamas <cmllamas@google.com>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Danilo Krummrich <dakr@kernel.org>, 
	Gary Guo <gary@garyguo.net>, Lorenzo Stoakes <ljs@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	=?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	Trevor Gross <tmgross@umich.edu>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 919BE180004
X-Rspam-User: 
X-Stat-Signature: uenwnn38uhsamhwk8sy3mm43mtwc5pdm
X-HE-Tag: 1784628481-21854
X-HE-Meta: U2FsdGVkX19NWYQFBmQlFivkJzNu2Ct7889lVCxIxPCa8nYeDWdYFGa74KdKpnR0gfAkMFafUSr3quj5ck8r9c9swzt0f+HnPDKwyBEBseSeuUhHFZgSvyBs+miG695ZlvZmihyEPKI9WnSe4mGC7u1Hyu1acu44/tNqji0OhJUA8br/hqXNFJ6XW74yN7Jik5kiNjYXXYJArPcCDeR2kb4FAg0yZbw+IDRlquXoZdcrcPJJjhW/L64u1+iuX5H7tWTydzH+R879Rs3vQYPwvH/+n/sSH+lR4iTChuZRXoWQyi5Akm0zIfQopvzY+9RlykZ1ZBYP48dZcAGhm2cDF0IMaH7/5e/K0IdTtjwyHR4zBweL/Dn7NA7yBBdG3DVRGgX8LRSrSq3si5p/uGaifFSj6/Okm94CxYWUcvGr4nFFTyDbv/I3ajibNTk8OnHS4bxFyKwNOego5837hBf4IcSkwYYaK0U3OZAvLZJeLZhgSwiqxfTdh8oChNbmCsjdQSrzec+beGw+vyLSlf88qr4ND26yg38kzAeg/s0mTrlPeGk3SppcDorluX7+G4PDR1fnRKU6jAnm7r4FuoN3btW3Jb6OqY/MaRHMKpYqeKpSecTvFJKc1Hc5zObNahF+ARV8wZj3r6JRxjbYnXpu8UwoWPRrXqUB72ns9hRU+HNiV7FlqPMpMD8XcOcw8U5vAfs6xLCvJidYL/7sRet/EQ81lTXX5/YM9X0hHI42aDz+nCLu8LipzXpwJVTwL6F4mF27k2IwldWM8L6ojmpZ/teALYEb4tADhubood+jaKs3Tn8C75a3BkXM/UqSr65LS+7oOuRz49yxlM8z5SIuFPXsyWhtoylwpZ9UpaZK6zF/AZ74fv9fUhW5TVAWA1Vaj7VGvHsrfLEDSHLFv4QdJrMxgJReIqY2VuorUYxl8tO7kXb+/Rqvsb4E59M6Uv2op1PnBeHvQvHCCFv3w+/
 h8KyBbjm
 bXU4uSaUM1kSrBYQmbB6rrob3dmBKzcBZJbNYroF+5qRI7J5U4W1z6gjEoeq4HVWRQTifoFtLoy0waUEpt21zfI2b63eef+eDZ8nh0WeV6S7yB6iC/ZP899tkp8nyEaifzGIl8smp3DFR6ZoSlCMHdyCZ5ll59uoJ3Wx1spp6kGh+yipQTlxBEiHh5zRXrd3govHRRsiyH4KGSO/z4fQGNRFFYYB2HvHR2ikiJ3GAsIcVbaMB6MaUzQ78pTgCtsCW9TGBggr6nrs3ltXve407NC+80DgUV/9D5CJR/fYA6hUcCl8txgHJjECzp0gteYLVKMEE4Sr3AU6nNkoKWCSAcz6NEIZIF1rvPvUoI+z55u2iuOq7j/Y3vSg0xiWgX+zzjm35FjDjGZ6YXsYraF1GKzNDC+M+gHwkmweKq+zlj6VQJL5tlhorKo10uGzjalbZ5EO4aQ+YmVKZ1GmhRk2Vk/us3ZpxV2Rp04jAVwgkZ+5bSiyW+YQmjMkUrMOqFFeSZBXRQqCNEFF4b/cx8Vvl370+sHhwOzypigkxBpjrJg+VIm71TEpVVERp429U5JWwSpKm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 19, 2026 at 4:24=E2=80=AFPM Yury Norov <ynorov@nvidia.com> wrot=
e:
>
> ID pool is a user of bitmaps, not a part of it. If we move every
> random user to the bitmap directory, that would be an immediate
> maintenance burden on you, Burak and me. Not sure I'm a fan of
> this idea.

Splitting things into more independent modules is usually fine, yeah.

I don't see why we would need a `lib/`, though.

Hmm... If what we want is to avoid having `id_pool` as part of
`bitmap`, then can we add the documentation paragraph added here
instead?

Thanks!

Cheers,
Miguel

