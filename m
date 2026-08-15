Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A39A8C5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 01:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC47C6B0757; Fri, 14 Aug 2026 21:59:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE0866B0759; Fri, 14 Aug 2026 21:59:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A81CE6B075A; Fri, 14 Aug 2026 21:59:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69F926B0757
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E33E9C02B4
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:26 +0000 (UTC)
X-FDA: 85101846732.29.0B14FBF
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf05.hostedemail.com (Postfix) with ESMTP id 10054100009
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="X GnhpE2";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Stk1zm+1;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qk5GeQLVap1nnpt4hhwsoYmaxkuYR/evO/AVLGk8sYw=;
	b=qdb7kCaZXR9O/AcTPj1Y2B2HG2nbuXpl5GZ2jsSgaMNdVScTjk/jxAHmxeLXKZHtlId8zO
	UfRM5ifi3LAfJtMcqa8EGTJP0/K1Zlk+16nPgAYxs9MR075+kgSXPC8AjP+FUSkmqFHmB0
	Oy4iC1tSEqldkrg732MJV5YAKNxSdT0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="X GnhpE2";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=Stk1zm+1;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759165;
	b=Lxwuz6cFBnDyb4S1gmjDcztT22W/oXSlXJa657f/HK3N5t7OItRQ82b1aD9NI1SlabfSod
	GL1qrZn9+p1C44fOcHK5ejdp6igdCISSsdk4lvF6G9uM+LWgMGO4dXnNpU6E+1/n6hJVHY
	i2CoOI7SfeEImqXgvI13bXy1u8nz14I=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 9BA54EC0230;
	Fri, 14 Aug 2026 21:59:24 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Fri, 14 Aug 2026 21:59:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759164; x=
	1786845564; bh=Qk5GeQLVap1nnpt4hhwsoYmaxkuYR/evO/AVLGk8sYw=; b=X
	GnhpE2LagaVsynrfBAbtHRm0TW1fCoTOVNgE9FSTahYktmCHyH+9OL9j+Tx9ucMy
	mTxiB4tvfdPRiM+Gc5my6lrikPRjsoASesBLAi2OqjblNsPBeAH9OkpdQ+J6W3aa
	I9dNCDl/SP1exx1JkOuNd5u0efx1YNrbecbQl+FecoxJFfqy/X3rj/A1NRFALB49
	KUegj4s8CiS7yrc3CfVtt3ypIVHIDLMAiUPaxnBDiGX7sDigRfN3Uo2QtN2ZeRRy
	SO1ZPEsYdjMXEkvjFYnk0go5n/i2DigJ5paOqw3qPFEJBbxPvUcx1e/O1pqgwyOL
	MVbOzm65jnFzTDC3YBAEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759164; x=1786845564; bh=Q
	k5GeQLVap1nnpt4hhwsoYmaxkuYR/evO/AVLGk8sYw=; b=Stk1zm+1mYZX4Q5qu
	Wzxe5WnhuNvccHbn5+Gbutl2SnS2kLYvbbL3MQ9Ah8rH+bIi3wqnak66GIwmUEWx
	r53APhcc5t/mpF/U1ngrEdJEv3KBWdwuhpIHstaUt1+qJ8tg78PNnYk32r/SJS73
	alt0gdpOr/mE66QDZ4yrSeVIxoGFs+eLKT+miFh8BvCvkcKK+AfisL/nkg+25joe
	oAsNdwP/t3v4zNLjJ+g3Qy+hY3+TYw1tq13N4ajCg2ZykD8IIhBzxnlQMLyn2C/d
	LDtgOMQAXjaAfBw1MC4393Ky/SoMkxyJuvbMvEAUND8fLdmYf9RWMG4lqcDBzERj
	e2gJg==
X-ME-Sender: <xms:_Md_atUJARYWa1ZTym3hp9SnGjjrQw9j-0VpMxnMQfA01OxTE5M4ag>
    <xme:_Md_ahjVzOF3aIZIGPQb42qa_T5eNSdE1mkN8xRMs3C51_IpgaUeRk4RUKCLRLWQJ
    Iyy4VzjxaQRmTjNprG-V4DvI764PtBvsqRj4uQJOnlFTxvfndP2hJI>
X-ME-Received: <xmr:_Md_ah6Lh7Y3oZ2-AZPonj4PfQXztyx2vKJfYrfPt1s8ujPx0y77XzFASNU>
X-ME-Proxy-Cause: dmFkZTGF7teVIHNqoa5p2A8iL+trOmU4pExV0BsGEGBxavUqSy3vvyW/t2uVaC82ybAhbC
    FZe2jS418ApiE9B8lCjDVAvs2O/1hVxxIyd2QmVeomYKnxIQlXrdOkpVI2/A6aay1R5wM6
    752pE1oD84VvsYvCM8wHufwfHzQzVg5WF64m0thPV1o6CCL0N8QD0816LOjK9LaF9KdRdp
    ShDgDyNTb/bU59JqJj/g3oSWXYBnQXQHEYh7kafl/PHtgQjoSit3F73LPXI/q1yj04b//y
    CUybFuAxuhlNqjceRELXNaCNxBn+qS4c4JK+cmo8T/HSoyzm/Kml9mcKob58Fnvz9v9LXy
    eLiUW+PjLxDuAmmBOpd0D1WPVsF0nMCdXCvLj/x/oQhXTYJ09daqpkuW9FM7BIIiu0ytWT
    DziKyW/IY4QISCcstmaRJfwMSDthdrHiyvBbFqmZ06pJcEtaWZVbAcHlqcm777xHFQ8YXE
    4fujkbtuim/zsXlMEYlLDsn3+bznqzHFoK3j+7P4SgpfDdmkn3HAXpOSAXkv/QTSEvCZYM
    zkqJIQjHY0q119hNY27PpCplxnE01dE3k8L+VKWNJ8RwQjwBtHelaQTyO+lRtWbxngkARy
    abOG8+C8q57JzMojbeEUCducL49/SSE1TO2N0kHX78KfCiQpFrwJKTFh8Bug
X-ME-Proxy: <xmx:_Md_ap5ANzQPE4HJ7WbpJFrGymttsxfpfmcmYNvI3uYPAp37iuMOfA>
    <xmx:_Md_avHJBEQE4uxbl5reZJA-fvZcdc6jvJArm81Ccbxh_pzMzF17gA>
    <xmx:_Md_anyT7Wq9xCUkpsl_w6CALi1Cv2gIjFHDB8cgXR142JUWmmvhVQ>
    <xmx:_Md_av1Z6sc9gC0k9pKfhnklSjFeA4nqi2rYLqPNvqF3g9SrBMvRaQ>
    <xmx:_Md_an3xL2GbRb9_FJ6rlCj-jyiQAbsGWJjD_k8T_g7wBytxYCIhmeq7>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:24 -0400 (EDT)
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
Subject: [PATCH v4 09/19] selftests/mm: add folio-order detection self-check
Date: Sat, 15 Aug 2026 02:58:51 +0100
Message-ID: <20260815015901.1236937-10-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 10054100009
X-Stat-Signature: xhnmgk7wopzjx5s6q9nxxgoe3yimtf8t
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786759164-604190
X-HE-Meta: U2FsdGVkX19ACOHbllNkzKVw1x1k9Udq28jqK83KesZlY32dMYAWG8Ai+zXUIKbQbxjg/s/IHO7j2fFXNSP+Tx0MLHntuDsEgQNkTbPsf9PN9z96ty5EpUJRupEKX5ho2UhozC1yI4z8aT2jwdE7PuaNOTcNV7YU4/t99yWAhuSOKAcQaU3A3lapfF53SDsFnqwlyHnLZkfSBHxkOJlnBoDK6wV/tCwyDCngNNiLnaTJl2zjUZeo5NSaWhBO4J58bC9GOwOBal1eBAVPqfCANhsI0qHZ6xOKBe15WG628/ljbSNmyKBkDunH2xckeC23kXg4R/q2tKAMhniPcoyTOhCrAxeyniX5Huvw6CSlONMc3jh9FJN5n+zqLpfsp3IjpKuAGMYGRiHp0tT48FPGcv1w/8sk5LgmpsgPaav/NPI+efYUNHCJpU8LPHQ9dGpwZvM364WKadTb4pIsKzroXjhQcPygbCgNXTynC8aTtvUrV/fUYD6+B6P+0vlbpIP+IAIHTRODMKrHZIaFPi5f8Q4Ix3X9yVpCWtSHD79w2LUXdqcX+IUxsLE2GV2hMBs4eEQ8ptvBOzxt19YX/kiugU0eezAjpafilQDhJO5MrGBkZuQodq2gQrula3yrC0hgaIxCO9/Buu4ijEuu2oGenPdw31fYJZVuPmro8ELspt5CbfFTnORrgWlZkoMQ2SqYetn3Hm9uPkXLfYWaC4AhMKxXCM/wyqRgbxMMm+t55NCCYjIKLnwDoHWMxAn1ElRGi/fsfzjd/Wi2tBm9ANETS9Rf7T4WrgI7pk9sjiTJFuKD6FALLzQtRU27hKoI8H5waqW94EBVTDU1+o7UgXMasIsTw4M4NgTss5gU8E2Z9ACfdvUlXDXntgpHSfR8xIHaO3Dg3OQD8DLB12Dm1l2nttGXVXdwXUG+eiJIGzPXyr0+QMWQFFG0JpJitNr2fGI4KQHHl/QxfcZNyyspazm
 mJZu5LTY
 dy6aYweOFK+KwYuZVZLrtanFM58bjkwOs51+QnEOrFvIlf0WMYYecUM4LBXscjtLE0ozMJti7iOC71hCf9wb7JH4k1KEO10afn9aq8EaqoojysGQs7+ZQveSuDs8HzmCGkIjIx0HDjmYnyMuaLPlwYUA/kuhCQFt9OGAsf/YgXWBCe/sZaGEW9+heqFma2jv8dO3eDSEAfmyvLCGC/0f5J0SHvlQ1ShbXVEuaYrxp5048tZHSX3XTa6QpPnc68htaOz0M7eGQ/sQ5AkvE2mxk8AOFoGQhQ0ZRTEtz0GDa3ZQqCQJw4RbIdyNGohPSqm7lLBzGlgnGUmc25qp9sJ/5v8R1EaMO+7gPjQcZwmV/PawG/enc6Y0u2XF6MWqhLbjQpsGkHEUKVs8zwQXWyAN/784Voaaq9I1fXEMJE+iA32kgMCsnQoPjICmNuwDraz+fOF+b8/315EK0+7vPFeyMdgbqGF45No4z8C/iIU3fE0j9sLH0/OCxzo48nnkLmiqKaZgd
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
the backing as exactly that order: not a neighbouring order, and 4K-backed
memory as order 0.

Run it in the thp category, ahead of ./khugepaged, so a broken helper is
reported as itself rather than as a collapse failure.  Verified on x86-64
4K (orders 0, 2-9) and arm64 64K (orders 0, 2-13).

The test needs ALIGN(), which hmm-tests.c and migration.c each defined
privately.  Move it to vm_util.h and drop both copies.

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


