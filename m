Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8830CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 22:07:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43028E0014; Wed, 27 Aug 2025 18:07:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1AB28E0001; Wed, 27 Aug 2025 18:07:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30DA8E0014; Wed, 27 Aug 2025 18:07:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B1AB58E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:07:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7567D5BA9E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:07:12 +0000 (UTC)
X-FDA: 83823923904.23.5C9E157
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id B7C29120006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 22:07:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ftvEY9Qb;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756332430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCvnB/7xI7T/4p4mwWx/D4+W6s//h9G2+oSyfbDOFZs=;
	b=Ez5SsK++8NzcO4EgqbgZ7tmgFN8Uiqfli0Rb62LelV299xcqtaQh3Sg4lFprv72p3Gr5Gl
	js3D/zoMskMOomFehLuRvDy1DRfnJyKZK15GRCO7U2jGKMAHm4EcOPZVaNzPy26xYIh/Th
	3QTPd7sJsej+z3JwV4B4m5IloKZx2EA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ftvEY9Qb;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756332430; a=rsa-sha256;
	cv=none;
	b=3kRh6C0MPwNJHkEjGXPta0wUd17w2sknQRtAgOsL4U4mEut7V2OZAl5huq183UWxvUATsW
	4ANG84bU9dSIKgkmbXHfMTVG1vk++zIyDq3qJv7964dwYTTpWw8+UuQiYHiWDUuWLJ1qdR
	goK9J0y0raUntQBvUCNww+krUQH5MwY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QCvnB/7xI7T/4p4mwWx/D4+W6s//h9G2+oSyfbDOFZs=;
	b=ftvEY9QbbtpEdWEFwA9LZnhZo1kLdEz8iioe4D0O2C7Hz2PdubtD9nFct8FV4nRddsAl+B
	IDwUFzXhynhjn0LWdtAaX5+FC7OmH5RFCWToTiWXFj3ZVDjNLj87ldzjTtI5R4BqJbLLzA
	K6PdnxExzO9KK9evt4bUtsc4/Axt6j4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-82-ClQKmaRWPAKB1M2iEYT62g-1; Wed,
 27 Aug 2025 18:07:06 -0400
X-MC-Unique: ClQKmaRWPAKB1M2iEYT62g-1
X-Mimecast-MFC-AGG-ID: ClQKmaRWPAKB1M2iEYT62g_1756332421
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B7B791800285;
	Wed, 27 Aug 2025 22:07:01 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B7D6F30001A1;
	Wed, 27 Aug 2025 22:06:45 +0000 (UTC)
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
Subject: [PATCH v1 17/36] mm/pagewalk: drop nth_page() usage within folio in folio_walk_start()
Date: Thu, 28 Aug 2025 00:01:21 +0200
Message-ID: <20250827220141.262669-18-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Stat-Signature: 7h433o7nj3s859enw6sbzc8zp9uxro6x
X-Rspam-User: 
X-Rspamd-Queue-Id: B7C29120006
X-Rspamd-Server: rspam01
X-HE-Tag: 1756332430-581095
X-HE-Meta: U2FsdGVkX1/00at8QRNqR4G/VhHS+hHSA8AcWcfufCGAYmQj9ruMBsJmzgVUCe34iE46wiIUh2HNm8TLGCrDhL0jEE92FxfuS287lhaKF9jY2ehnwOPUgDBInKvp4qf7gT2eHbT3mL1+fhJw3Vslmllwxh/51/zK0bjHvG1k1cnq2pHWgonERsoM4vZP9v4sDwfeLE5G25MzAllz5+z/8c7wgRe3UDbdEf7cgX6KGbZyxPk0sCRk/76k0/fLfz93l0Dc0oe1Qe+aQx0JyeVvWU4ecjF4A52AYh5KY09WQPjD78UQFNYSevq8SGYB2N2VL2C0WePBitqrmsCMGyrzxLz/amQXL1TQpmcKAZg4iU1ojvwX4r7OvufTJiZ9kcpuXdVyv7NUnfSHotCNOXX5Czr+/xGmqL+E2hd0cLc1MSoAEDxTFSL131wUuaEVHXxYfRujMR4o2WLTehVEpmQIlhOpaPl5+19eKNl1OC+z6XZRDSy5XFVPV0FTLSO+q4H2bIFuFDhLa7eemVBhaa3SzqEKYR2VO56p1SJK/1D8hkOA/pPcsFKIml84ieLb+OmLcI0jCv0uZ8fnHlFNyP03SZ3cyQcTzlHGY+2XElTbf6pDnxaVrQnf3sLDl8mBlYknoWkKbvG/Lt9Reji5Rt8YawoRUgDIbfJcbKFCrZM05gxyGpeppCQtLHOIKxpr/BrmNIWktPlP3ecbpWg/XDswSBw9thSVC24AC2coaGAtL1N7Q7BOzga7HZINOAEU7IJcWbJu2uq7Smdfandky3W1ApeMEVx0yFTpUYBTpxu0uGzvsEd2Hv4I1zKF83nm7ocTfEOAlyXABHA/4bC4h5pBJxE9i6vP0sYMW5iZXFE3c+JgQe83PK/Hf0q+59Yd0uPpbdZ3c+X2DgC9roGmtuEAnDrU9TA0Vf8xVls5IPJir25UGGPV+8BfdkqCQchm0UsYczEMJKHDRR3qNNfDi+L
 bjcR3MNg
 Ixa1wTOzxrYBBdCziC6mN1zbSNzSJeYwawP25tAvI1ZGJWOZ21/Rr+Ukeo5QPDQxdJfaqvSqsEdDaml6rGULR9FiWZSEJ0wAx2KA57MjCb5BWAxCILzS9OXPbnnkhuKDOMswP05eDEwwMq3eVet2i8VGLESco9+SdzSthxr/seZ6XMomwELwiG2QWYRzYV0g9j1nLtmn2uIuzRFWWMlCA+qolES6FcTzSpHPb/7VhG7ajTYUDMMI9s8OwFoOlbUrwXjum3rBurW31TBwLQ6xZHKLHAGjQHXzxSwpevxbPm6cw58iiR6hGSDkWYPgKka9AqViF8NGJ0yX4MwREmPCseGasZK71kuHras4dS/dwKMdg5y1I7DF5/lDhyC+0xOqH8Z5z2cHOO2YtqHihqcRG5kpBU2IE+kGL00AnPcZ105XpVZ63sRKj9fNb9FbQIWS2eiBc+W3jLVtXPPsVWj3T8CxwgwcrdRM93hWGt0qJkqbOb+jULPGF1W3sFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's no longer required to use nth_page() within a folio, so let's just
drop the nth_page() in folio_walk_start().

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


