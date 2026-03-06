Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52E7AFCB619
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:06:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E24E6B00A5; Fri,  6 Mar 2026 11:06:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D7936B00A6; Fri,  6 Mar 2026 11:06:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D5CA6B00A7; Fri,  6 Mar 2026 11:06:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C87E56B00A1
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:06:30 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9390213B226
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:06:30 +0000 (UTC)
X-FDA: 84516115740.09.E136428
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf04.hostedemail.com (Postfix) with ESMTP id E415140012
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:06:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=TmVIOGiv;
	spf=pass (imf04.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1V1/Uxk3C2b3bmWZW0aYP3fQUiU0/LLNtlQCW3eW0iw=;
	b=l+DUNlpXKZnBKCbbh+O/J4hW8T2GWvahcDHy355SOrKC8mKvmXjbKW1wYfaJzFr8Qp6Nm0
	kIkZFayQKrkMcmBCfgC4f2Ms6XcQTcPvOpKjG/GWSbDex/260hMCdmHlCXebGG3kIZmTKZ
	4ADGOzFR48suuPV/v7vXH19D6I+9Zmc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813189; a=rsa-sha256;
	cv=none;
	b=ezzn/SQDqWmMo379AFMDtAczFcjLi3H4/wEH3S3GJXMVxUXDJGUclE8oJH3s7YA8bgIElJ
	ldHc2lkxBH0UxZi14QrNjJxmtXO4/XVbwzj8dKI0EcwmfB06LaDvqu4AhuO365GuJMRm3s
	mpqu4LkiUeMJsNoDVpDa9H2LRgJe3zM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=TmVIOGiv;
	spf=pass (imf04.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 60685B3455;
	Fri, 06 Mar 2026 16:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772813186;
	bh=1V1/Uxk3C2b3bmWZW0aYP3fQUiU0/LLNtlQCW3eW0iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TmVIOGivH45S62A2GhBBGobf6V3PhxrFmTuo47eRyaYhCBjTLIcvP/JoSpnhfTY+1
	 PWjTK7mJQSK8f+EpQ9cgd17HyRNqZsjLYRuIHqTBc1ndR46t3MDo8EJqcSJaPAQXBb
	 F3P4BEEX/CdDEWMEbpZoecQ2jmolWzPmaeGHM8DM=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 8/8] mm: use zone lock guard in __offline_isolated_pages()
Date: Fri,  6 Mar 2026 16:05:42 +0000
Message-ID: <e56ee5c4f8961d728678a41e5c5abd48e0d98a36.1772811429.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772811429.git.d@ilvokhin.com>
References: <cover.1772811429.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kng5abb5h3om4msuzsi46gof68hnk6dc
X-Rspamd-Queue-Id: E415140012
X-Rspamd-Server: rspam03
X-HE-Tag: 1772813188-995335
X-HE-Meta: U2FsdGVkX1/cdJY67DqJWaih4b5AMav8cVgtK3fHw75owMlyi4FV82aa9cWsUK560Yp7S6Tivf+LNQtmb1v3qmINIRbe8PrNrzuOhuFrmTCeHkeeK56ENgntJwGg6KEa+Knjumnpo8WFBd9Vz3Hk75+It3TKnKC0I1VchBKqpzkD1ETZKUCGOrdO1L6XBo3Zp1B18Bmxl9/0/lVkcnhs5Ux5VIZKcScrygisdG26Gx8YJyCt8YRAZXrr3r2S2FNhFqluUpFR5StK2Xdw3I+4vhjh6qw4zav06Sbnz0XcSSb/1dQSZDizOiNAoeWCea3CPziVekVzA6SYQhrgYXY7CxymN6yJdPThvYsKrnORnFybTUxprAfkvhzaQtZ6eLF6LLfYgisCmsuJWVDJ9rkuGXnxSFJh+KYhG5ivfFEGVg6dFTPQ+P96qTKivw8Uz4ug2uMvI0Q55xHYj5HtWP6MRMsyzIxsGlur3zh1uJnHX3cHmTojrYEyGqlpSQcdM+8tBhy3LKazcYNpFJcUNXMsvKbUAXp2cm72rcZMs1Rocrz2S5gjNiIwoulcc9GLMLkAwdL3Xg0yc9Ioi5RQbhgD6Zy86iiAx20E7iiCd3EOwt4JO9q5S/szFEJ6iOLcfUXPio7bbesHo8i0+GQ+73k9zUffvDVqAJf8+o6ZfbnY4fsNsMxBAs8ReLS1hbYPpOW4VDz8vYSZCQZLr1hkPJPcnHJ+O60RRd4rRF6n3diPBCOujvO8zjujivOgVZkmBb/+5q/z1SVnZWtq229z6uD6Pl5x0VphlxrYP3NRUGDkNJraD85hqt4RzwMTvUkFXxMbu7jJvlYxguTBo8YTqJmfcixfru/6inUs4GlW3E//0wde/X62dOqXWxPng5pGq4iyhAglSDw71f4r9i9qQPXleL6u68ppN1Lzog/qDe9M3GuLFerGWtvYkNXX40MOyQ/GJUX+h3xBJP9+cd3LTeJ
 zlw7/qX1
 yf4EIZNkfrQ3gYmX/8Wbfyt0Md8cnFXYrRbyGfZiqeb03z8Evdbd6OKppUlN9Xd8uhkwO8B0D93ieLInVbEaec/pEa9gKtcIMvoOTUMbRwsfde/9SRqswx7yA4ccWowXN5eugz0w9GkAmilFVY+NqbGFyhWbmE1cgrcvJk/1GoLfzEJo/7AVq+zx4gRQABs3qozgCCFnayJ8vbKHu4D1RB9QbEb/SmCcMvzdE17ZrcH4tnsM3g1jwVGtXbD28KRO0kt2uRFRHcXcwzHwMk2t6NGZfSNmiAPnFUToM2rq0ND2lxnw25s7b8fpcSvEf3MSeg3Lyvr8QGTdNw0C0dFedItLSsNSaHHHT2KD+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use zone_lock_irqsave lock guard in __offline_isolated_pages() to
replace the explicit lock/unlock pattern with automatic scope-based
cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_alloc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2759e02340fa..6f7420e4431f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7380,7 +7380,7 @@ void zone_pcp_reset(struct zone *zone)
 unsigned long __offline_isolated_pages(unsigned long start_pfn,
 		unsigned long end_pfn)
 {
-	unsigned long already_offline = 0, flags;
+	unsigned long already_offline = 0;
 	unsigned long pfn = start_pfn;
 	struct page *page;
 	struct zone *zone;
@@ -7388,7 +7388,7 @@ unsigned long __offline_isolated_pages(unsigned long start_pfn,
 
 	offline_mem_sections(pfn, end_pfn);
 	zone = page_zone(pfn_to_page(pfn));
-	zone_lock_irqsave(zone, flags);
+	guard(zone_lock_irqsave)(zone);
 	while (pfn < end_pfn) {
 		page = pfn_to_page(pfn);
 		/*
@@ -7418,7 +7418,6 @@ unsigned long __offline_isolated_pages(unsigned long start_pfn,
 		del_page_from_free_list(page, zone, order, MIGRATE_ISOLATE);
 		pfn += (1 << order);
 	}
-	zone_unlock_irqrestore(zone, flags);
 
 	return end_pfn - start_pfn - already_offline;
 }
-- 
2.47.3


