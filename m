Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31774C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4686B0093; Mon, 20 Jul 2026 10:29:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 465226B00B8; Mon, 20 Jul 2026 10:29:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A2B06B00B9; Mon, 20 Jul 2026 10:29:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0865C6B0093
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:29:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 71A5A1A0100
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:22 +0000 (UTC)
X-FDA: 85009387764.27.B3E263D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 88BE318000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557760;
	b=19XDcpJgkC6Oub5nn0pcIvlGu/iLvxIxgMeBTihuHLdlTSnOh3e/O1eNm1Nj4Xb+ytvs7s
	N7D90+VtfUIm+wQdKfXThB7xqEkKEsil+WVKLVp/OFU3Jxzf+UG2QpVeN0BAoTqp2I6x7U
	L90roAFUfOAeEPjdY3KKMlk6fOhwV4w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6jw26bfvEtpWwnQSBK7mlilSHgh5pzTE57OWg4AH6io=;
	b=NFXgO0Q6EdmTInQn1NToPcOeDeO+79Wonxv7B3rkAJ1uVlNzuQgQX9i3Wy2QiO17m2+PGP
	NiTbrlOUfuGs3/MunPpA5lArxnpjEWFaBzCu+kL51l2ucT8aSWdZlzXDcxynlnnzpH5sO6
	kyrdqmy+hY0pYBLA2jH12n40WAH1Gfk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5229D79FCB;
	Mon, 20 Jul 2026 14:29:19 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B27D779AA;
	Mon, 20 Jul 2026 14:29:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wC8BD74wXmrKTQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 20 Jul 2026 14:29:18 +0000
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
Subject: [PATCH 2/8] mm/khugepaged: factor out page cache folio reading
Date: Mon, 20 Jul 2026 15:29:07 +0100
Message-ID: <20260720142913.846902-3-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720142913.846902-1-pfalcato@suse.de>
References: <20260720142913.846902-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 88BE318000B
X-Stat-Signature: ege3myx9ymtbsbzriih9w76en9p3sii6
X-Rspam-User: 
X-HE-Tag: 1784557760-877459
X-HE-Meta: U2FsdGVkX18lTs+dnWZ2YJlV9we/FI0msbem0e+wGhzReVNEg0ITEFEEE9nbHUmVymczHSji9TUYWtoPpCw1pk0aq+22ECFX454ztEcQv1Ad71myCZJgv3xjVsxAuyl/DTHXeFle/sduZNE35qCch2tQ4WNZCq1EaxJ0rzBf6pLFoDdYbXdyjZ0gq9R8jFS9Lf9bOC6v81HKbhhCDkmJHmfTfqfWSDfCxv/+amV/AgvREbcEMhQx+j6Uw0lxBTxdc56z6IyMW6Nk5vdSI6tgaGgN2MzJJGrew5xymQhg59KEdB3aARDN+x7D324McIHEtq/N7kAUapnyJ8XQjo/7jGM+zKcEJeOUPIZO+6cHutiBMA0jn3NyAdbAKBS7v/UoAgRq9j1DJEkt6zFvDpZatUZPaDcI8aYGoUKM5rXQW+gMnNx/gv02lwC+3oWm0hnH6NOjgnmerI2uUnCdtYvuX+K2eLBKRsnUT59/xhMMAbG92sPlPuclGI3IvRs0Qarpfw0noC4UIbcbJRPkN1u82xvfr86C+FE4JRFbhJQsLiBr2g3SUP7tMrVE7t0Q3a8fbpKMx/4z7BiydhDvaOT+xa7fq/bHDK/u2i0eZZW9YcrpWggwLiTagLsvWjOVfv7SPvOWAebSuH2pTdzZyzhg4UKSYJKM6/bMXykDYUe53yl9z5UMpWAeGSJ1xmMzEQHC2JAms/k457PeKzfCcFa1i3TDKwKXhdJa4tYLAyR5l5nF7XyU8Wp1CZ5KwZON3Q2sKJNzA80+nS74eTTghdb5SqTb6j3RqAUrrMKkVANtVIL55lcsTcBuHYTYfi4IHK8Tld2w5w2O7cuq7H2+rNfaob5/L9aLqY+Ze0z9QBcFFfrvK5t3LqTVALQtJ+JO9ipS9JdPoYQlvH+VY9y35fFU63Btp5XnLxTIbN/2Y7NWPMqn8KfWF2eBTvpRS1lA2afgs/9X2Vy+Ijubj4F1U/d
 cCP88VZe
 KHxZBedzT1HJ2v37jxeW8jV7lNHUaq3E8XAqgUXs3vvchcfzQrX18MSWWwSSmWrnHCww7Sbr03qH83PyYeklfB820/kJfNwdvzi88aIYETX6BR3z2uhm6p6vvqw8xoDDoDu7q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The two mechanisms (shmem, filemap) are quite similar and only change in
subtleties. There is no need to have two variants. Factor this out into
its own separate function, shared by both paths.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/khugepaged.c | 67 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 44 insertions(+), 23 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d4de507ac001..4cc6917a55c7 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2230,42 +2230,63 @@ struct collapse_file_state {
 	unsigned int is_shmem : 1;
 };
 
+static struct folio *collapse_read_folio(pgoff_t index, struct collapse_file_state *state)
+{
+	const bool may_bring_uptodate = state->is_shmem;
+	struct folio *folio = state->folio;
+
+	if (!folio || xa_is_value(folio) ||
+	   (may_bring_uptodate && !folio_test_uptodate(folio))) {
+		xas_unlock_irq(state->xas);
+		if (state->is_shmem) {
+			/* swap in or instantiate fallocated page */
+			if (shmem_get_folio(state->mapping->host, index, 0,
+					    &folio, SGP_NOALLOC))
+				return NULL;
+		} else {
+			page_cache_sync_readahead(state->mapping, &state->file->f_ra,
+						  state->file, index,
+						  state->end - index);
+			folio = filemap_lock_folio(state->mapping, index);
+			if (IS_ERR(folio))
+				return NULL;
+		}
+	}
+
+	return folio;
+}
+
 static enum scan_result prepare_collapse_file_folio(pgoff_t index, struct collapse_file_state *state)
 {
 	struct address_space *mapping = state->mapping;
 	enum scan_result result = SCAN_SUCCEED;
 	const int is_shmem = state->is_shmem;
-	struct folio *folio = state->folio;
+	struct folio *folio;
+
+	folio = collapse_read_folio(index, state);
+	if (!folio)
+		return SCAN_FAIL;
+	if (folio != state->folio) {
+		/*
+		 * collapse_read_folio() got a new folio. This folio is locked
+		 * and ref'd up. Nothing tricky (dirty, writeback, etc) can
+		 * happen, so bail now. But before that, drain the local LRU
+		 * add batch. Otherwise, it's very possible folio_isolate_lru()
+		 * will not succeed.
+		 */
+		lru_add_drain();
+		goto xa_unlocked;
+	}
 
 	if (is_shmem) {
-		if (xa_is_value(folio) || !folio_test_uptodate(folio)) {
-			xas_unlock_irq(state->xas);
-			/* swap in or instantiate fallocated page */
-			if (shmem_get_folio(mapping->host, index, 0,
-					&folio, SGP_NOALLOC))
-				result = SCAN_FAIL;
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
-		if (!folio || xa_is_value(folio)) {
-			xas_unlock_irq(state->xas);
-			page_cache_sync_readahead(mapping, &state->file->f_ra,
-						  state->file, index,
-						  state->end - index);
-			/* drain lru cache to help folio_isolate_lru() */
-			lru_add_drain();
-			folio = filemap_lock_folio(mapping, index);
-			if (IS_ERR(folio))
-				result = SCAN_FAIL;
-			goto xa_unlocked;
-		} else if (folio_test_dirty(folio)) {
+		if (folio_test_dirty(folio)) {
 			/*
 			 * This page is dirty because it hasn't
 			 * been flushed since first write.
-- 
2.55.0


