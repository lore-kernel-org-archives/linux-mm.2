Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D731CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 13:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE9F38E008D; Fri, 24 Oct 2025 09:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0F38E0042; Fri, 24 Oct 2025 09:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFD3B8E008D; Fri, 24 Oct 2025 09:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BF1B58E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:19:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 639F8160E74
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:19:31 +0000 (UTC)
X-FDA: 84033064542.30.0ECE681
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6EFDF10000F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:19:29 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OipC4utc;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761311969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cd+byjApNbKDhYg7oeVVpvm1SD1excSJlnJeo52Q0hI=;
	b=6Iv5fRhVj6AWIb5+OClgMXDb7sUOGv9SeEwi+gTPTwzYyfh7hxeFCvo3WfRja9HS0gPUpw
	aErq+m5dBa4z1wu3+Sc+dmj53PKCcnOBU/OEvc5Zmw6XspWUCnPQUU2v9ecA3KfkrIgbVd
	CoPfqetgVriApQ2f9AtmLkzRh1XQ+pc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OipC4utc;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761311969; a=rsa-sha256;
	cv=none;
	b=KuvxkPxCCCUbsX2F8OqLioSGsDKpviUDFQ1jIhvFKMPoACWVuCtJS58xaJXBrw11y7D2l7
	7PwFld/0OyWZ3K/JuHIveN7klbYle5EwBbPAY1UjCAxslCy3mHzTYbEkr5cJhaDFUtXcKI
	55VJKhGRPt3jTrhWVXouR9kTHXFfKo4=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-63e18829aa7so2946277a12.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761311968; x=1761916768; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cd+byjApNbKDhYg7oeVVpvm1SD1excSJlnJeo52Q0hI=;
        b=OipC4utc7eWaSS4xnLPt/zNccVJyrfWuQ0WSzBPYN+VNVvbsD0asuVCuKLFES7EfqM
         LAXSowvxfwEvN8qdYEeo1J+aAAJQv/xBHr38gtgRRvDBBfjDQUgIq/h58YfJJJiFRLdt
         f6pLN0ALfshNN3M6nGEw4VwS7Q09RZGE1kHxXkRs4f3kc52Yxo+Bx0jLmQXdjODPZxge
         7kIOEyGKoLvF5kfogsZs0R6jj/qmOgn9C2ppHcXbh6jbs5lEbSogfOQCNX56p9kx67tc
         rusmgwiLqbvj0OQ7hHN5qLlSVddOez4O120N3PEWXnguNklMLceYwd7sMyE1zJKBesYe
         HIig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761311968; x=1761916768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cd+byjApNbKDhYg7oeVVpvm1SD1excSJlnJeo52Q0hI=;
        b=b5Sejv7rdndctTENeIzdxCgGobV/FJbTRVjAPGtqv/TSzFYJeNR9tdWqnXkcCcdfNd
         ErCl/mIsPyWZo6B/8KXGi71n/UWnneavhFOrqpePbyScJ9t5lX+51EJRoxKzGJfrNUAe
         6zYWlj/cx1N3pDthGOHZUSw2p/+mWejNtSyJH90iDHuq3XGEmoyAD411G2LFGzBvwCSR
         TASkVbn93VuxXs5jHKwsGf3HUT6vMpDt7DPcKdBdMpTtN2iFG/GeSUXqLclo3966Ht1j
         XQzlmNT61a8FSac3Rw3+Yy8iB0jI4KMr9h5F01HWl0FfD5huDnfAaeZIihq/fzjyPqUv
         0yOg==
X-Forwarded-Encrypted: i=1; AJvYcCVviJKWh1H00AwQ5eZD5hGu+XUmISgTNwpDDPwLmyVMSUMxh+f0bOTtMWYnekD8fiHqkuLnWMKrJA==@kvack.org
X-Gm-Message-State: AOJu0Yy85WL37tR6ePRetX5QklKvNPDeRvDZ9ltECwS3gH6P1der3yj0
	VAI3uakqKKtqkY82xYALJqh7q1hQQ+RCoYBaG2587fjwAwZD8vfY3QEaGo1/MwUWrx2lbd8Rq+u
	ykyjXW+7W/bawdHwT+cc+iSW3UcmEJDDXKyxE6kRJvw==
X-Gm-Gg: ASbGnctMbawHi0OZ9z/iaEdzSbusIj7XgtZK3TsWU6uQavQjUSdWyZ1g3UI6lYOvuOw
	GxS1+uZHRmaPogqY3DY767T8QFgiNRqeDatr6FamaziElXaSG/9nitoT8HJaINQLluezrdzqmwx
	dd7NYz0BrvzuUOMZk7IRPqTbuokmRvGiXykVeYtm0dDQ1ezNGRXNINMMVLwl9byqTYNz9V3qKTk
	UcnH5HmkJnkW7Mg3xvkdZ8pCU1ebkGrAoiUMkEUReHQ+fx7UBejfhBrgA==
X-Google-Smtp-Source: AGHT+IHerXBAjE+eqb3d+VEJqly91GUZl7zoRvZTnmTC+7QMZhEDWBp0kb9IGewYF1+6lcIQ+kV8dBJajelZ0Tf7+s0=
X-Received: by 2002:a05:6402:1d49:b0:63c:43e6:16f7 with SMTP id
 4fb4d7f45d1cf-63c43e618d3mr26739268a12.26.1761311967869; Fri, 24 Oct 2025
 06:19:27 -0700 (PDT)
MIME-Version: 1.0
References: <20251022005719.3670224-1-pasha.tatashin@soleen.com>
 <20251022005719.3670224-5-pasha.tatashin@soleen.com> <mafs0ecqvfazg.fsf@kernel.org>
In-Reply-To: <mafs0ecqvfazg.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 24 Oct 2025 09:18:51 -0400
X-Gm-Features: AWmQ_bnYAH8dRV1ngHGEfK3HhlURkQgl2sSokzMwDTJAswcSitgikNMtMv1tkos
Message-ID: <CA+CK2bBA46PNuwDDa2pqNoLVN5vZq0nbfo3BnDwn7fXK1MFtdw@mail.gmail.com>
Subject: Re: [PATCHv7 4/7] kho: add interfaces to unpreserve folios and page ranges
To: Pratyush Yadav <pratyush@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ew6ijwzrdfuni186dx7patkekneeekfi
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6EFDF10000F
X-HE-Tag: 1761311969-713708
X-HE-Meta: U2FsdGVkX182a3DBtt41tGFRP1uOnHT4DsXPQ5K6il+1zK1tWzFd1AL9pc9TTAcsS5JecZCO3hY5WTdl4NVNPA8izVk4RepAxAoLVhgvMNayiT4gMg4Uwp2gBc3R7Xgykvmu6vfe/kBaGAv6hZwk9RWTfr+v+411zWfXmS+ayzSjo75cBOSe5djhTGv1foYFCHEicnbLiKXNi4h+WfmPLXF1GAQ7z8yQNn0pPOrPBS7A2w0r3ImbYCulxIfimHCAn3uciZ3Bo+GxfQqwAgTi5J3iJsjMq6hIdyTHADEPr4NdHRv/yDDE2GbimwcoW4mv+aK94MDama7WhKqFVb02SHAirv3DfqMZWSEG3jLmZgubFS21yVrE8b0ktmfbE8RZv57KD1as7vpS6jUwQBJQmz9uBZcgNd3Lgagf4wKFKd0e4iP0M7gT1UQsphkegXeOxm4IPVXq/8qQ0OAT5Au+tSbCATwpXCZJFVubsVf5169J5IvW3yKD+mDIjGgpYAdGzCbX7U8ZUk8ikJQ5TqkJeEU+0jOJC+9oDGSKi5nNObAeNTTiR2LG0BVaKZ1fg/s5CTw+ILss8Q/f2VhHqqymW+vUpX5vahQnikjfgcVyMd6riPgja0RlAK0RXDjvACiepaeCMQ42EWNRJn4+X7Yf3FbVaI8hJvQIApr7oDJqrIS1WzgzUjqLEoenR2+/NwTCGhqbff3B80cLaBhgyj7ItCJoaK5nt3ndw8HctLf9UjAAEnlOX/pwf33baxHf6OLOY0x524ohB1k+9zmsMjclL5IKdQrtCsccvySMuWMoJWj+TEe/A19r2ZOqtLM+u6dWcjrlktjtiIjUP6kZpBRWPg0ZfcYsWOKQDSnpIXh78QqXgMGoxLhhZ5zReIU+uS7rpb3sGNsUWwMgA4twM+an5WG8IfNDXlippMwlXLpbsUApLpe4BnlnUWT6Dzv8NdqIJLPb78G9T5pd6EzeZJo
 Ga67mAjk
 zjUyM/kRZAUbXrL2935/Y2KiPOH5dm72SIWJTkLZryQxH4X0MkujeTyULLkCb71HZK3SFivhu3eEwHtmrBgCIOCdhjISkrPtmx1Nbcqw8BS119d6oAtIQNo+eQtaPI7nTvHVfUSZhBRF0Nol3sLrPN6/HQ7xu/7QwQL1K62z1IwbLAXDnhdxUqTXrdxXX3hfU5XNQ1VmsslVj/tewSMTH1g5IS/ipXERJpJTyuocPAeVZnGnz7CL1SKHCJ2ESAS7mrpYz0fS3UAk4WyfW8uma+zmlvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 7:10=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> On Tue, Oct 21 2025, Pasha Tatashin wrote:
>
> > Allow users of KHO to cancel the previous preservation by adding the
> > necessary interfaces to unpreserve folio and pages.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/linux/kexec_handover.h | 12 +++++
> >  kernel/kexec_handover.c        | 85 ++++++++++++++++++++++++++++------
> >  2 files changed, 84 insertions(+), 13 deletions(-)
> >
> [...]
> >
> > +/**
> > + * kho_unpreserve_pages - unpreserve contiguous pages.
> > + * @page: first page in the list.
> > + * @nr_pages: number of pages.
> > + *
> > + * Instructs KHO to unpreserve @nr_pages contigious  pages starting fr=
om @page.
>
> s/contigious/contiguous. Also drop the extra space after it.
>
> > + * This call must exactly match a granularity at which memory was orig=
inally
> > + * preserved by kho_preserve_pages, call with the same @page and
> > + * @nr_pages). Unpreserving arbitrary sub-ranges of larger preserved b=
locks is
>
> Stray closing parenthesis here. Perhaps a rewording to: "This must be
> called with the same @page and @nr_pages as the corresponding
> kho_preserve_pages() call. Unpreserving arbitrary..."

Done.

>
> Other than this,
>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Thank you.

