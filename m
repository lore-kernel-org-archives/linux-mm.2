Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59149C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FEFF6B00E0; Mon, 27 Jul 2026 08:38:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D6E66B00E1; Mon, 27 Jul 2026 08:38:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 517766B00E2; Mon, 27 Jul 2026 08:38:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BD716B00E0
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:38:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9DFC140706
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:38:37 +0000 (UTC)
X-FDA: 85034510274.29.658CCBC
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	by imf18.hostedemail.com (Postfix) with ESMTP id B66731C000F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:38:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=jJgNcA2p;
	spf=pass (imf18.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785155916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avcd0GvpHsHr7mxbfL1p/CzBnaA4uWaToeE7s1gnya0=;
	b=ncbhKJQhg/nLYQ0V7WMtJyiIleeoJMb7xBQZntYD9kn1ZTLWU7YZ2pxaVQN3zHeO0sGMT2
	iAgZyqxxGoohRW4OO0Ri9k6Xgs1wy8Erq6Ksq18zhfLSeQCllxMH7pVZCooZcXUSLv7tXS
	MMQI/YVxFe5f3QqXfSUr0aZCMUFoVyo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785155916;
	b=vExOtHOKE20kJdt8J3iPLMwy09WcsyluD3UPwoYTF9Y42Yyj+KVoyNKrpqIoGn58K+Aycb
	yR/scqraBae4YH+P3Q0WcJ1HnRH/LON8HU2f2NjQ7h1TJcwStOhy9Iac0kluz3K+aPZgmP
	QQaaKPndkDoJq/gXz0MtDuY6UguYtqI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=jJgNcA2p;
	spf=pass (imf18.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785155910; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=avcd0GvpHsHr7mxbfL1p/CzBnaA4uWaToeE7s1gnya0=;
 b=jJgNcA2pHqzt7FnxTtltloPFsDofv9cQyCywNRhbuQpzoPiuBIi38xCim7rWpXJ5QVx8xo
 S6PImqRIOhXheRAmez5ABdSY1UYW5Vam8L3vmajYWYTUpLpJ25TPOKBXAuvcmn2Nf4LhM+
 uhr4usKIoyW48tS5m32UHpqGpMSrJE1I2LHfDAR0KxpQkq4gZjNzNwp+8AlYJyBuvSMd47
 yZ9mPlWVyNV3BINPDZkBJaUh9q/i+2mnobS2BkNPUXtKGWwpJFd6Tsze22253ZcX7mJN1P
 ScnTtuV3noVkm/Fst4HKVD/l7/9Fu4f+4X7f5kBob2I0bQhHh0VFocRl1Ritgg==
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260727123429.5673-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Subject: [PATCH v8 8/9] mm: use memcpy_nontemporal() in zone-device template copies
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260727123429.5673-1-lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Message-Id: <20260727123429.5673-9-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a675144+d5aa4a+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon, 27 Jul 2026 20:34:28 +0800
Mime-Version: 1.0
X-Stat-Signature: ipfzcc3ezhb5h87kxhygwnnfs5hm9s33
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B66731C000F
X-HE-Tag: 1785155915-598663
X-HE-Meta: U2FsdGVkX1+fp27o6DL5MiUrkO3/jwwWAlbfluaQVDwKFe6dczk5jeeSujTWoKTeWWUpFbm0i6l+B6WP68eX/0mxv/VGp6xT1vfZdihVZXuJAK7e5QezlvKERHB8P6kGJUoCC0nUhrMY8dY9sMB71DvdM2gOl+TaYvGROhxAzr4KFPIqpXaxms4WdvpngKnkl9FI9s9YyctlkxEi3x//eI6fE3DecC+uJOj2RNEQDQ/K0hJvAnEglJP/4fLpDMx/W3VS1kv66dLdSfW4F3e6ZHzDIbdI5nE2ZAdo9XxQZNWpJWhsOkyyNbF6vNtOF8EaT7GhV1gkwTJ+a7vUHkPG9UE2sYPwFstaiSkVV9Fw8v96zH+BXfGZjdgrp/tUUa/p7N7+rc9M0IlW+kWzHEMfmflEWrZ+vAfn5qNg8p4mHXUpjAeI/3/jL6NWzxvsCjHTDUNfsN/3PRVJXxiEt7AF9++3MI6XTXqomXSBtIBcovGskq2WGABzQzKgA+hxQm5ttiVzit9d59BRTN4hOyozPPE4oRQ5K6ow5LJwfvCyO64Z6xh5t6igTaPQCaJpUNA+sLr6oJYUb6DTBmHgKSL3a1VdNiL+oxAh+OXpVAURqRSF1Jz8nx10Ygw5vlF6ATSAH0oFRBI3fsKzLz7it3WQFLJBoAwygoCxphXjKeFT69jMK7en+uBmv9yyseF49+jW157jXPMzHj43Fy9jHisl/fg5xuif6cdjqEmzrFDg6Ih+yMM/+JGfG6eZ6EQIX3CSYepLMlVDB3MHB+YSFczrPuOVR4TdmrRjBBiKM/0ess9P6L6J6qzAg39Ut2ZweeEAwCq/01LhwtzNjQuC3ZmcjTSHlr2E6cMCVuQNRzsGl6tiUd0HbhPyCanEfVFUyeHPK4oXsV/2o9T2LmjjQP0F3hP7SPkTFEjxFfP6J1nrmzp0cz/A6Q6Ch6yjp+S8hEVSz2r8dQjhDYLfGKgkhUM
 FF41+HxO
 LrS2Up3PYNIhwrO7O/ksnNIYrZnViuunluOHsy+HZCPoNDQkl9bJPCTjI/uSe7PEoG0cmVBCUf32ykygjrKDaTNToy+F+il/+/ZeacsO+jrvfFCMV7iYIsafmaXKOEjqF8MPaEVDyqwTg1hQtU5hVg3qN6DJffK807Ajj5Onb/EbjspKV/B0YFbsKikX/mcjU2a0x992oYZOYgLqnvu5n8G1qQk4tFikqUdxMm6VkAb3B0RL47U32R05Mv5XerOxitpSzIEiu2gnByzlALL8wQh9hzfaHA/ogzilOw4Sey5tYX7Bqyz2kSg5sZ8Z54VhwiN2hM3k66YIBOIXiw+2KPsHVoXTzVj/dgfc4Gm+ZoqpevPwMEgwwmgIR1SMWl14DBRIX+hxDT/j6C69O2JVZA3DIgwt5ZWaluRe3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The template fast path currently uses memcpy() for the actual struct
page copy. Switch zone_device_page_init_from_template() to
memcpy_nontemporal().

ZONE_DEVICE memmap initialization is largely write-once: each struct
page is populated once, and most destination cachelines are not expected
to be reused immediately afterwards. On x86, a regular cached memcpy()
can therefore incur write-allocate traffic by pulling destination
cachelines into the cache before writeback, and can populate the cache
with data that has little near-term reuse. Using memcpy_nontemporal()
lets this path request nontemporal stores for that copy pattern, which
can reduce cache pollution and avoid part of the associated
write-allocate overhead, while architectures without a specialized
backend still fall back to memcpy().

No separate drain is added here. memcpy_nontemporal() is used only as
the copy primitive while memmap_init_zone_device() is still initializing
the struct page array. The ordinary stores that follow in this path,
such as compound-page setup, are part of the same CPU's initialization
sequence; they are not used as a publication store that tells another CPU
or device to consume data written by the non-temporal copy.

Therefore this call site does not need a helper-level drain for
correctness. Callers that use memcpy_nontemporal() as part of a
producer-consumer or device-visible handoff must add the required
ordering themselves.

At this point, sanitized builds still use the slow path so KASAN/KMSAN
retain their instrumented stores. The following cleanup removes that
local opt-out together with the remaining non-template fallback.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
server.

Test procedure:
Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

Base(v7.2-rc1):
  First binding for nd_pmem driver: 1456 ms
  Average of subsequent rebinds: 244.28 ms

  First binding for dax_pmem driver: 1462 ms
  Average of subsequent rebinds: 273.31 ms

With this series:
  First binding for nd_pmem driver: 1272 ms
  Average of subsequent rebinds: 96.79 ms

  First binding for dax_pmem driver: 1354 ms
  Average of subsequent rebinds: 119.04 ms

This reduces the average memmap initialization time measured during rebind
by about 60.4% for nd_pmem and 56.4% for dax_pmem.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 2668acef4fe6..2a723a518f41 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1067,11 +1067,21 @@ static void __ref zone_device_page_init_slow(struct page *page,
 
 static inline bool zone_device_page_init_optimization_enabled(void)
 {
+	/*
+	 * Keep sanitized builds on the slow path so their stores stay
+	 * instrumented.
+	 */
+	if (IS_ENABLED(CONFIG_KASAN) || IS_ENABLED(CONFIG_KMSAN))
+		return false;
+
 	/*
 	 * The template fast path copies a preinitialized struct page image.
 	 * Skip it when the page_ref_set tracepoint is enabled.
 	 */
-	return !page_ref_tracepoint_active(page_ref_set);
+	if (page_ref_tracepoint_active(page_ref_set))
+		return false;
+
+	return true;
 }
 
 static inline void zone_device_tail_page_init(struct page *page,
@@ -1110,7 +1120,7 @@ static void zone_device_page_init_from_template(struct page *page,
 	 * to the destination page.
 	 */
 	zone_device_page_update_template(template, pfn);
-	memcpy(page, template, sizeof(*page));
+	memcpy_nontemporal(page, template, sizeof(*page));
 }
 
 /*
-- 
2.20.1

