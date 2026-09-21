Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23283C982EE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 347F16B00B1; Mon, 21 Sep 2026 16:01:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1246B00B2; Mon, 21 Sep 2026 16:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C0F66B00B3; Mon, 21 Sep 2026 16:01:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF2816B00B1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:01:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A3291C2152
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:01:28 +0000 (UTC)
X-FDA: 85238839056.21.A5FE80F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E079F10000C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:01:24 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ElKC23rv;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zg9d2/OMUG70qYu7TGJ+44plepcpjkecBMRJ5CVA3ok=;
	b=o14INGaOIkF0HBi6vh5Lv4LjR7R15fUo390J1ArhQRAvISkV2Rdhkq0TUfUKRyN5WmuwqI
	se5pvH7okr/qord6GXlS9zgZBumjXlCzcWMW6EajhFeaVbeGvmz2J9VXEgDsxpWp0da8GO
	Ohuo/DnI9GpY0HfyaSsrqzTy7SuY4Bc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790020885;
	b=7Cfz3HAaAHnefzototVCdPytn7b/iHsI44vtuF9gfBtDEVMY48oAs7qE3mOO3AHZzWTeZF
	ytvBQMRUoEXNDongHm0VFbYt1ZC/V4HXQuEmPA8vv2qKdTKq2tiaFZSFPQ03AnwAQhIRU3
	zGAIGJVd4MIDuczC7y1S20fBKE1MugM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ElKC23rv;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21F2A40D98;
	Mon, 21 Sep 2026 20:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB2A1F00893;
	Mon, 21 Sep 2026 20:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020884;
	bh=Zg9d2/OMUG70qYu7TGJ+44plepcpjkecBMRJ5CVA3ok=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ElKC23rvyO1EuK7ppMEoqRlqUUtGVy9Pz99ZAK05LZl3sJAPS75pzvrKqOsPpMgSb
	 FTEy/U2s99jvXjlClKts/61uXJrC7PNs5Epfa9Ml3BSUNVIX4qPifcyM5sI4VnmLVU
	 cm+xh/89Ej/nrPYsQkBbXBOkGWgAAr/hPCA62KX48Znd7jlaSKZKGiH1v2oKkfeYf2
	 c+/9CXxxMqPaexpw+ptD0gfSJkdiuNr0xZWKWLEYmjtFZkOJocwym4L156YICwZmVM
	 X9C4Hcqq/vLNsn0djO4/LCjOEZ/JH9R+fjbZRDcyxD00LGgKcMemXOFR+XDlM14Y6h
	 oV0lnvOj+dCJQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 21 Sep 2026 21:59:05 +0200
Subject: [PATCH v2 13/13] mm/memory_hotplug: drop
 CONFIG_HAVE_ARCH_PFN_VALID handling from pfn_to_online_page()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-b4-sparsemem_cleanups-v2-13-54d81d65e125@kernel.org>
References: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
In-Reply-To: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1240; i=david@kernel.org;
 h=from:subject:message-id; bh=wS9y+w2lDfEszO4z/i/MtEKk8SGbU5ElVBcX2HbtZBQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI29rTv7z8j2O2UNOnPlhj7adzO/DcSrXuzc8wyL7/j2
 fR5wuXDHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExkdjIjw5OOOasDtXXZFWsu
 mq11P5rI8LLx5J5zS/rTo17pzi7hnMLI8LBoT8j79/clv2qv5/nSPOHy5oshduf3T1LfdzFzaeN
 8AU4A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E079F10000C
X-Stat-Signature: goheksn6gad9xy7k9fuscqt9z5t5wkkd
X-Rspam-User: 
X-HE-Tag: 1790020884-900953
X-HE-Meta: U2FsdGVkX1/rPT/4zbcVzxx1Qp6WQrNSWoNaT9Nl/16mPyt91Z7Tbuyc1M8A/eiJaot63MjCmI5ApidyQagADWR94cn0Zu86uMSoMqNdSHfGVQ0F5TaTxzd9gy2XsoC0W2vbJYBQswLReiMCqrnPTw0iqNHKis5Gi3nXaCRr4od4+Fu8T6e99OLNFjZ2VuRZ5aZx3AqLmqMz6V3IlvUXQEaMfiSBN/6k/nMrfbQ8upUFDYZoopd78WTHWrF0QO+RnIvSj24la3Koc4v3Ld/EX6jF+4E4MFDR6BXEnd3xaj1pojUCgT5ilmA00Zt1pDumZ6lK8WsZilVVH6T4ElmGX7yIbD7Otpt2XieQ1to8RHbkgGD4/khrq4Lj6NxDaHAmBg3ND0gDoU3Dl+xH72lMkFLv2ysFIz6JfTZp2bTa0RDHGZC7voJUF24+Py6qsbWqI0/leiULLy9oQ3Tu+xAyHLnBdb2OPhU8XRXNqkEg7iD9niqgSf/2aB6kjyQ45j5IZZCUa4wBbJoyB3u9Yc/CHKiwpNt3L/zu4GLu6rJVrXq2Y7SLPAD5gwldefOesbZkHXiB9sdAd8lAssRqlBw2CiBTU273RGeHLGXy5+KZa9+Yq4ifUBtSdxay6yO18zHzIqXW+WOKixi0myOiVqB21c5i/UbOC6/x4gEDtic74UErzEX3bgQD0OGhNI2PELiJwdg/C5Z8N5Rh+RoxlJV/hIeQXr9IG8udB3WgEXogtf3BkxEqzbp7avO0lOydWb7Hvv9R4bfst5DJNBKDbP21BpdX7GTKMjXoDPs3sOqaS7KiMtDrwe/BuPj6dpI4Vu2fXlGvpOxtLvL0iLL46GQ4wS7Iq/rfvB3RWNr3qcdz8tr+QXVRWPiKzY0GE6fKRUP6kWw9robZAnaLC/pbLu1AOsrrH02f5pNGxOUfD2Xq9Dq6EKGZRW0MNTs7GHVXPH2n4ucLkdJL7peHbFxk+JK
 lMiVZEbe
 9b/BRVe9p4WVPOd309WtnS+BvdGypirjvK2lwfW96g0U5xWn03JzrM5aSNE++vRUg0RT6z10KpmY8kzpmIElEUBJhEq0pVLEO/MVm590SLMP8WgmZ6UzEQW3Q8LLbGSrms9RrlKOaA5q+F/ifF2b2x/0TJ3V5vzzhAO/b1L5qyhk6cy4iYuLGd7i1luMwSk8LXLKE/cyQqxMD0PKBQZL6T90rzaq1KbY0fTJsppRE7S7x4DiZwS25YXNkZQQctpWmpWi8b++DLUaQvrCeZWVWI9YN++2uB8DEqTto
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Drop CONFIG_HAVE_ARCH_PFN_VALID handling, as CONFIG_HAVE_ARCH_PFN_VALID
is never used with CONFIG_MEMORY_HOTPLUG, as the latter depends on
CONFIG_SPARSEMEM_VMEMMAP. Make sure it stays that way.

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory_hotplug.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index d7a59167bec43..796af1028ee23 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -345,6 +345,8 @@ struct page *pfn_to_online_page(unsigned long pfn)
 	struct dev_pagemap *pgmap;
 	struct mem_section *ms;
 
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_HAVE_ARCH_PFN_VALID));
+
 	if (nr >= NR_MEM_SECTIONS)
 		return NULL;
 
@@ -352,13 +354,6 @@ struct page *pfn_to_online_page(unsigned long pfn)
 	if (!online_section(ms))
 		return NULL;
 
-	/*
-	 * Save some code text when online_section() +
-	 * pfn_section_valid() are sufficient.
-	 */
-	if (IS_ENABLED(CONFIG_HAVE_ARCH_PFN_VALID) && !pfn_valid(pfn))
-		return NULL;
-
 	if (!pfn_section_valid(ms, pfn))
 		return NULL;
 

-- 
2.43.0


