Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D9E8E6B25B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 23:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 981DB6B0089; Mon, 22 Dec 2025 18:38:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F786B008A; Mon, 22 Dec 2025 18:38:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 852C36B008C; Mon, 22 Dec 2025 18:38:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 766276B0089
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 18:38:36 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 33F7C8AEDB
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 23:38:36 +0000 (UTC)
X-FDA: 84248723832.13.74D22F0
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf18.hostedemail.com (Postfix) with ESMTP id 531421C000A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 23:38:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CsIOy6E5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=klourencodev@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766446714; a=rsa-sha256;
	cv=none;
	b=Ju50CoshNEY+GGkqhv6uoNSv+Dc7s0jT+9ln+0pYtkEUNgWNr3LaXBh7eZTqnskrK4zWcU
	5DEmKEdU7EHN0a2KFN9w/asi88X6i/x85PcTI2LAhOowTGL/IvkQod39kfsIeT4Tp7kMHC
	iR+JiOdfZXDmbrqFwQjiXM5zx5Nhl88=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CsIOy6E5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=klourencodev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766446714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAltUZH5yvrc/p4uA7SuEwhqe10XNpsv1s3Z3yj7Dr4=;
	b=vgRdVGihR2MJ1IZvk/ZejxjVoGyOO7aqha71uA9Lm4BySZ2by3m8Pc/KtiHpGuGLIUrruo
	lC/ld0VkQ5uzpiX0H+af5WfLWkPJnNZIU4uoKzYyvCk9qnBxTkt5+AJ+btWMWTpGWq7p3w
	MkfBWg7cQPljDFZBJT1CdtSx6y+qv3c=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b736ffc531fso792936466b.1
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 15:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766446713; x=1767051513; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aAltUZH5yvrc/p4uA7SuEwhqe10XNpsv1s3Z3yj7Dr4=;
        b=CsIOy6E50kBiLO4EaSsgZuf6IWarzLdHhyb3I+Hc0JtWBJV9XefMiSQK7fN3si8ZL+
         A/CkKmEg5YIQEc0cV6V6H3vd4dfTElbs2tKSadwYxDe90smKEvnIWFUTy6wDqtZsGSEd
         Pwk3R1NcWcSbBLIaXI2RZQejhuXNHctd2mq9UWPZ7qBCZTmbypA8HZ2m3nHblHWFb8kn
         1esQraUugXfg44YZdX8Wk5bX4x2EngUkuYLJV/2yBBTAEvGBF6+fKZ5q0dtjsNOq2tWP
         3mnM5hAUZL1dv4541f7E3up+23dBVL0t8j/TCBFQmpFBRaui0/G0a7mBCfLvGV2xOFgC
         dGyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766446713; x=1767051513;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aAltUZH5yvrc/p4uA7SuEwhqe10XNpsv1s3Z3yj7Dr4=;
        b=WfEcAbji3i/aKkvSv2V7HHVteG1bhkSQhFu7/pMQXkq1j+eQi8GGxjedV0WLRXv1Gt
         ELa63U8+jrG2f6BuGWNspuEBYP5HJ/1V1SMBFiVrIoalx+wgRd0ttJqbGJg9VOtAWG9N
         rqf7UjuTutBveMnwRV8KDH5DdpmxTA1QFjQD57dGaxOaQ9QTsJU57m/A1DmO59wM/t4z
         qI/GKsDlwtLuvThNtB75Hi+aRHk4CBHxVRkSTWPpGOGjL/iAZsUAEprGGd2Dvfz+FFEm
         DQ3Ml8tjrNvSm7L1sglErxXxJtpdDjSX2+6gEf60ZnVkBa2bauOphZJzd5fMia+ngtQQ
         zVXw==
X-Gm-Message-State: AOJu0YzaSKar3qNXnNN5XjFveuBK7nPiDtcZhKEk08xr9t+pOg7ZZffI
	j4z2rUdChWfElQRqUaoEp6eW/O4gZF99ghWq72+sDp6gRqNdSGH9MNMfPFCI8b0qhlec3jaQLdM
	WcYwL78TlOFPebzZK1Rc9yEAW+Ly5HplYvw==
X-Gm-Gg: AY/fxX4eQI9PYRz7SjUnCWtmAs0Z5zHWngq5f5/ANcyEksCxVn0ZPstSt2KAwwiZs5n
	IIyZz9DPv7ZV/H1etnKvyfW/y+MPTLxtoMvPYMrX3fYsNCBTNyNqsKd+tB4sgaxBnTKIOiCx/Sx
	0r5NZcsIpl0HrlYscadvBzmtId5OKl1M3Rmrg4dvMgQLXOkLvgFC0OVYk7LPV5jicXX8IPuch/A
	vb0m9nS1xfu7oXoT3L2n3Fi+9HQgrKRqrTgfjGDyUSjtm+kJYTWgXxoq3xkAQKzDVdDIfBi6HLX
	MkNh5Kg8SdXXa5cMMqCOa7QVGLE=
X-Google-Smtp-Source: AGHT+IFDN6WWO1QQmZN3R/lMaejqVPgAS7dO9jdaWPFhiCnUG84sJ4KNwT1Wrjbtn0onoNT7vWbatHvDtdFGf7d7J4E=
X-Received: by 2002:a17:906:9f92:b0:b2b:3481:93c8 with SMTP id
 a640c23a62f3a-b8036f1d812mr1202951566b.19.1766446712376; Mon, 22 Dec 2025
 15:38:32 -0800 (PST)
MIME-Version: 1.0
References: <20251222141817.13335-1-klourencodev@gmail.com> <20251222095248.18c4c102abcc8fb4f61c7067@linux-foundation.org>
In-Reply-To: <20251222095248.18c4c102abcc8fb4f61c7067@linux-foundation.org>
From: Kevin Lourenco <klourencodev@gmail.com>
Date: Tue, 23 Dec 2025 00:38:21 +0100
X-Gm-Features: AQt7F2qsDhp4u5LV9CR2xD6WKD4jJMPjz1DHUTwwJF1Z2YzR1yZB3JEJJCcbL58
Message-ID: <CAFveykPzenGkWKZvZx+f_n2Noy5mNMuF9=GpZVgZ2QWUmauh3A@mail.gmail.com>
Subject: Re: [PATCH] mm/fadvise: validate offset in generic_fadvise
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, david@kernel.org, 
	Kevin Lourenco <k.lourenco@criteo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 531421C000A
X-Stat-Signature: ng6mat5xs7mqbyekakxrfjojtsend8a9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766446714-840581
X-HE-Meta: U2FsdGVkX1/AHHoWlnYRpde1WpOJoZQHIwKIWv9Ov1FD05+acB5HLoD3yQxcXF3ZW13l5SBANumo7cUmT3L83CzzQI9cUWK4qN45wQUSsLGRH/8K9N5NPuhUJT7s/vjNAlyJExWCt3JEZhGo3PrzTxUnVhMFJX6tKejsJI1ElPRzYERf2oHM8V/tMuwKjGMjnNHzXEtCapAL1IC0Nj7QQSiKcHagwV08RNhzQnaqCY4Fmk/TyQBClWMJv4U97xNjSzR6Leqyamc9OZVOWKQDu5cP1FPSPXhjK+oK0N+afisxMO4oBfMGQLfvNodFCsTGHlHQAHvCZkpAFXhszwkV3KYGu/shA9Jf2rdCYeWe8cYadDz5QfNBwVNZJDWHzmZyK79B/qUNJ7WRZtvMnemjJHclebTHjVxUerAHDJJ7O0vE+EnCLevVEyu5zuJENgTgiPknRfV/zLWD9p/2waOk0w9Ltn4GYnN43xKzHYMMIPtzjP0TTF3wtbF8oKvIp6HBMR7yRzsonMYAkebvCrtpsJD4uOy8HuafmGop7+cnPOecsCWK6i+Cuf5GqC8bOs/qtNUcsW4JbNKimbr9H0BrdlApnSBEYiI2P2x1wB9FZoIPKEzPbEWMNh63jVEmIkhsfOCKnVdaFAT6sV/SGXvsn0tpSkgQ7SOR4FMPUur1vUejnLid6Wf/sVzjhgtNO8jpc5+bL8oNwKivUzHV8vIAZUNXMU8qV3Lwd7Lv7iQEFrBQ4X6Z9sizuJUCyhG9M9RJGnWRk2av1uiYtPIFA/wZZcmvo0uR8ix5h2wiY4CpBx+iEgIo2n2w2UnDl0oD6ojO38seC/eW0zbKzrOoUp6OtjIOQP7uz4tHZfQvdPruJ7P72SnRTgCHIDeCy8kvcXi+iJThz+mm+yJ2n/4PifazX3mjuZtUmh1sBYJqMQ0tUL7LWhWRPGNtLWXXGsbPNjAVlhkTYt/F7Jefk8LHJTU
 r6pCgmoS
 NSf2oolQnws9Md3VD4pqTzt7GupNq/tbUSQz/TOOlSzkAWQMnCmkdRMFwFUf7okjmvAQy2J9UFYjEE8HqG5NkrAwjVHaBZ2kUmO5nnUWCUQ3hAkachtSpm/BN08ndaiidgaWZUD1sP7FJt8mgKluDROh0JABZ/2DQgjQhO+x0eZ58WLTI2D/5p/J0ZB9rRPR3jWXFul9p5/BEmlZM5w9uohxG6a0aOOp2Y5/F618Y20CzylmHUgBKtYAE/AYTp2SRaudnSqhH7Yy6Pr7gSZJ1tJcDbMaR/3S0s6z6I+sHT5GfLMlrEKI1j9gflabQEHqIN5kMDrASbiGcWvk00NJNJsf8llnzgQf+sx8DapOaBoYoBsf2NeekD6VL7rTJVdnRB7S3BU1QlN7QlsnnWJxFy2J7SS7tccsnACGfYLzVfNUNdLiLtx4yjtMVKz+0MkxQahVTMLraW5X0V9hEyo8b1ajl9Rp8PQ1olLEU+5CyteSPk2vqKmIZ9ntwiD1/+nxBBLcKSp87sDI3V+jZWsTfo49L0rCFnc3M61a3wCcHegT7xl465btD9NEX5/2HDrMFIQwc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000143, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you, Andrew, for taking a look and for queueing in -next.

I'll keep an eye on it and will adjust the patch if needed.

Kevin

Le lun. 22 d=C3=A9c. 2025 =C3=A0 18:52, Andrew Morton
<akpm@linux-foundation.org> a =C3=A9crit :
>
> On Mon, 22 Dec 2025 15:18:17 +0100 klourencodev@gmail.com wrote:
>
> > From: Kevin Lourenco <klourencodev@gmail.com>
> >
> > When converted to (u64) for page calculations, a negative offset
> > can produce extremely large page indices. This may lead to issues in ce=
rtain advice modes (excessive readahead or
> > cache invalidation)
> >
> > offsets are normally non-negative, but the API does not guarantee this.=
 Since 'len' is already
> > validated, checking 'offset' here is reasonable to prevent potential sy=
stem instability.
> >
>
> Yeah, seems this code really didn't think about negative offsets.
>
>         fadvise(fd, -20, 40, advice);
>
> does make some sense I guess - equivalent to
>
>         fadvise(fd, 0, 20, advice);
>
> but whether this is how the implementation actually treats -20,40 is
> unclear.  Probably not, and what will filemap_flush_range() make of
> this.
>
> ugh.
>
> I suppose I'll toss this into -next for now, see if it breaks any tests.
> But more thought is needed.
>

