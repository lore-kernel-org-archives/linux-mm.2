Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66C59C44512
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 06:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D71676B007B; Wed, 22 Jul 2026 02:50:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D22386B0088; Wed, 22 Jul 2026 02:50:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C13FE6B008A; Wed, 22 Jul 2026 02:50:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E2A56B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 02:50:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE83F1203C2
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:50:16 +0000 (UTC)
X-FDA: 85015488432.13.295CD0C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6573F20007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:50:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=COQpX6iK;
	spf=pass (imf03.hostedemail.com: domain of vmalik@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vmalik@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784703014;
	b=RXtXh5goinHiJYLHAlKNvdE7HfOp6kkLn9TZvWQ0X7A5BLPLevo1S7PwS96pxzciOloSq1
	EJsASXEJCTqxJuk507mbZnt8oWEX096bOoQCzXSzNIeTLcb9INodc35ZdaOlzapECe6sGg
	ykqprwTU31oi8tYLNc62y0koc2ghkb8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=COQpX6iK;
	spf=pass (imf03.hostedemail.com: domain of vmalik@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=vmalik@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784703014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3lBBnji54QsZ7LpKe0DZFU4BcF1aXn/MPUxyOzixsJo=;
	b=LS8w7eKzxaYJ4LFi+S8Cz/QBrK2wF9kFTom1A8HN7T68HX4qF/ahDVeIv2UcpRw8Swg7aW
	FIk1NPmjr0wFw5y8ChUVr4a6nbsvwe2Bhx5FsvfyrhQv3p/JlhiMp4/8TWSCXk2BdZ9tl6
	gC7xUiaI34F3TPiiZXf1CNo/MzMoCGg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784703013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3lBBnji54QsZ7LpKe0DZFU4BcF1aXn/MPUxyOzixsJo=;
	b=COQpX6iK1LwCR8XzLJq8x5c5NazcA5hizNW9pI5jdIfbOlNNq5tm2jEd2NTSkBgHrxgn5L
	IXlBow4fOcPI9T+SXQRnRCCcRzlTw6J9xQg9IfRzv5EqjEjtZJriOJrWSNFWr3pUKJq6Cw
	J9TBjR/9gFRzi1oaXuD46O9cdojN9n4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-279-MIAVsmThMiegU7aIuLiREw-1; Wed, 22 Jul 2026 02:50:11 -0400
X-MC-Unique: MIAVsmThMiegU7aIuLiREw-1
X-Mimecast-MFC-AGG-ID: MIAVsmThMiegU7aIuLiREw_1784703010
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4956c1655c3so1177405e9.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:50:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784703010; x=1785307810;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3lBBnji54QsZ7LpKe0DZFU4BcF1aXn/MPUxyOzixsJo=;
        b=InJuQeGvoFHjzu/Gy3gzxNoqJOmsQ66o73DB2J6pMH/mBhLEGG0IrAL1e6+qFGWtSL
         omdX3B6hnYsN87hkAkeq2IiQ8hsw0uFxL4V8vK3P02WpsvTJhGIPF/CdDieywbCzmas7
         0MHvzSTiO1pxz/xOL4S5/cyMdZ2Vhg/NegxpFbpSNTFEfexEQgg6yN6TQrUWUYKKWiLx
         TIaDKqh88lfijXVv8LcYg19KmsMsODDJCuHhJ98zfKp3B5ES4z4dbUfEHRLI9IHeG/Ik
         le8O22ZInKTZVa61ejD5ZTcC0s4RSL4u2ufsXDOQfe+4qbswYGFL6By8SwHIfRWsGa6O
         mTvQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq5PdrUaY4QYLsbPz8iMU28tzgXSmbeUyuNDd6g9ciCG6wns0kLwSbWLQWCxSXea2Sj+oKeTX/+Zw==@kvack.org
X-Gm-Message-State: AOJu0Yy4hrDLOxgRlvtrUbARkgOtAdjDLMET+v6SFQuG+w4NTJKBW4wS
	pTyFbUXX/d4ocHl/52hD1K7QDDAqunu1zK9o7Q/Zaxsc5Cbai2+vCO+QLKau2VsabLK54a0OgQs
	YPM7sQYrjL5JuOJxmcZfdyMfmzv6VKgmdErR+r008GpntskRKG84=
X-Gm-Gg: AR+sD1192HOhsO8RhnRCFi3gUBykKNWMTZbf5yRgLc1zdZlMn0nYRt2KIoi/unsvmBh
	w2WPpec16acx3cRlTy4ZLkc8thFsa7v+KQTc5zUWlMjcBYynRqAaURVBCob4g5+Hl6dpEwEu5fE
	pYGVhyx4dUOz5I4sYxxvhbaJWnEniAVocd9BcAslA2EQJhHDAcUuzkyYqgsCGPa8hIBXJ2xFqH1
	sWl6hTp7Ymg3XpyTIOVDFLMF5COc7Sd24rV0Tl1+mx7dsPXz7c4i61xwPU0uTZYyg/vjZelhJIA
	dlVUyboD1hvy35xsmt4ckcsmoCiF7ZwTHuzku7Pdr7Gv8DItCN1kf7lMdAw/CcIb
X-Received: by 2002:a05:600c:3589:b0:495:641a:fffe with SMTP id 5b1f17b1804b1-495641b01acmr102846855e9.39.1784703010362;
        Tue, 21 Jul 2026 23:50:10 -0700 (PDT)
X-Received: by 2002:a05:600c:3589:b0:495:641a:fffe with SMTP id 5b1f17b1804b1-495641b01acmr102846315e9.39.1784703009819;
        Tue, 21 Jul 2026 23:50:09 -0700 (PDT)
Received: from [10.43.17.109] ([213.175.37.14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495653c9d99sm126187325e9.12.2026.07.21.23.50.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 23:50:09 -0700 (PDT)
Message-ID: <f2a0db3b-ac66-4b29-9dff-a691d9464123@redhat.com>
Date: Wed, 22 Jul 2026 08:50:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] selftests: add shared lib.bpf.mk to build BPF
 progs and skeletons
To: Ziyang Men <ziyang.meme@gmail.com>, Shuah Khan <shuah@kernel.org>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Jiri Kosina <jikos@kernel.org>, Benjamin Tissoires <bentiss@kernel.org>,
 David Vernet <void@manifault.com>, Eduard Zingerman <eddyz87@gmail.com>
Cc: Andrea Righi <arighi@nvidia.com>, Changwoo Min <changwoo@igalia.com>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, JP Kobryn
 <inwardvessel@gmail.com>, Mykola Lysenko <mykolal@meta.com>,
 Nathan Chancellor <nathan@kernel.org>, linux-kselftest@vger.kernel.org,
 cgroups@vger.kernel.org, linux-input@vger.kernel.org,
 sched-ext@lists.linux.dev, linux-mm@kvack.org, kernel-team@meta.com,
 bpf@vger.kernel.org, llvm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260721174833.1232771-1-ziyang.meme@gmail.com>
 <20260721174833.1232771-2-ziyang.meme@gmail.com>
From: Viktor Malik <vmalik@redhat.com>
In-Reply-To: <20260721174833.1232771-2-ziyang.meme@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8hJNRYkceb6RC_2DYuMeMakMOMKcWpwvkmXcrRXv28I_1784703010
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 91z4godq4pu9uz5rfck99eoek8dihq5h
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6573F20007
X-Rspam-User: 
X-HE-Tag: 1784703014-604866
X-HE-Meta: U2FsdGVkX18XNwf6dmMmD9s+7iX0bwx7jZpGO10jl+MvRlC3yTwazPUdvUh3xb2/ABHdVkUgQuCpr2RMFJacu/uve0B49mhybozlr/WFqwwOnhA13RFdnjhy0u1V3CQujiEYkTeXN6Q40+3gzvptPuL3NxqKNLyOWDEE6L6gnkg1N9S7gBkwYp8w0dCEp+RcmHnoLryLvnzVKgdzMjXKgBcZYnc2Vmqpi+pkFqM3OHGaJE978pNVyxdjM4Z8LmfcfcdPe63qxw6LoxJofue6lun65ilLaSfeuujp2jTJ9xJplV6kOqv815JQ63q+81QV8RSH/ChlmEiakL7yYNj+pyjaxe113O9odDQ7s6BIVUjt8v0UAhZUd4AGhwzh/J4UvK4QSQeDdkc45yZAY7ARv3EkjwJlpjzYIHTe17XLtcrMzB9wIwiRz3GG/0OY8tMwK69jFR9R65a9i4HWGMotYe5NpD0RGWVumjgcv20vsiCgmWeWWrHjGpSAud87BmzuVwpVR7VFOGD18oTEt85rII/P0cMrD0zOO/QIKWhnjhUlf+b3mkv3zSWeKAEeD1pPNLszYIjzqvwUfHegsrynyehQiVipOBOWcphoRLL9SHNcmxZ297LiagcuAfTcB/sK8m13EHTWGk/2v+QZl2o405f0G2BWgT7Jm16q765kgkC3nlF84jKNKbF7bHvJuolabYySixYz0QgniwnO4SZBnJHLM/pxU5ZT/cLkWmUWL7AoFHUGvSFQ0rw6V47QcuQ9KTN9cG+jTYkoN0uf1cvCEb0b2HoUczehKAh/l5I+FnuyDkuIXw7U+43uny3KZfr4Ej4YQeQPvUV0S9DU2qqEHqemOKqqbO8F9yqc0j485kEaTBrCSSQoTN8s84U5XkdOKdDQoIfZWeI/NkZuOKZfbwIDxCPSlNLLHsyNV8ji6dmbi5f0fZdLj04PLWgmsIpeotxTJo9qrOc2AUZ70LT
 72kxpgUp
 HrRfsGN4R1pAy182p0bJuJxXEemeCBEpfkmGQ90eycspAlWIII1QagcY8tDtogrrlZwHmwxziO2LIA8Ts9Mr+05emQpeBM216cbL7UoMIxPE1Sb/5c6nhR6vo3FHr25Lmhs4F2+VbxOVBPH+7eVuwbDDuf4K2s6We8iYBIfcTOh3hkZPELaLfSpXzAU8iLK2ELYryIPkPk6Rzvy/of0GonbVlFmQc1SFPtT8m/feKvIugl1ts1mSjXcHY+oo8GOJ9gYYI3j4A28MQHbEDFPHvOhPqY2dsds7/KaHOOg2MmCb6NcYQlO7wb6fVTojEgFy3JqU/TgvC8gHvBAsyL541Q94n0ZfZv4CYOC55oQyStKjk/sL5ykjdVg16qghzTPQdIw4knqkTLF/v8J26SZR0nvaFA7pnmFb1MQJRaIB8Wy1FscRtmN/UkV23aCrLEhAOWOtMHJi+C79gN7jTD+z2fermM6YBnAN+7KHj3w+VIY3PR5jem+WRK8AVpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 19:48, Ziyang Men wrote:
> The libbpf + bpftool + vmlinux.h + BPF-object + skeleton build tool-chain
> is currently duplicated across tools/testing/selftests/{bpf,sched_ext,
> hid}/, each carrying ~100-140 lines of near-identical Makefile.  As more
> subsystems grow BPF-based selftests, the duplication scales poorly.
> 
> Add tools/testing/selftests/lib.bpf.mk, a single includable fragment that
> provides the whole chain end-to-end. It builds the in-tree libbpf.a and a
> host bpftool, generates vmlinux.h from the kernel's BTF, compiles *.bpf.c
> into BPF objects (clang --target=bpf) and generates their skeletons. It
> also provides what the user-space test binary needs to build: the header
> search paths (so #includes resolve), a bpf_link macro that wraps the link
> command, and BPF_LDLIBS, so the test can be statically linked against
> libbpf.a.
> 
> To use: set BPF_SRCS and OVERRIDE_TARGETS := 1 before including ../lib.mk
> (so lib.mk's default link rule is suppressed), then include ../lib.bpf.mk
> and list $(BPF_SKELS) as prerequisites of the test binary, e.g.,:
> 
>     BPF_SRCS         := progs/foo.bpf.c
>     OVERRIDE_TARGETS := 1
>     include ../lib.mk
>     include ../lib.bpf.mk
>     $(OUTPUT)/foo_test: foo_test.c $(BPF_SKELS)
>             $(call bpf_link,$@,$<)
> 
> This saves much work for configuring selftests in other folder, such the cgroup.
> 
> net/bpf.mk (which only builds *.bpf.o, without skeleton or vmlinux.h
> generation) is left unchanged; replacing the existing duplication
> mentioned above is the next step.
> 
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
> Suggested-by: Mykola Lysenko <mykolal@meta.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
> ---
>  tools/testing/selftests/lib.bpf.mk | 247 +++++++++++++++++++++++++++++
>  1 file changed, 247 insertions(+)
>  create mode 100644 tools/testing/selftests/lib.bpf.mk
> 
> diff --git a/tools/testing/selftests/lib.bpf.mk b/tools/testing/selftests/lib.bpf.mk
> new file mode 100644
> index 000000000000..6f175c6568e9
> --- /dev/null
> +++ b/tools/testing/selftests/lib.bpf.mk
> @@ -0,0 +1,247 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Shared fragment for selftests that compile *.bpf.c into BPF objects +
> +# skeletons and link them into userspace test binaries, without each
> +# subsystem's Makefile re-implementing the libbpf/bpftool/vmlinux.h machinery.
> +#
> +# Caller contract (per-test Makefile):
> +#
> +#     BPF_SRCS         := foo.bpf.c bar.bpf.c
> +#     TEST_GEN_PROGS   := foo_test
> +#     OVERRIDE_TARGETS := 1              # MUST be set before lib.mk
> +#     include ../lib.mk                  # defines OUTPUT, CC, Q, msg,
> +#     include ../lib.bpf.mk              #   selfdir, top_srcdir; honours OVERRIDE
> +#
> +#     $(OUTPUT)/foo_test: foo_test.c $(BPF_SKELS)
> +#         $(call bpf_link,$@,$<)
> +#
> +# Optional knobs (set before including lib.bpf.mk):
> +#   BPF_PROG_EXT     - source suffix, default .bpf.c; set to .c for the legacy
> +#                      "progs/foo.c -> foo.bpf.o" layout.
> +#   BPF_EXTRA_HDRS   - extra prerequisites (headers) for the BPF objects.
> +#   BPF_EXTRA_CFLAGS - appended to BPF_CFLAGS for the BPF compile.
> +#   BPF_SKEL_EXT     - skeleton suffix, default .skel.h (e.g. .bpf.skel.h).
> +#   BPF_GEN_SUBSKEL  - if set, also emit a subskeleton next to each skeleton.
> +#   BPF_OBJ_DIR      - dir for generated *.bpf.o (default $(OUTPUT)).
> +#   BPF_SKEL_DIR     - dir for generated skeletons (default $(OUTPUT)).
> +# A caller with unusual compile needs may override BPF_CFLAGS wholesale after
> +# the include (the object recipe expands it lazily).
> +# BPF_SRCS entries may live in a subdirectory (e.g. progs/foo.bpf.c); the
> +# objects and skeletons are always emitted flat under $(OUTPUT), keyed by the
> +# source basename (foo.bpf.o / foo.skel.h).
> +#
> +# lib.mk MUST be included first: this fragment consumes the vars it defines
> +# (OUTPUT, top_srcdir, CC, CLANG, Q, msg) and needs OVERRIDE_TARGETS to have
> +# already suppressed lib.mk's default link rule.
> +
> +include $(top_srcdir)/tools/scripts/Makefile.arch	# ARCH / SRCARCH
> +# Pull in the shared toolchain definitions (HOSTCC/HOSTLD/CLANG) so this
> +# fragment picks the *same* host compiler the libbpf and bpftool sub-makes
> +# will: in particular HOSTCC becomes clang under LLVM=1 (gcc otherwise).
> +# Without this the host bpftool and its bootstrap libbpf can end up built with
> +# a mix of gcc and clang, which trips clang on gcc-only flags (-Wstrict-aliasing=3).
> +#
> +# Makefile.include's allow-override resets CC to a bare "clang", which would
> +# drop the --target=<arch> flag lib.mk set for LLVM=1 cross builds (make LLVM=1
> +# ARCH=arm64).  lib.mk ran first and configured CC for the target, so save it
> +# across the include and restore it afterwards.
> +lib_bpf_mk_saved_cc := $(CC)
> +include $(top_srcdir)/tools/scripts/Makefile.include
> +CC := $(lib_bpf_mk_saved_cc)
> +
> +CLANG  ?= clang
> +HOSTCC ?= gcc
> +HOSTLD ?= ld
> +ifneq ($(V),1)
> +submake_extras := feature_display=0
> +endif
> +
> +# ---- paths & tools --------------------------------------------------------
> +TOOLSDIR    := $(top_srcdir)/tools
> +LIBDIR      := $(TOOLSDIR)/lib
> +BPFDIR      := $(LIBDIR)/bpf
> +TOOLSINCDIR := $(TOOLSDIR)/include
> +BPFTOOLDIR  := $(TOOLSDIR)/bpf/bpftool
> +APIDIR      := $(TOOLSINCDIR)/uapi
> +
> +# Everything generated lives under $(OUTPUT) so O= and in-tree both work and
> +# per-test builds (distinct $(OUTPUT)) never collide.
> +SCRATCH_DIR := $(OUTPUT)/tools
> +BUILD_DIR   := $(SCRATCH_DIR)/build
> +INCLUDE_DIR := $(SCRATCH_DIR)/include
> +BPFOBJ      := $(BUILD_DIR)/libbpf/libbpf.a
> +
> +# bpftool must run on the *host*; split the host toolchain out when cross-building.
> +ifneq ($(CROSS_COMPILE),)
> +HOST_BUILD_DIR   := $(BUILD_DIR)/host
> +HOST_SCRATCH_DIR := $(OUTPUT)/host-tools
> +else
> +HOST_BUILD_DIR   := $(BUILD_DIR)
> +HOST_SCRATCH_DIR := $(SCRATCH_DIR)
> +endif
> +HOST_BPFOBJ     := $(HOST_BUILD_DIR)/libbpf/libbpf.a
> +DEFAULT_BPFTOOL := $(HOST_SCRATCH_DIR)/sbin/bpftool
> +BPFTOOL         ?= $(DEFAULT_BPFTOOL)
> +
> +# ---- vmlinux BTF discovery -----------------------------------------------
> +VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
> +		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
> +		     $(top_srcdir)/vmlinux				\
> +		     /sys/kernel/btf/vmlinux				\
> +		     /boot/vmlinux-$(shell uname -r)
> +VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
> +ifeq ($(VMLINUX_BTF),)
> +$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
> +endif
> +
> +# ---- clang flags ----------------------------------------------------------
> +# Clang's default system includes (not the ones seen under --target=bpf); fixes
> +# "missing" asm/byteorder.h etc. '-idirafter' so we never shadow real includes.
> +define get_sys_includes
> +$(shell $(1) $(2) -v -E - </dev/null 2>&1 \
> +	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
> +$(shell $(1) $(2) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
> +endef
> +ifneq ($(CROSS_COMPILE),)
> +CLANG_TARGET_ARCH = --target=$(notdir $(CROSS_COMPILE:%-=%))
> +endif
> +CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
> +
> +IS_LITTLE_ENDIAN = $(shell $(CC) -dM -E - </dev/null | \
> +			grep 'define __BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__')
> +MENDIAN = $(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
> +
> +# Prefer -mcpu=v3; fall back to v2 on clang too old to know it (probed once).
> +CLANG_BPF_CPU := $(shell $(CLANG) --target=bpf -mcpu=help 2>&1 | grep -q 'v3' \
> +			 && echo v3 || echo v2)
> +
> +# -fms-extensions + -Wno-microsoft-anon-tag: required so clang accepts the
> +# anonymous nested struct/union members bpftool emits into vmlinux.h.
> +BPF_CFLAGS = -g -Wall -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)	\
> +	     -I$(INCLUDE_DIR) -I$(APIDIR) -I$(TOOLSINCDIR)		\
> +	     -std=gnu11							\
> +	     -fno-strict-aliasing					\
> +	     -fms-extensions -Wno-microsoft-anon-tag			\
> +	     -Wno-compare-distinct-pointer-types			\
> +	     $(CLANG_SYS_INCLUDES) $(BPF_EXTRA_CFLAGS)
> +
> +# $1 = src .bpf.c, $2 = dst .bpf.o
> +define BPF_BUILD_RULE
> +	$(call msg,CLNG-BPF,,$2)
> +	$(Q)$(CLANG) $(BPF_CFLAGS) -O2 --target=bpf -mcpu=$(CLANG_BPF_CPU) -c $1 -o $2
> +endef
> +
> +# ---- output dirs for generated objects/skeletons --------------------------
> +# Default: flat under $(OUTPUT) (what bpf/, hid/, cgroup/ do).  A caller may
> +# segregate the generated files into subdirs, e.g. BPF_SKEL_DIR := $(OUTPUT)/...
> +BPF_OBJ_DIR  ?= $(OUTPUT)
> +BPF_SKEL_DIR ?= $(OUTPUT)
> +
> +# ---- scratch dirs ---------------------------------------------------------
> +MAKE_DIRS := $(sort $(BUILD_DIR)/libbpf $(HOST_BUILD_DIR)/libbpf		\
> +		    $(HOST_BUILD_DIR)/bpftool $(INCLUDE_DIR)		\
> +		    $(filter-out $(OUTPUT),$(BPF_OBJ_DIR) $(BPF_SKEL_DIR)))
> +$(MAKE_DIRS):
> +	$(call msg,MKDIR,,$@)
> +	$(Q)mkdir -p $@
> +
> +# ---- libbpf (target) ------------------------------------------------------
> +# Pass ARCH/CROSS_COMPILE/CC through: lib.mk's CC is file-origin and is not
> +# exported, so without this the libbpf sub-make would rebuild for the host under
> +# a pure-LLVM cross build (make LLVM=1 ARCH=<arch>).  -fPIC keeps the static
> +# libbpf linkable into position-independent (PIE) test binaries.
> +$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile) \
> +	   $(APIDIR)/linux/bpf.h | $(BUILD_DIR)/libbpf
> +	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/ \
> +		    ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) CC="$(CC)"     \
> +		    EXTRA_CFLAGS='-g -O0 -fPIC'				      \

Looking at the same line in tools/testing/selftests/bpf/Makefile:

            EXTRA_CFLAGS='-g $(OPT_FLAGS) $(SAN_CFLAGS) $(EXTRA_CFLAGS)' \

is there a reason why this is not respected and -O0 and -fPIC are
hard-coded? What if someone wants to build selftests (including libbpf)
with -O2 and some additional flags? Is that possible with the new
lib.bpf.mk? It would be nice if it used at least EXTRA_CFLAGS or
USERCFLAGS defined in lib.mk.

Same questions would apply to other rules for libbpf and bpftool below.

Thanks!
Viktor

> +		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
> +
> +# ---- libbpf (host) -- a distinct rule only when cross-compiling -----------
> +ifneq ($(BPFOBJ),$(HOST_BPFOBJ))
> +$(HOST_BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile) \
> +		| $(HOST_BUILD_DIR)/libbpf
> +	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) ARCH= CROSS_COMPILE=	      \
> +		    OUTPUT=$(HOST_BUILD_DIR)/libbpf/ CC=$(HOSTCC) LD=$(HOSTLD) \
> +		    EXTRA_CFLAGS='-g -O0'				      \
> +		    DESTDIR=$(HOST_SCRATCH_DIR) prefix= all install_headers
> +endif
> +
> +# ---- bpftool (host) -------------------------------------------------------
> +$(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) \
> +		    $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/bpftool
> +	$(Q)$(MAKE) $(submake_extras) -C $(BPFTOOLDIR)		  \
> +		    ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD) \
> +		    EXTRA_CFLAGS='-g -O0'			  \
> +		    OUTPUT=$(HOST_BUILD_DIR)/bpftool/		  \
> +		    LIBBPF_OUTPUT=$(HOST_BUILD_DIR)/libbpf/	  \
> +		    LIBBPF_DESTDIR=$(HOST_SCRATCH_DIR)/		  \
> +		    prefix= DESTDIR=$(HOST_SCRATCH_DIR)/ install-bin
> +
> +# ---- vmlinux.h ------------------------------------------------------------
> +$(INCLUDE_DIR)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL) | $(INCLUDE_DIR)
> +ifeq ($(VMLINUX_H),)
> +	$(call msg,GEN,,$@)
> +	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
> +else
> +	$(call msg,CP,,$@)
> +	$(Q)cp "$(VMLINUX_H)" $@
> +endif
> +
> +# ---- BPF objects + skeletons ---------------------------------------------
> +# Sources may sit in a subdir and use the modern *.bpf.c or the legacy *.c
> +# suffix (BPF_PROG_EXT); objects go in $(BPF_OBJ_DIR) and skeletons in
> +# $(BPF_SKEL_DIR) (both default to $(OUTPUT)), keyed by the source basename.
> +BPF_PROG_EXT ?= .bpf.c
> +bpf_stems := $(patsubst %$(BPF_PROG_EXT),%,$(notdir $(BPF_SRCS)))
> +# The output namespace is flat, so two sources with the same basename would
> +# collapse into one object/skeleton; fail loudly instead of silently dropping.
> +ifneq ($(words $(bpf_stems)),$(words $(sort $(bpf_stems))))
> +$(error lib.bpf.mk: BPF_SRCS has colliding basenames: $(BPF_SRCS))
> +endif
> +# BPF_SKEL_EXT lets a caller pick the skeleton suffix (default .skel.h; e.g.
> +# .bpf.skel.h).  With BPF_GEN_SUBSKEL set, a matching subskeleton is emitted
> +# alongside (foo.subskel.h / foo.bpf.subskel.h).
> +BPF_SKEL_EXT    ?= .skel.h
> +BPF_SUBSKEL_EXT := $(patsubst %skel.h,%subskel.h,$(BPF_SKEL_EXT))
> +BPF_OBJS  := $(addprefix $(BPF_OBJ_DIR)/,$(addsuffix .bpf.o,$(bpf_stems)))
> +BPF_SKELS := $(addprefix $(BPF_SKEL_DIR)/,$(addsuffix $(BPF_SKEL_EXT),$(bpf_stems)))
> +
> +# Locate the sources wherever the caller keeps them (e.g. progs/).
> +vpath %$(BPF_PROG_EXT) $(sort $(dir $(BPF_SRCS)))
> +
> +$(BPF_OBJS): $(BPF_OBJ_DIR)/%.bpf.o: %$(BPF_PROG_EXT) $(BPF_EXTRA_HDRS) \
> +	     $(wildcard *.bpf.h) $(INCLUDE_DIR)/vmlinux.h | $(BPF_OBJ_DIR) $(BPFOBJ)
> +	$(call BPF_BUILD_RULE,$<,$@)
> +
> +$(BPF_SKELS): $(BPF_SKEL_DIR)/%$(BPF_SKEL_EXT): $(BPF_OBJ_DIR)/%.bpf.o $(BPFTOOL) | $(BPF_SKEL_DIR)
> +	$(call msg,GEN-SKEL,,$@)
> +	$(Q)$(BPFTOOL) gen object $(<:.o=.linked.o) $<
> +	$(Q)$(BPFTOOL) gen skeleton $(<:.o=.linked.o) name $(notdir $(<:.bpf.o=)) > $@
> +ifneq ($(BPF_GEN_SUBSKEL),)
> +	$(Q)$(BPFTOOL) gen subskeleton $(<:.o=.linked.o) name $(notdir $(<:.bpf.o=)) > $(@:$(BPF_SKEL_EXT)=$(BPF_SUBSKEL_EXT))
> +endif
> +
> +# ---- exports consumed by the caller --------------------------------------
> +# -I$(OUTPUT)/-I$(BPF_SKEL_DIR): so the test .c can #include "foo.skel.h".
> +# -I$(INCLUDE_DIR): so userspace can pull in the generated vmlinux.h if needed.
> +CFLAGS += -I$(OUTPUT) -I$(BPF_SKEL_DIR) -I$(INCLUDE_DIR)
> +
> +# Static libbpf.a first, then its deps. libbpf may pull in zstd (BTF decompress)
> +# only when built against it; link -lzstd only if libzstd is present.
> +BPF_LDLIBS := $(BPFOBJ) -lelf -lz
> +ifneq ($(shell pkg-config --exists libzstd 2>/dev/null && echo y),)
> +BPF_LDLIBS += -lzstd
> +endif
> +
> +TEST_GEN_FILES += $(BPF_OBJS)
> +
> +# Link helper: $1 = output binary, $2 = test .c (skels are the target's deps).
> +define bpf_link
> +	$(call msg,BINARY,,$1)
> +	$(Q)$(CC) $(CFLAGS) $2 $(BPF_LDLIBS) $(LDLIBS) -o $1
> +endef
> +
> +EXTRA_CLEAN += $(SCRATCH_DIR) $(HOST_SCRATCH_DIR)			\
> +	       $(addprefix $(BPF_OBJ_DIR)/,*.bpf.o *.linked.o)		\
> +	       $(addprefix $(BPF_SKEL_DIR)/,*$(BPF_SKEL_EXT) *$(BPF_SUBSKEL_EXT))


