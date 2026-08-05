Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B5ACC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 11:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2CD96B008A; Wed,  5 Aug 2026 07:18:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DE026B0095; Wed,  5 Aug 2026 07:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82FF46B008A; Wed,  5 Aug 2026 07:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 515C56B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:18:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CDB2E1603AC
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:18:31 +0000 (UTC)
X-FDA: 85066967622.09.0B1344F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id DC9E0C0007
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:18:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t4bnVzSW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785928709;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESP5MnWlNHKSLv1MR7wXsaZjakanc99EezeQMtqWPQg=;
	b=A+ab5GFXsln4fm1jsbI46bsdhi//gRnkrG/fhQ2PlnmUv/g/sCtIwa29EGo944SZk16rHo
	8uz1F72K4SkLtDiCviO5b/C3cQSsvYAAB544o6hkgQDT++M3kovfzI5PwetAtQIHwzky7J
	blfu00+jTJ5b5WUavKQWHiPndY0MAI8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t4bnVzSW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785928709;
	b=dYNA5OzHfusUrk7/N2PQbzecl+RCZjmz6cUs+kT/sf6h4VmkqIY02A1nsqHWUlvuAIPn2Y
	zXoDstcdr926noHPIcUsPMBWv9YlrGkWzKDv126j/0S+CzYueCHRxAoW4jc7JLBvBYjBlk
	IVnWNG0oZ5iCr4+C4Od7sg4ur55IEug=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7884C60A8D;
	Wed,  5 Aug 2026 11:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1C68C4AF09;
	Wed,  5 Aug 2026 11:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785928708;
	bh=UT1LepNEWbCDWJUaYqv5zlUitw1W3TiARj2cPHvoCUY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=t4bnVzSW253zztAizs4KD1n/F8LF6BjSGZqoXiLNUHLADW43SyAl+F4vGC3mLRJ+G
	 1VIsXo/OelgBOP2pLzTSSTfsGRvcaQ3YhdVpRZD0jjtkFz1kI4pROqRNOWDt5Q4x2o
	 ZGcrwwanX4CvtFlLtS0cTDmfxV+MQywibHlqLDQgZqK8tnpRDI0Xu8V2pUnVtBhDBx
	 1qghbEiFfddqgF+XYph7lFv3JglkGfCol5n0/SYZTF0mTTbQdU/iWK9RSP+RdaPJ82
	 CsG8jvkgSatiYLI88pIahlTv6hfJq9j+EFdjtAYRkXq9eNAbbyUNMLhv3xGIhfp0f9
	 bKMe0WZuzKzhA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910CDC56203;
	Wed,  5 Aug 2026 11:18:28 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Wed, 05 Aug 2026 16:48:25 +0530
Subject: [PATCH 2/3] mm: add KUnit coverage for mappingless swapcache
 folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260805-b4-mappingless-swapcache-v1-2-b1d78ba257ca@zohomail.in>
References: <20260805-b4-mappingless-swapcache-v1-0-b1d78ba257ca@zohomail.in>
In-Reply-To: <20260805-b4-mappingless-swapcache-v1-0-b1d78ba257ca@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Nico Pache <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785928706; l=3587;
 i=shivamkalra98@zohomail.in; s=20260402; h=from:subject:message-id;
 bh=3IHZ3BPfu/ApButT5xoLEv/VnC/YC3Wow9MhmnAZMzc=;
 b=kwJo2F0rrfAhLwyUMaWx9mR8UMYCkW+NJtcJ+vkgWEVRteK7dzLUswl4dzXKcjsjnKaY7gy+o
 aZ7xqewrI1jABqzhx/4AhTC7/o5MsARKWLGAI5QWdu0WThzRY5Qn8TP
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=U8kQSxcte8P8iZ6zB7phIj+Yl+i/5ntifBGuclgypx8=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260402
 with auth_id=716
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DC9E0C0007
X-Stat-Signature: cyqodwcdrytsymo9w3mrmn4oagou6b6k
X-Rspam-User: 
X-HE-Tag: 1785928709-417276
X-HE-Meta: U2FsdGVkX1/UyM/xuIFMqWZTyVyp1WRJj3QoqkWKx2OA8n+a7ZNTmva3PD/q0kP4Mz+B9SYc78tSK5SnHsHFN+G7kJuEU5M4T+iwffzR3J8EoDJdI6Fclxvc4D/KQ1K0y/Ffg38n/Wtv8LDdp+XdcLxWk4F1GebLgd5niDhUANzsrHfSiDVWsQsSlhCEbux0BeOs2R8vW9L0+V4dzjCFWcyB3UVtYXZeVTer7odlm+/tec41frqDB8oVZdocnKW9cS4yOQmSZMi09xzbCUtj6EkLiPn4Q6C/tmNo+D+P20WbodZ3BC6AlsfyJ/+xTxCf6QY7SDgHfsRpuMs9ggitCH8Q5/HnpajoUVLiU5minJjYCzrYvSf/W8JWVVzVt2HGFFrkXFnuKaOf/Cdw4SR/Z+SxslmbjOvT0p4XPuEjxovpOuGRC6dFA01N1BTagmxsGCvePVZ2MmM8BvFQ2te/l7t9cseT2wQQqns2r7gN6P3e6DGM3+o0+AJnzjLFmfwW4IKwf/rnZiBjsv61enWjW/Bdb0FONlEJebaGcOgOA5wnB8MIhCBoB0yI9jBDfiQ5hc1VKqg/JX0h35rMQfEpokQFM0cznVrKnTbYQrAxQyK7/C0Kh41S3Zkhj9YtU73wBCB+L9qXbFjuuIZIQmFxvYqUJO+wyclavSGZgUogxVk4FiZi7Tw69w4U4vyhXkMbv8bHsH8fYYundviNPMs0/4lBY2/Cl+K7QhZQQh/hjrtjp4t3KQzvp8Vwfug4aDX+qupMBe+DyzOG8XqRVUfFYUvgk5MN0oJz3IPGaEnXchE8MkbynZQ9O++Zx8LPJas4ii41PJwHoJccqRmwt+j1dHk+19rslapu9lBnrpJoFXNjhp1fdOTh5m/XjtJNXOOrylGz6KSJIo5baG8V6Q256c6mpR6kPYGL/nxXElqyqja8WcLH2Abf413t09SJICblR2AXgIH4lC1ewlG6b6k
 Dzg26+kK
 GVADExYhbEIYOvmI5vRUXJhZ/oKo6mRpFyvZAt3M6IVkhBHmFPdTndlp5oI3RRsdvbUZ6wet29kDfmLE+Y6kZVewjBrP9vY6hGB/Cm1CXHPOOvrNkpRyUR8teFQq7egr893pj6/tMJW1oFJuS48coY4L41pZnA9OPaXtJsYwifP8BZ8paqHu/BQ3jfQif+vjT4t8UqiPQf85FkkoMD96BCrw17xmTJFcvB0YZZyiV16KY1o2E/ZVL9ZONIfWWGqeWMxCzpLHMkAADkH5xecxep2/803me3xeOSBBzBQ7O1toNPO+xt3LO5lE4ZdDWh7Dy+RHGb46s0lTDKEwuL/mN5+YKVNcbspeXBo3rkMZqF0Ht66ZmaGCvJ88Qs/XvmcJrUFKD62sQ35JlgqpdaJNHryPX+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Add focused coverage for the folio_check_splittable() eligibility checks.
Verify that an ordinary mappingless folio is rejected, a mappingless
swapcache folio is accepted, and unsupported target orders and split types
remain rejected.

Build the test only when KUnit is built in because
folio_check_splittable() is intentionally not exported.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/Kconfig                   | 14 ++++++++++++
 mm/Makefile                  |  1 +
 mm/tests/folio_split_kunit.c | 52 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index 331daf7fcfab..164dc1438900 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1503,6 +1503,20 @@ config LAZY_MMU_MODE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config FOLIO_SPLIT_KUNIT_TEST
+	bool "KUnit tests for folio splitting" if !KUNIT_ALL_TESTS
+	depends on KUNIT=y
+	depends on TRANSPARENT_HUGEPAGE
+	depends on SWAP
+	default KUNIT_ALL_TESTS
+	help
+	  Enable this option to test folio split eligibility checks. The tests
+	  verify support for mappingless folios in the swap cache and ensure
+	  that unsupported target orders and split types are still rejected.
+	  The tests are built into the kernel and run during KUnit execution.
+
+	  If unsure, say N.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index ab37ef428d98..f09057b40e1a 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -146,4 +146,5 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
+obj-$(CONFIG_FOLIO_SPLIT_KUNIT_TEST) += tests/folio_split_kunit.o
 obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
diff --git a/mm/tests/folio_split_kunit.c b/mm/tests/folio_split_kunit.c
new file mode 100644
index 000000000000..f91c1a320bbf
--- /dev/null
+++ b/mm/tests/folio_split_kunit.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <kunit/test.h>
+#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/huge_mm.h>
+#include <linux/module.h>
+#include <linux/pagemap.h>
+
+static void folio_check_splittable_mappingless_swapcache(struct kunit *test)
+{
+	struct folio *folio;
+	int ret;
+
+	folio = folio_alloc(GFP_KERNEL, 2);
+	KUNIT_ASSERT_NOT_NULL(test, folio);
+	folio_lock(folio);
+
+	KUNIT_EXPECT_PTR_EQ(test, folio->mapping, NULL);
+	ret = folio_check_splittable(folio, 0, SPLIT_TYPE_UNIFORM);
+	KUNIT_EXPECT_EQ(test, ret, -EBUSY);
+
+	/* Only the eligibility check is exercised here. */
+	folio_set_swapbacked(folio);
+	folio_set_swapcache(folio);
+
+	ret = folio_check_splittable(folio, 0, SPLIT_TYPE_UNIFORM);
+	KUNIT_EXPECT_EQ(test, ret, 0);
+	ret = folio_check_splittable(folio, 1, SPLIT_TYPE_UNIFORM);
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+	ret = folio_check_splittable(folio, 0, SPLIT_TYPE_NON_UNIFORM);
+	KUNIT_EXPECT_EQ(test, ret, -EINVAL);
+
+	folio_clear_swapcache(folio);
+	folio_clear_swapbacked(folio);
+	folio_unlock(folio);
+	folio_put(folio);
+}
+
+static struct kunit_case folio_split_test_cases[] = {
+	KUNIT_CASE(folio_check_splittable_mappingless_swapcache),
+	{}
+};
+
+static struct kunit_suite folio_split_test_suite = {
+	.name = "folio_split",
+	.test_cases = folio_split_test_cases,
+};
+
+kunit_test_suite(folio_split_test_suite);
+
+MODULE_DESCRIPTION("Tests for folio splitting");
+MODULE_LICENSE("GPL");

-- 
2.43.0



