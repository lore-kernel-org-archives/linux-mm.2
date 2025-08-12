Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9D7AC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 08:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C6378E0106; Tue, 12 Aug 2025 04:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 578558E00F5; Tue, 12 Aug 2025 04:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4659D8E0106; Tue, 12 Aug 2025 04:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3193E8E00F5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 04:31:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE8BE819FC
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:31:15 +0000 (UTC)
X-FDA: 83767435710.01.1848121
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9CBE11C000F
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 08:31:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ioBOVq4e;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf18.hostedemail.com: domain of BATV+01f4a5ca6254e61d0c65+8024+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+01f4a5ca6254e61d0c65+8024+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754987474; a=rsa-sha256;
	cv=none;
	b=c7LY+Xpok2IGRBoc7lvXCZGCZ4ehgRYHRJExOsihl/d+gqyyevHAFINXW0Io3JCogX24hm
	6inrrSfApjfmPX3O91rPtuFR/YFC/KTJpkFb5FGnF/W+ZhmwAcbTJMhT3dwPH2/AOhGTiY
	AcYDYhmGwRPeQbAk3AnppfOKpSag3W8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ioBOVq4e;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf18.hostedemail.com: domain of BATV+01f4a5ca6254e61d0c65+8024+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+01f4a5ca6254e61d0c65+8024+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754987474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=s7uIM6IQ2GnRJMINnamZt+nOZI6yL1Vh1Qs9yCS83nE=;
	b=YqD0lUMpLW2PFBxXp1+NInlfHWIfKLUxXWqPvzR55ciTxVgxSA2wuvM6nD7Jj7sTnnavpP
	MhCq99pploklQPi7ALAuMlbzcv98EQRxy+byrjY0QtIl9d/e4Yzs8URPB0IRJPELsvVuBS
	HmN9Z4cqny7185RJFw0wpjEjuVxsgpA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=s7uIM6IQ2GnRJMINnamZt+nOZI6yL1Vh1Qs9yCS83nE=; b=ioBOVq4en/GVng08rmZuW1h3lg
	RZxJG/RDqoA9T+fOm+5PJFmOO/RE8IswpvBt5dYYYxAPc3KWWl6EKPI1KFaq8VZgObrSTPDMlhkGt
	6vHxsGr3k6vUZTlfaX35ZuTL00P522XjVVZJA3+MwqD+ilxtspWlCSRXD08SL7/CnmdEBREGRMa4h
	/F9blN+B0Pvac8vqzlJ+LRHGfpX0j4BDY9mqnBEqu9lWPL/gtFpPkyNHhF9vRBXGg0PoOxvyKkd4M
	jc+K241ZeUHYf70IaSEojbBCeKsZOeH+bJjKAWt/hLFDl9Uz73/wPgeAD2tuXCjKgi5ZCnMxzse9c
	2FM0bPew==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ulkPU-0000000AFKh-1tta;
	Tue, 12 Aug 2025 08:31:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: vbabka@suse.cz,
	akpm@linux-foundation.org
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	harry.yoo@oracle.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mempool: rename struct mempool_s to struct mempool
Date: Tue, 12 Aug 2025 10:30:08 +0200
Message-ID: <20250812083105.371295-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: jzpktfbtz515redf71x9y4b8kbo9hwsx
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CBE11C000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1754987472-567902
X-HE-Meta: U2FsdGVkX1+FikVmmdzUjuNWpuva5s1qGjcZrk7n3TG/LGXgFRAMS9L9/yudTOOsrdS0u5CNe6O46wfJib/tRfOMlM7YQvojLDCWyWsqhABnOVKXHn7UKBLRsbJ8QA0Q3ynwdhwhhpriH6bLNI8J7HUio4HLbB5huQNE1Ee2A9fW+8rqvWQhKm5kYw5JDj4WsGjzup6q17kzjAfipksR46waGhl7xVmHP2YhOmEcBro/VYWqKR7FMm63ecYH1O6ykHjfxhw6lmipD6/k92j1l0MnwQDYqmW+1NGkoC8cZK1q8a37DAY08iQ74gtUtKsCF8WV/k8q/saoQJxuHHh++ahdHUktbmqKksyVOaeDqOQivjJ5K1W3u7DJux+bP+U5ZZlgeVYNjKcUQRGbdqgRnIB23/RuXqeFaoIk5eI79GZGRLvep3R9nV2bAtE3lv+uTHHTOETC/awUjf/Q08QDosxY+jx9PUhNbs7pxhkoDH/XxtHW27xaL/4iIX6/vMKcRmiGCfY+4/EB3FAt4X//aKOUdBD/+T8a/hBtMofOR9LlMn95vcMpFy8hb8wg6srZ+V9qbcS+/8ixN5MvUWHiTu0eqLpRlOBT9RaZ7wCatxBc8jOtd2EblNcqHtlsCjhBKU2TCPEpW1900cPYGA+qjY2L0/mPhH/soI+PtJm6zGhGNXO/tdzAiOo6TqEIFYIJT126PVs3Wx3QVSQj0mLZfRRbKThAUqeVRYRKZEu4gFIgy3Oyw+lpzKADcMAYuSp5t6VfeceJlASdX/yJVxxbeSn2D5GKw1co9wnswymYWVF64kFr/f0qTPpb/dI3BaC/Y2ODdUOxOL8m8pQI42dtdq4u4y9wS47JI+HUlRKd8tdvVW7VY+CU7U2u5v84bO4cwKsHvf3qugRFtjIjndgh/287AhzT5WqJG/7oUrH2MB3fcq2RK85w0PUuEkkjxNcS9ElEBUxnSiQevqTuZRd
 V4lrmfmd
 JF7IEwbCjQmcM4eVmAZyslZydJZIeS2NHnArLf6zFM5j6XWgPs8+nV84Qq+NDamAOGklQncOMlZzpihMJbUtzXDL3D1qUyzX6TCijGtpsRo2FLE2hqXKH3ZrweibQ4hvEHRsEsw91hzwY6k2jP2M6D90FPXF1aTesObnfWthNmRtiphK6a2D5Y3gxcZaMX8fkr/hYVR8zHd6oGttvv7XFRglJJfFhYg8LwkbjmKJVuyEPjtj72PdNX+H/VA7N7pLYUKMroq3ImBSTdeWbeUeYhe8PyTBtSD8E1qWkRX6J5g7GePb7PTmPACtK3Zs3DtV3c5l9pCcJzmCMStuo4KpovgPECX6GI73mKgW70XFeoyMJeYWeKjupRQjbs9Li4ngCq0w4vcIqmSnHT6ipm2U58vKV5g4YaULsvBHqTXi9wGGlz7PKthcSItnyeVHR3hrB3CB6XilDFrgYGcvljgccigkYR1aHsIXMFArgGClKH0bBXt/b8IJnThuDdPMiwJCpSo9kUNFJtA9rDFsqJpIngpjNxEFJJ1d+x8ZoSnAWSTIEukC+Js+EUb71vZxjnQgQGowKxFvy30LnhGUkPG0YOjqFqOUfmxzZcawP6irr2YvjD6iexsJDIHMcfU8ncl2JIeQI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Drop the pointless _s prefix and align to the usual struct naming to
prepare for actually using the struct instead of the typedef so that
random headers don't need to include mempool.h for just having a
pointer to the mempool.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/blkdev.h  | 2 +-
 include/linux/mempool.h | 2 +-
 include/linux/netfs.h   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 95886b404b16..c3f3ec5bb864 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -199,7 +199,7 @@ struct gendisk {
 	unsigned int		zone_wplugs_hash_bits;
 	atomic_t		nr_zone_wplugs;
 	spinlock_t		zone_wplugs_lock;
-	struct mempool_s	*zone_wplugs_pool;
+	struct mempool		*zone_wplugs_pool;
 	struct hlist_head	*zone_wplugs_hash;
 	struct workqueue_struct *zone_wplugs_wq;
 #endif /* CONFIG_BLK_DEV_ZONED */
diff --git a/include/linux/mempool.h b/include/linux/mempool.h
index 7b151441341b..34941a4b9026 100644
--- a/include/linux/mempool.h
+++ b/include/linux/mempool.h
@@ -15,7 +15,7 @@ struct kmem_cache;
 typedef void * (mempool_alloc_t)(gfp_t gfp_mask, void *pool_data);
 typedef void (mempool_free_t)(void *element, void *pool_data);
 
-typedef struct mempool_s {
+typedef struct mempool {
 	spinlock_t lock;
 	int min_nr;		/* nr of elements at *elements */
 	int curr_nr;		/* Current nr of elements at *elements */
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 185bd8196503..270ed0822efa 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -21,7 +21,7 @@
 #include <linux/rolling_buffer.h>
 
 enum netfs_sreq_ref_trace;
-typedef struct mempool_s mempool_t;
+typedef struct mempool mempool_t;
 struct folio_queue;
 
 /**
-- 
2.47.2


