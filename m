Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78751606A8BE
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FDD16B05B6; Wed, 11 Nov 2026 12:51:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28BD36B05B9; Wed, 11 Nov 2026 12:51:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12D176B05B7; Wed, 11 Nov 2026 12:51:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBC886B05B6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:51:28 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7106CA7D82
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:51:28 +0000 (UTC)
X-FDA: 85423580256.03.2D9ED9A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 74ACD80007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:51:26 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419486;
	b=a2OVeWWmjukf2x47ISwiQKorgJnCskH6wt4KVxf1M++ReJGQbybn7UX/MQ7t6ehZGw7E4B
	2brYyHsLTEhjmBYiu3y0SxPavVPACQvMOlv0/MXQMorZ0+13wq6hp3gk3D4zHfZzXbCzpc
	Zk5AAEfagxeqaz/98hz+qX4P56EYy0c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wL2QDiXgYZ0Yn6yfW/NEQwRS6ba4jqEjyh6K7k8Gtdc=;
	b=BsKcnpDCGySIVRLRpk2uB3vo9alqwFVx9EI/9GFTUhbuPJv6Mshj0OTbYVJ2ZoJVxTyt68
	iL8A7TlSZ0GZDRJrg6TPFsHUaAYNusKpK/uUAXJRkY4lH/aT87PY7n3yhJK/0KGM3E3V5p
	nT4c2lXbOGK8YwDpDmMXs3nnOGHAHbI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 69D7F1F458;
	Wed, 11 Nov 2026 17:51:25 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 62A06134F4;
	Wed, 11 Nov 2026 17:51:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +SJmCxur9GphXQAAD6G6ig:T2
	(envelope-from <pfalcato@suse.de>); Wed, 11 Nov 2026 17:51:24 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/8] mm/khugepaged: separate out windy folio logic from collapse_file
Date: Wed, 11 Nov 2026 17:51:14 +0000
Message-ID: <20261111175121.1328383-2-pfalcato@suse.de>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261111175121.1328383-1-pfalcato@suse.de>
References: <20261111175121.1328383-1-pfalcato@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Level: 
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: 74ACD80007
X-Rspamd-Server: rspam12
X-Stat-Signature: msohmk3d75mn48bcijy1hx1ehxk4sw6s
X-Rspam-User:
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794419486-450896
X-HE-Meta: U2FsdGVkX1+6ZXaGJ5AAnIZZ3nqXb4f/8KRawjw6bwf8PudBW28+r8dfEsHoaMDHaBnvvPC0H3VqY9mOtC5ore/Fy478w4CXGcC16JOlunIehGRfsXT5kQOxe+liH3abg9QjPMpvR4ZsgXTYRhdb9P1U46vFAl0WZso3q36vPJRamm0iAm81juZahgq7aFVFhIakO3wpPOEE/kfOjqrC6cS5rwIZRw0HkBXK2n70Zgt6lTttmCpGyW7KC8yeLtdsxnNwM+egQb6+x2hj9VPkseNF35+GOptvSYBzptz4CFqK5N2a3QQoxlq0lmcK2vAZRwgfYzRltIvWQlY8EcbO7mG8uSlhkBn2xVOGFzSIldHZ5smp2w4cralF87H5YmPqmo9JtbmWXPmeGuKXlYtJLUNbsnAJeE3ZoxBYm1suf+OPdhqKj0QZRC4918MbsDlUxVDWQV0zVAcACaoq7H5DZrzWoV3hxL0gmWAD8SxM8/MdPsc0TU3ZK3X8OgZdWp2m6fyxU72PiQRiBxLJjweF+hIQ1Jl0WDxpB8OILHGL22/U7LwxyVPgAkiL9PcHnx/XRYI2Q1agFf8667BNeoeFcs0YtKn7Y1yjRqLfuHiXNdZV3uatreTGfHfLGGMufaLh7EX9ljjpN10O6HwiQEPeioDh76ArY9odbZRLEEC5Opg/6aRAU2C/wwCkWMjK9JCzeoX2FZyRRbCxZrMbndz6Hu35+twl3FsJFAFcFp1ClqdGz56kRjP6zBRPkC6NCQyd7RsSLn0s/Xi5DeyBR+XX7lvz89Cd2AQ+eKLwAIPm5aefjBMWNIU9SUhR88BsPE8PuZJx+tCOjlMIvQbtaN/aoVuiwiVq39Yfml++aZJZPV5UAR6Oovt4LufugCySvjEZvnzUzB5RX2wYExe6KbutL52Xr7USz8QBajLoTZUfrvrfPVjgf/qM0SGLBBt9tzKYw8HuDFjtQXSWFlHJtKX
 SOayVvad
 Cs+4JAom5pMTl5ttMacOYCvugDlLq6Y2+Wjc3iurVFISYShYamMYKud8ziK+4VwT3DGTNnrBsl4K1qd3i7vo1iuZ+h4wTMj5c0jKXbi017UBF1dXiDy70GwZIWaRMxfmgkb1+TctrovgFdMk/O6XzkcNR+zj32lZpf30nuDtmqWq9i2dH0gRDzt5HF9BGr7P+aoxtH8IumLCMmpvNa64P2O7L+HjkL+pO9WFZ+Ko71vNX+nI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Separate out complex folio-related logic from the main collapse_file()
loop, and introduce a new helper struct to help marshal arguments back
and forth.

No functional change intended.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/khugepaged.c | 202 ++++++++++++++++++++++++++++++------------------
 1 file changed, 128 insertions(+), 74 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 24eb8281ea3c..0fe19acf470b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2211,6 +2211,105 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 	i_mmap_unlock_read(mapping);
 }
 
+struct collapse_file_state {
+	/* Inputs */
+	struct address_space *mapping;
+	struct file *file;
+	struct xa_state *xas;
+	/* folio is in-out; preparing might modify it */
+	struct folio *folio;
+	/* collapse end index */
+	const pgoff_t end;
+	const bool is_shmem : 1;
+	bool do_readahead : 1;
+	bool readahead_done : 1;
+};
+
+/**
+ * prepare_collapse_file_folio() - Prepare the collapsing of a single file folio
+ * @index: folio index in the page cache
+ * @state: helper struct of state being passed back and forth.
+ *
+ * prepare_collapse_file_folio() helps prepare the THP collapsing of file folios
+ * (both shmem and !shmem), including the reading of folios, initial tests for
+ * dirty/writeback, locking, etc.
+ *
+ * Context: Expects @state->mapping->i_pages.xa_lock to be held. Releases the same xa_lock.
+ *          On success, returns a refcounted and locked folio in @state->folio (that may
+ *          not be the same that was passed in).
+ *          If readahead needs to be (and can be) done, sets state->do_readahead.
+ * Return: Appropriate scan_result value (on success, SCAN_SUCCEED).
+ */
+static enum scan_result
+prepare_collapse_file_folio(pgoff_t index, struct collapse_file_state *state)
+{
+	struct address_space *mapping = state->mapping;
+	enum scan_result result = SCAN_SUCCEED;
+	const bool is_shmem = state->is_shmem;
+	struct folio *folio = state->folio;
+
+	if (is_shmem) {
+		if (xa_is_value(folio) || !folio_test_uptodate(folio)) {
+			xas_unlock_irq(state->xas);
+			/* swap in or instantiate fallocated page */
+			if (shmem_get_folio(mapping->host, index, 0,
+					&folio, SGP_NOALLOC)) {
+				result = SCAN_FAIL;
+				goto xa_unlocked;
+			}
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
+			state->do_readahead = !state->readahead_done;
+			result = SCAN_FAIL;
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
@@ -2249,8 +2348,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
 	enum scan_result result = SCAN_SUCCEED;
 	int nr_none = 0;
-	bool do_readahead = false;
-	bool readahead_done = false;
+	struct collapse_file_state state = {
+		.is_shmem = is_shmem,
+		.xas = &xas,
+		.mapping = mapping,
+		.file = file,
+		.end = end,
+	};
 
 	/*
 	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
@@ -2270,7 +2374,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 
 retry:
 	result = SCAN_SUCCEED;
-	do_readahead = false;
+	state.do_readahead = false;
 	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
 	__folio_set_locked(new_folio);
 	if (is_shmem)
@@ -2299,79 +2403,29 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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
-				do_readahead = !readahead_done;
-				result = SCAN_FAIL;
-				goto xa_locked;
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
@@ -2667,7 +2721,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	folio_unlock(new_folio);
 
 	/* Readahead may take invalidate_lock; source folios are unlocked. */
-	if (do_readahead) {
+	if (state.do_readahead) {
 		for (index = start; index < end;) {
 			folio = filemap_lock_folio(mapping, index);
 			if (IS_ERR(folio)) {
@@ -2685,7 +2739,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		}
 		/* Drain the local LRU batch before retrying isolation. */
 		lru_add_drain();
-		readahead_done = true;
+		state.readahead_done = true;
 		goto retry;
 	}
 out_put:
-- 
2.56.0


