Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4F0ACAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3C628E0021; Wed, 24 Sep 2025 11:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEED48E001E; Wed, 24 Sep 2025 11:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACA4F8E0021; Wed, 24 Sep 2025 11:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 979BF8E001E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 594CB5B83E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:33 +0000 (UTC)
X-FDA: 83924455146.09.33D8FFF
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5E64A40022
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kRFTbo7y;
	spf=pass (imf04.hostedemail.com: domain of 3jQfUaAgKCDofWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3jQfUaAgKCDofWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5L6wwf2TI57XEfLhcaZXMRQ+L/0zQiVmk9x1OVnFFiI=;
	b=lymYyrKaJmWklHbZd3/bRMzKpBwfaAGP9OaIVAXWWH1GYEswIW5UhtUhDfULzhHyqER834
	uwPkY6Wd7l5BReySrSYLkBVqTmS/32c59Vz0lAxmOI90Wu75//8kaybscCJQhpAP4TvMy3
	ASOCACHip332yWLET2RYJVEWM9aRTHU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726031; a=rsa-sha256;
	cv=none;
	b=1Wci+PtKW2ajag5wEvRaVPulDnEw3h2u63j6ttAW4+Q+ZHjjP16+xIGQilxYnrbqbvInwT
	8o/9Gj6H+EDDwvzFNf2u2x+PkUETJ8ev2uBWLgTcZPgYRR37GgFZ+JsoBE4bi3wFFhf19g
	p7YaBXi3eIWDUpZMh2vfAOUlV9/rnPw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kRFTbo7y;
	spf=pass (imf04.hostedemail.com: domain of 3jQfUaAgKCDofWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3jQfUaAgKCDofWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6349af0e766so124909a12.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726030; x=1759330830; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5L6wwf2TI57XEfLhcaZXMRQ+L/0zQiVmk9x1OVnFFiI=;
        b=kRFTbo7y3qd0RZFYMBx373PKbYziiaA7FGW3sOW8vhqpfuUm60N/qV4NLRoZqWXagC
         GYpW8I9PaCcMSrpy1Cpeh4sP2XU3zf1QSyB1/sz5qYOM0slt+1BY0fKof2tacxOrSSBx
         wmB12uu3Ac9IQ6r7r62bBbRdVFhB0irGLFDeZUmMfjGEWhML9mSPtW6W+YdcnOTyUbGC
         KOzH922pyS8Hu7rzUHuIH/WRN6M+hjVZLZCGIAoF8vQ40WdpzKzYr3d+83qq9KFJqecY
         MKSDSVmfLdX2iQ1oHeaibHeiwtRU3WE9emRqSq/P59c012CeIp7iLVEmXv8UxvKnSDvy
         yKxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726030; x=1759330830;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5L6wwf2TI57XEfLhcaZXMRQ+L/0zQiVmk9x1OVnFFiI=;
        b=JdMICa6AZ0ijG1/fh/Nk3dsrxMdEm+hEmwkn1B/exdgJPfvWH4moBX8PuzkjHn+1oW
         3d0pbXV6CG7B4X64wScc++Jk2eNWGHHLb4Uc0eE+hUhoiE3XsydNiMSIrUN1HxIVAqQG
         HvCMLusZBMC4TvQoY92mvAQt9946b0+HUoE0UP2c67gqwVw7vebd+fKZod5eeTHNdgTW
         8xNWwVylVw1L81awS514+L6czv+3d8OovM4s14siBJNTQhOEjrNr/gUAqbAFqcvjY++M
         +yyB/3SZ7wFhzD9466EKXp8mCFZctYFzDjZN0O89yt0zcW4e3ChQJfFpKBWYX9NcNAT7
         Rn+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXbPt82vYfSH8l07OS5tTGgOYVs1gnO7hfKVW9SeeE08CwEoZEyhn2B+ZNG4c+j9YavZZ7B9qRVVQ==@kvack.org
X-Gm-Message-State: AOJu0YzpBPzy6QdQ7xg0tAk8/6ELUWM7Bi0D/HkLDEn35akucokMcSBU
	EfPlVA12QXbMPrJuNWvM7TlLPTAo4bVLHwc2U0JfoY2RDpu7QmBwTX24mVHZ0l8myb49kbhYLbC
	dG5yaR88RAYALlw==
X-Google-Smtp-Source: AGHT+IHyYgPrnvJDNnriMm16XcgI4Z+GtksLauuH+Ta7oWXXcU6rl19T9F/meDi87vNPoKDDvgmVTSxx+6DjQQ==
X-Received: from eddp6.prod.google.com ([2002:a05:6402:46c6:b0:634:824b:21e0])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:1ecd:b0:634:66c8:9e7d with SMTP id 4fb4d7f45d1cf-63467a209bbmr6324885a12.36.1758726029633;
 Wed, 24 Sep 2025 08:00:29 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:56 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-21-2d861768041f@google.com>
Subject: [PATCH 21/21] mm: asi_test: smoke test for [non]sensitive page allocs
From: Brendan Jackman <jackmanb@google.com>
To: jackmanb@google.com, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org, 
	david@redhat.com, derkling@google.com, junaids@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com, 
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 5E64A40022
X-Stat-Signature: es6tj1fj4k9ybptwpjpu1jtt3d8htorb
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758726031-426987
X-HE-Meta: U2FsdGVkX1+CaBO6W8G5UkVa+ku/pvqEhunhJQOHPm+odwCMRrp3/3DLz+2QKuS16NppkF42ypI3e6KnECi/4Rciv9oonMikrESDQAhFhjGBxBM2IHuwBU7Ieyt0SeFUpdx9Nw6F5gA09xn7loJvycA1OPRlJM+j3mCBmuT8Cc0TVCDqlpe2AsZ2zodajLNlbmDZeFP6Rtn5bKrLEjieLXMOPcCNA8zLrWqRFH6lIBTLVPWn0EoM5QyQNs2fyFbKupGexvv5Wsx2V99SiHurBGBcg8QjU9BItX6YCbe9ux+FlRl95cp9XrA6Y49V4JDdRfskGviLOHuXMx/x3Yv5egJWWMhVVFxfPuISdByc//eVVqPDZNnP1Z/i5FM2PxnZRyNbMnEzjhgl6BGO1X8hnGwt3nlc07oogfNNcfAMmg3ELj1Li8y1HU1WCVGGVPGGzkGVHXscElPJN4S5rvbdjGoJ9brIIK9ydES9w8llgmkOm6G1RD3xjitlVWgKf/VcFAg7sB63yZjX500wI1CRfcnY53LjN+OWfO2lYuLZxVGtENkoNo+4A1/kCV99LjSdyOU+qjO1mqfLhGI0GXe2q3HCx2HeH83HX9sawhupAuQ0Sy8jD8tV0HvOx3Bs6hOASMP4evqnKiGym2nskab5CmfV8BWVPGGgU/6rb71FWsEeHirD90kWUKtY7YcyMsJ3XlDPFohavaAmGujp9u+LxLrZ/NDB9jX9uN/JEaFmd3HEaNCeqXfAgy/M3mKzy1+GDzLVtELsGHAGS+o7Ua6JfcChagCE1wWt64byMR5erwJ1DuUFRaOytI1gJLji4eYMO5FR2ZEyA8cUBLDqyD8kGBC7j0qCsMXM77mlI/t1wBqSs42KPXJtcfYg0py/ec4YishJn+GlKUeaJ/ARUooNCCFYuh511OhhGCtNYhVEMsoFIwpqxbm9D0eag8EePSaoW7YfZFhDS8eJK00V1ny
 cJr39J3Y
 +mmKauqTsqhqX48Xw/5kvE8qz6jgHtCI5b1bt5YpLeMsAz+IJdUFkHDQ7m7CNZLVmCLH0M/QUdTwaLce9Op5/+tFiavygBNKqstYVdQ0wNaOA/uY58M6ynVyeWGx3mMDPxZ0Xg+Ckil0DZSdxac0mDNfHHCa1qc705oD1YPSzb/EH2ejpxtCEGMTqaTuxtpQPRkOIA2T/vbCUOFbErMDsxQXK48tYnSQNHLtZuLdU5aOCe4p3jqtZb25TlF+w0CYuFuHZl8c7UOZQs9bxB4e/tcgx688bQ5vr/wmGC2kuGKjgrlEPK3w/liArG5JCGAOrIKffwlpCsfq5SaeBJoHd3LK/rWxXZQhLP1uO0HbPqO059LTnNUJthRoTdXuKYThr7k5+C/GWZSJbOKEdwWOAZhUeW9H1VsJbz6TUEs2vc/z4JPblh4wq4jmHyjQjHieLh0sBPVTQwGSITMeOoPLOCKxzuMavmGJfw73DJi2S+Okjmvwe5iG260CqDWBLzAxkHokwMG/H55OSA8UarPRx1RoGtNxObBGSjfwkJ6euR4em6sMl7Ucubp4wRGMHHUldkoryWcYXgYBsfhuwm7MPyiqxtCWKHdYU0TahhsCtn2apIdA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a simple smoke test for allocating pages of different sensitivities.

Since KUnit doesn't (yet) have infrastructure for this, add custom .init
and .exit hooks to our kunit_suite that detect WARNs by checking the
kernel's taint flags before and after running the tests.

Since ASI is disabled by default, whatever command people currently use
to run KUnit tests probably won't run these tests. Therefore add a new
.kunitconfig file for the x86 tree that explicitly enables ASI. It
should be possible to delete this again when ASI is the default.

So the most straightforward way to run this test is:

tools/testing/kunit/kunit.py run --arch=x86_64 \
	--kunitconfig=arch/x86/.kunitconfig --kernel_args asi=on

The more long-winded way, which lets you customize the kernel config,
is:

mkdir -p .kunit
cp arch/x86/.kunitconfig .kunit
tools/testing/kunit/kunit.py config --arch=x86_64
make O=.kunit menuconfig  # Or debug.config or whatever
tools/testing/kunit/kunit.py run --arch=x86_64 --kernel_args asi=on

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/.kunitconfig  |   7 +++
 arch/x86/Kconfig       |   7 +++
 arch/x86/mm/Makefile   |   2 +
 arch/x86/mm/asi_test.c | 145 +++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/panic.c         |   2 +
 mm/init-mm.c           |   3 +
 6 files changed, 166 insertions(+)

diff --git a/arch/x86/.kunitconfig b/arch/x86/.kunitconfig
new file mode 100644
index 0000000000000000000000000000000000000000..83219e6ecca8d2064aba71fab1f15d57161fa2e4
--- /dev/null
+++ b/arch/x86/.kunitconfig
@@ -0,0 +1,7 @@
+CONFIG_PCI=y
+CONFIG_MMU=y
+CONFIG_64BIT=y
+CONFIG_X86_64=y
+CONFIG_KUNIT=y
+CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION=y
+CONFIG_ASI_KUNIT_TESTS=y
\ No newline at end of file
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cb874c3857cf443c6235e05bc3f070b0ea2686f0..a7b5658ecb1203458e06a0a065bcc7aa7dca8538 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2458,6 +2458,13 @@ config MITIGATION_PAGE_TABLE_ISOLATION
 
 	  See Documentation/arch/x86/pti.rst for more details.
 
+config ASI_KUNIT_TESTS
+	tristate "KUnit tests for ASI" if !KUNIT_ALL_TESTS
+	depends on MITIGATION_ADDRESS_SPACE_ISOLATION && KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Builds the KUnit tests for ASI.
+
 config MITIGATION_RETPOLINE
 	bool "Avoid speculative indirect branches in kernel"
 	select OBJTOOL if HAVE_OBJTOOL
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 5ecbff70964f61a903ac96cec3736a7cec1221fd..7c36ec7f24ebb285fcfc010004206a57536fc990 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -58,3 +58,5 @@ obj-$(CONFIG_X86_MEM_ENCRYPT)	+= mem_encrypt.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_amd.o
 
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_boot.o
+
+obj-$(CONFIG_ASI_KUNIT_TESTS)	+= asi_test.o
diff --git a/arch/x86/mm/asi_test.c b/arch/x86/mm/asi_test.c
new file mode 100644
index 0000000000000000000000000000000000000000..6076a61980ed9daea63113a30e990eb02a7b08d5
--- /dev/null
+++ b/arch/x86/mm/asi_test.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include <linux/mm_types.h>
+#include <linux/mm.h>
+#include <linux/pgtable.h>
+#include <linux/set_memory.h>
+#include <linux/sched/mm.h>
+#include <linux/types.h>
+#include <linux/vmalloc.h>
+
+#include <kunit/resource.h>
+#include <kunit/test.h>
+
+#include <asm/asi.h>
+
+struct free_pages_ctx {
+	unsigned int order;
+	struct list_head pages;
+};
+
+static void action_many__free_pages(void *context)
+{
+	struct free_pages_ctx *ctx = context;
+	struct page *page, *tmp;
+
+	list_for_each_entry_safe(page, tmp, &ctx->pages, lru)
+		__free_pages(page, ctx->order);
+}
+
+/*
+ * Allocate a bunch of pages with the same order and GFP flags, transparently
+ * take care of error handling and cleanup. Does this all via a single KUnit
+ * resource, i.e. has a fixed memory overhead.
+ */
+static struct free_pages_ctx *do_many_alloc_pages(struct kunit *test, gfp_t gfp,
+						unsigned int order, unsigned int count)
+{
+	struct free_pages_ctx *ctx = kunit_kzalloc(
+		test, sizeof(struct free_pages_ctx), GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_NULL(test, ctx);
+	INIT_LIST_HEAD(&ctx->pages);
+	ctx->order = order;
+
+	for (int i = 0; i < count; i++) {
+		struct page *page = alloc_pages(gfp, order);
+
+		if (!page) {
+			struct page *page, *tmp;
+
+			list_for_each_entry_safe(page, tmp, &ctx->pages, lru)
+				__free_pages(page, order);
+
+			KUNIT_FAIL_AND_ABORT(test,
+				"Failed to alloc order %d page (GFP *%pG) iter %d",
+				order, &gfp, i);
+		}
+		list_add(&page->lru, &ctx->pages);
+	}
+
+	KUNIT_ASSERT_EQ(test,
+		kunit_add_action_or_reset(test, action_many__free_pages, ctx), 0);
+	return ctx;
+}
+
+/*
+ * Do some allocations that force the allocator to change the sensitivity of
+ * some blocks.
+ */
+static void test_alloc_sensitive_nonsensitive(struct kunit *test)
+{
+	unsigned long page_majority;
+	struct free_pages_ctx *ctx;
+	gfp_t gfp = GFP_KERNEL | __GFP_THISNODE;
+	struct page *page;
+
+	if (!cpu_feature_enabled(X86_FEATURE_ASI))
+		kunit_skip(test, "ASI off. Set asi=on in kernel cmdline\n");
+
+	/* No cleanup here - assuming kthread "belongs" to this test. */
+	set_cpus_allowed_ptr(current, cpumask_of_node(numa_node_id()));
+
+	/*
+	 * First allocate more than half of the memory in the node as
+	 * nonsensitive. Assuming the memory starts out unmapped, this should
+	 * exercise the sensitive->nonsensitive flip already.
+	 */
+	page_majority = (node_present_pages(numa_node_id()) / 2) + 1;
+	ctx = do_many_alloc_pages(test, gfp, 0, page_majority);
+
+	/* Check pages are mapped */
+	list_for_each_entry(page, &ctx->pages, lru) {
+		/*
+		 * Logically it should be an EXPECT, but that would cause heavy
+		 * log spam on failure so use ASSERT for concision.
+		 */
+		KUNIT_ASSERT_FALSE(test, direct_map_sensitive(page));
+	}
+
+	/*
+	 * Now free them again and allocate the same amount as sensitive.
+	 * This will exercise the nonsensitive->sensitive flip.
+	 */
+	kunit_release_action(test, action_many__free_pages, ctx);
+	gfp |= __GFP_SENSITIVE;
+	ctx = do_many_alloc_pages(test, gfp, 0, page_majority);
+
+	/* Check pages are unmapped */
+	list_for_each_entry(page, &ctx->pages, lru)
+		KUNIT_ASSERT_TRUE(test, direct_map_sensitive(page));
+}
+
+static struct kunit_case asi_test_cases[] = {
+	KUNIT_CASE(test_alloc_sensitive_nonsensitive),
+	{}
+};
+
+static unsigned long taint_pre;
+
+static int store_taint_pre(struct kunit *test)
+{
+	taint_pre = get_taint();
+	return 0;
+}
+
+static void check_taint_post(struct kunit *test)
+{
+	unsigned long new_taint = get_taint() & ~taint_pre;
+
+	KUNIT_EXPECT_EQ_MSG(test, new_taint, 0,
+		"Kernel newly tainted after test. Maybe a WARN?");
+}
+
+static struct kunit_suite asi_test_suite = {
+	.name = "asi",
+	.init = store_taint_pre,
+	.exit = check_taint_post,
+	.test_cases = asi_test_cases,
+};
+
+kunit_test_suite(asi_test_suite);
+
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
diff --git a/kernel/panic.c b/kernel/panic.c
index d9c7cd09aeb9fe22f05e0b05d26555e20e502d2f..6aa79c5192520af55cd473912d2ac802de687304 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -39,6 +39,7 @@
 #include <linux/sys_info.h>
 #include <trace/events/error_report.h>
 #include <asm/sections.h>
+#include <kunit/visibility.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -737,6 +738,7 @@ unsigned long get_taint(void)
 {
 	return tainted_mask;
 }
+EXPORT_SYMBOL_IF_KUNIT(get_taint);
 
 /**
  * add_taint: add a taint flag if not already set.
diff --git a/mm/init-mm.c b/mm/init-mm.c
index 4600e7605cab43b4bce24b85ec1667db8b92dc80..456b8f7d2ab3bd7963a51908dff76713a4e65ab5 100644
--- a/mm/init-mm.c
+++ b/mm/init-mm.c
@@ -13,6 +13,8 @@
 #include <linux/iommu.h>
 #include <asm/mmu.h>
 
+#include <kunit/visibility.h>
+
 #ifndef INIT_MM_CONTEXT
 #define INIT_MM_CONTEXT(name)
 #endif
@@ -47,6 +49,7 @@ struct mm_struct init_mm = {
 	.cpu_bitmap	= CPU_BITS_NONE,
 	INIT_MM_CONTEXT(init_mm)
 };
+EXPORT_SYMBOL_IF_KUNIT(init_mm);
 
 void setup_initial_init_mm(void *start_code, void *end_code,
 			   void *end_data, void *brk)

-- 
2.50.1


