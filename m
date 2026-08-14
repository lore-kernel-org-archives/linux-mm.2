Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E694C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 02:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 910656B05F8; Thu, 13 Aug 2026 22:23:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0C86B05F9; Thu, 13 Aug 2026 22:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B2A46B05FA; Thu, 13 Aug 2026 22:23:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 570356B05F8
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 22:23:50 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D4AA5801BF
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:23:49 +0000 (UTC)
X-FDA: 85098279378.14.8E513EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id DBF741C0002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:23:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P9DV8CX3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786674228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJB4jnGzB3s0yYEDqzQ/9XL0OtB5R+II7VabIDklkNs=;
	b=CETT7cvDG1CNmNPBnRL9kETlFUstbHu2DSL9RcnFE5lltskXclvLLrEKaSgVcCgX8S3SnT
	/OF3/QigF0BQU6Arb4p1/UOBjT7epe1lTEqxjXC2QD5a4X3x+ZjLEOc8i33Iz7NJyz4/Ti
	dUdma92I18v1Btl+adPmO4pY5L6EkB0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P9DV8CX3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786674228;
	b=hLsuQOEkQ64MuZZ7D7Ftw67RyOvH2gzmnBQn99o9M+ACPPFDntJS7bEDpVxxq1S6Uak8xz
	JlqNIjXGuOzZHDSneiZE+iFi19bx/fvJ8Yp5zCaTYew5mYI5GqIXQp9Ogx7aM0n6ueW4jc
	AzuHnbpNtlRz0j/S5KIdD1bzTUzuZn0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ECB6C44096
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D468C1F00A3A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 02:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786674226;
	bh=FJB4jnGzB3s0yYEDqzQ/9XL0OtB5R+II7VabIDklkNs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=P9DV8CX3IsLqXF1RU+2kqz5493fk+B/TZjpjAgtg6qt6XPINuY+xfsNLqimNXtCX7
	 Obd31R0W4hGyw3uz9/DELYLRgF5cAB4d+pOdcztttAkLCGbJTAYoAqbtAYe8fiw/2v
	 IXFufciGqlMRhkcE/Tqj6iEEgAk7mwAOEhwAsj/2pXW9b2D+uGzJg08mCeIs3TNHLv
	 0/mpeY/YP+mJNnihCJ5MHoZPtW20nnlUvb9mQh32Z5b6fTx38Jpes5/QyJPB+pWGRv
	 ofYPzs5UnraHNZPm/CxeTur+7cIGFEhgtYBaTeCPKqhT8v+wIPrJv20Zkqt8TjtE3i
	 aZQ47SAE4STDA==
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8f0e5e36912so3317926d6.2
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:23:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqVz965iszq9avHj6GQ1v9az2UUwzHJUbiGTVIyOWATmK6wqIhXRCeEzpoqU4rI/rUEPMVYaejoqw==@kvack.org
X-Gm-Message-State: AOJu0YzzFr53pvfNh75dH6YhEdvnmOxzCLRimZizIn/1Twpzc80jzssR
	t55wA1KxSXEC2HzV4Sqtt1Mi/7yWNq/ZAxnKLVnIEKrYQdTgkXEqdF5yknTtdCUdYrvZ8/2q80u
	dgIJ6JqE1tKsW0zsGnqAZ8yh3m8lxTmc=
X-Received: by 2002:a05:6214:406:b0:8ee:7c26:8bb8 with SMTP id
 6a1803df08f44-90a91d0ff8fmr25062666d6.9.1786674226114; Thu, 13 Aug 2026
 19:23:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260723045718.2052070-1-ridong.chen@linux.dev>
 <20260723171842.137e45eb36b21b3b45245da0@linux-foundation.org>
 <8336e48a-ab3a-4db9-a7f9-5bb6af2b22c3@linux.dev> <CAGsJ_4xPw24afGLZH6Qh5rxOts37SCpmBVeB3gGntk1QQuSCow@mail.gmail.com>
 <24b9f213-96e8-4eda-a20f-8746d7c399b7@linux.dev> <CAGsJ_4xCi1TzV0sg=8ZFhfAq7v=k=Q6a10DNDouYOrjcJL-5=A@mail.gmail.com>
 <f42dd57c-29fe-441c-ac5d-d4f990b7f6ee@linux.dev>
In-Reply-To: <f42dd57c-29fe-441c-ac5d-d4f990b7f6ee@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Fri, 14 Aug 2026 10:23:34 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zSEutDjM0rwfDZrzDUzJvPSFsU8Pcr2kBJiOmG81CY7w@mail.gmail.com>
X-Gm-Features: AUfX_mzjnZEhGGhECUEdL9E_6RFsBzsXVy7MFhHQaogonHuhPQXAXPCnQndFGaQ
Message-ID: <CAGsJ_4zSEutDjM0rwfDZrzDUzJvPSFsU8Pcr2kBJiOmG81CY7w@mail.gmail.com>
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
X-Rspamd-Queue-Id: DBF741C0002
X-Stat-Signature: wj3gyw3bdb94iogzdh98sb8dwbbomobo
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786674227-836315
X-HE-Meta: U2FsdGVkX1/vQYdRDhSbrPVmkPy2ofMAnWpkXe2NH/LVi5yYoZxLQ7HA9o2hQ1vzt7SDnVdl1sXJyiGeS7+4iUCQ2u/usPIEGRjsWDN/JVVKtFLf3PBXMyC6vru51DgtVL4LC0nsuHUGIon2GOOoZrBWImyghXXMpCgdN1xEfBe/kE47PfEOhYrGeZfsdUxp/CPPKwA3jvFJdGI3inlSSl0kK4YVSvQs8kZLXFd9a8vcMPPA/4g8rS1YN4tQ+g+wdYOiGnp88OwV9Jtnj14QtD9C9OWk9ZYrEN/pyr0mZoj9Cnyv81VGKhlmuxzT0wGAQx+8oX/wQWdVMTGfP2lNykAOgF684k85oP0Kyn6JRXxAeB4zWH0GVX29yHzIUL/XCm4MjSnTlwybc8QnJuC/Xblk+vdkqeNd2yK9xXFDxzs8s+nC5RI9sxMMa6HBsbSxHk3C/pAiGLdBXUemnq6T0FJ1UIUqDdV6rjQWUWt2K5+hgGxtIqKrufTit/pmGPWvYTJAw+DLaqaznlRUC4w3Lz97kWVEqmlx+/YDl7EgjXeQGSAZyVTzqWjAkm2ONAStAGkkeNWkM+BTIIGMJHPBsAviz4PoFB/VS2GEQ/+WdVhdsjux1G4Lsrl1H4NVGMZpo9ZacGYMWjcOekdp7F2zj4BYzjmGY6QwfVEDL3xI8oDgIqqljVBHPkR6cYRpWl8wZSuDJZ1R+cmkUjE3klCP20RYlH/rVwpubk6HPPFlBOWtawux0IAWS/kOOcEFdBCKuMMija+E+xP4A7MtOfRLjPfLOyRjV1j32QvmAmujknzNBnK0DT03hCKr5eqGXEkFcOfLC8X5qXNRCwSSxeZ552/04uaCioI2Io4lWb91bwKXkpDOO99OLldIc1/qLmMrXe6JKqmhgCfDF3G6UAxzsmcbotAHDeP7M+4WKH0VNR0V++Gmrq9AzO5zvQRKSpTKFtSewuS9qSDy7VRlVYo
 J6oPPXru
 tKNU8M9b1iHAOu4ci0gzWw2o/u26+Ge/uKdcKTCiws3U9u1GxyELHWNw4mO5y3kANXqGxm6otLqaYSKxOmFKalKDnht0x1OseH6iKWMNnSmFUxcjWqDmBZsglbxKu6lnBz0y0UteKUSkmLpPNhhdhjMuJlyCsY7DzUKdsGSkUGjUPtDg+C1wDkhFWv4ufAcHKcOgKLjhyB7KiZWte/VFcSjN+uWe2PYSbWMykVHQEeDJxkETIircba2VMEvCdQxLCd5s9k3sitQtYhN5Tx4c0LfbauIIJF3NOGzd+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 10:03=E2=80=AFAM Ridong Chen <ridong.chen@linux.dev=
> wrote:
>
>
>
> On 8/14/2026 6:37 AM, Barry Song wrote:
> > On Tue, Jul 28, 2026 at 4:34=E2=80=AFPM Ridong Chen <ridong.chen@linux.=
dev> wrote:
> >>
> >>
> >>
> >> On 7/24/2026 7:12 PM, Barry Song wrote:
> >>> On Fri, Jul 24, 2026 at 10:43=E2=80=AFAM Ridong Chen <ridong.chen@lin=
ux.dev> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 7/24/2026 8:18 AM, Andrew Morton wrote:
[...]
> >>
> >> So can we add just like?
> >>
> >> if ((sc->proactive && node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE=
_B) >
> >> pgdat->min_slab_pages) ||
> >>          node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages=
 ||
> >>          node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->=
min_slab_pages) {
> >
> > I feel both pgdat->min_unmapped_pages and
> > pgdat->min_slab_pages are quite broken in mainline.
> >
> > For example, even when the page cache is below
> > min_unmapped_pages, it may still be reclaimed. Similarly, slab may
> > still be reclaimed even when it is below min_slab_pages.
> >
> > Also, when both the page cache and slab are below their respective
> > thresholds, node_reclaim() may reclaim nothing even if we have
> > plenty of anon folios available.
> >
> >          if (node_pagecache_reclaimable(pgdat) <=3D pgdat->min_unmapped=
_pages &&
> >              node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=3D
> >              pgdat->min_slab_pages)
> >                  return 0;
> >
> > For example, if slab > min_slab_pages but the page cache is below
> > min_unmapped_pages, we still reclaim file pages, even though the
> > comment says we should not.
> >
> > So we are not going to introduce another broken mechanism.
> > Maybe we should start by fixing the existing broken protection
> > against reclaiming slab and page cache?
> >
> For example, Maybe we can skip shrink_slab when node_page_state_pages(pgd=
at,
> NR_SLAB_RECLAIMABLE_B) <=3D pgdat->min_slab_pages?
>
> And similarly, in get_scan_count, we could avoid reclaiming file page cac=
he if
> node_pagecache_reclaimable(pgdat) <=3D pgdat->min_unmapped_pages.

Yes, probably something along the lines of what you're saying. Also,
get_type_to_scan() in MGLRU.

It's a bit surprising that nobody has ever reported a bug related to
this. It may have caused performance problems that we simply haven't
realized were related to this broken protection against the
min_unmapped_pages and min_slab_pages thresholds.

I guess this fix could improve performance as well. For example, when
the inode and dentry caches are already extremely low, we shouldn't
keep struggling to reclaim them and waste time there. People have
already complained that shrink_slab() is slow and suggested having
an asynchronous shrinker for it.
Maybe it's related to something going wrong here.

Thanks
Barry

