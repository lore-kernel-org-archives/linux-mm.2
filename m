Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EE46C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 10:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 629646B0092; Fri,  7 Aug 2026 06:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6012F6B0093; Fri,  7 Aug 2026 06:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5184C6B0095; Fri,  7 Aug 2026 06:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F7D96B0092
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 06:39:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E1FF140380
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:39:11 +0000 (UTC)
X-FDA: 85074126102.22.8D519BA
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8EADC0006
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 10:39:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=leFCf1q7;
	spf=pass (imf10.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786099150;
	b=yeRnlu/dzs7sxtyhsXptoAsgHebApP3bLcsA0MShtXCyLl4YIoQo8c9pkneWE5OYT5l7jJ
	50+r/uoFE5DqkUuhh9d+2EyAm6pGGyTB2SEFnJGwWyUmLLFDAzX6LwyT0yREUkVlg7k6o6
	rtLVltWRI9UUEjbXiTp8pJLYQwJsV60=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=leFCf1q7;
	spf=pass (imf10.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786099150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+cRL3uotexgsAYtLUosWyuQdevxVlf8Hhe38VeOp48k=;
	b=Zdqk1CHt5CvqVDLFKMJAXIyHbb/TbaAYTyQlMCRhFBUCg03LgvPURIEtICQzieuSNHDBx0
	N5TUiTCd0qxUWVjv1sY/VuWvPG+Y4qb3udN2LpV6vkA83wzmbxfDJhZiNcfjc4EaRaw1T5
	7n8NTDUgjAZSaFP2vypA0soBcjIvm48=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786099147;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+cRL3uotexgsAYtLUosWyuQdevxVlf8Hhe38VeOp48k=;
	b=leFCf1q7bWexhIlRym5mgLf1EOisTxXGgyEu7WyO9nLs6AFFzBa5eAN4zwjxXwdcx9Zca0
	omPlm5ULbkJc4DAoXhz5sJcehdTr4IdR3WIHmsRnRF4G7Y5VNtpBLF9EzxE+TcLqPLTWwa
	oHj3Bgs1ou/YKoTNmTnBdncag6GUT54=
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	shuah@kernel.org,
	ardb@kernel.org
Cc: guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Kexin Liu <liukexin@kylinos.cn>
Subject: [PATCH v4 4/4] selftests/kho: add LoongArch vmtest support
Date: Fri,  7 Aug 2026 18:37:14 +0800
Message-ID: <20260807103714.33074-5-dongtai.guo@linux.dev>
In-Reply-To: <20260807103714.33074-1-dongtai.guo@linux.dev>
References: <20260807103714.33074-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B8EADC0006
X-Stat-Signature: 3u5jkd9n14pbrgyzeokfcdy6xorpgboo
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786099149-43435
X-HE-Meta: U2FsdGVkX184srynx6m3oM039Cd70Qe0IEjigzkyTFHcrWWWv7Zk9lF6wDy++kmow9O4oXyRG9Q7/mO4P99sZgu2OO79rqbjo38wERBJAySwaAaY/Z2Uj2IiV8nheBxj0vOIQHQ+D5TfoHGqbyFuguyC2FsEHlTZg7XGutpm46e3SQlukMoPAoochvE9/MHRZxeTm3iXIcP4a723QDXkIxZNGEn6V90K11RFR2kb3nniWilc/s9xFMXfLczeUXyt8QNLTasRyb/z4fHMG8N1EPYY3DhtGnbsaOGBhX7XJfD8wYZ4W2sjNKnxnZrJHsQGA1CxgG2ShCWxdzJ5c4tlTUGPyZoXdt7Qt7WAH3ALA2Uu4Hi15S9yNYLTWKPn12ghCjZOkUIC4tx8ScS9c71xmgy45qS3LvmyLTWdhLcW7k2Ewuq6cr1KX+o0HYUcaRwdO5wIbf02fGkCKWxSOGB3kkjGGSgUArb/qiZKFV7CVT2PDOgLZCDzTubl8W1pjXb4E4UagosfHzkGPA3Mk4P9BMqQYj6csPfHdOH7Mkt9gqM4ar/Xk/3F1tT5fTg+nNdfF6PcV3jC9nVP0ZJZ3xD2pqUfXWBx4w2sNN2qpAMHy9vp+r35ZU5ji6X9xXwFcq1oFDJHGPXrAMXMIpUVPHv338oAsxchuMkYwYKMuKJOglcYdaMlnwGv8G4thOM7DZJSO20GqLA+gT/Aht4707AfuK6lwwE2W/oZDsSiYhYuWpz8MVrFyy5LXaRBVZEly6k89qmxoFGibMgDg37YhIRDwdH90n1rDewAHMISW0uhUY1TWs2ApWQpl/2YjFDe974kXGxh3SqB1GKi1cn0quhdG1SGbzqvKfLATLA9FxX+ZxZHoKCCKecDBemCQx4EXTlhJJ5nTkO0WCrLzeDJynpssmOHKDpGIRn4TzlTofKcX2Q8qxuL2F/s9XANTlo17pac9M8rgYUxh++N9Gp1zKZ
 ylymBOFP
 j/sy9ifzboA0PlaDWwIzX4du2Ny/jpiBp+Gc0UIc7/nW+N2d8AS7kSXBBHwG/X0q/AjZ40o56r/kQaio+V/YMneP8dTrfWzLo+GJmfcKE/hcpcFB/um8Hz7Ks3Q/MrrBMOsRLdSWUvmuGfEPqOel6076hzhSVQ7QZrFVLsuSz1Es2lx1F77atsJFHgUi+OMVwTs/8lUPjAvVbgug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

Add loongarch.conf to configure QEMU's LoongArch virtual machine (VM)
with a la464 CPU, enable the 8250 serial console, and set the kernel
image to vmlinux.efi.  Extend vmtest.sh to recognise loongarch64 as a
supported target and map it to the 'loongarch' kernel arch name.

QEMU's LoongArch VM provides no ACPI tables and relies on FDT to
describe hardware.  Without 'earlycon' on the kernel command line, the
FDT is not scanned for a console UART, no output reaches the console,
and vmtest.sh's console log stays empty causing the test to always
fail.  Add 'earlycon' to KERNEL_CMDLINE in loongarch.conf.

QEMU's LoongArch VM has no i8042 PS/2 controller.  When PNP detection
finds nothing, i8042_init() falls back to probing the ports directly.
On LoongArch the I/O ports are memory-mapped, and the i8042 port
addresses are not backed by any device on the VM, so i8042_flush() takes
a page fault and the kernel panics:

  i8042: PNP: No PS/2 controller found.
  i8042: Probing ports directly.
  CPU 0 Unable to handle kernel paging request at virtual address ffff800000008064
  ERA: i8042_flush+0x50/0x198
   RA: i8042_init+0x2a8/0x35c
  Kernel panic - not syncing: Attempted to kill init!

Disable SERIO_I8042 and its dependents (KEYBOARD_ATKBD, MOUSE_PS2) in
the QEMU_KCONFIG fragment to prevent the driver from being built.
All three options are scoped to loongarch.conf; no other architecture
is affected.

Wrap the QEMU invocation in run_qemu() with timeout(1) using a local
time limit so the test always terminates, even when QEMU does not exit
on its own.  This is useful for every architecture; on LoongArch, for
example, QEMU provides no EFI runtime services and machine_restart()
falls through to an idle loop after kexec, so QEMU would never exit
otherwise.

Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 tools/testing/selftests/kho/loongarch.conf | 11 +++++++++++
 tools/testing/selftests/kho/vmtest.sh      | 22 +++++++++++++++-------
 2 files changed, 26 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/kho/loongarch.conf

diff --git a/tools/testing/selftests/kho/loongarch.conf b/tools/testing/selftests/kho/loongarch.conf
new file mode 100644
index 000000000000..e45fe1014cf3
--- /dev/null
+++ b/tools/testing/selftests/kho/loongarch.conf
@@ -0,0 +1,11 @@
+QEMU_CMD="qemu-system-loongarch64 -M virt -cpu la464"
+QEMU_KCONFIG="
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SPARSEMEM_MANUAL=y
+# CONFIG_KEYBOARD_ATKBD is not set
+# CONFIG_MOUSE_PS2 is not set
+# CONFIG_SERIO_I8042 is not set
+"
+KERNEL_IMAGE="vmlinux.efi"
+KERNEL_CMDLINE="console=ttyS0 earlycon kho_scratch=16M,16M,16M"
diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
index 0014bd76e88d..de6aa59cf5a0 100755
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
@@ -111,12 +111,19 @@ function run_qemu() {
 
 	cmdline="$cmdline kho=on panic=-1"
 
-	$qemu_cmd -m 1G -smp 2 -no-reboot -nographic -nodefaults \
-		  -accel kvm -accel hvf -accel tcg  \
-		  -serial file:"$serial" \
-		  -append "$cmdline" \
-		  -kernel "$kernel" \
-		  -initrd "$initrd"
+	local qemu_args=(
+		-m 1G -smp 2 -no-reboot -nographic -nodefaults
+		-accel kvm -accel hvf -accel tcg
+		-serial file:"$serial"
+		-append "$cmdline"
+		-kernel "$kernel"
+		-initrd "$initrd"
+	)
+
+	# Bound the QEMU run so the test always terminates, even when QEMU
+	# does not exit on its own (e.g. no EFI runtime services after kexec).
+	local qemu_timeout=60
+	timeout "$qemu_timeout" $qemu_cmd "${qemu_args[@]}" || true
 
 	grep "KHO restore succeeded" "$serial" &> /dev/null || fail "KHO failed"
 }
@@ -127,6 +134,7 @@ function target_to_arch() {
 	case $target in
 	     aarch64) echo "arm64" ;;
 	     x86_64) echo "x86" ;;
+	     loongarch64) echo "loongarch" ;;
 	     *) skip "architecture $target is not supported"
 	esac
 }
-- 
2.53.0


