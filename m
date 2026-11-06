Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EE8E606A337
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=qeJpSyEC
Received: by kanga.kvack.org (Postfix)
	id BAA556B05B9; Fri,  6 Nov 2026 02:15:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5AD16B05BD; Fri,  6 Nov 2026 02:15:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A99046B05BE; Fri,  6 Nov 2026 02:15:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85F3D6B05B9
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:15:11 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 00F821C4798
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:15:10 +0000 (UTC)
X-FDA: 85403832822.05.331D71B
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3AE461A0008
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:15:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qeJpSyEC;
	spf=pass (imf19.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793949309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Bi1Umej3UF4Ax9j2KGl5zOTvpdxOlN8avyZ39eWeMGs=;
	b=mJbn1mC4WosPcb+8FU1zqde2Q398jqpCdd3BfDCx3oA5e2RyDoHjtUQCVqHt5Y7TQgz3VH
	zpfiVi2U+50pXdCGEipAVxMEUdJ/TXRT7WyvYlmYtmvj/OvYNuvchxbd3OlMldQ0H9JIxv
	ZPXymuB9R++TKKM6G/OG4pdnkc+hf50=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793949309;
	b=mX1279rYVzAOBrkcQAqrymWo+M1CGUbKhmx1m7RJfaNVs+9cgupAccTYvsxo8dc3/4Kg5l
	3kIX+CZzPlCY6s0p76lSixIPNtJ+l1V3owF335vcO6eXiw6g0b4wMkA1/xczA7chst5zkh
	UTMqPk0TxloopE/OmITBMydVBdBt5xc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=qeJpSyEC;
	spf=pass (imf19.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793949304; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Bi1Umej3UF4Ax9j2KGl5zOTvpdxOlN8avyZ39eWeMGs=;
	b=qeJpSyEC0rtOQjFs4B0uPLRSJ/qVYJjXe0u60dN4ksjCnPEzgErkz3gjxoeACsVv0vTDBhIKTOXJiZ0AetMWLeaD3BbNCS1EInfjJui/scP7BfB8DPu6kTHOBSjuJNy7WZgYT8Ut9jNseWMu0cBEIn5y5LxZtuqR+d7nTrvlmWU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XEAtjKg_1793949299;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XEAtjKg_1793949299 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 15:15:03 +0800
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
Subject: [PATCH v3 0/4] riscv: Enable kexec handover and live update
Date: Fri,  6 Nov 2026 15:14:55 +0800
Message-ID: <20261106071459.2003-1-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ipgpsw9armthuqogr3puzn4u5r7ipuzd
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3AE461A0008
X-Rspam-User: 
X-HE-Tag: 1793949307-856942
X-HE-Meta: U2FsdGVkX1/g8NFIlhO67e2LgLuGNT305Cc883xBbP6lTydwPXb+ikU7wOHiaosapdxsy8/XWw9chDEQvwIMcMW1w+fODlji466KhTMS/ncBH9mAGuDCyAQKzYUUOIGnkbRp/U1ZT+gkPT4tHS4mAnnhY5PSbFGpYAz4zuCR/6NAS/eWLsXxbRXsizn/pQhMrth4WNcaF+9SNYgVWqwyMc6IjiA4Kz4+kdmplcRGXkqIQWmDa1f2LZgyf4U202gN6TtwCTqL0AphMYuieSeWSxh8HdOH+rfPfsAi58vALhcqb8tqLF4cEa7IdWHb289/+mE+9k7KNBLi5JrkgiRugTkVb7Z34GMKIM7x0YtwRdesIuBBXrazD4d+Z5XI+YXQTn4TBlBt7G4ASxCGX84ata5l17uNlbJEe9H7BKi8/1H2Iz0ZEfI12EGNVD61Ndmh+QcscwnsY8qrnl62svVKjjhk34O3WIJ8FBKHkArhix+AR8eiXU6J+miCrajDiL+VKM7iEsxagOY7tE5ZAQpMvhrqeZThBCouTHPiKIyUTzZXN9LNBtdbP+Thue85gsj4dkVb3FvLwEFwLER1jF9FfJNzxIRDu3olQ/M7aq9f+RdyPxlEGd1l7Ld7jnycifv+PcgiJBw3lc7Bz85K7RC5IX+whnTEECfaicMyaOfcdVCTGmMIgczZzHKwFZp2WFO1RLrDw9fCxef7T/5mkEqzJOlo5hNZMhtc6PliA09pI0+VyIstZXEX9BjugvVAKcXWXghkG4fiq0DDPFDMP3Uk/2UlQ4IwL8SV4otyeiNDyKcm89PgfmkG8RuUgoys3TQzjD9KPsYqC7E6JEI8ADgjruI4DZ3D+o89q2ETtx4euVQP6igLdqQM36RUcLR00MVUubbw1UOJHpHXW0yMTUcbv+Y5s/n380/njtb7AJ0JbaUmgJ1Q+mNfoNTug5L9x5cZl+LnOjI3U3YD1aB4Gzd
 dh13fGtH
 chfbifb7M5lHR0aS95UF19dz0BEuklWRBK8Puosouc5qKXVCkgBze7nv3Z7RLszXFCK0EVStRQKYiN1MG16AqJfmPa0LLG/tD+nOip+VIzEzQXt9Jv0e9fPdfosj4/WPw2B2ds/ocZ7ucqeFswMy/Dq/8cs7/KY+FdWuB+WlqDhagfp6QLE8UUw0XCwirlWH8tz8j7O8qoL/NZxyLiB81Qce1iQtS1bcZsjhUKZlgXXHO4lmdxaMndxZLtplmACQPmf8PjIFcLKsyx6R9PAn2TY4MAuO2Ra/p009yYv/CoJ5YC0ZG4DPrjtJm4XzTioeFDc9dFnCkuigtG2e/UFP6sjnp1KXox2YioMBPQZRdoFaIsN4x4rf1lzWnwg==
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
the handover is dropped. Patch 1 fixes that ordering, matching arm64 and
x86, and stands on its own regardless of KHO. Patch 2 enables
ARCH_SUPPORTS_KEXEC_HANDOVER as "def_bool 64BIT && MMU" rather than
arm64's "def_bool y": ARCH_SUPPORTS_KEXEC_FILE is already 64BIT only, and
KEXEC_HANDOVER selects CMA, which depends on MMU. LIVEUPDATE depends only
on KEXEC_HANDOVER, so patch 2 makes it selectable on riscv as well.
Patches 3 and 4 teach the two upstream vmtest runners about riscv64.

This series depends on Greg Thelen's fix to is_kho_boot() [1].

No DT schema changes are needed: linux,kho-fdt / linux,kho-bootmem are
the properties arm64 introduced (commit 274cdcb1c004), and their binding
lives in the external dt-schema repository [2] rather than in
Documentation.

[1] https://lore.kernel.org/all/20261023054518.3258350-1-gthelen@google.com
[2] https://github.com/devicetree-org/dt-schema/blob/main/dtschema/schemas/chosen.yaml

Changes since v2:
 - Dropped "kho: Do not translate the handover FDT address in
   is_kho_boot()", which Greg Thelen's [1] does as well.
 - Commit messages cut back to the reason for the change.
 - Rebased onto linux-next-20261105 (ddfe51b0a0f5).

Changes since v1:
 - New patch 1: kho: Do not translate the handover FDT address in
   is_kho_boot(), a generic fix the riscv enablement needs.
 - Rebased onto linux-next-20261102 (2637bdec0535).

Test
----
Testing on linux-next-20261105 (ddfe51b0a0f5) with qemu-system-riscv64
(virt, -cpu max, TCG); method and logs under the --- of patches 3 and 4:
  - kho vmtest: "ok 1 KHO succeeded", Totals pass:1 fail:0
  - liveupdate vmtest, all four suites passed one by one (simple,
    multi-session, 500 files, 2000 sessions)
  - riscv defconfig with and without CONFIG_KEXEC_HANDOVER both boot to
    userspace with no oops on the console; builds: riscv defconfig
    (+KHO), rv32_defconfig, arm64 defconfig (+KHO), x86_64 defconfig
    (+KHO)
  - UEFI handover boot (edk2 on pflash over OpenSBI fw_dynamic,
    DEBUG_VIRTUAL=y): with [1] applied, 32 consecutive handovers and no
    BUG; without it the first handover dies in
    linear_mapping_pa_to_va()

Additionally, a workload-continuity test was run outside the selftests:
a counter process was snapshot with criu 4.3, the dump was carried
across the kexec in an LUO-preserved memfd, and criu restored it in the
new kernel. The process resumed with the same PID and open log file and
kept counting from where it was dumped (500007 -> 500008, no lost or
duplicated ticks).


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


base-commit: ddfe51b0a0f5dc9e415cc2c8ad8db17532dd426b
-- 
2.50.1


