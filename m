Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 297B3E9A047
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 12:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85A3A6B0088; Wed, 18 Feb 2026 07:00:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 807C76B0089; Wed, 18 Feb 2026 07:00:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E96F6B008A; Wed, 18 Feb 2026 07:00:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 591786B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:00:39 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A068160120
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:00:39 +0000 (UTC)
X-FDA: 84457435398.25.E764D8F
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id E190518000D
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:00:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pOfP8kyO;
	spf=pass (imf16.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771416037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nIWl7aXfgGtJ3exLV9K3pfaZC32QHoeh0z91VzJokww=;
	b=NmV6/JA1uIW80a3ciOCdcsEbBAoXeERica1lbLyZdGr3PnCgrmFdMhvIeNMW5rJKyNaGp1
	TZIb5rsKU4ClByCFKeU9CMHpPlrSWLpQzTQ/W5flsvae4cFxuO5sKeytac5EhfQMFfDRDi
	v47rQryiYkMaxtMLiJcb4TsQ3v84qZ0=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pOfP8kyO;
	spf=pass (imf16.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771416037; a=rsa-sha256;
	cv=pass;
	b=H56dveQlCiwlPrxOx8o5SRg2e4SFtfcVtZY4T7H5EVDNXzl7xooHKyuARIn3tQ0vX+8kNH
	9G6SWr6pXvnuyzkqPDKVf5tNQi525aV+fQTH7w5GsJE/4OKWuTUEW7G85o+UlDWdf+NU3I
	l87XCfeN8jrfFkDjFMrVAKPgDuh05xQ=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4376acce52eso3397409f8f.1
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:00:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771416035; cv=none;
        d=google.com; s=arc-20240605;
        b=QBLnkgzf36QzrShWEbCTAQmCSG75c2ZDQ4fOVlqwFxUFdEm6FWsGO4CIF2BIkvncZv
         +jWOcQpa6/SathttgrPXQBHxzSg1RsG6MBjXLXmCbI3EpPAiR3CgKnfA0qFSo29Qtvbk
         isOevAgrAopROBhNuDG4qWxpoyInolK7nChsYWXNTY+V5EuvDmGO4vPvaKm5SSsfEHf0
         WbD7yvH4JjnGuIL7V1RC65uMgHhv8z9mGRkBDg18HO8fGgTP5VKKgm+g6+j3xGb1HBSa
         DK+NSgWZ3+qbKb6Uka2zXzSg1LWEQGf6R9WQBZY+jDcGyT/uWMGDWO3VywSh3W4EwBkY
         xGmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nIWl7aXfgGtJ3exLV9K3pfaZC32QHoeh0z91VzJokww=;
        fh=9mM4jg1/Uf7M9Xx5/nFps+WsxXeLQDzHhmx9xeR+ytE=;
        b=GJIRQSbBsnSQCKTnpbqH1mqOSV7MLIeCtv1/2kwuYMA5YFgnlHmHuUH5U8A60ijvUA
         +zPK94Te3xRnxnlo2L9dbpDS7FtZ9xcQc+VKEfTDky+mG4EZnm0AWXhAZfMDiTKqaB9R
         Bv3hgxpyH1Bmc3eDvya2dsswyunvTlVfB4GwEIDbC/ML98LbGlQ0bu2sqgVoFACKvgwL
         esLh4SeOtrEz57RMWyG2DWmth/4lHUbZSNaiAJnuY+Lpk/Er9esaXqhMV7gIY0/zFL98
         lBY/vcwWqDzDh4mQJu3VvfXtrlHf9U13z1f3g7ypzxSNqFeLEbvR0bF0c4lcor/HmGea
         fd6g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771416035; x=1772020835; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nIWl7aXfgGtJ3exLV9K3pfaZC32QHoeh0z91VzJokww=;
        b=pOfP8kyOgSvWhIog239ETdlgJFDJiIUNLS0Xnh6xbPe77SG/8H/QePGyc4tfK9WEHI
         LLvuxkkHvs4Svdl4J06y0YEcQURRiI1Y3F7zwGoEnDG5yTsFFKfom1SDWqcd6Fbqg9CM
         avUpsxRGs4vQAtppaAiYd6eMXSkFySdK9TYQtcAvJ6fSEi3H7UlIYqOxlTpjB5/LqfiT
         /mcL1IOQ6iJ23htnem76EOQ0kMOKHk+s9F3STCF068yu+euGFqwPgWqMEbVp3fdrQZcs
         vOG0Myrx70haBm9b5vN8w9zlz+V8YhaSaf/zEXDGuaMx6oAZt0KTQg4Kcac55zRI2kJv
         HwgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771416035; x=1772020835;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nIWl7aXfgGtJ3exLV9K3pfaZC32QHoeh0z91VzJokww=;
        b=UyleTU34hLjRZhKwSrR/qoluvgSvN2gGZ+w6vLc9Aa6tID1TLY7l3dlCCy8/Cq5OE6
         81D46mxr0i4+isWZc+sizZCSVtB+jFYJMhaRgcrZ0Vr1Nc5vawCje3/2K6LI4FrX5zDk
         s4hPd5qyrpB4d3B4O/j9T6SDC4DKQSvHGN1ZOpsk8bxZ4wkE3rU5xbv1/1QNP/0Ykvvq
         T2Xp5Oomi5NNfRSEm3Z/RB/Pm2dKSr1yTIcNnPzNRDsuG6nfJWV3kvzwgyabqP96Ry0Y
         P0KDZebrLKDKMqPFZfgNrPMZ6qwmyvFQ4uCUyoQoNqsVNd01xhxBsnX06nYG2sjS7q6p
         sNFg==
X-Forwarded-Encrypted: i=1; AJvYcCUJ8rgHa7n6c6gZyU1V7XGYkbtVxnJSS8ESvCzWVFSEPd73ma1OU81IgybJfj5qaufifH+38kMFdg==@kvack.org
X-Gm-Message-State: AOJu0YyLxLpn7LmE7oj9KH2+U6+pnDbn3WK6TzA5PT/CNzQZXYXuMFkd
	b1BdFv2WR5vvs1Sm/JWA90pYgW+GHn/erpIGjpcGYnEIdXaIrWrE/JH3OUvVMbAI/JkVbbVvp2F
	novFB2DGSQDpoZDHDVU2ZR6N+dBHUM01+PoJuAmLa
X-Gm-Gg: AZuq6aILkjhQ7cIakdKktPvUyDGbbfNlTh/OovTSwSbSzsHb5gTJK7ggkxqCndNDNEm
	TMU7G/G5AUVA7hRtWgBhhzFPHLOjSSJO8Y/H1a4kVG2NCpimMt5m9y5XoAcEeCc4fXAn7mZJQO3
	WaA91E3/PQV5T7iRkwXEWtL9inWhWYa3RlzZ0O/vcr7fgkEawVSwurLQ0O221jN8MKx9FuvGKbX
	gE/1wkaWCpBez6XKih4+8/Hbe3rAhU7V+ntUSyZKWIhstP7+85t11PJRjMFU57fAh6/bP8wvqAd
	zoPqEPd9lfs6esA/9uwFIIbNgOo5BJeGb4b4FsuUesg1O7KtA+t5T/3mu4+OeNsa0f+BPw==
X-Received: by 2002:a05:600c:3f14:b0:483:78e1:784 with SMTP id
 5b1f17b1804b1-48398a433abmr28986405e9.4.1771416034697; Wed, 18 Feb 2026
 04:00:34 -0800 (PST)
MIME-Version: 1.0
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org> <CANiq72=5r2miRm6GWszb2gDNi4k5-RZUzvdOdFQ3yyndvmHbAA@mail.gmail.com>
In-Reply-To: <CANiq72=5r2miRm6GWszb2gDNi4k5-RZUzvdOdFQ3yyndvmHbAA@mail.gmail.com>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 18 Feb 2026 13:00:23 +0100
X-Gm-Features: AaiRm522dce7ntc1e6TRegCfH-Fit-vrZloDiDJY77NewyDthLo_cZ6PwPQcfvM
Message-ID: <CAH5fLgi6NVagOPA_=r7Dmk9MFXrvZVuq85D9bsJfUqLNOZjCaA@mail.gmail.com>
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, Benno Lossin <lossin@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9336q7549nb1hequmurc1ozxc8hr1zje
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: E190518000D
X-HE-Tag: 1771416036-969578
X-HE-Meta: U2FsdGVkX19kkblGCKfGBMP/V1EXZuiajbiqsbN1V6+3PlG99ppBgZZ0VxYLil3tfCC5Nv2+384Q585ZgmI67U8mxw6P0iEdd3ye7QqmPUJ8MFCy24mI560/siQzZtscvA9s2JjKxxHK9NzgmC7bdvRdXiqF0NZ7dE8KLWYrKKckpDVn0Qm4rl093+XPFGJc6ojZ8Nf67vhhU8u9lq1yfnBUffP/WNqoWA4lNnm3qkRQUsvcxN+NEl6J+9h6SzjL1ZKVwb5/vKo/D3zwEuhMQw9cg4mxj3oKJiw+bx6lprD0/UjJkMqRjjClXG9bwR6xyi6u+bm4PxIUt8qORYnrQeT5hrUYkEVU7Ln4ovq968Pr8Xqhmdy8QzpFpSaFkM0nKUD1GFJS2XdXDfvB35UT+wSsXZi4xXi0dT14KqVWyO18pcR5UqmgeYi42fNZZkwch11dioLb30dPuNfXEm03PDD+Vq1TmNrLjw++JVoR5Fqs0R6C+03chkqZNjK+ncl1sTA9EnfS7za8JN0PJFeU5zIepzQUBpLXfEbUAGBPRYXR2jXmXe/SHmPvNODRTrWw88nZJgDFSYYKVA4kv7C/AGI9lAX64u6/JMcGD6y8YkCwd8cSObMQxrH4pgJRBpJukyEmAROM1Zasq3r6LqDogveApqx4CftznuSm1IluiCtHrw6IM52jvfMjDgmSQ+9V0gufQccMFUWEMVOu3CC43Q03dNqcVxg3ntuJGFf+W3TIJi1GVoFYDeWScAYKSVQin1E+GuWElG8gC8T7dr2EK3+9rPUr+DoE7uFQ8RiakgNMFPsJhz4NHxaR4laVL5py4kNVXjhisi9Xawgwpx21oIjFP+NU//n/GlHEQkxIq0em+jRK98iiZI3alPJ2DWuXrtYNn77OaA85HsVC/cQyPlU4uydncZpCrKjoVXHXCQ/hbvILK0b5CIUE1kUZlo+n+BoYbIRRaLFw/wTpcYI
 QfJyxK3R
 T0skyxUDKlnaU+fL/bQC2KIQTaIUzPOUQ2EP/y4ZeIBcxzXUZ2bxfJKmQOK2XJgaY0pVnmtC1mSQAZeI4QkDvliBhs5Emy7/p7MBCtm8BWeq0vq38roSfwSsKo/rEuxf98WrVrcUiETxjkPx9EkSlCiEV3DD+7BfNU+tzEOYwHKkJQGhQJnawd1Fz3y8+9jMcgwSeKgI3MFwZFzFCXdAjIOLw/ZOeNrVpdGrpUjOgCPtdS3gTTOkvA7y/thtpstjthcBAGSYyXqZuiBGMNhH3jgO5g+BynONEmerk3GhErNMItZKPP8px+34CH2N9Bmn+unjbtZYy3j001bWYk+HMQ7++PvI2e0Hl0S/uygAlku+Pjh0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 12:57=E2=80=AFPM Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
>
> On Fri, Feb 13, 2026 at 7:43=E2=80=AFAM Andreas Hindborg <a.hindborg@kern=
el.org> wrote:
> >
> > @@ -282,6 +318,7 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset:=
 usize, len: usize) -> Result
> >      /// # Safety
> >      ///
> >      /// * Callers must ensure that `src` is valid for reading `len` by=
tes.
> > +    /// * Callers must ensure that there are no concurrent writes to t=
he source memory region.
> >      /// * Callers must ensure that this call does not race with a read=
 or write to the same page
> >      ///   that overlaps with this write.
> >      pub unsafe fn write_raw(&self, src: *const u8, offset: usize, len:=
 usize) -> Result {
>
> Coming from:
>
>   https://lore.kernel.org/rust-for-linux/20260215-page-additions-v1-0-482=
7790a9bc4@kernel.org/T/#md120cdea73132fc698bf69bf3d69287c2cb28449
>
> Leaving a comment here to avoid forgetting: I think the new bullet
> point here and elsewhere is not needed, i.e. the first one uses "valid
> for reads" which I think is meant to already exclude data races.

That's right, valid for reads implies that it's okay to read it.

> > +    /// - For the duration of the call, other accesses to the areas de=
scribed by `src` and `len`,
> > +    ///   must not cause data races (defined by [`LKMM`]) against atom=
ic operations executed by this
> > +    ///   function. Note that if all other accesses are atomic, then t=
his safety requirement is
> > +    ///   trivially fulfilled.
>
> And, for this one, Benno said perhaps we should introduce a shorthand.

valid for atomic reads?

Alice

