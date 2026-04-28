Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F2E7FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DF6E6B00B4; Tue, 28 Apr 2026 19:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2CD6B00B6; Tue, 28 Apr 2026 19:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFB676B00B7; Tue, 28 Apr 2026 19:26:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D47116B00B4
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:26:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1C52140673
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:49 +0000 (UTC)
X-FDA: 84709549218.14.187AC2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8088840007
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=noo4TLAf;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418747;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1Gs3p+pe4/2/BJz3l3685bFh9dVL4vkQUKkBkeUlK4=;
	b=o3SZaeMHpCEBXDnOVAZrtYorOCeSLSniUJg9nxbNlNxPkLmP9Xeiv9G7MkLQAL97KVu5qC
	xWqUf4GJgeDznkTOtbGs1rd8vQ3zDBF8uDOxa65ObLhNtTIyafd9cPPsxnCWYawlYC9ymC
	BftadTVDD6fCUvYm8/p3UEO+6kSYvmI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=noo4TLAf;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418747; a=rsa-sha256;
	cv=none;
	b=Ym+/jtu24mRiCjX/1E+zxN8MpN5ykJXieXb/6prdRHj82xuy9FXMBNOM01BTlBFp79F/eD
	UKj1cLaCr9AiU6VZzgVDfAEF0bzRHHdJxw6OuXrLTYWwfV7WhTo8rxoVESyCIbTnQgxKuB
	LqCiybhuD4wbhppRKrLg+JbgNrH8Mn0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B8C8D43F9B;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8DFFBC2BCF5;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418721;
	bh=s28QTqIblc5Y6DOdmxWa5Scmu3ZH/aC9hwSZ3ST+PkY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=noo4TLAfYGVn2TdZFH+1oxxqJJRgkkIzzYpldDBDPhJknpFUijTpoRaBt8WRiv36D
	 Rl6W5sjnTivNAZizlQLX4Ff1VBScymcSazRyBrqBov74Exmf9Dnuh+Z4sr7sN+C8sH
	 JanfejjzlxV+Sxb/QDbSvCC85bQ8spQhZtasMIKK4k54YxUg+I9gPPhB9tCSxk4xGs
	 3YZC2SQmJkmkRib5xmnUvgBqQMeKJyWHh7nFwijdcRTAXKQJ/JkzhN7n4d8Yz5Qbtd
	 /rVfRzD8kY3rqPb3gTs2pw5mrzhNsM/pBCaUqYf5rEOoLmxtvAMFLFcsAr4W430CFN
	 uc+24+5Yece4w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84BF0FF8875;
	Tue, 28 Apr 2026 23:25:21 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:46 -0700
Subject: [PATCH RFC v5 51/53] KVM: selftests: Add script to exercise
 private_mem_conversions_test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-51-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=7318;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=MBmNVOtEFn3UaImA75kYfBAiVir6jH2f8GzDHzl7Zt8=;
 b=0iOJ6VGmoBLqpQ1pPp+dpNPbACMnUFr9SD0B5sUGRZ8aKHFijYWm7jBjFnEDT1q7AJ+9JSfcy
 EvL4LphHVCDCQvMMY+NBgmzT+xok7rkOgdDtFefSxqe7FZaI2rnX9S1
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Stat-Signature: s8z1tetsmadkan5mf9s3iukfoepsz6gx
X-Rspamd-Queue-Id: 8088840007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777418747-43885
X-HE-Meta: U2FsdGVkX1/3YjoZIwH4MAsnj3xhxu3sQFB/f7vbbA2Dp41IK6pqpNMjngQ6Gq84tnycn0a5oNNS0kXwRDHtcdHVNLnbd5C52iqJJnQyqWD3wAXOX88UKxO0Cbbf0btGxZW8L/oMTUB1OrVQOZQ4NiigVAHrMk8athoALbOOCj6BCNUJ8JQitrfW2ubxgzbqWDkMBZQmc8NrPHo3wd1fY5vO2vYej1AT0Ubuuh+jqpVVNYNsIbyHsddZG3jc2QiOwbiOJkvzXwtlCG6HnbCb8vtmDpxm/AHFs3XXz3Gh1/hDmA6NQn27aTV+rthv6jEj280RsiElgWhqE6IMyLErhX0iSj5leqCRNAkw3x7HNAW/6hjNuIKW7bvPwJLiCr04DrsUXARZfonT4ltifEZ4WK09T5+PIIiQK4rU3yF10TtkVWN3/7zKvUkzaIqkOGoMzfLne+HZrWjpgw3gH7blqg+vqfb5bNRjLR24TlJkMJDWxTCW3BrXaJVNuwwwrLN9Sj5J872uCQh5jGBcMoDuLEnTNgMdDg1CEwB2BJV349KVW1/AZNjUW7YTIIvWPwkawOGp+VkaimZIAR/j68ymlNwQxvYfBfVGEBVeu0aONsmI/NA+fU21A3N8SwEEQ9eTUkSl7WE+FsXUd3h7iC3pWt6AKBgExrFMH125z5kGhY66yL/snBS72WbXM+f2iXyoqS+WGBi7DyU//a85Q9EPm+wyx6JaMUBlLgrBqyr56y4Lfp3E00mdJ794GdjWelad+Wm/OY4DJGX+KWq8YrCcdlMLvLBGjDpLfq3aGh/xnWisNwOq6GthNxnDHuvL6CUtcXj1Ofk7XCSomJAXwOmqGL3rKMSpnde/Aqkv70R0wJTuHbBXohRO9K36FRfIk8JED01e2SBbXfCByBxIu0VK9HSYfuwzZ9Ej2n9VJRBV0RzNytSTTUQWVb0IqFpTX1bvIXvXo9Ao2K4JbRphWdu
 3bT3dAdq
 BGrdtVan5yvkNiktmIqfxKJQyTUaie2P2C+OY6/BSI8pCZnHW4bZ75h/ElLgNE487oCv9YWyQAFRcv0O9xI4SDWQnycP1z4pIPUJDcBCz18c+FTZqPDrObjpvfZjCIk8MHXk7gj0dbvyVLzVE9W7LmsWm2FTe00T5qvCPc8Eg/0ud2156n/qHToL5WKI2+qVWx/r9tWxm8bDh+VN7WLrx+vVrKI7qllalOi/p8ouh1/RqTwOoG8jlDSsDyFZBeB3h2J8htu7Yo0cZbPhtdl9X/wGGxF8wMN5JkC8PSX8Fqw1TvMZ4TdqUi0gazLOHG5KMUeHIOT7TS33aHfDe94FaA2XJfDUFvd+4Rjx9WqnME9gzNTEQGG/upeIsJfBjQBakePyh/KnlTjVudIcQee1Ul9I9Zytl+f8v3kgjiGhCwh/hkkxu2npK7ZpZTBXRxh3gpePOn6lej2ONmDJ+7/Rq5EeYOg==
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
2.54.0.545.g6539524ca2-goog



