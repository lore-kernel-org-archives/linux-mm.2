Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0040DCA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 15:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A09108E0079; Mon,  1 Sep 2025 11:09:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BA7F8E0024; Mon,  1 Sep 2025 11:09:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D0598E0079; Mon,  1 Sep 2025 11:09:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7A2108E0024
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:09:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C3551408F3
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:09:11 +0000 (UTC)
X-FDA: 83841014502.11.8204348
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3712D1C0010
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 15:09:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="J/9jvbTk";
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756739349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=28W0TjP7quFSAyZF0qsh8B2KkVopKfPNU5v7Cs/5Ym0=;
	b=DKLp1guN7AahcEj92MP8k5/FWFNHbEFfLKOIs6TUtzkC5UoUUFv+8wL0WF2Oi8WdkwdKCM
	cISEcdZCQ9M1Y0L1ZB+8ooBqisePt+5SMfVDUNuKXK3lqkiAT927m27ISUZzVmXraSUA9x
	JAOYGMo6UE1WMbHBES9VvmCHdiCY8qg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756739349; a=rsa-sha256;
	cv=none;
	b=5yR3XKMVr8LJhVRJNac5E1yIQu7Duc6RKWDTkXRDJZxvyy/9RdVCYZGHA6AbZd1EfiP5JL
	i+0ycQJYkUSarQRR+pf5UgqRTmoX69Xc6hDGKd8l4qgJ58xuH7CJci2aSdgbVorRlpurpB
	/t4prYKHFN7uVypKUEgWtYLp5dZlNqw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="J/9jvbTk";
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739348;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=28W0TjP7quFSAyZF0qsh8B2KkVopKfPNU5v7Cs/5Ym0=;
	b=J/9jvbTk5VLxiumgC/sn3gRJqrfKQgcnxYrfDtWbLoYw8uKxQeOPD4gI+3y6xkCtoSU2pa
	tDqGKCSLHVgv6JMo6f5c/Nd2/0bV7siLsxrQ090+gLz4b12uMVOBwZycSW++Bi8iujcLN8
	mxDhTRvYBxkNIG3+BJkufZqVZNdD18w=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-367-Xnh8yLGcPFel-NQdQHGKhw-1; Mon,
 01 Sep 2025 11:09:04 -0400
X-MC-Unique: Xnh8yLGcPFel-NQdQHGKhw-1
X-Mimecast-MFC-AGG-ID: Xnh8yLGcPFel-NQdQHGKhw_1756739339
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E757195608B;
	Mon,  1 Sep 2025 15:08:59 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4EC2D1800447;
	Mon,  1 Sep 2025 15:08:44 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH v2 17/37] mm/pagewalk: drop nth_page() usage within folio in folio_walk_start()
Date: Mon,  1 Sep 2025 17:03:38 +0200
Message-ID: <20250901150359.867252-18-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3712D1C0010
X-Stat-Signature: enazhk9r1i1xzajo1rduj4d4rfibd3ja
X-HE-Tag: 1756739349-241093
X-HE-Meta: U2FsdGVkX181NeYAoqGIcV0mIgzD9ihdXNqHO2+G5i98MihMB7A0r5ir27y12kwdvkUOv6XZ+R5r9dDXDb3kUJGO8RZJJVnSmuIb8GNathqKLhY9TV9CgcKw6zNS/3QK+tfhqxcgenu8nOffBJ1cNvNyscjPRN2QWC4tJAD4oh/3STteCfctYgs2BVV5mnwDYotZwK/19372gLFS5c/7JQxK5jgCTsmkG0JcZWvbFFcu8F0IpHFr/4yL7mauv+TEuTWRumvsOEu1QGdk5w0dMU9DFjwIsSr08Ro7JpwZL6+iQrkqVxgt1IbpU7s8emKFlymtuefZfb+MCC4OHq6aJzq5EefkDO+oXrELY40KHjLFRJROxZCLLYiDInojBOqOIW2uyPTlDFvKDyWMAgypZealDpxHhx4roDQY2HRWNvD4+/LrG/deVACrANvL+2YSNM90ZtigKsispZac6g/Xo4xutaFLQSmSef6dieQA61DSRzWB+o0De3rrMebVEgx6O/RNVQh8/99aVjXh/dwP0mHoORu8x+W+RGjgvNKBOmqUy//IrzeKObR+lUsnHz8SkRIK3vDDZqpHL5yQ3kKSqrCkicQaetJ+SUpVYkk9qg/uqg4+QV9sr5n5Qefjw7JD/MS02zIizceLPSij1t3Eb6CTfZNO5PbUp+tnwDaX5O8lipsfjMd5ZxFvGbOTWvygLPYoV50OectjkZpKv2rXJjPnK3niwiE7wntI11o8U+ftfq5lRl/1EU1gPSN1/gCfRyxFmZ/SYr9rsF5TmWvDR2f3HVWRSyqpOySReCI51TOTpAi2psnZbBi/EJqjQI8boRNGjojW+8Edop2n7xV7tXG7V7VWRgJynQDrPQhU0Aj0q6mS02NO0rXlZzDuT89gPWVZbikhzDLiHjLSOpFGSi5/BuYRjgha9IJStNhbglR6sXvw3vWfUUXrZrTC1f04U9GSJWUrH2dfJxkvpio
 gZgEYg9u
 zvCotzWuE/siGZC6saFW6lipNpk63rJU1AotEn1GU/RXs0+pwoSqJ8SVmmZb8g6o7amI81XHBGXvKIT9oM7cmBKnhJhhYL35iFekdMc6QWhKivoGUC1e7XZYPaI2HlRq1KcZ1oRw1KQmmeQJrS9LUSrRlTsy9WiX/+kHO7UvcrrOZrURS5n4/TxqkrTAW2DoeMYTqAic62mGgKfl/19eqOEzLKwHqAlt0o6nksKZztRSCwQK4WxhBJ3BGRPuxkgx5cMSMS1Umnfym9HOUYqtgeAe/Rz+97Fav/APGmKjWBZ7jpGA1YI8Wu+k1IhMj/vhRjspCxLLmcfp3/UaPwFKKfSaRdTR9C2cX/ktdgVrhzdPelGhfvp4eQZNBRw9DRM0ciLyU0xEC6egoB02C+y8aSqDTIw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() within a folio, so let's just
drop the nth_page() in folio_walk_start().

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/pagewalk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index c6753d370ff4e..9e4225e5fcf5c 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -1004,7 +1004,7 @@ struct folio *folio_walk_start(struct folio_walk *fw,
 found:
 	if (expose_page)
 		/* Note: Offset from the mapped page, not the folio start. */
-		fw->page = nth_page(page, (addr & (entry_size - 1)) >> PAGE_SHIFT);
+		fw->page = page + ((addr & (entry_size - 1)) >> PAGE_SHIFT);
 	else
 		fw->page = NULL;
 	fw->ptl = ptl;
-- 
2.50.1


