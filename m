Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94F29CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 14:44:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6715C8E0013; Wed, 12 Nov 2025 09:44:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 622268E0011; Wed, 12 Nov 2025 09:44:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 510DE8E0013; Wed, 12 Nov 2025 09:44:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 358558E0011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:44:38 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C6ECB14054B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:44:37 +0000 (UTC)
X-FDA: 84102226194.11.8CF10FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E39F6160002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:44:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H8bwPHKz;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762958675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DEFnKDHex8WFCM7aD9FZm9uwSSojc0gX2FNEbNrmLwU=;
	b=ynd07eNrUX2WSNo1TRdtEE992eGGF58RGhdLDcRnD8ae0BCGmBy1VU+8B82u2SxQbiXnNY
	K7AgYW3IAz/Z1SeTqA7kzoow4kRugqiljal0klniqP+VXx8F4Y6q4YOI/z0EzvFDSS4oaW
	0/VZefoA+7QzfmT7cIp4ppMfnLU1zbk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H8bwPHKz;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762958675; a=rsa-sha256;
	cv=none;
	b=I9kvNLCReaUmay9ikddTk+Rs+3AShaliyb0pUcwU23EQItuOTMOhARxl3IFhRBl3cav5gE
	dh2P8QxO77UH8H5QMGxsrMxiTb5JLtzP+r11xDRh5DK7h/Sxgnftqbm24vJf6RF/vyjyHh
	6etUhXfmO4VYm+d64hSAN+jvkW82P5Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 47CC460219
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF27C19422
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762958675;
	bh=PDnwftZCtKItMvQXS6vPJzVdQydGaJntJOyOabcBAHo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=H8bwPHKzfUN/JGbVuzz/f9oALQIK1EG8jgmga7Gfpp8GN7QKqeRQdz2nb5K4L3VRm
	 FTsh5wlzH5cXeJncoRa+Uz9thGZrOImi59EyQOM/HahHKrPiPssJ7EFiwgM/1AMRUg
	 tbU3tKT2e/eI2CLvsyAxMMDSJ6sOBCo8YJkEEN51dbRh4V/rIcRn9aW90R1fA5kx0r
	 n0HNJzKGOdv/tTSl/SlTdzHBBPflTK01Pz1ZkL9q/tqAM5syvCgyvVeSi7XmSQNJ2c
	 QaF0Uaef/CZ7RvrZ5Upg9W57/QXRNMALTEwH4uzuVomm5jCTzLa2NclB2klTT2NKam
	 fLmPOm8oQ+0aA==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-7866c61a9bbso8100077b3.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 06:44:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUDzwfApvgQE5cwLf7RodsmK+QyS2AcXKsdz0U8lfngvijGtEiAKI6QD7v2zPmw6lXe8DtXPrcLYA==@kvack.org
X-Gm-Message-State: AOJu0Yznxhdf9KKjrz9sC4ISSagybAFEn4bYaMqSfDU3XTIKV/7uaTi1
	UwGrRApj9RjxwunItmo3sR71JuTYbryGpJTpvnK1YUvsrgPwU6S69Vu7AlCkSQBWiy/sOElT1sq
	3BbZaH7THCkOzEx188+5WNt9XAZp1v9ogFjjgoXRikg==
X-Google-Smtp-Source: AGHT+IG5JeTs0/2jzgHnGQg6hAHz8vnJj97AKy982sF7acTacZdbTAFqicgdDUf8Z5OFDVpjMi1dXerlN4/1YJlDLLQ=
X-Received: by 2002:a05:690c:6805:b0:786:9be4:749c with SMTP id
 00721157ae682-78813666b4fmr29760027b3.31.1762958674170; Wed, 12 Nov 2025
 06:44:34 -0800 (PST)
MIME-Version: 1.0
References: <20251109124947.1101520-1-youngjun.park@lge.com> <20251109124947.1101520-4-youngjun.park@lge.com>
In-Reply-To: <20251109124947.1101520-4-youngjun.park@lge.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 12 Nov 2025 06:44:23 -0800
X-Gmail-Original-Message-ID: <CACePvbU+NviPmpXQAJUrY4rTqmY_rvYy2JvDBAfT290GmQmfZg@mail.gmail.com>
X-Gm-Features: AWmQ_bn2uFL5WDija3FNTBnu9eTA0Dq7KEi83tdS-oW7tHAdZkh7qgGbpcQOn8o
Message-ID: <CACePvbU+NviPmpXQAJUrY4rTqmY_rvYy2JvDBAfT290GmQmfZg@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm/swap: integrate swap tier infrastructure into swap subsystem
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasong@tencent.com, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E39F6160002
X-Stat-Signature: 3o3ywfz3gtjdhsa4k6nxmj1r581ekpe6
X-Rspam-User: 
X-HE-Tag: 1762958675-466099
X-HE-Meta: U2FsdGVkX1/ke96UQd62VVQfufNh/iAhb9U6ceRJNnnSwQWKpVS+P1ru2FZRO/8JlMYzygcaH9EfjHSOFV1bJXaEGI8nGMdMjI5mO+SFRAjSS93yV/Un5aTy9E5aTZbPT0T/ly77px0y0h0JE30w1+/IDDPrW1KK8nMASFpWO/jj5ZT5/btMh1gXm9V6yADPbx9emuUyib+45OuPDamHT/X+txcNHAaaF1M7sPXak7uY8rFkCQWHxfCrXumr8Ulhv4XFzFB3sB0mzJwynOBBLNC1n4t2ScJWi7hprUCgacVZN3zq1MF3P+E182658DYIBMGFcj/2XJmaogcUEm9NpZrINJwZYlitqDBhOm6yzOP1qS/XJQS4QL3VMLxLS6ta4g6rCEU5FoDHDUyyDiViAm9glCRnijujwwVRiBytCiM9BSUj/EAzKho5P8qmZLqn6R9tDxJNWcimwGs/Qy2OnJIer2o4hyjBMqvzXGvPUsGLGPIpPpUWnTN6KJcKt0UKuTxP334FOKI2Qf2RAdbX/fhLbGpb4Bel7ImCAM0zVIfAtINOaEMsqGvIfFHtJsG9m/tOE2Dnv5hhTbuLf4V3/mQmpzDTas+Rz6yruQa81UTf18AfZ2cq9buK+2J++fzxAOa/VRaLHjO0XQnblT4RLDLPSKrr53NpAOPW4iZkQgmJjeM5Hovyg5algInXQo8pqu1MyStTk3zp6GAuEJRwkdlknk65girDJiwDbXTDsrwhGB7SUaWP9G9OaBr5NpbEcvqfnayIe3ClihpVpNH/j19FOhKivPDcklqcrb6x77xBY+6RPD/lIjbKKE9BKbhHfv+48vOskEk1/1vqUQqA71lMLgE50+VAm5bn8W/SjjNEcBsosZHnywuhvxTKa0XGCSOhs9sD9am5vm+xZcIngBwuDLaUKTIrSfvMqIiR8MNFn2zW0LA7JR3x7Jx0714QJFiesvwkwW1GClJC+dA
 GcFXw2hO
 6wH8qxUIfAgg4nxBGIzzqgw98O+O7IdKc1U5G7pl3CJ04VGHXdFe0V6Re9KaBdLDD7dJpAJBSJUQ8Zt1apMmp0KuA6MoSP7cCoAOIj/KccDI5fzFDTM/X6m97uE+dS9ggm6sN0IsA82y0GY/qp+gLAnImLdEQUJ4I8newE/KBQDEqoFHkKedYt2dJoCLaO99pF7f7C/Xn+9GdJLicZ69xuUkoQxxLV6pGl+lE0sVQAdNtuXChsn2xGK/fd/3wulThAj1pjQZv8qLEalvE7nsH3p3CiBX3oBgPlOk/U5xHymQkM6d75y68EcSJ/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It seems you should introduce the tiers first. Allow users to define tiers.
Then the follow up patches use tiers defined here.

The patch order seems reversed to me.

See some feedback below, to be continued.

Chhris


On Sun, Nov 9, 2025 at 4:50=E2=80=AFAM Youngjun Park <youngjun.park@lge.com=
> wrote:
>
> Integrate the swap tier infrastructure into the existing swap subsystem
> to enable selective swap device usage based on tier configuration.
>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/memcontrol.c | 69 ++++++++++++++++++++++++++++++++++++
>  mm/page_io.c    | 21 ++++++++++-
>  mm/swap_state.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++++
>  mm/swapfile.c   | 15 ++++++--
>  4 files changed, 194 insertions(+), 4 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bfc986da3289..33c7cc069754 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -68,6 +68,7 @@
>  #include <net/ip.h>
>  #include "slab.h"
>  #include "memcontrol-v1.h"
> +#include "swap_tier.h"
>
>  #include <linux/uaccess.h>
>
> @@ -3730,6 +3731,7 @@ static void mem_cgroup_free(struct mem_cgroup *memc=
g)
>  {
>         lru_gen_exit_memcg(memcg);
>         memcg_wb_domain_exit(memcg);
> +       swap_tiers_put_mask(memcg);
>         __mem_cgroup_free(memcg);
>  }
>
> @@ -3842,6 +3844,11 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *p=
arent_css)
>                 page_counter_init(&memcg->kmem, &parent->kmem, false);
>                 page_counter_init(&memcg->tcpmem, &parent->tcpmem, false)=
;
>  #endif
> +#ifdef CONFIG_SWAP_TIER
> +               memcg->tiers_mask =3D 0;
> +               memcg->tiers_onoff =3D 0;
> +#endif
> +
>         } else {
>                 init_memcg_stats();
>                 init_memcg_events();
> @@ -3850,6 +3857,10 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *p=
arent_css)
>  #ifdef CONFIG_MEMCG_V1
>                 page_counter_init(&memcg->kmem, NULL, false);
>                 page_counter_init(&memcg->tcpmem, NULL, false);
> +#endif
> +#ifdef CONFIG_SWAP_TIER
Again, don't need this config.

> +               memcg->tiers_mask =3D DEFAULT_FULL_MASK;

Is this  memcg->tiers_mask a cached value after evaluating the
swap.tiers onoff list by looking up the parent?

I was thinking of starting with always evaluating the tiers_mask. Then
we don't need to store it here. How do you indicate the tiers_mask is
out of date?

> +               memcg->tiers_onoff =3D DEFAULT_ON_MASK;
>  #endif
>                 root_mem_cgroup =3D memcg;
>                 return &memcg->css;
> @@ -5390,6 +5401,56 @@ static int swap_events_show(struct seq_file *m, vo=
id *v)
>         return 0;
>  }
>
> +#ifdef CONFIG_SWAP_TIER
> +static int swap_tier_show(struct seq_file *m, void *v)
> +{
> +       struct mem_cgroup *memcg =3D mem_cgroup_from_seq(m);
> +
> +       swap_tiers_show_memcg(m, memcg);
> +       return 0;
> +}
> +
> +static ssize_t swap_tier_write(struct kernfs_open_file *of,
> +                               char *buf, size_t nbytes, loff_t off)
> +{
> +       struct mem_cgroup *memcg =3D mem_cgroup_from_css(of_css(of));
> +       struct tiers_desc desc[MAX_SWAPTIER] =3D {};
> +       char *pos =3D buf, *token;
> +       int nr =3D 0;
> +       int ret;
> +
> +       while ((token =3D strsep(&pos, " \t\n")) !=3D NULL) {

Not allowing plain space " "? Compare pointer !=3D NULL is redundant.

> +               if (!*token)
> +                       continue;
> +
> +               if (nr >=3D MAX_SWAPTIER)
> +                       return -E2BIG;
> +
> +               if (token[0] !=3D '+' && token[0] !=3D '-')
> +                       return -EINVAL;
> +
> +               desc[nr].ops =3D (token[0] =3D=3D '+') ? TIER_ON_MASK : T=
IER_OFF_MASK;
> +
> +               if (strlen(token) <=3D 1) {
> +                       strscpy(desc[nr].name, DEFAULT_TIER_NAME);
> +                       nr++;
> +                       continue;
> +               }
> +
> +               if (strscpy(desc[nr].name, token + 1, MAX_TIERNAME) < 0)
> +                       return -EINVAL;
> +
> +               nr++;
I don't think you need this nr, you will reach to the end of the
string any way. What if the user specifies the same tier more than
once? It is not optimal but the kernel should take it.

OK, I see what is going on now, this whole desc thing can be greatly
simplified. You shouldn't need to maintain the desc[nr], that desc
array is the onoff mask in my mind. You just need to keep the tier
bits in order.

Notice in the memory.swap.tiers. Except for the default tier pattern,
which always the first one if exists. The rest of the tier + - order
does not matter. You look up the tier name into the tier mask bit.
Just set the onoff bits for that tier.

> +       }
> +
> +       ret =3D swap_tiers_get_mask(desc, nr, memcg);
> +       if (ret)
> +               return ret;
> +
> +       return nbytes;
> +}
> +#endif
> +
>  static struct cftype swap_files[] =3D {
>         {
>                 .name =3D "swap.current",
> @@ -5422,6 +5483,14 @@ static struct cftype swap_files[] =3D {
>                 .file_offset =3D offsetof(struct mem_cgroup, swap_events_=
file),
>                 .seq_show =3D swap_events_show,
>         },
> +#ifdef CONFIG_SWAP_TIER
> +       {
> +               .name =3D "swap.tiers",
> +               .flags =3D CFTYPE_NOT_ON_ROOT,
> +               .seq_show =3D swap_tier_show,
> +               .write =3D swap_tier_write,
> +       },
> +#endif
>         { }     /* terminate */
>  };
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 3c342db77ce3..2b3b1154a169 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -26,6 +26,7 @@
>  #include <linux/delayacct.h>
>  #include <linux/zswap.h>
>  #include "swap.h"
> +#include "swap_tier.h"
>
>  static void __end_swap_bio_write(struct bio *bio)
>  {
> @@ -233,6 +234,24 @@ static void swap_zeromap_folio_clear(struct folio *f=
olio)
>         }
>  }
>
> +#if defined(CONFIG_SWAP_TIER) && defined(CONFIG_ZSWAP)
> +static bool folio_swap_tier_zswap_test_off(struct folio *folio)
> +{
> +       struct mem_cgroup *memcg;
> +
> +       memcg =3D folio_memcg(folio);
> +       if (memcg)
> +               return swap_tier_test_off(memcg->tiers_mask,
> +                       TIER_MASK(SWAP_TIER_ZSWAP, TIER_ON_MASK));
> +
> +       return false;
> +}
> +#else
> +static bool folio_swap_tier_zswap_test_off(struct folio *folio)
> +{
> +       return false;
> +}
> +#endif
>  /*
>   * We may have stale swap cache pages in memory: notice
>   * them here and get rid of the unnecessary final write.
> @@ -272,7 +291,7 @@ int swap_writeout(struct folio *folio, struct swap_io=
cb **swap_plug)
>          */
>         swap_zeromap_folio_clear(folio);
>
> -       if (zswap_store(folio)) {
> +       if (folio_swap_tier_zswap_test_off(folio) || zswap_store(folio)) =
{
>                 count_mthp_stat(folio_order(folio), MTHP_STAT_ZSWPOUT);
>                 goto out_unlock;
>         }
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 3f85a1c4cfd9..2e5f65ff2479 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -25,6 +25,7 @@
>  #include "internal.h"
>  #include "swap_table.h"
>  #include "swap.h"
> +#include "swap_tier.h"
>
>  /*
>   * swapper_space is a fiction, retained to simplify the path through
> @@ -836,8 +837,100 @@ static ssize_t vma_ra_enabled_store(struct kobject =
*kobj,
>  }
>  static struct kobj_attribute vma_ra_enabled_attr =3D __ATTR_RW(vma_ra_en=
abled);
>
> +#ifdef CONFIG_SWAP_TIER
> +static ssize_t tiers_show(struct kobject *kobj,
> +                                    struct kobj_attribute *attr, char *b=
uf)
> +{
> +       return swap_tiers_show_sysfs(buf);
> +}
> +
> +static ssize_t tiers_store(struct kobject *kobj,
> +                               struct kobj_attribute *attr,
> +                               const char *buf, size_t count)
> +{
> +       struct tiers_desc desc[MAX_SWAPTIER] =3D {};
> +       int nr =3D 0;
> +       char *data, *p, *token;
> +       int ret =3D 0;
> +       bool is_add =3D true;
> +
> +       if (!count)
> +               return -EINVAL;
> +
> +       data =3D kmemdup_nul(buf, count, GFP_KERNEL);
> +       if (!data)
> +               return -ENOMEM;
> +
> +       p =3D data;
> +
> +       if (*p =3D=3D '+')
> +               p++;
> +       else if (*p =3D=3D '-') {
> +               is_add =3D false;
> +               p++;
> +       } else
> +               return -EINVAL;
> +
> +       while ((token =3D strsep(&p, ", \t\n")) !=3D NULL) {
> +               if (!*token)
> +                       continue;
> +
> +               if (nr >=3D MAX_SWAPTIER) {
> +                       ret =3D -E2BIG;
> +                       goto out;
> +               }
> +
> +               if (is_add) {
> +                       char *name, *prio_str;
> +                       int prio;
> +
> +                       name =3D strsep(&token, ":");
> +                       prio_str =3D token;
> +
> +                       if (!name || !prio_str || !*name || !*prio_str) {
> +                               ret =3D -EINVAL;
> +                               goto out;
> +                       }
> +
> +                       if (strscpy(desc[nr].name, name, MAX_TIERNAME) < =
0) {
> +                               ret =3D -EINVAL;
> +                               goto out;
> +                       }
> +
> +                       if (kstrtoint(prio_str, 10, &prio)) {
> +                               ret =3D -EINVAL;
> +                               goto out;
> +                       }
> +
> +                       desc[nr].prio_st =3D prio;
> +               } else {
> +                       if (strscpy(desc[nr].name, token, MAX_TIERNAME) <=
 0) {
> +                               ret =3D -EINVAL;
> +                               goto out;
> +                       }
> +                       desc[nr].prio_st =3D 0;
> +               }
> +               nr++;
> +       }
> +
> +       if (is_add)
> +               ret =3D swap_tiers_add(desc, nr);
> +       else
> +               ret =3D swap_tiers_remove(desc, nr);
> +
> +out:
> +       kfree(data);
> +       return ret ? ret : count;
> +}
> +
> +static struct kobj_attribute tier_attr =3D __ATTR_RW(tiers);
> +#endif
> +
>  static struct attribute *swap_attrs[] =3D {
>         &vma_ra_enabled_attr.attr,
> +#ifdef CONFIG_SWAP_TIER
> +       &tier_attr.attr,
> +#endif
>         NULL,
>  };
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index a5c90e419ff3..8715a2d94140 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -49,6 +49,7 @@
>  #include "swap_table.h"
>  #include "internal.h"
>  #include "swap.h"
> +#include "swap_tier.h"
>
>  static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
>                                  unsigned char);
> @@ -1296,7 +1297,8 @@ static bool get_swap_device_info(struct swap_info_s=
truct *si)
>
>  /* Rotate the device and switch to a new cluster */
>  static void swap_alloc_entry(swp_entry_t *entry,
> -                           int order)
> +                           int order,
> +                           int mask)
>  {
>         unsigned long offset;
>         struct swap_info_struct *si, *next;
> @@ -1304,6 +1306,8 @@ static void swap_alloc_entry(swp_entry_t *entry,
>         spin_lock(&swap_avail_lock);
>  start_over:
>         plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list)=
 {
> +               if (swap_tiers_test_off(si->tier_idx, mask))
> +                       continue;
>                 /* Rotate the device and switch to a new cluster */
>                 plist_requeue(&si->avail_list, &swap_avail_head);
>                 spin_unlock(&swap_avail_lock);
> @@ -1376,6 +1380,7 @@ int folio_alloc_swap(struct folio *folio)
>  {
>         unsigned int order =3D folio_order(folio);
>         unsigned int size =3D 1 << order;
> +       int mask;
>         swp_entry_t entry =3D {};
>
>         VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
> @@ -1400,8 +1405,8 @@ int folio_alloc_swap(struct folio *folio)
>         }
>
>  again:
> -       swap_alloc_entry(&entry, order);
> -
> +       mask =3D swap_tiers_collect_compare_mask(folio_memcg(folio));
> +       swap_alloc_entry(&entry, order, mask);
>         if (unlikely(!order && !entry.val)) {
>                 if (swap_sync_discard())
>                         goto again;
> @@ -2673,6 +2678,8 @@ static void _enable_swap_info(struct swap_info_stru=
ct *si)
>
>         /* Add back to available list */
>         add_to_avail_list(si, true);
> +
> +       swap_tiers_assign(si);
>  }
>
>  static void enable_swap_info(struct swap_info_struct *si, int prio,
> @@ -2840,6 +2847,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         spin_lock(&swap_lock);
>         spin_lock(&p->lock);
>         drain_mmlist();
> +       swap_tiers_release(p);
>
>         swap_file =3D p->swap_file;
>         p->swap_file =3D NULL;
> @@ -4004,6 +4012,7 @@ static int __init swapfile_init(void)
>                 swap_migration_ad_supported =3D true;
>  #endif /* CONFIG_MIGRATION */
>
> +       swap_tiers_init();
>         return 0;
>  }
>  subsys_initcall(swapfile_init);
> --
> 2.34.1
>
>

