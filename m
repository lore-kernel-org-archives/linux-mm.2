Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4062BCD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C4C96B00A4; Thu, 30 Apr 2026 16:23:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 727C86B00A6; Thu, 30 Apr 2026 16:23:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 579446B00A7; Thu, 30 Apr 2026 16:23:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 403C76B00A4
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:23:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 063EC877DD
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:05 +0000 (UTC)
X-FDA: 84716346330.09.7BB0149
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5C70340008
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:23:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=TeC3RpUV;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777580583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VMo4rj3YcXawZoSW/XqvtDg1E9Hlqa5dFOb9KR5T/oE=;
	b=JCdQdf9jMY/5nDIljBfE2696Rghb7m7al1gTKijpdsxe4g87rwAPeClYF5OccpnmfBucHM
	lfZwmPlofh/L3HwzUvAHumDGfnpuh6Pko/BZiWo25ZtIhFfMHa1Olin6fhFKQ14+214lZ0
	QaG26NfsFBWhHSgvfM/MC3iv3WJDbyY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=TeC3RpUV;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777580583; a=rsa-sha256;
	cv=none;
	b=BupQLarZcYQHhBrtiHKBL2kU+HF6PaVoepcjtIPXfOkZHl2A/f/9hmof6Kz/N3EHsbDfmy
	iTrySX3NPe1B+mSnwMmRBfQpJWHfdd4yqhq/Jv8d9PM05BrXfkfXHXcTULkQ0LecohPPGJ
	Jv4V2X2OUk/pbdFMvq58OinVwHjSU+Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VMo4rj3YcXawZoSW/XqvtDg1E9Hlqa5dFOb9KR5T/oE=; b=TeC3RpUVM1TFbTegpmOO5ftiVM
	nLmJvwOQD+U1KjTxeI0x7cIKd5e9uKdQCu5C78Mixj7HUuqiOtdYOAi6RfOkhEZ1H8fPpsQkGF0b2
	mmywS1a4lapRBtOGw4G2NUtdS3qGh+LA+aNmP1ieEOdVmIM0c1gdScO+5TrSW8i6bUygJtgNiJtVF
	KWUUc1YzQmsZyIPXPTWDjneDlqgMkizyCDYI84wGnQy5E0qprnyoYeqcF4pcdxCo0V+Wk1GjfC/8t
	+3ZB8iK6ibRC2Fyul6C+W+UOcEB8b3GyfP95gBrb5RvPYg6Gjw+hT50K5yBgmwFh8tjsIOAPUsKxr
	UPOxlsbw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wIXuD-000000001R0-1oJj;
	Thu, 30 Apr 2026 16:22:41 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	Rik van Riel <riel@meta.com>,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 39/45] mm: debug: prevent infinite recursion in dump_page() with CMA
Date: Thu, 30 Apr 2026 16:21:08 -0400
Message-ID: <20260430202233.111010-40-riel@surriel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260430202233.111010-1-riel@surriel.com>
References: <20260430202233.111010-1-riel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5C70340008
X-Stat-Signature: wjk9f93khddohudszsuqtxmtryeftzra
X-HE-Tag: 1777580583-954913
X-HE-Meta: U2FsdGVkX1+sNQzXMnvjs2AoCTKxT74BY68CbeC3Nzn3GMlldALgShx29FiJRMsS+bz9KVR5WbKecAdfHec/IBgj0mn0D9so2x4sDdZWOuGtA2HYr1StiJsTCCFzdEer8FngtaKp2MXc0inhlXY74f9Dmovsac27jHPCLGtqkKT687NSoUN9/EGaxagPZZi1WLqa4mC3VaG8goqVddeE8zmPn8ghuHeOZL3XUy1cgmdH2ysb10T3nMlDBZg3ROqQLKXgXG0g1BugH4RZxqtpC5QOHLPB8vTUlBZP7B8YKpr/8viQ/PbVcoICa/ZNIWK9TUaZcmfqbXgcw19nLCEHGMw5pIARTeVvB/ZlbyLxHhncM2m0GHDYUP9tgufmU0RssYYr8lutw5PoR9aMLEUga8hI+9HCH+3Fo26cqLhkzOU+h9hIfXCxhWHMa7ixV/HMnIHn3lCH3tugl3OCYqBQrwyt2dAXo0ksoOUrm0k4oEWoM2stAipUtMsMsjX5hUiQKggLPj4XnZpxuBiI5YrjGcJi0M4QsQnSIhwlaa1/gjGWCHXY7pRAFh8J5Tg2Wsy5dwflnx+HWcHy0pdislxZRFE0jQFaBmdkkZnW99NqhUVgk0auWQReOn2mwWrv9UzZazXhsyYAkr9BcM9wmLeT9jrJ41l6hSgCndsuRtyTetLiRA3bWR9INs/popf0qY1kf6tqS42lx9GaZ3wD7Vfvb5GnEfgA1MKUSvproKWTT47J8JJW9eqgvwGTelsdXVOTiOIHIhcVuzSMLmowdTwBhWWUfNqowfAskW7OzBoa0f0vzTQM793glK5Ba2+G8LTHCUOXobH4eqvF96WmfMJYTX27FXC9eUIV4X6AYXYMdTymHednK/3WQgLFL1DPqTVIRmNUvJlVkVJsdxILO91FQ2iSSip1yyBIThf5BzVY/i4ezhH6obI2DpPxy0SNvWioIMdvhyrgyObYY4cTjNO
 D27B8/9D
 zFHcgwvSTXjMAZcLFEbimvRIvXYtcdjdaufG9IFjyi4KW4oYXzhyvtcafS/VV14jjI6A2A9WsgGZFbNvtiP4VKYt49ASE4l6CSARouZHaQguhUr8BbvAkvT1NsBphKVQcBoTsZsOBE1nV0rCR1MeWwA/UUU+IT390PXtZ6tDWexKCjDSRzJbeSisJ4nda9oBdYhRCNY64MGV+4lFtNXLfQcKuNWJMNrwNXVBgtsuhU8X/n8F5ghtlXhhokXPcJQtWNP4+8HGe1QgXuYe+OIA9I0yAJ2Eh41CAI7wbprM0DsFNEZkOdM+EVHp/rtcOwj4LJbN9I+Ian4NsTlDWDYeNzlJ211E9kJ1AHJaMOc+e/Re60U6rqxfFrmnD+rFREpko2Quy6Bd5KvOwV2ocg6ED4ro4nxLhsR17BtTX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Rik van Riel <riel@meta.com>

dump_page() calls is_migrate_cma_folio() which calls
get_pfnblock_migratetype() which calls get_pfnblock_flags_word()
which has a VM_BUG_ON_PAGE for !zone_spans_pfn(zone, pfn).

If that VM_BUG_ON_PAGE fires (e.g. dumping a page in an unavailable
range, or a page that hasn't yet been initialized), the BUG handler
itself calls dump_page() — which calls is_migrate_cma_folio() —
which fires the same VM_BUG_ON_PAGE. Infinite recursion until the
kernel runs out of stack.

Guard the CMA check with pfn_valid() and zone_spans_pfn() so
dump_page() can safely report on pages that don't have a meaningful
zone. The "CMA" suffix is only printed if the page is genuinely in a
CMA pageblock.

Found by: dump_page() called from a VM_BUG_ON_PAGE in early boot
hitting a page in an unavailable range, recursing until stack
exhaustion.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/debug.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/mm/debug.c b/mm/debug.c
index d4542d5d202b..e233520b009c 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -73,6 +73,7 @@ static void __dump_folio(const struct folio *folio, const struct page *page,
 {
 	struct address_space *mapping = folio_mapping(folio);
 	int mapcount = atomic_read(&page->_mapcount) + 1;
+	bool cma = false;
 	char *type = "";
 
 	if (page_mapcount_is_type(mapcount))
@@ -112,9 +113,24 @@ static void __dump_folio(const struct folio *folio, const struct page *page,
 	 * "isolate" again in the meantime, but since we are just dumping the
 	 * state for debugging, it should be fine to accept a bit of
 	 * inaccuracy here due to racing.
+	 *
+	 * Guard the is_migrate_cma_folio() call with pfn_valid() and
+	 * zone_spans_pfn(). The macro calls get_pfnblock_migratetype()
+	 * which calls get_pfnblock_flags_word() which has a VM_BUG_ON_PAGE
+	 * for !zone_spans_pfn(). If that fires, dump_page() recurses
+	 * infinitely. Call page_zone() only after pfn_valid() to avoid
+	 * dereferencing uninitialized zone data during early boot.
 	 */
+#ifdef CONFIG_CMA
+	if (pfn_valid(pfn)) {
+		struct zone *zone = page_zone(page);
+
+		if (zone_spans_pfn(zone, pfn))
+			cma = is_migrate_cma_folio(folio, pfn);
+	}
+#endif
 	pr_warn("%sflags: %pGp%s\n", type, &folio->flags,
-		is_migrate_cma_folio(folio, pfn) ? " CMA" : "");
+		cma ? " CMA" : "");
 	if (page_has_type(&folio->page))
 		pr_warn("page_type: %x(%s)\n", folio->page.page_type >> 24,
 				page_type_name(folio->page.page_type));
-- 
2.52.0


