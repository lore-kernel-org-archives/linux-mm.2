Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14F00CD6E7E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 21:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 881C36B00A1; Fri,  5 Jun 2026 17:19:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80DD16B00A2; Fri,  5 Jun 2026 17:19:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 687AA6B00A3; Fri,  5 Jun 2026 17:19:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 554236B00A1
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:19:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 12B431637CA
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:36 +0000 (UTC)
X-FDA: 84847125552.18.4A5FBB8
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 488CE1A0009
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tsDuhQAK;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780694374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l77sljwLY2ZMyEKXbyo6m0iIvdzx8NQv05f4wwNhT4k=;
	b=KZI1H7pcm5Goa0CQ7M2FNum0gQUgaIjaiq9C58Tr1CVMEvWO9eXn3Ei77ktfZGfiefBf+z
	Y8R+RyL+RBXhX4xQYgpWbzxXZ6xTnUbPAzPb3rbR9mR8fijy/E03Z3sSpBoqB/AAkOzJhU
	TwIZArRgOUcUyJ231gNaPlFDJkj4AF8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tsDuhQAK;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780694374;
	b=oVkbXmJ1oUIdizAa0oI0eWaFvjR+d5hMhqJ6HMlegOby2jlBjNVZV1+l1uK3R9YzKm/QAX
	WSNsyseI7JcvB0M7Z3zT9If61P3dZu+O+d/B1EQfX3zK3TZUD2kR+GIuiZ9D2HwHxiA6uh
	AJZGGq0sBBflU7TO1QNAkFr0l8QKwOs=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8ce9d444173so28830876d6.2
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 14:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780694373; x=1781299173; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l77sljwLY2ZMyEKXbyo6m0iIvdzx8NQv05f4wwNhT4k=;
        b=tsDuhQAKIvySZ+gYeTbGKTv70oAlu0eb++cBHK0hHxbqnlHg6KnQkRvIL0sDc1kwHY
         XJ9iN6/F/C204bXnHLlk96TYAGMRyYblWhJRfdi73fq6m6otQOU62Y4BG29wOWPffUl5
         feMj6KBRQxLR5Ad1NdLAXH4jyQI/8Rx/5AXxiUIQ7eX1R/QVV6e43fw+hlUFaGEw5xP1
         lETnA+BPVI1DQ4XFpov1N3SmXxYVcmgRWe11cjzov34BF0ihHo+XuxWFO+Cf6NK65O7J
         Vxqp+I6kyV/sXVRtbbb0MJdtTjXjYQBtw5V3PkDx11cVTjTlmMZkyX4mhck3cf1O78jz
         0MnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780694373; x=1781299173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l77sljwLY2ZMyEKXbyo6m0iIvdzx8NQv05f4wwNhT4k=;
        b=haquDrx/JC+YHqLXT+1y3l6r0uQivE0Ahp8z5fIVI8uOyS8O23L81tHUchdu9fIpPv
         /7Amb5GKp/Ax/wHlQrlxUIpBSoPHCTMQ/3iqVnwVNqBOavZFIbjMoGKrfp/3JpsY6Lq9
         YtqsUKIjRPFRP4XNL7mjpeCljFqtA68NBrm304Qi2bPCw3JZTM4pSXby4gc5vF5FUrCO
         Bp40bkHd+TgLEqaT8oCcvJd9nvKM/6ub73QpqK8zoNfxXmwiX1OY2bIfN3Clf/7KeXfJ
         W44rupAeETTouzUqMNT1Ss3qr0Bl2lSXZptowqyRmxlqphGmDBTeQNsxh2hx3+3Cwn8M
         2yUQ==
X-Gm-Message-State: AOJu0YxSMIkR4ISLtYwK9f8VKSLseGH8e/w3oXzi0M6h0qdUv0o3Jip1
	w0xb6jhQIHh13394DmsCKAAkKNbPTPY3sXXNI9+bwo2iWX9937xpfsRxfZt0X12AF1G5bEaRmm8
	ZC2cFStwWQw==
X-Gm-Gg: Acq92OGUKRWqpjpFDaUv9Ijjg73PTriI6pZVczOXPGju+Lc1FQ1J+8X/MddORxLdILH
	odLtdSy3ZfAKI2wmDhc8Cy6aFZ5QiEmj22vghxGnpCe8qH5bC0zqcG2yP7+Zwz91dXfQ7yHDAQe
	0mWK32OfPhhXadXs6SCfdYvtjihf/FtebPAnzcn57JK23cJPnlVMQbzIXklG6M1wdXMc2qqzI6O
	9RpPqcuV3BSZ/y93bJWnAlk7Zhckvecorx969cMReRb+R8Qxm7tFWXkg2WJEp/B7YNI5cVgx5ro
	vgDN8ONrMORiwCc+8SStVifJuKucC2V0pLgJI9c9wCQs0OBfnqPJCSh4HUStlCRZBeveYeGelH3
	LZVJXMZehaBaLYBwJrOhpHyTKtN4Ua0HR+uUXYe4A33RMnNziS5JiduDccB+1HYPnmoDAJ5ozDU
	VRpVX3kPOXby0vdT4JJQR+oA5lpzkzpskDOzE+9cTo0gJPPweF83vnDnSoKK3GVhGaGI8bcUWc7
	RNTx0yhGPrlISBmCBpDucv3T04tbcED5w==
X-Received: by 2002:a05:6214:2aad:b0:8ca:2559:8886 with SMTP id 6a1803df08f44-8cee5fbda5cmr92189846d6.13.1780694373324;
        Fri, 05 Jun 2026 14:19:33 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd277bbcsm90518196d6.49.2026.06.05.14.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 14:19:32 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v4 9/9] selftests/dax: add dax/kmem hotplug sysfs regression test
Date: Fri,  5 Jun 2026 22:19:11 +0100
Message-ID: <20260605211911.2160954-10-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605211911.2160954-1-gourry@gourry.net>
References: <20260605211911.2160954-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: xb6f1zcfisfhhyjwxgdod3yh3ntc98mm
X-Rspamd-Queue-Id: 488CE1A0009
X-HE-Tag: 1780694374-774106
X-HE-Meta: U2FsdGVkX19TZwhNB91K9IRcUMuSsogrXu1nUrOCvZzsvvPMiqvXW3Gs37bPqSXzpa2kKE/g4t8Pt1JJ6HEOx8yRjHfZVRiv616cHlPn2pfwUPeuDfyYbgVEtfqQazoFJ0HmzHsnNB2vmal4P5a65CzzdXX2oy4I01RUoHE8hAo7aglFWGDm2N4GugwKDir20Xew8z9G/GtdmQ+au311LJdQiFWuTU0C2DZwElA2so2mHMkxsXpoqVbBwjRBI8IN4TMvi9kXJTrx5LgKg4OadY+PUpr/L6jBfiQg2SXbVjO7va9zIn6QExaCPxwkZrUdtJgmIaeuuXMbsi/OOdBzh8Lo5w/axDvjcqtEH4SjmSccS6CIMakaj6d9e/k4zkerIHJhqUc1hpi+rb5b0dLN6vgUDcd28W7sc4+5vDrmWNKkeTonS+X1kPbT0o/ZDy1/eKpLkxZSnM6pYBV+EZ4B/Lyre+GfUpOU37C4nYCv6LW5P+b1Y1977u4takKZubxHEsqujOGpVroLmS0hOujX/nMUP1+Ctk/49QoAvPIuOPz92en0CtsbeIdpLFwdYjMZPrY66Y6Jk2bhywbLWf5ydPT6gP7Oa5PR4Z0Ps/eHiSpnGX8c5EtXUZdq36URxSKmY9SXzAC9f74wVuLdWpOx+hvqC3X6r5tCruhpZeVnepWGIq2ubpMuor9kJl0gkwqqZLUFwyg4uKmpoE0py9BoskUoOHS9o1ALP+4hd+4zFhwbiEISwW/nFkp1WsstyP8PxQgecvvqJ0057ZeKOeuD0dTI5wervPZ17Upm8ajyQ8wP3P0OG3HKDBk/DdxluF+IUZOgDmblOTstaoMSvXfDWX+aUKtB23HufGTchEdRCHnXpocgmfJGntQRTTlbeWcUingz60W2n88JQH4fZY9wHGqTjNTqATh0fRB04XJR35UvReNdiE9ic5kBstNgFX+RsjA3kQ/7Dp/Gkcz21xE
 iAAMPH/m
 fL8qbdAP0VN0wLpQz13NqfcCQPUaUv9VPSsILvk+ziSSowKnW+93E5ryeAFuaSFcuhsLCG1uAF9owZQQiZ15H5Md1I6lrPG9IJoCAbT66POjsgsm4BdJ32zZCJLiu2zsVjA+K8cokBxavAtBNOq9mIr32WsJvj7EBp51w2rw/5L4ezmEHItmXd+LAg/kc4RN+aV2+g4J7l9RoYHW99XR4wlN4DLzM2WPluIhwL1faEYBzT498ZI9BlBcrzJsUyz5anBIy8YWgQlLl5bCcVS7HTkD/CnsFoOanWFbXjl8KTpuJYeFrwESuEhtd9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a kselftest for the dax/kmem whole-device "hotplug" sysfs attribute
(/sys/bus/dax/devices/daxX.Y/hotplug), which transitions a kmem-backed
dax device between "unplugged", "online" and "online_movable".

Provisioning a devdax device and binding it to kmem needs daxctl/ndctl
(or the tools/testing/nvdimm emulation) and is out of scope for an
in-tree selftest, so the test discovers an already kmem-bound dax device
and SKIPs (KSFT_SKIP) when none is present or when the memory cannot be
freed to reach a known baseline.

When a device is available it validates the interface contract:
  - online / online_movable actually add memory (MemTotal grows),
  - online is idempotent,
  - switching between online types without an intervening unplug is
    rejected,
  - unplug removes the memory and the reported state matches reality,
  - invalid input is rejected.

In particular it covers the online -> unplug -> online_movable -> unplug
cycle: a re-online must re-reserve the per-range resources so that a
subsequent unplug actually offlines and removes the memory instead of
silently reporting success while the memory stays online.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/dax/Makefile          |   6 +
 tools/testing/selftests/dax/config            |   4 +
 .../testing/selftests/dax/dax-kmem-hotplug.sh | 145 ++++++++++++++++++
 tools/testing/selftests/dax/settings          |   1 +
 5 files changed, 157 insertions(+)
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
index 000000000000..705a34cc3c6d
--- /dev/null
+++ b/tools/testing/selftests/dax/dax-kmem-hotplug.sh
@@ -0,0 +1,145 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Exercise the dax/kmem whole-device "hotplug" sysfs attribute:
+#   /sys/bus/dax/devices/daxX.Y/hotplug  ->  unplugged | online | online_movable
+#
+# The test needs a dax device already bound to the kmem driver (so the
+# 'hotplug' attribute exists).  Provisioning a devdax device and binding it to
+# kmem requires daxctl/ndctl (or the tools/testing/nvdimm emulation) and is out
+# of scope here; if no suitable device is found the test SKIPs.
+#
+# To actually run it, provision a kmem-backed dax device first.  For example,
+# carve a chunk of RAM into an emulated pmem region via the kernel command line
+# (the region must be at least one memory block, e.g. 128MiB on x86):
+#
+#   memmap=2G!4G
+#
+# then, in the booted system:
+#
+#   ndctl create-namespace -m devdax -e namespace0.0 -f
+#   daxctl reconfigure-device -N -m system-ram dax0.0   # binds the kmem driver
+#   ./dax-kmem-hotplug.sh
+
+DIR="$(dirname "$(readlink -f "$0")")"
+. "$DIR"/../kselftest/ktap_helpers.sh
+
+DAX_BASE=/sys/bus/dax/devices
+
+memtotal_kb() { awk '/^MemTotal:/ {print $2}' /proc/meminfo; }
+get_state() { cat "$HP" 2>/dev/null; }
+# set_state STATE -- write a state to the hotplug attribute; returns the
+# write's exit status (0 = accepted by the kernel)
+set_state() { echo "$1" > "$HP" 2>/dev/null; }
+
+find_kmem_dax() {
+	local d drv
+	for d in "$DAX_BASE"/dax*; do
+		[ -e "$d/hotplug" ] || continue
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
+	ktap_skip_all "no kmem-bound dax device with a hotplug attribute"
+	exit "$KSFT_SKIP"
+fi
+HP=$DAX_BASE/$DAX/hotplug
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
+ktap_print_msg "using $DAX (initial state was: $ORIG)"
+ktap_set_plan 8
+
+set_state online; rc=$?
+mt_online=$(memtotal_kb)
+if [ "$rc" = 0 ] && [ "$(get_state)" = online ] && [ "$mt_online" -gt "$mt_unplugged" ]; then
+	ktap_test_pass "online: state=online, MemTotal $mt_unplugged -> $mt_online kB"
+else
+	ktap_test_fail "online: rc=$rc state=$(get_state) MemTotal $mt_unplugged -> $mt_online"
+fi
+
+set_state online; rc=$?
+if [ "$rc" = 0 ] && [ "$(get_state)" = online ]; then
+	ktap_test_pass "online idempotent"
+else
+	ktap_test_fail "online idempotent: rc=$rc state=$(get_state)"
+fi
+
+set_state online_movable; rc=$?
+if [ "$rc" != 0 ] && [ "$(get_state)" = online ]; then
+	ktap_test_pass "reject online_movable without intervening unplug"
+else
+	ktap_test_fail "online->online_movable not rejected: rc=$rc state=$(get_state)"
+fi
+
+set_state unplugged; rc=$?
+mt=$(memtotal_kb)
+if [ "$rc" = 0 ] && [ "$(get_state)" = unplugged ] && [ "$mt" -lt "$mt_online" ]; then
+	ktap_test_pass "unplug from online: MemTotal $mt_online -> $mt kB"
+else
+	ktap_test_fail "unplug from online: rc=$rc state=$(get_state) MemTotal $mt_online -> $mt"
+fi
+
+set_state online_movable; rc=$?
+mt_mov=$(memtotal_kb)
+if [ "$rc" = 0 ] && [ "$(get_state)" = online_movable ] && [ "$mt_mov" -gt "$mt_unplugged" ]; then
+	ktap_test_pass "online_movable after unplug: MemTotal $mt_unplugged -> $mt_mov kB"
+else
+	ktap_test_fail "online_movable after unplug: rc=$rc state=$(get_state) MemTotal=$mt_mov"
+fi
+
+# The online -> unplug -> online_movable -> unplug cycle once regressed: a
+# re-online failed to re-reserve the per-range resources, so this final unplug
+# reported success while leaving the memory online.  Assert it is really freed.
+set_state unplugged; rc=$?
+mt=$(memtotal_kb)
+if [ "$rc" != 0 ]; then
+	ktap_test_skip "unplug from movable not accepted (memory in use?) rc=$rc"
+elif [ "$(get_state)" = unplugged ] && [ "$mt" -lt "$mt_mov" ]; then
+	ktap_test_pass "unplug from online_movable removed memory: $mt_mov -> $mt kB"
+else
+	ktap_test_fail "unplug success but memory remained: $(get_state) $mt_mov -> $mt kB"
+fi
+
+set_state online_kernel; rc=$?
+mt=$(memtotal_kb)
+if [ "$rc" = 0 ] && [ "$(get_state)" = online_kernel ] && [ "$mt" -gt "$mt_unplugged" ]; then
+	ktap_test_pass "online_kernel: MemTotal $mt_unplugged -> $mt kB"
+else
+	ktap_test_fail "online_kernel: rc=$rc state=$(get_state) MemTotal=$mt"
+fi
+set_state unplugged
+
+before=$(get_state)
+set_state bogus_state; rc=$?
+if [ "$rc" != 0 ] && [ "$(get_state)" = "$before" ]; then
+	ktap_test_pass "reject invalid state string"
+else
+	ktap_test_fail "invalid state not rejected: rc=$rc state=$(get_state)"
+fi
+
+[ -n "$ORIG" ] && set_state "$ORIG"
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
2.54.0


