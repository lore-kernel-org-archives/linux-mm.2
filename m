Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5DEACA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 655128E0014; Mon, 11 Aug 2025 04:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605248E000A; Mon, 11 Aug 2025 04:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6B98E0014; Mon, 11 Aug 2025 04:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3491E8E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:25:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F3DB3140707
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:25:39 +0000 (UTC)
X-FDA: 83763792798.14.5655629
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3AA7240002
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:25:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J+xamGjR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754900738; a=rsa-sha256;
	cv=none;
	b=nxFE1bWHJyoJ0py4FPDQDF+0wVGaLLqR+COE9hJiL+tZKbV03msGTvVONZ+E5qqexs/HO3
	9Y7P2P6wlGPVrzWiRTPLGMKj4m3So3G2i3wq43jrCzfkphhtERWWfT2hOLrtbwTeXV1DQV
	odMp1wdYEdR6PjD19hRjGmgn/tbh29c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J+xamGjR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754900738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tlbJB+L4R3O7acATDOIm1feJEqppF/sXRloShshIIoo=;
	b=8lX8Edin9RkJInS+6yLuZiKIDfI0VTF+VXSO78klxb4PVC6eMvHQQ6ZTmCxu7ZsuSgBnn/
	PvP7+i+FuQC42rU0NeJbhAmOMCyH+zwxOrJOTNZ3maf6hg0IsEUkziiWUq9EJ9y/jbWBmb
	ffsZiJaWnGztVEeBrDgfKbpoPU+B7OM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 75A0A5C5BF9;
	Mon, 11 Aug 2025 08:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0AADC4CEF8;
	Mon, 11 Aug 2025 08:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754900737;
	bh=x9yDF0ETg1DZV483jmCAS7zdZyJxfX8QtrhsIOYLE3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+xamGjRj0qBZ8f+MKHSAySNijepwnYwt5H+o27/gEbgnXE3KQltdcbB0iHOqwdja
	 e3uxwJ+w5yxH41yVobpeGbK+tifeiohOed1kRfcIgZnRmaI0/zJph8jQ5jZVoQmEeA
	 SF8HdzQuD9/keUQlz5XLJhcPyyioXMA19Oobp3ATZm0iBRUf4g+5zifCSJpt16V6ae
	 aZW1oBggKLDmPu7m2OsuFxhT2HtyISgt7vOI/0pde2gNl2gwyV7EtRwVfP6dGR1CnN
	 VBZIFHyuTocPG+JYnv9+2PApCwJFsdR/g/PfEDfrLK1MTZdRF9ha1opuD5ix9iZ9en
	 HgZmIqifpPCkg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=DFschuh?= <linux@weissschuh.net>,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/3] selftest/kho: update generation of initrd
Date: Mon, 11 Aug 2025 11:25:10 +0300
Message-ID: <20250811082510.4154080-4-rppt@kernel.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250811082510.4154080-1-rppt@kernel.org>
References: <20250811082510.4154080-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3AA7240002
X-Stat-Signature: 1i4pec4seiznia1r8kyzjhrnbpshgz7c
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754900738-584405
X-HE-Meta: U2FsdGVkX183Qrj+r9dHq1rMj+jo6shldvaldw+j6NlNkDj4HWg2VCSY3Fvtob68vVEM61G2VZ02MI9+DMarJRBnBpwZwWWDwi4ggNLRprsVuorJvVedLriQMaA+kkv1X4UQvyQD0qW2lJ9bO5uPlm9S4ODaismldcC5aI+aMvRkSxYfQQJx6DmpZmcXVxclZiVJ3Bk1UDrTiGwDYkUJdOKteu5zHSObdYl0hVSxUmEYImq3EE5tBTfoBd38pZrtViSZKWEVTzvxl91QymrCrIxgQEvFfD4FE00+C3NP3w25/jgE0xzFCyQuQp7OIpTDascl4qT/apRApEbD+wvCMymdDQmxE3giN7HBUCOXHXo2Yq+CD5gr0OVrBrnJYilr2kf/brKlRps/dry+f8OhyOD180HnH8IoTa7FQaVk4bfqtkaR3eYn/SnazpxFBwe+AmFuiiQ65gJ9ZWw8cLtZOiZZmBxfurOquZ0iXk7tcoLaggh2cAz1O96M7ixzSlajSC7gTJgZSj82xbjcb1XfmRzDRVGqZLio/iPGrzGSW2iwT8uUJRv8Nqi3UHoe1SNdPQR6ylHNCH8Rz2B/bvKddVRb0tQfVZSmIKRv8HzWlSzJR5xFGXPb9Ji0YqHzabGLzRmHUmigKHNvaEFuxzfwczeR330JzMVHIdM8IReWfoxPF/hAFEO0DGbQ1zF/eRmMr6O0H7tzw837L+7ZWCSWWFIGAc63LtovKTPwkdhSHXOVFveFDjj6L6o1AaeitoGq71hSwwfErZnw7+QEaQ0uzeLKMZYiSSWPYjlLpX9u1X5iXR0qF7yAnU7grnU+ujiVEXOiIwMK3ohkPMy63rEBaeqvwkPAzD6050SYkm/1Zm+Ue6/TH58aj51QM8cZIHo8peIDmAt+TqSgrhVULz5QQBfSbyPBaznRmxBUvxwqgMxyfIsTD+Yel9z2ZBRPiNmpx/kk6F9ehz0VkLINg6u
 IyJ5/HOe
 CVs7Lhpa0Ix8hJ76HtPgKfeSDmEZOjynazPAqz1WJhWm1TdkKj35m9luRsDnuXLwFku7HsrS7YhbR1r9mfsuDP5Qn9eRZwaJewN7j64+06PRpuy5cO+FIPMbCzkjURUOHkXabmXrgIRuZeEGe3UO09nrRN1qX+vuIHvPB6daV7irqe+BTuONVAUMmqGchkxgPElaoHS0HVA4hAVw6l+J7fS4qlgq8M2OUJT+lbACEuW/KlRLlIpocr/6YLCmXZdjwBG09jEYXxxvvW9D27kEb0yumNkbB16pLopPwayWHdj3b590t1U5kEsRb2QLdUSrmR6p97n0A1asF+J5P6geipyRJfF9ThFsC6s/sFOuIPpalPME=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Use nolibc include directory rather than include a cumulative nolibc.h
on the compiler command line and replace use of 'sudo cpio' with
usr/gen_init_cpio.

While on it fix spelling of KHO_FINALIZE

Suggested-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/kho/init.c    | 13 ++++---------
 tools/testing/selftests/kho/vmtest.sh | 28 ++++++++++++++-------------
 2 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kho/init.c b/tools/testing/selftests/kho/init.c
index 8034e24c6bf6..6d9e91d55d68 100644
--- a/tools/testing/selftests/kho/init.c
+++ b/tools/testing/selftests/kho/init.c
@@ -1,22 +1,17 @@
 // SPDX-License-Identifier: GPL-2.0
 
-#ifndef NOLIBC
-#include <errno.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <fcntl.h>
-#include <syscall.h>
+#include <sys/syscall.h>
 #include <sys/mount.h>
 #include <sys/reboot.h>
-#endif
+#include <linux/kexec.h>
 
 /* from arch/x86/include/asm/setup.h */
 #define COMMAND_LINE_SIZE	2048
 
-/* from include/linux/kexex.h */
-#define KEXEC_FILE_NO_INITRAMFS	0x00000004
-
-#define KHO_FINILIZE "/debugfs/kho/out/finalize"
+#define KHO_FINALIZE "/debugfs/kho/out/finalize"
 #define KERNEL_IMAGE "/kernel"
 
 static int mount_filesystems(void)
@@ -32,7 +27,7 @@ static int kho_enable(void)
 	const char enable[] = "1";
 	int fd;
 
-	fd = open(KHO_FINILIZE, O_RDWR);
+	fd = open(KHO_FINALIZE, O_RDWR);
 	if (fd < 0)
 		return -1;
 
diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
index ec70a17bd476..3f6c17166846 100755
--- a/tools/testing/selftests/kho/vmtest.sh
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -10,7 +10,6 @@ kernel_dir=$(realpath "$test_dir/../../../..")
 
 tmp_dir=$(mktemp -d /tmp/kho-test.XXXXXXXX)
 headers_dir="$tmp_dir/usr"
-initrd_dir="$tmp_dir/initrd"
 initrd="$tmp_dir/initrd.cpio"
 
 source "$test_dir/../kselftest/ktap_helpers.sh"
@@ -81,19 +80,22 @@ EOF
 function mkinitrd() {
 	local kernel=$1
 
-	mkdir -p "$initrd_dir"/{dev,debugfs,proc}
-	sudo mknod "$initrd_dir/dev/console" c 5 1
-
-	"$CROSS_COMPILE"gcc -s -static -Os -nostdinc -I"$headers_dir/include" \
-			-fno-asynchronous-unwind-tables -fno-ident -nostdlib \
-			-include "$test_dir/../../../include/nolibc/nolibc.h" \
-			-o "$initrd_dir/init" "$test_dir/init.c" \
-
-	cp "$kernel" "$initrd_dir/kernel"
+	"$CROSS_COMPILE"gcc -s -static -Os -nostdinc -nostdlib \
+			-fno-asynchronous-unwind-tables -fno-ident \
+			-I "$headers_dir/include" \
+			-I "$kernel_dir/tools/include/nolibc" \
+			-o "$tmp_dir/init" "$test_dir/init.c"
+
+	cat > "$tmp_dir/cpio_list" <<EOF
+dir /dev 0755 0 0
+dir /proc 0755 0 0
+dir /debugfs 0755 0 0
+nod /dev/console 0600 0 0 c 5 1
+file /init $tmp_dir/init 0755 0 0
+file /kernel $kernel 0644 0 0
+EOF
 
-	pushd "$initrd_dir" &>/dev/null
-	find . | cpio -H newc --create > "$initrd" 2>/dev/null
-	popd &>/dev/null
+	"$build_dir/usr/gen_init_cpio" "$tmp_dir/cpio_list" > "$initrd"
 }
 
 function run_qemu() {
-- 
2.47.2


