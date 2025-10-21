Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B462ECCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 17:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19F7B8E0010; Tue, 21 Oct 2025 13:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 177038E0002; Tue, 21 Oct 2025 13:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08D968E0010; Tue, 21 Oct 2025 13:42:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA35C8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 13:42:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BFBC14868B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:42:48 +0000 (UTC)
X-FDA: 84022841616.03.58AAFAB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 450B220005
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:42:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B7pOF8pE;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761068566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HKohHX5PQdAgp4BuzOw5sJB5TQe1jmIOtleJ46IHraQ=;
	b=elgb+JZtVJG91Zd3D0jhXN6F8yHrpQRojp/uxrfY7aJkaoIQgwYx/tjnKRLJVecbZKQ758
	tkHhCrbKXjY6pBIC6YTpjo8JW0ykZpzIkvB7tOqe46N7eajb+UqEAfgkIwf1fU3W8ewwKu
	50yttWDd07Cpy2aWXfPbxuRBmXDKTbY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761068566; a=rsa-sha256;
	cv=none;
	b=arM9TFfe9Oyy3228eC3uZXluTW3ZpqGSkgpwrck86RupHn9WyaPCm89XHSTxFF1NgQT5dK
	3mPDS00G6eCXkFGrlC/T+0mrtdM8qwuMpWJDAcShoGZyj84GZa5q/VOaSjhRCoNztMsqXG
	QHwGzbdQGFNjoAcSLXxdt1lKJvC7OsE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B7pOF8pE;
	spf=pass (imf03.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761068565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HKohHX5PQdAgp4BuzOw5sJB5TQe1jmIOtleJ46IHraQ=;
	b=B7pOF8pEEHWPUVvAP5nkrjowckIrvsF0pOZaDwUKAnayuhD8QUjcnG3GbvtBfFdhhKQ00Y
	vGAVH2C/QsRHBJLdsYKr9llUPV+svUYY8DyZUzlKQGoXAKhB+xv/OnkKBnDgMLv1Ly4aWi
	N+43Hgxu+gYtJEodJ2RA0YgbOk6B+Bk=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-oXiRLWj7NQW1BztAd_Y-kg-1; Tue, 21 Oct 2025 13:42:44 -0400
X-MC-Unique: oXiRLWj7NQW1BztAd_Y-kg-1
X-Mimecast-MFC-AGG-ID: oXiRLWj7NQW1BztAd_Y-kg_1761068563
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-780d2956a2fso72379167b3.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:42:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761068563; x=1761673363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HKohHX5PQdAgp4BuzOw5sJB5TQe1jmIOtleJ46IHraQ=;
        b=ihTnLCf6bolNulTdKiGPIDozhXWlRdSgHBNVJKcvzeLp/raNFEo9OjHzTrMjl7HKvZ
         ocMoF/OuhZHIt23y3iXI6RCJlCSy2Ptx487A7jPozTglrolggbLxT3qC+Ovvf/XVZLo6
         0Hx/njikYb7ld3VYcwyAH7wYSfhMlb14od/BwxuZRbeXjcVRMFxTOS7SCilIKGClyGDC
         M6qyyWlKoo9ASqa/654OWhbhE2W1zV8PfXWp8s/jkPMV3JVMQxApUr7e1mObzWpJqkEa
         bnyDXbOujY6S7hG2V31pNZzzwfLXYpWBukbbox/SGy1h34ytRY6bcAo3Eebc0dBfS2Zo
         187Q==
X-Forwarded-Encrypted: i=1; AJvYcCUwIx1KK0pQJf0fYG9kuAxvayhenUlAYX79gACXplvMmHPxxm2CU0b4ga3l1ZSBUPcw5nBDSg24Eg==@kvack.org
X-Gm-Message-State: AOJu0Yx/PCF0xUwvR/kwvDEPrIlZaN8haVhfRMsoNvjCIWg7y3yy3kkE
	Y3mOK0aMYwK1afPAshdCm2x7+1Fvt8IlrYHrLZfxKlUvEBYMviZjzCRFCeDD+ZntNs7tH4OmvlD
	OxsYXsIyhiRUHK9GbUJpHQ14v+pMwcxPKCxulOdKA3UY5LBkay0gOwFU9E6b+B/YIC/B+xLStF+
	n9DNR8GlPYFE/h4E0dW0Mxnm/dbUU=
X-Gm-Gg: ASbGncuCHny4UpT2zOlY1/qGNOQN5Zg6o43lLsVsft1bgumW0PuUKqwj2/9+2iTUX5S
	U/24LyquTCZSQLFPlK1VSxDQN710LDP0pdvpvCBFZw0DjyfD9TrBGV7VABFIHBridzHRwTO/uDl
	RuR5RfZPt1g/1n0clK5ylauav3QGH1nAZhwd4/9FovNiFTMM1C4CcxGRp+NtQsYUTlf/Ra9w==
X-Received: by 2002:a05:690e:118e:b0:63e:27cf:8350 with SMTP id 956f58d0204a3-63e27cf848bmr9752786d50.51.1761068563413;
        Tue, 21 Oct 2025 10:42:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPeGWBwa5Vswr2rx8OIJkKxxwANwfGdn0lP1anQB7PC3Rr8+J3MWt2Uu35saaXOFAM5Burzjh2O4us/ANDTeA=
X-Received: by 2002:a05:690e:118e:b0:63e:27cf:8350 with SMTP id
 956f58d0204a3-63e27cf848bmr9752759d50.51.1761068562975; Tue, 21 Oct 2025
 10:42:42 -0700 (PDT)
MIME-Version: 1.0
References: <20251021134431.26488-1-leon.hwang@linux.dev>
In-Reply-To: <20251021134431.26488-1-leon.hwang@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Tue, 21 Oct 2025 11:42:16 -0600
X-Gm-Features: AS18NWAATySbKWIjDNiNWbHZ1s7hUwaBcjhshia5Gj7faitPCJK3Mblb9Kitkrc
Message-ID: <CAA1CXcAgjZ2o44ifY_Ay9MjgGT6q0vfrRBy=vxyecH68YcMYtQ@mail.gmail.com>
Subject: Re: [PATCH mm-new v2] mm/khugepaged: Factor out common logic in [scan,alloc]_sleep_millisecs_store()
To: Leon Hwang <leon.hwang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oybPlLs76GRY3W2GW7gVJ4lSESdrepvsUJyOQqwn48M_1761068563
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: 1rdosadro3robn6kkf5e1j51nzosirgo
X-Rspam-User: 
X-Rspamd-Queue-Id: 450B220005
X-HE-Tag: 1761068566-583091
X-HE-Meta: U2FsdGVkX18Ozw/nba9QtCSadM/KeEOg0zPHX8tjAE6AUtklGiGhna+THlYlmbWbqE8nNkh4d7EJ74VVQfUNdJHaABJJI2Xnd+U7zJZkcQJy5yIJMHc7CpJywd7lliXxU/Kj6gmkzjEt+ly0IGecup9MCL8E8NG08L3xiBdQTNIR0WmJrpyLB52FwQyiDgGbpkufG2rEnLY2cdqoayM3VopuIQrEIvFEpzcTHE//nFDvv/m7/2ZTARVayhW7vFEwQ8BvSfJrNl5scrJiqDKZ1DD9i+LlLbzNJADGkWT4JoD3CheX8OBaroNnqUzSS6ml3TWHDa7Mi/8pGwx0/asDaGwEFFV7TNNWqoADvYaFsBAdoodCMIYfEwgdGDo03B7PjAHmIZPxHULEUf5LrdR+zrdY62ewN4DnqreZJWYZvHAjFT22TtirgcoOoCtz17YvyCNubO0R9AsBkF0XxjH0f/ZL4rrplVq02M3icBLoqk2wbJ/zczgVMNCb7MGXnBux/K+2vGPTCrGGA9mUScqZo8he6ulr8QQV51O3BOHUTCrTtE8k9KUn2y1e7Q4Le0bGHbK16jgJ7pEcWmRXVfYtv0mxT9mJ1/C0WcvVzEqkNpKmk+U0sPbEieNlV5l1cPYPCytqMyakChRKewDH7x5M3FES3Jnf+rLdvG3wO5Uz0tTN8Meeg2u9TKh6Ox1j9gCYOR7G3vONQxtbiM+J6zYHN5X2gmKe4ppuaFXSFkzhT/2ImNSPttGq8Iw39WdG6wBptcYj6khhx2qNTJDga1wDHKfZFdN46AHhnJxyp7OjR6FZsOhzpgxBHJp8CMzxW1xzP5dHX7SHFJ8RTjXrGogxfRWvZA8CwxecaW7dz+zVMYhcJqieoVKh6lK+EnbL1Z2d7SAOy38WukQwxywrY9+a9AQIPCxrvrlXqZ+7LPaI219YqmrCZh0q7hEv1Vj/lrWTkL21n16slcnjIkJpOtb
 iCGcB49k
 SWSRx86D3yhD7s8Ig7um3XVBN2wHJ3yl3ChVJEDmHww9pVtn+7J3uVI+s+ThVLOm6a61iVwX7FCzUngmxeMgn+WA9/TYo2Wrue17z99r/711PK0xU3C+1wrSqMNTuMfRJuDwbEuj8XDspqqTn+5IAlQT+wAnm6pkky/7jiaFFpqwxCyzbbhrY0elVem6qq46bcxJ1Gb1kBjvAP6Zhd73VUjsykxTyOVUkYL5zzNAyrfZjprcQ+x29MI8x9oWY+rsW6KMaqDHBiXKgNLHksCTGO61aK+4ohHv9rIfdHTiQJqwAQwsunGUvkZoRS37lwmIR819B3lMCAbkAisCHkOtXTjha7R7auGdZjKfCHuvdk/0AELO4vz8u3t5sxJFJMUWmQyhPlEWUxPNe1U4BxQHz2QMHfGHpMJRfLh7VEbFMr/9sRXd1RZy6h01TTALklG1iRIdHkGsgyzJMflhyh0KRA824sT4n3muzThUPO467ypHOj0fTLRtqDAFetNHuT4kLJdLH30VBoyY5zt0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 7:45=E2=80=AFAM Leon Hwang <leon.hwang@linux.dev> w=
rote:
>
> Both scan_sleep_millisecs_store() and alloc_sleep_millisecs_store()
> perform the same operations: parse the input value, update their
> respective sleep interval, reset khugepaged_sleep_expire, and wake up
> the khugepaged thread.
>
> Factor out this duplicated logic into a helper function
> __sleep_millisecs_store(), and simplify both store functions.
>
> No functional change intended.
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>

Nice cleanup!

Acked-by: Nico Pache <npache@redhat.com>

> ---
> v1 -> v2:
>   - Simplify callsites of __sleep_millisecs_store() (per Lorenzo).
>   - Collect Reviewed-by from Lorenzo, Zi and Lance - thanks!
>   - https://lore.kernel.org/linux-mm/20251020115350.8175-1-leon.hwang@lin=
ux.dev/
>
>  mm/khugepaged.c | 27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 6f2ae2238b5b..5b7276bc14b1 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -129,9 +129,8 @@ static ssize_t scan_sleep_millisecs_show(struct kobje=
ct *kobj,
>         return sysfs_emit(buf, "%u\n", khugepaged_scan_sleep_millisecs);
>  }
>
> -static ssize_t scan_sleep_millisecs_store(struct kobject *kobj,
> -                                         struct kobj_attribute *attr,
> -                                         const char *buf, size_t count)
> +static ssize_t __sleep_millisecs_store(const char *buf, size_t count,
> +                                      unsigned int *millisecs)
>  {
>         unsigned int msecs;
>         int err;
> @@ -140,12 +139,19 @@ static ssize_t scan_sleep_millisecs_store(struct ko=
bject *kobj,
>         if (err)
>                 return -EINVAL;
>
> -       khugepaged_scan_sleep_millisecs =3D msecs;
> +       *millisecs =3D msecs;
>         khugepaged_sleep_expire =3D 0;
>         wake_up_interruptible(&khugepaged_wait);
>
>         return count;
>  }
> +
> +static ssize_t scan_sleep_millisecs_store(struct kobject *kobj,
> +                                         struct kobj_attribute *attr,
> +                                         const char *buf, size_t count)
> +{
> +       return __sleep_millisecs_store(buf, count, &khugepaged_scan_sleep=
_millisecs);
> +}
>  static struct kobj_attribute scan_sleep_millisecs_attr =3D
>         __ATTR_RW(scan_sleep_millisecs);
>
> @@ -160,18 +166,7 @@ static ssize_t alloc_sleep_millisecs_store(struct ko=
bject *kobj,
>                                            struct kobj_attribute *attr,
>                                            const char *buf, size_t count)
>  {
> -       unsigned int msecs;
> -       int err;
> -
> -       err =3D kstrtouint(buf, 10, &msecs);
> -       if (err)
> -               return -EINVAL;
> -
> -       khugepaged_alloc_sleep_millisecs =3D msecs;
> -       khugepaged_sleep_expire =3D 0;
> -       wake_up_interruptible(&khugepaged_wait);
> -
> -       return count;
> +       return __sleep_millisecs_store(buf, count, &khugepaged_alloc_slee=
p_millisecs);
>  }
>  static struct kobj_attribute alloc_sleep_millisecs_attr =3D
>         __ATTR_RW(alloc_sleep_millisecs);
> --
> 2.51.0
>


