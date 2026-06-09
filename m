Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3EF1CD8CB9
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 17:56:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEACC6B0005; Tue,  9 Jun 2026 13:56:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D74996B0088; Tue,  9 Jun 2026 13:56:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C516B008A; Tue,  9 Jun 2026 13:56:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEF6A6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:56:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 549769111D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:56:53 +0000 (UTC)
X-FDA: 84861129906.14.60FC4A9
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf01.hostedemail.com (Postfix) with ESMTP id 48EEA40006
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:56:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rPB24reM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781027811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hL+zuCbR8JcMHfo8scB5eaUZNpLPwPJepcA7ZSa4BEM=;
	b=Nz3RcoMmrNG+ro3rPbwKmnNDSOSOAyXAhHzBQhFDnuK4XSztcsropG7y+Qm6CQ/F9AuZ6w
	0S7yyeB7t3qw4Zjk7TyKM7UEXe2AEgiMrmeuguP/qYafw7aYl1btYvOW6EaUOkWRUgXjZd
	V2jOlNWq7QTpE4Iot0pfgYZCEskXNUg=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rPB24reM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781027811;
	b=6eopk0Z1rjdkQ5IvjVNlwfCkiByZvkcDA6eDRWKpG0CKPVpUfLdC7MEB9rHNJDhXfax7zQ
	SWVwwk2GsWtJuxzN7EyfvQp4/6s4PIpvSP7kKoRWY7yaY1p3ARfYhW/efqVu0lrfuKGso5
	V19YyiFkFXX6khma+a4oDdZn5UU/rBU=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-45ef1629ff4so4074470f8f.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 10:56:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781027810; cv=none;
        d=google.com; s=arc-20240605;
        b=ROKLUIrg1FPgRT7DIoz2d5NKo5QeuMUd7GDdoQxYMvq9nzk8RCxyFU6wJVWn2l/q+o
         IVjkZPlup9gG1OCJX8NfsRrJWxoWHHAD3oNEGVXDBTWW/EbnV4al4vx7xuywydg/tpkz
         vfVxeGWULKFhn+UPMUHOCfkW6HzNVJy4jRxPUJi0VMx1hC5e3S4rHeNZ09DfS46aKyBq
         sC0ziOyNeJH7puHfyiISjra/RwlwGnf7HMZKH+1RCSPnfXEu8NjALQZosGYPz25BEWZ7
         kb31FqlZaqQd495t3VjGbFXmgYpcPUgEbK7QaEweULL430361YOimHRYyuRGQCaySNMn
         gCng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hL+zuCbR8JcMHfo8scB5eaUZNpLPwPJepcA7ZSa4BEM=;
        fh=EVvO6J7pQTSBSu9GULsgz2XjkUnw92iX7Ot0dtd6bLs=;
        b=jcmCY6ILFRe2ETdcGZr+npIBD2LFwAe3mF476BUrgnOjv2FlEd1nNQV2D0MqydWKz+
         NfSM9gSLP014JiH+hwsl/UJc5as7maLQZH3vHzNCzEKF42eYw4HbSBevcTJ9IKujyelx
         zXxBfbeRPLKhtFxVluYx+5j/vckhKXt/CGKsQ7h7TrFpUeUvvZaEdTJEDXr9R9bkouo3
         RDqga8powW8L2Rv4jN61lN22YEM6DSY1cQ5Ebzw5fmSHKpSh6CLprqECBQ+R7H/OUnYU
         c9F701an4dXkZC8ubGEB87cAMMOCw7vUN2AMnG43uMOZCktSflsmrW69asTTjiWY2FnR
         25kA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781027810; x=1781632610; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hL+zuCbR8JcMHfo8scB5eaUZNpLPwPJepcA7ZSa4BEM=;
        b=rPB24reMVX82mNhw9KjYvBPU70ya33pCb9be9CZ2RMvUdFjrUk+rvpdbOCVXDu91S1
         tOvGV1c1GHoVg2wd/ZhJaV7Nd0kxVEFXMFCP1cs8otruGP3K1d6fwys9VSu8LA5yBnZz
         WqGH2h2EcAwTJ1JxC64iZY7DtLwK6rZtVVBN/KzXEd/P5xBOTRCvhzhIhdF0gzb6VhBr
         Gx7V+qVb34lWszXwHI2RUXmbY4J7CidpAsFY/OW8rbNrYwulKcl99d9Bd75NHg81Rd/0
         SkTs73Yu5wLt5YjHx8+0vv64cfElJQHmX6eUUuGHDgwLvrWJ0sd5zGy51DxF57jov/D1
         zfCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781027810; x=1781632610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hL+zuCbR8JcMHfo8scB5eaUZNpLPwPJepcA7ZSa4BEM=;
        b=Wya7AVyWOhkiIoSC5U9S+lOFo/bLVtrFpxhvu8mbcbpFzF6CB2jJbaXGLb4++tumvh
         V5077zyfz1CIqrek8H4179OvZFr15BYIynyXStQAp1qCh2gyle3wkQxAvGUXFXtjnkMN
         ma7rkfynbUGDG4hHEQXFrZy0vsliJq8Q6asgfqShXnd6/GDFiIDjKq50lkMzeSWt5jew
         SoqfeU99/DvB2xzttzi089CAsfju9xJsTKCij2I9DV5bosxmZqiBSbk6EIBdgZ+QG0kK
         aIQLDumG6/RLedM2eNmGpUZe8vrYEJiRw3teM9C8u2GVAt6xqGHnB+9vSLp9iWGHMlY7
         SAzg==
X-Forwarded-Encrypted: i=1; AFNElJ8dTWCJAvjrARjkhtRKgHKhJk4b+2WaZKrfSWakALnfldkYPN1Gdq6jzhIi1X9U18hR692uvDhk5g==@kvack.org
X-Gm-Message-State: AOJu0Yzi60YNo4GXXcNijMwYM0qoKfNPjrT2qYjsMb7SAyYB/Gwusrge
	Egr2WZdlF18KCVJ/Ck5LidBnURX/vYXvFtrXgrQFMjrr9ZbcpfsO8MNTrBVCMSuzOQxy8yljcsO
	M4R3c2hGi9SR5SXuM8PhoUy5IlWyTK1s=
X-Gm-Gg: Acq92OHlOOOsQ6tkyONCRfJDEJaYGQ7HKev7gJ0w2up66Kh8gIAIvSrLN7N5rUXLt3v
	dt/ssP6juuFxUStT9E30MgixqcuPilhbtxNUZoESEeEj1XtmpGTWNM/5Ohcs9a7SD2xdlr3jqUg
	VnS0Cmde8rNSmMlyu9TDewUzCqJN1yf5Iwz/cukar+85HN1lvH+WL8Nm14QxRRBq1jSoZrM3yCa
	sDVtleMTTSPpAr6D2h39G3aoEPQw1901DDxmxb1QAX2mTq125e8bUemHmAliHiW8HZK0Nd+ZYtM
	WjSLr6m3HAVVTuys53+Rf9DPTLzHcrBegjvUVy/QHxt7V7DyXnUSHS3hqYth
X-Received: by 2002:a05:6000:2993:20b0:45d:3cb0:5ab1 with SMTP id
 ffacd0b85a97d-4603065272cmr26160239f8f.38.1781027809488; Tue, 09 Jun 2026
 10:56:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260609113520.3507783-1-haowenchao22@gmail.com> <20260609113520.3507783-2-haowenchao22@gmail.com>
In-Reply-To: <20260609113520.3507783-2-haowenchao22@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 9 Jun 2026 10:56:38 -0700
X-Gm-Features: AVVi8CflvBQm1AC-a4GkBAfR9kwQkwKA4SVpk1oSo5DSueIXbnTJtqRhF5KOW38
Message-ID: <CAKEwX=NoNXqk6koBYMSjaQaiMfq-dRaBxuFpYdrZyByxs1g0xw@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm/zsmalloc: encode class index in obj value for
 lockless class lookup
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Barry Song <baohua@kernel.org>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: np1ypq78dn3jaqqsbt6bsgdt39jy5ths
X-Rspamd-Queue-Id: 48EEA40006
X-HE-Tag: 1781027811-874478
X-HE-Meta: U2FsdGVkX185MVJ4SiRnsvUmWGwsPLWiI0D45GO8w1St4QkTi44SGYCBuuGE8shWfV9lRSxucSgl4J9Fj6ScGkcMcpvnjw9Cug5BUZkqbfboYRuIlkVxuylpHnWX9T9O+UVsaCJNj9HpETU6uJaCogN2sNkswmsFTEPAubpDD6RC3QTLjYFW116vTBUOfPC4An/MsLoL/VannecVuPiyx+yDz4SdwAw9Gx/7Fcs7DyUkPKzd/ss2C6ss0ulrvDpzXcQeRoRjvdGBncTpjCzkpCg37b1XtAUf3eEjrc/orABveWppmgPRH7N4ZJ9Yj1CMfUxUa9OL0ijfr7nn3HxWwS6rwj25KNmTPpRwUwiGA13kd6rISavkN0ESm1UAYQvKZLBxlnLGp2WA4Ef8ZNe/R3bI5fkH/hEinZWJf5ShS9DhaE0ZI8iev6dmUayTAOq25Fnn1HY8FHyE42FrfH3VeWCLpah8+JIOIwO87l6tU4rzRh14HlBzlzzeSAatyaf7Hf+RCaKw8/yIkhbjUuHEzlWVwOQJtCoFNRKEV5GhD4KLo/1BezL1Jy29Ru4dwim2lzhn2YKfjf69HHezuxdbXWVPMsWfD8CvhOacLpPS+GFPU3REuO4udiFKhb16DrfbWGy1BmgpEXfp0etkGtIjyEVjrdcJTc6o91V79Ix6DJdacNjwpPFZYSlxUXA2paqGdOROuKqx31GGBsxKn1mWPvjlmsQMXfH/mzOpP7Rl0n+deE2PrEjzTsHQqKNtet9msrPLMSAttu2tIkvIy8V6YSjQWuaWgFL9UYwVnq39WMRiDXc3jcPHE8oHok/H9z6zU/T39T6KrbhWkpZJ81Vemp+mY7qsleZKJWN+6XcSqDOZ8137pj4zS1y4Xw70ZYYykO3B4v6kXjfxmYjvwXCi8yhLep+6J4puwD1vfFmnLDTwItMB4TOeuqNWEMH6eY1aehGqUb7C4vYTh6Wkeym
 tNAdVqHN
 wyUK+S8utWW1JBW+BSsPz2iFTjjlWOIhR5MKx9tUSOOwvtIslK0fDQLNNwHVYBidSJxX/EORkjdEobKzoGtzoC+Um4wynS+MRnx/k8Ud2ZzUqq0tW+MtCMxvmDWLN2OxybBLQv1Y9kdO8mptIa47Jcu0QHoJSj7ECBhT6vBbRXnGSJ3L/bU8cJeZUXSc5Gp7/pF2Mocreaj96pUFWbf84HaB6uZlEYjNEE+qsz4zxX4Doj3wjb2AmAjFeIdpyogOmdM1V4SX0vKovZXjd/6sxjdwApQmK4IVgCGvbci4NSxH6EtYnzRyd1LAPHF3UoJCJgsuxcM6cB6tWNeNJBskgCOBPtlteyhLJk7yU5uGDoXaDkkMnmDvo480CyD7CbGuDM+Pk1coT/QhRvj+ZjAXkX424MYL97lJBrE7Runy1lnG7Lrxk8gGgouMNT65f6k0EcAygbIV1dcTUz3EECGtwP3t32GNP2ZOrVeHO5mLFzHE+qo9riXR3DHMPBU5ya8WH07+JG7SaLkgUHc4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 4:35=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.com>=
 wrote:
>
> From: Wenchao Hao <haowenchao@xiaomi.com>
>
> + * ceil(log2(ZS_MAX_PAGES_PER_ZSPAGE)) at preprocessor time, for use
> + * in #if below.  Kconfig restricts ZSMALLOC_CHAIN_SIZE to [4, 16].
> + */
> +#if ZS_MAX_PAGES_PER_ZSPAGE <=3D 4
> +#define ZS_CHAIN_LOG2          2
> +#elif ZS_MAX_PAGES_PER_ZSPAGE <=3D 8
> +#define ZS_CHAIN_LOG2          3
> +#elif ZS_MAX_PAGES_PER_ZSPAGE <=3D 16
> +#define ZS_CHAIN_LOG2          4

Do we not have log2 macro to use here?

> +#else
> +#error "ZSMALLOC_CHAIN_SIZE out of expected range [4,16]"
> +#endif
> +
> +/* PAGE_SHIFT - 5 =3D log2(PAGE_SIZE / 32); 32 =3D ZS_MIN_ALLOC_SIZE flo=
or. */
> +#define ZS_MAX_OBJ_PER_PAGE_LOG2       (PAGE_SHIFT - 5)
> +
> +/*
> + * obj_idx width that keeps ZS_MIN_ALLOC_SIZE at its 32-byte floor.
> + * Below this, ZS_MIN_ALLOC_SIZE is auto-raised by the MAX(32, ...)
> + * formula -- still correct, but objects are coarser.
> + */
> +#define ZS_OBJ_IDX_DENSE_BITS  (ZS_CHAIN_LOG2 + ZS_MAX_OBJ_PER_PAGE_LOG2=
)

ZS_CHAIN_LOG2 is (roughly) number of bits to represent the zpage index
in the zspage, and ZS_MAX_OBJ_PER_PAGE_LOG2 is roughly the number of
bits to represent the object index within the zpage, correct?

> +
> +/*
> + * Encode class_idx only when obj has spare bits; otherwise
> + * ZS_OBJ_CLASS_BITS folds to 0 (32-bit, or 64-bit UML/fallback).
> + */
> +#if BITS_PER_LONG >=3D 64 && \
> +       ZS_OBJ_PFN_SHIFT >=3D (CLASS_BITS + 1) + ZS_OBJ_IDX_DENSE_BITS
> +#define ZS_OBJ_CLASS_BITS      (CLASS_BITS + 1)

Seems good to me, albeit a bit complicated... Maybe it's because of
the naming of these macros?

