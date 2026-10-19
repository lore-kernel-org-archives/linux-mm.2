Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18EE1606C91F
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P76XqEwv
Received: by kanga.kvack.org (Postfix)
	id 645026B02DA; Mon, 19 Oct 2026 11:51:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF7E6B02DC; Mon, 19 Oct 2026 11:51:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BEA36B02DD; Mon, 19 Oct 2026 11:51:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 208686B02DA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:51:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C067B8072A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:51:12 +0000 (UTC)
X-FDA: 85339814784.07.87AE0A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id CE05718000D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:51:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P76XqEwv;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792425070;
	b=ngUA0AK8mW2NSMTAUOUX4S9NIIC7XIRwDVeeP8eB6C0iHEKpuxWDjZBVXIkIbkMle2xaWs
	iMVM3oWYTHUFILSNAa7MO8/lVEjgsf90OkwFDKaCw54j1pMBglMn2mMNi0Na0qerLOZ0FS
	HTuo4blvFHOQAl0U0xxvuGRCyCemkrk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P76XqEwv;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792425070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nzf5AOZecE/pgMusAub/Smm2ReUG3xW+PWHZuYHUyt4=;
	b=71VpGIqjrwg+LMDzjgrtV9fUO6zL42CrntdsNs1FWJ+skn0NKOhd7Sfjb3NJlo/zPN6dOJ
	nKScb0mqzPhw9jriQ8MtsKYFSiWd+5rYHTBdOEk1XD89hjKR8bODBBvr7yG8jytrkQwwU+
	otdreKVtZ0SMTrI+B5StrmjsH2d+j3Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6405F60DAD;
	Mon, 19 Oct 2026 15:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78451F000CF;
	Mon, 19 Oct 2026 15:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792425070;
	bh=nzf5AOZecE/pgMusAub/Smm2ReUG3xW+PWHZuYHUyt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P76XqEwvYvtRiChGcMWUkKRntAV/ce5/WAbDoQUHDxuyq/aB6KdTUrY78u0cXtIP6
	 epFp7w4oJ6TMIyqBYj5OwvupZvIxx0sVNv4byNU0buBm+RiKpLfEHmKJSfAOG/Wvm8
	 dWNlpOHY9hcSDqH8t/aAoNR9F+d1gHDYB1HIylmtVlV/y+P+pwexEONeAlTgLhIeqX
	 n44jzEdIsOgrDlvXmwtwKaCZp3TblM1Qe2Ptl0PKcvwZQFDv5pQyvSvCvTHuLzqDMN
	 yJOUDq31Ztf8n9aWV5p9MFOraPQhZN/taiRlQxrki7CSdHLaBr9ku45PVpfKHgQLOD
	 mT9xN3yE6tpsA==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 9F85D198003A;
	Mon, 19 Oct 2026 11:51:03 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 19 Oct 2026 11:51:07 -0400
X-ME-Sender: <xms:ZzzWagvnHzpi2QV3TgoGU420L-mLrWpe4ZeZ3YsBGoAYKAOlKwHuPA>
    <xme:ZzzWakaRmRX07FGWx-lFgXP_y55PfBey5tiqcPlbsYljwRnVNudZgeGeuMi9oI-MP
    l3nFIYQPYr3VDIZDhdI-wKfeNfkILHkWdqsvKtI1CvawJgwDAqx_xo>
X-ME-Received: <xmr:ZzzWag7bNo07-OVAYs9B8KdVDMf0PsYoWGshMCbKlaITt0nmYvXi_P-P5p4>
X-ME-Proxy-Cause: dmFkZTESqR4vElUNfwe4Wb1kabMg9MdYUtHyNIvlHi5jfGRsEd0tjiYfzpqh5FemuLlMuA
    +QzWL/iolJzzDzQk8vzuoT2/u2xyL/YZG/CihU2eaSQe3uAw7YKu/Z/hQfgMIJpEQrBQkK
    hH3KJVpCmjg+gNXnnOIkdBMKpJa1pvTLqzuojrt68Uovke10kpOzVhZrNEf3d58NDgoR+6
    GBwzdAiHoLFFDGJo3/r+XBHeUTBbw+IeFaYdgC0j5JEQlKAOMB5I7tBUfVMuw5hMfUnXf2
    vE1DwOk7N/x2FbtU++Y3QX/1ODQhD5sTVGp3EMvK4jUTItTZrn4RBPsK+PhnbeHfl8JcpJ
    c2LUHcVVlnTmrxA40olgviWRl9T+26cUEoz3aZJIdT1EfpFsU+0thKqzxFC9q6r9alkT7P
    UjijYajoIbQcUwCvES00HGkFx6tcOfQlzfxTtLaIAWuifAZVmXruOnjSB2KfmIGd1Tp9h8
    pT7XR7J6tU0+2PVC3G7YK2c6UKb8RdB87PPzk5qtMsP2YH1aNuaOcR9AoL/bstgEKQzsbg
    t6Ubf6j8Uiwe5o955Rjad4bmK7153G+aKl6kgw9QxprBMlsBHQpSij80iErZkMlHPp5FCS
    lHriB7oqc0/oTiW+ZSU9MPqkYvzaUVlCHKrJhXKPuBMUw+OJ0rG24eS8p+yg
X-ME-Proxy: <xmx:ZzzWanlnKjOnpqouLmcZBHTvvQZAhOmIx28gpgaFrGTPuBZ4WXkrpQ>
    <xmx:ZzzWagrX6Xgxxskve5xmxtyfDhrB1FnQjMlC3CRer3mcBjheEo2dGA>
    <xmx:ZzzWai_Fe8OhMS5ikxCMThpHx3RGb5NTGTJgIUNrfuKyzoKEY0ZniQ>
    <xmx:ZzzWap50Crsvkz0DJ5oSQ2M8pG2fFH-AZ9Ga4gWMwCxQvkjGLJdxxQ>
    <xmx:ZzzWasaRQDbFeEJeYYHn_EpIsUNRWZjO0GImBaEDkaeVCkMQ5avkpNes>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:51:02 -0400 (EDT)
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
Subject: [RFC PATCH 16/18] mm/shmem: count accesses to a folio the way filemap_read() does
Date: Mon, 19 Oct 2026 16:49:09 +0100
Message-ID: <20261019154913.1765974-17-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CE05718000D
X-Stat-Signature: tagpwquotroqu1145hcqrirmowdqg4dx
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792425070-838899
X-HE-Meta: U2FsdGVkX19qBscWq+m+CRhhnChtY0M1F7McNIsiuf7QvSzqBJYzfJYT26OrtmF+NRb9vtIxIOfp7Bxgd5kkBrREZdQx4d1AWd5D1O+1WNPXf4pCXMSC0dCHTn7mbu8J06XzAoclzBD/eRZaDhS9L0rgW7lCj6PflV6+Ci6eTQ46XoKTuwVqnirhzwL8bkNsIceS4xq4LuKENeOMc9Q1TlVbE0QbV4SpbMm6UaioD2NqKRyp57Wzrn/hK3lXAtRX1uonkh5OR+8UgB3PQ3aICHTxOmA1FkatRhWJ+gbP+K1AsSjeneAgf10LJ8oIKQjfzeyZWUpsCDtwTReNRrXvDAy6BJNiuAqeVWKPJPWS/K0AjHTEpQ3/QYY5RjhH9wnhR6QGIsGGkFFrdPqPsF813womo4JA7APdaJG2XfxmI4sD5W/TeDd4pYxc9UD3MJ0c4S6kG8DR3V5rHVBbLgRqfFl84oHamkk3pLcysy7YwHq4IBcUlfOl/tRfSuVxIInmQy0E0uItxpJkWZc3UUxQm7yfDFFmHeYFbpzEr5crUpQTYpIF25PDxvvNCT5zVU7AQiAK9H2ccds4VgbmmKoEgzZx0qp90SUPAS/OktW8RX9IplPsTR84TDIcX4PRaj0fBwmHORRZYdz2c51yvoKqRz0Opfa4TF9hQaHqKLKhO5ucpk9WIAcgxwRNWV0T85Gmzn6bAwGd6vXre8dFAugGgmeG32WQCkdCfds/3YG+HAlo2ucyvR/Cyvk635JbYUiA2gk5zbCQMIz0cNKkBdf4bhK755Z8gkpTxCnsI9vN6SU4319rQWza1irPY/ixFpzcLPhX7Vw5R06vXS8AFqMCcJ4oZBSkcbEa6YDuYFqXjR7rTT45mzP1Z62X0I3mk0JIX+rdjqpd9uCsxZO7Tq9VEN1mevf+/37vxBxp1G4hbfqhP6Jj1VNn3hUWV26+Howr/3g5aj3bimX3/8RE6Hn
 or3/n0yw
 Qv8m7cIHzDL/bMNZj+j1PBnMqFzcwhZdCds+/1LRuxeTwwFmgx1+I95oNnvFgdZ9ap2xq4qw8r50AB+kQ7l4Y+ocZXV4U7J2ik7SY0LkMHqXET/0T2j8eekm+euvBm1UmksPNL69mKyPfek5vdwG8vPMd4pcnTSnMl0W+q9crLRqYS7/ZKc7UnELruLAxyTodSCtNETVOaIpKCzgDeWCJORhxGUs7JncPs7pths2WSCIsXbnNd1FxQnKKwIQpmk+3jmiHmW6mwa4sBdL/PjUSjo+YpUWIRA/up6du7Bvvw/WJQwOroa32UdRtPuzQZoKE3yxllV9nVTPqzhYGkuydv6lUyslbYkXubGAticDAQYOM+IA3Uvxy63ZZTtgVjD82LjyZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

shmem_file_read_iter() marks a folio accessed only when a read starts at
the beginning of the folio.  Small reads that start anywhere else never
count, so a folio that is read over and over at one offset ages as if it
were never read.

Count accesses with filemap_read_accessed(), as filemap_read() does: a
read marks the folio accessed unless it goes on in the folio that the
previous read through the file ended in.  Reading the same bytes again
through one open file counts once, as for other files, where it used to
count each time it started at the beginning of the folio.  The end of
the previous read is kept in f_ra.prev_pos, as for other files.

This also sets PG_rcu_free on the tmpfs folios that reads keep coming
back to.  On a shmem folio the PG_readahead bit is PG_reclaim, and shmem
does no readahead, so do not let that bit keep the flag off.  A write
marks a tmpfs folio accessed too, so a folio written in several pieces
can get the flag on its first read.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/filemap.c  |  9 +++++----
 mm/internal.h |  1 +
 mm/shmem.c    | 11 ++++++-----
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index ace6b1fd6b9e..4b5b7ba78f39 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2778,8 +2778,10 @@ static void filemap_mark_hot(struct folio *folio)
 	if (!IS_ENABLED(CONFIG_PAGE_RCU_FREE))
 		return;
 	if (folio_test_rcu_free(folio) || !folio_test_uptodate(folio) ||
-	    folio_test_readahead(folio) || folio_test_dropbehind(folio) ||
-	    folio_test_unevictable(folio))
+	    folio_test_dropbehind(folio) || folio_test_unevictable(folio))
+		return;
+	/* shmem does no readahead: there the bit is PG_reclaim */
+	if (folio_test_readahead(folio) && !folio_test_swapbacked(folio))
 		return;
 	if (folio_test_set_rcu_free(folio))
 		return;
@@ -2802,8 +2804,7 @@ static void filemap_mark_hot(struct folio *folio)
  * LRU records, or when this open file goes back to data that it has just
  * read.
  */
-static void filemap_read_accessed(struct folio *folio, loff_t pos,
-				  loff_t last_pos)
+void filemap_read_accessed(struct folio *folio, loff_t pos, loff_t last_pos)
 {
 	bool hot;
 
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..18391dc50418 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1248,6 +1248,7 @@ struct migration_target_control {
  */
 size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
 			      struct folio *folio, loff_t fpos, size_t size);
+void filemap_read_accessed(struct folio *folio, loff_t pos, loff_t last_pos);
 
 static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
 {
diff --git a/mm/shmem.c b/mm/shmem.c
index 848316eaa7f4..43ddb50974a5 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3309,6 +3309,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
+	loff_t last_pos = file->f_ra.prev_pos;
 	pgoff_t index;
 	unsigned long offset;
 	int error = 0;
@@ -3378,11 +3379,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 					flush_dcache_page(page);
 			}
 
-			/*
-			 * Mark the folio accessed if we read the beginning.
-			 */
-			if (!offset)
-				folio_mark_accessed(folio);
+			filemap_read_accessed(folio, iocb->ki_pos, last_pos);
 			/*
 			 * Ok, we have the page, and it's up-to-date, so
 			 * now we can copy it to user space...
@@ -3410,6 +3407,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 		retval += ret;
 		iocb->ki_pos += ret;
+		last_pos = iocb->ki_pos;
 
 		if (!iov_iter_count(to))
 			break;
@@ -3421,6 +3419,9 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	}
 
 	file_accessed(file);
+	/* Readers sharing the file would bounce the line for nothing */
+	if (file->f_ra.prev_pos != last_pos)
+		file->f_ra.prev_pos = last_pos;
 	return retval ? retval : error;
 }
 
-- 
2.54.0


