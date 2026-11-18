Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 413A6606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qc6F2Upo
Received: by kanga.kvack.org (Postfix)
	id 6F42A6B05B5; Wed, 18 Nov 2026 04:16:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56CD66B05B4; Wed, 18 Nov 2026 04:16:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FC6D6B05B7; Wed, 18 Nov 2026 04:16:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 024E26B05B5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:16:21 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83AC1140323
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:16:21 +0000 (UTC)
X-FDA: 85447683762.07.06CAB3C
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6F95920006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:16:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qc6F2Upo;
	spf=pass (imf03.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794993380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=klqbk4C3rfoVFxDtUCyjeC9wgALLOyJ7WnK86817z+Q=;
	b=x1pTr6B1KVxeoXesWksIYg7SR0UEMv4aQo/8sUabIIOz0+9pl85ImtoID8R/AgT6sqO+ac
	1aRj45/3WbMKxsjxxLl+8UyEwbbMsq3FfCIwi73lAQ0Ld9SVgGgsWNN6H1W4dFI3c4clV6
	AiwhRE9H/jX/3cOvB57sGMitBS7xo6I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794993380;
	b=B0F+MXKBvG2g+uIp9kPpb8vtgY2lNDH5Ueg6g0Pan8D0YmUjdb9GZ9jY0S0Emv4ZjkIEUA
	JOiK6Wsf18AXdsc2J27ZfbqBcepPZbS2nxWMw2BkaoeIWGD5xPffNb4FzskgD1Ank5Q55J
	/G65HHhEP8QIz7vs0GCEJcHYhNc2gw4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qc6F2Upo;
	spf=pass (imf03.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794993376; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=klqbk4C3rfoVFxDtUCyjeC9wgALLOyJ7WnK86817z+Q=;
	b=qc6F2Upo7Fi9oJlGRJZL7znMOEwH6AEWOxAOvxxnyLB3QcdA6cARtLSoTtNUXS2C4gGKTw9KnWSV2LzrOVy+WJQcwj8+Aii/OWJP9LKC5EpYlCY/ZdvGUf72rRJzPYxRMgLSmPC6/lXPIT5xQiq6w/80Uzy9JoAFq7ojezcK4uM=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XF0HHc-_1794993373;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XF0HHc-_1794993373 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Nov 2026 17:16:13 +0800
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
Subject: [PATCH v4 3/4] selftests: kho: Add riscv support
Date: Wed, 18 Nov 2026 17:16:02 +0800
Message-ID: <20261118091603.979-4-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118091603.979-1-cp0613@linux.alibaba.com>
References: <20261118091603.979-1-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tj6e5ja7m1ucfj6et5yggo4y3iir7f1o
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F95920006
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794993378-244513
X-HE-Meta: U2FsdGVkX199fUN7GzbW/DN3QPfl5C+VHhDRRdjhhG3NQKFyIkkN7UjP4xVd3I3TLZPs2YV1AEi1OSPzyiKcGe+u/Q3Ll8Sx9daSYSC/vY5hLf2BcErlzD/I6DFO5pI1mrA3ok9zqr1w92yz9erh0StjJ0e0DqLoCP4k78gVB2TClnJ2o2jriQ56haMs/fcfC4sThCR9I6a/RRCztoSMfk4Z1aqYV3RYqjq3pNIkMgDLgTHcnEQBWy8m2TNh5o0MmEUGEYGjbPZqH7ssaR4Kjef1L2p4W6VKaR+KclmGYLoXtg5JJw+dTYppc4MSU1JuraOrMyfiI7BMnHyVh28LOWxgR8BxHV+YYD954cj2koJqFOzC/a6ZhbJ4TATd6eKMSbjkRYFMWKtNsCDPKVyrJtJf4UypCyc8PzOGxR3N6E2hAJo4K3PxgsS91bjL7bHOkEohGbEC4vWX9N/0sfAkQQdcBMjqzk2q/347XNtGthfyELAXHdm7bLKHA5PCDSBhVADDCJzt2D9R8AIPJ06rizhjRtDuyD7+e63DzfrHutQu6/YZcb0USI1JU2VBAfZYfE+WIU4/96YMVIqDQ4noit6E+lqWYiOspJuX2NlAqMY6qO60BG3zMvhNtlZ0iQcZeppynoCwF0pinG1K+nCRaM/Cw+qLo9Ofnt/68T+r6lq3cws7DTwzqRCg3PAU9+BDNVK6mvuie06GEcF4iTXdmx9bzSwcGvUSmqrIq4TwH5YQxyQdOpomHb8D9uR2MyRlXV61FETwPOF+1H1LTOCF5M7sJKqMsScegIj94C7eBQ7o1bFabuj43Aa0Zs+zE7HWfi0aY6nA3c0CoqTWeVrbp1TT0elwrxZim4FVS/IDzNvacGtiXb5PEKU9s/LZQt1tYvLb3XzUTF2+5xXPJnh0cF80h82R0PtWHv5IlpJ0VwmkG0L2uJBaEHOOfTIfg2YDHHvdhhfNt/75q0S+3G5
 p1Pp4PHh
 aR/JotKKqu56edtyb4bMzJhr88KrMe5gGSMFjC59XcGuBPuz5oFUnGQgrFeFkoxJ9pIaJjZeuk6lv7DnJ5TzyMG6IyXRsQ968tgFoK5SX41fRdcEB2/tLdKiFjEnQCXDBd95EGIaEGpnv+/gxjCKEbCIlEZKCOe1fmRsaslTpkU8f8ZH9Bew2muk22u+sU9opgJEzSJiNDAwHCmyREDgNPwDJYrJgPNyLsn/NFr9vrGvXSG4t5B3ISL/m9COR4Xnv7VOFTgI1h+LkMAkvI7pYR0QV/mOS4YYKvY93SsNXdgxaweDr9/zXtLXTYq6X1bwWF0uVG5FhhhI+FVxn8fzV7hGYJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Describe the machine the KHO vmtest runner needs to boot riscv64, so the
test stops being skipped on this architecture.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---

Test: qemu-system-riscv64 (virt, -cpu max, TCG), in-tree runner
"tools/testing/selftests/kho/vmtest.sh -t riscv64" (boots the Image
and kexec'es into the same Image).

  KHO: found kexec handover data.
  test_kho: KHO restore succeeded
  ok 1 KHO succeeded
  # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

 tools/testing/selftests/kho/riscv.conf | 9 +++++++++
 tools/testing/selftests/kho/vmtest.sh  | 3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kho/riscv.conf

diff --git a/tools/testing/selftests/kho/riscv.conf b/tools/testing/selftests/kho/riscv.conf
new file mode 100644
index 000000000000..ec2a46cd45d5
--- /dev/null
+++ b/tools/testing/selftests/kho/riscv.conf
@@ -0,0 +1,9 @@
+QEMU_CMD="qemu-system-riscv64 -M virt -cpu max"
+QEMU_KCONFIG="
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SERIAL_OF_PLATFORM=y
+CONFIG_SPARSEMEM_MANUAL=y
+"
+KERNEL_IMAGE="Image"
+KERNEL_CMDLINE="console=ttyS0"
diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
index 1e86ffcc3a79..56cac6ae3cf9 100755
--- a/tools/testing/selftests/kho/vmtest.sh
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -21,7 +21,7 @@ Options:
 	-d)	path to the kernel build directory
 	-j)	number of jobs for compilation, similar to -j in make
 	-t)	run test for target_arch, requires CROSS_COMPILE set
-		supported targets: aarch64, x86_64
+		supported targets: aarch64, x86_64, riscv64
 	-h)	display this help
 EOF
 }
@@ -127,6 +127,7 @@ function target_to_arch() {
 	case $target in
 	     aarch64) echo "arm64" ;;
 	     x86_64) echo "x86" ;;
+	     riscv64) echo "riscv" ;;
 	     *) skip "architecture $target is not supported"
 	esac
 }
-- 
2.50.1


