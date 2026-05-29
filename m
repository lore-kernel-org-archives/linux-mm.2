Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9AE4CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:33:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8B66B0095; Fri, 29 May 2026 10:33:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0BC6B0096; Fri, 29 May 2026 10:33:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E350E6B0098; Fri, 29 May 2026 10:33:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF8E76B0095
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:33:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9C441C0201
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:33:29 +0000 (UTC)
X-FDA: 84820700538.23.6B1A214
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf11.hostedemail.com (Postfix) with ESMTP id 107C54000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:33:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=trmWex9p;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780065208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2pmFg0ye5kd/wVZc0l7oWo0it3EFeUIanJ2wGfN6Hps=;
	b=orvl0y5gDB4+aEi5YQOU4yF+YhnTa9++HfPuZlDPqBtzjUSYZRSIYyDHBSY0QUNi+dteoh
	y8gOL+AtAcfm82PAmQ29cEodfvPB1vbecKR7l6D4+O4dsKZGOrwJpMvu23bXVhbnbhvhPK
	4z7dUhrTg74f04cuIXiOVU9nmkHdhOc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=trmWex9p;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780065208; a=rsa-sha256;
	cv=none;
	b=r+PSh6qryCy/JBO1lJhXuDjKFaOWdY21kV7Qn+fNwdtj3EVsZvkbgVyW+j6y5Jz3Qu9d/5
	wBiilICoAluGnM/UXKqMQx2hU/sfN0uRt4006u9uDJQgNG+/o4Xj7tsmOHLVy1VQ+A6g4K
	CWkIHxhrkrRCXTDLZ/+bhpL79/+mBvk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780065206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2pmFg0ye5kd/wVZc0l7oWo0it3EFeUIanJ2wGfN6Hps=;
	b=trmWex9plGSmdvJZunorsxrk9A0B2CC66Xq5oDxgPLcra8WcWhAj+yrSNtWCGyJf3kmJUB
	OvAuB90ejBL3rRZNg2vI3fJmInKADuvJEKE9i+aIfK2LrZiw/E/vZ1B+b9g/+1YrF7T5nE
	RMSbjPyQza44x3A7soqYrdkbpo28Eq0=
From: George Guo <dongtai.guo@linux.dev>
To: Huacai Chen <chenhuacai@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>,
	Alexander Graf <graf@amazon.com>,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	George Guo <guodongtai@kylinos.cn>,
	Kexin Liu <liukexin@kylinos.cn>
Subject: [PATCH v2 3/4] selftests/kho: add LoongArch vmtest support
Date: Fri, 29 May 2026 22:32:37 +0800
Message-Id: <20260529143238.169169-4-dongtai.guo@linux.dev>
In-Reply-To: <20260529143238.169169-1-dongtai.guo@linux.dev>
References: <20260529143238.169169-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 107C54000A
X-Stat-Signature: e97oomhgz7iurp7u4ntzf5i38midshig
X-Rspam-User: 
X-HE-Tag: 1780065207-84362
X-HE-Meta: U2FsdGVkX1/8raGC5F17azsskoZqxvrMYt3RME9J1a5O4JNrt8Q5QyAIxKWVtfbT0WUB7YjbrY43qjisRzFdKJ7/7VAHm5gfwbWcgPdImKlhwz0uYLuvGer0wEFPoF8wXsC2LocaK6qFJTyERHPuTGAHDodtabTUU8I1U8wl2jiqYPXEJdAX4an3cLEmVts5NVcvtCBU0aBwQTH03hiiaYDDbVN/7oVhgQ+lahychElq0r+gC0wK6NWp+TBG78oWdrb9vJGLv7BAX8AS/AyFtRCMkOslKcal1OuRwuHx8LOxU1x48HBftyVz/6NziUNAqz3/wa9eQUVChEn06wCTlDPlFB+E1AftX75tPnHXOLfa8y4edC2QVx94vL75bSB9AhCzADPXfnVJw38AMtc2WIhJx7BSZfBYpqbU4mmfi56m13EMDMIn5Qjf7nOF4ZSfNOPyFHN7qvygJ1NuiaQjdAZv+50WPe8ijfIuKB4jPzrw/VdfmW0ZNw9IU3x5JV2CB4N/xe/2HF5oENeGugnXxSMxu104whirNZu8lQ6SwaHtWw5DDHsIM+BtTxqSt7qbIZ0J6KyxVYePGP5aqCE29ymB62upUzihUW7ZR3JGgDoFDZzp9EKBFtmz5pp+ZAp+pByM0o8SwqtbGfOun8q5DDDaOOHYZYco0WyYwQ53AyX+oVdPZJ1lz6qAYPy1zUc7WOhbE3iQ9AgDhzQ5GSPnzanl2XnCbyM4X+ruzJfkNACKfqECXWWhh/Lr4WIXhfpIjTJK/losk+mfxJaTvR/0nmFQ0XpLsMt+C8OaI0KNxQ5/qG8sT6f34Ug4gngi1XF+woaDpAhtHEH0OlnvkdOQmMHcbvdD80/VKjcMdUPYP7cRzSUr77SzK3LIqXK8oRq32mmkpWScJjJvsWdkqhZHqMQgalEpIqVMhmmeHUjHbkxez10puTFrE00z40WzdvgU5X5uh3osuO+M5QEUe6J
 PtBBo+0R
 aG5Q0PFOo0ZXK/WzjtB6iRAo77uMmHqbDG4ETaBUeJaUbQqVKo3A/fzLryeBHbi7H5dY+laJ6vGT9z/9Xu79X21/OTkJqx+jg2Cquha3JHO6q54EiERJqvXOag4FdAv+1GPWnbLeKzN6pmteKJJIQix0+0ntsPbss58kUGGx48ICRJyIxSfsq6OL/kkDDS9ajzxNysgPsVMUjuAQ=
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

QEMU's LoongArch virt machine has no i8042 PS/2 controller.  When PNP
detection finds nothing, i8042_init() falls back to probing the ports
directly.  On LoongArch the I/O ports are memory-mapped, and the i8042
port addresses are not backed by any device on the virt machine, so
i8042_flush() takes a page fault and the kernel panics:

  i8042: PNP: No PS/2 controller found.
  i8042: Probing ports directly.
  CPU 0 Unable to handle kernel paging request at virtual address ffff800000008064
  ERA: i8042_flush+0x50/0x198
   RA: i8042_init+0x2a8/0x35c
  Kernel panic - not syncing: Attempted to kill init!

Disable SERIO_I8042 and its dependents (KEYBOARD_ATKBD, MOUSE_PS2) in
the QEMU_KCONFIG fragment to prevent the driver from being built.

Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 tools/testing/selftests/kho/loongarch.conf | 10 ++++++++++
 tools/testing/selftests/kho/vmtest.sh      |  3 ++-
 2 files changed, 12 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kho/loongarch.conf

diff --git a/tools/testing/selftests/kho/loongarch.conf b/tools/testing/selftests/kho/loongarch.conf
new file mode 100644
index 000000000000..0145cb49e5b2
--- /dev/null
+++ b/tools/testing/selftests/kho/loongarch.conf
@@ -0,0 +1,10 @@
+QEMU_CMD="qemu-system-loongarch64 -M virt -cpu la464"
+QEMU_KCONFIG="
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+# CONFIG_KEYBOARD_ATKBD is not set
+# CONFIG_MOUSE_PS2 is not set
+# CONFIG_SERIO_I8042 is not set
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


