Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F4C8C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 11:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C2AF6B0295; Thu, 13 Aug 2026 07:45:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D2F6B0297; Thu, 13 Aug 2026 07:45:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EEC76B0298; Thu, 13 Aug 2026 07:45:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C344D6B0295
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:45:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FA6B8011E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:45:39 +0000 (UTC)
X-FDA: 85096066398.04.AFB5DB3
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5576A1C000D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:45:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="Z8/PfId0";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786621537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=7REaBd+iVbcbYZ8mO59hJsQfrciHsxUm/5TkdSNt6Fw=;
	b=sGZ+qqysHPdwYkzRb+4u6py7tygHdOGIgFEzRDDGVvqsmnxTd4t/Ojnajz8bkHeHIU5wOp
	yc6liZdYAYmSdf7XZ8XHYLfisQCAms2a+Zd015xiemSk0GBOqn7e0Lt14Drn77l6DN3qNx
	Pl0K1bIkZyOlR2Td6RiJJXxcSUj49j0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="Z8/PfId0";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf21.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786621537;
	b=Ctc2+xL0LtZng9qxVQU+oKE9U8Ko9K7CTH6lHzEljmNQdZRi1jzt4AHFZoEo1oAUecgSDN
	/zoG7FNGv9u9iKTxzjPwTqifacN5+Jowv+a2p+neZ/peiTEYljMmYFFQq22xD1hiM+gV2a
	pBgFroKI3EbrAHrt7oiNupsjAFt3fuM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=7REaBd+iVbcbYZ8mO59hJsQfrciHsxUm/5TkdSNt6Fw=; b=Z8/PfId0KRD/6PruLtn0hbt1Ap
	obPkBXQHtb1bnbVP0JNVMP5slSCFuzZzFpDfeivIYvH+DcfafESx9GtrIE0MgFQIkprmD4VeAzWhO
	RyTAqU5qF6rfy/2uvrTZgn3spCF+9WwjmlWRDUu4/HwB3YIgvrZQIYu68jYG2KnioT63EMEhJbN1Q
	Gt4pm+DLxk/CT2KysGYOtMSDvyD1Wov9FtfWvqBtrCUMNw/FjesvZeTWXSfpmDL5ReqdZseexIMdx
	+s1MNza8C/tGhpftYjfp0FKMTUUk1/00q1484EAoYk3DK1wVWf/oYP9EOWgMUiUrT4X7F1lTTGXf+
	p89Fhd7w==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wuTsF-0055R1-0T;
	Thu, 13 Aug 2026 11:45:28 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 13 Aug 2026 04:45:15 -0700
Subject: [PATCH v3] tools/mm: add hwpoison-panic tool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-memory_failure_rewrite_test-v3-1-f9fb6542cbff@debian.org>
X-B4-Tracking: v=1; b=H4sIAEqufWoC/33NywqCQBSA4VcZztqJudh4WfUeETLpUQ+UxhmzR
 Hz3UIJo4/ZffP8MAZkwQC5mYBwpUN9BLmwkoGx916CkCnIBRhmnEpPKO957nora0+3JWDC+mAY
 sBgyDTLxVmXdKe4cQCXgw1vTe9PMlEtBSGHqettmo1/p1rd51Ry21dN6npYvt0WX2VOGVfHfou
 YEVHs0PS5Xdx4zUEitlVImx0Sb7w5Zl+QCowEScFAEAAA==
X-Change-ID: 20260728-memory_failure_rewrite_test-7a309a601a6e
To: Andrew Morton <akpm@linux-foundation.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, david@kernel.org
Cc: SJ Park <sj@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-riscv@lists.infradead.org, sj@kernel.org, 
 kernel-team@meta.com, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=14007; i=leitao@debian.org;
 h=from:subject:message-id; bh=pLS8XmENf2qhypCRvhzat005WzlSNjjOjK9Li1LTCXU=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqfa5Sa8cUGHANYJtF92SpLn14AsyPzrdntQM/P
 gGEyITuPeWJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCan2uUgAKCRA1o5Of/Hh3
 beizD/sHarVxpPPdOkyh7d4ew+xd9atouwRMoR0ic2yZG6nqWQWz3tBWwHDihI7KIb3ToQFsinL
 fgtY/76Mq563pNlkMPtXJwQRSoQrbhy/FGJSFNnMDHCkJEuQsZmHBHeb7kz4e1ohA2rsnOGzLuJ
 uFl3InTaAtpLcrfnmTFHD/rywIpNFnuGjYNVkYf3t6JV1K1WRUc+8dBJ6BmEy5VCPtHsDcdUnMj
 gh/2/UC2o3JZSTZsqqAnRqgKGooVATB14ow3aSBFGqp+to54eLJbY2d1KceM3GSVFBZgp4nSGWT
 iUOFbcgWXrf+sBuH+uuXbd0qrpY731tErghnGC1M0DJ2/jYGiQtEMaR0TSRr69kvgvp3NV8/osP
 q0P6RU//1sxivgsktQhVQUpG2Cx/IrGx1Zx3yQmU7stEZxLLWT5MdBBgnm+mS8hiR2mM1typFEz
 gphNPgndfu49lZ6gP7Gc7NyYeRoJ6sijdRf4UdNBSQThiFIGsfid40MvoyGjwXak7PdF2ZaCUAN
 bkL6HpCHHDEIsgTFIpFpW0OkwKN45DZBjE0VB03/CLaJI3cOcoxXmO9nfBFepM7XYglgH8b9t/J
 388MBTxyBuoQTPRrnQxLZgk8Si8zdhg+TnWJBwRWxmACyD5m4yAVljZ5DfqXJCeTcPK94owz4UX
 reoMbZNlyEgr0wA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 5576A1C000D
X-Stat-Signature: xnhcjmkn5ghgfu1b3qoibxe9yggyrqn4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786621537-742931
X-HE-Meta: U2FsdGVkX1+VECbs4AGuvQSgl2+NZUlzIT70y8YYQ92TL34tIgfjxc22G/uBx6kOlY5SlLLBgGfwnNfmXVF2a1FFoUQrHuSmU+l0vj7NAKuzbGpdudSMcMO8DRWfrtEbqrlbHfQRpGD9nXu460Jxyhyiy0EPaTJ7igLgnmvktSD6suqWK2dxcVkP8o8I5Df2X6uJljg0K3eSopoulI/064XxVvZQxsrYr32RSxPrQisqMNLAQ2ebthDAPHxqASfbEwyMVogWfgsiVZOJss/JEgaNX2oQY+D8MYFkDMPMqP8si+2BAPq5CuiFb7yoxK6MfSiPtL4KVjSuoP9SiJlV6BqOVmHCLXK3Zrwad4W40LTXmMs+2o5acol8JII03wdrZ2+emhqE1/2n7u8uMgctu0erqOw8gxjKJYnwbZby9Ub7VC1WVwqWJgYKL4g7tU5qcjPBi7YS23cFwiCQ8Uku/NV7GtXN5tjn0vDbyV16QduLE1yjhEuK8up6SigMLKh5mQ/QJ0F+VDUtdF+T4fX6+wCGOjuWK77+bQt0lakQ3rz77ivCd+2BFrNQ0wToyPM0Di4/yHsb82JrhdPzqTp9WPk00IS1DyA9ZYi/NmgLUEHa+kM6GbVQzcFyDHKoJadUFDW8fTrFNO6UmaE9wHHc0BbSEHgmNfLkreJMpUwJhEsKa7nI1Tbbz03onFrgxGHWllWG3pz43oc5GQ8ysrz8Pi9IaaNHly6pdryi2BRThrW1PwFj3bgnPHbjxQ+zz8uosX1Aoc0Bny7g3ErECSWFRvgPhWK+QY7mqKqEufu4Ocouxz4nwsDT4H1v7vrDSOCGq8zU8CuHY1TJ0aTN1b/KtuJ0BqB20Ib0WNt0edaghOVjfH95BQhl6HHGnElUM9pyb62X77kbIsX+znZmEDEOhPlgwjkrRNXWfLJjeb2AtsYllOM5WinXQ56Jx2Dzjj0PXSWvLk6k7mcQTrv9jI7
 TTIe9VgT
 Jt3maRq8oGDgkfRodWm+/mf5pkKbLYqf5x/H4qTr4InJICuysMwYNn5h9MfA9F1nG+AKpXz/VxCJe2dZQCqlixBnzbLCN3nRHMqlZ3oJH9mSOCbT9jbwStCrPUBwPI+pMfmddE93PUgVI0MMPyLMJsB6rtIBS2oPXPWPtcqOee7F7TsjHe9HMdgD2cIjyFtXsfMr5RABJtrneajVAoair4qOAGkrp46oEhDkWHBwWoS4VFtXTIliNf/8iXTgC7VeaJ/RHqlnkBKok5nSzjh/7F7sBogjZ2mH0IbE6xj89RjR4YIq2h1LTJFjEmjXg4Z53vwBfKJ7kAk7L1rcALU7jGe8k5+pxuOiTQwntz1FPw4/aFaIqk9LR+KvYeIyVc9wWs2BTPPZf4A2Of7a71Ph7BV3bICAOSmkWRomfG8mYN55hLAlDLKt26i2S+D8TweSFMEWluaCPWKySw59KJDAy4w5jbicvNPSOVgXymnL5HflvPQlHLPGOUgJKE/hnGoocD4EPfNdbxRAfaDkjtJz0d59+3b6plMQph8GucJelJV7chaahlnb8t2tq5KKWY7yVOPp2cTITMCAe1+OX/1PQ8Lbv2eXKHwmlFkS0/BpyeY7m9cb0OzGqb6veZMLMwNj9m6QbITtCqZCph+QQcIgJbNvGvUu71GWQZE7l6RDOhXZKDqOSG/BaeTNy+7wWclnco/lJPGAjarCziEq/pxMoDWGsyon79iHQyGGRV/cVeras/BEDr3GWVGtC2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a tool that enables the vm.panic_on_unrecoverable_memory_failure
sysctl, picks a kernel-owned PFN and writes its physical address to
hard_offline_page.  Three page kinds are selectable with -k: rodata
(default), slab or pgtable. In all cases the host should panic.

Example:

        # ./hwpoison-panic -k slab --yes-panic-my-kernel
        injecting hwpoison at phys 0x100032000 (pfn 0x100032, kind=slab)
        expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'

In dmesg, you will see:

        Memory failure: 0x100032: unhandlable page.
        Memory failure: 0x100032: recovery action for reserved kernel page: Ignored
        Kernel panic - not syncing: Memory failure: 0x100032: unrecoverable page

This lives in tools/mm rather than selftests/mm because every successful
run crashes the machine, which is not something to run from CI.

The --yes-panic-my-kernel argument is required so an accidental
invocation does not take the box down.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
Changes in v3:
- s/(16UL << 20)/SZ_16M/ and including ../../include/linux/sizes.h
- s/MEMORY_HOTPLUG/MEMORY_FAILURE/
- Link to v2: https://patch.msgid.link/20260803-memory_failure_rewrite_test-v2-1-ed020ce42129@debian.org

Changes in v2:
- Reword the file header, the tool triggers a panic rather than
  confirming one (SJ Park)
- Rename -f to --yes-panic-my-kernel and say in usage() what it costs
  (SJ Park)
- Call check_prereqs() before getpagesize() (SJ Park)
- Use 64-bit types for physical addresses and PFNs.  On a 32-bit build
  the old long/unsigned long pair truncated addresses above 4G, and the
  negative error sentinel was indistinguishable from a valid address at
  or above 2G
- Link to v1: https://patch.msgid.link/20260731-memory_failure_rewrite_test-v1-1-6aa8c6435693@debian.org

To: Andrew Morton <akpm@linux-foundation.org>
To: Miaohe Lin <linmiaohe@huawei.com>
To: Naoya Horiguchi <nao.horiguchi@gmail.com>
To: Paul Walmsley <pjw@kernel.org>
To: Palmer Dabbelt <palmer@dabbelt.com>
To: Albert Ou <aou@eecs.berkeley.edu>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-riscv@lists.infradead.org
---
 MAINTAINERS                              |   1 +
 tools/mm/.gitignore                      |   1 +
 tools/mm/Makefile                        |   2 +
 tools/mm/memory-failure/hwpoison-panic.c | 359 +++++++++++++++++++++++++++++++
 4 files changed, 363 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 56b337a064478..799c4883d5b0b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12094,6 +12094,7 @@ F:	include/linux/memory-failure.h
 F:	include/trace/events/memory-failure.h
 F:	mm/hwpoison-inject.c
 F:	mm/memory-failure.c
+F:	tools/mm/memory-failure/
 F:	tools/testing/selftests/mm/memory-failure.c
 
 HYCON HY46XX TOUCHSCREEN SUPPORT
diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
index 1446a659e5408..b9b80d909db4a 100644
--- a/tools/mm/.gitignore
+++ b/tools/mm/.gitignore
@@ -3,3 +3,4 @@ slabinfo
 page-types
 page_owner_sort
 thp_swap_allocator_test
+memory-failure/hwpoison-panic
diff --git a/tools/mm/Makefile b/tools/mm/Makefile
index 858186a6eefdb..9f6de957a95a0 100644
--- a/tools/mm/Makefile
+++ b/tools/mm/Makefile
@@ -4,6 +4,7 @@
 include ../scripts/Makefile.include
 
 BUILD_TARGETS=page-types slabinfo page_owner_sort page_owner_filter thp_swap_allocator_test
+BUILD_TARGETS+=memory-failure/hwpoison-panic
 INSTALL_TARGETS = $(BUILD_TARGETS) thpmaps
 
 LIB_DIR = ../lib/api
@@ -24,6 +25,7 @@ $(LIBS):
 
 clean:
 	$(RM) page-types slabinfo page_owner_sort page_owner_filter thp_swap_allocator_test
+	$(RM) memory-failure/hwpoison-panic
 	make -C $(LIB_DIR) clean
 
 sbindir ?= /usr/sbin
diff --git a/tools/mm/memory-failure/hwpoison-panic.c b/tools/mm/memory-failure/hwpoison-panic.c
new file mode 100644
index 0000000000000..7772c5548adaf
--- /dev/null
+++ b/tools/mm/memory-failure/hwpoison-panic.c
@@ -0,0 +1,359 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * hwpoison-panic: trigger an intentional kernel panic by injecting a
+ * hwpoison error on a kernel-owned page, to check that
+ * vm.panic_on_unrecoverable_memory_failure fires.
+ *
+ * Three kinds of kernel-owned page can be targeted, selected with -k
+ * (default: rodata):
+ *
+ *   rodata  - a PG_reserved page in the kernel rodata range, from
+ *             /proc/iomem "Kernel rodata".  x86 and riscv only.
+ *   slab    - a slab page found via /proc/kpageflags (KPF_SLAB).
+ *   pgtable - a page-table page found via /proc/kpageflags (KPF_PGTABLE).
+ *
+ * slab and pgtable work everywhere; rodata needs an architecture that
+ * publishes the rodata resource in /proc/iomem.
+ *
+ * The slab and pgtable variants exercise memory_failure() -> get_any_page()
+ * on a non PG_reserved kernel-owned page, catching regressions where
+ * get_any_page() collapses such pages into a transient -EIO instead of
+ * -ENOTRECOVERABLE.
+ *
+ * A successful run crashes the kernel, so --yes-panic-my-kernel is required
+ * and the tool is meant for a disposable VM (e.g. virtme-ng) with the serial
+ * console captured.  The result is observed externally: the kernel panics with
+ *   "Memory failure: <pfn>: unrecoverable page"
+ * Returning at all means no panic fired, so every exit status is non-zero:
+ * either a failure, or an inconclusive run where the target PFN raced to
+ * another page type before injection.
+ *
+ * Author: Breno Leitao <leitao@debian.org>
+ */
+#define _GNU_SOURCE
+#define _FILE_OFFSET_BITS 64
+#include <fcntl.h>
+#include <getopt.h>
+#include <limits.h>
+#include <stdarg.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+
+#include "../../../include/uapi/linux/kernel-page-flags.h"
+#include "../../include/linux/sizes.h"
+#include <api/fs/fs.h>
+
+#define SYSCTL_PATH	"/proc/sys/vm/panic_on_unrecoverable_memory_failure"
+#define INJECT_PATH	"/sys/devices/system/memory/hard_offline_page"
+#define PROC_KPAGEFLAGS	"/proc/kpageflags"
+
+/* Not exported by the uapi header, see tools/mm/page-types.c. */
+#define KPF_RESERVED	32
+
+#define BIT(name)	(1ULL << KPF_##name)
+#define ARRAY_SIZE(x)	(sizeof(x) / sizeof((x)[0]))
+
+/* The kpageflags bit identifying each kernel-owned page kind we target. */
+static const struct page_kind {
+	const char *name;
+	uint64_t bit;
+} page_kinds[] = {
+	{ "rodata",  BIT(RESERVED) },
+	{ "slab",    BIT(SLAB)     },
+	{ "pgtable", BIT(PGTABLE)  },
+};
+
+static unsigned long page_size;
+
+static void fatal(const char *x, ...)
+{
+	va_list ap;
+
+	va_start(ap, x);
+	vfprintf(stderr, x, ap);
+	va_end(ap);
+	exit(EXIT_FAILURE);
+}
+
+static int kpageflags_read(int fd, uint64_t pfn, uint64_t *flags)
+{
+	ssize_t bytes;
+
+	bytes = pread(fd, flags, sizeof(*flags), (off_t)pfn * sizeof(*flags));
+
+	return bytes == sizeof(*flags) ? 0 : -1;
+}
+
+static int pick_rodata_phys_addr(uint64_t *phys_addr)
+{
+	unsigned long long start, end;
+	char line[256], label[64];
+	int ret = -1;
+	FILE *f;
+
+	f = fopen("/proc/iomem", "r");
+	if (!f)
+		return -1;
+
+	/* Sub-resources are indented: "  02500000-02ffffff : Kernel rodata" */
+	while (fgets(line, sizeof(line), f)) {
+		if (sscanf(line, " %llx-%llx : %63[^\n]", &start, &end,
+			   label) != 3)
+			continue;
+		if (strcmp(label, "Kernel rodata") || end <= start)
+			continue;
+		/* Page-align up and return the first byte of that page. */
+		*phys_addr = ((start + page_size - 1) / page_size) * page_size;
+		ret = 0;
+		break;
+	}
+
+	fclose(f);
+	return ret;
+}
+
+static int pick_kpageflags_phys_addr(uint64_t want, uint64_t *phys_addr)
+{
+	uint64_t pfn = SZ_16M / page_size;
+	uint64_t flags;
+	int ret = -1;
+	int fd;
+
+	fd = open(PROC_KPAGEFLAGS, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	for (; kpageflags_read(fd, pfn, &flags) == 0; pfn++) {
+		if ((flags & want) && !(flags & BIT(HWPOISON)) &&
+		    !(flags & BIT(NOPAGE)) && !(flags & BIT(COMPOUND_TAIL))) {
+			*phys_addr = pfn * page_size;
+			ret = 0;
+			break;
+		}
+	}
+
+	close(fd);
+	return ret;
+}
+
+static int read_sysctl(unsigned long *val)
+{
+	FILE *f = fopen(SYSCTL_PATH, "r");
+	int ret;
+
+	if (!f)
+		return -1;
+	ret = fscanf(f, "%lu", val) == 1 ? 0 : -1;
+	fclose(f);
+
+	return ret;
+}
+
+static int write_sysctl(unsigned long val)
+{
+	FILE *f = fopen(SYSCTL_PATH, "w");
+	int ret;
+
+	if (!f)
+		return -1;
+	ret = fprintf(f, "%lu", val) < 0 ? -1 : 0;
+	fclose(f);
+
+	return ret;
+}
+
+/* hard_offline_page() injects with MF_SW_SIMULATED, so unpoison is allowed. */
+static void unpoison_pfn(uint64_t pfn)
+{
+	char path[PATH_MAX], buf[32];
+	const char *debugfs;
+	int fd, len;
+
+	debugfs = debugfs__mount();
+	if (!debugfs)
+		return;
+
+	snprintf(path, sizeof(path), "%s/hwpoison/unpoison-pfn", debugfs);
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		return;
+
+	len = snprintf(buf, sizeof(buf), "0x%llx\n", (unsigned long long)pfn);
+	if (write(fd, buf, len) < 0)
+		perror("unpoison-pfn");
+	close(fd);
+}
+
+static const char *inject_hwpoison(const struct page_kind *kind,
+				   uint64_t phys_addr, uint64_t pfn)
+{
+	char buf[32];
+	int fd, len;
+	ssize_t ret;
+
+	printf("injecting hwpoison at phys 0x%llx (pfn 0x%llx, kind=%s)\n",
+	       (unsigned long long)phys_addr, (unsigned long long)pfn,
+	       kind->name);
+	printf("expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'\n");
+	fflush(stdout);
+
+	fd = open(INJECT_PATH, O_WRONLY);
+	if (fd < 0)
+		return "cannot open " INJECT_PATH;
+
+	len = snprintf(buf, sizeof(buf), "0x%llx", (unsigned long long)phys_addr);
+	ret = write(fd, buf, len);
+	close(fd);
+
+	if (ret != len)
+		return "inject failed before reaching the panic path";
+
+	return "inject returned without panic; sysctl ineffective";
+}
+
+static const struct page_kind *lookup_kind(const char *name)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(page_kinds); i++)
+		if (!strcmp(page_kinds[i].name, name))
+			return &page_kinds[i];
+
+	return NULL;
+}
+
+static void usage(void)
+{
+	printf("hwpoison-panic [options]\n"
+	       "            -k|--kind <kind>       rodata (default, x86 and riscv only),\n"
+	       "                                   slab or pgtable\n"
+	       "            --yes-panic-my-kernel  really run it: the machine panics\n"
+	       "                                   and every unsaved write is lost\n"
+	       "            -h|--help              show this\n");
+}
+
+static const struct option opts[] = {
+	{ "kind",                 1, NULL, 'k' },
+	{ "yes-panic-my-kernel",  0, NULL, 'y' },
+	{ "help",                 0, NULL, 'h' },
+	{ NULL,                   0, NULL, 0 },
+};
+
+static const struct page_kind *parse_args(int argc, char **argv, int *armed)
+{
+	const struct page_kind *kind;
+	const char *name = "rodata";
+	int c;
+
+	while ((c = getopt_long(argc, argv, "k:h", opts, NULL)) != -1) {
+		switch (c) {
+		case 'k':
+			name = optarg;
+			break;
+		case 'y':
+			*armed = 1;
+			break;
+		case 'h':
+			usage();
+			exit(EXIT_SUCCESS);
+		default:
+			usage();
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	kind = lookup_kind(name);
+	if (!kind)
+		fatal("unknown kind '%s' (expected: rodata|slab|pgtable)\n",
+		      name);
+
+	return kind;
+}
+
+static void check_prereqs(int armed)
+{
+	if (geteuid())
+		fatal("must run as root\n");
+	if (access(SYSCTL_PATH, W_OK))
+		fatal("%s not present (kernel without the sysctl?)\n",
+		      SYSCTL_PATH);
+	if (access(INJECT_PATH, W_OK))
+		fatal("%s not present (no MEMORY_FAILURE?)\n", INJECT_PATH);
+	if (!armed)
+		fatal("this panics the kernel; pass --yes-panic-my-kernel\n");
+}
+
+static uint64_t pick_phys_addr(const struct page_kind *kind)
+{
+	uint64_t addr;
+
+	if (kind->bit == BIT(RESERVED)) {
+		if (pick_rodata_phys_addr(&addr))
+			fatal("no \"Kernel rodata\" in /proc/iomem; try -k slab or -k pgtable\n");
+	} else {
+		if (pick_kpageflags_phys_addr(kind->bit, &addr))
+			fatal("no usable %s PFN in %s\n", kind->name,
+			      PROC_KPAGEFLAGS);
+	}
+
+	return addr;
+}
+
+static void arm_sysctl(unsigned long *prior)
+{
+	if (read_sysctl(prior))
+		fatal("failed to read %s\n", SYSCTL_PATH);
+	if (write_sysctl(1))
+		fatal("failed to enable %s\n", SYSCTL_PATH);
+}
+
+static void recheck_kind(const struct page_kind *kind, uint64_t pfn,
+			 const char *verdict)
+{
+	uint64_t flags;
+	int fd, ret;
+
+	fd = open(PROC_KPAGEFLAGS, O_RDONLY);
+	if (fd < 0)
+		fatal("%s (could not open %s)\n", verdict, PROC_KPAGEFLAGS);
+	ret = kpageflags_read(fd, pfn, &flags);
+	close(fd);
+
+	if (ret)
+		fatal("%s (could not reconfirm page type via %s)\n", verdict,
+		      PROC_KPAGEFLAGS);
+	if (flags & kind->bit)
+		fatal("%s (page still %s)\n", verdict, kind->name);
+
+	fprintf(stderr, "target PFN no longer %s; raced before inject, inconclusive\n",
+		kind->name);
+}
+
+int main(int argc, char **argv)
+{
+	uint64_t phys_addr, pfn;
+	const struct page_kind *kind;
+	const char *verdict;
+	unsigned long prior;
+	int armed = 0;
+
+	kind = parse_args(argc, argv, &armed);
+	check_prereqs(armed);
+	page_size = getpagesize();
+
+	phys_addr = pick_phys_addr(kind);
+	pfn = phys_addr / page_size;
+	arm_sysctl(&prior);
+
+	verdict = inject_hwpoison(kind, phys_addr, pfn);
+
+	/* No panic fired.  Put the machine back, then report. */
+	write_sysctl(prior);
+	unpoison_pfn(pfn);
+	recheck_kind(kind, pfn, verdict);
+
+	return EXIT_FAILURE;
+}

---
base-commit: 95d6a9ccef99117115e41e9adb271243bd5e985b
change-id: 20260728-memory_failure_rewrite_test-7a309a601a6e

Best regards,
--  
Breno Leitao <leitao@debian.org>


