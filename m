Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85472C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 22:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CDB76B008C; Wed, 16 Sep 2026 18:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657B96B0092; Wed, 16 Sep 2026 18:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 546616B0098; Wed, 16 Sep 2026 18:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 28C036B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:55:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 65AA31C0598
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:55:36 +0000 (UTC)
X-FDA: 85221133872.18.04A4BAF
Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9164B80002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:55:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YV2Y+rWj;
	spf=pass (imf02.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.231.204 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789599334;
	b=ETkIg7SrGE1hOVZaaFpC/fasCM7z9z37EpaOqzYPtOsbh7e0gJjShoSigPH7Nm/4dXJH17
	jOXM1r2NnzqOFOWkKFTWiyYpUDthv4sIVpP00BwK/63Dalyeph5gc4ymRpIBpnHePaiQrk
	FMNThb1u+GTo6QW0yST47DuSgxhCC7k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YV2Y+rWj;
	spf=pass (imf02.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.231.204 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789599334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gODPpc0D3faf2BH7sO0ryHejlY60ik6Qifsk28IBlL8=;
	b=tWXeBxR06mUdqanO9+mGXLXsm35oNDoZ35M6CpoBWOwMKoRtfSwsuhRf2EJJ707UcRGaOE
	C9+fOTZZk8xELKTQdbfEzL9zpqx/nyQDwWrT9kVp4Ot2AI+OSaxWoji8FyhmSlIREqRxf8
	o/5iw8jTqNStAIRGd+ijix/EzmO2PzQ=
Received: by mail-oi2-f12.google.com with SMTP id 46e09a7af769-7fcb425fb68so142002a34.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789599333; x=1790204133; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gODPpc0D3faf2BH7sO0ryHejlY60ik6Qifsk28IBlL8=;
        b=YV2Y+rWjHC5rdW6qiy4WURZ9ZtKVMTLIknetR8BbQ8tKD/4ZF5IzoPAupkI8LM651+
         DfFdnEEkMmMFbh7OUBxInGc739BHHNccnPz192uf/e0FUcHoVrx1TcmIooUR0MO4NRVY
         5t0+bXUAB+TflIcbYBDjWEZy1ouWFbba3VSgT6EREuQFYZN3upPN2YqT0gJ8br0Zehfd
         TiQEFWWKAAnFSREYCAmA8UrTRYEoFlV7lwo2DysO5zuBc/f/Y6izZsnECgsf7e3bi+Uj
         Sb6ZJRHpLncWNFFgIgpe696ZO1fcbA98Kxw8o7i5VyF8K6Jru0UMMM+B/AswTW5pUgbs
         t1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789599333; x=1790204133;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gODPpc0D3faf2BH7sO0ryHejlY60ik6Qifsk28IBlL8=;
        b=s/ZsBSK8x21bmhndzQ0BPGc86Ap4oO1kB9f5e9JfFZNdu6tyBvesKBAd3Xlt6Ji63a
         bwb7zCq7wlszj2FnewWyB/vxu/GS7qfIMbfUrCcQH1avE0Xdqj7qIPXKKm5GaLz7TjjK
         7o9jOXVXGkq12atvEIyCuDc9TYrCfJLFCI0B8jUrqU88fpHy338z2xZ7HYmP+cLcjOm6
         ZnH+gwYtEGqLT2xo5j7wC2ihP3Udf8un6vMZA4oLZ/m1HBL/QT+Bjn1lMC7Qvd1Prv65
         WfU4UiL5rI0lN/X+jFyGY1wb/c0/CBrCwluos58oCxkq9fjx6/nJdkcwdYyB8PEI48fn
         0Uow==
X-Forwarded-Encrypted: i=1; AKwUvBycoLY9JaFNHmZT0L5wQdfpHh08AtnDd6MJYFAwMSjTailuJ4aCovW7hUhQbMBhl93CsrV5T5IHkg==@kvack.org
X-Gm-Message-State: AFuF++mtxvWz0zuoO3bDpgAy7ixnVBgZLlP9NUbKyPD5NEe3epzFo1Ee
	psdt48FOxw4SVkDkJgljsVMkrG7WKo/FBOHT7AaGR3M3tjY1gUUfWkv3vMciJA==
X-Gm-Gg: AYBFou1jP7dO2k0ranLuwmRhOQ2uzj2uRf3NPPKMouvoOZbmQQX69gs0FQXJaiClIZx
	5eCE8av040nzYT04bHv/sYWDoO6NmYKWu2nXWyixD6G/Dab628bwkb+ZqGtK/e+LONAxZj4Jhj/
	uxgv6oSwlf4PVfnDqoWbNPbJWBVYvGbipdLSRwxfvbMAvxFglyoziV2DKCJyDz2o79OO1DtVurB
	3v7gNcG9oQk+/mr1IZRAe7RhsNdw5GEV5m+Kfbk61oLKeaL6+unxy1hjIeQduqrF5in/bkAn/Uz
	ASGyJpBk9SDpaEwSn9Q+tXJTHmS6FW+9IYLUBJY/qwXH0Z55wQU8Vd8gIpXF3V+eLWX2F2SYI6/
	FIh5H23nuDwqL8/Rpxg5k3a4/TVlkdBklJVVIqSwCNdaw8+HHXY1CVQtyEUGzlUPas2jRQG1tzq
	S8+Xs1mc1M4BkyQeT0ixk95Z8IbcYA0TvXiAwQlFGnjIIgI7Gegb7p2ZjjEZageIx9is58yzOWP
	DieYDCo2DAuQJYGXEg3jpRzmPZ7d33ScA02zhzvw4QzifXDI2k=
X-Received: by 2002:a05:6830:6815:b0:806:e047:cd7d with SMTP id 46e09a7af769-80b2c28e95cmr4952106a34.7.1789598915663;
        Wed, 16 Sep 2026 15:48:35 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:4b::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-80c46199e96sm1154633a34.6.2026.09.16.15.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 15:48:34 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: usama.arif@linux.dev,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	alex@ghiti.fr,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 2/3] mm/huge_memory: don't queue folios that can never be underused
Date: Wed, 16 Sep 2026 15:44:36 -0700
Message-ID: <20260916224437.1164512-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260916224437.1164512-1-joannelkoong@gmail.com>
References: <20260916224437.1164512-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9164B80002
X-Stat-Signature: ydnfargnxbaz3en55x3bfqrmc51rntbi
X-HE-Tag: 1789599334-785824
X-HE-Meta: U2FsdGVkX18rKIp3p+Ud2HTX+ce9i2E2rMhPBlKPhwlsdr3EU2UW3spa7FTOjuDx31ihsGLWgcnxjmusKIvPwBC73F6owEy8ZkfBkIN6KfPx4ZAVEmel9mnm5ud2Rs3UPLr527Br66ju/tavKCKKPQaFH5fBtoqVxbO5n4Vj5C8naRxk3/n8RAQRk5DYiCP0kFByw0SWJvKJzfnSUh+SAueV9ZEzGapfpUa7Q3U1ociL1XMk4mpWRZE2OK/nwknKLOgJzuPl47YEsoD9hGsaJwsTorEkvpjGHGn0h5Nvh3t7pVP5I17361Y3JQ6hfLBXzel+cofRmebKYnMDj7IkucXOIB0sNvSw7JeRW7+3GSNeGDX3uitmyejEJPw8IALpYJai8/WC0Vm/dbf3lShU+5L4PhYo8pSlfxV7hXYLDLkS47f7a0iURdO9oGj15eFNhJrvLwaRVVJfk9CY9IVfVDDD0PO7s2R7m8mvCKuJwuAZP6PRgCBLdoMPLjrD/oxpgAoPHV19t6pVl0kZEM7wKQOc1GGyZv4ROAmOj5CozfGUEbCZUu1yv7z8tgsgep6Lh5T7u7taoxCT+TX6J7l8ppUGB5pXG1gykJSzJGd/Gz2Jez032JW//j0AJyyDONhITTJjBe+MLEO/K2MGRyOhW9fjJuitfPgtFc5NQ5BuYJSOh9Wt5l0oqgS3BhHAmsar7/DSBEzRc8LQL1lrWzah4z6QExI0JRM09Br3fIz1jDJUDqH9gTBMi3pvBj/qZtVovUsqDWW3SHDvcf71obb7Gqh7ko2SAlxCimzl8/jwnerdAeaMV/THJw9bsDwpRCdDh3XzlMd38q6mHg4kBHG4/JE0WudmCYJv+nOoZC/QlxWU8DlYkuCs4hvW2aOP6TyLiClhpdTe5auwevufb6eJ8r7QM/ovq98EwUpcFgqSQfSjd0QuChqw5UNzZUkfdmu3r8cXHn7Kng8wbiHir02
 Mh3t3KR5
 cxtX83UEZAK2IIvwxNMsT/JOlZVME3/RP6eo4sueFpVxEbF3vdTyP+q3lSa+lEzPcs+niF8CVLwvK1rsHLCueL4dkgZHOmv3GGNlhpjMSe+efYEqNBdHSNphZCg2nGMTChMxoWlIoXrTXb8KGlEZJdetLd9uGBOkHnCr6QXn4d897bb04s1pSFsO4OhT3+fsGpmz5FfVYVXmwNl+4Y3N7KRjB++V1K6VX1t4dnqLARFOipgbfFT0M327KcLRGno+L+y3VI4/E7PNhgrCEt+m1mXA9yD00L3Ws5FVOq4bZxK7JzocAx1XGEdXxduDrQfAUuGYgqh9d1bq0I4AkARl5fcicFWhRtjPpw4Latc+BibLv9tLHr9Tk05B+8csZi6VYkTWYoeYCMhS1ZpfEMpN1FJ04S/H0UY7whw6EGL61gP6l8UnbtU9hpFwXmihOBFKbqyr1JNeVs03Y6f0KxPSqvwDinISLctSvjs97+/5SaBkQVuV1v3o1xM30SGL6weirp6RI48D+w8PDQTRG88J0yNT+4WfSQKkb+BvjGjAq7QCRt7sY8HKvbkWm8AWLypUUmVrw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every anonymous PMD-sized folio is put on the deferred split queue when
it is first mapped, so that the shrinker can find it under memory
pressure and split it if it turns out to be mostly zero-filled.

With the default khugepaged/max_ptes_none this is wasted work. The
default is HPAGE_PMD_NR - 1, which tells thp_underused() that any number
of zero-filled pages is tolerable, which means the shrinker will never
split any of these folios for being underused. They take the list_lru
lock at fault time, inflate the object count the shrinker reports, and
are then walked and dropped when they're first scanned.

Skip the queuing for folios that thp_can_be_underused() says can never
qualify. At the default khugepaged/max_ptes_none that is all of them,
and once the knob is lowered only folios with more pages than it are
queued. This matters for a subsequent patch that adds anonymous mTHP
folios to the deferred split list, as it prevents small mTHP orders from
taking the list_lru lock on every anonymous fault.

Please note that the queue has always been best-effort. A folio that was
queued before khugepaged/max_ptes_none is lowered gets dropped from the
queue by the first scan that finds it's not underused, so changing the
sysctl has never retroactively applied to folios that were already
scanned. Requeueing eligible folios when the sysctl changes will be
addressed in a separate patch.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/huge_memory.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c6ca2a541128..e3349f2314cb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4573,8 +4573,18 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 	if (folio_order(folio) <= 1)
 		return;
 
-	if (!partially_mapped && !split_underused_thp)
-		return;
+	if (!partially_mapped) {
+		if (!split_underused_thp)
+			return;
+		/*
+		 * Nothing will ever split this folio for being underused, so
+		 * keep it off the queue entirely rather than paying for the
+		 * list_lru lock here and a shrinker scan later.
+		 */
+		if (!thp_can_be_underused(folio_nr_pages(folio),
+					  khugepaged_max_ptes_none))
+			return;
+	}
 
 	/*
 	 * Exclude swapcache: originally to avoid a corrupt deferred split
-- 
2.52.0


