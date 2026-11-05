Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE916606D80B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 08:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xl6rJmUN
Received: by kanga.kvack.org (Postfix)
	id 8F01E6B05B9; Thu,  5 Nov 2026 03:44:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C8246B05BA; Thu,  5 Nov 2026 03:44:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B67A6B05BB; Thu,  5 Nov 2026 03:44:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54D3F6B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:44:21 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 50902120925
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:20 +0000 (UTC)
X-FDA: 85400428680.23.7FD31DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 811F6180008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xl6rJmUN;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793868258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZaNkuK+CuZCH16Zfn9adKcMMnVfFDERJiwr1XCFoM7M=;
	b=hSRxUGiUuf9NIE8QlCOPdNNyiQ+zDCRKJWXAZMr9TkZJQ7Qrpep5Q0fZ0JHWPQVVNXht7w
	e4l0wCv+YlAS7kOApmIr2KKsSr7iBz/H8nzsccrCcYAAOaiVIlsubzeP1+SzOKh1PWBw1G
	XBkJtnF4iogO4jF3vov/JeuUyNnkHPA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793868258;
	b=iDyM50pZSfg0mU0lZzx7SwiBtqCOggfXzzZ3YjqvWW7kI9/M6nX/sfLSsannQbdSbtk3Us
	reP0EMkBQbWOsGMM5ejxu4lAZM3ZJQX3pe25H/Y8S4kV7FWd+TSx4l10EPhdoCZurj+0EZ
	u5/VJhHvdXQ1FnG5PzNN6u+4xA0ka44=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xl6rJmUN;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C23D2436F2;
	Thu,  5 Nov 2026 08:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709831F00A15;
	Thu,  5 Nov 2026 08:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793868257;
	bh=ZaNkuK+CuZCH16Zfn9adKcMMnVfFDERJiwr1XCFoM7M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Xl6rJmUN/DWrJon99nZtxTbfk5UDamIX8Eq/y4HE94KYkSeXgDheIx+53+ZQXd1Mu
	 0k/BcEHNgJQsE7TMa0C3mD1aclFY0HQgwxmwGUdYvkPy5Y5QXplmW0GjNqokKIbklS
	 9iz0MpLl7bh6vPvauR9kFF/es4F1pI94mOdmOXv7NqAZ/GtvlVvyfM5Bn1RYdz2mjy
	 omCm9bRJ67oFRb4w6BgXx9sow/DiQOP3Yt/y+fmktLRG05HRq/QLdnXVmrOpx7iPiZ
	 G3Fuw4HJgbR2Lf/LgqGjojP4OkERYm/vSAr8k8gXDTmWnvSaeeC3oqHV4mq/T8zR1z
	 YLOG9Herkid2w==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Thu, 05 Nov 2026 09:43:55 +0100
Subject: [PATCH v3 06/10] mm, slab: make SLUB_TINY handling dynamic for
 sizing decisions
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-slub_tiny_rework-v3-6-0484ce59eabb@kernel.org>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
In-Reply-To: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
To: Harry Yoo <harry@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam06
X-Stat-Signature: s169gn5ahtbc9wsa3fypfik8ysbybcrp
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 811F6180008
X-Rspam-User: 
X-HE-Tag: 1793868258-341889
X-HE-Meta: U2FsdGVkX1/wN+j94RFhW2NNt5tHewQYjQmj1Dyd+M6eFJOaNXYKNefoOLwJh8Wjj8+AHdcOjkcAtLezZxLfQrMlT6dEdyTPD6jrSCLGz4vHcBA2tzn2qQxM8ao+bhiNHT5wRpNi/Z9Enb5guyuSyyVV+AvJpt5gPmZsWGun+rltmWxLP8/SdAYkU4bUxSbPTP/IyayoALyoyaQFTSQae/V7SUrDNwIxe4t6FavHr6Sfw1h7Fhg9FCIeqtBvkuVLBg15mdBv1fqBWmYZGdpydxYufatVauODSZFDhXrGw+sT0fHaakKZynX+wh1RkvuytULnfOdZx+G4HS53yOO1wi9aHLOUIqZmZFxqRQYVyJO4Gyw13uqXPdpMAltlEw0qmViuZMNa36pRpTibND46nh1MCY7ARJryA2KKlh5ergEjgQ6fZpNtQB03Ad9/p8BQqVsVftWE3EVHiTgqeC6+OeH5tezNmkO358NNMJIJ/cFQBDy7tsQHXfPLNoZN2VZc1V9y8B06UyEf8KMfafCNY/xTT2oZFklDkB0/vkPfN3YWh/PkluXV3p8K7ftuiFbccioO9S8Qu24B3d4GLES1KNkSWNOpb5Y/wRgmdk/ezqZV7kAPle/06ZxFxiNNVjgpnY8qFhYSnaN5oTswXo5T2p/CNsYWwCWCIy7CGnSotafmVCi8kRL0XBr6A3PquP3mh6pr4z4hS17h1WzuWKFFd0AqI74s6OPAGEyIJ4rxGAqx/6xHJ0TyrxmjyFP1+4Y5WYXsp0KO/it4tYKYynVX92Njm2l9OnlFnTyQAh42XoAyPOiHRMGXqZT4kFCzLHoE8SWFZYnfeZFfG7O+Vu1hsU1FAxbgXcB4hwLiUp3nQDj/gHk/zqX338wHVn8pwF6gYIoAFSj860RLj34gRB1aa9ajU3hOxgDV2YeDu1gdUk3lOh3k1I2pIfustPDK6k5qmSF5Ol08e5EOVFQ4hng
 MFMdewk4
 qjdDHotHkyLH82jDWC6IqNlb+VEnhcxUkd58HWk0yKphquEZRCUiOERqR21ST3RntgntjcDX5jqRLugmtERUQNsQqKGl9bXb5sbJAcIK2UVHALBw4uSAMmqyJb1ElEOIEbFNQ1xxQVPcSQHk6Rqb9DnZX73ubjK5xbd0M4Odkatkhf/xhIM36HcALyqgOU+7+Rzq+Hgv5l5TcTeTApfSdkLnVeA/VEOsPQMAcHPKr5YBVYWSKSy4nuJlWvNgBdgkBWI+a2yzzFEKD9o8oc/tqPDK/Oc9dxN3cMvaJmpzoYKAe/r2gpfg0pGpHWaV9AxHV8ywP5reP+Uc+YZvydBCO/mAqKlte2G2aik++U8NF7Kx1ap2l0vnWF61wYhPyuhR4dtslgApJPPnQQ8uY4ys6xatVKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Enabling CONFIG_SLUB_TINY results in the caches' min partial slabs
threshold to be zero, thus every slab where all objects become free is
freed immediately. It also sets the default slab_max_order to 1, with
the goal of reducing the potential of internal slab fragmentation.

Rework both of these decisions to be based on the newly introduced
slab_tiny_enabled flag instead of #ifdefs. It's still possible to
override the reduced slab_max_order with the boot parameter, as before.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a3ee1bdf0eb3..be4e1f193295 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -272,7 +272,6 @@ void *fixup_red_left(struct kmem_cache *s, void *p)
 /* Enable to log cmpxchg failures */
 #undef SLUB_DEBUG_CMPXCHG
 
-#ifndef CONFIG_SLUB_TINY
 /*
  * Minimum number of partial slabs. These will be left on the partial
  * lists even if they are empty. kmem_cache_shrink may reclaim them.
@@ -285,10 +284,6 @@ void *fixup_red_left(struct kmem_cache *s, void *p)
  * sort the partial list by the number of objects in use.
  */
 #define MAX_PARTIAL 10
-#else
-#define MIN_PARTIAL 0
-#define MAX_PARTIAL 0
-#endif
 
 #define DEBUG_DEFAULT_FLAGS (SLAB_CONSISTENCY_CHECKS | SLAB_RED_ZONE | \
 				SLAB_POISON | SLAB_STORE_USER)
@@ -7706,8 +7701,7 @@ EXPORT_SYMBOL(kmem_cache_alloc_bulk_noprof);
  * take the list_lock.
  */
 static unsigned int slab_min_order;
-static unsigned int slab_max_order =
-	IS_ENABLED(CONFIG_SLUB_TINY) ? 1 : PAGE_ALLOC_COSTLY_ORDER;
+static unsigned int slab_max_order = PAGE_ALLOC_COSTLY_ORDER;
 static unsigned int slab_min_objects;
 
 /*
@@ -8027,7 +8021,7 @@ static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
 	size_t size;
 
 
-	if (IS_ENABLED(CONFIG_SLUB_TINY) || s->flags & SLAB_DEBUG_FLAGS)
+	if (slab_tiny_enabled || s->flags & SLAB_DEBUG_FLAGS)
 		return 0;
 
 	/*
@@ -8763,6 +8757,9 @@ void __init kmem_cache_init(void)
 
 	slab_obj_ext_has_codetag_init();
 
+	if (slab_tiny_enabled)
+		slab_max_order = 1;
+
 	if (slab_max_order_param <= MAX_PAGE_ORDER)
 		slab_max_order = slab_max_order_param;
 
@@ -8886,6 +8883,8 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 	 */
 	s->min_partial = min_t(unsigned long, MAX_PARTIAL, ilog2(s->size) / 2);
 	s->min_partial = max_t(unsigned long, MIN_PARTIAL, s->min_partial);
+	if (slab_tiny_enabled)
+		s->min_partial = 0;
 
 	s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
 	if (!s->cpu_sheaves) {

-- 
2.56.0


