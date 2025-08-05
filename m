Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D10C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:26:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 837798E000A; Tue,  5 Aug 2025 10:26:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80F0B8E0001; Tue,  5 Aug 2025 10:26:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB9E8E000A; Tue,  5 Aug 2025 10:26:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 605658E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:26:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2FCCEC04B6
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:32 +0000 (UTC)
X-FDA: 83742929424.26.241348F
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id 47682C0011
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:26:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eaiJq9wx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754403990; a=rsa-sha256;
	cv=none;
	b=1YbYS1RZkoRKN8A/Bd66WanjSBkjMrniAp8Ee1IiYQuFCxkn86KomHq2lfVoZW6kVKveww
	OzsqeIKQ0CPmDB/3k79p6ipks45kerVIaCJL1zdwdq6ruG+XaXsFLlL6xkH+dt3AzkH7ae
	4dQpF+dhqZwa8YsjHQ1CqyMygsuOIrE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eaiJq9wx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754403990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pksKKRBtO31JVCyUig2REP3M3oI0Y/m5ILEfob1JeTo=;
	b=Lv4yJluCyPlx9p35oJVV7drNylWOw+tl+YRdS0Dkr4bkryIGAPUOPl+r3HNjeUw1J7XXiA
	xa7HqrBKf0WVI6GhyVueH1H+dSfYdni7NTjlI8IxFRHMvZx3WVhshsmxrR98xmUbWtbMQk
	srQLeVfzBvxAKosymdvvF0vPo5EqMmc=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-55b9c2482e9so3261733e87.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 07:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754403988; x=1755008788; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pksKKRBtO31JVCyUig2REP3M3oI0Y/m5ILEfob1JeTo=;
        b=eaiJq9wxBfZNM2CrLDn7nUgJoHSE1hBAt/eU9WEhPgk75jS3bqyJN/p47j/l9VITcP
         NbZD2zooePUJwGWiFqlRhRTEDgd/LIi3IEqOMV4b2LASVgW9M72MiwFDkOl1/3jfp4aa
         mNrmr34RBJmhH5baHJ0cUbhq2cpbmNvMC3UYh9jI1nd4FxC6/5G2Uct36Vq6Y+1ElpX+
         vk04PoYPV5zQJCBr0h7DNiBAW6v985DDCiQ8T3KyvAwqTZ5zFzxmQ0ro5zl4QnSTSw11
         kr4QcgCsp3ERw4Pj2PrG6w6x+0ELcG3pNOcJ+OocjnijquUxsfzNB2wnwNqIQL7435HT
         WwVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754403988; x=1755008788;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pksKKRBtO31JVCyUig2REP3M3oI0Y/m5ILEfob1JeTo=;
        b=tfL9PnV6KzhjhatJtsFKs7XqIt9Ar9tnOT/K6inHjt/2EBWvgJThp8HE1zel9sL8B5
         n+qPYcr1qMEFMKnjCKkNa3SgWwA4kS5owePW2fvhTlAZ1tODbYcl7gdEN9pzp+rJiedL
         onmpDSFzD6D4b3kyyP2AAB+iD4Mj1A0+jjGFmCNTws964Z1TW+OLwAMR0znKcfvXgGbY
         mX+f/DZ3sR9SIV0eM44JN2ewfl4hICjGRu81MOVaD6iz3DmM0OvjtZYSIfVBq0MOL8ll
         qjOU3PKgtHENkptmoX2vMABHd2VXcypAcTc2Hgn362j7GCQNjEU2UfXFAzIinVgLBhVY
         QCQg==
X-Forwarded-Encrypted: i=1; AJvYcCWa4lNVtwifY7MznLUS+J4eMTxoWGTj98MKGjn1Z7Bw6kRmjQysqIld8QVhmCjkst2YBCMvvz8GIA==@kvack.org
X-Gm-Message-State: AOJu0YxqhmfBdUHrD1YZqTJbodrJJsGYpqv2fufQXNQl0kRUknyqfrH6
	7H8gmHCGQje7VU/WDK7nLrcIDwExFKWmV9GpAOhbCREu2VllxLq/w16y
X-Gm-Gg: ASbGncuz17+D1Nf0uG2ioqOV8f6dHCeKWvFxS33N0wTU+H9qiJ2TezoaI7bTXrRoLG9
	v4RSl4TEmItewUZteAq9ps2Db62VU3jLUCQ4Krl5guYwW7S0AFt7TnBeujSzC78LQ72zFELOIhA
	69try5fLdQ3lla7MgJ6rwaj0msppZQC7j4eji2o/W3JZqtk8fVjbgDgN8nKJnoGJwzxEOyJC1Fi
	wqLJFwejJNmkobdFMeFQ2DC17bity0xY51m6ZlbWt6eHMPH5xizmXpcIMmfUYwmlhc/Dl7fV9SX
	uOw6OxHzK/ZtYjbOjJ+ja8TA4uFCEsMgzNbxGdQmVYSwY3k3QJ0DeW756WVQa9nqeRaZFp363kc
	7FN1DXD+i6cCkBV997qR4K56T9LM9rpgptW7D/nu1xms3gnTnLElvF4EYsLxQkVnIaf6irw==
X-Google-Smtp-Source: AGHT+IGy1WhFbslChqIwW3zDEXwo6CDb6xK1zgNUQQFWNlekigvy4oRcbBK1ihRZGuO8OayIKRf+qA==
X-Received: by 2002:a05:6512:39cc:b0:55b:9647:8e7b with SMTP id 2adb3069b0e04-55b97b75a15mr4601956e87.43.1754403988090;
        Tue, 05 Aug 2025 07:26:28 -0700 (PDT)
Received: from localhost.localdomain (178.90.89.143.dynamic.telecom.kz. [178.90.89.143])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b889a290fsm1976379e87.54.2025.08.05.07.26.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 07:26:27 -0700 (PDT)
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
To: ryabinin.a.a@gmail.com,
	hca@linux.ibm.com,
	christophe.leroy@csgroup.eu,
	andreyknvl@gmail.com,
	agordeev@linux.ibm.com,
	akpm@linux-foundation.org,
	zhangqing@loongson.cn,
	chenhuacai@loongson.cn,
	trishalfonso@google.com,
	davidgow@google.com
Cc: glider@google.com,
	dvyukov@google.com,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-mm@kvack.org,
	snovitoll@gmail.com
Subject: [PATCH v4 0/9] kasan: unify kasan_arch_is_ready() and remove arch-specific implementations
Date: Tue,  5 Aug 2025 19:26:13 +0500
Message-Id: <20250805142622.560992-1-snovitoll@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f39mrpyoni9grrabenp9dgzdju1hcxj5
X-Rspam-User: 
X-Rspamd-Queue-Id: 47682C0011
X-Rspamd-Server: rspam02
X-HE-Tag: 1754403990-46175
X-HE-Meta: U2FsdGVkX19WWeZVANAE5jhfSBXGfqGMKffQ69GzovNEQZX3H7GIe7oNSyvu1Thkr93qFoqjtS2P3B2hqLCvprcIUyaTEuyHlPH+iv0VW+Bwc12fKU+DU6lCOB6UpHmOjy9I9khnD3eIs+FUPQ/DzjaX/thbBfCcQfnBHnQF1C2M4GlqY9m9ZRLM/buMkB5OzlwW2AzbvUaZzyPRhjceF/j0PT4zF/pEuYsbs7JGd5nupoWoiDDKP55cI7qjVuFhvdJhTtNh9gSF17RrJa+eRoDGxUEL4zYo7ekxdhcY0KHQnxqiUP0MVgGG/4XyHifNVm6tOC9FWOggRATu36uESKs//1vu3xtKlPzGGxrHB9CKAvU50qyTIiOmq2DPyEOoUlUuAcCUHjgi1UhXD/5Njak5udftFf/IBhQL0d7u0xVYGl8hXI5mM9gOfvI9Hqy2v8jooX6v4U1XoOKjmemNRkSoaN9tx5CtqlfjjTD9wHZ+8iKOXD52oMbAAjpToP5sadE57mWPf6styDK9lEem6mfbCSzaXuLq2hnLU9w7Bjk3THAG0MIfAvAnXb1MLz3pnXxW6oSrjmavhHeJxGT+pfEZ5lyIFpPics88PLmK/XdvkaNJdo+nTT5K8szsbARXJpZEf2lMEkPalsT6gFKiMl+a3bsx42iFhnTP9WXxhHRnsjQKczpBgrEIBFtmT+Fxy/rDiZ42bmkt4TIBZMpyG7eXIasyVhovlZaqiUJEXqEyoRN4kfDImxgS6P9Aejo+m508ZGoro6nvsGSrgqRDrsIbz1vG3ZRUvij+pNzw7WNqRtZzX2pRy0eXYz80PRvj5Z12WRB4UanYPrC7QGFgl2rqbzd/veydSUMMVrulvTJi2yQiiq8VaWkwbve/miZbJ+zbGaalQGoBJkkT/8g7dijodIZUvNrCCLYInFt/x7QhrSgEjzZYd496hixvDoUJ01pFboFvK5LS8KNMpat
 26LMiyFY
 6xlnlY680pqJlthOJfSlkd2xONyFyHuEU3ehYUYL+hh0SXw4oQHLywWr6NUSnT9HT8f743rQ5KNKTY/Z55w6F8CMQTvkzKOKju54xPvVgp2eVmzYyAP75ho37G5s+fd5ut77BiX445YKkpItzckkgUCkeHeLZBAk8d0vwgDZ0g58P/mB51skhmzH1ztoCRCedAa7leD9tRki9cqCXMrVwlathrbGUwex5s5j0AMIA7k5ehN0cBy94wd5Koi0o2YyNyQjXoJ5uzMxtlczzyE+yto3TSaqZu9Ef/KH92FFHKo624iQtOF1STcPbTbIqT6zWBIG6pViKdDebIx2WxMd11Qlp8+oJ43j0dWMV2c8G/CT+oSAEnuzK0DOyrR6kdmXLVWUp0N8hl1chDF1tt/xeWlzKm+UrUVGoUOys5zC0vbzw92UBfbTzBmcszG9uuV3YDAYtiGxOjmJpe67EP4onxbDZwdug348zk31XTd2FfizwHg+upQ5iZf+oUzO62OjZMJOihBZnqIXYax7Qiyca/Tu77O65az0/cR76w/RsKQdwmsyE9pMRyWvEWw==
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

This series implements two-level approach:
1. kasan_enabled() - compile-time check for KASAN configuration
2. kasan_shadow_initialized() - runtime check for shadow memory readiness

Changes in v4:
- Unified patches where ARCH_DEFER_KASAN is introduced and used
  in the KASAN code (Andrey Ryabinin)
- Fixed kasan_enable() for HW_TAGS mode (Andrey Ryabinin)
- Replaced !kasan_enabled() with !kasan_shadow_initialized() in
  loongarch which selects ARCH_DEFER_KASAN (Andrey Ryabinin)
- Addressed the issue in UML arch, where kasan_init_generic() is
  called before jump_label_init() (Andrey Ryabinin)

Adding in TO additional recipients who developed KASAN in LoongArch, UML.

Tested on:
- powerpc - selects ARCH_DEFER_KASAN
Built ppc64_defconfig (PPC_BOOK3S_64) - OK
Booted via qemu-system-ppc64 - OK

- um - selects ARCH_DEFER_KASAN
Built defconfig with KASAN_INLINE - OK
Built defconfig with STATIC_LINK && KASAN_OUTLINE - OK
Booted ./linux - OK

- loongarch - selects ARCH_DEFER_KASAN
Built defconfig with KASAN_GENERIC - OK
Haven't tested the boot. Asking Loongarch developers to verify - N/A
But should be good, since Loongarch does not have specific "kasan_init()"
call like UML does. It selects ARCH_DEFER_KASAN and calls kasan_init()
in the end of setup_arch() after jump_label_init().

- arm64
Built defconfig, kvm_guest.config with HW_TAGS, SW_TAGS, GENERIC - OK
KASAN_KUNIT_TEST - OK
Booted via qemu-system-arm64 - OK

- x86_64
Built defconfig, kvm_guest.config with KASAN_GENERIC - OK
KASAN_KUNIT_TEST - OK
Booted via qemu-system-x86 - OK

- s390, riscv, xtensa, arm
Built defconfig with KASAN_GENERIC - OK

Previous v3 thread: https://lore.kernel.org/all/20250717142732.292822-1-snovitoll@gmail.com/
Previous v2 thread: https://lore.kernel.org/all/20250626153147.145312-1-snovitoll@gmail.com/

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217049

Sabyrzhan Tasbolatov (9):
  kasan: introduce ARCH_DEFER_KASAN and unify static key across modes
  kasan/powerpc: select ARCH_DEFER_KASAN and call kasan_init_generic
  kasan/arm,arm64: call kasan_init_generic in kasan_init
  kasan/xtensa: call kasan_init_generic in kasan_init
  kasan/loongarch: select ARCH_DEFER_KASAN and call kasan_init_generic
  kasan/um: select ARCH_DEFER_KASAN and call kasan_init_generic
  kasan/x86: call kasan_init_generic in kasan_init
  kasan/s390: call kasan_init_generic in kasan_init
  kasan/riscv: call kasan_init_generic in kasan_init

 arch/arm/mm/kasan_init.c               |  2 +-
 arch/arm64/mm/kasan_init.c             |  4 +--
 arch/loongarch/Kconfig                 |  1 +
 arch/loongarch/include/asm/kasan.h     |  7 -----
 arch/loongarch/mm/kasan_init.c         |  8 ++---
 arch/powerpc/Kconfig                   |  1 +
 arch/powerpc/include/asm/kasan.h       | 12 --------
 arch/powerpc/mm/kasan/init_32.c        |  2 +-
 arch/powerpc/mm/kasan/init_book3e_64.c |  2 +-
 arch/powerpc/mm/kasan/init_book3s_64.c |  6 +---
 arch/riscv/mm/kasan_init.c             |  1 +
 arch/s390/kernel/early.c               |  3 +-
 arch/um/Kconfig                        |  1 +
 arch/um/include/asm/kasan.h            |  5 ---
 arch/um/kernel/mem.c                   | 12 ++++++--
 arch/x86/mm/kasan_init_64.c            |  2 +-
 arch/xtensa/mm/kasan_init.c            |  2 +-
 include/linux/kasan-enabled.h          | 36 +++++++++++++++++-----
 include/linux/kasan.h                  | 42 ++++++++++++++++++++------
 lib/Kconfig.kasan                      |  8 +++++
 mm/kasan/common.c                      | 18 +++++++----
 mm/kasan/generic.c                     | 23 ++++++++------
 mm/kasan/hw_tags.c                     |  9 +-----
 mm/kasan/kasan.h                       | 36 ++++++++++++++++------
 mm/kasan/shadow.c                      | 32 +++++---------------
 mm/kasan/sw_tags.c                     |  4 ++-
 mm/kasan/tags.c                        |  2 +-
 27 files changed, 157 insertions(+), 124 deletions(-)

-- 
2.34.1


