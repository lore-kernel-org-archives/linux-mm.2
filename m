Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A5E9CDB47C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 10:25:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A4116B0088; Wed, 24 Jun 2026 06:25:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57B7B6B008A; Wed, 24 Jun 2026 06:25:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46C026B008C; Wed, 24 Jun 2026 06:25:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1AE726B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:25:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9842B164CBA
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:25:19 +0000 (UTC)
X-FDA: 84914423958.22.00009E5
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9CA212000C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:25:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kwd9ix80;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782296717;
	b=sx+1WeZgnF+fyE9jscogmb/Nxtg+1Lzk4MCEoNJdq+YXDVZ7rco1kYgLsdDw0jKt7hzbIC
	pvg6i1KeXUASiTZJW2OFJ0G2ELBcWC1U3RNTwRPpYnGrzLPbimNktPjwjBSaIPhybPqzbm
	d/yWRJgW2o0PGlIXwPvmmwX11wOWGy0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782296717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gn2q9W6t0rTfmg+/5vtYu0tyCAk29V2svA4HnR96qP8=;
	b=mPng37pJtD+XY1u3h9n41sxLkf+ZBxk7tv0O2QNULCMHTzzlFhxtyO0pg7CUB1vOIxu8NQ
	rb3nhqwLPpNYpZfEBA9Xf8XY1dyHB7zvaI6ifVnadxdmP78B33uO7y4ACLfmC0iQr3tjSi
	2E8+jk/iUm0vYfVdorcAEGZ8s1GLQK0=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kwd9ix80;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-69806f118d1so57378a12.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 03:25:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782296716; cv=none;
        d=google.com; s=arc-20240605;
        b=eAEtkQgKJ7xetsANsxaVwVEnEvvt32uMTWTJkPxzpX+Z37GrLCTtgumaIfmMkqk+tK
         8IA8mas5RcSCELcPItZrDbsO4Lnl4xPiYvTRrULwGRCPK2ctaAP2w/Utdd8Anl+e2E6l
         Rfp0gpCF3PKXfmWQIdpTHrjJw25crFZq+RFbGw5zax9vybPXXlJAvvrX+/6VUHkhhQvN
         TJ3MAJVZZhdnx4lPpfPQpa80oqHsu9eYAFwD9hWOVpi/TbX6dPd6aQFXHGdc5PnroB5x
         /VR4qvp5iTNGE4+0aaHhY8U4i3WoIh6iobyvscucKLTNiMV4vFNqGtuT37rB8BeiY6EU
         rnTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Gn2q9W6t0rTfmg+/5vtYu0tyCAk29V2svA4HnR96qP8=;
        fh=PWbGgCtx+Qs5CZyVWLeio4/i8c+3Piqb3++hw5f8aWs=;
        b=SUfsfsL4PJEVZGOZrKn4mydf/fUDiv7RQcIoJzcdue46ri6sgiR7U5R3nQ2z2q58GN
         vn9ucMNo9TskyT6aW7PL+B8K5SYjyiNH9vUVKfFYeKjv6yLQNN/vPDDoNiHZJQ65dIj5
         ouE1Hu4r4Fgffp0S+HTwmXlNaz4Vw+fAyU+1M07BOwIugibVgOecLm3ZZj9eMvcsOVT5
         Gay8EbnKw6Toy3lHYdYWbqWcpzQzXIysOfbHc+4UjcvVph/WQ1oGnZ8sxF/2NB2IxLTg
         woVOXS399aq3GiwnqCG0uQb4jrz7gCq9os45zzDxXCsncG3myvNaVOtur4mtlY56yVz9
         Dlrw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782296716; x=1782901516; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gn2q9W6t0rTfmg+/5vtYu0tyCAk29V2svA4HnR96qP8=;
        b=kwd9ix80vsUxXVDYkZ8nv2JyB55XrsTeAhkAs1EW2JouwunCn0Ozi3JEDDihqpO5C8
         KgT9KiN/1UncIxIftKDSKDQKJac2WWoKdCfauKsL1mg9en7fD8whspIO6BGWmI5lYbkk
         n7qf1zB7tT+6u5idiAjieIjP0tzXRSomtG75IjLnBO9RpDUb79K0HftItSLY/dUnI80W
         wuTUC+1BhfTHgcuniKbBSyQ/1iZQnSSjh//k4Yr/fGFXUzHOm0mqWRKPi51u5kw6Uw7q
         1PcfSZprX32cyie849AgedLjYv79jGRT+h+oim+FfDwJMv6jcDJr/IwAwq1vuAqB+V7v
         iUTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782296716; x=1782901516;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gn2q9W6t0rTfmg+/5vtYu0tyCAk29V2svA4HnR96qP8=;
        b=Re7qzRct/gPCDVLnk0Dtre2iEcISe9Nd0fqrUQVglfnLw1LK8BEqHDcMQ6+wNm+r/I
         QcdO/eqsIPybf6Eba8oDYuXd+mYsZmytPAfM8zjgjZP3Y92xI4eljzr9sb+aMN0McoSF
         biJ+2P30jyRlvN+Wv1Qy9SSVup23as8f7+FlxPsU31pyAeor2R+X00CDIKJqCxahj30V
         k4KOs4pnl7uQtyUDUOKTsy6P6Z2e1UxGgFb7ks2y3JEGXXZQhe0TQq8Eh7N7bA6ihAin
         +rMq+0TvcY/uZZNybhCCL8GjPoYJbkCagnvr3S1xBfJ53vYPuTX7U9s2HupP80gDQdjF
         HXwA==
X-Gm-Message-State: AOJu0Yx1Mq8M9QEJQiMH+5XgK6cAwpUEAdmD2TXaUIcTpWBY52f0B9Jf
	TI6aGL+x10Ti4bd+BeDLAPrYtKKhvbtTO9MHSbBN9xkXM/xogEcro1rrca7oLdZrp4ETbKONPnK
	ZIGWC8OkELJ/dNSGac6syej39MH4JRBE=
X-Gm-Gg: AfdE7clPMP50He4isFP4OgsZzZVYnRhpR4quvc9GeoLWuyFrhcCFqmPXS0hTRNlnjh+
	j0aOeceLJI79JOyg2irHq73Ofhw3gCWRFPPqBpCwyFYo+oy3Q/S4wLUvBFU7MMazl8nzRlGc1jP
	vEHnyCyptkrMNq6fUI7qrOq8Lkf3758S1gWPKQsb7BlI2ca5nFtiYSNYh6DbZZz3+xM1KHdeVNk
	84fg+jNZQTtqXIT28aP6gkNrngFnMj1I36t3XyjGRcSP5zFXFczYZlQUM0/HFptxSnSf2zgyReU
	bDtx0ZU6hoxs6qX5IENfQ46GhsYe6g==
X-Received: by 2002:a17:907:6092:b0:c07:4ce0:b013 with SMTP id
 a640c23a62f3a-c11a041a2f8mr130270766b.51.1782296715710; Wed, 24 Jun 2026
 03:25:15 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781843449.git.ritesh.list@gmail.com> <eda4e51ee9f1270582fbb2823ec5873e769de089.1781843449.git.ritesh.list@gmail.com>
In-Reply-To: <eda4e51ee9f1270582fbb2823ec5873e769de089.1781843449.git.ritesh.list@gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 24 Jun 2026 18:24:39 +0800
X-Gm-Features: AVVi8Cf04kmOBC68PWjRBoW-gvUbhJwHG2mcjG9oxoQEM2dr9vS6OCW6qGKPH3k
Message-ID: <CAMgjq7BNMYCBKDYH_O-mHsBdAeSq4Z_ve5oDB6rQTGioHo26GQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] mm, swap: allow archs to override SWAP_NR_ORDERS
 via ARCH_MAX_PMD_ORDER
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linux-mm@kvack.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, Sayali Patil <sayalip@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: tfec5rqu1pxys38jnejhbno8is87mruk
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CA212000C
X-Rspamd-Server: rspam02
X-HE-Tag: 1782296717-392498
X-HE-Meta: U2FsdGVkX1+DlhJzmXyMzEo24xm0mu1wfUErQr5vWbrodCYq2OjCGkROovsqso1iJU0nQ6JNXvRydL5J/uiZpt6x1XILt0NNgRoCQQ4tooBuuu277a/6b2drmm9jKFX0PahpZqZ9tDhN1hl/nI+uh8NuXDDxaA9ypN5bFZU8OFGmlPDAwQWCoqtCJMIDgfUOngkAS3rSTXGZgVX+NE/CAb++PGo9G7jxWxgcyst+qvvRsT9fmfYnjc7W1U+enx94eB3ybuXXcy5i69NPKiyH/3n8RIG2MdUFDKKspAbHYcXLBptvxSzWfQj2+3AP4zrPwsPPdI2R/2NyrWQACm9/axr2nL4wne9fej7Rs9/w2pjS8qcbZGlw9Zaa+VA6KrybRYSVMLugvpDyYKTnzTW9fJhag+NYcAIOwwmgvF8vC1m0YaSP00Puhcrglu7U6Sdw+AIVgb1OeU/2jOUj0285wHQfgpLlki1j/SYIa7/TEpyDHSz6rglJC7Y2oySi8raOU3I3fIizJldPeI3CF/StNZEa8AfAsL9TWBrPVWCGXERi15OCgUGSn1XXutn5rNNhIxf89DyNqIaRuyjGEtx0+4L1ak1s+3hLzypnfNohfamM/8HrkToKQJ7eMuj+QM1a2wohHuzxgnGDEWb6c7Q6VtYuTn5DiFg2p0f5n5jjprKViXgHeNUgOl//0A89wHOIrkqltvnrqt9iAO78dWbCcw936wgj6Rs4SSZ5Y/kKk1Hpc6lpHL5D4BpSfvU8V1qQ08n+pyrNC7PtSCbEEgbS/9J2V377eOEuSE5Pv58jMn711no++5cfUDFi1fuXPxpBx+BrT1yQsphW41VCSOIPEE+FoJq0ssGa8ylUXfOC0fE8SQ8kOv07ADMD5krMnVORohgjTTnGQxVx6m9o8+od9P+DXUrLONeEN8bf2U6Qr2qyaNZuEmiuO8cwRfYk32vPmGnRZUjzOWQuo3XjO9h
 rNclWoMV
 b7Brgk52wLPZn7PRc+cHss8Hl253xAwKYociDNbz361VR3yymTkM7WeZwNZS91NJSQg6sa9GSV/guqAwNH+6zTNlGdORviuGDeE+YL1YoevW83vILlni50mFyVdLroBqPKuShPNbi1xJ0zhyWRWsNSU5dYD9sEvhgYcbUppfJzUpNSJ+ZLFwh5vexx6a1D+at/4cyBy9XhGegDsnNDZ3yYhWzowGB3f/TR2GTfrI/bXK+gaGvnYbpkaGFxJYuOGWFQsvD91dO7nG/0tPXIrmUSsCZpP7TUiJ79s42khcpaK4vUwGexPEfDIZZkBnFVroJ1xo6o8YnNjNkDvAGTgcrTKGQBxTuzjm1PKhCRd5VQrCz+KCwNmU/LdTOQgaY6srvfW8tTEqPQEiijJAuvaGn45pvXMjAuQnOfBHQpdS/jbjBYfUTJlu2+3hFFw45dm8c6TPyyZaRC6RiNp6TeSrIKhWr76uYRq/8BRmpNUk7ddwu7dXk5wfCjYX53Nro3C0iSmT6ZFjgqRrczDX4wK3JDo2LACXZf/derymm3spQx7mwmDNHEVroN29bHNtw4a7GnbdW1mJLidJDnx8s2t4jowxLdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 12:42=E2=80=AFPM Ritesh Harjani (IBM)
<ritesh.list@gmail.com> wrote:
>
> SWAP_NR_ORDERS sizes a few small bounded arrays inside THP swap
> allocator code (nofull/frag cluster lists, percpu_swap_cluster's
> si/offset arrays, next array for rotational device). This currently
> expands to PMD_ORDER+1, which only works when PMD_ORDER is a compile
> time constant.
>
> However on architecture like PowerPC Book3S64, PMD_ORDER is a runtime
> variable which depends upon which MMU is selected (Radix / Hash), so in
> that case, PMD_ORDER cannot be used to size the static arrays.
>
> This patch provides an optional ARCH_MAX_PMD_ORDER (upper-bound)
> override for such architectures. The memory overhead on enabling this
> override is negligible. Even if we make SWAP_NR_ORDERS runtime alloc,
> default slab padding could cause some memory waste. Also we lose the
> per-cpu cacheline benefits (for percpu_swap_cluster) because it might
> cost an extra cacheline indirection overhead in swap_alloc_fast() for
> fetching si[order]/offset[order]. Note that a fully runtime
> SWAP_NR_ORDERS was considered in previous version but was dropped for
> this reason [1]
>
> [1]: https://lore.kernel.org/linuxppc-dev/pl1zdksc.ritesh.list@gmail.com/
>
> Suggested-by: YoungJun Park <youngjun.park@lge.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> ---
>  arch/powerpc/include/asm/book3s/64/pgtable.h |  7 +++++++
>  include/linux/swap.h                         | 12 +++++++++++-
>  2 files changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/=
include/asm/book3s/64/pgtable.h
> index e67e64ac6e8c..7f22d5d5fbdf 100644
> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
> @@ -204,6 +204,13 @@ extern unsigned long __pmd_frag_size_shift;
>  #define MAX_PTRS_PER_PGD       (1 << (H_PGD_INDEX_SIZE > RADIX_PGD_INDEX=
_SIZE ? \
>                                        H_PGD_INDEX_SIZE : RADIX_PGD_INDEX=
_SIZE))
>
> +/*
> + * Compile-time upper bound on PMD_ORDER across hash and radix MMUs.
> + * Used by THP SWAP code. Check include/linux/swap.h
> + */
> +#define ARCH_MAX_PMD_ORDER ((H_PTE_INDEX_SIZE > RADIX_PTE_INDEX_SIZE) ? =
\
> +                               H_PTE_INDEX_SIZE : RADIX_PTE_INDEX_SIZE)

Hi Ritesh

So swap is the only user of this macro? Will there by any other users?

I see that due to the percpu cluster design, it's hard to use a
flexible array here. We will probabaly get rid of the fixed percpu
cluster design in the future. By then should we be able to get rid of
this macro?

I'm OK with this approach though. This current design has no negative
effect on other archs so no reason to block it, just wondering if this
can be made simpler in the future :)

