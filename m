Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43FBAC87FDA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 19:40:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D87116B00BD; Thu,  7 Aug 2025 15:40:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5CB66B00BE; Thu,  7 Aug 2025 15:40:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C24666B00BF; Thu,  7 Aug 2025 15:40:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B24246B00BD
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:40:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7361182AAC
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:40:23 +0000 (UTC)
X-FDA: 83750977926.13.A808366
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8DF901C0007
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:40:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FVga8Qig;
	spf=pass (imf20.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754595621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZxujgbgbPZueP+pnQ5s6H3MUryeO1an975QxEYXuWHk=;
	b=XKCqzNiTcs7Tcq1qs8NnQ+quPJVd+JNUMaPDkskEN6Hh+lTlPlTVrhDxLD9FK6p29CnxYC
	uYzc4VV7oXTRQM+gn6UXqgkFnmgkcQvvh27Tye0t0OJVylEeZlHoVefTczefBt4tPbaBNJ
	6+Tfrs1c+QzYDnhaeqkmelRxaZBzdYQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754595621; a=rsa-sha256;
	cv=none;
	b=4Wf/33hqO0lr+Xc+ct1uZ9isztXTU9rMSga1H7tYJ3kwfmrVZLd8I+VmHP3ACSSKC9hgNp
	uuo4iewIhwJvpgaQiZ3NRYZUYvzN5B3CcHKLJJed+InqG2CB2Lxqm6ar48A3iTHQJ/dxKO
	GGVNJnm2YyVlDVOHVQVrMeSrnQBoSIw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FVga8Qig;
	spf=pass (imf20.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=snovitoll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-333a17be4e0so875411fa.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 12:40:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754595619; x=1755200419; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZxujgbgbPZueP+pnQ5s6H3MUryeO1an975QxEYXuWHk=;
        b=FVga8Qig76G2CcgSnga+lsWqWBn5FgDTI69uWyu228ReNmp8o48LcOjlQ+HPd8mZJ1
         Vg48Q0ngxKNv+KpoUN+48X/2dqzMjczL1381LkSHkE7rHHOlPzz+atf6Jh6KwS7ewTGc
         X72fCXXH9qYvC4DrjouFNNWkaT9BYN5JajMuCxh1dgFUAonV8zhtqvBJ3sELqURmSDQB
         6GKKQHCyPsqxFsu8zT32aa8NPSsw0kgeGSKH9y9mzgpgtfsjkYJX70L9AssSYGIa9xgp
         Zn4iMmUSX92MdmSCYxCKhweDBmRT4Wd32zPlZFp1WCJMGj4uHGjEsqTbbnbhGxTNEzcE
         EuCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754595619; x=1755200419;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZxujgbgbPZueP+pnQ5s6H3MUryeO1an975QxEYXuWHk=;
        b=qvWsGvFfgDozzQh/2MLlDKGxwQvac5NU60IySedStpFhACN9KQDbpbI7K70kaazVM/
         uxc9bEUqB9nKMmMcLuVN5+ccZP7dzm5m+1AIIPwiR/k+IvG583MFdxt+Z6z1kjqNS9B/
         V233wspBmeBkYDgp4kQPLJQv99cN6P+bZWl3zRU+zlaOtYOJGrvTowLRwx5MuGZ2XJSh
         IBSTkVYCI8xskHVXqY3dLYYw0PC6oWh2k3WFcvpj/55wlvFNngD3wZoqhR8yOQBQ2Aza
         x5WbCf3FEaDhey7W0kSopTv3dk0wXmvTMa6XBocX7QmjHpPd83Dw45qhlTNFVOlqnyLh
         AtNw==
X-Forwarded-Encrypted: i=1; AJvYcCUjWVE78j26N5J/eJNzFDZT6TGwY81bQ0gBHj4oQap8zetxeWd6eOSXfHScMgLDQiZgcVtw0/hRcQ==@kvack.org
X-Gm-Message-State: AOJu0YxVF4ZlMiGOE7EgDybJIe6gT/9f4znXudesoWcMZ2DYV9QW1ziw
	TgwQp0QUPwS5IwLjx3qycMaZjTLM+AP7gasB6DA+D6hSI3Ay4YBFK6yd
X-Gm-Gg: ASbGnctqJ5XgQGVSezzJZjadANHh6qllwWfJMNrDu/hzfgm5W1MqFXydwzSmE+vV6/b
	OC7nIyfvph7DwZB15dv+EODRkD8tq819A0ZXe2GmyQ7Je1OOHNgAHtCv4fZMUZphnFgQsgkv+6W
	I73wlYwwVhSoqes+yDcqsa3NzFs+RO55vENi0bUCzjJPnlgIH5ur7u6tgHx/OxK31Nk2jxGP16H
	9/WkxAuUwSTUP7OdBBmXCZQGFTY1yEEeA6RNJ3j4gaUH4Op48RnWNOrqTX455vX8zr6TjrvMmy0
	7DGQeArJ7K2vT0+qZRtEx6VQK5uAiiB1hRdGlwmXA3+Px/Q/Il6rUrS04DFWuUfMeeVT42R+XkK
	KmL7NCJwESngZFskuDy2mb1+SZOFTlv7RcsxtUN1WT0E18EkcIXtKsgR4TrJb6uEg/u3d5g==
X-Google-Smtp-Source: AGHT+IE3k4ZwCdWcT+X+hcq7vhHbrmZfaduJaslrnOP/WdlfOXcdLd8Kfq+JS+ZAkrsMnQsJjZ39NA==
X-Received: by 2002:a05:6512:3d09:b0:55b:57e8:16c4 with SMTP id 2adb3069b0e04-55cc012c003mr7357e87.30.1754595619107;
        Thu, 07 Aug 2025 12:40:19 -0700 (PDT)
Received: from localhost.localdomain (178.90.89.143.dynamic.telecom.kz. [178.90.89.143])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88c98c2asm2793570e87.77.2025.08.07.12.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 12:40:18 -0700 (PDT)
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
To: ryabinin.a.a@gmail.com,
	bhe@redhat.com,
	hca@linux.ibm.com,
	christophe.leroy@csgroup.eu,
	andreyknvl@gmail.com,
	akpm@linux-foundation.org,
	zhangqing@loongson.cn,
	chenhuacai@loongson.cn,
	davidgow@google.co,
	glider@google.com,
	dvyukov@google.com
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
Subject: [PATCH v5 0/2] kasan: unify kasan_enabled() and remove arch-specific implementations
Date: Fri,  8 Aug 2025 00:40:10 +0500
Message-Id: <20250807194012.631367-1-snovitoll@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8DF901C0007
X-Stat-Signature: ockffgohdrhfdggjb63639fekm7i4b3f
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754595621-23255
X-HE-Meta: U2FsdGVkX19+9Nfaf46q6ahEMQz/lGhRDFdJSLiOUa3MMFzPEUskax9IT03Qcfy85hqjXlv7w3Bi3xHgdkwOdClikke+ySNz0Fn7uzhuhSLRVLOEQXkMCnGL2iXCEv/7o0NtpdXWELxGl20MWmbP+LkVaOL5LV/+bGB54eHFjsTKm7d1jfuRpyj4iICn/HqNJLkuLJ8UFyJx44HFSCGFx+viDtcoNSoAOWTpnw02x5CePYzjLJTaU+tMQxlRy4e5FOCIH9eNDxGs8RF7Gzdi4y+6CSre8O3ju+ALW+hJMjD7CGa/hm1bGKqmUUIaxkJO8x+H/2uaNhzzMvwaRixZXM0eJNsZ+MobQobf1V4kKa4yObSwyrtTipZjdLMLrRdIOlExioydQfIGKkuRdnOxjE9NuGzmTF21912orsLpyQwLAeICV2/94mk3fDBhjZMGJMxBRLpgcwpWC7wY1+6rkcZCPFAN+9YzLaPfIc+7ZmDK9x2EVTHkNFD12VhKIrr+09NTzRODnHVM9FWceE9uXQDLAHplpFYoDfyq0YhYUI6S8irA6n7rqLX3n6/WKUPw1Ak43GI7LHvCAFUiWWiEHqpwCfo1blnTxG9shWc4GEQ5a6Of49wm3uOeDp72fVmpXxTi0HHLVBGIu7+XMviKoDDdabYR02oxYKYNQaYyXAOknrPpzfFj2WXaZLKsGOJ17fQnIXKTQTqwliPGn4tISdADjcLtAxDom7kVIWnBg6nFmaaki7z9V8YTXf2XfLHTah0fQqV9rXXPAWxLlTbgxyhLKy4w0YgzYMeUQDVHQFCvSg9iMVAgRsH+veETyn0dH++3nhryclZGVqEuUUiBsLO5/qR5JaN6J5CiETqumJEpzKHSGjlcJRGRzZjSiFUVWmfv6XOsdu26Mz6Id+R+g5FrDNONBc0/LiUfbA9VFT4sqv/tc0/WfUFGV+mbI7a7hOSj7jSqpzIRnBzH1Q1
 52AJQo8Q
 skUx2JnJsESpWLRHWk7teoh5LJ6ExW2p/+Tr80+8xTdmVgzGy/kik6gRvyPNSrjCbNm8j71qRd2GpHlXTXJfq8H0J93EIxFgR9k2SpcMIgL6kWPC65R0oEARPWMaMWON05+eVQPgrX+tiq4mmeJeONfvFY4qGjQFQGcGy58TJvrt5XZFpbB9bWxBfXxoAE4dPWzQQpMtFztUrsOUm6WFO+SflErGFKA56O1OY+9tDQjon8mArI29xeIGZ2EAOJ+OsdANlr1wwLAZ4I0OXFsqdHb79MsmPCsj5njg/N18XGe2cieaxq2Km/sMxJEOsQiST8bQEnamwki6Vo6pj3s0b4VYb1k5oCP4Xcv7P+2yREZNYID4G9h+m9o99cFSc4+7o0LoIHJEGrjwIZ4XOjd/QlEj6brNbDJvJz8y59j9jlno0F4evnE9yHC9NDtt9zglsZtjigXDgQC1b/c0Qj4L167R2naTZHGo5pq3n7xk39VNEDqSYmbHy2Dwp4012nFaBFKld3wmINIETJ2PmEWYbKAPh2XH3hKd65np5hPeYiF7zh89dMEUkYRY6nw==
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
 arch/um/kernel/mem.c                   | 10 ++++++--
 arch/x86/mm/kasan_init_64.c            |  2 +-
 arch/xtensa/mm/kasan_init.c            |  2 +-
 include/linux/kasan-enabled.h          | 32 ++++++++++++++++++--------
 include/linux/kasan.h                  |  6 +++++
 lib/Kconfig.kasan                      |  8 +++++++
 mm/kasan/common.c                      | 17 ++++++++++----
 mm/kasan/generic.c                     | 19 +++++++++++----
 mm/kasan/hw_tags.c                     |  9 +-------
 mm/kasan/kasan.h                       |  8 ++++++-
 mm/kasan/shadow.c                      | 12 +++++-----
 mm/kasan/sw_tags.c                     |  1 +
 mm/kasan/tags.c                        |  2 +-
 27 files changed, 107 insertions(+), 76 deletions(-)

-- 
2.34.1


