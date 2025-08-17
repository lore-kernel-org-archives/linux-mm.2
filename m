Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1274CA0EE4
	for <linux-mm@archiver.kernel.org>; Sun, 17 Aug 2025 08:37:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6162A8E003C; Sun, 17 Aug 2025 04:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C70C8E0035; Sun, 17 Aug 2025 04:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 503DC8E003C; Sun, 17 Aug 2025 04:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2298E0035
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 04:37:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECF1759B6E
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 08:37:29 +0000 (UTC)
X-FDA: 83785595418.08.8F095FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1DFDA120015
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 08:37:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j7UUlK8f;
	spf=pass (imf29.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755419848; a=rsa-sha256;
	cv=none;
	b=dxiGnDJ94pHRN6NzDerza+Eb3sMpkuRbjfPq6RfSSTTWNvKV2At3+qjPokZB1phMGsR7Vt
	LClHjUoYpkxvF9j3PA8uQj8jQtIFUgpIjE173VJcRjKDCoXgJmpxjGAsi6frWp93RVOoGw
	qDS6vWb79FTU3Q4fmRXrPTq97qbCSEs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j7UUlK8f;
	spf=pass (imf29.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755419848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=otnnuvclATB9pcn2REqWoiWhcBFxTDUwHsgYje0v0m8=;
	b=CDVS+XOQ99reWlTZmYwKIju/1OHTSYrdzJeNpkZ9BP95NR6xg40aCGhc4uftp0RZqNUFe4
	m44f6EFYtiv+3fibM1F542hHGY3XsTZ0a5JJHcDkBefqFUU7QNZTvETG5hfuprKo02o8Lr
	olfu/DoO1SJC6+LgtHuCcnjcjP+Feyo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 72617601F6
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 08:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA55C4CEF1
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 08:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755419846;
	bh=fahrmebLSoKwWLL9QMsG46bTQEaAEKFFWHvwwUUrNZI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=j7UUlK8fFbuaUdI9gWL1nIf0EMMDi6bejqIP/nFM4LeKziczstI4pW27/rp1LmFCx
	 a6zlVwNqAq8IsbV17NAzm1vDOM/irmFiOAa29T/Nr7dHqfVSyqdJ0R0MRGK56DeQRr
	 Aua2BXDMV2lZGW0EphC/uqAsPdHsLFjFqtPiys+52evzEUJKJXeEAgis36t70SGRRE
	 ZIhQhZW8/FRoHudgwGW56k9h/s8PcMiBVm1P8y5IcxrtmpiozDQ0OYb5lUMvfNkSSF
	 8TU1C3Xm2pwQStv/W6wVHJrgthuudPVRFmZHuni/HKqRZzl9nrY+oEy5P5pkH/d4+n
	 5+jgHMuvZmpFA==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6188b5ae1e8so3442921a12.0
        for <linux-mm@kvack.org>; Sun, 17 Aug 2025 01:37:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVPotmmssR96lu/AWn+ogrWVRVpCDXV64KzZajFwWjNk757fHrH5O5ncjP406HulIp6NEZm8f7GKg==@kvack.org
X-Gm-Message-State: AOJu0YyUpOYGRxopxnUJCm0o+GZ3v78SHIvYlxFKunmu7zARbZRYwbeM
	lNxS+LRVmYgviWABE7GVCzV74a+siGwfS6+dx8/zhj9MPfHDDmun4/TjUUE+o8MkTpGlXCh8v+E
	2P6v5kFoxSRLL4uIpIQFX+/YJN+4+BFY=
X-Google-Smtp-Source: AGHT+IFK4I416JnNha6gxzDGPiU4JJpXj/m/b37kpw1hRlOYIOqMymOBJ62kHnQDFLTpoC59dWF0inHCHn1MUzpSxhk=
X-Received: by 2002:a05:6402:510e:b0:615:539b:7ade with SMTP id
 4fb4d7f45d1cf-618b054dc65mr5983574a12.20.1755419845354; Sun, 17 Aug 2025
 01:37:25 -0700 (PDT)
MIME-Version: 1.0
References: <20250817083534.2398601-1-chenhuacai@loongson.cn>
In-Reply-To: <20250817083534.2398601-1-chenhuacai@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 17 Aug 2025 16:37:12 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5gtJD1Krz=EQ1T-=g9DpANkuuiV6wUcjrquYpU3hbrPA@mail.gmail.com>
X-Gm-Features: Ac12FXyjokHMwxAhvezm72Nx1-D-Pv-iLzcEjwiHvsLvO1fg05HxmcHilpmSkiw
Message-ID: <CAAhV-H5gtJD1Krz=EQ1T-=g9DpANkuuiV6wUcjrquYpU3hbrPA@mail.gmail.com>
Subject: Re: [PATCH V3] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	"Michael S . Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1DFDA120015
X-Stat-Signature: k7qbh1cuoip5afginwzmusi9pzpn1onh
X-Rspam-User: 
X-HE-Tag: 1755419847-85860
X-HE-Meta: U2FsdGVkX18ALc2bSao3wyjYHDwS5CZ+eFyJN02ErECsSCUda2DswNQ4TAZQ7binTxE8YGZ8IVcCZO2fJRYHhzwFSRA/Kp0JaC6fTRYcVKtm6a+cgSOpXtyw/QAF2lXIWUuApZx9bXGUjfg16K70HZppCi5aDjwCOpVMyHYMNxrg+H1lBVKLDDeKnufp+fWaJ39Iqoz4fj9PmHKULU/31bDMlwRWqtDWuxrbSkRQn/SZOErX9AKI6heYu/s3LflUk2QPlT2IE3j4kwyP5ddyr/Ji5FOiQqYzPOcOAibTv/piQce4IHgtLsKwFPVAAS3olJs+dgUeDk1NgJxpqmPxuT8AoN79sYB1s4UYSpY6bQcQYT3FdzQ3PsVOwW+iSQ4NzHntusORtk6tYT4I405Gr6TND36lulYCbvVaLvT8LKCAYUcUoakwJl3OTZd537HPbbjiWTTdLo3fGVvG8w5aidAztAUKtkbY2+iRYsyXWBUoYU8iu+NI1Yd8FbUn7P2rYtQTNsWUGSRZ+a2UUp/pVA3rtBAon6Cwkr/nezn3YzMHliFm4YDFK+5OX/C/cFM1RVmaNRUbDP/WffKDkvldO01Yv2uaoVHET7fv8A49PAb2QbwlOo8cusbjHjObeKwE8UuThkYJ+nnJBtIsetcpIm8kgyI+4flCVUIL75hAgyor67N5VzlAhlH3qDKINydzvxOYjugYQ0sXqvqELosx7+qj+DdUu8GaQ8YoWZi9PtlKD5393Ln3iCIPCK3KPhmW0rV5VFJ6pDM6BKOx7xzUdTpO3qo4r61xGwZ+fv4FIexV1N0GHq+MCCBB+zNrHr89AMXQ7kuZk/ehVM3PUM5P3kb3zAkeMOQAJScX2OITemvmQDEDt6+HM1PvAidImxVMRPiu8HlOGWpcTlfB76e1Y/n8RUli/xZgUQrYujE8aTIeaT38ary/shbeUTr7CDXOw7yp0KxR/RLcpNiys0d
 SuI6aJoP
 VxQBmk13Wngq4FDXCOQvO42EmnBfqj1kW2sfC1ggjPKSNNvskj4P/bn90g0RapCEEKC5ljeYh+AQojqxdIbtGUnu/y6f76pG2bUnVMEiGdCIbGDQbg8T0HCyNchgL2LlhXpR5g43WPa+cnkK22agfZPhoqgYa0g6ZtdvR3/JGUbierKCTBGpAkTPJeoiutxpoi3wCk6n/vXtkkHOPF2+GIc1Hmaz4GaeZpAntULHTl7Tjmjsg0jnRMGF1rG1fZ84IkI0a19nyTvpt2lF8y9G9vy/VR3QRNwD43y2lgrrxZb5oectxedGHEKe/CA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for my stupid, I forgot to update the commit message. :(

Huacai

On Sun, Aug 17, 2025 at 4:36=E2=80=AFPM Huacai Chen <chenhuacai@loongson.cn=
> wrote:
>
> After commit 84caf98838a3e5f4bdb34 ("mm: stop storing migration_ops in
> page->mapping") we get such an error message if CONFIG_ZSMALLOC=3Dm:
>
>  WARNING: CPU: 3 PID: 42 at mm/migrate.c:142 isolate_movable_ops_page+0xa=
8/0x1c0
>  CPU: 3 UID: 0 PID: 42 Comm: kcompactd0 Not tainted 6.16.0-rc5+ #2133 PRE=
EMPT
>  pc 9000000000540bd8 ra 9000000000540b84 tp 9000000100420000 sp 900000010=
0423a60
>  a0 9000000100193a80 a1 000000000000000c a2 000000000000001b a3 fffffffff=
fffffff
>  a4 ffffffffffffffff a5 0000000000000267 a6 0000000000000000 a7 900000010=
0423ae0
>  t0 00000000000000f1 t1 00000000000000f6 t2 0000000000000000 t3 000000000=
0000001
>  t4 ffffff00010eb834 t5 0000000000000040 t6 900000010c89d380 t7 900000000=
23fcc70
>  t8 0000000000000018 u0 0000000000000000 s9 ffffff00010eb800 s0 ffffff000=
10eb800
>  s1 000000000000000c s2 0000000000043ae0 s3 0000800000000000 s4 900000000=
219cc40
>  s5 0000000000000000 s6 ffffff00010eb800 s7 0000000000000001 s8 900000000=
25b4000
>     ra: 9000000000540b84 isolate_movable_ops_page+0x54/0x1c0
>    ERA: 9000000000540bd8 isolate_movable_ops_page+0xa8/0x1c0
>   CRMD: 000000b0 (PLV0 -IE -DA +PG DACF=3DCC DACM=3DCC -WE)
>   PRMD: 00000004 (PPLV0 +PIE -PWE)
>   EUEN: 00000000 (-FPE -SXE -ASXE -BTE)
>   ECFG: 00071c1d (LIE=3D0,2-4,10-12 VS=3D7)
>  ESTAT: 000c0000 [BRK] (IS=3D ECode=3D12 EsubCode=3D0)
>   PRID: 0014c010 (Loongson-64bit, Loongson-3A5000)
>  CPU: 3 UID: 0 PID: 42 Comm: kcompactd0 Not tainted 6.16.0-rc5+ #2133 PRE=
EMPT
>  Stack : 90000000021fd000 0000000000000000 9000000000247720 9000000100420=
000
>          90000001004236a0 90000001004236a8 0000000000000000 9000000100423=
7e8
>          90000001004237e0 90000001004237e0 9000000100423550 0000000000000=
001
>          0000000000000001 90000001004236a8 725a84864a19e2d9 90000000023fc=
c58
>          9000000100420000 90000000024c6848 9000000002416848 0000000000000=
001
>          0000000000000000 000000000000000a 0000000007fe0000 ffffff00010eb=
800
>          0000000000000000 90000000021fd000 0000000000000000 900000000205c=
f30
>          000000000000008e 0000000000000009 ffffff00010eb800 0000000000000=
001
>          90000000025b4000 0000000000000000 900000000024773c 00007ffff103d=
748
>          00000000000000b0 0000000000000004 0000000000000000 0000000000071=
c1d
>          ...
>  Call Trace:
>  [<900000000024773c>] show_stack+0x5c/0x190
>  [<90000000002415e0>] dump_stack_lvl+0x70/0x9c
>  [<90000000004abe6c>] isolate_migratepages_block+0x3bc/0x16e0
>  [<90000000004af408>] compact_zone+0x558/0x1000
>  [<90000000004b0068>] compact_node+0xa8/0x1e0
>  [<90000000004b0aa4>] kcompactd+0x394/0x410
>  [<90000000002b3c98>] kthread+0x128/0x140
>  [<9000000001779148>] ret_from_kernel_thread+0x28/0xc0
>  [<9000000000245528>] ret_from_kernel_thread_asm+0x10/0x88
>
> The reason is that defined(CONFIG_ZSMALLOC) evaluates to 1 only when
> CONFIG_ZSMALLOC=3Dy, we should use IS_ENABLED(CONFIG_ZSMALLOC) instead.
> But when I use IS_ENABLED(CONFIG_ZSMALLOC), page_movable_ops() cannot
> access zsmalloc_mops because zsmalloc_mops is in a module.
>
> To solve this problem, we define a movable_ops[] array in mm/migrate.c,
> initialise its elements at mm/balloon_compaction.c & mm/zsmalloc.c, and
> let the page_movable_ops() function return elements from movable_ops[].
>
> Fixes: 84caf98838a3e5f ("mm: stop storing migration_ops in page->mapping"=
)
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> ---
> V2: Use EXPORT_SYMBOL_GPL_FOR_MODULES instead of EXPORT_SYMBOL and fix bu=
ild.
> V3: Use register interface instead of set array directly (Thank David).
>
>  include/linux/migrate.h |  5 +++++
>  mm/balloon_compaction.c |  6 ++++++
>  mm/migrate.c            | 38 ++++++++++++++++++++++++++++++--------
>  mm/zsmalloc.c           | 10 ++++++++++
>  4 files changed, 51 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index acadd41e0b5c..9009e27b5f44 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -79,6 +79,7 @@ void migration_entry_wait_on_locked(swp_entry_t entry, =
spinlock_t *ptl)
>  void folio_migrate_flags(struct folio *newfolio, struct folio *folio);
>  int folio_migrate_mapping(struct address_space *mapping,
>                 struct folio *newfolio, struct folio *folio, int extra_co=
unt);
> +int set_movable_ops(const struct movable_operations *ops, enum pagetype =
type);
>
>  #else
>
> @@ -100,6 +101,10 @@ static inline int migrate_huge_page_move_mapping(str=
uct address_space *mapping,
>  {
>         return -ENOSYS;
>  }
> +static inline int set_movable_ops(const struct movable_operations *ops, =
enum pagetype type)
> +{
> +       return -ENOSYS;
> +}
>
>  #endif /* CONFIG_MIGRATION */
>
> diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
> index 2a4a649805c1..03c5dbabb156 100644
> --- a/mm/balloon_compaction.c
> +++ b/mm/balloon_compaction.c
> @@ -254,4 +254,10 @@ const struct movable_operations balloon_mops =3D {
>         .putback_page =3D balloon_page_putback,
>  };
>
> +static int __init balloon_init(void)
> +{
> +       return set_movable_ops(&balloon_mops, PGTY_offline);
> +}
> +core_initcall(balloon_init);
> +
>  #endif /* CONFIG_BALLOON_COMPACTION */
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 425401b2d4e1..9e5ef39ce73a 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -43,8 +43,6 @@
>  #include <linux/sched/sysctl.h>
>  #include <linux/memory-tiers.h>
>  #include <linux/pagewalk.h>
> -#include <linux/balloon_compaction.h>
> -#include <linux/zsmalloc.h>
>
>  #include <asm/tlbflush.h>
>
> @@ -53,6 +51,33 @@
>  #include "internal.h"
>  #include "swap.h"
>
> +static const struct movable_operations *offline_movable_ops;
> +static const struct movable_operations *zsmalloc_movable_ops;
> +
> +int set_movable_ops(const struct movable_operations *ops, enum pagetype =
type)
> +{
> +       /*
> +        * We only allow for selected types and don't handle concurrent
> +        * registration attempts yet.
> +        */
> +       switch (type) {
> +       case PGTY_offline:
> +               if (offline_movable_ops && ops)
> +                       return -EBUSY;
> +               offline_movable_ops =3D ops;
> +               break;
> +       case PGTY_zsmalloc:
> +               if (zsmalloc_movable_ops && ops)
> +                       return -EBUSY;
> +               zsmalloc_movable_ops =3D ops;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(set_movable_ops);
> +
>  static const struct movable_operations *page_movable_ops(struct page *pa=
ge)
>  {
>         VM_WARN_ON_ONCE_PAGE(!page_has_movable_ops(page), page);
> @@ -62,15 +87,12 @@ static const struct movable_operations *page_movable_=
ops(struct page *page)
>          * it as movable, the page type must be sticky until the page get=
s freed
>          * back to the buddy.
>          */
> -#ifdef CONFIG_BALLOON_COMPACTION
>         if (PageOffline(page))
>                 /* Only balloon compaction sets PageOffline pages movable=
. */
> -               return &balloon_mops;
> -#endif /* CONFIG_BALLOON_COMPACTION */
> -#if defined(CONFIG_ZSMALLOC) && defined(CONFIG_COMPACTION)
> +               return offline_movable_ops;
>         if (PageZsmalloc(page))
> -               return &zsmalloc_mops;
> -#endif /* defined(CONFIG_ZSMALLOC) && defined(CONFIG_COMPACTION) */
> +               return zsmalloc_movable_ops;
> +
>         return NULL;
>  }
>
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 2c5e56a65354..6c574ab8abff 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -2246,8 +2246,15 @@ EXPORT_SYMBOL_GPL(zs_destroy_pool);
>
>  static int __init zs_init(void)
>  {
> +       int rc;
> +
>  #ifdef CONFIG_ZPOOL
>         zpool_register_driver(&zs_zpool_driver);
> +#endif
> +#ifdef CONFIG_COMPACTION
> +       rc =3D set_movable_ops(&zsmalloc_mops, PGTY_zsmalloc);
> +       if (rc)
> +               return rc;
>  #endif
>         zs_stat_init();
>         return 0;
> @@ -2257,6 +2264,9 @@ static void __exit zs_exit(void)
>  {
>  #ifdef CONFIG_ZPOOL
>         zpool_unregister_driver(&zs_zpool_driver);
> +#endif
> +#ifdef CONFIG_COMPACTION
> +       set_movable_ops(NULL, PGTY_zsmalloc);
>  #endif
>         zs_stat_exit();
>  }
> --
> 2.47.3
>

