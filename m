Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BD4EFF8855
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 15:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FF736B0005; Tue,  5 May 2026 11:22:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6546B0088; Tue,  5 May 2026 11:22:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8135A6B008A; Tue,  5 May 2026 11:22:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72B8E6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 11:22:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B3D340427
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:22:47 +0000 (UTC)
X-FDA: 84733733574.23.A22C542
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5DB02180010
	for <linux-mm@kvack.org>; Tue,  5 May 2026 15:22:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BofG57Q8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3Qwv6aQcKCJgHJ2LE2D8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--pratmal.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3Qwv6aQcKCJgHJ2LE2D8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--pratmal.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777994565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UOjyVgTc9j8m+n6ADmeYm9LZ9JNWTd7uheWYAzKXHUM=;
	b=ckM2n+iQO4copv8ElIi1+M5tCysfR4XjQppeo0MAvQtJe11eAAg1IEQCwX6nn8o4w6L4CT
	7KKcDMoCu+fdjj7u+n5tIc5Bkxr64hSqbhez1feSu7Svz5Ppy8Mryz0M9Oi1CYox06OMvH
	ClUhb/4H0A+WJQfSgoBbxJZUvYdswNY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777994565; a=rsa-sha256;
	cv=none;
	b=uIYsRG4YKHXYOxZpNKbVqe8/hsSks7vTRG8+fvtgvFZ0WI6fuypYQDGSr21CzgBo788lQd
	N4sAX7tVQDsk8ldy6kpqoakVLmRThteWyPD2Mvj2pkdQ6STwNS7tM3dX0QNE0C2o6cUeqT
	ONA/KPKtcPvjumi6eVwagXYzb3Kd03Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BofG57Q8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3Qwv6aQcKCJgHJ2LE2D8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--pratmal.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3Qwv6aQcKCJgHJ2LE2D8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--pratmal.bounces.google.com
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2ee1da7a13fso5269254eec.1
        for <linux-mm@kvack.org>; Tue, 05 May 2026 08:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777994564; x=1778599364; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UOjyVgTc9j8m+n6ADmeYm9LZ9JNWTd7uheWYAzKXHUM=;
        b=BofG57Q8wUXHXSdLmHwdC7hhJg/d2eAMb1Bobzz6hnjwFLvoFJ2P8wPYr06UzrsAYj
         hQvSgyhE1h/nMWwZrEQsz0xc7HQCO9rwXCgajcGkY0xvmACM7YGivzBdA1c0GXD3+olH
         AxAS68Q3ntbrOifwuZnkryG0xWrnzQ/DPeHQ85xjSRIlbL7S583LMsmEmzMXe4w2+YYm
         Q4Pw5XsaOVqPXHjG+bMO9VYz82dmTpafChV29nS5QpTkkzpbLKiyX5/zGmxrRJlT+KVi
         wm/QMQB465ttkKwwMl602iYwUPj1106GzuGJP5ARgcsm3wUXOXgxYVYAkSp8iYf9Tlzz
         m4xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777994564; x=1778599364;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UOjyVgTc9j8m+n6ADmeYm9LZ9JNWTd7uheWYAzKXHUM=;
        b=XKpW+kdTysUuwnoUURlGqIZmst+UgPqMcRDGTg88aa7CKUURhFj0NA8aYT3PVuE6VO
         YgrdY4RE9cLD32l83vjt/5SB8R8HY24f6NQoIIu+d8RIIDlP6rUus2pTgXj1wTRWzYiI
         iFJ/Ba+cjmh3c+lhCZCzf8HlR52H18XEFEg0qoMLedcdRbUlUPjyyp/ktJzYguyzNkDy
         HfJBiC1byksIldwym3eteZ5We94+yBP0TiAdRKrWhl9J/C1lDfGwa42mFMDTcQt4BnMC
         VSKd/3aY7uy4blf4uTlsKMS/aQQ007nuPRb3QKGMsZpj/daL1rpIsDUOMtWg19jawZ2s
         tqWA==
X-Forwarded-Encrypted: i=1; AFNElJ/oslgZ8vnOT8bgarfUbDHYr5Y7vZm6084XhsJTSKO2iEf9tKue+Quy4QG1YO/coEoFkhC3ZN2RLg==@kvack.org
X-Gm-Message-State: AOJu0YyY6vlsVStVWzbU5/oHwUiex4tt7K1lL3GzVcCK1eMqqVbUl+P7
	JAlZIq0CErN2Dr4fICmwq8T4Bog0TYf/r1tsL2JCxRkkPYpJNeOe0rnpxCnAvCWPGWVUUqT3ZQ0
	zKKgm5ZbE1w==
X-Received: from dycaq14.prod.google.com ([2002:a05:7301:7e0e:b0:2f0:4bf1:a4a2])
 (user=pratmal job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:1609:b0:2f2:b544:2fca
 with SMTP id 5a478bee46e88-2f2b54431f7mr2282471eec.33.1777994563675; Tue, 05
 May 2026 08:22:43 -0700 (PDT)
Date: Tue,  5 May 2026 15:22:28 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260505152228.124065-1-pratmal@google.com>
Subject: [PATCH v2] selftests/mm: use pattern matching in .gitignore
From: pratmal@google.com
To: akpm@linux-foundation.org, shuah@kernel.org
Cc: yosryahmed@google.com, david@kernel.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pratyush Mallick <pratmal@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5DB02180010
X-Stat-Signature: nsqtuz8r3gihutijpmimubxhupzfj4qz
X-Rspam-User: 
X-HE-Tag: 1777994565-439371
X-HE-Meta: U2FsdGVkX1+yTgApt93L8h2dKju9SB9s7d16tTSBR38KAVz8HNCiwlZjRxJZTzlz/ETT9ujScraYTLLbSm/G+9C9+uS2R31PGgIgiVgIymk1n5PbGV6EADOQjYS85mWQDdyBVJON9QueqfEXkUYhWIzMXtjWllZz0zSj5Biuj84AH+cDD3/qXMsQpA0jT25nZGFBkXOYKvtS1mTzBgfrdlphotAVI8h4B291PeRZLYjI2p1hqiqNS+XF5UkvmG7oxYVr+3ohZI6z5nF4U0g/8oqlNab4cLSc0cY34RPq36GAM0Nc+yqCnL/eMG13X1Cx+Ka7l+y6RqIrktEDlFI9uE8kCxSLKsoXhpx53QVNl1DlokJaMxQKRJqYW/CfOQV2zCl2lwAWPTYk+vagrnmG6KvegXYpnTVWCZkNRwXEA2oBBzSQ1s8qW7lMdQNoVmJp5gfgffXXqROL7qjvWVoTd5BH/WAZ5VN9aJNQ0WB9VU9kot0TULPue2u+z4t50b5JoFjqz8OoJsQyCeNkX8L68atihVNEfACUPc/cVvfIJTBnpSqP2argWo3ad5zclwef2aQj/yUB3kGNcbAnCRtssuQus18WanpxfR5EdrOPUchFbqYFnan1DXIM6r1BsIQYSCCsp3bp4YmPWNWs16b8ZRYAuKIRh7+SuE/ycQu/3hE3pq3VdyliIDvNE3Kcv3leFoqgHgp8pROKKrrMgPJ/b7JpwDlz4ui5FRjevBQRZ+QVq1Ctidhiydf0qtmk7NER2JiksndBBQa74fehDmJS/8XGUWE9u9e7iGeNaT52zzN9eksxd2NZ9poAsJPWvzPprCgys4AoTJZ9gpQoMGbcc8shhenv+wbLomaAZ/vxaW7MqkEK3lpkTrn6U3l3CcAKTktKUPK3l98RXEKMUOkHgOZLeK6uv8VP8iYkL81uqbVjWkPvk4kyAVdmceBl9ThgDAAnTJhWyyStw0uVOC7
 j+NdIpT9
 FVGKril3O0qWlgjlK0ViK9TwEBHZXt/ANwTRu04W9U/dIzMt7VZt7VCLQmPJjhrDwlCt4feRsankP8w6O5kqu1tE8oPJq1/KtHv/nq0HX8KuMoFllYbnCLulI+gQqlAscRQ/qNvknAn6wxmpAgtc30nxrHy8GVh5ChevovLZF1gCsgYH6Gc9YIZ8KmgiPaARPRA8MDUk/Q7uRDZFGuuWyzfjvh6KHepiizFBZYPTi5sHvXgwVLTqJ0gDqnaYaH+4lO4tqStDYLojhas63qjpnkuu87MrpKf77W6ryPhvqKNoh16SmntDNRDhtTzV90xAqxbU1EN5Uzcfy/01+cQUz4rlWZRb5+vRToKs8JpgDgAHBb9IhDvx6apDwaDImdhnQKmSPIisx191bxqjVyqPyZqH8PuSLsttPzh5IGgZBISWJ4oZbnC6Zw/OZb7ywcnvAZF2OI8g0gY1Qf5Kf3kGQU8FSVfdeovRGp4ai2hAPH9AzhcyfFG14bB2EzjWujn4EfxMv6YXaQBecJ6A2Jk6As/VEVSuSGhlnu3D+PUYUyZrn0Lu0DSBPV8aqKHeZI+FQq7K+xUypwdgTuqhoKeg0YYBQyzTAOP+8jXJmGcXH7lmBLMNKMklWSz/wufqI0hO3SIiIPJ1GoFYDfoKDsIB6Y1h2kA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Mallick <pratmal@google.com>

The current .gitignore hardcodes each generated test binary by name,
requiring updates every time a new test is added.

Switch to the patten-matching approach similar to KVM:selftests.
Ignore everything by default and then allow source extensions (.c, .h, .sh)
and tracked non-source files.

To avoid un-ignoring the generated headers, rename local_config.h to
local_config.h_gen.

Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Pratyush Mallick <pratmal@google.com>
---
Changelog since v1 (RFC):
- Renamed local_config.h to local_config.h_gen to avoid conflict with !*.h.
- Updated Makefile, check_config.sh, and affected .c files for the rename.
- Removed *.mod.c as it was unnecessary.

 tools/testing/selftests/mm/.gitignore      | 71 +++-------------------
 tools/testing/selftests/mm/Makefile        |  6 +-
 tools/testing/selftests/mm/check_config.sh |  2 +-
 tools/testing/selftests/mm/cow.c           |  2 +-
 tools/testing/selftests/mm/gup_longterm.c  |  2 +-
 5 files changed, 15 insertions(+), 68 deletions(-)

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index 83ad9454dd9d..fcd892ed21e3 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -1,63 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
-cow
-hugepage-mmap
-hugepage-mremap
-hugepage-shm
-hugepage-vmemmap
-hugetlb-madvise
-hugetlb-read-hwpoison
-hugetlb-soft-offline
-khugepaged
-map_hugetlb
-map_populate
-thuge-gen
-compaction_test
-memory-failure
-migration
-mlock2-tests
-mrelease_test
-mremap_dontunmap
-mremap_test
-on-fault-limit
-transhuge-stress
-pagemap_ioctl
-pfnmap
-process_madv
-*.tmp*
-protection_keys
-protection_keys_32
-protection_keys_64
-madv_populate
-uffd-stress
-uffd-unit-tests
-uffd-wp-mremap
-mlock-intersect-test
-mlock-random-test
-virtual_address_range
-gup_test
-va_128TBswitch
-map_fixed_noreplace
-write_to_hugetlbfs
-hmm-tests
-memfd_secret
-soft-dirty
-split_huge_page_test
-ksm_tests
-local_config.h
-local_config.mk
-ksm_functional_tests
-mdwe_test
-gup_longterm
-mkdirty
-va_high_addr_switch
-hugetlb_fault_after_madv
-hugetlb_madv_vs_map
-mseal_test
-droppable
-hugetlb_dio
-pkey_sighandler_tests_32
-pkey_sighandler_tests_64
-guard-regions
-merge
-prctl_thp_disable
-rmap
+*
+!/**/
+!*.c
+!*.h
+!*.sh
+!.gitignore
+!Makefile
+!config
+!settings
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 7a5de4e9bf52..32f4b016b74f 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -5,7 +5,7 @@
 # script so kunit knows to run it, and add it to the list below.
 # If you do not YOUR TESTS WILL NOT RUN IN THE CI.
 
-LOCAL_HDRS += $(selfdir)/mm/local_config.h $(top_srcdir)/mm/gup_test.h
+LOCAL_HDRS += $(selfdir)/mm/local_config.h_gen $(top_srcdir)/mm/gup_test.h
 LOCAL_HDRS += $(selfdir)/mm/mseal_helpers.h
 
 include local_config.mk
@@ -259,10 +259,10 @@ $(OUTPUT)/migration: LDLIBS += -lnuma
 
 $(OUTPUT)/rmap: LDLIBS += -lnuma
 
-local_config.mk local_config.h: check_config.sh
+local_config.mk local_config.h_gen: check_config.sh
 	CC="$(CC)" CFLAGS="$(CFLAGS)" ./check_config.sh
 
-EXTRA_CLEAN += local_config.mk local_config.h
+EXTRA_CLEAN += local_config.mk local_config.h_gen
 
 ifeq ($(IOURING_EXTRA_LIBS),)
 all: warn_missing_liburing
diff --git a/tools/testing/selftests/mm/check_config.sh b/tools/testing/selftests/mm/check_config.sh
index b84c82bbf875..b46bf2d2e7f8 100755
--- a/tools/testing/selftests/mm/check_config.sh
+++ b/tools/testing/selftests/mm/check_config.sh
@@ -4,7 +4,7 @@
 # Probe for libraries and create header files to record the results. Both C
 # header files and Makefile include fragments are created.
 
-OUTPUT_H_FILE=local_config.h
+OUTPUT_H_FILE=local_config.h_gen
 OUTPUT_MKFILE=local_config.mk
 
 tmpname=$(mktemp)
diff --git a/tools/testing/selftests/mm/cow.c b/tools/testing/selftests/mm/cow.c
index d9c69c04b67d..87710c5a2d3c 100644
--- a/tools/testing/selftests/mm/cow.c
+++ b/tools/testing/selftests/mm/cow.c
@@ -21,7 +21,7 @@
 #include <sys/wait.h>
 #include <linux/memfd.h>
 
-#include "local_config.h"
+#include "local_config.h_gen"
 #ifdef LOCAL_CONFIG_HAVE_LIBURING
 #include <liburing.h>
 #endif /* LOCAL_CONFIG_HAVE_LIBURING */
diff --git a/tools/testing/selftests/mm/gup_longterm.c b/tools/testing/selftests/mm/gup_longterm.c
index f61150d28eb2..00ea0dd2f655 100644
--- a/tools/testing/selftests/mm/gup_longterm.c
+++ b/tools/testing/selftests/mm/gup_longterm.c
@@ -21,7 +21,7 @@
 #include <linux/magic.h>
 #include <linux/memfd.h>
 
-#include "local_config.h"
+#include "local_config.h_gen"
 #ifdef LOCAL_CONFIG_HAVE_LIBURING
 #include <liburing.h>
 #endif /* LOCAL_CONFIG_HAVE_LIBURING */
-- 
2.54.0.545.g6539524ca2-goog


