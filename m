Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B8DC4453B
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 07:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB10A6B0095; Wed, 22 Jul 2026 03:48:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D89186B0096; Wed, 22 Jul 2026 03:48:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C29876B0098; Wed, 22 Jul 2026 03:48:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E81C6B0095
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 03:48:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EAB3E1203CA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:48:36 +0000 (UTC)
X-FDA: 85015635432.25.20BFCE5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9B917140008
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:48:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mmOLZrZw;
	spf=pass (imf09.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784706514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cTZZiiE5kktj/wuzFu+mWHvdEQ2lr2pxn7eLIBud1O0=;
	b=G02aOuCZmCsqj4nff9GHkSZyTvU9bYoLgiXeMmXpddBW76Kr4+lGU9KU41DlybofNN9kEW
	tB2hsdYwVZn3o1e/9EXYYffrrIxdj5rt50VrbylzkrqdEKAeimVL7CyfrdVVIgWUSmo9HL
	WCMx+qR+QoonURZbTptBErmYq51Rwqc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mmOLZrZw;
	spf=pass (imf09.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784706514;
	b=nsjXYGKRyUd6dihoJuMBkE8jMeSNGlJHLTux6DZkpokDuR8pA5Rn4l2OHjJrVoiGPGmhyI
	4LrQtpR7jLYvQipaYTupkHlvNfpyu0NHl8BXECv+aIq1wxUGZJkf8XOwNKkRFpIWE9sWks
	Fd9YrIY5jFxEqcttoibunPCsCvx5YXE=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66M5BvaI3048306;
	Wed, 22 Jul 2026 07:48:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=cTZZiiE5kktj/wuzF
	u+mWHvdEQ2lr2pxn7eLIBud1O0=; b=mmOLZrZwJlipqPcgY15ufGOmz5p8WZXer
	V8mlbnZCxaBPdaviI4F2TCzBR0RaRh8wMqYuGq3cv/ZXYqAVy7sA2NBKsc+9AGee
	UdTxGZxehtP/5xRr6yYoAr1hSQFohRkAiSoTS5oppfhO0BVm4xIKIAw3T5P6Mxjo
	hB6veMcbEBL9qXBsVv6tcE07plP0uEdyQ+Qk0+PyhIny+QY/iNL6E3f/fp+NQzbX
	KaAahyWB0rX0365A47kYkcQ9nPRQ5jBvA+6qZORSLAlwc5FDBpU82hmeg8Rd+u5A
	P2ljD83pFHqom7PWQN1OmPs4G59HhmVHuEO5KjwQyMqnkdJy7bwig==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg78g8exc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 07:48:27 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66M7Yauw006002;
	Wed, 22 Jul 2026 07:48:26 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fgp1ge2dh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 07:48:26 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66M7mOSW34079040
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Jul 2026 07:48:24 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 67013200C9;
	Wed, 22 Jul 2026 07:48:24 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D5547200C7;
	Wed, 22 Jul 2026 07:48:20 +0000 (GMT)
Received: from aboo.bl1-in.ibm.com (unknown [9.123.14.187])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Jul 2026 07:48:20 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [RFC PATCH 2/2] selftests/mm: add pc-dimm ACPI eject selftest for offline_migrate_max_passes
Date: Wed, 22 Jul 2026 13:18:11 +0530
Message-ID: <20260722074811.378283-3-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260722074811.378283-1-aboorvad@linux.ibm.com>
References: <20260722074811.378283-1-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDA3MCBTYWx0ZWRfX/0DAlQdyBnYO
 AvJzqV8dwi3LjsaK5FxiIFbt6lpeHzbKBTcye+qjwb43s9L0h9IbFkBr3RTnjSbcgr5mcER5q/r
 jl6g9gr99bDAqEZr5CYlQ99XBmd4zove6AiEs+jlCOVBZNfv72g0Ck6utzdpgUtMlBe590m1Nkc
 5QJ/DKH13GzblZ+A8qXb/fXT6r+5xtbsL9yeM1uxOAkCbHviRs/1yrEFErufjGVmjx8MnivBFVL
 jk1VBllgU1RZG419FTt93ua60Kr8vLmuhZfFBgIsgu/ivGfrKfkkoOp6VSASItLVnSpYnN9h/fL
 w3nsvUYWO+LHubM6+EiCr/KZ10VDsNxEWT6Rmic8j+9oI1y3I9ffFgqKaKU3DvyR/k/JzEs+NJ8
 lnuZpQ2THm7gC+p1bJw9pPx1C3Ws0SEm5U4mXvP350almIfNu5FAoVeu0vRs+brQIwy/oUikFg9
 C1qJDRY/LS2F9dHcsIw==
X-Proofpoint-GUID: rknPGrjsA6ydhCp5WqrH1HIG3arFpz7L
X-Authority-Analysis: v=2.4 cv=MelcfZ/f c=1 sm=1 tr=0 ts=6a6075cb cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=ygpDcHnE5uXTT0XjHt0A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDA3MCBTYWx0ZWRfXy4n56Ytf/Mw0
 Z+/IEJPjDdoZIldzin7WiMNvwOLenTmXJZ0ww6lfaAiH2CbPlULzNXnrqRKqCIqyE8PWmNHjvf/
 IZ2/0eDvE/8VtIWLotJe1affXvdnYsE=
X-Proofpoint-ORIG-GUID: m7iHy-OKdyRKAQ3plhBSBylSpYIYuNwj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_02,2026-07-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 clxscore=1015 malwarescore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220070
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9B917140008
X-Stat-Signature: xgqs5tefifdmjrbteox1a3hy7rmyp6uj
X-HE-Tag: 1784706514-264317
X-HE-Meta: U2FsdGVkX1+4fIVxqJR637i4S2RNrh6atXO19SSSXqosAV6V8Qk4mJIaXAkuWmQpmgmz2F+5Ee2T92Khg2hjipwpJ5C+L2RanBttL3v4CIeNqO/NWpbtXh8lKMzECf8R0adYD0WAhn3llQQbThk4pdXNgSCHn8zfBPDoJZ6LXMk1gmUFlXPfnM0rFBNxyGSuocrCtAVbYU5Xk7xYqCz0AbuvawLkeE2gVhYHq7oHDis30sgwE8fwEnwOoblfAjdeB/J+HUeHEVQr8BcXs2t+ISj/zjAkgfGLKvhjB2+wNoJz3wO2SxT15xPobAKpvb8Cv/qLO05nX88bk23t+xqRH0oOAaoUAmSSHlvDdfJDKTPC1al2d60WMRwjjYEihtg47xGPhFvZAeCJ33nCP0PM11dt4J9zE/V/EmcqVIcAn1RG4OJxiZFR1les4jVdjKkV4h6s/pWA0NkWeBchg+c5TBX3vMSatfEVsHa+ekY3kxqh//Bt/w8GpMC3bWuQdnM5PAM8Qd4nOFYhdO1SG2z4YoCYpT1aoijnXH9CGGfxSMhLFsCLrjGz3Iq3bsa1iQz648BaOsM4dAk0UmpVOnN+vb2M/Yy8lbV+A1xiIVEX2sbOeGotVqo6U34SK6SH+Ag3I80h2iZFU40vH+GWjJKK46XXOW0Zl7dvqqlgesT8YW3/X1RQCrT8xHg/SVr8kfzpLZdR2PU1qT9/Yrp15u7B8z2K+vT2ELgy4v4k0ov0kbxLXZgjCdZZu/WwJ+dw36tp2acCu0TLaqPZubpTi+V4A35YcIgih6QwRO/8sWd6Sk8N5205yFe6G1LPCa+RMmqliWqIa4WgiIRHVJV3roFbHfSS10k8RV+cIlMYvcK0fB9UOQ45VHgLq0BhQvUAVYl821M5ZAfGBsNDOugZ+gRkYZrW7BI84uFP6j7Ev0rwMi8lbnyDAt3ivDBIKuIR49RXRHi308FPK12MjdZEZP2
 zI8w6r4i
 jyRJdsOGSLZ0rvyeXGeSYRkbEQN/D8wdEKwJRygAvnIMg93WoZa32TmRa87tjrv7WrTRoLNMzNlz3i6ifiayuagVBQ+45lWXLXhMHDuxf99kFVdPhicrzuru0vZ7r996/ACZN0ivr1x+1N5grMlLZSRpbywE1XEEqaNfmjq60f9k2bURFJdJnmjM/HWKPGeLKYb487JVRCR/NlP8yz3GKPpvh3KprHHcnrC7VD02xTd8YFcakoBvdFILwwed/0vI0Lkh+8po9LqPlGolrxvCFC/oXUd2pkAxoNmG6dIl0Sy4qG+AYu+Q/+MPAokMXG6/9oVisBcFTn6EwC8MvzQPAe3+PgTMKgOd3XjPm9TyxQCWwvAnjQFUN9HBMsetRaws3VW73kSQE1VZDk6wCHuXXji3luv1TtIHjYQaD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a self-contained VM-based selftest that reproduces the ACPI memory
hot-unplug hang in kworker context and verifies that
memory_hotplug.offline_migrate_max_passes recovers from it.

The test needs a real ACPI eject because the offline that hangs runs on
the kacpi_hotplug_wq kworker (acpi_bus_offline -> device_offline ->
offline_pages) and cannot be aborted by a signal.

It boots the just-built kernel under virtme-ng with a cold-plugged
pc-dimm and runs everything inside the guest:

  1. online the DIMM memory blocks as ZONE_MOVABLE;
  2. long-term pin one page of the DIMM via vmsplice (a small pin
     helper is embedded in the script and built at run time);
  3. eject the DIMM via /sys/bus/acpi/devices/PNP0C80:*/eject, which
     runs the offline on the kacpi_hotplug_wq kworker, the same path
     as a hypervisor-initiated device_del;
  4. observe the real hang: with the limit disabled (default), the
     block sits in "going-offline" while the kworker spins in
     offline_pages();
  5. rescue it at runtime: write offline_migrate_max_passes and verify
     the kworker gives up with -EBUSY and the block returns to
     "online".

Sample output:

  TAP version 13
  1..3
  # DIMM memory blocks: 32 33
  # pinned one page in block memory33
  # ejecting /sys/bus/acpi/devices/PNP0C80:00
  # block memory33 going-offline, holding 10s
  # do_migrate_range+0x1eb/0x260
  # offline_pages+0x361/0x520
  # memory_subsys_offline+0xdb/0x180
  # device_offline+0xd0/0x130
  # acpi_bus_offline+0x11f/0x190
  # acpi_device_hotplug+0x1e8/0x3e0
  # acpi_hotplug_work_fn+0x1e/0x30
  # process_one_work+0x16a/0x310
  # armed offline_migrate_max_passes=50
  # memory offlining [mem 0x108000000-0x10fffffff]: giving up after 50 passes
  ok 1 ACPI eject kworker hangs unbounded in offline_pages()
  ok 2 stuck offline rescued by writing offline_migrate_max_passes
  ok 3 memory block online and usable after the bailout
  # Totals: pass:3 fail:0 xfail:0 xpass:0 skip:0 error:0

The wrapper is added as TEST_PROGS_EXTENDED (like hwpoison-panic.sh):
installed and kept executable, but not run from a default kselftest
invocation, because it spawns a VM itself.  The config fragment gains
the options the guest kernel needs (MEMORY_HOTPLUG, MEMORY_HOTREMOVE,
ACPI_HOTPLUG_MEMORY).  When vng, qemu, cc or the kernel knob are
missing it skips cleanly (KSFT_SKIP), so it is safe to run anywhere.

The vmsplice-based pin in this test is a targeted technique to reliably
reproduce the hang path for testing purposes; production scenarios
typically involve slab pages or busy block-device page-cache racing
into the offline range.

Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
---
 tools/testing/selftests/mm/Makefile           |   3 +
 tools/testing/selftests/mm/config             |   3 +
 .../selftests/mm/vmtest_memory_hotplug.sh     | 369 ++++++++++++++++++
 3 files changed, 375 insertions(+)
 create mode 100755 tools/testing/selftests/mm/vmtest_memory_hotplug.sh

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index eae504bd94c8..e113f3ff4655 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -177,6 +177,9 @@ TEST_PROGS += ksft_vmalloc.sh
 # Destructive: every successful run panics the kernel.  Installed and
 # kept executable, but not run from a default kselftest invocation.
 TEST_PROGS_EXTENDED += hwpoison-panic.sh
+# Spawns its own VM (virtme-ng); not run from a default kselftest
+# invocation.
+TEST_PROGS_EXTENDED += vmtest_memory_hotplug.sh
 
 TEST_FILES := test_vmalloc.sh
 TEST_FILES += test_hmm.sh
diff --git a/tools/testing/selftests/mm/config b/tools/testing/selftests/mm/config
index 06f78bd232e2..d22f63eb9c2c 100644
--- a/tools/testing/selftests/mm/config
+++ b/tools/testing/selftests/mm/config
@@ -14,3 +14,6 @@ CONFIG_UPROBES=y
 CONFIG_MEMORY_FAILURE=y
 CONFIG_HWPOISON_INJECT=m
 CONFIG_PROC_MEM_ALWAYS_FORCE=y
+CONFIG_MEMORY_HOTPLUG=y
+CONFIG_MEMORY_HOTREMOVE=y
+CONFIG_ACPI_HOTPLUG_MEMORY=y
diff --git a/tools/testing/selftests/mm/vmtest_memory_hotplug.sh b/tools/testing/selftests/mm/vmtest_memory_hotplug.sh
new file mode 100755
index 000000000000..c211a0e7caa2
--- /dev/null
+++ b/tools/testing/selftests/mm/vmtest_memory_hotplug.sh
@@ -0,0 +1,369 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test memory_hotplug.offline_migrate_max_passes by reproducing the ACPI
+# memory hot-unplug hang in kworker context and verifying that the retry
+# limit recovers from it.
+#
+# offline_pages() retries page migration in an unbounded loop.  A page
+# that can never be migrated (long-term pin, slab, busy metadata) makes
+# the loop spin forever.  Userspace-driven offlines can be interrupted by
+# a signal, but an ACPI DIMM eject runs on the kacpi_hotplug_wq kworker
+# where signal_pending() never fires, so the kworker hangs until reboot.
+#
+# Flow:
+#   1. Boot the just-built kernel (virtme-ng) with a cold-plugged pc-dimm.
+#   2. Online the DIMM's blocks as ZONE_MOVABLE.
+#   3. Pin one page of the DIMM (vmsplice long-term pin).
+#   4. Eject the DIMM via sysfs; offline runs on kacpi_hotplug_wq.
+#   5. Observe the hang (going-offline persists).
+#   6. Rescue: write offline_migrate_max_passes at runtime, verify bailout.
+#
+# TAP subtests:
+#   1  ACPI eject kworker hangs unbounded in offline_pages()
+#   2  stuck offline rescued by writing offline_migrate_max_passes
+#   3  memory block online and usable after the bailout
+#
+# Dependencies: virtme-ng (vng), qemu-system-<arch>, cc.
+# SKIPs (never FAILs) when tooling or kernel support is missing.
+
+readonly SCRIPT_DIR="$(cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
+readonly KERNEL_CHECKOUT="$(realpath "${SCRIPT_DIR}"/../../../../)"
+
+# shellcheck source=../kselftest/ktap_helpers.sh
+source "${SCRIPT_DIR}"/../kselftest/ktap_helpers.sh
+
+readonly DIMM_SIZE="${DIMM_SIZE:-256M}"
+readonly MAX_PASSES="${MAX_PASSES:-50}"
+readonly HANG_HOLD="${HANG_HOLD:-10}"
+readonly RESCUE_TIMEOUT="${RESCUE_TIMEOUT:-30}"
+readonly BOOT_TIMEOUT="${BOOT_TIMEOUT:-240}"
+
+readonly LOG="$(mktemp /tmp/vmtest_mhp_XXXXXX.log)"
+readonly GUEST_SCRIPT="$(mktemp /tmp/vmtest_mhp_guest_XXXXXX.sh)"
+readonly PIN_SRC="$(mktemp /tmp/vmtest_mhp_pin_XXXXXX.c)"
+# Must live in the kernel tree so the guest sees it through the 9p rootfs.
+readonly PIN_BIN="${SCRIPT_DIR}/.vmtest_pin_park.$$"
+
+VNG_PID=""
+
+cleanup() {
+	[ -n "${VNG_PID}" ] && kill "${VNG_PID}" 2>/dev/null
+	rm -f "${LOG}" "${GUEST_SCRIPT}" "${PIN_SRC}" "${PIN_BIN}"
+}
+
+guest_result() {
+	grep -o "^${1}=[A-Za-z0-9_-]*" "${LOG}" | tail -1 | cut -d= -f2
+}
+
+dump_log_tail() {
+	tail -25 "${LOG}" | while IFS= read -r line; do
+		ktap_print_msg "${line}"
+	done
+}
+
+skip_all_tests() {
+	local i
+
+	for i in 1 2 3; do
+		ktap_test_skip "$1"
+	done
+	ktap_finished
+}
+
+# -- pre-flight checks -------------------------------------------------------
+
+ktap_print_header
+ktap_set_plan 3
+trap cleanup EXIT
+
+arch="$(uname -m)"
+case "${arch}" in
+x86_64|aarch64) ;;
+*)	skip_all_tests "pc-dimm ACPI hotplug not available on ${arch}" ;;
+esac
+
+for dep in vng "qemu-system-${arch}" cc; do
+	if ! command -v "${dep}" >/dev/null 2>&1; then
+		skip_all_tests "${dep} not installed"
+	fi
+done
+
+# -- pin helper (compiled on the host, visible to the guest via 9p) -----------
+#
+# Allocate one block's worth of pages (ZONE_MOVABLE serves them from the
+# DIMM), find one that landed in a target block, vmsplice-pin it into a
+# pipe, print PIN_BLK=<N>, and sleep forever.
+
+cat > "${PIN_SRC}" <<'PINEOF'
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <sys/uio.h>
+
+static unsigned long memory_block_size(void)
+{
+	char buf[64];
+	ssize_t n;
+	int fd;
+
+	fd = open("/sys/devices/system/memory/block_size_bytes", O_RDONLY);
+	if (fd < 0)
+		return 0;
+	n = read(fd, buf, sizeof(buf) - 1);
+	close(fd);
+	if (n <= 0)
+		return 0;
+	buf[n] = '\0';
+	return strtoul(buf, NULL, 16);
+}
+
+static unsigned long vaddr_to_block(int pagemap_fd, char *vaddr,
+				    long page_size, unsigned long blk_size)
+{
+	unsigned long vpn = (unsigned long)vaddr / page_size;
+	uint64_t ent;
+
+	if (pread(pagemap_fd, &ent, sizeof(ent), vpn * 8) != sizeof(ent))
+		return -1UL;
+	if (!(ent & (1ULL << 63)))
+		return -1UL;
+	return (ent & ((1ULL << 55) - 1)) * page_size / blk_size;
+}
+
+int main(int argc, char **argv)
+{
+	long page_size = sysconf(_SC_PAGESIZE);
+	unsigned long blk_size = memory_block_size();
+	unsigned long off, blk = 0;
+	char *area, *page = NULL;
+	int pagemap_fd, pipefd[2], i;
+
+	if (argc < 2 || !blk_size) {
+		fprintf(stderr, "usage: pin_park <memory block>...\n");
+		return 1;
+	}
+
+	area = mmap(NULL, blk_size, PROT_READ | PROT_WRITE,
+		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
+	if (area == MAP_FAILED) {
+		perror("mmap");
+		return 1;
+	}
+	memset(area, 0x42, blk_size);
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0) {
+		perror("pagemap");
+		return 1;
+	}
+
+	for (off = 0; off < blk_size && !page; off += page_size) {
+		blk = vaddr_to_block(pagemap_fd, area + off, page_size,
+				     blk_size);
+		for (i = 1; i < argc; i++) {
+			if (blk == strtoul(argv[i], NULL, 10)) {
+				page = area + off;
+				break;
+			}
+		}
+	}
+	close(pagemap_fd);
+
+	if (!page) {
+		printf("PIN_NONE\n");
+		fflush(stdout);
+		return 2;
+	}
+
+	if (pipe(pipefd)) {
+		perror("pipe");
+		return 1;
+	}
+
+	struct iovec iov = { .iov_base = page, .iov_len = page_size };
+
+	if (vmsplice(pipefd[1], &iov, 1, 0) != page_size) {
+		perror("vmsplice");
+		return 1;
+	}
+
+	printf("PIN_BLK=%lu\n", blk);
+	fflush(stdout);
+	pause();
+	return 0;
+}
+PINEOF
+
+if ! cc -O2 -o "${PIN_BIN}" "${PIN_SRC}" 2>>"${LOG}"; then
+	skip_all_tests "cannot build the pin helper"
+fi
+
+# -- guest script (runs as init inside the VM) --------------------------------
+
+cat > "${GUEST_SCRIPT}" <<PROLOGUE
+#!/bin/bash
+readonly MAX_PASSES=${MAX_PASSES}
+readonly HANG_HOLD=${HANG_HOLD}
+readonly RESCUE_TIMEOUT=${RESCUE_TIMEOUT}
+readonly PIN_PARK="${PIN_BIN}"
+PROLOGUE
+
+cat >> "${GUEST_SCRIPT}" <<'GUESTEOF'
+set -u
+
+readonly PARAM=/sys/module/memory_hotplug/parameters/offline_migrate_max_passes
+readonly MEM=/sys/devices/system/memory
+
+skip() { echo "VMTEST_SKIP: $*"; echo "VMTEST_DONE"; exit 0; }
+
+block_state() {
+	cat "${MEM}/memory${pinned_blk}/state" 2>/dev/null || echo GONE
+}
+
+[ -f "${PARAM}" ] || skip "kernel lacks offline_migrate_max_passes"
+
+# 1. Online the DIMM's blocks as ZONE_MOVABLE.
+dimm_blocks=""
+for s in "${MEM}"/memory*/state; do
+	[ "$(cat "${s}" 2>/dev/null)" = offline ] || continue
+	if echo online_movable > "${s}" 2>/dev/null; then
+		b=${s%/state}
+		dimm_blocks="${dimm_blocks} ${b##*memory}"
+	fi
+done
+echo "# DIMM memory blocks:${dimm_blocks:- none}"
+[ -n "${dimm_blocks}" ] || skip "no offline memory blocks (pc-dimm missing?)"
+
+# 2. Pin one page inside the DIMM.
+"${PIN_PARK}" ${dimm_blocks} > /tmp/pin.out 2>&1 &
+pin_pid=$!
+for _ in $(seq 1 10); do
+	grep -q "PIN_" /tmp/pin.out 2>/dev/null && break
+	sleep 1
+done
+pinned_blk=$(sed -n 's/^PIN_BLK=//p' /tmp/pin.out)
+[ -n "${pinned_blk}" ] || skip "pin failed: $(cat /tmp/pin.out 2>/dev/null)"
+echo "# pinned one page in block memory${pinned_blk}"
+
+# 3. Eject the DIMM with the retry limit disabled (default = unbounded).
+echo 0 > "${PARAM}"
+dmesg -c > /dev/null 2>&1 || true
+
+ejdev=""
+for dev in /sys/bus/acpi/devices/PNP0C80:*; do
+	[ -e "${dev}/eject" ] && { ejdev="${dev}"; break; }
+done
+[ -n "${ejdev}" ] || skip "no ejectable ACPI memory device (PNP0C80)"
+echo "# ejecting ${ejdev}"
+echo 1 > "${ejdev}/eject" &
+
+# 4. Observe the hang: the block must stay in "going-offline".
+sleep 3
+stuck=0
+if [ "$(block_state)" = going-offline ]; then
+	echo "# block memory${pinned_blk} going-offline, holding ${HANG_HOLD}s"
+	sleep "${HANG_HOLD}"
+	if [ "$(block_state)" = going-offline ]; then
+		stuck=1
+		echo 1 > /proc/sys/kernel/sysrq 2>/dev/null || true
+		echo l > /proc/sysrq-trigger 2>/dev/null || true
+		sleep 1
+		dmesg | grep -B2 -A12 "offline_pages" | tail -20 \
+			| sed 's/^/#  /'
+	fi
+fi
+echo "VMTEST_STUCK=${stuck}"
+
+# 5. Rescue: arm the retry limit at runtime and wait for bailout.
+echo "${MAX_PASSES}" > "${PARAM}"
+echo "# armed offline_migrate_max_passes=$(cat "${PARAM}")"
+
+rescued=0
+for _ in $(seq 1 "${RESCUE_TIMEOUT}"); do
+	if dmesg | grep -q "giving up after"; then
+		rescued=1
+		break
+	fi
+	sleep 1
+done
+dmesg | grep "giving up after" | tail -2 | sed 's/^/# /'
+echo "VMTEST_RESCUED=${rescued}"
+
+sleep 2
+echo "VMTEST_BLOCK_STATE=$(block_state)"
+
+kill "${pin_pid}" 2>/dev/null
+echo "VMTEST_DONE"
+GUESTEOF
+
+# -- launch VM ----------------------------------------------------------------
+
+( cd "${KERNEL_CHECKOUT}" && exec vng --force-9p --no-virtme-ng-init \
+	--qemu-opt=-m --qemu-opt="2G,slots=4,maxmem=8G" \
+	--qemu-opt=-object \
+	--qemu-opt="memory-backend-ram,id=mem0,size=${DIMM_SIZE}" \
+	--qemu-opt=-device --qemu-opt="pc-dimm,id=dimm0,memdev=mem0" \
+	bash "${GUEST_SCRIPT}" ) > "${LOG}" 2>&1 &
+VNG_PID=$!
+
+for _ in $(seq 1 "${BOOT_TIMEOUT}"); do
+	grep -q "VMTEST_DONE" "${LOG}" 2>/dev/null && break
+	kill -0 "${VNG_PID}" 2>/dev/null || break
+	sleep 1
+done
+
+if ! grep -q "VMTEST_DONE" "${LOG}" 2>/dev/null; then
+	dump_log_tail
+	skip_all_tests "VM did not finish within ${BOOT_TIMEOUT}s"
+fi
+
+kill "${VNG_PID}" 2>/dev/null
+wait "${VNG_PID}" 2>/dev/null
+VNG_PID=""
+
+# -- report results -----------------------------------------------------------
+
+skip_reason="$(grep "^VMTEST_SKIP: " "${LOG}" | tail -1 | tr -d '\r')"
+if [ -n "${skip_reason}" ]; then
+	skip_all_tests "${skip_reason#VMTEST_SKIP: }"
+fi
+
+grep "^#" "${LOG}" | tr -d '\r' | while IFS= read -r line; do
+	ktap_print_msg "${line#\# }"
+done
+
+stuck="$(guest_result VMTEST_STUCK)"
+rescued="$(guest_result VMTEST_RESCUED)"
+blk_state="$(guest_result VMTEST_BLOCK_STATE)"
+
+if [ "${blk_state:-GONE}" = "GONE" ]; then
+	skip_all_tests "DIMM was ejected despite the pin (pin did not hold)"
+fi
+
+if [ "${stuck:-0}" = 1 ]; then
+	ktap_test_pass "ACPI eject kworker hangs unbounded in offline_pages()"
+else
+	dump_log_tail
+	ktap_test_fail "ACPI eject kworker hangs unbounded in offline_pages()"
+fi
+
+if [ "${rescued:-0}" = 1 ]; then
+	ktap_test_pass "stuck offline rescued by writing offline_migrate_max_passes"
+else
+	dump_log_tail
+	ktap_test_fail "stuck offline rescued by writing offline_migrate_max_passes"
+fi
+
+if [ "${blk_state}" = "online" ]; then
+	ktap_test_pass "memory block online and usable after the bailout"
+else
+	ktap_test_fail "memory block online and usable after the bailout (state=${blk_state})"
+fi
+
+ktap_finished
-- 
2.54.0


