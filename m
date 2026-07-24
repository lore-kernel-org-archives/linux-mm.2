Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 052C7C531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 07:19:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7BF96B007B; Fri, 24 Jul 2026 03:19:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D826B0088; Fri, 24 Jul 2026 03:19:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91BD86B008A; Fri, 24 Jul 2026 03:19:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 616D26B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 03:19:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE909120290
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:19:01 +0000 (UTC)
X-FDA: 85022818482.12.14414F0
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id E09B0100002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:18:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BsYBeuLj;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784877539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1o/TeKLAsvOU5K4a5S381+TPlp4Jx2uMS/eZkpsUOs=;
	b=5TquyktM71hAdP0K9gq2pWg+4WUedWHDO1Hjxhm67Yuuh1VeG8mHOsBrGJ9W8dNT1ma0MQ
	BeWE8Fo8rlmg8ab3tClMlJlLcu50feh3O3nPVx0Oge1+/4KibYdEgfv6ImLjN7bJPXIm0G
	cghBzTHhiQuJpdhtru5+uVRgoqDgfg8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784877539;
	b=U50i5FCTaXriEOM2UrH8AzkNbbX0fxmz8sCpOak75HOsrOnJJ8lr20ZJPBwifQKRmWrUU0
	Ucd+tEaK58CBgJ9jRlBD9g7aAPIgrS3jo3LFqhs3UdKmD/0IK2F6k5DQxad1kfVQZTFWCf
	/ylgXS1fi0T7v4Q6YCIlm8rCXlQdYtE=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BsYBeuLj;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-699fbcd23ccso148579a12.1
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 00:18:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784877538; cv=none;
        d=google.com; s=arc-20260327;
        b=arZRme5s8O3jen9lX4D1cj9GizLWnI/R+ZYfGa2DAMy9o8fDSPtQzeT559g+Nsa/P1
         9x9Mo/PrELyz2ymLc/dv23wWAykNencIPa9f3vyavc7F7IFA3gN1Cbl7P23e35ygDFC5
         BYkceg368qfS9e16nADdJ1xLynlGXmaLA1/PFshqbl+Ke3wHmwI9zJKT6zzkYWJ/BJmk
         U3YNoVG7DXrqw7TfGP8PCXivwrIDAAgYjk4AhbpiQRmWiaRC/pQSm3BwMR43JTRm4/ej
         1jloKKYHEDiLJx56t50g2q9f/6VwFnG268V0lg4jk5FbnDWa0RGdxavwt02laeTM2aDX
         48NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p1o/TeKLAsvOU5K4a5S381+TPlp4Jx2uMS/eZkpsUOs=;
        fh=wb1PeqIpk/Y1qz9esoosEqgP8ai3UwCxH1Xn2SbtkCg=;
        b=nKKqcgJNZ75CSf7KuOAcggpqd9dfybRtfgs/eZLMncCMdZRSkVDD6A9y+0WMDkWPir
         8+3QcjYLZdO/1cXQrWyQiDVVhy84U5uGsbBnjVm2ENF2Dus15NW3jcRKCvdMCl9gcx4x
         fYW2/13MsQhl+Ueh3zHTEscmwbUel3jyVvad80NAHf2LqDN4j43u7i1kOiVPtCfZHBFd
         pGJFh1IVb6ZKgPxsoBZzGyiipme5KVhu4v7+rG168mFJhPSjsOWiWI0VpMVDfSPQuIS+
         UJiOxlAWvItsQJVn127gHHNViOXVq8BLe2H5ioAHLKmzmrUJcv2nDFmV9dUEGi8gRbTS
         WSNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784877538; x=1785482338; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p1o/TeKLAsvOU5K4a5S381+TPlp4Jx2uMS/eZkpsUOs=;
        b=BsYBeuLjPnU5TWLNLRFKuCXPvPZp3ttsw1QoW9ceSHzG3tEUK3c6KLY53vUs9NzIsC
         5sNh9aREpBLXjJeP+WRMHSCXjpdBZBYW/dtGv/598xRjkCWpjEb9cVw1DGej+lfY6BHg
         871dJQOGsTTEPPiFOYyi1ALS+ww4wVYrNERdmY4/qfxF86qMlhziyqXcCZTZ+5TDWz7T
         sNJyFfUnqM0KAQLQ2DcGaD8ZO7iqQz/Z/ncQYKj/CY8OaFq3gZfscXk1KN+A0Fgm/F20
         MbQxFTeG5BaAj5UfBcL/7eCnW1iy2y4YBhEk3y0khVeGB0yo1sQsenknaxP3hN6F9VrL
         sqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784877538; x=1785482338;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p1o/TeKLAsvOU5K4a5S381+TPlp4Jx2uMS/eZkpsUOs=;
        b=d7fOjdHQiCij6M11tZcm5yqzbw5CbvZyzhhd0RRLp3LtRTixkpiMsxDrqDe4RiLpKP
         acCA0dc58PUCu4aftjnkd6WrRokt140AcMI35kNcgYYKYl3bHp8TlT9TT5x6lOMLiuAg
         nwTp72DODNIbIqStHoHTDzUXkh8yFJDbyJH4T++P+NOccT5ZawMhXA5MI3gUy0/3bpuF
         thy+qf1H8DkGy1hKHLOM32gKL23jUHqFrf8RejO4yBJTgRNpCDBzygAWA4qiBHgmEACk
         lBI9Cr9lg6zWF7yQ0x8P/FntWdKnmmXD8ys/cBB5fFOzxuaEsszkyoQTDWszNod+tq67
         B7Rw==
X-Forwarded-Encrypted: i=1; AHgh+RqGepv4bF1BEqG6N6eYIChrFWrwTJMWqYa1Uda8qKyhYLK8JP7ILD3npUhTbLEVNB5eCI2g1H3acA==@kvack.org
X-Gm-Message-State: AOJu0YziVxV07C7/GZlu0H1CoblyV2NLI/gc++2sYPVQxUELBclUcYH1
	KBFumDaJ6wJySPf+nYpM5Hyd7O0FyYSkjnNNdHZGrrh4tSpEAhuTuT8zN47n58zU7V0WSY2w8jd
	MF6v60rB6VmH+HaDk/kAYqkANJtD+q54=
X-Gm-Gg: AR+sD10i6jtaIvN+yaOwIk77olzKg6Szr5DQFs5KhZp+5k1e7+7h2PtaHPQxsBi06BG
	uk40bZUFE0nlIRU6C2m/v6GhC2PMm6UDAZO3NBaXBlKFoPmmPNWXq46HKxyqSvow51h0/xadKMx
	mA5XcLi+U1exdTy/WQo3UdxjiseK/veqBvRchRAz1TM9xHyVB524K0KABTHoPn4WeB/taCS0foF
	KBOAWi4/dqfptbr/QniGrh6QABo1/hjZZP+BHH9h5+rXWvfgcj2kUeJabWNwET9emsOlPUohUd3
	5hIib5S2W+uFBZ2Bt8Js+Fx6ahPO0Q==
X-Received: by 2002:a17:907:d11:b0:c16:b05c:b9cf with SMTP id
 a640c23a62f3a-c1c509a9500mr275206666b.26.1784877538025; Fri, 24 Jul 2026
 00:18:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260724033435.2573323-1-ridong.chen@linux.dev> <20260724033435.2573323-5-ridong.chen@linux.dev>
In-Reply-To: <20260724033435.2573323-5-ridong.chen@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 24 Jul 2026 15:18:20 +0800
X-Gm-Features: AUfX_mwxRBF3SV1pnYd66b762DS2w7hBVFmVUzb7XbFbo2-Tk9fj0mZXFQv5doQ
Message-ID: <CAMgjq7AzMic8kBviymFi2qz+VcvwSysJTS=a2ca9cjDjC3xAMA@mail.gmail.com>
Subject: Re: [PATCH -v4 4/4] mm/mglru: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Ridong <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Zhongkun He <hezhongkun.hzk@bytedance.com>, 
	Muchun Song <muchun.song@linux.dev>, Davidlohr Bueso <dave@stgolabs.net>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E09B0100002
X-Stat-Signature: y7a47xurptj4wg8w13ngux79961eq48x
X-Rspam-User: 
X-HE-Tag: 1784877539-498235
X-HE-Meta: U2FsdGVkX1+9zjKFHs3JQDv58nG6BmjhJhF18Dc+WdooQm6BT2HSFz2JJU7ZcltA0QzRTgmhJB3vA5w3hUOZplWX+wNuG678Gvum8uG73C2uVp76+SIm+ZTTN1dMmLpeaRe4Au9/swHcF/433rNabQpf8dqG8G6HDiljzaeOvaNokOQaaRYcs1wkv7sYLKzw4IishEk+u8X9NK78Gn6ZKPR4TVMJLPqOP9a8iWWUn51xzPW4IfhMLhMwHBT0ROlg8gwy8HLLd/hh4v8yYV/kzfx3yqMDUuAY1Wo+YV1gea3rIZP+o+g5OkypdyyDJG4cuXHsO0BBCwiuN6D/P96K8jS910TQL1rNJ0tBAV9HFPtFIH+G0tnuu853h4HANeUjh4uooSPgLSRSLS+5XRA++jMcBSX6WUDY4iCGhZ+yH57HoJvTiCNpVDuIERlN2S1Wv19XcNCoRLkvmgb4NMW6l/W2iAeL/1nvDFLch15PEolEahA57w38SuwaNYrN+0dfzhSMh7TYqSO43/Jv0vQFznF8XYRC8VHxJ2dqD2ZOF+fjGYFQNR6Ogu7bsU+XBUDsdb8YwOJeYOEYE7eBGLHahoyMygIFckRLOe9iqVDWWyQ2drSruAF841NkGcr9yvR/6xFhy4Y1+XlCGpZuislVUvJzDqB9KpGXR/0airlGhh6UdQYIRqHisSXbvJLDKOR5HsRDRdJxj5S+U9nI4GxK93nJZxS+CW4xe9D4TwdUr6LJy1DGaHbs2L71ke0eg6FRmtWaeXw2XTOjECiqg8iJFIVG/9kimwKrz/LA22XS3KWXPmBuXkkA3IhtASvl8Xs+BF+ld8oKSIDqTPm5Owi8Ey0XrZGbRcqMW8y5b+r5loFf4ML/OgL4Ww6xhsaXtdOQbnc9Pv11sROXm6EKjkJwGizApfGwqolICqFaFB75ZvrdPDVNmWRUfnnoATAZtSJ8KvE04cdq5IxsRU0hXkK
 tF4aYf29
 2rIwE39mdbm/JHIjgEAYkSwola3FnY5wGJ9N+1Kx4hS2vCb7ikURkfr8a2Lr4lZ8NE4FSczLStmKDeKiSoq061mC8YkMnv0PFv7VPVQ3h0bffKlOJs7UYyvkoaoo/KRYjLNVBJV8Dw1LChPoXnEzK/UnLRBbmVplbWWmlF1GLu9AmI/XiuUq/wQtZlURRQazkSTBVOoBYxgLO8Zmt1/iYDhJFyWwrmjYJ6VXW1a4TafmDs7JaLVWwtwMogI9lVnn3yo5ifJkFgm61TiDrgVlEG1GXy8Q4CTXOKpH2uSrHMZ1OlDwb74cP76Hu4SUil63ahZDGMJPL4xHyJble8PCnatEe+FGOG56zKuKOyjwzYmXIEmxu1jBmDEATY0+6aM+mRfgSKaLck8lkgD21xnxGuY/s+3u/4YV8ESE0nWiDDavFY9r7XJc0uPkPWlIb6/uPiLotqBJpi/QQpt+061Hx4z7l4/uZgal6HzQyK2C+FuJ1MxOpm6CtLGuO0IzHJMUesCLa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 11:36=E2=80=AFAM Ridong <ridong.chen@linux.dev> wro=
te:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> The previous patch fixed this issue for the traditional LRU. The same
> problem exists in MGLRU [1]: when swappiness=3Dmax (SWAPPINESS_ANON_ONLY)
> is set, reclaim is expected to evict anonymous pages exclusively, but
> file pages can still be reclaimed when anonymous pages cannot be
> reclaimed (e.g. no swap and no demotion target).
>
> Fix it the same way as the traditional LRU: keep returning
> SWAPPINESS_ANON_ONLY in get_swappiness(), and return 0 from
> get_nr_to_scan() when SWAPPINESS_ANON_ONLY is set but anon pages cannot
> be reclaimed. Since get_nr_to_scan() decides how much MGLRU scans,
> returning 0 skips the scan entirely and avoids the useless scan work
> when there is nothing eligible to reclaim.
>
> The test result:
> Before fix:
>
>   # cat /sys/kernel/mm/lru_gen/enabled
>   0x0007
>   # cat memory.stat
>   anon 204800
>   file 67108864
>   ...
>   pgsteal_proactive 0
>   pgscan_proactive 0
>
>   # echo "64M swappiness=3Dmax" > memory.reclaim
>   # cat memory.stat
>   anon 208896
>   file 0
>   ...
>   pgsteal_proactive 16384
>   pgscan_proactive 16384
>
> After fix:
>
>   # cat memory.stat
>   anon 188416
>   file 67215360
>   kernel 1970176
>   ...
>   pgsteal_proactive 0
>   pgscan_proactive 0
>
>   # echo "64M swappiness=3Dmax" > memory.reclaim
>   -bash: echo: write error: Resource temporarily unavailable
>   # cat memory.stat
>   anon 204800
>   file 67215360
>   ...
>   pgsteal_proactive 0
>   pgscan_proactive 0
>
> [1] https://sashiko.dev/#/patchset/20260717113300.214717-1-ridong.chen@li=
nux.dev
>
> Fixes: 68a1436bde00 ("mm: add swappiness=3Dmax arg to memory.reclaim for =
only anon reclaim")
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/vmscan.c | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 859655fcf60d..254827544461 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2708,6 +2708,10 @@ static int get_swappiness(struct lruvec *lruvec, s=
truct scan_control *sc)
>  {
>         struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
>         struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> +       int swappiness =3D sc_swappiness(sc, memcg);
> +
> +       if (swappiness =3D=3D SWAPPINESS_ANON_ONLY)
> +               return swappiness;
>
>         if (!sc->may_swap)
>                 return 0;
> @@ -2716,7 +2720,7 @@ static int get_swappiness(struct lruvec *lruvec, st=
ruct scan_control *sc)
>             mem_cgroup_get_nr_swap_pages(memcg) < MIN_LRU_BATCH)
>                 return 0;
>
> -       return sc_swappiness(sc, memcg);
> +       return swappiness;
>  }
>
>  static int get_nr_gens(struct lruvec *lruvec, int type)
> @@ -4921,6 +4925,20 @@ static long get_nr_to_scan(struct lruvec *lruvec, =
struct scan_control *sc,
>                            struct mem_cgroup *memcg, int swappiness)
>  {
>         unsigned long nr_to_scan, evictable;
> +       struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> +
> +       /*
> +        * Proactive reclaim initiated by userspace for anonymous memory =
only.
> +        * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path=
, so
> +        * warn if it shows up elsewhere. When anon cannot be reclaimed (=
e.g.
> +        * no swap), return 0 to skip the scan entirely, avoiding useless=
 scan
> +        * work when there is nothing eligible to reclaim.
> +        */
> +       if (swappiness =3D=3D SWAPPINESS_ANON_ONLY) {
> +               WARN_ON_ONCE(!sc->proactive);
> +               if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc))
> +                       return 0;
> +       }
>
>         evictable =3D lruvec_evictable_size(lruvec, swappiness);
>
> --
> 2.34.1

Looks good to me, thanks!

Reviewed-by: Kairui Song <kasong@tencent.com>

