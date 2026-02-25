Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9781FD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 164336B00A0; Wed, 25 Feb 2026 11:05:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1565E6B00A1; Wed, 25 Feb 2026 11:05:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06BAF6B00A2; Wed, 25 Feb 2026 11:05:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E3F646B00A0
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:05:11 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8510659FE9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:05:11 +0000 (UTC)
X-FDA: 84483453222.09.5A68530
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7F97D10001C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:05:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=psXGNg6g;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772035509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w2mHEadrI82HevMOqzNsydbPuFfL3JspAsXzk7QxJzo=;
	b=quP8wTtOexCJUAK+QFie6o0Rapuv/n8uZ0VPn1cfZEu+8+JWPeFaHaID8wudOspc5IaPhr
	nKd225e58bFLBScjPHDoA8WxpeAFWBNxiJ1uYaba4dPlVBFP4DX9uBnIypat5GzXhPGyZK
	pSOTR8x45Ns6ZZru6VwIJbshHU5lyQk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=psXGNg6g;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772035509; a=rsa-sha256;
	cv=none;
	b=22hl6wlEopHgst/JzAYB/jp596BiCBJ+7fSUBwlEk2vzqtP5hNeFrTjG/nJEtK1dxkrB3w
	V4Y/eoppRwqLYqixcKh3ibxCxcSWgwHEGWQC8yw2+QFaS9ZXlqj9xgESLfkmx3eK4qujvT
	joukh8oAobaK/CpihF9pUIjxlmdtrPs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w2mHEadrI82HevMOqzNsydbPuFfL3JspAsXzk7QxJzo=; b=psXGNg6g61/oc6WQCvMVMCNhlW
	3A9Yrcb4Am0HNGEvdPaEBgNrUXC5I+rl6pVamJKW4QoHB4Seq/37+igO7VVBTFCGvSvsyB/bud0Xm
	bn3pjm7CG2jQIymlbKrjsgSoy9bFqtovRFC6dLF4TWQeQjbXFq7t8lF1GgqVVS66a6/tTJinsZLkS
	Jou+WpE7fL6DAOFGeeNaU5R4yjlrdC15Gi9ZKExrs45vYY4U1r4DhOcCd4xc5KOMM/z8HdcDsoGte
	HLuKPN3rkMbeucb+NqJ1heauPS75JmW2H/bJPqKqYzasEpybXRBjc5KU6PbMaO+5Y0WtTSg2gDsSC
	yjPGunKA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvHNq-00000001Iny-2zuo;
	Wed, 25 Feb 2026 16:05:06 +0000
Date: Wed, 25 Feb 2026 16:05:06 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "ptdesc: remove references to folios from
 __pagetable_ctor() and pagetable_dtor()"
Message-ID: <aZ8dsnqAsAcGE34o@casper.infradead.org>
References: <20260225002434.2953895-1-axelrasmussen@google.com>
 <aZ8dasxUYuuWF9M1@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ8dasxUYuuWF9M1@casper.infradead.org>
X-Stat-Signature: am1gtn66mth9nrwc1sbc4mo6xanyccho
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F97D10001C
X-Rspamd-Server: rspam01
X-HE-Tag: 1772035509-489192
X-HE-Meta: U2FsdGVkX1/uspBp6qLZva5JeOtaYGjLGVZmPA/kVKytu3QWfTImWVQUNmJ8POFpEQslyWwN0015/Csz3TnVllgoSa7N+K31vf0GnRTkhjmkXH68/xZOgJkzNlP52LiO8Z/oOk4YpQJ9X7Y4ECEBg0jf6LSVsVX+INzRdAuMrFag93hoJ/RrawsQ+u0E/wdxJW4kpgwMwwGxmMLOneeuvP9YnQq3QGKYO9weZ8BP5MuW9gzfa0G/EV8ALjUeqGBOBEyrZoW70SxQeRQe68OIb3PwQ5o1IOzjhkhK8hEmbnGB5M88dxb9h16fRi6ApTbI+DjLQBYp+qeT+33Cq83XsXDgv5P30o4YMMkFOydyDpG7Nm7GJB4GJ3StouReo2CyUaF9xCE5zPBxb3j/iK9ZJzKXFHxNHr5H79n7OV2BHdEzUqXAAjd4MMria301ZO+eCAj7IdrgNNL/9EwAOKCP5x0vuYkaKFw6A2lh7Q5jRzHN7gw1XH5EHS/VDZNRKgqcyiAjE6yqXGRp3lXq0Jb8XyWvgwlse1Pq5K24BLrR3AjVaie1jGbd34Tf9PkHwpr1rW9hYq6X2WnGarQK53TUAKG3FK8sXqNA/gUbDa52SAVo0BXz2+Av5tTutZKPdB69IEt2/9WI0zgO0fwVjA5FLj8V5p7G+oka5GowPqK8Wgb/hDIZCx8SzGMdRXQ1MM5VxhHZmkivjilXxv5auTDvA8WjYeLzkD7MX7EkOZn1BHytClBGK48qXWzhCmUXcduS4lHaFNtKaiYVk7zD5FD6Y2zdwD83tEzKHh/oy4juGWZA2mCjl+uQ/jiUw3P0yHLisTNbF/3UFY+Q/VEMIUGmXyf+xk6Ty1ZOtWKMA6cQI8C6uC8OSoi8fgLEn8jAoQpNgKmEyHL0gY9J07UIXC70Wu7E8iP0gn4cMAVDId9RlBpI/NBW0OqxEhtb21jbJ/2ONu23PTGC/fcy7B68v+D
 OxAaCbo3
 RnQxMsnOA6JlvwpfkjJe7zUBHubQte12YnW3Cnfgj5+t+6q1nkUjULa+PedUOhNRlXyvkJ90zCeXZkq8yibYJMC0iVggrO5hHsW0Y1LQCtbi2gRE4GE17oOM8i0UH4asJKHuU91aHrnhsx1wxw9eXmqgth576P99F5wcV0lD1R/AWo4W4fYKVXGWoeh68HwOuJYATU/9ulyX9RckH+UqFzix3ppm/XY4CWb3FrHdLuaqM9Zdf+8XladN1aKbfS7o/S+AE19wAG96keiYU2rgyU2pg0gIDht2Lb85Jh4IRKDVgEB+nF/BZV0D9gltZ0sAh+VhbNjT9d3tlGVRfhckn7Hx81w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 04:03:54PM +0000, Matthew Wilcox wrote:
> On Tue, Feb 24, 2026 at 04:24:34PM -0800, Axel Rasmussen wrote:
> > This change swapped out mod_node_page_state for lruvec_stat_add_folio.
> > But, these two APIs are not interchangeable: the lruvec version also
> > increments memcg stats, in addition to "global" pgdat stats.
> > 
> > So after this change, the "pagetables" memcg stat in memory.stat always
> > yields "0", which is a userspace visible regression.
> > 
> > I tried to look for a refactor where we add a variant of
> > lruvec_stat_mod_folio which takes a pgdat and a memcg instead of a
> > folio, to try to adhere to the spirit of the original patch. But at the
> > end of the day this just means we have to call
> > folio_memcg(ptdesc_folio(ptdesc)) anyway, which doesn't really
> > accomplish much.
> 
> Thank you!  I hadn't been able to get a straight answer on this before.
> 
> You're right that there's no good function to call, but that just means
> we need to make one.  The principle here is that (eventually) different
> memdescs don't need to know about each other.  Obviously we're not there
> yet, but we can start disentangling them by not casting ptdescs back to
> folios (even though they're created that way).
> 
> Here's three patches smooshed together; I have them separately and I'll
> post them soon.

Argh, fatfingered the inclusion and ended up sending ...

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5be3d8a8f806..34bc6f00ed7b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3519,21 +3519,32 @@ static inline unsigned long ptdesc_nr_pages(const struct ptdesc *ptdesc)
 	return compound_nr(ptdesc_page(ptdesc));
 }
 
+static inline struct mem_cgroup *pagetable_memcg(const struct ptdesc *ptdesc)
+{
+#ifdef CONFIG_MEMCG
+	return ptdesc->pt_memcg;
+#else
+	return NULL;
+#endif
+}
+
 static inline void __pagetable_ctor(struct ptdesc *ptdesc)
 {
 	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
+	struct mem_cgroup *memcg = pagetable_memcg(ptdesc);
 
 	__SetPageTable(ptdesc_page(ptdesc));
-	mod_node_page_state(pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc));
+	memcg_stat_mod(memcg, pgdat, NR_PAGETABLE, ptdesc_nr_pages(ptdesc));
 }
 
 static inline void pagetable_dtor(struct ptdesc *ptdesc)
 {
 	pg_data_t *pgdat = NODE_DATA(memdesc_nid(ptdesc->pt_flags));
+	struct mem_cgroup *memcg = pagetable_memcg(ptdesc);
 
 	ptlock_free(ptdesc);
 	__ClearPageTable(ptdesc_page(ptdesc));
-	mod_node_page_state(pgdat, NR_PAGETABLE, -ptdesc_nr_pages(ptdesc));
+	memcg_stat_mod(memcg, pgdat, NR_PAGETABLE, -ptdesc_nr_pages(ptdesc));
 }
 
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 3cc8ae722886..e9b1da04938a 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -564,7 +564,7 @@ FOLIO_MATCH(compound_head, _head_3);
  * @ptl:              Lock for the page table.
  * @__page_type:      Same as page->page_type. Unused for page tables.
  * @__page_refcount:  Same as page refcount.
- * @pt_memcg_data:    Memcg data. Tracked for page tables here.
+ * @pt_memcg:         Memcg that this page table belongs to.
  *
  * This struct overlays struct page for now. Do not modify without a good
  * understanding of the issues.
@@ -602,7 +602,7 @@ struct ptdesc {
 	unsigned int __page_type;
 	atomic_t __page_refcount;
 #ifdef CONFIG_MEMCG
-	unsigned long pt_memcg_data;
+	struct mem_cgroup *pt_memcg;
 #endif
 };
 
@@ -617,7 +617,7 @@ TABLE_MATCH(rcu_head, pt_rcu_head);
 TABLE_MATCH(page_type, __page_type);
 TABLE_MATCH(_refcount, __page_refcount);
 #ifdef CONFIG_MEMCG
-TABLE_MATCH(memcg_data, pt_memcg_data);
+TABLE_MATCH(memcg_data, pt_memcg);
 #endif
 #undef TABLE_MATCH
 static_assert(sizeof(struct ptdesc) <= sizeof(struct page));
diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 3c9c266cf782..0da38ea25c97 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -518,7 +518,8 @@ static inline const char *vm_event_name(enum vm_event_item item)
 
 void mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val);
-
+void memcg_stat_mod(struct mem_cgroup *memcg, pg_data_t *pgdat,
+		enum node_stat_item idx, long val);
 void lruvec_stat_mod_folio(struct folio *folio,
 			     enum node_stat_item idx, int val);
 
@@ -536,6 +537,12 @@ static inline void mod_lruvec_state(struct lruvec *lruvec,
 	mod_node_page_state(lruvec_pgdat(lruvec), idx, val);
 }
 
+static inline void memcg_stat_mod(struct mem_cgroup *memcg, pg_data_t *pgdat,
+		enum node_stat_item idx, long val)
+{
+	mod_node_page_state(pgdat, idx, val);
+}
+
 static inline void lruvec_stat_mod_folio(struct folio *folio,
 					 enum node_stat_item idx, int val)
 {
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a52da3a5e4fd..8d9e4a42aecf 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -787,24 +787,27 @@ void mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 		mod_memcg_lruvec_state(lruvec, idx, val);
 }
 
+void memcg_stat_mod(struct mem_cgroup *memcg, pg_data_t *pgdat,
+		enum node_stat_item idx, long val)
+{
+	/* Untracked pages have no memcg, no lruvec. Update only the node */
+	if (!memcg) {
+		mod_node_page_state(pgdat, idx, val);
+	} else {
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
+		mod_lruvec_state(lruvec, idx, val);
+	}
+}
+
 void lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 			     int val)
 {
 	struct mem_cgroup *memcg;
 	pg_data_t *pgdat = folio_pgdat(folio);
-	struct lruvec *lruvec;
 
 	rcu_read_lock();
 	memcg = folio_memcg(folio);
-	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!memcg) {
-		rcu_read_unlock();
-		mod_node_page_state(pgdat, idx, val);
-		return;
-	}
-
-	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	mod_lruvec_state(lruvec, idx, val);
+	memcg_stat_mod(memcg, pgdat, idx, val);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(lruvec_stat_mod_folio);
@@ -812,24 +815,9 @@ EXPORT_SYMBOL(lruvec_stat_mod_folio);
 void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 {
 	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
-	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
 
 	rcu_read_lock();
-	memcg = mem_cgroup_from_virt(p);
-
-	/*
-	 * Untracked pages have no memcg, no lruvec. Update only the
-	 * node. If we reparent the slab objects to the root memcg,
-	 * when we free the slab object, we need to update the per-memcg
-	 * vmstats to keep it correct for the root memcg.
-	 */
-	if (!memcg) {
-		mod_node_page_state(pgdat, idx, val);
-	} else {
-		lruvec = mem_cgroup_lruvec(memcg, pgdat);
-		mod_lruvec_state(lruvec, idx, val);
-	}
+	memcg_stat_mod(mem_cgroup_from_virt(p), pgdat, idx, val);
 	rcu_read_unlock();
 }
 

