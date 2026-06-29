Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3A27C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 18:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A38EA6B008A; Mon, 29 Jun 2026 14:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EA636B0092; Mon, 29 Jun 2026 14:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DA4E6B0093; Mon, 29 Jun 2026 14:37:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0FB6B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:37:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C68451673C2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:37:40 +0000 (UTC)
X-FDA: 84933808680.05.4967162
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id DA4B040007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 18:37:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KoEEPYCO;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782758258;
	b=SBnLJMLKVbgrAhDCUJw0sia5ZWL6uf7TRFMj9T14vS4S5tUOnQgsQ374KomKArz/9SPVQr
	c/G7jCa75O+x6LWlNpx8cAXvaSF0FX/i8wc2Gig32/9waDbro/xOalmeoNBLJIrtfRdNlg
	QU21Ck/dwxIwgKyP7NQItimZVeRik+A=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782758258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=66IdtV4A4O3twwyEenTNgYY676iFrQKRg0yaSc+sXIk=;
	b=RH2Zx5eQlbth+HHFrU42ZxSo422kiiZXmNTitZpcmQYRpWMivlVKjVUlALfzP8geBLhdMK
	PA7MvG8WLmeUJ1EJDbM+2rXyzIIjDXW5j3J9hUnm6tXfnFjX5Kht9Zehel4JZ/ZxzQ36a9
	j0G18bKd4l8ImaJ4OeLJyglisG9HNb8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KoEEPYCO;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493b29be0d6so9994405e9.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:37:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782758257; cv=none;
        d=google.com; s=arc-20260327;
        b=rNBcjZ9xUEd7lVToKPZiBAVoCbSkwgdXLbkmMHabZL44Ea83+DS5Rg3PwGWpe3KRA0
         mr+OzBd44jmZVfw6612Mvmiq/s8Po/PmnFpYoRVL8gYuniKBNCZo7fCVBj1kjoJQx5P5
         0I6Mzdc9CdbXIU9lzqnaGtS3DvryLPnU03cHaNfSuCymdzsWbFSee77KC10vYSHGFinX
         0T3tLhde4dxNnr+QEtqQTkhCL3W1dnU87hFBMYEVTWfgNzoxpsOI4XMfnDdKe5n9mit5
         dpttAH6xWd2maHe4ci6MQicxSlzAxpOcFujpZcKxeBZ8noKyxjqYZ+Wu8MCORhIgSKhI
         64QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=66IdtV4A4O3twwyEenTNgYY676iFrQKRg0yaSc+sXIk=;
        fh=d7yQJSIE84/x98VfUuh6m6XBYFxPMMu5U1+RC15Hmks=;
        b=Abcil+Et5hJUZN299TlxOCnXoNbHVfW9G/EYbI8zUxUccBC0qQyp/gtjWbYBgxGwoy
         lndegnrblywcqUYkGUE8OWMzFJ5n2Ido495IsZdGgqP1uRTyGCZrSzBj+S0xnhKXXsta
         dzfUAqDDXESHf3IcSC3iU9Mt06p1kG+v6YxKmhav8aJQfyGFuC2o92HCggKIl46Ywoan
         Wjw+MEJErhDVKJ8raVGnDg2LMhF78jQYM52uWYbsml95Az8sjIt6Ji8z7ujw3LLM1LxT
         eGdomEcxf7EZa7VRgLuvOgRcRWPqzSFJIR1qMgvpF1/6eCKpOFlks5CuKlykcDkt0R64
         8mNQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782758257; x=1783363057; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=66IdtV4A4O3twwyEenTNgYY676iFrQKRg0yaSc+sXIk=;
        b=KoEEPYCOWdau6/CeMATVFnpJB9bjVD2PyEgZaVkWT7Mh/FoUmE7WhfWGnvgvxK0jPK
         IzCRsSb4juqim8DYeM5STDSzEPfg7FJZCXeRevNpOBW42YfSa7/+iUWG6ejY7ElMSJ4k
         KqK37EYfJq/OhzHNhOCg3IluzepUsLAkG+rUz7Gudx1k9TJGAh0uauL4qpUb9B27YpWk
         aYWkSQnk6Vd/WRIttjXPpaI9eVT6Y0QeYu2atX9ODlzq5jZoDo2G10q9JKZp/u51ETco
         ZuT/lOCwYY85IqaqdvQxRdqgKJx+3GvYQC0csI7t7EItakrogMt+CNH9LprhJcHQMmeq
         503Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782758257; x=1783363057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=66IdtV4A4O3twwyEenTNgYY676iFrQKRg0yaSc+sXIk=;
        b=KO9ntPGfhJTrOtsmHhWXxykMFsKvz0KBZxtfRDEWcRkx2e1k+YeOrhi4nFXa//xh5/
         j9lOE8YoAh5zh7KyhWJRGhObvs8dY88kXbDf7aP6c9vZLkB2HoRsRLDqXZm8gQzKNdSC
         gkoHQl0wAWil+GSK/O95OCCVNDZiJzK2kFYrX7xgc1QIpY8q0lOyIVREbHG4FWAMf9am
         YvYYp54Ob+uAkUreyNEmv0gFc6jdEvw8TVJso0pkVLz+KrQx1uM0jyLXOuyb1zOwyi64
         cG2gjmZgw3bqTdFn1IPSIi0iXkMJkMzvhysBb5yt3QzWqhamfYkzpD4iIBCKtBLl9LDS
         tqxw==
X-Forwarded-Encrypted: i=1; AFNElJ/42xJJJ3SzqDPkdYdg8FI2Yvgj6sg9lGTFDrS6ZGXRbXrDGtDq9/UPJ6Y27U34z2+YvvOcPEalOQ==@kvack.org
X-Gm-Message-State: AOJu0YzTrgiJ/z5fg2XOGtUbi79ucePTRTvzx2iW94miPgyCxxNV/aqO
	SMsI8EQ/rDkRbk6j1nf9kXWysa8pdtXfzzDlVOTx2zFlzU/nneXyKT9VlP4lVTypbIX5Fc30kUS
	XTUnlmEv40lZmQYtvBuxZSBUHRwi8bO8=
X-Gm-Gg: AfdE7cmeMFMfEyb9jwJZ11pBUDPpRmYHlJzch2Gh+F+kV0o9OCsHDeU4gwG3nnNvu34
	Oc6ZD5EFUfFHzwlq81OTCPUFxsu0E8ozXJiSR670WfOc/og+yPrZGDjxLfj9N2AR98Ha+B1MHQG
	LRst4+kQgneE3i6YLIT/3vrhP6QJ493XwpmEecVuX2a8FmIxypK8iEEhBLOx4Ml1C3enxHvVMw1
	kuWxHxflSQUDkHKcJCB5GzYrsfufZonwVHNFBeLAB41O5m463M/GS6pE0TVETODIuNreBXe/yAk
	t64xEjkrmKjtHmb+4fXVwKyz4M1Y
X-Received: by 2002:a05:600c:524e:b0:48f:e230:29f5 with SMTP id
 5b1f17b1804b1-493b8ce540fmr4782905e9.16.1782758257412; Mon, 29 Jun 2026
 11:37:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260629112032.20423-1-jiahao.kernel@gmail.com> <20260629112032.20423-2-jiahao.kernel@gmail.com>
In-Reply-To: <20260629112032.20423-2-jiahao.kernel@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 29 Jun 2026 11:37:24 -0700
X-Gm-Features: AVVi8CeUNnnZ1b5gr34nY8C8rkHWBFp3tMR1RyjfkvKK-T1UYPS0l8SmSsuAXg0
Message-ID: <CAKEwX=MniM-4-aV17aH3UiDd_Xd2RH743fFZaxEnYX9qvnokeA@mail.gmail.com>
Subject: Re: [PATCH v5 1/6] mm/zswap: Fix global shrinker when memory cgroup
 is disabled
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, yosry@kernel.org, mkoutny@suse.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: p8ekyen6w9xehaxipy5w68a89z8bhwp1
X-Rspamd-Queue-Id: DA4B040007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782758258-886209
X-HE-Meta: U2FsdGVkX18YWT+Cvb4K0nRpRKWlKcYhgmdXL44f5RcpJFub6hEX/jF8Go/Z06yXnofwjygugacD5UonDYBIUS1IIwVseWvskdGvdYLtf0cYfEuFduiCuAEYE6MJedpJClryQWNIS+Umn1xv5ffDPi5FPB5T7BMyaczHJRws2SMaP7X+1HsgumUte6j1S9gRah+9A/AobRReBRYnnyZQYPWtxWYZrMsUJuhJRvVKqEbSs8Qg0m+kRC58mgHI6gHE3i5xZ9miQmTT0tq4ZLCanIvRvXvWDocJIsyhAk8Uhg6zOkNOFnrjDSwPfDB+JrLcKS9qiI2UFhsOy+xHu/AoIP3e554MKJU6k2nlae8Qb/VgRfbQ2ZMZFpysZ2BVllNgzTJy8Gdo2K052Fc5atcxuQqUhm6dhxzowhGEucGg5cyeAbRMuOLzSD8ArYn7q8hbLb+ug8TElTxaENL0/DnTFwGxNx3hRvACVzxIuDN+6uNUaQh9BGnd5PofWVRsGwUCqTZcWihgbReNj+1Kuzb4mtqdl5iQPo3ufrngUtlxlck/hszv0XISjGEgV6LL00cmVfyai0+VXPEy/JqtFTSu4RjwZ7xDjSebvZzZwl1zoKgKpAbK5TeoQU3YCrHY2FBdq0iw9fW/vVHXchR7bFgG7hJts3CLe9TlWM9VEaeU12dfSmOjviCfUnxry7LG+lNbeM7pD1i9jsL8lI/sOYtemgAGpKSnM511yO5ldACZu7hWQ4jHkDz/h9mN7e0oUKHl8j+9y9PobWaej9M3FGvpw500XVY4PySkTQyN5XRd8e4uyyWnCkvmXZ+gtGfcwjr5lrBwFeAMRP2UlDWzGMgjcdpdH2zD7zhxVzS0NZ5L0SCJQpzk2Bbps0ZvcUXeDk8L6qTpDi29EC1HgKxYM3BOF1V/XFTfP8HXtk6mMy0xEl5qZCVrhCaTMCMYiY+oRkeYIWKg/zwPmD5rlP5HlpD
 tMJojfIS
 aIRUIW2JFom/yegs1LT2hJ42RkA8HmOz2w4mkRcdclIJHOOOyCxGQHZuo/Cl6km8iA1eFWQrG+CerTPSHUwpy2MnXJnY9xRWu43s0NYsPrSsOBxLFkd9qKdz3OgQen39A0w04C7gAE/lYPJuzEZU60xVqGM0J1V5CRV+geEVZOJno+KvBg0F0V19rpoxg0DgjZvenzuk9h/Knj5hGv3hDPJPoCDRGGxOUzgIMP2JL89K8cz6JWx20RkxBTCxVWYWJB98qbW7ZxG8cDvOrk/DZvQxYU98uUtAjo71zkayUuUYkEuQZpvAkezX8olfCKIKE80waF81qngR3bk1KCaYt/S2FeuF90Jj0RSDRVCofNF0YlENIbaNZ65XjhVfAKjRZE3rqzC2dAS5clxA0q2BTzantyzjP40dY3LjvZFsV3v3SJuvDuPbcAOlSsP+onHgeQWCYBvLABfpoJmBA6UjmIUZTl0TgGTRRgxR1d2FYwzkHMErX5ScyBmTM7KpzLkCMucBl45D56X1w3L38Eqh02Evc4iAWzZXRyakir5jt7LplmgjGTe9G7zscPTaOZrZQEBzN0FCcDeSleZE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 4:20=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
> From: Hao Jia <jiahao1@lixiang.com>
>
> When memory cgroup is disabled, mem_cgroup_iter() always returns NULL.
> Therefore, the global shrinker shrink_worker() always takes the !memcg
> branch. After MAX_RECLAIM_RETRIES empty walks, the worker simply gives up=
,
> so it fails to write back anything.
>
> Therefore, when memory cgroup is disabled, fall through with the !memcg
> branch and shrink the root memcg directly. Stop the loop once
> shrink_memcg() reports -ENOENT, since the root LRU is the only target and
> -ENOENT means it has been exhausted.
>
> Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
> Cc: stable@vger.kernel.org
> Reported-by: Yosry Ahmed <yosry@kernel.org>
> Closes: https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeL=
c=3DeyTPKPVQgX4g@mail.gmail.com
> Signed-off-by: Hao Jia <jiahao1@lixiang.com>

Ah good catch.



> ---
>  mm/zswap.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 761cd699e0a3..0f8f04f22888 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1356,7 +1356,12 @@ static void shrink_worker(struct work_struct *w)
>                 } while (memcg && !mem_cgroup_tryget_online(memcg));
>                 spin_unlock(&zswap_shrink_lock);
>
> -               if (!memcg) {
> +               /*
> +                * Reaching a NULL memcg means a full hierarchy pass comp=
leted.
> +                * Exclude the memcg-disabled case, where it is always NU=
LL, and
> +                * fall through to shrink the root LRU directly.
> +                */
> +               if (!memcg && !mem_cgroup_disabled()) {
>                         /*
>                          * Continue shrinking without incrementing failur=
es if
>                          * we found candidate memcgs in the last tree wal=
k.

nit: I wonder if we can just merge this comment with the new comment
you just added.

> @@ -1378,8 +1383,15 @@ static void shrink_worker(struct work_struct *w)
>                  * with pages in zswap. Skip this without incrementing at=
tempts
>                  * and failures.
>                  */
> -               if (ret =3D=3D -ENOENT)
> +               if (ret =3D=3D -ENOENT) {
> +                       /*
> +                        * With memcg disabled the root LRU is the only t=
arget, so
> +                        * we should abort if it has no writeback-candida=
te pages.
> +                        */
> +                       if (mem_cgroup_disabled())
> +                               break;

Hmm do we need to do this? Consider a system with cgroup enabled but
with just one cgroup (root?). The behavior would just be trying that
cgroup for MAX_RECLAIM_RETRIES failure attempts, correct?

In that case, we don't need to do this check, and we would get the
same behavior. The loop would terminate after MAX_RECLAIM_RETRIES :)

Could you fact-check me? :)

