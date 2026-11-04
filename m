Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4155608362C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LTyF6sJh
Received: by kanga.kvack.org (Postfix)
	id B938F6B05C6; Wed,  4 Nov 2026 08:02:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6B2B6B05C7; Wed,  4 Nov 2026 08:02:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A597E6B05C8; Wed,  4 Nov 2026 08:02:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 80A6A6B05C6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:02:52 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 01AEC406C6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:52 +0000 (UTC)
X-FDA: 85397451384.01.D5BFD86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 102CF40017
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LTyF6sJh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XGUet/nX42bSwKZ2KUnEC+LBbDrNBhAuR79ZtGWgPZ8=;
	b=lRrijnVVirek5pcXwC+hqCqPKpkkQGLkNOl2hhjd8HEZHXTanIKZheSzG4nf5eEJPnnQBO
	d8U4iAWQHPeohkLCqu8/3Xv/HNnL3/Qpmrw87xvZbBXsczUzFTEgureAstd9TZTbt3dK6R
	Cki8AciYmu6ymOwenW1aD/Qtg/Iwcp8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LTyF6sJh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797370;
	b=HPjOzfWXcwrFM0z/jmdXH5awJdKgshoUs/x3xX2Bj+M30II+9PAV6i0hUaoIng5fl6eBxe
	V7w379+QCgHtFDwAUiHeFH9n3W3OfHVUI5AKXAVSF26CMMnqCfo60IaZazFnPIB7aalv4U
	FcIisZ2GaZbh00y9DDgLi6+z8ebvOjw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78CCC60F14;
	Wed,  4 Nov 2026 13:02:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56511F00A17;
	Wed,  4 Nov 2026 13:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797369;
	bh=XGUet/nX42bSwKZ2KUnEC+LBbDrNBhAuR79ZtGWgPZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LTyF6sJhyMGVnZa/UWJodxB/dDMmwuunKXCbuD/suEE9A/vq5suIGbIdo8yHO7El5
	 fyk4bM2O+6u6g/6dld+JarguhE+EZ2Wf/uRiWTbwl+NhERMMvGriPF1sEZ6XitxZZi
	 fa2WrTocGRDQ/fGK5irXh61jn8i8NXJSCbbkWvpwIRMCphfHf4pxJhmktKKTjn868d
	 SF1ENHGukPb2+KHgsP41bCXnjVqZVv3UKJym8wt58+WtriNI5n454a1Qd5XMs8jdWO
	 q4FuBXcpuY309a55x9ZqGz8LiVmGfDV1Fv28jR3nLW2G7TeeiG3JzrKxH2021jN/u6
	 fahSZm5ikZpOw==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.ams.internal (Postfix) with ESMTP id 9577D1980054;
	Wed,  4 Nov 2026 08:02:41 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Wed, 04 Nov 2026 08:02:45 -0500
X-ME-Sender: <xms:8SzrapKIhd-cwbaN6so_lThcYd7PjY5k5sSOR2TysUrY3PEARg4ElA>
    <xme:8SzraqZlA164U-tMpWxTKFChyZK-Sa_RO0Fl_F4DMDHi6bBYs5sC0G8ynASLFVu7T
    hP5XH0wkD720QbBY2mNNtZJF0QtSl7M6PacJgQ4L7K54mnVCqJNRLaM>
X-ME-Received: <xmr:8SzrakW7GeKiXcNXnhBZ9-HKUi_JAo54d7O0BgZ_0xLanfhqXYMdIHvMly0>
X-ME-Proxy-Cause: dmFkZTEk66d9wDCrVwGV2KJIuy/ruy5O0lHCepBxGNrlOaBp07skOmfpvndHRI5OELNSRA
    yGn0MCxfDBFvgtyU/Ak4d/WAic24VoVtjIR75/P/ngQIuraqmEs9ZkAXJhPO2VIG+d1IXF
    8IM0H4JyLf1Zvo7c0MMOZUL01NImbyo67v4VfXk76TAaVongE51xEXOR6TwNiSJMyPmHzO
    yvy//RxDs7szi5OqCFXsHX0nUmlJzvH+fYd32en08T2wupH37oWBqHCmwt7iQGlRXBtll9
    wmwpz0VKkZxr490s373q3pKsnGNjbIq7dF2jWYGBMXYWabdlQXgHC7ofo/k0KNKzla0CUC
    U6wwdcotS31awyT+o/wr6p9VDSEpn0ZpF4pwW9xlQyOh7TDLHcL5cKPyqnRe9rgU0FWYaH
    T8Z8lVHEiaZ4l1qriH7SJHJgb27kPF/nXHy0GHvJXUbT6t2R/tLSL5EMTO1BVfk5vt9L+n
    5f3C9aBDjNQLjGpTszqMtmEYobi47ZD43JIXzlz4PesRU7jhLrKbUeNmAZQ4l+tyA723I3
    xADPtB+fOkSQdO58lgyn/vMWGsk5tl5QxEJGV0KPdKQFEZ6k9PdKnQ+ClBkQF0D8m+TIYy
    1t/mRoZCZabukbXq0clcILi20Nep6CsJ1Ogs7uOABQFSxHKH/zHQSm8VZkZw
X-ME-Proxy: <xmx:8SzraqHWl55Rjxbvja8vOkfQysEq15RiYTJpCl4TVXHvPmDc48JU5Q>
    <xmx:8SzrahCX_yDMRZR8mQa_huksDJdjIFF3B542plDCXnKPlx_SleDt7w>
    <xmx:8SzralXEpBbya0F58yOB4C-j_AmD2gzAatB37XVoaLS_d2F-8eYT2g>
    <xmx:8Szrah4waKjWbrxU07uQeD_CS0kTL1Zl4tLQ9hwKZNs6coWVENeXmQ>
    <xmx:8SzramG2GnIP9aTpvj31XvphF5ZCNsfa_SGXxsqHkfBs0-Fe-7f1Ftsd>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 08:02:40 -0500 (EST)
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
Cc: Miklos Szeredi <miklos@szeredi.hu>,
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
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH v2 13/18] mm/filemap: read from the page cache without folio references
Date: Wed,  4 Nov 2026 13:01:09 +0000
Message-ID: <20261104130118.2507513-14-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104130118.2507513-1-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 102CF40017
X-Stat-Signature: q3z3hx848gbbswtire1x4j81hsq36qe5
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793797369-246415
X-HE-Meta: U2FsdGVkX19/WiISGNB4op4DXeFUijaVzV51jhXfVsjNyD+csjdNqli7AW7Ybxq2lFJ5Wh8GyNJievlMZLNYtJ5+25chFeNJq60Mkr1flP21PhLc2q/OdcZ/ts7oYJ/v+I5KjJPRVw+sIZuSmL2tle8wJePTOxMGXIpyQ9WzZHz8uOrUsZ9MbSE2KrkB+Ou6R4Xj/eZaQYtJm0U0jVCKJfDlGnCKAd5HZIVYRdGt5xPTFf2haSuvNQoqorzwW6yLKeR2eB3lZKEolKn87/7hbqU5oXAZzrYnauMfWD0s8kXA0DVpY1sK4xbiDZ7JdEnLm1GHPICFX+/UaMi84qo3NdN8/Ox53YwF7ZAp0aD1VdIUFmD4SFFSUQFqyOtrqA/YUkhVjqmRxEwMFnJ0IlTu1/WUjobGb3JftT9p7bByserRYVATjAI76ejImX2J/LW5uvrouINbPaigPjZmjwoQRkyze//BSoy44QMBLY4m0h6iZePynPv5Tug7LJ4P2xNobMhWrFLz09PW+0F2ilhIm6zXpXVrpIbXE86ugMA3Rz9FK62MgfZOdOJrdzzIsygCnfnH4Xc4FysCjg5HpJMS8RRu4sQdTX9u2P1xG9dIDIiz1kMoPRRrgkpVg+osziHcSST8oVqy+nQ6BSvI8hiB3YXgl66JjQ2YuD35YU7iQLdaJmjRwk6AZzPyCDERxKUeq0zIKz+xLgbAHnch9Mp2GHHBTTYcY3fUtAUFZf1FX2v4kIrWeHDoOGXLTcxCiACE8/aGuxNUDQbxJdR0FkMeMQlKYqLq/5LinTvjutjr5WXHgVhz02lONKlWBG+rzVBkso9r1tsg1YR6nV0BUuHqARWQSRXHo6DMqBmyww2dJ4/S+v8rWyyAmJZKLoqvK0NizNiO2sZD4g4m3HCvlVmasiX8oB45BIfM9g796nilFYvqUnUfNWifKcUC/SNoWb8iH2O4RLin4n46yqECu4L
 Nudnr7RD
 Cp6RSGAAof8lqcr9d5+WmyUcoNZfLDNfejHfIggtMUYdKiZV7wkCwMymC+pRFPoTTW/Sfu/HRDdfX4XYUYD1M9EevQ4llGjZJKRM85gf4DChae6b/4I8uJBIxnfBjnUAnGcPWrlUezIICzHOr2i0wuXp6u3722PnpPAJqIoyosIaK9lKYaivxjVbzEllWwb1ax7OU0R1xDr8YK2xAioA70g7SQmYm7gG/T1xyUMYKzmxdyIWQNhtuIcQrxd/5Xe58AElRAYtKiYutWyOOhy8xmhD/Yb+wn2Nw3NZjFBRE5NuditKMNSZJOXWQRfHyRt/jk9cpZWgmTUVViOyX4bWyRVZ94AaJW199xgD6UMi/wPlS47yqw/zoitKdKIjch6Dr0OS0/0vKmRo4jG8=
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
for all of its pages.  A split clears PG_head before the new folios
replace the old one in their slots, so copy an order-0 folio only at its
own index.  Copy at most 512 KiB per rcu_read_lock() section, and skip
files that never had a folio flagged or that are writably mapped where
flush_dcache_folio() is needed.

Declare the folio batch in the loop: with stack auto-initialisation,
the compiler zeroes it where it is declared, and the copy without
references does not use it.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[kas: i_size before the second look at the slot, poisoned folio check,
 large folios left to the slow path, 512 KiB sections, folio batch in
 the loop, shorter comments and changelog]
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/filemap.c | 178 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 175 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b732ecaa78a9..e99705a66c1d 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2821,6 +2821,168 @@ static void filemap_end_dropbehind_read(struct folio *folio)
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
+	/* One reference covers all of a large folio's pages */
+	if (folio_test_large(folio))
+		return false;
+	/* A split clears PG_head before it puts the new folios in their slots */
+	if (folio->index != index)
+		return false;
+	/* memory_failure() waits only for readers that got past this */
+	if (folio_test_hwpoison(folio))
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
@@ -2841,11 +3003,11 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 	struct file_ra_state *ra = &filp->f_ra;
 	struct address_space *mapping = filp->f_mapping;
 	struct inode *inode = mapping->host;
-	struct folio_batch fbatch;
 	int i, error = 0;
 	bool writably_mapped;
 	loff_t isize, end_offset;
 	loff_t last_pos = ra->prev_pos;
+	size_t fast_read;
 
 	if (unlikely(iocb->ki_pos < 0))
 		return -EINVAL;
@@ -2855,9 +3017,19 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 		return 0;
 
 	iov_iter_truncate(iter, inode->i_sb->s_maxbytes - iocb->ki_pos);
-	folio_batch_init(&fbatch);
+
+	fast_read = filemap_read_rcu(iocb, iter, last_pos);
+	if (fast_read) {
+		already_read += fast_read;
+		last_pos = iocb->ki_pos;
+		if (!iov_iter_count(iter))
+			goto out;
+	}
 
 	do {
+		struct folio_batch fbatch;
+
+		folio_batch_init(&fbatch);
 		cond_resched();
 
 		/*
@@ -2931,9 +3103,9 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 			filemap_end_dropbehind_read(folio);
 			folio_put(folio);
 		}
-		folio_batch_init(&fbatch);
 	} while (iov_iter_count(iter) && iocb->ki_pos < isize && !error);
 
+out:
 	file_accessed(filp);
 	ra->prev_pos = last_pos;
 	return already_read ? already_read : error;
-- 
2.54.0


