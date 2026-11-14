Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D474606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 15:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fd5+MW50
Received: by kanga.kvack.org (Postfix)
	id 99FF76B05B1; Sat, 14 Nov 2026 10:03:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976176B05C8; Sat, 14 Nov 2026 10:03:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865606B05CD; Sat, 14 Nov 2026 10:03:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5974A6B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:03:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD41E140427
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:03:04 +0000 (UTC)
X-FDA: 85434042288.25.7C60511
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id CF417C0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:03:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fd5+MW50;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794668582;
	b=e6/m9M5fLTKf9jkn9FYH4gn0anJXhkKPGt1DwJiFfmzNZOYt1wgfjVXFGAlI6ogx4geaN1
	VAIC2QThhRMEhMS37vEsjonmgS1DYbyODC2is8UEP29wBWc0DdnkD1BMQwrKAdfzLJuFaq
	mvnKITdJT14WReZY0csSQ1GZOJrI768=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794668582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C1lCCVtf/MPYj7pNIU76GaLtqiwfvOf2pe2XTu7js8E=;
	b=RrBNSw8mqy+aiV+nYKPhK+0LWDjdX6ZfkjnnIBycj2DkAGuZxuadZy3Kn3LX3jCXECMcSi
	AVQbE1Pxf5ry35ztt8yr5HvHGeQ3pRZ0QYwykwyZ1lkU8Jrb2hvGBh9tZpg7FUfFAvDcoQ
	OeuKPWwT+izfCAjo5JTzAkJinS0hxSw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fd5+MW50;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8a058315c79so1351409b3a.3
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:03:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794668581; cv=none;
        d=google.com; s=arc-20260327;
        b=T6Wec24uY5ED3y3FTvyKEmnFKleYJaSJ2GVYd5ezz48YOVnzOaX2rTj2kk93yZhoaJ
         Zt6ch/rjckN4ZEa7/hXlM8B83LO7nXfdPC1PmwUb4ZZKGDKxCnIobXKzSvGkgzooT1oj
         5vKeC8TOnaJkVQkZvosM8RC6dRYB7Frvsw56Ck6zATnqkrJqoSbjH4IGY/AwPG+vSZzz
         sr9K4DZGQzl1dUBStRj90iqzcf1uwck35GDJ4rYOz+9NUQ02E9Js2muzhy6DCtxc/4zo
         +m4mAW15RwBZRKivCqe+T+gShowpMt7bnGPmZ76sKxsJm96wNR5EiHeEcMpABebby3qH
         /zPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C1lCCVtf/MPYj7pNIU76GaLtqiwfvOf2pe2XTu7js8E=;
        fh=d1h+RwwFII3S19JooQ+Ubjb3+XaBlb+97REaXpjCq4Q=;
        b=nxZEwHPB5mETos/u+Y+KQQoMVYRpYR162X929rgRDGAVOHSegOpfmRSSwJUiD7IZEm
         sUY9f1hS9Im58VNb6wjAAP5oEBx4qGueF+mHwLmLUPUHBemAU7LVW4mkuC0Z803S1d2B
         OjTKiOHwo/gA3eLPJ0N/1dkwEunYXjhcWWxKpNkfcK0Twn7S8ZG2FcMk3ojj379W9C61
         +BLuiNGuG/bTUjtU/rOjjZJZnjQlWtdqikR7G97KeBobpN0+DabHtUusG5xSByazg4Pc
         pvhRd81LVACiz3Myqcd3oWMI9oX+iTjXm5GtuRI07d/I7ZLm6E2k28Insk8bYmE5Ixce
         aHcg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794668581; x=1795273381; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=C1lCCVtf/MPYj7pNIU76GaLtqiwfvOf2pe2XTu7js8E=;
        b=fd5+MW50LoU6sLvlAqdsFsOeR/IYBymSe6TURxc1DRmKVFpgJ/deVc/UvLpdVEnFoe
         M8d9QvrKnrl8gGDdiLUdgdJ1oiByzltvKd+m4ZW9s1rS00HJme9PYzhqj/sQwIfQ9YG2
         MPqvhftkszrNeU1FX2clyNa1kh/7qfnHVH9WZXSBzw4qrb3TYhn7pGfYZ0FH/Q0eZ05p
         GQnWS0iLvCjoEhhbHIKnAbMcrYnSXMhOntROzz3SKFK4X0oifixZX51WF+E291tZHhiY
         d+ZM9qsE2RfPDsnnRt7K5OA8ZyBn1b8yGar3xz/XJmaqS6CRvqfLrjY59dw0UeK5cBBf
         39Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794668581; x=1795273381;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C1lCCVtf/MPYj7pNIU76GaLtqiwfvOf2pe2XTu7js8E=;
        b=a2p6ExFZ+46ibxAPHn6OpB6c4ra6/yvP1UgKSGyuEcjPR1/o3Tz4dweSbTwuMmCHXA
         CRhBwveoxi80CqwV6T+DlvUkYMtc5wSgv6o2wOabv3UVD4Ccup8aPhPC7Ade7sDV3/Uk
         Vc6M3uHbGeP7GXOfcFAbyIiqjQ0ZNHkM1oyQQZlwVzFAAMwrWY4YSFb4wzQB3GjZSCgV
         Eb5nrtBcS9L3aixNDSWFMnYERivMzPz24LnrXvWWLZhFyqhopBX7hFGuSPLmSWPpHwla
         bX35RyWpHUz/pex9ap9Y3lBAprHTNgB1ide+2UGtReXqX4KzQTHiOoI8xECGlWE5ymsB
         8x2A==
X-Forwarded-Encrypted: i=1; AL+hErEr7RnycLbm6cddMeZ81Lo2pbM5qGnSXEn/dDGFYR8H8UP0rJisxRAHrbB+F5eH68KkQge7FwS5QQ==@kvack.org
X-Gm-Message-State: APuU4Z8fefNKnSB5xW3RsO7Cni9dKVNNULzIgr6DfWrw3L6HF+bV74hn
	+Ac6Z88JxhjAJExzp9RGEsUiq3Z+EvEIaFzIPV0gL3tedgG+3rqp5CkEDATH9lU1WfichTUf+YD
	FhJkIBDY5tQnxNMgMnMnoBNCIlptNONY=
X-Gm-Gg: AYBFou0LJH6FNVwVpJ7sKqz2B05EygbdSifbFgbuTGDPOF7ymAX15w++mVg5UjNQoil
	f+qsbo8mHt+GKUOxbHzKXFdyTVoJme5k0LXeTdNmTBV4VQf+kRZXerSCgExQiWBmkXi7OMXWwI7
	FxQjpJikRBkZkuP4GJMGGtIhtSZNPIhh3q/MRdv663PGY2OvlMhgSt6pOu5/u3pBf9GYDNIdyPQ
	NkzqBjEC4hVgT/VRjNJfwOwKkkbrMv1Ssq4dRQGx7EhdYk9j6mu9Ce3JnUUKVJQD+ZQxHLabYRG
	HL6yQozuIGXv7vE59+ulMEK9JovkAdK9/V9K6oxlvvl1jLKI5+YThUaR3QrnPPOf5pJ/1gYQy17
	a/0ZITnXJlOx2zWtulsim4y9MqTsLT5tTLcL95wEvqKjGd9AIaaIRRqcKtX52R2gddF6A2w==
X-Received: by 2002:a05:6a00:1acf:b0:880:f278:6b0b with SMTP id
 d2e1a72fcca58-8beb1fd2ff7mr4883548b3a.4.1794668581197; Sat, 14 Nov 2026
 07:03:01 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261113185541.70203-1-baohua@kernel.org> <20261113185541.70203-12-baohua@kernel.org>
In-Reply-To: <20261113185541.70203-12-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 14 Nov 2026 23:02:19 +0800
X-Gm-Features: AclHuK9gCJV8MFA9iUFu3CwHsXGh1an-enxfVWTT7zznIrP-Np1lV34GtN_mM4U
Message-ID: <CAMgjq7AXT7u3jMaJ5gU3p+Wnwt5maVAUygMXgv=wLDS6BSyR-Q@mail.gmail.com>
Subject: Re: [PATCH v8 11/16] mm/mglru: Run aging when one type has no
 populatable folios
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, 
	hui.zhu@linux.dev, kunwu.chan@gmail.com, liam@infradead.org, 
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, liuxiang.277@bytedance.com, 
	lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, 
	ridong.chen@linux.dev, rppt@kernel.org, shakeel.butt@linux.dev, 
	surenb@google.com, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, 
	sidchintamaneni@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CF417C0005
X-Rspamd-Server: rspam12
X-Stat-Signature: xzag3ft5t6edzze8n61s1ru3y8qd4jps
X-Rspam-User:
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794668582-74876
X-HE-Meta: U2FsdGVkX19z02AEBFoblECLIJbw97abQFFSJnmjlVeBfmCCKsBUdwX/5laPfDRiRKBKpjbfdiuxLKzm8UfAJEBkEDSfxLH1Mw7+dA8QgqyMaZ/BJa23c7/TanzR7m0fuuSKELtzmLmhiijoc2AmnxX7kKs6mwt0HUTDJKsD9E1JybOMfN1voveNfhS3HxCgKHoNhmp7JK3d7F+9Mj+xL4DBpHTfodRzZGLnlujokxgKDRqN5N5KB9E6c4JmmWfw85KJSCu8U/JCO7rhYwI1ZlWZhicAAqBfWjdRvn7b5azuKtiJMMYKPUOCJF9/k5vv2Qo9QeUZ1rLK49KQaT85TLtybi+AtRKzWb5JTtkqx14FmYUySf6v0D7u3fg4rIfBzVNl7z5uOZLAmf4xM9mMcn53ebUO7TtrSbyjzCHyhw5lk1fRVe0E482NOTbOa6JiCsyLXE9Vuyd2kXlX9uTNXlkEr2CZ02I4EGwNQd8GiVI0OC2ifmhWa+Fq24bj1dUs6sGz3V1KLgdJE3ShSBU/pNDqE49f8h/C+yJQz+h8DqqqxOEr2KTd70bgjnuf8pck0gtrTTTb54D5ZnonnWVXXQMbxfOSwFv4L6EYsi8lk4JWBiM00QPQmUZJ6C18lTfUvCr4MVy3xDq6Q0wTTcXfUubdoyLOVx7MpAxTsqihUSGIx5fau0NjfTnqMQNYf9FQDk6pmqEaEtRC/L0d0AMu9qKmCxKU63vmIxk4LCIWtWpsKOhw0zsD0lE0tbvDA+Aun5x6un8+h8FGxX5xw1fVD0wH7hpF6+fXwrUkwJt8r4B+6vaGvYF8/hpCdzVLuWf73p2Yjhgu/1nXU4vhibw9vAUJBWJdTfC9svXymKGldYhs370xR9gtxE9ws2fEI8FyfiXwYVgUHSQEz69rm+9VH0dSvEZNPEP+ar1V8mwSWqGVgbnA6V4ltCVmtuFKFN1tIDkey2IoxAfRKXr0YKu
 URUhhvyv
 27NGJ5+CZOc4TZA8I5HwMap2jvcDJzIeep2XUceAWMGwirZpQh3GE9n+LXm5pYs7lEaOcJyr2I03vDDw5vPehVcbF7c4a3ww12P2kCLI1F7f/zkZ+FnLcUVHgayT/6zp+/aoGQOazw1QXnJabHWMPPlPOj/5jB6NElVFYw0wuqtAfCU6xZfnJoMKA01mFhtrvKo7xw5RPrpSLRWn+Q3aZ6hdNnaDH4aFWXotcmWszUNIUPhOBpmOx96g18Auwn1PdsnQSxMshF8lj8Legb3GzodNAlUD0tNM7QQU+ggucCb6fXL00uLyX2/xG0KS1CV2kc6pRrfWQmz9+Qx9DUV0Bn6UTi7rr4muTNoe154A2exCQgaat1Oz1pFhBmZ4lj6HogHbVt/2GRgKF45nbCTCEi5MoQf6lMt7ZLq0Oj9UoypEgdUp/ZfOvBHpiCrGO3qWEK2jfEtLZYCzwItypJR2fmpgLoaDrQ2C1OzT+2BQJgT1HRM07T/z1J3lIPHLikw0OamF8GV7q16T5OQdTLMl036wRBnUtHOBV6o4InXUrhyILwbueRQF826gOYRJnP3li12P9WjMHDtuqopSpQLL7tg8BwLUMf8NlwA59rwyVao5XuhjX1rDhLCsrUFsm2BLRzDZ2+zK1CdRMEtoKuUCvozRQUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 2:56=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> We may have scan budget remaining for anon or file but no
> folios in populatable generations to scan. In this case,
> `scan_folios()` may waste time scanning that type while
> the other type still has populatable folios.
>
> Run aging in this case to make more folios populatable.
> This also helps respect the scan budget distribution
> determined by swappiness.
>
> To avoid excessive aging, allow no-populatable aging only once per
> `try_to_shrink_lruvec()` invocation.
>
> With extreme swappiness values such as 1 and 200, reclaim initially
> focuses exclusively on the preferred type. In this case, defer aging
> the lagging type until `sc->priority` reaches `DEF_PRIORITY / 2`.
> This avoids unnecessary aging and has shown better performance in
> testing.
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 49 ++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 38 insertions(+), 11 deletions(-)

Hi Barry

Thanks for the idea on solving the aging problem.

>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 59957fab915b..9071f8889b5c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5109,7 +5109,8 @@ static bool lru_gen_imbalanced(struct lruvec *lruve=
c, struct scan_control *sc,
>  }
>
>  static bool should_run_aging(struct lruvec *lruvec, unsigned long max_se=
q,
> -                            struct scan_control *sc, int swappiness)
> +                            struct scan_control *sc, int swappiness,
> +                            bool no_populatable)
>  {
>         DEFINE_MIN_SEQ(lruvec);
>
> @@ -5121,6 +5122,13 @@ static bool should_run_aging(struct lruvec *lruvec=
, unsigned long max_seq,
>         if (sc->priority =3D=3D DEF_PRIORITY)
>                 return false;
>
> +       /*
> +        * Run aging if scan budget remains but no folios
> +        * in populatable generations are available to scan.
> +        */
> +       if (no_populatable)
> +               return true;

Usually we don't prefer negative naming, maybe something like
`drained` is better? Also can makes the comment easier.

> +
>         /* better to run aging even though eviction is still possible */
>         if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=3D m=
ax_seq)
>                 return true;
> @@ -5208,6 +5216,13 @@ static bool try_to_shrink_lruvec(struct lruvec *lr=
uvec, struct scan_control *sc)
>         bool need_rotate =3D false, should_age =3D false;
>         int swappiness =3D get_swappiness(lruvec, sc);
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> +       /*
> +        * Avoid aging the lagging type under extreme swappiness,
> +        * as reclaim of the unpreferred type is disabled until
> +        * DEF_PRIORITY / 2.
> +        */
> +       bool allow_no_populatable_age =3D (sc->priority <=3D DEF_PRIORITY=
 / 2) ||
> +               (swappiness > MIN_SWAPPINESS + 1 && swappiness < MAX_SWAP=
PINESS);

This part is a bit counterintuitive, as we usually prefer to age when
priority is high, not the opposite. I think what it is really trying
to catch is then the eviction reclaim loop can't reach a higher gen
for eviction, and when priority is high, that limitation is lifted so
it can always reach the right gen for eviction, right? See below....

>
>         /*
>          * Proactive reclaim initiated by userspace for anonymous memory =
only.
> @@ -5225,22 +5240,19 @@ static bool try_to_shrink_lruvec(struct lruvec *l=
ruvec, struct scan_control *sc)
>         lru_gen_prepare_scan(lruvec, sc, memcg, swappiness, nr);
>
>         while (nr[LRU_GEN_ANON] > 0 || nr[LRU_GEN_FILE] > 0) {
> -               DEFINE_MAX_SEQ(lruvec);
> +               unsigned long orig_file, orig_anon;
> +               unsigned long max_seq;
> +               bool no_populatable;
> +               long scanned;
>
>                 if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
>                         need_rotate =3D true;
>                         break;
>                 }
>
> -               if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
> -                       trace_mm_mglru_aging(lruvec, sc, swappiness);
> -                       if (try_to_inc_max_seq(lruvec, max_seq, swappines=
s, false))
> -                               need_rotate =3D true;
> -                       should_age =3D true;
> -               }
> -
> -               if (!evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LR=
U_BATCH))
> -                       break;
> +               orig_anon =3D nr[LRU_GEN_ANON];
> +               orig_file =3D nr[LRU_GEN_FILE];

So maybe what we need here is evict_folio_lists return something like
`drained`, meaning it still have budget, but can't reach the protected
gens.

> +               scanned =3D evict_folio_lists(nr, lruvec, sc, swappiness,=
 MIN_LRU_BATCH);
>
>                 if (should_abort_scan(lruvec, sc))
>                         break;
> @@ -5252,6 +5264,21 @@ static bool try_to_shrink_lruvec(struct lruvec *lr=
uvec, struct scan_control *sc)
>                 if (root_reclaim(sc) && should_age)
>                         break;
>
> +               /* Limit no_populatable aging to once per try_to_shrink_l=
ruvec() */
> +               no_populatable =3D allow_no_populatable_age &&
> +                       ((nr[LRU_GEN_ANON] && nr[LRU_GEN_ANON] =3D=3D ori=
g_anon) ||
> +                       (nr[LRU_GEN_FILE] && nr[LRU_GEN_FILE] =3D=3D orig=
_file));
> +               allow_no_populatable_age &=3D !no_populatable;
> +               max_seq =3D READ_ONCE((lruvec)->lrugen.max_seq);

Maybe we can drop this READ_ONCE here and just let should_run_aging
read it from lruvec?

> +               if (should_run_aging(lruvec, max_seq, sc, swappiness, no_=
populatable)) {

And the `drained` signal, aging policy (allow_no_populatable_age) both
goes into should_run_aging for a cleaner logical divide?

> +                       trace_mm_mglru_aging(lruvec, sc, swappiness);
> +                       if (try_to_inc_max_seq(lruvec, max_seq, swappines=
s, false))
> +                               need_rotate =3D true;
> +                       should_age =3D true;
> +               }
> +               if (!scanned)
> +                       break;
> +
>                 cond_resched();
>         }
>
> --
> 2.39.3 (Apple Git-146)
>

