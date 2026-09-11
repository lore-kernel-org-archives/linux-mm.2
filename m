Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6148C88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 07:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2E166B0092; Fri, 11 Sep 2026 03:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF436B0093; Fri, 11 Sep 2026 03:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93BFF6B0096; Fri, 11 Sep 2026 03:44:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70B686B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:44:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED52040126
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:44:55 +0000 (UTC)
X-FDA: 85200694950.08.5A1AEAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 53F3680004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:44:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nSh8nXxf;
	spf=pass (imf30.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789112694;
	b=FVywHmajHKVelc9J8R2JnZesE8sgqb3Il1UhMANqXWwf8RbG5w71w6lS32ySfkbP3H8j8S
	WAqLnIxjuJdfdpNxVTMBzCgHolR2wG4Q5HnHVbTuGRMbZIdeALs2XsbgOFiyl6j+E8du8o
	Vt+aWcDSkA8NcRmjxTJUlNkSYDpJ4b8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nSh8nXxf;
	spf=pass (imf30.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789112694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JVNsmiGxY1SdhPHsIl79rzqOKs/aP852ofsVaoPTftY=;
	b=Vcue1tNp0P6XfMD4EAZz9+MWxLp/LMfBC72vpzHezXoQxHjv6I1JTbkHx3A/3BuHvtGnDo
	Ycw7krS2CFgoHsZZnTpFD8byDMCu7MK5MVkGHEvjqHLRK65tObAVg3+D6Fom0j1ZxzYG09
	l7fzaOJXs19UMxFYpmEZ7Eta2DzV3mY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1F3140181;
	Fri, 11 Sep 2026 07:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05E101F000FF;
	Fri, 11 Sep 2026 07:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789112692;
	bh=JVNsmiGxY1SdhPHsIl79rzqOKs/aP852ofsVaoPTftY=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=nSh8nXxfkEr1kUl7cfnHIIf1jZLF1ZnKYJMXAxMWbeex/1I+vA4DWR+URZEpMvHbi
	 Xnd9r+6mji6dWqQ9LCBHTlIGDBmfENwyZi5PoKHpFNaZUjNorCTFH/TTHY/G3I1dA4
	 S7uGU0ykKRHQQVaF4JDhVsKt2auPoAB+6NT3b+aIPD9mvfkjstADVlQH8nTUnqC0r2
	 EwAuj7ZGUOIv8VXmM6rLhTrgeRIR/46HXvJwII9OQYXc9vwQOiXOJmpXzAlsrcDx6V
	 vqfoDjPnSK3T0vArVyKY6JMKGujqewoGn/BM3DPlCS9vZ6WnXsmenQnuYyeu9uaoQT
	 gm0AJS8Tv+A5w==
Content-Type: multipart/mixed; boundary="===============1065213570066958851=="
MIME-Version: 1.0
Message-Id: <81d809ef7a590d33ae978b98bb3d830b3cff2ce34a091ab3f4a5f0b977bfdfeb@mail.kernel.org>
In-Reply-To: <20260910233303.1063501-4-ziyang.meme@gmail.com>
References: <20260910233303.1063501-4-ziyang.meme@gmail.com>
Subject: Re: [PATCH v5 3/4] selftests/hid: build the BPF program via the shared lib.bpf.mk
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,shuah@kernel.org,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,jikos@kernel.org,bentiss@kernel.org,void@manifault.com,eddyz87@gmail.com
Cc: vmalik@redhat.com,arighi@nvidia.com,changwoo@igalia.com,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,akpm@linux-foundation.org,inwardvessel@gmail.com,mykolal@meta.com,nathan@kernel.org,ziyang.meme@gmail.com,kernel-team@meta.com,linux-kselftest@vger.kernel.org,cgroups@vger.kernel.org,linux-input@vger.kernel.org,sched-ext@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,llvm@lists.linux.dev,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Fri, 11 Sep 2026 07:44:50 +0000 (UTC)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 53F3680004
X-Stat-Signature: sd14hu9uiteqresee81tkcx1cytigbum
X-Rspam-User: 
X-HE-Tag: 1789112694-58104
X-HE-Meta: U2FsdGVkX19hhYHb+Itjw2d7T9kqb/N3M9JQxTPY0o0FglDyAmoDt59AM9uGwAvjlvWX1t6tYMU1oLb7kxPQVwi70r+octX+KIW3xiYBPtu8mq+TmZRFGHskgxFW+Hb7HS1vv/j3+DbGnoWskxdGmWLNOVkUdRzZC2/pu4svVlac0lVRFFCjdOqky5NCJS51jU7nmdqdaRzmECNi7ME0f9bb84FF2P0XdUYPYzt4jRoBM8J3gTuNL17d0gMHgjZcuDO1iPnbUEInk5YQYsnUieQyM8ZG+4fIZwNVxaA2bBM5suJgwHJqSjvUjpXJFnvtpw7w4JhKbUUjZb46gGLr7O66Tqn189GCra1GJHId8Syig5r/W5tMZnV9yA8hWn9WI7GTF1D+4RoUuyr2qHFXqbbR+KqdNmlt7dqWAx4JVRVNbz03tHpu8Pf6lqLCZEIVPj+FKsJmCN1LuHNIEfUZTIRiTvJJEqaSkqachsNHCWyhXWzbhyrqcNs1TmXzyOFOU6oqOCik4igpS/92vZc9rvPJn6PIoy3SMBFf9Wp0sbvUkzkYJEkpmTdhJq/8ahntzLVJAsVCQwVh01rMVSuQqAuX59NcE5Jzlv7HvLV0cPnDOT3q6/qVJjCxJeZn5Zgkcfn+XxI7Zosu2vR1vW/KRerPCmYZTPhjGub4EkL7GLLlyOQLJmysvAL81IR0qPZA1w/+XSFp1bhMDaVYwV7lzIysc0f/fgAd+Rh3UwdTIuABzoL73zKMDGd8nVahJuQVg79AbN+f/Hc8ZLpdE5Xo9gbtI92/dhsYKz0h7OrWl0O6Vi5bSh2T34Ae+Urxem9fJy9H/lPu1gHYOWLU0VGvOn5u6lNbfOySep+J/Rs8hjcc94OPogj/5dTVVg+cXXc/9wqQUo0I0IxaaHFAbNwmLQFxFzzGrKsgf8AY7Dmc8Yxg/NlslYE7gIRnGcEcrbzu7ZKnYNBVEMf3iPpIutl
 Mms5FQB3
 QJKD0g6riekmeZ6+pTlb+W6XHK8fRd0XyFFKplHvtzT2kjs7Qqv8WUHXCrtBL0PPR5xt7/6aFqk9XHqHXVWl/G7OMJ7Yz65/poHLu4cUtBMqKcx4MdKE4geK9INQ7m9fj1DunBBYgqOEkSPDuzqGbwVAFoMwDllCSwzmIoT4PsNeo9Zgjnk3efOJGtKvu+RKVnJH997Y/qfaVa9Sohbwp+MY++9zGn6LOdni/0n7mDtMh/pmFn6SW0BlcOHlskGKHqdjwodUZfRuyM+SLDt4+F7J9JMTUfeJJlKUlfPJJEwHWfGFX9a6FceTBh3gOl/rF3bDAS8DrucJZI9UqkSOVuGzabFxgZA2nQJ4Bzun0+F4pAA29tt2OZFqqqvq4l2L3ZBrvy6wiVovA7WdRCztVyAp9+NM3rX0CB2i6Gsn92zvMkPOKb1AJYdlFb8fVOpyygBiqoBVHUMo8xkNRpksVITZj5Tiot4VOXTr2NYcv++xEi5y3xNfBIRRtNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============1065213570066958851==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/hid/Makefile b/tools/testing/selftests/hid/Makefile
> index 2f423de83147..1190a747036d 100644
> --- a/tools/testing/selftests/hid/Makefile
> +++ b/tools/testing/selftests/hid/Makefile
> @@ -47,7 +47,6 @@ msg =
>  else
>  msg = @printf '  %-8s%s %s%s\n' "$(1)" "$(if $(2), [$(2)])" "$(notdir $(3))" "$(if $(4), $(4))";
>  MAKEFLAGS += --no-print-directory
> -submake_extras := feature_display=0
>  endif

This isn't a bug, but with submake_extras gone, does anything still need
this local msg/MAKEFLAGS block?  lib.mk defines both identically a few
lines below, so it looks like it could be dropped along with the rest of
the copied machinery.

> @@ -58,172 +57,25 @@ override define CLEAN
>  	$(Q)$(RM) -r $(EXTRA_CLEAN)
>  endef
>
> -include ../lib.mk
> -
> -TOOLSDIR := $(top_srcdir)/tools
> -LIBDIR := $(TOOLSDIR)/lib
> -BPFDIR := $(LIBDIR)/bpf
> -TOOLSINCDIR := $(TOOLSDIR)/include
> -BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
> -SCRATCH_DIR := $(OUTPUT)/tools
> -BUILD_DIR := $(SCRATCH_DIR)/build
> -INCLUDE_DIR := $(SCRATCH_DIR)/include
> -BPFOBJ := $(BUILD_DIR)/libbpf/libbpf.a

[ ... ]

> +# Build the legacy progs/*.c layout with the shared BPF rules.
> +BPF_SRCS       := $(wildcard progs/*.c)
> +BPF_PROG_EXT   := .c
> +# BPFDIR is defined when this recursive variable is expanded.
> +BPF_EXTRA_HDRS  = $(wildcard progs/*.h) $(wildcard $(BPFDIR)/hid_bpf_*.h) \
> +		  $(wildcard $(BPFDIR)/*.bpf.h)
> +

This isn't a bug, but do the two $(BPFDIR) wildcards still match anything
here?  tools/lib/bpf has no hid_bpf_*.h, and lib.bpf.mk's
lib_bpf_header_sources already covers *.bpf.h - if so, this could become
a simple BPF_EXTRA_HDRS := $(wildcard progs/*.h) and lose the
recursive-expansion comment.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/34573210499
--===============1065213570066958851==--

