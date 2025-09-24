Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB679CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 13:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06F0E8E000C; Wed, 24 Sep 2025 09:35:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 045EE8E0001; Wed, 24 Sep 2025 09:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9E278E000C; Wed, 24 Sep 2025 09:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D50DC8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:35:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 76FCB1DFEE6
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:35:28 +0000 (UTC)
X-FDA: 83924240736.03.ED51F74
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8EBB01C0008
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 13:35:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lnpZg9pZ;
	spf=pass (imf18.hostedemail.com: domain of elver@google.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758720926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pe50O/RrUQLZAFgmjB7HU4D9kzr+KcVI1Eg33NkTII8=;
	b=sTb0zN9rlWHW808aHW7OnLlbx3q2Yz7Y4nrliRE6O9IaZq6JwUK2NqQ6hVdEgYvyHXzE2D
	uRRULI1hHNBRDL8aSDKGKUlwuMAoa75lx/r0khjFl2BII3qNVEjI//1STrDqbh5ZxJgLb5
	rFpnEug2jkcus0Xwr1tRcAnv83RyJ1g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lnpZg9pZ;
	spf=pass (imf18.hostedemail.com: domain of elver@google.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758720926; a=rsa-sha256;
	cv=none;
	b=qxIo48jYgZMkEwXJOdkZiPIL90y4P1dvLetuGsk+97SFGbq+kZQHyCw5tfH4VkU6Y8mB71
	bU6rD0AvABdBU6gwmRRz+ySqtoz9vWJsSHBfzcYcZ0RJ0FSjebXRFdhki5cvtpj9g+ZM71
	pyc3kNJoUNY+GTb3C11h+SzCDOLzuho=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b54a588ad96so852356a12.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 06:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758720925; x=1759325725; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pe50O/RrUQLZAFgmjB7HU4D9kzr+KcVI1Eg33NkTII8=;
        b=lnpZg9pZ56/Unts8fPQrxu+FGXW56k6jcpl36+m1QGmu/xMoeyfSRCQcdTLk2FjS7/
         BJV5xxJESHIxo6CyHl6HBWHS6X971gCiMwuSGRz/UsrioSr6XY3X0rzl8P8jIq7groeW
         G0GOn/pAo7z1Tk4sdcA/9IAFOiEAxVeDHaUh0s6ZCKZXmltiGAuO6B+wr0io6m+NFmRe
         xMt/twfDcdbhC6xdhy2rVH40XsLtF9yB8p5kF5hwAUdddikKaBJw3UR1rsgEHT8tdArY
         EOseW/oJ8JksQ7RSLNZttb3yDq2XCGNFjzsV5C7jSDh/FGm8gILubgMx6BS8DbMCOO7y
         Kxxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758720925; x=1759325725;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pe50O/RrUQLZAFgmjB7HU4D9kzr+KcVI1Eg33NkTII8=;
        b=Po/cx3lmi+/DpnW43Lwoov/aJYxROX2/h5LW/TAMXv7U+5rDJRbg3CUrPpewBP4OWI
         rHhticAyQ95e2Izr2/tpO7nhY0DXyEjIujwxcj8kL9PA9y/ByF2SgCNnWGBZ7D9Ri9FS
         Hqh32tdZXUyveRzOWGLOGRRvAXYps5Rx2dtCprD6Y0o9itFABQfIAniNYMU1uM510p6/
         Sts91JofyjgWhFIAdRqI4CLPzsPZomeIQn442+tcty9DkTLHCyJFpZbZjA/IK78iuCss
         5+FCLFLi19kNrFVMrNyF/vpGnVewy9OKbMekTCgIwyW33KeYwCGPfc9r8MUD6bUKi9hQ
         H1MA==
X-Forwarded-Encrypted: i=1; AJvYcCXeOw0dHpG/RdxYdjCHl9L9x5NvZgZHHjkLqjFilyczyEvOK5+S+S/z3KbILhIsKrQNNhNZijO/Uw==@kvack.org
X-Gm-Message-State: AOJu0YwiTso+08VW8JC9c7bj3dP7Lbd/xq7qpXZYzInWUPziQe0o3EA0
	GEyw8wJO17gDjCJHj85be62aj+QAkqRBqyEQwMWavdiJXfjmzGwKVkKfqDdW+ifnrYSNH2L7j8C
	TJRzDAjUW3jm0pLr9kNzx0ManWZ9P6RQ1N/fLIaey
X-Gm-Gg: ASbGncuxAOIrYTm/Chq+kxCPaYNbJapghdUgtxqu6pQs7KurXTrosAdM3TAAU6gT/cO
	2EqnGFWPs9oOso1p9SqSTFdbnFNCjU5RULQ+t04qLe56JTYCXlv/8kVhbd7Iw4Eu3eOYj09H16p
	pOumLkQNemIaSp4/84t/gdQ9MMkkvH7GDCDfcg/Y8fGbSuKgn8ZH9S5a8/xj4iI8sBc7WwQnH5H
	bq2PGDvaFF4pL3+htlG9b4x9HcDe5N8KeozxTdg6YvS
X-Google-Smtp-Source: AGHT+IEZB79FDy23Au1RBe1FRu0hDgBKlEfPABN0JOWEdfyHHG/R0n9grDY3ffSzMtedVDlArhR4HwkfTvUWJ+J5oOQ=
X-Received: by 2002:a17:902:f64f:b0:274:823c:8642 with SMTP id
 d9443c01a7336-27ec1199cbbmr30080495ad.10.1758720925041; Wed, 24 Sep 2025
 06:35:25 -0700 (PDT)
MIME-Version: 1.0
References: <20250924100301.1558645-1-glider@google.com> <8f0366c8-f05e-4687-817f-90a5b47922c9@web.de>
In-Reply-To: <8f0366c8-f05e-4687-817f-90a5b47922c9@web.de>
From: Marco Elver <elver@google.com>
Date: Wed, 24 Sep 2025 15:34:48 +0200
X-Gm-Features: AS18NWAZTmBr2I7oYM4SLQ_DoH6Vcj7XLTdfUyItYT_CFFhymyeJQEwdn2xWFgc
Message-ID: <CANpmjNO8J_cN-mCepSsqkG+az3QKbxZvD1zSKi29oi4prW9v5g@mail.gmail.com>
Subject: Re: [PATCH v2] mm/memblock: Correct totalram_pages accounting with KMSAN
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Alexander Potapenko <glider@google.com>, linux-mm@kvack.org, kasan-dev@googlegroups.com, 
	LKML <linux-kernel@vger.kernel.org>, Aleksandr Nogikh <nogikh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8EBB01C0008
X-Stat-Signature: xaykwiiidwz7hh8k89bddcrye8ouobdb
X-HE-Tag: 1758720926-468194
X-HE-Meta: U2FsdGVkX1+9hvl47bAZtA8C6ZDFJ4huk6Q7yodTWkIQeCrJpXSZCKwK/H8W93mGkQUE674MnAXEmm9yFfwQxWZbpRnX4F4hGGvrJfUZsTMpT/I7g+C6XRmMOQHwJdj+yVur/LJgjfOGb/Str5M20pFcPh2dZRhY+fRU5mvPjsJKFpset2aKRfuZEY4eUK3JKoAGfMfovMdQ2qmCuv0nsUQNSeoqLBgOi0V5V1PbtFGk8MJ110vzTQotgI7Vhcjsd9EcZk2mEscxcH84y8zZ6GwI7J4uxhPSaSQVm0zeO0jx32jSxHIFuINx4V4l4CI3S+z8Lsp+YykQOJB56qkDKk4OeLfGqyU5pI6ke5EnyUM/XICEnhXyQlXWlfy21ZxYYcdXpn9SF12hmHfxiPSOee6/ttlChB2BYVI/CoxaVCroGGFtGTQn+0bvVWQHghEC2035BzJjw7RhNzaEMuFTkHVwzri5y3H/tR8hV4J3istvDbMN3piWl8z631TTpKrxN5CyqefndSEWbDhKrKPUfu4ym3uN/Tj8pRxZC1au8sHN1+xGKygr734RakTaLTlJJ0qSjMaB3h+8LJ2TGFqq0acJVPhGGex4/ey25+s2ldNjpGK6P2Nj2WiekoW7zP6wDywhpRJLhUcUNq0g6jXY3khLDZaHmWDArQA4T+t5I+N9FGAIT+TwZ9a4LHXa3mHohWYo5GxJGNaeoOsNTzpNjrJUNIclTS4sy/kXHWN/MhCErNVP7zufIbY3H0Xk8o0I0DcTpSXgheUR+ZjpBosMg26SHN9JFZkGZYfvSTRBWq4olxLoLuz5ZMAlT9hU7eeTPtMY+EnQzh7QDdpFc8twBrG4vRrDnyyp5CN9Y1dgltp2AkWdhV/W3fWCJ+z5egIGqW9JvDCR3iYzw4UUcmrvvtyO2TDaX1nXNqudaA0sApmFDStEuNc2LsDxlA0FQiSWqSQq+I+rGmVJ5Y7J4mC
 FagtJLgm
 HfJnpsrGagOH+G61uGzpyrZhxMGMepC72i0rUuBQOY30Wa79mHwSIQdDtASQnPP7T074h1QgmDUW4Yde1j4m39wCJFnfEJd2Yzvy+ghSPhs54jWYOyg0ZOqJZ80wtCJeKDp70s+erWRGf6XW+WD12rH2aJzrx6GHM4gCBSIVh2Y0NoGFvT1fdK94WfCh4qv5zjc0ZRxGJ6WGgdBwpfvc4YyMQ6tgMMTkDwPuyO4BiK9GFFO7FZYI3mYmiDIUGHgeXXvdPOTfRsft1vT8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Sept 2025 at 15:23, Markus Elfring <Markus.Elfring@web.de> wrote=
:
>
> =E2=80=A6
> > +++ b/mm/mm_init.c
> > @@ -2548,24 +2548,25 @@ void *__init alloc_large_system_hash(const char=
 *tablename,
> =E2=80=A6
> > +unsigned long __init memblock_free_pages(struct page *page, unsigned l=
ong pfn,
> > +                                      unsigned int order)
> >  {
> =E2=80=A6
> >       if (!kmsan_memblock_free_pages(page, order)) {
> >               /* KMSAN will take care of these pages. */
> > -             return;
> > +             return 0;
> >       }
> =E2=80=A6
>
> How do you think about to omit curly brackets for this if statement?
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/D=
ocumentation/process/coding-style.rst?h=3Dv6.17-rc7#n197

No - with the /* .. */ comment there are 2 lines in this block.

