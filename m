Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5435CD343B
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 14:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4803F6B0088; Wed,  6 May 2026 10:42:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431556B008C; Wed,  6 May 2026 10:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31FD06B0092; Wed,  6 May 2026 10:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1DDAD6B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 10:42:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA9FA120160
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:42:21 +0000 (UTC)
X-FDA: 84737260482.27.1E0769A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 004FCA000B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:42:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y8YkwgMC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778078540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0J67wmVcmxdyyojCVDub3uUhhn+KvzW9v1JfDO0b0QU=;
	b=K4N0hY+YA4vWo5aPtRBgz0rK0QOXiZAqr7itcn/CGvcDD6x7mehUTwwCN0tYpjbH+2e/NQ
	8bcbkfB/fITs4ZfMZ8UYqXSWp9LLYF31UwIHOVf6cO5YomJ/ckb177Aq38Pnx4hfr1cGtO
	FkLQ+62INHu/D0n/F7fP62F8oN+x3NA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778078540; a=rsa-sha256;
	cv=none;
	b=nsQKO7ePiW8LFo4/7hNJeUhpnfRuIUzi39IJ/MwrDPMJ+syhwZ74OG9Z+XcRIR44tJJ4Xr
	RiXei7rfNBSvcrtvdq+5KNSxLzV6qnsnKxZy3uBwvGd5kKR5NrIw4K/A++H4adWxBm0JVM
	AnNa3mgtUI4Qj5Kor9yiLTlkO8exS78=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y8YkwgMC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 548746015B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09447C2BCF7
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778078539;
	bh=Z4SlF8NBsQlFWpbQMVXeCO/cJjCPL7rhbRaYvnTwuQ0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Y8YkwgMCjVkxTjapUn2w/qpBksIOxExMFWQSeNig7diAlEJCHvAe+tJzJNv61OqzX
	 1dz8GnLfmUYgUOyVAvrIPYgBMUG0aC7AYRC3s0uKLyDCpt5DsjV5S6hFIDUQ2XymYA
	 +iZQbiVERJHWPFV8gqwO3bTsybmehXna5tip1ycvopJ+CHl5Lp0uSmVM4o0a6Gx0LW
	 u2f9ltr3JrWQNtrjjF0pGVXD9hWOLaCq7AnXpu8tFPq71grxCOjGfhJbFCGpM2tQJH
	 WepRUIXKkWPBZaog+C+g624PtjwNpViiR06u+l29ELaWIDTM2P6saqYFSxvKd6VTZo
	 NRiRBs/fhaPnQ==
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-79a535e7c00so81051407b3.3
        for <linux-mm@kvack.org>; Wed, 06 May 2026 07:42:18 -0700 (PDT)
X-Gm-Message-State: AOJu0YxOFeftmHiZGgQaIRTCJDI6I/kZKVn8Q/6PemYNdmV8eGD8yvT0
	fU02FKp7l8HKgbLxDF/DK7e3wjgUXWdm68WWzY9BoijEi7vYix47QZeKKtFK27a31Hay/tZ9/F1
	O3xjmtrcXfRYhA9iyflmP7Ikh/dnvitsJgrJ1SZ7noA==
X-Received: by 2002:a05:690c:388:b0:7b8:926e:3ef1 with SMTP id
 00721157ae682-7bdf5d6ba1amr42892017b3.9.1778078538262; Wed, 06 May 2026
 07:42:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com> <20260421-swap-table-p4-v3-2-2f23759a76bc@tencent.com>
In-Reply-To: <20260421-swap-table-p4-v3-2-2f23759a76bc@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 6 May 2026 16:42:05 +0200
X-Gmail-Original-Message-ID: <CACePvbX3Bead1Ea+UJfUAq0e4JNJ0P+yN0=zf5rhdPsH8y9PUg@mail.gmail.com>
X-Gm-Features: AVHnY4IwL-gw4Sl3FRXlNA5vHPxixzm39dfEKEl2DSbStJz8gX21tz29sDT583A
Message-ID: <CACePvbX3Bead1Ea+UJfUAq0e4JNJ0P+yN0=zf5rhdPsH8y9PUg@mail.gmail.com>
Subject: Re: [PATCH v3 02/12] mm, swap: move common swap cache operations into
 standalone helpers
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 004FCA000B
X-Stat-Signature: ibkqomcwo96tx9drb1oxyh359comqxcx
X-Rspam-User: 
X-HE-Tag: 1778078539-554120
X-HE-Meta: U2FsdGVkX19inECM4r9JgQuVqo6wVpK6phb4MNlOQTYHhv/MVPX3H/LLAK2kWiJ9FqGj0RFsmOeCgSwCU9YTWzZrSpjxLBxMp7c7lB0YsfU5M1SKSVRWQO193JJmE11MCDrAF4L/5weYWbod3bG8pd7YG2TnpktIblTV8mZTvKC82iKjq+r530y0kbGBRgA/yWSVWqnmrllOO7ZRxUG6n0F8+pvkyEfynzWSzm4X1G/cNDz2OOlanTuFBsBwnQmp0WJCqOAbPw+ADVQ1c5xDUQYfcWDeoKABnBy0ZgA/j2+gpXDyMqDNBOq2ri75pUVvNK3PEumJccb/tuFtnPaFDpQd2ZBLrWi8xv4MvyagpAUZjkBv5QYAcMYl4hdtYyRByELSID3VumHb2922oE6cwFAR8rP91T0s8pP2Xayoglj31sSs1fZpRuG+WsZUycUCC9IiV0VCwxUPkZdCWZdL/muakSCzl2tlZ34gpqJR/SrAVcxDWdGrTF2HoMfwGaxSNQkB7pXGzR1GF8IO1yHxqF9eHegxuf4x1jHioQoy3Szs6JrQaDUT2zdJ2vFZC0rHgt2bLiW0xriYuf7h2CF1DhgX2975vJZ6xQDqIRrBEwz+Hc2dhwmhLaKzAN16hryyEnXXK1cOhdoRMciB9JjMUQa+YS7Gsnv9A8iZjoTpLQiXZ1qW6ezxTkm81lXFzi98++HgRP6bAoL9lPnnTrK6T029K8pjo3FXHfRXiD5XxeXQDkgy9MF8oS6WbmxzxoNXyrBZIFzEAQXyTS2FEJG9P5B4hjMxkQpT/lMBdJR122oult6CBePZ6Kc2VTo91hPthhRcSEJcNq9VpGXN9Jj1K5qeIJhqAxu6y1Zfrx/NSR+ZDYqTbNrn0vxAa8Esz0EqmqKmBS3hRkPxK6ifGHwWWUmvj/GBSXPSvXirRjuBl6dIZ6ups97Uv1SYhx+ScYvEpcKPOeOJcna0Oz8k++m
 nlYQHIi7
 hM4d8mzQ8F67SvMJaNxG3ROuAsCSk0QOsCWMymRa5AH4WkPiv14+/PUjWUbqZZvQlTm+btB6qNQRAe2vHc58Ue3pu4JrFB13HOOM9zjKt+sz1d/SOVlrbnxS7PBwOrhv6iM9uf8B6l04Gw/HiD9RdcCjAxWsfGvcedaVWRISz+FoYzyaZ8uqFFAkiFcOYbci4aKhJrW79tfvANdWkf4CV6wKKabpeDbt5DyCaYXkChNG/Rh5GOY23yu5CcQkkYd4jv2VBck6geOuK0UxasRu72gj4wTmLlw/DGrvFsc7YvGDU7Ap3zH+D8g/pQaH88MS9K51loRS+xgBFu/I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 8:16=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Move a few swap cache checking, adding, and deletion operations
> into standalone helpers to be used later. And while at it, add
> proper kernel doc.
>
> No feature or behavior change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Chris Li <chrisl@kernel.org>


> ---
>  mm/swap_state.c | 141 ++++++++++++++++++++++++++++++++++++++------------=
------
>  1 file changed, 95 insertions(+), 46 deletions(-)
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 204a9499d50c..3da285a891b2 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -137,8 +137,42 @@ void *swap_cache_get_shadow(swp_entry_t entry)
>         return NULL;
>  }
>
> -void __swap_cache_add_folio(struct swap_cluster_info *ci,
> -                           struct folio *folio, swp_entry_t entry)
> +/**
> + * __swap_cache_add_check - Check if a range is suitable for adding a fo=
lio.
> + * @ci: The locked swap cluster.
> + * @ci_off: Range start offset.
> + * @nr: Number of slots to check.
> + * @shadow: Returns the shadow value if one exists in the range.
> + *
> + * Check if all slots covered by given range have a swap count >=3D 1.
> + * Retrieves the shadow if there is one.
> + *
> + * Context: Caller must lock the cluster.
> + */
> +static int __swap_cache_add_check(struct swap_cluster_info *ci,
> +                                 unsigned int ci_off, unsigned int nr,
> +                                 void **shadow)
> +{
> +       unsigned int ci_end =3D ci_off + nr;
> +       unsigned long old_tb;
> +

Nitpick: Can add lockdep_assert_held(&ci->lock);

Can check ci_end < SWAPFILE_CLUSTER and bail out on error.

> +       if (unlikely(!ci->table))
> +               return -ENOENT;
> +       do {
> +               old_tb =3D __swap_table_get(ci, ci_off);
> +               if (unlikely(swp_tb_is_folio(old_tb)))
> +                       return -EEXIST;
> +               if (unlikely(!__swp_tb_get_count(old_tb)))
> +                       return -ENOENT;
> +               if (swp_tb_is_shadow(old_tb))
> +                       *shadow =3D swp_tb_to_shadow(old_tb);

Nitpick: You can create a local variable for the shadow and assign it
at the end. Because it is a pointer, the compiler can't optimize the
store away.

Chris

