Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69FFECAC5B0
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 22:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90DA08E0003; Thu, 25 Sep 2025 18:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E5788E0001; Thu, 25 Sep 2025 18:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 822818E0003; Thu, 25 Sep 2025 18:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6C06B8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:11:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 06819594A7
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 22:11:38 +0000 (UTC)
X-FDA: 83929170318.23.AB81E07
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf05.hostedemail.com (Postfix) with ESMTP id 60B9B100009
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 22:11:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LDlINN8O;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758838297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cV19K2kHwbzsptwnWHvhPs0HRaJ8ZbKRyVa4qDbsSX8=;
	b=evMVsFDMTZA5XmQn4W06T1jQWJmCcxAA7xPoJyxMKW9qwW52e623oZqrIKjxLhPaO+4RU1
	u94Efzbc/Wzf80NHlPj6CUUdj8TUWxBUnJDBO4AZX5cYboTzBAT3dGGsmAeNg6a86vf+Ts
	g4f0TkdvQM9kf/Rtxgbp7LcmhoImxmA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LDlINN8O;
	spf=pass (imf05.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758838297; a=rsa-sha256;
	cv=none;
	b=Nzdm7xnB/JZpnuVep5BNlu3W1FY52+kE6sMX6CeZElewTCfbZDuEQx5P9/xkpN6Q2wlrEo
	tvKrNkbW5hBxawYHc4A9YIj98W3FS4KhOGCBz6lMt8ppiJ4a5Ngq74YAaCk5MoK14TUeTw
	GLBI5n3DPjQRJQgemwdNqIXWzLOs8Yc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:
	In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=cV19K2kHwbzsptwnWHvhPs0HRaJ8ZbKRyVa4qDbsSX8=; b=LDlINN8O1LAKs2p5yHxLeWpBOw
	1/sCr+l5elgqI6Gv4YhA2Q05sQWwyTH3hXXFtaocpJjuPd99GX9HZdwZ6zi634uAZ/7Db0xPDpIdW
	jdKHhbcSuKjMOAf1HnSDqANuFp3MpZsVtsPiEdit3k7viRy/62ZmD2YYsr9cr6eqJBzFXewZA4ysr
	0d3kYU3u7rwwzI6NoZH4cqRRkRRwwbjcoftoaLuHWiioh51XJ5CAs47S/4/ru8oqX1ks6fGDWzCjS
	8Fb2TakL10qWB/IpR7rJFhW4eOMbe8sTNLL2jgxWZtqhNlo/CS2/S/L2yQXr5JdQvLF5fwc7SWO0v
	605RQA7w==;
Received: from [2601:18c:8180:83cc:5a47:caff:fe78:8708] (helo=fangorn)
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1v1uBA-000000008PK-1RQG;
	Thu, 25 Sep 2025 18:11:08 -0400
Date: Thu, 25 Sep 2025 18:11:06 -0400
From: Rik van Riel <riel@surriel.com>
To: Frank van der Linden <fvdl@google.com>
Cc: akpm@linux-foundation.org, muchun.song@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, hannes@cmpxchg.org, david@redhat.com,
 roman.gushchin@linux.dev, kernel-team@meta.com
Subject: [RFC PATCH 13/12] mm,cma: add compaction cma balance helper for
 direct reclaim
Message-ID: <20250925181106.3924a90c@fangorn>
In-Reply-To: <20250915195153.462039-1-fvdl@google.com>
References: <20250915195153.462039-1-fvdl@google.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: agsipb4qr3nyo5ry9uuzn3hinkpwbth6
X-Rspam-User: 
X-Rspamd-Queue-Id: 60B9B100009
X-Rspamd-Server: rspam04
X-HE-Tag: 1758838297-587349
X-HE-Meta: U2FsdGVkX19PC4Zd8yFsTZRreMcbTn/S9mUIrtQzmvKa/DwCPV8A/n9wyPJgV/7RrDb5X2DSVYMrTepr9lTm7RP5wMjdLxEsWRh3MXMrfVh0rD9ENUAEl+UqJZ2hB+6qDRtC+ixBSHuwIKzWO8bvAJDTep2NPjF9B1CH7YFw/SsQvB/Fua8aD5MaFGILizh1JHqiWpqcIfSRgs4ZknKSfTtLSDm20IKQFiomagqO+Oq98Sa7O6xXm6GNNT9sxhhhyRx86i2W1htjiPS7Eb8yB4HBX9I5zs7/hftfxn7/5Wxufzvzbhp0zJ4B0pXi52bdXEFj5mDlt/6CJWblwLjEZiA/E+LAXPNb19GRKs80yIZsS7iyaiSVAT7GmECcmpeWfw++ewgU3QmIxBsNMApaEVuJJxxX8/Peq3OatSWdNM90L2nk2CoEe2skMIyHttApPlgg0ctxzDrqOf4va2KF/A00CzBnuVohF17PMYZecwiiAvRkCFhLZTgY6pLdpMHp/hsdr7qXSz96X1N8Q1VH+aN1du29mWI0OSEKTD96WTubG4tFbPHCOhn0r/aCm5UM4tLr7ZB9ForEg+jSJO2w9M1ryXYTJOYEIlnOvLsEjfqNcW63QarkXHSt29qSHpo9TLg7Sj9Z1jWb8552L5FzAgNmgIDTBZdb++9Jd9TY4Nwsd6iqEveQTL4EJOte56raZUcpCXnoKD0L3bC9uInO4TAvlLTR79u3lXyQs8Uh6LS2aKgL955WQZ8oq49RgGvDNhvFZCbbn17xlKdd0rLCqiLvxZWI62lv39nM2ei9rdwjgUn2LKmlyvd1ehRSJnwABsAcpeW83ZK8dvE2CqNhTqcPU0UVfnWcimDVHrEu1K8sVxJ9D/cYOTYVNpVzeic+a+zk3Lv4gfPwdFaDy0WRg62QEGiyFYUTORodnHRhvBY13Y6LRoEgLBYL3BqhyVi44c+gOa/vV7KYPgTXUMx
 8gx0477t
 G7BbFEfQg0CNx4QfFpgAe762cOAZwYDZmLrwh1zFah2VyabJtu/srQCq5UwJjTa/Q6uDyNZDAcyAmi1W1RgEniyBtrSy5gGEcX6fT2xeGVyxlPv7NcWeeT4IHGhz9Zp/cYXjoQXVUY7R+cBHmCYjImyqxld+pGbCr1mogecQ0zpXIPRIUE+V2eP6NnG+uZNOD0my0Xt33aVEX7E5MDEynRSCMSjLKmKnf44A4h8xpGmqMFZ4pIyq80Uc4kKjaN8D7LwfPzbbmZTi8up9l1filNLls4tS5k0p0zpVQ+Uj2AMdgEZXp8WXZZmI1SovGa6uDliZNHGedCrtYABg+U+tjja3OluK1zYjJANVyNipuDbdb3+7Z5iheG+wFjI2AgjhqJ0MOsBaRh/3Jw9Lzx6ZIFZgBt2fggqAbUK3y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 19:51:41 +0000
Frank van der Linden <fvdl@google.com> wrote:

> This is an RFC on a solution to the long standing problem of OOMs
> occuring when the kernel runs out of space for unmovable allocations
> in the face of large amounts of CMA.

In order to make the CMA balancing code useful without hugetlb involvement,
eg. when simply allocating a !__GFP_MOVABLE allocation, I added two
patches to invoke CMA balancing from the page reclaim code when needed.

With these changes, we might no longer need to call the CMA balancing
code from the hugetlb free path any more, and could potentially
simplify some things in that area.

---8<---
=46rom 99991606760fdf8399255d7fc1f21b58069a4afe Mon Sep 17 00:00:00 2001
From: Rik van Riel <riel@meta.com>
Date: Tue, 23 Sep 2025 10:01:42 -0700
Subject: [PATCH 2/3] mm,cma: add compaction cma balance helper for direct r=
eclaim

Add a cma balance helper for the direct reclaim code, which does not
balance CMA free memory all the way, but only a limited number of
pages.

Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/compaction.c | 20 ++++++++++++++++++--
 mm/internal.h   |  7 +++++++
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 3200119b8baf..90478c29db60 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2541,7 +2541,7 @@ isolate_free_cma_pages(struct compact_control *cc)
 	cc->free_pfn =3D next_pfn;
 }
=20
-static void balance_zone_cma(struct zone *zone, struct cma *cma)
+static void balance_zone_cma(struct zone *zone, struct cma *cma, int targe=
t)
 {
 	struct compact_control cc =3D {
 		.zone =3D zone,
@@ -2613,6 +2613,13 @@ static void balance_zone_cma(struct zone *zone, stru=
ct cma *cma)
 		nr_pages =3D min(nr_pages, cma_get_available(cma));
 	nr_pages =3D min(allocated_noncma, nr_pages);
=20
+	/*
+	 * When invoked from page reclaim, use the provided target rather
+	 * than the calculated one.
+	 */
+	if (target)
+		nr_pages =3D target;
+
 	for (order =3D 0; order < NR_PAGE_ORDERS; order++)
 		INIT_LIST_HEAD(&cc.freepages[order]);
 	INIT_LIST_HEAD(&cc.migratepages);
@@ -2674,10 +2681,19 @@ void balance_node_cma(int nid, struct cma *cma)
 		if (!populated_zone(zone))
 			continue;
=20
-		balance_zone_cma(zone, cma);
+		balance_zone_cma(zone, cma, 0);
 	}
 }
=20
+void balance_cma_zonelist(struct zonelist *zonelist, int nr_pages)
+{
+	struct zoneref *z;
+	struct zone *zone;
+
+	for_each_zone_zonelist(zone, z, zonelist, MAX_NR_ZONES - 1)
+		balance_zone_cma(zone, NULL, nr_pages);
+}
+
 #endif /* CONFIG_CMA */
=20
 static enum compact_result
diff --git a/mm/internal.h b/mm/internal.h
index 7dcaf7214683..5340b94683bf 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -942,6 +942,7 @@ struct cma;
 void *cma_reserve_early(struct cma *cma, unsigned long size);
 void init_cma_pageblock(struct page *page);
 void balance_node_cma(int nid, struct cma *cma);
+void balance_cma_zonelist(struct zonelist *zonelist, int nr_pages);
 #else
 static inline void *cma_reserve_early(struct cma *cma, unsigned long size)
 {
@@ -950,6 +951,12 @@ static inline void *cma_reserve_early(struct cma *cma,=
 unsigned long size)
 static inline void init_cma_pageblock(struct page *page)
 {
 }
+static inline void balance_node_cma(int nid, struct cma *cma)
+{
+}
+static inline void balance_cma_zonelist(struct zonelist *zonelist, int nr_=
pages)
+{
+}
 #endif
=20
=20
--=20
2.47.3


