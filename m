Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C778B60A2636
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7480E6B05B7; Wed, 11 Nov 2026 12:51:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71F7C6B05B8; Wed, 11 Nov 2026 12:51:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65E326B05B9; Wed, 11 Nov 2026 12:51:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3ADED6B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:51:30 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A43F21A03BF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:51:29 +0000 (UTC)
X-FDA: 85423580298.17.D91C809
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id BCF1014000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:51:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xRMdRlOxbltCEqYlrFTaG1YeHSsYiY9ekiVfHPvc9XQ=;
	b=HQQUI9cyESdT3S9K/U4Vbw9f1CkUjMJpj6Dm55Yvy/jrU/yPrm8HCZARC4SvlegU0GWLl8
	6WZNv1oqif8otlN44+2G/NKRERpyn4Wz501nE80xJpcjlBTNg+5tM9mvhb2Cfy65d8Bik0
	BSvPNP9ScaCi+sc5L6yDSZGuibWNYy0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419487;
	b=CGW2d8d7qxTomjaX2QFAzBUfTTw48gBzxh7T/JffyKcFKdOmdyiNV/PUSrq3S05Jo0d3w8
	6X69xSWpXBoGyWDeeWWUF0gvAjPxy26e3Dej71seq8yMDayIDrvRwkOcY+NSIiUcdky1Jz
	GaC8Qfut/5/zG6TopSR6ZB7x/twix98=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6F7F921E49;
	Wed, 11 Nov 2026 17:51:26 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 687061339F;
	Wed, 11 Nov 2026 17:51:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +SJmCxur9GphXQAAD6G6ig:T3
	(envelope-from <pfalcato@suse.de>); Wed, 11 Nov 2026 17:51:25 +0000
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
Subject: [PATCH v2 2/8] mm/khugepaged: sanitize the folio passed to file folio collapse logic
Date: Wed, 11 Nov 2026 17:51:15 +0000
Message-ID: <20261111175121.1328383-3-pfalcato@suse.de>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261111175121.1328383-1-pfalcato@suse.de>
References: <20261111175121.1328383-1-pfalcato@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BCF1014000A
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 336jp9z31kdwzz6g3i5rmpn58bt7ukcp
X-HE-Tag: 1794419487-362608
X-HE-Meta: U2FsdGVkX19lJkjF4bC/Xa+vrIBgh+VoMyu3cUrqt9zJ5HoONXtkGXysI9M9d5duXXpLNuJJ02Jx6FrLu8eK7/IGwKXxGju5W3gqz1L/8FzlLqRbz14wVphWlCJKBAxiOWczIFMQ5kOHxsaugQ0vpM1gmwWETM6Fea2HiGcXvi7z/Xg2XBEu81qdUfvCeHIE/wfZZ5KbHLX/nFXtskBL5pDLumcNuZ5HR/WNgCrvpxM+pzbBMFmLujehMqWdG0eLqL97OCcHqwG9SsKegkvWclZr4uTMgK0/byrQ9dMY1xI5s8kLJL68agPybDmiVda9aSZh64PLlBfHh3HkRg/Zj8/EIZMFUmt/uy6cx2NGM9Ak0Jd/sgeGZQkevzB4Sy04bBlaNhzECpeW1230u0qRxXCdYQpmB8tO5yO0bHw4psauzq4Dpx+iY0kjBmMqKxNqvtTDs4JjMJZFj1GYmc/N4Iuj9sXcKxHQG3umFFhxvCcqZGtxXEaKGUepA6TRqgnbbBLVYbTO4c7+V0BlXxSabQrC9+HrplAVCx0r3Ygu4NHpeg3ADMkJgDVXvEJx71tPGbm1mJIaNSmSL/01lsEnJ1ZCL0r1JRC4vDfjUhzV/TCb7fWb8YCDuTHhVH9oGLrrcwDKJbPvcfLrLUUwbLjFCZHAkDBKKhbWzcwB45jyHP/uk6DQ4xkD3q9Eh8O5ieifxPVmrQQezk0Y0HTgUsaNyzFH81W//5DUBSs7P5OC98Wdsckvsp/lUAs2O23d2+8wRJRwiFoU1xjhnw64BbNrYMomeleCyefBDSo7wdfeWSgAxlUzDQHLZDOzJVa1z8NCETazxoBKs1G/OYQm8zDmPsoLpZTm4K7KJZJskglQr6T41c0FuC54LQ91VVwqMy5eJBJvP2Xyx5hMf+TY1Yz1trY9iKL8UQBmgyRfWjNh8eWJgRi1QiZ8yqHffZWp85oyFKBRDtv3Y63jmxMNBWc
 OVnq+DOX
 FOZ6rxwDaPhZbnafmopzxSkDN+EspXOeyTeOv+uMyFroT9N77uEjAhnbdfIyknn1FPTWkBdh2TmJzQ1xjroNqDpk4UneCRsUiB5ckIJ1vEW5S+34C+oH0bFXv0YZKuMNZgvB0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

At that point, the folio (which is taken from the i_pages xarray
directly) can assume 3 different kinds of values:

1) NULL. This is the complete absence of value from the xarray.
2) An xa_value. This is generally a shadow entry in the page cache, or a
   swap entry in shmem page cache.
3) A real struct folio*.

This is confusing. Collapse NULL and xa_value into NULL right at the top
of the loop. Collapse logic generally doesn't care whether something is
fully absent, or whether there's some sort of underlying shadow entry.

This simplifies a bit of reading logic in prepare_collapse_file().
No functional change intended.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/khugepaged.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0fe19acf470b..ac148db2a4a0 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2225,6 +2225,19 @@ struct collapse_file_state {
 	bool readahead_done : 1;
 };
 
+/**
+ * real_folio() - Convert a page cache folio * into a real folio *
+ * @folio: struct folio * to convert.
+ *
+ * Return: NULL if the passed folio is invalid (XA value, NULL), otherwise @folio.
+ */
+static inline struct folio *real_folio(struct folio *folio)
+{
+	if (!folio || xa_is_value(folio))
+		return NULL;
+	return folio;
+}
+
 /**
  * prepare_collapse_file_folio() - Prepare the collapsing of a single file folio
  * @index: folio index in the page cache
@@ -2249,7 +2262,7 @@ prepare_collapse_file_folio(pgoff_t index, struct collapse_file_state *state)
 	struct folio *folio = state->folio;
 
 	if (is_shmem) {
-		if (xa_is_value(folio) || !folio_test_uptodate(folio)) {
+		if (!folio || !folio_test_uptodate(folio)) {
 			xas_unlock_irq(state->xas);
 			/* swap in or instantiate fallocated page */
 			if (shmem_get_folio(mapping->host, index, 0,
@@ -2267,7 +2280,7 @@ prepare_collapse_file_folio(pgoff_t index, struct collapse_file_state *state)
 			goto xa_locked;
 		}
 	} else {	/* !is_shmem */
-		if (!folio || xa_is_value(folio)) {
+		if (!folio) {
 			state->do_readahead = !state->readahead_done;
 			result = SCAN_FAIL;
 			goto xa_unlocked;
@@ -2420,8 +2433,12 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			continue;
 		}
 
-		/* At this point folio can be NULL, or a value. */
-		state.folio = folio;
+		/*
+		 * At this point folio can be a value. Make values NULL. The
+		 * value itself isn't interesting here. Collapse only cares
+		 * about the absence of a folio.
+		 */
+		state.folio = real_folio(folio);
 		result = prepare_collapse_file_folio(index, &state);
 		folio = state.folio;
 		if (result != SCAN_SUCCEED)
-- 
2.56.0


