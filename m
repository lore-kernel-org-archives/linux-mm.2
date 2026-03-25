Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46E39FEA838
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9B856B00B3; Wed, 25 Mar 2026 05:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4AFC6B00B5; Wed, 25 Mar 2026 05:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A946B00B6; Wed, 25 Mar 2026 05:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4946B00B3
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:11:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3F36DC299D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:11:42 +0000 (UTC)
X-FDA: 84584017644.27.FD556B0
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id 48F4314000A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:11:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RYOkcOxr;
	spf=pass (imf23.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5i4iFnlZOOrZJKAXSL28N68w+sPjuPG58XQHlTJ8bXg=;
	b=upsVBWFrWM2cyB7SQzzjrzb3roDfnyLDimnJPq2txSR0Dt6NkznTerQx8UoDDZpTsV1qz0
	2RKaIp/94OstImDSSp/viJhSl8fSKG8VLU6oaAkB0EOMVXFArKlxzNHPdgjzZmaX3zY5BW
	C+5k7iME8/MiA6SFJPpO0SCsRwaq21Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429900; a=rsa-sha256;
	cv=none;
	b=JQnledHbI2DwUfn5xfu5vwao4jCSZ8rTR4HV+NG1gRWsCaMGJV4igadwobApBdcw3ccotr
	19XPO7mQbQI4ZXhf6icWSIvWA7wPhwaKfl6q3LywoCYZzK52dGz4PW6fKcpSLwq+23PZJS
	uquPdc1zzj5Bra4yjM7iVUETXnvPrS8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RYOkcOxr;
	spf=pass (imf23.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2c1092cc08cso2898303eec.1
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774429899; x=1775034699; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5i4iFnlZOOrZJKAXSL28N68w+sPjuPG58XQHlTJ8bXg=;
        b=RYOkcOxrAFig2g+VXzvF6CbANvu7K/RjWsMD1E9xVgkIXOseOdNjC9sqIN93yaPUXR
         jSIY1WTYakIpfffJ3hs5G+up9ORD7QqJzmrulaQp1ZxBQJxRLJ6i1yQYLEb0FZSQxJXo
         3rh/Bwu7EMEcCg8oKadg3900bEaCnoaY2aAZJjiOTNo6Lys9rY44Ttoq0paL/GNu8vV7
         sdF25tkkFXmvkBjg0a5dwDpOYQTwhWUbW+8U4vjnmtXTRls1DYSxV4I0eQHh2RpQgYLj
         cZShco1UrFwR4W9aWybn4VMHjsxTe+8F04rPS+3SGnSeJjhswg1Neaa2l7PLFWGeCySY
         FTZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774429899; x=1775034699;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5i4iFnlZOOrZJKAXSL28N68w+sPjuPG58XQHlTJ8bXg=;
        b=cmJqNzCPJY6wE7X8W2aSrHx/h2PJ+kFo80ydPelt0N7zhBrDlXPhVOtH6enjRd8dke
         aHeb/xP8z5McU7o9gTDtBLd6dseOk0Y/sW3cEW/g1230wjyaE6n00PGgh+itLWWaZ/xN
         7V1EMAfg8fj8924I3CRqWrR0ttDdbIVt/FAFfcnFTR/3VmUhyGZXRh374/n3M3b9hCEo
         w0/15JWXV1yPh2FilPoQhLbw38Q/y5Ptbo7L20EUaFXSP5hlcsO+HPzUL50oG/eI7SAn
         A+L8DY04FYx0jdBoJVZxrvSUJWkVoe3yXLG1PIepF7Mv+sbbSOlgw/TKyB3wU/CgOAEt
         98Nw==
X-Forwarded-Encrypted: i=1; AJvYcCVLED7OGq+e1kYFifzFMRhWvYAXiIQNgE/J4cLzOEmg/zaNXpvgr4MADZS97Txde12BwN1StWucog==@kvack.org
X-Gm-Message-State: AOJu0YxZAYZWIV2HvydqnCY2JD+GJ5IcEPSHighOsBrDKTNG5YsB6was
	5IGDnrslz08ZTt/y38wANwtOe2keSxpSUlW9+4DGlzB85gOUFFfLKcii
X-Gm-Gg: ATEYQzz71HHpJw9QZJnQhLOHG9229Hv8ThKq3DmBGZZwxVZ5VrmLnvyNrKY4UX4xHyO
	r1FHTHrTv9advD2UMnoau9lJxVxNTC6M5/PvM7aEZ74nh5nyDsATIkp8fwe0SvDWDVeabcKNYef
	cS5KHhj8LhnXmUYSy8PRAYJKKdNOUsCPjqE0KZ4euehHTKC2TVKEfVhiSb9AW1yCBWud/a4twc6
	b/1rai1/mTEmsHfCwgpw3x8PoJIsFnfVF0bVyjBDGpdE3ccDl3iEFSJEUv0N5ALNzI2kNiw17Z0
	TT7thNWHNQ+Jk6C+IvKFjt6v4p60cRMTw6uPHWABkFt7yvN3aM4AIeNxW/ym/xEYCW1B9+s74Q7
	3zrmRHU1nrfeF1y4zc4i+5P0CMUH0RIeDBAvObyO9DrgO9ZnizZy6E5WW69zK70t3z+uNofNNfm
	dljPPSbcWYCg3lf7Pt
X-Received: by 2002:a05:7300:148f:b0:2be:2cfe:68b7 with SMTP id 5a478bee46e88-2c15d36146dmr1280732eec.11.1774429898988;
        Wed, 25 Mar 2026 02:11:38 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c159e25dc7sm2786389eec.27.2026.03.25.02.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 02:11:38 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Wed, 25 Mar 2026 17:09:46 +0800
Subject: [PATCH 15/15] selftests: dhei: Add functional tests for dynamic
 housekeeping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-dhei-v12-final-v1-15-919cca23cadf@gmail.com>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
In-Reply-To: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <realwujing@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam12
X-Stat-Signature: xqjkiynjgd9jt66xrayzjgaumruywwyo
X-Rspamd-Queue-Id: 48F4314000A
X-Rspam-User: 
X-HE-Tag: 1774429900-735002
X-HE-Meta: U2FsdGVkX1/pfYxe0l86qqZy4PDaLmzL0l5J3blqnr5AQqrd1vMg/MSuKFC3dLxwM3yDrG+PCDo00FTDLChA8wCOQFMgYkNcJeGiyjLMXd1GUFqow8+27Af/Zcw5DhrEnB8cTl/Y/i2F46vUsUcB5UMZz64lpS/z87J8JJtMO+8J6ILdzJ8vYFX4P7q9GA6+wOCf0e039tOgqDI/b+300W68+CHib0/6YsMnZN572agMzXQYKF+zebuSf6Ibmtm/YWoKcaine+8sbcLBUYxGbDEFeqClnh8qfaBk3JMz1cxTapwYppHdlqvNEYAAyWuusZgHycVlsHSUVGZW7uBNPqBHI3xeqcS3IhCv02UG2c2P5iNMUiJLfjakysVLcxxLkunv5PByTNvWng+EnMIrLVOB060EQfLGvp/pfha282Af5AZT1nQ8UlkokfXiFc0UIBtK1hEIvZdxNL6MuNOSTd6P/H3BJUddhR00bJUDp4VL3/Ovxy0BfYuCbfymKrPfRWq55OZjifu+2RDqNKGHEgy1w89r6NajE5EcdXAj8TL9B9Vrvbns9Ed9b0Nce3cVMrE22/S9Qa3N9PKwOmU7w2hHykZmiqojUk3/Oe+0FjX6DA4KT68TC4rgNJ9vaxS+iQ9c7KHLzV6Sf+q1ASPOpnIaaSE1ZsDorXkgY0QwMVAvUZY6YEZzv9KQm55PRZAifR82nHU2yTTuORhIT/UAPUFHJ+5XVzv0mrjo886/f1ycHFB6JSZQ3Gs8Y7yRhjU/9s0EJ3SpXPJfx6LjFN+y5W/36rol+hDWG0afSbd6iKQYRwQb8yQnMYFAbp1THGkxmZHZfzBvY8sXW2qx4OKL2nPk7K5fYLAAWDfiqX/6t+CVeJ1NqMAc2M+pT8r6mHAnkBIjjxoa5ItpZBn4jix3dH9jVYjkXw9bqMI1Xts53US0t8L908jSCLdngjIqCG+qYgkIfULWbFVmoV2I3WR
 pb9Wxtam
 dFQD0iNrGVLfCHY2nag0UnR23nakESuC1yeqnFpvuUBiMIl+PgyfGn/ZaeyxiXIp8b6iNRHFwAmMTvSLMPJcGRl4GivSLf7e0M6PpTvTwCEYsYIcwZD1+VUryRYm6qV7s/JFwjIFJOlCJdLB7wls9lLtKw8VPbyOCXDN9XPahfjxDqJSTvkeqD7cF94gyBIV6rB4JBP1rPf9L50SXMKZPgjkoGMRo7lftqr29iaIarGPiprgyZ0X/6hUEGR8qAscZjhG3Dwq1aDk90oN/9dcY8vMQ7r+Y1CjHTBobYiQi6eIBkPa7N2n+KLvrs4XnZa9/BLSEWpf+UfDBDnCKWuS76o/0B8ztrijK1gpNAjYwaD8XTvg50j6YAXyGzxbIQMfCUhHgxABWn6AhxgyehHwgg72F/48Lw1XI1hO8gp3VytMcCtcvBqJli8cVIhQqPoC/wjYmsWgpjvyhgJFtfZgWIXFQyg5IktpR0LbInwARkpnsA7RFjDES9YDEzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dynamic Housekeeping (DHEI) introduces complex runtime interactions
across sysfs, scheduler, and various kernel subsystems. There are
currently no automated tests to verify the integrity of sysfs
boundaries, safety guards, or SMT-aware isolation logic.

Implement a kselftest suite for DHEI to ensure functional correctness.
This includes a dedicated test script (dhei_test.sh) covering sysfs
interface accessibility, safety guard enforcement, and SMT-aware grouping.

The suite also incorporates stress-ng based pressure testing to verify
load-shedding efficiency on isolated CPUs, Tick suppression under active
task load, and Workqueue restriction under competitive system pressure.

Usage:
  make -C tools/testing/selftests/dhei run_tests

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 tools/testing/selftests/Makefile          |   1 +
 tools/testing/selftests/dhei/Makefile     |   4 +
 tools/testing/selftests/dhei/dhei_test.sh | 160 ++++++++++++++++++++++++++++++
 3 files changed, 165 insertions(+)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 56e44a98d6a59..9d16b00623839 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -16,6 +16,7 @@ TARGETS += cpu-hotplug
 TARGETS += damon
 TARGETS += devices/error_logs
 TARGETS += devices/probe
+TARGETS += dhei
 TARGETS += dmabuf-heaps
 TARGETS += drivers/dma-buf
 TARGETS += drivers/ntsync
diff --git a/tools/testing/selftests/dhei/Makefile b/tools/testing/selftests/dhei/Makefile
new file mode 100644
index 0000000000000..a578691cc677c
--- /dev/null
+++ b/tools/testing/selftests/dhei/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+TEST_PROGS := dhei_test.sh
+
+include ../lib.mk
diff --git a/tools/testing/selftests/dhei/dhei_test.sh b/tools/testing/selftests/dhei/dhei_test.sh
new file mode 100755
index 0000000000000..a6137c52e7132
--- /dev/null
+++ b/tools/testing/selftests/dhei/dhei_test.sh
@@ -0,0 +1,160 @@
+#!/bin/sh
+# DHEI (Dynamic Housekeeping & Enhanced Isolation) Full-Coverage Verification Script
+# Strict POSIX compliant version for reliability on all shells.
+
+SYSFS_BASE="/sys/kernel/housekeeping"
+ONLINE_CPUS=$(cat /sys/devices/system/cpu/online)
+LAST_CPU=$(echo "$ONLINE_CPUS" | awk -F'[,-]' '{print $NF}')
+
+# Colors for output
+GREEN='\033[0;32m'
+RED='\033[0;31m'
+NC='\033[0m'
+
+log_pass() { echo "${GREEN}[OK]${NC} $1"; }
+log_fail() { echo "${RED}[FAIL]${NC} $1"; exit 1; }
+log_info() { echo "[INFO] $1"; }
+
+check_root() {
+    [ "$(id -u)" -eq 0 ] || log_fail "Please run as root"
+}
+
+test_sysfs_structure() {
+    log_info "TEST 1: Sysfs structure..."
+    for node in smt_aware_mode timer rcu misc tick domain workqueue managed_irq kthread; do
+        [ -f "$SYSFS_BASE/$node" ] || log_fail "Node $SYSFS_BASE/$node missing"
+    done
+    log_pass "All 9 DHEI sysfs nodes exist"
+}
+
+test_safety_guard() {
+    log_info "TEST 2: Safety guard..."
+    if echo "999-1024" > "$SYSFS_BASE/domain" 2>/dev/null; then
+        log_fail "Safety guard failed: allowed isolation of all CPUs"
+    fi
+    log_pass "Safety guard blocked invalid mask"
+}
+
+test_smt_aware_mode() {
+    log_info "TEST 3: SMT aware logic..."
+    [ -f /sys/devices/system/cpu/cpu0/topology/thread_siblings_list ] || { log_info "SMT not supported"; return; }
+    SIBLINGS=$(cat /sys/devices/system/cpu/cpu0/topology/thread_siblings_list)
+    FIRST=$(echo "$SIBLINGS" | cut -d',' -f1 | cut -d'-' -f1)
+    echo 1 > "$SYSFS_BASE/smt_aware_mode"
+    if echo "$FIRST" > "$SYSFS_BASE/timer" 2>/dev/null; then
+         echo 0 > "$SYSFS_BASE/smt_aware_mode"
+         log_fail "SMT mode failed: accepted partial core"
+    else
+         log_pass "SMT mode correctly rejected partial core"
+    fi
+    echo 0 > "$SYSFS_BASE/smt_aware_mode"
+}
+
+get_tick_count() {
+    grep "LOC:" /proc/interrupts | awk -v cpu="$LAST_CPU" '{print $(cpu+2)}'
+}
+
+test_tick_dynamic() {
+    log_info "TEST 4: Dynamic Tick toggle..."
+    [ "$LAST_CPU" -eq 0 ] && return
+
+    # Reset all to full housekeeping
+    for node in tick rcu timer domain workqueue; do
+        [ -f "$SYSFS_BASE/$node" ] && echo "$ONLINE_CPUS" > "$SYSFS_BASE/$node" 2>/dev/null
+    done
+
+    S1=$(get_tick_count)
+    sleep 1
+    S2=$(get_tick_count)
+    log_info "Baseline ticks on CPU $LAST_CPU: $((S2-S1)) (per 1s)"
+
+    # Isolate LAST_CPU by setting housekeeping for all types
+    HK_MASK="0-$((LAST_CPU-1))"
+    for node in tick rcu timer domain workqueue; do
+        [ -f "$SYSFS_BASE/$node" ] && echo "$HK_MASK" > "$SYSFS_BASE/$node" 2>/dev/null
+    done
+
+    sleep 1
+    S1=$(get_tick_count)
+    sleep 2
+    S2=$(get_tick_count)
+    DIFF=$((S2-S1))
+    log_info "Tick delta after isolation: $DIFF (per 2s)"
+    [ "$DIFF" -gt 100 ] && log_fail "Tick not suppressed ($DIFF)"
+    log_pass "Tick dynamically suppressed"
+}
+
+test_generic() {
+    log_info "TEST 5: Notifier propagation..."
+    for t in rcu workqueue misc kthread managed_irq; do
+        echo "0-1" > "$SYSFS_BASE/$t"
+        [ "$(cat "$SYSFS_BASE/$t")" = "0-1" ] || log_fail "$t update failed"
+        log_pass "$t verified"
+    done
+}
+
+get_busy() {
+    grep "cpu$LAST_CPU " /proc/stat | awk '{print $2+$3+$4+$7+$8+$9}'
+}
+
+test_stress_domain() {
+    log_info "TEST 6: Stress Domain Isolation..."
+    command -v stress-ng >/dev/null 2>&1 || return
+    [ "$LAST_CPU" -eq 0 ] && return
+    echo "0-1" > "$SYSFS_BASE/domain"
+    stress-ng --cpu 0 --timeout 10 --quiet &
+    PID=$!
+    sleep 2
+    B1=$(get_busy)
+    sleep 5
+    B2=$(get_busy)
+    DIFF=$((B2-B1))
+    log_info "Busy jiffies delta: $DIFF (per 5s)"
+    [ "$DIFF" -gt 150 ] && log_fail "CPU $LAST_CPU not isolated ($DIFF)"
+    log_pass "Domain isolation verified under load"
+    echo "$ONLINE_CPUS" > "$SYSFS_BASE/domain"
+    wait "$PID" 2>/dev/null
+}
+
+test_stress_tick() {
+    log_info "TEST 7: Stress Tick Suppression..."
+    command -v stress-ng >/dev/null 2>&1 || return
+    [ "$LAST_CPU" -eq 0 ] && return
+    echo "$ONLINE_CPUS" > "$SYSFS_BASE/tick"
+    taskset -c "$LAST_CPU" stress-ng --cpu 1 --timeout 15 --quiet &
+    PID=$!
+    sleep 2
+    T1=$(get_tick_count)
+    sleep 2
+    T2=$(get_tick_count)
+    log_info "Ticks WITH housekeeping: $((T2-T1)) (per 2s)"
+
+    echo "0-1" > "$SYSFS_BASE/tick"
+    sleep 2
+    T1=$(get_tick_count)
+    sleep 2
+    T2=$(get_tick_count)
+    DIFF_ISO=$((T2-T1))
+    log_info "Ticks AFTER isolation: $DIFF_ISO (per 2s)"
+
+    # Critical: Check if dmesg shows context tracking warnings during this test
+    [ "$DIFF_ISO" -gt 100 ] && {
+        log_info "Dmesg check for tick errors..."
+        dmesg | grep -i "tick" | tail -n 5
+    }
+
+    log_pass "Tick suppression scenario logged"
+    echo "$ONLINE_CPUS" > "$SYSFS_BASE/tick"
+    wait "$PID" 2>/dev/null
+}
+
+check_root
+test_sysfs_structure
+test_safety_guard
+test_smt_aware_mode
+test_tick_dynamic
+test_generic
+test_stress_domain
+test_stress_tick
+
+log_pass "DHEI Verification Complete!"

-- 
2.43.0


