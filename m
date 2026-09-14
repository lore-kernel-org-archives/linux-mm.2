Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDEA9C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 03:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB5766B0092; Sun, 13 Sep 2026 23:34:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42AD6B0093; Sun, 13 Sep 2026 23:34:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7FA56B0095; Sun, 13 Sep 2026 23:34:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97CCA6B0092
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:34:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C444E1606CC
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:34:16 +0000 (UTC)
X-FDA: 85210949712.16.04D5350
Received: from mta0.migadu.com (out-3.mta0.migadu.com [91.218.175.3])
	by imf19.hostedemail.com (Postfix) with ESMTP id C6C1E1A0004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:34:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=djkAODB3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.3 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789356855;
	b=dOy/gDE0u1fYEZ/dknu7udpBSQPtk23kcVyA7zMy7GRzBFdGMi2ofW8rixpmHQuX4okWRp
	AAJIUPRMPDcfypGMRpbNBXb26aDxgXoHJbLf0dDnLxqrgK/omofAy6QafvHF6K29sNSfxo
	koMx5HOzuWWOYd3XbXjUSlbwCFn3f24=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=djkAODB3;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.3 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789356855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JOAGub8MSHbJd/8LKk1qlgqBINDZ9Kg+TTXE24TCrYA=;
	b=vUEaynfYhMeMZ99/beez3sqrnZEevbz023r+m96hAMn9NjEaRjnUZd1BGf6V9O++6eB4Ff
	vJUxsU5CkCoEreMmAU/4G7M4/HTH7cwW/zh3GAoZeh64YgQmhX1i/xxgKFnDq4qFjvnFH2
	LcF3ji3L2YmG/3fFgiLElwu3uoPmTzQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FjLD91OsmHHYXnKEalfNO2UjXgSa8L0XL7p5Xdw+wAE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789356853; v=1; x=1789961653;
 b=djkAODB3+Q7/HNzhx2ZXdVuKpSEXgkumiGXVm7297ldREF4tU6vyOBml2BF0GW1zBLavcTdV
 ocY65ma5LzOdr4xaH0qcbNcqJJNU026tIBV/7GkBnvcAKNtkn5IL4YvR3lhRTKg2U3SYCceb2VU
 x4L330CwDHnK/VRZrDsBSFtE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id eb00aff8d21a2672;
	Mon, 14 Sep 2026 03:34:13 +0000
X-Mizu-Trace-ID: eb00aff8d21a2672
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Mon, 14 Sep 2026 11:34:01 +0800
Subject: [PATCH 2/3] mm/vmalloc: extract vmap_insert_free_area helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-vmalloc_study-v1-2-526f68559706@linux.dev>
References: <20260914-vmalloc_study-v1-0-526f68559706@linux.dev>
In-Reply-To: <20260914-vmalloc_study-v1-0-526f68559706@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C6C1E1A0004
X-Stat-Signature: 76wbm9uu187h8ajz3c4myhd3q9zgazr6
X-HE-Tag: 1789356854-94102
X-HE-Meta: U2FsdGVkX19ZSwsFEsDcdq74XfbKbitYbfVVi2fbd3UB8aQGWUYOIRtcp/W8jWDZu3kTPjOblGiLll0koa2SvaATGvcqwC3cUenJ8m/NKjNJyMplodyNzUdpLMnk+6yB8cZ+SaUzPVHw7K6vo9foZdKf5owzXbyYlYUioKxGT+fLYAz+dMuKIKvBpytelOQxZS6BFB0p8Bj09Gpwg/f+qU7vAtVeM39H630Wn0CnpzULZY1RKTIAA4XXafuW0Z/RCotiq1t2MxGEkitf3NwUgxZ8xRbFkWsUHmUSnYSsnLyhdHgtRYhT+ZkpH7N9U24rLbj6EI9flQMgOuZ4j3XifmTB4oN9j/T+wOtsdKDEeKFxvkwvqH6P4vbPkiJ9Aq6e4uNzlW8oxmmKMip7j0/SrX5HaZKruSegPuosRxd10iJ+KgbQb7cBTTlidoHfjYNzMVrHWzRXQF8y5+1cv7WgpdJR6YL521nQK0l85AMOH7C+q9uuvk/zg0eD/79bfw3xm2FtEgVv13Pc6oQjpW3tmjRqxOO4Ah8lHwCIpoSW+NrymZzr/VSWKLbtMJRXy49j9z1py8VzCHK3mgkepcCrvhdvYD+uIy8cJIJUGxhjvhsjgUpk22ZM/6kxIqsnhUSeR79EgU/ZZzV/YixIgiwHt/241VjfQSvM1qNCgTVrpK2xE8y5Mv/yPpwMawdWhXj1/wkD/BTLJDHGsAUDJWcwb2BnTAczIqOwuha7rxiPp0ntkBfvcx5rg7qvV7enuxaL346lXI3R30boo/WkImLbYaMETa0uGnjr/k9zXG90mVzq8jfI+rjKCXHNE0Ci4uvmdb+0dhje03JGja1rFl1LWyCIj1AQdk4iOUxPRq8ewNx0BoQsCk95VYyfxf4rx2DeLx8ushPwaWE/D1bD5SXHsjyrrQexSmpk3eD0UrGjYpq44TNiabUeG3DIPAMklPrIK4Ln7W7j2CrdTZV/s4B
 7O0jiqgv
 PxUx7xqNYdcMsh6fMRHXVFgfQ3mKRClTz/p0McD9xxyGhzXd0TlK1Ug/Yfkm98i4unSqyJnsRJNUjApTMswPGwgCnWK2wpj+1uhtjAxNv+pLvEXBKnhWFoBgYCTvmswIew8yDyPY/f6E1+9tHNhJBCQDs4b8CQW2ctLcOvkKGakc/yUcVoNRmcbeLKgQ/e6dP+AU9KdAy5G96p0z+UxYshYuK1yOcbfv3eacBF1MacjwvkPiKZMMbsQLmU8oQ0RjSyyXqvTGzy+ct9EkqXjFOlGAB6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

The allocation and insertion of a free vmap_area is duplicated
between the loop body and the tail of vmap_init_free_space.  Factor
it into a small helper so the main function only deals with computing
the free gaps between busy regions.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/vmalloc.c | 41 ++++++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 117483dd048c..797933ba9451 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5433,11 +5433,23 @@ module_init(proc_vmalloc_init);
 
 #endif
 
+static void __init vmap_insert_free_area(unsigned long start, unsigned long end)
+{
+	struct vmap_area *free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
+
+	if (!WARN_ON_ONCE(!free)) {
+		free->va_start = start;
+		free->va_end = end;
+		insert_vmap_area_augment(free, NULL,
+					 &free_vmap_area_root,
+					 &free_vmap_area_list);
+	}
+}
+
 static void __init vmap_init_free_space(void)
 {
 	unsigned long vmap_start = 1;
 	const unsigned long vmap_end = ULONG_MAX;
-	struct vmap_area *free;
 	struct vm_struct *busy;
 
 	/*
@@ -5447,32 +5459,15 @@ static void __init vmap_init_free_space(void)
 	 *  |<--------------------------------->|
 	 */
 	for (busy = vmlist; busy; busy = busy->next) {
-		if ((unsigned long) busy->addr - vmap_start > 0) {
-			free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
-			if (!WARN_ON_ONCE(!free)) {
-				free->va_start = vmap_start;
-				free->va_end = (unsigned long) busy->addr;
-
-				insert_vmap_area_augment(free, NULL,
-					&free_vmap_area_root,
-						&free_vmap_area_list);
-			}
-		}
+		if ((unsigned long)busy->addr - vmap_start > 0)
+			vmap_insert_free_area(vmap_start,
+					      (unsigned long)busy->addr);
 
 		vmap_start = (unsigned long) busy->addr + busy->size;
 	}
 
-	if (vmap_end - vmap_start > 0) {
-		free = kmem_cache_zalloc(vmap_area_cachep, GFP_NOWAIT);
-		if (!WARN_ON_ONCE(!free)) {
-			free->va_start = vmap_start;
-			free->va_end = vmap_end;
-
-			insert_vmap_area_augment(free, NULL,
-				&free_vmap_area_root,
-					&free_vmap_area_list);
-		}
-	}
+	if (vmap_end - vmap_start > 0)
+		vmap_insert_free_area(vmap_start, vmap_end);
 }
 
 static void vmap_init_nodes(void)

-- 
2.25.1


