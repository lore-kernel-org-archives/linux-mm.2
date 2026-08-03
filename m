Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE8E2C55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 07:12:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A273D6B0096; Mon,  3 Aug 2026 03:12:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FED46B0098; Mon,  3 Aug 2026 03:12:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9160A6B0099; Mon,  3 Aug 2026 03:12:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AA166B0096
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:12:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D2FBDA1F6D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:12:22 +0000 (UTC)
X-FDA: 85059089724.16.40C354F
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf28.hostedemail.com (Postfix) with ESMTP id B44D4C0006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:12:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=q8zou163;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785741140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QzfOHUwPwTz47PHoxHFvnWj+LzJxz+4qlyd4fHURS/o=;
	b=TE21QXH2AdS8FyiCi7q2B2XJFe2rlGNH4G+abe83R5lO96CV/gb3IBm330G5euxUpxUUGC
	04uEZnDmbt6oZ+r9nNnMfe0fRUdFdhB/UbpCafH2pa6o95uEUSsBxlklyKcJ/6fR1M1hnD
	Scp3L6wrzVLdhz7aJ+c6h0YMGCGeEMs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=q8zou163;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785741140;
	b=qbRrjZpkP0Hb+UIUQqLREIsB+HM5TXsW6jI5CE3MNpz+2g0kN59AekUxjoKLBsfLdeRa2n
	a77yzQFxH06Djl9LsFeXkG3VEOB35mqeKYMKkWX5S4ii/1a8nxMjBkFbJ8GqqW2swEfzj7
	mErT84ob826K8a/u4jtrNzOIMcMa/KA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785741136; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=QzfOHUwPwTz47PHoxHFvnWj+LzJxz+4qlyd4fHURS/o=;
 b=q8zou16300MC1W7e7yPTXD2oBxSau3+ECrMGu4Ox9gH4T6m08yOozCUPdBV2eVgDGm8BOJ
 ab2FVeJjik0zfvtMHi71aSQd5AdyQC93QXYW2S0UuRuUXPrvFCKZfaFF+JwIJCZauBTuuM
 3wbrPUaZdc6WcY4mCdfoi5Paf7hScsATlRpWl4DJeYG7NahTGRgh6hM3bQZ8ZXL+wHE3/1
 EaP6xySaFLbaMyWRGmVx7km+biMvilhW5mValFov+uzcseMaiIj6/XIFg+O5+qYoulOWmv
 fKWFDjQY3bP7c70sn76X6acCulGvywDvBurjl40XwfsNVb6by8JYYE7+DPsQRQ==
Subject: [PATCH v9 5/8] mm: extend the template fast path to zone-device compound tails
References: <20260803070929.86075-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a703f4e+41f923+kvack.org+lizhe.67@bytedance.com>
Date: Mon,  3 Aug 2026 15:09:26 +0800
Message-Id: <20260803070929.86075-6-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <20260803070929.86075-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B44D4C0006
X-Stat-Signature: rcdgixau9dtxnj6xip1o614h914bdhkp
X-HE-Tag: 1785741140-601202
X-HE-Meta: U2FsdGVkX1/GstHyYC12PJIBqpQFTPKUMMGAUqfx35SMbYk/jtjXN+5Guj9wtpMVEAnrSM8Rqs5F2rjDG34tgsRgDlYFoHBuzLFdGHL7JXRLzU22RhkwykbPsOvyyQjF2anlQNE0jU7DdPF1P96BRb5oMR/QC330m9HUb51O8xk7TPP2LXzjnzCpx5/b/OUQf7BR1PYLtEZdRV6CyUOCeHI/aUv7sklP8MeU2w199uel4tQJIMQDCoT20wd53CCljd4zlOJnIzlVW1K2hUo3JG3+Tkd///YpRtNDK4q+uPNHDAIX2z0/aW1KJLzDc1Y5f3YvFgZ3d/McRR7+iZVMmAc3F0Qd4Zkm38IEYiuCogQ3b7m8lqSlQHwfX611TzK6MaYd0w7esndFR63FkRKYTkmdjEdmRJuZW5Yeaz0uXJfM/eYIqwt3W1mI7Ux8Wb1gOmJTsmubJVYS3M4+S7Ovalx83rVECYfpZe4+WHf/ZxOyHFPwx6ynhTPLNH9LXxnbX9MTZHgGuWlYkzFdrQXstFQAMOW2/hAafrlH+8soBXUCSYuYysI3XsznNMugfK/hSciiUxcKIZgrSnHv9TjhYjTHLDz5fCdBhsrB6/b692Hyz8E/knhXIS1NVtKLvZ4EpXKFTs6cwtEl6j6mvJMT5FMafs6TFDebm3EicEACs2pmqNEXn66/jtuFV50Z4qZsiWr6fPEv2IxQN/ZuEwwJtsCyeKHobnQbevadP3Z/gr/Jevxpl/zM3c+AoUzL8dMLBpGLmKtdE7jA9+PIZSWUSXpPPZsQGCVTxdEVgp9M89ogph/d+DcvJ9yK8B/o0RiyjnUtva/X8rdvfExxSCsFX6IK6zFT0QFiEUE+vUfq5CkVpq94igM7oLH4vo0r9ld8zyj9gCoEjC2d0/VAndLSZt5x3xm7MvLDVC+6SAtL+avbZVQP3KZRIWutspEaRFV/DetNU+EarMrKJXjeRRD
 893y8ufV
 P6amys8e2CTKYWEpXgs6lRdmx1sGhXMZ+AqBlygE3/+nZTUPsrzolum9PkafGejDRxlzaaQsKFTrclI1bxsrOZB9P+1ipk8bhkzx5nhoweIpxxZ9i0VlCEISVXZbNIP2gJaoCn9LUA9MD9ifdmqF4nyiWtwb401p45Ub/hp5F84v7ys1DVNmSry3Flg0Y3sodj3rml5ybYhIg33PW4YSyQ3NCeELr7Aq2A02r9gqrTUGyH4yzye5s2c5HBqY7pHT1ZaSes7JxTR4MppM0holmn2Tl9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The template fast path from the previous patch only accelerates head
pages. Compound tails in memmap_init_compound() still go through the
zone_device_page_init_slow() one by one.

Build separate head and tail templates and reuse one prepared tail
template across the tail pages in a compound range. Head pages preserve
the existing refcount policy, while compound tails always start with a
refcount of 0 after prep_compound_tail().

This extends the template-copy fast path to pfns_per_compound > 1
without changing the existing zone_device_page_init_slow() helper.
Tail-page PFN-dependent fields are refreshed in the reusable tail
template before each copy.

Do not keep a separate non-template fallback for compound tails either.
This follows the same simplification suggested by Muchun: these pages
are still under memmap initialization, and the initialization-time
refcount updates are not part of the observable lifetime of pages handed
out later.

The impact is controlled for the same reason as for head pages. The
first tail page still seeds the reusable tail template through the
normal tail initialization sequence, and the copied tail pages have the
same final initialized state except for the PFN-dependent fields
refreshed before each copy.

Tested in a VM with a 100 GB devdax namespace (align=2097152) on Intel
Ice Lake server. This test exercises the dax_pmem rebind path and
measures memmap initialization latency.

Test procedure:
Unbind and rebind the dax_pmem driver 30 times, collect memmap
initialization time from the pr_debug() output of memmap_init_zone_device().

Base(v7.2-rc1):
  Average of rebinds for dax_pmem driver: 273.31 ms

With this patch and its prerequisites applied:
  Average of rebinds for dax_pmem driver: 244.37 ms

This reduces the average memmap initialization time measured during rebind
from 273.31 ms to 244.37 ms, or about 10.6%.

Suggested-by: Muchun Song <muchun.song@linux.dev>
Suggested-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/mm_init.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 56a36a71ba89..9691fa2a060d 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1065,6 +1065,16 @@ static void __ref zone_device_page_init_slow(struct page *page,
 		set_page_count(page, 0);
 }
 
+static inline void zone_device_tail_page_init(struct page *page,
+		unsigned long pfn, unsigned long zone_idx, int nid,
+		struct dev_pagemap *pgmap, const struct page *head,
+		unsigned int order)
+{
+	zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
+	prep_compound_tail(page, head, order);
+	set_page_count(page, 0);
+}
+
 /*
  * 'template' is a reusable page prototype rather than a strictly immutable
  * object. Most ZONE_DEVICE fields stay constant across the pages covered by
@@ -1126,6 +1136,7 @@ static void __ref memmap_init_compound(struct page *head,
 {
 	unsigned long pfn, end_pfn = head_pfn + nr_pages;
 	unsigned int order = pgmap->vmemmap_shift;
+	struct page template;
 
 	/*
 	 * We have to initialize the pages, including setting up page links.
@@ -1134,12 +1145,26 @@ static void __ref memmap_init_compound(struct page *head,
 	 * the pages in the same go.
 	 */
 	__SetPageHead(head);
+
 	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
 		struct page *page = pfn_to_page(pfn);
 
-		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
-		prep_compound_tail(page, head, order);
-		set_page_count(page, 0);
+		if (pfn == head_pfn + 1) {
+			/*
+			 * All tails of the same compound page share the
+			 * state established by prep_compound_tail(). Reuse
+			 * one tail template for the whole range and
+			 * refresh only the PFN-dependent fields in that
+			 * template before each copy.
+			 */
+			zone_device_tail_page_init(page, pfn, zone_idx, nid,
+						   pgmap, head, order);
+			/* init template page */
+			memcpy(&template, page, sizeof(*page));
+		} else {
+			zone_device_page_init_from_template(page, pfn,
+							    &template);
+		}
 	}
 	prep_compound_head(head, order);
 }
-- 
2.20.1

