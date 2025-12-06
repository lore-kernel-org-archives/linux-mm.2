Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20F0DD3ABC1
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 00:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5651A6B0330; Fri,  5 Dec 2025 19:39:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53B676B0331; Fri,  5 Dec 2025 19:39:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479136B0332; Fri,  5 Dec 2025 19:39:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3401A6B0330
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 19:39:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C27E652373
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 00:39:48 +0000 (UTC)
X-FDA: 84187188456.30.02C7AE1
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf14.hostedemail.com (Postfix) with ESMTP id E412E10000B
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 00:39:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dOxnEWX8;
	spf=pass (imf14.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764981586; a=rsa-sha256;
	cv=none;
	b=0YpU9gVNJOsQgXRlhiCdqjdppJpR7TVvHEiNEstrhi9cOD0CtCT/3eQlPLD/PwDlZ5xkCN
	ffYoUFxYZq8JzswO8GoIumAjeD1eA2o/8VBDUe17rONEzliCrH2cGfP6wFk0iIqlL8kuop
	qh5eoYIJxYJfCkIUeiD5ck4N3hH+Cu0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764981586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iS/PxCWZGwuJJcdGTqcqS3555N7P9Ocak8WOUuC5XsA=;
	b=ws1liRfYOEpVpmSUGQ9MLcO3wVWnzwUUpVEpQL0qzWCEAuxsB3ezNF08hfPpFSSD9GDlo3
	nd9hcGmshgjrhQccz7mjThyKlSwk7Sn9VUkGPLJjtuxXwz5/TTs3D8Q8MXr41qYlIkxAsQ
	YNmicSw1ufGmK4Q6zAFQEHzoWqFB8yo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dOxnEWX8;
	spf=pass (imf14.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.128.169 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-78665368a5cso25939867b3.3
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 16:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764981586; x=1765586386; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iS/PxCWZGwuJJcdGTqcqS3555N7P9Ocak8WOUuC5XsA=;
        b=dOxnEWX8uzgEepW2F2b+dJoqv+WPbMxpgN51SfKS7+lg6RjcMbJnKI70yZIdz95E/o
         n1GNqX5VUSb6d/rbi8by862+BTwnfBbJhjMJceJTFeB5GhjwfQorvdVO4m4yjpvjW6SS
         EFPePLCZexgr9lu9gZyjXQWr+jTxRL1H6H09kS1+C0Y2dw4ows5wu7evya/2v4n8M95Q
         S66zjdo1PhHKYDoxSd1HbMeTfEK0kKDUC/sC09IrLSZ2jDR1dSpVAWpxwwqsWtJnT8OT
         lemxxzjvbKlRPrnKJx2rDQW4KEcKUZLCTO5j5t1tqqHb97z1DYwoisPs2iraltfMjfyY
         NLQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764981586; x=1765586386;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iS/PxCWZGwuJJcdGTqcqS3555N7P9Ocak8WOUuC5XsA=;
        b=bWPMTFRwjzqAN0QmeNCtJjPg1PwHAR0zo1Tf8kz/2YgmRZ0snlCDMfwNxW7nDAWSs1
         G7q+5e0iDB7hZ53AQWaPuhZRURkwmb5ltU0S6yx1Szfu3tlXejysI/bTQV/JBI5d8Dw+
         VyemxkghK0Wh4ys039k7iNePMzdWaLMglFk0ufjDY3FLwiTcP6do/BnuAPIrhMqBHCz3
         s3lSmJvKB8l0Bk6bcMykQVy1p5HtJQky0KfeUflO78zAXOlxN05hc0GMAIrjbLBE6ZTQ
         NkjWIP6/4mgixBHX08uo/gzTAwZEMfifWOe7fS4p5TVsOJQAS3Hf4m+OPJc+CH5PIQfU
         AtLA==
X-Forwarded-Encrypted: i=1; AJvYcCWWbAXAe+dRTE9kp869exNIiEU9USJRcx8SKFiMqDz7mCiEF0wA1y0btC+ghL86o3nApFqV8IU9rQ==@kvack.org
X-Gm-Message-State: AOJu0YxMMzyEfXRlpA2hXNIW0ADo11DVeXTUq9VcoF9k9+kgpUUaLU0U
	+k8Rj3Se3FXuf0fECLElzHtCbDvKklbHoXSD8Ao2SDCiHZX+0dDwzyS+gJ4V/w81ANgIMtcS+Se
	gdLdBLK/NOkijLgu7uulaaQWh4c+XvCM=
X-Gm-Gg: ASbGncsdPInyXsstB0v5b3+P9Kxu0TF3AI8Z/GqjcIJDK4DrELnEgdtgA1a7AkDHm8f
	jAEvMXpHIIEQIQOxlORwJs+sEpsX593tqv6Q+szblhwkEtfmdzC+5ZTeFnVTPw2fHg94l3wrefC
	9ajHZwVOxd5tL5VRE85JyIcDmBcN66FpWgzaTyHveDF1WTKKQGQCN7w3+BwFiASOPZRytZfM9kz
	LN8F8zE+UotfXg7hyVGHTVP79SBw+h6S/xWEKiJ0XkRQRvdy8PeDjmUCx8Zr9J5N1+1x5Wr
X-Google-Smtp-Source: AGHT+IFNW2ikPffWpMB1hHHqvH6d1j54Kr483iTS45ilSSv6UXPYq8AygE7VN1mbYMiSFkmdAW2f1RCFz5pUEWe2auM=
X-Received: by 2002:a05:690c:ed3:b0:788:7f:98b with SMTP id
 00721157ae682-78c33b09d37mr10716447b3.14.1764981585915; Fri, 05 Dec 2025
 16:39:45 -0800 (PST)
MIME-Version: 1.0
References: <20251203080440.16096-1-rgbi3307@gmail.com> <6932b0cb.170a0220.2d16ee.eb89SMTPIN_ADDED_BROKEN@mx.google.com>
In-Reply-To: <6932b0cb.170a0220.2d16ee.eb89SMTPIN_ADDED_BROKEN@mx.google.com>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Sat, 6 Dec 2025 09:39:34 +0900
X-Gm-Features: AQt7F2qlyVil-aB12oBUhKCB7DUC91KtzDgwvf1_MltJSfNq8gM-a4Nox-P1RR4
Message-ID: <CAHOvCC4SVz1TH4OaququJUcYfo6hvBE-BcVgZcVBGt=u4HxJog@mail.gmail.com>
Subject: Re: [PATCH v2] mm/damon/stat: deduplicate intervals_goal setup in damon_stat_build_ctx()
To: Enze Li <lienze@kylinos.cn>
Cc: sj@kernel.org, damon@lists.linux.dev, linux-mm@kvack.org, 
	rgbi3307@naver.com, enze.li@gmx.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: E412E10000B
X-Stat-Signature: jhu38bockh3drqy15a69tesa6dwzme19
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1764981586-538577
X-HE-Meta: U2FsdGVkX1/V8Ic8ByN/nj+SNwXMPQW7sWonurBxnETLfsaPDKukQkrKGcz4o5xSJ3YsUCTnHC04VpuNf9pVxZ1SsB6fKXfipgHeYMdRDju2uhYCLsRGSBvxV9/KJVxtDiiy1psGp8s3xmSLxx261jCp9ygsRQ+0KFqOE8i+1tyj+QDotD5JT0I684s8nEfd0QyO97dsxR8RP+uQ3OTvjqnaiyJYWfeG6VPr4/m5q8JK98pTv97cKrSMDZSN49AJLblT9IReNYCXmQd0ru8hdc9hRCHYmVRpcZ5q9AaLlojFjFpnOx/xlz3z/gsWEPr9nuByIJKhnHS5oowSdvT4H+oW+D2m6m9FfFnCvh7eAOJeq0rIGpMcZFAo90MZA9SypSZik2uS2grPy3ZRb18UrtOXC74/bs+Smr/+7RgG/63k7K04BnXuW9S12MWFqUTuCHpTLT+IsHtaMASfAkUMmUf7Hi4y6Wcy/0cporGtg+Ja418Hhm2bvstGY6fEb5juh4NJ1pYO/rBrSQratA7SFBxPEBecWj+dFxopf21K6ryCl5uICyFE1hjqKm5DA4Sz+Zxb2UNWbEZjlLMPq3jQXPYJDc6VskFvd9eHUbtpTJVbTxwry/gcraCGez9rG4my0AuqfiR2eGBQHf542UJaNhdZFa2VZYR3XfgzX4qIkUeuSyVxsKqk20DWTDVwjxrR7o8n5y/DQUxNR3tomGlKEK7PsHXyQHJnbjcb3CNERS9P4Igb1qYooeyx3TJSwpu4BMMJHbrAYCIExPTF4Fx71T9FA0n2rx/JfMuk8KOfZtr/gXYryk8wMvlop8AUeMTwRRjhfULTb0m7+Z1bsSPqYM9czCG6ooqu/411QVhhM+YhHWZLTcKeIbRvZoeeOyN+5c7/S4LJ8AIWTQR0aQtGUmUWoCCH93JVOeyuvjOFov/ta/YRyYuCjkNJm35b8GhcfsDIGwSqiI+qaA2EMXi
 Y7i+Twpu
 2AKhHIvrYFW08ylhpyKzjiwtJhPed0IaHa4rSN/9m8KtlN/JVzgcYUuVIVXi1zmg2hsvYOfENvWdGm8lBygdL4nVTiR72YxEo3ThBuOTk/mF/jWJPrVDX28ubGPk2A3QGpcfbWH4UgJfnG0bgX2WjT2fTRuGivW5QtXFxgW5rQI6qZVxbePwbLu683cTPAPHte2SNrPsdAnEAQL8ydRwN0uJijGJQSO4gss7edJxLCcsyWNXxxGlyZWxpSelcF1+cIkCTPmjHUa+44BBZrH2oFXgQFNJFOiRQtsTIlazHFwYME6e55q0Nkqn/ASEl1cSnX5OnIWapPu8NyoZ6zyOsZ24ObgeUVG/u2ZpU0xnX++KPY25kUilwdwpmkpP2uZt/Abs8ZZM6En+6HGN2CzI33HSeSwlszYYDphInZnpVC038uclMNohc+pr4gycIMp3a4uwkt0phReWAdFNkMov+8gGbpKB0TfK1a4zNLE4IQPpzqRfrZKKmqTeDUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Enze,

Thank you for your kind help.  I will reflect it in v3 and send it again.

Thanks,
JaeJoon

On Fri, 5 Dec 2025 at 19:15, Enze Li <lienze@kylinos.cn> wrote:
>
> Hello JaeJoon,
>
> Thanks for your patch!  I've a trivial comment inline, see below.
>
> On Wed, Dec 03 2025 at 05:04:33 PM +0900, Jung-JaeJoon wrote:
>
> > The damon_stat_build_ctx() function sets the values
> > of attrs.intervals_goal structure members.
> > These values are applied to damon_ctx in damon_set_attrs().
> > However, It is resetting the values that were already applied previously
> > to the same values.
> > I suggest removing this code as it constitutes duplicate execution.
>
> Would you mind reformatting the patch description?  The kernel community
> documentation recommends wrapping lines at 75 columns [1].  While the
> current length is within the limit, adjusting it for more balanced line
> lengths would improve readability.  Also, I suggest using two spaces
> after a period instead of a line break.
>
> [1] https://www.kernel.org/doc/html/latest/process/submitting-patches.html#subject-line
>
> Thanks,
> Enze
>
> >
> > Signed-off-by: Jung-JaeJoon <rgbi3307@gmail.com>
> > Reviewed-by: SeongJae Park <sj@kernel.org>
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

