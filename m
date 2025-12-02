Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 451EAD116F3
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 02:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BCA16B0022; Mon,  1 Dec 2025 21:57:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 894E66B0024; Mon,  1 Dec 2025 21:57:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D1646B0026; Mon,  1 Dec 2025 21:57:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4226B0022
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:57:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A8681404AA
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 02:57:11 +0000 (UTC)
X-FDA: 84173019462.16.4956ABD
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 55B3320004
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 02:57:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MhJakbzb;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764644229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IbxtvI7JGB+xbAflih1LIDPQjkLzzKSp+rMSUHUFuhU=;
	b=0CumPfLi9MYJNlKnynfSImhW3sxidqJv9h7KUkidaWabP25M0gG5koVmyz1sh1Z55yUr+R
	SlMZUUjImyPFZS5pXfI4olEGSe276ieP72TfZ1O+d9OM5VQeh/fW7YKdHjPLBCOavt31Kx
	2nYpdY7tccK5Q/9bLKdXkI08LZUprHk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MhJakbzb;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764644229; a=rsa-sha256;
	cv=none;
	b=aCfVuPl2G0yHUo9aMkuNpZkhBgrgTtnxQTT9Wfnxe97bQw9p1j3oii81aGLZFU7jGhOSAk
	cOkvsKXioapCIRDza/NRYpp+bGR2VD/Fr7uVdlTQyWXxT3EgnheBRXKq461sILYCUMNt2q
	LyQ617c3BI21at5EA1KIo8k0Pat+nxI=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8b22b1d3e7fso466057885a.3
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 18:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764644228; x=1765249028; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IbxtvI7JGB+xbAflih1LIDPQjkLzzKSp+rMSUHUFuhU=;
        b=MhJakbzbg4NNkqWjnUhOusxP+5ZI7/P2ZEAtFHG1epR6ffIGMiTgDy+1VGjeD29saT
         36EEZkhi7Sasn/rbj0XkmJI6GdfO9ug1hMYaCkmeaLnPZAHufpB36uUaXnuFNBNsIYLb
         TOzQ2wj0CM8iO/Pnekk8o1l2On3PX+4UY/nsppxOt7A5v/DFfla7+W8OQfREjW79AMsy
         kHMISgYy8OqvNkjnc3wfopLg6+oHKoA1WAbrwHcnJMsNKODR8eu8HalWm/xElw/NEK/v
         BV0xI3k5ShYHC6YV8rElftOXz/yxYHN7OM/pKSW1j4Tl7QNQ9BI0eLkerYIYYMIxHbZS
         j9yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764644228; x=1765249028;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IbxtvI7JGB+xbAflih1LIDPQjkLzzKSp+rMSUHUFuhU=;
        b=RRQmTa4VxVJW5Obi8Lsdxy0js2m5clDulM+Fh/q3f9JWOdZEU8K/C3+OxBOAx7i3rA
         gUcsk8BRMWaqC5cMAXGJUnVUtRJTE3XfnX0BIDgFCpBNzU3cXAPvVUQUjmZa7OPuTkk1
         TXw9vOFJJYIu0IYfrFqfQTmRpe5q5T1rvi9hGnlQPO12mEb+ZAkfSO6nfODpEnnrnPim
         sVlyfvtfP+j1gLw8dhqfCeEPLdHuz71IdkpqI2Sgn++NEmdPYFbov3mG8tNl0SAAYmiF
         oXIVXPFCyFutH48i6p8PMsDD+DYO3l8XooAXJBpTvpZJFFaJGWeKGWDhKo/lmwe3OhE+
         a0sQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGS/Jzg3xTuQxPChlrhigHaSGn8uqRDaTf6y9y+N1nh1DSi8FB/d3JiJas0aqzkfhIcYbK/jDoHQ==@kvack.org
X-Gm-Message-State: AOJu0Yz6v8RJw4QCEkW2tGRhNTkl2jDk9IIRGskigljWu00oCi/dttID
	ZAkscvK+Lnel8q2W8ez9nrTAMuoquePgJkRR8J+YbyZNbiGJDTaPCEO1zN9cpalQ1reul9gERgl
	aJWMMsGSTN5Zyf/AkfG9Ofm2tsJeonXA=
X-Gm-Gg: ASbGncuMWntCtexUto0nHYOAzynZXo+DehKLFjRVKTsnYj3fcaaRToJTh6w54fkXiCA
	mHgBpjlNmGf49u0zD7ejzT+T4V2Ejg9Y4hPUKPwXq7xC6hc1KjTvPVY+orgSP78mk/YWjhqcHwe
	HstlTmQJ0sbM317Es7vK9niA5MALkRT9Iv7njtt+Fy9mN4N/+7idsJsxpZ/I7Nhe33A3NaovJlh
	C6RVKRtUnBqrLV3F52VifAI4BRlXNTDV93ilzvsAYI+Ko87I5pqsSc6fUjjAyrE8eZPZw==
X-Google-Smtp-Source: AGHT+IHSrFXx6WdPUJXNqwWySfNgAFhf6dUmf2TzIUCtpt5fJLC0Zr50oNP4NsLFvnsJnl9CG9tJBk/RXrRR4nOf+hg=
X-Received: by 2002:ad4:5d41:0:b0:880:7095:4779 with SMTP id
 6a1803df08f44-8847c4991d9mr567879156d6.1.1764644227981; Mon, 01 Dec 2025
 18:57:07 -0800 (PST)
MIME-Version: 1.0
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org> <CAMgjq7BgCocnkJAYd-BBBvzbu9zxmv4QCj+k62kcA3ThZcNv2A@mail.gmail.com>
In-Reply-To: <CAMgjq7BgCocnkJAYd-BBBvzbu9zxmv4QCj+k62kcA3ThZcNv2A@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 2 Dec 2025 10:56:56 +0800
X-Gm-Features: AWmQ_blt8FoEizZCYWt370rCBtZ01WGRW6EmeRdbp2bXALNDhH4Rs5OKCoY6MOs
Message-ID: <CAGsJ_4xZPPE3TaAYU96srZKe6aKZmV743kQ97E48ZWh3BQ5Z6Q@mail.gmail.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
To: Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	pratmal@google.com, sweettea@google.com, gthelen@google.com, 
	weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: m13fbbjhu1bqajkx69434spktgjkffwu
X-Rspam-User: 
X-Rspamd-Queue-Id: 55B3320004
X-Rspamd-Server: rspam09
X-HE-Tag: 1764644229-264529
X-HE-Meta: U2FsdGVkX1/qRQBSwlG53w95XRxWfbZolaIbRPAdUSMIoP7V6rBMocxmpzHP7qnOisEr6Hx4SxIp2cK0TcZNXJhqiAJrN4cVxlIrPEVB4bd7qe7G7twD7U96kYq52vQWukNrWhVgQE1Egwec/w9+LAa6tRxzKIEKvmuLP/BjiNgpx2U34OZ+Mu+im7l3S37ddRCcQ/eFRX0z1hH3P+Wq+cfQQ1GUFlhzGIXs8Yj7oAlgwoYf6H0SkjVB18Uz9dKBaOH5O5tr8uLhuGaSiDsh619EgjV/VG6iTA+jPCGpJ9cHMuT5gMPN66cS6Tr0LyUcFKE5rxx3qUI2shvOjs1pkG4AgNIBOyb9JNquSiKuqfWbwxPsY0G5HPkE0rMsEvUMKKcY0hVUJJ9YuddeZfbnkf0oamACUEU4eBiMdat9OE+9wpSdICuFQ4/D2AXWPzCGVhazRDtsWGh6jLN0wGgoJ3Beeu+r6VqiXwsqY1N+DNypqvDM0chAaaIs/P0S78qEPe1Bk1youyPwH8ZtDKVWSZv/cdsnnmWewaYT00olX7ZJ36XLOBniofszfGnHJ2rshV7FrO0H0HfyI1N8OtvUwSuBUXJ6nnzOAYULVvcw92sxTR7vpdIArsWRnJXY0TZA+FgFmJdL2xiPm0BqmUWkWQ0o9vURSpZW/H0V05PbwvOs5ypzCpLgMbBOmykqZjfCychnYbOFvZ2xvRwbOnZMvR4FRx3CsV/C62RzJ3RYw82+OAV7B+yaQ6WR5CpFd19CN6Fx/e64Yx8NwAheeSjnJ4K1akgDvZn1JUon5jPSqLG2BNYpRI+0+oVA9zY7azt4zpNlbjfqpc2XCrKUiaBDLsF31mDBH2C5VsKE3AXB5qNJI4J3CR7ijnJ0ydKA2QRkOKsPy4dpLjlgy2NDyJlJYTq9B0+jl+qcZAQVY8ldpeXqkTODT4XhtUtHXRLLuKAEOchVUl7KiYBinV9adVC
 pqlmc3Tv
 TArxQu25jYaBZqeDFP7B6aWdghpn3olHVP69DZ7TzvLe+FqoGH+DUNvGZchwgw2YeB6i9LeqoYbCOo6m7viM6lfJEcH/YCqkqOr/Jw8Vl1yTKtZ2Lb5mgxzFRFYgCOu00MkrYfVu1H2dSXt2ojKD27r4NBaQIUnUOy52FzCYMTznRcz0cZvhj1+F0F/WnJCW//Hl7/SA1GOihjSonHZRueOWUj3VqwkWAubAiAajpzpVvzy3RFkS2sbgwOubda/j1NuliQQ1uUzux5Dkyzg2AMvOZPsqtdRXPnZHwIsvLc65iCNXkAzbh/cpwj1hT1QNiZv1X9tDMpw1S/Q7ciKU7k/K9lVKaABqZ01PeeuDtG56YQXS+YLI6MLOhLE4T6QlUFr4vuPHHrEYMt4Fg9GxzDFQPzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 6:00=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Fri, Nov 21, 2025 at 5:52=E2=80=AFPM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > The current zswap requires a backing swapfile. The swap slot used
> > by zswap is not able to be used by the swapfile. That waste swapfile
> > space.
> >
> > The ghost swapfile is a swapfile that only contains the swapfile header
> > for zswap. The swapfile header indicate the size of the swapfile. There
> > is no swap data section in the ghost swapfile, therefore, no waste of
> > swapfile space.  As such, any write to a ghost swapfile will fail. To
> > prevents accidental read or write of ghost swapfile, bdev of
> > swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
> > flag because there is no rotation disk access when using zswap.
> >
> > The zswap write back has been disabled if all swapfiles in the system
> > are ghost swap files.
>
> Thanks for sharing this, I've been hearing about the ghost swapfile
> design for a long time, glad to see it finally got posted.
>
> >
> > Signed-off-by: Chris Li <chrisl@kernel.org>
> > ---
> >  include/linux/swap.h |  2 ++
> >  mm/page_io.c         | 18 +++++++++++++++---
> >  mm/swap.h            |  2 +-
> >  mm/swap_state.c      |  7 +++++++
> >  mm/swapfile.c        | 42 +++++++++++++++++++++++++++++++++++++-----
> >  mm/zswap.c           | 17 +++++++++++------
> >  6 files changed, 73 insertions(+), 15 deletions(-)
>
> In general I think this aligns quite well with what I had in mind and
> an idea that was mention during LSFMM this year (the 3rd one in the
> "Issues" part, it wasn't clearly described in the cover letter, more
> details in the slides):
> https://lore.kernel.org/all/CAMgjq7BvQ0ZXvyLGp2YP96+i+6COCBBJCYmjXHGBnfis=
CAb8VA@mail.gmail.com/
>
> The good part is that we will reuse everything we have with the
> current swap stack, and stay optional. Everything is a swap device, no
> special layers required. All other features will be available in a
> cleaner way.
>
> And /etc/fstab just works the same way for the ghost swapfile.

Apologies =E2=80=94 let me raise a question that may be annoying.
I understand that people may already be feeling tense and sensitive.

Despite the benefit of compatibility with /etc/fstab, we still need to prov=
ide
a physical file on disk (or elsewhere), even if it contains only a header.
Personally, this feels a bit odd to me. Is it possible to avoid having a
=E2=80=9Cghost=E2=80=9D swap file altogether and instead implement all "gho=
st" functionality
entirely within the kernel? Ideally, we wouldn=E2=80=99t need to introduce =
a new
=E2=80=9Cghost=E2=80=9D concept to users at all.

In short, we provide the functionality of a ghost swap file without actuall=
y
having any file or =E2=80=9Cghost=E2=80=9D at all.

Thanks
Barry

