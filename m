Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CAD0606A330
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 20:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gmCmslt4
Received: by kanga.kvack.org (Postfix)
	id 2D2226B05CB; Sat, 14 Nov 2026 15:00:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AA116B05CC; Sat, 14 Nov 2026 15:00:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 198AB6B05CD; Sat, 14 Nov 2026 15:00:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDAFD6B05CB
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 15:00:15 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 08AAE1C3C5B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:00:15 +0000 (UTC)
X-FDA: 85434791190.14.00FC039
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0212C180002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 20:00:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gmCmslt4;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794686413;
	b=EGCSNyNMF/xVS32tvJOUsTR/aPtyiXkEhjxMayBWmYwOYBYU0WqXUoqvJlmohCggRZdiyI
	SnOhSMbqRSRNG75jpoePZvikmafXEUADy9Ssxy2j97FXzl04DFTbbpdv8N9ZJ+diwEZGWX
	6excw8N0rZGQz04Zv8l7Y5vr1YMy+aI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gmCmslt4;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794686413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sOR+YhJV4utRWR4d1PAjqxQcUdv0HHDpc8pa5uwTO94=;
	b=EgP8BCFeWhMAmghBV1hD+CtYmsgv0prBdnsLR5BlVeiZgwmpISZx3vuGNxrJI/mR/3OXtn
	x+9TXUafdJvcSLAKHPyoha4zPphDJHTuoT0oMpWxiG/af7vyf87xNqJqf1vSDnvKv9iyIT
	Vgz63oLfqFyaReI9b+r04OpyR0gR9UM=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c4395d31228so387644366b.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:00:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794686411; cv=none;
        d=google.com; s=arc-20260327;
        b=L8KPrBoCIYmzqWuL4mPfPShvtPB9ZBIVQ6B2H3CrH9oZIQSQSlWgGE0wDL6MC5a+Js
         JrodzYezyvjZ64CLv55dXlgMPxeZfG/b9fZVHfLaqasFSbKQlPVodmucN4Nm0Szboaba
         X9loPLeqvP5LUQdJgA6N/rfoL56yt6tbT8Y/R6Qx2gz32RJ6a0q88S+xGiS89Y9flE98
         XfE2DGHEMmp8YL4GclJLZm4eT4NOsK520koM7Vrt14vb7VrwPjD+DqqMpSz4aiZTWJ2j
         o7svjrAcbnzXkfXLGbB+S489y9EtOpfr/YHs6f0uD2e75dPBYWdsyMuEg2DniqQ8S7Oi
         mmwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sOR+YhJV4utRWR4d1PAjqxQcUdv0HHDpc8pa5uwTO94=;
        fh=THs5RMYEBlRkLa4IPsoXWzXTRTDM3Mmatw8w7VmLCXA=;
        b=JBCQ3J57pFU9d5hpQYh4Fs50HHyHT2Wp3+IUngH/ouxx4x7aZfwpoKafbQoAqCfm1w
         lA/bpxZwS81Ke17nk2v7iiZ3r25zT9YTAtLD5FGfzg/+ilS/nr9zXl0hVXPnPtuPhxEn
         auykxVu45JNKjHuEqzb3qnd3RnOGUQkVBRgKLku8x/ubL68IUNDieamwp1mGCQxHR4Pi
         6JjJ84pmPws8wB7pM4SjNyQJdfsgIEBy2RZOvdP4vz/RxO7Zr4WhMc3Nn9fiJXgf1dWI
         42f6PleKSrE7Or9NPfwIauIHmArp56VpuwVY+X92hpLOJcZBXPpIBP9zBqQV6QNBu+cP
         225A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794686411; x=1795291211; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sOR+YhJV4utRWR4d1PAjqxQcUdv0HHDpc8pa5uwTO94=;
        b=gmCmslt4QM9ewriL2sVJ/LTcAtLp4FA96pm2pxj+lJJPB45EFe2jh1QzmDVQ8/mHst
         eSxTkqz2A6xYmTrcCBK7BmPQL+lMQIj6brexoKTlnliI8tG/Is19w0UBaZwZL2fA36zZ
         19+EoLXXCntNC5ShVYuBGbcZUo85gU5dMvDQ4CWjztHoy88ER/ZtG6xuVaKGnvmBNYDR
         Xw+7wt6g6aKYdBHbGjp/WBVVdqjoV77Auw2oUw347C3kwZAWs7AHu+FNYOFsQNNdp5Mz
         e1r5neTTbW5GUq3AQRHeSGQ4VFbeVXuHWW6XFLtjJs3+RnzpbaVcLX8OyBgrM1jIElNr
         TjDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794686411; x=1795291211;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sOR+YhJV4utRWR4d1PAjqxQcUdv0HHDpc8pa5uwTO94=;
        b=F3Gcc8G8TOUeZ0NOJBVTLE3sdiselFElk6XqZgDigSZashH+uOCPVTzzoIdBijMbqy
         XFAvAhDmMPphpXldr3ASYxJqzqQn/MUfD0fAfPYUJxm4HH1auEyprAZZGH/KkwLK5hUZ
         nBpsJETuuwz7dg6Gv9n6DjVBncTyWjMAwhy1t/A5mb5h2D7idieGqaVKv0sVmKzDGqGQ
         zdxkZcxfLemTeR3Y9BsZWDSI5a9Az4/9XrYW0li+LeMCd26EmUACI674UxDfhoc6UnE/
         sYOsCWB6alds2MmJZR6B7GFKQsiccPVfmeb11HXJh+OyvToehBnRxsFbNzIdPviYuwNS
         iSVA==
X-Gm-Message-State: APuU4Z/vMIEBdyBfcMGHPUSdSmh+ksyJfyqQYoVf2qFOKqAp/jL4Vftf
	wNqv5t1/yUDzfRoE4TIZhWyxABcIaoFMhy28ZUChomg/Xsq/pVtv0iSYpB+r9pZnWfzxkQfZrVV
	QRiudyYXpO4D/+ToYmz5FtUIQq2Qhca8=
X-Gm-Gg: AYBFou0YnlPlQBx2CGb80zArH+qBngWQ0JmCGLbQv2G08mrvkt8k64OPcFw39JMX8OX
	8weSvB+F0qyfH9U1uiAgtOyFvLMw2diCeDu0XiAdGnogFQS2c78/ccQEbQ1P7S2RcOUXBH8I/rd
	72bbHDgcVzbck9MUSObPw63IK4u3FHO9Ni6J0eU79PbTMlP1zKA6nQzAxlIAaQnLjtnkVkz6wei
	ojXUlMY1K4NI5a2u2QPsldbwOrWdfJMao0d+2QNVndT6pc6C3XjQjRlU7qKcaTgsc8LFUPynqaD
	4vWl98Q6YmUvCBm2J3ZuuYqGYoyFELsk5POeo+46/mu31VqgROVYrgONDaIbfMAPAX74Yt/GIr7
	1qHReZbF1KXfABPWLg0DVvccH+oEhURPyW4iWIC/s7T42REZ0d9Ispu/0t4U/L/AJDnH0+A==
X-Received: by 2002:a17:907:3e13:b0:c2e:3ed7:7db4 with SMTP id
 a640c23a62f3a-c5096340feamr485567566b.23.1794686411138; Sat, 14 Nov 2026
 12:00:11 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110151407.789960-1-nphamcs@gmail.com> <20261110151407.789960-4-nphamcs@gmail.com>
In-Reply-To: <20261110151407.789960-4-nphamcs@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 15 Nov 2026 03:59:34 +0800
X-Gm-Features: AclHuK9LiJKo4q2X-ldOljDTJeh41yrOvsNPTDo5hFk09bG_rGCM5-ExnL2Puq8
Message-ID: <CAMgjq7Cwb-hTx=36CB_gYObgN+Jm4VihKrxzjxQ-YujvJEhKqA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm/swap: skip relocation of tableless clusters
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	david@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, ljs@kernel.org, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, willy@infradead.org, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, chrisl@kernel.org, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, sashiko-bot@kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: z4qzz7n33m3fjajputoq4ukunfmstxf3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0212C180002
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794686412-692499
X-HE-Meta: U2FsdGVkX18VSenBr7hThV0O6/p63ZzU91hKubFMGitgmxXzzlFnNlQf1HDOgBYppe+OLEBoobk5mRNpKfemVAdXzF7Svoz5zjXHP9oNBnowiOQ4guCOK9su5OCUDaw0NSruKfjDdhR7cDFF9K3EERQN4cLmPXWuUnzNrsjAjCL6LxNpaUJkRHAkdk9oEhhF2QUIgP3Zg7X6wjQ+0euIopyuh+q5/1UQHjSnfdMQrpf47tmkKREMcjjX9yNpl4iogtguBp3y7WMcxfT9DeUL1p0hF3mFZTnRe7S/3WbtQVM8Jf6xPA6R5Z5OwkuL7QleQwPRVvunXSOqlf1mImec8urOS8RoRDOaHGNM7s4pp/Km7UmEq/sZ7A8vFqXuYk3CfY2HZZ+WXGVeRXK3MJTEAN9MrBQI4G4S+8A5ldNjhk3jk58rLIPfTHab/RLbNu7kUDhDpZ7EdsgrIYIUK0+KUb1mAPA55w6riC53EJYKTuPBsLJZ1Lo3xtZohbVtKotukPtnPGDt5+yKjNBPgZQSVZZJjeDeRIRudeCu4jZzL0JUuJsuEg3xqGV/ejjuPwWnFgxP2DktQroezVLmHy6fU7/snuYP5bEpArlN+8yEggnntxe9QXFpgzz6jJ03U/VR/61B9M1QeeI2xwv2yvgmyfgm8t3alvnWIliBTfay4gHgHZUy+ci/EuF+T32TfD95eSOT04+dQDAD2iOgHmijJjEMafigHbsFKGxmu2UXC3j0X7Mci1HYpIg66k/QQymlyuWKELA/e6yXOo/l4yQbqULrhvug0T+6H4hPtbyzJDHBoVXlTDo5Jsqkvjhv+9u7+dTKWhMDS5MmA6oLAf8vJcjn4WpncZ0w3pVMYdUlNu3N7lIIxcREJWZ1ObTVmDfqKl5k+9Pfq8nRlvHnjhMUbJtwSJ+XpLoPt1en7W9MS9ow/TnuyblzMHQtP5fh2kHtaQOYL9dPnPJ66zqIgia
 +h+pyeWz
 CDsthgSWHGZZkWNvcV9LUEzdX4udatHn3v4DYOiwJ35fHUoIEhinCZvh0tttPyNaOGp5rZIocNbD0rij+W2KxsRjQ/qPdgd/38sKPHa9XB4WJJhgb6gxLJG6vvhCS2EJljMQ8mqEi6vWrB0vIzsUDusgXhxQfGHwld6R5TVo0fuqdmBbO69dG2gHzcIax7mvET/QU9I7+LSK2t3wyfw/5/xfpWwXgKHCliq2//sLDn6SNotNIZluQboEnIT3V9PG6vx6DLhr2sElNEfffuMqM7jS52QCtyP9PjKtEvWFG77gdtDT7KroG2ijQzFm9s8q3gvBO/dJayRUxBlDn9jWuYcO85n9Mx7jKH/D1313liTWGyy/M8xqqhk0PJi6RbXHTYqhOowVR/504LWCDi1LsXUg5MKsxwZBEvAAc/7EAprjXgghbCJxt37NQ8pe/Ry29nyo4ClBT+DbKadgs72A5WdJ8oGWvhxRqj9yN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 11:14=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> A stale reclaimer can reach relocate_cluster() after another allocator
> re-isolates an emptied cluster and drops its locks to populate the table.
> The cluster has zero count, CLUSTER_FLAG_NONE and no table, so relocation
> can free it again and dereference NULL in the DEBUG_VM empty check.
>
>     CPU0                                    CPU1
>     Reclaimer                               Allocator
>     alloc_swap_scan_cluster()
>       cluster_reclaim_range()
>         spin_unlock(&ci->lock)
>         __try_to_reclaim_swap()
>           swap_cache_del_folio()
>             __swap_cache_del_folio()
>               __swap_cache_do_del_folio()
>                 __swap_cluster_free_entries()
>                   free_cluster()
>                     __free_cluster()
>                       swap_cluster_free_table()
>             swap_cluster_unlock(ci)
>                                             isolate_lock_cluster()
>                                               swap_cluster_populate()
>                                                 drop ci and outer locks
>                                                 swap_cluster_alloc_table(=
)
>         spin_lock(&ci->lock)
>       relocate_cluster()
>         free_cluster()
>           __free_cluster()
>             swap_cluster_assert_empty()
>               __swap_table_get()  /* NULL table */
>
> Leave tableless clusters to the allocator under ci->lock. This also stops
> a stale reclaimer from returning a cluster to the free list while table
> population is pending, avoiding the resulting FREE-to-NONE state cycle.
> The existing cluster lock serializes the table check and relocation with
> population.
>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://lore.kernel.org/all/sashiko-outbox-203018@kernel.org/
> Fixes: 07adc4cf1ecd ("mm, swap: implement dynamic allocation of swap tabl=
e")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>
> ---
>  mm/swapfile.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 32639f65f13c..9fd62e4ca7a0 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -815,6 +815,13 @@ static void relocate_cluster(struct swap_info_struct=
 *si,
>         if (cluster_is_discard(ci))
>                 return;
>
> +       /*
> +        * An allocator may still be preparing the table.
> +        * Leave the cluster to it.

It's more like the cluster is in an "isolated" state so we shouldn't
touch it, similar to the "discarding" status above, this comment also
looks to me. Huge thanks for fixing this!

> +        */
> +       if (!cluster_table_is_alloced(ci))
> +               return;
> +
>         if (!ci->count) {
>                 if (ci->flags !=3D CLUSTER_FLAG_FREE)
>                         free_cluster(si, ci);
> --
> 2.53.0-Meta
>

Acked-by: Kairui Song <kasong@tencent.com>

