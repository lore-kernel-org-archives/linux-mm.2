Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A7A4606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 08:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MEeabT6B
Received: by kanga.kvack.org (Postfix)
	id 9DE7D6B05B0; Mon,  9 Nov 2026 03:08:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6706B05B1; Mon,  9 Nov 2026 03:08:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A7AE6B05B2; Mon,  9 Nov 2026 03:08:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB136B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:08:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4B401405D9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:08:52 +0000 (UTC)
X-FDA: 85414854504.01.8C945EA
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf08.hostedemail.com (Postfix) with ESMTP id E4B5F160002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:08:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MEeabT6B;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794211731;
	b=IRu3p9lg4vbqdRqBwUOezKud5dj4gPvm9Y/A6S+ssk8Coop4qxEgvgOmiPlXTZwgMFynZr
	oGmGKkS1dtViLYyVhPMIj71mnA0skGDWsCCmfAHs4Ec0faMp/UX1bH+qJ0CYKLej38BlHS
	kOCTUAl2A8yTrQN5aiPRSG26XeJB5pY=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=MEeabT6B;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794211731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LiMJF1XvwF+Qc5jdWubo4n2qJDpryfHhpNFCa3GO55Y=;
	b=HH/mWvQLZhieKcS3pCeQeMGVD2ZHq7Vyj+7f0q4VVynU6LpnNBJ7/H0/4brS38qb+Ti2T0
	r0t9fdnsoHrHlgMJFpfH20QuD2F7eQiKNsfbVdpUTwHFOffvCIXLxEdm+HfemYpNesGbIm
	0PWg0KuMt8I6J/O4j/5iR321XNh+WMI=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c247f6687dcso94079266b.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 00:08:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794211729; cv=none;
        d=google.com; s=arc-20260327;
        b=POD4S29NM5nvwh8JZSt8GJEkcxwZjh6FwuqRuIWSVMAOI0RzRbmGIG7d4AHwX7FLIi
         dvrpeXIV75SVjpCitY2pPzw0swm+Y2qupNv9gTCcwjhnia97AjW3KatRGkAzHEwT7rbU
         8+5ArTkhNUSUfJfEXra9XqDmGWaJGfNbs+HnxkJQ0bh229iofKAd8GpQbdK/1ytJ71D2
         qyYkbc7K4wrzQtusjCWqsWxN4hvFigyERDPaLtueyKdoYLMZe0vs1TJAuEehAawLpGUF
         j8hQdEE2kRRjXArN8K3rb1v0okJWYg0ujWonK2tGaqV6uHuqzAskt+MYS5ibaAyYm1Zi
         uKtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LiMJF1XvwF+Qc5jdWubo4n2qJDpryfHhpNFCa3GO55Y=;
        fh=BRswjrorPDJe59NAr7GLmCZa8wmOFuh7SgJhqrtZ+lE=;
        b=MQecyGcDWYEY5m2dW6q/XpBlsX/BSjjklKbUrSA6ZReeUF6k4+6BRpDlPU5oU45sli
         +04yzELfpNxaBqh51moM+arr6Ue2LGgYNSfmyAanOP6zhCg2Q3TXXYZh0uAy1Az1C8YO
         EkGUNa819ubxCGUkf0ufnHYj5bH6Xp6T0NzaCwNGGyeT+WnC9aSYV5M3IzPdxjfaUZ1l
         aDWF4IZhaypuNfgYfI32uQ8v9nJMiz+fsYLkVGF2uCxHNf2JcPiiizSuGusBUIHVeB3w
         MrTgujAwYjLG8keJh4ZkUTIRVctV2ZiRZTcTsVRGXWEWGc+2ArjFLIPOZOEXtezGcAcv
         MhTQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794211729; x=1794816529; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LiMJF1XvwF+Qc5jdWubo4n2qJDpryfHhpNFCa3GO55Y=;
        b=MEeabT6B+yVfomyGKWfbXaSFGslj9PVbQT7g7Tbt3w8b3ZcGuNtyFSprTUuGr5D+J/
         luifKsi1/ou2U6LnGE/aCVGundMg1wm4JAX9QF7Ulod7nhptl8gdSJQSux82r1/hqWL2
         qhVCGNy7ZwjGs/2U/2/f0cAVv+Xb3GT9DQ5OCVc6cE5hmG7RYg3mHJlwOZL4UfnxV9um
         KgJE86qtx8wY6kRLyRIEgAI/wbFdLKFLe3XAz97YV0lApXpSHbPPL5zIXuYbBAjS0Aot
         jRjDOQSVv8xXk9pBTNi3l2EQUxfiXGxnq/mvSRJuQw4ccfM6ErVFxI4ILFGDuqCy60Dl
         Ri9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794211729; x=1794816529;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LiMJF1XvwF+Qc5jdWubo4n2qJDpryfHhpNFCa3GO55Y=;
        b=ftseaQvUnKKOq4mLs98pVvYpvNiXxnOqtxkAz/lOZt83hG5CYaGqlLjhsVfqNXW0WA
         sYLKTubn7P8LA7HokBgntPqc6hApYWhnjyq1lOczUG3E4Uv1/+P/GLXigIsNuwa6KMEP
         wa+wFquP8260qXyUEoU+//VJDGF32l/8XSq42/FL/+lObhsAhaFcknHbddoK5HwFF+KU
         me/fVnno7zPVHpkU0VGDtReWopRnQy4QmNAVbVk2s21Ol8d5G2sdYCo1jceTxnETlia+
         ZWQcj+t1qnLNOjWE5MB9iGVFjZ4NGD3+qFzr5SrlL19uUGAZSCB2SpCP0fQDv4ybAw/d
         9WQw==
X-Gm-Message-State: APuU4Z+vAGjEJDNhZLu2priYFKqM0r6hu7dEPM7ZSY/k4mpsZTRAuJq+
	HyTA4h+bj/7BV3AfS32a4dlIVDiQ9yDD+r706WebneoHvIfDehwkN4IH+5jmfbqpu84dQp9Pdpx
	Dx7Q8w6wmk7iVKNkWgh9lP+6ygyz+e9M=
X-Gm-Gg: AYBFou1aaLx0HUAb53TPzybNWFlLsdhihIJ+WypXUw6K/9aonC/bTxIUIecMMcPSu0T
	Aa5covn4I9bgdgeD31GxDWiCvxAoV7bPcyHNaQn2EH1oTkJ7AYhOENCp1Be9on9Sw1UuJCDjB/U
	KZiHqGFFNTFMyfsqx/AE5+rW5e8KcyIiisfCc6HLEj3/YiRMzu331Q0GU7N2kB/jALi0Xiz3ayI
	vMKbu/lLD4W9ulmljktvG/Y7YQaDfrtQtTpxmhtJGes+Ico2OM+9NmSPSGtgPKv5tl1v8X3poMU
	oVKQ6nRBYe4hM3e+o5Qt0MaiXKJ6snsSVWmHM3LbxVnNl106qXozaBgfv2NcvzYsw0azHKtGmsf
	iMURus4a282htIdyUixsr55QOZIq2717j9baAvUoJ09KzFPABjsNX9vgELYEs+9c5zaFi
X-Received: by 2002:a17:906:d54d:b0:c42:4750:8d33 with SMTP id
 a640c23a62f3a-c4d6d79c9e9mr220208366b.28.1794211729178; Mon, 09 Nov 2026
 00:08:49 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-15-2106750c0bfa@tencent.com> <CAGsJ_4wTFHJxzuiRDBcuevdULMcD+se6SuPbzWKA8wsUAG80_w@mail.gmail.com>
In-Reply-To: <CAGsJ_4wTFHJxzuiRDBcuevdULMcD+se6SuPbzWKA8wsUAG80_w@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 9 Nov 2026 16:08:12 +0800
X-Gm-Features: AclHuK-rg_Epjx8c_oIR5RKRDfprNqzR2T_gknTk1R87bd-Y63IPVOAg_lUq4r0
Message-ID: <CAMgjq7Atry0zRc_-xbrL_VubxTBQOT8R2_aumghXQaO9uTANHg@mail.gmail.com>
Subject: Re: [PATCH v4 15/17] mm/mglru: make folio_inc_lru_refs lruvec lockless
To: Barry Song <baohua@kernel.org>
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
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: en7i1kfjq1344h873p1rfnsbkfttgoqq
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E4B5F160002
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794211730-227136
X-HE-Meta: U2FsdGVkX1+6fOHt7HZYu4KucGqaHB21pRteMPWllRTLGc3L422uU0+08SMk/CYMSht9ClhaAoaJIRKi3wuaFE91CxN8mFZSqacy+G+icsCyIJgsEThMXfgY7dh0rS/YKgIVR5IDrXonO3G57V0DkOKBaswBwNWGJefnCVohoYWxGbR5Wxpb9ArBVjnsxBIMtD+jCWc9AOHd5YS+hBu7QHDPzk9GNJbafeRFRAeLHqfUUMCWRDBK6g41RQHV8yreETtcLDFeW+DuBl+4zfU3IMfTnLui6azpejUnU/7iVPL2nIAU2qP0ZZhn+1kuGttIfZOFREYCB5Ae23R7dOx5nGoB+hk5VLojpaAcyu660RN28UQ60Uoox8Re0KNznBkS5cJONssfIIiQ3paQW52UXzrVItpe7HbTpKlg6F5FS66dBdTJEAqcMR9dF712Dr+8it0q4h/zvU9xrpluGipLGf+dyN6Ui2wrqfKKdvUwsojoE8a2/z31pBAgfGOuv6wQqdWARGjoFYWUpYezztaNZuFm0NLjj7AgeE8KHdF1LmIN6qCh5q492l0KFU4O8GlQZRgeRWcmvvQoD7h62BbcTfHxN4MeSO7Q7stImJrLLHOuK0VkH6aKH9eJkWDSZc7ei647hz4i+wC44xym3+bK1nlv6TK5DOVsMghC9sLzYomkbVsiRO+sw2Rx354Vlk3frvKg/EmSSf2Rnnwl9tZGL08ZriyhQsXngvrdx5XkCOUJuWMtJMejxwHpW1EU3EcbyCsCRNv6sKbl4UoSDnKBGKG2wxojGaYgHgHaZQBPpHG8spx48KyxyYX+zhTQRXzCq6CYrI3KDRUXp3wvJ2jpcQ9yG6r7cCH/3cVa7i6d3iTGcrEirfuYyYqG56Uii/uXtbkV4jhjNnwplVx4zxlVxhaix3f/VZ95xMV4KZtSCEY9aDDPk6Ff7OW4SuclgthlrRYL5ZDlKDxYM7jT/75
 zmBCFNnf
 2vt68KeN6rl5wk1JheAzRddOTILwIusX6G3dNTNQLp9juAcq/60Iba861fsJvRu++horeMVXXVk/EzmWRyfCTY+iCjPIHiL0g6l+2cyly7B8qddU+bPqEdb1+PRwFYy8r2R7FO3UXJANfyPW//mwDAhFWurqdxQDSgjLHhep3hwRgG4afx0fF+a1tyvGGNAj03rxzsFoBEMVcKJ0s66CHmei2H/ZB4C0S00cjdA0BloQ/6txqKb8H/aYtjAMFpm1JzAAHbbxSWEK/8OfiJl01iCiGlpJarXBA3wodrElHW49ylv18kdc61UXG7vtQMpMlAVmJ6nFqxxTV+Z748zWYJgNx5147Kw5seVh8L50o6DGsHvf2YQI0cwYlXuldeKgJJjNM9OeHYpNb95QOC0bTjSxgxZKipbnuRfkwhjLRQob3cW7kthtdXEcZSlxfbsSKAwhrXdHNXj8MoOCrZb7pItnkHQqYKY6N0FfUad45XZhR6lG8pszLFpn4BmtRbf1LMaM/dE6br7ZhVTwxZaVVoS0fBbH/AEU0LrVNP35gO/E+7/sftxD0kIzv0NMO2OV9ljTb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 9, 2026 at 5:48=E2=80=AFAM Barry Song <baohua@kernel.org> wrote=
:
>
> On Fri, Oct 16, 2026 at 2:16=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > The lruvec spinlock in folio_inc_lru_refs was only taken to keep
> > concurrent aging from corrupting the size counters.  This is no
> > longer needed: the per-generation counters are atomic, and the
> > active/inactive ABI counters are updated per folio and linearized by
> > the CAS on the folio flags, so concurrent aging can no longer corrupt
> > them.  The same argument already allowed folio_reset_lru_refs() to
> > drop the lock.
> >
> > Use folio_lruvec_live_get()/folio_lruvec_live_put() to hold the RCU
> > read lock around the lruvec lookup, and drop the spinlock entirely.
> >
>
> Yes, this is cool. We have two paths calling
> folio_inc_lru_refs() or folio_inc_lru_refs_walk().
>
> 1. folio_mark_accessed() from syscall access
> 2. walk_update_folio() from page table walker or look_around
>
> For the latter, we can't actually cross multiple
> lruvecs/memcgs, because of get_pfn_folio() as shown
> below:
>
> static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *=
memcg,
>                                    struct pglist_data *pgdat)
> {
>         ...
>         rcu_read_lock();
>         if (folio_memcg(folio) !=3D memcg)
>                 folio =3D NULL;
>         rcu_read_unlock();
>         ...
> }
>
> Consider a common library file used by 100 memcgs, with
> its folio residing in the root memcg.
>
> When walking the 99 non-root memcgs, even if the folio
> has been accessed, we won't get a chance to call
> folio_inc_lru_refs_walk() for it. As a result, this folio
> may eventually reach the eviction rmap path. With a high
> mapcount, folio_referenced() could become quite
> expensive.
>
> That's what I was trying to point out here as well:
>
> https://lore.kernel.org/linux-mm/20261102213915.57805-1-baohua@kernel.org=
/#t

Hi Barry,

Thanks for the review, I saw that too, very interesting approach! And
I believe it will helpful.

> For the former, you can get the lruvec with:
>
> lruvec =3D lruvec_live_lock_irq(folio_lruvec(folio));
>
> I'm wondering whether we could eventually unify them
> so that both support cross-memcg inc_refs.

Definately, actually for that link you posted, combined with the code
snip above, after FG, I think we can further simplify that, no need to
check mem_cgroup_is_descendant, we just do:

- folio_inc_lru_refs_walk: if the folio belongs to the lruvec being
walked, the batch stays in walk->lruvec
- folio_inc_lru_refs: if the folio is a remote one, per-folio, no batch

non-descendant folio sharing across memcg are actually quite common
e.g., libc and shared mapped memory, this could be more helpful? And
it seems fast for the walker.

folio_inc_lru_refs_walk follow the same rule as folio_inc_lru_refs
(with MAPPED flag), just faster, skipping RCU and the speculative
check afterwards as the walker owns the seq it is advancing, and
caller handles the batch update of counter. While folio_inc_lru_refs
only requires the caller to hold an reference to the folio it heavily
relies on RCU / CAS conventions, not easy to batch things there, but
it's still accetablily fast already (e.g. the fio read test showed
almost no performance penalty).

And I think the main reason MGLRU can't operate cross memcg was, lack
of a protocol to stablilze the memcg's gen and holding a lock is too
costly, now folio_inc_lru_refs handles that, and FG
 lives on top of that. So we can try that out right after the FG series.

