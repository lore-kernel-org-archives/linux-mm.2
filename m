Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0841C10AB82B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:26:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C412C6B00E7; Thu, 26 Mar 2026 18:25:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18316B00E9; Thu, 26 Mar 2026 18:25:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADFA76B00EA; Thu, 26 Mar 2026 18:25:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B33B6B00E7
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:25:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B1D85D775
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:57 +0000 (UTC)
X-FDA: 84589647954.17.28E172F
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf16.hostedemail.com (Postfix) with ESMTP id 78972180006
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:25:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=H9GFz7Dz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3brLFaQsKCD8bdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3brLFaQsKCD8bdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOvCiY0rlYUHe0fOI7v6StFLJG8uwpZnrT+/fXekcCU=;
	b=Yu7S588qH3NdRLuwv1uSeJ2nwHZEVskGn78xBzziyx5RWb4mcz8v637blBR9jPASFK4afg
	8HY80LnBUmdXu2OmzYJMIKA1IrfZ8TLj6p6G7t2mStpmRVHSxjUPfI4S97ojS7eENr6urC
	r/zPz9Pf6kQldMq05zX1rT70PR1nxwU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563952; a=rsa-sha256;
	cv=none;
	b=hgE8GMaEboRAHGQqXmrKebKEvDBlCh/dFJOYs4Ppkj7cqUN+BY8e462a2McQddKenCnWxu
	wAzZPgvYVcsbXVL+n4NxFld0cVl2EXzx2GmU/CRcKhWOdcu8wFCNtuqcG4YUMJixHNn/lf
	qFCC3pvPsvEbkEefyqjvTUJECE1d3PE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=H9GFz7Dz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3brLFaQsKCD8bdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3brLFaQsKCD8bdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c741a9ef5f0so1036404a12.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563951; x=1775168751; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FOvCiY0rlYUHe0fOI7v6StFLJG8uwpZnrT+/fXekcCU=;
        b=H9GFz7Dzxrq0W0aE94grLQR5T87wpGpuMlgnpUCDKsIXmIiumrfpc5KQprN1xI6yPR
         687E11hf4qTFl8hOurhq/XjWAxs1X3XR4bORwJJ1pPa7zFpdR0DcTCqBahR77BHXwcak
         lt2AkFKQZMEj4mHWAOelD307rlKZW8oG+rm8JNWfE5EZAp2mhPt4H+irA5oqEOgstXfk
         V1hzo+n6hvWbr4FjOEYhusFUMzJ8ANof5gVZfZ0GueWWHhT2DwvAMtnHsv2MtB0IKezd
         Z4pMWZnoL00hT7/z3WNg4kV4bhYHSUnHYog2lVf9LvDr5ausubeTdJAFnCHwB1VeWknh
         0DtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563951; x=1775168751;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FOvCiY0rlYUHe0fOI7v6StFLJG8uwpZnrT+/fXekcCU=;
        b=lKOXA2o7TGsJT+g39kG85UPRJZIAyIiqG/CrssqwTBCvPznaYJUpK4Yzw3JfiCVZoN
         yuSA13ge4eMotEeJQhHI/LnyKvvSk0Y408HUVRvMZSNRU8a0LU+fglDTpz9i79AFPkFU
         w0H97djqAcIobdNLWBXhph8riVjA4ZdGI8Z+YNdFRPc9UWqQEcZ1Sl7HokzwihBc6rg0
         OJPOTDxmv7comnvVfBqIqtJxk6BP8ASmlAtt3Sx3UhM7K+9HbJnIRg8jHP9QY4DWUeGT
         L0zHNPznO9aWVXcaspK4FbWHK4gNHY2nHYWNzRNT4ecUbanMxRKqYzayM/VoLNF2UhpY
         YQEA==
X-Forwarded-Encrypted: i=1; AJvYcCV80nICWty+vtXS35Ts7T1Qk6BfuIi9oycpdkuL+PH+HLSKDUBI6E+Dl4jo1CLf0PBJbOcCLEkXWQ==@kvack.org
X-Gm-Message-State: AOJu0YxdQqZUI8Pkk0PO9AmZax4ItIT+9sQrfTa6NeeF1Sc5F8/D0YUo
	jG8JhXCpPmEBKa17LeJWJD0W0TapBbJhGmuNl3pagLcD5IpspvMQcVg9gapVW5GuxY1VusrqpJq
	5CsFqZuKBZi3jOxXgL5MBKmB75w==
X-Received: from pfbfm13.prod.google.com ([2002:a05:6a00:2f8d:b0:829:9230:5ae0])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4507:b0:824:b03f:2f65 with SMTP id d2e1a72fcca58-82c86327803mr2544703b3a.7.1774563950966;
 Thu, 26 Mar 2026 15:25:50 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:51 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=7309;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=1UdkhOs2Zqea3da/lUF30fB7TjQvN3BF4p6nSKOEiMw=; b=meNvl6H7hNe8vhcHr6NLmKIGogD5I73dTRdM0T0sz1m8FYD72Qb0slyTw8HDNsQ1XuejDyVCT
 q28EwvSh0emB3EOo8KZcCpFTHjegPcgqXIoPGnFsgPbAJ9DfeA1BI4h
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-42-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 42/44] KVM: selftests: Add script to exercise private_mem_conversions_test
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 78972180006
X-Stat-Signature: 8k4a3dsqbbkit13g4bptws71eg6e5hsp
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774563952-778817
X-HE-Meta: U2FsdGVkX19+avXCyFQGLFEdbwXCuZih4hsiFbLsVth1VLhUqGA+FJlpjyY8vCGor6sd+e5hFMNOitl+BjH53WAa9G5ZTbvUY2ddqj8n+LemCstY5IGHenZyyp17DhF5SL7BMaFkJ67t/1KuYLTkBrmVNHjTcz7+ibw8mKj2nXD8lPJyipkAgY2nKftwXvXaenQS0akFg2gMmGMRE0OpfsLVE0+Ygl5CGmhSKegqOSStmM+HSYH+mbObM7xOFSTdIaDChV/CYlbeSL/FJPdtRERFBIE3gJU1cZ6j8Xj/+TG4um56bB6Jdn5r/unDFfA1JqNALH4wfoNOc0GCixZXiyKvG0ZbcFHO+50NpvISvPcG9u0x3JODfP8TEv5KKJjNG0T6ghEdoIFXiUGX4cnwSeLdzTEevwOEIEkH1D3Var0rSswLElq4jNmasm1qy4YJMa2CDlP1gNFDKLcAJZtKDu55xNyBffuFlfgLIRwqNTJMiEf7CHAfGiUUhBRNZzPZeLehcw7mJISJWeoWHRg4RmqOf/JxRlBjFweJqAYnuvOpDzgWhTdmrs7qj9cj/StXJfNB7RaGFfddKx96D5381Os018m+ZUfmazA0Sy2neLKULFi/CxHPT8HEMyWYgRbynGZhQAFKc7Qqwo+0HZMY4Ym2pLpDzXnoj8cAWwHkmFLQziNqfQlSQ3wmQSK7/CTHf3rSH1cVwDsQTtHl0jaSl7SMkkqK35fHgzevRQ6iXbD0ZTSDDYAba0C6OMI8fGUFA2gVUNwgAbj+m36ZK2KbWnA1GCijjXuT4H88RstTtlIImWxox6odrZ0ldHJc9Gn5+UV2l+d8V8kEDWvmgzbVx/IC/tK3aroOpvez6qyv6SOtpRuq0V7Oov7HDZ6EF1qB2Pfhb6PYQfRu0wzwRoKsAhU6+C9KH/EwC/PSdfai4DWkgtbasqZGTpqpJYiWem53JFxB3VFXYYItGu0SQ4b
 kRh5W8hX
 lsetzW6NzJ9ondZnQGGNohOQsI/qPXYd6rU2s63IBlAJXSplI6yyhm9vJ4z3f6VEsq6xkSEumoUJIp2kv3tY0V6v3LWD1Fc9LuVME5UyHlgORybDt6REBftnEgEOKfS6NiHoTciaXaIYMH5FK+VeomZCMlO4Tx6qaAiEoA86Adci+0P+XszEAh4kLmoa0VrrDNkU8j55+YNT4QfmGIXCjfnJnJpfd8Wwk7ZavEqSfa/ObytUNBYVKihnQ+bcIiELxG72gYAdH7kFUSll4Nju2mGDEzmoQjiEdSgg4iltcTsLdjcX6ALhy802B2tDVvTS48jI5XK34SdSO8Tlk+aY7NiiR889cvlaoMbF63WE/2zptZc7H9YMPghIbRE0pF59/IwZsAIpFo+WiCAP2Iv9QxYBZfhbwwMqYOSmUVQE513+VPVDRbWcEkPxsCVuTcj+RCMm9MR6XNFzrgw3Pv1wBJjx6O4CIl+2F9g9U69LU9pexfvIIFyJdb3TlG3WY5PH3PDL+bsXBOA8p/a0I54j/gNpB8gImC8Eq3jGI0sbImDnLfRm9nSkOEf+YsNlz4P3vJ5KTeOFaA9BUaGfIgUrTT/nIXMBfHd2HmdapBG4vROeWYRV0bozZoRmZlGX0Gn6kq/LzJheaLvOzyJCKu63CXK/gm9AXBVsD9hHZ7SuRvCqqrE1Xu8ZDqZ4SM2riw+med/0R70UbH59C21XFdHIgcJ9jqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 0e2a9adfca57e..c326aecfeebb0 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -54,6 +54,7 @@ LIBKVM_loongarch += lib/loongarch/exception.S
 
 # Non-compiled test targets
 TEST_PROGS_x86 += x86/nx_huge_pages_test.sh
+TEST_PROGS_x86 += x86/private_mem_conversions_test.sh
 
 # Compiled test targets valid on all architectures with libkvm support
 TEST_GEN_PROGS_COMMON = demand_paging_test
@@ -65,6 +66,8 @@ TEST_GEN_PROGS_COMMON += kvm_create_max_vcpus
 TEST_GEN_PROGS_COMMON += kvm_page_table_test
 TEST_GEN_PROGS_COMMON += set_memory_region_test
 
+TEST_GEN_PROGS_EXTENDED_COMMON += kvm_has_gmem_attributes
+
 # Compiled test targets
 TEST_GEN_PROGS_x86 = $(TEST_GEN_PROGS_COMMON)
 TEST_GEN_PROGS_x86 += x86/cpuid_test
@@ -242,6 +245,7 @@ SPLIT_TESTS += get-reg-list
 
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
2.53.0.1018.g2bb0e51243-goog


