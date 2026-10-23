Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81AEB606A329
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 11:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=e8OBsHNb
Received: by kanga.kvack.org (Postfix)
	id A4F076B0B3A; Fri, 23 Oct 2026 07:16:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FFEE6B0B3C; Fri, 23 Oct 2026 07:16:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914C86B0B3D; Fri, 23 Oct 2026 07:16:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 687876B0B3A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 07:16:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA04480393
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:16:28 +0000 (UTC)
X-FDA: 85353637656.15.6B13F64
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf26.hostedemail.com (Postfix) with ESMTP id 888F3140006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:16:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=e8OBsHNb;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792754187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=imLoQJ3Y32KZZxL6AOPIQXTmbB11pGW4JBEfVopbcl4=;
	b=cnzdoJg9n18/63lv8Ags+HrC3olS/k3FBjZiSOaAtrnjn+/TNTEnrJVbVXxr5NcQqhuRxj
	Pu6InULL4GkQEdo2mTDKIQoc1TWEdYNWccpDUloEQ7QWzPdZoXWALLd3ccbPLJlz3D0/w0
	2fjjCLv9o4yYEpJ2mfNW/TQS3hJWvPg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=e8OBsHNb;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf26.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792754187;
	b=XJRgccizOBZIJp0o7AD0xDInuVAVe11NCUXQ3l9R9oNjfV1Hpb/GhLF/aI9gufxxgAGDZY
	NLa5cKj9NP/fap/vgORFfLKuq8XbikHgeSz51Xj7jt6WYhlNBrhov3UBPps5ABZF3ux09s
	bHIPzrmxY83vYiWvSWUTWsn+ncO0tc0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792754182; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=imLoQJ3Y32KZZxL6AOPIQXTmbB11pGW4JBEfVopbcl4=;
	b=e8OBsHNbKiJC5byTTl9dZa8vLWetF6RxjqRTD2/KtBBPtrCy4k74/G0bHKBN7aEguv3GNwVi90HK3arOf/8JfvGlxyTHQCPAr+kEs2/nwRk0ggUiuSGUdf+DHjIJ7smjSTo0iqdjHQDLbb6Ys6UHE/cIoAqzr058+ve+W7ii5ps=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XDM1n3D_1792754172;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XDM1n3D_1792754172 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Oct 2026 19:16:21 +0800
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
Subject: [PATCH 0/4] riscv: Enable kexec handover and live update
Date: Fri, 23 Oct 2026 19:16:08 +0800
Message-ID: <20261023111612.2134-1-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 888F3140006
X-Stat-Signature: ur7zkxnmmaun9uqi8m7d6gdgsqxgwdk4
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792754185-543789
X-HE-Meta: U2FsdGVkX1+y0T00rploYjgKASYsH6FrBRUqsS5DPo+td+Ppxl3egQ78X2sBTeY7v71/gskXPYzQkmVvjxZ66HtxAjvba9AKYMDGjtu3xvTLDggu0Sece6hZ7B/u55omIdr0bsbQDv8TIGVfXdnXHEyQ6VIpK8EhkCfY3ZsstD4+L0We2753g0flt7sZWqmJBFKvS4u/CRl6jb5UPHj+NZRtAXB4d4VMrYVEaZJmtyWypLk8ZDVKR0jD+uSS6C3idZSrNgLf91XKPgOrrRpqsKQOVbdSYfWweb/+5SQZtLV4W4cq98sIei1R68dEhpMs9xzDVpqImOsBN/26eEtbEjpAkeItPPiYBQM3degBFQkjtnrnysHU5FHqGwDmv2d8a97oJhzFMDObQEDMx0oJDJzr0lwhAIKIig0seq+oSXUv0Cc4dUxQiDaHjg480yxex0PgQbXAnqlz7y2bFqT7HiSjH0EJCGRNAyyWAxW0NlrowJ8Pxv68vD/kMWjhYTihqrtw8OsIEefRRJpiDXrikcPmpVDgUpm8BEUCNRRygtPgL17QhKka+ShTpYs4ZWxbvOK0MVxVUs3k6rawwLyILYhKi2FpcasL2yM8zYkXyXYsj2ZxT3bweeUiEVnyGu8JS0tdY81q0/ap4Y78E/jwCgdrHzeZjdM2Jk/+r1A0YRd6LYr32RnrJkMB+fsVe0kmrA9gvBKQ0cBfgETrbRgQcbFwxdlqYYeRtcgOzQHgQjcbM1BgamIKI7buQE+8h+tHO683ckj5u7nD4YFPW+IoPIk3yEhRNMqC+8LxyOcaUwat6/gIwrRZ2fiIyt/o34b0Fwph5L/txAe0OvkLojZQ7xcmdGl4H/pOsVQpKQejGdUUfYh49Xqqa0k8wwlB5Q6L4X6+4RSmnBnAJClkVKTIRbgq8vzOUN+kKenMWnLZwzDU+Z4zReSxPuCWD/qk/NAd6AQM0VN5ee6usY8E+rm
 0Qn1KFiJ
 Kp/L5AIgU2GzJliKWEATeJezEBteihxnhAP6T2wpUelk307mbdejlBy6dpYyhAXzIo5eCc+Btc5mwAVGk25O+us0c7UkUczI/xiUzUu6LwkB3mzVnRty8xk+RDEfz7Fgl64njdLrcFSFSCdnY34u+cSBzj92XBC9NBK5yxaWBeMGDhPcKQpBx5sPcybr7pg+RGWspD0xIAlWWbpvXgbJTmk7Xl9Ph/31hDeKj5FQFYS7+lbSV4Bj5y80RgJzNmZvXz9GVh2zg01J3Ij5AO7k6eAMaWU9pjSB2i0GhOPm/PI/vKVDReoY9gpzIELmvS40WDGvtWAdRcUbOkMI=
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

RISC-V already walks those same generic paths (load_extra_segments() ->
of_kexec_alloc_and_setup_fdt(), parse_dtb() -> early_init_dt_scan()).
The one real blocker is ordering: setup_arch() runs early_ioremap_setup()
*after* parse_dtb(), so kho_populate()'s early_memremap() of the handover
FDT returns "offset + 0" -- NULL for a page aligned address -- and the
handover is dropped:

  KHO: setup: failed to memremap FDT (0x810bb000)
  KHO: disabling KHO revival

Patch 1 fixes that ordering, matching arm64/x86 and standing on its own
regardless of KHO. Patch 2 enables ARCH_SUPPORTS_KEXEC_HANDOVER as
"def_bool 64BIT && MMU" rather than arm64's "def_bool y":
ARCH_SUPPORTS_KEXEC_FILE is already 64BIT-only, and KEXEC_HANDOVER
selects CMA, which depends on MMU. Patches 3 and 4 teach the two
upstream vmtest runners about riscv64. LIVEUPDATE depends only on
KEXEC_HANDOVER, so patch 2 makes it selectable on riscv as well.

No DT schema changes are needed: linux,kho-fdt / linux,kho-scratch are
the properties arm64 introduced (commit 274cdcb1c004), and their
binding lives in the external dt-schema repository [1] rather than in
Documentation.

[1] https://github.com/devicetree-org/dt-schema/blob/main/dtschema/schemas/chosen.yaml

Test
----
Testing on qemu-system-riscv64 (virt, -cpu max, TCG); method and logs
under the --- of patches 3 and 4:
  - kho vmtest: "ok 1 KHO succeeded"
  - liveupdate vmtest, all four suites PASSED (simple, multi-session,
    500 files, 2000 sessions)
  - riscv defconfig with and without CONFIG_KEXEC_HANDOVER both boot to
    userspace unchanged; builds: riscv defconfig (+KHO), rv32_defconfig,
    arm64, x86_64

Additionally, a workload-continuity test was run on the same setup,
outside the selftests: a counter process was snapshot with criu 4.3,
the dump was carried across the kexec in an LUO-preserved memfd, and
criu restored it in the new kernel. The process resumed with the same
PID and open log file and kept counting from where it was dumped
(500006 -> 500007, no lost or duplicated ticks).

Chen Pei (4):
  riscv: Call early_ioremap_setup() before parsing the DTB
  riscv: Add support for kexec handover (KHO)
  selftests: kho: Add riscv support
  selftests: liveupdate: Add riscv support

 arch/riscv/Kconfig                                | 3 +++
 arch/riscv/kernel/setup.c                         | 2 +-
 tools/testing/selftests/kho/riscv.conf            | 9 +++++++++
 tools/testing/selftests/kho/vmtest.sh             | 3 ++-
 tools/testing/selftests/liveupdate/config.riscv64 | 3 +++
 tools/testing/selftests/liveupdate/run-vmtests.sh | 2 +-
 tools/testing/selftests/liveupdate/vmtest.sh      | 8 +++++++-
 7 files changed, 26 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/kho/riscv.conf
 create mode 100644 tools/testing/selftests/liveupdate/config.riscv64

-- 
2.50.1


