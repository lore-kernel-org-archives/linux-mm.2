Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 359D2CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A0A76B0108; Mon, 11 May 2026 05:04:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 977C66B010A; Mon, 11 May 2026 05:04:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 866626B010B; Mon, 11 May 2026 05:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 75B006B0108
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:04:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 43F4C1C131F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:04:31 +0000 (UTC)
X-FDA: 84754553142.21.83F798C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id F23AD40012
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:04:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CFWVFP3t;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gBKqj2O9gjX/tz0GTabH1SzaDOD5jZb/zvIFduhmeuI=;
	b=5j1sJwHx19vV1I9uB2egyamZ4pVvVwKw5Z/jjWiozI0V5y/qJmhJrszYOQ87OnffkDZqLO
	7muTfBXxAZCY8Zycvdpj5PfbUvzMhwOu/9fApHsqRfv68axSA1P7evFUd/TJlDeUa09bTz
	AzDcf8gb4JkDMCNtvUsSZCyVau4CH6g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CFWVFP3t;
	spf=pass (imf27.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490269; a=rsa-sha256;
	cv=none;
	b=EO2kJ9P8Uf4A1R24iU90kPhzVspNOZAgeHAx4pg8axWl2um+Ey2/TGnDsqh+0Ju9+cJxLm
	bFTu6Gxay/MvS7dCiLWexBNrb/tgRV3ewV8MMMRYzERdOOZny5VdbpjSwqYJ/3d7xx5ASZ
	YZTQgpMlNK7ecdcRatYlN9YKN5yLhM8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gBKqj2O9gjX/tz0GTabH1SzaDOD5jZb/zvIFduhmeuI=;
	b=CFWVFP3tyW9yOLtjMOVVGqHAJ4QWm1faDpPalLjrhSuj5bNE3NHvX21c1BgnyRhrBBaSIQ
	Mnydn8aq8PR0njph8MKb0a4sl/l/U7rSCKnGvAJ6s5hNfqNd0ELk46E4tJq9PPQthytXPb
	Sc4f9q3+A5rdjz4ebtwQarIEB0gEGkQ=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-EMplLWqnM1G9zhaxfnD3Jw-1; Mon, 11 May 2026 05:04:27 -0400
X-MC-Unique: EMplLWqnM1G9zhaxfnD3Jw-1
X-Mimecast-MFC-AGG-ID: EMplLWqnM1G9zhaxfnD3Jw_1778490266
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48a589c7879so38759725e9.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:04:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490266; x=1779095066;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gBKqj2O9gjX/tz0GTabH1SzaDOD5jZb/zvIFduhmeuI=;
        b=BUo2YmcOae1beAsOHnExMcyxaSgHn8yoCv2SMTNOgGClX2Ae0iiEeepoAW1oqxI5Ih
         h1vrORWpC6jVMOJeADx+tXn/1njA/4CY1OzepPgIEMg9gfoUgqzaF2A7TCO8Gcs9fOmY
         I25j7hZ5MZhNo2deomPnCz/q3VELWRedDg1U+l2mgoGfqYp4C2EFwIuMjItM0LrNOur8
         SsppEXsdzaZN8ww0VrbPiFbGxWu6vgLshTdd+ELwSLAk9JJbDWNeoxNIO5Ls0aOsScKS
         XKLAUAt3FXjdj9arMy3oHbkB/TReoKDSU6KG2O6WDFtownJNvLUpTdQPMMe2uOSRFc/s
         +DWA==
X-Forwarded-Encrypted: i=1; AFNElJ98EQhggGFQOzckqj6Es9pij5OAjJ9Vo+wepbHylQHUfC1ClVjhEUFxxAGmbEPtvpRLbjcRpJIYRw==@kvack.org
X-Gm-Message-State: AOJu0YwB9bostMMLmfTL5nRazZ8Tvj5YJu5npL1Foa3zqAA+Fo8GkqLr
	yNqOEmt2NcaDCm/zlgt8vlmboQwGD4fNbEjthJszp0et0p2Wvgx3Gv0SfdjdQQ+QGPYmYf6uPQo
	hUe3vmV8GG786YwLntsWMJV16e+HPunnOoIU6QC32yKgUPWghO7Zu
X-Gm-Gg: Acq92OGpcqmydZ8XOwVERqMtYqwh7E0M2vE8Lp14OfBKRKR+JslSu30GsPNQmdYGQf8
	RO1IjSjud9lFAsHlWSd/QTjmu+dipknIIeQBf2kVgHq6ahd48g8OOTnycXimgQ1pDFvd9y+wzJE
	H7Ah1GgOvSZwgU5lJeYjQEGuFu4b6jAFIJ+s7ksupGpRZjczUrSNYUva8iPmuPq9RTZRkbJd6QN
	byMM61w1ePJdDp9PcUey2UhEIQuohPWqx0cVciooN5v+AAv9DbdXK+4O6Jo/BcC1z2lVI76yP7E
	zhxusiRKiayDlPYTK7U9gyHCK1KReLI7xlJV2767n7asTHqYVwrWvDcaPhK7JW5/Q7GpNn39pKN
	bH8yoSYPbwaJuMaCPrW+DCDaS0lAZ0l3UbnKW4G3M
X-Received: by 2002:a05:600c:3b8f:b0:48a:79d8:a8d6 with SMTP id 5b1f17b1804b1-48e642deefamr226935095e9.7.1778490265524;
        Mon, 11 May 2026 02:04:25 -0700 (PDT)
X-Received: by 2002:a05:600c:3b8f:b0:48a:79d8:a8d6 with SMTP id 5b1f17b1804b1-48e642deefamr226934275e9.7.1778490264756;
        Mon, 11 May 2026 02:04:24 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e80ca2666sm91672175e9.10.2026.05.11.02.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:04:24 -0700 (PDT)
Date: Mon, 11 May 2026 05:04:19 -0400
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
	"Liam R. Howlett" <liam@infradead.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH resend v6 28/30] mm: add put_page_zeroed and folio_put_zeroed
Message-ID: <450465e4a03e63381a4bb8a1799a25859d7fdd83.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: u0IeGv5ZFZsFGNu6ejzNEG4XDmece3rD0QrxGG9uOEg_1778490266
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: F23AD40012
X-Rspamd-Server: rspam06
X-Stat-Signature: x6m7ubmptjj4q9a7xt6f7zkjzgfcf3h1
X-HE-Tag: 1778490268-242549
X-HE-Meta: U2FsdGVkX1+aO+HWe+Licj2YT/svdmeuROU6lpzwGjkxbegdv/5XMMDDS6Nsf8+kPuzvmBSKcq7eAWU5sGDiV/FhWSFMFwIiXwpN8BXv+iuzsQjxyRuUJCdpZKznaFymAY+R6qXAdWoWNvE0MXNYyjwCOS1bQbbK6S2rzGQiy9Tm6S4r3D/iwCBnN0gxOF0MWavQcWmpQINdE4K5UWTS2nuuQUL+Z5SR5vgRpyNt7/i3yWoIocY4YY28v/6gI8GzIoZ34kY3iFbOG/v7tUs7Cm611+O1R+xZ0mVzb49I35tn8A5l2JzZxyvlba9bIbc3v/dUAu7ZrwUcH70W/5deG3iNWqksaRMQrGDxl/ImR8Oe8hDQukgMVq6DlIvJK4v4YytryHT2l3gGJPmZVZ+ObHojvtC1M7V6jEe7NmQZwOQuoEWO9EbBzFjWPhgepWLBcXWhmeqyY8Q0EGbdmQYuaG5NjBkT/NDWpSfVI2KiuioGCUj0NSfeO2URS+WXOnsQEXSqkbuHbal7rOeMRopxuJMoVL/skTxxvvEphyadRS41pgnRdfizbvRway6FNyZ73Rydos8o3ESBRG9o4k/CZgOgKtjGDXogEdQbwR0YiCQFxFlo73jBNTf6WN6E4YR+7Yz4yDQ1EfmvYiJh0anZyoWrbb//ReoDZAtiY0sVt2geiWjFbIsLvni9BZwtfKrTz9rPHWzceVUIzTh38euHREDMOD2Byr/GPBMXHJzHogLbdj5lpqLWpmXvff4AoRl4AuLt4fYrOFw5FnDCSn5XjpnPEJpUGdu1/eoWnelMfLn868i2rmUP2alr6FDSSsThRPOQL0CeNAbGQWHcr0vOBgj7lIDv2T0vVEG2J57maDa0jhsgSa765jOcfFf5XxQOjJE10MUPYRsuwjarojRWXGkJ22uPOYwltkWXO4FIzpOBVEGgAr0/LoDkSNSpO8ileYvp8TtRict47dt9110
 8yG3WvOs
 M8R+V7gkvg8sy9tqcVuQUB9G8I14sfng3n2NTV62pp7udeXHI43fcUVXNhiR0CQByL5x5wlJlH6vCxyM5ht4N0Ttz5bkk31eENLKczZNgyxPzeP5YOkpXuGh7y9A52rGUVNdlbt/RUYmrAqkjEAI7oKvIslQHP1ne2O9/xO/iHh7k44puoX2qcTioqoZkxKZ+Yk3H3EirpXjB+bJo7EBSv6qXzc+0cCIcCeKkYnd4zpOqCtuu9RK5zf+Y8vsiS6snoOEAFeb44p4kBEDSeZEUPnCBgOUFq6aHlaSbv/poy2nP7BoQYMZtVPsVEY7Xt4I7fKljtNuBXfCzHa1ZJUDqL4aRrPS5yVEyw+TQ+2KZrK4eyY/XhbDCwio8R4QdFOL1W4C82Rk5Hpt6DhPfHIPcBfrXC0rGj97pyquRXasq7EnZHh+sc27gl2XxqTKqgi4dARqL4kq9MriLlz3iTvABilsygsJEc4UNw5Po
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


