Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7BF4CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:05:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 305CE6B0027; Wed, 27 Aug 2025 18:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DD4F6B002A; Wed, 27 Aug 2025 18:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F3A86B0029; Wed, 27 Aug 2025 18:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09F158E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:05:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6CBB84B70
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:05:24 +0000 (UTC)
X-FDA: 83823919368.01.64EFF53
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1A345120008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:05:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aCGmnHbf;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/EwzdzyNFR+ewVEEFqEze2ovwyb82bK+Rce3/V3U0s=;
	b=WWF7eAJu7J9vwAzt/ZBnDYJxZfsJE31XULPUPn5ALhBoSWUrOlD5ogrhXirWR2Sac08fbI
	t/OjRlGHUhZ7CD3QxHYC4A1uethw0fhYrWsIfirF4sJU6PUeDonqu9SlsLLihIm9829hMX
	gH86KNPylKGuGfSIEsfxOFQaSuVJ25I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aCGmnHbf;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332323; a=rsa-sha256;
	cv=none;
	b=ae6QUB1bQdrBsknz0XnTLZuGBlMTMoOgaWrGHbfIlbZEJ5g4QCbHSTM+8bxeCqrY62uzTn
	vN/efh19hwFmrWBUdsZFAS2ayssPGGkLzBmUyFyJR7H6TOXkDW4bMAaUxbJGPFJZg6r5/w
	4lrzSiY08AkoH3xVpBJEbgVOGmL//+w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D/EwzdzyNFR+ewVEEFqEze2ovwyb82bK+Rce3/V3U0s=;
	b=aCGmnHbftK7FYaeMYLlOxTxjR+yN4TJCEHmhfD8JyM3i8aZCgPBp+b91KdZ5PGSNd9rOH3
	0M2JyWY5vT6YIbi23L5ndvzMoqZoqxnumrbiDbWw8bjaXC+w27t78+kwwEJ2AbXWgrqacu
	+WJkuZDqlgelHFNDFJIcQz5tiffY8mE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-319-rAeDOcrbOYu2jFZVlj4BxA-1; Wed,
 27 Aug 2025 18:05:15 -0400
X-MC-Unique: rAeDOcrbOYu2jFZVlj4BxA-1
X-Mimecast-MFC-AGG-ID: rAeDOcrbOYu2jFZVlj4BxA_1756332310
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E3F20180028D;
	Wed, 27 Aug 2025 22:05:09 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CB62530001A1;
	Wed, 27 Aug 2025 22:04:53 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
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
	x86@kernel.org
Subject: [PATCH v1 10/36] mm: sanity-check maximum folio size in folio_set_order()
Date: Thu, 28 Aug 2025 00:01:14 +0200
Message-ID: <20250827220141.262669-11-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Queue-Id: 1A345120008
X-Rspam-User: 
X-Stat-Signature: ho78juzu6auk9erdd4eyimi1eopp5yyg
X-Rspamd-Server: rspam09
X-HE-Tag: 1756332322-505910
X-HE-Meta: U2FsdGVkX1+1+U6jokjIS5Lq2t2iwQNt1YkQyjxQFkshRWybn9S2wFg7aTiM0T/FTqhaiYYbMBM/9/I1eXA8eCKImmo3+8+7YBrmxDN5f+LqZa4FrJIZ8z1PysSOE6z9OS85iVr/kLjbIeEr0yh9iRxKXqE6ZjSV1tdKeaB4UCStQ2WvgYgHQCDN6eu0waq5ErCL4ll+pswfSYvs1fIM0WK6uY/Dto2da1E2/6K9lviGb0hOMOg4H5d9kGlr1FJwWkLVtxycSB7HfQ3sW2ncbbFKZHoGFwcM+33PxEFs2ZHHdNwLahb8WuJDU12J0hWEp3zDNHSk8Thgk9PVex5E701JAvoHYOS8KLTR9t6cOMyw/9MHeka15xEotHb4i85eVd9OyRNfVYzKOfsmE0WV5zxkxX0ehiUBmyc/xnvVLqth56IJBGyTXnNocgAIi0+YpSyf0TXlZUACXwvjPd1kGR7prRQ5sySuhqF+96hayv54Xj40YtkLG4Fz36FVFy9lu598OTdvjU/A9vxnE6gQEoJcg3S6q2K58FnShXMvrg7VMdGMXEBFC8kVHtxiUUNZm3tJMxlV7KjAsQbWY7U+OVRFEJL7oo3Rqh9X5xaVEUvWiRqjvFFWK+KAvgMf2JX+3XAfgbhFkDerLBMlSo0VtoFvDKVdDQ+R6KV5PNV0FKivT5e2jVz4Dg0XUXDpDM60G7O1Fu7m9euBHwgsXvtFShPndd97gLhi0YyzvcQyJXhzjvwulqUXEPirkugqqcQ/Nd/1tZof8osLPPClsL6WhUw+/YT2PrRcgrMwhHUW43pF+rhtdeAnPCCxOnsmVSCPfdEwwWVwW932lZ/M5SCsRxTxpz3QE67MNiWS1WNO6cRNs/b7yzQRwO4THfNVO3tmKWDm/mjjjgBtX4RvkaTmghhyk1pIhojkZlXlchmxt8NwYNg+2SEU2W1X5wDp5uPS+jQe9aYUpCw7L53haJD
 S+9g0RRk
 sbwDD18xZ6hLuwYYDKnbwhUtWzSILNgYqnO7uJ6f9mcNfd1lnKZFpLh0Ci8DsWnKYPAdlbFigxpSj6IT8neuCvXAjiNK1veqkl/V3G55atbcxgiYP1J4YZSa1LAsNbhbQCu5EHC8hBgsRXyznozuByX0HNRjyhIh+NOlWYi65C5iswEfyF2rfEom2olgJmHzy7OdsUDdzSaI3PFfQENWlTc2cmkqOQgOGWrWmF4ZVpwMBHOsKl1dhBzaHMju4b+pZb8oHR3k4gzpFTXz+gHKbDxsDfofY6meCtRLa79P9aQ83FGtnCBF2VXiOBC8d3mc0Kvwx1rRHeyqxeD2gTgjw+xlWx4S3Euc+Km5NkUQFr+5MxHE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's sanity-check in folio_set_order() whether we would be trying to
create a folio with an order that would make it exceed MAX_FOLIO_ORDER.

This will enable the check whenever a folio/compound page is initialized
through prepare_compound_head() / prepare_compound_page().

Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/internal.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/internal.h b/mm/internal.h
index 45da9ff5694f6..9b0129531d004 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -755,6 +755,7 @@ static inline void folio_set_order(struct folio *folio, unsigned int order)
 {
 	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
 		return;
+	VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
 
 	folio->_flags_1 = (folio->_flags_1 & ~0xffUL) | order;
 #ifdef NR_PAGES_IN_LARGE_FOLIO
-- 
2.50.1


