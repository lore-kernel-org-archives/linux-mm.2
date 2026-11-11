Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2885606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=0up1x29w;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=P5RqRwxq;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=0up1x29w;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=P5RqRwxq
Received: by kanga.kvack.org (Postfix)
	id 636F56B05BC; Wed, 11 Nov 2026 12:51:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E2E6B05BD; Wed, 11 Nov 2026 12:51:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D70E6B05BE; Wed, 11 Nov 2026 12:51:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A0F26B05BC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:51:35 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B375F1A039D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:51:34 +0000 (UTC)
X-FDA: 85423580508.04.62BE7C8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id BAFDAC0004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:51:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0up1x29w;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P5RqRwxq;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0up1x29w;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P5RqRwxq;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794419492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nYqyrDunD/XWdDgSUSWZHVidq8sUw+omObbXg7Rq1Gk=;
	b=7ZQiKQb9FIn/RDzbry1lGwgdvykdreDriLeLMbD2K0LOXYVdiWCDStkWhIaZs7PLB1IBcn
	bjQhah5MVd5bvD2m2eG6mR4JR29wbXAXmG+gG1RtBl/VcHgJ5cgqcTO6eekApGNDA+V5n7
	Jd694Ip1CYdaJ3eugAPSxjh8X+R2Xc8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0up1x29w;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P5RqRwxq;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0up1x29w;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P5RqRwxq;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794419492;
	b=utfoDxyS65LzE4s6/xELXKpT7qvmHa6mAXX9fTOgzIeYIHLTI4hYDXfslUONPoRZFA3NtH
	5QmMnIuQ0lwUkLOaeC2VqptcVFVIC2W6VpTXoKXzOVIXeOxfD1ZbDJQngDatYMuGkzm7Wk
	YNMX6JCk/rvMJSPRuGaYaEJO6XFivEk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9AF6E1F458;
	Wed, 11 Nov 2026 17:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794419491; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nYqyrDunD/XWdDgSUSWZHVidq8sUw+omObbXg7Rq1Gk=;
	b=0up1x29wREGV/og/O6xlhVvTMl2hXZjCiKGexinb33873S6TYitZMXkYrm//2igUo1OOYu
	9CW22/lWQ9aGtTCMCayQ3y8g1Y+gcfIrLjBBEaRWRqHsQZwqTNNGJHVcMJ4hj+KohDoC2t
	6YNqlM/CICcx6JXt41GntWM7N+jWY6k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794419491;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nYqyrDunD/XWdDgSUSWZHVidq8sUw+omObbXg7Rq1Gk=;
	b=P5RqRwxqYpjdMocB9UkI9SiPCQz79pvmBCthmhM1qd/lLsieA7RV0nY2P3uAo+aTzF/zWl
	AIsOcvPO4covwFBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794419491; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nYqyrDunD/XWdDgSUSWZHVidq8sUw+omObbXg7Rq1Gk=;
	b=0up1x29wREGV/og/O6xlhVvTMl2hXZjCiKGexinb33873S6TYitZMXkYrm//2igUo1OOYu
	9CW22/lWQ9aGtTCMCayQ3y8g1Y+gcfIrLjBBEaRWRqHsQZwqTNNGJHVcMJ4hj+KohDoC2t
	6YNqlM/CICcx6JXt41GntWM7N+jWY6k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794419491;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nYqyrDunD/XWdDgSUSWZHVidq8sUw+omObbXg7Rq1Gk=;
	b=P5RqRwxqYpjdMocB9UkI9SiPCQz79pvmBCthmhM1qd/lLsieA7RV0nY2P3uAo+aTzF/zWl
	AIsOcvPO4covwFBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8D10E134F4;
	Wed, 11 Nov 2026 17:51:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +SJmCxur9GphXQAAD6G6ig:T8
	(envelope-from <pfalcato@suse.de>); Wed, 11 Nov 2026 17:51:30 +0000
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
Subject: [PATCH v2 7/8] mm/khugepaged: hoist more code into collapse_isolate_folio()
Date: Wed, 11 Nov 2026 17:51:20 +0000
Message-ID: <20261111175121.1328383-8-pfalcato@suse.de>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261111175121.1328383-1-pfalcato@suse.de>
References: <20261111175121.1328383-1-pfalcato@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Score: -15.80
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BAFDAC0004
X-Stat-Signature: rdsqmuk1fjc7qn45r7yq7dfjnpewcpgw
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794419492-478011
X-HE-Meta: U2FsdGVkX19LTOxMzuS8Z6WidnvQpBiz07anNAGzphGw5xKxt+fspk7ue1wyK1NiqNI2O6tU7k95LJKJUdGeOf762X8sWt86l4Zir+RIkMkMvjtdKdmiNX8S4eoH2wqK4Y0YqXijL4MpuIi1T55zzc855ZUi4MUiovKSysxDFKcWikkb5FtnU/rFBEapsIVM0khrZ6gpZMfmQF1iMMslLtwRyEx8ovWaJ+fb2g2eHHXq2gG+8ETTJU4wfRdZC2XuSfjBXxd52chxNf//WJsYtT2w6x8eoSb51l5EndPmPHgS51cIpWov/mcBDTi1phBffhhk6mjAvqVsrY/Xp8JvsW/clGev2FH4Mut2s8JbUxBugUtv/lhn4CGVgELSyIl2tY3FxoZbRbeYxquTzloZ03VlNrugsha6DkMJHP/Fi+/JrORnRHwBnlgiihIFiaVQwIEESA83rKtx010vyJN53/ZdJxTEPSBMFLAA7cBlNZdaLM8INuJsHE0FzGmKx8tTTIk7gYJxh0RD23+aMxPCZgRfVFUj3SpasYlNJKQi7xEQVVJWfIjQz/98AEP16cpPHGQ32Lpdm/s4aT5IK9PPfwOJZty9HpfRQqDMx2B2+AplFtFyIBculY30Xk5H4P100M6oRy5G2oiGvHhSEIarz9RpI1Kw8zX2VzT9VfhKnZ4ZBiDqtCKSqxSDS0q8yN1npZ/fTDHfUD8G7Z+5P8V+r8o0LTNclCYgpRscVXDwWZ+5BKuZiYJ0hMYJVJ4F6qRBqUScTTDcalIHvjD2U+u3RRv3+JbKKY8I45sRaWbHvLX8dz3TCUqlWw5xsYVqDK6emVjojFQpe+TEUWCnpnTeZeE1HWjYLnfVftmnIeM8e5qqobIeIMCp3ymcQZuWkp+50OvwgkaAlBXSjEf3lnJPLkTsYpvRmOBQY237W0u5ze2NEw8IZ3w3oeflFDvKPoTUXgQksYlROWM8keszHiq
 He5v869Q
 dRCLxMIIiSYxJWcTmI8aNxspgKyIg9P8TQbpZBtpYD9HhsMThdcOoF1vQAbfiyzugSKpu712gtF5KDBGSmItL3j6cKnZ20FsMl8kT8mKvNggTZAMij7s6/finKk20gIIfnGX5Sgdh7g1lZBiuEaSLE/FlqYSNTnlJDiaLQPaEZ5/IxK0Kro/8W7Yp9rUQwk499gRsyDq7c5vp/c7utR0ThipnFkW2FIyBMuFF1wXFHAjxH4chHPOucHq9xZuVrGUzrfEPOGVxcRUB/4Hc/xmuEMBG/TQ7Io5OGmfDSzZv3IIPMdEGoMchWI9+qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Checking expected refcounts or dirtiness has no need for the i_pages
xarray lock.

Page cache lookups are generally done locklessly, only requiring the RCU
lock and folio_try_get(). This makes it so refcount stability isn't
guaranteed under the i_pages lock.

Testing for dirtiness is in no way excluding anything with the i_pages
lock. Rather, the folio lock plays a more important role here.

Thus, move this logic into collapse_isolate_folio(), without the lock.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/khugepaged.c | 93 ++++++++++++++++++++++---------------------------
 1 file changed, 42 insertions(+), 51 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1e58ae5b3e74..accd8b4895d3 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2404,13 +2404,53 @@ static enum scan_result collapse_isolate_folio(struct collapse_file_state *state
 
 	if (!filemap_release_folio(folio, GFP_KERNEL)) {
 		result = SCAN_PAGE_HAS_PRIVATE;
-		folio_putback_lru(folio);
-		goto out_unlock;
+		goto out_putback;
 	}
 
 	if (folio_mapped(folio))
 		try_to_unmap(folio, TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
+	/*
+	 * We control 2 + nr_pages references to the folio:
+	 *  - we hold a pin on it;
+	 *  - nr_pages reference from page cache;
+	 *  - one from lru_isolate_folio;
+	 * If those are the only references, then any new usage
+	 * of the folio will have to fetch it from the page
+	 * cache. That requires locking the folio to handle
+	 * truncate, so any new usage will be blocked until we
+	 * unlock folio after collapse/during rollback.
+	 */
+	if (folio_ref_count(folio) != 2 + folio_nr_pages(folio)) {
+		result = SCAN_PAGE_COUNT;
+		goto out_putback;
+	}
+
+	/*
+	 * At this point, the folio is locked and unmapped. If the PTE
+	 * was dirty, try_to_unmap() has transferred the dirty bit to
+	 * the folio and we must not collapse it into a clean
+	 * file-backed folio.
+	 *
+	 * If the folio is clean here, no one can write it until we
+	 * drop the folio lock. A write through a stale TLB entry came
+	 * from a clean PTE and must fault because the PTE has been
+	 * cleared; the fault path has to take the folio lock before
+	 * installing a writable mapping. Buffered write paths also
+	 * have to take the folio lock before modifying file contents
+	 * without a mapping, typically via write_begin_get_folio().
+	 */
+	if (!state->is_shmem && folio_test_dirty(folio)) {
+		result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
+		goto out_putback;
+	}
 	return SCAN_SUCCEED;
+out_putback:
+	/*
+	 * The folio may have been unmapped with TTU_BATCH_FLUSH.
+	 * Flush before releasing the lock and our last reference.
+	 */
+	try_to_unmap_flush();
+	folio_putback_lru(folio);
 out_unlock:
 	folio_unlock(folio);
 	folio_put(folio);
@@ -2545,60 +2585,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		xas_lock_irq(&xas);
 		VM_BUG_ON_FOLIO(folio != xa_load(xas.xa, index), folio);
 
-		/*
-		 * We control 2 + nr_pages references to the folio:
-		 *  - we hold a pin on it;
-		 *  - nr_pages reference from page cache;
-		 *  - one from lru_isolate_folio;
-		 * If those are the only references, then any new usage
-		 * of the folio will have to fetch it from the page
-		 * cache. That requires locking the folio to handle
-		 * truncate, so any new usage will be blocked until we
-		 * unlock folio after collapse/during rollback.
-		 */
-		if (folio_ref_count(folio) != 2 + folio_nr_pages(folio)) {
-			result = SCAN_PAGE_COUNT;
-			xas_unlock_irq(&xas);
-			folio_putback_lru(folio);
-			goto out_unlock;
-		}
-
-		/*
-		 * At this point, the folio is locked and unmapped. If the PTE
-		 * was dirty, try_to_unmap() has transferred the dirty bit to
-		 * the folio and we must not collapse it into a clean
-		 * file-backed folio.
-		 *
-		 * If the folio is clean here, no one can write it until we
-		 * drop the folio lock. A write through a stale TLB entry came
-		 * from a clean PTE and must fault because the PTE has been
-		 * cleared; the fault path has to take the folio lock before
-		 * installing a writable mapping. Buffered write paths also
-		 * have to take the folio lock before modifying file contents
-		 * without a mapping, typically via write_begin_get_folio().
-		 */
-		if (!is_shmem && folio_test_dirty(folio)) {
-			result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
-			xas_unlock_irq(&xas);
-			folio_putback_lru(folio);
-			goto out_unlock;
-		}
-
 		/*
 		 * Accumulate the folios that are being collapsed.
 		 */
 		list_add_tail(&folio->lru, &pagelist);
 		index += folio_nr_pages(folio);
-		continue;
-out_unlock:
-		/*
-		 * The folio may have been unmapped with TTU_BATCH_FLUSH.
-		 * Flush before releasing the lock and our last reference.
-		 */
-		try_to_unmap_flush();
-		folio_unlock(folio);
-		folio_put(folio);
-		goto xa_unlocked;
 	}
 
 xa_locked:
-- 
2.56.0


