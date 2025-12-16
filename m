Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94AB7D5E12E
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 10:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0357E6B0005; Tue, 16 Dec 2025 05:57:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F24D76B0089; Tue, 16 Dec 2025 05:57:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E06676B008A; Tue, 16 Dec 2025 05:57:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDB746B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:57:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5CC0A6046C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:57:07 +0000 (UTC)
X-FDA: 84225032094.27.7C70928
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6CC6380002
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:57:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fkQvC4Nn;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765882625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4YTM5ziaIOOYraDYhOZYgWKHK+M5tUDa1EwJkxHyTI=;
	b=rLV4Q9NvtJIAskOOykJ8x1Uha/FGQCjaB8u5UPPHJWxJhxf0yKdovOe0wZjJxLypacdQGF
	eFuJPZQ9eGt/ro+THavJOEKsBdhHj7zOlLfmAcgzwyiK2Rm06v5KRNBM9yAr1jOth7SJh3
	vgkQz3cv9fiEohYm4OxRp0gU+VOj+5o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fkQvC4Nn;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765882625; a=rsa-sha256;
	cv=none;
	b=hGBECOBOoH3zS1rOuBiGw+UkUHqRZbdDN5O+aRdJGHxO/Y9ECbuquRS1hgKpB+jwsIySWE
	srE7oMfK3bxQpOuIVF009PWlJvAo0xvdigOFVQOrDLpq2Zc/+JFQHKLKYB/m815ZIk7R6h
	2Evoef5hiLEc7CQv8rAYxoi7bEtQKa4=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-63c489f1e6cso3359193a12.1
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1765882624; x=1766487424; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v4YTM5ziaIOOYraDYhOZYgWKHK+M5tUDa1EwJkxHyTI=;
        b=fkQvC4NnYL29gGr4M9kfjnVJpwCtZo3xit7Q5binAA9TG0i7K4fRGYi3cYsRKAyV6X
         cjIx3omJ2vmLu7gsXV480ncjCvYEh+DaM9Cw63WlD5RZDbmoyVc4Z97viYdA8agGuJ22
         enYWrvmGFYtCfiJl62vPeI5Fo9RF3tWe7bE3jRSDFGKZkH0IboxoBTBaJl8ZzstPLacF
         m2dQcumUfxIIVnppCOu0sHwAuj/pUrcUHh+l5Yye2rbmfXO64X5am+g2Fj2fK2J3Bn5Y
         KLKqV5lPXz+M4YGig38RlLj7zb6J1k/LQDZxTj4dqskI88Yd8BQGLqwG0kvB8j1beFGl
         9Xqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765882624; x=1766487424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v4YTM5ziaIOOYraDYhOZYgWKHK+M5tUDa1EwJkxHyTI=;
        b=gXFPK7oZFmhkflqKayinEwTiRAPH2Th+8UL6W+m9DJmdh0sOidoFxxCJ0XVwBT+iBu
         DA5PFEw9Gh5LARbzBCynCTrkSe3J93FE/21rm7xXz+ubzaywmE383g76VAbFQPHD4gUG
         Ri+tbHgJkmUjyhUSAmcWiKfcbiStbYVoYv7SR7VdlHZHU1JuUzzeZGVOGfQHOzJz3o1I
         N0A56Kx5PBi25OmUbamdHvLb6X/tUe36yeiLxNYXNCYbrOqJ0cnbtyTXJ+xO1h3PFnIL
         b1shTg77BjymbEAZWny4YfnNaIS4lUadfBs36WA+yHAOkWQ8v6/EqIPciGRqZIyqtt0g
         IUmw==
X-Forwarded-Encrypted: i=1; AJvYcCUqvZoOCwlayRxOchLS/HmnVNuJ07SW8yAaUsxxAt5IBip6cMsqHTWRIwnnqfRjnNbTORB5ZlH4iw==@kvack.org
X-Gm-Message-State: AOJu0Yz6GeLYEAjJTO17G6rAkqHgmL0N2t0TW9FGnmCAmdoQBTsu0yMZ
	ccI8nypVYUIh1PBfku6rRxyNr2ssCrlxrAxQt4T78+5Zkn2gyLhFXKN3pCRA+R+3orxGCSWwoRO
	FCxg1D1h6FtO+IymukJ8CYgyUAuiOWIlGCFXUQdQ4eQ==
X-Gm-Gg: AY/fxX6HlOW6IbJ7q567ybDykuq2vvIG7euBzK0DP9LpFTA5bjPh3GCVbGG04J3afCT
	pcxZuHT8Wt5/wrezrAvHa4vdufwt+4M90pxWdGVSrUZ3YKXMWneWPh7WCqPoRyHroTPcS6FPwvT
	eNN4TwhYQqW2yulzt/5uGcc8RUlTEf4DAtn57KYhbA6TKmHgtA6UKHjR7wr9sN/r9L22y7gTiHG
	zlMjLexVq25OBA1H84FcNy0AUuiFH/OYfv82BK7q04W7NEt+r9CtfEWCYSAy0CJyYv0Sfijspr5
	ON+bdeQAqSH/UL6P/jbe1rJs
X-Google-Smtp-Source: AGHT+IFBhO7lE4EKXlZe2u4YeG+WeUJE4DvyxMzToTPEQ7xdmib3BrCV7t/nup4j/dCwNV2xxCID7pup5fDv54S7Nys=
X-Received: by 2002:a05:6402:893:b0:649:81d7:581c with SMTP id
 4fb4d7f45d1cf-6498744875bmr12537223a12.1.1765882623873; Tue, 16 Dec 2025
 02:57:03 -0800 (PST)
MIME-Version: 1.0
References: <20251215091150.4094334-1-longwei27@huawei.com> <20251216064520.1529635-1-longwei27@huawei.com>
In-Reply-To: <20251216064520.1529635-1-longwei27@huawei.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 16 Dec 2025 05:56:27 -0500
X-Gm-Features: AQt7F2ruBzw9tVqvm1Bp3rdZ0Yk8-pcfP9mBghdN5ziQLr2J0U29LGeM3KBzb4A
Message-ID: <CA+CK2bCyqOKo1oA32TPnL3u+w8VT6MF+pb+Wps57C_P6v2C9ZQ@mail.gmail.com>
Subject: Re: [PATCH v2] kho: Remove duplicate header file references
To: l00580197 <longwei27@huawei.com>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, hewenliang4@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dttzziiejyu6duxbirmkbp5foy43nudu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6CC6380002
X-HE-Tag: 1765882625-71411
X-HE-Meta: U2FsdGVkX1++CWMUAWdqSP9GTe/xQpEuxjb9OO79lTYzyfKRLQKA7JOg+zi96eEFrsXqWw2Iz5x7YCUAB49kkOzl1TMaIZDM4lHF4h7INFrbgYSTFIZyoUW/8PwJDC+ZivXuVyS0x4M3zzLz/Iayw4vnHmIttHDrGtjP9WUTOU02TlAs1nz82XmBPY1dDH6F3NeT+b3jXiNJ/EMS3DT6yww25tZnJc/FCvCduwV8cg/uXO7ESM/Mb0gAWBydMnQFsdXS+ttM6g4SuugKDBkLC3lJqGDwzgXSyWL7KsZH4EXkwGDO85WTIOWRvd8Kbnmjxh+pEjx4/Q2SxQWVxXDIb+wPYggcXRXQnU0NCgPwcBGWZn2mUQ26bOVLR2u3sWMAnZ0xISUsArn563gix/7Xya4xpsXT34xEnS2bR0Hf1Ae15XsT6bU0KxAbsZODy1hXCrR5kCv4DUAhW7hy+bMipEOWOE80MmY7rD1V0itIYP063BX7U01bIQu4IEo/9uzFg88wrjeV4lBGLKobN+zeBqN4VCmN9ERHSpu4itJusrslHwBIuj+fiPKjh/XL5phH2Imq8Cq2lLNo/6kQ2aXzE4WZRkjAmBTPqttZz4xXD0r0eSDnOldyQjw4hML9EmaQIBw4RIfrLfTLmnx0z+ZutKNKKiw4wQq6NuLmUB6WeGXOMlko46VgPrtymY/rAUddvssxRE1AtuilVSOGDJ7i9XLMNOpFXbs2iGbcN21XB1He4hLF0BeY0CGv/Q9LWn/ToDDVWQXwqtj4JVF5e0Rl0iKGncgDuJ8K49WpynfkZ7Pqkvl1GEYk0S/X2ExZUaEofEU9vavBcXR89m3zmbadKVa4JLvmS6K+29qaEtinb4TgVGEYgWkcuBEpBBK7GvimPddJOZ0aD7FbEi38D7yB/0UZ+AIv08McBYvIqmirJKPb4cAFKrHpU7gNBM+8Bb90Bthw5zhhWkmbLdep6SF
 pZfI9YC/
 W5r5TMNFNgNoK6DAQGIih9cQvc48CloJNzmy4USCAs4Sc32z+6IwqU1PR5S2idE7PSqCRKadBLoU119PNuP90XqHwECkt9w0yJRz3l6CVClymQZo6mEJIngBExleYEkQuLczNVV1abbnn+OOYsEL7zlw3upOzx/L5o3MbGHB2WDR7FxQ2/ctrDGX5YVDHmXhGkVz6n573w+bmWmHWugjVWc0QLjnPxNhDoOki4hZBGLsGei41tjlRGYKISaxj3vdoDofETMMOCRcthHY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 1:45=E2=80=AFAM l00580197 <longwei27@huawei.com> wr=
ote:
>
> From: Long Wei <longwei27@huawei.com>
>
> Changes in v2:
> - Fixed the malformed commit message header (removed duplicate 'From:' li=
ne).
> - Added module prefix 'kho:' to the subject.

Please move changelog into stat section, so it does not appear part of
the commit log.

>
> kexec_handover_internal.h is included twice in kexec_handover.c.
> Remove the redundant first inclusion to eliminate the duplication.
>
> Signed-off-by: Long Wei <longwei27@huawei.com>

With the above:
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

> ---
>  kernel/liveupdate/kexec_handover.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index 9dc51fab604f..1962b6052840 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -24,7 +24,6 @@
>
>  #include <asm/early_ioremap.h>
>
> -#include "kexec_handover_internal.h"
>  /*
>   * KHO is tightly coupled with mm init and needs access to some of mm
>   * internal APIs.
> --
> 2.43.0

