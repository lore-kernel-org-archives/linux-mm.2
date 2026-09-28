Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D49B2C9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 01:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D13C6B0092; Sun, 27 Sep 2026 21:20:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 882BF6B0093; Sun, 27 Sep 2026 21:20:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 798BD6B0095; Sun, 27 Sep 2026 21:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 540DE6B0092
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 21:20:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F0A9401BF
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:20:21 +0000 (UTC)
X-FDA: 85261415442.08.F43BBC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id CC04A120008
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:20:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YmFDZFot;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790558419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ctA6EqR2gd6Q+NGyLup7FYkhpIGXwrlcUuBTb1lAxTs=;
	b=ryy00b4JCdray3K85E3MaPXfwB5jGLRzbn5CNTn2aMnpVbgNGH9WEmpWczIN+t5rwquTfV
	oXmlxX7/gMNFmyKUMVNch+RZ66GZVkgWcPtnFHK3yu4r+RdNx7msyvfXWpvk9zd2cP0Kyc
	20IOc6dgJpWqGSFpOEfAXCLahWuMTiY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YmFDZFot;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790558419;
	b=ESQzPjaAJTzXfTHorVYi/KVjOqQs9PtYKDriZHH/pvFSROR2OEA8k7CArFn7XfP6mfI4vT
	3clNIherohdCJsKCm08af3ywEt+eT0Agpysaa/FxsFfpvAAffV2CFg1Fenz0lbQV8Hi4ao
	T6y9hNFew6yw2sBjlCgb5CJqCYqZ/kI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F20960052
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0906F1F000FF
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790558419;
	bh=ctA6EqR2gd6Q+NGyLup7FYkhpIGXwrlcUuBTb1lAxTs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YmFDZFotF7XNmpS62mj17I6samqbBwexkZSK8bEGggAAVrQrWv9y22sn89aGdm/4R
	 tVkgsoim4BVtsydBEwrjb+QR+axOww1ZjkMjyhP48TFEhjYNWw779BEPgzL9trcYsm
	 sxZtLcjdJLXjjibSx4hSIAEXA7LE1bGJjoa+JhpobAo90OA1mfH37FFitnW1lKFwqm
	 eoNhEduAmOehM1L8u7eIJi7HkLRQJW7nZsSrELJGuRuFvUAX+PjMTnqdJJORmbQemO
	 JFNKytutmDjGetWmrSc9/Uqt9MxIqhkfTr5m8e6B3jnaS1T4M3RC0sbKxMYo1t/VfS
	 7Qc+Vs1+bw2lQ==
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2aff2c45efso171178066b.3
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 18:20:18 -0700 (PDT)
X-Gm-Message-State: AFuF++mdT1ANa/GPmgxwt4ngDzxy6z0MXiNNj5+KuR4qK9ziqLW0BMk/
	PqhyAXKtLZ5Phf9iAvu1I/IhPArJyGCd5DNBssCwhF6QtQx4sDU0Avvk5kXCQbg3nmJ8PtS36MQ
	9u3e5pza0g54Ol6Etw9/gHMrPaCMClYcjt+7KnrZ8Lg==
X-Received: by 2002:a17:906:9c82:b0:c29:49fd:c98 with SMTP id
 a640c23a62f3a-c2ac24c4c6dmr956185366b.32.1790558417910; Sun, 27 Sep 2026
 18:20:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <20260916101929.149106-4-hebaoquan@kylinos.cn>
In-Reply-To: <20260916101929.149106-4-hebaoquan@kylinos.cn>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 15:20:07 -1000
X-Gmail-Original-Message-ID: <CACePvbWFEkqMeoqhL2jufTa=iYF0wUVERy--DN=yR6iO631kng@mail.gmail.com>
X-Gm-Features: AclHuK8-xxY_6dZBLCjo-ZzmBnX6Zaephg9kFzmW7lSsXHrSGpbDTVKHB7yj5RY
Message-ID: <CACePvbWFEkqMeoqhL2jufTa=iYF0wUVERy--DN=yR6iO631kng@mail.gmail.com>
Subject: Re: [PATCH v3 03/14] mm, swap: refactor free_swap_cluster_info to
 take swap_info_struct
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CC04A120008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: gdxq3qb7z4z456ojaw5ei44dmrjj4nyq
X-HE-Tag: 1790558419-118266
X-HE-Meta: U2FsdGVkX19i6xaH9YU04QIsVYKcvtUMcv6UK92A86M/nFSoTQCssMDBsJEOewRGab1fGGB3LHBuHdLhHdk+scWjBUAwrPtsax5Oce3Iv8H24tjVE0yQBqqjuxqxs5c60CyVM1FBTXNojao7DH88yoe0Ha/k8YP/aUWRvu0DDx8fpD8rg9v5QgqkfTwmNsn4tovEW+6JyjGwyOSN0iSkmKUIOjq70LrGMD6H0oGwZTcMDlYuovJueKJhytrbQgImXnIm41ityxem319cZnMRtcge7d7aDAgmpVC+C/dYznBNqgnzNaEi7SFAWFLs1Ja4Q3JYn+AKIpaZqJAXwmcbKJn0eIfqr54abUh7mBtnzU8/zeoLBCP1I5ueVDL1S8IXAkvAhtdDaCeIUNdDwYLX5hWg/tIVs+HCU8qIYKz1gvzJMMcSeMY1l9luPnLv4dcG9DBpNlS27uZ7XetmJPscUmLNO8cY4B2EK6l8HGeIYE092iU+Wn7LNjul2eMN1yoRBoJPpMOSOemAq8OhrjtkIOHzl4o6geVpUf1eEOoJrGv1myQXYQ6d4TTIRrjvLU1MK1u7Ng10hrgQJuO694oUCIFtqyNSbROBA9Y2/XphHHbZkCfMuAwuRf/GiNsbFVuJ4ESRwhmnUmPYvfQEqwMZi91BxZpGiQPk9w+8LxXp1O1Mjx4M4XfuYx+XQUtgbh2NwurCcg7EasBPVj/BajQs8G3VrlC5OakkZngTUoCiNaP7faRQxbTncB+vsFJB5BYX0Zbd0jCHZiYWw992+UPM5jrn56Zf4YlCEyQEcFAwvmDIcIzId1Z2S04/JptsubOzsW0KPDja2lG6Fu/2wx72gGS0rGyt9NRymuUzuqW+hRIx8iXcyYwq5U+OHzET/5vSZHddozCelvDM/aklLEuCQF0yDAPxC//BRiBH5kZd5n13X/9Ybr+v6Kd11ykG87/BDd+xJ7QQUUAzQgwdzaM
 W4qjgaca
 fVOCxYeALZEmoHlBtF6Z4SKqOhMQs0YN8gCpS/UfbmPvPMykRkD2tHP2bUOy2GnZ4O8dkitZv7NTwg9kkc/Pc6AwAeqK2BHuXJlGIk2giBN2tZBiF3Aa0x+3JEBYqYOk2PpfACh4eQCm0wJuF/weZ8BHfx7DKgxKgAxUUk8brtlFwd7JuvIO73XkHWQbwdoh4Z62vSsg5uj3y8MPI9zMSnSi2R2EdDS458rfWiIihYPcwuPtVLax/PNBOuAEJdR5CJgg7ZQOa+8IzFHphCTBlpocMAL8epLb9tzPOr2NRB2XnTgqbj02q8PSxdkU2xQs/pZCqRxzLXg6Kkz4AjlVlaMlRES/k+dSybt46Bul5xAK8Zju8ime93i2iUCVO5hAVodcgAx31A8lPEfaBDRowONUTmhjOGKgQq7ERkdaWU8X62qLAPOkrZRGE7uxWErr3vzARBb8llGqFuA99RfXoXvAVbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 12:20=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> =
wrote:
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

Reviewed-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  mm/swapfile.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 13ae681acf07..4b260f9760ac 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3142,14 +3142,17 @@ static void wait_for_allocation(struct swap_info_=
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
> @@ -3161,6 +3164,7 @@ static void free_swap_cluster_info(struct swap_clus=
ter_info *cluster_info,
>                 spin_unlock(&ci->lock);
>         }
>         kvfree(cluster_info);
> +       si->cluster_info =3D NULL;
>  }
>
>  /*
> @@ -3188,11 +3192,9 @@ static void flush_percpu_swap_cluster(struct swap_=
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
> @@ -3284,10 +3286,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spec=
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
> @@ -3295,7 +3293,9 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
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
> @@ -3662,6 +3662,8 @@ static int setup_swap_clusters_info(struct swap_inf=
o_struct *si,
>         if (!cluster_info)
>                 goto err;
>
> +       si->cluster_info =3D cluster_info;
> +
>         for (i =3D 0; i < nr_clusters; i++)
>                 spin_lock_init(&cluster_info[i].lock);
>
> @@ -3725,7 +3727,7 @@ static int setup_swap_clusters_info(struct swap_inf=
o_struct *si,
>         si->cluster_info =3D cluster_info;
>         return 0;
>  err:
> -       free_swap_cluster_info(cluster_info, maxpages);
> +       free_swap_cluster_info(si);
>         return err;
>  }
>
> @@ -3947,7 +3949,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
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

