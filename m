Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13420CA0FFB
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:04:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54E646B0026; Wed, 27 Aug 2025 18:04:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 525C86B0098; Wed, 27 Aug 2025 18:04:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414816B0099; Wed, 27 Aug 2025 18:04:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8556B0026
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:04:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B205B5BAFD
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:04:46 +0000 (UTC)
X-FDA: 83823917772.03.FF1AEBA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id C8A8A100017
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:04:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RXbo7jlo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332285; a=rsa-sha256;
	cv=none;
	b=rrbSbqrna/EG+oBq/SvHo+8i4daAeD23UIYKDw/yg3GNnK1kWkpuwhgG+LnsyFi7NeEBMs
	y8VaZLeU7YQ1ysNiIJHTJfZBj7a2BNQgGzbmPIHp8+xylxtwK031NxKcK9xSxNJRCe0+NR
	UpS6LcenS57ecN1MqKFYOOQKmyrhrUE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RXbo7jlo;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPdRkz39C6GEGewoqOPx6e5B77yZ10PZ9TzgCgWDUu8=;
	b=nN90E/CmmvHcEPeYNuPIkN9QewNiMmg+/4o11mI39lC/CMSSh8dggbZSfuLDBsNhPhYwzE
	CCAsOGy7aBXYFUd3n9a42oDY3tX02BER5mkZ0gg6+S0uzsFjo/kW4XqdFV7N8k3B0abDb8
	E0QZ080oMWmFT3F56lUvJc5didbrzqw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IPdRkz39C6GEGewoqOPx6e5B77yZ10PZ9TzgCgWDUu8=;
	b=RXbo7jloDqD6rJfmfSxHdq7ICOTO4EncjNN6NSnwYcfOAcMwpCYeBxwsT2Jx8BudPfxyxv
	8zskoMpajFuLltu1TTZius8qkUk7J7tVdTzexl2ma9WDVlHR/EQ2CTZadlRv7NhVkF+B/A
	qIusWWUfHqXNBrYA78WlHx6pp8CB6ic=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-140-ejq5WAESPvyYJNhJ8vcpMw-1; Wed,
 27 Aug 2025 18:04:41 -0400
X-MC-Unique: ejq5WAESPvyYJNhJ8vcpMw-1
X-Mimecast-MFC-AGG-ID: ejq5WAESPvyYJNhJ8vcpMw_1756332276
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3C407195608E;
	Wed, 27 Aug 2025 22:04:36 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9EB3E30001A1;
	Wed, 27 Aug 2025 22:04:20 +0000 (UTC)
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
Subject: [PATCH v1 08/36] mm/hugetlb: check for unreasonable folio sizes when registering hstate
Date: Thu, 28 Aug 2025 00:01:12 +0200
Message-ID: <20250827220141.262669-9-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: C8A8A100017
X-Stat-Signature: waxnexszgm7cb35famxm5iodq11wiks6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756332284-36295
X-HE-Meta: U2FsdGVkX1/ygURSRDe7qwmd83SLAJa8lARrHxOx9TbypeWaYIqLxd/crUqAH4Rsy7vOTUeAD9gQKneFJis/+ARBf6P6aPSyXlrCpNl+RPotOumhYq5EOEHAK2AVxxyf8TtBQg5pJVxHP1uGagP2VaB/rOp3XM29ZfGG9f7UBWU252HW2jb3e6K4DX32D01q5izUc7oNIXh6o9igkBs4BTk9p1VyDzk8KJbz5wAi+ZdxETm7aJYB9pssBSZASG5G9r2OhJHf5Fj71Oqmei/MKn3pI5mt4ULtN2VoIOZlcTo4EtoktS2MO7soMRp8vLD42+/9KLfHkScWCxWj22x9DXFfrbI5Jud7WbgpAt2sO4QBirxrejYwgWy9sgwpv34t04QKTKrsQQnxAzey0GIxt+MB06ol+m69+rjX2vTGfjPYHm0hxs86PtHMl+AhLIyAaSFqlpaf8EVB7bZaiAMxDuIEBUOhPYoKJMCzFT6j8g+V2MR/loONvEmlYlnAJI2wFNl/NxMoZF8eRRJXNAmyMVuroxJB6KACyfALWbBy4CKEQMtO+x7RfXvB5mWPv0N+eVu+KXL1iWczVO243nRQdsBqrmuOLYZgZijy1mNYXmwpNRiI2rzrn60hYGjwcoskFmTCMO6Cqq8E+MxUM0rOjBrvjsIfjAs3ByPk3S3arU28RZBlKJ157SolYYt0cscVKH8c/oyXoLChMJkdlapRlJGkpQy4S9MD8Yy0xDUIvT/BaZ5r99/YccdvYTQgMvEQtZbA8LmMVLFqp3m2uh4wpvnhCxdtECns+YMhUiBv+U+RJqKRLivdgSpdclqTmVF+qavYQ2Kw1srDzOpwA71IQhduEgRhefSA9J42xTrSJij25TpPVwwtbUTNMB61Db7zWaXKkWhhl7dlCbtgZ0509V3/1SHKFYFfrH22IBtsuuMogLrXQDx4fhQAn7Y24s/YdHeiSFn8dXu4iBLOFWf
 8vX35I4Z
 3jxYDBgkMdeS+HxnlTYY3FR/9rCEdwDqDoCGboWCCDDMz0zOg+/xXjPrzNXH+ZrMQHZlkDwbUbf7zdoMJcwsUtq/viz7zFx85OEhhStxVUJglecOxax6VGGvweammE7FQhmt6bbWdcDCMjXkTLfz9LRvPS6ozvU7PSSCpdfA0oHd7kjxBVfwAr34rH/mjdL8ak/VGhZunvUM1sc/8/9zxgix+5j+Tl9pA2UGzklXwwQz5zBZ1KHppO6rH0qoAYzTMunbYZ0NzFd2iaf2NBVT8mj7L+TyLq9SMASnXFwR47994mm/xDgEA+NSj/h1YkQnvMQ3Dg7O3vM9pSpODkm5yF6TI7S1cw5PVTe9cjz3gWjM5vgO4wDIVbrjlrrvAE9QW/eB2GXrnVviFR5FCKCFEcgfwgt8ETEFVTUij/WkHAi6eERj41GEo2NWWcSs9sx95d0+8kODQnEgN5bjN3QmuiCT/aJaPKmhcdKJPwPV1oJQ3moM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's check that no hstate that corresponds to an unreasonable folio size
is registered by an architecture. If we were to succeed registering, we
could later try allocating an unsupported gigantic folio size.

Further, let's add a BUILD_BUG_ON() for checking that HUGETLB_PAGE_ORDER
is sane at build time. As HUGETLB_PAGE_ORDER is dynamic on powerpc, we have
to use a BUILD_BUG_ON_INVALID() to make it compile.

No existing kernel configuration should be able to trigger this check:
either SPARSEMEM without SPARSEMEM_VMEMMAP cannot be configured or
gigantic folios will not exceed a memory section (the case on sparse).

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/hugetlb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 572b6f7772841..4a97e4f14c0dc 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
 
 	BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
 			__NR_HPAGEFLAGS);
+	BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
 
 	if (!hugepages_supported()) {
 		if (hugetlb_max_hstate || default_hstate_max_huge_pages)
@@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned int order)
 	}
 	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
 	BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
+	WARN_ON(order > MAX_FOLIO_ORDER);
 	h = &hstates[hugetlb_max_hstate++];
 	__mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
 	h->order = order;
-- 
2.50.1


