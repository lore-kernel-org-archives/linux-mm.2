Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73A96FCD0C9
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 07:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D91966B0109; Wed, 18 Mar 2026 03:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D426A6B010B; Wed, 18 Mar 2026 03:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C57EE6B010C; Wed, 18 Mar 2026 03:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B51256B0109
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:40:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 50BB41A05B3
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:40:56 +0000 (UTC)
X-FDA: 84558387312.10.5E0D3CE
Received: from outbound.baidu.com (mx20.baidu.com [111.202.115.85])
	by imf05.hostedemail.com (Postfix) with SMTP id B9361100016
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:40:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b="Pl/QLI09";
	spf=pass (imf05.hostedemail.com: domain of "prvs=md15319726C1=lirongqing@baidu.com" designates 111.202.115.85 as permitted sender) smtp.mailfrom="prvs=md15319726C1=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773819654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=y2YpHlh+WSQL0MG8EwEamlgcCGzhk9KPm0u1wFzft7g=;
	b=GTcRwfkzuBi30fJXPYWBQnEtWbcyZrTcWiV3PMqyznMUjQzdOEWA8cjt9T8smvlQs1+kLw
	mWjvT+l4a+LX1I7wDqZR28yPLkx5n53WxbMDjRkoXsuOwy8oFxarbqNSJ/NoRxV4Cck3ni
	ccL1oRZiGMACzv+4qIOtSKImjVKZjPU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773819654; a=rsa-sha256;
	cv=none;
	b=jGRQQzyXtt7qhHKpcpsLLZ7moT3d97P/Ipu/gSeUGLRSIxiuW13BJHDy2E0X+ucJxfM9Lc
	VNJEyUVMPY2ulLLa5+W+hm54pe/7IVwfIOBLoSdTWw4bv35+9MREcKZ7sQp2Q24YjPuNui
	Av8qu+TerHIZw1ryWPzXbBw0kth7qO8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b="Pl/QLI09";
	spf=pass (imf05.hostedemail.com: domain of "prvs=md15319726C1=lirongqing@baidu.com" designates 111.202.115.85 as permitted sender) smtp.mailfrom="prvs=md15319726C1=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki
	<urezki@gmail.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] mm/vmalloc: use unbound workqueue for vmap area draining
Date: Wed, 18 Mar 2026 03:36:30 -0400
Message-ID: <20260318073630.2325-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.127.73.8]
X-ClientProxiedBy: bjkjy-exc13.internal.baidu.com (172.31.51.13) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1773819404;
	bh=y2YpHlh+WSQL0MG8EwEamlgcCGzhk9KPm0u1wFzft7g=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=Pl/QLI09z6s1lj6PvqIwSXzpuBWxixFtMj256R4Y+Im91d5/bJ+HgncZQqkRG45p7
	 IH5015wTLSL24frGnFyiPsZcPG4PMACqpHaWCCE+IzJycmvVxfHP/6PgrQpCB+u4GF
	 kMPFB1d4KOU/mfOyC8JOVH2ZVV8zX522mhTIQVPZLKap1LCD1dfVoaVU0x4Vqx2d/I
	 qaOJFpmD3iFxlF9VR1GpPz6t7dPIOrZ2aYR4IBbsXPxkUsotUtrRut6AusjE8aX7Y3
	 aysp47Wr1D3QBDnIT8rdLUO921vlqfl/z/lCWr7GYbzVssGjD/zaVMN6IvBB8YxHmT
	 CkT2FPskJVepg==
X-Rspam-User: 
X-Stat-Signature: m9j5b6bm45jdiupfyt9ewku1xfd5u7ki
X-Rspamd-Queue-Id: B9361100016
X-Rspamd-Server: rspam03
X-HE-Tag: 1773819651-325041
X-HE-Meta: U2FsdGVkX1/QZ7UtrzVEwZ54gCXhJRlJfrlYhcaFVqJIAjw0dcQUOHUzzC0KJsSYDyXyHTm1obBnyAb6syx2aSfID/VYE4NUbpL9kYqsHsw3PB2Zh65Yb71H/e5R8t0kApSNpi6SkR+Xux8lrQwpuV0vzexDAULX8l9KfS039XT8W+zNkrqn1gzW6gAM+osZ/ZdLVJDZbh+SdJgwl5DLRnAd4yEbxEI5JnqXBEsgM9a29EQNDClO68nqazJC/xe2eKEOwvYi7bKX3q0cwredBGwEOpzGaPoeh1xKngjIfkBHuRVGpB99MCZmXUMvzIqTNWm/roaLn3IFusFDX8p3m4xB7/LDH8CFKLQzGK/47wCjaEd2GrHAGlfDHQwzdXNDe+fKEWX53W0b1+mLXAvKsdjoBTu6teBFEbrhsygLVhF55g2OQA1TNw9OKN9u7VD1N15WxduGkhd4SIxAfa9WSJEAZRArEwWk2PHxJLZIOjTMJyquvbJmfjOkVTrENfdaD+MvXiXJLmptrdbrecZtaB1f41LYgxuFv/kbOu5coV3+ebPj8kbpeB7h8HjeprgOgS7QpNKZ+v2AptMxyK9luJScQq83oqf4hcLmRi/lXlxhL3LKaUjH4SVXUEOfgG7ID7pjmk8Ry227CAa23NBBwZ2mK9Z+IFtyluHsfw3HMwulHBTqAQ3eCP0hiC6fqL7dX8bMJ/8pQqnVZgr/b/Zyal6ZWImIwAoZA79Cj6gNCJHvwA4jUKOieeJ5j1GX9v2Vc0ix7mOxgXnJdstrGlLzK1ACDCH3WnOjHTkGbuIozsZ9y8dF/V4nwICbbBM1nO4JQyJ0BqstdgA2Emk5nYjh1yG1j3BvOKfVGTc9Km7UwR6IROfFJl9YPZS/vnzKD/y8orT/43KSr1434dJ5dJLXT9gSfanaSF+Ava/Zzaz1goQlWr98LMtMLFbnYKlzjWT1zAYsewzb3sSSRedgq1z
 0Bv+8RIR
 qRHcJ2kW0q1JghUXgvRalI8Y+G7CxJx7c+ymB1wkrdVWFlR4e2tqul+0agljcde8ivcKI5aNfeBDmeWRi6I6oTS7yqqElNNxeiqvBKMsTpLXFs7lCuwxIdMd5pWGry1/miIX7qb6QkxF3qa81bpRW1ONMs4WQBTeqUn122MEWiAQpKNsuMhGNVY9xoEfctI4JHrx0MmsC7gntbgD492qjR8az86l6T+HS54hk37ThJ8MB2F7EoPUQ8gMv061SbHH2XVGEjfGhbAM4eXCso4k9+0gV+vuf6IYyL46kOzzctifrAnAhUJ4sapEXiFFHbk0HM25zrS2D7RCDbQc8df9ZcjtLS5MlrUvadJGTIZbA0qB8JAumn1dwY5SvVWLzXcVWvswK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li RongQing <lirongqing@baidu.com>

The workqueue watchdog currently reports that drain_vmap_area_work
hogs the CPU for more than 10ms. This typically happens during heavy
memory pressure or high-frequency vmap/vunmap operations where the lazy
drain list grows large.

[ 2069.796205] workqueue: drain_vmap_area_work hogged CPU for >10000us 4 times, consider switching to WQ_UNBOUND
[ 2192.823225] workqueue: drain_vmap_area_work hogged CPU for >10000us 5 times, consider switching to WQ_UNBOUND
[ 3225.388966] workqueue: drain_vmap_area_work hogged CPU for >10000us 7 times, consider switching to WQ_UNBOUND

Since vmap area draining is a background housekeeping task that does
not require strict CPU affinity or cache locality, it is a prime
candidate for an unbound workqueue.

Switching from schedule_work() to queue_work(system_unbound_wq, ...)
allows the scheduler to offload the draining process to any available
CPU core. This prevents stalling the current CPU and resolves the
"consider switching to WQ_UNBOUND" warning.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55..5f2218a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2471,7 +2471,7 @@ static void free_vmap_area_noflush(struct vmap_area *va)
 
 	/* After this point, we may free va at any time */
 	if (unlikely(nr_lazy > nr_lazy_max))
-		schedule_work(&drain_vmap_work);
+		queue_work(system_unbound_wq, &drain_vmap_work);
 }
 
 /*
-- 
2.9.4


