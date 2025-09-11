Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 462E0CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 19:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A07C38E0006; Thu, 11 Sep 2025 15:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8098E0001; Thu, 11 Sep 2025 15:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CE508E0006; Thu, 11 Sep 2025 15:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 79B468E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 15:05:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D673596CD
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 19:05:38 +0000 (UTC)
X-FDA: 83877898356.11.EEA22D0
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0D0A1180008
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 19:05:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Sce6XXZs;
	spf=pass (imf16.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757617536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzAI8/Dwu1mzzM+7JGNFRB+3zNC3dYWXD5CdYN2RtYw=;
	b=RR3d8PCGzF6mct4kiAuI3UbnVEY5a2g6KKB8UwIU+nz2YRy+80C0jYSSEk5NsOe3u47Kmi
	dCkw2ZnbSNtsISd69BDyINnYPVSJAKIS6G6tJftfJyYWO26t5IBF4Uqw2Wh5l5Yzcv2SyV
	dpPQ2MZpXH2eHDcTDM2mbaEpQESKEVg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Sce6XXZs;
	spf=pass (imf16.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757617536; a=rsa-sha256;
	cv=none;
	b=HgSc/ss6LBZ/PAmTRXoPQ0MRkk2JWh0tSjicpiIcV3mDtkwQHEQxVsa1kweo59bs2HZ2td
	sY9stG0z/NKrO0zPQ3xED4S+/e2JQok3yP46os5pjs9fsHiX/cbrsetOGC1wI3ulWUa0Nq
	FejZHQ7pRcjYR+vJox9epZ+YVO5/A3c=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-621c6ae39b5so3161a12.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757617534; x=1758222334; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gzAI8/Dwu1mzzM+7JGNFRB+3zNC3dYWXD5CdYN2RtYw=;
        b=Sce6XXZsfAyHkMzzeWoaZ75c/tIaXHUU5xibOhMZEZrQIkzP/mpqzDGgtSQlsZqQbZ
         8ecWssfKiETYDVx/rtjPgv3NcAmrb9Nv/2H0048nC7wGSgQomtYhwwezvm+FVNB38JTM
         OX+Z/l2H6X6QNwXHJfk9h6NwL1lGhLSZH1B5azVLdhS3oThLRqFpAVXHC36eHuQfPTWj
         aXoEAIODl/vYZTeU5zCpyFQfOR48vN1k2iuVt3W5KOFcg7ZmeDeYGBgj8pkb3J/Y75Uu
         BKtv2/Sj+YI6q1wENwpNl8TymOOPPECqiQI2ZixmZ6GezT4LmejKaHuksY82Nd8RZMJe
         OHjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757617534; x=1758222334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gzAI8/Dwu1mzzM+7JGNFRB+3zNC3dYWXD5CdYN2RtYw=;
        b=ZSBSWNpPjgZoEod/KY4DbGXX6hAbaJvw4letLTPYjtfJc9dYZ0ZRQanuHxFBtrPG40
         LaHyoa9wAKIhLhNE2ZHOXrujYtN2zQfPPxlxnzfPu8eDBtYFHbbFgWyA/oqoyxMQzPWM
         268q4r4Q7mvsGwx1mwoRtkcG+53dyUxKMc17tYzVP/dMD3bbwplIJ0PKwxbmm1qms2gU
         5HoafXYu4WDt3OiXrPrkwHNIONu4HTrr5pRbBu6hp/tz3Oe2v345gFjqMe3w+dv6Kp5T
         tI2jKzd3Qf6aVcQjfp6FBaRfS61L8Te0dbgyeLe5DzZFquSJ2BjhZWjFSRxxmSmw2uce
         s13A==
X-Forwarded-Encrypted: i=1; AJvYcCWDKs45jce26OxENWoW8fWYNMffQPH0gPKRvuzKKkomFvYWzNmmzgfKdH7wsUV0W26KOSispT+s/A==@kvack.org
X-Gm-Message-State: AOJu0YwoGb4hjV+WM3pN1ZYoQ728u604qZ8boCc7uelxPfcCgB1xz2RU
	QTOsFZiVWTJ+ZI6TLGDckTmybHF4IY8ufiyELdIk3YTZBhKeRVYYuOZCK5j8saKtXCcYcsij1zM
	oGhsjd3V5OXgDuT7t2TJlaYoKnJQZO+QwE3csGnGFltG+BqwrRwk/Qg==
X-Gm-Gg: ASbGnct2FH/ConxnjrxQjql/7PjORR4vrwOLG4UJTGEuzA/v9P10xmqeqArThKucoS/
	3lYrgIF5/knj7/QPzQq2e9g/E7Y44iJLE8s0VT7EqLvzrZuVcPGHvIpopvxlzeAs3YWQuZhiJyJ
	GZfyjgt2H4n5Zz4UEoyOmiBqsD3K6DdKs6FwAxuyid34o9T0r1jXli+ffGhxHpapUKLEJexjvlX
	E4Nbe7de8br7bbfOUoprTR8EJrNlMkeYrE49f+XHA==
X-Google-Smtp-Source: AGHT+IFziXJzytJXX8V2uYv9JkEoSd3HZIALQ0xi0m7DhPW5QVQdyv4IgeuqEnQfMhLjKaKljh580ZW1RBCE5CPbAp8=
X-Received: by 2002:a05:6402:347:b0:624:45d0:4b33 with SMTP id
 4fb4d7f45d1cf-62d4e9a8296mr256486a12.7.1757617534116; Thu, 11 Sep 2025
 12:05:34 -0700 (PDT)
MIME-Version: 1.0
References: <20250908044950.311548-1-lokeshgidra@google.com>
 <CAGsJ_4zuj1nNpS0Ap=x-_dqERTU_NiCZAiHD=JULY1FQn+NwMw@mail.gmail.com>
 <CA+EESO6H7zkgEOnmDEZoPL8+5EBD6UrJOBAvcU_gXyxCNZSOZw@mail.gmail.com>
 <CAGsJ_4zi6kb3fBC9e8GkjR2JTpiAN9rTCpb2HmRV3ri_kDWE6w@mail.gmail.com>
 <CA+EESO6bQRLkHWWEMu5-1QbwKptQDRkkEK4vf8oi1dH6mSz3OA@mail.gmail.com>
 <CAGsJ_4wux1JOTQjT-SdWOTOT7-+eFMQLKRjKNrhE7vE31u5Jdg@mail.gmail.com>
 <CA+EESO6eNfb+92+uYDRRWdx4SJnHGY34QtzbWUpoB54yjvL0xw@mail.gmail.com> <CAGsJ_4yJYUbP5DZcmvpe7GwEDYnjMsycgN0TXKZoytrCk3VXxQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4yJYUbP5DZcmvpe7GwEDYnjMsycgN0TXKZoytrCk3VXxQ@mail.gmail.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Thu, 11 Sep 2025 12:05:21 -0700
X-Gm-Features: Ac12FXzmJhqpHY6IbqDzpHInhcskuQDEWAr7Eh02NAeNWiFE3W0XcnYwiS-0JB4
Message-ID: <CA+EESO7yPcWMgUv_-sP+h9qs=ndppYM-Hzwq5tWpg=DbOUpirw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com, 
	ngeoffray@google.com, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0D0A1180008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 46pmkt8fyzrftgwh9cr48h5a3n4rsin8
X-HE-Tag: 1757617535-412689
X-HE-Meta: U2FsdGVkX18YZuLhobYVRp6sa90L801lMoaP2WsTIUZIpmpvbZNYj66RvRQaEPFKsG136GDztrm4+OVISNU5wvKhhKmJGTcmHBlT8tXlgrE/MMBJ1rdmMJ+BSFwhx3TL0V4bGa5pVJ/4M1OTp4iSwlqqEifS+wsNLO04TShbPMmJ0fPrqX0aQUM5j1ta/BE3NKjPRdAIqYG9aIJdE9Xc8Wa9zqlTsGkDVKnMwY40qw0DK6fEU0b/XWPlJDS644HroQpwBcz+r3qub6n5vUMPgyO/J7GX5u9Id4DDVdiYHHnKgcWu9AgNga09mRHENbXjJA9Tb1//omrUtdndIAoKmtsZZu/9OhX8YZKGBEGmqMLB8wY8+wWEUibGcPAU8P30zsqdZknRUCgeQD2+gDkZtiYZDmjbGFagihxEyRM7X9qh5kwPoBOFpdSqvGdfxpl++z8IVSChyUSLI05KN74VYCXz2j/Hw+s/RyJch6fgoh9HfI9qIGse/FXG1aXMej/9iVShERdKxXyvVZM7Q57wR3PnRax84FreRNhJadgf1KKQ66Cv+gM27vCxE4Hp6KLIagmBG6yfsWMXTTQmmxcJWgH0G9dwsL9nGWECh7eAoPhlGhgYIb12v+IurQma8HXvg7HtUKA817P8q+Wvg7KCebRcGo+bj7ETdYP3zOWZTOSIIQvHk9UY4pV5Wfxk2zm0CubEpidJA6uB2SPqEqUHqVRtS65mbsCZg9MM1aWRdDbZA6VwBBmItWkhsSNGkxGDbhdwFJE9xtyoiM1EIxfNXqOAd4pZ110hpvCSU85RFi4jul/pVIkmk4/9fVvnh484fMciU2eyJeEs6r80nk8rPyNmBF/DsfbsB7Jbd2AEQLfAhy3aq1FOi91lFtKNczk8p/QQ+tYTPzBH7HNlUshP5Egc6QW+xh4FOXLQvmR6tQLa8QymwwGJ8og+sKQHKSAmWhLc/+WstDiV2F45Qti
 QV+UVLAZ
 eUi2vX6q1omevVB7ej9KMBvUiRkJlx0rTgoBFpIC/8Fax7SG9SfChguzaDeh0tKLCF/UaqXZD0iDrRlYy+hiEksk4uBIWqRP+5FJcw5zt2dw16zfmVG3733/JyTIN2t1X1EGGBgBjcBKhp8HU9iIgDmqJ9BXFhYcdXIssbw004Dosih6RxFi6aA3CpyF2Hc2JVHVBE0EmeGgypRdV3Tr5TKMQKPD5o0prtV1e2DEcNQkgyibijYZuWdVZAwJAsrdayNg+R7vuEdy7UkDTczgybQshX0odB4S3a+NZ0TFiC8piW7l8g6dF1RhG89dExx5eZ5cr+5gjdG41gVQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 11:01=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Tue, Sep 9, 2025 at 1:57=E2=80=AFPM Lokesh Gidra <lokeshgidra@google.c=
om> wrote:
> >
> > On Mon, Sep 8, 2025 at 10:52=E2=80=AFPM Barry Song <21cnbao@gmail.com> =
wrote:
> > >
> > > On Tue, Sep 9, 2025 at 1:37=E2=80=AFPM Lokesh Gidra <lokeshgidra@goog=
le.com> wrote:
> > > >
> > > > On Mon, Sep 8, 2025 at 5:40=E2=80=AFPM Barry Song <21cnbao@gmail.co=
m> wrote:
> > > > >
> > > > > On Tue, Sep 9, 2025 at 6:12=E2=80=AFAM Lokesh Gidra <lokeshgidra@=
google.com> wrote:
> > > > > >
> > > > > > On Mon, Sep 8, 2025 at 2:47=E2=80=AFPM Barry Song <21cnbao@gmai=
l.com> wrote:
> > > > > > >
> > > > > > > On Mon, Sep 8, 2025 at 12:50=E2=80=AFPM Lokesh Gidra <lokeshg=
idra@google.com> wrote:
> > > > > > > >
> > > > > > > > Prior discussion about this can be found at [1].
> > > > > > > >
> > > > > > > > rmap_walk() requires all folios, except non-KSM anon, to be=
 locked. This
> > > > > > > > implies that when threads update folio->mapping to an anon_=
vma with
> > > > > > > > different root (currently only done by UFFDIO MOVE), they h=
ave to
> > > > > > > > serialize against rmap_walk() with write-lock on the anon_v=
ma, hurting
> > > > > > > > scalability. Furthermore, this necessitates rechecking anon=
_vma when
> > > > > > > > pinning/locking an anon_vma (like in folio_lock_anon_vma_re=
ad()).
> > > > > > > >
> > > > > > > > This can be simplified quite a bit by ensuring that rmap_wa=
lk() is
> > > > > > > > always called on locked folios. Among the few callers of rm=
ap_walk() on
> > > > > > > > unlocked anon folios, shrink_active_list()->folio_reference=
d() is the
> > > > > > > > only performance critical one.
> > > > > > >
> > > > > > > As I understand it, shrink_inactive_list() also invokes folio=
_referenced().
> > > > > > > Shouldn=E2=80=99t it be called just as often as shrink_active=
_list()?
> > > > > >
> > > > > > I'm only talking about those callers which call rmap_walk() wit=
hout
> > > > > > locking anon folio. The
> > > > > > shrink_inactive_list()->folio_check_references()->folio_referen=
ced()
> > > > > > path that you are talking about always locks the folio. So the
> > > > > > behavior in that case wouldn't change.
> > > > >
> > > > > Thanks for the clarification. Could you add a note about this if =
there
> > > > > is a v2?
> > > > >
> > > > Certainly, will do.
> > > > > > >
> > > > > > > >
> > > > > > > > shrink_active_list() doesn't act differently depending on w=
hat
> > > > > > > > folio_referenced() returns for an anon folio. So returning =
1 when it
> > > > > > > > is contended, like in case of other folio types, wouldn't h=
ave any
> > > > > > > > negative impact.
> > > > > > >
> > > > > > > A complaint was raised that the LRU could become slightly dis=
ordered:
> > > > > > > https://lore.kernel.org/linux-mm/20240219141703.3851-1-lipeif=
eng@oppo.com/
> > > > > > >
> > > > > > > We can re-test to confirm if this is the case.
> > > > > > The patch in the link you provided is suggesting to control try=
-lock
> > > > > > for anon_vma lock. But here we are dealing with folio lock. Not=
 sure
> > > > > > if the ordering issue will be there in this case.
> > > > >
> > > > > Right. Not sure what percentage of folios will be contended; I as=
sume
> > > > > it is minor. Maybe you could share some data on this in a v2?
> > > >
> > > > Any suggestion on how (or which test/benchmark) would be good to
> > > > gather data on this?
> > > >
> > > > IIUC, shink_active_list() doesn't behave any differently whether th=
ere
> > > > is contention or not, except when it's an executable file folio. So=
 I
> > > > doubt such data would be any useful. Please correct me if I'm wrong=
.
> > >
> > > Since we skipped clearing the PTE young bit in folio_referenced_one, =
a
> > > cold page might be misidentified as hot during shrink_inactive_list()=
.
> > > My understanding is that as long as the percentage is small, this
> > > shouldn't be a concern.
> > I see. That makes a lot more sense why folio_referenced() is called on
> > all folios in shrink_active_list(). I missed that young bit clearing
> > before.
> >
> > Any suggestions on a good testcase to gather this data?
>
> I would run monkey for a few hours with some debug counters, e.g. how
> many folios pass through shrink_active_list(), how many get contended
> and moved to the inactive list without clearing the young bit. If the
> percentage is small, we can just ignore this disordered LRU behavior.
>
Thanks for the suggestion, Barry.

Monkey test wasn't successful in creating sufficient mem pressure. So,
I used an app cycle test. It took over 1 hour to complete it on an
arm64 Android device with memory limited to 6GB.

During the test shrink_active_list() got called over 140k times. Out
of that, over 29k invocations had at least one non-KSM anon folio.
None of the folio_referenced() calls on these folios ended up with
contention i.e. folio_trylock() failing.

So, as thought, this patch doesn't seem to have any negative effect on
shrink_active_list().

> Thanks
> Barry

