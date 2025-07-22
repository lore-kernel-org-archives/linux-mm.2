Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD452C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 01:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B3B88E0009; Mon, 21 Jul 2025 21:50:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6642D8E0001; Mon, 21 Jul 2025 21:50:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553A18E0009; Mon, 21 Jul 2025 21:50:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41FA18E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 21:50:34 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F11F112E954
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:50:33 +0000 (UTC)
X-FDA: 83690221146.10.4B2829D
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 13EAF1C0003
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:50:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none);
	spf=softfail (imf21.hostedemail.com: 205.139.111.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753149032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZBiEu4oD5Yt2ppv+RSRu+vntcGFpeogMFX+JEFJ0P6E=;
	b=vMzk5Lza1Xe0oamd/DQ1lZO1zA1IcuczkaaffTqFpFFahKegldAfFpBnrWzGj+W/8Aaw3E
	zLmHlGXdgYnfvOuxYK13GOlxawT9LaLraX7QgtIrvglOUJ87qMCFwwfPN7O+gAKafRFAs/
	gwxDg8TkhA4f2T8J5IebSVx15b+2g7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753149032; a=rsa-sha256;
	cv=none;
	b=CCrN7/fjPF1f0s+QFR1b04FBk9eeVvT2sd93Xo4lhAkdmzVt9TAzSesrS2Ovn9ITcMBbzy
	Nr3fsTcNQ76N3smzlitFcp/0frW7Hw9V6PEnzX/msYs/Aqi/tVoazQ4jqykgkVthfoGYIf
	vW/+h5Mrv0HsoKDUmeIvSrr7SHSGB8s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none);
	spf=softfail (imf21.hostedemail.com: 205.139.111.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-u-f4WmpcOduKJNcHCKpeJQ-1; Mon,
 21 Jul 2025 21:50:28 -0400
X-MC-Unique: u-f4WmpcOduKJNcHCKpeJQ-1
X-Mimecast-MFC-AGG-ID: u-f4WmpcOduKJNcHCKpeJQ_1753149027
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EEFD519560B0;
	Tue, 22 Jul 2025 01:50:26 +0000 (UTC)
Received: from dreadlord.redhat.com (unknown [10.67.32.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8D5841966651;
	Tue, 22 Jul 2025 01:50:22 +0000 (UTC)
From: Dave Airlie <airlied@gmail.com>
To: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Christian Koenig <christian.koenig@amd.com>
Cc: Dave Chinner <david@fromorbit.com>,
	Kairui Song <kasong@tencent.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 06/15] ttm/pool: track allocated_pages per numa node.
Date: Tue, 22 Jul 2025 11:43:19 +1000
Message-ID: <20250722014942.1878844-7-airlied@gmail.com>
In-Reply-To: <20250722014942.1878844-1-airlied@gmail.com>
References: <20250722014942.1878844-1-airlied@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: T675B52RB_x0ORZyHEpNAsOoIe3PZ5yN6wdb_vqMWtk_1753149027
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=WINDOWS-1252; x-default=true
X-Stat-Signature: whkr386upsdz1qeeuz9ymbai8ewj7p3x
X-Rspamd-Queue-Id: 13EAF1C0003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753149031-342087
X-HE-Meta: U2FsdGVkX19l4e8MkEg8Pn3dKAxfr56BC9LQtwhZNI/NOCgVZ/XmOpHRAQl/mhza+6QkNfG7OMCdzowdiVCdYV6U/QD2dqoYv0v9ewqjIVfPTrV4e0DDnQnBCf9LN/pnDSfWeEzpIstsjQYoWbdnqH+9MT45QET9Mq/nQ69e+YiHklMdlchZdYtz+MuI63QTIEuO8V/TI88B2sJImZAZqYUfmohmyckc1LojQL1FIPX42jweAAk0R5ceFQnzVOAOZMzsHlazpc1pFEc4Bdl/PwB5OL4X5eiZ7yH4/BwjJOy2h9Dk4Y8oDN/tTbyLvujwQBJHBKVDDzOo9jzGWjBkRNkprJvM6+WBSOsofnmuoU7WJDmX60I/TP5IZIjgxRZ5z4jtGboTVQGJrWqdgh79MiyMimFAcCjSs/dbKtoMCtswXGI5Pox2FpOLRpywdRIaMwsSRKkD6CHVJYal59NUxEyB+fYYmdqJUsFxI9QJU8CsgZ4M07lzAQvcGNF10X8Ie7JdIsRi2E1M2yGoN+T/JSGHSQCNv9wzU+rFse+GGIkGkCNd+NFcSTqNJ9Aa8gHsppNynF9B3GpzE3la6zay+ld80jh215v2uSHG7Y2T9HD80NL3XjKlfso7v3lcxltykwlfXH1QmwaoELacP991L5udsIBaR+wphU79mI9E8Bu0Q+Okt362n5YQxIwzy4VdGIUM7vxXzbOeSLVjBxdq/JdLTrW/j7r++AQHBkWci+V9mb1Q+8DmCdHX2HGmdAe3UJR0BBGPq8JraYqVj+j57UjAx1H99Mos+AjdqyjdeQEzjytBJwQcbr1ssq+0+fehBq+mx6mdKGj9X065gE+TLAeY9ATipDV1QYE5CnACzZTNTkgkWCDwsbbPpvZySEeo2ji0rq/WpWfXUKaw67nvoub53Wh8VJEHg4HT5UL02dVh3PKpUtvydICgyOvgbiuEMwOqugcj8ALy9viuvzM
 RhkI65Os
 +nstBb/WSyaIcyV0QdIe/in6jFv0BlwaPhSVjovma5BDjWJAHqib2Sb3phQXwsawOTA1QiecVTbM6aBuVORYRi1hAxE8zI56JkttMo334m9T6P8aRDBOepPqOIagL3/rqPtia2t6GCy+vHf23ncCmqOwtvQKReNZyk9RcKwDaM5JmZhd32oyIlQbsILlkSxdA4oQ60FCSfA7jqNHLTxAsYmxOWoglwy72vcUK2TMZ5TIlkGbFNUuEfy3Z1qQzbAc5n/cLRHpAGoR8mmgce3ur1Xj32jg8mIfpqy58AvgGD0akt7nTyEwPzP+QQ2bcdeB5UqnqfSJF5whk3TXNXCTjmvp2KvV1F6dWSIgVupzTsuIixD10qYTLJ07pl0XAtEGWS8yu44ohNrFjCa7P8hQklhrv7ulcZv9ih0BMwice3wJmmdKoDr5XKpoZzCuLBQ5ACCXY4c8hoRvkQXtCVHFE2o0ygEm+qW3XhgB93GrEeC5D/jk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Airlie <airlied@redhat.com>

This gets the memory sizes from the nodes and stores the limit
as 50% of those. I think eventually we should drop the limits
once we have memcg aware shrinking, but this should be more NUMA
friendly, and I think seems like what people would prefer to
happen on NUMA aware systems.

Cc: Christian Koenig <christian.koenig@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/ttm/ttm_pool.c | 60 +++++++++++++++++++++++++---------
 1 file changed, 45 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.=
c
index ae46aa370545..bd08667c9cfb 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -115,10 +115,11 @@ struct ttm_pool_tt_restore {
=20
 static unsigned long page_pool_size;
=20
-MODULE_PARM_DESC(page_pool_size, "Number of pages in the WC/UC/DMA pool");
+MODULE_PARM_DESC(page_pool_size, "Number of pages in the WC/UC/DMA pool pe=
r NUMA node");
 module_param(page_pool_size, ulong, 0644);
=20
-static atomic_long_t allocated_pages;
+static unsigned long pool_node_limit[MAX_NUMNODES];
+static atomic_long_t allocated_pages[MAX_NUMNODES];
=20
 static struct ttm_pool_type global_write_combined[NR_PAGE_ORDERS];
 static struct ttm_pool_type global_uncached[NR_PAGE_ORDERS];
@@ -289,6 +290,7 @@ static void ttm_pool_unmap(struct ttm_pool *pool, dma_a=
ddr_t dma_addr,
 static void ttm_pool_type_give(struct ttm_pool_type *pt, struct page *p)
 {
 =09unsigned int i, num_pages =3D 1 << pt->order;
+=09int nid =3D page_to_nid(p);
=20
 =09for (i =3D 0; i < num_pages; ++i) {
 =09=09if (PageHighMem(p))
@@ -299,10 +301,10 @@ static void ttm_pool_type_give(struct ttm_pool_type *=
pt, struct page *p)
=20
 =09INIT_LIST_HEAD(&p->lru);
 =09rcu_read_lock();
-=09list_lru_add(&pt->pages, &p->lru, page_to_nid(p), NULL);
+=09list_lru_add(&pt->pages, &p->lru, nid, NULL);
 =09rcu_read_unlock();
-=09atomic_long_add(1 << pt->order, &allocated_pages);
=20
+=09atomic_long_add(num_pages, &allocated_pages[nid]);=09
 =09mod_lruvec_page_state(p, NR_GPU_ACTIVE, -num_pages);
 =09mod_lruvec_page_state(p, NR_GPU_RECLAIM, num_pages);
 }
@@ -328,7 +330,7 @@ static struct page *ttm_pool_type_take(struct ttm_pool_=
type *pt, int nid)
=20
 =09ret =3D list_lru_walk_node(&pt->pages, nid, take_one_from_lru, (void *)=
&p, &nr_to_walk);
 =09if (ret =3D=3D 1 && p) {
-=09=09atomic_long_sub(1 << pt->order, &allocated_pages);
+=09=09atomic_long_sub(1 << pt->order, &allocated_pages[nid]);
 =09=09mod_lruvec_page_state(p, NR_GPU_ACTIVE, (1 << pt->order));
 =09=09mod_lruvec_page_state(p, NR_GPU_RECLAIM, -(1 << pt->order));=09=09
 =09}
@@ -367,7 +369,7 @@ static void ttm_pool_dispose_list(struct ttm_pool_type =
*pt,
 =09=09struct page *p;
 =09=09p =3D list_first_entry(dispose, struct page, lru);
 =09=09list_del_init(&p->lru);
-=09=09atomic_long_sub(1 << pt->order, &allocated_pages);
+=09=09atomic_long_sub(1 << pt->order, &allocated_pages[page_to_nid(p)]);
 =09=09ttm_pool_free_page(pt->pool, pt->caching, pt->order, p, true);
 =09}
 }
@@ -925,11 +927,13 @@ int ttm_pool_restore_and_alloc(struct ttm_pool *pool,=
 struct ttm_tt *tt,
  */
 void ttm_pool_free(struct ttm_pool *pool, struct ttm_tt *tt)
 {
+=09int nid =3D ttm_pool_nid(pool);
+
 =09ttm_pool_free_range(pool, tt, tt->caching, 0, tt->num_pages);
=20
-=09while (atomic_long_read(&allocated_pages) > page_pool_size) {
-=09=09unsigned long diff =3D page_pool_size - atomic_long_read(&allocated_=
pages);
-=09=09ttm_pool_shrink(ttm_pool_nid(pool), diff);
+=09while (atomic_long_read(&allocated_pages[nid]) > pool_node_limit[nid]) =
{
+=09=09unsigned long diff =3D pool_node_limit[nid] - atomic_long_read(&allo=
cated_pages[nid]);
+=09=09ttm_pool_shrink(nid, diff);
 =09}
 }
 EXPORT_SYMBOL(ttm_pool_free);
@@ -1189,7 +1193,7 @@ static unsigned long ttm_pool_shrinker_scan(struct sh=
rinker *shrink,
 =09do
 =09=09num_freed +=3D ttm_pool_shrink(sc->nid, sc->nr_to_scan);
 =09while (num_freed < sc->nr_to_scan &&
-=09       atomic_long_read(&allocated_pages));
+=09       atomic_long_read(&allocated_pages[sc->nid]));
=20
 =09sc->nr_scanned =3D num_freed;
=20
@@ -1200,7 +1204,7 @@ static unsigned long ttm_pool_shrinker_scan(struct sh=
rinker *shrink,
 static unsigned long ttm_pool_shrinker_count(struct shrinker *shrink,
 =09=09=09=09=09     struct shrink_control *sc)
 {
-=09unsigned long num_pages =3D atomic_long_read(&allocated_pages);
+=09unsigned long num_pages =3D atomic_long_read(&allocated_pages[sc->nid])=
;
=20
 =09return num_pages ? num_pages : SHRINK_EMPTY;
 }
@@ -1237,8 +1241,12 @@ static void ttm_pool_debugfs_orders(struct ttm_pool_=
type *pt,
 /* Dump the total amount of allocated pages */
 static void ttm_pool_debugfs_footer(struct seq_file *m)
 {
-=09seq_printf(m, "\ntotal\t: %8lu of %8lu\n",
-=09=09   atomic_long_read(&allocated_pages), page_pool_size);
+=09int nid;
+
+=09for_each_node(nid) {
+=09=09seq_printf(m, "\ntotal node%d\t: %8lu of %8lu\n", nid,
+=09=09=09   atomic_long_read(&allocated_pages[nid]), pool_node_limit[nid])=
;
+=09}
 }
=20
 /* Dump the information for the global pools */
@@ -1332,6 +1340,22 @@ DEFINE_SHOW_ATTRIBUTE(ttm_pool_debugfs_shrink);
=20
 #endif
=20
+static inline uint64_t ttm_get_node_memory_size(int nid)
+{
+=09/* This is directly using si_meminfo_node implementation as the
+=09 * function is not exported.
+=09 */
+=09int zone_type;
+=09uint64_t managed_pages =3D 0;
+
+=09pg_data_t *pgdat =3D NODE_DATA(nid);
+
+=09for (zone_type =3D 0; zone_type < MAX_NR_ZONES; zone_type++)
+=09=09managed_pages +=3D
+=09=09=09zone_managed_pages(&pgdat->node_zones[zone_type]);
+=09return managed_pages * PAGE_SIZE;
+}
+
 /**
  * ttm_pool_mgr_init - Initialize globals
  *
@@ -1343,8 +1367,14 @@ int ttm_pool_mgr_init(unsigned long num_pages)
 {
 =09unsigned int i;
=20
-=09if (!page_pool_size)
-=09=09page_pool_size =3D num_pages;
+=09int nid;
+=09for_each_node(nid) {
+=09=09if (!page_pool_size) {
+=09=09=09uint64_t node_size =3D ttm_get_node_memory_size(nid);
+=09=09=09pool_node_limit[nid] =3D (node_size >> PAGE_SHIFT) / 2;
+=09=09} else
+=09=09=09pool_node_limit[nid] =3D page_pool_size;
+=09}
=20
 =09spin_lock_init(&shrinker_lock);
 =09INIT_LIST_HEAD(&shrinker_list);
--=20
2.49.0


