Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3884D606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 17:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xPnFkVGP
Received: by kanga.kvack.org (Postfix)
	id 031BE6B05C7; Thu, 29 Oct 2026 13:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6536B0624; Thu, 29 Oct 2026 13:31:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E132A6B0625; Thu, 29 Oct 2026 13:31:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BCDD56B05C7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 13:31:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3267D1C3CCD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:31:02 +0000 (UTC)
X-FDA: 85376354364.15.2E82909
Received: from mta0.migadu.com (out-197.mta0.migadu.com [91.218.175.197])
	by imf23.hostedemail.com (Postfix) with ESMTP id 14DE714000F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:30:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xPnFkVGP;
	spf=pass (imf23.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.197 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793295060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/+hjM5CsEedso/LlGxQH+kdJiIeJBeEghJpwPsmuqXM=;
	b=l/CyftIVLxfQZu8hZiHlWhrESLmg5OqiAWSzzVM9rmoc3eXeemos423JjolNV4A9SypH4e
	2YXhMAo7i9R0a/u8ANpjMLK7VgJ4HTszgFwFRPlgdOsw6Vr/KgtsmASogske/jboWVnvwO
	WY9fwwwdzVjW22oXtxe5tH9wVZDdTuM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793295060;
	b=QbOqW6gl1ybfZ6Et0jci4UXRfmTr1utIPWdIoMMHDtwbiyxPmeuYRse+v3iUo/uZNlEnt5
	n8v9y2WVTQHoG0dbHi80pkvY8j/tLDVLcjqdAhgXbvM109q65aW01v50+MCHfJAIlWiPs/
	5lmuI5OoU4nbWHangZ/0qRwEpTBdrpA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xPnFkVGP;
	spf=pass (imf23.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.197 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XjaLIKpPNBz8YS+fveYxov34nv5lXYqg9aUyoW4HF6I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793295058; v=1; x=1793899858;
 b=xPnFkVGPL1QlatO8UExQBh7I/oQ7dCIPtcm0w9D9uT/f3tQiHIeMhfaVOfxkUr317Yy8D3qq
 Z9q+BkBVSYSu8XAvbF7V302QzSYfro1VtTONorAqqtsMb84XMbG+lFZgfoRYpIiT7eF/FRER19m
 tadG1qwTfbcTGi96CL0Qf208=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 072f51d6be77a39d;
	Thu, 29 Oct 2026 17:30:58 +0000
X-Mizu-Trace-ID: 072f51d6be77a39d
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
Subject: [PATCH v6 7/8] selftests/kho: Add LoongArch vmtest support
Date: Fri, 30 Oct 2026 02:29:54 +0900
Message-ID: <20261029172956.20791-8-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029172956.20791-1-dongtai.guo@linux.dev>
References: <20261029172956.20791-1-dongtai.guo@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 14DE714000F
X-Stat-Signature: oah3oyy696os6nws41dx551awg19siqh
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793295059-673742
X-HE-Meta: U2FsdGVkX18he0xuOJWT7aLaku53OuFNTcQF6Yle43sLZSH4CYr0wa3j0X8163G0xrMYtxxkZMlhokE1sCrRrKMktgzT0Gi7aZENfJe/H0oxjtvrz7hhYdhKE50kfBu2+2HiJzTaDiVwb4g1q+2ngczLJ3u1T/0JqpEC9R9eeCVfWidvYS2A5ix8gDPdAusrcU0LWX5s60N+QJAg/zFZZO5nVfMKHiHoBIj6RomhYKG6m3LhZgIittJRraky/tT2DTI0bdD3sh/ntvR4SOfO1QxTgMEMRJ6pfcnWbHjZReVF4lPmCx1c/cQEcToYxCCY2WtL+xB4jPmpwUoz0NwIgg1sYdIwt1IuloFiCtKudDzwJZe4V/7JrPUEWeKFCVtp/AmMDp0Ka4fSaYuTBuTNugqyENVd8ZzJ/ApQ4VcOJy43G5Bk8fIpyFu7iYmhr2vyySLmPsbc6RfdFJflMy2AQwyi8xUZ4V9XOGNaImDsPCaX6imIimid9YGcC/aaUGIOpEAG1ZsTKr+hiWlnR7CkgE2aqaYuCOEvyZSGj8E/tbMDTI6PwXs+zjZpn4W4zGgz9SPjEA/ct1VdYpFcLmZhHBPS0IXpo4PbdJxSA7La7XdgiAO3f8ORnckuMwVxEMdKbepk/oQUvTUxVoqB15a6sNkf0JTcORxMZKiGKjNIYi27bYbP9IJgJihlVyIYJ5vUokV+owt/4r59spRUQEfE6sRWEU7gWaCijB2mCRdfBnLnX7u/Ih0mca2NXsvczzXslLxgw2slFMkT5Yr8e141zPR6662quSY/UPrOgkjcdsT8jAECLaP4ggbj9g7n0uMZ47FGYfDynli1V0YFr3ZRbW9nhsIxGofgUPAR8cbGzg6lwHeAkvCEzDDXHGUfkri6aP6Xec6jSw7QZuOiOcFg1qt5gDn6jAHiOe5g6mdvfcrDxi7dT1ZGFJeZiEjNCNdrDnWC02afg7UmMItXMeN
 2Nt2ppeX
 vVVbeUfjBusbrwolaFvBzeeWR9f1yoFAOZeSsJYgwuFWiLAhDJlCpeb5Oj99FvVuBtSFeAxCi5rF2n1kVdvaQDrar2CI2HwnYQqg+8n7fACSP4l6Ws+U2QOyOad94Vc4aiQXe4dm2xwhKwk22H/Oc/11Ejgu2csvbLWtuFClCz2w3fSAHJ8DeOg8vO0tCKQ2HHxzetiyWNd+eYduDN8kAoBQeAO7JskU8j/+0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: George Guo <guodongtai@kylinos.cn>

Add loongarch.conf to run the test on QEMU's LoongArch virtual machine
with a la464 CPU and an 8250 serial console, and let vmtest.sh accept
the loongarch64 target.

Boot vmlinux.efi through EFI firmware. The EFI stub installs the KHO EFI
table, and QEMU's direct kernel boot would skip the stub. QEMU_EFI
defaults to /usr/share/edk2/loongarch64/QEMU_EFI.fd and can be set for
distributions that install the firmware elsewhere, such as Debian's
qemu-efi-loongarch64 package.

QEMU's LoongArch virtual machine has no i8042 controller. Enable the
generic PCI host so its I/O space is mapped before the i8042 fallback
probe touches the legacy ports. This keeps i8042 enabled, so the same
kernel configuration still works on real hardware.

Enable ACPI_SPCR_TABLE so the bare earlycon parameter gets the UART from
the SPCR table installed by EDK2. Unlike x86, LoongArch does not enable
it by default, and without it there is no early console and vmtest sees
no early boot output.

The KHO vmtest needs CONFIG_DEFERRED_STRUCT_PAGE_INIT=y, which depends
on SPARSEMEM, so select CONFIG_SPARSEMEM_MANUAL=y.

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


