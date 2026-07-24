Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37D55C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 11:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28DB6B008C; Fri, 24 Jul 2026 07:12:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFFEB6B0092; Fri, 24 Jul 2026 07:12:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3FE26B0096; Fri, 24 Jul 2026 07:12:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 972926B008C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:12:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1726A1C081B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:12:28 +0000 (UTC)
X-FDA: 85023406776.30.EBD3F86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 38EBE1C0009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:12:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ab2RYwwd;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784891546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YeK6HyHJ5Fys1rUtql2mZWcC+3hhi8PzP7ReBh2L8YA=;
	b=0CFGcYf0UrBK08km1NmlIWTAr6Fk1F96Lzu8hRgl1Gi+xbcW6jOlo9nIxmBhqZIcjrLzYi
	O2DSffWwOjKAttlGy0TCIklMwrvObQHWu0ewhcPPs6DeQmTRGzdtqdkCMye70OUbt2F9aJ
	6DlSuwTSrc6Ptzu6dF5TvA6EQGBqR54=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784891546;
	b=JZKLrueY2fn/BM9A4/6SyfRBxWV520SThAXfY4CnG51gGsoQD1ikDb6JMQOve++l+qD4DN
	nVt1JvDTs7QvrGalWRWoHftUXSPMGUbWzSEt3vcj/F++wJpGvRDerNReyyPI5mPMx64YII
	het8jqQI4ggquIvcdd2KdPct7xPhiWw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ab2RYwwd;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B7EC960A73
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06E51F042AB
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784891544;
	bh=YeK6HyHJ5Fys1rUtql2mZWcC+3hhi8PzP7ReBh2L8YA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Ab2RYwwdt11OH80MGdW78I2zvXItC8riTzjr2rpCnCrEFxGO67ksBUecjgrUYDMOk
	 +Tl8dVJH5pHCrCJqlLIJZn0Q0zQCDkv9mebcJWtT+N3cy5OFkoyFMK4J1d+WPtGfIY
	 XYu4M3NJXcMQpcpyUscjveJ5IAGZgNOiV75Jnnn2WTVJ/gP51Z8ZjTc2Nb5qIdTdGT
	 T0qAxI/yzCJ39H5YsazwKodpf8/CRDP/NSrqQyONjfq6udWRdY8Z/RJtt/5yxA+J1g
	 cd65K1KzQ2k6X0iJcpzL3aWvpDTl1J/Nrp1EJTli6hDX4YQkpV5HI+Wf5dq6dhRC61
	 cMXDjatTCq6Jg==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8f256eaedf8so3276506d6.2
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 04:12:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp/fSzev6khkNN+eqBmFglPnd2um8GAIrwpwIph2UZt+reFXKGHctvpDYyqrVia6JXy7Co1zInclQ==@kvack.org
X-Gm-Message-State: AOJu0YxYFdS6WW4g593XClJISofSW2D6/nhGj+UhK+WEAtiUdtfo6+R7
	8rPZVshvRzxdniiEjSZP/EENd2NaPPq7or2ke3kJtefXXdUJTqnUZZ7NVDenBASMmbHTZIlm5i3
	szrJnaNSFnqVEOSV/69VdzuPDZjFr/c0=
X-Received: by 2002:a05:6214:5711:b0:8f1:d3ee:a8f5 with SMTP id
 6a1803df08f44-907ca2971c6mr80794576d6.26.1784891544043; Fri, 24 Jul 2026
 04:12:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260723045718.2052070-1-ridong.chen@linux.dev>
 <20260723171842.137e45eb36b21b3b45245da0@linux-foundation.org> <8336e48a-ab3a-4db9-a7f9-5bb6af2b22c3@linux.dev>
In-Reply-To: <8336e48a-ab3a-4db9-a7f9-5bb6af2b22c3@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Fri, 24 Jul 2026 19:12:12 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xPw24afGLZH6Qh5rxOts37SCpmBVeB3gGntk1QQuSCow@mail.gmail.com>
X-Gm-Features: AUfX_mwP54Xsm1e3fuHSln2qycpckSPayxbDEncK2YYYhcH5HQwwtMGw8M1toWw
Message-ID: <CAGsJ_4xPw24afGLZH6Qh5rxOts37SCpmBVeB3gGntk1QQuSCow@mail.gmail.com>
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 38EBE1C0009
X-Stat-Signature: h6b7nppddnytieawqr83yggtxpdiodib
X-Rspam-User: 
X-HE-Tag: 1784891546-243191
X-HE-Meta: U2FsdGVkX1+WX/9ycDJWet1fRFKfOZ8jHhcMRzd0gbf/R/jpwV0H0nQpskNgFp4LkRWb4Vv4qosiQbxCMTPzvqVnzW+P2+YrOmekOwIi7LeRweL1AsYh2wF0gyiMMeAv2yG3yVXJLNV5X+KYweRA0N3V891Vkzpkv61nyWZbicu6BqlsEthgOZ6Cw6+TQ38kJ7/wzjKNgNZeDJLcfIvxFlJNJ2tnVufrlTfBoV+BjQxPhNgTtfBk+guq1zeXlmxpCnJCqKqlaFE/ilQlHZDfb3fXN8D9+j8JS1Bzhck1t8hw8hzxlgoERQu7FfSCoK8BRvJe720bRnoWbQNLHUzbZ1ArCi9aqbclV0Hm8uFLtTeWqLGJ+2RPeJ4YK0ZkYNOCneV3HsruaeuNSbJKOGk/E7kIdTSxTPq9Od8UWZg3i+8FqphLIN57HN8my0haqFkfYLfzqIaOH2taFQ5fyqKLadgA5bdAkKS0QEdwEFD/tVI0ZbcRutNWROO5zguXHmCpRNS5BY7CeWA55Un589ZkPwFXnPo5tdn8fLINhO4hBl8JfJPqlJAH5aOuKu2kp9uu5Ibx+xCoPmOTvv80KS/XMXuKwPLQUa0r7crctDGOtQCv3Oq3QOIKLIJLcJNC+drgnO4BQMfHsrQhWG5a/0BzfcqXeLV3ZVzPLdRdOf+SV/YmWynNH1ijIsMeKQ3eDQxdi5Qg8MOqJUhJCQHm/7Kh0BER9k9LfMYngjrfzg4KvmTTIJRACWiigc40ClgD0pxPoZ3dsmtVMuULfGYrK3xCiCbf0qEz9Q2/IgTgM3MAuqutNHjqhRPJbmyLGRO2bt9zC09w34STDEdL7n+kfSnb0BXP/OIsbwCLwwss9jSjj460COPRmMmTHJNQkLgzykN3sZ1lM8x+282f/z8nocQUzaf6oHg3K6PdzeLCLhyMR/PYGgv7iLzqN+5cn9mCPo/uVxFEljLNaQVFYwf5KSP
 cE+OqNVQ
 18YCZjj4p4mXj1aiLO1gfpeY6aEeVv6N5aNf9ym7bGs+lIFaN3ewE04X8fIipGtm3ZMbfUzcyd15KNiaVosGZ+GU7oSq4LNupu7uz5YZdRQ88yWzxiGyxxNRxm6/9xtw9pgo80NO71OL4wy7OkUp5x3nvMKRHfBxtYLZihurjuUZKyOin//DecILP4y00cNiWuny73kIY9w0k7pJI2n58yQXvW3G5AXSWfcLLeJ2EfZ9APOZno29Wp2mq3P4yCfsZv5wkJL8ohR8lL6kFcS+fHYkMpAa/d8ZOj0Ukara96KHvM2KSugLNqYinm2NihXXsbaVBbwlrz7R0y6oOpO6CBqC7nw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 10:43=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev=
> wrote:
>
>
>
> On 7/24/2026 8:18 AM, Andrew Morton wrote:
> > On Thu, 23 Jul 2026 12:57:14 +0800 Ridong <ridong.chen@linux.dev> wrote=
:
> >
> >> Fixes and one cleanup.
> >>
> >> Patch 1 fixes "swappiness=3Dmax": the anon-only test in get_scan_count=
()
> >> sat after the "cannot reclaim anon" check, so when no anon was
> >> reclaimable the request fell back to SCAN_FILE and evicted page cache
> >> instead.
> >>
> >> Patch 2 fixes reclaim_store() collapsing every error into -EAGAIN, so
> >> callers can no longer tell an invalid argument from a busy interface;
> >> propagate the real error code, matching the memcg path.
> >>
> >> Patch 3 drops the now-unused gfp_mask parameter from __node_reclaim().
> >>
> >> Patch 4 fixes the same "swappiness=3Dmax" issue for MGLRU.
> >
> > Thanks.  AI review might have found several pre-existing issues which
> > might interest the maintainers.  Also a suggestion against your [4/4]:
> >
> >       https://sashiko.dev/#/patchset/20260723045718.2052070-1-ridong.ch=
en@linux.dev
>
> Hi all, sashiko review:
>
>    This is a pre-existing issue, but I noticed that per-node proactive re=
claim
>    fails to reclaim memory if the node's unmapped file or slab pages are =
below
>    minimum thresholds, completely ignoring anonymous memory.
>    In mm/vmscan.c:__node_reclaim():
>         if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages=
 ||
>             node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) >
> pgdat->min_slab_pages) {
>    Does this condition incorrectly block proactive reclaim of anonymous m=
emory
>    by applying legacy zone-reclaim thresholds?
>    It seems to bypass shrink_node() entirely if file/slab pages are low, =
even
>    when sc->proactive is set, which could falsely return -EAGAIN to users=
pace
>    for anon-heavy workloads.
>
> Should we add:
>
> if (sc->proactive ||
>      node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
>      node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_sla=
b_pages) {

Nop.
I assume reclaiming file cache and slab becomes problematic when their
amounts are already very limited, so we should still honor these two
checks.

Maybe we could relax them only when swappiness =3D=3D 201
(SWAPPINESS_ANON_ONLY)?

BTW, for global proactive reclaim, when setting swappiness to 201, does
it prevent slab shrinking? If not, it seems problematic when
node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <
pgdat->min_slab_pages.

Your recent patchset prevents all file reclamation when swappiness is
set to 201, so we only need to check whether there could be a slab issue
before allowing shrink_node() to continue in this case.

Best Regards
Barry

