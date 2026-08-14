Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 527C4C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 17:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37C4F6B031B; Fri, 14 Aug 2026 13:05:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D456B031D; Fri, 14 Aug 2026 13:05:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5306B031C; Fri, 14 Aug 2026 13:05:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2D776B031A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 13:05:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6500D801A0
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 17:05:17 +0000 (UTC)
X-FDA: 85100500674.14.1AE9599
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 969591C0009
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 17:05:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TmbZodsj;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786727115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nTcDVPb9lc0nxETTOrYdaxHGm4RZ3gRaGaYQ2F0hvPE=;
	b=5NPFj16xAHI98xyseA+SBqEbHmA+ibClKuTT65ERcsfzdKYD0/nxqkzQQCsXfe5uuH5b+d
	SP1aeu7I8lY8swtmIqLBLIcbBriwHv0eE68YqyYN277h6JMU2dirEeFmYeioPwYbNdk1Wc
	r6ffbiS+K+5Mg37QyXzs5cchEL2dkyc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TmbZodsj;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786727115;
	b=UDvDgBgHekV3VWpWtBDGxZh9LNCqmZsVWe1qg4MBa5hjiYFid8BSpOoxH7AUqiuP+iFWIp
	5lQV+7eR752SzYip2SHqj4U6VKFZzVe9SIa7fiz1wvTzSgxk/oEyvnXy1Mjce0EPZumPpt
	7iKJbefbqaFEBYY9zBVFrXmV7radFCE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F08C943C5F;
	Fri, 14 Aug 2026 17:05:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D351F00A3A;
	Fri, 14 Aug 2026 17:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786727113;
	bh=nTcDVPb9lc0nxETTOrYdaxHGm4RZ3gRaGaYQ2F0hvPE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=TmbZodsjt9oMaWZBMu0XySo46nKHdB1ITiU3ozRdXsJZy+evrN4Y9Hk8w9qYcQEJL
	 1mJITTo3mhPAfmql+Z1h/kmJyoege82jjuv7PAoHgwGLSQB3R5XJAYTtMYlmljEUa+
	 rm692nVl54BOJhZ1QqasYHf6dOYA3QtkDicqSOuydT547RbTpEIhaUPMnUEMuPmV6I
	 X4/1N0wPody7SndkO6SpjTBACTs1ORupSXV3ncyp8Q9yP4x/9ho8wcnTijabuXKCCb
	 8qm/tJba6RWOVNwHcFOxxVfNr925Pw9TofbxwZOwFHAZZsBtojcXNx938RV7hnb9Dx
	 YTpX71qDalB+w==
Content-Type: multipart/mixed; boundary="===============2223739720343807470=="
MIME-Version: 1.0
Message-Id: <516ec49a2bff8ffb9142aa02957bcea1ade0398a778eadd1c9277a83782407b4@mail.kernel.org>
In-Reply-To: <20260814075054.507089-5-ziyang.meme@gmail.com>
References: <20260814075054.507089-5-ziyang.meme@gmail.com>
Subject: Re: [PATCH v3 4/4] selftests/sched_ext: build BPF schedulers via the shared lib.bpf.mk
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,shuah@kernel.org,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,jikos@kernel.org,bentiss@kernel.org,void@manifault.com,eddyz87@gmail.com
Cc: vmalik@redhat.com,arighi@nvidia.com,changwoo@igalia.com,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,akpm@linux-foundation.org,inwardvessel@gmail.com,mykolal@meta.com,nathan@kernel.org,ziyang.meme@gmail.com,kernel-team@meta.com,linux-kselftest@vger.kernel.org,cgroups@vger.kernel.org,linux-input@vger.kernel.org,sched-ext@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,llvm@lists.linux.dev,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Fri, 14 Aug 2026 17:05:12 +0000 (UTC)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 969591C0009
X-Stat-Signature: gndqbrasmuufnmhaehbxzeprrihj4bfb
X-Rspam-User: 
X-HE-Tag: 1786727115-680014
X-HE-Meta: U2FsdGVkX19QcpFgDqVNdwZr1+Zp6TcmDyR4iDsWpnfd3TL9Gc4CQyVtQRkD7+idxbM1/iUUMrTbdn0Kd7xURz5ULXVQLhNb+ANZADZXTIMp2ITi6QSDyaiAfSSqWHeiG4Y2f4R5vg4SWlGbVdyj5f9G3BwgCgOBpjc1PFUBcpa7tJdA3NITNY0O1cvkbPlXuKNBP3UXsFkyAxEZmF6U544ZIXkitvEJHURN/VyaZqNg4uNT8SR9yt/CJ1vj50cUsFiMArGCSjjdvJt9Vo1trn1lWbd3IS7w65U5cQsogjr8m4CAgCDmKXDrGR+e8tw1ZWUVDIOeK3kZpuDZkl59/jhCC0IDgXjaxpOyMWneGLgljA6r/QyU3vbzX9fCe+q0OtHLkGFisSwFs8zjvy46wVuRFhCYAO9ItXRTd7scLkkRp7IVK0vmcmwukm0l+2XbjHyLgZoxkeS7kh+MHy7olBYXvi+pZZG+Jq3IQjmbKun9VZSSJuI0TXCruzJqr5R8iYBGoC6pI/SRiY8fMVmOkJiGNSsfwGc4cSkx60ixL0TucGh3eM7Dgoc2UisV+J9v62lyOQULV6wut/P8FDU6JxQ8hSSgjFer6fnBksbxv/A/dus6ywVfTwMvLEoMf6WfEMDPMIB8fjctZvVmGrtAdf1kjPjLKDd/98QrYoomm0XPzf7XnHxxRdkq+iVTCHCbWoGI+VE9GdyG2TZGzRkrE3f91haFrfyhTdgOq1pvKBG5yM+NULVCH/eEGvdUQSzBiJMvhUYlFU8et8iMPzkjCDYsl5+BrDOXsHcOnsCj/xu+DG3cVr0v0mEjl90MA30YqpNBlX6kGAmQYJzTP1wg2D0Z0ytClsVlG0P7MtCgaC47aoPc5NpIVZWcQtvhE74nwFnTE4kmh3a+a28y8HZMpeYzNqLUXuHFMlo2gpXOSyI4EogMu22XdhLdj0YjSA9o0p9gHm/gDml2MwOr8k4
 s1mPfM05
 XCcnUOGJ+jIAtN6ixGHG9gFti0/2jqCD1ez7mWYnvDH9bwkajHYCssCH6xEnydZqzDINyOLFegjay+8vW1184LUypBphgrh+y+RJ0wFWUBZC+nJvLhXD6RVB0QOhLfijljGICiw0+cEoZx6duQWsWEiV24ffYeO3twMqMWZxhIor65O9OlfYpjaFyyjut5jjB5WSxGirrtPpjhG2WnFoOftKrB0ci/gEMdhDXDglKGzvmxrDHh1VwPg1QqSd435CrGvkNZ9igVxFEDdXBnGTqVBnObChqZqTw/TuEf9ZdluZ7PVmjJmYr+90iWSkKzW3JU58kyshxrM/WrQ4imM5n+Y1HhqeGTceMEEjq+ye5jdrTN1BcVwIRZueh6ga8EJvjMPI7YnqYfsjiRSWL6IJU3NAFtpDGKzx0SA38+5cvApmenL4bn7BgJKxxufchVGkzFDYhfmmixIk6xzbWi7sTCUpkAPPwTOOsizwsBOtE/DeI9vP8yKUY2V+Di2T2sGIfWTlIejLLu9UcBAmDQU6fee8Mo6lBnCrRtxLx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============2223739720343807470==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/sched_ext/Makefile b/tools/testing/selftests/sched_ext/Makefile
> index 3cfe90e0f34f..a2df47b300d0 100644
> --- a/tools/testing/selftests/sched_ext/Makefile
> +++ b/tools/testing/selftests/sched_ext/Makefile
> @@ -14,48 +14,32 @@ CURDIR := $(abspath .)
>  REPOROOT := $(abspath ../../../..)
>  TOOLSDIR := $(REPOROOT)/tools
>  LIBDIR := $(TOOLSDIR)/lib
> -BPFDIR := $(LIBDIR)/bpf
>  TOOLSINCDIR := $(TOOLSDIR)/include
> -BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
>  APIDIR := $(TOOLSINCDIR)/uapi
>  GENDIR := $(REPOROOT)/include/generated
>  GENHDR := $(GENDIR)/autoconf.h
> -SCXTOOLSDIR := $(TOOLSDIR)/sched_ext
>  SCXTOOLSINCDIR := $(TOOLSDIR)/sched_ext/include
>
> -OUTPUT_DIR := $(OUTPUT)/build
> -OBJ_DIR := $(OUTPUT_DIR)/obj
> -INCLUDE_DIR := $(OUTPUT_DIR)/include
> -BPFOBJ_DIR := $(OBJ_DIR)/libbpf
> -SCXOBJ_DIR := $(OBJ_DIR)/sched_ext
> -BPFOBJ := $(BPFOBJ_DIR)/libbpf.a
> -LIBBPF_OUTPUT := $(OBJ_DIR)/libbpf/libbpf.a
> -
> -DEFAULT_BPFTOOL := $(OUTPUT_DIR)/host/sbin/bpftool
> -HOST_OBJ_DIR := $(OBJ_DIR)/host/bpftool
> -HOST_LIBBPF_OUTPUT := $(OBJ_DIR)/host/libbpf/
> -HOST_LIBBPF_DESTDIR := $(OUTPUT_DIR)/host/
> -HOST_DESTDIR := $(OUTPUT_DIR)/host/
> -
> -VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)					\
> -		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)		\
> -		     ../../../../vmlinux					\
> -		     /sys/kernel/btf/vmlinux					\
> -		     /boot/vmlinux-$(shell uname -r)
> -VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
> -ifeq ($(VMLINUX_BTF),)
> -$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
> -endif
> +# The schedulers are built by ../lib.bpf.mk: modern *.bpf.c layout, a
> +# .bpf.skel.h suffix, and subskeletons.
> +BPF_SRCS        := $(wildcard *.bpf.c)
> +BPF_SKEL_EXT    := .bpf.skel.h
> +BPF_GEN_SUBSKEL := 1
> +# Keep the generated files under build/ as before.  SCXOBJ_DIR (userspace
> +# objects) reuses the BPF object dir.
> +BPF_OBJ_DIR  := $(OUTPUT)/build/obj/sched_ext
> +BPF_SKEL_DIR := $(OUTPUT)/build/include
> +SCXOBJ_DIR   := $(BPF_OBJ_DIR)

The comment says generated files stay 'under build/ as before', but only
two of the five generated-output locations do. lib.bpf.mk hardcodes its own
scratch tree from $(OUTPUT):

tools/testing/selftests/lib.bpf.mk defines:
  SCRATCH_DIR := $(OUTPUT)/tools
  BUILD_DIR   := $(SCRATCH_DIR)/build
  INCLUDE_DIR := $(SCRATCH_DIR)/include
  BPFOBJ      := $(BUILD_DIR)/libbpf/libbpf.a
  HOST_SCRATCH_DIR := $(OUTPUT)/host-tools
  DEFAULT_BPFTOOL := $(HOST_SCRATCH_DIR)/sbin/bpftool

So relative to the pre-conversion layout:

  build/obj/sched_ext/         BPF + userspace objects   unchanged
  build/include/               skeletons and subskeletons unchanged
  build/obj/libbpf/libbpf.a -> tools/build/libbpf/libbpf.a       moved out
  build/include/vmlinux.h   -> tools/include/vmlinux.h           moved out
  build/include/bpf/*.h     -> tools/include/bpf/*.h             moved out
  build/host/sbin/bpftool   -> tools/sbin/bpftool or host-tools/sbin/bpftool

The layout change itself is fine and is not a leak: lib.bpf.mk already adds
$(SCRATCH_DIR) and $(HOST_SCRATCH_DIR) to EXTRA_CLEAN, so 'make clean'
still removes everything the deleted 'override define CLEAN' used to
remove.

Could the comment be more precise by naming what actually stays put, namely
the BPF objects and the skeleton headers?

[ ... ]

>
>  ################
>  # C schedulers #
>  ################
>
> -override define CLEAN
> -	rm -rf $(OUTPUT_DIR)
> -	rm -f $(TEST_GEN_PROGS)
> -endef
> -
> -# Every testcase takes all of the BPF progs are dependencies by default. This
> +# Every testcase takes all of the BPF progs as dependencies by default. This

[ ... ]

>
>  .DEFAULT_GOAL := all


Separately, the commit message states:

>     sched_ext carried its own ~130 lines of libbpf + bpftool + vmlinux.h +
>     BPF-object + skeleton build machinery.  Replace it with an include of the
>     shared tools/testing/selftests/lib.bpf.mk, making sched_ext the third
>     in-tree consumer of that fragment, after selftests/cgroup and
>     selftests/hid.
>
>     All 28 skeletons and 28 subskeletons keep a same public API before and
>     after, the runner builds and links the same way.

The '28 skeletons and 28 subskeletons' count looks off. The directory holds
29 BPF sources at this commit, so the conversion generates 29 skeletons and
29 subskeletons, not 28:

  $ git ls-tree --name-only f71f601c6ade:tools/testing/selftests/sched_ext \
      | grep '\.bpf\.c$' | wc -l
  29

Both the old wildcard rule and the new BPF_SRCS enumerate the same 29 files,
and the skeleton rule emits one .bpf.skel.h plus one .bpf.subskel.h per
file. The two easy-to-miss sources are maybe_null_fail_dsp.bpf.c and
maybe_null_fail_yld.bpf.c, which have no matching userspace .c file and so
do not appear in auto-test-targets. A count taken from the test list rather
than from *.bpf.c comes out one or two short.

Should this read '29 skeletons and 29 subskeletons'? Also, the same sentence
reads oddly: 'keep a same public API' should be 'keep the same public API',
and the two clauses after it look like a comma splice.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/31820214629
--===============2223739720343807470==--

