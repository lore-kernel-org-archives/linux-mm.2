Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C419CF58F5
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 21:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9882A6B0023; Wed, 19 Nov 2025 16:34:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 938E56B0028; Wed, 19 Nov 2025 16:34:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875AC6B0096; Wed, 19 Nov 2025 16:34:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 74B276B0023
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:34:14 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B36B4E6BB
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:34:14 +0000 (UTC)
X-FDA: 84128660028.12.7412715
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2970D140003
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:34:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="GzJfp/Wu";
	spf=pass (imf23.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763588052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EZANuNEnfoPqlj8foFWgfUflASDM8QeoCHlW0HXoEPI=;
	b=nPviEY5o5oBfHE1AeAditCjiaSMfjZTPrOL2Pq7+NL/OB8z2EogY9DrUM+UJMg4XDA3Png
	kVCATyFq94yNzZzNPdXtJfw+ONLrP7AKW/plu1lNhj+oXAqy5deX01q9mPFVyc0lKhrzmf
	+1zCY1rOY9vNq58Dfz6zueFP+LellIA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="GzJfp/Wu";
	spf=pass (imf23.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763588052; a=rsa-sha256;
	cv=none;
	b=VpIFQo0pkQT74GDJ9Pa4C8s/kyZ5/RLwc5gPIMxGi93oj9L3ypfBPUYKMd+MucDTFXkHmi
	ti5XbVJWVfxUcFChoUHHm9fNNTiqxqFwsD/HLpKyPsMU+fRsZ5TlbIa9eIjpV8e3ZIePW2
	yDrb6ATajC5+WCqHjkggkcMhoUkXfzA=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-640aaa89697so225661a12.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 13:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763588050; x=1764192850; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EZANuNEnfoPqlj8foFWgfUflASDM8QeoCHlW0HXoEPI=;
        b=GzJfp/WuC3Zr4TnuqjPctCTf6arHcL+gCfW0oqCB7hEdS60rkEmFN3eaulok2q+QvG
         ANxfjIb7BxY7jI324jd3zSYcJx0/NCmifzGKI6H+RGkOb62VHaQ/xnbiaswlfxYKTLWM
         WBCqhHXgQk2CCBPyNweyXT14nGQgxDIV0H3ZbZSeKWXLxdBqCh+JTIXZvJy3fR20cs+Y
         fRbN/lNrpfOmBC0rYqNHjebkrL2sSDzarcBO89ZkwjU7gPZDR7eteFulIXzCF42sqAiN
         ovXQEAf9QeKds8wDPY5rbfCaTle9c7QPhCRpzFY3lBxMZRnEdqwwFyoxd1cPO4QBXTAW
         E31w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763588050; x=1764192850;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EZANuNEnfoPqlj8foFWgfUflASDM8QeoCHlW0HXoEPI=;
        b=Vkn5HXO+CkC1Gp9KQI9m+238Pjv49v2BgMq9AC3BkbKTqTIwCp/I5xo/Sr3esZffU1
         XKBrUIGBUifbPKSCNrwOx1cAQIfOuLqEQ/VbV7Qa1ngN2oko4L4uW6Vfhkcwnzc8hUhl
         YK2uWs+SmyAwcAJ9Cp9wK9uBBfacldaqFSuHn0n3L4tfV7zpRWXYbaU/UWoO5cqpTBUR
         JiUi+99txRipP2vJMsnUtnjFFeHOaMdbW5LX0P1IrmUcSrODopnCZISAa0Yq5HIr5khg
         XKuCY0Wif/nxiM8rvGKbQBmhqxmRCgBv213LL9WRljAKo9zELHjCXfTkSqFuOO+glYaQ
         WZOg==
X-Forwarded-Encrypted: i=1; AJvYcCXU2PkH7IEshl1IqIppU8VvdAuOUVrZD2JkG+3ixfENI5NMQYOw23yUYCJqGz+dsThLLi0ddMXmGw==@kvack.org
X-Gm-Message-State: AOJu0YzA0b2BzSPF/5YdcpW9ZS9n7hEI7O6o3N0pIg93OTdAxnIt297i
	7ldSufDL9jxTgfpTt4yQeFpR/U0Cx4KOAYXalEflOTcr3waaFxss+n937kbUPfJ9PAetEW2wvOn
	CjS2jFRAzk0WcG+dovlvxbp4BY0wDpzA=
X-Gm-Gg: ASbGncv5xyD8zKi8TTPMiTXKGSD8LMlFodKJpZXv0y3orumfBbOyUHiVljfJCldqoRS
	W1X1CNnUFPezlGGEwD3US/bsuLYL/8ejZ3cuAPUaEOqBQR8I9+Y06Bz+4oZPu7TTZEK+4SOa3cZ
	h+rXMdhKvJnTcaMNOM+r2Gjrvdm3s9BBBF39TXYHiARhxasSnmFi0AFvBi84lYEuK6kX5JVmGEg
	qsHUBjCMt4AlgwqAPSr26sZN3YyI3g/CB39H+BxxfVh3MsxJlP5tVrFvXIQicTINRp9O8g2zDO1
	hkPMExW16WlT6Z7Oaq83cMrAW7oolu8zOLmz
X-Google-Smtp-Source: AGHT+IHZcuD6SiEqohUA1uT4OmSsE6LKcx35j3DjRy8QJoebGQcLNtd8jd60RIfCGWdq5lgjmK1svl0yqR+TYutiSmw=
X-Received: by 2002:a17:907:3c8c:b0:b73:3f7d:3ce with SMTP id
 a640c23a62f3a-b765545951dmr47404666b.46.1763588050481; Wed, 19 Nov 2025
 13:34:10 -0800 (PST)
MIME-Version: 1.0
References: <20251119210820.2959128-1-mjguzik@gmail.com>
In-Reply-To: <20251119210820.2959128-1-mjguzik@gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 19 Nov 2025 22:33:58 +0100
X-Gm-Features: AWmQ_bnz1YEjl5mv1g1GrMMj-ODfaxl3O7vj5Sce3fq8TOCK1AFIniU7jm_tG2A
Message-ID: <CAGudoHGs+3A0TQ9q2jNGuphT=nDbfy9jBrF0-FHtV62E+cz19w@mail.gmail.com>
Subject: Re: [PATCH] percpu_counter: reduce i-cache footprint of
 percpu_counter_add_batch() fast path
To: dennis@kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2970D140003
X-Stat-Signature: ngsk7ry3ne3b96cd6qu3uh67mi4u6sq9
X-Rspam-User: 
X-HE-Tag: 1763588051-365444
X-HE-Meta: U2FsdGVkX19/qb/jFZXZk3EIGlAAMjg6bFFzUnPEHpIpas9ep4WMv+k1B5DHppR1B3c/H9k+k8hWAAGFBo5JUBP3O2/KT2l2dR0G/9UBA0RLFIzxeqdb6mVKBa4EESM+g49f7zxu+Pt8417zt6TDctiO6SFsrm8M0GjhHp1O88D4B9VSBO1188Pd8maRal6+7K7bcs13nkSYtMPya7ZX/vwjRpt84xMEX9a92ASFiXxdAvsM2Ocszn2uBX0L6kVptPhJU0Sca6+v/KIhCIRXXdxx+1rezaZKgWanCBr7eFpkp/cEOpnDpgvUHLO8k4w3TumU/g/agoa6tj3jl86rlTg6GnIMuuEBtjswC5ApLqSXkFQoyWJCmnT4vJkLE1frQTq8EZHahRY7sKYeBrqU6wlCq3szbWn6CznrGr2LHvOtQUEOF+czLviQOCoNc8/mp7JyJzIYtlTG9XyeerCCGL26pP0W2OL34XpYN+T0/h6T3UeoohM0u8VK1atI/IM4bQBScxSuWusotvG+rNBoKxAL9vo153nrVFlAOsYbIpgUzH9kv8BDjz/3MSK5k4NRK2M0dxJJCSHhFvMsx5u0ZqS1cRcvB4s4xDn6+32ZJGhxw+LoQPCHa42BlYg1n9KwEwW6c7mhxMU8qx6RKWeN4MsNIN+SPbtQlaG9sLI2FLcOIP0wgME8y6gLPxxI1gXRCfHCW+DQMgjgsrLWUKMsBqoCITMHuVkofFTXk3vBa1KuyovNBQ04LJyjX3+ggwb3t2S04y0120+YLcv5JziriFX1zglKzBu82dW+Pak6T31N6YYmtg96oMMi7CxZtu1QbSYTVb+I0cB8kR6BsVzBwlDikB+H2Jj/4RjgX5Vk8EOcrJxoUSr+wXOmKaRSkuEENhiwMJqjXm69R+vNn930P3+4lVstTH6Thcxd6zw16L0SNL1p3h9SqRaA0zUF6TI12QujouulkdINTRfAP3b
 PiuFPpdx
 mTJLcTiBnAvwzsiAk1Zue0kIRmXAjZ7v5nh7iAUkbvKI5QnPJbBH/c2hv3mB1SCI9rArglnuJt5OSApD3wpeqd+Iac5WZowAFBgz1wwUr7qDSp7nmd/sfnje6xDfljVZKd9BAdmFlkiNDzifrIfYJdxvc5TN56snguLHnjQng29Y9OnyGbgSRdTzq5fctTsk6o+rvbETfOZVJaNtqBepJ3X/K0awbjVOXXP26QVyt1dw3drUISvwvVVl/541gjNEwA25K4xIplzCIYB2rSxKqt6gi+Vno0Xh0ooZThdM0u3mUxTBwF2V/uqq5s0LMi62BzfLd0NmAAmNFDJV9KFYLgYZtpj09EOkr4EqFBtZn0lCcEJRA728YBFMi+vCITQFaeMT/izc0qxEWPnSOkS59nqPg4u/H/nq0n3xockyd1KCTJVk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

So I just verified gcc 15 has this problem fixed. So one can argue the
issue will go away on its own given enough time, hence the patch can
be dropped if there are any concerns.

On Wed, Nov 19, 2025 at 10:08=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com> =
wrote:
>
> When compiled with gcc 14.2 for the x86-64 architecture with ORC frame
> unwinder the fast path still has the most unfortunate size of 66 bytes,
> in part from register spilling to falicitate the fallback.
>
> Moving it out solves the problem by keeping it just below 64 bytes.
>
> Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> ---
>  lib/percpu_counter.c | 30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
>
> diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
> index 2891f94a11c6..0cf6f1101903 100644
> --- a/lib/percpu_counter.c
> +++ b/lib/percpu_counter.c
> @@ -89,24 +89,34 @@ EXPORT_SYMBOL(percpu_counter_set);
>   * Safety against interrupts is achieved in 2 ways:
>   * 1. the fast path uses local cmpxchg (note: no lock prefix)
>   * 2. the slow path operates with interrupts disabled
> + *
> + * Slowpath is implemented as a separate routine to reduce register spil=
lage by gcc.
>   */
> -void percpu_counter_add_batch(struct percpu_counter *fbc, s64 amount, s3=
2 batch)
> +static void noinline percpu_counter_add_batch_slowpath(struct percpu_cou=
nter *fbc,
> +                                                      s64 amount, s32 ba=
tch)
>  {
>         s64 count;
>         unsigned long flags;
>
> +       raw_spin_lock_irqsave(&fbc->lock, flags);
> +       /*
> +        * Note: by now we might have migrated to another CPU or the valu=
e
> +        * might have changed.
> +        */
> +       count =3D __this_cpu_read(*fbc->counters);
> +       fbc->count +=3D count + amount;
> +       __this_cpu_sub(*fbc->counters, count);
> +       raw_spin_unlock_irqrestore(&fbc->lock, flags);
> +}
> +
> +void percpu_counter_add_batch(struct percpu_counter *fbc, s64 amount, s3=
2 batch)
> +{
> +       s64 count;
> +
>         count =3D this_cpu_read(*fbc->counters);
>         do {
>                 if (unlikely(abs(count + amount) >=3D batch)) {
> -                       raw_spin_lock_irqsave(&fbc->lock, flags);
> -                       /*
> -                        * Note: by now we might have migrated to another=
 CPU
> -                        * or the value might have changed.
> -                        */
> -                       count =3D __this_cpu_read(*fbc->counters);
> -                       fbc->count +=3D count + amount;
> -                       __this_cpu_sub(*fbc->counters, count);
> -                       raw_spin_unlock_irqrestore(&fbc->lock, flags);
> +                       percpu_counter_add_batch_slowpath(fbc, amount, ba=
tch);
>                         return;
>                 }
>         } while (!this_cpu_try_cmpxchg(*fbc->counters, &count, count + am=
ount));
> --
> 2.48.1
>

