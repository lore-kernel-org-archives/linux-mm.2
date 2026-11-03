Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEEA6606D83C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=nebM7Z7o
Received: by kanga.kvack.org (Postfix)
	id 1090D6B05DC; Tue,  3 Nov 2026 03:09:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0991A6B05DE; Tue,  3 Nov 2026 03:09:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9B716B05E0; Tue,  3 Nov 2026 03:09:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0E2D6B05DC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:09:51 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 531F2A7D22
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:09:51 +0000 (UTC)
X-FDA: 85393084182.24.F2E51CA
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id 59EC720006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:09:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nebM7Z7o;
	spf=pass (imf03.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793693389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hZSS8pIphBraD9CLXDgq7aSqfm0V64ZlrBCsq6wroQE=;
	b=VX6QZ+YLuJB6h4HmyHy2cMiqZhp6fmVTsfPK/vsK2zB2dQ6CALxovRFrA8yKiaE+fob6bU
	WcvsPh/Vhv5g2fRCxFu2xTFTDB1SNdjlWXu1Fq56mnrdRc+voRXh/DoCYkcgxFaKc8buz+
	ICFYyIQTNWwyvDPs+NQAR3jDbTPmZO0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793693389;
	b=Xu2uUGLo3P08cxgTAXYVNwYXGNzQgyAQqy2bLGwf8LpDoFCVQvKbuzvi2Oi/xYWFmjIBwv
	pnO/C+hjgfx3Kf4E56LfOgAfMFI51sly2ESF0X9LHuAjiVIxtw9r35c3tH2mJfVK2/OLMr
	sVTqq20Y60rH9rgSW1sCFLPnnK5vA9k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nebM7Z7o;
	spf=pass (imf03.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793693381; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=hZSS8pIphBraD9CLXDgq7aSqfm0V64ZlrBCsq6wroQE=;
	b=nebM7Z7o32q1ppKJG2S5gz4nLWudpnTI4YE3RmbixGd7Hy17KAt2yJb8amgCi3ihJKxaLMNQQJwKjNFeI8WOgj+B3T51njQ15D6ZhW5sZnEXrF4PonVVIGhTi8RhH7YztP8iI0wsy1os1wuExBuOjCw1XfqBAY69BCSHHvpUdlQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XE27KwW_1793693367;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XE27KwW_1793693367 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Nov 2026 16:09:39 +0800
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
Subject: [PATCH v2 0/5] riscv: Enable kexec handover and live update
Date: Tue,  3 Nov 2026 16:09:21 +0800
Message-ID: <20261103080926.2079-1-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aibs1x1e4uybz9g6urg633x757hgh6ct
X-Rspamd-Queue-Id: 59EC720006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793693387-812903
X-HE-Meta: U2FsdGVkX1/huio3oyPm0cBCh5VyznG6aWvpou+pYWzaYELU0rrdWRaVxSo/ARQ+0txtKYWR/i+mj2BOmlrQFAaABIiTgtaVv4DI9oeZ+P3hoTdbv5zwyomGnHPAgRhMU1xt7ZBqsrCoXt9d2ORX3/Gn1uVv2tH7M2lgAmake/acMkcqoQjsUTUv6aI5LnAXYhcbbsqDY/Qm6hR+SZp3hKe0u2zO1FdkQNUndYWriLKaZ1XK7uraKD9tGMJC6nzU6mbjWUpQo01c/NZaDlxQfAR24DFvH4IXU9rTm5z7kJmlddSKBPWN3nJ2vuTQh5oTmwDjTNYKhFKyUUCk3EyRg8LbJ71rPZSrilbTjs9eh6L02MbCA+247cSC5xrQLKmC/RAX4zTI+s0gvnH6m3hWhNK0nMp8gVbVNZ+kNPDObJ3FGwPN1oOH6ZpdGfaf8KDat5FHSDxzeUltx7jNdJbkxGnNCzfuyM8ANTGzsoNSVihh7sCf8CNCN7wQu0jfP9RUfP3ixIG8Nq9zLe2m8wTPkL+k1ga9zC1wQWUxOltHGJ3MM+8bZUunYFNTzVtqYoIoXmz7ipmFS3fu0iemSR0c7pPMtLOzH6VZJhL7nMds1M/PttT3KdIqomsQWjcZPoH3b8Df2IaAx2KHZanPAecRwwEmZonE4FsVVSQ8Ofqq0Mo3RvF9z7oIc+eV7pgOvqItNxdgOJ1r8A/GOb/6LaLAhbwtVyo1cgpwVyFvd2nC7ta4AtmrNsznTU/62nkWXQcVGopsT+KyDmeXf555w0X/IK4b9xxt18zb6OIFohwHwgMpGE8ux7v9Twv9AoWQaVBqA1FBuysKmTGoWIydeXr9g7PMIdCXnoIl0UBsP7m93qKbU68+otnrCf3HgPN4YLhYLZI+Ncsx51GNN3uLXby9uaugZM14WMQR+WBalW/EnNuyHdtpOvf7XmlPmlyXZKnK+lKV9XpofMbLil5RNCN
 qmb1x6p6
 N7f27QOEc2yfUaR45lGvjGvHlpXaNIX4ZU8vsSDrfKihoTojix+UJcKQLxL5znaxiPZ1oVf3FN0hy/570MnD26XZUPXV+zApoorLWVZxFS0r4TMUtg7l7k582QFaxsw/2SkFNv99OItSLkb9UfBnP4LZvM3aglKKVk2KG8LNDKcVMGZh45keqt0swgVnNE0mwfYYaFM2xM0A/EOlIVG34SoA8m8urSZWmLoI+1/WS4RGUxBTe/L0xm9hHZUxMPMYYj9BCmc4zhflRmCiVbjAmoqTDNwFvBQaAqRPySQLKm24Qi4JaUvBXyf9zUHjXi5bzbC67tunI2v9jwbs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Host kernel updates in the cloud should not require draining the
machine: next to live migration to another host, replacing the kernel
in place while preserving selected workload state ("live update") is
what KHO/LUO were built for, and LUO's documentation names hypervisor
hosts as its primary use case. This series closes the gap for riscv64
and validates it with both upstream test runners.

KHO has been architecture independent since it was merged: the outgoing
kernel publishes the handover FDT and the scratch descriptor array in
the /chosen node of the DTB it builds for the incoming kernel, and the
incoming kernel collects both while scanning that node -- which is why
the arm64 integration (commit 274cdcb1c004) needed only three lines of
arch code.

Patch 1 is generic and comes first because enabling KHO on riscv64 needs
it: is_kho_boot() runs the handover FDT address through phys_to_virt()
only to return a boolean, and on riscv64 that is a BUG() before the
linear map offset exists. Neither caller dereferences the value, so
testing the physical address is enough.

RISC-V otherwise already walks the generic paths (load_extra_segments()
-> of_kexec_alloc_and_setup_fdt(), parse_dtb() ->
early_init_dt_scan()). The remaining blocker is ordering: setup_arch()
runs early_ioremap_setup() *after* parse_dtb(), so kho_populate()'s
early_memremap() of the handover FDT returns "offset + 0" -- NULL for a
page aligned address -- and the handover is dropped:

  KHO: setup: failed to memremap FDT (0x810bb000)
  KHO: disabling KHO revival

Patch 2 fixes that ordering, matching arm64/x86 and standing on its own
regardless of KHO. Patch 3 enables ARCH_SUPPORTS_KEXEC_HANDOVER as
"def_bool 64BIT && MMU" rather than arm64's "def_bool y":
ARCH_SUPPORTS_KEXEC_FILE is already 64BIT-only, and KEXEC_HANDOVER
selects CMA, which depends on MMU. Patches 4 and 5 teach the two
upstream vmtest runners about riscv64. LIVEUPDATE depends only on
KEXEC_HANDOVER, so patch 3 makes it selectable on riscv as well.

No DT schema changes are needed: linux,kho-fdt / linux,kho-scratch are
the properties arm64 introduced (commit 274cdcb1c004), and their
binding lives in the external dt-schema repository [1] rather than in
Documentation.

[1] https://github.com/devicetree-org/dt-schema/blob/main/dtschema/schemas/chosen.yaml

Changes since v1:
 - New patch 1: kho: Do not translate the handover FDT address in
   is_kho_boot(), a generic fix the riscv enablement needs.
 - Rebased onto linux-next-20261102 (2637bdec0535).

Test
----
Testing on linux-next-20261102 (2637bdec0535) with qemu-system-riscv64
(virt, -cpu max, TCG); method and logs under the --- of patches 1, 4
and 5:
  - patch 1, UEFI handover boot (edk2 on pflash over OpenSBI
    fw_dynamic, DEBUG_VIRTUAL=y): a BUG_ON in the incoming kernel on the
    first handover without the patch, 29 consecutive handovers with it
  - the same two kernels handing over from a device tree boot instead:
    both succeed, so what fails is the UEFI path and not the handover
  - kho vmtest: "ok 1 KHO succeeded"
  - liveupdate vmtest, all four suites passed one by one (simple,
    multi-session, 500 files, 2000 sessions)
  - riscv defconfig with and without CONFIG_KEXEC_HANDOVER both boot to
    userspace with no oops on the console; builds: riscv defconfig
    (+KHO), rv32_defconfig, arm64 defconfig (+KHO), x86_64 defconfig
    (+KHO)

Additionally, a workload-continuity test was run outside the selftests:
a counter process was snapshot with criu 4.3, the dump was carried
across the kexec in an LUO-preserved memfd, and criu restored it in the
new kernel. The process resumed with the same PID and open log file and
kept counting from where it was dumped (500006 -> 500007, no lost or
duplicated ticks).

Chen Pei (5):
  kho: Do not translate the handover FDT address in is_kho_boot()
  riscv: Call early_ioremap_setup() before parsing the DTB
  riscv: Add support for kexec handover (KHO)
  selftests: kho: Add riscv support
  selftests: liveupdate: Add riscv support

 arch/riscv/Kconfig                                | 3 +++
 arch/riscv/kernel/setup.c                         | 2 +-
 kernel/liveupdate/kexec_handover.c                | 2 +-
 tools/testing/selftests/kho/riscv.conf            | 9 +++++++++
 tools/testing/selftests/kho/vmtest.sh             | 3 ++-
 tools/testing/selftests/liveupdate/config.riscv64 | 3 +++
 tools/testing/selftests/liveupdate/run-vmtests.sh | 2 +-
 tools/testing/selftests/liveupdate/vmtest.sh      | 8 +++++++-
 8 files changed, 27 insertions(+), 5 deletions(-)
 create mode 100644 tools/testing/selftests/kho/riscv.conf
 create mode 100644 tools/testing/selftests/liveupdate/config.riscv64


base-commit: 2637bdec0535a2044cd830eba9a79363651d9043
-- 
2.50.1


