Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD90CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:50:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76DA98E0045; Tue, 19 Aug 2025 13:50:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71E638E000F; Tue, 19 Aug 2025 13:50:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6FC8E0045; Tue, 19 Aug 2025 13:50:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 429E18E000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:50:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E7FEBB6A2D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:50:36 +0000 (UTC)
X-FDA: 83794246872.19.BE50379
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id B4F23180009
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:50:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="CBw/AAkt";
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755625835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=km6PpNLWNkYr2PHAayYl2M7DhJxGw5o2MNLiKmVFaS0=;
	b=f1Xhv9TzM51ofa0ucaWTsOR2VXFdKBwkNeWOo5LruR5pwakGDzCHcPJ3J9N+fOT552H/eI
	RaEeH7k7c7lcsX5ia1pUnmSEKzu+LeVRsDSoL9ewOFG/QM30rf2ZoqDnFC0so4gs8WwX7J
	OrUd/rOQnNEWQN0c8DLvMBC0hdAUl8Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="CBw/AAkt";
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755625835; a=rsa-sha256;
	cv=none;
	b=M5fmgxwgjPsbHv6bIBGGyHj5rtUjYo2zFRdBxQfQBdKQ4aiKH1ot9fxKGXVROIjav5mnX0
	otYAX4LZOXn8/yc4mVDlVxxrNhjjbg9f4h1SmjIPdcCoIMRNYwblKDyync0qTUPZl8Lkkj
	0NYraM5WCUuyQBrPhk6vtJ3h7Ip+X8Q=
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-333f8ef379dso46676281fa.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755625833; x=1756230633; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=km6PpNLWNkYr2PHAayYl2M7DhJxGw5o2MNLiKmVFaS0=;
        b=CBw/AAktCxZoMlhlnq5ul2T36nTqBRQi+F9sddqROixdyWYIsutebNwXjmYt+jPByO
         Xf32ElNdb9+guvFZHFM4BwW0JAI6+cSOSrGEnei/AlggB+QTAEGxfP+VkA1jM3XFDYpZ
         W6xVpIGlcE5E+d4D1C8hIeIA4//jjolAMOdXMK4GHJQXLIupAf8OEz1TDUX5b9tQqZky
         qcnFX1stJJ35LJL04Rq5ZuonKxbU7fH3rrvoKOah/axVQoysExOhJVADHbiyeYJB1aXB
         9nDd95+MrH/fGGajZ9aguiJACY53XQQwXq/KWH5XXcUjfgpMO06D6lZDMSDfva1SRaAx
         xmIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755625833; x=1756230633;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=km6PpNLWNkYr2PHAayYl2M7DhJxGw5o2MNLiKmVFaS0=;
        b=WdzaQQ517akRdq97OcvGSfeiDcP5UaH0ITSYewRsiTO/uWEcSJNnCGrsDejojUPWiC
         PfKwZbAlhJ8vYaocL50SsqLSy6Oa8C6yhoIqFQBU+QabTusdVs8nH6Dh8UadA43jCIW8
         TeTCQ64NFaD0Onde0FlgWUkL9X34+Md4a//Y4q/dJ9V/sBnZE2rusEPi6YjUXXjhOM5M
         5IxLaJ3y8HMYtb4Joc/K9jj8QEG7MNk8kElnSpUEvh2x5Oafp+YCiDI3msOuYFacOkWr
         DHfrdI1AE+cNUT0D2FDVUg+eligx7Td5B79eSQwmC+o/n/Vaql3Wxzf8hCxMm3WJ7L2H
         72dQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/MlG9a9MR0KFqcHNezcB/89LVe46yjaPb3VfCML5619xldVyBeGODyjSNBBhZfOjcjSFbw1dfmA==@kvack.org
X-Gm-Message-State: AOJu0YwBtPZAYcjbovvuDSNPW6RWCy+e7nmmUE3ERuTF7FJEAMSbp2Ag
	fGwesaW6bh3dSQsUOWBqZ7ml2el1EHwib8QDe1VF0MrC0YfujDf8ozGoNjRouMzIJdn4mARTbv/
	Vscu9RJQe6KsYSdn1U84LEQRL+TyaF+BACVugy8U7RA==
X-Gm-Gg: ASbGnct92ALCpepheQinWqqjkuuW0zklX1PVQExU2ygpQtPIRBEbFYbWcjIEpZ7Zf43
	39r0s87CdnGKmDqUQHy24N01u+5Pcwbvo4/WBHgrfnzoRbqn1hIrFGr5H+NswYRq56yGsqhlg/7
	VFE7QLbWKc79lAD3c0fx4Lwi4+yia/CfzlXUt7g/6pmVPE1fp2RK5t9BPEKmtdW8wSDo4oh1LMp
	BoX+B0=
X-Google-Smtp-Source: AGHT+IEPyrhvaDNhz1c/KgqB/C84HWMNJ6a8K1RQxeBYMT6Lxer2nM+HLHTk43T19Qn4hO7i8dB9Ipd5u0UIivhJbXw=
X-Received: by 2002:a2e:b302:0:b0:332:4fb8:6660 with SMTP id
 38308e7fff4ca-3353bcec86dmr19751fa.25.1755625831703; Tue, 19 Aug 2025
 10:50:31 -0700 (PDT)
MIME-Version: 1.0
References: <20250805172307.1302730-1-willy@infradead.org> <20250805172307.1302730-2-willy@infradead.org>
In-Reply-To: <20250805172307.1302730-2-willy@infradead.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 20 Aug 2025 01:49:54 +0800
X-Gm-Features: Ac12FXww6_g36LAQMb3PGlZSQI3otzU_BiRBGZi7g0W8xznNf66_AxJPv6AUHBk
Message-ID: <CAMgjq7DA6Y3vY=dfKCk4WvNA_AtH1uHmXo15UYipPgOXYw80VA@mail.gmail.com>
Subject: Re: [PATCH 01/11] mm: Introduce memdesc_flags_t
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B4F23180009
X-Rspam-User: 
X-Stat-Signature: pm3oskocq9pqmm6k6ke38abj4wx13tqt
X-Rspamd-Server: rspam09
X-HE-Tag: 1755625834-656654
X-HE-Meta: U2FsdGVkX1+DbPCUjcj+yMu77hNxFrCCq/UeWf/JrFTtFsZv0+Q8xsrYqhoAvotSk3sqWitq/zjzrDvIJpHs5aJmT07MbPgVNZNbdSG8ie7uzPrhlvGnhoQLAGrKzRnMbPxHaMW2lSOmLiusF2Xe2rjl4DEJxJ94Lg2qoRmo456zj3hlNLC21Wh2TnRSMS3MG533+19R4uiB+poJWSa/9GPYkFYPoKin7KzzVCEmbYdDINVdjqUzaJotO8AZ7iTuXmG3DUPHf3AqpiSf8KAbTURLzR5C/pXLG4+ohh5pVX5GdjUAtKlBVH8t55AQXlImQDbn9uGbE6YokIlIvSkRVaopkVywY3T2lRdP7SF3OuxA3LHWMqbuifp4H7AquruKDoQ5+lcrsr9hijaSwhB5+HH8PvbSoNrTjJ4iGAIJqJDG2Z+cB9y77Xy2/ClOsbHGZlZFuz9NyGr5+/9F2BIJKIz2G5J8cYXxO6ug/aRQCBKEuW330Gbo4c8pshJ3LyEr4EulS9p0pnEbqxRG4efdqcCh7VfF1EwW3gLy0JqVhgv3nBRe3hRk23975wIeqeilQFVXnBlFC8qP/Tpc9XiynI0ejL68gY7fp8caSwP8ymtaBe//YvyHKsrhdJg6pn4rKbLgg3BFFpytvk6T9dehK3oL5Dpkn5WfalS5r2iUHrXhls2dYG7YudFRDf22HeoQ3SzASOKIBp2onrCZeyRf3sjvTwgThThTp6TafrV9HpC9NM5LbmmQOcOFPdnKnAXRg6fk+YVD2NY0BJBEL3pbsH9Vyt56Hrl0ZmwgupJBS+WC50VcqQi6uZdAHTxQ3lhy6HzMK5JdcxXrqTOP5bZ+AFfg0Tn/KdgUbMissvreXfM3+/JUVCwofysqb6adblbLidMjSHMzVSFhOgFdLylpuUmkd03853n8ZqQQ97CibRndmI84b5iMj5pfX4yIF89Lt3rkydDXll/KvhgqQu0
 xOKBi9J+
 M7gO4QqgMhL7YsR8S6qWEZKUwtolwpxZ9aZqUwjpdEdtCJ/W0419eDF3RCY9yIntLdA8vRB6cM22gu42Px29D/NDMR0UUPo5+IEgI7TOjjo7kzb5nJ7CiXeHc3LzBh6UH/fkitIyrmeuZrxbFbZy0JT8+uCB7MgYXahn1zuqG/Gi9pqAE39I5cVoup7Ak9szDzKEcLXt4Oaj9/+7LqZRls5Xm02dTem84UlGYbNc7pD3aD3t661bQfgHOexvS7hY4rxSD5jShxf2nbqZXwXC6aTZnIzkBKmdAQOTBqNC0PdVFzmpddVpk+OAAUW75JimiYopUsWkOv1x4dXvAxkK2WkRPVRkYXihn25wzoqowm6LXRFUUQO7ZUXyYfjnAzpmyy9CxItM3j4/rO8jOdJea725ugCh0xBdRpmJKavdPm4JDngFbu4sMvoBsH3j1XiZA4tG5ZuVy64XTP9IjgPPYO64jCBoQCU0pAtO2QDh3T0N2zzsmI8puIsuVtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 6, 2025 at 2:20=E2=80=AFAM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> Wrap the unsigned long flags in a typedef.  In upcoming patches, this
> will provide a strong hint that you can't just pass a random unsigned
> long to functions which take this as an argument.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  arch/x86/mm/pat/memtype.c       |  6 ++---
>  fs/fuse/dev.c                   |  2 +-
>  fs/gfs2/glops.c                 |  2 +-
>  fs/jffs2/file.c                 |  4 ++--
>  fs/nilfs2/page.c                |  2 +-
>  fs/proc/page.c                  |  4 ++--
>  fs/ubifs/file.c                 |  6 ++---
>  include/linux/mm.h              | 32 +++++++++++++-------------
>  include/linux/mm_inline.h       | 12 +++++-----
>  include/linux/mm_types.h        |  8 +++++--
>  include/linux/mmzone.h          |  2 +-
>  include/linux/page-flags.h      | 40 ++++++++++++++++-----------------
>  include/linux/pgalloc_tag.h     |  7 +++---
>  include/trace/events/page_ref.h |  4 ++--
>  mm/filemap.c                    |  8 +++----
>  mm/huge_memory.c                |  4 ++--
>  mm/memory-failure.c             | 12 +++++-----
>  mm/mmzone.c                     |  4 ++--
>  mm/page_alloc.c                 | 12 +++++-----
>  mm/swap.c                       |  8 +++----
>  mm/vmscan.c                     | 18 +++++++--------
>  mm/workingset.c                 |  2 +-
>  22 files changed, 102 insertions(+), 97 deletions(-)
>
> diff --git a/arch/x86/mm/pat/memtype.c b/arch/x86/mm/pat/memtype.c
> index c09284302dd3..b68200a0e0c6 100644
> --- a/arch/x86/mm/pat/memtype.c
> +++ b/arch/x86/mm/pat/memtype.c
> @@ -126,7 +126,7 @@ __setup("debugpat", pat_debug_setup);
>
>  static inline enum page_cache_mode get_page_memtype(struct page *pg)
>  {
> -       unsigned long pg_flags =3D pg->flags & _PGMT_MASK;
> +       unsigned long pg_flags =3D pg->flags.f & _PGMT_MASK;
>
>         if (pg_flags =3D=3D _PGMT_WB)
>                 return _PAGE_CACHE_MODE_WB;
> @@ -161,10 +161,10 @@ static inline void set_page_memtype(struct page *pg=
,
>                 break;
>         }
>
> -       old_flags =3D READ_ONCE(pg->flags);
> +       old_flags =3D READ_ONCE(pg->flags.f);
>         do {
>                 new_flags =3D (old_flags & _PGMT_CLEAR_MASK) | memtype_fl=
ags;
> -       } while (!try_cmpxchg(&pg->flags, &old_flags, new_flags));
> +       } while (!try_cmpxchg(&pg->flags.f, &old_flags, new_flags));
>  }
>  #else
>  static inline enum page_cache_mode get_page_memtype(struct page *pg)
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index e80cd8f2c049..8a89f0aa1d4d 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -935,7 +935,7 @@ static int fuse_check_folio(struct folio *folio)
>  {
>         if (folio_mapped(folio) ||
>             folio->mapping !=3D NULL ||
> -           (folio->flags & PAGE_FLAGS_CHECK_AT_PREP &
> +           (folio->flags.f & PAGE_FLAGS_CHECK_AT_PREP &
>              ~(1 << PG_locked |
>                1 << PG_referenced |
>                1 << PG_lru |
> diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
> index fe0faad4892f..0c0a80b3baca 100644
> --- a/fs/gfs2/glops.c
> +++ b/fs/gfs2/glops.c
> @@ -40,7 +40,7 @@ static void gfs2_ail_error(struct gfs2_glock *gl, const=
 struct buffer_head *bh)
>                "AIL buffer %p: blocknr %llu state 0x%08lx mapping %p page=
 "
>                "state 0x%lx\n",
>                bh, (unsigned long long)bh->b_blocknr, bh->b_state,
> -              bh->b_folio->mapping, bh->b_folio->flags);
> +              bh->b_folio->mapping, bh->b_folio->flags.f);
>         fs_err(sdp, "AIL glock %u:%llu mapping %p\n",
>                gl->gl_name.ln_type, gl->gl_name.ln_number,
>                gfs2_glock2aspace(gl));
> diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
> index dd3dff95cb24..b697f3c259ef 100644
> --- a/fs/jffs2/file.c
> +++ b/fs/jffs2/file.c
> @@ -230,7 +230,7 @@ static int jffs2_write_begin(const struct kiocb *iocb=
,
>                         goto release_sem;
>                 }
>         }
> -       jffs2_dbg(1, "end write_begin(). folio->flags %lx\n", folio->flag=
s);
> +       jffs2_dbg(1, "end write_begin(). folio->flags %lx\n", folio->flag=
s.f);
>
>  release_sem:
>         mutex_unlock(&c->alloc_sem);
> @@ -259,7 +259,7 @@ static int jffs2_write_end(const struct kiocb *iocb,
>
>         jffs2_dbg(1, "%s(): ino #%lu, page at 0x%llx, range %d-%d, flags =
%lx\n",
>                   __func__, inode->i_ino, folio_pos(folio),
> -                 start, end, folio->flags);
> +                 start, end, folio->flags.f);
>
>         /* We need to avoid deadlock with page_cache_read() in
>            jffs2_garbage_collect_pass(). So the folio must be
> diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
> index 806b056d2260..56c4da417b6a 100644
> --- a/fs/nilfs2/page.c
> +++ b/fs/nilfs2/page.c
> @@ -167,7 +167,7 @@ void nilfs_folio_bug(struct folio *folio)
>         printk(KERN_CRIT "NILFS_FOLIO_BUG(%p): cnt=3D%d index#=3D%llu fla=
gs=3D0x%lx "
>                "mapping=3D%p ino=3D%lu\n",
>                folio, folio_ref_count(folio),
> -              (unsigned long long)folio->index, folio->flags, m, ino);
> +              (unsigned long long)folio->index, folio->flags.f, m, ino);
>
>         head =3D folio_buffers(folio);
>         if (head) {
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index ba3568e97fd1..771e0b6bc630 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -163,7 +163,7 @@ u64 stable_page_flags(const struct page *page)
>         snapshot_page(&ps, page);
>         folio =3D &ps.folio_snapshot;
>
> -       k =3D folio->flags;
> +       k =3D folio->flags.f;
>         mapping =3D (unsigned long)folio->mapping;
>         is_anon =3D mapping & FOLIO_MAPPING_ANON;
>
> @@ -238,7 +238,7 @@ u64 stable_page_flags(const struct page *page)
>         if (u & (1 << KPF_HUGE))
>                 u |=3D kpf_copy_bit(k, KPF_HWPOISON,      PG_hwpoison);
>         else
> -               u |=3D kpf_copy_bit(ps.page_snapshot.flags, KPF_HWPOISON,=
 PG_hwpoison);
> +               u |=3D kpf_copy_bit(ps.page_snapshot.flags.f, KPF_HWPOISO=
N, PG_hwpoison);
>  #endif
>
>         u |=3D kpf_copy_bit(k, KPF_RESERVED,      PG_reserved);
> diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
> index e75a6cec67be..ca41ce8208c4 100644
> --- a/fs/ubifs/file.c
> +++ b/fs/ubifs/file.c
> @@ -107,7 +107,7 @@ static int do_readpage(struct folio *folio)
>         size_t offset =3D 0;
>
>         dbg_gen("ino %lu, pg %lu, i_size %lld, flags %#lx",
> -               inode->i_ino, folio->index, i_size, folio->flags);
> +               inode->i_ino, folio->index, i_size, folio->flags.f);
>         ubifs_assert(c, !folio_test_checked(folio));
>         ubifs_assert(c, !folio->private);
>
> @@ -600,7 +600,7 @@ static int populate_page(struct ubifs_info *c, struct=
 folio *folio,
>         pgoff_t end_index;
>
>         dbg_gen("ino %lu, pg %lu, i_size %lld, flags %#lx",
> -               inode->i_ino, folio->index, i_size, folio->flags);
> +               inode->i_ino, folio->index, i_size, folio->flags.f);
>
>         end_index =3D (i_size - 1) >> PAGE_SHIFT;
>         if (!i_size || folio->index > end_index) {
> @@ -988,7 +988,7 @@ static int ubifs_writepage(struct folio *folio, struc=
t writeback_control *wbc)
>         int err, len =3D folio_size(folio);
>
>         dbg_gen("ino %lu, pg %lu, pg flags %#lx",
> -               inode->i_ino, folio->index, folio->flags);
> +               inode->i_ino, folio->index, folio->flags.f);
>         ubifs_assert(c, folio->private !=3D NULL);
>
>         /* Is the folio fully outside @i_size? (truncate in progress) */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 349f0d9aad22..779822a829a9 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -973,7 +973,7 @@ static inline unsigned int compound_order(struct page=
 *page)
>  {
>         struct folio *folio =3D (struct folio *)page;
>
> -       if (!test_bit(PG_head, &folio->flags))
> +       if (!test_bit(PG_head, &folio->flags.f))
>                 return 0;
>         return folio_large_order(folio);
>  }
> @@ -1503,7 +1503,7 @@ static inline bool is_nommu_shared_mapping(vm_flags=
_t flags)
>   */
>  static inline int page_zone_id(struct page *page)
>  {
> -       return (page->flags >> ZONEID_PGSHIFT) & ZONEID_MASK;
> +       return (page->flags.f >> ZONEID_PGSHIFT) & ZONEID_MASK;
>  }
>
>  #ifdef NODE_NOT_IN_PAGE_FLAGS
> @@ -1511,7 +1511,7 @@ int page_to_nid(const struct page *page);
>  #else
>  static inline int page_to_nid(const struct page *page)
>  {
> -       return (PF_POISONED_CHECK(page)->flags >> NODES_PGSHIFT) & NODES_=
MASK;
> +       return (PF_POISONED_CHECK(page)->flags.f >> NODES_PGSHIFT) & NODE=
S_MASK;
>  }
>  #endif
>
> @@ -1586,14 +1586,14 @@ static inline void page_cpupid_reset_last(struct =
page *page)
>  #else
>  static inline int folio_last_cpupid(struct folio *folio)
>  {
> -       return (folio->flags >> LAST_CPUPID_PGSHIFT) & LAST_CPUPID_MASK;
> +       return (folio->flags.f >> LAST_CPUPID_PGSHIFT) & LAST_CPUPID_MASK=
;
>  }
>
>  int folio_xchg_last_cpupid(struct folio *folio, int cpupid);
>
>  static inline void page_cpupid_reset_last(struct page *page)
>  {
> -       page->flags |=3D LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT;
> +       page->flags.f |=3D LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT;
>  }
>  #endif /* LAST_CPUPID_NOT_IN_PAGE_FLAGS */
>
> @@ -1689,7 +1689,7 @@ static inline u8 page_kasan_tag(const struct page *=
page)
>         u8 tag =3D KASAN_TAG_KERNEL;
>
>         if (kasan_enabled()) {
> -               tag =3D (page->flags >> KASAN_TAG_PGSHIFT) & KASAN_TAG_MA=
SK;
> +               tag =3D (page->flags.f >> KASAN_TAG_PGSHIFT) & KASAN_TAG_=
MASK;
>                 tag ^=3D 0xff;
>         }
>
> @@ -1704,12 +1704,12 @@ static inline void page_kasan_tag_set(struct page=
 *page, u8 tag)
>                 return;
>
>         tag ^=3D 0xff;
> -       old_flags =3D READ_ONCE(page->flags);
> +       old_flags =3D READ_ONCE(page->flags.f);
>         do {
>                 flags =3D old_flags;
>                 flags &=3D ~(KASAN_TAG_MASK << KASAN_TAG_PGSHIFT);
>                 flags |=3D (tag & KASAN_TAG_MASK) << KASAN_TAG_PGSHIFT;
> -       } while (unlikely(!try_cmpxchg(&page->flags, &old_flags, flags)))=
;
> +       } while (unlikely(!try_cmpxchg(&page->flags.f, &old_flags, flags)=
));
>  }
>
>  static inline void page_kasan_tag_reset(struct page *page)
> @@ -1753,13 +1753,13 @@ static inline pg_data_t *folio_pgdat(const struct=
 folio *folio)
>  #ifdef SECTION_IN_PAGE_FLAGS
>  static inline void set_page_section(struct page *page, unsigned long sec=
tion)
>  {
> -       page->flags &=3D ~(SECTIONS_MASK << SECTIONS_PGSHIFT);
> -       page->flags |=3D (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
> +       page->flags.f &=3D ~(SECTIONS_MASK << SECTIONS_PGSHIFT);
> +       page->flags.f |=3D (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
>  }
>
>  static inline unsigned long page_to_section(const struct page *page)
>  {
> -       return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
> +       return (page->flags.f >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
>  }
>  #endif
>
> @@ -1964,14 +1964,14 @@ static inline bool folio_is_longterm_pinnable(str=
uct folio *folio)
>
>  static inline void set_page_zone(struct page *page, enum zone_type zone)
>  {
> -       page->flags &=3D ~(ZONES_MASK << ZONES_PGSHIFT);
> -       page->flags |=3D (zone & ZONES_MASK) << ZONES_PGSHIFT;
> +       page->flags.f &=3D ~(ZONES_MASK << ZONES_PGSHIFT);
> +       page->flags.f |=3D (zone & ZONES_MASK) << ZONES_PGSHIFT;
>  }
>
>  static inline void set_page_node(struct page *page, unsigned long node)
>  {
> -       page->flags &=3D ~(NODES_MASK << NODES_PGSHIFT);
> -       page->flags |=3D (node & NODES_MASK) << NODES_PGSHIFT;
> +       page->flags.f &=3D ~(NODES_MASK << NODES_PGSHIFT);
> +       page->flags.f |=3D (node & NODES_MASK) << NODES_PGSHIFT;
>  }
>
>  static inline void set_page_links(struct page *page, enum zone_type zone=
,
> @@ -2013,7 +2013,7 @@ static inline long compound_nr(struct page *page)
>  {
>         struct folio *folio =3D (struct folio *)page;
>
> -       if (!test_bit(PG_head, &folio->flags))
> +       if (!test_bit(PG_head, &folio->flags.f))
>                 return 1;
>         return folio_large_nr_pages(folio);
>  }
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 89b518ff097e..150302b4a905 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -143,7 +143,7 @@ static inline int lru_tier_from_refs(int refs, bool w=
orkingset)
>
>  static inline int folio_lru_refs(struct folio *folio)
>  {
> -       unsigned long flags =3D READ_ONCE(folio->flags);
> +       unsigned long flags =3D READ_ONCE(folio->flags.f);
>
>         if (!(flags & BIT(PG_referenced)))
>                 return 0;
> @@ -156,7 +156,7 @@ static inline int folio_lru_refs(struct folio *folio)
>
>  static inline int folio_lru_gen(struct folio *folio)
>  {
> -       unsigned long flags =3D READ_ONCE(folio->flags);
> +       unsigned long flags =3D READ_ONCE(folio->flags.f);
>
>         return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
>  }
> @@ -268,7 +268,7 @@ static inline bool lru_gen_add_folio(struct lruvec *l=
ruvec, struct folio *folio,
>         gen =3D lru_gen_from_seq(seq);
>         flags =3D (gen + 1UL) << LRU_GEN_PGOFF;
>         /* see the comment on MIN_NR_GENS about PG_active */
> -       set_mask_bits(&folio->flags, LRU_GEN_MASK | BIT(PG_active), flags=
);
> +       set_mask_bits(&folio->flags.f, LRU_GEN_MASK | BIT(PG_active), fla=
gs);
>
>         lru_gen_update_size(lruvec, folio, -1, gen);
>         /* for folio_rotate_reclaimable() */
> @@ -293,7 +293,7 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
ruvec, struct folio *folio,
>
>         /* for folio_migrate_flags() */
>         flags =3D !reclaiming && lru_gen_is_active(lruvec, gen) ? BIT(PG_=
active) : 0;
> -       flags =3D set_mask_bits(&folio->flags, LRU_GEN_MASK, flags);
> +       flags =3D set_mask_bits(&folio->flags.f, LRU_GEN_MASK, flags);
>         gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
>
>         lru_gen_update_size(lruvec, folio, gen, -1);
> @@ -304,9 +304,9 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
ruvec, struct folio *folio,
>
>  static inline void folio_migrate_refs(struct folio *new, struct folio *o=
ld)
>  {
> -       unsigned long refs =3D READ_ONCE(old->flags) & LRU_REFS_MASK;
> +       unsigned long refs =3D READ_ONCE(old->flags.f) & LRU_REFS_MASK;
>
> -       set_mask_bits(&new->flags, LRU_REFS_MASK, refs);
> +       set_mask_bits(&new->flags.f, LRU_REFS_MASK, refs);
>  }
>  #else /* !CONFIG_LRU_GEN */
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 08bc2442db93..15bb1c3738c0 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -33,6 +33,10 @@ struct address_space;
>  struct futex_private_hash;
>  struct mem_cgroup;
>
> +typedef struct {
> +       unsigned long f;
> +} memdesc_flags_t;
> +
>  /*
>   * Each physical page in the system has a struct page associated with
>   * it to keep track of whatever it is we are using the page for at the
> @@ -71,7 +75,7 @@ struct mem_cgroup;
>  #endif
>
>  struct page {
> -       unsigned long flags;            /* Atomic flags, some possibly
> +       memdesc_flags_t flags;          /* Atomic flags, some possibly
>                                          * updated asynchronously */
>         /*
>          * Five words (20/40 bytes) are available in this union.
> @@ -382,7 +386,7 @@ struct folio {
>         union {
>                 struct {
>         /* public: */
> -                       unsigned long flags;
> +                       memdesc_flags_t flags;
>                         union {
>                                 struct list_head lru;
>         /* private: avoid cluttering the output */
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 0c5da9141983..b4852269da0e 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1172,7 +1172,7 @@ static inline bool zone_is_empty(struct zone *zone)
>  static inline enum zone_type page_zonenum(const struct page *page)
>  {
>         ASSERT_EXCLUSIVE_BITS(page->flags, ZONES_MASK << ZONES_PGSHIFT);
> -       return (page->flags >> ZONES_PGSHIFT) & ZONES_MASK;
> +       return (page->flags.f >> ZONES_PGSHIFT) & ZONES_MASK;
>  }
>
>  static inline enum zone_type folio_zonenum(const struct folio *folio)
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 8e4d6eda8a8d..822b3ba48163 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -217,7 +217,7 @@ static __always_inline const struct page *page_fixed_=
fake_head(const struct page
>          * cold cacheline in some cases.
>          */
>         if (IS_ALIGNED((unsigned long)page, PAGE_SIZE) &&
> -           test_bit(PG_head, &page->flags)) {
> +           test_bit(PG_head, &page->flags.f)) {
>                 /*
>                  * We can safely access the field of the @page[1] with PG=
_head
>                  * because the @page is a compound page composed with at =
least
> @@ -325,14 +325,14 @@ static __always_inline int PageTail(const struct pa=
ge *page)
>
>  static __always_inline int PageCompound(const struct page *page)
>  {
> -       return test_bit(PG_head, &page->flags) ||
> +       return test_bit(PG_head, &page->flags.f) ||
>                READ_ONCE(page->compound_head) & 1;
>  }
>
>  #define        PAGE_POISON_PATTERN     -1l
>  static inline int PagePoisoned(const struct page *page)
>  {
> -       return READ_ONCE(page->flags) =3D=3D PAGE_POISON_PATTERN;
> +       return READ_ONCE(page->flags.f) =3D=3D PAGE_POISON_PATTERN;
>  }
>
>  #ifdef CONFIG_DEBUG_VM
> @@ -349,8 +349,8 @@ static const unsigned long *const_folio_flags(const s=
truct folio *folio,
>         const struct page *page =3D &folio->page;
>
>         VM_BUG_ON_PGFLAGS(page->compound_head & 1, page);
> -       VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags), page=
);
> -       return &page[n].flags;
> +       VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), pa=
ge);
> +       return &page[n].flags.f;
>  }
>
>  static unsigned long *folio_flags(struct folio *folio, unsigned n)
> @@ -358,8 +358,8 @@ static unsigned long *folio_flags(struct folio *folio=
, unsigned n)
>         struct page *page =3D &folio->page;
>
>         VM_BUG_ON_PGFLAGS(page->compound_head & 1, page);
> -       VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags), page=
);
> -       return &page[n].flags;
> +       VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags.f), pa=
ge);
> +       return &page[n].flags.f;
>  }
>
>  /*
> @@ -449,37 +449,37 @@ FOLIO_CLEAR_FLAG(name, page)
>  #define TESTPAGEFLAG(uname, lname, policy)                             \
>  FOLIO_TEST_FLAG(lname, FOLIO_##policy)                                 \
>  static __always_inline int Page##uname(const struct page *page)         =
       \
> -{ return test_bit(PG_##lname, &policy(page, 0)->flags); }
> +{ return test_bit(PG_##lname, &policy(page, 0)->flags.f); }
>
>  #define SETPAGEFLAG(uname, lname, policy)                              \
>  FOLIO_SET_FLAG(lname, FOLIO_##policy)                                  \
>  static __always_inline void SetPage##uname(struct page *page)          \
> -{ set_bit(PG_##lname, &policy(page, 1)->flags); }
> +{ set_bit(PG_##lname, &policy(page, 1)->flags.f); }
>
>  #define CLEARPAGEFLAG(uname, lname, policy)                            \
>  FOLIO_CLEAR_FLAG(lname, FOLIO_##policy)                                 =
       \
>  static __always_inline void ClearPage##uname(struct page *page)         =
       \
> -{ clear_bit(PG_##lname, &policy(page, 1)->flags); }
> +{ clear_bit(PG_##lname, &policy(page, 1)->flags.f); }
>
>  #define __SETPAGEFLAG(uname, lname, policy)                            \
>  __FOLIO_SET_FLAG(lname, FOLIO_##policy)                                 =
       \
>  static __always_inline void __SetPage##uname(struct page *page)         =
       \
> -{ __set_bit(PG_##lname, &policy(page, 1)->flags); }
> +{ __set_bit(PG_##lname, &policy(page, 1)->flags.f); }
>
>  #define __CLEARPAGEFLAG(uname, lname, policy)                          \
>  __FOLIO_CLEAR_FLAG(lname, FOLIO_##policy)                              \
>  static __always_inline void __ClearPage##uname(struct page *page)      \
> -{ __clear_bit(PG_##lname, &policy(page, 1)->flags); }
> +{ __clear_bit(PG_##lname, &policy(page, 1)->flags.f); }
>
>  #define TESTSETFLAG(uname, lname, policy)                              \
>  FOLIO_TEST_SET_FLAG(lname, FOLIO_##policy)                             \
>  static __always_inline int TestSetPage##uname(struct page *page)       \
> -{ return test_and_set_bit(PG_##lname, &policy(page, 1)->flags); }
> +{ return test_and_set_bit(PG_##lname, &policy(page, 1)->flags.f); }
>
>  #define TESTCLEARFLAG(uname, lname, policy)                            \
>  FOLIO_TEST_CLEAR_FLAG(lname, FOLIO_##policy)                           \
>  static __always_inline int TestClearPage##uname(struct page *page)     \
> -{ return test_and_clear_bit(PG_##lname, &policy(page, 1)->flags); }
> +{ return test_and_clear_bit(PG_##lname, &policy(page, 1)->flags.f); }
>
>  #define PAGEFLAG(uname, lname, policy)                                 \
>         TESTPAGEFLAG(uname, lname, policy)                              \
> @@ -848,7 +848,7 @@ static __always_inline bool folio_test_head(const str=
uct folio *folio)
>  static __always_inline int PageHead(const struct page *page)
>  {
>         PF_POISONED_CHECK(page);
> -       return test_bit(PG_head, &page->flags) && !page_is_fake_head(page=
);
> +       return test_bit(PG_head, &page->flags.f) && !page_is_fake_head(pa=
ge);
>  }
>
>  __SETPAGEFLAG(Head, head, PF_ANY)
> @@ -1172,28 +1172,28 @@ static __always_inline int PageAnonExclusive(cons=
t struct page *page)
>          */
>         if (PageHuge(page))
>                 page =3D compound_head(page);
> -       return test_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
> +       return test_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
>  }
>
>  static __always_inline void SetPageAnonExclusive(struct page *page)
>  {
>         VM_BUG_ON_PGFLAGS(!PageAnonNotKsm(page), page);
>         VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
> -       set_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
> +       set_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
>  }
>
>  static __always_inline void ClearPageAnonExclusive(struct page *page)
>  {
>         VM_BUG_ON_PGFLAGS(!PageAnonNotKsm(page), page);
>         VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
> -       clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
> +       clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
>  }
>
>  static __always_inline void __ClearPageAnonExclusive(struct page *page)
>  {
>         VM_BUG_ON_PGFLAGS(!PageAnon(page), page);
>         VM_BUG_ON_PGFLAGS(PageHuge(page) && !PageHead(page), page);
> -       __clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags);
> +       __clear_bit(PG_anon_exclusive, &PF_ANY(page, 1)->flags.f);
>  }
>
>  #ifdef CONFIG_MMU
> @@ -1243,7 +1243,7 @@ static __always_inline void __ClearPageAnonExclusiv=
e(struct page *page)
>   */
>  static inline int folio_has_private(const struct folio *folio)
>  {
> -       return !!(folio->flags & PAGE_FLAGS_PRIVATE);
> +       return !!(folio->flags.f & PAGE_FLAGS_PRIVATE);
>  }
>
>  #undef PF_ANY
> diff --git a/include/linux/pgalloc_tag.h b/include/linux/pgalloc_tag.h
> index 8a7f4f802c57..38a82d65e58e 100644
> --- a/include/linux/pgalloc_tag.h
> +++ b/include/linux/pgalloc_tag.h
> @@ -107,7 +107,8 @@ static inline bool get_page_tag_ref(struct page *page=
, union codetag_ref *ref,
>         if (static_key_enabled(&mem_profiling_compressed)) {
>                 pgalloc_tag_idx idx;
>
> -               idx =3D (page->flags >> alloc_tag_ref_offs) & alloc_tag_r=
ef_mask;
> +               idx =3D (page->flags.f >> alloc_tag_ref_offs) &
> +                       alloc_tag_ref_mask;
>                 idx_to_ref(idx, ref);
>                 handle->page =3D page;
>         } else {
> @@ -149,11 +150,11 @@ static inline void update_page_tag_ref(union pgtag_=
ref_handle handle, union code
>                 idx =3D (unsigned long)ref_to_idx(ref);
>                 idx =3D (idx & alloc_tag_ref_mask) << alloc_tag_ref_offs;
>                 do {
> -                       old_flags =3D READ_ONCE(page->flags);
> +                       old_flags =3D READ_ONCE(page->flags.f);
>                         flags =3D old_flags;
>                         flags &=3D ~(alloc_tag_ref_mask << alloc_tag_ref_=
offs);
>                         flags |=3D idx;
> -               } while (unlikely(!try_cmpxchg(&page->flags, &old_flags, =
flags)));
> +               } while (unlikely(!try_cmpxchg(&page->flags.f, &old_flags=
, flags)));
>         } else {
>                 if (WARN_ON(!handle.ref || !ref))
>                         return;
> diff --git a/include/trace/events/page_ref.h b/include/trace/events/page_=
ref.h
> index fe33a255b7d0..ea6b5c4baf3d 100644
> --- a/include/trace/events/page_ref.h
> +++ b/include/trace/events/page_ref.h
> @@ -28,7 +28,7 @@ DECLARE_EVENT_CLASS(page_ref_mod_template,
>
>         TP_fast_assign(
>                 __entry->pfn =3D page_to_pfn(page);
> -               __entry->flags =3D page->flags;
> +               __entry->flags =3D page->flags.f;
>                 __entry->count =3D page_ref_count(page);
>                 __entry->mapcount =3D atomic_read(&page->_mapcount);
>                 __entry->mapping =3D page->mapping;
> @@ -77,7 +77,7 @@ DECLARE_EVENT_CLASS(page_ref_mod_and_test_template,
>
>         TP_fast_assign(
>                 __entry->pfn =3D page_to_pfn(page);
> -               __entry->flags =3D page->flags;
> +               __entry->flags =3D page->flags.f;
>                 __entry->count =3D page_ref_count(page);
>                 __entry->mapcount =3D atomic_read(&page->_mapcount);
>                 __entry->mapping =3D page->mapping;
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 751838ef05e5..2e63f98c9520 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1140,10 +1140,10 @@ static int wake_page_function(wait_queue_entry_t =
*wait, unsigned mode, int sync,
>          */
>         flags =3D wait->flags;
>         if (flags & WQ_FLAG_EXCLUSIVE) {
> -               if (test_bit(key->bit_nr, &key->folio->flags))
> +               if (test_bit(key->bit_nr, &key->folio->flags.f))
>                         return -1;
>                 if (flags & WQ_FLAG_CUSTOM) {
> -                       if (test_and_set_bit(key->bit_nr, &key->folio->fl=
ags))
> +                       if (test_and_set_bit(key->bit_nr, &key->folio->fl=
ags.f))
>                                 return -1;
>                         flags |=3D WQ_FLAG_DONE;
>                 }
> @@ -1226,9 +1226,9 @@ static inline bool folio_trylock_flag(struct folio =
*folio, int bit_nr,
>                                         struct wait_queue_entry *wait)
>  {
>         if (wait->flags & WQ_FLAG_EXCLUSIVE) {
> -               if (test_and_set_bit(bit_nr, &folio->flags))
> +               if (test_and_set_bit(bit_nr, &folio->flags.f))
>                         return false;
> -       } else if (test_bit(bit_nr, &folio->flags))
> +       } else if (test_bit(bit_nr, &folio->flags.f))
>                 return false;
>
>         wait->flags |=3D WQ_FLAG_WOKEN | WQ_FLAG_DONE;
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 9c38a95e9f09..6b5f8b0db6c4 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3310,8 +3310,8 @@ static void __split_folio_to_order(struct folio *fo=
lio, int old_order,
>                  * unreferenced sub-pages of an anonymous THP: we can sim=
ply drop
>                  * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
>                  */
> -               new_folio->flags &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
> -               new_folio->flags |=3D (folio->flags &
> +               new_folio->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
> +               new_folio->flags.f |=3D (folio->flags.f &
>                                 ((1L << PG_referenced) |
>                                  (1L << PG_swapbacked) |
>                                  (1L << PG_swapcache) |
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 3047b9ac667e..718eb37bd077 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1693,10 +1693,10 @@ static int identify_page_state(unsigned long pfn,=
 struct page *p,
>          * carried out only if the first check can't determine the page s=
tatus.
>          */
>         for (ps =3D error_states;; ps++)
> -               if ((p->flags & ps->mask) =3D=3D ps->res)
> +               if ((p->flags.f & ps->mask) =3D=3D ps->res)
>                         break;
>
> -       page_flags |=3D (p->flags & (1UL << PG_dirty));
> +       page_flags |=3D (p->flags.f & (1UL << PG_dirty));
>
>         if (!ps->mask)
>                 for (ps =3D error_states;; ps++)
> @@ -2123,7 +2123,7 @@ static int try_memory_failure_hugetlb(unsigned long=
 pfn, int flags, int *hugetlb
>                 return action_result(pfn, MF_MSG_FREE_HUGE, res);
>         }
>
> -       page_flags =3D folio->flags;
> +       page_flags =3D folio->flags.f;
>
>         if (!hwpoison_user_mappings(folio, p, pfn, flags)) {
>                 folio_unlock(folio);
> @@ -2384,7 +2384,7 @@ int memory_failure(unsigned long pfn, int flags)
>          * folio_remove_rmap_*() in try_to_unmap_one(). So to determine p=
age
>          * status correctly, we save a copy of the page flags at this tim=
e.
>          */
> -       page_flags =3D folio->flags;
> +       page_flags =3D folio->flags.f;
>
>         /*
>          * __munlock_folio() may clear a writeback folio's LRU flag witho=
ut
> @@ -2730,13 +2730,13 @@ static int soft_offline_in_use_page(struct page *=
page)
>                                 putback_movable_pages(&pagelist);
>
>                         pr_info("%#lx: %s migration failed %ld, type %pGp=
\n",
> -                               pfn, msg_page[huge], ret, &page->flags);
> +                               pfn, msg_page[huge], ret, &page->flags.f)=
;
>                         if (ret > 0)
>                                 ret =3D -EBUSY;
>                 }
>         } else {
>                 pr_info("%#lx: %s isolation failed, page count %d, type %=
pGp\n",
> -                       pfn, msg_page[huge], page_count(page), &page->fla=
gs);
> +                       pfn, msg_page[huge], page_count(page), &page->fla=
gs.f);
>                 ret =3D -EBUSY;
>         }
>         return ret;
> diff --git a/mm/mmzone.c b/mm/mmzone.c
> index f9baa8882fbf..0c8f181d9d50 100644
> --- a/mm/mmzone.c
> +++ b/mm/mmzone.c
> @@ -99,14 +99,14 @@ int folio_xchg_last_cpupid(struct folio *folio, int c=
pupid)
>         unsigned long old_flags, flags;
>         int last_cpupid;
>
> -       old_flags =3D READ_ONCE(folio->flags);
> +       old_flags =3D READ_ONCE(folio->flags.f);
>         do {
>                 flags =3D old_flags;
>                 last_cpupid =3D (flags >> LAST_CPUPID_PGSHIFT) & LAST_CPU=
PID_MASK;
>
>                 flags &=3D ~(LAST_CPUPID_MASK << LAST_CPUPID_PGSHIFT);
>                 flags |=3D (cpupid & LAST_CPUPID_MASK) << LAST_CPUPID_PGS=
HIFT;
> -       } while (unlikely(!try_cmpxchg(&folio->flags, &old_flags, flags))=
);
> +       } while (unlikely(!try_cmpxchg(&folio->flags.f, &old_flags, flags=
)));
>
>         return last_cpupid;
>  }
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d1d037f97c5f..b6c040f7be85 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -950,7 +950,7 @@ static inline void __free_one_page(struct page *page,
>         bool to_tail;
>
>         VM_BUG_ON(!zone_is_initialized(zone));
> -       VM_BUG_ON_PAGE(page->flags & PAGE_FLAGS_CHECK_AT_PREP, page);
> +       VM_BUG_ON_PAGE(page->flags.f & PAGE_FLAGS_CHECK_AT_PREP, page);
>
>         VM_BUG_ON(migratetype =3D=3D -1);
>         VM_BUG_ON_PAGE(pfn & ((1 << order) - 1), page);
> @@ -1043,7 +1043,7 @@ static inline bool page_expected_state(struct page =
*page,
>                         page->memcg_data |
>  #endif
>                         page_pool_page_is_pp(page) |
> -                       (page->flags & check_flags)))
> +                       (page->flags.f & check_flags)))
>                 return false;
>
>         return true;
> @@ -1059,7 +1059,7 @@ static const char *page_bad_reason(struct page *pag=
e, unsigned long flags)
>                 bad_reason =3D "non-NULL mapping";
>         if (unlikely(page_ref_count(page) !=3D 0))
>                 bad_reason =3D "nonzero _refcount";
> -       if (unlikely(page->flags & flags)) {
> +       if (unlikely(page->flags.f & flags)) {
>                 if (flags =3D=3D PAGE_FLAGS_CHECK_AT_PREP)
>                         bad_reason =3D "PAGE_FLAGS_CHECK_AT_PREP flag(s) =
set";
>                 else
> @@ -1358,7 +1358,7 @@ __always_inline bool free_pages_prepare(struct page=
 *page,
>                 int i;
>
>                 if (compound) {
> -                       page[1].flags &=3D ~PAGE_FLAGS_SECOND;
> +                       page[1].flags.f &=3D ~PAGE_FLAGS_SECOND;
>  #ifdef NR_PAGES_IN_LARGE_FOLIO
>                         folio->_nr_pages =3D 0;
>  #endif
> @@ -1372,7 +1372,7 @@ __always_inline bool free_pages_prepare(struct page=
 *page,
>                                         continue;
>                                 }
>                         }
> -                       (page + i)->flags &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
> +                       (page + i)->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PRE=
P;
>                 }
>         }
>         if (folio_test_anon(folio)) {
> @@ -1391,7 +1391,7 @@ __always_inline bool free_pages_prepare(struct page=
 *page,
>         }
>
>         page_cpupid_reset_last(page);
> -       page->flags &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
> +       page->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
>         reset_page_owner(page, order);
>         page_table_check_free(page, order);
>         pgalloc_tag_sub(page, 1 << order);
> diff --git a/mm/swap.c b/mm/swap.c
> index 3632dd061beb..d2a23aa8d5ac 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -387,14 +387,14 @@ static void __lru_cache_activate_folio(struct folio=
 *folio)
>
>  static void lru_gen_inc_refs(struct folio *folio)
>  {
> -       unsigned long new_flags, old_flags =3D READ_ONCE(folio->flags);
> +       unsigned long new_flags, old_flags =3D READ_ONCE(folio->flags.f);
>
>         if (folio_test_unevictable(folio))
>                 return;
>
>         /* see the comment on LRU_REFS_FLAGS */
>         if (!folio_test_referenced(folio)) {
> -               set_mask_bits(&folio->flags, LRU_REFS_MASK, BIT(PG_refere=
nced));
> +               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_refe=
renced));
>                 return;
>         }
>
> @@ -406,7 +406,7 @@ static void lru_gen_inc_refs(struct folio *folio)
>                 }
>
>                 new_flags =3D old_flags + BIT(LRU_REFS_PGOFF);
> -       } while (!try_cmpxchg(&folio->flags, &old_flags, new_flags));
> +       } while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
>  }
>
>  static bool lru_gen_clear_refs(struct folio *folio)
> @@ -418,7 +418,7 @@ static bool lru_gen_clear_refs(struct folio *folio)
>         if (gen < 0)
>                 return true;
>
> -       set_mask_bits(&folio->flags, LRU_REFS_FLAGS | BIT(PG_workingset),=
 0);
> +       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS | BIT(PG_workingset=
), 0);
>
>         lrugen =3D &folio_lruvec(folio)->lrugen;
>         /* whether can do without shuffling under the LRU lock */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7de11524a936..edb3c992b117 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -888,11 +888,11 @@ static bool lru_gen_set_refs(struct folio *folio)
>  {
>         /* see the comment on LRU_REFS_FLAGS */
>         if (!folio_test_referenced(folio) && !folio_test_workingset(folio=
)) {
> -               set_mask_bits(&folio->flags, LRU_REFS_MASK, BIT(PG_refere=
nced));
> +               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_refe=
renced));
>                 return false;
>         }
>
> -       set_mask_bits(&folio->flags, LRU_REFS_FLAGS, BIT(PG_workingset));
> +       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset)=
);
>         return true;
>  }
>  #else
> @@ -3257,13 +3257,13 @@ static bool positive_ctrl_err(struct ctrl_pos *sp=
, struct ctrl_pos *pv)
>  /* promote pages accessed through page tables */
>  static int folio_update_gen(struct folio *folio, int gen)
>  {
> -       unsigned long new_flags, old_flags =3D READ_ONCE(folio->flags);
> +       unsigned long new_flags, old_flags =3D READ_ONCE(folio->flags.f);
>
>         VM_WARN_ON_ONCE(gen >=3D MAX_NR_GENS);
>
>         /* see the comment on LRU_REFS_FLAGS */
>         if (!folio_test_referenced(folio) && !folio_test_workingset(folio=
)) {
> -               set_mask_bits(&folio->flags, LRU_REFS_MASK, BIT(PG_refere=
nced));
> +               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_refe=
renced));
>                 return -1;
>         }
>
> @@ -3274,7 +3274,7 @@ static int folio_update_gen(struct folio *folio, in=
t gen)
>
>                 new_flags =3D old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS=
);
>                 new_flags |=3D ((gen + 1UL) << LRU_GEN_PGOFF) | BIT(PG_wo=
rkingset);
> -       } while (!try_cmpxchg(&folio->flags, &old_flags, new_flags));
> +       } while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
>
>         return ((old_flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
>  }
> @@ -3285,7 +3285,7 @@ static int folio_inc_gen(struct lruvec *lruvec, str=
uct folio *folio, bool reclai
>         int type =3D folio_is_file_lru(folio);
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>         int new_gen, old_gen =3D lru_gen_from_seq(lrugen->min_seq[type]);
> -       unsigned long new_flags, old_flags =3D READ_ONCE(folio->flags);
> +       unsigned long new_flags, old_flags =3D READ_ONCE(folio->flags.f);
>
>         VM_WARN_ON_ONCE_FOLIO(!(old_flags & LRU_GEN_MASK), folio);
>
> @@ -3302,7 +3302,7 @@ static int folio_inc_gen(struct lruvec *lruvec, str=
uct folio *folio, bool reclai
>                 /* for folio_end_writeback() */
>                 if (reclaiming)
>                         new_flags |=3D BIT(PG_reclaim);
> -       } while (!try_cmpxchg(&folio->flags, &old_flags, new_flags));
> +       } while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
>
>         lru_gen_update_size(lruvec, folio, old_gen, new_gen);
>
> @@ -4553,7 +4553,7 @@ static bool isolate_folio(struct lruvec *lruvec, st=
ruct folio *folio, struct sca
>
>         /* see the comment on LRU_REFS_FLAGS */
>         if (!folio_test_referenced(folio))
> -               set_mask_bits(&folio->flags, LRU_REFS_MASK, 0);
> +               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
>
>         /* for shrink_folio_list() */
>         folio_clear_reclaim(folio);
> @@ -4766,7 +4766,7 @@ static int evict_folios(unsigned long nr_to_scan, s=
truct lruvec *lruvec,
>
>                 /* don't add rejected folios to the oldest generation */
>                 if (lru_gen_folio_seq(lruvec, folio, false) =3D=3D min_se=
q[type])
> -                       set_mask_bits(&folio->flags, LRU_REFS_FLAGS, BIT(=
PG_active));
> +                       set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BI=
T(PG_active));
>         }
>
>         spin_lock_irq(&lruvec->lru_lock);
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 6e7f4cb1b9a7..68a76a91111f 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -318,7 +318,7 @@ static void lru_gen_refault(struct folio *folio, void=
 *shadow)
>                 folio_set_workingset(folio);
>                 mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, =
delta);
>         } else
> -               set_mask_bits(&folio->flags, LRU_REFS_MASK, (refs - 1UL) =
<< LRU_REFS_PGOFF);
> +               set_mask_bits(&folio->flags.f, LRU_REFS_MASK, (refs - 1UL=
) << LRU_REFS_PGOFF);
>  unlock:
>         rcu_read_unlock();
>  }
> --
> 2.47.2
>
>

Hi.

I'm rebasing on mm-new, and seeing below build error after this patch:

./arch/arm64/include/asm/mte.h:207:2: error: operand of type 'typeof
(_Generic((*&folio->flags), char: (char)0, unsigned char: (unsigned
char)0, signed char: (signed char)0, unsigned short:
 (unsigned short)0, short: (short)0, unsigned int: (unsigned int)0,
int: (int)0, unsigned long: (unsigned long)0, long: (long)0, unsigned
long long: (unsigned long long)0, long long: (long
long)0, default: (*&folio->flags)))' (aka 'memdesc_flags_t') where
arithmetic or pointer type is required
  207 |         smp_cond_load_acquire(&folio->flags, VAL & (1UL <<
PG_mte_tagged));
      |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./arch/arm64/include/asm/barrier.h:217:3: note: expanded from macro
'smp_cond_load_acquire'
  217 |                 __cmpwait_relaxed(__PTR, VAL);
         \
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./arch/arm64/include/asm/cmpxchg.h:262:34: note: expanded from macro
'__cmpwait_relaxed'
  262 |         __cmpwait((ptr), (unsigned long)(val), sizeof(*(ptr)))
      |                                         ^~~~~

Error is reproducible with:
clang --version
clang version 20.1.8 (Fedora 20.1.8-3.fc43)
Target: aarch64-redhat-linux-gnu
Thread model: posix
InstalledDir: /usr/bin
Configuration file: /etc/clang/aarch64-redhat-linux-gnu-clang.cfg

