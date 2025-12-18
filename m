Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23A65D6D22E
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A90F6B008A; Thu, 18 Dec 2025 10:09:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BD516B008C; Thu, 18 Dec 2025 10:09:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3409C6B0092; Thu, 18 Dec 2025 10:09:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 22CC76B008A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:09:59 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DEEF11DB1D1
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:09:58 +0000 (UTC)
X-FDA: 84232926876.19.12BD4DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E86AD140017
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:09:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uVRFTe4j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766070596; a=rsa-sha256;
	cv=none;
	b=oNWQezkJrWbLedTHyarhM9uOeI8Ia3sK9lbFRu7XpzBCp8sHHIfFs0VNm6Inb80LRkaXDq
	BA32UUQkgMgqHT6PodywGUx/l7A1C7eLSjE7dIj7iplLvcEIojeg1sMjhuJPurGm3g8BIt
	TUMKiGJmzzx9GoD3zEx50izD1ZRsHc8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uVRFTe4j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766070596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQd5aI2XniHm/V0D0Owx2fK41aUHIbbk8X9Bn/yomII=;
	b=jNehjGBsR75j8mBAH9+mIll3jT2b9AJ7CqQJKtUQMsPBdmWHnN/JQmXgMOF3Ku5Y2P4YBt
	o0byHWi4K+u7QXVwz/EJl0DNqrDzP2n+q2FQkOCpZmFHzTYR2uopZUdTySp2drYNAP41Q3
	eS/0g3xjZN3Am1zJDJjzTce+OB/YOvY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 07C606012B;
	Thu, 18 Dec 2025 15:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF91C4AF09;
	Thu, 18 Dec 2025 15:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766070595;
	bh=G2Gy4F6FoeycA/U+pPvXXH1RbWzUZ5Scx06TlxyQkj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVRFTe4jk3ut7r6wqnkj3Jxi5XLk6IYH7mPpTOUKlG7Y3AIh/jTkq62vOZBxZtQEr
	 Bf2RVoE7/f7/kCy3bTpmCXg/yXiYyGDmwat3tVYZ60OtKCXepNqZAJLLEwynyorSma
	 UyKcu+iPCUobh7JtvZQTqSmlZMn1X6s/hfgDT7ZcQDWlp+9VtkawDs4iCgLnojmsVQ
	 rbfUAt8/dgPUtREpFd7Y6Gdx5Gvs2x0gV8Or/8wkHaQj1SZvFdsEwHmjfDHxbfDQ4o
	 voktf5M/lAvOsKFFIC9nem9+NKMsbO/5ztccqBOuU0kpq/LAOM3EZ2tOwtBlW1SM4i
	 A4sF4yTgLLb0w==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.phl.internal (Postfix) with ESMTP id AB7CDF40072;
	Thu, 18 Dec 2025 10:09:54 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Thu, 18 Dec 2025 10:09:54 -0500
X-ME-Sender: <xms:QhlEaTLChUksQdxGfL_F4iMxjTdxjIqEuSXMGptHVbCQkrVyZiDQmg>
    <xme:QhlEaWbTOgHBdwrw6gs4YLd5oLiAxVBbF6Z9Ut4FP9gMtvy4uyP86kKIjBCCh0KUQ
    57NG_4Mxozxt9GL1uRFL2Mrbg7HvyqTHuzFbkNw_95xC-47xo0KATI>
X-ME-Received: <xmr:QhlEaeiaYNDWgawyVA6BZCW3Jok1zgmypH2zw1LTIAqn7Ul5kmX2RgOYx8-cXw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegheejgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpefhudefjeehhfektdeuvdefveejffdvhfevtddugfduffejfeeikeelhedvtedvveen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhope
    hmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiuges
    khgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdroh
    hrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdprhgt
    phhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvhgrug
    horhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhr
    tghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:QhlEaT48AP_7kD7HeRNX4RgkmGf1um-SQAZ0xfKgxFalhNu9fyhzqQ>
    <xmx:QhlEaeqirUk0QiQuH6DXq3f09uxiHxyZYWUgAyx_aG2VVNmaiKERRA>
    <xmx:QhlEaYjoB1chisENo0TEkaOBTY6Mys4IVInPtCdIZVGSoDCIO-hnCw>
    <xmx:QhlEaesYvH_0zHWxrnlvAAwY_FX7h5Uurjm26xmu-VHKPJSlSKiBMg>
    <xmx:QhlEaR2okHc-HMuzaoIVbaCEWuZzZrZEY1XLX2ZwvkqAva87xBLMfxDd>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Dec 2025 10:09:54 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv2 01/14] mm: Move MAX_FOLIO_ORDER definition to mmzone.h
Date: Thu, 18 Dec 2025 15:09:32 +0000
Message-ID: <20251218150949.721480-2-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251218150949.721480-1-kas@kernel.org>
References: <20251218150949.721480-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E86AD140017
X-Rspamd-Server: rspam10
X-Stat-Signature: fz6mjj6kzq6u91qemk3y8dhdpdzuno56
X-HE-Tag: 1766070596-193674
X-HE-Meta: U2FsdGVkX1834eV7CYh5UPAo5OBS4SE19PInhhRqjDh1SFgZXvct176GRDdX8J5ZNBSKPZWDzCne5Z4DR/0rtpHQUNtpXyTbtm3rjj4aSqEjUtOlR5zuxhKMpmIYDbsOkdB7VnRpGXp8tlOyiJ8FDpp7VQFHtxyv8ChSPypmB76ReXqwLml955Khlwg5tohEDIGvMcIJaHjxEYIdjV1kkyWlrgtWIL5wkTdNtyVwh5m6lsGDJ/OhSr8tpRmQ9Vx2BzkFZJMkBwT0RrkGviXiZ/v316DAqnZjcwMwbTt/SS6YDqWoekaH557UoebyBOeQGswbIc9Eq02iVO3Qt3WA040hR5mgnQ4gRXB7ejPv/U6bPv5nNU5v7js0ZL5dFssxlKOl+ktBPQpm+aEX8CNqJ0XuLlzPWi7lZ8xpEclDuFGkZEDJ+r76BU3eLYeQyun5J3Rmb2rMBGlXjnwPwKVux5U6SNwRWemOq53OG0rB5fMcfBHMgrEw/uK4w0gXhBoO8PPTUP3eonP5M7BujX6pGFQOp0sbNJNjERxge65N/+Sfn+YmvQkNgAbfQcKNpM+j6r6KzD+Hn4R8liip7P76M8DqT2IGov+geeSUKjZ23K+fSGo34ZM0wNWmjaHfLYBCXm7BIzBFAb/T2w59RvaszSgaoAw0a0D0UUgmpXhU9XDmTKdFPwZ1B00cL9QgFHVsGA5JZnMc/0n4j8aiILtQuoK+KHK55XXVbUmAO4QXkIC59467ukk9kFQSwMZXnNprt0sjEH+6EnBGHkDnXqSvNXkG3LPA6/+hl9PL6E7vKeECPDhriFjSav7Jai6nCFDnJESYaussk4SSq5LUtagcpbfkcJqGU67CQDyQ7zj3RXee0vif0ProCtwjGEh+PuzxbNFEWA23v5T9d4RxdrjQJnsM6mxnof0GecQ40WaNEo3DNcv+hCB+dmPbHkEC3U8PZzlmX0HK4e6GcDFTOL3
 86/R61xi
 f4niyN+nwOuMFvEiZtJ+1hsl0ia+x2qBbBdxoqAKkAX6MR5iuBDC31w8iC2NvHVTXOaSyB3oTamO6TFqQ9kQECw2txZADqfEOkK+wPqVtt4IUGVKwhMKh0DijsxPT1l34aVI0l4UoKhmNp1HeIURdYdzNvc2bY4tMSMYKoFDtcB59aE1IKiPYrNZIcMEUcb6Ak7sqa1hlEbnhf5MDSTWlaUsmRe/6KUhCdZpzpuvZSp1cnmjTjegl26kyKCm54MgU+G4dNSbWxwQqnirB/T+iqzHBB2yhBvFNeDfez3eyEb67qCX/Hbf/Wp1OH3YbtyCrrj9jAu594VUOrl/DY4HQnVob+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move MAX_FOLIO_ORDER definition from mm.h to mmzone.h.

This is preparation for adding the vmemmap_tails array to struct
pglist_data, which requires MAX_FOLIO_ORDER to be available in mmzone.h.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 include/linux/mm.h     | 31 -------------------------------
 include/linux/mmzone.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7c79b3369b82..2c409f583569 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -26,7 +26,6 @@
 #include <linux/page-flags.h>
 #include <linux/page_ref.h>
 #include <linux/overflow.h>
-#include <linux/sizes.h>
 #include <linux/sched.h>
 #include <linux/pgtable.h>
 #include <linux/kasan.h>
@@ -2074,36 +2073,6 @@ static inline unsigned long folio_nr_pages(const struct folio *folio)
 	return folio_large_nr_pages(folio);
 }
 
-#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
-/*
- * We don't expect any folios that exceed buddy sizes (and consequently
- * memory sections).
- */
-#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
-#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
-/*
- * Only pages within a single memory section are guaranteed to be
- * contiguous. By limiting folios to a single memory section, all folio
- * pages are guaranteed to be contiguous.
- */
-#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
-#elif defined(CONFIG_HUGETLB_PAGE)
-/*
- * There is no real limit on the folio size. We limit them to the maximum we
- * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
- * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
- */
-#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
-#else
-/*
- * Without hugetlb, gigantic folios that are bigger than a single PUD are
- * currently impossible.
- */
-#define MAX_FOLIO_ORDER		PUD_ORDER
-#endif
-
-#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
-
 /*
  * compound_nr() returns the number of pages in this potentially compound
  * page.  compound_nr() can be called on a tail page, and is defined to
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 7fb7331c5725..6cfede39570a 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -23,6 +23,7 @@
 #include <linux/page-flags.h>
 #include <linux/local_lock.h>
 #include <linux/zswap.h>
+#include <linux/sizes.h>
 #include <asm/page.h>
 
 /* Free memory management - zoned buddy allocator.  */
@@ -61,6 +62,36 @@
  */
 #define PAGE_ALLOC_COSTLY_ORDER 3
 
+#if !defined(CONFIG_HAVE_GIGANTIC_FOLIOS)
+/*
+ * We don't expect any folios that exceed buddy sizes (and consequently
+ * memory sections).
+ */
+#define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
+#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+/*
+ * Only pages within a single memory section are guaranteed to be
+ * contiguous. By limiting folios to a single memory section, all folio
+ * pages are guaranteed to be contiguous.
+ */
+#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
+#elif defined(CONFIG_HUGETLB_PAGE)
+/*
+ * There is no real limit on the folio size. We limit them to the maximum we
+ * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
+ * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
+ */
+#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
+#else
+/*
+ * Without hugetlb, gigantic folios that are bigger than a single PUD are
+ * currently impossible.
+ */
+#define MAX_FOLIO_ORDER		PUD_ORDER
+#endif
+
+#define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
+
 enum migratetype {
 	MIGRATE_UNMOVABLE,
 	MIGRATE_MOVABLE,
-- 
2.51.2


