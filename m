Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A726606D819
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=JATa7QQl
Received: by kanga.kvack.org (Postfix)
	id 43EA06B05DE; Tue,  3 Nov 2026 03:09:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413C96B05DF; Tue,  3 Nov 2026 03:09:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 240996B05E1; Tue,  3 Nov 2026 03:09:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E623E6B05DF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:09:51 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7925DC0330
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:09:51 +0000 (UTC)
X-FDA: 85393084182.29.8C951DC
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf18.hostedemail.com (Postfix) with ESMTP id 294AB1C0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:09:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JATa7QQl;
	spf=pass (imf18.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793693389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJpxS6fBbPkCEJfRw7yC+xmbJiBPG7KHL3DiOO0TU/c=;
	b=dRavnJjSbUXv7hJRjjC2JkijqdlYAT+LdyPs/2Y6K3ZO9HwoXSoEuc5aEC2y/Xh0wcykF8
	jbQhcaCbq2+9WioS/001WscbQ8asDSt9jdjdLoTC7u1roGznHZIYCxtat05JaGTD2RFv74
	RQKBu2D5ZVcO6Z49KNSA/kU9XLc6AW4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793693389;
	b=rnWXM2ohzPemNa2ocKXX0cWr7yX6WiDBzXhYrletmFHXUdVHFwuxCux0XQEZlC5QRBtNkC
	mr0sMf84AlIjj7mat7nAoSJkq05gLdhE62qx6WTElhxSkKQET9qRMl7wKkT7tIWabM/9e+
	eLeBN7/u3pOFwWVqHVmJalCiGc4uGs4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JATa7QQl;
	spf=pass (imf18.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793693385; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=WJpxS6fBbPkCEJfRw7yC+xmbJiBPG7KHL3DiOO0TU/c=;
	b=JATa7QQllxyXirelWKr/o69Q3iMQA3lj+1AbynX+mh4AoEy9uwiSc0yVWamw3yh3zhpG2UdWnG5CdAORT/Shhi23WPKx4y2KnhLf/96JQfZN9FQ2nBrWqiJ8ehnnlzUsvEevFFzmVL9a8woSbYfi8mm4rjlEjsd4yMxVlDESx00=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XE27L1d_1793693383;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XE27L1d_1793693383 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Nov 2026 16:09:44 +0800
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
Subject: [PATCH v2 5/5] selftests: liveupdate: Add riscv support
Date: Tue,  3 Nov 2026 16:09:26 +0800
Message-ID: <20261103080926.2079-6-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103080926.2079-1-cp0613@linux.alibaba.com>
References: <20261103080926.2079-1-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t598b115zcodtpss9muzp9gy5omu7nrr
X-Rspamd-Queue-Id: 294AB1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793693388-34936
X-HE-Meta: U2FsdGVkX195HYFUmaC9AMFb9WQIi6P+UKMoDp7jClIBb+3lhQXO9025sKQJniBbNcu1DtcArMc2/4Awx2gmL3ss67asKKqAvzftUKJmFe1sSCjUsM2pUReQ00SilxRltOoH+E8Vqbgy8iQhPgRJQzH1lEM7emqan99EkqXf2fU9WCc3JAMDhUPRQBnUMGaFsHeYq04QWPgX0A/Y1XLF6m8w1yUAB5IypOCDsEo/34+1YJnX2g8ncFJFAhnO69Xkw47LK8AybtNKasmZmBYntNCjtpy0eCKQDmFuutmCKReGHYGaU79ypd50ScGWMFd/lEk3xBYcFI3NR78+WhqoHgYz6lN3vAHoOKp1eI8wVM0Ax90cievEEn37G5HR9uRigjTK/5dSQSZSPw5RzuhorUV2QVVCTOSt4OL/GEJ4widtWNdCrNy7zzSrtvVEUAw3MPwrvSfuPdYKERy9cKuAvWeHdTmRdx5uMXOVT6YZmpbVeXGGKixY7MZG9vz/Mv+k7Tai2dI1H2pFT9OEMmbTvMTNJqFw21wy7ErOo/DKGkiQh1ho42rnzXOiW1OCcze5Mjp4Nb9Gp8p4fe4IeHAt1+qURRvhQc+BjSPWxF0JWrmMu1KJ6hfjgK47XdxX7chnnOQBaiDF/06kH8KcV16ZBHUvJCflQQP2y1qPRAL/ApPQKohB7j5cjyHnjo8HE34jQn9DaE0swF1V9x3EONNDbburAd43/OzozGcRyGLIGg2Crazq4TDJuAGRafZRC6VEfbOEBLr2mdsnjurh3GDXKlj9nXOSUmv/s6CBp6a3SV6pb32gygv2Of5GjEMIjcXRuHpdJKQYH7RcVV3eqlStZ487cBDFEG8FOB4ppc0kuK1jIRlP7Gx/lKzjh5L4lNrewOCA/Un9ng+wvI6cc+4g99jfJkWwS1ZV9WjPEwHfNwh25o03NtNC9sjkncldbU7ReFlBxtxRUklwzdJrUZh
 H2Oo7bPe
 /HOI2fycjenMLf21UpnUbTCDjvKPKQnMnh1qKDlJzSRwHmmxymWh3XIfSpQrm7i0Ip2hW953CSlgv27tY3akgIvk/z/iuQIHcOb2lRZFKzS/LYKDHpdDNMGCEeFUHevBGWNPoiyogkpxP+wtwsQbL6oxcB4ep+TtdmupOiL/KcWA3BkINjU8qVBJtAh+IUSFO+JZjSkqvK1jtVb1I2EuaZqv4txmSBxHpM7w34N48jCGUER18VupavX/2dlrlT5GHEIrB
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
  KHO: exec from: 7.4.0-rc1-next-20261102-00005-gfca49e548231 (count 1)
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
index f3fb4142c81d..e67e4613aee8 100755
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


