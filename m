Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 236E7C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 08:41:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 350416B008C; Wed, 16 Sep 2026 04:41:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F94E6B0093; Wed, 16 Sep 2026 04:41:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E8076B0095; Wed, 16 Sep 2026 04:41:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB92A6B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 04:41:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 733FDA0670
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:41:57 +0000 (UTC)
X-FDA: 85218982674.26.8E6B6DB
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3662340004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:41:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AgKzkSGY;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789548115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0S1eETe3LJ+QwVBor/DGsf/X/yEwY9BbUlBBosf3mxM=;
	b=iiotDkM6DBAAPdSD89yB/g9LzsgmZLj4P07iYUJy4dWig3MbEbw/i6NMDnripH4BSUgfQZ
	jRwMM9Qt9OXdr/82vuAAbqtS748CL+MtGCtPd08zOnq8jFemXuNnP1NOC/pW0nQUaxbl0D
	KjmJzo9ZI4tMfAG++twYrDJAb2FEpCw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789548115;
	b=do7picYT9JXLB7oC7a7+vvbVTIpLtwQQgD9CCgf+9qAo9RQei+oKQllkutRqC3C4FC8cCW
	RwgQa/dXM4OSWa7GKa7j+bpxP8te9gUNcMkm08tm3sf9QJJMvUDX0Kh0tEefXMo+9SNfX7
	W6Ovp8zRyEqHYs8RjbxakMXVpGUxlp8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AgKzkSGY;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f6c7a4aso96412866b.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:41:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789548114; cv=none;
        d=google.com; s=arc-20260327;
        b=ACbDgf3xcKbS5Wgiakiosfa0Cgh8JIZJrSV74x/ExxJ7rXmyI1SnJNoVmk9EbNqh/k
         X2Tvhvlt5lC+p7PhNIgePR3QxedeZ//VE9xVUMKQzE/v74SEfHgAvhwEbcWTAKV4olRi
         1EYZuGcOS41rlrU4U0tBgelRSDusc0t0C308XRZ2Vkkc8PlbcoyYJNmJ4ZKdWwthxVTi
         ABEH0jY6DMXR6iA9oJhmBwMw7WrwaW4YggDfX2el0I78685UbeMAUJJcB0jnGa9S3Sb9
         SPqSqhFetFV872jzLs0SZBOl98KjxkJVQ1MUFXbS7FPYdG+jJpStLhfEZWWF9ZK9zVo9
         +e2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0S1eETe3LJ+QwVBor/DGsf/X/yEwY9BbUlBBosf3mxM=;
        fh=kbuxAFr98HLHyx8FWiSUL1IhPdQxCGLYHm3sLd1h/Lc=;
        b=qIqkQ9CfYn57ALUk78APlttuW4DCi01UbMwk+Euf4c2/OvEj2spScMJ40zEsnugqE7
         t5oXS4dNKLf2InMssqI8GlAnbe1rMxvY7yx/cuqsp3MoVSUSIEUfFLF8UuHxsvA4tuuW
         1p1IdDQwLX0zmL52phSCBpJ/LbwvCdeGEk7saJnL3517Zq6As9MFhWnHU1HV8bO5YPTj
         izgR8odwoELLMJDJPNtZkqZuwNR2095jotrpZsNTs3htlHvfk/vR5mQXPXhoOQqUMrvE
         wm5aeRL+s7JpVdwV+Jv2tr90F35jUEtwmgZkz/T4ZELeRKIs1aFbw1zUxIf9/vFmbon1
         4a0g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789548114; x=1790152914; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0S1eETe3LJ+QwVBor/DGsf/X/yEwY9BbUlBBosf3mxM=;
        b=AgKzkSGYf3gxegB+Xc/N4fitJkEXBmYEci5YZqwLxl7ySlIVvx+LtUMK2s1rfcjjDp
         5PpZ4btjGGGQKo7DUfGAURPMD5luZm1A0JN2suEYcUXBbxHxfvfG4Rqik57UIusHxmBC
         MwCj3YxVJmDwyNnwN3hSyI71eNHf+EDSyAAPupp5rtJdcVK16HSRFUQxNTv+vs57CYN9
         6yIDRyCsGtC1ewdBblcgBpNjp55O6Afe4HQGWfax/QQIDIE3SqM6hhiOXkhZDBo7asKo
         dmnqUG0iOPhWshSMIlF/y5R1/7MvB96Vbk+dZZ2EhSBFCP0aL+L2L8WNCy6e01zp2KdE
         ciWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789548114; x=1790152914;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0S1eETe3LJ+QwVBor/DGsf/X/yEwY9BbUlBBosf3mxM=;
        b=Vp6q/ZIO3kuR3Ii4ykVrQjCWyg+URGiMLZGO9Y3LJkCXjf4O6PvGn1D0cYQye4VmWG
         +qh4KKEYFKmP2mSpqOUKCr3gLpystaP+ba93zcozqkLm0IlO4jggLgT2N5u0TxojnvdL
         QxwzVCD0Co02VPy8BnrcP4d99SMFtPPc8o2gv5Zh0ZP6PxJp4w3Ap2o/mrFgnhrefOL+
         KcX2pAFXzQEO5qeO6bsLRdnKyqP3/qYzVilfDMvX9hbfbz+39/AlfWQ9QR0UTlMTzJql
         yIpRWtLQrEIw3QMwM0CNgqjSvGS1o/fu9WJ86yUO3hSWvIqlaFvqDj8qSPuOWFhuj6EO
         pmAA==
X-Forwarded-Encrypted: i=1; AKwUvBxIlBALBCez8l8YiC1kADt9cZkQxgGCCGpu+2epkkcH8y3h8XahqtKKqzCrXFk22tWy86LvB0h/qg==@kvack.org
X-Gm-Message-State: AFuF++njupp2c6wvo0eCOadczkYLOphLCMQHoKx6b6wyD00DF7/Fl2v5
	ZSwKKd7GQEWLH0QsECSHuVXn3OsCFb1houSxc9sfY7Z7wysldNPK+NB734lEKCN0NZi1jnsR3pA
	kvDHbYGYrEPUVPGXWSQsHvWLxwFt7/TU=
X-Gm-Gg: AYBFou1wK2htCSeGmqHg6E5gCZyyo2PP+BoPaMAmQ74B4NQANsQ7NKnZy+3ShGXUS8i
	Diowk1zTTaopVzIoiDxAtdVzok+7rf8ybhwQi05C1Rm/XUDoE3LKLjY91UYyKvRNV3g7oaiVOAU
	Iq/gI8UJqYs1Qns+Pl5K8kf/PeSAR1ybS/ikhehAjYox+kGAG8arsT5P1S8JY/Jl5TgqO4tJnQe
	tH70CqiqbMyfUdCvqodwOL7xNp7kIzhZLAOojnpKGMdGb0P06IgC33NGjpqx99XICS0CbrTs1dw
	yxFNa8ubuOJk6ljXYrM5WqTfBCkuBFRSIUuXFOWZhcxdF/62DvCAldcGQRktL8cZFWF+9uWVdhR
	sgCkWnEgWWRpMsZrRsj+ANqk=
X-Received: by 2002:a17:907:9621:b0:c29:4415:2ec6 with SMTP id
 a640c23a62f3a-c29e520778fmr118715666b.12.1789548113486; Wed, 16 Sep 2026
 01:41:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260915101556.50467-1-baohua@kernel.org>
In-Reply-To: <20260915101556.50467-1-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 16 Sep 2026 16:41:17 +0800
X-Gm-Features: AcwNN1XUCBpeSCoeBmmtadQkp77vo0wkXI40Lz2QNWuVRwMGQvQZ3f_HHG0Gorc
Message-ID: <CAMgjq7CL7r_P-dw42uoymCd5TgFME39aBkm8u2BxKg1ia46LJw@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: restore accidentally removed seq < max_seq check
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baoquan.he@linux.dev, 
	david@kernel.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	ridong.chen@linux.dev, shakeel.butt@linux.dev, weixugc@google.com, 
	yuanchu@google.com, yuzhao@google.com, 
	Chuanhua Han <hanchuanhua802@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3662340004
X-Stat-Signature: a8bh5n47axmskg175ukuqqxey75xw8ks
X-Rspam-User: 
X-HE-Tag: 1789548115-940676
X-HE-Meta: U2FsdGVkX1/fnbtpr/SqEpvUpcLPgk0yp0vNqV6AV41LFEUjSY3gkyPezoankyZZSnIbFAvwidkw8vehB7PTZEqZy+gdxta+akdDUr31Xb52o1fQEEM5LxM0RU8pr1ZgX/1tRQOjR/5gkIgFLIhNaJg0nhPqXrZGNwFz0eXug6Eqlt0mzdaHFpqqPqndSGQkaz/TN826EoQ22Twd065H29Mif3NY+KWnvg/QyEuSBJKr8g+aTcRY80bSmDXvSGy90EpkXuOAo3Ztu6VLRCNuO5otqUNJJ3E4eTgpJOOc7S0APH+I3yHxxvtzwijaHqayPlI6tM4gz5Nm8IhF7y1wisu31/3F2icZ7bjcWAO1sMxAjCCC8WvudcA2IXxtb9swbT2ATcntB+rfy+MqxXwd3A1JziOnIdVrcM45Qb14rcD+HtxF89aGEabQF89OXdQZnE/XxirshrORFJqz3PdluHpPg4XyNxx+om1a4ClSqUFgyU38Hb371TTofkrFVHJqi1xBHUzTWdOLr4rs7kpy2rfcS4fM2JxV60GkRvESauR/EPDRsFGeKaRs5wcQfhFGKNG3ZX1ro1UDwG0q2Kt5x03tD0vjfeM5RR13b3fLCtP9z6eyYQXLjBo0zll8CeUuyHz5UgbkLLmKTMQutRJr5wJfzb1umk5J2hYzn+nXlVGDQEQ3MpUvd8047swgMsbhCZ1d8D5NflNV0LthKFdQbuYTpp78TWYDLRWniCqO/NIM9nJK48fKlEvkltRyPAdfCuEjp5LiI4jpo6jRdc7Ls/DulBwFLjRP+svgLmCmJEq+V2wPDUQX0j1IgmFBTuJIhnYjFXVL2kW4tewN+YO9fTqtvXcK982gfeordJwhHGKA6TKZk+JAXmoMGPCxgLckuREDVY98D5ZUrDrDm5zAQ3TT33KjFRdn43Zy16gTLRyc0P19sj4KqzQwUcocFx+kMSXu3VrzgewzrLKHDJp
 4HVzomWk
 nj1lSZYbKmcu/aubqYQ5Dh4YoxCNh6Sc0hKh7aDo643R9v8XCS6FYgJ4zevHifEbytNi8YsMth9t6JearT25HCcZtTM+KHe72/9ybTXt1jz5upEDY5jZA2//jEp+6u4zggVc+ByMtZH+ekkXWa/pbepx1bgXOO4DHZ1/14vO9QZF1FCgKqqSRn85weR6GqBAwTZbHE9tUNyYrMbk76FNN3+VVhfuXZ2q1985QPWXP6BJMuz41+bAOfjDh3HJqABdp3tsDenm8s2BjPthEnSxblWUNkmaxAZRuWRi0qSW+zZmE37zWJEQKVs1sGqhn9pdPmdcBTPgGdrXuSDhJPb6LRVqGON67Y7F+eU1R32Lr0nmotWHXSmseQuZes/6t1svxx+cfSfk5mM2Y4hDwpUG1RbYmI9b4kqEiHF8FNC/xJtzJiP6iPbK3h7kSyzji8wI5PDnc++mEO70Ta+mjx+CoicT/Y+OsAqx4CbXs29vGY4oC+63VhmUmgyWDYgYYdDzjcJ3TYI9Maxx6aj8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 6:51=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> Since commit 798c0330c2ca ("mm/mglru: rework aging feedback"),
> the following sanity check was accidentally removed:
>        if (seq < max_seq)
>                return 0;
>
> That means we can perform aging for any value less than or equal to
> max_gen_nr.
>
> This has been inconsistent with
> Documentation/admin-guide/mm/multigen_lru.rst, which states:
>
>  Users can write the following command to ``lru_gen`` to create a new
>  generation ``max_gen_nr+1``:
>
>      ``+ memcg_id node_id max_gen_nr [can_swap [force_scan]]``
>
> The correct semantics are that writing a value smaller than
> max_gen_nr should return 0, since the requested generation already
> exists.
>
> Fixes: 798c0330c2ca ("mm/mglru: rework aging feedback")
> Reported-by: Chuanhua Han <hanchuanhua802@gmail.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 5354eb8d3a07..18c4d3595749 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5827,6 +5827,9 @@ static int run_aging(struct lruvec *lruvec, unsigne=
d long seq,
>  {
>         DEFINE_MAX_SEQ(lruvec);
>
> +       if (seq < max_seq)
> +               return 0;
> +
>         if (seq > max_seq)
>                 return -EINVAL;

Reviewed-by: Kairui Song <kasong@tencent.com>

