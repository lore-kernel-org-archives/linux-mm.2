Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20E64C44507
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 06:44:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0AFD6B0096; Fri, 17 Jul 2026 02:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE28C6B0099; Fri, 17 Jul 2026 02:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5826B009B; Fri, 17 Jul 2026 02:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A96736B0096
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 02:44:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D4B2120486
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 06:44:19 +0000 (UTC)
X-FDA: 84997329438.25.70BF3E6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1398320007
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 06:44:16 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IvcQfNdW;
	spf=pass (imf31.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784270657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YvQD+9gys5Bjr4sehQzMMfeCVCfBYB0aLci2jGBuO4U=;
	b=7Ud+pRBltXVTPFAIkkNj8Q/A6jJZcGRCsEhjExHPLZ6eTEKnoHGjaOfmGxKYySJahxerAe
	xKDXEOQOLCNwNClteCoKwTJlTHCRe2AB3/KBUzsvwDZhgl6p1VGqPS42XdOUvu3x+pkFjX
	RuTILg+XQHcUbn9Y10pNDazDdkaUOnw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IvcQfNdW;
	spf=pass (imf31.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784270657;
	b=Dnu8Nb9gOSc48fRedOzHUuratM0TMT5GhXDesM/Bf5xU8g3KgsTDsnCxv0hXrA4UDsnPEo
	svI67l5/QxH7Lxkcu1yGGDoVthi+N972+6A9JJJT/ErrG4Tb6c5/9xthxepd8pC0Mfd2VO
	Esm5iOVpOzWayTAhY8jTzLlLyADC//k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784270656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YvQD+9gys5Bjr4sehQzMMfeCVCfBYB0aLci2jGBuO4U=;
	b=IvcQfNdWvZGzC77JPPVjhtazCoyu71vCjqshOr3giAx0R5twlJdd1EJA4Qy3Vw6kV/65Bw
	+jEZAC6k//Ywl0OUGPKGE3PGN8QWWXZLt6Qv645/5kQtM25cfdxDKfzk9CHcReXTN5U5vv
	9sJs4jN0PAHvRmGrs9H7yVwhlB0B28U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-418-Qv6s2ih4Niee3oujVrbRRQ-1; Fri,
 17 Jul 2026 02:44:10 -0400
X-MC-Unique: Qv6s2ih4Niee3oujVrbRRQ-1
X-Mimecast-MFC-AGG-ID: Qv6s2ih4Niee3oujVrbRRQ_1784270648
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C760D1955EAA;
	Fri, 17 Jul 2026 06:44:07 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.22.74.7])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B3D3B180036E;
	Fri, 17 Jul 2026 06:43:57 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: ljs@kernel.org,
	willy@infradead.org,
	Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>
Subject: [PATCH v2 1/2] mm: decrement MTHP_STAT_NR_ANON in free_zone_device_folio()
Date: Fri, 17 Jul 2026 00:44:59 -0600
Message-ID: <20260717064502.1980173-2-npache@redhat.com>
In-Reply-To: <20260717064502.1980173-1-npache@redhat.com>
References: <20260717064502.1980173-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: psIken89cqP28fleaJpQi9w3r-SHwp9VEeBHT-64VSo_1784270648
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1398320007
X-Stat-Signature: 97s8k46dyadd7wzmpik8zdfcsmzaux6b
X-HE-Tag: 1784270656-455198
X-HE-Meta: U2FsdGVkX18eqZ+FPn2EhyRQpI05DJG2hU3LcCbhIGmaaTSik7peYtkVTIFlONCgbvI/rckke/RwJPfOcwgsjBMsF8X5i4M1SA8bAGVxCObSfoicJSe+arhI8Wdm6TByC3eafNzAXJ7tW15oN4sKef/YDSbmwX7s0Py3ubbdZc8C9HK1uAihJaAUMIXZColJ2ukE/79U8InAHruqDo4HExQrak4TRc/YKI4virn/kmShggohRYRHVVS/Rs9LI8ZdHA9loCvyX0Hlv52/JVnPNo8GZFz97B09UJlMNu6GGzwYiQQLYTEYw5Pq4ZuNxB5gF4yxFAMLiCwdlONA9PI8FU6JhdDDkjS677pOD46xXFRV7nL57/+GuKrUFX5XKFX59sVfeYZ29X9ymeyVfZJgufDWYY+10UahklyV2vp2Exbpn7ZnN0fDKTbaunXJ+s4v/Ue2MMIJfh3ElZmR9Di+KX4yIXtha18uzN4tHTwngQ5fs5odrhArXy28cQ/P14chEpymYAEo9oEYkm1A0VKEPjgdk3hTed5yS1inigtM54BrvssH3BoXXMirb4cYfLpFl/Ff7orirC/unDjYCwYQpO2jxvSJQOCkUuSpQVZe08ejwEJkcebvvfsoZooCSpGS9UM9w4w3rF+eM+6Q8SEjxuRi7uqBPWJZHend/PbRUAEaYq/JcE9iIAX9nctbGyfXOEf5yKg/PNkqDlMrLY2XpnfIF1bjeh/DWpobm3KgifLv7ac+XhNpbdhe0NxZ8bUbRurMMTSF7g92Zf2tUBn8YlRWNn67zVODjRDo37rJfRNVbjjO7I7peWatVLOEtJOtWOTbDZhI7Z0Ldwgop28T6NZWQVvI1XNGzP4H/ZqK2b0xU1JxC40Nh+pdNmSV0tCOdB9fNQlHVPnDq9juHw00c5DXHW/VRRCU36hhmMF//ncqQCdoRh6WPXPxOm/ExOt5L1FjqtSSjNM0cx48J0X
 uh9GyxTy
 dtKVHEJtFR1wfLQPBZVXNs0712DeS4pryLNZN7pz96H/KI6N/ergs8tvQV9DLsfL6VUgAv/3rksGZDXei6Ylw0LVhXIH0WaHo1fGcFm+atiFwbXG10psPFqYJNvKhbDGI4BKriMDRH7QNtb+icCaxIHPw88ot6sYRg7UZIlLpZlfVqI//+T6dFYM0EKyx2DaAyKMTBC/QZKYVQvCUua6j+QZzsqWZ0+n252LyC1iz073iyFI+zwaDBQVhE/1Fjfc8QceBWzyGoUVab2LLzCA5V13g4EueuyqrvByYpj8cyJUOXsrNIob17vPVVMIZC4ai0cuqVnuScBTyzi4LzTBPhQzyuwaEzcl96nvZ2sdNSngREDdivygiG72bE9e8wMSbROeQlNIVpDjtEa48mOWSwcXQ29RdRpn7KFAJK/sVQNlowwfgtAmv/LCVt3sTL93jNZknCRj9MYc1LAYp3H+fyg5CiCCJmUcpNATFl9SRkeNs1UpTLN/inosRvl/jg/FMeOwl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a zone device folio is mapped as anonymous, folio_add_new_anon_rmap()
increments MTHP_STAT_NR_ANON. The corresponding decrement lives in
__free_pages_prepare() in page_alloc.c, but zone device folios are freed
via free_zone_device_folio() which never calls __free_pages_prepare().
This causes nr_anon to remain permanently elevated after zone device
folios are freed.

Add the missing mod_mthp_stat() decrement to free_zone_device_folio()
so that the counter is properly balanced.

Fixes: 5d65c8d758f2 ("mm: count the number of anonymous THPs per size")
Reviewed-by: Zi Yan <ziy@nvidia.com>
Co-developed-by: David Hildenbrand <david@kernel.org>
Signed-off-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/memremap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memremap.c b/mm/memremap.c
index 81766d822400..accba23aef28 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -425,6 +425,7 @@ void free_zone_device_folio(struct folio *folio)
 	mem_cgroup_uncharge(folio);
 
 	if (folio_test_anon(folio)) {
+		mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, -1);
 		for (i = 0; i < nr; i++)
 			__ClearPageAnonExclusive(folio_page(folio, i));
 	}
-- 
2.55.0


