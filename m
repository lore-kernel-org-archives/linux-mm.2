Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7D64CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 11:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AAF96B0093; Thu,  8 Oct 2026 07:57:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65B796B0095; Thu,  8 Oct 2026 07:57:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54CCB6B0096; Thu,  8 Oct 2026 07:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CB386B0093
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:57:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A450A1202B4
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:57:16 +0000 (UTC)
X-FDA: 85299308472.14.9E8230E
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id B07D61C0006
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:57:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tFrEtcSM;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791460634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0i0Jq921Jsm4vHHGLuxvRSz4j2TVU7+5Bry6BxrlzE=;
	b=r6A+B7MXC3QEKyAZgBLAVL8nzUMsFPx9FbcPVJKH4ML5aY1Pq5AYYZGlxhHWqSLdBy/OxR
	ccyhCW2QCyFrbZKgCavHdN/zNdPqMJq+UQ87NPP2/C+JdzzIDXQbUo2dlaiZ967KZrVlA3
	s/uOGPVk5+HXzKpFJxwnv94yFeZJ3W0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791460634;
	b=Jy29BeJ/MyjgdVe0bXc0nF8c4crAgtUKBiUQ+U/7RiaqCxt9yv2jgd0R9Yx2+ZuVhmuZBg
	BLvCWyylLGFxUTVSQykGRBkLTbpDEynNdKzMoBxdjtjuLA5epgYHJxQocLSAiQCAiE5Rkt
	rEmSQH9CR/o3K9sBd1Xgbo9OUQNMWeg=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tFrEtcSM;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6ae14eecc64so7473994a12.1
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 04:57:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791460633; cv=none;
        d=google.com; s=arc-20260327;
        b=ibNnOEw/uAD6KgSg42bzBrodU3IGy3Tbn/6fmMT+BC91q9dyP8dxwDMkz/CPl61quj
         ZT+jrAsBZR7f8pNZZ+njyqUgbf345Ctd7z+0r4wr4AXnwdkUcoE3OC0kFErJJmlVdPh7
         +mJFvMhA2b9m6i9+bx4PIFwzgi6nzK1Lavp6D38LquEBSRtGyzyYZ0UoHGfpNLxJzB1T
         4G+k/ENBMmBIpfbIdsXmTz6urHjGak/YazjE+gdAtHoXACCvx/MDEoEh4QkX46Ta0p2M
         AOlppUwYB5zD2Fs/bz7aB3MiLGTifrwL2pUZbB36L457UYkE1xSqxGWLkngYTkmAmGxh
         5coQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+0i0Jq921Jsm4vHHGLuxvRSz4j2TVU7+5Bry6BxrlzE=;
        fh=C0k5CxafATtgVKZ9+KflgOn8ppwKFWjlyIS0ylYuKaI=;
        b=OcvA5zx9t3QUx4+0TAl3lioO8vdX4H+NUTJ36m5TehV2cMuHYMZQLjh8RbJGIjE6r+
         kZ8O9+K39DZcgN/GVRtGbP9rC/FUMd2fXSH0dO8mybf/QpB/FB7ZgpbRFXydIrXOD3Do
         /mwPP28N2xJROVdzcXIP+4auF7WozZvSB6BLC8/2oBeXDENhh8R6mYeFmvtI/usgEe9F
         sYdOeRstMAUIq959nR2Icz5H8aEjxmpPE4nxJYBvt43efaN4+SGN5Whn7Bqy4smRN2C4
         oYzJGlL/D28ljY1B5J5dH9MqDCQjz9vaQ089BtVsNowahNkRI9xlhGC6tSaUhcAIXWZp
         TtKw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791460633; x=1792065433; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+0i0Jq921Jsm4vHHGLuxvRSz4j2TVU7+5Bry6BxrlzE=;
        b=tFrEtcSMlI3vlrp56Fdpo01Fz3szlRpv94zvXMHHdeUIqJM9wJ5t+nLbIc41puqh0l
         rDl6PGtyqKUho0TTfoMq6HXEf/vsvhiOnAnheGJ36SiQwOjHFsADzMsKUEw4U4IK7se1
         nYqPpgEREnunqHH/BtJcXjsRu9HKv7Q7fp4JW8TUGPUuEl2JpBkdHq86Iktb4XYyKj5a
         hV6Y+7zK2/hkEsbEaTIPq+EQZguAW2LaydhCUKoGJEcuFgwaLoGeRHlk4WHDbfFSZZsO
         vl+pAIUZYzP5vWKphyCkCGeVKnL4Dh2WUeibDoSvmvo9olXjYCOM/0NnOqloBzTMR45h
         L0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791460633; x=1792065433;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+0i0Jq921Jsm4vHHGLuxvRSz4j2TVU7+5Bry6BxrlzE=;
        b=ePsPm7tXtkSumkUBmnWx7hr2DOgUaeZ0tnE9i/8npe46rdcUnR2let/0XYrhYnsdEK
         oEqy2ftS95FnYyOS8bnX9E0JflozDb6177c8uIlCf5sjpB1BOI99fZwIW7pQGyFUvLzU
         Da8d7LANuRBGofB+K6ERV9Bfyo8bh9oMXKl+YAXiLXOz93hSp9YQ0Wuzx0aJotAqokoE
         7VIsPbHzIBrPQ705BLrMiOJiwxA2Rd6ArWS29tZ6C/baPcDXidO41wyge9qB9Rq9CYEm
         mvsdxzeWciD8aE8W6KSdNLXQe0BhaK5IorZ1CtGjTEFi58tJTAdpQ6QlTIT8snMe/hZe
         F5jQ==
X-Forwarded-Encrypted: i=1; AKwUvBzGrFAEYhSkifKnVMq7WicltduKM7RT/ZZbiIAZDKroA2sur3fqjSCsG442pKjrZQz48D1WLkAnPw==@kvack.org
X-Gm-Message-State: AFq9FYI7XHXGAZdOh0cLfKtthg3FmMDLImbLc1SKTJo7Yi4+VYSwXBM2
	nmdkGaf6lsiDdhOw09RXOUSGVnrTP0DrkVRASgJfqudoMsDpQeKpj0ofAlcsNgxuzNccoL6EwVf
	pGOwgN9e1bdp03u57+YGuDxeRQAXvyRg=
X-Gm-Gg: AYBFou0kFlmcBgOBNY/PqMMv0gqhra/oiuyvNBvLmbCBM6bYWenZbamnZAaDSgmYag8
	PTYTNpUXnbmB9+Hk77f6sG9ok6QILTv4HAVFBGucvEvPQbfTyrLOZh5SqPozptFJyj/614XO25H
	9cpPTUUNF+ofgxnGy0hHuz3fUuMukNwzq2Ozc4QwWeDDr/7KlFBbY7lpoHJOprZrYJX8IMuWaD7
	wkpYqB5uZ5xljmH7KMLnMT+vd0oGuNSDafCJLquiG4XrV9xXpQvuFR++ND12znqh1mKD7Av36Bl
	bqs79Ig8Y66oXZ44iKHF+nRNi1Pkt3N9pt0za9BT3QC8UV+Xqw64YCMt+Sp5YuVKkjKZBblRwPt
	9MZ33WhfoPXQ=
X-Received: by 2002:a17:906:dc8d:b0:c2e:317e:d711 with SMTP id
 a640c23a62f3a-c317bf5998emr545727966b.27.1791460632767; Thu, 08 Oct 2026
 04:57:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1789096175.git.zhuhui@kylinos.cn> <2ed42f96aca124856ea30f774afb55cbe6d8ba58.1789096175.git.zhuhui@kylinos.cn>
In-Reply-To: <2ed42f96aca124856ea30f774afb55cbe6d8ba58.1789096175.git.zhuhui@kylinos.cn>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 8 Oct 2026 13:56:35 +0200
X-Gm-Features: AclHuK-BxqNrNonn8CRYTTdm5cPRpBrRGaffHfg8y4IMBYCVm_4XzkFHjExbKwY
Message-ID: <CAMgjq7A0FKTJuEKSmTvJGHMOiMz_uAwE=TD89JVvLPysinUVaA@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] mm: workingset: use lruvec_page_state_local() to
 count lru pages
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B07D61C0006
X-Stat-Signature: zpdoinhecytostu675gwjcdp48n1m3dc
X-HE-Tag: 1791460634-212596
X-HE-Meta: U2FsdGVkX19kmWsIVdheHALWJgTtkaO9PX5xyMqa/X0Nip3YiwPzTxLBXZWhd9VqyYIewJfrohsuqQlyJcvQPYo7uN7oC32sapBzrpqPaIoLelQogwdywfhdggJIQKGYuyS9Ld15Q9L/5OsLQNwVt0L89VWqUh8DNonoZKYswj+2SlOWaYb2cdklLSQT0wqa/lwtWkO2C54znf15KS1AK8BXnyIQkPbPeKaDQqPpSh9I3GHLI7fjdVdE0mofY8BXA7ocSfdS4eTzPMs0jJ6o9cdJdeCaDpqiuFy+zDTbRFovqRpTLaVxIm+xNmfmJCBAF9X1EDduBdEA7Owol+Kz9uXRzFQEuVvn3HfbiT9OG2S5f3OpaPxQGdQlwhjhpk/35JiwOsJiQ6oNZs2mpu4rcMv3Z5+lF4GH3g8avB8v76Qx7M4+o5lCALIDld7oXDOX0a6g2YA7uKrrKA39e5EuxfcpWapUZJWQDRKOEiFkmX1TzsogqnepS2vKbGTKfWdGycgyZP9zwmKI8aUoXzuVeaW2xlYUF3N+9VoaiC7vRGr6cbWFcF0mlOuUb055Al5U4aBU+V7NGYOQGKQ/ghd/p5lSB4JF9QI7IQkD7OjDsjmX+1wNoMKVKBa8I8oc4yAPxPqOWb+pZjATwBUeu5any9HGs8JMhnqN9n1l5OjzWnRi+SVkuVKnPI3VJ6AglgCi2Wj31ZvjcA5KTyNYetTuRGQvY7+ctXv2lGJQjiv/GbDTnAZq2UWBaeA81TXFjDAoH7C8tiOjV4VlzspIzpGpKW6EomFGKLlcNyDD46hqolXCZqAXGudGwuqdsP3xtzkeRiYpgVkjzWtEVz2WjS0Q0xWYbKN+zIlir0PrATfg+G1DFPYurreYEQ3E9dBy9LcDvB0RRUbGtlOY0+DtF6OevWD1+AcFxEPR+duMkfxraZfXZG0EqaIz2Y8OkUD/qZ0svA7l4QU1+Ml2pRdRf4+
 8hA+FUZ5
 fK2g6IDzVstXTug3eUpUyoGENDhlRDnh8DHbuLmv1gU9+LUg2cB8BehQN4Mipl3pXTGjEvIvvqZvE5Wutw5niZ/EhG8AQipRHv2IYur9L8U3sS7Zh5hjcgZ3YuzcMyZofiP4a9B0NGEenyLa2OjFKv9jft8lfBydDempnjUrX+3yZ4/rL2NNcsi/J9EKpvtqq/FjkB3h5EWqC+/OeC45VDAyFpqyXU0ARKzeHG7diBd8W/4351knopX0B5PcOYBBIT+fzOb+cOc0rmEN/QKBOPG303V0F0nVloTsK5KsEmA0FLg2YITVy++ApsEYnlZNCvTaxN/YQ6JcUW79HujH/cLZ8pbFda22fKZ68Bdw4Y3ZP087X3x9eV8Cu04QRyYWMv0Ppd5Q4qVK3EGA/GwzXONjh7p5UlmHaTkn4xPc0joZ32BzHF4L/NzRtjuyZQAVefcVRfuxoC+WbEvomJh2vs53MUeYrTQOl+7dJWRs3ayw5+YHOpUD343ABJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 10:26=E2=80=AFAM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> Commit 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the
> number of lru pages") switched count_shadow_nodes() to lruvec_lru_size().
> With CONFIG_MEMCG enabled, lruvec_lru_size() reads mz->lru_zone_size,
> which only the classic LRU paths maintain.  MGLRU accounts its pages
> through __update_lru_size(), which skips that array, so with MGLRU on the
> four evictable LRU lists are always seen as empty.  The shadow node budge=
t
> (pages >> 3) then collapses to slab plus unevictable pages, and the
> workingset shadow shrinker reclaims eviction tokens almost as fast as the=
y
> are created, losing thrashing protection.
>
> lruvec_page_state_local() reads lruvec_stats->state_local instead, which
> both classic LRU and MGLRU maintain.  Switch back to it.  The reparenting
> race this re-exposes on cgroup v2 is closed by the preceding patch that
> redirects dying-memcg stat updates for all hierarchies.

Looks nice! thanks.
>
> Fixes: 7404bd37cfbe ("mm: workingset: use lruvec_lru_size() to get the nu=
mber of lru pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  mm/workingset.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 7ac2b88c80ae5..8412f4840ae35 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -688,10 +688,9 @@ static unsigned long count_shadow_nodes(struct shrin=
ker *shrinker,
>
>                 mem_cgroup_flush_stats_ratelimited(sc->memcg);
>                 lruvec =3D mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid=
));
> -

Blank line change is not necessary and I think it make the code a bit
more ugly...

>                 for (pages =3D 0, i =3D 0; i < NR_LRU_LISTS; i++)
> -                       pages +=3D lruvec_lru_size(lruvec, i, MAX_NR_ZONE=
S - 1);
> -
> +                       pages +=3D lruvec_page_state_local(lruvec,
> +                                                        NR_LRU_BASE + i)=
;
>                 pages +=3D lruvec_page_state_local(
>                         lruvec, NR_SLAB_RECLAIMABLE_B) >> PAGE_SHIFT;
>                 pages +=3D lruvec_page_state_local(

Just a nit pick.

Reviewed-by: Kairui Song <kasong@tencent.com>

