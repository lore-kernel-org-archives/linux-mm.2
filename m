Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EC92C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 17:05:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 248B36B008A; Tue,  8 Sep 2026 13:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FA216B008C; Tue,  8 Sep 2026 13:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8D86B0095; Tue,  8 Sep 2026 13:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B74BB6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:05:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CF28A065B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 17:05:32 +0000 (UTC)
X-FDA: 85191221304.04.2828873
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf09.hostedemail.com (Postfix) with ESMTP id 27620140008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 17:05:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cBRjHMid;
	spf=pass (imf09.hostedemail.com: domain of jannh@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788887130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t2BEbL6oK2TNdrl07S1eqJBu8muYQ4YhMI1yhqy/NuU=;
	b=p89LD8ig7dMWAZ5oNRuzAAooZ3dV+gZs9k7L7sfl6p9BiDd2F4U3QSx/Ijw14goRT2qHC6
	KSIkMDU3KDBBnmgUDSDW1Aq8tg9aS6T+WxS//OhW0CTsFww7C0CDum1v61XHTzpJyt7H0S
	Kv2Bazmd9enr4INvzC0zhp9SAIXQ8AQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cBRjHMid;
	spf=pass (imf09.hostedemail.com: domain of jannh@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788887130;
	b=aIw2OIinl7ZBeW0Y6z3YUsoVHkZVPkE9E0CqhRXgDuoogYxCwcxXCC970NYeQ9oZ5HvRv+
	Sn2+t340Qnp9P4dDAIClnYVbgLvJM49dQ8jfKBA7ypLYtQIQAcM1AEfYf3RWvVZQ4n2Ear
	pu5zWcHmrIYDJkiy2TgUnd0SkbcWXas=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2db425c9050so254855ad.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 10:05:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788887129; cv=none;
        d=google.com; s=arc-20260327;
        b=rwnkGbHvQ3wHYH9NVHS2xEuDvPp3WYoS/Mc7ZlLITL8/k46DQDEKy54wrEyBHKTVi1
         94a6lvuG0/fvEdmjuuJ2x3tMcJLyOM4eqBjIPVeUK7a//z6fW1kwMXSfcgBh8kRxFjPT
         3CDQmt9BPLhrI2n4ONWvKWXZfczOmVrzsAJ+DEFOaOBceRltpBAtkLJc0/H0PT8KinWI
         RXAhwXWdac5J6bV67b1UdRkDEj1KcCM6OCJCvxc9LCumMFW7v39+fWqQK2oFQ32V8UTu
         5SxgFbuC21yPXgKBb2vR2vlkra68JAyMn7o0FZ5gITLxHyVQdgLn11MoKrUQJeUJ94N0
         rBSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t2BEbL6oK2TNdrl07S1eqJBu8muYQ4YhMI1yhqy/NuU=;
        fh=e45Bk3iSpJAIBmtaWdr2CvjhsiM8Zq8yZboQhXhHwUo=;
        b=cVTItDcZzeoXCAEMLMjuIX3MEUuvhSzwPfmfl0NmE4t+ZTewwOa9uWAEKbNTW54Jk9
         oOXlu4JLgPykTwT4TDPl+VE7rmD8c1IPq54d1P8fNAGJq2lW5nXscMumnXBKlXjNblEP
         9Yg6kq7MMH8IbaCFrAeJiR1yVQaBYQ7vouj3zabfkv3nK5ZbjzB+qBpZadWeJA8YCX10
         Lh6MQooITKCZ+F5qMlU4mKYTyI4mUDan1IVznpfPCRlEMugZ1XhgoTL90TfV6LxkYo7g
         6LEsSA8uDfmYFyCVgjNfRQ2NFXWQ+D6JULsBezVKMy7XavaeSS9KS5cxRtzjOx3BiNd8
         2VCw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788887129; x=1789491929; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t2BEbL6oK2TNdrl07S1eqJBu8muYQ4YhMI1yhqy/NuU=;
        b=cBRjHMid/s4icgh+KMoKqgtn21XXWiTecVqMUcAYK9NqkbIEXT5jPa+6DBvZVbGBvg
         cSKgO2rOIQT91Awb745IJxHvL2hkXsTk+WgNPTkGf0LveXme0/323ToAAqp9FQm7tpeO
         BbjP7KdlM3nI9dhSyIYaWAIivkplSAdTM+WtmFpPMUVf8mHPoyjVqp01q8/oeMpQTwES
         dHXm6pthc8Kyz4ohlE6FcDKMPsjyDsKrp1atNC9RdIy2sn5c6r1y1AykX8piO3adjOxY
         6YKjycfgxNGG6L4DyQ60MqTjJVtvbRsx9tnlGYCbIRESH/dk5MZw+501UeRvYx8l5UJx
         KRrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788887129; x=1789491929;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t2BEbL6oK2TNdrl07S1eqJBu8muYQ4YhMI1yhqy/NuU=;
        b=huhSL8H9vv1W0HyI+H+OLY0fRQm42cOuHDhnni/yJgvwegsDAHfrMu/5nDcDPz2PD3
         8QcgtCo8eNQMtD+Pb3hbMjnpsNRvDj3X8fsc/p2hQbAcuPsEYAyiWQE6R0a/dnJ+aY2v
         Pj9xyzNz/P4aziNboh9HTgghdAhJC2ZPJnK1y8myEhAzgJrknxNWJIoSshbvRQaL3Wlg
         cWANNRRfSLkF4+pI/EtcvG80DK/Mtavf3ZpOUjL8g2QWZsmIxObtNWI0ukC+IP7jpcmG
         J2YO5q7envFCNG/FwtZWLqq6xNP+RXpKY928WSPJxVYOEYGcQ27viH/Lk8ZF1oe1a1q7
         78tw==
X-Forwarded-Encrypted: i=1; AKwUvBxxcgweQWrRFX6jujdJjVqeF9vDfGht75RD8Q+F0ZdaA3fhYnnN4xdG9l+A8TIw4OmSjiHGm+AxiA==@kvack.org
X-Gm-Message-State: AFuF++nNkJxFlj1WPWAtoFOGBMsOLTZzlB6GLhurYGRRdQvk572r27UN
	9VC0xm93UnjINnGTmpmtbe3EjLGMvglf3iabPUE4LXmE62aLUi6iWLQHkWXB78tSD3nFe5HSG9n
	LHv6KfdkMG0E59cCM2yDXQYGo2gvAwgOoz3IWDgZV
X-Gm-Gg: AYBFou2TBPgtF55K1bHfd+tCLUwxzZcxTgLUfIlT3SQD5kk+iZsZ/eqgmrs9RHSacw6
	l8+w8t4MPjmTVg/hdYKqEepUewk1mI4FgidKaitDR9j/HNmM6EWSnEZDp7V6o2XhymvJXddiRzT
	QcavdqmTA4oORqVAWamBlsnE/BwI2sx4h+FfqlFRUIUsO3ApQmgtC7NG81pGaJQtiEm9darK1e/
	uPGWDSZwTTr6/t9ynGz9xoDdplk8f4Cq5hfn0BChC4M4gmgwq2Y0iz7pjoZnS1iE0c4lhl05w1V
	fBGhkyIUgmAqhRcrhrfLnFdojPIeoorQTE5UmwlNdsA/icGSUNqZ5ZMQqn77twXPE0X+2y1EaQB
	gzdmpUWHKLuyoVXdKHaUZ8ZWT6Lvuu9E=
X-Received: by 2002:a17:903:26cc:b0:2d5:db3d:1a43 with SMTP id
 d9443c01a7336-2db28e87ca5mr17559255ad.16.1788887128208; Tue, 08 Sep 2026
 10:05:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260908-kcov-extrecord-v3-0-dcbc11593e88@google.com> <20260908-kcov-extrecord-v3-8-dcbc11593e88@google.com>
In-Reply-To: <20260908-kcov-extrecord-v3-8-dcbc11593e88@google.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 8 Sep 2026 19:04:50 +0200
X-Gm-Features: AcwNN1VvbLJASh_Ky3VRZJSD9T0ID1T_I_eVvcK3XtYNZ85Q5pJtmiWgBBKhAmI
Message-ID: <CAG48ez1ueO-rc+TKQZJoFuf0ingYR=E7s_exEDvOyE=CsDp7Ew@mail.gmail.com>
Subject: Re: [PATCH RFC v3 08/12] kcov: log freeing of SLUB objects and pages
To: Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Alexander Potapenko <glider@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, llvm@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 27620140008
X-Stat-Signature: qyxkyriu3iekwh46nsfyj4oj9e4nbeti
X-Rspam-User: 
X-HE-Tag: 1788887129-895578
X-HE-Meta: U2FsdGVkX192Ts7YzluihwxKUl7zx+g+yqefZp9O+JDJ/nZeGFP8DJQ0W4oOh4KOx1IE84hxX1OxAksEcF9pNAGmqAUykvG47UWl4Suup8UgmPNO7A+bgmDSUMERp7xE+3SCDjlq7Y8GlXv+Ushaxv9zKEzKnIfiaMEygihFB1mFtYeBvQ7ZOa9utkrCcf17kduAGNG7GWOPNy5dtTvXf/DtGxGKtk8XcomdpRQo7RrcI6ZDH9/7b4/Kx/ufG/TLYRpKlhJMHaV03U04bPuROv6J4+wPVRSctRSC4joAczXNXNuy9xptsm7rG39Tihfluj1b2ca4731AJtRjW6H6VgWMtFYmgCzd4vVt/BfNnurP0pQClBpEPiL+sCsxyFcDOWpBJGxndUxJnku5BYT2a54Qmn28PoKYh+a2YCCTEFxsW2EDTe0YO0TEFRNJGlTS827eS0qLUv1DftKPvm59vQ6pkh4vjGX2/vzOH7Qbi8LPe7dvIxguveRZUiQb+OB+888X07uDBdNIzepvSHnfazzBA/j11RDUD13F+T2mtHtM+WfUwV6jbC+SyUfRQWdWtvFdsNkKrdPrshiVkDH5zeMskkaTa3Z/9uY2OjH9H9hSkTuWBBDNMaUML69myyjUpBGA2GEMdks26ijY9f0tWMd/4kgHCrWUm8mpJB/Hj6GVlRIusqGsDISclzQGjMDvJdpYMvrGjBFoJjszWscN4Uek+AhiY3WPrzcKVFG+oZkN0Cz992z+vFklLwhExMunj7HToTbWA/dWC59cldGdANQy2CI5ga5KmmcxiI2np8hP29IxlDPakUgbkv3rl2IJgH6RzNCsfEqSmIoMvisQMSbvEC+dwHBW2zcduOzWqpsAO5WkxbuN0ikSR+SMVubCl2uGDBmEFlRVVtVc6Z3cjFqlPEVFAamcGdsMCtMd28kUEwKPpntm1Qr1m9nRaYhvgZkC0QmfMTYpiHjeVLa
 Fbhmp/dJ
 Rxjp0l5x+PlA1Y6gIJFem5dmjNoj6DOODf8wBjsKj6JsGzOdVjeeE8Kw1SDSckPaRrKCFp51MUtcaFjLQwZvsJ1mYYfud79JCa8nEGj8hcT9QDdBxX0LkPKIuW/IZ84K4/zj7b87MfqZeRzTC4xbyM5DTLG8C8JTbO9Tcj4TMrR2POnZJHg7kKs/XA/PX9GDzEl80uSu9hg1A6Ke4BqhiaCzOF8cL3fBIc8I9it4xU/9yiRDUzsJY+7wmcg6RmaJqm5Uhrd8ui5bv8FsoECg7U98R4P3vcN4IVQDWbo523scAmRHCg0y9ldgSBzdGiNN/8dz8oLfCjdrnkY5m1sFVonhF2ANZX+JVA75T0EeOTDy8Z62gisxNBKkLHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 8, 2026 at 6:55=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
> To help with using CONFIG_KCOV_MEMORY for detecting use-after-free issues=
,
> log when memory (SLUB objects or page allocations) is being freed.
>
> This should happen after KASAN has already marked the memory as freed;
> this will become important if we allow driving delay injection off this
> in the future.

Oops, I should include the page allocator and SLUB people on this one
patch in the series, since I'm adding a hook in their code.

> Signed-off-by: Jann Horn <jannh@google.com>
> ---
>  include/uapi/linux/kcov.h | 1 +
>  mm/kasan/common.c         | 2 ++
>  mm/page_alloc.c           | 3 +++
>  3 files changed, 6 insertions(+)
>
> diff --git a/include/uapi/linux/kcov.h b/include/uapi/linux/kcov.h
> index 7d7147e7b427..76822d1c119a 100644
> --- a/include/uapi/linux/kcov.h
> +++ b/include/uapi/linux/kcov.h
> @@ -90,6 +90,7 @@ static inline __u64 kcov_remote_handle(__u64 subsys, __=
u64 inst)
>  #define MEMORY_ACCESS_RECORD_WRITE 0x10
>  #define MEMORY_ACCESS_RECORD_RMW 0x20
>  #define MEMORY_ACCESS_RECORD_ATOMIC 0x40
> +#define MEMORY_ACCESS_RECORD_FREE 0x80
>  struct memory_access_record {
>         __aligned_u64 ip_address_and_kcov_flags;
>         __aligned_u64 data_address;
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index 1ab77ac9719c..3a648eaad024 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -283,6 +283,8 @@ bool __kasan_slab_free(struct kmem_cache *cache, void=
 *object, bool init,
>                 return false;
>
>         poison_slab_object(cache, object, init);
> +       _kcov_handle_memaccess(object, cache->object_size,
> +                                   MEMORY_ACCESS_RECORD_WRITE|MEMORY_ACC=
ESS_RECORD_FREE);
>
>         if (no_quarantine)
>                 return false;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 083cbcb5bdde..910d14925b84 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1446,6 +1446,9 @@ static __always_inline bool __free_pages_prepare(st=
ruct page *page,
>         if (init)
>                 clear_highpages_kasan_tagged(page, 1 << order);
>
> +       _kcov_handle_memaccess(page_address(page), (1 << order)*PAGE_SIZE=
,
> +                                   MEMORY_ACCESS_RECORD_WRITE|MEMORY_ACC=
ESS_RECORD_FREE);
> +
>         /*
>          * arch_free_page() can make the page's contents inaccessible.  s=
390
>          * does this.  So nothing which can access the page's contents sh=
ould
>
> --
> 2.55.0.979.g7e5102b832-goog
>

