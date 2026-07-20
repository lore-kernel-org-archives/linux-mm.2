Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B96CC4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 551536B00BA; Mon, 20 Jul 2026 10:29:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 528656B00BB; Mon, 20 Jul 2026 10:29:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0576B00BC; Mon, 20 Jul 2026 10:29:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13BE16B00BA
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:29:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 41493801B9
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:32 +0000 (UTC)
X-FDA: 85009388184.12.DC2E7CB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4D5131C0003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:29:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8+HpU1uqTGvPV+nHfD59KGVe+ikX/KP8DpbCE15YqFg=;
	b=krQ+N1aOSKrxEsxruwbFJD4dga9ZdjQrahX7EkwwpCVz3zKwPN+GM3QSNo8geL/6qqXFEt
	a0Zdm0Le3PdYDPHwWZdtxm5hmWpG1qHWuZqC1WmfmHTD4adpG3/HKJOcPoI2p1gfv9LofZ
	COyl6VdkIPLxU6l2aplt9KryQ6RZdJs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557770;
	b=DY4YBgWO3paaluW9DASe8yR0Bmizshn4/8y1XtdzVi34llJXiTLlt7/ZZnYex5YmgjyGnd
	JEwby75j6yibPoPmFG2noXtq1g5tJ8AIwEaF4daFkcNfieYImjyveBWMlz/8gMZFl9Yo0I
	JewJMdn4+vdNzRXBh34SUJhbJQorVbY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B95653E18;
	Mon, 20 Jul 2026 14:29:23 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA09F779AA;
	Mon, 20 Jul 2026 14:29:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cLYiKsIwXmrKTQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 20 Jul 2026 14:29:22 +0000
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
Subject: [PATCH 6/8] mm/khugepaged: hoist isolation into collapse_isolate_folio()
Date: Mon, 20 Jul 2026 15:29:11 +0100
Message-ID: <20260720142913.846902-7-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720142913.846902-1-pfalcato@suse.de>
References: <20260720142913.846902-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4D5131C0003
X-Rspam-User: 
X-Stat-Signature: sqfu3zacap4wzyitkktgund1hna3ngyy
X-Rspamd-Server: rspam04
X-HE-Tag: 1784557770-627322
X-HE-Meta: U2FsdGVkX1/rOU1sFfbnvdjcEX1kmzEpkqZ9J+W2tOCCtuIwnVODecsTWtWlOd0LkMiBpqUwScV5OSFPLxhYeQv5GeuNz1Zl4pB1xYWoRC5SAFyfxVW4iW+QUUchUoZa9giTZsGpk1+wuFqQTAMQmH4Gsf/49IXV8sINaZCuBMLkWnL48RFpMtw0lTKdvBzzROxZg8IZm4bJLM6sRxbiIQuEJKZTdEju0OKJp027BbykO9ppXCO51HE8kN6pxyi0tQ/w6vQrWYOZp95mp2gw0ejplhr3TTlOp9iOrGArzQqyilrpLKMUTuHZKuul0Nax63klugv4kaJhyatQ2Nt+OeurRbH6oV2kCLydbQi8p8oGLzUxG/ykh35ILSYcFRsSncoSNIt6Y3ovINi17/v1OE43di7MIRgmiX9G/9lVID4e28IYmzpszgLKSZ6OnsUl71n+M5VA+pG7no1Rvi7NiYhSRzFfO5sK1J1MVivxJr/dtEPMYk3wSkwQWHd71wqSCqsNku3jzfY8HYnlr6tgAuujjvqUtswccnN3/4tWwMLcWomSSPMbF/l9W6EYfm5Y90oM8Jg6Qdyk8SouiBr5Wro+pJELxqMQTpW1IQg/YiUzwht7j4gMaRuhijq/dL5fbV300MDyDV7FwS8ehBGJDiMZKnicJlh6e1KTpCGWpdXlf4heZEmLOZoi7EDj8xycG7tWR72wjifklTnM7CTlWdr2kxbTdoAFhfG9mbi9uev/UTo7Xv6Tj4OMGFtRL1mfvHCicIikpKFGihQKNHFieGbG/E72U9f5MFVwQdwt3LHFR4kO/rBb0POQG9opec2vaXSRgPJXsJ/do7UATJFHAzcreeDIdbos30aiyxHNXZicGMGL3055FUdq4QYlsEtEI6RhrCWBxMz0mDZywxCahCWS9W0b0pYliejkX+ToiFrJGvc74jElPA2K8CG66Qfl3WU9JMWg9o7qIgKFQbN
 V1Cqn39u
 5wUWDlFeuYtSv82JNr1/mg7nfRPNueBw6dlD3w/pFKrYe7SAk1TErAqSTuVMCNG/R8NPzypZ59fxT7fXcHaDN38DPd7EM/+X1xLzfdLZLeRuked3xeZgHGLGqc04TyBn1ykQv8ighUw9e3lG5IVM+cFsLIWAiPYgslZdX865kPT/qsOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/khugepaged.c | 118 +++++++++++++++++++++++++++---------------------
 1 file changed, 66 insertions(+), 52 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index db1f765b6ead..429e2c5833d0 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2332,6 +2332,69 @@ static enum scan_result prepare_collapse_file_folio(pgoff_t index, struct collap
 	return ret;
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
+			         folio_test_writeback(folio))) {
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
@@ -2442,61 +2505,12 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
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
-
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
2.55.0


