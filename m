Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C02E760A2609
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F1LyX8R4
Received: by kanga.kvack.org (Postfix)
	id DB5D86B05C8; Wed,  4 Nov 2026 08:02:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D66326B05C9; Wed,  4 Nov 2026 08:02:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2E0F6B05CA; Wed,  4 Nov 2026 08:02:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EE936B05C8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:02:57 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20852805EC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:57 +0000 (UTC)
X-FDA: 85397451594.09.D608DB5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2DE0540002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F1LyX8R4;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797375;
	b=Kf7GpfbvHh6X7bGz+o5Dql0UYCh+38OtRIFvqOLvHbqXKBMJv7XxtzIVptkhsZh2hYBHm9
	+dIzNuyXFUYjSiMlhp36zMhE79UdK5SfJ+0TKlzJaE60RnEBAZjHn20081Z+2h6HKWnLfG
	qBlySyz+JtmSmyFD7wONYSZ5aKtJSX4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F1LyX8R4;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l4BGAIhk72GrMEl0bP2Tn3Taagv1PMlryAAvqGAVCp8=;
	b=xCNdyow98rIAT+Uq4skKz6XKc8OBKUkzHB91fOYEAb5cNe9pANZRozE+u9WLGMUs2RXJ5f
	fx9+GiHNWHxXXoXZVimZwYBMw15YMIox5keqxgik+jYW/SEioJ3ed+ZR71RyF4Svb9AWMk
	khlbKL5HXQjY4yK0E2rusTaJD1eMG0Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD32062CCD;
	Wed,  4 Nov 2026 13:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC01E1F00919;
	Wed,  4 Nov 2026 13:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797374;
	bh=l4BGAIhk72GrMEl0bP2Tn3Taagv1PMlryAAvqGAVCp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F1LyX8R4P3vBU4b+F2XBXrMDfS07VL/kzGTZl5WZ2jilUL/Pv1sFab1/6HkwUOlfR
	 49VIhSwtwo/qkshsUOk19XQ6RpXvnixjanFkzFWUp43QFVeOetVvEuuUwMm8N7JoWG
	 jkuhQ2o9pcJKHXN+Q21/k6Wi8roWbPx485Th/DPe8g7YjgPHJfINrWpG/1uqAMS+ws
	 lWMIQukGqXIvO2CAadONoMSgHNjZmSMr6d6+MIEvTihJemX9WdgZiT8x63YldoVVC+
	 JQo8D3OBlW7yNBOuqzSnWHrkGcilchJ6E6qVXHXbSgAw+iEnxkeiDGRAeFvi/CKKNy
	 BTL25I50GQ2eQ==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id 90B541980052;
	Wed,  4 Nov 2026 08:02:47 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Wed, 04 Nov 2026 08:02:51 -0500
X-ME-Sender: <xms:9yzrajt91AZFpLBodMj6k_PS6-YllUd7evvZYhKdxHO7oUFQBm763g>
    <xme:9yzraptnPSSxy0OXh8kpgQPiB5dqxyeWpbqVMo8pz7MV6H5HSC_N-pK8s2awEiwIo
    TWsMFGtVQdBcGAqb0tOeOC0PiFUhkSqikqMb2OuZ1z-BZhEN6Q1Qd4s>
X-ME-Received: <xmr:9yzrapauaqrB4nFlNq9-vwGqRSb-ZRFfSUzzmuDf8Acqoba839jvtoib3UU>
X-ME-Proxy-Cause: dmFkZTFt4psseRmmhNB25obH6e3Jmvg5MI9YjhYCShYB0WDZIR/sfoknekqjPtgLdp/VUx
    DAjH23g16+lAAecMdJ7OTa+nj8nV+GeN+FQlk8C1gy1317lcxEZjhrwlk2drfC/uxjeZcm
    3c59gZriNo2ojihZ9Y23fsOBzYxPIsmJfU1uqjzKUR4FkiS0+meIWSsOSNIu46exUFpFDS
    Im6fJ1GXvBUs0GlP10d0JMz3tbvwwBF4SAjp/2yPzCkhjLYZeeIZwbBiU7bowbKHBhNqDH
    kkHjCH0P4lA1CsjneqhclSHZw/vFFT3nC/F46W32G1Imcq8qWwl+hWhNeM9PLDwYqAznrA
    botFO87QZCf63ZMvqVrnxb4nRvMNa+SpXn1D3yNUO949q+ZPxt3g0Q6ELkZXrR6s9Tt5Z0
    ygM9U8EzPTNorTVCkjy5tsM8rFr9kFdYDVudOtiYHqHMxYcySn8RIfNNjnRUWWKZmhv6EJ
    A0e6dWvhemwxXDPDlUnv3Hc1Qm5gXgWiz7JGXFuPLBHEFAKqBqEE0FP/ZWPB29J8cwEAHu
    0lxgC9mgUGjHS+HCAI4Qe6VaLlUtffp+n04M3cP3XOdZoK+8upPna2GA9e9RLqtS3uoj/q
    r46Z3ZkokvRgfkQcnyoj99Q8Bbh121zyfSLccAZ+JLsDBGND9pRiA/Iwt54Q
X-ME-Proxy: <xmx:9yzrah42VjCbtjvba91Li-1qyFt43m9W8LuN8HYOjeDNczh8kkMRAg>
    <xmx:9yzrakmNFKbPyz558y0RvD02sSlD3Xu-MoNpJ5QF0vSoUXrNdXHxHg>
    <xmx:9yzraprQVACPA0z8r3I-z1FGeHInM1ZJ5QQ4_sf6nJfOfQS3E-aVCw>
    <xmx:9yzran9n_3hDXu_qHcPi0lAWRYsk9hedK7Uebn3Jt4TvcHAup-PTHw>
    <xmx:9yzraq5wqkk704d7_zAqSwKAYvGWfq9CXT_tQvEpgKPrGcDVYzVOh9aM>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 08:02:46 -0500 (EST)
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
Subject: [RFC PATCH v2 14/18] mm/filemap: read large folios without folio references
Date: Wed,  4 Nov 2026 13:01:10 +0000
Message-ID: <20261104130118.2507513-15-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104130118.2507513-1-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m3uk5n4pz64ead5wjqpams4hrcm4s6of
X-Rspamd-Queue-Id: 2DE0540002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793797375-281653
X-HE-Meta: U2FsdGVkX1/9/9lxD2F/Nlpfv4urEUBda6XaZ0ICCXkwg67j/yPez8sRXU/D+EsgxijmlIxS+VhlAcRjXjPOWuxVlinEstGQlBZv1DlrvMoCok2+fd+fIVeperUtuhYB4DIpgjVbXVUNxTkCUfI33T8vHgSGrLoTgQdFRGHatb3HsmZyIZLRot0wNX3eXdoOq7mqxMFSOsM4IrfcjIGEFOmIBaiCLaDtUl/9M+dsV3xHuN1Q1eUTyLyR10wwbpzQfsKrJy3Dy0sDq4Rx9TwjanzZaTytfL2ak6R5rNvgufi0sRkGlP7x1/tfjsJ2lps8qRLrHHe+x2xbHjkTTjFG5OsWbHnX2/EK+5FKjlswTweNwBDLbyA3yE9Y0/C+wWy5aZ/anesece2QfJxJSXqTgqWCFbq8XGpPVaXqOnA1y2Mwp4U2Nl19TWsl53LccuyCScJR3AzmkxguR3CyugMUk9wsDvntugPGR807d/+dLv8JHm/88bioxLhpjFAQzu6TwHxLpSyVNXZyhXI3TkIfoFgQVRucTj2a1CQY1tf+R80dZXX7fWLV/oz031u4WTRjq/w3hW/jLs5NcZvbmq075liQD7OJT70cwjCripOvxJ6KFQ+Y/944mYOOT9vE6soCCVnzHTOp7TiUKJeLAgTw2QQYWOJAwnI5bcaC+8Y4BsnbNIXRzMHLgVwSccP02nbNGkkpBbjhqXACbZUt98LvwkS1sxQbdyzjtvmveYdady2IbC6leRv3bG3A7I7PhwyS8TqmIKahnHwH/xHbCQmbqQmBCfC0/zDTSFryB4dpSrrk7j8pzVVtpP3H/NtCqOwq7bJFiMR2XY+9APMfsRIZboL63pUU4hGv+ah2pMGiY0dst6xpGZd+oI6zUpV99mizhnMfFuiAIgy+U1tHG3RIumUrJKQsnheDSk1MwvZDSksRcxAClkpneOEENLsDLMdFWqHMxpXUNwp9rzAtPUy
 HHPV6DZ/
 kD47VUwClxJSQBtHwCrcHpwTrBkAxEIaVpCGhNp805Kg/XbujG9CKyN3bBjV7qgH0DeGX+eVsdQvK7aTdy1M7vltHfzz2RINEwK2AZ3NFw5unEsddfQlDtt7weehptR+mGSG+Ofgcu19iCrqH+SR6oRIIxdBKhJ0JMyh70yOpaye9BIEXk+CH+UaIUK5fFzbZQh1yk48FMFNJtj8pO+cWFn5Py6Iba7DB3wpTmthKXcFKODV1ruCfAYxtfx/Vifb8s/OOQsNAMYN24rUA3lnE1L3Br7UC18p39afPrrWbBvS7eecbTfB6Rn7+uRrRS6U9y6v1lSzjCFmn9PsGH2LCarp5rQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A large folio is in all the slots of its range or in none.  Once the
slot of the last page to copy holds it too, the pages in between are
this folio's: copy them after one lookup.  The folio's size is read
without a reference and only picks the page to check; a split after the
check copies PG_rcu_free to the new folios.  A split can also change the
order and PG_head under the reader: clamp the order, and read
PG_has_hwpoisoned without folio_test_has_hwpoisoned(), which asserts
PG_head.

Copy page by page with _copy_to_iter(): the hardened usercopy check of
copy_to_iter() reads the folio's order, which a split can change.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/filemap.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 64 insertions(+), 8 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index e99705a66c1d..182ae7d5db56 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2834,15 +2834,16 @@ static bool filemap_read_rcu_can_copy(struct folio *folio, pgoff_t index,
 		return false;
 	if (folio_test_readahead(folio) || folio_test_dropbehind(folio))
 		return false;
-	/* One reference covers all of a large folio's pages */
-	if (folio_test_large(folio))
-		return false;
 	/* A split clears PG_head before it puts the new folios in their slots */
-	if (folio->index != index)
+	if (!folio_test_large(folio) && folio->index != index)
 		return false;
 	/* memory_failure() waits only for readers that got past this */
 	if (folio_test_hwpoison(folio))
 		return false;
+	/* Not folio_test_has_hwpoisoned(): it asserts PG_head, a split clears it */
+	if (folio_test_large(folio) &&
+	    test_bit(PG_has_hwpoisoned, &folio->_flags_1))
+		return false;
 
 	/*
 	 * The slow path does not call folio_mark_accessed() on the folio that
@@ -2896,6 +2897,62 @@ static struct folio *filemap_read_rcu_lookup(struct xa_state *xas,
 	return folio;
 }
 
+/*
+ * How much of @bytes, starting @offset into page @index, can be copied from
+ * @folio.  A folio is in all the slots of its range or in none: when the slot
+ * of the last page holds it too, so do the slots in between, and the pages
+ * are this folio's.
+ */
+static size_t filemap_read_rcu_size(struct xa_state *xas, struct folio *folio,
+		pgoff_t index, size_t offset, size_t bytes)
+{
+	pgoff_t end = index + DIV_ROUND_UP(offset + bytes, PAGE_SIZE);
+	unsigned int order;
+	pgoff_t next;
+
+	if (end - index > 1 && folio_test_large(folio)) {
+		/* A split can change it under us: it only picks the page to check */
+		order = min(folio_large_order(folio), MAX_PAGECACHE_ORDER);
+		next = folio->index + (1UL << order);
+		if (next > index && next < end)
+			end = next;
+		xas_set(xas, end - 1);
+		/* A split after this copies PG_rcu_free to the new folios */
+		if (xas_load(xas) == folio)
+			return min(bytes, (end - index) * PAGE_SIZE - offset);
+	}
+	return min(bytes, PAGE_SIZE - offset);
+}
+
+/*
+ * Copy @bytes from @folio, starting @offset into its page at @index.  Page
+ * by page, as copy_page_to_iter() does, without its checks for each call.
+ * Not copy_to_iter(): its usercopy check reads the folio's order, which a
+ * split can change.
+ */
+static size_t filemap_read_rcu_copy(struct folio *folio, pgoff_t index,
+		size_t offset, size_t bytes, struct iov_iter *iter)
+{
+	struct page *page = folio_page(folio, index - folio->index);
+	size_t n = 0;
+
+	while (n < bytes) {
+		size_t len = min(bytes - n, PAGE_SIZE - offset);
+		size_t done;
+		void *kaddr;
+
+		kaddr = kmap_local_page(page);
+		done = _copy_to_iter(kaddr + offset, len, iter);
+		kunmap_local(kaddr);
+		n += done;
+		if (done < len)
+			break;
+		offset = 0;
+		page++;
+	}
+	return n;
+}
+
 /* Bytes one RCU read section copies at most: it holds up grace periods */
 #define FILEMAP_RCU_READ_MAX	SZ_512K
 
@@ -2941,10 +2998,9 @@ static bool filemap_read_rcu_batch(struct kiocb *iocb, struct iov_iter *iter,
 			break;
 
 		bytes = min_t(loff_t, isize - pos, iov_iter_count(iter));
-		bytes = min3(bytes, budget, PAGE_SIZE - offset);
-		/* Not _nofault(): its usercopy check reads the folio's order */
-		n = copy_page_to_iter(folio_page(folio, index - folio->index),
-				      offset, bytes, iter);
+		bytes = filemap_read_rcu_size(&xas, folio, index, offset,
+					      min(bytes, budget));
+		n = filemap_read_rcu_copy(folio, index, offset, bytes, iter);
 		*copied += n;
 		iocb->ki_pos += n;
 		budget -= n;
-- 
2.54.0


