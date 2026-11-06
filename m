Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 881A7606A333
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cuAvI3mh
Received: by kanga.kvack.org (Postfix)
	id 9B1C36B05C0; Fri,  6 Nov 2026 02:15:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986216B05C1; Fri,  6 Nov 2026 02:15:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875A66B05C2; Fri,  6 Nov 2026 02:15:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C3426B05C0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:15:14 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1E2E804C5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:15:13 +0000 (UTC)
X-FDA: 85403832906.28.6396564
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id D299F1C0002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:15:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cuAvI3mh;
	spf=pass (imf20.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793949312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WHFpp4e9/46UoCbTdVt0BUwdiaUS8B1AQ+AAM13FSjw=;
	b=sZig6h+lHeFDKhzoJnukFVQPrzIrmnmBx6WlLJqkSq/ZYNOSnrnUHxTMYMV8UMgu1w0r3G
	5k3Ir8pgOdXZVbm7c0mFlY3GOFY+JrP+wRO5b79B/wext9KElA6bNvevkbcEKqO5VccjbD
	uEaVksgNpAlfTd/pm9iOBWOLLTaYt1Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cuAvI3mh;
	spf=pass (imf20.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793949312;
	b=v08u4aMvHb7fv8J7wbJfDCEPLBvQt2GxqHUizzegKH7QvppMuADfCtKFIjZ4VSyOnKwtfK
	Gqc+ddtkPTMUxaANiadimDMiTOuoKKDoh8X0afXKeI2CjfRi+RRa7eW/lXggWtjAJ03saG
	XQThcmkvwrDLN1/CR1POFpnW4Yqjz0k=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793949308; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=WHFpp4e9/46UoCbTdVt0BUwdiaUS8B1AQ+AAM13FSjw=;
	b=cuAvI3mhgmPZXBDnJoKAeP1QCTDsrLlbvqo0xRXGF9MdTfVckWwsIx4ss+X6vhV+nNboSZSNM9x0ZH4ZbEWlyAij5lDtM6RjqbggZ1u3wo6wcv9MN0AtZoEdF69t99M6Rz9PZbLAVskAJ9hWvIOawNnW7KS1Thh297uiOCAerpY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XEAtjNn_1793949306;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XEAtjNn_1793949306 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 15:15:06 +0800
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
Subject: [PATCH v3 4/4] selftests: liveupdate: Add riscv support
Date: Fri,  6 Nov 2026 15:14:59 +0800
Message-ID: <20261106071459.2003-5-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261106071459.2003-1-cp0613@linux.alibaba.com>
References: <20261106071459.2003-1-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zhym8irm5tgqm4ajp9nc4amwuhor7ewb
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D299F1C0002
X-HE-Tag: 1793949311-64134
X-HE-Meta: U2FsdGVkX1/dtN1oti5SxlMXdCmnz9jOjlSjcgphul1HaPseM9KRM2hXaPkwhuE84BuFMV4f02Ymetd5qbPrgazceUCcoHaXM5OB0dl9mId4rC6HLKLvhY8DfSs/kl+vm1ojeGg2ZXBLs6YhYf8O0wtykW8ub5bqFJMdL/oGJIEzJY1taXWUKZFp1evUA2m5rjjuJzB8p7AScZVNCRs12KthuCNt06nxjQlOq0yzYqmBLpZ3u/VZ3/oOw2hq972tScBVLNO2wem3pa+uGKrPDVA37ojyFEv2sln49st/t6DUSvd+b72swVF6vwy9n/8V2UNEP3XFt5bdNaqu8bxesEr/tC8DMBN+s08XHxkkVi4rKPgUxkOavc07+yu4KqPNFxFCOVDlwRexHfDBTRV5jopMfvHYrl2o5tndhXqNnTiKftD5pSt4kUOkbKR5LNsstA0ZCPwEbRYT4VRhqj0+WWvt08sTEjS+7aKD+iPFRiaQDQQQI2J0uxOMY64MkX9MyDF4tXcoR9HRv4afCrNop2nboSIWVVPmrGTj62W+Q90h0asMwYpmUNxO4NWdUw18UraLn/EDzArslNvpKGVAVQysHlLQUEIOkVxzFlLnmyzE0Qq8Gq5S006fd+3eb+1hHIiaHgg91Ib6fxbRlLovJZSfUBy4HJw0vp++Hm5CVGzDM2LA34L+j0Nt+Y7WhwLwBUOYOY7zpdG/wKuVBRnxfefMWA8p4c6NHFZzP6eiKsEvDuLxPIvov12xoFfzSzBCWbHaV36Nr7Gn0Up3TMAKc+eDxFIY9xHemofnPCxGGBXeLGwElVpEmUKWGHZ7a2q0Vf4hbqjyhePDX2Xi0s5BQCzdJ+sxkispFfZrl0L6Iwl4mqRtthnSiNgh5JyduYyQGHTb3XUImI1r1AoCp8+BLHpBq/eL+gJgyxZL/rukz5R0hr2SP0tnV4ebNLwSo0tc2hMhrVciPoUkb333Uaf
 9iv4Ew4u
 31Zm2JfiuIsho6XT/VfMBBL3gM1HUPNe51Em3tauOksdlO9VVr6dBniaMxhVCj/yH7kNvqQ6xhtuiYvRurHkt3f9GLwxSx86w/tz7BZI0DujLcByS7euz3LRf++7SLNuKtyTSz9Uol3bJtZHxklqzCeji//qJJVT8GtQaE6nsF7z4PdlqqqCBzCn4LN/NKzgwkeG7kGsiMolE0Khc4ZGlZdlSEsNStzD6Zxd4ehBXqPyESY8gLnYE92oMctPehrTvjwck
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Teach the live update vmtest runners about riscv64, so the LUO tests can
be run on this architecture.

LIVEUPDATE depends only on KEXEC_HANDOVER, enabled for riscv64 by the
previous commit, so nothing in the tests stood in the way.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
---

Test: qemu-system-riscv64 (virt, -cpu max, -m 1G, -smp 2, TCG), in-tree
runner "tools/testing/selftests/liveupdate/vmtest.sh -t riscv64 -T <suite>",
all four suites:

  ok 1 luo_kexec_simple succeeded
  ok 1 luo_multi_session succeeded
  ok 1 luo_stress_files succeeded
  ok 1 luo_stress_sessions succeeded

each with "# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0". The
simple suite's serial log shows the handover round trip:

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
index 6f592aec0f85..c3d828cfd63b 100755
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
index dea5a6fb2abc..70a8d978077a 100755
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
 	-k)	keep workspace directory
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


