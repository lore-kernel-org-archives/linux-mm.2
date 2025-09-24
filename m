Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F64BCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96AF48E0019; Wed, 24 Sep 2025 11:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4C38E0012; Wed, 24 Sep 2025 11:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80AEF8E0019; Wed, 24 Sep 2025 11:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F7458E0012
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 330E9BBEBC
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:24 +0000 (UTC)
X-FDA: 83924454768.19.1B0345E
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id 41ACA14000B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QJj410gt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3hAfUaAgKCDEWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3hAfUaAgKCDEWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726022; a=rsa-sha256;
	cv=none;
	b=KnihhPeQhV3AOySidL/TdgD2dnkunHwPZYp7IZrnFSUHgW3/9f2z4urwOp280sCuEXdhak
	urlPfef4Rs5qZ8muixZvAwbPU/nw7sU83gTn4ze6fdECunUsLPptcfL4j5NU6K5jWZomYh
	//RWtEnBoT0ZFQkI9bx9ynQPEYYCkug=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QJj410gt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3hAfUaAgKCDEWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3hAfUaAgKCDEWNPXZNaOTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/bFXVx3R0RyJR3UqZnAzI+0uj7yd2IK0QOGE6ezKlUY=;
	b=3H5nkVIfNAacHcyHoCc4AtmAnfvVg4RBfinOY6tdwxtcHy0NajPn7RdeW9ZwkO99noEqVr
	8bAmFE7rqAPuR88Tkmp8ASg3//CcaGa/7xZWm45yLGLZ4GZFH5uw1UlSNGWTKThX7k2EyO
	RK9364k97Q/rZc6UmVNNKLsdQx1NVKk=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-3ee12ab7f33so3119457f8f.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726021; x=1759330821; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/bFXVx3R0RyJR3UqZnAzI+0uj7yd2IK0QOGE6ezKlUY=;
        b=QJj410gtgJJdxeyztNVZ6qKvoMWJyONqmHLmVVcZQ7XlZjMbSid0QTMM9jQWEOEjfO
         Z/BoLsR6YnQDJItzSmgQKJVEzGU/mSuFAkaiGZI/XbYwMrB0QlFejMHqkAOt4mN8/n53
         FquVjZGKNzPt9tofd5MFQRgP2tuSNwGGaXiKk+SVOPBInjBJ2F3TMWB9uTtGl0RGlwWS
         8j11SK260/2yGldjiSYFXEpjhBVoWWmoKlNM0dE6CUuXM7taK8f92JfzpMGMS7bsMk3z
         gtRTcreRsbYHR6/Om8CYSJjXFcFiuH6AgwF6kVZIJPCc5CRhhO74KBg0tC7pmXbxxzW9
         0FyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726021; x=1759330821;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/bFXVx3R0RyJR3UqZnAzI+0uj7yd2IK0QOGE6ezKlUY=;
        b=TRzVLxlg7m5jmKiKIVShnaA8zisPWKXjolq6vUn3pW+F6RZBWuLWTpO7EYdP3SHinI
         YXotD8EqPsMd9YlAmqVq13vukLAIa2zkHDZp4h4V2n90ZtjgGSFLjx226AkG9HKA5Z17
         cSrSXfZCJEAewRvCsYQfOo6AxUeHGHExqtP1KSYsshDu6FEaAf7br9azXWr0rDwLseNk
         s0BQ1ftrx436OnXjVwzt2beWuRc0vGkUleYA2XzvNGbnP+08+DEUcoHA6EL8KXNjzrCC
         tkr7utnFsVt1orLhaTbyHTBlMTCOghHXS3o2rWdDd/yhLEj3KXh/9DrZaibxr/0S23QC
         f0NA==
X-Forwarded-Encrypted: i=1; AJvYcCUQ6Fq/aDZEGy328PzgeTZga9l9Djt6ajJhmJGH8RWSWb3Ed4sCKE/nMaSp5itDrHEbDqssPOToaw==@kvack.org
X-Gm-Message-State: AOJu0YxH6i8/KAbJlHIAMJgD8iDvAm5t6V6bTQA5okJTTa7YqFolmzLR
	/7imUZU326qiSH5NrxHK6ImttKT+sj+pYLT6611urNaQ6xAoVarpOmR9FVr39UbkDiN6xb63FLo
	LjGqtQFtJzYHfeQ==
X-Google-Smtp-Source: AGHT+IHFVakseZTMWKw/YOwvxPSBppIbseG235GM/Mq7WzEAVq/9qbzbdj/TNAOCE62qZnIbK4YhRn+KuowqWA==
X-Received: from wrwu11.prod.google.com ([2002:a5d:6acb:0:b0:402:78b6:a467])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2586:b0:407:77f9:949d with SMTP id ffacd0b85a97d-40e4b945911mr255186f8f.40.1758726020780;
 Wed, 24 Sep 2025 08:00:20 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:48 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-13-2d861768041f@google.com>
Subject: [PATCH 13/21] mm/page_alloc_test: unit test pindex helpers
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 41ACA14000B
X-Stat-Signature: 6zed3zq4dqnc4a4urfcygibro4qtwcda
X-Rspam-User: 
X-HE-Tag: 1758726022-891453
X-HE-Meta: U2FsdGVkX19o+kc7GlenRAMT8EZtjcrpXFOm/nbAxhWubZwi28J1A4OyaFfqLorhAC0rqeuMxBKihZGUkFORr0H0hYXaMTSnAGrN/9a4Fq+A21RRrtr0I2E2IdPYYsflHjWBeAugs+RJi1OX0xzPW06kM5869dFe66tu6ONMBOVA4bodofGEwCKo54+keAZRfb7BNhBONuXJkV7uRuFcE9iOJKs1E5KwKPupSASZVV/ZkBjEU6Mu9hh3BMzysG0t4Ci3UPqZ4VKxtar36VVLHUn6nO0biMfPzDPeYUSicRtWHtFfmjTBYNlFfb/vMcS97yGJHqnxe8L5ko/TR0dhamuwEc4U861unZxpz8e5ymdAwbI8H76DDJsU6sz9joNW3NhpQYYLt6eWuLH9WfHaYLKepF2Htu8YhBJsrT8tlQ0xz2EUHhwM4Fh4p+OdT6pmKoP8T6ZmasKNybSHaVNyHdEktxIMrNvaEW8lwt9Lt2YD/TG4aYR+6rScc6+adi2VYaNV9Uc92L6UnWpBborKXmMJneZsV0v6vUdwCXy3wZm5soi9XZ7SznNzWN5CwCUYlhfqaxCsbs3G/IqBrqmrJ4xbsKxz2NSPVg6cJv/uKq4i45CxLHMxt91YgG8+qOsA4XVIW74vHlN0p53nDtcrFfNhnLVXfrHTpPmGf+foMtpgBSl7ZmzzxyXvS77xy6q+CGYzxx2zZy341p4ykX6HSFhRNuNgIP0jS88dj9rU17aMe/KMfNrZPWjsUj+xdMnbS2xtL8DNAHME33tT6NQzCeSWDuFNQ3BGk+wcEXdTlMYPDbVT78YGeaJUDMRlQ2ANNUmTGuuBf3eQQM8mjPXsGCGd8tsO91qaaml2REOOR3T51U21HfXfXuQRy3mUS/8aPbzsofg4Nyt+fq87cBcb1TS/koXjOsOpilDRkHTgup4pD2II17GXonfDwcGWr5d1+u5d3K4xRWIgZuMrFN1
 KrwCKMQH
 +lcym9BDTvGycPd2vEzATdDkInRql2no5o4MOUisle1TPsUcr9AsWulUcQbXIH1RuQByJvBDAlrBu5RvsBjMPOg8qnry4xcE1Khj0f+XPhp2S5/Nk2iUK0T5QOcdtVUrfQMNdw1vtGyB2OtWF+f18nvyklsMMeEgqWSkNxaMbwnSZLeu0rtJnCScsihM9g76b5HtjM5iFT447/cESSDlBq5yFcoF32BGxg+dEX9FKB99RpPCgdG2LAecNPX6aUTPGNKutUm2JkB0bt4YLI2BoaFrsnFCWz2rOjzamG5VdZxCr0Ag3KsezzrRk3uxcBzkN44Gg8rRXm80R+UIacpIvIbxlGZrz/a74ePBSQhLEZAYmNZrpxmiHU1HiVh0weTntXikAflUN4PbBk5Nx1Q1Cct8idnvzle67NiyuMwHMbfWqeeRfDdOmtbnKORdguoTDerVF0OB/1PFtk1IsBA8X7SN28UJTYhTrGscj27DfYaFabNugrks/Bi3moO+Q1TIpQIywsTsZiK4qJeNa+AzzChVlozw1tL2gG54TK8ok256+MPrepJ6WzwmQzrNTlRYqG/1GNjo0bYaok2Y8LkjHEILi+V5SPxbFzhl2ZMubvxd6vovaR5yU2MQs3io9+9j5kEj1EjrV6Zgjgc8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The author struggles with really basic arithmetic. This test checks for
errors in the helpers that are used to map to and from pcplist indices.

This can be run via a basic kunit.py invocation:

tools/testing/kunit/kunit.py run "page_alloc.*"

That will run it via UML which means no THP or ASI. If you want to test
with those enabled you can set the --arch flag to run it via QEMU:

tools/testing/kunit/kunit.py run --arch=x86_64 \
	--kconfig_add CONFIG_TRANSPARENT_HUGEPAGE=y "page_alloc.*"
tools/testing/kunit/kunit.py run --arch=x86_64 \
	--kconfig_add CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION=y "page_alloc.*"
tools/testing/kunit/kunit.py run --arch=x86_64 \
	--kconfig_add CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION=y \
	--kconfig_add CONFIG_TRANSPARENT_HUGEPAGE=y \
	"page_alloc.*"

Signed-off-by: Brendan Jackman <jackmanb@google.com>

fix
---
 mm/Kconfig           |  5 ++++
 mm/Makefile          |  1 +
 mm/internal.h        |  6 +++++
 mm/page_alloc.c      | 10 +++++---
 mm/page_alloc_test.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 89 insertions(+), 3 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 034a1662d8c1af320b2262ebcb0cb51d4622e6b0..e25451c1adbd6e079f2d00e3eb8a28affcedab7e 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1375,4 +1375,9 @@ config FIND_NORMAL_PAGE
 
 source "mm/damon/Kconfig"
 
+config PAGE_ALLOC_KUNIT_TEST
+	tristate "KUnit Tests for page_alloc code" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 21abb3353550153a7a477640e4fa6dc6df327541..c6ce46a2abf144f2e62df96ec7f606f90affc5f0 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -65,6 +65,7 @@ page-alloc-$(CONFIG_SHUFFLE_PAGE_ALLOCATOR) += shuffle.o
 memory-hotplug-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 
 obj-y += page-alloc.o
+obj-$(CONFIG_PAGE_ALLOC_KUNIT_TEST) += page_alloc_test.o
 obj-y += page_frag_cache.o
 obj-y += init-mm.o
 obj-y += memblock.o
diff --git a/mm/internal.h b/mm/internal.h
index 0401412220a76a233e14a7ee7d64c1194fc3759d..6006cfb2b9c7e771a0c647c471901dc7fcdad242 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1693,4 +1693,10 @@ static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
 	return remap_pfn_range_complete(vma, addr, pfn, size, prot);
 }
 
+#ifdef CONFIG_KUNIT
+unsigned int order_to_pindex(freetype_t freetype, int order);
+int pindex_to_order(unsigned int pindex);
+bool pcp_allowed_order(unsigned int order);
+#endif /* CONFIG_KUNIT */
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 5943b821089b72fd148bd93ee035c0e70e45ec91..0b205aefd27e188c492c32754db08a4488317bd8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -56,6 +56,7 @@
 #include <linux/cacheinfo.h>
 #include <linux/pgalloc_tag.h>
 #include <asm/div64.h>
+#include <kunit/visibility.h>
 #include "internal.h"
 #include "shuffle.h"
 #include "page_reporting.h"
@@ -691,7 +692,7 @@ static void bad_page(struct page *page, const char *reason)
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 }
 
-static inline unsigned int order_to_pindex(freetype_t freetype, int order)
+VISIBLE_IF_KUNIT inline unsigned int order_to_pindex(freetype_t freetype, int order)
 {
 	int migratetype = free_to_migratetype(freetype);
 	/* pindex if the freetype is nonsensitive */
@@ -713,8 +714,9 @@ static inline unsigned int order_to_pindex(freetype_t freetype, int order)
 	return (NR_PCP_LISTS_PER_SENSITIVITY * freetype_sensitive(freetype))
 		+ pindex_ns;
 }
+EXPORT_SYMBOL_IF_KUNIT(order_to_pindex);
 
-inline int pindex_to_order(unsigned int pindex)
+VISIBLE_IF_KUNIT inline int pindex_to_order(unsigned int pindex)
 {
 	/* pindex if the freetype is nonsensitive */
 	int pindex_ns = (pindex % NR_PCP_LISTS_PER_SENSITIVITY);
@@ -731,8 +733,9 @@ inline int pindex_to_order(unsigned int pindex)
 
 	return order;
 }
+EXPORT_SYMBOL_IF_KUNIT(pindex_to_order);
 
-static inline bool pcp_allowed_order(unsigned int order)
+VISIBLE_IF_KUNIT inline bool pcp_allowed_order(unsigned int order)
 {
 	if (order <= PAGE_ALLOC_COSTLY_ORDER)
 		return true;
@@ -742,6 +745,7 @@ static inline bool pcp_allowed_order(unsigned int order)
 #endif
 	return false;
 }
+EXPORT_SYMBOL_IF_KUNIT(pcp_allowed_order);
 
 /*
  * Higher-order pages are called "compound pages".  They are structured thusly:
diff --git a/mm/page_alloc_test.c b/mm/page_alloc_test.c
new file mode 100644
index 0000000000000000000000000000000000000000..1cc615ce90d95c47ecae206a87f2af3fab3a5581
--- /dev/null
+++ b/mm/page_alloc_test.c
@@ -0,0 +1,70 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/bitmap.h>
+
+#include <kunit/test.h>
+
+#include "internal.h"
+
+/* This just checks for basic arithmetic errors. */
+static void test_pindex_helpers(struct kunit *test)
+{
+	unsigned long bitmap[bitmap_size(NR_PCP_LISTS)];
+
+	/* Bit means "pindex not yet used". */
+	bitmap_fill(bitmap, NR_PCP_LISTS);
+
+	for (unsigned int order = 0; order < NR_PAGE_ORDERS; order++) {
+		for (unsigned int mt = 0; mt < MIGRATE_PCPTYPES; mt++)  {
+			if (!pcp_allowed_order(order))
+				continue;
+
+			for (int sensitive = 0; sensitive < NR_SENSITIVITIES; sensitive++) {
+				freetype_t ft = migrate_to_freetype(mt, sensitive);
+				unsigned int pindex = order_to_pindex(ft, order);
+				int got_order;
+
+				KUNIT_ASSERT_LT_MSG(test, pindex, NR_PCP_LISTS,
+					"invalid pindex %d (order %d mt %d sensitive %d)",
+					pindex, order, mt, sensitive);
+				KUNIT_EXPECT_TRUE_MSG(test, test_bit(pindex, bitmap),
+					"pindex %d reused (order %d mt %d sensitive %d)",
+					pindex, order, mt, sensitive);
+
+				/*
+				 * For THP, two migratetypes map to the
+				 * same pindex, just manually exclude one
+				 * of those cases.
+				 */
+				if (!(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+				      order == HPAGE_PMD_ORDER &&
+				      mt == min(MIGRATE_UNMOVABLE, MIGRATE_RECLAIMABLE)))
+					clear_bit(pindex, bitmap);
+
+				got_order = pindex_to_order(pindex);
+				KUNIT_EXPECT_EQ_MSG(test, order, got_order,
+					"roundtrip failed, got %d want %d (pindex %d mt %d sensitive %d)",
+					got_order, order, pindex, mt, sensitive);
+
+			}
+		}
+	}
+
+	KUNIT_EXPECT_TRUE_MSG(test, bitmap_empty(bitmap, NR_PCP_LISTS),
+		"unused pindices: %*pbl", NR_PCP_LISTS, bitmap);
+}
+
+static struct kunit_case page_alloc_test_cases[] = {
+	KUNIT_CASE(test_pindex_helpers),
+	{}
+};
+
+static struct kunit_suite page_alloc_test_suite = {
+	.name = "page_alloc",
+	.test_cases = page_alloc_test_cases,
+};
+
+kunit_test_suite(page_alloc_test_suite);
+
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");

-- 
2.50.1


