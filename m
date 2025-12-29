Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3B69E8FDB1
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 11:37:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8676B0088; Mon, 29 Dec 2025 06:37:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076366B0089; Mon, 29 Dec 2025 06:37:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBAF56B008A; Mon, 29 Dec 2025 06:37:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7C4F6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 06:37:49 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 701925EBAB
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 11:37:49 +0000 (UTC)
X-FDA: 84272309058.29.5F9BE40
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8577EC0002
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 11:37:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bBWKpa0g;
	spf=pass (imf28.hostedemail.com: domain of wale.zhang.ftd@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=wale.zhang.ftd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767008267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tHf9A8IyrdIqhEIS7lJbGAwWx1jMlHSEw9No5iwebr0=;
	b=yavWHYtSs3NN4BJbSOH813Y/M68cUV4O+e9XijOe5SRyPyWBqBf3o2Dga7KzfnbtrNSo8B
	GV13kc9ZCy31xDtp6aRCcjvuX6tMq5d/+CSlXkK+PUHNO8/NXVqKMQ5f2DdZuvb7CzZrF8
	nTJ6v5KoFVUQ5QjzwCbqI3hqUHpkZuc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bBWKpa0g;
	spf=pass (imf28.hostedemail.com: domain of wale.zhang.ftd@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=wale.zhang.ftd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767008267; a=rsa-sha256;
	cv=none;
	b=8LrhX54Fel9i+xnn0X7lru4QCxH2dlJAvJ1GCF4kuskLoprYvvhw60WrZcPVyPAElxykXk
	Tiawxmm3GumD+Umaa3jacmyMCJdaYUFCbkeATG3WfANomvsYo8Q/R1zrKredBgfm/coLOQ
	EUeo4YDJEMw6N/hnlkTZyhmW3m9huus=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b736ffc531fso1629094866b.1
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 03:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767008266; x=1767613066; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tHf9A8IyrdIqhEIS7lJbGAwWx1jMlHSEw9No5iwebr0=;
        b=bBWKpa0g6RH0kZ/5QfguvXssHpX32mk8mKJNjqIx9YUyHH3I5dysEvXiyZERm71yIE
         XZEW16QFc3M8n0aM6Sgg5TNLFratYT0bbMOIkSOcqMTD8QOw3xaKP5psTVFonrcuUdSQ
         mmx0r1aHAstPZpSH+UOCkJnSXGr3wcxly1me2tvStkcscS3y1bJ30sVud7r6hnf3CRpr
         LLdCRpBphHPlGywzidHIzq3NwOV3V6H3jjSOlfzXxDsFg1JH9Ie/3KgQhZtUd7pvEf/Q
         kTBYzBfjLbrMOb0f4EvCfCTbJHB09Hq3FaVsKFLg8M9RPD1+4nzy0tl69Yi7CJTKYqf/
         4qwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767008266; x=1767613066;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tHf9A8IyrdIqhEIS7lJbGAwWx1jMlHSEw9No5iwebr0=;
        b=lbZpyWAPTNujiY/o9EHWWSag5TiK4rPL9ZK9UXfYnWbnla+4Z2tDo46pQySDvqVhaM
         kA3faoqDcBRmmhtWVirkiApjs86sZrO/zLX6RFDOswzgMj/YhhfUxGhFywdFgtAhL9LT
         KYIwhSs8LpeJw9BV7/sYX6pwzfEHMEMzcnQpwSwyAExtjVR+TK9DqgG/qi269Hz2P8xV
         SS0dBLu12wSjPmSK4qyxbYGEHO+y6tWW4GV1E9zsiwPTr0sWisHjgZUJxn5j3G4jZO/m
         Mme5RyQxu5MJJLZK+84jj8d0WqrhidDQLN8+mlWsJ1LmXCo3sVySoSZIKpv9PPSoo8+h
         osXA==
X-Forwarded-Encrypted: i=1; AJvYcCWWV0kWVG5LZ6FURc7ZZXvsucvUYmn9LtCXD29p0tKiDNuDstnHS+wp/VDHrRQEi6Nlph/Cnvj5sA==@kvack.org
X-Gm-Message-State: AOJu0YwTW7opsmMfieS6yPnb6qpzfu4lchs91i66SSPSVmS4DMw15l1H
	ZPkedcOkksp62FvlbKLtlL4qHsFxc3XfUsvxrtDaLCiisvi8U3k4KN613vkE2qIlvkC1y7plZt1
	4NY7w8Itp7QBi//RdhFIAdQVGC7jzT7s=
X-Gm-Gg: AY/fxX5N6nTD1kCavOBhJM8UcjN9Y/u1y3UhoJeeaLJT2M0Paucd+710EnHUkX+zNo3
	9ulkL8P240FQhDJy8DPbv/vnvbonMODKrs701K/nTAqGCcNfWv2cI+yeaT1W0pX480H8Qx9vK31
	tKMCH8tjFCoD7gpZ9pBu9yCj6eZLqzIAkB+0nKMC9xzob8ESp3KjMcOAUmVP6pLuvtSi8ycDZoo
	tU2Y4TuNBNcPqEvIFe67v+s/QxCNuqJ91s+ftB8LCSMm4C/uHqIs2Gc3IbPmvou+MxF5fOx
X-Google-Smtp-Source: AGHT+IFbS33XLQ0m410pX8+flrMf29xDm+NrwzCoFtsQo9l/gTmcpqUXAiD41zvVQp64gr9vXuCFEAevcaGRmwsUpkk=
X-Received: by 2002:a17:907:6d06:b0:b7f:e703:fd77 with SMTP id
 a640c23a62f3a-b8036ebf29bmr3051793566b.11.1767008265707; Mon, 29 Dec 2025
 03:37:45 -0800 (PST)
MIME-Version: 1.0
References: <20251228133742.a1f90fc552d346c4c43aad8b@linux-foundation.org> <20251228220742.11157-1-21cnbao@gmail.com>
In-Reply-To: <20251228220742.11157-1-21cnbao@gmail.com>
From: wale zhang <wale.zhang.ftd@gmail.com>
Date: Mon, 29 Dec 2025 19:37:34 +0800
X-Gm-Features: AQt7F2rf9hMZmkqK0fhsvwddEcNsaNSp0c9RjfMmcbTtFJYq_NmE7UasUXbazWg
Message-ID: <CAHrEdeunY-YpDC7AoTFcppAvHCJpEJRp=GTQ4psRKRi_3fhB0Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm,swapops: Fix compile error on set_pmd_migration_entry.
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Stat-Signature: 6qkmq9t89c97t1mmsn637r1y7ucqy3om
X-Rspam-User: 
X-Rspamd-Queue-Id: 8577EC0002
X-HE-Tag: 1767008267-976420
X-HE-Meta: U2FsdGVkX1/NTjX1WL5o+zB3VZJyRlmDs8uwhqJyL8Ca7rBU/tN5XfQR6CdDyNrlXJtVDF7NqbYQtVItlfRrdUkS2JgCfst7WIwUVQTSscwH/RYFaRoUUsJXc1DVfvnAO29NAxjUIieOKqAfJGgX5yUOG8hqfwZSaPmL1nVE+/spr0GcXoktQLKqA25yXM03gJSto+LE7qGN1whbAVVsBF2cGd1mzb1gV/7th8MmK+cdpOfxvLMvpCsKoK3lByJDFmUj3GVot25ngndYVpKcY/tD/0Z8LnsiwRBW6ml0Okk5qaoxjckPcQbR/5bcnrdJII6MoiKjDJW9vFKjGnlL54vI6OackbMnKSGZlWejSQYmD56H/OnNax0Mp+RJ3Jkwmg+AngunaJY41r46Ca0Jhf5qdI+iY+0+ldX/LXgkfV5Cf4ZihZXb0aPRiIUlkxbwP7f+rWDxU1kP/T4lgnugfHhblzVAEY5n+njSh8p1emDZNTolxOWB8RZnaZY5wcYrhhdv1oyVn82WNl0XbjG8GNfZ8vUxwUX5+Gp1uSIW2Zb5vI3w1KAKQm2x9rgOn8/r+F1cGNooFRwnztMcTa/KAddXMvmfHZTjME6Ur39I2RRBo1ocPYX2QbhMCU7acnRbZqRsChdFS2ZI73RguaFcEkFB66nxE0/UBbz/cDyh96UOE66pkr/HNY+gs/xFISKlKmN3l3C+jMBUL6eNr8RnOt6P5zTMSNnd2QFCdIRxvrcB5w/l8qI2GphBErS99igE5Rp14AKE8/ItKV7ZvJJVmbpy8Uy+gpcGuqM40j8Xadh0ScAmCdE0zLyQIuZ1Ik+2GBqCW4DtIZbO3jzzglv7HFv+TBnpgHR4m3M6BYN8yJ3Y0zgJZJN5StLiwR2Xr4ooWnMAtoDRoDlxp/+b9O7aqfyCGr37yPGB1cgxgxClS+c/kforBQ2MEROsM13IEUBLhjOpEa7CdcCfubFo62Z
 +lqZ/YYo
 ntLYCUIc2xUd2fagLgbWDM7e28AAhhknNHFlkrsjQOvQA9qOUVCMx5iLlCY/wMzVov7GDtcHsHpCcBdwRDQ6j7Mb4pF7o0anhd0gRoAiwaqOb8b+aoXAiJk5RVZn6HzPVG4w4fTKqleYFXGZZ6AVjaBrXeuRn55etWGTRnXSk/XbkxKUGq817GfePYtGeNWWv091Yu1k9690Y0NWAVabmqymP01m/k1hyKoRDNbYGCmvcb6sk2NOw7lkw9x8uT8vkIi8yuNkn8BzYDwUPo89exPFWAQv0LP72z27Ud5v7JbjpMKlyDzJFKDkCelrJhCVbimniaA+4WNs8usVKljgcC4/CGXCdZETlpf8bCdrTokQvccP7nyNn+VBRFGqi7gayoQumjw4RDUfXed/ue42Iq2lx28Ycwy1N5cMHRBMAPL/+IwnBY8AH08MgCYHQ/YblO9wlrEe9MMBYY0Qaq2B8Qnv9L0onIYLAATsYzpro0AjuaDEh2SajipBNW+oNVkAqdh/j/8Sd6QiBtA9OPK9t608nkFMQX6eLnF9JsdN6P7ifF/CiBXh/rN0wzHbjpWSPRsI2wz5a6cBKbsUhJAf7cNrKBHeSxC/eFvN7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 29, 2025 at 6:07=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Mon, Dec 29, 2025 at 10:37=E2=80=AFAM Andrew Morton <akpm@linux-founda=
tion.org> wrote:
> >
> > On Sat, 27 Dec 2025 17:58:40 +0800 wale zhang <wale.zhang.ftd@gmail.com=
> wrote:
> >
> > > > No. You still don=E2=80=99t understand my point. The BUILD_BUG mean=
s this
> > > > code will never have a chance to be compiled under any possible
> > > > kernel configuration. That makes it dead code. If there is any
> > > > kernel .config in which it can be built, then we should fix it.
> > > >
> > > > This set_pmd_migration_entry() has no chance of ever being built.
> > >
> > > Hello Barry,
> > >
> >
> > Please share the .config which was used to trigger this build error.
> >
> > (It is strange to have this should-never-be-compiled code.  Why not jus=
t
> > delete it and let the compiler/linker report the error.)
>
> Right. We should entirely drop it in mainline. If Wale does want an
> O0 build, then the only call to set_pmd_migration_entry() that is not
> under
>
> #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>
> is migrate_vma_collect_huge_pmd() in mm/migrate_device.c.
>
> Then what we really need is as follows:
>
> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
> index 8cfc966eae48..fdd4375d5d90 100644
> --- a/include/linux/swapops.h
> +++ b/include/linux/swapops.h
> @@ -339,17 +339,6 @@ static inline pmd_t swp_entry_to_pmd(swp_entry_t ent=
ry)
>  }
>
>  #else  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
> -static inline int set_pmd_migration_entry(struct page_vma_mapped_walk *p=
vmw,
> -               struct page *page)
> -{
> -       BUILD_BUG();
> -}
> -
> -static inline void remove_migration_pmd(struct page_vma_mapped_walk *pvm=
w,
> -               struct page *new)
> -{
> -       BUILD_BUG();
> -}
>
>  static inline void pmd_migration_entry_wait(struct mm_struct *m, pmd_t *=
p) { }
>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 23379663b1e1..74d23c91626a 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -195,8 +195,9 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, =
unsigned long start,
>                 return migrate_vma_collect_skip(start, end, walk);
>         }
>
> -       if (thp_migration_supported() &&
> -               (migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
> +
> +#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
> +       if ((migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
>                 (IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
>                  IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
>
> @@ -226,6 +227,7 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, =
unsigned long start,
>                 spin_unlock(ptl);
>                 return 0;
>         }
> +#endif
>
>  fallback:
>         spin_unlock(ptl);
>
> Thanks
> Barry
>

OK. I will prepare the next patch to delete this unnecessary codes.
Thank you for your guidance.

--
Thanks
Wale

