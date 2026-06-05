Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8F80CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53C926B0093; Fri,  5 Jun 2026 13:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EDDC6B0095; Fri,  5 Jun 2026 13:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DC1F6B0096; Fri,  5 Jun 2026 13:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3BE6B0093
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:42:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6BF5DC132D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:42:11 +0000 (UTC)
X-FDA: 84846577662.25.8405CE1
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3789418000C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:42:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T+Sw1wG8;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780681329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xvrVrAU94fNa7PZ/4W0ShPlWMeLwmItfoaFd3zwJKkA=;
	b=8mg9vrLsw0+9YCy6Y3LB3xNNzkK45NnEMHRCeytKr2NvOGrnQ3QgbTMWxO858FdeQIue4T
	E0qepUfWKc2LjJzTOQXOfZ+HbDUufpntC0g9zWM0m6B34VEqX2OkLshcA2J6om6XNKnovR
	aYKN1LgQYidhPH8Bgnvn5O7AOw5GYhg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T+Sw1wG8;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780681329;
	b=C9iZ8UoyXL+NC316sSLW35+jxWWoQWdNoEUjl+tnmCH79P6R8mDTxMrEnWHa+mBobkMn4a
	l7TuV20CfpHWRUSu5aqVwf2qkJ78QetOcECG+kubAfKXNlEqBHXnL4r2m1XmxvbwZUihHu
	2PgAH+0F2ciiysd+dfnpOkW0QZwoeP8=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490ae94a89eso19324065e9.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:42:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780681328; cv=none;
        d=google.com; s=arc-20240605;
        b=N0iDri7rS6sk3ezQklCA2XJJF9kiXjCJgG98D77PuVFw64tt5FKB2lSuSBcUjUBWya
         ggANBKSRfQdiOw6a+56zzGB9VR2S1DcfmegFNHSywcUZSQla5yFD6VMBpLTd0bISs5f6
         Thw8uRQQsVmh97gDNtL2WF2odL01nJSJlMcz+qecVX/j4DUmOSb1ndpDSWcwRK+H/g2q
         MWTiViRzTAh8W0344mUtlgV7LzYgxZdXMe8LNc/gRqpAY5BYm2Zoj1S8Z4ZFKj0/qWyZ
         uM3I6BXN7VHcuQeNZW988J01f0ARPDQmMKiq3MBud5h+V7RtXrhkU0g628oPBlVyx784
         04Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xvrVrAU94fNa7PZ/4W0ShPlWMeLwmItfoaFd3zwJKkA=;
        fh=kYwYwZTYDuorJq/ugeWFTcyzks9vnAOEfpQj87GEX+s=;
        b=DA3Di+4/UGnhIlhfcV/VZhVvUXDXLPlSFzHFcMWblBYHecHSdkMwegj5nGHMgvtXrw
         DxkuZekGwxUJb+w8RndLk/co3YmPGopCNkzj13VdMZhcb/HE+dcWLzVv68naFYHH4+mG
         B4LOUY+YsHcJs3hkpp+B/OE+graUDAS1h4FLONF8FwkGMkmdqBe0ySS/GB43PISf/a1Y
         G5Pfi4HqHsya4g1BLR+OoYAnr4U9God+vDL1L3EjGLDrDLMBdfZDzdObA9hSksi69E9L
         nx8IBINeYYeSvyM2Uqp0az7FJut+JRPY63ZAvTYCDEBg3Cqd+ZdAKiy2twSNMSWqSOm2
         3GPQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780681328; x=1781286128; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvrVrAU94fNa7PZ/4W0ShPlWMeLwmItfoaFd3zwJKkA=;
        b=T+Sw1wG8hqM9WzonjmdNNyx143znsmVu2Hzu5D9zPBTKRetAqu+VwGvX+9hb/xgV3Z
         5V1f06jx7cyEFNFoxNDwJCzdLKfzOu0/ATet0KE4H7E+QMRm6p/sYRhvTTyvLY+0T+0Q
         5o+dlkvWqjBCz1Su6xVmYuSm9h1PjwR356OYSotC6vWGU9E+4AqrxFAhpTQgdYvsprPZ
         M0IX4Ec11BhHib3C/PPNxZFNoDOL9YyVtHRM11nVoSjRi8fq6xrnW3UWsPliove8LFUX
         wgVkdMEGnjk+1xw1ubKkO8VfEsjV1KeStz90222XXSyYM7EQjYEqK4UItAin93UfCnco
         eNVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780681328; x=1781286128;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xvrVrAU94fNa7PZ/4W0ShPlWMeLwmItfoaFd3zwJKkA=;
        b=WdTso+qXIJnZ2ylX3SAkyLBUiKjh9vOdSLFFLiogaiM2IDcenkTLguuR/sY+1RTR8P
         8DkJzlamCLBPWYvdlvtWmvlnLmShU34Klbd4d3XVT8kowol/GuA/d4sHlhysag4w+FCC
         3cI5Nxkv/VQNWAZqmIrlaNRd0iFabF+x8517EkNa7QvWe2MFQQSaTZtreE5/FLhc57hW
         UjlUFYoh0KNHqor2bQ9Ix2GUWu1EC0RJoXBrdWzJdErOoC/8MzISxeuHNjbLMUy8CXpi
         TydlTREN71KZenUo0F4dwYWIML8X0lziIJh/cVEq7hc/J0iXR7gHhTUkDCGmyghCJx5x
         vVjg==
X-Forwarded-Encrypted: i=1; AFNElJ9tImgUVHWZHG2+CkDWU5IiXV2pP9BoZ3YmeBBDRT/Sk2z6urjZgzFCx2cBAjFaQaoZBd6Aa888sw==@kvack.org
X-Gm-Message-State: AOJu0Yw4lOyw9clTNvSLPUbzl0iKyhSK13US3QpOzEGRRt96hsyk8+xd
	nYU34tAI61963Vl0AkUPzXFy52pMdzCEz2HaRKThuNfI1QDF1dj9yN7y0y/Fd4GaYiZ7ho2nsHg
	UsPiZvi2e83iyXHnyEisTQKqhUUT6vyM=
X-Gm-Gg: Acq92OFTj3LuwVdZpNBKOiOl1OIYFoIr9QEZ1KNLbnQPjeE5Cjs/PAu+7Xh6W5A7Rjk
	L/o97CMMAKwpx+dcNcNSm1opxt+JXpD3z+SIv003vvFk9Hn4zDXAKtTPmyeQJQbkVJdVRlFBCn/
	e39aoVQIbFa9dCnqOyr3B5tc+dTvNB8TAfytSlFZKCf3NZ4AThXbZGUWLM+sYEeNxzb/FT825NH
	9sbuGWulVeZX4qhcqtShoUDOE5CvKqur+2wu/hyDQi2ULCXrl/xXKJ2mHCKJjwlJ1NNeRONwoLr
	pXJ51b5FpudjR28InuVfmhhVMEwDd4jpSZGoJhgFoeK0BAPgMw==
X-Received: by 2002:a05:600c:441a:b0:48e:7854:1608 with SMTP id
 5b1f17b1804b1-490c26e1b8amr52174775e9.25.1780681327353; Fri, 05 Jun 2026
 10:42:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260601113449.3464734-1-hch@lst.de> <20260601113449.3464734-4-hch@lst.de>
In-Reply-To: <20260601113449.3464734-4-hch@lst.de>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 5 Jun 2026 10:41:56 -0700
X-Gm-Features: AVVi8CfgnC3OEWCHGW_022Y9C6xQSN-hQ-RytAcTfzC4RT05rMDUbv1FuXCKTmQ
Message-ID: <CAKEwX=NBdL3zZkKBC73ii1mFLY7ce==J3bd79G_nHjGnciyEsQ@mail.gmail.com>
Subject: Re: [PATCH 3/8] mm/swap: introduce struct swap_io_ctx
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, chrisl@kernel.org, 
	usama.arif@linux.dev, kasong@tencent.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3789418000C
X-Stat-Signature: ysgm688u3ixmqz66g4h9hqe4a1sq6oia
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780681328-76775
X-HE-Meta: U2FsdGVkX1+QXKZSgT4JqeyW+vdofZVEQnIQJK+YS2CmhDsLKUKUYoFkzuEaLuzeeRQi6rE9FXEPbcXNIdR/B2MjbaK9k3SeIfM+JdD2yDo8iQWP54G/YljEn6+8U5iCVhdwTg3OJBgpPv1y0Fy0XPOVEfBlo9Pkq35Rw+/Z0TwpVAvD29U6QATrz6muamiGM1fivjIrarLaY7Oswfz073cWAT7fxmDSEYVHJ6gUj5Mpa3fDR78yvKYBwDJ9J2yqz5ezdpzAJ+fMoT4H+6cvR8x/VLhrsxF6+m08YO35a3RJqfUDAS111afdLNVjyJEbSo2RjRJgdxjQi/HqNxmQs0+797nXbRMjqy3UQmgJL5MF0tP0PRYyWzEty/PHaX7NtGwcp/HMmufevysECz8DUUBmRmd6knRPS0smFC6LDyGYbT45EK8nnsTT8IWua+7f5oJopAxLhIjjSbyq4KeUDLnBWMMrk45iKvMAuj07cjL0v0/8HcgzWmwKITu3tEo70Mp6LYEM/fVTVloGWBwT6/xDzhCQzmFtJwPNuWGUlzC9tH70gCS2RRRvpaSZmrIv6NaEzeRC/orLAzJgps6NKkdfR990qf24MK9p0LcHPiwQ9mn/TfYfRkpQmPzNtLnfZLy+3/XWTneJVjXSOZZkBI585sYcMjiz76z6P0Lwj/Wscv62XkvEiJofSVrDhix/uXBaA3MJAdg6WrE+DBAPfkrK2q/ylisqI3CA8acQk4pPIlkOHbaDxYMv5CCgFEHCXm5fexUOOdcGjEDqGyjjslFuinTfzxRjsFjN+JoMUKdr1ig1LSOZtd/eyVOHWAU65ie7XGu5XKzLoFxgRcTHrGO32X0e17bIdfafqWSAyfIlvcfuxV4UoPeZn/NExq/nuERdWyZmRSeajSQShYlYiZ0jWc7D+N6TLXULRr77xcqE2VYnZuPxB1+I4BFF3U+bBOF7n0uilYUDFSv3fLF
 uKXJEDd9
 D6lz+oljVlOLYyVJuvfGAWvGC7k0xFGdxWP0YakpxlYNr48Aoh7dJpzTUrZ5nQ7T5zA0Up25E5w2IRYJZF2kQ3tiknngYTziRd/lx0qoSQLxTDuTTZl53ulczqn+z2NXewZ6pPavJt/173G3acll8dbOZOJQOwxrDxEWnAEM5H3DxYr/mqs1CXF5MSnmuRDh+gqjBtqQj6aj3S81WtqHeWlnHJngFif2wvYuGTWxcvOxWDfyBMX0omwfmqhmOtcqKhbRjoszj7v4iFkn4XmKXCxJjfBlKxmPooi950nQspEh4fyP4V6ifL8J7uoPMeCWCEaC8NhDlhEEhquUYG5GciTl61neBm6zluSXIVwxeYkZqeaAA/hIMrYd9ubuTTS3wp2sY/P2GRfWLSz59yJ0AICuTECW61EnKD15mN5YZLswtEUftkndhB/4luD2Mm83u9HUWos/WIrFmhLaZATxfJFS4Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 4:35=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrote=
:
>
> Generalize the context currently provided by double pointers to struct
> swap_iocb to an on-stack context.  This cleans up the code and prepares
> for adding more fields and supporting batching multiple folios into a
> single bio for block-based swap as well.
>
> This new swap_io_ctx is required for all functions using it, the old
> way of allowing a NULL iocb for some callers is removed to keep the
> interface consistent.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/madvise.c    | 16 ++++++-------
>  mm/page_io.c    | 60 ++++++++++++++++++++++++++-----------------------
>  mm/shmem.c      | 13 +++++++----
>  mm/swap.h       | 36 +++++++++++++----------------
>  mm/swap_state.c | 53 +++++++++++++++++++++++++------------------
>  mm/vmscan.c     | 15 ++++++-------
>  mm/zswap.c      |  4 +++-
>  7 files changed, 106 insertions(+), 91 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index cd9bb077072c..cd84e993190a 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -188,7 +188,7 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsigned=
 long start,
>                 unsigned long end, struct mm_walk *walk)
>  {
>         struct vm_area_struct *vma =3D walk->private;
> -       struct swap_iocb *splug =3D NULL;
> +       struct swap_io_ctx ctx =3D {};
>         pte_t *ptep =3D NULL;
>         spinlock_t *ptl;
>         unsigned long addr;
> @@ -212,15 +212,15 @@ static int swapin_walk_pmd_entry(pmd_t *pmd, unsign=
ed long start,
>                 pte_unmap_unlock(ptep, ptl);
>                 ptep =3D NULL;
>
> -               folio =3D read_swap_cache_async(entry, GFP_HIGHUSER_MOVAB=
LE,
> -                                            vma, addr, &splug);
> +               folio =3D read_swap_cache_async(&ctx, entry, GFP_HIGHUSER=
_MOVABLE,
> +                                       vma, addr);
>                 if (folio)
>                         folio_put(folio);
>         }
>
>         if (ptep)
>                 pte_unmap_unlock(ptep, ptl);
> -       swap_read_unplug(splug);
> +       swap_read_submit(&ctx);
>         cond_resched();
>
>         return 0;
> @@ -238,7 +238,7 @@ static void shmem_swapin_range(struct vm_area_struct =
*vma,
>         XA_STATE(xas, &mapping->i_pages, linear_page_index(vma, start));
>         pgoff_t end_index =3D linear_page_index(vma, end) - 1;
>         struct folio *folio;
> -       struct swap_iocb *splug =3D NULL;
> +       struct swap_io_ctx ctx =3D {};
>
>         rcu_read_lock();
>         xas_for_each(&xas, folio, end_index) {
> @@ -257,15 +257,15 @@ static void shmem_swapin_range(struct vm_area_struc=
t *vma,
>                 xas_pause(&xas);
>                 rcu_read_unlock();
>
> -               folio =3D read_swap_cache_async(entry, mapping_gfp_mask(m=
apping),
> -                                            vma, addr, &splug);
> +               folio =3D read_swap_cache_async(&ctx, entry,
> +                               mapping_gfp_mask(mapping), vma, addr);
>                 if (folio)
>                         folio_put(folio);
>
>                 rcu_read_lock();
>         }
>         rcu_read_unlock();
> -       swap_read_unplug(splug);
> +       swap_read_submit(&ctx);
>  }
>  #endif         /* CONFIG_SWAP */
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index f2d8fe7fd057..0bf035dc1170 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -248,7 +248,7 @@ static void swap_zeromap_folio_clear(struct folio *fo=
lio)
>   * We may have stale swap cache pages in memory: notice
>   * them here and get rid of the unnecessary final write.
>   */
> -int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
> +int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
>  {
>         int ret =3D 0;
>
> @@ -295,7 +295,7 @@ int swap_writeout(struct folio *folio, struct swap_io=
cb **swap_plug)
>         }
>         rcu_read_unlock();
>
> -       __swap_writepage(folio, swap_plug);
> +       __swap_writepage(ctx, folio);
>         return 0;
>  out_unlock:
>         folio_unlock(folio);
> @@ -385,9 +385,9 @@ static void sio_write_complete(struct kiocb *iocb, lo=
ng ret)
>         mempool_free(sio, sio_pool);
>  }
>
> -static void swap_writepage_fs(struct folio *folio, struct swap_iocb **sw=
ap_plug)
> +static void swap_writepage_fs(struct swap_io_ctx *ctx, struct folio *fol=
io)
>  {
> -       struct swap_iocb *sio =3D swap_plug ? *swap_plug : NULL;
> +       struct swap_iocb *sio =3D ctx->sio;
>         struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
>         struct file *swap_file =3D sis->swap_file;
>         loff_t pos =3D swap_dev_pos(folio->swap);
> @@ -398,7 +398,7 @@ static void swap_writepage_fs(struct folio *folio, st=
ruct swap_iocb **swap_plug)
>         if (sio) {
>                 if (sio->iocb.ki_filp !=3D swap_file ||
>                     sio->iocb.ki_pos + sio->len !=3D pos) {
> -                       swap_write_unplug(sio);
> +                       swap_write_submit(ctx);
>                         sio =3D NULL;
>                 }
>         }
> @@ -413,12 +413,11 @@ static void swap_writepage_fs(struct folio *folio, =
struct swap_iocb **swap_plug)
>         bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(foli=
o), 0);
>         sio->len +=3D folio_size(folio);
>         sio->nr_bvecs +=3D 1;
> -       if (sio->nr_bvecs =3D=3D ARRAY_SIZE(sio->bvecs) || !swap_plug) {
> -               swap_write_unplug(sio);
> +       if (sio->nr_bvecs =3D=3D ARRAY_SIZE(sio->bvecs)) {
> +               swap_write_submit(ctx);
>                 sio =3D NULL;
>         }
> -       if (swap_plug)
> -               *swap_plug =3D sio;
> +       ctx->sio =3D sio;
>  }
>
>  static void swap_writepage_bdev_sync(struct folio *folio,
> @@ -458,7 +457,7 @@ static void swap_writepage_bdev_async(struct folio *f=
olio,
>         submit_bio(bio);
>  }
>
> -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
> +void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
>  {
>         struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
>
> @@ -469,7 +468,7 @@ void __swap_writepage(struct folio *folio, struct swa=
p_iocb **swap_plug)
>          * is safe.
>          */
>         if (data_race(sis->flags & SWP_FS_OPS))
> -               swap_writepage_fs(folio, swap_plug);
> +               swap_writepage_fs(ctx, folio);
>         /*
>          * ->flags can be updated non-atomically,
>          * but that will never affect SWP_SYNCHRONOUS_IO, so the data_rac=
e
> @@ -481,16 +480,20 @@ void __swap_writepage(struct folio *folio, struct s=
wap_iocb **swap_plug)
>                 swap_writepage_bdev_async(folio, sis);
>  }
>
> -void swap_write_unplug(struct swap_iocb *sio)
> +void swap_write_submit(struct swap_io_ctx *ctx)
>  {
> +       struct swap_iocb *sio =3D ctx->sio;
>         struct iov_iter from;
> -       struct address_space *mapping =3D sio->iocb.ki_filp->f_mapping;
>         int ret;
>
> +       if (!sio)
> +               return;
> +
>         iov_iter_bvec(&from, ITER_SOURCE, sio->bvecs, sio->nr_bvecs, sio-=
>len);
> -       ret =3D mapping->a_ops->swap_rw(&sio->iocb, &from);
> +       ret =3D sio->iocb.ki_filp->f_mapping->a_ops->swap_rw(&sio->iocb, =
&from);
>         if (ret !=3D -EIOCBQUEUED)
>                 sio_write_complete(&sio->iocb, ret);
> +       ctx->sio =3D NULL;
>  }
>
>  static void sio_read_complete(struct kiocb *iocb, long ret)
> @@ -582,18 +585,16 @@ static bool swap_read_folio_zeromap(struct folio *f=
olio)
>         return true;
>  }
>
> -static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **p=
lug)
> +static void swap_read_folio_fs(struct swap_io_ctx *ctx, struct folio *fo=
lio)
>  {
>         struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
> -       struct swap_iocb *sio =3D NULL;
> +       struct swap_iocb *sio =3D ctx->sio;
>         loff_t pos =3D swap_dev_pos(folio->swap);
>
> -       if (plug)
> -               sio =3D *plug;
>         if (sio) {
>                 if (sio->iocb.ki_filp !=3D sis->swap_file ||
>                     sio->iocb.ki_pos + sio->len !=3D pos) {
> -                       swap_read_unplug(sio);
> +                       swap_read_submit(ctx);
>                         sio =3D NULL;
>                 }
>         }
> @@ -608,12 +609,11 @@ static void swap_read_folio_fs(struct folio *folio,=
 struct swap_iocb **plug)
>         bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(foli=
o), 0);
>         sio->len +=3D folio_size(folio);
>         sio->nr_bvecs +=3D 1;
> -       if (sio->nr_bvecs =3D=3D ARRAY_SIZE(sio->bvecs) || !plug) {
> -               swap_read_unplug(sio);
> +       if (sio->nr_bvecs =3D=3D ARRAY_SIZE(sio->bvecs)) {
> +               swap_read_submit(ctx);
>                 sio =3D NULL;
>         }
> -       if (plug)
> -               *plug =3D sio;
> +       ctx->sio =3D sio;
>  }
>
>  static void swap_read_folio_bdev_sync(struct folio *folio,
> @@ -653,7 +653,7 @@ static void swap_read_folio_bdev_async(struct folio *=
folio,
>         submit_bio(bio);
>  }
>
> -void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
> +void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio)
>  {
>         struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
>         bool synchronous =3D sis->flags & SWP_SYNCHRONOUS_IO;
> @@ -688,7 +688,7 @@ void swap_read_folio(struct folio *folio, struct swap=
_iocb **plug)
>         zswap_folio_swapin(folio);
>
>         if (data_race(sis->flags & SWP_FS_OPS)) {
> -               swap_read_folio_fs(folio, plug);
> +               swap_read_folio_fs(ctx, folio);
>         } else if (synchronous) {
>                 swap_read_folio_bdev_sync(folio, sis);
>         } else {
> @@ -703,14 +703,18 @@ void swap_read_folio(struct folio *folio, struct sw=
ap_iocb **plug)
>         delayacct_swapin_end();
>  }
>
> -void __swap_read_unplug(struct swap_iocb *sio)
> +void swap_read_submit(struct swap_io_ctx *ctx)
>  {
> +       struct swap_iocb *sio =3D ctx->sio;
>         struct iov_iter from;
> -       struct address_space *mapping =3D sio->iocb.ki_filp->f_mapping;
>         int ret;
>
> +       if (!sio)
> +               return;
> +
>         iov_iter_bvec(&from, ITER_DEST, sio->bvecs, sio->nr_bvecs, sio->l=
en);
> -       ret =3D mapping->a_ops->swap_rw(&sio->iocb, &from);
> +       ret =3D sio->iocb.ki_filp->f_mapping->a_ops->swap_rw(&sio->iocb, =
&from);
>         if (ret !=3D -EIOCBQUEUED)
>                 sio_read_complete(&sio->iocb, ret);
> +       ctx->sio =3D NULL;
>  }
> diff --git a/mm/shmem.c b/mm/shmem.c
> index d10735e49b25..17eb16dbfaa9 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1584,13 +1584,13 @@ int shmem_unuse(unsigned int type)
>
>  /**
>   * shmem_writeout - Write the folio to swap
> + * @ctx: swap I/O context
>   * @folio: The folio to write
> - * @plug: swap plug
>   * @folio_list: list to put back folios on split
>   *
>   * Move the folio from the page cache to the swap cache.
>   */
> -int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> +int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
>                 struct list_head *folio_list)
>  {
>         struct address_space *mapping =3D folio->mapping;
> @@ -1702,7 +1702,7 @@ int shmem_writeout(struct folio *folio, struct swap=
_iocb **plug,
>                 shmem_delete_from_page_cache(folio, swp_to_radix_entry(fo=
lio->swap));
>
>                 BUG_ON(folio_mapped(folio));
> -               error =3D swap_writeout(folio, plug);
> +               error =3D swap_writeout(ctx, folio);
>                 if (error !=3D AOP_WRITEPAGE_ACTIVATE) {
>                         /* folio has been unlocked */
>                         return error;
> @@ -1741,7 +1741,12 @@ int shmem_writeout(struct folio *folio, struct swa=
p_iocb **plug,
>
>  int shmem_write_folio(struct folio *folio)
>  {
> -       return shmem_writeout(folio, NULL, NULL);
> +       struct swap_io_ctx ctx =3D {};
> +       int err;
> +
> +       err =3D shmem_writeout(&ctx, folio, NULL);
> +       swap_write_submit(&ctx);
> +       return err;
>  }
>  EXPORT_SYMBOL_GPL(shmem_write_folio);
>
> diff --git a/mm/swap.h b/mm/swap.h
> index 4f86ef338a60..79d66272dfd4 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -4,6 +4,7 @@
>
>  #include <linux/atomic.h> /* for atomic_long_t */
>  #include <linux/mm.h> /* for PAGE_SHIFT */
> +
>  struct mempolicy;
>  struct swap_iocb;
>  struct swap_memcg_table;
> @@ -78,6 +79,10 @@ enum swap_cluster_flags {
>         CLUSTER_FLAG_MAX,
>  };
>
> +struct swap_io_ctx {
> +       struct swap_iocb        *sio;
> +};
> +
>  #ifdef CONFIG_SWAP
>  #include <linux/swapops.h> /* for swp_offset */
>  #include <linux/blk_types.h> /* for bio_end_io_t */
> @@ -240,17 +245,11 @@ extern void __swap_cluster_free_entries(struct swap=
_info_struct *si,
>
>  /* linux/mm/page_io.c */
>  int sio_pool_init(void);
> -struct swap_iocb;
> -void swap_read_folio(struct folio *folio, struct swap_iocb **plug);
> -void __swap_read_unplug(struct swap_iocb *plug);
> -static inline void swap_read_unplug(struct swap_iocb *plug)
> -{
> -       if (unlikely(plug))
> -               __swap_read_unplug(plug);
> -}
> -void swap_write_unplug(struct swap_iocb *sio);
> -int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
> -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)=
;
> +void swap_read_folio(struct swap_io_ctx *ctx, struct folio *folio);
> +void swap_read_submit(struct swap_io_ctx *ctx);
> +void swap_write_submit(struct swap_io_ctx *ctx);
> +int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
> +void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio);
>
>  /* linux/mm/swap_state.c */
>  extern struct address_space swap_space __read_mostly;
> @@ -317,9 +316,8 @@ void __swap_cache_replace_folio(struct swap_cluster_i=
nfo *ci,
>
>  void show_swap_cache_info(void);
>  void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int=
 nr);
> -struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
> -               struct vm_area_struct *vma, unsigned long addr,
> -               struct swap_iocb **plug);
> +struct folio *read_swap_cache_async(struct swap_io_ctx *ctx, swp_entry_t=
 entry,
> +               gfp_t gfp_mask, struct vm_area_struct *vma, unsigned long=
 addr);
>  struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t flag,
>                 struct mempolicy *mpol, pgoff_t ilx);
>  struct folio *swapin_readahead(swp_entry_t entry, gfp_t flag,
> @@ -335,7 +333,6 @@ static inline unsigned int folio_swap_flags(struct fo=
lio *folio)
>  }
>
>  #else /* CONFIG_SWAP */
> -struct swap_iocb;
>  static inline struct swap_cluster_info *swap_cluster_lock(
>         struct swap_info_struct *si, pgoff_t offset, bool irq)
>  {
> @@ -381,11 +378,11 @@ static inline void folio_put_swap(struct folio *fol=
io, struct page *page)
>  {
>  }
>
> -static inline void swap_read_folio(struct folio *folio, struct swap_iocb=
 **plug)
> +static inline void swap_read_folio(struct swap_io_ctx *ctx, struct folio=
 *folio)
>  {
>  }
>
> -static inline void swap_write_unplug(struct swap_iocb *sio)
> +static inline void swap_write_submit(struct swap_io_ctx *ctx)
>  {
>  }
>
> @@ -427,8 +424,7 @@ static inline void swap_update_readahead(struct folio=
 *folio,
>  {
>  }
>
> -static inline int swap_writeout(struct folio *folio,
> -               struct swap_iocb **swap_plug)
> +static inline int swap_writeout(struct swap_io_ctx *ctx, struct folio *f=
olio)
>  {
>         return 0;
>  }
> @@ -474,7 +470,7 @@ static inline unsigned int folio_swap_flags(struct fo=
lio *folio)
>
>  #endif /* CONFIG_SWAP */
>
> -int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> +int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
>                 struct list_head *folio_list);
>
>  #endif /* _MM_SWAP_H */
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 04f5ce992401..b9613026950e 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -623,9 +623,9 @@ void swap_update_readahead(struct folio *folio, struc=
t vm_area_struct *vma,
>         }
>  }
>
> -static struct folio *swap_cache_read_folio(swp_entry_t entry, gfp_t gfp,
> -                                          struct mempolicy *mpol, pgoff_=
t ilx,
> -                                          struct swap_iocb **plug, bool =
readahead)
> +static struct folio *swap_cache_read_folio(struct swap_io_ctx *ctx,
> +               swp_entry_t entry, gfp_t gfp, struct mempolicy *mpol,
> +               pgoff_t ilx, bool readahead)
>  {
>         struct folio *folio;
>
> @@ -639,7 +639,7 @@ static struct folio *swap_cache_read_folio(swp_entry_=
t entry, gfp_t gfp,
>         if (IS_ERR_OR_NULL(folio))
>                 return NULL;
>
> -       swap_read_folio(folio, plug);
> +       swap_read_folio(ctx, folio);
>         if (readahead) {
>                 folio_set_readahead(folio);
>                 count_vm_event(SWAP_RA);
> @@ -667,6 +667,7 @@ static struct folio *swap_cache_read_folio(swp_entry_=
t entry, gfp_t gfp,
>  struct folio *swapin_sync(swp_entry_t entry, gfp_t gfp, unsigned long or=
ders,
>                            struct vm_fault *vmf, struct mempolicy *mpol, =
pgoff_t ilx)
>  {
> +       struct swap_io_ctx ctx =3D {};
>         struct folio *folio;
>
>         do {
> @@ -679,7 +680,8 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gf=
p, unsigned long orders,
>         if (IS_ERR(folio))
>                 return folio;
>
> -       swap_read_folio(folio, NULL);
> +       swap_read_folio(&ctx, folio);
> +       swap_read_submit(&ctx);
>         return folio;
>  }
>
> @@ -689,9 +691,8 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t gf=
p, unsigned long orders,
>   * A failure return means that either the page allocation failed or that
>   * the swap entry is no longer in use.
>   */
> -struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
> -               struct vm_area_struct *vma, unsigned long addr,
> -               struct swap_iocb **plug)
> +struct folio *read_swap_cache_async(struct swap_io_ctx *ctx, swp_entry_t=
 entry,
> +               gfp_t gfp_mask, struct vm_area_struct *vma, unsigned long=
 addr)
>  {
>         struct swap_info_struct *si;
>         struct mempolicy *mpol;
> @@ -703,13 +704,24 @@ struct folio *read_swap_cache_async(swp_entry_t ent=
ry, gfp_t gfp_mask,
>                 return NULL;
>
>         mpol =3D get_vma_policy(vma, addr, 0, &ilx);
> -       folio =3D swap_cache_read_folio(entry, gfp_mask, mpol, ilx, plug,=
 false);
> +       folio =3D swap_cache_read_folio(ctx, entry, gfp_mask, mpol, ilx, =
false);
>         mpol_cond_put(mpol);
>
>         put_swap_device(si);
>         return folio;
>  }
>
> +static struct folio *swap_cache_read_folio_sync(swp_entry_t entry, gfp_t=
 gfp,
> +               struct mempolicy *mpol, pgoff_t ilx)
> +{
> +       struct swap_io_ctx ctx =3D {};
> +       struct folio *folio;
> +
> +       folio =3D swap_cache_read_folio(&ctx, entry, gfp, mpol, ilx, fals=
e);
> +       swap_read_submit(&ctx);
> +       return folio;
> +}
> +
>  static unsigned int __swapin_nr_pages(unsigned long prev_offset,
>                                       unsigned long offset,
>                                       int hits,
> @@ -798,8 +810,8 @@ struct folio *swap_cluster_readahead(swp_entry_t entr=
y, gfp_t gfp_mask,
>         unsigned long start_offset, end_offset;
>         unsigned long mask;
>         struct swap_info_struct *si =3D __swap_entry_to_info(entry);
> +       struct swap_io_ctx ctx =3D {};
>         struct blk_plug plug;
> -       struct swap_iocb *splug =3D NULL;
>         swp_entry_t ra_entry;
>
>         mask =3D swapin_nr_pages(offset) - 1;
> @@ -818,18 +830,17 @@ struct folio *swap_cluster_readahead(swp_entry_t en=
try, gfp_t gfp_mask,
>         for (offset =3D start_offset; offset <=3D end_offset ; offset++) =
{
>                 /* Ok, do the async read-ahead now */
>                 ra_entry =3D swp_entry(swp_type(entry), offset);
> -               folio =3D swap_cache_read_folio(ra_entry, gfp_mask, mpol,=
 ilx,
> -                                             &splug, offset !=3D entry_o=
ffset);
> +               folio =3D swap_cache_read_folio(&ctx, ra_entry, gfp_mask,=
 mpol,
> +                               ilx, offset !=3D entry_offset);
>                 if (!folio)
>                         continue;
>                 folio_put(folio);
>         }
>         blk_finish_plug(&plug);
> -       swap_read_unplug(splug);
> +       swap_read_submit(&ctx);
>         lru_add_drain();        /* Push any new pages onto the LRU now */
>  skip:
> -       /* The page was likely read above, so no need for plugging here *=
/
> -       return swap_cache_read_folio(entry, gfp_mask, mpol, ilx, NULL, fa=
lse);
> +       return swap_cache_read_folio_sync(entry, gfp_mask, mpol, ilx);
>  }
>
>  static int swap_vma_ra_win(struct vm_fault *vmf, unsigned long *start,
> @@ -889,8 +900,8 @@ static int swap_vma_ra_win(struct vm_fault *vmf, unsi=
gned long *start,
>  static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gf=
p_mask,
>                 struct mempolicy *mpol, pgoff_t targ_ilx, struct vm_fault=
 *vmf)
>  {
> +       struct swap_io_ctx ctx =3D {};
>         struct blk_plug plug;
> -       struct swap_iocb *splug =3D NULL;
>         struct folio *folio;
>         pte_t *pte =3D NULL, pentry;
>         int win;
> @@ -929,8 +940,8 @@ static struct folio *swap_vma_readahead(swp_entry_t t=
arg_entry, gfp_t gfp_mask,
>                         if (!si)
>                                 continue;
>                 }
> -               folio =3D swap_cache_read_folio(entry, gfp_mask, mpol, il=
x,
> -                                             &splug, addr !=3D vmf->addr=
ess);
> +               folio =3D swap_cache_read_folio(&ctx, entry, gfp_mask, mp=
ol, ilx,
> +                                             addr !=3D vmf->address);
>                 if (si)
>                         put_swap_device(si);
>                 if (!folio)
> @@ -940,13 +951,11 @@ static struct folio *swap_vma_readahead(swp_entry_t=
 targ_entry, gfp_t gfp_mask,
>         if (pte)
>                 pte_unmap(pte);
>         blk_finish_plug(&plug);
> -       swap_read_unplug(splug);
> +       swap_read_submit(&ctx);
>         lru_add_drain();
>  skip:
>         /* The folio was likely read above, so no need for plugging here =
*/
> -       folio =3D swap_cache_read_folio(targ_entry, gfp_mask, mpol, targ_=
ilx,
> -                                     NULL, false);
> -       return folio;
> +       return swap_cache_read_folio_sync(targ_entry, gfp_mask, mpol, tar=
g_ilx);
>  }
>
>  /**
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d7303eea1265..c43177a8e4dd 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -615,8 +615,8 @@ typedef enum {
>  /*
>   * pageout is called by shrink_folio_list() for each dirty folio.
>   */
> -static pageout_t pageout(struct folio *folio, struct address_space *mapp=
ing,
> -                        struct swap_iocb **plug, struct list_head *folio=
_list)
> +static pageout_t pageout(struct swap_io_ctx *ctx, struct address_space *=
mapping,
> +               struct folio *folio, struct list_head *folio_list)
>  {
>         int res;
>
> @@ -652,9 +652,9 @@ static pageout_t pageout(struct folio *folio, struct =
address_space *mapping,
>          * the split out folios get added back to folio_list.
>          */
>         if (shmem_mapping(mapping))
> -               res =3D shmem_writeout(folio, plug, folio_list);
> +               res =3D shmem_writeout(ctx, folio, folio_list);
>         else
> -               res =3D swap_writeout(folio, plug);
> +               res =3D swap_writeout(ctx, folio);
>
>         if (res < 0)
>                 handle_write_error(mapping, folio, res);
> @@ -1063,7 +1063,7 @@ static unsigned int shrink_folio_list(struct list_h=
ead *folio_list,
>         unsigned int nr_reclaimed =3D 0, nr_demoted =3D 0;
>         unsigned int pgactivate =3D 0;
>         bool do_demote_pass;
> -       struct swap_iocb *plug =3D NULL;
> +       struct swap_io_ctx ctx =3D {};
>
>         folio_batch_init(&free_folios);
>         memset(stat, 0, sizeof(*stat));
> @@ -1394,7 +1394,7 @@ static unsigned int shrink_folio_list(struct list_h=
ead *folio_list,
>                          * starts and then write it out here.
>                          */
>                         try_to_unmap_flush_dirty();
> -                       switch (pageout(folio, mapping, &plug, folio_list=
)) {
> +                       switch (pageout(&ctx, mapping, folio, folio_list)=
) {
>                         case PAGE_KEEP:
>                                 goto keep_locked;
>                         case PAGE_ACTIVATE:
> @@ -1584,8 +1584,7 @@ static unsigned int shrink_folio_list(struct list_h=
ead *folio_list,
>         list_splice(&ret_folios, folio_list);
>         count_vm_events(PGACTIVATE, pgactivate);
>
> -       if (plug)
> -               swap_write_unplug(plug);
> +       swap_write_submit(&ctx);
>         return nr_reclaimed;
>  }
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 761cd699e0a3..feed2557f6ed 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -992,6 +992,7 @@ static int zswap_writeback_entry(struct zswap_entry *=
entry,
>         struct folio *folio;
>         struct mempolicy *mpol;
>         struct swap_info_struct *si;
> +       struct swap_io_ctx ctx =3D {};
>         int ret =3D 0;
>
>         /* try to allocate swap cache folio */
> @@ -1049,7 +1050,8 @@ static int zswap_writeback_entry(struct zswap_entry=
 *entry,
>         folio_set_reclaim(folio);
>
>         /* start writeback */
> -       __swap_writepage(folio, NULL);
> +       __swap_writepage(&ctx, folio);
> +       swap_write_submit(&ctx);

LGTM.
Reviewed-by: Nhat Pham <nphamcs@gmail.com>

Note to self and other zswap folks: explore batching IO for zswap
writeback.  Should be fairly simple to maintain swap_io_ctx for each
writeback round and pass it around. Not sure how much physical swap
address space contiguity these zswap entries still have at the point
of zswap writeback, as zswap-ins might have already punched holes. But
can't be worse than status quo, and soon we will able to defer the
allocation of physical swap space until writeback time with swap
virtualization, which will make batching more attractive here :)

