Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E43E0CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5663B6B00C0; Mon,  8 Jun 2026 04:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 516D66B00C2; Mon,  8 Jun 2026 04:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7576B00C3; Mon,  8 Jun 2026 04:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 297AA6B00C0
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:39:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD5BA930C2
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:39:07 +0000 (UTC)
X-FDA: 84856095534.12.784D867
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 95415140005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:39:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="G/P8iFJm";
	spf=pass (imf09.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907945;
	b=h0roKLz7H9BXvlp6rDGoBAohyIO1F7HqlOd+fo0MaYgMNVLOEUKQB6FZskn/A2vmtfR7hx
	Ym/wxmyaVhW4rMAp0xSvVKoNBMNGFm+F2iLqV1aQpiYghN+d/CAoFjYJ7v9dZXhFHQzPxb
	v6OdKLYfAc8J4UCBnnSoSweC9HItagM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="G/P8iFJm";
	spf=pass (imf09.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DMc8fDrj0D8JcjJ5dRd88tqBSMHmwk7bs26tvZRKcB8=;
	b=bwcGtq3bUWXqOvZiKJcE4A9b5j99AgLOTJvkgqsfMstaxSXaXBAMiTt5aA8T+nUAok0GMK
	BEzbrc4y4z/TSIlcJo/kPY1DsTmFf+ooft4GnWx3ZIGrWw3jvQNacatM3yExcH8Po5OIJF
	VfcB/BuQ3GBB6z+95zh/WCtRWLbwqA0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DMc8fDrj0D8JcjJ5dRd88tqBSMHmwk7bs26tvZRKcB8=;
	b=G/P8iFJmpHhwPUu7PIsX4Rbnw+iUDM3kOfvEvk99IpvcmvZWqde1EpJSZiwCo6EktVS1S+
	hrpQXH7CbZv1NiZ7/yYrAB6S0sSFt/ngtd6saYVfSjBvOFOT79gjLmxb+fWBs+L79y4QMy
	M+/fnlYkI4Z3XRRQNVOeAqFS6o1mbrY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-AF8uiu89PdyINO59MwNHDA-1; Mon, 08 Jun 2026 04:39:03 -0400
X-MC-Unique: AF8uiu89PdyINO59MwNHDA-1
X-Mimecast-MFC-AGG-ID: AF8uiu89PdyINO59MwNHDA_1780907942
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-45eec2badc4so1974133f8f.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:39:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907942; x=1781512742;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DMc8fDrj0D8JcjJ5dRd88tqBSMHmwk7bs26tvZRKcB8=;
        b=RPWS3JdT+pcVH4M0JaDJ4Mz5M+170t6n35wuNf4p+SEdpGt8Z0fYFBlgunvQMQ/yvs
         shqhJGltd+NQOgCeLXAdbUwQ4UAY+LgCBVd7g/7pzYagl1dl5LFdF8YmsS3HgKYSoorZ
         NDDzfwKkaqmpBLA81AXHYVlrzGI92X/2mjaeYwAKYHvZv3o5wILMMUrKXVauSOiXvXQe
         zuwNSWBxqV1dC6sku2U5GyHjWD1cYKrsaIIO3Vppc7uu6lu1MeFEx5O91C/8CoiL0OTf
         sCwzKsRT750/BJ8TFXFLWGpEsYMLL6YoPWusF0JVpw/0oIQffquWKbckkEaHz8XOD5uX
         knvQ==
X-Forwarded-Encrypted: i=1; AFNElJ+8DVrPJhAxsMe9kGjFy0kNJqySiqX98BFvw2tS9Ci24G2RFMiW9vcemAUxh4+ZqHNEnn3C9dRKtw==@kvack.org
X-Gm-Message-State: AOJu0YwMfCiZ6PE8w71LUbRwYcqdBSCS1QUR+IQ1+rLHODDyVZv1Mg3l
	RvTpMxbv4kP+zcIqRhcUvjn+1HDE1pxd4yj9Ozg69K24fi6u+x6nivPcTj85kGYHF+OJriaF8ui
	iW+rfuSRu0ZFF0tWUbLw78IGTwHsAIu4jXUybeYi313QDu3e/SbBY
X-Gm-Gg: Acq92OH4Uv4/xqGv0qfDJnA1Yt+vW1G3DLP1Lvk2c/30NEDqJtO4RAt86fU4LmqCTWe
	cAkx6l1ms/XHf/1G/HrIiakxq222kQkv0MkXOTBzIAgUL2DKBmAxFiXV3hYt3t1+tkrU5WfsDPd
	3drP0j9kUE/bBhqMLfhezo+/BKSrKtkZRDXuxoh0ojzlrxhjSXZdymndmqqSMRVqqajOsYYgTlt
	i8h5ZwqfDsyG0eVaEALH+//RVtWcH1qi9gqCC49i69UHurbDTpbJV927iBBi6BBigJJQ4ZsC5Mp
	qmf8fWrH9xdJe6jZlEaT/JkuOGbo5238yF8ubzYcEXzWy0Xl+0yB5j6MivhnLp47cpDDwJqlFr6
	4OQwNo1pwi9+j3Ozm8NUp11Q=
X-Received: by 2002:a05:600c:5252:b0:490:b2a6:8c1d with SMTP id 5b1f17b1804b1-490c25adb2fmr254958515e9.10.1780907942374;
        Mon, 08 Jun 2026 01:39:02 -0700 (PDT)
X-Received: by 2002:a05:600c:5252:b0:490:b2a6:8c1d with SMTP id 5b1f17b1804b1-490c25adb2fmr254957625e9.10.1780907941897;
        Mon, 08 Jun 2026 01:39:01 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2ed944sm52040479f8f.13.2026.06.08.01.38.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:39:01 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:38:54 -0400
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
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v10 24/37] mm: add put_page_zeroed and folio_put_zeroed
Message-ID: <fef7ca7bbf591865defef658b0792b58494aaed5.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1xtJh5EFbavXpuzh0I5rEU-qipXB1pm1sRHsg9pY8FQ_1780907942
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 95415140005
X-Rspam-User: 
X-Stat-Signature: 96puxwdyxgp8xqwb3qw8opgjsm8zjto1
X-HE-Tag: 1780907945-923214
X-HE-Meta: U2FsdGVkX1/uw/4czV1A1O1EutSnClxdgLm3G2gnGX6Ztspx8bnDxni6FwjvXLFtxYYz9papSx9UcLkZyghVuaqOoBw2AzQih7ca3ViEcUdWBCrz5tC9knqqVIaBlNaVREhyEO4TwA0Av/xvXlOJXvs5dPcrQoe2HB5nvBvuCazAyZhIqjLn7hRcTBp60ChV7pcHQCdkkb1S0IKp+qcZLjV7Bhgx63U3uo285tY0DKVzs5Y1T4ZzLKZgbBP9EcQVJRHtIH8FN1gunNg1Dd5y+1iZU/o8skBtIZwXYVQSk+ASrCNSj2+UpylaKUuS0uc5/s1kMK0XNxCmzGE/UlPSq/7E5ioL/E2AVsnJV44G+ctWwLvWxo94h/1LrwBHLJAbdXVMfrd3Uju096W2WeVerlfrtwmMAEmQsvBN4Be22ytuofCZjsCkkEPf3d2VZxeVHWnFp8LONvzo9DuNcSHsZ1EydCxd7vd8rISkQatTH9+6AyWT+ZO9AWJym0SRAWvSu4lPLrVL/4Ef+hUfC2L6XgsWhGn9iWnCf3ODzaNtxElvLrdsefKuhcO+9HFSI5OGG/5xvMfUYkEjDrCIkooIyXFgxcbho9bSfe0w7DLPYMb0OLBiNM2Eqe1qAZ52FHCoI5UOkJSfG/2M6aq1lpZ7bhrEnLMVYp7l8sTsaClejapezxNOuFPzq1i6OE89D9B6+3XtwHAER/QGTxxS1rUniuogHsl8iM6aB/fQbOTm2tG4P2KdIIEZEE/kDAhwhKBCnHEpUY8t9TdySd0HuicFFH1x7HoE4lBpvmtpAT0tJsgtLCEIrAvdSU6PPxEYlz5wdJKgXxkq2bQLEjHH1H7VC4u1iKv6iRMBg3pOp9pO0HDhgVymtyuqosv0RKK5wFDMb3By3doWcJa3x+QdKb579N4y3d13yK4Y1BZDsCpMEVzcCGSkUz9Ndms/g9enQId60aUy04pSC4vbiuB3A73
 HmlLEhF9
 UlwVQqnii1X0ZoAtKsROmdRHbfqiSTGRXus2yE2W8OmoncqXZ+ieJ8fCTU/yFU0Z8skAGODYj5z6qeuCMlM9xizp7NsFjBnZTm7NS4CRewgmLZKLYSkUEONsazcxBnW9eJzOK+ac25CTbO+oei7g7eIP6n33f9pUYbtCaUXOpb8bgObWLOxwmYK7RcmZDsQur/kt8MWD2R0iXCRI9hDk2LKfU30L6TtKJJq0QWniypCqEmxJelziQoLrTUP/rd1mBieDc/Vts10gR9yV7m4syu8TDR1qrV2EmSxylcq/FeKj5zgfBB4RBdIpFkimJ1sdqWOgirX8738ux+Rrbvn6+FDVdEOJ1CkAMyCn3/LtAfmmhlTYrYGQdP7Jeq/xEyua4BzvFOQbpGpOaAI8DAeoQ0i8VW6HmFHAzo6aotWIouXdGOExezJuOlOCbobxBCm/0WJUX
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

Note: put_page_zeroed uses folio_put_testzero() which only
detects sole ownership at the instant of the atomic decrement.
A concurrent reference holder (e.g. migration) means the hint
is silently lost. This is by design: the zeroed hint is a
performance optimization, not a correctness requirement.
Losing it just means the next allocation re-zeroes the page.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/mm.h | 13 +++++++++++++
 mm/swap.c          | 20 ++++++++++++++++++--
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 06bbe9eba636..79b3a8cb9a3b 100644
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


