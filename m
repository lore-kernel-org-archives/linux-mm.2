Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F49CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 21:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 311886B0096; Tue,  2 Jun 2026 17:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FD2F6B0098; Tue,  2 Jun 2026 17:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 000A66B0099; Tue,  2 Jun 2026 17:56:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E21896B0096
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:56:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AF3FB160D6F
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:56:14 +0000 (UTC)
X-FDA: 84836331468.29.BC385C2
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id C8C9E1C000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:56:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nnbc5qOW;
	spf=pass (imf20.hostedemail.com: domain of 3e1EfagYKCPIqscbUhaiiafY.Wigfchor-ggepUWe.ila@flex--wyihan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3e1EfagYKCPIqscbUhaiiafY.Wigfchor-ggepUWe.ila@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780437372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y6mFy3Z3SyWCwRgM9+haQtSvrdq+maoP5fqUQtJx+eo=;
	b=Wk1OXuCJEu+Zupma1HwGRRVk2xqwvDU8VeYoqJBuQTlEmyM9Kxd+CwXAsj4G8+jFLefR5X
	NfoHcbOWmyByCA1u1jeMvJa0oJOu1fe8JIOa8rltfChlOYlC57dy3aAWSsoT9VFX6XuEYa
	Dztp33qqUeq6/6NPUVLPbZVCsNPiUt8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nnbc5qOW;
	spf=pass (imf20.hostedemail.com: domain of 3e1EfagYKCPIqscbUhaiiafY.Wigfchor-ggepUWe.ila@flex--wyihan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3e1EfagYKCPIqscbUhaiiafY.Wigfchor-ggepUWe.ila@flex--wyihan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780437372;
	b=4dd7FNtgKPc/xl6ShxEWjTc+aHcoJHCsOUIMn7UTgdWnuhY8zoEz55E8j0+wW4W3PWS1iW
	NYv/M6cObkx0V3pvK/gIxv7ieXV5SALxdF56OuH/XwhhiQKRE90WaAK5GocSUCI3G81fLF
	eG698l36qMJzYmlpGmfgQNlz3LGQSOc=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-36bbdcf36f0so37553a91.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 14:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780437371; x=1781042171; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=y6mFy3Z3SyWCwRgM9+haQtSvrdq+maoP5fqUQtJx+eo=;
        b=nnbc5qOWYW0KeuiZTSqSVaMfWeOw8r3DnzX1hkfe9Ff3A/wvT918UmQW8ynEmfNIwp
         7fnO80VKLPvc82mXTS0WKitSVKE9XeyiGVYpsTruGZtcpTHbigEPCbX61PBGA71I/oGr
         B2Qb/K8DfLOR8fhwWOpI0oJDVxPmZA3EhJN1oS4KqcdI86jPXkCHZ+TkL2u+Bg+58G2W
         C7xubqrrt9/oxvc39XASJ5XSJRQj1MbUvH0Z3igZtY0snIPEWrPCv+D6syWAqTmGm11R
         tNXFmu8pra5DYVRNHVIfpCDqoEQKZZtSKtTp6r3Vz0vdM19bf+BXJ6xOqFz3uMLc1e95
         rvaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780437371; x=1781042171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y6mFy3Z3SyWCwRgM9+haQtSvrdq+maoP5fqUQtJx+eo=;
        b=D7u/r3zDm9FqsI7TT4m4sGJUoZ4iAjUXkkmp7PojzkUsb7jqyIJ1YIBEQhTSN/GtYo
         +icCflG7CmJM6TSZ6BwN4uQrn9z5pmrE9p9plJUdAIdknGGdN/zLV3Pup9ZZ52OMO9w3
         otinpYrIMKOtnqZhjEnhFU+wnyrfUJZrCkTBzeeYdA29GF5bNDO0KnIV0aBj7hEPeQti
         OLjWMNkCrhTnC9fusf5+tfjLgB5QhhEcHdXB7NAspPFx6qFEap5Rm3DYXpuLd6fueNz4
         FAAuaXu3cg03gyoGNj33cGG3Ve1hYBXTqwZVqc7lsmuZsojE6K5SUuyGMMfAJz+n73ks
         05Kg==
X-Forwarded-Encrypted: i=1; AFNElJ9r60yfn5C/TD49/MxQd/0VFygBqG+pS9W2SontrQcuk0hTyT1wrylP3qk9acvUbSbbebXtwgtjdA==@kvack.org
X-Gm-Message-State: AOJu0Yy9x62g0auZMqbXUOEFYgWe4G1MowDORszo/MDyNqU3zstWuDqQ
	QsmjNimnCIBUcJXMZ1tC9aXavY3S1+qDvuOAe+aGtuRRSu/cetEEzzP5JN+hMwM1VJbaRo+Wfa2
	2I7cqDQ==
X-Received: from pjpo18.prod.google.com ([2002:a17:90a:9f92:b0:36b:8abb:86c4])
 (user=wyihan job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1649:b0:36b:769c:c037
 with SMTP id 98e67ed59e1d1-36e38a5ad7dmr345225a91.5.1780437371243; Tue, 02
 Jun 2026 14:56:11 -0700 (PDT)
Date: Tue, 02 Jun 2026 21:55:46 +0000
In-Reply-To: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
Mime-Version: 1.0
References: <20260602-memory-failure-mf-delayed-fix-v4-0-a5bc7db5a9b2@google.com>
X-Developer-Key: i=wyihan@google.com; a=ed25519; pk=cRi0fKzS5BMxlHyHY2pJv3w/1zcgfYKr6EYGYppdMYc=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1780437363; l=11908;
 i=wyihan@google.com; s=20260319; h=from:subject:message-id;
 bh=WaZ1Bk+9kgTkd/esD3bnBTyyH1p1bTgRbaMwG3iAxos=; b=SqAeAWv52UAEPcGkYpzMv8o5FzSIWZT3SZsD5NXiIh5u8IVpFEgGcT6WhIU7Nbk8K5YYCl77a
 5qnW7u/sLqaBTavQ2v5y2TwTStw+KcVVyLhpWWs2BMC6Z/Ltn+6hZu5
X-Mailer: b4 0.14.3
Message-ID: <20260602-memory-failure-mf-delayed-fix-v4-6-a5bc7db5a9b2@google.com>
Subject: [PATCH v4 6/7] KVM: selftests: Add the guest_memfd memory failure test
From: Lisa Wang <wyihan@google.com>
To: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: rientjes@google.com, seanjc@google.com, ackerleytng@google.com, 
	vannapurve@google.com, michael.roth@amd.com, jiaqiyan@google.com, 
	tabba@google.com, dave.hansen@linux.intel.com, Lisa Wang <wyihan@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C8C9E1C000A
X-Stat-Signature: jqtmttgjq3sk3e1y8ka3iq4zar3x6h87
X-Rspam-User: 
X-HE-Tag: 1780437372-771372
X-HE-Meta: U2FsdGVkX1+MSR9fweJtqMpR9uJYz2z2FKlCF4Umtcrsph53+BS4lvT9/+USGFIpH8Sp8sb835ILAGbOBIPj25toLZWeD8gGYZzMkNjqBvmcM5RBk9XeRhIpzo/6PDbIwSJe4CuuMOw2tjdy4UX+3S1ZC0F29Ua6Ll2UEN9lJCDdti4Wp9dNfNLFWGrRq1hJfD82auPD0U4n97OmBVri5KflO4/r2Ba6AebZ5sGBRQLdAVlIl224/o32SvE49JUxG/tMPtcEScM/1ge/tkbBYsFf4h7xJg1U4F8YNQ9iGeDfNaLd5wXmy/PhAYZY/HP3hR3BN67OJ6UzCq2S2uycSTvSgrXZ3pLwiE/r4DaF12HXJ+pAuBS9h3HaR64ECagkbCURYviq5RbpBzVrAKJIXBy/6wq6rL2EWtYGctv+7YdGdF/Bb2Rq1yP5pLjiQ+yFNUPg1H+HT/ck+TUkvgy1Smh6h8lQO6CgGUJk/GJk92hUKjmAMgNvU23ceRI9sKipUnix9Q4bnQnSAHp8x2EMURyCwd9jKozDOFCweT8Zsi4YkhROg9MgSKMrgGKxIKqR+BsuZos8/yi/BRkz5hnlO7FtXrcw2bOx+3esFonqMWhbY/52L1FoJtV0jXtj8q/QHrjeLqiAi/SJIxbOfbdf35qaEO/ZzHHy78Do54nC7ZRckkE73mDUTH69/s+KYGons23zoyTmK5AjAeA/XCH+lD3Fy0odYNX1EtpGYG6qZusVH2RW3Nw2iwXyMVc5TArQYBoC42p7INP7TlpKduAk+QCB0yS4j1EG6jPMGDFlyy2gTgFACbPxqa+ODNpMtg/B5R5hh80ICLI1k9HURs152RHfdXsX4I+2u8Mdnd0KLqFjJZsgbigVvl/3Lri/vM6oNtvlL4XESSfIWAI3RMpEGL3sMMw2TJUN2910qUuDY9F+L97Kmd7qaNEgSSlyY6pgTesIdDFjug/ARRyAFly
 ggBeIva3
 C4q66A7CKDhVlvIfrJy2WJvtpcXZiAy1j2FE5vlKGSYPI/pAbF0Rg+m+RZGSyS2cRobaklKZn4PdtMYccxOfxspjy5Y95Ky1OzxPETkRx7MWuHyBms86otOOhPVOAOecDTwpd8bbys6Km1eWqrnQ0lca4H2+ynl3L2DfUc/Yzkd9RYKi3anTUNFE5+PIyhMyHAvPfNM7S0mGYPJ0WxbixXfqfmDSsfTqTkTS43asjd/4HYcBfPNVLoL2tJwQj/ufa/nOOOJ0HHDMabwMSu6zLMA5GFD1MX/aLLVq1Ew3TiId1q9X2G0J/48j4Qi6XaHZEEzTf09CWu4zQya2qXf+fbvULWLErL9zg0TGCanww93YVsTUdBpzymj0b76G2HyRhgWyHw2sXWicw8T9TAOSGip5CUyYHv9NqjCUjfMxF4hfWVTJIaGAQuKmDGdorOEkQab/Jd3P2k/piIfLCQWdG7SPDiww6WbslXJMR78+ds4VjYPMIPoI1t7TgDOZ+TH+foyucObcPhQKpQnxhEy+dfQak4AEz/OGHBoQfmTtBzBsLaOZoFBHDIcGXOnjzkXPzyxkQIHeX/0HmoX//hDGUMwcuZNRxtWn0MSjWBPpdWOeXCZ9e7Egp7geC1XIN7kmFp/rEFbc//c4J0Tn8gm5xsAqau8MQckFxiXp7JazBpgKBry0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After modifying truncate_error_folio(), we expect memory_failure() will
return 0 instead of MF_FAILED. Also, we want to make sure
memory_failure() signaling function is same.

Test that memory_failure() returns 0 for guest_memfd, where
.error_remove_folio() is handled by not actually truncating, and
returning MF_DELAYED.

In addition, test that SIGBUS signaling behavior is not changed before
and after this modification.

There are two kinds of guest memory failure injections - madvise or
debugfs. When memory failure is injected using madvise, the
MF_ACTION_REQUIRED flag is set, and the page is mapped and dirty, the
process should get a SIGBUS. When memory is failure is injected using
debugfs, the KILL_EARLY machine check memory corruption kill policy is
set, and the page is mapped and dirty, the process should get a SIGBUS.

Co-developed-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Signed-off-by: Lisa Wang <wyihan@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm           |   2 +
 .../kvm/guest_memfd_memory_failure_test.c          | 336 +++++++++++++++++++++
 2 files changed, 338 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index fdec90e85467..9409ded6cbce 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -146,6 +146,7 @@ TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
 TEST_GEN_PROGS_x86 += guest_memfd_test
+TEST_GEN_PROGS_x86 += guest_memfd_memory_failure_test
 TEST_GEN_PROGS_x86 += hardware_disable_test
 TEST_GEN_PROGS_x86 += memslot_modification_stress_test
 TEST_GEN_PROGS_x86 += memslot_perf_test
@@ -186,6 +187,7 @@ TEST_GEN_PROGS_arm64 += coalesced_io_test
 TEST_GEN_PROGS_arm64 += dirty_log_perf_test
 TEST_GEN_PROGS_arm64 += get-reg-list
 TEST_GEN_PROGS_arm64 += guest_memfd_test
+TEST_GEN_PROGS_arm64 += guest_memfd_memory_failure_test
 TEST_GEN_PROGS_arm64 += memslot_modification_stress_test
 TEST_GEN_PROGS_arm64 += memslot_perf_test
 TEST_GEN_PROGS_arm64 += mmu_stress_test
diff --git a/tools/testing/selftests/kvm/guest_memfd_memory_failure_test.c b/tools/testing/selftests/kvm/guest_memfd_memory_failure_test.c
new file mode 100644
index 000000000000..6c8032d390ae
--- /dev/null
+++ b/tools/testing/selftests/kvm/guest_memfd_memory_failure_test.c
@@ -0,0 +1,336 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright Intel Corporation, 2026
+ *
+ * Author: Ackerley Tng <ackerleytng@google.com>
+ * Author: Lisa Wang <wyihan@google.com>
+ */
+
+#define _GNU_SOURCE
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <stdio.h>
+#include <fcntl.h>
+#include <linux/prctl.h>
+#include <sys/prctl.h>
+
+#include <linux/bitmap.h>
+#include <linux/falloc.h>
+#include <linux/sizes.h>
+#include <sys/mman.h>
+#include <sys/types.h>
+#include "kvm_util.h"
+#include "test_util.h"
+#include "kselftest_harness.h"
+
+static size_t page_size, total_size;
+
+enum memory_failure_injection_method {
+	MF_INJECT_DEBUGFS,
+	MF_INJECT_MADVISE,
+};
+
+FIXTURE(guest_memfd_failure) {
+	struct kvm_vm *vm;
+	int fd;
+	unsigned long poisoned_pfn;
+};
+
+FIXTURE_VARIANT(guest_memfd_failure) {
+	enum memory_failure_injection_method method;
+	int kill_config;
+	bool map_page;
+	bool dirty_page;
+	bool sigbus_expected;
+	int return_code;
+};
+
+FIXTURE_VARIANT_ADD(guest_memfd_failure, debugfs_early_dirty) {
+	.method = MF_INJECT_DEBUGFS,
+	.kill_config = PR_MCE_KILL_EARLY,
+	.map_page = true,
+	.dirty_page = true,
+	.sigbus_expected = true,
+	.return_code = 0,
+};
+
+FIXTURE_VARIANT_ADD(guest_memfd_failure, debugfs_early_clean) {
+	.method = MF_INJECT_DEBUGFS,
+	.kill_config = PR_MCE_KILL_EARLY,
+	.map_page = true,
+	.dirty_page = false,
+	.sigbus_expected = false,
+	.return_code = 0,
+};
+
+FIXTURE_VARIANT_ADD(guest_memfd_failure, debugfs_early_unmapped) {
+	.method = MF_INJECT_DEBUGFS,
+	.kill_config = PR_MCE_KILL_EARLY,
+	.map_page = false,
+	.dirty_page = true,
+	.sigbus_expected = false,
+	.return_code = 0,
+};
+
+FIXTURE_VARIANT_ADD(guest_memfd_failure, debugfs_late_dirty) {
+	.method = MF_INJECT_DEBUGFS,
+	.kill_config = PR_MCE_KILL_LATE,
+	.map_page = true,
+	.dirty_page = true,
+	.sigbus_expected = false,
+	.return_code = 0,
+};
+
+FIXTURE_VARIANT_ADD(guest_memfd_failure, debugfs_late_clean) {
+	.method = MF_INJECT_DEBUGFS,
+	.kill_config = PR_MCE_KILL_LATE,
+	.map_page = true,
+	.dirty_page = false,
+	.sigbus_expected = false,
+	.return_code = 0,
+};
+
+FIXTURE_VARIANT_ADD(guest_memfd_failure, debugfs_late_unmapped) {
+	.method = MF_INJECT_DEBUGFS,
+	.kill_config = PR_MCE_KILL_LATE,
+	.map_page = false,
+	.dirty_page = true,
+	.sigbus_expected = false,
+	.return_code = 0,
+};
+
+FIXTURE_VARIANT_ADD(guest_memfd_failure, madvise_dirty) {
+	.method = MF_INJECT_MADVISE,
+	.kill_config = PR_MCE_KILL_DEFAULT,
+	.map_page = true,
+	.dirty_page = true,
+	.sigbus_expected = true,
+	.return_code = 0,
+};
+
+FIXTURE_VARIANT_ADD(guest_memfd_failure, madvise_clean) {
+	.method = MF_INJECT_MADVISE,
+	.kill_config = PR_MCE_KILL_DEFAULT,
+	.map_page = true,
+	.dirty_page = false,
+	.sigbus_expected = false,
+	.return_code = 0,
+};
+
+FIXTURE_SETUP(guest_memfd_failure)
+{
+	self->vm = NULL;
+	self->fd = -1;
+	self->poisoned_pfn = 0;
+}
+
+static void write_memory_failure(unsigned long pfn, bool mark, int expected_return_code)
+{
+	char path[PATH_MAX];
+	char *filename;
+	char buf[20];
+	int ret;
+	int len;
+	int fd;
+
+	filename = mark ? "corrupt-pfn" : "unpoison-pfn";
+	snprintf(path, PATH_MAX, "/sys/kernel/debug/hwpoison/%s", filename);
+
+	fd = open(path, O_WRONLY);
+	TEST_ASSERT(fd >= 0, "Failed to open %s.", path);
+
+	len = snprintf(buf, sizeof(buf), "0x%lx\n", pfn);
+	if (len < 0 || (unsigned int)len >= sizeof(buf))
+		TEST_ASSERT(0, "snprintf failed or truncated.");
+
+	ret = write(fd, buf, len);
+	if (expected_return_code == 0) {
+		/*
+		 * If the memory_failure() returns 0, write() should be successful,
+		 * which returns how many bytes it writes.
+		 */
+		TEST_ASSERT(ret > 0, "Writing memory failure (path: %s) failed: %s", path,
+			    strerror(errno));
+	} else {
+		TEST_ASSERT_EQ(ret, -1);
+		/* errno is memory_failure() return code. */
+		TEST_ASSERT_EQ(errno, expected_return_code);
+	}
+
+	close(fd);
+}
+
+static void mark_memory_failure(unsigned long pfn, int expected_return_code)
+{
+	write_memory_failure(pfn, true, expected_return_code);
+}
+
+static void unmark_memory_failure(unsigned long pfn, int expected_return_code)
+{
+	write_memory_failure(pfn, false, expected_return_code);
+}
+
+FIXTURE_TEARDOWN(guest_memfd_failure)
+{
+	if (self->fd >= 0)
+		close(self->fd);
+	if (self->vm)
+		kvm_vm_free(self->vm);
+	if (self->poisoned_pfn)
+		unmark_memory_failure(self->poisoned_pfn, 0);
+}
+
+static unsigned long addr_to_pfn(void *addr)
+{
+	const uint64_t pagemap_pfn_mask = BIT(54) - 1;
+	const uint64_t pagemap_page_present = BIT(63);
+	uint64_t page_info;
+	ssize_t n_bytes;
+	int pagemap_fd;
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	TEST_ASSERT(pagemap_fd >= 0, "Opening pagemap should succeed.");
+
+	n_bytes = pread(pagemap_fd, &page_info, 8, (uint64_t)addr / page_size * 8);
+	TEST_ASSERT(n_bytes == 8, "pread of pagemap failed. n_bytes=%ld", n_bytes);
+
+	close(pagemap_fd);
+
+	TEST_ASSERT(page_info & pagemap_page_present, "The page for addr should be present");
+	return page_info & pagemap_pfn_mask;
+}
+
+static void do_test_memory_failure(FIXTURE_DATA(guest_memfd_failure) * self,
+				   const FIXTURE_VARIANT(guest_memfd_failure) * variant)
+{
+	unsigned long memory_failure_pfn;
+	char *memory_failure_addr;
+	char *mem;
+	int ret;
+
+	mem = mmap(NULL, total_size, PROT_READ | PROT_WRITE, MAP_SHARED, self->fd, 0);
+	TEST_ASSERT(mem != MAP_FAILED, "mmap() for guest_memfd should succeed.");
+	memory_failure_addr = mem + page_size;
+	if (variant->dirty_page)
+		*memory_failure_addr = 'A';
+	else
+		READ_ONCE(*memory_failure_addr);
+
+	/* Fault in page to read pfn, then unmap page for testing if needed. */
+	memory_failure_pfn = addr_to_pfn(memory_failure_addr);
+	if (!variant->map_page)
+		madvise(memory_failure_addr, page_size, MADV_DONTNEED);
+
+	ret = prctl(PR_MCE_KILL, PR_MCE_KILL_SET, variant->kill_config, 0, 0);
+	TEST_ASSERT_EQ(ret, 0);
+
+	self->poisoned_pfn = memory_failure_pfn;
+
+	ret = 0;
+	switch (variant->method) {
+	case MF_INJECT_DEBUGFS: {
+		/* DEBUGFS injection handles return_code test inside the mark_memory_failure(). */
+		if (variant->sigbus_expected)
+			TEST_EXPECT_SIGBUS(mark_memory_failure(memory_failure_pfn,
+							       variant->return_code));
+		else
+			mark_memory_failure(memory_failure_pfn, variant->return_code);
+		break;
+	}
+	case MF_INJECT_MADVISE: {
+		/*
+		 * MADV_HWPOISON uses get_user_pages() so the page will always
+		 * be faulted in at the point of memory_failure()
+		 */
+		if (variant->sigbus_expected)
+			TEST_EXPECT_SIGBUS(ret = madvise(memory_failure_addr,
+							 page_size, MADV_HWPOISON));
+		else
+			ret = madvise(memory_failure_addr, page_size, MADV_HWPOISON);
+
+		if (variant->return_code == 0)
+			TEST_ASSERT(ret == variant->return_code, "Memory failure failed. Errno: %s",
+							strerror(errno));
+		else {
+			/* errno is memory_failure() return code. */
+			TEST_ASSERT_EQ(errno, variant->return_code);
+		}
+		break;
+	}
+	default:
+		TEST_FAIL("Unhandled memory failure injection method %d.", variant->method);
+	}
+
+	TEST_EXPECT_SIGBUS(READ_ONCE(*memory_failure_addr));
+	TEST_EXPECT_SIGBUS(*memory_failure_addr = 'A');
+
+	ret = munmap(mem, total_size);
+	TEST_ASSERT(!ret, "munmap() should succeed.");
+
+	ret = fallocate(self->fd, FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE, 0, total_size);
+	TEST_ASSERT(!ret, "Truncate the entire file (cleanup) should succeed.");
+
+	ret = prctl(PR_MCE_KILL, PR_MCE_KILL_SET, PR_MCE_KILL_DEFAULT, 0, 0);
+	TEST_ASSERT_EQ(ret, 0);
+
+	unmark_memory_failure(memory_failure_pfn, 0);
+	self->poisoned_pfn = 0;
+}
+
+TEST_F(guest_memfd_failure, test_memory_failure)
+{
+	unsigned long vm_types, vm_type;
+
+	total_size = page_size * 4;
+
+	vm_types = kvm_check_cap(KVM_CAP_VM_TYPES);
+	if (!vm_types)
+		vm_types = BIT(VM_TYPE_DEFAULT);
+
+	for_each_set_bit(vm_type, &vm_types, BITS_PER_TYPE(vm_types)) {
+		uint64_t flags;
+
+		self->vm = vm_create_barebones_type(vm_type);
+		flags = vm_check_cap(self->vm, KVM_CAP_GUEST_MEMFD_FLAGS);
+		if (!(flags & GUEST_MEMFD_FLAG_INIT_SHARED)) {
+			kvm_vm_free(self->vm);
+			self->vm = NULL;
+			continue;
+		}
+
+		self->fd = vm_create_guest_memfd(self->vm, total_size,
+						 GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED);
+		ASSERT_GE(self->fd, 0) TH_LOG("vm_create_guest_memfd failed");
+
+		do_test_memory_failure(self, variant);
+
+		close(self->fd);
+		self->fd = -1;
+		kvm_vm_free(self->vm);
+		self->vm = NULL;
+	}
+}
+
+static bool can_inject_memory_failure(void)
+{
+	int fd;
+
+	fd = open("/sys/kernel/debug/hwpoison/corrupt-pfn", O_WRONLY);
+	if (fd < 0)
+		return false;
+
+	close(fd);
+	return true;
+}
+
+int main(int argc, char **argv)
+{
+	TEST_REQUIRE(kvm_check_cap(KVM_CAP_GUEST_MEMFD_FLAGS) & GUEST_MEMFD_FLAG_INIT_SHARED);
+	__TEST_REQUIRE(can_inject_memory_failure(),
+		       "Insufficient permissions to access hwpoison debugfs (requires CAP_SYS_ADMIN / root))");
+	page_size = getpagesize();
+
+	return test_harness_run(argc, argv);
+}

-- 
2.54.0.1013.g208068f2d8-goog


