Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F0ED606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=R7QiMtcQ
Received: by kanga.kvack.org (Postfix)
	id 746546B05CD; Tue, 10 Nov 2026 00:02:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5E66B05CE; Tue, 10 Nov 2026 00:02:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 522966B05CF; Tue, 10 Nov 2026 00:02:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2882C6B05CD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:30 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9561716087B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:29 +0000 (UTC)
X-FDA: 85418013618.23.0C083E8
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf15.hostedemail.com (Postfix) with ESMTP id E5537A0003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=R7QiMtcQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3YqXyagkKCNUK1ILEJ18L7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3YqXyagkKCNUK1ILEJ18L7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286948;
	b=v+nWmz4QLMOwi/EG9PwUlvTPFfEV+qYXBVcEWoPCIJdTsRjJYKg1Qo7Syde2evwB8eSLWu
	9IWz/B64iG6tRc0P+i/GqJhdsrzngTAhu0KSA9g/O9JUZ6TnLOk2Gj+Qz6ix7snTmfKEv3
	yXekbzlB+YFbM+n4SVN5ezTZ1pbKD6Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uCmKHaalBs1Mwi3hIIcbxr5U+8imaxCzGUPXqbL7HOI=;
	b=x/bHbGEKZNZph2NhwBNU6INgoz4FWL9KCITvFlHtNGbiw2XnkVJ3cfmtWh1B4tXBlua+79
	g7V2DlrtER6VaqRSpQDo04UgYJ2DnUQusteKDFyW3tAnVJkJYBqt1LexhEe7izyYnpgSMG
	Lrr9ZI3/BBlYZJLSVAjCCjc0l82AeyQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=R7QiMtcQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3YqXyagkKCNUK1ILEJ18L7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3YqXyagkKCNUK1ILEJ18L7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--tarunsahu.bounces.google.com
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b499549f64so1410238a12.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286947; x=1794891747; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uCmKHaalBs1Mwi3hIIcbxr5U+8imaxCzGUPXqbL7HOI=;
        b=R7QiMtcQ+HxB6pITPoTMcLfVW6dqathxOBUOmeGtl8BONqPmbOZAtoD/BWoLpJykAr
         arzb4gncaaLpPRlbwkQCAJ37naRKlSfFJVRDCd2oZ0UubnCpU68IJ+qOrSIQq19lMjfv
         VvkZ1IjMPDedzv6aa3aKDqblbGZnf/iizOYgr2y+UC5fX9uz6gp/FBu0uYyM6JNNQiP/
         GbyZA9t2g9NtapedWSFU4MtAHJzBLLQrYDWDJMsLj+MpkbfqduVtjigDW3apSHuzK0xZ
         lAcV6OGb+Lmn1rgVPy6ge8erIIGFdKQyblYh76TRi1sM5Pgzap3nOcu7UP1p1RkLdIZv
         Y4hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286947; x=1794891747;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uCmKHaalBs1Mwi3hIIcbxr5U+8imaxCzGUPXqbL7HOI=;
        b=v8a4rougWyDQXMlDPLgN7nuLCkq2DAQE7xtkNb38roMmDe/Qidnq07t2xkE4YnvhaN
         jUynnbaKHl205xRkm/qk1ZIm4rMCrJkwDKJsbeXn9vjQqSu+Gte1mbo2/ZfPckOlo7Ni
         LI0nvFkXJGzwevWwXc00WZoOQRm7UO6frHEMyNSKhu6m8dEu6tOKRao12Mgw2JEyrA/D
         ZxKDY2epiKT2gyToQcSmRl9DXxMWdMB8442LYOS+WLyCS2tsIWCd+9LZrF6lbhiEhzlc
         gZdaSlCDwrNsowkE7YXT1wbK4EVnepuAFndeAUElwXGRZrBHOhAoevNUK7GxKVQ2u8yF
         pL0Q==
X-Forwarded-Encrypted: i=1; AL+hErEg2keK5jUYyCnYhCiFC4O7qXd2CX7lZjKbdyXoz8E5HSee+7Av6iC8eDqmeYBTqVWwdXd72+zPtg==@kvack.org
X-Gm-Message-State: APuU4Z8jf/+uLK5GXzYJoOJqHes70gqqr89MlOTKvzgmmDkcvEfMDd6P
	J3JeiHN6UUe49CYt/SqJjpiukKuLtNjd2c36im+8mwbCLw2u86Q7JyfupDUjLXyFvoSO5XE7P4o
	/T9sVZPE2qhBynbbYyA==
X-Received: from ejpc8.prod.google.com ([2002:a17:906:54c8:b0:c3f:c35a:7704])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3d0d:b0:c49:a571:c4f9 with SMTP id a640c23a62f3a-c50494b4c4fmr100815566b.13.1794286946299;
 Mon, 09 Nov 2026 21:02:26 -0800 (PST)
Date: Tue, 10 Nov 2026 05:02:02 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-20-tarunsahu@google.com>
Subject: [PATCH v4 19/19] kho: Add KUnit test for the feature header helpers
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: E5537A0003
X-Rspamd-Server: rspam12
X-Stat-Signature: xu4cjjsxyqsfuqshkc3ubuuq9stt9tpd
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794286947-898602
X-HE-Meta: U2FsdGVkX1/jRJtHaknASeDLH/maV3nIbnEHNZZQLGhJPSkS3I9KblXSBoL88TyAykuBeN5vqWc44uBbnHzUlX6jGFIAIzXQSvYVDiYdFG2FsTPCXYSUbofhBekgK3qhWdlgh1lLLsbpFClj49iJtZx991KpjWf3K70sJuIv+uECsfINcuV23rA7ZV6XFryRz9VB6zha+ZeFrQDbC/lciEbpzeLDyYGwDZ5+owe+woWhoZsQ0KlsD3A/giMP98/ebyfTym/rOCX2bHK7d+blm1JHEnrAcE9TcBfZSwS6XRPRTZgJSESl9K32x0vajDv5rm6z1TzgXQaYa2+5nGCGUX4dlnjTd4MGGxZjwyPCc3z1tzCh4/HqHQaqShtu2LxtQxEqLCC9tcO6oBqM3xtHRPYpXVurTNYpzPl8Rw5M58bxcXnQjmN9UKlN9VrGQdMY9+NjRyBHhFocWXmwNyNp+edGEASCwbv6RysPOlMefH1kppkCwQtcJVOwSeByujQYOUPX0DPxzR/P01XecZJEFvov7M/1+ZheUyJpyah3S3F5tWMowcWNkQvsV2Y/Cg8rvAJfO9dvKkOPdmPApz+RCaAI0MtlsWlwUTEHy7Xh1m9RKgdyhnFswWzzqngAZxjarZyfsVqBKE/24E2OuLMZvOk8NH6Qwt5Km9gghsT/Eo9OwFR9KyXGUt9Y6JhWChAqL45xjMnWMFtDcTP4y13X23s9NId39eo+7Pa//pPfwIRB2QhobZFVgOXswVtC1XASznNLcQ1cwYs6mumdTrsVXTLlQTLGwzaqEMs5YlexI8m7EykY4XWnNd3glgcx8WbWPUvC2QdFRSmV6rl/DP/Ab5GYxnPyeAKCT5GIb0u/pllmdzpddiHFe9Si9anOcS68xYoW5MIUTREnlq60cPxyMUcRrIgLVtEBNpMSRn7uQNwWjZ0RphlIw9N+vw1G1NZDLxG4xnr9m5usxJb4wUX
 BjSLRQWC
 ysnKCU30BehjvMDZA5a78nRABYROJfKodKRNQaScSNynOXptzD5HJKYnzYJeid5rVIGt3FyIbqRE19/QgEZ9pB7f1XNM8e7AlvEpSDb4ACBb9ocJ4QM4Nhjwe8LBpnabjY/EirE6JqCihR41FsZXQrcAMoolHOKOiSXuGt2x1k5Gu9BuIsRAyqNRMtUW7s0k5ii73bMTZgZsFepBGD/qapOMh7p4+yHEovy44PQGwHbw1u2jknRrf++DiDN5dLihV+ycxmJEiS1wgALsiD3vKUCma3AwVPH8d4OMujuTW5O1UOyDVsbO0Ko0uagNdgylAyc5HUyGfT7mWmfvrMz/AR3hTNkI9KoXbJgpRf1Fk4DMZiH2to+SzuxWgoyRq4jIaZ9+kipUwVXiHpQpChxIGJA6adq4txAuci02NUFCbfgM/F3pDw16dw2KAl8CBC9kk/GBOG9fXEyJ9LbhimrE6JDF6ifAJIZHpldlo8VhKSX2dcxXKLX8CWxVk/9FnajMDfxuCKnjQJBlCHu8aYIIonXwO4XEVwA43WdwtSua/nKthvmpuY6gOMxhWlNuwPzXNyF3pLOWL1v5+QNMPqu7/cRTvR00xBc/+PGIViU4HKQyvlx18Zk8IwwZkf7Qxtdjien/OSPKj9z+hQ6ptnZBaa7KqhrjArYMNuL/UO2LEgewaL3cS09fUqEWmVhCTd6pxHT4XJuXILiCxEvsJ+nEufMmtQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a KUnit test suite in lib/tests/kho_feature_kunit.c covering
the Kexec HandOver feature header declared in
include/linux/kho/abi/feature.h.

The suite contains three focused test cases:
- kho_ser_hdr_zero_flags_test: verifies zero-feature header
  initialization, payload sizing, and empty feature queries.
- kho_ser_hdr_set_get_test: verifies DECLARE_KHO_SER structure sizing,
  header initialization, payload pointer resolution, and 1-bit
  feature flag setting and retrieval across flags entry boundaries,
  including out-of-range queries.
- kho_ser_hdr_validate_test: verifies __kho_ser_validate rejecting
  unsupported required feature flags while ignoring optional flags.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 MAINTAINERS                   |   1 +
 lib/Kconfig.debug             |  13 +++
 lib/tests/Makefile            |   1 +
 lib/tests/kho_feature_kunit.c | 184 ++++++++++++++++++++++++++++++++++
 4 files changed, 199 insertions(+)
 create mode 100644 lib/tests/kho_feature_kunit.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 1572f6c905aa..0b50de45140f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14786,6 +14786,7 @@ F:	include/linux/kho/
 F:	include/linux/kho_block.h
 F:	kernel/liveupdate/kexec_handover*
 F:	lib/test_kho.c
+F:	lib/tests/kho_feature_kunit.c
 F:	tools/testing/selftests/kho/
 
 KEYS-ENCRYPTED
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2d22638ec13a..3d74d32b181d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2967,6 +2967,19 @@ config DIMLIB_KUNIT_TEST
 	  For more information on KUnit and unit tests in general please refer
 	  to the KUnit documentation in Documentation/dev-tools/kunit/.
 
+config KHO_FEATURE_KUNIT_TEST
+	tristate "KUnit test for the Kexec HandOver feature header helpers" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This option enables the KUnit test suite for the Kexec HandOver
+	  feature header helpers defined in include/linux/kho/abi/feature.h.
+	  It checks the feature flag encoding, the flags array sizing, the
+	  feature bit helpers, and header validation rules.
+
+	  The helpers are self-contained, so the test does not depend on
+	  CONFIG_KEXEC_HANDOVER and can also run under UML.
+
 	  If unsure, say N.
 
 config CMDLINE_KUNIT_TEST
diff --git a/lib/tests/Makefile b/lib/tests/Makefile
index df0537e1b91f..f22a4552f755 100644
--- a/lib/tests/Makefile
+++ b/lib/tests/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_KFIFO_KUNIT_TEST) += kfifo_kunit.o
 obj-$(CONFIG_TEST_LIST_SORT) += test_list_sort.o
 obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
 obj-$(CONFIG_LIVEUPDATE_TEST) += liveupdate.o
+obj-$(CONFIG_KHO_FEATURE_KUNIT_TEST) += kho_feature_kunit.o
 
 CFLAGS_longest_symbol_kunit.o += $(call cc-disable-warning, missing-prototypes)
 obj-$(CONFIG_LONGEST_SYM_KUNIT_TEST) += longest_symbol_kunit.o
diff --git a/lib/tests/kho_feature_kunit.c b/lib/tests/kho_feature_kunit.c
new file mode 100644
index 000000000000..db36895d53f5
--- /dev/null
+++ b/lib/tests/kho_feature_kunit.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for the Kexec HandOver feature header helpers
+ * in include/linux/kho/abi/feature.h.
+ *
+ * Copyright (c) 2026, Google LLC.
+ * Tarun Sahu <tarunsahu@google.com>
+ */
+
+#include <kunit/test.h>
+#include <linux/kho/abi/feature.h>
+#include <linux/module.h>
+
+struct test_kho_payload {
+	u64 val;
+};
+
+enum test_kho_req_feat {
+	TEST_KHO_REQ_0 = 0,
+	TEST_KHO_REQ_63 = 63,
+	TEST_KHO_REQ_64 = 64,
+	TEST_KHO_REQ_69 = 69,
+	TEST_KHO_NR_REQUIRED = 70,
+};
+
+enum test_kho_opt_feat {
+	TEST_KHO_OPT_0 = 0,
+	TEST_KHO_OPT_63 = 63,
+	TEST_KHO_OPT_64 = 64,
+	TEST_KHO_OPT_69 = 69,
+	TEST_KHO_NR_OPTIONAL = 70,
+};
+
+DECLARE_KHO_SER(test_kho_payload, 8, TEST_KHO_NR_REQUIRED, TEST_KHO_NR_OPTIONAL);
+
+struct test_kho_zero {
+	u64 val;
+};
+
+DECLARE_KHO_SER(test_kho_zero, 8, 0, 0);
+
+static void kho_ser_hdr_zero_flags_test(struct kunit *test)
+{
+	DECLARE_KHO_SER_HDR(test_kho_zero, *fhdr);
+	const DECLARE_KHO_SER_HDR(test_kho_zero, *const_fhdr);
+	u8 buf[kho_ser_size(test_kho_zero)] __aligned(8);
+	struct test_kho_zero *p;
+
+	KUNIT_EXPECT_EQ(test, sizeof(struct kho_ser_hdr), 8UL);
+	KUNIT_EXPECT_EQ(test, sizeof(*fhdr), sizeof(struct kho_ser_hdr));
+	KUNIT_EXPECT_EQ(test, kho_ser_size(test_kho_zero), 16UL);
+
+	fhdr = (void *)buf;
+	kho_ser_init(fhdr, test_kho_zero);
+	KUNIT_EXPECT_EQ(test, fhdr->size, 16U);
+	KUNIT_EXPECT_EQ(test, fhdr->nr_required, 0U);
+	KUNIT_EXPECT_EQ(test, fhdr->nr_optional, 0U);
+	KUNIT_EXPECT_EQ(test, kho_ser_hdr_size(fhdr), 8UL);
+
+	const_fhdr = fhdr;
+	KUNIT_EXPECT_EQ(test, const_fhdr->size, 16U);
+
+	p = kho_ser_payload(fhdr, test_kho_zero);
+	KUNIT_EXPECT_PTR_EQ(test, p, (void *)(buf + 8));
+
+	p = kho_ser_payload(const_fhdr, test_kho_zero);
+	KUNIT_EXPECT_PTR_EQ(test, p, (void *)(buf + 8));
+
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_required(fhdr, 0));
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_optional(fhdr, 0));
+	KUNIT_EXPECT_EQ(test, kho_ser_validate(fhdr, test_kho_zero), 0);
+	KUNIT_EXPECT_EQ(test, kho_ser_validate(const_fhdr, test_kho_zero), 0);
+}
+
+static void kho_ser_hdr_set_get_test(struct kunit *test)
+{
+	DECLARE_KHO_SER_HDR(test_kho_payload, *fhdr);
+	const DECLARE_KHO_SER_HDR(test_kho_payload, *const_fhdr);
+	u8 buf[kho_ser_size(test_kho_payload)] __aligned(8);
+	struct test_kho_payload *p;
+
+	KUNIT_EXPECT_EQ(test, kho_ser_size(test_kho_payload), 40UL);
+
+	fhdr = (void *)buf;
+	kho_ser_init(fhdr, test_kho_payload);
+	KUNIT_EXPECT_EQ(test, fhdr->size, 40U);
+	KUNIT_EXPECT_EQ(test, fhdr->nr_required, 70U);
+	KUNIT_EXPECT_EQ(test, fhdr->nr_optional, 70U);
+	KUNIT_EXPECT_EQ(test, kho_ser_hdr_size(fhdr), 32UL);
+
+	const_fhdr = fhdr;
+	KUNIT_EXPECT_EQ(test, const_fhdr->size, 40U);
+	KUNIT_EXPECT_EQ(test, const_fhdr->nr_required, 70U);
+	KUNIT_EXPECT_EQ(test, const_fhdr->nr_optional, 70U);
+
+	p = kho_ser_payload(fhdr, test_kho_payload);
+	KUNIT_EXPECT_PTR_EQ(test, p, (void *)(buf + 32));
+
+	p = kho_ser_payload(const_fhdr, test_kho_payload);
+	KUNIT_EXPECT_PTR_EQ(test, p, (void *)(buf + 32));
+
+	kho_ser_set_required(fhdr, TEST_KHO_REQ_0);
+	kho_ser_set_required(fhdr, TEST_KHO_REQ_63);
+	kho_ser_set_required(fhdr, TEST_KHO_REQ_64);
+	kho_ser_set_required(fhdr, TEST_KHO_REQ_69);
+
+	KUNIT_EXPECT_TRUE(test, kho_ser_has_required(fhdr, TEST_KHO_REQ_0));
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_required(fhdr, 1));
+	KUNIT_EXPECT_TRUE(test, kho_ser_has_required(fhdr, TEST_KHO_REQ_63));
+	KUNIT_EXPECT_TRUE(test, kho_ser_has_required(fhdr, TEST_KHO_REQ_64));
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_required(fhdr, 65));
+	KUNIT_EXPECT_TRUE(test, kho_ser_has_required(fhdr, TEST_KHO_REQ_69));
+
+	KUNIT_EXPECT_TRUE(test, !!(fhdr->flags[0] & (1ULL << 0)));
+	KUNIT_EXPECT_TRUE(test, !!(fhdr->flags[0] & (1ULL << 63)));
+	KUNIT_EXPECT_TRUE(test, !!(fhdr->flags[1] & (1ULL << 0)));
+	KUNIT_EXPECT_TRUE(test, !!(fhdr->flags[1] & (1ULL << 5)));
+
+	kho_ser_set_optional(fhdr, TEST_KHO_OPT_0);
+	kho_ser_set_optional(fhdr, TEST_KHO_OPT_63);
+	kho_ser_set_optional(fhdr, TEST_KHO_OPT_64);
+	kho_ser_set_optional(fhdr, TEST_KHO_OPT_69);
+
+	KUNIT_EXPECT_TRUE(test, kho_ser_has_optional(fhdr, TEST_KHO_OPT_0));
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_optional(fhdr, 1));
+	KUNIT_EXPECT_TRUE(test, kho_ser_has_optional(fhdr, TEST_KHO_OPT_63));
+	KUNIT_EXPECT_TRUE(test, kho_ser_has_optional(fhdr, TEST_KHO_OPT_64));
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_optional(fhdr, 65));
+	KUNIT_EXPECT_TRUE(test, kho_ser_has_optional(fhdr, TEST_KHO_OPT_69));
+
+	KUNIT_EXPECT_TRUE(test, !!(fhdr->flags[1] & (1ULL << 6)));
+	KUNIT_EXPECT_TRUE(test, !!(fhdr->flags[2] & (1ULL << 5)));
+	KUNIT_EXPECT_TRUE(test, !!(fhdr->flags[2] & (1ULL << 6)));
+	KUNIT_EXPECT_TRUE(test, !!(fhdr->flags[2] & (1ULL << 11)));
+
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_required(fhdr, 70));
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_required(fhdr, 100));
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_optional(fhdr, 70));
+	KUNIT_EXPECT_FALSE(test, kho_ser_has_optional(fhdr, 100));
+}
+
+static void kho_ser_hdr_validate_test(struct kunit *test)
+{
+	u8 buf[sizeof(struct kho_ser_hdr) + sizeof(u64) * 2] __aligned(8);
+	struct kho_ser_hdr *fhdr = (void *)buf;
+
+	__kho_ser_init(fhdr, 0, 4, 10);
+	KUNIT_EXPECT_EQ(test, __kho_ser_validate(fhdr, 4), 0);
+	KUNIT_EXPECT_EQ(test, __kho_ser_validate(fhdr, 2), 0);
+
+	kho_ser_set_optional(fhdr, 0);
+	kho_ser_set_optional(fhdr, 9);
+	KUNIT_EXPECT_EQ(test, __kho_ser_validate(fhdr, 2), 0);
+
+	kho_ser_set_required(fhdr, 0);
+	kho_ser_set_required(fhdr, 1);
+	KUNIT_EXPECT_EQ(test, __kho_ser_validate(fhdr, 2), 0);
+
+	kho_ser_set_required(fhdr, 2);
+	KUNIT_EXPECT_EQ(test, __kho_ser_validate(fhdr, 2), -EOPNOTSUPP);
+
+	kho_ser_clear_required(fhdr, 2);
+	KUNIT_EXPECT_EQ(test, __kho_ser_validate(fhdr, 2), 0);
+
+	kho_ser_set_required(fhdr, 3);
+	KUNIT_EXPECT_EQ(test, __kho_ser_validate(fhdr, 2), -EOPNOTSUPP);
+}
+
+static struct kunit_case kho_feature_test_cases[] = {
+	KUNIT_CASE(kho_ser_hdr_zero_flags_test),
+	KUNIT_CASE(kho_ser_hdr_set_get_test),
+	KUNIT_CASE(kho_ser_hdr_validate_test),
+	{}
+};
+
+static struct kunit_suite kho_feature_test_suite = {
+	.name = "kho_feature",
+	.test_cases = kho_feature_test_cases,
+};
+
+kunit_test_suite(kho_feature_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests for the Kexec HandOver feature header helpers");
+MODULE_LICENSE("GPL");
-- 
2.56.0.506.g506a7eabc5-goog


