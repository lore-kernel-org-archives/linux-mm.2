Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF29BCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 16:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 170B58E00A6; Wed, 29 Oct 2025 12:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 148868E0045; Wed, 29 Oct 2025 12:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085788E00A6; Wed, 29 Oct 2025 12:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1A418E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 12:00:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ADF621408AD
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:00:32 +0000 (UTC)
X-FDA: 84051614304.07.F305A8B
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id 970E320020
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 16:00:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AjZcERqs;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761753630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K65D0qkLQ24GtBqbjWxaMhnSplvMfrH+SnXenMqBLGE=;
	b=34l1CtVnc3Yk7YqgzZzhLUvRRHVIN8GoA1Y3QMZ1niHrY/aZCfhHlXQ02JN5voneSYDp9X
	kr9WjU1tNOU/jaAvbA39E3fXb6SyCzfnNUHxNV2srIgVWdOGV8517Q4RGZz/qqakO0Grgc
	fmOUvUQ/IlXL+7cIv6LpkTUyPRibpbM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761753630; a=rsa-sha256;
	cv=none;
	b=hj3NTDD4sLivbVRgPiorvooNGgUF+bxJTLkXRCXN2oxm56sUcq/qnYd8qkCSLuHw7g9ZvR
	cRAmfzi0W/LlXMFiGMOQ+U7nlkFT+GHt2nt2lrlRoN2AWgYogZ91xiJ33uMWYKxIhjbhiO
	8yVF3KWOnlyue6feNo9FQGk6LsaHHh8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AjZcERqs;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-34029c5beabso91235a91.1
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761753629; x=1762358429; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K65D0qkLQ24GtBqbjWxaMhnSplvMfrH+SnXenMqBLGE=;
        b=AjZcERqs3yUGZ88T8sMAU5MFbmpQSQte++KpirvTbJ+GkoJHKmbY+6Jjf7FWKoJY//
         SDNv6dgN9vK+PbdPfPamHByQ9f5+cCt9oHwo8400oFFM+q7OnRCdeZDjrYtmhAbXsSRU
         SQtYuKHdX8PA+uowDpSFg+D5zkDFVoebrv9Hbatilpx86AtyC2LrjxVy47KY6MF///h2
         tDPPCA7ngF6Yb/JNC9iqr78zDNxZiEIFHwDCu+FS5DQIvsp+hD6Hh7fIp8EO68nCfuH6
         eVHxzkaez3VtI397b0VvE9oAzsE1UnTyBunTfBKATqUol6ecR311UzHjyvhLYzdNwz9h
         ubYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761753629; x=1762358429;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K65D0qkLQ24GtBqbjWxaMhnSplvMfrH+SnXenMqBLGE=;
        b=eaej4dAcwZaEoH3XG7erwFYhJCS6EOnthLf1l3nGqaTHFaEhlgFdQ3h1+E+ZKTze3j
         5ixFF0zz4b3hPo+EEmyP3Y3gPf2r3lhXQYAMf+UNMWENJ19TQq0WAUF6UcZI7iMepH9d
         2BtkpqyUjLQv1vSpm+vjdbEWU/gkGM8Sz5L7v+CMDiyyGwDyGi7KZtJJ3QNQU/+pLA+A
         1X2SfeqcLNsmut2IZltnGw814FqFUwZ4WJFQbE0t+LPbg8Ggob8fr99okw1l3pmjy7wz
         d91YTzfpjncEVxpPWFofa3jlZohhv4Y9/Zh4ID2DpGxwVXkd6R632rPz86rK0FWZqDuy
         lSeQ==
X-Gm-Message-State: AOJu0YyFWjwYMXLLG2chiu3U6A7eLw7w3CKqz5xmjvrm7vT+UfYEtJAU
	astCZqY+JcT0dSdlycgNoq63+mpslg6TsJQyOH5cKNDB1gsnuX93kBiN
X-Gm-Gg: ASbGncv5i+6hsYytRgPdXZFwnciLlICHduyd2H6GQRo58uOLrJS3klMRtShflb7Jp6g
	QzzP5mz44QqNRfFckk5O5kphIGGg1+SrjeJVvIBKH0PGPyqGiF9g78wQwSFlXLRCed4g16znmUt
	4LVdcLz0M2aSsRFqsOwGEdPYWUOoM8KCv8PO7TnOl5aQLWTco+zrz1suV/4EvHH2RLOO+boLwqh
	iTjfzWTzSV24HFNRkYe2uTHSeEVLjJ6at1mk1DioYG3RUP6V6FGpM9XJg6aSKSQUSyjlMNEZPWo
	kTZNH5/wRy7Y1WlkcFJUItpWfZYlqsGAhwGf+rwm3/H4lOk8uyopaMiRRNKwQl4hJP8Ws8o0bfy
	5e7eL+FQEV+ZyBBrd2ylWQoiCBd3uCXc7V+x2xrT2hRyT3O58LuokPu19UJACkbHs6nQBGbUlMk
	CbcpvVBPVowokpBiEjNRks
X-Google-Smtp-Source: AGHT+IFfb91fHwDShHt72AqOZe3jp0hMtnf0fflVA79t3VxX8NtzmyOvdGrSfHzPbZg1N+wH4X3uXw==
X-Received: by 2002:a17:90b:48c4:b0:340:299e:dca with SMTP id 98e67ed59e1d1-3403a15c412mr3897842a91.16.1761753629363;
        Wed, 29 Oct 2025 09:00:29 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7e95aasm16087366a91.8.2025.10.29.09.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 09:00:28 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 29 Oct 2025 23:58:45 +0800
Subject: [PATCH 19/19] mm, swap: remove no longer needed _swap_info_get
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251029-swap-table-p2-v1-19-3d43f3b6ec32@tencent.com>
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
In-Reply-To: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@redhat.com>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Huang, Ying" <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam05
X-Stat-Signature: 3pm8wnwt98k5wcntyhrfyhadj5i7sbim
X-Rspam-User: 
X-Rspamd-Queue-Id: 970E320020
X-HE-Tag: 1761753630-82317
X-HE-Meta: U2FsdGVkX1+lYrsSF1PgERFJx+F5U//1LKtL9biiRz2wJyiXJjpJDeSLci/WKBX9v8WAvdtLv1xgDos6pWsORYfCdYXhqRZz/3Ygu0H9lWLPr9dPnjEEAM1xfXUJIH2pek7ZqF7d9uR9PJ/77nnyINYqohYzZrIZE7txW2GFBAoVDSzXdycLabuDwY0x1A6eUPl+8VRmYQZdrqdbL5Bs1pVRDNcx7e+p0sidqg0OtQaiYib6RUd2l/cjOLO0tYGXhG+F3FI7yCgNlEyK5n/yOclAs0ijiHTpZp4PvlrSzv11tn2uWVKRcXmJAHb+xBVPFDSuQLPI42zjU9L1Kp5x6gcH8F4v4h+prdz8kwDxLDWUA8GyHQRtPJBdhS4Xrlhtfpb2shrJPfNC5Lnr2WffZMbWimeCmAozrv+VwFPKO8d6wv69ypRoYekiLVsTUrRd1Ez+uUhNSXRqnLnEpMiqc0WzFHiAgzOWp/QRRtKzTuXXnfOejPNLtkpBngz5lEjltsHUQHBNyRTJgb8Bpkd2ycDl40ZtmLBsdzj44f9wlhLFF+jCC9hKFiyhO1D1Tu6sh8ndUdsKxCw25z+zl52HdPVr8XBBpCIzPnGGInmweDK+ShRMeahy8bxMnC0vLZM32wHW7NdRd+2hyBH3LIvHpLyVcgno/AvCgLkgx4cmzQKdOr+yQatSKGLLoFADiDJxeUE8A3A1L5EaRWHYOCK5NDvnw8p3qqHp0NcJER6mP+sIdV21vWsqNBEEtWgcgqq1Dg11YXWISDN5ezswfFSSrCJWKhE2LGJ0j92a/cxa2l/Pk0d8FGa92kH9h1eREKsojsFKJHNUB1XRLTHVbxsJIcEEeSVUcHJpMs2j4PlP7AXoybRFuJ+w5lTzjHEGc759e77zJ6cq47v5Fecy6BPnum4/mtlfopjqIb8HBWH4HzOEW36mO801u1OJlYyblhsMgTuEO9XtmCg/33V5WNr
 0cTaciRb
 T7XCRWlB9EXOMM6FNrtvedRX77z+ZSGnrqIhRjBlX3J0f3Tb3cQSb8qwkYkwoQAQOAQDbClbzd1f7Ghy20nOalnme4kMsmZoIm8JdfE3PeJLGxbqvn1uGtdwrexmhXlLm6D7lPnqU3rLIsJEa/2rdTxRy6Vzd02fZt2LWqgrV6w9wBhQsjSyKFKV3EZfbnH0/kRhoRD7bH2TEjRuAiZawi1nXWkHH4pJJSBKphdrxSUjTCELV+OhAZG4hurenhB7oMKvqlmjcXO/G0zS7Q8c99W/KyM1hsG/5KOJwOMPjEgbGp7TNY42eSl5pIaZzZc0iR/y0WHjmW0qIe98O5PhUHA4x54gFHkYOl2ifDO9XS8FihvRK7FZ6rWsdnyMrPJwt40UDDHjl5AHkxsHfwXZhrCrD2JEzIgM4/pTjMvySXzUIxSspabLVBz908FO6AZMSoNB6nfKJ0J84/JygfqC/Zv5BZnrH3euczcZi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

There are now only two users of _swap_info_get after consolidating
these callers, folio_try_reclaim_swap and swp_swapcount.

folio_free_swap already holds the folio lock, and the folio
is in swap cache, _swap_info_get is redundant.

For swp_swapcount, it can just use get_swap_device instead. It only
wants to check the swap count, both are fine except get_swap_device
increases the device ref count, which is actually a bit safer. The
only current use is smap walking, and the performance change here
is tiny.

And after these changes, _swap_info_get is no longer used, so we can
safely remove it.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 39 ++++++---------------------------------
 1 file changed, 6 insertions(+), 33 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 49916fdb8b70..150916f4640c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1577,35 +1577,6 @@ void folio_put_swap(struct folio *folio, struct page *subpage)
 	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
 }
 
-static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
-{
-	struct swap_info_struct *si;
-	unsigned long offset;
-
-	if (!entry.val)
-		goto out;
-	si = swap_entry_to_info(entry);
-	if (!si)
-		goto bad_nofile;
-	if (data_race(!(si->flags & SWP_USED)))
-		goto bad_device;
-	offset = swp_offset(entry);
-	if (offset >= si->max)
-		goto bad_offset;
-	return si;
-
-bad_offset:
-	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
-	goto out;
-bad_device:
-	pr_err("%s: %s%08lx\n", __func__, Unused_file, entry.val);
-	goto out;
-bad_nofile:
-	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
-out:
-	return NULL;
-}
-
 static void swap_put_entry_locked(struct swap_info_struct *si,
 				  struct swap_cluster_info *ci,
 				  unsigned long offset)
@@ -1764,7 +1735,7 @@ int swp_swapcount(swp_entry_t entry)
 	pgoff_t offset;
 	unsigned char *map;
 
-	si = _swap_info_get(entry);
+	si = get_swap_device(entry);
 	if (!si)
 		return 0;
 
@@ -1794,6 +1765,7 @@ int swp_swapcount(swp_entry_t entry)
 	} while (tmp_count & COUNT_CONTINUED);
 out:
 	swap_cluster_unlock(ci);
+	put_swap_device(si);
 	return count;
 }
 
@@ -1828,11 +1800,12 @@ static bool swap_page_trans_huge_swapped(struct swap_info_struct *si,
 static bool folio_swapped(struct folio *folio)
 {
 	swp_entry_t entry = folio->swap;
-	struct swap_info_struct *si = _swap_info_get(entry);
+	struct swap_info_struct *si;
 
-	if (!si)
-		return false;
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_swapcache(folio), folio);
 
+	si = __swap_entry_to_info(entry);
 	if (!IS_ENABLED(CONFIG_THP_SWAP) || likely(!folio_test_large(folio)))
 		return swap_entry_swapped(si, swp_offset(entry));
 

-- 
2.51.1


