Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3E63CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 16:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F03436B0088; Tue, 19 May 2026 12:00:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3816B008A; Tue, 19 May 2026 12:00:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA2A06B008C; Tue, 19 May 2026 12:00:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CADE06B0088
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:00:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B43AA0658
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:00:40 +0000 (UTC)
X-FDA: 84784632240.26.36A1F27
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id AA318140030
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:00:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HGTwsbgu;
	spf=pass (imf09.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779206437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lxAuh/+LJ+cDVuOYgE+wIRcTwCiP9gqh5qSpye35R00=;
	b=KfKxzbpqiG0ogC525KLHIxWfK2mCfphtB8+C48lPVd++q+MlFr1VsAGL723CsQhP0Tz0LF
	nDoS7ZsJHB5vx2MwuMm+S7BNPEJUXgi4OaObtk0JLszSv4rks230eu8WP/ILMIu+qLuItU
	NfmYJYsC1X6GF65yPe1sOs/bVObiS1A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HGTwsbgu;
	spf=pass (imf09.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779206437; a=rsa-sha256;
	cv=none;
	b=p5jmDmwz6MTFBIU/Pm1HW/VmhVIF8umXFLPQgfgXC71dvlwHqjp2ut5SofC4Ml5XEdWq6R
	BWKwTn9Qeiro2H2PXJpe2Z+DoTPDp8tIFGvMdj/rO8OZSEjyUfJjPeEbFMqp62+wk4QvIA
	fzwRB3DkxuFuaToajj39IwfGWlLjERM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779206436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lxAuh/+LJ+cDVuOYgE+wIRcTwCiP9gqh5qSpye35R00=;
	b=HGTwsbguor4WkEnlLMfbkkPdkKv/AsHFhJutainvFAR6CPxvfb0r6l2m9XIzPVMtcaHkjL
	52SgFEE4HOzcIRP6qDW3CLDBT22DAZBKvuaEeZay8RiFSSCQ6eoTWGxCz2flIGaY6pUo1m
	HIsZILFztz1Xa3ZlMY1ByRB901p52ew=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-381-M8t_wTfENrOse06p9IXsOg-1; Tue, 19 May 2026 12:00:35 -0400
X-MC-Unique: M8t_wTfENrOse06p9IXsOg-1
X-Mimecast-MFC-AGG-ID: M8t_wTfENrOse06p9IXsOg_1779206435
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-8b49260e3d5so19948936d6.2
        for <linux-mm@kvack.org>; Tue, 19 May 2026 09:00:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779206435; x=1779811235;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lxAuh/+LJ+cDVuOYgE+wIRcTwCiP9gqh5qSpye35R00=;
        b=c2JZA7tocyC8QSunjWLcqRSB7+l6pIdJpPehVcYw9CtMvjq89a7x8q/O17CPzMeJ/G
         myaztQAjT8z5GzzqANy3J+3+dFfHgQlkA8NlxVdqikMK7zDb2Tzqq9YrClQAplOKfuB8
         BXtLcekmccxgvTv4qvJM2ldBK4rOfvh0Jw/U4zIJnQxYP5X2e8YJfpNaEJuMwNwJmjOg
         DnDL0kwWI9aw9GqCZzjVRST6JZ9Ymgr2gLj6UOt6OLwpWh2lbjSQSqtSwVXdcVUAFwMT
         F3YZZo7A0KdTotpm3OLCc2fv7E/vzDedZlgDDkADuKaH/Q5/bEmeGylZjpjGpcs9qq+B
         ZqXQ==
X-Forwarded-Encrypted: i=1; AFNElJ+o7Z5BcPGnLQQDy+dnDIn4kvfojhUFxk1MWgoV3mQ6ENC1E6fvJqDhOHYif9tKZRwnHWICdnwC4Q==@kvack.org
X-Gm-Message-State: AOJu0YzzJ/rZ8IHC5QeKhMmCzdCkJJ2kBehzMyER3gPXG/0GMn4qXxvo
	pmsXIR4zAn3T5VWoIhFyJtcGl2PNp9viFUrtwSzddEDBdWR2a7TktlMjA8gaP2vZdRCZY8zMAFh
	zIW+9Ia85OwIkkZEBf9g5yNzSktfQqV8c5I7fW+t12eb7t6sJ0+4p
X-Gm-Gg: Acq92OFGwIrO10ooJjULiOpQbYegB86uQNFLV4nsPkJP8CDJbAX6Eo5qIEaD+TO8dN/
	5RVWeQRs9TWy9INfBCw59mgcoMHB4FcjaX1LNRwWkZg1I30IhMq0KiRh5tnGGEu++Z003sn5bda
	fhGdD7izTM0gYAI9DQC75dpFubVGK1aIxXuwNS5okjio9xY8iRAoMaVQw4z/2k+jIVgUrLKnWv3
	qytT0dz5rqNPt7BvlDbAg8ZG6l/wZ8zNrsR6NOTxwfbZwx+Ek4kIfApexhggKrb7hKFslXAf+BF
	t31bjYKqqa+29ZgNd9BEKsT7CWKlZl0mrSAqMcqu1BGjCjMRve7FAo/t8tO1vXrORxks48qD+aP
	fOVwb3MEkO07KySFjLTIaTaYbhPzKEASTHj6RAmyn3my3W9kleiT7OIDiIi1WDc+QORH86B43cw
	XU
X-Received: by 2002:a0c:ea52:0:b0:8c9:c38a:20e1 with SMTP id 6a1803df08f44-8ca0f5ab3bemr240747506d6.10.1779206434547;
        Tue, 19 May 2026 09:00:34 -0700 (PDT)
X-Received: by 2002:a0c:ea52:0:b0:8c9:c38a:20e1 with SMTP id 6a1803df08f44-8ca0f5ab3bemr240746326d6.10.1779206433782;
        Tue, 19 May 2026 09:00:33 -0700 (PDT)
Received: from localhost (pool-100-17-21-205.bstnma.fios.verizon.net. [100.17.21.205])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ca36095326sm95016266d6.14.2026.05.19.09.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 09:00:33 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Tue, 19 May 2026 11:59:02 -0400
Subject: [PATCH v2 2/2] cgroup/dmem: add dmem.memcg control file for
 double-charging to memcg
MIME-Version: 1.0
Message-Id: <20260519-cgroup-dmem-memcg-double-charge-v2-2-db4d1407062b@redhat.com>
References: <20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com>
In-Reply-To: <20260519-cgroup-dmem-memcg-double-charge-v2-0-db4d1407062b@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <natalie.vock@gmx.de>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
 Dave Airlie <airlied@gmail.com>, linux-doc@vger.kernel.org, 
 Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.2
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tiH1MIRC_m5l8YfetxYqWDd_tfm1CZwmxeB2Z9CP7Gs_1779206435
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AA318140030
X-Stat-Signature: 3msit1aags7xzkotbpgrydpnaa7ikrmd
X-HE-Tag: 1779206437-342327
X-HE-Meta: U2FsdGVkX19NBYSIpgTWuhqhzWkc8aluQJLB0DFvFXz9XCJh7Rtsh7xG99EHG8LwS0VnOwSZ8FBvH4LdUHH67y1uszu60gVx2EBqYRbnuEQvs0tKeb7CudZgZ8laV3RUAbNZdyt8oMffjD4oPXXJhOGf1sOQzsr/3gV5/VcN0lVUtJXaEOWMAhnM0l794bh7BtpyGrsfIvlKBL+hol4EfLnvx+0HjgKzvATKeCf3mZPumQalaJHWXErv6AvfQwn9M47BDI8unrNhxlRRP0IfQwJ218DsRWfowVc+P2mQySFtIIOFeu9c5m7xh57fuB5SSlDfaRQj8D4sz+8ZRk+Y04TexeAa31ma5+3CuKc2edQCxRzeBWaMU65iNUKcIRQ/en8suLEd1z4yf67BbWNONmEylcERcmRBvZbEPMpa9Ke0ASV+eX4YOg1Sn1bxTQGVRFJne5XU006MwlxUC6TP0xx7kAKe6+/9PoDtI5x4+mR0aDw40Tr+KsPq7mrdk/mZ2DepctwPu/B7goWSQ0TuFKO1kjSnIj8mmk2p9PMCjFFEoq4qiIf2L4j0i83ogLuv80zp0h9pzMEoDdYNtwjcGUgknzU7BrnXKTEo0Twbx8THYEmqXOzkawGK2JLmDB5dn9mtOucekTNv+OhIuQNpYXQkIClFGn0Hyfp9Fd+ZKelK6mXy/maCBLvdmoizIaNW9soFuVUqXhWvQ+P0gxELFgN+uUHDZI6ajebsNDzXZbyPQbIzH/+JNfyQMyqpcvLg6v2b4FAYG/nAeWDx3gxZ+PIYU6PtxdmigC9sF1lhNLDNicICmct3hjPxSgcJF0SZUdmVe57cGuw3j4kCBysQmU+NIDidemXuE4cOrMzMPUdTsOvnH+PhlBCwi50HhsEuv5yNG0Q4wH2xwpT9a3O3pltFzCjLGYP8d6lZeYWHy048es5mEh6GocRvoo3NsyEbmr1l1j/XR2NIsouOpqK
 nogVeN2e
 YyrTx9bxlnXo2KFbZVtaJvy1ScRQS5GujOBCEJvgiJib0WyALFcffGImUv5IrvArES3BueNVMDu36j06a5Let78b2H5RN7jbedyBQ1SLdWZT87LUactcbAYHQ2kDGbsAVNoQCArXsDenpwCKI1zePj005jpDy9sMaJ0ULvOFxsniEDZu3JQ717aAiOu2JNO/eq4+s+DU3NBx4avqHa62oNjLNgiYQl3Ihi/emdWMNbRawcRBmGN9L4y2P4TQqiN3h6Wa50qWxbWA2U9LMrJLTKJkU84VeGHKjpoO4S0h8XgUn//AzRoX5B3zThV7LaaFlPwascLcZONWnieZFoiYFi0l++l9LATwq9hhRdQvFOsCqf86B3vqvxjGzUIhDXoA4snN460T0RtL3ylLbuyqwoP+mGW1F/UxdmmiHrD+jz/Xp5zxOAHje2ddDyo9NHzuFK9HXwXRwYBGnAqvSLrFv2XHZyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a root-only cgroupfs file "dmem.memcg" that lets an administrator
configure whether allocations in a dmem region should also be charged to
the memory controller.

To handle inheritance, dmem adds a depends_on the memory controller,
unless MEMCG isn't configured in.

Double-charging is disabled by default. Once a charge is attempted, the
setting is locked to prevent inconsistent accounting by a small 4-state
machine (off, on, locked off, locked on).

The memcg to charge is derived from the pool's cgroup, since the pool
holds a reference to the dmem cgroup state that keeps the cgroup alive
until it gets uncharged.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst |  23 +++++
 kernel/cgroup/dmem.c                    | 158 +++++++++++++++++++++++++++++++-
 2 files changed, 178 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 6efd0095ed995b1550317662bc1b56c7a7f3db23..1d2fa55ddf0faa17baa916a8914d3033e8e42359 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2828,6 +2828,29 @@ DMEM Interface Files
 	  drm/0000:03:00.0/vram0 12550144
 	  drm/0000:03:00.0/stolen 8650752
 
+  dmem.memcg
+	A readwrite nested-keyed file that exists only on the root
+	cgroup. It configures whether allocations in a dmem region
+	should also be charged to the memory controller.
+
+	Upon the first charge to a region, its setting can no longer be changed
+	and is reported as "[true|false] (locked)".
+
+	Charges to the memory controller are visible in ``memory.stat`` as the
+	``dmem`` entry, reported in bytes.
+
+	An example read output follows::
+
+	  drm/0000:03:00.0/vram0 false
+	  drm/0000:03:00.0/stolen false (locked)
+
+	Writing uses the same nested-keyed format::
+
+	  echo "drm/0000:03:00.0/vram0 true" > dmem.memcg
+
+	This file is only available when the kernel is built with
+	``CONFIG_MEMCG``.
+
 HugeTLB
 -------
 
diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
index 1ab1fb47f2711ecc60dd13e611a8a4920b48f3e9..e07b20b8025c528f190f84c76b088cb8a32a7f5e 100644
--- a/kernel/cgroup/dmem.c
+++ b/kernel/cgroup/dmem.c
@@ -17,6 +17,14 @@
 #include <linux/refcount.h>
 #include <linux/rculist.h>
 #include <linux/slab.h>
+#include <linux/memcontrol.h>
+
+enum dmem_memcg_status {
+	DMEM_MEMCG_OFF,
+	DMEM_MEMCG_ON,
+	DMEM_MEMCG_LOCKED_OFF,
+	DMEM_MEMCG_LOCKED_ON,
+};
 
 struct dmem_cgroup_region {
 	/**
@@ -51,6 +59,14 @@ struct dmem_cgroup_region {
 	 * No new pools should be added to the region afterwards.
 	 */
 	bool unregistered;
+
+	/**
+	 * @memcg_status: Whether allocation in this region should charge memcg.
+	 * DMEM_MEMCG_OFF/DMEM_MEMCG_ON or
+	 * DMEM_MEMCG_LOCKED_OFF/DMEM_MEMCG_LOCKED_ON, frozen after first allocation.
+	 * Transitions to a locked state are one-way.
+	 */
+	atomic_t memcg_status;
 };
 
 struct dmemcg_state {
@@ -609,6 +625,34 @@ get_cg_pool_unlocked(struct dmemcg_state *cg, struct dmem_cgroup_region *region)
 	return pool;
 }
 
+static bool apply_memcg_charge(atomic_t *status)
+{
+	int state = atomic_read(status);
+
+	for (;;) {
+		switch (state) {
+		case DMEM_MEMCG_OFF:
+			state = atomic_cmpxchg(status, DMEM_MEMCG_OFF,
+					       DMEM_MEMCG_LOCKED_OFF);
+			if (state != DMEM_MEMCG_OFF)
+				continue;
+			return false;
+		case DMEM_MEMCG_LOCKED_OFF:
+			return false;
+		case DMEM_MEMCG_ON:
+			state = atomic_cmpxchg(status, DMEM_MEMCG_ON,
+					       DMEM_MEMCG_LOCKED_ON);
+			if (state != DMEM_MEMCG_ON)
+				continue;
+			return true;
+		case DMEM_MEMCG_LOCKED_ON:
+			return true;
+		}
+		WARN_ONCE(1, "Invalid memcg_status (%#x).\n", state);
+		return false;
+	}
+}
+
 /**
  * dmem_cgroup_uncharge() - Uncharge a pool.
  * @pool: Pool to uncharge.
@@ -624,6 +668,12 @@ void dmem_cgroup_uncharge(struct dmem_cgroup_pool_state *pool, u64 size)
 		return;
 
 	page_counter_uncharge(&pool->cnt, size);
+
+	if (atomic_read(&pool->region->memcg_status) == DMEM_MEMCG_LOCKED_ON &&
+	    !WARN_ON_ONCE(size > (u64)UINT_MAX << PAGE_SHIFT))
+		mem_cgroup_dmem_uncharge(pool->cs->css.cgroup,
+					 PAGE_ALIGN(size) >> PAGE_SHIFT);
+
 	css_put(&pool->cs->css);
 	dmemcg_pool_put(pool);
 }
@@ -655,6 +705,8 @@ int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 	struct dmemcg_state *cg;
 	struct dmem_cgroup_pool_state *pool;
 	struct page_counter *fail;
+	unsigned long nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+	bool charge_memcg;
 	int ret;
 
 	*ret_pool = NULL;
@@ -670,7 +722,28 @@ int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 	pool = get_cg_pool_unlocked(cg, region);
 	if (IS_ERR(pool)) {
 		ret = PTR_ERR(pool);
-		goto err;
+		goto err_css_put;
+	}
+
+	charge_memcg = apply_memcg_charge(&region->memcg_status);
+	if (charge_memcg) {
+		/* mem_cgroup_dmem_charge limitation from try_charge_memcg */
+		if (size > (u64)UINT_MAX << PAGE_SHIFT) {
+			ret = -EINVAL;
+			dmemcg_pool_put(pool);
+			goto err_css_put;
+		}
+
+		if (!mem_cgroup_dmem_charge(pool->cs->css.cgroup, nr_pages,
+					    GFP_KERNEL)) {
+			/*
+			 * No dmem_cgroup_state_evict_valuable() could help,
+			 * there's no ret_limit_pool to return.
+			 */
+			ret = -ENOMEM;
+			dmemcg_pool_put(pool);
+			goto err_css_put;
+		}
 	}
 
 	if (!page_counter_try_charge(&pool->cnt, size, &fail)) {
@@ -681,14 +754,17 @@ int dmem_cgroup_try_charge(struct dmem_cgroup_region *region, u64 size,
 		}
 		dmemcg_pool_put(pool);
 		ret = -EAGAIN;
-		goto err;
+		goto err_uncharge_memcg;
 	}
 
 	/* On success, reference from get_current_dmemcs is transferred to *ret_pool */
 	*ret_pool = pool;
 	return 0;
 
-err:
+err_uncharge_memcg:
+	if (charge_memcg)
+		mem_cgroup_dmem_uncharge(pool->cs->css.cgroup, nr_pages);
+err_css_put:
 	css_put(&cg->css);
 	return ret;
 }
@@ -845,6 +921,71 @@ static ssize_t dmem_cgroup_region_max_write(struct kernfs_open_file *of,
 	return dmemcg_limit_write(of, buf, nbytes, off, set_resource_max);
 }
 
+#ifdef CONFIG_MEMCG
+static int dmem_cgroup_memcg_show(struct seq_file *sf, void *v)
+{
+	struct dmem_cgroup_region *region;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(region, &dmem_cgroup_regions, region_node) {
+		int state = atomic_read(&region->memcg_status);
+
+		seq_printf(sf, "%s %s\n", region->name,
+			   state == DMEM_MEMCG_ON ? "true" :
+			   state == DMEM_MEMCG_OFF ? "false" :
+			   state == DMEM_MEMCG_LOCKED_ON ? "true (locked)" :
+			   state == DMEM_MEMCG_LOCKED_OFF ? "false (locked)" :
+			   "(invalid)");
+	}
+	rcu_read_unlock();
+	return 0;
+}
+
+static ssize_t dmem_cgroup_memcg_write(struct kernfs_open_file *of, char *buf,
+				       size_t nbytes, loff_t off)
+{
+	while (buf) {
+		struct dmem_cgroup_region *region;
+		char *options, *name;
+		bool flag;
+
+		options = buf;
+		buf = strchr(buf, '\n');
+		if (buf)
+			*buf++ = '\0';
+
+		options = strstrip(options);
+		if (!options[0])
+			continue;
+
+		name = strsep(&options, " \t");
+		if (!name[0])
+			continue;
+
+		if (!options || !options[0])
+			return -EINVAL;
+
+		if (kstrtobool(options, &flag))
+			return -EINVAL;
+
+		rcu_read_lock();
+		region = dmemcg_get_region_by_name(name);
+		rcu_read_unlock();
+		if (!region)
+			return -ENODEV;
+
+		atomic_cmpxchg(&region->memcg_status,
+			       flag ? DMEM_MEMCG_OFF : DMEM_MEMCG_ON,
+			       flag ? DMEM_MEMCG_ON : DMEM_MEMCG_OFF);
+		/* Continue if a region is already locked. */
+
+		kref_put(&region->ref, dmemcg_free_region);
+	}
+
+	return nbytes;
+}
+#endif
+
 static struct cftype files[] = {
 	{
 		.name = "capacity",
@@ -873,6 +1014,14 @@ static struct cftype files[] = {
 		.seq_show = dmem_cgroup_region_max_show,
 		.flags = CFTYPE_NOT_ON_ROOT,
 	},
+#ifdef CONFIG_MEMCG
+	{
+		.name = "memcg",
+		.write = dmem_cgroup_memcg_write,
+		.seq_show = dmem_cgroup_memcg_show,
+		.flags = CFTYPE_ONLY_ON_ROOT,
+	},
+#endif
 	{ } /* Zero entry terminates. */
 };
 
@@ -882,4 +1031,7 @@ struct cgroup_subsys dmem_cgrp_subsys = {
 	.css_offline	= dmemcs_offline,
 	.legacy_cftypes	= files,
 	.dfl_cftypes	= files,
+#ifdef CONFIG_MEMCG
+	.depends_on	= 1 << memory_cgrp_id,
+#endif
 };

-- 
2.52.0


