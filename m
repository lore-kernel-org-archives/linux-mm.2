Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B93D9CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 17:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 152258E000A; Thu, 11 Sep 2025 13:01:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12AE98E0001; Thu, 11 Sep 2025 13:01:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 067E48E000A; Thu, 11 Sep 2025 13:01:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E78D18E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:01:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD0338690B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:01:27 +0000 (UTC)
X-FDA: 83877585414.22.141DF03
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8C04E8000F
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:01:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=S7KxiDIb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757610085; a=rsa-sha256;
	cv=none;
	b=0yAGMepdsTEphhLbEtjvRUP/RQDbRaww8Sv1RR8i90ukjnwVx/xHrJo3pB5VCHWuBNdHEN
	5DW7mfFYREfB8/yBF9Gq0SWRizXrpN7R2yw1PNn3Fo7OI8mUCHVxstVfMelflJ0YDtveNp
	BN6YyYSQXYfbRn4pqeH8rgcsfLXX6WM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=S7KxiDIb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757610085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6YrfqY/kfgSYj+oS+1XLN+/+rpi+sAaHCEvGJrLudw=;
	b=qsYYj2/YNnYEagHQl0mhy8SxW1If+4wdd6BLzSfF5/F6LzUOzH86bLbnwTpoDq+5iS0JS7
	qcnFDePm581UYmRneofeAdsZrqndoowAwT6VBk/5c8bzMSkrJkr/EcqH1HRaOhSZlHc2Tv
	lwa9Hoyvktl7kpXk/WMEngkmOyxfdhM=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4b4bcb9638aso29281cf.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 10:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757610085; x=1758214885; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q6YrfqY/kfgSYj+oS+1XLN+/+rpi+sAaHCEvGJrLudw=;
        b=S7KxiDIbEWc4f7XiYSaSsHTGL4lA1pLOmR1qcV0q7fmwLKOhOdc9AOaImCV5M9wRE2
         +tr2oGq25df6cCpqbvc4cmqtsCcIAZtsnl4O3V1RsK4opszKBAsnbVWMDEE/f6QlWDlc
         4VSjr5YyjAr5D+UT2pbPtDUA3IONv/nJLx519aqHotJjU2AIxXskxNVd/UdgAwRBwzQZ
         i7wbTE2zx7CDrrabCMWtXy/VxJKF+VtVvpDaesXlq+pW6iMDfA2NjgQ8UaE1BYprvEu+
         o2l4TYOT/Pnpp1o+8cryKEa37LIZRF4WKvYaV3Vi2/ildDPBPfuj4ePgEo48YROcQ4Io
         ICng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757610085; x=1758214885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q6YrfqY/kfgSYj+oS+1XLN+/+rpi+sAaHCEvGJrLudw=;
        b=vDpebSrPkyf5/629EgKvDjS9RIaO7Si3ksm2iefr5SWlEihcoGs7JH4fF1EI/V5upF
         8WSXgHcRRcPLgla1PXg210NEv15EoTri3Vu+IwlupIzo7tsf78bYeJ2ENNQHVpdm+cBv
         uVKXVuWC4E+wTW6rdmz3lyaVD7fu+GZRXA8DYgv6iL6QEwa3eBEKxnnbcEne5HH9ZTYm
         1LOZEb4QWzbzdlc2Wr74j/hnr0S2egSEKXMQbgGKJUDH28JaF3F6O+TvMei9ivQdWG/O
         Ltq9H04ALSgoRItQm3+xZU05pAhcH3t2CH2uO+JwiYVr5jNckFu3SK8Nhj557OXYRQRe
         Xs2A==
X-Forwarded-Encrypted: i=1; AJvYcCWomYZzLiopzcF2MDwSCqStXT0KRK0O1csORsDgbTCIEVv/6qpHf/57P32FOmnXbGkHRZXc7LkRBg==@kvack.org
X-Gm-Message-State: AOJu0YzFjGipc72IWxD9lFYMzPnOggmSNPYcgA+OGRs14bWi4A+FxB+t
	fJh5Uf2h+V/quLowNa/QyhowYWpDkqzOq806gnEnF8UVuPdPqDoTZ+Zfr+pSkj6RaAPiOYWdzIe
	NxRXB/W3MYU+np5BWrh5UKYqBz6DSplH6tDBfys+J
X-Gm-Gg: ASbGncu/+IlT3yO1/Ze16s7wRmDRrYj0V+JZ+0FdLUCZpKXoNfu6sJ1UlmTuIObD9zm
	2+Y6jic4b78AB+dIg8wAtQpOpi6QXmCpfzuOAyliZTbQ5XkSE2j5cHmJx+tzKDulJnuYZPNiMAO
	EjRyNiGvgOL6EXfIVFwBIePf9ZO54NqiPrYF28g9HLiQEioXN/7q7J7E34M7evhBzK+rXe9qJ6R
	SIReQgycS5Wk+1P1lHFfylZCq+LJMVyvxMWTpJbMG1nfpxavczdtsQ=
X-Google-Smtp-Source: AGHT+IG/kGtpeM1Gey5HXQIudODeDgi5j+h1iwkur2YPNebrI0EBbETji52IST4YryPwZxkruYtTb0YI2mIqsfHjVA0=
X-Received: by 2002:ac8:7f04:0:b0:4b3:509b:8031 with SMTP id
 d75a77b69052e-4b626ecdc80mr13291841cf.13.1757610083966; Thu, 11 Sep 2025
 10:01:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250909233409.1013367-1-surenb@google.com> <20250909233409.1013367-3-surenb@google.com>
 <8c4967ca-a125-458f-9998-6de4f8257dd5@gmail.com>
In-Reply-To: <8c4967ca-a125-458f-9998-6de4f8257dd5@gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 11 Sep 2025 10:01:11 -0700
X-Gm-Features: AS18NWAZbkq8dvCKSAxdNbLr7ujTjPXQQ54Sf8B1FoS7wHGiZNmF7lvVrv9CrLA
Message-ID: <CAJuCfpG3_Rhxg3y08PRivOYJY5CDVdzVg6uakeQ0HXKU1b8dpA@mail.gmail.com>
Subject: Re: [PATCH 2/3] alloc_tag: prevent enabling memory profiling if it
 was shut down
To: Usama Arif <usamaarif642@gmail.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	shakeel.butt@linux.dev, 00107082@163.com, pasha.tatashin@soleen.com, 
	souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8C04E8000F
X-Stat-Signature: uqkusxdbqkgj9oafh9ka5tooe6xybgr4
X-Rspam-User: 
X-HE-Tag: 1757610085-797553
X-HE-Meta: U2FsdGVkX1/OAVeuxyNQ33P/u07BEs70rzG/W73yyfknvvxRVuXZfgpLYTTmUZ+Zbjd7FHd7tLrJkFM5zKTeEk3AkF96HKgM1hZnxA7/wpoStVjB6Yag43E10XzZdzJECftM8fNAmlCxKaW4eBEtETwhSZkCT68UWoPe0rKdUz/MD1LjqpyzDiPwf5lO2Nq+ygED0tPxLAkztE+9obEOYwWp20ZwaSZw/VGRExMjl+Dlx92G1KiJpbaLuOqjlLI9XZTzuK6Gyswtdtb9vt5RLbKWx4SlGouXHi2sVR2VQFe/Zd8nNKyz1yU9Ri/9c1egjtYv5kQZtKST3+GddilV/lRtjY1yyn0joLpwe1rLtxRCKF0pV/102/8IP1+JkAtzTugKWGxnqjgvN3qhj2DhD58sxnXR6bgu56Cn60tJ3r5TzW3LB5uRNRLE/2z3xloEV/cj5wgfGlZ/XhXl6lVi/95a0TdGSgC8x3AaJcCMhoyfKKj+butAhP6N07RbNRNdLqforllX7Kl8TB5e8bdsCCW6y4ElyNrKo6RQsi2jJZyBaoVkuI1SI/h//x7h9+5GN/jIABM/HyurnOfHE+49wCojFhCoXPZ8O/FoyyKZMwjkbOt96wJIRYOJkFjA82CauIuZQYAQHJLKWuDZpdDYrE4lnjkjKqMLfTvzIrxXfwWYFZBnO65MEueAhUWI49iliKuFYnSG0AqCs8xZt1JZiiExB1TWzucxXOEDEt89sZNBTC16YgDZieOt663kNwTNDBzglZiaRoSTK7OjTyjVYPnwmKSmXQnpmAheRIwyRNPuW2mrrnLeSffXaZP8HjNOMwBK1MFVk573sIImLZyEzbT+o7N5NiofqCGUgKc609AeBpYF5a/9w7ml/XPK1s5F8MofXrko0Lj980G9gDqkXij45JrnEYnMEJMutcBfWi+uLTnBTCFocQ6kaGhCmepUerJhHwSZzufMSyAWYii
 ElY/1A+K
 SDBbr1xAEJU186DOo0OPEcjPAj4T/SuSXxGdJT3SNKln90URSmZeL2rqmlRctas6/BEYTW4E11i6wAsjNyRcbugSppGv3F6SDhktS5jRCWuZK4XF1aLYdJTVJ2YGoXSKhhsCx9ox/AXfFnAUsMC9bNdH9mmllSmMK4wohmw3FlEVossy3npGRYpsj8wtA30iKm0aL1ruMQT+uEjmBQPOgBgaPPJHal5asLbktzOjQfud4CRyYSNPXIdGpVjPiolx6ow1fa2jXRQnyMJEgtFhVmmoyJQC1fDibTPDz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 1:52=E2=80=AFPM Usama Arif <usamaarif642@gmail.com>=
 wrote:
>
>
>
> On 10/09/2025 00:34, Suren Baghdasaryan wrote:
> > Memory profiling can be shut down due to reasons like a failure during
> > initialization. When this happens, the user should not be able to
> > re-enable it. Current sysctrl interface does not handle this properly
> > and will allow re-enabling memory profiling. Fix this by checking for
> > this condition during sysctrl write operation.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  lib/alloc_tag.c | 12 +++++++++++-
> >  1 file changed, 11 insertions(+), 1 deletion(-)
> >
>
> Acked-by: Usama Arif <usamaarif642@gmail.com>
>
>
>
> > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > index 95688c4cba7a..79891528e7b6 100644
> > --- a/lib/alloc_tag.c
> > +++ b/lib/alloc_tag.c
> > @@ -767,6 +767,16 @@ struct page_ext_operations page_alloc_tagging_ops =
=3D {
> >  EXPORT_SYMBOL(page_alloc_tagging_ops);
> >
> >  #ifdef CONFIG_SYSCTL
>
> nit: might be good to add a comment here that we are not using default as=
 we dont want to enable
> it back if it fails once. But not worth a respin as someone can always ch=
eck git log if curious.

Ok, if I respin the series will add it. Thanks!

>
> > +static int proc_mem_profiling_handler(const struct ctl_table *table, i=
nt write,
> > +                                   void *buffer, size_t *lenp, loff_t =
*ppos)
> > +{
> > +     if (!mem_profiling_support && write)
> > +             return -EINVAL;
> > +
> > +     return proc_do_static_key(table, write, buffer, lenp, ppos);
> > +}
> > +
> > +
> >  static struct ctl_table memory_allocation_profiling_sysctls[] =3D {
> >       {
> >               .procname       =3D "mem_profiling",
> > @@ -776,7 +786,7 @@ static struct ctl_table memory_allocation_profiling=
_sysctls[] =3D {
> >  #else
> >               .mode           =3D 0644,
> >  #endif
> > -             .proc_handler   =3D proc_do_static_key,
> > +             .proc_handler   =3D proc_mem_profiling_handler,
> >       },
> >  };
> >
>

