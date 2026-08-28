Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E1CCC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 06:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90B9F6B008C; Fri, 28 Aug 2026 02:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E3726B0092; Fri, 28 Aug 2026 02:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 821706B0095; Fri, 28 Aug 2026 02:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3966B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:35:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8EFDA3A4E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:35:21 +0000 (UTC)
X-FDA: 85149716442.11.C8980A6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1CD2B40007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:35:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WBEl1Rwh;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787898920;
	b=19NaAOX0YcNccM7gZtOZOj2nmYXxyojOxBkx68XbJd1ICCndlYL1A7VARxUmtlSi4sVTMq
	A58sVuSOkTa+jlJyuy0cheR1z0Q7SKizEMeOkPQlLGu9T3CKixnRwaqmV+U23V5NSP3JEn
	STqkCwEC+UIyDffcxL/4ULBgFfMVyYk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WBEl1Rwh;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787898920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jub6oZR5NxUoNz20i8gX2vUB8KJOx19wdwkx4L9rW+s=;
	b=O4T5RPSAPyOnOTnRvJ+dawid0KVemY4GNrDbY57iOR2ODr5C233MiSuWUHQHmUYuz6RBuW
	XjmjGivz51hFnFjsLY/noLWIwudJtNQtEVtEq57tL0hJ0D62vr6SfEJMMYt1b82URg+4Ps
	Lrx9spnqAGiJGPltpKDhWtsRn8fFMJg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 45B7B602DA
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09DA1F00A3A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787898919;
	bh=Jub6oZR5NxUoNz20i8gX2vUB8KJOx19wdwkx4L9rW+s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WBEl1Rwhdy2n3UH2bTSIQH4+L18Cg6INFObyO36gEMsULJxen0wLLqzeR3NjSpdVK
	 ER+2aui6AK8yl/6y7huJhJ+O9pD/RIm4CIcW95ive62fT0Kxb2MHlAimJBpP7edc5j
	 KhaGRTgH9hGD2bXMiWCNhxdmYStPF2jrvJPTj5QCzFlvy5i5H3zNnAklxCbmBKT5ib
	 /P78mx23bfSQSsB9rlNaYC/AJXpg8501zwfaKX2DMMGcVZ2i2fdeYgHTzLDCiIAqwi
	 k75XqIglL8s7DTys2mftQXfbAjZ2bnMcKtqP3c7wknyv10NzN5GifJ9iTh8hFy4rMG
	 c9mTMLPnvU8nw==
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-52de178a66aso4847541cf.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:35:18 -0700 (PDT)
X-Gm-Message-State: AFuF++md9iQNh0+0Nvf30d4Bj4aYW2tgBnlg5qrAsE8dMbYKbdj76pCG
	WwVpFbel1+IDCV8tge5plGcOQIRm0/1DEKUWLZvYQSBnnJg7Zb0KYlZWcOSC5RmXRNYDvfu8xG7
	FldzYgSpl3utN1bfpfLsHJZWt8SbFNh8=
X-Received: by 2002:ac8:7d8f:0:b0:52d:e425:9b83 with SMTP id
 d75a77b69052e-52fb97248b5mr54275861cf.32.1787898918303; Thu, 27 Aug 2026
 23:35:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260824073806.629593-1-hebaoquan@kylinos.cn> <20260824073806.629593-3-hebaoquan@kylinos.cn>
In-Reply-To: <20260824073806.629593-3-hebaoquan@kylinos.cn>
From: Barry Song <baohua@kernel.org>
Date: Fri, 28 Aug 2026 14:35:07 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yC+2-Hx8wXop9bXPsAk7ZH=p=ZS1QmfyePKYK-VKhRXA@mail.gmail.com>
X-Gm-Features: AcwNN1U_mzxCnRk-WaIHLOzyDikoq-RGhiUqHaYXLmV6lZ9d2FLezDxgmf6WHCg
Message-ID: <CAGsJ_4yC+2-Hx8wXop9bXPsAk7ZH=p=ZS1QmfyePKYK-VKhRXA@mail.gmail.com>
Subject: Re: [PATCH 2/9] mm/mglru: suppress cross-node empty page table walks
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org, 
	rostedt@goodmis.org, mhiramat@kernel.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, baolin.wang@linux.alibaba.com, 
	hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: zb89wwh3zte1xrk6mnf86gjzwm4z6qym
X-Rspamd-Queue-Id: 1CD2B40007
X-Rspamd-Server: rspam06
X-HE-Tag: 1787898919-769520
X-HE-Meta: U2FsdGVkX1+IeY4bOYPXMwon8CkbMNBuplG90cOH3KZvTIySDjxbGRgq77aEyF1uCsVrJ1VhYDZ056p37JyrzSAUpG9ZhGfxeisOYccTV1j2Q/CsG39XJpWjBl0kNJGv/ItiJGjamwTjjqPpRyi0DpC+zy3OuxIBKo1w686oAFqAMk4wAlNKEwv4aG/l6E6VAzuLJNBJJfzx4yMfbArAWl/XyuQ7RXytyK+IVIcZimIWiYq9JfPF1dx4ZQ4/N+S4PdnFg2qjHFkkL9GseUL5fGqzLRnb4agKT9dP8hMC/hxP8UTmF7hW4ohc7NoArVFF0IhhvH+fpCrNaQ+tnMm1FZGFRKsm+c0Zi+9h2xBp1l8SvwuBE9GMUEqYD4p0OZqAKY4cKktohcWd+H2YGWlfUFMfP9Z45rRneSb7gG0IYCO1eCFEAgYYa0xeiNQ6JPZF3rG+ID2mrBQabGDBipV6e+/49irQtNlvZ7/KfCiqsbqGYytKdOFBqlbbLcuuPkGbidUL4/xUYJA0+I33hB6gDkX+70ImtoAtPBpV4878brRtrrhWJWJ0tcsBWJJZqHF0oZLo4F0hi9VF92g8ozrYVkXXmoohvE90/tMYr5GW7XeGG7qfrKw6bbBJe8bCtKz58AtFEZdP9Y4AxZLn93R1W37uj+6dOCBhKSNbqH1JiiXhHP8ihl/OjmqianXpgCyNH1gU6C/p7OwWmbvUWkSsOBecOI0wGRoyqzkDvYBgGcxdMEMVYpkJ+VaslcVgyxcWCZE0ykmXkwr5vCHvmDxpKoquEQXvwcereJxKRZuC+PrIr70uRSanMqA+4vV8mycSdVfhBLxkKK3rWvv+3Wk5aJjKjvQVaTtQR6O8VPy13qd/TKcinNe8Nfd/cDnwkm18+38THUK0B4vBhQwJKoD65x4aH0xAcMXHiyx2KuW9/Jfqp9DwYzuThxfCiJptMcppph18nStHXaR2zuYtd4M
 abp7SiZz
 C5U2VdMH0Xxob13hJQlKYVddoq6ZjPLaXWMjakjMy2xYSaJ1OQ2X7PMHxPrjQUTtpnmcRNZH084c0I+9o5KiEl6/n9gYiNF+9AeZvzQzQchqhO7uKDPNG8QtTcrHPUOwMppXzI/Qg51KuJtDE7U68GFGid5rYhfBnkR4t5CEo1047fgUjR7GY9cLZfZ5tA4B49GRZIu0L/+8XlnSARlvE5O5AUeioLUEu+gYnVBedjbd7P0Pqq9X56p5BTaO8nv5dbU9iHZRCdk4BcPDJQYTqCRYKt5d0IUYPHJZ4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 3:38=E2=80=AFPM Baoquan He <hebaoquan@kylinos.cn> w=
rote:
>
> In the current MGLRU, lru_gen_use_mm() will mark one process's mm used
> on all nodes at each context switch. So each nodes's aging walks into
> each mm's page tables. For an mm with memory on one or only a subset of
> nodes, the other nodes' walks find no pages for one lruvec. While these
> empty walks are pure waste.
>
> Track per-mm, per-node empty-walk marks: bit N on mm->lru_gen.empty_map i=
s
> set when node N's walk of the mm found no page for this lruvec, and
> get_next_mm() will skip the mm on node N between re-scan passes. The re-s=
can
> is driven by each node's own pass count (mm_state->seq), so every
> mglru_empty_skip_gens-th (default 4) pass re-walks all empty-marked mms t=
o
> close migration/NUMA-balancing windows; keeping it on the node's own cloc=
k
> avoids a shared "oldest marking" sequence latching at the slowest node.
>
> A walk is "empty" when it traversed the page tables and found no folio fo=
r
> this lruvec.
>
> A page that appears on the node during the skip (fault or migration) is n=
ot
> aged until the re-scan; a later patch invalidates the skip on those
> paths. mm_struct grows by 8 bytes per process.

Hi Baoquan,

As mentioned in my reply to the cover letter, I wonder if this could
be achieved by the PUD filter instead.

For example, if we find no associated folios in a PUD, could we simply
filter out the entire PUD?

BTW, is this related to memory policies such as `MPOL_BIND`? If so,
could we inspect the mempolicy to avoid these empty walks in the first
place?

I'm not quite sure what the best solution is. My gut feeling is that
`empty_map` adds quite a bit of complexity, so I'd like to explore
whether there are alternative ways to avoid the extra code and the
additional space in `mm_struct` before going with this approach.

So far, I'm not really against `empty_map`; I'm just trying to get a
better understanding of it and explore whether there are simpler
alternatives.

I mean, I really like your PUD filter, but I'm not quite as fond of
the `empty_map` approach. :-)

>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---
>  include/linux/mm_types.h |  3 +++
>  include/linux/mmzone.h   |  2 ++
>  mm/vmscan.c              | 52 ++++++++++++++++++++++++++++++++++------
>  3 files changed, 50 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 6d815f6440c9..3738e8877b73 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -1410,6 +1410,8 @@ struct mm_struct {
>                          * page table walkers cleared the corresponding b=
its.
>                          */
>                         unsigned long bitmap;
> +                       /* bit N: node N's last walk found no folio; skip=
 until re-scan */
> +                       unsigned long empty_map;
>  #ifdef CONFIG_MEMCG
>                         /* points to the memcg of "owner" above */
>                         struct mem_cgroup *memcg;
> @@ -1503,6 +1505,7 @@ static inline void lru_gen_init_mm(struct mm_struct=
 *mm)
>  {
>         INIT_LIST_HEAD(&mm->lru_gen.list);
>         mm->lru_gen.bitmap =3D 0;
> +       mm->lru_gen.empty_map =3D 0;
>  #ifdef CONFIG_MEMCG
>         mm->lru_gen.memcg =3D NULL;
>  #endif
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 229d27fbfb54..30213a880db0 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -633,6 +633,8 @@ struct lru_gen_mm_walk {
>         int batched;
>         int swappiness;
>         bool force_scan;
> +       /* this aging pass is an empty-walk re-scan pass (every K-th) */
> +       bool rescan_pass;
>  };
>
>  /*
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 92cb83a78971..e8ba49683b28 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2710,6 +2710,14 @@ static bool should_clear_pmd_young(void)
>         return arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF=
_YOUNG);
>  }
>
> +/*
> + * Cross-node empty walk suppression. lru_gen_use_mm() marks an mm used =
on all
> + * nodes, so aging on a node where the mm has no memory wastes a full pa=
ge table
> + * walk. Skip such an mm for up to MGLRU_EMPTY_SKIP_GENS generations aft=
er an
> + * empty walk, then force-rescan to close migration/mlock/NUMA-balancing=
 windows.
> + */
> +#define MGLRU_EMPTY_SKIP_GENS 4

Is this related to `MAX_NR_GENS`? Does that mean that, over a full
aging cycle, we have a `1 / MAX_NR_GENS` chance of doing a rescan?

Best Regards
Barry

