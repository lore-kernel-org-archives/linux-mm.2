Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8E9BD2F339
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 16:22:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2115F6B0089; Tue, 13 Jan 2026 11:22:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF7A6B008A; Tue, 13 Jan 2026 11:22:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A18F6B008C; Tue, 13 Jan 2026 11:22:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB90C6B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:22:07 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 861641AC83A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:22:07 +0000 (UTC)
X-FDA: 84327457494.29.DCB82C5
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7539240010
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:22:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SCYWRlln;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768321325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CL9mqA+L5ChBc4KUhSETt4hYPO2nC8ZfXtH0nl6Jj08=;
	b=gAA5KFnyh/vl3DocDrG91QWwTpdjjwW7WFrLmydCI9rQXmUqwBGBBFi4Ybt7bqGR3DFZ2T
	D67htdief02A9Tvm6OPZpKzCcmJNyniMn27SD6z5FnbP6gwcZqiZhtx3BtKJvYvmYs+KqD
	hswBwJ5k9x5dRNwdoU8Rz03lynOLmy0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SCYWRlln;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768321325; a=rsa-sha256;
	cv=none;
	b=QCP+ZHtdiNSpOPE42j7B4oMCHB8dh9uFu3DEu1gPd1za/bvRyHOmQw3brq9iqAAS00uY6a
	1QAlTKV413K6UysbsW81FPPFkY93SC6rncsyCLxWXRNn+zlka/dY9abrevXEBsakmexnZq
	FcbCCSc6SC4kWwFVUIjD6MZIqXoN4kI=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-64b7318f1b0so11078846a12.2
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1768321324; x=1768926124; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CL9mqA+L5ChBc4KUhSETt4hYPO2nC8ZfXtH0nl6Jj08=;
        b=SCYWRllnYJQ2v3R7Qu00kpt0FEN/rgXYm8qu2+vOUzu2U9tO36yfSWfqs0L3tMpoyZ
         20c3yFGPDqVO0QJOy1TZALYGr/sEhrkBXaB1Nzafe5qeddK6EIR61B5hD40lPUGP3ZDO
         /ecuPi+DqdeDApZr8NkXZT+Tfi7nDdVcJP4jVVQeClhaSXz0OG5p8U8KHc0QFPDLcE7k
         wv8AI1+McinUKY5T4iXYGG6ysuWm7dCAMbxf7WhVWKwoxc0Ntb00Fktuujhu35t8NrCk
         yaDaMsJWMCo4a1V7rLlGUHkwalU31xPhjzblJ+4uPDN7onjxO0cWzkTAatRYgTY75cZh
         2sMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768321324; x=1768926124;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CL9mqA+L5ChBc4KUhSETt4hYPO2nC8ZfXtH0nl6Jj08=;
        b=YOQH8z3VdlVxnQF38GXC3ZNFO2fDSfy1rJjzEHcy5yNjiFv3vOzSCllqSWxV84UYIh
         Y5ew+Dz1T46UdXyk6rzX4r1Wze4B0EbnBWDJN/SOiPvL+vn2+6n0Ok4WOVz8E7MOy9zm
         oBJGioNchLfG/5+1aAUTUMARZd4MU4KLfn9CVxQwq3NjzKVNiAMGU0HZThLbKbAyzaV0
         ziKRTbiWBFPWimFFvPwAHtUGH47DMDR5Lx2lN4dx7ExTEhw6goh3hGcV68KYgOENTKQI
         EQfkMc7JTyzGkwmmuFPWRNhr1D08Xx0UE6KrKZdB3BtDWqtEP6KLODApRDjFEHfViesF
         LnAw==
X-Forwarded-Encrypted: i=1; AJvYcCX+fHsBPFx3rak24mN9fnNbKQcjR+mTyA4iHMWOM8LexS8beugaqyzg4DhKywvn6zMwPH7Q+YMy2Q==@kvack.org
X-Gm-Message-State: AOJu0Yy0JGraFgysBmZdtsEZZQGgItR2PYFUwuzsH7HKIB1Ad1RQubG/
	bJgQOWepGsB4Z6NlJBDv7iCexh+IaIeedUD0nj3u2JRJkcEjAYET2lirzTTMpyyUcw0fsqsALwG
	bItMjMSm80WBiSt4mevKwrTVKPz2ZqBMiEczjicNjNw==
X-Gm-Gg: AY/fxX7s+h2tTtrGT28eFn3Cd3/lvPaYz536X9cXr4BXtV2bkjcCN62aQmmB/ZiM22m
	MwIDvuYc2VNiBYN4MAzbyjT76BUP3Xfe/5p8n40SdR5icn2jIOrqTlz3Mi8moktueptMyN1o31I
	4NcyfD/io3EcgHR+qQZZn39LOHP2llIn7m2ijlviWvlU1v51yEXw/Cnp+YVNOtyzKzTh8BrocIu
	rS+CHf0iwxiOCA8JOcg+s/c1alF7gVSk1c4apywJpQMNSruD7bmoCOgHGTnxVqwQ/9Msf0ioe3I
	UimEMylxkJP4IFxtqG+UOSJBPg==
X-Google-Smtp-Source: AGHT+IE09dEuw/V3YD01k0td3WIxhGV8UT0oz/yQ+pLP1I2+bSDu0laME8BHispRCz0saUuovB6LZomX8UuT6DU+VTM=
X-Received: by 2002:a05:6402:50c7:b0:649:815e:3f9b with SMTP id
 4fb4d7f45d1cf-65097dcba5amr20365112a12.3.1768321324008; Tue, 13 Jan 2026
 08:22:04 -0800 (PST)
MIME-Version: 1.0
References: <20260113033403.161869-1-ranxiaokai627@163.com>
In-Reply-To: <20260113033403.161869-1-ranxiaokai627@163.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 13 Jan 2026 11:21:26 -0500
X-Gm-Features: AZwV_Qhd1NUaX74PyQKfMs_orfB5NGTMsZf295fX_SYz96GVd1njvy0k-ruLXJE
Message-ID: <CA+CK2bDmfuqnR4SuMSgLS43e=wqM9ovu_VBCYDCzdcBaFJW8+g@mail.gmail.com>
Subject: Re: [PATCH v2] kho: init alloc tags when restoring pages from
 reserved memory
To: ranxiaokai627@163.com
Cc: graf@amazon.com, rppt@kernel.org, pratyush@kernel.org, 
	akpm@linux-foundation.org, surenb@google.com, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, ran.xiaokai@zte.com.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: zxjpzs4eqx3fysrdqwkhoj8q4tew3p4z
X-Rspamd-Queue-Id: 7539240010
X-Rspamd-Server: rspam04
X-HE-Tag: 1768321325-459303
X-HE-Meta: U2FsdGVkX18dsZeJ3HGBgCbg3S/s1SphP49tpTUTh9BjadSejxKVvaKGfoL50FLjar4LN/61gpb6KEjRjWCsrPbQhcZjRNlOYNN7iAwliP+Q14aNzUeGG9kEvl7fnQQx2xZ25OsejE3rhet2FbNTa50PPq69z8VUsy9KSMD47ii7ZH7qcKE8RMjwW6APsmJZ1UPzEekmP2Jz5iwPGTVu5xPBhJuow2QQQemzcac39LbFD7CZ90Z4xvjCs1NyRtBvqbMoK9OyOmBhO1eQG4vbu+RaM9NCa1v2eamsveIR5Mz7rQiNivHRlBO8UrVsXQTcYwxZG0nrqanVPv4PNQ2upPhjaVNprB/FSk3Vn/8m7J8djHeBiUIKHrXJhLEJrkik+bP8Hr4gZJ3itdE/DXg7qpOf55CqWDKw/4GORamNaEWpzw6AOGnigGdvtFmNAjQGOrpB4BqJC1icOistD8XX9tKTuWHBJWvhiLuX4z9gDj0AIhNhaEwBGKtSogkZEuGAxAxWyF3oT0V0dB/w5oAzG8BgvMqOVKqS11CePRiQFcv54DjvzMzeSFuO4Tk0iebvBtxyFH5cuSAeM29GLyyXUGSzfC34P89BOlq0PBFUjaUQbgnAGCGsM8/9+0n7YYW5gUS+6YxlB61XZpTsYcKSUfbNAprnGtfiVXxGTrzQ6bjutem0Q+gHGX0Eltv5PgjyQCPGAey4CBQ4DJsnFp00+m54OWRuy6D65g9H3YuT0wEyK5BZyNEs1TFrUtEjtcRN6yPhkqkipV1cFw8iZA1wDfpZ5t1QyhJfmYwmvnhhJwJOfPc7lA+3EJy8qCjMGR+yfzd+Jyk/nX1C5YrSBaT+r1l6C8q61sKgUfY1KBoenikbR/oPQNwjYtXUro0YV8doFySM+pLBw4I+8Ie04uFI0dVabLpOGdktzM6sXWpkv5jJjkyc5QAGWX1A9dROxhOlN/7AasagnGzw0dWPThf
 VL/CkpFG
 JIEMxcCLIF0b9I4SnSMHZpuJcTmgT/qukRZSf5GuBz1JxmuLhWOjZhhHrqtuIldMbwMFYL/lcGZ43GH03tkmUbI9YJuMx/JpVaQ1Ws4aE/AlLxk2P6PcOkQI3EKrRSVFSrHTN0TG5HyEO5SDq4I0KDvbMzgkOPDkWcv3+AajijgQz3bfnX8DaSj8GmOTqTK97jgZSzHYVTCkGlAzb2elISZy5HUhMxkmMRjoX6bMVzGOOJRNUmjmHdnhtHgdE6Dl9Gb+YwEo5ygQSQoLYM11xwkV2Xy3H92V2NJXs5lAuMNkVDx+kMAgLBmooxlbZ4/ozCEy56tqsE7o2LjngtrJ/eclyXCcf0+UZuY5c240YXkHC+G5Vx9oinC3zdFnfZW/PYM6PkN9Kl8JErjdKGJswRwtZhz228VZXI7Hn2r6HQrQMTglNZBqXn7EXXYX9q17ZtKjYIlkKratDJ2PEHFM0gbo6kw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 10:34=E2=80=AFPM <ranxiaokai627@163.com> wrote:
>
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> Memblock pages (including reserved memory) should have their allocation
> tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before being
> released to the page allocator. When kho restores pages through
> kho_restore_page(), missing this call causes mismatched
> allocation/deallocation tracking and below warning message:
> alloc_tag was not set
> WARNING: include/linux/alloc_tag.h:164 at ___free_pages+0xb8/0x260, CPU#1=
: swapper/0/1
> RIP: 0010:___free_pages+0xb8/0x260
>  kho_restore_vmalloc+0x187/0x2e0
>  kho_test_init+0x3c4/0xa30
>  do_one_initcall+0x62/0x2b0
>  kernel_init_freeable+0x25b/0x480
>  kernel_init+0x1a/0x1c0
>  ret_from_fork+0x2d1/0x360
>
> Add missing clear_page_tag_ref() annotation in kho_restore_page() to
> fix this.
>
> Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

> ---
>  kernel/liveupdate/kexec_handover.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index cd6b3fb9dcae..2d47f2c50bd8 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -268,6 +268,7 @@ static struct page *kho_restore_page(phys_addr_t phys=
, bool is_folio)
>         else
>                 kho_init_pages(page, nr_pages);
>
> +       clear_page_tag_ref(page);
>         adjust_managed_page_count(page, nr_pages);
>         return page;
>  }
> --
> 2.25.1

