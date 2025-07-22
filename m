Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C4BC83F26
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 01:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 554DD6B0089; Mon, 21 Jul 2025 21:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504DC6B008A; Mon, 21 Jul 2025 21:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F4796B008C; Mon, 21 Jul 2025 21:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CA456B0089
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 21:50:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE38F12D811
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:50:49 +0000 (UTC)
X-FDA: 83690221818.20.3824DB5
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2F4F7C0003
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:50:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none);
	spf=softfail (imf22.hostedemail.com: 207.211.30.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753149048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8at6GSuhaMQSngvLfISOdpqodOs1UFsY1ajBt87ThlY=;
	b=1h1CElUycvjb+MjG/sSN/T+hSn29k/Ox2l8LfluRJPSHgmKdu41njHsv43YvU39kSDdF0q
	vqHYMlCmGG9yeuYA68Mrn0caKkhUuc5JLaF7QsQC+rxzOoRU37fKFAv/Cz5q/JOvnY7m1I
	WH/1IVnv8qT/xEZr02shYbkT0fGdmMI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753149048; a=rsa-sha256;
	cv=none;
	b=79LqQ++DGjqtmHbW0LVZMYcAw2Qncc4FTjlXx+fNpPdkP13gFy/k5jrkFqh06MlLrsWS1V
	BntZuT7won5X3YdSArX3e/XBYN02h2QHOzHhqvhQQQA7qyhOgrpFUQ7xvq34ZQGtBBlRRj
	1QXDhu8AFv7F1KFo8P6/WkFzCWAmJts=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none);
	spf=softfail (imf22.hostedemail.com: 207.211.30.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-157-1LW42z-2P424ejYxjYPfiw-1; Mon,
 21 Jul 2025 21:50:43 -0400
X-MC-Unique: 1LW42z-2P424ejYxjYPfiw-1
X-Mimecast-MFC-AGG-ID: 1LW42z-2P424ejYxjYPfiw_1753149042
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B30991800284;
	Tue, 22 Jul 2025 01:50:42 +0000 (UTC)
Received: from dreadlord.redhat.com (unknown [10.67.32.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 73AF119560A3;
	Tue, 22 Jul 2025 01:50:38 +0000 (UTC)
From: Dave Airlie <airlied@gmail.com>
To: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Christian Koenig <christian.koenig@amd.com>
Cc: Dave Chinner <david@fromorbit.com>,
	Kairui Song <kasong@tencent.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 09/15] ttm/pool: initialise the shrinker earlier
Date: Tue, 22 Jul 2025 11:43:22 +1000
Message-ID: <20250722014942.1878844-10-airlied@gmail.com>
In-Reply-To: <20250722014942.1878844-1-airlied@gmail.com>
References: <20250722014942.1878844-1-airlied@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OVZeAs1jZuLQdG64GVvbtuu4lyDlyiw5LaOEOf7oQCQ_1753149042
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=WINDOWS-1252; x-default=true
X-Rspamd-Queue-Id: 2F4F7C0003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: mkxs6wx94qr17hucf934gtbpewt44uxo
X-HE-Tag: 1753149048-546500
X-HE-Meta: U2FsdGVkX19ISr1zSCRFBKJqFB2llTdWgSQYLU3NS4YEmF3WnpoMcfTiMhVUMFPP5Ukg9uZk4IdyG3hWiFyI4ncWvrsCAJdE1yG4LlNgSch/9nTXibVOOQ0E2/DbMYZ/lcQamNNhqUEt4zwhpcAuKmZF7G2YaUyCwE0NKTQvmyv0QbboSBhTQqH3/YHzD4bOmeW2J2OO5/CUIsn/+ZPKjvh4jqNnLU6az6tftASByJuzhTSCkF+ir5kuznQOT3QY60slaaGdZvRWfg93EKvEfQ83anZ+7WDmBeb42xQh1A9RYF1tmZRKX6WftKhAueG1UQ4hKhh/u1UDDN9Bj1lAOC/GXS4uKTX41K8ieu7kijpvP9cJxmQnvlyyaRZoz1aVN0Xq/nu/hILPcQQNqdfEcaYQLmMeq+HGSRLZuY2rMSddWM/RJqsjRpFhrXBCtChR9WgIAezZFpb6qjI5+KHW8Qkk0GWLh4OyXdSFDbJgkzQQGBsWG61JaVA/Hy09vGJNopi+iQn4TLaFMlBOfAbamval1cCpTCsGr9Qkpk+Uu8nSBW78KCmxFXX3rXLkZk+n39yeeNshd/gRh0a/O+M/bdse3jLd2Sb1HPWa7pBPrhNHcYuGVXD/aIUCxY9Amz1Ff7cOKgNirfetwB7EIfJXJlubU5+i+5sxqwKhzYwzPgBJCXVvlhq6nFe/PaygMYqx/3gpZv6JN5kditPG1R4BiUFdxdI2hcmyKdMHX3iZ2Ka26hz4sbpMaMATU9qwGMVpHm381wc91N1cRaMup89mW6NKegXuv6cmXbRUQ8PzUgDfBcKwQgrv2hwQp5q9Tab7fWBxweNRYGMZNu+39CmkUidPKy8sm2aGg8eDrvq9zLqXJdStn1CDEFb1eGfUKJHL4Qlk2E7rnv5BM+XKEgwJt72KuJvwp2MMMO175zc3sZIV6twjQt3+LJ1fNy/QPwzBRHedEP9RwZC/qemfcUw
 2hQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Airlie <airlied@redhat.com>

Later memcg enablement needs the shrinker initialised before the list lru,
Just move it for now.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/ttm/ttm_pool.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.=
c
index 9a8b4f824bc1..2c9969de7517 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -1381,6 +1381,17 @@ int ttm_pool_mgr_init(unsigned long num_pages)
 =09spin_lock_init(&shrinker_lock);
 =09INIT_LIST_HEAD(&shrinker_list);
=20
+=09mm_shrinker =3D shrinker_alloc(SHRINKER_NUMA_AWARE, "drm-ttm_pool");
+=09if (!mm_shrinker)
+=09=09return -ENOMEM;
+
+=09mm_shrinker->count_objects =3D ttm_pool_shrinker_count;
+=09mm_shrinker->scan_objects =3D ttm_pool_shrinker_scan;
+=09mm_shrinker->batch =3D TTM_SHRINKER_BATCH;
+=09mm_shrinker->seeks =3D 1;
+
+=09shrinker_register(mm_shrinker);
+
 =09for (i =3D 0; i < NR_PAGE_ORDERS; ++i) {
 =09=09ttm_pool_type_init(&global_write_combined[i], NULL,
 =09=09=09=09   ttm_write_combined, i);
@@ -1403,17 +1414,6 @@ int ttm_pool_mgr_init(unsigned long num_pages)
 #endif
 #endif
=20
-=09mm_shrinker =3D shrinker_alloc(SHRINKER_NUMA_AWARE, "drm-ttm_pool");
-=09if (!mm_shrinker)
-=09=09return -ENOMEM;
-
-=09mm_shrinker->count_objects =3D ttm_pool_shrinker_count;
-=09mm_shrinker->scan_objects =3D ttm_pool_shrinker_scan;
-=09mm_shrinker->batch =3D TTM_SHRINKER_BATCH;
-=09mm_shrinker->seeks =3D 1;
-
-=09shrinker_register(mm_shrinker);
-
 =09return 0;
 }
=20
--=20
2.49.0


