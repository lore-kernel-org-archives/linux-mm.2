Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E54B7CCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 21:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C215E6B0095; Sun, 18 Oct 2026 17:05:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF8EA6B0096; Sun, 18 Oct 2026 17:05:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0EBB6B0099; Sun, 18 Oct 2026 17:05:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84E326B0095
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 17:05:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65EDB140529
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:05:07 +0000 (UTC)
X-FDA: 85336977054.23.1ED8E8F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7323018000C
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:05:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4lLs6eE;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792357505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iQDTlvvwoXWqTgqUBdk+kEmh4xR3Lpqc+hC8biCo7vg=;
	b=bQ6dt9/xMtPgNXG2OcQxiDEUZx1HJXjw87hflfjDEQkZN3Q6k6psiQoGGuZOEC3n+AoINw
	AU47JAP9iPzr9+v+gIP+H1X7zh/hyP0wYJQ7fHv/WtyqrrIlLXAebo2TVoDb8mwT1odSw0
	Bzzo9loxhuG8XtASr5muVMMJ3Z3eDXA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4lLs6eE;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792357505;
	b=oLI4JmZDOj1MjSkrvRLgSdVb323qfNGTmbltOj9BmZvhvFgUqnPGrqS122w60V9yK6PF3+
	1Zbov0cGIh3LrzvyXJqPTANJ0KxPsx7d2lyKnFCIkEKdW9Dx1nBZINCab4zx7O1GQBam9N
	Z03KO7DB6DDlpsSJu+Tw2LAlwfXh8c8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C92F43E6D
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42E0D1F000C9
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792357504;
	bh=iQDTlvvwoXWqTgqUBdk+kEmh4xR3Lpqc+hC8biCo7vg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=P4lLs6eEEnoVjUQJuctxKFBDuyiPaK3m6UuM2qgmkC16By/9aSfZIWgpmJuCHfJPH
	 AZ2cEGKtdOqRNMne4/juWp8RLzT7qlc2GWSSIOK/AUl3LAOwSSsXi2xDZ5ELgU/LuJ
	 HCCZ+rsUppmYKvwZkqtLKONFVSL0amezDpnaIKAMeBxriahtJGt5qCaMjPT6ZQoJkp
	 47LrDtFiOgVtj4qwixrez4zTggHJ8aPqPPZAgg8ShK7muCU8B7cAFCCEDvaxnImxhc
	 qbssp2b5F8TKOPmKrxEXScyhc2cd0A/XHK2v/f0JApCl90328xasjtDE3vVKolKoTP
	 Y6y42DguGoHsQ==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-93f2ed2541aso110609185a.0
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 14:05:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxYL0+bcpWJPTUQrNa29FJJOaP4WJYintnmXmv1+VMXXpbOjBqI+J3bzRU+hyldjYBVpLmApxoioQ==@kvack.org
X-Gm-Message-State: AFq9FYLcM06t+KiZ82Pn990AO1W0e1c/Dq2J4HjHzQcnmwI1W/xUX+ul
	nrun2jTts1wOgV32iPAY6uJieXvf6WCdvA4k8kd2QzTpPf438k56G8oPfAB+6WHrudqyUNzYBHu
	A8bZsOJyXLnCEEQjkUpEaCXjt+V8j0FA=
X-Received: by 2002:a05:620a:280a:b0:93e:c12d:4ec9 with SMTP id
 af79cd13be357-93f17faaefdmr1523087585a.41.1792357503555; Sun, 18 Oct 2026
 14:05:03 -0700 (PDT)
MIME-Version: 1.0
References: <20261017050928.128582-1-sidchintamaneni@gmail.com>
In-Reply-To: <20261017050928.128582-1-sidchintamaneni@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 19 Oct 2026 05:04:51 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4whqGRQ4JY5rLLJZU=f8u5T75qHkJYQFDoqZSx5c6EBHQ@mail.gmail.com>
X-Gm-Features: AclHuK--x7DVGO_dcw8j_MNytrS7YLiy9sMauVU8tR1EJZ2OhP3EMm1WXJm10Fc
Message-ID: <CAGsJ_4whqGRQ4JY5rLLJZU=f8u5T75qHkJYQFDoqZSx5c6EBHQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm: multi-gen LRU: fix NULL lruvec->pgdat deref
 with memcg disabled on cmdline
To: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	yuzhao@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	apais@microsoft.com, rlmenge@gmail.com, stable@vger.kernel.org, 
	Hardik Garg <hargar@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5pncyutkwtuwacgsciggbe8gbz45hrxy
X-Rspamd-Queue-Id: 7323018000C
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792357505-388297
X-HE-Meta: U2FsdGVkX19zjsnqOQVxvgKCSn6v3Mzvomamwrd/JL5LSn0g9T3PD5IFan+5Z6xZAkWPmbucZfRO1wN8+OA4cxHLil8dWQG/lMxmEvhC0eSqIhakrDRYsecTwWF6n4FyVba1xYytER7uuirFgqCEOxJiSEA7Wmng/RW/eDkNSPSf9urkO6NKmOC8k2fOcrmvRM5Ng7yiKUJZcYnkbSwkGVn2fy7kdE54U07BwZ6bbMozHsu6x/u6YfDNqAfhcOqEmANi7nNlCDFG6zHpbXfySjaum+O+3k5u7FMbGmtKaCmWtRRp5tkqzTL66/7jnEkJ1cklNA35GZNugdNUNq4PHJqFMsehO3Nl/gGimZQp+ZywW8mSiE/DffroADyoRrQh+VdW6QLlKCxSae2RnX2DYTbFMnGzeG+flX9PyqVZse1kvGlsGNE5b2UL24/BCbAAIERC9IQKrWxSOLw57fJbX6d8m854+kPK7e+6qq3pACMim/qoGb4flhirg2KX8biCgU1WQFp9M8adeKWhDh7tfgvlz8EKnfA0cD03jTmN9gnS9dYRAqsEULXRQcO1g/bdJnI4CYwBzIjYjmEtvUUBLTDM7lCMfOnWNzHqnHG/o2FpWH1z3EgUmF6keJypZOz8g8wcNzqsHTsuqEtrrOzWrGgrgEemeajiy7UOzWnHBOUxH2BwPjaYJFic7+xBhtHLdm02nrBM/BiFLU3VvqnDp6yY8vLuxkEANO1jvlzlqu31w924MbOl9sfB61TyrQ7OP/e0/7TrkrrI/WbRoAEPVDKEMxeeDlOrBtQsN1rCMCphcEGVkubOnPepb2NNN9FgzC1f1AQnCOcClBJPbnq0fCQA15fEpIrnCGOsSUTmciu6c8U6CcQlGB0mfJA8g/zjXAV/VExXQDsN0qauM8QH6/og2UmVVvCtzNGAvwhawAjJUgtgrIrpg1Oi6nDUqM5xpzPTD1yGvvscOWL34wx
 AJ2XdKO8
 5EuGUrf/B9seEjpZtu+AXZkMC9ABjxtM98RwMcfLAALyKrYnethXOBE9EI3AUROm7TdeOr2V1Yww23R8312wLy44AoSnR9KbcMBqM1c2iI+L52IMRKCY79N54u9wtKehzbUObmNusChFcnJz1vYppK2HJObiHG8k9eQkjQszHIUGde3Nba5M0WVMgemIZmJ0U9WlzKP1s0f5tD/vQr3c1YfIfi2jiAGnggEBbLKyTlIA8G2jUQcdIO4UNcW8QPRHHFn5HJoT1gPPk9d3VF2rqmqGPBrWzeReJtUwqWweYr8bDdbhxzeN3ROcFeBpTvjAaB+pGTBIQHaNGZ5Zk+Ox117EC5Mm1flQ54KPGaa7qIbq9C8E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 17, 2026 at 1:09=E2=80=AFPM Siddharth Chintamaneni
<sidchintamaneni@gmail.com> wrote:
>
> When CONFIG_MEMCG=3Dy, lruvec_pgdat() returns lruvec->pgdat, which for th=
e
> per-node pgdat->__lruvec is left NULL by lruvec_init() and only filled in
> lazily by mem_cgroup_lruvec(). Normally that happens early, e.g. on the
> first folio_add_lru().
>
> With cgroup_disable=3Dmemory, lru_gen_shrink_node() passes &pgdat->__lruv=
ec
> directly to shrink_one(). If direct reclaim runs before anything has
> called mem_cgroup_lruvec() for the node, which can happen during early
> boot under memory pressure (e.g. a kdump kernel), get_swappiness() ends
> up dereferencing a NULL pgdat:
>
>   Unable to handle kernel NULL pointer dereference at virtual address 000=
0000000005040
>   pc : get_swappiness+0x68/0xb0
>   lr : try_to_shrink_lruvec+0x54/0x2c0
>   Call trace:
>    get_swappiness+0x68/0xb0 (P)
>    try_to_shrink_lruvec+0x54/0x2c0
>    shrink_one+0x8c/0x240
>    shrink_node+0xc6c/0xe08
>    do_try_to_free_pages+0xdc/0x570
>    try_to_free_pages+0x124/0x278
>    __alloc_frozen_pages_noprof+0x6e8/0xf78
>    alloc_pages_mpol+0xc4/0x1c0
>    alloc_frozen_pages_noprof+0x54/0xe8
>    alloc_pages_noprof+0x1c/0x40
>    atomic_pool_expand+0x98/0x300
>    __dma_atomic_pool_init+0x58/0xd8
>    dma_atomic_pool_init+0x154/0x170
>    do_one_initcall+0x64/0x350
>    kernel_init_freeable+0x214/0x430
>    kernel_init+0x2c/0x208
>    ret_from_fork+0x10/0x20
>
> The classic LRU path and MGLRU before per-node lru_gen_folio lists
> obtained the lruvec through mem_cgroup_lruvec(), which sets
> lruvec->pgdat.
>
> The above was hit on an arm64 kdump kernel (6.18-based) booted with
> cgroup_disable=3Dmemory nr_cpus=3D4. It also reproduces on mainline on an
> arm64 VM with CONFIG_ARM64_64K_PAGES=3Dy, CONFIG_MEMCG=3Dy,
> CONFIG_LRU_GEN_ENABLED=3Dy and:
>
>   mem=3D160M nr_cpus=3D4 coherent_pool=3D512M cgroup_disable=3Dmemory
>
> These options only serve to force direct reclaim early in boot; with
> 160M the boot eventually ends in OOM regardless. On mainline the first
> LRU reclaim happens while unpacking the initramfs, and faults the same
> way:
>
>   Unable to handle kernel NULL pointer dereference at virtual address 000=
0000000005040
>   pc : get_swappiness+0xd4/0x150
>   Call trace:
>    get_swappiness+0xd4/0x150 (P)
>    try_to_shrink_lruvec+0x44/0x2b8
>    shrink_one+0x80/0x1a0
>    shrink_node+0xd98/0xea8
>    do_try_to_free_pages+0xf4/0x4b0
>    try_to_free_pages+0x110/0x360
>    __alloc_frozen_pages_noprof+0x8b0/0x1718
>    ...
>    __filemap_get_folio_mpol+0x2ac/0x548
>    simple_write_begin+0x44/0xf8
>    page_symlink+0x178/0x198
>    ...
>    do_populate_rootfs+0x13c/0x200
>

So this happens before any folios are added to the LRU and before
the userspace init process starts?

> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> Cc: stable@vger.kernel.org # 6.3+
> Assisted-by: LLM
> Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
> Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f11491ee9ed5..0c57e4f1eb15 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5253,7 +5253,7 @@ static void lru_gen_shrink_node(struct pglist_data =
*pgdat, struct scan_control *
>                 sc->nr_reclaimed =3D 0;
>
>         if (mem_cgroup_disabled())
> -               shrink_one(&pgdat->__lruvec, sc);
> +               shrink_one(mem_cgroup_lruvec(NULL, pgdat), sc);

What's a bit weird is that even if we fix this here, with an empty
lruvec, we still won't be able to reclaim a single page. But it's
hard to see where we could break out early, right?

>         else
>                 shrink_many(pgdat, sc);

Best Regards
Barry

