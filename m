Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 855B7CCFA02
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 16:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2B7B8E0003; Sun,  2 Nov 2025 11:57:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03368E0002; Sun,  2 Nov 2025 11:57:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9416D8E0003; Sun,  2 Nov 2025 11:57:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83CD58E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 11:57:54 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 153F589219
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 16:57:54 +0000 (UTC)
X-FDA: 84066274068.02.7F02750
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 30DD31C0007
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 16:57:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WUQZ6dH0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762102672; a=rsa-sha256;
	cv=none;
	b=MlOUmWolZSmI4CfUME9M0eCW93ajCUAConwhjfrq2Ei/t6Ecx+vw64R9nVIRBtlt5jRB8l
	89xrWiQ6w/nvUhJuIrRCDLb695yfWzSMHr+jT4a9F3U67c/IT4L+y/y1NYR6fiVUN/H2qE
	Xsj3Nf1UH9c4HQNxkYjl8peAA+uDf7M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WUQZ6dH0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762102672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8D/2LxIRqPaEFpcJY4xTpfZFJoJ4QwYTL33/bGyG1rc=;
	b=AFuuVWSy/PeVfwvWaM1kvFhcW9xO8sPX0pVqwI6hfmDZHjRMVvJd4Obml4isf3ATHQYHz2
	48z2BigfCfUrUaBgKzweYPPNU27pfmbrgIBsQd/ub2mzp7Ka+wJZJ2VSiqWRIDlBTkZKj6
	briZB6/tNs8s5ziCnn3j42UOy51g/0Q=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b3e9d633b78so902787266b.1
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 08:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762102670; x=1762707470; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8D/2LxIRqPaEFpcJY4xTpfZFJoJ4QwYTL33/bGyG1rc=;
        b=WUQZ6dH0xDn0X5OQvGhVFOlenJQHDnXPwEXVbHeVaxGK2K01fYwHslzopHCiihJR9H
         OlOD/dg5v904Ob28n++pZoAOmIFxsX2GEhh3EhbOGWZ2ciu85q35zC5d5jGL4y6odO6v
         nlgr9FSqC2k7u4h7Xys8rPsqmDV/9dGB1PF5flYIwb+4zI08O4z9CIAmsJ3RpMiRPdyv
         LXgW060Itu29sGHUp4fKhpsx2rFeJtDJtzJml0KRdhYFu0+r2qqI9oR09RdF2YN9BIwk
         kDDh0jcMe637L1Am+5xTl3ZmcgK4seb1X9gvtDcjb1KgxJbMDLAokkxb0URs+WNhdKe+
         5rag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762102670; x=1762707470;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8D/2LxIRqPaEFpcJY4xTpfZFJoJ4QwYTL33/bGyG1rc=;
        b=TMolmbK+QI1OZFn5wkowMzq+tnRNdf1MzxahXoCSFEtNOQC9szkvyj3y8QvUe8MxWe
         Yd60Awvhq/je/SleIxLmbUTrX4Bxx0KD4HgswaeiD90x5l11xoJDKiJh5gZa9r/tKcnt
         cCX3INg1cZrxsoudlFbjPbzNZrUlTUwEBnlTJgGXcoZ48cV9rK1jd16mUh+yA10ItzXs
         Pdv+uRVZQPP6XVIeCpIRBV7Ly7TZsNzTCDDXPZtLUf+I9GjnRFZQC0n5ZMjIJFjMgJuV
         tn+5oTIFucsMT999c8uEPEOt3nb0aeTkb12MTwuc68lqyZjPDhorNhtsI/jr4yX8Othg
         arZw==
X-Forwarded-Encrypted: i=1; AJvYcCU9/R810CdeeV4ROgUQeK0RG3RC+wfuCOFU5pIbOKau2yU9R1Fkp33CAR8QkbnylqdKXzaqDJy0VQ==@kvack.org
X-Gm-Message-State: AOJu0Yz8R2Egz+AXVmaMIdAwztLoI+nDVsALm3h5y5lW/BlSyhbDpkwB
	9blL7fFctSUK4cZs4SYDaIT64Zjlxp2b2rCR4dm8KKyGYY4j8vzlSc7XGj17otlBE/VVNB7/Hli
	mYBAL2jBj0OLql+J3c9HbgmgRBTxF+ag=
X-Gm-Gg: ASbGncuOGAfTDoKWTOVdVJrb0CxpoOBxnXUTz91i534RrUx4+l5hLQ2m0PFfiVY2bJ/
	PKjZJecQ3vPfBZ77aVEBrOCxokw/toatOEc8g+ji/wGwPyAnSOxfhwQRkY864FwcvomDv7gWE+f
	cUKXNB4GRGNJhSjyKjBn6AKY8BhEF1TwBGNlyxu7O75lSXiYnULPj3zx6q/dkj0IIcVpbBeP6v8
	BJGzs2F7WMgbapqR2S4vc64Ne6Yp3dtsWJQps3Dzo5q/YM0uhFltgT18pVUsTQK
X-Google-Smtp-Source: AGHT+IF6kTS+BPq+5g0QzVhd4H7jJGaDHe33YwK8YfXloE6tTgIk87zoSHroCKmGlQ8/BJmiGW2LNXgDUOPRTx4dCUw=
X-Received: by 2002:a17:907:3f89:b0:b6d:671d:8814 with SMTP id
 a640c23a62f3a-b706e5823f5mr1057229866b.27.1762102670334; Sun, 02 Nov 2025
 08:57:50 -0800 (PST)
MIME-Version: 1.0
References: <20251102-swap-m-v1-1-582f275d5bce@kernel.org>
In-Reply-To: <20251102-swap-m-v1-1-582f275d5bce@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 3 Nov 2025 00:57:13 +0800
X-Gm-Features: AWmQ_bkaoXNCTN1n6otnUWB6pWjlguUIqX3xJfiZv2IxdZsnRJDYnUHIqQ415CA
Message-ID: <CAMgjq7AaPEAWF64qQ7mbcvoV18R2h19yuuw7AjWYyS6eWanw_Q@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: add Chris and Kairui as the swap maintainer
To: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Minchan Kim <minchan@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 30DD31C0007
X-Stat-Signature: kmhp7s4uwq3kj4nt5ezgcwtubs5oj7io
X-HE-Tag: 1762102671-665342
X-HE-Meta: U2FsdGVkX18cpHjwQIC+syE3FtLqs+71wLc/umd0F4qpLCLkTtCuplNVt4nu/yJCH4crV0xOphwp/t89j1dUgIJOnEbAq0Hs9f5f/ftFTivnzY3KVa2Ft9fbiEEj5Afb/IyUo6cF7eMiO7lclWa/F6JWEJm2rG+YEaRILI4S8jjPbRFbsPjr696xx4Xe8sKoawRHw8mTdNBcPet6aB7beNV2byLc7i0X2A+g6G7XZGZibKJMZDR8cMvHcUDrVD7FhM382aErk0YCR04yD6KmIa297k8JTYnRyti6FS4RlqiP9vVh8hVbzWAyRWTKCdnTPcW9Id72bKa/VaTS/4TcT4rbqVt2TwtkztU5vYZTC9PGCF87v2MDiY1VcRqvU2B1nuGwbRG3a/iD749e4Lp1sHZhJ+3JaMkC6sGO3QibyQANPVo69lLUvDgDeRFHUy6DQsUw6xMrushMJ3BJm+6VB/Ps5FafvHmUseHIBZzl+f7QHF5dOneUXD7AXodG17kJb7PyCSdIUCpToxPFeA66cKRY2JX8/UgIDw8uyuXInlu6Bdz/PyOgRTUU3YqczQIe3nEMuiywcVkcMI2efdBaSJMr0Au/yC1ZAdOYLgunn7RywtMjUGlvfPl59htTx6usEDYkdGArde+g+BZB4LoVI3OrGA2qq7ZN0jozNwBGW69L+9eQWbjLRsKFKYzrRSH/rm6udwadRQTKxwUipzRPqs9FlWiD33RNbtUdo0Ccupp3DRkzQHLTRBxkDyM7VpnCdb2X0XmJ3Q9GaXe/0pfg7GwJvUWMRIrhG6qqOoiXl0JQnrU2fBmxpg+NE/tsig7H6gF4VkVWDTJQpO0f1XMpejEXCiiKPs8fP1rK2TJ84viAivAZj6qcnJrK4n1XtT4D+agHGtyIKgha3BgR8gaVMsDEzYj5RLM9GJCTdlxfTZmhNYymakKcWYPgYMCmbFak8kBJMNmJITsUovna6fv
 KDNumMr/
 YQ0F+GSkTjQ2Uw4qCAx552TSxjMgNWHPO2CwDThQtRwOvWdJSq+Xz9gkx4XE/P630AXmAfkm6x/b10oWE/c01HaqLADaN/u9FLWIHqxIDHqfTnlFKF1iJHysB9GsTi/aYzqKBj9jOJe/mbqdVmTalm3HNTMCAJ9sbySP+FgT6P9w3UqcEILfpJYJOqkTe+eVQoGhsESmCHrhJWm/hFaKs91zuXHmPOoOQyiq3+gMCh6tR7G+9CdRSqyXtAiD/UPEViVrUUOhnrkwOZ03zacHhkKE/KxpRRugHibHmKxeb7EdS7mfVXl8zwciGAJtYn8EBUYwku0sTVLyvVt4Bs4kCfse5vvSP/G9oVdDacpAnHXE73ZzpX5Xy/GjPj24RMrorenSWMChfBzC6cLRtB4pXwzDXPM5tY2ReFWQwBHIN9U7J/H46RYV+AfzxPvxuTyjgDZHvYGyNCr++xjabiRg3FxIVQgatATQMTy83VYOsnz57Orb7Pitg3NA48K/kl5GCUfZhrHFpqNqsrUuSpXGQx4hzBw10Blfy/rZzZtWe0/N5poFw3qz8L2baFq330UhJWMi21cUrcv4DQmPImm+B8ZyHEA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 2, 2025 at 11:39=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> We have been collaborating on a systematic effort to clean up and improve
> the Linux swap system, and might as well take responsibility for it.
>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2628431dcdfe..8b5af318a0c8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16497,12 +16497,12 @@ F:    mm/secretmem.c
>
>  MEMORY MANAGEMENT - SWAP
>  M:     Andrew Morton <akpm@linux-foundation.org>
> +M:     Chris Li <chrisl@kernel.org>
> +M:     Kairui Song <kasong@tencent.com>
>  R:     Kemeng Shi <shikemeng@huaweicloud.com>
> -R:     Kairui Song <kasong@tencent.com>
>  R:     Nhat Pham <nphamcs@gmail.com>
>  R:     Baoquan He <bhe@redhat.com>
>  R:     Barry Song <baohua@kernel.org>
> -R:     Chris Li <chrisl@kernel.org>
>  L:     linux-mm@kvack.org
>  S:     Maintained
>  F:     Documentation/mm/swap-table.rst

Chris has been very helpful and insightful, I'm glad we're working
together to improve SWAP.

Acked-by: Kairui Song <kasong@tencent.com>

