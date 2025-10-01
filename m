Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FA12CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 04:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AE018E000B; Wed,  1 Oct 2025 00:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75F878E0002; Wed,  1 Oct 2025 00:35:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64DA18E000B; Wed,  1 Oct 2025 00:35:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FAA68E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 00:35:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3FB6BC19F
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:35:10 +0000 (UTC)
X-FDA: 83948280780.21.9D4E62E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3E8EE2000B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:35:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZYb0H0Nm;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759293309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0b5/BvT70k+vJiz3SordWv2jtVZP+YSZ2gcS6nnoogE=;
	b=vf+06ytG2k1t352nhbPvlNORvVe9rMWcstBPvWovqMATvkaxWkCiwMgF8EGP/jGH4hY0Sl
	JiI8mIePhX9KEL8tuHJDCQcdj1g3F+JFw9iGHULe20+JSO3feVupF72Etgw8NM18Frol9f
	CCVTy+bJ7aSXqKsDOgNXiyb6Wc2K5U4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759293309; a=rsa-sha256;
	cv=none;
	b=e96o/o7sLGfgx2FyZ8yGhqdDp3cCvJNb3P4VU7JwvXqfXtd3D81JsE8xHWO8kosGOPTDaL
	DF/qcrmbWFMJYe8fLcecI6qSta8/OSgbYtk2wQ3gG0CyQqqjYQT4P9WC/3hGc1UpIskd3H
	nJU6R4LnE3CGEhPV0ahRcoa8+GOOy+8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZYb0H0Nm;
	spf=pass (imf13.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759293308;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0b5/BvT70k+vJiz3SordWv2jtVZP+YSZ2gcS6nnoogE=;
	b=ZYb0H0NmCvJEdKqNh4gkN2v59jlWcKjHWbe5ofqLSaFc4c5TfsnxreCmuWIyO7r8L+XROR
	/uDSdNUXg8yVDgJSyVF/SIMyRkG6ptisvKv/XLMGJJAZj4FlzJetA4fqSbT2Pqg/LSvcA2
	HyKuvyImOIiWatPVQ+r4xZP3GJW+few=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-484-uugSkg2lPMqhEEdRgASAuw-1; Wed,
 01 Oct 2025 00:35:03 -0400
X-MC-Unique: uugSkg2lPMqhEEdRgASAuw-1
X-Mimecast-MFC-AGG-ID: uugSkg2lPMqhEEdRgASAuw_1759293302
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 01BC818004D4;
	Wed,  1 Oct 2025 04:35:01 +0000 (UTC)
Received: from MiWiFi-R3L-srv.redhat.com (unknown [10.72.116.46])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1753D1800576;
	Wed,  1 Oct 2025 04:34:56 +0000 (UTC)
From: Baoquan He <bhe@redhat.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	Baoquan He <bhe@redhat.com>
Subject: [PATCH 3/3] mm/swap: remove unneeded swap_active_head
Date: Wed,  1 Oct 2025 12:34:36 +0800
Message-ID: <20251001043436.41338-4-bhe@redhat.com>
In-Reply-To: <20251001043436.41338-1-bhe@redhat.com>
References: <20251001043436.41338-1-bhe@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: B_pfrkSHA9fdKVG35gnh_vAsQiWrW7XmKalirvJIR-I_1759293302
X-Mimecast-Originator: redhat.com
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3E8EE2000B
X-Stat-Signature: 4x7my6mstzj43ny6a8hoqwexetetjdn3
X-Rspam-User: 
X-HE-Tag: 1759293309-648131
X-HE-Meta: U2FsdGVkX1/X0cVCusuPZnxM5UZax1+LsZ+lIk+6MBUXpH0Hp5fcvKbsG7tyPLBXPAlL8yDUFWuoGcGCpjVq+JRHR1vD90Nd+7Gp5ZQhoARudP/zMzXOUECB+ZaONvGlDhpaUrGhcX/6s4HdzmOukpliEOiY6CLEXJXXFus9FdtsLHbqKx8QLNT33AoiD1YrzOjKTAtI/v7nqWIMI72CrUG8DFhMzqDgo6hw1neJwDaiQWDtKdOkMXJw/sC3l5WNd8OwPe56jAmVHFvYrI1M25j08uyVsI1Ps/rV/Z7ht8+FEsOX1maypgk/krdPLzAjypmR8RI10PGVJUAiYSIQKkWdbAd8daFzKTbl4a5XpXFbIyi3xfnh+G6SC5kCeV20pD3CEDzcaC4hq3S+2q7m6ZL1ETTlKaZAlTBPlGWmWzcPt4bJg47D4UADUma/Vmj0ENCl9b2E6VXQLoxsIddRZk0KU3g6m9sjdXITu6aG5aO+NL9jjhjBkD5ZA0P40Dc4RxmvzYP9WH5Q3SSrO/+pVA4NF5niQjfWsOCmMfTW7R2urET4Glqfb6dQgGi9TCDUPuqwDk5sBhaVQgnzcrcFN13wiINd4s+Dp/oxZ7CokH6c3An51nD4XfOhD/a5v9BT/RHQqF0M2LWEsiSzbC/mofHVhICskF1W+BaoPGqNmoUcU4NoYZFNE/0E8MKgTGR5bgvOkky48/AiFwcl6WdmI5ekk97xn4LZmwzR2jI9tdHJ+njaaBeARMOHQnczKk8YoJdkHdIXzmHVZ6w/yaCatilWj73RH2cgxM71arQaKzDftbMHodge/9UNRA6xFrEUTVcas0fqHsHoIxGwwtDs8v3hSGYtzVGYSKkhsoIvtjLX/nqegDp69eISJA87JMtOkRY+PDdHAY8dUw0JQJVR1AJ8TUUCN8Hcykk3N7INUwrXVo1JXsug5F4vUyRqTfgtkQf5u7Ywr0xwDGChGK2
 ApqbxdBN
 B7Hmx1KVlb8QNswiu+DLG79zb/B/MC8XKvxu3TACDapUoDPxP0WlK6wLke/rVtQOJM0USHin5g3kTeplZB1GbFPUkhDkk2chSKvhC+VVz3rvYXos=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no user of swap_active_head, remove it now.

Signed-off-by: Baoquan He <bhe@redhat.com>
---
 include/linux/swap.h |  1 -
 mm/swapfile.c        | 20 ++++----------------
 2 files changed, 4 insertions(+), 17 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 5b7a39b20f58..dfc0cc9fc166 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -296,7 +296,6 @@ struct swap_info_struct {
 	struct percpu_ref users;	/* indicate and keep swap device valid. */
 	unsigned long	flags;		/* SWP_USED etc: see above */
 	signed short	prio;		/* swap priority of this type */
-	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* extent of the swap_map */
 	unsigned char *swap_map;	/* vmalloc'ed array of usage counts */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 18b52cc20749..80b34dc86a95 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -85,17 +85,10 @@ static const char Bad_offset[] = "Bad swap offset entry ";
 static const char Unused_offset[] = "Unused swap offset entry ";
 
 /*
- * all active swap_info_structs
- * protected with swap_lock, and ordered by priority.
- */
-static PLIST_HEAD(swap_active_head);
-
-/*
- * all available (active, not full) swap_info_structs
- * protected with swap_avail_lock, ordered by priority.
- * This is used by folio_alloc_swap() instead of swap_active_head
- * because swap_active_head includes all swap_info_structs,
- * but folio_alloc_swap() doesn't need to look at full ones.
+ * All available (active, not full) swap_info_structs protected with
+ * swap_avail_lock, ordered by priority.
+ * This is used by folio_alloc_swap() because folio_alloc_swap()
+ * doesn't need to look at full ones.
  * This uses its own lock instead of swap_lock because when a
  * swap_info_struct changes between not-full/full, it needs to
  * add/remove itself to/from this list, but the swap_info_struct->lock
@@ -2539,7 +2532,6 @@ static void setup_swap_info(struct swap_info_struct *si, int prio,
 	 * the plist prio is negated because plist ordering is
 	 * low-to-high, while swap ordering is high-to-low
 	 */
-	si->list.prio = -si->prio;
 	si->avail_list.prio = -si->prio;
 	si->swap_map = swap_map;
 	si->cluster_info = cluster_info;
@@ -2553,8 +2545,6 @@ static void _enable_swap_info(struct swap_info_struct *si)
 
 	assert_spin_locked(&swap_lock);
 
-	plist_add(&si->list, &swap_active_head);
-
 	/* Add back to available list */
 	add_to_avail_list(si, true);
 }
@@ -2682,7 +2672,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	}
 	spin_lock(&p->lock);
 	del_from_avail_list(p, true);
-	plist_del(&p->list, &swap_active_head);
 	atomic_long_sub(p->pages, &nr_swap_pages);
 	total_swap_pages -= p->pages;
 	spin_unlock(&p->lock);
@@ -2958,7 +2947,6 @@ static struct swap_info_struct *alloc_swap_info(void)
 		 */
 	}
 	p->swap_extent_root = RB_ROOT;
-	plist_node_init(&p->list, 0);
 	plist_node_init(&p->avail_list, 0);
 	p->flags = SWP_USED;
 	spin_unlock(&swap_lock);
-- 
2.41.0


