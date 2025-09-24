Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 857D2CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 16:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6E28E0008; Wed, 24 Sep 2025 12:49:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8EDD8E0001; Wed, 24 Sep 2025 12:49:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCB908E0008; Wed, 24 Sep 2025 12:49:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BAA1A8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:49:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 53BB613BEB3
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:49:36 +0000 (UTC)
X-FDA: 83924729952.08.9B60270
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9686714000C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:49:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ATU1kB7J;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758732574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JvFELxPCxwY74AcuaB/2r4NripPELBrPEQdEr+31uM=;
	b=tp88SXkLVUT2A1Pz/SFzbdAbCbEAr2TdVAQ6g6ayRp0DgEeGozrLEfJS4GeJuYRfP/NLNa
	FRgfDiyeJVQUgsLNAyEkJkLsXiiaPgyj2NzGFYIDmBEy2ZwFcMPvM137KqcjRVuSebgOdZ
	mco+eIiTXrlNY2An9VOkZtSp9PtY07I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ATU1kB7J;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758732574; a=rsa-sha256;
	cv=none;
	b=vRUhZY8td07MIy3qqja43Sq+WEG0J+3wJdYGcY0tUOfoCcmSgwEaFmeLLN9xhwMlC0KEj3
	6jnBb5dpJZepHV+cQj4yIUbTRrd/Roy596RdIeCvtXnJ2oGIVi43XxvTTtrnptmdJrCja8
	oPC+NapKdGkXWKVNTIVkeX+CdK7O6kA=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4bb7209ec97so613021cf.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758732574; x=1759337374; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3JvFELxPCxwY74AcuaB/2r4NripPELBrPEQdEr+31uM=;
        b=ATU1kB7JqNMkoljxYd05S9RUVeI0fgcr++yJJ02tvfl8TacWz8sqwFLsKSNgQWm6Pr
         FfQX6j18rKEoH4+fCEtPREXX9JdJmoqMKovBUr/y6jAgA8MyeCGzpLJzwbI4Ey4TbUf5
         71E1blh8Vv+RnwjOFruwgHrxx3E4EozGGrzhOycKc8ww/FPMrI/d2OelX6iCgzguJhO5
         7ge6CDWq9MbZVJ0bDSPztLP49/WLqo56DHlqkIX1qmziy6JPfsfQOXrqdbi9JFZ8rl09
         n5rP+o3MIomK1jmio5pot4djXIoIu0iIeqkLtANG2WsM7Ox6S4xaz91cS2gHXca96wSS
         QxLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758732574; x=1759337374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3JvFELxPCxwY74AcuaB/2r4NripPELBrPEQdEr+31uM=;
        b=Y+CXrDUnKm9tT0tgDAC2NA4evRBGAyBWVuCcdp1yaIopDUhckbydSLiTc+WwAK0gfR
         RpPDcmVLjo2Mkpm279q7osOVksgTtQWNBLxfBXRxrfV5WUTnM1rAHwKzU9Cei0xix9i0
         fXKNCpWxBzL3D4T6MLn9xC2bLwm27XVyt/TrfXE/+0WVzowxO0Y0qocwifcE2uHQcWxp
         dcpfVvAcXAduIxJVuJMQDpFN7sgVlz7QPTitGbEykWa75b5dOuH3RftgG3Hu0PDmvDJF
         tHrxEKFkST0mpHKwaj++ysYAuVmvURivdNcxG1CtqZaUn9eOPQ97/lg0SURdf0cKRlQ1
         IkCg==
X-Forwarded-Encrypted: i=1; AJvYcCUCTItO786ZqsHa2NsLlClGMpufwmocb9P8liOOEvjwezgwJPUmm9jEFKlKL3TdDDl/3iRfqhtpVA==@kvack.org
X-Gm-Message-State: AOJu0YzOt2L3k2lV83hr8uC9CqfvOW9Lv3XJ7J+igdnECWthc2b5RvRJ
	hWvagzv+RMKc1n5uc/HVXgCxcOWKC4/KO8ZNIY/4LeCLz+e4cn/OmB4RKvabk6Wd+30A5jl8k86
	ZlXMhjcL/+dWKnlxt5Bj6ohqQVjZDZ6+kniAExOsi
X-Gm-Gg: ASbGnctMBATiCncCH97657d6AXgIYggBMwOgQkBkyZ/2/TLBYVH604ytqM5z0nNcrD7
	hWbMqc6/1NhT4241jspGROC/Mo0LLXO/A4a6Cve/8VjYZgReFAjZf2WoOxHRPb8QmTYSFuh3x79
	X8JSUo4ofvJ+oxqi+wpZJrdJwUouzM+HTBX2roI72nz59sUQ6X3u+djjZEPe2j1UY9LJlN/ipIe
	sAtOm6yOinWn3x+8Vs0tAZc4rgRam0hBe9O0bTQOA==
X-Google-Smtp-Source: AGHT+IGMhOROnHAHwCWHqP41TFW4SwH3fT102kMQ13CWu7KInQWNKqQYfl3q0oAPFRaFbRuo/IaOLBDDK9OLZu1oDik=
X-Received: by 2002:ac8:5996:0:b0:4b6:2d44:13c4 with SMTP id
 d75a77b69052e-4da2f12a974mr1030921cf.10.1758732573085; Wed, 24 Sep 2025
 09:49:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz> <20250910-slub-percpu-caches-v8-1-ca3099d8352c@suse.cz>
In-Reply-To: <20250910-slub-percpu-caches-v8-1-ca3099d8352c@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 24 Sep 2025 09:49:22 -0700
X-Gm-Features: AS18NWCIXTS-bjNMv6stOKe8Aj5QIFYPyCiaTgRjLhznKLAkt4P5WJ5syBfmC9U
Message-ID: <CAJuCfpE0AQ+59=PLb0xWK28NVAn_BxG-X=EPxy+dcRn2xWb6=g@mail.gmail.com>
Subject: Re: [PATCH v8 01/23] locking/local_lock: Expose dep_map in local_trylock_t.
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
	maple-tree@lists.infradead.org, Alexei Starovoitov <ast@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9686714000C
X-Stat-Signature: u67z4jakyqszbsks3uex31u3iyzfztek
X-HE-Tag: 1758732574-12000
X-HE-Meta: U2FsdGVkX1/tgDgAnbj/mM8CshxvLWNFA63oBkxdkpqepZbKCfxWJ21Jrs8MGjm3MM74AfZU9KKGEmgz+tF8R5LRxMtlYP07flMtnBUR95hZpMu00Kvp2M3c2H6t0vO87HWNwYnssa2KG0rLOm2WnBMZ0Ps0AxxhxqifyuKdL10wEamT0bF/XMZFuQ90iycowrSIMoezX1tt2+whCG0vOtoW0rkrWtYx30DtrTElFtoB86/tkDq8i3R0bKbBMfwCRbEVhayDG8OJF9DBgs7Eo/Lw/T/ql9aHq6lt9uPJYOr8amoLoKZPqEfKEl03904ewWQ1P0pXpmZpVvLZAuiZt8tM741um6fTfk9m9O12utW+HYG7lgUGCEx9EPGSUNa/DLM5nm8Enq5IXAaIa7ANGdGURxH2v9iC6LPihpHlOZLAlbHpupDkmhkKRLNcKA9Iybk/+DdTn3pNoLexLiQrikrkPjXnCvUqrii5Tz/B3i9ZberohyyFvm3zVkxVVR2UKwN0sZNDx38rVHzC3IkI1VlHi/4jj8zBjc2UWN7ASo+XgB40BYm535Tvv5T4uYyhyMImgTmVNzKyNebK2dVP2A2lGMPaUV6iEha/iqpHn4mDgxuzrJxx62/xmRCGZQ1N5a8ZXEukjd7vwJBCZEvdaMf6p6QkHWhWpCDrQcoNKTbxAxOVhSHQgahjOrm/NSXhTKkn7dUIbY3DOGsF2lG7HK2pUxNzGAEtRHc2IEcbPsI5eYRd6m/Nks0LRXx97v8dFw8rUmbAW59MdMb+9MT6sJTT+M2FPBmqvZXY9jMVbuL2b3mml8G9fRNLngUkpXqc1yOxOruCGlcfhHNY9V+FiiDrA2ycqvqaf0vZLwSJ6Yxt5c3W2A4IRlLM30k6LC7y+jQriEoNExiYesPzWWLLlNzaay/XHxYTNMRy4P1RkuBSgOpxLHh+iwPwwgJtNPGUBO8TTLC5WycZi3jzLRb
 LMyaMuMT
 G3TCfyXHgGZ0Q2QeYmKJ9rpwK9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 1:01=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> From: Alexei Starovoitov <ast@kernel.org>
>
> lockdep_is_held() macro assumes that "struct lockdep_map dep_map;"
> is a top level field of any lock that participates in LOCKDEP.
> Make it so for local_trylock_t.
>
> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/local_lock_internal.h | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/local_lock_internal.h b/include/linux/local_lo=
ck_internal.h
> index d80b5306a2c0ccf95a3405b6b947b5f1f9a3bd38..949de37700dbc10feafc06d0b=
52382cf2e00c694 100644
> --- a/include/linux/local_lock_internal.h
> +++ b/include/linux/local_lock_internal.h
> @@ -17,7 +17,10 @@ typedef struct {
>
>  /* local_trylock() and local_trylock_irqsave() only work with local_tryl=
ock_t */
>  typedef struct {
> -       local_lock_t    llock;
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +       struct lockdep_map      dep_map;
> +       struct task_struct      *owner;
> +#endif
>         u8              acquired;
>  } local_trylock_t;
>
> @@ -31,7 +34,7 @@ typedef struct {
>         .owner =3D NULL,
>
>  # define LOCAL_TRYLOCK_DEBUG_INIT(lockname)            \
> -       .llock =3D { LOCAL_LOCK_DEBUG_INIT((lockname).llock) },
> +       LOCAL_LOCK_DEBUG_INIT(lockname)
>
>  static inline void local_lock_acquire(local_lock_t *l)
>  {
> @@ -81,7 +84,7 @@ do {                                                   =
       \
>         local_lock_debug_init(lock);                            \
>  } while (0)
>
> -#define __local_trylock_init(lock) __local_lock_init(lock.llock)
> +#define __local_trylock_init(lock) __local_lock_init((local_lock_t *)loc=
k)
>
>  #define __spinlock_nested_bh_init(lock)                                \
>  do {                                                           \
>
> --
> 2.51.0
>

