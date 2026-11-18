Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 970F2606A8A3
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=oMm3ZXlA
Received: by kanga.kvack.org (Postfix)
	id 56E676B05B7; Wed, 18 Nov 2026 04:16:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 520746B05B5; Wed, 18 Nov 2026 04:16:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286686B05B8; Wed, 18 Nov 2026 04:16:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED76D6B05B4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:16:21 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A6BF1C4006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:16:21 +0000 (UTC)
X-FDA: 85447683762.12.21BADD3
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0281780006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:16:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oMm3ZXlA;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794993380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rYTNFSuTJlFrpWYa18HHlkT3uGcwjQ9KRzLVSjey8BA=;
	b=cf9jLmybO3Zhv8yzVrSWvipMWoWg6qbC7TUYnMZP1Fbspmmymew2EdbnNjf/etxuA7GA9X
	z18pepf8wnLKrXfH8FYjczrqlR+2OdzOMSX3w84ILdB2phyOKr1rL9eOqHsLAtzeIij9jE
	BsQG7V6bVkDKzK6zmanpTzTOkVGYvP4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794993380;
	b=g0lVKlOr44P/MQA7wrV5FQ/Ly4Y8GxBroB1tbmnSALdi1Ca1O+eAMTBo3XbG/HXRTZO9PE
	ZTj6EypXpEHdR/Po+767B4D8AwTxllX+yjmqMztwIYWcGLcKnSVAzpcNEOgxgMVR/0zHZX
	wQ4zCDC2mNvBJkoEFwIl47upP26WOMg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oMm3ZXlA;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf02.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794993376; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=rYTNFSuTJlFrpWYa18HHlkT3uGcwjQ9KRzLVSjey8BA=;
	b=oMm3ZXlAXAiByUV+MQFb9OsPMYF7k90zTvTXYmrwQZHA6EJqsVXEVaD6grHKsdGaoeWcTUjwkSdbNp8b0P8/GLb/XzM0trPaRTpDFJJY2TfbEM/w2e4K1TWvZnrqXqhmDKOJTWEWu7DCzMNLP7Ts4oGRce/a3jW8EzFgP9/VZ3s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XF0HHcG_1794993374;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XF0HHcG_1794993374 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Nov 2026 17:16:14 +0800
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
Subject: [PATCH v4 4/4] selftests: liveupdate: Add riscv support
Date: Wed, 18 Nov 2026 17:16:03 +0800
Message-ID: <20261118091603.979-5-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118091603.979-1-cp0613@linux.alibaba.com>
References: <20261118091603.979-1-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0281780006
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qgdzxoryjbjxcg4bz8kg4th4rjmdzxct
X-Rspam-User: 
X-HE-Tag: 1794993378-765409
X-HE-Meta: U2FsdGVkX1/NoVyXx8jcRHqVeCe8EgoCJlU1Z3gBAPteQ+UVtnYdIpcDYDuduRbaHFIAdX5K1dGKvovMj77JqCLfk08fTxCO6ALisg8YScGa7xlkU84c55PQ/S1l6iBj57oIb/FZrP0IB1rk/7AHYxO/aGlRy9k7B2ldlSQs4IaOkFc24QJV9Lo4NS8+LbvwS57Mano6p010Uu1asHFgBa6pK1udC7UQQRUzbPLrQzlVw2cggAISghZx9TI3S3c0yF/asUzDaWzquvFyTXfLVaJY9ZsYaCK8M97SCyJAL3IcPAmtG0PzYg7du0kcQh9SjGbHkLXbsO5Hh6zBaidHO0pYWKmm23q1n0i/Wwjv9RQJaZuaATnGYj3o5rrHCNvm9Lc+m8sY+092I+3aciWJC+f0WuAnKsVWiWoRs26CO1tmGbqHEKfEAeep/tkMMSWiVjKyj53fOxWy+2GU0BuEVcdt7yEenIWbmDZSpKcS2gN3ggh//9D2BQ69q6+NVnyusHrMt85gbJ+I4xb8ILhnAs3L7XItvoQh2kpcAVie5TMgu43gK2i6F2NrnRurT0WTQeDNFLfDgPzijN8tB5igXFTdvJN8ilxZpwLiWnmAEx2op7H3jAlRpSw8KNiCk5xXnv66f52ZHEdoN1foq1WvChQWKr3HvRbTkj/DwJklr3NlekPiqkOs/iUeBYPUltW2bZQejQtlTL0h2UPjgpB7TQdC1B0QG4a0KLlgm6Kh6JcYK4+eR+i/Dfav/abPgZ46yrglcE8lBT1CRXYHz9ntN9xMkXVeddY/FWq8aZjqIzOWQ1fk1NiarQ34iI4NxejvuvbIHLDQzOzox6mQoEkAbYXscKAihmoG0Ay4uhgrsIDjJKViBzyXAFbZ2XafQdYhAB0vbxBBj3pIq4A962SbmBEjMat8vvrbm6HG8BSe3XEs1AaXrdGLUscMO6IGk05TR8Bn8ilg46pWwi4ti/x
 FCeoVH+d
 tJWd9htkiHiBq7VgZYotbSHw3grhbwMeOdvecOUdpjPnLrbztJhTUaKrMuhTTKkdCN8XUOUrnh2kKzVUUY5QKiSNgZGP4jYodKj/irjvn8v64I7u5SUSIHkjvwsHpycgx2YsbFbpPT5DWqu+dKsQt7sYMlzIVpPz3yjGqT52PmnHmGaZ5If2Ico6YzNHZwSW20IkMRxY25rga4cLgQD2DMQ7QxnUrSltxq5L9VUpMil41wIewq5Pvh3BT5YfMPkc37Pndqvh7WlYD9JaLwAN7OsbpUZ1H0vsqc2/8YRF+c77FKd5v8vepXB0/TF1nz99iDLm/WNusQpJDe0RYWwooMuZgjQ==
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
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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


