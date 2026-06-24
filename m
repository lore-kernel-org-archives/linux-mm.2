Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3480CCDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 18:01:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85246B0088; Wed, 24 Jun 2026 14:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D36366B008A; Wed, 24 Jun 2026 14:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4C6D6B008C; Wed, 24 Jun 2026 14:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A19256B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:01:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18E8AC1D70
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:01:18 +0000 (UTC)
X-FDA: 84915573036.16.691260F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 25A4840022
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:01:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JoV8XehZ;
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782324076;
	b=uxIllXCS9S+SyGWMon4r/+uY5O8Sdwji8ToCHSD0fKVSAlrEgUute+T0XUoG/JM615kp7Q
	3LQgeOsBn6eal10nS3DejDFIlqTYaHO7PHOI13MlmmOGtH5+dBqqCqdUKmfGLD/jxxlK57
	OpvEnGb6yHl+nFN1YhucriS7PDQnXWc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782324076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5K8yajDahcpF3gW5nVYq9HPN+SJtpH2p0tgpm74RwM=;
	b=QEXxrWiPUcWGceHvCVOr7qec5z4pYMWwjEzhcFPgtivtQY5fBaj7Knzt3kGmmB8ofyx4l9
	9Z/sfHnmX4M3U3rsDGGD8uuDIwQMiEVcazBAo8eTin/PYqCDPEV2rgCwsZdga3KT5y81ri
	7zspqgHFmazjWv52Xo7sO/T00VzRMRI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JoV8XehZ;
	spf=pass (imf04.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7AE11600C3
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333C21F00AC4
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782324075;
	bh=t5K8yajDahcpF3gW5nVYq9HPN+SJtpH2p0tgpm74RwM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JoV8XehZaE6IUI4rabX1JrUT7d0izzF4yWFs6AxK0SrH3E/Ee9rnY6qGzb62Zgp+x
	 +Ab82MT93mdDBsDMi65sl58I40ayBEanVSq2rXuPa8K5TXWrIz/+2dhmLeJf9vh8OB
	 NAd4yAaO6QJTr/6xx6E7z2tH+8AO2Vq84gfeQv3Zo69qm4BxessccWxw8bh2Q62a+Z
	 tyV8+b8IM8Z8Qm27ERolLvGbaUTWJbozoPeqTEtUwIzpRZfQmEvnt9oFnhShm3nZ83
	 SfBfM2ul6npLMsnUoclLEABO1NxwHdOemh7CK35VPRpPrFaq8Bl5dDpADGmqyr1KO8
	 3DGYeyIo81MWA==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6978f0870c9so2163039a12.3
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:01:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+UYPlkcEt/18sE1vB9kG1VmUlU4GvT2GXsZ5Mi2RmALkoE+L3s009cVAXZMNHRriSDm36DCWOhow==@kvack.org
X-Gm-Message-State: AOJu0YzzDngseH0S/XtOPpuxAuDtXftTXwMVX8DvELkz8j9Ar8VUF/dZ
	K2ckhVqJMY3HR4QGtQfyvN5Hfm71OS0MLb/N8R8xHfxQ+NqiPtXuvm4gqduGBhvFH9ecB6hUKxW
	R69qtY8pxwdDDSNxH81v5z82PWbwAe00=
X-Received: by 2002:a17:907:c205:b0:c0c:48b1:21ca with SMTP id
 a640c23a62f3a-c0c65adf4a1mr1077529566b.29.1782324074128; Wed, 24 Jun 2026
 11:01:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260624075700.751467-1-alex@ghiti.fr>
In-Reply-To: <20260624075700.751467-1-alex@ghiti.fr>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 24 Jun 2026 11:01:02 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNni28A+9BiDgDTBRuvGTKnqH91kpbpjjeftfnKSeSOJg@mail.gmail.com>
X-Gm-Features: AVVi8CfoxdmnJIxy9iOH_ckAT9yPQlvHSUeYeQrv_1Gv128ksqliXHGBPUVEnZw
Message-ID: <CAO9r8zNni28A+9BiDgDTBRuvGTKnqH91kpbpjjeftfnKSeSOJg@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: bypass swap readahead for zswap
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, kasong@tencent.com, chrisl@kernel.org, baohua@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1jfhfjyme7yzfys9z9rr6w1kekf6accu
X-Rspamd-Queue-Id: 25A4840022
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782324075-957938
X-HE-Meta: U2FsdGVkX19rhI+PXaZjcC9bPkRkb9P7XYS1nAx7mnl8ohdquXFxSHTscen0efSBKaefiIh/NQyVTlKHXXVTNbCnlsls1bjWxQsMsZhjDyi4OmAV6q7WZci8J8kH+TuJmEyyaY67fDWDBsicPY7Z5c81qASyHD7G1FAjWTAeIwUjiKJ7OkPgWCItZ6XHDtQB6xoXUP89OI595/2rqWAwupa4LWadcRwdAGUIAEOWc5oAmaKI4IdwXiaPRWQSgV7B/5cNBvj7ODcuovSlKUKj/Gr+JqT8fUxgrpuePZVmqskeyWroz1BkADMaXmSjeOFWdhqSskM/5lQ3pMYBAuMoU3ri+dLk02ebuuKcgPbbBffgfgKtXQ9mgZZmjx0x+XbBsyk/+HozVwPbVs7J70B6Tr6YS5m/odiQQjp84n9WUVzksp8dH6sG01wkgHwMscpIuQbdKraWOQQA8/0hKD2WcQZ1nx7RXqpLniuJQAm4waDN4x3524lQ4LRsu2Ff11DCIrdhAEBefHQhyblyyPsnptFXLGfjNR13OptaHemL8X/Yba4i56mNHkp6XRyfkGrBbrzNeUkLjLhwe3kLR0YrtEYBiPnsmL53XHyuVa4cmFk3Em9uwHFgyw9NffVJ5AU5z6q/eteZ9pFmhdSxJeGWEzKxVCG0YUsMJwCzE2aiNjK0//0WZwdbFi7sDo8udN/rFd0sQ4hKoFYfm6VO+MZdNnxZw7TgT0lAWqzeUUGnTkDKKytkborwtK5ApjaJceVsoXhNpx+xh5twoiCWcnDJtanzUzuvNSGWHpza35n5PywWlvmIhOWzZrwReRb3QHLTuUlGRUBPemQ8yCno5O6B9dmIFN0NcWxmckNpn+PG/0bBSivgmad+/go8wMiM3IEgAz8+Zj4/MWtcNycw90eHAJsuoARoLGjDm6x1m7dyjnNPs+TnyMvt37UIq6zYWNSIo6y64wJgtrYs7oy+C41
 fO7mycH2
 9uYHquIi5E54jMuTcpvRxAvPLfvM6Yya2vf9S6xHNcn+qVOy4fue7yL+Hk18YeHPpq0xERlQC5n7ZRow98gVn/MOogh+pkZRlZbiVAcVtkhg7GhAC6oXF7W5UWShI6JrxD7CjeeA/H7lesgUiR+EZu+VO1oUVXz5bajQfoVHIvuuGg9Bsv1d/IprQZFFV8AfBgFv7rkALZ07xQ7tSuzCTr1a9416Y31Jy4zgGGuuWmcDEQ1zUb/2nUG3d1zPpuxJTY/N/8TUbHwNDOraK9bZmZuLg4AArUiPKWNP1dVOzuzU6WiBVdio7eUZ+AWojn4r3bsTn87g1x+3TeNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 12:57=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wr=
ote:
>
> Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous
> device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readahead.
>
> zswap is the same kind of in-memory, synchronous backend as zram, not a
> swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
> swapin_readahead().
>
> Here are the results from bypassing readahead for zswap too: it was
> measured with a kernel build (make -j16) in a memcg, zswap=3Dzstd, shrink=
er
> off, on Sapphire Rapids and 3 iterations.
>
>   768M memcg (sustained swap thrash):
>     metric                 mm-new    + bypass    delta
>     build time (s)          405.0       341.7    -15.6%
>     zswap-in (GB)            79.5        53.0     -33%
>     zswap-out (GB)          144.8       115.6     -20%
>     swap readahead (pages)  6.79M       0.45M     -93%
>     swap_ra hit (%)          72.1        89.9     +18pp
>
>   1G memcg (light pressure, build not memory-bound):
>     metric                 mm-new    + bypass    delta
>     build time (s)          177.7       176.0    ~same (no regression)
>     zswap-in (GB)            10.2         7.5     -26%
>     zswap-out (GB)           27.7        25.1      -9%
>     swap readahead (pages)  1.07M       0.08M     -93%
>     swap_ra hit (%)          68.6        87.2     +19pp
>
> The gain is from no longer prefetching pages that are pointless for an
> in-memory backend: readahead inflates anon residency and thrashes the
> page cache (file pages get evicted and re-read), lengthens each fault by
> synchronously (de)compressing a cluster of neighbours, and adds
> compression traffic when those extra pages are reclaimed.
>
> Bypassing swap readahead for zswap therefore makes sense.
>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>
> - This bypass originally comes from Usama's series that implements
>   large folio zswapin: while working on improving this series, I noticed
>   the gains I got only came from the bypass of readahead.
>
>  include/linux/zswap.h |  6 ++++++
>  mm/memory.c           |  5 +++--
>  mm/zswap.c            | 11 +++++++++++
>  3 files changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index 30c193a1207e..b6f0e6198b6f 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
>  void zswap_folio_swapin(struct folio *folio);
>  bool zswap_is_enabled(void);
>  bool zswap_never_enabled(void);
> +bool zswap_present_test(swp_entry_t swp);
>  #else
>
>  struct zswap_lruvec_state {};
> @@ -69,6 +70,11 @@ static inline bool zswap_never_enabled(void)
>         return true;
>  }
>
> +static inline bool zswap_present_test(swp_entry_t swp)
> +{
> +       return false;
> +}
> +
>  #endif
>
>  #endif /* _LINUX_ZSWAP_H */
> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe92..5aa1ea9eb48a 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4827,8 +4827,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         if (folio)
>                 swap_update_readahead(folio, vma, vmf->address);
>         if (!folio) {
> -               /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devic=
es */
> -               if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
> +               /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devic=
es and zswap */
> +               if (data_race(si->flags & SWP_SYNCHRONOUS_IO) ||
> +                   zswap_present_test(entry))

This assumes that if the swap entry is in zswap, then the remaining
entries (covered by the readahead window) will also be in zswap,
right? While not very likely, it's possible that the remaining entries
not in zswap but on disk, right?

>                         folio =3D swapin_sync(entry, GFP_HIGHUSER_MOVABLE=
,
>                                             thp_swapin_suitable_orders(vm=
f) | BIT(0),
>                                             vmf, NULL, 0);
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 761cd699e0a3..5b85b4d17647 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -234,6 +234,17 @@ static inline struct xarray *swap_zswap_tree(swp_ent=
ry_t swp)
>                 >> ZSWAP_ADDRESS_SPACE_SHIFT];
>  }
>
> +/**
> + * zswap_present_test - check if a swap entry is currently backed by zsw=
ap
> + * @swp: the swap entry to test
> + *
> + * Return: true if @swp has a zswap entry, false otherwise.
> + */
> +bool zswap_present_test(swp_entry_t swp)

zswap_is_present()?

> +{
> +       return xa_load(swap_zswap_tree(swp), swp_offset(swp));
> +}
> +
>  #define zswap_pool_debug(msg, p)                       \
>         pr_debug("%s pool %s\n", msg, (p)->tfm_name)
>
> --
> 2.54.0
>
>

