Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 153E2C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 19:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9560D8E0003; Wed,  6 Aug 2025 15:49:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 906F48E0002; Wed,  6 Aug 2025 15:49:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5BC8E0003; Wed,  6 Aug 2025 15:49:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E7888E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:49:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D21F2135CE2
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:49:35 +0000 (UTC)
X-FDA: 83747372310.10.B7CECFE
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id EAF9F40006
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:49:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JOGunGfu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of bijan311@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=bijan311@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754509774; a=rsa-sha256;
	cv=none;
	b=ZGAHRHMpMCqvo65PU8LiLDgaZaOhSy993WkR6R3KPbIFV8oylOAlRqj1kKPZ5n2aA0SM5I
	IKjTGZ1V1gRkbuh2fZ3QSw4GTBPQ4Ds6eCgeiIZFP4kF5JeuyMgAF5ZbjiSTfG78pVrBHA
	wzLUCGsDYOF78fSgwlBReMcbk0+WP0g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JOGunGfu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of bijan311@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=bijan311@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754509774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NzyWsZ2VS7UdwxNHeGlEc8995qxMO9wJq8rXT5/QHs0=;
	b=OV6nlLKZQZ1N/aXxu2SKjCTY9ZunM8/OtkuI6M23p/4Gd9FAIbuqTQgoqeGoi7CFbWeh7f
	HsDTjNKrDZWJg+Qs+4GivICmEPGKWnMAg8WwOXFxYm8gCNgOP3jPL5FfwFGGLj7m7Rk2IX
	3L28SkpGDrSyEXuURwWpcOQiFY2JMn0=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-61568fbed16so370998a12.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 12:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754509772; x=1755114572; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NzyWsZ2VS7UdwxNHeGlEc8995qxMO9wJq8rXT5/QHs0=;
        b=JOGunGfu4R4dkHhQh4IQwpNAa/4g4TRxu5ofseiNRNtX0wIvheWtUye4wpPlVQeU4f
         Mg7qEZDWRLmaJTytduKHhMQLRehT4ubnfbvn4025zCAof6EHMx30vIQLOHPPNCbbMJAC
         lAqyTELgrlD239mLwbqPZBomDoYKCFFD5Euyc0KztfYGw0buRSSo4MgV7El2YFncG1G2
         UkjIJlYNt26uF/7fF7QuevkU8glxnZMTrRdQwC6245qwuiEdZ/w4FszZ3tSbd3/0oORy
         jEcleesHX/1sQ7vsovYKKvGMXP9mdCrHo/dGzJgXFfv6B3hGOvE1aW93Hdz+dPVrW0HL
         gzUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754509772; x=1755114572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NzyWsZ2VS7UdwxNHeGlEc8995qxMO9wJq8rXT5/QHs0=;
        b=tvBNPQa7AeCFafsSWsdB7lqmIM0OjLFR+ansXH27m2/A2TV1b8jpkruLEyB73n/2fS
         hUVu+UtE+Ac8/XC7rrKw7m6sgIOuW56ofUxklVswuo6KW7Qh0ndk0z5CdL8uVsNZFKWH
         BoWkn2PMusiB13JiyYuKxEz6skre3mo0hE7/rYrhO4DPAI/rB4UsXE3MCGlYQtih1cRI
         eFVKHhe5UFpMAw79v3Th5/5Sin8Gh3Qjvzfse9fyYVntaalVXHxcmFvEKf8dNHwMQsfV
         z923FvHGxIAu7DOqAv6/gxsESGt81zvDhWoL1YX9YcJ9HgvJ0yaGKCR3uC0LMuvRgry+
         C5PQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcY9ArEa9A3nb9E5+k/XiSHH2Wm9lxMz+TjO+QbTZbt+RKCZ7wfvbTLsxObWnaSNniRzL1HPDOLA==@kvack.org
X-Gm-Message-State: AOJu0Yw5M4vHm6tWjBUwTcZMB6W9ID2Wp7cYHXovRHmxGMCaPeWg6aPx
	8d2nk4k+qC/M6rUCSsAbJFYvJ6gK17lHz47zyYIl5fWBXAfwXkgDa9F7AvrJd22eSpP0DCoilD2
	1C3eCZDCY8eRkDD/XDWcdmlOym5KbZak=
X-Gm-Gg: ASbGnctOV0XWtPMWIGFUHivlqQ/eC1fEcL7jR0VdgLHguVT9pK7y1v93Pnc8UvhKdlB
	AnwhGC8/Wn0S4fKKsWU04hsr19+81VnSME6Wkzw+KSgouoYl0twRH96/HtlLTdOi1LPGIU2PCCT
	dMBNsgeSLEye7+RMaWzO9CGlKcjMSnNBJv8bQXDG4cmaKgSHZieZwBt4+Tcv/h2MzAubgU1q9T3
	m8S7ev86uZIDM9cmGG46pYKcjn3rkJoTHk3NG7M
X-Google-Smtp-Source: AGHT+IHukw8BGGSuW8sM5wvXX1qfAZ4M93eqA3YKb60zFiqlp++MkcgH8j5+d0SXTAfe/GHRE+5PKfydrhljxI3QUEY=
X-Received: by 2002:a17:907:3c89:b0:af9:3c4d:e978 with SMTP id
 a640c23a62f3a-af992bcfc70mr330720966b.41.1754509771931; Wed, 06 Aug 2025
 12:49:31 -0700 (PDT)
MIME-Version: 1.0
References: <20250806164316.5728-1-bijan311@gmail.com> <20250806190911.49728-1-sj@kernel.org>
In-Reply-To: <20250806190911.49728-1-sj@kernel.org>
From: Bijan Tabatabai <bijan311@gmail.com>
Date: Wed, 6 Aug 2025 14:49:21 -0500
X-Gm-Features: Ac12FXzxEB8wSXoRu-3qE9z6QIyTH6H8gAezWdHjpR1Yn4gq7IihQeGGFcbaJHQ
Message-ID: <CAMvvPS7Anh4qZu-VewZ61_QqfU9PDCaUpGjxZWeCdioTWkr5vA@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/core: skip needless update of next_{aggregation,ops_update}_sis
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Bijan Tabatabai <bijantabatab@micron.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EAF9F40006
X-Stat-Signature: 8b8x7jjuiz9pxp8ga6zb9d1e8fj73id8
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754509773-954230
X-HE-Meta: U2FsdGVkX1/KMO4ziLs+98mTZsvNWAzln0Pa9uQgkQGKOTG9zDXM3/7qKjVjiRTT11J65C2r7cVW6unNxL3yjl7f094G3sGgE86xEog2Cds274dFtwQ1hdy/PhA+izlO/VRHCvORNaWOAx/7cwCP+FTMNVNA/dPjb97e64LBnS9V+Du2z0+MswG6kb4VIQoRymr+SoIbQtrt+FerayhNSAgEVLMouZgxzH7UcLuJ4Ro6Dewsb9iiPlHZXmz/lhD8vlYuwutyFVD81mx8iH5wBghHl0WFl1wzoi72/7eUMZNUyL1NlBoLx0I3/tetDteclJD2U7DHSPgzx2pwh6gUls50UXTslhfnJguz3KAMoMySyl+GSIJy4cjjD3n4BnkhUuev5t1qubN3LPXZ4tbllWZ410UbE9aYOgj1Q1ttgEbE1sLD1+DiDzO+Xy9fjeisACBV5JkMwJFRFUyECo2n4BjWlLMcAD+0r1Jkr4/wa1o1gmW8fYSwcUsG1rSqAJF0AExn6fGi1leB+oGhV+5Zh8JSRecCQq2ReMAEoBCmmdHveIhGlQsEX25fb8XFk8fS6er3VF9Vgxj93dpKu2tDrFy+mLrxwqPrWjsTlve5IPO6w6R/eSh06DZ78w3r7yWrcAfY+E6IaLm0HK3ohOO/QCbsIlkPS2SYcLtnHyXLB63i0y/eSmHNM18rT5lXkjnLk3jOSo2dAS3geXmJCP0hF00OScZEQNL5ygSf7MWw9xArIV2FReiG7wwGxtFHprCGIvzZ9S7IkkJPomh8ilJl2VAqqpPjrbYzMw9VJg6EmW/hPuBp9fWRUceXTQa3fgDdTKn6CcvkEXV6sGjNES6L8gayPqNCZYuVXdLZ+dQoOdIlIdkMqrCYHkoPvGnC45nxTfwPKuEdTROoFCQ1qBJ/x0owOen5ndQDZP9Id2FskNRHLpa2OEZwtbAuqdHz3X7w65joLTcEyzkQ5F66yh7
 Jji7cssb
 UREDZZvKxzB9IdlKVq2pB+JM7iF+lNVg7QcVsX98PHFP9PJTMM8CZGliZsH8l2wXJmr86gNwHkITSbff7xlAyAH5ICvukqmquo3K/2rZEF+9/hw0lu6Z7r2giMltPHwU4DlkZ0yZtRFFcukhu1veapIH1bCyIk6KlCkY8YWqWHRXUkzYrAM+DK1OiI2xbZPxjPSVJTR/tmyWjnJpC+nfJdkKDjqah1fOcV2muwX/eTGGHX2G2g8JvyGJYdgpxzeqEjIyuUgXq3aYM2s+MJMqsZBWpzmbXz4pQZJrU5pBNC4ULhxVNSes5Ocv8qF/s4lxmmSEqq1yTJxJkeSOShAM6uB3H7AH1Azl369NuoP/Vz2OfInZqGqJo92IfDRsqhluhT/5dUFprQ+FrxNAQz/HRSLuYQC6/v3SaQBAMyb3ZcvsFevcBPofGy0GNl88hHJkokjOo6p1CZApwu8bNytWMIJOOgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 6, 2025 at 2:09=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote:
>
> Hi Bijan,
>
> On Wed,  6 Aug 2025 11:43:16 -0500 Bijan Tabatabai <bijan311@gmail.com> w=
rote:
>
> > From: Bijan Tabatabai <bijantabatab@micron.com>
> >
> > In damon_set_attrs(), ctx->next_{aggregation,ops_update}_sis would be
> > reset, even if the sample interval, aggregation interval, or ops update
> > interval were not changed. If damon_set_attrs() is called relatively
> > frequently, such as by frequent "commit" operations, aggregation and op=
s
> > update operations could be needlessly delayed.
> >
> > This patch avoids this by only updating next_{aggregation,ops_update}_s=
is
> > if the relevant intervals were changed.
> >
> > Cc: Bijan Tabatabai <bijan311@gmail.com>
> > Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
> > ---
> > This patch came from discussions in [1].
> >
> > [1] https://lore.kernel.org/all/20250805162022.4920-1-bijan311@gmail.co=
m/
>
> Thank you for sending this patch as we discussed on the thread!
>
> > ---
> >  mm/damon/core.c | 16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 6a2fe1f2c952..1c3d8b92257c 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -693,6 +693,12 @@ int damon_set_attrs(struct damon_ctx *ctx, struct =
damon_attrs *attrs)
> >       unsigned long sample_interval =3D attrs->sample_interval ?
> >               attrs->sample_interval : 1;
> >       struct damos *s;
> > +     bool sample_interval_changed =3D ctx->attrs.sample_interval !=3D
> > +             attrs->sample_interval;
> > +     bool aggr_interval_changed =3D ctx->attrs.aggr_interval !=3D
> > +             attrs->aggr_interval;
> > +     bool ops_update_interval_changed =3D ctx->attrs.ops_update_interv=
al !=3D
> > +             attrs->ops_update_interval;
> >       bool aggregating =3D ctx->passed_sample_intervals <
> >               ctx->next_aggregation_sis;
> >
> > @@ -710,10 +716,12 @@ int damon_set_attrs(struct damon_ctx *ctx, struct=
 damon_attrs *attrs)
> >       if (!attrs->aggr_samples)
> >               attrs->aggr_samples =3D attrs->aggr_interval / sample_int=
erval;
> >
> > -     ctx->next_aggregation_sis =3D ctx->passed_sample_intervals +
> > -             attrs->aggr_interval / sample_interval;
> > -     ctx->next_ops_update_sis =3D ctx->passed_sample_intervals +
> > -             attrs->ops_update_interval / sample_interval;
> > +     if (sample_interval_changed || aggr_interval_changed)
> > +             ctx->next_aggregation_sis =3D ctx->passed_sample_interval=
s +
> > +                     attrs->aggr_interval / sample_interval;
> > +     if (sample_interval_changed || ops_update_interval_changed)
> > +             ctx->next_ops_update_sis =3D ctx->passed_sample_intervals=
 +
> > +                     attrs->ops_update_interval / sample_interval;
> >
> >       damon_update_monitoring_results(ctx, attrs, aggregating);
> >       ctx->attrs =3D *attrs;
>
> Long story short, this (original) code is bit complicated and hence I sug=
gest
> to make this change less optimum but simpler.
>
> damon_update_monitoring_results() assumes it is called only just after
> next_{aggr,ops_update}_sis are  updated.  And the assumption is important=
 for
> the pseudo-moving-sum access frequency maintenance.  As a result, this ca=
n make
> the monitoring results temporarily corrupted, and splat warning once.  Pl=
ease
> refer to commit 591c4c78be063 ("mm/damon/core: warn and fix nr_accesses[_=
bp]
> corruption") or the patch thread[1] if you want more details.
>
> Also damon_set_attrs() is called not only from commit situation.  So I th=
ink
> this maybe not an ideal part to modify.
>
> What about modifying damon_commit_ctx() to check if new and old
> damon_ctx->attrs are entirely same, and skip calling damon_set_attrs() in=
 the
> case?  Doing the entire damon_attrs comparison might be suboptimum, but w=
ould
> make the change simpler.  I assume the suboptimum comparison is not a rea=
l
> problem for your use case, so I think that could be a good tradeoff?

I can definitely do this. Checking a few extra fields is no big deal.

Silly question, but think it's best to get it out of the way before
sending another patch: do you think there's a more elegant way of just
having a dumb comparison function like

bool damon_attrs_equal(struct damon_attrs *a, struct damon_attrs *b)
{
        return a->sample_interval =3D=3D b->sample_interval &&
            a->aggr_interval =3D=3D b->aggr_interval &&
            ...
}

And I assume I shouldn't compare the aggr_samples field because it's
private, is that right?

[...]

Thanks for your patience,
Bijan

