Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 410A8606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=C1ALzjpG;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=m44ZE1oZ;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=C1ALzjpG;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=m44ZE1oZ
Received: by kanga.kvack.org (Postfix)
	id 4B0546B05BB; Wed, 11 Nov 2026 12:51:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 460666B05BC; Wed, 11 Nov 2026 12:51:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4886B05BD; Wed, 11 Nov 2026 12:51:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 080A06B05BB
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:51:33 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8141CA03A0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:51:33 +0000 (UTC)
X-FDA: 85423580466.17.E89FBBB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8C2C84000F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:51:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=C1ALzjpG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=m44ZE1oZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=C1ALzjpG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=m44ZE1oZ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lf6sqlY3+yAB952Y5PD4ErVl0pHq5ivSfG0Vn36FN/4=;
	b=ktwAUYhKvI62FVXfNgiTzoNReJxtc6CSXeYc11TzyLBd48uHyQMnFPBOQJlvbpit54LP9s
	TCxEx2WhdYACFIqv+pI682kURPajpSjxXP6XBZ0ZfwjDqXZDpN/h+QcAJAfQnxI/IHhOvf
	0fdf9QoO0WIjUeX4+EetFsEQyt21VNs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=C1ALzjpG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=m44ZE1oZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=C1ALzjpG;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=m44ZE1oZ;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419491;
	b=yAuTptDrjX/8aE75jXzqJI3Qkwl13ETeL+9QH3oTg2RCum3SNurkfoSJIWB9S5q6STQ78A
	fSQnqbemWdIq/C5E7bGcarKKLitdwOFD92RHJBiSkDn4taWpFyKLJfRS66CRbiSWlBtgND
	DXtfpA9X9k5j+BzuEcjaaLD42+jgZ8s=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8EDAD21E4E;
	Wed, 11 Nov 2026 17:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794419490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lf6sqlY3+yAB952Y5PD4ErVl0pHq5ivSfG0Vn36FN/4=;
	b=C1ALzjpGwF711mMV3rEPudZhADVNmSEPTWLYjqJIwXh+gpdz+01NSo2UuizdXUSsk6lS4h
	eyJMe3uQYg/1OacEVhzTxH8YneXgsdkMJKdlyVJK02tjBxwIwCzF5b0BSgqvV6ZIpH+n6r
	67QpeWLSSFijLxtAQT/cw6MuM7VCp+Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794419490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lf6sqlY3+yAB952Y5PD4ErVl0pHq5ivSfG0Vn36FN/4=;
	b=m44ZE1oZE1IM3Lqk8qPYxIFReIICotQUlw5cNiZDazgquvJ7On9Y+004BAsv7MRUvAJRIj
	coOIWJqIl2xWnLBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794419490; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lf6sqlY3+yAB952Y5PD4ErVl0pHq5ivSfG0Vn36FN/4=;
	b=C1ALzjpGwF711mMV3rEPudZhADVNmSEPTWLYjqJIwXh+gpdz+01NSo2UuizdXUSsk6lS4h
	eyJMe3uQYg/1OacEVhzTxH8YneXgsdkMJKdlyVJK02tjBxwIwCzF5b0BSgqvV6ZIpH+n6r
	67QpeWLSSFijLxtAQT/cw6MuM7VCp+Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794419490;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lf6sqlY3+yAB952Y5PD4ErVl0pHq5ivSfG0Vn36FN/4=;
	b=m44ZE1oZE1IM3Lqk8qPYxIFReIICotQUlw5cNiZDazgquvJ7On9Y+004BAsv7MRUvAJRIj
	coOIWJqIl2xWnLBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 80B541339F;
	Wed, 11 Nov 2026 17:51:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +SJmCxur9GphXQAAD6G6ig:T7
	(envelope-from <pfalcato@suse.de>); Wed, 11 Nov 2026 17:51:29 +0000
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
Subject: [PATCH v2 6/8] mm/khugepaged: hoist isolation into collapse_isolate_folio()
Date: Wed, 11 Nov 2026 17:51:19 +0000
Message-ID: <20261111175121.1328383-7-pfalcato@suse.de>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261111175121.1328383-1-pfalcato@suse.de>
References: <20261111175121.1328383-1-pfalcato@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -15.80
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8C2C84000F
X-Stat-Signature: re1n6bhcw9ikz58tsswc9mp5r1m9bnjw
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794419491-421181
X-HE-Meta: U2FsdGVkX18h3Lf3KHDM+B7FuOabnKqWBE3iqE4Oh/1r0hU3URsusBou9X9cEvf3Mtl1aa2n+pefq95vDh0+pQrR1HtQl20TmqP8SmdcAq5qlRD1FQ9UWBvJvM8qNZyuG25vL85b1udF+fzE///PGePwOwksLFbAra8km3cmQRdvPeHUTr5e9J355r5vgv1WRV3d3FOe7BxSag3Oc6MohyS8CJ4Sy11LD92xV8n0fKBMTKgnT0wVZGbWply00X5n7nlZLFjFTjWoTWd3sqzexxVNqP+GkHLVL6J+thTD4+rmiMqtY+jjFo1REg3wcSAobE9nPAEHRGM4BLRSaAogqlKT1oIHkQdWLttuQgXGO98VAyG3AnJv49AANNCjsZwovMjlDfeJqzYLpLiv80WjGM3icCW8AINAH0jiGlApkUVYy1fBdazC2el5Mq7NIZ/MJJ7NOeJkZmtFoHg7izcTDqrP7ZAugFDlnPPneJTNJ9KRQUgUEuqmBwQ31guZbR4bHotRRbof4gKfu56I4gXXC4MwDTRYFnbSfW8XGSo5buI+0nmanFY3RgML7qc4QBMu/Ug5r8W8P7s9zWaYEWhV/6PZnmTgC01yAr5WqklBExLAzgDzfT6z+eDa8YB9GUFOjheqrk5OtwrotB+MYSU/83laF4HnTGF/jIrnoFmtK50PS2D5lG5wx+iqXSsJMkCDb9PQNuPWvaH237SvoMZiAWD+V4vg3Rveayg7cR4YSAdSW+NwbkfQU1xj6B/ZrKCLmKhUueAwt8XPlu9KfO8+AzTIyGLp+MJogtw96rg9RLkGJo32LcFnUwyTbYsB9JUSb+ntkumIV9EA+UOZ1PvsnvamC3FVi0CgX1YcHFuZWbDqgdsoiK9xEiCBHHoy2P2PdWg3ANawbgmwAnN+4HV+zkPsYes18xTZDsIZuIQlffZJR7eXk5DpbiAHKCjDBgP+G8YYztbOFmsdSIJF3Vz
 t00iGpA3
 QyW11dr6pJywUsb4AMOJE4u5tjQ6UMdvT1Nn+oMVcds5OIwyg/3AzJnGp7yWyZ/kgqj3058ZLIgnJSL6P3CcgaG0myAOoVvnC2+9ppMSm/BFyySGyfG8k2WcTjFTl2YUGFanNWIzp3JnLyzc6tbZ7g3qgPpbOvyhZxP2XgYE3aaRBZhbf6WaWgmEvQbF9G39BgpEAlJmhjhZxEOA2Bxc3ukNlbFyVpgYfQBa8SAmSuDxZ5TPzwqoV779JR+cexEM67VXZ9K9C/rgs08nDyZxB/1sI8QuM+ycmXfHO7cr1dnlel105CV2VwThFsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move unwindy folio isolation logic from the main loop to
collapse_isolate_folio().

As a small side effect, try_to_unmap_flush() is no longer called for
errors prior to try_to_unmap(). This should be fine as there are other
mechanisms in place to flush it before references/locks are dropped.

Aside from that, no functional changes intended.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/khugepaged.c | 118 +++++++++++++++++++++++++++---------------------
 1 file changed, 66 insertions(+), 52 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 236df9be7e27..1e58ae5b3e74 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2354,6 +2354,69 @@ prepare_collapse_file_folio(pgoff_t index, struct collapse_file_state *state)
 	return result;
 }
 
+static enum scan_result collapse_isolate_folio(struct collapse_file_state *state)
+{
+	struct folio *folio = state->folio;
+	enum scan_result result;
+
+	/*
+	 * The folio must be locked, so we can drop the i_pages lock
+	 * without racing with truncate.
+	 */
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+
+	/* make sure the folio is up to date */
+	if (unlikely(!folio_test_uptodate(folio))) {
+		result = SCAN_FAIL;
+		goto out_unlock;
+	}
+
+	/*
+	 * If file was truncated then extended, or hole-punched, before
+	 * we locked the first folio, then a THP might be there already.
+	 * This will be discovered on the first iteration.
+	 */
+	if (is_pmd_order(folio_order(folio))) {
+		result = SCAN_PTE_MAPPED_HUGEPAGE;
+		goto out_unlock;
+	}
+
+	if (folio_mapping(folio) != state->mapping) {
+		result = SCAN_TRUNCATED;
+		goto out_unlock;
+	}
+
+	if (!state->is_shmem && (folio_test_dirty(folio) ||
+				 folio_test_writeback(folio))) {
+		/*
+		 * khugepaged only works on clean file-backed folios,
+		 * so this folio is dirty because it hasn't been flushed
+		 * since first write.
+		 */
+		result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+		goto out_unlock;
+	}
+
+	if (!folio_isolate_lru(folio)) {
+		result = SCAN_DEL_PAGE_LRU;
+		goto out_unlock;
+	}
+
+	if (!filemap_release_folio(folio, GFP_KERNEL)) {
+		result = SCAN_PAGE_HAS_PRIVATE;
+		folio_putback_lru(folio);
+		goto out_unlock;
+	}
+
+	if (folio_mapped(folio))
+		try_to_unmap(folio, TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
+	return SCAN_SUCCEED;
+out_unlock:
+	folio_unlock(folio);
+	folio_put(folio);
+	return result;
+}
+
 /**
  * collapse_file - collapse filemap/tmpfs/shmem pages into huge one.
  *
@@ -2474,61 +2537,12 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		folio = state.folio;
 		if (result != SCAN_SUCCEED)
 			goto xa_unlocked;
-		/*
-		 * The folio must be locked, so we can drop the i_pages lock
-		 * without racing with truncate.
-		 */
-		VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
-
-		/* make sure the folio is up to date */
-		if (unlikely(!folio_test_uptodate(folio))) {
-			result = SCAN_FAIL;
-			goto out_unlock;
-		}
 
-		/*
-		 * If file was truncated then extended, or hole-punched, before
-		 * we locked the first folio, then a THP might be there already.
-		 * This will be discovered on the first iteration.
-		 */
-		if (is_pmd_order(folio_order(folio))) {
-			result = SCAN_PTE_MAPPED_HUGEPAGE;
-			goto out_unlock;
-		}
-
-		if (folio_mapping(folio) != mapping) {
-			result = SCAN_TRUNCATED;
-			goto out_unlock;
-		}
-
-		if (!is_shmem && (folio_test_dirty(folio) ||
-				  folio_test_writeback(folio))) {
-			/*
-			 * khugepaged only works on clean file-backed folios,
-			 * so this folio is dirty because it hasn't been flushed
-			 * since first write.
-			 */
-			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
-			goto out_unlock;
-		}
-
-		if (!folio_isolate_lru(folio)) {
-			result = SCAN_DEL_PAGE_LRU;
-			goto out_unlock;
-		}
-
-		if (!filemap_release_folio(folio, GFP_KERNEL)) {
-			result = SCAN_PAGE_HAS_PRIVATE;
-			folio_putback_lru(folio);
-			goto out_unlock;
-		}
-
-		if (folio_mapped(folio))
-			try_to_unmap(folio,
-					TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
+		result = collapse_isolate_folio(&state);
+		if (result != SCAN_SUCCEED)
+			goto xa_unlocked;
 
 		xas_lock_irq(&xas);
-
 		VM_BUG_ON_FOLIO(folio != xa_load(xas.xa, index), folio);
 
 		/*
-- 
2.56.0


