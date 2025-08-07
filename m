Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E544DC87FCB
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 00:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20E346B0093; Wed,  6 Aug 2025 20:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5FF6B0095; Wed,  6 Aug 2025 20:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123396B0096; Wed,  6 Aug 2025 20:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 02AB16B0093
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:49:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0663136B7A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 00:48:59 +0000 (UTC)
X-FDA: 83748126798.26.3C34818
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id D7A70A0003
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 00:48:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OZksQ5NE;
	spf=pass (imf15.hostedemail.com: domain of bijan311@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754527737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FyU0sgZz9qTulaKfMDXTxb3hNbzZ1ImXa4EG7joeiFI=;
	b=IGw8w+UriQSFm1+LSqMcW9mwyWhevh6OHBzv1KtSesSUUjOGQmowNuH/ssBNnmiHwHWxN7
	/G2/SCP/llf55utQGldBOPvL99vyq8jTQmq0b9o2kZqPPya/MT1OCBqFu7rgrIh1OytHln
	5HM5Q8MH/G6QL+H5efvl8dK5JBKjPj8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754527738; a=rsa-sha256;
	cv=none;
	b=gns1Xcj3lCPrWnqd3F0xlfEtOASFoWPBhK869nUkO8hpQc5eko9xjEFz940HVgi0AOCq+x
	5rmMQoBRUxGs1YII6olxWMYuWICpHg+rzU2e5lCjy+0Jn66s053S7pctNTKduBPwMrKbT+
	YXqeOjuvfx1U1RNNb1uGV1TWrse6pLk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OZksQ5NE;
	spf=pass (imf15.hostedemail.com: domain of bijan311@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=bijan311@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-af8fd1b80e5so77955866b.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 17:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754527736; x=1755132536; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FyU0sgZz9qTulaKfMDXTxb3hNbzZ1ImXa4EG7joeiFI=;
        b=OZksQ5NEpxflI9RqYrBK5JDZlmk3g9+WFLSHcO6kOlS0A88rGWNy27zvzZDNmLACiY
         i66exnHvwRfSulQFSaK6+7312KC65Tf0boAXERx0xKOZWkDyL7ymAXXflr5b97Wv4je3
         SLS/BB3wlaNNOD0BogiihZqfIUE/3l6qcEArUAmB1+iBlsMxkLVNlJaVXGfmfVDgymMd
         hid6cE1ET13nv5IRWsgE0PaqVRLurekga+hge6/ilnPUAAlwZtE1HdMRk2JF3C133ix3
         6m8z/t4gy857sPlSij10RqAI+Fwzth6pNOdKLdjHxXQ/ytSInxWdgCBCOkayG5XVs8Na
         8BuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754527736; x=1755132536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FyU0sgZz9qTulaKfMDXTxb3hNbzZ1ImXa4EG7joeiFI=;
        b=ZstB3tLXivSJJe4PjCl5UO14QQ8XTzYkfBRwQ8ETnYxiPqLUP/KHoe9VabxgA+pTDv
         oTuhjFvJAibzpOYR//iV/81IqrVZYaOR/AwTrL0Z8PhJkf1+JYCwtsFWOSCQCAbw1vnq
         wbCf0jJYXWbtK44uMAC2nrU86I9McDgxxs6CvN4GOWSFrOS31sXCDPpVIS9AAwo9Bba6
         vPEMU4O74b5jJanR8mi1MfcS3pLGQhgRaKIgPavKZG2X0ESmAu0/c3+EQBpP+owlwulz
         AO/V6p6uratprfUClTIhhjXg+weN8zKffkmtJOKb3TS2NetvrnYcHJo+sXVnfUnV2pNe
         gRGg==
X-Forwarded-Encrypted: i=1; AJvYcCW4b12VXMUVEBw9LWVl3aeCgO/4PObIBf1o3GnxayMtEL+tPzYwuWF2BGQhxX/xKnc5oCHAsqOeng==@kvack.org
X-Gm-Message-State: AOJu0Yz6pAr+d50vGlhH0/9jGjrOh9rQ6Nxmedg6xuvyOAX/HkICUmu5
	c/Ggf1Eu0s1FRixkAqtgf5qmZwFxFM2fbQOdD8YCE8Rubo4sb75nqmI0ZstrJkHeHvo01hhqzAG
	7VmVo+U+PupT9vuykXHS15VAboXDYp/Y=
X-Gm-Gg: ASbGncubImiaTUuOOtrOIHgXfSLFXxmlWHBwy/0EkmcdDhGnY10uQej8bBH6QJr4TY3
	uKgVs3gi5dleVHNdjFO69yrjoHb/J7ni5QDiZxmFJrAFIuJSY5Bfm2uNdnBkLj7BZ2G+xAudH+1
	Xq9Uu/HRJl/Q5ihkA6PKT6K2kkFpAhpuzF3EIA46O4VnwNpJJXX2XSeG89JoXxPX4qwEa3/zszF
	t/SJI3NgdXopxya77jqndGy0XsFpZUc6JOvsXV3KF7bze+3IEBhmvph7h4th6A=
X-Google-Smtp-Source: AGHT+IFQwMopH6azHH9WIpfqyaRZ5dbJlxtTcRscsdnncSFoc6hUjK52CP/r7T5PFLOBcK4Y/4ju5GykKep2RTRqt/w=
X-Received: by 2002:a17:907:7e9c:b0:ae3:5e70:32fb with SMTP id
 a640c23a62f3a-af990105cdcmr469979166b.4.1754527735982; Wed, 06 Aug 2025
 17:48:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250806234254.10572-1-bijan311@gmail.com> <20250807001924.76275-1-sj@kernel.org>
In-Reply-To: <20250807001924.76275-1-sj@kernel.org>
From: Bijan Tabatabai <bijan311@gmail.com>
Date: Wed, 6 Aug 2025 19:48:44 -0500
X-Gm-Features: Ac12FXy1RsWB25PBoiuQCuL0TSug1jNHZq5fTiL_FTzQznrao8zQPdz3aIU7wRQ
Message-ID: <CAMvvPS7mcevjD-b2vz1P+grQfffVA0bx-x5WcUQ8=JApD+UkHw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/damon/core: skip needless update of damon_attrs in damon_commit_ctx()
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Bijan Tabatabai <bijantabatab@micron.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D7A70A0003
X-Stat-Signature: nbq4ka18hj5f9zgq4p9jryp7qcjd3q91
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754527737-517199
X-HE-Meta: U2FsdGVkX18PH1DxwyEfWaRvdxfAS3b7pd3vFRnOqm7KHc+c0dsKqCElwFcanLBrDj9FzKnNEjZSj8CLf2LFfXbzp5Wq/i4ny6q2hz1UeXIhJASxQw+ZNA25IswO7nHn5VXGtt3iwOHKG4I3V9+BKgujcVqmil69xR4mxvgP5ensnRVyX8fZvBUg2AEogI4+YKLhRtewf20Vy2XnLmJGTTKHxbcNeXaE7IEsNUM0MB7EEtLKMoJAGXrGw7P6Oyiuoc/lcuOhHS7XpWSZt7AICQuuwyEH+S97xdmkQAN/Vtz7KmhomZ8wiLfQjgSgM1XmHlQoyQS/YjTuLO+KejAcEBEnSEq9EWOt//I6sRSn7LUHNO+b8kcF+07os65sfwUhL6poMymjUROCdEv9bXqak9bv201r2Rqc2oXE8CFDcIbEooTnVZDZCt1xG5WYWXGuxJjznOuoJ2K4AnB2RjisuFHbzK3I8V3icL4EcrmH2nzr7iqVj5pzt/AuGct+Hliyjl2F+3FmKllZpvuyyGH7bm6neJoouQYCvOrjtfK/F7WlDAlSrrxHBO/xrPboQMRLcVarcAD12RpCzPLq9Sa+O95LnEY0nuY88D3W/6ps7FGZWoNjro2TidU1CatEg6iSJsy6C+sBtRk437Fm2gU2gjTwaHbBuuT48/D8sl37bbqK2FC0p6t4zSaVYVTmA9iqrtCarvLiTMC2NtTAvXY3Loi/QMIZsaJHPBs9L85C/xVfzfOcZAd/BWFaD2ZoLXp2StGej3ZM4c99kYIp4bvuB1zCogWG90gCIPy2N+IprI+hxUKDbNMo8g0QniBB8s1yDZG2z12rHbAdkSUvi6HNrlGOcfYsUHsowxxJP1Z6PpN5cX372WEgWd1xHKuPa+Ft2Y4vZgQk1+CU+Xp3r68pSs9b6NYAJHLKOA9x/3i4rv4N6UTb0eE05pXwebhns2zOOd+VLPyaQ6o3IKdp3kf
 q73F+s3U
 A02Eh9zUWxGiW9tRlSdxo+4SoKoD6qnTxm2QvVUXMlJ36W08cv4ICfZbCe6IhmaAnCuLJoc5Bfwq/zDcLXGQp/SaEK9VMoAX5kWwPerPd7y9Kr8RuQREEK42bhxqxe1Piy3vY3wKayHQ0OLil++qxRQZ8npIAeFaoXtFz/uPg2yMP967ghuvDQhgGHDpeCK8L4BPvowHl1v2M1Z/DG6EAJnENPTi4AtO/0c70QrzKCj3gSxZ+9EU/9RRM2oskrwaLwsdEqFd9iVDj5WGTGj0YxvKKvee22mUdM7rTGYV3bnSpyFornY+S7ey0EQyYUVoBrPHP1A0EHGnDI1cWod0wYsb2u/UoftegrFaR87NLkkpxpST5oUY0hCmPR9gIVzh7mtcYIevf0784I/kGeunvTgsBApcpy4IL+hKO9YQatAVWjxIiod6NLCMSNsTPUIWlZ+ZUIiKHztxpAeAnke/WoP2kr8Ab5n02xK1VYmQdbp0T8F+Rh2K18mBKmDXXD1meaSJ2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 6, 2025 at 7:19=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote:
>
> On Wed,  6 Aug 2025 18:42:54 -0500 Bijan Tabatabai <bijan311@gmail.com> w=
rote:
>
> > From: Bijan Tabatabai <bijantabatab@micron.com>
> >
> > Currently, damon_commit_ctx() always calls damon_set_attrs() even if th=
e
> > attributes have not been changed. This can be problematic when the DAMO=
N
> > state is committed relatively frequently because damon_set_attrs() rese=
ts
> > ctx->next_{aggregation,ops_update}_sis, causing aggregation and ops
> > update operations to be needlessly delayed.
> >
> > This patch avoids this by only calling damon_set_attrs() in
> > damon_commit_ctx when the attributes have been changed.
> >
> > Cc: Bijan Tabatabai <bijan311@gmail.com>
>
> Maybe above line is added by a mistake?

Sorry about that. I added it because my internship ends this week and
wanted to make sure I get notifications on the status of this patch
(e.g. email notifications when the patch is merged in Andrew's tree).
If it's inappropriate I will remove it in the next version (unless
Andrew does it himself).

> > Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
>
> Reviewed-by: SeongJae Park <sj@kernel.org>
>
> I have a trivial comment below, though.
>
> > ---
> > Changes from v1[1]:
> >   - Compare entirety of struct damon_attrs
> >   - Apply logic in damon_commit_ctx() instead of damon_set_attrs()
>
> Thank you for doing this!
>
> >
> > [1] https://lore.kernel.org/all/20250806164316.5728-1-bijan311@gmail.co=
m/
> > ---
> >  mm/damon/core.c | 26 +++++++++++++++++++++++---
> >  1 file changed, 23 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 6a2fe1f2c952..80aaeb876bf2 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -570,6 +570,24 @@ void damon_destroy_ctx(struct damon_ctx *ctx)
> >       kfree(ctx);
> >  }
> >
> > +static bool damon_attrs_equals(const struct damon_attrs *attrs1,
> > +             const struct damon_attrs *attrs2)
> > +{
> > +     const struct damon_intervals_goal *ig1 =3D &attrs1->intervals_goa=
l;
> > +     const struct damon_intervals_goal *ig2 =3D &attrs2->intervals_goa=
l;
> > +
> > +     return attrs1->sample_interval =3D=3D attrs2->sample_interval &&
> > +             attrs1->aggr_interval =3D=3D attrs2->aggr_interval &&
> > +             attrs1->ops_update_interval =3D=3D attrs2->ops_update_int=
erval &&
> > +             attrs1->min_nr_regions =3D=3D attrs2->min_nr_regions &&
> > +             attrs1->max_nr_regions =3D=3D attrs2->max_nr_regions &&
> > +             ig1->access_bp =3D=3D ig2->access_bp &&
> > +             ig1->aggrs =3D=3D ig2->aggrs &&
> > +             ig1->min_sample_us =3D=3D ig2->min_sample_us &&
> > +             ig1->max_sample_us =3D=3D ig2->max_sample_us;
> > +
>
> Unnecessary blank line?

Sorry for missing this!

> > +}
> > +
> >  static unsigned int damon_age_for_new_attrs(unsigned int age,
> >               struct damon_attrs *old_attrs, struct damon_attrs *new_at=
trs)
> >  {
> > @@ -1198,9 +1216,11 @@ int damon_commit_ctx(struct damon_ctx *dst, stru=
ct damon_ctx *src)
> >        * 2. ops update should be done after pid handling is done (targe=
t
> >        *    committing require putting pids).
> >        */
> > -     err =3D damon_set_attrs(dst, &src->attrs);
> > -     if (err)
> > -             return err;
> > +     if (!damon_attrs_equals(&dst->attrs, &src->attrs)) {
> > +             err =3D damon_set_attrs(dst, &src->attrs);
> > +             if (err)
> > +                     return err;
> > +     }
> >       dst->ops =3D src->ops;
> >
> >       return 0;
> > --
> > 2.43.0
>
> Other than the above trivial things, looks good to me.  Thank you again!

Thank you!
Bijan

[...]

