Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E204C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 21:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BF856B00B5; Tue, 30 Jun 2026 17:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3218B6B00B6; Tue, 30 Jun 2026 17:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C2FE6B00B7; Tue, 30 Jun 2026 17:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBCB76B00B5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:19:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3884840135
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:19:10 +0000 (UTC)
X-FDA: 84937844460.30.43BFDCB
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id 729DCA0004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:19:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZT9ANGyc;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782854348;
	b=Ah13hVildK2zJL0iuYAV4H47pl7Y6ZJbkuTqXA0U9JkQbKO1cwJsp0BUPAIoWp7xnbRMB6
	/Zf5KX6SXXSmodhttOpMtYezTQjtIepAPpfUn9a6DBGYasLuaQaM24wDL9H/wLpZPWuTD7
	vNPKyv+Sx1KCJCMtlgCSgoO3qAnSPk0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782854348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dr7k1s5kclXSnhlA0wjw73kcYoyYlKmbVekQHgXAunw=;
	b=gjsf8cZVcvYP3blL7tmUmlRvqM1N/4GdOyOXCiSMkppt2S0kSRvkkkLrA9nS9j92SiHNHb
	b7PG/k6q5K0Jrkay0T/fXEqqPsLvj922oeg20ly7F3eQKQ5WZu77xZCZ22lyibYM1OP3s3
	sv2sEupt8ozQYX5txP2m3kvsBqQXXoU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZT9ANGyc;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8eaa7b5e31eso9646976d6.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854347; x=1783459147; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dr7k1s5kclXSnhlA0wjw73kcYoyYlKmbVekQHgXAunw=;
        b=ZT9ANGycXT3Da8SlOupIky7qwbR5see0KP698viuGvgw4z7KtfhCFZc4VGPGtbE9Mt
         blG7LV5HeNPvFl1MxnGe2HL5m1OrdXIMxlxwz4XjnjIxpM1fLQ7hD1grPljZoDMgHOvj
         KEeQX1bu95s2LzyKTeAJtNlTVmhO9WdlM4KlFKIEdCMySpFxZdSGBMtPlYgo3z/o8vHm
         T32CBxEeziN68YNWSqzEiTVRwOHkzf+qsMDEZn0IM4PlbTyLbNouLVm0Pt7aWcK9bCrk
         06pwOr+yVgsRo/za1rxf9HZxk5ZtKjSZpYbycJVGVxIwnboOTO56J6HVgJP0KSLjwGDS
         XBgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854347; x=1783459147;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Dr7k1s5kclXSnhlA0wjw73kcYoyYlKmbVekQHgXAunw=;
        b=FSrhpe9DhETezJecE2R6b+XFsMNppXbVIOm13NS5rhOYw+ggamcXhbr4kL9n4vcG2P
         VjSkA5gJfy7yQQaHIBjYlfovsk84ShBM2xbN/apkqQfXQeUtgqcU2K2LT6CWwbRRhjvL
         rH1BG80ocOJXzKLerAmTCVhHb8KpiqqLKseD7SCKLa1o45iYg8gNDnhaVFFk3wU3F3ci
         WUm8oG4+qh0t+oFf9TuN1ePtOtrLCQaXmpwPzpbDmdrfEa1bbJnu/0Yva2NRcfd5CiK0
         KY8zpQCbA2Z+/CMnTgygWFswqkr1gxU1r+F7t8FO7cmc53vPjuLcmduDbl228N0XLSFd
         DixQ==
X-Gm-Message-State: AOJu0YwP1hx0AYPvGcvXONkuTlGc0gtwcsq4qAsgusxcTiz1Z8epOhOT
	SWq5IRIGidrtNlucTIorUTcagsh8pZLLvzq//nVTJYl0qm2O6+R448+AS0lTSF6dgbsYQ8nHD1a
	MHyyj
X-Gm-Gg: AfdE7cn2ENWUzr6eC98oivkclSUsI1gwF/BHam/Y50Rgk3F2X02UUWDDEJQ8TMc5DRm
	2NoMi3kwXfLBjkfzmBx3kMNlZ8QCWQhbTD16cXVo/d4qV1rI/7IbWP8AhQ7REF5WNQB66fkqfqS
	Ca1HIRSrDax+5WSZD5ux493snkDMzvI22JnbjrseFKvykrMUnFjehJuN4QESLw2Beu6XEDueUOZ
	QYWs2WB+lISAzFHLMXuWUy+h9f11MZkpMYzW99fphgTUIkmTP1O2dgecRTm1vpW/6MTCQ2Dho7s
	QRi9Bj6wjduPappexz5rDOzCvdlmc/sbTouz4k+PswUSA2fEEfPQlgrHZ75ozAMzGhMc5Bw8iaE
	/no2cDBIEgGEN0fDvtshDirNoG2e2sag+kswo/D/6xYVEVXSxrHF2kr/mKCh9UgHwt3RK6t7D+X
	L41QKtKCcDjiHMM3WJPRat0y46ALrNNkNuA827YLK61cMoytRSpPaGZfbTK6kqfziL9s4NCFN2Z
	K7quJ7Pu1Da
X-Received: by 2002:a05:620a:4008:b0:92e:5232:91f8 with SMTP id af79cd13be357-92e698667f9mr485377585a.43.1782854347322;
        Tue, 30 Jun 2026 14:19:07 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:19:06 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com,
	apopple@nvidia.com
Subject: [PATCH v6 10/10] selftests/dax: add dax/kmem hotplug sysfs regression test
Date: Tue, 30 Jun 2026 17:18:42 -0400
Message-ID: <20260630211842.2252800-11-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260630211842.2252800-1-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 729DCA0004
X-Stat-Signature: me79dg1x85wmgeqpua4y3h88cy8fdysy
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782854348-516198
X-HE-Meta: U2FsdGVkX1+C1PEO0vElM/vDVVXlLNP1JH6/x4y3HMEwlG342b+nsoZdvmXbRTQTf8D0TjgImhai+4k+ryXFlDfyKnNtnnHa/KxXg1EcdF72HbX/U7Q48S331305j49x/miU3YKAm610L0OTXeoyj2ZDPDxa9XHRHxDpfI+OlnXy40ANQD+nHUqDzVZqn9/pRUCVM+KzALHewHxY9ulVIhjlW2+krIgUKfj8Yy54MOUXUBiJCFhmcmgVUbVZOFjwynNBeNGlVbRgeDZl3RapGdboRh8wRhlQqO7t3CwjRbsoHIRxRnbranMuVyhSYWquoLaZfsK+NseRmf80tF1ZTi8vwE0oVwyhCSE9EemnobA4X+6hzqtcbDiKVYCztO+kj938ObDDt7dSjPLfzm1Zy6sXn7IayYmLM3rMlAPhJ2J3oYR27juwyhdyAELcpkrmrLFqyi+yTNGPHnScxdgE4fIjtbkqsvfExLyH3b45SBuh1ORcxsKCMlHmyhxNX9jf0dSxZqo8tQUhv47DBs9+MjPbRsw2MSMU/mCjSMcTxNP/KvyKo2dqJzPwWOMP3icXtQK4AU1ofbCzDZSsfa28/d+7gTWrr38WzLeytNmGiCii+5TQWeVUR7XZcRPsT5kGOzHYemWQ/2h/fVuFHg+2ToXR5X18WC4wvBBW6hvNE9pJLHicFK/xsvM+oiJztq/xPvP86oUmQzMOqxK5fZoajC3MQEcDc72QWLpI6sDJ51+krWHqgvS7VcIIjxaYEqu8wl159d3TJcQGvZgqYQohyZUowJbZRfvaFZSiLo2cminX/DKsFyq3U3ZFC3wwNJk+XzkNrmrrmP3i6fbYo/QFPqPTTR6Z9r5IiTahZ1URAdV3kHNTD7Ab92IfZZgL8Ieb/2oYpHtjqVu9rtBJhX4PeYeGcxg0qEBXLXOpFO7icG6TbEov2SVCnk7BOg0xrH/+doIautXzLBjA9JSi3Il
 UhaJhBgC
 jf5zmNMSp0X0lFUXB+GTiAC7vr+HmqRRPIjSlBxtYfp01+np2AAZrY37KSNecBjhV2cICQw0vWOn9QIrsGb1v2ArJyh09n4k14qFb7LrYcxIj70G6Nv7lL8bP62+hlo4o3DdxLqCW+CPNiFfPENIot8ra1aeIpYUMB7JbHZlMzunQfZsx745PEkSWsU+o+x0dW5LnXXqGpSJhBGEwDdAKWBwkRsF+Zxj/js1a3rY6JA9q/u5HInZiNr5AEi+uhNuGa+9+lYdrti/N03fBPRZJTdvMtN8M+l6K9fm8j1LcVfUJCNgNYHZBb+takw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a kselftest for the dax/kmem whole-device "state" sysfs attribute
(/sys/bus/dax/devices/daxX.Y/state), which transitions a kmem-backed
dax device between "unplugged", "online" and "online_movable".

The kselftest also includes a test to demonstrate the force-unbind
does not deadlock - but this is a destructive test.  The dax device
can never be rebound after doing this.

Provisioning a devdax device and binding it to kmem needs daxctl/ndctl
out of scope for an in-tree selftest, so the test discovers an already
kmem-bound dax device and SKIPs when none are present or the memory
cannot be freed to reach a known baseline.

When a device is available it validates the interface contract:
  - online / online_movable actually add memory (MemTotal grows),
  - online is idempotent,
  - switching between online types without unplug is rejected,
  - unplug removes memory and the reported state is "unplugged"
  - invalid input is rejected.

One specific regression test:
    online -> unplug -> online_movable -> unplug

Re-online must re-reserve per-range resources so subsequent unplug
actually offlines and removes instead of silently reporting success
while the memory stays online.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/dax/Makefile          |   6 +
 tools/testing/selftests/dax/config            |   4 +
 .../testing/selftests/dax/dax-kmem-hotplug.sh | 190 ++++++++++++++++++
 tools/testing/selftests/dax/settings          |   1 +
 5 files changed, 202 insertions(+)
 create mode 100644 tools/testing/selftests/dax/Makefile
 create mode 100644 tools/testing/selftests/dax/config
 create mode 100755 tools/testing/selftests/dax/dax-kmem-hotplug.sh
 create mode 100644 tools/testing/selftests/dax/settings

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 6e59b8f63e41..8c2b4f97619c 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -14,6 +14,7 @@ TARGETS += core
 TARGETS += cpufreq
 TARGETS += cpu-hotplug
 TARGETS += damon
+TARGETS += dax
 TARGETS += devices/error_logs
 TARGETS += devices/probe
 TARGETS += dmabuf-heaps
diff --git a/tools/testing/selftests/dax/Makefile b/tools/testing/selftests/dax/Makefile
new file mode 100644
index 000000000000..25a4f3d73a5b
--- /dev/null
+++ b/tools/testing/selftests/dax/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+all:
+
+TEST_PROGS := dax-kmem-hotplug.sh
+
+include ../lib.mk
diff --git a/tools/testing/selftests/dax/config b/tools/testing/selftests/dax/config
new file mode 100644
index 000000000000..4c9aaeb6ceb4
--- /dev/null
+++ b/tools/testing/selftests/dax/config
@@ -0,0 +1,4 @@
+CONFIG_DEV_DAX=m
+CONFIG_DEV_DAX_KMEM=m
+CONFIG_MEMORY_HOTPLUG=y
+CONFIG_MEMORY_HOTREMOVE=y
diff --git a/tools/testing/selftests/dax/dax-kmem-hotplug.sh b/tools/testing/selftests/dax/dax-kmem-hotplug.sh
new file mode 100755
index 000000000000..c8bbaf6178ed
--- /dev/null
+++ b/tools/testing/selftests/dax/dax-kmem-hotplug.sh
@@ -0,0 +1,190 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Exercise the dax/kmem "state" sysfs attribute:
+#   /sys/bus/dax/devices/daxX.Y/state  ->  unplugged | online | online_kernel | online_movable
+#
+# The test needs a dax device already bound to the kmem driver.
+# If no suitable device is found the tests SKIP.
+#
+# A dax device can be provisioned with the memmap= boot param, e.g.:
+#   memmap=2G!4G
+#
+# then, in the booted system:
+#
+#   ndctl create-namespace -m devdax -e namespace0.0 -f
+#   daxctl reconfigure-device -N -m system-ram dax0.0   # bind kmem
+#   ./dax-kmem-hotplug.sh
+
+# shellcheck disable=SC1091
+DIR="$(dirname "$(readlink -f "$0")")"
+. "$DIR"/../kselftest/ktap_helpers.sh
+
+DAX_BASE=/sys/bus/dax/devices
+
+memtotal_kb() { awk '/^MemTotal:/ {print $2}' /proc/meminfo; }
+get_state() { cat "$HP" 2>/dev/null; }
+# set_state STATE -- write a state to the state attribute; returns the
+# write's exit status (0 = accepted by the kernel)
+set_state() { echo "$1" > "$HP" 2>/dev/null; }
+
+find_kmem_dax() {
+	local d drv
+	for d in "$DAX_BASE"/dax*; do
+		[ -e "$d/state" ] || continue
+		drv=$(readlink "$d/driver" 2>/dev/null)
+		[ "$(basename "${drv:-}")" = kmem ] || continue
+		basename "$d"
+		return 0
+	done
+	return 1
+}
+
+ktap_print_header
+
+if [ "$UID" != 0 ]; then
+	ktap_skip_all "must be run as root"
+	exit "$KSFT_SKIP"
+fi
+
+DAX=$(find_kmem_dax)
+if [ -z "$DAX" ]; then
+	ktap_skip_all "no kmem-bound dax device with a state attribute"
+	exit "$KSFT_SKIP"
+fi
+HP=$DAX_BASE/$DAX/state
+ORIG=$(get_state)
+
+# A failure to reach the baseline is environmental (memory in use), not an
+# interface failure, so skip rather than fail.
+set_state unplugged; rc=$?
+if [ "$rc" != 0 ] || [ "$(get_state)" != unplugged ]; then
+	ktap_skip_all "$DAX: cannot reach 'unplugged' baseline (memory in use?)"
+	[ -n "$ORIG" ] && set_state "$ORIG"
+	exit "$KSFT_SKIP"
+fi
+mt_unplugged=$(memtotal_kb)
+
+DRV=/sys/bus/dax/drivers/kmem
+AOB=/sys/devices/system/memory/auto_online_blocks
+
+ktap_print_msg "using $DAX (initial state was: $ORIG)"
+ktap_set_plan 8
+
+# A public (N_MEMORY) kmem node onlined into a kernel zone (online/online_kernel)
+# collects unmovable allocations and can then never be offlined, which would
+# wedge the device for the rest of this test.  So this test only ever
+# successfully onlines online_movable, the one mode that is reliably unpluggable.
+
+set_state online_movable; rc=$?
+mt_online=$(memtotal_kb)
+if [ "$rc" = 0 ] && [ "$(get_state)" = online_movable ] && [ "$mt_online" -gt "$mt_unplugged" ]; then
+	ktap_test_pass "online_movable: state=online_movable, MemTotal $mt_unplugged -> $mt_online kB"
+else
+	ktap_test_fail "online_movable: rc=$rc state=$(get_state) MemTotal $mt_unplugged -> $mt_online"
+fi
+
+set_state online_movable; rc=$?
+if [ "$rc" = 0 ] && [ "$(get_state)" = online_movable ]; then
+	ktap_test_pass "online_movable idempotent"
+else
+	ktap_test_fail "online_movable idempotent: rc=$rc state=$(get_state)"
+fi
+
+# A different online type is rejected without an intervening unplug.  The write
+# is refused before any hotplug, so this never actually onlines a kernel zone.
+set_state online_kernel; rc=$?
+if [ "$rc" != 0 ] && [ "$(get_state)" = online_movable ]; then
+	ktap_test_pass "reject online_kernel without intervening unplug (no kernel-zone online)"
+else
+	ktap_test_fail "online_movable->online_kernel not rejected: rc=$rc state=$(get_state)"
+fi
+
+set_state unplugged; rc=$?
+mt=$(memtotal_kb)
+if [ "$rc" = 0 ] && [ "$(get_state)" = unplugged ] && [ "$mt" -lt "$mt_online" ]; then
+	ktap_test_pass "unplug from online_movable: MemTotal $mt_online -> $mt kB"
+else
+	ktap_test_fail "unplug from online_movable: rc=$rc state=$(get_state) MemTotal $mt_online -> $mt"
+fi
+
+before=$(get_state)
+set_state bogus_state; rc=$?
+if [ "$rc" != 0 ] && [ "$(get_state)" = "$before" ]; then
+	ktap_test_pass "reject invalid state string"
+else
+	ktap_test_fail "invalid state not rejected: rc=$rc state=$(get_state)"
+fi
+
+# The online_movable -> unplug cycle once regressed: a re-online failed to
+# re-reserve the per-range resources, so a later unplug reported success while
+# leaving the memory online.  Assert each iteration really adds and frees memory.
+set_state unplugged
+cycle_ok=1; fail_i=0; on=0; off=0
+for i in 1 2 3; do
+	if ! set_state online_movable; then cycle_ok=0; fail_i=$i; break; fi
+	on=$(memtotal_kb)
+	if ! set_state unplugged; then cycle_ok=0; fail_i=$i; break; fi
+	off=$(memtotal_kb)
+	if [ "$on" -le "$mt_unplugged" ] || [ "$off" -ge "$on" ]; then
+		cycle_ok=0; fail_i=$i; break
+	fi
+done
+if [ "$cycle_ok" = 1 ]; then
+	ktap_test_pass "online_movable/unplug cycle re-acquires resources (3x: added and freed each time)"
+else
+	ktap_test_fail "online_movable/unplug cycle regressed at iteration $fail_i (on=$on off=$off baseline=$mt_unplugged)"
+fi
+
+# change system default online policy while the device is unbound, and show
+# the new system default policy is utilized across bindings.
+set_state unplugged
+if [ -w "$AOB" ] && [ -w "$DRV/unbind" ] && [ -w "$DRV/bind" ]; then
+	orig_aob=$(cat "$AOB")
+	echo "$DAX" > "$DRV/unbind" 2>/dev/null
+	echo offline > "$AOB" 2>/dev/null
+	echo "$DAX" > "$DRV/bind" 2>/dev/null
+	sleep 1
+	st=$(get_state)
+	echo "$orig_aob" > "$AOB" 2>/dev/null		# restore system policy
+	if [ "$st" = offline ]; then
+		ktap_test_pass "online policy resolved at bind: auto_online_blocks=offline -> state=offline"
+	else
+		ktap_test_fail "bind-time policy not honored: state=$st (expected offline)"
+	fi
+	set_state unplugged 2>/dev/null
+else
+	ktap_test_skip "auto_online_blocks or driver bind/unbind not writable"
+fi
+
+[ -n "$ORIG" ] && set_state "$ORIG"
+
+# DESTRUCTIVE: unbinding the driver while memory is online causes the resources
+# to leak - but the unbind should not deadlock.  Instead the driver leaks it
+# with a single "stuck online" warning. This leaves the memory online and the
+# device unbound until reboot, so it runs last - and only if we can run it,
+# leaving the restored state above untouched otherwise.  online_movable only:
+# this test never onlines a public node into a kernel zone.
+if [ -w "$DRV/unbind" ]; then
+	set_state unplugged; set_state online_movable
+fi
+if [ "$(get_state)" = online_movable ] && [ -w "$DRV/unbind" ]; then
+	mt_on=$(memtotal_kb)
+	dmesg -C 2>/dev/null
+	echo "$DAX" > "$DRV/unbind" 2>/dev/null
+	mt_after=$(memtotal_kb)
+	# The leaked "System RAM (kmem)" regions stay in the iomem tree; reading
+	# their names dereferences res_name, which a buggy unbind already freed.
+	# Walk /proc/iomem to provoke that use-after-free (caught by KASAN).
+	cat /proc/iomem > /dev/null 2>&1
+	splat=$(dmesg 2>/dev/null | grep -ciE "KASAN|BUG:|use-after-free|general protection|Oops|refcount_t")
+	if [ "$splat" = 0 ] && [ "$mt_after" -ge "$mt_on" ]; then
+		ktap_test_pass "unbind while online: memory left online, no UAF/oops (MemTotal $mt_on -> $mt_after kB)"
+	else
+		ktap_test_fail "unbind while online regressed: splat=$splat MemTotal $mt_on -> $mt_after kB"
+	fi
+else
+	ktap_test_skip "could not online device for unbind-while-online test"
+fi
+
+ktap_finished
diff --git a/tools/testing/selftests/dax/settings b/tools/testing/selftests/dax/settings
new file mode 100644
index 000000000000..ba4d85f74cd6
--- /dev/null
+++ b/tools/testing/selftests/dax/settings
@@ -0,0 +1 @@
+timeout=90
-- 
2.53.0-Meta


