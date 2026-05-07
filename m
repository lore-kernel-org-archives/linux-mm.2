Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1040CD37AC
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E3006B00C2; Thu,  7 May 2026 16:23:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BA936B00C1; Thu,  7 May 2026 16:23:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CD976B00C2; Thu,  7 May 2026 16:23:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F3E666B00C0
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:23:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E29531405EF
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:16 +0000 (UTC)
X-FDA: 84741748392.13.04A82C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C131620010
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:23:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LoyYQ3Hn;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185395;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4tWeq6Z7OQ7/DT6ttV5IIbrWUq7ODdp2UrRgSX9Kl7E=;
	b=uFufs5PWsAW1+XAYeTSs9ltmbtgCkN2cyS0m4y6NjON4yfnNUCGwn3lb0sbshBlC6jTDe8
	rvdCQsn13lFBUuVMnNFnBvH+GDDUpukVsN2XAiHkiLM1ifZLYXuyptpS1+dgrU+uaM3Rwj
	r1eIv/hYSk1yd2puJSsUzXy4RydyL/U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LoyYQ3Hn;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185395; a=rsa-sha256;
	cv=none;
	b=liydeQOzhuroV6JefTKxS5cknWUuFPEuNyebaPg9UVwlCXvF8wnx5sWVsxf8s2UxlmyA/9
	ay2MeBYXGr09/Fh0HlgwhnNQ3eAVTPYvidO40dVRHiTgxR4xC4J/oh3x1wo/eIbAdPuVaL
	stVCRSwN3ZgUeltIt95fu6bvk1VY/+w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AF3314491A;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7977FC4AF12;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185373;
	bh=lwVlFCQp1XYVb6HoRPyHad+tlCW2NnrACLsMCrSqGoY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=LoyYQ3HnWfykO+/FdjEyR5uTtC32u6mEqqtR9h0TnREGHieDgGAYULxh6ZANiVj1I
	 hngTaznTCf5Hw5JbO2//WRKWdhO++0tpxbTV28wsFflPjCe91qNuujfhiAWqQcSABv
	 MyP+RMiY5AxqG0KzIKAJd8a5Ch9+NLjQjgVOqJWgzHvU/SXIqREQ6PeYuJ19EZjejk
	 Ilvc5sBgdVt6wXDrSTysCH5T8fp8t2Ju2fHh4qIdxxXhKvtEB3W/z+/OWmsTdouNyA
	 /Dek4H1Y1/tLO69O3n1uXMc3fEg9xKn6YhFqEqJbcb64JisMkt0V9Jvnw/KZIxwM0R
	 6EBO4iQTT3ToQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B8E0CD37AD;
	Thu,  7 May 2026 20:22:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:23:01 -0700
Subject: [PATCH v6 42/43] KVM: selftests: Add script to exercise
 private_mem_conversions_test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-42-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=7318;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=6e2GTdYPyQDy4VO0Ecn6nftzZ3nR0JAFcze9mdBDBUc=;
 b=889uK/NVkUSr2CCODFOE7tzBB3SgFehj04QQv9RgdYOkqk2BuLx12MLOmWcEM2mk3b54SgJYz
 ojiwa8Eh5HdD+0/+b0r9F8TA2kIZvts1a5m+lxqjHufI5XgI7t/oN2/
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: C131620010
X-Rspamd-Server: rspam06
X-Stat-Signature: 5pt4z7efmn5gmrszm6pkxzzg7iycgx8q
X-HE-Tag: 1778185394-670017
X-HE-Meta: U2FsdGVkX1/we/2nslJpGGZ0/ts6Okohc8mvhMpIrgXCIywAb8WDhQvuzOB/FU8EAbbV1ecgf1KKrOAYOcfczv3yhe0MFBdnGA+/yqDtdivzRX++bqkYXsFi5qZ2/SqRA59ODmBcg+Fl6bo8OMQwBhVvzKeq4+j/7INAoGCyVqTRcl6E9i96JoAIFtO/NbOZ1BtMnk4k3wbsn6ZVjusTFlQTC1HNb/zJm53szlo4GJgj633+dixTDLPc2QbDfzE56suyaPNOFDjdkhg8d7FwAFapEVb/C2fztAuuYZeH/RPu2tK3yGBVe0C+htVD50LScdm/876JnN+Vq3jMFJglbubnpb3tVbaqnL60GyhaZIVMG7vHeiQccgpFX1y8Hrl0ASSVZGPm2Up4UB5+XI9fV9u6TEBZHnfoYC5xx4ba6wjcEEjD3ppdEwbhv43dReTGjpFnV2D4mf2PzFdF8qouu8m/xCbRJX+w8PzZbBYYL552lHZY+3yJl9VjFwm+pfSeRwWl7/VM4VJYQm7Lu1t3KMQ92zjz6fQW93o1w/lUbEd2dZPXPGeP+AjGZcaBe4pz1eoqoIsgAq3t1EYhsmZaM/seijVPb8xJIZIxeXa3X3RgwJyVygJXrKL10IvxAvMz6of5I6AGCAuzSgyNwV5zGDPNQwhAlMurRxQ66QPdYq0VgKwwy941D9z2iudV2/OjmzZ4zmF/DoiC9uMBUTxYAntNwBKI63YmuJ1zsadIsK5Grz3gqXehsqweinj7t0Iy+EYGiifqKM0oIlxtPVbE1/ldEwzXPXPoj7DtLqJ6RnByQvhdQZfsHYuEaEhBkUSH/Hfj/vcg456586xOMNep9JFGu4n6cjRLQrHQW8svpYgHLUk4rT+RUp50SYxiB0gsDKq3vvmNbmpTaZHIP1VVXK65lub9fnQRx12eYgPUsoTPatbDbpps/qbeYj8EliwLrndj5bfxPlkbaTKKZju
 nQGXf5fS
 4owdWr8a8Z3YHWyGDZcYo8emRDKvfiABkKAW4NSUav+wG299LGqDQsXk/Hi6WmVaKDFK9lDr6HI8MRpziJ89WwhIobmZ/CaUjG1OgoE9dcxqFtil+udb942EXYXWMdEw6P336PrD3wioQQiCH37zEuLNRpXLUPEPfyN6AEnlCUpfMi1ZSZspV3HktzxJ0VhpYpgqIjDjOCUYhfxi0C3JZqcT8epsGxqDTkaHRfpXQLpLJAuMl5GVctcKMWQy43B1sEaz5CyykIOoXg0CbluZfya4x7HW2NS6yurP/mJTFJ5ZO8+AmEz+IU5aARNjzta/ybMELqdnhZvJJ8p9CX2P3uHvOKEoO2il9kP0nm8Wjw4OR5ymouSAi4nwgAnKcCk0aGJXPHPSIQv3MOLHeQYa0ahwTZ1MbVG63PG5PqnA5aztsX+MtVS91zbZfIUXSrAaoZDChVNjC28oE6AMuo6IX456RIQ==
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
2.54.0.563.g4f69b47b94-goog



