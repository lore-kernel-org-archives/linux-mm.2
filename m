Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4A94C55182
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:08:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52C2B6B007B; Mon,  3 Aug 2026 23:08:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DDC36B0088; Mon,  3 Aug 2026 23:08:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A5006B008A; Mon,  3 Aug 2026 23:08:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F32CC6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:08:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2453160241
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:08:01 +0000 (UTC)
X-FDA: 85062102762.26.272A56F
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 113A640004
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:07:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sd0YKOms;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785812880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSNzasmmTYyegXobZuV2K5wekesCNXCb21wLakNRewE=;
	b=ayRDvSxcK2pyC7rvSV3Q2S8ExGJceEbnMpp7oCFqNK5v2u8kgLAr7PmYR64Mt8Vc6NwUW1
	+WooJSoCXWhGxLr2X+Lyr6Cr26RCDsu2Aap23xVNQV6ptiLlybwg8vATT/6wJ3N5oo2dCS
	MU3OOkxIeQN/o4C/rPd5HqEVHzVybvA=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sd0YKOms;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785812880;
	b=4MEk/d6qAxcIJgiuptOM2Z9GYNlugqydke8XSdvKy3JLG2XR4ZwVVLR2Y/NZggoe8tX9/L
	jsGU6NICZPFnW27hOz/eZu2Rqf+ZPNfCW1QEwAAsufGn+BwHdl3XfQew2pM/+MGs0mlzAv
	+LZvbo6VXkjtWupB+g3S2FqEqgMWSeI=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-69fab5a852cso5627613a12.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:07:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785812878; cv=none;
        d=google.com; s=arc-20260327;
        b=soGM2py7CK0DdrlPn4MJyUbg2fgcjMKX0jtCqwDgn1Nbpwk+F/qJOA5aWUyRiQp0x+
         L1I6gEQL02DGDqfCV8DpA/TysbSnIYcyBbJ0+yfn7R5tH+oj+jCX2j7UHqEKeCFYCROv
         g62BHeGQjKOFrlzqUTc1pkaKpXOQX8mEBuYhHzmzIZ38oAoHpKO7vzjaGzT8AOGnZtyN
         MLw//1JKaqth2WMueD/Hn4H/cDZhUDgCYPG3IoCEsXVj+ARJ/3NHFDZ3s+qWXHW2Th2B
         m+ZlLocPL4ygUXSPDn/+2xQpZR/Jq8KE13O3tOZ8x1cYpifvT+QI9u+hR9H2XCMbSCWq
         yIzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SSNzasmmTYyegXobZuV2K5wekesCNXCb21wLakNRewE=;
        fh=II3mZJY3BnWV7aGzSZnvZoU61Ladetd+m9CzlywGYZg=;
        b=XePnpMAgni8x6C1OZev+0Z6xtthtJ0ciUfwRyRB2swXq3pe/cj7C9jUzVXaDT80qWs
         78Obtv+T58HeGOoLltW0YQU9v9Ka2uoVtqHBTNp6gZgukl877bIwL5NVn7ZOv4gSye73
         mznYOAJMNF6T2LqtMzryIPPyZDrX3uF9uOB7R8JYseH7R1WfYAL+H7apVCm1BCm/m+37
         aFzIeNfwcgzC9bwYw0y0V9y+c2asAEegA1coTiOOFvPKdHHaKw3mQYQiet1i4QUmQfzB
         bnLKG5A7GIaBXBYTtgwXHMYAblE0HeIPQmaVpUdjPgoQnMPiHZj4OCHXwQD/uS52DS3D
         H8+w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785812878; x=1786417678; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SSNzasmmTYyegXobZuV2K5wekesCNXCb21wLakNRewE=;
        b=sd0YKOmsSVd3YlMAaBIIW9F17j2Yzg2wdFPmgFm07+CvHyyPCp9FrWf9VWluplpnwD
         Q9u31uPLAtKOTBYW6lOYih4bkqY7IVjA+9yJBP8Fcx/AFuYqC3+dmzZuQXtVGgIEfBTZ
         Sgao108NtIKKanZLNs+rKvQXP9nV0kWrpZKVqGC0ivMd9iFWG3Di6cgmz96Hf3t3olzI
         /tUolah5ORogIGgGcouqHktwjF3OwVA+Wt7TfDZiU2JSmt40YmrS4MMXoL01JinovBy5
         goggLnq3kWwbIt/TvyoP9KqsAHgybEV2RsoRn4MaNgGSdYVdMjdzpJLGnWITttH6wmpr
         LJig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785812878; x=1786417678;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SSNzasmmTYyegXobZuV2K5wekesCNXCb21wLakNRewE=;
        b=UuVJR1ZYTGZ4mZ2lAO/4yfDTl7SDGJew3bT5lzwtoXmLvi0O/8MBvMWA5NBcCXOSiv
         Ta44EVTYkv+jsJI+UxlSi66Dh0dP4g77zAE5AZ2ZC11MbexJSOeyfYrtZhm3XrckTq+v
         qM1isNKlGT0EhN7+GSJdAxJG5hM/K9sGzqiND/FD1seHk62ejNt1n5zQbQ539cjZbNK8
         d6C3zuvHVyrBeZY4Z9LH6dEjiXhFZviYKIBXot3UJvg+z7K3fCceO/trz4Znfe747FyQ
         zhyuZzxRKZY6bfmXXX441r+Zx55mJWgya+FJhYmxliKJ8b5AVE6RDqMCdhl9V5f8z0Ih
         PocQ==
X-Gm-Message-State: AOJu0YxndlwI+8y/XUzbJuTS1O+QRjuTDNpYwg/+N5yZAdf5zDF8qfXv
	2/U4L+m0/8JpbKy9EjWxPxzeQY5wqo7Ccq6kNfJu5DWG1JMuc98Sl1REZcpH9fhu5WdtgxDxvwq
	+IA2qKWOVNACFFZs45txzXJVrenENBVI=
X-Gm-Gg: AR+sD12S1jYYO/B9Ddc/ph5zB86QsMjhN3gXJVTnyJ79l/HUPMLY7pxyacafrJ+n2c1
	zqi0DuON43K2Oh4ma5o97yUP/7o7mts7DcGBrIe4VuwimbIbW6MJE3q7pR0gRE0WarDl6ctrCfS
	Pd1IAWYXcGcdlLngcwiQogYM3JuYWEEstvhTQpaI34dEfMP1eFbkCWQlF5y///csspeFpIzFNHa
	chTW1tKJcZ50wkfSPbuXB2ploGFASnk7oh8xe1jEJDYWpQ66rRsBzfTSCMeJFiqxTmgwhacAf61
	jJcspc7HxnUdMtXS9PvuB4xB0PBJnDq9BOs/vft2hyH7oMhm4+NWZ9C5hvI2JZGq5kHCs5SRIRV
	k7w==
X-Received: by 2002:a17:907:d09:b0:c20:2b23:71cc with SMTP id
 a640c23a62f3a-c202b2372e7mr41676866b.10.1785812878197; Mon, 03 Aug 2026
 20:07:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com> <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com>
In-Reply-To: <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 4 Aug 2026 11:07:20 +0800
X-Gm-Features: AUfX_mxLDAxbcZrL7EYWPUhuMXrQt62cceqHcQR2T0bfe55TgV-_Dmxaq3nq83I
Message-ID: <CAMgjq7A0FvEDfm_04EzOhK4XHMeKmSW82x8+zeyD6OO9DLJe7g@mail.gmail.com>
Subject: Re: [PATCH RFC 09/15] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 113A640004
X-Stat-Signature: 9qdp69pb41qpj1tqse6uhmfmmissefgx
X-Rspam-User: 
X-HE-Tag: 1785812879-496703
X-HE-Meta: U2FsdGVkX19nZElSz9sClyo3ZL+XCqVHMLGxZNu1q3p9CtNzFoIW+ZpaC8Vpa99IFXWzR6QeGoLoCTKISqXP8qYsUShW7O9x2RBShZt08vTQMiRWGVuCRbUn0LR5am7l1Q8sCAqzuSjshtWJomcc3takAoqFkCF/MTIbaAs6G/kbDizIDhVRXCzooazJQEbSS/jdQqJgbcAnaX4Io7psVkMjh+f7IUNAjfKcytCCi31G17UThn23Ye+scZ7Es78SxecgDgNq9UxuhI4A9KfawSe5EBKDSHZy9FEqB4jxFRlVjPSrzMcGK5k5IC9eNam3fKKaYJneQRAA/b4ETWGlfkxV9bEhIZDXA9kyzTfSx6MdhcR5iNQRqIa8CRE6oPQaigGvP5mz5DRDPym+K+wx3uSKFdYObwVv2Hg2jtHEIKI0ESdaYWnJRGTFZSlBbXPQXRM8CfkLflsjpykHKbIYj+JyNYR7gAAIpO2qmyk3hr9+ejd959z8Oo6IOXbghPfZipptAn6rXiw5sWFRXxlKzQfZroKDXUastmfUf7ewTcu+1ueKan5oLNXhFT+BTBivsvvNCM6yhNtkkEDXuUkA//nLYUaaLBDuF+6MeQS9/7p8J0ua0JL8HT/J7gL93w5hiHgMUA+6T3KbUQ0U/MTsrHeUL5pF1VHt7eHLync7Vm6PVzIRXgxdGBdTVuYrOXcxDbiE6SH9CsQV+ZpTF54jBlETgAwvzPGbquc2wz9uzKYBYMD4+3UGkuXpdQIcXSbQe95Tt6avchp58xhuMLNMxttc8Go6lH1wmxbC2PX3sWFfQq8eCyOjEaa7NfWfT26zGT5y5UWBugZCaEPsXJXN6wUjgUJfAQJ6K3OaWka/Qk2BD66Kti740eRlwBLpXOjvQ4f80xoIbz+H7neLznQgVon8RVfraVH4Ef2DzxbcwXoG6sQdYBhC+KamqvFgME1ctDEhBZiwXM6NdZhXDER
 PykjEpH0
 yRWN8ayI9b/XLC9p7zM/ywWT/Gnq8Mx4S50+5OiMzn+8HdIgJm9WuyWQk06u8LJmNXR2u3tbaZVd2Jd7OQvzxAVNVuBIq7psdsVVsMGs1wa/zWsOiZX2P0Jxm2UV5/TzprcDapIOpsx8q/zvQsAIxAy4AwOoSrGR7FLUn/zsH93tqPw6CEY9R0k70UrdQtHRNwIzLalCAgpL/g8bc7EYfL9qiD0Ca4RroY40+KneQ9wV9kWk0FLMZwofGdiqn6IDvH8igwMlREQfGoFfJU3/f2WR8347Ay7GCl36Ez+rLyucTJlwk9KhosNiF0dwH/ZjvzEIGEF3Q9m/ErL0IHO3CQ7q+pJupDYU33VcWgFZ0Chdn0S+hJ1p2LVX+xEaSBuVsocgsvygHdbHIss2+F3akNMhOhIBLTvQ0cQFCs6kDFfaa+c7WY91KgfhYFEOC+FliKgUWXe3v/sZ58CQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 3:47=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Complement MGLRU's eviction-time tier-PID protection with access-time
> frequency-guided promotion.  Introduce a unified set of helpers built bas=
ed
> on referenced (access) count of a folio.
>
> Each access increments a folio's referenced count stored in folio flags
> (refs), refs still mappes to a logarithmic tier just like before, but wit=
h
> more formal bit definitions, a few special thresholds are introduced:
> LRU_REFS_REFERENCED (1), LRU_REFS_WORKINGSET (2), LRU_REFS_PROTECTED (3),
> and LRU_REFS_MAX(7). When it reaches certain threshold, the folio is
> promoted proactively instead of wait for the PID controller to kick in.
>
> Also simplify MGLRU's usage of PG_workingset and PG_referenced, now
> these 2 flags are purely used as the lower 2 bit of refs for MGLRU. This
> doesn't effect classical LRU in any way. This will actually simplify and
> make MGLRU's certain metric reading more accurate, and reduced MGLRU's
> original tier / referenced count bit by one since only one extra bit is
> now needed to record a max referenced count of 7 (previously 2 extra bits
> are needed). This changes make sense because MGLRU doesn't have demotion
> so these 2 flags are never separately useful for MGLRU.
>
> This addresses several shortcomings of the old model:
>
> - Long feedback loop: protection only activated after enough
>   re-faults, by which time the folio is often no longer hot.
>
> - Limited tier resolution: once referenced count exceeded the bits
>   limit (8 previously), MGLRU could no longer distinguish hotter folios a=
s
>   they are capped by the tier.  And what's worse, PG_workingset
>   forces a folio to stay on tier 3.
>
> - Eviction-time bias: because PID protection activates upon eviction
>   and always targets the LRU tail, it tends to protect cold tail
>   folios at the expense of hotter head folios.  Once the tail folios
>   consume the PID protection budget, head folios lose their
>   protection.  Additionally, the PID cannot distinguish the access
>   time of folios that share the same reference count.
>
> Besides reworking the LRU_REFS related helpers and definitions, most of
> the work is done by the helpers below; the implementation details are
> described in their inline comments.
>
> - folio_inc_lru_refs(): Used by both cache access (folio_mark_accessed)
>   and page table access.  The folio could be off-list (isolated),
>   unlocked, or unmapped.  This helper uses PG_lru to stabilize the
>   folio and performs a speculative and lazy promotion.
>
> - folio_inc_lru_refs_walk(): Used by the PTE walk path during aging,
>   where generations are stable; performs lazy promotion.
>
> - folio_inc_lru_refs_isolated(): Used by the rmap check before
>   eviction.  The folio is isolated and hence this doesn't perform
>   promotion by itself; the folio will be added back to the right gen
>   upon return.
>
> The eviction-time folio_inc_gen() still handles PID protection, but the
> protection ratio is softer than before, and it caps refs at WORKINGSET
> so the folio retains enough history to stay above the cold tier.
>
> The PID controller gain factors in get_tier_idx() are also relaxed from
> (2:3) to (1:2).  Since the new folio gen bump paths already proactively
> protect hot folios, PID protection can afford to be more permissive
> without increasing the refault rate.
>
> PG_workingset and PG_referenced are repurposed as the low two bits
> of the unified LRU reference count.  LRU_REFS_MASK provides the
> higher bits.  This eliminates the old restriction where LRU_REFS_MASK
> was only valid when PG_referenced was set, and allows all paths to use
> the same encoding consistently.
>
> Hence, a workingset folio is now defined as refs >=3D LRU_REFS_WORKINGSET
> (2), matching the active/inactive LRU's definition and giving in-kernel
> consumers (PSI, readahead) consistent behavior on MGLRU, which will be
> done in later commits.
>
> Note that PG_workingset and PG_referenced are no longer independent
> flags under MGLRU.  Adjusting existing raw folio_test_*() callers
> to the new semantics is left as follow-ups.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h |  83 ++++++++-----
>  include/linux/mmzone.h    | 135 ++++++++++++++-------
>  kernel/bounds.c           |   2 +-
>  mm/folio.c                |  46 +-------
>  mm/vmscan.c               | 290 ++++++++++++++++++++++++++++++----------=
------
>  mm/workingset.c           |  55 ++++++---
>  6 files changed, 385 insertions(+), 226 deletions(-)
>


> +/*
> + * Update the folio's lru refs indicator without taking the folio lock,
> + * isolation, or lruvec lock. Used by both page table access (@is_fault=
=3Dtrue)
> + * and by file access (@is_fault=3Dfalse).
> + */
> +int folio_inc_lru_refs(struct folio *folio, bool is_fault, bool is_exec)
> +{
> +       int max_gen, min_gen;
> +       int type, refs, gen, new_gen;
> +       unsigned long new_flags, old_flags, max_seq;
> +       struct lru_gen_folio *lrugen;
> +       struct lruvec *lruvec;
> +
> +       type =3D folio_is_file_lru(folio);
> +       lruvec =3D folio_lruvec_live_get(folio);
> +       lrugen =3D &lruvec->lrugen;
> +
> +       old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> +       do {
> +               new_flags =3D old_flags;
> +               gen =3D lru_gen_from_flags(old_flags);
> +               refs =3D lru_refs_from_flags(old_flags) + 1;
> +               new_gen =3D gen;
> +               if (!(old_flags & BIT(PG_lru)) || gen < 0)
> +                       goto out;
> +
> +               max_seq =3D READ_ONCE(lrugen->max_seq);
> +               max_gen =3D lru_gen_from_seq(max_seq);
> +               min_gen =3D lru_gen_from_seq(READ_ONCE(lrugen->min_seq[ty=
pe]));
> +               if (gen =3D=3D max_gen)
> +                       goto out;
> +
> +               if (is_fault || is_exec) {
> +                       /* Promote second page table access or executable=
 */
> +                       if (refs > LRU_REFS_REFERENCED || is_exec)
> +                               new_gen =3D max_gen;
> +                       else
> +                               new_gen =3D (gen + 1UL) % MAX_NR_GENS;
> +                       refs =3D min(refs, LRU_REFS_PROTECTED);
> +               } else if (refs > LRU_REFS_MAX) {
> +                       /* LRU refs counting overflow, bump the gen */
> +                       new_gen =3D (gen + 1UL) % MAX_NR_GENS;
> +                       refs =3D LRU_REFS_PROTECTED;
> +               } else if (gen =3D=3D min_gen && refs >=3D LRU_REFS_WORKI=
NGSET) {
> +                       /* Defer eviction of just accessed workingset */
> +                       new_gen =3D (gen + 1UL) % MAX_NR_GENS;
> +                       refs =3D min(refs, LRU_REFS_PROTECTED);
>                 }
> +out:
> +               refs =3D min(refs, LRU_REFS_MAX);
> +               lru_refs_set_flags(&new_flags, refs);
> +               if (new_gen >=3D 0)
> +                       lru_gen_set_flags(&new_flags, new_gen);
> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>
> -               folio_set_lru_refs(folio, 1);
> -               return false;
> +       if (new_gen !=3D gen) {
> +               /*
> +                * Gen can only go forward, so concurrent aging is
> +                * usually fine, except when multiple aging increase
> +                * max_seq multiple times, new_gen may have go beyond
> +                * the new max_seq's current gen border and causes
> +                * hotness inversion. In that very unlikely case,
> +                * just activate the folio.
> +                */
> +               lru_gen_update_size(lruvec, folio, gen, new_gen);
> +               if (unlikely(READ_ONCE(lrugen->max_seq) - max_seq > MIN_N=
R_GENS))
> +                       folio_activate(folio);
>         }

So sashiko complained about a potential race here, which I suspected
but let through for this RFC:

lru_gen_update_size is lockless here, so if the folio is move between
active and inactive gen and a concurrent aging occurs, we might lost a
active / inactive counter update and drift the reading. The chance is
tiny and active/inactive counts are just metrics reading for MGLRU so
this should have no effect on performance.

On Tue, Aug 4, 2026 at 3:47=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Complement MGLRU's eviction-time tier-PID protection with access-time
> frequency-guided promotion.  Introduce a unified set of helpers built bas=
ed
> on referenced (access) count of a folio.
>
> Each access increments a folio's referenced count stored in folio flags
> (refs), refs still mappes to a logarithmic tier just like before, but wit=
h
> more formal bit definitions, a few special thresholds are introduced:
> LRU_REFS_REFERENCED (1), LRU_REFS_WORKINGSET (2), LRU_REFS_PROTECTED (3),
> and LRU_REFS_MAX(7). When it reaches certain threshold, the folio is
> promoted proactively instead of wait for the PID controller to kick in.
>
> Also simplify MGLRU's usage of PG_workingset and PG_referenced, now
> these 2 flags are purely used as the lower 2 bit of refs for MGLRU. This
> doesn't effect classical LRU in any way. This will actually simplify and
> make MGLRU's certain metric reading more accurate, and reduced MGLRU's
> original tier / referenced count bit by one since only one extra bit is
> now needed to record a max referenced count of 7 (previously 2 extra bits
> are needed). This changes make sense because MGLRU doesn't have demotion
> so these 2 flags are never separately useful for MGLRU.
>
> This addresses several shortcomings of the old model:
>
> - Long feedback loop: protection only activated after enough
>   re-faults, by which time the folio is often no longer hot.
>
> - Limited tier resolution: once referenced count exceeded the bits
>   limit (8 previously), MGLRU could no longer distinguish hotter folios a=
s
>   they are capped by the tier.  And what's worse, PG_workingset
>   forces a folio to stay on tier 3.
>
> - Eviction-time bias: because PID protection activates upon eviction
>   and always targets the LRU tail, it tends to protect cold tail
>   folios at the expense of hotter head folios.  Once the tail folios
>   consume the PID protection budget, head folios lose their
>   protection.  Additionally, the PID cannot distinguish the access
>   time of folios that share the same reference count.
>
> Besides reworking the LRU_REFS related helpers and definitions, most of
> the work is done by the helpers below; the implementation details are
> described in their inline comments.
>
> - folio_inc_lru_refs(): Used by both cache access (folio_mark_accessed)
>   and page table access.  The folio could be off-list (isolated),
>   unlocked, or unmapped.  This helper uses PG_lru to stabilize the
>   folio and performs a speculative and lazy promotion.
>
> - folio_inc_lru_refs_walk(): Used by the PTE walk path during aging,
>   where generations are stable; performs lazy promotion.
>
> - folio_inc_lru_refs_isolated(): Used by the rmap check before
>   eviction.  The folio is isolated and hence this doesn't perform
>   promotion by itself; the folio will be added back to the right gen
>   upon return.
>
> The eviction-time folio_inc_gen() still handles PID protection, but the
> protection ratio is softer than before, and it caps refs at WORKINGSET
> so the folio retains enough history to stay above the cold tier.
>
> The PID controller gain factors in get_tier_idx() are also relaxed from
> (2:3) to (1:2).  Since the new folio gen bump paths already proactively
> protect hot folios, PID protection can afford to be more permissive
> without increasing the refault rate.
>
> PG_workingset and PG_referenced are repurposed as the low two bits
> of the unified LRU reference count.  LRU_REFS_MASK provides the
> higher bits.  This eliminates the old restriction where LRU_REFS_MASK
> was only valid when PG_referenced was set, and allows all paths to use
> the same encoding consistently.
>
> Hence, a workingset folio is now defined as refs >=3D LRU_REFS_WORKINGSET
> (2), matching the active/inactive LRU's definition and giving in-kernel
> consumers (PSI, readahead) consistent behavior on MGLRU, which will be
> done in later commits.
>
> Note that PG_workingset and PG_referenced are no longer independent
> flags under MGLRU.  Adjusting existing raw folio_test_*() callers
> to the new semantics is left as follow-ups.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h |  83 ++++++++-----
>  include/linux/mmzone.h    | 135 ++++++++++++++-------
>  kernel/bounds.c           |   2 +-
>  mm/folio.c                |  46 +-------
>  mm/vmscan.c               | 290 ++++++++++++++++++++++++++++++----------=
------
>  mm/workingset.c           |  55 ++++++---
>  6 files changed, 385 insertions(+), 226 deletions(-)
>


> +/*
> + * Update the folio's lru refs indicator without taking the folio lock,
> + * isolation, or lruvec lock. Used by both page table access (@is_fault=
=3Dtrue)
> + * and by file access (@is_fault=3Dfalse).
> + */
> +int folio_inc_lru_refs(struct folio *folio, bool is_fault, bool is_exec)
> +{
> +       int max_gen, min_gen;
> +       int type, refs, gen, new_gen;
> +       unsigned long new_flags, old_flags, max_seq;
> +       struct lru_gen_folio *lrugen;
> +       struct lruvec *lruvec;
> +
> +       type =3D folio_is_file_lru(folio);
> +       lruvec =3D folio_lruvec_live_get(folio);
> +       lrugen =3D &lruvec->lrugen;
> +
> +       old_flags =3D READ_ONCE(*folio_flags(folio, 0));
> +       do {
> +               new_flags =3D old_flags;
> +               gen =3D lru_gen_from_flags(old_flags);
> +               refs =3D lru_refs_from_flags(old_flags) + 1;
> +               new_gen =3D gen;
> +               if (!(old_flags & BIT(PG_lru)) || gen < 0)
> +                       goto out;
> +
> +               max_seq =3D READ_ONCE(lrugen->max_seq);
> +               max_gen =3D lru_gen_from_seq(max_seq);
> +               min_gen =3D lru_gen_from_seq(READ_ONCE(lrugen->min_seq[ty=
pe]));
> +               if (gen =3D=3D max_gen)
> +                       goto out;
> +
> +               if (is_fault || is_exec) {
> +                       /* Promote second page table access or executable=
 */
> +                       if (refs > LRU_REFS_REFERENCED || is_exec)
> +                               new_gen =3D max_gen;
> +                       else
> +                               new_gen =3D (gen + 1UL) % MAX_NR_GENS;
> +                       refs =3D min(refs, LRU_REFS_PROTECTED);
> +               } else if (refs > LRU_REFS_MAX) {
> +                       /* LRU refs counting overflow, bump the gen */
> +                       new_gen =3D (gen + 1UL) % MAX_NR_GENS;
> +                       refs =3D LRU_REFS_PROTECTED;
> +               } else if (gen =3D=3D min_gen && refs >=3D LRU_REFS_WORKI=
NGSET) {
> +                       /* Defer eviction of just accessed workingset */
> +                       new_gen =3D (gen + 1UL) % MAX_NR_GENS;
> +                       refs =3D min(refs, LRU_REFS_PROTECTED);
>                 }
> +out:
> +               refs =3D min(refs, LRU_REFS_MAX);
> +               lru_refs_set_flags(&new_flags, refs);
> +               if (new_gen >=3D 0)
> +                       lru_gen_set_flags(&new_flags, new_gen);
> +       } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>
> -               folio_set_lru_refs(folio, 1);
> -               return false;
> +       if (new_gen !=3D gen) {
> +               /*
> +                * Gen can only go forward, so concurrent aging is
> +                * usually fine, except when multiple aging increase
> +                * max_seq multiple times, new_gen may have go beyond
> +                * the new max_seq's current gen border and causes
> +                * hotness inversion. In that very unlikely case,
> +                * just activate the folio.
> +                */
> +               lru_gen_update_size(lruvec, folio, gen, new_gen);
> +               if (unlikely(READ_ONCE(lrugen->max_seq) - max_seq > MIN_N=
R_GENS))
> +                       folio_activate(folio);
>         }

So sashiko complained about a potential race here, which I suspected
but let through for this RFC:

lru_gen_update_size is lockless here, so if the folio is move between
active and inactive gen and a concurrent aging occurs, we might lost a
active / inactive counter update and drift the reading. The chance is
tiny and active/inactive counts are just metrics reading for MGLRU so
this should have no effect on performance.

I'll need to figure out a way to fix this, hopefully without any lock
because this is a hot path where overheads are critical.

One idea is that we directly jump to the part where we decouple the
active/inactive counter with MGLRU's gens (I mentiones this before
just didn't post any code about it yet)? If you use MGLRU in a fleet
you should already have noticed that the active / inactive reading is
almost unusable, because MGLRU's aging moves folios in whole
generations. Because the active/inactive count is bounded by
generations, you will see the numbers are very "jumpy," and almost all
page cache is always reported as inactive since the PID can only
promote the page cache to the second oldest generation, which is
considered "inactive." This is incorrect and breaks things like
cAdvisor in K8s, which uses the inactive reading to determine how much
of the page cache is actually used.

So instead, if we bound active / inactive with tiers instead of gens,
all the issues are gone. I planned to do that later, but if everyone
is OK with it, we can do this earlier.

Or else, some fancy atomic / barrier might be needed, I think that's
still doable though but kind of complex and maybe ugly.

