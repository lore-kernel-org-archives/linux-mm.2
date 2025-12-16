Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B239CD637B3
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 21:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C205F6B0092; Tue, 16 Dec 2025 16:26:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B82166B0096; Tue, 16 Dec 2025 16:26:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93D6A6B0099; Tue, 16 Dec 2025 16:26:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CD816B0096
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:26:58 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D5748AE8D
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:26:58 +0000 (UTC)
X-FDA: 84226619316.01.146D2D5
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf05.hostedemail.com (Postfix) with ESMTP id A2C23100002
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:26:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025112201 header.b=Q+IRqKFs;
	spf=pass (imf05.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765920416; a=rsa-sha256;
	cv=none;
	b=IOR3iJeQRvKW90W17pLnUP6DMPybvDsfEOzWRIBkk6BJZnKDUD57F+Ro7RmG/kHTX0ny6Z
	yMvBBVgCmYFBr2lbYbKalZ+cwafqi2nmeK5oXictuY+5VtvHq4Mulc3HtNH0TJXPpkDYh+
	xV9sWW5vwGDzWioEnU50CRuEPw+LuuU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025112201 header.b=Q+IRqKFs;
	spf=pass (imf05.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765920416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qfIXPrDPPzOmRPX4wlKrygGvZVz41nwH1/qG7m+qlJI=;
	b=I6zOyx0nXT6qMwsbDa2E1/HbicI+yqN/i8VEFKy4FVOpouHpp09PtohS8+jPIDTuDdMTm4
	X64+posyjtqc0qaWeDs2TW5lUmPpXWDB+Bl7y+KWA7LNwl48mEmV1KluLPjNWuMcsM22bw
	hcypZxDMKWtb7SjsdOFjwFSktoMozcs=
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5BGLQC212563820
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 16 Dec 2025 13:26:17 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5BGLQC212563820
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025112201; t=1765920378;
	bh=qfIXPrDPPzOmRPX4wlKrygGvZVz41nwH1/qG7m+qlJI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Q+IRqKFsMsjzabNidYuoiQalsihl+u+9Y6XqjoBvDQJMt/PjkkwuN7wshh+5LWG7K
	 GfpXrzloSEZ0VINGbw2wGowWxdH32j70El2W2gA1U4+1m6GcIHxTZ3upciVpsX7ytj
	 BsLXycBjpGX/jHy8bE5wjvQs4Qdv91KbcMkSaWuBEBEs/SlFxv3IWijoKr27UfDiTI
	 AKcBPv2nPS5P7JsHfhKQgnVmKI0YOVCw4DeEgpe1x/ZtK5KdvFNj1pX1Z8OMyECL05
	 7jU2d+AHxOkPBHODFxeKLlZ6Dokp57+egI445ZoVGKdh+/iRZNyo8pnsGnj23SGAUB
	 WJ+QT3rVHN6Sg==
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
Subject: [PATCH v4 02/10] x86/entry/vdso: move vdso2c to arch/x86/tools
Date: Tue, 16 Dec 2025 13:25:56 -0800
Message-ID: <20251216212606.1325678-3-hpa@zytor.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216212606.1325678-1-hpa@zytor.com>
References: <20251216212606.1325678-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A2C23100002
X-Rspamd-Server: rspam04
X-Stat-Signature: f4xkqfuesfdwb451qauujputt5oi6qj1
X-HE-Tag: 1765920416-234628
X-HE-Meta: U2FsdGVkX199gn8QObdIG3EwVwsPcocV0E2++skFI6ARgVeBKv6JMPzETucvkBMKV/D1JNySVc5YT9NBPHVSlRLJKmCgp1QdSUg+9+en7H68E6BnwrPWMirRxwXs4g0QpEKiy0mhKIEER7G0b6FRW4XNbBvc1k1JLlvtr7NJSmE/lXgZXG4cnGAx9lQa0vR8ARDdZ7otBtYwFadc/1odYtOTMNTUC5P0GTM69N+6AH/QnG72R4ElQdFY+UZ2QyndQV/Z3derKjfjDgJ0ZgscBEqFI9gf827zf/fhA3/pEcDQ+565zd5P0oX3bliOve8IEpZuzlbdwJbvfoltkwcJnq51dwabNMF9F1IvY3uxGkcZikNcnZXCGI+7JyZd5cM4gYjlWs3216+QlnqGdQOL01Ipga7o7OUfT+LqcUK8CNRdSU6nJAmnSoSsvSFhNSTcWk+U6b4nRQJ6SyRkT+Bg1bi2/MnbmECJv8fh15fCTshyNiZ8oi6FOzuJ+vF9m2X4C9WZwZxZFdnzUxABmc3v80VKSDt7AL7r8dwux+aJD9zresSSXPfphPvrEDqMz4EYWHZ78u/lOsqieQC5DsAsV1L9SQGkN1sTPhN275+j8UsWy7WdEJ5oMkqRE3V/cD1sdrog1vx+O2vd2EuGO/hnXNZeJiLJU97ewDG+Y0LfbOWR/96LvzbEHjGIHnlueVCBHh6y4ZqkFMa7jRK7w8SE+kTuYgGo+xsO1htJg8vSKvrQUFPpGvlBDrprWX38O3sIbnNgpzWzJYGK39j9ea1WhBUZhsXJC5fyE6k+dztv13Fejpqe9Kyfe05XjKzOjtq6WK0+AK5OUWRDFH/DqlM6/7Y0BI0X/C12+ktz75iQyOFnDVamikfql1bc4Zu4DUZa4bibDFC/eDsj+xEq7s8qw1OumHZzqMK+q1QBsHSFqlYVeh0a98mb5vRDf3RtuhvYfL+RSWN/qDo=
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


