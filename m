Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ACA3C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 01:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCF0F6B008C; Mon, 21 Jul 2025 21:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7EBD6B0092; Mon, 21 Jul 2025 21:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6EBF6B0093; Mon, 21 Jul 2025 21:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9981C6B008C
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 21:50:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 64A5B12EA51
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:50:53 +0000 (UTC)
X-FDA: 83690221986.10.5F05389
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7E5BA40009
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:50:51 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=softfail (imf01.hostedemail.com: 207.211.30.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753149051; a=rsa-sha256;
	cv=none;
	b=tuqCn/cZ0pFYwby/GBm59Kn28dRqcFfOVpag/AzSkdwiCu8ZDYaON8EaxGwtfiLi/gMZrM
	+ljPMFE447akL91eJtIYTucJ96khUSzpZIN9gIZI45mi0bBGCZvCalSeh6ahA7LB46AepB
	UQzX1q2PaowYWXjp8bXOLs02WDsh1EY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=softfail (imf01.hostedemail.com: 207.211.30.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753149051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GLmClCryQVLPQm+xrtkN5QbcKOKWO80SNkwQ8OGeyvw=;
	b=mqiC8gIYUX//MK/ci7J9gTepcImc5B9r6hEyK7i9GvXuVdxQZl3pc9Wf00KTTnO2CgWABC
	DC71pYJUITjW8lZ8ZsqfO0L68Ln+JZd3C9g1IOoyqwZTVvI0jxeGAkWPCGnfHiMx158/Kq
	R2K7SuSbJZVMBGuMIRq1tM7lLSgdU7I=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-199-x3gnI-77NLeDNv8nxrq9bw-1; Mon,
 21 Jul 2025 21:50:49 -0400
X-MC-Unique: x3gnI-77NLeDNv8nxrq9bw-1
X-Mimecast-MFC-AGG-ID: x3gnI-77NLeDNv8nxrq9bw_1753149048
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 12F3E1956046;
	Tue, 22 Jul 2025 01:50:48 +0000 (UTC)
Received: from dreadlord.redhat.com (unknown [10.67.32.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9B73A19560A3;
	Tue, 22 Jul 2025 01:50:43 +0000 (UTC)
From: Dave Airlie <airlied@gmail.com>
To: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Christian Koenig <christian.koenig@amd.com>
Cc: Dave Chinner <david@fromorbit.com>,
	Kairui Song <kasong@tencent.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 10/15] ttm: add objcg pointer to bo and tt
Date: Tue, 22 Jul 2025 11:43:23 +1000
Message-ID: <20250722014942.1878844-11-airlied@gmail.com>
In-Reply-To: <20250722014942.1878844-1-airlied@gmail.com>
References: <20250722014942.1878844-1-airlied@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8QXmq-DL3kRqPY1tEw4PbgwFT-1rFQ7XS6iY0LgJsQk_1753149048
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=WINDOWS-1252; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7E5BA40009
X-Stat-Signature: n3aa8fype3zisdt4k313rqajqum88rmk
X-HE-Tag: 1753149051-736291
X-HE-Meta: U2FsdGVkX19+6I55W6IOv9cVDdv/Jpz8jyxzFwWuTyOPOlxtGyKmgGhLYKZteXjYYjac0nujymsDOGAvWcJvD/gfd5goPLGn/LcfLsAS0NuNIT4rp7L3GFtsKhWx9/zE7COIt0Du1djG+5pNVIYp/hIVFIdsLR74+In9kewrZpumZwiIviF0dwAbqqpZU5WhDWxsetdgr1T5Nfue9qmDVwpmiM9+0/NXuGpdMSaGFTr6faJofth2Sfl25gfuTzGkGuqkYB5NFQ2LYIdfFU7PlBYRg1cN+csj8Ijcm3zPuK7GsaE0JN9YhM0nqXlnJXKBQzEXpxx43i0VyGTVvKvG+BMagIMAvHMUydF8drzPxsp/yUNrUE6xf/coOWmBd2MI1Co1VXJeJmQGM8Swrb4byew/Ry6JRf5XTgbxHu2ek1Pl9EUFRSNlyC7YKHH0kyoPYKX6pjEVIqj4v/aTXl3ASZ4NLQI6ZNiMm2NBhdqDku2kOPYr+iXDvjzB5q+lmvlwj3jlA+IHvmhsXGqNX7f/wfdt6RbdI5msCdqIekM1khIaOj3bVDTPQfPWXIxaAuR/bgNbBw3vHBY+96EJsnjtlYijrEp/Xd2B4E+IXGNKznuypehRJZY+u+2noaTGTRWSyCoqSZciHA9hoFyOaEHrg6CQBS6WGb6nH6BIXFe9OjV2zZWYWRBt3mGAR49bjhtV9hOoeWDOCaKbuV9QRxUMimZrFTjsGgp4RYSbbNlhrm4XGz7t33x2XRqemV38EKVTWC3CHHFiJyjrWMBFKgXV3xafcBPfxeQD0+11KPdjMaz4uweUaKJEK08owObP4n+Ngsp6J+aqt+mx1jCEbN3rF7j33qHoYBp7rwMYwsV5Ln36Z9ekith13VbpXp7w2LC4VS/GRNg+COrs+L8Icd7BHvA7Syi/8o/c4/V5mTSuZ9yGNnLFZA7iV0ZEF/OvkNGdps0XH2TeM/ulzSzAjr2
 ZyTbqU8A
 BXEFCMK+dUH6u/gHGlK0tsO1Ui49iKiGwBELetcVw6srqQ3tMC6+nCIQWr6HEg++R8jffcoHqPIoixJqso4jFdZu22lHBwJ2F1LnEqWg6528a8EkQ1qnh8KumqdzhtHjMOU2yo2tsHd7w41qnsfcnXXn38x6d4m8WFXRV8UOxpKKhdFhITdYaB4LL6RUfWbfWfu6emaGRG5N6Qz005S7wdbw5B8c4s1nDBYzXlu6Bh2b8RODMt5YuO9A0atgch7mgezGlCxubHm13phMjZl5iN6lD9/XjsvQp82/3lxERxkHwPIFdT7YNDZqPydYpe6gtyvDwy+YkSt8+kJA2tgGM1w31y9bsEtl0fGTEVvrDH+PlI1ndOmif03+aF05ibpTdH2P56hnne/4hIs+Ykj4qWusFJmejImrFpiN9JIcoquodL/XSavJgPm0k+QH72OxQ1lTeZwC4/96r+gsRnbXLCuUjUYn2+JDWkTJfM41q1xmrhZD9AeGWTgeDrk+0yQEcyDH0OQ2h/9fAWabx26f/ijDeSeTSlBSRnTBvJFZdEizeMm6NzSajEGq/lf5Q2juSkhTo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Airlie <airlied@redhat.com>

This just adds the obj cgroup pointer to the bo and tt structs,
and sets it between them.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/ttm/ttm_tt.c | 1 +
 include/drm/ttm/ttm_bo.h     | 6 ++++++
 include/drm/ttm/ttm_tt.h     | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/drivers/gpu/drm/ttm/ttm_tt.c b/drivers/gpu/drm/ttm/ttm_tt.c
index 8f38de3b2f1c..0c54d5e2bfdd 100644
--- a/drivers/gpu/drm/ttm/ttm_tt.c
+++ b/drivers/gpu/drm/ttm/ttm_tt.c
@@ -162,6 +162,7 @@ static void ttm_tt_init_fields(struct ttm_tt *ttm,
 =09ttm->caching =3D caching;
 =09ttm->restore =3D NULL;
 =09ttm->backup =3D NULL;
+=09ttm->objcg =3D bo->objcg;
 }
=20
 int ttm_tt_init(struct ttm_tt *ttm, struct ttm_buffer_object *bo,
diff --git a/include/drm/ttm/ttm_bo.h b/include/drm/ttm/ttm_bo.h
index 6edff0ec9b72..c33b3667ae76 100644
--- a/include/drm/ttm/ttm_bo.h
+++ b/include/drm/ttm/ttm_bo.h
@@ -135,6 +135,12 @@ struct ttm_buffer_object {
 =09 * reservation lock.
 =09 */
 =09struct sg_table *sg;
+
+=09/**
+=09 * @objcg: object cgroup to charge this to if it ends up using system m=
emory.
+=09 * NULL means don't charge.
+=09 */
+=09struct obj_cgroup *objcg;
 };
=20
 #define TTM_BO_MAP_IOMEM_MASK 0x80
diff --git a/include/drm/ttm/ttm_tt.h b/include/drm/ttm/ttm_tt.h
index 15d4019685f6..c13fea4c2915 100644
--- a/include/drm/ttm/ttm_tt.h
+++ b/include/drm/ttm/ttm_tt.h
@@ -126,6 +126,8 @@ struct ttm_tt {
 =09enum ttm_caching caching;
 =09/** @restore: Partial restoration from backup state. TTM private */
 =09struct ttm_pool_tt_restore *restore;
+=09/** @objcg: Object cgroup for this TT allocation */
+=09struct obj_cgroup *objcg;
 };
=20
 /**
--=20
2.49.0


