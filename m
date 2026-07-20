Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97B35C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 418706B00B8; Mon, 20 Jul 2026 10:29:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF876B00B9; Mon, 20 Jul 2026 10:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32F2D6B00BA; Mon, 20 Jul 2026 10:29:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CFC536B00B8
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:29:26 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38D1B1201E8
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:26 +0000 (UTC)
X-FDA: 85009387932.18.F42AE0D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3FAA84000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xU3AB7Ke2kal0QGjvP0KsMxx/bowEyuZ24eSIOxf8EY=;
	b=Qc8joLAF9nXO0BJ8FevE8Z/VqLIGaqajmhxqKdJ697IeEZ6yeEtJbC9SXZhuJ4s3rCDs3o
	uvhcZGdA14Sz7zlkioy3m29oLBUBrF3Yh5U7hyyRE1ezW0kNS8tumK4MiX1W+G1EsvBWi2
	AK2mlkMQh1lc9wH8vr+yhnZdim1V6kg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557764;
	b=ryUhDKQ+DK5mcsC9WbfoI6+lMF6eZHBr6XpxGo2zG5KJuofoUEqiDfO6h0+Ejc30JGPm62
	vvlzHmk5oX6tAz0cEU9IiMraXGwzIt7i8MuGdFF2H7pzfi14tAios+Mw8tSToYVFzqs41b
	opNl6uAlcF+GnAPU+inSzuYDYH7rMVk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3368C3E21;
	Mon, 20 Jul 2026 14:29:18 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2D919779AB;
	Mon, 20 Jul 2026 14:29:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4HvYB70wXmrKTQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 20 Jul 2026 14:29:17 +0000
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
Subject: [PATCH 1/8] mm/khugepaged: separate out windy folio logic from collapse_file
Date: Mon, 20 Jul 2026 15:29:06 +0100
Message-ID: <20260720142913.846902-2-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720142913.846902-1-pfalcato@suse.de>
References: <20260720142913.846902-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3FAA84000B
X-Stat-Signature: crfcaacip34p6w4dg8g3ug49hhqx1cqp
X-Rspam-User: 
X-HE-Tag: 1784557764-795814
X-HE-Meta: U2FsdGVkX1/41Kgf0vlEXu4hwY67HquXbo67wYrfp7miwMl7qoCfGUfU8W8APYnPm4r5qhRinTqml7MWle+cDCtd9RMrL22/qKkePYuZeKWI2so0ks1UPI+qwdnStmiTMX4pJ4x2mx2mVrgVUjPZQCZY1ykMV7JTsTYXy3NGgQL0tBuR/13i2Q+N1A9RYycR+OloU5NMy9P9gOZJI+qmUhRVXZqljvbHMa7mEZ8STsGLY1upMGy18G5QKGRwm+FQTbM968U9IQ0SikM/18HGfCotPmxYIX/YLBmUO+cS6jzFJBRSyflw/QfbMcyN4ImKrJPoGOGmdg7iugeosRGeo0ZvWGx0ihvd/nGdKloAA0Z49wrgEluRB5m1o/MRpSMmsnfE3YxEfd46MOUiZBPHgEdBCQ1bGDiRwIac2YX8sV/zG/JPaO69Qss1ADvKK6HrIfHPI1FnkAzwk9ZScFIUTBJONjQu2HK1kzUm3byQB8/3pPWqooKYUDlAav+DKQNMBOxUPGBZshEasXzVlWfhpDNqe8/38HFIhGlVSrot58wq5ocxjTT8lIPLAug9PuPJs0Z+pg2TQIcrxECnDVnKS0ooV6NAmva5pZREDkVKUVpM+jZWrRbJWqeSCfrlqcuo7EXWE4D7Vr5zB8V/CfIdXYiJ8UbrK6rOKe/P0hxVouwSGSuOjOBr14vGkyG5lmtexflWJfHRfg8gdE+jYgPwy3oFf5WaVH+RCFcm/9Rz9T6tIXQ+h8nrtKxoZWDI8iGUxZskgK+MpLgQSr84WtKj/Jn+wcWRkTzmcmnroJAY88NNgc5+Bv30onktDTGs4YAN4kvRfLN0GAMzYQKSH8vBh9KuhxWbig151lRm3/ZjHFLPhat2C1uiZDatKDeK/JHyK9nVhHngRpVSB4xNTN7bDth8W6OHTeseJoje7N8TnUJOffm+2JHo0tzdWZ/fbgy6LTMGlxgdm651ReGFTMM
 mhZQYeE5
 81Bv8MdKv+rcDddzFQAn/ABm8uxG6UkKvF/9mzii5//tq/4aY4hEjPl3MkZCdcMBawUlU1wVabURM+jqQS6Ep4fDqFaMgzBaFsPylZ/9D2qizuc0hHpMZWU/N9ZLV90GUQOOha7dtu1rzlqvvrOdb3+Xru0BpeuTfcQb/2EaMBZWWBnY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Separate out complex folio-related logic from the main collapse_file()
loop, and introduce a new helper struct to help marshal arguments back
and forth.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/khugepaged.c | 189 ++++++++++++++++++++++++++++--------------------
 1 file changed, 112 insertions(+), 77 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 27e8f3077e80..d4de507ac001 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2218,6 +2218,92 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 	i_mmap_unlock_read(mapping);
 }
 
+struct collapse_file_state {
+	/* in-out parameter */
+	struct folio *folio;
+	/* in parameters */
+	struct address_space *mapping;
+	struct file *file;
+	struct xa_state *xas;
+	/* collapse end index */
+	pgoff_t end;
+	unsigned int is_shmem : 1;
+};
+
+static enum scan_result prepare_collapse_file_folio(pgoff_t index, struct collapse_file_state *state)
+{
+	struct address_space *mapping = state->mapping;
+	enum scan_result result = SCAN_SUCCEED;
+	const int is_shmem = state->is_shmem;
+	struct folio *folio = state->folio;
+
+	if (is_shmem) {
+		if (xa_is_value(folio) || !folio_test_uptodate(folio)) {
+			xas_unlock_irq(state->xas);
+			/* swap in or instantiate fallocated page */
+			if (shmem_get_folio(mapping->host, index, 0,
+					&folio, SGP_NOALLOC))
+				result = SCAN_FAIL;
+			/* drain lru cache to help folio_isolate_lru() */
+			lru_add_drain();
+			goto xa_unlocked;
+		} else if (folio_trylock(folio)) {
+			folio_get(folio);
+		} else {
+			result = SCAN_PAGE_LOCK;
+			goto xa_locked;
+		}
+	} else {	/* !is_shmem */
+		if (!folio || xa_is_value(folio)) {
+			xas_unlock_irq(state->xas);
+			page_cache_sync_readahead(mapping, &state->file->f_ra,
+						  state->file, index,
+						  state->end - index);
+			/* drain lru cache to help folio_isolate_lru() */
+			lru_add_drain();
+			folio = filemap_lock_folio(mapping, index);
+			if (IS_ERR(folio))
+				result = SCAN_FAIL;
+			goto xa_unlocked;
+		} else if (folio_test_dirty(folio)) {
+			/*
+			 * This page is dirty because it hasn't
+			 * been flushed since first write.
+			 *
+			 * Trigger async flush for read-only files and
+			 * hope the writeback is done when khugepaged
+			 * revisits this page. Writable files can have
+			 * their folios dirty at any time; blindly
+			 * flushing them would cause undesirable
+			 * system-wide writeback.
+			 *
+			 * This is a one-off situation. We are not
+			 * forcing writeback in loop.
+			 */
+			xas_unlock_irq(state->xas);
+			if (!inode_is_open_for_write(mapping->host))
+				filemap_flush(mapping);
+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+			goto xa_unlocked;
+		} else if (folio_test_writeback(folio)) {
+			xas_unlock_irq(state->xas);
+			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+			goto xa_unlocked;
+		} else if (folio_trylock(folio)) {
+			folio_get(folio);
+		} else {
+			result = SCAN_PAGE_LOCK;
+			goto xa_locked;
+		}
+	}
+
+xa_locked:
+	xas_unlock_irq(state->xas);
+xa_unlocked:
+	state->folio = folio;
+	return result;
+}
+
 /**
  * collapse_file - collapse filemap/tmpfs/shmem pages into huge one.
  *
@@ -2255,6 +2341,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	enum scan_result result = SCAN_SUCCEED;
 	int nr_none = 0;
 	bool is_shmem = shmem_file(file);
+	struct collapse_file_state state = {
+		.is_shmem = is_shmem,
+		.xas = &xas,
+		.mapping = mapping,
+		.file = file,
+		.end = end,
+	};
 
 	/*
 	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
@@ -2298,87 +2391,29 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		folio = xas_load(&xas);
 
 		VM_BUG_ON(index != xas.xa_index);
-		if (is_shmem) {
-			if (!folio) {
-				/*
-				 * Stop if extent has been truncated or
-				 * hole-punched, and is now completely
-				 * empty.
-				 */
-				if (index == start) {
-					if (!xas_next_entry(&xas, end - 1)) {
-						result = SCAN_TRUNCATED;
-						goto xa_locked;
-					}
-				}
-				nr_none++;
-				index++;
-				continue;
-			}
-
-			if (xa_is_value(folio) || !folio_test_uptodate(folio)) {
-				xas_unlock_irq(&xas);
-				/* swap in or instantiate fallocated page */
-				if (shmem_get_folio(mapping->host, index, 0,
-						&folio, SGP_NOALLOC)) {
-					result = SCAN_FAIL;
-					goto xa_unlocked;
-				}
-				/* drain lru cache to help folio_isolate_lru() */
-				lru_add_drain();
-			} else if (folio_trylock(folio)) {
-				folio_get(folio);
-				xas_unlock_irq(&xas);
-			} else {
-				result = SCAN_PAGE_LOCK;
-				goto xa_locked;
-			}
-		} else {	/* !is_shmem */
-			if (!folio || xa_is_value(folio)) {
-				xas_unlock_irq(&xas);
-				page_cache_sync_readahead(mapping, &file->f_ra,
-							  file, index,
-							  end - index);
-				/* drain lru cache to help folio_isolate_lru() */
-				lru_add_drain();
-				folio = filemap_lock_folio(mapping, index);
-				if (IS_ERR(folio)) {
-					result = SCAN_FAIL;
-					goto xa_unlocked;
+		if (is_shmem && !folio) {
+			/*
+			 * Stop if extent has been truncated or
+			 * hole-punched, and is now completely
+			 * empty.
+			 */
+			if (index == start) {
+				if (!xas_next_entry(&xas, end - 1)) {
+					result = SCAN_TRUNCATED;
+					goto xa_locked;
 				}
-			} else if (folio_test_dirty(folio)) {
-				/*
-				 * This page is dirty because it hasn't
-				 * been flushed since first write.
-				 *
-				 * Trigger async flush for read-only files and
-				 * hope the writeback is done when khugepaged
-				 * revisits this page. Writable files can have
-				 * their folios dirty at any time; blindly
-				 * flushing them would cause undesirable
-				 * system-wide writeback.
-				 *
-				 * This is a one-off situation. We are not
-				 * forcing writeback in loop.
-				 */
-				xas_unlock_irq(&xas);
-				if (!inode_is_open_for_write(mapping->host))
-					filemap_flush(mapping);
-				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
-				goto xa_unlocked;
-			} else if (folio_test_writeback(folio)) {
-				xas_unlock_irq(&xas);
-				result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
-				goto xa_unlocked;
-			} else if (folio_trylock(folio)) {
-				folio_get(folio);
-				xas_unlock_irq(&xas);
-			} else {
-				result = SCAN_PAGE_LOCK;
-				goto xa_locked;
 			}
+			nr_none++;
+			index++;
+			continue;
 		}
 
+		/* At this point folio can be NULL, or a value. */
+		state.folio = folio;
+		result = prepare_collapse_file_folio(index, &state);
+		folio = state.folio;
+		if (result != SCAN_SUCCEED)
+			goto xa_unlocked;
 		/*
 		 * The folio must be locked, so we can drop the i_pages lock
 		 * without racing with truncate.
-- 
2.55.0


