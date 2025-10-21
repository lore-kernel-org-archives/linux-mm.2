Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F166CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 16:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 058058E0020; Tue, 21 Oct 2025 12:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030258E0002; Tue, 21 Oct 2025 12:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAED08E0020; Tue, 21 Oct 2025 12:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD7368E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 12:08:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8691447DFD
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:08:42 +0000 (UTC)
X-FDA: 84022604484.09.609E009
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9A545100018
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:08:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RP+DCSdB;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761062920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxaUYavdFNgjliOqAPTDoGj/sgS4UHn62o4psiKVfI4=;
	b=1PAqpkQqrZDkUuTC35kzIdLWTPLpaywAFQVTYA8rHA+othyzYytelSHLQmdTULRBTOzqT9
	Qx5C/MpK6m7Ru9Q7i6UM/yK2ASd6RDiGRC8adYKifrN3izAF6a1mn3NP4PLeb0seIffLrO
	p5RY/Me6C6lhphpPi3hIYjWbVzDPC+8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=RP+DCSdB;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf05.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761062920; a=rsa-sha256;
	cv=none;
	b=SKIAUPQSw2LgqBX1ZkY7GBnU9w6W066wklttLHsFddf4CMB+LIm3YVS9veJpoMeeCbycjV
	BjzhLi+iagLVKbUAzG4tJsPzA5gBfYId9mr7cLwDz4KScbSKUGP9xaMqs2ICIGzX6dice2
	rzU6TirvtwZ37brtVVYVa0hTJcoqdrU=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-63c0c9a408aso10469406a12.3
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761062919; x=1761667719; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jxaUYavdFNgjliOqAPTDoGj/sgS4UHn62o4psiKVfI4=;
        b=RP+DCSdBxq0zU7QofIWOYhm8wVPD9j+uXpBR/DfE4fOFHLhTaJj8W+oCpgoeobF/IO
         l9t2RnqlTV10GZHp6NCiyZ9lgdGPcuvD+SmwV4GPqMi4rOTPS0rIJ0yEJQ1kNtKTRzH9
         AxX7Yvng/Nir/N51p6WS7L6QO9yqRopkfHS9UKiK2XoMkzipnNE0nHoIAUf21bMvIYLf
         UE4bRvdqZsInJeaujA7Ke/5/SFLaHfbOmn7dxOpAYNMywzvKOPO0C5ejFE9Qrf+s7vtP
         5rqGCUlWIKQfeWW3BEJoz93p5HEu/6YkbJZqmoOwF2BNJAfIjQajoIftNNF+kp8mKTc8
         7hGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761062919; x=1761667719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jxaUYavdFNgjliOqAPTDoGj/sgS4UHn62o4psiKVfI4=;
        b=vjC/4f+esUrDn6vqXeYmAvj+XUChw8ZVpeuZnHawXwSiAJo49PP/ZzjJAqiuENjmxT
         RZuOOl+3nmx5GmMqdNtIp6OcxSVUl4SaoLwaFoHhMWcmEmAODiPQmcEEpeDBiep/lEQn
         DrEADuMgBSDaFsRsnOKV508xvybLe/2GHqT5Zvpc+eCZIXvGCZQQtI/XlPdcMSNgzed5
         I23P9pxwZGywoD42Dqi3GY7Tnp1Qqn6proUIShkmlRv7zgVgoN4fuAMjcRdgF0hcdMIH
         ia2r/MqwUkJ4Ty+qO6ZnRTVL8UpRnFq4hjL5USHul9fuJ2S24ZsBUr1mwcCuNi6oyJe7
         S7Jw==
X-Forwarded-Encrypted: i=1; AJvYcCXmhAiu8lfH1roq2/qC+nabT/xlfWj0NQX17wHw58liRaJ8zgP09tFyvg+ABy/AnwtDstPPi3Verw==@kvack.org
X-Gm-Message-State: AOJu0YxdfQv5DiwU0/NH5kVRzgGR4Krgz9ZqJbfV70gc4XnqsSEsRKK2
	KH587pp/Xtgf8VfsHS6E4r7p6cESdOc+3Nb5rue5SOU/cEmLgUOphHl/hxSk1pemP7NKZxK9UDj
	mjAr1mmArcS/rM4iJhzwnwBrl1RrJEKwv6KGBIBdLSA==
X-Gm-Gg: ASbGncs583KcdkqF6PkBg45s6s4JShNzdwD4mUoBWCPw688/JB3JMpyGr6GnHEEza/7
	HddFcTc474ckwjBEQE2M45kLi/8LgMG2BUWIflnnJKK3sfXmayLmjnlxhyXScuUwRlTmUoVaIWX
	+hUJmMY+GLWfY4nxY5F2R/iYsWAmt+ct/PDZrdvLLY+L1NONGDDS8XqSUQFql+USl6zMqoaDMBc
	fCfVa3Zks5yF9NxXVCQ5D3wp8QtMDsvfTDfII4aOqAEAbGVJC1GZR9XxM9U0/AFs7ss5zW4mQor
	zV4=
X-Google-Smtp-Source: AGHT+IGYvj0cBBq3wGSoiNp1CoIJkYDF8ytokgZ/O7ati7otorbUHmL5FNnl4y1k4W4RaajJu5WCCQ85CcQM/eQSHZw=
X-Received: by 2002:a05:6402:40c5:b0:637:e4d1:af00 with SMTP id
 4fb4d7f45d1cf-63c1f677665mr17049736a12.10.1761062919175; Tue, 21 Oct 2025
 09:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
 <20251018171756.1724191-2-pasha.tatashin@soleen.com> <aPXoKRVAyGWCNj8I@kernel.org>
In-Reply-To: <aPXoKRVAyGWCNj8I@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 21 Oct 2025 12:08:02 -0400
X-Gm-Features: AS18NWBcHGkJXGG0ZFCeY6uu-eAVSgeT1z_110jp41TVdiVY4QWXrqa-qnZgrXU
Message-ID: <CA+CK2bD9RHEWZd+t7kWFxofOjBVLd-e+gQTheNJxZbSFy84rfA@mail.gmail.com>
Subject: Re: [PATCH v6 01/10] kho: allow to drive kho from within kernel
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net, 
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A545100018
X-Rspamd-Server: rspam03
X-Stat-Signature: urdejp5zbqbj7ohoz37zszou5re56is9
X-HE-Tag: 1761062920-282281
X-HE-Meta: U2FsdGVkX1/DhiFKMmEQ/CNzrohc89+iwsY7EGuAGuES9nFCkbbp1QSfvpMh8SQ4u0oYQ9RLPlF+w9tylhdD3y2z/EINp/9orare+VdQmmGjuGu7IVS5hQ/4Hf81GJicPyU5RNsy6ZpsPcTETJTzC4qqXGAi3NWyqahElAovvXphcUiqZZaNz8cTnAyjr/3gfxiK+Hi42hzZtbHYH9PNNexYawFwTXDakbO+g4cnM9d31ubmKeaeI63cjs4N2SAU/fBZHGCIph5SO2K5oENtfIRXi7FS2hiCv5jFErLn89JhrdF3zS286MxcLMMXobrseU2oNorEN4yrTMUNdwcRfiEArA6J/X6JmnofXTpPjGzuuZaRQwRO/saNj6BU2NGXW5PfLFIJirOIhGn8pnEjE04uDmfuafEK8xFPHvo27uiET7L591h3f9vsjHTjGCTyLx/hsa2IQ6Rvm30zEAG66rwD0Zbh9jCP4Zo5MpT1qUO7IdNxCmmVIHJIumAwE+Lng4MbV5PkgFjPHyGzs37ufMMdGI6LMRYd5jVKWa3qaA7aV3UNIxtARRFulucve5INlAKJZc1KftJNqXaX7OtWKMIWIlemE2H4hBm0WqbKY1jPEFhSVMzhFOxmQy06o/ojy/c/BepM7Lw+9IM7wMmu8LUiWAXkyMT2HlXGb9iDZU8bRvpeHcvyK/MEVRkKjPOgHZUW6lFuXAb6hh3lReQQw2SV8t8fUFEbUHy13fH0CxrtS7XtJ59gWXLaoRNrgNDBMKlTSM0cos5/BJmelCyyBAFr75+bglxLEpRqOHWbxzS89k5y2blOvQsK6x0KeLIAr+mFE8joY/gIV/8IowODUpISkV/Ll5daKU4IYDy27pZsuHC939TMwAHvoajyr+Hk/RvkULhNyw9v/4LoE0BOxMjNi4fpREa8/A0PUwqB191x56D2ELXiS1PiRi5TB1H+MQhtDc3SJhmZhnzYL/A
 p0NS3VGs
 CtvyfoCbn71RlETHpNfd8eATtP0qI0WZGtX7X+O/N9xI7eSq0i9tI669L8NVSMPR6i6pYAgz0ga+7yXzylv4gpHRdkdV34kxRJaqpxinO8jdJrkamOz/EOgD9yjCniHRHFa15dDDJrkytW1xHxI4GZvSnWIUqPa/ZXdBYEAeyIy15fBcK7kM2L3p8R/j/O/z0ihvgPMzyVoSLOVIh7tpCshsV7L4kyaelEOQUDHknjrpNmHv8bZ//fnrRl6ggDtK3l7xwZU9ltl/XvQIm4XP0A/Tr5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 3:43=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Sat, Oct 18, 2025 at 01:17:47PM -0400, Pasha Tatashin wrote:
> > Allow to do finalize and abort from kernel modules, so LUO could
>
> We surely don't want modules being able to drive that. Maybe
>
>    allow kernel to drive finalize and abort without requiring triggers
>    from the userspace

done

>
> > drive the KHO sequence via its own state machine.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> > ---
> >  include/linux/kexec_handover.h | 15 +++++++
> >  kernel/kexec_handover.c        | 74 ++++++++++++++++++++--------------
> >  2 files changed, 59 insertions(+), 30 deletions(-)
>
> ...
>
> > diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> > index 76f0940fb485..76c34ea923f0 100644
> > --- a/kernel/kexec_handover.c
> > +++ b/kernel/kexec_handover.c
> > @@ -1067,7 +1067,7 @@ static int kho_out_update_debugfs_fdt(void)
> >       return err;
> >  }
> >
> > -static int kho_abort(void)
> > +static int __kho_abort(void)
> >  {
> >       int err;
> >       unsigned long order;
> > @@ -1100,7 +1100,27 @@ static int kho_abort(void)
> >       return err;
> >  }
> >
> > -static int kho_finalize(void)
> > +int kho_abort(void)
> > +{
> > +     int ret =3D 0;
> > +
> > +     if (!kho_enable)
> > +             return -EOPNOTSUPP;
> > +
> > +     guard(mutex)(&kho_out.lock);
>
> Please include linux/cleanup.h explicitly

That is going to be included via kfence fixes which will come before this p=
atch.

>
> > +     if (!kho_out.finalized)
> > +             return -ENOENT;
> > +
>
> ...
>
> > -unlock:
> > -     mutex_unlock(&kho_out.lock);
> > -     return ret;
> > +     return (!!_val) ? kho_finalize() : kho_abort();
>
> An 'if' would be cleared IMO:
>
>         if (val)
>                 return kho_finalize();
>         else
>                 return kho_abort();
>
> and we can rename u64 _val to u64 val as we are dropping the boolean.

done

>
> >  }
>
> --
> Sincerely yours,
> Mike.

