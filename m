Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9178EC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 14:51:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1527C6B008A; Thu, 31 Jul 2025 10:51:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12B2E6B0093; Thu, 31 Jul 2025 10:51:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0679C6B0095; Thu, 31 Jul 2025 10:51:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA7216B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:51:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B79F4160502
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:51:14 +0000 (UTC)
X-FDA: 83724847668.12.B567FC0
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id AB0C31A0006
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:51:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kowalczyk-ws.20230601.gappssmtp.com header.s=20230601 header.b="TZk/l8yT";
	spf=pass (imf19.hostedemail.com: domain of patryk@kowalczyk.ws designates 209.85.208.51 as permitted sender) smtp.mailfrom=patryk@kowalczyk.ws;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753973472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IRJbAub8KuCgRqOk042KmktSaTt0LegPLtY8Icpmfw4=;
	b=NxDmHS3dg/VGK6Q11Y4RbmBuIgLYVqhs8ohLj6tWMHRsvBJmHN6IQlif5CuyohtiCZeYjC
	dT7lOOBOepj9nr/3Kw0b9huW9DstKzDB1AkyDqpHb8ILzLIoaUvwyGE0MvJCoE1ajTe4QY
	gd0rxD5IYrEpGs4k7Z47hh4HhUoQ5yk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kowalczyk-ws.20230601.gappssmtp.com header.s=20230601 header.b="TZk/l8yT";
	spf=pass (imf19.hostedemail.com: domain of patryk@kowalczyk.ws designates 209.85.208.51 as permitted sender) smtp.mailfrom=patryk@kowalczyk.ws;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753973472; a=rsa-sha256;
	cv=none;
	b=ibS7B/WBiDO8GfpFIvSToMUgO6aeD7A74wz4yqPCzQ7tRb34QgfGJ05XqHppods/VCHT++
	5KsmVvz5ZTrHfxZ0Mmn7wsxrhs0Dcu0x+HhgmJqDmoZktVtorSvQ6H74rxv9RSLOHzijIY
	dj5oIRV8AmNPzJPaqULPQNcwzLkF93g=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-615378b42ecso1692329a12.0
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 07:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kowalczyk-ws.20230601.gappssmtp.com; s=20230601; t=1753973471; x=1754578271; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IRJbAub8KuCgRqOk042KmktSaTt0LegPLtY8Icpmfw4=;
        b=TZk/l8yTu9zAhWB1RVSWu9dGD+gxscDePfd2Wvpi0w+AOULZa7eAQA0JFY9ea7YtOc
         0NarfED5SDX8qsQ0Ztq9ds6dtY9UH19Y7YClP9j+1CiBrlzOFHRt9a8K/UZCUly1fbHn
         /5nktSdnuXd7dlOjlQRtP7CI+SjGc23pqLCLZVJ3U8yHQHLMcd5NeQeWFLDQa04ifoC/
         s/dSBIXOnxp4mz1rs6qwF4KlO0awAPI3UUJbKgsZ3FLgJWA3WqhLSlEUjIEaKcMzhoZI
         CnOaKPqS6e2Ir/1Vx/fV60UQnItzzHpQG7hRVzfjOnkQTwcVmU/uHt4WMvIAbo5Bxikm
         ey2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753973471; x=1754578271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IRJbAub8KuCgRqOk042KmktSaTt0LegPLtY8Icpmfw4=;
        b=icQ7w47f3WmXTZMkqDgNp/eYE43DcWFJL6cYcq8l4KFRbTLqvSQYD0t8j8xEYMOCc2
         ZN0+k1ukLA3RTvHxG7HM/1P96GPjIJLFQB8UxPBc2O0Q2p3uFLW8N/GcfptVN2h0kAHg
         JXSq4/4rFFZCsK4J8OiLQnAgOSBaWAd7RlVqZwCF9Y8E5vM9EjO+vf4sc47ijijnvy0c
         IC8rmXEDz8M3FLGn7LwA6dOgurf8cDSPZ33dcrVtDaGAuVQx6LwESHRM5aR1SiQeauvN
         7j/fWFaJrl9IegamNCzP8Rktrr8VRTRO4AZcbIPupoV7WAXUa42M5U6cfKbeXhrx1b75
         TeRA==
X-Forwarded-Encrypted: i=1; AJvYcCXnizbC+/wDoFahWWFAsnYuNy6MBP9X24YeMiT0n+MIJJP6a0U9YFX5Y0Pdq2jO9szSD+JRE5UYIg==@kvack.org
X-Gm-Message-State: AOJu0Yyra32DjR/0oBiWu2zOnJ5c+CDi16+w0IEF92IhxSGaktSwcDGn
	TpTJaR+7UgjJXpwqRpYIQms2iRrz6HrOvAt+eAvnOgsZZSrzuPXGIOmC4N9Sj8DyQ2cIocII//z
	+WvCiJZgrNOU+GKuDRKpSYX3kBq0+qFNojv38M+8V
X-Gm-Gg: ASbGncuDvhr0uCslnXFJD99QmztvyMgJ34XBR5YeNJqm+pekPixPgZJVMG//syA1Bsl
	o9nXwoUiJ09o96zAJV/MHx05Qsrp1DGQEwx3ezlmEvSy8frlTwKsucnPjQr0ONPAB9XA4TBwG1M
	Ui/RiFh15IcQLIBRc1YyhZOEzlubWDw61bsvBp1vcljla6/v51B8Q9LmK7TnUB2chGb7BbLrLpk
	u95
X-Google-Smtp-Source: AGHT+IGZY7UseRYSFQBaSqdhffcEIF7jCfDrD9+0HtI82aHPApXaJSNDz5JLaBTvoWHQDv4aQl7vq9zDoYUPbWSh3NE=
X-Received: by 2002:a05:6402:210a:b0:615:b6b9:d859 with SMTP id
 4fb4d7f45d1cf-615b6b9db0dmr2004485a12.3.1753973470621; Thu, 31 Jul 2025
 07:51:10 -0700 (PDT)
MIME-Version: 1.0
References: <f7e64e99a3a87a8144cc6b2f1dddf7a89c12ce44.1753926601.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <f7e64e99a3a87a8144cc6b2f1dddf7a89c12ce44.1753926601.git.baolin.wang@linux.alibaba.com>
From: Patryk Kowalczyk <patryk@kowalczyk.ws>
Date: Thu, 31 Jul 2025 16:50:59 +0200
X-Gm-Features: Ac12FXz136963mYuJ5YCEu4SeKKHx8OQYOh5muD6VLWBOteHGPZjvJkpeAM4OC0
Message-ID: <CAJCW39+3whWNZ7PV606cewqvdGrE18BTbnDLZ_Py=6nvV+vseQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm: shmem: fix the shmem large folio allocation for
 the i915 driver
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hughd@google.com, ville.syrjala@linux.intel.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: AB0C31A0006
X-Rspamd-Server: rspam06
X-Stat-Signature: rge844maeh8xezbfyik6ywgse6kdngy6
X-HE-Tag: 1753973472-169351
X-HE-Meta: U2FsdGVkX199qCuobzSXE5N3lqIfES2DIxpoONXEpJLbsFNcmIFuQmvQQlK3k+nVDVDCaciULaXqpRRqFQvD5CgyW9cbJzwXk1tkbOrObfoDOnJeMARE6Jl4i4sJRQvA+X3KM8r9b5NV/stRsOTXhRGQMT36wmLPM7Pqhhl0BnxSD9NqpDnalA8d355N3qfATIp/MQCjYjB8VPbmEVf/b4hjkzFPG65AtySApmNvV2KAbJd/u31XWGV57MntGlyptYpm1xhtbM75euIiuX1sF1E4wnANA3CbC9Mti7dvJCVjfOW+xZOIRxtKyFmaYkim1JYvMDpkiMUkULADhAsztqjUHCF+rPN1leaoIV8+9UtnZovEZZUclcK4Oj8OlAKty8EOMIw+dNVUZw4Pg8n1f73cUyY3u3VCo3L/KAa56WTC5erA1t1C2lmig/cSf19BO6J8azBFTgT5ye7Q1zB+RssNWKUHtBcITwCz8pc4OPwRgzJR5U8yQ+A4qKZz2ylwhKXYnFuJ01u0G3J9ViH5CYLNs90v3egWHuW9lytBAmyhtUHJTI+4eI0kBNlZYpTYP5OnnHd3rpZ760Uu5J5QcAWsOR0ngm8dKXnMHYVsKIrztFC6ucswXBMR0GdYzPDbX8Jn9YfaEHzu8som6E46qVJC8ksTXitdvC4enYMt7AJBGCEctYe2Z5KybYYPPorEBl5hEP0XkotCYrv2c5btbgWdYXuBWds1iSvrA7RjQR+UI7+HxuJ+zv0UvrWRV1JQANpKHLC3NrjHR0ACfW3OFdN8J1dNw0HsdZpzAuzr5aIvVFpwFN1WTA2Rql/uaDmsWON/tkqobndfgICDWkibgDP+MQzOxAJK1dkf5Al5s/zUXM/Xqp4p5q7hvL5hQ7Ve/av42x8toA1O4XZ3WQeP61BesmRST5uhscm8rUnqgmdDGP97oqHO7dCD+JQpSFeAMy2RlP/IOvuCbnaDfXv
 w7A3JRyZ
 XAmcym1bzU78+W4MKAHILxtwCAqOPRin+iinJ+MtFjKkrx2RgrD8Esfh3374aQg7FKhPALsv57ciU3sPawIDBGb5JDwUCw0C/1+07Y42epIOJjoA3xzg42RZgnkVv84hPQfSjR6qcaJTUV8YdWBTrRYZLVFEPqfAwdOgHtjmVAXIhY3UzzTMiljCVgsKk0o0xEXPJP84IiKa0nJygbmo6tmnIZfYlCl4DD6f7G468fYs7LvkRz4iE3xJaPB1DPIFFl5jE3kHfSUp7SXU1qro1xd5zWVVIeGobMiTTOjzPaagb5kEPAsjVYmthTCalz+O3QNkI3W/6PH5LSeEtQrNUxlZcvjKUmUPdPSMBMOThs+wYpNUV82xuEqlwmcYB4T3G5i4tQpXqTz2lYgRvIaqet5fvP+pZnf1oiEpsEq8/ErvvVl0q+7ugKdJ+ATj9kJ2mLW2+ZRnMKrZBpJoHAVnn1TBsGQRjYk6q7rJMp3XkFpYYP/L9qL6YdwlseK8huLpeDt8NOEdYk6jLiAc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

That patch solved problem with the i915 performance regression, so the
previous patch for the i915 driver shoudn't be merged.
best regards,
Patryk Kowalczyk

czw., 31 lip 2025 o 03:54 Baolin Wang <baolin.wang@linux.alibaba.com>
napisa=C5=82(a):
>
> After commit acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs"=
),
> we extend the 'huge=3D' option to allow any sized large folios for tmpfs,
> which means tmpfs will allow getting a highest order hint based on the si=
ze
> of write() and fallocate() paths, and then will try each allowable large =
order.
>
> However, when the i915 driver allocates shmem memory, it doesn't provide =
hint
> information about the size of the large folio to be allocated, resulting =
in
> the inability to allocate PMD-sized shmem, which in turn affects GPU perf=
ormance.
>
> Patryk added:
>
> : In my tests, the performance drop ranges from a few percent up to 13%
> : in Unigine Superposition under heavy memory usage on the CPU Core Ultra
> : 155H with the Xe 128 EU GPU.  Other users have reported performance
> : impact up to 30% on certain workloads.  Please find more in the
> : regressions reports:
> : https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/14645
> : https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13845
> :
> : I believe the change should be backported to all active kernel branches
> : after version 6.12.
>
> To fix this issue, we can use the inode's size as a write size hint in
> shmem_read_folio_gfp() to help allocate PMD-sized large folios.
>
> Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
> Reported-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
> Reported-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
> Tested-by: Patryk Kowalczyk <patryk@kowalczyk.ws>
> Suggested-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Changes from v1:
>  - Use inode size as the write size hint, per Hugh.
> ---
>  mm/shmem.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 41eb4aa60be5..e1e5d5f7f58d 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -5989,8 +5989,8 @@ struct folio *shmem_read_folio_gfp(struct address_s=
pace *mapping,
>         struct folio *folio;
>         int error;
>
> -       error =3D shmem_get_folio_gfp(inode, index, 0, &folio, SGP_CACHE,
> -                                   gfp, NULL, NULL);
> +       error =3D shmem_get_folio_gfp(inode, index, i_size_read(inode),
> +                                   &folio, SGP_CACHE, gfp, NULL, NULL);
>         if (error)
>                 return ERR_PTR(error);
>
> --
> 2.43.5
>

