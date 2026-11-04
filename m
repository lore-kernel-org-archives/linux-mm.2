Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9EE9606A337
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RLbBmCrt
Received: by kanga.kvack.org (Postfix)
	id CCC716B05CB; Wed,  4 Nov 2026 08:03:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA37D6B05CC; Wed,  4 Nov 2026 08:03:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B920D6B05CD; Wed,  4 Nov 2026 08:03:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99E876B05CB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:03:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 248C5120594
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:03:10 +0000 (UTC)
X-FDA: 85397452140.10.1449238
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2D49240006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:03:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RLbBmCrt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LyJ5LhydnHWMWHiwLye8xdx6/6doxNo3rjssOxw/XEA=;
	b=bZ1VgjGr2WzEjxQzG6C0p/p5TKsUGR2UgHtR9NpwE4zCvmhDVtsG49H1dOcfw01JVaYWh/
	am68IPDamGwXvex4LER1M7TvLPwQGxbmG2o56PRVOGm28PWa0v7JqMS9QRnLn/e1xnlq4l
	Vl05Wl3DBeyfjjHzJVZEMC79aQuENp0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797388;
	b=MYiPxQDVszeiOoM+ZlCunHaatIpoM2ePkGi4JnUOUSA0I0RQe4yH7VRMrHlSGoQpkneFVv
	wf80Kv5+TPD+ySjLS78BGHs751r1ysJNhFOniL7uW7pS2u8THeCwK7zWClsum4/H8/idcE
	qo1Hod2UA2gLsgXXxNf8u5A0d+qySCg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RLbBmCrt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B0B9F63D58;
	Wed,  4 Nov 2026 13:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06691F000C1;
	Wed,  4 Nov 2026 13:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797387;
	bh=LyJ5LhydnHWMWHiwLye8xdx6/6doxNo3rjssOxw/XEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLbBmCrtUa60xuCrBC8BAWP/XK96WIAWbFKNGpsqirSqKkQUrQWxXrvksO2J16c+/
	 0WKIE4wdeJ1xe2E59FE47afAqMbxqXhya+lnTkkPHCfH3heH1TDb81UrG7pkc0evE4
	 wh1nYcwXRvgx0Y+1HI9FMp4QWkcEJoRTNan6hC27YLnHoSbkB1wmCVnvNXim9pVz+B
	 qFcR9T7DTvB/kYyKng78VXIipAci6WWVCjTZsnouWFHUTBHrkbtU8AKToK3FfCdW4X
	 /zWDp1c5UWNSftYVLo7Omq0nTpMreSHRZkSBWpgB6qehF/TfjSDntxnrgN77BZumCV
	 MJfM0VrkjoqiQ==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id B995C1980052;
	Wed,  4 Nov 2026 08:02:59 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 04 Nov 2026 08:03:03 -0500
X-ME-Sender: <xms:Ay3ranYgkY_XrLO06Rt2zxbZ81RQuV72zKk2jsGLwvKhRYruiA7gqA>
    <xme:Ay3ratUlCel_qAS_Di9AObYS-U98a6yBO_z3Ge9POWcq9SjHtX5KDbuAF5p4ffJ9M
    4ezofs2lBMvbMMYjPRjfNhNrIFCC3FQpO6q4qAEgH-S1oEMX6jwB1I>
X-ME-Received: <xmr:Ay3ravGVBcnfEuNF7sjgeA-O-pMSZkjMK3jxL6T178epMdym2fDxWgR631E>
X-ME-Proxy-Cause: dmFkZTEkTGQme7AYtjF3GuVS96P2KQmK7WXeTlUb1QwwiuzIvAmashPSlbgOXzJn8Vwnwy
    GtuimX8GVaozomoo/zh+dZJa/50iMsle5DQ+rz1xv6q7s8h1ROZ32xDIMTiguWiavpmC2D
    BBwjWvlIRSWZcXI9bWu6+sLs7omuy7lLW9/gOc6hVkazqru7j3LnWdj5tmV/csyW0bsTmS
    EsxaoHyCeNrVLjcn3op2UYLn5kjIXtndJ2M5CWyKjF23KtNnUBacMFKYutyyEO2UkxXzYe
    RLi75JY7cBimTx0NOw8ItiGvjmUs48xoopmJA34QoNHmlECPZN6WTQStnLRujBuoPTyyqY
    WNZVZSQNCEd6xp+B5OcigglVi/M4vyTQAOp8DAvxQ6AAu7fsihetgvFDtIIDS5ObEaNW2s
    U6wxXPW0s9rD0+XTraAtlBvBIpvjMETR3urx6nwBgBwLzX9c7PCB1JeSjKkqKBzMFpyxyp
    D31IEO9Hn2FTO+eQ+QIw9D38MApBAMgD+do7ngt4xMfXhbY3T7wqbAu65VS2ZUtSfwfYKq
    kWXnicU5R9b31F5IhRxjhTGPQM0+wpZm3zSfBP56ZMPQV3QGtEnX2jeAKyTTDvPWG5w/wq
    qPiCgH8vCH8FQifqh4DXfGoRyFm0vh6aooGv+EocCSZF8jDUXaZH8fzYqqyg
X-ME-Proxy: <xmx:Ay3raiDsW4mhWHofLCiwXi87nnuRdmiG3xcWyAVOKXg42RDrH7lqPw>
    <xmx:Ay3raiVcIcXJxXU8-ZuS5ACNt_e8L9f_7DVbEjG0ZnHYyEhlRpb7JQ>
    <xmx:Ay3raq6zmTd4ddo3YhxVWmKr3TywONNuMCsLdbUiGR4WYOe9vrCMog>
    <xmx:Ay3rarEaIw-IXBTza2AXmYn9SNvhb9NqvxYARyWegRJcmKQOBwx5Wg>
    <xmx:Ay3rat1ZeL1JZQXP0cbJEvUpHP-6iXUb5N58dA-wUg2uhNELNoOnhxi8>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 08:02:58 -0500 (EST)
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
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Harry Yoo <harry@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
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
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com
Subject: [RFC PATCH v2 16/18] mm/shmem: count accesses to a folio the way filemap_read() does
Date: Wed,  4 Nov 2026 13:01:12 +0000
Message-ID: <20261104130118.2507513-17-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104130118.2507513-1-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xykhirnrkthnsrnmocw473pqeu3whmtf
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2D49240006
X-HE-Tag: 1793797387-531045
X-HE-Meta: U2FsdGVkX1+gOfMjJX2OIvm5ye+aYQ9hmow25Ws3PusmLVFktzI+fzPw/3txjBN/cooA6TUS+EugjnKsVOr4/7wLSUhUuYUIvrwxXNmtLPuhQivOiXkcgphHpAr5oxnyQ9rVipcv+vJxb27SfJT3ay9XQ+P3yVeexREaYSmA++8Uuop3ZudgI7LKUudnc4LwT4gg2+740BtmfhSaeV0wKAswaoDNd41QX6nQUZms6vclI3h+zjnYkvXtwuuVyj6ulWbgP8797NMMB9iiGFgqq8JgdbYsmwUpUIONcOkR8oNXGEw0ffHsgqVn71j2RAMJV9szJBrolrg3ROa+VeYqdg4PpS2P+aAI/NDQwqWj2HJCM6hmOhlm99j4gFWvDdFF0G2yoDeL3v8UJem47iboq+8KKCcRfq9a+WmkNMq9SxwUQFs4ecLGYh1oXdivzYwwzjIcI15PB6pd7WsbAtYl709npyEGdW8Y/QLbqkZtnF/GZSygHpIhldR96JTms3m9L6XGnukSsb51mmEyaHA2ZOnBOPbCjx4Goqfajo0n6OBHpTgmk2YUIldrwspZPetTB3pqbHe3M31L8OI+xViXInYhKzWCtppvcwxNro12YVuDZ8Frm5PoegyQwG+/dlqG5C9TXRda6otei+QQyupsFwblAqQI4XNfelQdofa5ORB4l2JPOH8CXUT7E3nOTaGFtctXbyJMY6JTT7/CI+oB1vMHXexOrcIDZ9jDAEB67bUoywxSUtxR+Ot3uBmBbWUg4SSDT/KTeeY3E7T9Npj/lAQUuuMrVPQtMVc5wUrvXZUo2mz+YJ0uaUNPFIJk28EEytbbxWCU3lKGkm2AeY3WvRoYpO4wRDxR8OPhjb9cW9oWz9v4+8RAxyKYO/zPvtZq38/kJM+bsJUioVBZeLcHWOQ4G3yvwqeFEatzafl7/pDultSxjguks9IBV3H2YliLf3OXEuPdAxc2frXoBOO
 pJYeBWGq
 BWpH2GQc2b9ksKiXGPHeGPDvpDhA9VclrTuMVrtLKY7dXEmEL5LnwoHeUWVvnbaARmp/6OlzY5b9tFxbAQCLwa06B3TtYKZWgxMw74t84FYE8nbaLBskhC6/EVFNTLk2gzVP5AhJDjWpETkNgboGN87IUDhGraeufLcLlq414vm0KeYlHdZYqV228SViBHWl0JaDphIwANkbxS0Tyqan0iWWjM44O9E+F9Tl6aUWMMhHamILe81lBBoH3gQaYvhppsMLJZEBHTobvPe928ep+SdbQN8d0XBjpqmkJPMIKDKNXgkfxEzArUAL88dq/f+J4dUI4aAxTLTEY83pjdaVqqUaNYx1VTvyBlwTbwSSrx2ZRkfEXoUQO/3InGOKsJOs/+DxA
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

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/filemap.c  | 9 +++++----
 mm/internal.h | 1 +
 mm/shmem.c    | 9 ++++-----
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 5998de3d6697..65d414ad9d85 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2772,8 +2772,10 @@ static void filemap_mark_hot(struct folio *folio)
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
@@ -2796,8 +2798,7 @@ static void filemap_mark_hot(struct folio *folio)
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
index 848316eaa7f4..1c700fa9666d 100644
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
@@ -3421,6 +3419,7 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	}
 
 	file_accessed(file);
+	file->f_ra.prev_pos = last_pos;
 	return retval ? retval : error;
 }
 
-- 
2.54.0


