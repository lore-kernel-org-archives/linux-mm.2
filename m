Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 325EDC88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 16:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D641A6B0092; Sun, 13 Sep 2026 12:36:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D156D6B0093; Sun, 13 Sep 2026 12:36:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C03CD6B0095; Sun, 13 Sep 2026 12:36:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90A806B0092
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 12:36:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8C321A08C0
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 16:36:55 +0000 (UTC)
X-FDA: 85209293190.15.0934E3F
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf16.hostedemail.com (Postfix) with ESMTP id E4C33180004
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 16:36:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B6mo2Kpo;
	spf=pass (imf16.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789317413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3OFZoxZdendLiI0c2ZwgOt1fV1G7t70nnE2lAiT2KzM=;
	b=pkfkMI7S7VnY+Ud9I5w9/TiMpGJB2woVf67PuGxIc8O2LG4ae8HjOgIFLvdOQ5id60C8Ck
	t/3o5lqmaovPM6gVB3hHN2qJ2zqH1TPitGapo/B0KRXboSL7Ichs+sXbbm4B8iLjupMc95
	eh+eYf2gnmTU/raMiTe6DgTGMZG+0wg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789317413;
	b=SI84Crm/WPtyHts0pw6U7+dGOh5pFjm9HPaghn9CDmPBv1gOwlu+59oiGfvMrDE+eIyI1e
	KB9EHoKaSWy1uFHJlHqC+PV7O587KSfuH7ApXgIUo6kJb1WBGYgqfOWPzBdHxHa6fEE0Ft
	actUB5B7dkC5WX/U/i1Vc+kx5Kq8Ioo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B6mo2Kpo;
	spf=pass (imf16.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2db18fe433fso7802845ad.2
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 09:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789317413; x=1789922213; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3OFZoxZdendLiI0c2ZwgOt1fV1G7t70nnE2lAiT2KzM=;
        b=B6mo2KpodN1ZjRBegzeYReTmASYWocDhSGC+QDtmrbqyC2VrsNRrvo3tavbZhk8cyI
         5QLq/0c1PJNjwjvqQ+Ct5lGR0SImzLhstzl1rT775yqxj1nrOybDzH93R3MoRQqXWr+x
         aA6BJsSbkKlP3nZEEYHvoCUkqJki5nuDCXaqQV2JqVkAZmi9j49cAHIXnyRaexz81xJM
         L5yXu0vN4cQF6u0XvrM+UetHPvsar3rKPtYXZgM7Wk4yPMVDK2zQ9TvAbQG1seDVs5I0
         X3Vw9khfD1IaVNOc93Dz3c1gX2n/AEhSvw1mLlMazyDQNndd8st+8D8iKA+VqKcyynng
         pgFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789317413; x=1789922213;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3OFZoxZdendLiI0c2ZwgOt1fV1G7t70nnE2lAiT2KzM=;
        b=TZHqqmQt7WM8D65XLYefmh2Yvub4uFqPhA8SA79q8Ky6oKcF7Z2gPzQsHiQNu0kjrA
         2O7B+59hQKFHdjeCYpVw9UDXIV/C3ppW53h12s7yIeidU79EcGr+CvB8fxwIJweQ/oAd
         nGDwn7DVpnOddm0bPTfQn0iDPzACiR5uW3DTGDHT1DiQE8+PtSH4Z2maDwJB7yA5BfH0
         r+Qw3lLF6rCv/i9QkLKJ66zOgL59H0xtq5WKwFMzF3LZbw5iov8MooSNCCBhU6De92zZ
         4Alv+RfBbraeZB5W7onXTv/9uznHgAzQuM4w5zHO3soJIsxBFUpMSJjFfGG+RYupRc5r
         Az6A==
X-Forwarded-Encrypted: i=1; AKwUvBw+xwX2pM4UtARnotC/JVelhOzrvkNdhC3DyxYO3jCNq1WAGdUURaB6Y3cD3IC3xJ9Ee5iKVpH60g==@kvack.org
X-Gm-Message-State: AFuF++mBzDG7CD9ASadgFW6NfwGkxI1BXgUS6ZVTsRQ5x+EZdy/yas20
	AYyMAhVTcrIuOXzOYUZ5tG/xJMAiD0yZDNkmQhpFhBf9ZrjNu8BEN80F
X-Gm-Gg: AYBFou1BbOk6N7rbuTlpyIX2QdMurZNkTQabR1PR1eky3vWxrAiYHMvoyrMVs78bYSu
	76O3qZrx0YwsgBwvU52IGWiopTjOd1mKwsXij3nknheMeAXCNIOklbuTHDw/9iw62l6p4Hu3WUN
	Knk7zsPCCADdpou1MaAfqVebFpOk4Uc9s1IfSydiLOE6zjNbH+LLbWLpzRmTWUksWB7+GlnFYQJ
	9Q28e/TeRl4FydzSjjeMfYg4X98P6ex2/z5VoJR/4kqlfvoc8QGsyyTrp3rq5syYmxMHUistwru
	tJonK1xB9WBrVbf9LCyuVsQ7X0QJ1RZbn2Scx/+VJsaVCDGypfG/VJqvyv7DOnVXWqHNhmC5tS2
	xJtk1I6cteSLHqP1ZVUFxeey0/upQ8Osdmlg6gtSvzBlRTO9F4glA00o4UfkcG3C392jpCUG4cs
	A0gsCxCFv5PsiHjqhE9ho8ni9zPKjC5AOlb+MKVdB6AlcbcOTRX8gJzLMRSgmhvKY4tybMGMm2O
	PNNUS8N2jRSHJppAA==
X-Received: by 2002:a17:903:1a4c:b0:2d9:464f:d45f with SMTP id d9443c01a7336-2dd4bc33217mr145184825ad.5.1789317412610;
        Sun, 13 Sep 2026 09:36:52 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:1d38:5c70:f608:4e94:6df6:c8b4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2ceb3bd7sm35299925ad.34.2026.09.13.09.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 09:36:52 -0700 (PDT)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] khugepaged: hold invalidate_lock across collapse_file() readahead
Date: Sun, 13 Sep 2026 23:36:44 +0700
Message-ID: <20260913163644.122133-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <DLEBZ0GIGNQ8.17U563YYJ37AA@nvidia.com>
References: <DLEBZ0GIGNQ8.17U563YYJ37AA@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E4C33180004
X-Stat-Signature: i6dmebdebhiunx5td4xadrax1wuccabs
X-Rspam-User: 
X-HE-Tag: 1789317413-730422
X-HE-Meta: U2FsdGVkX18FYOo5vQFO6Rc48r1zIkG7NswzAxKN5oS7beW2WvHzxuYuxj2ygxl3RpJgPAZ2/g0TW33bzL+w6it9YqWaWpV8Piq9GA4hEeFFBTu2hQZZ+6+vbVq3Wt2IFslvn8l7pLdfMoRoYc9S6Oe7fiQYSN8mcSkWVzoHoWIHRoe60SPj82lOIUIUW6XPoFl5s3BZORgnCi2Nbv7noSBGaN28p2rwe2yrIJ8sdDsDTLaHabi4XSMcXZMUojd76XIw6s7Wbu4ltKoe0wku025iIojryjkrp4tnB2YFFDKaGL+sHVZ33kzhpY7XlRFPBiHxw5eKVwtAfsewTQ9DFaq3L9x1sK5NfkmQiXq+0Tq+BFNsunxM22bDdanJSaYoALi7HnhKrnwxNSabOUm0KVnCSRG9M2j6pDP+fWe7yvTsrvnIX9/RyR3+EQHUO6evb0bQoYGqMEVFWx/pEtcJTBxu27zfUzl5YXPeDvu7NMOnN5Gcz+gGmOgPO1omZ5xadx8OZYeA6zS8kOaNL4V/QMhJQAb6sucxeuqRRTPMNVjwEsFOPMVIbWjkMWZBW+fR1uyKmmLkbZ2CCQ+UBa6ENqv9gBiZcfkuB4QSucBrh8H2MR+9UG6D2VJ7Qlz66yw5SUEbv7sC8rCrzYZn/XOdhSpM/IBCX52RF3R1TE7sF5yq/+PjW+OQRftpxkjAN/C7Z1/QtGrX8aYbcVvA4YAIB60eAhsDhpct5i46L9kTOTayA+D7RP201gYP06X7b91GVJZVjQFRBLRnh7268DbBdDnU3VLFg+1YqQap08NJrwYg8glj3Nv1d94zl+Wdki3gMW863NNJy5N22Z+XCNBtYmlczaACTKpkav++V+CJIk0tfzCCt918BJ7v2o0PRbzBVypNd26w7QMOd6X3zZ/O1XBwvRtM89igEOf3RUrMDxR0vqwucnqzJsJj/KgQT0vXX1CR4Q6Mf53r9QEks0T
 7QV1ligl
 ChoRWas3IkM20ZsV0giASZ8tw6DfkQiCh3F4Zfk5PIM/aYhHf5UJFya2udY1eXt4QNmqTxbal9jYXQ/Q25bE/F0jb9KarZT/M57+otGxcazEpNBWzMw5fJBykF92O0IH1A2LhxnQd4qGWlLy/eA8MyETDhIT+r3B7Vv2ZOuzAQBWx8Dlq4K36w6WfS70Vhu3Cd59+68pRBj8zYjzuQwHTrVLwt6uEsaDk9HPEYJdXIimYlu6+ObMsT32cX8ZJOasrINUJr5258Hl4Kczbj8iWA6BlvpzuWNamf0Ekuv/XeqPFr/xKySn9sLdMXlnpph5AUBgkxZHe1kxPZDwW9RMmW4bsi2ejA+/wo+Cr49DrKtGYWvU9knLQZIuD8LVdFrzxpNXmxyX71TIutnOBUymEXovCKGHjVxPXycMkVXDSQIo0ndByAfeKRolv+FJCLw7/cSR7RFdyvHBGsygpyhGCpqQSvH2cLmXPht5E3XJHnZyl47NWvOztivYbL/20PiDazgqXglfjWkyzxj9FyWLKmlb51e5ItzL1AXMdAEdKcxwXJqWhpfUsUyEYA8aOD0Mbg5C7J7u/sv8nI8ZHP38ythxlWVDvGeU747hGIo6cpt0BpUu58V20YM7N6QtXOEaZeoNfRD9s/jmOe6s/7srAqWdIc63kZpPHw+9vsfoVJVye26lC1X0wXvvtOak7dzdA5ag/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_file() calls page_cache_sync_readahead() to fault in missing
pages before collapsing them into a THP. That helper takes
mapping->invalidate_lock itself for the duration of the call, then
drops it -- but truncate (e.g. ext4_setattr() -> truncate_pagecache())
takes invalidate_lock and then waits on each page's folio lock while
holding it. If collapse_file() has already locked one of those folios
by the time truncate reaches it, and then tries to acquire
invalidate_lock again (e.g. on the first readahead call, since
invalidate_lock is not yet held at that point), the two paths can
deadlock/hang on each other's lock: truncate blocked on the folio lock
collapse holds, and collapse blocked waiting for invalidate_lock that
truncate holds.

Reproducing this over ~150,000 collapse iterations with truncate
racing concurrently reliably hits hung_task: blocked tasks within
about 20 seconds on an unpatched kernel.

Fix it by taking invalidate_lock_shared once for the whole scan, after
alloc_charge_folio() succeeds and before locking any folio, and using
page_cache_ra_unbounded() directly in the readahead call site instead
of page_cache_sync_readahead(), since the latter would try to retake
the lock we already hold. page_cache_ra_unbounded() does not clamp to
EOF like the helper it replaces, so clamp the requested range
explicitly.

730633f0b7f9 added invalidate_lock acquisition around readahead but
missed collapse_file(), which already locks pages while calling
readahead; later filesystem conversions made the deadlock reachable by
taking invalidate_lock before waiting on page locks during truncate.

Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: stable@vger.kernel.org
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
---
v2:
- Take invalidate_lock after alloc_charge_folio() succeeds instead of
  before, so allocation/charging stays outside the critical section,
  and skip the unlock on the allocation-failure path (Lance Yang)
- Add Fixes and Cc: stable tags (Lance Yang)
- Add Tested-by (Lance Yang)

 mm/khugepaged.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 11ff98d55c76..a5fcafd57505 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2257,6 +2257,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	enum scan_result result = SCAN_SUCCEED;
 	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
+	bool need_unlock = false;
 
 	/*
 	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
@@ -2271,6 +2272,15 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	if (result != SCAN_SUCCEED)
 		goto out;
 
+	/*
+	 * Take invalidate_lock before any folio lock: the readahead below
+	 * needs it, and truncate holds it while waiting on folio locks.
+	 */
+	if (!is_shmem) {
+		filemap_invalidate_lock_shared(mapping);
+		need_unlock = true;
+	}
+
 	mapping_set_update(&xas, mapping);
 
 	__folio_set_locked(new_folio);
@@ -2337,10 +2347,20 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			}
 		} else {	/* !is_shmem */
 			if (!folio || xa_is_value(folio)) {
+				DEFINE_READAHEAD(ractl, file, &file->f_ra,
+						  mapping, index);
+				pgoff_t eof = DIV_ROUND_UP(i_size_read(mapping->host),
+							    PAGE_SIZE);
+
 				xas_unlock_irq(&xas);
-				page_cache_sync_readahead(mapping, &file->f_ra,
-							  file, index,
-							  end - index);
+				/*
+				 * invalidate_lock held above; don't retake it.
+				 * page_cache_ra_unbounded(), unlike the readahead
+				 * helper this replaces, does not clamp to EOF.
+				 */
+				if (index < eof)
+					page_cache_ra_unbounded(&ractl,
+						min(end, eof) - index, 0);
 				/* drain lru cache to help folio_isolate_lru() */
 				lru_add_drain();
 				folio = filemap_lock_folio(mapping, index);
@@ -2672,6 +2692,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	folio_unlock(new_folio);
 	folio_put(new_folio);
 out:
+	if (need_unlock)
+		filemap_invalidate_unlock_shared(mapping);
 	VM_BUG_ON(!list_empty(&pagelist));
 	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
 	return result;
-- 
2.43.0

