Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 181DBCD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 19:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 581CB6B0093; Thu, 21 May 2026 15:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 520E06B0095; Thu, 21 May 2026 15:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 391266B0096; Thu, 21 May 2026 15:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1FC276B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:32:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B895F40722
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:32:08 +0000 (UTC)
X-FDA: 84792422736.14.28BA7A9
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf05.hostedemail.com (Postfix) with ESMTP id D83CB100013
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:32:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gaXjFwPw;
	spf=pass (imf05.hostedemail.com: domain of 3tV0PaggKCAYyqng2gpgmuumrk.iusrot03-ssq1giq.uxm@flex--skhawaja.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3tV0PaggKCAYyqng2gpgmuumrk.iusrot03-ssq1giq.uxm@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779391926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ncOCeCfKsOq2argSmTVmNq9obkxAz4X3VwJeLEeWDgg=;
	b=wRRIbGsdLHTmgNyZnjH4OfZ12wU8YiQWlI9iH10EvUsZ6/rSaKPZocii2tWPOltC4oC/YF
	pNNktBkyztQR9zQ/V5KxXdthzEdUC6JCDUaYt8IuAiXu0lQT+CPdNFdh0vnfvGa+YXgGgu
	4A5E3IEHGqlcJy6WfYImMEa55+5JxjA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gaXjFwPw;
	spf=pass (imf05.hostedemail.com: domain of 3tV0PaggKCAYyqng2gpgmuumrk.iusrot03-ssq1giq.uxm@flex--skhawaja.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3tV0PaggKCAYyqng2gpgmuumrk.iusrot03-ssq1giq.uxm@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779391926; a=rsa-sha256;
	cv=none;
	b=hn4tAEeMp2yITbR1xse1BEkIM7UZwgUZdL0gzk6RcG5r5b9l4mUea5o22j1UWRjffoYRHF
	+TDVqOylEAQsQ3UsQrXY6yhrS0hFHKF2g54Ppetmpm+wm7/X16TCXZgdTCvTokHnDdjTam
	OvgMUWuGInRS71AZGkIhmgYUShadl2I=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82fa1c94b37so6992252b3a.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 12:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779391926; x=1779996726; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ncOCeCfKsOq2argSmTVmNq9obkxAz4X3VwJeLEeWDgg=;
        b=gaXjFwPwccJ1y//cgj7fELKIaJf0KYT0sG9TO13C2l6HRz1uDIotnn9VRrh210bhoh
         qTWF9FBHse0309f2ZpzqLNzB+MC1npggDmCxbYFcXgy18VLRFvZ2+0SQ6B2Nzq90Mk1w
         298EECn3+upOzs2e1OBy4UY5bvHGFNUij9a4o0ON/Tpd2x0fBCikv5s/jl9PiYNfBpiR
         loX/FvgVc2oZpcD3KXcMS/jhJsOF2led28A+YwDL81unIbKfRyE5OyWCHyWGxGAt6er1
         Fsps9me/xnh/cQ4dFO+/7C3ao3sy2QH2wdRi34mSRX+EoDjfwtcn+9On3Vvr9cpaTnKR
         Eeog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779391926; x=1779996726;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ncOCeCfKsOq2argSmTVmNq9obkxAz4X3VwJeLEeWDgg=;
        b=JiVrNO3iC7BJqklL9tJK8Xrj58EHpoj9EPHmFyLJVYZDd0JjnbQ5aCcmVCI6kDC9lE
         AEl0v/8V9i9cHP+R/UfqUBKfrAEirQBINg5QZzSXbS/GV2QRrHKNeLIKhZKOHzGyxPE5
         WAcca0xych+jlBQfivtIyvIJcpGI/S69LV3faF8T1IXnWLIhX+BCZMSzIbTS8zQccmns
         VIvk30bsGveIH9xktGYg+AgYNxsaqRVheXutQIBRuUI9TyH1sF3VWgoMJqdIrbv3cOYJ
         LCvOfJoaTcBXYe63yPQOhA+yf7L5D0qIX/kbEGMPvWMNhJ6m9/MOu23/AlAZKZ7siDUY
         OwkA==
X-Forwarded-Encrypted: i=1; AFNElJ/Af8OCTVz634/Sw0ZNKelP0W1uaOw97LboLp2iIFktqrWvasFJjnjFcFaE3AYsj2vrif59E2Cacg==@kvack.org
X-Gm-Message-State: AOJu0YxXnAx7YMziIXpf03IMSoS6uk2Q7wnHiSRvQVOKh4QvBFarp+4w
	jU4voN4Wa7P5GXcW78Coe4lsLXJPpiE/4Ne2qYeRF9R8Sr6vHz2vvliMbHZSvesa2JG8u7xyvdh
	qiR2EbI7vpO9xFg==
X-Received: from pfll21.prod.google.com ([2002:a05:6a00:1595:b0:82f:93e5:c64c])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:847:b0:82c:7420:82bf with SMTP id d2e1a72fcca58-84161176bddmr117690b3a.19.1779391925396;
 Thu, 21 May 2026 12:32:05 -0700 (PDT)
Date: Thu, 21 May 2026 19:32:02 +0000
In-Reply-To: <20260521193202.746810-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260521193202.746810-1-skhawaja@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521193202.746810-4-skhawaja@google.com>
Subject: [PATCH v2 3/3] kho: Add kunit test to verify preserve/restore pages
 and folio
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: i9pfpgtethk731tkmresk99344dtfnxs
X-Rspamd-Queue-Id: D83CB100013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779391926-333083
X-HE-Meta: U2FsdGVkX19FLg064m6HPoFsiyGZ/huSIU3aT2ibEsJu5WDbe7cokPj5udpc56djsopbN3vY8PPbWLTFI/yeHViLzhifVxwq8lLaALZxUqqjJ9GHdn36ti/z1jO4Y8hLqangK9k3pDWabfyoxjJQuAf51OJaJCybhKHS9AT3164jquAICwGOe3fb7RPndxecZzB3sWTCW0Nsq+CZZCv8Wa0r/1QV5RdYPNUH3hJFNLsmqebfCIgBfywODFqYPLX043ENvAntKXteN2UBqv2XHKMWotRQ2qvyUA4kAgDKqOyPlZBC6V29C3XSftisWg/Q2UEVctDUv7q2OAMUjY1W11pF3MLgTnIL6rxgqaL6lP8x06RkCJgrpO6pz+g5Z7eHV8VLvFOME8Bmgj4w/ZjYoRcU/sETFpegwjpq0wa4KYjUy/+7Z2tE8V13J8b6nAAOV/EUV7rKkBLyoK50oOej0bL0RpSV2TTIrl8I3d1znb4bOmTzrdQIZ2tYSSkQTPkMHwHZsgvmDDFuSLw1nef1PV8P4P8NbjDIiy1I+oABzOHVEqduICeIqC2treZHqPYgtjouUApdtnUMN+iIr+JapyNfdJy/Ge556JC1ok9VYrJlxvlYU/v/ejYJ+tkIHVyg4l4lQpL++R2+17DLkjbY3hwsYOSfiNeq1PmwJl5OVNtoNAGQW//79IBRAiwMLgYwAzRKBdoOiJUlKv8JbHXbMydZ28gS9ljRZZmQbuw3W0vr5N0zx6fOIJsc5nWMQJ5O4wgfdi5nJOIQ4WkDATgV+WMTFjqBmLdVpyC8+WQHN4iT8i1+lUvRzt3Ta1UPBoZ+41IaNg6f4wtYzd/r4sQ/T7aFIbTvS8K4abbkL5qy9LQymHtMitYMYorq7RFpU58ohAaWiFxMCyKtU1Z58m/UZpz3jI7oaxJDPeZZztQr65InVnQ0AGOODX2ZSMixi20geGsvn2UeGhDmY8uSmSv
 jKdfc2mG
 Qgj/VuODPWggcQ4RjCWb5ezAl9PUhuqcdDG9ghyCk5SOnpMNrcECq7gYG89GXcKDvJlN585qD66fM1j67ioomD/2pXNHVi+TeG0UFyAAOHQsKMHjEVjb+GuQ+kIQwZngLBuQ80dBM4qfLmNbbWl/zSKCbgZiL1ktNS7LvNohOXChOmHGLdKxck3AlaMpHKaNZ6VxEKY8SuGrRkCOprArCM68tgVxMoOTeaMJsT5yswxMLFH2bGsttFQrkWx1UvdiceS6RYGcgP/WdD772HvnX9XVWqSDEw1SkKi23mxuI0EpWqsqTsNKsyP4rvu/UNc5gl9zilkkqCvrDlusfNgt+OqyOQv0vtyQgyd6XZWH+5hV4AkroF+l2TjeL9UOs/80jZfk2GtxT+GGUh051a34LutVE+6DHlGpuYLWeLUojdZZ/g0XTLuzWhzeUcc11McUDKZf/aGDa8UuIxH5/jAnDP1NAdl9XxzDKnivD6vVBsq6yBVX3b0OUi366g+tsl1Mrsr0Ki68F19b+A8n6epqiEydmroKlIItR97AgI8amBuGxEOet9Cyo7iMgAED3rg1/iuCX+cVr+GUavM+6P89/pYDg/DmBlDj3kL2n0avPTOAtSrtxMGw3QoVbL9SsMEVhk/tZmsa6VBpmeZI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a kunit test to verify the preserve/unpreserve and restore of pages
and folios by mocking the kho kunit restore stubs.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 kernel/liveupdate/Kconfig               |  10 ++
 kernel/liveupdate/Makefile              |   1 +
 kernel/liveupdate/kexec_handover_test.c | 131 ++++++++++++++++++++++++
 3 files changed, 142 insertions(+)
 create mode 100644 kernel/liveupdate/kexec_handover_test.c

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index 1a8513f16ef7..d2623f60c0dd 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -51,6 +51,16 @@ config KEXEC_HANDOVER_ENABLE_DEFAULT
 	  The default behavior can still be overridden at boot time by
 	  passing 'kho=off'.
 
+config KEXEC_HANDOVER_KUNIT_TEST
+	tristate "KUnit test for Kexec Handover (KHO)"
+	depends on KEXEC_HANDOVER && KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Enable Kunit tests for Kexec Handover to verify preservation and
+	  unpreservation of memory using KHO API without triggering kexec.
+
+	  If unsure, say N.
+
 config LIVEUPDATE
 	bool "Live Update Orchestrator"
 	depends on KEXEC_HANDOVER
diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index d2f779cbe279..ed798b2401a8 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -9,5 +9,6 @@ luo-y :=								\
 obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
+obj-$(CONFIG_KEXEC_HANDOVER_KUNIT_TEST) += kexec_handover_test.o
 
 obj-$(CONFIG_LIVEUPDATE)		+= luo.o
diff --git a/kernel/liveupdate/kexec_handover_test.c b/kernel/liveupdate/kexec_handover_test.c
new file mode 100644
index 000000000000..9e6dca45c3f3
--- /dev/null
+++ b/kernel/liveupdate/kexec_handover_test.c
@@ -0,0 +1,131 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026, Google LLC
+ * Author: Samiullah Khawaja <skhawaja@google.com>
+ */
+
+#include <kunit/test.h>
+#include <kunit/static_stub.h>
+
+#include <linux/gfp.h>
+#include <linux/kexec_handover.h>
+#include <linux/mm.h>
+
+static struct page *kho_test_restore_pages_mock(phys_addr_t phys,
+						unsigned long nr_pages)
+{
+	struct page *page = phys_to_page(phys);
+
+	if (!kho_test_pages_preserved(phys, nr_pages))
+		return NULL;
+
+	kho_unpreserve_pages(page, nr_pages);
+	return page;
+}
+
+static struct folio *kho_test_restore_folio_mock(phys_addr_t phys)
+{
+	struct folio *folio = page_folio(phys_to_page(phys));
+
+	if (!kho_test_pages_preserved(phys, (1 << folio_order(folio))))
+		return NULL;
+
+	kho_unpreserve_folio(folio);
+	return folio;
+}
+
+static int kho_test_init(struct kunit *test)
+{
+	kunit_activate_static_stub(test, kho_restore_pages,
+				   kho_test_restore_pages_mock);
+	kunit_activate_static_stub(test, kho_restore_folio,
+				   kho_test_restore_folio_mock);
+	return 0;
+}
+
+static void kho_test_alloc_preserve(struct kunit *test)
+{
+	void *mem;
+
+	mem = kho_alloc_preserve(PAGE_SIZE);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, mem);
+
+	/* Verify if memory is preserved */
+	KUNIT_EXPECT_TRUE(test, kho_test_pages_preserved(__pa(mem), 1));
+
+	kho_restore_free(mem);
+
+	/* Memory should be unpreserved after restore_free */
+	KUNIT_EXPECT_FALSE(test, kho_test_pages_preserved(__pa(mem), 1));
+}
+
+static void kho_test_preserve_pages(struct kunit *test)
+{
+	struct page *restored;
+	struct page *page;
+	int err;
+
+	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, 1);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+
+	/* Preserve and verify that pages are preserved */
+	err = kho_preserve_pages(page, 2);
+	KUNIT_EXPECT_EQ(test, err, 0);
+	KUNIT_EXPECT_TRUE(test,
+			  kho_test_pages_preserved(page_to_phys(page), 2));
+
+	restored = kho_restore_pages(page_to_phys(page), 2);
+	KUNIT_EXPECT_NOT_NULL(test, restored);
+	KUNIT_EXPECT_PTR_EQ(test, restored, page);
+
+	/* Verify that the pages are not preserved */
+	KUNIT_EXPECT_FALSE(test, kho_test_pages_preserved(page_to_phys(page), 2));
+
+	__free_pages(page, 1);
+}
+
+static void kho_test_preserve_folio(struct kunit *test)
+{
+	struct folio *restored;
+	unsigned long nr_pages;
+	struct folio *folio;
+	int err;
+
+	folio = folio_alloc(GFP_KERNEL | __GFP_ZERO, 1);
+	KUNIT_ASSERT_NOT_NULL(test, folio);
+
+	nr_pages = 1 << folio_order(folio);
+
+	/* Preserve and verify that folio is preserved */
+	err = kho_preserve_folio(folio);
+	KUNIT_EXPECT_EQ(test, err, 0);
+	KUNIT_EXPECT_TRUE(test, kho_test_pages_preserved(PFN_PHYS(folio_pfn(folio)), nr_pages));
+
+	restored = kho_restore_folio(PFN_PHYS(folio_pfn(folio)));
+	KUNIT_EXPECT_NOT_NULL(test, restored);
+	KUNIT_EXPECT_PTR_EQ(test, restored, folio);
+
+	/* Verify that the folio is not preserved */
+	KUNIT_EXPECT_FALSE(test, kho_test_pages_preserved(PFN_PHYS(folio_pfn(folio)), nr_pages));
+
+	folio_put(folio);
+}
+
+static struct kunit_case kho_test_cases[] = {
+	KUNIT_CASE(kho_test_alloc_preserve),
+	KUNIT_CASE(kho_test_preserve_pages),
+	KUNIT_CASE(kho_test_preserve_folio),
+	{}
+};
+
+static struct kunit_suite kho_test_suite = {
+	.name = "kho_test",
+	.init = kho_test_init,
+	.test_cases = kho_test_cases,
+};
+
+kunit_test_suite(kho_test_suite);
+
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+MODULE_DESCRIPTION("KUnit tests for Kexec Handover");
+MODULE_LICENSE("GPL");
-- 
2.54.0.746.g67dd491aae-goog


