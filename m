Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1731C606A88B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C9A96B05B8; Wed, 11 Nov 2026 12:51:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17AC66B05B9; Wed, 11 Nov 2026 12:51:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B7AB6B05BA; Wed, 11 Nov 2026 12:51:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0B6E6B05B8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:51:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E10C1C362B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:51:30 +0000 (UTC)
X-FDA: 85423580340.22.7E5521B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf15.hostedemail.com (Postfix) with ESMTP id 82BFBA0002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:51:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kEj5fM36biU8ATX3Hs0Bnu0HMNxG5HBdQhLfnJwgrB8=;
	b=DalT/Uyhi5WMPXQe2fKt2/o7PGBbzqT9BhABaEP6Y92LcGnG/nWURQYEIo6zulnu+lPE9z
	d6Y5o7d82TBsazY7k3hUuLJoV3+5nj9d6hSDV1Vy0kloERullbCWjM8cEC6YV+1WTPL15W
	XMt7HjRw8f8Ui+wHIbgTUnxe0sKhbC8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419488;
	b=uYMJsOuC5o3Th7p3WUZrSRGbHDwmd0gUCgsaljL0LlJzH/LLE6XnBcLv0YMfbUWBorz9ec
	BfXop78n6K5slece+ZOU0CVdiOZLFDxBHGvFjcmKBJ/KzI0/5CHnkt9myC4JK3DfUZ4Mly
	6QietZy/D4MY6PoSazKYA00C3E5lOdI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7257321E4B;
	Wed, 11 Nov 2026 17:51:27 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6BBF5134F4;
	Wed, 11 Nov 2026 17:51:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +SJmCxur9GphXQAAD6G6ig:T4
	(envelope-from <pfalcato@suse.de>); Wed, 11 Nov 2026 17:51:26 +0000
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
Subject: [PATCH v2 3/8] mm/khugepaged: factor out page cache folio reading
Date: Wed, 11 Nov 2026 17:51:16 +0000
Message-ID: <20261111175121.1328383-4-pfalcato@suse.de>
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
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: d4kgnukgf579dxhaiupeawgyc4j4xexx
X-Rspamd-Queue-Id: 82BFBA0002
X-Rspam-User: 
X-HE-Tag: 1794419488-509901
X-HE-Meta: U2FsdGVkX19u2Yzd/Gv9Rp84KC6a/CC70celWjYlG//BQ1npBnnPvnvtuqaVP6qwvuPtsmBpOgjhqyNTkBwAt4X8TrEgJes0y12ULeEj1Y8tptVVvydIqU++wBvSqYymQBiqQ1U7mNUs54IWlrh/NK5v086W6ArLO0G6buYYlbPPP3whfxGdtWJAX0GfBQG+xW37ytzyQbEUF2k+z4aKMHtvXiviGlRuCj9/e158aT/Yjab+QYXT1z5BaEkGwQ/ciSbLDzyQWHioGbRif5gHOtp0PXzzs2Z+ZqL/ME3X0kSDChG7opAQUiZzALAWL6+D6ehQvpFL6P6Dgx3AnW8v+fdBu0XEG6mIdJjgToAS+WkKwZGynDRAW3fQAquI82BY7mGP9G7sproP718I26JVONUu41HYfS8Hxjv/Sa2Qq0lPFBFEJ4QaFN0jHpILq4QAygO5krqZh3WeBD4kNpWjw4BYqevEIOZA9WThGGOxpI+QayJmC8iIHjFlr9GMVC7y6byr0kkB6HlBCPKidNAaRcUiL2jSG+PCplltiscbvxQ7BWj5cJUXGjscge026YkKGfVUytBmrBKXDJSwuPNkN0kRrF2u2yvzvF3E07m+hoVCgI7upiI6T/lBMhIdmlXWCBiRnXbsMK3X6D2LpmKyMASHIVwBiuyobt6ot+hlxPayvFLVZo11/UqWcpQzmLIoqPs95ZpO1f1/VYVebERClZnN1fx4I1uZkvt7M/s6HgesMiaGgSA4OsSSX8i3ztp9M8ohc1kGiWim/iSrpcgV0wtu6I0nVklfqq5rSfJPKTYt83zTrc24abD4XfEkZ7QwGujbvDREa+5pi5/+ZEWQUt64PkcYJTvj5phAj9QUFJnvsnDZfo3F/xQ6OU2d00KXjyUTIrpLS03Tf4gYxeqwYiGq4oBqSftMxeu7Du4qkdDvY0NBcrhbsJNp6kRkloyLW7rzu25fNd/n822E7JY
 kN8ogE+j
 bKCSWnszdVKef0OCyaPjK+zJbns0grjbFexARgMzLA+sK3dQKKhGHgS7FPJZAUinbnQ31BHkGm9HrCgDbMXpRkw9Rujm7ku/a6ii2guBPMX1hlBI/v1l1xoxfA6W6PraHI5k18uRFjX9OD0iDIBHGwCY+QCMKRkTF1ywIWruORyGbRxk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The two reading mechanisms (shmem, filemap) have similar purposes but
vary subtly. There is no need to have two variants.

Factor out the do_readahead toggling (for regular files) and
shmem_get_folio (for shmem) into its own separate function,
maybe_read_folio(), shared by both paths.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/khugepaged.c | 77 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 59 insertions(+), 18 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ac148db2a4a0..d5647a3ac095 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2238,6 +2238,46 @@ static inline struct folio *real_folio(struct folio *folio)
 	return folio;
 }
 
+/**
+ * maybe_read_folio() - Ensure a folio is uptodate
+ * @index: folio index in the page cache
+ * @state: collapse_file state helper struct
+ * @new: if a new folio is returned, *new = true.
+ *
+ * maybe_read_folio() ensures a folio is uptodate and, if not, either reads it
+ * in synchronously (for shmem), or schedules readahead (for after the collapse
+ * logic untangles itself from all the folio locks it's holding).
+ *
+ * Context: Expects @state->mapping->i_pages.xa_lock to be held. Releases that
+ * same lock on error, or if *@new = true.
+ * Return: Valid folio (locked and uptodate iff *@new), or NULL on error.
+ */
+static struct folio *
+maybe_read_folio(pgoff_t index, struct collapse_file_state *state, bool *new)
+{
+	struct folio *folio = real_folio(state->folio);
+	const bool may_bring_uptodate = state->is_shmem;
+
+	/* Perfectly cromulent, uptodate folio. Proceed. */
+	if (folio && (!may_bring_uptodate || folio_test_uptodate(folio)))
+		return folio;
+
+	/* We're either returning NULL, or starting IO. Drop the lock now. */
+	xas_unlock_irq(state->xas);
+	if (!state->is_shmem) {
+		/* Folio is missing? Let's start readahead, if we haven't already. */
+		state->do_readahead = !state->readahead_done;
+		return NULL;
+	}
+
+	*new = true;
+	/* swap in or instantiate fallocated page */
+	if (shmem_get_folio(state->mapping->host, index, 0,
+				 &folio, SGP_NOALLOC))
+		return NULL;
+	return folio;
+}
+
 /**
  * prepare_collapse_file_folio() - Prepare the collapsing of a single file folio
  * @index: folio index in the page cache
@@ -2259,32 +2299,33 @@ prepare_collapse_file_folio(pgoff_t index, struct collapse_file_state *state)
 	struct address_space *mapping = state->mapping;
 	enum scan_result result = SCAN_SUCCEED;
 	const bool is_shmem = state->is_shmem;
-	struct folio *folio = state->folio;
+	struct folio *folio;
+	bool new = false;
+
+	folio = maybe_read_folio(index, state, &new);
+	if (!folio)
+		return SCAN_FAIL;
+	if (new) {
+		/*
+		 * maybe_read_folio() got a new folio. This folio is locked
+		 * and ref'd up. Nothing tricky (dirty, writeback, etc) is likely to
+		 * have happened, so bail now. But before that, drain the local LRU
+		 * add batch. Otherwise, it's very possible folio_isolate_lru()
+		 * will not succeed.
+		 */
+		lru_add_drain();
+		goto xa_unlocked;
+	}
 
 	if (is_shmem) {
-		if (!folio || !folio_test_uptodate(folio)) {
-			xas_unlock_irq(state->xas);
-			/* swap in or instantiate fallocated page */
-			if (shmem_get_folio(mapping->host, index, 0,
-					&folio, SGP_NOALLOC)) {
-				result = SCAN_FAIL;
-				goto xa_unlocked;
-			}
-			/* drain lru cache to help folio_isolate_lru() */
-			lru_add_drain();
-			goto xa_unlocked;
-		} else if (folio_trylock(folio)) {
+		if (folio_trylock(folio)) {
 			folio_get(folio);
 		} else {
 			result = SCAN_PAGE_LOCK;
 			goto xa_locked;
 		}
 	} else {	/* !is_shmem */
-		if (!folio) {
-			state->do_readahead = !state->readahead_done;
-			result = SCAN_FAIL;
-			goto xa_unlocked;
-		} else if (folio_test_dirty(folio)) {
+		if (folio_test_dirty(folio)) {
 			/*
 			 * This page is dirty because it hasn't
 			 * been flushed since first write.
-- 
2.56.0


