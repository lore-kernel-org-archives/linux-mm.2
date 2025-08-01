Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CE9C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 10:06:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F7B96B007B; Fri,  1 Aug 2025 06:06:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A8676B0088; Fri,  1 Aug 2025 06:06:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297716B008A; Fri,  1 Aug 2025 06:06:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F0C06B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 06:06:42 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B369D1A149B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:06:41 +0000 (UTC)
X-FDA: 83727759402.15.E42ABD9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 03BBD12000C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:06:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AdjhJ4oL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754042800; a=rsa-sha256;
	cv=none;
	b=0N2TGJOWbvGnpwBIXAZMGsxuZaWsbIJ9dIWhDBLy5aL4lWTgAxSSerkbLNk2kOfKos3Z10
	EeSvSTkXUcx7yVIdNsCIA8yaiJutDTaBx+dPOg+mF28v7haGxkUVH2qUdX3ugXrY6DqDEC
	iFRvLLelWsNcCFPW1SvgJZ717CuJsFs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AdjhJ4oL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754042800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ShUqQG6BjoxuL7p/FUlwcxPl6a9vn6L2r3Z/nAMiwPo=;
	b=5JXYSXlhhq78tSWJdxXIWSqJ2DOX4/zbFvMk/7L4X2TfwCsNAeADhMkQyH18y0CdsOt/NT
	MUrFNacc+0QBvZaas5n80I3A3c3hlo37etKCMwvrHFBrusT1jatZK1F23+N1Whe0Zud6jx
	jawMCxksBbYS383K3aeMrI8WBHrgDJ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B79EA41A14;
	Fri,  1 Aug 2025 10:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D2FC4CEE7;
	Fri,  1 Aug 2025 10:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754042798;
	bh=z7l3h/eJxDqkOrIqr9TIJ3RWiy088wOwHcu0LhVd6CA=;
	h=From:To:Cc:Subject:Date:From;
	b=AdjhJ4oLP5HPb7GpOKzMpQAyJUxgtAmo13AH20OvGzPDyd/QmujtR8oWONjd3m8Fu
	 tPYwJq1PwenpUeqTrPDhtbOUaaYdHRpLXnwMqXk5reh6cNRzrj2S+lNKUH5NH+HAUV
	 abASmBIB3peglZF8Wf25qIoHGn2DDwSeuhVEe7lYQsjbybk7U03WwHW7p75HV7oEq1
	 Ls+pdOkkbxwZMn8Or3JNs3HVUWCAKH9o/swJ5nUjonp1srl3eeLE5FuW4zLT5+YWQc
	 qXdN9PIjCMrFZh43YmL1IZUMJxUCSD/k/7LLPPmZEaafAFvzNR2xSgxZAY7XIi4kxo
	 SzYjfNgH5S+aw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=DFschuh?= <linux@weissschuh.net>,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2] kho: add test for kexec handover
Date: Fri,  1 Aug 2025 13:06:30 +0300
Message-ID: <20250801100630.3473918-1-rppt@kernel.org>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 03BBD12000C
X-Stat-Signature: 9q4ns6y6hnprbqktpcizuhif1tdw7f8k
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754042799-6188
X-HE-Meta: U2FsdGVkX19GfDpV7Dxq2/vP1XQfrqd3SgcMpHrI1R172Mg2/SllPPr7O4bBNOiEsVXYCIioNZr15vvetTlVYz8Ex0XBd9sFypqhnI5RbWOs5yYyPDouez83YZQSmbpO7AHn4jcbt3bcZvSd5MnHIwGUQUmJFxv2W4S1dVSzkCuOOAuQ5DocLoKsrBj7YDuyTaprcwy3/ny7C6/LLRaR+c5l6fas/Q1mhJ/I84JZ+bpbN9d5nfWEIkuuBAcj7jjA5Cs/ZsqZYE5zFID4ckQPg7ufMx6Tqb29FgBpRQPtJTrQlAMCV03qeKr4PM8v+B2jlTqiVtYHCxrefHGQbDsWk0c2kaKrRjfw8aBYBd296uofeM4srI6FNbI1DE1GtL7veV52ODJ2NhMb1dBxamN0L3cqg4S5szIUi6Q7UIF2BtnTrSUWrSCRovvhAuOhDUSvB1naSR3CUzcqk5RmddaqrAGVsvrYPj6KYno1Kxl7Xt4kPfLnggAHWsAadPI5kSNt2nv0pf3xwV7dIyBWOYKUjVO7JahnRONn8fcVVoTNAy0jU5tmWTwkrRPfPrOnRodb0huwIX2/+iggFS0oegzTPl9ZpJYmI98eClHmuj4raCHJFCFhIndgHuh3kdm0QSy/YNEN8rUueUoGgtCZ1YysobvreKY5CPTXGAbQ3iz8+Rwh+9u7493nvW9S7fmhcV9w3eXhbuzaxETmZ8Y+V5MbOFDyHvZfKTn8Q9CEMmmuULA6Fx59PU+NOZIQ2oy3uR8HUj7IPy3MVsm0Xstv+j8pLZlflfKr21bvSXdFfFlyDONNNMn8QqSKwtKV0cvSc5gruSesdq7M7rPNLt5FU4wYh8Ds5EPe8FEs2qwddu1zUTw+QtgrEdsfaPo6bx2BfBZ+2QxwZ+CubMOPG/qIXXt9vhYwZyj86QAH+1py20y3oe0UU+BvUNNRNZHbhxw2rR0UgzBhAmNZe5ISuYXH1b8
 n74VpQkG
 ZhDc7MSCi1OXOU85awPoxgUaZXfTn7M+xAiw2uZGyRtMmkGYihzL5oXdWUSkzxcyNAg8IhomTkm1gqlu/O1zP+fiHBDmE8BHZgfVkT1CGWI23tPC84oGD0YV54/K/p4d9Dn/l9a9TkwIZayLh0fgwrH9Mna0XTgcCNvMM6ttZ1OaAmPTsPY6o2kA+o8FM9/Ad16Id35UXJxb5lEyPBVQn0AXXM0/Kls5PPWaiH6eiaw1bBIhfKyZcBHS3WAayNdeV67JsbD8HNOCKGi9p3re51uN6gXQ+kLoqQTORZgzLsNRLWV5KkVZum7eMpQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Testing kexec handover requires a kernel driver that will generate some
data and preserve it with KHO on the first boot and then restore that
data and verify it was preserved properly after kexec.

To facilitate such test, along with the kernel driver responsible for
data generation, preservation and restoration add a script that runs a
kernel in a VM with a minimal /init. The /init enables KHO, loads a
kernel image for kexec and runs kexec reboot. After the boot of the
kexeced kernel, the driver verifies that the data was properly
preserved.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v2 changes:
* fix section mismatch warning in lib/test_kho.c
* address Thomas' comments about nolibc and initrd generation

v1: https://lore.kernel.org/all/20250727083733.2590139-1-rppt@kernel.org

 MAINTAINERS                            |   1 +
 lib/Kconfig.debug                      |  21 ++
 lib/Makefile                           |   1 +
 lib/test_kho.c                         | 305 +++++++++++++++++++++++++
 tools/testing/selftests/kho/arm64.conf |   9 +
 tools/testing/selftests/kho/init.c     |  98 ++++++++
 tools/testing/selftests/kho/vmtest.sh  | 185 +++++++++++++++
 tools/testing/selftests/kho/x86.conf   |   7 +
 8 files changed, 627 insertions(+)
 create mode 100644 lib/test_kho.c
 create mode 100644 tools/testing/selftests/kho/arm64.conf
 create mode 100644 tools/testing/selftests/kho/init.c
 create mode 100755 tools/testing/selftests/kho/vmtest.sh
 create mode 100644 tools/testing/selftests/kho/x86.conf

diff --git a/MAINTAINERS b/MAINTAINERS
index 10850512c118..7eada657c5e6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13356,6 +13356,7 @@ F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
 F:	kernel/kexec_handover.c
+F:	tools/testing/selftests/kho/
 
 KEYS-ENCRYPTED
 M:	Mimi Zohar <zohar@linux.ibm.com>
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index ebe33181b6e6..4f82d38e3c45 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -3225,6 +3225,27 @@ config TEST_OBJPOOL
 
 	  If unsure, say N.
 
+config TEST_KEXEC_HANDOVER
+	bool "Test for Kexec HandOver"
+	default n
+	depends on KEXEC_HANDOVER
+	help
+	  This option enables test for Kexec HandOver (KHO).
+	  The test consists of two parts: saving kernel data before kexec and
+	  restoring the data after kexec and verifying that it was properly
+	  handed over. This test module creates and saves data on the boot of
+	  the first kernel and restores and verifies the data on the boot of
+	  kexec'ed kernel.
+
+	  For detailed documentation about KHO, see Documentation/core-api/kho.
+
+	  To run the test run:
+
+	  tools/testing/selftests/kho/vmtest.sh -h
+
+	  If unsure, say N.
+
+
 config INT_POW_KUNIT_TEST
 	tristate "Integer exponentiation (int_pow) test" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/Makefile b/lib/Makefile
index c38582f187dd..6a8d00aac3a8 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -102,6 +102,7 @@ obj-$(CONFIG_TEST_HMM) += test_hmm.o
 obj-$(CONFIG_TEST_FREE_PAGES) += test_free_pages.o
 obj-$(CONFIG_TEST_REF_TRACKER) += test_ref_tracker.o
 obj-$(CONFIG_TEST_OBJPOOL) += test_objpool.o
+obj-$(CONFIG_TEST_KEXEC_HANDOVER) += test_kho.o
 
 obj-$(CONFIG_TEST_FPU) += test_fpu.o
 test_fpu-y := test_fpu_glue.o test_fpu_impl.o
diff --git a/lib/test_kho.c b/lib/test_kho.c
new file mode 100644
index 000000000000..c2eb899c3b45
--- /dev/null
+++ b/lib/test_kho.c
@@ -0,0 +1,305 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Test module for KHO
+ * Copyright (c) 2025 Microsoft Corporation.
+ *
+ * Authors:
+ *   Saurabh Sengar <ssengar@microsoft.com>
+ *   Mike Rapoport <rppt@kernel.org>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/mm.h>
+#include <linux/gfp.h>
+#include <linux/slab.h>
+#include <linux/kexec.h>
+#include <linux/libfdt.h>
+#include <linux/module.h>
+#include <linux/printk.h>
+#include <linux/vmalloc.h>
+#include <linux/kexec_handover.h>
+
+#include <net/checksum.h>
+
+#define KHO_TEST_MAGIC	0x4b484f21	/* KHO! */
+#define KHO_TEST_FDT	"kho_test"
+#define KHO_TEST_COMPAT "kho-test-v1"
+
+static long max_mem = (PAGE_SIZE << MAX_PAGE_ORDER) * 2;
+module_param(max_mem, long, 0644);
+
+struct kho_test_state {
+	unsigned int nr_folios;
+	struct folio **folios;
+	struct folio *fdt;
+	__wsum csum;
+};
+
+static struct kho_test_state kho_test_state;
+
+static int kho_test_notifier(struct notifier_block *self, unsigned long cmd,
+			     void *v)
+{
+	struct kho_test_state *state = &kho_test_state;
+	struct kho_serialization *ser = v;
+	int err = 0;
+
+	switch (cmd) {
+	case KEXEC_KHO_ABORT:
+		return NOTIFY_DONE;
+	case KEXEC_KHO_FINALIZE:
+		/* Handled below */
+		break;
+	default:
+		return NOTIFY_BAD;
+	}
+
+	err |= kho_preserve_folio(state->fdt);
+	err |= kho_add_subtree(ser, KHO_TEST_FDT, folio_address(state->fdt));
+
+	return err ? NOTIFY_BAD : NOTIFY_DONE;
+}
+
+static struct notifier_block kho_test_nb = {
+	.notifier_call = kho_test_notifier,
+};
+
+static int kho_test_save_data(struct kho_test_state *state, void *fdt)
+{
+	phys_addr_t *folios_info __free(kvfree) = NULL;
+	int err = 0;
+
+	folios_info = kvmalloc_array(state->nr_folios, sizeof(*folios_info),
+				     GFP_KERNEL);
+	if (!folios_info)
+		return -ENOMEM;
+
+	for (int i = 0; i < state->nr_folios; i++) {
+		struct folio *folio = state->folios[i];
+		unsigned int order = folio_order(folio);
+
+		folios_info[i] = virt_to_phys(folio_address(folio)) | order;
+
+		err = kho_preserve_folio(folio);
+		if (err)
+			return err;
+	}
+
+	err |= fdt_begin_node(fdt, "data");
+	err |= fdt_property(fdt, "nr_folios", &state->nr_folios,
+			    sizeof(state->nr_folios));
+	err |= fdt_property(fdt, "folios_info", folios_info,
+			    state->nr_folios * sizeof(*folios_info));
+	err |= fdt_property(fdt, "csum", &state->csum, sizeof(state->csum));
+	err |= fdt_end_node(fdt);
+
+	return err;
+}
+
+static int kho_test_prepare_fdt(struct kho_test_state *state)
+{
+	const char compatible[] = KHO_TEST_COMPAT;
+	unsigned int magic = KHO_TEST_MAGIC;
+	ssize_t fdt_size;
+	int err = 0;
+	void *fdt;
+
+	fdt_size = state->nr_folios * sizeof(phys_addr_t) + PAGE_SIZE;
+	state->fdt = folio_alloc(GFP_KERNEL, get_order(fdt_size));
+	if (!state->fdt)
+		return -ENOMEM;
+
+	fdt = folio_address(state->fdt);
+
+	err |= fdt_create(fdt, fdt_size);
+	err |= fdt_finish_reservemap(fdt);
+
+	err |= fdt_begin_node(fdt, "");
+	err |= fdt_property(fdt, "compatible", compatible, sizeof(compatible));
+	err |= fdt_property(fdt, "magic", &magic, sizeof(magic));
+	err |= kho_test_save_data(state, fdt);
+	err |= fdt_end_node(fdt);
+
+	err |= fdt_finish(fdt);
+
+	if (err)
+		folio_put(state->fdt);
+
+	return err;
+}
+
+static int kho_test_generate_data(struct kho_test_state *state)
+{
+	size_t alloc_size = 0;
+	__wsum csum = 0;
+
+	while (alloc_size < max_mem) {
+		int order = get_random_u32() % NR_PAGE_ORDERS;
+		struct folio *folio;
+		unsigned int size;
+		void *addr;
+
+		/* cap allocation so that we won't exceed max_mem */
+		if (alloc_size + (PAGE_SIZE << order) > max_mem) {
+			order = get_order(max_mem - alloc_size);
+			if (order)
+				order--;
+		}
+		size = PAGE_SIZE << order;
+
+		folio = folio_alloc(GFP_KERNEL | __GFP_NORETRY, order);
+		if (!folio)
+			goto err_free_folios;
+
+		state->folios[state->nr_folios++] = folio;
+		addr = folio_address(folio);
+		get_random_bytes(addr, size);
+		csum = csum_partial(addr, size, csum);
+		alloc_size += size;
+	}
+
+	state->csum = csum;
+	return 0;
+
+err_free_folios:
+	for (int i = 0; i < state->nr_folios; i++)
+		folio_put(state->folios[i]);
+	return -ENOMEM;
+}
+
+static int kho_test_save(void)
+{
+	struct kho_test_state *state = &kho_test_state;
+	struct folio **folios __free(kvfree) = NULL;
+	unsigned long max_nr;
+	int err;
+
+	max_mem = PAGE_ALIGN(max_mem);
+	max_nr = max_mem >> PAGE_SHIFT;
+
+	folios = kvmalloc_array(max_nr, sizeof(*state->folios), GFP_KERNEL);
+	if (!folios)
+		return -ENOMEM;
+	state->folios = folios;
+
+	err = kho_test_generate_data(state);
+	if (err)
+		return err;
+
+	err = kho_test_prepare_fdt(state);
+	if (err)
+		return err;
+
+	return register_kho_notifier(&kho_test_nb);
+}
+
+static int kho_test_restore_data(const void *fdt, int node)
+{
+	const unsigned int *nr_folios;
+	const phys_addr_t *folios_info;
+	const __wsum *old_csum;
+	__wsum csum = 0;
+	int len;
+
+	node = fdt_path_offset(fdt, "/data");
+
+	nr_folios = fdt_getprop(fdt, node, "nr_folios", &len);
+	if (!nr_folios || len != sizeof(*nr_folios))
+		return -EINVAL;
+
+	old_csum = fdt_getprop(fdt, node, "csum", &len);
+	if (!old_csum || len != sizeof(*old_csum))
+		return -EINVAL;
+
+	folios_info = fdt_getprop(fdt, node, "folios_info", &len);
+	if (!folios_info || len != sizeof(*folios_info) * *nr_folios)
+		return -EINVAL;
+
+	for (int i = 0; i < *nr_folios; i++) {
+		unsigned int order = folios_info[i] & ~PAGE_MASK;
+		phys_addr_t phys = folios_info[i] & PAGE_MASK;
+		unsigned int size = PAGE_SIZE << order;
+		struct folio *folio;
+
+		folio = kho_restore_folio(phys);
+		if (!folio)
+			break;
+
+		if (folio_order(folio) != order)
+			break;
+
+		csum = csum_partial(folio_address(folio), size, csum);
+		folio_put(folio);
+	}
+
+	if (csum != *old_csum)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int kho_test_restore(phys_addr_t fdt_phys)
+{
+	void *fdt = phys_to_virt(fdt_phys);
+	const unsigned int *magic;
+	int node, len, err;
+
+	node = fdt_path_offset(fdt, "/");
+	if (node < 0)
+		return -EINVAL;
+
+	if (fdt_node_check_compatible(fdt, node, KHO_TEST_COMPAT))
+		return -EINVAL;
+
+	magic = fdt_getprop(fdt, node, "magic", &len);
+	if (!magic || len != sizeof(*magic))
+		return -EINVAL;
+
+	if (*magic != KHO_TEST_MAGIC)
+		return -EINVAL;
+
+	err = kho_test_restore_data(fdt, node);
+	if (err)
+		return err;
+
+	pr_info("KHO restore succeeded\n");
+	return 0;
+}
+
+static int __init kho_test_init(void)
+{
+	phys_addr_t fdt_phys;
+	int err;
+
+	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys);
+	if (!err)
+		return kho_test_restore(fdt_phys);
+
+	if (err != -ENOENT) {
+		pr_warn("failed to retrieve %s FDT: %d\n", KHO_TEST_FDT, err);
+		return err;
+	}
+
+	return kho_test_save();
+}
+module_init(kho_test_init);
+
+static void kho_test_cleanup(void)
+{
+	for (int i = 0; i < kho_test_state.nr_folios; i++)
+		folio_put(kho_test_state.folios[i]);
+
+	kvfree(kho_test_state.folios);
+}
+
+static void __exit kho_test_exit(void)
+{
+	unregister_kho_notifier(&kho_test_nb);
+	kho_test_cleanup();
+}
+module_exit(kho_test_exit);
+
+MODULE_AUTHOR("Mike Rapoport <rppt@kernel.org>");
+MODULE_DESCRIPTION("KHO test module");
+MODULE_LICENSE("GPL");
diff --git a/tools/testing/selftests/kho/arm64.conf b/tools/testing/selftests/kho/arm64.conf
new file mode 100644
index 000000000000..ee696807cd35
--- /dev/null
+++ b/tools/testing/selftests/kho/arm64.conf
@@ -0,0 +1,9 @@
+QEMU_CMD="qemu-system-aarch64 -M virt -cpu max"
+QEMU_KCONFIG="
+CONFIG_SERIAL_AMBA_PL010=y
+CONFIG_SERIAL_AMBA_PL010_CONSOLE=y
+CONFIG_SERIAL_AMBA_PL011=y
+CONFIG_SERIAL_AMBA_PL011_CONSOLE=y
+"
+KERNEL_IMAGE="Image"
+KERNEL_CMDLINE="console=ttyAMA0"
diff --git a/tools/testing/selftests/kho/init.c b/tools/testing/selftests/kho/init.c
new file mode 100644
index 000000000000..8044ca56fff5
--- /dev/null
+++ b/tools/testing/selftests/kho/init.c
@@ -0,0 +1,98 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/syscall.h>
+#include <sys/mount.h>
+#include <sys/reboot.h>
+
+/* from arch/x86/include/asm/setup.h */
+#define COMMAND_LINE_SIZE	2048
+
+/* from include/linux/kexex.h */
+#define KEXEC_FILE_NO_INITRAMFS	0x00000004
+
+#define KHO_FINILIZE "/debugfs/kho/out/finalize"
+#define KERNEL_IMAGE "/kernel"
+
+static int mount_filesystems(void)
+{
+	if (mount("debugfs", "/debugfs", "debugfs", 0, NULL) < 0)
+		return -1;
+
+	return mount("proc", "/proc", "proc", 0, NULL);
+}
+
+static int kho_enable(void)
+{
+	const char enable[] = "1";
+	int fd;
+
+	fd = open(KHO_FINILIZE, O_RDWR);
+	if (fd < 0)
+		return -1;
+
+	if (write(fd, enable, sizeof(enable)) != sizeof(enable))
+		return 1;
+
+	close(fd);
+	return 0;
+}
+
+static long kexec_file_load(int kernel_fd, int initrd_fd,
+			    unsigned long cmdline_len, const char *cmdline,
+			    unsigned long flags)
+{
+	return syscall(__NR_kexec_file_load, kernel_fd, initrd_fd, cmdline_len,
+		       cmdline, flags);
+}
+
+static int kexec_load(void)
+{
+	char cmdline[COMMAND_LINE_SIZE];
+	ssize_t len;
+	int fd, err;
+
+	fd = open("/proc/cmdline", O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	len = read(fd, cmdline, sizeof(cmdline));
+	close(fd);
+	if (len < 0)
+		return -1;
+
+	/* replace \n with \0 */
+	cmdline[len - 1] = 0;
+	fd = open(KERNEL_IMAGE, O_RDONLY);
+	if (fd < 0)
+		return -1;
+
+	err = kexec_file_load(fd, -1, len, cmdline, KEXEC_FILE_NO_INITRAMFS);
+	close(fd);
+
+	return err ? : 0;
+}
+
+int main(int argc, char *argv[])
+{
+	if (mount_filesystems())
+		goto err_reboot;
+
+	if (kho_enable())
+		goto err_reboot;
+
+	if (kexec_load())
+		goto err_reboot;
+
+	if (reboot(RB_KEXEC))
+		goto err_reboot;
+
+	return 0;
+
+err_reboot:
+	reboot(RB_AUTOBOOT);
+	return -1;
+}
diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
new file mode 100755
index 000000000000..3f6c17166846
--- /dev/null
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -0,0 +1,185 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+set -ue
+
+CROSS_COMPILE="${CROSS_COMPILE:-""}"
+
+test_dir=$(realpath "$(dirname "$0")")
+kernel_dir=$(realpath "$test_dir/../../../..")
+
+tmp_dir=$(mktemp -d /tmp/kho-test.XXXXXXXX)
+headers_dir="$tmp_dir/usr"
+initrd="$tmp_dir/initrd.cpio"
+
+source "$test_dir/../kselftest/ktap_helpers.sh"
+
+function usage() {
+	cat <<EOF
+$0 [-d build_dir] [-j jobs] [-t target_arch] [-h]
+Options:
+	-d)	path to the kernel build directory
+	-j)	number of jobs for compilation, similar to -j in make
+	-t)	run test for target_arch, requires CROSS_COMPILE set
+		supported targets: aarch64, x86_64
+	-h)	display this help
+EOF
+}
+
+function cleanup() {
+	rm -fr "$tmp_dir"
+	ktap_finished
+}
+trap cleanup EXIT
+
+function skip() {
+	local msg=${1:-""}
+
+	ktap_test_skip "$msg"
+	exit "$KSFT_SKIP"
+}
+
+function fail() {
+	local msg=${1:-""}
+
+	ktap_test_fail "$msg"
+	exit "$KSFT_FAIL"
+}
+
+function build_kernel() {
+	local build_dir=$1
+	local make_cmd=$2
+	local arch_kconfig=$3
+	local kimage=$4
+
+	local kho_config="$tmp_dir/kho.config"
+	local kconfig="$build_dir/.config"
+
+	# enable initrd, KHO and KHO test in kernel configuration
+	tee "$kconfig" > "$kho_config" <<EOF
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_KEXEC_HANDOVER=y
+CONFIG_TEST_KEXEC_HANDOVER=y
+CONFIG_DEBUG_KERNEL=y
+CONFIG_DEBUG_VM=y
+$arch_kconfig
+EOF
+
+	make_cmd="$make_cmd -C $kernel_dir O=$build_dir"
+	$make_cmd olddefconfig
+
+	# verify that kernel confiration has all necessary options
+	while read -r opt ; do
+		grep "$opt" "$kconfig" &>/dev/null || skip "$opt is missing"
+	done < "$kho_config"
+
+	$make_cmd "$kimage"
+	$make_cmd headers_install INSTALL_HDR_PATH="$headers_dir"
+}
+
+function mkinitrd() {
+	local kernel=$1
+
+	"$CROSS_COMPILE"gcc -s -static -Os -nostdinc -nostdlib \
+			-fno-asynchronous-unwind-tables -fno-ident \
+			-I "$headers_dir/include" \
+			-I "$kernel_dir/tools/include/nolibc" \
+			-o "$tmp_dir/init" "$test_dir/init.c"
+
+	cat > "$tmp_dir/cpio_list" <<EOF
+dir /dev 0755 0 0
+dir /proc 0755 0 0
+dir /debugfs 0755 0 0
+nod /dev/console 0600 0 0 c 5 1
+file /init $tmp_dir/init 0755 0 0
+file /kernel $kernel 0644 0 0
+EOF
+
+	"$build_dir/usr/gen_init_cpio" "$tmp_dir/cpio_list" > "$initrd"
+}
+
+function run_qemu() {
+	local qemu_cmd=$1
+	local cmdline=$2
+	local kernel=$3
+	local serial="$tmp_dir/qemu.serial"
+
+	cmdline="$cmdline kho=on panic=-1"
+
+	$qemu_cmd -m 1G -smp 2 -no-reboot -nographic -nodefaults \
+		  -accel kvm -accel hvf -accel tcg  \
+		  -serial file:"$serial" \
+		  -append "$cmdline" \
+		  -kernel "$kernel" \
+		  -initrd "$initrd"
+
+	grep "KHO restore succeeded" "$serial" &> /dev/null || fail "KHO failed"
+}
+
+function target_to_arch() {
+	local target=$1
+
+	case $target in
+	     aarch64) echo "arm64" ;;
+	     x86_64) echo "x86" ;;
+	     *) skip "architecture $target is not supported"
+	esac
+}
+
+function main() {
+	local build_dir="$kernel_dir/.kho"
+	local jobs=$(($(nproc) * 2))
+	local target="$(uname -m)"
+
+	# skip the test if any of the preparation steps fails
+	set -o errtrace
+	trap skip ERR
+
+	while getopts 'hd:j:t:' opt; do
+		case $opt in
+		d)
+			build_dir="$OPTARG"
+			;;
+		j)
+		        jobs="$OPTARG"
+			;;
+		t)
+			target="$OPTARG"
+			;;
+		h)
+			usage
+			exit 0
+			;;
+		*)
+			echo Unknown argument "$opt"
+			usage
+			exit 1
+			;;
+		esac
+	done
+
+	ktap_print_header
+	ktap_set_plan 1
+
+	if [[ "$target" != "$(uname -m)" ]] && [[ -z "$CROSS_COMPILE" ]]; then
+		skip "Cross-platform testing needs to specify CROSS_COMPILE"
+	fi
+
+	mkdir -p "$build_dir"
+	local arch=$(target_to_arch "$target")
+	source "$test_dir/$arch.conf"
+
+	# build the kernel and create initrd
+	# initrd includes the kernel image that will be kexec'ed
+	local make_cmd="make ARCH=$arch CROSS_COMPILE=$CROSS_COMPILE -j$jobs"
+	build_kernel "$build_dir" "$make_cmd" "$QEMU_KCONFIG" "$KERNEL_IMAGE"
+
+	local kernel="$build_dir/arch/$arch/boot/$KERNEL_IMAGE"
+	mkinitrd "$kernel"
+
+	run_qemu "$QEMU_CMD" "$KERNEL_CMDLINE" "$kernel"
+
+	ktap_test_pass "KHO succeeded"
+}
+
+main "$@"
diff --git a/tools/testing/selftests/kho/x86.conf b/tools/testing/selftests/kho/x86.conf
new file mode 100644
index 000000000000..b419e610ca22
--- /dev/null
+++ b/tools/testing/selftests/kho/x86.conf
@@ -0,0 +1,7 @@
+QEMU_CMD=qemu-system-x86_64
+QEMU_KCONFIG="
+CONFIG_SERIAL_8250=y
+CONFIG_SERIAL_8250_CONSOLE=y
+"
+KERNEL_IMAGE="bzImage"
+KERNEL_CMDLINE="console=ttyS0"

base-commit: 89be9a83ccf1f88522317ce02f854f30d6115c41
-- 
2.47.2


