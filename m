Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D480D49220
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 13:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A20E26B0005; Fri, 12 Dec 2025 08:20:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1B96B0006; Fri, 12 Dec 2025 08:20:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7616B0007; Fri, 12 Dec 2025 08:20:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F59B6B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 08:20:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1EDB31A0179
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 13:20:18 +0000 (UTC)
X-FDA: 84210877716.21.86E997A
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 43DFAC0002
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 13:20:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h3fxL8Hf;
	spf=pass (imf22.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765545616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzHnejj8FlvJoZPTI0Iwe9LyfECd4OIzjxmqM5a/Z6Y=;
	b=lt3T9K9Str04kSpMUzEFAn++QIgPa6GJLP5YYqylNypYtdAYoOFfJFMBdyJ/75IxyIABgn
	C/Lede5ZKaQazkJ5/34WO56K6ivPTmFKd2zBxJubHeKbBMvGltjKNe6PNos3z57q+hwziy
	ubBoofBPvfY6ETQvUjdHyD40LmMAp/I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h3fxL8Hf;
	spf=pass (imf22.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765545616; a=rsa-sha256;
	cv=none;
	b=H9+NAuh+NRvQZV7ziT2GD1gSNHmU9G1oCRricX+dWG8vsEO64fXzyFns8385ni43Sbq/78
	ZeSXpr7T4l/Bz9h7LBHY5Ny364zOfNmvxjuvRHeqMK7fKoFUGWbWGtQBLtmdYQV+UjOKWj
	GXY0XP+RGYeJcasXiJVwXIAdOedxAYQ=
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-640c9c85255so994492d50.3
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765545615; x=1766150415; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gzHnejj8FlvJoZPTI0Iwe9LyfECd4OIzjxmqM5a/Z6Y=;
        b=h3fxL8HfGgVEz8hcr1aFvqnBpdSoiRtug5QPM/IQ7Xr+xAtmSREUHbraKyiSSgjYwy
         08pLZmDZHY2QVMXRmrYQ/aOEs4V7bBy25Fd3JL6Pyg1pQpKMxjXn71JMcV7iTQq/LYoc
         1aAR/jX85p9ccuHWfpH1lSKvPe5E1cGhxxw4Sx6lhkTIXMRqD4pAjSGMF136aF22mACb
         /cYJwm214LddkwZXll19S1wf3riBAzA0V9Ddc0K85FLRMRuN4X2QpsuOMeNDgK5u/j2s
         bDKkupmmXm0MtOHHt9usQqA/6c3vkMthKws6nWmGVx0r7F21v3wrLKlKnREx8DnQZE6T
         jC7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765545615; x=1766150415;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gzHnejj8FlvJoZPTI0Iwe9LyfECd4OIzjxmqM5a/Z6Y=;
        b=mmDjY4t+0HrTT5fkFvV5fJJwalrGEH+N5TnEoWhCs9z6i5r9cxZM74yWIvxLl8QaOY
         6H6CugqkUTn6Gz6v2eCpQ1zsUGCtLuB80PSmyxa3PfUVBGjuXMiJcyKLq76Jhe9ftvY5
         aKp/bkwf9Xb1uU9k5RgaIDDoDFn+qudSBcvHnqRdgyvrHdkhoLpIGpiMwXK0sTt++ul+
         4cQ2X23+TxjDtva20GpKLC5f55JeLWFZdTlae7Y5xDrXGdcKansQop+bIx3y4LYCQ3D1
         7EdNTWIuS1zSbJGdZG6Kf4MJjBJ17rkjGeg4XsI1HTwImCuFWtZvCiZlylMrPG2EizuQ
         HOAw==
X-Forwarded-Encrypted: i=1; AJvYcCW6zl/yMOBNODfvNesikBthGf+Jw56jhKyjm53Mvf1QWj2hLyB79hR/BP5PhGfMyruGAc9FjcGhaw==@kvack.org
X-Gm-Message-State: AOJu0Yzrp2zKCoULoMLGKpq6ToNqKTJppcoxjmcswBqgL6eo9h0BKiXW
	45Nj7FDm9LaU/BmkrDI83JJyGlpy2AMwhHr94iOiPcFV/X0X44q7R+IH/b8k4gyF8EJG8EP89IN
	QbxlsmjGs9Dns9diVrkLa/tlOZMXKdb4=
X-Gm-Gg: AY/fxX7DkzeddwK+HSKAT7p3MBUn8faGSskVK2hlhAabavBE/dT2m9mYVTPEOY8z0Fx
	/w81J9Hz02E/STazJxEP2uzGcWeLQ8F4UjS7QRMZCNB9W6wlc0pNDOBlXGRoT3rexDRdyAAZmV+
	liZFI29xhUbwuYpLYnxNr93sKmgbnv1fiK+GPvcbwo9t4fR7U1dfF59MlSkKWvqfU1y3T5L5rtC
	ekqtICvkEGEaAXgbYBHJh/Mwi8Q7030GLU9XhkbdKFHvYsWCz8/xiv7x4a37syY1a6bAhhX0Rew
	Ex1hyec=
X-Google-Smtp-Source: AGHT+IHnkwapZuSfPrtWGxGZpc4G+TYqUmEglUfs7oJm1L366fuFdiHWGE/dajxKNzADDxbDcuoHYHvJHC5Sy26zlx4=
X-Received: by 2002:a05:690e:13c2:b0:640:d31d:6ed4 with SMTP id
 956f58d0204a3-6455564ef81mr1316411d50.51.1765545615251; Fri, 12 Dec 2025
 05:20:15 -0800 (PST)
MIME-Version: 1.0
References: <20251208062943.68824-1-sj@kernel.org> <20251208062943.68824-8-sj@kernel.org>
In-Reply-To: <20251208062943.68824-8-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Fri, 12 Dec 2025 22:20:04 +0900
X-Gm-Features: AQt7F2rwF43VTf84s_zacyLJLnB4XlNKOig3wI6N8NrIFP5vpH9CYdsAr_9HKVc
Message-ID: <CAHOvCC4WQPo5HrCJ+958t1ab2NDzbg493XYarqACARTpYskVzQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 07/37] mm/damon/core: apply access reports to high
 level snapshot
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: k968cfd5wnfy8c1bhuo51ob4epcqf47r
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 43DFAC0002
X-HE-Tag: 1765545616-821571
X-HE-Meta: U2FsdGVkX1/m0OrowzkfsuKAdmOCko9gqHQdxRfZbSTxwJ92zOB2WCeZFfwLO7SFjkgJlYPhwZi5xq3cF+6fDEy8F6oaWcz975nLcrHvqCVt6KpZX7V6ko0B72z8oR38HavmITlzfgt52cDeVjJ/NoNtLQzgqPRaUyDBukxniQdS3Oy2egzDU3yvErIxz1Xz1iebSNF83lpF6/RrY7bvo3JbWQkMPtmvpgZaqUC6KOrGWDFiC5rX3308dYLWgDoES+ycZObbanZPAWkdcggUG4oDWf5CS+LYRyoxenOxUzFsIQT5Xbg+bNel/olzzi2RlKEdb4AMcCLfkprZ65DRw5RV2K1I3rgASgO7g5OKfSrTGihrGIsvngbdsd7lbP7EXXV9Fv+S2++gNLqA3ciE/Ai9xRSLL9sVfRl25JUpkuW+ZGU+blpONqn85NIo6VpdeSzY6VD5XYPUU08mhYyJk+hSW2/JKtm6QtIgp5Df9opaJAeJCBD3XDUnkCWeckFbHAjUVYutmMpaMpXplpP6ccZw09Yxs8C4vD3sWRNqrzwfmuA/RJmzS4qNBBPMRq3a3rHIGwI7izRpDv8fKzLNKK6MEGADE5UImQfkvqvz4Br2BNzLT7TqwgbE4eCt8yPwWACIw8yEPU+XIJLJ6atyiz/gpcGnBe6ci6dg2QYS7E5FhsKqtJnenG5eU7hb7GbZ6L8RAff15CuqzehxDToI81Yys3s6ztXw86uN6BRtkD869gEE/I3RocakuxrJcJ015sEEneEsnb4V7YNZ2/Cykt9W6hU9e1dbIGmqMuGtYTgdeSY3PdxvBLm/3qXcVCM4FrIPSZFVHTGjxjFyzIs4+ook9N5kHk5G6srHBT8Nr++1hgt8Nv3s4V3LEOcN2vj5pAKmQ0BufKfEVqGZh20B2GoQTZkovJYej7BZQ6QelLCc9ATdp4Da38SA//5aAM3DuOdMUAXk5khClBUWUT9
 MXAJ+dQg
 4+3cVmOtWuxzplOCd2llxdinJSoxyF4teTJyuEcstoq78qoQUBUrUZHuz6NSaoU2ywR3nY0Q/6VfTn/47BYmIaQReGozSj2ih7GlRIbPZ/uOwyzZIyFfvtpkRz1aHcwLecZugo5W/wPOBkk/EhwXBJuVheTELuB/rVaRqnSghyjjY3MAOgE5WtO33Mk1vVWxqm9fXHIXPwNhgGEgBgUF61uOINk1UcPKdZKkJK+sD5E8u4kHtz6jVcrzJ/Rx4CgDKo+qoXKEBoYlwovT7V9vEesj1lokaQeNq+uBQ11B1o4iw9kLd+/ijVkLOnrLqr2dVRusg5YbOPCNGuX5j1lFdQs02dxHoYmh6/Wn7iTHVL+jE8qw7Pc7F4Q4lGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Dec 2025 at 15:35, SeongJae Park <sj@kernel.org> wrote:
>
> Now any DAMON API callers can report their observed access information.
> The DAMON core layer is just ignoring those, though.  Update the core to
> use the reported information at building the high level access pattern
> snapshot.

It seems inefficient to repeatedly access the damon_access_reports[1000] array
using a for loop in the kdamond_check_reported_accesses() function.
It is inefficient to for loop through the entire
damon_access_reports[1000] array.
When CONFIG_HZ and jiffies are increased as follows and
damond sample_interval is 5000us (5ms), the time flow diagram is as follows.

CONFIG_HZ 1000, jiffies == 1ms
damond sample_interval == 5000us (5ms)

reports_len(==): [0 ... 5]
                                                     [*]
        0       1       2       3        4       5     6    7    8
9     997  998  999
        [====|====|====|====|====]-----|----|----|----|  ....  |------|-------|
jiffies++    1        2       3       4        5     0    0    0   0
    0      0       0
damond_fn(sample interval)      -5[0<]

reports_len(==): [997 ... 2]
                                  [*]
        0           1            2    3    4    5    6    7    8   9
    997    998   999
        [======|======]----|----|----|-----|----|----|----|  ....  [=====|=====]
jiffies++   1001       1002   3   4   5    6     7    8    9       997
  998    999
damond_fn(sample interval)
                            -5[997<]

It seems that only the section corresponding to the sample interval ([==|==])
can be cycled as follows.  And, how about enjoying damon_access_reports[1000]
as damon_access_reports[500]?  Even if it reduce the 1000ms to 500ms
array space, it seems that it can sufficiently report and process within
the sample interval of 5ms.

 static unsigned int kdamond_check_reported_accesses(struct damon_ctx *ctx)
 {
-       int i;
+       int i = damon_access_reports_len;
+       unsigned int nr = 0;
        struct damon_access_report *report;
        struct damon_target *t;

@@ -2904,16 +2905,18 @@ static unsigned int
kdamond_check_reported_accesses(struct damon_ctx *ctx)
                return 0;

        mutex_lock(&damon_access_reports_lock);
-       for (i = 0; i < damon_access_reports_len; i++) {
-               report = &damon_access_reports[i];
-               if (time_before(report->report_jiffies,
-                                       jiffies -
-                                       usecs_to_jiffies(
-                                               ctx->attrs.sample_interval)))
-                       continue;
+       report = &damon_access_reports[i];
+       while (time_after(report->report_jiffies,
+               jiffies - usecs_to_jiffies(ctx->attrs.sample_interval))) {
                damon_for_each_target(t, ctx)
                        kdamond_apply_access_report(report, t, ctx);
+               if (++nr >= DAMON_ACCESS_REPORTS_CAP)
+                       break;
+
+               i = (i == 0) ? (DAMON_ACCESS_REPORTS_CAP - 1) : (i - 1);
+               report = &damon_access_reports[i];
        }
+
        mutex_unlock(&damon_access_reports_lock);
        /* For nr_accesses_bp, absence of access should also be reported. */
        return kdamond_apply_zero_access_report(ctx);
}

Thanks,
JaeJoon

>
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  include/linux/damon.h |  1 +
>  mm/damon/core.c       | 68 ++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 68 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index b8ebb2aa02c8..b04c2e36833a 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -83,6 +83,7 @@ struct damon_region {
>         unsigned int age;
>  /* private: Internal value for age calculation. */
>         unsigned int last_nr_accesses;
> +       bool access_reported;
>  };
>
>  /**
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 296117d5e7f7..a14754a47c7f 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -137,6 +137,7 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
>
>         region->age = 0;
>         region->last_nr_accesses = 0;
> +       region->access_reported = false;
>
>         return region;
>  }
> @@ -2745,6 +2746,68 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
>         }
>  }
>
> +static void kdamond_apply_access_report(struct damon_access_report *report,
> +               struct damon_target *t, struct damon_ctx *ctx)
> +{
> +       struct damon_region *r;
> +
> +       /* todo: make search faster, e.g., binary search? */
> +       damon_for_each_region(r, t) {
> +               if (report->addr < r->ar.start)
> +                       continue;
> +               if (r->ar.end < report->addr + report->size)
> +                       continue;
> +               if (!r->access_reported)
> +                       damon_update_region_access_rate(r, true, &ctx->attrs);
> +               r->access_reported = true;
> +       }
> +}
> +
> +static unsigned int kdamond_apply_zero_access_report(struct damon_ctx *ctx)
> +{
> +       struct damon_target *t;
> +       struct damon_region *r;
> +       unsigned int max_nr_accesses = 0;
> +
> +       damon_for_each_target(t, ctx) {
> +               damon_for_each_region(r, t) {
> +                       if (r->access_reported)
> +                               r->access_reported = false;
> +                       else
> +                               damon_update_region_access_rate(r, false,
> +                                               &ctx->attrs);
> +                       max_nr_accesses = max(max_nr_accesses, r->nr_accesses);
> +               }
> +       }
> +       return max_nr_accesses;
> +}
> +
> +static unsigned int kdamond_check_reported_accesses(struct damon_ctx *ctx)
> +{
> +       int i;
> +       struct damon_access_report *report;
> +       struct damon_target *t;
> +
> +       /* currently damon_access_report supports only physical address */
> +       if (damon_target_has_pid(ctx))
> +               return 0;
> +
> +       mutex_lock(&damon_access_reports_lock);
> +       for (i = 0; i < damon_access_reports_len; i++) {
> +               report = &damon_access_reports[i];
> +               if (time_before(report->report_jiffies,
> +                                       jiffies -
> +                                       usecs_to_jiffies(
> +                                               ctx->attrs.sample_interval)))
> +                       continue;
> +               damon_for_each_target(t, ctx)
> +                       kdamond_apply_access_report(report, t, ctx);
> +       }
> +       mutex_unlock(&damon_access_reports_lock);
> +       /* For nr_accesses_bp, absence of access should also be reported. */
> +       return kdamond_apply_zero_access_report(ctx);
> +}
> +
>  /*
>   * The monitoring daemon that runs as a kernel thread
>   */
> @@ -2790,7 +2853,10 @@ static int kdamond_fn(void *data)
>                 kdamond_usleep(sample_interval);
>                 ctx->passed_sample_intervals++;
>
> -               if (ctx->ops.check_accesses)
> +               /* todo: make these non-exclusive */
> +               if (ctx->sample_control.primitives_enabled.page_fault)
> +                       max_nr_accesses = kdamond_check_reported_accesses(ctx);
> +               else if (ctx->ops.check_accesses)
>                         max_nr_accesses = ctx->ops.check_accesses(ctx);
>
>                 if (ctx->passed_sample_intervals >= next_aggregation_sis)
> --
> 2.47.3
>

