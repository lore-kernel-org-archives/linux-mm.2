Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C215CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 23:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8D268E000A; Mon, 15 Sep 2025 19:05:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3CC98E0001; Mon, 15 Sep 2025 19:05:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92C2A8E000A; Mon, 15 Sep 2025 19:05:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 78C878E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:05:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D43613BB5B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:05:58 +0000 (UTC)
X-FDA: 83893019196.17.6B07C2E
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 534CA80004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:05:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GuXhxa4J;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757977556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1qJ1ywJEbaE9nq0ko+s0hyX1ZObpOzS9ljbjORUd/zM=;
	b=fUh6kp/Lu2i7qELRXXxLitr2/a8hOahWhyBfYD5DNWRdhO9UExX14yXgHB0sTaDMU0OLUv
	XYKILvWIk/KzDNXs3Dua+YJoVyRVACPFqtJul8RgV1UVmOwD3J6+M2Nth7AxPRXx1psIw1
	4bhizzxIQ+MotXwmqul332qQVJAZmeY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757977556; a=rsa-sha256;
	cv=none;
	b=E3tKCAUNGxA/aDXe8ogCmTN0aZw6QjL1bxbbFFAQyZ19EgPinqLNE1QQWEXFjJiq76umGU
	0aTEP35rbeSJ5NUhsyV6HwjB+CuCH+eq6lP8K8LNS9qf6xoT/p0FGvvoytr+MkKLhpv+HK
	GgLvgoAtkNZ50VLML5E6pWNjVpKy8Qk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GuXhxa4J;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b4bcb9638aso103041cf.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757977555; x=1758582355; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1qJ1ywJEbaE9nq0ko+s0hyX1ZObpOzS9ljbjORUd/zM=;
        b=GuXhxa4JlZG/WleE11mAtuJmktXpnJAunrteubfJiPgMNWQL384bLnixQP5weNmdQm
         ZwUrvTUNXTHpQJMMcWLpsa4z26eTxYrfzuM7uzPIqWBplYDaM4SyscFAIYziHDPLpfeK
         LyHiGclsg2Pl7j5b4I8kdOSOxuQ9R9v67OMCzeLhbFhhX9qum+XBZLxEoJIkv6xOijow
         gqWceg1D3cHUfbMaCX+/tD4ITfUlWLzZBTYAxocipNaJb9ZAfOPht8UFQKS81IcuycSK
         DvM6zgCFv3Zf0lWGOXq9FYmDEu6uAv4oQ3rTSMur9uU6/UKboljGKH+0BBgQ2IMbzCfy
         3TUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757977555; x=1758582355;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1qJ1ywJEbaE9nq0ko+s0hyX1ZObpOzS9ljbjORUd/zM=;
        b=hggpbdF2ipJtV5B7uBG6B2uP3ms1noPzmQ0oN3bF/h7uVtKZm7+q7ClbfRrg5GuxtY
         +V7hx2teGDHUKwEOl6o6bva42TWeN+5rtIGlvE1AvNZlHcT4I2eFeQRm8TSpzMtwVgqo
         oD6aPhlBSH2iuPKdJ9bThbXLYICZJFV4dJri9wka3Arvj/E2MMf4yWbvyGtx5najzeZR
         pLOqHl5Wup08wcYuyrNHTPxd0Jch6srk+fIKFoxAT5VhQTFnzvTnxyLLauAR2t/K+ggV
         e2IbXFq6C9hTMvduoYlKy3kwEfeMwDD+wDQFxQFUIzRqIGC0wJmFXDXWqsHyctrdTPaT
         TVAA==
X-Forwarded-Encrypted: i=1; AJvYcCUm0dUh58cvd9j6lqgFvgHF0ItyiUvsbWEeacRyVFJphfkDPx1mgLhMXgDxaGgzam/WsbpnG2doHg==@kvack.org
X-Gm-Message-State: AOJu0YzXAEwnrZKgiNPh7RHa6p3puMAQ6wf7l/4kFGFMBxmO2Ex3wS4K
	bAqhpU+BXlTZq/wMsODX2T+SpnZTHmr3/wbh8+VrBTcuI3XiFp9F9QQC8Eep7QI7R8HxQi0kg/A
	9mFjTt77tU4KxFVceUqWEfZzspTo4YFniQvD9ZKwT
X-Gm-Gg: ASbGncvtl9rPuw0E+U47A4weObSzjzw8sT2yZg3N4KwviQVcjpLuiV4LTZ+ZuAAJnH7
	V/num40jt7o/xXPpXF/zWaOcDf1kQBPlJ69YBOLFX4sJbZsekNN9k9hZGpVFxWFUtadsAANwlAJ
	+oVipqrlIbuNaPyx0oDi89AtOI6jM7NTrh9CEBct0clCcEc4c2KVIJmkPgZW5ONfKdzMr8qRYxl
	kGcQmQrbMClRO8P7QEiTAkEcHGHvHQLOD2ci+4Dqkrx
X-Google-Smtp-Source: AGHT+IGSDw4q7zvyhHz8jYY09WOelxKBRgvxIUR/b2xOqj3hs370yTlQ5WcBbmIrTt+w0VFq+mNlMcQ7e+FO0tWkJok=
X-Received: by 2002:a05:622a:1a1a:b0:4b7:9e3a:3804 with SMTP id
 d75a77b69052e-4b7b1ceb2ebmr2609391cf.16.1757977554914; Mon, 15 Sep 2025
 16:05:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250915230224.4115531-1-surenb@google.com>
In-Reply-To: <20250915230224.4115531-1-surenb@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 15 Sep 2025 16:05:43 -0700
X-Gm-Features: AS18NWD6T-GfGYPt0XH871IgorUw9EfNUMGDUoO7LTR6UK84OFYT0bzZ_WbKkwg
Message-ID: <CAJuCfpG+Vp8w0ZuEbdxKEcG2YurYCij=7BrekDPtJwW9rFegjQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pyyjason@gmail.com, pasha.tatashin@soleen.com, souravpanda@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: dk5riuqirh54ghnkh1as767uxo8i1uwx
X-Rspamd-Queue-Id: 534CA80004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757977556-735299
X-HE-Meta: U2FsdGVkX1+/6z0lbrC8Arfl7oOTxu3ROywwo4Qu4MsGTa4Tt9LHaqScdAdtH0Xty7kHOyJVSPiTDEmDERjwbfgL/FGGdk7tc2JmlkCEmU3nsgkqe5lrjAMk8qu2ZuV5xR7S+3l/QaC9G1QKAUmZ4yhRAy19ymf5mmsLn8niJLrjABvjo37qG1VAXPY9nMVv7g+i+VdU3wXysQo+IBx0u5oI7KWIwqXnWZGH70EyeIUjylB59FyOnNaN+kYDlcV3/1DYMxeKW7XCrt+ARBJ4nQ4eGSLQbrTKoox14Y+RLzhl8G2dw1xbrVzzZ1+wxxpRbWYh1QsmNbomCU4gba8PGiJzYUV4Buu/FTxi/m/irXLg3KkYJ9auwFzg6uaQJ/SBLbJ7XcmrYe+KUXh0T6oUz8jxM/VQ6i2W0bZYFrOG3Hsq5+CkkBC58pinXWfmQ0lZoCILHpwKTtBd1R9jtCIUpJdIjZHEujvharp1K/jFfOY1drmmp1Nfrmf55QNBv3RYqLjBrPrmPd6FnRPLywcP3tRqZmz5QmphJRNPFg9R3PDLniTceVjlKA0KgLyUtM0s1Oh9jyQY0VkpyB21Yu17FeHizdDT4gkrSIakQyuH1+9O8+AaDPaJQAvtZB7YidRXuoKBtBeik+vx110HL3mRxB03zDdea9wajPhi0xM0w9W6VQjhVRjX0g1X9aoYhQXaoaXxjmmG8U4OM/iKMfmj1J3zYJvwUQU3FI2du+g8XhRGO4hcmqiMPA4QHfecGcjauAqE2oX5q1JEXpalhT8IDcxapGBuJ8U+P5fpdUwFR+9DN1Tplc+XKyVafDfcQkkN47GFHgiUUuDo9FoPBVm4xzbYwrc6S/w+7IGQN4X8tuqxD5wTDOlfl5xrv2kt37T/agHGjmG8nJRlVOZTK+rRwneEK1lKk3y9UKpY8A/zkYxbdUS+EZYMKz7dBurOsYHYZK+YpNF3XV/M6x9OX4u
 BY19Pnrd
 Dh8Aq7LMnWfSL+D9uyugJc3pj+i1cg/mlYVGGHfAM5aQIZUolrVYUGM5WnoKp18Ssuo6jG7oJO8VY4ntllCf0W6OFeiTdidxk8h6yXCJaYkNGo4Ma5GAniwWB62PSd5R2XuMqmxG7gj/ouvJ83N3Ah39OvkEomMRqBdneqv56aexrjzpa/CuFw0W11joZknIWrhWRZ41l8SpZQhBeoBBe6tQF72gsn00yZsGwzpUHEd34YyzGGVgNj3Y9JcUfkh1ZUhp08zsWGLxrspfEoWHwMS9E3Gp8+M108/KzdefNjqFnjIapsXEAMK+dQYRG7REl8NUkYLD0Z+tyq4LfShLDbzPEFZWG1JAmItTVT9UbQVHyKdpWjfCiuvIIQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 4:02=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> While rare, memory allocation profiling can contain inaccurate counters
> if slab object extension vector allocation fails. That allocation might
> succeed later but prior to that, slab allocations that would have used
> that object extension vector will not be accounted for. To indicate
> incorrect counters, "accurate:no" marker is appended to the call site
> line in the /proc/allocinfo output.
> Bump up /proc/allocinfo version to reflect the change in the file format
> and update documentation.
>
> Example output with invalid counters:
> allocinfo - version: 2.0
>            0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_da=
ta_nodes
>            0        0 arch/x86/kernel/alternative.c:2090 func:alternative=
s_smp_module_add
>            0        0 arch/x86/kernel/alternative.c:127 func:__its_alloc =
accurate:no
>            0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_se=
t
>            0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_real=
loc
>            0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_enab=
le_hybrid_capacity_scale
>            0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:in=
it_amd_l3_attrs
>        49152       48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device=
_create accurate:no
>        32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_gen_=
pool_create
>            0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_thresho=
ld_create_device
>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Acked-by: Usama Arif <usamaarif642@gmail.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
> Changes since v1[1]:
> - Changed the marker from asterisk to accurate:no pair, per Andrew Morton
> - Documented /proc/allocinfo v2 format
> - Update the changelog
> - Added Acked-by from v2 since the functionality is the same,
> per Shakeel Butt, Usama Arif and Johannes Weiner


Sorry, forgot the --base=3Dauto when formatting the patch. It's based on mm=
-new.

>
> [1] https://lore.kernel.org/all/20250909234942.1104356-1-surenb@google.co=
m/
>
>  Documentation/filesystems/proc.rst |  4 ++++
>  include/linux/alloc_tag.h          | 12 ++++++++++++
>  include/linux/codetag.h            |  5 ++++-
>  lib/alloc_tag.c                    |  4 +++-
>  mm/slub.c                          |  2 ++
>  5 files changed, 25 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesyste=
ms/proc.rst
> index 915a3e44bc12..1776a06571c2 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -1009,6 +1009,10 @@ number, module (if originates from a loadable modu=
le) and the function calling
>  the allocation. The number of bytes allocated and number of calls at eac=
h
>  location are reported. The first line indicates the version of the file,=
 the
>  second line is the header listing fields in the file.
> +If file version is 2.0 or higher then each line may contain additional
> +<key>:<value> pairs representing extra information about the call site.
> +For example if the counters are not accurate, the line will be appended =
with
> +"accurate:no" pair.
>
>  Example output.
>
> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> index 9ef2633e2c08..d40ac39bfbe8 100644
> --- a/include/linux/alloc_tag.h
> +++ b/include/linux/alloc_tag.h
> @@ -221,6 +221,16 @@ static inline void alloc_tag_sub(union codetag_ref *=
ref, size_t bytes)
>         ref->ct =3D NULL;
>  }
>
> +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
> +{
> +       tag->ct.flags |=3D CODETAG_FLAG_INACCURATE;
> +}
> +
> +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
> +{
> +       return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
> +}
> +
>  #define alloc_tag_record(p)    ((p) =3D current->alloc_tag)
>
>  #else /* CONFIG_MEM_ALLOC_PROFILING */
> @@ -230,6 +240,8 @@ static inline bool mem_alloc_profiling_enabled(void) =
{ return false; }
>  static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_ta=
g *tag,
>                                  size_t bytes) {}
>  static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {=
}
> +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag) {}
> +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag) { retu=
rn false; }
>  #define alloc_tag_record(p)    do {} while (0)
>
>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> index 457ed8fd3214..8ea2a5f7c98a 100644
> --- a/include/linux/codetag.h
> +++ b/include/linux/codetag.h
> @@ -16,13 +16,16 @@ struct module;
>  #define CODETAG_SECTION_START_PREFIX   "__start_"
>  #define CODETAG_SECTION_STOP_PREFIX    "__stop_"
>
> +/* codetag flags */
> +#define CODETAG_FLAG_INACCURATE        (1 << 0)
> +
>  /*
>   * An instance of this structure is created in a special ELF section at =
every
>   * code location being tagged.  At runtime, the special section is treat=
ed as
>   * an array of these.
>   */
>  struct codetag {
> -       unsigned int flags; /* used in later patches */
> +       unsigned int flags;
>         unsigned int lineno;
>         const char *modname;
>         const char *function;
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index 79891528e7b6..12ff80bbbd22 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -80,7 +80,7 @@ static void allocinfo_stop(struct seq_file *m, void *ar=
g)
>  static void print_allocinfo_header(struct seq_buf *buf)
>  {
>         /* Output format version, so we can change it. */
> -       seq_buf_printf(buf, "allocinfo - version: 1.0\n");
> +       seq_buf_printf(buf, "allocinfo - version: 2.0\n");
>         seq_buf_printf(buf, "#     <size>  <calls> <tag info>\n");
>  }
>
> @@ -92,6 +92,8 @@ static void alloc_tag_to_text(struct seq_buf *out, stru=
ct codetag *ct)
>
>         seq_buf_printf(out, "%12lli %8llu ", bytes, counter.calls);
>         codetag_to_text(out, ct);
> +       if (unlikely(alloc_tag_is_inaccurate(tag)))
> +               seq_buf_printf(out, " accurate:no");
>         seq_buf_putc(out, ' ');
>         seq_buf_putc(out, '\n');
>  }
> diff --git a/mm/slub.c b/mm/slub.c
> index af343ca570b5..9c04f29ee8de 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2143,6 +2143,8 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *=
s, void *object, gfp_t flags)
>          */
>         if (likely(obj_exts))
>                 alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size=
);
> +       else
> +               alloc_tag_set_inaccurate(current->alloc_tag);
>  }
>
>  static inline void
> --
> 2.51.0.384.g4c02a37b29-goog
>

