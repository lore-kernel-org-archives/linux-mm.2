Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B22C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 23:35:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C6E66B009D; Tue,  5 Aug 2025 19:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 477576B009F; Tue,  5 Aug 2025 19:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33F496B00A0; Tue,  5 Aug 2025 19:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2396C6B009D
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:35:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7E2F114FC7
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:35:46 +0000 (UTC)
X-FDA: 83744313492.18.923D76E
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf02.hostedemail.com (Postfix) with ESMTP id EBDB380008
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:35:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s3CN78Af;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754436945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WEcHjBitTOhgeyvhST79Xx0fm+K/l28u0tFs3KRJokI=;
	b=OFTFJZfGNilLNGcB3gYJVrVAK93KtPPoFyV1D9/GqtIhQEahe+MtK4v9+hnJOSNujgTmPH
	nwf5Sngm1p88yzYXyCw7KBmcV+25ZOjARcx95ZKQ3+3GmEzywHb2gLdEYE1hnK0BlrMDNG
	ly737fvQQg/MiT4D7sXh2Xo3htEPy7o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754436945; a=rsa-sha256;
	cv=none;
	b=k6nRLSLslsvbmJtt1r888ThwsKqr5Zbe18MXPy1QcnnT0DkGNwznd1Ox8UPKbsH2KZvn2b
	0PrFF/1GOYStPsb6G4VZb6sQkaIQqPzI5htzRF+4UVo2200ayPvjtZO/OInQpNsju1Rsa4
	pbK0GMEvP8EksX9C3Eum+EBIrbVwFyk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s3CN78Af;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 4D09BA56820
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:35:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A68EEC4CEFD
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754436943;
	bh=dfkF4zvAOrOAcEgTbDmIN6zbS+Jp+b4BXY/3cALRqYM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=s3CN78Af9yWKiBUxjlkgWJhfr4II0NvCuH4P+hENta1qr5y1VUHImFg4s3fZSe/ve
	 cS1IQlvh0ARJWO2rcxnZVxatO9PhaWaSjKECPAy/1UWzhG1RaXBQecz6+udMxamGp2
	 Wnv6QSyxNxjdIS/b7vc4HwOMGDkHvm9/Y3uBmaK0G9g8MVMxlhTf0CU6PXChlACrJH
	 TwGnQQhWI1eq7d8FH4C0CaVmuy960tyRCr4RidvQRYpSNGYxx6g/2kfg28jzukHv8f
	 qlAfgmnrxeySqGNOlon4nOsnFlHVpssWtEWdFktZAnr2C66wj9l4qZVjDm8PBA674I
	 FH5h3D+xNn9fw==
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-459b3904fdeso13335e9.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 16:35:43 -0700 (PDT)
X-Gm-Message-State: AOJu0Yyk1KrJgMQVqaU9fTaiiBhLvk1ZBq2x+LvBSKDgiMvTc/nEQ2TE
	MTdTPfEjMPk3493lCA1raCAJ4cX/1Gye3EYztYgDqeg9d4yA0Umou1QEt2j4AZxO1Uz/ceMxmFl
	aUvzZkLGZ1G3DtBx5S3M12tW6FgBPt+2fPh98Ocq0
X-Google-Smtp-Source: AGHT+IGfyIalU4sN4H/oUM8GTkhl1j2T8Urex0TikGxCJcfJ+0k0dcHQ0Be0nqxa0koy6Uz18uZaVunzfvOXK8orVDw=
X-Received: by 2002:a05:600c:c0d4:b0:453:672b:5b64 with SMTP id
 5b1f17b1804b1-459e6d019d5mr494105e9.2.1754436942237; Tue, 05 Aug 2025
 16:35:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250804172439.2331-1-ryncsn@gmail.com> <20250804172439.2331-3-ryncsn@gmail.com>
In-Reply-To: <20250804172439.2331-3-ryncsn@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 5 Aug 2025 16:35:30 -0700
X-Gmail-Original-Message-ID: <CAF8kJuPCZ8BEEAWT4QYVAMW4BD_1=77NuJySnWo3TopegOH5Gg@mail.gmail.com>
X-Gm-Features: Ac12FXyZva7-b-yvuQVjG4V3fUaLnUEQDNn-uRvVqaWk9MtjWv3FA-Q454exq7c
Message-ID: <CAF8kJuPCZ8BEEAWT4QYVAMW4BD_1=77NuJySnWo3TopegOH5Gg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm, swap: prefer nonfull over free clusters
To: Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EBDB380008
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: am7fdpo8dtpbo5cnfr8piwzjbddzqtgn
X-HE-Tag: 1754436944-215654
X-HE-Meta: U2FsdGVkX1//wH8QGr5CYWsszZthO+886uh6FY/x2sC4A1/7UMEtwMSmNGwSzfT11EAzbSNMPfYn8wZQn1h8xwYoIWprmxClrMc/8Bgl4o8/UJrD1G4YgGS9cduhCUEba8Yvy16GqPNFGokFnbPmM2z0S5wtcdeux33sTHHM5VUA0a8Zp/LgDpa6Yx2HZ6Z36o7rKBsbnlrCli0t0iQtm7cB1wbp3EeWQXSdffFxAlEf2nh7myPelCxslklJyJDcI5lYKmeSKsnNhwo+qPAJok7CTpk7fRAzCE08ELTOk3WsIZCz0wUwSf6KGadirDP+QhA7UnB1K+0FUe3AXjbCGTy2gG3atTs9K1WfN7lda1ZG4ojrFi4RThAw/gzTWxZrkhFulY5LNOe1uufNOo+U2hp3ttlIE/gfRLoaChVSHTHyn9VS2puGr1AXPmR6wXj2SXNvdbxPHkz50OpmJHehrVDuUXPXQ3TQsycyz6u6/+Zx/XuR83gH4THZgIeXs58ojMrWZwvvtrK6K5vCUxPNJYuw3KxcrgGS9q1Zd4SpWi5sIZtj/ELzKiQ2J7zmFw6kkGAzBpxuLpH+WnVu23vXhtKDlsWI8ynQJBThAtfjWxwf2PEYlL0vputyXlaPHmjUb4TJICu9AJIU9Vwo0seRBRXmEqQHECtLI+u0sMu2enmFykaoFviq7cNg4vvIjKxe/REe4HGgVwyDFji4k9tnnmMDfESw3ZdfvDDfRAxdUdu65knXfKZkCYNdhgpw7DXwmTrkKMam3/FJgihqt7FBXQ7vRv8m78pwRC6OCxkMjN8Xh2Ud/j34CJnOXzoXF4byNxYyWFpoeeaJVtTdcbZ8bxDRUGgyiTnKDnKx6dLPXZYiY8lCHjP0Nnjg8MzJcI+e6eE68nYKhr591kDPP/5G+6iqlp1VNAXIAaZNt3Pi/ei+OgRhhAt1o2quq2lTp5BEyk8wQ9YTYfzysgBHS7E
 8jGBDRZ1
 5UwKhFH91PMCKmT0Hn98Wcrym7XtmVvN7hQb+wJ7pLjrAjXAyTB5yohNdNveJxrgX7WegjPXr5/Sha4MYvBdeYoT0aPDtw7IzrV6KotTscX64vHHAxjOKvUyWJ+c5Ag4gmBi/aTjvY5PPi86hTjmNSrD0Kqy5/B2XbQyksY3l4XFc1UvosqEvzduEkYX0sS9VW9WGX3tXvCi6e9LmgiKO5mHAVO0Bap5v/z11fGxpQpeh20xhcbKp2wLL8pMrKX7eY6ryvBKuBUf+Rg4+meC/pTDyAcMhXrGJuSyt3Iq1uC7Ve99yX9GdKuOEg5xGcgsqiWA4JkItTameBNY8KEZaHUEHpn4ICv583MLJji8zn3y736FBw8iC4xSJyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Acked-by: Chris Li <chrisl@kernel.org>

On Mon, Aug 4, 2025 at 10:25=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> We prefer a free cluster over a nonfull cluster whenever a CPU local
> cluster is drained to respect the SSD discard behavior [1]. It's not
> a best practice for non-discarding devices. And this is causing a
> chigher fragmentation rate.

Not only does it cause a higher fragmentation rate. It also causes
limit working set size over a long period of continued swapping can
write to the whole swapping partition. That is bad from the SSD point
of view if the swap page access pattern is random. Because at random
access patterns, very few clusters can have all 512 free, which can
reach to the discard. The previously preferred new cluster approach
works best with batched short to medium running cycle jobs, so at the
end of batch, there is a time where most of the working of swap is
released. That can release the nonfull cluster to a free cluster. For
long running jobs and random access of swap entry, very low change
frees a cluster to discard.

This patch will cause the limit working set to only write to a limited
swap area. Which is a good thing from the SSD wearing point of view.

Chris

> So for a non-discarding device, prefer nonfull over free clusters. This
> reduces the fragmentation issue by a lot.
>
> Testing with make -j96, defconfig, using 64k mTHP, 8G ZRAM:
>
> Before: sys time: 6121.0s  64kB/swpout: 1638155  64kB/swpout_fallback: 18=
9562
> After:  sys time: 6145.3s  64kB/swpout: 1761110  64kB/swpout_fallback: 66=
071
>
> Testing with make -j96, defconfig, using 64k mTHP, 10G ZRAM:
>
> Before: sys time 5527.9s  64kB/swpout: 1789358  64kB/swpout_fallback: 178=
13
> After:  sys time 5538.3s  64kB/swpout: 1813133  64kB/swpout_fallback: 0
>
> Performance is basically unchanged, and the large allocation failure rate
> is lower. Enabling all mTHP sizes showed a more significant result:
>
> Using the same test setup with 10G ZRAM and enabling all mTHP sizes:
>
> 128kB swap failure rate:
> Before: swpout:449548 swpout_fallback:55894
> After:  swpout:497519 swpout_fallback:3204
>
> 256kB swap failure rate:
> Before: swpout:63938  swpout_fallback:2154
> After:  swpout:65698  swpout_fallback:324
>
> 512kB swap failure rate:
> Before: swpout:11971  swpout_fallback:2218
> After:  swpout:14606  swpout_fallback:4
>
> 2M swap failure rate:
> Before: swpout:12     swpout_fallback:1578
> After:  swpout:1253   swpout_fallback:15
>
> The success rate of large allocations is much higher.
>
> Link: https://lore.kernel.org/linux-mm/87v8242vng.fsf@yhuang6-desk2.ccr.c=
orp.intel.com/ [1]
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/swapfile.c | 38 ++++++++++++++++++++++++++++----------
>  1 file changed, 28 insertions(+), 10 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 5fdb3cb2b8b7..4a0cf4fb348d 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -908,18 +908,20 @@ static unsigned long cluster_alloc_swap_entry(struc=
t swap_info_struct *si, int o
>         }
>
>  new_cluster:
> -       ci =3D isolate_lock_cluster(si, &si->free_clusters);
> -       if (ci) {
> -               found =3D alloc_swap_scan_cluster(si, ci, cluster_offset(=
si, ci),
> -                                               order, usage);
> -               if (found)
> -                       goto done;
> +       /*
> +        * If the device need discard, prefer new cluster over nonfull
> +        * to spread out the writes.
> +        */
> +       if (si->flags & SWP_PAGE_DISCARD) {
> +               ci =3D isolate_lock_cluster(si, &si->free_clusters);
> +               if (ci) {
> +                       found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
> +                                                       order, usage);
> +                       if (found)
> +                               goto done;
> +               }
>         }
>
> -       /* Try reclaim from full clusters if free clusters list is draine=
d */
> -       if (vm_swap_full())
> -               swap_reclaim_full_clusters(si, false);
> -
>         if (order < PMD_ORDER) {
>                 while ((ci =3D isolate_lock_cluster(si, &si->nonfull_clus=
ters[order]))) {
>                         found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
> @@ -927,7 +929,23 @@ static unsigned long cluster_alloc_swap_entry(struct=
 swap_info_struct *si, int o
>                         if (found)
>                                 goto done;
>                 }
> +       }
>
> +       if (!(si->flags & SWP_PAGE_DISCARD)) {
> +               ci =3D isolate_lock_cluster(si, &si->free_clusters);
> +               if (ci) {
> +                       found =3D alloc_swap_scan_cluster(si, ci, cluster=
_offset(si, ci),
> +                                                       order, usage);
> +                       if (found)
> +                               goto done;
> +               }
> +       }
> +
> +       /* Try reclaim full clusters if free and nonfull lists are draine=
d */
> +       if (vm_swap_full())
> +               swap_reclaim_full_clusters(si, false);
> +
> +       if (order < PMD_ORDER) {
>                 /*
>                  * Scan only one fragment cluster is good enough. Order 0
>                  * allocation will surely success, and large allocation
> --
> 2.50.1
>
>

