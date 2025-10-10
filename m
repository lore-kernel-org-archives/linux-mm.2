Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E687CAC5BB
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 03:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D67798E0009; Thu,  9 Oct 2025 23:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3DC28E0002; Thu,  9 Oct 2025 23:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C534E8E0009; Thu,  9 Oct 2025 23:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4E0F8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 23:44:55 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C5681DB0CE
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 03:44:55 +0000 (UTC)
X-FDA: 83980813350.10.EF6044B
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 55869C0007
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 03:44:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lQwoEZGK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760067893; a=rsa-sha256;
	cv=none;
	b=ia8MJ+WiXYcvwpY/0VDgvMftLKGAqyfUxuiiXCU9QhEEwWe0kHDnN0P6npVAi/whOLyJDU
	61tqyC/KKHXc0Uf0DHODOVt1c46xojYuhfqJNxrKcgCsaM+qBAavUgy8xjFtqKM7f3lOvX
	RIQRdVk+Wvv+FMYImim5BZYUI1ihmzk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lQwoEZGK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.51 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760067893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lrCDic28MJQLcI4hxPoUYdgbfh8YLLZbssre5IwVfkk=;
	b=kCEcPEmYI2553otVRxQi1OibUM/SxJ3ARLtjWPEDLnrhBqTGTFBdN7IMleWkKgsubTuLXJ
	6VrqUN0CpJwVvLbBW9woUrD5zoio4V6KOgBLIXi661Hxyi74uQlgvAhF5RnjcNH2JkJdH+
	05GprllUOi2w4Alh45UWxGKmSkqkmAU=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-87a092251eeso27564086d6.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 20:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760067892; x=1760672692; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrCDic28MJQLcI4hxPoUYdgbfh8YLLZbssre5IwVfkk=;
        b=lQwoEZGKN24aCpnA8RN0/wbdsDnCtzlyf9drfuQufh9coYS1zMsj6B92fvClP2g4ct
         cf0Revty7K05JqzulcD+pWmK6A1EOgnLl1+3yHgrZZ/lFQMugqicTTgMEg6N1v5X6U69
         gYY4lg7AXrLzc4wk1BIwhuX1cZ+Ice6jY9LTRTucxEPUco8/kLzOIAbp2Ca9RwJhFEcr
         pYfsxjIZRnCdRXoT1ip/sISyL0OG6WVobsNsKKm3xL8ba7nOW5y4IvNJAEantZrBTb5F
         m3tBh50kQA4G1MyRcfEaJvJVq1Yq0tSHEoQfgcArogaxtVEtmfGGf0nQ3T+mEAlVrOeZ
         t6vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760067892; x=1760672692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lrCDic28MJQLcI4hxPoUYdgbfh8YLLZbssre5IwVfkk=;
        b=Q4wpKOlQZx9FaPBn8TH3oofFQD9cIqzU+xzwRwFqKbyaGjE/VwjAymJ4aPH7iZMu/Z
         IT9JZZzZZ2k1KeQd8tW1JcIG5RaCRZM4JOXXZuen/jRdiNjjNBnO9is9PkmlTzdk4FHn
         Sdqw6xDy7H2bmnZ12Ypncj9StPWJjh8L+LYTTDe5aucJSxJLaHp+1jKlnnaMmq4Y0I8i
         /AAtZaKelUFiBLBt93hhTeFhO/lLeBYZxu7R6AC8XFVlq2w7/Cj53P+/EmEaZ92z0NTz
         ZfA1eFKWS3qq8bEL3MwWvoQY5qqvAU080KKrljrhUT70Ut6541/yiYt3qyvAmBMhc3Hc
         r05Q==
X-Forwarded-Encrypted: i=1; AJvYcCVFlCH7XecpKlnoXAjuE1T5Qkx7tjblj9WC1rsCKcZtZR3YNgkSDIYch9m0WlFckCuDDANhDV3FeQ==@kvack.org
X-Gm-Message-State: AOJu0YyCVE/yh2Lw2gfNK+T0EtMnXJ1k53yGYDVFmh8SgRZcScRm64v+
	o84HYVw0Z8ytNBJlKNsncojKGbq5ExQOVivPiUSDqyYbPATchUcK2pFx2Q6vPnE0WDF0Y9ro87L
	cJOAP8BPqd971eu5SvYeJWZ5AkgBaKUY=
X-Gm-Gg: ASbGncuQoHE2Mgtcr+Xa8x6FP43auAqvrlBc0ce2rumtcj5pDFSUl8X6aXCYh+7nGcq
	uQhis8Qlz8ysvne/UB9YoA2w7D3h/3v1dIgsofYJJePDdQGTfLBwPGZxCyFHKxc6X/i1nwY+UHQ
	hC0/F6i8aJnWBOysyapt1/ayDpLqfWaeZ2/aM1oe5wZj3yxVQOQlXvgF/QRua54zbniKSgdY0kX
	2Dl9Vvq2e+WKRQKdbqH6QEti9Nr8I6SdgFtlkfaLsEyINIvccB0WMmsFq1u
X-Google-Smtp-Source: AGHT+IFt9dPrNwZtvTc/2n0761h7JBS7U/UywR1UhWegFqqLZQNzDDQzTRrENgTAYeGsX+9n/owRJEuybLV7L5kg/Ak=
X-Received: by 2002:a0c:fbcf:0:b0:87a:6b6:d107 with SMTP id
 6a1803df08f44-87a06b6d175mr116737256d6.17.1760067892162; Thu, 09 Oct 2025
 20:44:52 -0700 (PDT)
MIME-Version: 1.0
References: <20251008032657.72406-1-lance.yang@linux.dev>
In-Reply-To: <20251008032657.72406-1-lance.yang@linux.dev>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 10 Oct 2025 11:44:40 +0800
X-Gm-Features: AS18NWBU91fuBdxwWqHXshtBB35dHf5N-qCYNjdXGhtMxOLtFEEsBf9YCOoHrLY
Message-ID: <CAGsJ_4zp1HSQbSjrt8ftmzdGXxU-ENJX1VfC6Ah+QvhXgzQfVg@mail.gmail.com>
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, baolin.wang@linux.alibaba.com, dev.jain@arm.com, 
	hughd@google.com, ioworker0@gmail.com, kirill@shutemov.name, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mpenttil@redhat.com, 
	npache@redhat.com, ryan.roberts@arm.com, ziy@nvidia.com, 
	richard.weiyang@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: sfcsany6p9pmbf11u5rds4p9z1sfmi8h
X-Rspamd-Queue-Id: 55869C0007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760067893-509957
X-HE-Meta: U2FsdGVkX19BKNyzAdP6jUynKhO7Rt6XgIxHTCqo29RWSknaMfsjWIku63+PhussKPIErayjhZuWd8vMS3DBRzlAEAQse3BO5SiFD5u49M7adFkOwPCTLJWC5aPZS64Qrte6aekYSLxRI3bQMmxwP3WXxdA13gzUSyqvGQn9BzMNiN3R/CCOZN06c5dkh2v10tvSV8NcsKtrdljgqLygVsRrsY8gIYS48UgcJZyMdHUZe2V79VrQUXpMooZ2HA6mf5OJNxgTUIdHQkgyx1KQejMoClSOg8U6AtYd4qlp5+SH53fCKyq4ItTGQRCKiixX2t+YeWoGkVf8tKDDbxypju0wAJPiUrf/jkl1lQjtw9HwOuTwBPZi/AowXiQixDsRUBY1sj2xKdHHJ6rcKOxIHSCN0OD4+cYjRI+y6nnFToO8I+RVDOhxCEnLRXErXMg1mDYAu4Q/gfdheBYWILPEGJVzG5oVG6G8IYCZZkirAPQLk285Nwm1bprDqrL+MEIVlwSZAT6iKaDhXvj6Pxu4FFz6iNNTv4m93h5JA1tzE6ELUSVPYJFx/v4t7rNWqZMZ2iklf5RI1LW2Gf9Vp9JzUbT504cnHrgwlq4YKz9XHY4JkXO+7OmErp99ehzxPZUZxmoZNj+k8rWAptsx10nlucjU231tX9Gt3O6tH5CnlX1RAo5nMW5O4uM89valHkGZ2GqTjc9O8lSgOxsGeAOWhQLbwroS1H3hLwzAYz/70HphXuo4amezsN17ahBmwJT3Y3nVtPHcerv95DEWhumNQf8C18lxCQD0gHMK9Xd5KPabC5kfKv/KV40A2oeFZrJgZW78bDo9jiy3/Xz8NAaYfGJ37VGLfo9rE7lHrqNywf7XaPAvUW5/w1y0OYqRnl3GNBYlSfW4cpLUOBooYki739n/iDVeVZ2A7oCo4LDZsI+EGLWhZ9k8Ybz/jZVe+z3EMVuzzqh7ucJqE0VIl12
 R7QZKeyj
 bqWKDtgYBLqJnm44H8SgHE0Tb25MVIlKy256T65N1C6SkZ3lvnUyPb2JVUnBBXf72QkrDkUIi0a7tkgBf6+1i+iha0awNZXux0dO3fN3Nn7lJh+MlmgaaG1/+2lEJxYlz2tTf/+ebNZEHBuWvTUfJsnjjI4jg511mOXiTFfa2G7MQB6WOEj8J6hMhXxYGasLZEKvHScul28JqP1Z8/TOeVw6YuSX+4B3Q4LJCdCiRU6PZxluFAzyxjzf2IhB71a0W0wGK2QxIy157aik5gwkUF1o+sUNy7Dlc2yxSwGzH/i4iJ6Vu8FBlSZghqWNLEODmW8oeN1mtRtZMhOZIaCQHFOB/7xYcU+bVVjF8L5YZkgqplfeIhhqgSD4vsYPeFieuuWjuQyFkEyTXc7jr+Kmxsha3VIl+g2lS09pysb9Vuc0UP0PgI0Csd/FemmmZQS3UppFrOuyVmfuV9iPH/BjOZHsvs9einRS5eE0kW1t3gk/fwx7q3LhRJdBugdPN/4im7Znw0BDgM1TUkQp6TEIhV/sPqrBKEj21/lxt37NosZ1q7ZEvC18F/UwcvixI0LimYexR85IwCvm4BWo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 3:56=E2=80=AFAM Lance Yang <lance.yang@linux.dev> wr=
ote:
>
> From: Lance Yang <lance.yang@linux.dev>
>
> Currently, special non-swap entries (like PTE markers) are not caught
> early in hpage_collapse_scan_pmd(), leading to failures deep in the
> swap-in logic.
>
> A function that is called __collapse_huge_page_swapin() and documented
> to "Bring missing pages in from swap" will handle other types as well.
>
> As analyzed by David[1], we could have ended up with the following
> entry types right before do_swap_page():
>
>   (1) Migration entries. We would have waited.
>       -> Maybe worth it to wait, maybe not. We suspect we don't stumble
>          into that frequently such that we don't care. We could always
>          unlock this separately later.
>

On phones, we=E2=80=99ve actually observed user-visible stutters when the
migration process gets preempted and a foreground app is waiting for
do_swap_page() to complete. Anyway, that=E2=80=99s a separate issue we migh=
t
address later.

>   (2) Device-exclusive entries. We would have converted to non-exclusive.
>       -> See make_device_exclusive(), we cannot tolerate PMD entries and
>          have to split them through FOLL_SPLIT_PMD. As popped up during
>          a recent discussion, collapsing here is actually
>          counter-productive, because the next conversion will PTE-map
>          it again.
>       -> Ok to not collapse.
>
>   (3) Device-private entries. We would have migrated to RAM.
>       -> Device-private still does not support THPs, so collapsing right
>          now just means that the next device access would split the
>          folio again.
>       -> Ok to not collapse.
>
>   (4) HWPoison entries
>       -> Cannot collapse
>
>   (5) Markers
>       -> Cannot collapse
>
> First, this patch adds an early check for these non-swap entries. If
> any one is found, the scan is aborted immediately with the
> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
> work. While at it, convert pte_swp_uffd_wp_any() to pte_swp_uffd_wp()
> since we are in the swap pte branch.
>
> Second, as Wei pointed out[3], we may have a chance to get a non-swap
> entry, since we will drop and re-acquire the mmap lock before
> __collapse_huge_page_swapin(). To handle this, we also add a
> non_swap_entry() check there.
>
> Note that we can unlock later what we really need, and not account it
> towards max_swap_ptes.
>
> [1] https://lore.kernel.org/linux-mm/09eaca7b-9988-41c7-8d6e-4802055b3f1e=
@redhat.com
> [2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd=
@lucifer.local
> [3] https://lore.kernel.org/linux-mm/20251005010511.ysek2nqojebqngf3@mast=
er
>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

Thanks
Barry

