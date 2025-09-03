Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E94ACA1011
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 17:08:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 897378E0012; Wed,  3 Sep 2025 13:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847EF8E0002; Wed,  3 Sep 2025 13:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75DD28E0012; Wed,  3 Sep 2025 13:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 604EE8E0002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:08:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 262B71DEFB7
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 17:08:43 +0000 (UTC)
X-FDA: 83848573326.22.5C5FC64
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 28A4380003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 17:08:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="WvMGkJX/";
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756919321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/FshQjGscW6AK7gc0lIFS3uvoLvZ0MarkksP9A4ElGU=;
	b=kZh59MnZqHf6OPMxh/WrDoYPm2NLyRQXOwNr3sG2FqtFRRUjLK+3Qxn2UjpTxUp+NjZxAY
	Tv5ehDlb1jCiI4Ntc/FjeXB7EUNWYXO48lSFb82UUAoRFKLzwj1XP+iCgTHmiDFWA89j8k
	9ZglLBGr6AYw89x0oUu2JLwoHClAhA0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="WvMGkJX/";
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756919321; a=rsa-sha256;
	cv=none;
	b=Ync+jhlEsLzpCJGPUGYDOn5VcWD/2gwmG5hAQn6/y8z4uQhbZv5mWCpXo4J5Xtg6zO0K6e
	WtqGZHEXggdRJbY0TLf4iilR1u/w3qvuLl6OYVZzP4P4vdgwzE3/1ZOWTJMuYaj2vRfEAD
	+jHjKcyiCETVvAcuPhn/F8+4efzfrtQ=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-61d14448c22so278a12.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 10:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756919320; x=1757524120; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/FshQjGscW6AK7gc0lIFS3uvoLvZ0MarkksP9A4ElGU=;
        b=WvMGkJX/CyXr9TQkgJe/BrWWrMGil5wnNAM0569LwSknT8zr2D3sonDqbBgIYNFF55
         +ucNItlwMRbXOtE6ytVlIm7B3RmN1mqDXavTPIswKFw5ez/chfgK+sxZMIRd2YLHTZgP
         4/sKKq+l2rvoP1FawTbYO/1l7BAICtzyBnxoyoL4pAE+75jl5Usc2yh4CPbC/I5yhPKS
         4rCjXE2XsRQwkVYH+4S8AjNXfP4fD0Ab1n3Zs0Hcn3C1BvT9/bhAiEivlOmB0M9MLE6B
         alkEptfXhIfdG87eTWHxnZp/Dz9EVkkMJNX6cQsGhOqTESMM6BrRJrXT+tDkku616HPQ
         0QYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756919320; x=1757524120;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/FshQjGscW6AK7gc0lIFS3uvoLvZ0MarkksP9A4ElGU=;
        b=R9FaePMpA3T39m6Uj70Azn7/p1rGWxzOzG9fJaf0Jb988kX7z4/uz37fW22Blt3Dk0
         9wtlNy4dGFwtMwrPlcRNka/e/aPwBwVC0oore3v9b0G0RbPWtqADakyvdyity9dOlC1V
         nctR+akqu4z52OJmIXubzzxhVxtQQyjKh+Fh94NDmh7jT569DNcnfZN7tlPCAh+sWKB7
         uFs8VxNH52HsHxJ8wKvjoRd72HH38GWk6pQStcGVei5bEwa2ALMwxnyBDYFeRD967QW5
         tCr/fL3gdg8RkWD+AUm0IZH7azYcHOgRtzU+AZx7OMJ59VC3emac1V8JWnx1lqCGwwnP
         KKBA==
X-Forwarded-Encrypted: i=1; AJvYcCUX9F2p6XDMQqZVq+20T7xn2gG2t4cvqP1NZm4nJZ4FqIHGOy70dPGYA+j6iMS4iDRdOXn4q0Iiew==@kvack.org
X-Gm-Message-State: AOJu0YyTr/7/UPQVO+SZ84x0X/nw839sDJYKFbTvMYyPDnwC3M5fXi/l
	sOEX3BEIwmBqRsXSWL84BiuSB39B7R8UKl7GY00q64N2/qs1d4ToyNJc4HQiZz8D0mt65xVAEW2
	p+cXp7VQGHxtOtFTy8N/fc6GgTy6o7fl1kpoWOwZm
X-Gm-Gg: ASbGncvaNgCxVYLXiGH72ZPjz1zfTYxlShtVaDBuZXHKuhV7HR06e+bg7APa5ignmtO
	703xVSxKAExbWXZbKfnh/0VxnsKYRScQUhkC2786RNbymARpzA9RKC1w1K/F2swgLiSHj4hTYGW
	ZEGNIxob5dQdsm97dSnoM1A7YKyjqxkJYLmAjaNtME73NZwM3lYzOhzT7l2InvhlYkMAHQumSLO
	oXUSAPeygtDfnHnFxEouFvZPer/D8X4wQQSkXWv16OagFziFFmRO3HKBYc=
X-Google-Smtp-Source: AGHT+IHxfEfw62Su+HKG4JBWo3W0aBGajU1Xh1NsFulFe/66SMuM8pHjRvYAAFDyII21IadxnUuyNeeJi6HBZV8G06Y=
X-Received: by 2002:a05:6402:a0d4:b0:61c:d709:ce04 with SMTP id
 4fb4d7f45d1cf-61d21f8f882mr468669a12.7.1756919319452; Wed, 03 Sep 2025
 10:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1756897825.git.pyyjason@gmail.com> <4ed91296e0c595d945a38458f7a8d9611b0c1e52.1756897825.git.pyyjason@gmail.com>
 <087C9FD8-BEDD-4CF8-82DB-E3B909FEE321@nvidia.com>
In-Reply-To: <087C9FD8-BEDD-4CF8-82DB-E3B909FEE321@nvidia.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 3 Sep 2025 10:08:26 -0700
X-Gm-Features: Ac12FXw1gYyhedLLejRbTL6Jpooa3X-CPGeMAti8LxEga1BIvj3YabGnl81tV6U
Message-ID: <CAJuCfpEUBFk6uHieHdsXoRFV+WxEgqW7LOvz1wKfrU=uKm-Uzw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] mm/show_mem: Add trylock while printing alloc info
To: Zi Yan <ziy@nvidia.com>
Cc: Yueyang Pan <pyyjason@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vishal Moola <vishal.moola@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, 
	kernel-team@meta.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dgrb19i7tg6djn1bw11mxgxwks66bsfp
X-Rspam-User: 
X-Rspamd-Queue-Id: 28A4380003
X-Rspamd-Server: rspam05
X-HE-Tag: 1756919320-736346
X-HE-Meta: U2FsdGVkX1+bYuN421IAIuKuVYFngeEQyZPDL7vQk85baT3Omuu0USVDVmOYC1B3QekryHZWUhAmmyOCn/HD2Efh0wKFU4B060Y7U6zymoWy2Adan4UXjtorvoYiDzDh2qIKUuBHW0+shAa3VcWDngJyXrudSKx89As9A9dnTP0OHznNTjB2MRYkqKJnsDQHZt/S1vVwiYzhgMeY15UjK/RJSyKqzGajXOJ/T7VOcld9RW6ElGaoYlc9hNajA/QM8ZSusf4iYDVnUql0tKS0JvcKZJezgGq9djCK2AaAvIzyeATFoJaEWDjA1Car6F60uifanWc8IpG3aVDTfEpn90RiG2ADryK4GzA6CxeGATDVP57+D+QsjiZQmbPadO6HU+vSAvW3Ql6dHiQ8OG4jrp/PV1scPehUix/P/2/8GqzA/UJPBcSBawSOoUXF93CC2+AgzbsyHjl8VBXLqObi2gDvLjXVezi2nXftMOOIIkzimx3O9P9qLWq6zRG/fOQBLuOgtUHjUZsfKW38o2Oop7hjCxHVoPf1NVnYTPzYbX61EVh6Mh7dInJu0nxt6LOAzxpzsiYuvbLBaUGH//yNxhFXKTA5IBL+u9+b4ZqLKokEwU5SwGI5NWpsDXYZ4lyw9Q0qSlr5/siw6t6IgGknhysbdRJZNHxWUFQn36lPj670ynSXsH0oFrKk/QuD8m/nuMU5t101oMaZhF1tbidSVcbQ9KDNmowFFsrYNOltxIiPuCFzelpTUFw36evgF8vadJTpIljtlqIQRurqNRANa7XIvZHtIgkAIdnCdA2MOBrQMMCV/hTapuey8kYzbg84gMrVCnFVCoj0Sg9s7eocCSnZrz1Hvllcn3JznBdKLLTvZK0T0PI685viI+dZFNT8cHNyh9LJx7l7U/lIN2AFHFM2O55fZqRuw8sQ1PE5jkkbOghqNo73w0gRXb/BEelyaChWecrVcBlKgYbareR
 J2gA1P5l
 sBzRlTV0E6gme8J7vSueiKhJ/hmwWJtATyyJqHKKtl/FckwG2jVm1BwPQNrjr30D/C3hic3ApPHA+SCOjRm1lEJsgRnmiGE0MqPAjhGm3u8obbfjkg/GhLCCd0Ot4UZn34J6XAKf8QYKPaionlLkkdEjkxxCKfkDE2LGq7p30udauBDMRbacoInykJ0p6e1U8dWuB6uek1ZbyMjR6jJmga7/1CE4ghtCZeiSYez/VGybt0NzpK5QM2klKQ22GoLMWfUblkBv9Emlip3Zy9qH5wukiqx0y42AV3Jdjg/EFbm7xzabn1qdHJ0xGNPgCTkJxWkI2jA3qth7gkpKDE9pgFli6wbdX8XhKiMzeczTv8+n0TOWhhBSlsCzlmeitCsAUpocu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 9:30=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On 3 Sep 2025, at 7:16, Yueyang Pan wrote:
>
> > In production, show_mem() can be called concurrently from two
> > different entities, for example one from oom_kill_process()
> > another from __alloc_pages_slowpath from another kthread. This
> > patch adds a spinlock and invokes trylock before printing out the
> > kernel alloc info in show_mem(). This way two alloc info won't
> > interleave with each other, which then makes parsing easier.
> >
> > Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
> > ---
> >  mm/show_mem.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >
>
> Acked-by: Zi Yan <ziy@nvidia.com>

Acked-by: Suren Baghdasaryan <surenb@google.com>


>
> Best Regards,
> Yan, Zi

