Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81C5CCD342D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 00:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770218E0014; Wed, 12 Nov 2025 19:09:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748118E0012; Wed, 12 Nov 2025 19:09:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C15A8E0014; Wed, 12 Nov 2025 19:09:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD7B8E0012
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:09:43 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DA7A712E22F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:42 +0000 (UTC)
X-FDA: 84103650204.26.C48B5D9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4806F100012
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:09:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BeG5DlQv;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762992581; a=rsa-sha256;
	cv=none;
	b=URwO8FjiiviyhB+uFRUYzmdJ9QkQ+irVEllIoXFMOLksb0xT+Wc/V9tDI+zUTarc+GuwS7
	cXRn3HAr82IV1tU7AlbrAckO6Dbxxivbv5qFjSTk2lBFGUgJDKh8WcAV+iIh1mG3Qa561i
	KSOAMsif/5msycgCoXs6ZhZ5bwG4+s8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BeG5DlQv;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762992581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PxZkdsw3AvExa2s+lE/wpoYA3pnAzbSC5CA5PV/sp7E=;
	b=YP2c4S+cHEiUWd4wQcOFx/MUoyUO57a6crnQaGYu4pJCQt6B4Byrz0Qy6bxSK7D6SDSEQB
	2bJkIZxIYGH4ipUkPX9f2BiGC0KWk8Nctp9hE/UYwAA6NoYGgTG44E8kwcqVGex/9DJSNe
	r0PMaTnBcYgT27PO0fR8ph0EBZpUU88=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=PxZkdsw3AvExa2s+lE/wpoYA3pnAzbSC5CA5PV/sp7E=; b=BeG5DlQvLMsI8zTq7f/ymzTUTo
	RXI366pSGQdULy0UCAI0at39JngyFgeOoXKLARXJgugslliJjiH+0ZIAhWbN1G1nirv29no66lzSe
	fm8zQXKEhHuQnWogDO7THGgMZbxkC5hDGUvtY+ACKU9h8z3ZJ77P1XfA5S5xg/Rwld0n4HUdWJcf8
	HPVJtwCJm53cizrhHEVKrDPdXdE5MG651Jkt6xSaJAidBeRVNgo1B5GIbsXrKDzxsqQILGV9Vyqff
	1OF9rr7QZfPMfDHaTdZOVPC5N5ShfTOHITMZ+VWtXZWy3zTxiArUSlrEkDnPBJ/E8DGdUJrsUeq7h
	wFAXBUqA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJKu7-00000006fPH-3R1L;
	Thu, 13 Nov 2025 00:09:35 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org
Subject: [PATCH v4 14/16] memcg: Convert mem_cgroup_from_obj_folio() to mem_cgroup_from_obj_slab()
Date: Thu, 13 Nov 2025 00:09:28 +0000
Message-ID: <20251113000932.1589073-15-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251113000932.1589073-1-willy@infradead.org>
References: <20251113000932.1589073-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4806F100012
X-Stat-Signature: yubj6txs7c6i78x6pkzfdc7yoqahr41a
X-HE-Tag: 1762992581-368092
X-HE-Meta: U2FsdGVkX196tCvR5P1fMw88vRv3u3/uoA335zBsr3IagLyzNQ3dK6qDhgKe/zJ3MNAgsHc8XT9Q1FpaZgVrYdu+5vk0K7QpQd1LtATaq+W0PNXRNPnKpCA0NGiiwGq4QsoYfOPDQlHYtzIo4+e/obNiQbH2nq7vr7epJqSjX8vUhLbAbwnOfXB+nIAhM/FWzf3k+KQxvS1BBDEkBaWrUWx7xSEyp/dAZFlDagT6WyRQcjME/oC2q64hMClEW1Ot9VcLGKbIDw7YXcHl6wz1KUda0LflGZPBT0lHhTN4pc4tlqACp1aqpeORLFv4APEXFlK+s/k5sLa6U41OFYz/uGgpF5m2ESSKmkxTlX7E2akrggLziEtdbRTu881uibspOLunWsUdej1dsLSxpZNLLfc7F5R3zginXNMaNsqaQflJxlFm/iFNuXhnM6LV/ApucF+ukOqC4raEVe9MiP4Ecj/ktdeCuZhxZS4ZlkGGmsoN/pJv7FMGm65fZVPQroJIG9JxSeuO2f+qlp3BPIPP4+H8vkP8yCvyVWzcf1oYk/drjohyRn+D7bLWATnj044mlSUSZdFOVtJYS5hjpRe+zhkxSi9DRBVSLZyPJ015uix6oApT14fHOqltbxTQFzQx4cwzf1PYHvFxcPLOI9N88fzMTVdlc1z2ekUB39StNz0TuhAw7Z0/jVEU71ydbD7L/KekCBbgOQHdgtgKx5nLcsAxM4wa1LxrsBbdCwEQTYvh3GkaHiCsRoNcVvqzs0FUN3GPIuewV46J7715dGFIJLzA+XvJzbEdkRj7+9TD05uK+zEsJFBw/OVh6BJQdpHqqBMtvRAapid5VptQpPkbv4HeAegpnuAnhgeFsegOTL3IonGF0J99Fd3SeNVDpz/uU1rHxPtItIh3TCBBZMOIjlSu+ovU1wgmfwxQloUmJ7dntClHCyD28ERYG15lmdP1OLFHB9LaFROGO756MnH
 6fkB20D9
 r4bBhjgMsu6IMjWrSl4A9FEqIz+GM+qkLHb3kKV8EZGq+3i2y005XvwQwqG5ihbr45G7b2UaMjbvHj1D9DCjyT5fVK1kIWeY6YSljel6LX2NeT06gLt4N1Ptb040wEjdV3MrFELJ5PIs4j302jp4T9uuXfngYlz4asPkSe5r9K1w20Vm2kx/PFDlg8eSamyoUBCFt19DOsacvlLqPK2/fkC3b1NA6EjadN529j4RRo0QXjxQvEgJqAXFcIGi7z/SxtRx2K5rnGtj0CVNpNco2Tu21LkFXVq4UTz1b1QuYdtEud9ievmWs3xE/w9SyiRfQnwqizEhea343/Ipm1CVMUYyK9mZicvZhvIm/aLn0iu2EuK7LoSmCslH+XiiPtT7lUoy2Sijtpoyuzm4=
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
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: cgroups@vger.kernel.org
---
 mm/memcontrol.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 025da46d9959..b239d8ad511a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2589,38 +2589,28 @@ static inline void mod_objcg_mlstate(struct obj_cgroup *objcg,
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
@@ -2637,7 +2627,7 @@ struct mem_cgroup *mem_cgroup_from_slab_obj(void *p)
 	if (mem_cgroup_disabled())
 		return NULL;
 
-	return mem_cgroup_from_obj_folio(virt_to_folio(p), p);
+	return mem_cgroup_from_obj_slab(virt_to_slab(p), p);
 }
 
 static struct obj_cgroup *__get_obj_cgroup_from_memcg(struct mem_cgroup *memcg)
-- 
2.47.2


