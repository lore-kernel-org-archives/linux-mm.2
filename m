Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFB35CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7B0F8E0110; Fri, 24 Oct 2025 16:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2D418E010F; Fri, 24 Oct 2025 16:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959058E0110; Fri, 24 Oct 2025 16:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 720158E010C
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:44:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 36E56140F5D
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:55 +0000 (UTC)
X-FDA: 84034186950.09.54F739C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id A18311C0012
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OMmTwOAc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBxqr1+coDaiUG+uvsbuuwD/Bi99bD+qPAzTVvSM2Ro=;
	b=6YHHI635kjLZIoV/GBOkxWePWqku7K3xyy7syMzxymYYqgoKQ+WDBiYDZeZNHm8Dld6LEZ
	zQ+R+Z2lw5uqW9sbsc+clICx0DE7Hs6FZrszkGzY36WBg+Qg8jrgD1P+cLIgaKWe2LRWZ8
	qGt49rlv0fzzsnYAOcDwOEl3/RAY2Do=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OMmTwOAc;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338693; a=rsa-sha256;
	cv=none;
	b=ZvXk/UTB7CujRJQoWPbR8/U+mBbnP17YERXJEQwLEVYJiV11Y8Mci8Ow/9EYZzdQ+BVuK0
	mWmW1FsuO3tuFW+ARth/KkJKzKjFBi0FF2as+fmvuzonOX21ij9E2MLpc8nMKup1lL5mBk
	BGE79CJXmuIiJLkC19/kViowTvXkyzI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=OBxqr1+coDaiUG+uvsbuuwD/Bi99bD+qPAzTVvSM2Ro=; b=OMmTwOAc8qMjEvnyB0Oc5wF179
	pLPsjNybZP0gUentzZ1rwLmQ8tmB1+4qc/iFO0Nm1T+mcEYvFCW3pw+94NrTgqWzNEa1ldxu0/S7D
	CH5Y5tBb7P0sa5LJL0Zb681Nv2YCuHBVjco8aq8a44QNuvUzqAfUDXhenIVqtf5+F91ZskamvwUhQ
	wrEqUBJmcxjZUcd5zD5TSNnc30xjGCMRM9mW3prXb12W+btF5TPfSj1RuFhZkrrTPptj4xc7Emqvx
	HkFBenIQVKbr/UtH+EGPBnQOgIpIHjcylo4+MkwKbkS85KsUA4gwUMO7wm0Ng4C0zgV9SyWQf0Ryx
	6JsimHGQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOeO-0000000AKUT-2ZsE;
	Fri, 24 Oct 2025 20:44:40 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v3 15/17] memcg: Convert mem_cgroup_from_obj_folio() to mem_cgroup_from_obj_slab()
Date: Fri, 24 Oct 2025 21:44:30 +0100
Message-ID: <20251024204434.2461319-16-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024204434.2461319-1-willy@infradead.org>
References: <20251024204434.2461319-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A18311C0012
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: zdzqq9tx5x1augmgxsbn148safm7hzdt
X-HE-Tag: 1761338693-359063
X-HE-Meta: U2FsdGVkX199GAuEIuWbHTgFI9WCPNInhnBiEF3JroJY9aGyBvttY20ZKquRqEcj1knpV5KfbIMBeDJfBvXf7l+XN5IUIIzlXCF7vo0irbuz1++Vw3A7GWcQHV/6ddsXxTHUohIUgECt+wkbVi+CwO5TiAbm/5FeKEoS+cbtmoKYD/eub3CIx2Z2Cm4e5zZ3rHdBpNXNMwq52j4SoRNe3NB1tF4Z1x1DJZgowJsnKquPJVXfgtn2Sq+77oUXYi6XUR9pDP+LWoTZAxB1jtP5qwsUzE7PZV1aYxZAmIYf1tex0WxL+9wc8GDKb8mJjfUGe9PPy1z2qMcRl51s2OSg6DQ7Eou/zzxuheUvD+3s2A4gHH1LQeJ1T4JAzXtcqimYi3G7yX0Sn4Qro1mpO9o9ctXGyK4KnXuSF47Ka9JGFIXm419IPpd/QBkOw08aS91nJcQJwk8cPf7RQxcLrjLQ/HHWPJydBgwv41QnnFDiBmu7H8pKtE1B7jZBINIf9b2F0/g/jsN7+N7Lw9SfZu/U/ux9bAqhbFQUDZW6KQcepwMjqPpWMGs2bILcLHs0h02Ic5cOdKR5hUYrtnw137SVl9NQxy7ot83yfb6F8ETJlKoQKSB43rwPG2BVrsfpibKAgBsPTbErWqO2GwpgvSB0/299vPGsM9gcJ0sMx/RWyehvTuHWn3TbkFZJ56vrcQTLD4+nZddunGEPhjgsBtMGyCyZAwCh/LMm+Mhrn6OTkbm66mfwC+0xiNlVvHCxvIidQrAXwH42PttUNZ7FJhIc82UuOjE6AekGUg4CMnSrJfzKleegousF2L+PcPWA2XAxdoPiaD09lmw16OzaHgWhYvs/cW4P3uS4oo2s3UeWO6hQVcfZ1gKJrLZ5R6Ci2ETfA8UsKrHnoU1ehPRaeg7nw2Iu1dj61uoPX5ireD8aEwf9XOej19CAI0wrh+aWaFKzBq4eCMSJRlfI17Wbu16
 RswNSLj4
 PxcrxyOB4k84m4QlVRpkEx6bapPTj39HNuU8I28532qh3lZGxr4G0QN7zR821ufsSu6Y13kDrylsnDm8y9c6rdfXV78+OB7rtYMVcZGX7NQL3Nh/xL1QDY038B2/n6vBbZsPMxoxLpBYB9D2T3+AMw2VXMBKWo4dWszHr9ImMPGJEvmh1W0OBS4pHXHAzQ9XDAcpgpk8+W3zy/Dc9VgOuCi60/igYn1ItCP6C1yjfe4seaOY=
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
index 1a95049d8b88..c3ba53b40375 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2558,38 +2558,28 @@ static inline void mod_objcg_mlstate(struct obj_cgroup *objcg,
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
@@ -2606,7 +2596,7 @@ struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
 	if (mem_cgroup_disabled())
 		return NULL;
 
-	return mem_cgroup_from_obj_folio(virt_to_folio(p), p);
+	return mem_cgroup_from_obj_slab(virt_to_slab(p), p);
 }
 
 static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
-- 
2.47.2


