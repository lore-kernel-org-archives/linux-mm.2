Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3D7DC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:08:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE8C56B00B6; Mon, 20 Jul 2026 08:08:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0276B00B7; Mon, 20 Jul 2026 08:08:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB17E6B00B8; Mon, 20 Jul 2026 08:08:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B00E6B00B6
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:08:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC09616014C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:08:05 +0000 (UTC)
X-FDA: 85009031730.12.A22B966
Received: from va-2-115.ptr.blmpb.com (va-2-115.ptr.blmpb.com [209.127.231.115])
	by imf08.hostedemail.com (Postfix) with ESMTP id DF4D916000C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:08:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=VWU3ZUE8;
	spf=pass (imf08.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784549283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avcd0GvpHsHr7mxbfL1p/CzBnaA4uWaToeE7s1gnya0=;
	b=aPOEq1MZhHZmat9Xv1tVbdY8XtJI68IHDZ721Hd2pKTexa1jd7aj9H3MNg/XYaPJe5Qjuu
	dwP0d3EejdWsANO12GmTttHhNU/NCoXW+KeCvV+g0LCl8X+3Yl1CHX8fhqzWm00GF9yfk4
	I+KoZ42IA8ztq42BOPss1rUiGY942Dw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=VWU3ZUE8;
	spf=pass (imf08.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784549283;
	b=8DpcuPGbhZ6ZTIx3afYsaFC0HxRjfgS5fakHNrzF+JOUEc0P2kSrNDz/33j9mq4/Zp33u3
	E/GHaifqreP056d9dqLRjGlI25Aq8OgXWPJy/LpfEk5W3Vo2j2BWV4S0l7eBPl4NJpP00F
	f5fB54naYtuoOVW202q/vlwEoYNJC8o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784549278; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=avcd0GvpHsHr7mxbfL1p/CzBnaA4uWaToeE7s1gnya0=;
 b=VWU3ZUE8cWZh+o3D8L2Nl7R/fjaWU/75RGkcWxynmyrWaZ1jAD38piQKSw3e/SMo73XISM
 sqZ8b5YI3xVakILgJlYrluPosvj7OQJpcjyCIkTxCf8VrNm1A4OsxU5s672uJK6lUMo1ZI
 h4NMfRx6rkbRypNGi+liJQ0yi9p8YVB7ozKMxjB3sLrEJmnhxQdAehkpPIIJwMR7ZNkgKo
 93YYXvgBaSFO6fdchYI/nGgEiLJRdXyi662cQryep4zgucg/gno9CNDe28dMuhUjrMPSHG
 8F2jRoylP7SBVlOUlX7xbkRUIj4PX0x07h71fCsSJRPhfYA9vLr7vr36ZGJtaQ==
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>, <muchun.song@linux.dev>
Message-Id: <20260720120259.1545-10-lizhe.67@bytedance.com>
In-Reply-To: <20260720120259.1545-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a5e0f9c+cf0c81+kvack.org+lizhe.67@bytedance.com>
Subject: [PATCH v7 8/9] mm: use memcpy_nontemporal() in zone-device template copies
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon, 20 Jul 2026 20:02:58 +0800
X-Mailer: git-send-email 2.45.2
References: <20260720120259.1545-1-lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: DF4D916000C
X-Rspam-User: 
X-Stat-Signature: gqyhubjm18oh1hfp8eis9g8bt594ta4y
X-Rspamd-Server: rspam04
X-HE-Tag: 1784549282-471223
X-HE-Meta: U2FsdGVkX1/JdYDaMwOR2WNsdTbXsKNVgDCwgFhL+sdHlPTOIVNrxyfp15ZWPgztu+3P7/5OcyqfBKY+0xv1wuIOdNmzEfSSP6hSnyOkN/KYcD5pC0l5uSsmQGjvXB20ofYV4RzVYDclKWhm/IN4uAgMyk2Vd8mWIeSTvAv/Vj3wT423e3huPTtqGKt5V3vJKeBwhnxGO+t2+EHTTywokyggMXmVRVH1Oa+kek9Ix8KhcgR/vrTKLQKZn4BRS4RZBc8DKc+fTdfLsWHDfD0Uzt0iZYDk3BO0a8OBj401lgD5DcLzgtgGjs2S3BNNN8lhlKq2q6OcPqD0nAJWcWEbJ+bKbdIyjb0UQJ2zY/VYKHYhQR8Q5NdNACkJ49jWBUU42EsZlgKmmGgaqD7DN5ZJqEIJbCm/1Rx/Al0Gili5/SJlRcCkaJcH4q+q01QGG5iTIJbcbdXddKgK7qB6KZ31GcCp21aoEwj8nlSOPeqwdkaTRgOdLcWETSNolXH+Jyv/8JS3eQioGbhPwiMUhwbO7S1saxF9PL1CXQXTvSimCYbJUs/zqVH1kBkS61JqmT58u/j0KmfBNzKGC8wky/QmKcZuBcKPJR2IvtNodaXiK/7eV3UEOaxJnxX4rMyXHAIm/LzwO+apcaXHtUIRTrDplPoPHRPRaM6DLEgOQOc8A+AGw/okc/3LBcl97zbrA42MEm1Oz7JNRVpOV335jQ0kEYM+59hme/L62DgUmCo0THRk895VQBTCOlCL5m7WhLINAYjpN9QlmH4YD4vHPr75luN4eaNhe2qAh+z6aQJOZ1dQQC7sD+qY7oG7Pds4OetgPfCzXbxqwLX77g9/5RvWR4G6b0fK2bCyp8oy+8nAf4ItuYZncusqXF2Of14jWTyZ8bp6A1xVv8DKB4jI5zyet1RCmOUhIDwaf1PcsRLfY7BxAcVR3EntdRTZihAmGNxsmpsp5hRAAjwXoCb3lfb
 9JwBORQG
 EJP3TW60WklaWPAuOD9RSSCuJk/4wrIpzDYrcoj/kFNEpjQeDk6VeSvFS02FwmL4fbPr9/wzusrJ2Vrjq3J+sOv8c4RZaqgjO/FKvJ5FyyflQuFdA/7pyj97kdAJ8O9E4siyvQKKWKffiVMAaeumZFz3IcWuNOxMssF1329N9N+ofT2XMBlkqhccA9k/zCtQAirHkyHTBTGl5IIF2ON18mqprRtDzrGmdA8y6epkdDMURZnLbeqEJM/aSTbbMZSk9GAIu97t5YjS8CxGFTTzTJmLFFBcCSMfSTZThWD281k7WucKB3w5N0sndbQ==
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

