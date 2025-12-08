Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB6D1D3B7EA
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 17:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 062496B0007; Mon,  8 Dec 2025 12:32:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03A1E6B0008; Mon,  8 Dec 2025 12:32:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB9916B000A; Mon,  8 Dec 2025 12:32:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9DA56B0007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 12:32:30 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A8CCC0296
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 17:32:30 +0000 (UTC)
X-FDA: 84196998060.15.F1FDC8D
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7390A40004
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 17:32:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e5zZFVEV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765215148; a=rsa-sha256;
	cv=none;
	b=mW32dz00B8WUONTcKpvmUlbGLA1DECHQj2sCKkLHmKwPzuBBcI0Rvtc55TOWYOoyzvAhu5
	SGvoO08ydsR4h8BjmScnPYTDPAEy5wZ4d9LDdabTxO/lfB2ibmPeTESvBXLR/T8N5CS5Vo
	FiGtkNei/EkCHqjGK2gjpl8tLjYN7Bs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e5zZFVEV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765215148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kvvNrbzxfKIfhL9wonNMP6XRUhQd8y0eo6+8602KYfA=;
	b=53fiKo7U5H3x3I5+ftjvMEndjx0Iqfwlmcy336F5kIWE3ZyvnD24V0biR1LBCuYCTsyftO
	bf3thP/1I66BtiK3g19joVT4nETdbGIA3rnbPJDTRicEl8SbvWGW+LU/zALqtPAezfu8MH
	VjhuaV1XB3cH8Jp9lQCJ2J5Oa3WBj1w=
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-37b983fbd45so42315921fa.3
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 09:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765215147; x=1765819947; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kvvNrbzxfKIfhL9wonNMP6XRUhQd8y0eo6+8602KYfA=;
        b=e5zZFVEVN4Y6kRPEwZBmJMTgNzwiXp4fkmdndwEvG98Qr0ZD5a9ukUPP2XUx5rwQ0w
         HErgG+JUrXcQ1+uwt78zSWA8hcC2DKoMp9MjHB8B863HTgwmMQItMUESIsvkTL4U73iw
         ToVEu0gWPGV22WtQ80NpGJSL/PCHxppSt8ob84TQwyJIbj1zy5+ZQJajs+R6fLO64D4Z
         YTlpoIUBkAvNfOlL+FoJh8mwWtrYt4qG6W3fT/Yn+CviwDWqMLNR/KpEcVO6t48r8pjN
         CjkqsCGpNjbosS31RDU0BN19Wi3Kd/IarZR89/SGWbMjBWn67cD7mPDJEO7oYK42V/sO
         PT8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765215147; x=1765819947;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kvvNrbzxfKIfhL9wonNMP6XRUhQd8y0eo6+8602KYfA=;
        b=oZIS623QXPuXcbOq+8AnQNocd6iKFerTjfQl2ZniUZAJpgfnCapTHwxfxE/+l7KSJR
         lRbj8ZLm1t5FXIvMA7Wj2uK3pNRRdpxAbYvMpGb0K3lkGw/jYMtAEApOcDmBttZu0Ydm
         U9birlpfdJs6nGrNZVXyuN9E8H/PgFgT6NovubmMJAYkxVhhiUhk8o9fe2aYmry69dUe
         gpJ9sCgpN3S8nNFeGqVCabjL5u+nXc3K8nCjCoS/1Y2SQ+6MFs0PZMehntMxv8U61aER
         RQClx/USQzEUovI9ONIMJSbWbjKwRvL4iHPofhui17KOIwkAw1LwmTpP9alLAj8/D3FQ
         wHlw==
X-Forwarded-Encrypted: i=1; AJvYcCXEIhce2snXGzVlRzTilAQ+cLAU1YdUnGe3IPpQ4PlgWhKLt8HGZJkBaihuwBb9SX5Qfc5G+t7e7A==@kvack.org
X-Gm-Message-State: AOJu0YySxz03RhCjGkAwzJ/zHWdujPT4XCfe74X4sZ30O9jyogZt7hT9
	zsaRuaCZRT9BkqT7QB8d5OE+TGsQPX1qsOE4fpRIeyaCTId2SvUxZtwB
X-Gm-Gg: ASbGncszYUDwO6BxuVmWM1J5QnpGmENa9SazAkEW6JCZQ8dMdI6XWixBS8595PtPgWz
	kd/tOqAGrLXG2u1rLSN1gI9h1FyH7s13TiXcgOW3x7n2mfbEhuoQgQQQ0oKvc9v5BdBWnYerIWR
	O/0mQ9rg3et/18vKPI+71F7me/fDAJDY3t/DNq+1WprRF6h5sTZSPqadKa8B3mk9W9Z43xhYG8w
	r7evYmMtZcOVwutpYXYBqoTS7lfsVC8vOEvsncpGX7BUZlRAgOsp7WfI8DcWN+2GT/r+vLF3OhQ
	bMMDESyCk76jjZdSbuvs4a+FX3IWZx54i/Ks+7hcTHbupe7QSeSopf2QzawU7xdRWQFx1xJ2J9m
	lmgt61l+UNUdd9Ecm1S0WkGFwOfv0pY2DvtXWinZJvHvgH4Jk4fjN
X-Google-Smtp-Source: AGHT+IFsm7rxgn02r1lDEyDh6oMhj9/rBDOaoFL0QYsFnQGFM2lDhg6gWYfXyuZuPifV8on94YS5pg==
X-Received: by 2002:a05:6512:689:b0:595:90f9:b9d2 with SMTP id 2adb3069b0e04-59874372abamr3094454e87.3.1765215146407;
        Mon, 08 Dec 2025 09:32:26 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-597dfc08b25sm2722262e87.6.2025.12.08.09.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Dec 2025 09:32:25 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Mon, 8 Dec 2025 18:32:24 +0100
To: Brendan Jackman <jackmanb@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmalloc: clarify why vmap_range_noflush() might sleep
Message-ID: <aTcLqNyqm_WIyn99@milan>
References: <20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08@google.com>
 <96aa9bf7-1f1d-4870-90d2-84d3d6d4254c@arm.com>
 <DESNXS1K25LW.2E7ZWFWV56PZD@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DESNXS1K25LW.2E7ZWFWV56PZD@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7390A40004
X-Rspamd-Server: rspam10
X-Stat-Signature: 7zbgdsd1xaddawjusg7h3img95yt6eoc
X-HE-Tag: 1765215148-733885
X-HE-Meta: U2FsdGVkX18iXNdJAV4h0AwPva/pgmVdJVO5Jy5dm3/3CBqMgl+24Q08uKrXaW2R1TH/O7C/QJ8xLkiUol5NExOEy/P13qMTQJ6y5OjK0Snajl/9QBMj7jNUvNHtGOU4QfQpZnRJGI0S4dgEyYcNU27Oc/leRjKo3P5mwjwViCcUQ8b2C8oU3mV/omU/31n+lHrbKpcScQ7T9hPqvaQqONikJVI4jb106wFgxjE9vA1KmqJ+iqfvx0DJhHmTeIzywG1x1OcIU2M3LVoyS6fSgn4xoxEctnTPW8M/h3hpR4mEKbetJ8Leb71+Q0ntrokW4qjNockLQn3MChpZf1scGWCMat7S0KnRHewGyBhh/8YzEKpxpuB50FyCyeQle5dDscO+YI4oCffUgvD779GNrFUyNcX/4t66RmRpzp3BSdFS4HGlD4nBppxUE6XYcAnw38kRJyuZyjLjvgyan584Z1xA7eRpc9NG0gLs7x447SHMLFDS/lW7HcrZ20039IZQxBlCnStJ7x3KRKB9hHEpzr2VpYpZDbaxTPe2PJzpye5v7kMh/hYbtPI5LxnSFk4qgPQoxIfpAKjENoHoyip9c1nO8mZnHmQKXl7pLDeZr6EU/OZrFfG3VC2loqZZuOHzD7CxqiS1GQ1n2m0w7sKFGJfEGYA+WpWbpn382NoKpG2aSeKm2U9JzJvKKls7BeNjn5PpO0omJdpHp9MY6MeTJsbSJjHvV2+u/yJkJWxQx5pRtAFiNiTmJ/ttkgN6o5kD3TrMLK/6aaOh4/RjyLti0FiX0V7RSAmpGTjXhFv4h8EPAvLGI0FDGL4BoDYeD8Zkti+5v7N+iV3UL4gyNJqw7JkmrpsiNJ6KrzBBL9unpjekSkKdtFwHh6gqQwMJEloQzX7VUB4z+ZZQqxYhcGYi6KtntjuHToetbBgh0jHXlqfS/hbRjMAckz0osNjXAysxMif5bTnsbuJ2nDC3bZY
 REnP0N/M
 XMpbO8N90vlpJCgSPTp6WNQtlbAen6uZFYPLO9tuqYcPuGvf0i8qVuoc8DVaJUjV6zVBuxJ3CGjFNAD7+X5+Cb+LR1Ks10RKFt9ZFYjpdmSzt8pYTtt6Pe1SXqhbApJKXA3riEnTznGT53bmyrLluT46nyQJRhzpF6YCUTrltPQ3o8lbrx5j7q0NFGCP7nFq9L95/zrF+jZiKmmBE15/9+AF0d8CWGbbXh2Luv+qfOaUNl8AWPRkNoLJKHmxxUji5De5QWL3COfnxkiELNEn8FNgBH3XkwcCZwaL3ZEyqiXrMnLdqZK3mrLGwLgeILiJbZw/6ZLYXlSFMFXGsViMaDKMNKc185HJj+ILdniaD+ZLjg3Z114IV8By/+CHFWCu0BcsIXjS+xHi7mXeyAGeOwBUBc0bZUBJ8L1gX5N2gTjiWn8PAyc/AyLZnoWnQp51VpfJ7Qd7wxZ9VLnhSeAjwV1XRpYy0NeYgRVdkwFqjg//jPIaa7mqScfcRywLkO7y41yzoSUFNHFTpjUc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 08, 2025 at 07:39:39AM +0000, Brendan Jackman wrote:
> Hi Anshuman, thanks a lot for taking a look.
> 
> On Mon Dec 8, 2025 at 6:41 AM UTC, Anshuman Khandual wrote:
> > Please add <asm-generic/pgalloc.h> in mm/vmalloc.c - otherwise it does not
> > get built as GFP_PGTABLE_KERNEL is not available. But otherwise LGTM.
> 
> Oh, but that's not correct, IIUC we shouldn't directly be including
> asm-generic headers from here.
> 
> So while in principle GFP_PGTABLE_KERNEL is a sensible common
> demoninator here, it doesn't actually exist at all everywhere, e.g. it
> doesn't look like m68k defines it for Motorola. 
> 
> So maybe the best way here is a really vague:
> 
> /* 
>  * Different archs allocate pagetables in different ways, assume
>  * GFP_KERNEL as a common denominator.
>  */
> might_alloc(GFP_KERNEL)
> 
> ... a bit yucky but I think still useful.
> 
> Any thoughts?
>
Maybe just add a comment why that might_sleep() is there?

We can simply state that page table allocation path is hard-coded
internally to use GFP_KERNEL flag.

Thanks!

--
Uladzislau Rezki

