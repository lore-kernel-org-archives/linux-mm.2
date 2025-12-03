Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69869D116F3
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 07:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38806B0023; Wed,  3 Dec 2025 02:54:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8F16B0024; Wed,  3 Dec 2025 02:54:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26296B0027; Wed,  3 Dec 2025 02:54:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 909586B0023
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 02:54:48 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3E64DBA098
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 07:54:48 +0000 (UTC)
X-FDA: 84177398256.19.37CE60E
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7456840002
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 07:54:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZPZXJg8C;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764748486; a=rsa-sha256;
	cv=none;
	b=ddicxpwZqjsZq1fOqNcQPAC8b5f7MyFvLOErNz0JZBBIvaWa/P/5hMJgzLdIIqgH4VDwTn
	HufXPDWwA6VIXl23p5rr3syQOpqt9m3Nu8mk0CICcELq7BwlPuVOcAceYvoiJQXTXQsC6k
	142IZnMnVT0m95/slxeOk6adjrHrQ44=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZPZXJg8C;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764748486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=opxEjkEEzWDYDI6mbsJgfie/jI2vqrmyMYr8FKJBA40=;
	b=QgF+ZEU59hgAUMCssPPdOvduzLvnYez5SRGzbjloAWZ2qYRuUqA/s+5RYxtNxdsV3rsGbB
	LS2DObT7XMry/f1pe8ceqecgDzTVN2A+lphMqno8JjCyrvGxx3bTsibh8CAySuzQ4PLjp4
	S50BwAwfcYFrraqDuGFpjjhHxvm5haM=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-78a712cfbc0so67801277b3.1
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 23:54:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764748485; x=1765353285; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=opxEjkEEzWDYDI6mbsJgfie/jI2vqrmyMYr8FKJBA40=;
        b=ZPZXJg8CTWca016q35Xd3zwRISGCPEtlMd4T9d9vcKr3HSSEquf8xXypdlX1LI2BSU
         JC0S+OTqGoV4RaP3qx/kT4QzPtEhpSH/gQt/gePGfaTAlpsB5dmVzaDkFnx3BSPMIdVd
         9AcIzXsRN3Yps45Y1ofgjLH8x5n/aaX3HWyIFIRaEoH6vkg/OjHRqeH7Pc1kxRDvMuSr
         GqDQpuZvYJBMqBj1KEQhY5d7Jt6NN/ABchKm2/Bbh+zC4aPN6UrLfpQdufJvSMt++miT
         WGkHHrUbTEiw2CIAwD4buYsawpu9ZZ1iZmpBDuGbszDuQLsmTQc/fUVqflF8LW3OnQH9
         NanA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764748485; x=1765353285;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=opxEjkEEzWDYDI6mbsJgfie/jI2vqrmyMYr8FKJBA40=;
        b=WIhWTMuFJBELXhqz7xO2mPWbn4C/7D87wm9LmYyGNVA7XUE9p83Gs0wW35Qj0B3jAd
         XFdHziRp7xUuXAtkdYFnpUSBi0xtfxmOfyTKxPqN7ZpygqVzZN1v85cCyq70CxcSGO4r
         9Ivh7vqKp2vz+0nwuLmBzllRms8Dbzb6oNcglK4rwr7i/jnRTRCm5hgRAovsNkrOJSV7
         doT+2jp3bbWqIvuO9JCGIsG6hubWiylQqWd1Iv2YgDkvSxarMy1pR8HQU66KJ9kl+756
         R0r9XCWLdJgitgnMom09XYnGQzRql7UfeNl/1I5lh+gYGHUyJnMlhkraKZD+IGUrppWh
         BIhQ==
X-Gm-Message-State: AOJu0Yyxr26Zfr9MH2W+uUtdouhhjwlHBX3T3Yn480erov9Uo7ES/t+8
	EK0KsXFk16v1Lj6yTpbOjENEk533IhVWjtRTA9yOWzaj2Z26/OkjWeo5IGrI06rDoSGIoOOsRwr
	gw3unW/x6c8zEXgEAysN56G5k5VydpsM=
X-Gm-Gg: ASbGncsJu1+XDdWMFyAroUBijJOcPyijNq9NBJfOr5b5g/+7ZGtjwqV7O+OBQMZ++rK
	HGQKBLv07qBqmd/AZIhBxREDEMD0wAs/OJ584OViKZ2MDe9z8j5y6DUP/SzYIBANpcI8RqmLktw
	1jsRDTBHEYMVDsIVugkFEe80N+QreFT0+3nUapd2C1ked1hYfV7XNMetQKfpxi0oUfxOnNzEN4R
	+IWvkiSMvMI5EnaRv5RlQN5bZ94Bh0QyvbvuitvvDV57oGo2h3Ja1M83gvNcpK5AU/XG/9B
X-Google-Smtp-Source: AGHT+IENKl0Dkx8rYrQUsvLPO5L3t8HEgzDrP/ixPiYlg+yAleWlsgnRJvxrxEcDhTyTitTH4p4QzqYQ+U5uxHnFMTo=
X-Received: by 2002:a05:690c:6e03:b0:788:17c5:4459 with SMTP id
 00721157ae682-78c0c1b3612mr11124357b3.58.1764748485496; Tue, 02 Dec 2025
 23:54:45 -0800 (PST)
MIME-Version: 1.0
References: <20251203033350.14629-1-rgbi3307@gmail.com> <20251203042738.47206-1-sj@kernel.org>
In-Reply-To: <20251203042738.47206-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Wed, 3 Dec 2025 16:54:34 +0900
X-Gm-Features: AWmQ_bkgfLdzi-xw68LxqlBAAb_jyseLFUz9QtWZnNb2t9w7BsoVbbS3bXQXxbk
Message-ID: <CAHOvCC71f5ZXRq_HK_NiCT-o6kVfOY3cm4wWzFy+N6Ds2RMPQw@mail.gmail.com>
Subject: Re: [PATCH] mm/damon: Remove duplicate attrs.intervals_goal at the damon_stat_build_ctx()
To: SeongJae Park <sj@kernel.org>
Cc: linux-mm@kvack.org, rgbi3307@naver.com, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7456840002
X-Stat-Signature: z4bf7fjy3ycszojjx1ejmmeti4t3jahy
X-Rspam-User: 
X-HE-Tag: 1764748486-359824
X-HE-Meta: U2FsdGVkX1/c/D6D7gW8ZrgbtPWVgafNr+kEw+iDJI+sRTQ530v69Jaewt0OmAOlmrNENNoeyajnRuubRqnAikxII7yrdimR09JeWGeKMqFuYPN6Wj3yKTQ8eb0QL7mcpoFLTNzaGbcOf3TFbkBvxg/qoDmerSEpEvJ61SGo4MVf1n46zC81zUurhvc+y491pZYrdLgKDp9N/6l3RMdF8fQ5AOQTKa0zJiXrC3nE1BzLH1Vz8F33dkDIKIdshssYAQoySTa4JY0Pk0r5ylrgRr4Zaphi60E3WqjKT9fHleBZullAIbrgTkGnbA7RCQX5scLMaBBArNLvUV7NsYqcm9CXIys355f6SizZtI98BXZi4IcHvyyrb3pFlFIr1ThlBczu/vS95gOsESFmRMGKVUR5Hg9dqL+CRSD+4NT+L8wXyBo6CLqmLHJX/QUpKUSYTL2zr8SwPmsfEEHXELoLDMNIyH9Rx0CTWr8a5RNFl0jucrB4CktL5Ib7khmwPh1Oc+q6stL4YIvePCmVM7tSzY1rlioQ9OUV533myABYqSIKQ5dwTgE7k3X3nB6IWynFiEBFKFDgTL4f2emeeMImKA2sqcVgl1zTwk/jYWmxoPhICfjPORvSJQ1oAgefBY0lR9EZkschWp49JWWPV7OUv9Ewy0ZNKWU8cgs6BzkVU3jEUOmCAcojm+gDVSAhQeej2Uk+aaYfJJ5Oiuf1HqVQSdw0vTJ1kIse5a7xUzj3WwUaNo30K/v4GzDxBpUqJmE+dz5tnzqvbe6QZ3bTdoS+lmKR3ohTMTvFgESJdTyrzEWeKiiubfHd9oeVgIwGLC1IicolTPEf3WPgEdJIoYRIQzRIlc2szfvLqW0gjBuUPTyEI7Iom7fds0T7bl8VInEK4CdG/IjcN2LGEe6xpG35xAd7qi+If5oW8jzTs6wHJY9roBiEJ/qKJjo1WyXJPFMA4KIc0uOHld4CyjLJ5yj
 WYWz4Mdq
 Gt1N2swnoxJNIRAdbZtJqSBsWD/XugLHtTn/WYN42o4wnsvtAijswTQcILNmdt2lNoUZgY6CrYOaymw9oVxrq5oBP4xZMhFSPznqBS4cZcXmXCKbxSQgCi9P3t7+B2OlqRDLd5wGk3olQdgOkiUaOJ2nxD8WOCGkuz6LMpe7z3vaA6Adu2qWYeRQaoWkiAnoa1MoeyVwp0BeWDhlj4fk/NZ2wHegmfDnSofAgl7AU4KlVALaokPATx+WmXV9Yxl6bDEh/3YEr1pMLRWGtIePfHW39hXO3PjLPuWqHg0xlsvmqVAKqlkkpzzjKo/QhcT+zti4Zc0y+mJy78iF6E9gmfAPk5/a/RzGUDsumirUVh2zayiWXd59CeH6WTlmtdgTC09UnzLS/QoJtC3m6xb+hS8M2KcXJah1exXc/MVRfsctkTw8qrtCxL8VLTxxEakd9HCBf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, SeongJae Park,
Thank you for your kind reply.
I will send you the v2 patch incorporating the advice you provided above.
Thanks.

On Wed, 3 Dec 2025 at 13:27, SeongJae Park <sj@kernel.org> wrote:
>
> + damon@lists.linux.dev
>
> Please Cc damon@lists.linux.dev for DAMON patches from next time.
>
> On Wed,  3 Dec 2025 12:33:48 +0900 Jung-JaeJoon <rgbi3307@gmail.com> wrote:
>
> > The damon_stat_build_ctx() function sets the values
> > of attrs.intervals_goal structure members.
> > These values are applied to damon_ctx in damon_set_attrs().
> > However, It is resetting the values that were already applied previously
> > to the same values.
> > I suggest removing this code as it constitutes duplicate execution.
>
> Thank you for finding and fixing this!
>
> > Please check the modified code below:
>
> The above sentence is not needed for normal patch descriptions.  Please drop
> it.
>
> Also, I think the subject could be better describe this change, e.g.,
>
> mm/damon/stat: deduplicate intervals_goal setup in damon_stat_build_ctx()
>
> Could you please make the above suggested changes to this patch and resend the
> modified version as v2?
>
> >
> > Signed-off-by: Jung-JaeJoon <rgbi3307@gmail.com>
>
> If you agree to my above trivial suggestions and make the requested changes,
> please feel free to add below on the v2 patch.
>
> Reviewed-by: SeongJae Park <sj@kernel.org>
>
> > ---
> >  mm/damon/stat.c | 8 --------
> >  1 file changed, 8 deletions(-)
> >
> > diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> > index bf8626859902..51dd29685915 100644
> > --- a/mm/damon/stat.c
> > +++ b/mm/damon/stat.c
> > @@ -173,14 +173,6 @@ static struct damon_ctx *damon_stat_build_ctx(void)
> >       if (damon_set_attrs(ctx, &attrs))
> >               goto free_out;
> >
> > -     /*
> > -      * auto-tune sampling and aggregation interval aiming 4% DAMON-observed
> > -      * accesses ratio, keeping sampling interval in [5ms, 10s] range.
> > -      */
> > -     ctx->attrs.intervals_goal = (struct damon_intervals_goal) {
> > -             .access_bp = 400, .aggrs = 3,
> > -             .min_sample_us = 5000, .max_sample_us = 10000000,
> > -     };
> >       if (damon_select_ops(ctx, DAMON_OPS_PADDR))
> >               goto free_out;
> >
> > --
> > 2.43.0
>
>
> Thanks,
> SJ
>
> [...]

