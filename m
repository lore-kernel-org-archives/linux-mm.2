Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3D3E6083619
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=kWQMzGCd
Received: by kanga.kvack.org (Postfix)
	id C30046B05D8; Mon,  9 Nov 2026 04:59:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE0856B05DA; Mon,  9 Nov 2026 04:59:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF68C6B05DB; Mon,  9 Nov 2026 04:59:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90B4F6B05D8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:59:04 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3A42F1A0627
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:59:04 +0000 (UTC)
X-FDA: 85415132208.14.6029DE3
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf21.hostedemail.com (Postfix) with ESMTP id 710901C0004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:59:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kWQMzGCd;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794218342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=To4BA2WdbYiQnlb3QwwdIbRfoel2CyTLdH5PXVnKES0=;
	b=wV79370Zvzpg6PHp8XS+3BqXtvlNZn2nEKbDqSOhlIdigJQAHo8HlkvJkYqlkqe7olDLnI
	RvtXT5g5NtzoCwxFdWDWG/dDP1MK+/rRrqxY0JEYl1Ah5QUQN1fHjlmtp2/kQPhmqUagM0
	LNaDTs1dmWaxA40lX0aEU2XeJylBupE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kWQMzGCd;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794218342;
	b=zJXPimiRb5uqP7PisMYEPp3P9r+htCP3V5nsFRhuCF6paPr0cS2WajZXWFxpcYymtI8D+2
	qJd2/UDSxbheYPU8vLHRymwqzYeiA+Ql0ulqk2UBOqMGCbuG9kWp3YBCa9KjlxlcGQoR65
	aw3Z9gdwMHFn48YkQ27ISXEXseTJh2o=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-15ea896ddc8so1284715c88.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 01:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794218341; x=1794823141; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=To4BA2WdbYiQnlb3QwwdIbRfoel2CyTLdH5PXVnKES0=;
        b=kWQMzGCdCVLHAgN46WMBHeqMQgxgzwMmbsfyPsRfQrN4QMJ9KxWVp3nsIS8R76PWni
         yjv5fbIIRs0EXUtecexGPY7J9ify7jM7tE6A9M6m028Lw6SyNpJlfi9o+vsiOhzV1WOC
         EO5Xg0SJ0kxQ6gY32N9bqL1mvYAAmY0OJY7XqSxXhHCDnCgaOEnME3Vvhf6rxGnFPQOU
         A0eFuArD0x7V0I9Rq7H1OzmStkvnGtBJO3XeIiUPO5VA7or3hI7+Bow8IxaI9WAdsqld
         wmEjCsQlk6C5glJqImqRP+TXhEscMtq9g5+fgpUN+mazDhx90c8lZUZ/9CFyAmZRpCsq
         j5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794218341; x=1794823141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=To4BA2WdbYiQnlb3QwwdIbRfoel2CyTLdH5PXVnKES0=;
        b=rkaRz5maSv84GZgxZuXGTFk2J+La6f9PNTt+IuDjqfVp2weE0kSBL1GHRM9ITEqEb2
         VMz4/dlKRKGMlveDIdnAfzbjD1joFKKzzK862i6zkilgItMZhDF1Gc0/hAT1uUUQ5/c9
         vHxt5UXKchyM92JNr0g/RTJZ+SiY+BAl6M8oQuHiyp6kpqX3G8b+YNdYwHGOXA+JClBV
         qdUYCJlN1SS+68PdGXdQ5ES/4YofPNsZG2NOwEXwCwuo46shzLbVLfnJuIPFg5z0VAPz
         5peMJAqB5X3EKgMJtdNEcbRSnen170WRbR7t7qi/lccL19TZgB+ZDzvR6bA3mHczpFru
         Vu9A==
X-Forwarded-Encrypted: i=1; AL+hErGRQBggwyGIXpZSCPaT1Gf0cA82VJ41vAXgNg2/40IXOs3NIL7wpvlbFVG/evM1j2XenH8Umoj0WA==@kvack.org
X-Gm-Message-State: APuU4Z9kTHUv8JgUiUummfkBC9ayZDYGN+GQUWy0r+Fi0TzmgBzCi+3F
	D9Ae0qh0yqUElRaQZYJPZ+BIYSsKkrJFfW9HSYzzYLMeVNuw6ydUD1nURGggqFO+kig=
X-Gm-Gg: AYBFou39G9kMeQKgnT0XAq9BoM4aq/eTrdxJdrwEvkx7btKIkzNa5Me1RJ55BhzWyCj
	a8QaXEIv0ooFyO+u2fat4vUnWJqOj4yJicG5BZX3ts+lTPWP6Jvf33rdTKiskexI/Zln2wwtSGh
	ElisRBksDhe6mwyCt/9VBm0NJNMEI1yKh2ztSTESnDX9Zr4qQYZh060CbxAFMwvO1Jg9uNPP4p9
	FP+wb6Fg7gN7CVMO9KKLpz3VPi+JWUPzlSnqKUxhSu3xgODpO9ozs8ThOSMXvDcBZqk3hOoVPGY
	w5IyncGS9s/U7e1qFlhQlq0/59oiLCmAvf6C5YQuvtQQrTfV3gB/0I2tUpsst6drk9Bvt74+a/k
	q/sHZ0RUbmePYJJDorzNLISpai2FBI5WS8zoAAlHsNTRfI2+0zGhZx+33Yf2nHupufk1zQXrp/g
	XbqITSKsGYOxvj9VL2TpMJT+kFlYW2Hcvtkk6RSwWKOgWWMDSe/utPkwl1g5C4Olihz9wSlm34O
	OvEt5Yn3UvdkLJVopYvmtUiZydmjBdxpVk9oPx0YOmNOKZVb7t0jsPntH3LZCmAb282YC3zNkxx
	8RnAXVwPKpZy/aRVxikYcgYGod1szO+7Jm6OsA1VJk5gYsTVd+KQo1kzxQLUeqXnMp/tY30u90x
	xmTDDv+U=
X-Received: by 2002:a05:701b:2303:b0:191:ac4:55a7 with SMTP id a92af1059eb24-1b39fe95e8fmr5401187c88.23.1794218341054;
        Mon, 09 Nov 2026 01:59:01 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.10])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3755e8911sm12841684c88.5.2026.11.09.01.58.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 01:59:00 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 10/11] mm/cma: localize init_cma_pageblock() to cma.c
Date: Mon,  9 Nov 2026 17:58:05 +0800
Message-ID: <20261109095807.41547-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109095807.41547-1-songmuchun@bytedance.com>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: megduxb119d3d59ce5su7iasn4qu19d7
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 710901C0004
X-HE-Tag: 1794218342-423000
X-HE-Meta: U2FsdGVkX1/UZqxlAqulI8f8DjmJnNyJOEBzdZzPQyVHbSIX4mDJj/qsg6HTEs03W7KXQl56yEQaW5armcfxqG3JkU+w9subdVs5oQVfNZyEXdniB4jjGG9YTWNRy6n5qr4jcvTSZA2JoyHf8JykXhUfWNe4RRJxZWlZ9m+clMLbJyR8JzOix55jOsMkGfrGLCrU1O4j6w4h9WMhFlyaAHcU7xcu61Ub1/AQ6/RXOjucOVKI2pIGJrKXOdOUHxrnOSFUuAlMhM+vZ0C1B4Qi7dUrpj4gARDpbaroy1xSlfjSlJZ7n9zti8aJ/nV5COSP9irMh267gB4oUsskfAOiGgweDne5PMaK8p0cwcKpuzUnULfv5aaHr1X1dd/k99sw86xSpnAfttIrO6MPKh12yxnHdxFPBdERUq+HgG4wYpgpdvPFFqcFNldRtbLAWCyfOWLvBIWZffEChkFt0UjGd3P/92Pc0PjFROsZlsxTVhYsX6RiTzBcXMiwzshxnIF9Rwea1HRz1WFfKlNcB8u4ekcHI09kmPNf0BbWu1rzrOjnCuzhVrWkV0PdEOWPPFCETp9qqui9Mfj5DiKLjeo+ONgL7lzVoEpi00gGgt3Gm8XrPiN9PBBAUeXDx8/Nr+tMS6OqYgR0tiElna/QS+rj81Ap4GCxdhDQJkQ64AhrpBRLvN6v5WVmk5Qyq9LuZvrjCgiZBQlAwAuifyGtglJmcdIZUpyrryd4R3hFNCWjccQQpEqe3lLjmNtdpzuBGnxKnmDlHFaQemZXLTDPaHCwqDmpdjtz30WnSiTqIR6VaoIb84HZSKPFvanveNzBh6lzisgqMw/NnZCHhe6/JNIvtZknkyWiyo+5Mgk+u9llzygoU680I8sZdJJExvtra0/b+36T5MKopVbbgu99D4V6VB75YJvYRO+8vGc4RrmeIsv1MsVJ3yFZt4HZQ8+3odSqhyEY4anKE6I+3636mwD
 GeKW7CdY
 mUXiEz9dJbt7gqHTId/+J5R+E/3eCdMISrVJRyKivtJ7GZfrBMkwOHINZvTozJu6ZctIXWbyH376wwj/7gV1Ym3+LHqWbivEh3lJOmKvLp9ofl3RZ/MflflwGQ/PayrCiuqcVAJheT0vv66GkeKW46wU1drCZo6a+AQtKvYROGZaJhzw2S6/Va3y2MSovFocFKUdLyNeh1UJ8O0mj8baYHvFh/qllrwIYxlSHyS7sWD/ES4ntyXzfA1g/hhD+ERXWaMUJJJMIuCMbTtUH4+FFkR8gMX0E3Uf9tShnzBV3RHoBooyKztH9fQ00AeH+7nnECQjkpKU4Nny5k9lOckLFG6K8qAWI5wZX+8zCbzO1z1asxrHDnx2t2OPfBqYgUo7HvRYKQ2cGCkaIKw0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move init_cma_pageblock() from mm_init.c into cma.c so it lives
alongside the CMA code that uses it.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/cma.c     | 8 ++++++++
 mm/mm_init.c | 9 ---------
 mm/mm_init.h | 8 --------
 3 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index 46e72734ba72..7ca0e100504d 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -30,6 +30,7 @@
 #include <linux/io.h>
 #include <linux/kmemleak.h>
 #include <trace/events/cma.h>
+#include <linux/page-isolation.h>
 
 #include "internal.h"
 #include "cma.h"
@@ -138,6 +139,13 @@ bool cma_validate_zones(struct cma *cma)
 	return true;
 }
 
+static void __init init_cma_pageblock(struct page *page)
+{
+	init_pageblock_migratetype(page, MIGRATE_CMA, false);
+	adjust_managed_page_count(page, pageblock_nr_pages);
+	page_zone(page)->cma_pages += pageblock_nr_pages;
+}
+
 static void __init cma_activate_area(struct cma *cma)
 {
 	unsigned long pfn, end_pfn, early_pfn[CMA_MAX_RANGES];
diff --git a/mm/mm_init.c b/mm/mm_init.c
index b719e6f82d66..61a720bb44dc 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2205,15 +2205,6 @@ void __init init_cma_reserved_pageblock(struct page *page)
 	adjust_managed_page_count(page, pageblock_nr_pages);
 	page_zone(page)->cma_pages += pageblock_nr_pages;
 }
-/*
- * Similar to above, but only set the migrate type and stats.
- */
-void __init init_cma_pageblock(struct page *page)
-{
-	init_pageblock_migratetype(page, MIGRATE_CMA, false);
-	adjust_managed_page_count(page, pageblock_nr_pages);
-	page_zone(page)->cma_pages += pageblock_nr_pages;
-}
 #endif
 
 /*
diff --git a/mm/mm_init.h b/mm/mm_init.h
index 1a1cde5126c3..54d6043bed9a 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -40,14 +40,6 @@ struct zone *pfn_to_zone(unsigned long pfn, int nid);
 void init_cma_reserved_pageblock(struct page *page);
 #endif
 
-#ifdef CONFIG_CMA
-void init_cma_pageblock(struct page *page);
-#else
-static inline void init_cma_pageblock(struct page *page)
-{
-}
-#endif
-
 /* Memory initialisation debug and verification */
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 DECLARE_STATIC_KEY_TRUE(deferred_pages);
-- 
2.54.0


