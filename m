Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F3F3CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:06:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBADD8E0011; Wed, 27 Aug 2025 18:06:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92958E0001; Wed, 27 Aug 2025 18:06:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80978E0011; Wed, 27 Aug 2025 18:06:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 924CE8E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:06:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A6CD1408B1
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:06:28 +0000 (UTC)
X-FDA: 83823922056.14.F2A8A0F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 989551C0003
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:06:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PoXHJwEz;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TaqjYk7qiFpFT4dP16wKMuC8fiQfbkUwRRgQVKGzHC8=;
	b=fFB/tTSxeNLzn924ebXQz3Z8V2QHEkdS9e0QquFBHTVM9CE04iKzGr55odPzOrYK5jBAz5
	6263zpn+sglmd0r2MhmDWNz61BUVKAmcaGSCwJ/acKx2l5QBWyRfAvfwfmzDTX+AVtUnWN
	j12QQJfbWpTRrYdcrCddYw6qYavd+iw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PoXHJwEz;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332386; a=rsa-sha256;
	cv=none;
	b=e6ehoqe2ByeX+eB9tXO/nVAACGm6SC4jzpWuvHx2KLahJs7k5/UNtupAo5f/7Gq2dNUvmE
	wZslLCtrZkoBwKKjhIeht6mEcyc98xl00Sf8SjDj4bgtF5wUQ021OV+RN8rUCV9qWTeGNc
	JUrmPbd3ZLV+3aEPFgdd8WjdZ3+1CKs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TaqjYk7qiFpFT4dP16wKMuC8fiQfbkUwRRgQVKGzHC8=;
	b=PoXHJwEzk7w2QrZiRN5qwswFGzO4Fur9KbS2Pq0kw3vH+sjIV8DfkOy5vjMjGF3DFFk/9W
	FyvaBZ7ulBVM5XZsqIJ30EIBKMC296H30G5XkHH0wvHUb/ZgeCZY1AU/dMk8X2bD1PaLfS
	XxcbE1lvXXaONrNyGeeCHMcoMU3rGME=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-154-990HNXa9P7CWji11STEtIQ-1; Wed,
 27 Aug 2025 18:06:21 -0400
X-MC-Unique: 990HNXa9P7CWji11STEtIQ-1
X-Mimecast-MFC-AGG-ID: 990HNXa9P7CWji11STEtIQ_1756332373
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36F19180028E;
	Wed, 27 Aug 2025 22:06:13 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B193D30001A1;
	Wed, 27 Aug 2025 22:05:57 +0000 (UTC)
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
Subject: [PATCH v1 14/36] mm/mm/percpu-km: drop nth_page() usage within single allocation
Date: Thu, 28 Aug 2025 00:01:18 +0200
Message-ID: <20250827220141.262669-15-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Stat-Signature: akauxyrasxi8wwcp6mdtr8icwwy5hwp7
X-Rspam-User: 
X-Rspamd-Queue-Id: 989551C0003
X-Rspamd-Server: rspam05
X-HE-Tag: 1756332386-962224
X-HE-Meta: U2FsdGVkX1+yDx4U0oOjoO9SB4iGHki5d8xGa4KwBwsY1dVawE0V3h6SJIlwDaXZ5xpwjCEOXC8APmhMKSI6yJFPPfdCtYBVBav/yhOa1WmRQ+I0043D5+OMINl/yRkXrkDYT57VNenPGkmnUxyydR1Mfw0JmBTLeJxy0ORoXP9zSz731CQbyd/KqaQql6smyPaUF3joZbRuzypA21YvBchlPB1e72XIdb3h/E/Q7Y+awKbhSifazDs2I2saWd4SXAsL4kG0WPvR85wqQaVkf1f4vLTq1uFN1SP2MDcxhhO6+GnLhcQom9gmv7afEamu0CmtVla1MitPowQxV3IOPxtLrFMBb+g2ci/l8go593hxmQ6zs9GqD/Rg2B1yLzISjHGE4+h+PhjmeUxfCJ7fjEF4Yl1k2ajIz9bpA9THhfZb/6iJm7pwZ0stb1eek84vq8e1vI09znnaoJwzDZQ7xue69IB79/3EE18MUrWhDTi9lIkkSxzCouj5UZeb6j1FHiTUP5pnWACREwx0Gqt9YuCkkd7/sVz1FvoaqO1OnWT4YANRB0c4h+sQF5jOw4fqefwOzwy8wnA7dIFtIE6i99KV9mvAAmbXrLUg3IddH+Yt6B7Pmh4s/5OcP1HmNAeovPx/vCpVINzVVZY2NDBR7QBKYhb8jIdscivOYZsBda4S6rX6BkbN7QNQldln+zvqjJlj/SQBdGo7UtN4vTxPbNrQVOi69oFHc0iB94iRzOvD6kflHtSHEt6HzW4gj2/sCagchQ0p+a8P53hFOWqM5vxFsSol3I7Ngqd33RgUVbBeq9IPRQIp/ZBs6G+lnQMoZRJPPPjniR8RdNtD97Hm8atL6KV1d/4+JXNIUvAmcNV6g5nzxxK3I3bBdaNLGOPuF9iBFTc1rmyoMd+OnrIzDLPE3igd15KdNXvmoZPV4PVWUGsWmW3LBfM74OcXP9xM1o9c3VH8BP8PUIwRy2A
 bnSuS0aH
 t4bVNuGurIe5vL9MK4hkHky4EUMIk9YSBlTMo9m3ol2YrdMKRrzxmjYW5NGjnMLNWNPv4onkVbM2yCNFdPHpuzirjxV7EbvBtkMgr/eL96kQDFgwqaxaVyb/izC6YIFBlGgTKVdhN9bZZUJRteB+oTQAnv9v97JxwIj58dwA6d8LEGKIG9N5ESzWNmMEtF7ddio8wpqqGlaVonDOcUXwpStdjNVQvJax0FN3y1Vx++aiCjrNNh9vAmrdZbEDADMEy1pTWdBpjSPQuLrUCwUZ5in1Rd/h+IgbcFhf+YOxnjrTI7JQ7tHHIz6zSMJ+1pWaKPpHCLWC+jYvR3M7ifFOiAmnLOF2TH3obUbcNd/jLnhGTB4Ywdglj+xnMrVw0kLP+5Q/QANQ46pGFEu903JcLkonWEe36U/3oo5IKmuquHgX3mXKwPfFhmZkUxTvb77RrRMllx+h7CNcz9ukEjXgh1o4YEzzhADwA3fjiOoru6XBk0HCewUtuW6p/OIHwrwbz4sdI5zfL1+TDyvbtGLFeq5xm2Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We're allocating a higher-order page from the buddy. For these pages
(that are guaranteed to not exceed a single memory section) there is no
need to use nth_page().

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/percpu-km.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu-km.c b/mm/percpu-km.c
index fe31aa19db81a..4efa74a495cb6 100644
--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -69,7 +69,7 @@ static struct pcpu_chunk *pcpu_create_chunk(gfp_t gfp)
 	}
 
 	for (i = 0; i < nr_pages; i++)
-		pcpu_set_page_chunk(nth_page(pages, i), chunk);
+		pcpu_set_page_chunk(pages + i, chunk);
 
 	chunk->data = pages;
 	chunk->base_addr = page_address(pages);
-- 
2.50.1


