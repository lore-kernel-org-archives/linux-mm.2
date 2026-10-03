Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B98FFCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:23:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D366B0093; Sat,  3 Oct 2026 17:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D0026B0095; Sat,  3 Oct 2026 17:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E5326B0096; Sat,  3 Oct 2026 17:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25EF66B0093
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:22:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AC12C1A0A11
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:22:53 +0000 (UTC)
X-FDA: 85282589826.11.1E5681B
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf29.hostedemail.com (Postfix) with ESMTP id ECCF2120004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:22:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aKgTYA4g;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3KXLBagYKCHAZfWnncUccUZS.QcaZWbil-aaYjOQY.cfU@flex--lrizzo.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3KXLBagYKCHAZfWnncUccUZS.QcaZWbil-aaYjOQY.cfU@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062571;
	b=qttEslC5T75/tzqFYKV9bdDqgcFyJrX84KtRpeORF6m1ht8vNjnpY5XNMgmJHpzt8H8jK+
	vl3E6/jWwZdVgi7s02Jt+ZpjPGyDHsTY63iQcwuR7B7HVCQmKZqKjjaB2mrR08aaNVpC4R
	1zwIcXEvo9rss8Z7x3mVTnLGFT21BMU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aKgTYA4g;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3KXLBagYKCHAZfWnncUccUZS.QcaZWbil-aaYjOQY.cfU@flex--lrizzo.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3KXLBagYKCHAZfWnncUccUZS.QcaZWbil-aaYjOQY.cfU@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxA7oyLrSoVNihu+TTEed7Cv84XwkDi44oXKTt9irD0=;
	b=qoH+EmRKkFwExF3u1a0Vuk1JnVLKi2QsHQKGnunJXyQ3CPP/ruaeoGHq4uURX6WmzS0aj6
	Xo0XC5ovsnmju8T1Z/jYvV7xiyQVwdbFo9lWqSG2t9tbWHcaOTQwCLFT/fnnwC4S0KVRdG
	OF0EZnfquWhFolwg6SQFDNahvQjIHU4=
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c2e385c2586so88385966b.2
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062570; x=1791667370; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sxA7oyLrSoVNihu+TTEed7Cv84XwkDi44oXKTt9irD0=;
        b=aKgTYA4gfHCTbPWOMbYBSpd3QTbDgP+BC9qQ0b8ZtV6xihcI9UlgZYWGnqgnipItVX
         on4lP7je6Ns9+OlcJFAbh6heyV4iYeL3+yVKWFa4Aynz4Htwe5rEqRU3wwH3Y1nPs3UY
         OA+91lWnO1af6rZ1RdmNWUKZYGzwv0delAVPkboJp+ECXXJo8USI2/7hlecfvZ/saBLF
         6PDOm63rPAh6sxWOn8rmrSEW57P5NR4BS+EhK76Qqi+FiznstsXBDXoS44GpIalmO958
         FgH3Xnw9BpXjFFzHdAqI9NBeyIoc53qGOoRAW6AomnsUVYrgM96j4WQ8NlnwJbIQtxwf
         VkQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062570; x=1791667370;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sxA7oyLrSoVNihu+TTEed7Cv84XwkDi44oXKTt9irD0=;
        b=oZI5DNabUeTLOVzutSxgJ+w3xx9I36Ksjwxxqj3VQ5anD18VQ8HPWabT1wDxAg5yvy
         rAFRFVQGdVnqIxIaHM+KT+xQe7SwImfJMonTwFxf0pM98gWMah+dnMJM7grvPW0/CIOX
         r8XITwUTE7wFB5eHIr3ixiit0NLlwgOFmrsSyan/Wc6uIv8q5tCdo7tw/jYJ66AVR/xE
         oohwUjuJNJ82mBF32+COHMo5Tj+stYhW7wJ6cLfaKIlHyiLrc98LqfGfp6tRlFSLuLef
         sjrvLy+pKf61QPMld53Ir76zYL8iZzJgZCsK+zXa92BkGD0WZ7NrTRE4Mb+7ll7FEnuZ
         0Low==
X-Forwarded-Encrypted: i=1; AKwUvBzgRAvt1lFBPt73DvKXAtj615RvnvR7zuL1GKpJfwPeHVJTu8931W84znTxUpMnxzq52IMPpiS2Wg==@kvack.org
X-Gm-Message-State: AFuF++lOx2MbaGMF/8JLoflO5XhJwaOVVDzEajMs16XAZMODmwvLkde6
	/S3f5bD/aIwrkhB5SB3fQl4fn+eSiW1Ccpp9InOaiW68LG83D3nHylhlRSPcxGDczcXCObFwRGH
	vJk2OZg==
X-Received: from ejcay23.prod.google.com ([2002:a17:907:9017:b0:c2d:d3a7:21fe])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:97d3:b0:c2e:3ed7:7db4
 with SMTP id a640c23a62f3a-c2e6ed3f0fcmr244265366b.23.1791062569971; Sat, 03
 Oct 2026 14:22:49 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:22 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-4-lrizzo@google.com>
Subject: [RFC: DMA_PMD 03/22] mm: Add split_page_compound()
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: osbyejofpaamk1qxmj4qkdu4njc7x9kw
X-Rspam-User: 
X-Rspamd-Queue-Id: ECCF2120004
X-HE-Tag: 1791062571-502349
X-HE-Meta: U2FsdGVkX18Y2WkhWfTzSx5t394y4HqCDov7EOwSoyFl6om4mxYSL959YRZGLOuCOliee2WDjAjX/T08iBhs/UOymNREFcJTtq6/20QZv/lsHEEoNESFe8uN7DYGgvz1k2oBXFPAE7aoBkA+5reONWNJBOj3+lYinyb4TwjkSCpZIhz/NfY47l3zij+e8KXAlSNw3CxvSzIIqGDEH5IfsYug5rJGeX9KJWAaMGS9NH67OggkpHTr1HbJw8KGGMk5QxxZ8ExPkYBM/nHgXR33oWyPl7brHTkhhCMNYf8+iQVXPD77/E+ilR7z82dHN5BVMXqHGgB3Idc+7nTg2AhGZcG/3LwRr2ML1YyVCKHQqewGPGT0IdNG6IRldawWGKj1xiVY1mcEw516TgJTwsafeXzLLXjYPI12BCOeTq8QoriYN0qrFtvjarFvCsyImygS2v6JO+PVOF37PtLAUyyBxKCTR0nnvJrMdSPgWUO9ujvmXqW6dOyJJq/gIcQV6hlnD8bSds7zSKc8mKsaIKiMzyTv2ZZRCGHroE79irIXSMKVH5/4OuLtrguIfBe2yG/zmwPLSef6j4A5/UFQBBKjjGeOWDVZMDhBxIO5YthFhHtJ02vBkoO+QVrGKuChOS0NoRac6NzHoXzSFDhnFmuQu51jkDso1zIXWjYJ/PS6SM0ydH48cA7m2w++lUBXuIh+b3Orl2LComShzlWyZHYILyZmYyoZ77CfgVZdbeyy6PkO/NL8rbyPXNI+4oKwR7P0ack0j5P5sEpc+gms187cjmCH0rfVll36vqJlIKPGUvTagNGvxjgePxB31YGqpfJYQ/P6wDIxDj+FgyXVcwPfsiOLjJP8CXOM/XxoGZZUDK154V61Fh1jbEy0lbwAB5pGQVNR8qSyvDxm8BxS4H/KyTx7WFRleFM1lQ6X9kN22+eT+xjfaFipk7D5AI2IPjzy7DHOTK/KzxCkuPQd+Ut
 m3/HubU8
 v0HpJtBJ0OXQqFVB4Zs+QyKFSteLXENcMW1zg5hzpgxHwK2hDdxwX87OdRfV/75uR7r3JBdfHxQlZ0MrhEcr7XaZumFHB2GYEv6T09PXRXVDFN5epmuH8GgMNIewtKQB2UVB34sPmEmkjEbq5T834gU6tfyfooAz4Syx92hymAOJvakgP96r80rq4YVPlKm2Byd3jR0+MXHWJGjPWHwQxyWwFeX7xh81jr3q2xsp5G+3UiBvt1UPZCvUK6kDmLkRvzm7d4KMOLO5KK6+mBg6eKDkcxSvWPIa7SgVU+qrhoBC9wf2k+KOBhnfixumpRrporV7bqT0FtNAEa+wBlACyDT7fX3OOqiKyaXwckpGYqV/ulJXt1McII7IerXdKW4Z+GU1pyUMIqeKD4bo/wGRgDXzpXoNyXfe5qIPcy94EY0Vl0AImur/0YYMyzzKoki1wWj4ITQRSzWiBoaOwXEKNFerh/+SR3IGifcTT0el+Xc9iuFq/CQb0Q9FKA7Zf0FKeEgqYacQTYMuU6VPlvuspIXnacMfp6DNctkz1+sNASkfA8yEi3SQ+ehOeM2IrWD5jvYIWR+anNXVoxs52xlHR2qtWJ6enODgombq1zGE4LiaQlyz9kCV3isi/L3q1Nnvf6PppH98amaDokDx+JbrZ+scDBLBFaSIelKEV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add split_page_compound(), which splits an order-@old_order page into
independently refcounted order-@new_order compound pages (or order-0
pages when @new_order == 0). This is the high-order counterpart of
split_page(), used by DMA_PMD pools to carve PMD pages into smaller
compound blocks.

All resulting pieces are returned frozen (refcount 0) so the caller can
park them in a pool and publish each piece with page_ref_unfreeze(piece, 1)
when handed out.

Also add a KUnit test suite (CONFIG_SPLIT_PAGE_COMPOUND_KUNIT_TEST) in
mm/split_page_compound_kunit.c.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 include/linux/mm.h             |   2 +
 mm/Kconfig.debug               |  11 ++++
 mm/Makefile                    |   1 +
 mm/page_alloc.c                |  85 +++++++++++++++++++++++++
 mm/split_page_compound_kunit.c | 113 +++++++++++++++++++++++++++++++++
 5 files changed, 212 insertions(+)
 create mode 100644 mm/split_page_compound_kunit.c

diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd09c438fa23e..799a42005627f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1985,6 +1985,8 @@ static inline struct folio *virt_to_folio(const void *x)
 void __folio_put(struct folio *folio);
 
 void split_page(struct page *page, unsigned int order);
+int split_page_compound(struct page *page, unsigned int old_order,
+			unsigned int new_order);
 void folio_copy(struct folio *dst, struct folio *src);
 int folio_mc_copy(struct folio *dst, struct folio *src);
 
diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 15dca19dd07da..e1a04671c3b0d 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -347,3 +347,14 @@ config MEM_ALLOC_PROFILING_DEBUG
 	help
 	  Adds warnings with helpful error messages for memory allocation
 	  profiling.
+
+config SPLIT_PAGE_COMPOUND_KUNIT_TEST
+	bool "KUnit test for split_page_compound() (built-in)" if !KUNIT_ALL_TESTS
+	depends on KUNIT=y
+	default KUNIT_ALL_TESTS
+	help
+	  Builds KUnit unit tests for split_page_compound() in mm/page_alloc.c,
+	  verifying compound splitting, sub-block freezing, and speculative
+	  reference handling.
+
+	  If unsure, say N.
diff --git a/mm/Makefile b/mm/Makefile
index e7245cb88c665..448c0f5f783f3 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -148,3 +148,4 @@ obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
 obj-$(CONFIG_MEM_ALLOC_PROFILING) += alloc_tag.o
+obj-$(CONFIG_SPLIT_PAGE_COMPOUND_KUNIT_TEST) += split_page_compound_kunit.o
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e8e9905cdea5b..a663ec81a588b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3133,6 +3133,91 @@ void split_page(struct page *page, unsigned int order)
 }
 EXPORT_SYMBOL_GPL(split_page);
 
+/*
+ * split_page_compound() - split an order-@old_order page into compound pages
+ *			   of order @new_order
+ * @page: the page to split
+ * @old_order: the current order of @page
+ * @new_order: the order of the resulting pages
+ *
+ * Unlike split_page(), which produces order-0 pages, this produces
+ * 1 << (@old_order - @new_order) compound pages, each with its own head.
+ * @page must not be compound, and the caller must hold the only reference to
+ * it: the block is frozen while the new heads are built.
+ *
+ * All pieces (including @page at index 0) are returned frozen, with a zero
+ * refcount. Publish each piece with
+ * page_ref_unfreeze(piece, 1) before handing it out: its release store orders
+ * the compound layout built here against anyone who then observes the
+ * refcount. A relaxed set_page_count() would not, and on a weakly ordered
+ * machine a PFN walker could see a live refcount on a head whose layout is
+ * not visible yet.
+ *
+ * Memcg-charged pages are rejected: the accounting helpers assume a split
+ * produces order-0 pages and would mis-attribute the new compound heads.
+ *
+ * Return: 0 on success, -EINVAL if @page cannot be split or if @new_order is
+ * larger than @old_order, -EBUSY if anyone but the caller holds a reference
+ * to it.
+ */
+int split_page_compound(struct page *page, unsigned int old_order,
+			unsigned int new_order)
+{
+	unsigned int i, step = 1U << new_order, nr = 1U << old_order;
+
+	if (WARN_ON_ONCE(PageCompound(page) || !page_count(page)))
+		return -EINVAL;
+
+	if (WARN_ON_ONCE(new_order > old_order))
+		return -EINVAL;
+
+	if (WARN_ON_ONCE(memcg_kmem_online() && PageMemcgKmem(page)))
+		return -EINVAL;
+
+	/*
+	 * Shape the new compound pages while the block is frozen, which is
+	 * the order __alloc_pages_noprof() itself uses: prep_new_page()
+	 * builds the page with a zero refcount and the set_page_refcounted()
+	 * that follows is what makes it visible.
+	 *
+	 * Freezing stops a speculative PFN walker from resolving a compound
+	 * page that is only half built: get_page_unless_zero() fails for as
+	 * long as the layout below is being written. It does not order
+	 * against memory_failure(), which sets PG_hwpoison before taking any
+	 * reference, so the non-atomic __SetPageHead() below can still lose a
+	 * concurrent poison bit - exactly as it can for every other
+	 * prep_compound_page() caller, the page allocator included.
+	 *
+	 * A failed freeze is not a bug, it means someone holds a speculative
+	 * reference. Every PFN walker in the tree gates
+	 * get_page_unless_zero() on PageLRU, which a freshly allocated block
+	 * is not, so in practice only the hwpoison machinery gets here. Let
+	 * the caller fall back rather than warn: a machine running
+	 * panic_on_warn should not die of a condition the caller handles.
+	 */
+	if (!page_ref_freeze(page, 1))
+		return -EBUSY;
+
+	if (!new_order) {
+		/*
+		 * The subpages of a non-compound block are already
+		 * independent frozen pages, so only the bookkeeping applies.
+		 */
+		split_page_owner(page, old_order, 0);
+		pgalloc_tag_split(page_folio(page), old_order, 0);
+		split_page_memcg(page, old_order);
+		return 0;
+	}
+
+	split_page_owner(page, old_order, new_order);
+	pgalloc_tag_split(page_folio(page), old_order, new_order);
+
+	for (i = 0; i < nr; i += step)
+		prep_compound_page(page + i, new_order);
+
+	return 0;
+}
+
 int __isolate_free_page(struct page *page, unsigned int order)
 {
 	struct zone *zone = page_zone(page);
diff --git a/mm/split_page_compound_kunit.c b/mm/split_page_compound_kunit.c
new file mode 100644
index 0000000000000..bb0ac908bbc1e
--- /dev/null
+++ b/mm/split_page_compound_kunit.c
@@ -0,0 +1,113 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * KUnit tests for split_page_compound().
+ */
+#include <kunit/test.h>
+#include <linux/gfp.h>
+#include <linux/mm.h>
+
+static void test_split_compound_pieces(struct kunit *test)
+{
+	const unsigned int old_order = 5, new_order = 2;
+	const unsigned int step = 1U << new_order;
+	const unsigned int nr = 1U << old_order;
+	struct page *page;
+	unsigned int i, j;
+	int ret;
+
+	page = alloc_pages(GFP_KERNEL, old_order);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+	KUNIT_EXPECT_FALSE(test, PageCompound(page));
+
+	ret = split_page_compound(page, old_order, new_order);
+	if (ret)
+		__free_pages(page, old_order);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	for (i = 0; i < nr; i += step) {
+		struct page *sub = page + i;
+
+		/* All heads 0..N-1 are returned frozen (refcount 0). */
+		KUNIT_EXPECT_EQ(test, page_count(sub), 0);
+		KUNIT_EXPECT_TRUE(test, PageHead(sub));
+		KUNIT_EXPECT_EQ(test, compound_order(sub), new_order);
+
+		for (j = 1; j < step; j++) {
+			KUNIT_EXPECT_TRUE(test, PageTail(sub + j));
+			KUNIT_EXPECT_PTR_EQ(test, compound_head(sub + j), sub);
+		}
+
+		page_ref_unfreeze(sub, 1);
+
+		/* Tail get_page()/put_page() must operate on this piece's head. */
+		get_page(sub + 1);
+		KUNIT_EXPECT_EQ(test, page_count(sub), 2);
+		put_page(sub + 1);
+		KUNIT_EXPECT_EQ(test, page_count(sub), 1);
+	}
+
+	/* Each compound piece frees independently at new_order. */
+	for (i = 0; i < nr; i += step)
+		__free_pages(page + i, new_order);
+}
+
+static void test_split_order0_pieces(struct kunit *test)
+{
+	const unsigned int old_order = 3, nr = 1U << old_order;
+	struct page *page;
+	unsigned int i;
+	int ret;
+
+	page = alloc_pages(GFP_KERNEL, old_order);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+
+	ret = split_page_compound(page, old_order, 0);
+	if (ret)
+		__free_pages(page, old_order);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	for (i = 0; i < nr; i++) {
+		struct page *sub = page + i;
+
+		KUNIT_EXPECT_FALSE(test, PageCompound(sub));
+		KUNIT_EXPECT_EQ(test, page_count(sub), 0);
+		page_ref_unfreeze(sub, 1);
+		__free_pages(sub, 0);
+	}
+}
+
+static void test_split_ebusy_extra_ref(struct kunit *test)
+{
+	const unsigned int old_order = 4;
+	const unsigned int new_order = 2;
+	struct page *page;
+	int ret;
+
+	page = alloc_pages(GFP_KERNEL, old_order);
+	KUNIT_ASSERT_NOT_NULL(test, page);
+
+	/* Simulate a concurrent speculative reference. */
+	get_page(page);
+	ret = split_page_compound(page, old_order, new_order);
+	KUNIT_EXPECT_EQ(test, ret, -EBUSY);
+	KUNIT_EXPECT_FALSE(test, PageCompound(page));
+
+	put_page(page);
+	__free_pages(page, old_order);
+}
+
+static struct kunit_case split_page_compound_test_cases[] = {
+	KUNIT_CASE(test_split_compound_pieces),
+	KUNIT_CASE(test_split_order0_pieces),
+	KUNIT_CASE(test_split_ebusy_extra_ref),
+	{}
+};
+
+static struct kunit_suite split_page_compound_test_suite = {
+	.name = "split_page_compound",
+	.test_cases = split_page_compound_test_cases,
+};
+
+kunit_test_suite(split_page_compound_test_suite);
+MODULE_DESCRIPTION("KUnit tests for split_page_compound()");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


