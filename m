Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0E66C79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 07:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13246B0093; Fri, 11 Sep 2026 03:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9AAD6B0096; Fri, 11 Sep 2026 03:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0386B0098; Fri, 11 Sep 2026 03:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 718EE6B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:44:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DED0F160109
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:44:57 +0000 (UTC)
X-FDA: 85200695034.15.08D5E29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 62B721C0004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:44:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IndTzz0q;
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789112696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBzZVFee4S2rVGtg6M6II1AeDxf+F8a1EcPtLaDHgSA=;
	b=lrvQLt8ClaTx9xhRYvLXFoucVTCTT00MN16uGJ0KGiCiWOv+1So6vRuzUGnyyVTZEgWFD6
	DKwjaZMx0oLqOIsyQYNHvB5Q0qD+f9YGjWQUMx20r3MOs66rmKJ4vT7uhuoQIyVINgXjV7
	gK+0Tm7Bu4PqPPFsGjmn87KzlVvrNjE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789112696;
	b=BNndUx7HQiVkKVGuhFkDUdKoENUi1YWu2SDPQMakPbiDBgk9M2saFhJuAZnjeihwfCuvvk
	31QJunMFBqpMbutPAqYzrUF/3XYykrKM4KlWG/8CpQHlBXY3FBZAtxBTgcKgfhZg4nxild
	RmRD3Uz8+ctcE1Zo4Zv6fv2rctEX4GA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IndTzz0q;
	spf=pass (imf20.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 92CA460213;
	Fri, 11 Sep 2026 07:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6CA1F00893;
	Fri, 11 Sep 2026 07:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789112695;
	bh=OBzZVFee4S2rVGtg6M6II1AeDxf+F8a1EcPtLaDHgSA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=IndTzz0qx5n84yuYFaj0DWuFbXlMNMPU4pRMRYbKWgxyf4TAx2zBq8olTVJsw4s2u
	 T8ETqh0czo2f8KDTWd/deX51MYFDkVdIFO3jrx3+oJdStA6flfctbs8Kow9r290h9/
	 ysBcd4DtTy6jucTnsC9uG3bAlZdzphZM22IDAA+tfNUpb1185+ZTvA0wuTYdkFIDlQ
	 GY+8MTjJh6Sf1yjKHRdxLJRSR4tsXlWw8dXmKWnC+c0hbF7rNeEftF3Q0uYOwSChKD
	 6R3SIFMUrqRBR5DKwf4bY4JCkrXjt16eiRWlwNww199xaYLBMnyK0TdnOyRIMGd5MC
	 z5YYoLKAUXWUw==
Content-Type: multipart/mixed; boundary="===============1662541605359616403=="
MIME-Version: 1.0
Message-Id: <c51a056670cea30c7fb85ed0ef80a6be9b7e538196a5ae53cbad3b374db70c2c@mail.kernel.org>
In-Reply-To: <20260910233303.1063501-5-ziyang.meme@gmail.com>
References: <20260910233303.1063501-5-ziyang.meme@gmail.com>
Subject: Re: [PATCH v5 4/4] selftests/sched_ext: build BPF schedulers via the shared lib.bpf.mk
From: bot+bpf-ci@kernel.org
To: ziyang.meme@gmail.com,shuah@kernel.org,tj@kernel.org,hannes@cmpxchg.org,mkoutny@suse.com,jikos@kernel.org,bentiss@kernel.org,void@manifault.com,eddyz87@gmail.com
Cc: vmalik@redhat.com,arighi@nvidia.com,changwoo@igalia.com,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,akpm@linux-foundation.org,inwardvessel@gmail.com,mykolal@meta.com,nathan@kernel.org,ziyang.meme@gmail.com,kernel-team@meta.com,linux-kselftest@vger.kernel.org,cgroups@vger.kernel.org,linux-input@vger.kernel.org,sched-ext@lists.linux.dev,linux-mm@kvack.org,bpf@vger.kernel.org,llvm@lists.linux.dev,linux-kernel@vger.kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Fri, 11 Sep 2026 07:44:53 +0000 (UTC)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 62B721C0004
X-Stat-Signature: s57ht7s13akfo7tx9ntid1r5qw7a61q3
X-Rspam-User: 
X-HE-Tag: 1789112696-806557
X-HE-Meta: U2FsdGVkX1+JxpQaC6zJUXtgCXTVfGugymbD37pzylfMLYX6SUXriFVJ+ugLqOag+oAQJ788IdqZoKQ3F4SmcwkvJWYYiNg3AfCZx1b2cgrmb2MTV+vafzcWdBbe4aO4aTfrRq+EtAuNenMa/WSVKsuD8niIuodA4dLtDgzzmKoVprQl+XSeKjiGln41asd1BV76FyNiOausrdkLTVPCSW0hieLn/N0W/lF0dofOfCpOVxR/yPfS2aH7Q29MfusKFiJ4dRj/nduhO7khnkhgwUgU6ybtxV5rzyUyjyPiG0iw673DPi3FCCATJVG90ahwtVqG+E9IwRHI+1iCnzUzuIa6XyG8Mi18b7R+GRUSyPDunTtHXIuczQI2ER5qOVaSrHFgHtNSEcVKRfmd3geNMm90z0veLHmtoIglHY7/yfQdU9xxXCdbXYpDPzgvuqSXZw2bHuOt3XGtphRNerDgtnaxXDT2VfVtkUSyF8NOyeiB86tORgo6RWA+nYFMKrv5oGtkd6TxVvmclDocal4Z+syYLtBye+kGwFANDPuThqgjgyfHbLjM3Q0ryeF0UD1Bi3TBW3TpHGS0YDkp8sMI1qTFS6PG+WkGVbMjAVmUj7POhep1Uwa/gvIpxCykhpk4MqGJo2BC0FkXc6zSnKTy65GtVBYokNt63jgRtPDaAkfDDfjCK4zL3k7JZxfsG38tLOjP8ld7mWx7W5+SiSq31xLaNhC6ZRBgbX23ciwXeUtd6RvlE3h5KN5e46M8VCWNWi0aUF76eGk76vS7kpEMSNvsG93MFb2rBSHM/eTpFpJWF3RpdtmR63YQuPE7OXlqkRbhfCfJQfmCNvSf8dtJJAkH+ksmKSfFx2ZrGDEeIHb0bYMGPxgC/HvOajn1t64qtBs/g60Kr3fqNiqcfU4B7i5TEp6ALBYeJopldxhqs0mwIkc8ZwYqWG+z3m8F6fm+U/IKL44gQFLHNpsK0X5
 QKMMEJ2E
 s7roPViPW9KT2ID4cMNADbJ2UVBTBo085b7W9JQTl2FVjYZNreVvxhGTYTRhipsYDgxpgUaklR2nau2CFyRsX9m8EOq2PoFkbOVwZn3O3IutVoUKKrH6iB5ukneDz5EXnOII1n+aUhIUsRie8OxOxQolfVucFZOeA/HtwWP+o6nbu/6Dq+AnSu1yfp0xkUyDQsEuSTZP16Ru69ZXdyCYGpV0upgru6u5zdgjGd8pYdTKgYAy1H7wTXnzbEnCp3LOLO1OhF6WJiOUmw122y/LKjqbjNx+rlltnkj/7NPK9LDM6mkTVQlK2mtsBCbB3hT8xHwFymUBn6luy5et0zOGTH8EfNlhdO8rBdH4oOnksaLLzTTnr+8z8BbO0WB/UCkdmuXA/udu4ZtjmbvL+E0IeDUHJUmMbgjA3A2r+wSycJZ8h9xO6MaryBHdB40UdxY9i97LJ3PXQ6HuKjn4spVxLrLcfsrjtdtGuSpwLowQB8vMgCAhSOnh4MZAQtTF2QBuApkTaW9+LFwVtzqKDEBgxcvUTWW33FlT6HueC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============1662541605359616403==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/tools/testing/selftests/sched_ext/Makefile b/tools/testing/selftests/sched_ext/Makefile
> index 3cfe90e0f34f..dd3f5594af24 100644
> --- a/tools/testing/selftests/sched_ext/Makefile
> +++ b/tools/testing/selftests/sched_ext/Makefile
> @@ -14,48 +14,29 @@ CURDIR := $(abspath .)
>  REPOROOT := $(abspath ../../../..)
>  TOOLSDIR := $(REPOROOT)/tools
>  LIBDIR := $(TOOLSDIR)/lib
> -BPFDIR := $(LIBDIR)/bpf
>  TOOLSINCDIR := $(TOOLSDIR)/include
> -BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
> -APIDIR := $(TOOLSINCDIR)/uapi
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
> +# Build scheduler skeletons and subskeletons with the shared BPF rules.
> +BPF_SRCS        := $(wildcard *.bpf.c)
> +BPF_SKEL_EXT    := .bpf.skel.h
> +BPF_GEN_SUBSKEL := 1

This isn't a bug, but is anything consuming the generated
*.bpf.subskel.h headers? Grepping the directory for "subskel" matches
only the Makefile itself - no .c or .h file under
tools/testing/selftests/sched_ext/ includes a subskeleton header. The
pre-patch rule generated them too, so this preserves existing behavior,
but the conversion makes the subskeleton an explicit one-line opt-in.
Would dropping BPF_GEN_SUBSKEL be a reasonable follow-up to save a
bpftool run per scheduler?

> +# Preserve the existing build/ layout.
> +BPF_OBJ_DIR  := $(OUTPUT)/build/obj/sched_ext
> +BPF_SKEL_DIR := $(OUTPUT)/build/include
> +SCXOBJ_DIR   := $(BPF_OBJ_DIR)
>
> -BPFTOOL ?= $(DEFAULT_BPFTOOL)
> +include ../lib.bpf.mk

[ ... ]

> @@ -64,102 +45,26 @@ endif
>
>  LDFLAGS = -lelf -lz -lpthread -lzstd

[ ... ]

> +EXTRA_CLEAN += $(OUTPUT)/build
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
> -# allows testcases to load any BPF scheduler, which is useful for testcases
> -# that don't need their own prog to run their test.
> -all_test_bpfprogs := $(foreach prog,$(wildcard *.bpf.c),$(INCLUDE_DIR)/$(patsubst %.c,%.skel.h,$(prog)))
> +# Build every scheduler before each test.
> +all_test_bpfprogs := $(BPF_SKELS)

This isn't a bug, but since the variable assignment is otherwise a
straight substitution (the foreach expression becomes $(BPF_SKELS)),
would it be worth keeping the original comment wording? The previous
text explained the rationale - "Every testcase takes all of the BPF
progs as dependencies by default. This allows testcases to load any BPF
scheduler, which is useful for testcases that don't need their own prog
to run their test." - while the replacement restates what the following
line does and drops the reason a testcase depends on schedulers it does
not own.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/34573210499
--===============1662541605359616403==--

