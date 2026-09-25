Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 159ACC9832C
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 19:30:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC4636B008A; Fri, 25 Sep 2026 15:30:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9C186B008C; Fri, 25 Sep 2026 15:30:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8BFD6B0092; Fri, 25 Sep 2026 15:30:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B04BE6B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:30:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E9091406D9
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:30:20 +0000 (UTC)
X-FDA: 85253275800.03.3C50C7C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 83EC240007
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:30:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C8dc9noG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of nsc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nsc@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790364618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ueH+xY9RFLDadkvffxnfvNnn+Ri87HVM6QE0V6wob0=;
	b=moxXi9Zsqnk4yAHelbOUUxKY6+jhmJwsiO8G2d21gcrB/hEMq4UrFPpahRoc0XHB7YgCG0
	tVy3DuUsF4FBIfZixG6siKlKKH77W859oGyfCcp/ezh1WLERTRgenbG6tTEFh/8df47iHz
	lEGuT89qUuezdm8HsUVreFquaCfWUJo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C8dc9noG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of nsc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nsc@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790364618;
	b=X2ixh11tHa9uDNu/Znq09dox0n2RyHCW+JcbLUP0SQyHPQXNHjkjgO3jm5xzQdaZ0w+P0v
	sKSSLUAURoOWDsRGZiEtSis+T1Ru7pnNqnXfDabs/JgWpbzGsoYzxF+pV3SYWAVVYKJO9b
	AgnKiPTFb1QnIa6bt0LyrzgwOYtlrX4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 9D6AC60235;
	Fri, 25 Sep 2026 19:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D79F01F000FF;
	Fri, 25 Sep 2026 19:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790364617;
	bh=4ueH+xY9RFLDadkvffxnfvNnn+Ri87HVM6QE0V6wob0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=C8dc9noGHQjBwf28Now6cCcxFcUU////WF4hn1dVqirGbH4FP50676hsthbrEK9XT
	 /r8t8nEZYE82sQtkx2ZeRAwJZaEVSITJgwspW7vs8nNaFsXfk8SYy2e1ZsW5sg9Ei0
	 PjKz8/x+qANh+zO7NvTzvCE6T89DkfSTF3Ra2Mee5Wuwq1MxvrQ+i9WBzuoWiD6l1Y
	 pbA81vm9ef7tO+lQaJkHbKLQ5wSxQW2ByjrEOa0GU49v6pM6QkTd4Y8JyDg+dTQ1Wl
	 6RLjygYOBwvCuDXf4Z2okchF4LehMQWj7mjyJz+joKr1ljmH491RWX7flB2mXe6JnR
	 kZyP6FPzIlHsA==
From: Nicolas Schier <nsc@kernel.org>
Date: Fri, 25 Sep 2026 21:29:31 +0200
Subject: [PATCH v3 2/2] kbuild: Move gen_init_cpio and gen_initramfs.sh to
 scripts/
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260925-move-gen_init_cpio-to-scripts-v3-2-99c493f76722@kernel.org>
References: <20260925-move-gen_init_cpio-to-scripts-v3-0-99c493f76722@kernel.org>
In-Reply-To: <20260925-move-gen_init_cpio-to-scripts-v3-0-99c493f76722@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Luis Augenstein <luis.augenstein@tngtech.com>, 
 Maximilian Huber <maximilian.huber@tngtech.com>, 
 Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Willy Tarreau <w@1wt.eu>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Askar Safin <safinaskar@gmail.com>, linux-doc@vger.kernel.org, 
 kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Mailer: b4 0.17-dev-1f2f7
X-Developer-Signature: v=1; a=openpgp-sha256; l=13943; i=nsc@kernel.org;
 s=20250924; h=from:subject:message-id;
 bh=XpTYRbMlGKwi40d1/0eAJWWcp4caSEJnFdW+BVK84sQ=;
 b=owEBbQKS/ZANAwAKAQdSCnAWJhJpAcsmYgBqtsugdXGpSsErm6kR/RRFswWRq2VKSgYXskrNi
 Cb/ajzwxlmJAjMEAAEKAB0WIQSHQTenhzckp4G+wsYHUgpwFiYSaQUCarbLoAAKCRAHUgpwFiYS
 aQMWD/9Js/SXxIWauSbDkwoMCxF9PYuA+rrZTaRr6VGMqg3PHBuVkO5R/FxF8+LOCyedkJb6I/8
 FUCtpoKgWxWsyyg/ht6n3pvqedIdjFKnRO2lR0A95WTJ+2hcXg1rw3pla6Q0llYDk9Bu0LUILVO
 KGx6FRcs6AwmJ/H0yrXHLzsSGUChZ91jcwtMkkOnRWfHRsFnum5JI8T9G+N+m6jwLwWGY16SbFe
 NZE76CMWRKMYUO6rjRwJj7AU2l8wRtWAoar1Cs9lk6Q4uLq114dO86k2J28tqk+ffNJIYKKpg1U
 Z3MAuxKhBGxj7lR1PmF02STntuVAba52Z33EfP1FfGQ+B/Boc18kNvvCwN4kn0hFlytS+nmGWen
 kfo2zFtOg/rWjC1r/3lSwAnKbnDR/G+MFrpRDiJVl3fihzTGp0FlThQad8d/ztbag7QEaI16rNX
 BCTa/+2hQsJn5EX9RisXdggc+/iK5crp25MgotM4RylY0imoZdCQG3wBZGgFWNC0+oARwERcvlt
 toEit3KXgUsKwrU1eXVIx1P/KA6gVXt/cisebfafNMgJIXNxMShn6E38u6Tf9ZzIO9Kjfm81lP4
 r8aX1NpNRwQ3x4tSBsE2bqxg3AhJ6tF5g5SHR8rp9u7A0vVCfhF1vcI2jt3+d//OcHyZenkVToF
 4BDmVXeqHJeQnJQ==
X-Developer-Key: i=nsc@kernel.org; a=openpgp;
 fpr=18ED52DBE34F860EE9FBC82B7D97093255A0CE7F
X-Rspamd-Queue-Id: 83EC240007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 9o9jqwwjd89j57chobnzo5pnnt16herg
X-HE-Tag: 1790364618-315054
X-HE-Meta: U2FsdGVkX19G9EoMFtCW1ZBef9Q2nCxHqRoXb82L/4xX7u5BjI+pT/IG7mNQRl2ATjWvBA/oOExwJGc0bMgjYTDAmwgo0H7koeT+1SIAs3A34Wil5B8Xe5b+qpcBtUpZWarXZynV4dFQ30V/LREzTIeT+d9Wwp594ORyLplTYUU4J7uKLDnSTbtp20xUBKCZvs6m63D4ao99SulAHad/yEO2aULfQQDX6MEnassthF8VoZk5pP2V1mO++pQmehoaMf7l9GQS0zCPy4woFgiP9MMIEVg4lQjyM3y9iRlvhzIk+1W+tfThV7RBnGgfLOmwaYUBMsxe/UWOyg21KjawckedrIG7IIbZod1SZ+0SYoB8eQ0DLKwibSCKpsiiidXft7jqQK/LlAOahK+Epdspq+MkyOTKfXqHii51u+grrrs/OoZJFMmpJvDXOUfQNwzNrzuuffvKYffmC2NxE9qmmTJ4/yGNb98nfqvKHt94eRW7ZW6F7eX68GGOVKVoCW6mBZjnP88nenCXKwB4vwuxn2P1/RYp05lEAVCEHwCFm8HNP5tzoOqGRxlPAlqemJW9WSb6LCFYxxxKmWo6JH4Iu/FmBwZJxl0WY/optLbJP5msyd1ARcypeTR25CZFcK6OTPxYH2ZEdy17IksoH5jjDXZRXTgVbFAb/kHT3ua1OuSq5aSyImaNn5kVfcN6XKpbDRyuu6GKsx43jU91oW4G2gxIBWOwXS3HR9zMJsXF7MtrQK+kU4z7gXrV+2dwNIkrClzrLZP2hrUqHvMlVGk4KpcPF0s551Ko/aPIVd9ROSfgxED9xyxcyCENNcPR9Ond/Lk7MqpmMqkDLnRjgzo1GRRmYoGSl35QRuqUcTjvkSOMqFajfWWEKGFnRQwkOrUTVcS0XMQkNGqdQlZ8JhXyOLDnNShIJEAonELqAWtzRQP6KkKz92eZVJmAQzRHyfc8VyTSJ/qU26A2dOEOw9c
 YL/I8F9v
 W6SQgRUBBNrPPCNHcYHB6MX2pC9NEScQUTwb3qORzGWjT1NzUB7AIm/NDZ8pgKmBMFLu3lXB3D0ebp3YJni6lyoC2cb5J+0Ryt8OpuYgl5cZEVj+wPITpEjjhbh2V7rjkXGApFfH//pnrKAODWOdo6qxLdOJIcP7Si685kQleqoAwdJj6VgaT/Y6mlQbWn39SCf6fBZ4ke3vJ7ancpQypmnkHtaSRMaIWZ33VQTG9GxQ7giZxmRJyIdGoDBWs9eca5zjYVSrlMM/mU8ZL4pHFuznsdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

gen_init_cpio and gen_initramfs.sh are part of kbuild and required for
all kernel builds w/ CONFIG_BLK_DEV_INITRD.  Move both to scripts/ to be
more clear about their importance.

Link: https://lore.kernel.org/all/aSdrCFkUQup3qb-q@derry.ads.avm.de/
Reviewed-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Nicolas Schier <nsc@kernel.org>
---
Changes in v3:
  * Update other references to usr/gen_init* (Nathan)
---
 .../early-userspace/early_userspace_support.rst          | 16 ++++++++--------
 Documentation/filesystems/ramfs-rootfs-initramfs.rst     | 10 +++++-----
 MAINTAINERS                                              |  1 +
 Makefile                                                 | 10 +++++-----
 scripts/.gitignore                                       |  1 +
 scripts/Makefile                                         |  3 +++
 scripts/Makefile.package                                 |  2 +-
 {usr => scripts}/gen_init_cpio.c                         |  0
 {usr => scripts}/gen_initramfs.sh                        |  2 +-
 scripts/remove-stale-files                               |  2 ++
 scripts/sbom/tests/cmd_graph/test_savedcmd_parser.py     |  2 +-
 tools/testing/selftests/kho/vmtest.sh                    |  2 +-
 tools/testing/selftests/nolibc/Makefile.nolibc           |  2 +-
 usr/.gitignore                                           |  4 +++-
 usr/Kconfig                                              |  2 +-
 usr/Makefile                                             |  4 +---
 16 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/Documentation/driver-api/early-userspace/early_userspace_support.rst b/Documentation/driver-api/early-userspace/early_userspace_support.rst
index 60d1e1bc9413..1070f82e3578 100644
--- a/Documentation/driver-api/early-userspace/early_userspace_support.rst
+++ b/Documentation/driver-api/early-userspace/early_userspace_support.rst
@@ -55,9 +55,9 @@ user root (0).  INITRAMFS_ROOT_GID can be set to a group ID that needs
 to be mapped to group root (0).
 
 A source file must be directives in the format required by the
-usr/gen_init_cpio utility (run 'usr/gen_init_cpio -h' to get the
+scripts/gen_init_cpio utility (run 'scripts/gen_init_cpio -h' to get the
 file format).  The directives in the file will be passed directly to
-usr/gen_init_cpio.
+scripts/gen_init_cpio.
 
 When a combination of directories and files are specified then the
 initramfs image will be an aggregate of all of them.  In this way a user
@@ -69,17 +69,17 @@ early userspace image can be built by an unprivileged user.
 
 As a technical note, when directories and files are specified, the
 entire CONFIG_INITRAMFS_SOURCE is passed to
-usr/gen_initramfs.sh.  This means that CONFIG_INITRAMFS_SOURCE
+scripts/gen_initramfs.sh.  This means that CONFIG_INITRAMFS_SOURCE
 can really be interpreted as any legal argument to
 gen_initramfs.sh.  If a directory is specified as an argument then
 the contents are scanned, uid/gid translation is performed, and
-usr/gen_init_cpio file directives are output.  If a file is
-specified as an argument to usr/gen_initramfs.sh then the
+scripts/gen_init_cpio file directives are output.  If a file is
+specified as an argument to scripts/gen_initramfs.sh then the
 contents of the file are simply copied to the output.  All of the output
 directives from directory scanning and file contents copying are
-processed by usr/gen_init_cpio.
+processed by scripts/gen_init_cpio.
 
-See also 'usr/gen_initramfs.sh -h'.
+See also 'scripts/gen_initramfs.sh -h'.
 
 Where's this all leading?
 =========================
@@ -142,7 +142,7 @@ b) some device and filesystem drivers built as modules and stored in an
 
 c) using initramfs.  The call to prepare_namespace() must be skipped.
    This means that a binary must do all the work.  Said binary can be stored
-   into initramfs either via modifying usr/gen_init_cpio.c or via the new
+   into initramfs either via modifying scripts/gen_init_cpio.c or via the new
    initrd format, an cpio archive.  It must be called "/init".  This binary
    is responsible to do all the things prepare_namespace() would do.
 
diff --git a/Documentation/filesystems/ramfs-rootfs-initramfs.rst b/Documentation/filesystems/ramfs-rootfs-initramfs.rst
index 165117a721ce..4263fe06115d 100644
--- a/Documentation/filesystems/ramfs-rootfs-initramfs.rst
+++ b/Documentation/filesystems/ramfs-rootfs-initramfs.rst
@@ -155,7 +155,7 @@ specification such as the following example::
   dir /mnt 755 0 0
   file /init initramfs/init.sh 755 0 0
 
-Run "usr/gen_init_cpio" (after the kernel build) to get a usage message
+Run "scripts/gen_init_cpio" (after the kernel build) to get a usage message
 documenting the above file format.
 
 One advantage of the configuration file is that root access is not required to
@@ -167,9 +167,9 @@ Documentation/driver-api/early-userspace/early_userspace_support.rst for more de
 The kernel does not depend on external cpio tools.  If you specify a
 directory instead of a configuration file, the kernel's build infrastructure
 creates a configuration file from that directory (usr/Makefile calls
-usr/gen_initramfs.sh), and proceeds to package up that directory
-using the config file (by feeding it to usr/gen_init_cpio, which is created
-from usr/gen_init_cpio.c).  The kernel's build-time cpio creation code is
+scripts/gen_initramfs.sh), and proceeds to package up that directory
+using the config file (by feeding it to scripts/gen_init_cpio, which is created
+from scripts/gen_init_cpio.c).  The kernel's build-time cpio creation code is
 entirely self-contained, and the kernel's boot-time extractor is also
 (obviously) self-contained.
 
@@ -313,7 +313,7 @@ the above threads) is:
 2) The cpio archive format chosen by the kernel is simpler and cleaner (and
    thus easier to create and parse) than any of the (literally dozens of)
    various tar archive formats.  The complete initramfs archive format is
-   explained in buffer-format.rst, created in usr/gen_init_cpio.c, and
+   explained in buffer-format.rst, created in scripts/gen_init_cpio.c, and
    extracted in init/initramfs.c.  All three together come to less than 26k
    total of human-readable text.
 
diff --git a/MAINTAINERS b/MAINTAINERS
index cc3cae2e378b..6a76fbf6ed57 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14139,6 +14139,7 @@ F:	scripts/basic/
 F:	scripts/clang-tools/
 F:	scripts/container
 F:	scripts/dummy-tools/
+F:	scripts/gen_init*
 F:	scripts/include/
 F:	scripts/install.sh
 F:	scripts/mk*
diff --git a/Makefile b/Makefile
index 51fada9059d6..bc97a8c08e20 100644
--- a/Makefile
+++ b/Makefile
@@ -298,7 +298,7 @@ no-dot-config-targets := $(clean-targets) \
 			 %asm-generic kernelversion %src-pkg dt_binding_check \
 			 dt_style_selftest \
 			 outputmakefile rustavailable rustfmt rustfmtcheck \
-			 usr_gen_init_cpio \
+			 scripts_gen_init_cpio \
 			 run-command
 no-sync-config-targets := $(no-dot-config-targets) %install modules_sign kernelrelease \
 			  image_name
@@ -1529,9 +1529,9 @@ ifdef CONFIG_HEADERS_INSTALL
 prepare: headers
 endif
 
-PHONY += usr_gen_init_cpio
-usr_gen_init_cpio: scripts_basic
-	$(Q)$(MAKE) $(build)=usr usr/gen_init_cpio
+PHONY += scripts_gen_init_cpio
+scripts_gen_init_cpio: scripts_basic
+	$(Q)$(MAKE) $(build)=scripts scripts/gen_init_cpio
 
 PHONY += scripts_unifdef
 scripts_unifdef: scripts_basic
@@ -1832,7 +1832,7 @@ distclean: mrproper
 # Packaging of the kernel to various formats
 # ---------------------------------------------------------------------------
 
-modules-cpio-pkg: usr_gen_init_cpio
+modules-cpio-pkg: scripts_gen_init_cpio
 
 %src-pkg: FORCE
 	$(Q)$(MAKE) -f $(srctree)/scripts/Makefile.package $@
diff --git a/scripts/.gitignore b/scripts/.gitignore
index 4215c2208f7e..700456543910 100644
--- a/scripts/.gitignore
+++ b/scripts/.gitignore
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 /asn1_compiler
+/gen_init_cpio
 /gen_packed_field_checks
 /generate_rust_target
 /insert-sys-cert
diff --git a/scripts/Makefile b/scripts/Makefile
index 3434a82a119f..3d50805b0885 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -53,6 +53,9 @@ ifdef CONFIG_BUILDTIME_MCOUNT_SORT
 HOSTCFLAGS_sorttable.o += -DMCOUNT_SORT_ENABLED
 endif
 
+hostprogs += gen_init_cpio
+always-$(CONFIG_BLK_DEV_INITRD) += gen_init_cpio
+
 # The following programs are only built on demand
 hostprogs += unifdef gen_packed_field_checks
 
diff --git a/scripts/Makefile.package b/scripts/Makefile.package
index 6d36786ba31c..948ad5b679d1 100644
--- a/scripts/Makefile.package
+++ b/scripts/Makefile.package
@@ -198,7 +198,7 @@ tar%-pkg: linux-$(KERNELRELEASE)-$(ARCH).tar.% FORCE
 	$(Q)$(MAKE) -f $(srctree)/Makefile INSTALL_MOD_PATH=$@/$(INSTALL_MOD_PATH) modules_install
 
 quiet_cmd_cpio = CPIO    $@
-      cmd_cpio = $(CONFIG_SHELL) $(srctree)/usr/gen_initramfs.sh -o $@ $<
+      cmd_cpio = $(CONFIG_SHELL) $(srctree)/scripts/gen_initramfs.sh -o $@ $<
 
 modules-$(KERNELRELEASE)-$(ARCH).cpio: .tmp_modules_cpio
 	$(call cmd,cpio)
diff --git a/usr/gen_init_cpio.c b/scripts/gen_init_cpio.c
similarity index 100%
rename from usr/gen_init_cpio.c
rename to scripts/gen_init_cpio.c
diff --git a/usr/gen_initramfs.sh b/scripts/gen_initramfs.sh
similarity index 99%
rename from usr/gen_initramfs.sh
rename to scripts/gen_initramfs.sh
index 7eba2fddf0ef..27ac1fd48001 100755
--- a/usr/gen_initramfs.sh
+++ b/scripts/gen_initramfs.sh
@@ -247,4 +247,4 @@ done
 
 # If output_file is set we will generate cpio archive
 # we are careful to delete tmp files
-usr/gen_init_cpio $output $timestamp $cpio_list
+scripts/gen_init_cpio $output $timestamp $cpio_list
diff --git a/scripts/remove-stale-files b/scripts/remove-stale-files
index 6e39fa8540df..e46337e4bfb8 100755
--- a/scripts/remove-stale-files
+++ b/scripts/remove-stale-files
@@ -26,3 +26,5 @@ rm -f scripts/selinux/genheaders/genheaders
 rm -f *.spec
 
 rm -f lib/test_fortify.log
+
+rm -f usr/gen_init_cpio
diff --git a/scripts/sbom/tests/cmd_graph/test_savedcmd_parser.py b/scripts/sbom/tests/cmd_graph/test_savedcmd_parser.py
index d7776f072e03..93787a1cd156 100644
--- a/scripts/sbom/tests/cmd_graph/test_savedcmd_parser.py
+++ b/scripts/sbom/tests/cmd_graph/test_savedcmd_parser.py
@@ -338,7 +338,7 @@ class TestSavedCmdParser(unittest.TestCase):
 
     # gen_initramfs.sh command tests
     def test_gen_initramfs(self):
-        cmd = "sh ../usr/gen_initramfs.sh -o usr/initramfs_data.cpio -l usr/.initramfs_data.cpio.d    ../usr/default_cpio_list"
+        cmd = "sh ../scripts/gen_initramfs.sh -o usr/initramfs_data.cpio -l usr/.initramfs_data.cpio.d    ../usr/default_cpio_list"
         expected = "../usr/default_cpio_list"
         self._assert_parsing(cmd, expected)
 
diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
index 0014bd76e88d..1e86ffcc3a79 100755
--- a/tools/testing/selftests/kho/vmtest.sh
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -100,7 +100,7 @@ file /init $tmp_dir/init 0755 0 0
 file /kernel $kernel 0644 0 0
 EOF
 
-	"$build_dir/usr/gen_init_cpio" "$tmp_dir/cpio_list" > "$initrd"
+	"$build_dir/scripts/gen_init_cpio" "$tmp_dir/cpio_list" > "$initrd"
 }
 
 function run_qemu() {
diff --git a/tools/testing/selftests/nolibc/Makefile.nolibc b/tools/testing/selftests/nolibc/Makefile.nolibc
index f70c8dfca018..380200b152e4 100644
--- a/tools/testing/selftests/nolibc/Makefile.nolibc
+++ b/tools/testing/selftests/nolibc/Makefile.nolibc
@@ -295,7 +295,7 @@ run-user: nolibc-test
 	$(Q)$(REPORT) $(CURDIR)/run.out
 
 initramfs.cpio: kernel nolibc-test
-	$(QUIET_GEN)echo 'file /init nolibc-test 755 0 0' | $(objtree)/usr/gen_init_cpio - > initramfs.cpio
+	$(QUIET_GEN)echo 'file /init nolibc-test 755 0 0' | $(objtree)/scripts/gen_init_cpio - > initramfs.cpio
 
 initramfs: nolibc-test
 	$(QUIET_MKDIR)mkdir -p initramfs
diff --git a/usr/.gitignore b/usr/.gitignore
index 8996e7a88902..13bf7a38355c 100644
--- a/usr/.gitignore
+++ b/usr/.gitignore
@@ -1,4 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
-/gen_init_cpio
 /initramfs_data.cpio
 /initramfs_inc_data
+
+# Keep around until cleanup in scripts/remove-stale-files
+/gen_init_cpio
diff --git a/usr/Kconfig b/usr/Kconfig
index 9279a2893ab0..f87dd4bac418 100644
--- a/usr/Kconfig
+++ b/usr/Kconfig
@@ -13,7 +13,7 @@ config INITRAMFS_SOURCE
 	  to be used as an initramfs image.  Directories should contain a
 	  filesystem layout to be included in the initramfs image.  Files
 	  should contain entries according to the format described by the
-	  "usr/gen_init_cpio" program in the kernel tree.
+	  "scripts/gen_init_cpio" program in the kernel tree.
 
 	  When multiple directories and files are specified then the
 	  initramfs image will be the aggregate of all of them.
diff --git a/usr/Makefile b/usr/Makefile
index e8f42478a0b7..5b97ee66c00a 100644
--- a/usr/Makefile
+++ b/usr/Makefile
@@ -16,8 +16,6 @@ obj-$(CONFIG_BLK_DEV_INITRD) := initramfs_data.o
 
 $(obj)/initramfs_data.o: $(obj)/initramfs_inc_data
 
-hostprogs := gen_init_cpio
-
 ramfs-input := $(CONFIG_INITRAMFS_SOURCE)
 cpio-data :=
 
@@ -72,7 +70,7 @@ quiet_cmd_initfs = GEN     $@
 # 2) There are changes in which files are included (added or deleted)
 # 3) If gen_init_cpio are newer than initramfs_data.cpio
 # 4) Arguments to gen_initramfs.sh changes
-$(obj)/initramfs_data.cpio: $(src)/gen_initramfs.sh $(obj)/gen_init_cpio $(deps_initramfs) FORCE
+$(obj)/initramfs_data.cpio: $(srctree)/scripts/gen_initramfs.sh scripts/gen_init_cpio $(deps_initramfs) FORCE
 	$(call if_changed,initfs)
 
 endif

-- 
2.47.3


