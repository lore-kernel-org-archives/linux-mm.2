Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD9A6C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 15:25:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE6C76B009E; Mon,  3 Aug 2026 11:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A97CA6B00A0; Mon,  3 Aug 2026 11:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 938AD6B00A1; Mon,  3 Aug 2026 11:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 63F4E6B009E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:25:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF3F614065D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:25:00 +0000 (UTC)
X-FDA: 85060331160.27.C7536A6
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id D800F14000F
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:24:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SkMxwW0o;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785770698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CfqUy+aUdkgVaWTQja4NA3XF8kA/c7pq/D5v+x5p88c=;
	b=Lfss1XMf3mhwNv6BaX71gFIbLhfaJZkcb+GU/hzA0pUr9VszAH4bX7ZlSUMKPgf+wW0z02
	AtbzHO78/pOb/5xeIOLRyBu3yeSmk0rLdEHTmfSfdovNs2pMGkkTHwzXFjQr0ydE34rvqW
	7INo1657jHT6NRzQKzfsRokklSki0dY=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SkMxwW0o;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785770698;
	b=LNfRviN5NYN6Iildma+xPSGwCx0nRZlUr3ws7xpNf96jJVoOKozhbyYrGtYB40GcTUh7Ix
	2o+rNJLw8I3I+F60+ZfycbtJxXYJRFg2Yp4qrcJ2tux3hsEsVYxJhopGOwm8St6mxwuhQV
	oWdO6VyG7bRaydBQUNRgM9XlOyK5hIg=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c10e86e52so388981cf.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 08:24:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785770698; cv=none;
        d=google.com; s=arc-20260327;
        b=BU98lUv66Kxnambtf38f/rIpG+79s6KBEG6DFyVp5lzs85CYwtbuT8K1tMU+FW6/2Y
         406UOmiDh9Qx1gKJC6fWOIQO/v//OfDHRbBdazlAqQEh+m7dM6eFiSo/wdOrYK+eMN90
         SKfY+nMYVJn1nidmqS3U2ALGO5jd1B8GgxYtFkGZchnm/RccXNU05UUcN03DmrgT25ut
         0Muk/2N9kZ8rzCJdBcaayhokYXdDPqyBeRhJb6jdl2sjOZZx3r2S/agOFKji/GfZYDzY
         2stnK/HC+zBIlVCN7bO4jeugQgop1kOAPCKWQvHi0PoElHtqp2/o4xK4iXxjuput/ZrC
         OKyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CfqUy+aUdkgVaWTQja4NA3XF8kA/c7pq/D5v+x5p88c=;
        fh=nursKwrxgUBNfrMS1/ypcDH3bq4XKaX8IUwedXoow90=;
        b=oNb+PM6nCdqv8LetPVhkzhgjqkYxoKC2wtW/NcQHGprOBZ5J2Z0Ua0eylBVC5udBfB
         QDdRWYgqwblTONjdtvcylSaMSDZGtd73SwTHdRAOH/gxsgUo24bghjjAsKkuXcacIiZY
         tq+2UUTU+SFUpBG8SlLd5iCabh5DiK2PtoDZIqKZfRe08sKlXw7A3Ncf2BBCbRndzjW9
         9p34rcyB5DrjkRVjKFx97cFuWLRQ4gjc/UUPP7+fUNTA6TVHoVfCQT9/FdFels2VLEqB
         14mCbuY0nzGbaeVi+3o6tsJoB8P122hkErJDKx1elKW+Bi9RI4zfNmjUutRsO0JVezeS
         BI1A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785770698; x=1786375498; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CfqUy+aUdkgVaWTQja4NA3XF8kA/c7pq/D5v+x5p88c=;
        b=SkMxwW0o1mUk5TgZOepCI1ITHvV0Ytst3WQ/2N1usP2cmctBB/SlonfIbsIE+nizJf
         hHhliADoRkwkxoIgpFzASmhh3ox2ZPvMcc4N4qWyQdOkjdzb2encKjY8pxl+UdX2KqwL
         FHX5jJ6XT0cyumt7roKa1r0j1oEIOIGdMcl2lq0FfcOcDBcK9BwzhK9nfisKk9rDUQx3
         hX/N5j7e7HdC+6mlGkvom9iQQHp119zS+gTLrV4v7eED3bOEJgo7kvJD4ROLivPnUC7I
         5nWqI1R6njBivXs6i/DNDx3/piG+ZfcZTxhz7Vt8hsSQ4w8694z0voaaqP+DPizaEUyB
         6rLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785770698; x=1786375498;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CfqUy+aUdkgVaWTQja4NA3XF8kA/c7pq/D5v+x5p88c=;
        b=tAolWozwkOzNASopxUD9V84Yd5pDWY+KkShyJjfGc1Pp8hqPcKETLyPEPH6SP3ptYx
         Rfo4GlCWcxnof9alAPn2u4FC5EZsO+BvZBqi+hlQ9CAg5P8g/UC6gvMOgQRZcB9ia/lE
         0E/1vA9gi1mjBhCQzeSPQNysxd3pHJEVbw8e0cVyK/ocYIvhaMh5G2AADEY76BJyEB1d
         tgkbI+IWVA7cQ/KuN8xVw+RUEQjzKypkf1GimNAXZvnrafVb30C/3iKmSm3b+o1e74iy
         6P/31FZswJ26wk/VpBcRGOLlRxHkj7tka3Df/5DBJe8fKKUhXemd+Sub8Ao/Q0qvVkJ4
         be4A==
X-Forwarded-Encrypted: i=1; AHgh+RpA5NqnnLrmx1XaiAhI0yYw7cq/4dWfO7d2CD/6m60ZL5DYt2yGvqjuMtRdFbrRlVsAihro40+zIw==@kvack.org
X-Gm-Message-State: AOJu0YwkGzlw5Nab0pBUD50zyYooH5v9JFrc5XscnSrNjNOoQWKjNKaM
	jR8FWLwYsH4uC7h7iNiIbY1ac7R2dxFHDBJMJfleQXzmE9rB67TW0pfr9EehWz3vPdEkFQRmXFl
	K8Z5QaJFMf1QifTJPqDW0DOAmsNL7l9quXoR1NXNi
X-Gm-Gg: AR+sD13YIIg0QEx+ggJaXUPyo9atC9uWywE/6WcCukaPFLHsD9gZebri6rYiHcgZvXS
	cgLqCOzTxcs9GljeabkR+qLCT/cO2hF9d1M+ciQDwpHSc0FfCZXjYTVas3NQ7Q9G5ibVpueXN2R
	wM9FegRySD1We4Ua5d9Giru+XDvluwQjtbUcIh4ykSAcQo9QzJoZF+9BVs4dW+Dx4c/+g4zsDh3
	aQVk83TGx5eTDIryn3oNul/ubLslcmSnxTDTCzhy3I/NHXRQqBU7IHh1X5068En/VvIzyTFxRNc
	oqCD1JAqzGkwb56JY/XJJG+bRL0bkWNbj7m7guALAUc=
X-Received: by 2002:a05:622a:a6ca:b0:527:f08f:56a2 with SMTP id
 d75a77b69052e-52b599f3008mr36400151cf.8.1785770696149; Mon, 03 Aug 2026
 08:24:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <20260802215459.2769283-2-surenb@google.com>
In-Reply-To: <20260802215459.2769283-2-surenb@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 3 Aug 2026 08:24:44 -0700
X-Gm-Features: AUfX_mw_u1ui6PiLSyc9agyyvZ5FOqC-vR7LLpP20ly173fAHJcw9rug8uJCxHU
Message-ID: <CAJuCfpGezxdaSme_QpHVq-QVeZAUaF360_Ajvkrn3QqDcSQVog@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] mm: Make per-VMA locks available universally
To: akpm@linux-foundation.org
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org, 
	david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, 
	dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D800F14000F
X-Stat-Signature: io1atnmoan3b78rhpfmju69nyn1hhc8w
X-HE-Tag: 1785770698-303136
X-HE-Meta: U2FsdGVkX19gxBW3hel0ZsSnQiSFN9SjWtbzZJoTQgeZtn661oNOxkLSE1/Rov2AS8Sf8EkmgWSshHTdcBvSBwi5PHDoTHyj+v/VGt8UnFTdfPvFcfipCrHSh5+Vg9e8cxHZFbNUXoZEViq8B9477B9pUAp8iyWE7MpNF/s8pFhGQ8lPP+pUsUie+nIfPALlr7YjvdQId4++BTjy8Oec8SBXsBe0A6nuWSdGX68Nxwb0pjZCGXsVPneanTtjylFxOCicR9l+qKnm+5EKM26vJqO5Imf9XvguLaA2WS2bMh+ovylrvhGF6t0bB9JSrn3rRkDnFiNGO798RP+gGdB7c04ZfQy/GTV/bLohF57vXqbxtx3bJIC45PHnzq3vEON81Mx5O40tfY0DrltC4BE9HKt73/Vv+0cSl/kYgGhp2OhG3vJ+yWGVMkXnLrPjV5aqj8za5tAKOdDEz2kgWhKXa5J5Iuvl5GIRfwak1LEG+BOqS6zBJxTzqF7DXLoOxvB6jw8jDV9v8jCFqtUc4aJMjDVIgjjxX+GUoLd1zNt+hzekyCCG8idKEQxoAcrgqe5StNBKuAhihwuUSozeKnoxdEFKxuULHH0WcQyGaAG9z7O/zrdnQ2yura9NleT5ciaWBrSKz/CvFKrb0T9z824EaxDMRbQ1PviY82UMNT2YWffYJFktNvFhdz+WBRNoKqDzUOE8LWrPHyYdsIA6b6cDnXg3APKGgmdIcEGmAJHIPB8smi231Q9uxgHg2v9l62anZLOIHYq9gR11/ljlOAC64uUfGp+vVRfc6hdsi4sdImJxb82+YG1pUMuNvguxdAGg+HQpYraZP6DGZb2SbTGbAJWwp6K2sSs2JVdyqSF7zq/389rwtS2rO0ZhjZzXKL6aIDI/BXQPVRfiDuKqgJ30XC7Mwp99d2KvMlsCf7an2ZWWz8pLBSGKR7KgM8836Sl8ZsIrsrffq+Qmp03KuR2
 BUzva3Vu
 hHyxCudnYe9crL1phTWeuR1BeoZJ6vhI8N8lRb1aY1gv+yCsWusTnGSIHw7M9UB2vbzxVtvCkEKQ3CcpB2jLbRmyQlKpx7YJoGIQaHUC3veQwmT18NHCQryAtYT+IiQ+efzYkyOS5RW7F9PmIq704X5+6CItFySHI1ssZu5dSCa+IxQQaHyV3mycE0ruY/w2ScSPnB61uKevdwlvHJ4QwBVpcSALtaTF4Y6emhJrUjJRa8bb3joNi39jQTNvkvrqvCLnuO1rCVsNN7x3ZbPDqSrTpM7MNsL7Hbdm38yC38SNEfeC9FqsLsbD3WbqPPzqldNUxd2TghM17idMa4HkgE+n+lKSuOub3TiSRTTK/1VsZDna+85jz6AQg7qXWVGg08q5hZ2ApKYOqStyBj8DuNaLzKGL9VPxbc2OaMBDjkF4yhsxdlBcarGt39GG0hrKcXZ2LwQ/B7uAhyU+0gedtPI5eaQ77A5IQMAve3ejGRE1pcujyU0E1zzBrmY7Lkq/SQtWNui/0aeig8SuTj/YspMnzMGDc0LnQO/IkN7RnMb9LuiAs6YFY1LLYQT/v7KLUXF4AOfRWjjdhGzwzD3YCwOLV2+7S/Cwkprifjxe4DoCn5zhhU1f75EV04JprFcbxxGcSNZkt94OkN6QMzsDGScj947Joj+se6bgEsFOqDp8rjE2RWsET/tjXQuaJTlUd/U31
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 2, 2026 at 2:55=E2=80=AFPM Suren Baghdasaryan <surenb@google.co=
m> wrote:
>
> From: Dave Hansen <dave.hansen@linux.intel.com>
>
> The per-VMA locks have been around for several years. They've had some
> bugs worked out of them and have seen quite wide use. However, they
> are still only available when architectures explicitly enable them.
> Remove the conditional compilation around the per-VMA locks, making
> them available on all architectures and configs.
>
> The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
> when the architecture started using per-VMA locks in the fault
> handler. But, contrary to the naming, the Kconfig option does not
> really indicate whether the architecture supports per-VMA locks or
> not. It is more of a marker for whether the architecture is likely to
> benefit from per-VMA locks.
>
> To me, the most important thing side-effect of universal availability
> is letting per-VMA locks be used in SMP=3Dn configs. This lets us use
> per-VMA locking in all x86 code without fallbacks.
>
> Overall, this just generally makes the kernel simpler. Just look at
> the diffstat. It also opens the door to users that want to use the
> per-VMA locks in common code. Doing *that* brings additional
> simplifications.
>
> The downside of this is adding some fields to vm_area_struct and
> mm_struct. There are likely ways to optimize this, especially for
> things like SMP=3Dn configs. For now, do the simplest thing: use the
> same implementation everywhere.
>
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: linux-mm@kvack.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> Cc: Todd Kjos <tkjos@android.com>
> Cc: Christian Brauner <christian@brauner.io>
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Alice Ryhl <aliceryhl@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: netdev@vger.kernel.org
> ---
>  arch/arm/Kconfig                       |  1 -
>  arch/arm64/Kconfig                     |  1 -
>  arch/loongarch/Kconfig                 |  1 -
>  arch/powerpc/platforms/powernv/Kconfig |  1 -
>  arch/powerpc/platforms/pseries/Kconfig |  1 -
>  arch/riscv/Kconfig                     |  1 -
>  arch/s390/Kconfig                      |  1 -
>  arch/x86/Kconfig                       |  2 -
>  fs/proc/internal.h                     |  2 -
>  fs/proc/task_mmu.c                     | 93 --------------------------
>  include/linux/mm.h                     | 12 ----
>  include/linux/mm_types.h               |  8 +--
>  include/linux/mmap_lock.h              | 50 --------------
>  kernel/bpf/stackmap.c                  | 16 +----
>  kernel/bpf/task_iter.c                 |  5 --
>  kernel/fork.c                          |  2 -
>  mm/Kconfig                             | 13 ----
>  mm/Kconfig.debug                       |  1 -
>  mm/debug.c                             |  4 --
>  mm/init-mm.c                           |  2 -
>  mm/memory.c                            |  2 -
>  mm/mmap_lock.c                         | 24 -------
>  mm/pagewalk.c                          |  2 -
>  mm/rmap.c                              |  2 -
>  mm/userfaultfd.c                       | 55 ---------------
>  rust/kernel/mm.rs                      | 22 +++---
>  tools/testing/vma/include/dup.h        |  5 +-
>  tools/testing/vma/vma_internal.h       |  1 -
>  28 files changed, 13 insertions(+), 317 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 9187240a02db..f815209167cd 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -41,7 +41,6 @@ config ARM
>         select ARCH_SUPPORTS_ATOMIC_RMW
>         select ARCH_SUPPORTS_CFI
>         select ARCH_SUPPORTS_HUGETLBFS if ARM_LPAE
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select ARCH_SUPPORTS_RT
>         select ARCH_USE_BUILTIN_BSWAP
>         select ARCH_USE_CMPXCHG_LOCKREF
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 11a9c534b7b4..21eb64b24a2c 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -81,7 +81,6 @@ config ARM64
>         select ARCH_HAS_PTE_PROTNONE
>         select ARCH_SUPPORTS_NUMA_BALANCING
>         select ARCH_SUPPORTS_PAGE_TABLE_CHECK
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
>         select ARCH_SUPPORTS_RT
>         select ARCH_SUPPORTS_SCHED_SMT
> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> index e20acbe5fe7b..7741e39eca2b 100644
> --- a/arch/loongarch/Kconfig
> +++ b/arch/loongarch/Kconfig
> @@ -69,7 +69,6 @@ config LOONGARCH
>         select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
>         select ARCH_HAS_PTE_PROTNONE if 64BIT
>         select ARCH_SUPPORTS_NUMA_BALANCING if NUMA
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select ARCH_SUPPORTS_RT
>         select ARCH_SUPPORTS_SCHED_SMT if SMP
>         select ARCH_SUPPORTS_SCHED_MC  if SMP
> diff --git a/arch/powerpc/platforms/powernv/Kconfig b/arch/powerpc/platfo=
rms/powernv/Kconfig
> index b5ad7c173ef0..dd8f6060fb7a 100644
> --- a/arch/powerpc/platforms/powernv/Kconfig
> +++ b/arch/powerpc/platforms/powernv/Kconfig
> @@ -17,7 +17,6 @@ config PPC_POWERNV
>         select PPC_DOORBELL
>         select MMU_NOTIFIER
>         select FORCE_SMP
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select PPC_RADIX_BROADCAST_TLBIE if PPC_RADIX_MMU
>         default y
>
> diff --git a/arch/powerpc/platforms/pseries/Kconfig b/arch/powerpc/platfo=
rms/pseries/Kconfig
> index 74910ce3a541..7d125e288f6e 100644
> --- a/arch/powerpc/platforms/pseries/Kconfig
> +++ b/arch/powerpc/platforms/pseries/Kconfig
> @@ -23,7 +23,6 @@ config PPC_PSERIES
>         select HOTPLUG_CPU
>         select FORCE_SMP
>         select SWIOTLB
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select PPC_RADIX_BROADCAST_TLBIE if PPC_RADIX_MMU
>         default y
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 7b9c373d82fa..faa85a031fe5 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -70,7 +70,6 @@ config RISCV
>         select ARCH_SUPPORTS_LTO_CLANG_THIN
>         select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS if 64BIT && MMU
>         select ARCH_SUPPORTS_PAGE_TABLE_CHECK if MMU
> -       select ARCH_SUPPORTS_PER_VMA_LOCK if MMU
>         select ARCH_HAS_PTE_PROTNONE if MMU
>         select ARCH_SUPPORTS_RT
>         select ARCH_SUPPORTS_SHADOW_CALL_STACK if HAVE_SHADOW_CALL_STACK
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index ab8fccc2cc4e..d1274bca8c39 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -151,7 +151,6 @@ config S390
>         select ARCH_HAS_PTE_PROTNONE
>         select ARCH_SUPPORTS_NUMA_BALANCING
>         select ARCH_SUPPORTS_PAGE_TABLE_CHECK
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select ARCH_USE_BUILTIN_BSWAP
>         select ARCH_USE_CMPXCHG_LOCKREF
>         select ARCH_USE_SYM_ANNOTATIONS
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index fb298e219179..79479d29576f 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -27,7 +27,6 @@ config X86_64
>         select ARCH_HAS_GIGANTIC_PAGE
>         select ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
>         select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
> -       select ARCH_SUPPORTS_PER_VMA_LOCK
>         select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
>         select HAVE_ARCH_SOFT_DIRTY
>         select MODULES_USE_ELF_RELA
> @@ -1846,7 +1845,6 @@ config X86_USER_SHADOW_STACK
>         bool "X86 userspace shadow stack"
>         depends on AS_WRUSS
>         depends on X86_64
> -       depends on PER_VMA_LOCK
>         select ARCH_USES_HIGH_VMA_FLAGS
>         select ARCH_HAS_USER_SHADOW_STACK
>         select X86_CET
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index b232e1098117..6713757da099 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -385,10 +385,8 @@ struct mem_size_stats;
>
>  struct proc_maps_locking_ctx {
>         struct mm_struct *mm;
> -#ifdef CONFIG_PER_VMA_LOCK
>         bool mmap_locked;
>         struct vm_area_struct *locked_vma;
> -#endif
>  };
>
>  struct proc_maps_private {
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 817e3e0f9194..096bf0b0b9e0 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -130,8 +130,6 @@ static void release_task_mempolicy(struct proc_maps_p=
rivate *priv)
>  }
>  #endif
>
> -#ifdef CONFIG_PER_VMA_LOCK
> -
>  static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
>  {
>         int ret =3D mmap_read_lock_killable(lock_ctx->mm);
> @@ -233,46 +231,6 @@ static inline void reacquire_rcu(struct proc_maps_pr=
ivate *priv)
>         vma_iter_set(&priv->iter, priv->lock_ctx.locked_vma->vm_end);
>  }
>
> -#else /* CONFIG_PER_VMA_LOCK */
> -
> -static inline int lock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -       return mmap_read_lock_killable(lock_ctx->mm);
> -}
> -
> -static inline void unlock_ctx_mm(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -       mmap_read_unlock(lock_ctx->mm);
> -}
> -
> -static inline bool lock_vma_range(struct seq_file *m,
> -                                 struct proc_maps_locking_ctx *lock_ctx)
> -{
> -       return lock_ctx_mm(lock_ctx) =3D=3D 0;
> -}
> -
> -static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock_c=
tx)
> -{
> -       unlock_ctx_mm(lock_ctx);
> -}
> -
> -static struct vm_area_struct *get_next_vma(struct proc_maps_private *pri=
v,
> -                                          loff_t last_pos)
> -{
> -       return vma_next(&priv->iter);
> -}
> -
> -static inline bool fallback_to_mmap_lock(struct proc_maps_private *priv,
> -                                        loff_t pos)
> -{
> -       return false;
> -}
> -
> -static inline void drop_rcu(struct proc_maps_private *priv) {}
> -static inline void reacquire_rcu(struct proc_maps_private *priv) {}
> -
> -#endif /* CONFIG_PER_VMA_LOCK */
> -
>  static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *p=
pos)
>  {
>         struct proc_maps_private *priv =3D m->private;
> @@ -560,8 +518,6 @@ static int pid_maps_open(struct inode *inode, struct =
file *file)
>                 PROCMAP_QUERY_VMA_FLAGS                         \
>  )
>
> -#ifdef CONFIG_PER_VMA_LOCK
> -
>  static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
>  {
>         reset_lock_ctx(lock_ctx);
> @@ -612,26 +568,6 @@ static struct vm_area_struct *query_vma_find_by_addr=
(struct proc_maps_locking_ct
>         return vma;
>  }
>
> -#else /* CONFIG_PER_VMA_LOCK */
> -
> -static int query_vma_setup(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -       return mmap_read_lock_killable(lock_ctx->mm);
> -}
> -
> -static void query_vma_teardown(struct proc_maps_locking_ctx *lock_ctx)
> -{
> -       mmap_read_unlock(lock_ctx->mm);
> -}
> -
> -static struct vm_area_struct *query_vma_find_by_addr(struct proc_maps_lo=
cking_ctx *lock_ctx,
> -                                                    unsigned long addr)
> -{
> -       return find_vma(lock_ctx->mm, addr);
> -}
> -
> -#endif  /* CONFIG_PER_VMA_LOCK */
> -
>  static struct vm_area_struct *query_matching_vma(struct proc_maps_lockin=
g_ctx *lock_ctx,
>                                                  unsigned long addr, u32 =
flags)
>  {
> @@ -1314,8 +1250,6 @@ static const struct mm_walk_ops smaps_shmem_walk_op=
s =3D {
>         .walk_lock              =3D PGWALK_RDLOCK,
>  };
>
> -#ifdef CONFIG_PER_VMA_LOCK
> -
>  static const struct mm_walk_ops smaps_walk_vma_lock_ops =3D {
>         .pmd_entry              =3D smaps_pte_range,
>         .hugetlb_entry          =3D smaps_hugetlb_range,
> @@ -1345,22 +1279,6 @@ get_smaps_shmem_walk_ops(struct proc_maps_private =
*priv)
>         return &smaps_shmem_walk_vma_lock_ops;
>  }
>
> -#else /* CONFIG_PER_VMA_LOCK */
> -
> -static inline const struct mm_walk_ops *
> -get_smaps_walk_ops(struct proc_maps_private *priv)
> -{
> -       return &smaps_walk_ops;
> -}
> -
> -static inline const struct mm_walk_ops *
> -get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
> -{
> -       return &smaps_shmem_walk_ops;
> -}
> -
> -#endif /* CONFIG_PER_VMA_LOCK */
> -
>  /*
>   * Gather mem stats from @vma with the indicated beginning
>   * address @start, and keep them in @mss.
> @@ -3497,7 +3415,6 @@ static const struct mm_walk_ops show_numa_ops =3D {
>         .walk_lock =3D PGWALK_RDLOCK,
>  };
>
> -#ifdef CONFIG_PER_VMA_LOCK
>  static const struct mm_walk_ops show_numa_vma_lock_ops =3D {
>         .hugetlb_entry =3D gather_hugetlb_stats,
>         .pmd_entry =3D gather_pte_stats,
> @@ -3512,16 +3429,6 @@ get_show_numa_ops(struct proc_maps_private *priv)
>         return &show_numa_vma_lock_ops;
>  }
>
> -#else /* CONFIG_PER_VMA_LOCK */
> -
> -static inline const struct mm_walk_ops *
> -get_show_numa_ops(struct proc_maps_private *priv)
> -{
> -       return &show_numa_ops;
> -}
> -
> -#endif /* CONFIG_PER_VMA_LOCK */
> -
>  /*
>   * Display pages allocated per node and memory policy via /proc.
>   */
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 7fabe6c66b4b..d9850f846242 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -931,7 +931,6 @@ static inline void vma_numab_state_free(struct vm_are=
a_struct *vma) {}
>   * These must be here rather than mmap_lock.h as dependent on vm_fault t=
ype,
>   * declared in this header.
>   */
> -#ifdef CONFIG_PER_VMA_LOCK
>  static inline void release_fault_lock(struct vm_fault *vmf)
>  {
>         if (vmf->flags & FAULT_FLAG_VMA_LOCK)
> @@ -947,17 +946,6 @@ static inline void assert_fault_locked(const struct =
vm_fault *vmf)
>         else
>                 mmap_assert_locked(vmf->vma->vm_mm);
>  }
> -#else
> -static inline void release_fault_lock(struct vm_fault *vmf)
> -{
> -       mmap_read_unlock(vmf->vma->vm_mm);
> -}
> -
> -static inline void assert_fault_locked(const struct vm_fault *vmf)
> -{
> -       mmap_assert_locked(vmf->vma->vm_mm);
> -}
> -#endif /* CONFIG_PER_VMA_LOCK */
>
>  static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
>  {
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index b5d4cd3b067b..d8e246fd09d3 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -950,7 +950,6 @@ struct vm_area_struct {
>                 vma_flags_t flags;
>         };
>
> -#ifdef CONFIG_PER_VMA_LOCK
>         /*
>          * Can only be written (using WRITE_ONCE()) while holding both:
>          *  - mmap_lock (in write mode)
> @@ -966,7 +965,7 @@ struct vm_area_struct {
>          * slowpath.
>          */
>         unsigned int vm_lock_seq;
> -#endif
> +
>         /*
>          * Low 32-bits of virtual page offset.
>          * See vma_start_virt_pgoff() comment for details.
> @@ -1003,7 +1002,6 @@ struct vm_area_struct {
>  #ifdef CONFIG_NUMA_BALANCING
>         struct vma_numab_state *numab_state;    /* NUMA Balancing state *=
/
>  #endif
> -#ifdef CONFIG_PER_VMA_LOCK
>         /*
>          * Used to keep track of firstly, whether the VMA is attached, se=
condly,
>          * if attached, how many read locks are taken, and thirdly, if th=
e
> @@ -1046,7 +1044,6 @@ struct vm_area_struct {
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>         struct lockdep_map vmlock_dep_map;
>  #endif
> -#endif
>  #ifdef CONFIG_64BIT
>         /*
>          * High 32-bits of virtual page offset.
> @@ -1254,7 +1251,6 @@ struct mm_struct {
>                                           * init_mm.mmlist, and are prote=
cted
>                                           * by mmlist_lock
>                                           */
> -#ifdef CONFIG_PER_VMA_LOCK
>                 struct rcuwait vma_writer_wait;
>                 /*
>                  * This field has lock-like semantics, meaning it is some=
times
> @@ -1274,7 +1270,7 @@ struct mm_struct {
>                  * mmap_lock.
>                  */
>                 seqcount_t mm_lock_seq;
> -#endif
> +
>                 struct futex_mm_data    futex;
>
>                 unsigned long hiwater_rss; /* High-watermark of RSS usage=
 */
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 87f77e3da77f..eb32b482434e 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -76,8 +76,6 @@ static inline void mmap_assert_write_locked(const struc=
t mm_struct *mm)
>         rwsem_assert_held_write(&mm->mmap_lock);
>  }
>
> -#ifdef CONFIG_PER_VMA_LOCK
> -
>  #ifdef CONFIG_LOCKDEP
>  #define __vma_lockdep_map(vma) (&vma->vmlock_dep_map)
>  #else
> @@ -484,54 +482,6 @@ struct vm_area_struct *lock_next_vma(struct mm_struc=
t *mm,
>                                      struct vma_iterator *iter,
>                                      unsigned long address);
>
> -#else /* CONFIG_PER_VMA_LOCK */
> -
> -static inline void mm_lock_seqcount_init(struct mm_struct *mm) {}
> -static inline void mm_lock_seqcount_begin(struct mm_struct *mm) {}
> -static inline void mm_lock_seqcount_end(struct mm_struct *mm) {}
> -
> -static inline bool mmap_lock_speculate_try_begin(struct mm_struct *mm, u=
nsigned int *seq)
> -{
> -       return false;
> -}
> -
> -static inline bool mmap_lock_speculate_retry(struct mm_struct *mm, unsig=
ned int seq)
> -{
> -       return true;
> -}
> -static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_=
refcnt) {}
> -static inline void vma_end_read(struct vm_area_struct *vma) {}
> -static inline void vma_start_write(struct vm_area_struct *vma) {}
> -static inline __must_check
> -int vma_start_write_killable(struct vm_area_struct *vma) { return 0; }
> -static inline void vma_assert_write_locked(struct vm_area_struct *vma)
> -               { mmap_assert_write_locked(vma->vm_mm); }
> -static inline bool vma_is_attached(struct vm_area_struct *vma)
> -               { return true; }
> -static inline void vma_assert_attached(struct vm_area_struct *vma) {}
> -static inline void vma_assert_detached(struct vm_area_struct *vma) {}
> -static inline void vma_mark_attached(struct vm_area_struct *vma) {}
> -static inline void vma_mark_detached(struct vm_area_struct *vma) {}
> -
> -static inline struct vm_area_struct *lock_vma_under_rcu(struct mm_struct=
 *mm,
> -               unsigned long address)
> -{
> -       return NULL;
> -}
> -
> -static inline void vma_assert_locked(struct vm_area_struct *vma)
> -{
> -       mmap_assert_locked(vma->vm_mm);
> -}
> -
> -static inline void vma_assert_stabilised(struct vm_area_struct *vma)
> -{
> -       /* If no VMA locks, then either mmap lock suffices to stabilise. =
*/
> -       mmap_assert_locked(vma->vm_mm);
> -}
> -
> -#endif /* CONFIG_PER_VMA_LOCK */

Now that I'm looking closer into this, I think we would break NOMMU
case because nommu.c does not take VMA write locks at all. So,
lock_vma_under_rcu() for example would always succeed.

Extra per_VMA lock-related fields in the vm_area_struct and mm_struct
would also inflate NOMMU structure sizes without them being used. I'm
not sure if this is an issue we should consider.

> -
>  static inline void vma_assert_can_modify(struct vm_area_struct *vma)
>  {
>         if (vma_is_attached(vma))
> diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
> index 41fe87d7302f..8848e26ef581 100644
> --- a/kernel/bpf/stackmap.c
> +++ b/kernel/bpf/stackmap.c
> @@ -272,13 +272,8 @@ struct stack_map_vma_lock {
>  /*
>   * Acquire a stable read-side reference on the VMA covering @ip.
>   *
> - * With CONFIG_PER_VMA_LOCK=3Dy this returns a VMA with its per-VMA read
> - * lock held and mmap_lock dropped, so the caller may sleep.
> - *
> - * With CONFIG_PER_VMA_LOCK=3Dn it returns a VMA with mmap_lock still
> - * held; the caller must snapshot any fields it needs and pin vm_file
> - * with get_file() before stack_map_unlock_vma() drops mmap_lock, as
> - * the VMA may be split, merged, or freed after that.
> + * This returns a VMA with its per-VMA read lock held and mmap_lock
> + * dropped, so the caller may sleep.
>   *
>   * Returns NULL on failure, in which case no lock is held.
>   */
> @@ -288,7 +283,6 @@ stack_map_lock_vma(struct stack_map_vma_lock *lock, u=
nsigned long ip)
>         struct mm_struct *mm =3D lock->mm;
>         struct vm_area_struct *vma;
>
> -       /* noop under !CONFIG_PER_VMA_LOCK */
>         vma =3D lock_vma_under_rcu(mm, ip);
>         if (vma) {
>                 lock->vma =3D vma;
> @@ -308,13 +302,11 @@ stack_map_lock_vma(struct stack_map_vma_lock *lock,=
 unsigned long ip)
>                 return NULL;
>         }
>
> -#ifdef CONFIG_PER_VMA_LOCK
>         if (!vma_start_read_locked(vma)) {
>                 mmap_read_unlock(mm);
>                 return NULL;
>         }
>         mmap_read_unlock(mm);
> -#endif
>
>         lock->vma =3D vma;
>         return vma;
> @@ -322,11 +314,7 @@ stack_map_lock_vma(struct stack_map_vma_lock *lock, =
unsigned long ip)
>
>  static void stack_map_unlock_vma(struct stack_map_vma_lock *lock)
>  {
> -#ifdef CONFIG_PER_VMA_LOCK
>         vma_end_read(lock->vma);
> -#else
> -       mmap_read_unlock(lock->mm);
> -#endif
>         lock->vma =3D NULL;
>  }
>
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index e791ae065c39..6cf815bc84be 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -835,11 +835,6 @@ __bpf_kfunc int bpf_iter_task_vma_new(struct bpf_ite=
r_task_vma *it,
>         BUILD_BUG_ON(sizeof(struct bpf_iter_task_vma_kern) !=3D sizeof(st=
ruct bpf_iter_task_vma));
>         BUILD_BUG_ON(__alignof__(struct bpf_iter_task_vma_kern) !=3D __al=
ignof__(struct bpf_iter_task_vma));
>
> -       if (!IS_ENABLED(CONFIG_PER_VMA_LOCK)) {
> -               kit->data =3D NULL;
> -               return -EOPNOTSUPP;
> -       }
> -
>         /*
>          * Reject irqs-disabled contexts including NMI. Operations used
>          * by _next() and _destroy() (vma_end_read, fput, bpf_iter_mmput_=
async)
> diff --git a/kernel/fork.c b/kernel/fork.c
> index f0e2e131a9a5..ff91f5f66c80 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1077,9 +1077,7 @@ static void mmap_init_lock(struct mm_struct *mm)
>  {
>         init_rwsem(&mm->mmap_lock);
>         mm_lock_seqcount_init(mm);
> -#ifdef CONFIG_PER_VMA_LOCK
>         rcuwait_init(&mm->vma_writer_wait);
> -#endif
>  }
>
>  static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struc=
t *p)
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 060190e12bce..77103b46b679 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1425,19 +1425,6 @@ config LRU_GEN_STATS
>  config LRU_GEN_WALKS_MMU
>         def_bool y
>         depends on LRU_GEN && ARCH_HAS_HW_PTE_YOUNG
> -# }
> -
> -config ARCH_SUPPORTS_PER_VMA_LOCK
> -       def_bool n
> -
> -config PER_VMA_LOCK
> -       def_bool y
> -       depends on ARCH_SUPPORTS_PER_VMA_LOCK && MMU && SMP
> -       help
> -         Allow per-vma locking during page fault handling.
> -
> -         This feature allows locking each virtual memory area separately=
 when
> -         handling page faults instead of taking mmap_lock.
>
>  config LOCK_MM_AND_FIND_VMA
>         bool
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index 5737a504efbb..1dd150edfe71 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -310,7 +310,6 @@ config DEBUG_KMEMLEAK_VERBOSE
>
>  config PER_VMA_LOCK_STATS
>         bool "Statistics for per-vma locks"
> -       depends on PER_VMA_LOCK
>         help
>           Say Y here to enable success, retry and failure counters of pag=
e
>           faults handled under protection of per-vma locks. When enabled,=
 the
> diff --git a/mm/debug.c b/mm/debug.c
> index 9a0297b3988d..655e6bcc0e8d 100644
> --- a/mm/debug.c
> +++ b/mm/debug.c
> @@ -157,17 +157,13 @@ void dump_vma(const struct vm_area_struct *vma)
>         pr_emerg("vma %px start %px end %px mm %px\n"
>                 "prot %lx anon_vma %px vm_ops %px\n"
>                 "pgoff %lx file %px private_data %px\n"
> -#ifdef CONFIG_PER_VMA_LOCK
>                 "refcnt %x\n"
> -#endif
>                 "flags: %#lx(%pGv)\n",
>                 vma, (void *)vma->vm_start, (void *)vma->vm_end, vma->vm_=
mm,
>                 (unsigned long)pgprot_val(vma->vm_page_prot),
>                 vma->anon_vma, vma->vm_ops, vma_start_pgoff(vma),
>                 vma->vm_file, vma->vm_private_data,
> -#ifdef CONFIG_PER_VMA_LOCK
>                 refcount_read(&vma->vm_refcnt),
> -#endif
>                 vma->vm_flags, &vma->vm_flags);
>  }
>  EXPORT_SYMBOL(dump_vma);
> diff --git a/mm/init-mm.c b/mm/init-mm.c
> index 3e792aad7626..a1bb2c2d0284 100644
> --- a/mm/init-mm.c
> +++ b/mm/init-mm.c
> @@ -39,10 +39,8 @@ struct mm_struct init_mm =3D {
>         .page_table_lock =3D  __SPIN_LOCK_UNLOCKED(init_mm.page_table_loc=
k),
>         .arg_lock       =3D  __SPIN_LOCK_UNLOCKED(init_mm.arg_lock),
>         .mmlist         =3D LIST_HEAD_INIT(init_mm.mmlist),
> -#ifdef CONFIG_PER_VMA_LOCK
>         .vma_writer_wait =3D __RCUWAIT_INITIALIZER(init_mm.vma_writer_wai=
t),
>         .mm_lock_seq    =3D SEQCNT_ZERO(init_mm.mm_lock_seq),
> -#endif
>  #ifdef CONFIG_SCHED_MM_CID
>         .mm_cid.lock =3D __RAW_SPIN_LOCK_UNLOCKED(init_mm.mm_cid.lock),
>  #endif
> diff --git a/mm/memory.c b/mm/memory.c
> index a620d425ec95..f109f6c87b28 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6813,7 +6813,6 @@ static vm_fault_t sanitize_fault_flags(struct vm_ar=
ea_struct *vma,
>                                  !is_cow_mapping(vma->vm_flags)))
>                         return VM_FAULT_SIGSEGV;
>         }
> -#ifdef CONFIG_PER_VMA_LOCK
>         /*
>          * Per-VMA locks can't be used with FAULT_FLAG_RETRY_NOWAIT becau=
se of
>          * the assumption that lock is dropped on VM_FAULT_RETRY.
> @@ -6822,7 +6821,6 @@ static vm_fault_t sanitize_fault_flags(struct vm_ar=
ea_struct *vma,
>                         (FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)) =
=3D=3D
>                         (FAULT_FLAG_VMA_LOCK | FAULT_FLAG_RETRY_NOWAIT)))
>                 return VM_FAULT_SIGSEGV;
> -#endif
>
>         return 0;
>  }
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 898c2ef1e958..e20d01e8d38f 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -43,9 +43,6 @@ void __mmap_lock_do_trace_released(struct mm_struct *mm=
, bool write)
>  EXPORT_SYMBOL(__mmap_lock_do_trace_released);
>  #endif /* CONFIG_TRACING */
>
> -#ifdef CONFIG_MMU
> -#ifdef CONFIG_PER_VMA_LOCK
> -
>  /* State shared across __vma_[start, end]_exclude_readers. */
>  struct vma_exclude_readers_state {
>         /* Input parameters. */
> @@ -431,7 +428,6 @@ struct vm_area_struct *lock_next_vma(struct mm_struct=
 *mm,
>
>         return vma;
>  }
> -#endif /* CONFIG_PER_VMA_LOCK */
>
>  #ifdef CONFIG_LOCK_MM_AND_FIND_VMA
>  #include <linux/extable.h>
> @@ -548,23 +544,3 @@ struct vm_area_struct *lock_mm_and_find_vma(struct m=
m_struct *mm,
>         return NULL;
>  }
>  #endif /* CONFIG_LOCK_MM_AND_FIND_VMA */
> -
> -#else /* CONFIG_MMU */
> -
> -/*
> - * At least xtensa ends up having protection faults even with no
> - * MMU.. No stack expansion, at least.
> - */
> -struct vm_area_struct *lock_mm_and_find_vma(struct mm_struct *mm,
> -                       unsigned long addr, struct pt_regs *regs)
> -{
> -       struct vm_area_struct *vma;
> -
> -       mmap_read_lock(mm);
> -       vma =3D vma_lookup(mm, addr);
> -       if (!vma)
> -               mmap_read_unlock(mm);
> -       return vma;
> -}
> -
> -#endif /* CONFIG_MMU */
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index ed4860c01936..fbcf64c59a97 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -446,7 +446,6 @@ static inline void process_mm_walk_lock(struct mm_str=
uct *mm,
>  static inline void process_vma_walk_lock(struct vm_area_struct *vma,
>                                          enum page_walk_lock walk_lock)
>  {
> -#ifdef CONFIG_PER_VMA_LOCK
>         switch (walk_lock) {
>         case PGWALK_WRLOCK:
>                 vma_start_write(vma);
> @@ -461,7 +460,6 @@ static inline void process_vma_walk_lock(struct vm_ar=
ea_struct *vma,
>                 /* PGWALK_RDLOCK is handled by process_mm_walk_lock */
>                 break;
>         }
> -#endif
>  }
>
>  /*
> diff --git a/mm/rmap.c b/mm/rmap.c
> index b917431759ee..4e4a4b747977 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -260,11 +260,9 @@ static void check_anon_vma_clone(struct vm_area_stru=
ct *dst,
>         /* For the anon_vma to be compatible, it can only be singular. */
>         VM_WARN_ON_ONCE(operation =3D=3D VMA_OP_MERGE_UNFAULTED &&
>                         !list_is_singular(&src->anon_vma_chain));
> -#ifdef CONFIG_PER_VMA_LOCK
>         /* Only merging an unfaulted VMA leaves the destination attached.=
 */
>         VM_WARN_ON_ONCE(operation !=3D VMA_OP_MERGE_UNFAULTED &&
>                         vma_is_attached(dst));
> -#endif
>  }
>
>  static void maybe_reuse_anon_vma(struct vm_area_struct *dst,
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 258b03182a78..edd90892f8cc 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -122,7 +122,6 @@ struct vm_area_struct *find_vma_and_prepare_anon(stru=
ct mm_struct *mm,
>         return vma;
>  }
>
> -#ifdef CONFIG_PER_VMA_LOCK
>  /*
>   * uffd_lock_vma() - Lookup and lock vma corresponding to @address.
>   * @mm: mm to search vma in.
> @@ -182,34 +181,6 @@ static void uffd_mfill_unlock(struct vm_area_struct =
*vma)
>         vma_end_read(vma);
>  }
>
> -#else
> -
> -static struct vm_area_struct *uffd_mfill_lock(struct mm_struct *dst_mm,
> -                                             unsigned long dst_start,
> -                                             unsigned long len)
> -{
> -       struct vm_area_struct *dst_vma;
> -
> -       mmap_read_lock(dst_mm);
> -       dst_vma =3D find_vma_and_prepare_anon(dst_mm, dst_start);
> -       if (IS_ERR(dst_vma))
> -               goto out_unlock;
> -
> -       if (validate_dst_vma(dst_vma, dst_start + len))
> -               return dst_vma;
> -
> -       dst_vma =3D ERR_PTR(-ENOENT);
> -out_unlock:
> -       mmap_read_unlock(dst_mm);
> -       return dst_vma;
> -}
> -
> -static void uffd_mfill_unlock(struct vm_area_struct *vma)
> -{
> -       mmap_read_unlock(vma->vm_mm);
> -}
> -#endif
> -
>  static void mfill_put_vma(struct mfill_state *state)
>  {
>         if (!state->vma)
> @@ -1852,7 +1823,6 @@ int find_vmas_mm_locked(struct mm_struct *mm,
>         return 0;
>  }
>
> -#ifdef CONFIG_PER_VMA_LOCK
>  static int uffd_move_lock(struct mm_struct *mm,
>                           unsigned long dst_start,
>                           unsigned long src_start,
> @@ -1927,31 +1897,6 @@ static void uffd_move_unlock(struct vm_area_struct=
 *dst_vma,
>                 vma_end_read(dst_vma);
>  }
>
> -#else
> -
> -static int uffd_move_lock(struct mm_struct *mm,
> -                         unsigned long dst_start,
> -                         unsigned long src_start,
> -                         struct vm_area_struct **dst_vmap,
> -                         struct vm_area_struct **src_vmap)
> -{
> -       int err;
> -
> -       mmap_read_lock(mm);
> -       err =3D find_vmas_mm_locked(mm, dst_start, src_start, dst_vmap, s=
rc_vmap);
> -       if (err)
> -               mmap_read_unlock(mm);
> -       return err;
> -}
> -
> -static void uffd_move_unlock(struct vm_area_struct *dst_vma,
> -                            struct vm_area_struct *src_vma)
> -{
> -       mmap_assert_locked(src_vma->vm_mm);
> -       mmap_read_unlock(dst_vma->vm_mm);
> -}
> -#endif
> -
>  /**
>   * move_pages - move arbitrary anonymous pages of an existing vma
>   * @ctx: pointer to the userfaultfd context
> diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
> index 4764d7b68f2a..2633e704c83d 100644
> --- a/rust/kernel/mm.rs
> +++ b/rust/kernel/mm.rs
> @@ -174,26 +174,20 @@ pub unsafe fn from_raw<'a>(ptr: *const bindings::mm=
_struct) -> &'a MmWithUser {
>      /// When per-vma locks are disabled, this always returns `None`.
>      #[inline]
>      pub fn lock_vma_under_rcu(&self, vma_addr: usize) -> Option<VmaReadG=
uard<'_>> {
> -        #[cfg(CONFIG_PER_VMA_LOCK)]
>          {
>              // SAFETY: Calling `bindings::lock_vma_under_rcu` is always =
okay given an mm where
>              // `mm_users` is non-zero.
>              let vma =3D unsafe { bindings::lock_vma_under_rcu(self.as_ra=
w(), vma_addr) };
> -            if !vma.is_null() {
> -                return Some(VmaReadGuard {
> -                    // SAFETY: If `lock_vma_under_rcu` returns a non-nul=
l ptr, then it points at a
> -                    // valid vma. The vma is stable for as long as the v=
ma read lock is held.
> -                    vma: unsafe { VmaRef::from_raw(vma) },
> -                    _nts: NotThreadSafe,
> -                });
> +            if vma.is_null() {
> +                return None;
>              }
> +            Some(VmaReadGuard {
> +                // SAFETY: If `lock_vma_under_rcu` returns a non-null pt=
r, then it points at a
> +                // valid vma. The vma is stable for as long as the vma r=
ead lock is held.
> +                vma: unsafe { VmaRef::from_raw(vma) },
> +                _nts: NotThreadSafe,
> +            })
>          }
> -
> -        // Silence warnings about unused variables.
> -        #[cfg(not(CONFIG_PER_VMA_LOCK))]
> -        let _ =3D vma_addr;
> -
> -        None
>      }
>
>      /// Lock the mmap read lock.
> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/=
dup.h
> index 800e5fa02d78..362feda28526 100644
> --- a/tools/testing/vma/include/dup.h
> +++ b/tools/testing/vma/include/dup.h
> @@ -582,7 +582,6 @@ struct vm_area_struct {
>                 vma_flags_t flags;
>         };
>
> -#ifdef CONFIG_PER_VMA_LOCK
>         /*
>          * Can only be written (using WRITE_ONCE()) while holding both:
>          *  - mmap_lock (in write mode)
> @@ -598,7 +597,7 @@ struct vm_area_struct {
>          * slowpath.
>          */
>         unsigned int vm_lock_seq;
> -#endif
> +
>         unsigned int __vm_virt_pgoff_lo;
>
>         /*
> @@ -632,10 +631,8 @@ struct vm_area_struct {
>  #ifdef CONFIG_NUMA_BALANCING
>         struct vma_numab_state *numab_state;    /* NUMA Balancing state *=
/
>  #endif
> -#ifdef CONFIG_PER_VMA_LOCK
>         /* Unstable RCU readers are allowed to read this. */
>         refcount_t vm_refcnt;
> -#endif
>  #ifdef CONFIG_64BIT
>         unsigned int __vm_virt_pgoff_hi;
>  #endif
> diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_int=
ernal.h
> index 8a48b231aa7a..54d5c3360aa2 100644
> --- a/tools/testing/vma/vma_internal.h
> +++ b/tools/testing/vma/vma_internal.h
> @@ -15,7 +15,6 @@
>  #include <stdlib.h>
>
>  #define CONFIG_MMU             1
> -#define CONFIG_PER_VMA_LOCK    1
>
>  #ifdef __CONCAT
>  #undef __CONCAT
> --
> 2.55.0.508.g3f0d502094-goog
>

