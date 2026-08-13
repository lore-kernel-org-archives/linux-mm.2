Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B9FAC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 22:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F17FE6B02CD; Thu, 13 Aug 2026 18:38:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA9D36B02CF; Thu, 13 Aug 2026 18:38:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D713D6B02D0; Thu, 13 Aug 2026 18:38:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA8676B02CD
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:38:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 29B4F802DC
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:38:12 +0000 (UTC)
X-FDA: 85097710824.13.0B98E57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3EF7D1C0007
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:38:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kp/dh28N";
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786660690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/LqEmxpPwrLgwTd9RsN6GwpBP97Mg4t06WVKzlbFZTk=;
	b=7FOc0A0jzi8p9sLKzO0pfL8l7caBtMOBh6cOOaouoeH1biuGL8J6hDOAHFnEXR8TLrH4NL
	1epUj5SGxVfobK4xoJ/10aBBixmJXGn0jswQUvFDRpgJ6vB5TNhrvjddNR4tY/tGbfktfb
	KrrPLPR1qhhDznpUd2fyzZq839RFM8Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786660690;
	b=5t4AQ2R1nNUxUQsJKXIl0K1f6FDMb8Zb6VBW0+c9yEK2DK302nernBwag0qxJHqrQKgdhp
	4DjAwYsSD8iKtmrSz5uXUVsKu4so+FVqbAuagLYeLoYv1GnEb2jW0aw0Qy5Z8rHemCTso9
	R0Tup9jcX9CNao6v3rjKpU9lIZAeo8Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kp/dh28N";
	spf=pass (imf21.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6941C43CE5
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5F11F00ADE
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786660689;
	bh=/LqEmxpPwrLgwTd9RsN6GwpBP97Mg4t06WVKzlbFZTk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kp/dh28NxoPeZsol81qGOsY7xIOi5bgfN04MdH1Om6axJHrhI54QoHihGzegd03kA
	 Zb2NfOLwp15iWgoAbh2Q1s+cyB4TwpjdfJ3CGj7FAEECgRPETDGTpQWC1AL9fR6Lz1
	 0MBMl47jfE0/Tgv0BzdmO7btrC94OMwPIg8uwpQY9SBLhWh19ZW/scvnLOp7ea4DPR
	 KHU4M3/RGRVAqUnaeSLCsTcduXgLYNLTP51LM7LH2x847vs8XZZCPHvdoBzpgtUtjb
	 i5OaVg4Ys4ErcvaKwd6BG/vf4TR9Bp6zUzpRRs7SjGSfO5gjAtlMWSsDRPoLyAMkvG
	 2RV4AukM7wceQ==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-907ae240ac3so2188916d6.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:38:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rqgyla8LUAdgrOm46GIwBOKUqCG/ahY/OJlCAKWXZO24Ji1tASv0T5IMfH+DlrpQ2yKZTWdlAmjWg==@kvack.org
X-Gm-Message-State: AOJu0YwW9nMuMz0jD+hDtcFLmPjUJNDWlXHXmHMNe+AyUlT7S59CuJL+
	/oZxVaIpzoPVs2YALx/WC1fI69nwkAnzg5RUB/H62gPr2e9BxMrE7342YbAle9smsx/Q7tnpvJE
	oCPQL+qk70NteJ67ezGDIUvx+Bee1pBU=
X-Received: by 2002:ad4:5d61:0:b0:8ee:cf22:88f1 with SMTP id
 6a1803df08f44-90a91d650camr13069416d6.17.1786660688345; Thu, 13 Aug 2026
 15:38:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260723045718.2052070-1-ridong.chen@linux.dev>
 <20260723171842.137e45eb36b21b3b45245da0@linux-foundation.org>
 <8336e48a-ab3a-4db9-a7f9-5bb6af2b22c3@linux.dev> <CAGsJ_4xPw24afGLZH6Qh5rxOts37SCpmBVeB3gGntk1QQuSCow@mail.gmail.com>
 <24b9f213-96e8-4eda-a20f-8746d7c399b7@linux.dev>
In-Reply-To: <24b9f213-96e8-4eda-a20f-8746d7c399b7@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Fri, 14 Aug 2026 06:37:56 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xCi1TzV0sg=8ZFhfAq7v=k=Q6a10DNDouYOrjcJL-5=A@mail.gmail.com>
X-Gm-Features: AUfX_mzxj7IwBhL5GPyEcNHh14T7Jijh6fXojasM9ALS-3KIXNrDdRYdwoo8O1g
Message-ID: <CAGsJ_4xCi1TzV0sg=8ZFhfAq7v=k=Q6a10DNDouYOrjcJL-5=A@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] mm/vmscan: fix swappiness=max and clean up
 per-node proactive reclaim
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Zhongkun He <hezhongkun.hzk@bytedance.com>, Muchun Song <muchun.song@linux.dev>, 
	Davidlohr Bueso <dave@stgolabs.net>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: trn6auniieztjbwtb5e3t7o9uwo7zfdu
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3EF7D1C0007
X-HE-Tag: 1786660690-795960
X-HE-Meta: U2FsdGVkX18vbAyKBQs5uZYyAEGuWVMGByllTok3hYXdl/6yR+o0egLgkgq6msM/lBA5tuPYuTsqlZgrXeriFNhMio84g/kL9sT78li2wV/qUPd9ZPMtwQmHc/DgPkdpc8GajIRAFEobacpilX/QbdPWqlOaUeCCaJ6hu1kTVkm1mHebZeEytgK9f+jeBkZ/SC7CDVNlCGbvfLuBuo591U5A0oYOXveobxoq0h/IDIGRnDmINFiuu1/atGvCXrMtQ3AgwMVxXYK2bawb+VX6pAVWTWA41qW4wsyWGJudx8VhuYzDMYpmctgSgKb0taKsJSKkrs0LPAhUZRyl28oLRgy0YMBdFX2OxU5XEZEjMWMn60eX3W6ZV4EvXI7Rnmkt7oCsliNgNlQXMpDtgbnxfY4vCtgIAY1rP7MIzO0We9HVRy+ZHx5FmrF55feitTq2js4d1+Whkm8hnd0nuRVe7wKtjzEG0+8VkGTW6aWPY8mX2CLI3oo5j2AKUOvbXgQ7OqOwx0ry8pchWX8xcpzEGyyf8BPWDPCWsAZZf0PaY7DltXXveiznnerWXPH41YZCAmBOyHH6ub5gXPLDl3dA4Y/WbEbp5Uc+7XIYorL35bSpBcX75R9a2tL2rCytY3zx4bEB1lrL19ljGeZNYAr+RSGq/QfuBWF0iGB2oIqh9/RTtbtU9PVBsBVW1+qYII8jJ8BcZuC7hxMDO2p8KafCleAHNNM5FY7v0osK/BCK88JgL9/0YAzcyxTylY4do8KaZ34tQWiYaDCiUADqWHhserQiXErQzstYPvdU1bxvGoxoJCx5bs+sh2zS6Ee5JEdMhV7GO636XUdmpPGEyt4qqbg/aklKpbIZI+iREsbvnuq8EshH9MtuLAekLwFgqf90f7Xm1Zg3rhtszU5XOmPOM3JJD/v/Djy7wuLCXhEPVVKq9Idj/AkWw+yWmDMR5lgxmwNc3YB/NmdnAVCodGm
 apwWx5oE
 FoDF454QvD37VOp83aOaTKg38iJdN5MqrZt5AWTWZuCpI2/Nn+/pLJMZ/M80puDB+Ili4PLi7muzxLanwBkMebwIFZvYB6nP98tYFiCQifdfB2kb59hjHxKBtYBR5GmUl/wHjJB9tGmlESC7u6+l2h39D9VRPICKFhXjoIojjhXMfKSkiIpzKwF5ZA24n6BUT/i7K80mJImuuyDh+/7rWN98ocCMI8VrsoWQGXHHbG+bzs3LDg49sZPgP0K8O5U5nkyyuufArCe03adqmGvzDSgv9DoC0ujbhWdJRP2rnSVnNGT6ZpeMrWcboBFs+6ZtY1f+OR4Cxo6h+rENPSlIoaQ5YYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 4:34=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
>
>
> On 7/24/2026 7:12 PM, Barry Song wrote:
> > On Fri, Jul 24, 2026 at 10:43=E2=80=AFAM Ridong Chen <ridong.chen@linux=
.dev> wrote:
> >>
> >>
> >>
> >> On 7/24/2026 8:18 AM, Andrew Morton wrote:
> >>> On Thu, 23 Jul 2026 12:57:14 +0800 Ridong <ridong.chen@linux.dev> wro=
te:
> >>>
> >>>> Fixes and one cleanup.
> >>>>
> >>>> Patch 1 fixes "swappiness=3Dmax": the anon-only test in get_scan_cou=
nt()
> >>>> sat after the "cannot reclaim anon" check, so when no anon was
> >>>> reclaimable the request fell back to SCAN_FILE and evicted page cach=
e
> >>>> instead.
> >>>>
> >>>> Patch 2 fixes reclaim_store() collapsing every error into -EAGAIN, s=
o
> >>>> callers can no longer tell an invalid argument from a busy interface=
;
> >>>> propagate the real error code, matching the memcg path.
> >>>>
> >>>> Patch 3 drops the now-unused gfp_mask parameter from __node_reclaim(=
).
> >>>>
> >>>> Patch 4 fixes the same "swappiness=3Dmax" issue for MGLRU.
> >>>
> >>> Thanks.  AI review might have found several pre-existing issues which
> >>> might interest the maintainers.  Also a suggestion against your [4/4]=
:
> >>>
> >>>        https://sashiko.dev/#/patchset/20260723045718.2052070-1-ridong=
.chen@linux.dev
> >>
> >> Hi all, sashiko review:
> >>
> >>     This is a pre-existing issue, but I noticed that per-node proactiv=
e reclaim
> >>     fails to reclaim memory if the node's unmapped file or slab pages =
are below
> >>     minimum thresholds, completely ignoring anonymous memory.
> >>     In mm/vmscan.c:__node_reclaim():
> >>          if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_p=
ages ||
> >>              node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) >
> >> pgdat->min_slab_pages) {
> >>     Does this condition incorrectly block proactive reclaim of anonymo=
us memory
> >>     by applying legacy zone-reclaim thresholds?
> >>     It seems to bypass shrink_node() entirely if file/slab pages are l=
ow, even
> >>     when sc->proactive is set, which could falsely return -EAGAIN to u=
serspace
> >>     for anon-heavy workloads.
> >>
> >> Should we add:
> >>
> >> if (sc->proactive ||
> >>       node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
> >>       node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min=
_slab_pages) {
> >
>
> Hi Barry, sorry for the late reply.
>
> > Nop.
> > I assume reclaiming file cache and slab becomes problematic when their
> > amounts are already very limited, so we should still honor these two
> > checks.
> >
> > Maybe we could relax them only when swappiness =3D=3D 201
> > (SWAPPINESS_ANON_ONLY)?
> >
> > BTW, for global proactive reclaim, when setting swappiness to 201, does
> > it prevent slab shrinking? If not, it seems problematic when
> > node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <
> > pgdat->min_slab_pages.
> >
>
> in __node_reclaim, we will shrink the node when
> node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages, even if
> node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=3D pgdat->min_slab_=
pages.
> This means slab shrinking can still occur even when below the limit (sinc=
e
> shrink_slab is called unconditionally after shrink_lruvec). This is not a=
n issue
> only for global proactive reclaim.
>
>
> > Your recent patchset prevents all file reclamation when swappiness is
> > set to 201, so we only need to check whether there could be a slab issu=
e
> > before allowing shrink_node() to continue in this case.
> >
>
> So can we add just like?
>
> if ((sc->proactive && node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B)=
 >
> pgdat->min_slab_pages) ||
>         node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
>         node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_=
slab_pages) {

I feel both pgdat->min_unmapped_pages and
pgdat->min_slab_pages are quite broken in mainline.

For example, even when the page cache is below
min_unmapped_pages, it may still be reclaimed. Similarly, slab may
still be reclaimed even when it is below min_slab_pages.

Also, when both the page cache and slab are below their respective
thresholds, node_reclaim() may reclaim nothing even if we have
plenty of anon folios available.

        if (node_pagecache_reclaimable(pgdat) <=3D pgdat->min_unmapped_page=
s &&
            node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=3D
            pgdat->min_slab_pages)
                return 0;

For example, if slab > min_slab_pages but the page cache is below
min_unmapped_pages, we still reclaim file pages, even though the
comment says we should not.

So we are not going to introduce another broken mechanism.
Maybe we should start by fixing the existing broken protection
against reclaiming slab and page cache?

Best Regards
Barry

