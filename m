Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 353361125876
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 20:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9A56B009F; Wed, 11 Mar 2026 16:33:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 686DF6B00A0; Wed, 11 Mar 2026 16:33:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 569C56B00A1; Wed, 11 Mar 2026 16:33:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 499286B009F
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:33:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6FC7C19DD
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:33:49 +0000 (UTC)
X-FDA: 84534933378.29.169E55C
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf30.hostedemail.com (Postfix) with ESMTP id 01E8480012
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:33:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IOYNPqRg;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773261228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YHI7l1WCAEY4m4EuY554pKNgGWPa5e1fuqNEJbOzcgo=;
	b=kvWEoIEt4xxhoL9MxDgS2ra3lrOaAbZOcqiXYc1VYOxoO3xxo+o7ns3VXrHH5J2U7knu2z
	IH2nFLEQ89LfUZmN9DFy/7O6V/9NVexwYXCwe3JS1+K2kCU27aHqg6h7QGcHH+v1pz/iFZ
	xjN0XGXtzt0Rjupm5kkE787Z9e8dnY4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773261228; a=rsa-sha256;
	cv=pass;
	b=2BABQe/VjWw6zUXDzdiqcd5rjVUTCZVpuku1TWoGRQzaytHufRKol8zrws6XT1Y7NNnWMp
	JX+i0RMKEAxAZ6ICB5RKq/o9wwPnJ/+UOaW+UkulDHJ8spUuai4yEpYjUi5VQLAU4zt48a
	8ZX0yvcjYgRNxCq3TZqO0khKVftzow4=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IOYNPqRg;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-439c6fc2910so222430f8f.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:33:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773261226; cv=none;
        d=google.com; s=arc-20240605;
        b=UJ1tsfwFVbz3u3BhNL34Tb4kb2A/OaDB7gGAaLPXQcoJufiPnjciwMGem40HnEWT+M
         NOEw32Wgioi+jiisPX9wQ7/davOY1sCiFgETD7qQ3QjH9flKQHITIOyTCekv6zuGoORu
         imWV0AQVugHgoYw2UYYRUTGD9G8caY8RTg1Ml7wi078VUPp0jvnBVDRyL7k3GThFodUc
         dqhS63bmFziuyq1RIWew8Ji6bUnQ6tHkzZhPfchaSRJYmF79Efu4K9lB4iGxW+7B5gF5
         HximibfB0TMc61/aBsZIVaTZ/bHCUvP498Ufq8/Vs2YFPC9xKTde3D/VeY1GWoTwuVic
         R7DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YHI7l1WCAEY4m4EuY554pKNgGWPa5e1fuqNEJbOzcgo=;
        fh=1GAofrGfVf9wnWGBpPWSUAfS47zOPC+fjqSPeCDmpjA=;
        b=LbEYAPuaGiMdFKAlpEw8TKtBaqLiP661+nKSAYAYchi7fE/PSkZAZhPZSMIE8mFjFH
         Mqiww685onBgXLimsfzE8citg50y/nUYGXs9jecv69SFsU+Jgrb3r2dJfRXPARKCZUiW
         AyPbU5I5tZuhfPD4MCGrIbz+yeLct1DRu4MTNvbQadnzB+bhGc9UPPrqfZOKavN8nYpR
         KKPitwt++lTTaoQsnDUkkzRjEGZpokQgapV7ObWfbK/EZoXaMNL+yxGe+L6l8XQ9MMk7
         6l1vnwCWYiHVLYabNnusHJaFWz/3xdK3+gkAnGfms0tOxg5zEFaLQN8ewBVfreU+r2kJ
         GavQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773261226; x=1773866026; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YHI7l1WCAEY4m4EuY554pKNgGWPa5e1fuqNEJbOzcgo=;
        b=IOYNPqRgE0u6SYXa6x5KZXj1wuloR7vfi0dHk0wzcKjae25UhehM2TCNheKy07Kcu/
         tj5KqcNpfi3w6MAx838C4EYLlq6F6qd5ONj/vgQYfCrBUYxXLIawVgDF3FTEf0UqXIlT
         YZRCKA19KmqpLynW7JaDGfhu67IxsoiswYWEqUmjYJYRSP3ppj/OXqOFZUXWxHhsMNu8
         55Qawg1e6CtVpqGSDhgiYFaJ0PFDAPaM2UzgQmO6HdImGypby2fCT1deJmNqbm+4E8Ya
         Bg/ZOis45WjLEvB67oRCGTZJttxgleIqtbbcm+bDBXAMNekv2tG0FESvNCs9LXD50176
         /81w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773261226; x=1773866026;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YHI7l1WCAEY4m4EuY554pKNgGWPa5e1fuqNEJbOzcgo=;
        b=o4q4btn94N+s0IrRFyAxLpUO8V5iJPYFA/XFJrGiUiXOuBYkmgdafCv+1FS+PhFmt0
         NSBIC91qQcxF7tey9o7lg9pxgzod1GbK99lqsoMfN9pqbpkSVTG2RDPi1vVkgsQcSwY+
         vGx/QAmxFUF0QzBY1kPOH4visV1JG30jmvf/hlEOS5TWwgJA73wG2EHg33oam/+N285l
         bei3T2hezNb6gcQ99Ck4MisKrfZR5s+KCPm5szhCP8RpDmRivIuf6y6ftNSm9ZPP9Yhh
         iirqznxpw38AlXgsaGxPq4CEhCB+qjUgF+RYUiDv/ssf5ieDWQ/bjqVRyV2/IbhJojFx
         f1iQ==
X-Forwarded-Encrypted: i=1; AJvYcCVi5KEbTVyDupqWGI9cHfyD3qEipbE7aF0zAq15ylz6aR1GAweTYwQKV+FfCAG9s/MWnxz7k7KtSA==@kvack.org
X-Gm-Message-State: AOJu0YzoQkd4J94lKM5Aach6TNxTBR/YW9XfsQAHos5DjNpB01Q1PAuQ
	z6zy7r8em912PTiXsfe11eDQcrLZ5O8UnumCJc6i9+BLDnN1Fn78cX4akkiWkQSwfrBhtPQhsZS
	JUrRks9etRXC5tuxmY6yjQmoeYlUeSQk=
X-Gm-Gg: ATEYQzyxSE+K690dv1YWjNft2PTyaQGyKMxO4y5TmioSivTf9t6GBoKpq8gazfMRlL1
	gxNjuk0sUunvDZilqz7jdJhfvmkfuvQ4qTmsfHMxUNUzUkeIok25O2cqMCyEcGZazGwgWdDshyy
	rqSvshSSdVGMINLt6UcPTk+S/spIan89XxiVMQ9OOC3/uFlxZG5pmkDS0Fj84lRtqIJmarN9EUa
	gxZ2yd84Wzs3iovAu9Av/6UcmIyL1kk5FVnBEmCjK7/SjARW28xyvMp7FVL1EA7H6sSxEafW/0p
	FSvPeEAuqZZ78vCF7akNZr+oBsEPLPTpqJPERQk=
X-Received: by 2002:a05:6000:2c03:b0:439:b539:787 with SMTP id
 ffacd0b85a97d-439f843cc76mr7457063f8f.53.1773261226227; Wed, 11 Mar 2026
 13:33:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com> <20260311195153.4013476-9-joshua.hahnjy@gmail.com>
In-Reply-To: <20260311195153.4013476-9-joshua.hahnjy@gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 11 Mar 2026 13:33:34 -0700
X-Gm-Features: AaiRm50IIEY3RVV7LzpuXvXj-0-MT8KAtiVfjsqVQKB09RLupSJJBknv2VPETzs
Message-ID: <CAKEwX=OySmc1SnnzYBjL7vn4o9bf2BiSzUUHtx+6hpU4oCu93Q@mail.gmail.com>
Subject: Re: [PATCH 08/11] mm/memcontrol: Track MEMCG_ZSWAPPED in bytes
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Nhat Pham <hoangnhat.pham@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: sbmqo9gfpmj1sxizdsxijcn58xot8t88
X-Rspam-User: 
X-Rspamd-Queue-Id: 01E8480012
X-Rspamd-Server: rspam12
X-HE-Tag: 1773261227-105866
X-HE-Meta: U2FsdGVkX1/sEZ5+r6OGZLXW1s0BRnm3d5/nlgBsqIPFuCdHXVf7i6+0nKpgnEGKv0rvCMP02twDI7ZG3HQWJB2bvlVVQw8ZpTdN/S2GBYPaVh2lHI4/HudRBG2T9+6uQZxBqYIXkjQ3bC9hOH+E2DwhVMaeEJMtWVVBNeYLO2ORQgfnvnkKDWkp98tB/eIb9I6SqUuKuNgichFRh3J0fdcJl516CdFAhICbADmSPFys/GCOY5lerPvlJVQisztzguuABLs3/EloTjWxwR6ajKLMsBkZnC/ASfNC+Ey9GVhekBk0hncKPl1FoPb2AMJnrMzSV2vsaw68x6OETz86UJxQCyEzMUhbnsHL6NXyAHRIc65P8fxzzNlbjlGXfcsKDbOeF7BdWL0U5Fu05VPyQ//9VTjalyfxdBMDVe4ZK4BhSEDrneiO3mmR410KPhRppwmW0DfCNnMSW9ygYNN6niLDXeAGc9K1WMPo2x/OjO8dLMIB0IfAysK7RYSGyE+Nxb+XH1VInVraxpQukkrOi6OlGjdTtvWE6Nd3hJk9LzdqPLQeORSJl1M08WvaxC4nINX3OnqTca6QRJJq4BMeJkn7jWEdLEDBVSEIKXck61MFUZEUg2pmqqyvgTweM3AMmSWylSTm1OC4cOESxZWo0l4ycRtq+Jsrlyf1BtkThqHQOwCHZPD0djQ7C+QFNC/ypnTL1qhWw01TXQV1vRoudKIJ+a5+cvnTnQPFrHPpa7+VQNVLpDFVFLeC0H1tRTli633uBG7DbD9uizklQYEwSuvl3OLJL70qTXwoq4QXJNVcc3BoZsbtto1KjLkPZ7pDviXfgdXeUXpWZJUKuAqyIS5ANeCUy6Lf0PnDowLtG91EXk4FXC6MpoBqTlWurnzIUZbMq83S1aqaqud7j/daEfDQYOC0IUYTECYHuQ3h3k7mW0GskZ3okRpW7nOanGDjzpek4UzoTgeAux7Tath
 fAH1GTjA
 c+sv7SOu+aYvbBSOi0AeZ3MDmoJRO6S5Fo+MRF/uov+/fSnP/7o6vIlTSEAZH3cYBf+2uaQNyTTnwQCaxx/IWsZKmWdc6SOpceq5JOx/gNdNOSpYMMTD2hKz+Me310LRiQ9ZjBEQX5FoxbpLPzNsrTXREspnJnJThuY/439utrz/KJxHDlnpsB8P0qAi+cv5MDORv88gujRqBKtBuaAWv2s+luQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 12:52=E2=80=AFPM Joshua Hahn <joshua.hahnjy@gmail.c=
om> wrote:
>
> Zswap compresses and uncompresses in PAGE_SIZE units, which simplifies
> the accounting for how much memory it has compressed. However, when a
> compressed object is stored at the boundary of two zspages, accounting
> at a PAGE_SIZE granularity makes it difficult to fractionally charge
> each backing zspage with the ratio of memory it backs for the
> compressed object.
>
> To make sub-PAGE_SIZE granularity charging possible for MEMCG_ZSWAPPED,
> track the value in bytes and adjust its accounting accordingly.
>
> No functional changes intended.
>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

LGTM.
Reviewed-by: Nhat Pham <nphamcs@gmail.com>

> ---
>  include/linux/memcontrol.h | 2 +-
>  mm/memcontrol.c            | 5 +++--
>  mm/zsmalloc.c              | 4 ++--
>  mm/zswap.c                 | 8 +++++---
>  4 files changed, 11 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 701d9ab6fef1..ce2e598b5963 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -38,7 +38,7 @@ enum memcg_stat_item {
>         MEMCG_VMALLOC,
>         MEMCG_KMEM,
>         MEMCG_ZSWAP_B,
> -       MEMCG_ZSWAPPED,
> +       MEMCG_ZSWAPPED_B,
>         MEMCG_NR_STAT,
>  };
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 68139be66a4f..1cb02d2febe8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -342,7 +342,7 @@ static const unsigned int memcg_stat_items[] =3D {
>         MEMCG_VMALLOC,
>         MEMCG_KMEM,
>         MEMCG_ZSWAP_B,
> -       MEMCG_ZSWAPPED,
> +       MEMCG_ZSWAPPED_B,
>  };
>
>  #define NR_MEMCG_NODE_STAT_ITEMS ARRAY_SIZE(memcg_node_stat_items)
> @@ -1364,7 +1364,7 @@ static const struct memory_stat memory_stats[] =3D =
{
>         { "shmem",                      NR_SHMEM                        }=
,
>  #ifdef CONFIG_ZSWAP
>         { "zswap",                      MEMCG_ZSWAP_B                   }=
,
> -       { "zswapped",                   MEMCG_ZSWAPPED                  }=
,
> +       { "zswapped",                   MEMCG_ZSWAPPED_B                }=
,
>  #endif
>         { "file_mapped",                NR_FILE_MAPPED                  }=
,
>         { "file_dirty",                 NR_FILE_DIRTY                   }=
,
> @@ -1412,6 +1412,7 @@ static int memcg_page_state_unit(int item)
>         switch (item) {
>         case MEMCG_PERCPU_B:
>         case MEMCG_ZSWAP_B:
> +       case MEMCG_ZSWAPPED_B:
>         case NR_SLAB_RECLAIMABLE_B:
>         case NR_SLAB_UNRECLAIMABLE_B:
>                 return 1;
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 291194572a09..24665d7cd4a9 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -1047,7 +1047,7 @@ static void zs_charge_objcg(struct zs_pool *pool, s=
truct obj_cgroup *objcg,
>         rcu_read_lock();
>         memcg =3D obj_cgroup_memcg(objcg);
>         mod_memcg_state(memcg, pool->compressed_stat, size);
> -       mod_memcg_state(memcg, pool->uncompressed_stat, 1);
> +       mod_memcg_state(memcg, pool->uncompressed_stat, PAGE_SIZE);
>         rcu_read_unlock();
>  }
>
> @@ -1066,7 +1066,7 @@ static void zs_uncharge_objcg(struct zs_pool *pool,=
 struct obj_cgroup *objcg,
>         rcu_read_lock();
>         memcg =3D obj_cgroup_memcg(objcg);
>         mod_memcg_state(memcg, pool->compressed_stat, -size);
> -       mod_memcg_state(memcg, pool->uncompressed_stat, -1);
> +       mod_memcg_state(memcg, pool->uncompressed_stat, -(int)PAGE_SIZE);

nit: seems a bit awkward lol?

