Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B84E9C55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 21:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B714B6B0092; Fri, 31 Jul 2026 17:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22696B0093; Fri, 31 Jul 2026 17:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A13936B0095; Fri, 31 Jul 2026 17:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C8B16B0092
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:41:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F043380164
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:41:58 +0000 (UTC)
X-FDA: 85050394716.01.47B49A8
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1534120006
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:41:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KR2yv79Q;
	spf=pass (imf13.hostedemail.com: domain of pratmal@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pratmal@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785534117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVBIwZIPgIDhLzcF7RXhpKO3wVpM4DEMhlKxrjF7g5k=;
	b=AOzNgAQGBD9M2gATJoTKCRDO5AgKCAni4wliS/NMHApr5kH3xfc74T4bmdWCTIchICGXCs
	Wi0MJsf733ZvjKClasjzb435AXD7MN0gElDtQxCAfAVLwSESZ5n+D4P6li9VQ3yH/94d3H
	4jU627/DlE6jbdTaKFrt885GqvgL5r0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785534117;
	b=3sFwVX3IL6aww8XieTPdWnei6TvfQXaUIS1OfERXrrnveT6yx++go16I1oF9Q5mUThRUZM
	64zpGYGuzznHLUaIbuIDRU45F6Bv5Z4rOsirS212FtW47BwRaScBi0j/X6Wr4mGN9hIRdp
	p7NQt19WDch0R/gI2MirK6LME2db8jM=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KR2yv79Q;
	spf=pass (imf13.hostedemail.com: domain of pratmal@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pratmal@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c15a5b265so86801cf.0
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:41:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785534116; cv=none;
        d=google.com; s=arc-20260327;
        b=S4/tjlohAW7e11H3gz5wfKdLOD6J8rojpVOLBkM3mecTzHv90JU5pHhGviLaHkAT2q
         WRYjaDLbJfErx3iXTdavKUoogwQ0zTnfvRy5HuGvbkIjGnc1HSdrB0k7wXn4I+MmV+p5
         ukBtn67lT5VHW2TFnR8TwrJbf+0100BnkHwkGMBvl1NVQJsWVMb6Jos24z0NDSqQs+lP
         WqTKJXNRM+zIrZ8GJYd8d9FkSSf3yV4p7V/XSGZau4n7DJiabTiemWCeIH3LbAmWh4UY
         Evu1MBjETQd0GGImlAItJrP2vVh1o0C0Rm89M/Rw+fbTKOnVojooe4qRcBt6rFVO7inH
         G3sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rVBIwZIPgIDhLzcF7RXhpKO3wVpM4DEMhlKxrjF7g5k=;
        fh=9SgDQoOGjxz37THeHzYsRRuiYG2BYJCBKR0pjUR8Li4=;
        b=jDtFxo1bUGqvaCIMeQFVxFefCXO6zIt99hHtpP1EUeICIc9iLkcv0wvNCdeHFAclTe
         rZeamtmivKXstbGT26s6nn6wGQWMvPp91a10G0sfhZlu07GGPcjHwddtyIIHotBttlqg
         +Yllzu97OO7i5QhYnL6euN54kFF1D/BSuvd6O3jpzqrstyK2V/JpkzUqMDVb8Tn8YCcN
         hgH34Gu7jwpL3fJMJesWfB+0L3L11NiGE196DBjGR08c4Yzn/SEhiXXTwnRyy9FtouZM
         OhhyNZPRTNzC5S9IM6gWog3jV6E4RJgkThCLuXzrU024CZWdLAoEjt8yY5l09Op38p2Y
         b4PA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785534116; x=1786138916; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rVBIwZIPgIDhLzcF7RXhpKO3wVpM4DEMhlKxrjF7g5k=;
        b=KR2yv79QIMXmA4HrCpswRNI0ynEdVpCfunoBJpFbQjoXvjqGaRGIfrt7SNObmyv5Gh
         ZYsLQ23c/FnR8wlpixZgfA8bcmU+w4OArXy1V2gFw8li6W9AOV44IED/hlt/hN/6lWD+
         Vwe0InNNWfshxJK99VMKFDY/iU1aRyong3OMe9YYynOxhCJR5qZZKGBf2heHVfuUhPJN
         wkoJnkXgK+NJIyluaPSbfG3mkZYM1Z5j1TWfuNdSzhj54XEhL0umLQnN3zykdDdCXSeN
         9+g5b/mBmao/K3uPlOkCbSTFvGhCr2QsyS6mG6i/jzQfu6r0eXvJbLsIxABWmis9Wyci
         TiBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785534116; x=1786138916;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rVBIwZIPgIDhLzcF7RXhpKO3wVpM4DEMhlKxrjF7g5k=;
        b=GEGNAqPhSM0PImMq2nW3UPeBwYwyKTvAtnTA+agGTAaY8pRDHxmfBZpw1K9s9Y5miS
         AngfGkhku8z+tKiooLpCRmwTA9SFigZymZY+COvZHkI8la/GIkAL+2emnkK5H3Cb4PYb
         cTi9yCZEn2ikx5EfSh9Tys3HoKk+AvTKN2gJJVYJbt6jmFDazntj/RuPZQbbv3cHLW3r
         AZvlCQz/fxzLZnopz+KerFaC8K/cVu7XHeSFUmSIVUTIzx8wzhBC/bo1zfDgYw0ldXCh
         1WcGcca1Alz1OiDUDLgvAgcRzvEd5DkcrOs5gcKtaDYnEDglmO/rcaS8ENFcvv/K3/RZ
         bGjw==
X-Forwarded-Encrypted: i=1; AHgh+RpqeOm3NTQpH6wXO0Mp9bLf3kucCTXO71BXlAQi4EYrU5u8tCX7c+RF4GJNNPoyuVr8EHcNHIfPxA==@kvack.org
X-Gm-Message-State: AOJu0YzWFBX7TuM8kfQWQhGziBFmLzyteasa/tEhHZrtaftrTaUd9+A9
	qnotwz09ZgeDMJuqjn+vcDFRrYygtEQoYZpo5SmhmvL4urs69FM/9ktFiXgbJ5+UsQTEF/3zWcW
	edk0hf5pJ7FZp6lCcxTQVbCNGNBfV+mtlx/JPVp/+
X-Gm-Gg: AR+sD13WJyViHKxQKjdee1RhQTsTEQeIiq5kf2uEv8fVgLUHSletYkitWmUWKgrT5kw
	J4ck1JPh111I+xNzHWH4B13zXZf9DqgH3zxZpajGmJpGtI08Zw5PZOm1fwuB8wGj7lLztf1yclp
	SOyxIuc2WHAnoVJRCZ0I0EqZ5znTrP5lWwek08bZpfGVqFLMHUAcsgHqzeWgYayOLwa+pq4vg1F
	9RbS1ju9lsKIM3RjVDn6siJUYBXqmR1RmAuzDIiR24pKcSikh4eT7Nsmx9/jNVNvgByYQfm8ITF
	fwuHTeRr+RIVFKgk1DNancC2VVVcny/avdeEr5jjeLdeqcxEvpFPoy4RRYMfJr7gad6Nq/ZFrI+
	gWp4bsdQ78QUw
X-Received: by 2002:ac8:5752:0:b0:50f:af60:3496 with SMTP id
 d75a77b69052e-52b5af82a24mr2496091cf.1.1785534115622; Fri, 31 Jul 2026
 14:41:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260731193705.2902728-1-pratmal@google.com> <20260731143420.0787387ce2ca120ecee15338@linux-foundation.org>
In-Reply-To: <20260731143420.0787387ce2ca120ecee15338@linux-foundation.org>
From: Pratyush Mallick <pratmal@google.com>
Date: Fri, 31 Jul 2026 14:41:43 -0700
X-Gm-Features: AUfX_mxONT7BUnCqEgoJ5gcgCngtoxjaOpE8s96ir9f1CQtwXRsj0be_zU_HCIo
Message-ID: <CALHaPKfeCqNUF_+_y=3_iqrDHK++aRNNeTCy1DUYdDOnzsXMxg@mail.gmail.com>
Subject: Re: [PATCH v4] mm/page_reporting: Add page_reporting_delay_ms module parameter
To: Andrew Morton <akpm@linux-foundation.org>
Cc: vbabka@kernel.org, david@kernel.org, sj@kernel.org, corbet@lwn.net, 
	ljs@kernel.org, skhan@linuxfoundation.org, anshuman.khandual@arm.com, 
	gthelen@google.com, surenb@google.com, mhocko@suse.com, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, liam@infradead.org, rppt@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1534120006
X-Stat-Signature: iohyt4jksqjkhpwud75w9ut3waja8944
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785534116-332770
X-HE-Meta: U2FsdGVkX19wXYgoYVnDUdAyfy8Y9LNXJmfGM95d7av9U71KQeVbAtJf6r8kq7Ek5aHOV7K8amDaz1TYX6rBd8JHvLo7GEo3YaYdzAJiLkP/NlJZRjeB2XBybwFqXo3X+QWulCftT01Rr4xo2yjeLJcSExwyy2MGCuNDWl0gKYPAyZbjfUJ9xXia0gEKRniXVF4ICvU4J3v04U9BCgjjkUWBFegr58xwsx9I2yAVVuJCU4OocdbK00XN/uQN3KYMqXGR10XjUKAJioo4xmWarNc8hcuw42DniCmio9PKI92eO4TRirh5YkMUUnLRcMGLac5iV/KPDAHUCulZqdZ50sFo6nVN4A0UVSD6dAZpCDBzTC/6dua6ehCDiXaVp1xoXWyRBowHHRPFnmU6B2XnVPkik9cnt6N63R1cYeo8gMIIKGFNL2YFfFNSrhITD0qXINbh3s9+Sxdq2+MPTa2klhilQmAJos44v7RWhs6vriu8G+5N/i7hCxr08fHRj7OlxjVvj57U33z4BFlCG0qBDFiAWMcDmvTajtbImTnqZ7X3dMdHOOAWIWIwpQrMjIOghqNcC2eByKTrupg8SlWC7ij9saiIt7EDaEu6G755hNOtVv3xRpwAM1N8jbW6zUmn+WxxRWjzHwZzz+ECEjeAQIF5jp3BVywGCXtwDjkLLGIVAiqXPrlMrhjSvI2XcVQvofiR0SzE/011b0U6xB1sqV8RHoHzFMmW22/U+TddIbKhRtrr9/td+pNnEiS43n7F66rArinVahMxv6gsIEPC5T+nmWCeYKMOvSHPBsvYjhgTCrTx5uR4eDyBs6BJODK3ZMStlTblFzsZOEr20Nvi8boin5blHHjvC1UK5zGkf750Za9/An2neEvnICEH1Xk/b6p7odlptT//ABhdloCjFQ+G49befJvVjuI/cs/fAOqAkA+xpMTvXBFceAOB8swiPh3dGZoC9itbgs97HEY
 cCMWu0cM
 tG2cIlHY01Bma/pPWaDPSj/NPKaombpVfhG7ppgp5OBl2ka4AmVXQ8x1Z94M6K+XZ17E/b74cqWW+O6M8UIG3C4IiOB60PwZxx97FRQTxFagI2uysRv2w+ceEiYkrFhK9oDwQinwtsxtK5fuXLcqaX01pvBgrY2nczOFpYhXmHZzm4WUiCb2Z5RZ7hY7pv/H5UyWWMmyEOYv5B3oTkbbMl8IiwPcqttVt/2gnR0Irn351Y23RilfhzVdpcz6gMQlTV0dbqJxle+UnU+IAECv+yV+ZUxnew8hTZYAyb9cb6vdlx5EIY6P4WwRn6moivJZL3yC30z4TzHb+b+lP5tr1BTayjGVoXZfhG74XSvf1Nn0DV4bfInQGnzZCLCAGENqXqj7zDPJjBvdNp0c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry I forgot to update it in v4. Resolution looks good to me.
Thanks Again!

Regards,
Pratyush


On Fri, Jul 31, 2026 at 2:34=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 31 Jul 2026 19:37:05 +0000 pratmal@google.com wrote:
>
> > Free page reporting currently hardcodes a 2-second interval between
> > reports. This rigid delay cannot accommodate diverse guest workloads.
> >
> > This patch introduces a module parameter, page_reporting_delay_ms
> > (default: 2000), allowing users to tune the reporting rate:
> >  - Lower values enable aggressive memory reclamation by returning unuse=
d
> >    pages to the host immediately.
> >  - Higher values help batch pages during spiky allocation/free churn,
> >    reducing hypercalls and nested page fault overheads.
> >
> > Setting the delay to 0 is safe and execution is strictly gated by:
> >  - reporting is only triggered by high-order page frees.
> >  - expensive hypercalls are bounded by a slot capacity watermark check
> >    before proceeding.
>
> This conflcits with the just-upstreamed 0b45f6927a1
> ("mm/page_reporting: use system_freezable_wq to fix UAF during
> suspend")
> (https://lore.kernel.org/20260721005603.1710551-1-linkl@google.com).
>
> Please review my resolution:
>
> --- a/mm/page_reporting.c~mm-page_reporting-add-page_reporting_delay_ms-m=
odule-parameter
> +++ a/mm/page_reporting.c
> @@ -48,7 +48,11 @@ MODULE_PARM_DESC(page_reporting_order, "
>   */
>  EXPORT_SYMBOL_GPL(page_reporting_order);
>
> -#define PAGE_REPORTING_DELAY   (2 * HZ)
> +static unsigned int page_reporting_delay_ms =3D 2 * MSEC_PER_SEC;
> +module_param(page_reporting_delay_ms, uint, 0644);
> +MODULE_PARM_DESC(page_reporting_delay_ms,
> +                "Set page reporting delay in milliseconds");
> +
>  static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
>
>  enum {
> @@ -57,6 +61,13 @@ enum {
>         PAGE_REPORTING_ACTIVE
>  };
>
> +/* schedule work for page reporting */
> +static void page_reporting_schedule_work(struct page_reporting_dev_info =
*prdev)
> +{
> +       queue_delayed_work(system_freezable_wq, &prdev->work,
> +                             msecs_to_jiffies(page_reporting_delay_ms));
> +}
> +
>  /* request page reporting */
>  static void
>  __page_reporting_request(struct page_reporting_dev_info *prdev)
> @@ -77,12 +88,10 @@ __page_reporting_request(struct page_rep
>                 return;
>
>         /*
> -        * Delay the start of work to allow a sizable queue to build. For
> -        * now we are limiting this to running no more than once every
> -        * couple of seconds.
> +        * Delay the start of work to allow a sizable queue to build.
> +        * We limit this based on page_reporting_delay_ms.
>          */
> -       queue_delayed_work(system_freezable_wq, &prdev->work,
> -                          PAGE_REPORTING_DELAY);
> +       page_reporting_schedule_work(prdev);
>  }
>
>  /* notify prdev of free page reporting request */
> @@ -337,13 +346,12 @@ static void page_reporting_process(struc
>  err_out:
>         /*
>          * If the state has reverted back to requested then there may be
> -        * additional pages to be processed. We will defer for 2s to allo=
w
> -        * more pages to accumulate.
> +        * additional pages to be processed. We will defer by
> +        * page_reporting_delay_ms to allow more pages to accumulate.
>          */
>         state =3D atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDL=
E);
>         if (state =3D=3D PAGE_REPORTING_REQUESTED)
> -               queue_delayed_work(system_freezable_wq, &prdev->work,
> -                                  PAGE_REPORTING_DELAY);
> +               page_reporting_schedule_work(prdev);
>  }
>
>  static DEFINE_MUTEX(page_reporting_mutex);
> _
>

