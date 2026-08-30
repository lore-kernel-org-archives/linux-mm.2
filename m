Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 067F9C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16EF96B008A; Sun, 30 Aug 2026 03:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11FD06B008C; Sun, 30 Aug 2026 03:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010216B0092; Sun, 30 Aug 2026 03:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CD3656B008A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:54:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D518A3B41
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:54:06 +0000 (UTC)
X-FDA: 85157172492.06.8593AF9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 765E7C0006
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:54:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ocy4ylfF;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788076444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UeEQ5jVzcI0HkkaBYNG8dZHlQd9/ubRiXJT++zIWi7M=;
	b=aPq7HNQa6s4fxy+LsAsSe7xzbn6l6+R4v6OdIXL5ylVI+Rj8oN4Y9Nm8aEFAZxZkam1/31
	ghwjd6gVdoFuGLBam9dxihLgS/lHRKxkL1IfCNzheDFD7m2UL0ROLKF+xMEcMofbS5Hw8s
	jLav0E2uBfIhejDY1j4k4YfARrM0SrM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788076444;
	b=ZMeBiNS1IOf7JwSNu8kUEBCToqYNYVo5zhkqS7Qqr2l6ochuQX6FRizIe6J3x2EuAd1kvu
	MmV8rVc2z687tcl03ofrKk8yJYIrXxoeCHBZO/VezNmDprd/NDLhZAkaIPF+6R0oaYKGrf
	xiJzrL5RJePigYckmlHwKXoPad3MXLo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ocy4ylfF;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A56A3434AB
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894A71F000E9
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788076443;
	bh=UeEQ5jVzcI0HkkaBYNG8dZHlQd9/ubRiXJT++zIWi7M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ocy4ylfFrWKNIBjucLRgP/bcUttjvfQaZdfmC/pHFTioFbRGlQ/BlBKtxGZvpA56x
	 y5ImLCwoTbty6dkS6KMS89q6JBdaD+/NQTN5LkWHvvPGlmvCnDIw8/djn59ZygBqOv
	 qpf6b1LPrGedr/UXbe+Q7ljzC/EK74Z0OZfMDyxNLvShInFyiXq22EwFZBrL7ZaP90
	 A1o3rLatmXqkczN8qBvTranP1LLvheI1b78mbPVMICwC8PwQZ6zS3T3aK3OzuKZ781
	 BMoERzwL+5IbTPFjHwrOp6xKzLVWu4mbxGH77VAham2ilthQ3rh/KxqQjwbVAoXHAA
	 +v6+rbaqH2HMg==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-9387752a4d0so148322285a.2
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:54:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpmrGqAnnizUAM63MOnK/L7r0cmucWeNlAXMOe7FtsuKetV0w6bTRjp/7tTyFd3u+qCuruRTnOOWA==@kvack.org
X-Gm-Message-State: AFuF++lKs6Vl+hjl6CQGfRmT8FRXDvi7sIB59MXXfSB1xdq5GrxscvZc
	XIU9dvF9R6kuvb4BhBsAsbZ9jJzIlwKaSG/CVpKJOJobyASfVfWciP0jaxLl/P0z+uGpmjAubnc
	lV2iHSHdowLTTUQDqhBQzjHvV+5eytm4=
X-Received: by 2002:a05:620a:6c0d:b0:938:fd60:4f9 with SMTP id
 af79cd13be357-939138ffdc0mr2008314785a.27.1788076442846; Sun, 30 Aug 2026
 00:54:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260828110919.1324028-1-ridong.chen@linux.dev> <20260828110919.1324028-3-ridong.chen@linux.dev>
In-Reply-To: <20260828110919.1324028-3-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 30 Aug 2026 15:53:51 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ws6edtcToqJQ0azJPTymAYj41nzdGJvBqEM+gROiJtRQ@mail.gmail.com>
X-Gm-Features: AcwNN1XAAY1zLhOoDIQLd7-dIIw1xCvdhjIWr8q4jSclCc3cBnbDulr35kYiJ1A
Message-ID: <CAGsJ_4ws6edtcToqJQ0azJPTymAYj41nzdGJvBqEM+gROiJtRQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Muchun Song <muchun.song@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 765E7C0006
X-Stat-Signature: rqb3ak3dd1rajg5m3i5pstfgbettu6di
X-HE-Tag: 1788076444-1275
X-HE-Meta: U2FsdGVkX19935C7ypf4wCt5DIYQaJdg/0MhDsvR8sT1jIMBOWMXZuAVkF/AHqHCGNCfGw13zR1+jb3GFvPu/5ZrlNVi4GzThUk32rvfXfsyZSARw1oR8il3EjTY85Mr8Ktt/pMKG1Yc4RygQVz/u5T/TJee1A/nYQ0N7lq8jwf+1G2BxzI5xi1Jt925onWa6j2yoymleuNeRDfIsqoDsv0n9/03sz4QpqOu6OSH3CBBQgCQRKttvR7MCfKlnz37zBCay1s12QYucUxdtjWssJG5fzuke74g/c1rY5ppDOV9cNnTQ7FogzVqsg6m5AcyOCnhkCahFR27IM0ah3+OaSg1NLKa2W702ZSlLyjcnbZ00BGeGwbdEhrAY9gsbuEmM+czbuqWw0p7I7CxNVZWQZvdoKKwn2xkeV/pKLVnB06i9Gl2vX9YpFlOw/R0JzIcGQr44GXronTFeSifVu5hibHCLyYYYYDu5JNrVl0H9L+3ui41gHaLss+4ztaAXXzGzY5wXErdJInxg/h6NUD9cv2VZ5C69DOtfTve5BbU2dZixXYJ5cWpE+n11ObqT0wuw7PYuO4AQMoivAlLdXZhgfdl2zmrbTDcrT9tY4HSKNeVo4AxVEtSxumE48ScgTQgPGc9SlmvUFUTqpXlD58/qurNafdvBBeIOvgkSHTVZed+mwuasCfA0y8uNoMGVwICZyeS6d474FNUylJsVtenYFzkDcuwaLtrcB5RFMF3yrpoW5EDebxz3ZuGEDmMG5uIPuqhvdURBWJdjASy0kf2s1hICJC9a397qJw7jdzgv8uDlm0k6FYVBq3eeGg9njO09N7aHbjy4lbUmNcIpFAU178RvaRe8lsIAxeoZT4/VVGux8zKWBNZRlmIQYZb9vonpafzuJO0MWyPSiKWfpBR/EJZ8cY3TUn3sjewad2ivy4akMFvAicw0l0Txg0U4Q7hIcDiF8y0WwRKQeByK4K
 hdFrDkA1
 JftoO+uohAZzUMXRFXGjeksuXJn6HpyEBkjSxpEUk6Ip3fFJlBiepJFOITMs0dLHwxfatoYcPq2L3s28XslDCo64O6bgJs9DFNTy1heLvClZ8r/0aKRZ7fWNlDu52AjzSQSi+TWuGpA5qdILvlDFbx1fjbfN/OgihmtXtNtEb4aiKXCn6IRR96Xd4s+me2LQEN7ZJ0eV04R3TM3DoRB+/Hi7szsYN+8ITwWiaoevF99q8m76xEjgOX6QtXl94YEsKqC1ATkJXkbA9WqAAbd7CA9jfVxYXJhb1D+XotZ2wQi/ZRsy0GDO56aBgh3rnce/4fPhXdG15HYSd+iQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 7:10=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> memory.min/low is silently bypassed for MGLRU during global proactive
> reclaim (writing to the root memory.reclaim) and global direct reclaim.

I guess nobody is silently bypassing anything. It's just that the
effective min is stale data. If kswapd has run at least once, should
the protection have been updated already?
I guess we need to update the changelog a bit?

> It can be reproduced as follows:
>
>   # echo 7 > /sys/kernel/mm/lru_gen/enabled
>   # cd /sys/fs/cgroup
>   # mkdir -p a/b
>   # echo 100M > a/memory.min
>   # echo +memory > a/cgroup.subtree_control
>   # echo 100M > a/b/memory.min
>   # echo $$ > a/b/cgroup.procs
>   # dd if=3D/dev/zero of=3D/tmp/testfile bs=3D1M count=3D200
>   # cat a/b/memory.current
>   222650368
>   # echo 500M > memory.reclaim
>   -bash: echo: write error: Resource temporarily unavailable
>   # cat a/b/memory.current
>   6070272
>
> memory.min is 100M, yet reclaim drops a/b down to 6M, breaking the
> protection. The traditional LRU path is not affected because
> shrink_node() calls mem_cgroup_calculate_protection() for each memcg it
> visits during a top-down tree walk.
>
> Commit 30d77b7eef01 ("mm/mglru: fix ineffective protection calculation")
> moved the protection computation into lru_gen_age_node(), which only
> runs for kswapd. Non-kswapd global reclaim reaches shrink_one() through
> lru_gen_shrink_node() -> shrink_many() without any protection
> computation, so emin/elow remain stale or zero.
>
> Introduce mem_cgroup_protection_path() which computes emin/elow along
> the root-to-target path only by iterating through the cgroup ancestors
> array top-down. This avoids the full tree traversal that would be
> needed with mem_cgroup_calculate_protection(), limiting the cost to
> O(depth) per memcg - typically 3-5 levels.
>
> Call it from shrink_one() for the non-kswapd path so that each memcg
> about to be shrunk has correct protection values.
>
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  include/linux/memcontrol.h | 11 ++++++++++
>  mm/memcontrol.c            | 45 ++++++++++++++++++++++++++++++++++++++
>  mm/vmscan.c                |  8 ++++++-
>  3 files changed, 63 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 7d1c0ce189a8..8066b798a759 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -605,6 +605,10 @@ static inline void mem_cgroup_protection(struct mem_=
cgroup *root,
>
>  void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>                                      struct mem_cgroup *memcg);
> +#ifdef CONFIG_LRU_GEN
> +void mem_cgroup_protection_path(struct mem_cgroup *root,
> +                               struct mem_cgroup *memcg);
> +#endif
>
>  static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
>                                           struct mem_cgroup *memcg)
> @@ -1133,6 +1137,13 @@ static inline void mem_cgroup_calculate_protection=
(struct mem_cgroup *root,
>  {
>  }
>
> +#ifdef CONFIG_LRU_GEN
> +static inline void mem_cgroup_protection_path(struct mem_cgroup *root,
> +                                             struct mem_cgroup *memcg)
> +{
> +}
> +#endif
> +

I wonder if we could follow the zswap pattern?

#if defined(CONFIG_MEMCG) && defined(CONFIG_ZSWAP)
bool obj_cgroup_may_zswap(struct obj_cgroup *objcg);
void obj_cgroup_charge_zswap(struct obj_cgroup *objcg, size_t size);
void obj_cgroup_uncharge_zswap(struct obj_cgroup *objcg, size_t size);
bool mem_cgroup_zswap_writeback_enabled(struct mem_cgroup *memcg);
#else
static inline bool obj_cgroup_may_zswap(struct obj_cgroup *objcg)
{
        return true;
}
...
#endif

>  static inline bool mem_cgroup_unprotected(struct mem_cgroup *target,
>                                           struct mem_cgroup *memcg)
>  {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1271d390b617..095050d4296a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5198,6 +5198,51 @@ void mem_cgroup_calculate_protection(struct mem_cg=
roup *root,
>         page_counter_calculate_protection(&root->memory, &memcg->memory, =
recursive_protection);
>  }
>
> +#ifdef CONFIG_LRU_GEN
> +/**
> + * mem_cgroup_protection_path - compute protection along root->memcg pat=
h
> + * @root: the top ancestor of the sub-tree being checked (NULL for root_=
mem_cgroup)
> + * @memcg: the target memory cgroup
> + *
> + * Walk the ancestor path from @root down to @memcg and compute the effe=
ctive
> + * protection at each level.  This is safe for isolated queries because =
it
> + * ensures parents are computed before children.
> + */
> +void mem_cgroup_protection_path(struct mem_cgroup *root,
> +                               struct mem_cgroup *memcg)

Can we rename it to `mem_cgroup_calculate_protection_path()`?

BTW, I see that the only caller is in vmscan and it passes NULL as
`root`. Do we need to keep the `root` argument if the new helper is
only used for global reclaim?

Best Regards
Barry

