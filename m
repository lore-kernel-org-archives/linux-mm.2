Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D47DD6CFA2
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A84F6B02E9; Thu, 22 Jan 2026 13:04:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 580166B02EA; Thu, 22 Jan 2026 13:04:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B65C6B02EB; Thu, 22 Jan 2026 13:04:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3766A6B02E9
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:04:31 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E92B71AFD58
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:04:30 +0000 (UTC)
X-FDA: 84360374700.27.FDF3BE5
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id D6F88C000C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:04:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IDUFPCgu;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769105069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=99ki6Hhq67MHdhcohRnEyhf3o01MAY7zm2rO8p0glWw=;
	b=A912QeOg3gbgq2I0+Jc6MdHMhkeKF1qBzHgjMdMOVZjFpCel81c7DYi478mxB89PcE/Xew
	2ZsZmFhW8k62w+gKCbZ1/3VWikO8FKwpMkt60Z3He2U9uGYLceljbY4k4RAyF1pD1nL8XR
	FnfKL1T25jJVXKDT2XxcW2tK2mffzeY=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=IDUFPCgu;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769105069; a=rsa-sha256;
	cv=pass;
	b=ZjVhlFEG6RX7XeLP6HEvBk5ipKvv5Z0YRoKN8ppivQpwVxce9mPYWHVD9OafTlisM8ZfSt
	A4J0+RwKq/z3HSVaZCeDx45PQ0/dMKjR+hjRRfXNAvi67TRR+DZ4J7iB0xRmADLH/xlE+v
	AVZIAO67l42whNpXkMaMTfp0YrQqyZo=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-65801ce918eso2680186a12.2
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:04:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769105067; cv=none;
        d=google.com; s=arc-20240605;
        b=YuZY+tm4z7icEe/y7rTrK7IBvuEU2bc+Eh40RCXcD6jnHbOKCL93xGP3qtncQfZJYn
         FrUpl6PDjbuG+UArIwm/eLBCnrKX++78wfJM0Q3DLKdNyDC236ozgyEJLHos4QpKRJdT
         3tl2WI6nXdeg9VcopBzVkussNzOTTLkM3CuXC4LeAXFsDNH5scgCxaua6ZjF3S8jUeFO
         6YcnGJ7goNCtyTjkpeUyaenHqBP1v8qhGzHGSDzTNYDojxCeK8B9lPa4eSgw3/RnH3uR
         b/haCF+Y4UBec2ZKahLRPawnQziqobOhBQMFbznXWF6+JyFozeXvbNIu7IMxyko+gT9a
         xxMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=99ki6Hhq67MHdhcohRnEyhf3o01MAY7zm2rO8p0glWw=;
        fh=HsqgEbrgonPLaiArQ2gMLaJPSqdnYz8t7lzqh+Wodc8=;
        b=f+xvzD18xiovWPNkBorn+PRUsz7geYlPLOwzTzaswkgn+cQc6xcfyw/6O2dM6nkr0I
         RWWDgxtRpVIvRuMDmSD9qxy6tKMvdWDrjHS+x+O8ddDoTt/fjlV40uNYPHtK1HZwZS5H
         rM0ik5I7w7ZDugC5kuGFqA2arDYHFr5RlQR+mmq2Q+dUqOXFXL334I7M3xy43pepNk3w
         tjV8rlYn1MVIByvLz1m3G6L7lY7KHltQoHr64IjQ6HPjiCa+LQzaD5S1zblIM7uYi7uD
         RkPN7BKm2F5oJKYPjpB76wgQHfy6YOd27uHxk68QDm9ionZ4/KVoFKHnsMgrebWpuiqR
         QC8A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1769105067; x=1769709867; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=99ki6Hhq67MHdhcohRnEyhf3o01MAY7zm2rO8p0glWw=;
        b=IDUFPCguoiCD8RnXbSUBCuVpIGLy0RjCeqbYiQqX/yvWYE4GpLzVe6Z6HjrRBGTecS
         NWqYFxNEjy9urqFUcbg0aU3msVjHZNiChvoPC3dUef8LMjOyGo03yywOVqtngldY72tC
         dw9bw1bRwce6yIbENLDq2r6+0xsArwoKAqow/KIIDupxJYFNpqIZBr8c+Rbq3vCPvb16
         nyOJLod9MHImG6C9CFfcg2VJ19NyeuncWTtZEjiw7/Fe1m7mJRMzW1YIsn3pw6fqx7hE
         9jccLKjsrOCsO6ETJ/Ei2+NjA0k812kiNyNlNdImugjtny+lgEZ9RzUDMTRPDI8acOeD
         WkQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769105067; x=1769709867;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=99ki6Hhq67MHdhcohRnEyhf3o01MAY7zm2rO8p0glWw=;
        b=eyACeJJGDpkNy3bWj3HzCqE9WZi4D/1djLjUM8gbU8x28r32Cz58zGdiVdLuJ9aEDh
         dMK7LrmV13b5QsFHSoXvpDcaZfHzEmodklWKj1D7uckp/GqrhwgY8DeP3KIspiN0QbMe
         1Ddd2M2B9+dbn63J1OqswqKUt8euUHe1rMNBU+M8155wUDQSW7iZ1sDXN0MjP8MxlbPF
         lJL5huve4Db4N7yvYIM5sWIE2n2dHUSyg0MyVuDUpkQMEydP1KmHUTUis/DcbGswpa6Y
         p+C+3JU5nQyBuf3Dnit9vwRpY2P1EKTJcmnPlcveHzry5vP1k2DDjTLd9qIESbSv8Lrz
         mTig==
X-Forwarded-Encrypted: i=1; AJvYcCXGfsPkyp7mA7q7qbG4SJFuTJZBcNhNpG1pY59SEzIm29d+rOC21Ts5UPxQ2+UuY8YsAUdUAzXdeA==@kvack.org
X-Gm-Message-State: AOJu0YwFIXDvb+rAFxV4W3ZkcJtbOzywdswS51pPAznLVPeBfJnsa3yZ
	1PuK005yDDq+NQJLBGXK1EuiZFU6Nr+Dg81d5TrKtuVy/lL5mJAuD00OmpPb1oyDMW251hr7etm
	NDQVI2fWLFfYvqSKNUrsIvAo4EV07vvVII56NXOgGCg==
X-Gm-Gg: AZuq6aIGbvjFcWpj7qjq6Kh+aQRRBGHXPst6vtQGlyjwB26mmvIUL27XWJXlbr2wIuo
	OPJOFyxYH2QXth4Mwz9OoL4bQ1vsg6JC/Jn94X9QdiS4UbM3N8GC9xPUQyhqF7LzyAjA6VhAot7
	37LZMRBCYGdJuwRsRHsSxUcI8D+dHeONX/LB7QNSEt41cKpoEdPilr8QOUJqe5xSr7nU/1sBBF/
	dUZTPL/BNFkY+iTxQHLciPu23tRcBosaJy4sOtodvSBM82LQ9lREayU5hE/CzuY93OiKbpIzEkM
	wKEFwqkDdLAEFmRD4wqwinxTYQ==
X-Received: by 2002:a05:6402:50ca:b0:64d:170:7976 with SMTP id
 4fb4d7f45d1cf-658487a15f3mr312505a12.16.1769105067085; Thu, 22 Jan 2026
 10:04:27 -0800 (PST)
MIME-Version: 1.0
References: <20260122151842.4069702-1-pratyush@kernel.org> <20260122151842.4069702-4-pratyush@kernel.org>
In-Reply-To: <20260122151842.4069702-4-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Jan 2026 13:03:50 -0500
X-Gm-Features: AZwV_Qh8nx4t08z9lAWZN6PptbPHg1a29tTBaHuW3Q-TyEfYXSBvmXkqgSAOoeA
Message-ID: <CA+CK2bBRGo3fQJ9dYhGHzOZU9hhLX8Yc=BjLph9HG6zuk_vE5A@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm: memfd_luo: restore and free memfd_luo_ser on failure
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: pzzz7udc3yszkrn5p6sgftete3a3fs3w
X-Rspamd-Queue-Id: D6F88C000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769105068-231659
X-HE-Meta: U2FsdGVkX1/k0ukVdB7LQxFF/3O4GbG5WAxCsbmeWmYulDgn1AJBdjGNKfaCqONB8F+6tEsXbP4A5HclAWEW2MuF1yZnQMC1nFKaHkcT5ZAPgTB6flAGMn+eN3Vsvt5xE+9BCAyrEHe4ZOzh7lGkWkGLFoXK+/xJ0qFhf9PYVNq2M915I3udG1cPfJwbbzaPWIIy8P+mI0rEjWDvDSciacdsSC1Vs0LvKKQTKuWg3YKfJgSqNE4ana8FG1h/WPvva+Vg7fk3ZjTBQip836Im5NvrxrVJKoHCDc09UTAcwyipkDUR2RHAtejylgtah4URW+CYIgX+H9YIHBBCD8gEJRHMEKDEVs94YS/eWE3RmX+GfIEZXldHGfi5TTC0nSUkT/zATtg/jFBhGBo4QDl38q/SsvqOxAlmKV8ZAPX02GjLOUG3VkNre/NdcGHOOtpgF4Liv4LP4pD17opYaY2XfIYe64INSkgWpb71m2CNhUMr/Ay12eIAoGvxguXBCxoPjvq874SiH1W1lAAQcYl++wOy0z8ZSFgvYS9yEyDZl7hZ8mJ5VQGM5bTAh3l7lB3VOkGHLIO1VbYLEzSu/n0e+MzmiqEXevpmXv8GYPSBtm0f8lLex+klg1L6W/MGICuYUSLuUcYE+Ev+sSj/pCVJ1A0JkZfKbBnKdoec0Xz1L5dTrKrJsx+nIRPBanHpfasicGKt944V4AXZ8NaCoSanuTN5MkWOYTLZwlrDNOCgermNK7UqxxHt1Y9eKnPLHhn1EkBp872gPbObsdt22h03N4Rk1M6AiIyq+0gmjzKBJpgw9hzAQ01FduZaNwmBnWVF5ctyBVhizTMjv2o71hQ04TBRHZ9v51pPsnXwSSMlluPnwf35sG4bGfZsPU18A+Lb+eV1L+TzZ2fQ7/MOapEkIdHMCxkO5BsBshZ+pDVL6cjH0gB1e8SqFaBLvupcki3B3F95fPafxLoCF8sVTm3
 v1DLrQ+3
 mmIoHrZZttv7f5BnXHTZxIM9vZjCJXt7Wh6B8fzElf/o+2O2kUiLCnhbdNub8cRSlf4NsJIj1RmyssMHtABG//wVIiIycVUrFdGN6VJ6zK45J0fnAm5EFHIyFif8jbh1AMiqZZF1Vz3Ner3pGPdyPxZu/IRGetL0u/n72dH0qOY9RID7d7nvzlsRGyLt0x7syBcJu+xcNUeitq3reE2y6EE614Luv7YqGIiS632bNCpcSil4grhIWs6lWA8qrxVvxX50m0iRXakyA/QDAZ7kupsIfkr4nDUo0LsYav3pEq+Dl76sHJ8s1rC42QGzYacWO8H0GSVjdrClENyGJb0bY1eoqtegX5LqLnL2KqDJA9bPQ087Gxurrzk9b37dMDzQQWnWHAEb8B7U6LyL33WB5pclELVtVcXXBJnmPsvHyyMuIO1o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> ---
>  mm/memfd_luo.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 01a72e4d3ef6..a34fccc23b6a 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -447,7 +447,8 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
>         file = memfd_alloc_file("", 0);
>         if (IS_ERR(file)) {
>                 pr_err("failed to setup file: %pe\n", file);
> -               return PTR_ERR(file);
> +               err = PTR_ERR(file);
> +               goto free_ser;
>         }
>
>         vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
> @@ -473,7 +474,8 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
>
>  put_file:
>         fput(file);
> -
> +free_ser:
> +       kho_restore_free(ser);

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

