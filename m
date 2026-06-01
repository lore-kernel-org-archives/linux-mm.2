Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4B7CCD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 09:39:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1773A6B02FD; Mon,  1 Jun 2026 05:39:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA576B02FF; Mon,  1 Jun 2026 05:39:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0AB06B0300; Mon,  1 Jun 2026 05:39:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D91546B02FD
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:39:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 98532402BA
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:39:47 +0000 (UTC)
X-FDA: 84830846814.12.1358111
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf04.hostedemail.com (Postfix) with ESMTP id DC3FF40007
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:39:45 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rDt+H9kr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780306786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sk4h4g29M85uJUDYWr0m/BnA8wl5x57lY+aGRwoFkNo=;
	b=fN1zmxNfaZ58hvnQ2aS1TGfL2HLnkuzrnfsYoLaD/4MNmw6lOKfyCiXeXte5C7hEi2bZ9U
	980qNMGb2qMr5M0qsnn5m3//wKRZynGugGQq4cGKNVzeZZCONjDj3kHrM4kOEzW1LZlXC1
	rRiGrIEsecoj+cleuM7EijyFF9So9zo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rDt+H9kr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780306786; a=rsa-sha256;
	cv=none;
	b=g8jaseHxv5nUA1d5Dz9sZu3GRGIxiFXP0Ymc8t1QbDBmhZs2CpSlNMXUb39NPCKsmoTuju
	ybme0UJK22KMrAACCDR/6FHD3Cq9kyFR5KEzrNkvi0L5tNax6akubmVQLnp9Mwc091jYTr
	KwWK77FfIgrl3CU/8h2Qy1QwPUozSJ8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780306784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sk4h4g29M85uJUDYWr0m/BnA8wl5x57lY+aGRwoFkNo=;
	b=rDt+H9kr8vc/k8aVhFk+5C+D1jpOj/mQ8GRN3/YLVVxbF8aNwD5/8wkSuqdu1bi5sbiVph
	AVKe5+FOFMEChjBYo/sm/96gbBtPlF5+SXkpLC8QQrLn0NjhvHNydpajyRTRohB0uhuAw5
	sOCCzcCcRHDSOEnmPg9oKaInHdH16ek=
From: George Guo <dongtai.guo@linux.dev>
To: Huacai Chen <chenhuacai@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: George Guo <guodongtai@kylinos.cn>,
	WANG Xuerui <kernel@xen0n.name>,
	Alexander Graf <graf@amazon.com>,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Kexin Liu <liukexin@kylinos.cn>
Subject: [PATCH v3 3/3] selftests/kho: add LoongArch vmtest support
Date: Mon,  1 Jun 2026 17:39:30 +0800
Message-Id: <20260601093930.112758-3-dongtai.guo@linux.dev>
In-Reply-To: <20260601093930.112758-1-dongtai.guo@linux.dev>
References: <20260601092823.110362-1-dongtai.guo@linux.dev>
 <20260601093930.112758-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: j43y9qhs4dk4o1qe6afos7ny6w7cgfcm
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DC3FF40007
X-Rspam-User: 
X-HE-Tag: 1780306785-463758
X-HE-Meta: U2FsdGVkX1/NFhj7W6V2CBqedfyh6LK2YkLRXFA1Kt1DkSFmIiisdJ/k0OzpSMCyy2GN8MfEC1kjng9U8zLySWrl1NCjPEmYrDEc1NvJPkew9/0FFvKHXQsqXtxeUsMZ4XaCKKVJHfY2ZiWc3pnJjZRx2OV+1tFaAVcZPIMGr214CfE5BH7VImCOfF7bnynKge7zWj/54uqBmB5LgmXaQ4CermaSC/piGbJCyr3c8Q2+nkD1El50ptJGvUjSVcykr9/MIZEdMvwUI24fWTy2IiBzKIguON2Zj4qo0z8XVXuCBHIq4/WBEUy+O3FXk32BdWf5QoUv9+F+iIqTQVaHDyykfwfgTBUFUO6yLpJavndfBvngavcbmMh+iXSvkWSywan/hL/8yk4QT3bDgqPyoGTdyWoFtgU6zKSPVaNSEPws2OngI7gLmz4i2K3XTMUlz1uun/iXMIfWSS08joAypsSO60gG8nhQscv5FHM0W7NFOlkKZUSGsmM6ctIPvBhpp3660z+AxG8FwbHjDL7DIPTl7vPOclq7UIsw6BCoi+ZYY/pSsfYCBYsuZKCD0nJMqFPeqdrh6PeIbw/pZZjGL9RVKu38eNG5MapuNgclgtbUK0L7hS0OyNCu17uxjjKYwwOpnVaum3VGhCTZ5cympJDx41RbCximRU0JyU0+NtD5B/AWrCADXphE2BIpMFNHLhq2SXs/7q60nGfWJswKoUuLDSsKYYAdOWgNvfPTIJDblAowYuVoVMkQ9fDUNNdpfGE8Wlnfa3/WA9COaxvoCoANNPATfzEXETWHek4yzmzWRd2NOoPkSjPrIqhuDa/5ZN2jSJ2VjemHLw95M0WP9xRT8a7Vtp52jseI6cZyeNiMVJyg/YOW2ILbcRQFyu8wxakAzNC6c064VNUhY0U88962sguEuoYBPfqVigptMYMO+7tamMkmpfkb1e/FIOkMKoypHHxFO0j6RnuoR20
 bwlW+PQd
 rGqWO4LXGkdmoWXUpyoDkUAE5ZGOLi8oJLj5TMZG7zBvQKGAanJ06WLB7qTK08jVD2kFpICjfRtVv28dxmrxsJkn6qI3Owa2ejx6z5zwEmZsgmcrVjiSrsQceQb8XWvB8S8vTeQbpAPrWIliRkYih/u6rQcfeiD1VVwbbV+9FR+g+SDXkD4afgpBejBQ2HlwIT74aBdUHvh+QPAo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

Add loongarch.conf to configure QEMU's LoongArch virt machine with a
la464 CPU, enable the 8250 serial console, and set the kernel image
to vmlinux.efi.  Extend vmtest.sh to recognise loongarch64 as a
supported target and map it to the 'loongarch' kernel arch name.

QEMU's LoongArch virt machine provides no ACPI tables and relies on
FDT to describe hardware.  Without 'earlycon' on the kernel command
line, the FDT is not scanned for a console UART, no output reaches
the console, and vmtest.sh's console log stays empty causing the test
to always fail.  Add 'earlycon' to KERNEL_CMDLINE in loongarch.conf.

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
All three options are scoped to loongarch.conf; no other architecture
is affected.

QEMU provides no EFI runtime services on LoongArch, so machine_restart()
falls through to an infinite idle loop after kexec.  Set QEMU_TIMEOUT=120
in loongarch.conf so vmtest.sh wraps the QEMU invocation with timeout(1),
which terminates QEMU after 120 seconds if it does not exit on its own.
Architectures that do not set QEMU_TIMEOUT are unaffected.

Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 tools/testing/selftests/kho/loongarch.conf | 13 ++++++++++++
 tools/testing/selftests/kho/vmtest.sh      | 23 +++++++++++++++-------
 2 files changed, 29 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/kho/loongarch.conf

diff --git a/tools/testing/selftests/kho/loongarch.conf b/tools/testing/selftests/kho/loongarch.conf
new file mode 100644
index 000000000000..68727654578d
--- /dev/null
+++ b/tools/testing/selftests/kho/loongarch.conf
@@ -0,0 +1,13 @@
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
+# QEMU never exits after kexec on LoongArch (no EFI runtime services);
+# give the test a fixed time limit and let timeout(1) terminate QEMU.
+QEMU_TIMEOUT=120
diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
index 49fdac8e8b15..918698b6dd2a 100755
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
@@ -107,12 +107,20 @@ function run_qemu() {
 
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
+	if [[ -n "${QEMU_TIMEOUT:-}" ]]; then
+		timeout "$QEMU_TIMEOUT" $qemu_cmd "${qemu_args[@]}" || true
+	else
+		$qemu_cmd "${qemu_args[@]}"
+	fi
 
 	grep "KHO restore succeeded" "$serial" &> /dev/null || fail "KHO failed"
 }
@@ -123,6 +131,7 @@ function target_to_arch() {
 	case $target in
 	     aarch64) echo "arm64" ;;
 	     x86_64) echo "x86" ;;
+	     loongarch64) echo "loongarch" ;;
 	     *) skip "architecture $target is not supported"
 	esac
 }
-- 
2.25.1


