Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8130FCB61D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72B116B0098; Fri,  6 Mar 2026 11:06:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69B946B00A1; Fri,  6 Mar 2026 11:06:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5566A6B0092; Fri,  6 Mar 2026 11:06:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9D56B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:06:28 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F19BABA2AC
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:06:27 +0000 (UTC)
X-FDA: 84516115614.23.CA77577
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf01.hostedemail.com (Postfix) with ESMTP id 45E5440017
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:06:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=kIsu87qC;
	spf=pass (imf01.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772813186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i9UEkKMHpo5tNbaHzJ6bf5dC7adclkzJ3ytPit9GXIQ=;
	b=8MM+nk3KLXlao4KzCuqCYHtT8/QHVA/bwxEjYJPFNFqEw5NxVMAZnSI3TL0yfRyjTpAMBu
	Y7a6yPz4EmeV4xBlbDMVEj79da32WP3NgILpgvg27Xv9ZQqbRUMHb59UKWOfka6BK8YVak
	KUvLw8rp/0HqL7kCS+BMBnZ1/PPhrT0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=kIsu87qC;
	spf=pass (imf01.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772813186; a=rsa-sha256;
	cv=none;
	b=0/sWB5651ZkopjuBo4m8SG45zu92KngQwVKQMQ9BbPhtijEVRQQ/xXuoiRXODjNG5Lpijw
	su06iGxYU0tgvWQ4rjErNEYXki8j9C39/xIoVbQdF1c08Y4pbT01SPxmcvl9NSMneW+naP
	nTe6Z1/ZdQ7c4msPFQHZjDpbBmnvkXI=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 6D4DEB343A;
	Fri, 06 Mar 2026 16:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1772813184;
	bh=i9UEkKMHpo5tNbaHzJ6bf5dC7adclkzJ3ytPit9GXIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kIsu87qCkpQM60NfUwX2uTA3cZQ1SRKOjnU7PGWuT3Y76LtaFmxUaE7TF2LuaKa5D
	 KbUgRhD1q2TZaVN+7l9IoZ/e+/Sr6qnyw3f3LksEdr7coxXDaIgC9R/8tAlzG+dRZa
	 s7jxzba4KWLI5P8orJ4WEY5O4kaS/BUNk8YKyCSY=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/8] mm: use zone lock guard in reserve_highatomic_pageblock()
Date: Fri,  6 Mar 2026 16:05:35 +0000
Message-ID: <cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772811429.git.d@ilvokhin.com>
References: <cover.1772811429.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 45E5440017
X-Rspamd-Server: rspam07
X-Stat-Signature: 93fy4k3w4qbfeo15q6en58qqtu68i1fb
X-Rspam-User: 
X-HE-Tag: 1772813186-876352
X-HE-Meta: U2FsdGVkX183QkE/0eZsTgBZj0Bu3DaNPwRLi/Xe44tyhbBuc8w/TnZ1qEeKoQVdB7kpoerpkJG0xwbk5/fzQa4unMZtm8Aw7B8ApnxRMxVsLKQ64a9D6oTTso1WA2+2B+cXcBgNDAX+yDCIVYfQynk7XxZeVGUhjzspWRTej6xX4JAQghGmwHCR4CbgfP3PNVP6oWMOyoJ20Ez8JV/YQzPlxxiv5aSDqsTvfzWLEA+OXo53IWJV1S3pVlTUCiZNXB41Dxg6MFDiSV6l68WrNzrCWea1wxi8emclQihYsv5psoQ+EiN8sB3ggGQDhxCGIlXNeyb0iAQ49xan7U3YfwaEROqtgMQbefGyfpeH0+tU0/VdMUU0pMY5KQKIEu9VznpxT/ITVuu5eRQGJGHzFyk7+1fqfQ0RaZFGzEaJKAybRfemcLqnNNwpMpS/DJQYJr2TtBEZfoEq8Fd9vVHOZAumsBQNr+lyq4Z27yqHYRtUj1IZXoAoJtzO19ETS4/D3DeTcLg1cT9AHTDvK7W8ZtZ13xuKrBS8QEUDMTZSH0cy5d1HXm0x0A65D1Ca8I9+txUCrH5IP0Bx5d30DADrNG/mCoEZkDNhQpZev/cEuF7SlcaMoGBYsb6y+a2aXo+6vJMQ9PmxqXXCIbPYtYuN+TIgvsBm3itViaDmkVHPIQR7GI4H/1PTnNcVA/yGlcYmA83Js0ay+Ivx85FJsifculhJ6+ipFI5wHVUB/AUHrIGMw3Qx9akmIZpBIY0Tb5tbGriJz9KQU7TFBoVMKbfmO/gAeqSB+fpEcQntY/kazECUTUJv2PVQjEJQLlt41ixnyv73+vmvw/P1ZKAeGWo2tfyuGJZ/QGNL1c1sqkvT3Hms8bHr5gFA5TI7MKKGtKvNpkilN94hG6McaY92t2R/cLC4U4p6fjdbf5epA00Q/LGs1sRgayj38I84AkYHTP+wS7k3B1v8N5ubwyDhnyj
 Rkia6ccL
 MbedaN9HHfe2c4FHhD5EX9GfPnsFzn+kJkhsUgheuK+xoVUyKFKrxX3AMgQ7LhsgM4c4zFQJHe8EuNfJzj0KzZAx8wG+i8Kn4hZgRcRasP6bV+ye1gw0dB+V/iOT6CrlG702F/ZXEe0te91SZads5MMC9oa9q83iuaFxfgWRSqn49y4VCl9JAt5AFqIQ+Ddp9kSAnUS3T+fbAItGZmTI2E6gTfjOgzxpVa7PY2pwysl4YZ4+gtm3qOJ3VIi0BEg5SQwvXmzwpNIlBa28dOnqogwmlHXbqoKFiDoXh1KmerE0Z6ElwZqo16RFb0k0kh7oj+TZzvPApStZ3PSF0TDyoc3sZx8B5NuZzMuQ1g1+5t77qsay5tZdGp4Y5HB+bDMW+aF6h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the newly introduced zone_lock_irqsave lock guard in
reserve_highatomic_pageblock() to replace the explicit lock/unlock and
goto out_unlock pattern with automatic scope-based cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 include/linux/mmzone_lock.h |  9 +++++++++
 mm/page_alloc.c             | 13 +++++--------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/linux/mmzone_lock.h b/include/linux/mmzone_lock.h
index 6bd8b026029f..fe399a4505ba 100644
--- a/include/linux/mmzone_lock.h
+++ b/include/linux/mmzone_lock.h
@@ -97,4 +97,13 @@ static inline void zone_unlock_irq(struct zone *zone)
 	spin_unlock_irq(&zone->_lock);
 }
 
+DEFINE_LOCK_GUARD_1(zone_lock_irqsave, struct zone,
+		zone_lock_irqsave(_T->lock, _T->flags),
+		zone_unlock_irqrestore(_T->lock, _T->flags),
+		unsigned long flags)
+DECLARE_LOCK_GUARD_1_ATTRS(zone_lock_irqsave,
+		__acquires(_T), __releases(*(struct zone **)_T))
+#define class_zone_lock_irqsave_constructor(_T) \
+	WITH_LOCK_GUARD_1_ATTRS(zone_lock_irqsave, _T)
+
 #endif /* _LINUX_MMZONE_LOCK_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 75ee81445640..260fb003822a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3407,7 +3407,7 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 					 struct zone *zone)
 {
 	int mt;
-	unsigned long max_managed, flags;
+	unsigned long max_managed;
 
 	/*
 	 * The number reserved as: minimum is 1 pageblock, maximum is
@@ -3421,29 +3421,26 @@ static void reserve_highatomic_pageblock(struct page *page, int order,
 	if (zone->nr_reserved_highatomic >= max_managed)
 		return;
 
-	zone_lock_irqsave(zone, flags);
+	guard(zone_lock_irqsave)(zone);
 
 	/* Recheck the nr_reserved_highatomic limit under the lock */
 	if (zone->nr_reserved_highatomic >= max_managed)
-		goto out_unlock;
+		return;
 
 	/* Yoink! */
 	mt = get_pageblock_migratetype(page);
 	/* Only reserve normal pageblocks (i.e., they can merge with others) */
 	if (!migratetype_is_mergeable(mt))
-		goto out_unlock;
+		return;
 
 	if (order < pageblock_order) {
 		if (move_freepages_block(zone, page, mt, MIGRATE_HIGHATOMIC) == -1)
-			goto out_unlock;
+			return;
 		zone->nr_reserved_highatomic += pageblock_nr_pages;
 	} else {
 		change_pageblock_range(page, order, MIGRATE_HIGHATOMIC);
 		zone->nr_reserved_highatomic += 1 << order;
 	}
-
-out_unlock:
-	zone_unlock_irqrestore(zone, flags);
 }
 
 /*
-- 
2.47.3


