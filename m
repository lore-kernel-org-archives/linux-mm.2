Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22D7CCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:06:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E0388E0013; Wed, 27 Aug 2025 18:06:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B1068E0001; Wed, 27 Aug 2025 18:06:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C7878E0013; Wed, 27 Aug 2025 18:06:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7688E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:06:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 156B7140892
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:06:56 +0000 (UTC)
X-FDA: 83823923232.24.25A621D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 312482000D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:06:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H6ikshVo;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6MroGOug632a51ffxPVHU3ATCsOwaa4b3tJ1MTGryys=;
	b=AwetZ+SsDXHt0CjhMrN6fohdwU6og+OTCdrRu/g4gngtOz0NzQn/FDNVUie4ZrhTvk9kPF
	pHhIx9Owr+gGKAuX+gw8jkK9+DYLlnxkgpMtM2ty73zeLmsTNIt14DmUBgFlhliyMr1mkP
	nkGX/FZFYit8x6KqC/1XchjM1c679As=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332414; a=rsa-sha256;
	cv=none;
	b=SWvuKQwo2P6L+rbTDEukf9/+PGPiXY1PFiMiZ+cSlTxr4pF0lKBXkl6PwPnaoArcNkD7Ug
	oZ12qZaWBdS7NvVUF1DF2sXeGldAJ+9kTwsGvkkg6Zbs4KrdtniKkIPI/qcaIf5jb2fO46
	qKOwxXEcAZX+o92KXxVQkzUKo2i2tSM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H6ikshVo;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6MroGOug632a51ffxPVHU3ATCsOwaa4b3tJ1MTGryys=;
	b=H6ikshVocCN9ovfDDNAd34H4MNLOjAcK+d61ojQBlU1vR5uP9OdzxqUkAHRO3eiey0ECkJ
	i0KxSVULsQ9Y9X9+OIc1Nr+SClgv2Fc5JVJb68qzgr8DAlaXv7eB2nvg/msgaMVCu2DkvF
	dVSm9oWy9knpHSI9RmLiJo/EAMYY9q0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-556-a2F6JvbVP--8yuHhX8WRDg-1; Wed,
 27 Aug 2025 18:06:50 -0400
X-MC-Unique: a2F6JvbVP--8yuHhX8WRDg-1
X-Mimecast-MFC-AGG-ID: a2F6JvbVP--8yuHhX8WRDg_1756332405
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2834019541AC;
	Wed, 27 Aug 2025 22:06:45 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8C0E530001A1;
	Wed, 27 Aug 2025 22:06:29 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v1 16/36] fs: hugetlbfs: cleanup folio in adjust_range_hwpoison()
Date: Thu, 28 Aug 2025 00:01:20 +0200
Message-ID: <20250827220141.262669-17-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 312482000D
X-Stat-Signature: 8muikcg7814b57qaqz9nah74kasu9dnp
X-HE-Tag: 1756332414-499227
X-HE-Meta: U2FsdGVkX19wMBs6dpSqxpNrsWXLMvq9OJpA0IirJJlRq66lsTJoHhN6WrKZIY40h4htqyaFA6JM6IC2UoeEsEDHNDML/QrloYyqsWWxrHn8qUXfCqrrm+DcznjaKD5gODXjIv2WbrTuMdc3m+ZH+ig7deEPeAkxMp9omqpiPgVaiU8P4ay3DxXWdlJgmH+OQzykIqZNTUdNsUVGtCbnNF+Rm1JNF1Re4nY6ZENSDTScQexM/V/92WY/yWrr3kmQAD/Y8tLz0kF7ANZqywM23+TYAxQtvPalIuE0MjvTjoub+4gaiQzo3hr/xob2QXsIA2WVNSKR0FoVtyaNZQrCGZSHFlg3Xe9D3jv+tBdNV9CGqTkGoEcjMXTj78HKu+UF6yvKmsmH4cgVpz5bgCxfxqW9j5aX9/2PaIazRy3L2HEB0nD1fcXIC80oopjq+hhJFptYmArYZrGhwxTQf1QKb6NDF8ffQ/gHg8QIrzns/S7cUhj/FgBraK5/uZzIHAAsT7zWwMIO83CfkUZQo775pwXmDlEiEz0/RLRNwb/go0ddV6HsqY+tQJ0WQbk4cVtv44AkYL3DVjfI3XbQphD3b6k52hlgLJzyAN97huZ2vZ4nEd2QOL6jRk70wItworTaf3kIT4/+Ep9IPeHQCs8Wga8Ivijy/tn5KkgQWL5DshVwh7hiu9PnB7zK1ylyWp2Bu22IXWwpYeufqHc4M0gIu1UZJpe3hOeWN7Hn4qqezsdNUCHR8zWW0dU1nUaXferZMkgdy0WoZAEdNZHsJWf545LFyuRhq36IxH6J/Zfg5o5+lhEnfKL31LZ1cABpqwWwW5FGimKdMpDaCgSfM4fwZJDbBGpFTan4ouau/Sk5QiWr0EJghA5TLlMW9xBO/rDxTwV3z8+Xh0ueKW1tiRvzlpFh790q9CEd/XeHwqwhz0NQ4M/+z4loAG3dn/4eCTkMamu0zMR7DqtTbXtFB1b
 +RmMGNPu
 ZMv7M/BJtUD+WvdnGb7YX3/Ng9OESjVLWpEc7tHvVwh2YNm3tTOvaUgnj+6iG38+K9GDd9tyqvahjPi3mJ07z4kh28G7AGdllWv5FGTFM9waCXm9JCgEhOckV3FyNKYyLpQySiIo5UDsUL0zlyJcphZsdvq21MyaOJG/OCyI6+r1ZldKjMMRkEXOZXYRdqxQuUNMEg1tOdcRxE+qwujdbKWADKJOkn5pFLiPOYj8UTg/HaffGcKN7o0YA8hw70z37zG4/K1d/o+McdHG0RVEJXEbADF6U4f9NCyHCjeIHbJxh4nlfX6uIugheRxeZY114Ep0MVRhCr6syYOzAm+Rj62SU/lFkdhkbDJXH0+Kci/2kCk490RNv9XjpIJGFjtiNBt87
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's cleanup and simplify the function a bit.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 fs/hugetlbfs/inode.c | 33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index c5a46d10afaa0..6ca1f6b45c1e5 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -198,31 +198,20 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
 		size_t bytes)
 {
-	struct page *page;
-	size_t n = 0;
-	size_t res = 0;
-
-	/* First page to start the loop. */
-	page = folio_page(folio, offset / PAGE_SIZE);
-	offset %= PAGE_SIZE;
-	while (1) {
-		if (is_raw_hwpoison_page_in_hugepage(page))
-			break;
+	struct page *page = folio_page(folio, offset / PAGE_SIZE);
+	size_t safe_bytes;
+
+	if (is_raw_hwpoison_page_in_hugepage(page))
+		return 0;
+	/* Safe to read the remaining bytes in this page. */
+	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
+	page++;
 
-		/* Safe to read n bytes without touching HWPOISON subpage. */
-		n = min(bytes, (size_t)PAGE_SIZE - offset);
-		res += n;
-		bytes -= n;
-		if (!bytes || !n)
+	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)
+		if (is_raw_hwpoison_page_in_hugepage(page))
 			break;
-		offset += n;
-		if (offset == PAGE_SIZE) {
-			page++;
-			offset = 0;
-		}
-	}
 
-	return res;
+	return min(safe_bytes, bytes);
 }
 
 /*
-- 
2.50.1


