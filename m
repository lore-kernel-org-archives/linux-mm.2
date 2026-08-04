Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1E56C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 20:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0A8F6B00C7; Tue,  4 Aug 2026 16:59:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBBBD6B00C9; Tue,  4 Aug 2026 16:59:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA9EC6B00CB; Tue,  4 Aug 2026 16:59:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C1B86B00C7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 16:59:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 74A40C02D7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:58:59 +0000 (UTC)
X-FDA: 85064801598.03.FB6B3E0
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id 726DBC000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 20:58:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mSxu0lUJ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785877137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VCDLaCnnX9vaaUQUw3u7HIXTX0Qk5FsyUI95fgf12Z0=;
	b=7nRK/XlHMJs+7nPrwesTg9gZW75O3yEK8EwtubnCuYKQgso9Okqq2CC6KORR4OkfjKqw+V
	CAyyMFSRHLS12YTMQFveXZNCBHc+PeFPJ2L0r2WjzsvAq3SKdHQdDHSikgi4SPF50N7PIP
	M16RUVByR6MaKjE4ElTRXxh7Exey1A8=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mSxu0lUJ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785877137;
	b=a6wDGYANquJ7jxC4qUkA5PGY533P0jsIjnK4mg0Jcky8XK6yqdF+t5Z7UlKwwe4s3QcXew
	Wv11Z39wJP7bjlS8L00rk/uKS7Vo7jS9c4BruzJmD276/YnBTEdc67X6VSM/YsLSEJrugm
	kWhcmSHXYQmLwXtO/S/uTwpMURP35DA=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c10e86e52so26581cf.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 13:58:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785877136; cv=none;
        d=google.com; s=arc-20260327;
        b=JI9fkPRKEFwHydxna4RQ6Nq6ivIK4tH/ZkVE9Xp/V/0DjHvtP+OHo6ZucZv75DhlnO
         Ji7KtQL+QKJfeFVvwWP9ONBDZUpmay77JL0x4VaXurmTIZ3BX6sCMCkEAZn//51Y1/A5
         Vx0fA9QbLMlvM2bmnSoRqEhkKihseXOgGqKv9KykHQJYH7ljNWpKDTKE2EqpTHfTLBRG
         HvSH7X2LB1MI+CKXsPjYjt4snTy/HjaddelUHZhr7Ohe/5W5RQEQsowB17kmyWjwzGxv
         8jwvi2PI7dRqbyj8kkcuXThJLcaLbc/AnjTZUSD93Z82iSQ+T81F38g8F3a0zYaTmH8o
         4GyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VCDLaCnnX9vaaUQUw3u7HIXTX0Qk5FsyUI95fgf12Z0=;
        fh=MZyrLcGt6JSZxEx/7DXnEOQ+bqgMzRtIzxfEACFOkJ8=;
        b=Un3Vcg+DqkDSndq2DjxHYmplolREvMqaJ88/Za1HIvqrduCjFWCFUcNyxCgn36aR8U
         lz9FH7lI2BoAIJcAUGgva4K/jS1hX+bSGP3EvDdDDhGrdzHcnrZ+ms+PgExlfmTgDDrl
         WuIkCOk3WijLjOVyXAgUcCmJh1yFKhGBDg6MHRmtcuSZ6vRX3+P2n6nbxHsntYPmlCFA
         zMOYzxrCHUN60OQMcvc7j1pSVSPXb/jSuArztRxoMZs+WO6puYv39aPP2az6SYHGX+Av
         m016lqJ9Xpas46AfVvIZDbWxRj7WWcb0yC6W9mdBa5A7LisNrXqYu3R8C8af+cYlXEG7
         x3FQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785877136; x=1786481936; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VCDLaCnnX9vaaUQUw3u7HIXTX0Qk5FsyUI95fgf12Z0=;
        b=mSxu0lUJR3Wex0L2UW78Bf7p7B7ZkIOwyUgoz/CCueoKaX5+XmDjGkdHZKH6yE2a4S
         lz99XU4DsW0O9EaDO5GUtqmCLKoEXX3/K7YEG/927TuIxrWmiJeC/Bh+7n08f1t/94Si
         JapaQKiyk+5cri4fHDZimqO52LTFZfvIKmGjGgsfn5Gx63mo5L/zYSvieaJ4leLLTROH
         JbFCLzJIO9OKs4A/+AWULXKZLljzJu1UzIQE67R53fMof/mWzPqzYQOAIbZnDDX4fcoX
         CVbKtfpE7eSJbDppgVMtmPjM0m2E50KW2PzcEfD4vvNuFJWxQFULwfUYZnKHjzTDDzO3
         HmcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785877136; x=1786481936;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VCDLaCnnX9vaaUQUw3u7HIXTX0Qk5FsyUI95fgf12Z0=;
        b=hut6SY5hSE5p1yGbAfxXtxorDwC4kM55JvznpaFMghQE3PCrXG01R3LNy+pxuuFl2m
         7I6EHbxZ6SotHVWTXUh/WDJ9H6RXjcVWFCkQabUYylsEZn9RwTG2cPJGGKiXaWtcVLPh
         3tgR9LeQuKdV6En6Z8me5KGsMasMVg2Ls7wHxhZrHYEU5qWYoDeJNamXq3/cOIiTItG2
         qfoBwNLfV5ZaKYkgi+XMAA8nSh4x8tOqpOOgaBG6zDOYwV55pKW1Tm9W641HabeVlU4Y
         C5i0w4+bh9DztY4+Z+adcKcGQCUFpPS0idRjQGyZ2osdbH7UDV2GuKZMFtJW4vuFbYKn
         aZDQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpp4AQ7W8sg9xftdvaL9uhYuguNSYVBl9UWyDIZu/vGir4nw5wnfudEnWB9oVpog+X4TMLW1a/FIg==@kvack.org
X-Gm-Message-State: AOJu0Yyxg8AtNTMDIoVv/hBmcoP3Rgxpi9RszmZT8XiZ1LUZtmiJuPTi
	zdhz5fpMlLS2KJW+96hLDG66PUN7yvxYIbTvmXhgWzVyeqknxW2yK5VHu1gpwDApDg3WxsDEyG9
	eHk97HVOSD1VZ2n1c2ekUSnp5dGsLPoINtgfEDPvV
X-Gm-Gg: AR+sD12Smiy4LE201O9htTvj2/wSVREycs/OrwXbvGNXoj29skmEBylQriDmI16GBfs
	qaqOUz2MPEL03r0PHondY5pzgVSkeYPYt/CtKjl0UouDtErN2SiQFaKIguAaTxu09bK5DvA3baf
	NMd/EFAK4nBJg7BqVW5JQnYJViuQHEMJp0prBN/A0jE4FjKJBW2uQklIkkZVXLFGcNLiV95cm5B
	EXjfkKgfqOiDFfrpODeX8+4RIacvUMvfc/PKZUDkaoOUPU08f9+IJ0X1K6HHyFY1CNoIU1eBIKl
	xwm/o97r7ovE3jh2N1Ydu8pH+ZtRva4srwucm1r70AcxxwdXom2jlLAisKNy56dFvBjqislyaSg
	=
X-Received: by 2002:a05:622a:1492:b0:527:f08f:56a2 with SMTP id
 d75a77b69052e-52ce6ab3f96mr3904401cf.8.1785877135648; Tue, 04 Aug 2026
 13:58:55 -0700 (PDT)
MIME-Version: 1.0
References: <e4e49ec4a5960292aeeb9e196526c18dc95228a2.1785867739.git.abhishekbapat@google.com>
In-Reply-To: <e4e49ec4a5960292aeeb9e196526c18dc95228a2.1785867739.git.abhishekbapat@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 4 Aug 2026 13:58:44 -0700
X-Gm-Features: AUfX_mwz-EJKrwP1sftaB-MCja1ZSBxW5FrEQIo_h0y9MKEilpUwpv9zxavWOc4
Message-ID: <CAJuCfpEJmxY6HWKQ-rk44Px3e4gRQegnzjE3fhN57W7ie8CK1A@mail.gmail.com>
Subject: Re: [PATCH] alloc_tag: add ioctl to /proc/allocinfo -fix
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Ge <hao.ge@linux.dev>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 726DBC000C
X-Stat-Signature: hqn881ujwjek4f4oin4onf8y55dd5jiq
X-HE-Tag: 1785877137-258319
X-HE-Meta: U2FsdGVkX1/051jm9tpvQ3ODHQwTvvCjm9fgpbpot58Whvm3lmTyGshQlYbDKrfd6cq11U++0OJx6QPtvfWMa+TFF9hY19BgNHJtfwTCMzl/EDohy/3dOloUlJ9RXOVSR5V4zQYPekQd8ff01NPmNREe/qSyze7sKwwanVrjUOX64OI3ZS0iGrMQHhMluQj/CYETKg2iSW7Y4Nk0ckhp9RAFamacvkEHjoFY42kYz1xSW3OTDIybP/JVWQcKHETQ3beVBy9aDZv1MAp612DXRLzYxyw5E0khbTDXDpRr+ig4JIUo3LisZuMCjWuaMtYxNMNpMTC8rVRwj6dCdSiuppY1nYapznlaD1euD4t15zVXujyuGhGw9PEqJUKLhjdDF6UPqpQMPzD32ayHomOMG5Dpny5mBZQ7kIStZYvP4xQs84bAxg3aEgYRRYKeDqYk2bSYwvjQZPXI/ef7FesDUGp8EhvzROMkS5SJMqP1Q7gmgGXHjJ2NigpDAKjqHlww86tMpzvZEyNvANMia6nsi/tAF6CZ5mIt9yfFHC7N2kklJXoyzzJWofYihl1kju5SWHxgrXltjNA/cXu2zcud/i2Ey8iDyk+GHrOicrLu7KNkuKzN/HhPEKbtM+7fmlLdiWOlDtSJeCmzFjoUk63b3yL6JRlE3equufDuBNeaDOEr+V1M2pH3ok5sB3Wpql9ur3qQHjrVRhBZr+LnPNGQtoyB+3+iOHEWjbhH/Bm1qiGNZoivDVRYJ0e4I0VLLczf89N8yKWD98DswcaxJuic0mnd53gl+9oe8kYUpA2B1MWrN4B+lyqqaGOGdH3aXqDiLkjtd0cQ7k+sb7RfadxxTQOxoIodDMGwZ57Iq+RD1YA/wh3d8AJ7d2CA/b0ySmxlrIIqP4R7m1FPJniLjLWxXo3Z0CnHS4iKzb+DjbBxzNZ/Wyem/XS8gE4+cea2uk1hYwRGcjmYHJsXuwUxp2d
 OoSSPF6c
 INDfZ4eVkYnXvUhQzmYfegcXbtd0LqrfW03lwOXwk1JoRC563H7eK2iPV6y360OvdhutGGEJa1UONjHV24JFuTkEOk8byzckc8JyPdd1owagHY2R1nbPQ6oF9AOkkUJ45/Gtr92j2tpzHtKLBpfo2z5Krhs3/77Bi8q0npR1J+WuqqE+0uR6jubecGvC425V+63ULhjfaof9HzR4qpvOiNkgRudW+pVkQPVKSv4og/rCWnIlpeBW38bYEgoqnoTaXsmZa8LAUVvn1PMWbBj7A5PSVlQBf5Za9P/zZuO3ZK1VCCbXPe6DREbT1qSZHvYWL66Kb18GFyIBBpEVtVBSFDzh9ZLv2mR3FhgHjgG/UvgTCZyQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 11:24=E2=80=AFAM Abhishek Bapat <abhishekbapat@googl=
e.com> wrote:
>
> Move the `inaccurate` filtering criteria from `struct allocinfo_tag` to
> `struct allocinfo_filter`. Also fix a typo in the selftest added to
> validate the introduced feature.
>
> This is a fixup patch to resolve a pending comment left by sashiko on
> the patch series starting with Commit bc3da70ba4d9 ("alloc_tag: add ioctl
> to /proc/allocinfo").
>
> Note, sashiko also left a valid comment on the selftest about the sscanf
> in the test skipping loaded modules, however, it was a deliberate design
> choice. The modules were kept out of the test baseline on purpose as
> dunamic module loading/unloading can trigger content_id mismatches
> (which can cause flakiness). Since the IOCTL logic itself function
> regardless of whether the codetag is in vmlinux or a loadable module,
> stocking to stable built-in targets keeps the tests robust.
>
> Fixes: b011dfc9f8d6 ("alloc_tag: add accuracy based filtering to ioctl")
> Fixes: 359316c50445 ("kselftest: alloc_tag: add kselftest for ioctl inter=
face")
> Closes: https://sashiko.dev/#/patchset/cover.1783532853.git.abhishekbapat=
@google.com
> Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/uapi/linux/alloc_tag.h                           | 4 ++--
>  mm/alloc_tag.c                                           | 2 +-
>  tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_ta=
g.h
> index 270f693b1822..e3ad94444864 100644
> --- a/include/uapi/linux/alloc_tag.h
> +++ b/include/uapi/linux/alloc_tag.h
> @@ -31,8 +31,6 @@ struct allocinfo_tag {
>         char function[ALLOCINFO_STR_SIZE];
>         char filename[ALLOCINFO_STR_SIZE];
>         __u64 lineno;
> -       /* filter criteria only; see allocinfo_counter.accurate for actua=
l accuracy */
> -       __u64 inaccurate;
>  };
>
>  /* The alignment ensures 32-bit compatible interfaces are not broken */
> @@ -74,6 +72,8 @@ struct allocinfo_filter {
>         struct allocinfo_tag fields;
>         __u64 min_size;
>         __u64 max_size;
> +       /* filter criteria only; see allocinfo_counter.accurate for actua=
l accuracy */
> +       __u64 inaccurate;
>  };
>
>  struct allocinfo_get_at {
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 52aece27b00e..84c5c3783ca4 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -291,7 +291,7 @@ static bool matches_filter(struct codetag *ct, struct=
 allocinfo_filter *filter,
>
>         if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
>                 inaccurate =3D !!(ct->flags & CODETAG_FLAG_INACCURATE);
> -               if (inaccurate !=3D !!(filter->fields.inaccurate))
> +               if (inaccurate !=3D !!(filter->inaccurate))
>                         return false;
>         }
>
> diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/t=
ools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> index 7d94abb785a1..74fd64b2370c 100644
> --- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> +++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
> @@ -1,7 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0-only
>
>  /* kselftest for allocinfo ioctl
> - * allocinfo ioctl retrives allocinfo data through ioctl
> + * allocinfo ioctl retrieves allocinfo data through ioctl
>   * Copyright (C) 2026 Google, Inc.
>   */
>
>
> base-commit: 486855239e38a91d3eae26618ccb7845c1764625
> --
> 2.55.0.508.g3f0d502094-goog
>

