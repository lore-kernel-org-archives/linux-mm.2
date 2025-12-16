Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EB0ED609AA
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 15:36:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FF696B0005; Tue, 16 Dec 2025 10:36:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC596B0088; Tue, 16 Dec 2025 10:36:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ABFB6B008A; Tue, 16 Dec 2025 10:36:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68E4A6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:36:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1D28C60574
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:36:42 +0000 (UTC)
X-FDA: 84225736644.26.9348D41
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0E78F40004
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:36:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XTG3Pj52;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765899400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kyhO0Vu8BVEr0KLG4JdHSpLvhjfSxro5PtVmRdfvFt0=;
	b=ZA9bPbAXAq8VWtc6+oZqOpYSliwuDfyKyXAaxQ81oZhUhr6Tg0ZzNzkgv9pyVofGcBECTH
	zBugfhkCQ5CJDC4/dW5kko+nZr3ps7H7ZKDIOv81qW/MqKvWmQdJ2AY9ZD6zmwU+GDf9X0
	qSZbmG1luCLqJSwmVRacuKpA3qIy/64=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XTG3Pj52;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765899400; a=rsa-sha256;
	cv=none;
	b=je+FWEHe6zrEpWTXFr2EhVaUKzskO1w87eujOSjSDVEY1qqmVb6CFVlzx8QIHjbLGXOGPw
	G6vRiKt6IVjM+vnlwRMdQAUMvrZYZKRfo8BgibtY4eKfUGQfJxK6vMQOwhurkwxAQKbW2/
	+7gyZK5G23ze3594Z2jYwcyimT82KMM=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-640ca678745so9196139a12.2
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1765899398; x=1766504198; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kyhO0Vu8BVEr0KLG4JdHSpLvhjfSxro5PtVmRdfvFt0=;
        b=XTG3Pj52UXTQ5Ec9LzeBRiPdK7+BjvhRpl9bc5lNwx7wBfVgWTZVkScXvwMvrtEku0
         w4mHFJRgoZBrSLVBHykH3F2L8CQCn1/QSFsitQBgQHgLRkPv7BuUt/Mk5OSxWnjPqnxM
         SeZDPrijq3llyRT+07wb+jjWJjdPcdXB2vhoeoX80IL4MJo6lYamzSa5EgA1bpCnYLee
         2eaizC+xQNekZRzuopmgV54zNVJClPGc2m0fnPbnAJ7kQhv/i2stujVNMNTZ6ysY15s6
         jAhjSfGzsR80qluyrfGbVtdC+2JLC+aj0JCN1hILNn/e/oysfZko+OfK27upziNbkmgH
         X6zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765899398; x=1766504198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kyhO0Vu8BVEr0KLG4JdHSpLvhjfSxro5PtVmRdfvFt0=;
        b=ECuhYeOt0o9vES+ZX7EYE6fB945bYxr0n9bZBoNPLQdUf8AWbMuTCBlo2tgjjAYUCR
         0NhLI9GluMAhnTICdTZNaQAjguzYPtYQtqmkYrt7R48O6sauSMG/9p3RID+mOn1X+Rn7
         bFkwY0dErGteq0+ll+3dsQ5UwSU5yIauMa7UV7Oc9T0fFL69XsCjbl7p9bS/oAcmqeVI
         WuAi2AgRibHaPJb+OEjciTKJxZm9MPmhlmK2rvrpJ6aNw6BfAA6nQMil496tsrH7e70g
         XODwEzSbxdtQRIdN/8BZbQEMwayHJNiiXxxVH163lBCFnibiBAfJ6y7B8b1k7ugbexVg
         BeRQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1liS8i1pjvtkY0+POSg9UPgQINScMYRmaEYIf8N7RIlW8C85OgG3ANF1VXCfzJ5Bw4a6hebESww==@kvack.org
X-Gm-Message-State: AOJu0YwqffIlDZix90AxBr9y1C1G525ApBTwGnpMjFhbZqMVbUwAUPIX
	GtDQ7jFlBASmcummL1X9AlF4weqMurjcJqy8yYd59Khb2wm2uqEsQgd3hClMfv8kFXg0i8O+xBB
	y3sbrwIbH3xamikif16bY5PDIK2xiJrGJ02qChPjcWw==
X-Gm-Gg: AY/fxX5HD0tBzewLd5rHwM227LW/MyoXa0yXgcFOPSjbENxbmi1ubyctHyGxz3GEgmf
	HDDDRHmtknGxlqh7fGT0BaNG7pSU74RlInfiXIcwesfTI8GwZKMdqz9/icgMKufcH25v3GllLF7
	RPDEEU8o058RdNz7f5xSqRwwdN2O80FuxrqEF3Hnoa+4t0AO3yvESd9uN+Px9jXkXSuWrdobcmH
	/QqEIZ0RgJp+t1AmXo+cHN7GnCW6fwwRos+kEmP+LW6EplGKguWV9qIP44CYyZ/MedWSfF0ATPO
	x4vbEqTu2x6Xj7VUp4ErWuj3
X-Google-Smtp-Source: AGHT+IF1mzYKz9Pi/RdrX2W8Uy/2n5vpRPoElJEou5SB9bjQFnA433sUpyNaSnQczRJ6sW3Cz+taBB6TZqfVtRlhV4E=
X-Received: by 2002:a05:6402:2114:b0:640:947e:70ce with SMTP id
 4fb4d7f45d1cf-6499b12ff90mr15987210a12.5.1765899398395; Tue, 16 Dec 2025
 07:36:38 -0800 (PST)
MIME-Version: 1.0
References: <20251216084913.86342-1-epetron@amazon.de> <aUFJH9xzJXYOt_X8@kernel.org>
 <CA+CK2bDGvgcGJijAtSSa2k_FWjnZXm2jRiFd6Z9-XjEQ-Y68DQ@mail.gmail.com> <aUF4fsWwD9BswkFh@kernel.org>
In-Reply-To: <aUF4fsWwD9BswkFh@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 16 Dec 2025 10:36:01 -0500
X-Gm-Features: AQt7F2oykeBYe_aO9TrNeO_QmB0iVwu16-Lrz5T79UiOUKv88gfkA_WI_X2fFTw
Message-ID: <CA+CK2bB2mn5b0N9gs1UavYLUQhbpVvdo702oHZa15E9OaZkKWg@mail.gmail.com>
Subject: Re: [PATCH] kho: add support for deferred struct page init
To: Mike Rapoport <rppt@kernel.org>
Cc: Evangelos Petrongonas <epetron@amazon.de>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Miu <jasonmiu@google.com>, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org, nh-open-source@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0E78F40004
X-Stat-Signature: unpp95zhmpn6giq13cknz8foynawadh4
X-Rspam-User: 
X-HE-Tag: 1765899399-141868
X-HE-Meta: U2FsdGVkX1+WbIozBkgQQ3CmiTYi2+MyQzOl3vXWH842sUV1R7HfkIrWg1tugtOARiGwDLsVCg1/50hBQ4mQW9FAFK52MCxA7fbUeeoAtb51eoOTI9eZgT93deEnObIvj5NKTXQLz2peDGsDZBtHvcLj+UcytZppMjaWhAzJ2QCitlRo70/fLSVreadMGkB+pn0DlWwvyLgyxGSlRJNzavEpjDi0oHUyhu459p95kyJoB6MSUWVzGuDnmuU7e2jfMRs3wGft7KVm3Zxs9u5/LovqV0VFyOkZvCczSDDyOfsjpg8y4l0CsS486YP4I1Y0Ie4cB6nuqhbjzhwZ5pNIRKJiBkorjk7HRqD8fR3EZiSkTm/y/iO/0B4XAI6rzjObBd3XbVy6KzGqSjOFvRn72bZ8xtCLJbUxVEfw1kKYNK4wQoVD4XdEN82rm6Pt3Bq8t/IZA6TeErj8lY2m7n7USaZQ8hW8Q80wNGEqAPl44Xs9XiGYWt2UJhdGg8ugihSAb2n7gCnAr1DpZtbhjK2phTjOxNmyFmm35OT2mEamM3hmkHDFFxOcwP2E9gT+wFGss24EsxLRtAqxLhrkL3xnSQH6eJ8XZ9AddMGKqjlzsGQXWXtGFukA48LCg5i9him2+e2pzwC6tVCIsSlwZxSjOtre3gTms9Co2W7WlQPYpX5VU8L4mhod38ecDyKR5lDNZnKmQHYC7p/TjSeywHOKF/n8rO4PQgg8yCqXR4UkHEI4OvVijtm1XlScmRq+f/zZkJEZq0qkDSGIV0q73r5wBYFYm9AsBNfCztYp2wdKjaqiKOHWdOYrzHH4yqHQP/LXdwPMwweBZHu1/d9Qv8EUdsCcUvh8YnqH/3ugF0I78FzvRoUDE2Nk/2qJizcP+X9k4gLQvlsjA2xLQcv7iWBkCzcTH9pM4ZKJk1CDzE3XKMpzuLTjI7+usDg3pzWH7eidFDdwPWzEOqTM9o6PzVD
 8Q4ESSC8
 fBBuQUsMf1U7R4gv6ketjVb49TSKI3iZ85tovHD+k0cNXAtWlcULuh+OuPQufE/wtXji0J+LQn5mTEXpMV/tqEfWdZ++6BN9V8OGW9tWYIyfguNkEhvxAWL+10qBeHJadLbywBaJJRUkVK6WoL0lAuberiBrENTRMOo/K+DjTXW42pZTieUeJ+fAtbi1ACzAoKBosQOLza2iNy+7ZQ1I0WC6AKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 10:19=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> On Tue, Dec 16, 2025 at 10:05:27AM -0500, Pasha Tatashin wrote:
> > > > +static struct page *__init kho_get_preserved_page(phys_addr_t phys=
,
> > > > +                                               unsigned int order)
> > > > +{
> > > > +     unsigned long pfn =3D PHYS_PFN(phys);
> > > > +     int nid =3D early_pfn_to_nid(pfn);
> > > > +
> > > > +     for (int i =3D 0; i < (1 << order); i++)
> > > > +             init_deferred_page(pfn + i, nid);
> > >
> > > This will skip pages below node->first_deferred_pfn, we need to use
> > > __init_page_from_nid() here.
> >
> > Mike, but those struct pages should be initialized early anyway. If
> > they are not yet initialized we have a problem, as they are going to
> > be re-initialized later.
>
> Can say I understand your point. Which pages should be initialized earlt?

All pages below node->first_deferred_pfn.

> And which pages will be reinitialized?

kho_memory_init() is called after free_area_init() (which calls
memmap_init_range to initialize low memory struct pages). So, if we
use __init_page_from_nid() as suggested, we would be blindly running
__init_single_page() again on those low-memory pages that
memmap_init_range() already set up. This would cause double
initialization and corruptions due to losing the order information.

> > > > +
> > > > +     return pfn_to_page(pfn);
> > > > +}
> > > > +
> > > >  static void __init deserialize_bitmap(unsigned int order,
> > > >                                     struct khoser_mem_bitmap_ptr *e=
lm)
> > > >  {
> > > > @@ -449,7 +466,7 @@ static void __init deserialize_bitmap(unsigned =
int order,
> > > >               int sz =3D 1 << (order + PAGE_SHIFT);
> > > >               phys_addr_t phys =3D
> > > >                       elm->phys_start + (bit << (order + PAGE_SHIFT=
));
> > > > -             struct page *page =3D phys_to_page(phys);
> > > > +             struct page *page =3D kho_get_preserved_page(phys, or=
der);
> > >
> > > I think it's better to initialize deferred struct pages later in
> > > kho_restore_page. deserialize_bitmap() runs before SMP and it already=
 does
> >
> > The KHO memory should still be accessible early in boot, right?
>
> The memory is accessible. And we anyway should not use struct page for
> preserved memory before kho_restore_{folio,pages}.

This makes sense, what happens if someone calls kho_restore_folio()
before deferred pages are initialized?

