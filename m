Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F283FCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E4FF8E0010; Mon, 15 Sep 2025 11:05:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5963F8E0001; Mon, 15 Sep 2025 11:05:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2D18E0010; Mon, 15 Sep 2025 11:05:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3C38E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:05:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F220A5A135
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:05:53 +0000 (UTC)
X-FDA: 83891809386.12.66022D7
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id E352EA0015
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:05:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ck6f+sN/";
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757948752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1fZzkxHP1OOwmzsUzfvvWxxzPkZrOBgcHf91zQ9q6bA=;
	b=lSEolm9FFUmOPiWUkK5lUT+jlv+GadXBbe2VSHaX1P7iiV7h7VBmGoKvHgOAha5NhbDIxE
	oiKV+/RVB3/rJ0o+MUt70GBerlqLak86v2NscfQP96zfp3+D97xfxsgShWgPVN+RKNlEJ0
	KIWisykHs6o40ZhIetz4W+CYeDjmJqw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757948752; a=rsa-sha256;
	cv=none;
	b=jUZYonn6fco+4GrOahyLKsUMIVk5udH8aXwpMep1oyeG5V7+iJrQWczA+bRIK2UH9s0nWg
	rs/oiKgySDhJpXWKhIPbbFjo8oydcsIWsX0ZaG14tda3iUPfTI6uxHNabHdliC2tF5bBnw
	popupFF20YzOQYLKecHg2PFZ0y7QPo0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ck6f+sN/";
	spf=pass (imf25.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-71d60528734so29497587b3.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757948751; x=1758553551; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1fZzkxHP1OOwmzsUzfvvWxxzPkZrOBgcHf91zQ9q6bA=;
        b=ck6f+sN/+G37WVDW5kEXyDazprkt12R0p4iKuGiNOCzGvXrVzwGKQHoTKeLfJgTg/a
         VSeu43dC4baCLsIcLNJ9z+AjAdPMWJk3bDXGSDjihmTfKiY7gwCunIO1lpBiUM0NCFeu
         X8QAztW+QKj0SS9sllqCZi1lv+coW7uTfKL2EvqPpYqVpL8jZNXo2m4o2u2TDtb6t12+
         b3vRr0a1ARkgU+4+jWSaVcvOmzVbSljzJhBdOL2rfhOQgOHAHQMvcTa/o6CVro7lm9pT
         zHNVK0p6f15GE0ecJCmPeq1koxX8/FO2iDxbSr9jMpJdWFeAEdNGkkTHJemO80KO1gEv
         17Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757948751; x=1758553551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1fZzkxHP1OOwmzsUzfvvWxxzPkZrOBgcHf91zQ9q6bA=;
        b=XOOcArgtNgz4D7VXGcHYlMqqRthG9+8m6wUSJ+feJPB1s7KpgV0EyZ+qpjoFRkXPbC
         qPiuZ09ZLqeoGjmvrS1rbysLiycyHKbmnXgJMl/KWJ87VJvx+mc+Qgc/v5xeCOZJehvr
         9oD/rC5UXqEAvG0c9bH8Gs19r9cj9fB1ObBdON4cR2EE0/7pzS1Mhogk+mQ0RSAaqzhS
         m9Ca+ltlPSxLk0KQepVjGjFXK3z8PDILwetlc5SIiD4fTUqylWLmr5zZPf3NujD3szc1
         bj7IUlth9XPpTPKpHC8I4Q0IY580+xaQOH1r2b0W/nDYSCDeu8yZpeecCK34ljRnsHWO
         2zMw==
X-Forwarded-Encrypted: i=1; AJvYcCVgU2KXTxbZJTamcUCXlGj9QUsOr9Grxi1UOPoxa16zfpz4dNgjA7RTtGnuYq25NYgJ1CgPhLascA==@kvack.org
X-Gm-Message-State: AOJu0Yz3STeNc3a+IK/9dKWWhqIryVAoJ1rqcexXcrIAekBUzN2YGIRF
	uHV5xCmfIUWhJEN+Ij660agxXjwEZ9ORBkb+rWg+0UM09/g/nKJchTb5mT7G/w==
X-Gm-Gg: ASbGncseKOkyuGwc1AiQw8Ck7f173nZWZOanj2lnMSr/blE0IAguEP/wwxQa2XlManx
	Z3NuZ9UaHhfsUCaaz3SjLgIeXvgP4TzF6Q6t6prVEqxgvlJcbNgo9h9g8MpXrs8yQAa582bFQ6F
	IR4SAfl0QiQo7WD/7FKl8D3NwKDSPu22AGCWMW9G+rbWwxb9m/bvUb7prz7P8lXIGcGoLxL2YgI
	4GYQKsdSaoY5ZjQzOvlVjMXc+r6NY9aFWhFSHc2THX0xgL7D1Yqazl7WyL5LnbX5l1XtZuITcJy
	O0wR9t5LUuj32h48KI8FEXfzzZmrCXLVJes90r2yh33z7dHPTTH7DQVDtC1iislujjizMu36e6Z
	Fzhz/4C7/AP3Lxw+nlRYe2Qc6RCPFbSoy/SVWbLEA7vMUhXczpqYNxUE4ABRi/0zr
X-Google-Smtp-Source: AGHT+IFVR4/jZB2COJFPEGxfd0jRNijX9bwoQRclaQiC53MprmBZ+9vZhNJplkD1Ak6GytefEA05oQ==
X-Received: by 2002:a05:690c:4904:b0:733:af83:51b2 with SMTP id 00721157ae682-733af836cf2mr41991207b3.45.1757948750534;
        Mon, 15 Sep 2025 08:05:50 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:55::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-72f76238386sm32849077b3.8.2025.09.15.08.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Sep 2025 08:05:50 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/6] mm/damon/lru_sort: use param_ctx correctly
Date: Mon, 15 Sep 2025 08:05:47 -0700
Message-ID: <20250915150548.1486984-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250915015807.101505-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o61xdcacwocszrjj7aeufhxptzikwgje
X-Rspamd-Queue-Id: E352EA0015
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757948751-628755
X-HE-Meta: U2FsdGVkX1+SQfrEUD0TI7h3PESK3xM+8PxmZWkNoVYNyloUlTQ5b10AwRTpgPOrQg4RNOeVlNkL/772clwZhiSqAfLuFWzOSf7C9NiO8mD4UGQRqN/ZWVWPkfu6NdkJ2hFeryyYwx0hro+EuFnV4i9podo/ypfZSVSudjl8Rfz9llgB3/uFurvI2HsprtcJCJD2CAe5392vhCoAY28oS6AlwkHPftsiyTw4QvQFtVI2nnBs/mqHoI/gBBamrD2tcML5g/Xiaox8AVpTgCNnWZ8a1xQcbxeX75Kmcolo/8WjPOg8Ra/CcWa31b9JuDUWoWAkyj/BInP/OlN698BfvCVlyYGIPYLo3It3O+MnjdWBukXjBvnrmVx/yBaNOOrJvrcJeCjNMaUoDyygopvbzhqYZENyfCNxR1KLKVsdCTch1BjzFmssdJxuwdj+govkuNjtvzMTTosn6wSTlIcLgY+lZ9JhaM0lBA7ClN40nDAQZCs963g58/OTbds7glI0pgXBikZZyS6DzDmFYgRNeJFA6/oEbxnOW0XOCGBmQWFzZkGd5mhpCASNebbdkBYTxzvurhPfwdtZjDvHNXm9PKFwi7z6o6tMDVVQFxaEnOoaoz4hXFZnny02pAFGlwNpvVYPJCsbxOhh18EIAi11XKuCos3uAL8+5OO5JlRBxJLJIS9iHdZtZ5oq/tGIH2hhx7bzIBidPih0uJyaJSjR14j6pq+na05QUH/W+iTsUKY31hVZ/kaNWd90S273Ml5zWlf7MQeeuXDnkRcBAQkY9/an6FCD/SMfnofMv4XDG1aB+2RLygbwSmKb5RGrrICsTcck2WNmmEdYjGRQ4EKmmD9F3b7y9kvIb5VqEzbrVfWaZqQ3r88vg1quCxq4DaakyQVZ/jP6feh83j+NOrFg6+UXOOx1VAHpyecgQrenNnJon22YUsi/D0uAo8KLECBOCozXUS1sSzc0AULIWvw
 5pVDuihm
 8TOiAgIOkDJ8QkrFULU+29DLgvWAK9hgqVQtN6LrSX6eEFeBuTsk/WyfY4taH5zqo2gT1oTewZW6i0pVL20i47M65wGFrN6AJQwk6aWTE0ZYCAUBZjIX7wd292w/rRZkWgNqrTy4OEfPU4STF2l48g3FdenOKhdGmV/1J+hD0+YODMaQwgcmsvfLxTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 14 Sep 2025 18:58:04 -0700 SeongJae Park <sj@kernel.org> wrote:

> damon_lru_sort_apply_parameters() allocates a new DAMON context, stages
> user-specified DAMON parameters on it, and commits to running DAMON
> context at once, using damon_commit_ctx().  The code is, however,
> directly updating the monitoring attributes of the running context. This
> doesn't cause a real user problem but apparently this is an
> unintentional mistake that can cause code review confusions and future
> real problems.  Fix the wrong use of the parameter context.

Hi SJ,

Thank you for the patch! I am a little bit confused by the behavior in
damon_lru_sort_apply_parameters. I was hoping that you could help me understand : -)
In particular, I think that this patch fixes two possible user visible errors.

My understanding is that we want to make changes to the param_ctx first,
validate the changes, and commit these changes to the global ctx struct at the
end. In the middle in the errors, we can abort the operation without committing,
and ctx will remain unchanged.

So to me, it does seem like the current code could lead to some visible effects
from the user's perspective (error-handling case).

Also, I am a bit confused by how the commit is currently called. We have
err = damon_commit_ctx(ctx, param_ctx), where the first argument is the
destination and the second argument is the source. There is a bit of a mismatch
because in the current code we have the following:

+------------------------------------------------+
|              ctx                    param_ctx  |
+------------------------------------------------+
| New &damon_lru_sort_mon_attrs                  |
|                                     New scheme |
| attrs overwritten to NULL	  <--            |
| scheme rewritten to new scheme  <--            |
+------------------------------------------------+

So in particular, the global ctx will never have the correct attrs pre-patch,
since it will always be rewritten by param_ctx, which never had its attrs
initialized.

I hope this makes sense : -) All of this is just to say that this patch does
more than just improve review confusions -- I think there at least two errors
that this fixes for the user. So perhaps a more descriptive commit will be
helpful in the future, since we are also adding a fixes tag?

Thank you again for the patch, SJ! Feel free to add:
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Have a great day!
Joshua

> Fixes: a30969436428 ("mm/damon/lru_sort: use damon_commit_ctx()")
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/lru_sort.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index 14d31009c09e..ab6173a646bd 100644
> --- a/mm/damon/lru_sort.c
> +++ b/mm/damon/lru_sort.c
> @@ -219,7 +219,7 @@ static int damon_lru_sort_apply_parameters(void)
>  		goto out;
>  	}
>  
> -	err = damon_set_attrs(ctx, &damon_lru_sort_mon_attrs);
> +	err = damon_set_attrs(param_ctx, &damon_lru_sort_mon_attrs);
>  	if (err)
>  		goto out;
>  
> -- 
> 2.39.5

Sent using hkml (https://github.com/sjp38/hackermail)

