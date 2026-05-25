Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FE57CD5BCF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 06:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEDA36B009D; Mon, 25 May 2026 02:28:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC5366B009E; Mon, 25 May 2026 02:28:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02B36B009F; Mon, 25 May 2026 02:28:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0F986B009D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:28:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 627B714014A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:28:37 +0000 (UTC)
X-FDA: 84804963474.05.649C511
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf03.hostedemail.com (Postfix) with ESMTP id D54522000A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 06:28:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wF4CAHMK;
	spf=pass (imf03.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779690515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mcgnzkCekxGDxlLfZgjscpscBgEbQ0p2mN6z74HWjig=;
	b=3cogh2hA2Es2cJbF9cLDOqwKDhRfwsYlX+2uYGCWztscLLXBHgp+zVjnLQNIUkgV7QwD2D
	nZ6jKhyeZ8m3ojBh7PidvqvK7+kFB2rfHO2EI91hoB6atA7SpVqbL3KGXtWmFcskmQh5xQ
	3XRXdDH63+kr1LVlfZCk1hgqEGOJQdM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wF4CAHMK;
	spf=pass (imf03.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779690515; a=rsa-sha256;
	cv=none;
	b=rQZzUyQn60FssUUZqIHaMu/4skqTBzr2mrDox/GnwnFbcRYqoaJBG3qjhx9nUY4r7lR7T6
	LJIhlFXHc3LVFp0UAxKOLQkXZjY7RMyO5K5Vy1ij1GXBsupjNzsOD7mu/ZsbD/MP4uKx7j
	5B2mYbhLC6gVxGxrXQpq4+VAjTIRi1c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779690514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mcgnzkCekxGDxlLfZgjscpscBgEbQ0p2mN6z74HWjig=;
	b=wF4CAHMKnaTjqP7CgZmhq1gjjZcsaQDDnRTJ7BOOXGt2R4+eBKLdLu6nFi1Etz86WDKBUm
	9eIv/D+TXkOgB43kU/9ITlfPggrXIbYYowsynT59if8vuDhnasmeCa25X6FhnqXoDxoTVg
	kRRqpHBBSpRR8UA7tn4RIUkQmoAWafA=
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org
Cc: kernel@xen0n.name,
	graf@amazon.com,
	shuah@kernel.org,
	loongarch@lists.linux.dev,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	George Guo <guodongtai@kylinos.cn>,
	Kexin Liu <liukexin@kylinos.cn>
Subject: [PATCH 5/7] selftests/kho: add LoongArch vmtest support
Date: Mon, 25 May 2026 14:28:08 +0800
Message-Id: <20260525062810.103367-6-dongtai.guo@linux.dev>
In-Reply-To: <20260525062810.103367-1-dongtai.guo@linux.dev>
References: <20260525062810.103367-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D54522000A
X-Stat-Signature: 9gwr45getokpr7jk1rkt4zkedat1g5eo
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779690515-214958
X-HE-Meta: U2FsdGVkX194HHOVBEcagCkxViC/plEMQQFvNeILz+14hPtYT3RKf5X7URhZW0yaey/xYWZKcSPC7g4e5qBsnCmegcmSXGHHzcJtoC+gEyZMb4winhj1HGBNepIqSPX9iZcLMCdL2IzqSlOXuL96NBWOWq+9MtpP679SKgacTovP5gl0JUbqkAN+SE3rPi7r7T+VA8mpsoNyDU75gDJhoZ/vZVCRwlDj1sf889pljO81js2g62p1xeS7uyYgxB4Kd0ChcACJ/D3c0b1gKwZGwGNoj/qlSPWoc7oY6ghipMUjJ2nytMwhwUr49+VHix0juqC5NUosUXMQ4MawfxrQykPNzraEIhfTq/W7ot3GvRs/3blp6DKhSWzeFZ+YJNas/zp9bbu90n0+3p7WJidMaZbMTz6TocQEuQ5fpL1kRr1UX5hlRZKGdpgtgrknOTsWWD0s7TWzGxS2oDEiirs2zyUXaFO3wz+IXbkEMAbrmsyF/bOr3U/ZMgQh3UfmtNaw3KUfB9RlBK/j9A+EYmFdJw7hVQCCNdsN5EK/cMbuYeJGIADjpGfn3zGxNIA+2hS+axaXJF9tlXvUNtVXssX5xSaHfimxX2OF18VU1TN68jvO+Q4+RUuxgjFRDxsb5vwms3IBhTllxtgG6ELqvA5DWzo1mL6RIzVomvEJ6In5NCSF2s2/wZ0W6uSG7b5J/xNtbo6hwejTLYhKFIlYK95T4tdbjNjn7GUYpMgUv0IGuIJUHsr20cgLEDBaZKnQtPDeQvMMTDOKEa/tgVgfBQapfZYqcT4S4lhyxhS3dpD9wLbGdaoR+qWlEwJk2KIEYE0jrUlR3Ha8HjTmtrnw0qKt2hwWcBRv5bkc9uAeIQj9SoU273c3HBw+osXwZHs4rpT0cpVhbixsZ2uthR1aCp9imIeNnixGX9YG+MNoXlBdhZf4k70TZJVdBnbUbOK1Wi2/+f1GivwmyBH9geYqQTw
 pu8cla/C
 Zz+zLs5drHi0h0FYlabzMolX3qZ9Cup1iknfrZOZWh7qzTxZa1k9PPZ6324EghrBHYGWVEdOsJjzU8PzWB5AmZNnkWupNVOxev4yOolob2NUgh4JvfwpSewohrfahkFRqvBX0EDChXRqLou6l35/NMCpI46P7TB7iPTauUPSmXMaDDHOcq/Lut5pUzA0u3upheKme
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

Add loongarch.conf to configure QEMU's LoongArch virt machine with a
la464 CPU, enable the 8250 serial console, and set the kernel image
to vmlinux.efi. Extend vmtest.sh to recognize loongarch64 as a
supported target and map it to the 'loongarch' kernel arch name.

QEMU's LoongArch virt machine provides no ACPI tables and relies on
FDT to describe hardware. Without 'earlycon' on the kernel command
line, the FDT is not scanned for a console UART, no output reaches
the console, and vmtest.sh's console log stays empty causing the test
to always fail. Add 'earlycon' to KERNEL_CMDLINE in loongarch.conf
to fix this.

Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 tools/testing/selftests/kho/loongarch.conf | 7 +++++++
 tools/testing/selftests/kho/vmtest.sh      | 3 ++-
 2 files changed, 9 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kho/loongarch.conf

diff --git a/tools/testing/selftests/kho/loongarch.conf b/tools/testing/selftests/kho/loongarch.conf
new file mode 100644
index 000000000000..b0551e0c2d77
--- /dev/null
+++ b/tools/testing/selftests/kho/loongarch.conf
@@ -0,0 +1,7 @@
+QEMU_CMD="qemu-system-loongarch64 -M virt -cpu la464"
+QEMU_KCONFIG="
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+"
+KERNEL_IMAGE="vmlinux.efi"
+KERNEL_CMDLINE="console=ttyS0 earlycon"
diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
index 49fdac8e8b15..a6ae9ac09595 100755
--- a/tools/testing/selftests/kho/vmtest.sh
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -21,7 +21,7 @@ Options:
 	-d)	path to the kernel build directory
 	-j)	number of jobs for compilation, similar to -j in make
 	-t)	run test for target_arch, requires CROSS_COMPILE set
-		supported targets: aarch64, x86_64
+		supported targets: aarch64, x86_64, loongarch64
 	-h)	display this help
 EOF
 }
@@ -123,6 +123,7 @@ function target_to_arch() {
 	case $target in
 	     aarch64) echo "arm64" ;;
 	     x86_64) echo "x86" ;;
+	     loongarch64) echo "loongarch" ;;
 	     *) skip "architecture $target is not supported"
 	esac
 }
-- 
2.25.1


