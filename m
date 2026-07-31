Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 738BCC5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 13:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94F76B0088; Fri, 31 Jul 2026 09:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45436B008A; Fri, 31 Jul 2026 09:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D34D76B008C; Fri, 31 Jul 2026 09:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2046B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:16:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 235C2A042F
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:16:48 +0000 (UTC)
X-FDA: 85049121696.24.AB8C6C3
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2E6C040013
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:16:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=L5l0BgWE;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785503806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WxmpxPhLkAfN6dJJ6eY1iNH1qQqKhQ4rnEke/X+tN6M=;
	b=V1l4JIkshtCVLME44LuD5I1nmWCfvggi+2uNUAf4GypW7kn87g+RXhMdTx/8vx8K8KC4Qr
	bvu7B/jWsDqGMypp2lg8tEPH25/PDJYB76buRttqdbmOPRA0A5K7mMxN5B5+ouuwspuqXt
	EAmhekRIxiniHQBGDqZYDvhTjk53kaY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=L5l0BgWE;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785503806;
	b=pnPGdW2gtNXDeVuBaukpit72SGRwjTmONg4OhFYThyX8LO3S/QlHIXVhaagEUHBVbzv3yz
	GeIsIGN418p+M0R7J0J4D7Jm0ILJlIu4ZbJImXQmCyKRL4BdSKTVBT1Fh7++8IvX0/CuWN
	tBsxbq8JUN0PAWrr6VU5BnU7SCkRMFE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=WxmpxPhLkAfN6dJJ6eY1iNH1qQqKhQ4rnEke/X+tN6M=; b=L5l0BgWEu5lOmPT2nuYcZRlfmd
	3woB6c6xsa0UpGupTEZLqfbVJB81uTGlPz+Or+V2WBClFUYkq32JCvh9J1pi1S+jTv1Tg0jJuVBn5
	CaPVLcMnMYa7VCUTfyZcqYLjVEuhdWeNVAxhTh0xIuBaZOyM4hBg6tUznYQgTJGr2qfe2e7PLxGF9
	+rlTeUgs0UXVfhsj26GGr1+XitCxEDBkqWjPDol+jg0F5NlGSSMHhwbM7IpvmZS4e9yNdxPnru8z2
	oG9bouE8E9k47uBMkR3J5EuK2HGtGtlUpS7RMfzcN9Zs5N4uZJT8QyXfVAg3JuDiZUA9xEsroxecv
	cIVOXrgQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wpn6E-00A2QL-1v;
	Fri, 31 Jul 2026 13:16:31 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 31 Jul 2026 06:16:12 -0700
Subject: [PATCH] tools/mm: add hwpoison-panic tool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-memory_failure_rewrite_test-v1-1-6aa8c6435693@debian.org>
X-B4-Tracking: v=1; b=H4sIABygbGoC/x3MWwqDMBAF0K0M820gphBttlJKGNqrDvgok/SFu
 PdCzwLOzgWmKJxoZ8NLi24rJ2ob4tsk6wind07EwYfou9C7Bctm3zyIzk9DNrxNK3JFqa6Tkz9
 L9K1EcEP8MAz6+e+X63H8AMROuOhtAAAA
X-Change-ID: 20260728-memory_failure_rewrite_test-7a309a601a6e
To: Andrew Morton <akpm@linux-foundation.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, david@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-riscv@lists.infradead.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=12392; i=leitao@debian.org;
 h=from:subject:message-id; bh=x/n7bFuXnnjqh6ikdwXfpq2b7z0g0U4Vzs5zejnfy+s=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqbKAqp6seMta8YA5BQe0YHa4X1DOo4NlPhT6z/
 FW3ng4xIPWJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCamygKgAKCRA1o5Of/Hh3
 bajrD/4uEuxZIlDH1WmvkPvB2pd2m76SGl7jRLUc+lSjZKpbcMYFEWmcIheqpE8MdALRZ8S0dm/
 JOaOapXt9wq+hG5v2k1PSiRNqwtoBoLDsTXRiBVZhTtD0Ph8L1XDSaY84DTqIIl92CI8CW3A5F7
 I0bazp4AOt01lwBG+4fPkM8ws2/fd7Wi1VePgv4yarcemLMWJv4KbY8MOD+Nm1EC+YUwRUk5TEn
 G3CQlCw0P3F9fgIFDzqgeLpJlBufALlyj0k26thp90yaRpPUNg38WPzMxlv08N/Gw4sA6tsvxQZ
 vF89HRIbbNi9Sawx1H3aIFo3ybqN3mwC+0EJ+ncDRD+OhQVdNZG8s9sxYeC1q4JBqV4rjihpQKh
 /wYEqMhj3fOYozaRQaIvu2D2pKWY96u8mxBIzAfxtBPOewkg4PRryYkKw9nnClMWH6HmBAebFZz
 5lFLqPZuAm55/vpzljC475FZJenx+sUdXnfs9eVGu5yJuk4giyHgrEzIbs0z2gXePNepqWB1HNx
 PICZ/KeMXyWWfMzXy16RzWJGu+c8uKHkae8+ZG8DExyY4TVECLiVNmN41H+enuncFlS7QPx82c2
 Cv6koFi27tmQjXVBPCfOW+VApFcF2nVZM81A3fwve194yYxpDpFSBgmhL6W3jOj5Z7rLXIyB42l
 vkddYOLL1H61pLA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2E6C040013
X-Rspam-User: 
X-Stat-Signature: uswbeej9tqi8k9f11j8egz3b8b3m9sqg
X-HE-Tag: 1785503806-337601
X-HE-Meta: U2FsdGVkX19PR71gTp7sWeecSDbtICVYxlt1pT+fbIiVcCySwPenckH50wZJ2DspX909rN7m7mcLBJSdJ/BMiWBCzCAeRQGCZw54GoWhabK5QN3EvRtYiQM3aK87j9DkqwKiMMxYmUsNheLwevJ8Jr8rpEnqhKqm7W/J4BXCzUwPg/VysR0tsAeoPlfFWADu5nnmoFQ4nPQfWKkEljKdz0nwBdxPfqt5XyUxpzd6/jwjsc2tIW6nXgvhuOV2jg00vhNxxMGk7GUs8nJ7BrizeNPD3Q3yFH03qL5WQ4+w4XULNX/hr0ePtqy4SPig/0PbO8cKbxLQaqC0A7pEnVxLyZcXvfaJ0MZo7PoAb/hI2lN+w/48uJ1xr9RUnG9A7JfjxrJVCfbipQXNdw5U7KpvGx4YSk9W3n2nFikIfPorAamKqwy6UCIlBNX8I12mkNZj0Q81NWnQkoc9u9Ipf15QxWy/qEMQ506bKKRrAjEgvoEbKgMjFTNs3DQOOAwjh8+bYWICV64E7vO6JxmnUOwr0tBMj/8L9taWyGW8tXUBzVqB7Z0c0NLgpvOYbNO1CKEyA1PfYncoMGxE5Z8bxL1RPxfQO16rI7Fpll2W4cJi4rmAGiv3P79NRxoTHEOU4yXCmFFpK+EXWCZcaRPP50i2eveqaJOrHZ3oLWApbEGm0kD4MuWc4jXr1fgG76PGBgCPVxq4Bii0WNA9ybO7Ukqt+E4WxO/qkpdIsGeGKd/6Ji8/i4oQgLyFSJIwfn5QC6RK2rRWQytzHet1sOu+ZhOugSahESv0K6Xqn5HYqtvunltro6FGClzRoeqqgoT6bNTJiv8ssjYb0G5x7+7US6/rtMFBaiDKiExIx3MMmjVDNBNPg2VUmw7EF8Z44SAPMpXGGin1dI9AZrLSPf+dkQ7vhxYejU5ma8Lt2WQF0P+kfe/Vr7u4oC/4nOcflQDmiQ6oyhuZbX0AY/01Ww02nde
 RkVE4rv3
 H40hATHb+ZQD5pMGzuuS65LxIlxgNRuCdICKW3+Wwbh2VVV6LmTIwvGetZ770o+QDBf6zr1VW8bzx/iXb2jYo40KHOtiPl8mxo4qvQagDXzWK1ea5sVA7cb5ABouj0E0iDmqRbZUhwjwahqt1+KMC1F3IgcKuKIHtRS+1U2fMrdXSoqpYvZ+nSEVuTHnVLUI+MZC5DFyGrrOd95D7KolJqMHpYvM1s5LDsXTLqH0+3RCaiiZ7IxdwZWuoxlEXpkf/Ay7ZKcb2a95kA+ansTQpmB+YIoWASsqGKV06BxmcVrU51Vsdnx2fW5muO8v/M2fZvwJhT5EJOjiTDZAg/CX1gn1BdR4Sr+LszOZ8T3jdAkEG0Rk=
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

        # ./hwpoison-panic  -k slab -f
        injecting hwpoison at phys 0x100032000 (pfn 0x100032, kind=slab)
        expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'

In dmesg, you will see:

        Memory failure: 0x100032: unhandlable page.
        Memory failure: 0x100032: recovery action for reserved kernel page: Ignored
        Kernel panic - not syncing: Memory failure: 0x100032: unrecoverable page

This lives in tools/mm rather than selftests/mm because every successful
run crashes the machine, which is not something to run from CI.

Argument -f is required so an accidental invocation does not take the
box down.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 MAINTAINERS                              |   1 +
 tools/mm/.gitignore                      |   1 +
 tools/mm/Makefile                        |   2 +
 tools/mm/memory-failure/hwpoison-panic.c | 353 +++++++++++++++++++++++++++++++
 4 files changed, 357 insertions(+)

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
index 0000000000000..b8076d86da15b
--- /dev/null
+++ b/tools/mm/memory-failure/hwpoison-panic.c
@@ -0,0 +1,353 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * hwpoison-panic: verify vm.panic_on_unrecoverable_memory_failure by
+ * injecting a hwpoison error on a kernel-owned page and confirming the
+ * kernel panics.
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
+ * A successful run crashes the kernel, so -f is required and the tool is
+ * meant for a disposable VM (e.g. virtme-ng) with the serial console
+ * captured.  The result is observed externally: the kernel must panic with
+ *   "Memory failure: <pfn>: unrecoverable page"
+ * Returning at all means no panic fired, so every exit status is non-zero:
+ * either a failure, or an inconclusive run where the target PFN raced to
+ * another page type before injection.
+ *
+ * Author: Breno Leitao <leitao@debian.org>
+ */
+#define _GNU_SOURCE
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
+static int kpageflags_read(int fd, unsigned long pfn, uint64_t *flags)
+{
+	ssize_t bytes;
+
+	bytes = pread(fd, flags, sizeof(*flags), (off_t)pfn * sizeof(*flags));
+
+	return bytes == sizeof(*flags) ? 0 : -1;
+}
+
+static long pick_rodata_phys_addr(void)
+{
+	char line[256], label[64];
+	unsigned long start, end;
+	long addr = -1;
+	FILE *f;
+
+	f = fopen("/proc/iomem", "r");
+	if (!f)
+		return -1;
+
+	/* Sub-resources are indented: "  02500000-02ffffff : Kernel rodata" */
+	while (fgets(line, sizeof(line), f)) {
+		if (sscanf(line, " %lx-%lx : %63[^\n]", &start, &end, label) != 3)
+			continue;
+		if (strcmp(label, "Kernel rodata") || end <= start)
+			continue;
+		/* Page-align up and return the first byte of that page. */
+		addr = ((start + page_size - 1) / page_size) * page_size;
+		break;
+	}
+
+	fclose(f);
+	return addr;
+}
+
+static long pick_kpageflags_phys_addr(uint64_t want)
+{
+	unsigned long pfn = (16UL << 20) / page_size;
+	long addr = -1;
+	uint64_t flags;
+	int fd;
+
+	fd = open(PROC_KPAGEFLAGS, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	for (; kpageflags_read(fd, pfn, &flags) == 0; pfn++) {
+		if ((flags & want) && !(flags & BIT(HWPOISON)) &&
+		    !(flags & BIT(NOPAGE)) && !(flags & BIT(COMPOUND_TAIL))) {
+			addr = pfn * page_size;
+			break;
+		}
+	}
+
+	close(fd);
+	return addr;
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
+static void unpoison_pfn(unsigned long pfn)
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
+	len = snprintf(buf, sizeof(buf), "0x%lx\n", pfn);
+	if (write(fd, buf, len) < 0)
+		perror("unpoison-pfn");
+	close(fd);
+}
+
+static const char *inject_hwpoison(const struct page_kind *kind,
+				   unsigned long phys_addr, unsigned long pfn)
+{
+	char buf[32];
+	int fd, len;
+	ssize_t ret;
+
+	printf("injecting hwpoison at phys 0x%lx (pfn 0x%lx, kind=%s)\n",
+	       phys_addr, pfn, kind->name);
+	printf("expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'\n");
+	fflush(stdout);
+
+	fd = open(INJECT_PATH, O_WRONLY);
+	if (fd < 0)
+		return "cannot open " INJECT_PATH;
+
+	len = snprintf(buf, sizeof(buf), "0x%lx", phys_addr);
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
+	       "            -k|--kind <kind>  rodata (default, x86 and riscv only),\n"
+	       "                              slab or pgtable\n"
+	       "            -f|--force        really run it: this panics the kernel\n"
+	       "            -h|--help         show this\n");
+}
+
+static const struct option opts[] = {
+	{ "kind",  1, NULL, 'k' },
+	{ "force", 0, NULL, 'f' },
+	{ "help",  0, NULL, 'h' },
+	{ NULL,    0, NULL, 0 },
+};
+
+static const struct page_kind *parse_args(int argc, char **argv, int *force)
+{
+	const struct page_kind *kind;
+	const char *name = "rodata";
+	int c;
+
+	while ((c = getopt_long(argc, argv, "k:fh", opts, NULL)) != -1) {
+		switch (c) {
+		case 'k':
+			name = optarg;
+			break;
+		case 'f':
+			*force = 1;
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
+static void check_prereqs(int force)
+{
+	if (geteuid())
+		fatal("must run as root\n");
+	if (access(SYSCTL_PATH, W_OK))
+		fatal("%s not present (kernel without the sysctl?)\n",
+		      SYSCTL_PATH);
+	if (access(INJECT_PATH, W_OK))
+		fatal("%s not present (no MEMORY_HOTPLUG?)\n", INJECT_PATH);
+	if (!force)
+		fatal("this panics the kernel; pass -f to run it in a disposable VM\n");
+}
+
+static unsigned long pick_phys_addr(const struct page_kind *kind)
+{
+	long addr;
+
+	if (kind->bit == BIT(RESERVED)) {
+		addr = pick_rodata_phys_addr();
+		if (addr < 0)
+			fatal("no \"Kernel rodata\" in /proc/iomem; try -k slab or -k pgtable\n");
+	} else {
+		addr = pick_kpageflags_phys_addr(kind->bit);
+		if (addr < 0)
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
+static void recheck_kind(const struct page_kind *kind, unsigned long pfn,
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
+	unsigned long phys_addr, pfn, prior;
+	const struct page_kind *kind;
+	const char *verdict;
+	int force = 0;
+
+	kind = parse_args(argc, argv, &force);
+	page_size = getpagesize();
+	check_prereqs(force);
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


