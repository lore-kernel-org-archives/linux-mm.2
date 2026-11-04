Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77432606D826
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RQ9c7E1k
Received: by kanga.kvack.org (Postfix)
	id 970536B05CD; Wed,  4 Nov 2026 08:03:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 927B56B05CE; Wed,  4 Nov 2026 08:03:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E8AE6B05CF; Wed,  4 Nov 2026 08:03:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D0086B05CD
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:03:17 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE553806F9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:03:16 +0000 (UTC)
X-FDA: 85397452392.11.8A6EEF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id DD659140006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:03:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQ9c7E1k;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797395;
	b=b7LOKY4z/H26VTEQ4WZDshqNoNPO92dEBnOhwW1oHk+PrtMaLlBtAf8I5rUhmbC53KTba1
	a1o9LNiE6G3oa2B5eytsoflbowB9RuIc4GmG2g/q2/pwrL8vvFlI6pmPLgfj8Pcz3lMUSQ
	oMnNFjnqPgW/mSjVOX30fXHRolBUYSg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQ9c7E1k;
	spf=pass (imf26.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T6Io+8KMRKdZfFLT9BPvR1kCng9N5oVop+UTdq2d9CA=;
	b=4qyNvL+EI8yALMaCx3Jpq4zaHfG4b0lShOrAqU4XgER2LtmI+X+5KmilhCCRWb7GFdvvxO
	CpyYz6ZvLX0iV00Rpd0HEcPjoDsDuUoLQv4t3jnNVYAlBw9rnwAgsBt9e9VaqofQcD2C68
	bZyrEI4tkk9Dfsh5BmhhT1+9NaMa9LI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B20F44819;
	Wed,  4 Nov 2026 13:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E1E1F00A17;
	Wed,  4 Nov 2026 13:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797394;
	bh=T6Io+8KMRKdZfFLT9BPvR1kCng9N5oVop+UTdq2d9CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQ9c7E1kX6C6EMziaQfihzV07DpTT+ltaSGAeRA6Uet6AS1jkLvU1gPkp/uBPQVJi
	 kZaBKD2F/xaoSUd9Yo0osBFq+YYTGhOND8NuANAZw/w3GbCHAa3SSTbbgPpmfExdsv
	 THXg2kmkx/BPeJXKtOrcuQN4xcYbzcdBnV9xxs3pr7dimDtLQNah1/jBuERtRlWqak
	 f+mprTY/HjoXr2z9iUtQ2ZWGJc2Bgy6D2xFbFHSwIilc6H0vpszpt+WIWCjdEMjq2O
	 0TNaB7B/XS9CEil3qNSV1OCP3BNNjvHouAAInI9jo0fzpBhb9L7qu0kKDYSHX4Lci6
	 J0ZuJ+Tdg5fdw==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id BB07F1980058;
	Wed,  4 Nov 2026 08:03:05 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 04 Nov 2026 08:03:09 -0500
X-ME-Sender: <xms:CS3rattHkCoQiFep-bB5gzpVapNr_fcSEsmtmDCdgdkZ6EawYap9iA>
    <xme:CS3rarttvp6o0E4bYxQj0zXixktP8TVOri7Kqo5eyLNQkq2t6W8NrmvCc-J7nqu43
    IkgnufDjfoHoWPsK7WohZ7fpi5gTzreWi_hKoBESzsd64833aftlw1c>
X-ME-Received: <xmr:CS3rajYKWyTDEwJPi2_WOMT581mPMw5US80erg5LHFT0hhemeNvPbfLFukA>
X-ME-Proxy-Cause: dmFkZTEvV2YAkGfM/7KQTdNUPKASUoKivbf8aK7reNbiRWx6UbSyYJoBiI1aLFQD0JmJIL
    suuLzf8FPF5XXOxsI4n3uatEJISIq8lfLQzWs4ZXVY70I4vMqmzsMJ7lGJ46GbcAPXP+27
    nbqWstaujK1I6YUZb9z+ZqV1uLZr3rGJG+0r4w/gGbN8dNbDx0uz9q+Ln5gHW/zJfXd0Mx
    LucPAfkwgcRoeIu9xH9pdJvf2Akov2r7sS+tvQQtk9VR5hmZMO56kjZiFGarxbHYybrUXu
    m8XGCL1PIBUAW4CkGGSJ7es6S7rupClQfiIG4ieqXTbHyX1rEMGh3ihwL/bhr1XVL0tAmZ
    JSSwADdVM0zOM680rMMzpcwnkR7i6sXqNVT8pP/kSrFp/QUJposbYhRg6EweZH2u9za8zV
    /QvxHBLDuwQBgrSh4KtcjxDU/shF+aHeNsgIoYEtTdy1I9qGVm/AwiI65KkzrmE/ejcfdi
    Kte3e1f7WB7dCZOWkQHckvXXr0x+BjnF05Dm3HudpBr//PxPuT/vRKwpPdC4/ELI1mny2P
    BIpwqKAmpEAiZTN6mvMLKEewys2S83UXacplDVrqPXe444P9hB8kwo4mRMUFd50OAzA5F2
    Ma2vivh4juI9U/JJDS5U/kKqbPQhGubXz5qMEaJeOc+EdWIq2ZcHPOWDADrg
X-ME-Proxy: <xmx:CS3raj75fkVPiLY1uys-NJmZkDd1Q_dZpd6zrXqV-aR0h6Ah_CjmiA>
    <xmx:CS3raulhPuk-GPnjPLsNqaMc5OP0H7Pn-8VLZ05NoRQF7FWYANKkIA>
    <xmx:CS3raroYrPFivpnC-vgKrnNo4Rb95GA6KSuQPkX3LpTUdbiaYYwPnQ>
    <xmx:CS3rah_ddeN0rYex3UTW0knhNHKDTiyiTCwP100Xi7SH81CF5KeU3A>
    <xmx:CS3ras5FSDv1i5lts89nrpkq72Dprt3l4OSdayrPYLzAJtYRhCknF8nx>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 08:03:04 -0500 (EST)
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
Subject: [RFC PATCH v2 17/18] mm/shmem: read without folio references
Date: Wed,  4 Nov 2026 13:01:13 +0000
Message-ID: <20261104130118.2507513-18-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104130118.2507513-1-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: apxppmyg9tfuw49s4ja4j5oppwnjib6u
X-Rspamd-Queue-Id: DD659140006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793797394-148265
X-HE-Meta: U2FsdGVkX18mJdUWfHoY6E4KwxhBKNiDr34X26L0tjgAPn7GzcssUoK3Gx2pbJheWeFCgg8TSaP7KogQRRIvQCpNkaZgN9KcLcLh8r1o8PonsPUhp+HEvFG5tsFrZAxibiHN/zlcfmS6d+I+np3dVv7qFdA0gPOlNQTbV060nLKM47YfFUd9bfvFKBxTX43/u2+LIHKaJiYH/nZjFYjcf0pMLfKx+nHeJvQikUaDiXH+CfFyYdvhQkZjI3elW6jCyCi0m73RfOBGypi6RkCnO9NRMl0H04MCfTeLpmhk9VAE5zzkZ3jTXcZ6qK5piJKXDgJ98ZAn0xQxAw2TjJS/WX2nc35i9KCGMgPrRjWUlc1jJOUEhzAEVqoZPVZbrrhkqxYHrPbnIM13afaQHuPPOdq/5urwqKHGwlGHWmDnDHPhR1HNVwBam7kffR+MdktDc1U5OtiXYhr7G5hzE5NMBKB7Tl7U2B7hKP8L9zpvq/KOZXmmxOnJUdP+LSTKZSNDD7bxaAi5wNKllJcOaR6A1byIE41qbIOwk6apf10+grrEAqMKLdf71fCJ8k6MmvfHXJx3CZpBJruXHj3I5tWzbkH4DHdZxvd73lZ7jTYRkRg7RnEHK8RtZkr+feTBR3o9A7wgaetJnGJHjwmtZv3VKmZn+ELSH+n42agmVOxDMwRr3uXiEiUfL92NMVRziyl7vLoRStFukcVGIIIJK8h4HFb1tuFTM9f16UnhxZPlRGKqzYIiHHxF1J/i7KTmC235JzyTyZyTpR6Ig5BoMkKOQugr/ccizgqnyfIfD4mSOKYzUPS+QT9SNUT8TvjTB0iDIVJDAzzJhgmP7ZoRpYDV6h2XX7M9WskSZ1V2CYmOwHoFivVWLsSOcE57iWheRcGipykcYyR+wZZJCz+gqn2vP7SrbdEZJQ6jJsT6/OLbx4huqcKzCdZha17aRgdQHdrCSD9G/LCRQuxOX2+Rdc+
 XcDTeNsf
 bI9J4cwcwwnzkAdrnmj+yU5J4qJ+fCB1oruVYrgR/17JV0DqMvUNdS0yFmwT/twhcJAdpZVGD6LtbiLnUJXKoiWwhYgaO5VC8mcBP4bUKyyFmAqWtNdL3IsBVIlntl8a1PYKWjAnadozbH6kzSUHSIhW2yXLLmGvDzrue/9PoLEUFalin0kzpuq4E75jajKgaduBgnxEzWccjGaOOqf/2J39vv47XyLnSqbHQk4mgsowsNGpxu5jVpFt17XWEvsiFGWwJ37EUYOqXUo3eCoSydEFgZgkwSM1LoSZRHpKEktE7eF4oIRbj8xj5dIyVOSspRl+66KS5sVU1ZTCVDmfD0p/fKw==
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

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/filemap.c  |  7 ++++---
 mm/internal.h |  2 ++
 mm/shmem.c    | 11 +++++++++--
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 65d414ad9d85..e148490db4da 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2831,9 +2831,10 @@ static void filemap_end_dropbehind_read(struct folio *folio)
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
 	/* A split clears PG_head before it puts the new folios in their slots */
 	if (!folio_test_large(folio) && folio->index != index)
@@ -3020,7 +3021,7 @@ static bool filemap_read_rcu_batch(struct kiocb *iocb, struct iov_iter *iter,
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
index 1c700fa9666d..8700b03a8a5e 100644
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
 	file->f_ra.prev_pos = last_pos;
 	return retval ? retval : error;
-- 
2.54.0


