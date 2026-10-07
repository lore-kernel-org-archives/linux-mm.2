Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B3EBCA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 04:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D1A36B0088; Wed,  7 Oct 2026 00:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2820E6B008C; Wed,  7 Oct 2026 00:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14B766B0092; Wed,  7 Oct 2026 00:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDAA96B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 00:32:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 667B61A0434
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 04:32:47 +0000 (UTC)
X-FDA: 85294559574.20.52B01A5
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8196A180004
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 04:32:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=V3XWmskO;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791347565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ziYSY4OvbjG7dEn6zvCiVo/zloi2nFktnH/0C9O/jZ0=;
	b=fl7UR909ehsNxfRPhBY8hxO8F9YXfQ6qYKgv37pP8qaL9sgoOOlpJNGMuRG033+O4ohaiL
	4qYleoeDr9W21wlfcJXNoZcloG33Gh9j6nuHWc2xdsisWtNTgAbDowYkzSryZ1WSaofy+Q
	r/oVouy0s9C0HZ5vw+JLWmr0bFdbG08=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=V3XWmskO;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791347565;
	b=HZjPVOkDEYr7lfgq6XXYIux+40BPCGrWJ33DiPkWbecp6TGk4CWTBr+/SZ38G6FjcvZUwt
	41AaH6gO2kzaap4/+Jhvy2Qsqih1B2vBg09tClNJgerVz7gXLVbjfkYt6armRIr4sIwtI0
	gVYI/yzlwYdD1q4d9ULUtP3jZ6WIMSg=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a1688d7769so22248155e9.0
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 21:32:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791347564; cv=none;
        d=google.com; s=arc-20260327;
        b=RQpzzwbJlbON2Nl3QMdTpzRhruJwWgBe4i9KILd6asAAIP14BySeUF3sFCK+mj0b25
         hy7/lgB5x3vzQp+VUKa4akFhplAqGd3gZhsauu7bvSQRk4wEMvf5W5dKfqzTy4rAjUvW
         u/DBvxh8gIGWe28jshEEMmROYrzb7wMy6oU03An69N32eKUIAR61Wi/ZkQXM57TZeDEE
         sWK8r1aCZXMcaD6sEW7r4sqEQ3IZzNQXwqtnxszgzbYuxwxYGpIQyGYfPYnWTsiL52/6
         XaW0IQ7UyZVd31QQDPzq8bTrqI+viyLS0/FS/ta4ZdVZ5AqgXIzAchRGwfeQaDSV21pK
         7+FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ziYSY4OvbjG7dEn6zvCiVo/zloi2nFktnH/0C9O/jZ0=;
        fh=7hA4/DtOkRXrU+dD6PZgS5g/08x4uElnFZrA1GeomiA=;
        b=Dtrjr/z1Al6aYCocN9vt75NakHc8E8nMfpJozwevf+0Z1oqzkTQQuRZ/YoAP9PnRyP
         GwlxPwQlm6WW1DVxcc2EO5IbBU+TQVV4kaWAzbBzXONQ1aKejPfZ7jLb88rUSlP+yEDJ
         VKbMd+fpHU12Fm402g/fEBqpX93bZSQX2txI0Bq6OcB5qJNWPkqEXw+gmixZjEDf7Rku
         xCRI6WLFaoKsScqEsbUxvhmJrM9tLTwpfNNWx96xmPmboUQCwhU/GoqvfSngyt3Yav6C
         lgXsvDLDgfi7w8EtwVGHxuSACgBs/D8bKmlGVT+HCkA1NDsm4vddulWIpeVnqgppipCU
         dBrw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791347564; x=1791952364; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ziYSY4OvbjG7dEn6zvCiVo/zloi2nFktnH/0C9O/jZ0=;
        b=V3XWmskO9c7CEba8gBw4YZPJvz8Mz48RO0wKINP86AUjx1KsgEPL43gwkVY1iVUJas
         EVejpySZfP5ARf4/Kxg0oGl+POgFu0ETLJX6WaOohvHww/1HSvWHp+stM29AkCmoabSK
         bgpx9mpN/3o7/ms1kZlv6gTpkYBuIHrc12XutkuWCzySYs0byDjBZAfjcxrehrjpIHyy
         q7jBSczFdU2YpJyF5gZE5ZVfmiKLV/1sxusjYJgCktCvp7VpO8/gFk9SxHMVsQnFLfO6
         Zz+XTT7NHYyXEUsgRNo5nYpX1aFJsUZER5drimDXO6vx3Vqu1xGuFs25jg1oSq/8ymPC
         qg5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791347564; x=1791952364;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ziYSY4OvbjG7dEn6zvCiVo/zloi2nFktnH/0C9O/jZ0=;
        b=DFSCi65c2yZjS/cwI76JAxylJtghkK/BzlBCOqCmPNOkK/NqAxM3Mj6ozWf5UE1agP
         QOBJj02MbB0LmP63W1kS1PRDwMasEl6VCl/uUgRxdmmp04xKxbNFtEatGhMFvcpHJSWy
         S59nkpI6FHtNJWwZsdU4dML5DQh+DUxNVjiPXFO85JFf8c+2956W2zTBoKiUAirVYmX7
         YHxfiA5NjdGYP/LNUgIV6Ph2qbK3cbTvlP/1ccCry622iP1g8poCkJ3CxEe6P3A8PibF
         DkMv3HOJNzOZ9pMB8jNWLoo1vP56oQF9+Tk8yD6PoNNDuVcNxrjtXisfC5kCBy9aqne9
         QzBQ==
X-Gm-Message-State: AFuF++kDQ/CpGgcPCwkEPnn4hPzKkwtUqp3W3JLEz6XW2eElJgHPd73s
	KzDvU9QKSq8X5LuahKHtHiO1wIPSSg9YbzMDroxC5tJrjIdz/SguG58V0o2xKhk4XZcdGlPI0DV
	VNk6d5naA4ZdIN7Y6QvvXi147PSiWyqc=
X-Gm-Gg: AYBFou0tCQR45nuV1eAdyiePM0vRBK2i5s277kE0pTVVMhPb3xrXopcPeS6Di9XcNyx
	h3+8QcboacuZgwAxLxwxA7iwSdhBQ+NSbdk8lEw7+VwXE0Xzjfd2b9oSH4U4DW+fovqx05gP9Qs
	vG/g50dHJbjtsu+mOkNz7ZGou1azhqc6blUX0tmHpMKZqoO8MyTsCpxsaU1LdfYOt61/p+rs4aa
	BwZ3zaroXe0ZQA1E0eEZV6V8c6lV0KKrU120MMcq14pvMexPjkiVBvlHYx+vwXj8vJy68VsnZbS
	9CGW+jMpiz3nPXOZCH6YMpNP+HzwTZUTI9xRiTQpMaicPIaa5i1LhMjQ
X-Received: by 2002:a05:600c:4f10:b0:4a0:98c:e082 with SMTP id
 5b1f17b1804b1-4a18043b5aamr12107135e9.13.1791347563360; Tue, 06 Oct 2026
 21:32:43 -0700 (PDT)
MIME-Version: 1.0
References: <20261003003136.750633-1-hebaoquan@kylinos.cn> <20261003003136.750633-3-hebaoquan@kylinos.cn>
In-Reply-To: <20261003003136.750633-3-hebaoquan@kylinos.cn>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Wed, 7 Oct 2026 12:32:31 +0800
X-Gm-Features: AclHuK9rNw0KhJfEjVigVEkKU4o-iTF05f5OabqTJfPrepOKC4uycIJO-xV9Kvg
Message-ID: <CAN_Opa-Y8zuyuvRUWmmP8btKPuqBQzWQbyQGKGemhbnABWcxOA@mail.gmail.com>
Subject: Re: [PATCH v4 02/14] mm, swap: refactor free_swap_cluster_info to
 take swap_info_struct
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, nphamcs@gmail.com, baohua@kernel.org, 
	youngjun.park@lge.com, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, klarasmodin@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wj34wqnx5nubb1rc6rt8ju1849adzui9
X-Rspam-User: 
X-Rspamd-Queue-Id: 8196A180004
X-Rspamd-Server: rspam08
X-HE-Tag: 1791347565-103791
X-HE-Meta: U2FsdGVkX1/zTF1NIkVc9/4B6gWhWlj8Qejme8mR0vOGFFiKyQjnvzYWijNi2v4nhTri6KMZdUiBh/G/svHLfv3YrCh5gi5bl4UMkUq6Mz3+wMhIW7RAxOL79bj1wA1qpbdoITbBqxGrB7T0rIyRJH+KxhkXwLnPHPkfT0D2aFT8SopFVhLKwv1SdQJ2DN45ildDbBs3vyNiepca4/V6yxijGFInEsZyagr5as9/YhgR8dvfNm+wACS9r09Opfet6eawccwkR7BMCx+84R904XXXRhofQ89p7x0Hm2wkea/mQEmQEeIV8M8zBFvVfiF25V5LZLV/TfH6KU+gkxSIHeetyvHPgJ6hs/j4vXlau+i3uXlunXvVfwyj8Bq/XQody0XJ3FDftdfiBzp8qnkxUNyU2mlB79LXT9pQ6IlpV4JEXC6CtN1JugfVbmwMHSiTxVE26ffL7WCLfEyupHZ9Oi/DH8PU8pY6YqypNZMmm1vfiSgR2fWjJhl+cO9rarel7EWdO1xf/FpaF/Vz1gfSmTmTYScY5V36uQZzQ6632rK86rIeqZPF7E5lAx66ale4nLXrnx/xyEziFv6R/J0MS5By3Uv9CaQW/I0ysSIZXmBQrQiBsu4wvlFDBvw5NjrH7NoHfvijl7xDOLme2iPBu/sdUQ8X8CF8jYyS5iSdssO7pxIQBlTXMdKfONAE46hG38oUZjAEWNNkY0LcFsQqbEjZqa84ZXbSzppFygrnuY9wuonzvXTuavH77RIqF0ScCjk5ofkePjeG726ouzvsQSNfohKt7wbnHJAQkCAB7917nLWpjd2SSoSn7F2m/0XEOkNJiZVwBeThBSeY+Y/u3/xAQS5892UaK53xNOrhJ7FbIztPBY4jOY2yKR9Ik6uINRn/9ID/LvgDLPKQfAkZKNMNGfJxxxFV8Zu5lzxhkYfJOMnUaLUpftToNvh3iWUq+8yLD+d7cdFHDpqB72F
 gWDaipxt
 HnqqpMUPzY9zF87isDNQksWtEwcoXUhhgXkfQV21ibVAQe4PsCMD1MOmnuXmwpCRt3Wij1WtU0TaNb7JBCMe+4rdcYphVzqd6GpQ7a+L+ZfMK5oK0fie3glXgqq9Lm6OKOdnq8kfnOcBWcGw0xMxaVLK+YmWmPI4EPihp1i3RPlHAchl4usAe3zV3TW9d+2rZGQ9N5CT9NGYD6Xpza1q6V7QylHLpi7qEHMnVrkkqQMQMGaqtRLaHlJfAk/Oh5lANexxyss9i5lWeryc5P24SGoDwlInYb6auEkSaLTs06Ljx2AMQQsc3BYqDPa+lzdxnZuYka1jB28ZXhnt7E07sniL1ub5EPIx87VpZ9Mex23trSd/cggFhEkm0rN6pUkGw6IC7VbtPbQhwIN7CrzDHIfR0YEbnrwMzjaG0ooj7IVEkbj/qZ33S+NWsNtxbPvrV4YbmjqXoMrV2D6HJ3SBurcN6u+Az4lN8TpVNuyjTHKKB1Kzshs7TbevHNL/nQ5IfqtnMoNG5MPGnmJN39HdaTxDsKylBkN5x/phd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 8:31=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> wr=
ote:
>
> Change free_swap_cluster_info() to take struct swap_info_struct* instead
> of (cluster_info, maxpages). It now extracts the fields from si and
> clears si->cluster_info after freeing to avoid a double free on the
> swapon() error path.
>
> The new parameter also lets the xswap path access si->flags in the
> function.
>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> Reviewed-by: Chris Li <chrisl@kernel.org>
> ---
>  mm/swapfile.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 32c3133e1211..13ec5c0f3c2f 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3144,14 +3144,17 @@ static void wait_for_allocation(struct swap_info_=
struct *si)
>         }
>  }
>
> -static void free_swap_cluster_info(struct swap_cluster_info *cluster_inf=
o,
> -                                  unsigned long maxpages)
> +static void free_swap_cluster_info(struct swap_info_struct *si)
>  {
> +       struct swap_cluster_info *cluster_info =3D si->cluster_info;
> +       unsigned long maxpages =3D si->max;
>         struct swap_cluster_info *ci;
> -       int i, nr_clusters =3D DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
> +       int i, nr_clusters;
>
>         if (!cluster_info)
>                 return;
> +
> +       nr_clusters =3D DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
>         for (i =3D 0; i < nr_clusters; i++) {
>                 ci =3D cluster_info + i;
>                 /* Cluster with bad marks count will have a remaining tab=
le */
> @@ -3163,6 +3166,7 @@ static void free_swap_cluster_info(struct swap_clus=
ter_info *cluster_info,
>                 spin_unlock(&ci->lock);
>         }
>         kvfree(cluster_info);
> +       si->cluster_info =3D NULL;
>  }
>
>  /*
> @@ -3190,11 +3194,9 @@ static void flush_percpu_swap_cluster(struct swap_=
info_struct *si)
>  SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  {
>         struct swap_info_struct *p =3D NULL;
> -       struct swap_cluster_info *cluster_info;
>         struct file *swap_file, *victim;
>         struct address_space *mapping;
>         struct inode *inode;
> -       unsigned int maxpages;
>         int err, found =3D 0;
>
>         if (!capable(CAP_SYS_ADMIN))
> @@ -3286,10 +3288,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spec=
ialfile)
>
>         swap_file =3D p->swap_file;
>         p->swap_file =3D NULL;
> -       maxpages =3D p->max;
> -       cluster_info =3D p->cluster_info;
> -       p->max =3D 0;
> -       p->cluster_info =3D NULL;
>         spin_unlock(&p->lock);
>         spin_unlock(&swap_lock);
>         arch_swap_invalidate_area(p->type);
> @@ -3297,7 +3295,9 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         mutex_unlock(&swapon_mutex);
>         kfree(p->global_cluster);
>         p->global_cluster =3D NULL;
> -       free_swap_cluster_info(cluster_info, maxpages);
> +       free_swap_cluster_info(p);
> +       p->max =3D 0;
> +       p->cluster_info =3D NULL;
>
>         inode =3D mapping->host;
>
> @@ -3664,6 +3664,8 @@ static int setup_swap_clusters_info(struct swap_inf=
o_struct *si,
>         if (!cluster_info)
>                 goto err;
>
> +       si->cluster_info =3D cluster_info;
> +
>         for (i =3D 0; i < nr_clusters; i++)
>                 spin_lock_init(&cluster_info[i].lock);
>
> @@ -3727,7 +3729,7 @@ static int setup_swap_clusters_info(struct swap_inf=
o_struct *si,
>         si->cluster_info =3D cluster_info;
>         return 0;
>  err:
> -       free_swap_cluster_info(cluster_info, maxpages);
> +       free_swap_cluster_info(si);
>         return err;
>  }
>
> @@ -3949,7 +3951,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>         si->global_cluster =3D NULL;
>         inode =3D NULL;
>         destroy_swap_extents(si, swap_file);
> -       free_swap_cluster_info(si->cluster_info, si->max);
> +       free_swap_cluster_info(si);
>         si->cluster_info =3D NULL;
>         /*
>          * Clear the SWP_USED flag after all resources are freed so
> --
> 2.54.0
>

Straightforward refactor. Passing si lets the helper obtain the
cluster metadata and its size from swap_info_struct, while
clearing si->cluster_info after freeing it makes the error-path
cleanup consistent with the normal teardown path.

Reviewed-by: Kunwu Chan <chentao@kylinos.cn>

Thanks,
Kunwu

