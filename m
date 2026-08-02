Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7CD6C55174
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 19:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50CE86B009E; Sun,  2 Aug 2026 15:53:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4979A6B009F; Sun,  2 Aug 2026 15:53:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3369B6B00A0; Sun,  2 Aug 2026 15:53:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB90A6B009E
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 15:53:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 36B2F1C05DF
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:23 +0000 (UTC)
X-FDA: 85057378686.30.02B280A
Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	by imf29.hostedemail.com (Postfix) with ESMTP id 34C11120002
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:53:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=VhPJ2BnO;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="X OYp3Bn";
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785700401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FubTz6hs1ouD8czSiv6S3nBYtEo7V5uwGpnAX260wY8=;
	b=yhQEHkVkGO2rWqrkLtJn5HZLtoOZysHLdRE0BFeMa6zDrS73P6b2LxUVyXdZqxR2PtLpSK
	EVAX2HnDl+F7c4FVwCMW0goDu0edPRCR2036mgiPPWektNP8MuX+l65MJBz5itbF2EB6tA
	kpltAz3lM5bHfDpC7qAbMMkj1bcH74o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=VhPJ2BnO;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="X OYp3Bn";
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785700401;
	b=fjxmXq6kmj1+Vf/XpUVkMx8QFycQUv6nNR1TAgC207qscuMyf+SXU4CLZgVVODLRZy5pyh
	vap9kG35ZUvnNz1NrBc9kJR2OnJgFTxPUYFZ24QFe85utYu0v34NHvVLkrQsZe6YENEC2t
	bXZzIjJyW0RLrp75iTqKwHwRTI/2dIo=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id C75D41400051;
	Sun,  2 Aug 2026 15:53:20 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Sun, 02 Aug 2026 15:53:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm1;
	 t=1785700400; x=1785786800; bh=FubTz6hs1ouD8czSiv6S3nBYtEo7V5uw
	GpnAX260wY8=; b=VhPJ2BnOSUlF7S7/VxwA+6X6T5nSkK7Cf9K71AdLO3L9u/o0
	0oudXXMwxTg/21kHJLP7CwX2hQhBA/onS9XxJ0VOE++8I8GlLHVZAiUR+Q4HA77B
	xRoiF59GSKE+MKu3bb4xLg/xu26Ao5NoBedEpMVkjZi58eor33YLsQmpaWIImglM
	bN7h7oWSZxTNuRMFX2IxhrqKifRIdY+bUWFI5KiPxDVjbkRqAzwVGi8qO7f6nger
	pmc0simfsS/iMBLt1KC+DHmIj8ad8Iwoi50qf25tLnA7K7e6iWoh85Xl55frM/hS
	Sv8RZyYvCwVgrn+jc6fhcNRVaaDHx3PULm5KCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1785700400; x=
	1785786800; bh=FubTz6hs1ouD8czSiv6S3nBYtEo7V5uwGpnAX260wY8=; b=X
	OYp3BnoHDvVZpEtrXQVEca4G7F09FA4oCSv19Mi//qjnSGaivdAtF2CmnP77qAtW
	NXjdi+jjDXS8GfUiE58Js+r94i+TV1/UCKAnNPcXSRJH/fkaaHcNtux8mKxJklkO
	NHqLobvyXV+Yv3jza79ytJhqkdaQvqOf0da2jnPLCsSC1zni8NihZ1aGkQ85sUSP
	Vt3MQlX9a6Oq1XIC1okz9MetQ60/Li4072FxGkQ2rvWEhvar2qDucsQUwajWpSkE
	IxP0iUeh3dJ9gCcmeeIiigwe9p8M9RhzDYNHxSoG0patD8tgbmj/pyUhOS+Ivnb2
	ubfKN3BEvraT40ewb3vgg==
X-ME-Sender: <xms:MKBvamzL_9jNlmm8Dz4FKfL7LSIWAoEnlte-gyFu0Uacd-_KnD4YtQ>
    <xme:MKBvasxM-A9bqDXEIBQEHU6Ft9qcHYrqYi1ABfk4_g9p5cAP-Q122_YMZSiMwjRS2
    DCFEFtL6PX_qOAcxZL7-uM5DoirySGFzXGvvODS1pTtmhZFiRznDzlw>
X-ME-Received: <xmr:MKBvalSY7dvgkdjFWccQubI-W3K4rSn9OnPflMbZEExFflvZZ0oKzlCIXCA>
X-ME-Proxy-Cause: dmFkZTFRqBzYArQKIzPxb/MEmNdGCT9ToZWR2Z9MFKXceCJ1pZ0XPHz+Tzow2tPL6GklJ1
    ebwaY4MKncGqyHJ1wskc6iYnqwrXZWvu+eDTzjBDdq3qg5JzcpKLV2w5UXl++0ReGOv608
    KE0HsICS0VS04Z0PWJwgXozgbjanng2s7GWgtPtWep1u75VG+5Ccb7pmOLAYQRehnk8s/n
    Wx2YaYakwl8jPSznTBPTV6Ns7Dgzgr24rNO0/DjwxE75tlmTUYoBr01HkosW3AQHBZRkOJ
    RXiFIhKzFvuBcF0iyrVURvrOvHy+xWjdSnjKWHJiNPnoaoE8xNEOGhdnSZ1IPeyDLmLLYX
    uUJVTW0Me7paWo9F03nzroIpuGs/8s3+DVGsUJ1sotkmj5uha2nRl+rGCTU9tpEsvZ6AXh
    To1ne1wwU99aZMzofS7ZEb/alPh7L54FPvN1weItXQ0zXILe8QRfJAlyczSjfjxlI0KL0a
    /2YnCaVyD2VWzv2lmDzEKXNKIzP5rfPCCE7V729mBGyFl1cwkzoARw/5IrmeoozAUaj/ht
    /5mkdade7oOJcMOp2TYWCVFM8GaepmTcVVYIcmTXf5NWk/k47ntqNI/8AYYXTQxC6yf3q8
    LadlRDdJ5Q16q7lF1dK3EsCKWE+TQXlPNNFsJHFzKAs98+IDdxjjUr/NClKw
X-ME-Proxy: <xmx:MKBvavMa4nvXsIp_I0Epb3vb2ssynhKlThJo4jvZaHcuXb2pWWLmkQ>
    <xmx:MKBvagQPPkoZQ3dHJ_krDv-507Sb0VIkPcz9eb6dBrSxkogHd0KWWw>
    <xmx:MKBvaq9T0sOitOrbkeDhkJ5Nc5kgtXNXbjOw_JfURZiFKNle4qqTqA>
    <xmx:MKBvaiVUyDbjEX41HXyuQ3xkwr82nMYaLSCv8qVuDbfWxQEXT23q3Q>
    <xmx:MKBvaguqZCkOMBBB5mc8CcYS7e6Pyn3VslP2F4i46Y8AbYxedcUBDfZ3>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Aug 2026 15:53:20 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Nico Pache <nico.pache@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 10/16] selftests/mm: verify synchronous khugepaged driving is attributable
Date: Sun,  2 Aug 2026 20:52:42 +0100
Message-ID: <20260802195254.1937477-11-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260802195254.1937477-1-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 34C11120002
X-Stat-Signature: jbayqed16ofhdm6hong8cc3r14pnsnom
X-HE-Tag: 1785700401-520113
X-HE-Meta: U2FsdGVkX19nBw6KgvjXeCu89QoX48zKL06/kHQ1oPrNBBhPcvMXE27FwJ1cqWQUnkcbW0hobwLsr1aF+95vxMrjMFaJ2RPJPd/gYOEwxM1MnjhXIV78ilxWkWgOC+W/XUrnjf5ssWejzHEvTwPCOuADU8aqSO7Yep785guTS9eF+9HTw8PpPvZNaKCrgkmEScDlDXv9vME3rXSFXTLAHnFoR6QM2vhUPVGRrDq8KdZ86M43bro80R2MNPQP947nOoQ/EbH1xqS64OcEeO/ptjIcFS+Q/uXy6XpVOlZGaXbAo3JvqnKDr/wa09ZlDWeEimpqB8os6OnKfr5HJgsuYsWCQ7q0rK51rleN7R9bIXa08L8mF5Url8734T4v1rOVRsiWvwwcz8SiFhEtXaTovtRThbYawsvdi43WIBB5SGvWfPRqtGH/bW3fP3wz0EeyfaaPXOmqmpiHlgNU54O42dnVwf8IqKP7UHZKFNI2Djvh4X+xd68+vXbnNpSO0r34/XqWrqvyuV5pesco5AAeYrkfKcE/GIKLT7Qq8vDRtb2/aE+eXT8BERDin4K+JKM/9O4r2upiX4LUpxwYJCvgtfD6lkKz7yKCX6yiPkcqtOGfYQSKP9IhCsc7hpDdCqMzbPw7jIKL1ONxWZJXP3snw/pfBb8GOJWRLmNCdM/aP2U08QS7LdXDLw7AZodv0cp8Ses+MpkQfMGJngNjAJlsXlkfljwAt5Kj3fP5xKS2X8yLzcC3ZhnXonLwwRRk9ClFX0JMKrlrMq0ECZdMFp3n+pRu3v+F/pbZ7eLXN8BRnyPQf7RSbTcAXNjeqjhXOmivnMPZY1CKbPESv2uJ4DmKs9POjTtTS+lLb1sAzrQoNjPMwe9gH970an+cSgA7+QUpKd7HDEEf19grQbTTBPi2MSjqrTEq9X5jOrBmvjblr7dPPC/uOkiSMtPEtLcp1FHWcH62G6oqAunqMnVZrQd
 oUHM8D6/
 kufW8KchrjsK0OoCcXlTzZ36Rvzq1bPDbltNnrz1C8fIrUz35VOtxlMSaqMai58I/PX0c/488sjgrxP7l5pF79flY+ALJooGkn55muXWT5EGAM08ZuDdDE5/y+pQrxROW8XV2hawuRSvTiYqdbhew+4/iGeX0jbE5I56znu+qFY/5uhKmwDpu+Q7Iy6NMDrWeeilnN/3Ujk6Kroej6AMNcR3Xe1brWwZHsk0XzMsQr4Bb0gyH5IMejBbM3qW1tDNHtwcYFNFkSktGgBZv5zGwjt+BAcC26KRLvgT48OOvA1TFvLGYFJcToLXl1ng5lkdZVTu/awv4TbWFpZygJQCDXEDP7nrFCgDpZSh0JY6QJNsam7WXoeqKe1QLuLUDg+n/ImAf2FxxFfVWfPAH9Y1i9+pnvr81Pu1qeZm9fMUv6MtAHK4ad6AemjgZpSpuzUKgh/TFB/726S5/S7LMd/kTg6DStilAnbZ6Ph5/McSVQVuBvR4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The khugepaged tests attribute per-attempt outcomes through the
huge_memory tracepoints. The anon-path events carry no virtual address,
but an attempt is identifiable anyway: mm_collapse_huge_page_isolate()
reports a source folio PFN and order, which the test matches against the
PFNs it recorded from pagemap before the pass. Count an attempt from
whichever attribution signal fires, so the check does not depend on which
of the anon tracepoints a given kernel emits.

Add minimal tracefs helpers to vm_util (enable/clear one event subsystem,
open the trace buffer) and a khugepaged_sync_check test: per step, prepare
one aligned window, record its source PFNs, run one khugepaged_full_pass()
barrier and require the window collapsed with exactly one attributed
attempt. Five steps; scan_sleep_millisecs is set high so the test only
completes inside its timeout if the sysfs store really wakes the daemon.

Passes 5/5 on x86-64 4K and arm64 64K.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/.gitignore         |   1 +
 tools/testing/selftests/mm/Makefile           |   1 +
 .../selftests/mm/khugepaged_sync_check.c      | 198 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   2 +
 tools/testing/selftests/mm/vm_util.c          |  49 +++++
 tools/testing/selftests/mm/vm_util.h          |   3 +
 6 files changed, 254 insertions(+)
 create mode 100644 tools/testing/selftests/mm/khugepaged_sync_check.c

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
index b3b26447cd23..616043a0fcd2 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -67,4 +67,5 @@ prctl_thp_disable
 rmap
 folio_split_race_test
 folio_order_check
+khugepaged_sync_check
 khugepaged_race
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 046bae8d1eff..026d4b61414d 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -105,6 +105,7 @@ TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
 TEST_GEN_FILES += folio_split_race_test
 TEST_GEN_FILES += folio_order_check
+TEST_GEN_FILES += khugepaged_sync_check
 TEST_GEN_FILES += khugepaged_race
 
 ifneq ($(ARCH),arm64)
diff --git a/tools/testing/selftests/mm/khugepaged_sync_check.c b/tools/testing/selftests/mm/khugepaged_sync_check.c
new file mode 100644
index 000000000000..13215cb370ce
--- /dev/null
+++ b/tools/testing/selftests/mm/khugepaged_sync_check.c
@@ -0,0 +1,198 @@
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
+ * window's source pages — mm_collapse_huge_page_isolate events
+ * filtered by source PFN and order — and the window is collapsed
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
+static unsigned long hpage_pmd_size;
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
+	bool collapsed;
+	int attributed;
+	char *p;
+	int i;
+
+	p = mmap(BASE_ADDR, hpage_pmd_size, PROT_READ | PROT_WRITE,
+		 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
+	if (p != BASE_ADDR)
+		ksft_exit_fail_msg("Failed to allocate VMA at %p\n",
+				   BASE_ADDR);
+
+	/* Prepare one window; record its source PFNs. */
+	for (i = 0; i < nr_pages; i++) {
+		p[i * getpagesize()] = i + 1;
+		pfns[i] = pagemap_get_pfn(pagemap_fd, p + i * getpagesize());
+		if (pfns[i] == -1UL)
+			ksft_exit_fail_msg("Source page not present\n");
+	}
+
+	if (tracing_events_start("huge_memory"))
+		ksft_exit_fail_msg("Cannot enable huge_memory events\n");
+
+	madvise(p, hpage_pmd_size, MADV_HUGEPAGE);
+	/* Wait up to 120 seconds for the pass to complete. */
+	if (!khugepaged_full_pass(120))
+		ksft_exit_fail_msg("khugepaged did not complete a full pass\n");
+
+	tracing_events_stop("huge_memory");
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
+		ksft_exit_fail_perror("open(\"/proc/self/pagemap\")");
+	kpageflags_fd = open("/proc/kpageflags", O_RDONLY);
+	if (kpageflags_fd < 0)
+		ksft_exit_skip("open(\"/proc/kpageflags\") requires root\n");
+	if (tracing_events_start("huge_memory"))
+		ksft_exit_skip("tracefs unavailable\n");
+	tracing_events_stop("huge_memory");
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
index a8b6b839cb97..f61ec76d8e00 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -405,6 +405,8 @@ CATEGORY="cow" run_test ./cow
 CATEGORY="thp" run_test ./folio_order_check
 
 
+CATEGORY="thp" run_test ./khugepaged_sync_check
+
 CATEGORY="thp" run_test ./khugepaged_race -d 5 -m stepped
 
 CATEGORY="thp" run_test ./khugepaged_race -d 5 -m free
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 793342095420..886fb3de9c01 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -411,6 +411,55 @@ bool is_range_backed_by_folio_orders(char *start, size_t len, int order,
 	return true;
 }
 
+#define TRACEFS_ROOT "/sys/kernel/tracing"
+
+static int tracing_events_write(const char *subsys, const char *val)
+{
+	char path[256];
+	int fd;
+
+	snprintf(path, sizeof(path), TRACEFS_ROOT "/events/%s/enable",
+		 subsys);
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		return -1;
+	if (write(fd, val, 1) != 1) {
+		close(fd);
+		return -1;
+	}
+	close(fd);
+	return 0;
+}
+
+/*
+ * Enable one ftrace event subsystem (e.g. "huge_memory") and clear the
+ * trace buffer. Returns -1 if tracefs is unavailable; parse the results
+ * via tracing_open_trace() after tracing_events_stop().
+ */
+int tracing_events_start(const char *subsys)
+{
+	int fd;
+
+	if (tracing_events_write(subsys, "1"))
+		return -1;
+
+	fd = open(TRACEFS_ROOT "/trace", O_WRONLY | O_TRUNC);
+	if (fd < 0)
+		return -1;
+	close(fd);
+	return 0;
+}
+
+int tracing_events_stop(const char *subsys)
+{
+	return tracing_events_write(subsys, "0");
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
index 76e9938a908e..4ff5a1c5ab8e 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -115,6 +115,9 @@ int close_procmap(struct procmap_fd *procmap);
 int write_sysfs(const char *file_path, unsigned long val);
 int read_sysfs(const char *file_path, unsigned long *val);
 bool softdirty_supported(void);
+int tracing_events_start(const char *subsys);
+int tracing_events_stop(const char *subsys);
+FILE *tracing_open_trace(void);
 
 static inline int open_self_procmap(struct procmap_fd *procmap_out)
 {
-- 
2.54.0


