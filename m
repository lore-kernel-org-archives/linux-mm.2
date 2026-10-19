Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0B3BCCF2D4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 02:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99C2E6B00AB; Sun, 18 Oct 2026 22:11:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 974B96B00AC; Sun, 18 Oct 2026 22:11:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814836B00AE; Sun, 18 Oct 2026 22:11:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 593606B00AB
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:11:32 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 006CA405CD
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:11:32 +0000 (UTC)
X-FDA: 85337749182.29.A8F6B9B
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4838180005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:11:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fJSLh9KP;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792375890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmeYwpV1WXgURkKRUEhvLrRNpkq1JL/wE/xlQQFWMQk=;
	b=Wzl5n6qD9HK3M+RTwniFIe4mNEbTe90EQT3vz+ZdPfncV6LoHHiOUI8NIhTGjdNsYEDMbB
	wmd2qxoC+ZQKc8v/5ELqVuAl9cWoYFIu+Fo+5+vkysB08OizaRWoVH+CA3QswYtuZNtL6y
	9Q2nPRMIeFvhLMrhwV17zH83COIXYpc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792375890;
	b=m+ZjzL0lA55S1BXMMSy6TgiqDJSr78wutez764dVDGX6fdoGyK9DlT9AKBzkBv+i6DwAiM
	2hIhriGAS2x8EDiBIuYrqaYWQ6NCUrCIJSbAH2sF39aMrxUUrpHBqBO6f9yQ8OmwXatzjk
	zSDC86JkO2MeMiEsbrAGyAJmNTbdALY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fJSLh9KP;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5e948e56b9dso636991e0c.1
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 19:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792375889; x=1792980689; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=UmeYwpV1WXgURkKRUEhvLrRNpkq1JL/wE/xlQQFWMQk=;
        b=fJSLh9KPDWHs1zzrjJKw3kqa0mWLdWr3UOOTPjfH1CwUGhkDHhcqDVFWWzccHBP+WM
         Dcd3vi90sLuJ4oknekNbT9pgWUtmvrWX/WvxdrDqOaQ8iJhi2RVE+gq0hgaqXQMAXwyM
         xbuVDRScB3xpwdZgmVCBe0t1m/QniAbPlb0FI7Fav3rJVnwTZqXEUw3Amagp7hODrR9l
         5YtEaC8xlt7EfUjWEkTasw6eBYc045xdr1mw/ON4pXO8U/ckPijLRLzeWBhGYp5fEMYz
         4X47qiY7YQhsp4+6OgtLQH9IVFofImGNELEifI8lDSKS2yiR7dtw+9AmvEBaRBKxn+nx
         LipA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792375889; x=1792980689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=UmeYwpV1WXgURkKRUEhvLrRNpkq1JL/wE/xlQQFWMQk=;
        b=C5OtuAZIGDWIZMICnZeV8rLdAuntuub4vak/lFg2Vdq79/Q0jp1acCd0Opsri2wQYH
         w2cEEylBpcksFDoumguGW5kGAKblN92rYnZlm95hJy+J+KxK1VLqMY3nb7EMeTcd46NT
         2yu4+5U/1pa2mHR66Bg9pVnRMFaIIVPG+AfSouUdAia3SGCvoGqTpwZ50dnB3Pg8ZPjl
         Qq8WlOcvpI9IhRgKt8rpyYLDe1eL4Mo+pcZs4lrmYEDlS3Xd9kzpHCNWs3zbQ9mMKT36
         pTrzr7RuhEYiZmMfRr1O9ogdcA4CCU9bU44uGSrU4Eh49sAZ8KmkaWeKD76d/5XkWdmY
         EROg==
X-Forwarded-Encrypted: i=1; AKwUvBz73hqs317Kyw+4IwkPO72v0oqXDbQr+ky+7mGSzeL6ajCk9N46k2KCp305xEymE6aynqrGAS436A==@kvack.org
X-Gm-Message-State: AFq9FYLIr1ykoE1QtJoxdCCqzGElwUqn60IZDODpUibDznMd5OEWfQEC
	GIVeOmRY1JHdnbQzdrsAQFX4qCeP5miLUgiJOsLrK/KmIBtohAuQ2j1Bemyx2gi3wnA=
X-Gm-Gg: AYBFou3LzwLmAD9avBvDj2xF3ysL5d24Y+FfWJV0qb2RGKPwUhz4EsSWmLTD+pmqlTF
	FxmXj+GbikFu8nwI4aXnCI8BFzAfqvpScWkxt5dlxgjrm2B/aq1lh21e4TRXwKPme2ged0MFcSq
	HW0y0H+mFewpTtlGjwLMFVloennCQzwgNvAROABTU/NHJL85kID7GCUxV8h/x31fkCY9y73BNuf
	DGnGIlGDFsQESwEocT59OH/+F7yN02Y35+7i/Oy+WpOAhHLjcFQzys4gmymqh2BOoDpMgZP68ib
	yahmDPQ+vl7OtENqjYydZIbj2f17+4wVQUzxSpu28SyLUJ9rNsmlRIDnjqhXwwPyXe8Mh0hUZL8
	3PGmoRIR0OXddkodQcuxnn0vjc9a8dMjOZaLhbpFQWWxoxT4KlhqPGbhl/z9cSov+988NyxXw3f
	onJ0EsESH8SQveA+fhD1NLgSUwnepdTx5I9Yk89vb0kAqiRFplQzZLz8jHRxZoBiRgyjbAyYNx5
	idFHB8pvWwFdg8yw3NSgLHhyPGxSbgTxTnInfyEO9Rq3WwGce4NcuKXcQJRb9V9c7lyPrqSo4uE
	ltDUYRpxZysj1omikBXJeJsF1HtiSg==
X-Received: by 2002:a05:6122:8616:b0:5c9:a60b:e5c8 with SMTP id 71dfb90a1353d-5eaaa414a8bmr2432423e0c.11.1792375889472;
        Sun, 18 Oct 2026 19:11:29 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eabbd9ea2bsm4271383e0c.2.2026.10.18.19.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 19:11:29 -0700 (PDT)
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
Subject: [PATCH v1 8/8] selftests: kho: add read-only KHO test to vmtest.sh
Date: Sun, 18 Oct 2026 22:11:11 -0400
Message-ID: <20261019021111.990394-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019021111.990394-1-pasha.tatashin@soleen.com>
References: <20261019021111.990394-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4838180005
X-Stat-Signature: adhwrofbw8sp5n67e9boi3zd6qp5mtt3
X-Rspamd-Server: rspam05
X-HE-Tag: 1792375890-917003
X-HE-Meta: U2FsdGVkX1821BD0eCMnIaYy9AiKhKL2ajRLYGeya0QUwXQ2xVEKyPDuW5qVWjg4n+h1BaRNR4qLKwqh9L5fqyNlMGWloy4z1sA/3G1G6wopxNxrnNoYbO0ErDfyHBwylng2yQOjQEyOWPlejD6BHSYWMz2enpogSrg+DIK/2OugmA5zG0hJTQUUeRmaLbxehNUqske3ZlryTM1p7PKEj37J8roY2bZFVUuIUCGZXZwvsDkmIa78Zpv2KlIraEK5KaHgpIGdjfa65V6953Ye/sHR5AriXFu0V1QXEGMr2pmcgCErwbUmyVzb9rEc9nlX2oF5tMvn9TKBgeckwcabu5/xsdh7n1O97qAb6v/B/pMafwWNtFevada+nycAdZWtrstYS98HNLfMQmOoVPltJPRJEYsfkobJhGUwpM95IwSCdEEuN/RX+RVPOfJysQGSG8qNzrmx6gO6jtDtSB17mc1+M5eGS8BV3db7v/WUKUP1qEHR8XAI8Lp3KjbUCvajoYD+k6g5kfua/VikMh+OASGqiI09GHQq/J2GHTuSduaoA996ky0trOZbqsQ5nuxg+2njAly2pWe/qP7DKkQon0nuQcK3JBpTZ8deqx/66eU6hA4m7TSQ7FksDu1UPOsV3MpNXwxp4vh2vt1/Cwn7sgudgxZkaDRh92vIanpnPV6ETPAga3uzBU9QX8WEOcOJRJVKuEFFQPHLWEk4tZQho976le45u1qnRC/Iu/UG2kpp9q9W2PWJZtu0qGqi9fQjaykEbst/yh4PT8y0171//DV6Q8q0YXKx0RyT5bhnQyjHwL9XFEh86761i5DIZ1IADWKCfV9QFDD0Q+mxuLKQBg2YwChu1FSYD5NqLBdbHp9tK0c9crK05KacEDwhvRDz/XZhZKxervEO5qR651dSoK+HKh6B1PESOV3PmvSR1qfrDNZTEdo6ZMnT/fi5xmxrZMbF2efG3gaIqRBg45Z
 K5XGP2Po
 gkB7MAW6X16y+fv5eZdWCyy49z6ccx48guExRhJ/C//wHiNIA4/gb2Lvv+6BKeVj8GThWKwnKg2UDBABY7t0u6X12FNU+agcvSO+ppbXUgCaWL24OFU6t1RCaJUHKOU+XQ89numLk/gW3Xm/HPiCI1Js+cwRK6TGKA6FMP3lZ/K0GqwDWyBaHkF3VWzjPqehAsIq0kVQMTyWfll74atKrBB5kdjnU8XAEruaZluyxi8xEauv4PtXnur4k8UmTL3ytEh8e9rxlyom9lmzLbVTPWBXs4BtLDu8HH5tldb8iwvGfjg7aY7O6oJS2CI59QM2VDqJh57DT0qSHLNw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend tools/testing/selftests/kho/vmtest.sh and init.c to run a second
QEMU test verifying read-only KHO ('kho_ro=<fdt_phys>') after the
standard KHO test on both x86_64 and aarch64:

- Build a second kernel configured with CONFIG_KEXEC_HANDOVER_READONLY=y
  (and CONFIG_KEXEC_HANDOVER=n).
- Pass KHO_RO_CMDLINE ('nokaslr kho_bootmem=64M,64M,64M' on x86_64,
  'cma=116M@0x40c00000' on aarch64) to the first kernel in the read-only
  test run so KHO allocations are placed in predictable physical ranges.
- When booted with 'kho_ro_test', read /debugfs/kho/out/fdt_phys in
  init.c and kexec into the read-only kernel with 'kho_ro=<fdt_phys>'
  and architecture-specific memory parameters
  ('memmap=792M$16M memmap=24M$1000M' on x86_64,
  'mem=128M cma=12M@0x40000000' on aarch64) so the preserved pages are
  excluded from the boot memory map and mapped via kho_ro_map_folio().
- Verify 'KHO restore succeeded' from test_kho in read-only mode.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 tools/testing/selftests/kho/arm64.conf |   3 +
 tools/testing/selftests/kho/init.c     |  38 ++++++++-
 tools/testing/selftests/kho/vmtest.sh  | 103 +++++++++++++++++--------
 tools/testing/selftests/kho/x86.conf   |   1 +
 4 files changed, 112 insertions(+), 33 deletions(-)

diff --git a/tools/testing/selftests/kho/arm64.conf b/tools/testing/selftests/kho/arm64.conf
index ee696807cd35..36dd8c46060c 100644
--- a/tools/testing/selftests/kho/arm64.conf
+++ b/tools/testing/selftests/kho/arm64.conf
@@ -4,6 +4,9 @@ CONFIG_SERIAL_AMBA_PL010=y
 CONFIG_SERIAL_AMBA_PL010_CONSOLE=y
 CONFIG_SERIAL_AMBA_PL011=y
 CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
+CONFIG_CMA=y
+CONFIG_DMA_CMA=y
 "
 KERNEL_IMAGE="Image"
 KERNEL_CMDLINE="console=ttyAMA0"
+KHO_RO_CMDLINE="cma=116M@0x40c00000"
diff --git a/tools/testing/selftests/kho/init.c b/tools/testing/selftests/kho/init.c
index 88a41b6eba95..272338f186be 100644
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
+#define KHO_RO_MEM_PARAM "mem=128M cma=12M@0x40000000"
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
index 0014bd76e88d..b3659e4fd1c9 100755
--- a/tools/testing/selftests/kho/vmtest.sh
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -35,32 +35,25 @@ trap cleanup EXIT
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
 	local arch_kconfig=$3
 	local kimage=$4
+	local kho_mode=${5:-"rw"}
 
 	local kho_config="$tmp_dir/kho.config"
 	local kconfig="$build_dir/.config"
 
 	# enable initrd, KHO and KHO test in kernel configuration
-	tee "$kconfig" > "$kho_config" <<EOF
+	cat > "$kho_config" <<EOF
 CONFIG_BLK_DEV_INITRD=y
-CONFIG_KEXEC_HANDOVER=y
-CONFIG_KEXEC_HANDOVER_DEBUG=y
-CONFIG_KEXEC_HANDOVER_DEBUGFS=y
 CONFIG_TEST_KEXEC_HANDOVER=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_VM=y
@@ -70,20 +63,50 @@ CONFIG_DEFERRED_STRUCT_PAGE_INIT=y
 $arch_kconfig
 EOF
 
+	if [[ "$kho_mode" == "ro" ]]; then
+		cat >> "$kho_config" <<EOF
+# CONFIG_KEXEC_HANDOVER is not set
+CONFIG_KEXEC_HANDOVER_READONLY=y
+EOF
+	else
+		cat >> "$kho_config" <<EOF
+CONFIG_KEXEC_HANDOVER=y
+CONFIG_KEXEC_HANDOVER_DEBUG=y
+CONFIG_KEXEC_HANDOVER_DEBUGFS=y
+EOF
+	fi
+
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
 
 	# verify that kernel confiration has all necessary options
 	while read -r opt ; do
-		grep "$opt" "$kconfig" &>/dev/null || skip "$opt is missing"
+		[[ -z "$opt" ]] && continue
+		grep -q "^$opt$" "$kconfig" || skip "$opt is missing"
 	done < "$kho_config"
 
 	$make_cmd "$kimage"
-	$make_cmd headers_install INSTALL_HDR_PATH="$headers_dir"
+	if [[ "$kho_mode" != "ro" ]]; then
+		$make_cmd headers_install INSTALL_HDR_PATH="$headers_dir"
+	fi
 }
 
 function mkinitrd() {
 	local kernel=$1
+	local out_initrd=$2
 
 	"$CROSS_COMPILE"gcc -s -static -Os -nostdinc -nostdlib \
 			-fno-asynchronous-unwind-tables -fno-ident \
@@ -100,25 +123,31 @@ file /init $tmp_dir/init 0755 0 0
 file /kernel $kernel 0644 0 0
 EOF
 
-	"$build_dir/usr/gen_init_cpio" "$tmp_dir/cpio_list" > "$initrd"
+	"$build_dir/usr/gen_init_cpio" "$tmp_dir/cpio_list" > "$out_initrd"
 }
 
 function run_qemu() {
 	local qemu_cmd=$1
 	local cmdline=$2
 	local kernel=$3
+	local initrd_path=$4
+	local test_name=$5
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
+	if $qemu_cmd -m 1G -smp 2 -no-reboot -nographic -nodefaults \
+		     -accel kvm -accel hvf -accel tcg  \
+		     -serial file:"$serial" \
+		     -append "$cmdline" \
+		     -kernel "$kernel" \
+		     -initrd "$initrd_path" && \
+	   grep "KHO restore succeeded" "$serial" &> /dev/null; then
+		ktap_test_pass "$test_name succeeded"
+	else
+		ktap_test_fail "$test_name failed"
+	fi
 }
 
 function target_to_arch() {
@@ -164,7 +193,7 @@ function main() {
 	done
 
 	ktap_print_header
-	ktap_set_plan 1
+	ktap_set_plan 2
 
 	if [[ "$target" != "$(uname -m)" ]] && [[ -z "$CROSS_COMPILE" ]]; then
 		skip "Cross-platform testing needs to specify CROSS_COMPILE"
@@ -174,17 +203,29 @@ function main() {
 	local arch=$(target_to_arch "$target")
 	source "$test_dir/$arch.conf"
 
-	# build the kernel and create initrd
+	# build the kernels and create initrds
 	# initrd includes the kernel image that will be kexec'ed
 	local make_cmd="make ARCH=$arch CROSS_COMPILE=$CROSS_COMPILE -j$jobs"
-	build_kernel "$build_dir" "$make_cmd" "$QEMU_KCONFIG" "$KERNEL_IMAGE"
+	build_kernel "$build_dir" "$make_cmd" "$QEMU_KCONFIG" "$KERNEL_IMAGE" "rw"
 
-	local kernel="$build_dir/arch/$arch/boot/$KERNEL_IMAGE"
-	mkinitrd "$kernel"
+	local kernel="$tmp_dir/$KERNEL_IMAGE"
+	cp "$build_dir/arch/$arch/boot/$KERNEL_IMAGE" "$kernel"
+	mkinitrd "$kernel" "$initrd"
+
+	local build_dir_ro="${build_dir}-ro"
+	if [[ ! -d "$build_dir_ro" ]]; then
+		cp -a "$build_dir" "$build_dir_ro"
+	fi
+	build_kernel "$build_dir_ro" "$make_cmd" "$QEMU_KCONFIG" "$KERNEL_IMAGE" "ro"
+	local kernel_ro="$build_dir_ro/arch/$arch/boot/$KERNEL_IMAGE"
+	local initrd_ro="$tmp_dir/initrd-ro.cpio"
+	mkinitrd "$kernel_ro" "$initrd_ro"
 
-	run_qemu "$QEMU_CMD" "$KERNEL_CMDLINE" "$kernel"
+	trap - ERR
 
-	ktap_test_pass "KHO succeeded"
+	run_qemu "$QEMU_CMD" "$KERNEL_CMDLINE" "$kernel" "$initrd" "KHO"
+	run_qemu "$QEMU_CMD" "$KERNEL_CMDLINE $KHO_RO_CMDLINE kho_ro_test" \
+		 "$kernel" "$initrd_ro" "KHO read-only"
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
2.56.0.176.g3575e65682-goog


