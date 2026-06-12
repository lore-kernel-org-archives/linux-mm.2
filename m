Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F280CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 07:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 708D56B008C; Fri, 12 Jun 2026 03:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B92E6B0092; Fri, 12 Jun 2026 03:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8606B0096; Fri, 12 Jun 2026 03:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C0D36B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:35:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EBE721C2DF3
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:35:19 +0000 (UTC)
X-FDA: 84870449958.27.4455795
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id ED98514000A
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:35:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ESlshKT7;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of glider@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781249718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g1vLF6yuNSQgtVfJ+k2uIVqLmlvQ2f0shING6YSG4gg=;
	b=cy/B8mqcNJAcEq9/0cBgDRbiBB5in6WEQwz1QSxbV7ziQtbKAJZUr8QSdOMsttlRiNraNy
	VzknqWWVuLNSisgUXwho0BCzGOJSV5gqQSF72xO5s9x2Hymtsikl858chWA1gbuXFJIjsa
	1v+CK6b8VUzF3ucTMHvjFlCtE+O3lV8=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ESlshKT7;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of glider@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781249718;
	b=f+SB4Mac7RRlR2/cTuYCOOfIl/c/S072oDe/hjoTUxWY+UIRHbP1vsU9eAI5XthWi9WzeZ
	rfii7EQlmBNqD3neI8CCIOPd5KsirywhdYQ3Fnr6YHLzzAWOQc9I/JMPApky948WM9hT0y
	uPO4tZr4cxuVO5y3ncNGeBuHs/V/DQA=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-7dc93d02916so6430987b3.3
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:35:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781249717; cv=none;
        d=google.com; s=arc-20240605;
        b=V2O0cmh/Lkw9tc8k9J/XCekfo74hVXnxQnCTZwPTwcANvjNco72ERgR7gCtACPnYqX
         JFMkp5hwo2AdFYVuAFcWea4U2rZ/gOYrX8oHOPniVj38nqWfUI9k/cfHzb/isVCws3Um
         RKOEZfKcLCVjdbIbRY8i2ZLdP8j1ngJgM5feDVAPm5hT2wN9qb/hS2+WIdtVgx2/ahKC
         0TQjvMYk4cg55f3zgdHVRL8wVP0SlbcxTQHHFQK62xN0P4a6QGOh7WvQEgXv2V3qKNDp
         JVUxNPMAm8autSuE0/vGXOx62Io7pewFvWBiam3vEEBd3K73+hRsGCfRpPU7wDeVHFuR
         InTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g1vLF6yuNSQgtVfJ+k2uIVqLmlvQ2f0shING6YSG4gg=;
        fh=RgkPv2pJy3UuUFwOF32E9c5HM50YY7ZKfvL2+uRz9OQ=;
        b=X6umCw1xEs2EP2t6+iifhOrlvNaGQQnQaaqu7KtVWKc9kyvs0FszPLNeb4aCoJh9TR
         WJX9b/LjK1hI+Xh74zVmojkAG/42UG4NvvCJMTMwPTmfl2b69iSu+ZOAFePso4jPwPq/
         +5pKGapQhJhe4UUW91f+/F55o+mSEUCCNONQVeGrclLLaBLKpce7xuDvJ/QhFJTc2qRM
         IBF2kid/xsCIXXP3PZqHfYdUbI0FlW1YjauTHMAlltq7zZlP1b64yZrRzlKtwuxvvW6w
         6IZ8NVnmA4kWolyq5TqFYBFOdoGeKyFZ3ohEB8WgTDj72ZKKahSxwaEfPwjzQYMFAqFv
         l5QQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781249717; x=1781854517; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g1vLF6yuNSQgtVfJ+k2uIVqLmlvQ2f0shING6YSG4gg=;
        b=ESlshKT7gN/pYFS9LYBvOygyrj8720pmtLIguUql+DnxIBHBKOSZw4kOjj+VdfD8Qg
         T3u/vz0lNk9tmf0c/2XxCDcv3m6dzHl8MtSge+o65lebMEWkzOkXhsUpvJHOVJCtxWVk
         7T1NSJMHSw878xb77fuc3dm8FMQYlBD0m2ap34TCqZO4PkZE3hxvhX8590qkFU3oxmUP
         bdvEmhi+CTO6mGIiZ7whEPeB0prOyjVM6ik7yLbBtIL4iGxkosrKMkXUxvbRy27CDJLd
         JX3Uk+DqUYBIJBDDNfigta9d/qg3kKeJssCfkNYFZao7rLhr66MEwUJSNnf5vRKNfLfc
         3fiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781249717; x=1781854517;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g1vLF6yuNSQgtVfJ+k2uIVqLmlvQ2f0shING6YSG4gg=;
        b=hmqoH+X5/g1GXe90aEpsbOYBlh5JaTkuAd7SsBYOAnMzR6rOa0BxnQdxue/m/Lku74
         YfW72x3Co57pxdV+f/mRzNLCryZgZWw/ixByWGJdBKuzvB99QbOZafuBqh7SJ3CdwqmW
         nOqQmke3XFSte5IN43z36eIQ6obVuiEhfTd5/YWo6vIonRsLc5n9G5PpIfdxLwnsXbPE
         h2IHdBn/ObV/CAQjcEUM9kpWjk++pwW+qeN/3PNoLHOgD2jgObFcznWIcYtM6drROQh8
         QdfYzACc2UiqMIxZ9feP6GAuKepgCQSwrV/Rmm1jRJdfPWr71ntUuSXc6kxb//gmEuze
         braw==
X-Forwarded-Encrypted: i=1; AFNElJ/VJy2BCURksemRr2L9HoUj1gQpWX02UlPqGCua26kXWxZyroyvaqEOqhUwEFCnHirj24NfYRYL9Q==@kvack.org
X-Gm-Message-State: AOJu0YxN75rbWvB0JA5sQVkXxGBzzRmMYU+uXRdkeu9PnJrBlwSdPo0B
	GAzy67mkAnLCZWRREM7cnG1u9P2J6VE1K3wbrQ8JQqTWTBLXdF4wW1Lt5TWGflTswQhXtFV1zmD
	+cQBCD6yIUnAmnNjzBG5pIWYlBQ0F+j+0HQXhrzQJ
X-Gm-Gg: Acq92OHVVvWKvdAL+eJMOziYJf/3XsGmrqtR2WnrE7QTNRFGcJxQCEWvC5Ac/MBp/ak
	l/0T/uQX/OCYjiRvSj+R3wSq+hNXOfTJ/VceIZsBL3/WWEsNn0pckkZjoMhbkJ0oOzpnn2l1mtX
	mdKwI84R1pKbgbMukT0PqB0xR0mu8p4M2sExHdkhMDMwEpLYbCFqyqbAh6IcCREafBwgX7uNzYE
	6mACjbph2imd2EQABc7112MXEHXvFxgJCpe4e/nLcQPDCYIuyjjkROUJ95v961+gVOx6fGfUeCy
	93uxTmk10Z/BWQHgjcAtquHAy95k2XX6IeJGdQ==
X-Received: by 2002:a05:690c:4b0f:b0:7d1:c256:b5a8 with SMTP id
 00721157ae682-7f7b9020616mr15009847b3.40.1781249716383; Fri, 12 Jun 2026
 00:35:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260611-b4-kcov-dataflow-v2-v2-0-0a261da3987c@est.tech> <20260611-b4-kcov-dataflow-v2-v2-1-0a261da3987c@est.tech>
In-Reply-To: <20260611-b4-kcov-dataflow-v2-v2-1-0a261da3987c@est.tech>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 12 Jun 2026 09:34:31 +0200
X-Gm-Features: AVVi8Cfm4phss8ao3422B1w1tp_vYDP5PJUsvm_ZDGjV7MhrtYD94WvUDwrEe3M
Message-ID: <CAG_fn=WYdnX_09RNs3sTQWn+KZZaw+X9a=s1Uk1bqd3gW04h6Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 01/14] kcov: add per-task dataflow tracking for
 function arguments/return values
To: Yunseong Kim <yunseong.kim@est.tech>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, rust-for-linux@vger.kernel.org, 
	linux-kbuild@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, workflows@vger.kernel.org, 
	linux-doc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: ED98514000A
X-Stat-Signature: hrg83fjp14b74uwzf7z5ijs6j998ibb3
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781249717-128879
X-HE-Meta: U2FsdGVkX18d2gaGu7lHKtGRkAvU2AmzjyPByDyuPGcLm4dvyHu9GaOSmKzemM+iZB/t0/CZetf15aqwjv/N6ZKKpqBs8Gl9dNJOETduzK+vK0YvDgJILapMw16OI2c1TWV4bZeQbQeG4iaEF85Byo/CObWeOwdBUAxrNP2wWC+J9ToRoNHA8KyBPs3NZKYF94Cfb9q6tsH2bdCaLyqm13lBY/QpxFLXWMxMNw2mo6etjzXZxe+8KKPTScnvrUJ06hghNP26LrAB33DvsIJPRbOiWHCC7tNm4IMdAikXQD4yfgfQ+8XKKe3gs9LySAezUavsMDBjZcz6K1lCoxTcUnHdh0Oyxry1q72CvDmcMpvCGngKzWJXzJlJhFTlC2lrsKdMU3G9wjHkmhmFlnI5layXZ1Rx5/sQZR/65DFeFMMdrCMbqYqyKgv4SFFDzXRaqaaONpcnT8CUTdjI5+MrVG2UHFSFHkYn+UrU6gsc/Kv7t3L8erhv9t8vhws0W2PceSrzmX68MlCmBEvtED/j5Lg3dUzzi1kAhWQ+mVA2P8RbPmM2HR5RAbhyG89TXimDbnixLbvzbMLIXfe4uDef6ac2TDU+pDBo9ifV9z4hRt65k0FYoklEEHO/GAhGK9+EiH0ETBcBGMpkPbOSVqUtihvW2B3R7qc8ziNPTNXCfEmO5piqE+N3xx/URq5U4YdxgYDBgxTwtCo6bX1SdfiybgUcooQYbumDZToLfYB6Ih2b3k4oMec2SlmxCv1V/40x3Gf0vXfgrq0kOJHCE2FXTRa54ah7Xn2xz57BK3xt6KFaHXACpsdFBgAiyzb7tRGOClRagr7UgNquY3Xp4OGfF7ER4lnVP08wkdjVF8xwaVzy3zG3p52PQhUA473rpVdfahiIbMnNaBOwbECcOFJ9ydu7jhFzKbr/99/AzeIiGXeYcW/GDzKecn4SLB+ChFpkgyrIeElaO2LEhHxsYvP
 /wj+8yjK
 hn2uTu8b8/EQPYCFvL/PWDzlfbSzucDoUw5qG9iq7S0y9r2di2i9UcAIpD0Z0xWmlcw+ntt90OuEbIQpYhq0ed2dOpNpc0BHuAP03zdMwmgCsGdRpdNpRLndKMn4DE6ulLJ6wetNznJQsTgEF7mfKsWlcEqkWieWPR4iRs3JtgYdQEm9FgKfh+BTSYaQZYBa+SnAhXPUzeO9kVFcrmUzMkBwKIZBUtz6hZDMmL2oFV9WoBD0rKYJBOBOe1jGOyMbNfRAsR4d+0sSARuB7LMExmbKmXoL6dEJj48mZHSOo3YQ28m8ikjXOxKEOBCnS/doj5pR2DFQWGtTwhQuGR4nBFeKpafmBMJbjQzaueiI3PF+C1P5gIvuyGLGaXrUyrjSLvJJL0XfuailJMm6b8bva4gx/zoCQcWoPAM8BVVAc5Ggm1RwoBR7Xxt71V4DET4+QNEyk8NLxBSxssGgE0JBtGVsUtXgsaSTR7yQ9AZ1Xipc08MIWb064k4UXt8oyvSEcP6k9t2f4ZmBNwVCzcUYp8St36A8V2mgaySb5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 6:21=E2=80=AFPM Yunseong Kim <yunseong.kim@est.tech=
> wrote:
>
> Add a new tracking mechanism that captures function arguments/return
> values at instrumented function boundaries via submitted as an LLVM
> RFC SanitizerCoverage callbacks:
>
>   __sanitizer_cov_trace_args
>   __sanitizer_cov_trace_ret
>
> This requires a custom LLVM/Clang build with the trace-args/ret passes:
>
> LLVM RFC:
>
>   https://discourse.llvm.org/t/rfc-sanitizercoverage-add-fsanitize-covera=
ge-trace-args-trace-ret/91026
>
> LLVM PR:
>
>   https://github.com/llvm/llvm-project/pull/201410
>
> Clone and build toolchain:
>
>   git clone --recursive --depth 1 --shallow-submodules \
>     --jobs `nproc` https://github.com/yskzalloc/kcov-dataflow.git
>   cd kcov-dataflow
>
>   cd llvm-project
>   cmake -S llvm -B build -G Ninja \
>     -DCMAKE_BUILD_TYPE=3DRelease \
>     -DCMAKE_C_COMPILER=3Dclang \
>     -DCMAKE_CXX_COMPILER=3Dclang++ \
>     -DLLVM_ENABLE_LLD=3DON \
>     -DLLVM_ENABLE_PROJECTS=3D"clang;lld" \
>     -DLLVM_TARGETS_TO_BUILD=3D"X86;AArch64"
>   ninja -C build
>   cd ..
>
> Build and boot kernel (using virtme-ng):
>
>   export PATH=3D$PWD/llvm-project/build/bin:$PATH
>   cd linux
>   vng --build \
>     --configitem CONFIG_KCOV=3Dy \
>     --configitem CONFIG_KCOV_DATAFLOW_ARGS=3Dy \
>     --configitem CONFIG_KCOV_DATAFLOW_RET=3Dy \
>     --configitem CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL=3Dy \
>     --configitem CONFIG_DEBUG_INFO=3Dy \
>     --configitem CONFIG_RUST=3Dy # for rust module kselftest
>     LLVM=3D1 CC=3Dclang
>
> Core implementation in kernel/kcov_dataflow.c (separating from kcov.c
> as Alexander's request):
>   - Per-task lock-free ring buffer via debugfs kcov_dataflow device
>   - READ_ONCE/WRITE_ONCE atomic pattern (tested on arm64)
>   - copy_from_kernel_nofault() for safe struct field reads
>   - in_task() guard rejects interrupt context
>   - Bit-31 recursion guard prevents INSTRUMENT_ALL re-entry
>
> Build system (scripts/Makefile.kcov, scripts/Makefile.lib):
>   - CFLAGS_KCOV_DATAFLOW: -fsanitize-coverage=3Dtrace-args,trace-ret
>   - RUSTFLAGS_KCOV_DATAFLOW: -Cllvm-args=3D-sanitizer-coverage-trace-args=
/ret
>   - Per-file opt-in: KCOV_DATAFLOW_file.o :=3D y
>   - Respects KCOV_INSTRUMENT :=3D n for noinstr exclusion
>   - CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL for whole-kernel
>
> Kconfig (lib/Kconfig.debug):
>   - CONFIG_KCOV_DATAFLOW_ARGS / CONFIG_KCOV_DATAFLOW_RET
>   - Depends on CONFIG_KCOV and CONFIG_DEBUG_INFO
>   - CONFIG_KCOV_DATAFLOW_NO_INLINE (default n)
>   - CONFIG_KCOV_DATAFLOW_INSTRUMENT_ALL
>
> Also fix rust/kernel/str.rs unused import (flags::* -> flags::GFP_KERNEL)
> which newer rustc (1.98-nightly) rejects as a hard error.
>
> Rust support requires rustc built against the custom LLVM with
> trace-args/ret passes compiled in:
>
>   https://github.com/yskzalloc/rust
>
> Link: https://github.com/yskzalloc/kcov-dataflow/
> Cc: Alexander Potapenko <glider@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Nicolas Schier <nsc@kernel.org>
> Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
> ---
>  include/linux/sched.h  |  10 ++
>  kernel/Makefile        |   3 +
>  kernel/kcov.c          |   2 +
>  kernel/kcov_dataflow.c | 324 +++++++++++++++++++++++++++++++++++++++++++=
++++++

I think the total size of kcov_dataflow.c doesn't justify splitting it
in multiple patches.

