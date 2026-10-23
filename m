Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B3D2606A321
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 11:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=sfIz+CvI
Received: by kanga.kvack.org (Postfix)
	id AC4616B0B40; Fri, 23 Oct 2026 07:16:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D206B0B42; Fri, 23 Oct 2026 07:16:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93C666B0B44; Fri, 23 Oct 2026 07:16:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 690796B0B42
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:16:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE6D01403C6
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:16:31 +0000 (UTC)
X-FDA: 85353637782.08.A422683
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7FA5B4000A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:16:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sfIz+CvI;
	spf=pass (imf12.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792754190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fYZBu3LeiIKSBKKb9aemA6XX/JPZ7pVsvOrhAujfcC8=;
	b=QuvCbFIpjneCVEQIsyNRf7onP5J/BHnyQawmnQ6aEyNw3URGusQkShc67nofctoyvkOI6V
	9QnTKW/kshOvcYMNanoDkg8TJz90b1yGN/dS31gsJU04ZEwCGFLU/aYhFSozBc/4nsoGKp
	ZWtN31kFgo0eB5RjJprvfxvLgZfk1bY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sfIz+CvI;
	spf=pass (imf12.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792754190;
	b=E0VX5Xz9xXnFxTEfVf6TdukzXs7X0mluah89Slic2HCckW2A3Fv7RMGvzePZuXB7omwncX
	1niARTphz02r3xKvLXwEuuAkntEmlG5l+fkYhWwwK6tG3WiLwcqez/sXtLqUtA5mx5RmqP
	5E53iv7IQdDPBCa0elY+Z8oq5cn6J9w=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792754184; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=fYZBu3LeiIKSBKKb9aemA6XX/JPZ7pVsvOrhAujfcC8=;
	b=sfIz+CvINKysQ0fn3PCOIoNtk8juVb1Y/RxWXT150XgYEcf8xe6N7D4iz0MP4i0rN/hzMbN8U7Xo6oA9n/UyxlegRma4zbDOSPr2dKL63EbOnhJswUZ0CrvCuwMcez0Yu7bj5LN5Yxx077p2MZSwXUH8wd/uTwAE7NxvdFB+ssg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XDM1n61_1792754183;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XDM1n61_1792754183 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Oct 2026 19:16:23 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	alex@ghiti.fr,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	graf@amazon.com,
	shuah@kernel.org
Cc: guoren@kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	kexec@lists.infradead.org
Subject: [PATCH 4/4] selftests: liveupdate: Add riscv support
Date: Fri, 23 Oct 2026 19:16:12 +0800
Message-ID: <20261023111612.2134-5-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261023111612.2134-1-cp0613@linux.alibaba.com>
References: <20261023111612.2134-1-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7FA5B4000A
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: oabunspzhgxdnyadzc46zkb1n4zup7hx
X-HE-Tag: 1792754188-710452
X-HE-Meta: U2FsdGVkX1+w5AQDF5AfUF97/ntaK+VlB5SwM7rroWWYdw4YFd2NZIqj2Qszn9Bte+/r8M9tlO4KmWikgTE8KkH8bn5WGvxurKxaeTRCTyhFGaPF7wyK4uL9qHMyTgJTh55J5ltZ1yOYyLjbArpaEIekLEjosNZrxK8pv6o9rIN0bTorsJ7pzO5VIXwrWbZvy8CDFpzGTm8iS740KVrPBe8YMTngnz0T5cDbRggA4oWmc8l4V1muPqK6ou+KjQigDMYn6f6McZ160epiR1iQmTEQmIqxG4vlTQpR4uv5x/ZlKUmo70+/CfsKlrbjIEBepK+NA7OdUghmIsco5DBFMdpo6/QTqgM23906yt68NPsWHVstUDFD3gIAa/ZD6gLWSBOCV43rQTk45zKOtAFl0U9XSZvwH6Hf7Os9wfCkBt4giwbzlkVjbExqgcTQwT0NEcM2/m2lnCnf0XTvKWnT4CNGNPV9T1IxtrG3uk+9dJQ3dxvpWE78gnOrLMPMMTcJr07m3D6sSfibzft11CuRiJT7ubFmvV4IaG8CzPOVJ+EmRZ95+iO85meWrDU61+LSUwQtnZ5/oxESzIN5V/pKAtc/k3yB/jEQAd1e3OpmaBuEcOYCzwQsaGIFHLPvXCJAuvjCZg6h3ZAtPQXckE4ebD9gSoj8nQz4MMFa2+OjylcLz6YreRU6mpm9bTvxetpLk0edDvxRfX/93iUEe8zhZSia5z7YapP5uGyTX8HJpTO/EK0Z7tCXNJ5ogyxlqin2SVK2qjoWdJJTnO84loOU5GW8QHItDPuyq6iFo1moPpAEkIUZJ1vgdDdrPBhZ0nrLj2j4o/Bm5e5S4914UFpGEO5C2pBOlpfzvn0dNU7Jg6H62ESgaQ40oo2h04P2CozkuBUZm3rJBYM//Kjh7l4RcJjokKvcLeOOSIF0JqtU/l6ymZNbM8HjFDvddCyE39MtdN/VhQINF0a4nkNKzMr
 47BYZwJ5
 awAiXIcuaAWm26uNSQazGGHP0O8AmGA2MGLWTf+wyQqw4CLwYBN7QFu0TStDa5hulrX7bEExDSZUU7AVhWmxvhWW/D2iq+hWcQM9E8T91PWTlMOIibCtteETUP+D/w0+bLbIun9897qWtMPiMw84p7FSxHGRLYIM8VG+kH7T8ZaGrsyhC4dy8cLwcMkeld4/XZCr8pq9x9cqcgX+ORCKAVRIXmOSspxU0NueH6hF8N9Z3VT0eTfMnzw1BPahpWeuZqCif
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Teach the live update vmtest runner about riscv64: map the target to ARCH
riscv, describe the QEMU virt machine, the kernel image and its console,
and add the arch config fragment holding the three symbols needed to get
a console on the virt machine's 16550A port.

KHO is the only dependency of LIVEUPDATE (kernel/liveupdate/Kconfig), so
now that riscv has KHO the LUO tests only need the runner to stop
rejecting the architecture.

Add riscv64 to the CROSS_COMPILE auto-detection list and to the target
list of the batch runner as well, matching the existing aarch64/x86_64
entries.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
---
Test: qemu-system-riscv64 (virt, -cpu max, -m 1G, -smp 2, TCG), in-tree
runner "tools/testing/selftests/liveupdate/vmtest.sh -t riscv64 -T <suite>",
all four suites:

  luo_kexec_simple:    SIMPLE KEXEC TEST PASSED
  luo_multi_session:   MULTI-SESSION KEXEC TEST PASSED
  luo_stress_files:    MANY-FILES KEXEC TEST PASSED (500 files)
  luo_stress_sessions: MANY-SESSIONS KEXEC TEST PASSED (2000 sessions)

The simple suite's serial log shows the full handover round trip:

  KHO: found kexec handover data.
  luo: Retrieved live update data, liveupdate number: 1
  # [STAGE 2] Test data verified successfully.
  --- SIMPLE KEXEC TEST PASSED ---

 tools/testing/selftests/liveupdate/config.riscv64 | 3 +++
 tools/testing/selftests/liveupdate/run-vmtests.sh | 2 +-
 tools/testing/selftests/liveupdate/vmtest.sh      | 8 +++++++-
 3 files changed, 11 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/liveupdate/config.riscv64

diff --git a/tools/testing/selftests/liveupdate/config.riscv64 b/tools/testing/selftests/liveupdate/config.riscv64
new file mode 100644
index 000000000000..edbc551199b0
--- /dev/null
+++ b/tools/testing/selftests/liveupdate/config.riscv64
@@ -0,0 +1,3 @@
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_OF_PLATFORM=y
diff --git a/tools/testing/selftests/liveupdate/run-vmtests.sh b/tools/testing/selftests/liveupdate/run-vmtests.sh
index d656ce58c5a7..2e3f5f6f96b3 100755
--- a/tools/testing/selftests/liveupdate/run-vmtests.sh
+++ b/tools/testing/selftests/liveupdate/run-vmtests.sh
@@ -4,7 +4,7 @@
 SCRIPT_DIR=$(dirname "$(realpath "$0")")
 TEST_RUNNER="$SCRIPT_DIR/vmtest.sh"
 
-TARGETS=("x86_64" "aarch64")
+TARGETS=("x86_64" "aarch64" "riscv64")
 
 GREEN='\033[0;32m'
 RED='\033[0;31m'
diff --git a/tools/testing/selftests/liveupdate/vmtest.sh b/tools/testing/selftests/liveupdate/vmtest.sh
index 64fd2ab55b76..ee554d889e1b 100755
--- a/tools/testing/selftests/liveupdate/vmtest.sh
+++ b/tools/testing/selftests/liveupdate/vmtest.sh
@@ -25,6 +25,10 @@ function get_arch_conf() {
 		QEMU_CMD="qemu-system-x86_64"
 		KERNEL_IMAGE="bzImage"
 		KERNEL_CMDLINE="console=ttyS0"
+	elif [[ "$arch" == "riscv" ]]; then
+		QEMU_CMD="qemu-system-riscv64 -M virt -cpu max"
+		KERNEL_IMAGE="Image"
+		KERNEL_CMDLINE="console=ttyS0"
 	else
 		echo "Unsupported architecture: $arch"
 		exit 1
@@ -37,7 +41,7 @@ $0 [-d build_dir] [-j jobs] [-t target_arch] [-T test_name] [-w workspace_dir] [
 Options:
 	-d)	path to the kernel build directory (default: .luo_test_build.<arch>)
 	-j)	number of jobs for compilation
-	-t)	run test for target_arch (aarch64, x86_64)
+	-t)	run test for target_arch (aarch64, x86_64, riscv64)
 	-T)	test name to run (default: luo_kexec_simple)
 	-w)	custom workspace directory (default: creates temp dir)
 	-k)	keep workspace directory after successful test
@@ -87,6 +91,7 @@ function detect_cross_compile() {
 	case "$target" in
 		aarch64) candidate="aarch64-linux-gnu-" ;;
 		x86_64)  candidate="x86_64-linux-gnu-" ;;
+		riscv64) candidate="riscv64-linux-gnu-" ;;
 		*)       skip "Auto-detection for target '$target' not supported. Please set CROSS_COMPILE manually." ;;
 	esac
 
@@ -194,6 +199,7 @@ function target_to_arch() {
 	case $target in
 	     aarch64) echo "arm64" ;;
 	     x86_64) echo "x86" ;;
+	     riscv64) echo "riscv" ;;
 	     *) skip "architecture $target is not supported"
 	esac
 }
-- 
2.50.1


