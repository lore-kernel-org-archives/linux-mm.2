Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E9C0CA0FF6
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 00:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C786B0029; Thu, 28 Aug 2025 20:24:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23C7D6B002A; Thu, 28 Aug 2025 20:24:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 104FA6B002B; Thu, 28 Aug 2025 20:24:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ECFE66B0029
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 20:24:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D82914049E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:24:12 +0000 (UTC)
X-FDA: 83827897944.16.0526AD9
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7BF26C0002
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 00:24:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LJS+4b1L;
	spf=pass (imf22.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756427050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fb0y9vtGTZ+dzUMPugM8yqfICr2GysN5pwXfEC/sNhA=;
	b=wnbHu62JL7kRzd+1GCl0ruadWKKg9JYJYaEI/qFBmnMLGaMgHxGLOr6aYc9NWYrcUVdrQh
	YgIkUWm1sVcerB1ts0AIfLxyKZBmiFfEVjRKlzJof23ijpcTBcSXyD0Oyui3lPD3iY4qoN
	aw41TWOU5YpqugGlngqOej4TPkpzDXo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=LJS+4b1L;
	spf=pass (imf22.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756427050; a=rsa-sha256;
	cv=none;
	b=YVskLg2/jsQC121Au8oarSwbBhNfzK/igEP335iFDVMa8roMMDbmXJT6xgVus3AU7kIqoW
	T0DMSZzpgGI4l74R639gE1BVNVSH0MJGzd7JAjpJX7mnzgH9maqm0swK8WBojee8dfyfdD
	qMbfuhiPejfnZcC+KHmOuldeWOJjGvU=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-618660b684fso4929a12.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756427049; x=1757031849; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fb0y9vtGTZ+dzUMPugM8yqfICr2GysN5pwXfEC/sNhA=;
        b=LJS+4b1LPi1C5xxz9uGBoAAQK/flctoyI2a28wYbTm4gjdYzjB2/KF8jBjB429dMO7
         aEoZAZj6qOxHzJ6tggATDoINclw/CawPmKYjC3Acjerir2dpLm+esC5Sl0sMd0E7tlYr
         FW+m4PdHyTNS3bAhoHeN2nmaNwjTM6RcZpnAFVDaPjLhttm4MstFJAMiX8APFGcaWJoB
         YyeYK0yFpBWHJBrJ1GtOMZNpygMp10Zd7t2/BkUhIv8ZtNsAop1LFsi0VH/b7EIFgYrA
         almmHOI1VjlBvNXuqiy6ROV+eRWc+TS1TINk3wZqDmFv6xNOA5619EHoDOWqXeX08/N3
         G68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756427049; x=1757031849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fb0y9vtGTZ+dzUMPugM8yqfICr2GysN5pwXfEC/sNhA=;
        b=K1nbtpxRaTkotcBD1Acc/FlbEw7Dq0CULfPikYCAl0AL6SpcQ4gBU1m5gzKjYBjxJ9
         C+3aUlb5YHNM8zifnPexQnP1pmQGpOMcRyhl2anQWsORpQr7AuCx/k2/bfFGXKySh6sZ
         HNDt8iUxoURqLj02G/Vb9eKGvmGgu5tElCOcaWMaXvSUbG+8ZSGV+lBx67kyMUJa16MU
         YQ8HBvMrYhExhH5JUiXEQ90GmtzQwIw+V22nEwWHBK6m01Bjc1Ekb3GpoXYV3ZQTxdq9
         PAvBeEKYhwUar3sZQkXS+FkJqhrl2yAiB5M0mq/bP+0ZP2wDQZ0WbzC2n/Titp4HJ/tv
         T19A==
X-Forwarded-Encrypted: i=1; AJvYcCUTA0iwRhNX2sWVhCBAAxgZdn2lj9vFD+nSeYnB9b9eDd3YceO1lWT6f6rTOVQVvD3KUM/rf5J8mQ==@kvack.org
X-Gm-Message-State: AOJu0YwaAdUcGnAhcUWAXfHZSykfVhyznLZzI9k7k8g5gerEdUPZZf5/
	Hn3pz4+pwsS9UOaShKuLcZoNZc5vRdR+Xwk8sw6HYa3fJ07ABIQabPgIH1Dz8bSVq60EP3kPw+Z
	OEbXc8fjJ7lsNyaqCyAjxequ0jjOuv6RvlqUOw65t
X-Gm-Gg: ASbGncsR62ypnuOmxeEX4h6VSZHGwKvzWnUbeEOff1p81GNkXpZou6FP7G8OqWAw60a
	7gI7W3IuOK2kBNQKOxDHQNptL2ta23nI38HaCeNbrljpf7leMCb5/+QsmBfbpxDpObPf7fzvf/R
	UKjR7AiRgkN73aVe6wG4t3rm4E61FCt62nORn17jNIQCXT+Q1+Cngt+I/Y9NNcrQHZL/Chxtz1A
	1yaU0jpdDJqnEXEheF+kHmayFAJTMsDyF93xKyI/vf/8E0=
X-Google-Smtp-Source: AGHT+IGHd9I0AQLS1rXEfAJmvOR/gyxXdVZywIfUPo//u1+kPAq9z38CCUP9OBMIAZG26vl3BjzMxE43SXhsiruLtFE=
X-Received: by 2002:a05:6402:2398:b0:61c:32fb:999b with SMTP id
 4fb4d7f45d1cf-61c91d000e6mr569462a12.1.1756427048570; Thu, 28 Aug 2025
 17:24:08 -0700 (PDT)
MIME-Version: 1.0
References: <CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com>
 <dc92aef8-757f-4432-923e-70d92d13fb37@redhat.com> <a0350dd8-748b-41d5-899e-1505bd2b2e80@lucifer.local>
In-Reply-To: <a0350dd8-748b-41d5-899e-1505bd2b2e80@lucifer.local>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Thu, 28 Aug 2025 17:23:56 -0700
X-Gm-Features: Ac12FXxW3K_Bg6VMteJaxri8c5NDc0ZgxIw1US5qRGGnGagV8jf0XXZ2DNebdpc
Message-ID: <CA+EESO73TRAcMWeo_aXkLM+0rT5nt1cxyvf+Ye3Xp9kqxL5=6Q@mail.gmail.com>
Subject: Re: [DISCUSSION] Unconditionally lock folios when calling rmap_walk()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Harry Yoo <harry.yoo@oracle.com>, Zi Yan <ziy@nvidia.com>, Barry Song <21cnbao@gmail.com>, 
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	android-mm <android-mm@google.com>, linux-kernel <linux-kernel@vger.kernel.org>, 
	Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: x6h1yimuedfwe4t3rfx9qrcqruhgohei
X-Rspam-User: 
X-Rspamd-Queue-Id: 7BF26C0002
X-Rspamd-Server: rspam05
X-HE-Tag: 1756427050-704186
X-HE-Meta: U2FsdGVkX1/eCsW0BjOEd902aikWuZk/VS+/bR0yfXcaaotATNDe9XlavOLMU9lFgnPDMg97KiQBiQ4uK2B2wvrHeqXuZj2r60oD7DAlY56XSvscYWJ39ZyuOFzG8XOlS+G2SvszmAnQ/r/+2rlA3+4riwicpTDjNsVqRLLZjcWSB8wJ8VvKoZbaIH6g4f4l6v+vD/mOuIz80qKhyPfo4aCO0ijJB0ZHjFucYy57FHaYQFl3o+6WWpezDxU23uWSzRXhLuYzLDyc92yCJ7xE0wx3bA7rBAM1M4vcx/4av4B101CHZzwiTWbQs66aYNhZbb+V76ATfgDB6zdu+sODNGACQvC9g9+RNpQ7KOUqYDcwNuBCZk8vRbobRNxr7gGaBa1VPCjYDlSUFXTIFjJ4VoOEXkeC344GNI1OHXcnY4zl66jK3R5fZccZlc5Rw2c9r+SFt12ZLCCEp7oMvG0f6FG9NNLbHG1X0pFNI4BxvAkIMw2bsN2Nr0DjYerndYgRhgrIMbZhTCs4pYgqcxNbUGAqjbG01DQzxDpuWx46QqQsGrdiMO5pgN1CGtWD49efBYEGxi5iMXs6ohwg1b68OU7YNsav8iq3HNg1Zu+qJVGHYddIjSF3/+AwvPimJErc7M0l17t/WSv/umoQQsbYCcNmSBPAvVfwVcZMfwffs0gyBchTO+LRVtpzM4tGSZFHrDy+vrX++fRAnaMyn1LEofay7qSKuxmLqkfOuqx6Yr7Xm5rcXBkF77hxLwORZnnoPUzndG/dxpenl1fsh9JnhqoKOaHYBF36FssJs5ev/5dHf2Q9MQml7qYNJksYc0mchg+tnyEsq+hz4TfBfEayNUb4PCXBoLuTr9mHzMTakNTfP33CZqndGk5IuYAQBTI0FWyIgRjgEXHdvClD4BcFpnOuhpKnEeWDorGbHBZ7zw6xbLYjgWmhMSYDQ0Th+zmGD6tBqk9RkI0JWaI7FAI
 SHQNT+V9
 le7wkr3Msfodi5H4xQqn/VTiaKvEYuk3YdpIbS1fy0YyokzZHskatvXtKZq79ocm44w+Ntgw1ipflDoGgyOy+FexjGFdr5gR3nM9iFR5Ux1RhuColqp+SkKv62bx/Q7bOlS5WiSbpwLi65ZZofF6fNGXtC8YHmw+aoPAtwGvNxTMaGnx7pSkMeiqn8+V9Trb08TtxKcihWNhzG4b/RHlDcAyNen+WmtNnRpLgDS/ARVQr0eNOeBCJ337uxgmxQy0VeJdMnfTomwJqMMo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 5:04=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Mon, Aug 25, 2025 at 05:19:05PM +0200, David Hildenbrand wrote:
> > On 22.08.25 19:29, Lokesh Gidra wrote:
> > > Hi all,
> > >
> > > Currently, some callers of rmap_walk() conditionally avoid try-lockin=
g
> > > non-ksm anon folios. This necessitates serialization through anon_vma
> > > write-lock elsewhere when folio->mapping and/or folio->index (fields
> > > involved in rmap_walk()) are to be updated. This hurts scalability du=
e
> > > to coarse granularity of the lock. For instance, when multiple thread=
s
> > > invoke userfaultfd=E2=80=99s MOVE ioctl simultaneously to move distin=
ct pages
> > > from the same src VMA, they all contend for the corresponding
> > > anon_vma=E2=80=99s lock. Field traces for arm64 android devices revea=
l over
> > > 30ms of uninterruptible sleep in the main UI thread, leading to janky
> > > user interactions.
> > >
> > > Among all rmap_walk() callers that don=E2=80=99t lock anon folios,
> > > folio_referenced() is the most critical (others are
> > > page_idle_clear_pte_refs(), damon_folio_young(), and
> > > damon_folio_mkold()). The relevant code in folio_referenced() is:
> > >
> > > if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio)))=
 {
> > >          we_locked =3D folio_trylock(folio);
> > >          if (!we_locked)
> > >                  return 1;
> > > }
> > >
> > > It=E2=80=99s unclear why locking anon_vma exclusively (when updating
> > > folio->mapping, like in uffd MOVE) is beneficial over walking rmap
> > > with folio locked. It=E2=80=99s in the reclaim path, so should not be=
 a
> > > critical path that necessitates some special treatment, unless I=E2=
=80=99m
> > > missing something.
> > >
> > > Therefore, I propose simplifying the locking mechanism by ensuring th=
e
> > > folio is locked before calling rmap_walk().
> >
> > Essentially, what you mean is roughly:
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 34333ae3bd80f..0800e73c0796e 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -1005,7 +1005,7 @@ int folio_referenced(struct folio *folio, int is_=
locked,
> >         if (!folio_raw_mapping(folio))
> >                 return 0;
> > -       if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(fo=
lio))) {
> > +       if (!is_locked) {
> >                 we_locked =3D folio_trylock(folio);
> >                 if (!we_locked)
> >                         return 1;
> >
> >
> > The downside of that change is that ordinary (!ksm) folios will observe=
 being locked
>
> Well anon folios, I guess this is what you meant :)
>
> > when we are actually only trying to asses if they were referenced.
> >
> > Does it matter?
>
> Also another downside is we try lock and abort if we fail, so we've made =
this
> conditional on that.
>
> But surely this is going to impact reclaim performance esp. under heavy m=
emory
> pressure? It is at least a trylock.
>
> It's dangerous waters, and I'd really want some detailed data + analysis =
to
> prove the point here, I don't think theorising about it is enough.
>
> >
> > I can only speculate that it might have been very relevant before
> > 6c287605fd56 ("mm: remember exclusively mapped anonymous pages with PG_=
anon_exclusive").
> >
> > Essentially any R/O fault would have resulted in us copying the page, s=
imply because
> > there is concurrent folio_referenced() happening.
>
> Fun.
>
> Thing is we now have to consider _every case_ where a contention might ca=
use an
> issue.
>
> One thing I _was_ concerned about was:
>
> - uffd move locks folios
> - now folio_referenced() 'fails' returning 1
>
> But case 2 is only in shrink_active_list() which uses this as a boolean..=
.
>
> OK so maybe fine for this one.

For shrink_active_list() it seems like doesn't matter what
folio_referenced() returns unless it's an executable file-backed
folio.
>
> I really do also hate that any future callers are going to possibly be co=
nfused
> about how this function works, but I guess it was already 'weird' for
> file-backed/KSM.

Actually, wouldn't the simplification remove the already existing
confusion, rather than adding to it? :)
We can then simply say, rmap_walk() expects folio to be locked.

>
> So the issue remains really - folio lock contention as a result of this.
>
> It's one thing to theorise, but you may be forgetting something... and th=
en
> we've changed an absolutely core thing to suit a niche UFFD use case.

I really wish there was a way to avoid this within the UFFD code :( In
fact, the real pain point is multiple UFFD threads contending for
write-lock on anon_vma, even when they don't need to serialize among
themselves.
>
> I do wonder if we can identify this case and handle things differently.
>
> Perhaps even saying 'try and get the rmap lock, but if there's "too much"
> contention, grab the folio lock.

Can you please elaborate what you mean? Where do you mean we can
possibly do something like this?

UFFD move only works on PageAnonExclusive folios. So, would it help
(in terms of avoiding contention) if we were to change the condition:

diff --git a/mm/rmap.c b/mm/rmap.c
index 568198e9efc2..1638e27347e7 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1006,7 +1006,8 @@ int folio_referenced(struct folio *folio, int is_lock=
ed,
        if (!folio_raw_mapping(folio))
                return 0;

-       if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio)=
)) {
+       if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio)=
 ||
+                          PageAnonExclusive(&folio->page))) {
                we_locked =3D folio_trylock(folio);
                if (!we_locked)
                        return 1;

Obviously, this is opposite of simplification :)

But as we know that shrink_active_list() uses this as a boolean, so do
we even need to walk rmap for PageAnonExclusive folios? Can't we
simply do:

diff --git a/mm/rmap.c b/mm/rmap.c
index 568198e9efc2..a26523de321f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1006,10 +1006,14 @@ int folio_referenced(struct folio *folio, int is_lo=
cked,
        if (!folio_raw_mapping(folio))
                return 0;

-       if (!is_locked && (!folio_test_anon(folio) || folio_test_ksm(folio)=
)) {
-               we_locked =3D folio_trylock(folio);
-               if (!we_locked)
+       if (!is_locked) {
+               if (!folio_test_anon(folio) || folio_test_ksm(folio)) {
+                       we_locked =3D folio_trylock(folio);
+                       if (!we_locked)
+                               return 1;
+               } else if (PageAnonExclusive(&folio->page)) {
                        return 1;
+               }
        }

        rmap_walk(folio, &rwc);

I'm not at all an expert on this, so pardon my ignorance if this is wrong.
>
> >
> > Before 09854ba94c6a ("mm: do_wp_page() simplification") that wasn't an =
issue, but
> > it would have meant that the write fault would be stuck until folio_ref=
erenced()
> > would be done, which is also suboptimal.
> >
> > So likely, avoiding grabbing the folio lock was beneficial.
> >
> >
> > Today, this would only affect R/O pages after fork (PageAnonExclusive n=
ot set).
>
> Hm probably less of a problem that.
>
> >
> >
> > Staring at shrink_active_list()->folio_referenced(), we isolate the fol=
io first
> > (grabbing reference+clearing LRU), so do_wp_page()->wp_can_reuse_anon_f=
olio()
> > would already refuse to reuse immediately, because it would spot a rais=
ed reference.
> > The folio lock does not make a difference anymore.
>
> folio_check_references() we're good with anyway as folio already locked.
>
> So obviously shrink_active_list() is the only caller we really care about=
.
>
> That at least reduces this case, but we then have to deal with the fact w=
e're
> contending this lock elsewhere.
>
> >
> >
> > Is there any other anon-specific (!ksm) folio locking? Nothing exciting=
 comes to mind,
> > except maybe some folio splitting or khugepaged that maybe would have t=
o wait.
> >
> > But khugepaged would already also fail to isolate these folios, so prob=
ably it's not that
> > relevant anymore ...
>
> This is it... there's a lot of possibilities and we need to tread extreme=
ly
> carefully.
>
> if we could find a way to make uffd deal with this one way or another (or
> possibly - detecting heavy anon vma lock contention) maybe that'd be
> better... but then adding more complexity obv.
>
> >
> > --
> > Cheers
> >
> > David / dhildenb
> >
>
> I mean having said all the above and also in other thread - I am open to =
being
> convinced I'm wrong and this is ok.
>
> Obviously removing the complicated special case for anon would _in genera=
l_ be
> nice, it's just very sensitive stuff :)
>
> Cheers, Lorenzo

