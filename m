Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6536BEE6429
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 10:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEDE46B0089; Wed, 31 Dec 2025 05:57:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDEEE6B008A; Wed, 31 Dec 2025 05:57:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1FE6B008C; Wed, 31 Dec 2025 05:57:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AD1E16B0089
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 05:57:44 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 492A21A78A6
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 10:57:44 +0000 (UTC)
X-FDA: 84279465648.12.C15B1FD
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id 55AED120008
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 10:57:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RhFQaX0x;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767178662; a=rsa-sha256;
	cv=none;
	b=6MhzZuuH5ZCnLwwM97fNzeqOKYDc5dRnMVsEdpmbCnDf+IV0sY6INXuUCMzggBKu/waKkw
	xTRam5uN8PI3z9rBk26E3Yc5eTGZhSgJLsoiEF1HUuDd4sV1jrKb/PXm8kKTUmsubfRTpa
	ldSqUfFqH+QXAS+p6iFVNcMkXhYN/OQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RhFQaX0x;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767178662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzBXNYJlsNN07KPlxWLMxM6xd+nL0NGSkMU6WRRV6Nw=;
	b=Ts9hLOuYKYkgZGAPJtQmYLRVxVQIAiUMgJT1uM4i1zlUz/1gy11C5tYD/LpPksRUd6moHK
	6t99nQAccqt7FzxCkPeoiFGTiv+2lhaAlHXfFh2Xle28IuMf8FGylxL+qOFYh3bdJfsbp7
	S5tnY433nO/SvH9AXGpmQVDhOcpr5L8=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-595819064cdso16961305e87.0
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 02:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767178660; x=1767783460; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OzBXNYJlsNN07KPlxWLMxM6xd+nL0NGSkMU6WRRV6Nw=;
        b=RhFQaX0xQJ5t/Z41FmppqOsQ85Q3xnFdGZ/R6X3j8BhOarbKuHCpuKCKzPRaNO+afv
         kWyD1Mfy561Yg/xoOslGiFobqd+sRWb0f9GdeIjyk1HsOsSo0QhPEU/uXyBRW1RBq/3A
         S5bTc+vIfCmE94DSOyXxgt7A5UtuywwgDjclKvf7sho0rz1SSK4E+XNdDtYSKr9Ypalj
         F7ssRHvQbq7goM7/BTOlsJ3P8Lhcqt6rMbiaXa8Iv4M/zV+Aw4mKiS+ibmaax6XFvNWd
         LJ5wv7Zj7nQwz2vkq6yugD+msNX4dqP6JVlKOtEfZxso9yhtf9JEKYb2krEt4kfJifnE
         ys/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767178660; x=1767783460;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OzBXNYJlsNN07KPlxWLMxM6xd+nL0NGSkMU6WRRV6Nw=;
        b=cPKRHnBHyUi3aQPZFnySytJRKLt3dEPCNn/JBmY/gl6dhKEoRqVUqTMmQwNrukZkMZ
         Bz7LQHqsphRym7VNhcGKsakz9V4URsISTMAr3KADkll/MmV4DTND4NE05jk6CphC8Ppj
         xy5Bs3hmBsQclYiXTlvo2H6ArwHEeJMz2qPCF51ju723fBUyb8L4hu5jpDi/IzMt8qd2
         MSapttv1Xox4tqdJtgAv7L4DaEV4IWZPnP9lOS2RfXwdyIqoHqVhFfq0ceCS13eeO1V5
         jQTeAueLKDwsWvi+HS3coSFWE4pUGj9FxZuXLwFbug1LyKEssQ2ssmUinS+zQl/09O7/
         4q/A==
X-Forwarded-Encrypted: i=1; AJvYcCUeyrmDP+/30ikgoE1H6HfRcyfpk7AL4rU4GvYHm3MeRr/SnFCPdqNDr0I2mVS4RA1OrI6lzGKozg==@kvack.org
X-Gm-Message-State: AOJu0YzMrE5p+QgW+BsdAQ2N8ZhD5YtRUat4ochA3Jcpp9eyR68EJVjz
	prlZegxgpQvQBsFXhXNG8IW/6r4M+Afj/8CD+VdJmk5NDrHZfhxZyTRFJWyM0UXIAVBilftI+ZB
	EhlgoeJ39rP1ELTN+TLOkx4k1Uef0wYY=
X-Gm-Gg: AY/fxX4BmsreRzdWOCOMHboc/1zNhw1VSTPxca6P5LBNlpQ7wrze/yy1lyVwBnX1Ifb
	op+yjKs7HYqnq6uxQlTT4rGtEriS4qcLYRhOM9zI5i6jL2WqQ0EKGN6e42YnmVR3GHnsqc22vQQ
	omc3J+O8XH9CZqmRKN/o2g8b8U2UFNUPJzNereyBbVPaweTMCk5+71U3UnxTYs880iLLGO9jOUl
	ECpovl8VxUmBnh4Cr1nx1ct0I0UeO1vu38OYi3NV0/7RQZZ8Pgld9w2PhCbEU4KqIB0zi6p5rH7
	12uI6PM=
X-Google-Smtp-Source: AGHT+IGFvAsHY/1WC+nVZNJJBlIt+WIC1IjpIdxPoYdAkw9fVZDWp2nGFIJMvuKmGOEgqX/2Rrjx3WTfpDtQRexD1kk=
X-Received: by 2002:a05:6512:114e:b0:59b:420f:95dc with SMTP id
 2adb3069b0e04-59b420fa5b0mr3032828e87.18.1767178660154; Wed, 31 Dec 2025
 02:57:40 -0800 (PST)
MIME-Version: 1.0
References: <20251229055151.54887-1-yanglincheng@kylinos.cn>
 <20251229055151.54887-5-yanglincheng@kylinos.cn> <f47b6192-2115-4f4b-82ae-dd66e65f4340@kernel.org>
In-Reply-To: <f47b6192-2115-4f4b-82ae-dd66e65f4340@kernel.org>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Wed, 31 Dec 2025 18:57:28 +0800
X-Gm-Features: AQt7F2qPxdn0q4B-lcjNsZvsrrV3SBQEMqOanYCatn5Or4aXcyFItoQ5-8mOH5s
Message-ID: <CACZaFFOvDad09MUopairAoAjZG6X5gffMaQbnfy0sCHGz8xSfg@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] mm: khugepaged: set to next mm direct when mm has MMF_DISABLE_THP_COMPLETELY
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	richard.weiyang@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 55AED120008
X-Stat-Signature: ok4fq59pqdts4q4x54ku9gy3zdj7yo1h
X-Rspam-User: 
X-HE-Tag: 1767178662-88368
X-HE-Meta: U2FsdGVkX19HZ5/O6lQckYVIsDlPgx3jdss1ZNkpxWtg8qn+chwblyZkAoS83EmpdSyzss7ZrHe7jjAlcCUOOW7gAGlGySRgz2jObxZWIudcjsPmzhNryWMOpNAXpZWr59B4FJheit+zQ5rGc7V0RjjF4P85rtemDP8F7jvc6WWWOe5d61WcdoiGy1RkfNJcM+JIlMXyTLiFJoe0twDBYSF1RrumEL734hHfisPvuET7C5hrRbtYz4QUwIZ7t1EsOih1I1qwJxxnkPboCIPqEulLafFtg7tf5V1eYBRAdIKD05WpEr3Gc3VcetztWG0SLAb2fFncqvmcSb9mQxjf64JGA0RzZIHYvvD+S8SNngFkmh2gjhuRLr3gC+pIwveg7Ol85pNAPx8YooAk2e3xY3K47UzEdtOne2WkWGJeORK4AlOrsKBe5IiXIbhAbn05GP3qP+lQTW6EPsHT2HmUgbgpUiy2eNYanZBleKoyV6N28Wmk0cPV/2Sytnk14em41IPhy95ahZefeuv6txrPjW9M7/BhpPZsFHCoO/3ilMqbTJtArObnQ11hNPGcroP5zTHAN/QNvP9ADAsMtxbDCDwiq93tfjoZ10Dript+D/N+/7Zc6d4JFDh370KtS5bHQLzmlQZqrxIdkUtGSaV+/32JfocEEGdiwSYtvsM4xRXAsO41uXfPGzhNYyQWGdL6Gd3cKCNz0vj1LGKpOq7+1kbqStEux//Ys7czUhKow61WeXimx9jIMnZBm0bRRV9jG8DzeO+00FGlHYOeiNTD1K8jBzevKeNKQM+VjBKrSn7XxGOhavT80q2kgVVWRbpMRl6a+Y7TfTjXpVxFsxrK9T+p8p82n3nSTypgrwr/82XT2Z4BjRd/mNmrnBpun9i8lZpzR8Fqq+/sZJgq2j/1JtDgI+9vatAquYrb3WpBDMpjJ/+5pkkkOB/S3psMq2telI+XC1tlqsUgmsBrR4m
 /yS0Za5B
 8J44cB+DsO48LiH1T+O+YGLZDyk44WsDneNw/Hn4WevTvH2ii6/UQ/FME+6JMmGkDsl4IKXRKGvPdU6z7N4nmAEA4vcu8JPoPw/6MPKzWC2ANdREdbO2KqljkjgtCiNiJVSCwbOKUQwCrG12mhj6aJ6jxETv1BQqTg/vHQylKuWAV5uaJKBJPzaDn1+Vn8Q1FVLEXM36AQjXEkzmFjnVwe3+zDTUJfIowA2rO28COSDJVN/jwcgUzasd4hgMLaH6d6bw2f4veDOwN+mz0cVqYkW2w60F9QZ2IAFC0GCag/mKEmFbyynbCoGYSnBJsdn91+Lj8vG4dXKnTSSz2JfwWekrisc0ogymZdkS1Aackl68edPX6DIg8/86jV8QsKyhnnZcSRQ55CLjVAy49hORZDY4O8fi0hHJJQD9SSIu0NugXNsmvRbf2Bl6kEyDTK8oELXxCvYL/CUTB5fE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 31, 2025 at 4:03=E2=80=AFAM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 12/29/25 06:51, Vernon Yang wrote:
> > When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
> > scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
> > reduce redundant operation.
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >   mm/khugepaged.c | 9 +++++++--
> >   1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 2b3685b195f5..72be87ef384b 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2439,6 +2439,7 @@ static unsigned int khugepaged_scan_mm_slot(unsig=
ned int pages, int *result,
> >
> >               cond_resched();
> >               if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
> > +                     vma =3D NULL;
> >                       progress++;
> >                       break;
> >               }
>
> I don't understand why we need changes at all.
>
> The code is
>
>         mm =3D slot->mm;
>         /*
>          * Don't wait for semaphore (to avoid long wait times).  Just mov=
e to
>          * the next mm on the list.
>          */
>         vma =3D NULL;
>         if (unlikely(!mmap_read_trylock(mm)))
>                 goto breakouterloop_mmap_lock;
>
>         progress++;
>         if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
>                 goto breakouterloop;
>
>         ...
>
> So we'll go straight to breakouterloop with vma=3DNULL.
>
> Do you want to optimize for skipping the MM if the flag gets toggled
> while we are scanning that MM?

Yes

> Is that really something we should be worrying about?

Just reduce redundant operation.

Before optimizing, entering khugepaged_scan_mm_slot() next time, vma =3D NU=
LL,
we will set khugepaged_scan.mm_slot to the next mm_slot.
After optimizing, we will directly set khugepaged_scan.mm_slot to the next
mm_slot.

> Also, why can't we simply do a
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 97d1b2824386f..af8481d4b0f4e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2516,7 +2516,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigne=
d int pages, int *result,
>           * Release the current mm_slot if this mm is about to die, or
>           * if we scanned all vmas of this mm.
>           */
> -       if (hpage_collapse_test_exit(mm) || !vma) {
> +       if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
>                  /*
>                   * Make sure that if mm_users is reaching zero while
>                   * khugepaged runs here, khugepaged_exit will find
>

Sound goods to me. Thank you for your review and suggestion, I will do it i=
n
the next version.

--
Thanks,
Vernon

