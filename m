Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B41B1FD8779
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 23:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233AE6B00B0; Tue, 17 Mar 2026 19:38:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BDD86B00B1; Tue, 17 Mar 2026 19:38:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085656B00B2; Tue, 17 Mar 2026 19:38:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E49E26B00B0
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:38:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B299B1B7E3A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:38:42 +0000 (UTC)
X-FDA: 84557172084.05.7C06B6D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E346720004
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:38:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="L/MPvfbd";
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773790720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yku0rMfo5KRnI6sOIneKy1yCYYDlqzKd8iKzA5X2r+E=;
	b=4X0XqhG5wadjoI5aVPXApeQDcPyl4w6xFHIfIjp9o1Z+D4mGWOtEDMRRI/sZuTLF65JQoP
	WNDg9Iiz9d3I+nhiZ38eMqbuH9DBgSvyloiduJduRkH1qvrH0eKDql9tFI0BPZGv3/UvXR
	Jv/yfLScsIcMUUiye3uaxBCLK2C45hs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="L/MPvfbd";
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773790720; a=rsa-sha256;
	cv=none;
	b=ze2z9oKBT6tXuW64TUv5uaTyT2DGTQu4WASXKgo5RIaev7MOseP9+t88u7yCKjkp/AgIpt
	4I3+gF80sLdnh7IIjfG++/E0iXPbuAt+QYwfXHSCuqBUO1h1U8MLmaJQNcmeCz8k6d8auu
	ZKTE6mziw7k2CFy7Y7XE17RKK7vaWd8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E1B461119
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50DCC19425
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773790719;
	bh=z9IH9OKJr5RtRPTjR6nTyEd3nuoW0Qtcmuy6u9T3pDI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=L/MPvfbde1VDvQq87fln4fs0qU856NjFg9MDlH+jQ60+1MG0vtSltd41Shop7Xxjs
	 QXGM+hPuiVTIl9sZFzhhsdWgJyi2v+cGpcleLgkvcP4onrKJonu42TJKW2zygNxzGL
	 c4yo5ezgunWE+dBLRsU/dz9d1iA7ipNLsWGqhNhuk4co6B7dzQVKMMfVDXFM/Yve8B
	 QAthOTuu803mTm8+yAHiQbk/qxr+Ks4lt97mm74aE8DUHcej0gIrKFoycqXbDl1KaK
	 un4T3PFbbZW87kVzs8jn5jwyLNy2hECJboY5a2KJRo8nYYcMMrEbQgMY5a0yi6XbLI
	 LS4xPBY03Qtrg==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b942424d231so777300066b.0
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:38:39 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz/aZqjGWb+YvC3j1K2VPJGhV1QP6ue1reFMbxJtMTtglmHsPd9
	xWvfh4dEVicfHIVgXq2jZGimAGlrIHePcCC6vDMCxHl2eNLyqoCfDbc+Sow4ppJhRL5vqLfFSM4
	XezW6+UMWnV5JXHqANk7eZLqNdP8bP4M=
X-Received: by 2002:a17:907:e101:b0:b93:5612:a57 with SMTP id
 a640c23a62f3a-b97f4ab77a4mr41074966b.52.1773790718620; Tue, 17 Mar 2026
 16:38:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260317230720.990329-1-bingjiao@google.com> <20260317230720.990329-2-bingjiao@google.com>
In-Reply-To: <20260317230720.990329-2-bingjiao@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 17 Mar 2026 16:38:27 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPwxGX1jtRuwRk1ZZGX7nwEkFemz=qU44jsK4DUS4TyfA@mail.gmail.com>
X-Gm-Features: AaiRm5188bu_ZClF-T2AbXUIUyVUuMZFFN-LnGzmxGVywCM-tnHOmmkoh_z1ZLo
Message-ID: <CAO9r8zPwxGX1jtRuwRk1ZZGX7nwEkFemz=qU44jsK4DUS4TyfA@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm/memcontrol: fix reclaim_options leak in try_charge_memcg()
To: Bing Jiao <bingjiao@google.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E346720004
X-Stat-Signature: gwmbia6dz97dmrae9hyaxkn9enetmhxg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773790720-915628
X-HE-Meta: U2FsdGVkX1/YOYmFHD3cKdiaNV2hE7f9ERpsgDVnLVA2g2vmJiPwQvTQxXZK/X+Lz+OrTuUOTs9WI1zf4EIEMlImrCCPW4xHPktx1uRo8YyhgQ+gjTutIbw/4qJ/2cgsW5W4IifMQzcgzY8Yki9onnBWqMVzzVjnYmZqLm6oAgpQwQkNO3u1BXS3t/ypoDmogVYR0zHefJxGTtUgI5tEMfCANov2zFeoa/bHL0l9eqVo6uAOJMl9cJ2vzX4S1X2BDDJbbYA59v5mTuV/rm2kyAzBYOXqZ3DNwPlPsymwG72NqrvkI+8F9Wp+SX6qv05nmebLcJ3ZnelMO7iW1/HhhK67tXWGOhVh9pRyoo24JoGBX3lOj2/GTYlMksaegAyal49eh/l6MZfMMJasHfJpKShBB3BNO0H4OCVCMGyOBHm4g3b0+AhXaDh5gisfx3usnik0/PFo+blfXxB6qnjgPZNLEOGtGjq0kc7j43dHlIarsbkoZfYTcDq48pNcec0J6ENHFjjgVRuekd7mn5ch0x3sR0g6881i9s1hf44Q89Z6u52oJ0fp3uiXhF+Wx9iq/fxUuNlUoa07JrzSSdXx5Y9v7m16ki0Ar5L10isgUd5NFMz+Amsc7t/EBNaB3gdYB5BNX+ts+1j4lENYBxGxrCZHSLQDax1aSAWnxKn4GGH9rMktaEF9sc0OVrSEb46aU74Udsfe2VvKBg/MeZlCG+FKMQQvlnd/KaEbLj8D8riPxt67Mb4vl5vuAjBsRAgLac4wXVwma2wrJEXPkZDw4fNqxeQlR/ADtQvSN5Uyiz6CRDbYOWy6sDf2qi1dbtfgosaPN0GVjkUfC/yDylgXaDo8Hxx+pH+1ikuShhQZny/ElyV5uvUIEN2j+yNa2TfrWnmT668pfEdxCO6pNmhVAkejP/qsjqVtR/fYyr+sJvrKhcoTyoQXpAGn5B0v537zCqEqy6TlJ/XQeq1TlZy
 PC6FCE6L
 FhZOLxpsR62U91OtXpXkRoq4va2hxy4oToDjCrJhOVYzWcbDiynghSWXQoGMaB/alAj9tqpdBOgI15MDVqfjD/84FjglYYlrW70XF+gh5988FvWnXtvN17cRCWuxpkb1Tnx9pa9ifazgvRJQ/inOlfm5amuj6nVbGFHD3iodusG92mpbJhr1DlVZvoYPe1AYzmwy8Y3zmE1fNepPS2FWE6IWn62cX9p3x3F43RHlIsuIWhgwa1Rrm7bntdluypj2gE96SPl6JRaufqLq1kNT9Qv17R0aPpXJva8SKGa2xeSGkbEpOyH5/JmnMVx6QaLJuJz72bsnMUYwYFonlg6S/g9nR9tvZugYC+8dTzKh+BOyU/L9uzVwclrj5iZ+nPYlkT47xOoOmP/xNGnDjFs0gbqGElKoW30jtrMNkLVT9fyRBDSeTxXfDCat2LUb/OtTjzutW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 4:07=E2=80=AFPM Bing Jiao <bingjiao@google.com> wro=
te:
>
> In try_charge_memcg(), the 'reclaim_options' variable is initialized
> once at the start of the function. However, the function contains a
> retry loop. If reclaim_options were modified during an iteration
> (e.g., by encountering a memsw limit), the modified state would
> persist into subsequent retries.
>
> This could lead to incorrect reclaim behavior, such as anon pages
> cannot be reclaimed if memsw has quotas after retries.
>
> Fix by moving the initialization of 'reclaim_options' inside the
> retry loop, ensuring a clean state for every reclaim attempt.
>
> Fixes: 73b73bac90d9 ("mm: vmpressure: don't count proactive reclaim in vm=
pressure")

Before this commit, we had the same logic with 'may_swap' being
initialized to true and set to false in the retry loop. Before that,
it was 'flags' and 'MEM_CGROUP_RECLAIM_NOSWAP'.

I think initializing whether to swap or not outside the retry loop
started by commit 6539cc053869 ("mm: memcontrol: fold
mem_cgroup_do_charge()") 12 years ago, so I don't think it's a problem
in practice.

Practically speaking, we clear MEMCG_RECLAIM_MAY_SWAP if we hit the
combined memcg->memsw limit. I guess it's theoretically possible (but
probably unlikely) that we try to charge memcg->memsw, fail, reclaim
and/or OOM, then try again, succeed in charging memcg->memsw, but fail
charging memcg->memory. In this case, we should indeed attempt to
swap.

All that being said, this looks correct with the right 'Fixes' tag:

Reviewed-by: Yosry Ahmed <yosry@kernel.org>

> Signed-off-by: Bing Jiao <bingjiao@google.com>
> ---
>  mm/memcontrol.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a47fb68dd65f..303ac622d22d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2558,7 +2558,7 @@ static int try_charge_memcg(struct mem_cgroup *memc=
g, gfp_t gfp_mask,
>         struct page_counter *counter;
>         unsigned long nr_reclaimed;
>         bool passed_oom =3D false;
> -       unsigned int reclaim_options =3D MEMCG_RECLAIM_MAY_SWAP;
> +       unsigned int reclaim_options;
>         bool drained =3D false;
>         bool raised_max_event =3D false;
>         unsigned long pflags;
> @@ -2572,6 +2572,7 @@ static int try_charge_memcg(struct mem_cgroup *memc=
g, gfp_t gfp_mask,
>                 /* Avoid the refill and flush of the older stock */
>                 batch =3D nr_pages;
>
> +       reclaim_options =3D MEMCG_RECLAIM_MAY_SWAP;
>         if (!do_memsw_account() ||
>             page_counter_try_charge(&memcg->memsw, batch, &counter)) {
>                 if (page_counter_try_charge(&memcg->memory, batch, &count=
er))
> --
> 2.53.0.851.ga537e3e6e9-goog
>

