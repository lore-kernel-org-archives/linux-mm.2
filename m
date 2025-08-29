Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FB7CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6F9E8E0011; Fri, 29 Aug 2025 11:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADE478E0018; Fri, 29 Aug 2025 11:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94AA18E0014; Fri, 29 Aug 2025 11:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6F3828E0014
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:47:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3208C1607EE
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:47:41 +0000 (UTC)
X-FDA: 83830225122.08.EE01BDB
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8BB5716000F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:47:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XOpZykXp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756482459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oY9CpxCuu7VIslyzT8NQtX9cPt/p98lNJlRjbOnmf4s=;
	b=qws9LTpgvwva2Zx+i7zm9NwhIUmtIIU4n7RPUwD4z0bo7GF1d4IneqFrYjcyZYfYxDtNR+
	tp6M86wEewQoZSqltOk3eDFSlIkKwa0rR61nhcN36dKMqe8nYOe+zkg9ow4h6jasbBg6Cs
	7CdvS6Oshgr7DFXUaKf6MikTc5miZQc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=XOpZykXp;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756482459; a=rsa-sha256;
	cv=none;
	b=8OdKB6DdykjAi7qmGr0NhkmwbzMAz+5NFAvhsPrgoJLle+RX5hlWKl5rMx1bAuqagATsjG
	XYyLTw0mStCRzVJ1jTFeGA2OFHOxPLWnR6jzxBoV+TmUep+Q/qLkr9mD5Dv/49qQk88H3r
	+nLhtCcDI5WmkGo/xcTXwYAK3ujj2NA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=oY9CpxCuu7VIslyzT8NQtX9cPt/p98lNJlRjbOnmf4s=; b=XOpZykXpvdhd85l1hovio/dXdG
	ogXpVr1mi9wrCfQEG9CpuzJnP91SRth2m1j0W710sb+jEHtKKcYkQv3QE9Ukl7VAFjDpWp3H+oLLz
	PH9ndu2bewX5kbPqpScYbQp0+NwclBuYs7hXUuDN3xXkDIEqUXSMAqLTJZRHluoF3sWYKOxZ9GhXk
	QFBZ6rRtwGnn+931uvYRPSa0wIG2tx0lsA+k5cMDbTkIXPuGaIVbM26qoaY5VzeyTEWscGO/FlALE
	ngLGKATxG2V59JacWj9vGBiU/7cxGOKIdceMAjjOw888B9CpUAcrudnJRgKhKgYX5uZ9OHXAOdrlL
	Fsn3FIhQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K8-0000000EFyA-2SBG;
	Fri, 29 Aug 2025 15:47:32 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH 19/22] memcg: Convert mem_cgroup_from_obj_folio() to mem_cgroup_from_obj_slab()
Date: Fri, 29 Aug 2025 16:47:23 +0100
Message-ID: <20250829154728.3397606-20-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nhrdbcxghcdgpafsj9c5qhjzb4rouk39
X-Rspam-User: 
X-Rspamd-Queue-Id: 8BB5716000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1756482459-430762
X-HE-Meta: U2FsdGVkX18m+6JSDPppobWql6fYiJqsyaIifBn7ox+8SaVimMt5QULRx8JIReWXvKiRWPv0OH4NDcLvgTQeANmiiB81IMKsleDWYfgqnjyEmg9c8mWbXhJx/ved0YUuwd/n9Xt2GuzK2su53M+j+9yBcq63nq670iQ5kL8YkgGCYzDLxuj4R9fYOCGBeB3y03/1NHEJgaocgMAzr4G6uMfvMatjt08wUz3d76FPdjMB1xAy3uPIowzVIydcCTW+0TnBJqoiG0nftCUkkKPiLQ/VZB9UmJnayYf0VbRCATO5XBKs3GfH4CWFG5Uy8m02amfLGq34YX9Q5MTucjJ7kFCWb8m/1qUfoHiDQj+6PrE98soxeqhLle3Vgrc62VijOju1QRb6dE3BcKhukEZGOYP3cyB0+x+Z+1eJpTymsZtgZ18+hv5XHK4VdoEonQWDuOwV3++DcTbrDdNcyPmJ+AEhD9NMGqV6svUigRFAsWQGRB5XOcGxCWvLwUjqEtiDGwFKwRWbcm3hgrrCTRpV0xk/Nm+k9qo8AHALMTwJonUYLOwzL7ldTcQ/QgQEmYQus8MFIs0DMNxNKJqq9aY6d+PwyuPgbLc61NZ6Z4GzcpY8gM1aMX0K4DkBe3bsY20yesAdBEwPY9KjBlH3tdIf6gVtzJ0WiMgv85nmJZXB3XrZOGgcGK2QfpUIJl+kKwpktY+rCJE/NZdcVAX27KaIW9Dhzwkfsa7gdfT9GmxCdl9SXWWCwbVIz0R6UazUr02wm9vuNIMkSOgIiZVyFct7OgpiC8V++tR+ZgH/fY4yQ1W/rbJb+5U71cT10bOkM2C6ZuG8511v7nNnSxvzTdP+TNYtOPUerUIYi+cwAJgqrdvmQPLtNZQ2CVhdGy6Vt4LAlspAJX/VUl7+WphAy/MTsYBUQit7eTI7ck668Up+cPqX8w0qNp8k13OtZfo3t4jc8UlUO0Le2INreH2aW3T
 srZc5LKa
 Fif6oruJvs5/mwnfOtPsz4xlwYTvtRaf9DahZVgWGb+0ZPBjQ3hsu5ArhExOx4epR/qENrjXl3evpnlSgFbcYgovPS/rPeTmdvdYgpjNFQN4T5bfilpTr9DlOCqxmqnQSXXZkXyYQvYdcdmSyJFGi9qGQKIckpQxhQQrJ2q2HOA4pTavHdjmv1nwqFeRc15gcSUY3CycmoRW1GeHyX32GVVxGQk5EbTZwMJ8acdUSYe1th1w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for splitting struct slab from struct page and struct
folio, convert the pointer to a slab rather than a folio.  This means
we can end up passing a NULL slab pointer to mem_cgroup_from_obj_slab()
if the pointer is not to a page allocated to slab, and we handle that
appropriately by returning NULL.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/memcontrol.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 257d2c76b730..f72ec90ea365 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2555,38 +2555,28 @@ static inline void mod_objcg_mlstate(struct obj_cgroup *objcg,
 }
 
 static __always_inline
-struct mem_cgroup *mem_cgroup_from_obj_folio(struct folio *folio, void *p)
+struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
 {
 	/*
 	 * Slab objects are accounted individually, not per-page.
 	 * Memcg membership data for each individual object is saved in
 	 * slab->obj_exts.
 	 */
-	if (folio_test_slab(folio)) {
-		struct slabobj_ext *obj_exts;
-		struct slab *slab;
-		unsigned int off;
-
-		slab = folio_slab(folio);
-		obj_exts = slab_obj_exts(slab);
-		if (!obj_exts)
-			return NULL;
+	struct slabobj_ext *obj_exts;
+	unsigned int off;
 
-		off = obj_to_index(slab->slab_cache, slab, p);
-		if (obj_exts[off].objcg)
-			return obj_cgroup_memcg(obj_exts[off].objcg);
+	if (!slab)
+		return NULL;
 
+	obj_exts = slab_obj_exts(slab);
+	if (!obj_exts)
 		return NULL;
-	}
 
-	/*
-	 * folio_memcg_check() is used here, because in theory we can encounter
-	 * a folio where the slab flag has been cleared already, but
-	 * slab->obj_exts has not been freed yet
-	 * folio_memcg_check() will guarantee that a proper memory
-	 * cgroup pointer or NULL will be returned.
-	 */
-	return folio_memcg_check(folio);
+	off = obj_to_index(slab->slab_cache, slab, p);
+	if (obj_exts[off].objcg)
+		return obj_cgroup_memcg(obj_exts[off].objcg);
+
+	return NULL;
 }
 
 /*
@@ -2603,7 +2593,7 @@ struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
 	if (mem_cgroup_disabled())
 		return NULL;
 
-	return mem_cgroup_from_obj_folio(virt_to_folio(p), p);
+	return mem_cgroup_from_obj_slab(virt_to_slab(p), p);
 }
 
 static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
-- 
2.47.2


