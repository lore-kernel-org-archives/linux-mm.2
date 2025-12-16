Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C875D637B3
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 23:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B36646B0088; Tue, 16 Dec 2025 18:20:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABB6A6B0089; Tue, 16 Dec 2025 18:20:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C6896B008A; Tue, 16 Dec 2025 18:20:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 85B916B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:20:26 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B4875AFAA
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 23:20:26 +0000 (UTC)
X-FDA: 84226905252.13.5A7023F
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id BCE45180017
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 23:20:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=0x0f.com header.s=google header.b=Ar8oi01N;
	spf=pass (imf24.hostedemail.com: domain of daniel@0x0f.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765927224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gy2rjlQJ/MwlF7d+TSXEhOTxke1Wr2G6RWbQLrYM7Dk=;
	b=GUGKUF3GDiy7b+F+N3iG8+kDL5vgdE1MkE75zkC9u9RHcsISoHN34z16YqHOr8LLakakeM
	5MxdzUMAmbHWPlnxlQjq0H1ZfIdkyl9PkwwtZdX01MsrarKYL9McgZNehZbGUwvvv1O1t2
	BQ1LvF9W7AuG8ZlntRvf12jWv8FHJsc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=0x0f.com header.s=google header.b=Ar8oi01N;
	spf=pass (imf24.hostedemail.com: domain of daniel@0x0f.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=daniel@0x0f.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765927224; a=rsa-sha256;
	cv=none;
	b=AiYsg5y5RIz6twv7jZ8p3Ps9BUTvnldbJl2AQKeGBjmcSaEwlWNbOBn/H7NdkZshKU43h4
	G8VUiTo87u8lP0Dh9sYPTFIChQgvsddnVTM3wpQrahAWWbzUdM5UTUZvy/ZLoyNE9TOEyf
	7wE7QCa1NM7aV4e1HHLcLUlso4UITL4=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-34abc7da414so3865353a91.0
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0x0f.com; s=google; t=1765927222; x=1766532022; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gy2rjlQJ/MwlF7d+TSXEhOTxke1Wr2G6RWbQLrYM7Dk=;
        b=Ar8oi01NFOvCrM56ifCzM/NkOWbbPvoI1QXRZ7JJ6s2CFJj716zB6DaCHYVEN4+y6H
         M15KWsOzXsRG720VSIcL+H+TKW0i07Vs3lLQjaptfe4wmbmbCGoIVBoPakJbebUcmWEM
         2xLTa/etQEtmjv+iA2ELTsodDKrnDig7H7qgQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765927222; x=1766532022;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gy2rjlQJ/MwlF7d+TSXEhOTxke1Wr2G6RWbQLrYM7Dk=;
        b=SLZhH7mWfOyvVqPcju6vRrk3M0hA86WYH7exieBDK1TJnuQk/LPB9wvAAoolJuNawg
         bjYeXxsL7tjqdnA+Er6hlUu91A/eO1pjqGK/Vju5h9mK/RAAKYhEoCsd9R/LELKu3mj6
         2Ny8m/Rei+KUR4bIua2QGWC438eZm2BRZowPlzTqa0Zckiy5jsPLfJWDUAr19jqucq1T
         F5K+yX8uvQyybEzZAOxwZAsQO4K+N+uIBk8wtL2lOGg7SOSB//5RKBO9GD7HtEnGefDy
         pzFbCRTQzsLo7/sXDm4t7hqE3FqSpCh//5d5q+l/A1aLSf7nKsBDhyXf7dE1RHmLDWpk
         sG4g==
X-Forwarded-Encrypted: i=1; AJvYcCUREAb2tPSN8xmnidWp2kqOVDAde5OTdv6lpWAh4I2Kojww90fgXfmJoCjVuvMAZXsbohSXaiLo3w==@kvack.org
X-Gm-Message-State: AOJu0Yyxlh4dkBWKwiCvz3jIr+fmQsWTMoTc1dYBFYidcygAeQieTKzA
	+VX1qJh0l7P89WkgVfRRvj3hpO5Rqc3JgMWLAkaZ8OSrMYrqndwHUx0nP6YfzvrExt1fu7GD0JQ
	at3lqjP5hm+o4C8I79IaEJBa/IDlaV/B/vag896E8HVFwayiX8EsyiOghRA==
X-Gm-Gg: AY/fxX6A+ChOUghxv0zcZBITz4qRrPiJmnPnpx3rhJ4tS4ijUHkqfqFUAnEiotzEgbZ
	NifNxrnVdSPI+ZASCG2EPESaizZXXMYIBQSFv2rtO1Z4tHnkOe5wkNLPm6TFbsIXf3eG0jpyn4w
	2yq6pKKiVIEmKmuB5UG3Q9xr9GCw+12/Y8pNVqOOlhLrSNj3EYzi4MuOuWsa6NIbRWoYODkh2k7
	rkFNcQoyjdkXvXNCjjouu9uTmbBOtXy54Wq5VvNxqKAD9c5d8Hk2Xy0bGFtCrdladv/qv/B
X-Google-Smtp-Source: AGHT+IHRLmrH0NhxsCVKZ9qmGrCAl+I2i9/10P+TFyGujd+JX2sBrK1stDmkuLqLUE/Qescwxw7u3hLX+aeoqjfkUTM=
X-Received: by 2002:a17:90b:2891:b0:32b:9774:d340 with SMTP id
 98e67ed59e1d1-34abd78d3a2mr13622806a91.33.1765927222280; Tue, 16 Dec 2025
 15:20:22 -0800 (PST)
MIME-Version: 1.0
References: <20251009192933.3756712-1-joshua.hahnjy@gmail.com>
 <20251009192933.3756712-3-joshua.hahnjy@gmail.com> <42143500-c380-41fe-815c-696c17241506@roeck-us.net>
In-Reply-To: <42143500-c380-41fe-815c-696c17241506@roeck-us.net>
From: Daniel Palmer <daniel@0x0f.com>
Date: Wed, 17 Dec 2025 08:20:10 +0900
X-Gm-Features: AQt7F2pdkaX_FXf3Vw4ZDQFKJiyh0g2VIemxkf9QfS5MKxqxzb6tlEjZT7oT4fU
Message-ID: <CAFr9PXkRRQwMGzAQyhkaZU-BLFHP02rd3nHy7HR9Z+T5eUaUJg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/page_alloc: Prevent reporting pcp->batch = 0
 [mcf5208evb boot failure]
To: Guenter Roeck <linux@roeck-us.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Hansen <dave.hansen@intel.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com, 
	Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@lists.linux-m68k.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Stat-Signature: dwcnfatkous414yj5pdux71qa865ymgc
X-Rspam-User: 
X-Rspamd-Queue-Id: BCE45180017
X-HE-Tag: 1765927223-741611
X-HE-Meta: U2FsdGVkX1+W1Mu70BLtLuX00JAq/m84bx/prI3pA3oqv4j2dJR3bamO/hzkkyOY+GHpBSmXHb/TQi0dXHhoQpP35TuE7u4kwf1/Yir/epkZnLUwd8Mlk4HSDemDi6CfMfOtCt/uRWDaOeBYvieleM993me/HsaUVuVmAdP0kNGJ+9qE6jisrU8IswvmK4/GmFwzsjgJo64+LCxUjAfIOYlFd/9cjVpy86vGwyTOqv9xEyB34HVXMnoLmPKgRnFEjFP0zZ8dx0PhXcndzwQS/FAaiJOLl4aKMSWYvTQfiuxb6+bQP9KMeBvzbewb+v/kO/EDpTP7V5ggqANrgzbJvBgC/1zjQzlYSh7VHDNNBUFcHKzyFhpZJ9LVLBmSLjJ2kEkTru0K5qoz0ofiYkCaOBqthOVoi0lA4miV6nIPHB+TXndGLb+pm1CCaiwuK+HWbaRQ/Klg3mZi7XL3aKwcsyIqhCUOIEdWWQTXDDlswHXSbTOqdcs8/kLHb2gx+mm0moxPhCqo1+ozukfs53cpMtPNdPy8vQSzXmKHS597hQ+5pCXnYGidaNnlwvJI2TTZ3v6m2d6wpVDT32MeVWe1wG3O+rej1cSNiSYfprFrGcwAe7yxwQ8YGmzuts6pZxhBuI7X76AmIBPZv7PcRsJshu09BhdzdYLBWmPB25nqLU03YN8mnytVYik1tI9TyMFtr0/IsWtwz0pUGRcmgmMzUTx+56XdwNg9p84REr9rRpOph7R1UCHyrPlZrBGEfes8qDu1l1jha+StRoh3g1W/uNrPnT9Hx0CzKSZkxq+ybB6nblbmUTp7l35l6VodlxI5tSHJb8sm2hD4wKhEuhludeYiw/jmjnKYccG6AkBqZs19ymwGraCInbYgpwL2m0NYrAOaBu6W0jiFKSutDayHUmrRRGrKy39MBnjKKO/P1ms7gxz0CEB2QbcMsdu4VAHv65/8JBfFFrVReDs8dk9
 90BXxG2n
 Jb2R6OmiM0iZ71Z1/nnmue934cw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Guenter,

On Wed, 17 Dec 2025 at 06:47, Guenter Roeck <linux@roeck-us.net> wrote:
> With this patch in the tree, the qemu 'mcf5208evb' machine fails to boot
> with memory errors such as
>
> S01syslogd: page allocation failure: order:7, mode:0xcc0(GFP_KERNEL), nodemask=(null)
> CPU: 0 UID: 0 PID: 34 Comm: S01syslogd Not tainted 6.19.0-rc1 #1 NONE
> Stack from 407d7ce0:
>         407d7ce0 403df960 403df960 00000000 00000001 00000007 40027c60 403df960
>         400c06be 00000cc0 00000001 407d7d7e 400bf614 407d7d34 403df3ba 407d7d14
>         407d7db8 400c0e5c 00000cc0 00000000 403df3ba 00000007 00000007 00000cc0
>         000d8000 00000018 0000006c 00000001 00000000 40fe6640 00000000 40fe81e4
>         403ffa40 4085eff4 00000000 00000400 00000000 001008c0 00000000 40854041
>         f4fe0000 00004041 f4fe0000 00000000 00010000 403ffa40 4085ed00 4085e800
> Call Trace: [<40027c60>] dump_stack+0xc/0x10
>  [<400c06be>] warn_alloc+0xdc/0x1bc
>  [<400bf614>] get_page_from_freelist+0x0/0xfa6
>  [<400c0e5c>] __alloc_frozen_pages_noprof+0x6be/0x8be
>  [<400c1358>] get_free_pages_noprof+0x16/0x3e

I reported a different issue but with the same change:

https://lore.kernel.org/lkml/CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com/
https://lore.kernel.org/lkml/20251211102607.2538595-1-daniel@thingy.jp/

Cheers,

Daniel

