Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43509C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 885AB6B00BB; Mon, 20 Jul 2026 10:29:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80F336B00BC; Mon, 20 Jul 2026 10:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FEA46B00BD; Mon, 20 Jul 2026 10:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6586B00BB
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:29:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A65BC1201E7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:34 +0000 (UTC)
X-FDA: 85009388268.16.1359B0C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id B6D75160003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ISgXyunc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P4vFvQAE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ISgXyunc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P4vFvQAE;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mtAUlclE6KOqACLOJXzP3lbBnDD0ozmS9uuandpFwC4=;
	b=A6KRshhdMRmb0TeJ9qGGO4G+qcE3QJHuT7gXqJ7Q2aoTtrATBWDXP+uRDO0nxXuLpFTR3p
	fUombUeYYnPrpLJlXqMzzzXi/T/4+2jfFKbo0yUBGl2s+2sR16x9UBbviB0YKcPxfZV2sm
	88xTUiQM5LQhEy8aOe9G55idh9AtSRQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557772;
	b=6yyCBmOxe6Rt0kms/5V0k9aqF+k/JuPVIWAjosjuRqsxXoUdSFEV0fCAQBbE8Qmp2ovHZu
	+eEE3GN9LJKI0An/LwEBAuVyfp1rx5TPmMXfBqzLgIQApdkeZZjv9NjL0UGsKlOTcNiYii
	dRn9/y5GbzeIippTsv5cN1j0ReB6Ivk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ISgXyunc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P4vFvQAE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ISgXyunc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P4vFvQAE;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8451079FCF;
	Mon, 20 Jul 2026 14:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784557761; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mtAUlclE6KOqACLOJXzP3lbBnDD0ozmS9uuandpFwC4=;
	b=ISgXyuncxsOmNKEHpWbgZmlvEcLQ7a+uufeHsKQudQufx67G8VWSVaD2ybnvNXc6BLZdGM
	nvA/dmS03+4HW23nDhogiUsTMuN5AhKbB00uz39J/GLh8ICMv4ozeevk+raa9DCBqoQg2x
	rHHgYWqXCwo0bYskTomMc21Pht3cNK0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784557761;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mtAUlclE6KOqACLOJXzP3lbBnDD0ozmS9uuandpFwC4=;
	b=P4vFvQAEX0x+BYfyrYZe4HJzHZZgHIfdqyAgELWzHgq7047zE2Ff67MCsXxhfv3NKKdZv0
	EYQqZk9cYQb4AFAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784557761; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mtAUlclE6KOqACLOJXzP3lbBnDD0ozmS9uuandpFwC4=;
	b=ISgXyuncxsOmNKEHpWbgZmlvEcLQ7a+uufeHsKQudQufx67G8VWSVaD2ybnvNXc6BLZdGM
	nvA/dmS03+4HW23nDhogiUsTMuN5AhKbB00uz39J/GLh8ICMv4ozeevk+raa9DCBqoQg2x
	rHHgYWqXCwo0bYskTomMc21Pht3cNK0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784557761;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mtAUlclE6KOqACLOJXzP3lbBnDD0ozmS9uuandpFwC4=;
	b=P4vFvQAEX0x+BYfyrYZe4HJzHZZgHIfdqyAgELWzHgq7047zE2Ff67MCsXxhfv3NKKdZv0
	EYQqZk9cYQb4AFAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 80362779AA;
	Mon, 20 Jul 2026 14:29:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id COzlG8AwXmrKTQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 20 Jul 2026 14:29:20 +0000
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
Subject: [PATCH 4/8] mm/khugepaged: simplify prepare folio locking and exit paths
Date: Mon, 20 Jul 2026 15:29:09 +0100
Message-ID: <20260720142913.846902-5-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720142913.846902-1-pfalcato@suse.de>
References: <20260720142913.846902-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B6D75160003
X-Stat-Signature: pztpcfxrnqsgpgsmn4xczydn3jxtjhqg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784557772-521056
X-HE-Meta: U2FsdGVkX19xus5Nm+Au/+IeTPc4Alpn4IFnBoB5KIKbTzkVKoZKpRuhBtNGLIWOlXgcCKyhnFnsrE/CfwM7os+4FJ5UMXere/UL6vs+J/bpkUkTv3/zA1g38bdfgGcbz6SHmfahfGKfzYpH8CPJmPALBeu5forWV3KZMNF+zW3Ku9kP/8i2GHnzCltvAL67NxdDBPnrM76mtNKssApoj4Kj9nr/IuRkrXOHCy9Ac6/i5zyUrch08Q6oTFMab5pKSjYgQhTYl8M9lK2lbPStxO3n7R895wkcM7a+BEoNJNTnNlRmLAw8304QcsKQVs8NNL3MPUwj653cMTYtRh277RTnUTD/TbZoY9lJ0JQZ8SDl1YOgZ77fp9jDlgmrXCJx2HW3TyqnfOMxvJ8ocot7tGKBYLyCIkPQF8HEUPmYkxL+BPHG0Xs30VoaSfHTjkf3JfozkLHXBMCUhmpOYHcXClQmh8Ek2VYqCnOKTIHWP4fjSrPYQC2gzoY8JU1WMB4cnf9EUwlv5PaVwK2oPnACIrnz/mzjcSBOXBSpt4pQmOl9SJpkHE6UDdWiDtiYjEd79eEpsG7Ba7Mg02YVuTegcyOfcCwxIijImgesp04wx6Sth/xHKD37iuPkbZu6gakDtcB/bmCq2GI3jJ0TKsEOTtaWLAnYzSklhRVRWEsv2RsjgI5oJFPqccohJPdg3zs8NFn5JBR90C6BNKtP8ZQFPNV5PXEr7FqKNv8LrPzc5sJokCSLDxdQDAR1e6AEJJJCxQYCsqLk5Xb/VE8ZYGsA5aR5o41UTdw3eely/nVUEVN324IJ4zy2kX98RW62uSAMMW4hhz9G8Cpv9TCzD4V9yPeq8HLa/5DZoJfIxd7GF/OlpMTYXOQgjCnM+QaAsveuNexnC4SBwHtOj61Iart3M/t1nOaR2ra5mlwV6TLr8iqV1XtsKf/a+wkfSYh1Ks5l64e167MYCfbG0P2poqI
 rRan6Vy8
 XHtUD30d9EohT3kpNS5I7UotlSOg34o1wkAAfb5oNK7VcccUfKKLEVQV37Q8g10e5TQjzRQ/z0b8zTf7cBiLZr+jE/Oz/zE268YHyanj4m5cf/6NYZ45f6Tz9iPUJLlziNG7iqBcy/n2iwL7PxpJUe9OIqr0g+wY+VVbI1YKCyGgclbFGDXBvgXqH39zrOtEksejZlFDE+0v3NEnGCCu0q+0NGiJMoDWqI86FbaB8wMF4VbvbrTJNRaraZNMDsFTcwesoNo5YfeMlXuY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_trylock() + folio_get() do the exact same thing on both is_shmem
and !is_shmem paths. Unify them into one path.

At the end of the day, there are two large invariants for the function:
 - xarray lock is not held at exit. Either it was dropped on error, or
   dropped on success/IO.
 - success always means a locked-and-ref'd-up folio.

After this transformation, it's trivial to notice how simple the error
paths are, so do away with the gotos and hoist some code.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/khugepaged.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ed5d23317177..d170b64378e6 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2259,8 +2259,8 @@ static struct folio *collapse_read_folio(pgoff_t index, struct collapse_file_sta
 static enum scan_result prepare_collapse_file_folio(pgoff_t index, struct collapse_file_state *state)
 {
 	struct address_space *mapping = state->mapping;
-	enum scan_result result = SCAN_SUCCEED;
 	const int is_shmem = state->is_shmem;
+	enum scan_result ret = SCAN_SUCCEED;
 	struct folio *folio;
 	bool dirty;
 
@@ -2276,7 +2276,8 @@ static enum scan_result prepare_collapse_file_folio(pgoff_t index, struct collap
 		 * will not succeed.
 		 */
 		lru_add_drain();
-		goto xa_unlocked;
+		state->folio = folio;
+		return SCAN_SUCCEED;
 	}
 
 	if (!is_shmem) {
@@ -2299,32 +2300,21 @@ static enum scan_result prepare_collapse_file_folio(pgoff_t index, struct collap
 			xas_unlock_irq(state->xas);
 			if (dirty && !inode_is_open_for_write(mapping->host))
 				filemap_flush(mapping);
-			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
-			goto xa_unlocked;
+			return SCAN_PAGE_DIRTY_OR_WRITEBACK;
 		}
 	}
 
-	if (is_shmem) {
-		if (folio_trylock(folio)) {
-			folio_get(folio);
-		} else {
-			result = SCAN_PAGE_LOCK;
-			goto xa_locked;
-		}
-	} else {	/* !is_shmem */
-		if (folio_trylock(folio)) {
-			folio_get(folio);
-		} else {
-			result = SCAN_PAGE_LOCK;
-			goto xa_locked;
-		}
-	}
 
-xa_locked:
+	/*
+	 * Note: trylock + simple folio_get() is safe here due to the i_pages
+	 * lock being held; this excludes truncation happening in parallel.
+	 */
+	if (!folio_trylock(folio))
+		ret = SCAN_PAGE_LOCK;
+	else
+		folio_get(folio);
 	xas_unlock_irq(state->xas);
-xa_unlocked:
-	state->folio = folio;
-	return result;
+	return ret;
 }
 
 /**
-- 
2.55.0


