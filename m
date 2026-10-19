Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A0A6079D44
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SuW/ZU3r
Received: by kanga.kvack.org (Postfix)
	id 9016C6B02BC; Mon, 19 Oct 2026 11:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B2166B02BE; Mon, 19 Oct 2026 11:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779DC6B02BF; Mon, 19 Oct 2026 11:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 507B56B02BC
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:49:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D59B01406DD
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:49:42 +0000 (UTC)
X-FDA: 85339811004.29.CFD5E97
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id DE94480015
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:49:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SuW/ZU3r";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792424980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4ryK0uFT6LOFyuJdmAuxXhuh94KeEdmaAIvPF6s5TM=;
	b=je460JojxxXCEfoIwlXNoqmJJpul2S5mCg8QKT/N4PAk0V+jyDWT9ZVYKFxTwBsrKJEvlU
	2eJB1kwoPyxfgX7Zj7FJmpvPniOGxZPKqU52FyG+oQBpJaWzrjr+KBqDQCGuGDKC6HxJ+7
	gx7RfD4sSd5MXgdtJ8AFoYFdJ8JvlGg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SuW/ZU3r";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792424980;
	b=1QnFj999RBlRngE7611oCYHQcR+Lvpg3NWiVnIEU9IQ+tKtJuYUiFLlgstig/r1eerPCGL
	9i4KVyrcnT1qedPeMpIjrKZSAII9i3KqBv/P0G4CL1Tj+3K/UUYXaYWWy5TQv59naH0SVp
	9pUopNVvio7dmqNnGxHvq+gt8zXdXiM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78FA160D82;
	Mon, 19 Oct 2026 15:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914B91F000C8;
	Mon, 19 Oct 2026 15:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792424980;
	bh=U4ryK0uFT6LOFyuJdmAuxXhuh94KeEdmaAIvPF6s5TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SuW/ZU3r2cVDI0MsGtAqY7lp1e4JKP84OSelU1jDLrUdnhardwOiGsL6ZdNWe/sJX
	 XxCOanD+yswhINbioTu/uBwI+GZnxfFRI7tAyVQEbaF7LAUhpvpGi0gtkUVutwsmWI
	 Ztg2U6F4nqZKClyQRTTG/zTVX6Bd3BG5GLE8vjbfXf2sC88/k5ywfQZIReR+X5UZGJ
	 uSfqezTEcgvMZ1by6DdXowbRMURfv/jElF1RmPM7DHV8kWYGN9XKZaT9n/k35Oi1+w
	 7cB+KGBMUoOzyiaVffGm4MQyuLHNbZ5T2xDigWr5J+TpZUhKDzhwSihAtl5Vuo82DX
	 f/eh0dCaUH+XA==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id EABA8198003A;
	Mon, 19 Oct 2026 11:49:30 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 19 Oct 2026 11:49:34 -0400
X-ME-Sender: <xms:CjzWavXO_Y880XZrtTCjlXdKtDqIB2QaAMwafKZch5S5npGwx5wdRg>
    <xme:CjzWas1Puk3zubKMm0tmz-Pbo9ZZYlLiZfxNQkLo_tUBKxrM9mKwpUk149-FwC6t8
    eg6ZgJbkO36lVheRIfyypG3DU3Y9_zuCOEWz6V56qBZm3_5yZkR0oQ>
X-ME-Received: <xmr:CjzWauB3TvdayaTR0qveByvk7mbHUUY_mJetq8O7G5BS5PPJo6m3KQEr63I>
X-ME-Proxy-Cause: dmFkZTFpjrG+2jfVBfklNRE95oThC60xlhUtv5sioyJrfpDDHbEB/2cXkTI411oJriXTLs
    N7RLfOUdBbmoibSFu4zT/f1BKPPyxkEYUp5eDeafGhPQjcnfJv/29ZtYwE6q77Fr7A6zQu
    C94bEu3EPqJJ50fLC5xP9PtYZOq3sS+jMfKkgkZFNUAdZxkDiyHArLijwBk9MwzijLWdvR
    4raSXvkSyIGvp9XYd2doZUGuEANzDQejgJzzg3ARZCjBL2yZfXIvLZCg0AMujDeTHEemYv
    cvWt94P7AS+P1mtikHZvyS9eAaK3Fy2/TwDlvaPXULPDsZK9f0sj0aca+uCBBoNs4d3uIW
    6UtJ41xqrTh41J9CGKF5HMdWWNPlzyNWgWQzyeIKO+iqcaYPlEF9Y5+OBdY51W8gzONadz
    MxZF+NNp24tKwLD4/n1vy2Ovyn5wcR3tpqUHyQQpOTfDPZ4IwklH+mHOUVdzlFtnjgYkaQ
    qoNdWC/Qz3DlVKJX3IEmP6IDgyqMgqiPpwb6q5YyYOFoysGo7gHd2QNO9WcnhuKVK+bLic
    /u4BPVbK5+aqDmA+vVjbOvePAVA1tvWTAf2718PxhSMiEPspjNO8JwFB57p35ewgTxBW7f
    y5dRgjXgQxXNs9kr1jbCq9G/mob8EFCcMV/U+ZRpNrKfSXjGnRlgT2m+VOxQ
X-ME-Proxy: <xmx:CjzWaqBmY1BwDTEGOsh6LrR6Iv28To4XkMFUMNKyAk2sab-xos9gkQ>
    <xmx:CjzWaqMAH5kjgYLBGev1TmLRy7ZBnpqemGYZiitesbhexZdNypHpmQ>
    <xmx:CjzWauzJYkLsAOJpqj9kc2I5QOz4s5s4MNjwAUepO8XqIFw8W6Y8RQ>
    <xmx:CjzWamk7ihrz0TkkbxoO3o-ji1NdsMy_QJIzTK2PhTorQf-yvwLfdw>
    <xmx:CjzWalDn4hPNLGniKiM4csh4s3wCtwuUcuswoCivCQdjdz4SqVZMy1ry>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:49:29 -0400 (EDT)
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
Cc: Miklos Szeredi <miklos@szeredi.hu>,
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
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH 02/18] splice: don't steal page cache folios
Date: Mon, 19 Oct 2026 16:48:55 +0100
Message-ID: <20261019154913.1765974-3-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DE94480015
X-Stat-Signature: gc8j39spwuxg34db1kebud7dyxgd8hqk
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792424980-326992
X-HE-Meta: U2FsdGVkX19R+OElDzhEsFX+FzmLRDDlzZnesIR0aPjk5m0a1JLWS6P0lwlAGgSgydaRIcN+NVGsOG9fbV/jMHx1sB+WPlLROpp5Qr2f4Y4VrXJvVs4VzOjUSewD4Q15D1+Fno9PxDdtF+qgpb3qXm/jGwNbdZsEmC6nik0uLijtFQLPGRe+B/IUu1gBjMP9WldAxQwOl6zjMVWn/cmrLCiPy+lQ85b6fRuDmP4Zba9SKyO51pjJGzmfoM4IkQeY6WLjWpovy3eQDqMkvEAJM9mnvWO9kDMdN+LaT2NCQAMKQRnJX1GgQKTV3iOjYRFV4D+8WK+6UR+G71tltQEQj5hdn10DBcc5LJb0ikPq3j0vWTtLvhrPcxS8plTrApfSbPK4oTjkzd2x3HXWz/4IDScVcahTkukgP2SWJevREXT8xQ6UM9PNuuv2d3skAibgFp+ib3W2fMwNXzFyCcmzAIwX90BAl+n1tT84ahHY2yF9+oIePatVcLKPydUFhFTJCSLv1VZYkalBiN09IdiRVn0WsHXR66y9En3FcRekmKixY3UOZC41uMgKAcE+PXmmfDK+UdrZHEOybGdTak0MfNA1+Vo/PgnFf5viD5xkVh/ryznHuzsiH5vEO16cB7A+RVq5RVrnaIYiu5/+b/wkBlpNmGAACma+nk1dvlYqK0L0sA8IyFFYfNdktX1H7Et4POP0CMpOoSJJS7zebgXWSTXX+Q6K7uGUNecgWrDcOFC8MrGyiqalLI4XKnZF61iL3+cO9sWQVlwwBH5AlpjtIhUAts64UkUVxft3GBt2tUxaiJmH8VHmOadEQYsz40k+mE4WuGr2Vsy+lrpM0tgJqigpyBj8xQW0lGW9DJSO6CmrHLsCuuRxBmwvHwqYMMGrB86G2D29PLsD7QU9q2sbcDkF5YlwEIysgEzLnBhG2uqflzdX3JZWkeodeNRF5P4MnE10NzHQjxmRtAJ0Jlp
 An2oBGor
 piLBASuter5rfezL4ssJ4B3Gzqt+MB+7CI5k70qw4L9UB9bMuQH9DTPbYEZOvnrNdkYy2XdQxnrfUyrkaXy93vPfUO8O5TL/wyjdod0BunAPQzmqHtL7t2FiWMmNVWb+eTNR08l76/p91iC1SfZw5l/bQ6+/DyIRO6UGKYmBLcTeOaYJr08RbNSLQpRXTfruOHOFHFe4fssYlcy1opPP1g2d0EI5rEsz3vCXkosZNw/C1vW8rgfnFB51smCfRIbzzbRU67JWVEy5I+WujJxw9uRAmmChMtBhqleCDXd4jRvMpwhZ/xO9Nxv85jZJBiYbWOKSKwy1gmNoRpxGrN1biLkKVIDUwROn2TQCVuzBRz99LcYIdekHojFoqzy2WgKvbT9HhCjKlOxL6Org=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Linus Torvalds <torvalds@linux-foundation.org>

PG_rcu_free holds back the reuse of a folio's memory until a grace
period after the folio is freed.  A stolen page cache pipe buffer is
reused without being freed: remove_mapping() takes the folio out of the
page cache and the caller keeps it.  fuse_try_move_folio() puts it into
a fuse file, where writes change it under a reader that found it before
the steal.

Drop ->try_steal from page_cache_pipe_buf_ops.  fuse_try_move_folio()
and virtio_console's pipe_to_sg() then copy, as they already do when
stealing fails.  SPLICE_F_MOVE from the page cache into a fuse file or
a virtio console now copies.

Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[kas: rewrote the changelog]
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 fs/splice.c | 51 ---------------------------------------------------
 1 file changed, 51 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 9d8f63e2fd1a..0133c2348da0 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -55,56 +55,6 @@ static noinline void pipe_clear_nowait(struct file *file)
 	} while (!try_cmpxchg(&file->f_mode, &fmode, fmode & ~FMODE_NOWAIT));
 }
 
-/*
- * Attempt to steal a page from a pipe buffer. This should perhaps go into
- * a vm helper function, it's already simplified quite a bit by the
- * addition of remove_mapping(). If success is returned, the caller may
- * attempt to reuse this page for another destination.
- */
-static bool page_cache_pipe_buf_try_steal(struct pipe_inode_info *pipe,
-		struct pipe_buffer *buf)
-{
-	struct folio *folio = page_folio(buf->page);
-	struct address_space *mapping;
-
-	folio_lock(folio);
-
-	mapping = folio_mapping(folio);
-	if (mapping) {
-		WARN_ON(!folio_test_uptodate(folio));
-
-		/*
-		 * At least for ext2 with nobh option, we need to wait on
-		 * writeback completing on this folio, since we'll remove it
-		 * from the pagecache.  Otherwise truncate wont wait on the
-		 * folio, allowing the disk blocks to be reused by someone else
-		 * before we actually wrote our data to them. fs corruption
-		 * ensues.
-		 */
-		folio_wait_writeback(folio);
-
-		if (!filemap_release_folio(folio, GFP_KERNEL))
-			goto out_unlock;
-
-		/*
-		 * If we succeeded in removing the mapping, set LRU flag
-		 * and return good.
-		 */
-		if (remove_mapping(mapping, folio)) {
-			buf->flags |= PIPE_BUF_FLAG_LRU;
-			return true;
-		}
-	}
-
-	/*
-	 * Raced with truncate or failed to remove folio from current
-	 * address space, unlock and return failure.
-	 */
-out_unlock:
-	folio_unlock(folio);
-	return false;
-}
-
 static void page_cache_pipe_buf_release(struct pipe_inode_info *pipe,
 					struct pipe_buffer *buf)
 {
@@ -155,7 +105,6 @@ static int page_cache_pipe_buf_confirm(struct pipe_inode_info *pipe,
 const struct pipe_buf_operations page_cache_pipe_buf_ops = {
 	.confirm	= page_cache_pipe_buf_confirm,
 	.release	= page_cache_pipe_buf_release,
-	.try_steal	= page_cache_pipe_buf_try_steal,
 	.get		= generic_pipe_buf_get,
 };
 
-- 
2.54.0


