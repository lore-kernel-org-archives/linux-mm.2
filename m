Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E61E0C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:05:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 098606B00C3; Tue, 30 Jun 2026 11:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3E5E6B00C6; Tue, 30 Jun 2026 11:05:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2BAC6B00C8; Tue, 30 Jun 2026 11:05:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCB386B00C3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:05:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BB95140407
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:05:09 +0000 (UTC)
X-FDA: 84936901938.03.7B76BA4
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 92640C0002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:05:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dZAcTlU9;
	spf=pass (imf22.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782831907;
	b=PvxpBfrKRm56FS9wnp19o9rPaC2k2x9SyKqfW2XZF6jQZL844+p0Pw6Jj7UCsaSEBBcyz9
	m/Zb0CWUwJdtdcjpzzAZVDJqdylcwoGSvha1+ike+hLDEBH+GSN4jWz+w9sZQhr7Udg46Q
	xRWQLMy+3XcaK693YjemMBQI7KOHGnc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782831907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HJOlaOlPql4L/ybBsn3qlq0tdJ5CIZPrHo11scoNzQ=;
	b=zBogWaZLgSutdiFNL89Fa1NXEPYGANAT9Mtsyc4XJecVJnuMXY7S5DzDGwvd46q2ar4Kzp
	+Yf/bbDf/YsEJlPcNw6yNLSzEe+WF+toh0x4b6V/rncQieT8MRsmf9n/Fq9hKJSdE+2pi/
	5lVw6jWF+ERWQd92ab4Sw6uG3gRcCcE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dZAcTlU9;
	spf=pass (imf22.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2c9d87b1f9eso17337175ad.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782831906; x=1783436706; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4HJOlaOlPql4L/ybBsn3qlq0tdJ5CIZPrHo11scoNzQ=;
        b=dZAcTlU9L7kDnKRKtTP0tmJw9anRrJaizG+bbl7/5jGIkMo7ZTnsxs7qJN9cheRRhY
         qxMr7mNkKWf3YsvQeIFidc3Cdz4c980Ok2Fdi6hdG01JrhPOgHC/3dFFDdS6DHH3wVql
         TKqzeEaIl5VuI9E1CetlFRdAARj1LZzJJEhaRpTpr7lCfjr6+hYxwSULlHYh14bRRcyb
         Rv6zjVdYJoA77b9Zo89lGznUgxUTcXyI1L8C/oxutEhATNF1kxLnMDbmyOFtYEolKA42
         1loc0j6XXzT5nVGimHXVrf73Y+om4Spu2btRZyLh7TqrbGE6j+WXWm0EkqohMeetlOTF
         srhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782831906; x=1783436706;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4HJOlaOlPql4L/ybBsn3qlq0tdJ5CIZPrHo11scoNzQ=;
        b=ZWRF14iP1qhTCH9QIaBJ7nVSPhxGQRQk51aPNgYoVKjgS86pVytqcL+zWqV5XBB5u/
         SFkMJU3TCY7m8Tt3klmJv9LoFQEkH3ZHbNs5TIvhCg7EqTjmFSA3HMbj62eMThGVLyRU
         01Tg0jymG4SByiCLgEJB71yOjsCrlFANIhxYPr7+0lqJbuq1GMlEJol2Kax3p5xR+Axs
         Yad5wqaC+ylDqRToQs80KPNcDsYi1t1cNQ1ihD4Mvg6fnx9f3j4ZFjPsium0KR0bDTRO
         6YAIEDjjucK1pL7CxEJQhirLt6IhYc6uJCBrY7yNUKLvCVWqCNe6IdY0PDqCYEknkXu3
         OtrQ==
X-Gm-Message-State: AOJu0YyvCu5c3n6Dkd8mQlSCRCNtq3nxZZurIEqcmCqLv388RVTLy0Om
	VVRCA996Dz2Q3My5XmkZVICU3dODCMZs1fJfUE7igPwMlIWRSNGITQMB
X-Gm-Gg: AfdE7cnd3Iap3n5KbwxxW2+0mVwtwyXhJxQyXf2v/zoAaMOcPqDigqPFFDBMB/D4RTR
	WOI9iINTl4qlmP+Fhm+CEkOxm+k6NaNP8E5aA+kzWN14xTq7HQcJfZx9M44XNvEHroQkRkpsTIS
	pgvJj1si7Xju9zLCcBtwbXuBFBTdH6I5KAlhuLNkbkXB0lfnipZYpth5OGOI+rpz2dXoX7vkaP8
	mga1JroHD+jq3loLFOAcBkHpKHuJNh1+i3EeW4R88LN8ibolSotzviT8VKvER4ugc2CVV+Ub+nP
	AdWKMu3AQUTov1l+fAwCn3PfckMALghUAsqUp0pjKvMVlriLHVOS1xdJ65O2xnGC69OzjCaxodz
	/RpxYfArjNUVf+S25hb3SjamDAOkMZ+KAMeeN0XhtFLA/2Phl1ltGol91mwIlIe1HdfCp4B0tcK
	l3qRi2xsM=
X-Received: by 2002:a17:902:fd8d:b0:2c2:7baf:139f with SMTP id d9443c01a7336-2ca2ed345e8mr28805105ad.30.1782831906340;
        Tue, 30 Jun 2026 08:05:06 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37a70bc0sm16250465ad.10.2026.06.30.08.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:05:05 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 8/8] mm/hugetlb: remove unnecessary empty range check in hugetlb_bootmem_set_nodes()
Date: Wed,  1 Jul 2026 00:04:13 +0900
Message-ID: <20260630150413.1718632-9-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260630150413.1718632-1-ekffu200098@gmail.com>
References: <20260630150413.1718632-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nxoij7or3zf4pzc6zs3y61eais3nn7my
X-Rspam-User: 
X-Rspamd-Queue-Id: 92640C0002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782831907-114130
X-HE-Meta: U2FsdGVkX1/SxhoHrGSy4Jq6AFDN1OjqedJlP1YlhvDcGdyC9Xx7QJ1fopMWg+XS6AXwQIvNTLWDL8Z6E+tNi1zJBuXGZb9pFFUgIFq+V5vK3/hCZ1qEk4A+ikqhSF+CULqr+63xQZOLg0/dZslR3Bi2IvwNusOLm/PWMssqbEUNFQRfo+8cbda26MHTHru8/EbmVbxc7DPhOL4XXChPz0yCIRXmRD+ZOpvKEDTM2YUcGR+o1fiyf+shCxwLdMRyYjFeCNP21WbHIelmJcvioDMvv4PGirpA10NP+GIaNzMRjlq4PlhmlIBhul/gI3aCBa4i7yKPHbhjDZmUBz0kS8KJeikkEDxS6g/RkXrWyxbQhkfgVG7dwIMrwAeYtrsbZ2LPuGm8FLwGcFFrdgaKU9A/XckMZ4uVr5Nnj3KT1+kh6t0sGXhXIlNIqnreQc1F34tL+gVhdXrH20RlTdQ6O/gqr7jCsel7NSRt4bw+E+tMV0CWq+ltMTqeukhJVquhigbDu9+HNMlo0erkP4faHX3tqVPGkiSYCSo+xqjRAlxonwFrZFuD/0HORnFsY0wB0gd2Tg2DgI4YD00xWcrrhr4Rq2e5eS34IoiSw4if1ZDNMWGPRir/kuaeuYt13HCHj0xZ0KYceBpeC6I17Zzq8E9y5TOEaXpMejWfPnvXHCco1zD4C/qXkN5TOsa9QrYj56rtlxaIMOdU8c2s/9Jn2QhhOoNtttIEouKijJf3dF6fFKX3tgbNmulK6CkS3xm6LeisjrZIj4WJ+2wg+bmZpjloyDbixNQPky4GBTYGZrbWOMGhyG/z0GFyw0vhEUz2cMcfXHvnxkcqEgkAttdI3MIS8p1tbKej9ylZ8tyJgSdy889Kq0waByLiy6kdhuah4N/KVh5cACCZst1G3VJSM3+0pkX2z7E6oi/6G/9fRWVkyEj83TjyLGn7iOyaP0KbriaDstgj0Nx0DGQYUwH
 hZfg5fZd
 /bwUmPSjynv5wYBE9KzrgQJKtHz/mgDooiwpBiHfbEqtPKf1JEfIDkmjSNxwon5x90GqujKQV1Fgpca6G4tqdHQBTW8160vkBPg1AADdeNFbEjmVXnH8HFEygJlMrE201Jil2yw1zxrS9BdT1JRyqy+UNwi3tLt7Cnpx4GOfDFgcVkMoU2tqz7slL57pT5DYbK28VDvAFWwCvOybsIGur/bZGMpRbv5fgeEEHcIhmBV0B7vRRvgo0jxctgNJa1B6+aOpnW1vljwbnfekIoCxKh7OM7dr3NJx+HoSR3yPhhJD9UD7qr/NrIXtLPph+BjqtBuTT1XZ2T8w61RtIzQBI3zS3fBBzWfkK7JDpCP9TDl+5YZ82puKDhQTS2iHq9SWEq7eAOc+mnWKdmkzVqk6Y7Wg3PufkNxt8jgfF0wF08/bWWgy6jPT5n51pjZpZi5HF8p+gGPCbdG6wnj4AKw9Z/aFeluzii3hhZId3F3/qJgeZTqQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_bootmem_set_nodes() iterates the memory ranges with
for_each_mem_pfn_range() and calls node_set(nid, hugetlb_bootmem_nodes)
only when end_pfn > start_pfn. for_each_mem_pfn_range() never returns an
empty range, so start_pfn < end_pfn always.

Therefore the check is unnecessary, so remove it. start_pfn and end_pfn
are no longer used, so remove the local variables.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..4f7020962486 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4444,15 +4444,12 @@ hugetlb_early_param("default_hugepagesz", default_hugepagesz_setup);
 void __init hugetlb_bootmem_set_nodes(void)
 {
 	int i, nid;
-	unsigned long start_pfn, end_pfn;
 
 	if (!nodes_empty(hugetlb_bootmem_nodes))
 		return;
 
-	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
-		if (end_pfn > start_pfn)
-			node_set(nid, hugetlb_bootmem_nodes);
-	}
+	for_each_mem_pfn_range(i, MAX_NUMNODES, NULL, NULL, &nid)
+		node_set(nid, hugetlb_bootmem_nodes);
 }
 
 void __init hugetlb_bootmem_alloc(void)
-- 
2.43.0


