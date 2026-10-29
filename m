Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91E18606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 17:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=W9LFoFBs
Received: by kanga.kvack.org (Postfix)
	id 932326B0625; Thu, 29 Oct 2026 13:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E22A6B0626; Thu, 29 Oct 2026 13:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D2E86B0627; Thu, 29 Oct 2026 13:31:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 43D0F6B0625
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:31:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1075A04BD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:31:07 +0000 (UTC)
X-FDA: 85376354574.03.2ABA091
Received: from mta1.migadu.com (out-19.mta1.migadu.com [95.215.58.19])
	by imf15.hostedemail.com (Postfix) with ESMTP id D8BB1A000D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:31:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W9LFoFBs;
	spf=pass (imf15.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.19 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793295066;
	b=yMOQ/P4L1hOLC7wHFc3HsUcs9R/0yBdqh+JXCyQR6SaYW4Kaxbs2jUlubh6sbF3ikKS6r5
	YH9gNuI71c7aUdLvgJKlgY6MV2h9LfaHlTdfludws4jIybpTckfDryLIvve5Y05tuwfRoM
	BahLp/kw6aCpQx/mHTjd9i6/ajDF3ng=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W9LFoFBs;
	spf=pass (imf15.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.19 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793295066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hjl3YWLB9mIMK4NxN5xFoTsa4zvmwEeXlgSjnO0OUbA=;
	b=3PRiO1Yn7r3Zbq6k3LI7W8B3qC9gvB0s8J8O7yMVG58WNseFDE7zeiJzJwdvKd/ovlaM4n
	DGf+ghia2WejSWyFPRxO0/2Lqf65weSeSJUMQCJwS7Wn9B/aFEvM0VA2TRxDZySHuB8l4I
	KPx7heDpa2RHxsFFp0uyTrkqco4LBm8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GBih4azSAalhMpwQa4vAt/wr7df5ETSpm+lkTN2YYcw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793295064; v=1; x=1793899864;
 b=W9LFoFBszpWry1/NSZbVhjNsFbcVuSrt/CoO/JfaLe7WiVW7vFpNJY7uGjKf+aJPQSKJXkIV
 06V+5qqpODl9AsLap7BQ8oVrkrYL+GpTR9hNsSgs8TMSSct9wgIdgHD1c/40EKKFuVfRSevj1BA
 V7H11bHuwTRyacCfRGC8mjeE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d28391d344248cfb;
	Thu, 29 Oct 2026 17:31:04 +0000
X-Mizu-Trace-ID: d28391d344248cfb
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	chenhuacai@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org
Cc: ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH v6 8/8] selftests/liveupdate: Add LoongArch vmtest support
Date: Fri, 30 Oct 2026 02:29:55 +0900
Message-ID: <20261029172956.20791-9-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029172956.20791-1-dongtai.guo@linux.dev>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ymoiyzbuydxa7qetxkjnnxz4u8q4miyh
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D8BB1A000D
X-Rspam-User: 
X-HE-Tag: 1793295065-44146
X-HE-Meta: U2FsdGVkX1867m1cIIyWwiioOUYUOuU7JBznaO9AtsCro6OSZRXmFCAxSUqOhoz806ggVvIVk7T3ygkZ7IRCc7HnuHIwWkEtmbAr36Vo7qgHjcgJDcPpiUp+ESZSPgh31uBhNi4tgxHa8hAAmNtJij/tbb1PP8rZUX1dBeIU7LUA01CyrXoinC8W9ZjaQOjShSGyJ1I5wi4P5OAMXwRm1znRWa6qD0SOywZgFHZ+Z7UKvg/0j1xmOAfO+F8LNJ1IxnXOw71cIu0s/6I2lc83Qe7VUoS2XkLHvuRX1nt5zVpE38rorRwjtjqimbVfbBzszbqE8GH2OhP+fVoSvnmc3nv7pn7Fzxfu+sO1mBWzyFWjC2pZ+qyDa/3Bv7kLHIQVPCBE5XiMDfNFE3InL0LypIA+alX1QGmUC4m/OiJt+MQerxs2Kjhqi/A/GY7MxMFH5E1U9uu3bS9UsERnAkcdWISQO3D1K2zgx0UERp2KsSl3rEO10CpFVZ4fRX6KGd4kwOusMbayd33zRAFth8AAbNuiS2H2HSVUth84Eq2bOumhybMnedQj3PwwLCVDHZWj2A9Dfm8Di2p5P+8XWjJ1nAf4IfcRXVjpygQf4lFwPMOIcZJ7+D23x5X2FzovNUXD+Jtnkcz9DP58lSog2nOm6ECVImBqmGrVb+Ygj9QMfqT0gtDxX4OJLmAyjsDSrRnaukQe2Z8Fq13plz1iQJ7B/Orb+/vWZGMBPm4qQncpXZv6gjT0CkkV9Xw2rUeWCHIjfxEr/2HFzrN9ILvVFzk8q/ox1b4IjOEr6O5+GJpJUcR98zy49Oaeq7Umd822NjFbeWBdy3OveNgwNgn7vahugiKbMye3Ara/Xb+ZBp7IG7Ma+9D0g6H2Bz6mebpY8+piIClhdt/593JueJ/ey29QbZq6l6AutpWqOzxT+0oQcic5PA6e00B7cwW1ayYXbYZq9WYyiXKv5kCoqZFwtwZ
 FlbJdZk2
 7qW3nMGU5uqsV0uTBJ4VRLaOOioGw5wjrdYU9qz7itkg+KrahMV2u3dpbGZ/746sCuhVIXEEDm0cl8agQwAP/uAUZUeZhPLrCeoVIANBLjISTMjDqwm21gHsjyYqq8y9kQmMbZO39HQkTApvO0Vp9yb4/hmS9B0K+0E5c1IFKjXwgOWblt1bcS82Tgvt4qomUAb80TZaA+cqiY5dWa4saA3kUZUynMri4ITJ5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: George Guo <guodongtai@kylinos.cn>

Add the LoongArch kernel configuration, target and cross-compiler
detection, and include loongarch64 in the VM test suite.

Boot vmlinux.efi through EFI firmware so the EFI stub installs the KHO
table. Allow the firmware path to be set with QEMU_EFI and skip the test
if it is unavailable.

Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 .../selftests/liveupdate/config.loongarch64        |  5 +++++
 tools/testing/selftests/liveupdate/run-vmtests.sh  |  4 ++--
 tools/testing/selftests/liveupdate/vmtest.sh       | 14 +++++++++++++-
 3 files changed, 20 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/liveupdate/config.loongarch64

diff --git a/tools/testing/selftests/liveupdate/config.loongarch64 b/tools/testing/selftests/liveupdate/config.loongarch64
new file mode 100644
index 000000000000..264067ef5ab1
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/config.loongarch64
@@ -0,0 +1,5 @@
+CONFIG_ACPI_SPCR_TABLE=y
+CONFIG_PCI_HOST_GENERIC=y
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SMP=y
diff --git a/tools/testing/selftests/liveupdate/run-vmtests.sh b/tools/testing/selftests/liveupdate/run-vmtests.sh
index d656ce58c5a7..f6cfb76b1dac 100755
--- a/tools/testing/selftests/liveupdate/run-vmtests.sh
+++ b/tools/testing/selftests/liveupdate/run-vmtests.sh
@@ -4,7 +4,7 @@
 SCRIPT_DIR=$(dirname "$(realpath "$0")")
 TEST_RUNNER="$SCRIPT_DIR/vmtest.sh"
 
-TARGETS=("x86_64" "aarch64")
+TARGETS=("x86_64" "aarch64" "loongarch64")
 
 GREEN='\033[0;32m'
 RED='\033[0;31m'
@@ -72,7 +72,7 @@ function main() {
 		for test_name in "${TEST_NAMES[@]}"; do
 			log="$output_dir/${arch}_${test_name}.log"
 
-			printf "  -> %-8s %-24s ... " "$arch" "$test_name"
+			printf "  -> %-11s %-24s ... " "$arch" "$test_name"
 
 			"$TEST_RUNNER" -t "$arch" -T "$test_name" &> "$log"
 			exit_code=$?
diff --git a/tools/testing/selftests/liveupdate/vmtest.sh b/tools/testing/selftests/liveupdate/vmtest.sh
index 69beda6c961d..ffe82512f3e4 100755
--- a/tools/testing/selftests/liveupdate/vmtest.sh
+++ b/tools/testing/selftests/liveupdate/vmtest.sh
@@ -21,6 +21,12 @@ function get_arch_conf() {
 		QEMU_CMD="qemu-system-aarch64 -M virt -cpu max"
 		KERNEL_IMAGE="Image"
 		KERNEL_CMDLINE="console=ttyAMA0"
+	elif [[ "$arch" == "loongarch" ]]; then
+		local qemu_efi="${QEMU_EFI:-/usr/share/edk2/loongarch64/QEMU_EFI.fd}"
+		[ -r "$qemu_efi" ] || skip "EFI firmware '$qemu_efi' not found, set QEMU_EFI"
+		QEMU_CMD="qemu-system-loongarch64 -M virt -cpu la464 -bios $qemu_efi"
+		KERNEL_IMAGE="vmlinux.efi"
+		KERNEL_CMDLINE="console=ttyS0 earlycon"
 	elif [[ "$arch" == "x86" ]]; then
 		QEMU_CMD="qemu-system-x86_64"
 		KERNEL_IMAGE="bzImage"
@@ -37,11 +43,15 @@ $0 [-d build_dir] [-j jobs] [-t target_arch] [-T test_name] [-w workspace_dir] [
 Options:
 	-d)	path to the kernel build directory (default: .luo_test_build.<arch>)
 	-j)	number of jobs for compilation
-	-t)	run test for target_arch (aarch64, x86_64)
+	-t)	run test for target_arch (aarch64, loongarch64, x86_64)
 	-T)	test name to run (default: luo_kexec_simple)
 	-w)	custom workspace directory (default: creates temp dir)
 	-k)	keep workspace directory after successful test
 	-h)	display this help
+
+Environment:
+	QEMU_EFI	LoongArch EFI firmware path
+			(default: /usr/share/edk2/loongarch64/QEMU_EFI.fd)
 EOF
 }
 
@@ -86,6 +96,7 @@ function detect_cross_compile() {
 	local candidate=""
 	case "$target" in
 		aarch64) candidate="aarch64-linux-gnu-" ;;
+		loongarch64) candidate="loongarch64-linux-gnu-" ;;
 		x86_64)  candidate="x86_64-linux-gnu-" ;;
 		*)       skip "Auto-detection for target '$target' not supported. Please set CROSS_COMPILE manually." ;;
 	esac
@@ -193,6 +204,7 @@ function target_to_arch() {
 	local target=$1
 	case $target in
 	     aarch64) echo "arm64" ;;
+	     loongarch64) echo "loongarch" ;;
 	     x86_64) echo "x86" ;;
 	     *) skip "architecture $target is not supported"
 	esac
-- 
2.53.0


