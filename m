Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC9C7CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 03:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3225F6B009D; Tue, 26 May 2026 23:41:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CC016B009E; Tue, 26 May 2026 23:41:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2098B6B009F; Tue, 26 May 2026 23:41:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EF516B009D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:41:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C74CB1C19F0
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:40:59 +0000 (UTC)
X-FDA: 84811798638.02.15068D7
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2C1341C0002
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:40:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=jxGxZUs3;
	spf=pass (imf18.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779853258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/2RvXz8oWe2/xVcoRxII+0kZXLSgfUTV6Cn2seMf/Rg=;
	b=FEF4nCgylDEM8u/cmYu1iUQoQ1LXn0Oyd9HGJ3vaq9kf4HRAYTlObY3K95P1P2kouQ4z6A
	21a9WW/jvjaXRdG6LA/dq+RaFB0aoVB8xPqvJqI8aefKB5WECSHnmeQNwZ+LlQSki05H7f
	WmtlaRL1CQ/F1OUwYtonW4l2feIt+r0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=jxGxZUs3;
	spf=pass (imf18.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779853258; a=rsa-sha256;
	cv=none;
	b=x4WuaXGz5b+JQWbu4+F5pr2w425pYtRqCIDEYW+iB0NP+Xt/aIofiuAqXzAf6SACpayRDW
	AianxTwZ31xHoe/0cXyzXeEPw4OKfxLA9MMXNDdtbsE6EurrV/uto/jp8um4hdfiUKb+E9
	g+Kqt1pVZ+drz7h5YIqGc0xFNjvOFIU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779853253; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=/2RvXz8oWe2/xVcoRxII+0kZXLSgfUTV6Cn2seMf/Rg=;
 b=jxGxZUs3u2P4WcI+TbLrf1iJPbfO2E927/UO7AbjPGoyrqScQm+seFYm/WaaloWm9c5OhG
 CaiCfhVRWd7E4dyhdPw7AcSzVAMF0FoQcu4RrI6QjbIqq/lcLvCaCmNvpCn8c1VXkp9NR1
 R8ltVzJBXD93p17b9n5T8bgR3Ui70rmuQRxIB2ioFZfSoEhtRiE7YQNg5qdDFQUJF/uM2q
 qsH8PvlckD2t5q2i6MwQeT12yQmqNTf9CNJkRhSm+TkKksxSI8C/T4UPetnnp7DDkarKaD
 RIpPZh0E21NPr4Cao6omM2bP2e0b1XmS0bv31+ZiTpgH4UZeBl0FWnle0319ZQ==
Subject: [PATCH v3 8/8] mm: use memcpy_streaming() in zone-device template copies
References: <20260527033636.28231-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a1667c3+f04cd6+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed, 27 May 2026 11:36:36 +0800
Message-Id: <20260527033636.28231-9-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <20260527033636.28231-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
X-Mailer: git-send-email 2.45.2
X-Stat-Signature: 67q5qkd3dsfopmj5ywcqjycduk5k65ih
X-Rspamd-Queue-Id: 2C1341C0002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779853257-796383
X-HE-Meta: U2FsdGVkX1+iNbY6oWZboHVGdJdHYjpAYZQVztLjv8szvdop+8Y2doYdhXeb0rt869GXCxyj6pyY/2/1AYmio6zYKKl3VeHg99bT4J6xQfBRO9eiBzOuXO1viE3PE8JCgJ7kNMYn9ri2JDzTo4uQFye5gs634+WgLTOiSsN1oi8pmfXpxRbWR3QIxwZSqWoBV6M5Nwl8qzwPjlsP4uyHLuyCuSbfw9t+HAHMExCVTAG2wYzZ1Fw7v88K5ICp6XFutQm88pfngb3LbVufb0dfxGkvlWpZQX6iSFgw2F7ovNglxtQQC3d/lWQLEsotrQ9MJAwkpM5f1gk7Q4ZkVqtrAlWFZ6Z61EXHCIEmcSAt7LwHaPGKEljkV1KSSI1xhWGZ78eic1jlptHofEk5QdKpVMGwzVhQ4iIZ7WYU0Les5BMyw1fuHfRQm9IxhffhFyHsKhvXEEmwjApMz0x1OtnvkLl5moqpex0kK4uIZI/JoIoiaFk+wrNgxpJRMuLiA9X6He98V+/r9aDs4EzXWCcmtOuywPvCZYT3WUoDVqra6AuqzYU/K+attlqBFtGTGyLqPloHtwjHD5LriNVCMCKPrZO3Cti8t102BNTUBnK/lj38akYAGBc6ihxu7zitn16xfr+F3etvlN5jQtBTMj17sgD7LfCUBz7hKDVoiK9SPvEw7Nrtjf5rxVkTy82mCEnPwj8JRj8h7o4VUDgCSraTw+Gk8dVy4K0B34WxHNHgfzIXYz3+gbdC7/DfKgG2UPjPeRkTJQbSN9YusRKl/7aIX7CQJRL/z1ec5r76CdZ5sJXZ4z61zRZ5o1MCfIX+Psle0wrNbmKYiUfa2cInD0InxtmdZRFf2dW9+LgzkchBknhONOA/5AIiKXY8Pyrz5bOcKppXJ4/pYgBv/IH7sYu+CqRSywLi6uwni9s+XpLK339WdeLAJZsXN+DQ16p4VxJ3XRZIwDrac/M5HOEODwf
 3T9OdZ/j
 VWFPXQPFWP59nFMIoo/8kBwNHAe1rbiEiINnkZEzsWrp72a8MUKp2vPg0TKvNawfFTy0tsWhQVLptqRRtdbsxFQL5TC1YE3EXIrea4+A6i4vMF5Vvotzogmbaw6yP8ggwPo8zySo6Cs+8NAE8DyyuZHQUsHXUQg8Dv3xYJ7LNUS47JVuGHZOJZDU4ExJWKCCK8kxEz0jkHcmoFegjuNWWUuBk6+EWeGSfpV73XEhsBNHPy5SGy4V5coGA+LIWm+sIYQJNkLVrO64mUCtB5mqJ1ctEvJxjm9J1lMjNn1OWLGjO1VLpNuzAnFOgkg==
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

Base(v7.1-rc3):
  First binding for nd_pmem driver: 1486 ms
  Average of subsequent rebinds: 273.52 ms

  First binding for dax_pmem driver: 1515 ms
  Average of subsequent rebinds: 313.45 ms

With this series:
  First binding for nd_pmem driver: 1285 ms
  Average of subsequent rebinds: 114.31 ms

  First binding for dax_pmem driver: 1331 ms
  Average of subsequent rebinds: 99.37 ms

This reduces the average rebind time by about 58.2% for nd_pmem and
68.3% for dax_pmem.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 47 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 45 insertions(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index d5ccb49a048f..1f56765b92e1 100644
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
 
 static inline void zone_device_template_head_page_init(struct page *template,
@@ -1120,9 +1130,19 @@ static void zone_device_page_init_from_template(struct page *page,
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
 		prep_compound_tail(page, head, order);
 		set_page_count(page, 0);
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
 
@@ -1232,10 +1261,24 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		if (pfns_per_compound == 1)
 			continue;
 
+		/*
+		 * memmap_init_compound() immediately updates compound-head
+		 * metadata. If the head-page template copy above used
+		 * non-temporal stores, order them before entering the
+		 * compound setup path.
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

