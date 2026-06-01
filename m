Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87436CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 09:28:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F32B6B02F0; Mon,  1 Jun 2026 05:28:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3AF6B02F1; Mon,  1 Jun 2026 05:28:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B9936B02F2; Mon,  1 Jun 2026 05:28:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 77A496B02F0
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 05:28:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21E8C12056D
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:28:52 +0000 (UTC)
X-FDA: 84830819304.30.747D051
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf27.hostedemail.com (Postfix) with ESMTP id 695514000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 09:28:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G1yanIRS;
	spf=pass (imf27.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780306130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=g29uDzwGW0NTcSuFfWko8xrjZg7XxEg7NOcp6XGp35E=;
	b=EhTLIwByX5Nt6919KqDKCeD2RQpDImEkvGATh7tuhUCxL7qBCTecBzdGviDJSNgl+OMcKI
	6ICadniGHyIcoTj7q1TPvsf5B55lG/HjtKY6lihh7Bi47p8qQc+VaK9G1HYs7DBzD22AsU
	IVUe9kEK/r78itVRD5YNjOvdq1O7E4s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G1yanIRS;
	spf=pass (imf27.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780306130; a=rsa-sha256;
	cv=none;
	b=v0R6zDHK8pqjcRbFocjq7AeuzQqwox04otYBlLyyGkpT7Hk0wShmqCRvYa18Pf+TrT7nyv
	GejVO9ly6w2ZUJAIiQTQ1/vXVvQMQYEVJ8Hrt3f0VWQ9n5F6TOCIHJn9O95EL1xt71BggD
	8vTInSURpzRHmbRH1wHNUNikIsS2NuM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780306128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g29uDzwGW0NTcSuFfWko8xrjZg7XxEg7NOcp6XGp35E=;
	b=G1yanIRS6yXPZoIwX1L76zEI/J+Uwmu2iCm4414ti+w1YVL+TEmhRDZxnTfDwVpz4RQ1Ks
	RgQds/2HYs8jVcZzx93YbUarTOCWkNz5RANvpCjGdcmpwLQstUfaAmlYGrb2E27rjO/Dna
	OiiPa7ufzdr9fGuygNemUGjCcQ/nspc=
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
	linux-kselftest@vger.kernel.org
Subject: [PATCH v3 0/3] LoongArch: add KHO support and selftests
Date: Mon,  1 Jun 2026 17:28:20 +0800
Message-Id: <20260601092823.110362-1-dongtai.guo@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: z556zjitgxcytaw6sro9rscannq4akyn
X-Rspamd-Queue-Id: 695514000A
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780306130-448475
X-HE-Meta: U2FsdGVkX1+I4eJMv78ZdLtVqxctOWeS7h4iSuxOFGFJlIJsB8CjCl+qWyHYGBP0vB7sWUgeP9loWBidX5gmCHa4QCiJc5Wm3b3nGrWlDSsmGVhdlEsKuj5ycNaIAu6RRhFG5LRB7//LhMESNIzk2CDruVjW1Qphpen60/kDgI5MViQQTrSjCjf4QvglOFj8nkS+9BZ3JMfiJKHrOUeIKrs57KUOpE2RklWXZK0bxHflzCjnGr7TGrJfvp9Z3wLjoIkRAI8HQrC99ooHDm4dU0lOaNMrUlS8ey2esTmqEP8vSYf6X+LwCRiavTjyZzvE+e+8smtM/xOTAdwRFPujkFTvwZvYWIDmR8thY76CIUfPl9faU//EstPaNnpL2lrUSKCyJet5bNE0tzz4ZQKc/xXtP3IXaJildIdBTSvFxTjTGi10ywpE9yQYlOMUn9+w9n0D8j+b/yRVczsY9720S+eR7bf8QdNNhujz/w8x1iGhC4Dh2/y0GreysMrsqYnrQJj7xvW3M+7RIIwnyNg2MVhz3PCu0mFdPSOoUxX9RBbm/T5WDMmROED+GWnp9j34UiLpKoFpbSiRJuKKN2qMpcdiCxHSCnOU5O5+FmFGkD0+UB3vd+u2rGIrwoURf1AbdT5Ie/JkqYpJHQQ7bSW4ePjI7ZH56r7PUSlHFnxLodRVGqLWvZySR2QvmRfYW3ZZnUo8Bjjdoc+fY4v9tWGR/HhGVOYoCLLBbyrOnkHi0A6KeNgDRBApUWpO/80NwAPAbMunp3i2QcvaJZeOZvRYrQ1vEPaNNkz0eUwkNbJedD8ZGM5GbGkMNjlO6xw2NhUimn0qpXtI1VhBEKJ3+ht/HhskahfE4GAuvLHXfzWNDLIkP4Zm86CZyx/j4jNV4jMYjNZEsbu31hxXQxbcR02iBQLkizHc9XncaCX3co8Y/NlN0ntuxge5rdy4YDYYdiQKWWlJjsHKx0lQ629vFRi
 uEZsaa4e
 7dM6/u18LAtgVOXBIVHMsG2Ktt2l/4zbmRWokjBuADXLMj/qDm/mNtkCC/HeQspTlnI0NPxqBy/mdhuo2UOWJMCzmUZdFsYTdzww5PyZ0rO9PBdY2BUHiwZ0FJ6O4z9OTXPmJ4T3ts7jCVpxiaqePR+Hvjc5dl9mqDE7ZZdOm9B1I3pvdRDDKauanEm1bdDKE3Sq48oOXQt1n2d5oac5Mzi+qcWNuqSYUivDv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: George Guo <guodongtai@kylinos.cn>

This series adds Kexec Handover (KHO) support for LoongArch and extends
the KHO selftest infrastructure to run on LoongArch under QEMU.

KHO passes metadata (the KHO state FDT and scratch area addresses) to the
second kernel via the FDT /chosen node, using the linux,kho-fdt and
linux,kho-scratch properties that drivers/of/kexec.c:kho_add_chosen()
writes and drivers/of/fdt.c:early_init_dt_check_kho() reads.

KHO support (patches 1-2):

Patch 1 adds KHO support for FDT-based systems (initial_boot_params !=
NULL, e.g. QEMU virt without OVMF).  kho_load_fdt() copies the running
kernel's FDT, appends linux,kho-fdt and linux,kho-scratch to /chosen,
and loads the result as a kexec segment.  machine_kexec() updates the
DEVICE_TREE_GUID entry in the EFI config table to point to this segment
so the second kernel's fdt_setup() can find and parse it.

Patch 2 adds KHO support for ACPI-only systems (initial_boot_params ==
NULL, e.g. LoongArch servers with UEFI or QEMU with OVMF).  Because no
system FDT is available, kho_load_fdt() builds a minimal FDT from
scratch containing only /chosen with the two KHO properties.  Since
DEVICE_TREE_GUID is absent from the EFI config table on ACPI-only
systems, a new extended config table is built with the entry appended
and loaded as a kexec segment; machine_kexec() switches st->tables to
point to it before jumping.  The second kernel's fdt_setup() calls
efi_fdt_pointer() to detect the KHO FDT and passes it to
early_init_dt_check_kho().

Selftest support (patch 3):

Patch 3 adds loongarch.conf and extends vmtest.sh to recognise loongarch64
as a build target.  The LoongArch virt machine is FDT-only (no ACPI), so
'earlycon' must appear on the kernel cmdline or the console UART is never
discovered.  PS/2 input devices are disabled since QEMU's LoongArch virt
machine has no i8042 controller; the fallback port probe hits a page fault
and panics before reaching userspace.  QEMU provides no EFI runtime
services on LoongArch, so machine_restart() falls through to an infinite
idle loop after kexec; QEMU_TIMEOUT=120 in loongarch.conf lets timeout(1)
terminate QEMU once the time limit is reached.

Changes in v3:
- Merge selftest patches 3 and 4 from v2 into a single patch
- Replace QEMU_NEEDS_KILL/background kill loop with QEMU_TIMEOUT/timeout(1);
  the timeout value is set per-arch in the conf file.

George Guo (3):
  LoongArch: kexec: add KHO support for FDT-based systems
  LoongArch: kexec: add KHO support for ACPI-only systems
  selftests/kho: add LoongArch vmtest support

 arch/loongarch/Kconfig                     |   3 +
 arch/loongarch/include/asm/kexec.h         |   7 +
 arch/loongarch/kernel/machine_kexec.c      |  38 +++
 arch/loongarch/kernel/machine_kexec_file.c | 256 +++++++++++++++++++++
 arch/loongarch/kernel/setup.c              |  21 +-
 tools/testing/selftests/kho/loongarch.conf |  13 ++
 tools/testing/selftests/kho/vmtest.sh      |  23 +-
 7 files changed, 353 insertions(+), 8 deletions(-)
 create mode 100644 tools/testing/selftests/kho/loongarch.conf

--
2.25.1


