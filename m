Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 693AEC531F7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 17:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24C086B0096; Thu, 23 Jul 2026 13:12:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222916B0098; Thu, 23 Jul 2026 13:12:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1398A6B0099; Thu, 23 Jul 2026 13:12:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C7E7C6B0096
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:12:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62FEEC05AD
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:12:06 +0000 (UTC)
X-FDA: 85020684252.27.0C71C90
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8F7B9A000C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:12:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784826724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vy3lpdlZhVoJO12cvkXIy0QiQ7yg4bA2Tl2yEbGhkSo=;
	b=jvAXOGPpOEiCGcmyS6mdou0S2LAW6m/bsePq54/bTLB12SWPmLBrMe1dpA8FGmt5jMS7CI
	lzvg0Zxib15RiParvvRg6FpqW/6RKoS7DCoSu/5K+ly2w3PdjxcVIxWiIeC4bcJJJp2ppP
	C7EJY+OilOIoGd0Vy4s8Ab4s/IudNAE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784826724;
	b=iORPagRHJyuP977GLnZKDvkRLCHhl08lXjaWp3xg5xBiO4S72zT/5PalcHBWqEjDFUNPaN
	t1mB9so9RGEM3ZC2XIuZ2rAZ7lgfLQZdjSZ0ynfm0ARB1P72K3XiR1zG/jKo/PbBe22aoL
	dQBCCqZNVQ48zVcS7Dd/U4aCuEothh8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDAF5600AD
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9890B1F00A3D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:12:03 +0000 (UTC)
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-6689402c7bfso698560d50.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:12:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoKwSic0N+P5dC1z901X6GOOu2zWeeZLuGRskVmBWt3G0f4ux5TC27QhJEA2+VP2S179xqYvTF6rg==@kvack.org
X-Gm-Message-State: AOJu0YxOm8gmhGdmVh2nQ9CmSKgKz+B0Id1azYWKmzGd5/XPguG9hbVn
	6KcaT7R9qzOSkcte0KPQ7eDlbTUkTlTxd4ZTVQs/VZnok3HMncorTlvdx6ucJnNp+fjOquyGqrl
	fd+YhyzKzFVnaRvBkovQORk47kCPwSdDusjcnInXaGQ==
X-Received: by 2002:a53:ca4c:0:b0:667:8b9c:e6c4 with SMTP id
 956f58d0204a3-668a500cae8mr796538d50.104.1784826714641; Thu, 23 Jul 2026
 10:11:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260723054622.3460249-1-hch@lst.de> <20260723054622.3460249-3-hch@lst.de>
In-Reply-To: <20260723054622.3460249-3-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 23 Jul 2026 10:11:43 -0700
X-Gmail-Original-Message-ID: <CACePvbUTUXPR6JQhBEnsOT2qwhpeyb8ycXkAaSj=DT=T+KDDtA@mail.gmail.com>
X-Gm-Features: AUfX_myqyuT5hBkyXIBFLmZ_g9vicrtyLEsDrAbfU8CZGQvWhiy3AApog2t068c
Message-ID: <CACePvbUTUXPR6JQhBEnsOT2qwhpeyb8ycXkAaSj=DT=T+KDDtA@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm/swap: add a new swap_ops.h header to allow for
 pluggable swap ops
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, usama.arif@linux.dev, 
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, ryncsn@gmail.com, trondmy@kernel.org, anna@kernel.org, 
	sfrench@samba.org, linux-mm@kvack.org, linux-cifs@vger.kernel.org, 
	linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8F7B9A000C
X-Stat-Signature: 5ae4yp4hmujhabakhrhxn6hgm1uawabe
X-HE-Tag: 1784826724-579729
X-HE-Meta: U2FsdGVkX19eUEmrKYtnP2PQ/9WgJv3/h1Q5iGErJEVXMl8EOeqTlJDCAaD0JW5Y9Qm/rZCoN07dZSZDNh4SQqZayM+wFOjfuqFKPOgp43RaDBWoLUAVrT0QBdR3SrTwm9n9L+xo4dETEtjQvfx60RR3ZFV8lULPftj8EO/IepY3Noks54BQ+Kbnch39JgSHL+4lKC5z87HuHoC0iSv4tyGwr2QtPuoYWWooBcZTYH2+JKTjpOhzwdmavp+a7bsBZPm8vZCPTzEK6dLDzU/+IQB7tzeVBtVsxW31tUxq7EZhmKMsa/EOSAgKksyPhMDsnKZx905CRHYjhzfNWx9Sv5RxF+YnL8H9mxJ2WAHaJIAQMaCZZhZwGBCXxs4uVDJkNXahN1NL3OOWfkUCM4zld3JLUk7w/Q2lsrIxAY4+7oUy1Y2ZTZCQclxQFfoCwdFCWRbNv7X3kYjxOCg1fcgVRelKl0YQatXxkuaD2IHMoBldhed3ctj/qtFj4IG3Xgu7rZPIuo25wLJW1xhGwe9AaHB6KCegDi0zYv5l+3U2t1YtYsoFsKAQ1Jz0251pNf25TvreLPywSUtR5NDrjQK/dBfoFZCkTpJR7OxCg+oxDnZs4M7jGizifHzQNtg/eHCuI/hskiiJMBrZu6Fc/cy/8DH40WWOdVfAi817EkNYsF+YBc4a9H3Bi9HRn2pT9PayQZrHJh0APS07F6CkxtILul8Alsy62NrPjDTzcyiGY3l3zoDpal8DpLvYyI/vt/anHfMkXptNU5kN3hlfvr4RRHnaT06+26qcOhAjhtpoD5SLRKp4D225+7Z0WDQGlNKDwy4BmHjGSEdyX/D8qKGGlKFKFVPwbz8GOMvuI83OmYFkk1C00dEwlIO+hoKwPobGac75zb6DJKE/XbohxJWMOeY31wl8odjlEirwSuCcMowI83XMUa6lnwo7OAsUFJ6vm53nShH4w6g/t8v3ddR
 qSCXz2kc
 876brBKzmcSGlsjmZvzcdUJjtbLhhIqp+eMM7DNITuowda0XDyOkA4c8SD0WfCwpockaVGUnKqRwuMPa8h1zpIqZoXOloYtoepsA5cRkVdFo0CsudzP68GaHoARRI/I9l3AahpIjdkoLBlLC7jhn9FMZDh9AEo3eH1RUgfBhnSvPysggL2dibHryihPdKM/Xa+QZB9D0sll3jtU8zJPZHShe0YcSORv+JkdTL7n1K3FGHG2rrFP/hxa6A+e9dmYQyaD1B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 10:47=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> Add a new header to declare the swap_iocb, swap_ops and swap_ctx to
> allow for swap_ops implementations outside of mm/page_io.c.  This
> will be used to remove the double indirection for file system-based
> swap.  There is no functional change, just a move of the declarations.
>
> Note that there already is a swapops.h header, which is totally
> unrelated to struct swap_ops.  The close naming is a bit unfortunate,
> but I could not think of a better name for this header.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  MAINTAINERS              |  1 +
>  include/linux/swap_ops.h | 39 +++++++++++++++++++++++++++++++++++++++
>  mm/madvise.c             |  1 +
>  mm/page_io.c             | 10 +---------
>  mm/shmem.c               |  1 +
>  mm/swap.h                | 23 +----------------------
>  mm/swap_state.c          |  1 +
>  mm/vmscan.c              |  1 +
>  mm/zswap.c               |  2 +-
>  9 files changed, 47 insertions(+), 32 deletions(-)
>  create mode 100644 include/linux/swap_ops.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 15dd00c7ffec..713275f62ec4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17240,6 +17240,7 @@ S:      Maintained
>  F:     Documentation/ABI/testing/sysfs-kernel-mm-swap
>  F:     Documentation/mm/swap-table.rst
>  F:     include/linux/swap.h
> +F:     include/linux/swap_ops.h
>  F:     include/linux/swapfile.h
>  F:     include/linux/swapops.h
>  F:     mm/page_io.c
> diff --git a/include/linux/swap_ops.h b/include/linux/swap_ops.h
> new file mode 100644
> index 000000000000..e92b4f532604
> --- /dev/null
> +++ b/include/linux/swap_ops.h
> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _MM_SWAP_OPS_H
> +#define _MM_SWAP_OPS_H
> +
> +#include <linux/swap.h> /* for SWAP_CLUSTER_MAX */
> +
> +struct swap_iocb {
> +       union {
> +               struct kiocb    iocb;
> +               struct bio      bio;
> +       };
> +       struct bio_vec          bvecs[SWAP_CLUSTER_MAX];
> +       int                     nr_bvecs;
> +       int                     len;
> +};
> +
> +struct swap_io_ctx {
> +       struct swap_iocb        *sio;
> +       struct swap_info_struct *sis;
> +};
> +
> +/*
> + * SWAP_OPS_F_REQUIRE_NOFS:
> + *     When set, all reclaim operations must operated as GFS_NOFS and no=
t
> + *     just GFP_NOIO, as GFP_NOIO allocations could recourse into the
> + *     file system backing this swap file.
> + */
> +#define SWAP_OPS_F_REQUIRE_NOFS                (1U << 0)
> +
> +struct swap_ops {
> +       unsigned int            flags;
> +
> +       bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
> +                       size_t prev_folio_size, int rw);
> +       void (*submit_write)(struct swap_io_ctx *ctx);
> +       void (*submit_read)(struct swap_io_ctx *ctx);
> +};
> +
> +#endif /* _MM_SWAP_OPS_H */
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 07a21ca31bad..c179938097bf 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -32,6 +32,7 @@
>  #include <linux/leafops.h>
>  #include <linux/shmem_fs.h>
>  #include <linux/mmu_notifier.h>
> +#include <linux/swap_ops.h>
>
>  #include <asm/tlb.h>
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index c984a4023a65..e741e67d6592 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -25,6 +25,7 @@
>  #include <linux/sched/task.h>
>  #include <linux/delayacct.h>
>  #include <linux/zswap.h>
> +#include <linux/swap_ops.h>
>  #include "swap.h"
>  #include "swap_table.h"
>
> @@ -300,15 +301,6 @@ static bool folio_blkg_can_merge(struct folio *folio=
, struct folio *prev_folio)
>  #define bio_associate_blkg_from_page(bio, folio)               do { } wh=
ile (0)
>  #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
>
> -struct swap_iocb {
> -       union {
> -               struct kiocb    iocb;
> -               struct bio      bio;
> -       };
> -       struct bio_vec          bvecs[SWAP_CLUSTER_MAX];
> -       int                     nr_bvecs;
> -       int                     len;
> -};
>  static mempool_t *sio_pool;
>
>  int sio_pool_init(void)
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 5071177059a9..797c42f024a0 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -41,6 +41,7 @@
>  #include <linux/swapfile.h>
>  #include <linux/iversion.h>
>  #include <linux/unicode.h>
> +#include <linux/swap_ops.h>
>  #include "swap.h"
>
>  static struct vfsmount *shm_mnt __ro_after_init;
> diff --git a/mm/swap.h b/mm/swap.h
> index abd26588abd2..19ea61c97df2 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -8,6 +8,7 @@
>  struct mempolicy;
>  struct swap_iocb;
>  struct swap_memcg_table;
> +struct swap_io_ctx;
>
>  #if defined(MAX_POSSIBLE_PHYSMEM_BITS)
>  #define SWAP_CACHE_PFN_BITS (MAX_POSSIBLE_PHYSMEM_BITS - PAGE_SHIFT)
> @@ -77,28 +78,6 @@ enum swap_cluster_flags {
>         CLUSTER_FLAG_MAX,
>  };
>
> -struct swap_io_ctx {
> -       struct swap_iocb        *sio;
> -       struct swap_info_struct *sis;
> -};
> -
> -/*
> - * SWAP_OPS_F_REQUIRE_NOFS:
> - *     When set, all reclaim operations must operated as GFS_NOFS and no=
t
> - *     just GFP_NOIO, as GFP_NOIO allocations could recourse into the
> - *     file system backing this swap file.
> - */
> -#define SWAP_OPS_F_REQUIRE_NOFS                (1U << 0)
> -
> -struct swap_ops {
> -       unsigned int            flags;
> -
> -       bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
> -                       size_t prev_folio_size, int rw);
> -       void (*submit_write)(struct swap_io_ctx *ctx);
> -       void (*submit_read)(struct swap_io_ctx *ctx);
> -};
> -
>  #ifdef CONFIG_SWAP
>  #include <linux/swapops.h> /* for swp_offset */
>  #include <linux/blk_types.h> /* for bio_end_io_t */
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 5be825911e64..b76eb3d876fd 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -23,6 +23,7 @@
>  #include <linux/huge_mm.h>
>  #include <linux/shmem_fs.h>
>  #include <linux/sysctl.h>
> +#include <linux/swap_ops.h>
>  #include "internal.h"
>  #include "swap_table.h"
>  #include "swap.h"
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 9b8ee902f972..efe24bb36ce1 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -58,6 +58,7 @@
>  #include <linux/random.h>
>  #include <linux/mmu_notifier.h>
>  #include <linux/parser.h>
> +#include <linux/swap_ops.h>
>
>  #include <asm/tlbflush.h>
>  #include <asm/div64.h>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 4e76a4a87cdc..9c4c337790fd 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -20,7 +20,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/types.h>
>  #include <linux/atomic.h>
> -#include <linux/swap.h>
> +#include <linux/swap_ops.h>
>  #include <linux/crypto.h>
>  #include <linux/scatterlist.h>
>  #include <linux/mempolicy.h>
> --
> 2.53.0
>

