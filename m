Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46C70CA600A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 09:10:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2BF86B008C; Thu,  8 Oct 2026 05:10:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDBA26B0092; Thu,  8 Oct 2026 05:10:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF1676B0093; Thu,  8 Oct 2026 05:10:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 748BC6B008C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 05:10:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE1EF1A043C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:10:47 +0000 (UTC)
X-FDA: 85298888934.23.8EE1935
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id EC3CFA0007
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 09:10:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qZAeL4V2;
	spf=pass (imf15.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791450645;
	b=KTo2tw5FrS8hg1HqNbPi4Gu3h/Wf1XUGmTmq9egbIvaKdGkbShWqN6tMdMeJO/kgef5tDG
	GiXcDFFqfi52adZ3LWd45NSTo3+KdIyVJMVs/sMcbjsucRWIPUN1Xhts2hlmcfO38UbjR/
	ZNMQR7JeWidFALjbHzxcoHoGAKCm5RA=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qZAeL4V2;
	spf=pass (imf15.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791450645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EVekyCoytYvsWEA/xawPaTKhkTfUsMDuQvQjTfILfOc=;
	b=TKKIwzPqwJUdpaMQSJ365uixVslo/93jETkrRJ96VAjOHvtau2JHK5XVH41AA8UW/a9hvl
	OEdnIqVkE+wHzye7hJY+EkdgwkCNr2np7bxJ/xr8CLIqvjnGOcMtwl1Eg9rbvWLedCFJas
	FEb+RoX0LHRGNLoZA0Ftn0NY1kB2EqU=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a140e7405dso50048975e9.3
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 02:10:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791450645; cv=none;
        d=google.com; s=arc-20260327;
        b=tBZ88ZM4EispK0gLocnsXiY/gCfADLKDn+k5z6J92EUOa/z/YcxKsnZPFI6SC1F09D
         w7wDbn0f4DMntDGFbtTc9MhFyiWLdMJWwLPxmQIv/P9ap7Nk+rS8rQZXvwGpxBNw2yBI
         mZQXv+ON6kTDQrPivdtI9BM3zZWYJYZH2/c5AFXyp3UMttmFN2iwnrFXbq5gMynmVDBm
         yopeTRBrUGm3FH+juKAC1+I+Ho7c47++U8ZCxMdJ0jtMRDYBVP3FTrIw1AUpDJptmOwq
         3oyQ8QbSR/QV1DpxI0yitIZFvadFM70p08xC3d2TAqCl99t4tAXIaUzR5X6ulJjdnvAE
         hhnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EVekyCoytYvsWEA/xawPaTKhkTfUsMDuQvQjTfILfOc=;
        fh=7hA4/DtOkRXrU+dD6PZgS5g/08x4uElnFZrA1GeomiA=;
        b=rt369hs74YVLidcT1xG7o33nAUb1hswJZsW399o0xEiAKS33Y94eKQKzcCsnaYgWK7
         V+ES/nhGwH5NnoxFJysKGWBr2ZmGUG+c1xSdOPb/RnWkqTnn+0AR8ylPqLV7E4jburHV
         SGb0j6TH+mnsKP8gcxpS3+grGTA66soTG012KtLyxyvxaBsEZnI6qzESsL2DLOBkPbPJ
         qimzXo+LF6ZuOV47WENeyeBWFheB2fmaJxhq4nmLaf8BqB/cu1aBKmIDB0kitJVd3Fy9
         159wBBCmJ2MZJaqcwMyBY5FzXJsJjumGjMaQtWHRMWOhLpvWSI3+y3QGeJnGSgPy0Fe1
         tpJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791450645; x=1792055445; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EVekyCoytYvsWEA/xawPaTKhkTfUsMDuQvQjTfILfOc=;
        b=qZAeL4V2CPb1eMVnkXWh9xjUIq9kpp2ZQXOL+R2w4d4VGWDWLxYGA7yzxUxFvTy0CW
         nTFLOOyl3HWdnFex1iCUHHFldwOxfiQ5/XUDJ/d2DxHGcM6nhpemgwtGwnX0HCmsH8/k
         LJcTmfKt3mdnPopFH4zTXIb3eaxE1p7Lw+wkzcxG3nbhxyghOxWaYaLb4ttVD8Bpi6et
         iwCGQ+dLvrIHgr8A6T1v1PS4Dk4rtM1peoRwj1r0WoxK5isaXTgVvUge0oYc5tyz4Z7k
         i4Wu4CpjayMKammvzGlhULTcIq6Xbhvhy6q3D8HzeKcCvGMV3uEInjOH+UbRoeXQ8O3k
         2H5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791450645; x=1792055445;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EVekyCoytYvsWEA/xawPaTKhkTfUsMDuQvQjTfILfOc=;
        b=Dm+t/icLndq7CA+QlbVLQ2T3ZbW8Egq1/tGIqC50uzAan5XePIhIBvWTH4DGsaEc0x
         HmeHdTXJnN7yEs8l6uynbK9rI+rbF0ObSc1H1eEOqS5OW3ExR9RlKEe1yKITBRq2YRz/
         H+NhxMrYoep0+v2ZBnfhzaMAAbFEk8JP2XHM3Qx4wVR3eN7UHGNBwLrVYuHlN+Jn/rnI
         ui9uUg5XIhw++VwnIscb1j37fi4+buaA+Dg0kyP3gkCd22UvSSz4HYppz5XV0Yw7n0j9
         7Nqt9DukhI3S2pgIWJBMbwMf37vFDYceDzSGbe54Xps+Tmyqc0QiLnLXpk3+k1hfcLDo
         LyEg==
X-Gm-Message-State: AFuF++mcXTVMylT5O91/zxVLHjFkEet5b0sCOsZjW8vxS7fT+ZJ+K4eQ
	EMFZM/hZmIeiwanfXpep/1pq6+FScwl5OT+x5NYkd3Z03PzfoZQOeOmy+OH1OVoXW3mWS4eC4oD
	1eJ9vVagy3p60t9i5NxUbnrolw7GwR6hc92ngPMoDMQ==
X-Gm-Gg: AYBFou3pVMWo1ELmeQDfeChfgRdum1K3SdXUOhcVw/3QSA278sNgSWBaO/a7ru2w5lf
	02/XXiVZLk1Uy6xxgfIBJtG6VkNgnU0gDxEa/G2cKEqAZaXlGObLdzuMjA5KkXvBMsnl154Lfwa
	R26YC/0EML2NKCmCbpGq/8OMcU/GY657i7g9W+hzyPLSmSXJRC0Hx/pCum2GhPT7ZDLevt+4FeK
	bCNMONonJ5JDN7ocCzxBGN8L5axgUZj28CENVYsjUTty/q2xGJcUZ6JMYTUdaNN+RSPJiZUdetC
	uyrQOOlqnwhTXy1luGHmjZ6lCcgKbyaZyVWY6JQ55WNgvgz/HMtdAqYB
X-Received: by 2002:a05:600c:8211:b0:4a1:6f78:842f with SMTP id
 5b1f17b1804b1-4a18041acfbmr82208975e9.11.1791450643778; Thu, 08 Oct 2026
 02:10:43 -0700 (PDT)
MIME-Version: 1.0
References: <20261003003136.750633-1-hebaoquan@kylinos.cn> <20261003003136.750633-9-hebaoquan@kylinos.cn>
In-Reply-To: <20261003003136.750633-9-hebaoquan@kylinos.cn>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Thu, 8 Oct 2026 17:10:32 +0800
X-Gm-Features: AclHuK8IQys48doaeIzJ4ioSb5lXI_GS92fTzf02uQErFmsCZ6PV2LE-OBf22GI
Message-ID: <CAN_Opa_JCCd-+o5y9JXbzypPtYjTGvyvnOy7KmSUKHYtVab85w@mail.gmail.com>
Subject: Re: [PATCH v4 08/14] mm, swap: defer xswap shrink to workqueue to
 avoid lock recursion
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, nphamcs@gmail.com, baohua@kernel.org, 
	youngjun.park@lge.com, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, klarasmodin@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EC3CFA0007
X-Stat-Signature: 6a6xj3cxn811i9e7e9a35gbdxgop91mb
X-HE-Tag: 1791450645-423301
X-HE-Meta: U2FsdGVkX1+Ol/zRD8dHfxUKICxoiqGfrKTGJkJgUk3q8PyC07Fqoz+wAU3mgkz0YQVjKgv71F8YrdxDpUeZu8k5WupKoThgY7rVMzVn3/XgarqlSSAj8laxoPtEDTuLKJOZCFKhKknrTReRyP+DT+MK0eCK9RYrJ/rLwsVSRoVqTCpilrHAD/eIbgtrGwY7Wajuq9+zmTM5WuQsGT7P1aryvTdo457Abrv4rPP07og2oIyJ26PWUICujCGLq4EqbTA82GQyhMg4rGdLhZwJkQtFq0GKHgNP+ebUVgQOcZCxllV2amIxnLG2h+In/pbSJrThcduSo8ALC8YkPQyWzae/g8+jYhqhcGt/i3Oja+9A4VI3IYtRYaDAAnTAwEtTXy9X6lO9yVh07+8WQ3PluXb7xMuCtFkb6noLNxMWdGBkq2ZzMg8tDs7D/ESyNn1RTRCRggfRJi82cwiAWochfed/b0+J4+DN6d9BiI4SBvh1jv/HRQbBcvwwA0Hzw4pGw0ynzykvq+DfaTZf/mluD0xCI5IvXpNEITwO771ZhfRnJgZ9E08otUleBYdX53+az8W6Pje6TxyYzLsdo0B27QWLpSolUNAFN5pMYEFd+ffCoZ6QkmlFqf537X6aK4fWAJcPnS2f3kz1g0fBZQc+AuGRfeisT56wG0h5rxZMxP+kYkvaV7LiPbptVddo+vX3Q57l0rv9dtE5XuZP3amV7lrnfpGQZjTnAdVJV2tCDXE44ZAKw9npQBqHWLfUSDL4ISgUHeNrkmJDD/vfRe56gUZYhDqQ25HKF8+XE6qMK0OS6zIOm5ewhryIpiy9vznmSRWcy8S5RbduqZyG/SiMMsbSWp4Li641XCzs7qTbu6O+m9riWIMNJkmYp7jruHQyFZIDrvDw2VYpLfA2kcEQirRoLEFW5F7SAHauHSPUpZz7QRUSHFQt/gTs05BBoMtAulIN+/F3sy7y0Cet9Vw
 AAy7xV/s
 dVLdDUwRo745dqaccHTsQL1FO7ZKqAFlJT+9Mw+kcCMWPgs+KLs7FOfwIYrEYg7z43d/BEQSdLkam3z35a/zpPWXz42uRvA1HrHighnCeTPjCBKeyzLKsQ2f1OpXUJXQg4BkyS48LXJ7onh2WPioLXKB4xO0gnlBCWGo4NWN4m81vEiVnaZST54UhqwKK8huX9Dyp8VS42gXDgEUBTRIs34UQvG1jAk1wJYr7rju8ZWdpLgOxxqF8+xRCpy3nByHLlfZepCu7sJGfH15y9bPNooEcoS2Ew7fDrwLAMe0zikOyFgFAucrEGHbeciMg9Y7lW5uTxzObkRRdjIksW7uC+GmfTAHSr5v9raTZ45Ylzg8gpkVjlpL0cETMfRJ2Yi9BpfnwelfELmmiVTz9P4ScZnEaulOBwHWSbBNb/6FFOq/8b3caqF6PGk0gzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 3, 2026 at 8:32=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> wr=
ote:
>
> __free_cluster() called xswap_try_shrink() while holding ci->lock, but
> shrinking unmaps the backing pages and the subsequent unlock faults on
> the unmapped address. Run the shrink via schedule_work() instead, so no
> cluster lock is held. The work is only scheduled for xswap devices and
> is cancelled on swapoff.
>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---
>  include/linux/swap.h |   1 +
>  mm/swapfile.c        | 129 ++++++++++++++++++++++++++++++++-----------
>  2 files changed, 97 insertions(+), 33 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 382a578140b5..12cdc00f78f9 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -246,6 +246,7 @@ struct swap_info_struct {
>         struct vm_struct        *cluster_vm;    /* VM_SPARSE area for clu=
ster_info */
>         unsigned long           nr_clusters_max;/* total clusters in the =
xswap address space */
>         unsigned long           nr_clusters_mapped; /* currently mapped c=
luster count */
> +       struct work_struct      xswap_shrink_work; /* deferred shrink tri=
gger */
>         struct mutex            xswap_lock;     /* serialize map/unmap op=
erations */
>  #endif
>         struct list_head free_clusters; /* free clusters list */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 7c062e772f5b..49703731ffd5 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -727,7 +727,9 @@ static void __free_cluster(struct swap_info_struct *s=
i, struct swap_cluster_info
>         move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
>         ci->order =3D 0;
>  #ifdef CONFIG_XSWAP
> -       xswap_try_shrink(si);
> +       /* Only xswap devices, and not while the device is being torn dow=
n. */
> +       if ((si->flags & SWP_XSWAP) && (si->flags & SWP_WRITEOK))
> +               schedule_work(&si->xswap_shrink_work);
>  #endif
>  }
>
> @@ -3334,6 +3336,7 @@ static void free_swap_cluster_info(struct swap_info=
_struct *si)
>         if (si->flags & SWP_XSWAP) {
>                 unsigned long nr_mapped;
>
> +               cancel_work_sync(&si->xswap_shrink_work);
>                 /*
>                  * Cluster 0 keeps the bad header slot, so it never empti=
es
>                  * and __free_cluster() never frees its table.
> @@ -3452,6 +3455,11 @@ SYSCALL_DEFINE1(swapoff, const char __user *, spec=
ialfile)
>         spin_unlock(&p->lock);
>         spin_unlock(&swap_lock);
>
> +#ifdef CONFIG_XSWAP
> +       if (p->flags & SWP_XSWAP)
> +               cancel_work_sync(&p->xswap_shrink_work);
> +#endif
> +
>         wait_for_allocation(p);
>
>         set_current_oom_origin();
> @@ -4074,8 +4082,9 @@ static void xswap_unmap_range(struct swap_info_stru=
ct *si,
>                 __free_page(pages[i]);
>  }
>
> -static void xswap_unmap_clusters(struct swap_info_struct *si,
> -                                unsigned long start_idx, unsigned long n=
r)
> +/* Caller must hold si->xswap_lock.  Cannot fail. */
> +static void xswap_unmap_clusters_locked(struct swap_info_struct *si,
> +                                       unsigned long start_idx, unsigned=
 long nr)
>  {
>         unsigned long start_addr =3D (unsigned long)si->cluster_info +
>                                    (size_t)start_idx * sizeof(struct swap=
_cluster_info);
> @@ -4087,11 +4096,9 @@ static void xswap_unmap_clusters(struct swap_info_=
struct *si,
>         unsigned int noreclaim_flags;
>         unsigned long npages, idx;
>
> -       mutex_lock(&si->xswap_lock);
> -
>         if (vm_start >=3D vm_end) {
>                 WRITE_ONCE(si->nr_clusters_mapped, start_idx);
> -               goto out_unlock;
> +               return;
>         }
>
>         /*
> @@ -4113,7 +4120,7 @@ static void xswap_unmap_clusters(struct swap_info_s=
truct *si,
>                 xswap_unmap_range(si, vm_start, vm_end, pages, npages);
>                 kvfree(pages);
>                 WRITE_ONCE(si->nr_clusters_mapped, start_idx);
> -               goto out_unlock;
> +               return;
>         }
>
>         /* No memory for the array: unmap in bounded batches instead. */
> @@ -4133,7 +4140,13 @@ static void xswap_unmap_clusters(struct swap_info_=
struct *si,
>         }
>
>         WRITE_ONCE(si->nr_clusters_mapped, start_idx);
> -out_unlock:
> +}
> +
> +static void xswap_unmap_clusters(struct swap_info_struct *si,
> +                                unsigned long start_idx, unsigned long n=
r)
> +{
> +       mutex_lock(&si->xswap_lock);
> +       xswap_unmap_clusters_locked(si, start_idx, nr);
>         mutex_unlock(&si->xswap_lock);
>  }
>
> @@ -4157,6 +4170,16 @@ static int xswap_mapped_end(pte_t *pte, unsigned l=
ong addr, void *data)
>  #define XSWAP_SHRINK_SLACK     XSWAP_GROW_CLUSTERS
>  #define XSWAP_SHRINK_MIN       (XSWAP_GROW_CLUSTERS * 8)
>
> +static void xswap_shrink_work_fn(struct work_struct *work)
> +{
> +       struct swap_info_struct *si =3D container_of(work,
> +                       struct swap_info_struct, xswap_shrink_work);
> +
> +       if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
> +               return;
> +       xswap_try_shrink(si);
> +}
> +
>  /*
>   * Try to shrink the cluster_info tail: unmap contiguous free clusters
>   * at the end of the mapped range.
> @@ -4164,14 +4187,20 @@ static int xswap_mapped_end(pte_t *pte, unsigned =
long addr, void *data)
>  static void xswap_try_shrink(struct swap_info_struct *si)
>  {
>         struct swap_cluster_info *ci;
> -       unsigned long nr_mapped, last, keep, idx;
> +       unsigned long nr_mapped, nr_tail, keep, nr_unmap, start_idx, i;
>
>         if (!(si->flags & SWP_XSWAP))
>                 return;
>
> +       mutex_lock(&si->xswap_lock);
> +
> +       /* A swapoff raced us and is about to walk this mapping. */
> +       if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
> +               goto out_unlock;
> +
>         nr_mapped =3D READ_ONCE(si->nr_clusters_mapped);
> -       if (nr_mapped <=3D 1) /* keep cluster 0 */
> -               return;
> +       if (nr_mapped <=3D 1)     /* keep cluster 0 */
> +               goto out_unlock;
>
>         /*
>          * Reclaim on our own, but only once the mapped range is at most
> @@ -4181,40 +4210,73 @@ static void xswap_try_shrink(struct swap_info_str=
uct *si)
>          */
>         if (swap_usage_in_pages(si) * 100 >
>             nr_mapped * SWAPFILE_CLUSTER * XSWAP_SHRINK_WHEN)
> -               return;
> +               goto out_unlock;
>
> -       /* Find the last non-free cluster from the tail */
> -       last =3D nr_mapped;
> -       while (last > 1) {
> -               idx =3D last - 1;
> -               ci =3D &si->cluster_info[idx];
> -               if (ci->count || ci->flags !=3D CLUSTER_FLAG_FREE)
> +       /*
> +        * Count the free clusters at the tail of the mapped range.  Scan=
ned,
> +        * not tracked: the count must be exact to size the unmap, and an
> +        * incremental count falls behind on out-of-order frees.
> +        */
> +       nr_tail =3D 0;
> +       while (nr_mapped - nr_tail > 1) {
> +               ci =3D &si->cluster_info[nr_mapped - nr_tail - 1];
> +               if (READ_ONCE(ci->count) ||
> +                   READ_ONCE(ci->flags) !=3D CLUSTER_FLAG_FREE)
>                         break;
> -               last =3D idx;
> +               nr_tail++;
>         }
> -
> -       if (last =3D=3D nr_mapped)
> -               return; /* nothing to shrink */
> -
> -       /* Below `last` has to stay mapped: the free ones in between are
> -        * not part of the tail, and unmapping them orphans what is above=
.
> -        */
> -       if (nr_mapped - last < XSWAP_SHRINK_SLACK + XSWAP_SHRINK_MIN)
> -               return;
> +       if (nr_tail < XSWAP_SHRINK_SLACK + XSWAP_SHRINK_MIN)
> +               goto out_unlock;
>
>         /*
>          * Stop at SHRINK_UNTIL rather than at the end of the tail, or th=
e
> -        * range comes out full enough for the grow to be woken.
> +        * range comes out full enough for the grow to be woken.  Below t=
he
> +        * tail everything stays mapped, and one chunk of tail with it.
>          */
>         keep =3D DIV_ROUND_UP(swap_usage_in_pages(si) * 100,
>                             XSWAP_SHRINK_UNTIL * SWAPFILE_CLUSTER);
> -       if (keep < last + XSWAP_SHRINK_SLACK)
> -               keep =3D last + XSWAP_SHRINK_SLACK;
> +       if (keep < nr_mapped - nr_tail + XSWAP_SHRINK_SLACK)
> +               keep =3D nr_mapped - nr_tail + XSWAP_SHRINK_SLACK;
>
>         if (nr_mapped < keep + XSWAP_SHRINK_MIN)
> -               return;
> +               goto out_unlock;
> +
> +       nr_unmap =3D rounddown(nr_mapped - keep, XSWAP_GROW_CLUSTERS);
> +       if (!nr_unmap)
> +               goto out_unlock;
> +       start_idx =3D nr_mapped - nr_unmap;
> +
> +       /*
> +        * Only shrink a run that reaches the mapped end; otherwise
> +        * truncating nr_clusters_mapped would orphan the active tail.
> +        */
> +       spin_lock(&si->lock);
> +       for (i =3D start_idx; i < nr_mapped; i++) {
> +               ci =3D &si->cluster_info[i];
> +               if (READ_ONCE(ci->flags) !=3D CLUSTER_FLAG_FREE)
> +                       break;
> +               if (!spin_trylock(&ci->lock)) {
> +                       spin_unlock(&si->lock);
> +                       goto out_unlock;
> +               }
> +               spin_unlock(&ci->lock);
> +       }
> +       if (i !=3D nr_mapped) {
> +               spin_unlock(&si->lock);
> +               goto out_unlock;
> +       }
> +
> +       for (i =3D start_idx; i < nr_mapped; i++) {
> +               ci =3D &si->cluster_info[i];
> +               list_del_init(&ci->list);
> +               WRITE_ONCE(ci->flags, CLUSTER_FLAG_NONE);
> +       }
> +       spin_unlock(&si->lock);
>
> -       xswap_unmap_clusters(si, keep, nr_mapped - keep);
> +       xswap_unmap_clusters_locked(si, start_idx, nr_unmap);
> +
> +out_unlock:
> +       mutex_unlock(&si->xswap_lock);
>  }
>  #endif /* CONFIG_XSWAP */
>
> @@ -4278,6 +4340,7 @@ static int setup_swap_clusters_info(struct swap_inf=
o_struct *si,
>                         }
>                 }
>
> +               INIT_WORK(&si->xswap_shrink_work, xswap_shrink_work_fn);
>                 return 0;
>
>  err_unmap:
> --
> 2.54.0
>

Hi Baoquan,

While following the shrink path across these patches, I wanted to
clarify the lifetime guarantee for the `cluster_info` backing pages.

P07 flushes the per-CPU swap cluster cache and calls
`synchronize_rcu()` before unmapping the tail. P09 clears
`SWP_WRITEOK` and cancels the shrink work before proceeding with
`wait_for_allocation()` and `try_to_unuse()`.

Could you clarify how the shrink path ensures that, before the tail
is unmapped, no allocation-side reader can still access the tail or
republish a stale per-CPU cache entry that points into it, and no
swapoff-side walker can still access the unmapped range?

Thanks,
Kunwu

