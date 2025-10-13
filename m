Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38110CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 18:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7C78E0029; Mon, 13 Oct 2025 14:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47EE58E0009; Mon, 13 Oct 2025 14:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB898E0029; Mon, 13 Oct 2025 14:54:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1908E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:54:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B7A8946C8A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 18:54:11 +0000 (UTC)
X-FDA: 83993991102.15.F8FCC72
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id D6978A0004
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 18:54:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=It+9jCk0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of edumazet@google.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=edumazet@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760381649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHvdDoFLXKQzTfUBohM5QpfVzGeutBShrm8qkwsGAgA=;
	b=YaSEGnZ8KThhUSi+Bli1WWwjthiqHBgL2I21rSjkJw8pkv2G+8Z40TyloecaWbUtHSnlyH
	TOofsF4Yq3YHnucWGeahVbiHH+8j8AtUF728YL/7HTIX5HR4AEL3GUgUFJ1wbyEi/VClqz
	bOiOJ1JmFtZMcqk3+Sdr3Jm/Z8cWJKQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760381649; a=rsa-sha256;
	cv=none;
	b=7Bkbi8S4zOO6VszCaiDBF7naiPwGso3rrg3k1ZHIF/GnxLmc76X9qsry8uAvfpFAIFGOAX
	w69WgkWpp5dTHpKjucaPWFUCaC/xUuuA2t+nqLqJuBPpzwHIpHqtrEEwO8wEB77l7/khKj
	gTh3E7CTfKeVoGIn0YTu2JDtiWvq7vo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=It+9jCk0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of edumazet@google.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=edumazet@google.com
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-85d5cd6fe9fso463855285a.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760381649; x=1760986449; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OHvdDoFLXKQzTfUBohM5QpfVzGeutBShrm8qkwsGAgA=;
        b=It+9jCk06Vaar+icAPDS96+ayL0S8EALXcDuV4sVbUZPZlRKYnuk79tJqLZdSoMZT0
         XWSb1KkCGEGKySy6laJDC85/RCRkDZqrhUbxibGhdRJtKijH2jMEi3eBA8pJAssvIojE
         qo8WxBb5FIJ2F8I3ol/H3eVM0ohdKdWArb8FJtp4yubGjrffADlsoBpuLY68vSyfahbv
         KVqjpGFBtSvYK2YflnwCter9oee1b4em9cBWTh7mrQxLWJ7l6s9JZd487IsXQxTK3ro/
         JC9funAPxoH/r7aEVcLWo+A7qHlpB1K3DkIWbnEnmvxqyfIIkEG40p5suLpOpmQE33pR
         1vhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760381649; x=1760986449;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OHvdDoFLXKQzTfUBohM5QpfVzGeutBShrm8qkwsGAgA=;
        b=BNopWlH3kX0JcRFTSejEPnSXAAUC6p1FedvAnd5lTFT9gj+zdqHk8W78XB5UptevFO
         Sb3AHGssJCopIHSw46Rdch5roVKnCDPYPrvFaEWwoL9oLAr217WTgEqr3zAQa9lxjEik
         gEGX20/0eKeE5F6Mq4u30MSY0ZEVqMVaBp8RT/jJYxsLyacBp9i2Eco+xqBO1BLC6xp7
         UNmiXZA8sucOV+b0i4NDAWdqD7LsKNKcSOhCxFuY83BzavwYTTRs4rHnN6XqR0Ta4vSo
         Z8/ZE2d7/HK9VhQtrFMxTHS5BiXAbtJCZ4FIBr/DE0TWEMkKVA55PPcSUrTu7ZocHUCk
         jGIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSOTUUdM1kmz5BgteocA2qiBNhOyVLL3qkAAeFChfACKfKRDVmy+mPxJ6qh/D8K8wFamVtkrZsOQ==@kvack.org
X-Gm-Message-State: AOJu0YxXVZLpRnVk5o33woQ9NdLftroClwgEuCwr1ck8X0qOTUjfJzY9
	rHy3ZH0q5m0gZ/JPhmduott/bikWmbWvsyZNGN5b/rGKzEIwASK3OTBxiDPy3KCIGipHvJi7hdV
	4kA/h6zuEnK0/TSyPqw0TaKu1kBsyhmT27jANhI54jWWHqrOkP2S9qy/6
X-Gm-Gg: ASbGncvgHcohWntM62RwAW1GwHGcr3o7ivoQhK1CKKdXoRb9BuX5LOXz0pnbfOKClmR
	GrqxJr7+cvoK572ha/bDSzDPpftutlAKosRXsWWQqv4VgDym/ufEEqWP7huSFvCIyJJzTglHaV0
	mq9ClLDbeGTnp/g14Im4S6Yl7m8NUnwBfb+9eeO2XkFd5v7dnD0aTYvZaBxuPdzNegeiDw8fGuV
	cY/Le7rSMILBzVUtQ41ILDu0LHtCcaD
X-Google-Smtp-Source: AGHT+IHEX/LXCcXiIAvMWCf1qx+3kkMbx/P3MOisSt6xugJLgd5lVynv5AI5WAJHsRmWmbQAX0ncoNz5Nk1IfQjetPE=
X-Received: by 2002:ac8:5902:0:b0:4de:b0d4:dda4 with SMTP id
 d75a77b69052e-4e6ead7493fmr328872751cf.69.1760381648539; Mon, 13 Oct 2025
 11:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <20251013101636.69220-1-21cnbao@gmail.com>
In-Reply-To: <20251013101636.69220-1-21cnbao@gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 13 Oct 2025 11:53:57 -0700
X-Gm-Features: AS18NWAe_NmExu5WITMBDbR0FpCc3scky7DNzwEUSRCGS5tETmNSC2IUauhYc4w
Message-ID: <CANn89i+wikOQQrGFXu=L3nKPG62rsBmWer5WpLg5wmBN+RdMqA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
To: Barry Song <21cnbao@gmail.com>
Cc: netdev@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>, 
	Jonathan Corbet <corbet@lwn.net>, Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Yunsheng Lin <linyunsheng@huawei.com>, Huacai Zhou <zhouhuacai@oppo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: D6978A0004
X-Rspamd-Server: rspam02
X-Stat-Signature: kq66ktqi841iknn319j9hae16a4qofxh
X-HE-Tag: 1760381649-172504
X-HE-Meta: U2FsdGVkX19WOcvxfA0hUuAYrpq60pLFVZwvUR/hREVv7R7ecYEifX2Iqsd0lGxGskoW+j9dSfwu2xyQusKuxqjVok0lbYh6O7sGY912Egmeo1UkrqzmbkXKYMASvSuCKatUaY1hlh3w8BNBnbbfFu+YZ6Ako8KWWRHx3fIMu6UToFcp2VOfUBpbETXlzCKXalRV1TG9XjuY+0Yrx5guqkhI10yCTkRNdn3c45uaS5V5wvJJ3NhyxjSHun/BE3bWHJQgTax2wNI6nmkTvFHzC5LUxSuaiDilML4kl1bHDyrt8d12Uhc6Ck+m4sQVirTM6ShRAeQbWgJYYaKfv8vFYJ/9ufqnCEwKLKtUMETLdA4vs2ivOGXy9W8OLQAW2ngz7NvXHWGlCayOi1eXNYB58BjR/rANjqnG5JcOYv+1YC5wqSfPY0aFsFRh5unqm+D2+mGhw35tf4raVqO/Gjigk5iUvpoBoZu83cTf9AUuP5+ozlRo+1Ccyky5b/50PQIfzbwaZSSuxj4tTJxE15VOKpaNv/3W5pxCPuEnaSyx3VqM+i5yg3wtLeyMXbRT2mMd/UkXiNAAg0YGMLwjmXTsZixmf4YGElUnAU8NRD5fp8jCIoSbl7vqBIHpVy5tb5lZHxuZQvI+TXH4WCtpAL076c0VfpMp0CrxrTyJXBusRHvCrbcgNm3s6CaXFOaDh6li7G1cVh9Hbdf/eiokjMG8iaHJzfcE2nmmyGFHwYiIlypqzuDiQQCGr4KS68HFOA3PEKDEJFYfg82yGbjFRZPzAiiuL5mOgE1ZDNNFGCrS3OfRL4o7j23QICABoc7gd/jbzyM7jOSEYO3kAGPfyKBZ3NIKW4f4ifqUfDB8HreSof2v2ybUkvoPlOd7w+HGKEh9nYdn9EjW9jfr3/X/aU9nIRh2KozFM7giX1wP7v32M8zGAgDe4NrVkIdgXWQtP7ruKSXuA50f4j5PIN6n29Q
 BhlRIHA5
 7TxauDr5xXcMVZWWR+fuieKvOg+4qO9evan2nBUthL33qi9h2mzUPCLVolYz7AphHA3mxwVlaXFUbXwVHPG9Vz/nNg2LObgdPpOCP3H74h3nPC2TwkmbZ32cxXmVkf0DVlZF4VEDhFD6MtWY6j1RLdioluNOnR3djF3qfervVmbxpot2ehmuEOnOxXNUKtVkDah1md5Q8JP0JSPnjm3hhuSd4dpYgXrki2E3bE8cC5V4w8VVwQELSu2nniQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 3:16=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> From: Barry Song <v-songbaohua@oppo.com>
>
> On phones, we have observed significant phone heating when running apps
> with high network bandwidth. This is caused by the network stack frequent=
ly
> waking kswapd for order-3 allocations. As a result, memory reclamation be=
comes
> constantly active, even though plenty of memory is still available for ne=
twork
> allocations which can fall back to order-0.
>
> Commit ce27ec60648d ("net: add high_order_alloc_disable sysctl/static key=
")
> introduced high_order_alloc_disable for the transmit (TX) path
> (skb_page_frag_refill()) to mitigate some memory reclamation issues,
> allowing the TX path to fall back to order-0 immediately, while leaving t=
he
> receive (RX) path (__page_frag_cache_refill()) unaffected. Users are
> generally unaware of the sysctl and cannot easily adjust it for specific =
use
> cases. Enabling high_order_alloc_disable also completely disables the
> benefit of order-3 allocations. Additionally, the sysctl does not apply t=
o the
> RX path.
>
> An alternative approach is to disable kswapd for these frequent
> allocations and provide best-effort order-3 service for both TX and RX pa=
ths,
> while removing the sysctl entirely.
>
>
...

> Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> ---
>  Documentation/admin-guide/sysctl/net.rst | 12 ------------
>  include/net/sock.h                       |  1 -
>  mm/page_frag_cache.c                     |  2 +-
>  net/core/sock.c                          |  8 ++------
>  net/core/sysctl_net_core.c               |  7 -------
>  5 files changed, 3 insertions(+), 27 deletions(-)
>
> diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/adm=
in-guide/sysctl/net.rst
> index 2ef50828aff1..b903bbae239c 100644
> --- a/Documentation/admin-guide/sysctl/net.rst
> +++ b/Documentation/admin-guide/sysctl/net.rst
> @@ -415,18 +415,6 @@ GRO has decided not to coalesce, it is placed on a p=
er-NAPI list. This
>  list is then passed to the stack when the number of segments reaches the
>  gro_normal_batch limit.
>
> -high_order_alloc_disable
> -------------------------
> -
> -By default the allocator for page frags tries to use high order pages (o=
rder-3
> -on x86). While the default behavior gives good results in most cases, so=
me users
> -might have hit a contention in page allocations/freeing. This was especi=
ally
> -true on older kernels (< 5.14) when high-order pages were not stored on =
per-cpu
> -lists. This allows to opt-in for order-0 allocation instead but is now m=
ostly of
> -historical importance.
> -

The sysctl is quite useful for testing purposes, say on a freshly
booted host, with plenty of free memory.

Also, having order-3 pages if possible is quite important for IOMM use case=
s.

Perhaps kswapd should have some kind of heuristic to not start if a
recent run has already happened.

I am guessing phones do not need to send 1.6 Tbit per second on
network devices (yet),
an option  could be to disable it in your boot scripts.

