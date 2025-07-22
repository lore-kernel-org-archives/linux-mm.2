Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E951C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 01:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A37476B00A3; Mon, 21 Jul 2025 21:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7B96B00A4; Mon, 21 Jul 2025 21:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6FB6B00A5; Mon, 21 Jul 2025 21:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78A6F6B00A3
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 21:51:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D31C57688
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:51:18 +0000 (UTC)
X-FDA: 83690223036.13.04508BE
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
	by imf08.hostedemail.com (Postfix) with ESMTP id 785DE16000C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:51:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=softfail (imf08.hostedemail.com: 207.211.30.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753149076; a=rsa-sha256;
	cv=none;
	b=Y5fbTmjJpfoISKAKXbCdIT+1aLVIEApzJZc/gwNLVvW9r9PN1tou8uvaObRL1b4d+/tY0t
	KFSZEVjbKNINfl6ClijUElj1bhoYxwffPvxdR+p2QSmKnkn1cNV8w4tOElfNrtMa6q+LAB
	49AKKzSJJUY61IQrrLqVL4U9x0C//tI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=softfail (imf08.hostedemail.com: 207.211.30.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753149076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ifVyisNU3voJyj64X4e5xbaTjW3DKwqQE24Y+oGiaOM=;
	b=3IDdLm+hjTpdvtsR6jpV/0hNaZp8OqT+8QNUNh44Jz7vX6V04i4atsbiea0FxvN0q/V4GF
	1OpF56P2jwuRfpOd/qsrG3Uz5C3dddVgNaOXWSYvN0p7/Btl12qG2t9DCC3VKZwIQB4GVh
	bS4imfTFeaaYnAWYju/0uEtME/QbeGw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-639-45FMXp0GOjCwgzzT1WpC1w-1; Mon,
 21 Jul 2025 21:51:09 -0400
X-MC-Unique: 45FMXp0GOjCwgzzT1WpC1w-1
X-Mimecast-MFC-AGG-ID: 45FMXp0GOjCwgzzT1WpC1w_1753149068
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F9901800C31;
	Tue, 22 Jul 2025 01:51:08 +0000 (UTC)
Received: from dreadlord.redhat.com (unknown [10.67.32.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3620219560A3;
	Tue, 22 Jul 2025 01:51:03 +0000 (UTC)
From: Dave Airlie <airlied@gmail.com>
To: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Christian Koenig <christian.koenig@amd.com>
Cc: Dave Chinner <david@fromorbit.com>,
	Kairui Song <kasong@tencent.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 14/15] amdgpu: add support for memory cgroups
Date: Tue, 22 Jul 2025 11:43:27 +1000
Message-ID: <20250722014942.1878844-15-airlied@gmail.com>
In-Reply-To: <20250722014942.1878844-1-airlied@gmail.com>
References: <20250722014942.1878844-1-airlied@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gXG_PLnr7Vb50YnkCaSon6pwFgK1z6hTPDyrfOFvtXE_1753149068
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=WINDOWS-1252; x-default=true
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 785DE16000C
X-Stat-Signature: 4hns5u56fmizd61pc9qpf1bgn45daf13
X-Rspam-User: 
X-HE-Tag: 1753149076-387949
X-HE-Meta: U2FsdGVkX191i4qogOY45PTuuUGmRMQJY0YRZ819g0GNjWkQEbEKi/bsOy6sxWMI6zuimnf3SCr7Z9t+xaIob5c7znz5/P/AXl4hZXZDhakXZi8QLScHLlDOaZ7pDyjpMkmWP48z+BK5AMf0QQDsCBxUwMeS5w4urhEZFQW5TU7F2lllGXgSoGUqrSP8JNrQTiLRbSRt/vvLXtxwwtp/QKPgz7KwzeXgj6ABUT9iOSCjCsxxHt5CrB2LpxnT9NiyNhV3FSBGUokT1o3UmKrX+U2JtB5Iw/ZETJrUf8zemTcFsuqdu7i/gNyiyDpK+ZTI8wgf5sDlrgeI7zZ48Y5ONWC99d3+7/WvTcz4ENenLzsV7MRnSIQ31LaNyhA+TPphd2rMS1aEx3uv5P60b07VHUjGCkzYeFi0/r0Ib2c3TNvyM1m5Tsozf9TLxj4yP0GDS+wipG7Nt76uuue+RksyiQy6XC+Lm4YaJkSJ+ZK/JKg42GgnoQ7LJDIeq0nddPuYTWQwAsr/ZckPG+nW/Py1PpKPJFVQvpQBa2p7ClFWd9/GmsoST+5i2r+DWasSFoBHsTcDoXmC4YlAGPIl3LrelgZIbXvv2PrpoSCcYQt72VZ6XMu/p0amSRuGNZGHxGmhjhhg2cqjDiwr0QG45xVeZiIdbCGR6fZLrsjqvuyONK3/rdJ8ifm3dVfoxAHeKOZU73v3CS5H2N4LMJXplAAv1ctZ4glm3GUniNgmbr6o11CiulfxV/h6vnVJ+K0wmCffqR6sMmGaXVeeV0VC3XEcJiPYoHP8+698DaTrtvc/ZQvFyizbZwIM4JAOn8JDQeIzzDQorHb8NOYRWZWyBi0RfhGL6XtUnn45fYJCX4v84R2LYqsP9Eb6vQqWQVHTic+JNhdb/Uqe+GywtbBtMM+GJXPMzA0xjNxUXsjNxdsqsgmniXbBhy2CTWqV4WN6SEEOhwgOzr7NBAIjmWsO01W
 6ZthIF2T
 hjCpIr6HQMfpzIIDYXZEvs8quZQQiagdPYHUHqismodb+FaG45A13OG6MDUQkbU8WRnK6xwwx0ug3VuFlX3j/umfiPjWzIH66O315kRDHfHRI6jl8R5SxR31UY+KhfIqrxNZjNIkW3w8FyFqmwq/LCp9Y3XSNWFXnWfB5IJr9jlwdtM+Tl7toCaAy7ymxCLdvDMDAIZYygq+QNMtaPRXnjAaomhNhaMhU03M917lRPjdqks/gwoLju8Ouo3iSoz98HbrkKNtQ+rZqpM34ZYJXv94mgS3hUyg+eyukxS7UALJ4Ro1HvhsLp9o9z/4NpDgRNxbciwB9nd7sFy7HKn/iwxSovgdXacdJq30gjfb99yl6qQF9ECdvW2A164L1A0bxQRFqucywO42SqA/cqCDzNHI//Un785mnvny0L0wCNXb+FTGAmw1DtDbyNxB4oa/hZA2r1lB5M8ymZEo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Airlie <airlied@redhat.com>

This adds support for adding a obj cgroup to a buffer object,
and passing in the placement flags to make sure it's accounted
properly.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c    |  2 ++
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c | 13 +++++++++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.h |  1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c    |  2 ++
 mm/memcontrol.c                            |  1 +
 5 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/=
amdgpu/amdgpu_gem.c
index 6626a6e64ff5..044005bdd199 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -198,6 +198,7 @@ static void amdgpu_gem_object_free(struct drm_gem_objec=
t *gobj)
 =09struct amdgpu_bo *aobj =3D gem_to_amdgpu_bo(gobj);
=20
 =09amdgpu_hmm_unregister(aobj);
+=09obj_cgroup_put(aobj->tbo.objcg);
 =09ttm_bo_put(&aobj->tbo);
 }
=20
@@ -225,6 +226,7 @@ int amdgpu_gem_object_create(struct amdgpu_device *adev=
, unsigned long size,
 =09bp.domain =3D initial_domain;
 =09bp.bo_ptr_size =3D sizeof(struct amdgpu_bo);
 =09bp.xcp_id_plus1 =3D xcp_id_plus1;
+=09bp.objcg =3D get_obj_cgroup_from_current();
=20
 =09r =3D amdgpu_bo_create_user(adev, &bp, &ubo);
 =09if (r)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/a=
md/amdgpu/amdgpu_object.c
index c5fda18967c8..5ec69ab8bf44 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -159,7 +159,7 @@ void amdgpu_bo_placement_from_domain(struct amdgpu_bo *=
abo, u32 domain)
 =09=09places[c].mem_type =3D
 =09=09=09abo->flags & AMDGPU_GEM_CREATE_PREEMPTIBLE ?
 =09=09=09AMDGPU_PL_PREEMPT : TTM_PL_TT;
-=09=09places[c].flags =3D 0;
+=09=09places[c].flags =3D TTM_PL_FLAG_MEMCG;
 =09=09/*
 =09=09 * When GTT is just an alternative to VRAM make sure that we
 =09=09 * only use it as fallback and still try to fill up VRAM first.
@@ -174,7 +174,7 @@ void amdgpu_bo_placement_from_domain(struct amdgpu_bo *=
abo, u32 domain)
 =09=09places[c].fpfn =3D 0;
 =09=09places[c].lpfn =3D 0;
 =09=09places[c].mem_type =3D TTM_PL_SYSTEM;
-=09=09places[c].flags =3D 0;
+=09=09places[c].flags =3D TTM_PL_FLAG_MEMCG;
 =09=09c++;
 =09}
=20
@@ -658,16 +658,21 @@ int amdgpu_bo_create(struct amdgpu_device *adev,
 =09=09size =3D ALIGN(size, PAGE_SIZE);
 =09}
=20
-=09if (!amdgpu_bo_validate_size(adev, size, bp->domain))
+=09if (!amdgpu_bo_validate_size(adev, size, bp->domain)) {
+=09=09obj_cgroup_put(bp->objcg);
 =09=09return -ENOMEM;
+=09}
=20
 =09BUG_ON(bp->bo_ptr_size < sizeof(struct amdgpu_bo));
=20
 =09*bo_ptr =3D NULL;
 =09bo =3D kvzalloc(bp->bo_ptr_size, GFP_KERNEL);
-=09if (bo =3D=3D NULL)
+=09if (bo =3D=3D NULL) {
+=09=09obj_cgroup_put(bp->objcg);
 =09=09return -ENOMEM;
+=09}
 =09drm_gem_private_object_init(adev_to_drm(adev), &bo->tbo.base, size);
+=09bo->tbo.objcg =3D bp->objcg;
 =09bo->tbo.base.funcs =3D &amdgpu_gem_object_funcs;
 =09bo->vm_bo =3D NULL;
 =09bo->preferred_domains =3D bp->preferred_domain ? bp->preferred_domain :
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h b/drivers/gpu/drm/a=
md/amdgpu/amdgpu_object.h
index c316920f3450..8cccbe62e328 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.h
@@ -55,6 +55,7 @@ struct amdgpu_bo_param {
 =09enum ttm_bo_type=09=09type;
 =09bool=09=09=09=09no_wait_gpu;
 =09struct dma_resv=09=09=09*resv;
+=09struct obj_cgroup               *objcg;
 =09void=09=09=09=09(*destroy)(struct ttm_buffer_object *bo);
 =09/* xcp partition number plus 1, 0 means any partition */
 =09int8_t=09=09=09=09xcp_id_plus1;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/=
amdgpu/amdgpu_ttm.c
index f71431e8e6b9..a3fa28e5a43e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -151,11 +151,13 @@ static void amdgpu_evict_flags(struct ttm_buffer_obje=
ct *bo,
 =09=09=09amdgpu_bo_placement_from_domain(abo, AMDGPU_GEM_DOMAIN_GTT |
 =09=09=09=09=09=09=09AMDGPU_GEM_DOMAIN_CPU);
 =09=09}
+=09=09abo->placements[0].flags &=3D ~TTM_PL_FLAG_MEMCG;
 =09=09break;
 =09case TTM_PL_TT:
 =09case AMDGPU_PL_PREEMPT:
 =09default:
 =09=09amdgpu_bo_placement_from_domain(abo, AMDGPU_GEM_DOMAIN_CPU);
+=09=09abo->placements[0].flags &=3D ~TTM_PL_FLAG_MEMCG;
 =09=09break;
 =09}
 =09*placement =3D abo->placement;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 94fe825f0e0f..53c2b51c97f4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2726,6 +2726,7 @@ __always_inline struct obj_cgroup *current_obj_cgroup=
(void)
=20
 =09return objcg;
 }
+EXPORT_SYMBOL_GPL(current_obj_cgroup);
=20
 struct obj_cgroup *get_obj_cgroup_from_folio(struct folio *folio)
 {
--=20
2.49.0


