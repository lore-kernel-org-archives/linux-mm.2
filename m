Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4131DC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254D76B00CD; Mon,  6 Jul 2026 10:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205316B00E2; Mon,  6 Jul 2026 10:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11CC76B00E3; Mon,  6 Jul 2026 10:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA46C6B00CD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:14:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C6F312037C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:14:05 +0000 (UTC)
X-FDA: 84958546050.30.87EB010
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7B996180003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:14:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jGI5RxHD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RCUbKkMVAqXLVkO6E18NiEWI8e2TIkxGzfCQs6g1ZKo=;
	b=K9Th9optIL9HhcN3+wnKZhJiYca5B/ZKMChh6dCAOwrvGjg8PmF/lO5LdmYeiv+etg1wmY
	Ume3Ei0VYebtaDMEqhllrq5hL2Pd4QXzvZAlOvh2mvoQxwGy8NqTIKdWChk3RupexBlim0
	ffWlfgRtRZi2Sg1nEMgjviGZJib5tc0=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jGI5RxHD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783347243;
	b=bAHXNxp/QH3k8fnE1LXll96J3rLi9vJFjG9TSBKd4OceJdOEy/S3PXCGA4t3P4gh5YH/13
	k3Tdi5XBhcG0JWIQLu9T3ORpgia7oRLyt51vtB3+oXbliHe0O3B6iZtx6OpLsBs7ukl3gf
	NwL3DvhDZdneHQNuVZQoLQ/wnrd+MDU=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-475cb71a4ebso3249972f8f.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 07:14:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783347242; cv=none;
        d=google.com; s=arc-20260327;
        b=BFJ4hhRbgc5GWWjw/xFgEQ0N0S0kNJI6Xt0EosGELW8QDw7kFFIwqQp2LjbcZ18Bsp
         3PxA9aoNaP086Ab2mwFSdNGIhEx1tHDt1ZeCv/Ti14gH9DaoDExrbUPh/ec40v9Yyw7P
         /j9kEBN+vqdRjDfHOp2CYd5PVaDp1iItwYCo5VBFkBMVQ8jpG+reQwaUPl14DWx9Hig1
         yjgP5eHNOLBYciJ6On1e5iP+ktTEYkCwHlAsXiQ5Yl7NkYqLXOn9VVk6EeTfArTcPw3h
         dYmiBRYmSSaU5uL5K1LQJw3TT5qBsDsF782vG/yofKas6+i97w/FPpxk7S31yajxUr/j
         6uuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RCUbKkMVAqXLVkO6E18NiEWI8e2TIkxGzfCQs6g1ZKo=;
        fh=5bx5GWB7Otbbbe6GD4dNj5vmwLZeMs7y8wdcY4btilE=;
        b=WUlSk4iDAgEEf+fHd4sC77VglFyc2VtpArI4RpJVs4wCSh2RlS2dDjM/sV6xd+NN7I
         aDrgIGo0tZh/K1fKHl+htobcMZdOeC7fyKuBtuiSduTw7XuXKJ3DrHhDQDgZICS1hZ/8
         ecDVU4TBT5VTPfIOLbIBsCffXpAF9VFa9cBIDh2yMICSrszadfdRXWBlD29B1oF880Hn
         0oaQlzhBsAMAvslana8Lamwj9A2QRFtFNtNpNBgvr5rls4/5u2W6iNBpcTyCY78ixAfN
         E9iog04faUammK/Hpfu8SirtlsxHlOTT2fHkxX8mQsEmJjau9AcOdOxNKCx5fqtj/8lf
         jP2g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783347242; x=1783952042; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RCUbKkMVAqXLVkO6E18NiEWI8e2TIkxGzfCQs6g1ZKo=;
        b=jGI5RxHD0YouniMLs9CU2yBSty1ndY1tTlYW5RPM3qoGVGUpyfWX6Lpuijac8uskFC
         emBLRjkku24gIDuqWEm2vvNdDKCWavtbrWlgvsoUO71iVocxUBkeWSYrEn8i1Smr4+va
         MBSoJQVETBptD5VJzDCo5NMUg2yTQ+koAKvCsBDbDWiddZyGS3htkzTcNVLVvO7C//K1
         HYoD8yHuxFiCtdAY5d0hnVaIfnRb47u+HennNUxyTxqL6lWnsr3I2DJ6Wxy3b13pt7m/
         p9ME6MJzIEtDI/X0AYnHma/QixizoOiSE9NbI6vi9pTLTeIuXA48asky/a8eMjEkvZZl
         ufVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783347242; x=1783952042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RCUbKkMVAqXLVkO6E18NiEWI8e2TIkxGzfCQs6g1ZKo=;
        b=s1+A8/3768MBYsKcIT8vMe8s/JJSCvG/sHOCAEAd+VDnFNOs+jlKv4YLgruUVdByXK
         vl3GpK8EoqtUb7Ovomw000KyY8I8zZTU6OEb3O8W8bJbpS5SI7uBc535S0Vy6kGN7Abs
         XvS93HgZz4mhT5JOH+3VbYBrJSn3+Axww/7Cq4XU/3Vbj5xj/EFQa2khOzy0wslQ23oM
         jnAYh6DyZ63YWGJ3Va+IE079x7BObPjHXYerGcmzo+JI5XpYek8a7MW6rZalU+6CDz8O
         PKdMM4UJPzcW31yhhcWBuH+S9/D1jA66iZpIlbhhYgYGUJK8kVLpgyslo4bI8kEg2Fj+
         HI8Q==
X-Forwarded-Encrypted: i=1; AHgh+Rp33B34xhzowG7RWg5hAwwquKDW4RZCMoM2gq50cDMQZp5zFxb8YUCKOw9EFmtMViuxT48MPbleHA==@kvack.org
X-Gm-Message-State: AOJu0Yye1+VMYMSpZKSrl/NkwEcgPIzDKwou66b/Y4jxePz5pmNI7irn
	mWRcRZ5724HlgOBrK1gooit9VNWrmal6uAbqkKX8rbQasOmd3VXfLp1J2yyPdIh/rE3Jzyz4u3t
	tw/WhYHFrRVx9fYGO3T4qv1rjOWPpbFY=
X-Gm-Gg: AfdE7cmk8GzN7P3shkEeoOA448u7i8aGxQSJErWqI8OZy85rSED34LGcoguezquI9Hh
	deHHA1eOj2f+moejRZiVX4lDLXJEaTHMO/kd1UwwjEw9HdV4csf7VkidftPzUItvl0sbjy5+S2W
	TlJQcPFK+rjcm+M56tcdIs4nxejc0eiD6HI63KiQL1Lybz+//1cQbAb5Nv3geeQ9KaousdUER3z
	rG9ZCqcCMViFPsU4ITOMcVOvoP8uuVFapTclUOuwkQvCgrHnERFWkV+BkQcCiEYHvpE+tvQ47zc
	K8Xdfc8kCS0+GTAq8t1hkghf1vGDW5s=
X-Received: by 2002:a05:600c:5309:b0:490:d38c:7836 with SMTP id
 5b1f17b1804b1-493df082feemr8853095e9.3.1783347241905; Mon, 06 Jul 2026
 07:14:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260704092007.3483-1-igorpetindev@gmail.com> <20260704092007.3483-4-igorpetindev@gmail.com>
In-Reply-To: <20260704092007.3483-4-igorpetindev@gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Mon, 6 Jul 2026 16:13:50 +0200
X-Gm-Features: AVVi8CfSo_a33Q1WdaWqLuVo2tcFB5VpUhYoEy9ZG3mJd9mF_je-FZgLimqail8
Message-ID: <CA+fCnZc2VOghj5b4Tjkz4MditvVORnAK0FRs51=i4+ZmDqsbng@mail.gmail.com>
Subject: Re: [PATCH 3/3] kasan: common: replace magic number with KASAN_TAG_KERNEL
To: Igor Putko <igorpetindev@gmail.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com, 
	vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7B996180003
X-Stat-Signature: h4gzk999u6dhksskardbsaaiycr1gyxw
X-HE-Tag: 1783347243-286812
X-HE-Meta: U2FsdGVkX1+Vki0dJ9f73s8jPcLgIfDWJ1++UvFrL3c0h+UwZywe0zVXlfTPlmKFEtqSshHC0BwahOvmWQrjE4XatHyPruNGFrr3hiVfGUVVbpojPqcdic8fSkfrkpZ449xB68LcAsJ6EusbyNfzDkImHc03q1/4qY3AQi6wZl8HlKeLAV9a/SMn+M61yK+ZYt9nQMcMLva7QN2iiVJWv/Ur1NUUWUfFt/svpu3mTIBXse9w5a8mNJILFjRtmm0hVE7ZaKDkeC1HwyYn6CNikD5xpbyW2sBf6zSQGQvPuqxMsWftyVGe5BWHDpEaT2+GzRs8hNwlwit/jae46yXEHUrU34iiwJkVUilz2EV6HJWZJwoYMx1Guz6XsSp0yVQhpjL0KJuDCRQiQQsZ1JrkFYCjiJw90A9ZjDirJEe5Q8RCuG/Vxs5Vex4ASBj0BZGX9kEocranzC4lOMbBYZMBFsuSEPIBut8655ejjGkaaUHeY/97nrKNZNC/lF/Xg4Yzam2RjmZTAMvhjHsGPmrp15Z1zD33hWGe2oz9CMRPIsWYQfmoEQvK0C8SRhDx8hUR8T+7ugeWFBjRXK37iYn75NPwdQs3RnCFQ5RA3iELxBSAUIgekCe5ko/rZpxK1KCmcx/tbhEBWk+k/1kzpiOtX547EYwGEKjLtlQFtgy4MiYLxoXAeCkqi71/1L9Y5zQ+r0Bi900WKs50tasvOeDijEBf4mEX/bgjPD/XCJU3IpSTTswE1ajaIN6vVzZCc2zM5a9vbVGhk4IaEAyj2IGpieSkxdCAyhX63uhNjz4gR7kqnLwZH44duV7bMf8mHa3lJCbkzx7+pXoTxv9LNVOmEpRHWFX0Azdc1Powh8rJhUymwlzH6Hj4xSahmgqK5E0MIRfKVbZwVUtMbsj752Z7E27mgICo7U+Lb4cy3DUw2Oi1YJMQCC+mCK5UuGzhGCp1ITU6koffgBV6KP1mPl2
 rkOGNdJz
 9M7NkdNxNsNpVM8cXJgx/W/oWpmyAbsAvSGMWlH2UQuuT8mOji9LmNR5GarJP0tjHNIja/UG9gtDbJRkHmjiA+N0mvO2gbvi2wLCJ1HZb4oHCfi903nspyeFgr5CXU0m7bTMgopCLjeZJkp3OAQxEkS+VrGukybhzunRpMyYrg/Sx5wu7HUrXL3f1Nrkd1ZUY91T/IeYvPwNT7tNC9vNHrakzGuV/1Q4fa8tnavKJ0ZdHHV5y0n0vzaoXDFR6HsegaT/xbaR+QJRqD+44RUVyPyt2wq2DK4Ybf0GdrLB7wZ3A2zQaPUSBcQcjmbhmlWWkKL/N+p3apCgpL4zCS+pq/Qw0rKEr2YdImONtl8MUVCRML69c2KUqZJ5vHJIhfDOuVI5LlhAY4MsPyAYMyCyWffIFGJ2HEHSd/MHYs6UJw9Uqdnu92TGS8F3Dt4MF1zfMFOx0SgX9zw0lTcMxlcjWSBHmc4W5RpUBbVWz8YQHKmapJYIZVyDWDM4+X4Py8jySGELWd+pbt4GOA0PHAbMNotFyFBB51lwNlVcD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 4, 2026 at 11:20=E2=80=AFAM Igor Putko <igorpetindev@gmail.com>=
 wrote:
>
> Replace the literal 0xff in assign_tag()
> with KASAN_TAG_KERNEL to eliminate the
> magic number and improve code clarity.
>
> Signed-off-by: Igor Putko <igorpetindev@gmail.com>
> ---
>  mm/kasan/common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index 5faf73c8f..3e9b6b8f5 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -188,7 +188,7 @@ static inline u8 assign_tag(struct kmem_cache *cache,
>                                         const void *object, bool init)
>  {
>         if (IS_ENABLED(CONFIG_KASAN_GENERIC))
> -               return 0xff;
> +               return KASAN_TAG_KERNEL;

Not sure about this change either: the notion of a tag does no apply
to the Generic mode, so the code uses 0xff in such cases (the second
definition of page_kasan_tag() is another case).



>
>         /*
>          * If the cache neither has a constructor nor has SLAB_TYPESAFE_B=
Y_RCU
> --
> 2.47.3
>

