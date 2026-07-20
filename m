Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93D91C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EEA36B00BC; Mon, 20 Jul 2026 10:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C2E66B00BD; Mon, 20 Jul 2026 10:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43FEA6B00BE; Mon, 20 Jul 2026 10:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7B86B00BC
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:29:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 759811C0126
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:38 +0000 (UTC)
X-FDA: 85009388436.24.0B9CEDA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7A632120009
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=I8f093Gt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zIPot4lI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=I8f093Gt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zIPot4lI;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QwWtCS1crk1JPnVWYwUvcYFHRLHis6CsOgoX49n95Ww=;
	b=LzZbB4skbCmpLmrALlqhky5ZGBctq8eYl5hx7tnjl3IhVz0isO9Nxo2hIPRtThCIoI3ERN
	GdV9qRBdXqJ8t4qzNdtWMQWsN3L92as2PPtthrmfd2gsGOoOgD67UPYpg6dGFgfQOiFySj
	2yXgwZdlO8rrngtUsfg6uTcHi9jQ73k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557776;
	b=YubquDJ4gaS5WfTREBE9XjS1LEkl6vcnNJl7LuoVsFlNBQVy7vS7Fj9HcDFudhrkFqzwwt
	Rx75IO4cJ1aTMnhMiqjaK5YoDbHKzyI0gEyCoS5sd1mRVkk7G36QItaxtrmJdhV9D4PPiR
	ngfpekKfk3fIgeng21XDA+B5Jh31B/E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=I8f093Gt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zIPot4lI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=I8f093Gt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zIPot4lI;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D8F663E22;
	Mon, 20 Jul 2026 14:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784557764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QwWtCS1crk1JPnVWYwUvcYFHRLHis6CsOgoX49n95Ww=;
	b=I8f093GtNZzJw23a862NbIXxjnZL0gLD4DhsL4eieV5dsdC9VLY0iNBweLhQtwx8BksDQZ
	tvyfKJmwjTK7+L3H3JEd+qIG6Qyx59u81vbdBKiE2An3hNI98zWpiJNYZT4H7Y7hLm4X/E
	qsZ3y4+nukAPhchkdttG7sRYkNXevbA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784557764;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QwWtCS1crk1JPnVWYwUvcYFHRLHis6CsOgoX49n95Ww=;
	b=zIPot4lIM66SF1r38ioJl2NT6cNaDwQdluP8gN4lhBmyRhMnDwkgzXXG6ktKmg9iV/aNCM
	ntUAYPOOEj4Z25AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784557764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QwWtCS1crk1JPnVWYwUvcYFHRLHis6CsOgoX49n95Ww=;
	b=I8f093GtNZzJw23a862NbIXxjnZL0gLD4DhsL4eieV5dsdC9VLY0iNBweLhQtwx8BksDQZ
	tvyfKJmwjTK7+L3H3JEd+qIG6Qyx59u81vbdBKiE2An3hNI98zWpiJNYZT4H7Y7hLm4X/E
	qsZ3y4+nukAPhchkdttG7sRYkNXevbA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784557764;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QwWtCS1crk1JPnVWYwUvcYFHRLHis6CsOgoX49n95Ww=;
	b=zIPot4lIM66SF1r38ioJl2NT6cNaDwQdluP8gN4lhBmyRhMnDwkgzXXG6ktKmg9iV/aNCM
	ntUAYPOOEj4Z25AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D4C21779AA;
	Mon, 20 Jul 2026 14:29:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +PvML8MwXmrKTQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 20 Jul 2026 14:29:23 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] mm/khugepaged: hoist more code into collapse_isolate_folio()
Date: Mon, 20 Jul 2026 15:29:12 +0100
Message-ID: <20260720142913.846902-8-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720142913.846902-1-pfalcato@suse.de>
References: <20260720142913.846902-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7A632120009
X-Stat-Signature: hrhoaezw98tcjcqmtxnu71ia5w4wafef
X-Rspam-User: 
X-HE-Tag: 1784557776-366126
X-HE-Meta: U2FsdGVkX1+LaFutkTcwTkgBB/aIbUxkYSX1vADahNb9PltyVARmLt3R9LKyNfgNSCWhms1ceIhQ8LL6UEVGgiI1AGnXvrNCWa04umtn2+fxrW/wIsqw4x+SeGQ7GGqnUy+qw186FCswgzX0nXwbCT4md8KzHy3tWLnZqrTDdELFWAIr1ibPS7ZQTsIGZQq6hYZ52GjYcvLPs+PKZVKhcMXc0eEs9jLnyCPzcI+BIEEXl+bxId/DdZzxr24aCBPwzB9utty8AsVi//2APswSuq71Q9Fq9tBntHQABydyW5pObiiVmOQfpxbSo/fMjurgIp9/Gp65qV2Zoloa4AwSbdzzROjuKZrZ+KCOo6b8FOTjDYjD65hf6LO+5POQouE+L5utKhBc4JGUhHLqObacYK0wx2orZ5VlOphKIzKzUhwLg81FeGJ2O2gkcYbDBTVTHd5jtG4IcFUZeS2WHbCdq7AjZeG/a6L6VdetEAbm6N6XtbiA8Qjx/XE5ONeBOptDCDuo7W+PwO+P+Z+OoG+fjO7kPWuEd4bL/BSPT93xEg9E62EMNFwfuxObQt2sTxrF25u98/+QFP2s/DoPkLszXlCnUilY7skpXRxvTqCyyXpG+tN7PUhiQp0JvBM60m1zJ4l6a6f72x9cOCyjLWp/pEp9qsFf7c9wO4NTf7JwSIR7lOE3HKDrHFhcBY3CrUlKKB1+KX+M4Q7Id5bTUajmHwGa2pHrQKLWTZH+sPbAvsZYE6dOi1uSYOj+6t28BdyukCgjHyh8AGOUGntn063yKS0Ogo6Zpi9WYjOvERvjCWYORIHADVKT8KuV5ubMpxzNdXIs4jU88NcPSGRXT0ygDAleeTHl6/lPxhKYYotUOxvJg5c5nBbdqcX84y5KI9c4LdUt6k+pvyuA25KRn+eiVs0fuREQtQpYx7qtnNFEXr++6iKf5Kre+JV5SUgG6YVw3/bIiWt+AyaDV/6m+8w
 xutOyKEF
 xqGGg73W/012HZ9E1MduPF2b/hnM0faIoDYauUWmqVHC3CkfPVO3p21EkdzDzBATu4oXrip1G6JoBgk/pk5rClK9n7F7gQtBJArYk+EPvpgVbYdlXz3w6L6RU/TjKUt9/1I5k6NEQdJnuU1+tSgHQsPHYvzsYlqlpF7uiaRiTYGqwKdE+j7ZcfkvWkuNAeKa3SPnGdPwB1+E06qzXUbZslTNWnPXqCJ/c4ynPVNV0X5qmvcAKKBzGiNuXyIpYIYMQE0fSK2gWQEEIBG3mIZX2wb3FZ7fw0IM0Lnai3pYV+I2Ytgm0xj0vw2IE7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Checking expected refcounts or dirtyness has no need for the i_pages
xarray lock.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/khugepaged.c | 83 ++++++++++++++++++++++---------------------------
 1 file changed, 37 insertions(+), 46 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 429e2c5833d0..a09e4e4e1943 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2382,13 +2382,48 @@ static enum scan_result collapse_isolate_folio(struct collapse_file_state *state
 
 	if (!filemap_release_folio(folio, GFP_KERNEL)) {
 		result = SCAN_PAGE_HAS_PRIVATE;
-		folio_putback_lru(folio);
-		goto out_unlock;
+		goto out_putback;
 	}
 
 	if (folio_mapped(folio))
 		try_to_unmap(folio, TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
+	/*
+	 * We control 2 + nr_pages references to the folio:
+	 *  - we hold a pin on it;
+	 *  - nr_pages reference from page cache;
+	 *  - one from lru_isolate_folio;
+	 * If those are the only references, then any new usage
+	 * of the folio will have to fetch it from the page
+	 * cache. That requires locking the folio to handle
+	 * truncate, so any new usage will be blocked until we
+	 * unlock folio after collapse/during rollback.
+	 */
+	if (folio_ref_count(folio) != 2 + folio_nr_pages(folio)) {
+		result = SCAN_PAGE_COUNT;
+		goto out_putback;
+	}
+
+	/*
+	 * At this point, the folio is locked and unmapped. If the PTE
+	 * was dirty, try_to_unmap() has transferred the dirty bit to
+	 * the folio and we must not collapse it into a clean
+	 * file-backed folio.
+	 *
+	 * If the folio is clean here, no one can write it until we
+	 * drop the folio lock. A write through a stale TLB entry came
+	 * from a clean PTE and must fault because the PTE has been
+	 * cleared; the fault path has to take the folio lock before
+	 * installing a writable mapping. Buffered write paths also
+	 * have to take the folio lock before modifying file contents
+	 * without a mapping, typically via write_begin_get_folio().
+	 */
+	if (!state->is_shmem && folio_test_dirty(folio)) {
+		result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+		goto out_putback;
+	}
 	return SCAN_SUCCEED;
+out_putback:
+	folio_putback_lru(folio);
 out_unlock:
 	folio_unlock(folio);
 	folio_put(folio);
@@ -2513,55 +2548,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		xas_lock_irq(&xas);
 		VM_BUG_ON_FOLIO(folio != xa_load(xas.xa, index), folio);
 
-		/*
-		 * We control 2 + nr_pages references to the folio:
-		 *  - we hold a pin on it;
-		 *  - nr_pages reference from page cache;
-		 *  - one from lru_isolate_folio;
-		 * If those are the only references, then any new usage
-		 * of the folio will have to fetch it from the page
-		 * cache. That requires locking the folio to handle
-		 * truncate, so any new usage will be blocked until we
-		 * unlock folio after collapse/during rollback.
-		 */
-		if (folio_ref_count(folio) != 2 + folio_nr_pages(folio)) {
-			result = SCAN_PAGE_COUNT;
-			xas_unlock_irq(&xas);
-			folio_putback_lru(folio);
-			goto out_unlock;
-		}
-
-		/*
-		 * At this point, the folio is locked and unmapped. If the PTE
-		 * was dirty, try_to_unmap() has transferred the dirty bit to
-		 * the folio and we must not collapse it into a clean
-		 * file-backed folio.
-		 *
-		 * If the folio is clean here, no one can write it until we
-		 * drop the folio lock. A write through a stale TLB entry came
-		 * from a clean PTE and must fault because the PTE has been
-		 * cleared; the fault path has to take the folio lock before
-		 * installing a writable mapping. Buffered write paths also
-		 * have to take the folio lock before modifying file contents
-		 * without a mapping, typically via write_begin_get_folio().
-		 */
-		if (!is_shmem && folio_test_dirty(folio)) {
-			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
-			xas_unlock_irq(&xas);
-			folio_putback_lru(folio);
-			goto out_unlock;
-		}
-
 		/*
 		 * Accumulate the folios that are being collapsed.
 		 */
 		list_add_tail(&folio->lru, &pagelist);
 		index += folio_nr_pages(folio);
-		continue;
-out_unlock:
-		folio_unlock(folio);
-		folio_put(folio);
-		goto xa_unlocked;
 	}
 
 xa_locked:
-- 
2.55.0


