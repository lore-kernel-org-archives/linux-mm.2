Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1456CD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E37946B0005; Sat, 16 May 2026 14:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7DF6B0088; Sat, 16 May 2026 14:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD6656B008C; Sat, 16 May 2026 14:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BE95F6B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:27:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44F3CC17DB
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:27:20 +0000 (UTC)
X-FDA: 84774115440.02.CE3013B
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id 415231C0009
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:27:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OUlcnMtG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ipLjnPPVoAmFo9hBOVjjo0mZdXOpS4I9gXteWAq5QAU=;
	b=XQKSK6MmY4YtkLSC6MpgbsKcoaxpLuFk0laNzJga1f88nqSpd9/5LZakx1RTZxg7X6H3DV
	lD0ePEaQnpKGmsbcu1ypHOvkOjOiMG5HEUWvyq/aDqE0qxHTrwvZM2jcrHpYNbZ76JeVJE
	XqRHVY8L6X+90b+PvxKDx5XYtzArNJc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778956038; a=rsa-sha256;
	cv=pass;
	b=rvHhLfFRan34yOYb96bqKjJZjL/nd3wOH52zwZmoyoy7GEEsZaquLaoPpD7DmeYpONhkeJ
	+2D+kgV5SfpFRaCp4gB5eABg/Z9qc4y8z552rvcbLBDtY3iD1G+m5YBkvDX4J18lvibPgH
	YG1Rp2/safeQdKrRAHQp0HbTwt+F+Wg=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OUlcnMtG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-67c1e0229acso1636163a12.1
        for <linux-mm@kvack.org>; Sat, 16 May 2026 11:27:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778956037; cv=none;
        d=google.com; s=arc-20240605;
        b=L01coIGZd+WE8U+PLyBkKF96ovIX8LNB7YDDErdwMBpskMu8icVDLyW7CDw/pvYz7T
         URbtwxNRhGi+Qvi3QKWvodIKUxQNNt+qJBOWudrRT9kTaddoeQJ2mR59icGx89Bf7ofg
         YWbhSPvJR2yFjCH2m+o1le+nWZedCCwuk0+Lz84MtJ451jNQ9Nwgit8mw+bOD1UP9FDy
         kakVhtOCydK0e9iciiqhOZ6HxqZrKvZq37Yb0577l73ISKgUFh5lZkDyAFLDIL8BISM/
         QTDgq8d6YArn2/QI8YEobPEPMSZhSDiPeET6V70MmmBT923E3rXPw0gsiWeCDlMibybQ
         UeRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ipLjnPPVoAmFo9hBOVjjo0mZdXOpS4I9gXteWAq5QAU=;
        fh=hb97NItwle+n79Yf/k/1h1kO21tyxE6HVbsHWe325KA=;
        b=A9FwYEHTXP3LPTtfHt+wzs0s0GaNW9nWM5X4luHg7K4CdjnKT4/z3y7PXAcxKWilJj
         vVeb1GC2Yi5GT3o7nAqqzjTN6/67ZTjkohEl4hnCN+NrOd7FtKJFUo9ojHgJPvkWIMcZ
         oPSZmHxyxNlB+ybDB25gTDajQ/tEPpLCXc1ZxcEDyYcw/jdEEq+71d5I/xWZXYVPangL
         OQUvBv88D5uaO+JsnGD3Ijm5P4nbxvFjIRp91ZW2uNQKnlHTIhW2YIPN3KC6DaoDyirM
         EB2eMv8aBnc12Fxwo1zszzjd31G8OHApt611/lVzHmfD2SJaX7G8sP+LJp6QHG8oftjC
         5mNA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778956037; x=1779560837; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ipLjnPPVoAmFo9hBOVjjo0mZdXOpS4I9gXteWAq5QAU=;
        b=OUlcnMtGBFPjb2iGi9fMojrsa0LN7NPLCRtrgqchKQ90B8mf5p07oQF5wTPzQHGU8U
         uLRRgwGmQOZm+NCNa2cerbMZzUObHeGD0xl2jmgnoItEy/vKXIUvG7OrKVpiltKI3oSe
         iL/VCzN8nJ6laR+BSjj/4JGR2ccY/WqZeWSO4o+8p2QSDUe0ExHw+gL+mM8EzhOzfQti
         s0SXbjko9T73/OHz5dTQgospJ7tglKnARv0jDwhaOmrsdYnvaZtIE9+JD6tOeHgnNtOk
         EgLMvoQZbGmC9hmlATFevO6I2RsBbh9mw6x69uHVJKVMvZgMBvrbSNbcB2MTTc2ulXVg
         GXfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778956037; x=1779560837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ipLjnPPVoAmFo9hBOVjjo0mZdXOpS4I9gXteWAq5QAU=;
        b=dmijeukg7bzOpQtjWAqfSi5zj+/bMTpWrh6HHZKzT80eFsJk2PghsYmx32dhFzKLuv
         3VORg4VrlMadaZAPwIGIUYkNowJSx2nbBPsdtrPj9LHzpTEj1Y3dtV9VeVBSA4Xwvhxk
         aJe3+7FRL6Q85Y4TrfN+KJ2M2pV4Ny98Y/UC+xJ5kMXA1xeVTmZCTWId8wlGMVoLTHFY
         mPOVFkdnVOk+SKRA/qXhro5YDobrHjVrka07Y/Y3j1I+91ENEmiJ3qlXE4N+J+i7VnCN
         /qJs9IwD1pjd7MbOPHbAx1kBy1QqzranUF5e8yjkMXZcxT4ty/pLV7OpVSFLULC+Hgt4
         TNfA==
X-Gm-Message-State: AOJu0YxoIB8d/ChyBKYnNhyYMhxYkJPV/jPeCcvpHluvdEumzGlReUrI
	qjOJccheqEIo1zPyIys1mrkTmD0/ZbFGbWma6lGwYhOn0CAy83W7knYs6EKlNEEe4VrEdC4ZBBy
	gFCzOATl2HP4Wlp5XWehTUrbS8eVHDjk=
X-Gm-Gg: Acq92OEXd6JpFUbRiLFRkkV/XL0uX2tAxIGEEXZ458qUpLophLgcF5o5SoXY1O7mTFc
	qWXRvjNXioJqnp3NT3WfC+1XnQBnNjoe3/8iC4MvobWU2/P/I71e2qXahEjxr3KudduFwoutCVG
	rDf2Xg8Zh+vok2KlM1daNHAlhg9d3mMqVrTtlPRng8/Nv+1iL0ywGzQm9UYePxOp3HtK47DLdGw
	DljBucScqTrCM0QRBl1DajmvJEtmtFM+4s9xFnyjw/BG62k48sgMascKH0gTffwem1BAZDbwxo8
	UujGEhn3iQ7azso6e4i6uM20Q4HJCyBlOrhCQKrhUscYB8cnFAE=
X-Received: by 2002:aa7:d6cc:0:b0:672:be92:e913 with SMTP id
 4fb4d7f45d1cf-683bd589317mr3236394a12.17.1778956036340; Sat, 16 May 2026
 11:27:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260515-swap-table-p4-v4-0-f1b49e845a8d@tencent.com> <20260515-swap-table-p4-v4-5-f1b49e845a8d@tencent.com>
In-Reply-To: <20260515-swap-table-p4-v4-5-f1b49e845a8d@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sun, 17 May 2026 02:26:39 +0800
X-Gm-Features: AVHnY4LwzFo6b6lT16u0Jm5tkZjNNGtyC5TXmtlNsG_Qn3_5hxODn6Nmeys6Exk
Message-ID: <CAMgjq7AqKskE5UVivTEdPzmTa09_aapWZM7JeSshhmf-4GYbZw@mail.gmail.com>
Subject: Re: [PATCH v4 05/12] mm, swap: unify large folio allocation
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 415231C0009
X-Rspamd-Server: rspam04
X-Stat-Signature: 7gc8cb1cjnmqsnpempzru5fo5z1nzerm
X-HE-Tag: 1778956038-347776
X-HE-Meta: U2FsdGVkX1/Q8LuFDMcFUc1W4iOOv5woWdu5cboKyvyidmAQHb0EiAktaKgY8ZBqUk9iVXZLzrX9MojqcIcBbQo6f7TBmWcPUVR+whzotRvOK/XxQNyDSLIpFKfRYnvF0H65kMc9gei8KFsmgxk8Z/3vh5uerNf9rIR/4dX1yRtPmQyJDEaaDll6r3E2+znAyMdBF4ZkSwgjo51y1/FUfpU3XYLIV56wBF8W+KocThPfHTt402pIAA0jomk5WApkyBuQFXQDdQCiyTp3y56nQK1FmfG3zBc1LEWffrSi+4KLLvo4dT92uJNPwOkRBm26WSto/zx7O2GqlKpDpRhyGgCX0Q3laJ0jEOhuF0j9Hc36kPP2Xiz/+vKOPEqBxJIoMqL29M2zVd92p9wwOAtKP52fJ0k9as/lB/y6LyI1G9e8sn0l0sfWYs8CYMA79CIxPsrfM7iSQBaMq9iQ/m/01z26zMMLumGMZqehZ8AbZerR9rdGk0o/d9HjAS0EjZQ6R/CQYtzIoqtvgBm7ExnqKzmkdFC1i0B+AwAwxIdDpTSqV88rjKWSvvVBWm9nzN+MDmUTTinIaZBM/KqrPf67whVAHl2sg14+TaH18HxpUte8bBNAmRv7iHGq9xs6fMddR1mhKbjSnbb4YDKu7XBsqM13JxKbWLo8Vhx8qrf2uyxk6rcmlihewulRAvoDf8JESlfTLm5WxnM9NkN4BalYFlSg7teHArrhyAI4leWznJD6naTsltHFL1NcPXdW5uIQ7MUeStIy/Nx3YuUe2dSZNPbEBARcZL7NM/K3ZwDfpRzZ3dbhzr19kFl1FZCSijqDnKi6XiMCeisSi+nW2j9c0eKIOAv7KfDSlUdLWsOfb3h7PKf4HVf0oCcs85AxJBC9HGlJ+Yu+RCb6/uMYFk9dEzcpAwsW7zXtL8M9X1OaCU4qA9hqaxG9Wr4ZKmX0s2DQ8DyMILE8qIAMDLKrVYz
 X34Xz6gj
 ET+aDw9Bsetrb3wzx5yITrcFVbihg2sBxxbEeuJnaKyVcqOu4+NUrTRKfoE7XIIeER/D5HFuE9eqz7r11/1Nz2kWmLOMsp93WNiXt/qThdjeY06fOcMcgFCIDBCAx7MTq0YqitJi5TngZmFSrBCMvCVxlTKPftu930HeHNjbbgLHanccZjGrifkMAMkbW1fLLThtjCvdWy1Tb9YsA8VyTBK8a8QFeFO1Fz+IAidUufMvh0X6uff0R7+/h6AMwd3FWDmSxbjRRahaNwLDbOJ8cBYH3eBRO7cyAOyzd/31U3kDqmsQ5auZQ/JhpZoHSb5Tz7IuHBe/wLC02um/zVy2WMdhANGPIoypVwgYJxllaxhUwfGWjjNb4xFDHj4ZETM/bRcVeeZaZJIksy6bOStthyOq2AxsADiJRTmgsZNYxQsCkEQeL9r54fTPM/yy0i6OSitn1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 6:11=E2=80=AFPM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Now that direct large order allocation is supported in the swap cache,
> both anon and shmem can use it instead of implementing their own methods.
> This unifies the fallback and swap cache check, which also reduces the
> TOCTOU race window of swap cache state: previously, high order swapin
> required checking swap cache states first, then allocating and falling
> back separately. Now all these steps happen in the same compact loop.
>
> Order fallback and statistics are also unified, callers just need to
> check and pass the acceptable order bitmask.
>
> There is basically no behavior change. This only makes things more
> unified and prepares for later commits. Cgroup and zero map checks can
> also be moved into the compact loop, further reducing race windows and
> redundancy
>
> Acked-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/memory.c     |  77 ++++++------------------------
>  mm/shmem.c      |  95 ++++++++++---------------------------
>  mm/swap.h       |  30 ++----------
>  mm/swap_state.c | 143 ++++++++++----------------------------------------=
------
>  mm/swapfile.c   |   3 +-
>  5 files changed, 68 insertions(+), 280 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 6edb23b41bac..e3edc0c20e34 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -159,7 +159,7 @@ static unsigned long shmem_default_max_inodes(void)
>
>  static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>                         struct folio **foliop, enum sgp_type sgp, gfp_t g=
fp,
> -                       struct vm_area_struct *vma, vm_fault_t *fault_typ=
e);
> +                       struct vm_fault *vmf, vm_fault_t *fault_type);
>
>  static inline struct shmem_sb_info *SHMEM_SB(struct super_block *sb)
>  {
> @@ -2017,68 +2017,25 @@ static struct folio *shmem_alloc_and_add_folio(st=
ruct vm_fault *vmf,
>  }
>
>  static struct folio *shmem_swap_alloc_folio(struct inode *inode,
> -               struct vm_area_struct *vma, pgoff_t index,
> +               struct vm_fault *vmf, pgoff_t index,
>                 swp_entry_t entry, int order, gfp_t gfp)
>  {
> +       pgoff_t ilx;
> +       struct folio *folio;
> +       struct mempolicy *mpol;
> +       /* Always allow order 0 so swap won't fail under pressure. */
> +       unsigned long orders =3D BIT(order) | BIT(0);
>         struct shmem_inode_info *info =3D SHMEM_I(inode);
> -       struct folio *new, *swapcache;
> -       int nr_pages =3D 1 << order;
> -       gfp_t alloc_gfp =3D gfp;
> -
> -       if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
> -               if (WARN_ON_ONCE(order))
> -                       return ERR_PTR(-EINVAL);
> -       } else if (order) {
> -               /*
> -                * If uffd is active for the vma, we need per-page fault
> -                * fidelity to maintain the uffd semantics, then fallback
> -                * to swapin order-0 folio, as well as for zswap case.
> -                * Any existing sub folio in the swap cache also blocks
> -                * mTHP swapin.
> -                */
> -               if ((vma && unlikely(userfaultfd_armed(vma))) ||
> -                    !zswap_never_enabled() ||
> -                    non_swapcache_batch(entry, nr_pages) !=3D nr_pages)
> -                       goto fallback;
>
> -               alloc_gfp =3D thp_shmem_limit_gfp_mask(vma_thp_gfp_mask(v=
ma), gfp);
> -       }
> -retry:
> -       new =3D shmem_alloc_folio(alloc_gfp, order, info, index);
> -       if (!new) {
> -               new =3D ERR_PTR(-ENOMEM);
> -               goto fallback;
> -       }
> +       if ((vmf && unlikely(userfaultfd_armed(vmf->vma))) ||
> +            !zswap_never_enabled())
> +               orders =3D BIT(0);
>
> -       if (mem_cgroup_swapin_charge_folio(new, vma ? vma->vm_mm : NULL,
> -                                          alloc_gfp, entry)) {
> -               folio_put(new);
> -               new =3D ERR_PTR(-ENOMEM);
> -               goto fallback;
> -       }
> +       mpol =3D shmem_get_pgoff_policy(info, index, order, &ilx);
> +       folio =3D swapin_sync(entry, gfp, orders, vmf, mpol, ilx);
> +       mpol_cond_put(mpol);
>
> -       swapcache =3D swapin_folio(entry, new);
> -       if (swapcache !=3D new) {
> -               folio_put(new);
> -               if (!swapcache) {
> -                       /*
> -                        * The new folio is charged already, swapin can
> -                        * only fail due to another raced swapin.
> -                        */
> -                       new =3D ERR_PTR(-EEXIST);
> -                       goto fallback;
> -               }
> -       }
> -       return swapcache;
> -fallback:
> -       /* Order 0 swapin failed, nothing to fallback to, abort */
> -       if (!order)
> -               return new;
> -       entry.val +=3D index - round_down(index, nr_pages);
> -       alloc_gfp =3D gfp;
> -       nr_pages =3D 1;
> -       order =3D 0;
> -       goto retry;
> +       return folio;
>  }
>

Sashiko reported a problem on this:

When shmem_swap_alloc_folio() computes the interleave index (ilx) for
MPOL_INTERLEAVE and MPOL_WEIGHTED_INTERLEAVE NUMA policies, it passes the
original large swap entry order to shmem_get_pgoff_policy().
If the allocation falls back to smaller orders (like order-0) inside
swap_cache_alloc_folio(), will this ilx be reused for all those fallback
allocations?
Since the calculation of ilx incorporates the original order, reusing the
same interleave index for all 512 fallback pages of a 2MB swap entry might
force them all onto the exact same NUMA node. Does this defeat the intended
page-by-page interleaving policy and potentially cause memory bandwidth
bottlenecks?

=3D=3D=3D

I initialially thought this is trivial. ilx is already somewhat broken
if we are doing fallback. shmem_get_pgoff_policy() computes ilx =3D
i_ino + (index >> order). The shift makes sense of all folios are in
the same order: an unshifted ilx =3D i_ino + index would give index %
nnodes =3D=3D 0 for every folio on power-of-2 node counts for THP so
shifting by order will ensure interleave is still effective.

However, once a file is backed with mixed-order folios due to fallback
or case, the shift becomes order-dependent and the ilx mapping is no
longer monotonic. The calculated interleave is skewed already.

It deserves a separate look as that's a pre-exist seperate problem. I
think I better not change that, as it might cause confusion. The
problem can be solved (or ignored?) later as it's not critical, the
ilx is just a hint anyway. For now I'll just squash the following
change to keep the behavior identical to before (hoist the fallback to
shmem just like before):

diff --git a/mm/shmem.c b/mm/shmem.c
index e3edc0c20e34..4427661ab2ee 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2023,19 +2023,26 @@ static struct folio
*shmem_swap_alloc_folio(struct inode *inode,
  pgoff_t ilx;
  struct folio *folio;
  struct mempolicy *mpol;
- /* Always allow order 0 so swap won't fail under pressure. */
- unsigned long orders =3D BIT(order) | BIT(0);
  struct shmem_inode_info *info =3D SHMEM_I(inode);

  if ((vmf && unlikely(userfaultfd_armed(vmf->vma))) ||
       !zswap_never_enabled())
- orders =3D BIT(0);
+ order =3D 0;

+again:
  mpol =3D shmem_get_pgoff_policy(info, index, order, &ilx);
- folio =3D swapin_sync(entry, gfp, orders, vmf, mpol, ilx);
+ folio =3D swapin_sync(entry, gfp, BIT(order), vmf, mpol, ilx);
  mpol_cond_put(mpol);

- return folio;
+ if (!IS_ERR(folio))
+ return folio;
+
+ if (order) {
+ order =3D 0;
+ goto again;
+ }
+
+ return NULL;
 }

 /*
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 946ec4ae9ae1..ce4e8c39ed12 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -652,7 +652,7 @@ static struct folio
*swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
  * if needed. @entry is rounded down if @orders allow large allocation.
  *
  * Context: Caller must ensure @entry is valid and pin the swap
device with refcount.
- * Return: Returns the folio on success, NULL if failed.
+ * Return: Returns the folio on success, error code if failed.
  */
 struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long orde=
rs,
     struct vm_fault *vmf, struct mempolicy *mpol, pgoff_t ilx)
@@ -667,7 +667,7 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t
gfp, unsigned long orders,
  } while (IS_ERR(folio) && PTR_ERR(folio) =3D=3D -EEXIST);

  if (IS_ERR(folio))
- return NULL;
+ return folio;

  swap_read_folio(folio, NULL);
  return folio;

