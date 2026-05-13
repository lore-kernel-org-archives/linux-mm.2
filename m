Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02CC8CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 11:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5579B6B0092; Wed, 13 May 2026 07:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 508766B0093; Wed, 13 May 2026 07:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CFD46B0095; Wed, 13 May 2026 07:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 265706B0092
	for <linux-mm@kvack.org>; Wed, 13 May 2026 07:50:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EE152A0880
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:50:01 +0000 (UTC)
X-FDA: 84762227802.27.1905825
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id D6B5316000A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:49:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VKn9FUn3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778673000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+eyCRfvbu7d8VrqUkRV2z/MHJa96tgDU4sif/IM1p4=;
	b=wpcXIpmsmFb207T6Op3ZLK97p0QEaFuvuQKl/6rWfYU27LMszW6kTyLCKyG5LlsVZObNQD
	jsHB+g1jdz7ePQ7eDLKlYlA7pD8KBTVCXQyocGFsp3DNAR9RZKeS+t0/V2K/4KK8QRC17c
	1C1TCEox2dm2XfMNSsXMSuXhV17gee0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778673000; a=rsa-sha256;
	cv=pass;
	b=4AKmszLtBI6cAu6D9RB7DQnZfjb1s3vnjUWldGKiCEVdBBeFpyqrHelahJ/Wj6FhifkdYL
	pOLOrGsSsvyaxiKdAGdPlhY2/KcU2ALFMj9P8ZL3mzmnBc8MzvZo+Pk2QSupBJ7qbap835
	GeXkjntcoPxH/vs3KIFZ+nFcyH8gpAE=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VKn9FUn3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-678a16429c6so10177295a12.1
        for <linux-mm@kvack.org>; Wed, 13 May 2026 04:49:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778672998; cv=none;
        d=google.com; s=arc-20240605;
        b=OG83/4uZMjzLy/CrPQn/YvaMclA41f6rXQBEsbXnHgpOPqm8eFH/+vU4Z/766HEJvg
         g5rtzUGnfOjXaqDTcLZPfnufbyHwhJtsxcZFFpIIK08ryK6Lv5SvrxMh5WGXLgmDnPGc
         hpQVVCmhpJbGQFkW2H1W2enESx9PU+LliZOGJiM4kV7YjNbMnf3rv18E6AGMdP7P41fM
         HeboCEvR10zz40AI0xjTBmmRGbztshVsxa8JKtyNgQkHGoNQMH388Bb8p41twbDXQkEY
         VXg7uEKCopZPbIaJDwyPzXnJ66HP8KUYwdpWEmE7CrZbvd5Q6OPiXDTu+HPYhWUcMw/D
         BNDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H+eyCRfvbu7d8VrqUkRV2z/MHJa96tgDU4sif/IM1p4=;
        fh=HgvzTsTje9lnNmOaG67L9WazGxXHdaNiyuLClgLUnnw=;
        b=FZlou6U5YYKk2otsXEb2SsDnoWlCTMqKAny9PQn7KKib0NPatiA9zyMlAaBVjk+znm
         Q936PCD+Yt/iptxSObN8GVAHoKCbGesr6I11B4lQc4P8qk+3mIDydB8v+8IekGa4PmlN
         mNXZKFQcL/0c3D3HXwxsc25N9XjHc60gmtAwAS2GDXj5gA39AErMsbQYCCQJwqtp3dPW
         3D4rhKrXwiVwM2HOX1bmNcecmaSHEquwp/+bsLTuhRaDeSVbT2W8yE60YJLEOjHUugpb
         985MdzSGWi0cweO0y6QIGaaipF74/3gc/hXJuzAMJCAf4dyS0xs9l13VjXq//+SdT6bt
         5+DQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778672998; x=1779277798; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H+eyCRfvbu7d8VrqUkRV2z/MHJa96tgDU4sif/IM1p4=;
        b=VKn9FUn3C42nJqfxqk7uXjyVRWrEiComRi5LiJO698qsgXOoS4xWf6Q8gfpZZQJzo/
         SoiCVI3j7QEuQf7deSDaaNzpDYigBBvdnMEaPEJyBXHonM3zu3HEsz0OdvuinFc6g3r8
         cQ6bnMmXV2FGmb6BUXzUB963HYb15qzYznDN0f+3fTFLPO/hDxpAxp9WGj+yrVKS8eyJ
         0rO1v6aFnlFpAGDnbcGV4ZCSUX+aIaiXqKIgDezan1M6LfTBOuGj3eMfc8SfAxK4f1Se
         N5t7vjLgOURfdxsFBS7Q1D9msUX1eXl178MX922xYiPLKwrSXUk3m4nQKrHkOsmfwXU4
         C+ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778672998; x=1779277798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H+eyCRfvbu7d8VrqUkRV2z/MHJa96tgDU4sif/IM1p4=;
        b=sUzt6d4P2xMhplrr+spJR63RGIqGDj3cTbjs9D0pxm+31gT1gqIoVOfHxkxdPXI27p
         cIdr3ef6pd2P1BagXOMGYykGOUagEMxytgrZFTSop+UwHscCrYDp2FDlo5Tks6STCxGR
         A5jg1yr/HUopZXJPKmHM3CapfdcTY3NiNZc1iZ5jdbog8o8C+ONiEQi6y8nmDcvJ8qJx
         xTL5s94MTPHJtvpcDkOw4pOpHUH2gc5Yno01MekUEY8CT9RvGIjeE82+32484AEAVkHo
         /gBKqxJSxF/2pAIEqHxhyRdOndTNZ/W8Oo+I7vGKp4NZV6EMgRV6GkkyV7FkRcnB2+jg
         fyqA==
X-Gm-Message-State: AOJu0YxJhcLKvwoEfbrO6pikDQcJeHzf5id84az3l10w2Iw2d/hg801K
	YIhClMdmXTfdwsaLDoDTvqFQ1zOj90Gb9R13ayw/DwpSdRkxiDj+gJpeE6A8YYR7SLU62zBlbd/
	blE+wZ/x2zEweMSPTiAgUE0y8fms69ns=
X-Gm-Gg: Acq92OEHw4i1WutiRxqQPs8BT5TwCTR4gXVja9UQogAB0t8p34Q6msms9R2E3ShTpB8
	qQPvP4nCIpccUh/biqYzTdquq4be7BpDA6Vk6NvPnXb8hWvN2LTJv8rtqqPvfPjqCAm6F2pmJVG
	jF4axu/NGj3U6XZKwpcvbH52WLc7CDroddXVY7pzDf7wXibSi9oxeM965sF7V2Gip6h0+dFeV8a
	reT1+9N7frq/jSuvQ1Qp9DLGWqtJa9UVt5MdRCVnyt+wWEurQYxjl6Y1SOnRdCyLNej5hyJ8ttE
	nMQqFH0YQyfDUGi3ghPQItNXPluygLpyhDnuWaQ=
X-Received: by 2002:a05:6402:7d0:b0:67b:7e7a:45ed with SMTP id
 4fb4d7f45d1cf-680b2b12646mr3489347a12.6.1778672997859; Wed, 13 May 2026
 04:49:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <20260421-swap-table-p4-v3-10-2f23759a76bc@tencent.com> <CACePvbXeUv9g+pKW55hrEbwrFZaZ+XdBip9oSwT7pfztrG_7GA@mail.gmail.com>
In-Reply-To: <CACePvbXeUv9g+pKW55hrEbwrFZaZ+XdBip9oSwT7pfztrG_7GA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 13 May 2026 19:49:20 +0800
X-Gm-Features: AVHnY4Ks2BUbReMA9gs5ZJ-uwNtvfeaDihycWWUgwEm25NTeZvjq8Y_AbMswWzo
Message-ID: <CAMgjq7D_W5qQfNfjJ=j+YSfaQE_f=XEOY2TphOaBtmwnJZSrfQ@mail.gmail.com>
Subject: Re: [PATCH v3 10/12] mm/memcg, swap: store cgroup id in cluster table directly
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6B5316000A
X-Stat-Signature: bqdjzh59y7a54ibowi4y6uameqtkjwaw
X-Rspam-User: 
X-HE-Tag: 1778672999-860825
X-HE-Meta: U2FsdGVkX1+wIgyPl5SNSjikt0Y+UbJqm14sBeW2VqwANY/GnTfbuX5/VgOvD3NeB7f/mN7/PWzzdj+gqRbFmXAU4Rq0kbf1x/jBq3ffkVJSJGBsaHFn04ZoUGUjlBLcc/dX8kEc0fnLC/e/wgshDQTEGZs2xOFAeJhWFPGO0DVKuhG1bRfAVu/Wx7qIP4W0E/mhMUQUqTkiVQtwOz76AUGK576W/qjBpTqeMe3ZUNm11NZ2KaUMavOr0n7NTTI4KLDe4muMJ3y8WEW3iGfveW9MweSxn1uv2Pm4H03UeG/cZnGzj9KF2ukX9gejkeV5Nrun7upuzyQh3EkItKhX/RX7V4yDBwU7cgo2ayner0ePkGmQjIT5SKUodTO3ZZKr1FavpfoUT7sfByDS+zX4pwI2qON3GhvJowIem0067EjkJePWRMwBL8ce8Ctftou1IaWgaSCQHBB3a29rJhTIUD1x7cfRmSn310FBfa4L5AswXkVkefteCgNdtmX+Ti2/aMM3JmcbwQr5e9pMGOy2T1tZTnSbvrX1Fb8VvZhO+uPL4JvyiWaOTapM0o5ap6eAb1PTpQH/NOaEODQUvN7rEk5VPMPUABbFTXuRD61vmuap2t6GQ0MDA1Ri6tbgkiCLWk4Oq0hRNIZ6Jp+dUWVF+RothvpeZdpfyf9zc3Zl4n3jJEkqqcKcxrHNoRPeF5a/rEOzggG7u4FW3hz0PvxOtIeTtF8VGbuLdbBFFku8wnMoasjmvNkpEXSwtMPnZb610Zj1Mz1TavMPfnRzev6XqMxjx7T1t243zbXFhFLJNyfTPGgb0Tnp7n03I0iau4dZGchlIUtfQaYS62450Gx9WSu0A59biDvMXGPIbhujHafRTBrEUhuiLL0nScHnvI2NG9cEViVHDZj89vXKQXAQrLhgBbZfC3ewAeeQa/9+rvzgSgI7/gyMt0l4FHUmCFofwfE//wh5A9PPY4/uwo7
 51kWQ69D
 hc1NivqbzvPdb7UIDnwUDnp7gG6oSe5wkt3LqV195E2dAYtMRG47VXb1zglF8jc6EM2CkVjBvLrc7LB2ijIuQbs7Bd9/OzThpH0UqTp1TqdJZ/KSelx3AvB3fgylPOajSEcAqv6FhotX7MyYAGUXU6ma3WmQC3J6oWIbEbxvOdB/gRChsP6C1f8528yEBWt6rnfdSBrPlp/46uPtxedqfVw/7aN8KJHiOtB5LAlDLlJpnit5mKL1CnY6ZwzjHw6HYBk2bGLrdDIe8qWcDfu2vL3+n2ZC2DJOsgUHjnKvEpCUhhDrsQISm0+JWjYkxkWtalEFi3kwete9Rd6U7tgXRoYZR74exZISw7ej40CBs2930KI0pYiqyZz4sdlmP7u/cZErytPblWyffyLuSLwVDH2T2tW6TrS1/2X8cFA3WsveoMA8IgopNXVByZytJzMNY8AMUIf8d3Smj5veDabnMPelmpGU7U4om77EL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 9, 2026 at 6:46=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> On Tue, Apr 21, 2026 at 2:16=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Drop the usage of the swap_cgroup_ctrl, and use the dynamic cluster
> > table instead.
>
> Nice! It takes so many steps to finally drop the static allocated swap
> cgroup ctrl array. Thank you for making it happen.
>
> >
> > The per-cluster memcg table is 1024 / 512 bytes on most archs, and does
> > not need RCU protection: the cgroup data is only read and written under
> > the cluster lock. That keeps things simple, lets the allocation use
> > plain kmalloc with immediate kfree (no deferred free), and keeps
> > fragmentation acceptable.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
>
> Overall looks good, with some nitpick and question follows.
>
> Acked-by: Chris Li <chrisl@kernel.org>
>
> > ---
> >  include/linux/memcontrol.h |  6 ++++--
> >  include/linux/swap.h       |  8 +++----
> >  mm/memcontrol-v1.c         | 42 +++++++++++++++++++++++-------------
> >  mm/memcontrol.c            | 14 +++++++-----
> >  mm/swap.h                  |  4 ++++
> >  mm/swap_state.c            |  6 ++----
> >  mm/swap_table.h            | 54 ++++++++++++++++++++++++++++++++++++++=
++++++++
> >  mm/swapfile.c              | 35 +++++++++++++++++++-----------
> >  mm/vmscan.c                |  2 +-
> >  9 files changed, 128 insertions(+), 43 deletions(-)
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index a013f37f24aa..bf1a6e131eca 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -29,6 +29,7 @@ struct obj_cgroup;
> >  struct page;
> >  struct mm_struct;
> >  struct kmem_cache;
> > +struct swap_cluster_info;
> >
> >  /* Cgroup-specific page state, on top of universal node page state */
> >  enum memcg_stat_item {
> > @@ -1899,7 +1900,7 @@ static inline void mem_cgroup_exit_user_fault(voi=
d)
> >         current->in_user_fault =3D 0;
> >  }
> >
> > -void __memcg1_swapout(struct folio *folio);
> > +void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *c=
i);
> >  void memcg1_swapin(struct folio *folio);
> >
> >  #else /* CONFIG_MEMCG_V1 */
> > @@ -1929,7 +1930,8 @@ static inline void mem_cgroup_exit_user_fault(voi=
d)
> >  {
> >  }
> >
> > -static inline void __memcg1_swapout(struct folio *folio)
> > +static inline void __memcg1_swapout(struct folio *folio,
> > +               struct swap_cluster_info *ci)
> >  {
> >  }
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index f2949f5844a6..57af4647d432 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -582,12 +582,12 @@ static inline int mem_cgroup_try_charge_swap(stru=
ct folio *folio)
> >         return __mem_cgroup_try_charge_swap(folio);
> >  }
> >
> > -extern void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int=
 nr_pages);
> > -static inline void mem_cgroup_uncharge_swap(swp_entry_t entry, unsigne=
d int nr_pages)
> > +extern void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int=
 nr_pages);
> > +static inline void mem_cgroup_uncharge_swap(unsigned short id, unsigne=
d int nr_pages)
> >  {
> >         if (mem_cgroup_disabled())
> >                 return;
> > -       __mem_cgroup_uncharge_swap(entry, nr_pages);
> > +       __mem_cgroup_uncharge_swap(id, nr_pages);
> >  }
> >
> >  extern long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg);
> > @@ -598,7 +598,7 @@ static inline int mem_cgroup_try_charge_swap(struct=
 folio *folio)
> >         return 0;
> >  }
> >
> > -static inline void mem_cgroup_uncharge_swap(swp_entry_t entry,
> > +static inline void mem_cgroup_uncharge_swap(unsigned short id,
> >                                             unsigned int nr_pages)
> >  {
> >  }
> > diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> > index 36c507d81dc5..494e7b9adc60 100644
> > --- a/mm/memcontrol-v1.c
> > +++ b/mm/memcontrol-v1.c
> > @@ -14,6 +14,7 @@
> >
> >  #include "internal.h"
> >  #include "swap.h"
> > +#include "swap_table.h"
> >  #include "memcontrol-v1.h"
> >
> >  /*
> > @@ -606,14 +607,15 @@ void memcg1_commit_charge(struct folio *folio, st=
ruct mem_cgroup *memcg)
> >  /**
> >   * __memcg1_swapout - transfer a memsw charge to swap
> >   * @folio: folio whose memsw charge to transfer
> > + * @ci: the locked swap cluster holding the swap entries
> >   *
> >   * Transfer the memsw charge of @folio to the swap entry stored in
> >   * folio->swap.
> >   *
> > - * Context: folio must be isolated, unmapped, locked and is just about
> > - * to be freed, and caller must disable IRQs.
> > + * Context: folio must be isolated, unmapped, locked and is just about=
 to
> > + * be freed, and caller must disable IRQs and hold the swap cluster lo=
ck.
> >   */
> > -void __memcg1_swapout(struct folio *folio)
> > +void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *c=
i)
> >  {
> >         struct mem_cgroup *memcg, *swap_memcg;
> >         struct obj_cgroup *objcg;
> > @@ -646,7 +648,8 @@ void __memcg1_swapout(struct folio *folio)
> >         swap_memcg =3D mem_cgroup_private_id_get_online(memcg, nr_entri=
es);
> >         mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
> >
> > -       swap_cgroup_record(folio, mem_cgroup_private_id(swap_memcg), fo=
lio->swap);
> > +       __swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entri=
es,
> > +                         mem_cgroup_private_id(swap_memcg));
> >
> >         folio_unqueue_deferred_split(folio);
> >         folio->memcg_data =3D 0;
> > @@ -661,8 +664,7 @@ void __memcg1_swapout(struct folio *folio)
> >         }
> >
> >         /*
> > -        * Interrupts should be disabled here because the caller holds =
the
> > -        * i_pages lock which is taken with interrupts-off. It is
> > +        * The caller must hold the swap cluster lock with IRQ off. It =
is
> >          * important here to have the interrupts disabled because it is=
 the
> >          * only synchronisation we have for updating the per-CPU variab=
les.
> >          */
> > @@ -677,7 +679,7 @@ void __memcg1_swapout(struct folio *folio)
> >  }
> >
> >  /**
> > - * memcg1_swapin - uncharge swap slot
> > + * memcg1_swapin - uncharge swap slot on swapin
> >   * @folio: folio being swapped in
> >   *
> >   * Call this function after successfully adding the charged
> > @@ -687,6 +689,10 @@ void __memcg1_swapout(struct folio *folio)
> >   */
> >  void memcg1_swapin(struct folio *folio)
> >  {
> > +       struct swap_cluster_info *ci;
> > +       unsigned long nr_pages;
> > +       unsigned short id;
> > +
> >         VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
> >         VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> >
> > @@ -702,14 +708,20 @@ void memcg1_swapin(struct folio *folio)
> >          * correspond 1:1 to page and swap slot lifetimes: we charge th=
e
> >          * page to memory here, and uncharge swap when the slot is free=
d.
> >          */
> > -       if (do_memsw_account()) {
> > -               /*
> > -                * The swap entry might not get freed for a long time,
> > -                * let's not wait for it.  The page already received a
> > -                * memory+swap charge, drop the swap entry duplicate.
> > -                */
> > -               mem_cgroup_uncharge_swap(folio->swap, folio_nr_pages(fo=
lio));
> > -       }
> > +       if (!do_memsw_account())
> > +               return;
> > +
> > +       /*
> > +        * The swap entry might not get freed for a long time,
> > +        * let's not wait for it.  The page already received a
> > +        * memory+swap charge, drop the swap entry duplicate.
> > +        */
> > +       nr_pages =3D folio_nr_pages(folio);
> > +       ci =3D swap_cluster_get_and_lock(folio);
> > +       id =3D __swap_cgroup_clear(ci, swp_cluster_offset(folio->swap),
> > +                                nr_pages);
> > +       swap_cluster_unlock(ci);
> > +       mem_cgroup_uncharge_swap(id, nr_pages);
> >  }
> >
> >  void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgp=
gout,
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 641706fa47bf..193c8eb73be7 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -64,6 +64,8 @@
> >  #include <linux/sched/isolation.h>
> >  #include <linux/kmemleak.h>
> >  #include "internal.h"
> > +#include "swap.h"
> > +#include "swap_table.h"
> >  #include <net/sock.h>
> >  #include <net/ip.h>
> >  #include "slab.h"
> > @@ -5462,6 +5464,7 @@ int __init mem_cgroup_init(void)
> >  int __mem_cgroup_try_charge_swap(struct folio *folio)
> >  {
> >         unsigned int nr_pages =3D folio_nr_pages(folio);
> > +       struct swap_cluster_info *ci;
> >         struct page_counter *counter;
> >         struct mem_cgroup *memcg;
> >         struct obj_cgroup *objcg;
> > @@ -5495,22 +5498,23 @@ int __mem_cgroup_try_charge_swap(struct folio *=
folio)
> >         }
> >         mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
> >
> > -       swap_cgroup_record(folio, mem_cgroup_private_id(memcg), folio->=
swap);
> > +       ci =3D swap_cluster_get_and_lock(folio);
> > +       __swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_pages=
,
> > +                         mem_cgroup_private_id(memcg));
> > +       swap_cluster_unlock(ci);
> >
> >         return 0;
> >  }
> >
> >  /**
> >   * __mem_cgroup_uncharge_swap - uncharge swap space
> > - * @entry: swap entry to uncharge
> > + * @id: cgroup id to uncharge
> >   * @nr_pages: the amount of swap space to uncharge
> >   */
> > -void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pag=
es)
> > +void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pag=
es)
> >  {
> >         struct mem_cgroup *memcg;
> > -       unsigned short id;
> >
> > -       id =3D swap_cgroup_clear(entry, nr_pages);
> >         rcu_read_lock();
> >         memcg =3D mem_cgroup_from_private_id(id);
> >         if (memcg) {
> > diff --git a/mm/swap.h b/mm/swap.h
> > index 80c2f1bf7a57..e4ac7dbc1080 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -5,6 +5,7 @@
> >  #include <linux/atomic.h> /* for atomic_long_t */
> >  struct mempolicy;
> >  struct swap_iocb;
> > +struct swap_memcg_table;
> >
> >  extern int page_cluster;
> >
> > @@ -38,6 +39,9 @@ struct swap_cluster_info {
> >         u8 order;
> >         atomic_long_t __rcu *table;     /* Swap table entries, see mm/s=
wap_table.h */
> >         unsigned int *extend_table;     /* For large swap count, protec=
ted by ci->lock */
> > +#ifdef CONFIG_MEMCG
> > +       struct swap_memcg_table *memcg_table;   /* Swap table entries' =
cgroup record */
> > +#endif
> >         struct list_head list;
> >  };
> >
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 86d517a33a55..71a3f128fcf0 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -176,21 +176,19 @@ static int __swap_cache_add_check(struct swap_clu=
ster_info *ci,
> >         if (shadowp && swp_tb_is_shadow(old_tb))
> >                 *shadowp =3D swp_tb_to_shadow(old_tb);
> >         if (memcg_id)
> > -               *memcg_id =3D lookup_swap_cgroup_id(targ_entry);
> > +               *memcg_id =3D __swap_cgroup_get(ci, ci_off);
> >
> >         if (nr =3D=3D 1)
> >                 return 0;
> >
> > -       targ_entry.val =3D round_down(targ_entry.val, nr);
> >         ci_off =3D round_down(ci_off, nr);
> >         ci_end =3D ci_off + nr;
> >         do {
> >                 old_tb =3D __swap_table_get(ci, ci_off);
> >                 if (unlikely(swp_tb_is_folio(old_tb) ||
> >                              !__swp_tb_get_count(old_tb) ||
> > -                            (memcg_id && *memcg_id !=3D lookup_swap_cg=
roup_id(targ_entry))))
> > +                            (memcg_id && *memcg_id !=3D __swap_cgroup_=
get(ci, ci_off))))
> >                         return -EBUSY;
> > -               targ_entry.val++;
> >         } while (++ci_off < ci_end);
> >
> >         return 0;
> > diff --git a/mm/swap_table.h b/mm/swap_table.h
> > index 8415ffbe2b9c..b2b02ee161b1 100644
> > --- a/mm/swap_table.h
> > +++ b/mm/swap_table.h
> > @@ -11,6 +11,11 @@ struct swap_table {
> >         atomic_long_t entries[SWAPFILE_CLUSTER];
> >  };
> >
> > +/* For storing memcg private id */
> > +struct swap_memcg_table {
> > +       unsigned short id[SWAPFILE_CLUSTER];
> > +};
> > +
> >  #define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) =3D=3D PAGE_SIZE=
)
> >
> >  /*
> > @@ -247,4 +252,53 @@ static inline unsigned long swap_table_get(struct =
swap_cluster_info *ci,
> >
> >         return swp_tb;
> >  }
> > +
> > +#ifdef CONFIG_MEMCG
> > +static inline void __swap_cgroup_set(struct swap_cluster_info *ci,
> > +               unsigned int ci_off, unsigned long nr, unsigned short i=
d)
> > +{
> > +       lockdep_assert_held(&ci->lock);
> > +       VM_WARN_ON_ONCE(ci_off >=3D SWAPFILE_CLUSTER);
> > +       do {
> > +               ci->memcg_table->id[ci_off++] =3D id;
>
> Do you need to check the memcg_table is not NULL here? Because this
> function is no longer static. Another caller might invoke this when
> the cluster hasn't allocated the memcg_table. They shouldn't. We might
> want some check and complain here.

Good idea, a NULL check seems good to be defensive. I also noticed
that I should skip memcg table allocation as well if
mem_cgroup_disabled() is true to save some memory. I will update this.

