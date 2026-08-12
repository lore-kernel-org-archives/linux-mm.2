Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAD0EC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03CCB6B013E; Wed, 12 Aug 2026 09:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F08E76B0140; Wed, 12 Aug 2026 09:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1E0E6B013F; Wed, 12 Aug 2026 09:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7B6F36B0119
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0AC9D12035B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:35 +0000 (UTC)
X-FDA: 85092684390.17.18347FC
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf27.hostedemail.com (Postfix) with ESMTP id 00C9D40010
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Y 2aRuXQ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=XT0vHhyN;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541011;
	b=EnYEKfDtiNUAiWyaxdxh33ej4H8Lp9wjhnazftBVXbooNdk/Vms0zR/tRO0vI5S0BawbJW
	zMULBydc6gzLmKC3F3/SRQN2cqLXRssZHJPYwFCNGtEty2S9nBp3UEQfAoMHzWJw9Fok2P
	+cFdiVrT6E6ckjg7/pwQ+TCyZ/BVMKA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="Y 2aRuXQ";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=XT0vHhyN;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eV+c3895JCTdH1VJjEuBsFvGHhdtHUWemWq2+damYtQ=;
	b=QwBOjRmRsmImYdcFuVIRCIchwtIci7rId1TDImLVHxZZnqdH6MwUTsxYXJAnGAbvfFCY01
	fPGMa6AdhXtCKkzDHylXG6HDtqRZ9nq74tCWLrmYYggIbejpZkIOY8gwhBrAionks/ha9O
	4LmgzO5t4DZ44196QhGdMhkPRXBYk18=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.stl.internal (Postfix) with ESMTP id CF1877A015F;
	Wed, 12 Aug 2026 09:23:29 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 12 Aug 2026 09:23:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786541009; x=
	1786627409; bh=eV+c3895JCTdH1VJjEuBsFvGHhdtHUWemWq2+damYtQ=; b=Y
	2aRuXQhyHjkKd1QYCLfq3PlNdfxXF2j3x3C8qlHoqHlX/rkNfbzNfTx8gLlmCsjt
	frBXJK9mZscWUaX0CbUwekyFNa/xp+pMpvqKpM003vGeB9E/uxSPt422TUxeI1pu
	H05cK34WJplIq9l1yl1kXXxgUycd6zmwLcIwyvV0qqJWNaZobfrPho7s4cvumPYQ
	dXe9/ClGBhEqZBNHqseCcW9nx28MWce4yk/lzHgVdAhsQhKa+JTwz7WCMFVb0G+u
	3qA07B/9AYK4o1IHWPzMuGo5RFIapbJ0ueNbHNnC//Pwrbcw6Oe2PWK1VRDdxtc4
	Yl+x1SAA4Gm+qu7g4oLAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786541009; x=1786627409; bh=e
	V+c3895JCTdH1VJjEuBsFvGHhdtHUWemWq2+damYtQ=; b=XT0vHhyNr/jesPv6Q
	VX0YnJt2YxvhOqeI6fyPGxDTW52oUNd7hkLqd+129F8HU5BzxDi7NsA6V+V2HcCV
	916NTzORmL6OHOADG7SjRJgC48SxTdirNzoXLLlftorN2bvFzCq78Cp2dAp1sJqA
	/U/siWtzoissMESH0rcqHdf6OnhQqX2swlOKUigvB518nUQZ0tevzdZUABJZrqmW
	+/tSfCSnIKVF063oOON3EYKXZn8XN/e6gTCoes4SldVYRDM4H4I/WZzUxcKFy9lP
	LySje7yMXvDIE0cPP6YhO9BaU7If0mT5Lk7OhrJwPyM5RZhlmD0jt/brQQIyY3kM
	/vn1Q==
X-ME-Sender: <xms:0XN8ahQhq7ScG5R96gximdDiebNQ5mwHO-lwnwKMxQtMCUAhOHx7MQ>
    <xme:0XN8autUL1GTOHBK7w5_-J3gmWLWbWqy1zmA4h3qToNcgKksTX9E_2-M2r7mfIKil
    AO2a8om_ac2Vy8tjyZ3YhPYvATdsMkyF5wO8wukGPObNd8ayGxhhlM>
X-ME-Received: <xmr:0XN8avWJ03KPoJsld8BHaUHRPrditTVwSnQ3axhcFIKBCIcjGYvmc_XZp-I>
X-ME-Proxy-Cause: dmFkZTFzqtrNoSTXX2MRzKyN6p8XXqdjDSX08KYyJpXp82eYC1ae2GegaTOhbDzreYT/K0
    OAsc1zsfjWszwuQXvOMxV3FM9x50+HqAsA48u5Kq52QtHo+TJJPCEG+EOeKn5Il8AepNuY
    amkSO7LHncjzMJKy/SPUs50UUrTlzGP0ayf7b+h/q5NreZMQSrrfXSzcd6tsdBCg4Hhmbc
    7COQKDHpqWJD3HpoJ7/Bw0J3tcRV9tZIkmRGQ4nZ/O76iTBc+eN6GYtayu9aLLTJal0DNN
    hI5LqlugC7KhSFwlZIIFqKKnJB7XY7vZnEBEdRJ8Mvpq9sE5OflKN5J+H3ujbniJsnhlPB
    GEVJb5AijGvAC/NfopsI7czdo2wONzWrV/c4G9br9asrjG5pXZXAqMU7dITwfFGwUqL5H7
    Tt9EK0KvS5pS8oQqKEsQj+/gU1mEhUmzFys1sm1kG0Hx3rtMQdzqXrLd0yamhSyBWOgH8B
    BMA1jaxo1CXtHaGldha0M2yx5byWDwdQM/9pPpxbnBhC0d/2tmPCiF79DZ+mln+zzKedZF
    z3DHrwJ/hkLHGyYTJyVcRgmqKYrIVYma/O5X8snp0s51EKg0vzdvkGdOOjoLPDiZmw0fXs
    0+PIF83+Fu7S1EwOCgEcfFcvW1c+ZFSv6ULiKU+o4EmBlD/rWgXOnST6UGJw
X-ME-Proxy: <xmx:0XN8ainsuwecdNHdz9her_roCfee90U9588MSuiLzbVzOdEbzlebcw>
    <xmx:0XN8aiC2xDMUcKKdUJO9nenAhR5g5kpBhM3IrN4XGhWHK7Q329vMbg>
    <xmx:0XN8an9dK2vzSUphfPKE-1QKPRUMzPIEkoFr48SH1dQYuNiRhw0PnQ>
    <xmx:0XN8akQPfDo8qt3rN05vX0SAPtbnLabRpVnQ21UchGtlkKA4nnl7jw>
    <xmx:0XN8aqyyUHHiiicqq_f15ct6YB9p9ML5SwFhfk1ZwlO58HxqojzCimnD>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 09:23:28 -0400 (EDT)
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
Subject: [PATCH v3 08/18] selftests/mm: add folio-order detection self-check
Date: Wed, 12 Aug 2026 14:22:54 +0100
Message-ID: <20260812132304.199287-9-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812132304.199287-1-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 00C9D40010
X-Stat-Signature: 1ys8wk7xkygf1mrmiizi69qm58yn1fwh
X-HE-Tag: 1786541010-951228
X-HE-Meta: U2FsdGVkX1+hpqJOUz3WNhhtKbY5kUCvvrtMsTXL6mA2t+1h52N7Ht2zurIelE60oAPVn0deP17IIxRgZ8/RWaEcbHSP1fjaiWG5EWKnU1cUoSHMSx7ay8ctdoy2xfJl7y3anBom0qeDwtp714EzI1v4gN1Lm6MJTo+hrY4os4kvRkGneF5q1Lo80V2wSyBgXcShSZxwXWZ8vqn246rqQuplp4vacfC1YfUeNOR7+0ilDO2Soyq+GGSUKXmOtgj6QDqmufcwhwf+dwZpXxNByBkyIHzxXASeEgjHSuXcrEHYJHg1/rvwJyYvZQJ5uw7LFH4a/BNtfmwu8K+ajeLw13k0+c72btfFGEzjiiUPXiM8JEgngQ34fGwuOfhEzASbihnCvvo4E7waa5Qqt9V/PzIgCSudfwLqKDSfHKKHekrAaHNgrE5HGDyQ/VGSOXFnfZmh7nsbqJtKO+ohBJ7k9IhFGz4DNK49sLZDiEhkFv4hzxlvl0Ss+JoASoSdERDOvDR0eb/cGQefCsyAL4dHqlFVCZBNAvaRIlG8BDf7EFjmu0pTsOvoeHeKRaQgLrDGbeZ63yJZEKjTPacH19gMOaq0b0a+Q+eZgggxYipUmbRLyt6NuqKS7dHhdkvVXi1D029ooVyTpL0aCiNzfLpSDD9YNsPNxlIngVjoaz+U8rirnLSLqcMBy46fgoVwhA0oj7lRTGFx5GBZ99AkDmV/e8Qn8uPy7bNAZ2RWi9Yk7z+cTHvmJYK+1u6jMEBCfE15rohLOYXcyTsJhzMTM9byl9Pm6Xn7EtkvZ/NVwBCsirtaGksi0Rf2eypHoljskAxCxrxisODii/+8QZFQE08arsUkGaVfS7ZZqz6PCgxM8OMdEd+0EL76ollxxZkjhGEMyAMnbu+RA2EhnL9rmylvfZ5gwSDz+VGzDElQPXisTZWzO0Dn4qGv8lNCnoHicLHGAM4SU8STlX3udpAMKqi
 2ttG+7nT
 A+kwd8sS+XT5TWVHCe6nKB2Lh09iRdxX4bLPnV6sceRt9ZSAhIMPESZHkyyXeA7l/dUrBY6sypYhvq7MRWMX2u93NI4lecg9K8TI9CcJ9Fv5x6kE1g32HoRUaSZi7IW416JPGp8x81e6Tv4dhQ5DDulJekqGhSGrE8NuGW7Gx9xYwLHgvFNJKmsqw2owYfu0KsPmXjcjZfOwRrEBRk9hli13HFSCRg176nboSPaxQ8OPNJlN9jK+BdGLZZyJraHUVxiwPyXb8DG23nJxikPodHfjoPb4BsTB3OC6uWJOTpOuIfbE6ksUO8qzzMZCRYomttL2HjHqD/yJ43xG6IebzOa0IxjuPhXiDTdOlShY0HbyHlIEx95gztKTEMGI58zWTYNxhgjvCEdNNF6hrwG2TrlIik8L4DzFTq1zYO4q/NbhLyv5KewjKTbG74KEoL5z99pJ/e/Equx1T3gtjq2g31CeUyhf7WHrP+mglNRQHWhAFhNQ+z3CJG17/h6e572m0ylRO
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
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/Makefile           |   1 +
 .../testing/selftests/mm/folio_order_check.c  | 137 ++++++++++++++++++
 tools/testing/selftests/mm/hmm-tests.c        |   1 -
 tools/testing/selftests/mm/migration.c        |   1 -
 tools/testing/selftests/mm/run_vmtests.sh     |   2 +
 tools/testing/selftests/mm/vm_util.h          |   2 +
 6 files changed, 142 insertions(+), 2 deletions(-)
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


