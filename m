Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DE7C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83C718E00C4; Thu, 24 Jul 2025 19:37:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C70F8E007C; Thu, 24 Jul 2025 19:37:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667878E00C4; Thu, 24 Jul 2025 19:37:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4D9EF8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:37:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2681AC058A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:22 +0000 (UTC)
X-FDA: 83700771924.28.3398144
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4A1EA2000B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=utv81lEv;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753400240; a=rsa-sha256;
	cv=none;
	b=DiYYFvZ0VFet9n58eJTJfDIMml/+Lfab61wMa5XNVBuDP7Etn8FnXX69K+wX8I5NyE9vcH
	59jIOasNzmwZTJDhRH3rpIwxkbVvhrf17vrbTBmhgf4Yd4WZbFbcKfEGqnT2fR/Hbaeo7l
	imHfDl8C0i0k3BXAESYp2dLRcLUlUX4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=utv81lEv;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753400240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WOl3Nqiah3DIFqJnwAEdiPuuEwqhP+r/KN32JLcNnyU=;
	b=quTAYrxHN3SYkHou1D9qCTu5PX71MO2ezCwg40UlR06VupicU0veEFFvviFIBazSPKzj5W
	jRp5QC9yNyTsTtfj1cn2hjkv49O/fUMBWjKwitPELr82EfJRSSiz/nbXuNQzeN0+XilnOF
	6jYp4rcSplsmQZlvq1mRpPfhvQY2tag=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-23fb04ea1ecso728465ad.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753400239; x=1754005039; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WOl3Nqiah3DIFqJnwAEdiPuuEwqhP+r/KN32JLcNnyU=;
        b=utv81lEviLWBXv9DZVSFWpSY02AEUFBgiMNhvberldcZ2pi9XPv3IVZdi33jqZ1h+B
         WBInV5fwJXFQVwXVf2GQZJMtz54WaUED0sGL64PEJUAy/ekg294CAWCjGtsy/bKNTkfl
         sZ6Dg040RPOvETl29wK22yQQOGfPpzsIuLcR4TQZ/2hkkt1s7r0Z1D/6r08EraG2HIR6
         gDYiu5VvaCNhkRhL451lGy0Ubzf16ucL9UJG+GGCP2yw0NFD4DpgnelyeY/Bx8cp3kl0
         w7j5Xyg4Yhe50y087PGTRNgOfGfi+NAvBwz2sHvUFTlmD5Mkz7+DG+DDR02ycNQ2uOF/
         VQeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753400239; x=1754005039;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WOl3Nqiah3DIFqJnwAEdiPuuEwqhP+r/KN32JLcNnyU=;
        b=RWvojj7EgcMD5EjNJgd2dXMzRjG1EeCnIdMgLL0yO4jsSXpwELfZT2OzdliolZolRS
         lPHR6iLwzYLe3mahbi4Jv1rsrM9J7sogjx1YQr8QwbhOb/H3T5jwI3VtckSEqSKVstjv
         5rjFODGdnWBuHsfDJCIkD1xhNImEVyIDf/VFLReMwQtRJSrhOkeBl38MaI2DyKj8FMyP
         uQ9MPaYDx6WiKO3nbF1raxfMAXsvW+XkK7/wua37D4QNN9002wx7vtYp5GuQVJONFbgt
         njEzd8MwVpRxuW595Chcq5JT9D7htuGQsrHKU1TGD8FY4hJla+Yvg+hV4c4CNX8KdAe0
         K8Mg==
X-Forwarded-Encrypted: i=1; AJvYcCX4q7sz83lOfYJt2j7AYm+YfO7F7adyk/ulp6XN3tisH+oSBD+88DmiSxZenjDUsqIhHkxfZsA0ng==@kvack.org
X-Gm-Message-State: AOJu0Yw/C51Kj+fyzt+E4TLOQGbvZjq0GAcmP4s/ih/54at0fSk9Ra7h
	P/fGDflJjX38ULq4rdg6gUGn5vw88/Coe3lccA2SNkWDrX+KqAnIde2Ue3F/1ZQPQ8TXVyG+30q
	IjPNZ
X-Gm-Gg: ASbGncsc+xT9uifpIyiEzTYcSz/tUSlYvqSoK+FT5TPW16lMAhqhyPFDerK+iKrTg3L
	zjhKjJS7XcBMCFFL1HkByavki4zERB1dJ9boDytxTbgPmFr9F54aJat4+faEkIcr9TjJUHAI8Lc
	BlDODIYi1CqjJlPya2C3ltiUbZcGMJeMKVuadWh2EmM3Q4paMlW5S+VjODGm1+eNljPUTJ08eVC
	k3AmohDO3hKqDv3bjDTzksM4wOLo5Y2igEgG++57VCYHQ2v+yXNDc5JpSrMLYMSXMvBPmE+ArlK
	ldK9pWbWlBBki39Msf664VoNuvXaw/TwHX/w+ZjhiLcYqYVHdxPCenwfTs28bOBg/rpoCeKLBg1
	zjOHnQjz2d2aWHqTp3WTXZKvNhaiH2LvU
X-Google-Smtp-Source: AGHT+IGSQSNsbZMV3011ClnOwbU01lkESEFEILFi40CGgrviIgB/I9wMU9rWnehZSismvHPpuGcGoQ==
X-Received: by 2002:a17:902:d501:b0:235:e71e:a37b with SMTP id d9443c01a7336-23f981aed8emr123582705ad.34.1753400238919;
        Thu, 24 Jul 2025 16:37:18 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa48bc706sm23598685ad.106.2025.07.24.16.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 16:37:18 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 24 Jul 2025 16:36:59 -0700
Subject: [PATCH 06/11] mm: Introduce ARCH_HAS_KERNEL_SHADOW_STACK
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-riscv_kcfi-v1-6-04b8fa44c98c@rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
In-Reply-To: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Masahiro Yamada <masahiroy@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Monk Chiang <monk.chiang@sifive.com>, 
 Kito Cheng <kito.cheng@sifive.com>, Justin Stitt <justinstitt@google.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 rick.p.edgecombe@intel.com, broonie@kernel.org, cleger@rivosinc.com, 
 samitolvanen@google.com, apatel@ventanamicro.com, ajones@ventanamicro.com, 
 conor.dooley@microchip.com, charlie@rivosinc.com, samuel.holland@sifive.com, 
 bjorn@rivosinc.com, fweimer@redhat.com, jeffreyalaw@gmail.com, 
 heinrich.schuchardt@canonical.com, andrew@sifive.com, ved@rivosinc.com, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 4A1EA2000B
X-Stat-Signature: pgdi11cd9yx8n944y7qhxcx7d4z76oid
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753400240-486358
X-HE-Meta: U2FsdGVkX18LU2NXsMLQOlf/Ehgp5s+F/UzXuRunwYELNT4y1HI3egjt38g5pqY7thHDyHQ/nRD26433x1ElCDLjm8wlZXW7eYF3EL223ulB1hHeOq+orVEWr+gVT6e7HcY16QA+hOk2HqoIhQdv+sQFX1uj80r+/noww2JSi5AkrdJ7C/7u+4CbK6LA1dy/RKc46jZwrkX//Gju/oQ2eW1rSR9jUMn5JFEsvGmPqhJ1IU8aVnwK0fQarWbE+jwXRiuBOkkds701elEumdRZfG2ne0mdw15LLd2fy3WgoS9U4CABWYGrX1QaWcSZxTolD2O/04t3j9zwfln46eGdyavuORAqbSrkNhY+S7Uiplz0NPSp/54A1wyHicAXG3EEYHcUcAwyq062/roI5Vktr7zv/GcBYgdlzpXfvoe4HFkS9B/NcU0uF6DVxcnBjm+zTWET7qxOsnvCdB1EsaH6bwYTFjNBG0++AZbkyTzX/DsvsZzEULE7TiWpN6Q4m9dXtD5bPOSNUKIUYWKBkGD1JRzMTOaiORlpg5DOuO0qy1IPZ7YnF8/TXaT7x2qD7EvPpFIgjLbaWBkpSp3Ezzl3chl/jXRoCsug2wJnEmeeHmSnkjx864GDSuhqvGijchND49Ol7qM26Z0tg1j//cfvI3LNJF2bINvYPc4RJXSQqzK+OrQS/KExQRzs+5+jyRtNpoQvUzZHQ5DGmoy2fprul3xmI++O52PT3KUu7epjc/qXPH6x95k+heMpcaoqr7Ls/vcDRyfEa7VQ2l2szvE2YlR/PvxozFF7bkTU/Gm7aWX7e6Rxzz5F/ey2GUaPnu35vHaPvno68XwGay8r5+I3xgo+MkKrbaBSxNDXOs4EZYlrDU0emydrAdyV6CUtjqwPjSsMPVNpHhpk6TLdM/f/bJ6yVHMY1+5L8J/nWsDCkZywWUGqt2WddKUgfCW8m7AOH4Ihw/o7Q0fij2W7MD+
 Fa2c+Huz
 kOoDJt2TVpdVEYodcJq0hNtNbpBQbuWL55Q2iS1Nh8LobamSTY3lYXesPVlbBRTpQE14KraN6hiiVmBtU7neX42jjHJeZ1uVBs1fJ/EAoXy4Crrf8xqoIrSpNyB+/xaJSLPWsn2EfQWFPpMhabNs6smBTR2NQZWhzJjkKJH5JmWETWy7doxhTs+igGcLFuYFBLinPXApc2dEySa+MlJhx/0akmC0ZxbcqiNEGW+jKNpyLhtMaU99kBwuKnepHffb6N9hHXaq1ZxT9X6ja5Tw+OaDuR8QIY2lZV5q2P782ST/ynAjoHbwKaTvSOWDr7abq5WoS6EIvEB2mrHJ3VLNmlJLN8eqTv+CsIllUhAaajOtDo7D3vzHeCnmuLPFXnLW/00C5WEmzlbDM7TbP9IFBYVRBzqTiLE8gOnwXKUlmku8Cnk65wC+dThHCNxJTdnXk/RR5YYhaLcchUinVZRHyqrVF0X/KyU/jHHNeRUYt+LtF6GEACgTzD2HHI6kQgeOA9/xu8Az1GngMAcLiIqFbwkqoTnN+sKeDsAs5gEod/nMLgs4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

commit bcc9d04e74 ("mm: Introduce ARCH_HAS_USER_SHADOW_STACK") introduced
`ARCH_HAS_USER_SHADOW_STACK`. Introducing `ARCH_HAS_KERNEL_SHADOW_STACK`
so that arches can enable hardware assistance for kernel shadow stack.

If `CONFIG_DYNAMIC_SCS` or `CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK` are
selected, skip compiler flag `-fsanitizer=shadow-call-stack`.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 Makefile   | 2 +-
 mm/Kconfig | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 35e6e5240c61..7e3ecca9353d 100644
--- a/Makefile
+++ b/Makefile
@@ -987,7 +987,7 @@ LDFLAGS_vmlinux += --gc-sections
 endif
 
 ifdef CONFIG_SHADOW_CALL_STACK
-ifndef CONFIG_DYNAMIC_SCS
+ifeq ($(or $(CONFIG_DYNAMIC_SCS),$(CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK)),false)
 CC_FLAGS_SCS	:= -fsanitize=shadow-call-stack
 KBUILD_CFLAGS	+= $(CC_FLAGS_SCS)
 KBUILD_RUSTFLAGS += -Zsanitizer=shadow-call-stack
diff --git a/mm/Kconfig b/mm/Kconfig
index 781be3240e21..f295ea611cdb 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1367,6 +1367,12 @@ config ARCH_HAS_USER_SHADOW_STACK
 	  The architecture has hardware support for userspace shadow call
           stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
 
+config ARCH_HAS_KERNEL_SHADOW_STACK
+	bool
+	help
+	  The architecture has hardware support for kernel shadow call
+          stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
+
 config ARCH_SUPPORTS_PT_RECLAIM
 	def_bool n
 

-- 
2.43.0


