Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F871CD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 09:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FB836B009F; Fri,  1 May 2026 05:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D3A06B00A1; Fri,  1 May 2026 05:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C2146B00A2; Fri,  1 May 2026 05:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69B9A6B009F
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:50:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32C0DC14BB
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:50:23 +0000 (UTC)
X-FDA: 84718380726.09.88AC646
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0E1A340006
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:50:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kKVnoSQr;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777629021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8B2RUjq8jBK2e03j/xFVxpLt5AXUKl1QQvY/ZUPjfBE=;
	b=Kbp4Y1+FLVV91MkcUNXISwDzsGlfdaLtevfp61d7w8lhUoC5Qdt/rucpjoZ4c+rAYC97uj
	iC2iDgTheGiRqV+2rhV5HmKcaQcooF+8T7ZxhpzPRm80syvoPkHP7rnYxm2k4CL3IcT4v1
	2/6LlaRFyLYRSrMntnzZVVE+WwuV8u0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kKVnoSQr;
	spf=pass (imf07.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777629021; a=rsa-sha256;
	cv=none;
	b=GyIl68mgVNO1psQej0X0FdolDSvAn6VZLS5WimoLyiz2BWmUYgKdiAk/bULVHRQSz+vFgB
	+hOdoI2AXDLk0v4hBYF/UwKFT/yPhQqo0mMsuVBkRm2iKyXy5JB9amNHJCAI0c0ZefZQgj
	ZbzorYzBFZEvMQBHaduXrAZmdyy/Gsk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E9778444BC;
	Fri,  1 May 2026 09:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D515DC2BCB7;
	Fri,  1 May 2026 09:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777629019;
	bh=4CYXeOlFdNJ/l03z2utNHrOYCz+YwEmVX7CEA57VKaQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kKVnoSQrWJeDILj7+mIfDLX2WD/0fJg2ViILcSv46jpdeO9Vx4w9kZ3AW5tXAdSOT
	 VqjrDTlg+ZM8yUOrQeTKFdDtbqtAJbkuE25QQv9n4mh+DLkOSnWP9ltsCfvQ0iKTrO
	 aPUX4tQALCljkv8adxFtd6xicjVU+UKZSKcCcE0D9gnA67ltC8miBdOYnuiLS+UiGz
	 6qSbqes/CKa+6PETChdfQtDAvz+VZELHp/F9gTEozl9Cm7a5HqbsZYKT+QD6ecbhug
	 9IhKebdVDSvcBDKqPWOAAbQcqA+7duHlwUNjdhWLAWges5mS9/vKTAjVypZTmtO6u1
	 vYYq+7Mcfoc6g==
From: Jeff Layton <jlayton@kernel.org>
Date: Fri, 01 May 2026 10:49:35 +0100
Subject: [PATCH v4 1/4] mm: track DONTCACHE dirty pages per bdi_writeback
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260501-dontcache-v4-1-5d5e6dc71cb3@kernel.org>
References: <20260501-dontcache-v4-0-5d5e6dc71cb3@kernel.org>
In-Reply-To: <20260501-dontcache-v4-0-5d5e6dc71cb3@kernel.org>
To: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Snitzer <snitzer@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Ritesh Harjani <ritesh.list@gmail.com>, 
 Chuck Lever <chuck.lever@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nfs@vger.kernel.org, linux-mm@kvack.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3683; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=4CYXeOlFdNJ/l03z2utNHrOYCz+YwEmVX7CEA57VKaQ=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBp9HdPPFn55EVKdK2kssKhcP5f4apt0ClJopsC7
 t1wRkqHf96JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCafR3TwAKCRAADmhBGVaC
 FeqCD/0Zqep3sm7p/GXonKUD3Hrr+qlUGhzPqP4bv5R18zbFwInLPz9G7ypQwV1i3w8OE/BfKcb
 zYYwJQi7Oke6qUeEkVur0wj0z0ZP+G5rUK/HlhNVYzG+XQgomTnznPcMEBtbtwS7VYL+0anFLQf
 IG4wpFtM959wNowJe0wgV79AwhezsYimbD2BZzSiqk9vSibo+7jkRChHIpQCK9flDS10GJoSFO6
 hPRiLSO4y8Gc6HE77vD+Cu6JinCmzhQ1Amy9Z7b94vzcyi4wjgDdYKlHtUMI/9zQP5Z5lWV9QXX
 Kk5sfuv1g8KQ885ZXKDkq91bWtTZCJdHzPDPu0L5KI3w7jIWZh+39y+C/XIYHlxJ9AMFcVYwpo+
 4BFipwwcEpXuO064LT9CkbFddWSfPR83RDoV2H4N5Inylh8sqVp7LdnRT2H9TmDbEDWAaEdJoff
 G5HgvlhpoPevt7C9nFP9h8Kz4Gnz4hsF0xaeyMLzJIF01liLM5VNPr32utprTE75JCxrX5Vag4e
 kYevA9gwOe40xAjnOZmeH24qW0Aeesuc21gzO4DM1+fNikEjzHkQ609t6spwJrMp168x/jOx47w
 iLuinj8ZUYiBP2sxFQYgStBcRqVP3l1wlQtoeU3oOyMR5UX9vi3vHlqXjSTy0Ex+VbbX9AS5XUX
 STkQPWt0m0Q1q0Q==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215
X-Stat-Signature: in958p84fswnd6jxjfa1eycr13fq9q9q
X-Rspamd-Queue-Id: 0E1A340006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777629020-623134
X-HE-Meta: U2FsdGVkX19zMiXlPwy05nG01RAbsfxyQO9l5Kwj14O9GZCUCxoPPH7OV03o/6yn3OVmjid4LYjTEdmYN6YqJzo3Iy4VC+Tijv6XTZdehOYcftg+GcsXolB/bUf+492ZfVnSVzIoUItlwbKTHtg/fi24pkQHSkgasP7QmKpOC9OG02AqFW2uqM2Qs3zHJ2iyq1Yc4XTy7MtK1s8cM+B4kFqu55tG5QyFNTPqN36jkQ8wM8HzE2iivgk6vsHEfIHUmugS4inhxOFLpuuMH3eFYbQBfsWcceAWD8w6lSiO53IuQiDNs4dThXSLDUqYDex1PmJr/n3Cnd6+8BgL2uTx+sKaDeOLOFoAgYghj00E9f26N8hHDm6GRxXtvgD6+YGdjUxKRnJ1uP1uf4vLvSh47Boax3DvNiUNONii5I9RH1a2duD2EvYCsX6RBvssuYPXhFGOYajZCFiXzAJNP0M04S5JnQxl09nTBKDHEuD4NbAOEZKA1flaoOOw8ryOwsuF37wEQeXGkU6ycNzIkMVriYjMvJoa7b7m/aVWhLndrNTuNRqJD29zU6r2cEyv0pj/UN4jM4p843QXDITIVUYO5eMmy7h0TTffB/wNNmcoGfNzaFv5gjYEypYQiMZAxHYiqtLeuTEdqNiGUDURfl/omO2HubKW4fhSL4zo0BEPxPEqE0Z0XT87SOoB30/jnkn2RIiwBwsWiuxfwe1Wj3SMYA7LqjokAEBTG8g9adZD6h8Klhnqn4OopHBQvqXwfSg6p374X1peBJoM9PXN3I6JbdZV+nRh9SWd0D5HIw52vTd4uqKR/OwBKPE4c0eQc9NN6c5YTviziCtglq9Sskku8GwT184GmkSNliZADzpN92Fr1+DTNqF+z6lJ6RJDjWbt0xCv6n8Pyb2z8XCIEd32pwoptpSBIKsVcC3RknaJNN4Ql3ediTx1lOOffUB2GmMsqJgS6+JQy2eASwcZgLe
 HmCsBeeH
 ySb4xKMDS+AgpHolmheXrtSdJ3plJQJZj6besvDJLIY9UAr3Gg9vttlpg3L8x6JySy2Ca1/yu2oG9nEz7Sr0lkfAM8DlsJUpk7QYavqEVBl23311k8QvV0ArK2GUpVZzbESzO4RAhlQlHT8QH9dZIH3X9YokySf3PT/edy2gWaK2KbmX3NgF0ujHX1AVpZY5PofIIGNI7o2ja3FM3FTRsTf64q8VcanHRJcdemTzMw0YWpSO+ftAa1/M58Op1eqOym8JWwTI6Pbyiyo7/ECcD9WxA08Ex4uRkfUXVl0IzJl2pqc7UuzKp3WVvp9NASfID6YDhA8uHuDpW5WmLnA4ot+tLlJpeqBdFAkdD/CK/ZPkKtvw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a per-wb WB_DONTCACHE_DIRTY counter that tracks the number of dirty
pages with the dropbehind flag set (i.e., pages dirtied via RWF_DONTCACHE
writes).

Increment the counter alongside WB_RECLAIMABLE in folio_account_dirtied()
when the folio has the dropbehind flag set, and decrement it in
folio_clear_dirty_for_io() and folio_account_cleaned(). Also decrement it
when a non-DONTCACHE lookup clears the dropbehind flag on a dirty folio in
__filemap_get_folio_mpol(), using proper writeback domain locking.

The counter will be used by the writeback flusher to determine how many
pages to write back when expediting writeback for IOCB_DONTCACHE writes,
without flushing the entire BDI's dirty pages.

Suggested-by: Jan Kara <jack@suse.cz>
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 include/linux/backing-dev-defs.h |  1 +
 mm/filemap.c                     | 13 ++++++++++++-
 mm/page-writeback.c              |  6 ++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index a06b93446d10..cb660dd37286 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -33,6 +33,7 @@ enum wb_stat_item {
 	WB_WRITEBACK,
 	WB_DIRTIED,
 	WB_WRITTEN,
+	WB_DONTCACHE_DIRTY,
 	NR_WB_STAT_ITEMS
 };
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..1c9c0d5f495f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2052,8 +2052,19 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 	if (!folio)
 		return ERR_PTR(-ENOENT);
 	/* not an uncached lookup, clear uncached if set */
-	if (folio_test_dropbehind(folio) && !(fgp_flags & FGP_DONTCACHE))
+	if (folio_test_dropbehind(folio) && !(fgp_flags & FGP_DONTCACHE)) {
+		if (folio_test_dirty(folio)) {
+			struct inode *inode = mapping->host;
+			struct bdi_writeback *wb;
+			struct wb_lock_cookie cookie = {};
+
+			wb = unlocked_inode_to_wb_begin(inode, &cookie);
+			wb_stat_mod(wb, WB_DONTCACHE_DIRTY,
+				    -folio_nr_pages(folio));
+			unlocked_inode_to_wb_end(inode, &cookie);
+		}
 		folio_clear_dropbehind(folio);
+	}
 	return folio;
 }
 EXPORT_SYMBOL(__filemap_get_folio_mpol);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 88cd53d4ba09..8e520717d1f6 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2630,6 +2630,8 @@ static void folio_account_dirtied(struct folio *folio,
 		wb = inode_to_wb(inode);
 
 		lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
+		if (folio_test_dropbehind(folio))
+			wb_stat_mod(wb, WB_DONTCACHE_DIRTY, nr);
 		__zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
 		__node_stat_mod_folio(folio, NR_DIRTIED, nr);
 		wb_stat_mod(wb, WB_RECLAIMABLE, nr);
@@ -2651,6 +2653,8 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
 	long nr = folio_nr_pages(folio);
 
 	lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
+	if (folio_test_dropbehind(folio))
+		wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
 	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
 	wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
 	task_io_account_cancelled_write(nr * PAGE_SIZE);
@@ -2920,6 +2924,8 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		if (folio_test_clear_dirty(folio)) {
 			long nr = folio_nr_pages(folio);
 			lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, -nr);
+			if (folio_test_dropbehind(folio))
+				wb_stat_mod(wb, WB_DONTCACHE_DIRTY, -nr);
 			zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, -nr);
 			wb_stat_mod(wb, WB_RECLAIMABLE, -nr);
 			ret = true;

-- 
2.54.0


