Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E235CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 16:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287008E0003; Thu,  4 Sep 2025 12:20:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2377D8E0001; Thu,  4 Sep 2025 12:20:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126578E0003; Thu,  4 Sep 2025 12:20:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F11F78E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:20:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C69F1602BE
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:20:49 +0000 (UTC)
X-FDA: 83852081418.21.4F3A3D9
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id AE86820012
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:20:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=G3yOV2v6;
	spf=pass (imf03.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757002847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e0t6bhmQA22wX44ktbmUqj5cgU/my1Kdps55OJZMqkk=;
	b=DYIMC//4P8/EDLBs9bk+JtjJCZa7WDeALCuVS2Nlo6ux0rNPJ4Aznt1t0k6p1kWHHwtwMn
	Z+pLZp/F9AU2l8BY0e7jGAILP7tejsNzOecxXSSP5YXBmxM55NGYFFI2A9/SjWSNT6bqkz
	Q+MIFmfw6GeTDfvvAJk+mtvhgKTepcE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=G3yOV2v6;
	spf=pass (imf03.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757002847; a=rsa-sha256;
	cv=none;
	b=WkhpW96Yifk7AyFvngvr1scjiVgaWHPXPKg9b+vRfyxmgybFfGPB8T0Ag6R7LkAtr5VICD
	kFhYjYtH7ChQ5IyoZjxBD3IeXjfBL9c0HJfrVNWQeHGWtG09OWP/ZzpxPYoh9UJUaS+zeJ
	wcQOY0F8ttCyNo2SF3xye4m0iuZlSfY=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-24ab15b6f09so208375ad.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 09:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757002846; x=1757607646; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e0t6bhmQA22wX44ktbmUqj5cgU/my1Kdps55OJZMqkk=;
        b=G3yOV2v6GNo62udULjygc1x6/1R6r36KSaaBTv5Yrg83WDzXNYWXhq/k3nRCaTBIsZ
         8LDknckfwzLL5gFQGmgSfPo5LmlauhrSexuJj3/sKjUu5KUxtmAv68tW2UBpmW/upVr+
         sQlCFlq0ohbJ/VEEDbJXvsTylYiE/KCIS9Vz11wsBzFfNZB4f9W1X5bpTu1AABXGAIWS
         cPTiTJozvzzMsNL5FotMnrbWarLAeq4GS/l73Jp2bAXQSjzKwN5bgnpz4eWNB9aOuqnV
         bp8g3qcUxNjUUyhnn5vxzM03bur9BHIzvDG9yOX0UxS+gecS3vksgBsjBkRIIIMbk87Z
         ctvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757002846; x=1757607646;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e0t6bhmQA22wX44ktbmUqj5cgU/my1Kdps55OJZMqkk=;
        b=oeMSQjHzrnV7C2YEHrF6SSE71VfuyY+7GwmLRbnmKyRQ7EqC698bAMCyC8wrucLIn/
         KHd6ILRhDwYg0pf5oXnNpEcZ4ss2T671gvahxU75ik5KkTF/8kreF8fmMHaAPP5w/Q9V
         4tHx9MYPaebfMhJdp78xGlktjJRa1iLR1At4rW26vrvw8AKQ/hw/MkSAk+FES5jErfuj
         8cYDE2SiN4Teou0FKE3301q3T83XkjTfDqHpwqzgg5+oeEz+mGxIXaGH97nvjctKW5CU
         Dpbmrf7+J87R8JD3F0Vhwy2pxCiRyDDVQnRqGuO8lBTnEpNSabJ07O1iLUQ95c59lO+c
         NvMA==
X-Forwarded-Encrypted: i=1; AJvYcCWzjv/68q9f74oeBbWtO+MX7K1X63AsL2BEpCdKrbrfObJ34q9lJbdiqJxDuRLBPhyYpJDy5bPk2Q==@kvack.org
X-Gm-Message-State: AOJu0YxKQGuu7vNFQT6XW9b161VIplPyj33/LanbigtkoD/2diDLURJa
	74xq8FF2WB9UlhWT11RMENAMIfrJ/2fKiFAc4F9AlLmvMZ+9LC05iwOrsB6aA3VY+lghf1Bc1yZ
	36DSlknMbBKGq9BNBepNXxfHCWxdUalGDEHKZFdkg
X-Gm-Gg: ASbGncsfk+22Cja+OeW3nMq8JHDGknVijcuuPdKrNI0XjdqEQ+qdD+cK2Pj9tKv805U
	iEobjrtjBRqQ9aec2RoQc0xYBCN3kwMV3sqYi25T+MeOaL20m00UO34MTGMXdDoOvGJvc7kNP1T
	RQ9pyyW7kA3aGi9hn1QvtrD0faZv7cx2u/2QfT/qqPbe8btv2e1Y67LfA+KxMJ4OGGjBkz/G8TV
	9plXBsLKT6B2l+4w3TrLdkFIBK5g93rIFiRiYVY+S1TsTN6BeZrX3qyHFPQGa4ybw==
X-Google-Smtp-Source: AGHT+IHThq6GwO2/qHwlSP0iRWoql/gtSI+KBd6TV5CKErad41aW7prfJ1BHV/t4PpXi6b9rJmJsWOcxBCxqXuBOLZg=
X-Received: by 2002:a17:902:ecd0:b0:249:2f1e:5d0c with SMTP id
 d9443c01a7336-24ccccc4c7amr2934785ad.7.1757002846099; Thu, 04 Sep 2025
 09:20:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250903232437.1454293-1-kaleshsingh@google.com> <aLk_zbXxYxHs1Igk@kernel.org>
In-Reply-To: <aLk_zbXxYxHs1Igk@kernel.org>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Thu, 4 Sep 2025 09:20:34 -0700
X-Gm-Features: Ac12FXwM78mo5ZQ5cUxcmH3ulwLdG7jBYopJRFbNNqJcd7ybiS1glWTpedGl5Rg
Message-ID: <CAC_TJvciKbEOyBv_V01s8nJF8MMKznKq-Gw6+Shv9AAppJ46+w@mail.gmail.com>
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	kernel-team@android.com, android-mm@google.com, 
	David Hildenbrand <david@redhat.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AE86820012
X-Rspam-User: 
X-Stat-Signature: hsjs1t54xe7yrtdhdsh4to314tx7re97
X-Rspamd-Server: rspam09
X-HE-Tag: 1757002847-955045
X-HE-Meta: U2FsdGVkX1/9kigo85K6+NZTbpNftQG93wYg/ZwDtbuG65pH8US26QRSRJPMTGzKLdVV50or4qzB8WZ2ofEusDlqN7CtjUngnTbP9xr59vWpS4k85CifZ7wmpDtJOopRlFKfncIF16sjJK+lLUh6FbAKEjhgM/RaJNQAYhT4ToXxUFwn1YeamSosT4g8kC8vFYJMMN9bzLvtUrsUfAITDy/x9hzf1WQHOV/+6+GBdUGRFY/6F8LSEsHImtcunt0d2DcanjzUJ+C+AKplv3HsADn+hMI8vdNwH3wU9Oo77SmQFUaqLHMUZNE1MvjKe6n4cUG0F7EGhzBKtf9X1MMiTmREOfvQSFyyFYP3JFHoL+SptBp4ewa0n2L3oITunMjQGLWrWzCoUmQiZjxgAFFQEGwWQY+yddL1Y88Feq+e/JrnIfI7BUcM3F97XOcSdukfxZXQ8WaNAU/SmkMYdckqXTz3YBRP+f282BJVc3bv99VEElxbQGyGuZ4sZM+QHtyUTsMaxq5L0fvcjlEctDa+IzvIVxdcKEaTPWQ+LDNKqhHAoN1FluRME6OmFMNU3X/GTKCFAntNndc8tj8FmW/6skWJXPLuAbB/TOdyV5H94q5UOA3hyqYD3fsDWM7oLWr2wPoqP6CKw2LYj7MazpYLaZUwc0CnYKest+i9k4gB5+s1bZ/TJ/pjRsxidCstA2CQ2aIvMQVBC9f6dU7mJA68OGqVpIpWCuByjfWhp7O/bLw+93N00dBJWz6Bpu9dcXQn7GNDsOonB6Q0re6qXAYfPs+mGUz9M0xXzV5PyCvE/8jq6Yp0FPGp6l6dX4gp0gZONj2K1KNivrE5RUApRMvETRjdWOWK4Iclsi5nN1zm917AvEEEKjNasFset9zyB++D+fpF3xFzmQG8BY7wZDqYEcTIGmwFQ8/Q/nwetvMU85C9HBwkwgAAFbBj0K0sxXhLtO36bpkWcJx88yONRG3
 xlEezoaE
 ZnMrovmBNSqjRpvg+MAONBNgduT7ZfPsSQnEp6ibxA2hZI+40a2rvnby4yHCVy3pTngpVI7VoRkJBTEscq9zCupLwM1GQb/LzZkIJNqLuyfMxvZ+VolN+NV1A3M2bWywW42TVNOFMuM/IU+l+s/cMtAmdNhr2ta1fABBdY8zDY4LC9G78kVr5yZ1hawAdG0QlrNrK1mK+UWcT1Ssd4S2RNUm0ISlwxS4GPwSaM4xJeCHLioI5gPAGnRUETi6k7nk+Py9j4t/kiiPTp5c4od1hUKostX84uMGMNE7VNHT6UxMU+NBT/Sj4gDMlAZtl5C90vDNFGM/uGN3eJdFA9YH19v8uumu7v0sP9gUULrfWgMV+baA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 4, 2025 at 12:29=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Wed, Sep 03, 2025 at 04:24:35PM -0700, Kalesh Singh wrote:
> > The check against the max map count (sysctl_max_map_count) was
> > open-coded in several places. This led to inconsistent enforcement
> > and subtle bugs where the limit could be exceeded.
> >
> > For example, some paths would check map_count > sysctl_max_map_count
> > before allocating a new VMA and incrementing the count, allowing the
> > process to reach sysctl_max_map_count + 1:
> >
> >     int do_brk_flags(...)
> >     {
> >         if (mm->map_count > sysctl_max_map_count)
> >             return -ENOMEM;
> >
> >         /* We can get here with mm->map_count =3D=3D sysctl_max_map_cou=
nt */
> >
> >         vma =3D vm_area_alloc(mm);
> >         ...
> >         mm->map_count++   /* We've now exceeded the threshold. */
> >     }
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
> >  include/linux/mm.h | 11 ++++++++++-
> >  mm/mmap.c          | 15 ++++++++++++++-
> >  mm/mremap.c        |  7 ++++---
> >  mm/nommu.c         |  2 +-
> >  mm/util.c          |  1 -
> >  mm/vma.c           |  6 +++---
> >  6 files changed, 32 insertions(+), 10 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 1ae97a0b8ec7..d4e64e6a9814 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -192,7 +192,16 @@ static inline void __mm_zero_struct_page(struct pa=
ge *page)
> >  #define MAPCOUNT_ELF_CORE_MARGIN     (5)
> >  #define DEFAULT_MAX_MAP_COUNT        (USHRT_MAX - MAPCOUNT_ELF_CORE_MA=
RGIN)
> >
> > -extern int sysctl_max_map_count;
> > +/**
> > + * exceeds_max_map_count - check if a VMA operation would exceed max_m=
ap_count
> > + * @mm: The memory descriptor for the process.
> > + * @new_vmas: The number of new VMAs the operation will create.
> > + *
> > + * Returns true if the operation would cause the number of VMAs to exc=
eed
> > + * the sysctl_max_map_count limit, false otherwise. A rate-limited war=
ning
> > + * is logged if the limit is exceeded.
>
> kernel-doc will be unhappy because of missing Return: description. Please
> s/Returns/Return:/

Hi Mike, thanks for catching this. I'll fix it in the next version.

-- Kalesh

>
> > + */
> > +extern bool exceeds_max_map_count(struct mm_struct *mm, unsigned int n=
ew_vmas);
>
> No need for 'extern' here. And the declaration should go to mm/internal.h
>
> >  extern unsigned long sysctl_user_reserve_kbytes;
> >  extern unsigned long sysctl_admin_reserve_kbytes;
>
> --
> Sincerely yours,
> Mike.

