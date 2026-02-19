Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8D39E9A04C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 06:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECD0D6B0088; Thu, 19 Feb 2026 01:51:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E79636B0089; Thu, 19 Feb 2026 01:51:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7B626B008A; Thu, 19 Feb 2026 01:51:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C38656B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 01:51:36 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70A69B8C9B
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:51:36 +0000 (UTC)
X-FDA: 84460285392.04.DC41C0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A7F9E1C0010
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:51:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lAGy87ik;
	spf=pass (imf18.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771483894; a=rsa-sha256;
	cv=none;
	b=WG/8CeQVuPk8RYGEnIT3k0OFHIORoCN9vAChZct3iu5nCrr5/vwqLRpWGrvzRa1VK3rhRi
	96H7FbYqdndSLzjEezvfvoAN4C9zuWhY3J0oUpfsC6HdXgO98JLQVWpibcYTgb8J+5rmqO
	1moUG9CfAIUObfURoi3Rbuxa5cfmrto=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lAGy87ik;
	spf=pass (imf18.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771483894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8gZ9Icnx9b/KX3W9rkfiUQRSx8uQbxsn/tmkZFee6xc=;
	b=KcxPcXSd7YPndX2MgzFUGN1FUwtp91ANSEKc6pQhdxE8Def6dOHDfSRVaxqNBUX1Utw/1J
	rT9sQLUW9aNOrBL5VOuganss6SBVEzxktzR6xc8R362/3SFbSvt9FA63LLAETRudAd0AYB
	7Cx4Y3UZ/Nl0Kb2zim+rma86u+wqLks=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EB1796111A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:51:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C1FC2BC86
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771483893;
	bh=AjgAPS4LrAGQy3BXZn9eDQKjCsJDi6iNAR0BfUQdcV0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lAGy87ikZxyzqZ1hSRnJEF4NXYSKyCtQj9QponBSBSCK9SvOp/dvRrguj/BBWeeYe
	 uQFEk3SoopryAxEq+fd21nJvfNdqjDfMuKWonwRxpSXgZA7FPf2dStG+xXiDF0Fqoa
	 b9Mmz1Uc+xDoyitRKk73qkKF3SXi4sIZCDxcBQ909F7Hz9XymnME6lw0Fkfa2xDJU7
	 Tko3MyAr8uZLa2NEYUxXZwyZGNduYNfMskTVlewEITbdpaqsDuvGhTDCZXOZBBigc1
	 pEAbqG3C2ETkebyHxBbUUgaePPtp+rncBz9ZnHBupUF/EHgliN+9p/J9DNJj+IREKG
	 9vB7+CiwEcIMw==
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-64ad79dfb6eso539043d50.0
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 22:51:33 -0800 (PST)
X-Gm-Message-State: AOJu0YwW6rX9S7ok4pf+Tnpc9dbr+GAAzTokKpZERtl8mfv0ROSWx8tK
	p3MFMuI2iXHmakPXL/MfgTNS7Oiyu43Hzvy36DkztGpbQvCNtUsha17bzE0aS+Zcv31XtlGbcrb
	EakN9uSvHBQPKuGjrUFzTdmJLF3EafTE0vVqsr++uOQ==
X-Received: by 2002:a05:690e:13c3:b0:645:54a9:11b6 with SMTP id
 956f58d0204a3-64c556ade4fmr4160564d50.52.1771483892822; Wed, 18 Feb 2026
 22:51:32 -0800 (PST)
MIME-Version: 1.0
References: <20260218-swap-table-p3-v3-0-f4e34be021a7@tencent.com> <20260218-swap-table-p3-v3-4-f4e34be021a7@tencent.com>
In-Reply-To: <20260218-swap-table-p3-v3-4-f4e34be021a7@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 18 Feb 2026 22:51:21 -0800
X-Gmail-Original-Message-ID: <CACePvbWbB7oROi=HA4JoaXaZyf8i1421VzEN54uiTmOibOhsDg@mail.gmail.com>
X-Gm-Features: AZwV_QiqXU3n_478tNmhdK9upBqN5eS_0Zr317vKN3N9D_wd2nucV4P6-Mn4veg
Message-ID: <CACePvbWbB7oROi=HA4JoaXaZyf8i1421VzEN54uiTmOibOhsDg@mail.gmail.com>
Subject: Re: [PATCH v3 04/12] mm, swap: consolidate bad slots setup and make
 it more robust
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A7F9E1C0010
X-Stat-Signature: mbibnk6s15hd3r8p78fgjx1u7pxy34rw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771483894-194907
X-HE-Meta: U2FsdGVkX1+eL+YAa0cFaXrF5Im7mYWKSskCZGTnU2WfbAGA/jH3Ich5RU+hacSfbnhJc7b4JMnzrTA1nCxBnvjrpalJCDW6HWfp084njuIrb6n5a1B3zaIGHOwkolhqdtZLmE/8dpbUxNJohm4ENWmDxs0EiqxKlqNfD+1QcV0aE7b8FvvmPYmgVfcriSidIUrKek7IInFlvis+FwkGtrYtSNkm2DRiTG9XanpmHqmnf4xKKFtdkJBoAlE8B2Ifs6Xkuc7lKndeqHPCrnhPWWpaHmj7PDj7r+K088rkbtgsrzhrqcj7sBaaJxWQTlB/owdaM73oooRsHHzV3buzMshCUWGW/5yxds4kqt8MAswM6/FdQlWNteLWcldWXRrZwfLKQMtbEQz1zu6y9zjVvP+aTnrprC62lYCvBcSf16xPhzC3+fTBy1EkWVILWlXXkGb8naAg8cBXeXJ6pqMuXrQ+MSnvQO/pSR/82FLYlpylnjQw2nwuObzn+WAMoq/Y6KD1QBWFwyMEu1/wEbYIATtZeyIZXMV937BidlNvvMJL9d2AmCrKGtUNgD/iG1PeGCDD6pKu9t6v0rgxLd0fWHDIM8g2Ce5J5sElSk5yjd4QDpI7lrqOHYOINrYLzkY9LCESHw0ls7PFwX46/n7kfZpbq9FoQdWFgR3ILOkiA9RIZmDdxZexjTXFKMP4e3+8xpv/UoYUMKRxPTi8V5qzQJa/o78QUBfedwPGzk+RyJ3fPhLnX4k3925AO1tfUOnaU+yA5fmi1knDKuBMbFCp4GwR0v6hNXpm0TonAfG72F9lucCvYK0TmRr86b2r8ycIPmVL8v47yAwD80yvc6livYc06aa3DBDJQMajqC/jEYu1kn/uiZqwVaWRKJo6gXaU/DgCTynx1a23hRPM1tsqrrpgw74HWUxSfHNi6Dadp/rWheTnrhpuqsVqlAfCgCPiw0lP7sSC/6Nb7Vj73Dm
 wt23noVg
 IRjqEiNgFycZ94a5PcziJ4iGn05XS9SP5upw1BPlb22WxSkgEXHAHfc1HG3T2vqVgjP+Ex4rTnRybzjSsibY1SQLgRm6l3BndMvRUfi86BbMtrkSC3Qxw0yc3uCMdl7VxmDfKNCD9QdyFSZCwqaQL//0X2h9lJ65aDiZmE/Vzn6S9L0z8U+MZLzABesXP0EEGG1+fOKnjG8ntN1mU0HbmRAWtY8bawyXmIb59J9F1QKpxI9q1rUrWumZwAUfpDVhPMNvd5C2eX/zK5Y+waBfcUSeRRhKfBXlJlLWFboIGgKX1z7u4hYzZmtffhw6USFM8nuP/Qa78AUPAe5w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 12:06=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> In preparation for using the swap table to track bad slots directly,
> move the bad slot setup to one place, set up the swap_map mark, and
> cluster counter update together.
>
> While at it, provide more informative logs and a more robust fallback if
> any bad slot info looks incorrect.
>
> Fixes a potential issue that a malformed swap file may cause the cluster
> to be unusable upon swapon, and provides a more verbose warning on a
> malformed swap file
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  mm/swapfile.c | 68 +++++++++++++++++++++++++++++++++--------------------=
------
>  1 file changed, 38 insertions(+), 30 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index fb0d48681c48..91c1fa804185 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -743,13 +743,37 @@ static void relocate_cluster(struct swap_info_struc=
t *si,
>   * slot. The cluster will not be added to the free cluster list, and its
>   * usage counter will be increased by 1. Only used for initialization.
>   */
> -static int swap_cluster_setup_bad_slot(struct swap_cluster_info *cluster=
_info,
> -                                      unsigned long offset)
> +static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
> +                                      struct swap_cluster_info *cluster_=
info,
> +                                      unsigned int offset, bool mask)
>  {
>         unsigned long idx =3D offset / SWAPFILE_CLUSTER;
>         struct swap_table *table;
>         struct swap_cluster_info *ci;
>
> +       /* si->max may got shrunk by swap swap_activate() */
> +       if (offset >=3D si->max && !mask) {
> +               pr_debug("Ignoring bad slot %u (max: %u)\n", offset, si->=
max);
> +               return 0;
> +       }
> +       /*
> +        * Account it, skip header slot: si->pages is initiated as
> +        * si->max - 1. Also skip the masking of last cluster,
> +        * si->pages doesn't include that part.
> +        */
> +       if (offset && !mask)
> +               si->pages -=3D 1;
> +       if (!si->pages) {
> +               pr_warn("Empty swap-file\n");
> +               return -EINVAL;
> +       }
> +       /* Check for duplicated bad swap slots. */
> +       if (si->swap_map[offset]) {
> +               pr_warn("Duplicated bad slot offset %d\n", offset);
> +               return -EINVAL;
> +       }
> +
> +       si->swap_map[offset] =3D SWAP_MAP_BAD;
>         ci =3D cluster_info + idx;
>         if (!ci->table) {
>                 table =3D swap_table_alloc(GFP_KERNEL);
> @@ -3227,30 +3251,12 @@ static int setup_swap_map(struct swap_info_struct=
 *si,
>                           union swap_header *swap_header,
>                           unsigned long maxpages)
>  {
> -       unsigned long i;
>         unsigned char *swap_map;
>
>         swap_map =3D vzalloc(maxpages);
>         si->swap_map =3D swap_map;
>         if (!swap_map)
>                 return -ENOMEM;
> -
> -       swap_map[0] =3D SWAP_MAP_BAD; /* omit header page */
> -       for (i =3D 0; i < swap_header->info.nr_badpages; i++) {
> -               unsigned int page_nr =3D swap_header->info.badpages[i];
> -               if (page_nr =3D=3D 0 || page_nr > swap_header->info.last_=
page)
> -                       return -EINVAL;
> -               if (page_nr < maxpages) {
> -                       swap_map[page_nr] =3D SWAP_MAP_BAD;
> -                       si->pages--;
> -               }
> -       }
> -
> -       if (!si->pages) {
> -               pr_warn("Empty swap-file\n");
> -               return -EINVAL;
> -       }
> -
>         return 0;
>  }
>
> @@ -3281,26 +3287,28 @@ static int setup_swap_clusters_info(struct swap_i=
nfo_struct *si,
>         }
>
>         /*
> -        * Mark unusable pages as unavailable. The clusters aren't
> -        * marked free yet, so no list operations are involved yet.
> -        *
> -        * See setup_swap_map(): header page, bad pages,
> -        * and the EOF part of the last cluster.
> +        * Mark unusable pages (header page, bad pages, and the EOF part =
of
> +        * the last cluster) as unavailable. The clusters aren't marked f=
ree
> +        * yet, so no list operations are involved yet.
>          */
> -       err =3D swap_cluster_setup_bad_slot(cluster_info, 0);
> +       err =3D swap_cluster_setup_bad_slot(si, cluster_info, 0, false);
>         if (err)
>                 goto err;
>         for (i =3D 0; i < swap_header->info.nr_badpages; i++) {
>                 unsigned int page_nr =3D swap_header->info.badpages[i];
>
> -               if (page_nr >=3D maxpages)
> -                       continue;
> -               err =3D swap_cluster_setup_bad_slot(cluster_info, page_nr=
);
> +               if (!page_nr || page_nr > swap_header->info.last_page) {
> +                       pr_warn("Bad slot offset is out of border: %d (la=
st_page: %d)\n",
> +                               page_nr, swap_header->info.last_page);
> +                       err =3D -EINVAL;
> +                       goto err;
> +               }
> +               err =3D swap_cluster_setup_bad_slot(si, cluster_info, pag=
e_nr, false);
>                 if (err)
>                         goto err;
>         }
>         for (i =3D maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i+=
+) {
> -               err =3D swap_cluster_setup_bad_slot(cluster_info, i);
> +               err =3D swap_cluster_setup_bad_slot(si, cluster_info, i, =
true);
>                 if (err)
>                         goto err;
>         }
>
> --
> 2.52.0
>
>

