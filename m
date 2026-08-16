Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08B03C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 14:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBD3A6B0359; Sun, 16 Aug 2026 10:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94426B035B; Sun, 16 Aug 2026 10:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D83376B035C; Sun, 16 Aug 2026 10:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1D626B0359
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 10:23:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1284514056B
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 14:23:16 +0000 (UTC)
X-FDA: 85107349992.18.025FECA
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1E4E340007
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 14:23:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hQcI+OLr;
	spf=pass (imf11.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786890194;
	b=spNssF0uBI84MeWrS7SRpIl5v3Uljdy2LiM8HTCouar+owbmYlUfWq+JCTcDHM09063Qg2
	sGqS8/4CewcOpIoVwBQtYQSNDu6WDNkV2e7qhgSnHTgkpXIBjAM3TCCx1OkkGozi2km5Kq
	dp5wMmXoicPTrTB/fekTUuBwwbR7X3M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hQcI+OLr;
	spf=pass (imf11.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786890194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZh5CgmasB3FNwZhE5a0RmyqcaBUm5A+ddeEPpNzaA4=;
	b=QUdENKTL5/lXxPzlMJKa0FjfORkiU3/J9lbz1EjHwpqOETgc07m/jHEDX33gjolwKbRRQ4
	NzY91GsXjmBvjhEc2czmMA2vCxrVkf/VSBu9kG9KiqgLC5xdfnR6upsrnvL42cy9YkAnZ/
	ESd6/v0CU9UjFkrPJPZglnMQY8YibYU=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2cca0c5799eso23060825ad.0
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 07:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786890193; x=1787494993; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VZh5CgmasB3FNwZhE5a0RmyqcaBUm5A+ddeEPpNzaA4=;
        b=hQcI+OLrEhQFGIVk1JeI2TlgpInQZ+RDNq3CBph2CjYD5a2sp7N8W6amOda0i9XM3o
         PJE9YLO2ProexcUhStfMdQX4Vvlq1zQ8Xw59vp2h8RLrjMyDLmdhPwZCL3E+YmBMRwms
         eJGnu9uCWnmjjFBpajl43JHEKitJWBtqs+Ih05j73fhutk2YoPO8JtWKNXmvJmpSLVSM
         KvhwckY2tIH+o/NO7tXQVVyOPlWgqQQf5TDDvPtw2JOLUvyG+66c6nltWP1p1RbM0yPA
         PgyJXtbiVM25xPkwTMyMseHYJLBB5yVfxIgiAN9nrXWWjpIf8mYOyYbDoStzsHKnepIc
         l46g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786890193; x=1787494993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VZh5CgmasB3FNwZhE5a0RmyqcaBUm5A+ddeEPpNzaA4=;
        b=JL39JFsek6rI5Mzrsgwc1+N2SQp4a5paDAD58CYibAi0u31Wv8RhD77U1UCD5kqtps
         MzZJN1olYeQ5aGju2bH3u9e2YQDn/dUYkbd11AWUTEj/uuMZHf8CEhWjXXT0ytyG51ZI
         tcVVL5M8oeKd2kg4HPrItcqFHPsqQ7Jejqs/Pnxlb+A6ssiz27XBdJ22KxqRBbO73+WY
         tnKQC6EL+HdXcWFYz8fgpTiGAyjlP9uw07/Lis82H1cqF1WObHRXv6aQGD32dHylVLIv
         D6yHlaNAcx7oG+nKd2x4b2ks/9p2IQw7NQ1v/q9CCX6tpEOE+QAO1mMyLGgUYkIJre5o
         1kUg==
X-Forwarded-Encrypted: i=1; AHgh+Rp2jkkJ8PeOd8+6Z6pzmNBSxkYzLUK+55/mYdqMPQB+8HWeH2Ejv2a6YVpn+wUGlrsUuvALl4h5iQ==@kvack.org
X-Gm-Message-State: AOJu0Yy69hpr8UL2W9hLdz17+UrHIWwHZRR0JkrvwaIWhDgJ5vDIc0yH
	AfIw+Q9lKIaNF4+3QQ2yG44jeqCbyCZ112NBXoXMpXrjoC/hkcw1pJpP
X-Gm-Gg: AR+sD10zKX1WuQhisAgfvxdVgtisrofP73ZTjIqZW2uLZk09kSnkZixw7+A/pPw0WcO
	tx6ygSRueJ4D3tOgnSmTC/EXEX9TMNESS/3IBHVvpJveMJ3rK/L3iUhu/p0Uss4/fQG8OlaECnG
	KUa3yiFjaVHkwtErM1iUrAfjHAU2rO2L7MEVvhOcPM3qG27o2jziEFfn8am6LSIM+WU1dg0DZWP
	8Wzad2TJ/tpNqO/O4aZz27yMl878YG/uVqdj6U74p9hgQOkMQ2fRU4izVadRZrtTGXy6NrYTn2i
	Okhw4O1lo4ndbR/kKVw2jGhf1kmnl/y/jUbyl9Q99KJYyM0vNaq5dpygN0A+7IG3WPurl9N6Oy+
	g16GZcJCxo820+yIazNRac+ZApxZVJAOYSWiuTgNpdQAhqX7G0Ckw3warT7qYvgo8FDpBHBWOVX
	ytwhCT+3xRi6mQ8ejSgpfi1f1cOnG21Rt8YHgWcDATGoCPenbM9dMvPAzSMJRBN5j2KCtoP5r0/
	zdkE5g=
X-Received: by 2002:a17:903:8d0:b0:2cc:aa36:c04c with SMTP id d9443c01a7336-2d3b0ad0fa1mr214403475ad.1.1786890192602;
        Sun, 16 Aug 2026 07:23:12 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d3aebc8199sm26102365ad.74.2026.08.16.07.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 07:23:12 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: will@kernel.org,
	mark.rutland@arm.com,
	sj@kernel.org,
	akpm@linux-foundation.org,
	shuah@kernel.org,
	kunwu.chan@linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	"Lian Wang (ProcessMission)" <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [RFC PATCH 4/4] selftests/damon: add DAMON perf AUX backend test
Date: Sun, 16 Aug 2026 22:22:21 +0800
Message-ID: <20260816142222.689624-5-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260816142222.689624-1-kunwu.chan@linux.dev>
References: <20260816142222.689624-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1E4E340007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ru5noqzujfys938giquho4o83w3uwdto
X-HE-Tag: 1786890193-283586
X-HE-Meta: U2FsdGVkX18e8bQl/f7ZtnfP8ZouGZR3jl978OTq3wwGd/+1AB5rQRl+4j8OKzZ7WDTZGBFe/vcC6syttB/0+pHhCkl5hiMeKoXZqjqlGSY1GLHOqm7b2I9SXPPC7Z3PrwOTxivaNBP4Z1FKnk6S82pmSYPFrXTLW2sBQ+vtjcrLYcaKuRYv7PKQQrOJYWyMSop1/Dx6UAX6nakFNxV40NzFWX85BfON6uP16LxrLVEG2eND9jNlSnch9XRvMR9C82WAIfsZMKPdnS3f5EfzPmGDP2qBDB7usm71Wn66xTW19z2XnWA8je4EPX46/PlRUk2qC9mXxKkWYnpfsiX9ZMml/U6S74/vJe+jkXrbAp/R0AFyGVYqmw4duUd6zuNAmHQtMJlg/GvhI9zjXllh795TGMFZ4E4E0W7Mb//zVpjMQKMaRT1xtiUKcrwwJOvYARi3oxavVYkyQC++zn6yNYpvbiB7UOS1T1vJ504bsFfcbb7laosRcG3hkqlSeeBX1U1Hq9MjsJ4pHjCP4xGbyYCmj+vWfm9inQYERZ6DKKA88rELHLV2TJ8KjlphGc9so7hpWuWSIB+N2rwzkS6VGF8FymseqD9yIyYq7n79sLscdSe1A6RD4svTqzaC42Lh7tnqqj6KNLwshq46MjuJfCX97CM6IWz+xxTqFQXQmhKeGYmf/0JYG6eG5DmMbIG/o8LwhhGAqSwF0dqDP+QWmaIrhCjrtbMMzFYq3YbICIUjr/OTwOV/juf5AQgtcG5A1WMkE05I0W2dyVWwMNfulz8RRofHFAvsfwHr3PM97s36+Odq5p9MXLKrQvv+hcEgDuPWJdJXzqgqKV/qUr/vpqBUXTYQQfI6MgeMWVh4NIHB5IS9SWQicfP1qnp9OV4luyta5HmYHHRhW9gTK7oAK3XTGM0L9595jut8FEvrkqbDf98T5gmUdSU3uIRXdPJC0/iqh1ZxiuoYmZMKDzy
 VX7NcJvS
 lxtrTwWBLtQbVJ6We/KE+BYN1TtG7q3DKImgOFZ3odDFcSUr1+O6UuT++iYIvJdE8IE5UdNvMGYTZX9U/1VQDu3xoPl/LEfBSfqBL/jJhuY3MPr9G8SqoTPfaLmokftq96qv1KLDhD7k0mW2Xsv8Lx3FhrorVjwy6dHdfZxNOmvpbaKTISefW+tBQqVCeeyklkbQN8LhmhxJxTPIWHr3uevGR6qfmWkZ4WKb6clpGAQ++z8gYBwi12sqhCVSHZngRXbB4hTpQac/lwqEhSEWYFF31RdF4wAWCGLxvdNAfzvS7hDLDX/n1WtbhSqMeiscHR0m97sbZjjX8RaCyelTTunIEU2apIK/vd7fPlmFqXCwflpD57/yNhLU8jhl3aonRr3GPQtJz0k7vKH5h9fdfsjnAOqBLd/EfPy4fK1LRisSdzOHj2FFn4zcMU5MFqd6NBEXj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>

Register a DAMON kselftest for the ARM SPE AUX backend.  When kernel
sources are available, check the backend integration and the required
AUX-before-ring lifecycle ordering.  Independently run the SPE parser
KUnit suite through debugfs when it is built.

On an ARM SPE system with no pre-existing kdamond, create one controlled
userspace target and collect counter deltas from a five-second session.
Stop the session explicitly, then verify positive end-to-end pipeline
counters and final enqueue/dequeue closure.  Use a private mktemp result
directory and restore only the DAMON state created by this test.

This is a smoke and lifecycle test; full-ring pause/resume validation
remains a separate hardware stress test.

Co-developed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
---
 tools/testing/selftests/damon/Makefile        |   1 +
 .../selftests/damon/damon_perf_aux_test.sh    | 414 ++++++++++++++++++
 2 files changed, 415 insertions(+)
 create mode 100755 tools/testing/selftests/damon/damon_perf_aux_test.sh

diff --git a/tools/testing/selftests/damon/Makefile b/tools/testing/selftests/damon/Makefile
index 1db8fa95ba2d..204a0b60d84a 100644
--- a/tools/testing/selftests/damon/Makefile
+++ b/tools/testing/selftests/damon/Makefile
@@ -24,4 +24,5 @@ TEST_PROGS += sysfs_no_op_commit_break.py
 EXTRA_CLEAN = __pycache__
 
 TEST_PROGS += damon_perf_obs_test.sh
+TEST_PROGS += damon_perf_aux_test.sh
 include ../lib.mk
diff --git a/tools/testing/selftests/damon/damon_perf_aux_test.sh b/tools/testing/selftests/damon/damon_perf_aux_test.sh
new file mode 100755
index 000000000000..86ccaca6310c
--- /dev/null
+++ b/tools/testing/selftests/damon/damon_perf_aux_test.sh
@@ -0,0 +1,414 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# DAMON Perf AUX Backend - Automated Test
+#
+# Validates the AUX trace-buffer backend framework and the ARM SPE
+# backend:
+#   1. Source-level structure checks (files, Makefile, ops interface)
+#   2. SPE parser: runs the KUnit suite against byte-exact binary
+#      fixtures (mm/damon/perf/spe_parser_test.c) through debugfs
+#   3. Architecture checks (exact PMU match, SPSC ring contract,
+#      lifecycle ordering)
+#   4. Runtime smoke test: live DAMON session configured with an ARM
+#      SPE event.  Only runs when no kdamonds exist; the pre-test
+#      sysfs state is restored on exit.
+#
+# Usage:  sudo ./damon_perf_aux_test.sh [pmu-name]
+#
+# Requirements:
+#   - CONFIG_DAMON_PERF_OBSERVE=y
+#   - CONFIG_DAMON_PERF_SPE_KUNIT_TEST=y and CONFIG_KUNIT_DEBUGFS=y
+#     for section 2 (skipped otherwise)
+#   - CONFIG_ARM_SPE_PMU=y for section 4 (skipped otherwise)
+#   - Root privileges
+
+set -e
+PASSED=0; FAILED=0; SKIPPED=0
+pass() { echo "  [PASS] $1"; PASSED=$((PASSED + 1)); }
+fail() { echo "  [FAIL] $1"; FAILED=$((FAILED + 1)); }
+skip() { echo "  [SKIP] $*"; SKIPPED=$((SKIPPED + 1)); }
+
+PMU_NAME="${1:-arm_spe_0}"
+RESULTS_DIR=$(mktemp -d "${TMPDIR:-/tmp}/damon_aux_test.XXXXXX") || exit 1
+exec > >(tee "$RESULTS_DIR/output.log") 2>&1
+
+ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
+if [[ -z "$ROOT" ]]; then
+    ROOT="/usr/src/linux"
+fi
+SRC_DIR="$ROOT/mm/damon/perf"
+
+ADMIN="/sys/kernel/mm/damon/admin"
+
+echo "=========================================="
+echo " DAMON Perf AUX Backend Test"
+echo "=========================================="
+
+# ---- Section 1: Source structure ----
+if [[ -d "$SRC_DIR" && -f "$ROOT/mm/damon/core.c" ]]; then
+echo ""
+echo "--- 1. Backend Source Files ---"
+for f in aux_backend.h aux_backend.c spe_parser.h spe_backend.c spe_parser_test.c; do
+    if [[ -f "$SRC_DIR/$f" ]]; then
+        pass "Source file: $f"
+    else
+        fail "Source file: $f"
+    fi
+done
+
+echo ""
+echo "--- 2. Makefile Registration ---"
+for obj in aux_backend.o spe_backend.o spe_parser_test.o; do
+    if grep -q "$obj" "$SRC_DIR/Makefile" 2>/dev/null; then
+        pass "Makefile registers: $obj"
+    else
+        fail "Makefile registers: $obj"
+    fi
+done
+
+echo ""
+echo "--- 3. Backend Ops Interface ---"
+OPS_COUNT=$(grep -c '(\*match_pmu)\|(\*init)\|(\*cleanup)\|(\*arm)\|(\*disarm)\|(\*drain)' \
+    "$SRC_DIR/aux_backend.h" 2>/dev/null || echo 0)
+if [[ "$OPS_COUNT" -ge 6 ]]; then
+    pass "Backend ops interface: 6 ops defined ($OPS_COUNT found)"
+else
+    fail "Backend ops interface: expected 6 ops, found $OPS_COUNT"
+fi
+if grep -q 'DAMON_PERF_BACKEND_AUX' "$SRC_DIR/aux_backend.h" 2>/dev/null; then
+    pass "DAMON_PERF_BACKEND_AUX flag defined"
+else
+    fail "DAMON_PERF_BACKEND_AUX flag"
+fi
+
+echo ""
+echo "--- 4. SPE Parser Constants ---"
+for c in SPE_BUFFER_MIN_PAGES SPE_BUFFER_MAX_RECORDS SPE_HDR_MASK1 SPE_HDR_PAD \
+    SPE_HDR_END SPE_HDR_TIMESTAMP SPE_HDR_EXTENDED SPE_ADDR_DATA_VIRT \
+    SPE_OP_CLASS_LDST; do
+    if grep -q "$c" "$SRC_DIR/spe_parser.h" 2>/dev/null; then
+        pass "Parser constant: $c"
+    else
+        fail "Parser constant: $c"
+    fi
+done
+else
+    skip "source structure" "kernel source tree not available"
+fi
+
+# ---- Section 2: Parser correctness (KUnit, binary fixtures) ----
+echo ""
+echo "--- 5. SPE Parser: KUnit suite (binary fixtures) ---"
+KUNIT_DIR="/sys/kernel/debug/kunit/damon_perf_spe_parser"
+if [[ -d "$KUNIT_DIR" ]]; then
+    # Writing to "run" triggers a fresh run; "results" then holds the
+    # TAP output of the byte-exact fixture cases.
+    if [[ -f "$KUNIT_DIR/run" ]]; then
+        echo run > "$KUNIT_DIR/run" 2>/dev/null || true
+    fi
+    RES="$KUNIT_DIR/results"
+    if [[ -f "$RES" ]]; then
+        if grep -Eq "^[[:space:]]*not ok" "$RES"; then
+            fail "KUnit parser suite has failing cases"
+            grep -E "^[[:space:]]*not ok" "$RES" | sed 's/^/    /'
+        elif grep -Eq "^[[:space:]]*ok " "$RES"; then
+            pass "KUnit parser suite: all cases pass"
+        else
+            fail "KUnit parser suite produced no completed cases"
+        fi
+        echo "    $(grep '# Totals:' "$RES" | tail -1)"
+        # Spot-check the fixtures that cover the review-critical paths:
+        # record content, consumed-length accounting, truncation,
+        # alignment, extended packets, and error resync.
+        for c in "store record" "bad packet resync" \
+            "alignment packet at odd position" \
+            "alignment packet at aligned position" \
+            "extended address packet" \
+            "invalid extended header resync" \
+            "truncated trailing record retained" \
+            "truncated packet retained" \
+            "pad-only window"; do
+            if grep -Eq "^[[:space:]]*ok .*$c" "$RES"; then
+                pass "fixture: $c"
+            else
+                fail "fixture: $c"
+            fi
+        done
+    else
+        skip "KUnit results" "no results file (suite did not run)"
+    fi
+else
+    skip "KUnit parser suite" "CONFIG_KUNIT_DEBUGFS missing or suite not built"
+fi
+
+# ---- Section 3: Architecture checks ----
+echo ""
+echo "--- 6. Architecture Correctness ---"
+
+if [[ ! -d "$SRC_DIR" || ! -f "$ROOT/mm/damon/core.c" ]]; then
+    skip "architecture source checks" "kernel source tree not available"
+else
+
+# Exact PMU match by pmu object, not by name-prefix matching.
+if grep -q 'arm_spe_pmu_match' "$SRC_DIR/spe_backend.c" 2>/dev/null; then
+    pass "PMU match: exact match via arm_spe_pmu_match()"
+else
+    fail "PMU match: arm_spe_pmu_match() missing"
+fi
+if grep -q 'strncmp.*arm_spe' "$SRC_DIR/spe_backend.c" 2>/dev/null; then
+    fail "PMU match: strncmp name-prefix matching must not be used"
+else
+    pass "PMU match: no strncmp name-prefix matching"
+fi
+
+# Backend selection: gated on the ITRACE capability, then matched by PMU.
+if grep -q 'PERF_PMU_CAP_ITRACE' "$SRC_DIR/aux_backend.c" 2>/dev/null; then
+    pass "PMU selection: gated by PERF_PMU_CAP_ITRACE"
+else
+    fail "PMU selection: ITRACE gate missing"
+fi
+
+# Lifecycle ordering: arm() before perf_event_enable(), disarm() after
+# perf_event_disable().
+ARM_LINE=$(awk '/^int damon_perf_event_arm\(/ { in_fn=1 } \
+    in_fn && /ops->arm/ { print NR; exit }' "$ROOT/mm/damon/vaddr.c")
+ENABLE_LINE=$(awk '/^int damon_perf_event_arm\(/ { in_fn=1 } \
+    in_fn && /perf_event_enable/ { print NR; exit }' "$ROOT/mm/damon/vaddr.c")
+if [[ -n "$ARM_LINE" && -n "$ENABLE_LINE" && "$ARM_LINE" -lt "$ENABLE_LINE" ]]; then
+    pass "Lifecycle: ops->arm() before perf_event_enable()"
+else
+    fail "Lifecycle: arm() must precede perf_event_enable()"
+fi
+
+DISABLE_LINE=$(awk '/^void damon_perf_event_disarm\(/ { in_fn=1 } \
+    in_fn && /perf_event_disable/ { print NR; exit }' "$ROOT/mm/damon/vaddr.c")
+DISARM_LINE=$(awk '/^void damon_perf_event_disarm\(/ { in_fn=1 } \
+    in_fn && /ops->disarm/ { print NR; exit }' "$ROOT/mm/damon/vaddr.c")
+if [[ -n "$DISABLE_LINE" && -n "$DISARM_LINE" && "$DISABLE_LINE" -lt "$DISARM_LINE" ]]; then
+    pass "Lifecycle: ops->disarm() after perf_event_disable()"
+else
+    fail "Lifecycle: disarm() must follow perf_event_disable()"
+fi
+
+# The stop path calls the common check after disarming.  That common check
+# must drain AUX before it starts consuming the SPSC rings.
+DISARM_LOOP=$(grep -n 'damon_perf_event_disarm' "$ROOT/mm/damon/core.c" 2>/dev/null | \
+	tail -1 | cut -d: -f1)
+FINAL_CHECK=$(awk -v start="$DISARM_LOOP" 'NR > start && \
+    /kdamond_check_reported_accesses\(ctx\)/ { print NR; exit }' \
+    "$ROOT/mm/damon/core.c")
+if [[ -n "$DISARM_LOOP" && -n "$FINAL_CHECK" && \
+      "$DISARM_LOOP" -lt "$FINAL_CHECK" ]]; then
+    pass "Lifecycle: final common drain after disarm"
+else
+    fail "Lifecycle: final common drain must follow disarm"
+fi
+
+# Per-tick and final: AUX must publish before the SPSC loop reads rings.
+CHECK_FN=$(grep -n '^static unsigned int kdamond_check_reported_accesses' \
+    "$ROOT/mm/damon/core.c" | cut -d: -f1)
+DRAIN_TICK=$(awk -v start="$CHECK_FN" 'NR > start && \
+    /damon_perf_aux_drain\(ctx\)/ { print NR; exit }' "$ROOT/mm/damon/core.c")
+RING_DRAIN=$(awk -v start="$CHECK_FN" 'NR > start && \
+    /for_each_online_cpu\(cpu\)/ { print NR; exit }' "$ROOT/mm/damon/core.c")
+if [[ -n "$DRAIN_TICK" && -n "$RING_DRAIN" && \
+      "$DRAIN_TICK" -lt "$RING_DRAIN" ]]; then
+    pass "Tick: AUX drain before SPSC ring drain"
+else
+    fail "Tick: AUX drain must precede the ring drain"
+fi
+
+# Per-(event,cpu) parser state scoped via aux_priv.
+if grep -q 'aux_priv' "$ROOT/mm/damon/ops-common.h" 2>/dev/null; then
+    pass "State scoping: per-(event,cpu) via aux_priv"
+else
+    fail "State scoping: aux_priv in ops-common.h"
+fi
+
+# SPSC ring contract: kdamond is the only process-context producer and
+# writes only to its own CPU's ring.  A remote-write helper must not
+# exist.
+if grep -q 'damon_report_access_on_cpu' "$ROOT/mm/damon/core.c" 2>/dev/null; then
+    fail "SPSC: damon_report_access_on_cpu() must not exist"
+else
+    pass "SPSC: no remote-writer helper (current-CPU NMI-safe enqueue only)"
+fi
+if grep -q '^void damon_report_access' "$ROOT/mm/damon/core.c" 2>/dev/null; then
+    pass "SPSC: damon_report_access() present"
+else
+    fail "SPSC: damon_report_access() missing"
+fi
+fi
+
+# ---- Section 4: Runtime smoke test ----
+echo ""
+echo "--- 7. Runtime Smoke Test (live DAMON + SPE) ---"
+
+CREATED=0
+WORK_PID=""
+NR_SAVED=""
+if [[ -f "$ADMIN/kdamonds/nr_kdamonds" ]]; then
+    NR_SAVED=$(cat "$ADMIN/kdamonds/nr_kdamonds")
+fi
+
+restore_damon_state() {
+    # Tear down only what this test created, then restore the saved
+    # number of kdamonds.  A kdamond that was running before the test
+    # is never touched (section 7 skips in that case).
+    if [[ "$CREATED" == "1" ]]; then
+        echo off > "$ADMIN/kdamonds/0/state" 2>/dev/null || true
+        echo 0 > "$ADMIN/kdamonds/nr_kdamonds" 2>/dev/null || true
+        if [[ -n "$NR_SAVED" && "$NR_SAVED" -gt 0 ]]; then
+            echo "$NR_SAVED" > "$ADMIN/kdamonds/nr_kdamonds" 2>/dev/null || true
+        fi
+    fi
+    if [[ -n "$WORK_PID" ]]; then
+        kill "$WORK_PID" 2>/dev/null || true
+        wait "$WORK_PID" 2>/dev/null || true
+        WORK_PID=""
+    fi
+}
+trap restore_damon_state EXIT
+
+if [[ -z "$NR_SAVED" ]]; then
+    skip "runtime smoke" "DAMON admin interface not available"
+elif [[ "$NR_SAVED" -gt 0 ]]; then
+    skip "runtime smoke" "existing kdamonds present (nr_kdamonds=$NR_SAVED);" \
+        "refusing to disturb them"
+elif [[ ! -d "/sys/bus/event_source/devices/$PMU_NAME" ]]; then
+    skip "runtime smoke" "no $PMU_NAME PMU (kernel without ARM SPE or not booted with it)"
+else
+    SPE_TYPE=$(cat "/sys/bus/event_source/devices/$PMU_NAME/type")
+    pass "SPE PMU $PMU_NAME present (type=$SPE_TYPE)"
+    DMESG_LINES_BEFORE=$(dmesg 2>/dev/null | wc -l)
+
+    # Keep a userspace memory workload alive as both the DAMON target and
+    # an SPE data source.  The EXIT trap owns and terminates only this PID.
+    dd if=/dev/zero of=/dev/null bs=1M 2>/dev/null &
+    WORK_PID=$!
+
+    # arm_spe_pmu_event_init() rejects freq mode, so the event must be
+    # configured in period mode.
+    echo 1 > "$ADMIN/kdamonds/nr_kdamonds"
+    CREATED=1
+    echo 1 > "$ADMIN/kdamonds/0/contexts/nr_contexts"
+    echo 1 > "$ADMIN/kdamonds/0/contexts/0/targets/nr_targets"
+    echo "$WORK_PID" > "$ADMIN/kdamonds/0/contexts/0/targets/0/pid_target"
+    echo 1 > "$ADMIN/kdamonds/0/contexts/0/monitoring_attrs/sample/perf_events/nr_perf_events"
+    echo "$SPE_TYPE" > "$ADMIN/kdamonds/0/contexts/0/monitoring_attrs/sample/perf_events/0/type"
+    echo 0 > "$ADMIN/kdamonds/0/contexts/0/monitoring_attrs/sample/perf_events/0/freq"
+    echo 256 > "$ADMIN/kdamonds/0/contexts/0/monitoring_attrs/sample/perf_events/0/sample_period"
+    echo 3 > "$ADMIN/kdamonds/0/contexts/0/monitoring_attrs/sample/perf_events/0/config"
+    PE="$ADMIN/kdamonds/0/contexts/0/monitoring_attrs/sample/perf_events"
+    FREQ_VAL=$(cat "$PE/0/freq" 2>/dev/null || true)
+    if [[ "$FREQ_VAL" == "0" ]]; then
+        pass "SPE event in period mode (freq=0, period=256)"
+    else
+        fail "SPE event must use period mode (freq=0), read back $FREQ_VAL"
+    fi
+
+    STATS="/sys/kernel/debug/damon/perf_stats"
+    if [[ -r "$STATS" ]]; then
+        cp "$STATS" "$RESULTS_DIR/perf_stats-before.log"
+    fi
+
+    echo on > "$ADMIN/kdamonds/0/state"
+    sleep 5
+
+    STATE_NOW=$(cat "$ADMIN/kdamonds/0/state" 2>/dev/null || true)
+    if [[ "$STATE_NOW" == "on" ]]; then
+        pass "kdamond with SPE event is running"
+    else
+        fail "kdamond with SPE event failed to start (state=$STATE_NOW)"
+    fi
+
+    if [[ -r "$STATS" && -f "$RESULTS_DIR/perf_stats-before.log" ]]; then
+        cp "$STATS" "$RESULTS_DIR/perf_stats-running.log"
+    fi
+
+    # Stop explicitly so the final snapshot covers disable -> AUX drain ->
+    # SPSC ring drain, rather than leaving that path to the EXIT trap.
+    echo off > "$ADMIN/kdamonds/0/state"
+    for _ in $(seq 1 50); do
+        [[ "$(cat "$ADMIN/kdamonds/0/state" 2>/dev/null || true)" == "off" ]] && break
+        sleep 0.1
+    done
+    STATE_NOW=$(cat "$ADMIN/kdamonds/0/state" 2>/dev/null || true)
+    if [[ "$STATE_NOW" == "off" ]]; then
+        pass "kdamond stopped after final drain"
+    else
+        fail "kdamond did not stop (state=$STATE_NOW)"
+    fi
+
+    # Check only messages added during this run, not stale boot history.
+    DMESG_AFTER="$RESULTS_DIR/dmesg-after.log"
+    dmesg 2>/dev/null > "$DMESG_AFTER" || true
+    DMESG_LINES_AFTER=$(wc -l < "$DMESG_AFTER")
+    if [[ "$DMESG_LINES_AFTER" -ge "$DMESG_LINES_BEFORE" ]]; then
+        NEW_DMESG=$(tail -n "+$((DMESG_LINES_BEFORE + 1))" "$DMESG_AFTER")
+    else
+        NEW_DMESG=$(cat "$DMESG_AFTER")
+    fi
+    FAIL_LINES=$(printf '%s\n' "$NEW_DMESG" | \
+        grep -Ei "damon-perf.*(fail|warn|error)|WARNING:|BUG:|Oops:|lockdep" || true)
+    if [[ -n "$FAIL_LINES" ]]; then
+        fail "no damon-perf failures in dmesg"
+        echo "$FAIL_LINES" | sed 's/^/    /'
+    else
+        pass "no damon-perf failures in dmesg"
+    fi
+
+    if [[ -r "$STATS" && -f "$RESULTS_DIR/perf_stats-before.log" ]]; then
+        cp "$STATS" "$RESULTS_DIR/perf_stats-final.log"
+        pass "debugfs perf_stats readable"
+
+        stat_value() {
+            awk -v name="$2" '$1 == name { print $2; exit }' "$1"
+        }
+        for counter in callback valid enqueue dequeue match update; do
+            before=$(stat_value "$RESULTS_DIR/perf_stats-before.log" "$counter")
+            after=$(stat_value "$RESULTS_DIR/perf_stats-final.log" "$counter")
+            if [[ "$before" =~ ^[0-9]+$ && "$after" =~ ^[0-9]+$ ]]; then
+                delta=$((after - before))
+            else
+                delta=""
+            fi
+            if [[ "$delta" =~ ^[0-9]+$ && "$delta" -gt 0 ]]; then
+                pass "AUX pipeline: $counter delta=$delta"
+            else
+                fail "AUX pipeline: expected positive $counter delta, got ${delta:-missing}"
+            fi
+        done
+
+        enqueue_before=$(stat_value "$RESULTS_DIR/perf_stats-before.log" enqueue)
+        enqueue_final=$(stat_value "$RESULTS_DIR/perf_stats-final.log" enqueue)
+        dequeue_before=$(stat_value "$RESULTS_DIR/perf_stats-before.log" dequeue)
+        dequeue_final=$(stat_value "$RESULTS_DIR/perf_stats-final.log" dequeue)
+        enqueue_delta=$((enqueue_final - enqueue_before))
+        dequeue_delta=$((dequeue_final - dequeue_before))
+        if [[ "$enqueue_delta" -eq "$dequeue_delta" ]]; then
+            pass "final ring closure: enqueue=$enqueue_delta dequeue=$dequeue_delta"
+        else
+            fail "final ring closure: enqueue=$enqueue_delta dequeue=$dequeue_delta"
+        fi
+    else
+        fail "debugfs perf_stats unavailable; cannot validate AUX data path"
+    fi
+    # Cleanup happens in the EXIT trap (restore_damon_state).
+fi
+
+# ---- Summary ----
+echo ""
+echo "=========================================="
+echo " SUMMARY: $PASSED passed, $FAILED failed, $SKIPPED skipped"
+echo "=========================================="
+echo "Results saved to: $RESULTS_DIR"
+
+if [[ "$FAILED" -gt 0 ]]; then
+    echo "Overall: FAIL"
+    exit 1
+else
+    echo "Overall: PASS"
+    exit 0
+fi
-- 
2.43.0


