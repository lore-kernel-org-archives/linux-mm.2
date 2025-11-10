Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 066D3CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:25:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226F78E000C; Mon, 10 Nov 2025 11:25:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0988E0003; Mon, 10 Nov 2025 11:25:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0575F8E000C; Mon, 10 Nov 2025 11:25:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFAF88E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:25:18 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93659139688
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:25:18 +0000 (UTC)
X-FDA: 84095222316.30.45A26F9
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id B814D8000F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:25:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FMC7UYLe;
	spf=pass (imf30.hostedemail.com: domain of glider@google.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762791916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c9SA+Oyt3urlxF8erNwoXRcqQ1B+Xtx2kUos6VgD610=;
	b=rkxYLq9Nc4y5ZL1+GzqzRFhw3VNh62/SP1enB1pF4jSNqsf0zaO76UxI1ugBZaL4npHcdE
	1vpGhKZwxSGzwMdWkBcIgdaVoHSxxIxZeHB9OZEPOCOyDH9uvk0GFocAxG/ASmgXcnEbnb
	Q4daNSAHC/7QEfFsgn1qU68tGqFyNXA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FMC7UYLe;
	spf=pass (imf30.hostedemail.com: domain of glider@google.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762791916; a=rsa-sha256;
	cv=none;
	b=HazfjOq8g5f6Saa8BGUE8hvT0+59Ez2i3A0RjyLInVG1xPa+44q9Bz3pcHnhzZUpwvgPFS
	dKo/kL677lp+Xyp0iXjfbuByGzFsWzylQc1sRKvpGncaornbVnbZ28JWPpTSt+cPJ9D1c7
	T7FhFvYHZjxkNhcM7eAmWm+x1vx+/rg=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-88059c28da1so34078756d6.2
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762791916; x=1763396716; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c9SA+Oyt3urlxF8erNwoXRcqQ1B+Xtx2kUos6VgD610=;
        b=FMC7UYLeIXn4KVzvU9keJ415jpNJ4PcD4Oayd30ceD8E+dexW2QlP0hJxYSLvNpesw
         8+MwYSgQkgpSFiMCn491qXONWsTO6JaKQzcgr/Qj8mTmfUuyF8vxATs8XXHQRC6zA55k
         AvDM5fEUH4olzOpYzMAu5RL5W/dXns+DMrz8yJBwSBVVugvVxajKpOKgLcakYXQhXxTM
         ssioslL3sUbMXOz3NaWA10JdTKaq78Wc3wC1ndeZ63xIy1lUafqciOrv5KWf4AYYlr2T
         eGSul25OGgIM+nE/cd2YOwaICLvL3DULt6qmyiLruW+O5CGEtSJokB606YKgE1wwA2jm
         dmPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762791916; x=1763396716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c9SA+Oyt3urlxF8erNwoXRcqQ1B+Xtx2kUos6VgD610=;
        b=uMiBV0MI8sZHpnfgUTTUk+OW112fPt9se9CBoT0k41mETMMoAEgjLDMUmCmNYm3kxf
         45hvYvKNyr9kDM+zvJ5rs7E80H5DugcFoKejJTsByV/szhKnBvyLsAZ62GaFrJJvLDAt
         Q2bwvsF6n7HFtwOS2tJiVlJkneNztWHMKrogQGxuHUpL5UUSS6a2PQO09D2s2t+MbPgp
         YeFMCfev9o7p2XN8jCx4pZRV9dHQuW2cTBUkvrp6A4F3ydSJxMIRIyaw8CD1O7P2z0RU
         vnSxOSTRTC0NuAspTxt24Wu2ThR3psZgCZZVNm1gRiNgfoCbCOZyw3YXROirhlV9aZMd
         yPbw==
X-Forwarded-Encrypted: i=1; AJvYcCUVZpGsmg3dZJ40/zUHph24vdJjXfP8lZHANrBk0nL1u2ojCMWMNlRilaJY4KRRMBcPw3gnHji1aQ==@kvack.org
X-Gm-Message-State: AOJu0Yxe7hEyI1zqR40CgRlSerz5pWHSKMJ0YDDcBGI6b8Fc91aU6zcP
	J/FPw/LhPPxEeyMwYR3Vy/Ep2DcXSV2jNlQQxIRPtnaaTNHELK6NEp02xyXJzcpIcNDGNrci0me
	YHpAy3d9IhQAICwzXbowrC9CM0kcEJxldRSkAdrs7
X-Gm-Gg: ASbGncvDeGvGQhm2s5euREwJjgMlDEM6P+odk4aIUvKRurCoN9SmWub8N1Sc0kDZJF8
	o8um1hhTRIU5+kAi/frcrPGZwsuQpDXI+1Em9VspUgTQJLEAcunHR43jQSqSFIw3EDFC0rBlBcZ
	kChLxqa3k1usi5q18jsl9xPDWrzcGRiwF1/xtBCTVCXzy93PaaeSSOz+U96fFrrM6A1kSYoKQwJ
	HIDgwqzpqfqg3GAjgn9uOBvpYn7cE599wg9nXc3wXjjiLlIiLdN4KmPk+eh5eBQTlq56O2kbw6v
	+G5EwmKV/DqV0z4=
X-Google-Smtp-Source: AGHT+IHpxAHAI0f9Cr24tNS6jOzBKv+3mGRu+Z9H6Txpc480qOR0dPNsaiR/3XasB7O8AH8S5J5ulzFL0knik9fmYsk=
X-Received: by 2002:a05:6214:600f:b0:882:4987:360 with SMTP id
 6a1803df08f44-882498705a3mr75490586d6.62.1762791915502; Mon, 10 Nov 2025
 08:25:15 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761763681.git.m.wieczorretman@pm.me> <da6cee1f1e596da12ef6e57202c26ec802f7528a.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <da6cee1f1e596da12ef6e57202c26ec802f7528a.1761763681.git.m.wieczorretman@pm.me>
From: Alexander Potapenko <glider@google.com>
Date: Mon, 10 Nov 2025 17:24:38 +0100
X-Gm-Features: AWmQ_blSpUzzxuUgQTtcq9gjImncZd1NpVlVJACeWgHgjGc0p5BSkakhSm40GYM
Message-ID: <CAG_fn=Ut9JUpStLiO+GsoBpn3d_EyyttcuBby=EKzuxkKdcKcw@mail.gmail.com>
Subject: Re: [PATCH v6 10/18] x86/mm: Physical address comparisons in fill_p*d/pte
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, 
	kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, 
	ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, 
	morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, 
	baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, 
	wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, 
	fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, 
	ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, 
	brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, 
	mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, 
	thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, 
	jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, 
	mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, 
	vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, 
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, 
	ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, 
	maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, 
	rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B814D8000F
X-Stat-Signature: 9yzapyffb5c1shf3smx3bqy7onm47krr
X-Rspam-User: 
X-HE-Tag: 1762791916-61762
X-HE-Meta: U2FsdGVkX199OR+AD0etIxsPKnyvTVfab+3xYBvYR6wzeOdauIJSkScwUAsOx5YXWH7y2tVa3jlcuYB2O/SUQYrQgzCAr9jyc579jsAFfIOPskLKoPW10MXdhtQZ/X/fpfY+64iHmvQYKWcMld/PY1Lfj8pVryw4ZGZqXgUKUUYsjXnMW6tdTlCZNu68Sh179Kr4EOEP4FEiNXAphiSO4zzZU6RT4rq8OzZjNkocYdugYyoyf64+Vi//EGqknimB5hFAQV2cmA15fEzegEXEuZ+AVrncDESw2mgd6k5mSVXdXi1lezYnDg7yS9O9oClYklXDKLL0XdtUMmHXx59FKnzriV85oNzeXVdRc/NG1/4WOqTT0wlpzvCEs7U/gN4lPdDjHPNbN3CXPGNbv6PMGlxmqljJJHR/P3lknCdfrLLYdHzC2UutstLaJehLnL54XVxdTdAwEQH3CcC5N+YvqGl7QRveHUmLzqLG8P2QnD9oubgg91GeOW0fNeQ1QC9BJsWc7W5Q8A60H52VMGRZjISO5M+1FbbP5/Z/lu1oprR1bli99fQtA60/HkeZDM1hVCzXgCnUMJk3LxOWc3MkHf51PcU/SE6lQhHlQ651M+rHQtmFT+FJbC+XqdS7VTm+M8vmxYoE9qsyL8mb5pirI3UyDBD8DAvnniNGzRT54Lr1xyG5V5yYyFWZwZu2r5u9PNSWiBTvsQnjEyH0an3bT2lQBZh9lrsX1MlmgQWD0HEsOIKYEgXJ6gYFNulueMgj2ujzn84H6R1OWNJiaafGYqW/r7k2N2Qe7aiJtcL8XhmMANXWXXHEqIBgo/pDnjmn2Jjk6QXyOAGJ1YwalOyxjWDYX5CKS+vchgE60/xdBGhO0jzALB0yY6lSRDsGugL7hHATzFy2EOuKrf48Qq7rYoMKeoVe3REIoujEKYyu+6B/KX+JSbw9Q/b/fIGpy0Xqg7mtDXoB+MbHHICoCl4
 O5nPAQFJ
 J7Yv4yu3stkpY0OpJCafESqRDm1k52aphtvwCp0ZMzhaY8QMKYS2a7BPDwmDNJJJNmrJcW67F/vHcMnKx4X8wxpICFMFRrw+2JQVCt0XoPVDd+7v0GUliCrnmD3DNewcZ9fhcm778//oWicjoIS2tPrnq6Uuy5uZ8rtdxCTXX1dGU6Zm8MnACXAlHsXZF0nc/Xkx88oa5jeJRk43bWsrYTylacpVlfFtC0/Gz0NMVGkTZ6zQHEmagc+ohXsrtXpLq02HttmwnSeo/ZpjrOKgsOW7adMdQDSTOrGFxEjLsKQJWj/X86wA6wFa2KHWRXqoO4U61/FqIXRJFrGpg/ujlgU/71G9Aw8rb6kXhhpOR2/4Uk5fmRoBECs5p7A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 9:07=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>
> Calculating page offset returns a pointer without a tag. When comparing
> the calculated offset to a tagged page pointer an error is raised
> because they are not equal.
>
> Change pointer comparisons to physical address comparisons as to avoid
> issues with tagged pointers that pointer arithmetic would create. Open
> code pte_offset_kernel(), pmd_offset(), pud_offset() and p4d_offset().
> Because one parameter is always zero and the rest of the function
> insides are enclosed inside __va(), removing that layer lowers the
> complexity of final assembly.
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v2:
> - Open code *_offset() to avoid it's internal __va().
>
>  arch/x86/mm/init_64.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 0e4270e20fad..2d79fc0cf391 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -269,7 +269,10 @@ static p4d_t *fill_p4d(pgd_t *pgd, unsigned long vad=
dr)
>         if (pgd_none(*pgd)) {
>                 p4d_t *p4d =3D (p4d_t *)spp_getpage();
>                 pgd_populate(&init_mm, pgd, p4d);
> -               if (p4d !=3D p4d_offset(pgd, 0))
> +
> +               if (__pa(p4d) !=3D (pgtable_l5_enabled() ?
> +                                 __pa(pgd) :
> +                                 (unsigned long)pgd_val(*pgd) & PTE_PFN_=
MASK))

Did you test with both 4- and 5-level paging?
If I understand correctly, p4d and pgd are supposed to be the same
under !pgtable_l5_enabled().

