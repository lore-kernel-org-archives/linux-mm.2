Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A35C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 01:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 554348E0005; Mon, 21 Jul 2025 21:50:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503F68E0001; Mon, 21 Jul 2025 21:50:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2DB8E0005; Mon, 21 Jul 2025 21:50:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2A8428E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 21:50:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD33D140210
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:50:13 +0000 (UTC)
X-FDA: 83690220306.03.36C0884
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id F293980003
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:50:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=softfail (imf02.hostedemail.com: 205.139.111.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753149012; a=rsa-sha256;
	cv=none;
	b=mmWjDyW/ZDD5JrOzWICCbSu2tyscPJThWerfpxfQ5NqRU4CvqEV4akT6N4ESsiz9vUsy0s
	PcuqgxmseJYexXWyGCn6ZCdR6M9wQLFWbc18E55a6EMR0J4Ol+cznRSzAkOz7+ixXXmzhU
	ZXMzkMCy7tOSQ6l2/sghzL1leJJ8UBE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=softfail (imf02.hostedemail.com: 205.139.111.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753149012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=caFuM8AG71ujw4Je2WJcEVo/nw5cimqw0Invn9LBv5U=;
	b=MixMCOWMRFM3boQH6iqJgUVjSw9/mr5No1jNi3mUZ7ydRCqizaLIBUqlIV+Zj2FBuxyPyU
	WXIic+ttHUxwLfpzHsg6+YXqiYDs+w6PQDO8BJR78lrZcXw/2oAktxU+LgPefFtTNN3TNg
	jFbI239EXAyEfwunPSYJeeTFWbZNlEc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-632-D4C7eHe7PzOlEekcRbmq5w-1; Mon,
 21 Jul 2025 21:50:07 -0400
X-MC-Unique: D4C7eHe7PzOlEekcRbmq5w-1
X-Mimecast-MFC-AGG-ID: D4C7eHe7PzOlEekcRbmq5w_1753149006
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CCDB9180028C;
	Tue, 22 Jul 2025 01:50:05 +0000 (UTC)
Received: from dreadlord.redhat.com (unknown [10.67.32.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 63C2A19560A3;
	Tue, 22 Jul 2025 01:49:59 +0000 (UTC)
From: Dave Airlie <airlied@gmail.com>
To: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Christian Koenig <christian.koenig@amd.com>
Cc: Dave Chinner <david@fromorbit.com>,
	Kairui Song <kasong@tencent.com>,
	Dave Airlie <airlied@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 02/15] drm/ttm: use gpu mm stats to track gpu memory allocations. (v4)
Date: Tue, 22 Jul 2025 11:43:15 +1000
Message-ID: <20250722014942.1878844-3-airlied@gmail.com>
In-Reply-To: <20250722014942.1878844-1-airlied@gmail.com>
References: <20250722014942.1878844-1-airlied@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GfyACQNX7j9f2X5H04Hi87cQhOjS9T7s39rHlf6nDLg_1753149006
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=WINDOWS-1252; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F293980003
X-Stat-Signature: bpe4rthrpbi36dcbziwj4781tubwefd9
X-HE-Tag: 1753149011-429729
X-HE-Meta: U2FsdGVkX1/kksWjtK0v1+4/DieWUBXS4pve9NJX4QmJ/mb3N1GWnqi2zMUjEXcgry8KtgbNVT747Xwxpx9cLmnUMh+FRkOQys3S2q8ivLDF/X7u9PGHnCMI4x9zekdlEbzsIuO3v/tI7dVo23mMNwM6zojI+zNRVe6odY9zaRTsHa29Q4Smy0uDrdsTCBfHmuMr5mFA9wV7+MucB+HD6sDvHwr0Kuj4iVvmVEhaJ6U+4ZwAsiWKA3ZNjm32/yC0PlU8AzHe4vbitGTK0q1+YFq7DIQXoV9m85xms923f1Cp8JTpMgQSG4V9gNWWePQfBcliq50k9k2fuTNBMsjOA++qRRAsj7gz3FnSHAWvAvHlSgIAfBSiFpVyqRhomWo63Otq9Lb1DYkRiIELyBjjZcUlrlnNsXFqn2yOaeaCZQ3VdLnNCYR6ORUcA8iIeyy6Xez1ZlY9jd9GAweSA33uQWm/Ov5cjPlJDZW/AADHXRivBeEjJ83ObILihX2QSnQkW68tTLjiABwl3MaVBNQSNa52lAObHol7ffeMQisREAxoSv6fEFHg3iO0Pk3wiLxQFChaN5eILc+fNil+IQbnqRG5td7SekTirk48m6YKNjf9/0sRzqiAb4qgyKFRFQLTKJ6obI/giweiS1KHYwRqkO0YS+YpKBkmuEeTP5s14QE2JtBWFCT2UBmNUmNXfOOCT0sPnJFvIR+OA1vvzh19u/UAJxljpLKIJIYqHKw61Vn3qing87IhC9qJQZBj/sE8KSYd9gMRB7+mz2TFTjeKzkVYGwvzUKL5dVs8RvSoPUZSybaShzQhvjyrkgFE51VlX06Mb0muanWq3FKqOYLJVmXwdPJTBjK5QP52fT/1Oyq8i68DJ644x8kB+JT5DmHXre9TDNTUiADk7HqvS8xmbTqsyD4EbNabtXMw1lNDl6XpaV0FgvNXVgsmbb1S8U530oEGoAAt5/Eb74LfRhD
 2pIn515f
 FzPv2CYusN8MTXnuracu5l/j81PLp9jzGqfQdFlzTleivFSB+EVl+BHgmpFu36IxEnzb+W6UN4Ltw4Z8OSX3kQ7peiqKHwh9G/eWhrG6dw1Gto0km2Bc2tki+G/uBYnq36fOa5jPU/0guMFO7T67+kLlSfKH37w5Otz85y5P3nMnQB15O1q4OYzNoaWitfGjYjPfo8XomPM728DbgMpE0JmSQLr6YIImSJUEsnQv0U86I1K5Bjpe1vH+nVW6qftlGr6sgOp/802ETCOmBreuqzDUg0ITk4EinO3Pe/CG4L6dpg5//UYXbUP0qpGTdPz22cSMwqDNO813yKmXcciwpTl1pyTwz23MqWI2h59iiM8YUbX7s+5hwYmGwt5cBIpt08bYLp/pyUTXZW6+o+98gxlIWr4zZ/P2dNom2kt7JxKHsarOLbbIcHn3Q6tq1wbeQOctht5zIO3MRrBrTmOWGtM+iDNxw3EPZf/uCEDbhiOP+PJ7f0HqLrJ9dBkseWl0tkIPH85+wY+Pt+t4LjMkBt9qXn9SPl1ZbOFU+pKD1qyBWI8XUKvDrjrKlyyxayi0l5fia9xySCq1bScbycgIbXXrlTUBIBWRoCrD2B0m1uoltDju2nsS21F4vnxKA+TbWHTZrtxsntJDl0io=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Airlie <airlied@redhat.com>

This uses the newly introduced per-node gpu tracking stats,
to track GPU memory allocated via TTM and reclaimable memory in
the TTM page pools.

These stats will be useful later for system information and
later when mem cgroups are integrated.

Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>

---
v2: add reclaim parameters and adjust the right counters.
v3: drop the nid helper and get it from page.
v4: use mod_lruvec_page_state (Shakeel)
---
 drivers/gpu/drm/ttm/ttm_pool.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.=
c
index baf27c70a419..148c7530738d 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -150,8 +150,10 @@ static struct page *ttm_pool_alloc_page(struct ttm_poo=
l *pool, gfp_t gfp_flags,
=20
 =09if (!pool->use_dma_alloc) {
 =09=09p =3D alloc_pages_node(pool->nid, gfp_flags, order);
-=09=09if (p)
+=09=09if (p) {
 =09=09=09p->private =3D order;
+=09=09=09mod_lruvec_page_state(p, NR_GPU_ACTIVE, 1 << order);
+=09=09}
 =09=09return p;
 =09}
=20
@@ -186,7 +188,7 @@ static struct page *ttm_pool_alloc_page(struct ttm_pool=
 *pool, gfp_t gfp_flags,
=20
 /* Reset the caching and pages of size 1 << order */
 static void ttm_pool_free_page(struct ttm_pool *pool, enum ttm_caching cac=
hing,
-=09=09=09       unsigned int order, struct page *p)
+=09=09=09       unsigned int order, struct page *p, bool reclaim)
 {
 =09unsigned long attr =3D DMA_ATTR_FORCE_CONTIGUOUS;
 =09struct ttm_pool_dma *dma;
@@ -201,6 +203,8 @@ static void ttm_pool_free_page(struct ttm_pool *pool, e=
num ttm_caching caching,
 #endif
=20
 =09if (!pool || !pool->use_dma_alloc) {
+=09=09mod_lruvec_page_state(p, reclaim ? NR_GPU_RECLAIM : NR_GPU_ACTIVE,
+=09=09=09=09      -(1 << order));
 =09=09__free_pages(p, order);
 =09=09return;
 =09}
@@ -288,6 +292,9 @@ static void ttm_pool_type_give(struct ttm_pool_type *pt=
, struct page *p)
 =09list_add(&p->lru, &pt->pages);
 =09spin_unlock(&pt->lock);
 =09atomic_long_add(1 << pt->order, &allocated_pages);
+
+=09mod_lruvec_page_state(p, NR_GPU_ACTIVE, -num_pages);
+=09mod_lruvec_page_state(p, NR_GPU_RECLAIM, num_pages);
 }
=20
 /* Take pages from a specific pool_type, return NULL when nothing availabl=
e */
@@ -299,6 +306,8 @@ static struct page *ttm_pool_type_take(struct ttm_pool_=
type *pt)
 =09p =3D list_first_entry_or_null(&pt->pages, typeof(*p), lru);
 =09if (p) {
 =09=09atomic_long_sub(1 << pt->order, &allocated_pages);
+=09=09mod_lruvec_page_state(p, NR_GPU_ACTIVE, (1 << pt->order));
+=09=09mod_lruvec_page_state(p, NR_GPU_RECLAIM, -(1 << pt->order));
 =09=09list_del(&p->lru);
 =09}
 =09spin_unlock(&pt->lock);
@@ -331,7 +340,7 @@ static void ttm_pool_type_fini(struct ttm_pool_type *pt=
)
 =09spin_unlock(&shrinker_lock);
=20
 =09while ((p =3D ttm_pool_type_take(pt)))
-=09=09ttm_pool_free_page(pt->pool, pt->caching, pt->order, p);
+=09=09ttm_pool_free_page(pt->pool, pt->caching, pt->order, p, true);
 }
=20
 /* Return the pool_type to use for the given caching and order */
@@ -383,7 +392,7 @@ static unsigned int ttm_pool_shrink(void)
=20
 =09p =3D ttm_pool_type_take(pt);
 =09if (p) {
-=09=09ttm_pool_free_page(pt->pool, pt->caching, pt->order, p);
+=09=09ttm_pool_free_page(pt->pool, pt->caching, pt->order, p, true);
 =09=09num_pages =3D 1 << pt->order;
 =09} else {
 =09=09num_pages =3D 0;
@@ -475,7 +484,7 @@ static pgoff_t ttm_pool_unmap_and_free(struct ttm_pool =
*pool, struct page *page,
 =09if (pt)
 =09=09ttm_pool_type_give(pt, page);
 =09else
-=09=09ttm_pool_free_page(pool, caching, order, page);
+=09=09ttm_pool_free_page(pool, caching, order, page, false);
=20
 =09return nr;
 }
@@ -780,7 +789,7 @@ static int __ttm_pool_alloc(struct ttm_pool *pool, stru=
ct ttm_tt *tt,
 =09return 0;
=20
 error_free_page:
-=09ttm_pool_free_page(pool, page_caching, order, p);
+=09ttm_pool_free_page(pool, page_caching, order, p, false);
=20
 error_free_all:
 =09if (tt->restore)
--=20
2.49.0


