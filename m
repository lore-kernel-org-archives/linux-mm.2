Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3972CE8D66
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FE518E001F; Fri, 14 Nov 2025 12:48:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AF598E000A; Fri, 14 Nov 2025 12:48:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE03F8E001F; Fri, 14 Nov 2025 12:48:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DAFCD8E000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:48:03 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 88B331603FA
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:48:03 +0000 (UTC)
X-FDA: 84109946046.14.A7070DB
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id A151E4000B
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:48:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WoItjulL;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763142481; a=rsa-sha256;
	cv=none;
	b=LbBPWkkv9y3CzSYzaLm9CWoOeYS96lQHgYGHGdQJj2ogKLVS5nIFKfCK3DdZWmXhOre34E
	sx5C0F/+dZFxU1HJNvN4diz/qYloQfgyRJDsWKn9UhY3i6eFjaA6sZw/+gbJHx+AhonHez
	IkpWmseuPlo3nWfEKbdqVQmRjMx65yY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WoItjulL;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763142481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zbn9p1VuyYMk2i0qgvr7OVfrXyGoZz9FTwk/+35lXQ=;
	b=bbdMHSqwjd2Vzk40pX8eIt1yQGxHrviF6h2TLH4jXR5tlnABdsDm4BY9JOP6Xi0zJ9swhb
	yIk5z2myNOKfWH8lYy+Ognw3SP8ccLkdwnPMdFcbv1wBX5scC88vkma75YANR/gtF4KEVs
	QKdqMD+5tLOwXjNKKNQfvlV3YgBMHYk=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-640aaa89697so3147873a12.3
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 09:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763142480; x=1763747280; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zbn9p1VuyYMk2i0qgvr7OVfrXyGoZz9FTwk/+35lXQ=;
        b=WoItjulLSmDS76I7WE29qVABUBvPlgK39fhoGcNsNswn5V3saaIchzyCu8CAMkokK7
         Jlt/YiyFushwCztBIi5TOsJOXXKBfXL7Cd9j3+kc9nNU9R85mcMejjoVe3SGneYIr6lq
         M/4IiG5YQkVKvmhxFQc0p2WO8MNMACrmT3vxKjjJPQ5TLHus7pZ4jwi8bb3YIPK0ILE4
         XKShz7kSqODQzn1TOzXuP/YTExl3lbb0HAQ39YjeDqLFC10K3dnDQHbRqZzNkES6jUpK
         rgH5djvDojyt1D+7J9X/aY6V2CaRmz6fYNNcwYLDWtqIOd4co83fkZSaCj3yZK+2FkHs
         ZnaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763142480; x=1763747280;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+zbn9p1VuyYMk2i0qgvr7OVfrXyGoZz9FTwk/+35lXQ=;
        b=WCF72w7YA7nLk5Fdr/+hjY/L2PjYtGWItwq6f69DSu9A9XswdARXJgOG3u98yTxtgt
         plx63nNN5vBzik1wlpb0ZD/K5JH3YJb+LCOSVxTxYqIrLm1e/noVSvwcrn+cFGrJDGHL
         bbbveF9jnkfrG1TmswxcK9/Ky9CBeRvX62IR7H4YmM7XrE458ki7wJELsvwZ1daG5GXQ
         WIP6Ei9vY/XO+I60KslSeg7KyNFnJzQ+2T8c5gHiQ0zVOOcw1QpjrnV/anhireXNUF1w
         OiCbG5iACTS5lzGi3MXKxytfRdN/kkQUgeeahjygmXWNyBzQKmi6pKCI4nX1bGv0MCh5
         zbRg==
X-Forwarded-Encrypted: i=1; AJvYcCXuEVwm00DKc4AgM+61ore7bqIqTRBwtdD5gAsQk3epzdD98t08LKA+q2n/Hgu8dX7TwJPp8YLQlw==@kvack.org
X-Gm-Message-State: AOJu0YxAxev5MfNHlgTxT61OfC6OG6QAI1IJgXLYZajtoypuXQCH1Pi/
	ciY66yI4qjC3F0/ZC8MscPWh/oSYrbPLoHiBncbO4D2JDyx7MwrVlIop0JXgM+5J4fG+eggJudl
	I5THPYs7NDqTg3c+yo2ZPs4ka6XHw9eWomeVnSlfOvg==
X-Gm-Gg: ASbGncsbMrJgXVgAknRUQxU+M414KPznfzN6Xbr7Z20NOav6YQbk/2lkqCyebQJY/58
	JAL9S1liyxEAIO8lrl2ZqzPE0CBkhlLSLUO8O2iFiP3OVgmfx6WntQkT8jhWGGxlk9WD490yW3T
	HAqzCqvMdcQ1+E1ByNc9qOcnH3CZ6WSZrBN/S4Nfvepn6Ghk/aID5bO5djjxeAnmZLjMMTGar3I
	VeH7+srk7dMeIKDmcY7iD3o8QHkurzNvB7SEF528hk74AIQIfj4A+InLZD6RMop7CnIG3PipUhf
	yWI=
X-Google-Smtp-Source: AGHT+IFQhVRqfKMxnTXFqt53dbh9lEJU1FDUr5KWPHxGUp6CjT22Lq5xHtZYP0OnXMk43mo1GItUtGSGw951XYijv2o=
X-Received: by 2002:a05:6402:2813:b0:640:9eb3:3686 with SMTP id
 4fb4d7f45d1cf-64350e8e398mr3485744a12.19.1763142480101; Fri, 14 Nov 2025
 09:48:00 -0800 (PST)
MIME-Version: 1.0
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
 <20251114155358.2884014-12-pasha.tatashin@soleen.com> <mafs0zf8o5xjk.fsf@kernel.org>
In-Reply-To: <mafs0zf8o5xjk.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 12:47:24 -0500
X-Gm-Features: AWmQ_bmCljt8tZlfSqASZeT1KUJ_yGPGwIPhaLXLETZu6fzjOFak8efk0-r0QcU
Message-ID: <CA+CK2bC99-VwzuyB-0D=z9H_zF6gnH-EX1USf-Ox-fwGd1s5dg@mail.gmail.com>
Subject: Re: [PATCH v1 11/13] kho: Allow memory preservation state updates
 after finalization
To: Pratyush Yadav <pratyush@kernel.org>
Cc: akpm@linux-foundation.org, bhe@redhat.com, rppt@kernel.org, 
	jasonmiu@google.com, arnd@arndb.de, coxu@redhat.com, dave@vasilevsky.ca, 
	ebiggers@google.com, graf@amazon.com, kees@kernel.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A151E4000B
X-Stat-Signature: ssngst7h739pw6b6t3jcwetyr1s9unac
X-Rspam-User: 
X-HE-Tag: 1763142481-478884
X-HE-Meta: U2FsdGVkX18voP78BLbZ3Ll6tRqzA3LEIHT4kn7khs7iw3d3iNnY0c0SiwLOEnhLgV27qxkWP9hJTBhOkfZL1xjaC4hO5fZWFvOl/wSAaAHUCLROKj/hcd7JqWvMlf/vvV7hKgkPi+nE+PdZFyaHL8ucqgp6ZwewUkAwwyq3f67JC8Oxp0LOT82mVpRr0CQ6JWw0j8npgY9J2Kd7McZ5cDJ5k/ON+3ogKXES3f3+/fvrpoN7R7eCp79oTopFRqCcWVePVCImCsBFS7YqVgo0Qhx1cWA3ncyxKWy3iEbvy41/UTG6klEh4fKuP0vwS70NEaYf9HfR9FmqbAPMnzC9KoK3xGU6ZjDep51HVNEGwXf5hyVYWwlJY7DBwjY/o+a5e2PBhWcFa/aAb4mp0t5cDSQ3PUGlCmwT/N9yP8mnz4aovtcjcXGS5RCUcelDKOjlsnpX/KEJndglTi+NA8RziOYox75+sFJPUbKSVMvBnOmUW/dFot39zuPiQDzQyFgzkNWWU0CVXiJI8yXPqWME1LT0PZ/e95xtDDZnoDIb9Fuk13B74jzqJS1KpItB9EnUgiRHkOwpdZU9v4RqU4h3hU3kgT1kqgWP+oV2odwyVXYEzpI3pxqzIbX30H7RgIvhlhqiT+JJ/NjN+nfCcr94ges42R0nWMsaGXOTYupI3gVcKB7hE7flddaveeaBysYRwJb5uY4KKR1i2vNYR3TDvAm2/OiQqiIz9Pq6cdovfUcdlKAc6/2SqgX8gF8MdvBEqVJppTz2NwJyBkNECRvR/9Zj1cm+zn+dROlFjHkUeMw7AlxSBn/f5VvZO2+xOCvDhl+n/fskxFwgwK8ugldWI8VryTBZ3Y1k/WyOqSmCZ3N9YJNPWVkeMVJd8x3Dx+0zrqd859kl7GuMgfX5CDkPPGof53uoaq0+4YBYSpKBS2q/ELefsRY1vwtKDxlWKS16TALlukMudFR4SEYnEtg
 JjCG9rwq
 hdC+Og0MQDfOUu41YLFY3EXXWSw/VwWQ/94cwk9I6qOs8tyaq/YYbSGEVrqI1gJmx4nudKlH/UiVrmPDtu6bHwdUsFudET2EKUvNfJKlFKbKGwtALfrGzdfLA4HW2O1yMacnCNn2KEq/KmA+R4qfh/jsBWoMNsTgVwpqll2QkRhTofWbL494O4rMtBcz0WpZ+qAXv2gcL1pSff2sxsXgPqIhx0BS4dAC/b1Je8T9+zd+Zcc8ElHO+fYI7JSSp84Z2ZzZvG7K9+cUdnDhqmCOxMV/GaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 12:33=E2=80=AFPM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> On Fri, Nov 14 2025, Pasha Tatashin wrote:
>
> > Currently, kho_preserve_* and kho_unpreserve_* return -EBUSY if
> > KHO is finalized. This enforces a rigid "freeze" on the KHO memory
> > state.
> >
> > With the introduction of re-entrant finalization, this restriction is
> > no longer necessary. Users should be allowed to modify the preservation
> > set (e.g., adding new pages or freeing old ones) even after an initial
> > finalization.
> >
> > The intended workflow for updates is now:
> > 1. Modify state (preserve/unpreserve).
> > 2. Call kho_finalize() again to refresh the serialized metadata.
> >
> > Remove the kho_out.finalized checks to enable this dynamic behavior.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 13 -------------
> >  1 file changed, 13 deletions(-)
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kex=
ec_handover.c
> > index 27ef20565a5f..87e9b488237d 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -183,10 +183,6 @@ static int __kho_preserve_order(struct kho_mem_tra=
ck *track, unsigned long pfn,
> >       const unsigned long pfn_high =3D pfn >> order;
> >
> >       might_sleep();
> > -
> > -     if (kho_out.finalized)
> > -             return -EBUSY;
> > -
> >       physxa =3D xa_load(&track->orders, order);
> >       if (!physxa) {
> >               int err;
> > @@ -815,9 +811,6 @@ int kho_unpreserve_folio(struct folio *folio)
>
> This can be void now. This would make consumers a bit simpler, since
> right now, the memfd preservation logic does a WARN_ON() if this
> function fails. That can be dropped now that the function can never
> fail.
>
> Same for kho_unpreserve_pages() and kho_unpreserve_vmalloc().

Oh, this is a very good suggestion, really disliked those
kho_unpreserve_* errors.

>
> >       const unsigned int order =3D folio_order(folio);
> >       struct kho_mem_track *track =3D &kho_out.track;
> >
> > -     if (kho_out.finalized)
> > -             return -EBUSY;
> > -
> >       __kho_unpreserve_order(track, pfn, order);
> >       return 0;
> >  }
> > @@ -885,9 +878,6 @@ int kho_unpreserve_pages(struct page *page, unsigne=
d int nr_pages)
> >       const unsigned long start_pfn =3D page_to_pfn(page);
> >       const unsigned long end_pfn =3D start_pfn + nr_pages;
> >
> > -     if (kho_out.finalized)
> > -             return -EBUSY;
> > -
> >       __kho_unpreserve(track, start_pfn, end_pfn);
> >
> >       return 0;
> > @@ -1066,9 +1056,6 @@ EXPORT_SYMBOL_GPL(kho_preserve_vmalloc);
> >   */
> >  int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
> >  {
> > -     if (kho_out.finalized)
> > -             return -EBUSY;
> > -
> >       kho_vmalloc_free_chunks(preservation);
> >
> >       return 0;
>
> --
> Regards,
> Pratyush Yadav

