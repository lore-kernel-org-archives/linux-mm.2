Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B678C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 11:37:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D6A56B009D; Fri,  7 Aug 2026 07:37:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 011B06B009E; Fri,  7 Aug 2026 07:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF5436B009F; Fri,  7 Aug 2026 07:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5D8B6B009D
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:37:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48504C0349
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:12 +0000 (UTC)
X-FDA: 85074272304.06.B414596
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf14.hostedemail.com (Postfix) with ESMTP id 528E6100002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:37:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="o M2T9FT";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=M8dqq961;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786102630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Q59Aumd9RegCdWlgfhV9psGQQvAucyMQvh9lBiHEw4=;
	b=OVYr0gwWdSKmrV1W4bTFhk5+odMvE3DAvawNqqSPGFh8G3e9SsnMztuqnzgdRXSTmsid32
	yThzNXAybRh2+X2+EZ+5N7Z+fVK9QDTEFLzrtzZ+6BIiva/wVZKa4hjcaYdiOCFsO6coND
	hC5TsWYv/vITYqID7rOsIbMXNeHuyGQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786102630;
	b=3yZ2whHbPYHNgyMW6qtTSz1cRhGSGVjx5FUTuWZJQEstBGNjSmTDt5nxXZ1DeM6IrDQ8x3
	xu/rrluk9zh3R0mbJqcV8HQcdUCnfi2qF+gIQsZjC+qrcOXZP5BkezkVTtil9BlNO8FsmM
	fyjWAijR1ZTvizm6k8O24APUMaZEdBo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="o M2T9FT";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=M8dqq961;
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 260717A004F;
	Fri,  7 Aug 2026 07:37:09 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Fri, 07 Aug 2026 07:37:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786102628; x=
	1786189028; bh=3Q59Aumd9RegCdWlgfhV9psGQQvAucyMQvh9lBiHEw4=; b=o
	M2T9FT6LfiuXNEslmr2/X0kTm2MS+KkZx1jphaTgf+sKPW5zz+/KUYjMS8F/KvFT
	toa7Xi7LVW5Va0P+Laa8BIJIT1KudZvodLb7v0Mu6GoijuSWuwFCKX8h0U7Ei5xG
	Z7ULhQO/pv86M58JEbWOk/DCPfle0ovhgGSNyfrTJsaJ0XjZJqqYYGYQcKiaoMlm
	E3zwNPJZnn78tIjeLuox93vG4eFJ5EiTUlL4qxSKDeivMJ0mYo/8gyy6UkMaYZgQ
	8yTBOfK2BzB5aexsbYXADmElQd+58EK+co+gZAhTL2Bl/78vjDznzMfJYlob6nyo
	A5JL+9V1o82ThDmIbLZRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786102628; x=1786189028; bh=3
	Q59Aumd9RegCdWlgfhV9psGQQvAucyMQvh9lBiHEw4=; b=M8dqq961k0sKrZbvI
	Y49AP/ju2jYimNQtIwq2jMg2jSX02dmFnOPbRnVs7PuTmwX9O8Bmy5YDCc9dHedz
	2HukqFisyIJhhDWBcl7xDxGIEVNaDBJZ1jzOLM+bAfHtT37mDZl+2DBjn0mCXfs2
	2z1ychGNFKh4ZTaLO3Zj0aTjRKA5VO5TWRazezqaSTcJyJOANOyL+7uheR0uXUnI
	WW2ZEgG+bCtsGIL4kCObHqPeCnUJbbM892OWaYgVCI8ovf5SX+3mi11E/CL7yZB/
	6zdqo+/vlceTPPNbE/sdWGa7dMyTkQWk3zCMGJtDbMSVZYH12U7yeTIV1XQVTmGy
	wWQqQ==
X-ME-Sender: <xms:ZMN1avkdloX5vij4oEW3IrwsM_NIoMIv2KHSGkZiYvshh2Kzima0TA>
    <xme:ZMN1amzAjh2klwviCGMV3BUu-O9wrwfVKqXN_k9LgOZIyzdldG8nERcROPZJMNO_T
    SDSja0t__XkSGimIkaNP0ypBY0QB6YBVRTnPuOOQ_0EkL34rCvaMdQ>
X-ME-Received: <xmr:ZMN1auI19ir860HuJc3bsCLwT-i7nGdCb93pVU-YhiD71pE-aM3BSBMoH9A>
X-ME-Proxy-Cause: dmFkZTEcBCtHwgFqhRPkncf0k+1ylINMWkiJotqLKgP2XUmyCnaVLH6jJFUJYUtwVpCetV
    bzy51nCrHgVQnKUbL6xUc35a2wACIZl+NbR3y/w0ModeWlKP4SKCXfcn2Mi8esZBMBdaWx
    faB4jzBJOawj2LBnFTgyCBiywrPp7FpNgfXB5cgYmB0wgvQ/HhhWAfKjMf/weJgLhMF/VV
    yXrMoja9EZiHjuXu8bb94hiDoU2fqI8TuwJJmzzN4TUL6MxSST+GnkpA2ZnKWVewXCphJB
    Lec89iAB+bDvFyV3zsxjbJ8cA1IEQ3aF+gxi5HDHtN75oTRJtbf/Sd54tDaiXy5fa0cQtq
    r+NnXnL5OKG4MXGIn/QCfDhFT91GGYEPW5Dk96gROsGOBHkEe5+DPqNBeNl7epTFHK7f8p
    Uw3PVVm+827Wwy42lRc2goJ99LU+sSl2tIXGuLCHea6m6MmZ5cdrvcFZCfwPd3vYBRWNLj
    YANYl1XnXhaOX5VI3ShqvILc6LQm0UCwIr+TAILVga2RYCcZkuEM8MfUhmy4IA++RCLv4n
    O6VzE92iHn4+1EAhaOwdUVqHT+rzbqyGDwEHCmbGpBa4oLb4BNWyXPIFPAsAcGgy7fVEEl
    sbnR+UlqPmFLRMkMOCmGey1wr3UP+cD32tj/ZdQQ2APwiEekon4EBFwLDp+g
X-ME-Proxy: <xmx:ZMN1ahIOcpmYOAcYeEcqhYfrFgJ5xAiJfl6vyh4r9RXDAz8oyA8Dlw>
    <xmx:ZMN1alV8lDGnEGZmfHru33Byh3P7yWJ63Yybxeo-Dq2YOCIy0OtKVw>
    <xmx:ZMN1ahBgktfuG7grzq7NLmD_3J3AKNHyBcgjw6FcfmSM9kkxUdMOSA>
    <xmx:ZMN1agFtUgoBzaDWPmk2SLQQaF1vTMjrOd3chNqCJt4n0_qIaT_wrg>
    <xmx:ZMN1auGv1JjOaZ7jIMEsQ1CTJOpEpT8dDekFsAYjO2D2lSNWQHyJEkri>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 7 Aug 2026 07:37:08 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org
Subject: [PATCH v2 07/17] selftests/mm: add folio-order detection self-check
Date: Fri,  7 Aug 2026 12:36:37 +0100
Message-ID: <20260807113647.3744609-8-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807113647.3744609-1-kirill@shutemov.name>
References: <20260807113647.3744609-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 528E6100002
X-Rspam-User: 
X-Stat-Signature: uszxbbgh9aa4rqsz16qfub1p5rsh67qz
X-HE-Tag: 1786102630-256719
X-HE-Meta: U2FsdGVkX1/LdGwORhP2B+I0xPOxevegVzRul7oyvyiKpDExbeVVomHtiVIXX8Pk/VQ1XOwkteKiiSByljmE5fMr6lSR3qxiXI8leDMfG5Zg3xTgvSJailu9dnwkJ+0hpqGsTc2mxRk+7bNTu1hJhsT7VDqNkjRiqxIO0g84S6aJwPHj0G3Zrn/0b99XGqXfhok/q2TEvPIf7xcHn1YxQGLRj4O/RnszUo9fQgCQ+t8Onza25ioT7XaXuJk8oIhJRcjdtTH79Farknzfq/HlJ0DLvvIv1UvXg5LwxKTGEpSybqR88qTfZYGLxORBuqJLZBBXoV/JHJSmW7RaWNKb5QzbxVkSMiYXZ/j3Qh5o7CFPRwOaSNQWF1Yj3PXq8S6rOoOdPAmNAdzmxxTJVq16bbTzqjjmptlausB/KNNJGsThta/9ulLXuD6U9e+Wgn/i/urUt/00rqJS95JN3OaZIXRQzYB34kWThjTqXzCI8pg9Ak3eYE+Iq1m5TH73D3H7mOC9QA6FPoOXR3ThCtWJqP+HEPDoV/fNU+oYYNGDiGPq+iLldBFoUBEoWid9e4EF+xRUPCvEwv2ihhnh+32PKsriZTcfOgU097p6vIjsYfds8foVGtD+gSRFxDBm4B6/OBA3SdsZdEWH8bgITni8ghccc9vuZRhJobascglMDQLAFIZGxEDykpmVxJcPRBd5MrASS8AaFG9X4bjXdmO/MEdV5OfuUb6pyKkGPuH3dUTmM+oKN11+ESdBgXh6yX3GDqYMUUKpWkLr3xxTpGBozUbkS/aNJ9fN46phmicHUNvhEOHGUCESWx7HfuL1L1yoq/PcAjm6afGVfdUqE4+X25qDqOTx1HBMTC3z2kDcZsivgF5GHDjJgEVvck4nMwwe6z39jd2W3jE8SNfkSw9uk2jZhzog6y8sfFIYIHc3LEpnyuV3+YyUucrtuD6CWXXeJ0NSI1zAnqpVpxPnzkq
 7UueyUen
 6Azvqnubs/WP/6SgbKdpkb+vXwIpS0K417/EyAzYKW1cvcLAZiyKjN4dVbmC8XAptO3GiLDTR6tJkiD3JtCmOCkH4zSua3mgLXKrJuXInirjnjmhwDf6iw4EZkBsjsUAFs3SL1uMhJKUKH1ZNfhUNcg6eldcqjeYlfkNnb1rgLV0wQbXk//pnS4favbM1bGXXkCfJ0BpjOMYpBwSugAuaqL07xupvIUisLE0RBEn+F3Qr39otYughdYo5b9+gjKOxfJewK/owekc5bFdwTVhPEiohKXzOdaY8V14bs2RMgZnZwyewPAPzYG9s1aseWFPEzhV0+b8sbbCjhKROOyjoesqKue6nrxV/jkribiGY7i2ui7t/nz5eSRsXoqXtwNubYmez0W2Ab/pAMlNHpywrnvhxXilnwC2oxPtumg02ZmNOUr/wyHI19vuSWYdSD3vRaIfL4YZUbj4wzmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The upcoming khugepaged mTHP tests detect collapse results with the
vm_util folio-order helpers instead of smaps AnonHugePages, which only
sees PMD mappings. Before any collapse test trusts those helpers, make
sure they agree with the kernel about what backs a mapping.

For every anon THP order the kernel supports, fault memory in with
only that order enabled and require the helpers to classify the
backing as exactly that order: not a neighbouring order, and 4K-backed
memory as order 0.

Runs in the thp category of run_vmtests.sh. Verified on x86-64 4K
(orders 0, 2-9) and arm64 64K (orders 0, 2-13).

While here: ALIGN() moves into vm_util.h, where the next test that needs a
round-up can find it, and hmm-tests.c drops its own copy.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/Makefile           |   1 +
 .../testing/selftests/mm/folio_order_check.c  | 137 ++++++++++++++++++
 tools/testing/selftests/mm/hmm-tests.c        |   1 -
 tools/testing/selftests/mm/run_vmtests.sh     |   2 +
 tools/testing/selftests/mm/vm_util.h          |   2 +
 5 files changed, 142 insertions(+), 1 deletion(-)
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
index 000000000000..93030a42c3cc
--- /dev/null
+++ b/tools/testing/selftests/mm/folio_order_check.c
@@ -0,0 +1,137 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Self-check for the vm_util folio-order detection helpers,
+ * is_backed_by_folio() and is_range_backed_by_folio_orders().
+ *
+ * For every anon THP order the kernel supports, fault memory in with only
+ * that order enabled and verify the helpers report exactly that order:
+ * not a neighbouring order, and plain 4K memory as order 0. The helpers
+ * are what the khugepaged mTHP tests use to detect collapse results, so
+ * they must agree with the kernel's own idea of the backing before any
+ * collapse test relies on them.
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
+/* mmap an anon VMA of exactly @size bytes at a @size-aligned address. */
+static char *alloc_aligned(size_t size)
+{
+	size_t len = size * 2;
+	uintptr_t aligned;
+	char *p;
+
+	p = mmap(NULL, len, PROT_READ | PROT_WRITE,
+		 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (p == MAP_FAILED)
+		ksft_exit_fail_perror("mmap()");
+
+	aligned = ALIGN((uintptr_t)p, size);
+	if (aligned != (uintptr_t)p)
+		munmap(p, aligned - (uintptr_t)p);
+	if (aligned + size != (uintptr_t)p + len)
+		munmap((char *)aligned + size,
+		       (uintptr_t)p + len - aligned - size);
+
+	return (char *)aligned;
+}
+
+/*
+ * Enable only @order (order 0: nothing), fault one aligned window in and
+ * check the helpers see exactly @order.
+ */
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
+	if (!is_range_backed_by_folio_orders(p, size, order,
+					     pagemap_fd, kpageflags_fd)) {
+		ksft_print_msg("order %d not detected after fault\n", order);
+		ok = false;
+	}
+
+	/* A lower order must be rejected: the folio is larger. */
+	if (order && is_range_backed_by_folio_orders(p, size, order - 1,
+						     pagemap_fd,
+						     kpageflags_fd)) {
+		ksft_print_msg("order %d also reported as order %d\n",
+			       order, order - 1);
+		ok = false;
+	}
+
+	/* Order 0 pages must not look like any large folio, and vice versa. */
+	if (order && is_range_backed_by_folio_orders(p, size, 0,
+						     pagemap_fd,
+						     kpageflags_fd)) {
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
+		ksft_exit_skip("open(\"/proc/kpageflags\") requires root\n");
+
+	orders = thp_supported_orders();
+	if (!orders)
+		ksft_exit_skip("No supported THP orders\n");
+
+	ksft_set_plan(__builtin_popcountl(orders) + 1);
+
+	thp_save_settings();
+	thp_read_settings(&settings);
+	/* Base of the settings stack; the bottom entry is never popped. */
+	thp_push_settings(&settings);
+
+	check_order(0);
+	for (order = 1; order < NR_ORDERS; order++) {
+		if (!(orders & (1UL << order)))
+			continue;
+		check_order(order);
+	}
+
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
index 39dfb18dc10c..ce05bce4670d 100644
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


