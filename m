Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D6D0606A321
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 15:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UiwPBxpd
Received: by kanga.kvack.org (Postfix)
	id 16F996B05B0; Mon, 26 Oct 2026 11:20:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1471C6B05B1; Mon, 26 Oct 2026 11:20:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0838B6B05B3; Mon, 26 Oct 2026 11:20:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CEFC96B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:20:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 42BA680789
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:20:36 +0000 (UTC)
X-FDA: 85365139272.29.CB6CA53
Received: from mta1.migadu.com (out-251.mta1.migadu.com [95.215.58.251])
	by imf16.hostedemail.com (Postfix) with ESMTP id 39073180004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:20:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UiwPBxpd;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.251 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793028034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BakHxwsKEl4wEb5dVq2y9HEY/A5llL3ub2wEKFZvMME=;
	b=w5Gqy2G6tJOCi+Ifsmy9Un1PCAWEW4rKIMnmAzHEiXQ7s9IAPuJHjaCnB1lbCsq9Xq4vFv
	r+8fvnVLEiX0GPVfyTyfrLpEghhdjyMnmUOq6QJ88Rj7ncOqs+xr3CNmGJRkD8s+ESp9ZJ
	ZZ0JTWmluOE+7zG/soJW1le6byaWdI4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793028034;
	b=QdtfUlAYiTCO7b0rAUkyRcLwg2m36hZvWUJRHSD96urnpeh0wQ1N5r0Q94+RmTZciQybFa
	snidd2h9KMMLCUFr0TInUSADEJUolhuc3wmHDMtZPO1H4h/f0t4ilnDcmu7NOeyJdV7gtt
	E/hJzXulrRzalEJj0dKIMp7n8K91BmA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UiwPBxpd;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.251 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=D2dq0y7/R+47sGNlmCNomNPSpPiujMaxii50Q4fB8XA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793028032; v=1; x=1793632832;
 b=UiwPBxpdG+wagooE/4M4hkMSrbE2LMFBAsGAVmVbFf67w9Mhssr1VbSUqWqRUc/3ACRvc+ea
 AvCW1CjfL2Ufm0+ihMyKJFd/YzhOQIJhd/74CNYtjWb5ufuDzKUOfulW+nENQ2n553s3pJm8AAS
 RZ07Y3k6t75QObctEKuOJd90=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c68f61dd7087423c;
	Mon, 26 Oct 2026 15:20:24 +0000
X-Mizu-Trace-ID: c68f61dd7087423c
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	kas@kernel.org,
	jack@suse.cz,
	djwong@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hch@lst.de,
	pfalcato@suse.de,
	ngocthang2710.1999@gmail.com,
	syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v4] khugepaged: fix readahead lock inversion in collapse_file()
Date: Mon, 26 Oct 2026 23:20:13 +0800
Message-ID: <20261026152013.10511-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 39073180004
X-Stat-Signature: rq88icknpcweueztq3aa6jr7ep3wgbum
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793028033-632122
X-HE-Meta: U2FsdGVkX19DbZ+2zQOQ1ZgMLuZ8ORMxGSUF78TIMep35+fciIVmCWSUEroEyQfItuAJ67vH+cJYt9juNjTuqWJKtIHHX8IHzrgnQvMeOuxQLYk9u5xU6xPSdDw5OpleYKFWUP/N7BQ/BDgPYiZwpeR/4tMHmNWD1NUhRJVlL+icumQPadtw5rYdq3gVVyUxo3kTeqtNS01QlExx+KyJa353Nrhaz3ucU12Hwu1lmVDFnQ7rUXt2YM8VOzP12r8Xy9Ya1DtZ7k8NSXTvHlaJRJ7DX4Gj1j9B+arjCi8Apas59efxQpGcnKqzMhpTzEbVX0XO3cUFDG2FFS5l6o9KJ65epVCIGWoDiM2h6gGmY31xiw5A+p75SdZYc8KLoamUIsJdwKv+aILnRWz8iYvl76U55Bu1JXe3k+CalxyX5awYdvayTUlyq3HROJleznCITaVwIxepfZ086AN9+ebwab1nzsSoHt6BJJqw5KBP7WiNGPHphc4fgojAMdmLNzMlDKMO2I7LuDqYLcE+vOMy6cUDe0876wffZy2euwLtT7FtCZvfHvO6vR4wNWTUT+uiK0Uy+ZWiFpLc36aJNW0jExkB1ePH2BzFzM8qHDuHceGgL4P+oOEYDS+ki4S3vtvxsA53RcvuuhD2IcsgSqT+RjN6ZEeEMZDJCcS/ks9CF7WS45hfoWYAiav7zS1S0Op8tRsTsGdhqQ8X7wRUgSdj8S8Um1NxM9RKG54oMFC/CeHkJySNv4ZG1k2Oc3exMPTEhmk4l5azoewPF4EUh6p9ryDw+pvO3htyYLKSjp4MWY7CWKUZz3Ct8Q9QwxyqgZJhyxT9OJzEsildb2OQskbq4C9QBTWqmO3NO3u5g2q/SRyUgwV0mStV5odCT5AK1rf7AW7vPjRe6wSQN+rJWPFKD00akLFFD8E5RvsMaA3UojmiAaNJkU4bwxIMHM/ATJinaaNzBH2w+WcT9MAEil9
 YB9J8oex
 uag7nCy7Taiuy/m2UjJpkov1aH/hNIoMPE8ctUqZdyNNSLmZ8IhfQMAc27AD2avV/ejKaq4diY8HjM++ZYD3VsVte6hBv3uaKL58RuQUMHy03L5S+pJjxm9LVkUQJEscYX6FCjCzbM7Gdi6SLdDi0UIlJ7WxVsx2jInEf1UiauVAZKe/OOLsikTdFWkWCjwYGBhJk12iri10QG2msBL8zAUKpDyqoSsDKu5VRLgvXiT+JSYJ//BGZttPnluypw0PZh+h0hAFgB6ZR0vsM4aMNyYD0WFzTXyhl/80h1fRNzGoHBmb2jdxuSAFkw0CGOw8xME10b7EzKF0l6rOkgdfffApmuHBHT4NJ+BNe7VLBenHypWoDRbNsD7tf2W6Ul7I+BUTuE3iGLP9aGvFBYHG0gD+IcHKdSWfwRRHjl+pej9lk0a8Qr/IaZqgHMq6gEEJ3M7Y0NZcEtyqQ7DNIZWuJqAnjOYgCCzaFlchFVryfh2XSD0CfvTjV7JtTxyfJsI5/rGwyCP1LKK4UNWs+zenCJzRY68zmwOXXEoi5qFYowhuU1tM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

collapse_file() can call page_cache_sync_readahead() while still holding
source folios locked. If truncate holds mapping->invalidate_lock
exclusively and waits for one of those folios, readahead waits for
invalidate_lock and neither side can make progress.

We need to release those folio locks before starting readahead. On a page
cache miss, roll back first, populate the collapse range, and retry once.
Doing readahead after rollback avoids an extra pass when all folios are
already present. If another miss occurs on retry, give up rather than keep
retrying while truncate or reclaim removes folios.

Keep page_cache_sync_readahead() and wait for read I/O with
filemap_lock_folio(), releasing each folio before moving to the next. The
existing uptodate check during collapse still handles read errors.

Shmem uses shmem_get_folio() for swapin and fallocated folios without
taking mapping->invalidate_lock, so it is unaffected.

Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
Cc: stable@vger.kernel.org
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
v3 -> v4:
 - Move readahead after rollback and retry collapse once (per Pedro).
 - Drop the preparation pass and its redundant uptodate check (per
   Baolin and Pedro). Thanks!
 - https://lore.kernel.org/all/20261016065920.4153-1-lance.yang@linux.dev/

 mm/khugepaged.c | 44 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 11 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index da91762f6358..0d3bd9e23613 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2239,6 +2239,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	enum scan_result result = SCAN_SUCCEED;
 	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
+	bool do_readahead = false;
+	bool readahead_done = false;
 
 	/*
 	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
@@ -2256,6 +2258,10 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 
 	mapping_set_update(&xas, mapping);
 
+retry:
+	result = SCAN_SUCCEED;
+	do_readahead = false;
+	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
 	__folio_set_locked(new_folio);
 	if (is_shmem)
 		__folio_set_swapbacked(new_folio);
@@ -2320,17 +2326,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			}
 		} else {	/* !is_shmem */
 			if (!folio || xa_is_value(folio)) {
-				xas_unlock_irq(&xas);
-				page_cache_sync_readahead(mapping, &file->f_ra,
-							  file, index,
-							  end - index);
-				/* drain lru cache to help folio_isolate_lru() */
-				lru_add_drain();
-				folio = filemap_lock_folio(mapping, index);
-				if (IS_ERR(folio)) {
-					result = SCAN_FAIL;
-					goto xa_unlocked;
-				}
+				do_readahead = !readahead_done;
+				result = SCAN_FAIL;
+				goto xa_locked;
 			} else if (folio_test_dirty(folio)) {
 				/*
 				 * This page is dirty because it hasn't
@@ -2657,6 +2655,30 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	new_folio->mapping = NULL;
 
 	folio_unlock(new_folio);
+
+	/* Readahead may take invalidate_lock; source folios are unlocked. */
+	if (do_readahead) {
+		for (index = start; index < end;) {
+			folio = filemap_lock_folio(mapping, index);
+			if (IS_ERR(folio)) {
+				page_cache_sync_readahead(mapping, &file->f_ra,
+							  file, index, end - index);
+				folio = filemap_lock_folio(mapping, index);
+				if (IS_ERR(folio)) {
+					result = SCAN_FAIL;
+					goto out_put;
+				}
+			}
+			index = folio_next_index(folio);
+			folio_unlock(folio);
+			folio_put(folio);
+		}
+		/* Drain the local LRU batch before retrying isolation. */
+		lru_add_drain();
+		readahead_done = true;
+		goto retry;
+	}
+out_put:
 	folio_put(new_folio);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
-- 
2.49.0


