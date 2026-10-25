Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6444606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=AxP7fTWy
Received: by kanga.kvack.org (Postfix)
	id 856196B05BB; Sun, 25 Oct 2026 13:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E0CB6B05BC; Sun, 25 Oct 2026 13:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7DB6B05BD; Sun, 25 Oct 2026 13:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FD816B05BB
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:40:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9CBF114059B
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:34 +0000 (UTC)
X-FDA: 85361863188.14.79ECA23
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id E3AAE20005
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AxP7fTWy;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792950032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bAlNiVr8BQR0wHHuK51By00coxfZadVdizds6cbggxE=;
	b=XQAEdKciGWtC+1vn93lPdtppzUDQsRYj9zqZarEfDxagw2giyCJxlXY2aPUAo4n1PKG9di
	tCEvId97f5z9JgSVESF0necj15qHtJxf433OmShUWVZ1ec4opd/cP++6tDq0gF7hYIaf8m
	f8dKLS/UDG84YTWW6bGF/YLZm08KJlE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AxP7fTWy;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792950032;
	b=FOjbnLv+hWi0lAHiE32TiehMBQteDo864kpw2QVqMSKt+NS7k53BABjmcaPa5Sf/+hjpnE
	ugOyFK+kS/kYHQW9MUlLUPjRB7X/mhi93g4n8Z6dpp8+5SMPDm3Y9Qt+U0nYzxt43Xs+AA
	fMaCdrMW+/NlJ1daYUH7JeRbAxraUYs=
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5ea969fafeeso866434e0c.0
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 10:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792950032; x=1793554832; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bAlNiVr8BQR0wHHuK51By00coxfZadVdizds6cbggxE=;
        b=AxP7fTWySh2BTAS6w5STWaH8BHP4TWR57MiZlgA1TSVxy+gufl5nbkJfteKQBpWD25
         qL7bPJW03muWlQArQ8HzwLs1lHTp+HdY+BAKLRPvr0KSQIkjnql5Qbmk7j1mLvE3ydo3
         RmWGvIMDIiYQjZCCMeFfBP+0P+MODifRD4ydQN0lXSS4eVxOg0vzJ0j7FCGWom4oZy5g
         4PXGmbxDq0jI7TJjcnA4c3JKdPHsbJBtTkKqosyi8ayRvW/zWBpkTOu/L9gMpsGxxk4I
         sT2BenS2908vlcrp8whUXETzIiPG2Sryiv4RJbtnfIGpOZeeP4id4SQkR2nhkQPxw06X
         9Jug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792950032; x=1793554832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=bAlNiVr8BQR0wHHuK51By00coxfZadVdizds6cbggxE=;
        b=nrO9bQKpl3SRgLUnXPTfgOedLN1Yq6idtoDS6tlkcXYaxqsRK3w13CY9fcYtTKjHd6
         rIn8fR5qsXmvgrahAsmrNagawnv1Y1XkWQ+I58OCHAjXpMp36F2jMfi+6GHgwsWItwah
         790YZCs5DAhzQ+gFxziK8c2YGWsQHzzqs5plRvOXaeZ3wPsZU21mkPMC5dxlnmJTg9NT
         pV9bHG1c/7cqxei2ofujyrwWHCLB3abLeSIaZMuYItWrgo46aLNqzsyPy0i5/v34Y+Il
         WymDbrsVzsOnWS2lAMXImPY7ItciROJq8NVGC/U59tmEiGObyWcOPydXbGoYLTfTRmae
         TbLg==
X-Forwarded-Encrypted: i=1; AKwUvBxoIOUaISZP21ij7x2rLcNVMcy+zhUw0VLXYMUfD8MkQGfi3m+ubDtXGLg26/ZSDcPvI5ZD/d1pIQ==@kvack.org
X-Gm-Message-State: AFq9FYJ5vxLLIHqZOBIWATBXbA2HQIZfhMlXpIflS8REZvz0ay832e0A
	5SkrtDt0Sws1v/O71+kFKKjfz62wvcFPbBypWxwg70rCdKJ3v7EyuKxnun3Ho9yjqVc=
X-Gm-Gg: AYBFou0uO9/VfX/f+3uHYSjnfQjTq1oUMp6v8RiGbzQuWjXynOkLI5Y0muvhglOVt99
	oVh5CxCMn1BzpRJRrsPUqwtVD6FtwlGWIjRzm2R7PhFiebXlQbXWpZdUuky0iRL68Jx8+CFx0uc
	iM63lwnv4sN+hudkZqiA+lVgzbUK2+10iWi6xzOFkR9544H8UbbzunETYM/Ll5h8Ty1m95iiHLd
	sghNZJsz0WZ/db7T+Dr5CyGVit0xTVTGdt2LSCwD3zRhYJLYEdl0bqCO/uJjPvnT7VJAtYFfY/m
	3SVWUHecles7q2rETwHX5zodDodg9IuMa3urIdHMjrdHnhyN0fjgB74ljcr2QAj/olDEzbPiFdb
	Rl7yR85yNCf4bSZqkemiIVjgIawyPcZfWufdzVJJLwyDMD3ed15OxZy583MuArl3DINtm5iouXu
	rvfY/n5ngekCjR949T9K3La2otzAwmaz2Opqtkxz6w6IZVfd/L9FgIXR2u8Z0dCWknjF88ZAzwj
	qlOQIbQ07WxifkQ5j1XhootU4F+NxQSiPEUP7BlDfMeBByOy7Qi7CyICHEwSRlihUZFZmw/qX1w
	FWJ5qoAySZFWj94jKyGvNyUtcW1iZM1slrUwyQsj7mHDXC0VsKidDah5tyJEkdA5uFcNsSYMlyK
	m
X-Received: by 2002:a05:6122:3117:b0:5ea:e196:272b with SMTP id 71dfb90a1353d-5ec23326b7amr1522204e0c.19.1792950031820;
        Sun, 25 Oct 2026 10:40:31 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec234673ebsm5783333e0c.13.2026.10.25.10.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 10:40:31 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	kuba@kernel.org,
	enelsonmoore@gmail.com,
	bp@alien8.de,
	shuah@kernel.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vbabka@kernel.org,
	dapeng1.mi@linux.intel.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	surenb@google.com,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	elver@google.com,
	graf@amazon.com,
	lirongqing@baidu.com,
	liam@infradead.org,
	jlayton@kernel.org
Subject: [PATCH v2 9/9] selftests: kho: add read-only KHO test to vmtest.sh
Date: Sun, 25 Oct 2026 13:40:16 -0400
Message-ID: <20261025174017.3870481-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
In-Reply-To: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
References: <20261025174017.3870481-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E3AAE20005
X-Stat-Signature: co3mnnsi8x9sysry448jqprk3nof13dp
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,LOTS_OF_MONEY,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792950032-428839
X-HE-Meta: U2FsdGVkX18mtx2bgIl3sVsg0BRY5/gScs7KtcN1AT3knKLcV7JEjYn4VdvqVU4CvggxYHgxyErZWwyB/yyYT7twISujgCaojTQBpcUDRGOZJOV8evBIVABEXJJ35y8+e9IYlkwpPNyYeui+xKOSUVVsjkBhbgIOHXuAogO80nQrop2V4IPdqZNklp9E6p3lOO/pWR6eaIoLcT0VaV4lG2wkFF7B2/u/p1PqPgpj3Yz1Hlx1BBVV6agDfZeS16uG5SLSPHlc561B3Na3f0rT+ekm8C/gIigOiha3xDbB1E/hPPhfF/EjGbZaa9tAgI+1bQ/caQONHOfkxGyBkzTnSI6EOxULcKz+M7T4yvPcqhgyFQ1lcXXY54hDLTAhls0w30VoepHJxNsLMHPAugUS4tyBhwnBQ20wmHi3Lzwu4t0LXC7ro2d1BkchUMr0PUAaWwC8HLYstC+e88fUE9d13jDU2lM1G0t1T1HyQw4Eq6Gujnpacv02KbcviJGsCReinjAtDXVeUBmH15Mb7L75GEtLbGupN9TNkS5ouYmIHxfHOgLxvfudzjcWe2KlJsiatyauErSZf+SEvzmWaZ6TSvS8ShBJNIWJggcy04kEMm2hr5dkx2mUKDJZYmSmvXpmi2HzoDwdkT7yj1p0SP0ZWv4MOGCW9qmGs7SCRtALYGYxoMHXIp2CCcBG9rNxqY01sBQaVMSIdmLaqb0AsnlWxLQXQB0I467l4Hg7XsCG2FPsudukvOWU6V2wlfJeY6Cj6+ADUWJpXVZtEAsZHThX9aVhWhYdvJSBRZ77ayJ56L4TSDNRwpcgcrzE1suAsmb1etLVfmXSzt/gxdsNqtbDH7xI/eVkZ1nP7O+XFZyMSYktcuzg0wurpPoNc56oxVSYTkSTPi9Hqh/y4U5dJiLswyfc+cQjLm43LEMQDBjIIhXLI7N8eYn0tNO4BV4RRaoo8NoHDCs0xEa6xSBalwm
 1Ka9+F9r
 dZhz1QZEikjz89yLPWfhFOrQ3WApp2s2pmW8NRQGIRz91s5cXlnXBza4sbAGFLaAcnK/+QVG7Gbye27Ya1qHFi8AMqpWtOGHoD4NkSaa/oQaiLA2f6loZlqJFmJDHNvJMz92w5fRrB0kPd/f0FdNw71msQadr6Wmii7V+vHT8rc0soogZFFXzwQH+cpXdjDmS/MmYNfE4ha4VX8roh1KLJ8xDZV+ktQOxfAS03l/Sjtf7pL7T+O5ucs8ziffLxccbr/2RlKrzmpLUyuxATPl4gbtqnnUndiD9eusFVHznW87Kg3CNaepu5q4bGUSJcZv+h4gdxY+0+THDcRo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmtest.sh currently only tests standard KHO restoration and does not
exercise read-only KHO mode ('kho_ro=<fdt_phys>') in QEMU.

Extend tools/testing/selftests/kho/vmtest.sh and init.c to enable both
CONFIG_KEXEC_HANDOVER=y and CONFIG_KEXEC_HANDOVER_READONLY=y in the
kernel configuration and run a second QEMU test verifying read-only KHO
after the standard KHO test on both x86_64 and aarch64:

- Enable CONFIG_KEXEC_HANDOVER_READONLY=y alongside
  CONFIG_KEXEC_HANDOVER=y in build_kernel().
- Pass KHO_RO_CMDLINE ('nokaslr kho_bootmem=64M,64M,64M' on x86_64) to
  the first kernel in the read-only test run and configure 4G of RAM on
  aarch64 so GFP_KERNEL KHO allocations are placed in ZONE_NORMAL above
  4G, outside the read-only kernel's System RAM.
- When booted with 'kho_ro_test', read /debugfs/kho/out/fdt_phys in
  init.c and kexec into the target kernel with 'kho_ro=<fdt_phys>' and
  architecture-specific memory parameters
  ('memmap=792M$16M memmap=24M$1000M' on x86_64, 'mem=128M' on aarch64)
  so the preserved pages are excluded from the boot memory map and
  mapped via kho_ro_map_folio().
- Verify 'KHO restore succeeded' from test_kho in read-only mode.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 tools/testing/selftests/kho/arm64.conf |  1 +
 tools/testing/selftests/kho/init.c     | 38 ++++++++++++++-
 tools/testing/selftests/kho/vmtest.sh  | 65 ++++++++++++++++----------
 tools/testing/selftests/kho/x86.conf   |  1 +
 4 files changed, 79 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/kho/arm64.conf b/tools/testing/selftests/kho/arm64.conf
index ee696807cd35..202f92121695 100644
--- a/tools/testing/selftests/kho/arm64.conf
+++ b/tools/testing/selftests/kho/arm64.conf
@@ -1,4 +1,5 @@
 QEMU_CMD="qemu-system-aarch64 -M virt -cpu max"
+QEMU_MEM="4G"
 QEMU_KCONFIG="
 CONFIG_SERIAL_AMBA_PL010=y
 CONFIG_SERIAL_AMBA_PL010_CONSOLE=y
diff --git a/tools/testing/selftests/kho/init.c b/tools/testing/selftests/kho/init.c
index 88a41b6eba95..e2ebcf7ab307 100644
--- a/tools/testing/selftests/kho/init.c
+++ b/tools/testing/selftests/kho/init.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <stdio.h>
+#include <string.h>
 #include <unistd.h>
 #include <fcntl.h>
 #include <sys/syscall.h>
@@ -12,6 +13,15 @@
 #define COMMAND_LINE_SIZE	2048
 
 #define KERNEL_IMAGE "/kernel"
+#define FDT_PHYS_PATH "/debugfs/kho/out/fdt_phys"
+
+#if defined(__x86_64__)
+#define KHO_RO_MEM_PARAM "memmap=792M$16M memmap=24M$1000M"
+#elif defined(__aarch64__)
+#define KHO_RO_MEM_PARAM "mem=128M"
+#else
+#define KHO_RO_MEM_PARAM ""
+#endif
 
 static int mount_filesystems(void)
 {
@@ -32,7 +42,8 @@ static long kexec_file_load(int kernel_fd, int initrd_fd,
 static int kexec_load(void)
 {
 	char cmdline[COMMAND_LINE_SIZE];
-	ssize_t len;
+	ssize_t len, fdt_len;
+	char fdt_phys[64];
 	int fd, err;
 
 	fd = open("/proc/cmdline", O_RDONLY);
@@ -41,11 +52,34 @@ static int kexec_load(void)
 
 	len = read(fd, cmdline, sizeof(cmdline));
 	close(fd);
-	if (len < 0)
+	if (len <= 0)
 		return -1;
 
 	/* replace \n with \0 */
 	cmdline[len - 1] = 0;
+
+	if (strstr(cmdline, "kho_ro_test")) {
+		fd = open(FDT_PHYS_PATH, O_RDONLY);
+		if (fd < 0)
+			return -1;
+
+		fdt_len = read(fd, fdt_phys, sizeof(fdt_phys) - 1);
+		close(fd);
+		if (fdt_len <= 0)
+			return -1;
+
+		if (fdt_phys[fdt_len - 1] == '\n')
+			fdt_len--;
+		fdt_phys[fdt_len] = 0;
+
+		len = (len - 1) + snprintf(cmdline + len - 1,
+					   sizeof(cmdline) - (len - 1),
+					   " kho_ro=%s " KHO_RO_MEM_PARAM,
+					   fdt_phys) + 1;
+		if (len <= 0 || (size_t)len > sizeof(cmdline))
+			return -1;
+	}
+
 	fd = open(KERNEL_IMAGE, O_RDONLY);
 	if (fd < 0)
 		return -1;
diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
index 0014bd76e88d..ca59a58ae2fb 100755
--- a/tools/testing/selftests/kho/vmtest.sh
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -35,17 +35,12 @@ trap cleanup EXIT
 function skip() {
 	local msg=${1:-""}
 
-	ktap_test_skip "$msg"
+	while [[ "$KTAP_TESTNO" -le "$KSFT_NUM_TESTS" ]]; do
+		ktap_test_skip "$msg"
+	done
 	exit "$KSFT_SKIP"
 }
 
-function fail() {
-	local msg=${1:-""}
-
-	ktap_test_fail "$msg"
-	exit "$KSFT_FAIL"
-}
-
 function build_kernel() {
 	local build_dir=$1
 	local make_cmd=$2
@@ -55,10 +50,11 @@ function build_kernel() {
 	local kho_config="$tmp_dir/kho.config"
 	local kconfig="$build_dir/.config"
 
-	# enable initrd, KHO and KHO test in kernel configuration
-	tee "$kconfig" > "$kho_config" <<EOF
+	# enable initrd, KHO, read-only KHO, and KHO test in kernel configuration
+	cat > "$kho_config" <<EOF
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_KEXEC_HANDOVER=y
+CONFIG_KEXEC_HANDOVER_READONLY=y
 CONFIG_KEXEC_HANDOVER_DEBUG=y
 CONFIG_KEXEC_HANDOVER_DEBUGFS=y
 CONFIG_TEST_KEXEC_HANDOVER=y
@@ -71,11 +67,25 @@ $arch_kconfig
 EOF
 
 	make_cmd="$make_cmd -C $kernel_dir O=$build_dir"
-	$make_cmd olddefconfig
+	local need_config=0
+	if [[ ! -f "$kconfig" ]]; then
+		need_config=1
+	else
+		while read -r opt ; do
+			[[ -z "$opt" ]] && continue
+			grep -q "^$opt$" "$kconfig" || need_config=1
+		done < "$kho_config"
+	fi
+
+	if [[ "$need_config" -eq 1 ]]; then
+		cp "$kho_config" "$kconfig"
+		$make_cmd olddefconfig
+	fi
 
-	# verify that kernel confiration has all necessary options
+	# verify that kernel configuration has all necessary options
 	while read -r opt ; do
-		grep "$opt" "$kconfig" &>/dev/null || skip "$opt is missing"
+		[[ -z "$opt" ]] && continue
+		grep -q "^$opt$" "$kconfig" || skip "$opt is missing"
 	done < "$kho_config"
 
 	$make_cmd "$kimage"
@@ -107,18 +117,23 @@ function run_qemu() {
 	local qemu_cmd=$1
 	local cmdline=$2
 	local kernel=$3
+	local test_name=$4
 	local serial="$tmp_dir/qemu.serial"
 
 	cmdline="$cmdline kho=on panic=-1"
 
-	$qemu_cmd -m 1G -smp 2 -no-reboot -nographic -nodefaults \
-		  -accel kvm -accel hvf -accel tcg  \
-		  -serial file:"$serial" \
-		  -append "$cmdline" \
-		  -kernel "$kernel" \
-		  -initrd "$initrd"
-
-	grep "KHO restore succeeded" "$serial" &> /dev/null || fail "KHO failed"
+	rm -f "$serial"
+	if $qemu_cmd -m "${QEMU_MEM:-1G}" -smp 2 -no-reboot -nographic -nodefaults \
+		     -accel kvm -accel hvf -accel tcg  \
+		     -serial file:"$serial" \
+		     -append "$cmdline" \
+		     -kernel "$kernel" \
+		     -initrd "$initrd" && \
+	   grep "KHO restore succeeded" "$serial" &> /dev/null; then
+		ktap_test_pass "$test_name succeeded"
+	else
+		ktap_test_fail "$test_name failed"
+	fi
 }
 
 function target_to_arch() {
@@ -164,7 +179,7 @@ function main() {
 	done
 
 	ktap_print_header
-	ktap_set_plan 1
+	ktap_set_plan 2
 
 	if [[ "$target" != "$(uname -m)" ]] && [[ -z "$CROSS_COMPILE" ]]; then
 		skip "Cross-platform testing needs to specify CROSS_COMPILE"
@@ -182,9 +197,11 @@ function main() {
 	local kernel="$build_dir/arch/$arch/boot/$KERNEL_IMAGE"
 	mkinitrd "$kernel"
 
-	run_qemu "$QEMU_CMD" "$KERNEL_CMDLINE" "$kernel"
+	trap - ERR
 
-	ktap_test_pass "KHO succeeded"
+	run_qemu "$QEMU_CMD" "$KERNEL_CMDLINE" "$kernel" "KHO"
+	run_qemu "$QEMU_CMD" "$KERNEL_CMDLINE ${KHO_RO_CMDLINE:-} kho_ro_test" \
+		 "$kernel" "KHO read-only"
 }
 
 main "$@"
diff --git a/tools/testing/selftests/kho/x86.conf b/tools/testing/selftests/kho/x86.conf
index b419e610ca22..2c097c5bd6c6 100644
--- a/tools/testing/selftests/kho/x86.conf
+++ b/tools/testing/selftests/kho/x86.conf
@@ -5,3 +5,4 @@ CONFIG_SERIAL_8250_CONSOLE=y
 "
 KERNEL_IMAGE="bzImage"
 KERNEL_CMDLINE="console=ttyS0"
+KHO_RO_CMDLINE="nokaslr kho_bootmem=64M,64M,64M"
-- 
2.56.0.307.g5fe7bd680c-goog


