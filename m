Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E40F4CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:19:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C07178E0082; Mon,  1 Sep 2025 11:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6F38E0024; Mon,  1 Sep 2025 11:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7F838E0082; Mon,  1 Sep 2025 11:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91B0C8E0024
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5AA3C13A8E7
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:09:54 +0000 (UTC)
X-FDA: 83841016308.29.F937D8D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 73B8FA0011
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:09:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PRx8rG0j;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0kDSZHtV88oad9zCDDBj5yf1ZyH7AU8+3y2ZSBVzpUw=;
	b=bJsqFa9PZHnR2YcYe4KaLlCp9RadYj+fbJeALp04N20l8BMKYbev5Ug3V+vdxwNnhqg+h9
	rITTIefiEmex4OO3NAun+3BXqouEljfYcpuXW2ZM9Z5nBSOVNPA1lYhrhmR2QrMv1RY2NV
	n22Uy5WfLgDczcjeoPGWuhhj6pUli/k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PRx8rG0j;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739392; a=rsa-sha256;
	cv=none;
	b=DMhPKeSCkBtGDlqMPXUTO3f6N100/NQGMTtSASbUpEF2FJpKmLppsaAMozrmN5nrzMf+jX
	oUBaTAdGU7EFhcyaMMYBOQB5uxuwZLwkrKJzTvLJRZgWMn9QhHm9hySKyjSmfw1IGzkZ8n
	Wnh7qP1f4nGIUyU7m4e/vDkvKU9IDD8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0kDSZHtV88oad9zCDDBj5yf1ZyH7AU8+3y2ZSBVzpUw=;
	b=PRx8rG0jPA4iBK0wSW702bguC+cLLo5mWLyWqJy18JLdHQYvut4zGW3rUXA4YL/50s2ZCe
	mp+Pu1+Y6Pm6k419aqck4moFyKW4PNoMz4wXo5k5ScUThqv8nDhKizWKT2BDlZvzI4vfHt
	v6SMz+dLE/Wo8WCryHipK72jfPvUuEQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-35-RS9bIdDPOQKXbvnr4BPRbg-1; Mon,
 01 Sep 2025 11:09:48 -0400
X-MC-Unique: RS9bIdDPOQKXbvnr4BPRbg-1
X-Mimecast-MFC-AGG-ID: RS9bIdDPOQKXbvnr4BPRbg_1756739383
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3EB7719560B2;
	Mon,  1 Sep 2025 15:09:43 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 54B441800447;
	Mon,  1 Sep 2025 15:09:28 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
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
Subject: [PATCH v2 20/37] io_uring/zcrx: remove nth_page() usage within folio
Date: Mon,  1 Sep 2025 17:03:41 +0200
Message-ID: <20250901150359.867252-21-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: cpd1w64f3mi9e1hgazq9fx73tinr6rmd
X-Rspam-User: 
X-Rspamd-Queue-Id: 73B8FA0011
X-Rspamd-Server: rspam05
X-HE-Tag: 1756739392-264876
X-HE-Meta: U2FsdGVkX1+aKa4bXI1GGFpd69rdBhvkru8RMSjkYaUZATdnLd3keV+f1fJU6TwGoE46Vij3cXsZRSa5XxPpexLui6mJ+JMnx4x856TvGTLUJZ3xMaZFb9Fybc/kAEjdkJWCeaTqUIQez7nefPNXnhPJ7O0NCqAe08hmyaAZN0dHd7PzyfAWGGVjpGU5vl4o0L2P/tNcf5ig0le16fDZ9KjSoS+zARawvZl82I2/wx3JJfCLbbRCpdla52tjPT8LNolCYb2Q99t4itY6Hqg4gwYy+PHoYR1sZ/VXm+dKO7svqoknVYJ0ucsGneo5Y5n9FWWb+D1xXgkg3kPw0gNQZqR8SaxCSlDnC/PCjrjA4TPLSzIUVz+btnfgUutcNf9QJcX9zlz+ChfMia3ddzcFGBOw3ZLVms3WsyyvPl6jWHLM37P+KafTW02HaMNbEcdrVm3NaoCGCfEX5jRq5DxrsJ/aXzuO1WwDI7MfQCqxg5x/958kidtLmnbdK9yrtKrHewFoUSnVRQIEMFTVYI1XhglDLQGwra67Z2rAWuZAX3xrJbtS2TS9JuULggC7QotCF3jhA0mlTqJdrwQ0b7rXR+RXC3wOya2E9keOUVDAjDk6+8K0rQnh0JHO05jXsZCFe+xJwA0Z5qA6BELbU/kN4ltX4MQfOC1AnqaiU3UKvcEpfPK7jvZyy8uRnQ79LVP9IBxJ1uJq/ZToxQxzeFkofWVrCw8KoxIcCMfBRHbnLaybchObALj5p9WgZe8sg4BiWsD+e/Iv1jYXOdEXrHl24jRrWDgoktdX2Vwi4sLvlrXGfsr3usdQiyTDcHMxbVPOrLARRIMfUkr8y1/CkmFxSbRwT7OAZP6n03Q38BLEQjRU/NIOApEzLrusE+Ux3LgajYBRsKYvUnegWJObR9ebcUQ7diYTJLJ1DVuQz7EdlsQD2XQpxFU+DI7L6S7ev3IScZkWYVoargDBQ7bNgRD
 dXT9FxyJ
 WmpNC4KyLUjGmsd+bBKAbHKzdPhf8wdsDcp2uozASchvd7933p9Ub9YxRcMZRTOMRZlwXKv2FUmotHGvy/0aG2psmweXLWzR2KzDVTbzJ5vrVtHG3CRMzgRrT7Tl+OCMWThx/lQQrR5UlMXsb6DXKDfFwzgKnLamOi1/rp3t0XekuxbgrAnsT5OJ9dBbU6mIDP2/bJ2cd0y2gwEqWzC3GthfecRU+LvPF5ox4RQHsDFGAZKT4DhH5/YiZVS1n8XmpyhWPUUCgRA9h1hKJxycZxCKCbYJd0aCT2uoTNLpqRc5S7iyYH7IPBxj8UWT5sGsaHVcE7w9wBmuOYzKRNnNP52ffXBd/VqB+QBm6e3tYU7o2z88ASr+WcPRlR7wTF+NNkYl0RmIu3/MGc+Jn4onS1xsSwi8gMutDg7gt4/vl3ZfRfjfMkTjHhfDdZJIM2J9R5VWhY9i5EgljHbq53fHzORG/eK7Etup0EHrUoYluZ6lI7XCH5+Dl7bpK/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Within a folio/compound page, nth_page() is no longer required.
Given that we call folio_test_partial_kmap()+kmap_local_page(), the code
would already be problematic if the pages would span multiple folios.

So let's just assume that all src pages belong to a single
folio/compound page and can be iterated ordinarily. The dst page is
currently always a single page, so we're not actually iterating
anything.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 io_uring/zcrx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e5ff49f3425e0..18c12f4b56b6c 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -975,9 +975,9 @@ static ssize_t io_copy_page(struct io_copy_cache *cc, struct page *src_page,
 
 		if (folio_test_partial_kmap(page_folio(dst_page)) ||
 		    folio_test_partial_kmap(page_folio(src_page))) {
-			dst_page = nth_page(dst_page, dst_offset / PAGE_SIZE);
+			dst_page += dst_offset / PAGE_SIZE;
 			dst_offset = offset_in_page(dst_offset);
-			src_page = nth_page(src_page, src_offset / PAGE_SIZE);
+			src_page += src_offset / PAGE_SIZE;
 			src_offset = offset_in_page(src_offset);
 			n = min(PAGE_SIZE - src_offset, PAGE_SIZE - dst_offset);
 			n = min(n, len);
-- 
2.50.1


