Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D913C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 16:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D0D6B0760; Tue, 18 Aug 2026 12:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644A06B0762; Tue, 18 Aug 2026 12:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 582246B0764; Tue, 18 Aug 2026 12:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 345106B0760
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:35:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C76FD1C080A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:35:47 +0000 (UTC)
X-FDA: 85114941534.08.154440D
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id BA967160009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:35:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787070945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vSOIXE8MBqQMEDA+96b+J5y7JPJJuSAslxY0mI5H4bs=;
	b=fBlPN9lijj41dhscd7zDHbh6bk6T/48DzyUphCsRQgZWsX/f4gxiSwcpZ4ED0dNAV8V/cV
	MwNjof40dCaOewWnChBSEDglmhp0+v6AbJYS8R4556cF/ZIFjeepOJ+QwzdW2OHKk/TUqk
	3XW9TlshhU34BYONyfghayXvVQxPkjE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.195 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787070945;
	b=h+CetgBvkB79w+UqO7GzfK3FiCWYxtydQ+Ag7Ii0LQZrb99WgG1fH2ZsURTIzI3/DaYw/X
	XTe5F2YD91qBI67xoAsNxlwB5QFOD6lPKTwzQ+BWD7VuiiBIN+eVJfmbn2kgHi+Lh8f+GZ
	NX4DINmhXdZeyH7iloZL/1eXUpGJXbk=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 7B2C91F481;
	Tue, 18 Aug 2026 16:35:41 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Wei Xu <weixugc@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v3 3/3] mm: zswap: drop cold writeback folios via swap dropbehind
Date: Tue, 18 Aug 2026 18:32:00 +0200
Message-ID: <20260818163221.589352-4-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260818163221.589352-1-alex@ghiti.fr>
References: <20260818163221.589352-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTFhwtGOHO/OC4b8xDhaenAw0ulkOus9FaFWHZYSGUVEHOu3uVHUJQDjV+J84J33ebDFlApYLH3YLEUqtWFmuQdSK1irj6MX1MBEbJLXzAQx7OObcE/toye+GUN3UEOmEvSmRNLLmpgVb+qXKjo52/AG6mFAh7FS744BvnTpNurRq3t6Hp8S0BAmC/gKyOBrbLNJozvfhAa3w3qU15mfEoNYHwE0OU5NKqOYfxUl3AOq79I2M2NeYOwJv2DcrCoGGhb/RilbXlq3sGiCkYnmrOYmu1bDDktDq70Sd5yAaOIv7w5aJ2t7nvcUB+FCfg2l/PUe7QukE+KWF1EEzPeHJ2btbH2uklxcsAHc2+w0VMrqR6xDiRElI6DRrpsWOkkaGoSXnbysFZsUX3cde6+iTR9TdURDhO5Dz+71lGBThShNuw7cx7eC8/LVDAaSkuzjJfwbuVNUfX78Td+1KWX2vrk2TXM7jp2l2LJyOBGmURp/nIXUzQfd0MGs5VzNfjfZNu5/v2B5mNddp0C9NJqKZM1RbZviCqUcmawUK5vCucJxdJwMF7gTSOkT+9RdHhtWTMflW/Ed9jUsEmepGn/1bwBoObLFITCtw2JENSdYFVnSdaAj8h1vWnEFcCwC+GJJUsDH3tvUwWWUe5h9eCPNDwBH+mLG8STCj7MWXXSnPbROxw
X-GND-State: clean
X-Stat-Signature: 4zk89tqgn8stgsy7zdnmurxwsyjyo4m7
X-Rspamd-Queue-Id: BA967160009
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787070945-164011
X-HE-Meta: U2FsdGVkX1+ff1C51f5DSoJXJYLWGhaxNfKrCFx8v45CFwChVQs+EUS67NTOPKgIb4X1CJQzxLOY4RixyG+79euHfb1N8OPVuoXFVMt2obNcpAQSfg0CBt0sQY3+Xu8WjRpaqo/T4ClaEiM2in15evdOrOy6dy+Rr6iWIRYIawGFNjIJDUzKVHztNh601sjn7zPRgztShT6To2KavvvBv7kcEm0qdOirYKIHsQhNEQLw4THaylLwuO5TrkTeR3q6ITKKoXh4EJ2tiGtVN+YEJFlu+LfWtx+nG4P3sPw3CrdX2DWXBzpzE64OFgTQ6Lrbpw+/enoP1M+zjEB+zU6JTHMuARMiQgi8xAW5/V7oHHFr9J502EeJE9d5aGyaWE7wpzQVPluT1mPvRAZ4vmM0oRZ6pU/EX+Q/XjbQ84nlhSZc/eLGRLNqjS9HZ1Zj1vCfUfGM0s6j+8BYEip4g+wlbgPgGSI+YLhOY8lUba/ZCUan2QUV1bLKHUYkLWZ7JZALL0fhFzwRcYs/leyAx62CRiJKWyMSpp3coNpPploB17GpSgwPk6R4Hvi8hOjalGkIi1P/er+sKl9/Q/79wvrWZwKewMUZeAbtKwSHp7GaxQlDyAh9hd5eYCxxuNVA9tpag0CyoufABQk3w52dNcim6AhHXdwPSnHAyXLML2MFvRmHxFXN1e6bL8UaTjYK4FUDH1KsX/47B4m0X2/TnJNc5fgiWnamRYo2Xbex7kRHPLW5Jfo6hKe4av9wDAFn7jDeyAd2NwwNHedqqvSTxKFlm6qirEoyvMbt5xWfAtVvlmzIALO9DXJSU2EjmzO8OsKg5sLMW+HgqYsNqzniAlsWgHcNWjR/TpXFOSVUb+JVU1asocN2mCmDLicbOe9DU0RKaPSKZdi68dmww3N3u9jDtaLfRJwjXVDpzfxnMhYfrhet6NVcw8ccCTKyWR/U0m3QUhgKIX8RGAW8cD4OV0p
 X6PDXi4+
 pnXiessgBnZGoZj9VGZd7nWEe3ep3gGtg0hbSnYBuqNqqOHbMGwhKbdhNmH9xFOWAAzfoqE4z0+n8kIBHzYcX82c9ZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zswap writeback decompresses an entry into a fresh swap cache folio and
writes it back. The folio is cold by construction, yet it is left on the
LRU for reclaim to find and free later, wasting a reclaim scan and keeping
cold memory resident longer than necessary.

Allocate the folio off the LRU and mark it PG_dropbehind so the swap
dropbehind path frees it from the swap cache once writeback completes.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/zswap.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 8163e6c5f76c..a35671e837f8 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1013,7 +1013,6 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	 */
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
-	folio_add_lru(folio);
 
 	/*
 	 * folio is locked, and the swapcache is now secured against
@@ -1046,8 +1045,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	/* folio is up to date */
 	folio_mark_uptodate(folio);
 
-	/* move it to the tail of the inactive list after end_writeback */
-	folio_set_reclaim(folio);
+	folio_set_dropbehind(folio);
 
 	/* start writeback */
 	__swap_writepage(folio, NULL);
-- 
2.53.0-Meta


