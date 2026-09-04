Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66B02C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9396B009B; Fri,  4 Sep 2026 06:10:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D0026B009D; Fri,  4 Sep 2026 06:10:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E6966B009E; Fri,  4 Sep 2026 06:10:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFF046B009B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:10:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8FA88160459
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:10:41 +0000 (UTC)
X-FDA: 85175660682.07.2E1B5FD
Received: from mta1.migadu.com (out-130.mta1.migadu.com [95.215.58.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9943E20009
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:10:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dg/D2y03";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.130 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788516639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uI5FL0ACsU1gI6Es6Isjml7bm4xOo67fJ+SLBa3OHw0=;
	b=Em1fJJYYbEaAII7oISN1fyuo5vn9yn0R9bLLEy3R6fGZBOCuRLlNfwhbheLuuelQ7hFe0h
	n37vg3dih62PtOHZ8Bq60rayK0aw+puoHz4bzDwVcJmQyMYZZ6flmv+gx/pCQJ10PjRHMv
	9BShvDl+WSZMcOUJaUzmzYF4XmRmABI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788516639;
	b=W4UxrAmAEm9SA2egwwWMT5Upz7g/sxd9nyEOu0f76ihWjmnJLIcTn3NvwtEDZnyxkzOBuD
	4ZldL5u0lZQQ2mkwOqsY8pittSShxVNfL0qEMWpdOWcAx0z0ceCBPCfhzPyyC0/bVu7PTz
	3uUMyVYUYV/AmGIQQ3ziJ+fY8U6ma90=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dg/D2y03";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.130 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/oiDxHrVDKa7VGrXp6hL5mHL7wu/IJpMsp5HWkvasdU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788516638; v=1; x=1789121438;
 b=dg/D2y03QKFwv7tqBdzyogXQtKWJ6QyG1AcV3TJ7bsMddVZASTcVwj62I/0/wfZEFineU+UJ
 CnMSS7E65A4K0nrZe9VxlTxW2cOeDVyg0D8ncWkhy27GLqaMZuMNHGYTvO2pwJF8dwi1WXA3wLh
 UgCdLH577lFDOfuakyd6prj0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6e5c0a65e25e0cdf;
	Fri, 04 Sep 2026 10:10:37 +0000
X-Mizu-Trace-ID: 6e5c0a65e25e0cdf
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	chenhuacai@kernel.org,
	ardb@kernel.org,
	shuah@kernel.org
Cc: ilias.apalodimas@linaro.org,
	akpm@linux-foundation.org,
	baoquan.he@linux.dev,
	ruirui.yang@linux.dev,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: [PATCH v5 5/5] selftests/kho: add LoongArch vmtest support
Date: Fri,  4 Sep 2026 18:08:52 +0800
Message-ID: <20260904100852.26006-6-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260904100852.26006-1-dongtai.guo@linux.dev>
References: <20260904100852.26006-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9943E20009
X-Stat-Signature: fteu3d7usytthniyt19xz8d4terz6nfu
X-Rspam-User: 
X-HE-Tag: 1788516639-34480
X-HE-Meta: U2FsdGVkX18FO1G/SCduB9CUkkJh5YrseJvLsZ74rFyoaZPpFax7+zIWUdkeJSIJUah2gS953/3SQuembkS3/edU9XN0MM0uwPMD7d8cJAtGxwrXTr0eAFhHkbUCCH4VvuZ12bnGuo8D0jyrH7arRjrpJJoVFwE/HinA5KkoDtT1Zq5yO0cmqtX7SuG25L1vaxVzBLYVpDOLFfUu82zznXlY9d8Bo0dCuG9+MOisrdq7Qw+AeaY5vIU6J24r5xEIqMyXN4LiafxwATss3nQR11qIlC6EpoLfBE9S6GtuZAWtR+yEUtikpN14mAqKHFN0YZtiWrlWibJUTkox6/atakp6zFzvun1wKFKp+KmtTTiVkxo/jkdHiQLiNhGqPXXv1yu4074RDwElpEHNT7ULAT3i9HY+08s46up9JwsiLCT5oZ92CJ7mp3Atb01xRonuFAZ8lfmdi/fUw2aRfit/YBDRbplwfYBhfigW4dy0eVvx+iIPRzqhmoP56ojs4JDSJe3YGFUgM5LIObFhFdCjhs/sev0fbLFQg02+1Pcy8RhtX6p/BjIHYbBrtTxf2rMRUTxXeZuQ+XKy7fx2TAf1NY5qEq+xQ7frYYuH7meNf/IZpSQB5d3V0ktUOc0U0FmaVhzu4RpdEl+2yDhUCZQ8/HFE3UQMVJdITVEuFLjY5TRu3B47XZm8abXsyDCLgDFtpOyjWJUJXl7PUhXpjy+G2CP6asyuTfC6bpwWRP3FC+M7YPDyxiB5zN8yjmwSqzmwe02s8l1v8SZZb6pefKsq5gmvMFIZEkmYEsdgP2ITS14tSmbjlhzMPD0NO6Md794jG65CiYARh4+jk2e79STgTqW+yb//4HaednjLW8n5r1YGHUrieMuSmSNfPVUouTRzEl+CBBWWcH4xMO91VjiW7SZIl2xxQMrgOI1bLuoznU0Kv7bLyC2M2BKB42roFwJGOsAuaK3mD2uNgNVdpt2
 zh1aP9HD
 sXUdW99k5GS1J5Ws3zhPTnQhclz4UBLU2NOK/AQhDHZu5HKjCQkJu+MiC9/RyNoDwOmW2aFDmQbCCb9cv7iteaiHBal6kRWmNTeoQqV8oGKd/slh26t4TGYjQkvvgbTnGi92m7eOFI4P77f4CXK4x4PVqZ57X6cc6PsjSkrLqW2wdxCB7+Z4LEZuGJQLcRgtRl6ck9htPI4ohNJPvyZpgVKgOigvOOO/yA7iTzfx7D7kjbTg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

Add loongarch.conf to configure QEMU's LoongArch virtual machine with a
la464 CPU, an 8250 serial console, and the generic PCI host controller.
Extend vmtest.sh to recognize loongarch64 as a supported target and map
it to the loongarch kernel architecture name.

Boot vmlinux.efi through EFI firmware.  The KHO configuration table
channel is installed by the EFI stub during the initial boot, so direct
kernel boot bypasses the path that this test needs to exercise.  QEMU_EFI
defaults to the firmware shipped under /usr/share/edk2/loongarch64/ and
can be overridden for distributions that install it under a different
path, such as Debian's qemu-efi-loongarch64 package.

QEMU's LoongArch virt machine has no i8042 controller.  Enable the generic
PCI host so its I/O space is mapped before the i8042 fallback probe
accesses the legacy ports.  This avoids disabling the i8042 options and
allows the same kernel configuration to remain usable on physical hosts.

Enable ACPI_SPCR_TABLE so the bare earlycon parameter can obtain the UART
type, MMIO address and baud rate from the SPCR table installed by EDK2.
Unlike on x86, ACPI_SPCR_TABLE does not default to enabled on LoongArch.
Without it, no early console is registered for the EFI firmware boot path,
and vmtest cannot observe the early kernel output in its serial log.

The KHO vmtest requires CONFIG_DEFERRED_STRUCT_PAGE_INIT=y, which
depends on SPARSEMEM.  Select CONFIG_SPARSEMEM_MANUAL=y to satisfy the
dependency on LoongArch.

Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
Signed-off-by: George Guo <guodongtai@kylinos.cn>
---
 tools/testing/selftests/kho/loongarch.conf | 11 +++++++++++
 tools/testing/selftests/kho/vmtest.sh      |  3 ++-
 2 files changed, 13 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kho/loongarch.conf

diff --git a/tools/testing/selftests/kho/loongarch.conf b/tools/testing/selftests/kho/loongarch.conf
new file mode 100644
index 000000000000..36153b03c4ef
--- /dev/null
+++ b/tools/testing/selftests/kho/loongarch.conf
@@ -0,0 +1,11 @@
+QEMU_EFI="${QEMU_EFI:-/usr/share/edk2/loongarch64/QEMU_EFI.fd}"
+QEMU_CMD="qemu-system-loongarch64 -M virt -cpu la464 -bios $QEMU_EFI"
+QEMU_KCONFIG="
+CONFIG_ACPI_SPCR_TABLE=y
+CONFIG_PCI_HOST_GENERIC=y
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+CONFIG_SPARSEMEM_MANUAL=y
+"
+KERNEL_IMAGE="vmlinux.efi"
+KERNEL_CMDLINE="console=ttyS0 earlycon"
diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
index 0014bd76e88d..d05ba0734b25 100755
--- a/tools/testing/selftests/kho/vmtest.sh
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -21,7 +21,7 @@ Options:
 	-d)	path to the kernel build directory
 	-j)	number of jobs for compilation, similar to -j in make
 	-t)	run test for target_arch, requires CROSS_COMPILE set
-		supported targets: aarch64, x86_64
+		supported targets: aarch64, loongarch64, x86_64
 	-h)	display this help
 EOF
 }
@@ -126,6 +126,7 @@ function target_to_arch() {
 
 	case $target in
 	     aarch64) echo "arm64" ;;
+	     loongarch64) echo "loongarch" ;;
 	     x86_64) echo "x86" ;;
 	     *) skip "architecture $target is not supported"
 	esac
-- 
2.53.0


