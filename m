Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB673606A331
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=mD9uVWVk
Received: by kanga.kvack.org (Postfix)
	id DF4C66B05BE; Fri,  6 Nov 2026 02:15:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA5446B05C0; Fri,  6 Nov 2026 02:15:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC4636B05C1; Fri,  6 Nov 2026 02:15:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA346B05BE
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:15:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AFB39160CD0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:15:12 +0000 (UTC)
X-FDA: 85403832864.17.6EDEC2F
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf16.hostedemail.com (Postfix) with ESMTP id 58B70180007
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:15:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mD9uVWVk;
	spf=pass (imf16.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793949311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d6ydCQ+GA/r9O1lqv1CIkHCaiuKsabnmgnyXnw1pfuk=;
	b=rxMJwGp/YBshAJiAX6OUznInmo0r1sHV7EpdS+h1vZwM2KOCziDTy7/smuUpAUgaMhVPu/
	MMDvXw03uKZmJtp7FtJkaWm3aTLWkL55yVBlHCOBZRt1sBVBluYVX3WSEoMMOOuX2XPc7r
	uAeK483aM5oepPAxRCS8YQaqVpMOzQY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=mD9uVWVk;
	spf=pass (imf16.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793949311;
	b=JQI3nkc8HdzE24IdN0FAOjn+ZqjCLTX0aAWqtM3PjydU5YjWklaKECfYyyD7uDerNUPv2u
	5y6cSCacgIOjokdYIoko3f59XxX6AHK0UDQDr7o82fbrpgNFqBDBSN4YlVV/A/dUurrpNf
	qypcjT9wmCfOgjuk5mRz8hVvgGkEruM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793949306; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=d6ydCQ+GA/r9O1lqv1CIkHCaiuKsabnmgnyXnw1pfuk=;
	b=mD9uVWVkJsLNiO4/se3MP1sPfn2e/Yp5Jl0u5Hq5TQuBdMeXEQMlDudiUOLqlyUWOA37mAqw6Jg2hit4INsya/1IT6mn8O7k4tBiGO4xg97DLX8pdTPXQxymSa99Ve6jUWFKfs/g1xmue8H/SrnXe/9QpE3+2q1KMGcMdsBVOok=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XEAtjNb_1793949305;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XEAtjNb_1793949305 cluster:ay36)
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
Subject: [PATCH v3 3/4] selftests: kho: Add riscv support
Date: Fri,  6 Nov 2026 15:14:58 +0800
Message-ID: <20261106071459.2003-4-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261106071459.2003-1-cp0613@linux.alibaba.com>
References: <20261106071459.2003-1-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3cet589xjwxhjzowi4zsqsuci97hxg4w
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 58B70180007
X-HE-Tag: 1793949309-50970
X-HE-Meta: U2FsdGVkX1/ctKVdp+5LMLmPnvh6cqGE5cyu6JbszupZpe3CssClUl1ci3ddgl497GBm+dWpURzoIpK8jM98s8fdKwRG3OhFRksGyGIXBDi8OGHcLvL2yHnbeoHeIaLU1F0D7dPgb383pcAfKy32s7ZW6jlJDZx5jO3i12XxtezJuxLYruR6sMIM5fX77O+5a4DZTHDIPVV2H058Fh6IlX2/ZeqaNtnbbd5/0i42e96M6+bnD7K9voP5DOWGlG5eoD2kaVRo2051I+DE+XmHDsYRRGDMGxDraNlS+Ipzi3QuYNHkvSwPE5i41FbD47/pH1VabMtemsOat9wNsp8Rg/H7dEc4vWQ/dv56kFCD7tYO61pUW1FEyGDOt4d9TI0gwEvTl5Ymdih2QwYA972tIfVCXfJMIyHByIzURMaGagRTMdW8Bcy9MNjN2z9kDoO5aY9L0YT532rHPCWPowd2Dm4oNvMZhgAN3J0I0OwmX1PZ8AfAhbpSYS0dgbeAThKL7UhaRNfLOsmegMtKsbySpRhuKxBDSaVJZUpBk7RGfypZysZd5hoygq3g5nnjeQCPQmEcXlhJSkNcK+smsUBcy2cIhnBinT4/YDEoJzCbluJ8XD1YZ8MY0nuEOSsn+WeVkicGM+Krb0GYWf8biJgcB4k8Uxt8qSOgEhEm6eiEGSSvldZUaLXKxbZn+761MpiAG6kNPvQC8+sR3k4RLFKYq7jFeZ6DyiWQ9Eahx+bDLT47RSP17uvKooamoLhIDozGi0CszPRoS8vthFYPL31IOmw+zJDTPWlqfqmU+NfsrMUL2lWpvszSN4dShlQfox9CDnwEmo1nPbJd4SnVRIRKZkEprSpFKd0RlkEgU8Tll0TFwSPJ3JB4BnfYy4cOcKEslr/k9qRFVCpO6SiB89osPyIW3i1GUyW9svKC6xN8XF88iXqrFxx6AVmJ3rtLc+DauS8Oj85Ep/zPG8282AJ
 OZSqf6Ok
 DbQb/JibkeupCj3y39DrBgnUrv6KK1JeYYkdggbnkoDcQcexvBviYrvFrWmywyk5uUJEmkabXGfVKfFZe2+cdsNEKF8zJc49QEs5kMZzUEM0NJb3JPcisWKYArDUUF7Alr3JJj2t+FPl2IeYwNswgHJq4kulMBo/qQeGvGt3z8aqYMMRm6z+HA33psLTQQ3sZZVGTRkR2HVwIHQKJ+j+fYdHwvG0cnsR80b+HmerSkkcigmU/p0cASP9lPnFqO2zo9zHs
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


