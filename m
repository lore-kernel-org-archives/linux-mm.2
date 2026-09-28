Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B94CCCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF99F6B008A; Mon, 28 Sep 2026 13:27:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD06A6B008C; Mon, 28 Sep 2026 13:27:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FDF96B0092; Mon, 28 Sep 2026 13:27:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5323F6B008A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:27:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D430940253
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:27:38 +0000 (UTC)
X-FDA: 85263852996.02.9F94A08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E708120010
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:27:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BpDq5Kzl;
	spf=pass (imf03.hostedemail.com: domain of nsc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nsc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790616456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cITydetfbk+BECmH2A2K7tEbUVJLhbtLbo/ZZwPHqos=;
	b=2LVtFTl77Bo3RKJnjnTsw+nNhb0KRuBig09vb1S1rsJbDqGBXaiNdC2y0CuR7iv294y9Xb
	UzdDm9suNYb60K0AeLG66MFPPkVWM87l6dXH5vPM4BMxvqDNecNvlJ4bb3xrzgdiviMifV
	O+rg8iub10ruaM6tJ56dYX4HxEHtGv8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790616456;
	b=fyDBb0Fzt7aNtzhhhti9vGxjXG23UEPpIEt3tIIiq84w4wkS80/l1fH7FJcePmThfzttDg
	7xcpl5BgambLRVd5sGfh/rehdj7Znr1h/I7dWwhQVA9FhGt/ZYk2zZqIsw5jZKM1UAcK/w
	u5jLzU3dj9CgI2/xwbz0BM4ZrqiuiUs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BpDq5Kzl;
	spf=pass (imf03.hostedemail.com: domain of nsc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nsc@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 71A32601FA;
	Mon, 28 Sep 2026 17:27:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AA6171F000FF;
	Mon, 28 Sep 2026 17:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790616456;
	bh=cITydetfbk+BECmH2A2K7tEbUVJLhbtLbo/ZZwPHqos=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BpDq5Kzl5IOP+PM+p1H7zSZG71QSGgWxuMwt0WP8XvVBmNmVDVmj6VFyE9AuXTQn4
	 BXqV9eIqt5X8i1gMAUTZHDfjBVILnnm/P8XUa9C3UNitlszV8oP1J90P3nH2o4+hON
	 uKpCFVwsEhpazbayU31mKYB4J2ggV39ArqMYsU6kW+2MsMIiJ1ZnhKQ9ap9BU0zPTs
	 UQtxBRIguQOkhioBuGIyQPuQ0DX2bJIhgHsRj671xm5wi7YmAfai3x3OBobT1MYL3N
	 fM/M+lhgFLLbWfF2Golg3L92ek8lPKpv0rq1KvNMzPmWv+y1YL+ns20MSAhwYXm6o+
	 YjJNkdBdP63eg==
From: Nicolas Schier <nsc@kernel.org>
Date: Mon, 28 Sep 2026 19:26:58 +0200
Subject: [PATCH v4 2/2] kbuild: Move gen_init_cpio and gen_initramfs.sh to
 scripts/
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260928-move-gen_init_cpio-to-scripts-v4-2-f437a33c40ac@kernel.org>
References: <20260928-move-gen_init_cpio-to-scripts-v4-0-f437a33c40ac@kernel.org>
In-Reply-To: <20260928-move-gen_init_cpio-to-scripts-v4-0-f437a33c40ac@kernel.org>
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
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=16335; i=nsc@kernel.org;
 s=20250924; h=from:subject:message-id;
 bh=mcYKQj9m7IBVVIH67tl1D69tRYxHLBH407vvFnIlO6I=;
 b=owEBbQKS/ZANAwAKAQdSCnAWJhJpAcsmYgBquqNoQUexeZ66PPzdvJvlMXS5kuHiMoCgulYNf
 R1qCqvDqXWJAjMEAAEKAB0WIQSHQTenhzckp4G+wsYHUgpwFiYSaQUCarqjaAAKCRAHUgpwFiYS
 adnzEACd9KrF5MEW9fiHG32UWncx8FI+V0JUuklf9wI+UnnYowW1ra1cld9ZXP0WYIjZQygidiG
 ZitVgqL1sPT4/EjrFeUeOwRCw7llhlruKsWKxVJh7ccz0tKNrfz8Ilzwnut6mnA7SZl/yseoXOc
 rEgrvoogW9gaCHXQHAve3JR5clDJZdeXHYKIIlTb+5rCdym0oh+Das5HKbtpaRxgxMg9ZpU3/cs
 CYM//W54pAupxNwI2lB882qfHwjF9h2hrB1kK1ewmd8d7evReoFfikDFU0db60/FAzOJvOG5zIr
 pAw2kMdQhk7r69/9rYfFsb7HqHbeeUH3YMfx4ffaqjWUPvwHFNMt3wgQbuGdrBPBHPHnNy2lU6y
 I2mlEnpFatBOzXK+L4FNJ6sqeQ8sZWQIL/jfLyPAreD3LH7ALVIAxNDyNfI9ttx8IIVFF+Umft4
 3LYN51xg3mP7XZQB3S3+EV4B/Uzd46vBGimXqUj6y687RbEXqpaiGYa6JJQgM6zUF+TRwP2G1rp
 qkrcVs6UgSfH9NFjnRat1/clPLzDrkdEkh/XUyzXg2ArYgODaUxtXfhPgG+kl3FJaFH52OJ7QiA
 /9ic7sOSQsSrQeIX8I4Ufguyrsavq8XT2oNE0aB0j9arKzc7DXzQDgLLfvnHviEhBpKZEJMA7GS
 TApQTS1Qbb1ahzg==
X-Developer-Key: i=nsc@kernel.org; a=openpgp;
 fpr=18ED52DBE34F860EE9FBC82B7D97093255A0CE7F
X-Rspam-User: 
X-Stat-Signature: 7iax3k5ya91kho4mrbagm1n819npzstf
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E708120010
X-HE-Tag: 1790616456-658532
X-HE-Meta: U2FsdGVkX1+J2L/Gr6YIVZo/MJ3s3bhgeh9U2Ehk3zpBFIk4rxLLmsCi7L0mLpNi2S3qCXCA1CPgvX3qu++PM5BLXfngTST5FsYvnD2Xx7txcM4d8WxWL1tNKaiHx6znojhszaGdBCPUZZRYxrT/6ebTrstgMzYyvOGOSVC5uaxH2b6hOAw1Z+/BWoLCGh8hGjmm9K3m/s2J3JJnShGr27IyenOhsG+bNHPgF2hANb65vYn2HOO42sU3jTjCrQ2QuYO59lOWo33zDhR7nsqhyAIvUSM+ZQljlESscw6S5YYLFsPy3P2ns7inpoIKERyJvJnMiS29X4d3/cs8RYw9xoDXcuTveS2S+EifT895UGWv2MZpZqCc9A6U8bSjzdvpTP9RHtMxo+ZEOMfu5m3mCUoHWfDy3n87D34ifQBBdTr6eAU/tzk6PVT9vZRVdiiAVdqbkTjjx/jfk6Oo05PywRNtwlObscD3wKX0nHG9PbXOwFAykuaacwfLNnsnSLp/W2VWX5K0ZsJgK4SyVKBtfCq4T3D3ple4hDzzGK59DZ8pBxwwB0ja5wBHS7298Ckk/C5CXoFZhvgsq1VKBo5wSlrsoIJ1eHEr00g8hHbcu9dKnAN7Is6I7trhMBdyO02hLR5UJGClou71cgFBu18n2PZC3C1f0TqhiCiM4/kppMN7ltkssnC40cBGedrTVnsD9UdQvCdrq6DG7Erc/nvgEBiEN9kGhhuXwliI+VFcvsKX8KpI8m54y/5imz+cQvoiCuOMZvnxX4ARuTmDSiowNK4yGw5tXRRv1lpdEABietFMAyRCw54Kw/neKQjAmfTqY4CtPqraSACFSx48ZyFAaanNF9876jRDzFj86ZQMtsz6OMMd5Z6jk/gY5YUOJc1k/7Ge4lB/GXAD2yHq4LewBn3UxbqZXL2MHHZCuGv/p32XyiNnm8/HuLBN+nmPxKnymLElIXYjerzvy4GTJjv
 mw42DUdA
 GurKU1qsJ3eEQXEGpS8kkoNeA6e///fdjHLawQc5yajWs2UxJIlckEY0IbnHaYx+zfNyndF+k3Cuc20jAiSsXYp4rwpKfVBYanrsRyOusQuRjAfXHDozhZOvQ7EGnvckyrtU2zTchfxZM83krqW0Kv6wjM52xLgXf4rbbVT2yYv4x3eiyLc1L7RhhJ0o0FuuqbzWDxyuWTAjGsCNRCNhcj4JY0PYln9iqEliarNbtK2G7W1uX6Nti6/qDGsdob1hZ1uCz8tJ4J3jggUIBaFTRKcuVKA==
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
Changes in v4:
  * Update tools/testing/selftests/liveupdate/vmtest.sh to new path of
    gen_init_cpio (Mike Rapoport)
  * Update stale comment in gen_initramfs.sh (sashiko)

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
 {usr => scripts}/gen_initramfs.sh                        |  4 ++--
 scripts/remove-stale-files                               |  2 ++
 scripts/sbom/tests/cmd_graph/test_savedcmd_parser.py     |  2 +-
 tools/testing/selftests/kho/vmtest.sh                    |  2 +-
 tools/testing/selftests/liveupdate/vmtest.sh             |  4 ++--
 tools/testing/selftests/nolibc/Makefile.nolibc           |  2 +-
 usr/.gitignore                                           |  4 +++-
 usr/Kconfig                                              |  2 +-
 usr/Makefile                                             |  4 +---
 17 files changed, 38 insertions(+), 31 deletions(-)

diff --git a/Documentation/driver-api/early-userspace/early_userspace_support.rst b/Documentation/driver-api/early-userspace/early_userspace_support.rst
index 60d1e1bc9413bcfd86e509294b3d85ee53c7b3b2..1070f82e35788f9e3c7676712636f77938472c6e 100644
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
index 165117a721ceeea6461188f15b2e65de85ee04c6..4263fe06115de146149a60d5ceca8c588e4b4fcb 100644
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
index cc3cae2e378b34aeb705cef654c720ca9f2ba223..6a76fbf6ed575d2290795cb68ce9230a770eff2a 100644
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
index 51fada9059d68a92e6f5725e45ff9a594bfd9645..bc97a8c08e20c978dd7aef0785c9fe0ff2429e04 100644
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
index 4215c2208f7e4100e8047a6ac0407e3aea9a92f3..70045654391074295ba88aa8abf7507f7b7c8ae3 100644
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
index 3434a82a119f090864ecb7c6444053d84f54461e..3d50805b0885a814ee58023c34ddf875ee0dfbe8 100644
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
index 6d36786ba31cefaf5ae2c6e2537d421b5bfb7a06..948ad5b679d110f492f5454fe636a1b923ef1a29 100644
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
similarity index 97%
rename from usr/gen_initramfs.sh
rename to scripts/gen_initramfs.sh
index 7eba2fddf0ef2e4dd3a9000fe6203e16892d1207..9c6168a9338d44ac16ed9c920f8bfa3536f60d64 100755
--- a/usr/gen_initramfs.sh
+++ b/scripts/gen_initramfs.sh
@@ -6,7 +6,7 @@
 #
 # Generate a cpio packed initramfs. It uses gen_init_cpio to generate
 # the cpio archive.
-# This script assumes that gen_init_cpio is located in usr/ directory
+# This script assumes that gen_init_cpio is located in scripts/ directory
 
 # error out on errors
 set -e
@@ -247,4 +247,4 @@ done
 
 # If output_file is set we will generate cpio archive
 # we are careful to delete tmp files
-usr/gen_init_cpio $output $timestamp $cpio_list
+scripts/gen_init_cpio $output $timestamp $cpio_list
diff --git a/scripts/remove-stale-files b/scripts/remove-stale-files
index 6e39fa8540df2f6da9d8a1d1e90e105243b495a2..e46337e4bfb8f836e2afbbfe6770ae3c6d5fe73e 100755
--- a/scripts/remove-stale-files
+++ b/scripts/remove-stale-files
@@ -26,3 +26,5 @@ rm -f scripts/selinux/genheaders/genheaders
 rm -f *.spec
 
 rm -f lib/test_fortify.log
+
+rm -f usr/gen_init_cpio
diff --git a/scripts/sbom/tests/cmd_graph/test_savedcmd_parser.py b/scripts/sbom/tests/cmd_graph/test_savedcmd_parser.py
index d7776f072e03425b9f9d006a23d04f30ecb537aa..93787a1cd1566dccd27b16e7a75023fcedb5924f 100644
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
index 0014bd76e88de6ceaa217ee28dd191154124c48a..1e86ffcc3a79e6199328c96213f842c223adda06 100755
--- a/tools/testing/selftests/kho/vmtest.sh
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -100,7 +100,7 @@ file /init $tmp_dir/init 0755 0 0
 file /kernel $kernel 0644 0 0
 EOF
 
-	"$build_dir/usr/gen_init_cpio" "$tmp_dir/cpio_list" > "$initrd"
+	"$build_dir/scripts/gen_init_cpio" "$tmp_dir/cpio_list" > "$initrd"
 }
 
 function run_qemu() {
diff --git a/tools/testing/selftests/liveupdate/vmtest.sh b/tools/testing/selftests/liveupdate/vmtest.sh
index 64fd2ab55b765fabd46a4e38de6df20958bb4072..672a9e9d685a55d363c98c722f434d76b5e08a31 100755
--- a/tools/testing/selftests/liveupdate/vmtest.sh
+++ b/tools/testing/selftests/liveupdate/vmtest.sh
@@ -152,7 +152,7 @@ file /test_binary $workspace_dir/test_binary 0755 0 0
 EOF
 
 	# Generate inner_initrd.cpio
-	"$build_dir/usr/gen_init_cpio" "$workspace_dir/cpio_list_inner" > "$workspace_dir/inner_initrd.cpio"
+	"$build_dir/scripts/gen_init_cpio" "$workspace_dir/cpio_list_inner" > "$workspace_dir/inner_initrd.cpio"
 
 	cat > "$workspace_dir/cpio_list" <<EOF
 dir /dev 0755 0 0
@@ -166,7 +166,7 @@ file /initrd.img $workspace_dir/inner_initrd.cpio 0644 0 0
 EOF
 
 	# Generate the final initrd
-	"$build_dir/usr/gen_init_cpio" "$workspace_dir/cpio_list" > "$initrd"
+	"$build_dir/scripts/gen_init_cpio" "$workspace_dir/cpio_list" > "$initrd"
 }
 
 function run_qemu() {
diff --git a/tools/testing/selftests/nolibc/Makefile.nolibc b/tools/testing/selftests/nolibc/Makefile.nolibc
index f70c8dfca01869d5f4d8328916c5d0e6a7f102e8..380200b152e4decb4ca29082733cac4f5bc1e6bd 100644
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
index 8996e7a889024fbb13511a22743a2bff01c896f1..13bf7a38355ce5a5ffc53479c573ddbf5853a0d8 100644
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
index 9279a2893ab0eede6212cba009ff6c4f4c6c419c..f87dd4bac418385f527bfc8ade67d5e9b9647d77 100644
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
index e8f42478a0b76540180d191042cd58d3e4381f19..5b97ee66c00a02e32c4383c42df6370e331f5451 100644
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


