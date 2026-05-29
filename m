Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAF26CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 23:00:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FB426B0005; Fri, 29 May 2026 19:00:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ABED6B0088; Fri, 29 May 2026 19:00:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173EA6B008A; Fri, 29 May 2026 19:00:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 06A0C6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 19:00:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99859C1776
	for <linux-mm@kvack.org>; Fri, 29 May 2026 23:00:06 +0000 (UTC)
X-FDA: 84821977212.23.4419DA9
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id 834C840002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 23:00:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RSdjPcwo;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780095604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=esBJv1XmH81oqfMvMS6FKEsXTHYPPlye955uwcqZrYo=;
	b=H7l7dYLc3/eyH0mwh7r2V7E7s7RR3rrVRN9DKUGutDrfMRIZT9W1DiaAeD3sedqRVlA0IQ
	z1sgG6/w/nRkiMVfMeMnTDeWFfxWJr305oSkCSpjOvAQA4xmfU0e7JSCd/nVkoncE1Dmfp
	SsPU94AQBeYXkURDGr1U0tKiOnMv6aE=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RSdjPcwo;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780095604; a=rsa-sha256;
	cv=pass;
	b=KtQyoq8HCM7yFxtU2kdR+MNPBljSr9TkkuiWiGc508rUPuMq+LolHUXjWRr30WVy/8D86H
	FKZpJsna92q/+P87fn0DE5rVsVr9WepWCa2fol6/1+kDKCd4W2fTQESMf+IHNhOj3P3Uf5
	WcWlCy2Oq72HN8Cyc9Av2OMUfOIg5Js=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-45ef616daf6so720215f8f.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 16:00:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780095603; cv=none;
        d=google.com; s=arc-20240605;
        b=iFVGluOpyPlfqL9vtB8ScalkeIv/Gf1gdji/49qsCfW5qQb3BliAX0JbU1exnZNLko
         8m5ROcFRs6JGUJVEiwg6XXwpeqWGPvrTyd/ZGS3UEFxh1FWQg5kQ7KqVGYAC/QVLoMr6
         2i6397gIlWCCmF2hhxlWC24RehTgCiu3bYw+vkZHqp4yNJEvidhYE8Wb4Qj3ZEojHzb3
         OSH58PTp9uamIytsggt1LNyWgj/ICvAS82AZ9MoZnV8stT1tuETaMCd6F4DX163zJhJU
         LrfGyWqnyqHuoQX49tMTGJuGOZxkkNrOjQUdrYgvax4C22j+hwyR2LSYtz4FEVGVRTvu
         0O3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=esBJv1XmH81oqfMvMS6FKEsXTHYPPlye955uwcqZrYo=;
        fh=owjxmPQf3nx0Q3xLVCT2vvF9vh62LAHUJxmAji8M42s=;
        b=X866zg3VrEaJ3ynVi8dPGDZLnKFNBmkU2amNP0dFDxYrqsuhpWrzREbYrISEEiKd2o
         86Cjcr/IQJYWTlA6MSr1oM1nPKJ+ZdNu6hT2+tRb0Xb/IPpTmOVMrfYBlL4RQDrrlXxl
         YC2A3YofTk8QZPbjjjAdkhIGmIwyjYbWN5MNXx0Z9bJzMjTHqik4qKGNMNJr1tHkKWxT
         /b+zjNotOT1QlTRqVjKn72IUV/FtcTZ1VWk6SkN5EaXkTvm4RX2pzKEIHMQHS6dIIiNR
         QpTYJrp9LtRZhaZ7HHQxSr36zHhqTNVXM7jxd6x3cICE4NfVMorjxUjC8+x0MrSHvTkq
         QAFg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780095603; x=1780700403; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=esBJv1XmH81oqfMvMS6FKEsXTHYPPlye955uwcqZrYo=;
        b=RSdjPcwoixfljrvhitAV+R5/ZEWhEsH1qMJrQT67xztbPjGZnwgnOSe9KSkxl4uNtN
         oJMnky0VKg4NSPQKubazWoX6t4EL9VgFRTf5XxOiyLM30pCX+nnyDH1pSZ9D2gvew9bJ
         /jNp5IaR/L6ovxPd7xx/Hzm7U6+sGf91V8silxWpXUE7iQue2+br59S6viwhv1UNy2d3
         mJawKhNSquMykGSlNzJIFxRWE0tlUt0N7Q9pHdliqkfBqE4mpCSqFebJtlEhCDKPFDdm
         Vw0yJfRs/0dfLponMYp86UeNfmF0hBllAcgoSDVk/0mDabxfwCuPnw+D8/GlDy3pb5dK
         Ou6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780095603; x=1780700403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=esBJv1XmH81oqfMvMS6FKEsXTHYPPlye955uwcqZrYo=;
        b=RhboPLLHoo6+ZuAE9jF20na+NyB8cl6toaT1AWRqYMyJU5esAHZ3GWSmF6S1gvw6Uy
         fhpp41gC+n1s9yUy3CRMpLKgN82EKDNMZFwa99Jo2f5auMMD8WLfNTBzFgjuxQeC1jH5
         HXBlSQX2jrrumnH5BOoG19vB7MJ8Vu840mGNTIOPDF8LP9yGtDRQ+ApWxCfmm2h8DKPT
         pMnCT4knaI4HxTpBS5RzqjXqhkGo80HmAhu0mfxMP+LCYeTVxGxmDbpDJr7ShITdGFfm
         pAP1E1llqAVgZ+Cl6k9BOqjGRoaiEwrvWnGsoQdfObMvqzmREhv04RIyfC3JuAD0trpY
         f64g==
X-Forwarded-Encrypted: i=1; AFNElJ/ZL4p+WCtC/Zs9FM14MQQjSjRV3XF55NTU7G7R5J+7jB1UnJ8Zzkvn5jThfJpB12BuO8KWzTubqA==@kvack.org
X-Gm-Message-State: AOJu0YxcFFPdQDknGHKCUvPeKp4tbq8gwrbULgMvrRd0Ygl5kBgr1Jlk
	abe9vsOEd0hBcP4AR/iDCp8X3zz4sYMA98V/o0rnMNrLjfyRGYZu8qePtd72jvItrncgwDLnBgR
	xDRKHu0prp+iUuEML0qoO4NxciisikKg=
X-Gm-Gg: Acq92OHvNnsh0YdMtbVcRtWe/CNbQpCZ/nmUGkZ8jfRUzFu5XdTxCDvRj5otJWyqDg0
	3D+LfFFCq4Ld29a+KXPzNPCetVVWRPPYT3+f2VEyg825VliNn0ujD92HIswbR/Fg2QypJnI556F
	JZBuBJtV3/LtW6S4/IJDf1gpGYZ3/5MMzUP+DkPaaE5sIC/cOsXLV65kipWS4r8+PniuQ6+1sKo
	eSE3oXx1Z9j7IXmGX+j0w6Fw1I+6CKLvAL5oN3rbZPiyGxAqG7jyCh60YP8nNHx2ezlGZ9KjZZj
	CAJwO8wS0W5BkFKZDhRuFESz96bozWqiyoz9nkJIintsvcn+3Q==
X-Received: by 2002:adf:f089:0:b0:43d:77c6:be78 with SMTP id
 ffacd0b85a97d-45ef6ba1425mr2108467f8f.39.1780095602639; Fri, 29 May 2026
 16:00:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260527115930.3138213-1-haowenchao@xiaomi.com> <20260527115930.3138213-4-haowenchao@xiaomi.com>
In-Reply-To: <20260527115930.3138213-4-haowenchao@xiaomi.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 29 May 2026 15:59:50 -0700
X-Gm-Features: AVHnY4LNv6nJBLUBxh0JlN7CTnCDxua4YFUwff3Kk-OXI-Bg9n_-qXcdHjq1V3E
Message-ID: <CAKEwX=OjEkm766-js+mxRr2KBTSpLxc6wRWXxVuBXt-OT+drcQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/3] mm/zsmalloc: drop class lock before freeing zspage
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6h8ezj74frws1dq1zde6nnfdktw15cqq
X-Rspamd-Queue-Id: 834C840002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780095604-912566
X-HE-Meta: U2FsdGVkX19/6Qru74qIWY3gZzaSpolchFsZ5cDBzmxPI0Rz6ELvF46vwBU6qYQn9JVBTOgEZ1rUsehNUjrnEF1zB9gIKiuJasn7FjIy0n5lZHtgY+sdCpTRdQpLPdnl1IzkvfHIg7ChA7nk/cSttol3u9imcqZZwq2eRTKNLpxDB2IwUPG2Xhqz4NdLfRd8culjVxKFEdFgty3vzsltOBpgfp2+MLbnTdcsF+4TcpdRed9q65MDj8lEBG7wTZhyrdU/rgO6akLIyXeTgCEFLMKQJaEveckZfM0Gsk8kjl2KIwcfJvc0nGEUeXTYyRyUKL7x9+FkZbwWWntEiL/f8/luGVfIy4SQfpmJAGzUvYvwsLGvSxAdr0CKjbyxO7vCT50S0nbb1hFSph/dEyU0AEByASemGvQn05xdZjBAOOdry/unxyKjPpgiiazz/2645etGSy4ssMGQwJGJ38xOaaDwB7RrLrsXRFtnB8ERjTjh8QCuYbF5YouLj86mBjFJG4BZ0mfqqJ69G4zuOrkrRrE0ltOrIhphM0NEMHsv1waLGpJVqPQ3LIqeWuCTMYlyYkCrmXu3AUcgyBJr8mGqvl6FtWzfTXnNKWfGM/1EKrQ+cqnZ4+Mz9/uBbofqEzEnx4Jp30SQILPzuVvqGQeZRKdEul/ZFymQzvEvxoAd1H+h/dZunVskiREeXtw6op+XjMu6XEnxjvNJhzXxoM19RrTYqm+cmkN1CyyBFWwsHSdR5hr00WVWke29uuISBUKmNNryG5OsiaoLNq924a+XctwfIKPiU/BqyterigongxbIhB+3E9eavNejoSLccdSEcHEQYQSM8RcndgD+EuvGgurP4QaOcL0FBoMQnoCKxFOghaZNJnrJWaHcU5RTejvxFkYLxwqEWGeqkftTXwRT0lqoVTLpPRa6XRFq96eo7D2Bk4B/IGRSwbyv48fJCx4tAEHdCJ5CHplD7tGXU0o
 IXsIQC/w
 5GM6ydiv7rAVKDa01Ozszk+y2QIts5PdmbrSWEkGAXJLIgM9gq642yzExGyC2bAVxa7vvLmuEWDTNnZYc+T9Z6qjGAxkqRtZlOErGMMgyjoukNhDH9Fa8hGLCvG2l8BgeRFLKjlDPo3YSfiMRh9mYaKrxu53K5aLvDZ3+NJ19iv7TzO5dnW0REoG9J7WRmeo1Btm3m/SU+yoJqWJM3vKLrMkp3bSroYnRO0jA7eaFe1UlDMvi9u5zLwsRT1AUUY9BbA5ypUcx76wcTSlnDPU+cKVrl5OM9ILBlhuHd1oPx3TULpkjVs1NPvGrniQxDXGpB1+6pD/aE7npvRmtKuyhd9BeI8dmaeOhE57Ekx4QDeQ0avLELaytkOFd/zNe0Vth3hzIsuFOuTDsJLqSE8eyUC37AiOhUC/CjL8Bu1U1uERjsanMf2ZXhuA9IWrdOQXWsnaQsptqTJHvjZquEC8SJlb5SvYGruKEPa3e4SW3oKLe8Pt2ZWhXoLREBqOh7nqIs539Af4dZgvOsfc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 5:01=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.com=
> wrote:
>
> From: Xueyuan Chen <xueyuan.chen21@gmail.com>
>
> Currently in zs_free(), the class->lock is held until the zspage is
> completely freed and the counters are updated. However, freeing pages
> back to the buddy allocator requires acquiring the zone lock.
>
> Under heavy memory pressure, zone lock contention can be severe. When
> this happens, the CPU holding the class->lock will stall waiting for
> the zone lock, thereby blocking all other CPUs attempting to acquire
> the same class->lock.
>
> This patch shrinks the critical section of the class->lock to reduce
> lock contention. By moving the actual page freeing process outside the
> class->lock, we can improve the concurrency performance of zs_free().
>
> Testing on the RADXA O6 platform shows that with 12 CPUs concurrently
> performing zs_free() operations, the execution time is reduced by 20%.
>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
> ---
>  mm/zsmalloc.c | 28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)

LGTM for the most part, with small nit.

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

>
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 88d10f814da9..5511c347d00b 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -856,13 +856,10 @@ static int trylock_zspage(struct zspage *zspage)
>         return 0;
>  }
>
> -static void __free_zspage(struct zs_pool *pool, struct size_class *class=
,
> -                               struct zspage *zspage)
> +static inline void __free_zspage_lockless(struct zs_pool *pool, struct z=
spage *zspage)
>  {
>         struct zpdesc *zpdesc, *next;
>
> -       assert_spin_locked(&class->lock);
> -
>         VM_BUG_ON(get_zspage_inuse(zspage));
>         VM_BUG_ON(zspage->fullness !=3D ZS_INUSE_RATIO_0);
>
> @@ -878,7 +875,13 @@ static void __free_zspage(struct zs_pool *pool, stru=
ct size_class *class,
>         } while (zpdesc !=3D NULL);
>
>         cache_free_zspage(zspage);
> +}
>

nit: we have *too many* versions of free_zspage now. Can you add some
small documentation for:

free_zspage

__free_zspage

__free_zspage_lockless

to help reader distinguish between the various cases? What do they do,
what cases are they used, etc.?

Can be a small fixlet or follow-up patch.

> +static void __free_zspage(struct zs_pool *pool, struct size_class *class=
,
> +                               struct zspage *zspage)
> +{
> +       assert_spin_locked(&class->lock);
> +       __free_zspage_lockless(pool, zspage);
>         class_stat_sub(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
>         atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
>  }
> @@ -1492,6 +1495,7 @@ void zs_free(struct zs_pool *pool, unsigned long ha=
ndle)
>         unsigned long obj;
>         struct size_class *class;
>         int fullness;
> +       struct zspage *zspage_to_free =3D NULL;
>
>         if (IS_ERR_OR_NULL((void *)handle))
>                 return;
> @@ -1502,10 +1506,22 @@ void zs_free(struct zs_pool *pool, unsigned long =
handle)
>         obj_free(class->size, obj);
>
>         fullness =3D fix_fullness_group(class, zspage);
> -       if (fullness =3D=3D ZS_INUSE_RATIO_0)
> -               free_zspage(pool, class, zspage);
> +       if (fullness =3D=3D ZS_INUSE_RATIO_0) {
> +               if (trylock_zspage(zspage)) {
> +                       remove_zspage(class, zspage);
> +                       class_stat_sub(class, ZS_OBJS_ALLOCATED,
> +                               class->objs_per_zspage);
> +                       zspage_to_free =3D zspage;
> +               } else
> +                       kick_deferred_free(pool);
> +       }
>
>         spin_unlock(&class->lock);
> +
> +       if (likely(zspage_to_free)) {
> +               __free_zspage_lockless(pool, zspage_to_free);
> +               atomic_long_sub(class->pages_per_zspage, &pool->pages_all=
ocated);
> +       }

I think Joshua has a point here. Just plain "if (zspage_to_free)" for
simplicity?

>         cache_free_handle(handle);
>  }
>  EXPORT_SYMBOL_GPL(zs_free);
> --
> 2.34.1
>

