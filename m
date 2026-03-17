Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E932FFD8779
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 23:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0904C6B00B2; Tue, 17 Mar 2026 19:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 068596B00B3; Tue, 17 Mar 2026 19:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99706B00B4; Tue, 17 Mar 2026 19:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D69966B00B2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:44:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5749AC1B19
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:44:51 +0000 (UTC)
X-FDA: 84557187582.04.4D1F4BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 60894A000F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:44:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zx8Petuv;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773791089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DxQYbxmHSsSO9M2Z7myeLzk/g6/LRQaehI0+t9bv7VA=;
	b=WVXPiXIeej1rdjR0y45L1VWIsNTCZjolJKpVo9fchZP4wD1Fvmj96tgk/HLKGLsxkYdO2L
	PsZ8pESMDQnPnMIhpClKm4OxLOhBLFejMAZNyiwH2TEwXoPJQf/703CK7IpBaz4vi+vmRY
	BjVqFy9aOIram0ii425jcGRuTosnsSE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zx8Petuv;
	spf=pass (imf25.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773791089; a=rsa-sha256;
	cv=none;
	b=6+gcORD/k2afUUddC4b7DSM9sj9E8YwmpPsidHw13P2K3l5a2XT248UG7ZLOtiv4Arw2zK
	tx/JlKkNkkZCNmje4EO2rM/F9N/y1Kye9Kzf3Nfk7yAojKK2+7v7CZJV3vrzcJU6oBK/CO
	d7yFcQ6PXcy21yy6E3K08E+ZplX4vZY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B026442E2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DF1C2BCB4
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773791088;
	bh=61d3W2tpnS0KkrdeI1XmmuVAhVXpxBDTBzXbwdbx58I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Zx8PetuvkWzEq287mV1/1xmSAQFlPBf9HGJCgMfsSb3rm2Baozjac/ZeWWLFuodMo
	 90hHgnjtQ92Nfyxrr5BQ1EoAnfmLXBdVpUjDpGY8f2zBQ0aJpQQjEqoGX7CixHqx2t
	 En3s6WGYYvNnU+jKknNZNIAvgRO/vi3lprYBeFrl3NYgT+1P7jsU1c/yz/v5S4bdTd
	 yNHWGK20dSl1c7Y7S2+CO/9lB5MEVBLtDysupkUEtZI4y7CkoF6oNHVtSljB4g36o3
	 K6Vf9saNs9IbroueePq7bDhtcRjcjLD5APdZZf9bTs2jhiySXlU8Npjvlvh/cahprt
	 K03oB7bDxXDuw==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b9795ca4e6dso634155566b.2
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:44:47 -0700 (PDT)
X-Gm-Message-State: AOJu0YwyYCkBiXQ3X5/JyQAqtn2ZrIVMjSPDZ5nPKMQdbj8+YGccEzuv
	iQr4aqONzWYXVJ/6muiFrQvWajh5m9oasrcCWu2tCYCV1yMcTK1qqVfMDFRQq0hRNeBVwn5ucPi
	xNGUK8er8E43ZsNWxqVWnfrqCghMP4oU=
X-Received: by 2002:a17:907:c1f:b0:b97:a215:3d1 with SMTP id
 a640c23a62f3a-b97f4aad947mr58264266b.42.1773791086816; Tue, 17 Mar 2026
 16:44:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260317230720.990329-1-bingjiao@google.com> <20260317230720.990329-3-bingjiao@google.com>
In-Reply-To: <20260317230720.990329-3-bingjiao@google.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 17 Mar 2026 16:44:34 -0700
X-Gmail-Original-Message-ID: <CAO9r8zP5HmeE1uOZE9WxN1GyC59mM_F2JGaKLEkxzzCvnxpW2g@mail.gmail.com>
X-Gm-Features: AaiRm53K1T7iGoYV3Lx1Cc_11ZGTWZyjENkvqraqWVXO2-lNXSjZMG9_FFHOcZc
Message-ID: <CAO9r8zP5HmeE1uOZE9WxN1GyC59mM_F2JGaKLEkxzzCvnxpW2g@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/memcontrol: disable demotion in memcg direct reclaim
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
X-Rspamd-Queue-Id: 60894A000F
X-Stat-Signature: ni8uhhpuhzs6ohhndogc6zn1xtd3nj38
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773791089-376568
X-HE-Meta: U2FsdGVkX19SVNNqqPkLy/UsfxXE+ZNQCFrAWiJaY3/oYTxR/VmUUZGJUXvHmcWqiU8RboOBzlGBlfx42E6WQxEJ1M91Od3dkxpn1ArDxfN+bRCkMv9cIfA61zDxKPec2wvE8iKQAuSxM4blnGMMyPFhZtgAq1IZmhsf4uRLR2P+fRpgWvz21lDLyVTHbUq3LRDGCpBx6MWSxQAq0nKdDRMmrKovvlYSfB6tftf8YM8X0t5AO19Kjg9ZKP2dLKBIzbwBGEffwFQs2toastHzrzQQOhJgBu1t5QlVJq5yQhAkZZPf22WOn7m7aBhruwyWlaIe1VtPQohFFngop01HM1EGRSzBzTwk/MIj5WpemCbpt+cn9lh3wxTmN89p2swjCMUQMdmSwuppqcUxVYDdAvyDNlyHUbwRwtpkmwqbgLiZ3c4Dve52LJstcPL6kTDVjdZU+HRb1U4Z+YEnmzBr7pjYBOvpCITUlIKJkdx6sqL3KIwInfgPweCmk5/I6alJdPv3Lb6wcXLldsbjWDAyKwGWXWxVk6ZH7PS6cu2JNJTkZC9+mqL9Een93I3A0rCBHQinogRYFHTaYG8gh+TC3NcBbEHCkBorTCcR7G3hymMklyUBUoBZ43rHZFo2BaR8MqqofIyvB99tls3SLJlBn94fFGsZAaK61fi+oxQA81Q0Gt9MEhGf0rLfHRBB5HnkfyrMVojDmD9XRWVamfra3vZSI7YiwJGmAJKKbOBTStzQKbssK2c9CsL33rmD2n7Zq3nPLHKRxzqe6XqPaMJY2/M0WZv2CXwRP4vloepOlZ6GpP7MaEe0yYVdhzldYR2B2cIFay0GQt5Ym7+WfHf0jBsOj9ihEVMOrDrYtk5o2UAkPhvKPbo/EwkjhUjVVcb/LzydJSEJiBNstVKM+C7aa1xld9mpgN757eM0IlnNVjzf7j6dJOk3LiR7WjCO34UWQVYQ5AvgwOtAwGs5RO+
 U3ZIR6aQ
 3g+X8jzsij8ZWljKIsf1/QdPPrtBbDzKXY8T66S9/0z5td+wegRzRoa7IEKVJ0xn8X1vNx+sMA2rUaeuyLfZoQb8R8AQOMdXEHkSV21J4WlZwYq6WEJypOLzFFyAfYGirwNXg3RT0NGkiQeu+xuxbMcgTDz21KHdfzT6bUV1aOG1JrMc4qfvsx9EhI4Y8U1v6z2Yl1rnSVuCIGit0SHRNPn/zXnRY2yCg80+3BKTPl+8vbn8NvPaieO/zMSHSM5eHvUjKBEZRQd8GX+5mEPAuSQy21SF/ab3b45pyRn5YGCb0lCMVO1wKQLH1jjderTTdpyoMzT+yfj57RYxGp01wb1E56BIEfjAMoXE2kTBVHaLmmI4iFhMF46GxSoT9hUzyJfUHhrx73FA3jmiRhs9p7rcboeu/mKizLqUcRljlVesvliRv5uV2g7ZDKkdkxrVFdIrtHTNaAia4NNhXMyIHg1orhhUIbHr6VaFG55TKfW4xmnAclCADZBWcgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 4:07=E2=80=AFPM Bing Jiao <bingjiao@google.com> wro=
te:
>
> NUMA demotion counts towards reclaim targets in shrink_folio_list(), but
> it does not reduce the total memory usage of a memcg. In memcg direct
> reclaim paths (e.g., charge-triggered or manual limit writes), where
> demotion is allowed, this leads to "fake progress" where the reclaim
> loop concludes it has satisfied the memory request without actually
> reducing the cgroup's charge.
>
> This could result in inefficient reclaim loops, CPU waste, moving all
> pages to far-tier nodes, and potentially premature OOM kills when the
> cgroup is under memory pressure but demotion is still possible.
>
> Introduce the MEMCG_RECLAIM_NO_DEMOTION flag to disable demotion in
> these memcg-specific reclaim paths. This ensures that reclaim
> progress is only counted when memory is actually freed or swapped out.

See the discussion @
https://lore.kernel.org/linux-mm/20250909012141.1467-1-cuishw@inspur.com/
and the commits/threads it is referring to.

>
> Signed-off-by: Bing Jiao <bingjiao@google.com>
> ---
>  include/linux/swap.h |  1 +
>  mm/memcontrol-v1.c   | 10 ++++++++--
>  mm/memcontrol.c      | 16 +++++++++++-----
>  mm/vmscan.c          |  1 +
>  4 files changed, 21 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 7a09df6977a5..e83897a6dc72 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -356,6 +356,7 @@ unsigned long lruvec_lru_size(struct lruvec *lruvec, =
enum lru_list lru, int zone
>
>  #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
>  #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
> +#define MEMCG_RECLAIM_NO_DEMOTION (1 << 3)
>  #define MIN_SWAPPINESS 0
>  #define MAX_SWAPPINESS 200
>
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index 433bba9dfe71..3cb600e28e5b 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -1466,6 +1466,10 @@ static int mem_cgroup_resize_max(struct mem_cgroup=
 *memcg,
>         int ret;
>         bool limits_invariant;
>         struct page_counter *counter =3D memsw ? &memcg->memsw : &memcg->=
memory;
> +       unsigned int reclaim_options =3D MEMCG_RECLAIM_NO_DEMOTION;
> +
> +       if (!memsw)
> +               reclaim_options |=3D MEMCG_RECLAIM_MAY_SWAP;
>
>         do {
>                 if (signal_pending(current)) {
> @@ -1500,7 +1504,7 @@ static int mem_cgroup_resize_max(struct mem_cgroup =
*memcg,
>                 }
>
>                 if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
> -                               memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP, NULL)=
) {
> +                                                reclaim_options, NULL)) =
{
>                         ret =3D -EBUSY;
>                         break;
>                 }
> @@ -1520,6 +1524,8 @@ static int mem_cgroup_resize_max(struct mem_cgroup =
*memcg,
>  static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
>  {
>         int nr_retries =3D MAX_RECLAIM_RETRIES;
> +       unsigned int reclaim_options =3D MEMCG_RECLAIM_MAY_SWAP |
> +                                      MEMCG_RECLAIM_NO_DEMOTION;
>
>         /* we call try-to-free pages for make this cgroup empty */
>         lru_add_drain_all();
> @@ -1532,7 +1538,7 @@ static int mem_cgroup_force_empty(struct mem_cgroup=
 *memcg)
>                         return -EINTR;
>
>                 if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
> -                                                 MEMCG_RECLAIM_MAY_SWAP,=
 NULL))
> +                                                 reclaim_options, NULL))
>                         nr_retries--;
>         }
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 303ac622d22d..fcf1cd0da643 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2287,6 +2287,8 @@ static unsigned long reclaim_high(struct mem_cgroup=
 *memcg,
>                                   gfp_t gfp_mask)
>  {
>         unsigned long nr_reclaimed =3D 0;
> +       unsigned int reclaim_options =3D MEMCG_RECLAIM_MAY_SWAP |
> +                                      MEMCG_RECLAIM_NO_DEMOTION;
>
>         do {
>                 unsigned long pflags;
> @@ -2300,7 +2302,7 @@ static unsigned long reclaim_high(struct mem_cgroup=
 *memcg,
>                 psi_memstall_enter(&pflags);
>                 nr_reclaimed +=3D try_to_free_mem_cgroup_pages(memcg, nr_=
pages,
>                                                         gfp_mask,
> -                                                       MEMCG_RECLAIM_MAY=
_SWAP,
> +                                                       reclaim_options,
>                                                         NULL);
>                 psi_memstall_leave(&pflags);
>         } while ((memcg =3D parent_mem_cgroup(memcg)) &&
> @@ -2572,7 +2574,7 @@ static int try_charge_memcg(struct mem_cgroup *memc=
g, gfp_t gfp_mask,
>                 /* Avoid the refill and flush of the older stock */
>                 batch =3D nr_pages;
>
> -       reclaim_options =3D MEMCG_RECLAIM_MAY_SWAP;
> +       reclaim_options =3D MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_NO_DEM=
OTION;
>         if (!do_memsw_account() ||
>             page_counter_try_charge(&memcg->memsw, batch, &counter)) {
>                 if (page_counter_try_charge(&memcg->memory, batch, &count=
er))
> @@ -2610,7 +2612,7 @@ static int try_charge_memcg(struct mem_cgroup *memc=
g, gfp_t gfp_mask,
>
>         psi_memstall_enter(&pflags);
>         nr_reclaimed =3D try_to_free_mem_cgroup_pages(mem_over_limit, nr_=
pages,
> -                                                   gfp_mask, reclaim_opt=
ions, NULL);
> +                                       gfp_mask, reclaim_options, NULL);
>         psi_memstall_leave(&pflags);
>
>         if (mem_cgroup_margin(mem_over_limit) >=3D nr_pages)
> @@ -4638,6 +4640,8 @@ static ssize_t memory_high_write(struct kernfs_open=
_file *of,
>  {
>         struct mem_cgroup *memcg =3D mem_cgroup_from_css(of_css(of));
>         unsigned int nr_retries =3D MAX_RECLAIM_RETRIES;
> +       unsigned int reclaim_options =3D MEMCG_RECLAIM_MAY_SWAP |
> +                                      MEMCG_RECLAIM_NO_DEMOTION;
>         bool drained =3D false;
>         unsigned long high;
>         int err;
> @@ -4669,7 +4673,7 @@ static ssize_t memory_high_write(struct kernfs_open=
_file *of,
>                 }
>
>                 reclaimed =3D try_to_free_mem_cgroup_pages(memcg, nr_page=
s - high,
> -                                       GFP_KERNEL, MEMCG_RECLAIM_MAY_SWA=
P, NULL);
> +                                       GFP_KERNEL, reclaim_options, NULL=
);
>
>                 if (!reclaimed && !nr_retries--)
>                         break;
> @@ -4690,6 +4694,8 @@ static ssize_t memory_max_write(struct kernfs_open_=
file *of,
>  {
>         struct mem_cgroup *memcg =3D mem_cgroup_from_css(of_css(of));
>         unsigned int nr_reclaims =3D MAX_RECLAIM_RETRIES;
> +       unsigned int reclaim_options =3D MEMCG_RECLAIM_MAY_SWAP |
> +                                      MEMCG_RECLAIM_NO_DEMOTION;
>         bool drained =3D false;
>         unsigned long max;
>         int err;
> @@ -4721,7 +4727,7 @@ static ssize_t memory_max_write(struct kernfs_open_=
file *of,
>
>                 if (nr_reclaims) {
>                         if (!try_to_free_mem_cgroup_pages(memcg, nr_pages=
 - max,
> -                                       GFP_KERNEL, MEMCG_RECLAIM_MAY_SWA=
P, NULL))
> +                                       GFP_KERNEL, reclaim_options, NULL=
))
>                                 nr_reclaims--;
>                         continue;
>                 }
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 33287ba4a500..7a8617ba1748 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -6809,6 +6809,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct m=
em_cgroup *memcg,
>                 .may_unmap =3D 1,
>                 .may_swap =3D !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP=
),
>                 .proactive =3D !!(reclaim_options & MEMCG_RECLAIM_PROACTI=
VE),
> +               .no_demotion =3D !!(reclaim_options & MEMCG_RECLAIM_NO_DE=
MOTION),
>         };
>         /*
>          * Traverse the ZONELIST_FALLBACK zonelist of the current node to=
 put
> --
> 2.53.0.851.ga537e3e6e9-goog
>

