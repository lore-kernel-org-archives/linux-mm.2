Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B171CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 07:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C5B86B00EB; Tue, 19 Aug 2025 03:30:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7764A6B00EC; Tue, 19 Aug 2025 03:30:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664EB6B00EF; Tue, 19 Aug 2025 03:30:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5009C6B00EB
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:30:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1098DB7F3F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:30:57 +0000 (UTC)
X-FDA: 83792685354.21.CEB3ED0
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5A1A7A0008
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:30:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W+dcDrzU;
	spf=pass (imf25.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755588655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8A3lRrUmhcKBoeRoSo9KGlZI+P5MDqfwClgrD0+6VbY=;
	b=yQGE0qLzAucIQwFps2MWXo02Bmyepc/kq5N3qcBU5tWX5zpEONuu+tOFxMKgi9L9XR6SWk
	vXldgbv3Ks9ozjb7U5mv195ly2HH0Oe3zlDx06AwDuXBAgQSpzIKSDamTagrKZ122FT5Iy
	gtxTLruL79qpioCIYFNvjDB8/9Ik3u4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=W+dcDrzU;
	spf=pass (imf25.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755588655; a=rsa-sha256;
	cv=none;
	b=jXHb9Qlqk2DlF4phNaFaF99JOclBNsb87aOx2MlAqQB5aNMymBqmCpUhODCptPwlpfpE25
	k2wJKDP61IJA9CDOGl3AOB4KHsamt7Zp7+h6JYJHCLQWxZbXL8gv5bcoR7AE/9JM7jRRZJ
	5tY9dszZqKaHLOrdoitz03q/I+FEFsY=
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-30ccea94438so3343549fac.2
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755588654; x=1756193454; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8A3lRrUmhcKBoeRoSo9KGlZI+P5MDqfwClgrD0+6VbY=;
        b=W+dcDrzUIln98qaJukN9XWJ0pYzGAJ+vo3yTURCiQ+vJH9O95Pu+rtElXBcs43DG+S
         gkE2Lr6w4xltOynXCSFUXChJ4lwam0gV4lty2a18JuumCS+huhBlD0Q9p6tOu5QVZEYP
         L9pS85Ugs8snb7jYICxTAuOpZNBnZ4cFZ5z3da5e4a+KdHHP8+XGnlPqcQ02vp54ZBjA
         XB10A/S4ibUUR3DOBWDm1EWaQtdhQ83qkEgEH2+DEqN6dv9/IIlNeIUf3N2yhOrPFpQ9
         WKf7RiqgYS79M6znvD1ewjvHsMrk/Sqa3x47GMdNzQjH/sA8eGpszgC/Ux8vcT+aRROn
         wcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755588654; x=1756193454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8A3lRrUmhcKBoeRoSo9KGlZI+P5MDqfwClgrD0+6VbY=;
        b=ur0F8F4DrpbtPGSmXmoGLlHsX0pRk2AcKvyL5Rd5GjouhQVY2QMBqMLpwnUr3jFVa1
         Q2sHminOTR4yV+DNMMNhWlyvLxiUbO+qXBOzhzFzQS1Ju2Fs1BWcQV0ptj4RTDzFfKAM
         6buTEvVAU4Om3TkeZgmIXDp0HxiIBZjy7jCvGrp4tnx0vDBLgjDiDzeCmCHZiXe8rkt7
         APJzS+0bldoGslKJjyvfECxXebEg+XK3WaSKl+MaYtc3iEwZU9ktDLKJrjt6TpntF8kL
         0SbFASomZS3dT3SuzrUxSUok7XYCG7Ipzl7fuE9rrUHUYjxFiSS8L0xuZP91uICN8Yp2
         G3Rw==
X-Forwarded-Encrypted: i=1; AJvYcCVX3VyXbDsKHDxlucEhMSEMee2O0NQlydlrbMtGJ1tIqOVeffMZugD0qBW268b0rNnIsPbRDNX76Q==@kvack.org
X-Gm-Message-State: AOJu0YyzOQ1qOf6jxRf0SxD1SD+eisKyZY8GUyHdkr7iqRkzAbe9pNrk
	OBk7kGl7NBn4O2zIi2r+vAtjpQ1KEER/t2PKRhLhbkqzF4gUGGvZiyo1Xpg+0cOpQuuXiW1BGvE
	Y0GoLaq0AHv5gkiEFFamaWfPIql1gigw=
X-Gm-Gg: ASbGncuD12pqPsd9tvNCVJmcGvkG+6yLZRJjOKm0ZekkGS8zjxnZPU2t0w9tvWroUXY
	ZR7KcMvGgQ4uwEz375k8AUwj6Vswoxo/Jg04il+yxq6CIffDk9Fl0ICq/l0XBNedoBNotzSa6Uv
	rtovzDAt6u4w6dImauWoefA45HCZbyZrU3b0VVKDUIgO7tHgFB6wViqdkqczMsNOz3gdVCVHPQ5
	RLE
X-Google-Smtp-Source: AGHT+IHo9E+Ay4b6CGxhfla0xIwP4IxvRxaBWauEjxrlr4PbTxTTTGDiDt0U9yiuYkuBZCIvztT3wUwOBRyI4LpPSrw=
X-Received: by 2002:a05:6870:210f:b0:30c:347e:bd34 with SMTP id
 586e51a60fabf-3110c0084f7mr1135578fac.3.1755588654099; Tue, 19 Aug 2025
 00:30:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250818183803.1450539-1-ekffu200098@gmail.com> <20250819052539.38526-1-sj@kernel.org>
In-Reply-To: <20250819052539.38526-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Tue, 19 Aug 2025 16:30:42 +0900
X-Gm-Features: Ac12FXyvAGBa2SmkxF-KMcyPgNBPvNMYaluWCiXVi1lPx9WcFpbaMHI5TpDxSio
Message-ID: <CABFDxMFnVMbLDW4ZHo1Z2WHdWtcEjSZZ3qOkc9s7G=YfvEj0-Q@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/core: set initial quota->charged_from to INITIAL_JIFFIES
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5A1A7A0008
X-Stat-Signature: c763n5mbtg6z56hmrwi4gzn883yfar13
X-Rspam-User: 
X-HE-Tag: 1755588655-481070
X-HE-Meta: U2FsdGVkX1+OBqovwliilzY14dwO+VSPHMMUB+ptkUcl9cMucsQtoS6KnJWyyEPP4Y/yh1mqFkw8BKz4gnn6CoHj2TiSEvDgPZbSNSB7g1AntqlfnAtnjT5+RgizR4aKbYeGwBT8toLRUOlGTL5rt6ClWmnWK4pft3CRyZuAWbVD8VW/DBUEMKHi0aIEkk3uO0l/hrr1S3mqEmy3mETF3yfwOR366wSMpfgS3JuWglxAzT4nua4U2I1jK4g4edqIrchdXOegfWATZ6ojN0Wb+6tRQF5jBk4CoKtnECqlya5H1+mxg9IJnKwJS/ugft5RHhn4w9yLCJL7Axot1B+AJSFTFbchSV+OjUCZa6jvnvhdcb4XDOjQUHjl5QFL6zlyqc9w37hB1mU2h6ke/DHi4b1y62CRHmMQ2fL2rwvXjUvlxvqwuYcUTSOVfJHS0vnqL/2ngybKCy0KY1YieZ9bLYdEBeOgpJ+sAxpmvJx3bWYjePngC+M7u3Nsaam3qcT97+powyumfwbEI5AixBCmdRhyzQQecyarqBIOwdmGtgy53MeN2BPOa59UmA20JJiX0oZAfIkdZrpojzE8egi1xwKhp6q7gmed5z88X08YB+RQVWtPwpd0mkltRTa1caylyMssN5sl0gLbVOHXoWqfpt7yzJwAtrRnHUyRl3QPvIzsDqWGSbw4Sns5z1lPCsUe5PVy4svrrKOOWHmsfAwz9fFPxfkHb142H35L0nZDZNnaXfiOhTlyhDqDypp/lCL9lj2XswQv4X1u4nQ33MUsdWn6eHu1EOlqkzPN1nXCyXoBbK129LyZFCZnQiImoBNZudXRlos4tYbEts/VGnfTIbM3JVvETu407jXS4MxaP5greQ5rhUZ/7RlZbL5kQAEcW+/LtvKnFPGMhH1igz48NFvkEgGKgge0qAyJstzJsGP1k5nfzD6pJjbfTYFWw+wOL2jmDNccyxs3oEeRoFu
 8B0TWaAY
 V/MT2LSdY4VihpWO9e0mb+hHILG4rKRzIyMSboZ84eMrHC4oOZtTnAHgpn8yBXTXd3D0m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 2:25=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Tue, 19 Aug 2025 03:38:03 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>=
 wrote:
>
> > Kernel initialize "jiffies" timer as 5 minutes below zero, as shown in
> > include/linux/jiffies.h
> >
> >  /*
> >   * Have the 32 bit jiffies value wrap 5 minutes after boot
> >   * so jiffies wrap bugs show up earlier.
> >   */
> >   #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> >
> > In 32bit system, if quota->charged_from is initialized to 0 as it now,
> > it will not adjust event if reset_interval_ms passes for the first 5
> > minutes.
>
> Thanks to your clarification on another mail, I now understand this can h=
appen
> because time_after_eq() casts the diff of the given two unsigned long val=
ues
> into signed long type.  I might be not the only one who can be confused o=
n this
> part, though.  I think at least I of future will be confused again.  Plea=
se add
> the detail on the changelog.

I am also confused with the above things. I'll add more descriptions
including time_after_eq() as well.

FYI: If we use jiffies_64 instead of jiffies, maybe it will not be
confused anymore. but you know, maybe it can be a big change.

> The above explanation is not technically wrong, but I think it is not
> describing the issue completely.  The above description is saying about o=
nly a
> case that a DAMOS scheme with quotas is applied just after the system is =
boot.
>
> But, a similar and much worse problems can happen at anytime if such sche=
me is
> applied while jiffies value is somewhat that can be casted into any negat=
ive
> signed long value, e.g., about 25 days after the boot, assuming HZ value =
1,000.
> In the worst case, hence, a quota charging window can continue for up to =
about
> 25 days.

Maybe I'll add more examples of problem cases to commit messages. I'll
try it on the next version.

> The same problem can theoretically happen on 64 bit machines too, though =
not
> practically early (about 300 million years after the boot, assuming HZ va=
lue
> 1,000).

Yeah, in a 64bit system. I think this could not be a big problem.
Maybe I can add this minor comment to commit messages as well.

> If I'm not wrong, I think the fix of this bug deserves Cc-ing stable@.

You think the same as me. I'll find the commit and add Fixes and CC to
the next version patch.

> >
> > So change initialize value of quota->charged_from to INITIAL_JIFFIES.
>
> So this will fix only just-after-boot time issue.
>
> I think it should be initialized to the jiffies value of the time that th=
e
> quota really starts being charged.

You're totally right. I first used jiffies(this patch didn't show that
anyway), but while trying to find other reference commits and making
the commit messages more detailed, I got confused. late night issue.
I'll fix them.

> > This soultion has already been applied in commit 7d70e15480c0 ("writeba=
ck:
> > add missing INITIAL_JIFFIES init in global_update_bandwidth()") or else=
.
> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> > I think it would be good to add selftest of below senario.
> >
> > 1. Set DAMON with quota.
> > 2. Wait and check esz is updated well.
> > 3. If esz is not updated after quite long time, set test to fail.
> >
> > but I'm not sure that selftest can support environment handling; jiffie=
s
> > with INITIAL_JIFFIES or near there.
> >
> > If there is another method that i don't know. Could you please let me
> > know? Or any better idea?
> >
> > ---
> >  mm/damon/core.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index cb41fddca78c..90317a3bcf78 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -366,7 +366,7 @@ static struct damos_quota *damos_quota_init(struct =
damos_quota *quota)
> >       quota->total_charged_sz =3D 0;
> >       quota->total_charged_ns =3D 0;
> >       quota->charged_sz =3D 0;
> > -     quota->charged_from =3D 0;
> > +     quota->charged_from =3D INITIAL_JIFFIES;
>
> As I argued above, I think we should at least set this as 'jiffies', not
> INITIAL_JIFFIES.

ditto.

> Also, damos_quota_init() is called by damon_new_scheme().  We cannot guar=
antee
> if the caller will directly start DAMON with it, or commit it into runnin=
g
> DAMON.
>
> So a better approach would be initializing ->charged_from at the beginnin=
g of
> kdamond_fn(), e.g., inside kdamond_init_ctx().  For commit case, damos_co=
mmit()
> may also need to be updated.  To me, this feels too complicated for stabl=
e
> kernel backports.
>
> What about modifying damos_adjust_quota() to initialize ->charged_from, l=
ike
> below?

Oh, I missed this point. I just consider assignment points not timing.
Thanks for clarifying. Honestly, I think changing kdamond_init_ctx()
and damos_commit() are more accurate solution. but I agree with your
point as well. It looks a little bit more difficult.

> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2130,6 +2130,10 @@ static void damos_adjust_quota(struct damon_ctx *c=
, struct damos *s)
>         if (!quota->ms && !quota->sz && list_empty(&quota->goals))
>                 return;
>
> +       /* First charge window */
> +       if (!quota->total_charged_sz && !quota->charged_from)
> +               quota->charged_from =3D jiffies;
> +
>         /* New charge window starts */
>         if (time_after_eq(jiffies, quota->charged_from +
>                                 msecs_to_jiffies(quota->reset_interval)))=
 {
> [...]
>
> In theory, this can also incur wrong behavior in a case that charged_from=
 is
> overflowed to zero while total_charged_sz remains zero.  Such cases would=
 be
> unrealistic, though.

You're right. I agree. It is just in theory.

> And even if it happens, nothing goes really wrong.  It
> will only extend the current charging window for one reset_interval, once=
 per
> jiffies overflow.  Meanwhile, this fix is simple and can be easily backpo=
rted
> to old stable kernels.  So I'd like to recommend this option.
>
> What do you think, Sang-Heon?

Your solution is reasonable. I'll apply your direction on the next version.

>
> Thanks,
> SJ

Best Regards.
Sang-Heon Jeon

