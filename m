Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04BD0CD98C7
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 02:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34F0D6B0005; Thu, 11 Jun 2026 22:38:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 326016B0088; Thu, 11 Jun 2026 22:38:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 263516B008C; Thu, 11 Jun 2026 22:38:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 160556B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 22:38:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB58C1A0467
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:38:31 +0000 (UTC)
X-FDA: 84869702022.05.80C2D9B
Received: from SHSQR01.spreadtrum.com (unknown [222.66.158.135])
	by imf06.hostedemail.com (Postfix) with ESMTP id 83C28180005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:38:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=kr8U0avN;
	spf=pass (imf06.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781231909;
	b=T51JNt5PY8Eqs4/U7oC45Q7pMudCoabvIejyXX2iG8VclbknHHmoTX/TyemIURs1wormo3
	Df9icS3zDbCQajOoRXde5jyMPWZphMEynE5/yjhRP6YySwVFP0U15IZ9xGwOJHlbpgY3I/
	mKsVh068Pf3h8qxQx/fP6p5jbU+9Bkw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=kr8U0avN;
	spf=pass (imf06.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781231909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PXJYIYRnngICuVpD5lGcrRUztWHnNTiA0AI9Ism9GE0=;
	b=h7KytbV0sAakI1c/afCSEqDRJnBkcEAmUXKtQuVfLi9JL9tvnVknuCdzJgG//I+h8PdmpS
	eJoZolXHl5KWBG8yVqCTZeEsmVZ9UfdSWKlYBUwkFY7whRmZ1bYtZtvp/TuDJ1kdJDvSUL
	uRAAyrwjYpMg24U1n2vkO6UnwyIaMNY=
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTPS id 65C2Z6mW062701
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Fri, 12 Jun 2026 10:35:06 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4gc3Qn1K82z2Q9CQF;
	Fri, 12 Jun 2026 10:30:41 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Fri, 12 Jun 2026 10:35:03 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Lorenzo Stoakes
	<ljs@kernel.org>, Barry Song <baohua@kernel.org>,
        Baolin Wang
	<baolin.wang@linux.alibaba.com>,
        Lance Yang <lance.yang@linux.dev>,
        "Liam R .
 Howlett" <liam@infradead.org>,
        Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Jaegeuk Kim
	<jaegeuk@kernel.org>,
        Chao Yu <chao@kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang <huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
CC: <xiuhong.wang@unisoc.com>
Subject: [PATCHv2] mm/huge_memory: do not add dropped split tail folios to LRU
Date: Fri, 12 Jun 2026 10:34:56 +0800
Message-ID: <20260612023456.2424044-1-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 65C2Z6mW062701
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1781231718;
	bh=PXJYIYRnngICuVpD5lGcrRUztWHnNTiA0AI9Ism9GE0=;
	h=From:To:CC:Subject:Date;
	b=kr8U0avNTTcS0+eoNLbe8NzH9uwAZT5Q13aH4nKScVap+6Ll6DsXLjNp4S24ZpXdi
	 L990zeMf0tESw6l+KLoHYXximUkIqRRrIAS0Iad1IVKGjCAxlRzsVhhPqora6UmjLL
	 jKMotRzQBNOgJmCR0jOGk0zZ+9ZQNJpzJ9s2e5jNAuYmv8k4jTjM1XnYrXlN/iWkDq
	 vR9T6gYkFa8WLu/q4gTlkQOUdZtOXCzY018J6+UGWy5SKKvmE1zFwsP1V7qBO/S6ix
	 dH3tPPyLtu47Ks2JUW/qIJ4jGNVc6bkwE+gtgfJEud+v/3Rlrn9enmjGiHtqVDLXrs
	 Dgys8Mvd8aGAQ==
X-Rspamd-Queue-Id: 83C28180005
X-Stat-Signature: 1yjkpckzi4pztbwxwaei61gkeatihmnd
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781231908-758563
X-HE-Meta: U2FsdGVkX19ikmnKa5N475A+GfOo9g9kS/doRcSP9iWDduDjCOPgNHvVh4wHC96T5fKMSNorbdEgV6ebeuKyOGRApyGTXAdr+jT3yPi61OHJlUetNGYCaV8LS1PRPtY8wboyELL5EMAbnRbmVv3sMH0vYPU5SidK1tcUEf3IFrQleGEqd1fPwX0QkgjV5nPX0i0zvUVYbzWNtiAzcY0NY6LrScWsLhqczhhFQ/n4RQnqxXbuwK1oPz2vUyG75FhFHHyRiDXNepUzWJdqW5Vu5Gnf27+fdaBd0ILBnUfDaGyRFW/WudyLMLppH9gUI8kl/OgX70uwgvr/mK/nQGJucdUJ+H3oG5vnZXQPiU9rxo5G7NXDJsq7VeVJ2xDnRA1jhJfVIMth32S5afLr9pS6e4N2SyXXiBkAFzi9Tdr70uQB3PO9E3Ys/GMrr5XK6pln2vgV6QTi5hBQNERqaTrQ2Eea95IvwU6K7scarbGVBwwlhZhs++pGX1B0s4lfWNJ4qdSxoAGVO466yeUxxjTq0bKmt40cSV5mhKlMWKZe+hWp3Js6+01px0aPbfGx72nn0zgpns0PTC8tSU/QLXQ1Yrf0CPW4c6iOalK2QS8nsdYU998+bpxJei3esT6JlGhK/3vzsADFAi0lSPRcnMpIE7zw/ggrYsYRaSFm6FDJ9vqaeLYAmAzd/wU0SRAK6zD14gbtw6tb+JnimG6EEA8QEYHbtYuDWyXFPk/AGYhMlx3D9H7G6VNMF2R9sf6YlhI+M1KMLPxYuAYVJcEtJceNWx6Yf1RCO9uEGUCt4C3m1LE2GaBu4EGTCmCa5X/1vwrc2bMkHYxkXFbV1ZlL+5t2C7l0omAdfecgzIRQjFZeojxa2OaNkXh0TkpGlMR3PjFtbcTsEEFl1dowKyf2fvWNyBly9qTkBIl3ZXPwiICyenGLvLCnMrJmpRPfD3ReFmEcXYmAtwhB8hrIZV559WK
 PS8brE8c
 Y3pD8ufRj8ktIjDpohKJSKrmY1s/KZ2qH0mJZxx66z9v7U2dHOfSGZhvXbc8cmVHCaNK5naP23VD+WKO/hOdqVdsAg2XYR4IPWtDFKSzXB2ankT94XwcoBBVlMXCRzqg/dWIswta7vwLr7t6DCwtyGB22FsgbudXXSgdrzwqOclG55a2iJ2M+a01/0f0KXgHSlt8/NCpqxhXq6Kv5Bi/qBlxuroIkM2FSBhuXFpaxhH7FeQuSZv0HI1D2qON7qOoV4dXI3mr9eZcHdznvg4R7VrB4ACnCuCQ4oBVr8fHQu6+E5slFYkRiZ4RUn3TMtbQnn6+R5hcaV0P4sg+yWgGxkcC0yMp45DSlX1QizRgBrNd9yT+VdQUOH7juQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

The kernel panics are keeping to be reported especially when the f2fs
partition get almost full. By investigation, we find that the reason is
one f2fs page got freed to buddy without being deleted from LRU and the
root cause is the race happened in [2] which is enrolled by this commit.
We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: remove
non-uptodate folio from the page cache in move_data_block").

There are 3 race processes in this scenario, please find below for their
main activities. However, by further investigation over the code, I
think there is a common race window for the truncated folios between
split_folio_to_order and folio_isolate_lru, where the folios lost the
refcount on page cache and remains the transient one of the split
caller, under which the folio could enter free path and compete with the
isolation process. This commit would like to suggest to have the folios
beyond EOF stay out of LRU.

Split:
split_folio_to_order() can split the big folio into individual pages and
put the resulting subpages back on the LRU.  For tail pages beyond EOF,
split removes them from the page cache and drops their page-cache
references.  A tail page can then remain on the LRU with PG_lru set while
holding only the split caller's temporary reference.  When
free_folio_and_swap_cache() drops that final reference, the page enters
the final folio_put() release path.

Truncate:
The changed code in move_data_block() lets the GC path evict the tail-end
folio from the page cache through folio_end_dropbehind().  Once
folio_unmap_invalidate() removes the folio from mapping->i_pages, the
page-cache references for all pages in the folio are dropped.  The folio
is then kept alive only by temporary external references, which allows a
later split to operate on a folio whose subpages are no longer protected
by page-cache references.

Isolate:
In parallel, folio_isolate_lru() can observe the same tail page with a
non-zero refcount and PG_lru set.  It clears PG_lru before taking its own
reference.  If this races with the final folio_put() from the split path,
__folio_put() sees PG_lru already cleared and skips lruvec_del_folio().
The page is then freed back to the allocator while its lru links are
still present in the LRU list.  A later LRU operation on a neighboring
page detects the stale link and reports list corruption.

[1]
[   22.486082] list_del corruption. next->prev should be fffffffec10e0ac8, but was dead000000000122. (next=fffffffec10e0a88)
[   22.486130] ------------[ cut here ]------------
[   22.486134] kernel BUG at lib/list_debug.c:67!
[   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
[   22.488502] Tainted: [W]=WARN, [O]=OOT_MODULE
[   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
[   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
[   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
[   22.488539] sp : ffffffc08006b830
[   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 0000000000000000
[   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: fffffffec10e0ac0
[   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead000000000122
[   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ffffffc080061060
[   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 0000000000000058
[   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 0000000000000003
[   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe85721f0e25f00
[   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c65645f7473696c
[   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 0000000000000010
[   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 000000000000006d
[   22.488647] Call trace:
[   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
[   22.488661]  __folio_put+0x2bc/0x434
[   22.488670]  folio_put+0x28/0x58
[   22.488678]  do_garbage_collect+0x1a34/0x2584
[   22.488689]  f2fs_gc+0x230/0x9b4
[   22.488697]  f2fs_fallocate+0xb90/0xdf4
[   22.488706]  vfs_fallocate+0x1b4/0x2bc
[   22.488716]  __arm64_sys_fallocate+0x44/0x78
[   22.488725]  invoke_syscall+0x58/0xe4
[   22.488732]  do_el0_svc+0x48/0xdc
[   22.488739]  el0_svc+0x3c/0x98
[   22.488747]  el0t_64_sync_handler+0x20/0x130
[   22.488754]  el0t_64_sync+0x1c4/0x1c8

[2]
*F: big folio before split
*T: tail folio after split
CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU2 (folio_isolate_lru)
*F: pagecache refs = n
*F: extra refs = split
*F: PG_lru set, mapping != NULL
                            split_folio_to_order(F)
                              folio_ref_freeze(F, 1)
                              ...
                              lru_add_split_folio(T)
                                list_add_tail(&T->lru, &F->lru)
                                folio_set_lru(T)
                                folio_unlock(T)
                              /* T PageLRU set */

*T: pagecache refs = 1
*T: extra refs = GC + split
*T: PG_lru set, mapping != NULL

move_data_block()
folio = f2fs_grab_cache_folio(T)
...
__folio_set_dropbehind(T)
folio_unlock(T)
folio_end_dropbehind(T)
  folio_unmap_invalidate(T)
    __filemap_remove_folio(T)
    folio_put_refs(T, 1)
folio_put(T)

*T: pagecache refs = 0
*T: extra refs = split
*T: PG_lru set, mapping == NULL
                            free_folio_and_swap_cache(T)
                              folio_put_testzero(T)
                                /* refcount: 1 -> 0 */

*T: pagecache refs = 0
*T: extra refs = isolate
*T: PG_lru set, mapping == NULL
                                                                  folio_isolate_lru(T)
                                                                    folio_test_clear_lru(T)
                                __folio_put(T)
                                  __page_cache_release(T)
                                    folio_test_lru(T) == false
                                    /* skip lruvec_del_folio(T) */
                                  free_frozen_pages(T)
                                                                  folio_get(T)
                                                                  lruvec_del_folio(T)
later:
  list_del(adjacent->lru)
    next == &T->lru
    next->prev == LIST_POISON / PCP freelist
    BUG

Assisted-by: Cursor:claude-opus-4-8
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
patchv2: update codes to eliminate bad page status
---
---
 mm/huge_memory.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..c24c12f71157 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3878,6 +3878,23 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
 	return folio_nr_pages(folio);
 }
 
+static void clear_dropped_split_folio_lru_flags(struct folio *folio)
+{
+	/*
+	 * __split_folio_to_order() clones these LRU state bits from the
+	 * original folio.  A folio that is dropped instead of being added to
+	 * the LRU will not pass through lruvec_del_folio() and
+	 * __folio_clear_lru_flags(), so clear the cloned state before it is
+	 * freed back to the page allocator.
+	 */
+	set_mask_bits(&folio->flags.f,
+		      (1UL << PG_referenced) | (1UL << PG_active) |
+			      (1UL << PG_workingset) |
+			      (1UL << PG_unevictable) | __PG_MLOCKED |
+			      LRU_GEN_MASK | LRU_REFS_MASK,
+		      0);
+}
+
 static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
 					     struct page *split_at, struct xa_state *xas,
 					     struct address_space *mapping, bool do_lru,
@@ -3958,6 +3975,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		for (new_folio = folio_next(folio); new_folio != end_folio;
 		     new_folio = next) {
 			unsigned long nr_pages = folio_nr_pages(new_folio);
+			bool drop = mapping && new_folio->index >= end;
 
 			next = folio_next(new_folio);
 
@@ -3966,7 +3984,9 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 			folio_ref_unfreeze(new_folio,
 					   folio_cache_ref_count(new_folio) + 1);
 
-			if (do_lru)
+			if (drop)
+				clear_dropped_split_folio_lru_flags(new_folio);
+			else if (do_lru)
 				lru_add_split_folio(folio, new_folio, lruvec, list);
 
 			/*
-- 
2.25.1


