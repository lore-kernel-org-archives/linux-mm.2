Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 377D2C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21EF06B00A6; Wed,  1 Jul 2026 05:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CFDE6B00A9; Wed,  1 Jul 2026 05:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D016B00B4; Wed,  1 Jul 2026 05:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFB9D6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:10:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8614E1A02B3
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:10:52 +0000 (UTC)
X-FDA: 84939637944.27.85FCE8D
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	by imf29.hostedemail.com (Postfix) with ESMTP id F0A45120003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:10:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=HKojACwS;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782897050;
	b=uzZ0Gu1fLxhwjsvbvFx20Vj6jomE3C1GyEjHR/ariZn3DxZa9A25pOiB0rGACO55I2l3WC
	RnYNbfgulosYyplDyHqSDkMgb0WKSRVkfK58DoigCPGQJNx9cVpesAiVv46BoNllmKywpD
	TRdFoAcXmLSuaqCAnlkIBnxkjKTwxHg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782897050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GlwU9A21h4aOkD7NMu1GopyeMNyt93ZxYgfEuylocqo=;
	b=uhkOgfNerD6hYc9ZBngmSTxt77yJU4Q/vK6/m1Csm4QTbwX6dfCpDEwElY23FtGGamtIgr
	8UwNokLUR9YOA2xCq4bQ9dYfuYhqsZBGR2oBwlJkrtCvcT9i8/H9zxYalxbO2a9G4UAsT6
	A9DQvyRGOdFqYJ+XQceYqt7ZSTKMLCg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=HKojACwS;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782897047; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=GlwU9A21h4aOkD7NMu1GopyeMNyt93ZxYgfEuylocqo=;
 b=HKojACwSHM0O4PZ14F8gSKGX7+NtZjqJNdSkkk919J5eF9i6hXRQGwTV0V19aTvT/kdEoU
 hOFD7f6AjhKcr4J7mOafMYqZTUvDyGvT7RrtBDWmUbNXNFG2JezQ5LHfNyimf1O25EQO/D
 hJ6Sc8STcKPd81OaKJ4n7pEzfTzI+NFtJ9CBS2gTWZNo2zg/5xgwXvqGM1wgPvbbnZ1f9F
 0W+g8dAEWG3fwqEat7dRZZ1t2BUPyE7UcAEreANgR4AoUF6D/0qPEiKCF7hqN1BkZCcLMP
 QTvIp96oxsGF1K7hu2W+C3kPJZoiPIuNxL70TJ+CRiAGTV4Ie451uQ1RQJz/uA==
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v5 8/8] mm: use memcpy_nt() in zone-device template copies
Date: Wed,  1 Jul 2026 17:05:53 +0800
In-Reply-To: <20260701090553.62691-1-lizhe.67@bytedance.com>
References: <20260701090553.62691-1-lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Message-Id: <20260701090553.62691-9-lizhe.67@bytedance.com>
Mime-Version: 1.0
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
X-Lms-Return-Path: <lba+26a44d98b+0875b6+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: n5gmkzosftgro13naexaoxgj9rj656kg
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F0A45120003
X-HE-Tag: 1782897048-27629
X-HE-Meta: U2FsdGVkX18UnOW/Sl9g5wpOx+qf8l4RjnSFTTevO59BFlC/+LkCzZ6T1avK9a/GDz6Q0bPE0ziN80D+KogoB9XNqrbaz9W6f4Dq++pCq6UaTYXVp5v+xHSGANB9sU+pmoYf00KFdi0Nup58RmFvYP76J55iJbyreko7jw8hcbrzTjV0jjAPL+g5F3tjmVReE1an47BvH+jIp64jqC1spItl3mlGgGNsywwKjDij4R4KK+Ksmg2BLSc5yUBAZSc1Gxu+GzCvF0IIJOwHSJaqCY/UiSIibduFlzrEUrfB+WpisfOIoCzcOawGrjJDFi7GzcWxKPatFY4GjMlOrWlsVyI5Eej4dy+TYit+UBXzlDMvPksbXTkhB4hiXzGpxmV0x3YKq8dPWBQdqdg/sNBm84fGXKylN2QgisdVK4RkwPlMXd5gwGaiForHeEZsmaKogGzUW8Jf36SRqQR/N6yJZ9wgBNpWR7Lm2iuCXGSuwlpEnITh8b2FPrI/gKaBLxZQdr8iF7J+yD245D7oAHKdFNlfM6syzH5BVPDE6rn75nB5IG8XM9EjRUxG2hhLiugEYpohaLAtJuCqjYd3uR2H2BbbrJWFcA8qWyEtl+4K0w8x7SHtc63p+mbQtoefCX4GbRYbIsproMvtxbW8rZ9dgjxyKuw/3wA720GzdCdgua87+sasy/o52KJPblUMEmkcSRQ4G11hJnmY7kAXEPxzQ1tz2SRwFf1ebYXUKsCP0UxiHpQTw7GirmWJTCUSGXIBs4AFDSTNu4X5ii1Sc/9sVYnvv1q1/Vy2eEJC3Jfl/YE2hNTJzj9YsDJPvVKwcL88BgSXFeBmS/skturNQuIFvXR1v0dpcBTDkF6rfVhiLxYFgO7LYcQCNUGGd1WFcPM6fBTwjyqvGZnPuSU0CH1IKAIMmyiDklTMJ/YUELyHKOREWeG/i+26AiYFwVAtnAvC86ehsTEIvz01evWwiN8
 iC4SlRJt
 xlUhYjEzSp7kTjal7NoWNGZ4qNlefJtQbYmbeWW4L0vr9c7ieWGlvz1OtGF5W/Z4o9HCixBZOAUjgQ/ypMPWm6zeaoRJT7uxkO7ZB1un7oaDrMyZNUwOgUFl6kQ5ZcXHsJXC0SDIFvSRP03RgICB94hjy3ETeXMZlBp0RmWNHlnrEmnSvhk2+dt678S3x5FYKWIF5ofUzKs1PiiX9V/fi2C5aczKSImRi2YMtVojUhsfm0LxVe4R+WOV2hCwcI+UHqS8dXyZoeHZlxI8O0cgR/NCNedZSZbZ5LVIk/Au5GpxYwITCzgchLcL1mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The template fast path currently uses memcpy() for the actual struct
page copy. Switch zone_device_page_init_from_template() to memcpy_nt()
and add memcpy_nt_drain() before memmap_init_compound(), before
prep_compound_head() updates overlapping tail metadata, and before
returning from memmap_init_zone_device().

ZONE_DEVICE memmap initialization is largely write-once: each struct
page is populated once, and most destination cachelines are not expected
to be reused immediately afterwards. On x86, a regular cached memcpy()
can therefore incur write-allocate traffic by pulling destination
cachelines into the cache before writeback, and can populate the cache
with data that has little near-term reuse. Using memcpy_nt() lets this
path request non-temporal stores for that copy pattern, which can reduce
cache pollution and avoid part of the associated write-allocate
overhead, while architectures without a specialized backend still fall
back to memcpy().

When memcpy_nt() maps to non-temporal stores, order those stores before
memmap_init_compound(), before prep_compound_head() updates overlapping
compound metadata, and before returning from memmap_init_zone_device().

Keep sanitized builds on the slow path so KASAN/KMSAN retain their
instrumented stores.

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

This reduces the average rebind time by about 60.4% for nd_pmem and
56.4% for dax_pmem.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 60794050bc07..eb8859a62f70 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1068,11 +1068,21 @@ static void __ref zone_device_page_init_slow(struct page *page,
 
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
@@ -1117,7 +1127,7 @@ static void zone_device_page_init_from_template(struct page *page,
 	 * to the destination page.
 	 */
 	zone_device_page_update_template(template, pfn);
-	memcpy(page, template, sizeof(*page));
+	memcpy_nt(page, template, sizeof(*page));
 }
 
 /*
@@ -1188,6 +1198,15 @@ static void __ref memmap_init_compound(struct page *head,
 			zone_device_tail_page_init(page, pfn, zone_idx, nid,
 						   pgmap, head, order);
 	}
+
+	/*
+	 * When the template path is enabled, order the preceding tail-page copies
+	 * before prep_compound_head() updates the overlapping compound metadata
+	 * in the first tail-page descriptors. If memcpy_nt() fell back to
+	 * regular cached stores, memcpy_nt_drain() may be a no-op.
+	 */
+	if (use_template)
+		memcpy_nt_drain();
 	prep_compound_head(head, order);
 }
 
@@ -1257,10 +1276,26 @@ void __ref memmap_init_zone_device(struct zone *zone,
 		if (pfns_per_compound == 1)
 			continue;
 
+		/*
+		 * When the template path is enabled, order the preceding head-page copy
+		 * before memmap_init_compound(), which immediately updates compound-head
+		 * metadata. If memcpy_nt() fell back to regular cached stores,
+		 * memcpy_nt_drain() may be a no-op.
+		 */
+		if (use_template)
+			memcpy_nt_drain();
+
 		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
 				     compound_nr_pages(pfn, altmap, pgmap),
 				     use_template);
 	}
+	/*
+	 * Ensure any prior template copies are ordered before returning.
+	 * On architectures where memcpy_nt() used regular cached stores,
+	 * memcpy_nt_drain() may be a no-op.
+	 */
+	if (use_template)
+		memcpy_nt_drain();
 
 	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
 
-- 
2.20.1

