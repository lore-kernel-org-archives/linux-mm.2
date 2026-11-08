Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCA64606A321
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 21:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gm0vMsur
Received: by kanga.kvack.org (Postfix)
	id 63B0D6B05B0; Sun,  8 Nov 2026 16:04:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC066B05B1; Sun,  8 Nov 2026 16:04:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48F036B05B4; Sun,  8 Nov 2026 16:04:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 144386B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 16:04:34 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68204A8127
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:04:33 +0000 (UTC)
X-FDA: 85413180426.07.DFE9699
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7DB5640003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:04:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gm0vMsur;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794171871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dA8BlSr4nW8M2tmghZ/qmNUjL9Vz8LO1wLh57I7CYw8=;
	b=hvyxxxj68MKHxIiTTxcKMYRfoyIYTVQSfzA5lVhxwccdCKXF4I42hpqVgHe17Z/EQAsiKp
	DkQep8eHN0c9peTaVODxBCW6fFVMdZNGXTJlD+GCCHnAh8nG1qNI63t+SCy851lvC6mx9S
	R6j6qKcI9D/NSZDzHjt5dIr5tbfnX3A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794171871;
	b=mKwMliKymtzWHvCO1JC25/MDB63P5dB1XL4MPwXbNdpQut49L0y//4xIdLlcz1qH5O0wmU
	N6BAD1K/hAGA658O/qTJaj6QBEaxXoqDqFEPF92Bw26RyvHUk1PGpv2moZgwX5z6Vblyas
	iEiCU4yI0zV5xLzn9r2OmGmwWoCLeG0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gm0vMsur;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D807644EBF
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92871F0092C
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794171869;
	bh=dA8BlSr4nW8M2tmghZ/qmNUjL9Vz8LO1wLh57I7CYw8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Gm0vMsur6Zp+NDkvE5MIcJ+lRVCZkjKGPWerSg0Ixxfn9AEbpAu/RLNKOqwe/ZTdo
	 qPph1jA31UrzXqTs+vyoemnUgI2gqnqO/vugay5bIG4wQdwTss9sreUHZHeUpgXCew
	 xT57TF/AzNCIVb5ptdoraysWsiWP9qiz+GAmeYe2ZaABkPz3HHL/YoH5zndZBhaInK
	 l1ZfJq9jygp4h8kT5Gh1IRgMOKCswVib34YlOmDx7ZDzDx5NL5V9adTpX+A20v/nD1
	 BvGjiE7CAPVWDb1+95/Ev5HtSHiPIok/91M5Lqq/9Iz2IAxMN30nyu4NE4pqAouu5k
	 JZwc0uwTnuukw==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-9441591aa5cso38927385a.1
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 13:04:29 -0800 (PST)
X-Gm-Message-State: APuU4Z9hxOeSkmfnebDlI+i2dih+RMEio22ceMAv81V6Gz0ynpY2Aki1
	cpRpHmhS4TgL2pgZvbTUBs22XLsxyhXieeOV5rbBjkoMLaSnZIrATxpCpd+yObSfOY0zEMdrdBi
	hlrLb3CvnQ++EYB4jcFmOn/Mb20XXZm0=
X-Received: by 2002:a05:620a:4147:b0:945:d2f9:5c2e with SMTP id
 af79cd13be357-94784201be3mr321265885a.18.1794171868934; Sun, 08 Nov 2026
 13:04:28 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com> <20261016-mglru-fg-v4-7-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-7-2106750c0bfa@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 9 Nov 2026 05:04:17 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wSDOgCC9AmLS-z670W-nkF3DXB_cNvNFnptX5F95fGMA@mail.gmail.com>
X-Gm-Features: AclHuK88cVk2cTHlbMRpEce2sAMWIV7FVPbAiXOdIHIxIsSaZ46UdtpCmeHh5_Y
Message-ID: <CAGsJ_4wSDOgCC9AmLS-z670W-nkF3DXB_cNvNFnptX5F95fGMA@mail.gmail.com>
Subject: Re: [PATCH v4 07/17] mm/mglru, gup: mark folios referenced via a fast helper
To: kasong@tencent.com
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: rtgajrxzsr9mqgg8zcehx7sj5oxu7apq
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7DB5640003
X-Rspam-User: 
X-HE-Tag: 1794171871-189465
X-HE-Meta: U2FsdGVkX19mxLU2i5O6s63t/YXmGtLCFCoSXcIPuLEhvJ3vot67JtckhbnnuWmOCiJnR95Zuu4TM7Nysz+vfw1g8wAI44ppkmiq8fLA9s799rIl00Qevnn5XXJZCqS1noPrnnqeGlL8bgO5Vrc0dl10jryA6ZqahUIhg8iMk34di8LSb7eLCp0s8F5mx3/20k5zAMTDTqMB2niD+mECgkc7TiRQRDU+GhCHAlSpsaX0mWatFZBgh3JLybXqPd+e2y17d8FVsyCgULFir1FlW++vTDqF7lO0NrpAjvlDhqgKM1ny4lTYuScApwHjCgeHHBQgx7sF2LF43QqkxVuzCE9MNeGmfo41bDhgrsnrADaA+6oam9QeyIjqtM1SzCwuUEEKaw8y8mmd4B9sDNwyy3sCVX+xKBd1gaGxZM/hjaRyGXgUH87DWSMMGebDNZOYzmW5u7fZXakJtJz6PGF4joJWYWeOCAvHhQ/NXf4lg2O+NBBfNhVOrmmvlET0FCA9fdcZysM0cgd2upfCwfFGQ2D5EyGmQEzva2RA4LqdjKC2aI6Sc0SMFgObBr/7tWyAN1xeLrbnBANullyt+G+8DOKUAxQordvtNkuvExG+2kBW0XlPDhVPCBONJMK1qRCZ+FkSr9JWlUUKNMl1FrCNEm3wOepxvYC+sRPLQyaEumLSUNLLV/O5pqcN5sJBjRAMx6O/NE608H6LduI3z9o9O7pzc3USW9jKB4DW8JIjxELWMFUNoLQn6/1aUG3uVCEA2smE8fzviZXyi0a2YS+XEbKnID5VIBQ2FPdyLujxyVJbO1K/EfPeLRSYEoRphO5wISD/nOmUPFFs9o1MPZISuGw88mSYznBdUWhocUf7hvRr6G++M9WxooMbCQ/aTM1bzlhPKoVODGZQ7/mAPpUbC7vN4vQc3NTiUIvXiBAElVygFdjGuS7Sd57kCXcAebT5V90c69WSbDNQ1gzLIzr
 SsaxGFLu
 9jEaxSqGVChMh7r+TU4nZP0IZZfGeli0+jIQiavDyUcQQPdlaZBfg8R8r9DYz/7SjR0o920nLY3dxUu79O8vJzJJEP1Gz13G/0ufIcZkdJmLKEz6WFDsolAfUE9NZRTQev7iw1dmCUUw343hxDYleNkuSyCYVWmzjlSrjatcsw5lvvJuOQtuSvvwJBnyrmzua3IYEGGb6xOjs34wF4zCSW+Eo759hmUzspF3qqUvvalPtehr4rD1PplJf+KRYuwWeHrbojWXBOaFnTne9gI3L2PhrpQ0UjusSgZ9hqIB/o55oFDw5PQWaWjIHbeSBCfM/5/ABafV1nUu+yJbVVyDgIaqsXT/j/VFwNtO23rsUyfvJoJKjprUy2SoG1kJu/RI8L4sEQtpgqa3XZkntR43wUIh71mw3PMEWvHRRwsIMbOQHt/7uxeuUTtjZNcBVwybch4B1VsiCUSsXDR2DjA0ZV1wCZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 16, 2026 at 2:15=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Introduce folio_inc_lru_refs_fast(): raise refs from 0 to
> LRU_REFS_REFERENCED via cmpxchg, or just set PG_referenced for the
> classical LRU as before. No counter update, promotion, and guarteens
> no other complex operations in following commits.
>
> Convert the gup fast-path sites. No behavior change for classical LRU.
>
> Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 25 +++++++++++++++++++++++++
>  mm/gup.c                  |  6 +++---
>  2 files changed, 28 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 65415eeac802..effa13c63632 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -454,6 +454,31 @@ static inline bool lru_gen_del_folio(struct lruvec *=
lruvec, struct folio *folio,
>  }
>  #endif /* CONFIG_LRU_GEN */
>
> +/**
> + * folio_inc_lru_refs_fast - Bump folio refs count without promotion.
> + * @folio: the folio
> + *
> + * Raise refs from 0 to LRU_REFS_REFERENCED and leave hotter folios
> + * untouched. For the classical LRU, a plain PG_referenced set.
> + */
> +static __always_inline void folio_inc_lru_refs_fast(struct folio *folio)
> +{
> +       unsigned long new_flags, old_flags;
> +
> +       if (!lru_gen_enabled()) {
> +               folio_set_referenced(folio);
> +               return;
> +       }
> +
> +       old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> +       do {
> +               if (lru_get_refs_flags(old_flags))
> +                       break;
> +               new_flags =3D old_flags;
> +               lru_set_refs_flags(&new_flags, LRU_REFS_REFERENCED);
> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
> +}

What is the actual purpose of this patch? Is it to skip
cmpxchg() when the folio already has non-zero refs for
better performance?

Thanks,
Barry

