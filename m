Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38ED6CA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A86556B009D; Tue, 29 Sep 2026 17:53:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37FE6B009E; Tue, 29 Sep 2026 17:53:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94D136B009F; Tue, 29 Sep 2026 17:53:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 724806B009D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:53:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ECF9516065C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:29 +0000 (UTC)
X-FDA: 85268151738.03.83871D7
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by imf08.hostedemail.com (Postfix) with ESMTP id 43E6A160006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U4inXO7e;
	spf=pass (imf08.hostedemail.com: domain of 3VjO8agoKCAsytwl96lt3srzzrwp.nzxwty58-xxv6lnv.z2r@flex--nilayvaish.bounces.google.com designates 74.125.82.198 as permitted sender) smtp.mailfrom=3VjO8agoKCAsytwl96lt3srzzrwp.nzxwty58-xxv6lnv.z2r@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790718808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RahMTkaht7nhK0P4I392N//nShuSxCC9bOhbGUFtS7w=;
	b=hhkFzeXHrgd64gghbkUWSzdSaW8YpZYqJnKfoYHUtnLEihRsu+QFIYWlsvl9T+G+yv6v4q
	qa5SyqoxWF6rb71Y9LfvX7zR0DdTQUoHq0ocA50F1wPPWZbTbA1WqgKY+aDilSy/uwX4Sf
	QWDHfwyzKQPoEXdH4JrPsYublU/VjyA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=U4inXO7e;
	spf=pass (imf08.hostedemail.com: domain of 3VjO8agoKCAsytwl96lt3srzzrwp.nzxwty58-xxv6lnv.z2r@flex--nilayvaish.bounces.google.com designates 74.125.82.198 as permitted sender) smtp.mailfrom=3VjO8agoKCAsytwl96lt3srzzrwp.nzxwty58-xxv6lnv.z2r@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790718808;
	b=y60lMmRyWYqLpFjHf7HCuQxRTw8wQxOIoNOEMJWbuwHfTeIl3uU6XIlSsmUffSjder+C+N
	xlE/wpAA6QEF4wjuDebj6ydyVFc10J5fsGdk0m3fZyjG7ucI3r97UsfzexfSe4+GCiVmM0
	dNoHIKxCgy/evLTM9BZecVB5r1sqq6E=
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-34bbf2e3c5cso2891069eec.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790718807; x=1791323607; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RahMTkaht7nhK0P4I392N//nShuSxCC9bOhbGUFtS7w=;
        b=U4inXO7eDspkFM8X0zo/zTxKFIF/6s8TXVSuEgRXK8/CeMuX0xjNTlO0q4VEXlla5t
         PR1q2pc0qGFC8Xla87oCpCAtRbVy+VOMcYidyLY+p7Tv7poSsPe0y+p+AVhcN1DuNchW
         MlySUxn8hfH5fxex9BrQmw9E3BZ+2Y71kybkgtht7nwq5iIlAALkZHPMgOcsXCtyrYOE
         +FKGAnWuQv6++Nez2exMU2CM1uzJDnjchHapBbJB6CTM42uilbQwNDrwT53wtDXm/a5V
         13MSEGaOeGMaj3b7DLNUvUvs5FjawPHCU6iGZUPvyisfb6p7zL0qgA6Zz9tec622OCUr
         2Ndw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790718807; x=1791323607;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RahMTkaht7nhK0P4I392N//nShuSxCC9bOhbGUFtS7w=;
        b=osusRiSYVJrFQ+kVF9zbnBbqunHztca09k2xeLZUov54XcqA7D8yeQX58vh7ftI4up
         mkv8CgQN8n2JCFHMg5C+MkkdK7RHm5LtYDOLqKUyq/iFqE8LYOS7GJLmaGPkVK9v10UT
         22V6M7BmU2sw3i2cO+FpGdpYlxBBB9ErzSrWu1PdnuwTNb66a7bnEJYyVKzo20Ok0wJ5
         Ev7oF4rcjzIqaKEyeluxQEWo4/aKyrbTz0dFG4ywATjvdDCttxnuWYhS74dz6LD+qeLQ
         sglleBKsCCa/Eq5Qr+ulAaFk4QyJNGBWLelMR1aUFj2UegLCP67Ob7isgFtrmSBJPeDZ
         v7Kg==
X-Forwarded-Encrypted: i=1; AKwUvBymElcytjReLrjaYCNYuE9nu5EF+nF8FcZ6M//Z7ALBlR3sC4RrRQfAj9qipr8NGJdT61kBkanNTA==@kvack.org
X-Gm-Message-State: AFuF++m46eQWhyTPjBaJGl1a4eRRIXz335rpI1DGOkOvK7/dfFh5Z3nm
	6lIRBhKVHrot5AqPulLmsaJ6Xba33MMADHG9vLaCunQz8fSKhKuHrdbi3Zzw0vUQPN6Eje/r2V7
	B/LC7Q3yDaKqYEdO8SW4h+A==
X-Received: from dlbqs7.prod.google.com ([2002:a05:7023:d07:b0:143:7820:3080])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:4286:20b0:14c:be8e:69eb with SMTP id a92af1059eb24-14cbe8e6ae4mr214250c88.7.1790718806743;
 Tue, 29 Sep 2026 14:53:26 -0700 (PDT)
Date: Tue, 29 Sep 2026 14:51:59 -0700
In-Reply-To: <20260929215206.516490-1-nilayvaish@google.com>
Mime-Version: 1.0
References: <20260929215206.516490-1-nilayvaish@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929215206.516490-9-nilayvaish@google.com>
Subject: [PATCH 08/15] mm/compaction: stop casting free pages to struct folio
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Greg Thelen <gthelen@google.com>, Roman Gushchin <kfree@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 43E6A160006
X-Rspam-User: 
X-Stat-Signature: ygiz1ka6xz5ofyawc1fez7ai8u8pnxi5
X-HE-Tag: 1790718808-430766
X-HE-Meta: U2FsdGVkX18d9OowjO2sHi9kBV2kXHWgCgWJc4dzKZOQvB/gwoDeoEyszWAzKGztXYBfbkWlqiul+AcZlie4BxAZnNLN7v5rYr3kJ0ZT5kJfZk9k3aIRMyVxE64XbhYYnG1mtD14ufsK4tojdkFdy1lgRZsAXmmap45YQIJWWhUjUp5vDQ0QhxNtqrDY4/7mFj1a3uZs/4QrlaZdk75b1SPOO4JhBB61y1zasJqlgMaPD2Vn7ulxTQWK7UItQqXer1CtqPcwExmGOLR4SrSwilzn48Fizw87m1tZ9Z0NRQyv84bgS7KOr7c2yK8q3VdquW2zAKPQ9/t2XmigWpwT08yJQVweg0WyzbYz1mQUf8lgug3FIAy1th/P4zSzdi23br1hOH1Yf1tGCOSzKFK4VcxPKQDCEKF9KTwD3HI9q3REselItAAF209FTDOmeNvqUVbJxFG9wN+qji0XVBogUrHG+/ZkfQohuklS07JhVQFv2g7mkIjCfxKvri7mUAEPIkQFEOPEH4uMkyaX5mgzNDeSp+Gw76bZfmEFbxoI/0qRpxGJZD7aiyEdWr0Pww3DFYSKbkY/8zEz6modHbeK6GcbXpXT1/YLfloguvKdtnaTFW6BV0ScQ9PpWNHBe0F0w6Xs4HAcXsAh3kbe99C5J12NnxXv9BIR8yqz7n62MlwSa0aiqHDg+1cfOaYQXzvIK3D1FI+2L96Dhl6acVkMC1aqBPdFlyvx4/nYKYQ8EECV9KlHHWq2fqTm7SYJtH4EG8OyQqPgnd1d8kpOYdbN+dqX9cyfUuF5+zfKg3p49PV08MaVHLpbDkRsDnvglW4y04HO1epypDlAYpA/yZ9dygEVFz2y1nLg76niaU2PpaWl9jaXczf/HQtLCSoqwI0yYi4CagF73rqLTUK8a1X3bjy+9pE6mpaov6HMAUP9Hm+Wo48VUNV14xym7pYq1y+H8gReIBAG9cLRChUii58
 SbxW/gfp
 AS3AlLDVQguIcI1wM++PzX2pJ8uWVauQ+M7impXrsphuIX3S30uoovtemqfPBVRAXYI/32Imn8x4oZsE/4TeZi2yrdNBySj/qojySGZnIiCpS667RzHABlexE8k5QhH1T4OBylu5fFqt7BXg3FeDO3z/i3emC0sxuWogTY5X8kg41EwVCf/jY9KR1CWDt3my2S7w3jImW6eet3fWNMzFjRdPBYMZjL+5irGN6X/Hqf8bhG4e9/2h3AmeiTb5vJmq3NyYu51u0thfNJsT9k11Nogw6nmV+n4QlQxGEWE6lqUriqzn3wAQThiOMLI0AL3MVB0wbEGQz8BnyqyEg+qeam8m4KwkYFrs70PXtBvJLqAdYfSfYkpqqlzaNjK4MPxaLKKMgDWEF8RGGe5pVpC5msKbr+7ntRuz/SMxaGWNinIXBFFJvXXxyZaXzJjyNFdbzNn++A41iC5T5pESI+dxKtEin+ksf74lqjcrR2Y3rIaskfPSFST5+SMM12Wcpwl8PdcBWmiQMA+xJAEChIUWZ+Ud+La9IsRr3aOBoPIpt7tOCtxBi6SnWGVnhD/j7cm8N+Dv6B9szIGB0cevBddKG5Fx2GcQjMXikS0NC3zgxLHr63HA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of the memdescs effort, struct folio will be allocated
separately from struct page and will no longer overlay the head page.

In compaction_alloc_noprof(), pass freepage directly to
post_alloc_hook(), set_page_refcounted(), prep_compound_page(), and
page_rmappable_folio() instead of casting freepage to struct folio *
prematurely and referencing &dst->page. In compaction_free(), use
folio_page(dst, 0) and add &page->lru to the struct page freelist
cc->freepages[order] after free_pages_prepare().

No functional change intended.

Assisted-by: LLM
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
 mm/compaction.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index f1b2060eb201..d708d973250a 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1845,7 +1845,6 @@ static void isolate_freepages(struct compact_control *cc)
 static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long data)
 {
 	struct compact_control *cc = (struct compact_control *)data;
-	struct folio *dst;
 	int order = folio_order(src);
 	bool has_isolated_pages = false;
 	int start_order;
@@ -1878,15 +1877,13 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 
 		list_add(&freepage[size].lru, &cc->freepages[start_order]);
 	}
-	dst = (struct folio *)freepage;
-
-	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, ALLOC_DEFAULT);
-	set_page_refcounted(&dst->page);
+	post_alloc_hook(freepage, order, __GFP_MOVABLE, ALLOC_DEFAULT);
+	set_page_refcounted(freepage);
 	if (order)
-		prep_compound_page(&dst->page, order);
+		prep_compound_page(freepage, order);
 	cc->nr_freepages -= 1 << order;
 	cc->nr_migratepages -= 1 << order;
-	return page_rmappable_folio(&dst->page);
+	return page_rmappable_folio(freepage);
 }
 
 static struct folio *compaction_alloc(struct folio *src, unsigned long data)
@@ -1903,10 +1900,10 @@ static void compaction_free(struct folio *dst, unsigned long data)
 {
 	struct compact_control *cc = (struct compact_control *)data;
 	int order = folio_order(dst);
-	struct page *page = &dst->page;
+	struct page *page = folio_page(dst, 0);
 
 	if (folio_put_testzero(dst) && free_pages_prepare(page, order)) {
-		list_add(&dst->lru, &cc->freepages[order]);
+		list_add(&page->lru, &cc->freepages[order]);
 		cc->nr_freepages += 1 << order;
 	}
 	cc->nr_migratepages += 1 << order;
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


