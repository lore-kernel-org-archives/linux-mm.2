Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D993C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 05:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48D006B0093; Mon, 28 Sep 2026 01:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43E426B0095; Mon, 28 Sep 2026 01:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32DB36B0096; Mon, 28 Sep 2026 01:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 020A86B0093
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:27:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B2BCA0B6D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:27:05 +0000 (UTC)
X-FDA: 85262037210.21.12DF184
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 96E7240004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:27:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JWJGO6r5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790573223;
	b=Q/7SsJAPIutf+DpXf9nkwCuQgV5NBIrYLUX0LsuqYVoT7LP+bnAT9deUdzlGht7a+R8oNB
	mmT9Wd7czfu33exf9DiSKALp4mv1dWh1YLFIT0r9v3UlZyk/jRVaFZQ60CJvhACRSAMm3g
	zJz9D5duEi2hwYdQTmegUxbOXXM6ASA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JWJGO6r5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790573223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nbR4qOlYxUWlOFxZQwzq4H4GzfUZpkBGmCpDrZmQISY=;
	b=CVaALII6dIYbjlt0UPI6/cDjSGy/9owUCec3t5YsfEygYgDo38JJxSYpzcYfjhGZfwbJDU
	1Wxxg88o6j0JlA7r9VfLTK9/GhtC6wTEZPISaXXi3Ug+xvC32uipGwzPI3HkskvhPNAMr7
	IoRLjNSUw2WMF3lkuV//70OwXzCSTns=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 92C4740AD1
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773341F00898
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790573222;
	bh=nbR4qOlYxUWlOFxZQwzq4H4GzfUZpkBGmCpDrZmQISY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JWJGO6r57luVC5SxyIky0wYBVV5pFUAcywvoOlCA7HCfVlFKL85EM3O05yACtrogm
	 XJydYynPfBnUbkZs73yhwh2R6yFB2HjXxltXSICbTDK2zHFunAiKUoMrJRYg+A6Cmm
	 yf4tldxuFfjnJ80fdnKhgcuSfJTPjGNFQ7/n4DOLXxqEbsn7Bp/tL8GYVec0AegFMd
	 lpJi6l1FdcUVWHhwfngIQQnWAyyvaLw1Ivp95ZUpdvNkrOKkHi/cRCx0X4bLvI4QKD
	 94M0wDypzcNleeiSrs1S80MSOXDZXS7Chb+LiE0SlEd+LJWeB/1rYf31xOueNJH6h6
	 hE742EtfsHK3w==
Received: by mail-ed2-f33.google.com with SMTP id 4fb4d7f45d1cf-6ab0d9260baso1523459a12.0
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 22:27:02 -0700 (PDT)
X-Gm-Message-State: AFq9FYITEOHsmb75+bwjYoVU7WS8ZX9suiJ0KMeEwCrBGgMBDOSlsl3s
	MTxFF2iGpS8EeKfdTb9vVQ1QoMafSddMPtcWOKTZYgqjwHTRBpI+022l1XdxGz7EQjccwByz94h
	FidLFV7GF0mx+4fcp3dCdCHN3sFrn09U0yhnXyd6Bjw==
X-Received: by 2002:a05:6402:2755:b0:6ab:7700:9360 with SMTP id
 4fb4d7f45d1cf-6ab77009470mr3252778a12.21.1790573221307; Sun, 27 Sep 2026
 22:27:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <20260916101929.149106-9-hebaoquan@kylinos.cn>
In-Reply-To: <20260916101929.149106-9-hebaoquan@kylinos.cn>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 19:26:49 -1000
X-Gmail-Original-Message-ID: <CACePvbX1ZMu=DJ5AU2fjkOT8Y1o=peetizr1uFag17D8_9_byg@mail.gmail.com>
X-Gm-Features: AclHuK_8kcLS_r3xP2ZiQ5ZwO06a56MHUoBUWTKoqa7lnUBMRC86eB9HZgOK25E
Message-ID: <CACePvbX1ZMu=DJ5AU2fjkOT8Y1o=peetizr1uFag17D8_9_byg@mail.gmail.com>
Subject: Re: [PATCH v3 08/14] mm, swap: free backing pages in xswap_unmap_clusters
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: 9nzo5f1spjicja86q4ghcydepj7ojbch
X-Rspam-User: 
X-Rspamd-Queue-Id: 96E7240004
X-HE-Tag: 1790573223-785483
X-HE-Meta: U2FsdGVkX1826Y6ZOvs8PeKlfWz9G+f4FqkPx1EgxLyIAsoXv7othunvVnHxS2xZSNrQsYa1mKzQ40nOtN8ulAdxRQmB1MYn8CyATigUCnXyS1cZ+89y3IgtbsNRAEITsonrMWyZp5JR8XywF5s/vudGbzC9vEZbN1yqefXl0tABkjptL17iWybvp3I5ZpYRcaNx2OXHr6ogjAqF1EHDIbT8MVcUN6SmvwhGVZzvGjnDsHuRxdQuycy8my7Ke4enQO4gw4C56xMN6dCs+2ux90E3hFqCfjnJakPYUnLYWLOCEIkDLb/hgj/X9KzJ53VBcwNBraLWw/jO/6Yzz5gMI54z0ED7Cp1QH2eSzVIJNUpiySGk/kdMfm4svx5QcVLi+C2rGiRSFR49IDoI7qs8qERiNP4ACTDzu9cN0mPLjXk/VcSv3CnSSYZN48WoQwHwyd1aSieNw49SNdW6orGy3LwSzDUrqxHEe1Gck78Z9TLMfyYr7jsIhe8hTiYNZcuZzdg2yXBW+QticxRq62ZXNArrslZHSsexA5qFYEqAps+knWN6I8Kf4quHbPcEoLjZ7v/ItwuLbn/MPQzz4F4lAfzNfqeTN5/jY0KfXvgjoZixJ4G0O1GnZx+TbtDmqZqprjIbznFLPq0e0tz003DhHmksLBVhvuQ1z8kTuXV9KHZqsoqLv/ifxqkNnRtMqR3uorJy3PO1F1FOAFf92GEKfPcmsJJ2kHO9h2mllIyCve8kls3JlTmI3sjLXRfUJKHusYR0WgT0sTrBiTYS3/RVutMOoTb0LGyQ0GrcIQ56mtoB53DBJBE5TgcM6TDxc45AYOQj8wV+DpYKuFROWYG+S2KGxaJnriCunVUPn8W7E5x323ioN+mCf6asLMmqfrzt6ffB2a/6My0Tjn9iwMbG+k23klzFV85UUcxQzVXyLK4DbpC6glRdV4w6plIKUKy/hvuTsOyALVPMWhqPEGn
 fM70sDZU
 x6UgoZC+8GwDvqmu4ChQN2kziDdkhoVYTsCjmtkrWBjbtB77Q2cOV3iyvrQszAC9KJWePF0fJjqJ33eCo2djg18eHY7u5awFhJUKM6fYtxxEzONhxigT9PPuV2G7AEnVDwFNRPoYqtDQNEnU33szJgGJubMLAJP7h95ge1KSGbynV9TCRooUTBriK/VGJpNPp3gdvigg6qD2jwlQ+PpST+n2uGZcwIGkfwTYZf9p972ptlZtOaaNAnZ9DkYPE0J3gEeYh5lDYmWv6j5PiEWvwXb1vLWUb4HNdm90qnvhr8vAZ6fRyHZuHZB7m6FCfNMP12XrJ12m/TZZyvR+7TCTAdT7y1S+jDovcgKOnnUETiQCMmlRqSAZJzDaqnTzTx8J+IKF6V1yCHsYgAXO/jwTQX1xdnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 12:20=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> =
wrote:
>
> vm_area_unmap_pages() does not free the backing pages that
> xswap_map_clusters() allocated, so they leaked on every unmap.
>
> Collect the backing pages from the PTEs before unmapping and free them
> after the PTEs are cleared. The collection array is allocated under
> memalloc_noreclaim_save(); on failure, return -ENOMEM without unmapping.
>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>

Will this patch still be needed if you don't do the shrinking?

Chris

> ---
>  mm/swapfile.c | 76 +++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 65 insertions(+), 11 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 2a03b13c0ed2..5b31aacb3ec5 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -67,8 +67,8 @@
>
>  static int xswap_map_clusters(struct swap_info_struct *si,
>                               unsigned long start_idx, unsigned long nr);
> -static void xswap_unmap_clusters(struct swap_info_struct *si,
> -                                unsigned long start_idx, unsigned long n=
r);
> +static int xswap_unmap_clusters(struct swap_info_struct *si,
> +                               unsigned long start_idx, unsigned long nr=
);
>  static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
>  static void xswap_try_shrink(struct swap_info_struct *si);
>
> @@ -3343,9 +3343,14 @@ static void free_swap_cluster_info(struct swap_inf=
o_struct *si)
>                         }
>                         spin_unlock(&ci->lock);
>                 }
> -               /* Unmap all mapped clusters and free the VM_SPARSE area =
*/
> -               if (si->nr_clusters_mapped > 0)
> -                       xswap_unmap_clusters(si, 0, si->nr_clusters_mappe=
d);
> +               /*
> +                * free_vm_area() drops the mapping without freeing the p=
ages,
> +                * so the unmap has to succeed first.  Retry; its only fa=
ilure
> +                * is a transient -ENOMEM while collecting the backing pa=
ges.
> +                */
> +               while (si->nr_clusters_mapped > 0 &&
> +                      xswap_unmap_clusters(si, 0, si->nr_clusters_mapped=
))
> +                       cond_resched();
>                 free_vm_area(si->cluster_vm);
>                 si->cluster_vm =3D NULL;
>                 si->cluster_info =3D NULL;
> @@ -3988,21 +3993,44 @@ static int xswap_map_clusters(struct swap_info_st=
ruct *si,
>         return -ENOMEM;
>  }
>
> -static void xswap_unmap_clusters(struct swap_info_struct *si,
> -                                unsigned long start_idx, unsigned long n=
r)
> +struct xswap_page_data {
> +       struct page **pages;
> +       int nr;
> +       int max;
> +};
> +
> +static int xswap_collect_page(pte_t *pte, unsigned long addr, void *data=
)
> +{
> +       struct xswap_page_data *xpd =3D data;
> +       pte_t pteval =3D ptep_get(pte);
> +
> +       if (!pte_present(pteval))
> +               return 0;
> +       if (xpd->nr < xpd->max)
> +               xpd->pages[xpd->nr++] =3D pte_page(pteval);
> +       return 0;
> +}
> +
> +static int xswap_unmap_clusters(struct swap_info_struct *si,
> +                               unsigned long start_idx, unsigned long nr=
)
>  {
>         unsigned long start_addr =3D (unsigned long)si->cluster_info +
>                                    (size_t)start_idx * sizeof(struct swap=
_cluster_info);
>         unsigned long end_addr =3D start_addr + (size_t)nr * sizeof(struc=
t swap_cluster_info);
>         unsigned long vm_start =3D PAGE_ALIGN(start_addr);
>         unsigned long vm_end =3D PAGE_ALIGN(end_addr);
> +       unsigned long size;
> +       unsigned long npages;
> +       struct xswap_page_data xpd;
> +       unsigned int noreclaim_flags;
> +       int i;
>
>         mutex_lock(&si->xswap_lock);
>
>         if (vm_start >=3D vm_end) {
>                 WRITE_ONCE(si->nr_clusters_mapped, start_idx);
>                 mutex_unlock(&si->xswap_lock);
> -               return;
> +               return 0;
>         }
>
>         /*
> @@ -4014,12 +4042,32 @@ static void xswap_unmap_clusters(struct swap_info=
_struct *si,
>         flush_percpu_swap_cluster(si);
>         synchronize_rcu();
>
> +       size =3D vm_end - vm_start;
> +       npages =3D size >> PAGE_SHIFT;
> +
> +       noreclaim_flags =3D memalloc_noreclaim_save();
> +       xpd.pages =3D kmalloc_array(npages, sizeof(*xpd.pages),
> +                                 __GFP_HIGH | __GFP_NOMEMALLOC | GFP_KER=
NEL);
> +       memalloc_noreclaim_restore(noreclaim_flags);
> +       if (!xpd.pages) {
> +               mutex_unlock(&si->xswap_lock);
> +               return -ENOMEM;
> +       }
> +
> +       xpd.nr =3D 0;
> +       xpd.max =3D npages;
> +       apply_to_existing_page_range(&init_mm, vm_start, size,
> +                                    xswap_collect_page, &xpd);
> +
>         vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
> -       /* vm_area_unmap_pages() clears PTEs but does not free pages. */
> -       /* TODO: free backing pages via page table walk or tracking bitma=
p */
> +
> +       for (i =3D 0; i < xpd.nr; i++)
> +               __free_page(xpd.pages[i]);
> +       kfree(xpd.pages);
>
>         WRITE_ONCE(si->nr_clusters_mapped, start_idx);
>         mutex_unlock(&si->xswap_lock);
> +       return 0;
>  }
>
>  /* Track the end of the run of pages that is already mapped. */
> @@ -4152,7 +4200,13 @@ static int setup_swap_clusters_info(struct swap_in=
fo_struct *si,
>                 return 0;
>
>  err_unmap:
> -               xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
> +               /*
> +                * Retry until the unmap succeeds.  Its only failure is a=
 transient
> +                * -ENOMEM while collecting the backing pages.
> +                */
> +               while (si->nr_clusters_mapped > 0 &&
> +                      xswap_unmap_clusters(si, 0, si->nr_clusters_mapped=
))
> +                       cond_resched();
>  err_free_vm:
>                 free_vm_area(si->cluster_vm);
>                 si->cluster_vm =3D NULL;
> --
> 2.54.0
>

