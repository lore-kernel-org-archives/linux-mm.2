Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A105FCD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:25:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 118F96B0101; Fri, 29 May 2026 11:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F1A16B0102; Fri, 29 May 2026 11:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F228C6B0103; Fri, 29 May 2026 11:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E36546B0101
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:25:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A69338BDD2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:25:30 +0000 (UTC)
X-FDA: 84820831620.06.B65A630
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7246A40011
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:25:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W5505X6z;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RfirkbM5TmZ61fE0cxqW40X8dDTC2oX5xU5kp1FvlUs=;
	b=Nl7QfueG++vuJMMys4PsaBmrdGaYOrJamoIBYgna0tP7HUjgSFWMVQJXuaqsFtBkbxbYLb
	SavaZ+XZg7f5awG6cEEYge39hxgAnQOoJFN1uVYLl2u3RiGFdMYmIx3qCamb4pbl7p5Vfo
	IXxq5kHA9KM9R8h2JRkex8sMQAz23GU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W5505X6z;
	spf=pass (imf04.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068328; a=rsa-sha256;
	cv=none;
	b=AOXTPXz2zyv6id/6CYsH3k9/V/AdEekrQEsFwKWgqzmSeqfxy7REF7/SReEpKHAo3cS3e4
	MzMYDhxd1AS2G5jjqFphd1CXYYr8Zq5FWz4GecgP1taQOWt1dQAlADn3o3D/JKsU3lfhdS
	SwsvC11IFhPl98MGBP1iCLSp2E7h+UA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RfirkbM5TmZ61fE0cxqW40X8dDTC2oX5xU5kp1FvlUs=;
	b=W5505X6zwgfGQLPtKjvIjnYz0RXTf0Tth1m1ZU66pTROn41CzCqtkmZHFPdpNkyP/GpreA
	dIeEXIC+Pe0njiM5P8iLW/q3cTjPNdXdFr37CEiuzO66V0mznnJ7mzWONQdBXwS5Gbw7zq
	51wfFqEMZ4/pX3JNz/JUF1o2QB0nMWE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-599-B3isqTmTNN6td94r4nBYOA-1; Fri, 29 May 2026 11:25:26 -0400
X-MC-Unique: B3isqTmTNN6td94r4nBYOA-1
X-Mimecast-MFC-AGG-ID: B3isqTmTNN6td94r4nBYOA_1780068325
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-45ef6417092so186646f8f.2
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:25:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068325; x=1780673125;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RfirkbM5TmZ61fE0cxqW40X8dDTC2oX5xU5kp1FvlUs=;
        b=XEWa8IgezvAzG7dZItFNjwMqGYgUVoTXnbN8kZCW9IRjrhHHPvd9yWSS2z/KhdK6z+
         iodeyiCQSod9ZwG7Wpnp9W+9Ed3K0CQU5IDUZHt4Wn+NURdYQ6teRg0zV3tqq+3JaMYE
         y0d08bvymQeX7QHgBHZf4ns/xNupX5u4zKorQ1R0AywMdiiXhjiz1SKwoeLgR5xE75c1
         Rqp2SwOmcQ3h7g4dE7nOy8A29L/U91T4lG6/TcF/KqzbCOOwIoz8vBjCeFRoT2QCdviK
         tP2lbMyf4u4E+WPNmRflUzTRwCKjHb8QeIdXGM8npDww7KiqX3SEAo9oorwVtYY8Go85
         MH/A==
X-Forwarded-Encrypted: i=1; AFNElJ9L9h5M1PckaYmobHGsdVDy7HpH5SGbnf4NYMZtqXr0qUjf1J/FllPg/0lFazwg5SGfeYkd/lUuoQ==@kvack.org
X-Gm-Message-State: AOJu0YxMl/aeNM3f0IkqzwOJwsCcTriJN3AcbebjJ6duCx0O3qKnuhIV
	aSAkUz+lixcwyXfwe2kQMrmY/uNInIJmztsePiimH90yu9qR6gw8TEWL0+zin8HByOrRPs82Y/T
	eucNARWVtKKM8lQdXugvM6j7mTzP8EJO2zX6iVHIZJ2jw+I2Z+oZz
X-Gm-Gg: Acq92OFaO+ic/d5ZgTCodHEwoQ5VGPnh2RXbFlylB/6xrlR+K1Rf+fxFZMZMSFFbZ8P
	h9dD8VI7fGGSMPn7pwWYCAflLRO9vdeW52enMef/uPTOr9vTVugdZ8gqC5RZA5fWyA/+emzN92q
	2Tk5aY1JgqNOkwKUPxAxrhq45y31VRCGFghfEVdNGdAaNeQZ/fZv3gsuXKZdVPvj7pfd1p67Fw2
	VUKt8eTqPpN7qGFf9OlNMxHFGz1t79wXLNl/OatvzNSgExgXlu/a7diwT4e9bjfSWwhsiVNX9Rg
	me7dR3PLmXfB/kciuPfnMHtry62Ks1I5Y9UG+69yo47KmotcPsGbOXppPbWZMaZp0qZJ1gDZaJg
	dfq1q3Z41tILoAN059ACvzD9Ras58M4gK9M25lFZ+xGpF1f7b/5aFJA==
X-Received: by 2002:a05:600c:450d:b0:490:778:4fe4 with SMTP id 5b1f17b1804b1-490a2952091mr1218155e9.26.1780068325265;
        Fri, 29 May 2026 08:25:25 -0700 (PDT)
X-Received: by 2002:a05:600c:450d:b0:490:778:4fe4 with SMTP id 5b1f17b1804b1-490a2952091mr1217355e9.26.1780068324663;
        Fri, 29 May 2026 08:25:24 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef34b7d6bsm4731601f8f.10.2026.05.29.08.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:25:24 -0700 (PDT)
Date: Fri, 29 May 2026 11:25:19 -0400
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
Subject: [PATCH v9 35/37] mm: add put_page_zeroed and folio_put_zeroed
Message-ID: <343a0d61f4b597791e3ebd16dffc5b91a0d733e0.1780067978.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: k90KHf-0TtgoDTSrd6fYVSgDkK9SVi4Lw1OsXgxn--s_1780068325
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: wsq3my6oesozayxscy3u7g4owaqaqfik
X-Rspamd-Queue-Id: 7246A40011
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780068328-305846
X-HE-Meta: U2FsdGVkX195I0AwbJQMJG0Pk/pkHNXQrmqORjLp1C8Gjq7+uNaHYMJ3O+ZjuRgGcnWfmWm0v9KlTXkpMu9WdRsjY7lOXXtLZ+stsyOT9M1JaMdRZpZzsdwSMtP4IxkJ2nFCUCqefrA8aQtQ8fV9wkNBjCkOuh9SPpjqnbBOLGYd/bmmTfSMXmQLE6RhWQ481ShSh6tgsk48SZ9ag8TbN3yCX3JZ9ZcHx3/JuhOSvIIrY37unniUwOPrWj8Y71ow9RkOrhCcT75ItD34TOrDuv5Nfom2spFEBLi2JrUeljKVrVDH4Hag1Qd7AVrHz7GggDITWqpyOl3fcnhH8AQnQXnwrQsRdPp1AiZUww4p19zI7Z40ujYv1bTALJabygTBT9213CiTkHua4Tcd6oRH052SvQAHkpr9HLLor4wau7YYmII0frC0f9gDJuZx5TX2ZorzcMQe0PQIoapGqRGkzhk9QT/6p7QMtLl0MKCIv9TpqFcV3o3XDRzIQckvIaJw0YSi765Pw3GGwh0qOPBxQeoKaECqmR8Fjm5LmobDRJnK5Q5i/m+Y2UQAe0BwFnGC2nsV1olN9fRNFfBFetqKs3by6e4XfxvKcLU4ZO7fpgXFjXY1IXNwswWzpkTuK1XwzMYWHz+ukSV6mM66OuCfUGbKB7JKSC3Q8XlyBQyEhPKOeg2wvElvklsSToqR4j9n0LPDvBvXInHik0b+zC95sUZ6nJkwZcMk7YNgUegjcHoG8ug88ZXpCNa9OQF8nFnITCUSDOfNuXOoIDAiJtkoCbZ8OqkHDfzx+1/WTgu9KqUkQd5mVx8rUMLHxRitieH6XNAPJ4WV+7UrbWVGjqODBzIrkGnyj7dljn6MBgOs+XQsY165o1k0PviIsHWKH2bt086VizGpnpQBQDptSmksoYfEfm5iyHlZcjGs7pD7vh0isJVzBy4SiKa4LpkppQUOGL/jZ3xRtcuzwY2G8Mf
 c2c44Xw/
 eyh9dajizNrwma1HlhtoSHtEN/yccS4S1Ukw6ROgwcoPdKR3DJIt5gMfg3KKY4s25LQgoSetHdtMowRSlitT8ZGpL4Y5ipXW/2rtwgtBhL9EdqZ05fuNxQqYDHJBnMLEksB7zLWMgorT+vZyj/JRYeRKpnDzkohnqv7S9z5dNkFRYWit7HzTvVE1u5c3ofnkR9XvZnUWunzYJoo2jJBZqDdlAq5LpXKduA0A9nUgSZ6JloQ9brQQRL5iHaS71JqT4hgqc389UASP32saXh5lf73tlWpnhH6sOawKRZnoQxzHOt3ULF8GIkXcKxMGQUk9uxeBQ+3j+ecCMt03nOx2xfgb1kiYZqalLwIMBMUILhR+xcnEPbrndGrfa/oVGfyqmBgt7eOKnJh8NgvftrY1UJbiEuYzP44I6tJiUnKqGhT3mRz3gbc7QmHPCj3Sw3BkYhpx5zYJeHyGZWvVXKXT9/wInUXlO0bIPk6sP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add put_page_zeroed() / folio_put_zeroed() for callers that hold
a reference to a page known to be zeroed.

If this drops the last reference, the zeroed hint is
propagated to the buddy allocator.  If someone else still holds a
reference, the hint is simply lost - this is best-effort.

This is useful for balloon drivers during deflation: the host
has already zeroed the pages, and the balloon is typically the
sole owner.  But if the page happens to be shared, silently
dropping the hint is safe and avoids the need for callers to
check the refcount.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/mm.h | 13 +++++++++++++
 mm/swap.c          | 20 ++++++++++++++++++--
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d1e768dcda13..86638ffaad01 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1913,6 +1913,7 @@ static inline struct folio *virt_to_folio(const void *x)
 }
 
 void __folio_put(struct folio *folio);
+void __folio_put_zeroed(struct folio *folio);
 
 void split_page(struct page *page, unsigned int order);
 void folio_copy(struct folio *dst, struct folio *src);
@@ -2090,6 +2091,18 @@ static inline void folio_put(struct folio *folio)
 		__folio_put(folio);
 }
 
+/* Caller must be sole owner to guarantee page is still zero */
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
index 5cc44f0de987..ecec780172ad 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -94,13 +94,15 @@ static void page_cache_release(struct folio *folio)
 		lruvec_unlock_irqrestore(lruvec, flags);
 }
 
-void __folio_put(struct folio *folio)
+static void ___folio_put(struct folio *folio, bool zeroed)
 {
+	/* zeroed hint ignored for now, no current user */
 	if (unlikely(folio_is_zone_device(folio))) {
 		free_zone_device_folio(folio);
 		return;
 	}
 
+	/* zeroed hint ignored for now, no current user */
 	if (folio_test_hugetlb(folio)) {
 		free_huge_folio(folio);
 		return;
@@ -109,10 +111,24 @@ void __folio_put(struct folio *folio)
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


