Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52768CD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 08:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8BB6B0099; Wed,  3 Jun 2026 04:08:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859006B009B; Wed,  3 Jun 2026 04:08:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7480D6B009D; Wed,  3 Jun 2026 04:08:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F3C26B0099
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:08:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 240AC161955
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:08:16 +0000 (UTC)
X-FDA: 84837873792.06.6A2F118
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	by imf10.hostedemail.com (Postfix) with ESMTP id 37670C000A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:08:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=pB4S8BwY;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780474094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A5euipl6qc7ONaSWy009BEQvfxAQyFAQV+XgcOVI8kM=;
	b=osLbP6768qS3oej7tbCsZQJsw2QcUDXctLit2NaNVoL2QfX4njX0wkKvy0dXUHOZemELA5
	WCxDV2uIhx7a1uJuWFCMLmXZnyDxf7lv2EzA+Qfvqq98CayGFze+U/uVLc7L4eRFS+Y5CU
	YaEnbEI+yvgjJgCnoE3cJ1iHSBNqWNs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=pB4S8BwY;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780474094;
	b=UN2z4jGEIAGcLhCGeWY8Xnx3hvjz6hLaSydIr4MWJ6R90FuVaDb+C7xpwQmwN7riuvW2tI
	moiZKbv/hH5BRrmM1eRm9/2HafbLLLStfm/tmYhWy4usC9MOYsLqCVSt74ywCY7ePWyzOg
	cClpfegU6LZd3tj0mk0u9DkDi7x3Etc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1780474088; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=A5euipl6qc7ONaSWy009BEQvfxAQyFAQV+XgcOVI8kM=;
 b=pB4S8BwYAbNJ4NDAhr3y0o+XUY71E7wUogqlxhMSeC7adJ4B9e3UXJVbAjlOyy39srx9NF
 M6nBZgYHNkTxAxfQUI1EyJlHPBPk73tFzQqtarfY3fIDbYoKSx6wK05noC+cr7UjhqoJvf
 OnLbv6p13Dzpaeh/LC8msfhWHWaPViH4UO3Lk2/d9RueXY7+bnnVebgJP91lvv+So7GqdQ
 VHaJoMHp7BKTyxgdcPFmkVWL5QsIeNOBiQjVHgnbIht7lUfcjcCJOqHN7t06t1a/6vL5l6
 kDZBlBjOLpTdY4UZ8Mk1bFearc1ysjWCtxe0ttTdZqnrqW/xi0oudyu8UhQkdA==
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260603080152.64728-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a1fe0e6+c84522+kvack.org+lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Date: Wed,  3 Jun 2026 16:01:52 +0800
Subject: [PATCH v4 8/8] mm: use memcpy_streaming() in zone-device template copies
Mime-Version: 1.0
In-Reply-To: <20260603080152.64728-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
Message-Id: <20260603080152.64728-9-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 37670C000A
X-Stat-Signature: ehd7ek4mrjrzq7qbq635kzd1cj67o8hr
X-HE-Tag: 1780474094-597317
X-HE-Meta: U2FsdGVkX18eNxThTOkaqdDrV33t5doUAnkjHNBCk3SATu9sFrPFJRIbp3RIut3T9U9x4QrUV7BZZexkfqnE44eC9LDKt3k4d4ebgZBzl2wm/2m9E3BIlixzWeuoMB7r+l55TzAgbJysiPw6OX8r0+t8qrSq6LxwVek8cTFKVYWeio3KjCNrgP7xsL1CtLF63Ood5hbjAGAzbeJ3SoMI5EohNAuU3jk39qM09mWnSQxPi1lMf+g/inEejia3CPFNvRdjNCKIfGN2mA3i6cIL2nMv0uFeWEynp0wy4DCfo1Lk0BZDQvD/uC8AIZ1GcZagoj2ItER7Fvt4OhE1/zfIbSjG+EF2O1Z4VQmeohpJWKF7ctBnJyDYg3KCfFN1IQITzAGQ9kvD0UuRtPa7lgbPwxlsbF5w+tpZm5+WwnOGPf+3fvdg1kDlCeUP2G4HtDvYo0foXQl0NMw3I3aT5HyQmwVtN2f4FsJpf5euqNwNevPLb8Y04bZDZpkJlDnKbcRFDwASmDzc1cTCh1DwhvqKr2tUVgnG9VtknEANy51IqI/w/e2W7dx5qO1KF+2zx3sIT85o3Tgn8bWVIdnECI2aVIh22SmrJc+SPv1Caq8TgDzevxwRMdGU/3wEcGBB4CXWDNqdyHjnwQ3J6eC342YcHm2HRC3pRqUwJGUQ8ZmKK2mOD7L57SNhMcN/mV8rDKZoYc2HBlB4BlLaAyTE8wAamnJir6DWM+zIZzPfOxuhWp8r6vd0bkRaYRiYlHRcy0Df1xgfBmahJ8/P8ql8WYO9QONwIy+jq/mfkvmxEnKVb7J7ylka6IBfAXDtKF5RT0cSGH1ljdoGE9qT7V68wdP+uYJxgvsp3Wqvint0u7yquvrbHKsI3vUTmhLLEYFeCpOxpD5cg0SfnYhqGrjUVCNazCuvuua+bXG6474pcVa3UvwjD7QXT01CvRk6PWkGnkiC0tyDyl2e5XNaPl/9jGq
 oXImxsdz
 wYCpxczWDx2wKj7SpOXDLwlxjIWjpfsACn/4qBco+tevszrRKik4ZICKm2bCCJxBB+gfduKfLkq85XMPV+Y+3kzg70dMcUptU17JHV3DZUqtxTUb2yPYlfshwiG1vHHSClbKcvZay5zj/oEMuak2eL5f4gCqUn6VBu8na0mCRdS4trifJd5YzWX2QITI1ACLdNgm7rjk4HlVUcZgWu66eLVTxNHrj+K41RQ+5Fff+JLNgdZswG8gGCdJeDjEPp5uUO29C6YC2SusTwxXsTtrznx+tSTaQOZNp8B2vosqaV5n3OwF3RzfII0Wa6Q==
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

Keep pageblock-aligned PFNs on memcpy() so pageblock initialization can
immediately read back page metadata without introducing a
read-after-streaming dependency. For the remaining PFNs, use
memcpy_streaming() so the hot path can avoid write-allocate traffic
while still leaving unsupported or unsuitable cases to the fallback
implementation.

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

Base(v7.1-rc6):
  First binding for nd_pmem driver: 1466 ms
  Average of subsequent rebinds: 262.12 ms

  First binding for dax_pmem driver: 1430 ms
  Average of subsequent rebinds: 229.12 ms

With this series:
  First binding for nd_pmem driver: 1359 ms
  Average of subsequent rebinds: 108.36 ms

  First binding for dax_pmem driver: 1273 ms
  Average of subsequent rebinds: 100.17 ms

This reduces the average rebind time by about 58.6% for nd_pmem and
56.3% for dax_pmem.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index ad078ee354fb..fbc873284fb8 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1070,11 +1070,21 @@ static void __ref zone_device_page_init_slow(struct page *page,
 
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
 
 static inline void zone_device_template_page_init(struct page *template,
@@ -1117,9 +1127,19 @@ static void zone_device_page_init_from_template(struct page *page,
 	 * 'template' carries the invariant portion of a ZONE_DEVICE struct
 	 * page. Update the PFN-dependent fields in place before copying it
 	 * to the destination page.
+	 *
+	 * pageblock-aligned pages immediately feed
+	 * init_pageblock_migratetype(), which reads back page metadata via
+	 * helpers like page_zone(page). Avoid a read-after-streaming
+	 * dependency for these rare pages by using regular cached stores
+	 * instead of non-temporal ones.
 	 */
 	zone_device_page_update_template(template, pfn);
-	memcpy(page, template, sizeof(*page));
+	if (unlikely(pageblock_aligned(pfn)))
+		memcpy(page, template, sizeof(*page));
+	else
+		memcpy_streaming(page, template, sizeof(*page));
+
 	zone_device_page_init_pageblock(page, pfn);
 }
 
@@ -1184,6 +1204,15 @@ static void __ref memmap_init_compound(struct page *head,
 			zone_device_tail_page_init(page, pfn, zone_idx, nid,
 						   pgmap, head, order);
 	}
+
+	/*
+	 * When the template path is enabled, order the preceding tail-page copies
+	 * before prep_compound_head() updates the overlapping compound metadata
+	 * in the first tail-page descriptors. If memcpy_streaming() fell back to
+	 * regular cached stores, memcpy_streaming_drain() may be a no-op.
+	 */
+	if (use_template)
+		memcpy_streaming_drain();
 	prep_compound_head(head, order);
 }
 
@@ -1248,10 +1277,26 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		if (pfns_per_compound == 1)
 			continue;
 
+		/*
+		 * When the template path is enabled, order the preceding head-page copy
+		 * before memmap_init_compound(), which immediately updates compound-head
+		 * metadata. If memcpy_streaming() fell back to regular cached stores,
+		 * memcpy_streaming_drain() may be a no-op.
+		 */
+		if (use_template)
+			memcpy_streaming_drain();
+
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
 				     compound_nr_pages(altmap, pgmap),
 				     use_template);
 	}
+	/*
+	 * Ensure any prior template copies are ordered before returning.
+	 * On architectures where memcpy_streaming() used regular cached stores,
+	 * memcpy_streaming_drain() may be a no-op.
+	 */
+	if (use_template)
+		memcpy_streaming_drain();
 
 	pr_debug("%s initialised %lu pages in %ums\n", __func__,
 		nr_pages, jiffies_to_msecs(jiffies - start));
-- 
2.20.1

