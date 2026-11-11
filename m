Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3490B606A88D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 329236B05B9; Wed, 11 Nov 2026 12:51:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B3206B05BA; Wed, 11 Nov 2026 12:51:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A2916B05BB; Wed, 11 Nov 2026 12:51:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB8A06B05B9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:51:31 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5FC82A03A7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:51:31 +0000 (UTC)
X-FDA: 85423580382.20.FDE8A8B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 76DCE40008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:51:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tOYuvTPV5xGOYsXlvOip9uAQksG43BGEcO5SFlSXiQc=;
	b=r/Nsuzz7Xb+RaTCqnlGVAtKfBulymdaWl0pLsvYXtjMY8QT/fYDwapF0yMrKGsuKIsZAs+
	NDe3uKVv00C/vFsTKHQ7cUMH1ZEF2L8Pd1tHNFMUSeJe6ioj72K37ZutUnXgAuJBsaM71Q
	pVM0gnLKlppQNr9N4IFWg9kakCnKqzI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419489;
	b=5J8N212URVSBdh2Liaj55LCjbmUT8xd/p8iJTKcQY0FIot1WvcZf5S0fHtg4b2IMpy2ena
	cRZKRgX9wZwP3pbACNbuujhcKwVMDynSUivmLQN+V63Z22v+xuDNQ6nA8dgKxGBuxXvqyU
	IcYPevfXh53CM2+Yu7sR9T8CLwflUFI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 75E601F45B;
	Wed, 11 Nov 2026 17:51:28 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6F4C21339F;
	Wed, 11 Nov 2026 17:51:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +SJmCxur9GphXQAAD6G6ig:T5
	(envelope-from <pfalcato@suse.de>); Wed, 11 Nov 2026 17:51:27 +0000
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
Subject: [PATCH v2 4/8] mm/khugepaged: factor out and simplify dirty/writeback handling
Date: Wed, 11 Nov 2026 17:51:17 +0000
Message-ID: <20261111175121.1328383-5-pfalcato@suse.de>
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
X-Stat-Signature: dxe4d3j1ptspftbgncc53ku37x3wjw8k
X-Rspamd-Queue-Id: 76DCE40008
X-Rspam-User: 
X-HE-Tag: 1794419489-615004
X-HE-Meta: U2FsdGVkX1+qH/Fn008yjDmW1O7Fb+58v1+P/0gxpHMtxxo8/EUnxUuFUlYg7VgVertLKFWJjCqv2s4xxwP7jsOwbFMPChmlLVDNMKCfl51bZRK14lrsONahbg5LN9dpl/BB30o9/EoKC4aWlLi0kXHdPZOE7WnY4tAoWFhMKgNSsd+uux9fOSxknOAUqutIQP6QrWeCiwOJ7JF1iw8gsOnlECmKdulLym2CWiGgHHDfssrRG4yhZD9E6kiaoJPxd3Xll46iB2qDe3tNlc3/vL+vqWxVvyXoOTVLDCogK1MIPDSVLUYEPXwTtBgAoFNcyiMvHtaU3Lp5RL30pDqEM1q7DdXDoOwXgKZJDZIXEos1BMKhc50AgrvGXYmJi/kuYZNC424q2x7Tr+D1KZaPk3LjiolJu1AVOYLgbAHipwBAYYs4zNln8TMDpdouSMHeJF6hb09oucA4cwTiwOxEJAsgnwu7cVkYO4f7yli94M3kDtBRAOAAy6nVi2wOQ6/TLncfcRMX3oOf/Tbke4q9E0ld+lMec+NhOtNo99sn9S4/jZwADTcP4FEH85QF8uPnsZuhU/hJNxhI76rREoFh1L8RzrNqaqKHH7c4MFTaWT6bTLfC4Zh0GR44w3fMj7hE50D0vW2wxb5y8eT3pYi7U/ILeextqW3lnbh4gtJ/eo/q4iWTQCV3cQleIl7/eyiwPOznoB5BQc6928rmfgBU9gs+DAh+K1svI3BMQbaY5LqU3V3pbGxk7KTcZsG4VXj55xn7GwLQHcHWGdxMp7E538+4SJdTcqEdWqVobDceq4v6tlntEt7KQmZrRu5fuEsd/H8MV3XxNad/lLaUqm7XpIsxR7lSAANvSZWMv/9Olcw22CmxZWYgtnSbzTGB+V73P93cumitmxmGxGUkoVaHAADlIqN4xsdSmw9NHj8u/Eo6EhehcevbmZCVJ17Nz0UIOE7Gmuzs9Lk+/OS7LNj
 PBiljeyd
 BfQMfCgqp/jjodBlzUbpyzzXCGaUMFckFkTH0tH6fnrufV3tfLZnyGkAWt5cm1DHp5YmkLjcOocI6zcW9pVcCkWgxm+cHGPQJwxIJg6TE+q4HvSqN0zLN8yQNLb9x1ZH/jXurHIIcvvUAq35mRri/AUtBJ5ko8FUpala8iD+JCs1ibc4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Dirty/writeback folios can easily share most of the branch. These checks
are still gated under !is_shmem due to shmem not really having issues
with dirty folios.

While here, reflow the comment.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/khugepaged.c | 47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d5647a3ac095..0eee2b6bbe64 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2299,8 +2299,8 @@ prepare_collapse_file_folio(pgoff_t index, struct collapse_file_state *state)
 	struct address_space *mapping = state->mapping;
 	enum scan_result result = SCAN_SUCCEED;
 	const bool is_shmem = state->is_shmem;
+	bool dirty, new = false;
 	struct folio *folio;
-	bool new = false;
 
 	folio = maybe_read_folio(index, state, &new);
 	if (!folio)
@@ -2317,39 +2317,40 @@ prepare_collapse_file_folio(pgoff_t index, struct collapse_file_state *state)
 		goto xa_unlocked;
 	}
 
-	if (is_shmem) {
-		if (folio_trylock(folio)) {
-			folio_get(folio);
-		} else {
-			result = SCAN_PAGE_LOCK;
-			goto xa_locked;
-		}
-	} else {	/* !is_shmem */
-		if (folio_test_dirty(folio)) {
+	if (!is_shmem) {
+		dirty = folio_test_dirty(folio);
+		if (dirty || folio_test_writeback(folio)) {
 			/*
-			 * This page is dirty because it hasn't
-			 * been flushed since first write.
+			 * This folio is either dirty or under writeback.
+			 * khugepaged cannot operate on such folios.
 			 *
-			 * Trigger async flush for read-only files and
-			 * hope the writeback is done when khugepaged
-			 * revisits this page. Writable files can have
-			 * their folios dirty at any time; blindly
-			 * flushing them would cause undesirable
+			 * For dirty folios, trigger async flush for
+			 * read-only files and hope the writeback is done
+			 * when khugepaged revisits this page. Writable
+			 * files can have their folios dirty at any time;
+			 * blindly flushing them would cause undesirable
 			 * system-wide writeback.
 			 *
 			 * This is a one-off situation. We are not
 			 * forcing writeback in loop.
 			 */
 			xas_unlock_irq(state->xas);
-			if (!inode_is_open_for_write(mapping->host))
+			if (dirty && !inode_is_open_for_write(mapping->host))
 				filemap_flush(mapping);
 			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
 			goto xa_unlocked;
-		} else if (folio_test_writeback(folio)) {
-			xas_unlock_irq(state->xas);
-			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
-			goto xa_unlocked;
-		} else if (folio_trylock(folio)) {
+		}
+	}
+
+	if (is_shmem) {
+		if (folio_trylock(folio)) {
+			folio_get(folio);
+		} else {
+			result = SCAN_PAGE_LOCK;
+			goto xa_locked;
+		}
+	} else {	/* !is_shmem */
+		if (folio_trylock(folio)) {
 			folio_get(folio);
 		} else {
 			result = SCAN_PAGE_LOCK;
-- 
2.56.0


