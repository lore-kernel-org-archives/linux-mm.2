Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37645C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 19:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 567F96B009B; Thu,  6 Aug 2026 15:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5401B6B00A0; Thu,  6 Aug 2026 15:48:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 456B66B00A2; Thu,  6 Aug 2026 15:48:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 203146B009B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 15:48:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1D071401C7
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:48:43 +0000 (UTC)
X-FDA: 85071882126.09.B8FEB47
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id E8AAE1C000B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 19:48:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="W/vPVG/M";
	spf=pass (imf20.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786045721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sol2WO6spiJABjGJXVw88JoISuJHWDSM4SUE68dh/Oo=;
	b=UQQcLafKVynJj729UMF6l2HiyYHPwhiCzNksb4ZDRsCBAHd8Bl0YLOw5CPjwT+DT58JFp7
	VKyYtdfMK5Ds1uR6x0+xtjnyoJgdLjx4Jf3ezJZGB8dhBP26jwnX2BSCx5VacEIk1y32mB
	YnqHY6D+NroriA4w6+WqemtXH7qOrno=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786045721;
	b=FB93XumCV0T6khDtErT+3q6dByHRxFKxAsxM4ykX983j6ha0vt0KXWB3tO55pO/G2UEE8t
	QaVh2yYuuimuRJcZ1OlPeH+rvSbNrkjgU63DID3V/8kDeKkpBjc2qIcjTwKbdj3ZtiHiLx
	I2VguFsgN0E8z69A4cHKv8mokBD0M4k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="W/vPVG/M";
	spf=pass (imf20.hostedemail.com: domain of ziyang.meme@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=ziyang.meme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ceaf8a1265so38869935ad.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 12:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786045721; x=1786650521; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sol2WO6spiJABjGJXVw88JoISuJHWDSM4SUE68dh/Oo=;
        b=W/vPVG/Mgo4096i1ydenz+jGliWuIkRUE+bu2WxTAg69d6LVeGPQitHa6E2SOthwvz
         Ax7pWeXjBVVJbIXfmpwDYP0KqHANqKNUgbZJrju3L/iCpR7gk4nTbgIWX4IiZeUfnUo0
         P8vRgOr8gECf6TvCIU9J3Sfv5XrkW7DOQqqNVz0CWVkAd1M0MAdvNlQ67FzkPLJ+mnQ2
         aOhfUhjgqRmkmsvAWn57Te5d0iXjoXEL1iRELBPIaxr9WCekAR/rVOmwV8woVTQmOe0H
         wr5aGl4shMVEs1RCxmxfTXiRKXYYndSDFobbDK6/woVDw9sKnmH2PeyH6CZDl3gXgIzr
         6k9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786045721; x=1786650521;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sol2WO6spiJABjGJXVw88JoISuJHWDSM4SUE68dh/Oo=;
        b=cA6ae86IN5fIijRRfT8EgsLuFgUnJH13oEQ9JrxTiJUSI/oniWHtAYvqFcdpVrgMUv
         rrR8XNg3eGITW/Iu9SGVG4KLuCULyEuUVK2T3u66ty4oVzhTBdGLxYm7HgrEdij3Hizz
         BZAPoc1gTK/P7ICLGAU369sm6LQZ3eIS0dDuSmiqbpDrqXwVMEar/yF+tsNKjBTKQZa5
         T6rrc9hIU5wb4a1QiDMP8ZfuoB8YqhuhLAMnDSr1vAVqml0Wl+v+/NEFWbXKkshqBNc0
         IyFFzu7s1Th0oU7Kz7R1tl4nNgeSd7DigWT8XZbLchs3dayvsCgYGWlB6TjZvhUodKXl
         Tw6Q==
X-Forwarded-Encrypted: i=1; AHgh+RqpzhzDYWUCwHaHP/5Af7oy7aTmZEBRAB9fv9+B1UaXFU8xAFureIw3zJw9jPv2WoQUnBcohlpaMw==@kvack.org
X-Gm-Message-State: AOJu0Yx0TMZzGnF9wgaE59aMbqJwh8e8h6Ay/bAcZyUmDvN0TzCunlMF
	EARmbQ9EHQDk6v3DY3U87e3SDFs47qFqHjOPTMjs+1wmFDB+l7HUEQmr
X-Gm-Gg: AR+sD1229Wp0Q0kuxJQL+8KgIwLD213DAqROfXtzRF4ron6ehxM5W/LPuwpe6r/oH8q
	ebt4XSNg0ncC84u7hVeGdLzUOgnQLKpG3wSBBi3mXdCe2d/2/2nE8Hrc11YxHRp/8K+lDyWcnaR
	wwUPZVXo3xFwDv6s3mQ/4zBUBVyQEZBFWyck4ci/zx/JKBA0f2rFfP9kB0oAB7VNgY6tjoJvK2s
	d7ZChCmDMSSh9nTmVa9Dt50R9dThhWmjuSvdlTuMX+6+4emdeA7hmhc1qesns6K8oX3b46Pi0iY
	16sriT0H7T43O0KOMc5dfOhH9SUI4aAFSk0v3/WQ8qu1JD1hfW1ANwx1AAzAH/hogZNOsB/4wN1
	L1ajfSeGWGsN25HnGgbjxU80G+6rnWN9HMePfTSWDTZHNVVg3HhNVIUfG0Dll2IWXXdr9Pqtwdd
	+y3+EmBi5J90CN8u8vUNis+6Ph/VyX4nWhNXGms6plI2tYym2qwRyomasXUoP3zydqW3dL+RAro
	SWCDjuq
X-Received: by 2002:a05:6a21:139a:b0:3bf:82c5:ed13 with SMTP id adf61e73a8af0-3cb860269a0mr22194217637.38.1786045720625;
        Thu, 06 Aug 2026 12:48:40 -0700 (PDT)
Received: from devvm16600.scu0.facebook.com ([2a03:2880:9ff:42::])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14100a73dbdsm736497c88.15.2026.08.06.12.48.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 12:48:40 -0700 (PDT)
Date: Thu, 6 Aug 2026 12:48:37 -0700
From: Ziyang Men <ziyang.meme@gmail.com>
To: Viktor Malik <vmalik@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	David Vernet <void@manifault.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	JP Kobryn <inwardvessel@gmail.com>,
	Mykola Lysenko <mykolal@meta.com>,
	Nathan Chancellor <nathan@kernel.org>,
	linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org,
	linux-input@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-mm@kvack.org, kernel-team@meta.com, bpf@vger.kernel.org,
	llvm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] selftests: add shared lib.bpf.mk to build BPF
 progs and skeletons
Message-ID: <anTlFSsr5FqQt+o8@devvm16600.scu0.facebook.com>
References: <20260721174833.1232771-1-ziyang.meme@gmail.com>
 <20260721174833.1232771-2-ziyang.meme@gmail.com>
 <f2a0db3b-ac66-4b29-9dff-a691d9464123@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <f2a0db3b-ac66-4b29-9dff-a691d9464123@redhat.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: oqjwxcxm1hhnny8xbggtirp4zpgxgz67
X-Rspamd-Queue-Id: E8AAE1C000B
X-HE-Tag: 1786045721-315355
X-HE-Meta: U2FsdGVkX1/F4mgiOtaI6fZPjW3NdzGeYY/yLv45lFqEynVAS/6OsxKhLU1fj8wLMgEMnXv5wIOtPs6uio/vQCIDYwyqw3zbe51CknKbyfL3cFSbNxmAjRH4oJnuFYGSdgeXYylB7VQH1lZsDH8CoQe4xtWLYzajL7BTXyM+j0y/hJpGqYyo4yWNUttVjwzDApwek7KuIX3AIjBl+tfBY7BBim7Z80PdmK9m358enX0xaj07ChNoEzaS+WWi4+dNsRW+mors0o9tfIMTFZNn91P7CYOLgawgsRJ7FSG32drb9M+5yPTbnC6Wc9I2HrnO6+jXuASZJ9L3vc1ZY3Pmph9XxgobQpIsoWBCLeg1vIS8HpYGg+IYZvN6/RSWC78/pGVNP0WuA5o8cj8D3b2cV9M7jgaO+H2DYvM9o8NhytlK9RYzyYWaRUlmuelhf2NIBTP+jiIE2FwzB2AOuiryh4TNd7OftBtsOnVihV6bxMuaakqKEf1eTFF9UnvYp1yaLwiO2eEZ8WQe4HUj9LHAKuFYdy/Ds3dOij5a6MFwnJH8RcpdNKUBh4k+pX946J8zIn+Bkx8TfWaDjdPhYvQPmRULi0k0QPDs9uFUHVgw3BwDF5IR+HZ6mpo9dDjb+BbGHePNyZRFlW20Xl4pbcQKA1aHnElared8IjjeVqqm/0U1Q/gtjN41f4fQxQY8wtCbFITYgV0tCZCrs9JFEc4f+jt7/EdmKJMGw2NTN03PQehwL/26okKaeVVXfeeFmJoH1ZpXTxpCzJWWSB6G/ZBIW1s1IKN6+f0CKFTjTt4j+rKLO8K4Um1TUD1yu1doJ1zz3tfgKKwO88esEeXZm4zKiZ2HwwF3rbnaBs3nA571SzN+TGEG3XY/BrGN5W3Mv4ofqRYjvlYN3z1yO+LvRgJlp14DUDsKdFXgag9iUhIji7HC+0nsN3E8NDRD/f6HjKLRjF9wJvt5fzSPwTCxeGI
 mY0m98wv
 2uPXYr50TbVTSDo9ZRvfNeR7z8GqR9PDOINdVBCF2XnoSYLyYJkZ9P1Gmbm1xM+dDbVkY8EMdR8hyGIYgPD4/hCYd4CCRunIlrsI3+pn3MRn0l0etu/m7UWxqNb6cecWUVMBkmX5fEC9ATjsljHaTc07LLp6aJ+U2G75E/BDRLteF2fLdVlODFra4eJCOt9oBsarIGagFg034IfAJoTrmowPqaBXmmsAnvb4d33lnnoZpxz+OwMdGakVp2JQjXouag/elfTDt+7FdyAF5W3ba9zUKhcoKgo94E6eAzuRi69DZ4w/W3JuuJG8vpTkUEkKf7yWQZtQnj43Z+HCurtwRI/4Gq3Z3J49K9U+Qrcs0RX812PZrhcoWfSiHobUpkfkApQxbMRyoYFpAp47ZD1H9SehoJpPEe/cAAC0fa8kbqDZWp8Ofouek1rUFpNJEeh5SXZHztbEThpB3teFZrB2gQyNI6DDR/YiZNqDrxkQil3uFej81vZiwIbTK7Nfv4qgu+w/pUzMfcuoicX5d3uojJBpgvpixe1YBWjaCC7V4GPG7xhwcQA+mcpoUtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 08:50:06AM +0200, Viktor Malik wrote:
>On 7/21/26 19:48, Ziyang Men wrote:
>> The libbpf + bpftool + vmlinux.h + BPF-object + skeleton build tool-chain
>> is currently duplicated across tools/testing/selftests/{bpf,sched_ext,
>> hid}/, each carrying ~100-140 lines of near-identical Makefile.  As more
>> subsystems grow BPF-based selftests, the duplication scales poorly.
>>
>> Add tools/testing/selftests/lib.bpf.mk, a single includable fragment that
>> provides the whole chain end-to-end. It builds the in-tree libbpf.a and a
>> host bpftool, generates vmlinux.h from the kernel's BTF, compiles *.bpf.c
>> into BPF objects (clang --target=bpf) and generates their skeletons. It
>> also provides what the user-space test binary needs to build: the header
>> search paths (so #includes resolve), a bpf_link macro that wraps the link
>> command, and BPF_LDLIBS, so the test can be statically linked against
>> libbpf.a.
>>
>> To use: set BPF_SRCS and OVERRIDE_TARGETS := 1 before including ../lib.mk
>> (so lib.mk's default link rule is suppressed), then include ../lib.bpf.mk
>> and list $(BPF_SKELS) as prerequisites of the test binary, e.g.,:
>>
>>     BPF_SRCS         := progs/foo.bpf.c
>>     OVERRIDE_TARGETS := 1
>>     include ../lib.mk
>>     include ../lib.bpf.mk
>>     $(OUTPUT)/foo_test: foo_test.c $(BPF_SKELS)
>>             $(call bpf_link,$@,$<)
>>
>> This saves much work for configuring selftests in other folder, such the cgroup.
>>
>> net/bpf.mk (which only builds *.bpf.o, without skeleton or vmlinux.h
>> generation) is left unchanged; replacing the existing duplication
>> mentioned above is the next step.
>>
>> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
>> Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
>> Suggested-by: Mykola Lysenko <mykolal@meta.com>
>> Assisted-by: Claude:claude-opus-4-8
>> Signed-off-by: Ziyang Men <ziyang.meme@gmail.com>
>> ---
>>  tools/testing/selftests/lib.bpf.mk | 247 +++++++++++++++++++++++++++++
>>  1 file changed, 247 insertions(+)
>>  create mode 100644 tools/testing/selftests/lib.bpf.mk
>>
>> diff --git a/tools/testing/selftests/lib.bpf.mk b/tools/testing/selftests/lib.bpf.mk
>> new file mode 100644
>> index 000000000000..6f175c6568e9
>> --- /dev/null
>> +++ b/tools/testing/selftests/lib.bpf.mk
>> @@ -0,0 +1,247 @@
>> +# SPDX-License-Identifier: GPL-2.0
>> +#
>> +# Shared fragment for selftests that compile *.bpf.c into BPF objects +
>> +# skeletons and link them into userspace test binaries, without each
>> +# subsystem's Makefile re-implementing the libbpf/bpftool/vmlinux.h machinery.
>> +#
>> +# Caller contract (per-test Makefile):
>> +#
>> +#     BPF_SRCS         := foo.bpf.c bar.bpf.c
>> +#     TEST_GEN_PROGS   := foo_test
>> +#     OVERRIDE_TARGETS := 1              # MUST be set before lib.mk
>> +#     include ../lib.mk                  # defines OUTPUT, CC, Q, msg,
>> +#     include ../lib.bpf.mk              #   selfdir, top_srcdir; honours OVERRIDE
>> +#
>> +#     $(OUTPUT)/foo_test: foo_test.c $(BPF_SKELS)
>> +#         $(call bpf_link,$@,$<)
>> +#
>> +# Optional knobs (set before including lib.bpf.mk):
>> +#   BPF_PROG_EXT     - source suffix, default .bpf.c; set to .c for the legacy
>> +#                      "progs/foo.c -> foo.bpf.o" layout.
>> +#   BPF_EXTRA_HDRS   - extra prerequisites (headers) for the BPF objects.
>> +#   BPF_EXTRA_CFLAGS - appended to BPF_CFLAGS for the BPF compile.
>> +#   BPF_SKEL_EXT     - skeleton suffix, default .skel.h (e.g. .bpf.skel.h).
>> +#   BPF_GEN_SUBSKEL  - if set, also emit a subskeleton next to each skeleton.
>> +#   BPF_OBJ_DIR      - dir for generated *.bpf.o (default $(OUTPUT)).
>> +#   BPF_SKEL_DIR     - dir for generated skeletons (default $(OUTPUT)).
>> +# A caller with unusual compile needs may override BPF_CFLAGS wholesale after
>> +# the include (the object recipe expands it lazily).
>> +# BPF_SRCS entries may live in a subdirectory (e.g. progs/foo.bpf.c); the
>> +# objects and skeletons are always emitted flat under $(OUTPUT), keyed by the
>> +# source basename (foo.bpf.o / foo.skel.h).
>> +#
>> +# lib.mk MUST be included first: this fragment consumes the vars it defines
>> +# (OUTPUT, top_srcdir, CC, CLANG, Q, msg) and needs OVERRIDE_TARGETS to have
>> +# already suppressed lib.mk's default link rule.
>> +
>> +include $(top_srcdir)/tools/scripts/Makefile.arch	# ARCH / SRCARCH
>> +# Pull in the shared toolchain definitions (HOSTCC/HOSTLD/CLANG) so this
>> +# fragment picks the *same* host compiler the libbpf and bpftool sub-makes
>> +# will: in particular HOSTCC becomes clang under LLVM=1 (gcc otherwise).
>> +# Without this the host bpftool and its bootstrap libbpf can end up built with
>> +# a mix of gcc and clang, which trips clang on gcc-only flags (-Wstrict-aliasing=3).
>> +#
>> +# Makefile.include's allow-override resets CC to a bare "clang", which would
>> +# drop the --target=<arch> flag lib.mk set for LLVM=1 cross builds (make LLVM=1
>> +# ARCH=arm64).  lib.mk ran first and configured CC for the target, so save it
>> +# across the include and restore it afterwards.
>> +lib_bpf_mk_saved_cc := $(CC)
>> +include $(top_srcdir)/tools/scripts/Makefile.include
>> +CC := $(lib_bpf_mk_saved_cc)
>> +
>> +CLANG  ?= clang
>> +HOSTCC ?= gcc
>> +HOSTLD ?= ld
>> +ifneq ($(V),1)
>> +submake_extras := feature_display=0
>> +endif
>> +
>> +# ---- paths & tools --------------------------------------------------------
>> +TOOLSDIR    := $(top_srcdir)/tools
>> +LIBDIR      := $(TOOLSDIR)/lib
>> +BPFDIR      := $(LIBDIR)/bpf
>> +TOOLSINCDIR := $(TOOLSDIR)/include
>> +BPFTOOLDIR  := $(TOOLSDIR)/bpf/bpftool
>> +APIDIR      := $(TOOLSINCDIR)/uapi
>> +
>> +# Everything generated lives under $(OUTPUT) so O= and in-tree both work and
>> +# per-test builds (distinct $(OUTPUT)) never collide.
>> +SCRATCH_DIR := $(OUTPUT)/tools
>> +BUILD_DIR   := $(SCRATCH_DIR)/build
>> +INCLUDE_DIR := $(SCRATCH_DIR)/include
>> +BPFOBJ      := $(BUILD_DIR)/libbpf/libbpf.a
>> +
>> +# bpftool must run on the *host*; split the host toolchain out when cross-building.
>> +ifneq ($(CROSS_COMPILE),)
>> +HOST_BUILD_DIR   := $(BUILD_DIR)/host
>> +HOST_SCRATCH_DIR := $(OUTPUT)/host-tools
>> +else
>> +HOST_BUILD_DIR   := $(BUILD_DIR)
>> +HOST_SCRATCH_DIR := $(SCRATCH_DIR)
>> +endif
>> +HOST_BPFOBJ     := $(HOST_BUILD_DIR)/libbpf/libbpf.a
>> +DEFAULT_BPFTOOL := $(HOST_SCRATCH_DIR)/sbin/bpftool
>> +BPFTOOL         ?= $(DEFAULT_BPFTOOL)
>> +
>> +# ---- vmlinux BTF discovery -----------------------------------------------
>> +VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
>> +		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
>> +		     $(top_srcdir)/vmlinux				\
>> +		     /sys/kernel/btf/vmlinux				\
>> +		     /boot/vmlinux-$(shell uname -r)
>> +VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
>> +ifeq ($(VMLINUX_BTF),)
>> +$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
>> +endif
>> +
>> +# ---- clang flags ----------------------------------------------------------
>> +# Clang's default system includes (not the ones seen under --target=bpf); fixes
>> +# "missing" asm/byteorder.h etc. '-idirafter' so we never shadow real includes.
>> +define get_sys_includes
>> +$(shell $(1) $(2) -v -E - </dev/null 2>&1 \
>> +	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
>> +$(shell $(1) $(2) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
>> +endef
>> +ifneq ($(CROSS_COMPILE),)
>> +CLANG_TARGET_ARCH = --target=$(notdir $(CROSS_COMPILE:%-=%))
>> +endif
>> +CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
>> +
>> +IS_LITTLE_ENDIAN = $(shell $(CC) -dM -E - </dev/null | \
>> +			grep 'define __BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__')
>> +MENDIAN = $(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)
>> +
>> +# Prefer -mcpu=v3; fall back to v2 on clang too old to know it (probed once).
>> +CLANG_BPF_CPU := $(shell $(CLANG) --target=bpf -mcpu=help 2>&1 | grep -q 'v3' \
>> +			 && echo v3 || echo v2)
>> +
>> +# -fms-extensions + -Wno-microsoft-anon-tag: required so clang accepts the
>> +# anonymous nested struct/union members bpftool emits into vmlinux.h.
>> +BPF_CFLAGS = -g -Wall -Werror -D__TARGET_ARCH_$(SRCARCH) $(MENDIAN)	\
>> +	     -I$(INCLUDE_DIR) -I$(APIDIR) -I$(TOOLSINCDIR)		\
>> +	     -std=gnu11							\
>> +	     -fno-strict-aliasing					\
>> +	     -fms-extensions -Wno-microsoft-anon-tag			\
>> +	     -Wno-compare-distinct-pointer-types			\
>> +	     $(CLANG_SYS_INCLUDES) $(BPF_EXTRA_CFLAGS)
>> +
>> +# $1 = src .bpf.c, $2 = dst .bpf.o
>> +define BPF_BUILD_RULE
>> +	$(call msg,CLNG-BPF,,$2)
>> +	$(Q)$(CLANG) $(BPF_CFLAGS) -O2 --target=bpf -mcpu=$(CLANG_BPF_CPU) -c $1 -o $2
>> +endef
>> +
>> +# ---- output dirs for generated objects/skeletons --------------------------
>> +# Default: flat under $(OUTPUT) (what bpf/, hid/, cgroup/ do).  A caller may
>> +# segregate the generated files into subdirs, e.g. BPF_SKEL_DIR := $(OUTPUT)/...
>> +BPF_OBJ_DIR  ?= $(OUTPUT)
>> +BPF_SKEL_DIR ?= $(OUTPUT)
>> +
>> +# ---- scratch dirs ---------------------------------------------------------
>> +MAKE_DIRS := $(sort $(BUILD_DIR)/libbpf $(HOST_BUILD_DIR)/libbpf		\
>> +		    $(HOST_BUILD_DIR)/bpftool $(INCLUDE_DIR)		\
>> +		    $(filter-out $(OUTPUT),$(BPF_OBJ_DIR) $(BPF_SKEL_DIR)))
>> +$(MAKE_DIRS):
>> +	$(call msg,MKDIR,,$@)
>> +	$(Q)mkdir -p $@
>> +
>> +# ---- libbpf (target) ------------------------------------------------------
>> +# Pass ARCH/CROSS_COMPILE/CC through: lib.mk's CC is file-origin and is not
>> +# exported, so without this the libbpf sub-make would rebuild for the host under
>> +# a pure-LLVM cross build (make LLVM=1 ARCH=<arch>).  -fPIC keeps the static
>> +# libbpf linkable into position-independent (PIE) test binaries.
>> +$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile) \
>> +	   $(APIDIR)/linux/bpf.h | $(BUILD_DIR)/libbpf
>> +	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(BUILD_DIR)/libbpf/ \
>> +		    ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) CC="$(CC)"     \
>> +		    EXTRA_CFLAGS='-g -O0 -fPIC'				      \
Hi Viktor, 

Thanks for your suggestions!
>
>Looking at the same line in tools/testing/selftests/bpf/Makefile:
>
>            EXTRA_CFLAGS='-g $(OPT_FLAGS) $(SAN_CFLAGS) $(EXTRA_CFLAGS)' \
>
>is there a reason why this is not respected and -O0 and -fPIC are
>hard-coded?
Yes it is true that there is no good reason. I will fix it in the next version.

>What if someone wants to build selftests (including libbpf)
>with -O2 and some additional flags?
I will add a flag such as OPT_FLAGS ?= $(if $(RELEASE),-O2,O0), which follows
the pattern in the bpf/Makefile:37. So if we run 
$ make -> -g -O0 -fPIC (taget libbpf) and -g -O0 (host bpftool)
$ make RELEASE=1 -> -g -O2 -fPIC (taget libbpf) and -g -O2 (host bpftool)

>Is that possible with the new
>lib.bpf.mk? It would be nice if it used at least EXTRA_CFLAGS or
>USERCFLAGS defined in lib.mk.
Good idea. I will add the EXTRA_CFLAGS for target libbpf, host libbpf and host
bpgtool. Such that: 
$ make OPT_FLAGS=-O2 EXTRA_CFLAGS=-DFOO -> -g -O2 -fPIC -DFOO (for target
libbpf) and -g -O2 -DFOO (for host bpftool)

>
>Same questions would apply to other rules for libbpf and bpftool below.
I would check it them as as well in next version.

>Thanks!
>Viktor
>
>
Thanks for your time and reviewing. Please let me know your concerns. Thanks!

Best,
Ziyang

>> +		    DESTDIR=$(SCRATCH_DIR) prefix= all install_headers
>> +
>> +# ---- libbpf (host) -- a distinct rule only when cross-compiling -----------
>> +ifneq ($(BPFOBJ),$(HOST_BPFOBJ))
>> +$(HOST_BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile) \
>> +		| $(HOST_BUILD_DIR)/libbpf
>> +	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) ARCH= CROSS_COMPILE=	      \
>> +		    OUTPUT=$(HOST_BUILD_DIR)/libbpf/ CC=$(HOSTCC) LD=$(HOSTLD) \
>> +		    EXTRA_CFLAGS='-g -O0'				      \
>> +		    DESTDIR=$(HOST_SCRATCH_DIR) prefix= all install_headers
>> +endif
>> +
>> +# ---- bpftool (host) -------------------------------------------------------
>> +$(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile) \
>> +		    $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)/bpftool
>> +	$(Q)$(MAKE) $(submake_extras) -C $(BPFTOOLDIR)		  \
>> +		    ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD) \
>> +		    EXTRA_CFLAGS='-g -O0'			  \
>> +		    OUTPUT=$(HOST_BUILD_DIR)/bpftool/		  \
>> +		    LIBBPF_OUTPUT=$(HOST_BUILD_DIR)/libbpf/	  \
>> +		    LIBBPF_DESTDIR=$(HOST_SCRATCH_DIR)/		  \
>> +		    prefix= DESTDIR=$(HOST_SCRATCH_DIR)/ install-bin
>> +
>> +# ---- vmlinux.h ------------------------------------------------------------
>> +$(INCLUDE_DIR)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL) | $(INCLUDE_DIR)
>> +ifeq ($(VMLINUX_H),)
>> +	$(call msg,GEN,,$@)
>> +	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
>> +else
>> +	$(call msg,CP,,$@)
>> +	$(Q)cp "$(VMLINUX_H)" $@
>> +endif
>> +
>> +# ---- BPF objects + skeletons ---------------------------------------------
>> +# Sources may sit in a subdir and use the modern *.bpf.c or the legacy *.c
>> +# suffix (BPF_PROG_EXT); objects go in $(BPF_OBJ_DIR) and skeletons in
>> +# $(BPF_SKEL_DIR) (both default to $(OUTPUT)), keyed by the source basename.
>> +BPF_PROG_EXT ?= .bpf.c
>> +bpf_stems := $(patsubst %$(BPF_PROG_EXT),%,$(notdir $(BPF_SRCS)))
>> +# The output namespace is flat, so two sources with the same basename would
>> +# collapse into one object/skeleton; fail loudly instead of silently dropping.
>> +ifneq ($(words $(bpf_stems)),$(words $(sort $(bpf_stems))))
>> +$(error lib.bpf.mk: BPF_SRCS has colliding basenames: $(BPF_SRCS))
>> +endif
>> +# BPF_SKEL_EXT lets a caller pick the skeleton suffix (default .skel.h; e.g.
>> +# .bpf.skel.h).  With BPF_GEN_SUBSKEL set, a matching subskeleton is emitted
>> +# alongside (foo.subskel.h / foo.bpf.subskel.h).
>> +BPF_SKEL_EXT    ?= .skel.h
>> +BPF_SUBSKEL_EXT := $(patsubst %skel.h,%subskel.h,$(BPF_SKEL_EXT))
>> +BPF_OBJS  := $(addprefix $(BPF_OBJ_DIR)/,$(addsuffix .bpf.o,$(bpf_stems)))
>> +BPF_SKELS := $(addprefix $(BPF_SKEL_DIR)/,$(addsuffix $(BPF_SKEL_EXT),$(bpf_stems)))
>> +
>> +# Locate the sources wherever the caller keeps them (e.g. progs/).
>> +vpath %$(BPF_PROG_EXT) $(sort $(dir $(BPF_SRCS)))
>> +
>> +$(BPF_OBJS): $(BPF_OBJ_DIR)/%.bpf.o: %$(BPF_PROG_EXT) $(BPF_EXTRA_HDRS) \
>> +	     $(wildcard *.bpf.h) $(INCLUDE_DIR)/vmlinux.h | $(BPF_OBJ_DIR) $(BPFOBJ)
>> +	$(call BPF_BUILD_RULE,$<,$@)
>> +
>> +$(BPF_SKELS): $(BPF_SKEL_DIR)/%$(BPF_SKEL_EXT): $(BPF_OBJ_DIR)/%.bpf.o $(BPFTOOL) | $(BPF_SKEL_DIR)
>> +	$(call msg,GEN-SKEL,,$@)
>> +	$(Q)$(BPFTOOL) gen object $(<:.o=.linked.o) $<
>> +	$(Q)$(BPFTOOL) gen skeleton $(<:.o=.linked.o) name $(notdir $(<:.bpf.o=)) > $@
>> +ifneq ($(BPF_GEN_SUBSKEL),)
>> +	$(Q)$(BPFTOOL) gen subskeleton $(<:.o=.linked.o) name $(notdir $(<:.bpf.o=)) > $(@:$(BPF_SKEL_EXT)=$(BPF_SUBSKEL_EXT))
>> +endif
>> +
>> +# ---- exports consumed by the caller --------------------------------------
>> +# -I$(OUTPUT)/-I$(BPF_SKEL_DIR): so the test .c can #include "foo.skel.h".
>> +# -I$(INCLUDE_DIR): so userspace can pull in the generated vmlinux.h if needed.
>> +CFLAGS += -I$(OUTPUT) -I$(BPF_SKEL_DIR) -I$(INCLUDE_DIR)
>> +
>> +# Static libbpf.a first, then its deps. libbpf may pull in zstd (BTF decompress)
>> +# only when built against it; link -lzstd only if libzstd is present.
>> +BPF_LDLIBS := $(BPFOBJ) -lelf -lz
>> +ifneq ($(shell pkg-config --exists libzstd 2>/dev/null && echo y),)
>> +BPF_LDLIBS += -lzstd
>> +endif
>> +
>> +TEST_GEN_FILES += $(BPF_OBJS)
>> +
>> +# Link helper: $1 = output binary, $2 = test .c (skels are the target's deps).
>> +define bpf_link
>> +	$(call msg,BINARY,,$1)
>> +	$(Q)$(CC) $(CFLAGS) $2 $(BPF_LDLIBS) $(LDLIBS) -o $1
>> +endef
>> +
>> +EXTRA_CLEAN += $(SCRATCH_DIR) $(HOST_SCRATCH_DIR)			\
>> +	       $(addprefix $(BPF_OBJ_DIR)/,*.bpf.o *.linked.o)		\
>> +	       $(addprefix $(BPF_SKEL_DIR)/,*$(BPF_SKEL_EXT) *$(BPF_SUBSKEL_EXT))
>

