Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2338606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 19:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HfT0zD/j
Received: by kanga.kvack.org (Postfix)
	id 058246B05B2; Mon, 23 Nov 2026 14:28:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008116B05B3; Mon, 23 Nov 2026 14:28:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3C776B05B4; Mon, 23 Nov 2026 14:28:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB5EE6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:28:08 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 568A616099A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:28:08 +0000 (UTC)
X-FDA: 85467369456.03.D11AFC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A10E0120005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 19:28:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HfT0zD/j";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795462086;
	b=aCioftqr7+zW9aO1nicT7n9o8NWOMfZ5LcL0rMVXCGH8Fr+SPA5PwYTt1+1gIIArhircwZ
	pBmyhnpxepvPeaFPcDwXx6ao+XL+Ek2qYMehu+IKYP63+14yqBVOB/s2Wqjb010Bu6xgQ4
	fAVp7lSJiTQhUMNw0VIaeo9P+yYehlQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795462086;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CANnW+hAEMIUmX34omHKhF3VfiVjx1PL/iyRq31vyR0=;
	b=OapvJJkinP64hq/tgwkdRwvEML/L8gB/u9KRmfN5Q4aov9PB6DqsjCJsWqtccqVrNOgLxb
	tMEnC2PCYhDNcmlQMjSMkP5sIlnrtBpPapWAYtOyvNurkmXcUbrI29J9gQfNQq7X+0dbX8
	fbawDJfNmqTr745UZAx0zWgRlZ1nwts=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HfT0zD/j";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BDC4344FE5;
	Mon, 23 Nov 2026 19:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BC81F000CF;
	Mon, 23 Nov 2026 19:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795462085;
	bh=CANnW+hAEMIUmX34omHKhF3VfiVjx1PL/iyRq31vyR0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HfT0zD/juyN6xv5uFFkYHlcPwpyemnxygXuuBV69fH5F93NiuC3S5nsi04gtls2Kf
	 aDwMi/wwTRBUijC4Yj5di034UazCkmIwMKzpaLwAVamywYicfgQi54V1A2UvUbhtbn
	 tP6CZfccI6yTmwywI6uV95nsr84xPKBKPEKCiENE6J0tPrCS7xmW5VoupAkyGtOMtz
	 AAEpXf3bP6XJvN5hisL8AECJkcmxQ9CrdBZ4BLCBfslCUPoRIF2Cq0CQiokQ0A0voZ
	 gv77Gw8JWZLYQ8U7Vkrqg67+jp+6XN7Wy9ZcrUN8Ff93G9pykYZBgWuALhiQzLnOpL
	 4Ch7p+ulS3D3g==
Message-ID: <sashiko-outbox-229933@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 17/18] mm/mglru: folio LRU refs based active/inactive
 number accounting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kairui Song" <kasong@tencent.com>, linux-mm@kvack.org
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Weiner" <hannes@cmpxchg.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Qi Zheng" <qi.zheng@linux.dev>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Chris
 Li" <chrisl@kernel.org>, "Baoquan He" <baoquan.he@linux.dev>, "Nico Pache" <nico.pache@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Barry Song" <baohua@kernel.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei
 Xu" <weixugc@google.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Nhat Pham" <nphamcs@gmail.com>, "Youngjun
 Park" <youngjun.park@lge.com>, "Zi Yan" <ziy@nvidia.com>, "Gregory Price" <gourry@gourry.net>,
 =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "Dev
 Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Hugh
 Dickins" <hughd@google.com>, "SJ Park" <sj@kernel.org>, "David Rientjes" <rientjes@google.com>, "Yu
 Zhao" <yuzhao@google.com>, "Vernon Yang" <vernon2gm@gmail.com>, "Zicheng
 Wang" <wangzicheng@honor.com>, "Tal Zussman" <tz2294@columbia.edu>, "Kairui
 Song" <ryncsn@gmail.com>, "Xiang Liu" <liuxiang.277@bytedance.com>, "Ehab
 Ababneh" <ehab.ababneh@intel.com>, "Zhao Zhenzhuo" <zhaozhengzhuo@uniontech.com>, "Lian
 Wang" <lianux.mm@gmail.com>, "Joanne Koong" <joannelkoong@gmail.com>, "Kunwu
 Chan" <kunwu.chan@gmail.com>, "Hui Zhu" <hui.zhu@linux.dev>, "Maxim
 Muzafarov" <maxmuzaf@gmail.com>, damon@lists.linux.dev, "Tianyi Chen" <hi@tychen.cc>, "Ridong
 Chen" <ridong.chen@linux.dev>, tj@kernel.org, mkoutny@suse.com
In-Reply-To: <20261124-mglru-fg-v6-17-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-17-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 23 Nov 2026 19:28:02 +0000
X-Rspamd-Queue-Id: A10E0120005
X-Stat-Signature: 7yzrn5x6dg4xu81ddugb1nwyyjgina75
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795462086-885405
X-HE-Meta: U2FsdGVkX1/y2dePprNn6xMsMfX+HYjqUdwF0qL5qZR5WgXR0guKfr7OIt9ij1NuBid2VCCGn1SbrjDgm4gVo2NVKETWB2UCbMWK0do3E2RUG0nbK6B4gWsay0K4MOqmDAi3TRt8Mod/IFilV9N1nPFaG/Mf1g8nXRcvUSnZ1ja5tJvnQrzKpQ1DAVsmj2pCRFJ4YHObgClQUgHwkLb83X+B0ergg5LqGC1k/sRv4OXN+szrC8nOtT5Lz6eZhyDc8ztwYhayMXQtF3WhIj3P1nZAteu2pt+XqHfb1QUopMXf3VfJEPEdHvY3BEqlIrpudl5h4wbeTJ6BywojBg0MtEt5mphxYx2n0997DeBUUNyGOIrpPpSAozuf1JvEi1VGlwiKlEB++rLsVuAVyteFC2GsSp7dim31Fp/PuNZQLqi4uqB7ONTzZys10TtQ9AnjDqIGvjnNIsKBN6rN5ircNkpF7tuWamgA0sWNQ7MC3y2ZJgAm8cujYK9pEcsGv9JVgLF3yAlU28CpZqO07ftypYACn1MfBmxBBUbOSGWGw540EZsEwssaSRp0cqJn0Q03gK93Et3RuD13QRu30QXOdjS+0FBt90aExTNEFK7YlMEq1qFPL0/3zhEo18TEDUgMW1MWIJzMyfZSGG/r7p4srwPCiHSH+oL1T6ynijIMopGuDsd5knyWsZEAeJ5Z3QAQ2Vafb3bwK2Kpgtb16kXI3qodL6T4tHn/muhEAU1YABB52+sI7N5ISivuzLQEoXN1hgIGbXo5rbToDiTYsK3DzQnTYGdDaEpUKkVKzqgyv2C/jyCKIwlj5Q4pxjaSIJxEodZSmGjdQBAKDYTBnFLlWU/Pc1wUDyegK/FMNSc/Pswa2AI5ZmFc3K6mUdWeFDvn55TEyIWIv1LT9Hl4bh+fvTz+KnQ/EFK8tFpDBv0SV0XsWoHyE01Fhmg0jaFtFkX1C2MubXoMrqSuYIIy8v0
 d3yWYiOY
 zSx/dV0JT5836DvYKrdPvPCdvCVLYIDS6EXplpRJqR6LOAdtSQRM1fGBxKVLX9nVDPNkdBnnNbQb8qxeB0XD5JJwo9Bg0MLgOVhfbwj+3DA67Ds6SHtrQ4hXZdyCk0Fw5lbLvp2uGKGZ8dw8U0AE8EKph8FR0INVBY8BbqPHYFbDOvTE/IrIyx7xF+0sF6jLAS2rbKysAYBC7SIfiQL9Z0fJlHvS0rd36ipok6CIEd8nBsHM2RIYwSVN0PU8sNVOKWmiR4wPKm8wqPGSUpbFVPiY67AZNp2fO17sXcGKniKD0erqMRwhhhEKpyDcTS/qwwH7dcNC4F8uRjzfLbUio0WuhXo7VtjncSdvZeiA7H+PNu6YYfRhzTYFgYgc32vr5G+nDWw2/f28AmKSo9UtWD1x4UoLCeFRvPVoKGp2xnHNnUqfH64JcuLvF4DHJUI/GpuZ2HTWj/WLvyhwSaIflXYfkZB4Fjs16q68SqVIARpMHlmzWLlSyjFANVz7XRk4bRDTynUQmi6c21qTjo/SwlttNGykjozvyFvqnTSZ9vRSNNjL1FSRe1xfo8UjQw6hw9ltueBb+oXXu8XD1kz7qL+puXc783CDjvdkF3zDktefDWEU5NhIdRus++YL2/74aEjSJrBmUHoSCfNTYxygTcXZkXyFJS858Wbki0KxtbZAw9+lcdZBY41GXJI7SZiWByzX1jkf99kWogtC2OFGGj/qPmZ+9f9yqjsqQ1oRMqKirA66j3VPFvLYsaT5SNMNAPTEXQqQhhLiL5DnY0Olrh3ToW3rWnVjazUTSq+bpINkn2R4itfQt2HLM0RXYHie6OpnIc+/ozsbq1qBHnpeRsOHmceetzPUjZNX87lJcHoFIzklGUvz1OyXDpHmxFpNeOfSPTmUPP6G3KVoOO9NHJlYdJqUtDQ1OuGE9Olbjflp6mjc=
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
- [Medium] mm/mglru: extra atomic RMWs on folio->flags in
  lru_gen_del_folio()
--

commit c2fa4ccd879e2b2e8e7542ec52e0fe26798b936c
Author: Kairui Song <kasong@tencent.com>

mm/mglru: folio LRU refs based active/inactive number accounting

This commit switches MGLRU active and inactive LRU size accounting from
the generation window to per-folio LRU reference counts based on the
LRU_REFS_ACTIVATED threshold.

> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index a4daf366e6aa7..b0f062e3a1905 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h

[ ... ]

> @@ -440,24 +445,33 @@ static inline bool lru_gen_add_rejected_folio(struc=
t lruvec *lruvec, struct foli
>  static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio=
 *folio, bool reclaiming)
>  {
>  	unsigned long flags;
> -	int gen =3D folio_lru_gen(folio);
> +	unsigned int refs;
> +	int gen;
>  	int zone =3D folio_zonenum(folio);
>  	int delta =3D folio_nr_pages(folio);
>  	enum lru_list lru =3D folio_is_file_lru(folio) * LRU_INACTIVE_FILE;
> +	unsigned long max_seq =3D READ_ONCE(lruvec->lrugen.max_seq);
> =20
> +	/* Keep LRU_REFS_FLAGS: refs carry access history across isolation */
> +	flags =3D set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, 0);
> +	gen =3D lru_get_gen_flags(flags);
> +	refs =3D lru_get_refs_flags(flags);
>  	if (gen < 0)
>  		return false;
> =20
>  	VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
>  	VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
> =20
> -	/* for folio_migrate_flags() */
> -	flags =3D !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(PG_active=
) : 0;
> -	flags =3D set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, flags);
> -	gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
> +	/*
> +	 * See the comment in lru_gen_folio_seq.  For migration, compaction,
> +	 * or any other isolation of a hot folio, try best to retain its gen
> +	 * info. Ideally we would keep the full gen info.
> +	 */
> +	if (!reclaiming && ((max_seq - gen) % MAX_NR_GENS) < MIN_NR_GENS)
> +		folio_set_active(folio);

[Severity: Medium]
Does moving set_mask_bits() before the gen < 0 check and splitting out
folio_set_active() add unnecessary atomic RMWs on folio->flags in
lru_gen_del_folio()?

set_mask_bits() unconditionally runs a try_cmpxchg() loop even when the
masked bits are already zero, so every lruvec_del_folio() call when MGLRU
is disabled at runtime (or on unevictable folios) now performs an atomic
RMW instead of returning after a READ_ONCE() check.  When MGLRU is enabled,
non-reclaim deletions of folios in the two youngest generations (such as
__page_cache_release() in folios_put_refs(), which immediately clears
PG_active via __folio_clear_lru_flags()) also execute two atomic RMWs
(set_mask_bits() followed by folio_set_active()) instead of combining
clearing LRU_GEN_MASK and setting PG_active into a single try_cmpxchg()
loop after checking gen < 0.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124-mglru-fg-v=
6-0-8ffea39934a6@tencent.com?part=3D17

