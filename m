Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC3FFC83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 07:54:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C9878E0005; Mon, 28 Jul 2025 03:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 473248E0001; Mon, 28 Jul 2025 03:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361E28E0005; Mon, 28 Jul 2025 03:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22B928E0001
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 03:54:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7E07C016B
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:54:04 +0000 (UTC)
X-FDA: 83712910008.27.3A092D5
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 08908C0004
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 07:54:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k27MkXfe;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753689243; a=rsa-sha256;
	cv=none;
	b=vrjakUYx2Nv8fjn48sacdlUnjcH41DCZq/1x2mxbDlDSg10bNjUXfHDlkYEARS4bQuU1cS
	wvGdAoXB2vErEnS83lPmSnFcVDWdqDth6AtWDla5AO0NNOIZ4XHe2mgt6+qML14ZVsd1bh
	AhHl+lIsV95KbA31Qqi8raWoQlyYz6c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k27MkXfe;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753689243;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=knGBd5jfLpxYWqvJFei/yT6Q+eb8VZoGgCefpAHxX/Y=;
	b=4abXp1W4bw3+HslXrbJOTsbQoHYJu4weK97YiDP1+ZqcPB3a+2HKafe0IQxfGYqlcfHsEi
	QvdBVvQBkfeVcJCKx13AlwnQ+7XyA/xjd3DYRpasjZfmuS5glxpj2iyksYbVWEKZ508Mt5
	YJOt9Kko6BWWEQzW1dUnr5dmmUyXWAQ=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-23dc5bcf49eso56220645ad.2
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 00:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753689241; x=1754294041; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=knGBd5jfLpxYWqvJFei/yT6Q+eb8VZoGgCefpAHxX/Y=;
        b=k27MkXfe24H17Ej4iMSjXzPg5qdBgk8awT8Cv8vBWPLU13xHeIHy2YlMc0gvlSDb/3
         iyscbqi3m+KY1ijzZxljb0DDUT1OJOCh+MQIB7pdgwHKgMlaEJYDP+/2bTUMp/Yi1Iuw
         m/KrHJosI10XTfIdv9GdWF6qn8f6N2Qaa8ThKPyVVwcWfkALYZk4A1i3836jwYxn4H+R
         qc6n8jEZIkjo+939jgHthqvRwOHehm0B02AS+Cv4xHLOhD025yym6GYDDoiHqg2JjCC5
         K/h6Ng+EyJsvkR5q+dVmLHMuw6J7NFMmItf5W5vyPZQm2PlvIJQ3hRe4dRh/Cu8cYvLP
         Zifg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753689241; x=1754294041;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=knGBd5jfLpxYWqvJFei/yT6Q+eb8VZoGgCefpAHxX/Y=;
        b=JhWJ3f5MVAsxpnV3F//RxCTZF3CTg6Mw8CLbjRs/7Qsfil3TopbDnI1alzs0cw6lS4
         ouWGtZ+Kd1KYcDDT4qN5xT1PYk3+4QXjbPk2l+PymtJMAvix7/jAaFTBDP7D8a13V+Te
         AJ18FBXVaewYL3Zs6zHr/zga2rSxqQjMX/7vqYAMHyN6jZ0fuPzglKmqA8r1t9uAy8Hw
         vduxZ0XHmGO3kGuRKbPutR2UkYv/pxiFZpOwjb9yiNfc0gMn57f2Cuz9cII8lr2uvXx1
         5AMkrhIFpMVdIwOb+ssIpI5m7UXsVzmqAHYkQa0hxmbJFCtUN3lSLAS7JoY27EyiKrim
         b0yQ==
X-Gm-Message-State: AOJu0YzZHSukNIktuZx4udAVU6DqtbBVlAhEQGYPcQIqPjyb9XpVg5QR
	auqo4i7RNTXIgEWH8InJVis32Gf5ipGhQi/BEbiNXLSF/ksgKhIRtip/zPxw58mY5TQ=
X-Gm-Gg: ASbGncuBFZAqG9GZXhgqWcgsHKaBg9quky3Ow0AGMnXyg7hnRa04BtX7nrrQsOPzwfd
	mpkFtWw8rHpmVFAlMxGAJYlhtYc+55SpKYaAg2hMLHsH396UZOJzSJD4js0Wh6VB3j2qqX25KLN
	wSH5Ob0lV4+5kIZQc0bIxRYx//QhqlFRQglZXWT+79lWMx2Rdz/MtsBvQyYVy8gnnG9vcw3rael
	9ICDuAec6UF77kBco+xcUsBVUSPn0JjgQcLxcUQFevJET1oAWm5ti3cUijPWCa/QR3aLK9eW/p5
	6sZ9ZVxzuOTr65IJM0MezqDzisubcg43q6Zzms2Mrv2PpKOWmzaCSXO69MGKRsQ7QwmcbUUfeeX
	LNsJ4ZwNwaVica2sGDnZyWJUbpYFLls8rLEyJ
X-Google-Smtp-Source: AGHT+IHbEgSCz7muxEaP14OZPu7wIZ7iP6SbFhHsXB9PfuHrCICAOPtunkQ6Vt7Sy0XqXlLfDh2N9Q==
X-Received: by 2002:a17:902:f54f:b0:240:1ed3:fc1f with SMTP id d9443c01a7336-2401ed3ff16mr52388515ad.12.1753689240203;
        Mon, 28 Jul 2025 00:54:00 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2401866c2a1sm20272305ad.4.2025.07.28.00.53.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Jul 2025 00:53:59 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Matthew Wilcox <willy@infradead.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v6 7/8] mm/shmem, swap: rework swap entry and index calculation for large swapin
Date: Mon, 28 Jul 2025 15:53:05 +0800
Message-ID: <20250728075306.12704-8-ryncsn@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250728075306.12704-1-ryncsn@gmail.com>
References: <20250728075306.12704-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 08908C0004
X-Stat-Signature: x3g5ujfwzbmmf8sn1qony11ykg56anjj
X-HE-Tag: 1753689242-826666
X-HE-Meta: U2FsdGVkX18xYOx5+fziiaFMikg3Rj3zRG7tvm/zWaBNBSbBwcFcjkQr5cPVfpj3BAU0DWlvpKavWj0sngUY4aysvoFcZU8Gv+MW5CJ46z5pYja0OedElPC0dKwePKcftzmR6Zm10o7CbiWlPrWytbAjbmdLknqcNIFtKJKxdmVBhjazeR8tuZyEMwT/YQ8NXgxn4M//ZiFOHbPQF6F2dK4VhK5H7VQhIiSdEL11lGiNZDUOuTPgKE2vRvkZbCbakULSalhXDTJ2FFxYrT7RURSCuVEl4kjPef/avYruA2f+O/uh2EShzIcCLhKPw6GfV7I6fBu2ULfahYpgbE2LvUoXtKTGaNz2auNWg6LsI47qdb1t9jfTOePEs+EntyS0KT4cK+V32Ko5NI95jDngX7Aj+QxF2O1Ab2Kj0U3cBjdoqt6ikVgMQERjmnIj5t6kV/e8la3/DJGhzcbFPRuSpIxAWYMXClNUB6S3mJDsem4dMFOokxWJoQ5TZoWNiUyJtVuRZLxF+U19tlwYHWxsR8ClgrZ9wicMSQ06q6RIdBvs/9xAQErrh5J5+UPTRntvNLg3LM87b7hjWnhPpBEjOvU6xs4UOQ/0sxHydfrCH8GNDP2hp5YZ+SgWQZBrpTYTlQqoTZsFTugSxA6BxbKwJQLD3yDg8BrIkni79WWtlvgEE+bIzjtG+rQ+ghjg4Qcow6bqUVKuenuS8ONDR0S98GSuVT5eBxLWZ/S/SWrh2hThs5DbTT8sNWpPr8YpbLDRq5atqyoyTXBFycH9sHZ5UZeMFp4+InCEIYB8W/l4wRLmJWzO/sjjU7VmhW9ns4gS2uqrTfrLGLRpYdcjm/Ly3/6Lgz4vAKvfCfYFbHB6L303syk/Y/MzxUrK7tXlZIoiGZgY5PimwskvfaTlx5NS4yL2wDIowILJpSiCVf27BcwdlaiUC5kqfQq6OK3KkjjVEmM+wtPtYRNA6ycR5h2
 hoLsCwbF
 QcZ4r/szC+YN9IZX3dt0wTYAlCfsTZxOUriK6fWeSAJ5bpv4uwd266pkCw7wVUaUzPzRY6ejIhcE3X9MLhvJJrBul0pAbB2cjMjTDqdxCMiAew/9tHCUOJvcmy7E5lxDhkXfGyHCgIrwgNjNQbq5y4HNaZHil+NXUIDoRsMrjgy7WOq2+F6RkiYCYgBPIq20MrYUOoEoo79qwjtP1i9nUSaIZwkMCh0rYH+D6KG2OVNDUm7PfQLFg4NZvzLKsypTLtYr12ebWQ7CwKUtQQqKwLiZbFt/8h7WZdFG9Pp+Ca+l5YVOcgqSoeErYXeQ59G42q7t+4w8UojWsQkdc2a7Nxo55WlUGtHGEtWLjFIt+Ur9w2NxSh0w8u+BkrDVQ4iks2MA3YvJ98EAkLJ+ufAA2bUSzIGKdkDiwW0K25gfpf5/mJpHPRLhA2KFB8ogcTkxPxet7grg1MOPjMtl2QCJEEXiI621lH+J2LhDPSBwDEJcZXbnV2aIO93tYm3T09svRfm6bYMvEv6m9W2Eo/R/qy1O7wctn9IkTTCPAgSBxBW+O0HrVhD8vs+vX2qGelp4bSppPRi+hA3pDhxWAld3t8fuhpBFkelio7q7dzEKD/bOy+50i5MnJiji2yuv8LCdKkHeR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Instead of calculating the swap entry differently in different swapin
paths, calculate it early before the swap cache lookup and use that for
the lookup and later swapin.  And after swapin have brought a folio,
simply round it down against the size of the folio.

This is simple and effective enough to verify the swap value.  A folio's
swap entry is always aligned by its size.  Any kind of parallel split or
race is acceptable because the final shmem_add_to_page_cache ensures that
all entries covered by the folio are correct, and thus there will be no
data corruption.

This also prevents false positive cache lookup.  If a shmem read request's
index points to the middle of a large swap entry, previously, shmem will
try the swap cache lookup using the large swap entry's starting value
(which is the first sub swap entry of this large entry).  This will lead
to false positive lookup results if only the first few swap entries are
cached but the actual requested swap entry pointed by the index is
uncached.  This is not a rare event, as swap readahead always tries to
cache order 0 folios when possible.

And this shouldn't cause any increased repeated faults.  Instead, no
matter how the shmem mapping is split in parallel, as long as the mapping
still contains the right entries, the swapin will succeed.

The final object size and stack usage are also reduced due to simplified
code:

./scripts/bloat-o-meter mm/shmem.o.old mm/shmem.o
add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-145 (-145)
Function                                     old     new   delta
shmem_swapin_folio                          4056    3911    -145
Total: Before=33242, After=33097, chg -0.44%

Stack usage (Before vs After):
mm/shmem.c:2314:12:shmem_swapin_folio   264     static
mm/shmem.c:2314:12:shmem_swapin_folio   256     static

And while at it, round down the index too if swap entry is round down.
The index is used either for folio reallocation or confirming the
mapping content. In either case, it should be aligned with the swap
folio.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/shmem.c | 67 +++++++++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 34 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 72b6370a8e81..aed5da693855 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2302,7 +2302,7 @@ static int shmem_split_large_entry(struct inode *inode, pgoff_t index,
 	if (xas_error(&xas))
 		return xas_error(&xas);
 
-	return entry_order;
+	return 0;
 }
 
 /*
@@ -2323,7 +2323,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	struct swap_info_struct *si;
 	struct folio *folio = NULL;
 	bool skip_swapcache = false;
-	int error, nr_pages, order, split_order;
+	int error, nr_pages, order;
 	pgoff_t offset;
 
 	VM_BUG_ON(!*foliop || !xa_is_value(*foliop));
@@ -2331,11 +2331,11 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 	swap = index_entry;
 	*foliop = NULL;
 
-	if (is_poisoned_swp_entry(swap))
+	if (is_poisoned_swp_entry(index_entry))
 		return -EIO;
 
-	si = get_swap_device(swap);
-	order = shmem_confirm_swap(mapping, index, swap);
+	si = get_swap_device(index_entry);
+	order = shmem_confirm_swap(mapping, index, index_entry);
 	if (unlikely(!si)) {
 		if (order < 0)
 			return -EEXIST;
@@ -2347,6 +2347,12 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 		return -EEXIST;
 	}
 
+	/* index may point to the middle of a large entry, get the sub entry */
+	if (order) {
+		offset = index - round_down(index, 1 << order);
+		swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
+	}
+
 	/* Look it up and read it in.. */
 	folio = swap_cache_get_folio(swap, NULL, 0);
 	if (!folio) {
@@ -2359,7 +2365,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 
 		if (data_race(si->flags & SWP_SYNCHRONOUS_IO)) {
 			/* Direct swapin skipping swap cache & readahead */
-			folio = shmem_swap_alloc_folio(inode, vma, index, swap, order, gfp);
+			folio = shmem_swap_alloc_folio(inode, vma, index,
+						       index_entry, order, gfp);
 			if (IS_ERR(folio)) {
 				error = PTR_ERR(folio);
 				folio = NULL;
@@ -2367,16 +2374,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			}
 			skip_swapcache = true;
 		} else {
-			/*
-			 * Cached swapin only supports order 0 folio, it is
-			 * necessary to recalculate the new swap entry based on
-			 * the offset, as the swapin index might be unalgined.
-			 */
-			if (order) {
-				offset = index - round_down(index, 1 << order);
-				swap = swp_entry(swp_type(swap), swp_offset(swap) + offset);
-			}
-
+			/* Cached swapin only supports order 0 folio */
 			folio = shmem_swapin_cluster(swap, gfp, info, index);
 			if (!folio) {
 				error = -ENOMEM;
@@ -2384,6 +2382,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			}
 		}
 	}
+
 	if (order > folio_order(folio)) {
 		/*
 		 * Swapin may get smaller folios due to various reasons:
@@ -2393,24 +2392,25 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 		 * large swap entries. In such cases, we should split the
 		 * large swap entry to prevent possible data corruption.
 		 */
-		split_order = shmem_split_large_entry(inode, index, index_entry, gfp);
-		if (split_order < 0) {
-			error = split_order;
+		error = shmem_split_large_entry(inode, index, index_entry, gfp);
+		if (error)
 			goto failed_nolock;
-		}
+	}
 
-		/*
-		 * If the large swap entry has already been split, it is
-		 * necessary to recalculate the new swap entry based on
-		 * the old order alignment.
-		 */
-		if (split_order > 0) {
-			offset = index - round_down(index, 1 << split_order);
-			swap = swp_entry(swp_type(swap), swp_offset(index_entry) + offset);
-		}
-	} else if (order < folio_order(folio)) {
-		swap.val = round_down(swap.val, 1 << folio_order(folio));
-		index = round_down(index, 1 << folio_order(folio));
+	/*
+	 * If the folio is large, round down swap and index by folio size.
+	 * No matter what race occurs, the swap layer ensures we either get
+	 * a valid folio that has its swap entry aligned by size, or a
+	 * temporarily invalid one which we'll abort very soon and retry.
+	 *
+	 * shmem_add_to_page_cache ensures the whole range contains expected
+	 * entries and prevents any corruption, so any race split is fine
+	 * too, it will succeed as long as the entries are still there.
+	 */
+	nr_pages = folio_nr_pages(folio);
+	if (nr_pages > 1) {
+		swap.val = round_down(swap.val, nr_pages);
+		index = round_down(index, nr_pages);
 	}
 
 	/*
@@ -2446,8 +2446,7 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 			goto failed;
 	}
 
-	error = shmem_add_to_page_cache(folio, mapping,
-					round_down(index, nr_pages),
+	error = shmem_add_to_page_cache(folio, mapping, index,
 					swp_to_radix_entry(swap), gfp);
 	if (error)
 		goto failed;
-- 
2.50.1


