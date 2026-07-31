Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89078C55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 04:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C4836B0092; Fri, 31 Jul 2026 00:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49BAA6B0093; Fri, 31 Jul 2026 00:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363A16B0095; Fri, 31 Jul 2026 00:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05F196B0092
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 00:26:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 64DB6A1541
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:26:28 +0000 (UTC)
X-FDA: 85047785256.28.C1560C1
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id A9480120002
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:26:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cZ0TsiX+;
	spf=pass (imf29.hostedemail.com: domain of rientjes@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785471986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYx+7/vOEZAK67zN7a62VWu2wkdimiEvpJwaQveLjY8=;
	b=kqCevq7IxUgKVtq7iwo5ItIS+S4KlYG0T61+yjUN7nWExg7I5V4H8f2SPEiD7wXmti1lOe
	U11Z1DERM3Dl9nnp5GboHPl2F7ZTuRIHcSUqdgtkw/zYtgTa60HWZmdsmacY8M/VladdTb
	wi+7QN3Q516/AmT7XFDFhv/xmruf1Fw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cZ0TsiX+;
	spf=pass (imf29.hostedemail.com: domain of rientjes@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785471986;
	b=hRLzA4i+zZMs6l1cMruml7BWxjkhnr4+1HNGlXFfysmkX9sYBuXhDuCO1sWweixWFehG75
	sawrF0UTmbgORJijwFxN64Uc5E6kY03M1nB+AWzXtU21Iuy30J6M8FoZDaUFQY2FMVI0LL
	Rw7vdhRfzaB7w1wQS97c63lRlIxHNCI=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cede6375caso58725ad.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 21:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785471985; x=1786076785; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WYx+7/vOEZAK67zN7a62VWu2wkdimiEvpJwaQveLjY8=;
        b=cZ0TsiX+dYuzxHJhxH2nqSw+csoWoByELuEQyF6hZnVg7qUJGKVlNZWqkczBJY7avB
         GdvOckMtUeU39xjhZ5IcUyAJxIsssB+/r8xPXUIwMm7Is+U5aA79SZUGG8mLGYAyVcNA
         OR978bWz6ZOoj7ofSTqPb38FsW6JuVTX89d5vNTQouPXgJZcen+m7ApYnDWeAQ15okxs
         ytnTL6FP8JNH4U0hoeh7mc9UA19v+WV7h4UomM1CvoMoqjwm0IOvQScnoX0CH+T+WmZY
         zl4tis083S7rUL8pipL2BWTw5L8OX6VW+2liI2HBWFn4qyOvs8/l16hAqCbIKrvX5jtC
         W17w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785471985; x=1786076785;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WYx+7/vOEZAK67zN7a62VWu2wkdimiEvpJwaQveLjY8=;
        b=PO9R92x6nG2oDo9Q8K/KoUG8mwXEIGAghR0eioCef4fEOo91wwI/CzTQAFmKZCa16J
         oaOU5GBfqhaNIsonGGBUtNYHkRAkjE6vMPOwm/LkYAU5KRwprDt39k2om/Y0xTUGs5h/
         uIF8+jV1+sJXmW0LdbghQtQwFpMeQ2X2KZ7+REqVZe8tzm9IKdLETfpgcpUGs03YMM2P
         dKdr4M+SwkSydDR5jdhq2Tmob0qRVOmguiCseoEtOSom7rOewoZupgAGxPaMn/LLF1k0
         xEHFISfo38PmjRB8qfB95VdoAZAWZUo3xhaAqhVxDP5B4PFTuM1lD8Fx48pw3BwmEo2C
         H9Cw==
X-Forwarded-Encrypted: i=1; AHgh+RrXjXOTeHzocda6HoCSh1Y3YZgJ/yH6dNRloxJ34PsjsDIsOgc5PiIVVrOKkxrhTSXB9GdW1pFXYQ==@kvack.org
X-Gm-Message-State: AOJu0YxmyIZ6W4Q+NjPx9pW2b1Erk4qiDFCfo9YnB2yMnsUiS1t+d0up
	d6jR9weknnhPN+s4wdCnibdNph4nfmekYB6RaXyYjhHbVpP2CtyaHj3S0KqYZQ0WLA==
X-Gm-Gg: AR+sD10F0swacNBsLSAGvV10bubb2FBbNHXy/Iey4TsGA8wYZS+D5546XREpoKTM43F
	aM5sjNwx3xyXfETciXHLu22I1O4O7U1xl2nzbq/KM3hqGvBhMmS79OhFXnGkeEbGjjjsuJ+Ro92
	FtIm/nFYDkldr8XMtUGtJyZ5r/22bM+N2GUkv3vX1BpJoDI5ujO+/g643lBDA6UrPmiOosN9CRQ
	/6ClY6SLrm7lW08rx6QmH4di4dZG8so9uzzn2viMRZaDUXFGMB2uooyjAHZwjcykHySSVOPCTxz
	CPDa2NtS+QUsqC17mwHkB//WelSBu2Xxj2yDuIIvyDgEoLx+G2n0sf/TVoWcpfzxUc8dcteML76
	mnL9EcuTudZNpt9v9jeWXYQvzs5/NvNImAWLbOXXqB/XvEYQVI9c0b0GDGxejeWsqKbjLky0t8+
	25kUBy4P0y3jkCqA+g6QRaFweLGok/bw9lT2nvU/4ejplHMTD8GK+k2maz9PcRuB1F6xlb8hG/E
	Vh71tVMmLFcltsPU9N0L7XtNIMcsjzdU+OodAUqO/E8qkbm9EXa4DpbKPFz6HKpcld3ZX5pJE0D
	MMbkx24FQWWC8lrgak8FSxxMdg==
X-Received: by 2002:a17:903:2c0f:b0:2cf:9ec1:ea6e with SMTP id d9443c01a7336-2d046e9a9f7mr1524175ad.8.1785471984911;
        Thu, 30 Jul 2026 21:26:24 -0700 (PDT)
Received: from [2a00:79e0:2eb4:9:a061:9e19:11a8:45b6] ([2a00:79e0:2eb4:9:a061:9e19:11a8:45b6])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84ed57861e8sm207186b3a.8.2026.07.30.21.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 21:26:24 -0700 (PDT)
Date: Thu, 30 Jul 2026 21:26:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@kernel.org>, Christoph Lameter <cl@gentwo.org>
cc: Vlastimil Babka <vbabka@kernel.org>, 
    Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: [patch 1/3] lib: test_vmstat: add synthetic benchmark for vm stats
In-Reply-To: <d6787a7f-3213-2b2c-2de5-af3b02daa21f@google.com>
Message-ID: <e8dd28ab-ea7f-2ccf-c89e-a12f2d8b9988@google.com>
References: <d6787a7f-3213-2b2c-2de5-af3b02daa21f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: A9480120002
X-Rspam-User: 
X-Stat-Signature: 3hkkw5g7u6zaryykqp6z1gox4jmkygch
X-Rspamd-Server: rspam04
X-HE-Tag: 1785471986-75592
X-HE-Meta: U2FsdGVkX18mCEYBJNMgclyxhNlYZHHPYyLTMgvNrxY/I57Rp5xkMSUDzuxtmhTl6y+qXekpTRYYGnN3UrerWFhHFEADD7GLD+OqhhywNZY6EPmPsufc3uq8NMSTPOm02mxea4y++1XRjLWf84kVBooC+0JQYaka/UJh0YRJm8VBaezEETKXa694zEb+jFpXq5tt6FT3QJXBgo9g0YQNmOj35drid40kOXX7YvWQ/eEPFbXVZr7nSIqncbFn4iP7334108Y8fymwNQSxw62pIhfH6AE7b1j1390sy8UTCqPGWC1VMUz70RaQQeDuGNplnhhD+SBXB6tkKHm/HGlsQU12z+fpVXxQJi+mJsVE+NHxYFsnlkzpNQyNesbMzfEquLlhx4Xd8CN9eROSce10dUPTEAZcX8O5aYm5aSFcgVAIl6VNsq2IDW30C8sfI6xTwq3nJ83/ph2PtYS5ZnIW+0Z0/9AMe3cmWgIAIGSaq9Qk0bASbiRmkAVs9qjf5Ip6LlFmYEPx0yFBiKeVJ9mAeosvYyx8DID3ir7Rq2a3gw2jPCYhAvGXAHZ6scxqfrKrjRGrjmtpYljPCpy1ioniJ6ps1kS2oEsO5SEo/maAm1aPjvXxumqGUwO4DPqZZgwtQDtK1Z0adJIG+SnqqR2vQ2r2PXoyAAbbIolIEF+qR4si/sNgXBbmTkKh+TsBbhP7q/1cCDmhBVCi2ezWhHlXNgKKJ6BS4/Da2P8GsgGn3cVUTGvETcG/TNP8tN2D81P3uFtwboutL0MmPMyO+LfZc/qao4nxCmbvriyMv6inQGnuUpwvUF70OWm4AuEhKp0zJBdmirwVwxnkOGZhqw45wKY5pp63QEq3cK/NmTx67vDCYmo9iDgpmGk9+FGVc8k+/5GPxfwdoZ66Zy3APAy2HG5j4eU+lAAmk5n+1vdIzrOidtpvcOgDhsaUVyDLVdPJZoBS/qazL/f1cXR46sF
 t9j+TZA+
 eC/3BRO/CyaZYdSrY/DQMU9zVEPqOhzpJSgEWbCBrLS/G4sPr0WYu4oUEcpo+SQu+o5rRIT3MiBrXbXAVV0foRb7OJFGF0IquwuwzCgtEjawEew1wXsC25Xn4jQXFYh+pZbU0nWfvsO+PXv/O1ZAxmxSa+cVNd1fH1HKZ2gk6dtJwfALnRxurkEuqltyD2hrZkVZUcmdJhk31Midr91w+j7CLa0xW+9BAldcTPzVlXygR4I87ysitQuzLC3gVYTlR+CpBwMZSV+m7WD9+1hmEXhISsnucWcxE7XsRvSAOtGFxBYZTZLmjB6Q5c0qZIP3kgT81QbR743qJ1szpKtr6XKvP7Yg+l6LH2D79sHHGsdQMih43QeRfuVdFA0uu2yuIFLNbkClJgvFjqkEfVxezXh+HI3/DFSsTFGtbfMgsCKhh7kpQ1+P2ZqqXxujCuuPiPywrLUaeohHPuHJzy3GyewOCEw==
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
 lib/Kconfig.debug | 10 +++++
 lib/Makefile      |  1 +
 lib/test_vmstat.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+)
 create mode 100644 lib/test_vmstat.c

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
index 000000000000..f63f439ab9d2
--- /dev/null
+++ b/lib/test_vmstat.c
@@ -0,0 +1,95 @@
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
+		__dec_zone_page_state(page, NR_FREE_CMA_PAGES);
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
+	return -EAGAIN; /* Fail will directly unload the module */
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


