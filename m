Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09B57CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 06:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E5886B0032; Thu, 28 Aug 2025 02:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BC4F6B0062; Thu, 28 Aug 2025 02:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1FC6B007B; Thu, 28 Aug 2025 02:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C96E6B0032
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 02:50:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB67FC09EC
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:50:48 +0000 (UTC)
X-FDA: 83825243376.29.DEEF378
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id E778840011
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 06:50:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fMlDNF2G;
	spf=pass (imf11.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756363846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IiNHEvw4OCzSJ36sRfMVygFrm4X1IJUCPsv6ANJRoOE=;
	b=EibAruuOT0gOZZGXRvIaPNlYywathHAxH5OcmceI05M+xq3Wi3cbrVcbPF6XisKcNohVzH
	dUAb+xT2bxmZ7eTKu/XPP9VPQSO6SNJ1CA+zhz7LY3YTx2tC8K4OO8lTXzs8FCTShu75wD
	rgIrmNSiUMvOn5xbTc1SfBmd5l2IUA4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fMlDNF2G;
	spf=pass (imf11.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756363846; a=rsa-sha256;
	cv=none;
	b=PIRDnCo8NBajYlk7cr56MAbA95CTCGBnljZ4Cj8UmubougOj7ycpqTC3RHxVRUWtyfTbOu
	IvaaN3jhU02P6ftlGGtkIAKu8SAJcoB2SvXDi1DXIZ790DcA+fi9LNFH2u51z4nLI+F2zO
	Uub/21tvxvQytS6Z0LuHwf/uCb9O1BI=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-70df1b769e4so2072136d6.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756363846; x=1756968646; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IiNHEvw4OCzSJ36sRfMVygFrm4X1IJUCPsv6ANJRoOE=;
        b=fMlDNF2GrhLAC+k3CmPR88ZUroSteIZAcdAs0wbv1ybbeEIq1eB3q+PQfP8CIK51RP
         y5UG+45DuML5Y7u9/2pljvk98Ep3c2vppT8e49Uw5CH31AqGcRp0ptDDt7rpQvxERmXe
         UgpfozhjVSIO6JFL6z0ABiK8vkNhfE9tY7dz79uGlsYZTWkDoncR8jnVEbzO1NSoBaWd
         Lyc6ee0V/rVJBq3/txQBbbX4LIhA+XrYMDRVHDykJcjhShGoVbjMF9JfI7ZvwnhLvTYt
         Z1dozSrkn7YnkYqYTge3B8M6KDjgyaj/12AexPG0YujHXOb11mlCJdFb4T51XwrVwmJI
         jNSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756363846; x=1756968646;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IiNHEvw4OCzSJ36sRfMVygFrm4X1IJUCPsv6ANJRoOE=;
        b=A1UIHME570CA79mhsm1bgxlcJESANFQ3l+mBp9zNlnqgZMnAEX8cdJLf05Cl+HTV0L
         WynhkALsmQsIsi7CGAd/NDaaNUQFGIHms7VjTFHiKt2CrsRSBDC7vuE395b0bqLStdE6
         1nwdUwEMWyxlGg9q8IVLj6G6lXDgNoI8iR13A0FImlj0JqVc74dKaJItUUgg5TdNeMdi
         kNvWHCEi7ZcHxmtWwV+GRD8d9UB+zckItGF6uw0b4tmiO/jJq5UfC6ze2FIwhF3Xb5Mm
         V+lEki7TqJUglthP3KM2EjudtwyzpISfzW5h1Mfw+DyvfNkGf301pWywH7AIB55x7LRv
         1j1g==
X-Forwarded-Encrypted: i=1; AJvYcCUs8i9IZouo76NquZTKdEaDgiolzmaF/gHy6w2uL0etezvupMzha2pwBRzrFixLYuxK7H9D6cYC2Q==@kvack.org
X-Gm-Message-State: AOJu0YwG1ryJwWrOws3c1kaSdcGAbcd9l1IELaCOGJaA8fexXp5ERC6t
	8vMzrmJIaV574gWuIYgUu65BVKOAVQGdhTY6e9fNXt+lqbUwvBEamFEqKIvsZ5KbhEEMnVM6+k2
	31NarxGrbJ2hwynU2Eo5cPBVIWKr0GFo=
X-Gm-Gg: ASbGncs7aMfR5ieajBSroWtzd3+D37feH56kJq29Ngs6lUV9BoWxU3Uw0ipmmkwk7t6
	ynuvWSJlr78pIhNmOY2iC4E38iapD2JWIrBc2q8ynnwVuf7S4hCtwVxeuLkrLHgMnHvE0eKq+42
	oOjLGnJTsGsrHns8dQf6E/l0AHBP2X7xePn3y3CBkoIWZOehrdH1BcskJEzwUBvn/ClKk5pVpIa
	NyMAFVrlcQcFu88W+nORj1u5Ir7z8pCdkiGhj+TOajlCyMlww==
X-Google-Smtp-Source: AGHT+IF+ehKK78j4DDuJ4sGpjti346ms5dAzHA6bOxAHCOy4qjrtSDtJIZ0Z8hdL2OZci0mG9+6t4jpIK1su2Tf5Rdw=
X-Received: by 2002:a05:6214:ccd:b0:70d:bdee:ce2a with SMTP id
 6a1803df08f44-70dbdeed2bcmr157099056d6.46.1756363845938; Wed, 27 Aug 2025
 23:50:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250826071948.2618-1-laoar.shao@gmail.com> <20250826071948.2618-4-laoar.shao@gmail.com>
 <5fb8bd8d-cdd9-42e0-b62d-eb5a517a35c2@lucifer.local> <CAEf4BzaOA-3NtwTmrPgveqbW16m3KZAAA1E_xn_qjtiJBGsE4g@mail.gmail.com>
In-Reply-To: <CAEf4BzaOA-3NtwTmrPgveqbW16m3KZAAA1E_xn_qjtiJBGsE4g@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 28 Aug 2025 14:50:08 +0800
X-Gm-Features: Ac12FXxzAaUxjJkSIKj9IhilFeKPZNkJYuhj1_W1tJSrtzY4m65m7APoD6Uecqk
Message-ID: <CALOAHbCc7upWnZuAsxSvW0LAwMi+RzAYZh9MzO52+B=TcY8NzA@mail.gmail.com>
Subject: Re: [PATCH v6 mm-new 03/10] mm: thp: add a new kfunc bpf_mm_get_task()
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, akpm@linux-foundation.org, david@redhat.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, bpf@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E778840011
X-Stat-Signature: r34isoaz4xcjpse4zhz5xrod4i4tawsj
X-Rspam-User: 
X-HE-Tag: 1756363846-14529
X-HE-Meta: U2FsdGVkX182La/1U0GlHAwx4/Y/IhBVFZAwq6JnUkQh9HgR3N0/lKZKvRox+lHZS3BhDhVT269+IiZl2kykLFie1+d9aTGxYP/rtLQhmlCvj7wVWv7w3HRQL03ba0a/hQbLwzTwJbO7ikePO1Y0TJj/dzFnq/9uyIzZkRch8FhWb/ha7r8dEf4i6TYqTe8NBBFegiIfAipmHa7cJb4q9cFpM//9282xNhXXCqe1e4BNQa3onh+scBCAysxHDP2ddHSiZh8cFG74dWd5uo6Rzp3lg27kIi6c4PtQhLSrwtSvN/9wE9g9ECkk2H0OaJ1Wz+0Gm9hMxoReDP+P/ZOy5v9NxfkNzAzIuBZZpdB4iEadgpsSoROaV2PgRYqgWxvTKGEA05jnikas4qr9qZ7Vz4WYgDv5xtTkpc+w3i7jiRbm1rqtJi7jZMHjVYwXsjmdE1nnybiDAE5SCys3cd+htmwCsfAf48OshJ9DL2uVCzfC9IzJzF01tElIPRwyR1YnkpAma6zrSZg6xb+J1gley+mcFyAuSJAeetrQ9nqVSdMKKqxfAPMeubLUB3kvgqyp+WVoztY3b1Vt9PU03JYP3A/a9JZuYl5T8SLM7jTJpfAEusbLVizlqTJ+PA4M53J4Bxgt8qRAyTbbGoYA0JguW4RwsPUo1HBQbczs1NPWD6A/eI4T9TdzxMD0B/bhcCjIiFurIMU8AQMTIPzWl9o7oRhNsX99/NrpOEE9mqjSGmuvHdiWpcqoxC9cSK82eZZeTHHVc99rdlo8vaa82MvHaG3+QsYrTipMFEhjaDJtmmL+s67aue0w0hRuFNsbcI01VKe7PwAjnir+aXHDcGFcXtmQB/M52aziwBDX+889K6d/hmQvF/QOjnrYGnh0K4OQFqtg6BdmFpP/6yNi+S2y+X5G6OxB4laDIGlCewo+eoz8fnRP4vWHmff4TWBk3tUisb+0InAjrg9lT0KuUO7
 qmotMZ4C
 +1yUkvvn8Wfa+Nmr78B0L2RUBylXrAgcYIjRQtGX6pxcnN9XFMUaObUtyoND+Ts7MwqMJ27bzfIllD7lv/Y0xKQpycsCkKlg8hSWQFqTLojg7ZcDVhJMI0D612NPMrJKSM0LU9za/e/PTefUG6Djj2nU4J3QfXE59oNpfnng1RbVXSaG8xE6g+QkdfZ+bAnEJNPVOi6ZaCQCuLAsf40mg+QVwOJXLUIlFkZQHX9TU73pKasR+jvT1c3eHFYieXnXcDtPPTR0cdnRzNdZhzSHz+OTios7h75+rL9z4tZx9rIyPe8fOCxas5Bo1EQnAXZfEtUqev3F/RAeW4dtKY1URqguXF3L/uGq4lu2At/OcYvBcAVWZsyJF4tRPhmAQDjwUrZ9jXJ3knIC0P5OY2gjYvgcGG2VeO/wgqPq1CpQDuGyKFggqTLNG1jEhVMbZ8yMZt49xW3H7kmaZ34Eh3DANfmXQcZw6B7p5/yfuJKJYA7BEAIMgVm9Ft6kYhXWcIOgTCgiXX1iRbtryNoY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 5:50=E2=80=AFAM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Aug 27, 2025 at 8:48=E2=80=AFAM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
> >
> > On Tue, Aug 26, 2025 at 03:19:41PM +0800, Yafang Shao wrote:
> > > We will utilize this new kfunc bpf_mm_get_task() to retrieve the
> > > associated task_struct from the given @mm. The obtained task_struct m=
ust
> > > be released by calling bpf_task_release() as a paired operation.
> >
> > You're basically describing the patch you're not saying why - yeah you'=
re
> > getting a task struct from an mm (only if CONFIG_MEMCG which you don't
> > mention here), but not for what purpose you intend to use this?
> >
> > >
> > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > ---
> > >  mm/bpf_thp.c | 34 ++++++++++++++++++++++++++++++++++
> > >  1 file changed, 34 insertions(+)
> > >
> > > diff --git a/mm/bpf_thp.c b/mm/bpf_thp.c
> > > index b757e8f425fd..46b3bc96359e 100644
> > > --- a/mm/bpf_thp.c
> > > +++ b/mm/bpf_thp.c
> > > @@ -205,11 +205,45 @@ __bpf_kfunc void bpf_put_mem_cgroup(struct mem_=
cgroup *memcg)
> > >  #endif
> > >  }
> > >
> > > +/**
> > > + * bpf_mm_get_task - Get the task struct associated with a mm_struct=
.
> > > + * @mm: The mm_struct to query
> > > + *
> > > + * The obtained task_struct must be released by calling bpf_task_rel=
ease().
> >
> > Hmmm so now bpf programs can cause kernel bugs by keeping a reference a=
round?
>
> BPF verifier will reject any program that cannot guarantee that
> bpf_task_release() will always be called. So there shouldn't be any
> problem here.

Thanks for the clarification.

>
> >
> > This feels extremely dodgy, I don't like this at all.
> >
> > I thought the whole point of BPF was that this kind of thing couldn't p=
ossibly
> > happen?
> >
> > Or would this be a kernel bug?
> >
> > If a bpf program can lead to a refcount not being put, this is not
> > upstreamable surely?
> >
> > > + *
> > > + * Return: The associated task_struct on success, or NULL on failure=
. Note that
> > > + * this function depends on CONFIG_MEMCG being enabled - it will alw=
ays return
> > > + * NULL if CONFIG_MEMCG is not configured.
> > > + */
> > > +__bpf_kfunc struct task_struct *bpf_mm_get_task(struct mm_struct *mm=
)
> > > +{
> > > +#ifdef CONFIG_MEMCG
> > > +     struct task_struct *task;
> > > +
> > > +     if (!mm)
> > > +             return NULL;
> > > +     rcu_read_lock();
> > > +     task =3D rcu_dereference(mm->owner);
>
> Question to Yafang, though. Instead of adding new kfunc just for this,
> have you tried marking mm->owner as BTF_TYPE_SAFE_TRUSTED_OR_NULL,
> which, if I understand correctly, would allow BPF program to just work
> with `mm->owner` (after checking for NULL) directly. And then you can
> just use existing bpf_task_acquire()

good suggestion.
will change it.

>
> >
> > > +     if (!task)
> > > +             goto out;
> > > +     if (!refcount_inc_not_zero(&task->rcu_users))
> > > +             goto out;
>
> nit: just call bpf_task_acquire(), which will more obviously pair with
> suggested bpf_task_release()?

makes sense.

--=20
Regards
Yafang

