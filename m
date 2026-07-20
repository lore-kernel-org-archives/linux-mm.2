Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BEC6C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:29:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3C186B00B9; Mon, 20 Jul 2026 10:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EECCB6B00BA; Mon, 20 Jul 2026 10:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDBCF6B00BB; Mon, 20 Jul 2026 10:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA61F6B00B9
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:29:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20F1C1C00D0
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:28 +0000 (UTC)
X-FDA: 85009388016.26.A5ED65A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1E83314000C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=r40uyrRo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=y4Jm4JzQ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=r40uyrRo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=y4Jm4JzQ;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tOHlMuSJ0FI7SQpr2VHqCuu+f1bO4v5hqudfd2KAok4=;
	b=3deone1bH+QVwOl3vJ4irYUYwgu5wdo3tWd0vfvGLNTcltHBoN0AkTBKvVsN4DVU3VEZJJ
	zWN4WXSFpjxz91Sie+rkaPuznPuqSqbk1FgGSGMAr7BQTlimyRtNPOihiMuNasjhX0Qe1q
	+LdaV2D+UU1smzOGbiuo7PC5Gy8IC54=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557766;
	b=qI4VqeZVdC2H0ljzU1KYItxwNobBZZrN8cXk6JViTWPyuX9o3IkCKENAoCKiNBx6Cwti3+
	bMprrRLXWHPSMvetSMe4atUb8jPnaRE78/XsuytW9k5yc7EnPRsV67iE4Cb8GqAchwWGgo
	m0+pRVeJ1+2ATGr4f8jax4KMfMj16AI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=r40uyrRo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=y4Jm4JzQ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=r40uyrRo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=y4Jm4JzQ;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 671B679FCD;
	Mon, 20 Jul 2026 14:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784557760; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tOHlMuSJ0FI7SQpr2VHqCuu+f1bO4v5hqudfd2KAok4=;
	b=r40uyrRoiqYJ5w6S9nx2T3R+WF0RHP5QmYJqEeckMXPikZ6+AZKWmnj68J3Y0QIgvXOwEC
	El8mJyYZ8SY6PLgH1k+vUVZK6ay/sG5j1i5QRQ00ZCWo4EnkKnIKKy8tp0snW6byxdiOZN
	Z6uH16Rb/t596hIIkccQu4M9XmD2X+A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784557760;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tOHlMuSJ0FI7SQpr2VHqCuu+f1bO4v5hqudfd2KAok4=;
	b=y4Jm4JzQQMIayljn52lr6HptDGAg2ypunSHsK2VmiluQ0ISRluZh4giM0O4P5f8ldfzdbx
	vGFugCDgeOSecFDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784557760; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tOHlMuSJ0FI7SQpr2VHqCuu+f1bO4v5hqudfd2KAok4=;
	b=r40uyrRoiqYJ5w6S9nx2T3R+WF0RHP5QmYJqEeckMXPikZ6+AZKWmnj68J3Y0QIgvXOwEC
	El8mJyYZ8SY6PLgH1k+vUVZK6ay/sG5j1i5QRQ00ZCWo4EnkKnIKKy8tp0snW6byxdiOZN
	Z6uH16Rb/t596hIIkccQu4M9XmD2X+A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784557760;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tOHlMuSJ0FI7SQpr2VHqCuu+f1bO4v5hqudfd2KAok4=;
	b=y4Jm4JzQQMIayljn52lr6HptDGAg2ypunSHsK2VmiluQ0ISRluZh4giM0O4P5f8ldfzdbx
	vGFugCDgeOSecFDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 69BCE779AA;
	Mon, 20 Jul 2026 14:29:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WFyAFr8wXmrKTQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 20 Jul 2026 14:29:19 +0000
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
Subject: [PATCH 3/8] mm/khugepaged: factor out and simplify dirty/writeback handling
Date: Mon, 20 Jul 2026 15:29:08 +0100
Message-ID: <20260720142913.846902-4-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720142913.846902-1-pfalcato@suse.de>
References: <20260720142913.846902-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1E83314000C
X-Stat-Signature: mnsc5srsqqh6tru5hpbhoesswgoe47do
X-Rspam-User: 
X-HE-Tag: 1784557765-254369
X-HE-Meta: U2FsdGVkX1+ltCP9G+ODUJ3HOhb6/k+giG1pQtpy5j2BTZtqtuPriFYhwNiwX5HaKW4TTDH0u54zB15/K1hJQAmxo3TZ4WyIYpOClOTJL5KH+KZDO8Fq0cPZoiUzx3FrDMNMyQUoKs9DGBaQQbe6rbsKKyoHTDAS1tSBfN0Xksu/CjpO4ReSZI3usWM0p+Tn6t5D1md3nz/0IWn2N+Wn0pgUwd607/O3zhxv8YEvpUDyVAJDfzoX7W6n+Bo8qLZTNZ5ncvo5vHQXP0S+o+JyhDFqLGgIToZRS9k2U3p+qZOXQfo4c4CEyUSPxg3U6z+CrkUM0etgGl6WLQd24ZZAi7qEbZins7F7l1ZXHoQRynH+82b2VOqdQ7dvpZSOHWJdvml2ZLZIiAS/bLXQc4XuvQ3e6nEL8h9V8ewxMiiv7kt+KNzKKGED/NOxnifYMlaAfjyUQB7CSgnALtcK73ZT4VDWFxfkNui1xq10mGWnVVxoA9eV3Uput03ZTgsmFRcTABEkL/PrqabxtEqbWOmY5MsRLG0hrce/EgDqT3Hd1wCh3RBJprdR6Wwa53bVA3NMXDWwlZBAiIQ7PznMNPvcbqWggHo6VxM2qlZIM9srO8JnSSmG0ypRPN6j+fh+x9Z/FENUoKgQrfbK4sKsYLz8DSCNJ7AW9TCLtfpWsYsdRiGbcbMRF6+60GEV9JRASxQDFyq62+qDh1wK1nmfoUVCfHQyTrQDii7S1iura/wOi4kjBaFXRXnHsiXhGHmwyvYHVv6f9T/50UZAu8bouYjXiCRLBSkWgNgrLuMCodVVFJ7FIkYIBWgtUK7qcScruGi1TB5KGRy2+bHJf0smQGcBmMX4Y1p1ySRfB6oIdA6/cU1tLjksPWy9kNwe3FwW1ymv5aCP8vaxL1/hIS4PChUdN8Di9Ln2Ou7KkztlQ5gMA2EGhsDYUzv9vYsirYA6PwkuXm1heseUEB7cADM/29L
 MyNUyT2j
 S17wS200AtvoUm1Q0pyDRxiX2cQtFgokXUlCtmnmdPu0wRdM5/lcbryJ3rNkIAyBrjvd+rVTc3E3lhim50t4YlSOohNav7SWRnpF7hhrZDC15bH1MLnA3M/P2s0D0jQVKANwD1PTt8Mg3N8tTDM8cFNjX4A9ecT8uTfcNwoaB1s4hvfl9zeRSPuy+zOKnbAwuTqjh64jHQn7uUJ679vibEmo/7oqCtIaeb0D0r8nNytCgPC/y818R8UxxpB5Q7lVTqACjQHMMKStDrMo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dirty/writeback folios can easily share most of the branch. These checks
are still gated under !is_shmem due to shmem not really having issues
with dirty folios.

While here, reflow the comment.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/khugepaged.c | 46 ++++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4cc6917a55c7..ed5d23317177 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2262,6 +2262,7 @@ static enum scan_result prepare_collapse_file_folio(pgoff_t index, struct collap
 	enum scan_result result = SCAN_SUCCEED;
 	const int is_shmem = state->is_shmem;
 	struct folio *folio;
+	bool dirty;
 
 	folio = collapse_read_folio(index, state);
 	if (!folio)
@@ -2278,39 +2279,40 @@ static enum scan_result prepare_collapse_file_folio(pgoff_t index, struct collap
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
2.55.0


