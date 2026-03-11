Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20B081125826
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 20:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 816926B00A0; Wed, 11 Mar 2026 16:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE0A6B00A3; Wed, 11 Mar 2026 16:17:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0B56B00A4; Wed, 11 Mar 2026 16:17:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5AB726B00A0
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:17:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2760B91E2
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:17:36 +0000 (UTC)
X-FDA: 84534892512.04.040EA23
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id E843810000E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:17:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hcKJMJie;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773260255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lV5czEXSj6GTlGyrBR9CLBL/OkAb3+kqVVdUiTYnGjA=;
	b=AVQRg1S6+3bFzsl/PtMq98q8PHwKKhZFWGc2NnsWkam/wPdHFk8rHqserbVIXgUJlyczza
	kBgYYRslOW6AzxUIq4RHHN9ver4faxes2m7uC6vF50VjB6VV6L3LuOO4h/myU2mR6XH31+
	8FvesIdLtbGshBOR57eR49vvyUUNGZI=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hcKJMJie;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773260255; a=rsa-sha256;
	cv=pass;
	b=uGyklTTCVogv3KsIs5YvbnFonrDWeX6zRZATu/0Mi8VGUkwzBiqYDb+jyX8Bb1qnO8TvtH
	v9VRmzkuEB+7MyN3R5e8EShfpKY8B8RtDP4Ot3ndrkQ9rVBf0wKvai8f1dUBHLf5MsuyUg
	D8WU/IsjJQyJVW7lQUfaAIdqGYq1lLw=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-439c4bde55cso199794f8f.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:17:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773260253; cv=none;
        d=google.com; s=arc-20240605;
        b=WfX1JhVVR8GZBcXUMH0K0UmSiTmnvvrgez/QmOuBvUpoPxn8Og7aQXRZIkLJjSVAAo
         JfVZq9bi7+Gvrfpfg2CCoKU9Er4ojhcNACkY/u9ub8ZmrrzGaFRNgn4lcFUbf4iCHvs3
         WhP1QDlNnCVJrGA9E1VND/ehkTjG/6IuzwRS80Aqd9AXI/MsnwL+r81IKndULahDcbcZ
         7YoAJcfx1skL8x7fDCPev6GuhOMHcxAeSKetmK8+6ZPCcJAsT7OfR9rpHVkK34xeTTzs
         3XIaBDx9dmni1G8G9pLyqc5EguN0q1RV1gT32jnnIZYRChrr++/5wsIBzId6xL2wYCy5
         MceQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lV5czEXSj6GTlGyrBR9CLBL/OkAb3+kqVVdUiTYnGjA=;
        fh=eFPAFk7aq5JtP2sFInVHtGhuHmS0WfkdLAe0+hJ/TBQ=;
        b=NvHjklnhL+W2Or01BxPOOhYs/OKXkMa3ItDbtctlUmOo7wZWriS3pjGxaeaj4vViPW
         FlIRMQr8bX2+mhC2gCdP66WGJef3bLagT97pEAQsVi/uizKUtXm4XSL9qU6bBcvr4U0+
         y/qpm4A52eaJzQWSKumQA8N9QOGT34Ac2ca8FIUii1SyXvevz0R1irZrqp8fwIHbAWWb
         Sg09feMmEGDw3UUISsbiuwQZOSBAqa/rk9ObjW0b3hKIMgPdzG0Egc1QC1Bt8ZwDQlep
         JrfoC2Ik/vPaU7jjeEeH4/CVXvk6vQUKUupOJLuXZEU27G9QWOj4ZWfNxTqHK17w/Yhj
         uzhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773260253; x=1773865053; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lV5czEXSj6GTlGyrBR9CLBL/OkAb3+kqVVdUiTYnGjA=;
        b=hcKJMJieqXNKri6Ri4RfDRzKZtuAxayD6ag/t/UcGpHnI/tu768mlOTGdzDEtsH1Ki
         WJ4sSsE7cdiUdK9Ls5Ek5m+Hh35zX4s/rf7xAiJT9vk0/t+p1Tb2Nexv6pVuMISYzqIc
         ZmL1XeMrHSXANg9z/P63Wc/HqaH0p0cSX/1RpbXToqunyNnXhz54KScuR2WDaLqRYQJi
         JJN+tN5bYty/nJyF1HYDMOgorh1nH8EHA4hkmfj5VXgGEPZF3wyiefnapmPpNKFUT+Gf
         0JzU2X0QztSnJeSJQidhkGhZd1xdZK9DPQl44KRW11TC2BV2ZUlmaDOrpkG+ARtlDcQr
         DkEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773260253; x=1773865053;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lV5czEXSj6GTlGyrBR9CLBL/OkAb3+kqVVdUiTYnGjA=;
        b=tHg7FfIi5yLh9bzAXLy/Jq4XaEDEB6R3EAwy7f1ndZf2GC1SV6MYRbLI7AX9PogD32
         /V2R7X21pnOYO00GshkltfCXJqYDme1+WHZ35udCmlXz7KuOqwJ4GzLCUh7gLVUl/gIu
         /xxH2ucbfY/OyClkqnN9lW2I/h2NdTQA5jZjkJpn90pBipTF52c4mWcnHaQHg/ojNqgc
         QV2mFKBFzCFxTE5r9yC247Va/6hm5SsKZb0VdkrhHekZUO6IWMAT2XrVdP73XPvRx2OA
         N/HPd4jUzBMlzem6IJ/Dg//lezIZ9niQIliBJKH6qoqfbLwETq2aIOSpDtoKdwCEHVmA
         GqbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTJazodCGVoa0K+4dPUFVoSR4owjD5BWkhCOK+5k06RQgIRuq32nfD3pvzaxaq91fw+Dgp4G8whw==@kvack.org
X-Gm-Message-State: AOJu0YzQMzHZgydoNrqKUQSRKyclrshtGBupajwmHpRJWmT38xWl200r
	DNURYea7Gz+OBi2SkyzLWah+Tf5yHTkwMMPf7ML8TYuvZsSbiMcrRxZpY6kThFWBV3lOx9J0yHn
	89rphcv01m3Hiiqz1q+DQBTerU08tNWk=
X-Gm-Gg: ATEYQzwmwxy6NBAZOVznc69fl8AQQgysYXowytYxAljvUXCIam9xP+Dud2h6yhXi4fN
	uzKdGqcCwuKnnMRrtJ5udk4dXB2h7KoK4OHHn0ay4uNDllvIQeBr+h4OmLGYyaCbmlSFBvZtB9B
	uTR/Gw98PTSS0rjKBFOUfsNeOUGJaISl6p1AUS7U/rea6mMrvQZgMXhy5N8sVamgJWFrcBFnqDJ
	CTC+hiRyBe4SP3ibQgeZpLMaD5FU0CvSg0Z1m6f0oHJ3xGCPryFJxG7vcrkHJf9fMKTxFs9vfIC
	nRNorFzuTxY93iGUU0vj4J0O/bLT+GbMjK0DuW8=
X-Received: by 2002:a05:600c:3511:b0:46e:32dd:1b1a with SMTP id
 5b1f17b1804b1-4854b0ae565mr72255395e9.7.1773260253382; Wed, 11 Mar 2026
 13:17:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com> <20260311195153.4013476-5-joshua.hahnjy@gmail.com>
In-Reply-To: <20260311195153.4013476-5-joshua.hahnjy@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 11 Mar 2026 13:17:22 -0700
X-Gm-Features: AaiRm53KOhSCrzsuPj5GmyiSCFvk8oRrWzuZDDh6-67NZPwbQagJ2OtgQg4Zyp4
Message-ID: <CAKEwX=Ns9zGhSSYOfVunb2dR-i-0krFP4SKQfro2FztLkbH6-g@mail.gmail.com>
Subject: Re: [PATCH 04/11] mm/zsmalloc: Introduce objcgs pointer in struct zspage
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Harry Yoo <harry.yoo@oracle.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <hoangnhat.pham@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dijifffsfofnjfazpxjhkr8xarfd38rf
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: E843810000E
X-HE-Tag: 1773260254-446455
X-HE-Meta: U2FsdGVkX1+PKxvj4yHEKabY5E3ZTrbzcMrPY+ZD1EQMW8y3F0uyTBjMU06B4Z8Dc2sLmFiMbSksefwzjzdfzdQa8tjtRsDcDNuOaxweTraog6nPxSz/yZ3d7heDBUrjhnMxYyR7BlX/pHhNTZ8JinF0yWNRe3WPv7zjpmOU3o84frNEbztzOVLrgzvTQOXQm/o1C+la80xFS0GXMtQ+6vvDVKV0ogJlaH8byFe3xR9yySh1e6KX+wtRCJIZE+D1xmwBA1DcFw9YGwrRZhiJr55yK+NAV5zA0HqyAlxtNcEYGx/QGEn1t/kQx2V5Q/WHpLeMN4Ph49Fz0u7S3ODFl5M2eYscxLCGqDrwKlX3rMhVQ2GW5r5XSkrfhNcP82y1lsnRuILPyVkoQ1l+bh0+efEiivyvBYiHjgMvbD/mqgXzrorKaCrncquPUNzvd0PcxCoaRyzaGu9iU3NKlRh/8neHOiUX/n2RMa2hBWeCh2dQjfBaxkqX2GC9p2yasFKWwTmGapdy/+NEiuCM6kSzew4ITn4GYDHIXVejZ1X9OZV8DQgEEDm6O+6l75izlK2A0DRGrwrlrkX1pcQDjkahE17YJ3Plm/j42j06zsX1RzT+ULRSq4Kk7aEdN4QTO+hKgArVXlpq01cUvs08mR5+gSbsTZSqnJxw9Drm6cB9K8t6iykPlCeONUGmn28hPDVkiDZ6EgV956OeBx3RVOoyeZiLBKtcZPW08HFLSteER32UIHbcjFqfV+8krDY66tYVF/5coSC7a+9ebeKqdaJf0/tjiF1aW2OTCKKUKbZ81vy157hoH8dxKGW8DdOZONB3hAgL3UzLSmBudUILfbCIHpKFoR5BFwnRWoxP0FQKk0vnubKmfwQhFQuOhgoLRQyfng7SqcGOMKLTSnMTAmt+/azqcufcEJOT1dcVw0vsvCGoXWfSlSZHJd0p2RAlMa+oRj3MKlYKm4D4fI+wU8J
 7dfhAZvy
 Fn1bPnwT06V8W3nSxd3elecNMM7tFntwYaZL5V+lRjWdc0vlvcFhUyKJT3gCqz8Isrnqy9qEnICPI499u/ij4O3SlXVU/NR08FTuF3+huisnnm8qtep2lj514g7rmqxSDZ/7Tl5XZ+Vf4q6cYcNBWJM/YTiZfq9fSsc+9czmAcYqZ8/L12ZbGRMnxAqcP0IM/5EbLIQmG1xvW6s/0qhG7yUqJZMqN95XRO5sm/pEAOJsxI0E/JWXmpWNbL+l97/jkwdZE+zlzRpDh4ULkdvFfYQ6VZr9Q8C62MNaq/mmA9+ry9w7AhcsGMTtsekPWUZ/6L7WJ237PV6CTaFgy9cgrredHMyrrhG3hjQn+zfXPjkGSz62f7T/jqV8G335bST3umuhvMU7eYnEKLWGmAigd5/XFobzwdWA+NSb59DzJ0TetP/FN6yFgmgDntTFmtC83ii03+L4ZqMFBTWUWdOKhVTcxOS2vV8rhY6g29/FmbprIp5TWq/LY//QbSIcDaYEKFXdcWItAaxR9kQYxttddLZZ9cDFeH8/rlCJyGYTesJUkhEt4EG6bmVO+6Uo/XqQhFO0h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 12:52=E2=80=AFPM Joshua Hahn <joshua.hahnjy@gmail.c=
om> wrote:
>
> Introduce an array of struct obj_cgroup pointers to zspage to keep track
> of compressed objects' memcg ownership, if the zs_pool has been made to
> be memcg-aware at creation time.
>
> Move the error path for alloc_zspage to a jump label to simplify the
> growing error handling path for a failed zpdesc allocation.
>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  mm/zsmalloc.c | 34 ++++++++++++++++++++++++++--------
>  1 file changed, 26 insertions(+), 8 deletions(-)
>
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 3f0f42b78314..dcf99516227c 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -39,6 +39,7 @@
>  #include <linux/zsmalloc.h>
>  #include <linux/fs.h>
>  #include <linux/workqueue.h>
> +#include <linux/memcontrol.h>
>  #include "zpdesc.h"
>
>  #define ZSPAGE_MAGIC   0x58
> @@ -273,6 +274,7 @@ struct zspage {
>         struct zpdesc *first_zpdesc;
>         struct list_head list; /* fullness list */
>         struct zs_pool *pool;
> +       struct obj_cgroup **objcgs;
>         struct zspage_lock zsl;
>  };
>
> @@ -825,6 +827,8 @@ static void __free_zspage(struct zs_pool *pool, struc=
t size_class *class,
>                 zpdesc =3D next;
>         } while (zpdesc !=3D NULL);
>
> +       if (pool->memcg_aware)
> +               kfree(zspage->objcgs);
>         cache_free_zspage(zspage);
>
>         class_stat_sub(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
> @@ -946,6 +950,16 @@ static struct zspage *alloc_zspage(struct zs_pool *p=
ool,
>         if (!IS_ENABLED(CONFIG_COMPACTION))
>                 gfp &=3D ~__GFP_MOVABLE;
>
> +       if (pool->memcg_aware) {
> +               zspage->objcgs =3D kcalloc(class->objs_per_zspage,
> +                                        sizeof(struct obj_cgroup *),
> +                                        gfp & ~__GFP_HIGHMEM);

I remembered asking this, so my apologies if I missed/forgot your
response - but would vmalloc work here? i.e kvcalloc to fallback to
vmalloc etc.?

> +               if (!zspage->objcgs) {
> +                       cache_free_zspage(zspage);
> +                       return NULL;
> +               }
> +       }
> +
>         zspage->magic =3D ZSPAGE_MAGIC;
>         zspage->pool =3D pool;
>         zspage->class =3D class->index;
> @@ -955,14 +969,8 @@ static struct zspage *alloc_zspage(struct zs_pool *p=
ool,
>                 struct zpdesc *zpdesc;
>
>                 zpdesc =3D alloc_zpdesc(gfp, nid);
> -               if (!zpdesc) {
> -                       while (--i >=3D 0) {
> -                               zpdesc_dec_zone_page_state(zpdescs[i]);
> -                               free_zpdesc(zpdescs[i]);
> -                       }
> -                       cache_free_zspage(zspage);
> -                       return NULL;
> -               }
> +               if (!zpdesc)
> +                       goto err;
>                 __zpdesc_set_zsmalloc(zpdesc);
>
>                 zpdesc_inc_zone_page_state(zpdesc);
> @@ -973,6 +981,16 @@ static struct zspage *alloc_zspage(struct zs_pool *p=
ool,
>         init_zspage(class, zspage);
>
>         return zspage;
> +
> +err:
> +       while (--i >=3D 0) {
> +               zpdesc_dec_zone_page_state(zpdescs[i]);
> +               free_zpdesc(zpdescs[i]);
> +       }
> +       if (pool->memcg_aware)
> +               kfree(zspage->objcgs);
> +       cache_free_zspage(zspage);
> +       return NULL;
>  }
>
>  static struct zspage *find_get_zspage(struct size_class *class)
> --
> 2.52.0
>

