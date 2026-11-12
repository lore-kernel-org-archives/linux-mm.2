Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26AD7606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 05:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CE6YXn7b
Received: by kanga.kvack.org (Postfix)
	id EEAA66B05BA; Thu, 12 Nov 2026 00:01:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74A76B05BB; Thu, 12 Nov 2026 00:01:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB0EA6B05BC; Thu, 12 Nov 2026 00:01:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4E716B05BA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:01:12 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4DE0F16046A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:01:12 +0000 (UTC)
X-FDA: 85425267984.03.D810565
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 99B3418000E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:01:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CE6YXn7b;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794459670;
	b=12eijwFyaUzYG/Y2LUJQH/K1QiuAFQ7Cb6P729l3FRPiilcyPsub9KDVauVyxssq/9xPLv
	I93tsanuXVacZx4WoDTj4s4lkF0DQ2V65VWADOxWDIAZg9wQTHRJdV5zI3Va0yuneYLFOw
	Sn00uq14/NOIYLsJI50l8kwQ9G1WpAE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CE6YXn7b;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794459670;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rGnqvBfwv1GuzgofDivUXLxhCclkpqt3OTX1NYXZgCg=;
	b=GfQWV31+dcZ9y0AhG+SEpiEwS8Qe/fy+yLAYMLaKa78fAuUN9ga0+iPtoirobNZmBNekhy
	r+LTRbidHVBUg6qSj9kI6nN4Jijh1W5yB8gycJdrh8tmwbhi9oIQ/aBqpPIH9D0yxGlDI/
	9lvEcBMXVeLLKwim0xzJJ++12jYjA48=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E3A4C43439;
	Thu, 12 Nov 2026 05:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7D11F00A05;
	Thu, 12 Nov 2026 05:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794459669;
	bh=rGnqvBfwv1GuzgofDivUXLxhCclkpqt3OTX1NYXZgCg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CE6YXn7bKsphjp6X4RUj+o8yYThu4S1WjytVLPUav9DUmivny2qiLJErTxBlUAhlP
	 1Cde7MzHMXfg/MvZQyo+i1hAq1tw0Lht+9DCtJyejOXXKIxWnJh/8eoOmD6BfNhIh2
	 RwklVmnwKiTZXeWv5pzCc7OKdMnLj1fGazNp3QI6hnE4RCxXRxxR+NOORa6dYDp8Pt
	 Uvg2fqsBipG7xyYi9sDEtNrUO+B3Afi2hySmrMu7NThyDPWSqrNOxiAzG0WSFw7E/2
	 fiD0eCxlLjBt5TqwdAIueQ53vT3397zDB7eUL5Rh7kf4+ZW/gP+betR80D8EkqeDJW
	 UOq18IhjWFdAA==
Message-ID: <sashiko-outbox-210420@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 12/16] mm/mglru: Restrict eviction accounting to
 eligible zones
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QmFycnkgU29uZyAoWGlhb21pKQ==?= <baohua@kernel.org>, akpm@linux-foundation.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org, lianux.mm@gmail.com, linux-mm@kvack.org, liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn, sidchintamaneni@gmail.com
In-Reply-To: <20261111232603.9934-13-baohua@kernel.org>
References: <20261111232603.9934-1-baohua@kernel.org>
 <20261111232603.9934-13-baohua@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 05:01:08 +0000
X-Stat-Signature: 95x3hb85w395ymcnfq3pmcaoy3arrfa7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 99B3418000E
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794459670-862065
X-HE-Meta: U2FsdGVkX18d+Fx35FD5gibHB4cf8kjGY6lnum7x1ty3XP72NNkhZRxQnATzCDSh5I2dcVhCAUzxeXAYGVjrAtG7Q4eCpn/8BPM8r9ZO93yf9y1jMnxycwRIsSeAhYQA5rxG/GuxMRQiqgJSHD3Grt8O1RLPC4yD6mAlihdJGJGt04fSewkbdMpuobDZk22gnMorm7PWqzUVTuGazspkmHr5XilBDWSjGt0zr+FSZ/cTUKe/Qbq1X745nmRhuycz1yY1jiTVlDBR8+TZs4sXBi4+rE9ndFanygpIrGtJ573SzvtFMlK0Dqks4+xH02uw04EZcnE0rk1nKs/j8qu/huneBUkJhb2diHLVWVK0e5212loIm0a9AQ21bg8XE2URwImemRQf/MxhQXLAQAOndg668Li+NLMDXe1uAaFTrGeeSwqsRyknUusrexzM3Oz7UfliJ7SozkDv5g4ui8aZWzdFs3Ia4RzcJUo+ZNkG9tk3GNpCK/C7+tRNrwvYZqMLmbWr2iHR0i8G9hEtcMm8jbEjIhXM7I71Uq/sv1S9XJRPUJ5ks4wN3Y1Jwn5ZiLc7gYEzXAD61kpUfXxxJVjTQXbaJHnYCCDSU0ugbnnVLosjQsJNxGLJPxSrGRXoyj1vfdCH4Dzk8c7P62SHGfQyOgSC+CEEaB8SUznA8u1Ch1Tn86LjjZzOsxIm3fRRsUkqpCZJjx5/A7GpmQdYlTLfo63D/bmgZLVZ7oatnSeELRxHOBk0k0ED+dSxFxGDrAIbkV0oHVVph3+umbCyhYX7gX0sxG5LmoivQJwyQC7zWacx/GzTzF/AB2LTo+jIiixDmUpAW/aq2imYiHUYrU9CaVP1yRNkYfbognmL68EDUwaDeC2/0YFUUFBRshUw1RcIzddmLz6j+XCUzcL9tfFep1mgqGRKNelegwdBX2O2OKguCmO/FJQ8/ZUGPuFmJhbrvO7hREAi6oSfpI2Q0Eg
 YnIgcFQT
 EfbH7ZxJy0LR7JkSSFPoIa6ajandV9xe3hdFTfoGmQIQhILlT0gk5niO3tzWZ97aaUZqVoVbPoSvkJNlMLZ93XXEi2cWatr1H6cEhPBbWEBRnBUk1aSoKSRO6XOfEjkVJHH6Y0jTUdBeIginJqXbPE7HugGmcRk/2jQKOgKJHPLQg518G2SjzkD27StZ416CD1/Wg2ygCBA78zLPtrGPo1wnUAjZxxrsKej0n6Ue1ATjFENvMapb/92mUtZGP4RxTYp6fjg2m76eOgqLKDDqapfUdjb2Wc4togakUXykwKatjTp4CtKBCNy91YwV2HgdykPaSILjjTxf8HkLQ044/XZlzBlCScfGoq1HfYsX/xgIemOOZP+kTGopeb5Mk4ZFPN9Vm6QTATlGUfLiB3ugOWSKiPnWdV4qVnqEFOILec/NiS9dLOZHliKBkDhdP3ChrXugcEE1u8jiCCx8lmMJuvpo5wtmZr04dQeqmvjcn5Ed1DsxBJrg6sgTgN6k8IbMqCltiGTwUbV37rrhTEyVutUQoPFDvQjWXhtwHfqki89nZlN4yjgULzzTzgdt+QbqtrG5xmgGWgWHCGu/BbIIsgyM6y77Ye32lg2apvo+g1Yd+v4YHI4CJ+zcRgC7uEq4xMU/a3q9yjLI5qkdRq9eFONTHFItn0HbqF5hUifr4+HQnhrQgY9837jWZY/I6KtCCFrInNe8iCimLvmw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/mglru: premature OOM kill in lru_gen_age_node() on
  zone-constrained reclaim
--

commit 169c51ce627ac19052dda882e181615f7e7c984d
Author: Barry Song (Xiaomi) <baohua@kernel.org>

mm/mglru: Restrict eviction accounting to eligible zones

This commit restricts lruvec_evictable_size() and lru_gen_imbalanced() to
count only zones at or below sc->reclaim_idx by adding a max_zone
parameter to lruvec_gen_size().

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 41dd77652c82f..8b77e6bc1d519 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4207,8 +4207,8 @@ static void set_initial_priority(struct pglist_data=
 *pgdat, struct scan_control
>  	sc->priority =3D clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
>  }
> =20
> -static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
> -				  unsigned long nr[])
> +static void lruvec_evictable_size(struct lruvec *lruvec, struct scan_con=
trol *sc,
> +				  int swappiness, unsigned long nr[])
>  {
>  	int type;
>  	unsigned long seq;
> @@ -4221,7 +4221,7 @@ static void lruvec_evictable_size(struct lruvec *lr=
uvec, int swappiness,
> =20
>  	for_each_evictable_type(type, swappiness) {
>  		for (seq =3D min_seq[type]; seq <=3D max_seq; seq++)
> -			nr[type] +=3D lruvec_gen_size(lrugen, type, seq);
> +			nr[type] +=3D lruvec_gen_size(lrugen, type, seq, sc->reclaim_idx + 1);
>  	}
>  }
> =20
> @@ -4230,7 +4230,7 @@ static bool lruvec_is_sizable(struct lruvec *lruvec=
, struct scan_control *sc)
>  	unsigned long total, sizes[ANON_AND_FILE];
>  	int swappiness =3D get_swappiness(lruvec, sc);
> =20
> -	lruvec_evictable_size(lruvec, swappiness, sizes);
> +	lruvec_evictable_size(lruvec, sc, swappiness, sizes);
>  	total =3D sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
> =20
>  	/* whether the size is big enough to be helpful */

[Severity: High]
Can restricting lruvec_is_sizable() to sc->reclaim_idx trigger a premature
global OOM kill in lru_gen_age_node() during zone-constrained reclaim when
lru_gen_min_ttl is enabled?

In balance_pgdat(), kswapd sets sc.reclaim_idx =3D highest_zoneidx and runs
kswapd_age_node() -> lru_gen_age_node() before kswapd_shrink_node():

mm/vmscan.c:lru_gen_age_node() {
	...
	do {
		struct lruvec *lruvec =3D mem_cgroup_lruvec(memcg, pgdat);

		mem_cgroup_calculate_protection(NULL, memcg);

		if (!reclaimable)
			reclaimable =3D lruvec_is_reclaimable(lruvec, sc, min_ttl);
	} while ((memcg =3D mem_cgroup_iter(NULL, memcg, NULL)));
	...
	if (!reclaimable && mutex_trylock(&oom_lock)) {
		struct oom_control oc =3D {
			.gfp_mask =3D sc->gfp_mask,
		};

		out_of_memory(&oc);

		mutex_unlock(&oom_lock);
	}
}

Because user LRU pages are allocated from the highest zones and kept out of
lower zones by lowmem_reserve, a wakeup with a constrained highest_zoneidx
(such as ZONE_DMA or ZONE_DMA32) can find fewer than 1UL << sc->priority
evictable pages in zones 0..sc->reclaim_idx in every memcg.
lruvec_is_sizable() and lruvec_is_reclaimable() then return false for all
memcgs, causing lru_gen_age_node() to invoke out_of_memory() with
GFP_KERNEL even when higher zones have plenty of reclaimable memory older
than min_ttl.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111232603.9934=
-1-baohua@kernel.org?part=3D12

