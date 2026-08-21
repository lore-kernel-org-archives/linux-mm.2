Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7346C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 17:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06796B0095; Fri, 21 Aug 2026 13:04:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB73B6B009F; Fri, 21 Aug 2026 13:04:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF3D76B00A0; Fri, 21 Aug 2026 13:04:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B16DB6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 13:04:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3D2CA401D6
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:04:17 +0000 (UTC)
X-FDA: 85125899754.24.90D0F4F
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9DE8510000D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:04:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DNzWoRYK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3DoWIaggKCJU32JBzO3I5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--edumazet.bounces.google.com designates 209.85.222.198 as permitted sender) smtp.mailfrom=3DoWIaggKCJU32JBzO3I5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--edumazet.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787331855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ytXCiIXJSEWeQd3fczjuZy6blW2T09URPllThg0U0lI=;
	b=sTjgBI2XuiTLkoAva4l2CsMPMp6xUycBJCwxTmWvF3OnXTXjESC6z72jWiVEz9/cYG8Awf
	rFVBW1UyhI9gxlsTGPAc3DpNV8+HDGrO6JhSddiLy/ij1HviuzrGL3G9GyKpDfWYgxLu7H
	RgIMAG+MvXa+axdWPyZFoik3KouukRo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DNzWoRYK;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3DoWIaggKCJU32JBzO3I5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--edumazet.bounces.google.com designates 209.85.222.198 as permitted sender) smtp.mailfrom=3DoWIaggKCJU32JBzO3I5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--edumazet.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787331855;
	b=PRBMuBtLBLEfEcl3Opxtm8B5kDTFinXKdHSGSb3I6JhpVYiy9C/b8Wl5E6Ovs20jJH5Y+2
	ROvWbWLTlnb/OIEgAqzB4aDpIakdR/y/Oz4T5gqch402zkQmjyBXABr6LhlhBd/xKznq3A
	0bzms3auRv8uEJa4TbTBO1DqBrHcdRE=
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-9372b9db132so127519585a.2
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:04:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787331855; x=1787936655; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ytXCiIXJSEWeQd3fczjuZy6blW2T09URPllThg0U0lI=;
        b=DNzWoRYKMu3szdvmdWgYGxpnsvuoPYvL7G+l7Qo0SsI5xSrsBiYWAM0UeglcPY7WRj
         Xh2SYecEScUBV3j7stsu2Q37h2G8o7bG5xkpyRgxi93VzUyv+zeIg8ZdHHocNyALvIO0
         xbLiCFV8lPe8vF2AT9SvGMao19iz/1+VZ4K/2SjuZAFnnF78Nu14ATnAexBQtboJwBSv
         equbhK6dCFWLdcsl8zQqH9tw4T6K3NDIJ7xWCdT0C1NoPCgq81au5ga5tmwl0vHuRULO
         aPr3elORHPuOcC+kJDJVkfHICmRtl6BKHd0GlNVPHXqe1ddWWfoBXReYrD/pSxiwqeY4
         E2Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787331855; x=1787936655;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ytXCiIXJSEWeQd3fczjuZy6blW2T09URPllThg0U0lI=;
        b=Bp0R+cfnw+hekvndXyegclrAYDwY13I+g4Jofzg+hl3lFGNduQtvUYUzrlPThV7kul
         AicID22xf6tqRmqmW4lWjJCquloCrVi5P4h0e4OI4uqN7uW66/FcRV3Ai7G7bm7gw0OE
         i2FaM14rdw+Qz/4M1Qe+aCYyhwQbzjSvixm2WFEkY4gNtQBytddZU/oNs2FU+6bu0lDn
         jZ0ZnKHn+Wa5DUNAUDZqmBvIHT56VMD674nL6QZF7d7/Sjw+NBiyYjxSi5bfGjW6QfeA
         nbGmxh8x0qorMQ2UpZwYRtD15+Ei+cOOC0DlkGA+hc/wKQKYDLn9iCFiRpjg/YG/EhLy
         YyEg==
X-Forwarded-Encrypted: i=1; AHgh+RqTeTJ7QO+gTFQU/TFD1AUbPzKIlZKiotkfDYhL5nbKw3COz5YkJPxRK/4eG9aC9u9kbFwfO2jk+Q==@kvack.org
X-Gm-Message-State: AOJu0YzgzoD4mkM2Jg9FzJOkQo5xCRTfxV+HF8XEQ2r5nWh0Ajr7f1AZ
	U7N3B5fxPtyUipitP0H+w2ojAmuZuf8cUSg/YKu5Slpe4SkaCi4omW26Q8K5/m9WubAocSlexW1
	33eaLy5HcjoCk6Q==
X-Received: from qklc14.prod.google.com ([2002:a05:620a:134e:b0:92e:6551:eed3])
 (user=edumazet job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:620a:31a8:b0:92e:e1d1:49dd with SMTP id af79cd13be357-9373957489amr644583685a.21.1787331854394;
 Fri, 21 Aug 2026 10:04:14 -0700 (PDT)
Date: Fri, 21 Aug 2026 17:04:07 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.766.g2966f0265a-goog
Message-ID: <20260821170407.3721004-1-edumazet@google.com>
Subject: [PATCH] mm/mempolicy: Fix sleeping allocation in alloc_pages_bulk_weighted_interleave()
From: Eric Dumazet <edumazet@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Eric Dumazet <edumazet@google.com>, 
	syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DE8510000D
X-Rspamd-Server: rspam07
X-Stat-Signature: 5o9a77nbqgdib1nkupnxq1s5stu6g8zi
X-HE-Tag: 1787331855-279890
X-HE-Meta: U2FsdGVkX1+Exz+9jUNBlPYFKZkhIfR9QHPKRAfzJ+7tfuQu+uHZ/oIM6blpxUEfd36jbwSf2EsnUTDkkSm7mXTG54UniS+EhaCoXwl+bFSsRr8MV4nlmoFaTcra4unrvIWVnhmnrbwvCIwrGhBoFV6uCs1MJM9FEIJBGszp1Loe2wLM2Ph6OfMY8nfbHUvog5PD2JDx56x7iQRaBF6o/keJhYit+MiMgIrqGzv0+Y/gHQ8goUHQsCcfEvrgYmjdfObprf2TfVTEmJf2tOP9b81WgBnvY2zTIaaV1NGTByu/4QBGWEGPYjGckl+BhOI6DWO22/N37DgVTOogqlxwRfYMFF+vZKMK9f5iQzPNRDSJpPJlM5/P1g5Jv5rbQO6HDNNX8eidIw2LDm721Ov7RsMq0TkjXMYFJM9axSKcwtBDV5HNc7rYB2UMU8+nTsVxQMxmqSLd2BTAk/j+dYPh+0Dv+wFdQhLZR/apZeF5KiZVGWwA0uBpWv+3/OuuGxxT3A0RTpaQz9Sa9a0Hfy+SzlPoajXYy1JeAxGIH6lhgXFm/loPLlj0i1jFrEpbJKhIsIDrOYddj8X2jtEF9tRLvUGc0E4sG2oLYNOzNsStlyUCzRBum20xynIS0QJUJE0kNhgdSYGetYin0ytmKBprx6yb0pD2eoKAIsUEmvzKChUcVAe8fJC2hg+Gib30x4YCMEyQOhjU79Fr4m8HI0rciQvdujvRjqgw01N/czNasuOX2EuhT4Ne//3OzdUwgefChvTFi3zvRSwDSrUdE7VMfldIw+HYZGnSEwTUz5v/qhgEZJTQIHfyvlRUCJbSK3ht2/ZQxA5zhBKxBI3PXqhJW+JEJwnhh5W4bQf24BbbJ/HpIDWs1KWnJBP9Pob3cEj0exN2d+z7a4ChEoSGE3nnnGfxYjiIaJZXVmeqEVO6hvtJc0vp/8Cw/U9Pz/bActJUN9vVj3+NQiP0RzdwFt9
 b5tN1zNn
 1bU+i6epB7MdnbIx21A2CbbiKhWZF6G3GMyUrtTNCy4H8amQBQKyxN2cCyuN4/UFbubb9ZU++lP7Gcm4rhdlYEu76Xe9l2Z4vOe2Ov8LyNsRJFmIgmOJYBJ9fn9ddrppAkvJvDzs1UtnwRc4sZ/8GaR+XldiNt5wiM5SYwn3YYH4scHIzQXZafYVCn4Stm63LuNXj4lVUABY11J+uwjfujGEI3YHsI+xot/bcwEvCWwiUZEYVJFiTiHd0YYBK+O7DhtRLfR7p8cvdkDMbPNpdKszZXoYo8oAYyVjc+Po6z18xdmFpF1V94sxFehgZnAUHk7HUzvzjQ4mV3KKTgGwPMN7UG0yYVitttPMon9z0F6liE0R56Pkqhi/Jhx+sebQ4Y5op96PwGLjW46CK/wUR6k+PoW/TFOuU3rfMkCBa7OLp4SU+wSLaF6JUUHV0Kxv49DNwo1Jo5pfTN3x04Lggx2E77WnXb5LogVBBb/tOcPttCV4dt2M4WYCfPXMkgu5/03fx8ceUJXZScqthMhLyAaNV5NCYMt4Ssm3NgOKwI9BuK/3ZdY0ZG5jaJZKUQdhakFIfcUHQ+O6fSX4sq0K30DZPWFrili3uC7FqgFzRJX0LEbYMei8MwC4t7KEkbOj48AZPUI9bxBJLGb6UuNdKu2xUrDahDc8bsKZWW3Uf77+ti6nroG0u1qDPYzl6dvDbJ8ghmJKByIV8ogwDHOpnu/XCJ95b7c4y72Q7BYCh7JhNwKU5YxOuIPlrlBkU5Ga9nxFOl3kdfhbMN5mlpuYJSNHaSghCjxtlXFyKm3dOUMR2fOfLHis9WQMaVvgogItWZcDw5CI2Z3ESTZTJI39JnjuD8ciYy56p7/ZLgwEPKDKum1/nfjA8rhyFOwJ7PJ3nN8ToqI+QpFfhArluAR36I3/ZVRtjjVQ0Kt0GD7EaQnkQAtIuQ1SSIdSHK2L3+qXIzGYFIzvwM4EHxMy9ZUp71XExYJnf
 KCBMvibi
 45WJUfNUAkFcQqPJZndl9Tjz93ORYKp9UR3WJc5OT2EPeNcinN5sumh6pIoMuCpGhOVFIkKHzj7iJvrOtysZ0h7osl5WxaomBjCq0BPWEXU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot reported a sleeping function called from invalid context splat
in bucket_table_alloc().

When rhashtable_insert_slow() rehashes the table under rcu_read_lock(),
it calls bucket_table_alloc(..., GFP_ATOMIC | __GFP_NOWARN).
If the bucket table allocation uses vmalloc, __vmalloc_node_range_noprof()
invokes vm_area_alloc_pages() -> alloc_pages_bulk_mempolicy_noprof() with
the passed GFP_ATOMIC flags.

If the current task has an MPOL_WEIGHTED_INTERLEAVE mempolicy,
alloc_pages_bulk_weighted_interleave() is called and currently hardcodes
GFP_KERNEL when allocating the temporary weights array, triggering
a might_alloc() splat in atomic/RCU contexts.

Pass the gfp flags (masked with GFP_RECLAIM_MASK to strip page-allocator
zone modifiers like __GFP_HIGHMEM) received by
alloc_pages_bulk_weighted_interleave() to kmalloc() instead of
hardcoding GFP_KERNEL. Since the weights buffer is immediately
initialized in full, kmalloc() is sufficient.

Fixes: fa3bea4e1f82 ("mm/mempolicy: introduce MPOL_WEIGHTED_INTERLEAVE for weighted interleaving")
Reported-by: syzbot+0dbf6d295b3350944f0b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/6a88837e.ae6ddae5.3da009.0040.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
Cc: David Hildenbrand <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org
---
 mm/mempolicy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 501e0b80d7da..1ef50ca37d42 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2688,7 +2688,7 @@ static unsigned long alloc_pages_bulk_weighted_interleave(gfp_t gfp,
 	prev_node = node;
 
 	/* create a local copy of node weights to operate on outside rcu */
-	weights = kzalloc(nr_node_ids, GFP_KERNEL);
+	weights = kmalloc(nr_node_ids, gfp & GFP_RECLAIM_MASK);
 	if (!weights)
 		return total_allocated;
 

base-commit: 4e69c1856bfd9ffb7e9d335a25842fa211628929
-- 
2.55.0.766.g2966f0265a-goog


