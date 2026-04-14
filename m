Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ED06ED7B8B
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:16:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73076B0093; Tue, 14 Apr 2026 05:16:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5796B0096; Tue, 14 Apr 2026 05:16:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC45B6B0099; Tue, 14 Apr 2026 05:16:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B8886B0093
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:16:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C54D81B7F56
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:16:20 +0000 (UTC)
X-FDA: 84656605320.19.6BFA038
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf20.hostedemail.com (Postfix) with ESMTP id 148A71C000E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:16:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TX2kBkfH;
	spf=pass (imf20.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776158179; a=rsa-sha256;
	cv=none;
	b=1TkQFnd8uwNVTLK41YsivToTdH/+Tl4MpPC7jCXtBd0IK1W9WTkmGhETjNcFcHmXiMEmho
	kZR9zpgjo/orjosR5+9wSSHj32qUvVVkysB5LZOLV2Da0gHt5HjuOD8XoRmRqA0eI4XOfZ
	104VE/aK7EdAP/rARhBFOCPqyFkMpmY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776158179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Im9++lg/lpHN74Nk2FRmzX3snVH1LvwzoX73u95S3I=;
	b=R1otkNWuojNXJhjqcmVlprqrFSBAbCSbo+cj4sIlb1K7waWLJQDOcoaRsNhwDluu8G4sQq
	mc8U8P9iFJhkCcJ6pWKBwDEAhxXAx4knJptZzGvm58wnElJwMMlbU03cWAxS3yijGhyMee
	THvqQi2nUD8FG3kpTG396TFxKbAeKaw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TX2kBkfH;
	spf=pass (imf20.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776158177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Im9++lg/lpHN74Nk2FRmzX3snVH1LvwzoX73u95S3I=;
	b=TX2kBkfHAXl/AoJvsdawQlVCbbtFUOqmbqWwxcLAtHnvy8fCkD5glCD6qJF9rHwnYhySDH
	kjm51JNBzG2pEhhpUtjzdZZUioipbKBvZxZMy/tuFt3LOcA/Ykb9namQ677T6BvWiQ6goN
	2w1Wvh0FSYcZSJt1i/keRIly3WOEgbE=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/4] mm/vmstat: use zone_stat_add_folio/sub_folio for folio_nr_pages operations
Date: Tue, 14 Apr 2026 17:15:19 +0800
Message-ID: <20260414091527.2970844-3-ye.liu@linux.dev>
In-Reply-To: <20260414091527.2970844-1-ye.liu@linux.dev>
References: <20260414091527.2970844-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 148A71C000E
X-Stat-Signature: qgbkusbgcg9ex4nrrghz8uaj898qs7y1
X-HE-Tag: 1776158178-936241
X-HE-Meta: U2FsdGVkX1+0AXeNCknMSmc9I/xaOkbXY9m/pZu/f63O2NV/Pc7he54Y9blnQt9wR5qoFrCu6ViwOG4OoVtRdX5APSyLWmGjgpN+M3nFppKcxW86rs830jyZBphZncJfyzV01YHvXvHHE6xPanWU90L6EXLD/fLPL5cPMmupFx8fksAeoJ0BhUkWCQS+F92QZpXKczFy8Ss4HhlC+Q7aCqEPUJ/hXOwh5qZXuGEhNf7QJX9KjnaSkq62eqG0PFtB9sXzWFZgMarrGxZ6vqVmJuVPx3DOqvLyxXslZcu8MVPhHAztT1yV9OlW0vu0DjbqJUghjx+rXcbnACrHhV4aY07mkzYvcJUkNx1LrfoYTm/P1CzezGjaApfeXVk8sWnkkwEeIw/tbf2YpnzxApOIit6YZxLHh79zNcAY2iHRKMxoyYUbR5hSW6TcLa15ZmxlPDdtB68H66PfKDZyC2ijJG62ljtWHXpRBgjBmSTcc3GlrRJKmy61f+yk/wcjCG2BhuwcNIOWkmYT0oFNqkSkwIeOgqL4Tb3GRRm9Xsq0/NOyBI25IhrHzObBdGwWiz9FTXjK5nH50ilalwxM72f2KhOmY61IXA5gTNalYb9AnX4ZNfTjR3IzGd09ME7+wRor+kVwdRhV5hWZjaE0SvmhIiEYqdehuzrdVkd02JhAkJxuFU0WL8LvT/cSFS7kgV2RuSSQ4fuo+TWIdFwOCJgXdTNxmsUfFHAdIFQ3FRimdarrwpkU9HIPY+r4hu5I66lPAWiXRQZpxY0nbqnTIG5Ou3XXYBucgO4cCK7KUAe03CjPdwU/5MZR6C5/cxvsg9M/QpOLMBiWDHuM9HRNBvMTjSLByxpT1kVtcqltnP4qgsf1aZLZHwdvfo09VtJ3HEfZyFoqwfXGfKLRLA7IRStlFjRrYVIg8R+88GbkPs4WjJfZbDdOUEgiEuYfvA9Zoz1w2LxB5MgjQxhFU1XZMSh
 icwwX9uf
 zt8pMP4Xsy6WygLFwe9TOJiHPHV8oz7XqPspAAvc5idkeqUrtSLWB9205dMVh2IY/VmjTufMpQtSN0IBrC1qbiqoCPvgcDaL/h6wgU6gshvGdEVoPanTX+elrWKLcc1BcnVuUoYPQkyciNsE7q2RKUGhxkCXrNxunomJA01qTqTqqiC4hT+oXFBPn8ifICc7tgvZsKThJqFnFaNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace zone_stat_mod_folio() calls that pass folio_nr_pages(folio) or
-folio_nr_pages(folio) as the third argument with the more concise
zone_stat_add_folio() and zone_stat_sub_folio() functions respectively.

This makes the code more readable and reduces the number of arguments
passed to these functions.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/mlock.c          | 4 ++--
 mm/page-writeback.c | 8 ++++----
 mm/page_alloc.c     | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 8c227fefa2df..0cafcb2f4e8d 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -249,7 +249,7 @@ void mlock_folio(struct folio *folio)
 	if (!folio_test_set_mlocked(folio)) {
 		int nr_pages = folio_nr_pages(folio);
 
-		zone_stat_mod_folio(folio, NR_MLOCK, nr_pages);
+		zone_stat_add_folio(folio, NR_MLOCK);
 		__count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
 	}
 
@@ -273,7 +273,7 @@ void mlock_new_folio(struct folio *folio)
 	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
 	folio_set_mlocked(folio);
 
-	zone_stat_mod_folio(folio, NR_MLOCK, nr_pages);
+	zone_stat_add_folio(folio, NR_MLOCK);
 	__count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
 
 	folio_get(folio);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 87e9ea41313a..6f9b7b081ab7 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2647,7 +2647,7 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
 	long nr = folio_nr_pages(folio);
 
 	lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
-	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
+	zone_stat_sub_folio(folio, NR_ZONE_WRITE_PENDING);
 	wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
 	task_io_account_cancelled_write(nr * PAGE_SIZE);
 }
@@ -2916,7 +2916,7 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		if (folio_test_clear_dirty(folio)) {
 			long nr = folio_nr_pages(folio);
 			lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
-			zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
+			zone_stat_sub_folio(folio, NR_ZONE_WRITE_PENDING);
 			wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
 			ret = true;
 		}
@@ -2980,7 +2980,7 @@ bool __folio_end_writeback(struct folio *folio)
 	}
 
 	lruvec_stat_mod_folio(folio, NR_WRITEBACK, -nr);
-	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
+	zone_stat_sub_folio(folio, NR_ZONE_WRITE_PENDING);
 	node_stat_add_folio(folio, NR_WRITTEN);
 
 	return ret;
@@ -3032,7 +3032,7 @@ void __folio_start_writeback(struct folio *folio, bool keep_write)
 	}
 
 	lruvec_stat_mod_folio(folio, NR_WRITEBACK, nr);
-	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
+	zone_stat_add_folio(folio, NR_ZONE_WRITE_PENDING);
 
 	access_ret = arch_make_folio_accessible(folio);
 	/*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 65e205111553..a81ceb4181ea 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1327,7 +1327,7 @@ __always_inline bool __free_pages_prepare(struct page *page,
 		long nr_pages = folio_nr_pages(folio);
 
 		__folio_clear_mlocked(folio);
-		zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
+		zone_stat_sub_folio(folio, NR_MLOCK);
 		count_vm_events(UNEVICTABLE_PGCLEARED, nr_pages);
 	}
 
-- 
2.43.0


