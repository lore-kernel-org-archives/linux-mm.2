Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3131460ACCD4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nVp17WTC
Received: by kanga.kvack.org (Postfix)
	id 4BF316B02DC; Mon, 19 Oct 2026 11:51:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 448B96B02DE; Mon, 19 Oct 2026 11:51:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2D96B02DF; Mon, 19 Oct 2026 11:51:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 043306B02DC
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:51:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AB2F1A80AB
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:51:20 +0000 (UTC)
X-FDA: 85339815120.01.0C3440E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9274F100003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:51:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nVp17WTC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792425078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RERAHv0f1FeePlwah3UOiQF6OoFt+Qe2xFbGw7JJygo=;
	b=4nZ7xUX18h9LTx21e3BhNkRU5YcPIv28I2DKgCMBHxau0zmAio2GqGOXXoKSR2SqxX1HdV
	h2q9Ter/JAS9Dhvx5DDEr59BeHEACNffM96KcDtJnzGshLv8Y5J+e7zUTDA+oz9EHAxeRs
	nppKpwfxhjjXN5lB5Q3P/uq81IlQFvw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nVp17WTC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792425078;
	b=Thhxjm/JerJoza9HLg93UoG7GMHWQPXRMl1h24R7auRVUP1GZ8nYW4IFvLeo5qEMWjLJlS
	9BzAo9JBLXN8cCYzel/acllIV7R5JNMLnc+s0PfBQVVCVycJdKeVP5/Nov5t+pYo5ohCRn
	+W9mB5ZNhZi09zfvlnzlvM5b0SF4dO0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E3EEE44504;
	Mon, 19 Oct 2026 15:51:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E0B1F000C4;
	Mon, 19 Oct 2026 15:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792425077;
	bh=RERAHv0f1FeePlwah3UOiQF6OoFt+Qe2xFbGw7JJygo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nVp17WTCGZq1k14qldmi5JzpY/g+CyF4VKgrTVccRfl4i4T06O4NRb7VgWzbFI/zH
	 myiQPWXgAHhVc/CRY9fcIMY0ieQAlF++fp8YkfMO5I/l3wK4UdPQi66Ae4ehsu3D/l
	 15hQ0zTglAow9EhdIGcjgb6DgAclapoSG16+yhqqtHyze+et0L33PYl0tiWns81tlx
	 gMZsbl3S/iL9/AMIGDBfQ9HHcc6whsZ0+Yo+eQd6UbXDtQWgzhRb8R7GlTvLqY77Qv
	 7+uAWWHUK7jwT6WCYtUVSLOw8lekOYHOuruFM10Sq9Oj6HSMWmr3+HjepFXBa0tXEi
	 nx9AzOMP6qdRg==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.ams.internal (Postfix) with ESMTP id 04F7D1980047;
	Mon, 19 Oct 2026 11:51:09 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Mon, 19 Oct 2026 11:51:14 -0400
X-ME-Sender: <xms:bTzWauYf77b2W8v-ONgvv6tBwE6NoKdZSEkBkYHJqcPo40VbIYXRJg>
    <xme:bTzWampMXk1TOFKrPxxCPCHMsjSIyuLDQlLiGsthTxHTArBOHqc1JkHkcsaGxulQm
    cBMxFljtMnH86CQeObQ0VgC8fSi-MEoqlb7nvtLz0tcDEderdOhNCoZ>
X-ME-Received: <xmr:bTzWarkU0iu4xNCwOwWKTc69RXpeXsmkeLVBpM1dyx7FGggWT_hgfZd2jE4>
X-ME-Proxy-Cause: dmFkZTGFA7RcREpaZWsLyw0Mr0XLVEScxscceCzrzQCctey9GkLKywZksIPHQL++5Ez1l4
    8ZtK4uQQ55DP6KC6KY2Tq4MmUijTRf9wNpB+eBiDYQyyOrNdkCvLnyLRoWmHqIJi9QgC5s
    a05lQI5Z36HZWoOti16iaeg1yeaoNWQf/xGUk9VWOqtF6qbSZNTrI+y5DzMoADYW/WYpe6
    xi0sGgMnsbIx31el0gfeshdIZno0srcJI8ohhNflL/0R7FrINqZHMwN5cb6lyav8SgTLVW
    L8jKHwxa2hVAuYmQV812wpYXni4+G+KXXKip3711Z5uNAji8ERrYRXaOa0gQ3V/ELjwdMB
    DY6RU5nX4lcmyZdq4kUuM+SZbr4DMh70PPeGkUpDgnX4Opf3mcxVPJ3HgHr4XJ/Sk5tPy7
    8xkCP9KYYUIlOnoYhtjVR3wPGHzGSuWnUPEZbh6vSNUWpd9lY+9iEhBZe7K6FJUPkMT8gq
    6W7cpQ3gxgFCXjGoNwpbmy2ccVtcSyoNpgIHVodlO0k+HOn8cFjzadooNdrrWVeM+CdYcC
    HTGsHHA9WhN6V4Ey1PUvmL6yOlYHbYD6AQv6Dda/+zzOicvimkllzttVSDEHTLijtjuhHY
    lrffnLRpPewMkqkSl+5MIOwX6fRCrGvVBPPSbjlkDw0USvz1zHci4cNsdx5w
X-ME-Proxy: <xmx:bTzWagUlZLE8_5n-leBaCMpdZtiH17ti9ud2JQXG7Iv4xXaN86sfPw>
    <xmx:bTzWaqTPmqzj0zd5QafpeTE_Gg6Iz9pm9MJbu2d4U60TPGMGj25SiQ>
    <xmx:bTzWalnTAH31iWgwwIeBXAmkWFSm6sXTO7Le86pRvTw6DhHFU-JNOQ>
    <xmx:bTzWatIsyEJwAp-U_A3J1RFiuZXKTu-D-F7y4RJCSUgwUb1L61uiXA>
    <xmx:bTzWagUH83c72LL_fasXLLGuHazhJcM_vSOt1AfzvS2oGYKaGjRR7xW5>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:51:08 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Harry Yoo <harry@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com
Subject: [RFC PATCH 17/18] mm/shmem: read without folio references
Date: Mon, 19 Oct 2026 16:49:10 +0100
Message-ID: <20261019154913.1765974-18-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9274F100003
X-Stat-Signature: 59uxqsrqfisewmsn3owxrypmhgj8w3eh
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792425078-494382
X-HE-Meta: U2FsdGVkX18pnxastOp3DhwHhY624sL6ip9Rzy80T94e8sKglCpA+jodtAzqCtGi3bVrSoB7JWQel6oV9dbkeG2YLLsCGgh/yFANoM7n+7YjRAJ/Edjwf/Ge0eCsvXthsApDr3QYj+Hjrzh6zhLyqUOKIUIMoHeZgJbhPzVLM1pqf7DBMjVL3pQU3YO1lxoaMBflMvl6RW7WAlkYS/KP5qINw4uCXaJnTpUzyvBuX3DbjO0jJFQy9RAncB/AW0n7Dd8nGJF8PuhJhMp55f81EIR1SHkpdgRSsCZhTFbxIUoIXVH0fCzvkNCJhEkBdPBlqQ3feX/p9/7uLvd6S2WW42FsjDURpLynOo7NA19NrF57yChBKy7pwHwd95m1y9kmfgKPHnT1TKCcusFWUVnCNTCYM528r1UMgYKLW24OjP8JpVgPmVSdyJ/ACDJvxej1RI21ElY9rWVi9KgrqmgYk3uqdLJQ2kdT0Q+EyrQOFof59Jn/GNPv0s++pKlt62HFUJ/MOcQZ92OadGXmbknHIPLmQtelGTsIgJF7Dbimm/zbhxSw/1wEg2j8d5/Be7+1SWKgmw2VRxQJI6D9ibhs16T7RDk9eFEM16evsNCbBO4BKe8uwNtEZDP3A2qRFFYBdBVAJFupkq/ZBOZvAGa0q/0pugDRum/W1682XmuwIuogLZSJoXLF3imGqiYVOVsWMLVZ6hTyGQ6dMf1NnZ5Im2XPFmN+koHpHLlc7DC7nlrKlzJhUWEFXrz/xMyTFGbRvFR7zYWJW5ZBACIaifY5NMD1ZOAH5vhgm1ruPBMGHy7VnTT3bTFtEb/VRam+CDxwVUuFtcAsaXauHOhVAvqPva1qR43cXj9RXMXVZ92MSqK9BJPZvRHvMobBTDxvsUSC2v1ftXt1/yNKrikAVe7rf57vheEN+yIR/rcyJDhmqn9lOQyqfE0+9OV34K3aQmbNOzKFCDGrkB6tNOKNw3T
 YEzem70B
 Vhb99O6LAPODkaP38LDcfZjWjQZqqCY5qUl5mAt7jBZfMxF7tE7Iu5GvYfOnJcF0mqsXc2fA9gw78UJHxexgu8xrZxaybxsA9maFU1V6zD+ukpAt6MD0T25MlFxPE3DGn//l0e0hoUHbqztiThsGRoDBQQMMOAY8Rj0N2FwRFVWieHaykLGR0g3eWtVFkHTbHj9MVJicDEHT+BMDds9GBrl15dU4GI2rVM6tnwYNCzxsaODbWhmqns8053onZesWAksAua07FT6uwrSB3oeu4rm0j0ao0criLGf0xJzdrqToB9C8QWwLhuLgMXxlk2nU8lJ/NFvmZK4xgU3dRat0fm3+P5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

shmem_file_read_iter() takes a reference on every folio it reads, so
small reads of one tmpfs file from many CPUs bounce the folio's
refcount.

Copy with filemap_read_rcu() first, and continue with the existing loop
where it stops.  Holes, swap entries and fallocated folios that are not
uptodate all end the copy.  So does a hwpoisoned page, which shmem keeps
in the page cache and reports with -EIO.

This drops the folio lock as well as the reference.  shmem_get_folio()
held it only for the lookup, and the copy ran after folio_unlock(), so a
read was never atomic against a write or a hole punch.  Now a read also
does not wait for one that holds the lock, as filemap_read() does not.

shmem does no readahead, and on its folios the PG_readahead bit is
PG_reclaim, which drop_caches can leave set on dirty tmpfs folios.  Do
not let it end the copy there.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/filemap.c  |  7 ++++---
 mm/internal.h |  2 ++
 mm/shmem.c    | 11 +++++++++--
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 4b5b7ba78f39..cde7bc68b32d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2837,9 +2837,10 @@ static void filemap_end_dropbehind_read(struct folio *folio)
 static bool filemap_read_rcu_can_copy(struct folio *folio, pgoff_t index,
 				      pgoff_t last_index)
 {
-	if (!folio_test_uptodate(folio))
+	if (!folio_test_uptodate(folio) || folio_test_dropbehind(folio))
 		return false;
-	if (folio_test_readahead(folio) || folio_test_dropbehind(folio))
+	/* shmem does no readahead: there the bit is PG_reclaim */
+	if (folio_test_readahead(folio) && !folio_test_swapbacked(folio))
 		return false;
 	/* memory_failure() waits only for readers that got past this */
 	if (folio_contain_hwpoisoned_page(folio))
@@ -3017,7 +3018,7 @@ static bool filemap_read_rcu_batch(struct kiocb *iocb, struct iov_iter *iter,
  * Copy from the page cache without folio references, in batches, and
  * return how much was copied.  The slow path reads the rest.
  */
-static size_t filemap_read_rcu(struct kiocb *iocb, struct iov_iter *iter,
+size_t filemap_read_rcu(struct kiocb *iocb, struct iov_iter *iter,
 		loff_t last_pos)
 {
 	/* The page the previous read ended in; ULONG_MAX if none */
diff --git a/mm/internal.h b/mm/internal.h
index 18391dc50418..ae9a4e511c82 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1249,6 +1249,8 @@ struct migration_target_control {
 size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
 			      struct folio *folio, loff_t fpos, size_t size);
 void filemap_read_accessed(struct folio *folio, loff_t pos, loff_t last_pos);
+size_t filemap_read_rcu(struct kiocb *iocb, struct iov_iter *iter,
+			loff_t last_pos);
 
 static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
 {
diff --git a/mm/shmem.c b/mm/shmem.c
index 43ddb50974a5..e6c18e745f81 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3313,7 +3313,14 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	pgoff_t index;
 	unsigned long offset;
 	int error = 0;
-	ssize_t retval = 0;
+	ssize_t retval;
+
+	retval = filemap_read_rcu(iocb, to, last_pos);
+	if (retval) {
+		last_pos = iocb->ki_pos;
+		if (!iov_iter_count(to))
+			goto out;
+	}
 
 	for (;;) {
 		struct folio *folio = NULL;
@@ -3417,7 +3424,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		}
 		cond_resched();
 	}
-
+out:
 	file_accessed(file);
 	/* Readers sharing the file would bounce the line for nothing */
 	if (file->f_ra.prev_pos != last_pos)
-- 
2.54.0


