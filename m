Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7F70CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 21:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0839B8E0018; Wed, 24 Sep 2025 17:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 033FA8E000A; Wed, 24 Sep 2025 17:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65408E0018; Wed, 24 Sep 2025 17:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1B098E000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:56:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7BC0C118793
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:56:03 +0000 (UTC)
X-FDA: 83925502206.01.14C0940
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7D525C0002
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:56:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NAylZhzv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758750961; a=rsa-sha256;
	cv=none;
	b=kjjIAqRcNCdIW+XrtsvXl8zk3nQ4Js5Z8h/4Mkq+GKO1B1hiw9EV5tqgTEeYbhubLh6wlc
	wkMtwf0jSY7aiaLHiEZcuhYs9lj5NE51GXEsZ2NBgVBhLjodcruH1wCjofeRqe3IwDSxeL
	TA8USWB26vv6fGjaoInhf/ey/E3BW+0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NAylZhzv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758750961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HWAbpyunu39MiySnIwIuaZzvE3EOCpESj8Gz0CnuHyU=;
	b=2ZhiWIFRUs6lMOalUYwNgQpLf3Z7lvDBP5Qpvfs6ehFVIONbiJ9kUiEieadPchUZbCtE+u
	ahI7UaICxWAYt0+uP69Y9hNybSbI1mRXaZyz9DLzP9/yND01l4y3xVMUpPi+95GzeqyhFt
	+iqxs3bpnQIbboT2IXYRrWo2lILMhaE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6944344D72
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40224C116B1
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758750960;
	bh=0IApxeWFDP3AXr4lFm31bOZo/GEJt0YPuVBszXf2fe8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NAylZhzvpE8YibeqOhfRyvoWOsiHO2udVr4+xohY8enhGyRWIYBmKZL2pitllzF6e
	 LCdQT1FYeCOzkZItCoyPFNbGLNavX43crU81iDv62jAvFGlJSPpOCL7CjlwWNbWpdO
	 U2FavtnWmsi4wMY5L3xlgjGyIa1whmwlt9Je4JQMIDaEaWqq3Xp9U3lL0GZljdvw3X
	 5tlSkxHk1xhWyTQq+Bmb0dk0Nyw56BFi11X85/V117izrsxfGLUdV7vGQVb9AFX+fH
	 LrxaAShYsVdTq2Uz2LiQmE8YpQTUp4jETztLBmyR5IXcycTbuqczT4vpXjYHh7Q4dt
	 BFbTG3INjTL8g==
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-4248b431b41so314925ab.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:56:00 -0700 (PDT)
X-Gm-Message-State: AOJu0YyXfS9i9eBKEwgY9f/ss07a4M7l/kZUsr3UniVQz7NzEFkBYqZL
	LTcH+QrO4RrFr9q5uJh+ABnyLW3G4P4TMa/CrUCmRpFFT7iHAxnwQAs6H2NCu8zmdG232i4QJf6
	X1cOVqPqOULB74adlv21w40F/vO3C6tHxGjOjHYb6
X-Google-Smtp-Source: AGHT+IFgJBpNuxi3ocERek8ZEjpOAjiislMEQWgqugk5bKqlDdTRvki16pecSgbGbndODqmMuHfBJGffO6pv5HRyXsM=
X-Received: by 2002:a05:6e02:12e6:b0:425:7567:7487 with SMTP id
 e9e14a558f8ab-42594ea7fd2mr3152535ab.5.1758750959188; Wed, 24 Sep 2025
 14:55:59 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-10-ryncsn@gmail.com>
In-Reply-To: <20250916160100.31545-10-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 24 Sep 2025 14:55:46 -0700
X-Gmail-Original-Message-ID: <CAF8kJuOyck_4bsy1=Ek2MFADfj9p09_+aQ+59-0NtpSjNHuNGg@mail.gmail.com>
X-Gm-Features: AS18NWBQx31zmrvTS7h1YvQaXb6rQlk-DLD4IkRJLY1_5cZ-sA6anhebF4UaAh0
Message-ID: <CAF8kJuOyck_4bsy1=Ek2MFADfj9p09_+aQ+59-0NtpSjNHuNGg@mail.gmail.com>
Subject: Re: [PATCH v4 09/15] mm/shmem, swap: remove redundant error handling
 for replacing folio
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D525C0002
X-Stat-Signature: ewfzb9sghu69aphrwr94866pga1rt5zw
X-Rspam-User: 
X-HE-Tag: 1758750961-307918
X-HE-Meta: U2FsdGVkX1+V+tByeVRjubho2ndLuxGdjOhWCrGL/X/zqs6OHNW/QTULDqrjtbynzxpElOOGec4TjCtr2nAMk4VFcbiOfPGaa7Usxg0aYsXSzrLxmEgMqT1miDAWY/HJmC+gl8/Rx1JgIF9RMFMjHigt6EF2IDbx2YwPb7neA6JrVsqclOanwtOxcZiVq6hlCG2rPKfTtznFpXrUf1WAz9FqPvnWXpV8wn7v7gHvvDBXRGNZpfnnJ4mRCdMEOOdKurvQc27cQ422IlgEhx0JmAKz0JZ+LKn24qMAn7WF6mcQgxZi2mMLzrnR0vU5M3r3jFQ2req3hP0evxQIrEFDnBxuyS0WnpEzxswCZa2n8bkTYCk1qlMNQhsHL5gpkcRucdfdNxcgO9kMYjNab2fjLsp6bAhbmXqwV9yto+YHNfAJvxxFoPh0j1CjqJBuO8UoXJS+DoINQ7LO7zW2hyaHsNJ1GBAHcWmaxiTzzhhXVe/Z9DAdPgFrRtnbkpt8u9xcyTUVEdqGO+2qDMxhVe57fbWmlh2i5uenyduglvn8hbVznhLLoVC5z7RGsgH9nupqyh9yCOBzxfPuOuMTZepl4MgVPkeSIdyk+hIRzOyAu1V/1ed6rN2K1EWXB1wIISVrRBg7xJeVlfnVu6cOD3K1SAEWPOI+tpjAqiXOq1GPExcfm5vn0F/VnwnwQJkve7f9HJgdUo+oVaO4exMNzFOYXA0bfZ4+VZkKjNsQCMfPfNd4KXsBxLMdZdw9gtBcYWDeV8KK3/9NIl8E28KUqUJD6tgS5U0QFs5D9wQEhTOgbT4oibFaoSL4uRpuqGg828PFnzSOwRB0/YhhLq1ySUybHZylipVynQoDIWJzqn7oK/T0iwQSiOylqaaDNYxlhPxtgQKvn1Dq0oJs5PBeRQDS5x0v13MJGueeNFdQHvyPixjpBH2Tytmtar6N+kf2GwV80SrsJ4GDxKK6NEaQQcz
 e8pJuQzM
 0YIKVjDzl+a/hhPoXdNBgSdeC/dVQoMfYPjB7kTyNQlf04yGnGW8jJVCOGp5/J49qD5R3jn4uIKUlhYwQoTFA4RrfcE1lNcED/1zaejHA62BcItwNx/H29lid7JBWo00KB7JczEWBtcr25ZexH/KIuyTQ0HTZyaEfCUAxBp9e8OoStBBAdlTINy3h4rntT71q9gncyq+/skjh4rNkVn2u9/YUbqh8EKCUJDNY7e1X3ggraBeSZKMMJIjODB+3hNiOb5yV5R9ZxSlFXvLcOTKyD4IVbmm3lualVn5AlSyIqSkOkiswOY3PsyaG4Xbfxa8e+c5MVMh4D4rMx3oGjvxmrkpvDn6c+2TYC6U6gI5/422dKw6oajPJp4E4jHRsMTWgN9UMJ1dEGRTZRAEInO3SSLdBlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 9:02=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> Shmem may replace a folio in the swap cache if the cached one doesn't
> fit the swapin's GFP zone. When doing so, shmem has already double
> checked that the swap cache folio is locked, still has the swap cache
> flag set, and contains the wanted swap entry. So it is impossible to
> fail due to an XArray mismatch. There is even a comment for that.
>
> Delete the defensive error handling path, and add a WARN_ON instead:
> if that happened, something has broken the basic principle of how the
> swap cache works, we should catch and fix that.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  mm/shmem.c | 32 +++++++-------------------------
>  1 file changed, 7 insertions(+), 25 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 077744a9e9da..dc17717e5631 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2121,35 +2121,17 @@ static int shmem_replace_folio(struct folio **fol=
iop, gfp_t gfp,
>         /* Swap cache still stores N entries instead of a high-order entr=
y */
>         xa_lock_irq(&swap_mapping->i_pages);
>         for (i =3D 0; i < nr_pages; i++) {
> -               void *item =3D xas_load(&xas);
> -
> -               if (item !=3D old) {
> -                       error =3D -ENOENT;
> -                       break;
> -               }
> -
> -               xas_store(&xas, new);
> +               WARN_ON_ONCE(xas_store(&xas, new) !=3D old);
>                 xas_next(&xas);
>         }
> -       if (!error) {
> -               mem_cgroup_replace_folio(old, new);
> -               shmem_update_stats(new, nr_pages);
> -               shmem_update_stats(old, -nr_pages);
> -       }
> +
> +       mem_cgroup_replace_folio(old, new);
> +       shmem_update_stats(new, nr_pages);
> +       shmem_update_stats(old, -nr_pages);
>         xa_unlock_irq(&swap_mapping->i_pages);
>
> -       if (unlikely(error)) {
> -               /*
> -                * Is this possible?  I think not, now that our callers
> -                * check both the swapcache flag and folio->private
> -                * after getting the folio lock; but be defensive.
> -                * Reverse old to newpage for clear and free.
> -                */
> -               old =3D new;
> -       } else {
> -               folio_add_lru(new);
> -               *foliop =3D new;
> -       }
> +       folio_add_lru(new);
> +       *foliop =3D new;
>
>         folio_clear_swapcache(old);
>         old->private =3D NULL;
> --
> 2.51.0
>
>

