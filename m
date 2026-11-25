Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D13C5606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aB9TCN5u
Received: by kanga.kvack.org (Postfix)
	id EF3276B097F; Wed, 25 Nov 2026 05:03:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA34C6B0981; Wed, 25 Nov 2026 05:03:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90EC6B0982; Wed, 25 Nov 2026 05:03:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD0D86B097F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:03:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4CD16A8C53
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:03:16 +0000 (UTC)
X-FDA: 85473203592.07.0BA2166
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5E35940006
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:03:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aB9TCN5u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795600994;
	b=zZgCxyErUWW4Ag5ZghwIk8vwnzeCyrJ2keE/bTtU0FbK9XdzmaUTd/8pilwqYF4IFBY/Hj
	hqUmbvJ0cDMXl7HWatfmLvXK4pSnOR9kTnVvG/2bXYyLtutAzZQ92BiR7gMjTWZF3YU6mP
	+UIZyug/rLdiP9g9/9qwAnPndjinQYc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795600994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ahAD1nTlJMyKd+Ivy4YWjGLtR4U+tnl+mOngOadx7yo=;
	b=vEFrRu9taLYJhtmBnsmKEpEhgWtykbpkozDpG507IWLGtvcC3uk9EoVZamknXU3v8qXuGO
	uEEhn8YecJyc6ij0iKC8qbjmWbSC0nlHKA9CAXgVcwdfPPLTEiQokzMnEYCF6xpkImz1Ux
	mHTsnzSA+vJHSv5fxUpHYWq0ViFu/+8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aB9TCN5u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E24545D35
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8011F00A3D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795600993;
	bh=ahAD1nTlJMyKd+Ivy4YWjGLtR4U+tnl+mOngOadx7yo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=aB9TCN5un+FY44DyzDWOfl/JnifH+71Ve+hTPGcSbb5FWibTB8+3/a03RedeyXNtw
	 Ut9a/5zRNkzIfwPM6/c+S+na0kzX2kwPZHrDCK52XhWFCBtUhcZrVR5Upx3aWadPFo
	 8NJWiQuMjAfswvt25VnnqVlrijaEO4ceNFKGLCrVfyg8PKFfhQM49xUc4KNORl245l
	 xwGeI6stLtGCII8QWnG9I6IawEmJ4MBCp6r1t47BEYd7Yu5SmPp38aOviFYzyzKXUM
	 ZMhk/UIIo8OdYZxxNmfjRj7D5vITgRvSjWY5jFCjjYLxbODxTN94UtKki/yrvlBR7h
	 59NtENOfSatLw==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-9496577d4c4so628440085a.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:03:13 -0800 (PST)
X-Gm-Message-State: APuU4Z9JUh5P/vUTFcxrbPSZ39ZuJjK/c2U+qMyINj8/L6BPotq2ci1Q
	wcX1mnW59eM/ArutmZ5kpEN45/tGm45d9WmIqhZP3n1egvTv5GEkemcxL5ey6WVdDVuMaGxiAx+
	+mKD4vV2lJ0LAXn0f6rXHnFBoOBqxtnw=
X-Received: by 2002:a05:620a:4011:b0:949:82b5:402d with SMTP id
 af79cd13be357-949ba955997mr2986180585a.12.1795600992351; Wed, 25 Nov 2026
 02:03:12 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com> <20261124-mglru-fg-v6-17-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-17-8ffea39934a6@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 25 Nov 2026 18:02:58 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zuAmNt9xYJdU1dmc06PRsCnDc8H+hV=5vU6oRAyWsSCA@mail.gmail.com>
X-Gm-Features: Aa3M54rjOxmsiKxZY9PTg72qI_9AeJX3OFX-7i-N7MNLDLDrtS6AQM6YTnwOk90
Message-ID: <CAGsJ_4zuAmNt9xYJdU1dmc06PRsCnDc8H+hV=5vU6oRAyWsSCA@mail.gmail.com>
Subject: Re: [PATCH v6 17/18] mm/mglru: folio LRU refs based active/inactive
 number accounting
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Joanne Koong <joannelkoong@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org, 
	Tianyi Chen <hi@tychen.cc>, Ridong Chen <ridong.chen@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5E35940006
X-Stat-Signature: h8mbk8fbb4zuebjdhqcd3tzayq3797k6
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795600994-704093
X-HE-Meta: U2FsdGVkX1/cjrgkr4h+j5TjLrS3L1iebzg+AGdlGLTjy3HKAgcJraDsaec+wm7QlwAKOLspWW5VkU4+tmumBWMAinU4wJCXwjO1k1KJOCpooL6FWyN44nZf5ijQzi7+dWFkrWwPBG2A2HoXEVEt/oGbbasCUAsKprt3clS7AY9jCK45B0sdKq/0BjaB+5foYmjWL/HO3Z3kQow+JaRR6MT40wqn97tUx/BmJ/qPaXwlc4VsQSeQf3xXOUm+1ZseCYzWi+1iZP2dylRWFs+1oXK6pWwTFh1zu5FBb7Ynu342wcuwq/9pXLvSQIEasnDeA1ArFAsILjC0y9w3VcbGrHQLQCRfvKUb9RhNM1mv086yPIJoyHsvqFuI581T2YCGZUUdZs6za2vXa78MuWAwVWvg9hOB6BtNJy+LA4dJtS49sb14ngc7WF4y88buwG2UZ0uYxzQw3VJd2/FxPxrOsAAJJXzD/gupVdV8ICSl4wFNI9DNm1QDKxHR9gWhgHqbkcVNd80Z04nQ69uVYTkdNr+cSp9kUiriSUigdwe5dV4RRyFEJM67ExcbTsPX8Nddycvszqg+pricXHyaflEvk/KVXbi5me8hPURMVgJZdOXTsHfvMX7zFhQa6pOrZeAKrLfE/gFKxDaZcbJPUGeHdx72buArS3cTm8HOz/7AhlZsFI0lBZfaJ1DE9nI4e34ny0BQ/HcBwC8oBy5ljJjjHKjfOuAHpck2a9ffLrSIk9ERt4xFgodsp4v6rbRZJ0qGyoK4N0Q/S8uHTe/sF8eNuTsWixMN1vtPHpFPYU7WGmj9TbJqy1aGXtvI3hE6q0k7x2tigBxEokzIUzHiJjY2PAnUhISZpNJw07PH+avQ0RB8vTeAYdpfT9p/pgpof3srVuxfJyjdRhAmeBD13kKexeReYKAG1O4LFOaciViEFuxsSxKSyrnSyK4oCnd7MLOTo4H2vnoHU2vthD7LqU4
 BPERN/KA
 Pw83tcMz+dFmnI4Dg/fXANz0LgG63GX6h5bavp9yZrjkVSo4hvZObd6sCkEjR8x0sTFE02hpPj4tSFibYCJ7i4Dr0YHsj7OAxMsaHHM+FvDlxtkOuDCJ5oBlK0MwGiqlVpzt6xxZG3oEChNCVs4s/8k/AviTpr2amr0LTpHdR+kixFLOhmMkmH5YUepmcoq4DX3WJCgtHQNr6lEfgy4MmGismYkPBYiINXi6wsAXSgOSppqv7batAnUr0d83zBHtw3y5KKat44oWzteZP+E9ZZTB1MELGsqHPPQmwpSrabS4Jc/5MWOb1NJQ1gYvxd41ctKYXREzn30j1zzpiT+CaD9ljcJ2xhUqF50cnfXT3lsTvCLxpekcyUsOOsq9h0dyec/UIYNpglB3bMEgDF5pzpWbKzjgdBGmAqWdxwm4U5llEPiw+GzjmpB/3WwWzH71x33Tzk+CuXGm1kLXEAJr+71ucpeE/dHrzLyQ4vs6ppvs7hWaVb4JkwLQueG1E9COGYNuSx2yhCy2wh2YDltWHD60TBosER66fyUmWajBO3WGTW6pHLkwExMBSp2kOSDaf429lKVg1fYZTj89yRL1RM8GNBFZbLe6Zxz8oYUcgWVGnUWASfFtMAuz8WwNwYxbOuuIO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 2:53=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Currently the active/inactive LRU sizes exported through /proc/vmstat
> and memory.stat are derived from the generation window: folios in the
> two newest generations are accounted as active, the rest as inactive.
> This causes several problems:
>
> - Unmapped file folios can stay in older gens despite repeated use,
>   so active files can be under-reported, unlike classical LRU.
>
> - The reading is jumpy: on aging, the second-newest gen, previously
>   active, becomes inactive all at once, causing a huge drop of active
>   folios without any change in use.
>
> - The reading is reversed on swapless machines. When swapping is
>   disabled or unavailable, MGLRU ages anon by moving the gens directly
>   without walking or touching any folio, to reduce the overhead. So
>   inactive anon folios can suddenly count as active, or vice versa,
>   despite no change in their hotness.
>
> With frequency guided promotion, hotness is already tracked per folio by
> its referenced count, so we can do folio level accounting instead: a
> folio is active once its refs reach LRU_REFS_ACTIVATED (currently
> LRU_REFS_PROTECTED).
>
> On reaching this threshold, folios are accounted to the active part.
> On forced per-folio aging or PID protection, refs are capped at
> LRU_REFS_WORKINGSET, dropping active folios to the inactive part.
> Note that on swapless machines anon refs are not reset by aging (the
> shortcut skips the per-folio walk), but the counts no longer oscillate
> as the generation indices wrap.
>
> The accounting is now per folio and lruvec independent, so no size
> adjustment is needed when reparenting a dying memcg: the hierarchical
> stats keep the counts in the parent automatically.

I'm still struggling to understand whether the local LRU accounting
is correct here. But if there is a bug, it wasn't introduced by
this patch.

[...]

> @@ -4743,7 +4823,6 @@ static void __lru_gen_reparent_memcg(struct lruvec =
*child_lruvec, struct lruvec
>                                      int zone, int type)
>  {
>         struct lru_gen_folio *child_lrugen, *parent_lrugen;
> -       enum lru_list lru =3D type * LRU_INACTIVE_FILE;
>         int gen;
>
>         child_lrugen =3D &child_lruvec->lrugen;
> @@ -4756,8 +4835,6 @@ static void __lru_gen_reparent_memcg(struct lruvec =
*child_lruvec, struct lruvec
>          */
>         for (gen =3D 0; gen < MAX_NR_GENS; gen++) {
>                 long nr_pages =3D atomic_long_read(&child_lrugen->nr_page=
s[gen][type][zone]);
> -               int child_lru_active =3D lru_gen_is_active(child_lruvec, =
gen) ? LRU_ACTIVE : 0;
> -               int parent_lru_active =3D lru_gen_is_active(parent_lruvec=
, gen) ? LRU_ACTIVE : 0;
>
>                 /* Assuming that child pages are colder than parent pages=
 */
>                 list_splice_tail_init(&child_lrugen->folios[gen][type][zo=
ne],
> @@ -4765,11 +4842,6 @@ static void __lru_gen_reparent_memcg(struct lruvec=
 *child_lruvec, struct lruvec
>
>                 atomic_long_set(&child_lrugen->nr_pages[gen][type][zone],=
 0);
>                 atomic_long_add(nr_pages, &parent_lrugen->nr_pages[gen][t=
ype][zone]);
> -
> -               if (lru_gen_is_active(child_lruvec, gen) !=3D lru_gen_is_=
active(parent_lruvec, gen)) {
> -                       __update_lru_size(child_lruvec, lru + child_lru_a=
ctive, zone, -nr_pages);
> -                       __update_lru_size(parent_lruvec, lru + parent_lru=
_active, zone, nr_pages);
> -               }
>         }
>  }
>

The old code also skips updating the local stats when
lru_gen_is_active(child_lruvec, gen) =3D=3D
lru_gen_is_active(parent_lruvec, gen), as we skip
__update_lru_size() in that case.

But we do have some code in mm/workingset.c that relies on the
local stats:

        if (sc->memcg && shadow_nodes.memcg_aware) {
                struct lruvec *lruvec;
                int i;

                mem_cgroup_flush_stats_ratelimited(sc->memcg);
                lruvec =3D mem_cgroup_lruvec(sc->memcg, NODE_DATA(sc->nid))=
;
                for (pages =3D 0, i =3D 0; i < NR_LRU_LISTS; i++)
                        pages +=3D lruvec_page_state_local(lruvec,
                                                         NR_LRU_BASE + i);
                pages +=3D lruvec_page_state_local(
                        lruvec, NR_SLAB_RECLAIMABLE_B) >> PAGE_SHIFT;
                pages +=3D lruvec_page_state_local(
                        lruvec, NR_SLAB_UNRECLAIMABLE_B) >> PAGE_SHIFT;
        }

So unless the local stats are transferred elsewhere during memcg
reparenting, this seems to be a pre-existing bug.

It would be relatively straightforward to fix in the old code.
With the new code, would we need to account for active/inactive
pages on a folio-by-folio basis during reparenting, or is there
still a way to transfer the stats in bulk?

Thanks,
Barry

