Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54203CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE126B00E6; Tue, 16 Jun 2026 17:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7589C6B00ED; Tue, 16 Jun 2026 17:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 646916B00EF; Tue, 16 Jun 2026 17:42:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3495F6B00E6
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:42:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8FD2EC14B7
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:42:44 +0000 (UTC)
X-FDA: 84887100648.26.D088053
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1DFA1A0002
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:42:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=X4jn8n0U;
	spf=pass (imf15.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781646163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xyyMgzL3dB9zRqf2mWub/khi9AUa+g6mx9a5bkCc6yY=;
	b=yJdLC2gqNRpakp448BMHemUtimsV6xG0pUGNgOtUv1a1aX7jxVEHdSsFfRF+NPJ7uGu9yt
	RuC1Pz+zEcaGQcINFfrUFNHCJDHrCLxoYB35wDNyK61JDFtoBB9T/S21pg45OZ05E/caRg
	bcE5BkEnB4gM/Q2gDHVWkzmQsJMSv2g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=X4jn8n0U;
	spf=pass (imf15.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781646163;
	b=X9qa9vms5/JUAIwflhbdzZpFiKgYJOUiFkJYUDj0Rzk3I3BBSmWG+9WW1WdYVM+E/LFAQK
	wNQkqv4ZA8t+njf4+HQ6d7B67XjIhmbwn0Ysk0J5ZizDscaBMRG/Bzujnu8/myxxDk79A0
	l1L09d7TqjM4zU7vPgx0Iqxv3JOQ5Aw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:Cc
	:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xyyMgzL3dB9zRqf2mWub/khi9AUa+g6mx9a5bkCc6yY=; b=X4jn8n0UChybSdWbaA3p5vTXQ9
	POf5b0yi0/B8W8WTmHwPzzKRALHRqJeKIpscn2Hd8ThX3gUT6csiQmRRRjiSJlrFS4EggNtX7vu53
	n814jdE86cyFX83NHtB6FbOyWPgJVpQNkzHQspyXZPDqSh7TlY2kDv9cqEj9OdLxAcpxQvJc4EAI5
	QTgP14bu/cz5cFwd0CvtNlW7ZMIcxXPmH3zaat242zpK4gE1ITbiCqHlft9rxEiwqudDjCRFq5EXl
	FgUL6zTZjeowEvI8b/HE0KHSpSJObx8kwzHIE2yhkB/sFQyqnlXyOOoiBGT2wY8Cwj6B0mf7vfrG6
	d5y6fF8g==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wZVBC-000000002wP-3kfH;
	Tue, 16 Jun 2026 10:54:18 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	Rik van Riel <riel@surriel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org
Subject: [PATCH] mm: khugepaged: free xarray nodes left behind by failed collapse_file()
Date: Tue, 16 Jun 2026 10:54:13 -0400
Message-ID: <20260616145413.1491961-1-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1DFA1A0002
X-Stat-Signature: xaq8tc6sqkcyfc6pr7k5tbdcqqstbuqf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781646162-333357
X-HE-Meta: U2FsdGVkX1816KWx5FW26qyhbeBcuv0RnL1VLyyhn45K+l9T5Ca6zA3WNvYjmuDlUk7Z+VfmO+wYh+XdzKXA+lngtONewltKr5yp5XKfA44EGFMfqpV37NffSfFH6aLwSoDhsrUWiXVakUyEwG1f4a8CLuH9l5tZrrIInr3Xytx8FFD1pvnHW1TIBf4usT5IpOAci9fqjeGUEm8g2VLmWgWLp9MFvDwY8J9x0xbuQ6C0eJNiJHZ+f5TzypefrdEvkQZFrIQkKpYv34FLJ3T7wiftCJfllwj0naqqHgSlyFqGj/bKn9ax7Gcr320VPkFQM73IKejIWRg5epREeVMgoxWvcGvluJcKgpPZoMePMdS5Xflbz5nUtDLMeIaCo4SzrQ3MLzfAruobFvZwF0nmvtWH7aIXMoRf/xWultaUlctjCS4+6t9giFW+EBXGXWKGzUXSP3g17Kgcs3VBjmdvNNVgMRTinn/6ZX16oXebqD/mNInR/qcjAFAQ6iELgl4vx3sobodmR8lmGHAFPeNsa1GK91syrxJmShJywpSfYIwlTtb5tuiIL6wHyE+o3lQObQa5u1E2f8Nyjz5sxcYmxcSKmc8x4GdJuvGrmtteWf3jimfskutswf9Abd85XqEgTFmrKE7B3ic9BPB0Xm2QluZLe6weSxRWgifxnJQ1CEjTOuoB1dmXo2K0XsPh/O9eC7u2tWhVklEWyQFnQ1jv0iNQ7dKpDS2/LUxhs/RAevVQJMPHC9IdL3y5k2TtmpBu9Gd5qidBHzf4EOID/OL0NRlsrNazGHmu4FUpNK7LevatUMbR11kT558o6H1PUx72kjYWhGLWtY39DL9EWl+D5H/wFoc1t7xttRVj7Y+Xtlsf3AuNnBaMDZVIQFGF2z5XrgnR0XeK5yhmzqw1sh23WG3npUd/Bm3OgYB5nXRPBql/x3DQfDQ6wgORIkF/DBVwCPWb1jcYYRUkIXkhPZk
 RaEeBLAf
 /23yCWnxRyZ+Hwb+/gnj5L3UALEAOYJ88nmgJ50T8fjhDrBcZnU9QvkWm+x0cL9Spbp0+TAqYS5ftgSRY3hkzTlpEOMJG8QTpZusKGknkPi6AqMh2uQf8Gv0wjMRT+x40501xrzco3fO/KzId7CovWZUf1K1vbanVfi3pkyfu1nmU9hQkvjGanEegGxbJiFRsiLwoqO8vrhY9RZEehKvPOs+ZDfbDqVgWNKrqvkOJK90SgrEItue4BrqmpUd+m1CTak5PpCBsF1ONGqBlrc0/FnWx6ia9nwZA0RqGFq+w6ykqMzFJJkG3NsnycY3YuQ+u0HxdzXOuKo8znIiuZa86+Y46So7f8iRESiSS92mi0FInaxEE8sFB1b1JkBoynVw91TITQELPa2hgnk3LAwiQj4MqT/FW/BYooJoC8N//QF67Gm2rwQY9x/vgwhT1QEnxwSVn8nFz9fNQUxB00Uv2aETSdG3VyzugcxzehVqpGmw44KN2TG0iLz+58GQ+W2UASmlEByvjuTwQkj1Pj/+Zvbm+UnpENfySlhgehsRc1hpo8URNI8u9s9KcjZH5mpn0nMUImELZyVSwdSPd/LsKViuyUU7D9ZaJ0lQOpLT2U23LumjZ+JtkdArftrR5lSKvR4SDziPDFVmDGOm4Kv16UFTCWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_file() calls xas_create_range() up front to populate the
xarray with nodes spanning the entire collapse range, including empty
slots for the holes (the nr_none entries).

On the success path those nodes are either consumed by the multi-index
store of new_folio or freed by the nr_none retry-entry dance.  But every
error path that branches straight to the rollback label -- e.g.
SCAN_TRUNCATED / SCAN_PAGE_LOCK / SCAN_FAIL detected in the main scan
loop (which then sets nr_none = 0 and jumps to rollback), or SCAN_COPY_MC
during the copy -- does neither.  The empty nodes are left dangling in
mapping->i_pages and are leaked once the inode is finally evicted.  This
is exactly the "THP collapse_file() failed" case that clear_inode()
documents and deliberately tolerates without warning.

syzkaller reproduces it trivially with MADV_COLLAPSE on a sparse shmem
mapping (collapse aborts with SCAN_TRUNCATED because the range is empty),
and also via slab fault injection, which forces xas_create_range() down
the xas_nomem() path before the same abort.  kmemleak then reports the
576-byte struct xa_node objects allocated in xas_alloc()/xas_nomem().

The leaked objects are struct xa_node (576 bytes each), left dangling in
mapping->i_pages and reclaimed only when the inode is finally evicted.
Nodes leak when a collapse takes one of the rollback paths (SCAN_TRUNCATED
/ SCAN_PAGE_LOCK / SCAN_FAIL / SCAN_COPY_MC), and only for the empty hole
slots (the nr_none entries); they are not leaked on the success path (the
nodes are consumed by the multi-index store and the nr_none dance), and
slots still holding folios are never touched.

Prune the now-empty nodes on the rollback path.  A node is only freed
once its slot count reaches zero, and storing NULL into an
already-empty slot is a no-op, so briefly store an XA_RETRY_ENTRY into
each empty slot and immediately clear it: the clear drops the count
back to zero and lets xas_store() -> xas_delete_node() free the node
and its now-empty ancestors.  Slots still holding the original folios
are left untouched.

Fixes: 77da9389b9d5 ("mm: Convert collapse_shmem to XArray")
Assisted-by: Claude:claude-opus-4-8 syzkaller
Signed-off-by: Rik van Riel <riel@surriel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Hugh Dickins <hughd@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/khugepaged.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b8452dbdb043..d11a4c9610e1 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2273,6 +2273,39 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 
 rollback:
 	/* Something went wrong: roll back page cache changes */
+
+	/*
+	 * xas_create_range() above populated the xarray with nodes spanning
+	 * the whole collapse range, including empty slots for the holes
+	 * (nr_none entries).  On the success path these nodes are consumed by
+	 * the multi-index store of new_folio, and the nr_none handling further
+	 * up frees the ones covering the holes; but the error paths that branch
+	 * straight here do neither.  Prune the now-empty nodes explicitly,
+	 * otherwise they are leaked until the mapping is torn down -- one of
+	 * the two cases called out in the comment in clear_inode().
+	 *
+	 * A node can only be deleted once its slot count drops to zero, so
+	 * briefly store an XA_RETRY_ENTRY into each empty slot and then clear
+	 * it again: clearing the retry entry drops the count back to zero and
+	 * lets xas_store() -> xas_delete_node() free the node.  Slots that
+	 * still hold the original folios are left untouched.
+	 */
+	xas_lock_irq(&xas);
+	xas_set_order(&xas, start, 0);
+	for (index = start; index < end; index++) {
+		if (!xas_next(&xas)) {
+			xas_store(&xas, XA_RETRY_ENTRY);
+			if (xas_error(&xas))
+				break;
+		}
+	}
+	xas_set_order(&xas, start, 0);
+	for (index = start; index < end; index++) {
+		if (xas_next(&xas) == XA_RETRY_ENTRY)
+			xas_store(&xas, NULL);
+	}
+	xas_unlock_irq(&xas);
+
 	if (nr_none) {
 		xas_lock_irq(&xas);
 		mapping->nrpages -= nr_none;
-- 
2.53.0-Meta


