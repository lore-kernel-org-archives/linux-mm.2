Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFD99C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 23:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA56F6B0088; Sun,  2 Aug 2026 19:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56256B008A; Sun,  2 Aug 2026 19:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44C26B0092; Sun,  2 Aug 2026 19:06:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92E4F6B0088
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 19:06:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18EE91402BC
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 23:06:53 +0000 (UTC)
X-FDA: 85057866306.07.799E96F
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4E67B8000A
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 23:06:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ISOM3XQw;
	spf=pass (imf02.hostedemail.com: domain of rientjes@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785712011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5l4odDXQoSJW0+BHeNDPiNY7HseZAOv5KH97z8YXnGI=;
	b=Wc2sGr8EH4cRWjvhhxOkI7xRqr8BzQzV+ImDuC5LQL1KAufvTXTVRVmyxFhNRkHzlB713D
	5NMBK1jow3GXR9WYOR/5Ro/c9AxVRg8bLgdgm+sfJscGgtieaMknEOlABlgeGgvw8nhW3h
	rxbWbjCUfPROmDcJ4Pw2t/gfF/duluo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ISOM3XQw;
	spf=pass (imf02.hostedemail.com: domain of rientjes@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785712011;
	b=kBTzRiJlaGyI9lCFalFTNEaHN11hmtcfj6FRFr1lXLBphIzJeo69tQT5Wax88QWV9x1Ecc
	0tp7IwE4q932upg41P9r/DaNdEjJIApB0TV5DyRdoyrRMIkQc3/VaFqu0ZcJGCCjcL9WWF
	AUMD2UQxdHLlmcRponGDFZfjNYMMqUI=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ccdf36f63dso84155ad.0
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 16:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785712010; x=1786316810; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5l4odDXQoSJW0+BHeNDPiNY7HseZAOv5KH97z8YXnGI=;
        b=ISOM3XQwtJqZIETzBO6xdo2z+wgGuTOoF9G4NLprD8qndbZx2XbLTgYb1/cxgXiK2x
         TYFmQzdrUFzQKYEMCl3/zlKe6WhVVnKGmxLJZai7v96so39xcO8F0jOYvwiZ5lwwtO3s
         7czVcO8uWuJO8xoG3ZYHKufxJG/eYFx4tShBlqdjab1aPqc3xzDAgzdMwszN6nSufTQn
         o2LWsEf5ymHSIZhmo35B3LSXtsAL9T1ReB+sMWa9WxbkK4urzzqH18RHexRqdtbpN7Su
         EKLNC59G7RVO6mn3ReLO41utLw0GHGN++qTga+k1Zl5JIQcQCO+DzBRPTe9slrsRF97V
         BBNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785712010; x=1786316810;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5l4odDXQoSJW0+BHeNDPiNY7HseZAOv5KH97z8YXnGI=;
        b=V+x4d9XAosqOrsx1J4Pv/ohawTFVQixW51lEEbV39/ijaTFvFLFgzdu+B/gd+w1k0y
         FpmGZCLQHugk9jvZ/8I+AudUGKdspkbTzWTrRob2zWnHDl/49mfKGmHmH/vKbJ5PO2p2
         lXrixIKNyxvBVM8pKZX2/h+fYBLnL36bWUkLRHiaqE2ZjidrbWO7JU1024KUTDI0S61p
         eXQMmoc4Nnt0FLseweAOgZYx4ePRK8lvKvwKuP3MX9Mui9R0q4Agu3WBc3EPDqDncoN1
         pJNre83BE1F026J7GvvJY6PbHqnejhuLbQe2XRKAdFmUX28zWyuHGT/NzrZ79ssar/A5
         +N4w==
X-Forwarded-Encrypted: i=1; AHgh+RoD5Ra50NSlPtQmvanD7QgLoOxgvwp3D8WcyYqdrsE1MDd0lnLWNuScw56aZ+8rRxynoMId+46MaQ==@kvack.org
X-Gm-Message-State: AOJu0YzC7C+rp4yTcbUwtYcgpDccd/mc4r50hJUtcwUdJaFXBgoBEW0u
	tfkFbagJRehUqPJgghYVe+s2fKEKQyJDqlytrT7mcopz9VYMdUcQOXb+PE5MiTJkzY/n8VzS6FO
	DzPIfaOKa
X-Gm-Gg: AR+sD10u76Q/CDIafc4tAw91C/IEXuLGDLNVcqXxyaZikk+/PGQYr9qghIgt7/aUwih
	zd1maW+Pnij03li0YmMaXnjNcIRN3leXcJPr+eJ7pd33pNJ9sQ+B6xfB7w2YwjSZZYCzcmCkIUu
	YE3J7Bg3hhZhojuC+30IylxM2nYpk0UEyAFkYg4jafDYlllG6754qwNsxBRHJxrHR68aZHDfJGz
	rGjrqNpF1o58SNZzVDJOtkDL8rRSq9Mt6IdxJZKwR8Snyqr2H/A2lvpos6SQwXOXAc7YiD4HpZe
	s1zu09axrMayFtWtLChHulIJQGDwujTWz3Yo1a4c61c9PHrCgKeYnnUE9NIGQMeNt6blqkqxC8z
	eIFtZHHjtusRtUl6xGUpClrdsBL1oT+Fgdts4x89zX/Dixj3eLDwTc/1g7Z468pVc3b/6yhSpPe
	TUrGIwu3+nvkJN/GrWYyYS5yVug98qN67taoYJmsgVeKoZy60MDiT6woLstNSRdjYTAiMVcT/xZ
	O5iUcwLn7y4a5Xa8/UhNcQ1K3SMdTqnUCLQ3penQ3z9V60jzR67g8migLO3g2HUyxLwQhY3U7qS
	PfPShoFCBUDgaMU=
X-Received: by 2002:a17:903:1205:b0:2cc:80b9:3a1 with SMTP id d9443c01a7336-2d0573c0ca7mr6072905ad.13.1785712009361;
        Sun, 02 Aug 2026 16:06:49 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:b3ef:da16:936a:c7c9] ([2a00:79e0:2eb4:9:b3ef:da16:936a:c7c9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84edc2d7b97sm2853952b3a.43.2026.08.02.16.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 16:06:48 -0700 (PDT)
Date: Sun, 2 Aug 2026 16:06:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@kernel.org>, Christoph Lameter <cl@gentwo.org>
cc: Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: [patch v2] lib: test_vmstat: add synthetic benchmark for vm stats
In-Reply-To: <e8dd28ab-ea7f-2ccf-c89e-a12f2d8b9988@google.com>
Message-ID: <94068447-f9c5-ba84-73be-bf492277b9b3@google.com>
References: <d6787a7f-3213-2b2c-2de5-af3b02daa21f@google.com> <e8dd28ab-ea7f-2ccf-c89e-a12f2d8b9988@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E67B8000A
X-Rspamd-Server: rspam01
X-Stat-Signature: 4gtdmhr4fu73wstcssyuide9317n94af
X-HE-Tag: 1785712011-227027
X-HE-Meta: U2FsdGVkX18ab2Vm9XFqyAS7nQ1WVgnt+gbPP/KgK0AOEs/0R2EGcdzat/FcggFZoQh8y6hhVlgb5K86BnsrXG1ZpcfnEuhrgwyunO19GTdaWjLoMJmt7ScvyzQvtEZfPi4rd+56sZDHsILlK+K6IIFJneN6iu6Xukn3tSuHht3LdtOBKENE/VsN6j41y1a3kcZPPcYwLaylfqEl0nXkSsvJWlyTNwKcCikfJlP8bZzbmzIz1J6inkDa8/WLsAJKtd/GpeRPdvPksxFwcmlyfiFGTv7edvxrkGdAXikYtBO5KuHiGJi33KiwuuiXm65tdfaaeuX8+rwJdaPXTrLvEFW4fVgpZoaina5tiuLycOyZq6qfR0TpRLaq/nx0ljL2lgOmSidmmK1/qv2kb9oInGuo0sfy1uJLoi7fi+y3sBCWSLYJ4GHudP2MvAGv7VWGXTRTlDmNudc46BxgoiG3pYQ7fWvvPrUsgSPBrbMSIHVK3OVPbwMWYjUaDH6PxZJRHy/kX1uHYdOrct3XbydPrFS1kaOJSOonWajZLQW9ldFUPv0TrUgQSeSJJrw85jcnQUmk/LIeBKLAjf+ZhSNmppWjrOX0yyuZTjqV/TXjv4/kpUmAelPjGId9f9Jvne3A8JlhFn0UgTg6xX0ptzsZGTRip/haWklyqr/4IOTvo9QUR/Y3KeKVAXClNSyTnasw5cNZx+B2g/orsDcStBJ9IEPEzW7AG1uN0H4x9o7pOk2ouiqusArtTscg+oP/GbnJtZDU0+Nxnm0W30v48HTmdpa6Hqotx0W/jeg8iPSr/KAsN4mrZQQOUjp080JDmH06C/iBR6GTh/y5g6jXaK1t5BJa5wc4k43tRaxpRgOhi+HJu8YfHKk4QqIA4Jl3hPIh1UYEdmWWsUj7jnQdHMXRlABQWpBkMN/WGzPhDi7BkqwXiJ5cdKScfus6iQSObJ2TkwaTd3GeOt9wsW1bTVZ
 WvcABo5f
 IBm47jQYAFLQAZHmN2E9hRCGVTtenEVOb6/AUhCcISVmGiD9+2YYFK0yxwpUzJAieX3hvS8Pn5ywFMDblN08WrXVlSopzQdNy6JHV+dv2jnSNJXcCdl9vrKpPQJLwx76CEFeqVHkuxuIMuG0BlTQUJbjDu+dtXTOP54OgT3dyk7EkmgxR5Rb1otU1X+YZh5VJFHu8OxRsJArrYg6XACjlyzs+OqKQDjXpzS7tEQpLKzI/VA/b75gyKBZCgk6v+to+pOHzAiO0t3vh32xVm/MWwsZkAuri6ZRVEH/MuMrYKL9LL5oxo78gYNMDK6pjQxsHWqFSx6mYaHmzuatL9eCt6BscdmscJo7pFdNNBhI8yC1GmhJADjuUWLfTpIfq+SgNfvEr0F6a2EqzknbwOg8FxRvMrtmDHGUfj/KrKeoKeFUSSmVnnK3KEQcGCMO3EZaEUvsCylxUoNGjxt7WoiGmUHgElA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Christoph Lameter <cl@gentwo.org>

Add a synthetic benchmark that can be used to measure performance of VM
statistics.  This is used to analyze any improvements or regressions in
functions that are frequently used in hot code paths.

The test is run by inserting the module: modprobe test_vmstat
The module insertion will always fail so that it is automatically
unloaded; the results are in the kernel log.

Signed-off-by: Christoph Lameter <cl@gentwo.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 v2:
  - added bash wrapper to ksft per David
  - integrated into ksft
  - added MAINTAINERS entry per David
  - fixed alloc_page() error code per Usama

 Adding single test for now to solicit feedback before updating the other
 two.

 MAINTAINERS                               |   1 +
 lib/Kconfig.debug                         |  10 +++
 lib/Makefile                              |   1 +
 lib/test_vmstat.c                         | 100 ++++++++++++++++++++++
 tools/testing/selftests/mm/Makefile       |   2 +
 tools/testing/selftests/mm/config         |   1 +
 tools/testing/selftests/mm/ksft_vmstat.sh |   4 +
 tools/testing/selftests/mm/run_vmtests.sh |   5 ++
 tools/testing/selftests/mm/test_vmstat.sh |  71 +++++++++++++++
 9 files changed, 195 insertions(+)
 create mode 100644 lib/test_vmstat.c
 create mode 100755 tools/testing/selftests/mm/ksft_vmstat.sh
 create mode 100755 tools/testing/selftests/mm/test_vmstat.sh

diff --git a/MAINTAINERS b/MAINTAINERS
index 5114e6db7307..c76514d6c503 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17004,6 +17004,7 @@ F:	mm/sparse.c
 F:	mm/util.c
 F:	mm/vmpressure.c
 F:	mm/vmstat.c
+F:	lib/test_vmstat.c
 N:	include\/linux\/page[-_][a-zA-Z]*
 
 MEMORY MANAGEMENT - EXECMEM
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1244dcac2294..6d743c8e27fa 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -3427,6 +3427,16 @@ config TEST_KEXEC_HANDOVER
 
 	  If unsure, say N.
 
+config TEST_VMSTAT
+	tristate "VM Statistics Benchmark"
+	default n
+	help
+	  A synthetic benchmark measuring the performance of VM statistics,
+	  useful to analyze any improvements or regressions in functions that
+	  are frequently used in hot code paths.
+
+	  If unsure, say N.
+
 config RATELIMIT_KUNIT_TEST
 	tristate "KUnit Test for correctness and stress of ratelimit" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/Makefile b/lib/Makefile
index 7f75cc6edf94..5f3ebabd0224 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -105,6 +105,7 @@ obj-$(CONFIG_TEST_FREE_PAGES) += test_free_pages.o
 obj-$(CONFIG_TEST_REF_TRACKER) += test_ref_tracker.o
 obj-$(CONFIG_TEST_OBJPOOL) += test_objpool.o
 obj-$(CONFIG_TEST_KEXEC_HANDOVER) += test_kho.o
+obj-$(CONFIG_TEST_VMSTAT) += test_vmstat.o
 
 obj-$(CONFIG_TEST_FPU) += test_fpu.o
 test_fpu-y := test_fpu_glue.o test_fpu_impl.o
diff --git a/lib/test_vmstat.c b/lib/test_vmstat.c
new file mode 100644
index 000000000000..ee4872a4c82d
--- /dev/null
+++ b/lib/test_vmstat.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Test module for in-kernel synthetic vm statistics performance.
+ *
+ * execute
+ *
+ *	modprobe test_vmstat
+ *
+ * to run this test
+ *
+ * (C) 2009 Linux Foundation, Christoph Lameter <cl@gentwo.org>
+ */
+
+#include <linux/jiffies.h>
+#include <linux/compiler.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <asm/timex.h>
+
+#define TEST_COUNT 10000
+
+static int vmstat_test_init(void)
+{
+	unsigned int i;
+	cycles_t time1, time2, time;
+	int rem;
+	struct page *page = alloc_page(GFP_KERNEL);
+
+	if (!page)
+		return -ENOMEM;
+
+	pr_alert("VMstat testing\n");
+	pr_alert("=====================\n");
+	pr_alert("1. inc_zone_page_state() then dec_zone_page_state()\n");
+	time1 = get_cycles();
+	for (i = 0; i < TEST_COUNT; i++)
+		inc_zone_page_state(page, NR_FREE_CMA_PAGES);
+
+	time2 = get_cycles();
+	time = time2 - time1;
+
+	pr_alert("%i times inc_zone_page_state() ", i);
+	time = div_u64_rem(time, TEST_COUNT, &rem);
+	pr_cont("-> %llu cycles ", (unsigned long long) time);
+
+	time1 = get_cycles();
+	for (i = 0; i < TEST_COUNT; i++)
+		dec_zone_page_state(page, NR_FREE_CMA_PAGES);
+
+	time2 = get_cycles();
+	time = time2 - time1;
+
+	pr_cont("__dec_z_p_s() ");
+	time = div_u64_rem(time, TEST_COUNT, &rem);
+	pr_cont("-> %llu cycles\n",  (unsigned long long) time);
+
+	pr_alert("2. inc_zone_page_state()/dec_zone_page_state()\n");
+	time1 = get_cycles();
+	for (i = 0; i < TEST_COUNT; i++) {
+		inc_zone_page_state(page, NR_FREE_CMA_PAGES);
+		dec_zone_page_state(page, NR_FREE_CMA_PAGES);
+	}
+
+	time2 = get_cycles();
+	time = time2 - time1;
+
+	pr_alert("%i times inc/dec ", i);
+	time = div_u64_rem(time, TEST_COUNT, &rem);
+	pr_cont("-> %llu cycles\n",  (unsigned long long) time);
+
+	pr_alert("3. count_vm_event()\n");
+	time1 = get_cycles();
+	for (i = 0; i < TEST_COUNT; i++)
+		count_vm_event(SLABS_SCANNED);
+
+	time2 = get_cycles();
+	time = time2 - time1;
+
+	count_vm_events(SLABS_SCANNED, -TEST_COUNT);
+	pr_alert("%i count_vm_events ", i);
+	time = div_u64_rem(time, TEST_COUNT, &rem);
+	pr_cont("-> %llu cycles\n",  (unsigned long long) time);
+	__free_page(page);
+
+        /* Fail will directly unload the module */
+        return IS_BUILTIN(CONFIG_TEST_VMSTAT) ? 0 : -EAGAIN;
+}
+
+static void vmstat_test_exit(void)
+{
+	pr_alert("test exit\n");
+}
+
+module_init(vmstat_test_init)
+module_exit(vmstat_test_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Christoph Lameter");
+MODULE_DESCRIPTION("VM statistics test");
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index e6df968f0971..0d386c8b83b7 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -173,8 +173,10 @@ TEST_PROGS += ksft_thp.sh
 TEST_PROGS += ksft_userfaultfd.sh
 TEST_PROGS += ksft_vma_merge.sh
 TEST_PROGS += ksft_vmalloc.sh
+TEST_PROGS += ksft_vmstat.sh
 
 TEST_FILES := test_vmalloc.sh
+TEST_FILES := test_vmstat.sh
 TEST_FILES += test_hmm.sh
 TEST_FILES += va_high_addr_switch.sh
 TEST_FILES += charge_reserved_hugetlb.sh
diff --git a/tools/testing/selftests/mm/config b/tools/testing/selftests/mm/config
index 06f78bd232e2..16e02a2cb2a1 100644
--- a/tools/testing/selftests/mm/config
+++ b/tools/testing/selftests/mm/config
@@ -2,6 +2,7 @@ CONFIG_SYSVIPC=y
 CONFIG_USERFAULTFD=y
 CONFIG_PTE_MARKER_UFFD_WP=y
 CONFIG_TEST_VMALLOC=m
+CONFIG_TEST_VMSTAT=m
 CONFIG_DEVICE_PRIVATE=y
 CONFIG_TEST_HMM=m
 CONFIG_GUP_TEST=y
diff --git a/tools/testing/selftests/mm/ksft_vmstat.sh b/tools/testing/selftests/mm/ksft_vmstat.sh
new file mode 100755
index 000000000000..4e47112f9925
--- /dev/null
+++ b/tools/testing/selftests/mm/ksft_vmstat.sh
@@ -0,0 +1,4 @@
+#!/bin/sh -e
+# SPDX-License-Identifier: GPL-2.0
+
+./run_vmtests.sh -t vmstat
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 8c296dedf047..c5416eda4c2e 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -47,6 +47,8 @@ separated by spaces:
 	tests for very large virtual address space
 - vmalloc
 	vmalloc smoke tests
+- vmstat
+	vmstat performance test
 - hmm
 	hmm smoke tests
 - madv_guard
@@ -338,6 +340,9 @@ fi # VADDR64
 # vmalloc stability smoke test
 CATEGORY="vmalloc" run_test bash ./test_vmalloc.sh smoke
 
+# vmstat performance test
+CATEGORY="vmstat" run_test bash ./test_vmstat.sh performance
+
 CATEGORY="mremap" run_test ./mremap_dontunmap
 
 CATEGORY="hmm" run_test bash ./test_hmm.sh smoke
diff --git a/tools/testing/selftests/mm/test_vmstat.sh b/tools/testing/selftests/mm/test_vmstat.sh
new file mode 100755
index 000000000000..a4fc7f7fec16
--- /dev/null
+++ b/tools/testing/selftests/mm/test_vmstat.sh
@@ -0,0 +1,71 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# This is a test script for the kernel test module to measure performance of VM
+# statistics.  It simply loads the kernel module.
+
+TEST_NAME="vmstat"
+DRIVER="test_${TEST_NAME}"
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+check_test_requirements()
+{
+	uid=$(id -u)
+	if [ $uid -ne 0 ]; then
+		echo "$0: Must be run as root"
+		exit $ksft_skip
+	fi
+
+	if ! which modprobe > /dev/null 2>&1; then
+		echo "$0: You need modprobe installed"
+		exit $ksft_skip
+	fi
+
+	if ! modinfo $DRIVER > /dev/null 2>&1; then
+		echo "$0: You must have the following enabled in your kernel:"
+		echo "CONFIG_TEST_VMSTAT=m"
+		exit $ksft_skip
+	fi
+}
+
+run_performance_check()
+{
+	echo "Run performance tests to evaluate how fast vmstat is."
+
+	modprobe $DRIVER > /dev/null 2>&1
+	echo "Done."
+	echo "Check the kernel message buffer to see the summary."
+}
+
+usage()
+{
+	echo -n "Usage: $0 performance"
+	echo
+	echo "Example usage:"
+	echo
+	echo "# Shows help message"
+	echo "./${DRIVER}.sh"
+	echo
+	echo "# Performance analysis"
+	echo "./${DRIVER}.sh performance"
+	echo
+	exit 0
+}
+
+function run_test()
+{
+	if [ $# -eq 0 ]; then
+		usage
+	else
+		if [[ "$1" = "performance" ]]; then
+			run_performance_check
+		fi
+	fi
+}
+
+check_test_requirements
+run_test $@
+
+exit 0

