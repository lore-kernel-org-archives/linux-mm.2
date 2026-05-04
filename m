Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79EAAFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 09:33:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 779756B0096; Mon,  4 May 2026 05:33:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640C96B009D; Mon,  4 May 2026 05:33:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 494016B0099; Mon,  4 May 2026 05:33:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 277F66B0098
	for <linux-mm@kvack.org>; Mon,  4 May 2026 05:33:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CEADB1C1119
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:40 +0000 (UTC)
X-FDA: 84729225000.10.E878C56
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf22.hostedemail.com (Postfix) with ESMTP id E2FFAC0013
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:38 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=o1NfSlad;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=3iMHR0tj;
	spf=pass (imf22.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777887219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ugVOeRWOWBTtOIYgmoFYz2LhMt6W4Dhjf2Ekki4Yvyw=;
	b=FasgciEe6Uv73fVfWorwviriRmo/zaRuIsYdjW2Mqut+XS1JLnCFswuqD48PgCFB4cXMs2
	A2979wV2fG1SLu0KzWifmQBob5glqghQ0hKlsr2TCSUq7yt9V8ql4azP3ApRWfpm+bkJUn
	4+KQBMgBgMtKMrdK7D36GIpxMkDt2r4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=o1NfSlad;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=3iMHR0tj;
	spf=pass (imf22.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777887219; a=rsa-sha256;
	cv=none;
	b=umlgJZ9PFu+WeEG9tklRO+KKAFBelOJrcQBUqJ7NL2OsYtisSfGYf44YDmH8A3H9Z64l9v
	KE5CcSjbeNOQJ+RIQkfOl0AGRXxOdJmgE0N8BX6W/mgbNtbwCb1dgmtPWMz8uUzlcDJdyy
	JD0SsAFxPyoT2vEb8tEiiG2JRzWXrUU=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1777887216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ugVOeRWOWBTtOIYgmoFYz2LhMt6W4Dhjf2Ekki4Yvyw=;
	b=o1NfSladl93mM06aJdoptf/eSurx6nQPJXgm2QcRqoU9KrrsZnqml9Mw8ZAP59TqxL8PlW
	x4Za1b4elqPJ1HgTgVq7J4aBQNwu7rfUAYy15OK1W0zgPPdXpNeprVRTXHpiKe9aA9+rWe
	QRDNCxHGuPy+9zraizvL+c5W4ACpPpTOCqb4EX4xOHyPRFnqzjowy2eQmPCwVJ+un+7GrH
	T7NVljFiawhvvp8LXv19e82B/FJuRiTHA+yV8FGLYieRtA1JIsoh2ph5qaKW/j+6qW40tc
	Nk2EQ3vT0YRchsXI2UWCVAGkeFSDKiGhwKkGp0Vov3V5vE6ir3q5rF9ppb7zCA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1777887216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ugVOeRWOWBTtOIYgmoFYz2LhMt6W4Dhjf2Ekki4Yvyw=;
	b=3iMHR0tjbnL8tPWjVIBtZgGPFqGE0Ei/V/A1ZWtgai9bVFgsjYH0+VP0OJAFVPacr6mFK3
	QXOXum6eDsu39fBA==
Date: Mon, 04 May 2026 11:33:21 +0200
Subject: [PATCH v6 05/11] init: add nolibc build support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260504-kunit-kselftests-v6-5-712d3d526d97@linutronix.de>
References: <20260504-kunit-kselftests-v6-0-712d3d526d97@linutronix.de>
In-Reply-To: <20260504-kunit-kselftests-v6-0-712d3d526d97@linutronix.de>
To: Nathan Chancellor <nathan@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
 Brendan Higgins <brendan.higgins@linux.dev>, Shuah Khan <shuah@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Nicolas Schier <nicolas.schier@linux.dev>, 
 Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@lst.de>, Luis Chamberlain <mcgrof@kernel.org>, 
 David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
 linux-doc@vger.kernel.org, workflows@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 Christophe Leroy <chleroy@kernel.org>, Nicolas Schier <nsc@kernel.org>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777887211; l=2801;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=6rrqaxgFiPHF8GVMd6WSz8gimcEUJCAQ0WbyR1cySwc=;
 b=lLv26QbCnoFu+xwMv5Zb421C/VYsqHUM8BHxOQNWqkF7mZy+TSz+5G6TsseajtATALbOf1Rbj
 X8kKFb3ozuSCcD605KF4XXKed6PUuWZkfSuZHLuIibd1Cu9USBgBroO
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Rspamd-Queue-Id: E2FFAC0013
X-Rspamd-Server: rspam06
X-Stat-Signature: hoibkr1fahzmkxuoeux9e1oz47o57u5e
X-HE-Tag: 1777887218-549710
X-HE-Meta: U2FsdGVkX1+sycDTz2NmbBkLQ0jatdvp6JMkuy4Jw2vP3gAWpCB8SRZXHzsvAfDQca8teeB1DRPXTCIbgeZwEg6rDKWcDYyG7OckTdRw/6YpKWb2UJjLcfDYED9qXeqLU4W0pGrZncpnml19OepRFlbxXLU8FMyPB6acUKrEFzR0K+2iHGkl1WPtIdB9R5np5fpTpxxwWMv2Z5RHxZk9B+22uC6jJ7H+7VAInk+YcBawbLMztEpeNfVO0oEeDTqSdHv5Uu8MkDGM7w4wQxiQg3f5vrVpAAyheFANVjI34j7xjLWvxu6A9W5TMBKLoTdhWTcCU5UP/ZjZugnpTIouet2vtswxCHS6kDOkCs3Pa2f+FALFbgZmVIElkeme+q4QTS4ED93qAn7k9PP+KnPxfIisO3sozagZ7BFL3ZU/r6LGPE+JNGZkMHPEXDjVkkDwpL8bUZ8hm6A6IiAiqdMO8y0IkZWH1hvI/SuLq4C7+rBR8c3kEz1C4EFHfsgtmyVQoVUcr6fQgOVvPz2IzI/ZKrg3Ck0oaMzovMA2QOTzt0RWGaMZxTiF6iugIvdXHIgmaIbkH5gAfD+NBZWIrvcmhKsFS4LILgxhCC4saYObvr4wI2auxcMxfE+OIDCE+Vj5iPIxaeWW3MyVkWxCMGSCM38iVAR+9zv6AAVI5CUwRpkGbsHRw6UK2LEIiDJFTjrzdhWCn0OyVvxjPD+Ep3b5/YqKL6RxEnHh0//Bw08H+HOMr5h11Wefh1lbAHO9i6dkpWVhUOOZm+ovE5rAo8zd3IBwwJaMV8kOjOYDk98bZPISyZ2NQd/TO24kqTC7kYJJWpaMR4fEJHL0A6XZ2+cjT/+xa2oCncNWsJVgxi8Q1M1GWsg5fdQTJUsYH7Q22eFBudUvOBvEbhcFVw8r83Z+S7dtPyFuVG1UTiXQatSfewer5348pbX7vOP61fgau2Oc96HjmOR7rxvbbW+FtP8
 jvjPnOxm
 IEpw41INbWSSxMCZ4SJsGRXEeIoSMfydvMXIhUkhsLE0mKf+r8BEnEkAPzro3+AjuJTPbiFzbwK16nZ2X13hSiQcKi6THXBkwkZc10ubGZ7WRQC+J4wulHTqaMBQMno5xtVxs4V1Ed+01Fy9OEkRdNtrC8AM6e1Y1e9WdgDgLjgr0yFLYpNiVFVK9HFv07C4vQwMTvuBuDZynZm6JJnjr2/AoU3Uz4do8Dj6zM1K0iHL1BZ/OTFXV4Z5B4fjJGnqlg1IckHgIY/uyYWPfJZfG+whhoON8up3M8g1alTGDQf5lvb7bykTbzMNSsdfyinwIVDtkC+LPC3UxOH+JpXyHGuEAyckjIBgSCDyG4dIDYRFbmbEPKRKraYtGoemWPzkNCleVJqWKHayD3/GOm2RqsWsvzuJM/qm9jz5YTg7RWb4RUUfoVVUMK3qAJzkxAhzexSQ76CI4M6abia/Fr6VXVeTJfVviZSMv4A0u4Dvt0gTJefEjOP1VAxm8iP5r4zxE/K1RlbGGCFgxVEeXps5/dwuMVp8ttnXL0JREqL9iNqW1YHaIRE0XMsiWPN5ySuaoekubfzt71AwJcEHXnlzrUwk9FeB8sShDfwvb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Building userspace applications through the kbuild "userprogs" framework
requires a libc. Kernel toolchains often do not contain a libc.
In this case it is useful to use the nolibc library from the kernel tree.
Nolibc does not support all architectures and requires compiler flags.

Add a kconfig option, so users can know where it is available and provide a
variable for common options.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Nicolas Schier <n.schier@avm.de>
---
 MAINTAINERS          |  2 ++
 init/Kconfig         |  2 ++
 init/Kconfig.nolibc  | 16 ++++++++++++++++
 init/Makefile.nolibc | 13 +++++++++++++
 4 files changed, 33 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2fb1c75afd16..be4f6242b3fc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18960,6 +18960,8 @@ M:	Willy Tarreau <w@1wt.eu>
 M:	Thomas Weißschuh <linux@weissschuh.net>
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nolibc/linux-nolibc.git
+F:	init/Kconfig.nolibc
+F:	init/Makefile.nolibc
 F:	tools/include/nolibc/
 F:	tools/testing/selftests/nolibc/
 
diff --git a/init/Kconfig b/init/Kconfig
index 3bb92a3f6cc1..c37d9227ba72 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -106,6 +106,8 @@ config CC_CAN_LINK
 	default $(cc_can_link_user,$(m64-flag)) if 64BIT
 	default $(cc_can_link_user,$(m32-flag))
 
+source "init/Kconfig.nolibc"
+
 # Fixed in GCC 14, 13.3, 12.4 and 11.5
 # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=113921
 config GCC_ASM_GOTO_OUTPUT_BROKEN
diff --git a/init/Kconfig.nolibc b/init/Kconfig.nolibc
new file mode 100644
index 000000000000..07488ef18f4f
--- /dev/null
+++ b/init/Kconfig.nolibc
@@ -0,0 +1,16 @@
+# SPDX-License-Identifier: GPL-2.0
+
+config ARCH_HAS_NOLIBC
+	bool
+	default y if ARM
+	default y if ARM64
+	default y if LOONGARCH
+	default y if M68K
+	default y if MIPS
+	default y if PPC
+	default y if RISCV
+	default y if S390
+	default y if SPARC
+	default y if SUPERH
+	default y if UML_X86
+	default y if X86
diff --git a/init/Makefile.nolibc b/init/Makefile.nolibc
new file mode 100644
index 000000000000..dacc78ab4c81
--- /dev/null
+++ b/init/Makefile.nolibc
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0
+# Compiler flags, which are necessary to build userspace applications with the
+# in-kernel libc "nolibc".
+
+ifeq ($(and $(CONFIG_ARCH_HAS_NOLIBC),$(CONFIG_HEADERS_INSTALL)),y)
+
+NOLIBC_USERCFLAGS := -nostdlib -nostdinc -static -ffreestanding \
+		     -fno-asynchronous-unwind-tables -fno-stack-protector \
+		     -I$(objtree)/usr/include -I$(srctree)/tools/include/nolibc/
+
+NOLIBC_USERLDFLAGS := -nostdlib -nostdinc -static
+
+endif # CONFIG_ARCH_HAS_NOLIBC && CONFIG_HEADERS_INSTALL

-- 
2.53.0


