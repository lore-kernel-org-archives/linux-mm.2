Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 701B3CCF2CA
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 21:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E2416B00A0; Sun, 18 Oct 2026 17:02:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 192BA6B00A1; Sun, 18 Oct 2026 17:02:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 082036B00A2; Sun, 18 Oct 2026 17:02:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D268F6B00A0
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 17:02:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1918C057F
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:02:08 +0000 (UTC)
X-FDA: 85336969536.11.7B892A0
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id DE436C0002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:02:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ZdW/sFnw";
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792357326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qy/eUVeUOjsCzAJiN1MNGTJCTNknQERtyP6Ddh4oOBI=;
	b=QJothq0BDyqFm0uu3xlXZicmqv17oO7JAVtbyoqKIAD5/fH49aAVIq00rkW3r6ejOx3+UQ
	eYieFedn8gnjwCplYACXRHDmTxjKX+qBE4bxhbxuhAEm9MFdLst3+915Z1PURyOn/7m8g7
	vBBdDOB/dh7bSF1xkhj9MQQpXS+S5mM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792357326;
	b=kO5O2kY5k7cDcvuDjPq1k6zYv+x+f4IUUuEA6HjtMpZhSxOEkO4tuBAvMT/cr906trzytB
	or9PqUvQDkjWDC3hrw7kq1jszfs25XiLPzBeea6t+P4TzqjOrg15OSMCyrR4BoDpmAx7iM
	RzHEZhYJ7nD2/SwYlHulE2Wb0su3VEU=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ZdW/sFnw";
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.217.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-74ab6c88052so352300137.2
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 14:02:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792357326; cv=none;
        d=google.com; s=arc-20260327;
        b=Rr10Wfwm096u/0xeLftAMjh9beIbliKKLa5udZBuljCm2xZMDE7P+0JPoxoj35wqJE
         NQx3hmoQRZlvXAh1pGwNElruG1670M3HlvD/J5emMxZJGhuJBx0/2XzRS56ZL1Sf92T5
         x7jZE5Q6l99EQ2W6ysiQ6/i6KDhuGw897O6fmWC2NBhbzLhxnyRFrEgnE4yAvto5l+C2
         VEx0zrjv9yTw4hN4bfwZyKoQq0GC+ofPpkbVeNd4igJFQaPo3xeqH6OixvFr2dKv7SVn
         BNPaQt32X816Tz1MbSiUSlWdXjiEZjE3Lyu0Xv5qAglDWnUwheiMxRMwN8iycygmV5XE
         tgyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Qy/eUVeUOjsCzAJiN1MNGTJCTNknQERtyP6Ddh4oOBI=;
        fh=1rz3Kj8HFY1jwGDvPBNjQ41YcDi0cg7oUjHfGeI8YHw=;
        b=dr+7CLhlo6r0kqCR6NX+NYMEZw/G3K8Q1GJK+y5piqjEov+6Q+0cwaL+SOn1kHNGAm
         Mjk/73qZp6jefBIi0u4lIOk1jrAHvtyzPCX8ZEhR16HSaROSwHS6YX27gzG5vDLLytPe
         ribTMR4gO45ysif+DMNOstQ0MisRp39pxJGjeyNwHrPMUjLr96tucpXJotX/H/bazq8x
         AL8xN76H3D1fjY/qdCednZIKi30ayGHQF9aMfcTOBZBbQbss+P2nsrEPrdSoXVOiKkpT
         6PD7BnG1xYEdobDNT1daI5rXZk5DBDarsDySRh/V4zc1Zp2BAKoma4pVe2fJWX+DUt2c
         Znew==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792357326; x=1792962126; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Qy/eUVeUOjsCzAJiN1MNGTJCTNknQERtyP6Ddh4oOBI=;
        b=ZdW/sFnwm118TZN1Odlvkj+j8M83+gikbTb+oFSWv6+lSo9tSbTZmwcB09/73YTw7K
         vGW/YioRJiag9Q/l6w2flByQK4l7TU51TkduKRKVBvrOlXyGnpcvlKBJCMew4umx8z8s
         594zrgaYAhccWaqdBBw1Fb+uHpK12Igo+wSnFXZWYSkayqbHKe8GffDP3sDlstPXGS4h
         4Yun4xB3ySj27U5VcByfxyoicRMK0BiJhpi4LsPNbuLice0+zZcmE1BFw28VhS66Ixh9
         R1NOQeqr+8oFx6oxFvROXiJ0xSN6t4mk4HPK298eGmYnfnWNyXulc844mHJINdDmUhsw
         DkVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792357326; x=1792962126;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qy/eUVeUOjsCzAJiN1MNGTJCTNknQERtyP6Ddh4oOBI=;
        b=qS/xAKKZPxyu3fJnwr2YoznUjnTRH/1+A9gF1Q0ZQ4l9hdmTKxxrDpDybaCV4HlEZd
         4/gilnI/Km3Ig/g7kolZ2NscQCuPgtFnvOvIoQtKEQStrHhB6x2gPUs4YiVRPF8RbsG2
         zY5//keh+A7hWErowEZ2UroeYRYmMBNnul9tQ4IkZEI7B9hOvYv3kAUx8RQMcnvNLleR
         CDV8hD9Cukx6u7S6EkMcNMvV3Ze4968wNYlVTRP1uf7vwhd/NxiOKWBhFiL2FGx4EuyG
         7Y8TXs71NTscsekXbDbbcfolAPH8BjTRbEgdqyC4jO5LIScnVAkTS4wou8a8hYcK5f2F
         6tjw==
X-Gm-Message-State: AFq9FYJ50AkgrUbKVLJn4Aa16zmc2TDlJ4r0//NnYKItXU/2cshkiAk3
	8LZ2bEd5AGdPr3Jp/vJ/CPmCVq11SJH54GKYZ3K8pxeL6QkCsqV+hrOgHr516m33BP4+sJl8lOf
	/kXB+p7ObYVfr5WeG075Y43V8y41kK00=
X-Gm-Gg: AYBFou2D0gOdU7qBa2QncMUPZzUi2kGt9oypXqXF+iQ8WGL9DVm83I3KtlvWZ8WSOq5
	EiyEUoqghFETX3fH6osnvKUXwBDAO9E3itQqNDDfHYp5hwRqwHXERodgS4fD5Akq1YLWdSshvsq
	u2ucEPY9NgNLUYY01xvuzjEue9oo4h1hJ3SxrOVvxeNolFgvfqsL77649RWWVOcsdU2y+4MhII+
	f1A97kVmBiEhTAN04J/v/x7s0yrnI81Vd89oAlA+ifvGQo0jKyNHJSxo9IYq7mRjY5+OQxJvUyd
	N2BU33E8qppcWWf/sS4mKM36PqckS3Z+bi9VlWgjHcSzyRaPHafjeL8BAmfOe7XksvjALl6wMkM
	e5k52NuMKukJtp+qiOzoiP9wouptiUzKvSAHhENtg4sMSUw==
X-Received: by 2002:a05:6102:548b:b0:7c3:c0b9:9031 with SMTP id
 ada2fe7eead31-7cc36b17a5fmr1262224137.36.1792357325888; Sun, 18 Oct 2026
 14:02:05 -0700 (PDT)
MIME-Version: 1.0
References: <20261018023349.1697434-1-gourry@gourry.net>
In-Reply-To: <20261018023349.1697434-1-gourry@gourry.net>
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Sun, 18 Oct 2026 17:01:55 -0400
X-Gm-Features: AclHuK_otQGVJnFH3of7l6giChtEJc7SlCr0xXb-9-VAKMTt98ua1SNqHcfLZJE
Message-ID: <CAN+CAwMJZ929StJF3=5pJ8uO97u6pK+XrF3LwmhHia-rUO+dUg@mail.gmail.com>
Subject: Re: [PATCH] mm/mempolicy: apply bind policies against the scoped
 allocation zone
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, rakie.kim@sk.com, 
	ying.huang@linux.alibaba.com, pasha.tatashin@soleen.com, mhocko@suse.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DE436C0002
X-Stat-Signature: ibccom1g6ogufakz8b3584a6dkoxoszd
X-Rspam-User: 
X-HE-Tag: 1792357326-100948
X-HE-Meta: U2FsdGVkX18HqByAC1Vyae4bvUQ3J6/nLQwS62nypaf/zcxHSvzaMaRcDSr+wDh1qf33cSug2+GRfzVMpSjxTFdR3kX3343Tja/K5R/seIUZhzY631TzMyxvIQiGY4UUnidvPTqSnuMtUHusToAWRbUGnTE/BBgiVQ8k3fUwjZjrRkXSwBGlL0t5a4zmE1YUC2PE66pqnm5KY5yJ2CrJuHo1cb5gUB5WCcK/C4K3Zf684kCo63nOATGBm4k4URf+JWYUf8De9e7Lx+gSKY/AAB3GSSDTsZ+MciuGxNVRKAN3AsNp1pk8CqSlTytteLZJ0OV/pfJAY4hgS59ChArakvmcJTbd909GpHf95Fy2K3G9nR+I7V74BsFMJ1govpcllJhmrZQfeqI2i5pPalz2ic6bRxpN38gKgOHFdz0ZB9Fc2RxTZKgiPOHm6EHDqTxNudewiSl77tlOrOmQzPvbuiG5+uVLm+3mMS3oKpLMTP+W+B1gnk8d1PlxaCHjbZnYXSBxg7tNvw8Rtt941kEC0grk/VMbaZGMhY3A/T/wHCSdvTx7LyJsp0m+u0pRG2f3p02dWbt0ygfzmR5/4YryrcQlrBxwVz+qLBTWg4Z0sJ/grA0rBt5kyRaMtqdw8ZbAeA9fV0i9SO2Af9LvmmvUto8sdOuqRtSU1DiMpXr+rJAz+d01/rMh982QBlpQXRlyZXzxcJ4ges3ewnEaH8c73bkJ7LYIz5GYApCjNK2PeiG76EEpY1MwWF5mJnRg71b0rstIQiXUmgz1OblQ+wl/XtjI97CaF7UNghKodZ/TODAF/SmRjSN7irm8f2Nm4m0tIkySRn932xatQhbe0KQV9l9kRdtbRxw2vXyFEr5CTtJdhJXOHuR2Gc1FIdajwQn1h8KyPUfXhAeGoEGSDFw1YhDGrOL5tQtJTw91bYfb3Bm+sWFA0GX4Rzmig54kBOXIH0eHzDOd79ZOJ+e1J2k
 Z8yn1KGP
 RVRPBSERstwfbjEK9FiefncKQUd+PTRmwPm/tUEjytPV8KGFfnLqjL6r6r+w2vNeOR8BaHjfjc0Rp3cdsUiYe11Qta/5SP2wPxb+xCg8XX0keAKbZr4ZZdMpDVaRCV6tpJ34wSsH1TI9o73CHnIz0KT4wcPE/fT4DOJYyQ6g4KCRc610Dr2esXS+z9/teL7Cfs0vBWAMqSgpZGobX5/yJ/7TUSCTcpX7WdXnioKCGknHrLcfaxYqyNB9cq9avQL022PxGClDDyH5uYijScPXhDNnMnHrEHFSk6ACGUHIrsG2FH1BY29ipKMop8qvsXT7FzFgBl1VQDrY+CBgXsuV5jcvfdy4SoTPnN4K9mIgNs4TB+TtfDF/1gjODArE51ZhomdZq1SVjJmoxWEReeR0FmfIACNWKQjxscSf2Ad2ZfiFy7vNSwAqbSEi4MXjUSNzlv/opdbF84MvUCbCMiELM2pjN6MMRXDGargbFTul7ZpsPBs1GoAeRZ/NWYhXQjmYafC3xG4ST1A9zaKNrWdoVJ/dJcYf4n925a7U7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 17, 2026 at 10:33=E2=80=AFPM Gregory Price (Meta) <gourry@gourr=
y.net> wrote:
>
> QEMU fails to start a guest with a VFIO device when guest RAM comes
> from a memory backend bound to a movable-only node:
>
>   vfio_container_dma_map(0x55b1b1317800, 0x0, 0x10000000,
>                          0x7f39a2200000)
>     =3D -12 (Cannot allocate memory)
>
> VFIO pins guest RAM when the device is realized, and the pin faults
> the pages in. io_uring fixed buffers fail the same way. Faulting the
> range in before pinning lets the same pin succeed, since resident
> pages are migrated off the node instead.
>
> A long-term pin faults under memalloc_pin_save(). PF_MEMALLOC_PIN makes
> current_gfp_context() clear __GFP_MOVABLE, but policy_nodemask() tests
> apply_policy_zone() against the caller's gfp.
>
> The bind keeps its movable-only nodemask, and the allocation finds no
> usable zone:
>
>   page allocation failure:
>       order:0,
>       mode:0x140dc2(GFP_HIGHUSER|__GFP_ZERO|__GFP_COMP),
>       nodemask=3D1,cpuset=3D/,mems_allowed=3D0-1
>
>   Call Trace:
>    warn_alloc+0x136/0x150
>    __alloc_frozen_pages_noprof+0xed8/0x1720
>    alloc_pages_mpol+0xaa/0x170
>    vma_alloc_folio_noprof+0x65/0xd0
>    __handle_mm_fault+0x137b/0x1ac0
>    handle_mm_fault+0xa0/0x270
>    __get_user_pages+0x250/0xfd0
>    __gup_longterm_locked+0x116/0x870
>    gup_fast_fallback+0xcfc/0xdf0
>    pin_user_pages_fast+0x47/0x60
>    io_pin_pages+0x9a/0x110
>
> Base page faults fail with -ENOMEM.
> hugetlb faults fail with -EFAULT.
>
> Check the policy zone against current_gfp_context(gfp), so a pin-scoped
> fault falls back off the movable-only nodemask, like any other
> non-movable allocation under the same bind.

Hi Gregory,

LGTM, thank you for making it so easy to review!
I wonder if other places are missing current_gfp_context as well.

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Tested in qemu with a dax/kmem movable-only node 1. io_uring and VFIO
> pins of unfaulted base pages and 2MB hugetlb pages now succeed and land
> on node 0 (correct). QEMU now starts with the same backend binding.
>
> Fixes: 8e3560d963d2 ("mm: honor PF_MEMALLOC_PIN for all movable pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/mempolicy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 70298fded1b4a..0884c629670dd 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2302,7 +2302,7 @@ static nodemask_t *policy_nodemask(gfp_t gfp, struc=
t mempolicy *pol,
>                 break;
>         case MPOL_BIND:
>                 /* Restrict to nodemask (but not on lower zones) */
> -               if (apply_policy_zone(pol, gfp_zone(gfp)) &&
> +               if (apply_policy_zone(pol, gfp_zone(current_gfp_context(g=
fp))) &&
>                     cpuset_nodemask_valid_mems_allowed(&pol->nodes))
>                         nodemask =3D &pol->nodes;
>                 if (pol->home_node !=3D NUMA_NO_NODE)
> --
> 2.53.0-Meta
>

