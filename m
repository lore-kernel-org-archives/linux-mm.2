Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E2D3C44507
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 07:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 560086B009B; Fri, 17 Jul 2026 03:21:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50EE56B009D; Fri, 17 Jul 2026 03:21:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 425DB6B009E; Fri, 17 Jul 2026 03:21:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1EEC86B009B
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 03:21:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A70F01C0507
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 07:21:36 +0000 (UTC)
X-FDA: 84997423392.01.A2449CA
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1FF3E100002
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 07:21:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hcKnqy7N;
	spf=pass (imf14.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784272895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=d+Tkj7zV4PZ2cdVzzSUp4ijJxsddWqia3LSrbVC+6B8=;
	b=u0ppP6B0FnMsEsW7ha5ADNCFJDKUdFFhGBd7lZnl3eTwxIRCcJwTbh/6rUJfvNlDbMYX/D
	AF6JVUn2OyXZ7fHeNwgo5htM9AVuUK4cITSEjKZXhyBext6A7qKeunssXbZlA5vZhoz7io
	JjNjjfwThAdOLmyPCBxtswl5I6mNtpk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hcKnqy7N;
	spf=pass (imf14.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784272895;
	b=084tWnSw1cMXFPK4+jNCphCHfzQHdhqTvCuYyk3IIPBgGt6YAc+NwrurXyUQKHJfgGSBje
	naT3OO23L/7H6rdm3wimCyaWJh1XDv71BmizshVvbmCc9CJGtCN7mRSW0+9VLmrpU2HHbL
	Wqv5koIh3IFDrBkZGaXhUtrGUssf/jE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784272893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=d+Tkj7zV4PZ2cdVzzSUp4ijJxsddWqia3LSrbVC+6B8=;
	b=hcKnqy7NN9SjSmlK8KHRx2dS/HNwGT5WZEf+dHaJqZjkciqsMVoDfhvAY/pizJ6BCcelRk
	elMlyvwg3VquJ+j8hkGLRlC3PJG0Xx4rSh3zKPuEX5Rs/QmBgijjh4nS8b6Kka7OazW+Bc
	h0+aiACf0CXVAYrD0hKSkZJObeamIEU=
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] mm/folio-compat: Drop superfluous return statements in void compat wrappers
Date: Fri, 17 Jul 2026 15:20:54 +0800
Message-ID: <20260717072054.74260-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: gqy8d5iwqe9bxpye9qnbuogx4w7ac677
X-Rspamd-Queue-Id: 1FF3E100002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784272894-561986
X-HE-Meta: U2FsdGVkX1/hU4ykP8ZbrJCcK2LoQPC2vPbcBwMk6y+VpXm6n00VJBSC80V5X0H3IgUzoLPYvaT9G5nQfzgQ1oa7o129EieDfyFN/Xe5kczY1In+l1rvZt3fD8CME1LpxFaKm41PzE8GI2mNgHBweIs0ORFdhPZsIg+q8P1sKH9+X9onPt1qBKvnWZxk8FygnrfXELljDXhWyuKf0GjRUKRQvClx1F/bpgNYDub31LRIEY7pz/QrAFugZ04TAhgge8x+LM6NRkyW7+iLtf4pQ0sk/xjN6LNEVnp96t6T9scZ+69y2h5R8ouOMiupucLeUS0nFReoXvsUzONuFo7FT7TUj1Zth3lK1Rb6fbw1JMSNHwAbfvvGM5mKsJnWJ9FUUIgmr87pLaZgr/g/buo9rujH1bkMjxyV8upbDyn9IvLITkX/PWcM5peJpvfJaVj8SzOkC1C47BiezP4NNRvhj2G7JT3+TPY6EfMGi1RsEFGI/LYSi/vd62L4fiI0PTa/67+mg5JUm6ttbp04vkPWxM0XCx7YOn2E6m7U52S32e4q0lFn3BvRQ8vd2H2GTHaqFmcY9momhOZxGAO7yNw8P9UfHccnVv1j7D2RzliM/jm1okX0C4D6awvE0wNPh0UcwlW7ymQdi9f9WLf7PsQdtF6iQat/TYc1JJNPfNhfzKIurk6rY0RBvZGnsoPB+Pt0rooCnvrIGZ42hztk5Ees/BgkoLGYj/MdZjWZqHhrz2z7MATWc3PHGZKXsriXNTf8b9Tg4ASEZR24yDF0Q1UGq5zmeuFjvAbuBrq8B6LssTkdKpBprMgy9XPUbgpv3benMOXwOILAslkP2h+XK5NJuwBjKoY63V8k4tchAnN1+qoQBeLty5v0F0KlOYT74+qd/2yOZVDGOxPMTIOzkqI/USKkt+Qv0Pg1JMuq5SNc5DkbpqOQhQyc/8VDJwZNMPbNPEzqtF+BnJxHFpd5yB/
 G4eZ32Kc
 Aaspb5fxe0mvOIRzX16Haf39FJRfW5R3oQ4YD8QC3vx6ajeeZsdK32FOH89HEEDrMe7m5z6pCKwUgj6Tv0R+lEL7raaeaEqTlc4P4MjSPNJyqC256NdVTbFfSh7tc2qJLPGM0XPrpv+h70Mpl5v2F9M/6NGHLKAVo1LRrF6WQ5NeSlZoYXDZGzrMKMSBtFOwQ9K6xIjNnFg/waYw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

unlock_page(), end_page_writeback() and wait_on_page_writeback()
are void wrappers forwarding to folio-based functions which also
return void. Explicit return statements here are syntactically valid
but unnecessary, and inconsistent with other nearby compat helpers
such as mark_page_accessed() and set_page_writeback().

Drop all these superfluous return keywords.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/folio-compat.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/folio-compat.c b/mm/folio-compat.c
index a02179a0bded..8eb3e7fe4c91 100644
--- a/mm/folio-compat.c
+++ b/mm/folio-compat.c
@@ -13,19 +13,19 @@
 
 void unlock_page(struct page *page)
 {
-	return folio_unlock(page_folio(page));
+	folio_unlock(page_folio(page));
 }
 EXPORT_SYMBOL(unlock_page);
 
 void end_page_writeback(struct page *page)
 {
-	return folio_end_writeback(page_folio(page));
+	folio_end_writeback(page_folio(page));
 }
 EXPORT_SYMBOL(end_page_writeback);
 
 void wait_on_page_writeback(struct page *page)
 {
-	return folio_wait_writeback(page_folio(page));
+	folio_wait_writeback(page_folio(page));
 }
 EXPORT_SYMBOL_GPL(wait_on_page_writeback);
 
-- 
2.54.0


