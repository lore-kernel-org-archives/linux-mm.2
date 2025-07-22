Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28CB4C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 01:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE36C8E0007; Mon, 21 Jul 2025 21:50:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B94188E0001; Mon, 21 Jul 2025 21:50:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD19E8E0007; Mon, 21 Jul 2025 21:50:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B6F98E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 21:50:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0634757688
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:50:26 +0000 (UTC)
X-FDA: 83690220852.05.8FC686F
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id 230BA40004
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:50:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none);
	spf=softfail (imf07.hostedemail.com: 207.211.30.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753149024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U0e3+Mfz+b5PCyr5+j+ZJ2H7zjr+wW2onyWPgiR3N7c=;
	b=gG39NFABBrzSoPEu4X0lnwCuIPq2OAm7Pqfgt+z6Ciouzc53D+LW0aZ/qvWyeaSd4cFuZX
	ho69xD513Z8nsCEZmbh1ZhnanFK+b4QTrDc2x6Z13fGZkYSVlWoYy6kinjIdbY27PQ3BAo
	kqEfAdVAgzd0fggn6EsN/gvxgB03Vw0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753149024; a=rsa-sha256;
	cv=none;
	b=8Ydd0odII7dFQ41aXcsQHEFfCJWsnUlLRJvQCJ9UhrjflX7qJWxd/WnPGw+OY+rrHjfMN8
	PAlKOiMr5A6mcd1hBXH9UPMJykjANnhj3zEGvNKU1hPk/B2JvDAnL5EeRh37LjKZtoRaPK
	hiEfCXY0LT4thQzW4PsSD1YpE6E3cqc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none);
	spf=softfail (imf07.hostedemail.com: 207.211.30.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-6nhiMGY7PWyQYpz-GQZsRQ-1; Mon,
 21 Jul 2025 21:50:17 -0400
X-MC-Unique: 6nhiMGY7PWyQYpz-GQZsRQ-1
X-Mimecast-MFC-AGG-ID: 6nhiMGY7PWyQYpz-GQZsRQ_1753149016
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 632A719560AD;
	Tue, 22 Jul 2025 01:50:16 +0000 (UTC)
Received: from dreadlord.redhat.com (unknown [10.67.32.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1D0FB19560A3;
	Tue, 22 Jul 2025 01:50:11 +0000 (UTC)
From: Dave Airlie <airlied@gmail.com>
To: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Christian Koenig <christian.koenig@amd.com>
Cc: Dave Chinner <david@fromorbit.com>,
	Kairui Song <kasong@tencent.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 04/15] ttm/pool: drop numa specific pools
Date: Tue, 22 Jul 2025 11:43:17 +1000
Message-ID: <20250722014942.1878844-5-airlied@gmail.com>
In-Reply-To: <20250722014942.1878844-1-airlied@gmail.com>
References: <20250722014942.1878844-1-airlied@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9N0ei4qLoy4X-1yujKrHtm_L3NUnBgAQtvS896rVlA8_1753149016
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=WINDOWS-1252; x-default=true
X-Rspamd-Queue-Id: 230BA40004
X-Stat-Signature: cid3zei3pmckxa33magan5iuwcjnn7i1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753149023-952310
X-HE-Meta: U2FsdGVkX1+rApw11+hfNjvw2Z3HnFAn1FQ3/HHb/QzBV0DjgqyU1KhiAFsOcqA/9t9JrhRiLNE2vPaGqAzOOfkKWh4K73K+K7GKs8wFYD40MJSQXbkUqtuKvH5dM6uOTU9CBJq1NKOqAfw4sBs+055SUPHHxckQoIAwBPm0d46B8zLMeOxhIHct+wIHozTShernqwsQ5pvzqxySq+2qEfEUz7sybhV8xrjoJ8ErE7GjcDaGk8iZ2lcLNDPTW7fPo7NV93mHZArdf7QdJ0XFSN6ODl1OI73qYj2K7lSs02ziY0d4+HzZqC74NhBc0RwzJa+esYAPcKqVjHG6VTW/f7dDSawno95kQHGkFg+7qnTj6VrPkwV1fEtDOL74urvq9DjU+ZMTqvxCih9jsoym4w3Cvi+0XHlv4peiwwAcia6xb+z5PHHo4TWFpBC4gZji+NQSrXMmnR3SS1hUO03oAqCRV4GPmcZuiBAy0wif4tRY7sVU6oqDBBmNtMiP4ek1IpbipzALdMy97tvCBUhvSJhvjApT9KfI4RE4mo06c+b8o0mzQu1eKxVHoZo+g4T2tcIanluEt7sAdiHDJq2MqO8M2TobydlybCs96JI9EOPHwiTJOsE90bvocV0gp0I/xni9KAGQFuJRaXd9iLweSUm+Eyb7Ip4fHZXG1jrRQ6CPQybxKJ6XzZlqcwCUCKe3TScGc6JOPCLM/15gs76ZWIW4CpfmKCl/oQQiTgl3LkELHZLPhFaMXzkq7iob1LUKncwwlc7sgfLa/WYoWrdjWbJxScfD4T4JN6nX6aXRPMBRJxGP4DyMomwU1kFB42VdNhJRVWMKzbJpaey94epUr6xyQJzQGmeFBWbmgCdnmvwPV9d/JnpdKk/3H+b46M+GMVZPcJZeChW0iMxHI9q7NqmNSUp36m1cyg2yaEPQ7VStu5aK1pK75BMTyM6BqQoYLTu8m1Gk+MjjaEnIcqg
 9+k8BP5H
 zsl6abhbJz/VWr9dsaOvs2psm65IuKYPR0GYoAsRLrvkwWAyqU3YO7Sq82G3lQGzNbQ6tV+lrXWwNb4CmCQGmNsfuLfM7p5FBtE/iqNU5qMVeRotmZiEuXNACv7OhUlOT6H9TDQW7h99gAogP23DjMbwWsKfdJmGMxM2zlunrFjzJ1zgZwpW0HGYJzNutdEFJOvYuPq9denOKUf82KfGpmzaWxc81j07Shr8CKxP8I7zC9YtDnXuyiBY+qbGPeIVCpTaRNtDd5K3WvEpl8N3YU17bLc5zILgaPFKZ9aKvLQj51pTU2fzNaZ5Dbe81gNMQhDboSVmlgsywgGBpPE3plXYstPsedj2Tyqd9BGQr/CQNt6zl74DdqQ+vSMo16bMjvtNRxS1qp9FKAqRbGCwu4y+yHAOPNWjK5ktrgB/g2kz86c+p7tLuV7WDW1JpHCad9uO1X6YF5UE6xEuZY5ryYqn/pDARDKGzG1bxS7PlqsQWSDwXSk6slT1Qfv6ELp02O57KtWpvb5eOux5/KQMcQcovolynNgK7wLHT6F7MgRMoj5kp7jPSglqkaqQE5bo3Un35kiygxjP6gBu05R9j4rPbFQ8rTOipvxNuWjarUobKg6Tu/duwud6J2brnN5zSPkye1A3B3sYmJYPtXeqLEOdJrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Airlie <airlied@redhat.com>

The list_lru will now handle numa for us, so need to keep
separate pool types for it. Just consoldiate into the global ones.

This adds a debugfs change to avoid dumping non-existant orders due
to this change.

Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/ttm/ttm_pool.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_pool.c b/drivers/gpu/drm/ttm/ttm_pool.=
c
index 8b0fe7a0164a..bc8a796201b4 100644
--- a/drivers/gpu/drm/ttm/ttm_pool.c
+++ b/drivers/gpu/drm/ttm/ttm_pool.c
@@ -396,17 +396,11 @@ static struct ttm_pool_type *ttm_pool_select_type(str=
uct ttm_pool *pool,
 #ifdef CONFIG_X86
 =09switch (caching) {
 =09case ttm_write_combined:
-=09=09if (pool->nid !=3D NUMA_NO_NODE)
-=09=09=09return &pool->caching[caching].orders[order];
-
 =09=09if (pool->use_dma32)
 =09=09=09return &global_dma32_write_combined[order];
=20
 =09=09return &global_write_combined[order];
 =09case ttm_uncached:
-=09=09if (pool->nid !=3D NUMA_NO_NODE)
-=09=09=09return &pool->caching[caching].orders[order];
-
 =09=09if (pool->use_dma32)
 =09=09=09return &global_dma32_uncached[order];
=20
@@ -1281,7 +1275,7 @@ int ttm_pool_debugfs(struct ttm_pool *pool, struct se=
q_file *m)
 {
 =09unsigned int i;
=20
-=09if (!pool->use_dma_alloc && pool->nid =3D=3D NUMA_NO_NODE) {
+=09if (!pool->use_dma_alloc) {
 =09=09seq_puts(m, "unused\n");
 =09=09return 0;
 =09}
@@ -1292,10 +1286,7 @@ int ttm_pool_debugfs(struct ttm_pool *pool, struct s=
eq_file *m)
 =09for (i =3D 0; i < TTM_NUM_CACHING_TYPES; ++i) {
 =09=09if (!ttm_pool_select_type(pool, i, 0))
 =09=09=09continue;
-=09=09if (pool->use_dma_alloc)
-=09=09=09seq_puts(m, "DMA ");
-=09=09else
-=09=09=09seq_printf(m, "N%d ", pool->nid);
+=09=09seq_puts(m, "DMA ");
 =09=09switch (i) {
 =09=09case ttm_cached:
 =09=09=09seq_puts(m, "\t:");
--=20
2.49.0


