Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24013C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 14:45:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD4BD6B008A; Fri, 25 Jul 2025 10:45:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5ED76B008C; Fri, 25 Jul 2025 10:45:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4D7B6B0092; Fri, 25 Jul 2025 10:45:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 944D36B008A
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 10:45:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 452141A07D0
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:45:11 +0000 (UTC)
X-FDA: 83703059622.11.0E3B39B
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2B67640018
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 14:45:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2H8keXiX;
	spf=pass (imf17.hostedemail.com: domain of jannh@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753454709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qIq14dJIVdG8Em0IZoGynxSIJDeMyZzA0yiBWzPg6Xc=;
	b=00NT3pURVIv67BlgJa4GccJIw39r1nc5Gy93+4N7+tlQDcdUJvEs39gEd4GHnIr13LN8DD
	zYMDUexRLWcShqhLc7MGlH8Y1QxEPwWXFMhIXd/NLia0EnDLNTy/OjZMB+rbRsTl20wfF7
	BxygwfmUbIYzbkHHLRBMcTc8Ws9yaRU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753454709; a=rsa-sha256;
	cv=none;
	b=wdtp6pBi7IYO8it4bT3OIqSqWQU6JnFknd3EJiu6hvtTYpXv4VVSCnm5GGXgjWasXiRG53
	wTHnUNb8WvahiUi/mqWA/PRZcQGfi403qvXNu9QNolF+1fUSxbLDXSUJZYTwHip/G1jkBs
	g+J5puISdGVv6iEs+qSJRFC1UKr3S3c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2H8keXiX;
	spf=pass (imf17.hostedemail.com: domain of jannh@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-609b169834cso11295a12.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753454707; x=1754059507; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qIq14dJIVdG8Em0IZoGynxSIJDeMyZzA0yiBWzPg6Xc=;
        b=2H8keXiXKBRwG4pCaw8R4h2AnJFQSnPDUbhd35xleTumwWpUbmC2QIYHxHXBJpucRa
         jC4VsKJIayDEZrpefGjkGHbkYm9Cr78ua+KwQxKCBRsl6vI+w0xv14jaDndFEhbnfANY
         huj74fQ3jUpQLSgrMMWt0h4duBID2XdXBlvnGmryKtt0MstuXiIj7WaU/PB0UnDs59Yn
         mnFKb1rj72jvdqGfYUQdzyIFRIeWI+wfdpfXktyKPkiSdfxLXotXQbWj5baAbFVCF68I
         jOiTNepwt9DpQTZAqtzvKL+EX6NYGQc73yamWMtgXmhaD7Kyhz/oXUWF5vP9JLDrQ8SH
         JCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753454707; x=1754059507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qIq14dJIVdG8Em0IZoGynxSIJDeMyZzA0yiBWzPg6Xc=;
        b=eYOIm8Aq+3TQzrqsTHWb7d2npJQsuaq4zf0VMbAI0JHYKh5AsqSCtN5T2Auc/rocUA
         bQFXhByfNc3oi82E/nOj11R8irqC7EpLlTKfKzBU0r9ldTTKpT5HINXYf8jiEIeiWifO
         UjJED2Nz8Wc+gBpOmADEDgm2zUP4AUS0O02R3pyZWGqoKZFTToweG8I2e1hmU15tSfx8
         0e7yvNTmxni3Sr8jNmVyCsZPHxxkoccN8y1sDp/1rInEKytm0K6MnOesx4pianBpUELI
         g/ZK/xu3DZVDw+RhKo3UPphtVQZg0WRoYwvFIXXxbxgpKrBpMy2ayrduWPjx6tt8AHdC
         lPbw==
X-Forwarded-Encrypted: i=1; AJvYcCU1vR8TF9evwO4+gQ5oqs0pf0A9WF65zdEy4TKLiSE3+AQOgc+PTizTZXQUNufjLUOKpFFgspH9uw==@kvack.org
X-Gm-Message-State: AOJu0YyVlx2CHLAEJnwzhxEzbogEs+pW2m2fHM2xtpintJyqebN7U220
	unGXxmY3W+iW14YAQXFP6DMOWEFUiD9pgfPoBVZRa1saWI+YqvwxZhqMx1t6fe1jN+Cw3lFA+oe
	yb7+DgZocMI5Hu6033jygYk/SUp+iJV+4vaW1gzQcNqPRFg1Jw2DXYnTujpc=
X-Gm-Gg: ASbGnctYSaVdoXYyObsielJB8Mp3U4osD9eOJxjliZlVAcpUe5wpuy2XHcmGeAHIX03
	aro2u61ozA38lhA3kRWzPkNbYI3cm8PQb4XCejjeqxPXxKI1ovDTqr+nAYQWvTs0lZvnvx5MP0P
	qWBA4L3DEHI4Zqs4gFD/hr30/QFB2ubmPAKfX6A65k7EFNt9biOcUo/scE0B++ghvntYPAiYVpX
	L9Zn65Q8IwrmsEQVf99skM+W8wvh5um5T4=
X-Google-Smtp-Source: AGHT+IEYQbZPuNP3paaUxn8jeMegpNMd+Dg193eNXtPsbU/sYQfNMnRC6dvCdmFyXtMH+mXp7L5rpb7LbQrPR5ksMss=
X-Received: by 2002:a05:6402:1d89:b0:612:ce4f:39c with SMTP id
 4fb4d7f45d1cf-614e6e4cfd3mr86568a12.0.1753454707041; Fri, 25 Jul 2025
 07:45:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250725-anonvma-uaf-debug-v2-1-bc3c7e5ba5b1@google.com> <1d849190-214e-413e-a082-d7f862b653cc@suse.cz>
In-Reply-To: <1d849190-214e-413e-a082-d7f862b653cc@suse.cz>
From: Jann Horn <jannh@google.com>
Date: Fri, 25 Jul 2025 16:44:31 +0200
X-Gm-Features: Ac12FXyb-HgzDpS3DcrqFBWx_FgxxiAo_cGOTd9j55tu-ioQwhxjh8xLSbmTJD4
Message-ID: <CAG48ez23CPO-m6kPaEs8kLUfRVCN+QMbsEn7BocfaJuq=gRwaA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/rmap: Add anon_vma lifetime debug check
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2B67640018
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: uexbnenqp88rpaz7bcwrqtmgu43zqesc
X-HE-Tag: 1753454708-600649
X-HE-Meta: U2FsdGVkX1/dHKBZDThzjJ01Yl4/q/mn/MpMt4N6hw/frfxRD7FjiQI0l3hSGYZ9Grs36/lnVk+9yna7wNnBaKCZIn/ZimUGN/yDw/lHrppj1P4g4XK0gGKhMEYnUuJgkzPyYf2szo9++hAFROxrro06Xf86lWarSM9Or7kiCW6NsR90aZYZU0u5KN+iE54kEwVbnJJ04I6yP2x/N2dDM2Qh00/Be0BHO+NgUNRvaJv09NNXyXoPWjE00F8kmPJT3e5Am5lKx4ENb4CdlGn9qTKVLWDAsx6uxqU5LG/TGWdJ+cArs7DtSoOPuFEScVkfovezAfqahVEgzdcCipJ68NnvHNrrkafB5nij8cj6P94EUfKvCHOdydDbFuQ5eS0oUmIrkau3ad5b1ZbsgUcLJCfUOIGKuJoXS4tJLi00Bk+yRNlyp29E/FsjUsqHsBSBBu7w/Kc4efZizZVKXvAzwspyGkbUm/4Qsue0ntEM6i6BSK/b7ayrJ+lCic8ugCebVThIyotsHLd3DHHqieWmb39rMSnzHeuQEN5q6WOwohB0le053L8ciA02cG5gRrV3H8I7tngh9fhh99yGAxF1xK1F/OB6k4KOYjWWeXhYYtAbzTSnAKjqNfIHekMCwOPhYZThdJTc3vFxCRTZRs2orI+n6EHdaTrEh6i7GppilZu80j4jTyCZdh1/TvSuqY90cZItkkjWIMs0d0m2P9xRlvxWq+pzzGaWc6Kw7fW61nJqidbcqNWMJb/wf4+tgaFnWnc3S/lNYThT2ZPIlyIRJbfCTke3Xg4irVwiasZ5PBkgrdant0wdMyTHAvNQqVM2mOsq8OJyJ3aXSS3YBpPhlTMk9v2ExCmXwAYubdXFZySW9kxAzfaRPd6L3OrOE78DWHre7zrGtjUehLFZI3NCs1OwiGZkhhRxjbga2yTg04a99WWPCWX7kbcG55SNh2Ly8gNET0BUEEQVe15FZHz
 PJMGzLG9
 +OZ+hI8fs9e++95szPeOaMrs26dRrM276sXDd2akpVHRb+8jSuNe+n+93Njo6t/vDOakyiZDgv8gOM1twk1gI6bTd3amWMMq46avMPC4PL4AQPnivVe9wYG18AlR1DbRpJzyAsFdqBMD3z2FA5MUE6WSXiWjjq61+O56m2gP1YJaj4z28DLFNr9erXm5YZIPJwOP/ygkuGzdUcHhnkENJlBTYUo4hPsUQloUrNllqfnz4t5JdxrpNeo+DLSU2BCZmAVveL4AKu8XpG2HVG3jCuQq14Wm09fFVqbV4FCGh0BQB0+bywIMSWKVpBin9Iuz8yeMNgyWgSNKAxKw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 4:11=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
> On 7/25/25 14:16, Jann Horn wrote:
> > If an anon folio is mapped into userspace, its anon_vma must be alive,
> > otherwise rmap walks can hit UAF.
> >
> > There have been syzkaller reports a few months ago[1][2] of UAF in rmap
> > walks that seems to indicate that there can be pages with elevated mapc=
ount
> > whose anon_vma has already been freed, but I think we never figured out
> > what the cause is; and syzkaller only hit these UAFs when memory pressu=
re
> > randomly caused reclaim to rmap-walk the affected pages, so it of cours=
e
> > didn't manage to create a reproducer.
> >
> > Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous folio=
s to
> > hopefully catch such issues more reliably.
> >
> > [1] https://lore.kernel.org/r/67abaeaf.050a0220.110943.0041.GAE@google.=
com
> > [2] https://lore.kernel.org/r/67a76f33.050a0220.3d72c.0028.GAE@google.c=
om
> >
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Jann Horn <jannh@google.com>
> > ---
> > Changes in v2:
> > - applied akpm's fixup (use FOLIO_MAPPING_ANON, ...)
> > - remove CONFIG_DEBUG_VM check and use folio_test_* helpers (David)
> > - more verbose comment (Lorenzo)
> > - replaced "page" mentions with "folio" in commit message
> > - Link to v1: https://lore.kernel.org/r/20250724-anonvma-uaf-debug-v1-1=
-29989ddc4e2a@google.com
> > ---
> >  include/linux/rmap.h | 22 ++++++++++++++++++++++
> >  1 file changed, 22 insertions(+)
> >
> > diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> > index 20803fcb49a7..6cd020eea37a 100644
> > --- a/include/linux/rmap.h
> > +++ b/include/linux/rmap.h
> > @@ -449,6 +449,28 @@ static inline void __folio_rmap_sanity_checks(cons=
t struct folio *folio,
> >       default:
> >               VM_WARN_ON_ONCE(true);
> >       }
> > +
> > +     /*
> > +      * Anon folios must have an associated live anon_vma as long as t=
hey're
> > +      * mapped into userspace.
> > +      * Note that the atomic_read() mainly does two things:
> > +      *
> > +      * 1. In KASAN builds with CONFIG_SLUB_RCU_DEBUG, it causes KASAN=
 to
> > +      *    check that the associated anon_vma has not yet been freed (=
subject
>
> I think more precisely it checks that the slab folio hosting the anon_vma
> could not have been yet freed, IIUC? If the anon_vma itself has been free=
d
> then this will not trigger.

The point of CONFIG_SLUB_RCU_DEBUG, which I'm talking about here, is
that it allows KASAN to catch UAF once the anon_vma has been freed and
an RCU grace period has passed; it is not necessary that the slab
folio has been freed.

You can see that working in the linked syzkaller reports - KASAN
tracked the object as freed after slab_free_after_rcu_debug(), which
is an RCU callback scheduled from kmem_cache_free().

> > +      *    to KASAN's usual limitations). This check will pass if the
> > +      *    anon_vma's refcount has already dropped to 0 but an RCU gra=
ce
> > +      *    period hasn't passed since then.
>
> AFAIU this says it more accurately and matches my interpretation above?
>
> > +      * 2. If the anon_vma has not yet been freed, it checks that the
> > +      *    anon_vma still has a nonzero refcount (as opposed to being =
in the
> > +      *    middle of an RCU delay for getting freed).
>
> Again the RCU delay would apply to the slab page, unless you talk about t=
he
> CONFIG_SLUB_RCU_DEBUG specific path (IIRC).

Yes, right, the "RCU delay" in the second bullet point refers to
CONFIG_SLUB_RCU_DEBUG.

Here I'm saying "If the anon_vma has not yet been freed" because
that's the only case in which I can reliably say what will happen, and
this is the main case that isn't already covered by the first bullet
point in a CONFIG_SLUB_RCU_DEBUG build.

> That said, I wonder if here in __folio_rmap_sanity_checks() we are even i=
n a
> situation where we rely on SLAB_TYPESAFE_BY_RCU in order to not touch
> something that's not anon_vma anymore? I think we expect it to exist?

Yes, we expect it to exist. That's why I'm not just asserting that the
anon_vma is still considered live by KASAN, but also that its refcount
is non-zero.

> Can we
> thus invent a CONFIG_SLUB_RCU_DEBUG-specific assert that assert the anon_=
vma
> itself has not been freed yet (i.e. even if within a grace period?).

That is essentially what I'm doing - checking that the count is
nonzero verifies that it's not within a grace period, and the implicit
KASAN check verifies it can't be in a KASAN quarantine after the grace
period is over.

> I was wondering what actually does rely on SLAB_TYPESAFE_BY_RCU, thanks
> Lorenzo for pointing me to folio_get_anon_vma(). But that's only used
> elsewhere than here, no?

Yes; the point of this assertion is that folio_get_anon_vma() and
folio_lock_anon_vma_read() (which show up in the stack traces of the
two linked syzkaller reports) rely on the ->mapping not being
dangling; and they can happen in the background anytime as long as the
folio mapcount is elevated, but they only actually happen sporadically
(in particular under memory pressure, which syzkaller apparently
mostly triggers randomly and non-reproducibly). If we have bugs where
the ->mapping of a folio goes away while it still has an elevated
mapcount, then instead of randomly getting KASAN splats under memory
pressure, it would be nice to detect this reliably. So I figured a
nice place to check this is when we're decrementing the mapcount -
that should catch almost all cases, except ones where such a bug
happens because we somehow leaked both a mapcount and a refcount of a
folio.

> > +      */
> > +     if (folio_test_anon(folio) && !folio_test_ksm(folio)) {
>
> So you verified this compiles out completely without DEBUG_VM?

No, after David's suggestion to remove the explicit CONFIG_DEBUG_VM
check, I looked at the definitions of these things to check that it's
all just plain reads and arithmetic, and removed the CONFIG_DEBUG_VM
check, but haven't actually compile-tested it.

