Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8230BCD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 04:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69006B0088; Thu, 21 May 2026 00:05:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E40EE6B008A; Thu, 21 May 2026 00:05:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D56D16B00A0; Thu, 21 May 2026 00:05:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C38246B0088
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:05:32 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 956CA1A04CA
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:05:32 +0000 (UTC)
X-FDA: 84790087704.16.0780911
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	by imf28.hostedemail.com (Postfix) with ESMTP id B0D58C0007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:05:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=H9E+oWZM;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779336330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6yOkcnsUQzUvHuhs1BUNozB1nWiAB67h4IULUSq8t6Y=;
	b=61e3S+OaOZCy9rbn1LSZ1hfYBVZjhv8zdpH7bzh4i9ajOmnQQ7oqqV85VuJmo0WnI5TCmH
	78p/X9yJteFcufnanzm5yk33f6Vw9UHVYLoOdnJ8S/FYR2OFR6e8rNqgBCLZBAuvTtpCxr
	bQGpsWtiR0HS5shFnHyYPpoJQjq3pfI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779336330; a=rsa-sha256;
	cv=none;
	b=PczG1uJZsbwVeoDp7I4hXbmKCSFzmt7EunGbRTac3f9YWGbnPIUmsTViwLvKlbHge6KTp7
	7Lf6PKksb4reAU0JBfROfr1wx7b3FB1EEibfLwW6ciPmW5CSbVJKxnmjGRFKZ9JFCacmQd
	lSvJRSXCb8b1TINHWlAAwK0cxf0Clao=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=H9E+oWZM;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779336325; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=6yOkcnsUQzUvHuhs1BUNozB1nWiAB67h4IULUSq8t6Y=;
 b=H9E+oWZMTtJppFi69MCqfOZ6fwGQY695lXdiU3sEfw9V5MUkc0G9mcrlmYaTTLo7wEGqNF
 3ND1r4t0yQBSJpYt+CdgnoWsn0TN8LoQpsRAjNUfhy/8p/nZJUZHbroMbTJtxk/qirrGqv
 AdFjo1JmOncufKuCK9a430Hat3W4LNYESlN4sbp8CV0zaVzRoMj17VjI3popdg4LJihLpw
 KUJfu+eAADYp0Cx8xF1Eu591NUtQFwyMO/VwxaAefS7GsxviTUE7uRlfuiJgYsfYJh+241
 eMg0QRTdxg8O++6K17wTh2xHDKX07zjmDhwND+2WjiFWOnH8kbMVqgpWBklYiw==
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Message-Id: <20260521040124.10608-8-lizhe.67@bytedance.com>
References: <20260521040124.10608-1-lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <x86@kernel.org>, 
	<linux-hardening@vger.kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v2 7/7] mm: use memcpy_streaming() in zone-device template copies
In-Reply-To: <20260521040124.10608-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <apopple@nvidia.com>, <akpm@linux-foundation.org>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<mingo@redhat.com>, <rppt@kernel.org>, <tglx@kernel.org>, 
	<kees@kernel.org>
Date: Thu, 21 May 2026 12:01:24 +0800
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26a0e8483+c0bf9d+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B0D58C0007
X-Stat-Signature: 8x7jq1oq1xzj4dns1isbfknqrhexammx
X-Rspamd-Server: rspam06
X-HE-Tag: 1779336330-833806
X-HE-Meta: U2FsdGVkX1+d8qjEwjQVUP0d262pMNPp1vtT3w5VL2BAMldQ5kh6Ccql5k+VhmnbGG/i2n1hZNzawR00GoFrE8ytoQFjG1McLVtuq0S5bbRhLg5gkj/7SJ65J56AxMlHhZZgAjrlNmomUdCqlymzxNJJ5Fa/byw1wJoyKhCi24VHqdy0G5f2hG0x3rqtJLAtKZc88mARVfwQ6GUhQll9ZQNFCZVRVzkj+p+9ZDJpOrAEmzXo24s9jPU9TW2enlrDtSMxJtxuvef/0yeSo7oeVAowISWDju1y9ABPBVx3LT784T3ffuFsDD6Vs65vhLaU9xqpIxFSwBpD80gngGLA8FXkFCKGF0V7eId4ur4LJGX+zvsRY140KTxCR73DwHiuad+KloLYDXKrKBddB/mxBIVAzKNw0Nmah/omZJiER0Ao2ClsoYETnneHRztZl6lirWXfNVU+KElnkf4gf9UMI6OBNSAl7RkFJcK6/qRJUh3RHV66PX0aFMu/kxYP6PQvpttTHPxlFOqTFIHWBUzZKowTHyxAI90rKXy0RzBOLZ3vfEXI8Hx6PW+qu7C+GKOMeoEtwVNJhdB7V9/OmqMzZyoIyR4VP+sH6vtlnhiIzndjXD8rMeWh+tg9A8NwZhnpgt+8ixxs59gMYpWGc46simTcuupZV+GZ2NMm0kqiEilT8OwGyqgNuYfU+1lFrZtG0j5HK0KEHg13bRpRqEM57BKKsvepHvP++dS3xYf/zI6yw0JqNWilv/c4r9Es5Ms48wOibcjqaKBd6CUIjNcQHLECGACFso7wBjfiJkM0Z11WcY22po1S5vBkOz5hB91y0VLXWxeVN6EQOiiSWMvby1NNKGQYzoNnnQiMLsnohSCxskiBXgZPlpUCTAEGJQVRyxthATcl+hotO91FCtKFNwXJjnym4/PIp0yFq/AhH8QZPN2R3n3uikB3A1dKKtvIon9GUnmqluBhZMI546P
 sVidrObM
 0MhoLFmYLt+uv2ZbSfd/NxuKHqBqhjsq7ZPicnkSaXfqDT2Fa0JmpIB5A2mIEA3MOO1HRXkvWkOATiVRZZC2nXDFNzWUlY1K3ek9IDm4Aw1Tdw8PhId8gii3DSg2Gb8w/UGNPTxLdvlGLnx+lEqspuCF+thO/YblAHBJnYbsaOS2jAT8x27V3ssyfJkgbtdDvhyDNg+k09kfNzMaC4kVInCFJWwdVV1nRsT6yeMXAMPgtuQCKdq46oggNmvU7w/u1uj+0F5rIxepBqkx6glCbatLLbss42b2mTrKuTP961P0U59QIYCB7XavEQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The template fast path still leaves the actual copy sequence up to the
compiler. Use the streaming-copy helpers introduced in the previous
patches for the ZONE_DEVICE template-copy path so common mm code can
request a write-once copy primitive without embedding arch-specific
store layout in the generic layer.

ZONE_DEVICE memmap initialization is a write-once path: each struct page
is populated once and is not expected to be reused from cache
immediately afterwards. A regular cached copy can therefore incur
write-allocate traffic and pollute the cache without much benefit.
Using memcpy_streaming() lets this path use an architecture-optimized
streaming copy where available, while still degrading to memcpy() on
architectures that do not provide a specialized implementation.

Update the PFN-dependent section bits and page->virtual state in the
reusable template before each copy instead of patching the destination
page afterwards. This keeps the hot path as a single streaming copy for
the common case and avoids post-copy normal stores to cachelines that
were just written through the streaming path. Keep pageblock-aligned PFNs
on memcpy() so pageblock initialization can immediately read back page
metadata without introducing a read-after-streaming dependency.

When the streaming backend uses non-temporal stores, order them before
entering memmap_init_compound(), before prep_compound_head() updates the
overlapping compound metadata, and before returning from
memmap_init_zone_device().

Keep sanitized builds on the slow path so KASAN/KMSAN retain their
instrumented stores.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
server.

Test procedure:
Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

Base(v7.1-rc3):
  First binding for nd_pmem driver: 1486 ms
  Average of subsequent rebinds: 273.52 ms

  First binding for dax_pmem driver: 1515 ms
  Average of subsequent rebinds: 313.45 ms

With this series:
  First binding for nd_pmem driver: 1389 ms
  Average of subsequent rebinds: 111.08 ms

  First binding for dax_pmem driver: 1294 ms
  Average of subsequent rebinds: 110.24 ms

This reduces the average rebind time by about 59.4% for nd_pmem and
64.8% for dax_pmem.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 83 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 60 insertions(+), 23 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 17a84d4cda01..08feb24795b8 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1075,13 +1075,15 @@ static void __ref zone_device_page_init_slow(struct page *page,
 static inline bool zone_device_page_init_optimization_enabled(void)
 {
 	/*
-	 * The template fast path copies a preinitialized struct page as an
-	 * array of u64 words. Skip it when the page_ref_set tracepoint is
-	 * enabled, and fall back to the slow path if struct page is not an
-	 * integral number of u64 words.
+	 * The template fast path copies a preinitialized struct page from
+	 * a reusable template. Keep sanitized builds on the slow path so
+	 * their instrumented stores remain intact, skip the fast path when
+	 * the page_ref_set tracepoint is enabled, and fall back if
+	 * struct page is not an integral number of u64 words.
 	 */
-	return !page_ref_tracepoint_active(page_ref_set) &&
-		IS_ALIGNED(sizeof(struct page), sizeof(u64));
+	return !IS_ENABLED(CONFIG_KASAN) && !IS_ENABLED(CONFIG_KMSAN) &&
+	       !page_ref_tracepoint_active(page_ref_set) &&
+	       IS_ALIGNED(sizeof(struct page), sizeof(u64));
 }
 
 static inline void zone_device_template_head_page_init(struct page *template,
@@ -1104,30 +1106,42 @@ static inline void zone_device_template_tail_page_init(struct page *template,
 }
 
 /*
- * The copied template already provides the PFN-invariant portion of a
- * ZONE_DEVICE struct page. Fix up the fields that still depend on @pfn
- * after the copy, namely the section bits and page->virtual when present.
+ * 'template' is a reusable page prototype rather than a strictly immutable
+ * object. Most ZONE_DEVICE fields stay constant across the pages covered by
+ * the current template, but section bits and page->virtual may still depend
+ * on the PFN. Refresh those PFN-dependent fields in the template before
+ * copying it into @page.
  */
-static inline void zone_device_page_init_finish(struct page *page,
-							unsigned long pfn)
+static inline void zone_device_page_update_template(struct page *template,
+						    unsigned long pfn)
 {
-	set_page_section_from_pfn(page, pfn);
+	set_page_section_from_pfn(template, pfn);
 #ifdef WANT_PAGE_VIRTUAL
 	if (!is_highmem_idx(ZONE_DEVICE))
-		set_page_address(page, __va(pfn << PAGE_SHIFT));
+		set_page_address(template, __va(pfn << PAGE_SHIFT));
 #endif
 }
 
 static void zone_device_page_init_from_template(struct page *page,
-		unsigned long pfn, const struct page *template)
+		unsigned long pfn, struct page *template)
 {
-	const u64 *src = (const u64 *)template;
-	u64 *dst = (u64 *)page;
-	unsigned int i;
+	/*
+	 * 'template' carries the invariant portion of a ZONE_DEVICE struct
+	 * page. Update the PFN-dependent fields in place before copying it
+	 * to the destination page.
+	 *
+	 * pageblock-aligned pages immediately feed
+	 * init_pageblock_migratetype(), which reads back page metadata via
+	 * helpers like page_zone(page). Avoid a read-after-streaming
+	 * dependency for these rare pages by using regular cached stores
+	 * instead of non-temporal ones.
+	 */
+	zone_device_page_update_template(template, pfn);
+	if (unlikely(pageblock_aligned(pfn)))
+		memcpy(page, template, sizeof(*page));
+	else
+		memcpy_streaming(page, template, sizeof(*page));
 
-	for (i = 0; i < sizeof(struct page) / sizeof(u64); i++)
-		dst[i] = src[i];
-	zone_device_page_init_finish(page, pfn);
 	zone_device_page_init_pageblock(page, pfn);
 }
 
@@ -1168,9 +1182,10 @@ static void __ref memmap_init_compound(struct page *head,
 	__SetPageHead(head);
 
 	/*
-	 * A tail template can be reused for all tail pages in the same compound page
-	 * because shared state for compound tails is pre-set by prep_compound_tail().
-	 * The per-page page->virtual and section in flags are fixed up after copying.
+	 * All tails of the same compound page share the state established by
+	 * prep_compound_tail(). Reuse one tail template for the whole range
+	 * and refresh only the PFN-dependent fields in that template before
+	 * each copy.
 	 */
 	if (use_template)
 		zone_device_template_tail_page_init(&template, head_pfn + 1,
@@ -1189,6 +1204,15 @@ static void __ref memmap_init_compound(struct page *head,
 			set_page_count(page, 0);
 		}
 	}
+
+	/*
+	 * prep_compound_head() updates compound metadata in struct folio fields
+	 * that alias the first tail-page descriptors. When the tail pages above
+	 * were populated with non-temporal stores, order those writes before the
+	 * overlapping metadata updates below.
+	 */
+	if (use_template)
+		memcpy_streaming_drain();
 	prep_compound_head(head, order);
 }
 
@@ -1237,10 +1261,23 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		if (pfns_per_compound == 1)
 			continue;
 
+		/*
+		 * Compound-head setup immediately updates head->flags, so make
+		 * the streaming template copy visible before entering
+		 * memmap_init_compound().
+		 */
+		if (use_template)
+			memcpy_streaming_drain();
+
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
 				     compound_nr_pages(altmap, pgmap),
 				     use_template);
 	}
+	/*
+	 * Drain any remaining non-temporal stores before returning.
+	 */
+	if (use_template)
+		memcpy_streaming_drain();
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
-- 
2.20.1

