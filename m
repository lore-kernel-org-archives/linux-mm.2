Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BFB1F53D85
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 18:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C71D6B033C; Mon, 16 Mar 2026 14:23:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49BB86B0340; Mon, 16 Mar 2026 14:23:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8896B0342; Mon, 16 Mar 2026 14:23:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9776B033C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:23:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2FE713AA77
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:23:04 +0000 (UTC)
X-FDA: 84552747888.01.0E75570
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id DCB148000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:23:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BDqUsdzs;
	spf=pass (imf30.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773685382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rq0tOO+dj1//VrvsBCgXZjoN1LwX8pTcrsD14x8QFQM=;
	b=ZPkb5mb59qmF/qYItPG8uIEwT0aZkuC3FjGwfaWqJKHylXXX+G10aFfHUe9EIvqHhkNIRV
	bLlwzFRz7LnSStQORJBmkWXhGjJHPOZ8i9O87yvgwoFGMTm9NT2ZJfaHOShxqwPaQ9fVpZ
	gg4Z+KreBJWUMWbmmqCzfod55RDKcAw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BDqUsdzs;
	spf=pass (imf30.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773685382; a=rsa-sha256;
	cv=pass;
	b=QIR/FsO7+z1EHfj9CUWgZkxVdz3xFCdxUiWBLa83hRLVKEgiT215q07xcvvU4b+ct44vLb
	yT9uYlrwJmMIGhyFV9/4pCWerF3csE4qgYaIS7On/oVQsE9PIDfD5xfsgnAn7cByntvITM
	RkH0vGQh/R9WGU5wQh1nXKGbHodCSn4=
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-2c0d36f3888so488378eec.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:23:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773685382; cv=none;
        d=google.com; s=arc-20240605;
        b=l1g4Vm0IsMpPJ5EiX7eM6S7bsMqlqg8hCQF2UITsb6QTp7pPIvbyKCjPCKuNQL//Np
         2gdxTFeJtblukgCGdLRkqr32xd5Fukb/dCCZ/7ckGFjk2HCsssnDEM/8sWM1UlMmYNk3
         NIb4i/LYvEAo0G7WAivgrzZH0rtolxdCiPgLucSECeHPT5BUmxPsOI+sWJ+noyQftmYn
         NKGM/sNcyodei3Yr+2xTVDAZN0cRpDrJgPM++DvGDzX/4BrHuN8RaM5+i0rDhBtm0JLH
         Co1/ghxTvuV+DjPXPs/NnDrvK57E52OMwEikqwqE2FCL7hflnW+TNWKITwC8P3Wp2nW9
         ao3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rq0tOO+dj1//VrvsBCgXZjoN1LwX8pTcrsD14x8QFQM=;
        fh=2QGGvUsE++yPQX581ZWu8W6o1MS+Dybgt4rXK6NTp6Y=;
        b=E1LGrLdYrXa2vdhwe9HnoN8x0G34THi6IXc7NlJbQ8r2BsMyVyeC9rxX6OIR8R2KaW
         C58LFSk7ibNvr9sCn1B+j9dYDZdS4r5BpzWhfN+Kt+79C3Mw6fmvZCAc9t2R+g92oAUN
         FkTeIzw4CoOA66qgip42/l2E2czr6v0MEMpaaeGWdQOQUw8Ar7G80SlVVesLU42b7dAr
         W6bt+Qy7y1sD6j7iJ+qEDFf2J1ILZM7BMmMUOgeM0DDvV0AKwjUp/QxG0RyqvRmbM+ol
         NTzH/2Xt6NMgtJm+PPwPv4Jhk1joL4ICJ5L4KPRwXlue24ICELy4R69c61iL0OY/aZqM
         OMmQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773685382; x=1774290182; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rq0tOO+dj1//VrvsBCgXZjoN1LwX8pTcrsD14x8QFQM=;
        b=BDqUsdzsm3opSGnEXOgbeZXxwPjFKBdqV9P3jy/FJM+kRN5QjD5M2MBoPPKDUhmH6J
         mJG11Fqhe0lYmOOSmfatvmwxorRJL6iML/tz8Jw3PV6Jn98nJ2dpmSKNgYJahbCYP3bx
         muza8Cdiy4e2mEPBHD43/VLEcEwbUDfZYXgkRdkzbWjj1Qz+6mwJ7lSZLCMSDirliyKg
         N4L8gxu1LfBytM8tHkIP6jdSnBoCYhcN6X5DDvEyoWyBNxTg3hddqfsI7LOVq8fDT06N
         vaUlzF4quXZpdyKQ44mbsxfzIlEExoHoLIB5lUWII2Pn3FGqHjtvNa7MlaZDMaOIBBqI
         hEFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773685382; x=1774290182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rq0tOO+dj1//VrvsBCgXZjoN1LwX8pTcrsD14x8QFQM=;
        b=dMcmBnVwkK7tjDLMIImN/YBUHVUevDPj4SW4zzsTtChTOi/zuzbTP2+AKlaQhMSnso
         sWniDO6df28HarLV79ROUYOF5cc5A72X9xd0gaiUWmMCbIGfEOQVJZYP/9ngdLWjq+Rr
         ildDtTpIS2CTfPKiW9afj0bMhMYLBcOchCgSUih/WES43GLlYDjCOaK/GzBmQPkM7/7I
         8xFh23jJq5PT0DJPxbvlhIoLdfosgYaZKgNyXL+VS1aK2TvOMU2DmqlwSUnAGxtm1JsJ
         QAzzDpdLWsQkoLJp9sTDaRCjkrncJ7mbnp6Sjh86xnIbmgKz9IFkuE/OzcTipgoEo5YL
         w3QQ==
X-Forwarded-Encrypted: i=1; AJvYcCW3D1I36K8bth6xUYBjvQt8VI3NqK3QJK/TNQHzAoCn4LtrCW+52Yod8cot7TXQRP3Eaa/vA4wB5w==@kvack.org
X-Gm-Message-State: AOJu0YzzV1HVd4tJPdXb3ihvJBjuAuhmvoTa3rD6cCwxRctd3P+n3IlQ
	fPwCrx/qlrPXHvYMN034DK9zFdUmO/u5izM2pgO6IX1kftrbCmbge9y7LVXdoJqTIBf+Grv9cOa
	fpl6Vq1FoH0zXrqOw8mBp4GMpX/XqDEI=
X-Gm-Gg: ATEYQzwkUIAqTR//l4M2Gj6u2xPwYhFYZRoXJsl3PKxobMzmfqXnBxLVhqfuoF4Cr0f
	cPHzxc9aojnf77DwvAFJis4vbih8Ba2A6AuuqTzhSCql1BCBMwhs2wkevCUyBA9ji1qt2mfsgp1
	LuUMLmWGFKSv/voeSb4sCYGWiUpVEnK619r0162ioiiP/2Nvoq1zpMupJm4zTZ98mDWI8/gkzPM
	EGpfMT4R/G+Ti9r3CO4fDNI8xhcIpDUXcgNPweC17eaz2uIwxoI9BY1d+uzCl4vxJvvO5gqKpRu
	ZU8u8kttCDAeLPI2NGuWy5zo
X-Received: by 2002:a05:7301:2c89:b0:2be:8da:3207 with SMTP id
 5a478bee46e88-2bea53ab887mr5936824eec.6.1773685381593; Mon, 16 Mar 2026
 11:23:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com>
 <20260314171150.fd6a80a8f51a5390144d20d6@linux-foundation.org>
 <CACpmpodjsMELCrJ-QX066CYiGgraysr_ZhFMvU5N-6nr2HsRsw@mail.gmail.com>
 <abgbx0YXbxu2mAHU@google.com> <abgc5cn8Co9ft0Wr@google.com>
In-Reply-To: <abgc5cn8Co9ft0Wr@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Mon, 16 Mar 2026 11:22:49 -0700
X-Gm-Features: AaiRm52iiXFiPEyBvKWl5vf4gWzYwQb4JuEsIcoEKAQxWfHMktBPshpXiL8azRw
Message-ID: <CACpmpocK524uc9ws1oDPwE7XkOntCzXJmOv+0mk8Q4WisGaE9Q@mail.gmail.com>
Subject: Re: [PATCH 0/2] zswap pool per-CPU acomp_ctx simplifications
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	herbert@gondor.apana.org.au, senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ae3rprrmyrga91yh1oi3jw85a3bwy7jd
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: DCB148000E
X-HE-Tag: 1773685382-215532
X-HE-Meta: U2FsdGVkX1++/rdEcUMKrZq17c4RLYQf816jWgRl46DzZL3oZ5s0o50bJcRLELWw3UQJHEr4f6VFCsivokR32oqutSbUNF276PKlKFQWS6dfFZqOcmDxzCHa5B5AHdRyQhd7kd5VaANN290ibRmzYVwaNu8Q2lbi7P/tbKHfV47MqDE7RgmRWriGEYnrZoThXJYxOGH3DLLMH5uTnN3r8NuqXMRRd1UwMVx38GYkyuQ/4U6s5swCKYOPuPS6bF3QcxNG30wiYstfIo/5YkW2A4zEMqzgeHAukAgQbKt+aYxT01IOZQ49SfYCbCLi6qNPrX4KD95x68xq11+eMRn7YIX777JSIa1dZi2lBK/afaW6jlydWbZgUf9JrSM/kJp5l97YACVDFyRdh8AWL0+mx1cw5nxYWMe1hlcDZVYbn6BncrEXlv+3jOCqmIU6WRpDPdlaoYwTUI+8fUWErffjs14D74kpyWKfp6MSOKG8oWBFknVUt+gMhDcmJgD2/A7MQJs8ezv4x66jWi+6cygHcHyO3fksdda2lNxWHsZx1kwm1ItbJK+s+l+c4eXl9CBUqiIQxj4+89pNiLS47OrWp+YgL5UKo5RAd9EoK1aj+zUcxlM5b7iFR1Ii1vPK5HGY6Bh1UZ5aeEb7wawRtPtEWNUGWR8mVdvNl9z9hVosZf6qoqjwl/s/Dd97YB9r4zH+pHXqE/eI5pJKXevjtVHNaVWJ3+v28OxdgsmLYxkS2WVGg+LUB8c7eAuPF6zB42wWpCg2vUxwvINSRveG2VK/JdXUDUcVO2+MraPrufmoRYHR0qJDhKJWxyeYzLh7FffembqAxBugD4Q/5RAyS6kKFtt+qRTW/X72sUG5qjjSFhSUplrCdXKp0fa+BWKw3mBzkGdO8OIArVLkxpjk3AgDgePZ3vzjR1dMWHbAwzZpPMAP7M7L2jgHqWN9oFwhHUa3AdGwi1YrtCIbGZX8KKi
 DbHbyq93
 CvkcoDdiYTAWNi+QAmo0INBDS2JixI9boDN52dbc76foYxZwTBc78YNey7VTISB+Zp0JVDywiwNhwKXWQjtUZWd4Xhync3ffIbeXWz3lJPUgjJJHWrZ/4tkvxGBY4gIDCV53YdJf1AxwiGx18Eyw7b2FbKUtlp47hL3JnAF0xajHh9TMOJRybYyVsB7/TsLjUwdDMH0XEZBGKLn9F4TyI9TzxqmgPx4eyO2hJ6V2B35V0gy2ACYLBTDFwBXz5bV3f81JttLRyrfr53AJKtoXjBErcdgB/p4xyqLJYYUq5qkzRLbAZoZ7N2rKdfY4r67rOpso7nSk2EdpGklAt9Gn0FaNZ1u+UNr7b5x4ru1z4ynIr0MzxW/xFkzFs2IQsA8NoPU4lzSIhqtAPXysXaHbUs93WMYEBSW1XkdVLsqN9SmdlqXl4BETk2pqZkek6Ud4xmcAu5Wz8eODuswG6Z+Zd53Srag4Go+/QMamKzMoNfkc1G0XwkdzE2h9F5XjwV7VR5Crge1tbhRZ0c4rk3DnH3/hkZT5kRcwv0kGmKtUhQnTPmH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 8:09=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Mon, Mar 16, 2026 at 03:06:32PM +0000, Yosry Ahmed wrote:
> > > > > @@ -786,7 +786,7 @@ static int zswap_cpu_comp_prepare(unsigned in=
t cpu, struct hlist_node *node)
> > > > > return ret;
> > > > >
> > > > > acomp_ctx->acomp =3D crypto_alloc_acomp_node(pool->tfm_name, 0, 0=
, cpu_to_node(cpu));
> > > > > - if (IS_ERR(acomp_ctx->acomp)) {
> > > > > + if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
> > > > Does crypto_alloc_acomp_node() ever return NULL?
> > > > Looking at the error handling just below this check, if this were t=
o
> > > > actually return NULL, PTR_ERR(NULL) evaluates to 0. This would caus=
e
> > > > the function to incorrectly return 0 (success) instead of an error =
code,
> > > > hiding the allocation failure.
> > >
> > > This is a good catch. Just to provide context, this patch was
> > > introduced based on Yosry's earlier comments in [1].
> > >
> > > [1]: https://patchwork.kernel.org/comment/26282128/
> > >
> > > crypto_alloc_acomp_node() currently does not return NULL. However, it
> > > could, in future.
> > > Since the rest of zswap_cpu_comp_prepare() dereferences
> > > acomp_ctx->acomp, it depends on whether we want to future-proof the
> > > code to handle a possible eventuality of crypto_alloc_acomp_node()
> > > returning NULL.
> >
> > Hmm upon revisiting this, I think keeping this as IS_ERR() here is a
> > better documentation for the API, and the incossitency between this cod=
e
> > and acomp_ctx_dealloc() is arguably documenting that the function can
> > only return an ERR, but it can also be NULL-initialized by zswap.
>
> Also, sorry for leading you astray in the first place. Looking at this
> initially I thought the inconsistency was confusing, but looking at it
> with fresh eyes I think it better documents the API and the different
> callsites.

No worries.

