Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E550CA9EBB
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 00:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 347C36B0096; Fri,  9 Oct 2026 20:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D22B6B0098; Fri,  9 Oct 2026 20:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 199D36B0099; Fri,  9 Oct 2026 20:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1C556B0096
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 20:23:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FE6D1205D7
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 00:23:36 +0000 (UTC)
X-FDA: 85304818032.03.ED23195
Received: from mail-ed2-f8.google.com (mail-ed2-f8.google.com [74.125.228.72])
	by imf20.hostedemail.com (Postfix) with ESMTP id 703831C0008
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 00:23:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QC0yYW7h;
	spf=pass (imf20.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.228.72 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791591814;
	b=Yj5wZTv72HPBAsO0ACexHn1B+RluWgd4ylLr9h5ZCS455HmWlJ99GN3QRGt/LbojHfnGFJ
	gzfpVwRYb7VFcs9JQ+4dRPnC3szKEMpde77crfp6dCpbV9Nl+N9zSU0jud0tCrb2dEd+6U
	lDTBSkqgKtDElj+u/1NqAqkQazy/ckk=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QC0yYW7h;
	spf=pass (imf20.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.228.72 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791591814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E5Py6HL+QggVsOTpYoDRwjrwSN8ziJN3Kv+kCMYmLTg=;
	b=iskJQQqNIiOoKKg7kiQ7FMl2Ced4QrMeH0rN7z0ZL3RKG19Xj9wON+H+l2TWUxxUgEStb4
	gWDdtkCD4QI3t5YbVnBWulATBGvwJ72VcdXlG1Zpo8HYliv66GNc85uFmKB9uBIMOo1oc4
	0xcAE49QTUqBReoIZbbV97j2SSiVECE=
Received: by mail-ed2-f8.google.com with SMTP id 4fb4d7f45d1cf-6af61a7c893so137702a12.0
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 17:23:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791591813; cv=none;
        d=google.com; s=arc-20260327;
        b=CQ9lRXJwPXLBzJvjrfoBiNCMovh/rbTIvIbQhYvSocNc4z4Y3UDwwWf5dLwgrkXv7+
         YYzcCTR/S69npHD9jrdpRHgF2CgJ1BrC0XV7PBfP4kigritJdcHFv7al3SHNOfH512uU
         hK3IwcDDyvzzfjBY5tSDTlvUMpau1WtQSheVFq3Bpy2xtSIVbRJEbV7Ywp1M/8h6qnnU
         E45G6OMBjzbsaN+T6zL81bQuhSJpb8zD82orvPqz/fWXxbK7axcOlM9u2r5AIVzPIqay
         qojogOymGn3JqsjJOavbTQ/UcxyFWWof7IOAcgG9rRdiFbYgsd180hoH9uzb+T1alGah
         eVFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=E5Py6HL+QggVsOTpYoDRwjrwSN8ziJN3Kv+kCMYmLTg=;
        fh=kwEfUjelwE/IyEJR9B4nnClplP2Ktpi5buD9McDtoOc=;
        b=odERuXBYqb2o9VR/pPTQiM8u3Iy3sbIpgJLdYw70dwp0j5JiS53IU4YpZy4YHaTGmr
         fYgBgmSiCDGZd5O8UFKPg+VXvfnoN+YiMCYsZZ1KP6UqSZty1XCeQZ4KgWkFlAJnIg8Z
         No82fvhi8PYrG2WFOm13eARjl8IswTPgvDp1ObIvvV6f2ZyW9HC+zvH0WAHIklhrYvjY
         5UAzjIQ3vgDSrCvpLhsraK//tag7ZoelIJJQC2JXdUl0v/zhyNxlK0qAN4RlQMuziTLN
         lpkExerjJlO/LBwOtyuxh5xpHEOI/CYiwyT4A8c3p0Zwh/ZFij4eo/gMlsjpAXhkHvrA
         af8Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791591813; x=1792196613; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E5Py6HL+QggVsOTpYoDRwjrwSN8ziJN3Kv+kCMYmLTg=;
        b=QC0yYW7h3KjJL3QPNH2PL8Dab9jnv0cdQPEFBv7QPxG4CviJUnVv89KSG8tblZ/ATC
         Rzxfo8LNqeTb1hu01538LcYljG4eyS1x+6cxmMQmoSdchD/+rH0f2e8y3G236JQWUklG
         MF8ZNLXakOZbmwq4T3LcNYf3wDgueMlaXXyHZQZ6xyAM0Qf/uwAttlFI5sBHU1s6i2ZA
         UzyKVvlrtC9OvN0S/W17faMFbHf28h++sKSSqpDf3j8SwJ0tSyEESY8UOmnyYfDUBNDV
         PpckpynIHuJ7ZLoIIoguwsxj2iEgoQjOekashSWn1ln3EOgZ3Qkh69Ei6oOXkXWtcQFJ
         PBtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791591813; x=1792196613;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E5Py6HL+QggVsOTpYoDRwjrwSN8ziJN3Kv+kCMYmLTg=;
        b=myHDmbByiNBCPppeq8Qtkmx2nRjn09r4ebHP6mQSG9MQqBWfG7+R3nVCvoO1F4I1pT
         M7KJmEdr8DMAfIRB6nTBO1tGQXoF5Iya+baiF+hM2sMi5cCO8+Me/uJG9R9r4gaK6Z3J
         ssYW2RHrvD1Uec6NRvDijo7KjoYe/eu1cjvtV/Z/47QJUwtlXHNuVHP6HLqfQilRKvDm
         H9iamcaRf0MFOvHovNS0DUTeFtRpejOf3gMGRR5MuUA51/90Oagcr4A1DMkxhOvoIqDy
         2njfs0wbkUsG4In5ifvA7rdOGLBK3DqP4inLqGTot/2c2VoeKFvzuCT6dUy6id7/wdLw
         AJvw==
X-Forwarded-Encrypted: i=1; AKwUvBwQIE+hSr/bsSunP1cHLA0eHTrmnQd9yuW6IWvojlPlenOWVFFah6qWIaWuOCkIqgX3UucFysR5Cg==@kvack.org
X-Gm-Message-State: AFq9FYKbyvEspUXANWuYN317pOA0nVoM55cMRQXCcxf4f1eVDA2UB6vJ
	4o5av/Hqgoppl1zmfRRtTjBI8MMyALtpz/R5EXTozHuEm4US7GyNppE7Om9yla6js6gXz3KOCbf
	CuaTm1WbpJ7Oma02TWgOcUGOlW4FpQw==
X-Gm-Gg: AYBFou30RZVEoNaeoe3S8A77njQ87x2ULzKSyyt4e89g0LlmddqHlVHCPB2zbfS3FAu
	c2fpz9yHWwG6gySNH0JZ7K6hauklmS3Fqi7+pFVSSI9LXHiZDDlsGX3nELYj/CsGNRiPPzK8x/d
	gTFFq0BDb4rnXg1Yvc7QUl003GszVoJKwZBYq1DB3dXnkCZhgEqhCddRPRri8GbRyyvQz7X+b6U
	a3LQcwnpWZnEsx7alibLjGy67uFCkMn8nfO83xbVn9L9RyDuqKmKIqPXqHLSHhJqJiVBclVbNfP
	+2HOyhVKKhw7uXsCqnZ3B8g3L83nZ7u0U1XdwB5Y+V/jCPalVE/Ih8PFX+ka76/gZ6Jk
X-Received: by 2002:a05:6402:4490:b0:6ac:9a44:d412 with SMTP id
 4fb4d7f45d1cf-6b17c25d32amr3176429a12.7.1791591812741; Fri, 09 Oct 2026
 17:23:32 -0700 (PDT)
MIME-Version: 1.0
References: <20261003202727.3673-1-ravis.opensrc@gmail.com> <20261005100435.1211485-1-kunwu.chan@gmail.com>
In-Reply-To: <20261005100435.1211485-1-kunwu.chan@gmail.com>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Fri, 9 Oct 2026 17:23:17 -0700
X-Gm-Features: AclHuK9H7NRLbSCaBe_aB3pxVn0sHlmdw2q3s22R7c9utOO5Z_szeWimYSsPy00
Message-ID: <CALa+Y17i9wN=0oLbbrsPafJY_KNEoKwZPLdLCrMq5Nf2k3aVKw@mail.gmail.com>
Subject: Re: [PATCH] mm/damon: add damos_node_eligible_mem_bp tracepoint
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, SJ Park <sj@kernel.org>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Bijan Tabatabai <bijan311@gmail.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	Honggyu Kim <honggyu.kim@sk.com>, Yunjeong Mun <yunjeong.mun@sk.com>, 
	Akinobu Mita <akinobu.mita@gmail.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3jrptgosgcmmg9zqn11mpxh5wyy91wkx
X-Rspamd-Queue-Id: 703831C0008
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791591814-657457
X-HE-Meta: U2FsdGVkX19t4jtL+zst5IkjUj43s0tUMXai7kk4/Eo7iARzKQDXsPL+EjEsXiRwZbb+11NYMKgut1c9D7yYLlwEZx0SFTXoWkPjY08zFMjl0HexHHpFLEesTsHKzDHssZ2hLg07SvdI1tRB7o9rw6t37xeFwmbEdPQB8QEFTSEDSFNgczWC+wxsBDvVh8e49IukQR20ycVfQCdUXqlKXgN26iNGSjf6uISaDuZ9/W5fjLUc5haVM4ilxMZGzLJKtOKTr8QQkzbvAMwHFtaqjhifWmWPcMt8U3qFRFNhJ1Sn6NozS/LYA1svasUIg9k3EVVuJG52xToc7/SlJNL5iNlVPwuPzeEGDwk1154/EYKkgbw4+WsEKYwCbBnxFaSCIstOT3qCk23XL9mfh1YmJ5Y9qr2X2hUbz6YMwYcntIvZJArBzu2VrOQkrLV3aNO+kF+JZT7tYSkNUr2P2tr2GJws4AcBj/Z4RmjZa5AL9m6DpATsfeJv6o1h2Xr92qNBRX4a6rilufsfCDi5251/xBCJe/LJg2oogM96c/2f49ZcyNLRkWuhn45Ue0fOgXyVrLSB64n2r9Nq2OALcuw+4kKSXkM6d6HzCQGvXBCkz5+tfYx/T3ONBqsoTC41TMUjcIUTwn1Byt3HkbFCxbi2wl78JRzWZItXCCRAIk5xeriCn1ybVeUtCF3HvM0jYrtkgLzhQ8iWQbz73MiCJ8Ca5I7QE6Bbw+wi0zxKFpddF2LKyHseeBNiBQ7vaaJ0pqit7s0YyHPYtY5JT0EX8oOOVMlbtVdocWs/Arz2DVHMsPhPKr+UP4117117gwe1mSA1U8oIU0y6dUuNXokUftYoy7MvuFo97tP+wrBDVtcODr0ftE2qs42KxhHlbWND31zxNsH82rSmzpArubCp0WBuH01c6LiiFiLV0Ea5+QCt7s4etZM5/ROdbBXLnbe7Ojw63IJ4RfCp8iqz6XVzgEZ
 VBQuJWGM
 QNJehDsjPieMjBQB84M+t3DESdHTxHIBGg71tLmBZn1I5983fag9UH/D8f3QaKqo9SoRQ7nhjEhMv1kqRmZ03AdUWCS5NyMCkzhxJEVH1qu7Jl5X3DcvAq5sRu55DphZWAAE2liMH0BNCltIW8RtPbwB+MDm1fY1SJA56Xng8w1phBBhiHO5x9iWFvjLRttV9IIOb8YouGlTgh5tv2VdUCdwmDHEXhml8rUNnocU/crcTcuUPBzWw/8Eqvf79xCiMYZgTcYIkIh0kIW2YzI0w2/f0sG6q7qQvi3Usy/oUn0AOL9z1fZpk0iQ4KhZoBGgYpaKySwLc5gjGsh6Xo7RepDvhzfwSVmnCLeh1J6Duwro0DMoqkfS9OwmzjARh3aIsdHje32rhydGrDt5/0dQjujhO3vTVYRhsI7BHe5M5LdNtebScYcIJbewoieF4I5gO+1WiOKvL461V98g9iU7LXgjpOu5cRzVgGesSW0xm5UE7Fjz2WOzHY9EjeQnyzF7haZyiIlykODPtzxoP+v37BVL8BRBVrvOxJEunjryq6hcCDwt+k3bDbNuXow==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 5, 2026 at 3:04=E2=80=AFAM Kunwu Chan <kunwu.chan@gmail.com> wr=
ote:
>
>
> Hi Ravi,
>
> I agree with SJ that this would be more useful as a general quota-goal
> tracepoint rather than being specific to NODE_ELIGIBLE_MEM_BP. The
> target_value and current_value fields are not metric-specific.

Hi Kunwu,

Thank you for the review.  Agreed; I will make it a general quota goal
tracepoint, as I wrote in my reply to SJ.

>
> On Sat,  3 Oct 2026 13:27:27 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> > Add a tracepoint for DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP quota goal
> > evaluation.  The tracepoint fires once per quota-score computation when
> > the goal metric is DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP, exposing
> > context_idx, scheme_idx, nid, target_value, and current_value.
> > current_value is reported as the quota tuning sees it, after the goal's
> > complement setting is applied.
> >
> > The DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP metric expresses node memory
> > occupancy as basis points of eligible bytes.  This information is not
> > exposed through any existing external interface (perf stat, /proc, or
> > sysfs), so the tracepoint is the only way for userspace to observe the
> > target and current eligible-memory basis point values at quota-scoring
> > time.
> >
> > Link: https://lore.kernel.org/linux-mm/20260428030520.701-1-ravis.opens=
rc@gmail.com/
> > Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
> > ---
> >  include/trace/events/damon.h | 31 +++++++++++++++++++++++++++++++
> >  mm/damon/core.c              | 16 ++++++++++++++++
> >  2 files changed, 47 insertions(+)
> >
> > diff --git a/include/trace/events/damon.h b/include/trace/events/damon.=
h
> > index 8851727ae162..2c7249cc7c88 100644
> > --- a/include/trace/events/damon.h
> > +++ b/include/trace/events/damon.h
> > @@ -74,6 +74,37 @@ TRACE_EVENT(damos_esz,
> >                       __entry->esz)
> >  );
> >
> > +/* Per-tick DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP goal evaluation. */
>
> The comment says "Per-tick", but the event is emitted for each matching
> goal in damos_quota_score(). "Per quota-goal evaluation" would be more
> precise.

Right, I will fix the comment.

>
> > +TRACE_EVENT(damos_node_eligible_mem_bp,
> > +
> > +     TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
> > +             int nid,
> > +             unsigned long target_value, unsigned long current_value),
> > +
> > +     TP_ARGS(context_idx, scheme_idx, nid, target_value, current_value=
),
> > +
> > +     TP_STRUCT__entry(
> > +             __field(unsigned int, context_idx)
> > +             __field(unsigned int, scheme_idx)
> > +             __field(int, nid)
> > +             __field(unsigned long, target_value)
> > +             __field(unsigned long, current_value)
>
> Also, context_idx is currently always 0 here, since
> damos_quota_score() only has struct damon_ctx * and no context index.
> If this tracepoint is generalized, it may be worth considering how the
> context/scheme are identified rather than introducing another tracepoint
> field that is currently always 0.

I kept context_idx for consistency with damos_esz and
damos_before_apply, which carry the same field and also pass 0 today,
since a kdamond runs one context.  I will follow whatever SJ prefers
for identifying the context in the generalized event.

Thanks,
Ravi.

>
> Thanks,
> Kunwu
>
> > +     ),
> > +
> > +     TP_fast_assign(
> > +             __entry->context_idx =3D context_idx;
> > +             __entry->scheme_idx =3D scheme_idx;
> > +             __entry->nid =3D nid;
> > +             __entry->target_value =3D target_value;
> > +             __entry->current_value =3D current_value;
> > +     ),
> > +
> > +     TP_printk("ctx_idx=3D%u scheme_idx=3D%u nid=3D%d target_value=3D%=
lu current_value=3D%lu",
> > +                     __entry->context_idx, __entry->scheme_idx,
> > +                     __entry->nid,
> > +                     __entry->target_value, __entry->current_value)
> > +);
> > +
> >  TRACE_EVENT_CONDITION(damos_before_apply,
> >
> >       TP_PROTO(unsigned int context_idx, unsigned int scheme_idx,
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index b63e60ef8990..6ddd15dc4f55 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -3294,6 +3294,22 @@ static unsigned long damos_quota_score(struct da=
mon_ctx *c, struct damos *s)
> >               highest_score =3D max(highest_score,
> >                               mult_frac(goal->current_value, 10000,
> >                                       goal->target_value));
> > +
> > +             if (goal->metric =3D=3D DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP =
&&
> > +                 trace_damos_node_eligible_mem_bp_enabled()) {
> > +                     unsigned int cidx =3D 0, sidx =3D 0;
> > +                     struct damos *siter;
> > +
> > +                     damon_for_each_scheme(siter, c) {
> > +                             if (siter =3D=3D s)
> > +                                     break;
> > +                             sidx++;
> > +                     }
> > +                     trace_damos_node_eligible_mem_bp(cidx, sidx,
> > +                                     goal->nid,
> > +                                     goal->target_value,
> > +                                     goal->current_value);
> > +             }
> >       }
> >
> >       return highest_score;
> >
> > base-commit: 763ad0211c7b587344f03bc4d1299810aeb736f4
> > --
> > 2.54.0 (Apple Git-157)
> >
> >
>
> Sent using hkml (https://github.com/sjp38/hackermail)

