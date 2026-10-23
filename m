Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B496606A333
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 11:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=ijxAmZPy
Received: by kanga.kvack.org (Postfix)
	id 857A16B0B41; Fri, 23 Oct 2026 07:16:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7950D6B0B40; Fri, 23 Oct 2026 07:16:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9636B0B3C; Fri, 23 Oct 2026 07:16:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 324D06B0B3C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:16:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEC17C03CB
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:16:29 +0000 (UTC)
X-FDA: 85353637698.11.B43A4F0
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf27.hostedemail.com (Postfix) with ESMTP id 25BC940007
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:16:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ijxAmZPy;
	spf=pass (imf27.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792754188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UpRjfzyNCxF6lUBPMaKXf5c8n1ufZ+711CHxEJrOmlU=;
	b=oPVzRvD/+UtY5FIIQ1mfJnlxsF9oLTnhQnCmcZT1AZdm+i1HDjPH6hlK92KAOd6T3s7Rqk
	K+sktxLlTr3dGWfh0oFj78MdO5KK3nWpv6v5YuoIA7XRoeMZNlx4S+zg3Okv6re1A0QmSz
	oSsbCrVUW45wDOPFE82Y3OKZtcs0Oow=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ijxAmZPy;
	spf=pass (imf27.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792754188;
	b=f82+36FXbEo0PU5OETYuDnyKmD9TdPM++NNwacXCbyJerAwEfTFy48PEA1fpFV/XS0IIoL
	GIMXNQ2YcFz+bWHM43/6M4Mx008lpR1e20ntdq4GGGjJAoziQamoir31kUK4JXILl8F877
	hjG25mYLSXSEdU9RZ5WExIB/s3iwIk4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792754184; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=UpRjfzyNCxF6lUBPMaKXf5c8n1ufZ+711CHxEJrOmlU=;
	b=ijxAmZPydjaHZmCv+f0CWGtQ69hI3hphK91TMKo93FuEThn9smcL4RfLTpqDRa0Ng+1CHOKzWiR3sXS2gAf9vbHhNNtu5WkauxinMsZyb7WIt1HESP3/BQg//GSZ12aWOE2LGHV4+IY0CsrP+sy2/tlFb6Nqhhm+5HrnmUROXUk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XDM1n5s_1792754182;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XDM1n5s_1792754182 cluster:ay36)
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
Subject: [PATCH 3/4] selftests: kho: Add riscv support
Date: Fri, 23 Oct 2026 19:16:11 +0800
Message-ID: <20261023111612.2134-4-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261023111612.2134-1-cp0613@linux.alibaba.com>
References: <20261023111612.2134-1-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 25BC940007
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: iqhhj4jdnsb3gnoc4yjnga6wjrr3xx3b
X-HE-Tag: 1792754186-505727
X-HE-Meta: U2FsdGVkX1+rJql4y84FAQkTW1uSqZoxVIuyvPbfrz5UJ3TraYbavY8cTb9c7l9GMt9UPR+YL831J/fIfvKBANLSNwRNBbZYTGnzIO6bTmVUIs+i+VVlk3mBa2px/Fbqf8hlTdJiqsv/7pGcfU4T44rvSdwZT4hXPvWAkQz5+6/jIvM5lR4kJKREL3fq1UFMiaGhY4AE+PPylTtGokjFKbg+owL6JzPC/oXP5hgcY9HjDH+9HNWBe08sIZB8W/bG8FhmaVCXYIfoX+1jW4wBZtWHgtMyi2ZhSilvMmqEYkNiHn/QRQCeXfqOjE37SeewwLC2gT5KSL5EktYv8cMFRxeVbnwPyEhbj270CJdWpRC+c2hELEhUteQvd+W5hWL0SZtWHLosRbLkGMibx7ain8G1AmVvly0cxbO0KiesGAlci3R14Yh0bGwIrDY8VByQiRlHxP6eRWWk8MghHZULXWi93ZgovvW8e0E3Bu8LYPL7oY2TCicBR8BoUD4r6lo0lV9SbACIBi9mEsdWsVvw8C7mzcRa05/VeH4+bY7J7dRhukbDNQ0svAhz/LaCpsoNHoj0QpetiGTuTKl/Lg2J7K5/xGb/d5zDqfDzy4prokmmLPWfrAO2hEuOU/17gW9Afzw6kgHH0zjtpGjnmDySKBgydns8BIJdqslnvg+Qr5OrAo+yFY23oyYBw1Ypt1rKBtXLJhMEQhJXBS3SdczyfFre5dgKEVbd7RzBtnwtPyTm1e0uDUwF7ovxSTxwfp53sCnqtGgyDgpPeEsM/4GwYL+IRcZgzhm8wWk5cH0NeJWjqNf0nUQgzCWURiXrpQhxTOvDBShpRUVALdTw18b5ALu50TB1IcMw67KwXcWnx3XVWe/QB4leIwn6LD+rUezFeVSPbL/8kHi/iUgvHLiJld5nBx4epqQ5tkDpfV04ily5XnCfWyE9jsjOPI9R218xuI9z7Uapl0W/mDxb5E5
 ygNsQtJt
 uSrejQ6KxKF7m0+rZkGD+xDCcET3mFnhQ9JLXFkympsJZjSqMy/XOhjKBRHhHPyZZpiXIBnRBxW7jNBrrcd1RtcqlsXKkik67Zs1Q2Pb5m3ZDmJiYgwZnNEcr2ZA4dmVPZrpPd8lqTU+DbLfqNhaAFPNx6BE7mvPxf1ZZLMQP9NUIbQBHeA09jMw+0gvrwFgjZBHp8G4ErQuZM9xVM/MzxQEgeiCXkcqJvG1tuC+Mo+9aUxEoieIJotX6ORkgI3dlW2KD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Teach the KHO vmtest runner about riscv64: map the target to ARCH
riscv and describe the QEMU virt machine, the kernel image and its
console -- a 16550A port probed from the device tree on virt, hence
the SERIAL_8250{,_CONSOLE} and SERIAL_OF_PLATFORM symbols.  Also
select CONFIG_SPARSEMEM_MANUAL: the runner requires
CONFIG_DEFERRED_STRUCT_PAGE_INIT, which depends on SPARSEMEM, while
riscv falls back to FLATMEM (no ARCH_SPARSEMEM_DEFAULT), so without
it the test would just be skipped.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
---
Test: qemu-system-riscv64 (virt, -cpu max, TCG), in-tree runner
"tools/testing/selftests/kho/vmtest.sh -t riscv64" (boots the Image
and kexec'es into the same Image).

  KHO: found kexec handover data.
  KHO: exec from: 7.3.0-rc7-00108-gc6e90ee4ccbb (count 1)
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
index 0014bd76e88d..325af59f653a 100755
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


