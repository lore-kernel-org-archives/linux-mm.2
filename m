Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88A02CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 19:51:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D75236B0092; Tue, 12 May 2026 15:51:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4D286B0093; Tue, 12 May 2026 15:51:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEDE66B0095; Tue, 12 May 2026 15:51:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB3F36B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 15:51:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7DB511A059E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:51:41 +0000 (UTC)
X-FDA: 84759812802.15.722B1FF
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9E5F01A000D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 19:51:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ujT9swfp;
	spf=pass (imf19.hostedemail.com: domain of 3yoQDaggKCDknfcVrVeVbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--skhawaja.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3yoQDaggKCDknfcVrVeVbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778615499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v7TVTYRDvcEKHxiAe879U7fECAlukFuq2rcibnBNqK4=;
	b=bgvnAtn/F5DFTwiASkf2yHVGAegWxhV8kXREVSm4b+ssRq736zDYGOgxbm5t5ystFqLTNB
	NMJHtbmTF+NJ3IeZ9yg9eOz3ALLHAiALJ2OzMvF/gD7QCVXd3afPT8f3kcrK3TEby5t4Un
	J5iWTrlF0ME/QdtfiMJqCthLQe9UEnI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ujT9swfp;
	spf=pass (imf19.hostedemail.com: domain of 3yoQDaggKCDknfcVrVeVbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--skhawaja.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3yoQDaggKCDknfcVrVeVbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--skhawaja.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778615499; a=rsa-sha256;
	cv=none;
	b=3lIfDPolk5waFkNCZd3CxiQUxvoTIPY19z5qEHBYLs1GRYYbQb5AG88Xq1Avaz6HU/3avd
	Lj/lpo5tpAOi3WtKUB8Rrcl7OaGrTgamACcb+dGsdjdAwUP6EfElgaxEuzzrmIBrDbCMFX
	2+Oo5/QF1OCHowSC8Qdm8SJuWHZJf5c=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c82894155ceso3314688a12.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 12:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778615498; x=1779220298; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v7TVTYRDvcEKHxiAe879U7fECAlukFuq2rcibnBNqK4=;
        b=ujT9swfpZUBa5U6wOx0wn/qlyTp4FjKq8syNhDQcvecvySEjpR7SuHfmLgvOUpbsnP
         5yG9v22EVtrBhjzOwrnPU5N7ATaGlztcjzHYx74o2F2mwNcwMQCKPaRAcVfYB2eXTgtj
         HDAqPzgSXBdEZmYyMgsX1z+28LMrgf946CR8fm6fYtHpRt3XJxQl+zSkn4ZPWgu95Zw7
         TlKe1Zs/761TQa+JtdhWxTGZg7wSR+frBF2R8rgsds5X5Yqk/f62+Uvv/of8UCktZIFi
         qRA7omZnHn1LTh9TVXBEehJVLj0SMJlqeu/YCwydSENPgFNADGjv71MagXc4iDSfzOuu
         oN/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778615498; x=1779220298;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v7TVTYRDvcEKHxiAe879U7fECAlukFuq2rcibnBNqK4=;
        b=gwJx4PuhucSGWeJD8odOijQ3lnAtqEpQ2J7f1DHlV0BM8L+QmCJK/xBCjJ2yfCyEFm
         qnpgzfTrWQN2oA0B4Bdeio916PqGAXidcefx7RnPCYkGDlTiKjKP3m7DO79INWEeM6Gg
         MYsR1OcfpFek8LKqj8HD+JLSNkunbXEJ08MewWJbadNR+FFWILc3JuNzzdIx6J9yHYEA
         9LWOS3a2l6vD84S4fDV1v/vXxYjRxwDivAHf0CVLPFe92xbM0EXrhHuw7HbI4nvonzaP
         4KwE3z3ZXSYrq0OrvmzSzjx/XaRz3CPIyjjJ1scna5CWO1uzE4kLe6IMZqdkyuGqdQHK
         b9PA==
X-Forwarded-Encrypted: i=1; AFNElJ9Eh79A1QLUte/Lbn1G2C5LKj76D+ADZN49SclUFBq2hI5QS+K6gT1BOi4YK/cvcNVy/4PY9zUM/g==@kvack.org
X-Gm-Message-State: AOJu0Ywh2q+plVuV8yZvAz+bYpo2pwDYeBZvdnNd4yovcAnMxvAOJBcf
	d9mWzaunU9tWKvrleKwZyobHFYSXXHtocvO1gkfPXao70zQJ1AfGq2m1hZkBZHMYBwRJrnKN0fj
	4+2Q8ZgbrNOI/kQ==
X-Received: from pfbcg6.prod.google.com ([2002:a05:6a00:2906:b0:836:ed4a:203f])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:298f:b0:82f:390a:69c7 with SMTP id d2e1a72fcca58-83f0429e3c3mr90865b3a.33.1778615498220;
 Tue, 12 May 2026 12:51:38 -0700 (PDT)
Date: Tue, 12 May 2026 19:51:35 +0000
In-Reply-To: <20260512195135.804833-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260512195135.804833-1-skhawaja@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260512195135.804833-4-skhawaja@google.com>
Subject: [PATCH 3/3] kho: Add kunit test to verify preserve/restore pages and folio
From: Samiullah Khawaja <skhawaja@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, David Matlack <dmatlack@google.com>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:KEXEC HANDOVER (KHO)" <kexec@lists.infradead.org>, 
	"open list:KEXEC HANDOVER (KHO)" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9E5F01A000D
X-Rspam-User: 
X-Stat-Signature: fajtsxhqd9xg5ih6q76wdy53g6euyw9b
X-HE-Tag: 1778615499-395481
X-HE-Meta: U2FsdGVkX1+gRvim9Qrwb7H8wz8Jx9n/a9j86RWuViyFtfS6miFESDvf34u8FEMtkGco/dgVjoIcANwOYN6Kjq7PkcJxNptAwRJAvnr03Kf8ab10hsQidQAkKeG9f7GJr6sTU74BNLloj1PhSxFiZRzFYKr83XUxtNvI7t+kg96dxbCdDW0mFX7Uye6ijHeUNMUDpU0RrqZeQxFPGJh0fuhrbA0do1hN9wQKAjYfIoB5GSsy1WRiorX6FDNPfhgWm83m6ZObwrzs/IgONsUv1SnTrM9sUO/MYHGjNewaVvbC20f4dM7mji6CsAswwLE4fCshi9AVCb5pJCX9UQanP6oO5BLNz2XvEb+AHekLpn+Y5GHDqlCkNPqXRWWdxuKMyoayCuPAn5wazx+IrZCZ/44FobkWocCMBAKH+JfeGD38vZzU5Rs9iBajp6ALl2rWI76VKJYegN7We+r3F7tFSnrlRym15zjO8dpJGmmQYpteK/8OqRUTdT8BdFxmxLS0V84bbVyJdq+QIQWWPXD1TXtbNPSZsDMl/6rMrtKFQIvItsqcaEp0Ob0hZ80sKyoPG0HNRbM69C9+bNrLGYLIpOTG4ab0hOwLGXem2aKGDgCL4DEslpwYuvXI6TMEHhrLaW/ZUkXi9lAQxCyoERQMlVw3ky5+WQqsKEp3dKpjKUqnsFb8pV1oEmQkD/PjK+eK88onYvqmiwZyq4Z5lW9W4xH3zRjEblKsst4WwSRmMdLGQtW37a28nHNEZhpNQ6oPV+/4nahDwHydzVDkrRkzAJbO44ZqQvbWq1WJzNsS2ojUkOppTTAC19d2x8gmXwnAoLnNE2lMIfDGlStr3qaCirMFdx6Rn0UgW1ryzCuW0eTJ/ETE7n5c2D0ZyfWInosHyY14+4m5po5E9/NI+PhJeNwE0YQg0PEld1vlv4jSVsYnPge7ZRPqQvQrpL7qHnCN1pODU/9Lt5/m4d4H+CI
 kwH2UEYf
 4eWsUkqSQYqNqzpo/U/GCmqNqMeJ9hkKq11hZHqxPNfA29ryWFLRKELEFy5IWN2aWx+Wv6woQyG7rmCBpur/6RZn+oAtDRfGXX/Ho4BDq1SuwiRAvKwJHDJ79e7+/gHUTL/zFzPwhj2LRtmM5oHrMLpu43h+ahfmsEtOuqGgSbyjuD+GASDbR2sVySYXVFzazz+gHYR9JmIbdQeW5jQPfYSNsA1LhukN68RlqQ79KzJEalClLRHiM+AE1xbkIDJ2+HzQFbaXWDZqhJhvLq0O/YClpgzvuVjfR11bbkQ5CM8qWQaieJiQNs0OTnY0PUtS9HFvT/he7w5mVdLQIx6UKrBHl5IM8EN1d6Kq8QEdDMCfU5VrMYCKf3VLF8jTFPT6IvNT746XW5JwBz8f/v0ASKbLA/RZ3eiBzjt00NQtuX7O3eFCTmOjywGuxUO/UdR3WAzoLPq8mgGKc8SirlFHAiufWUurjELz0P1OFa6Je34chbpyS7Xgn5iQQdgZPFADzQsYFJyCc5AmZRJYEkpyxf/YYlUkrHaDuocHYwSNnfquqX/7CMQqvqweCDg==
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
 kernel/liveupdate/kexec_handover_test.c | 130 ++++++++++++++++++++++++
 3 files changed, 141 insertions(+)
 create mode 100644 kernel/liveupdate/kexec_handover_test.c

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index c13af38ba23a..ffdfdc4080ef 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -49,6 +49,16 @@ config KEXEC_HANDOVER_ENABLE_DEFAULT
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
index 000000000000..1113007f9ac5
--- /dev/null
+++ b/kernel/liveupdate/kexec_handover_test.c
@@ -0,0 +1,130 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026, Google LLC
+ * Author: Samiullah Khawaja <skhawaja@google.com>
+ */
+
+#include <kunit/test.h>
+#include <kunit/static_stub.h>
+#include <linux/kexec_handover.h>
+#include <linux/gfp.h>
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
2.54.0.563.g4f69b47b94-goog


