Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B37D9C87FCF
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 12:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B7566B00A9; Sun, 10 Aug 2025 08:58:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38EEF6B00AA; Sun, 10 Aug 2025 08:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A52E6B00AB; Sun, 10 Aug 2025 08:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 126E26B00A9
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 08:58:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81AFD58D49
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:58:03 +0000 (UTC)
X-FDA: 83760850446.08.7BF56CF
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf26.hostedemail.com (Postfix) with ESMTP id 968E3140009
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 12:58:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OuNV99Ds;
	spf=pass (imf26.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754830681; a=rsa-sha256;
	cv=none;
	b=1e8Yi2k4ngCp1n5RAtWE1/fCXlbgkt+fJB+qh5dpC117huD3M/MrAOi4S4BuePludefvZ1
	hDuKcwbLnvsBqmpOmfXaTGEKYEBENiTrUI2S8VbNGezh6N5xqN9ckbNzdjDX0a+l/g40pq
	mWM8DlebpTSIMf5DDUKEykXeBx9SGcs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OuNV99Ds;
	spf=pass (imf26.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754830681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fLpTR6tAuSk7MmdRr1bx3cY7Ji1Fi9DhOlpvPdNYklM=;
	b=lVVLyOQbw1UyoNOV2mvvJP8JcxlxfLtDaUXaxg1A9LmSe6lZm8mTgBAt/ftWCj9ouM+IwF
	vY0Wjt89BhMJWzgScBWLxpk6Rr1PAC21fjJJ2gNqRWcCwFiuaTJ7sv0uWTzgfI1fVKLWQP
	bFl/mkLkOWirx6YGY1KpKGC8NJJVSgI=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-32b5931037eso27923311fa.2
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 05:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754830680; x=1755435480; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fLpTR6tAuSk7MmdRr1bx3cY7Ji1Fi9DhOlpvPdNYklM=;
        b=OuNV99Ds9AZWi1Gq8Uxt7SZgLmuvwEeDDhPRrQlMAHQ36IAlsyYYRvbYmGfhkfPTjA
         slfXf5yyleff0QCMrQ6t3QtbHKSncBeWPKDS9LGnUpWQd1Ds3A7TLB42YvDNTdeMMDxL
         TiGAXHfMIbGtgT2eN+snvjcqEYkYPvD1nfY+niUayYjLAjXw+xRpcvFozWxYaJr9wl0k
         r6Fs5AGANoMuEqHGau0VCRMvsWZllH0qanWZ5S5GicjY8ocOLk8z/jiqqyolSo0bu6Tb
         sPzeBFkUl3sMyMPbOR7D4rtk+6oJgCFtbrCAJ0JFI7Hp7CC3302SUp+50UvkeeUVy3Q4
         5g4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754830680; x=1755435480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fLpTR6tAuSk7MmdRr1bx3cY7Ji1Fi9DhOlpvPdNYklM=;
        b=fqhTfYYapPkHPjO0juyf5wfnRynH1Xi/qYu53tmK1pjb9AhynB1IffReWberWeVUkL
         LkCQ5QFQyLFDBaaIfrZswsoWGuV0S/mY++dDAXfPLUavSZ68xyw3aA66CFX6SqK4YLo1
         s0SbbSA7g252xWdR1hCcpP39ib35ytFPx66RMvFz7g1GpgeMsgVvqKJf3JcZ7Q74L5tr
         TQdy9sJLID5jVtUTnPv3bOMeH5kntfyNIBiESsiI0xLp2Bp7TLJPTrurYde8Se6xNoq/
         EzN80IHC76yxMRwjRJIkT4siIu/9CNZB3r2dR6+H8QBn2DuBFGr5a7zG+gM3ud2Dnj1b
         3DtA==
X-Forwarded-Encrypted: i=1; AJvYcCUl26gO1/jYvPIB591rLegLtQ9Af4RcS4/u+SiWm9VKt1nJk9S067yeXkcjYvjXUJjdwieiAUWa6A==@kvack.org
X-Gm-Message-State: AOJu0Yz2iQDXyRJexSxr+ZsXThUqRBlRy0iRN+bOSkGhcCUmLqf/FjHw
	LgV1dvDILSs6sfVbV7PQJceN/EveQi/m84l50iEydGuoH4tZ5fDTW1x8
X-Gm-Gg: ASbGncviEQVsWQCPxtTJrQ3ezR8W4pByPH8r1VYoeLUqwFF65nWEfJ5ITBxx9QZvOqI
	yiPhX3ocTOIq1vY3zBGsADzvhGcOvjJHAmDTeCPZbcgcyLSrmhaTbVeBDUTSnAxnb3PE2W4owuY
	3AWv6wvBUjrxL0FGeucv3rFvLAri5J9yJXO56zWZj2bijdUqgtbngBTXsAq7bu5JunR73odxnNy
	MksETHRgzB4BsFRC4opG8lGr1SQEW9qHQ2Hj3HR4Zl3lg0L/6xLmsI7+wUwh1LR8WcNrrRe5ckp
	YDLUhOYckGq16s4uIl2In3G5LQBGgMjX0wp3o83vepojc5pCx6EzhvKcZEH1aw5YpUNqkSn9nut
	DDIvme5r0fQmygZjJhi0tMXLoRCMvBhEVEFGbkw==
X-Google-Smtp-Source: AGHT+IGP/4+VH4qZJqmI6pqOQcdamwMMjmUjwyAr9JTcQGvwe1pb2iGdV8kKhr91VYx69eEOJbHKcQ==
X-Received: by 2002:a05:6512:2313:b0:55b:8397:cffd with SMTP id 2adb3069b0e04-55cc00ada77mr2589766e87.9.1754830679327;
        Sun, 10 Aug 2025 05:57:59 -0700 (PDT)
Received: from localhost.localdomain ([2a03:32c0:2e:37dd:bfc4:9fdc:ddc6:5962])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88c9908esm3804561e87.76.2025.08.10.05.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Aug 2025 05:57:58 -0700 (PDT)
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
To: ryabinin.a.a@gmail.com,
	christophe.leroy@csgroup.eu,
	bhe@redhat.com,
	hca@linux.ibm.com,
	andreyknvl@gmail.com,
	akpm@linux-foundation.org,
	zhangqing@loongson.cn,
	chenhuacai@loongson.cn,
	davidgow@google.com,
	glider@google.com,
	dvyukov@google.com,
	alexghiti@rivosinc.com
Cc: alex@ghiti.fr,
	agordeev@linux.ibm.com,
	vincenzo.frascino@arm.com,
	elver@google.com,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-mm@kvack.org,
	snovitoll@gmail.com
Subject: [PATCH v6 0/2] kasan: unify kasan_enabled() and remove arch-specific implementations
Date: Sun, 10 Aug 2025 17:57:44 +0500
Message-Id: <20250810125746.1105476-1-snovitoll@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 968E3140009
X-Stat-Signature: yx7wb7xttzxwzk1jy835itns36oea7uu
X-HE-Tag: 1754830681-375030
X-HE-Meta: U2FsdGVkX18VuKXqid1rxp2mDbSdEzjUHBqEvQoejHvo2bnwzBxyh4xTTt30SF7j0rhg8rAIejrw3Uj1PJOBf3N7SSNsxZziOP5RiVHPLV2GdNhpY3tYxNFPImxvej3iWV0oNLwPrQPKyzJ4Dzs1B6xfLgblYMxwF/iKI79ElbGwZGkMYb0Vfl2Nb0H3VCU7AOnpj8MTw9CQgj5fNdg2xtyC55486CsSDEJpFsHmdbkHFtNm4tjfwAme2i3lonarDhKeJfRKwdji60/6KC2U2Wu7d25AjdPrtq4leeIcoS+gD5dJwvFNj7FaIJJdnddKQcdYhgfcCbVsT11BeyD+eQ4xIlZLGqfG1oLr6c3kca/xIPVWuGUsfIcW1QdpKMehHWNQ9R1386Z8+JD1YZO1pOF2B29MKkmQx6kSKN/wo4xrra3fUWwgr/KRRjXJ853OEGzHzH9/JVHZR97okxfbpSJ3dl6hYB8vGO4U6ccBZA3SU1PXRHWZw/pvnXglB9vDv19vlTZt4ipY50QvmdyhS/poAWA9szSS59jDTJoY4s45g1M8OjSGquM2S6v9fqTSQ1Sf7cUVpDczJ1IXfr0SZRvhdFKZPF+BA4+q8qJ13eeyIOWXluAMHzfL1AxYcIvgxM4c1R8VlksdkLyURwxl6bISyxtJo15reJC/+QzNllaUOqJXnGCsV2DVOgYnE53PSRxeF7aezQO0bEQL7kaSZ/8Vjg9beb6d49cCpqeXqiRVDb9SBU8xm6htuEuQvHXGcvlFOCNtDVlYPhdR0m92B9sFp/V73RC2eH+/nVVo/GYvrW+JhgPdsCNi2R1kZPWPmBhFd+RxR8HhX8MEHsOf223b7G6WwW+EnxoEHE5UuB1knoPmF3Vy/cBjxRKEbZB4O3gWTdz4I2HLo5QfGJlZ4OlVbefOPqAD6hTE0QSPZobFltzRfmsv/Rcs5aE+BZIdfjdyHCKBG/mvvcaXvbr
 ql2IpXZ1
 lq9HYWMwqhGvOPjU1w1irUhjkPKZCpnfd+PzEp5gCMy1mOb/ZfPy+JoNu5WMMtUgSIwcyzhEblTApBtU9R+7pCIcV5mxjd+iUrbttP7GP4rjEOEc0+NDG52YpuNhEdg5rPles8nNMeV/eaFMXVM0Cz8mR+jq/8lykFvBupU4LsqiWqDjx8sp8wz2j/KjjycVS6C3LjDQ/s7b7C0GYkl1dDY7jhs2R1bG1gi1eu7E4PTlje1IFg242qPkbu5oX3pAUPurXWsfS/QldsRnx7T1uSxUKfPa+CdlxQRivaDR1tJLdGSfeR2rMERK46QpDJNR3FbpdHFHyA9idfG+8pNZ8VfXIpp9S+0iFjDR18KkEsABr4EUIFd1SlqI4aiLDunCnqUBvA8qF8WtKstCbdeRPfz0u4DA5tgGYqpNX1oglWlgX1yNENgMkrRQj2HH3icqqn5GM0PKLbXe7XnYdGfmlQP921rcfmB/dOHu4K9rDrlxOCmr4h6xemP95yNSmari8DNLTjSQbXzaYrEcJ6QZYXQ5Ycpekqnul+/Ruy+TVCgeJ776mNn7wQa3pxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series addresses the fragmentation in KASAN initialization
across architectures by introducing a unified approach that eliminates
duplicate static keys and arch-specific kasan_arch_is_ready()
implementations.

The core issue is that different architectures have inconsistent approaches
to KASAN readiness tracking:
- PowerPC, LoongArch, and UML arch, each implement own kasan_arch_is_ready()
- Only HW_TAGS mode had a unified static key (kasan_flag_enabled)
- Generic and SW_TAGS modes relied on arch-specific solutions
  or always-on behavior

Changes in v6:
- Call kasan_init_generic() in arch/riscv _after_ local_flush_tlb_all()
- Added more details in git commit message
- Fixed commenting format per coding style in UML (Christophe Leroy)
- Changed exporting to GPL for kasan_flag_enabled (Christophe Leroy)
- Converted ARCH_DEFER_KASAN to def_bool depending on KASAN to avoid
        arch users to have `if KASAN` condition (Christophe Leroy)
- Forgot to add __init for kasan_init in UML

Changes in v5:
- Unified patches where arch (powerpc, UML, loongarch) selects
  ARCH_DEFER_KASAN in the first patch not to break
  bisectability. So in v5 we have 2 patches now in the series instead of 9.
- Removed kasan_arch_is_ready completely as there is no user
- Removed __wrappers in v4, left only those where it's necessary
  due to different implementations

Tested on:
- powerpc - selects ARCH_DEFER_KASAN
Built ppc64_defconfig (PPC_BOOK3S_64) - OK
Booted via qemu-system-ppc64 - OK

I have not tested in v4 powerpc without KASAN enabled.

In v4 arch/powerpc/Kconfig it was:
	select ARCH_DEFER_KASAN			if PPC_RADIX_MMU

and compiling with ppc64_defconfig caused:
  lib/stackdepot.o:(__jump_table+0x8): undefined reference to `kasan_flag_enabled'

I have fixed it in v5 via adding KASAN condition:
	select ARCH_DEFER_KASAN			if KASAN && PPC_RADIX_MMU

- um - selects ARCH_DEFER_KASAN

KASAN_GENERIC && KASAN_INLINE && STATIC_LINK
	Before:
		In file included from mm/kasan/common.c:32:
		mm/kasan/kasan.h:550:2: error: #error kasan_arch_is_ready only works in KASAN generic outline mode!
		550 | #error kasan_arch_is_ready only works in KASAN generic outline mode

	After (with auto-selected ARCH_DEFER_KASAN):
		./arch/um/include/asm/kasan.h:29:2: error: #error UML does not work in KASAN_INLINE mode with STATIC_LINK enabled!
		29 | #error UML does not work in KASAN_INLINE mode with STATIC_LINK enabled!

KASAN_GENERIC && KASAN_OUTLINE && STATIC_LINK && 
	Before:
		./linux boots.

	After (with auto-selected ARCH_DEFER_KASAN):
		./linux boots.

KASAN_GENERIC && KASAN_OUTLINE && !STATIC_LINK
	Before:
		./linux boots

	After (with auto-disabled !ARCH_DEFER_KASAN):
		./linux boots

- loongarch - selects ARCH_DEFER_KASAN
Built defconfig with KASAN_GENERIC - OK
Haven't tested the boot. Asking Loongarch developers to verify - N/A
But should be good, since Loongarch does not have specific "kasan_init()"
call like UML does. It selects ARCH_DEFER_KASAN and calls kasan_init()
in the end of setup_arch() after jump_label_init().

Previous v5 thread: https://lore.kernel.org/all/20250807194012.631367-1-snovitoll@gmail.com/
Previous v4 thread: https://lore.kernel.org/all/20250805142622.560992-1-snovitoll@gmail.com/
Previous v3 thread: https://lore.kernel.org/all/20250717142732.292822-1-snovitoll@gmail.com/
Previous v2 thread: https://lore.kernel.org/all/20250626153147.145312-1-snovitoll@gmail.com/

Sabyrzhan Tasbolatov (2):
  kasan: introduce ARCH_DEFER_KASAN and unify static key across modes
  kasan: call kasan_init_generic in kasan_init

 arch/arm/mm/kasan_init.c               |  2 +-
 arch/arm64/mm/kasan_init.c             |  4 +---
 arch/loongarch/Kconfig                 |  1 +
 arch/loongarch/include/asm/kasan.h     |  7 ------
 arch/loongarch/mm/kasan_init.c         |  8 +++----
 arch/powerpc/Kconfig                   |  1 +
 arch/powerpc/include/asm/kasan.h       | 12 ----------
 arch/powerpc/mm/kasan/init_32.c        |  2 +-
 arch/powerpc/mm/kasan/init_book3e_64.c |  2 +-
 arch/powerpc/mm/kasan/init_book3s_64.c |  6 +----
 arch/riscv/mm/kasan_init.c             |  1 +
 arch/s390/kernel/early.c               |  3 ++-
 arch/um/Kconfig                        |  1 +
 arch/um/include/asm/kasan.h            |  5 ++--
 arch/um/kernel/mem.c                   | 13 ++++++++---
 arch/x86/mm/kasan_init_64.c            |  2 +-
 arch/xtensa/mm/kasan_init.c            |  2 +-
 include/linux/kasan-enabled.h          | 32 ++++++++++++++++++--------
 include/linux/kasan.h                  |  6 +++++
 lib/Kconfig.kasan                      | 12 ++++++++++
 mm/kasan/common.c                      | 17 ++++++++++----
 mm/kasan/generic.c                     | 19 +++++++++++----
 mm/kasan/hw_tags.c                     |  9 +-------
 mm/kasan/kasan.h                       |  8 ++++++-
 mm/kasan/shadow.c                      | 12 +++++-----
 mm/kasan/sw_tags.c                     |  1 +
 mm/kasan/tags.c                        |  2 +-
 27 files changed, 113 insertions(+), 77 deletions(-)

-- 
2.34.1


