Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94C12CA1014
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 03:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD6418E000A; Wed,  3 Sep 2025 23:02:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD858E0001; Wed,  3 Sep 2025 23:02:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9F38E000A; Wed,  3 Sep 2025 23:02:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE7158E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:02:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C40FC09CF
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 03:02:05 +0000 (UTC)
X-FDA: 83850068610.25.587CF5C
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id 70790160012
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 03:02:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="KihRr/F4";
	spf=pass (imf08.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756954923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sg3/MOE3S1m7f3fF13n1hw3ITE04y8oKW6xr+zs7pi4=;
	b=XAFCfBFawg5FOIUKGsdsG8w2uf+dFUtoCS8jsej8ZGRl98RaTJrmDNDc/2wV7Nuo3jB/87
	2tBPrDzW1BwDklIA2djxbe1CJkIIBSKiUXX10u6utD1mmauKihohqaMlYpotHPuaYd2ZId
	iq8IcDn63T1Xh1cvI/qXJQqEgn6A28k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756954923; a=rsa-sha256;
	cv=none;
	b=l9PuFx1elB2QFrox9CeVReJZ+Ia3rKqAgPIycZs2qAfwoFA9jGHe/50wNSN1fm6P2x/6F7
	sUiV1qCqJvz6SNunug36hV1DkEURlvwg06v4h3wjqdGySrHDPaKkS4DTb+lLOngaGdMrPT
	3fBrtKoNkvORDU5/8GzWq6xinsnbTsQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="KihRr/F4";
	spf=pass (imf08.hostedemail.com: domain of kaleshsingh@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=kaleshsingh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-24b2337d1bfso109225ad.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 20:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756954922; x=1757559722; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sg3/MOE3S1m7f3fF13n1hw3ITE04y8oKW6xr+zs7pi4=;
        b=KihRr/F4HwXeU3FD9aubdLs1H/vD/V2ENi4FXQbE6TyatlAeN4ieQdPERGSHgUkvNe
         3BjTOu66NQOUo/EWFSNWLEreJvFK1zERKE8hvX9eQOh+zZrGPuOTGfMZ+ZRhYdlPa5JH
         G+e/Z6B1cjS87qFRitMDsEe8LL7xzfiotv6d//5UpPwG245+JDXuT0hqdUxMoMueLay8
         lBrk/MAbXWLPJapZH5FE/Z3jXCtxU6UpCUmWQveccMu7ui6tAlDL+J8XFolHqrQqXvFy
         swz5oGKCeMJb4FPj24DPvXNrhQkSQxAuetbbc1vJhgf1IkiBPvjrtStwvskGCfqecyWD
         OAyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756954922; x=1757559722;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sg3/MOE3S1m7f3fF13n1hw3ITE04y8oKW6xr+zs7pi4=;
        b=p+RVdWcoBckEKuOGWRbwcaEC3EyGpfTP1cmWAgqSPHNRnPjEpDnNG72ujCnzEvInT6
         NoYmMovzpngph1pYLjNJPznjRBtqYpeJ4WdiMMzNe6C4jKtWp3Eqi7pIS+8m6+uQkoC5
         sfPKCNINJXumluH/U292NHd+CWmkEDKaLjfzrLoqWhgl7kGLAkpqVhK3OcLD9GxGQC7h
         oRhIHeLa262XYNoxxgoygJ13e9tBG2msdpPmB0uhAM6L2zsLMAPzSHXGFuPEsIBeYyrp
         u5ZU0R2TVVi5cL2EggJJT5E6uLQxei5ctO4xx1AqfOtxpzJSfBllD9kDnr9HL0zOma1b
         nkLA==
X-Forwarded-Encrypted: i=1; AJvYcCXeA6rxG+BSY7xgqRh71H9gDQfz602RmnwYeDwwvRZBPMPWxgHOEt6Os6zrBA/YMWFjARRJorq2IA==@kvack.org
X-Gm-Message-State: AOJu0YzwY0tHLwd75bwpXfQEeo63DLDk+dKjJ2yGGZiWwhD1eKSBFyKW
	+voWOmqcByyTnKLFOqYyBLyrgpLlhud1KZnAaTHVX+khspzzf2jHpsUzU0eGg6Sm0DPCgUMej76
	Eauc42KCq9/lpLlypdDsiOqaX9rq5O/ZqaVQE/EJX
X-Gm-Gg: ASbGncsOjabIecM0OHqh0I5IGj+1K8eV7JjlFkrTDiVQcOyi3xOlp+S0/MF5wYHZ9Jo
	F8VrKXrZCy/ooFDUz/8WrYzmT4b/EFKZtdttmZ0ierh3k3KKqHe4SQAMgE9q9RVscn60Qz1Bd3E
	9aAAPdH3ua5BiAITbVw7KqKaBbuUyenIekexLBXCD8pJTUjiQ6Rwe3UUMBsC4KCwY6TvO/N3k8L
	a+ajRNp2M7NPzaajKzWnHDIk8ML9yRLYax+2vgj6OYMuFu2vuvyuVXBeQ==
X-Google-Smtp-Source: AGHT+IG8YHt751a8iagriEcNsKMllgaN6wY06ZE8CJTNDUcFMlf5P7pepAtKth9DhLzX66wuKthgL0uNwy/D9mA5rp0=
X-Received: by 2002:a17:902:e748:b0:248:dce7:40e1 with SMTP id
 d9443c01a7336-24cccca7f62mr454025ad.9.1756954921579; Wed, 03 Sep 2025
 20:02:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250903232437.1454293-1-kaleshsingh@google.com> <qa7b7pvrycejnn6pjytxysu57xckhexupjrzefmk4j5hlaxka3@ayeg2vzpfe3r>
In-Reply-To: <qa7b7pvrycejnn6pjytxysu57xckhexupjrzefmk4j5hlaxka3@ayeg2vzpfe3r>
From: Kalesh Singh <kaleshsingh@google.com>
Date: Wed, 3 Sep 2025 20:01:50 -0700
X-Gm-Features: Ac12FXy43GL9nI9zR7z8e9dj8Hz5wlrXATZLKUd47Qr5ZkcfHVn_XRh1JMB9T7w
Message-ID: <CAC_TJvd0SnHpEv0MSwXsF4UFpP0MNvRc033=JS1xTEHAOjQY5A@mail.gmail.com>
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
To: Pedro Falcato <pfalcato@suse.de>
Cc: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	kernel-team@android.com, android-mm@google.com, 
	David Hildenbrand <david@redhat.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 70790160012
X-Stat-Signature: 4os98qhpofmmmc6kb6n6jidnttweytcm
X-HE-Tag: 1756954923-301113
X-HE-Meta: U2FsdGVkX1+ZNbQZtHrEJz5T4kQ6MA8mT5A4S0US2AteiuaJSFho0mmszpo9JIiUv9OW4tj9XuUbgi/G39Wu2oh0pUHpID5Mu+4Mqmyeqh6HAqSp+UIv5122hDxO5XVJTvkGxCbZ08KGcmLpvklKWhxVthm3s7BHYCE/pS3a/r0vYqIbtn318IFMGzcCmobx4oDRJryCnotzAS6jPcuVw1xYbl8Ov48OGxjZ8odJmApZfcA+0cdnS7NJy7ZWmH9FItDXvRvzuP4R46KjuDtRdSOyJx+Cl5tJPbJ/zMU2Rgja7EZExE1jNkx+Ft3cXY9uB6CKME6nFwW9TRW8cXdg/DpL2VTITwGvK7hMTns1BLXPl0cs1wa3qfcE0Z1ThFRDq3zlozHnbkimbx4fBOlqE8WrygVHGnp0/fj+IyQeYLH6rj8pzBz/IBFfOI0zHMCHjSjXFtute5b1OJnSCfRT9/7uI2eGreAn7JxqMc6F4x2W0PMeSCc4UasiKg6Pp6QcaumtOLAgmsQPOfIr1Djsg5uhnJQLut7F7P+0iASOTakzsPvywC1uoSTM9sr84LlH7zKZAhrQ7iNDjBVOAiKKRlwE8JqzZxFAx53nJHgEcZup66BNivLSeUUTKbi1gl42vN/DQ+vwdWcISOTsu8R7wuHUBWjwErReJoYfaG5/gLDdXMbYW1260PXYfbULVwnm/YEQu5MT7/sXMUC1Ug9lnto420rDBsO1GSKjjwSmPSmy83WWxG4ZpK1Tfo4mpKOZF48DuLlKyRYrkqNMDQGvNe+B0RqcvMF3faPsWRGlI/XYGGuBJIli6IRW9VZA+fcj1wG4Q7sA3L7wbdxq8rkvD6tMC8UlfC3Gp8MzKa4741S6dqRVXBy0x1/vZ26KPba5fQBA/tplsh5GD3BvPrWWMn7eXnDwGZmPYQySAVzkpa6rrjMtO2gcSkwRKiUEkthM7pn3+PquFEOzd9EkAtW
 N/Phd9Go
 ydhbL/kJntjIIwgBJtKRNpbmMXo4WeuKqX5Up4hF4iY9KlStznbcp22vMSy4112qHPf9g6vamjV2usS9EW5W2ZTfcl+1tbamwnXx7tU3hR+yJJNeqD1XIYX8+CD0IjzkJobnvJ6g4jzquzR/WtPIYRJ3UtyszZuZLuwZW5DSw9oJ6pqOvap5OwNBel30fsHkNxupiTaVZ95uasmFqzg2tkt+qzIPZ1o9HmO+aRNZZrrOdt6HOHHGXsf8WDdHJ1rZp5zPTkcI1M7FDxpPHAAgkD9LAQCEG86Z/WVByJWJEtYKAhqGqYOsUk9YhjYRx8+0tx30ExEE5CLTLi4CcwsyxCC2G1kmmyFuUkewh51dA0pp7L6M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 4:46=E2=80=AFPM Pedro Falcato <pfalcato@suse.de> wro=
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
>
> I think this should be fixed separately, and sent for stable.

Hi Pedro, thanks for the review. I can split this out separate.

>
> >
> > To fix this and unify the logic, introduce a new function,
> > exceeds_max_map_count(), to consolidate the check. All open-coded
> > checks are replaced with calls to this new function, ensuring the
> > limit is applied uniformly and correctly.
>
> Thanks! In general I like the idea.
>
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
> > + */
> > +extern bool exceeds_max_map_count(struct mm_struct *mm, unsigned int n=
ew_vmas);
>
> No new "extern" in func declarations please.

Ack

>
> >
> >  extern unsigned long sysctl_user_reserve_kbytes;
> >  extern unsigned long sysctl_admin_reserve_kbytes;
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 7306253cc3b5..693a0105e6a5 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file, unsigned l=
ong addr,
> >               return -EOVERFLOW;
> >
> >       /* Too many mappings? */
> > -     if (mm->map_count > sysctl_max_map_count)
> > +     if (exceeds_max_map_count(mm, 0))
> >               return -ENOMEM;
>
> If the brk example is incorrect, isn't this also wrong? /me is confused

Ahh you are right, this will also go over by 1 once we return from
mmap_region(). I'll batch this with the do_brk_flags() fix.

> >
> >       /*
> > @@ -1504,6 +1504,19 @@ struct vm_area_struct *_install_special_mapping(
> >  int sysctl_legacy_va_layout;
> >  #endif
> >
> > +static int sysctl_max_map_count __read_mostly =3D DEFAULT_MAX_MAP_COUN=
T;
> > +
> > +bool exceeds_max_map_count(struct mm_struct *mm, unsigned int new_vmas=
)
> > +{
> > +     if (unlikely(mm->map_count + new_vmas > sysctl_max_map_count)) {
> > +             pr_warn_ratelimited("%s (%d): Map count limit %u exceeded=
\n",
> > +                                 current->comm, current->pid,
> > +                                 sysctl_max_map_count);
>
> I'm not entirely sold on the map count warn, even if it's rate limited. I=
t
> sounds like something you can hit in nasty edge cases and nevertheless fl=
ood
> your dmesg (more frustrating if you can't fix the damn program).

I don't feel strongly about this, I can drop it in the next revision.

>
> In any case, if we are to make the checks more strict, we should also add
> asserts around the place. Though there's a little case in munmap() we can=
 indeed
> go over temporarily, on purpose.

To confirm, do you mean we should WARN_ON() checks where map count is
being incremented?

>  Though there's a little case in munmap() we can indeed
>  go over temporarily, on purpose.

For the 3 way split we need 1 additional VMA after munmap completed as
one of the 3 gets unmapped. The check is done in the caller beforehand
as __split_vma() explicitly doesn't check map_count. Though if we add
asserts we'll need a variant of vma_complete() or the like that
doesn't enforce the threshold.

Thanks,
Kalesh

>
> --
> Pedro

