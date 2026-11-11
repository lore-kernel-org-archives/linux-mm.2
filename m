Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AC4E606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=aVtr62aZ;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EqWUrHka;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=aVtr62aZ;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=EqWUrHka
Received: by kanga.kvack.org (Postfix)
	id E9C7D6B05BA; Wed, 11 Nov 2026 12:51:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E24DF6B05BB; Wed, 11 Nov 2026 12:51:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9EFC6B05BC; Wed, 11 Nov 2026 12:51:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E3926B05BA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:51:33 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2EC1E160378
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:51:33 +0000 (UTC)
X-FDA: 85423580466.21.5F8DB31
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2BB3FA0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:51:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=aVtr62aZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EqWUrHka;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=aVtr62aZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EqWUrHka;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419491;
	b=BrXenNjWluvb5EXdUso4HDkxFo0FUQqEdkJV+nTzBJ2Mw5hdpXGUinObCc5fTsA8SNgZYb
	Waa2bCI5/+j3vOSZrdN5SUEnz+2EYgw/gcrFgIRfuRhVHaNue9wAN4c9yWmMH33bbkc38x
	5+68fAiOoRtVcwIS6lx9kc4oH6Nieyw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=aVtr62aZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EqWUrHka;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=aVtr62aZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EqWUrHka;
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+HiscfN4+DVbmqui1EUJQgaWwTJHFwhJVZ/d6WtcwgA=;
	b=ypTKOnhTSKcxZNLQOJ8L4FFHncu9riOQvYIGyNPPoJkr/ccKUpUFFxRMKEbi8Weh9X6+rx
	H1U/Qf4qMZklHGzzrDwt9C5gbiCUbBvQgK4i2eJbc/a0Q9roTbt/OzT5Nlo8yZWADRCsa8
	KRZLtSbkUylsFQ/S9muft9bjiT7LqqE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 808B91F78E;
	Wed, 11 Nov 2026 17:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794419489; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+HiscfN4+DVbmqui1EUJQgaWwTJHFwhJVZ/d6WtcwgA=;
	b=aVtr62aZ4JKq28xOjAsXbZN9koW/kss+w99l6WB4ET+8EbE2fEEQKgvGu5fjChrsxlk2qn
	QCWhVaXu1GX1xjPDV3AWWJUJeRJaQvsYVsnEFiOYOEc1jgAl6TAT3ozOwUI0wOVzyWMVzQ
	wvNJJwD+71gWFL+3Qumn/sQfkveP/xY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794419489;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+HiscfN4+DVbmqui1EUJQgaWwTJHFwhJVZ/d6WtcwgA=;
	b=EqWUrHka6Q1KNEBxYxIGTZlMYsHy8ZvGlp5vSwkY9LKJrPkEnDZnDW8PfnrY0JShawPGQ4
	LADGpBrtJ4cdcVAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794419489; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+HiscfN4+DVbmqui1EUJQgaWwTJHFwhJVZ/d6WtcwgA=;
	b=aVtr62aZ4JKq28xOjAsXbZN9koW/kss+w99l6WB4ET+8EbE2fEEQKgvGu5fjChrsxlk2qn
	QCWhVaXu1GX1xjPDV3AWWJUJeRJaQvsYVsnEFiOYOEc1jgAl6TAT3ozOwUI0wOVzyWMVzQ
	wvNJJwD+71gWFL+3Qumn/sQfkveP/xY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794419489;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+HiscfN4+DVbmqui1EUJQgaWwTJHFwhJVZ/d6WtcwgA=;
	b=EqWUrHka6Q1KNEBxYxIGTZlMYsHy8ZvGlp5vSwkY9LKJrPkEnDZnDW8PfnrY0JShawPGQ4
	LADGpBrtJ4cdcVAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7542A134F4;
	Wed, 11 Nov 2026 17:51:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +SJmCxur9GphXQAAD6G6ig:T6
	(envelope-from <pfalcato@suse.de>); Wed, 11 Nov 2026 17:51:28 +0000
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
Subject: [PATCH v2 5/8] mm/khugepaged: simplify prepare folio locking and exit paths
Date: Wed, 11 Nov 2026 17:51:18 +0000
Message-ID: <20261111175121.1328383-6-pfalcato@suse.de>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261111175121.1328383-1-pfalcato@suse.de>
References: <20261111175121.1328383-1-pfalcato@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -15.80
X-Spam-Level: 
X-Stat-Signature: 7nhojd7r7y1xnkhyaafn3it5hyparoq1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2BB3FA0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794419491-433500
X-HE-Meta: U2FsdGVkX1+gRXQJfNDyqe38jWW1vszs7ZA1dilZjhkbP8Y9RAevKX4U9LQpm5NeQMPvjq+C90+FpFQti4fnGd63PqqHuhSyJ3jpHuMWi6yFvjyUdVqlF8Pw3XnC82wepihlObZ8A9s6Xa8wqs4sV55ImyZ/+Xek9HW+UmShdNih/4MEUJnEX5FzML6tvxT0dHKPIcTaN66tawbUBDbOoupPf4sQylEM/l0ZvzZ5lGjRw0fA/28dQIKY6HFL+XXcRQiwZZWPcyJ1d39Iok/F99w5QL1NDs/qhg9cTCxENV2FjPBJ3KOrYjKX+jDU2LSUy9zy1KFn57P8OQ9C5UacpC0cVLgva+ED0Zn9hXWcD/fv6smYsYFjla7NAtpS+oPpBMSlJs38oJv0mX4ZFM65jQrd8D50jZRq5oHufwVZMGXt5AS5IS/d58xSbK2DqZXgwLrKYcbjjvL2ValE+JZLPftDSutrHag0iCB1vY4bkC2+fG3lPDxbLNb3HxpLYiDLa7PUBazwH+hLpjy/gHV8prOJ/x7ojVJcFbObBw4QxQjsp8pffum4GR5FY5uQJzBY90ctzaMsrbyNt2jOuQb+Va9uqvVvs01y3M+eltlWy2LQsGuo1RCMhtmkwuAiUwfFeR8+9g0n/UkIsyEhK6iPVxE0Zh5qghd7vCq2lPaVqzcTAEIGGvBgUVUHom8a2md08AnPaDe7/OSSXrCVl15Q6E+OcjZsce2GN/9QVbXjTfbCZIc7fGRi2pkGHgEbYRtJV6LPuUECdpXhD4ogbUQDhV4WzpHXpA0qLO8GyIWT8rDM0upfc3jppswlNj93rQjEqcFrpVNNbFma7MFjCwT82oL9EyI3xWiCjsBuvj1Nb2D8D3OlVNGcOHFG5Zriz6GQwoMkqTOoSrGC2TIge3Q0IHAOdPSBVTbegxIoM3LUhG4YXKcNfYVFBvX0k2iSs6IT+3jf2sSDVr2JfYX9Q7O
 rG5HM7eu
 pATtCdHfdB+ZIhrmQ1PVUCjtRnHPebqbbgqiyJHibjTvc4hkgFwH7octEGNOSgtjscUQ5kJWcZQIlPsiAuxlsWpzCGmtyD++Vp4zH5QBYEJ+dhhUi+EV976XD1X3ermWr+HffQ9QadIhCmyJ35ESE5uYuWIpEhmV19d/4zHYM9hCFhYOSIUIkq2ayiCzsMd1HszMwBKrH8hFhrMQONgBsi5ErVtfbNOhuXIWWRUNwOytQmcvwfT0cpLOTrocKNFasMz+p+EqdfH5uBPo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
 mm/khugepaged.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0eee2b6bbe64..236df9be7e27 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2314,7 +2314,8 @@ prepare_collapse_file_folio(pgoff_t index, struct collapse_file_state *state)
 		 * will not succeed.
 		 */
 		lru_add_drain();
-		goto xa_unlocked;
+		state->folio = folio;
+		return SCAN_SUCCEED;
 	}
 
 	if (!is_shmem) {
@@ -2337,31 +2338,19 @@ prepare_collapse_file_folio(pgoff_t index, struct collapse_file_state *state)
 			xas_unlock_irq(state->xas);
 			if (dirty && !inode_is_open_for_write(mapping->host))
 				filemap_flush(mapping);
-			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
-			goto xa_unlocked;
-		}
-	}
-
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
+			return SCAN_PAGE_DIRTY_OR_WRITEBACK;
 		}
 	}
 
-xa_locked:
+	/*
+	 * Note: trylock + simple folio_get() is safe here due to the i_pages
+	 * lock being held; this excludes truncation happening in parallel.
+	 */
+	if (!folio_trylock(folio))
+		result = SCAN_PAGE_LOCK;
+	else
+		folio_get(folio);
 	xas_unlock_irq(state->xas);
-xa_unlocked:
-	state->folio = folio;
 	return result;
 }
 
-- 
2.56.0


