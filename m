Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38A6FCD5BC2
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9387E6B00C0; Fri, 22 May 2026 20:18:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89AA36B00C1; Fri, 22 May 2026 20:18:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762966B00C3; Fri, 22 May 2026 20:18:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49A0E6B00C1
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1F3D71C0097
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:24 +0000 (UTC)
X-FDA: 84796772928.07.4725EAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 30B1F20008
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bQgmQOtn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495502;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ExgLwTiGXbNnfGpmfMuz3V+Jj6nv5FqN2crLASzkrA4=;
	b=m/mtXS+eEmihQlcevagc2HWnJeyGZAaPQeO4dpto+dtURbIgWC4dSzc+eLtok0urf4syRb
	opeXXYyDoeaK8oDq1QpHhCLMvlv4D6mD5eLJeOEUDNkwLqclcJULy0Fa94DJkMhUXwBHxU
	a9MWdU63DA94bCVqXyY1q4+g5bKuykc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bQgmQOtn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495502; a=rsa-sha256;
	cv=none;
	b=zxveaX70iSFJvFSkZ8fx2GJ42F7S6Nt8sEoQFQTTCQIXDQIvItjMLaXEjQ2Ih6LsDqlLIh
	jEXSeLmYo1rTUJqZ7K6LEx7Mdv/yPmtcOmJrCF8/sNKbLINrPNICFvDhIT08VawwXOLE13
	APj4RUwh0nXgU6IvcqpHia4Xp6pm3Hs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5896B44E58;
	Sat, 23 May 2026 00:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 19C25C2BCC6;
	Sat, 23 May 2026 00:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495487;
	bh=Axovs8TeuO5FXTqmrfmqPxJ9R/hBIGAfGhEbQRH38to=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=bQgmQOtn11lA/S/qU89X9Jy+nCBStLSt4n2kyQiY9E9uGCkvYRZLaVIzMXNgZHLxg
	 nuXioh5/7XRvKtPde2XG7+G23GyJcI+uSa+sl9WNAD+iMLA5SicJBrwhwKCHUMDjMS
	 0eDeLqwRykzg/sKvQqrmbvtnqUzmFEcwTifLf7nUcwZtUjfCrZbDm0vsWo5C9IcipT
	 uftDK13mVzCVFS+wmhXo1xzmG4BG47/FxscEpQ0pL+Iv9YKXv5hwE936ZS74zYQ+bX
	 2aP+CZV7sS+jM/xoV0sQEKiYoV8gFW7Gkuzt1DWSNvgaIsZssEWdZvSBfr8mdZcTHu
	 RWkFu4QX5YOFg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0702ECD5BC4;
	Sat, 23 May 2026 00:18:07 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:18:23 -0700
Subject: [PATCH v7 41/42] KVM: selftests: Add script to exercise
 private_mem_conversions_test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-41-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495481; l=7318;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=jk7oZstbdn3sFO0k9hEIYgbfEsRxZui+neQcxlrUbE8=;
 b=qp7eZIJqzyfSAzn2qCkTgcZZQHoQuXtudlEJWTmgSdVjUhsGcGj/rKFvlEL9KHSxSgKmkXpJy
 nB4yiS5ToOxDM+/5M7wpxbqcUSbG8PPv6bgyi/BcFRsbClOvLrMjDmo
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: 1rfqan6rcp458m4k81upczoczeqmbgu3
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 30B1F20008
X-Rspam-User: 
X-HE-Tag: 1779495502-780791
X-HE-Meta: U2FsdGVkX18FftwErwsri968eue3lgMSfBGe+L2GALYjlMKemihOG4v8c+z6w6XVeOgVYh9GZPLvLbzrp84S1BOg/I/SrxU+pNFELds3CiEYPch3yTt+SxbAG8pP3a/GNuKbkfCvYHvnbgkimlIdqv9b2HE2ytfWM2Rcd6EZ7guJqIYsiNPdbGApiiTx3AetJ34cPzaBt9OqQ3ZWwYn+NYf0zCu/kmxmP5KBLrnVIMGN8j95at1Vg6GTGsncNiCspXnYQC32ndQDpUrGmCCS68hZliQ2gh65FA/a58WH0hNnroTMinnIRgLiHZ6Sf3TIjK7oAJum0gEqdgWfQgze/L+LXBByOxJ4ctC37UMtMboykScnbiORugGZqVie46T4e12VHBoeK2riDJ5bc6rqg3RCaCmDQFpuaOJD3GIiAA51FBWfVpquUMKYOylIfEUzdlrUcihMsk7dKBQZ0CsfhaxPccxm0l7TRYW0Gd9ycsJ1G8KtRnbo7TaOy0YTpE87XOQdlcVMlrTLiNSaNXFHV9rv6y1fHyJ08vdweIPZtwrsQF7JJUcxUYKBPGlO43VbTMOo2xmewoe1WrvjLxHdzKkUrgzCehjWEhcS8HiqWgk5NUaCiAl2M2od9+AHFlhAiFwBlDDiLBHrsVmEc2QlAfPC38G0tyS4+RX+jOB7Pxi/tLLwYod+jY2Lrq+ghete0TX3jJT4PZPdcksNUB1b5bZEuhAS2PUcmzf9nE3GL8bTNsDTHghJgdtCVz09EADkhOQs7bwXTdt6Vo3BKY9dIEGaWa1TXKzTSd2HR9f7dK0peMd0oUjmvPxx5fcc/XeKbRZEDL9mjDz5VywWzKXH6pCuEkQnJOvFZiARHRWs8UTDYXTWRxGvc2s6oJ0/7xoCgOzvRN83ddGCOC9ovkz07mXOgaY0FKGAzwnfWSSG8Bfv8RtRXBl6/eeu6ZNJTm7vPOVCsU/R7sDN1XpYULY
 aivz5Cat
 GJ3HDkBEhYrc5oVKAvBEpUBRa//QI2GiNlRj58oTTiw2YN7rwETKHB4WaZ7modyUZNseRRTuea54YtDOjfV02unaGR75b4CzpppFB0c/eRcUpE564nEzvszQlerpqWOpVDEaeCkYfNjWZZN2rVblOIu4nLqGW4OWSHU1iMJoNCWxS+xxBeBNCxAcvb3llj8mSuaIdersvaVZAUTxAItKUJ8iY13CxS62ST+2Om7K15MmBnAu0EEqW3rnmOFGJQBVsS4NQzLU5rYVmj8xIE1PEDCrrP4ZF79ZJBhfONiiS8p1UF2TNG8HzZq+BuNB7hUsxRmYXvJsiq8jvw7PlSYkeq6YUYlUwmzIt5yyazTMjjJZ7dZb9rQmpKixJvzrq1mqunomwX5kO+l2kLYuhQc2jGwI1ZfzZ9JR9GG8XOp3+BpEUggOAN0LySlFf6lg3szkZnAVsDeMbEJK/Vi8+GJMExPpGhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add a wrapper script to simplify running the private_mem_conversions_test
with a variety of configurations. Manually invoking the test for all
supported memory backing source types is tedious.

The script automatically detects the availability of 2MB and 1GB hugepages
and builds a list of source types to test. It then iterates through the
list, running the test for each type with both a single memslot and
multiple memslots.

This makes it easier to get comprehensive test coverage across different
memory configurations.

Add and use a helper program in C to be able to read
KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES as defined in header files and then
issue the ioctl to read the KVM CAP.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm           |   4 +
 .../selftests/kvm/kvm_has_gmem_attributes.c        |  17 +++
 .../kvm/x86/private_mem_conversions_test.sh        | 128 +++++++++++++++++++++
 3 files changed, 149 insertions(+)

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 6232881be500a..e5769268936a7 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -54,6 +54,7 @@ LIBKVM_loongarch += lib/loongarch/exception.S
 
 # Non-compiled test targets
 TEST_PROGS_x86 += x86/nx_huge_pages_test.sh
+TEST_PROGS_x86 += x86/private_mem_conversions_test.sh
 
 # Compiled test targets valid on all architectures with libkvm support
 TEST_GEN_PROGS_COMMON = demand_paging_test
@@ -67,6 +68,8 @@ TEST_GEN_PROGS_COMMON += set_memory_region_test
 TEST_GEN_PROGS_COMMON += memslot_modification_stress_test
 TEST_GEN_PROGS_COMMON += memslot_perf_test
 
+TEST_GEN_PROGS_EXTENDED_COMMON += kvm_has_gmem_attributes
+
 # Compiled test targets
 TEST_GEN_PROGS_x86 = $(TEST_GEN_PROGS_COMMON)
 TEST_GEN_PROGS_x86 += x86/cpuid_test
@@ -245,6 +248,7 @@ SPLIT_TESTS += get-reg-list
 
 TEST_PROGS += $(TEST_PROGS_$(ARCH))
 TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(ARCH))
+TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_COMMON)
 TEST_GEN_PROGS_EXTENDED += $(TEST_GEN_PROGS_EXTENDED_$(ARCH))
 LIBKVM += $(LIBKVM_$(ARCH))
 
diff --git a/tools/testing/selftests/kvm/kvm_has_gmem_attributes.c b/tools/testing/selftests/kvm/kvm_has_gmem_attributes.c
new file mode 100644
index 0000000000000..4f361349412fb
--- /dev/null
+++ b/tools/testing/selftests/kvm/kvm_has_gmem_attributes.c
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Utility to check if KVM supports guest_memfd attributes.
+ *
+ * Copyright (C) 2025, Google LLC.
+ */
+
+#include <stdio.h>
+
+#include "kvm_util.h"
+
+int main(void)
+{
+	printf("%u\n", kvm_check_cap(KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES) > 0);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.sh b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.sh
new file mode 100755
index 0000000000000..7179a4fcdd498
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.sh
@@ -0,0 +1,128 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Wrapper script which runs different test setups of
+# private_mem_conversions_test.
+#
+# Copyright (C) 2025, Google LLC.
+
+NUM_VCPUS_TO_TEST=4
+NUM_MEMSLOTS_TO_TEST=$NUM_VCPUS_TO_TEST
+
+# Required pages are based on the test setup in the C code.
+REQUIRED_NUM_2M_HUGEPAGES=$((1024 * NUM_VCPUS_TO_TEST))
+REQUIRED_NUM_1G_HUGEPAGES=$((2 * NUM_VCPUS_TO_TEST))
+
+get_hugepage_count() {
+    local page_size_kb=$1
+    local path="/sys/kernel/mm/hugepages/hugepages-${page_size_kb}kB/nr_hugepages"
+    if [ -f "$path" ]; then
+        cat "$path"
+    else
+        echo 0
+    fi
+}
+
+get_default_hugepage_size_in_kb() {
+    local size=$(grep "Hugepagesize:" /proc/meminfo | awk '{print $2}')
+    echo "$size"
+}
+
+run_tests() {
+    local executable_path=$1
+    local src_type=$2
+    local num_memslots=$3
+    local num_vcpus=$4
+
+    echo "$executable_path -s $src_type -m $num_memslots -n $num_vcpus"
+    "$executable_path" -s "$src_type" -m "$num_memslots" -n "$num_vcpus"
+}
+
+script_dir=$(dirname "$(realpath "$0")")
+test_executable="${script_dir}/private_mem_conversions_test"
+kvm_has_gmem_attributes_tool="${script_dir}/../kvm_has_gmem_attributes"
+
+if [ ! -f "$test_executable" ]; then
+    echo "Error: Test executable not found at '$test_executable'" >&2
+    exit 1
+fi
+
+if [ ! -f "$kvm_has_gmem_attributes_tool" ]; then
+    echo "Error: kvm_has_gmem_attributes utility not found at '$kvm_has_gmem_attributes_tool'" >&2
+    exit 1
+fi
+
+kvm_has_gmem_attributes=$("$kvm_has_gmem_attributes_tool" | tail -n1)
+
+if [ "$kvm_has_gmem_attributes" -eq 1 ]; then
+    backing_src_types=("shmem")
+else
+    hugepage_2mb_count=$(get_hugepage_count 2048)
+    hugepage_2mb_enabled=$((hugepage_2mb_count >= REQUIRED_NUM_2M_HUGEPAGES))
+    hugepage_1gb_count=$(get_hugepage_count 1048576)
+    hugepage_1gb_enabled=$((hugepage_1gb_count >= REQUIRED_NUM_1G_HUGEPAGES))
+
+    default_hugepage_size_kb=$(get_default_hugepage_size_in_kb)
+    hugepage_default_enabled=0
+    if [ "$default_hugepage_size_kb" -eq 2048 ]; then
+        hugepage_default_enabled=$hugepage_2mb_enabled
+    elif [ "$default_hugepage_size_kb" -eq 1048576 ]; then
+        hugepage_default_enabled=$hugepage_1gb_enabled
+    fi
+
+    backing_src_types=("anonymous" "anonymous_thp")
+
+    if [ "$hugepage_default_enabled" -eq 1 ]; then
+        backing_src_types+=("anonymous_hugetlb")
+    else
+        echo "skipping anonymous_hugetlb backing source type"
+    fi
+
+    if [ "$hugepage_2mb_enabled" -eq 1 ]; then
+        backing_src_types+=("anonymous_hugetlb_2mb")
+    else
+        echo "skipping anonymous_hugetlb_2mb backing source type"
+    fi
+
+    if [ "$hugepage_1gb_enabled" -eq 1 ]; then
+        backing_src_types+=("anonymous_hugetlb_1gb")
+    else
+        echo "skipping anonymous_hugetlb_1gb backing source type"
+    fi
+
+    backing_src_types+=("shmem")
+
+    if [ "$hugepage_default_enabled" -eq 1 ]; then
+        backing_src_types+=("shared_hugetlb")
+    else
+        echo "skipping shared_hugetlb backing source type"
+    fi
+fi
+
+return_code=0
+for i in "${!backing_src_types[@]}"; do
+    src_type=${backing_src_types[$i]}
+    if [ "$i" -gt 0 ]; then
+        echo
+    fi
+
+    if ! run_tests "$test_executable" "$src_type" 1 1; then
+        return_code=$?
+        echo "Test failed for source type '$src_type'. Arguments: -s $src_type -m 1 -n 1" >&2
+        break
+    fi
+
+    if ! run_tests "$test_executable" "$src_type" 1 "$NUM_VCPUS_TO_TEST"; then
+        return_code=$?
+        echo "Test failed for source type '$src_type'. Arguments: -s $src_type -m 1 -n $NUM_VCPUS_TO_TEST" >&2
+        break
+    fi
+
+    if ! run_tests "$test_executable" "$src_type" "$NUM_MEMSLOTS_TO_TEST" "$NUM_VCPUS_TO_TEST"; then
+        return_code=$?
+        echo "Test failed for source type '$src_type'. Arguments: -s $src_type -m $NUM_MEMSLOTS_TO_TEST -n $NUM_VCPUS_TO_TEST" >&2
+        break
+    fi
+done
+
+exit "$return_code"

-- 
2.54.0.794.g4f17f83d09-goog



