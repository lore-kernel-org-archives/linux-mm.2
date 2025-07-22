Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 485E4C83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 01:51:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92556B009A; Mon, 21 Jul 2025 21:51:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D43046B009B; Mon, 21 Jul 2025 21:51:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C321F6B009D; Mon, 21 Jul 2025 21:51:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B27B06B009A
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 21:51:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7FABE1D8D6E
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:51:05 +0000 (UTC)
X-FDA: 83690222490.10.F8948A3
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id 97DC9A0002
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:51:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=softfail (imf15.hostedemail.com: 207.211.30.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753149063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8VzX0KNyRQdeR1UwY7UsulSQ5CAxVfPiFSHmFFkPB8s=;
	b=ya9PykSuWe0tkf4gUynbH/nsyDiADnfoDO9hyEyhJ+n6vdYouR2r0staqFbcajaw07JCmD
	y4/O+e3J2+QLfAe/v0T9jFTGWRwV6HfwidbsoWtTgv4vBH//xGyWBJNsawO5VfSAseDylB
	v2JpPHoit4P/c99DW40jix1/sjXUCuw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=softfail (imf15.hostedemail.com: 207.211.30.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753149063; a=rsa-sha256;
	cv=none;
	b=b3j0lnPYPFt4hmQGnbEflfzTJCK9jxvr8daizq9bRvzZyFBzpGJnOZ6WlL18+y0HaAmCIy
	TzhIHyg/WJvzLHvLgM4wH7wTZtB5My/HsfoJO3V5tWjPwrN+CELXDPUkeFi91xXwEnGoTh
	LwgXjuq8e8vTY25QbFQNpeQAYMqOee0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-Ndefx291MhmGl-PfGOuXvw-1; Mon,
 21 Jul 2025 21:50:59 -0400
X-MC-Unique: Ndefx291MhmGl-PfGOuXvw-1
X-Mimecast-MFC-AGG-ID: Ndefx291MhmGl-PfGOuXvw_1753149058
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3382A1800286;
	Tue, 22 Jul 2025 01:50:58 +0000 (UTC)
Received: from dreadlord.redhat.com (unknown [10.67.32.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0B81719560A3;
	Tue, 22 Jul 2025 01:50:53 +0000 (UTC)
From: Dave Airlie <airlied@gmail.com>
To: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Christian Koenig <christian.koenig@amd.com>
Cc: Dave Chinner <david@fromorbit.com>,
	Kairui Song <kasong@tencent.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 12/15] ttm: hook up memcg placement flags.
Date: Tue, 22 Jul 2025 11:43:25 +1000
Message-ID: <20250722014942.1878844-13-airlied@gmail.com>
In-Reply-To: <20250722014942.1878844-1-airlied@gmail.com>
References: <20250722014942.1878844-1-airlied@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Bd5ZfjXXkVU35RwUN3MewLuOQtxsThgIqA7xPNh_mqM_1753149058
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=WINDOWS-1252; x-default=true
X-Stat-Signature: pr986osq1wie7kme48nu9zhr9ibohbez
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 97DC9A0002
X-Rspam-User: 
X-HE-Tag: 1753149063-325152
X-HE-Meta: U2FsdGVkX1+/LZB6asnaHXiPZ1kG+ua4aCAsazOrzRwP/nr11lMBmkBum0AtfbJ7SLXkAqRi4aIUvryerr//9ultHlKjKzhNMU7D4Ibza/FjnNeu6fIK4nMNUjcSgOGa5TbQxmFASr2bFWTZs/nLLoi87X/VoxlyEEQadQF0oqZ1rJxrK2JpYj2ks/GYpF1g7nTgtYpAdcUrQj6ibT1DkX+qLFrH9RgiNy0R/IJkmh7725+fyfisoH/pE1rtfF9qECWY06NHJ2o0oOHYOeu2hdaJaACyjvnNFxHYBT1685lvDQIkfpPQh8dlO1zoZmtBv8U0WzOAH5NToZgnXtNEQDnCyntE5NkIW1s8pmSi7HTqTqlW1yHz5qhEiQrqqZf6coSm2Xox4jjvQwXau58sbqGhQ/aQVrW5yMdakJdvBiX/I7WX60+s0Q2zXlNtgklySMBEtoWkihsBbUzoRcQI56RprFALp9VpxMt7OzUsT5HR/KiK6hRndE6bDr1mkVNpcQJVaRXCk9CZX7dwieVF19PZ+uaTqn1s4zPOdU/ZAz5pqAisTeJxlRU+HRb/kw8S+6P1uTDAevjJHDRXFrlru4Lq5nSGI/EvTgU9oV/2DWiCANXv4yG+WVcZSHWOoIoNLBJ08KbzAcKv4T2cMQ3EwKtbISfnhP8zn8kj2TX1INEX3GlRVYqXJKyFgdRzIyVO0epzjtvVgfHs5rO938ZHZgOOQsEP6dH+/XHJC/PhzgVgBeSz3oYwWAUki/UiuFVbysxvnG5OsPC4dETN18ks+nUiAW5fdFn4tSBcwRTUyXPOpRD6BFsLyaAL35NJWDd/TrD0E+Me3ia4P/XjwC0pLPzCAguZ68Tvn3K+xNJDhbgTzso8yc65tLB13wHLaBi7ic959YZiYRtNn3m5tXAokBPvr6nDafQum+lZcroBxFRR5zrTo/wBkeT2TNPsCIOJwL65lFqAB6dGagbVpFo
 Zaa9kuuY
 nN7gUNR8AiVuKWbJxh4TLD4YJeRAAdOXhYYzK/UNDcjhyUheqsvgv2DOwxHqUBcRUi1bCMI2JIeLe13Z9lZLfFbWb02Tx5LyhgenJDkwh9ly+z33cRNRU/BG4GZ2o14UxN37kqio61d4Pj8DTaAjWhtI5CN/DuT+jXyCf6aVVaaZe9r04FBrQz1Wlpjjw2N5LZnTcfHq3puuumc5rabD4XEzYWD4dTU+H+arNBw3bX0tfq6yF1V02JFqiZXEbviWf2wMI4MGqri+lLVBztdLAFuLZWAYAD9XmZdmTNGMvuOs5rST6cJkMoE2MSK7s9KFpU4gBLg2c8g6Hh8zkT+ojMKXazBy4zNUBTsckDpyLBjNv7GkEOds/jssoVN2U3XZmK+fwf0Wb9P5URKCFfedDttF71kHmMPzV/x6UR/lwwzyJzQsZxF1vlem27iwXwv/REn/v8loFpC4DwUktWAtBCxKvw+xtC/PRSOdi0hv8tnjrlZtN4uscbWAIFAkx7qJ6wpl+buuvfx61lp3Ae5LjzIdCZdGyZe7OLzXE7KXJw9BrsTi1gQVesQ07lJzDYks3kZDP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Airlie <airlied@redhat.com>

This adds a placement flag that requests that any bo with this
placement flag set gets accounted for memcg if it's a system memory
allocation.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/ttm/ttm_bo.c      | 2 +-
 drivers/gpu/drm/ttm/ttm_bo_util.c | 6 +++---
 drivers/gpu/drm/ttm/ttm_bo_vm.c   | 2 +-
 include/drm/ttm/ttm_placement.h   | 3 +++
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index af04bb8e2c2a..273757974b9f 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -142,7 +142,7 @@ static int ttm_bo_handle_move_mem(struct ttm_buffer_obj=
ect *bo,
 =09=09=09goto out_err;
=20
 =09=09if (mem->mem_type !=3D TTM_PL_SYSTEM) {
-=09=09=09ret =3D ttm_bo_populate(bo, false, ctx);
+=09=09=09ret =3D ttm_bo_populate(bo, mem->placement & TTM_PL_FLAG_MEMCG, c=
tx);
 =09=09=09if (ret)
 =09=09=09=09goto out_err;
 =09=09}
diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo=
_util.c
index 944dc9906173..76a3e1756f97 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -167,7 +167,7 @@ int ttm_bo_move_memcpy(struct ttm_buffer_object *bo,
 =09src_man =3D ttm_manager_type(bdev, src_mem->mem_type);
 =09if (ttm && ((ttm->page_flags & TTM_TT_FLAG_SWAPPED) ||
 =09=09    dst_man->use_tt)) {
-=09=09ret =3D ttm_bo_populate(bo, false, ctx);
+=09=09ret =3D ttm_bo_populate(bo, dst_mem->placement & TTM_PL_FLAG_MEMCG, =
ctx);
 =09=09if (ret)
 =09=09=09return ret;
 =09}
@@ -354,7 +354,7 @@ static int ttm_bo_kmap_ttm(struct ttm_buffer_object *bo=
,
=20
 =09BUG_ON(!ttm);
=20
-=09ret =3D ttm_bo_populate(bo, false, &ctx);
+=09ret =3D ttm_bo_populate(bo, mem->placement & TTM_PL_FLAG_MEMCG, &ctx);
 =09if (ret)
 =09=09return ret;
=20
@@ -537,7 +537,7 @@ int ttm_bo_vmap(struct ttm_buffer_object *bo, struct io=
sys_map *map)
 =09=09pgprot_t prot;
 =09=09void *vaddr;
=20
-=09=09ret =3D ttm_bo_populate(bo, false, &ctx);
+=09=09ret =3D ttm_bo_populate(bo, mem->placement & TTM_PL_FLAG_MEMCG, &ctx=
);
 =09=09if (ret)
 =09=09=09return ret;
=20
diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_v=
m.c
index c5ad447debe3..dddc904f8727 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -226,7 +226,7 @@ vm_fault_t ttm_bo_vm_fault_reserved(struct vm_fault *vm=
f,
=20
 =09=09ttm =3D bo->ttm;
 =09=09err =3D ttm_bo_populate(bo,
-=09=09=09=09      false,
+=09=09=09=09      bo->resource->placement & TTM_PL_FLAG_MEMCG,
 =09=09=09=09      &ctx);
 =09=09if (err) {
 =09=09=09if (err =3D=3D -EINTR || err =3D=3D -ERESTARTSYS ||
diff --git a/include/drm/ttm/ttm_placement.h b/include/drm/ttm/ttm_placemen=
t.h
index b510a4812609..4e9f07d70483 100644
--- a/include/drm/ttm/ttm_placement.h
+++ b/include/drm/ttm/ttm_placement.h
@@ -70,6 +70,9 @@
 /* Placement is only used during eviction */
 #define TTM_PL_FLAG_FALLBACK=09(1 << 4)
=20
+/* Placement should account mem cgroup */
+#define TTM_PL_FLAG_MEMCG=09(1 << 5)
+
 /**
  * struct ttm_place
  *
--=20
2.49.0


