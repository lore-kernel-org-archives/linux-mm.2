Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5D3AC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:51:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B945B6B00A4; Tue,  8 Sep 2026 08:51:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6BB96B00A5; Tue,  8 Sep 2026 08:51:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0E916B00A6; Tue,  8 Sep 2026 08:51:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73EFA6B00A4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:51:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 12D244057F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:32 +0000 (UTC)
X-FDA: 85190581224.27.822BDBB
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1955D160011
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="k LxwheJ";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=BRWO2MQm;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sIS6fNLbNyz8emwIgfidikiVHKPCia4QjSI19QX/P8g=;
	b=aVIkqDQrNeNPqJoIQZqOu0UdsMsB4ZIj0fULWpONTF97aDZCI1TOpr7HOeB521w02IPpMc
	izbYfsGG9Xbl4JTk5RiRX7x62QBzpypDHd0lLN75FuJ9JUyxtovyD5sfMu3lyyu/IMniTK
	t2kWOy4bVHpMs/fCUijIyZ4oyy2lWSo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="k LxwheJ";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=BRWO2MQm;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871890;
	b=tgTIzuFkCASLjqW482+P7/F6nyTQjdN10bDQOFsWbcmYzRNw2sr1o33pwrjdtoyysAiI+Q
	vuZhnOLF48Wgk2wimwabw6OZzEdkFWcO+Ete3NciYM7r0ZM/F9f7RoCF14RhXo9T531IQH
	AWCQTKPO2KOaRknbqhFrx/ink1PTLz4=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.phl.internal (Postfix) with ESMTP id 9A351EC0032;
	Tue,  8 Sep 2026 08:51:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Tue, 08 Sep 2026 08:51:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788871889; x=
	1788958289; bh=sIS6fNLbNyz8emwIgfidikiVHKPCia4QjSI19QX/P8g=; b=k
	LxwheJba5G3C6xh00NrzV0Uw6X7N4Gydxv8DHAKE13fNnSrzqRfFoahfUWpcgi5V
	QwUY/5qDPKSDAcTSJdQikZZXiGxSQyXzT6QE+dfXpGwRulqUNUC8cStxRXQVNZXF
	MDE64bjQxH3Gx1JUGF3WxYOYvxnDamqWPGJUQ+ZEQ0j92nXUMcApTlzFdv2w4KIN
	i6628kAo63k0hquSdysOjzRg6SU+QC8Zu5RuimrqEKnqXTI2Ex5zipb1itE4k/wN
	UI3Fl1y0VaRKB69peod5CQyWHwQRT4wAbZCKTd4J7xqQyI1c+0hJvR7lYBzlUcpT
	PSxd9pl5MXU8z0Hq+2LIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788871889; x=1788958289; bh=s
	IS6fNLbNyz8emwIgfidikiVHKPCia4QjSI19QX/P8g=; b=BRWO2MQmDuQrRSa7f
	+JwtTMATBVzrm3voyzxuwGvd3K7PUAxMg+HMh8rX2eNgQJ2xHsuyHOpT6SZv2Ysb
	TlqaZYSn3vDCcPv3cpQyfZyUVgWtREB8xvgZflJUQuSsZOUzYoGjFup7DvK7oiZ0
	dncULcTsOVM2jzDYu5RkkFEx9vXP6iWEheQCJpALW45kG2tcIl1ULrlkHTFAe0Rt
	53taZFxCUyvjHWtF3wQJI20pbfvZJxFMxkkn2wRZ2Q1Li73f/DhZSsdGR1trfpnZ
	8LQt4HKG+8Gk02Kyh1GmJoKlGuArlJEM7daFeSX7/P7rV87rYt1l2HbwOItLzYDB
	BeaEA==
X-ME-Sender: <xms:0QSgarUDQWLnA0yNUxgPgoAkpsKOph0CEV7lIiT4YgnwnJGWEuAdhA>
    <xme:0QSgar_KIwpmp20huAUFUW2zo3ABPRn0ezIO2seZ_HgbiOApBAUzaCB29bMpThoPm
    zUC7PjBkLp2zxZL-x6I8CpjSRhwqVlw8UZ_LY-Ipin2NJTX0B-AcVQA>
X-ME-Received: <xmr:0QSgaplFPS6Qxp7aLdQnc1_NEeCQvSUil6KQ1Wvgy22qOqjOhzLeVsWlTQM>
X-ME-Proxy-Cause: dmFkZTFCT83ts3xpHDuUgDdlzQtELcoAknrXBpsFepmdcEBLccwduWOOVyAuau0VlYvm49
    objBvbnGefvuHsKXiB+MOl7qErn3M4/Q7Z72R+asBFni+WG6jRYqPjjJBv1F7ovmfnEZp3
    uEJcbLADGcdxsWcYxdWct2wwV9KQaoOTpGWM7Il7/oKOILrVOp7MvqHbWAXdA0mgRBniUZ
    2M+Su4Zoe9zFbzekNirjNltohahTSfzaLbYZTkGXD/hRQ+ajqkABo2HdEn2GJrc7g0w4Iu
    PhTUexE0AKZ4j2dsA7W9i19VnbZvZZgTTujH64lpg2nDW6KlKK63jDlRsrLETwVfJ8WCX6
    WSN+HYjEFpoqT62XYb69m8N3bWF4E7LxK14kEgvviCmVPuHyhEkc3JMD+WicAP6/3dRBQN
    xi+2W80PS5RkYFCLbTMOdiI/2lgS/lm8JjCs0I4ZG1TQd40+C1Cs45KpE0Os/oUvfnlMuR
    Kt+srlzhA/YG2BELRtW8Gn2FSMnoLKByjqzbv72BURgBb7ET7xoA6jKcfMFk+l40EYSOii
    o58OEfLUVQurMS9J1Zcszd8f0WO193vq/Zb9LveVOtxLhXFL1MkY6u5aCVhpklNrIJnbHq
    2iE/TK9qEMWk0cAspao+vMN6CqF1Pjrejwi2N3ZjXyk6xjfWY9qDzLW52SSw
X-ME-Proxy: <xmx:0QSgauJJCIWFwgR5qvPmAN_xC6z-QwsdnJcFGzoRwo5s2I9l4UtS4g>
    <xmx:0QSganrqEXkg_tQzyA1WmY9kIHYS8MqHUUHAAtYbYnOBj2mRTM3rEg>
    <xmx:0QSgajTR0d0PS6j7UvI4Ofrs3kMHC7TWE3ofdjbuXYRpR2CZauTYtQ>
    <xmx:0QSgai51LIyY6-M-ugeYYpZ25Ek5N1BXqXUTiSBhZEiyzu_LeZ_OSw>
    <xmx:0QSgaulB9yaVnirB2mTG7vsqJT-6h2UJ9FHQC4_ZmP3co8yWD_9BiUIs>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 08:51:28 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	usama.anjum@arm.com,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ziy@nvidia.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	agordeev@linux.ibm.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 09/19] selftests/mm: add folio-order detection self-check
Date: Tue,  8 Sep 2026 13:50:55 +0100
Message-ID: <20260908125105.1510704-10-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908125105.1510704-1-kirill@shutemov.name>
References: <20260908125105.1510704-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: atoei5ej3x54jwsgrj53x37k1nrcxqdj
X-Rspamd-Queue-Id: 1955D160011
X-Rspamd-Server: rspam07
X-HE-Tag: 1788871889-141110
X-HE-Meta: U2FsdGVkX19Vy5SVYACBEm8aroTuI0fj7OY5pnj/6B0EWOfq6upDuV9JDwOszb5g4no+DQ/q34esHiisnYjwrGugbhv4j2lu8IOHThatY9Y7ek1jqpWpJYAjlr3XiOh0sEA54BlcdgiBKcevBHtM8LDY+fl7ISu1qRAXihHvpuB1SPTWkbaftJbJ+OCL9YOSdKe7TGgLmZD9Eitc+1tl2Jf1gzB9AcT9Bdi7WHoUXVL6Dx8Z87Uw259ejRy3muiNPEzmt+3Tb+K4bfaqJ/SuUT31u99gAOSUaexxLcIxlwRjfNtymJjC7y6LPMMuLZJmIFD9yGCpYTAjuEPmZgrKQhDLganP4PmGAqEfpi6rrwcFVcyp8EmWQS5oaRZKAscaTcJCSZxYO9e/9otavQ+jFVxuxQW8Oom78fBXRvjIoB7q5ixYXAvTOVeoNcysgrJuZD/nXNpeWh8Y8HKLIUjlhuWjsBaqZcDz6ZXQf62mxNjtQv9CB18/I1X1eRrOA1Y/trmQtU5VxLRmxHu6Lalh7BfL2QlehfVSLX3aE6SiofyVvueEmHVyBtMzzyOEFPb2wM4lmyHZelFjQ21TGgkw9mmwdOp1jexSILDxPQ8rIIMYXh0G7yvDesI3V+fGnDqF8C9Kt0IIPfkuM8leCm0FvOPA0t57eWo6DLnEP1ndwIMvL2pv3E8gwXJm3TGAg3OlK+dsu2y7qRXjP5tXsECXKc/166MulhISTZNryYp81PMV/xaffpw8ftkb1lGkwdpipZ0Y+KkM5nswj4B6d5VltUwFzZkSKG+HaXrLfxY/lgJrQRQyQmhEDH8oAnG0RLHiMs4oQfahFOvK1kIgZ+/zrVrPXk0RAwYqTRvd8jIFhzckHeR83tbBN83atUKlpZozUo56fjmHUyv92nvnxKS4AIt7a6YOcfFWm16t0GUBZJL4eaGHWN/ea5dTmyisetOua2k4FITtWqM8h/hecbo
 LD1nleZ0
 BQHioU5UJAwOSDo2UE40LwZrfbQ5n2moNgMahS9imIMp/0XarKV1qsX41PwiVLqGbXRClJKPSYOsn8nZ7oYJr2yihmJBH5MOwpRvJjOSVx+xTR/uoD7xyzGxbTRNZI6wQgPq50D/A32qVHffSdEtVu9+E+YiWIKrU5phApdxYNxK16yQwcelok+VjceLF9F4vAlJ7B34rUgbemEf60sdG37qsR5iPgeK8+XY7P2hFkmf7WFNrJqs67XrffjAsiWkF5+CmdJ8PEJB2GqtDBZlsETQf1pvKaR7u9XjqVxNIeWw6ND3EtIgfKVktFa8E87X+QerFPZDimRTBuFpEhpPBZdWTvLukll72+9c1Ci+UTmxDEbsZkFFTBEjQO/w38skzRwV6n9YgOnuz1v294EONKsAGEh8Es0gO0NHe0fJc7JtRtIvqULsLOp7FFMKwzAR8BzazobGF2XtQA9gPuSBFOjcTmEEvfPKUFs06PHH+zmK5+OOX2VpTojGk+6nadoB6Ym7H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The khugepaged mTHP tests detect collapse results with the vm_util
folio-order helpers rather than smaps AnonHugePages, which only sees PMD
mappings.  If those helpers are wrong, every case built on them is wrong
the same way, and nothing says so.

Check them directly.  For every anon THP order the kernel supports, fault
memory in with only that order enabled.  Require the helpers to classify
the backing as exactly that order: not the order below it, and base-page
memory as order 0.

Run it in the thp category, ahead of ./khugepaged, so a broken helper is
reported as itself rather than as a collapse failure.  Verified on x86-64
4K (orders 0, 2-9) and arm64 64K (orders 0, 2-13).

The test needs ALIGN(), which hmm-tests.c and migration.c each defined
privately.  Move it to vm_util.h and drop both copies.

Assisted-by: LLM
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/Makefile           |   1 +
 .../testing/selftests/mm/folio_order_check.c  | 122 ++++++++++++++++++
 tools/testing/selftests/mm/hmm-tests.c        |   1 -
 tools/testing/selftests/mm/migration.c        |   1 -
 tools/testing/selftests/mm/run_vmtests.sh     |   2 +
 tools/testing/selftests/mm/vm_util.h          |   2 +
 6 files changed, 127 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/mm/folio_order_check.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 2d5366196e30..2093fcf6e915 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -104,6 +104,7 @@ TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
+TEST_GEN_FILES += folio_order_check
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/folio_order_check.c b/tools/testing/selftests/mm/folio_order_check.c
new file mode 100644
index 000000000000..fa736c9f701a
--- /dev/null
+++ b/tools/testing/selftests/mm/folio_order_check.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Self-check for the vm_util folio-order helpers, is_backed_by_folio() and
+ * is_range_backed_by_order(), which the khugepaged mTHP cases use to detect
+ * collapse results.  For every anon THP order the kernel supports, fault
+ * memory in with only that order enabled and require the helpers to report
+ * exactly that order.
+ */
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/mman.h>
+#include <unistd.h>
+
+#include "kselftest.h"
+#include "vm_util.h"
+#include "hugepage_settings.h"
+
+static int pagemap_fd;
+static int kpageflags_fd;
+
+static char *alloc_aligned(size_t size)
+{
+	size_t len = size * 2;
+	char *p, *aligned;
+
+	p = mmap(NULL, len, PROT_READ | PROT_WRITE,
+		 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (p == MAP_FAILED)
+		ksft_exit_fail_perror("mmap()");
+
+	aligned = (char *)ALIGN((uintptr_t)p, size);
+	if (aligned != p)
+		munmap(p, aligned - p);
+	if (aligned + size != p + len)
+		munmap(aligned + size, p + len - aligned - size);
+
+	return aligned;
+}
+
+static void check_order(int order)
+{
+	struct thp_settings settings = *thp_current_settings();
+	size_t size = psize() << order;
+	bool ok = true;
+	char *p;
+	int i;
+
+	for (i = 0; i < NR_ORDERS; i++)
+		settings.hugepages[i].enabled = THP_NEVER;
+	if (order)
+		settings.hugepages[order].enabled = THP_ALWAYS;
+	thp_push_settings(&settings);
+
+	p = alloc_aligned(size);
+	*p = 1;
+
+	if (!is_range_backed_by_order(p, size, order, pagemap_fd, kpageflags_fd)) {
+		ksft_print_msg("order %d not detected after fault\n", order);
+		ok = false;
+	}
+
+	/* A lower order must be rejected: the folio is larger */
+	if (order && is_range_backed_by_order(p, size, order - 1,
+					      pagemap_fd, kpageflags_fd)) {
+		ksft_print_msg("order %d also reported as order %d\n",
+			       order, order - 1);
+		ok = false;
+	}
+
+	/* A large folio must not pass as order 0 */
+	if (order && is_range_backed_by_order(p, size, 0,
+					      pagemap_fd, kpageflags_fd)) {
+		ksft_print_msg("order %d also reported as order 0\n", order);
+		ok = false;
+	}
+
+	munmap(p, size);
+	thp_pop_settings();
+
+	ksft_test_result(ok, "order %d classified\n", order);
+}
+
+int main(void)
+{
+	struct thp_settings settings;
+	unsigned long orders;
+	int order;
+
+	ksft_print_header();
+
+	if (!thp_available())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_perror("open(/proc/self/pagemap)");
+	kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
+	if (kpageflags_fd < 0)
+		ksft_exit_skip("open(/proc/kpageflags) requires root\n");
+
+	orders = thp_supported_orders();
+	if (!orders)
+		ksft_exit_skip("No supported THP orders\n");
+
+	ksft_set_plan(__builtin_popcountl(orders) + 1);
+
+	thp_save_settings();
+	thp_read_settings(&settings);
+	/* Base of the settings stack; the bottom entry is never popped */
+	thp_push_settings(&settings);
+
+	check_order(0);
+	for (order = 1; order < NR_ORDERS; order++) {
+		if (!(orders & (1UL << order)))
+			continue;
+		check_order(order);
+	}
+
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e2642eca0d02..df426f9218e7 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -65,7 +65,6 @@ enum {
 #define HMM_PATH_MAX    64
 #define NTIMES		10
 
-#define ALIGN(x, a) (((x) + (a - 1)) & (~((a) - 1)))
 /* Just the flags we need, copied from mm.h: */
 
 #ifndef FOLL_WRITE
diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index f19d53c69576..fd35f8a7b5b8 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -20,7 +20,6 @@
 
 #define TWOMEG		(2<<20)
 #define RUNTIME		(20)
-#define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
 
 HUGETLB_SETUP_DEFAULT_PAGES(1)
 
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d09f9f6a384e..2652a7920b80 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -402,6 +402,8 @@ CATEGORY="pfnmap" run_test ./pfnmap
 # COW tests
 CATEGORY="cow" run_test ./cow
 
+CATEGORY="thp" run_test ./folio_order_check
+
 CATEGORY="thp" run_test ./khugepaged
 
 CATEGORY="thp" run_test ./khugepaged -s 2
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index e509fc4012a5..3be430e01901 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -10,6 +10,8 @@
 #include <linux/fs.h>
 
 #define BIT_ULL(nr)                   (1ULL << (nr))
+#define ALIGN(x, a)                   (((x) + (a) - 1) & ~((a) - 1))
+
 #define PM_SOFT_DIRTY                 BIT_ULL(55)
 #define PM_MMAP_EXCLUSIVE             BIT_ULL(56)
 #define PM_UFFD_WP                    BIT_ULL(57)
-- 
2.54.0


