Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86737CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23AE6B00D0; Tue, 12 May 2026 17:07:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFBAC6B00D2; Tue, 12 May 2026 17:07:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E12296B00D3; Tue, 12 May 2026 17:07:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEB7E6B00D0
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:07:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BB59C21A5
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:52 +0000 (UTC)
X-FDA: 84760004784.26.80FB49D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 25AE520013
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jNp+Nj5D;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778620070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBKqj2O9gjX/tz0GTabH1SzaDOD5jZb/zvIFduhmeuI=;
	b=4qxznpzEiGQXOxsLeCPJVHlFKJwwU9ublTJuulvxA8a3yTqk51zw00Rwq481snXZyhSMSY
	TKQw6vm0r1fam+WJkY2Nxny52ZzqbJHYAuDObfBNwdYhtct2r1movcBW/9MR0TQDRfCAaF
	qFUfUGmmLeGo0b+rHuaXSTicI9Zz328=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778620070; a=rsa-sha256;
	cv=none;
	b=3VkqN52x1aD8y7HUviMKoGZCVLNfjw/3nKSjFqI28gJJ9silGxx5mnCOMKFb9ODfykKSnw
	NPtBQ25D4TbJjQFkHbh5dktOrnsEdNxBFelgi21jMXhvNcVWyQ6GjznLRpaxq3JDs0B3JK
	mbcD/e3v5RxMLp278NXOQ/+wRPtj4mk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=jNp+Nj5D;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778620069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gBKqj2O9gjX/tz0GTabH1SzaDOD5jZb/zvIFduhmeuI=;
	b=jNp+Nj5DqYNVE0KyOUMbUdK8ujDlW6phBa8jHGJFHZYbHQDRbA3dKHoeWQurnILetOwMLc
	VQJrbPHMn8c/MKw/iwu2qGwAVK1isVpSzM0lwIViIgYdvc7+8GKEFXBdKzFDtzH9qPlWul
	gc0CAhGfZ1AVvqtREA3tD/Y+pno6RNM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-fKtU1MxLML-xE3YwcxCjuA-1; Tue, 12 May 2026 17:07:48 -0400
X-MC-Unique: fKtU1MxLML-xE3YwcxCjuA-1
X-Mimecast-MFC-AGG-ID: fKtU1MxLML-xE3YwcxCjuA_1778620067
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-486fa07f2bbso35898105e9.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:07:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778620067; x=1779224867;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gBKqj2O9gjX/tz0GTabH1SzaDOD5jZb/zvIFduhmeuI=;
        b=BqCa9fyMqMxf5l6dgwAPKuNPljM6dd5sdWc8Tu0Rnh5U2AX7957v9zqIfZZ84V16M3
         0ZmPbCZEa8f682oNbiHX0jDHTIG66b1OaXFrUxIwubog+039hB8h+6Q3Wm14D8Y/Swqo
         HQg+81yoXP1GdEd4764hKx5+ElAR0sRl8xe5fP3EdAxZUwi2DxEAhLS5PMYMRTrGqEHI
         XDlv9Dke0/oGVYKGfVJNSAPjI+IVbqVLt+ECoXOvg8zDNWz/4KFaGh5Q5KO/YqZOT/mg
         SdvwwAvUsd1VrAJf60YdwoiVEUk/WYTqKKskx7YU11k9Id7TfpdzvL68Uh8kB5DwZsa+
         GRXQ==
X-Forwarded-Encrypted: i=1; AFNElJ+akqUOTeJ7+1O34/tQPAJ7jXpUnEPdorlshkGNNuFBnTHqHtLcy8zWvZKl+XxpQQTEkJCBGh73zA==@kvack.org
X-Gm-Message-State: AOJu0YyiDmsF15Z1PeXyTaExF1AKmfvJFo1QkMJHIm06r2IBWJsCM61q
	hRfqtZ0rPvUcJ1H6TxbhQ8lRerqLfVgGGvJaJV1u6JrapLNwKRy9dV405S12LHPbkdJsrgxA/G5
	FRF4YzvZAl0Pu3UuXeGoWFMD/G15cphQaR4FtYfBigpLwPTmN20Rd
X-Gm-Gg: Acq92OHahH1a471aahNqCdC9AR4xDUPRWqfr17cc/RB35mLU5NbBpWrXFTwacWZeir+
	WX3zirvx4bRfsT/9lbMCgUTFdnJDH8f808/oi4k5Zo49SShqygZ0vTzmYzoG3t+ICMjfmKmIQDn
	rETG6z+96qebGwG5nqygKYXsUJyzhbzeRDli9Fk72zU95Oa0Mmb3EmVsyLiuHeD7vLUXLhUeYp1
	PUsbe1bIOZ9Jm/blGbG8khxuTai46L/s7FSJ2xnF3S1hLwP7/ZwUZ5w3EkwacawT3T2SkeoYNXh
	Jyulz6FCqLDzYu6Gbp3kp8hz9SGYOKt4f5y03DpFClqEL0RPAKOyZGy3zgGAckrdzmU/Yi7mx/x
	T9hgKU7u3C/2OPwqxt/pTqlI1/7l7zh/JNKkAIDrv
X-Received: by 2002:a05:600c:19ce:b0:48e:7f1c:8778 with SMTP id 5b1f17b1804b1-48fc9a34577mr5609785e9.17.1778620067129;
        Tue, 12 May 2026 14:07:47 -0700 (PDT)
X-Received: by 2002:a05:600c:19ce:b0:48e:7f1c:8778 with SMTP id 5b1f17b1804b1-48fc9a34577mr5609425e9.17.1778620066569;
        Tue, 12 May 2026 14:07:46 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e8f63beb7sm30481905e9.35.2026.05.12.14.07.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:07:46 -0700 (PDT)
Date: Tue, 12 May 2026 17:07:41 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Youngjun Park <youngjun.park@lge.com>
Subject: [PATCH v7 29/31] mm: add put_page_zeroed and folio_put_zeroed
Message-ID: <f719e415bc71546c89933dad1c1dff20c8be3019.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Xt2TN9ymv3iALDu7VT60AgPa630odJR7vhk5yZ_VpHQ_1778620067
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 25AE520013
X-Stat-Signature: yt6dagqkh5yr9etig6eipxd4x79rqd3r
X-Rspam-User: 
X-HE-Tag: 1778620070-693510
X-HE-Meta: U2FsdGVkX1+y0w+YLS2RRJn2XOJHjvyUfPghwwyWdJm8JoNpoEvfyrMAzewdW4NQ4qmol0aZpBYCiV1rgloZbYmg89f56o1/Su/yCrNsEkKq0YFbUSR82IXY3hLfSTBKCkz9ZDUvQQqWApatKSL2XBos/XnHprKTKvOWBVy4CrZmPt4BXbp9f94AOqfx8VQ+bMZeM12f71v/ttOgqHJccJiwpqknEKel5xXzak7J/sEoiMLnbau7kfxTOhI4ZvdZaTV/o7OlrGfdZ4Xqxr+rgPhrrAJGmCcEV+4JespZj1eqcHVtUqVZEBamifFyQTxB1fES28qPudyc9mB8Fz05Rk2l0l0K18LWQ9IZoUQPBO7ev4DLyomHJj/oZAcUhYU1kk6XW273lKREcFSEM20H0xFfzhczspNJJ07IslQ4kUfv//ayTXnZgGFAtc/v4ARSJFPi9DqLpBBqhw+CeitcNvgw30Zp+KCQbcPIJMXgNYdLuVcAPM0PVRdExeR3EAABvhLg5KLpS1kAWDXABVd4sdjpb+m2AP6PNy0ywUolrTsnYfufmvDEfCqeUMJI9cEzY4jowXNPBYeBz2/h51KDHnKRa0dHJCit20RuPPPBKVZ7A/j+FzDnvQdz1ZLEPjyE2KcARI2ol0ssZ1Huu8FCZJKEaXAmljqok/jgWpZSQi7rOpNmH4LFOxWPuiLTLHrcYR2QQH3YY9cT7oN2dO9uHs7iTwgycR/G4S9A9U0turkdxPEz+jspmtLtcHMiLyw8Lu8yv4QBj9Wb8QwwskuJnbjq56uV35kYp4W/+fl9fkMwMxi6tSpYBbCjKV/xKL5bI9IYoXwhXDfM6T0LyYqvJppTIEFji7/qrnIOiukoYE7v/I7BeD28LK4P1n4kZQmOoWp16dVtblw77QMCZIV/gUWtdd+yV2fF3NHC7zUNMkZqkHZbTHXY1yHfVY6YiNhUlyQiJFZybBDY+rbYWKD
 /XQD3abm
 +w+pYsUx55A/SDuPjf+O/UYLiPQVSY2rDMMB5TOK+XlN+DxqQzHH49+jiPxjNTOA3xwyJu2xoTTzmxTo6ahPnimGSRKp4eF9VaJJktnvtzEHNeX9RJEKRnn14pbL5p9gFv7RSRu0766eEDSANBneAsuk9UqinPnZqOsbkj3lNUpsbgXTZr76J6XKxJTUQahAa0faeNugOQOWK8NE0KvBLUF0QpEbq9DCZSrsnFGogKuKs4egI199pWXvspu1tIDf/z8YHiC86LM1XaGVrKlhtnuMEQmZCEnhbsvZLoNM2pilD1mVz5p6Kq74GPn8j0SKzn+P39FCaVuAttVhl7q2y4aaE3jX5Rh0F0OgU7IaMPrBKcmkb2IfXFwS/OEKWSVNfDu0VKxRx989YO7GYjCJcccOQE76gF/d8MCibK7I3JWlnqWhTeUl885RUpqhEHXWQuvkwwTaCNY+U3Oll0CuIhfBSqhx5M6mOEH7r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add put_page_zeroed() / folio_put_zeroed() for callers that hold
a reference to a page known to be zeroed.

If this drops the last reference, the page goes through
__folio_put_zeroed() which calls free_frozen_pages_zeroed() so
the zeroed hint is preserved.  If someone else still holds a
reference, the hint is simply lost - this is best-effort.

This is useful for balloon drivers during deflation: the host
has already zeroed the pages, and the balloon is typically the
sole owner.  But if the page happens to be shared, silently
dropping the hint is safe and avoids the need for callers to
check the refcount.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/mm.h | 12 ++++++++++++
 mm/swap.c          | 18 ++++++++++++++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3b1ca90fd435..4c51b7bd7576 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1913,6 +1913,7 @@ static inline struct folio *virt_to_folio(const void *x)
 }
 
 void __folio_put(struct folio *folio);
+void __folio_put_zeroed(struct folio *folio);
 
 void split_page(struct page *page, unsigned int order);
 void folio_copy(struct folio *dst, struct folio *src);
@@ -2090,6 +2091,17 @@ static inline void folio_put(struct folio *folio)
 		__folio_put(folio);
 }
 
+static inline void folio_put_zeroed(struct folio *folio)
+{
+	if (folio_put_testzero(folio))
+		__folio_put_zeroed(folio);
+}
+
+static inline void put_page_zeroed(struct page *page)
+{
+	folio_put_zeroed(page_folio(page));
+}
+
 /**
  * folio_put_refs - Reduce the reference count on a folio.
  * @folio: The folio.
diff --git a/mm/swap.c b/mm/swap.c
index 5cc44f0de987..8d57223dfe34 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -94,7 +94,7 @@ static void page_cache_release(struct folio *folio)
 		lruvec_unlock_irqrestore(lruvec, flags);
 }
 
-void __folio_put(struct folio *folio)
+static void ___folio_put(struct folio *folio, bool zeroed)
 {
 	if (unlikely(folio_is_zone_device(folio))) {
 		free_zone_device_folio(folio);
@@ -109,10 +109,24 @@ void __folio_put(struct folio *folio)
 	page_cache_release(folio);
 	folio_unqueue_deferred_split(folio);
 	mem_cgroup_uncharge(folio);
-	free_frozen_pages(&folio->page, folio_order(folio));
+	if (zeroed)
+		free_frozen_pages_zeroed(&folio->page, folio_order(folio));
+	else
+		free_frozen_pages(&folio->page, folio_order(folio));
+}
+
+void __folio_put(struct folio *folio)
+{
+	___folio_put(folio, false);
 }
 EXPORT_SYMBOL(__folio_put);
 
+void __folio_put_zeroed(struct folio *folio)
+{
+	___folio_put(folio, true);
+}
+EXPORT_SYMBOL(__folio_put_zeroed);
+
 typedef void (*move_fn_t)(struct lruvec *lruvec, struct folio *folio);
 
 static void lru_add(struct lruvec *lruvec, struct folio *folio)
-- 
MST


