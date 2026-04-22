Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34870FA1FD6
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 17:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117606B0088; Wed, 22 Apr 2026 13:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0C86B008A; Wed, 22 Apr 2026 13:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83DC6B008C; Wed, 22 Apr 2026 13:33:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF02B6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 13:33:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 322441602A7
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 17:33:07 +0000 (UTC)
X-FDA: 84686887614.25.88C3289
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id 344FBC000A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 17:33:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cjyirwr1;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776879185; a=rsa-sha256;
	cv=pass;
	b=rJ27ZRpKoLtcWv0OJfzDhkdx9S24cyC+NjxzWcbwSFXP83uWB0+kT59Z0IE6zYu0G08CkU
	S+4oApOzlmbynUXjZoBtvch1NzHDzZRZETm6e8eV4HAGQTTxqotxXHlasTQzrW6vf6T7Ot
	RlRSbxNB4vcyevMhrDjst7FirOEUx8Q=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cjyirwr1;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776879185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8K4mf41CHRsbFuSj2AYheGrWVLooDWd66PVqdv4d81Q=;
	b=QKgOUzY/XCCsMO3GfQlGhfjP/6W7q8AEKzOhz/jN16xVYAjFTmYLoTKlTW7A4UdpEWNbiR
	bwrgsf0lTMuNO6iwnnGRV8ufYemmYzD76FYHnD6vJwpyv3jE0TLwXYYxujXdiJqU2VCqEi
	9wiZP1Mb3Mhk13Ei003zdqCVhQz8Jm0=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50d836552daso3155371cf.0
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:33:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776879184; cv=none;
        d=google.com; s=arc-20240605;
        b=XvqZQZFaOE0IfdCnkW7BZ0vYzJzNDnyUrzFn0ODNwnsky8GX0jjF82q8rqtgxOH9S8
         An3rCfBy8fQCXHutLxe5OSCUb7JQihucFLpby6uc0Jf2RTf7MHFwjxNhWAsq2jIhq59C
         CsUiYbpx7FR2hF/owwpxVz9dYpwvJbOcbo/erXeBAcJD2oYEQ2befXpa5mMxruoFJX1T
         dqBK0BSXUwpqpehTa4bjHskwrlbmMpfurOdxp19BSs8+QgIvNDxiyMFIkeXngCNArUDH
         ygXEjB2KnFAWyCLMHGX6XUT6wy8i51ZsFyMYWB0J78JC6GICKWFdWx6LmvERIsM7z7o7
         LM6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8K4mf41CHRsbFuSj2AYheGrWVLooDWd66PVqdv4d81Q=;
        fh=GsKbNu5lnMp/b6+z8kQ2cMrclGr2NujDAzdVx8jBshI=;
        b=iJ8dghP5zvOo2y9GaG7BEhdjwpSyVN1WrIx0CI8FXvDuBZZhe2Do7i2txBoh+jbzZN
         zIIVT7GjdTDT4XZcsukqJnQwjejuFoTXaGvPc2FTQFggUVoNy2A8rihnp7gWCF0NCwfe
         PWNJrDysJUwxu1n5YLDxHar3Grxu2cQH1BtffEBjNhC3lIwyNmQW3A9sLnCKc/SV8t88
         LK+x5c7KY6qUVFur3NvMauhitr1aESOzGMa3kHLK2Jx7T4FL2e8kuf6wDUPFMGSg43bQ
         l2+rkNHZ+98XzDsuKY/g8f2X4FFh6KjkFvQu8r2GyC2yP9AaVfipV8TMquB2sq8so7vq
         HLbA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776879184; x=1777483984; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8K4mf41CHRsbFuSj2AYheGrWVLooDWd66PVqdv4d81Q=;
        b=cjyirwr126oWIwy3qZxdcF4mI9IspWd+blAneZnmqcH/8NZQfdksj0zuyhVQcKlNsX
         4K5vGNIcY//RiNwH+iqC0KSm2uxP28F3DpOScSNhrdAbEiZR18xtyfkqBESd+nnRBq27
         9ZS6eNsw8TK/bwNpu/ER3rvLd28JFvWGxzu9s3m4v5lhXLUpD5vsbMbWuuOWIWGmcPB3
         ra2zcD+aiNc2EnPP4TZIyUiVd0Lb09OevWmYrCAQOiNKBq+ZTkJM9Dlo71ySl8spxCpn
         GHfa1x4+YCCBDHjH16a9nv+Q9HGnUv9ImIEuSuPGH3yk3VZ7b6KYNPQywg+Uha0zlWO7
         6Sog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776879184; x=1777483984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8K4mf41CHRsbFuSj2AYheGrWVLooDWd66PVqdv4d81Q=;
        b=KQAWvAt3YrHkLXlcipXehP1SXr0ewcAW0TBxBMPtDBaiAuuFXS3YpjQTaJwUkn29sn
         a5CXYh/dmx5BhHQqRvFIZt5fKHvCJYC3LLRuVTkjdxyG420MwRkkZCdHg9AdAxFQtnj7
         JYta4HVIqkrrtSTn/E5vXo4EdvWwa9sRCGEKkCuEo5fsuRy6zEpTfjShGUbQIzn4ioND
         DXVQpdp1luNeEI9C1LPIEh2q1VrmeeyWGYNYcIQkfFPYDuVG1h9dzaJogaJ4qjRKz8fC
         u/Jq07ZF236j/XObec0dpt0ZBozpT4zDm5FfYdiBtOztQYqJy7lJERNY19395fS554Bk
         7KNA==
X-Forwarded-Encrypted: i=1; AFNElJ+oTJFbSV+ynp6S1earoTc4YWofrOuglcCD5z6YnrXkLdEBZ4q6bh+OUG2F5lpFvt/Z+xMnNAG11g==@kvack.org
X-Gm-Message-State: AOJu0Yxh/zBIr8C5exUAWPZHfp7WQXj0l8032vNnOsy479x+vYOMcX9b
	0qr4O9sr8K07GAabDT12sASu5QpQmn1N87OEHl514l2scG5Y9NJdvPr8lJ2YHpvsDa5GvPmb6Fz
	0PWm6mSx8n06W+qziS6/bYLdlio3FLa+1Yh3MersfYa/dRUdCaptEGnd9aRY=
X-Gm-Gg: AeBDieuSQaTyH+DvCSx1z9q4csA6SQg49X7QouEhMTyZYdunzc7aMAa/y66jP+dVhDI
	0QQO+ot15JvfisEeymaned8yjc9vExwJ6K5rniCmQcbWxHn4irw1DHxh1/uXmTjyocWuchZwPof
	NpLdvaCbNITwW/LuI7aLFsSf75KTUwJMGvt3CaZr6YB5jSPi+YJLz3c1HmRdOWn/FPVuYJP5Z9v
	bVfGnsbKwC1+afVG7wqIMd4L97l9v28UosTLQC9YcHYYT5fKYW4jRGV/DdUSM8T07kOBVzPZQ9t
	vGS7DJCU22lh7FI1csl3rcW6nbmK4VlUdn2jLCWuc6wys+2YciXyviB8msU=
X-Received: by 2002:ac8:5d50:0:b0:50e:6189:cd29 with SMTP id
 d75a77b69052e-50e6189d107mr23895521cf.11.1776879183446; Wed, 22 Apr 2026
 10:33:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260421031406.1189000-1-hao.ge@linux.dev>
In-Reply-To: <20260421031406.1189000-1-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 22 Apr 2026 10:32:51 -0700
X-Gm-Features: AQROBzBdB7meqL8-k5LXUgdRLrN5YpeMK1Niu1ewJvbeWZTvEkOJnjcJ-Qbjbe8
Message-ID: <CAJuCfpHvCODeKG1y3Ndte9immkW6cUzqsaduOozSEhDv17x82w@mail.gmail.com>
Subject: Re: [PATCH v2] mm/alloc_tag: replace fixed-size early PFN array with
 dynamic linked list
To: Hao Ge <hao.ge@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 344FBC000A
X-Rspamd-Server: rspam12
X-Stat-Signature: i58sfajhdzf9gj3pkx3w9iq5a1oteniy
X-Rspam-User: 
X-HE-Tag: 1776879185-431378
X-HE-Meta: U2FsdGVkX18D/2bj90+ezZEHu/Kg+BrzNAImE1glNyAGSij3QyfOFOgKJ9zc9NSDjYgmxlvgiqfm4KYnDsK5sMU3tMMYtg4yVTkzcwQ6H9Ua3PUA7NHOb+NA73T1anlz8JQ839wnTr4CUP9TZJ1l7azA+9QkAZxaKjYKLDcJ0svwfFKbOl8fUBJitZSu0RWVAGDRZATDQrF0lcn7e6o0jjok1ZvtDbCe+yKtrrWVg3/zoVUUToFMqlhLOR6J7rb0tgy371mbeyqU70HuHzaxciG3GjnNYhRTbrMysY0dCVEw6BHsemT6L9TszBvC4QgX0AsWGrf2kfE2sDiLx6Ttrg/aIC5SFO3cbADAVmUgwk5NoGwff7biF9bcYbcZe3gNFB/nPhxR219IxB47y5h/V5GoeplO5rnhuKaQOAmq91Ijkrm6mKgftqVaMxg9WTD4ga/8TiDBsiL8IskBWJMlEIyuTzp7hCYYzh8I08Qi7ucughbBi+/pvOcLT7nGfzBre9dr99QEocLlLC8c4s/0UlakupNfVLf7x3rJdQNt36XV7zWTA5a/czXYIPxfZBviNUiv6xTc2+5oDknovP4X1apnuz5xJ4VUpNSpa/cL/27Nd6l5pIkKZo64yQLKbtN5tZNAqcHam/KJi2CUUanobFNxzmL1xqB6ygz6wPEgpS1Pi7BqDeTXnnC/g8INu/n4p2rZbdbra4H8D1UaFh29xZaex+Wtp8Tbx3WRJQfazlwwYn/SDJbs5cNS4ZHgKkINa69LerLNQkbMYSq9mia1Q0oIzp2rbbb9MRiakFpy2C39Fosx0GKZ3094zIS2jqvJW+iaGSiMQbn188stTs6BD2uv24qNrftI27o2vvRu6OFZcXBccvCV0AlqDhY4SkeIYr7TFG7P3cV1yo9KYgzch8nNlsPuUc8N4LvsdRcz7LQH/Omp+UU0xbVlgYZQL7ARmjyLvJvO5N+M9rKKAkm
 Qmkn6vfx
 G/OYTWUWFRZfgmo6qRsCkI9WrsmvrbsAXsjIGfRGKey9v55lHgLoViKjU0wH2Nfb1esROTlGF4zVnZhENCMnz7mhSNqyoYYDrSXVE8FI1YDTt9TjHiiE0irkCsDO4flXupON8QHNlLbu3eZFe0e9anfMrVDKBFxbDiUteMTPqZD5has8a24n5iNl97QENYVp0B82dK8aDTdWnON2q/x7LzjVsz01nYW4Fa7hGCEE22Pxgw0zRhoWGi+JywbFVTw8Hl+Szku6lDs5QqlbNtuKI74p8hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 8:15=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
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
> Replace the fixed-size array with a dynamically allocated linked list.
> Each page is carved into early_pfn_node entries and the remainder is
> kept as a freelist for subsequent allocations.
>
> The list nodes themselves are allocated via alloc_page(), which would
> trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() ->
> alloc_early_pfn_node() and recurse indefinitely.  Introduce
> __GFP_NO_CODETAG (reuses the %__GFP_NO_OBJ_EXT bit) and pass
> gfp_flags through pgalloc_tag_add() so that the early path can skip
> recording allocations that carry this flag.

Hi Hao,
Thanks for following up on this!

>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
> v2:
> - Use cmpxchg to atomically update early_pfn_pages, preventing page leak =
under concurrent allocation
> - Pass gfp_flags through the full call chain and use gfpflags_allow_block=
ing()
>   to select GFP_KERNEL vs GFP_ATOMIC, avoiding unnecessary GFP_ATOMIC in =
process context
> ---
>  include/linux/alloc_tag.h |  22 +++++++-
>  lib/alloc_tag.c           | 102 ++++++++++++++++++++++++++------------
>  mm/page_alloc.c           |  29 +++++++----
>  3 files changed, 108 insertions(+), 45 deletions(-)
>
> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> index 02de2ede560f..2fa695bd3c53 100644
> --- a/include/linux/alloc_tag.h
> +++ b/include/linux/alloc_tag.h
> @@ -150,6 +150,23 @@ static inline struct alloc_tag_counters alloc_tag_re=
ad(struct alloc_tag *tag)
>  }
>
>  #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> +/*
> + * Skip early PFN recording for a page allocation.  Reuses the
> + * %__GFP_NO_OBJ_EXT bit.  Used by alloc_early_pfn_node() to avoid
> + * recursion when allocating pages for the early PFN tracking list
> + * itself.
> + *
> + * Callers must set the codetag to CODETAG_EMPTY (via
> + * clear_page_tag_ref()) before freeing pages allocated with this
> + * flag once page_ext becomes available, otherwise
> + * alloc_tag_sub_check() will trigger a warning.
> + */
> +#define __GFP_NO_CODETAG       __GFP_NO_OBJ_EXT
> +
> +static inline bool should_record_early_pfn(gfp_t gfp_flags)
> +{
> +       return !(gfp_flags & __GFP_NO_CODETAG);
> +}
>  static inline void alloc_tag_add_check(union codetag_ref *ref, struct al=
loc_tag *tag)
>  {
>         WARN_ONCE(ref && ref->ct && !is_codetag_empty(ref),
> @@ -163,11 +180,12 @@ static inline void alloc_tag_sub_check(union codeta=
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
> +static inline bool should_record_early_pfn(gfp_t gfp_flags) { return tru=
e; }


If CONFIG_MEM_ALLOC_PROFILING_DEBUG=3Dn why should we record early pfns?

>  #endif
>
>  /* Caller should verify both ref and tag to be valid */
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index ed1bdcf1f8ab..cfc68e397eba 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -766,45 +766,75 @@ static __init bool need_page_alloc_tagging(void)
>   * Some pages are allocated before page_ext becomes available, leaving
>   * their codetag uninitialized. Track these early PFNs so we can clear
>   * their codetag refs later to avoid warnings when they are freed.
> - *
> - * Early allocations include:
> - *   - Base allocations independent of CPU count
> - *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_init,
> - *     such as trace ring buffers, scheduler per-cpu data)
> - *
> - * For simplicity, we fix the size to 8192.
> - * If insufficient, a warning will be triggered to alert the user.
> - *
> - * TODO: Replace fixed-size array with dynamic allocation using
> - * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
>   */
> -#define EARLY_ALLOC_PFN_MAX            8192
> +struct early_pfn_node {
> +       struct early_pfn_node   *next;
> +       unsigned long           pfn;
> +};
> +
> +#define NODES_PER_PAGE         (PAGE_SIZE / sizeof(struct early_pfn_node=
))
>
> -static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
> -static atomic_t early_pfn_count __initdata =3D ATOMIC_INIT(0);
> +static struct early_pfn_node *early_pfn_list __initdata;
> +static struct early_pfn_node *early_pfn_freelist __initdata;
> +static struct page *early_pfn_pages __initdata;

This early_pfn_node linked list seems overly complex. Why not just
allocate a page and use page->lru to place it into a linked list? I
think the code will end up much simpler.

>
> -static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
> +static struct early_pfn_node *__init alloc_early_pfn_node(gfp_t gfp_flag=
s)
>  {
> -       int old_idx, new_idx;
> +       struct early_pfn_node *ep, *new;
> +       struct page *page, *old_page;
> +       gfp_t gfp =3D gfpflags_allow_blocking(gfp_flags) ? GFP_KERNEL : G=
FP_ATOMIC;
> +       int i;
> +
> +retry:
> +       ep =3D READ_ONCE(early_pfn_freelist);
> +       if (ep) {
> +               struct early_pfn_node *next =3D READ_ONCE(ep->next);
> +
> +               if (try_cmpxchg(&early_pfn_freelist, &ep, next))
> +                       return ep;
> +               goto retry;
> +       }
> +
> +       page =3D alloc_page(gfp | __GFP_NO_CODETAG | __GFP_ZERO);
> +       if (!page)
> +               return NULL;
> +
> +       new =3D page_address(page);
> +       for (i =3D 0; i < NODES_PER_PAGE - 1; i++)
> +               new[i].next =3D &new[i + 1];
> +       new[NODES_PER_PAGE - 1].next =3D NULL;
> +
> +       if (cmpxchg(&early_pfn_freelist, NULL, new + 1)) {
> +               __free_page(page);
> +               goto retry;
> +       }
>
>         do {
> -               old_idx =3D atomic_read(&early_pfn_count);
> -               if (old_idx >=3D EARLY_ALLOC_PFN_MAX) {
> -                       pr_warn_once("Early page allocations before page_=
ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
> -                                     EARLY_ALLOC_PFN_MAX);
> -                       return;
> -               }
> -               new_idx =3D old_idx + 1;
> -       } while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx)=
);
> +               old_page =3D READ_ONCE(early_pfn_pages);
> +               page->private =3D (unsigned long)old_page;
> +       } while (cmpxchg(&early_pfn_pages, old_page, page) !=3D old_page)=
;

I don't think this whole lockless schema is worth the complexity.
alloc_early_pfn_node() is called only during early init and is called
perhaps a few hundred times in total. Why not use a simple spinlock to
synchronize this operation and be done with it?

> +
> +       return new;
> +}
> +
> +static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gf=
p_flags)
> +{
> +       struct early_pfn_node *ep =3D alloc_early_pfn_node(gfp_flags);
>
> -       early_pfns[old_idx] =3D pfn;
> +       if (!ep)
> +               return;
> +
> +       ep->pfn =3D pfn;
> +       do {
> +               ep->next =3D READ_ONCE(early_pfn_list);
> +       } while (!try_cmpxchg(&early_pfn_list, &ep->next, ep));
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
> @@ -814,13 +844,14 @@ void alloc_tag_add_early_pfn(unsigned long pfn)
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
> +       struct early_pfn_node *ep;
> +       struct page *page, *next;
>
>         if (static_key_enabled(&mem_profiling_compressed))
>                 return;
> @@ -829,14 +860,13 @@ static void __init clear_early_alloc_pfn_tag_refs(v=
oid)
>         /* Make sure we are not racing with __alloc_tag_add_early_pfn() *=
/
>         synchronize_rcu();
>
> -       for (i =3D 0; i < atomic_read(&early_pfn_count); i++) {
> -               unsigned long pfn =3D early_pfns[i];
> +       for (ep =3D early_pfn_list; ep; ep =3D ep->next) {
>
> -               if (pfn_valid(pfn)) {
> -                       struct page *page =3D pfn_to_page(pfn);
> +               if (pfn_valid(ep->pfn)) {
>                         union pgtag_ref_handle handle;
>                         union codetag_ref ref;
>
> +                       page =3D pfn_to_page(ep->pfn);
>                         if (get_page_tag_ref(page, &ref, &handle)) {
>                                 /*
>                                  * An early-allocated page could be freed=
 and reallocated
> @@ -861,6 +891,12 @@ static void __init clear_early_alloc_pfn_tag_refs(vo=
id)
>                 }
>
>         }
> +
> +       for (page =3D early_pfn_pages; page; page =3D next) {
> +               next =3D (struct page *)page->private;
> +               clear_page_tag_ref(page);
> +               __free_page(page);
> +       }
>  }
>  #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
>  static inline void __init clear_early_alloc_pfn_tag_refs(void) {}
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 04494bc2e46f..4e2bfb3714e1 100644
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
> @@ -1294,21 +1294,30 @@ void __pgalloc_tag_add(struct page *page, struct =
task_struct *task,
>                 update_page_tag_ref(handle, &ref);
>                 put_page_tag_ref(handle);
>         } else {
> -               /*
> -                * page_ext is not available yet, record the pfn so we ca=
n
> -                * clear the tag ref later when page_ext is initialized.
> -                */
> -               alloc_tag_add_early_pfn(page_to_pfn(page));
> +
>                 if (task->alloc_tag)
>                         alloc_tag_set_inaccurate(task->alloc_tag);
> +
> +               /*
> +                * page_ext is not available yet, skip if this allocation
> +                * doesn't need early PFN recording.
> +                */
> +               if (unlikely(!should_record_early_pfn(gfp_flags)))
> +                       return;
> +
> +               /*
> +                * Record the pfn so the tag ref can be cleared later
> +                * when page_ext is initialized.
> +                */
> +               alloc_tag_add_early_pfn(page_to_pfn(page), gfp_flags);

nit: This seems shorter and more readable:

               if (unlikely(should_record_early_pfn(gfp_flags)))
                            alloc_tag_add_early_pfn(page_to_pfn(page),
gfp_flags);

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
> @@ -1341,7 +1350,7 @@ static inline void pgalloc_tag_sub_pages(struct all=
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
> @@ -1896,7 +1905,7 @@ inline void post_alloc_hook(struct page *page, unsi=
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

