Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8742DCA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 16:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDF7E8E0011; Thu,  4 Sep 2025 12:24:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B90918E0001; Thu,  4 Sep 2025 12:24:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7FAA8E0011; Thu,  4 Sep 2025 12:24:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92C8F8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:24:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 634E958438
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:24:59 +0000 (UTC)
X-FDA: 83852091918.15.5A1DA46
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 699134000A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:24:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VEBSd5We;
	spf=pass (imf12.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757003097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFT2XNmKJMqJjJ79Z4MTMpVJ3yD1gMC0n0BoP0X9opI=;
	b=2ohl1KJQqtcEU2wa5QiPhYXkkoRl7a8yYGcr9Nfj8hU93Ef/UexRQnhASAh/eG6gxlxkGA
	2BnAK2aaTkZk7w+2kc9e9yRnbrGCtKmuPxYOnT8BT/35InHT0QUApYsvn3ke3vqSF2BpoA
	P0EWKK9Ag0ft//HUS/ag2qH+XX62Gwk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VEBSd5We;
	spf=pass (imf12.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757003097; a=rsa-sha256;
	cv=none;
	b=tL2i2iYk3vi+Zo/umApC2dMJZ4uuqbON1czaiyYImnOhjmei7cUCk24i1o81iHbXAVdmw3
	Jyffx0zEH+Qj9stuP6yVwG3Ks60tZ590N8sZY0GCAqOPW2+477kmkpP+GIYv5CF254isqV
	3zfqAeST7uQRmYJ8WKfwCM8+IVmvqig=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-24b2337d1bfso233555ad.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 09:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757003096; x=1757607896; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LFT2XNmKJMqJjJ79Z4MTMpVJ3yD1gMC0n0BoP0X9opI=;
        b=VEBSd5We+3Z1RL50CYwSlvLqQ6aTGGCwcfsKLMW/IxTGTLe+gKz1I2fAXGVvz5DK7l
         aj9RLbIFXjCOH2rstrk0ccBAp5vHBD6kz3Y+07Nihcy6RLmWip0H3ozje84rMN2a3htV
         d4D5W7VSKpwDvY4RYYJlzFBVPd3qNP3eMLncWMXYk0558NVIsVDOfR67qGHjLieCNykA
         /e0q1kofd9c+jJN4EoYnnm3PV5QJt/v6Qybxv64xRQ7i8J9G2tJNG0T42IVzjZxF0veA
         SEyZX3BRyGZTCb6p5PSDOpW8YhV/VHeCuxLiMcuAAHF7kUqX2IYMjSl+9zQ2zjKG+JEI
         vUbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757003096; x=1757607896;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LFT2XNmKJMqJjJ79Z4MTMpVJ3yD1gMC0n0BoP0X9opI=;
        b=k8myC+RwC/IaMBrOK8J/PGmdR/rcYjoL2WBpusLAz6BHBkl1fvtZ+Vywar+/yFCtDq
         9SWp+FILt4YDDW1GAmr5cd/cVBEjJiDXOwjGIWuOYD8ffUkWnYdsqePOU/vH3ceM9Pzp
         QQqDHBntxZ4tyxGbiJXHINWsRE2Tx5+3ITFgywqTgZukniWxKolSZBbRZeiQ/Nt+FRYY
         vZ/RZ2cLvhQO/StJknpIdXVlABNt4IssBoSk94WaTLfEL6m/ihy5TtsVz8AzjI0Ongw3
         jS6TPBRsmlwOuCkT5gZAXpWpnUuUMeuYHX7Erqh0TwnEqG5gN6MfWs3GACKU9BL/G1p6
         ib5A==
X-Forwarded-Encrypted: i=1; AJvYcCU/rcYPxZK0S2bpVPdhjTTc5xxpQ5X8mF+Sho6/+u3ybAdWhZqcNVIkhcLA3wsSJuM7Ak4VfFQKYA==@kvack.org
X-Gm-Message-State: AOJu0Yzov1aYE7JIuPAls5Ndvnk420W4fglHLgcLqeYe3D7S2WvuPd5b
	/1UW5sXW7TCiHSS4NEovCW9cq0FK2LOEjelf9d70KZgUFbG0AKd/eY/ushKSRwctCKOD7d4HfdV
	jmPw8aXfjJpwx160os9n/K5L5YWOnAnUVbAJYFJbk
X-Gm-Gg: ASbGncvZu+kRBKRL0D0Xmqsc/jVzyBkwWHI6frlHNxwObhJnhd32Ki6KGqgf5W3VcTT
	es2pbk8mvin6SdvUm6AqKGWKaqq+vgfNqLwWMq5CeFGNv4KnQmCJOBmu7qhkMWBy51TcZYQ6mgx
	w4A8miQB/kjFFRCVM2YExj16y3L9aZyld35mfYeAB2d+QUAMeNfHVpVoLtyA/ZFfxCxHhNccYfj
	xQb8QdjKgOF7GxYm4PyeDHNYny1rRmWC8XmU4nrMVvWN4QmJskfaac=
X-Google-Smtp-Source: AGHT+IGAm0XmOGNriB4QaIFnEDqerBTh/T4Isup/MLFm4TpGRkjTg+tlhc0v5DUDCXYa4WATyHeEEilzLQTs3FmdcfA=
X-Received: by 2002:a17:903:186:b0:24b:131c:48b4 with SMTP id
 d9443c01a7336-24cccca62b7mr2615175ad.5.1757003095906; Thu, 04 Sep 2025
 09:24:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250903232437.1454293-1-kaleshsingh@google.com> <3997965c-4cc6-405c-b6fe-a70b4e75afa6@redhat.com>
In-Reply-To: <3997965c-4cc6-405c-b6fe-a70b4e75afa6@redhat.com>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 4 Sep 2025 09:24:43 -0700
X-Gm-Features: Ac12FXyI8cT7GjNmqWKUiyjar1SUg-FKukKdQAYqgi0-iYI-lyutgx2yN_rj1rQ
Message-ID: <CAC_TJvc-V9=59p0HG8tmUqQHmp5Sn3E8BV3gHsPj+RHCANd0HA@mail.gmail.com>
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	kernel-team@android.com, android-mm@google.com, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ri3w51oi5j1453dstx6rxkwbaxodsaxj
X-Rspam-User: 
X-Rspamd-Queue-Id: 699134000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1757003097-538940
X-HE-Meta: U2FsdGVkX1+Qu7yu8ZTlFi9TfV033ISf6QPhGb/yKdn3zhlWPL+2eG9+G89iaVxT46zbo2ds6oTJSPWTuiBltaoHoJxHcxoFSkP4J+vBo7ryY9VcLyf0I56RMxjYQkCUBPPwuwCDy1o4wiYkqnZeCb9xWhBf5Uw6vJLn145asBX0m445OH3as96GX9qRJxBrWchUd/RuSynzsYQf2FYBvyhyC7H4NcGbd5hKBEfQMLk9fOgEkE3mMGa0YSVrNWV9JL4fXg0sxrllsF7ynT7isFpTr9c+XhVL+7mcWDy9orc1ohPqll4be4jKOrG3gk1z1km5NCABSfR9zpX88YIjgaGMPpmH2qKIyU1PyiDo39kT714xszscED0ZubRIwAtGjl3kZIXin9UfjNFC+0sGUh4k8xMi0MgAr5d9l01noiJRbDvisFolFnEVe1vNGRb1erugxQbF/OBiNOP3ulLoZexFFOPLlRzzckTFNQFB6Vd89gNAjz45jXjdjwj5bSAsFar+xZjdsNsdm6r6VEa8YNpm9qVbj0QOHDKWWmXV9mXIPokkXZjOgYV3ubnxZP5njhR8EMXIGDFXnyVBAe6JnIqYa90S9wEOoPEpFKCfZMwpfIaU61Bk9SEoKXWOUGt7OSOa77R5fFJFDi++9gxHu5BomBirUDULMGOVTxQWMYulsXIFFE6Oe+pLLUdMgRZSKTjZphmApSyWdTQ8ReTU9QpfVnPZX2q7Jn45rzUzG3xopYQmBAj2xuzsEgak418Y3MZgSnOKr5zS/dPoLF9Mb55smUEiXlKqwRJGfDQXvXQTMBKvaWJaxRGuPqbe5CNqGP0e9tJ9PgNqngp51rajQUO+mzj4I3otd/3VdZXJO03WM0sOt3Qa3/RdDj9RhFrCz2Swv4qi81Ck7ZMq/r7ZEGnCOyvwtbZ8oxOE45DVDvkSI7fWLUF5uSKNIkGHrtnbCOZFPFd6vGMci3poPSz
 fnDzZo/M
 dr/6crqh6eK+IQtHNU6bfEQqHyjI4Jto9+oTx2AweFpkVGLrYd2Ile/2ps/3h8I9E6utv1YCcnLf0H/t76oqGwTCsuyaj34xrbt6GCzFsKtbtdH1YJl+OBGKCfF89xzRddccbzG3pu3c+4uBpQ3UiWHZ4Q5fspcKDCo8tLY8IWe8JL+t15T5DHah2iHFrilS+ik5JknfRSZ4P/QMdcQA5a2a6dAu032c0+RiiF3EfOZOpMC4yNQsqHZ5al3fyzpUSU3+2HcXxEI03LCw5pMdzXqfT7uMeASlsdT11SkpFtEIzHKVYzpmKDAjkt0FpR2JA2WHXP7/VuOij/O5TimmIrBhe8JQTkU3i/cU0PYo537/dRxQpZHrdQrxkKls3hkrdPS8l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 4, 2025 at 3:14=E2=80=AFAM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 04.09.25 01:24, Kalesh Singh wrote:
> > The check against the max map count (sysctl_max_map_count) was
> > open-coded in several places. This led to inconsistent enforcement
> > and subtle bugs where the limit could be exceeded.
> >
> > For example, some paths would check map_count > sysctl_max_map_count
> > before allocating a new VMA and incrementing the count, allowing the
> > process to reach sysctl_max_map_count + 1:
> >
> >      int do_brk_flags(...)
> >      {
> >          if (mm->map_count > sysctl_max_map_count)
> >              return -ENOMEM;
> >
> >          /* We can get here with mm->map_count =3D=3D sysctl_max_map_co=
unt */
> >
> >          vma =3D vm_area_alloc(mm);
> >          ...
> >          mm->map_count++   /* We've now exceeded the threshold. */
> >      }
> >
> > To fix this and unify the logic, introduce a new function,
> > exceeds_max_map_count(), to consolidate the check. All open-coded
> > checks are replaced with calls to this new function, ensuring the
> > limit is applied uniformly and correctly.
> >
> > To improve encapsulation, sysctl_max_map_count is now static to
> > mm/mmap.c. The new helper also adds a rate-limited warning to make
> > debugging applications that exhaust their VMA limit easier.
> >
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Minchan Kim <minchan@kernel.org>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> > ---
> >   include/linux/mm.h | 11 ++++++++++-
> >   mm/mmap.c          | 15 ++++++++++++++-
> >   mm/mremap.c        |  7 ++++---
> >   mm/nommu.c         |  2 +-
> >   mm/util.c          |  1 -
> >   mm/vma.c           |  6 +++---
> >   6 files changed, 32 insertions(+), 10 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 1ae97a0b8ec7..d4e64e6a9814 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -192,7 +192,16 @@ static inline void __mm_zero_struct_page(struct pa=
ge *page)
> >   #define MAPCOUNT_ELF_CORE_MARGIN    (5)
> >   #define DEFAULT_MAX_MAP_COUNT       (USHRT_MAX - MAPCOUNT_ELF_CORE_MA=
RGIN)
> >
> > -extern int sysctl_max_map_count;
> > +/**
> > + * exceeds_max_map_count - check if a VMA operation would exceed max_m=
ap_count
> > + * @mm: The memory descriptor for the process.
> > + * @new_vmas: The number of new VMAs the operation will create.
>
> It's not always a "will" right? At least I remember that this was the
> worst case scenario in some ("may split").
>
> "The number of new VMAs the operation may create in the worst case.
>

Hi Daivd,

You are correct. Cases like mremap account for the worst case (3 way
split on both src and dest). I'll update the  description.

Thanks,
Kalesh
>
> --
> Cheers
>
> David / dhildenb
>

