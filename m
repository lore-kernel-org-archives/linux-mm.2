Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94005E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 07:10:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04E046B0088; Thu, 19 Feb 2026 02:10:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26A46B0089; Thu, 19 Feb 2026 02:10:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E607D6B008A; Thu, 19 Feb 2026 02:10:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D49C66B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:10:51 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B9891B52BA
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:10:51 +0000 (UTC)
X-FDA: 84460333902.30.BDF404F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 858A940002
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:10:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SojqIgo7;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771485049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3D+OwkB/CHpveSwHfI1hLnn47/cBVFCjC/fY/8gXE4w=;
	b=HSQUkOJySt5WK3bbfKZqMYcSwh0VS/fv4pSk8ip0+4gxFLOplFwXQ4m/qG7ndfWmlEJZhu
	pxmS4xduN4Bj57Dffpbf/nkX1IVavIJtzdlFygRAa3rmBrNZI0fA1yziHHAQXSLg+odvyD
	Cqb7RyBXOyf5hotZISvZTDTccboI2UM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SojqIgo7;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771485049; a=rsa-sha256;
	cv=none;
	b=u5s7BZRn4r7XvYgJbw3PZj0Ckqro691vjY+VGkc/0Vr/CWgz7ehl8q5VOhSLHEX5Cj5bSh
	3AhCM3za4yNUX8+QE52JsCLNi1sr4YfCPh8Vmf2GQteWYKUbYKcdeBxrcejihzzzrA3sZG
	60PDzLNJ71FrMy/gRls0AbTrp2eLAVU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C4B742AD1
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69607C19423
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 07:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771485048;
	bh=SxhRcA9HZCWHgcdyLMb8MIjTjGWUlZeb4jXBtc/K2AA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SojqIgo72NJCHEI/eSItlsCH4PfMyzlUTQuFRo8sWlp2GHB5+j1EkiZld4+flfXk9
	 Vxqx9uL/lJR8lp8/OZdh71J4pCdTZ5hpjnp9O9wRIlXSdDzP5ewboL36kXGPMBbE3B
	 xpGrpa+q2zIUrMnXIzMer7ytP7WZ8x1jnLaDYAD98+Mio7zTRHy2I4WNfEkKsBw2ey
	 07OTmLmdp0gpAJM17WepVfsvLzjOwAKk0DwXrS4TKW6nWkmKO86ho/69vi4NIbV/MM
	 er2zYmA7b7Xe+O3tqQIoSet2EJS1wJf5LVi5MqUnIH+0c3BlqCqPBgytGEMCDCytiL
	 pa6JwDcpZjBiQ==
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-64aea64bf15so567072d50.2
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 23:10:48 -0800 (PST)
X-Gm-Message-State: AOJu0YwZtEWkuUZ3rOaG2r81V1lpWLgit+zh0at9VPOin53yqf5SDdf8
	2RT5FAK7NXyEVYr8zSRDbeUDuAxb7jkOmuW+wVJjk4FQmNljBclpiC4g1VrvMzDvmQGsSGJFFQb
	YepMnak+UbDOO+KbFKabL70EA+ywGzbufHBPyen1vQQ==
X-Received: by 2002:a05:690e:118d:b0:649:e4eb:cc66 with SMTP id
 956f58d0204a3-64c5568a3b6mr2606179d50.41.1771485047618; Wed, 18 Feb 2026
 23:10:47 -0800 (PST)
MIME-Version: 1.0
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com> <20260218-swap-table-p3-v3-10-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-10-f4e34be021a7@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 18 Feb 2026 23:10:36 -0800
X-Gmail-Original-Message-ID: <CACePvbWw10u9V9UD0o66cvAdFA9Q2ysbZPKCx6GW6rU+Atb75A@mail.gmail.com>
X-Gm-Features: AZwV_Qi31-92-1VAwRc3fPJq_CPbpWsOyD1cb6l-t2RrSTuF6fCNmssfEn-PPIY
Message-ID: <CACePvbWw10u9V9UD0o66cvAdFA9Q2ysbZPKCx6GW6rU+Atb75A@mail.gmail.com>
Subject: Re: [PATCH v3 10/12] mm, swap: no need to truncate the scan border
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9ccq46118qfc4z9mr5k7gi9hng13qut8
X-Rspam-User: 
X-Rspamd-Queue-Id: 858A940002
X-Rspamd-Server: rspam01
X-HE-Tag: 1771485049-712950
X-HE-Meta: U2FsdGVkX1+XmACi3BYftw3/dopnnPrtQMH7Q39mIvzIPJR28s4b/TbaZXVSUgYvCtsRl/O9d34yEaXnsV5vxE+ZEnJ8bzZM51f5L3gnjsXiTs6lbUjZX2j8KwomCuaUyO8KdsdFhCL3MYva3mdsXSdIFnViJwJ6zIUbT1piWpv5AetzC7NDyGtDVABhUTUrSLUEkmCsudEhAfE1WNBcQ6HmCXVsleM36Rg2xdTTjpXdw8uFptmO/nEY/y0FNHZd8eT/UeTzV1sy//mt59ufjQ1zyhiZvjv4vR+Z9gQVc342n5g2zGthSTZcZBHEskTKJt0atVqLEd2vP9O/4zlV6mruhNRjEwZHHk19sXWmXspL0UGwv8cUaFDs+i3I+82BN01wS4t9QvHBV/7GVQLOD+ICdNZFtnWKv7Doza2S3fRBC7wrXaFViJzNejukyD8fF326OpJZ8XGGWpl4fr0C6Als+mrMhNG/RHd8YzEKNTLd3FQ+sjc8/21DSIMnIMRZs3lE61c8s4AoYl3+DGNaZeL+Tr2gHw1X6+JxawEGheHM5/FgUSP27PW+M5oaQiyy+/83Cd+rM6EJvgZbDw/FpnIWG+Ym7n1PKfxEzBER17Qq761TxyWO4z6i5bkN3DZZeOLVhqliKnszcrrYv3g9U+qD799NLeYqkRbm6zrrPTLPkfPfYHcJMma/LgzDpj6Xe83Eri6hrz3R+qzyA0RJ3c5y1Pgj71gCpMJlyNMSD08bA6LsNISRxvZ8GWMr0ypty7n3SyNMu7fLziydWmA2QRi0qO1o1QDnRNqbuR1oLTkvC4po64+t4V3mdA7IE3gSv/fHXoEq4fQu7LkXcrmkr8shcibwpsN6zHXtMPHNoedmpyjqKSytnLV8wB98fq96CjSFg9A8JVLccbKB15LE3ixFxIuu+dWS8Q7xbR70y+xM4QOlugTnXsX4eLTrLxX4dIC2kmWyhMIaSr7TEqs
 llQyHOUG
 QzAjf0Uo7aO5g5GEau+el/t7PU8Nbx/D8xYW9PwPtIn3/YvKkDeWq05wSuORAMkvQktC8qUFYqo4WyrOLiIP3NMQxk3sx3mS2Lhe6wjUUbZf+kAyQAosDzHj2OBUgSW/c2hLPUK1yKvfs4nBR6bj3Qwu7GCC63CWI/Rx2yn7rQLJJnWHFtdyoCZ4BSmeYPIjRibh31XXlkeVPvt0E2UPdlH4ZvjjceIAaI814fRrW59p5Pa+LgCMlBxmS2VtCwe365Q03S2CHx5gtqLBpfZGbjNU5uKXwnsHpgVwLaToOjGmKF52jeH8Z7G0Tmwy+kYWGAWg8znJGt63xtVQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 12:06=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> swap_map had a static flexible size, so the last cluster won't be fully
> covered, hence the allocator needs to check the scan border to avoid
> OOB. But the swap table has a fixed-sized swap table for each cluster,
> and the slots beyond the device size are marked as bad slots. The
> allocator can simply scan all slots as usual, and any bad slots will be
> skipped.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  mm/swap.h     | 2 +-
>  mm/swapfile.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/swap.h b/mm/swap.h
> index 0a91e21e92b1..cc410b94e91a 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -85,7 +85,7 @@ static inline struct swap_cluster_info *__swap_offset_t=
o_cluster(
>                 struct swap_info_struct *si, pgoff_t offset)
>  {
>         VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swa=
poff */
> -       VM_WARN_ON_ONCE(offset >=3D si->max);
> +       VM_WARN_ON_ONCE(offset >=3D roundup(si->max, SWAPFILE_CLUSTER));
>         return &si->cluster_info[offset / SWAPFILE_CLUSTER];
>  }
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 801d8092be51..df2b88c6c67b 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -945,8 +945,8 @@ static unsigned int alloc_swap_scan_cluster(struct sw=
ap_info_struct *si,
>  {
>         unsigned int next =3D SWAP_ENTRY_INVALID, found =3D SWAP_ENTRY_IN=
VALID;
>         unsigned long start =3D ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
> -       unsigned long end =3D min(start + SWAPFILE_CLUSTER, si->max);
>         unsigned int order =3D likely(folio) ? folio_order(folio) : 0;
> +       unsigned long end =3D start + SWAPFILE_CLUSTER;
>         unsigned int nr_pages =3D 1 << order;
>         bool need_reclaim, ret, usable;
>
>
> --
> 2.52.0
>
>

