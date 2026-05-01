Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94D2ACD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 20:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B1006B0005; Fri,  1 May 2026 16:33:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 788766B008A; Fri,  1 May 2026 16:33:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69DE16B008C; Fri,  1 May 2026 16:33:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 59CB76B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 16:33:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9A111C00E9
	for <linux-mm@kvack.org>; Fri,  1 May 2026 20:33:04 +0000 (UTC)
X-FDA: 84720000288.30.53FAC51
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id C6CD4A000B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 20:33:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OW8Kc4eI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777667582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T/OAl8KInoHXQ6AvflVqniFa5LdHznYgc+Fi8xE6mQY=;
	b=OMzpfqwxMX0fxQa3Qzyq2JSYqPPly6qF+Air8doYWaTHUSfL71fwBwodAqVRBEO8mJdEFC
	tRiUfmDIYOGq1SN/y9a4Z1cZ1FhNOKtVMAUnlnQplk9pt4/c865EyxIgUaN3Lkc/JSD+Ar
	MUZQQf2H9BjyQvLkjZLHIMmwSiy/EbE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777667582; a=rsa-sha256;
	cv=pass;
	b=6+Ie151ulmdyv+qX2nlwNr6hovEnvyCKd+Bo7nq/pGMVsJY+HFxICbzdVcQvM2aa6kTXM3
	zLSNR2joEMZb0knsTTLdtvWBRfuUdxo7ulVlAgrn7MfKUHcym4B34hByPXNC4/JFuvTkeC
	FR8vxsfTHxSnz2oIc2g/pjhb17lA1AM=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=OW8Kc4eI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-50d836552daso2491cf.0
        for <linux-mm@kvack.org>; Fri, 01 May 2026 13:33:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777667582; cv=none;
        d=google.com; s=arc-20240605;
        b=klnO/NxK/VEFfVqAyH0fZR+pPNZuQvSsP2UofxAFUagIeIvsB6R6UODM/K/GSBFNBt
         cDUB+NDxt0EK8pEi0cB44xLE3TUNhKWyiqXevMjlc6EJqTRgCzk7GroLi6tWb0C9XNHg
         gioEvzueqm0lP8TR48ExONVAQ4CD6VMKe5SsLkz4kYI7UGX9OVzKfP1llWDDybE79dZV
         Rn5ANTt0+RcbQ96ek0RDoANYq7UNpOL4nlIFGNIzBTkmKlluRWKSfL8iC/XDw9RMxteQ
         53NNUBjPnblK/VBd1ZwlH2aAednzr+Xqdfwtvc6qkLx270u3SuFXPA3xxbiyVylx9Ok0
         Gb/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=T/OAl8KInoHXQ6AvflVqniFa5LdHznYgc+Fi8xE6mQY=;
        fh=gU6Zhk6NS5p2DOu2jjdUTVNiySUf1k9g7BWmoBBWBm0=;
        b=SwqR5jAonSptKdo8qstX0ahXDbRuhUFETi5BWlSsdCqhCnmiSixOj0qPgz7yB7LwFP
         9wK95W8/BWCusmj8IyJ328SC+hRS7YbZDbAa7lKk4Z79qciwON2ZxkqMlFDfj/wfl9iz
         l1R963AeLxHCjS/2W78gRrCQRKFO77Pge5/21uALKmRfg3s5HzJdFXzggo1C6bHxor8g
         qxs9gW9BZkXo/aI5uYFbJXikSIERf5eIjIWCeV6TxWn5Hh+D9PkaTZh/tqr4hs9b3dPB
         z6lF2hC9En+LFbCsBVGFoZGR1djLsau8AyrranqC6Yr/pe67FW0v6o2qCbwL4/41aawQ
         eIzg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777667582; x=1778272382; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T/OAl8KInoHXQ6AvflVqniFa5LdHznYgc+Fi8xE6mQY=;
        b=OW8Kc4eIWaVeMJmrS9OhdB+vV5LS+eN1ch9/qVOej2H7dscfT5K0bMQpxP5/ISkApF
         W1BbsjKNBMCIY6mA3jhqcB4rJcoUoPj+OCtV2kIJBDKDsDUzeUlsTdwVaioKnwaWtSQT
         ADUED+H25cv3Nqd6p7hxwuHzs9EXt6PyeOt5nSvpgIOPrydtSkUNBoerMZaICuV9zjyN
         c8Ck43ypgmDmpIKH1NMwAS88Ur4RqoDcgkP+KtA2ovDL2iktY3y6v3jtZFEa6uVqf3We
         yLq3Z0Etm6rWDeO2T03B0Ys/QWh2/X+GZYf9H7Z8uE1BJLZa2IMOIwOBKnxHd3zvUPbe
         5Jcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777667582; x=1778272382;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T/OAl8KInoHXQ6AvflVqniFa5LdHznYgc+Fi8xE6mQY=;
        b=QLFi+U5pFQTwSbPwu+RBa8D0W3S0pso/zK4D/BjQknFKxhGF0JLflpXTmcbUFLu6Cg
         ZxP+cGGpMrZSAEI09LIpzygp2oChKW8sh0S6rpiHZ9xgFjmMXNVM/mQm2COuZAwCedby
         MNEkqrmJUo//ENIkx60PBbwqQuPBYwAYIw5l7g5g4L+l0TzjHqHhZr9rG2eudPH8Xu2/
         EXOTju+JIjeYxv/rnerLzWcQQEbE/KbxbkgA+bYewMinf6eI/P0UfUVNOZKMfkzbH4CS
         hXT+BW8dxG8XQWw0WJOU0M0a/p8rIEEMSFxo6RG8es/iQazSFvkWGzKcEd98omkffzrn
         AgbA==
X-Forwarded-Encrypted: i=1; AFNElJ+qAQZ2fK+Q9xLahY7BJi8HCii3UPmgHbswIPlyMipUaDyzQj/sWY/4RcNtsXh4gAaWEckUAKuGtA==@kvack.org
X-Gm-Message-State: AOJu0Yw3vprc6c9dk3i+wYKXXN7BHkO8kD6+fpK1JIPvrivtT3sX6Hfi
	eACaQlAvRrptHTfUoUlUy+pizEM+l3zAogyxhSOvgKa65MvPvld0jen2mxIdBAatRUkOpYDrcDa
	/Ib3mNCoXFzvmAKyYqWfr/kMgi5Zj2VBWOZmQv6OXk+CGMSdx4qme1kn+Ol0=
X-Gm-Gg: AeBDietQglypy/owaqwPFUZrpnK7raIY6aC6sGxfS2vxFWE51a3tNcsR78iejYuWKoU
	jpIGYxHgWEIZoWaP00YdVeSX0B87RidK81fkrwYJQOV52D1+6i8RNYMLIkNC/B0XI7clAvn37zh
	u3icUjgIh02bKPsPPwDAIIEQeKWa06yE3j0ZIgf/x3jitG0ej7WRWkgrQ0z3zsi4jL7teEu6MTi
	jWCo50GVX57g+/bivpYDbUFJIK1jXRytYiOSSWcJWgd53FvLjf+ELp2FiXKSE6QJ0SPOqxFmfM7
	lYdFOt+DYqhjE7wrBeagbv73tsFZMHzORcaTXQ==
X-Received: by 2002:a05:622a:255:b0:501:4eae:dbfc with SMTP id
 d75a77b69052e-510730d9e07mr604771cf.5.1777667580942; Fri, 01 May 2026
 13:33:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260430020226.34116-1-hao.ge@linux.dev>
In-Reply-To: <20260430020226.34116-1-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 1 May 2026 13:32:48 -0700
X-Gm-Features: AVHnY4JLImLgQWhmqNG8AyEb21pXwCehtL0cxv5914ZVwEinsgoy_Jv7jPFujkw
Message-ID: <CAJuCfpHme8UfSft9FbX50UcmuPQNhBVhG4K6=hbDud12z+VbGQ@mail.gmail.com>
Subject: Re: [PATCH v4] mm/alloc_tag: replace fixed-size early PFN array with
 dynamic linked list
To: Hao Ge <hao.ge@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C6CD4A000B
X-Stat-Signature: 6d8y3ndiyabf8emh6k5qkmjppxgiwk53
X-Rspam-User: 
X-HE-Tag: 1777667582-981241
X-HE-Meta: U2FsdGVkX19N8Mp6EsL5CmPjbEUzGfLBZHqQFLPBaUg21NFYdZmTP/m/4BAoZlPJF3XqX2awrkZm9EQ3z4YO0Oro0j6mKj8ZQix0zEOFMDfAQa9x6bK9zfu7JLZ6JcTK2B1PWbB1OUcL3jUK2XF6K3+LJgGepKAXvkbuF8RUEkEm8M7bSLJDxTQ2mB7o8gwTY2zz6GDtGfPvOIpqut73AWHYNrgiz05PFPSlxVDXzjNR/D6yqXjD+e8CBQJZVJQlOGhGSGvulTi/W131Vre4gpb+9Wgqbs+M9YPP2zI0m3xeMbeodDvB/nNZvXlWlzoVx0+IE6nfhJWV5msBq7nlpTP/ah55qz9AHPr/MOghrX9zRTpSO1FUgugS87oJ9b977ZCZxHIK8IlHZFcvaZ6rZkZ2OTJqo4OZtVcILYnYzP0nFQnjg12tGyeC50StscgfzP2V9KCH5ILXj939ItZhilesRHStvOJ7rEpNQjHvokozWqTu9yetFR004LVT9q+tUI9QkhjZGXLhG92Gp3GCXzZiRqB5WikMI1u3V2gAhOToXq8KAi5XbgfevhpLhRqwp4Bay2iS2qERKbuLQbt3XMfhO+xc1C8W91QWvaxkfHEkpxpbGRhWfYew5vjZ+oboH10Gu0UEvfY7vbIf0or10gfz6i4InGQ8RGP51eYl35UA1z2ulxSP4R+h/cqXAeuAIzVpX0Zy8CUBg8TNLFT0bAtcTYESGLFY7uZZxnWXi09nC+Vr0oa/qbD1R9LOrF3ctL3JUWMonh2PgncIMWTnCwg0M2t3sSAFUXWjLL25O65UzFlLGsTaqOVjgGibx6gbA4xC4eSAn1Z3SzF0bXnEwlimVa6bN30Owe89olCWz9xGF/7asWU3Kf8s8UeY0QWAUGgBYtyQF0ze14+w/bTQWG+QLqviqddZ235ciVriHOXZIeDWhYPH9Yn53tbKbyZ25O/R4gvhfiRRybE4jjB
 /paQkO7z
 Kgn8k5TNrC2B0+tQhPrHZPJRN2d7fu0NaCPbH2pHju4XpEubb7JFV3OOE0PjEWJDWX0d93QM+Kdy/Lf6h7GSulyj3iuMTko5ZCi1DtUEuvQPAkaBfB4YLd/VvntdFABFF1RraMtW01MgXhONujbc0GPLqP5jfWWBBFbvvnlytmLD9cKTgbx8Crq+2ydGVsUEKuDm4YJHVCcTsVsrSm+5slIF2HEs6XJucjX7udW+aMcH5i7LyugYMV49ipIyICfyDBvw3JSYUgq+rk5tqCmdJCkEV13tUqM9nPwH7kqNVILe9kXdA8sxqe8g7cVjWrXjlYZXdfoXMOJbC499Qateuc3okhD9pkd2dBorXCAL6BG6ounRZImdCiTggMUZgunY1bIJeoKANO3P7N50=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 7:03=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Pages allocated before page_ext is available have their codetag left
> uninitialized. Track these early PFNs and clear their codetag in
> clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
> warnings when they are freed later.
>
> Currently a fixed-size array of 8192 entries is used, with a warning if
> the limit is exceeded. However, the number of early allocations depends
> on the number of CPUs and can be larger than 8192.
>
> Replace the fixed-size array with a dynamically allocated linked list
> of pfn_pool structs. Each node is allocated via alloc_page() and mapped
> to a pfn_pool containing a next pointer, an atomic slot counter, and a
> PFN array that fills the remainder of the page.
>
> The tracking pages themselves are allocated via alloc_page(), which
> would trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and
> recurse indefinitely. Introduce __GFP_NO_CODETAG (reuses the
> %__GFP_NO_OBJ_EXT bit) and pass gfp_flags through pgalloc_tag_add()
> so that the early path can skip recording allocations that carry this
> flag.
>
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

One nit below, otherwise LGTM.
From Sashiko's findings:
- I believe page_ext is initialized before slabs, so aliasing
__GFP_NO_CODETAG to __GFP_NO_OBJ_EXT I think is fine.
- Masking out GFP_ZONEMASK during the page allocation sounds reasonable to =
me.
Thanks!

> ---
> v4:
> - Use struct pfn_pool with named fields (next, atomic_t count, pfns[]) ma=
pped
>   onto the page body, replacing the page->lru/page->private approach
>   (suggested by Suren Baghdasaryan)
>
> v3:
> - Simplify linked list: use page->lru for chaining and page->private as
>   slot counter, removing the early_pfn_node struct and freelist (suggeste=
d
>   by Suren Baghdasaryan)
> - Pass gfp_flags through alloc_tag_add_early_pfn() but strip
>   __GFP_DIRECT_RECLAIM instead of selecting GFP_KERNEL/GFP_ATOMIC,
>   because __alloc_tag_add_early_pfn() is invoked under rcu_read_lock().
>
> v2:
> - Use cmpxchg to atomically update early_pfn_pages, preventing page leak =
under concurrent allocation
> - Pass gfp_flags through the full call chain and use gfpflags_allow_block=
ing()
>   to select GFP_KERNEL vs GFP_ATOMIC, avoiding unnecessary GFP_ATOMIC in =
process context
> ---
>  include/linux/alloc_tag.h |   4 +-
>  lib/alloc_tag.c           | 145 ++++++++++++++++++++++++--------------
>  mm/page_alloc.c           |  12 ++--
>  3 files changed, 101 insertions(+), 60 deletions(-)
>
> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> index 02de2ede560f..068ba2e77c5d 100644
> --- a/include/linux/alloc_tag.h
> +++ b/include/linux/alloc_tag.h
> @@ -163,11 +163,11 @@ static inline void alloc_tag_sub_check(union codeta=
g_ref *ref)
>  {
>         WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
>  }
> -void alloc_tag_add_early_pfn(unsigned long pfn);
> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags);
>  #else
>  static inline void alloc_tag_add_check(union codetag_ref *ref, struct al=
loc_tag *tag) {}
>  static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
> -static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
> +static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_=
flags) {}
>  #endif
>
>  /* Caller should verify both ref and tag to be valid */
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index ed1bdcf1f8ab..117f14e7654b 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -767,60 +767,95 @@ static __init bool need_page_alloc_tagging(void)
>   * their codetag uninitialized. Track these early PFNs so we can clear
>   * their codetag refs later to avoid warnings when they are freed.
>   *
> - * Early allocations include:
> - *   - Base allocations independent of CPU count
> - *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_init,
> - *     such as trace ring buffers, scheduler per-cpu data)
> - *
> - * For simplicity, we fix the size to 8192.
> - * If insufficient, a warning will be triggered to alert the user.
> + * Each page is cast to a pfn_pool: the first few bytes hold metadata
> + * (next pointer and slot count), the remainder stores PFNs.
> + */
> +struct pfn_pool {
> +       struct pfn_pool *next;
> +       atomic_t count;
> +       unsigned long pfns[];
> +};
> +
> +#define PFN_POOL_SIZE                  ((PAGE_SIZE - offsetof(struct pfn=
_pool, pfns)) / \
> +                                        sizeof(unsigned long))
> +
> +/*
> + * Skip early PFN recording for a page allocation.  Reuses the
> + * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avoid
> + * recursion when allocating pages for the early PFN tracking list
> + * itself.
>   *
> - * TODO: Replace fixed-size array with dynamic allocation using
> - * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
> + * Codetags of the pages allocated with __GFP_NO_CODETAG should be
> + * cleared (via clear_page_tag_ref()) before freeing the pages to preven=
t
> + * alloc_tag_sub_check() from triggering a warning.
>   */
> -#define EARLY_ALLOC_PFN_MAX            8192
> +#define __GFP_NO_CODETAG               __GFP_NO_OBJ_EXT
>
> -static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
> -static atomic_t early_pfn_count __initdata =3D ATOMIC_INIT(0);
> +static struct pfn_pool *current_pfn_pool __initdata;
>
> -static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
> +static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gf=
p_flags)
>  {
> -       int old_idx, new_idx;
> +       struct pfn_pool *pool;
> +       int idx;
>
>         do {
> -               old_idx =3D atomic_read(&early_pfn_count);
> -               if (old_idx >=3D EARLY_ALLOC_PFN_MAX) {
> -                       pr_warn_once("Early page allocations before page_=
ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
> -                                     EARLY_ALLOC_PFN_MAX);
> -                       return;
> +               pool =3D READ_ONCE(current_pfn_pool);
> +               if (!pool || atomic_read(&pool->count) >=3D PFN_POOL_SIZE=
) {
> +                       gfp_t gfp =3D gfp_flags & ~__GFP_DIRECT_RECLAIM;
> +                       struct page *new_page =3D alloc_page(gfp | __GFP_=
NO_CODETAG);
> +                       struct pfn_pool *new;
> +
> +                       if (!new_page) {
> +                               pr_warn_once("early PFN tracking page all=
ocation failed\n");
> +                               return;
> +                       }
> +                       new =3D page_address(new_page);
> +                       new->next =3D pool;
> +                       atomic_set(&new->count, 0);
> +                       if (cmpxchg(&current_pfn_pool, pool, new) !=3D po=
ol) {
> +                               clear_page_tag_ref(new_page);
> +                               __free_page(new_page);
> +                               continue;
> +                       }
> +                       pool =3D new;
>                 }
> -               new_idx =3D old_idx + 1;
> -       } while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx)=
);
> +               idx =3D atomic_read(&pool->count);
> +               if (idx >=3D PFN_POOL_SIZE)
> +                       continue;
> +               if (atomic_cmpxchg(&pool->count, idx, idx + 1) =3D=3D idx=
)
> +                       break;
> +       } while (1);
>
> -       early_pfns[old_idx] =3D pfn;
> +       pool->pfns[idx] =3D pfn;
>  }
>
> -typedef void alloc_tag_add_func(unsigned long pfn);
> +typedef void alloc_tag_add_func(unsigned long pfn, gfp_t gfp_flags);
>  static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
=3D
>         RCU_INITIALIZER(__alloc_tag_add_early_pfn);
>
> -void alloc_tag_add_early_pfn(unsigned long pfn)
> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
>  {
>         alloc_tag_add_func *alloc_tag_add;
>
>         if (static_key_enabled(&mem_profiling_compressed))
>                 return;
>
> +       /* Skip allocations for the tracking list itself to avoid recursi=
on. */
> +       if (gfp_flags & __GFP_NO_CODETAG)
> +               return;
> +
>         rcu_read_lock();
>         alloc_tag_add =3D rcu_dereference(alloc_tag_add_early_pfn_ptr);
>         if (alloc_tag_add)
> -               alloc_tag_add(pfn);
> +               alloc_tag_add(pfn, gfp_flags);
>         rcu_read_unlock();
>  }
>
>  static void __init clear_early_alloc_pfn_tag_refs(void)
>  {
> -       unsigned int i;
> +       struct pfn_pool *pool, *next;
> +       struct page *page;
> +       int i;
>
>         if (static_key_enabled(&mem_profiling_compressed))
>                 return;
> @@ -829,37 +864,43 @@ static void __init clear_early_alloc_pfn_tag_refs(v=
oid)
>         /* Make sure we are not racing with __alloc_tag_add_early_pfn() *=
/
>         synchronize_rcu();
>
> -       for (i =3D 0; i < atomic_read(&early_pfn_count); i++) {
> -               unsigned long pfn =3D early_pfns[i];
> -
> -               if (pfn_valid(pfn)) {
> -                       struct page *page =3D pfn_to_page(pfn);
> -                       union pgtag_ref_handle handle;
> -                       union codetag_ref ref;
> -
> -                       if (get_page_tag_ref(page, &ref, &handle)) {
> -                               /*
> -                                * An early-allocated page could be freed=
 and reallocated
> -                                * after its page_ext is initialized but =
before we clear it.
> -                                * In that case, it already has a valid t=
ag set.
> -                                * We should not overwrite that valid tag=
 with CODETAG_EMPTY.
> -                                *
> -                                * Note: there is still a small race wind=
ow between checking
> -                                * ref.ct and calling set_codetag_empty()=
. We accept this
> -                                * race as it's unlikely and the extra co=
mplexity of atomic
> -                                * cmpxchg is not worth it for this debug=
-only code path.
> -                                */
> -                               if (ref.ct) {
> +       for (pool =3D current_pfn_pool; pool; pool =3D next) {
> +               for (i =3D 0; i < atomic_read(&pool->count); i++) {

I believe at this point pool->count can't change, so loop does not
need to re-read its value on each iteration. Better to read it before
the loop and thet used the cached value.

> +                       unsigned long pfn =3D pool->pfns[i];
> +
> +                       if (pfn_valid(pfn)) {
> +                               union pgtag_ref_handle handle;
> +                               union codetag_ref ref;
> +
> +                               if (get_page_tag_ref(pfn_to_page(pfn), &r=
ef, &handle)) {
> +                                       /*
> +                                        * An early-allocated page could =
be freed and reallocated
> +                                        * after its page_ext is initiali=
zed but before we clear it.
> +                                        * In that case, it already has a=
 valid tag set.
> +                                        * We should not overwrite that v=
alid tag
> +                                        * with CODETAG_EMPTY.
> +                                        *
> +                                        * Note: there is still a small r=
ace window between checking
> +                                        * ref.ct and calling set_codetag=
_empty(). We accept this
> +                                        * race as it's unlikely and the =
extra complexity of atomic
> +                                        * cmpxchg is not worth it for th=
is debug-only code path.
> +                                        */
> +                                       if (ref.ct) {
> +                                               put_page_tag_ref(handle);
> +                                               continue;
> +                                       }
> +
> +                                       set_codetag_empty(&ref);
> +                                       update_page_tag_ref(handle, &ref)=
;
>                                         put_page_tag_ref(handle);
> -                                       continue;
>                                 }
> -
> -                               set_codetag_empty(&ref);
> -                               update_page_tag_ref(handle, &ref);
> -                               put_page_tag_ref(handle);
>                         }
>                 }
>
> +               next =3D pool->next;
> +               page =3D virt_to_page(pool);
> +               clear_page_tag_ref(page);
> +               __free_page(page);
>         }
>  }
>  #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 04494bc2e46f..819d44ffd470 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1284,7 +1284,7 @@ void __clear_page_tag_ref(struct page *page)
>  /* Should be called only if mem_alloc_profiling_enabled() */
>  static noinline
>  void __pgalloc_tag_add(struct page *page, struct task_struct *task,
> -                      unsigned int nr)
> +                      unsigned int nr, gfp_t gfp_flags)
>  {
>         union pgtag_ref_handle handle;
>         union codetag_ref ref;
> @@ -1298,17 +1298,17 @@ void __pgalloc_tag_add(struct page *page, struct =
task_struct *task,
>                  * page_ext is not available yet, record the pfn so we ca=
n
>                  * clear the tag ref later when page_ext is initialized.
>                  */
> -               alloc_tag_add_early_pfn(page_to_pfn(page));
> +               alloc_tag_add_early_pfn(page_to_pfn(page), gfp_flags);
>                 if (task->alloc_tag)
>                         alloc_tag_set_inaccurate(task->alloc_tag);
>         }
>  }
>
>  static inline void pgalloc_tag_add(struct page *page, struct task_struct=
 *task,
> -                                  unsigned int nr)
> +                                  unsigned int nr, gfp_t gfp_flags)
>  {
>         if (mem_alloc_profiling_enabled())
> -               __pgalloc_tag_add(page, task, nr);
> +               __pgalloc_tag_add(page, task, nr, gfp_flags);
>  }
>
>  /* Should be called only if mem_alloc_profiling_enabled() */
> @@ -1341,7 +1341,7 @@ static inline void pgalloc_tag_sub_pages(struct all=
oc_tag *tag, unsigned int nr)
>  #else /* CONFIG_MEM_ALLOC_PROFILING */
>
>  static inline void pgalloc_tag_add(struct page *page, struct task_struct=
 *task,
> -                                  unsigned int nr) {}
> +                                  unsigned int nr, gfp_t gfp_flags) {}
>  static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {=
}
>  static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned=
 int nr) {}
>
> @@ -1896,7 +1896,7 @@ inline void post_alloc_hook(struct page *page, unsi=
gned int order,
>
>         set_page_owner(page, order, gfp_flags);
>         page_table_check_alloc(page, order);
> -       pgalloc_tag_add(page, current, 1 << order);
> +       pgalloc_tag_add(page, current, 1 << order, gfp_flags);
>  }
>
>  static void prep_new_page(struct page *page, unsigned int order, gfp_t g=
fp_flags,
> --
> 2.25.1
>

