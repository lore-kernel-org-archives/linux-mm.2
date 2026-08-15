Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF3A1C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 02:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8132B6B0765; Fri, 14 Aug 2026 21:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA086B0767; Fri, 14 Aug 2026 21:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1D06B0768; Fri, 14 Aug 2026 21:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31FFA6B0765
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E4A0402BC
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:38 +0000 (UTC)
X-FDA: 85101847236.23.A84A4B9
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf01.hostedemail.com (Postfix) with ESMTP id ADCE140003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="B JysKvR";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=D+SXhRAt;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AO/oUzqhOXSGRBCY8YhrbuAzNWboTvwfnRq6ibT3Z0I=;
	b=zFE3OR1JwYAm29LBtFrkwy7Q0lIM2vo+lxDOeVwyp+a5u3DnUDLPVoxz+sM8h2libGk1LM
	Beg8Pqz3DM158FMtmTGwyaPIC/gvRJ7I8TSvYCSO2b8iKbQnotT5K0fikFwVLrpBCcZ7ax
	4W+3MvTIv/k05wBaz6MR/jLDQXdxlp4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="B JysKvR";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=D+SXhRAt;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759176;
	b=3rY3dz+XNdWBfWy7sXpDpAQA45pZS0MS9yz84ScvufDdiVTZY7O0HQT27asyhEcVoziCel
	b85ubEmCVAUVuO2v0VfP4uuZmNScLEVJz1hkb+6jw2fdMrIWGMSMavIM6P35UrJxtvWfNQ
	6OkMHNDOzEIyu8JfnuNgqtTmNROjBRY=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 4004CEC0222;
	Fri, 14 Aug 2026 21:59:36 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Fri, 14 Aug 2026 21:59:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759176; x=
	1786845576; bh=AO/oUzqhOXSGRBCY8YhrbuAzNWboTvwfnRq6ibT3Z0I=; b=B
	JysKvRs0w0dgewcptHTLipsM9Igk808LxEzX3Mw+bdC4IaRgdUCKqn4jxy3LehOS
	jQgwh/N3prJRrIi3DnddulryRX6pwlFMK055muuDUkHZa6yTRVeClP31cqb0cQO6
	BvvkaS2JveX/sVlkFswC+TpglmiAdLrmtc6wE1CDtk2xdCOkbc2xSlzDEuweHPek
	miTAO+ESM98O2e2bcWPxUvXaiXmzvilm9QdAhI++CHbeSY3LSo4lhwCCPBxJhumn
	hg8Fwxv2JQD77j/n+f1IUtO1s1lDPAoGcNQwqhHCHtJ794bPv1tbBe78oWmUdcHD
	FDYKG59fQ9yCmxYM6EZdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759176; x=1786845576; bh=A
	O/oUzqhOXSGRBCY8YhrbuAzNWboTvwfnRq6ibT3Z0I=; b=D+SXhRAto+UkByM6P
	JkXZgS2uLdbYaQysPTEeGB8CfgKUiAVzol0jcI6Xffwd8l2LMXK3n5DvbhKvVype
	VQlr9lgbhAxknZJMpJwJhuz3Dv32kpGEJOkF9FSRx4M+abcpDvqW79t4uz0RyyaM
	O/NhExdboVOmRZNS/ZoModXqwrFfpdUGwezS1EUbld3/39otTfvqm9Y1fUdbNm3/
	VZg+ZoN49Nz0krxkc2juYW02gj9PBV0RTEdxx5Dy/Mbn4pFxlZg7fkDWNUqXPo6h
	XDpJ1AxyuS7pCCFDoL25RILDfm5xpVuOD3AXjMC1EB0iprbpZ4mVH00JkUMeJ437
	6Eh1g==
X-ME-Sender: <xms:CMh_anv4nHJDLOlppzuZ_KIO4Q_STlrHk-j9DTIon67_xTcfeF2Buw>
    <xme:CMh_asaVol16zcLzAYv8phsxzg2u1T9eTW8lkNYPTyJjaLVxOBS6t0oJmQ1ay0KEi
    AuEVtxl88c9mIxdTlsDr7pZT4oB9KwlJIbjg__1ws81Gh9eQS5aew>
X-ME-Received: <xmr:CMh_ajTpDgCDQvr7FWYG7sh7p28gVoelUs1CyxJk87pYRf-VvKnKxMsk294>
X-ME-Proxy-Cause: dmFkZTEHOB8klcfpaewZ3k5dhFGq+0NT52m0JgfrBhlsrZZ6/wIFkiWFy9BKVmBRzT/M60
    afg3IBZlSt5ygR3bwXNIcW5ZM0yyzN/pf9UTr2aIVxu9PRgCvu2oUUNVujSBw7FeHwFBsc
    cXVjrQP9UQmJU5OZxw2U7sN+BvQMOJwzXPSq8ovjEuIpT5m3q0hBt7II5b5sCGi7gkG3/G
    fAkJjKG33ZxocRSbFLEDKzhP8eL3QUGAVXaSl2VxURMVZW4QVvv1Ki5M31XaRzn4+ok0bg
    hGdz4SdlVbJh+GxMS7w8oKVQIiajy/o8Z9eSxaHEz+PVJrdtO9FMEbFO2si+6c9liGB/kA
    mdDnw2Qcq4Dz9ph/PSDADa+0M0gnI/qIYttfy8mfVpS7Bx3F6HWYF1THwbGAI8uraMQmXt
    lznRPNv+kN2bXaiuCMZFG9ezL4A9dHjVOOnrV36kp2B5apv2ECy2pHuk2iOUz8wofrKSVk
    cUW4VPaOcgzg7yWwV1Evn72D0dr1cklBFc29DIDa3N4SVHaqCy9a3MkPgotfWam/WmT7Vc
    SgnpF5IsNI+007S29LNfYEToPBZBYAeAcJPGQmQyEmXSn16ENIDsrTM97ivmRGY9q3omLM
    Gr/T6NjAIA7QGNsgeAuJVh22TzxTOiRHSUh4hY1w9gyJ7ZYfrmhmKzbcPvbQ
X-ME-Proxy: <xmx:CMh_avwTqvHmHT__Pdu5z3ZckIWir5vMk72Nxh2WyfMW7AuVvci1Zw>
    <xmx:CMh_avc8d3bHHPK9waCOpkWX4C-XjaK5V6kw7TCmoGnv9Oh_Q8lL4w>
    <xmx:CMh_agrxh_assq0UHpndm0Pcl6rBsxgcGNfUyFtDKeCX4NCpjOCFZA>
    <xmx:CMh_anPDmUuUpXkzDkbCygsvExwkuMRu5bNQVHVjsSBgao8AV8-wpg>
    <xmx:CMh_ami_fAbCMrVpLeW76zDZ6nRHA-EV9oHdaDEmL6tTs-F6lBP3GCxI>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:35 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org
Subject: [PATCH v4 16/19] selftests/mm: add khugepaged race harness
Date: Sat, 15 Aug 2026 02:58:58 +0100
Message-ID: <20260815015901.1236937-17-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ADCE140003
X-Stat-Signature: c4yqo9os6ibnfacpox768ymz5z8z3fcz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786759176-484024
X-HE-Meta: U2FsdGVkX19tV7T9pRs+dgiv1HQ4pfL9VKEIYexkTkUP0gHYGMUNl7QSGMqmNHxo9CrRcMIOBPAfo1h2swoOpHS3ekxe+Jqryi5XTN8XwUMuTaOaIbne4lFD1uxR8ydqakosKHxJiGJI5/sWf+4c116r6caUQ9lvzGutGScGrZ/0V9lvTeTfUOHgg4iNLhAqZJWWakaU708B0VsXYz4zyl7POjLlGocxltYwYBW9LATNmvSFnSJfHT/w3kjwnPr09J2hWMokSrCcEHfVZ19pk5pg2N9NmGpF02DeGoLI/p+O3ztsojYHwjSQsvsTIIrPFnSHk6pLwNaJmuiQyIrM0Aw+O2JeJjBfRMOGekUQoQhGSjWPa6mZcPflLMVbAPxAlUn/zkyer8z2lqzbYdo9lGIPa4gqMtHf1NEUBOLrkCTf+9U3jTOeXUIgu8AoPBwK24J77ybRE1Rbaa6RZysEMEZFIxGDS0pXKm09RQw/2dBghCtSbhvp/f2e6UvvR1h1W27ZbyVJIjZguhAPpG7XQQEjvZvbOCH6wq++2mOpKXMqRTef023Mni8LB797p0XdgT89eaj+PQKgRFMVxqUiIiDxa2ZxXDvwoO+22HwZtCZ7RRTQ2xpYEAd3reJMwf35eY/lbDF1eljoep2851xrYTaEase73Hr++H+v1jIKIlS/u2htN+peWnpbcsXZxu+rdMx0nsvbYgT4DSNamDXIo2NgaO/VyVPHGZfpJBpvq40IxFPEpuv7BFXg+zkjDNoWjYJkdEgzyhZmklWIQbRuhDtjixxCvoMWrzg8X8Tr9XFq/N6YlWMi2D+ysjzNPyT1ev+PRYEEZayy1gsjAy8EWYACUUl1zTm8B8nLFUyWCWp/mEneVWdoOKtXXnTrL4Zt8EeYu6UlWh3xztV/mtBOjpmzDJNqmqY0CjFv+BEEE9VSmsIG/rY99VRQmg1WcXza58G8AGA6RbcJRRRCabE
 uLcIKyV9
 agRElehWpJIkk4car9it3jidCytc6aqaNQjURRynP+SZd02CuUEPtnMb+IWGqJ2DHCbCg6BBO19/atexY2SL3nER1WCtF6IkFEbg7Ks2SRlExomVhIyFc79vrR8ip24dFsBjlkC/k+peGrPSV4wxEuQwfM9DPVEVCa5haqAeWhNceoZ7YK0ETimt1guFO0/heEd72QIcOKRX2V7uFD80WLnZ4e3QXPWbYrdEnSf2cyN6VqhUH+Aoekjjdyg0ptqGLaT54DkmrfXIfka5d6bu9IZCeDTJM6TNG2fPSIlgdcCpBeUSe3wfOPisdGAO3NoWWoInu+LWtLQVzfuFEB0z6J7B0f15nyVzA9kWYUAfDxJyuNPceqvA1YezEs3IjMGpguw10SnmprvziY/ahZMO/0F3Xv6sy7lenkaEIL2sPqxjV4/owczOS8bpm9ztrIUbBV8afce86gmP3lzQM0eksx+/mLyw+NS5gcOFoYR9U8P8bXT/qVqAOxRLP7+Ij9gXhr4gV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Collapse serialises against faults, GUP, fork, mremap and zapping through
a protocol of locks, TLB flushes and refcount checks.  No khugepaged
selftest exercises any of it under contention.

Add khugepaged_race.  Six racing threads work the same address space:

  - two faulters
  - an MADV_DONTNEED thread
  - a transient FOLL_PIN thread (gup_test)
  - a forker
  - an mremap thread

One of three drivers collapses under them:

  stepped   khugepaged, one full pass at a time via
            khugepaged_full_pass(), so each step covers a known extent;
  free      khugepaged left to run (scan_sleep_millisecs=0), for soak;
  madvise   an MADV_COLLAPSE and MADV_DONTNEED loop.

Every mode runs in turn unless -m names one, five seconds each.  Every
supported anon THP order is set to inherit and max_ptes_none is 0, so a
window collapses only once fully populated and the racing MADV_DONTNEED
steers selection across orders.

The rule is that a racing page reads as its pattern or as zero, never
anything else.  The faulters and fork children check it throughout, and a
final sweep checks it again.  The other half of the check is the kernel's
own assertions -- DEBUG_VM, page_table_check, KASAN, lockdep -- so read
dmesg too.

The pin thread goes through gup_test, so the harness skips without
CONFIG_GUP_TEST or root.  The threads share three PMD-sized areas plus
one for the mremap thread; -a sets the count, since at a 512M PMD that is
over two gigabytes.  -d sets how long each mode runs.

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/Makefile          |   1 +
 tools/testing/selftests/mm/khugepaged_race.c | 442 +++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh    |   2 +
 3 files changed, 445 insertions(+)
 create mode 100644 tools/testing/selftests/mm/khugepaged_race.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index b2d6e5c12934..308bbad73c11 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -106,6 +106,7 @@ TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
 TEST_GEN_FILES += folio_order_check
 TEST_GEN_FILES += khugepaged_sync_check
+TEST_GEN_FILES += khugepaged_race
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
new file mode 100644
index 000000000000..3128031e28bc
--- /dev/null
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -0,0 +1,442 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * khugepaged race harness.
+ *
+ * Runs collapse against concurrent faults, transient GUP pins
+ * (gup_test), fork, mremap and MADV_DONTNEED over the same ranges, in
+ * one of three driver modes:
+ *
+ *   stepped	khugepaged, one full pass at a time through
+ *		khugepaged_full_pass(), so a step covers a known extent;
+ *   free	khugepaged left to run (scan_sleep_millisecs=0), for soak;
+ *   madvise	MADV_COLLAPSE and MADV_DONTNEED in a loop.
+ *
+ * All anon THP orders are enabled (inherit) and max_ptes_none is 0, so a
+ * window has to be fully populated before khugepaged will collapse it, and
+ * the racing MADV_DONTNEED decides which orders it can still use.
+ *
+ * Correctness signals: every racing page must read as its pattern or
+ * zero (MADV_DONTNEED), never anything else.  The faulters and the fork
+ * children check that continuously, a final sweep checks it once more, plus
+ * whatever DEBUG_VM / page_table_check / KASAN / lockdep report in
+ * dmesg, which the caller is expected to inspect.
+ */
+#define _GNU_SOURCE
+#include <errno.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/time.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "kselftest.h"
+#include "vm_util.h"
+#include "hugepage_settings.h"
+#include "../../../../mm/gup_test.h"
+
+#define BASE_ADDR	((void *)(1UL << 30))
+
+/*
+ * Shared playground for faults/pins/fork/dontneed: several PMD-sized
+ * areas the racing threads spread across, plus one area owned by the
+ * mremap thread. More areas means more independent regions collapsing
+ * at once; the default suits a normal machine. On a memory-constrained
+ * host -- or under emulation, where a 512M PMD (arm64/64K) makes the
+ * default playground multi-gigabyte -- pass -a to shrink it.
+ */
+#define DEFAULT_SHARED_AREAS	3
+static int nr_shared_areas;
+static int nr_areas;
+
+static unsigned long hpage_pmd_size;
+static unsigned long page_size;
+static char *region;		/* NR_AREAS * hpage_pmd_size */
+static char *mremap_area;	/* region + NR_SHARED_AREAS areas */
+static char *mremap_scratch;	/* well above the region */
+static int gup_fd = -1;
+static volatile int stop;
+static volatile int corrupted;
+
+static unsigned int pattern(unsigned long page_idx)
+{
+	unsigned int val = (unsigned int)page_idx * 2654435761U;
+
+	return val ? val : 1;	/* never collides with the zero-fill */
+}
+
+/* Zero means never written; anything else must be this page's pattern */
+static bool page_is_corrupt(unsigned long page_idx, unsigned int *val)
+{
+	*val = *(unsigned int *)(region + page_idx * page_size);
+
+	return *val && *val != pattern(page_idx);
+}
+
+static void check_page(unsigned long page_idx)
+{
+	unsigned int val;
+
+	if (page_is_corrupt(page_idx, &val)) {
+		corrupted = 1;
+		ksft_print_msg("Corruption at page %lu: %#x != %#x\n",
+			       page_idx, val, pattern(page_idx));
+	}
+}
+
+static unsigned long shared_pages(void)
+{
+	return nr_shared_areas * hpage_pmd_size / page_size;
+}
+
+static unsigned long rand_page(unsigned int *seed)
+{
+	return (unsigned long)rand_r(seed) % shared_pages();
+}
+
+/* Pages left from @page_idx, so a range never reaches the mremap thread's area */
+static unsigned long room_from(unsigned long page_idx, unsigned long want)
+{
+	unsigned long left = shared_pages() - page_idx;
+
+	return want < left ? want : left;
+}
+
+static void *faulter_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+
+	while (!stop) {
+		unsigned long page_idx = rand_page(&seed);
+
+		if (rand_r(&seed) & 1)
+			*(unsigned int *)(region + page_idx * page_size) =
+				pattern(page_idx);
+		else
+			check_page(page_idx);
+	}
+	return NULL;
+}
+
+static void *dontneed_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+
+	while (!stop) {
+		unsigned long page_idx = rand_page(&seed);
+		unsigned long nr = 1UL << (rand_r(&seed) % 6);	/* 1..32 pages */
+
+		madvise(region + page_idx * page_size,
+			room_from(page_idx, nr) * page_size, MADV_DONTNEED);
+		usleep(rand_r(&seed) % 500);
+	}
+	return NULL;
+}
+
+static void *pinner_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+
+	while (!stop) {
+		struct gup_test gup = {};
+		unsigned long page_idx = rand_page(&seed);
+
+		unsigned long nr = room_from(page_idx, 16);
+
+		gup.addr = (unsigned long)(region + page_idx * page_size);
+		gup.size = nr * page_size;
+		gup.nr_pages_per_call = nr;
+		gup.gup_flags = 1;	/* FOLL_WRITE */
+		/* Racing MADV_DONTNEED makes transient failures expected. */
+		ioctl(gup_fd, PIN_FAST_BENCHMARK, &gup);
+		usleep(rand_r(&seed) % 200);
+	}
+	return NULL;
+}
+
+static void *forker_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+
+	while (!stop) {
+		pid_t pid = fork();
+
+		if (pid == 0) {
+			unsigned int val;
+			int bad = 0;
+
+			/*
+			 * No stdio in the child: a thread may have held
+			 * stdout's lock when we forked, and printing under an
+			 * inherited lock hangs.  The parent reports what the
+			 * exit status says.
+			 */
+			for (int i = 0; i < 16; i++)
+				bad |= page_is_corrupt(rand_page(&seed), &val);
+			_exit(bad);
+		}
+		if (pid > 0) {
+			int wstatus;
+
+			if (waitpid(pid, &wstatus, 0) < 0)
+				ksft_exit_fail_perror("waitpid()");
+			/* A child killed on the read counts too, not just its exit code. */
+			if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus))
+				corrupted = 1;
+		}
+		usleep(rand_r(&seed) % 2000);
+	}
+	return NULL;
+}
+
+static void *mremapper_fn(void *arg)
+{
+	unsigned int seed = (unsigned long)arg;
+
+	while (!stop) {
+		void *p;
+
+		p = mremap(mremap_area, hpage_pmd_size, hpage_pmd_size,
+			   MREMAP_MAYMOVE | MREMAP_FIXED, mremap_scratch);
+		if (p == MAP_FAILED)
+			ksft_exit_fail_perror("mremap() away");
+		for (int i = 0; i < 8; i++)
+			mremap_scratch[(rand_r(&seed) %
+				(hpage_pmd_size / page_size)) * page_size] = 1;
+		p = mremap(mremap_scratch, hpage_pmd_size, hpage_pmd_size,
+			   MREMAP_MAYMOVE | MREMAP_FIXED, mremap_area);
+		if (p == MAP_FAILED)
+			ksft_exit_fail_perror("mremap() back");
+		usleep(rand_r(&seed) % 2000);
+	}
+	return NULL;
+}
+
+static unsigned long now_ms(void)
+{
+	struct timeval tv;
+
+	gettimeofday(&tv, NULL);
+	return tv.tv_sec * 1000UL + tv.tv_usec / 1000;
+}
+
+static void usage(void)
+{
+	fprintf(stderr,
+		"Usage: khugepaged_race [-d seconds] [-m stepped|free|madvise] [-a areas]\n"
+		"\tWithout -m, every mode runs in turn.\n"
+		"\t-d: seconds per mode (default 5)\n"
+		"\t-a: number of shared PMD-sized playground areas (default 3)\n");
+	exit(1);
+}
+
+int main(int argc, char **argv)
+{
+	static const char * const thread_names[] = {
+		"faulter", "faulter2", "dontneed", "pinner", "forker",
+		"mremapper",
+	};
+	void *(*const thread_fns[])(void *) = {
+		faulter_fn, faulter_fn, dontneed_fn, pinner_fn, forker_fn,
+		mremapper_fn,
+	};
+	const int nr_threads = ARRAY_SIZE(thread_names);
+	pthread_t threads[ARRAY_SIZE(thread_names)];
+	static const char * const all_modes[] = { "stepped", "free", "madvise" };
+	const char *one_mode[1];
+	const char * const *modes = all_modes;
+	int nr_modes = ARRAY_SIZE(all_modes);
+	const char *mode_arg = NULL;
+	struct thp_settings settings;
+	unsigned long end_ms;
+	int duration_s = 5;
+	unsigned long thread_mask = ~0UL;
+	int nr_areas_arg = 0;
+	unsigned long i;
+	int steps = 0;
+	int opt;
+
+	while ((opt = getopt(argc, argv, "a:d:m:t:h")) != -1) {
+		switch (opt) {
+		case 'a':
+			nr_areas_arg = atoi(optarg);
+			break;
+		case 'd':
+			duration_s = atoi(optarg);
+			break;
+		case 'm':
+			mode_arg = optarg;
+			break;
+		case 't':
+			/* debug: bitmask of racing threads to start */
+			thread_mask = strtoul(optarg, NULL, 0);
+			break;
+		default:
+			usage();
+		}
+	}
+	if (mode_arg) {
+		if (strcmp(mode_arg, "stepped") && strcmp(mode_arg, "free") &&
+		    strcmp(mode_arg, "madvise"))
+			usage();
+		one_mode[0] = mode_arg;
+		modes = one_mode;
+		nr_modes = 1;
+	}
+
+	ksft_print_header();
+	if (!thp_available())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+
+	page_size = getpagesize();
+	hpage_pmd_size = read_pmd_pagesize();
+	if (!hpage_pmd_size)
+		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
+
+	gup_fd = open("/sys/kernel/debug/gup_test", O_RDWR);
+	if (gup_fd < 0)
+		ksft_exit_skip("/sys/kernel/debug/gup_test requires CONFIG_GUP_TEST and root\n");
+
+	nr_shared_areas = nr_areas_arg > 0 ? nr_areas_arg : DEFAULT_SHARED_AREAS;
+	nr_areas = nr_shared_areas + 1;
+
+	/*
+	 * The mremap thread moves its area to this address and back, and
+	 * MREMAP_FIXED unmaps whatever is in the way without saying so.  Claim
+	 * the address here, so a layout that does not match this assumption
+	 * fails now instead of losing a mapping later.  Nothing else in the
+	 * process maps this low: thread stacks and malloc arenas come from the
+	 * top-down mmap area, well above.
+	 */
+	mremap_scratch = (char *)BASE_ADDR + 2 * nr_areas * hpage_pmd_size;
+	if (mmap(mremap_scratch, hpage_pmd_size, PROT_NONE,
+		 MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED_NOREPLACE,
+		 -1, 0) != (void *)mremap_scratch)
+		ksft_exit_fail_perror("mmap() mremap scratch");
+
+	ksft_set_plan(nr_modes);
+
+	thp_save_settings();
+	thp_read_settings(&settings);
+
+	/*
+	 * A base entry for the stack, so that the pop at the end of a mode
+	 * always has something to write back: thp_pop_settings() on an empty
+	 * stack has no settings to apply and gives up.
+	 */
+	thp_push_settings(&settings);
+
+	for (int m = 0; m < nr_modes; m++) {
+		const char *mode = modes[m];
+
+		thp_read_settings(&settings);
+		settings.thp_enabled = THP_MADVISE;
+		settings.thp_defrag = THP_DEFRAG_ALWAYS;
+		settings.shmem_enabled = SHMEM_NEVER;
+		settings.khugepaged.defrag = 1;
+		settings.khugepaged.scan_sleep_millisecs =
+			strcmp(mode, "free") ? 1000 : 0;
+		settings.khugepaged.alloc_sleep_millisecs = 10;
+		/*
+		 * Strict occupancy: mTHP collapse only supports 0 or
+		 * HPAGE_PMD_NR - 1 and coerces anything else to 0 anyway, and 0
+		 * also keeps khugepaged from burning the whole step in doomed
+		 * PMD-sized allocations on 512M-PMD configs: under racing
+		 * MADV_DONTNEED a fully populated PMD area is rare.
+		 */
+		settings.khugepaged.max_ptes_none = 0;
+		settings.khugepaged.pages_to_scan =
+			nr_areas * (hpage_pmd_size / page_size) * 8;
+		for (i = 0; i < NR_ORDERS; i++) {
+			if (thp_supported_orders() & (1UL << i))
+				settings.hugepages[i].enabled = THP_INHERIT;
+		}
+		/* Popped at the end of this mode, before the next one. */
+		thp_push_settings(&settings);
+
+		region = mmap(BASE_ADDR, nr_areas * hpage_pmd_size,
+			      PROT_READ | PROT_WRITE, MAP_ANONYMOUS |
+			      MAP_PRIVATE | MAP_FIXED_NOREPLACE, -1, 0);
+		if (region != BASE_ADDR)
+			ksft_exit_fail_perror("mmap() playground");
+		mremap_area = region + nr_shared_areas * hpage_pmd_size;
+
+		/* Populate so the first pass has something to collapse. */
+		for (i = 0; i < nr_shared_areas * hpage_pmd_size / page_size; i++)
+			*(unsigned int *)(region + i * page_size) = pattern(i);
+		memset(mremap_area, 1, hpage_pmd_size);
+		if (madvise(region, nr_areas * hpage_pmd_size, MADV_HUGEPAGE))
+			ksft_exit_fail_perror("madvise(MADV_HUGEPAGE)");
+
+		for (i = 0; i < nr_threads; i++) {
+			if (!(thread_mask & (1UL << i))) {
+				threads[i] = 0;
+				continue;
+			}
+			if (pthread_create(&threads[i], NULL, thread_fns[i],
+					   (void *)(i + 1)))
+				ksft_exit_fail_perror(thread_names[i]);
+		}
+
+		end_ms = now_ms() + duration_s * 1000UL;
+		if (!strcmp(mode, "stepped")) {
+			while (now_ms() < end_ms && !corrupted) {
+				if (!khugepaged_full_pass(600))
+					ksft_exit_fail_msg("khugepaged pass timed out\n");
+				steps++;
+			}
+		} else if (!strcmp(mode, "free")) {
+			while (now_ms() < end_ms && !corrupted)
+				usleep(100 * 1000);
+		} else {	/* madvise */
+			while (now_ms() < end_ms && !corrupted) {
+				for (i = 0; i < nr_shared_areas; i++) {
+					madvise(region + i * hpage_pmd_size,
+						hpage_pmd_size, MADV_COLLAPSE);
+				}
+				madvise(region, nr_shared_areas * hpage_pmd_size,
+					MADV_DONTNEED);
+				steps++;
+			}
+		}
+
+		stop = 1;
+		for (i = 0; i < nr_threads; i++) {
+			if (threads[i])
+				pthread_join(threads[i], NULL);
+		}
+
+		/* Final integrity sweep. */
+		for (i = 0; i < nr_shared_areas * hpage_pmd_size / page_size; i++)
+			check_page(i);
+
+		ksft_test_result(!corrupted,
+				 "%s: %ds, %d steps, no corruption\n",
+				 mode, duration_s, steps);
+
+		/*
+		 * Hand the address space and the settings back before the
+		 * next mode: it maps the region at the same fixed address,
+		 * and its scan cadence differs.
+		 */
+		munmap(region, nr_areas * hpage_pmd_size);
+		thp_pop_settings();
+		stop = 0;
+		steps = 0;
+
+		if (corrupted) {
+			/* Memory is suspect; the rest would prove nothing. */
+			while (++m < nr_modes)
+				ksft_test_result_skip("%s: skipped after corruption\n",
+						      modes[m]);
+			break;
+		}
+	}
+
+	thp_restore_settings();
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index c0f69da3fd3b..fc61907aa3b2 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -406,6 +406,8 @@ CATEGORY="thp" run_test ./folio_order_check
 
 CATEGORY="thp" run_test ./khugepaged_sync_check
 
+CATEGORY="thp" run_test ./khugepaged_race
+
 CATEGORY="thp" run_test ./khugepaged
 
 CATEGORY="thp" run_test ./khugepaged -s 2
-- 
2.54.0


