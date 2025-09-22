Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A754ACAC5AA
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 02:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BC0D8E0007; Sun, 21 Sep 2025 22:15:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093748E0001; Sun, 21 Sep 2025 22:15:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB578E0007; Sun, 21 Sep 2025 22:15:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D93918E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 22:15:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 84235C0452
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:15:20 +0000 (UTC)
X-FDA: 83915269200.04.A43AB66
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf11.hostedemail.com (Postfix) with ESMTP id AE80F40005
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:15:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf11.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758507318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=SPCqIDb+yNYcV+5yEAWwdEaCDvI8BD77bbTSTfws3Yw=;
	b=vexcbNczGL5UlxLBfdHX3qbXtmllu4XIqBoeB9wyH0A9GQJFrqpa7Yx5KctH1ICihiR8pE
	Y1/8MYz7wcZG0Pw5m5LKPQaqjr1x/gLmg+ljfzbg92aZwysrUwcG5uDXIdGjiMYiVyNJON
	88eiPSHwT++c+yWeR/gGVPEJsSnseC4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758507318; a=rsa-sha256;
	cv=none;
	b=nvFPCJKp+asWzTXg+TPRdRhY0Annkh0TO17kxUhpjA3vLf6ysk7NSGB125wnEawAykgtW9
	uCKln6zbotOd5OLpMRbVBEB2moJPb5t1DPOLFkBgj/5G6wCsYiDQLUyeSdNKunAN6/uVbo
	w2QSY7Zg19/rw/qTVbRgocq3gLNrplo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf11.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45de56a042dso23857515e9.3
        for <linux-mm@kvack.org>; Sun, 21 Sep 2025 19:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758507317; x=1759112117;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SPCqIDb+yNYcV+5yEAWwdEaCDvI8BD77bbTSTfws3Yw=;
        b=uQeRwW9XHg/P7EcROHGE8ogaZBuzMUjCRh9SogAIDLVFKfjjicbgiF6w6PVDjuznnE
         kZFXcEtQabDviGvLQMitrKB7eTQBGjkmNhR6U4wZEa5+VHD60Bc88l/CARXp6O/cB/n+
         wGEm3heRzuQowmmJH662Y0TflYilV0ogYbzUVZfeqgG0bstsZzd0O4uqcSogrWp+FJ80
         D7C6TP1H3SG0HFzj2SD5MuVM5f60vVD9TsemHcL/ka0SEAF45mG7O2FqpPAtE/9YMZJ0
         4OHQSbwgSmK2HjlSF+c8uh1c+tAVPDJeSyXj2mJgkSW2CAaW6BjhluFFMWkNMXa69KAs
         ASEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWmMey9AWyHBE0qvwEgcNhF6ASOSF7san5dX67RWuepxkiPS1spaTdQpJUNTPqpwjWRzKLLo/083Q==@kvack.org
X-Gm-Message-State: AOJu0YwbeRaV6MsDvMZyb3Qa+UWhWc48fHr3nS//4jBgolbSWQoYEkD9
	+gvFnw4zHK1z2QGjftbrwufWH+bGgsEqCzlWCtpnWbtkU6BX6XpSrMfu
X-Gm-Gg: ASbGncvD7bI9+/b/UZLzXr7leBBrBMVDM9FJ06sZnlsgwAVLzISXztpkp4vXN+OwrOp
	cRrVXm6FNawicWt5OO29sDf+UXo+94Iaixg4NQTPRzN0UqSSujmrCOLo5ITv9dRQnyJBh23iaHZ
	ZOExtp4knbFljoTDLztNgcVaekAUJrd3ZWH15uq+7BOo1+AIKhsNdVXCBPi3pK2+bpkEQ0+9dHc
	NsrNwhthZ/qH+ES/5CDwGKDgMvkOp+09SLBO6WD/13+3bq3UqerFVF3+xBXyD+8WnGMYSbHUQ9C
	Qy0d0e3HeI/HLZE9UD0KJeMKkwT1TAYQtloOS+7ya7+T4OWZNM0PmmMs50fvK7skZJ5RgLyQ7+N
	F1N4yRZfg
X-Google-Smtp-Source: AGHT+IH9s1cY1E+H2vTOe2w6B4oa+af+uNdUi3NtjrXEcg2rWJv7ohFVr7kLsZhy27UnUnTj0ObGrQ==
X-Received: by 2002:a05:600c:630e:b0:46c:9e81:ad0 with SMTP id 5b1f17b1804b1-46c9e904ffamr24190015e9.0.1758507313301;
        Sun, 21 Sep 2025 19:15:13 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a09:0:1:2::3086])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4613dccb5e2sm220376635e9.17.2025.09.21.19.15.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 21 Sep 2025 19:15:13 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: usamaarif642@gmail.com,
	yuzhao@google.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	voidice@gmail.com,
	Liam.Howlett@oracle.com,
	catalin.marinas@arm.com,
	cerasuolodomenico@gmail.com,
	hannes@cmpxchg.org,
	kaleshsingh@google.com,
	npache@redhat.com,
	riel@surriel.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	hughd@google.com,
	willy@infradead.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	qun-wei.lin@mediatek.com,
	Andrew.Yang@mediatek.com,
	casper.li@mediatek.com,
	chinwen.chang@mediatek.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-mm@kvack.org,
	ioworker0@gmail.com,
	stable@vger.kernel.org,
	Qun-wei Lin <Qun-wei.Lin@mediatek.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing zero-filled subpages
Date: Mon, 22 Sep 2025 10:14:58 +0800
Message-ID: <20250922021458.68123-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iwm9ecp7rdg45zenr5u7opiaj3y5ta59
X-Rspam-User: 
X-Rspamd-Queue-Id: AE80F40005
X-Rspamd-Server: rspam10
X-HE-Tag: 1758507318-180093
X-HE-Meta: U2FsdGVkX18s5QQWhYeRYZSNC9TVNYHpFbL4W1b/QymMRCzqwpmO9wNdpf7JvVC3UimPuLjIk5D7ZIlvCpcpjo3z/4Jzi2hGj/vtnTN1+W02eBxz+0taqB3fwR8L+A5aNLQcMF+mwYcP2zF1ncoCLF/1O0im3tpPKQnZ5oJgzV8vUK5mULpggBPKPlkKZ+CTqu2elU0PxJBRtdBPrau0cMKVURZTMX4HsUbHHEXkfbNxPI6CUjQPDo56Lremf5GmM8QNobewXmwYhyYtXconDacH1oz0c10u3kdYIcKAh27f1eYCnbN5e9DjZ44mLwub4dqupQRpNU8eVebUjLYvKsCcwUqWO8P3Bsv4mdsileXdWvHrS9L1IltZ/B428chzbQxgIhfFpIuf3N9JB1XbMad4EzfzygG8CHhdipRIg13sz79lxO3RXdFz9pTD3uKA/zAKp7ij1oNpD4AvzS9sf0el1Zn06mIFsgVP5N6DQ0GxbomrzY2ndRBrF334VwO2AGH9Bgsy8nGy9SJn7/8Vh5/xZm5bfaENypnFv4bk1VmG1kPM0saSg43X8PyHYWIerCizKph+0mir2yjvNOdQgsV/XAnpR1GyzfEbvxMX+jsZfUFrMSl4tAjI+8m83saoDkxwIloh5v7wuLeDAHwOnHzLNh5tyF6Eg43KIUp2va3dKbHtGNnZIHW8ULrh1Z9n1WL+SapnQh7bYHccAKVEOdlnDDnc4NRJsG3Buo+dTHYr5VgGfk3BjGWSpoiC1baI82t43F+ymiFYTT2rlZlEPnuukprQWYDgPKxAIIHeQ0anRbAZBrc8tglqOtye2krEsY7jLNnGl8KRDGYjUzJmiy6wVYQChjd/PheIwbDRfw9CafJrsnMWqwSI4Llkcwde8jqIudcRX/ooO+a9wK3z/q88GBrI6JUBelnj8DInpqNutcBHt0MjC0byJ5p3B3PuMPXUKbt4oBFcEZ4IEMo
 4JmQ883f
 7cGJfnmvV9tWp5xSv0aHgzxokPoRLA0pDvm6Gd/lYTkh8BgpLLGh1OKfFe9Hhhnc58Usd+1Ye8Zw8Ua/U/7FJABJAqtTMw0FilJjR2QrubfNjco16UWFs60RS5DoDt7uNGMQuuZ4vuRgaXmBeVKtNiY5u4kOTgH/5vKaWmA6Z/Euqq8SWPEZYipa3MX+bv4T/LWr9sI04xddCGGdyXJal/tfrA8MyLy5YSv3HNdqo+YdcmDjWZNAEQ6tsP4xx1gV5Mlc/sDTtO065rDvHwkIn3xe0zMfZylr2w2mZEmw+zywfGvXe7L6tVoFbqlxS56xq0Nqnc1HaTSoQBxTR5Zo1fMLZnWoty1e/38Xgh7DPuHcuZXGITxG5BX3EFZp7BJlb+TbPbc919+fVCgBbrN47iUY/+Ga89xjXyw/V+WF/0sCYxCZByo8Hud9qd4JzmJ3vIYGFsKlaZ5qIhH2q3QI/Q4swNjymArAE6cbeLMxEFk2PlLXaOjENecyDupPuzHOtfw4sX4J+K2S29tiXlFiz3+/u8s1HfIxVXKlibGLzp0z5DMM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

When both THP and MTE are enabled, splitting a THP and replacing its
zero-filled subpages with the shared zeropage can cause MTE tag mismatch
faults in userspace.

Remapping zero-filled subpages to the shared zeropage is unsafe, as the
zeropage has a fixed tag of zero, which may not match the tag expected by
the userspace pointer.

KSM already avoids this problem by using memcmp_pages(), which on arm64
intentionally reports MTE-tagged pages as non-identical to prevent unsafe
merging.

As suggested by David[1], this patch adopts the same pattern, replacing the
memchr_inv() byte-level check with a call to pages_identical(). This
leverages existing architecture-specific logic to determine if a page is
truly identical to the shared zeropage.

Having both the THP shrinker and KSM rely on pages_identical() makes the
design more future-proof, IMO. Instead of handling quirks in generic code,
we just let the architecture decide what makes two pages identical.

[1] https://lore.kernel.org/all/ca2106a3-4bb2-4457-81af-301fd99fbef4@redhat.com

Cc: <stable@vger.kernel.org>
Reported-by: Qun-wei Lin <Qun-wei.Lin@mediatek.com>
Closes: https://lore.kernel.org/all/a7944523fcc3634607691c35311a5d59d1a3f8d4.camel@mediatek.com
Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
Tested on x86_64 and on QEMU for arm64 (with and without MTE support),
and the fix works as expected.

 mm/huge_memory.c | 15 +++------------
 mm/migrate.c     |  8 +-------
 2 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 32e0ec2dde36..28d4b02a1aa5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4104,29 +4104,20 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
 static bool thp_underused(struct folio *folio)
 {
 	int num_zero_pages = 0, num_filled_pages = 0;
-	void *kaddr;
 	int i;
 
 	for (i = 0; i < folio_nr_pages(folio); i++) {
-		kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
-		if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
-			num_zero_pages++;
-			if (num_zero_pages > khugepaged_max_ptes_none) {
-				kunmap_local(kaddr);
+		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
+			if (++num_zero_pages > khugepaged_max_ptes_none)
 				return true;
-			}
 		} else {
 			/*
 			 * Another path for early exit once the number
 			 * of non-zero filled pages exceeds threshold.
 			 */
-			num_filled_pages++;
-			if (num_filled_pages >= HPAGE_PMD_NR - khugepaged_max_ptes_none) {
-				kunmap_local(kaddr);
+			if (++num_filled_pages >= HPAGE_PMD_NR - khugepaged_max_ptes_none)
 				return false;
-			}
 		}
-		kunmap_local(kaddr);
 	}
 	return false;
 }
diff --git a/mm/migrate.c b/mm/migrate.c
index aee61a980374..ce83c2c3c287 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -300,9 +300,7 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 					  unsigned long idx)
 {
 	struct page *page = folio_page(folio, idx);
-	bool contains_data;
 	pte_t newpte;
-	void *addr;
 
 	if (PageCompound(page))
 		return false;
@@ -319,11 +317,7 @@ static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
 	 * this subpage has been non present. If the subpage is only zero-filled
 	 * then map it to the shared zeropage.
 	 */
-	addr = kmap_local_page(page);
-	contains_data = memchr_inv(addr, 0, PAGE_SIZE);
-	kunmap_local(addr);
-
-	if (contains_data)
+	if (!pages_identical(page, ZERO_PAGE(0)))
 		return false;
 
 	newpte = pte_mkspecial(pfn_pte(my_zero_pfn(pvmw->address),
-- 
2.49.0


