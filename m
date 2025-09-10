Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5C2BCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 355E58E000C; Wed, 10 Sep 2025 10:31:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 306BF8E0003; Wed, 10 Sep 2025 10:31:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243498E000C; Wed, 10 Sep 2025 10:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11FE58E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:31:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C59731408F9
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:31:23 +0000 (UTC)
X-FDA: 83873578446.26.C53BE97
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 31161120011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:31:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bJzuPBCY
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757514682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oY9CpxCuu7VIslyzT8NQtX9cPt/p98lNJlRjbOnmf4s=;
	b=vfW/oBMW/xHLJywIW2lnPaXNlbWCXVbNFabkzbZnNvgqvxaXd0JDRgLLntrvp+KSCUq2zC
	jK+YCLk+7nkjYY8bi+xM4babgSRLaEEkQ8MteymnEPrWakUK2fUkJ7M/FwfV5Bdb73FSED
	dR5UIws1lWvRDX+xRIjKrwBN/diTTvE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bJzuPBCY;
	spf=none (imf29.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757514682; a=rsa-sha256;
	cv=none;
	b=Z3l/Xu6HRS3xINtzzkdcsGy4f9+AsqAm2lk6/22jG6K3a4Fggioclj4juvBWV29hzFdWaR
	1uWenE830SjI+CtBpgWuhi7srZmL742MKCUHgSFD6nnh8WVfGU/nDUjeIo77deDbFFCKlj
	1bOM/GBLUn9N1vN+b8/xF8EvY3FiseI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=oY9CpxCuu7VIslyzT8NQtX9cPt/p98lNJlRjbOnmf4s=; b=bJzuPBCYqjKYFVogbJ3qqi/FIe
	C0uu1eTHz3OAAkLZ8HAcwj7KCF+BGG3bAghHgisL5QPHWwzNu+oEviIotT1iSdhtqbp2MOkXwCtkP
	wWgfg5LZ6CwpVekd/oR8cqZa+fpRot6JzIY9Ws4eu3fyGO7mf1pPAoifGJ1SvitP5gDvQPT5r9tQ9
	761RkRKYv7DyMoNzEraH+O5a5hqyJWOPtkXEc1be88ArmjPYxxYpz8+JZtTkcwpjRFPFJQJDp6TVy
	jzHt9hp4aoyn9oM6Dk2AZH8P7syFHsaacMbUJfmRogBHHTdoGYkZLIy6iz5KmiLXkhf20+KjaINg5
	jniOEbKA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPq-00000008MFb-2veg;
	Wed, 10 Sep 2025 11:55:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v2 19/22] memcg: Convert mem_cgroup_from_obj_folio() to mem_cgroup_from_obj_slab()
Date: Wed, 10 Sep 2025 12:55:01 +0100
Message-ID: <20250910115507.1991829-20-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 31161120011
X-Stat-Signature: tik43u3fa7iu4ect639z8h5psj134ox7
X-HE-Tag: 1757514681-143056
X-HE-Meta: U2FsdGVkX18bdFzf4PT08lWKsOpkyu/XmoaVux+mtsLnuQod+HOZ9kUPcD6o1rjvcWjyy/pyiUz5IOt3oixgF5NT7oUPImRpzf6Q6jnyh211uszCbpQIuGQqpAfj8lOEwdQQs47Bt0+7rqqpjCEgfr/XMb5BZUOagAstYpbyYKsla8soT0vbHAU2MQ62ve2ti/NNQB64F2kma9ynFd3nI1RPEGPj7qeGWegZUQ7VpwcXI1CwZ1to8ROCQdU9lXH3whx7seyxV6bZ848n9MmDaH5ouvhA9aLFbFaI7/3012TESsjwKj2aOvSWO4SMBcEcsSuTzS57yPTuSjpe/PDUUnUhZiE2RXGapvVYqFOWLU6qjelKFTo5460f4lrWO680DQrR/VG68CqQwQf/kmq5mlffBA/nwsBAjEmCLIngoqHMqX8CDAa4RcBdC5rt0miAkwJPIvoI3tJE70yvXx/hPhYTLemibgruoyN1AJzS/bf5qUCZfJdva36eNeJDQHE7GPt01Jnso48An7FLBEcdToGGzDVY8wcFgYPeV5BCa+Rp9DVBX0oS5DnTnT1hKf2ZMpxRooVIscKHLuiyLn59R0nHAXqXVF08cHnldCwCpYoGZZTyrWRA39rfriKDpxoH7LVEhON/pH8HfX3oy2ISGbu30DAfzba+clOVcuXwho/DSnwf4axwxEk+YhDr1DGdvkkPvGEg3FnLt9UmaO5cE+p/YWXtOqqq7EEVklUlqonEbiIBCCSshTwrSBRNuB/EKjCsy6s9ANu5aqj1kqfPHqDKIIql5TJ9H9VsYA/msvtrxgEqtPGaCQdercIU9TXoXZuu8rAgdauH3F02bkQWBKPdTBnpnOIebRIes8DqlDLz8WiREcfvcMa2Ni92sHYuvbCL9t+Mz9N4HtIi8+/ipHQ2UvTNh+w7UvXYHlpvBINsv+qps8EMkj4zAwWVSe7cK5jNhyPk7IQDYkGHqMz
 /NWnQ58X
 F5wLnfE8uovdWPCvqXBaWp7qwtZJ4UK2G2JjSoVF/CHnhKppFlxbJWTER8v5t+97WDpywq+Y7TwWW9a+M/KYTwR0oGyXmEB/jB+rS8yoGPQRk1SgnEGMS0zsrXLEguXfMShz1AZcao4IjHtN+Qd+L1pz04dWocZVbOBcHvO0/gC2YxMYKvrLoLmF4RVnluD1Xc44rNVNNTqTEATghJJ7F2YSRION06oeu6r6eyOlOBjXCa0Q=
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


