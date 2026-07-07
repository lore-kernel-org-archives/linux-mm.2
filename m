Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 033A8C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF2B56B00AD; Tue,  7 Jul 2026 04:27:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA30D6B00AF; Tue,  7 Jul 2026 04:27:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B926F6B00B0; Tue,  7 Jul 2026 04:27:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 842796B00AD
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:27:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D12C1A039D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:27:12 +0000 (UTC)
X-FDA: 84961300704.13.8A61487
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 780261C0003
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:27:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E1ToZpjs;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783412830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kunGe7C6xhIHkVZkIf+Bq+1kDqvK88lHrFnSbrffnn0=;
	b=3btJrUL61HYFDjMLML5S2/VLy6jgTS+09BlojbzL0cgGaHSftkVNH5a6yimqVMnKlRSQTw
	1FMPWJ/GuKDuuQdFRL9BGU4TTdnNA7QdlAHQp26eY6hvOe+vtPwZ8LEJdqEMqkrk3vGAfG
	byHIywJPG4tInVz+k0uux+IwElq/kHQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E1ToZpjs;
	spf=pass (imf21.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783412830;
	b=2zaaFQJk8OmQI7Qg0S+KP1rvVmEj5TrnmF56edcOqjtnqWsxGX6FeedXJkKl8S5Q1aortz
	PaeR9ocikzQNZXqRp3TcJ3Y+QG5ftUFCeinri7ExGUvOlwKLh5jLlJ0NwYyzrQar7vSExr
	UeEwcsIODIX+u8z6vhIGCiE742/CTH8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783412829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kunGe7C6xhIHkVZkIf+Bq+1kDqvK88lHrFnSbrffnn0=;
	b=E1ToZpjs6T/cz+vDQt6MGrXm0A7R15ZuLJLHP4nKgxCUu3MT0YHbr1Fvv5KfvXYEesKeuN
	twvE70zBSHlua21537cPep3rtagx0khoSpr9TlMyVr9aCYDw8HJIib1ziY0arOYVKXVn8h
	MxPYicDyDEXojEh259wHRFVndpnD6yI=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 05/10] mm/swap_state: restore Redirect entry when swap cache folio is removed
Date: Tue,  7 Jul 2026 16:26:07 +0800
Message-ID: <20260707082614.95030-6-baoquan.he@linux.dev>
In-Reply-To: <20260707082614.95030-1-baoquan.he@linux.dev>
References: <20260707082614.95030-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 780261C0003
X-Stat-Signature: uoikcuqiwi41d1xeeqxkt54kka333yzn
X-HE-Tag: 1783412830-899777
X-HE-Meta: U2FsdGVkX1/JIUOfm+x8LWI3e7h3orkVrnTOmp3ijl0D0r5qbG6jSchFEir0i/DkJJRrpeLluHxSHmxP+3dbWATTkGCUG/FZOEV81pzqi4mHcXoSJHImOtNuLKBHYKqGO3W9QKFvqcv82b3+2+0kcl8vI66q2z7RkdatyhuYb6ZAVH8jRc37iuWvdGoXdPPDC8pjwuJR0BQ2Ni9wOZW5QS1aQ0HNiXGuZUegep2p7yFCDpS64u2RzoIDirWyeP5FREUGuiG6UaP0PGwq3822BUaSdcOjPEfOO688BocFrEVh97d3AZkXhrVV+YfZJZgKH//JvrCFEWQFnh/YI333zHI9EYA8WXzYVoO9VfOt8GIYF0ka4HEhkunvS2wDFkxrhZSZOqi7IWELqj9/NJY684veHqaTZXFis3PwITiuVNgBko8h7YrBuUZzgNukoCRrkwNbafQg/8/MN7LksmS5+qZGSjeRcqBOFFMBW7VdZWuZLCUBz2QtkTaR6QZ7CZrSA9H91fcuAEZbvqaTuDoiDraNC0tdDMeOeZ845BK6MHwtMKm9ZmVLujZ00UAHbbamE7grZvpi5IoHGPG76TAIqOcph8yPVVtQ9LZ2g9KIm9xVtgf5Ry5qjs/xCyu8Av097Zr9tsA7DB1NPSzeIgNJBawkhd25aZoCx9Z5u5rnzN7sWPuUMkOJ2wch6rKaZcPxr6PcgUAeB5BZ9WGxXH3IvyjDXuoSBmJAPNWmoAAA9IF97MqjH3/2sYdMaaj1YBv1Ztx1t6WrH03OE7+EYvNpKLiqmUfQ6UlLZferyN9K7TNZRqYW19C/xLh2qINY4GECiGFwxw9Et5Nb5b+S40zai9iZbhLc84c2wPhk2JUp0P3VvR0hz+DhxNntgfw8e5iZk+jTJas1GGy5MrMeYL0eEP/ggjs/ytLe/+zJneSJcK4Z7FpxNWLLE1c7l9TvaU3DXO+jbZcmjkxBPTMT1OB
 cOp1Y1IO
 4PdSre9c0aMHjiXCg7Gl11y/ghWqCLViMdAyaj2NfUMkwEQ/wtmDYfWp5049EQF+b6ogHUXAyg115DoQS2I8LB7RzBbl+w6BfUdXHLjG+xQVnbtu4xjzDdbvZxc9A6CMNFqhGLV7Gp1Y+qxA/JWRQi587w60JBWA+q1qGlpzQvgKLGG5J8OxI948aqlH3RqfJM/etqxiOyvELs0woaPX7Id67EMiungQShU4bVfZLSa6js+/FrVId3n14Hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a swap cache folio is removed from a ghost swap device,
__swap_cache_do_del_folio() normally restores a Shadow entry with
the preserved swap count.  For ghost devices, the entry may have
originated from a Redirect (zswap writeback to a physical device).

Check the redirect_xa before restoring a Shadow: if a redirect
mapping exists, restore the Redirect entry instead.  This ensures
future swapins are correctly forwarded to the physical device.

The redirect mapping is stored in the xarray during zswap writeback
(see zswap_writeback_ghost()) and persists across the swap-cache
PFN lifecycle.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/swap_state.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 5fb893cc7fce..cb2ed2a18f9f 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -12,6 +12,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/mempolicy.h>
 #include <linux/swap.h>
+#include <linux/xarray.h>
 #include <linux/leafops.h>
 #include <linux/init.h>
 #include <linux/pagemap.h>
@@ -329,6 +330,26 @@ static void __swap_cache_do_del_folio(struct swap_cluster_info *ci,
 				folio_swapped = true;
 			else
 				need_free = true;
+			/*
+			 * For ghost swap devices with a redirect mapping,
+			 * restore the Redirect entry so future swapins
+			 * are forwarded to the physical device.
+			 */
+			if (si->flags & SWP_GHOST) {
+				swp_entry_t phys_entry;
+				void *val;
+
+				val = xa_load(&si->redirect_xa,
+					      (swp_offset(entry) -
+					       swp_cluster_offset(entry)) +
+					      ci_off);
+				if (val && !xa_is_err(val)) {
+					phys_entry.val = xa_to_value(val);
+					__swap_table_set(ci, ci_off,
+						swp_entry_to_redirect(phys_entry));
+					continue;
+				}
+			}
 			/* If shadow is NULL, we set an empty shadow. */
 			__swap_table_set(ci, ci_off, shadow_to_swp_tb(shadow,
 					 __swp_tb_get_flags(old_tb)));
-- 
2.54.0


