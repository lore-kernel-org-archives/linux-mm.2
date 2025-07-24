Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F97C87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:37:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88B7D8E00C9; Thu, 24 Jul 2025 19:37:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC978E007C; Thu, 24 Jul 2025 19:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68F1C8E00C9; Thu, 24 Jul 2025 19:37:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 514B68E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:37:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2142B80578
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:34 +0000 (UTC)
X-FDA: 83700772428.18.4052FB1
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 38EAE140007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=d8B9P47L;
	spf=pass (imf09.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753400252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=peHOF2kFTCg4ZjEHfH+NsYT+T4LY9ghqoCHBPY5quO0=;
	b=gniZpepTWNxcivkHQdbQh7ybK7qXyhw50OGs/T9iDYWavcjF9LxO5+KlXYr6ToMK1kXc7J
	+F58r2dKSBTzSSDbdXx+M55RQTLvAuzUJbJK+06mrI6bLU5s6939JJMTXJn8t46CHB/eJc
	WGvRgbUXOWX7C6CZpHka/n3dFhqxN6I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753400252; a=rsa-sha256;
	cv=none;
	b=HwkiEhpGjgHT0iD1vUYvi4RzZbg/zJSx4JwxdBh3Pt4m8xn2mmvd7C5NCc/m6sCqRs3bT3
	eGHqra6EUNi8r/L1TDc2MOrw3cBmjnxWTYWBix98a6N4xvYwBmTGxZ6grMN4/ashBwpU4Z
	7j2O7n3LthVc7Rqzrpsr7SBElCfo25w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=d8B9P47L;
	spf=pass (imf09.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b321bd36a41so1449273a12.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753400251; x=1754005051; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=peHOF2kFTCg4ZjEHfH+NsYT+T4LY9ghqoCHBPY5quO0=;
        b=d8B9P47L/IHBR1hSe9wao70ncNgWQ17gHYU9+0jQcnYCuGJvpccNWuagOeGvJQw0Lo
         8L7hhS7nVEWwtqW6iIrig8bo9kmpIsu369fL7Bkf53JbuAoQS8DSrCjc3soPMB5fVd/j
         P18nhNy1+A1wzVRS/aTgy1ZmgjdKmFwFwIsV8zZh9LZfJHZ66Jv64RZ/gXh8WUeP0W2Y
         l6zs1UUcfOt6SMd+MlzV8AgpUryt2aa4l0LijXrN0NfUDjVu5Gf2N4TwbLctNhsBXMRH
         7oowLuPWtVz7bYFrKZGjH5vV+MSJdIPp848Jw5F1hXIiln2xObK4eBtSc2vFHhpf35YK
         W8pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753400251; x=1754005051;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=peHOF2kFTCg4ZjEHfH+NsYT+T4LY9ghqoCHBPY5quO0=;
        b=PjWeZ5U+N0Qfr94CGsipKygy/IsLsCMFdReG/FDN4MmCTFl/OeYmwHwCT10jdaykYL
         WG1vtebQ8a3LopaZoA+pNNIVMCyM3P0NUK5kAGfVX2YakJ96hVaZQTKnQz38yAJ3nA17
         WyiPdD3+mKZD6xz08PSLKbJiOsc/r8/Ym6rNCntv1jef4GQxRK2AcRdvlzh+rUcimCxU
         PeJsELp6WdiWYInrVafp+7VSlnILft0C9xj4MdnxfFLrCcU3SzVI/NSgxB97+g7iHuFG
         GQdcQbJq/9eJ6zch2tJxK7UxJRm/IfES5I77LsV8N1i6WyuBoXDKQfv3xQekg4K5cRsA
         PusA==
X-Forwarded-Encrypted: i=1; AJvYcCUHa0j/bgtPBo5MqAwi21ar0h42uSbbRz4s3c6YUVZJsR4AyflIhIO90M3KiNeox6BCLHJGTWvtow==@kvack.org
X-Gm-Message-State: AOJu0Yz58+PDm/9694RkGJtTg6c348P4W4HfxeqJy0qr7fR8IWeTJtjD
	tSyXkqdy4f3oMv1hvgBhvINrj3S1qAlciq797bI+RtJjqk59KDWw0/yLTUdi9M/vbf3+XyXy2Kd
	xFvq9
X-Gm-Gg: ASbGnctIPezRsitdtvNRHJw2A8bikYXABtNZ4qmd7AecRXd3X4piXBQRUO89FSUcYFX
	6rKOkaHzC5IriYLr9CtwXzgWD56NAodIFcoiqw4FKLy6Ca6Y2xFH5GqY9W42CVJYgwpKu9WBHxJ
	LFcIdDxiobw85Lo9dguJ2+UJOSRoNqkpg7fJtytPoVXOw5++e4ArzuEb+nnwgqeZesMdcd2iANs
	jUhb0a7XNVcGX8BoEzU1JFVozSh7J/sF3bNBEQSrNxt4L/1uuO1bK3tbkjpn3AuON7KJoEdtN6O
	cGveD0zehNmAuY83WMnHQFtnHjvMgAQHBkanSOg94ANWsSSCKQ8TCmU7sWc1iROc2ArRsncKvBs
	brIDqCfo1OqwhUjdMNtalxXnK2m1lH9ur3iUSfNEeGVI=
X-Google-Smtp-Source: AGHT+IHWiexaVwmMrfCesAYQvzzDEjUSkMZA8bOmNgM6tMD5UpaI8v8Bzd/POThkVi6Pt2HxfwQt4Q==
X-Received: by 2002:a17:902:cece:b0:234:d431:ec6e with SMTP id d9443c01a7336-23f9813a90emr143907835ad.3.1753400250715;
        Thu, 24 Jul 2025 16:37:30 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa48bc706sm23598685ad.106.2025.07.24.16.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 16:37:30 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 24 Jul 2025 16:37:04 -0700
Subject: [PATCH 11/11] riscv: Kconfig & Makefile for riscv kernel control
 flow integrity
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-riscv_kcfi-v1-11-04b8fa44c98c@rivosinc.com>
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
X-Rspamd-Queue-Id: 38EAE140007
X-Stat-Signature: 4xnc6mcpm83o6ry76xybyxmudmr4x6kh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753400252-263571
X-HE-Meta: U2FsdGVkX19J2ZdZ1jekQ4SQkdIRdvD2Ns68quxM+1Fmy8mo9uZHxbEVyz3m58XMIh3pYWKiCTHAprvKwdyQs5UYLRvQfxJ4ydv6kpP7ufVFSh92fvuH3qHjZYAIu3Bk0PYi+gpfMf1f4Yw3Kxg5onl6Xj/PzLoOcU1vC8yzaUlXMdZ6rGrOMpklLaW5jxgvYIsniBuhul+4+j6BhgKJIbTPOXrrQgNuU4OP/nZVot5rTk3Jr+wo6CyDAxuJLjBum0JW2TVAnxBmRehoji2DGfG0VqsS2BTmM9aezb0+9W/PNvAjMLl7CZKmeWPsrrtQvRM5j0TrzQLYAvfIWbSjPqZ4uoMpV+DfH9zfWxld3CyfLVCIoShuzH7BfMaaRsnK+mwQWcbnHPErJ8DuFtyLbLzt0xtD66mlmo2dCtn8BmtGK+hd0l57w/pLDw0hWdAzmKvL+Pq6dtLlrxtXG3OOiXk3FgQp+EkPQ+55Ah896+Q0WZ0BJ36TT0Xe2pc2UPRzOIxsptMjdE44XJdGPZAZJZjfkT2RvDwewNjKFTLmagScjmsajUvzvagv+sdyf5EEk9T+3AQdw8U6wq7Whvj/UezD4xvrW1C4SR4+2+wPkNgD7pW3HHtqeWbIcIhIfQOwa9IkUWkteK9xTFyXZ6Aygf0Fnt1Wfe2LptA2jBtUdnb/4FtAllVgUPlIbma93xxszXcegrPJ+fYIcWO3tVQD7jshBWP5U09cpDFRXwXrKK/xKlaRu4CZpSXnwa6MlV4FgDIhkkpA/GAMaHyplMI/72PHe4KEd+cUfKg9yg7droq9wP0dHf94yo2Rgihv7uU5ufnBzZWHUDZFbTQoGoOCyhz7C34NVm5T8CV6YXbR/Iodgxdf4Tsy+KW0ixkCqIoGrAmMr8mQqH5OELN9W5A75R+Nc60HQVffEM4bkH14A0PamFhHCFyErSLyWXnFcgsyvZSI7omBeQvM87TUOVs
 3ZfE+PhN
 gW3srqiipXhs5ca7l6A11YR545ex4koNC19fGBO9q+9+lmDtyul5X1Kppj//v92M9TeAH87uZ/0iOBrPFXX58RXxZpDuTFmDvUb40snfjPBSg5ssw4wUyw/PHBTGs0QAoPfGQvFfhTxGOShecyT3vOMlo/ROWre2mo35oERBwdJw5NuHCc3nICmKl++eUu+KSEwEwkZAFCQGDct7tqV9I/E3QQm1WyMjaR6B7vCFFrIhVYGaQ8VlJ9WFfRHzGuMtngJ8ERIHmX02ZR0UFhKQUK/SuSDZU4xIBaVx+poSOm8qDS/RUDHBw8lzmSV6UWzYZcCCIQ6qZx3mp7Aatg+3uvZXSoXcphypMiRw4FtWUXBSf+OHUXNsdQCJo67voxZecuSYIRsi7iyJI1c8a97X5GW/oF2LlqmOfTr/bDdqdF00mjFYYzCws83N4az7Ul5vsbCoDf04UUSBN9NkSucr3OFUG6KzpuUPIPyAUh/i2pbZEQZgoIiiK94FMZkbjtAp58q/ObbvMX9prreq9FycvkPWxeDBTsh7uuXUKFyNfu95F2ZwjNCN8ltHpmIVSQw2ReAU3oLdN03hxW0Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Defines `CONFIG_RISCV_KERNEL_CFI` and selects SHADOW_CALL_STACK
and ARCH_HAS_KERNEL_SHADOW_STACK both so that zicfiss can be wired up.

Makefile checks if CONFIG_RISCV_KERNEL_CFI is enabled, then light
up zicfiss and zicfilp compiler flags. CONFIG_RISCV_KERNEL_CFI is
dependent on CONFIG_RISCV_USER_CFI. There is no reason for user to
not select support for user cfi while enabling for kernel.

compat vdso don't need fcf-protection (toolchain lacks support).

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/Kconfig                     | 37 +++++++++++++++++++++++++++++++++-
 arch/riscv/Makefile                    |  8 ++++++++
 arch/riscv/kernel/compat_vdso/Makefile |  2 +-
 arch/riscv/kernel/vdso/Makefile        |  2 +-
 4 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 385c3d93e378..305ba5787f74 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -245,7 +245,7 @@ config GCC_SUPPORTS_DYNAMIC_FTRACE
 	depends on CC_HAS_MIN_FUNCTION_ALIGNMENT || !RISCV_ISA_C
 
 config HAVE_SHADOW_CALL_STACK
-	def_bool $(cc-option,-fsanitize=shadow-call-stack)
+	def_bool $(cc-option,-fsanitize=shadow-call-stack) || $(cc-option,-mabi=lp64 -march=rv64ima_zicfilp_zicfiss)
 	# https://github.com/riscv-non-isa/riscv-elf-psabi-doc/commit/a484e843e6eeb51f0cb7b8819e50da6d2444d769
 	depends on $(ld-option,--no-relax-gp)
 
@@ -864,6 +864,16 @@ config RISCV_ISA_ZICBOP
 
 	  If you don't know what to do here, say Y.
 
+config TOOLCHAIN_HAS_ZICFILP
+	bool
+	default y
+	depends on 64BIT && $(cc-option,-mabi=lp64 -march=rv64ima_zicfilp)
+
+config TOOLCHAIN_HAS_ZICFISS
+	bool
+	default y
+	depends on 64BIT && $(cc-option,-mabi=lp64 -march=rv64ima_zicfiss)
+
 config TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI
 	def_bool y
 	# https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=aed44286efa8ae8717a77d94b51ac3614e2ca6dc
@@ -1182,6 +1192,31 @@ config RISCV_USER_CFI
 	  space does not get protection "for free".
 	  default n.
 
+config RISCV_KERNEL_CFI
+	def_bool n
+	bool "hw assisted riscv kernel control flow integrity (kcfi)"
+	depends on 64BIT && $(cc-option,-mabi=lp64 -march=rv64ima_zicfilp_zicfiss)
+	depends on RISCV_USER_CFI
+	select ARCH_SUPPORTS_SHADOW_CALL_STACK
+	select SHADOW_CALL_STACK
+	select ARCH_HAS_KERNEL_SHADOW_STACK
+	help
+	  Provides CPU assisted control flow integrity to for riscv kernel.
+	  Control flow integrity is provided by implementing shadow stack for
+	  backward edge and indirect branch tracking for forward edge. Shadow
+	  stack protection is a hardware feature that detects function return
+	  address corruption. This helps mitigate ROP attacks. RISCV_KERNEL_CFI
+	  selects CONFIG_SHADOW_CALL_STACK which uses software based shadow
+	  stack but is unprotected against stray writes. Selecting RISCV_KERNEL_CFI
+	  will select CONFIG_DYNAMIC_SCS and will enable hardware assisted shadow
+	  stack protection against stray writes.
+	  Indirect branch tracking enforces that all indirect branches must land
+	  on a landing pad instruction else CPU will fault. This enables forward
+	  control flow (call/jmp) protection in kernel and restricts all indirect
+	  call or jump in kernel to a landing pad instruction which mostly likely
+	  will be start of the function.
+	  default n
+
 endmenu # "Kernel features"
 
 menu "Boot options"
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 7128df832b28..6ef30a3d2bc4 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -61,8 +61,10 @@ else ifeq ($(CONFIG_LTO_CLANG),y)
 endif
 
 ifeq ($(CONFIG_SHADOW_CALL_STACK),y)
+ifndef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
 	KBUILD_LDFLAGS += --no-relax-gp
 endif
+endif
 
 # ISA string setting
 riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
@@ -91,6 +93,12 @@ riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZABHA) := $(riscv-march-y)_zabha
 KBUILD_BASE_ISA = -march=$(shell echo $(riscv-march-y) | sed -E 's/(rv32ima|rv64ima)fd([^v_]*)v?/\1\2/')
 export KBUILD_BASE_ISA
 
+ifeq ($(CONFIG_RISCV_KERNEL_CFI),y)
+riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZICFILP) := $(riscv-march-y)_zicfilp
+riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZICFISS) := $(riscv-march-y)_zicfiss
+KBUILD_CFLAGS += -fcf-protection=full
+KBUILD_AFLAGS += -fcf-protection=full
+endif
 # Remove F,D,V from isa string for all. Keep extensions between "fd" and "v" by
 # matching non-v and non-multi-letter extensions out with the filter ([^v_]*)
 KBUILD_CFLAGS += $(KBUILD_BASE_ISA)
diff --git a/arch/riscv/kernel/compat_vdso/Makefile b/arch/riscv/kernel/compat_vdso/Makefile
index 24e37d1ef7ec..552131bc34d7 100644
--- a/arch/riscv/kernel/compat_vdso/Makefile
+++ b/arch/riscv/kernel/compat_vdso/Makefile
@@ -69,4 +69,4 @@ quiet_cmd_compat_vdsold = VDSOLD  $@
 
 # actual build commands
 quiet_cmd_compat_vdsoas = VDSOAS  $@
-      cmd_compat_vdsoas = $(COMPAT_CC) $(a_flags) $(COMPAT_CC_FLAGS) -c -o $@ $<
+      cmd_compat_vdsoas = $(COMPAT_CC) $(filter-out -fcf-protection=full, $(a_flags)) $(COMPAT_CC_FLAGS) -c -o $@ $<
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index 2b528d82fa7d..7b1446b63ebc 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -17,7 +17,7 @@ ifdef CONFIG_VDSO_GETRANDOM
 vdso-syms += getrandom
 endif
 
-ifdef CONFIG_RISCV_USER_CFI
+ifneq ($(CONFIG_RISCV_USER_CFI), $(CONFIG_RISCV_KERNEL_CFI))
 CFI_MARCH = _zicfilp_zicfiss
 CFI_FULL = -fcf-protection=full
 endif

-- 
2.43.0


