Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 300E2CEFD0C
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 21:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93C686B009B; Tue,  6 Jan 2026 16:20:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918506B009D; Tue,  6 Jan 2026 16:20:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85E5E6B009D; Tue,  6 Jan 2026 16:20:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1236B0098
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:20:12 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 35BBF160C6B
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:20:12 +0000 (UTC)
X-FDA: 84302807064.16.113B4C3
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf23.hostedemail.com (Postfix) with ESMTP id A5059140002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:20:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025122301 header.b=bGAskTlw;
	spf=pass (imf23.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767734410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qfIXPrDPPzOmRPX4wlKrygGvZVz41nwH1/qG7m+qlJI=;
	b=t5ASCD3Kh2Ara7fEOfvhLJvKFIavzzXfbMF29DvaLvb2LYWqqebE0XK74c5xCuCskj+4/j
	cd04nrglwNj3cg+XqvWsp2yWHrgNDCG+Meddt7JcbBxviCzkNJbMaBYrH7ntKBJ3+Zmh/4
	80h3e4gv3co3Ji+ipHpfqdKWsX9vU/E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025122301 header.b=bGAskTlw;
	spf=pass (imf23.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767734410; a=rsa-sha256;
	cv=none;
	b=jt/l0Qse2QM2c3fucsXD1Bsm2V2XRHYVaNWKRt1pLJLvElCubdyEAvM42oYBZlO0xhAFGF
	UjIedHDhFazX/HNJGr+eaqcjU1GUEcCf8jEcs5u6HnQZmF8jcBIt6nIxtBzDulUR5EakqW
	tcCCOJdQ3F8yDCENm+LZ1IQAFnQTnIg=
Received: from mail.zytor.com ([IPv6:2601:646:8081:9483:178c:dccb:2d71:85fe])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 606LIrDq029412
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 6 Jan 2026 13:18:58 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 606LIrDq029412
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1767734339;
	bh=qfIXPrDPPzOmRPX4wlKrygGvZVz41nwH1/qG7m+qlJI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=bGAskTlw3xK0ppwBuBMw3DPh1VchZUr2ucDh9N6oGGsIftfABz2G6bDvPJHoG6Owy
	 pmbRzuPAeMu/MaBPASvYECtJsgPKGvYO5TUwS1RwMXaebPF3I5oS5hcwIWQ58YyyyZ
	 QHadaH8HdTIpf9vFFUJ1w0vBeJ36l8uyRO8RBgTn/f75N5BDaqVcy8mHOPFS4TpEey
	 cUr/Qeoy27ERS6aWRYybHrAIl6NKJlgcCYsbwzuyRZMmlqCr7MuFN09nPA+MCGsGpo
	 oNR09mhYaOJ7Cb4BP/dN+kvbQ/eVue8iSP9Uu3jxkaJ7W4KNODumsPzMG0TY2w/q/A
	 5eRNx7pza5Pgw==
From: "H. Peter Anvin" <hpa@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-sgx@vger.kernel.org, x86@kernel.org
Subject: [PATCH v4.1 02/10] x86/entry/vdso: move vdso2c to arch/x86/tools
Date: Tue,  6 Jan 2026 13:18:35 -0800
Message-ID: <20260106211856.560186-2-hpa@zytor.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <vdso-cleanup-patch-4.1@zytor.com>
References: <vdso-cleanup-patch-4.1@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: msaybw7h7jsjxoneq896cfx6qwozbeu6
X-Rspam-User: 
X-Rspamd-Queue-Id: A5059140002
X-HE-Tag: 1767734410-681279
X-HE-Meta: U2FsdGVkX19GU/CwlJWbFw8/Qjjcz7+1q2cBjHzaWeft7XhRCCe+ISSRPjivtAovC2K++rHHxa43bu2UtAmIETjhvU93pKYupS3IKa/gzfIY2ToJGcK3ghScrKUjzBADxYwrw+G80hE2ChSPXuAT1X47G6TLKAehB71FXEUMgJFCHQhT0+6wUGgEE0IZXVSPmKA0a8n8z3rEC/JNldrgirNeZHGXM//n527839KN25zVTAadaCVuEzUoWZRVluDAnBErCyGRRRcx60zondmOYtnDaYZD3l8eRQr+HMnDcZEcEJr7DnIYk6yfsVL1lnz1AojptuHejketNsNGJMgrx3YjKkIXXpll0VWHz5XGx5HRcI1laG1n7GEqp0T5ZxSTM3T+mutzQpnGZQtP3uuD4l6aBgybr+tN1ZlkxQe1iI9DHET6ckO3u+ClwlBi6wVTKLiroPf9c/zmnVswofBZVrtcwQoBdDYRnJ1WjMQaQftzT+tZwX+I5zehNxSIuqoIHC04zoAzFU9UL7gOZ42qRnMfkOFzBAMs9IjiI+PRGC8ZFScw9HPcVRgssfG8RWinYEbjpp0Uae+p9YYvn5GCqqgr9r2EYMrMSjROOIB+gqj+quhTT+eu7Af0PRyGMQM2IiagKsMudCS0Q/f0NfWJFg1S28/O7U3bpaQYiw+1QP2ZwcKz5uw4Vo44Id6ie43PrjFkqxh7PsN82Tb6vmYn5e1SVcmpbEDj4DRl4Ym8YowOyj6J0Rkq11VCTKf31Rxx/o2JviklBXY8YlLFmacB4ffqelt4Jt7MxslAy5G/FFx4FihwGxJlc03+qfHlZT1jCi9/ozZmYq0NQMI/zJXeN/9HlALjc2movZ74+jx2JsOkBYkQ/oe1oLF5cFiiiT48+qMshPIluwBWPu1406q8Qr0bQ1wDNEu88lM88gFBcePkBfr172ntUdkjecsu5Q5WL0zmVxCagbo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is generally better to build tools in arch/x86/tools to keep host
cflags proliferation down, and to reduce makefile sequencing issues.
Move the vdso build tool vdso2c into arch/x86/tools in preparation for
refactoring the vdso makefiles.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/Makefile                       |  2 +-
 arch/x86/entry/vdso/Makefile            |  7 +++----
 arch/x86/tools/Makefile                 | 15 ++++++++++-----
 arch/x86/{entry/vdso => tools}/vdso2c.c |  0
 arch/x86/{entry/vdso => tools}/vdso2c.h |  0
 5 files changed, 14 insertions(+), 10 deletions(-)
 rename arch/x86/{entry/vdso => tools}/vdso2c.c (100%)
 rename arch/x86/{entry/vdso => tools}/vdso2c.h (100%)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1d403a3612ea..9ab7522ced18 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -252,7 +252,7 @@ endif
 
 
 archscripts: scripts_basic
-	$(Q)$(MAKE) $(build)=arch/x86/tools relocs
+	$(Q)$(MAKE) $(build)=arch/x86/tools relocs vdso2c
 
 ###
 # Syscall table generation
diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 7f833026d5b2..3d9b09f00c70 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -38,13 +38,12 @@ VDSO_LDFLAGS_vdso.lds = -m elf_x86_64 -soname linux-vdso.so.1 \
 $(obj)/vdso64.so.dbg: $(obj)/vdso.lds $(vobjs) FORCE
 	$(call if_changed,vdso_and_check)
 
-HOST_EXTRACFLAGS += -I$(srctree)/tools/include -I$(srctree)/include/uapi -I$(srctree)/arch/$(SUBARCH)/include/uapi
-hostprogs += vdso2c
+VDSO2C = $(objtree)/arch/x86/tools/vdso2c
 
 quiet_cmd_vdso2c = VDSO2C  $@
-      cmd_vdso2c = $(obj)/vdso2c $< $(<:%.dbg=%) $@
+      cmd_vdso2c = $(VDSO2C) $< $(<:%.dbg=%) $@
 
-$(obj)/vdso%-image.c: $(obj)/vdso%.so.dbg $(obj)/vdso%.so $(obj)/vdso2c FORCE
+$(obj)/vdso%-image.c: $(obj)/vdso%.so.dbg $(obj)/vdso%.so $(VDSO2C) FORCE
 	$(call if_changed,vdso2c)
 
 #
diff --git a/arch/x86/tools/Makefile b/arch/x86/tools/Makefile
index 7278e2545c35..39a183fffd04 100644
--- a/arch/x86/tools/Makefile
+++ b/arch/x86/tools/Makefile
@@ -38,9 +38,14 @@ $(obj)/insn_decoder_test.o: $(srctree)/tools/arch/x86/lib/insn.c $(srctree)/tool
 
 $(obj)/insn_sanity.o: $(srctree)/tools/arch/x86/lib/insn.c $(srctree)/tools/arch/x86/lib/inat.c $(srctree)/tools/arch/x86/include/asm/inat_types.h $(srctree)/tools/arch/x86/include/asm/inat.h $(srctree)/tools/arch/x86/include/asm/insn.h $(objtree)/arch/x86/lib/inat-tables.c
 
-HOST_EXTRACFLAGS += -I$(srctree)/tools/include
-hostprogs	+= relocs
-relocs-objs     := relocs_32.o relocs_64.o relocs_common.o
-PHONY += relocs
-relocs: $(obj)/relocs
+HOST_EXTRACFLAGS += -I$(srctree)/tools/include -I$(srctree)/include/uapi \
+		    -I$(srctree)/arch/$(SUBARCH)/include/uapi
+
+hostprogs	+= relocs vdso2c
+relocs-objs	:= relocs_32.o relocs_64.o relocs_common.o
+
+always-y	:= $(hostprogs)
+
+PHONY += $(hostprogs)
+$(hostprogs): %: $(obj)/%
 	@:
diff --git a/arch/x86/entry/vdso/vdso2c.c b/arch/x86/tools/vdso2c.c
similarity index 100%
rename from arch/x86/entry/vdso/vdso2c.c
rename to arch/x86/tools/vdso2c.c
diff --git a/arch/x86/entry/vdso/vdso2c.h b/arch/x86/tools/vdso2c.h
similarity index 100%
rename from arch/x86/entry/vdso/vdso2c.h
rename to arch/x86/tools/vdso2c.h
-- 
2.52.0


