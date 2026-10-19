Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D929606A332
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OtkJIiMJ
Received: by kanga.kvack.org (Postfix)
	id 952C16B02D4; Mon, 19 Oct 2026 11:51:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DBB86B02D6; Mon, 19 Oct 2026 11:51:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77D236B02D7; Mon, 19 Oct 2026 11:51:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5259D6B02D4
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:51:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4B4C1C4099
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:59 +0000 (UTC)
X-FDA: 85339814238.17.628E6EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id E26692000C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OtkJIiMJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792425057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHFgwB1QQdeguUBHh1LZeUKmP2EVveCA6ywncN+4824=;
	b=qmVWhTpOWruRKmJxWJ/+xtKw3ooU7nr0xRhjunsssTWWMVPPOKCxzxZRUyqEOS5anmhaF+
	YkzIWT4SeDRFdfHoMh8poSZ9kRFPBs0l/CYDF1pjtxnBWZSbQZ/x15B4VUhpXpBZbi/6Fj
	RxJDvwyy5TBxN5h6uTBqfWOSXcC7enQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OtkJIiMJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792425057;
	b=Dk8EICqTMyjCoxYLsiMekhg7L9I8zwCq+KyzMwgHP7DlUZ1tgmCY1SUzaKPqALmYI1h5wY
	j/eti+8miVB9lBYt0dNsRvzwsciJXFsYGZrmjvhDYiizj3brI8035/DkN4xDF7Bm6PuHnT
	PnTnL44XjysECFpC/qh7xNXN20AruN8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7666260D81;
	Mon, 19 Oct 2026 15:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7611F000C4;
	Mon, 19 Oct 2026 15:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792425057;
	bh=aHFgwB1QQdeguUBHh1LZeUKmP2EVveCA6ywncN+4824=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OtkJIiMJwUKW+PpYBxbejkBKvIfF5XZUj9+iRAh9PWDsELtE1iZBY3/SkMdBz/k2m
	 Uei8vSV+E+ZzJ0BURGiaCP9zE11b/k460hkrVvzYB26SmVh1k9YfxE+zPeLOptVk+s
	 cNU1EO30xTBnt9eqIzXc2SkeOCazHsdu/t807E4UdSiUBGK7u4Tk6HG5YY2MEzQ2sw
	 +4LrkF4FACdMQp3nq2o7Gv3Y7KasvO34pR5QiApYHZSWOncMMUTMfODuoEdFd53lIK
	 uaXuMZ+3euJSfW8th/Kt8d2R1aTcolvSsqyXdznnZ9BB4z1com3/OOTwxAI4LLjwn2
	 glsWapkMr5bXg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 9D590198003A;
	Mon, 19 Oct 2026 11:50:49 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 19 Oct 2026 11:50:53 -0400
X-ME-Sender: <xms:WTzWankDtQBpbX8-A7KeHpUkJjxA23ulY2hVup8-Qb1LuawvvpvDOw>
    <xme:WTzWagFEmsa7ABjv5spb4NJ4aLEvtMHnJrl6zn9-JUUj1AhTJeu4K-CVWTEI6NctE
    f3N-Rt5Z6KotvmEcPzJtcu9xtRJPKan50NVFzOpFUKwgcat-nG8PNkt>
X-ME-Received: <xmr:WTzWagQqANz65r9kGtUpU6Yt2nXXnsNcnUxFtQRBDwO4obnWVffcojBgET0>
X-ME-Proxy-Cause: dmFkZTEPqwHCv5IVDOfp+gppQpoSvl4iKuiR2RK5Y+mCZyyWO88dcIgYD60QXY0H8fSG9y
    +i/Fi66FpUhP2Ikf7ONks1QGsKRJt/NoxWDxl5HXxNylv75I6mtGV03osn/+lvccKEBd4W
    KnTaLXmzxvblXRRW+RSShg/hHxynElJxqWehmOFUYq4U1x7ifoitgX+ne3vp8F3h8AQ/N0
    /m2r4CY1m8XbTmLiUOTFaC6q0oQJ3XXcpirfEfr7IPSxVFCOUTfbQW2d5jjoyFzJhvq7h+
    uIBkQwMZCXw2y5U40pZhX7XPPqGR7Z3fiyae5UDORfmXvndjR9BDrzyAINzfPzRUg9LHlX
    k0IkKTk9iNht3cIGRTIZ2lUZssI02DI2+r4CLzf9ALJvkCYS2731J2VpdbOY6W6ssdpZaq
    q61aKe5jdOQRiHmCzGbTuNUnnXQMa1s1MYT7kWNp2XXUjLgPn0z5+PtISNXTEW1SsTC/56
    +/AywSZLo+AmKJldqc/DJBr3AuzCUlzce5s0eOrs/wPTX9AWPQRJ2MMmZjPzhLopP1eoxw
    0j3F+Ye0cf+APkDpVznsTTVhYZQ/Y+ausVHhYcDlznuhBSu6aojjhGD6qDJ/85Df8I+5JH
    JS6uR59Nu8GhniM7xqxNRP1zUGEDjgGFmqzlorj6gQzkBYvu0Z9eOmDJZvKw
X-ME-Proxy: <xmx:WTzWavSXSMe8mjKSzEv9M4YKuLHRTpBFS2_rZQEn9KcEbkpE86Z-qg>
    <xmx:WTzWamd5dnT_wLS9RyyG-aJ8l_6aCHDceWsgY9CBv4X1i-uzXVTmXw>
    <xmx:WTzWamBN0Ym3A7UqT0MT-OzVeZYdxtAF_PNglcqQceTWkA7aoY637A>
    <xmx:WTzWas1ropU3sQtK5b2EIVmByal3_RmrXIW-sCzaLxFIM3sDKoUD1g>
    <xmx:WTzWauRZ2YzWDO3s7IXVJyAWhpnG6gU3u4bnavYuv9vCkdlKPAhC1ASH>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:50:48 -0400 (EDT)
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
Subject: [RFC PATCH 14/18] mm/filemap: read from the page cache without folio references
Date: Mon, 19 Oct 2026 16:49:07 +0100
Message-ID: <20261019154913.1765974-15-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E26692000C
X-Stat-Signature: p85gwic8wj1cz83gz8huij5mpn18q97h
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792425057-320732
X-HE-Meta: U2FsdGVkX184O+EbpO0cXDzNKbwRqsYBdrXySnhPQFnzpecFNDYgkvRa6sj1bAFU0lW27QwyT93QMg3blMhiZXbmjWD/8bzUD84wLrDTe1jwzw3ugr0CCzyOh65MpwYyuJ6sBprkoz4fqRXKESsII+Cn0VK8kwPsF9v7jCK7eC4CJy0NUvcyoxuyef/N1txBhK30dkwxc5zVhBeNqKUItWjj3dWONgBu01P4WjGpFCV3iS4wnSuTwDU/g4rug3F3KKi9O42gGcHv30q5GZBtQEGBRDQZ6qdkjMaWEqfCMO3CdQ34uAtF1uI2y0hM39R+ukW4fiGM4c0xckfFHcSeLP9hzZhYSo6Nn9aRyF2e9zIe9rMou0uE5QvvwjKpz5wXTnCFk/gahq8zoOZSCWvj6zc8jawNshw6ga24+fFZhROBsyM1UIF08CImPiXI56StlQL+dS2jiUCYKIhhEhiR4VNISX07KYXQPjNlRWzv7kG5FXrVz0XJ9dpTgrn42NZM3B5OnjbntDHIw88Hv1FCT4GttTJ2bgzyxGzg07zaJ6LWU9JiW6a9B/Fkc4Jo2CtC5fIhRntxS9weaij3JV7HB08kOlNP3V+k/o4JrodoRjJMQvCtxsypXoG8zwD3CGq1hq7Nc9Xj9e6EiTCAM/jRuJo6Unqk+lSV84IOgC20c1Xcxi8FUf8memKFhDZFIW/UQrTW+2/8hFh7YIwsty2SGUB4b6OZ7UpjTIXLYut6b+GpCyBKLnTHMs2D/1Gcj0Rghb00t2T2hh6vQcH40IJ1xPJJJysXymRVxY+mvNYXjjkryBTlZrScYS4IoD1Vf97TM6+GhLgUZ1lT5Ikw55x4lzSBBHhG4x2hNDpZeVW0NDIARVBnF5YOfvlfAnSqWmsCytkG3bBtM5ARsSeE4dlWCxReSTM7EVm5M1GoejXIUj/c6pKsl/CrVE4jPXbZugTUj6SfKc0QkPTT5ZZuKnb
 nXIuo94+
 hW+G0jN4xOK9c+qc9CPOf1sN5ZlAzEugEqQE0wuvFI9p5vCr1GZ43WVcp54Qzden6cqTpDrKQNi2r6hxHQbRS9ruFLhMzKT+ep+QNKAUZr86AMDnVV9+BNX+odje5sHvl3EmgHr8bDPO6UYVrNpbAcEsXKmUVQWpIKceZXryjgArrAy4Y5E7KLOQiVMp0eKcphMN+rMvVmCT6TeWcM9ShqooW1MjSOKJnUhJ8sHQylFDtYHFH/lJHL2WnXRZhs3IyluR0dqPS37b7P5M3onav0tvJg7hHwXEK3YIpk/4k9H/4ya0kKtp2P/oRXC9tUVTzEpBOvySBdmjjNZ24Qgd0knYRjopNuWSOWxfeVXKHLQQ32gSs/GGD1Hv+9sTKjgG586JtPWOvu5ctNSk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Linus Torvalds <torvalds@linux-foundation.org>

Small reads of one file from many CPUs all take and drop a reference on
the same folio, and its refcount bounces between the CPUs.

Before taking a reference, copy what can be copied under rcu_read_lock()
from folios with PG_rcu_free, with page faults disabled.  A flagged
folio is not reused before rcu_read_unlock(), so a folio still in its
slot after the flag test is this file's page until then.  A folio that
leaves the page cache during the copy reads as the file did when it
left.  Read i_size between the flag and the second look at the slot: a
write that extends the file fills the slot before it moves i_size.

Leave to the slow path a folio that is not uptodate, needs readahead or
dropbehind, is not hot, or has a poisoned page.  Leave large folios
there too: looking one up for every page is slower than one reference
for all of its pages.  Copy at most 512 KiB per rcu_read_lock()
section, and skip files that never had a folio flagged or that are
writably mapped where flush_dcache_folio() is needed.

Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[kas: i_size before the second look at the slot, poisoned folio check,
 large folios left to the slow path, 512 KiB sections, shorter comments
 and changelog]
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/filemap.c | 169 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 169 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 960d53b61d4b..55fc471c0489 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2827,6 +2827,165 @@ static void filemap_end_dropbehind_read(struct folio *folio)
 	}
 }
 
+/*
+ * Whether filemap_read_rcu_batch() can copy from @folio, or has to leave it
+ * to the slow path, which holds a reference for readahead, dropbehind and
+ * folio_mark_accessed(), and deals with poisoned pages.  @last_index is the
+ * page the previous copy ended in.
+ */
+static bool filemap_read_rcu_can_copy(struct folio *folio, pgoff_t index,
+				      pgoff_t last_index)
+{
+	if (!folio_test_uptodate(folio))
+		return false;
+	if (folio_test_readahead(folio) || folio_test_dropbehind(folio))
+		return false;
+	/* memory_failure() waits only for readers that got past this */
+	if (folio_contain_hwpoisoned_page(folio))
+		return false;
+	/* One reference covers all of a large folio's pages */
+	if (folio_test_large(folio))
+		return false;
+
+	/*
+	 * The slow path does not call folio_mark_accessed() on the folio that
+	 * the previous read ended in, so copying from it skips nothing.  The
+	 * folio's size can change without a reference: compare pages instead.
+	 */
+	if (index == last_index)
+		return true;
+
+	/* Otherwise only if folio_mark_accessed() would leave it as it is */
+	if (lru_gen_enabled()) {
+		unsigned long all = LRU_REFS_FLAGS | BIT(PG_workingset);
+
+		return folio_test_unevictable(folio) ||
+		       (READ_ONCE(folio->flags.f) & all) == all;
+	}
+	return folio_test_referenced(folio) && !folio_test_idle(folio) &&
+	       (folio_test_active(folio) || folio_test_unevictable(folio));
+}
+
+/*
+ * Return the folio at @pos if it is this file's page until rcu_read_unlock(),
+ * and read i_size into @isize.  A folio with PG_rcu_free is freed only after
+ * an RCU grace period.  Without a reference, the folio that xas_load()
+ * returned can be freed and its memory reused as another folio before the
+ * flag is tested, so look at the slot again after the flag.
+ */
+static struct folio *filemap_read_rcu_lookup(struct xa_state *xas,
+		struct inode *inode, loff_t pos, loff_t *isize)
+{
+	struct folio *folio;
+
+	xas_set(xas, pos >> PAGE_SHIFT);
+	folio = xas_load(xas);
+	if (xas_retry(xas, folio) || !folio || xa_is_value(folio))
+		return NULL;
+
+	/* Not folio_test_rcu_free(): it may not be a folio any more */
+	if (!(READ_ONCE(folio->flags.f) & __PG_RCU_FREE))
+		return NULL;
+	/* Read i_size and slot after the flag: it implies uptodate */
+	smp_rmb();
+	*isize = i_size_read(inode);
+	if (pos >= *isize)
+		return NULL;
+	/* i_size_read() is an acquire; a write fills the slot first */
+	if (xas_reload(xas) != folio)
+		return NULL;
+	/* Read the rest of the folio only once the slot holds it */
+	smp_rmb();
+	return folio;
+}
+
+/* Bytes one RCU read section copies at most: it holds up grace periods */
+#define FILEMAP_RCU_READ_MAX	SZ_512K
+
+/*
+ * Copy from folios with PG_rcu_free without taking references, at most
+ * FILEMAP_RCU_READ_MAX bytes under one rcu_read_lock().  Return true if that
+ * much was copied and the read is not done.  *last_index is the page the
+ * previous copy ended in, set as the slow path sets last_pos.
+ */
+static bool filemap_read_rcu_batch(struct kiocb *iocb, struct iov_iter *iter,
+		pgoff_t *last_index, size_t *copied)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	struct inode *inode = mapping->host;
+	XA_STATE(xas, &mapping->i_pages, 0);
+	size_t budget = FILEMAP_RCU_READ_MAX;
+	bool more = false;
+
+	/* flush_dcache_folio() is not known to be safe without a reference */
+	if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE &&
+	    mapping_writably_mapped(mapping))
+		return false;
+
+	/* A user fault cannot sleep in the RCU read section: it ends the copy */
+	rcu_read_lock();
+	pagefault_disable();
+	while (iov_iter_count(iter)) {
+		loff_t pos = iocb->ki_pos;
+		pgoff_t index = pos >> PAGE_SHIFT;
+		size_t offset = offset_in_page(pos);
+		struct folio *folio;
+		size_t bytes, n;
+		loff_t isize;
+
+		if (!budget) {
+			more = true;
+			break;
+		}
+		folio = filemap_read_rcu_lookup(&xas, inode, pos, &isize);
+		if (!folio)
+			break;
+		if (!filemap_read_rcu_can_copy(folio, index, *last_index))
+			break;
+
+		bytes = min_t(loff_t, isize - pos, iov_iter_count(iter));
+		bytes = min3(bytes, budget, PAGE_SIZE - offset);
+		/* Not _nofault(): its usercopy check reads the folio's order */
+		n = copy_page_to_iter(folio_page(folio, index - folio->index),
+				      offset, bytes, iter);
+		*copied += n;
+		iocb->ki_pos += n;
+		budget -= n;
+		if (n)
+			*last_index = (pos + n - 1) >> PAGE_SHIFT;
+		if (n < bytes)
+			break;
+	}
+	pagefault_enable();
+	rcu_read_unlock();
+
+	return more;
+}
+
+/*
+ * Copy from the page cache without folio references, in batches, and
+ * return how much was copied.  The slow path reads the rest.
+ */
+static size_t filemap_read_rcu(struct kiocb *iocb, struct iov_iter *iter,
+		loff_t last_pos)
+{
+	/* The page the previous read ended in; ULONG_MAX if none */
+	pgoff_t last_index = (last_pos - 1) >> PAGE_SHIFT;
+	size_t copied = 0;
+
+	/* Not on an inode that never had a folio flagged */
+	if (!IS_ENABLED(CONFIG_PAGE_RCU_FREE) ||
+	    !mapping_rcu_read(iocb->ki_filp->f_mapping))
+		return 0;
+
+	while (filemap_read_rcu_batch(iocb, iter, &last_index, &copied)) {
+		if (fatal_signal_pending(current))
+			break;
+		cond_resched();
+	}
+	return copied;
+}
+
 /**
  * filemap_read - Read data from the page cache.
  * @iocb: The iocb to read.
@@ -2852,6 +3011,7 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 	bool writably_mapped;
 	loff_t isize, end_offset;
 	loff_t last_pos = ra->prev_pos;
+	size_t fast_read;
 
 	if (unlikely(iocb->ki_pos < 0))
 		return -EINVAL;
@@ -2863,6 +3023,14 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 	iov_iter_truncate(iter, inode->i_sb->s_maxbytes - iocb->ki_pos);
 	folio_batch_init(&fbatch);
 
+	fast_read = filemap_read_rcu(iocb, iter, last_pos);
+	if (fast_read) {
+		already_read += fast_read;
+		last_pos = iocb->ki_pos;
+		if (!iov_iter_count(iter))
+			goto out;
+	}
+
 	do {
 		cond_resched();
 
@@ -2940,6 +3108,7 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 		folio_batch_init(&fbatch);
 	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
 
+out:
 	file_accessed(filp);
 	/* Readers sharing the file would bounce the line for nothing */
 	if (ra->prev_pos != last_pos)
-- 
2.54.0


