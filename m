Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8F40C5CFCF
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 323226B0149; Wed, 12 Aug 2026 09:23:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FA626B014B; Wed, 12 Aug 2026 09:23:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19C046B014C; Wed, 12 Aug 2026 09:23:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E584D6B0149
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:23:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7EAB9C0384
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:48 +0000 (UTC)
X-FDA: 85092684936.26.1B4A6E2
Received: from fhigh-b1-smtp.messagingengine.com (fhigh-b1-smtp.messagingengine.com [202.12.124.152])
	by imf11.hostedemail.com (Postfix) with ESMTP id 881C540008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:23:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="x MiUF7T";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=LNMkxvW6;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6PELDQDgdL1ofsn+a6Ycmvq65G/VhZ4TTdp7hsL+eOo=;
	b=6TUhpSqxVTb1gyYgZS1+9M4YEzT4N+JVZOUYdFySf/wODG8uufaTAfp3mDluCx2KVKTsMb
	W08bCjiAe9F8eb5hw06ExFuSww8vRYQ8bCfYWAjA4GSxygbHTAUaiEfE0DA2C+FxLdKG8X
	5qxiiFYPmPRzyOn6KrOa/UxP2zemsmQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="x MiUF7T";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=LNMkxvW6;
	spf=pass (imf11.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541026;
	b=BB+ZlLZ3BFXLRQSP1y0DdOfNWYhn0u4/tjKg2vp4LiWXdoSKpYRk4HJd5ghg6xC+L7/dvj
	6fnZ2WZiTRXtwS5jSOrGmS6jLvIXGQc0Ur+NyVLEvM+wEsjEbvNJruuofODl+c4adVAufO
	ZX9Arrl1u0iYrT6OA+4RFO63z9JfPZ0=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 552437A00F7;
	Wed, 12 Aug 2026 09:23:45 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 12 Aug 2026 09:23:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786541025; x=
	1786627425; bh=6PELDQDgdL1ofsn+a6Ycmvq65G/VhZ4TTdp7hsL+eOo=; b=x
	MiUF7TnyTe9UL11b243rk2E1RA2R4fDL4ah/nlAVyRWWi4qf8nPckK5tgdtcld4c
	amqEg70rD+o91Rlh4Wk8d5xNQo9+hQyVgMoG+feDe4DkXS2Ax7J49mFjEvTPskJz
	6Z1W9E9FffqH31qf55x0Ko2/bbyuduzfsw7/3giWt59+XOD9+AMdEVK2oxgkdwCy
	POTeWi5tkwXCZl5BNi5YSE/7kgb8OlbzIWtxtDL27jCNf7+wdBkOQSilu1BwkH3L
	Q6IqvDJSMqb+u+DsqiVMgkCDLP3RG9C+OpjL9Oj5KS1E9Yq33a8TAniOskOcONp/
	R+uho20OGMllHEjAFfmxA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786541025; x=1786627425; bh=6
	PELDQDgdL1ofsn+a6Ycmvq65G/VhZ4TTdp7hsL+eOo=; b=LNMkxvW6ZyEdq3GZK
	ZC8Lv5PvbN5woCHPVrn9wPHkWcqh1qxCR9IsEryNGe4HgcDt6J7hNQ5KD2trBVoM
	bNuS8wMYo9xSGramz+QZMFhBK95tu9RaSPr36vdCP+cVTvRjr+GDLDL+vuPm1Vyg
	OnhMgszKsvVZAYa0EjiKgXx41iCpZ58CRnLAMI007l2KX/zNp3SQVL0Dpv9j6P+1
	Tdxrnm5YnyjO4nHpUdU1R6KCCRbYF3zo5z3izz1XE025uI1ZJzm4f4l7C/x0VjgB
	0Yi5U1QRnI52IwqyvCxlxgYVsETKdrLmOY/46QWcX3SvLdP2/8Wn4McHOK8aQ/I0
	wwKaQ==
X-ME-Sender: <xms:4HN8anbibgwKgruKXV5EDR_A_6D_DqAsmNvtEohJ-JKS3pfp5tghLw>
    <xme:4HN8aqW3ntF2-dawyoOu5pgj578SbDfDDpyYxXImxOgxRkHeI7tDwButb3HcX3wcp
    578_VS5XxmJtBbi2j_BYcTB8D9PfjxZOeD-E82dkw_4-IMp4q_yl6M>
X-ME-Received: <xmr:4HN8aieva4RPY5F-1ZtY97lIM4i4bV_oYqxdiKESlQuVgotg-1d2BLBThMg>
X-ME-Proxy-Cause: dmFkZTEWZPjKBYDoSh3uCuJ0ogiZvSuDj1RAgMuSmimalRft9LCPvZxyrluChLfTbkjo2r
    KkCK8Ttm4mqxi+W2/UjRoyI4gRuaMCGjIyoE2sYafZhhTXl0iIGCKEOr9/WVtZfHPc/pjz
    XsLpzK8U2Xu6F30SrJOujIlp1bmlomKUtpU/iiXSkRy6wwaI7NV8wAm1PQ0lHgRG0nCRKX
    WKIh8TtevEly/nhHwG2deu/klJhGkXN7h/CDYOOyqjOIkeF7MAFsC6fZtQDVeVkgzM4xU1
    Py5NrFUehZdXXi5LHUYxqNjNVNbuxWN2P2YJW6J2IL8s+zlVHHPN2YdKOlFVuMcbnWK9sh
    Zh/iqUff1BlKwk2ETqlAUo3CDRrLY2hXcGdUqRTk7FGYeW6lpDxfJ9e3an+QrSOGW0dAzi
    nKdzgBpwSozJafjPi1DxKzjrwPtjRSD4wUHlSxYEOg7uHmWIvOfvgY2BsteYEKaL7mqlP3
    PUIfbZB3mezZe/jUfjy8YTeXCWIJJ6Je2o0f+HB90Sg/vBo1Lp4YohG8oKeX+z0/NnVuEQ
    P0RBZGkV9qsKtMuEozJ0hGIxEUvuGO7K8wUpLvvSLL6lv1v6kcOWDU68CIp1xk+5BG7l1v
    vJrQ66VNbBl050PX/fFLJDzCXCECXV0lhzNUCbgKlnPw4GFyWE3wvIw5Kh7w
X-ME-Proxy: <xmx:4HN8anOuBt0D7OxmeQ2EFXYFjbV-qxIyJjatW2fmcTJALm_MDuATMw>
    <xmx:4XN8aqLrX3c7rFSxh_HswjymlL425RJWXw_nmynSWXRnKsPH5mv6sQ>
    <xmx:4XN8atnxK7ZXquilSYZeBLBOpNhUiMsHBh1W5YUZOZCr5iIpgdAhsA>
    <xmx:4XN8apYV_H227lFuEO-tbNLSwfwYBExqG2Y0UhxyscPHPikaqXayLg>
    <xmx:4XN8auaqF4pwQoQjnOKjdWEiQPyWX6g770uprztB4EuvYao5yfc0WC3->
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 09:23:44 -0400 (EDT)
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
Subject: [PATCH v3 14/18] selftests/mm: verify synchronous khugepaged driving is attributable
Date: Wed, 12 Aug 2026 14:23:00 +0100
Message-ID: <20260812132304.199287-15-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812132304.199287-1-kirill@shutemov.name>
References: <20260812132304.199287-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9cdswy9w3yqc3fu7guy6bb5xhxyytuom
X-Rspamd-Queue-Id: 881C540008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786541026-879092
X-HE-Meta: U2FsdGVkX18Ii6jrrSHbZy2eRK72nZ8sHUGVdmKQhHl43LY0GcbKROe8qVjbWwQwxf4KK+QtncKQ7GLMYH7xhR/HESlGQTJZ/vA0QbDdF4L1ayMtuTWM7zcp3qIHiEdq6Dq2a5bVFHWYFVqAGDiPbsiIPwRFiPGvSW7fGAHpIhscxYz9JJW0Siah0n1xmaFh/KzRDPlsS63Lpkz35KX3WNcvqeeQsJa2+60tm+uBcbo3PMtCqmlDbU2ieoI5Y+0q4LIdrePOKL98rqhrw8ut3tqs2XvxyN3BetzQtE+VVw0shIH4jfbM9cvHLOORc2c4EY82i9YQHZ8CHhwd8FqJsrmsIGW/ZoGeaF2UnaRBCfIL8/e5Axw57GtdipLqHH2sJl+d8+tkWc1ubKnUD2PZuAWReOuimvF76OKGO9dNVkUZTUfm4gpdVGoQWFuEXT6/8oQAXhZyXH55LjgJOKRhXKFz/OCP2O4B4He5xAvavvbLoXEewkyc132wqJwQjVTX3L5ZxW/hx5lJLMWIdAJm409be+9aTrriPjZlAOeQ6l+eaH8fSuOvpiMulFfcATkykBW16BOqlB0otkAOySEgmCY7p1hUvIbhqQYJ0PVk6J/OsMY3H+v6/1kiOcU33L8k5V+grqSwtDZrAwwyk1kN/elTT57Zy6C8cfKVPZBGCXT6+5i4Q7I7F5AwHQ2exd2oHcvLyTLuYnnvSqappROYu32Fd2P1YlVQQ0XjiouunE+c8CMaAGd50EqBlollUNDoU5h4v0OqGcr3vzDjtHBxdJAzta05wcYG5JODAX12usePRDsJMLVSn7CkRHDGjJF3yWzxP5en6jwfFrTDpLrZqkwh4mQ0WVlK48hggKpIEH6Dnjr58V5szxK1Z3MarR6wVDMUwv6hVBzzt3/WUJIeKxzL+xMkJi+5j8ovfH67ifBI7u5qAdLy8aKnzY7l2ypi/IqIhTgdgNfEk5a26J7
 EbbG2Ymx
 9HVss8/ajSdFo7MqJJPv+ElTJfhoKBzkv6VFrs3U+4RT2LPRfHWo1CjT72w/eLe2oVpJ+UFDVTm4YkkNU85odJmnSQQ91fYG7ep7jLszhvgJcQQUqywLLMDG41Z68icZV0dYqqDjbq+wyqEttX0erUEjtt1QHe2YUOyrBJPN+Q7tMqUgypCWQHUPUSKid9YeLGqhF/YqTmzCaO9D/u8ycS81Y5f7gX3rdUZDyODhvVh6JFr11Bbaxu8gjtKohK2Yujgmc5xfk6RwLLusT7CV+Ifnk6U6C8/KpEEwskl5Ts2IR6D0ZKJGNR4YTfQy+zy/EUSdPOLLkPgF84xAFpfdwPEivmXg5c+HuLQUDfiNhelU+Su4R4vKjKo1GeCoaC9JKNamXIvvHZhVIxz4yT4klh5DZvt+3ozMoqGRD6efFeD6PKFGb/QpxwWSSNvFO/9zVCx7IeLEIPIQqAcP0P4DP+GKQWkLxD8YaWFf/N3M1V/gakPvG2tZKrBHkX3XwR/BIelch
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The khugepaged tests attribute outcomes through the huge_memory
tracepoints.  The anon-path events carry no virtual address, but
mm_collapse_huge_page_isolate() reports a source folio PFN and order, and
the test matches those against the PFNs it read from pagemap before the
pass.  An attempt counts from whichever signal fires, so the check does
not depend on which anon tracepoint a kernel emits.

Add small tracefs helpers to vm_util and khugepaged_sync_check: per step,
prepare one aligned window, record its source PFNs, run one
khugepaged_full_pass() barrier, and require the window collapsed with
exactly one attributed attempt.  scan_sleep_millisecs is set high, so the
test only finishes in time if the sysfs store really wakes the daemon.

Passes 5/5 on x86-64 4K and arm64 64K.

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/Makefile           |   1 +
 .../selftests/mm/khugepaged_sync_check.c      | 217 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   2 +
 tools/testing/selftests/mm/vm_util.c          |  41 ++++
 tools/testing/selftests/mm/vm_util.h          |   4 +
 5 files changed, 265 insertions(+)
 create mode 100644 tools/testing/selftests/mm/khugepaged_sync_check.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 2093fcf6e915..b2d6e5c12934 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -105,6 +105,7 @@ TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
 TEST_GEN_FILES += folio_order_check
+TEST_GEN_FILES += khugepaged_sync_check
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/khugepaged_sync_check.c b/tools/testing/selftests/mm/khugepaged_sync_check.c
new file mode 100644
index 000000000000..30d3fb519fb2
--- /dev/null
+++ b/tools/testing/selftests/mm/khugepaged_sync_check.c
@@ -0,0 +1,217 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Synchronous khugepaged driving check.
+ *
+ * Race tests drive khugepaged through the existing sysfs controls: a
+ * store to scan_sleep_millisecs wakes the daemon, and full_scans
+ * advancing by two is a completion barrier for one full pass that
+ * started after setup (khugepaged_full_pass()). Verify the pair gives
+ * deterministic, attributable results: one barrier step over one
+ * prepared window produces exactly one collapse attempt on that
+ * window's source pages (mm_collapse_huge_page_isolate events filtered
+ * by source PFN and order) and the window is collapsed
+ * afterwards, repeatably.
+ *
+ * scan_sleep_millisecs is set to 60s to prove the wake path: without
+ * the wake, one barrier step would sleep multiples of that and blow
+ * the timeout. It also keeps the daemon from free-running between
+ * steps, per the khugepaged_full_pass() discipline.
+ */
+#define _GNU_SOURCE
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <unistd.h>
+
+#include "kselftest.h"
+#include "vm_util.h"
+#include "hugepage_settings.h"
+
+#define BASE_ADDR ((void *)(1UL << 30))
+#define TARGET_ORDER 2	/* smallest order khugepaged considers */
+#define NR_ITERATIONS 5
+
+static int pagemap_fd;
+static int kpageflags_fd;
+static int trace_events_fd = -1;
+static unsigned long hpage_pmd_size;
+
+/*
+ * Each step switches the events off again, but a helper can still give up
+ * on us in between (a failing sysfs write ends the test from inside
+ * thp_write_num()), and huge_memory events left on are the whole machine's
+ * problem, not this test's.
+ */
+static void trace_events_off(void)
+{
+	if (trace_events_fd >= 0)
+		tracing_events_enable(trace_events_fd, false);
+}
+
+/*
+ * Count collapse attempts attributable to our window: legacy-engine
+ * isolate events whose scan_pfn is one of the window's source PFNs,
+ * plus batch-engine per-candidate install events at the window's
+ * address. Either engine reports exactly once per attempt.
+ */
+static int count_attributed(unsigned long *pfns, int nr_pfns,
+			    unsigned long addr, unsigned int order)
+{
+	char line[1024];
+	int count = 0;
+	FILE *fp;
+
+	fp = tracing_open_trace();
+	if (!fp)
+		ksft_exit_fail_msg("Cannot open trace buffer\n");
+
+	while (fgets(line, sizeof(line), fp)) {
+		char *s;
+		unsigned long val;
+		unsigned int ord;
+		char *o;
+		int i;
+
+		s = strstr(line, "mm_collapse_huge_page_isolate:");
+		if (s) {
+			if (sscanf(s, "mm_collapse_huge_page_isolate: scan_pfn=0x%lx",
+				   &val) != 1)
+				continue;
+			o = strstr(s, "order=");
+			if (!o || sscanf(o, "order=%u", &ord) != 1 ||
+			    ord != order)
+				continue;
+			for (i = 0; i < nr_pfns; i++) {
+				if (val == pfns[i]) {
+					count++;
+					break;
+				}
+			}
+			continue;
+		}
+
+		s = strstr(line, "mm_collapse_candidate:");
+		if (s) {
+			if (!strstr(s, "pass=install") ||
+			    !strstr(s, "result=succeeded"))
+				continue;
+			o = strstr(s, "addr=");
+			if (!o || sscanf(o, "addr=0x%lx", &val) != 1 ||
+			    val != addr)
+				continue;
+			o = strstr(s, "order=");
+			if (!o || sscanf(o, "order=%u", &ord) != 1 ||
+			    ord != order)
+				continue;
+			count++;
+		}
+	}
+	fclose(fp);
+	return count;
+}
+
+static void one_step(int iteration)
+{
+	const size_t window = getpagesize() << TARGET_ORDER;
+	const int nr_pages = 1 << TARGET_ORDER;
+	unsigned long pfns[1 << TARGET_ORDER];
+	bool collapsed, passed;
+	int attributed;
+	char *p;
+	int i;
+
+	p = mmap(BASE_ADDR, hpage_pmd_size, PROT_READ | PROT_WRITE,
+		 MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED_NOREPLACE, -1, 0);
+	if (p != BASE_ADDR)
+		ksft_exit_fail_perror("mmap() window");
+
+	/* Prepare one window; record its source PFNs. */
+	for (i = 0; i < nr_pages; i++) {
+		p[i * getpagesize()] = i + 1;
+		pfns[i] = pagemap_get_pfn(pagemap_fd, p + i * getpagesize());
+		if (pfns[i] == -1UL)
+			ksft_exit_fail_msg("Source page not present\n");
+	}
+
+	/* Clear first: with the events still off there is nothing to undo. */
+	if (tracing_clear_trace())
+		ksft_exit_fail_msg("Cannot clear the trace buffer\n");
+	if (tracing_events_enable(trace_events_fd, true))
+		ksft_exit_fail_msg("Cannot enable huge_memory events\n");
+
+	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
+	/* Wait up to 120 seconds for the pass to complete. */
+	passed = khugepaged_full_pass(120);
+
+	/* Off before anything that can give up: the events are system-wide. */
+	if (tracing_events_enable(trace_events_fd, false))
+		ksft_exit_fail_msg("Cannot disable huge_memory events\n");
+	if (!passed)
+		ksft_exit_fail_msg("khugepaged did not complete a full pass\n");
+
+	collapsed = is_range_backed_by_folio_orders(p, window, TARGET_ORDER,
+						    pagemap_fd, kpageflags_fd);
+	attributed = count_attributed(pfns, nr_pages, (unsigned long)p,
+				      TARGET_ORDER);
+
+	ksft_test_result(collapsed && attributed == 1,
+			 "step %d: window collapsed, %d attributed result(s)\n",
+			 iteration, attributed);
+
+	munmap(p, hpage_pmd_size);
+}
+
+int main(void)
+{
+	struct thp_settings settings;
+	int i;
+
+	ksft_print_header();
+
+	if (!thp_available())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+	if (!(thp_supported_orders() & (1UL << TARGET_ORDER)))
+		ksft_exit_skip("Order %d is not a supported anon THP order\n",
+			       TARGET_ORDER);
+
+	hpage_pmd_size = read_pmd_pagesize();
+	if (!hpage_pmd_size)
+		ksft_exit_fail_msg("Reading PMD pagesize failed\n");
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd < 0)
+		ksft_exit_fail_perror("open(/proc/self/pagemap)");
+	kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
+	if (kpageflags_fd < 0)
+		ksft_exit_skip("open(\"/proc/kpageflags\") requires root\n");
+	trace_events_fd = tracing_events_open("huge_memory");
+	if (trace_events_fd < 0)
+		ksft_exit_skip("huge_memory events require tracefs and root\n");
+	atexit(trace_events_off);
+
+	ksft_set_plan(NR_ITERATIONS);
+
+	thp_save_settings();
+	thp_read_settings(&settings);
+	settings.thp_enabled = THP_MADVISE;
+	settings.thp_defrag = THP_DEFRAG_ALWAYS;
+	settings.khugepaged.defrag = 1;
+	settings.khugepaged.scan_sleep_millisecs = 60000;
+	settings.khugepaged.alloc_sleep_millisecs = 60000;
+	settings.khugepaged.max_ptes_none = (hpage_pmd_size / getpagesize()) - 1;
+	/* One wake must complete one full pass; see khugepaged_full_pass(). */
+	settings.khugepaged.pages_to_scan = 1UL << 24;
+	for (i = 0; i < NR_ORDERS; i++)
+		settings.hugepages[i].enabled = THP_NEVER;
+	settings.hugepages[TARGET_ORDER].enabled = THP_INHERIT;
+	/* Base of the settings stack; the bottom entry is never popped. */
+	thp_push_settings(&settings);
+
+	for (i = 0; i < NR_ITERATIONS; i++)
+		one_step(i);
+
+	thp_restore_settings();
+
+	ksft_finished();
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 8bf898b71350..c0f69da3fd3b 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -404,6 +404,8 @@ CATEGORY="cow" run_test ./cow
 
 CATEGORY="thp" run_test ./folio_order_check
 
+CATEGORY="thp" run_test ./khugepaged_sync_check
+
 CATEGORY="thp" run_test ./khugepaged
 
 CATEGORY="thp" run_test ./khugepaged -s 2
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index c9bd6c92fa41..ee1334778391 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -598,6 +598,47 @@ bool is_range_backed_by_folio_orders(char *start, size_t len, int order,
 	return true;
 }
 
+#define TRACEFS_ROOT "/sys/kernel/tracing"
+
+/*
+ * Open the enable file of one ftrace event subsystem (e.g. "huge_memory").
+ * Returns a descriptor for tracing_events_enable(), or -1 if tracefs or the
+ * subsystem is not there.  The events are system-wide state: whoever
+ * switches them on owns them until it switches them off, including on the
+ * paths where the test gives up.
+ */
+int tracing_events_open(const char *subsys)
+{
+	char path[256];
+
+	snprintf(path, sizeof(path), TRACEFS_ROOT "/events/%s/enable",
+		 subsys);
+	return open(path, O_WRONLY);
+}
+
+int tracing_events_enable(int fd, bool enable)
+{
+	if (pwrite(fd, enable ? "1" : "0", 1, 0) != 1)
+		return -1;
+	return 0;
+}
+
+/* Drop what the trace buffer holds so far. */
+int tracing_clear_trace(void)
+{
+	int fd = open(TRACEFS_ROOT "/trace", O_WRONLY | O_TRUNC);
+
+	if (fd < 0)
+		return -1;
+	close(fd);
+	return 0;
+}
+
+FILE *tracing_open_trace(void)
+{
+	return fopen(TRACEFS_ROOT "/trace", "r");
+}
+
 /* If `ioctls' non-NULL, the allowed ioctls will be returned into the var */
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls)
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index ce05bce4670d..10c7be46e44c 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -119,6 +119,10 @@ int close_procmap(struct procmap_fd *procmap);
 int write_sysfs(const char *file_path, unsigned long val);
 int read_sysfs(const char *file_path, unsigned long *val);
 bool softdirty_supported(void);
+int tracing_events_open(const char *subsys);
+int tracing_events_enable(int fd, bool enable);
+int tracing_clear_trace(void);
+FILE *tracing_open_trace(void);
 
 static inline int open_self_procmap(struct procmap_fd *procmap_out)
 {
-- 
2.54.0


