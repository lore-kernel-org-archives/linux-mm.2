Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 845B5606A336
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=RAeJpJy2
Received: by kanga.kvack.org (Postfix)
	id A4F9C6B05B1; Wed, 18 Nov 2026 04:16:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A27FE6B05B4; Wed, 18 Nov 2026 04:16:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93DEA6B05B5; Wed, 18 Nov 2026 04:16:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F42F6B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:16:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 72E7B1A0106
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:16:20 +0000 (UTC)
X-FDA: 85447683720.04.E04A93A
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2BDA540007
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:16:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RAeJpJy2;
	spf=pass (imf01.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794993378;
	b=ZANBcNPcLurerAhzRMS8xUvg96AYH/WKHCzFVWbBzpwEMRYGRch4+j9lMYQNFcoMoqOTm+
	LC0w0qhsBaFH7BJ3xhihlyGQk5zN56IxpEoPo+CMVi9lnBuGtFypuX4KXYsQFYdOqzhGXj
	4/xqcmpNBhMFW+6QYfFxnUUAyDHI/JE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=RAeJpJy2;
	spf=pass (imf01.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794993378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hGfK5Hi5QOdXQbsME0+GiG+Fz4TcL5XOwxtDG4CKWPw=;
	b=JbSyuA4gssDi0L+JUQx6TX8MOqmz05S/r7yTCrix0kcHFs9KTKj6+7RaAVxzbvrxrO8c2p
	SNbxViOG4WCJusHpNtejDFjx0zCxb7ugHMJEP641ecNnxY9BgkczwfzDyeHSZt24eNUlbA
	UjVRTzLKJ/jQalQqPEQGiZ8NCzyuSY0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794993373; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=hGfK5Hi5QOdXQbsME0+GiG+Fz4TcL5XOwxtDG4CKWPw=;
	b=RAeJpJy2cCk/Nmv2pzPjctOI9rCOtGGLL2S9sdNtJq1o99n6kGgApjE5kNIW/mjEkWeWhvtXKCwhNCututH5F4X7nnYUcCtES3mO+dsGJhCRDrIrmqWiFRAjyc4dEhaD+LaZ2NjFJ0ulHxTfSut4mo/nbKP2KUD0FaPhrFIm190=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XF0HHZg_1794993365;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XF0HHZg_1794993365 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Nov 2026 17:16:11 +0800
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
Subject: [PATCH v4 0/4] riscv: Enable kexec handover and live update
Date: Wed, 18 Nov 2026 17:15:59 +0800
Message-ID: <20261118091603.979-1-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2BDA540007
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: wqb38hmydps3ayuhxkmbncswkx471ch9
X-Rspam-User: 
X-HE-Tag: 1794993376-869165
X-HE-Meta: U2FsdGVkX1+lRapMBql9uyBF4eq+DmFmO9UtzkqBIhpQ+PtnKy6+ogQ7ZZtJpk1Qn9bOCKemWMBAW4PjsPPHaEa0iergKX27pgLHArzDG/mbI6oIk7kbaN7LoOSPsByHYXlJWM/RW/e5ySC5CzV0G/T1HPyuxVt454LAbmb7XqVuJ5b0qCp1YanmFwY5+ws7rkZ0Udw2lMpjGgoFLj3u86D9AdOrPSqUtEOsOqP/cA4bfqqLva0iD7onK29MPgc8OoeKHKJY1JcGUIUTMLeTsV4qdlm9MteqHAAixqOsqi/8jHho+0+Ae6Bg38DdGbWVvuILSHjJXmiKi7dqw2NFniDXnlDelEzQwfdclAFd8rb7ypyfG6Sn7qfe+ZsjqxnvtbAQnMRc7iNnmcu/akOKmT8ngCPNTt0cwtKwfHx+7TsFBwtSKoAKzPhaROOfAstcgKLoJG04vBtTdcRfK2vkW6WxQzYr1X/RqBWDsiCzqwMTMxWeArYH17i7N5aDp0TWuz6UvK+HPOdx/TeJ68tMj+/aN8a0YEtHaa+lFxo7GBVLkNgpjPrWz23Q8raY+27KbDMxj2rWfJ3hboxI29oocJ87zFsngCiZakbh4Q3TmyKJYAhHyjEwMujOm7noBEnhLqiaxrP22o+MV4Oi27/ke7//LZAMaOPT47SA51gDreXjzp7UT4U7EFUpFWjwmzK1V+Hvnw8CjN8g3/l3iIoHuVgW3JbA6FZdyrv76HiHYLcwQ43T7PllnlhSEVCC5O6V705hPHWj+5TrT8SxrezCcl7LJ9yMepERlbz5DYsctL+MZ6mP3jI8PiTX/lORGc1mP/t5yLU/5uDY0E9MvVCageid3iZ9LZHbEcO+CI3hCvjWZPp5XBfEVuskn7mflaJmajaOQMbsQh7bblADn9R5ntvs7O+RLdHwm1BwAliiea9EDL06NQ9c5cqhzWlNoaYBOrwNL5EDFveoVaU2LCf
 NZfuPdX9
 CWpov2ozfE4mPVanIxdGTcBiJYVGiLgP347xmU/wYGERcnpwOHLiwJYK+G6p1bdEz3+13jnegJRlGe2lAxY8BGRIhNcVxnu5I+DfuX/HaZKfApYtFtzL1K5ws6dLu2Ebr3TfQdgk3TTC+CeBLx+KkcDeWy9v4SCeLTLBkQxc7Ef0Z8+Y2j61OY8egCnPIY7YOvpO0SxHvDK2Selr4aD8OO3hsJQgisYH3gIl1qzjnruBXzQHNzTo245nSTOASDjM3BBqCfTRvMO72zRh096F0JTPoO0rrkp/X3itVFWnGu6XKBeZx/zYO8BhTDM7iijLGa2x8oClLAIVIDHllUW19TWwje1Wg3HMCyBvKAb+gpCA1iqdq46xabmzVqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Host kernel updates in the cloud should not require draining the
machine: next to live migration to another host, replacing the kernel in
place while preserving selected workload state ("live update") is what
KHO/LUO were built for, and LUO's documentation names hypervisor hosts as
its primary use case. This series closes the gap for riscv64 and
validates it with both upstream test runners.

KHO has been architecture independent since it was merged: the outgoing
kernel publishes the handover FDT and the bootmem descriptor array in
the /chosen node of the DTB it builds for the incoming kernel, and the
incoming kernel collects both while scanning that node -- which is why
the arm64 integration (commit 274cdcb1c004) needed only three lines of
arch code.

RISC-V already walks those generic paths. The blocker is ordering:
setup_arch() runs early_ioremap_setup() after parse_dtb(), so the early
mapping kho_populate() needs for the handover FDT is not set up yet and
the handover is dropped. Patch 1 fixes that ordering and stands on its
own regardless of KHO. Patch 2 enables ARCH_SUPPORTS_KEXEC_HANDOVER as
"def_bool 64BIT && MMU" rather than arm64's "def_bool y":
ARCH_SUPPORTS_KEXEC_FILE is already 64BIT only, and KEXEC_HANDOVER
selects CMA, which depends on MMU. LIVEUPDATE depends only on
KEXEC_HANDOVER, so patch 2 makes it selectable on riscv as well.
Patches 3 and 4 teach the two upstream vmtest runners about riscv64.

This base already contains Greg Thelen's is_kho_boot() fix [1] and Mike
Rapoport's bootmem sizing rework [2], so the series carries no generic
KHO changes and neither patch is needed on top.

No DT schema changes are needed: linux,kho-fdt / linux,kho-bootmem are
the properties arm64 introduced (commit 274cdcb1c004), and their binding
lives in the external dt-schema repository [3] rather than in
Documentation.

[1] https://lore.kernel.org/all/20261023054518.3258350-1-gthelen@google.com/
[2] https://lore.kernel.org/kexec/20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org/
[3] https://github.com/devicetree-org/dt-schema/blob/main/dtschema/schemas/chosen.yaml

Changes since v3:
 - Dropped the arm64/x86 comparison from patch 1 and this cover letter.
 - Renamed patch 2 to "riscv: Add support for KHO" and spelled out the
   acronym on first use in its body.
 - Dropped the dependency note; both generic fixes are in this base.
 - Collected Reviewed-by and Acked-by tags.
 - Rebased onto linux-next-20261117 (7cfbf79c66c6).

Changes since v2:
 - Dropped "kho: Do not translate the handover FDT address in
   is_kho_boot()", which Greg Thelen's fix does as well.
 - Commit messages cut back to the reason for the change.
 - Rebased onto linux-next-20261105 (ddfe51b0a0f5).

Changes since v1:
 - New patch 1: kho: Do not translate the handover FDT address in
   is_kho_boot(), a generic fix the riscv enablement needs.
 - Rebased onto linux-next-20261102 (2637bdec0535).

Test
----
Testing on linux-next-20261117 (7cfbf79c66c6) with qemu-system-riscv64
(virt, -cpu max, TCG); method and logs under the --- of patches 3 and 4:
  - kho vmtest: "ok 1 KHO succeeded", Totals pass:1 fail:0
  - liveupdate vmtest, all four suites passed one by one (simple,
    multi-session, 500 files, 2000 sessions)
  - riscv defconfig with and without CONFIG_KEXEC_HANDOVER both boot to
    userspace with no oops on the console; builds: riscv defconfig
    (+KHO), rv32_defconfig, arm64 defconfig (+KHO), x86_64 defconfig
    (+KHO)
  - UEFI handover boot (edk2 on pflash over OpenSBI fw_dynamic,
    DEBUG_VIRTUAL=y): 28 consecutive handovers and no BUG

Additionally, a workload-continuity test was run outside the selftests:
a counter process was snapshot with criu 4.3, the dump was carried
across the kexec in an LUO-preserved memfd, and criu restored it in the
new kernel. The process resumed with the same PID and open log file and
kept counting from where it was dumped (500006 -> 500007, no lost or
duplicated ticks).


Chen Pei (4):
  riscv: Call early_ioremap_setup() before parsing the DTB
  riscv: Add support for KHO
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


base-commit: 7cfbf79c66c63e807ea452abf0546e6f6d6833a6
-- 
2.50.1


