Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7E67C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 01:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68CC58E0008; Mon, 21 Jul 2025 21:50:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 664468E0001; Mon, 21 Jul 2025 21:50:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1BC8E0008; Mon, 21 Jul 2025 21:50:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 468418E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 21:50:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D4E511088A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:50:31 +0000 (UTC)
X-FDA: 83690221062.30.8EE6D0D
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id C9713140004
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:50:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=softfail (imf26.hostedemail.com: 207.211.30.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753149029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SyHu8Vtt5ASuIP0TYPq7sVKXrOgHX8fWsYF61hx7gIk=;
	b=Edc2LCP9SQJ2vb0TF02S5d+3crff7RcbL0RddYS7T+5ifUTKFEyzSNUF/eK8u4Sq29UNIo
	oWdf8pHwcOMdTSqms2CZ2oxdeooUoBs9oncW85jGp0j6PNK1wCmbE1Y/KN+nYggRrWBWHf
	Xu5H5eksfQUw0F8PMSsXCq5TEmiDSpk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=softfail (imf26.hostedemail.com: 207.211.30.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753149029; a=rsa-sha256;
	cv=none;
	b=zrGiXT2xs6jq1gBoA8BwEamOHCFG5IEUDX5FvA8zWKXNXVsIJFOQiwO3WEuqS68jrWDs2x
	/Hg4goHfYAz5dn9ZtLo4Lj12bf8CjunmTxzRDHk2mdYnrWFanVGt/gd+lBo+hul2xvMxgR
	9Q2c25tfcO5Esxj1414JYslJ+vrNvBs=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-63-9MxSKBeKNOyVvcOrhlEPjA-1; Mon,
 21 Jul 2025 21:50:24 -0400
X-MC-Unique: 9MxSKBeKNOyVvcOrhlEPjA-1
X-Mimecast-MFC-AGG-ID: 9MxSKBeKNOyVvcOrhlEPjA_1753149022
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BB1B619560AD;
	Tue, 22 Jul 2025 01:50:21 +0000 (UTC)
Received: from dreadlord.redhat.com (unknown [10.67.32.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4C47F1966650;
	Tue, 22 Jul 2025 01:50:16 +0000 (UTC)
From: Dave Airlie <airlied@gmail.com>
To: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Christian Koenig <christian.koenig@amd.com>
Cc: Dave Chinner <david@fromorbit.com>,
	Kairui Song <kasong@tencent.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 05/15] ttm/pool: make pool shrinker NUMA aware
Date: Tue, 22 Jul 2025 11:43:18 +1000
Message-ID: <20250722014942.1878844-6-airlied@gmail.com>
In-Reply-To: <20250722014942.1878844-1-airlied@gmail.com>
References: <20250722014942.1878844-1-airlied@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gHb9sVlds64nK22RhEkc7kHfvj-vPFPCzlJvxr29vWA_1753149022
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=WINDOWS-1252; x-default=true
X-Stat-Signature: repeajqga818hrygmies9d8wm9zkrpp1
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C9713140004
X-Rspam-User: 
X-HE-Tag: 1753149027-114120
X-HE-Meta: U2FsdGVkX1+VmoTGQWok+xxvT14aSDfrCEZ5bfpeXwWaviH368fhzgS/hx1CDRfUlkC3f0bRWnx/0O9dfz4h2eq3FaNUk1qejhx/UzwsawKpCSZRZ+EYu5Dz62JQQEgJ8q53l9VeGyz9WpesVC8zYkfjigQxeAar5z51sz2jZcBs70OJi952ZvQaUOlAH3FeJGxy7clu6Avr4CmawnauDqSR+BeLFBvj8LiuWZ6kPQcr8vNaR9Fk5pxL4sNHy2t+mk7X0Xlp00HuZLkmb2mAAr+Wf5MVrKvk/ug1n9ljDP9l4TrqtPsZC0ihNVfsFqBot2zWs1vVlkaE0LQDJ0luu6v9WHDHr7Hqj0y7ejfAQ43hFPGwKCrEPIK+QVi0u5TPPQ7VRRyjF9Qhh7/SCb4bMSi7thrmD8yY72HOfeTcmJUgiq0/mlLT7rwSX8KRCtM+74hG2D+Vxxw0E+FZlEGvz0NExHf6TL1gO6gWwB2vYodR6YEQ8TWy6BWO5As8jtUcgYeoWH9F5QzbQ78z0WtFzJwlNFd2UR8pAJo+G6KF91JJKmtwvmsTz83nO8PyZylMgihFlIz9T0r9cXzjegrlEAk/PCY8WOlCW8Z3/GeF69fYyhLdo2DYNVQtEuVfhCJKUAMRResHFgw/jRAdSj4c343rqvRrtmzdQc0FA8jKh4nrShKHkLmeC9V+3TvrthMCiuwX6cbFP1lVFNqa8tBJRtU1c3zrJvbCSzCyxpUHeQyf7FL2tHW6xAtwdl8Mgh4CzKWco+5m+H3qVuTCggzBqX1DzEQJPlDPrkeUMh88x+n2BfreUcfaNFfnPIL6FIFLNvcE0fCROepLGxuNwc3hLKlrH8/Hg/hs5ZxuP1DVSgNmZ0YC3Qbbkk1JomCtzK/TXazhf4mAIOvN+1jFFCIsS5KbiBlDeMpTEaISmucmY1Y94ML8SHy5l7jZTfBwnM1e0J8azS9++Fz7sj/CLdg
 ZH6zNbHI
 Cq+kO4cCTpDtUYrmzxa2xP2Ao3NWJDREI8Nhtow138EwJiqDu2/l84tJV3LVXZJ2yeQ7DJljK7NZ2rBc7x8tuxStiJ8CJB2Jdnvnrui/tXHjNNvIXASP9n+Q55q4hNJ5dHJfEbrbABfEMqCxFauIdY5c09PmHJkJRLWMquC0KApKtQc76UhTRm5iQAdMkxu2muP75BGSNDaD8wL+hbE8jJHL4X/UmOR61OY5t94qWc2Zm07WPWHvLU3iaMh2vXKj+3ror+7ylntvsaK5FVMS2rz/q40gRqq2zSAnGRhizkJ+Vey4D18Nc+tqjrr4NxlkRSrMaIYtvHyMcAoqzGoXJXystbuFCcYN5KW+ffToW2an49nKZaVV8+ix4lCUxhTwib6M+xiceA1WGp4ayW0p1RXMDMKwgsZzf4VavgP6AhU5BcAb7Nc43swNAyHLaIcUW28HYb/8LwC7dFQSnrVafaRmouCdQvfBV7gpotxArqpP1MbYMbcPQDKHeQPtU3NK5xICZ/KieP+5rzXZGJJds+ikzzvPn3uwJqm0bthM8lTrYfR+5coimMTj/PFzncytQp1fkPPbO2yhQVry3hR4+eEvGTZfVUODZTKwMSD11f59HAnCQxNg9QR0IzjcPmyc11MdNPExLEhKzyjAuSCRXKuum/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Airlie <airlied@redhat.com>

This enable NUMA awareness for the shrinker on the
ttm pools.

Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/ttm/ttm_pool.c | 38 +++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.=
c
index bc8a796201b4..ae46aa370545 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -413,12 +413,12 @@ static struct ttm_pool_type *ttm_pool_select_type(str=
uct ttm_pool *pool,
 =09return NULL;
 }
=20
-/* Free pages using the global shrinker list */
-static unsigned int ttm_pool_shrink(void)
+/* Free pages using the per-node shrinker list */
+static unsigned int ttm_pool_shrink(int nid, unsigned long num_to_free)
 {
+=09LIST_HEAD(dispose);
 =09struct ttm_pool_type *pt;
 =09unsigned int num_pages;
-=09struct page *p;
=20
 =09down_read(&pool_shrink_rwsem);
 =09spin_lock(&shrinker_lock);
@@ -426,13 +426,10 @@ static unsigned int ttm_pool_shrink(void)
 =09list_move_tail(&pt->shrinker_list, &shrinker_list);
 =09spin_unlock(&shrinker_lock);
=20
-=09p =3D ttm_pool_type_take(pt, ttm_pool_nid(pt->pool));
-=09if (p) {
-=09=09ttm_pool_free_page(pt->pool, pt->caching, pt->order, p, true);
-=09=09num_pages =3D 1 << pt->order;
-=09} else {
-=09=09num_pages =3D 0;
-=09}
+=09num_pages =3D list_lru_walk_node(&pt->pages, nid, pool_move_to_dispose_=
list, &dispose, &num_to_free);
+=09num_pages *=3D 1 << pt->order;
+
+=09ttm_pool_dispose_list(pt, &dispose);
 =09up_read(&pool_shrink_rwsem);
=20
 =09return num_pages;
@@ -781,6 +778,7 @@ static int __ttm_pool_alloc(struct ttm_pool *pool, stru=
ct ttm_tt *tt,
 =09=09pt =3D ttm_pool_select_type(pool, page_caching, order);
 =09=09if (pt && allow_pools)
 =09=09=09p =3D ttm_pool_type_take(pt, ttm_pool_nid(pool));
+
 =09=09/*
 =09=09 * If that fails or previously failed, allocate from system.
 =09=09 * Note that this also disallows additional pool allocations using
@@ -929,8 +927,10 @@ void ttm_pool_free(struct ttm_pool *pool, struct ttm_t=
t *tt)
 {
 =09ttm_pool_free_range(pool, tt, tt->caching, 0, tt->num_pages);
=20
-=09while (atomic_long_read(&allocated_pages) > page_pool_size)
-=09=09ttm_pool_shrink();
+=09while (atomic_long_read(&allocated_pages) > page_pool_size) {
+=09=09unsigned long diff =3D page_pool_size - atomic_long_read(&allocated_=
pages);
+=09=09ttm_pool_shrink(ttm_pool_nid(pool), diff);
+=09}
 }
 EXPORT_SYMBOL(ttm_pool_free);
=20
@@ -1187,7 +1187,7 @@ static unsigned long ttm_pool_shrinker_scan(struct sh=
rinker *shrink,
 =09unsigned long num_freed =3D 0;
=20
 =09do
-=09=09num_freed +=3D ttm_pool_shrink();
+=09=09num_freed +=3D ttm_pool_shrink(sc->nid, sc->nr_to_scan);
 =09while (num_freed < sc->nr_to_scan &&
 =09       atomic_long_read(&allocated_pages));
=20
@@ -1315,11 +1315,15 @@ static int ttm_pool_debugfs_shrink_show(struct seq_=
file *m, void *data)
 =09=09.nr_to_scan =3D TTM_SHRINKER_BATCH,
 =09};
 =09unsigned long count;
+=09int nid;
=20
 =09fs_reclaim_acquire(GFP_KERNEL);
-=09count =3D ttm_pool_shrinker_count(mm_shrinker, &sc);
-=09seq_printf(m, "%lu/%lu\n", count,
-=09=09   ttm_pool_shrinker_scan(mm_shrinker, &sc));
+=09for_each_node(nid) {
+=09=09sc.nid =3D nid;
+=09=09count =3D ttm_pool_shrinker_count(mm_shrinker, &sc);
+=09=09seq_printf(m, "%d: %lu/%lu\n", nid, count,
+=09=09=09   ttm_pool_shrinker_scan(mm_shrinker, &sc));
+=09}
 =09fs_reclaim_release(GFP_KERNEL);
=20
 =09return 0;
@@ -1367,7 +1371,7 @@ int ttm_pool_mgr_init(unsigned long num_pages)
 #endif
 #endif
=20
-=09mm_shrinker =3D shrinker_alloc(0, "drm-ttm_pool");
+=09mm_shrinker =3D shrinker_alloc(SHRINKER_NUMA_AWARE, "drm-ttm_pool");
 =09if (!mm_shrinker)
 =09=09return -ENOMEM;
=20
--=20
2.49.0


